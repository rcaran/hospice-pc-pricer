package com.cms.hospice.pricing;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * Core payment arithmetic matching COBOL COMPUTE ... ROUNDED behaviour.
 *
 * COBOL ROUNDED uses HALF_UP and the result precision is determined by the
 * output PIC clause: WRK-PAY-RATE1 PIC 9(06)V9(02) → 2 decimal places.
 * All monetary results are rounded to 2 decimal places with HALF_UP.
 */
public final class PaymentCalculator {

    /** Monetary scale: 2 decimal places, HALF_UP (same as COBOL ROUNDED). */
    static final int MONEY_SCALE = 2;
    static final RoundingMode ROUNDING = RoundingMode.HALF_UP;

    private static final BigDecimal TWENTY_FOUR = new BigDecimal("24");
    private static final BigDecimal FOUR = new BigDecimal("4");

    private PaymentCalculator() {
    }

    /**
     * Per-diem payment formula used by RHC (single rate), IRC, and GIC.
     *
     * COMPUTE WRK-PAY-RATE ROUNDED = ((ls * wageIndex) + nls) * units
     *
     * @param ls        labor-share rate
     * @param nls       non-labor-share rate
     * @param wageIndex wage index for the care type
     * @param units     number of service units (days)
     * @return rounded monetary amount
     */
    public static BigDecimal perDiem(BigDecimal ls, BigDecimal nls,
            BigDecimal wageIndex, int units) {
        // ((ls * wageIndex) + nls) * units
        BigDecimal rate = ls.multiply(wageIndex).add(nls);
        return rate.multiply(BigDecimal.valueOf(units))
                .setScale(MONEY_SCALE, ROUNDING);
    }

    /**
     * CHC hourly-rate payment formula (FY1998–FY2007, where UNITS are in full
     * hours).
     *
     * COMPUTE WRK-PAY-RATE ROUNDED =
     * (((chcLs * beneWI) + chcNls) / 24) * units
     *
     * @param ls        CHC labor-share rate
     * @param nls       CHC non-labor-share rate
     * @param wageIndex beneficiary wage index
     * @param hours     number of hours (integer units)
     * @return rounded monetary amount
     */
    public static BigDecimal chcHourly(BigDecimal ls, BigDecimal nls,
            BigDecimal wageIndex, int hours) {
        BigDecimal dailyRate = ls.multiply(wageIndex).add(nls);
        BigDecimal hourlyRate = dailyRate.divide(TWENTY_FOUR, 10, ROUNDING);
        return hourlyRate.multiply(BigDecimal.valueOf(hours))
                .setScale(MONEY_SCALE, ROUNDING);
    }

    /**
     * CHC 15-minute-unit payment formula (FY2007.1+, where UNITS are
     * quarter-hours).
     *
     * COMPUTE WRK-PAY-RATE ROUNDED =
     * (((chcLs * beneWI) + chcNls) / 24) * (units / 4)
     *
     * @param ls           CHC labor-share rate
     * @param nls          CHC non-labor-share rate
     * @param wageIndex    beneficiary wage index
     * @param quarterUnits number of 15-minute units
     * @return rounded monetary amount
     */
    public static BigDecimal chcFromQuarters(BigDecimal ls, BigDecimal nls,
            BigDecimal wageIndex, int quarterUnits) {
        BigDecimal dailyRate = ls.multiply(wageIndex).add(nls);
        BigDecimal hourlyRate = dailyRate.divide(TWENTY_FOUR, 10, ROUNDING);
        BigDecimal hours = BigDecimal.valueOf(quarterUnits).divide(FOUR, 10, ROUNDING);
        return hourlyRate.multiply(hours).setScale(MONEY_SCALE, ROUNDING);
    }

    /**
     * Computes the hourly SIA rate (CHC daily rate ÷ 24), rounded to 2dp.
     * This intermediate result is kept at MONEY_SCALE because COBOL rounds it
     * at that point before multiplying by EOL hours.
     *
     * COBOL:
     * COMPUTE SIA-PYMT-RATE ROUNDED = (((chcLs * beneWI) + chcNls) / 24)
     */
    public static BigDecimal siaHourlyRate(BigDecimal ls, BigDecimal nls, BigDecimal wageIndex) {
        BigDecimal dailyRate = ls.multiply(wageIndex).add(nls);
        return dailyRate.divide(TWENTY_FOUR, MONEY_SCALE, ROUNDING);
    }

    /**
     * Converts EOL add-on 15-minute units to hours, capped at 4in accordance
     * with COBOL SIA cap logic:
     * IF EOL-UNITS >= 16 → MOVE 4 TO EOL-HOURS
     * ELSE COMPUTE EOL-HOURS ROUNDED = (EOL-UNITS / 4)
     *
     * @param eolUnits raw 15-minute units
     * @return hours as BigDecimal (at most 4.00)
     */
    public static BigDecimal eolUnitsToHours(int eolUnits) {
        if (eolUnits >= 16) {
            return new BigDecimal("4");
        }
        return BigDecimal.valueOf(eolUnits)
                .divide(FOUR, MONEY_SCALE, ROUNDING);
    }
}
