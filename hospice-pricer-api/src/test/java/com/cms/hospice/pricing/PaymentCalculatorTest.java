package com.cms.hospice.pricing;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import java.math.BigDecimal;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Unit tests for PaymentCalculator.
 *
 * All expected values are computed by hand using the stated formulas,
 * then verified against COBOL-documented examples where available.
 *
 * Formula references (HOSPR210/HOSDR210):
 * perDiem: ((ls * wi) + nls) * units → ROUNDED 2dp
 * chcHourly: ((ls * wi) + nls) / 24 * hours → ROUNDED 2dp
 * chcFromQuarters: ((ls * wi) + nls) / 24 * (q/4) → ROUNDED 2dp
 * siaHourlyRate: ((ls * wi) + nls) / 24 → ROUNDED 2dp
 * eolUnitsToHours: q/4 (capped at 4 if q >= 16) → ROUNDED 2dp
 */
class PaymentCalculatorTest {

    private static final BigDecimal WI_1 = new BigDecimal("1.0000");
    private static final BigDecimal WI_115 = new BigDecimal("1.1500");
    private static final BigDecimal WI_085 = new BigDecimal("0.8500");

    // ── FY2021 rates (from fy2021.yaml) ─────────────────────────────────────
    private static final BigDecimal RHC_HIGH_LS = new BigDecimal("136.90");
    private static final BigDecimal RHC_HIGH_NLS = new BigDecimal("62.35");
    private static final BigDecimal RHC_LOW_LS = new BigDecimal("108.21");
    private static final BigDecimal RHC_LOW_NLS = new BigDecimal("49.28");
    private static final BigDecimal CHC_LS = new BigDecimal("984.21");
    private static final BigDecimal CHC_NLS = new BigDecimal("448.20");
    private static final BigDecimal IRC_LS = new BigDecimal("249.59");
    private static final BigDecimal IRC_NLS = new BigDecimal("211.50");
    private static final BigDecimal GIC_LS = new BigDecimal("669.33");
    private static final BigDecimal GIC_NLS = new BigDecimal("376.33");

    // ── perDiem ──────────────────────────────────────────────────────────────

    @Test
    void perDiem_rhcHighWi1_10units() {
        // ((136.90 * 1.0000) + 62.35) * 10 = 199.25 * 10 = 1992.50
        BigDecimal result = PaymentCalculator.perDiem(RHC_HIGH_LS, RHC_HIGH_NLS, WI_1, 10);
        assertThat(result).isEqualByComparingTo("1992.50");
    }

    @Test
    void perDiem_rhcHighWi115_5units() {
        // ((136.90 * 1.15) + 62.35) * 5 = (157.435 + 62.35) * 5 = 219.785 * 5 =
        // 1098.925 → 1098.93
        BigDecimal result = PaymentCalculator.perDiem(RHC_HIGH_LS, RHC_HIGH_NLS, WI_115, 5);
        assertThat(result).isEqualByComparingTo("1098.93");
    }

    @Test
    void perDiem_rhcLowWi1_5units() {
        // ((108.21 * 1.0000) + 49.28) * 5 = 157.49 * 5 = 787.45
        BigDecimal result = PaymentCalculator.perDiem(RHC_LOW_LS, RHC_LOW_NLS, WI_1, 5);
        assertThat(result).isEqualByComparingTo("787.45");
    }

    @Test
    void perDiem_ircWi085_3units() {
        // ((249.59 * 0.85) + 211.50) * 3 = (212.1515 + 211.50) * 3 = 423.6515 * 3 =
        // 1270.9545 → 1270.95
        BigDecimal result = PaymentCalculator.perDiem(IRC_LS, IRC_NLS, WI_085, 3);
        assertThat(result).isEqualByComparingTo("1270.95");
    }

    @Test
    void perDiem_gicWi1_3units() {
        // ((669.33 * 1.0000) + 376.33) * 3 = 1045.66 * 3 = 3136.98
        BigDecimal result = PaymentCalculator.perDiem(GIC_LS, GIC_NLS, WI_1, 3);
        assertThat(result).isEqualByComparingTo("3136.98");
    }

    @Test
    void perDiem_zeroUnits_returnsZero() {
        BigDecimal result = PaymentCalculator.perDiem(RHC_HIGH_LS, RHC_HIGH_NLS, WI_1, 0);
        assertThat(result).isEqualByComparingTo("0.00");
    }

