package com.cms.hospice.pricing;

import com.cms.hospice.model.*;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * FY2016.1 (Jan 2016+) – FY2021 pricing strategy.
 *
 * Key additions over ModernPricerStrategy:
 * - 60-day RHC HIGH/LOW rate split for revenue code 0651
 * - CHC < 32 units: single-day payment uses HIGH or LOW RHC rate based on
 * prior service days (same 60-day boundary logic as RHC)
 * - EOL SIA (Service Intensity Add-on) for up to 7 days
 * - New return codes: 73, 74, 75, 77 (instead of 00)
 * 73: ALL days LOW rate, no SIA
 * 74: ALL days LOW rate, with SIA
 * 75: SOME/ALL days HIGH rate, no SIA
 * 77: SOME/ALL days HIGH rate, with SIA
 *
 * Covers fiscalYears: FY2016_1, FY2017, FY2018, FY2019, FY2020, FY2021.
 */
@Component("fullPricerStrategy")
public class FullPricerStrategy implements FiscalYearStrategy {

    @Override
    public PricingResult calculate(HospiceClaim claim, FiscalYearRates rates) {
        if (anyUnitOver1000(claim)) {
            return PricingResult.error(ReturnCode.ERROR_10);
        }

        boolean qip = claim.isQip();

        BigDecimal pay1 = BigDecimal.ZERO;
        BigDecimal pay2 = BigDecimal.ZERO;
        BigDecimal pay3 = BigDecimal.ZERO;
        BigDecimal pay4 = BigDecimal.ZERO;

        boolean hasHighDays = false;
        boolean hasLowDays = false;
        int highDaysCount = 0;
        int lowDaysCount = 0;

        // ── RHC (0651) ──────────────────────────────────────────────────────
        RevenueLineItem li1 = claim.lineItem1();
        if (li1 != null && li1.isRhc() && li1.units() > 0
                && li1.dateOfService() != null
                && !li1.dateOfService().isBefore(claim.admissionDate())) {

            RhcSplitResult split = RhcSplitCalculator.calculate(
                    rates, claim, li1.dateOfService(), li1.units(), qip);
            pay1 = split.totalPayment();
            if (split.hasHighDays()) {
                hasHighDays = true;
                highDaysCount += split.highDays();
            }
            if (split.hasLowDays()) {
                hasLowDays = true;
                lowDaysCount += split.lowDays();
            }
        }

        // ── CHC (0652) ───────────────────────────────────────────────────────
        RevenueLineItem li2 = claim.lineItem2();
        if (li2 != null && li2.isChc() && li2.units() > 0) {
            if (li2.units() < 32) {
                // Single-day RHC rate — respects 60-day split boundary
                LocalDate dos2 = li2.dateOfService();
                int priorSvcDays = (dos2 != null)
                        ? RhcSplitCalculator.computePriorSvcDays(claim, dos2)
                        : 0;

                if (priorSvcDays < 60) {
                    pay2 = PaymentCalculator.perDiem(
                            rates.effectiveRhcHighLs(qip), rates.effectiveRhcHighNls(qip),
                            claim.beneficiaryWageIndex(), 1);
                    hasHighDays = true;
                    highDaysCount++;
                } else {
                    pay2 = PaymentCalculator.perDiem(
                            rates.effectiveRhcLowLs(qip), rates.effectiveRhcLowNls(qip),
                            claim.beneficiaryWageIndex(), 1);
                    hasLowDays = true;
                    lowDaysCount++;
                }
            } else {
                pay2 = PaymentCalculator.chcFromQuarters(
                        rates.effectiveChcLs(qip), rates.effectiveChcNls(qip),
                        claim.beneficiaryWageIndex(), li2.units());
            }
        }

        // ── IRC (0655) ───────────────────────────────────────────────────────
        RevenueLineItem li3 = claim.lineItem3();
        if (li3 != null && li3.isIrc() && li3.units() > 0) {
            pay3 = PaymentCalculator.perDiem(
                    rates.effectiveIrcLs(qip), rates.effectiveIrcNls(qip),
                    claim.providerWageIndex(), li3.units());
        }

        // ── GIC (0656) ───────────────────────────────────────────────────────
        RevenueLineItem li4 = claim.lineItem4();
        if (li4 != null && li4.isGic() && li4.units() > 0) {
            pay4 = PaymentCalculator.perDiem(
                    rates.effectiveGicLs(qip), rates.effectiveGicNls(qip),
                    claim.providerWageIndex(), li4.units());
        }

        // ── SIA add-on ───────────────────────────────────────────────────────
        SiaResult sia = SiaResult.none();
        if (rates.hasSia()) {
            sia = SiaCalculator.calculate(rates, claim.beneficiaryWageIndex(),
                    claim.safeEolDayUnits(), qip);
        }

        BigDecimal total = pay1.add(pay2).add(pay3).add(pay4).add(sia.totalPayment());

        // ── Return code determination ─────────────────────────────────────
        // When RHC or low-unit CHC days are present, set an informational RTC.
        // If neither high nor low RHC day indicator was set, use SUCCESS_00.
        ReturnCode rtc;
        if (!hasHighDays && !hasLowDays) {
            rtc = ReturnCode.SUCCESS_00;
        } else if (sia.hasSia()) {
            rtc = hasHighDays ? ReturnCode.SUCCESS_77 : ReturnCode.SUCCESS_74;
        } else {
            rtc = hasHighDays ? ReturnCode.SUCCESS_75 : ReturnCode.SUCCESS_73;
        }

        BigDecimal[] eolPays = sia.dayPayments() != null ? sia.dayPayments() : new BigDecimal[7];

        return new PricingResult(
                pay1, pay2, pay3, pay4, total, rtc.getCode(),
                highDaysCount, lowDaysCount,
                eolPays,
                BigDecimal.ZERO, BigDecimal.ZERO);
    }

    private boolean anyUnitOver1000(HospiceClaim claim) {
        return unitOver1000(claim.lineItem1())
                || unitOver1000(claim.lineItem2())
                || unitOver1000(claim.lineItem3())
                || unitOver1000(claim.lineItem4());
    }

    private boolean unitOver1000(RevenueLineItem li) {
        return li != null && li.units() > 1000;
    }
}
