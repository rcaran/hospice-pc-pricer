package com.cms.hospice.pricing;

import com.cms.hospice.model.FiscalYearRates;
import com.cms.hospice.model.HospiceClaim;
import com.cms.hospice.model.RhcSplitResult;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 * Computes the Routine Home Care (RHC) 60-day HIGH/LOW rate split introduced
 * in FY2016.1 (January 1, 2016 release, CR #9289).
 *
 * Logic mirrors COBOL paragraphs V161-EVAL-RHC-DAYS,
 * V161-APPLY-HIGH-RHC-RATE, V161-APPLY-LOW-RHC-RATE.
 *
 * Prior service days formula (V161-CALC-PRIOR-SVC-DAYS):
 * days_between = DOS – ADMISSION_DATE (integer day difference)
 * prior_benefit_days = BILL-NA-ADD-ON-DAY1-UNITS (if > 0)
 * PRIOR-SVC-DAYS = days_between + prior_benefit_days
 *
 * Rate selection:
 * PRIOR-SVC-DAYS >= 60 → ALL units at LOW rate
 * PRIOR-SVC-DAYS < 60 → units up to (60 - prior_svc_days) at HIGH rate,
 * any remaining units at LOW rate
 */
public final class RhcSplitCalculator {

    private RhcSplitCalculator() {
    }

    /**
     * Calculates the RHC payment applying the 60-day HIGH/LOW rate split.
     *
     * @param rates         FY rates (must have has60DaySplit = true)
     * @param claim         the hospice claim
     * @param dateOfService the RHC line-item date of service
     * @param units         number of RHC units (days)
     * @param qip           whether QIP reduction applies
     * @return split result with high/low day counts and payment amounts
     */
    public static RhcSplitResult calculate(FiscalYearRates rates, HospiceClaim claim,
            LocalDate dateOfService, int units, boolean qip) {
        int priorSvcDays = computePriorSvcDays(claim, dateOfService);

        if (priorSvcDays >= 60) {
            // All days at LOW rate
            BigDecimal lowPay = PaymentCalculator.perDiem(
                    rates.effectiveRhcLowLs(qip), rates.effectiveRhcLowNls(qip),
                    claim.beneficiaryWageIndex(), units);
            return new RhcSplitResult(0, units, BigDecimal.ZERO, lowPay, lowPay);
        }

        int highRateDaysLeft = 60 - priorSvcDays;

        if (units <= highRateDaysLeft) {
            // All days at HIGH rate
            BigDecimal highPay = PaymentCalculator.perDiem(
                    rates.effectiveRhcHighLs(qip), rates.effectiveRhcHighNls(qip),
                    claim.beneficiaryWageIndex(), units);
            return new RhcSplitResult(units, 0, highPay, BigDecimal.ZERO, highPay);
        }

        // Split: some HIGH, rest LOW
        int highUnits = highRateDaysLeft;
        int lowUnits = units - highUnits;

        BigDecimal highPay = PaymentCalculator.perDiem(
                rates.effectiveRhcHighLs(qip), rates.effectiveRhcHighNls(qip),
                claim.beneficiaryWageIndex(), highUnits);
        BigDecimal lowPay = PaymentCalculator.perDiem(
                rates.effectiveRhcLowLs(qip), rates.effectiveRhcLowNls(qip),
                claim.beneficiaryWageIndex(), lowUnits);

        return new RhcSplitResult(highUnits, lowUnits, highPay, lowPay,
                highPay.add(lowPay));
    }

    /**
     * Computes PRIOR-SVC-DAYS matching COBOL V161-CALC-PRIOR-SVC-DAYS.
     *
     * COBOL uses FUNCTION INTEGER-OF-DATE (Gregorian day count from a fixed
     * epoch). Java's ChronoUnit.DAYS.between produces an equivalent integer
     * difference between two LocalDate values.
     */
    static int computePriorSvcDays(HospiceClaim claim, LocalDate dateOfService) {
        long daysBetween = ChronoUnit.DAYS.between(claim.admissionDate(), dateOfService);
        int priorBenefitDays = (claim.priorBenefitDays() > 0) ? claim.priorBenefitDays() : 0;
        return (int) daysBetween + priorBenefitDays;
    }
}
