package com.cms.hospice.pricing;

import com.cms.hospice.model.FiscalYearRates;
import com.cms.hospice.model.SiaResult;

import java.math.BigDecimal;

/**
 * Computes the End-of-Life Service Intensity Add-on (SIA) payment introduced
 * in FY2016.1.
 *
 * Logic mirrors COBOL paragraph V161-CALC-RHC-EOL-SIA.
 *
 * Rules:
 * - SIA rate = ROUNDED( ((chcLs * beneWI + chcNls) / 24) ) — hourly CHC rate
 * - For each of up to 7 EOL days:
 * If eolUnits >= 16 → cap hours at 4 (equals 4 × 15min blocks = 1 hr cap from 4
 * hrs)
 * If eolUnits < 16 → hours = ROUNDED(eolUnits / 4)
 * dayPayment[i] = ROUNDED(hours[i] * siaRate)
 * - totalPayment = sum of dayPayments
 *
 * The SIA indicator and return code determination is handled by the strategy.
 */
public final class SiaCalculator {

    private SiaCalculator() {
    }

    /**
     * Calculates the EOL SIA add-on for up to 7 days.
     *
     * @param rates    FY rates
     * @param beneWI   beneficiary wage index
     * @param eolUnits int[7] of 15-minute EOL add-on units per day (may be null or
     *                 shorter than 7)
     * @param qip      whether QIP reduction applies to the CHC rate
     * @return SiaResult with per-day payments and total; hasSia = true if any
     *         units > 0
     */
    public static SiaResult calculate(FiscalYearRates rates, BigDecimal beneWI,
            int[] eolUnits, boolean qip) {
        int[] units = safeArray(eolUnits);

        boolean hasAnyUnits = false;
        for (int u : units) {
            if (u > 0) {
                hasAnyUnits = true;
                break;
            }
        }
        if (!hasAnyUnits) {
            return SiaResult.none();
        }

        BigDecimal siaRate = PaymentCalculator.siaHourlyRate(
                rates.effectiveChcLs(qip), rates.effectiveChcNls(qip), beneWI);

        BigDecimal[] dayPayments = new BigDecimal[7];
        BigDecimal total = BigDecimal.ZERO;

        for (int i = 0; i < 7; i++) {
            if (units[i] > 0) {
                BigDecimal hours = PaymentCalculator.eolUnitsToHours(units[i]);
                BigDecimal dayPay = hours.multiply(siaRate)
                        .setScale(PaymentCalculator.MONEY_SCALE, PaymentCalculator.ROUNDING);
                dayPayments[i] = dayPay;
                total = total.add(dayPay);
            } else {
                dayPayments[i] = BigDecimal.ZERO;
            }
        }

        return new SiaResult(dayPayments, total, true);
    }

    private static int[] safeArray(int[] raw) {
        int[] result = new int[7];
        if (raw != null) {
            System.arraycopy(raw, 0, result, 0, Math.min(raw.length, 7));
        }
        return result;
    }
}