    @ParameterizedTest
    @CsvSource({
            "1,    199.25",
            "30, 5977.50",
    })
    void perDiem_rhcHighWi1_variousUnits(int units, String expected) {
        BigDecimal result = PaymentCalculator.perDiem(RHC_HIGH_LS, RHC_HIGH_NLS, WI_1, units);
        assertThat(result).isEqualByComparingTo(expected);
    }

    // ── chcHourly ────────────────────────────────────────────────────────────

    @Test
    void chcHourly_wi1_8hours() {
        // ((984.21 * 1.0) + 448.20) / 24 * 8 = 1432.41 / 24 * 8 = 59.6837... * 8 =
        // 477.47
        BigDecimal result = PaymentCalculator.chcHourly(CHC_LS, CHC_NLS, WI_1, 8);
        assertThat(result).isEqualByComparingTo("477.47");
    }

    @Test
    void chcHourly_wi085_24hours() {
        // ((984.21 * 0.85) + 448.20) / 24 * 24 = (836.5785 + 448.20) / 24 * 24
        // = 1284.7785 (daily rate) * 1 = 1284.78
        BigDecimal result = PaymentCalculator.chcHourly(CHC_LS, CHC_NLS, WI_085, 24);
        assertThat(result).isEqualByComparingTo("1284.78");
    }

    // ── chcFromQuarters ──────────────────────────────────────────────────────

    @Test
    void chcFromQuarters_wi1_40units() {
        // ((984.21 + 448.20) / 24) * (40/4) = (1432.41/24) * 10
        // = 59.6837... * 10 = 596.84 (rounded)
        BigDecimal result = PaymentCalculator.chcFromQuarters(CHC_LS, CHC_NLS, WI_1, 40);
        assertThat(result).isEqualByComparingTo("596.84");
    }

    @Test
    void chcFromQuarters_wi1_32units_boundary() {
        // (1432.41/24) * (32/4) = 59.6837... * 8 = 477.47
        BigDecimal result = PaymentCalculator.chcFromQuarters(CHC_LS, CHC_NLS, WI_1, 32);
        assertThat(result).isEqualByComparingTo("477.47");
    }

    // ── siaHourlyRate ────────────────────────────────────────────────────────

    @Test
    void siaHourlyRate_wi1() {
        // ((984.21 * 1.0) + 448.20) / 24 = 1432.41 / 24 = 59.68 (rounded 2dp)
        BigDecimal rate = PaymentCalculator.siaHourlyRate(CHC_LS, CHC_NLS, WI_1);
        assertThat(rate).isEqualByComparingTo("59.68");
    }

    @Test
    void siaHourlyRate_wi115() {
        // ((984.21 * 1.15) + 448.20) / 24 = (1131.8415 + 448.20) / 24
        // = 1580.0415 / 24 = 65.8350... → 65.84
        BigDecimal rate = PaymentCalculator.siaHourlyRate(CHC_LS, CHC_NLS, WI_115);
        assertThat(rate).isEqualByComparingTo("65.84");
    }

    // ── eolUnitsToHours ──────────────────────────────────────────────────────

    @Test
    void eolUnitsToHours_below16_returnsQuarterFraction() {
        // 8 units → 8/4 = 2.00 hours
        assertThat(PaymentCalculator.eolUnitsToHours(8)).isEqualByComparingTo("2.00");
        // 15 units → 15/4 = 3.75 hours
        assertThat(PaymentCalculator.eolUnitsToHours(15)).isEqualByComparingTo("3.75");
    }

    @Test
    void eolUnitsToHours_exactly16_cappedAt4() {
        assertThat(PaymentCalculator.eolUnitsToHours(16)).isEqualByComparingTo("4.00");
    }

    @Test
    void eolUnitsToHours_above16_stillCappedAt4() {
        assertThat(PaymentCalculator.eolUnitsToHours(20)).isEqualByComparingTo("4.00");
        assertThat(PaymentCalculator.eolUnitsToHours(99)).isEqualByComparingTo("4.00");
    }

    @Test
    void eolUnitsToHours_zero_returnsZero() {
        assertThat(PaymentCalculator.eolUnitsToHours(0)).isEqualByComparingTo("0.00");
    }
}
