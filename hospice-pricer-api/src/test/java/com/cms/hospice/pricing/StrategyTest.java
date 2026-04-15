package com.cms.hospice.pricing;

import com.cms.hospice.model.*;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDate;

import static com.cms.hospice.pricing.TestFixtures.*;
import static org.assertj.core.api.Assertions.assertThat;

/**
 * Unit tests for all four FiscalYearStrategy implementations.
 * These tests bypass DriverService/file loading — wage indexes are set
 * directly.
 */
class StrategyTest {

    private final SimplePricerStrategy simple = new SimplePricerStrategy();
    private final TransitionPricerStrategy transition = new TransitionPricerStrategy();
    private final ModernPricerStrategy modern = new ModernPricerStrategy();
    private final FullPricerStrategy full = new FullPricerStrategy();

    // ── SimplePricerStrategy ─────────────────────────────────────────────────

    @Test
    void simple_rhc_wi1_10units_returnsRtc00() {
        // ((83.81 * 1.0) + 38.17) * 10 = 121.98 * 10 = 1219.80
        LocalDate date = LocalDate.of(2005, 1, 15);
        HospiceClaim claim = claim("P001", date, date, WI_1, WI_1, 0, " ",
                rhc(date, 10), null, null, null);

        PricingResult result = simple.calculate(claim, fy2005());

        assertThat(result.returnCode()).isEqualTo("00");
        assertThat(result.payAmt1()).isEqualByComparingTo("1219.80");
        assertThat(result.payAmountTotal()).isEqualByComparingTo("1219.80");
    }

    @Test
    void simple_chcBelow8units_returnsRtc20() {
        LocalDate date = LocalDate.of(2005, 1, 15);
        HospiceClaim claim = claim("P001", date, date, WI_1, WI_1, 0, " ",
                null, chc(date, 5), null, null);

        PricingResult result = simple.calculate(claim, fy2005());

        assertThat(result.returnCode()).isEqualTo("20");
        assertThat(result.payAmountTotal()).isEqualByComparingTo("0.00");
    }

    @Test
    void simple_unitsOver1000_returnsRtc10() {
        LocalDate date = LocalDate.of(2005, 1, 15);
        HospiceClaim claim = claim("P001", date, date, WI_1, WI_1, 0, " ",
                rhc(date, 1500), null, null, null);

        PricingResult result = simple.calculate(claim, fy2005());

        assertThat(result.returnCode()).isEqualTo("10");
        assertThat(result.payAmountTotal()).isEqualByComparingTo("0.00");
    }

    @Test
    void simple_chcExactly8units_calculatesHourly() {
        // CHC: ((728.14 * 1.0) + 331.77) / 24 * 8 = 1059.91/24 * 8 = 44.16291... * 8 =
        // 353.30
        LocalDate date = LocalDate.of(2005, 1, 15);
        HospiceClaim claim = claim("P001", date, date, WI_1, WI_1, 0, " ",
                null, chc(date, 8), null, null);

        PricingResult result = simple.calculate(claim, fy2005());

        assertThat(result.returnCode()).isEqualTo("00");
        assertThat(result.payAmt2()).isEqualByComparingTo("353.30");
    }

    @Test
    void simple_irc_usesProviderWageIndex() {
        // IRC uses PROV WI, not bene WI
        // ((153.79 * 1.15) + 133.37) * 2 = (176.8585 + 133.37) * 2 = 310.2285 * 2 =
        // 620.46
        LocalDate date = LocalDate.of(2005, 1, 15);
        HospiceClaim claim = claim("P001", date, date, WI_115, WI_1, 0, " ",
                null, null, irc(date, 2), null);

        PricingResult result = simple.calculate(claim, fy2005());

        assertThat(result.payAmt3()).isEqualByComparingTo("620.46");
    }

    // ── TransitionPricerStrategy ─────────────────────────────────────────────

    @Test
    void transition_chcBelow32units_paysSingleRhcDay() {
        // FY2008: CHC with 10 units (<32) → pay 1 RHC day
        FiscalYearRates rates = fy2021(); // using FY2021 rates for simplicity
        LocalDate date = LocalDate.of(2021, 1, 15);
        HospiceClaim claim = claim("P001", date, date, WI_1, WI_1, 0, " ",
                null, chc(date, 10), null, null);

        PricingResult result = transition.calculate(claim, rates);

        assertThat(result.returnCode()).isEqualTo("00");
        // Single RHC day: ((136.90 + 62.35) * 1) = 199.25
        assertThat(result.payAmt2()).isEqualByComparingTo("199.25");
    }

