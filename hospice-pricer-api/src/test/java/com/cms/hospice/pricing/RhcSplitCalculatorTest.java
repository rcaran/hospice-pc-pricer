package com.cms.hospice.pricing;

import com.cms.hospice.model.*;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;

import static com.cms.hospice.pricing.TestFixtures.*;
import static org.assertj.core.api.Assertions.assertThat;

/**
 * Unit tests for RhcSplitCalculator.
 *
 * Test scenarios:
 * A — All days at HIGH rate (priorSvcDays + units <= 60)
 * B — priorSvcDays >= 60 → all days at LOW rate
 * C — SPLIT: some HIGH, rest LOW
 * D — Admission date = claim date (day 0)
 * E — priorBenefitDays contributes to prior count
 */
class RhcSplitCalculatorTest {

    private static final FiscalYearRates RATES = fy2021();

    // ── Scenario A: ALL HIGH ─────────────────────────────────────────────────

    @Test
    void allHigh_whenPriorSvcDays5_units10() {
        // admission 5 days before DOS, no prior days → priorSvcDays = 5
        // highDaysLeft = 55 → 10 <= 55 → ALL HIGH
        LocalDate adm = LocalDate.of(2021, 1, 10);
        LocalDate dos = LocalDate.of(2021, 1, 15);

        HospiceClaim claim = claim("P001", LocalDate.of(2021, 1, 15), adm,
                WI_1, WI_1, 0, " ", rhc(dos, 10), null, null, null);

        RhcSplitResult result = RhcSplitCalculator.calculate(RATES, claim, dos, 10, false);

        assertThat(result.highDays()).isEqualTo(10);
        assertThat(result.lowDays()).isEqualTo(0);
        // ((136.90 * 1.0000) + 62.35) * 10 = 199.25 * 10 = 1992.50
        assertThat(result.highPayment()).isEqualByComparingTo("1992.50");
        assertThat(result.lowPayment()).isEqualByComparingTo("0.00");
        assertThat(result.totalPayment()).isEqualByComparingTo("1992.50");
    }

    @Test
    void allHigh_withPriorBenefitDays_10days_units5() {
        // admission 5 days before DOS; priorBenefitDays = 10
        // priorSvcDays = 5 + 10 = 15; highDaysLeft = 45 → 5 <= 45 → ALL HIGH
        LocalDate adm = LocalDate.of(2021, 1, 10);
        LocalDate dos = LocalDate.of(2021, 1, 15);

        HospiceClaim claim = claim("P001", dos, adm,
                WI_1, WI_1, 10, " ", rhc(dos, 5), null, null, null);

        RhcSplitResult result = RhcSplitCalculator.calculate(RATES, claim, dos, 5, false);

        assertThat(result.highDays()).isEqualTo(5);
        assertThat(result.lowDays()).isEqualTo(0);
        // 199.25 * 5 = 996.25
        assertThat(result.totalPayment()).isEqualByComparingTo("996.25");
    }

    // ── Scenario B: ALL LOW ──────────────────────────────────────────────────

    @Test
    void allLow_whenPriorSvcDaysGte60() {
        // admission 75 days before DOS → priorSvcDays = 75 >= 60 → ALL LOW
        LocalDate adm = LocalDate.of(2020, 10, 1);
        LocalDate dos = LocalDate.of(2021, 1, 15);

        HospiceClaim claim = claim("P001", dos, adm,
                WI_1, WI_1, 0, " ", rhc(dos, 10), null, null, null);

        RhcSplitResult result = RhcSplitCalculator.calculate(RATES, claim, dos, 10, false);

        assertThat(result.highDays()).isEqualTo(0);
        assertThat(result.lowDays()).isEqualTo(10);
        // ((108.21 * 1.0000) + 49.28) * 10 = 157.49 * 10 = 1574.90
        assertThat(result.lowPayment()).isEqualByComparingTo("1574.90");
        assertThat(result.totalPayment()).isEqualByComparingTo("1574.90");
    }

    @Test
    void allLow_exactlyAt60Days() {
        // priorSvcDays = exactly 60 → ALL LOW (boundary)
        LocalDate adm = LocalDate.of(2020, 11, 16);
        LocalDate dos = LocalDate.of(2021, 1, 15); // 60 days after adm

        HospiceClaim claim = claim("P001", dos, adm,
                WI_1, WI_1, 0, " ", rhc(dos, 5), null, null, null);

        RhcSplitResult result = RhcSplitCalculator.calculate(RATES, claim, dos, 5, false);

        assertThat(result.highDays()).isEqualTo(0);
        assertThat(result.lowDays()).isEqualTo(5);
        assertThat(result.lowPayment()).isEqualByComparingTo("787.45");
    }

    // ── Scenario C: SPLIT ────────────────────────────────────────────────────

    @Test
    void split_priorSvcDays55_units10() {
        // From docs TC12: priorSvcDays=55, units=10 → HIGH=5, LOW=5
        // HIGH: 199.25 * 5 = 996.25
        // LOW: 157.49 * 5 = 787.45
        // TOTAL = 1783.70
        LocalDate adm = LocalDate.of(2021, 1, 19);
        LocalDate dos = LocalDate.of(2021, 3, 15); // 55 days after adm

        HospiceClaim claim = claim("P001", dos, adm,
                WI_1, WI_1, 0, " ", rhc(dos, 10), null, null, null);

        RhcSplitResult result = RhcSplitCalculator.calculate(RATES, claim, dos, 10, false);

        assertThat(result.highDays()).isEqualTo(5);
        assertThat(result.lowDays()).isEqualTo(5);
        assertThat(result.highPayment()).isEqualByComparingTo("996.25");
        assertThat(result.lowPayment()).isEqualByComparingTo("787.45");
        assertThat(result.totalPayment()).isEqualByComparingTo("1783.70");
    }

    // ── QIP ──────────────────────────────────────────────────────────────────

    @Test
    void qip_allHigh_usesQipRates() {
        LocalDate adm = LocalDate.of(2021, 1, 10);
        LocalDate dos = LocalDate.of(2021, 1, 15);

        HospiceClaim claim = claim("P001", dos, adm,
                WI_1, WI_1, 0, "1", rhc(dos, 5), null, null, null);

        RhcSplitResult result = RhcSplitCalculator.calculate(RATES, claim, dos, 5, true);

        // QIP HIGH: ((134.23 + 61.13) * 5) = 195.36 * 5 = 976.80
        assertThat(result.highDays()).isEqualTo(5);
        assertThat(result.totalPayment()).isEqualByComparingTo("976.80");
    }

    // ── helper method ─────────────────────────────────────────────────────────

    @Test
    void computePriorSvcDays_includeDaysBetweenAndPriorBenefitDays() {
        LocalDate adm = LocalDate.of(2021, 1, 10);
        LocalDate dos = LocalDate.of(2021, 1, 20); // 10 days after adm

        HospiceClaim claimNoPrior = claim("P001", dos, adm, WI_1, WI_1, 0, " ",
                rhc(dos, 1), null, null, null);
        assertThat(RhcSplitCalculator.computePriorSvcDays(claimNoPrior, dos)).isEqualTo(10);

        HospiceClaim claimWithPrior = claim("P001", dos, adm, WI_1, WI_1, 5, " ",
                rhc(dos, 1), null, null, null);
        assertThat(RhcSplitCalculator.computePriorSvcDays(claimWithPrior, dos)).isEqualTo(15);
    }
}
