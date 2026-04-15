package com.cms.hospice.service;

import com.cms.hospice.data.ProviderRepository;
import com.cms.hospice.data.WageIndexRepository;
import com.cms.hospice.model.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Optional;

/**
 * Top-level orchestrator that mirrors the HOSDR210 COBOL batch driver.
 *
 * Processing sequence:
 * 1. Look up provider record (0700-GET-PROVIDER)
 * 2. Determine CBSA vs MSA period and compute FY boundaries
 * 3. Resolve provider and beneficiary wage indexes (0350/0375)
 * 4. Validate the enriched claim (ValidationService)
 * 5. Route to fiscal year strategy and price (FiscalYearRouter)
 */
@Service
public class DriverService {

    private static final Logger log = LoggerFactory.getLogger(DriverService.class);

    /** Claims before this date use MSA wage indexes (pre-CBSA era). */
    private static final LocalDate CBSA_EFFECTIVE_DATE = LocalDate.of(2005, 10, 1);

    /** Before this date the CBSA comes from the provider record, not the claim. */
    private static final LocalDate CBSA_FROM_CLAIM_DATE = LocalDate.of(2008, 1, 1);

    private final ProviderRepository providerRepository;
    private final WageIndexRepository wageIndexRepository;
    private final ValidationService validationService;
    private final FiscalYearRouter fiscalYearRouter;

    public DriverService(ProviderRepository providerRepository,
            WageIndexRepository wageIndexRepository,
            ValidationService validationService,
            FiscalYearRouter fiscalYearRouter) {
        this.providerRepository = providerRepository;
        this.wageIndexRepository = wageIndexRepository;
        this.validationService = validationService;
        this.fiscalYearRouter = fiscalYearRouter;
    }

    /**
     * Prices a single hospice claim.
     *
     * @param inputClaim claim with providerNumber, fromDate, CBSAs, and line
     *                   items populated; wage indexes may be null or zero
     *                   (they are resolved from reference files internally)
     * @return fully populated PricingResult
     */
    public PricingResult price(HospiceClaim inputClaim) {
        LocalDate fromDate = inputClaim.fromDate();
        if (fromDate == null) {
            return PricingResult.error(ReturnCode.ERROR_10);
        }

        // ── 1. Provider lookup ────────────────────────────────────────────
        Optional<ProviderData> provOpt = providerRepository.findByProviderNumber(
                inputClaim.providerNumber(), fromDate);

        if (provOpt.isEmpty()) {
            log.debug("Provider not found: {} date={}", inputClaim.providerNumber(), fromDate);
            return PricingResult.error(ReturnCode.ERROR_51);
        }
        ProviderData provider = provOpt.get();

        // COBOL compatibility check: if provider eff-date < 2005-10-01 and claim >
        // 2005-09-30
        if (provider.effectiveDate() != null
                && provider.effectiveDate().isBefore(LocalDate.of(2005, 10, 1))
                && fromDate.isAfter(LocalDate.of(2005, 9, 30))) {
            return PricingResult.error(ReturnCode.ERROR_51);
        }

        // ── 2. Compute FY boundaries ──────────────────────────────────────
        LocalDate[] fyBounds = computeFyBoundaries(fromDate);
        LocalDate fyBegin = fyBounds[0];
        LocalDate fyEnd = fyBounds[1];

        // ── 3. Resolve wage indexes ───────────────────────────────────────
        BigDecimal provWI;
        BigDecimal beneWI;

        if (fromDate.isAfter(CBSA_EFFECTIVE_DATE.minusDays(1))) {
            // Post-2005: use CBSA table
            String provCbsa = resolveProvCbsa(inputClaim, provider);
            String beneCbsa = inputClaim.beneficiaryCbsa();

            Optional<BigDecimal> provWiOpt = wageIndexRepository.findCbsaWageIndex(
                    provCbsa, fromDate, fyBegin, fyEnd);
            if (provWiOpt.isEmpty()) {
                log.debug("Provider CBSA WI not found: cbsa={}", provCbsa);
                return PricingResult.error(ReturnCode.ERROR_40);
            }
            provWI = provWiOpt.get();

            Optional<BigDecimal> beneWiOpt = wageIndexRepository.findCbsaWageIndex(
                    beneCbsa, fromDate, fyBegin, fyEnd);
            if (beneWiOpt.isEmpty()) {
                log.debug("Beneficiary CBSA WI not found: cbsa={}", beneCbsa);
                return PricingResult.error(ReturnCode.ERROR_50);
            }
            beneWI = beneWiOpt.get();

        } else {
            // Pre-2006: use MSA table
            String provMsa = provider.msaGeoLoc();
            // Bene MSA comes from the claim's BILL-BENE-CBSA field
            // (which redefines the same area in the COBOL record)
            String beneMsa = inputClaim.beneficiaryCbsa();

            Optional<BigDecimal> provWiOpt = wageIndexRepository.findMsaWageIndex(provMsa, fromDate);
            if (provWiOpt.isEmpty()) {
                return PricingResult.error(ReturnCode.ERROR_40);
            }
            provWI = provWiOpt.get();

            Optional<BigDecimal> beneWiOpt = wageIndexRepository.findMsaWageIndex(beneMsa, fromDate);
            if (beneWiOpt.isEmpty()) {
                return PricingResult.error(ReturnCode.ERROR_50);
            }
            beneWI = beneWiOpt.get();
        }

        // ── 4. Enrich claim with resolved wage indexes ────────────────────
        HospiceClaim enrichedClaim = inputClaim.withWageIndexes(provWI, beneWI);

        // ── 5. Validate ───────────────────────────────────────────────────
        PricingResult validationError = validationService.validate(enrichedClaim);
        if (validationError != null) {
            return validationError;
        }

        // ── 6. Route and price ────────────────────────────────────────────
        FiscalYearRouter.FyEntry fyEntry = fiscalYearRouter.resolve(fromDate);
        log.debug("Routing claim date={} to fiscalYear={}", fromDate, fyEntry.fiscalYearId());

        return fyEntry.strategy().calculate(enrichedClaim, fyEntry.rates());
    }

    /**
     * Determines the provider CBSA code to use based on claim date.
     *
     * For claims before 2008-01-01: use provider record's CBSA geo-loc.
     * For claims from 2008-01-01: use claim's BILL-PROV-CBSA.
     */
    private String resolveProvCbsa(HospiceClaim claim, ProviderData provider) {
        if (claim.fromDate().isBefore(CBSA_FROM_CLAIM_DATE)) {
            return provider.cbsaGeoLoc();
        }
        return claim.providerCbsa();
    }

    /**
     * Computes the fiscal year begin/end dates for a given claim FROM-DATE.
     *
     * COBOL logic (FY begins Oct 1):
     * If MM in 01–09: FY-BEGIN = (year-1)-10-01, FY-END = year-09-30
     * If MM in 10–12: FY-BEGIN = year-10-01, FY-END = (year+1)-09-30
     *
     * @return [fyBegin, fyEnd]
     */
    static LocalDate[] computeFyBoundaries(LocalDate fromDate) {
        int month = fromDate.getMonthValue();
        int year = fromDate.getYear();

        if (month >= 1 && month <= 9) {
            return new LocalDate[] {
                    LocalDate.of(year - 1, 10, 1),
                    LocalDate.of(year, 9, 30)
            };
        } else {
            return new LocalDate[] {
                    LocalDate.of(year, 10, 1),
                    LocalDate.of(year + 1, 9, 30)
            };
        }
    }
}