    @Test
    void transition_chc32units_usesChcFormula() {
        FiscalYearRates rates = fy2021();
        LocalDate date = LocalDate.of(2021, 1, 15);
        HospiceClaim claim = claim("P001", date, date, WI_1, WI_1, 0, " ",
                null, chc(date, 32), null, null);

        PricingResult result = transition.calculate(claim, rates);

        // CHC: (1432.41/24) * (32/4) = 59.68*8 = 477.44... → 477.47
        assertThat(result.payAmt2()).isEqualByComparingTo("477.47");
    }

    @Test
    void transition_noQip_evenWhenQipIndicatorSet() {
        // TransitionStrategy has no QIP support — ignores QIP indicator
        LocalDate date = LocalDate.of(2021, 1, 15);
        HospiceClaim noQipClaim = claim("P001", date, date, WI_1, WI_1, 0, " ",
                rhc(date, 5), null, null, null);
        HospiceClaim qipClaim = claim("P001", date, date, WI_1, WI_1, 0, "1",
                rhc(date, 5), null, null, null);

        PricingResult r1 = transition.calculate(noQipClaim, fy2021());
        PricingResult r2 = transition.calculate(qipClaim, fy2021());

        // TransitionStrategy does not use QIP rates — results must be identical
        assertThat(r1.payAmt1()).isEqualByComparingTo(r2.payAmt1());
    }

    // ── ModernPricerStrategy ─────────────────────────────────────────────────

    @Test
    void modern_qip_reducesRhcRate() {
        LocalDate date = LocalDate.of(2021, 1, 15);
        HospiceClaim noQip = claim("P001", date, date, WI_1, WI_1, 0, " ",
                rhc(date, 10), null, null, null);
        HospiceClaim withQip = claim("P001", date, date, WI_1, WI_1, 0, "1",
                rhc(date, 10), null, null, null);

        PricingResult r1 = modern.calculate(noQip, fy2021());
        PricingResult r2 = modern.calculate(withQip, fy2021());

        // QIP payment must be less than standard
        assertThat(r2.payAmt1()).isLessThan(r1.payAmt1());
        // FY2021 QIP RHC HIGH: (134.23 + 61.13) * 10 = 195.36 * 10 = 1953.60
        assertThat(r2.payAmt1()).isEqualByComparingTo("1953.60");
    }

    @Test
    void modern_rtcAlways00() {
        LocalDate date = LocalDate.of(2021, 1, 15);
        HospiceClaim claim = claim("P001", date, date, WI_1, WI_1, 0, " ",
                rhc(date, 5), null, null, null);

        PricingResult result = modern.calculate(claim, fy2021());

        assertThat(result.returnCode()).isEqualTo("00");
    }

    // ── FullPricerStrategy ───────────────────────────────────────────────────

    @Test
    void full_allHigh_noSia_returnsRtc75() {
        // admission close to DOS → all HIGH → no SIA → RTC=75
        LocalDate adm = LocalDate.of(2021, 1, 10);
        LocalDate dos = LocalDate.of(2021, 1, 15);
        HospiceClaim claim = claim("P001", dos, adm, WI_1, WI_1, 0, " ",
                rhc(dos, 10), null, null, null);

        PricingResult result = full.calculate(claim, fy2021());

        assertThat(result.returnCode()).isEqualTo("75");
        assertThat(result.highRhcDays()).isEqualTo(10);
        assertThat(result.lowRhcDays()).isEqualTo(0);
        assertThat(result.payAmt1()).isEqualByComparingTo("1992.50");
    }

    @Test
    void full_allLow_noSia_returnsRtc73() {
        // >60 days since admission → all LOW → RTC=73
        LocalDate adm = LocalDate.of(2020, 10, 1);
        LocalDate dos = LocalDate.of(2021, 1, 15);
        HospiceClaim claim = claim("P001", dos, adm, WI_1, WI_1, 0, " ",
                rhc(dos, 10), null, null, null);

        PricingResult result = full.calculate(claim, fy2021());

        assertThat(result.returnCode()).isEqualTo("73");
        assertThat(result.highRhcDays()).isEqualTo(0);
        assertThat(result.lowRhcDays()).isEqualTo(10);
    }

