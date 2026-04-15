package com.cms.hospice.pricing;

import com.cms.hospice.model.SiaResult;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static com.cms.hospice.pricing.TestFixtures.*;
import static org.assertj.core.api.Assertions.assertThat;

/**
 * Unit tests for SiaCalculator.
 *
 * SIA hourly rate (WI=1.0000):
 * ((984.21 * 1.0) + 448.20) / 24 = 1432.41 / 24 = 59.68 (rounded 2dp)
 */
class SiaCalculatorTest {

    private static final BigDecimal WI_1 = new BigDecimal("1.0000");
    // SIA rate at WI=1.0: 59.68
    private static final BigDecimal SIA_RATE = new BigDecimal("59.68");

    // ── no SIA when all units zero ────────────────────────────────────────────

    @Test
    void returnsNone_whenAllUnitsZero() {
        SiaResult result = SiaCalculator.calculate(fy2021(), WI_1, new int[7], false);

        assertThat(result.hasSia()).isFalse();
        assertThat(result.totalPayment()).isEqualByComparingTo("0.00");
    }

    @Test
    void returnsNone_whenNullArray() {
        SiaResult result = SiaCalculator.calculate(fy2021(), WI_1, null, false);
        assertThat(result.hasSia()).isFalse();
    }

    // ── basic single-day SIA ─────────────────────────────────────────────────

    @Test
    void singleDay_8units_gives2hours_times_siaRate() {
        // day1=8 → 8/4=2.00 hours → 2.00 * 59.68 = 119.36
        int[] eol = { 8, 0, 0, 0, 0, 0, 0 };
        SiaResult result = SiaCalculator.calculate(fy2021(), WI_1, eol, false);

        assertThat(result.hasSia()).isTrue();
        assertThat(result.dayPayments()[0]).isEqualByComparingTo(SIA_RATE.multiply(new BigDecimal("2.00")));
        assertThat(result.totalPayment()).isEqualByComparingTo(SIA_RATE.multiply(new BigDecimal("2.00")));
    }

    @Test
    void singleDay_12units_gives3hours() {
        // 12/4 = 3.00 hours → 3.00 * 59.68 = 179.04
        int[] eol = { 12, 0, 0, 0, 0, 0, 0 };
        SiaResult result = SiaCalculator.calculate(fy2021(), WI_1, eol, false);

        assertThat(result.dayPayments()[0]).isEqualByComparingTo("179.04");
        assertThat(result.totalPayment()).isEqualByComparingTo("179.04");
    }

    // ── cap at 16 units (4 hours) ─────────────────────────────────────────────

    @Test
    void singleDay_20units_cappedAt4hours() {
        // 20 >= 16 → cap to 4 hours → 4 * 59.68 = 238.72
        int[] eol = { 20, 0, 0, 0, 0, 0, 0 };
        SiaResult result = SiaCalculator.calculate(fy2021(), WI_1, eol, false);

        assertThat(result.dayPayments()[0]).isEqualByComparingTo("238.72");
    }

    @Test
    void singleDay_exactly16units_cappedAt4hours() {
        // 16 >= 16 → cap → 4 * 59.68 = 238.72
        int[] eol = { 16, 0, 0, 0, 0, 0, 0 };
        SiaResult result = SiaCalculator.calculate(fy2021(), WI_1, eol, false);

        assertThat(result.dayPayments()[0]).isEqualByComparingTo("238.72");
    }

    // ── multiple days ─────────────────────────────────────────────────────────

    @Test
    void twoDays_8and12units() {
        // day1: 2h * 59.68 = 119.36
        // day2: 3h * 59.68 = 179.04
        // total = 298.40
        int[] eol = { 8, 12, 0, 0, 0, 0, 0 };
        SiaResult result = SiaCalculator.calculate(fy2021(), WI_1, eol, false);

        assertThat(result.dayPayments()[0]).isEqualByComparingTo("119.36");
        assertThat(result.dayPayments()[1]).isEqualByComparingTo("179.04");
        assertThat(result.dayPayments()[2]).isEqualByComparingTo("0.00");
        assertThat(result.totalPayment()).isEqualByComparingTo("298.40");
    }

    @Test
    void allSevenDays_8unitsEach() {
        // Each day: 2h * 59.68 = 119.36; total = 7 * 119.36 = 835.52
        int[] eol = { 8, 8, 8, 8, 8, 8, 8 };
        SiaResult result = SiaCalculator.calculate(fy2021(), WI_1, eol, false);

        assertThat(result.hasSia()).isTrue();
        assertThat(result.totalPayment()).isEqualByComparingTo("835.52");
        for (int i = 0; i < 7; i++) {
            assertThat(result.dayPayments()[i]).isEqualByComparingTo("119.36");
        }
    }

    // ── QIP reduces CHC rate ──────────────────────────────────────────────────

    @Test
    void qip_reducesChcRateUsedForSia() {
        // QIP CHC rates: LS=964.99, NLS=439.45
        // SIA rate = (964.99 + 439.45) / 24 = 1404.44 / 24 = 58.52 (rounded 2dp)
        // day1=8 → 2h * 58.52 = 117.04
        int[] eol = { 8, 0, 0, 0, 0, 0, 0 };
        SiaResult result = SiaCalculator.calculate(fy2021(), WI_1, eol, true);

        assertThat(result.dayPayments()[0]).isEqualByComparingTo("117.04");
    }

    // ── short array handled gracefully ────────────────────────────────────────

    @Test
    void shortArray_treatedAsTrailingZeros() {
        int[] eol = { 8, 12 }; // only 2 of 7
        SiaResult result = SiaCalculator.calculate(fy2021(), WI_1, eol, false);

        assertThat(result.totalPayment()).isEqualByComparingTo("298.40");
        // days 3-7 should be zero
        for (int i = 2; i < 7; i++) {
            assertThat(result.dayPayments()[i]).isEqualByComparingTo("0.00");
        }
    }
}