    @Test
    void full_allHigh_withSia_returnsRtc77() {
        // All HIGH + SIA → RTC=77
        LocalDate adm = LocalDate.of(2021, 1, 10);
        LocalDate dos = LocalDate.of(2021, 1, 15);
        int[] eol = { 8, 12, 0, 0, 0, 0, 0 };

        HospiceClaim claim = new HospiceClaim(
                "1234567890", "P001", dos, adm,
                "16740", "16740",
                WI_1, WI_1,
                0, 0, eol, " ",
                rhc(dos, 5), null, null, null);

        PricingResult result = full.calculate(claim, fy2021());

        assertThat(result.returnCode()).isEqualTo("77");
        assertThat(result.highRhcDays()).isEqualTo(5);
        // SIA: day1=2h*59.68=119.36, day2=3h*59.68=179.04 → total SIA=298.40
        BigDecimal expectedTotal = new BigDecimal("996.25").add(new BigDecimal("298.40")); // 1294.65
        assertThat(result.payAmountTotal()).isEqualByComparingTo(expectedTotal);
    }

    @Test
    void full_allLow_withSia_returnsRtc74() {
        LocalDate adm = LocalDate.of(2020, 10, 1);
        LocalDate dos = LocalDate.of(2021, 1, 15);
        int[] eol = { 8, 0, 0, 0, 0, 0, 0 };

        HospiceClaim claim = new HospiceClaim(
                "1234567890", "P001", dos, adm,
                "16740", "16740",
                WI_1, WI_1,
                0, 0, eol, " ",
                rhc(dos, 5), null, null, null);

        PricingResult result = full.calculate(claim, fy2021());

        assertThat(result.returnCode()).isEqualTo("74");
    }

    @Test
    void full_noRhcLineItem_rtcIs00() {
        // Only IRC — no RHC/CHC days set → RTC=00
        LocalDate date = LocalDate.of(2021, 1, 15);
        HospiceClaim claim = claim("P001", date, date, WI_1, WI_1, 0, " ",
                null, null, irc(date, 3), null);

        PricingResult result = full.calculate(claim, fy2021());

        assertThat(result.returnCode()).isEqualTo("00");
        // ((249.59 * 1.0) + 211.50) * 3 = 461.09 * 3 = 1383.27
        assertThat(result.payAmt3()).isEqualByComparingTo("1383.27");
    }

    @Test
    void full_multipleRevenueLines_sumsAllPayments() {
        // All 4 revenue codes in one claim (all LOW: adm > 60 days before DOS)
        LocalDate adm = LocalDate.of(2020, 10, 1);
        LocalDate dos = LocalDate.of(2021, 1, 15); // >60 days

        HospiceClaim claim = claim("P001", dos, adm, WI_1, WI_1, 0, " ",
                rhc(dos, 10), chc(dos, 40), irc(dos, 3), gic(dos, 2));

        PricingResult result = full.calculate(claim, fy2021());

        assertThat(result.returnCode()).isEqualTo("73");
        // RHC LOW: 157.49 * 10 = 1574.90
        assertThat(result.payAmt1()).isEqualByComparingTo("1574.90");
        // CHC: (1432.41/24) * (40/4) = 59.68 * 10 = 596.84 (approx)
        assertThat(result.payAmt2()).isGreaterThan(BigDecimal.ZERO);
        // IRC: 461.09 * 3 = 1383.27
        assertThat(result.payAmt3()).isEqualByComparingTo("1383.27");
        // GIC: (669.33 + 376.33) * 2 = 1045.66 * 2 = 2091.32
        assertThat(result.payAmt4()).isEqualByComparingTo("2091.32");

        BigDecimal expected = result.payAmt1()
                .add(result.payAmt2())
                .add(result.payAmt3())
                .add(result.payAmt4());
        assertThat(result.payAmountTotal()).isEqualByComparingTo(expected);
    }

    // ── FiscalYearStrategy default: anyUnitOver1000 ───────────────────────────

    @Test
    void full_unitOver1000ForAnyLineItem_returnsRtc10() {
        LocalDate date = LocalDate.of(2021, 1, 15);

        // line item 3 = 1500 units
        HospiceClaim claim = claim("P001", date, date, WI_1, WI_1, 0, " ",
                rhc(date, 5), null, irc(date, 1500), null);

        PricingResult result = full.calculate(claim, fy2021());

        assertThat(result.returnCode()).isEqualTo("10");
        assertThat(result.payAmountTotal()).isEqualByComparingTo("0.00");
    }
}
