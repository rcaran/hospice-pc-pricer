package com.cms.hospice.regression;

import com.cms.hospice.model.*;
import com.cms.hospice.pricing.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * COBOL Parity Regression Test Suite.
 *
 * Tests the pricing strategies directly (bypassing DriverService/file loading)
 * to achieve 1:1 functional parity with HOSPR210/HOSDR210.
 *
 * Tolerances:
 * - Payment amounts: ±$0.01 (BigDecimal comparison)
 * - Return codes: exact string equality
 * - Day counts: exact integer equality
 *
 * Rate source: HOSPRATE copybook + HOSPR210 hard-coded paragraphs.
 * All wage indexes use WI=1.0000 for deterministic calculation.
 */
class CobolParityRegressionTest {

        private SimplePricerStrategy simple;
        private TransitionPricerStrategy transition;
        private ModernPricerStrategy modern;
        private FullPricerStrategy full;

        private static final BigDecimal WI_1 = new BigDecimal("1.0000");
        private static final BigDecimal WI_115 = new BigDecimal("1.1500");
        private static final BigDecimal WI_085 = new BigDecimal("0.8500");

        // FY2021 rates from HOSPRATE
        private FiscalYearRates fy2021;
        // FY2020 rates
        private FiscalYearRates fy2020;
        // FY2016_1 rates
        private FiscalYearRates fy2016_1;
        // FY2016 rates (no split)
        private FiscalYearRates fy2016;
        // FY2014 rates (first with QIP)
        private FiscalYearRates fy2014;
        // FY2013 rates
        private FiscalYearRates fy2013;
        // FY2007_1 rates
        private FiscalYearRates fy2007_1;
        // FY2005 rates
        private FiscalYearRates fy2005;
        // FY2001 rates
        private FiscalYearRates fy2001;
        // FY2001-A mid-year update rates
        private FiscalYearRates fy2001a;
        // FY2003 rates
        private FiscalYearRates fy2003;
        // FY2015 rates (with QIP)
        private FiscalYearRates fy2015;
        // FY1999 rates
        private FiscalYearRates fy1999;

        @BeforeEach
        void setUpStrategies() {
                simple = new SimplePricerStrategy();
                transition = new TransitionPricerStrategy();
                modern = new ModernPricerStrategy();
                full = new FullPricerStrategy();

                fy2021 = rates("FY2021",
                                "136.90", "62.35", "108.21", "49.28",
                                "984.21", "448.20", "249.59", "211.50", "669.33", "376.33",
                                "134.23", "61.13", "106.10", "48.32",
                                "964.99", "439.45", "244.71", "207.37", "656.25", "368.98",
                                true, true, true, true, false);

                fy2020 = rates("FY2020",
                                "193.35", "87.56", "152.80", "69.16", // rhcH / rhcL
                                "1388.78", "629.11", "352.98", "297.89", "946.75", "531.39",
                                "189.56", "85.86", "149.82", "67.83",
                                "1362.82", "617.10", "346.10", "292.04", "928.50", "521.10",
                                true, true, true, true, false);

                fy2016_1 = rates("FY2016_1",
                                "168.97", "73.39", "132.24", "57.41",
                                "1199.18", "519.67", "307.27", "262.47", "771.01", "435.28",
                                "165.59", "71.94", "129.58", "56.26",
                                "1175.33", "509.49", "301.28", "257.22", "755.60", "426.64",
                                true, true, true, true, false);

                fy2016 = rates("FY2016",
                                "161.90", "72.24", "161.90", "72.24", // no low split
                                "1149.09", "498.94", "294.55", "251.23", "738.36", "417.55",
                                "158.71", "70.83", "158.71", "70.83",
                                "1126.38", "489.02", "288.78", "246.24", "723.52", "409.12",
                                true, false, false, true, false);

                fy2014 = rates("FY2014",
                                "107.23", "48.83", "107.23", "48.83",
                                "841.11", "383.22", "215.53", "186.84", "582.41", "329.39",
                                "105.12", "47.87", "105.12", "47.87",
                                "824.89", "375.81", "211.30", "183.19", "571.10", "322.99",
                                true, false, false, true, false);

                fy2013 = rates("FY2013",
                                "96.51", "43.96", "96.51", "43.96",
                                "754.58", "343.98", "193.53", "167.65", "522.80", "295.55",
                                null, null, null, null, null, null, null, null, null, null,
                                false, false, false, true, false);

                fy2007_1 = rates("FY2007_1",
                                "52.22", "23.79", "52.22", "23.79",
                                "419.83", "191.37", "107.93", "93.56", "291.22", "164.67",
                                null, null, null, null, null, null, null, null, null, null,
                                false, false, false, true, false);

                fy2005 = rates("FY2005",
                                "83.81", "38.17", "83.81", "38.17",
                                "728.14", "331.77", "153.79", "133.37", "412.41", "233.29",
                                null, null, null, null, null, null, null, null, null, null,
                                false, false, false, false, true);

                fy2001 = rates("FY2001",
                                "69.97", "31.87", "69.97", "31.87",
                                "558.84", "254.82", "118.86", "103.07", "316.84", "179.12",
                                null, null, null, null, null, null, null, null, null, null,
                                false, false, false, false, true);

                fy2001a = rates("FY2001A",
                                "73.47", "33.46", "73.47", "33.46",
                                "428.84", "195.29", "59.88", "50.74", "304.49", "171.20",
                                null, null, null, null, null, null, null, null, null, null,
                                false, false, false, false, true);

                fy2003 = rates("FY2003",
                                "78.47", "35.73", "78.47", "35.73",
                                "457.97", "208.55", "63.94", "54.19", "325.18", "182.83",
                                null, null, null, null, null, null, null, null, null, null,
                                false, false, false, false, true);

                fy2015 = rates("FY2015",
                                "109.48", "49.86", "109.48", "49.86",
                                "638.94", "290.97", "89.21", "75.60", "453.68", "255.09",
                                "107.34", "48.88", "107.34", "48.88",
                                "626.42", "285.27", "87.46", "74.12", "444.79", "250.09",
                                true, false, false, true, false);

                fy1999 = rates("FY1999",
                                "55.20", "25.14", "55.20", "25.14",
                                "440.95", "201.00", "93.90", "81.40", "249.80", "141.15",
                                null, null, null, null, null, null, null, null, null, null,
                                false, false, false, false, true);
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC08 / TC08B — RTC=10: Units > 1000
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC08 — RTC=10 when any RHC units > 1000")
        void tc08_rhcUnitsOver1000_returnsRtc10() {
                LocalDate date = LocalDate.of(2021, 1, 15);
                HospiceClaim claim = buildClaim(date, date, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, date, 1500), null, null, null, " ");

                PricingResult result = full.calculate(claim, fy2021);

                assertThat(result.returnCode()).isEqualTo("10");
                assertThat(result.payAmountTotal()).isEqualByComparingTo("0.00");
        }

        @Test
        @DisplayName("TC08B — RTC=10 when any non-RHC units > 1000")
        void tc08b_ircUnitsOver1000_returnsRtc10() {
                LocalDate date = LocalDate.of(2021, 1, 15);
                HospiceClaim claim = buildClaim(date, date, WI_1, WI_1, 0,
                                null, null, li(RevenueLineItem.REV_IRC, date, 2000), null, " ");

                PricingResult result = full.calculate(claim, fy2021);

                assertThat(result.returnCode()).isEqualTo("10");
                assertThat(result.payAmountTotal()).isEqualByComparingTo("0.00");
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC09 — RTC=20: CHC < 8 units in FY1998–FY2006
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC09 — RTC=20 when CHC (0652) < 8 units in FY2005")
        void tc09_chcBelow8units_fy2005_returnsRtc20() {
                LocalDate date = LocalDate.of(2005, 1, 15);
                HospiceClaim claim = buildClaim(date, date, WI_1, WI_1, 0,
                                null, li(RevenueLineItem.REV_CHC, date, 5), null, null, " ");

                PricingResult result = simple.calculate(claim, fy2005);

                assertThat(result.returnCode()).isEqualTo("20");
                assertThat(result.payAmountTotal()).isEqualByComparingTo("0.00");
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC10 — ALL HIGH: units <= highDaysLeft
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC10 — All HIGH: priorSvcDays=5, units=10 → RTC=75")
        void tc10_allHigh_priorDays5_units10() {
                // priorSvcDays = DOS - ADM + priorBenefitDays = 5 + 0 = 5 → highDaysLeft=55
                LocalDate adm = LocalDate.of(2021, 1, 10);
                LocalDate dos = LocalDate.of(2021, 1, 15); // 5 days after adm
                int units = 10;

                HospiceClaim claim = buildClaim(dos, adm, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, units), null, null, null, " ");

                PricingResult result = full.calculate(claim, fy2021);

                assertThat(result.returnCode()).isEqualTo("75");
                assertThat(result.highRhcDays()).isEqualTo(10);
                assertThat(result.lowRhcDays()).isEqualTo(0);
                // ((136.90 * 1.0) + 62.35) * 10 = 199.25 * 10 = 1992.50
                assertThat(result.payAmt1()).isEqualByComparingTo("1992.50");
                assertThat(result.payAmountTotal()).isEqualByComparingTo("1992.50");
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC11 — ALL HIGH with NA-ADD-ON prior benefit days
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC11 — All HIGH with 10 priorBenefitDays: priorSvcDays=15, units=5 → RTC=75")
        void tc11_allHigh_priorBenefitDays10_units5() {
                LocalDate adm = LocalDate.of(2021, 1, 10);
                LocalDate dos = LocalDate.of(2021, 1, 15); // 5 days diff
                // priorBenefitDays=10 → priorSvcDays = 5+10 = 15 → highDaysLeft=45

                HospiceClaim claim = buildClaim(dos, adm, WI_1, WI_1, 10,
                                li(RevenueLineItem.REV_RHC, dos, 5), null, null, null, " ");

                PricingResult result = full.calculate(claim, fy2021);

                assertThat(result.returnCode()).isEqualTo("75");
                assertThat(result.highRhcDays()).isEqualTo(5);
                assertThat(result.lowRhcDays()).isEqualTo(0);
                // 199.25 * 5 = 996.25
                assertThat(result.payAmt1()).isEqualByComparingTo("996.25");
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC12 — SPLIT: priorSvcDays=55, units=10 → RTC=75
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC12 — SPLIT HIGH+LOW: priorSvcDays=55, units=10, WI=1.0 → RTC=75, total=$1783.70")
        void tc12_splitHighLow_priorDays55_units10() {
                // DOS-ADM = 55 days → highDaysLeft=5 → HIGH=5, LOW=5
                LocalDate adm = LocalDate.of(2021, 1, 19);
                LocalDate dos = LocalDate.of(2021, 3, 15); // 55 days after adm

                HospiceClaim claim = buildClaim(dos, adm, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 10), null, null, null, " ");

                PricingResult result = full.calculate(claim, fy2021);

                assertThat(result.returnCode()).isEqualTo("75");
                assertThat(result.highRhcDays()).isEqualTo(5);
                assertThat(result.lowRhcDays()).isEqualTo(5);
                // HIGH: 199.25 * 5 = 996.25
                // LOW: 157.49 * 5 = 787.45
                // TOTAL = 1783.70
                assertThat(result.payAmt1()).isEqualByComparingTo("1783.70");
                assertThat(result.payAmountTotal()).isEqualByComparingTo("1783.70");
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC13 — SPLIT + SIA → RTC=77
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC13 — SPLIT HIGH+LOW with SIA → RTC=77")
        void tc13_splitWithSia_returnsRtc77() {
                LocalDate adm = LocalDate.of(2021, 1, 19);
                LocalDate dos = LocalDate.of(2021, 3, 15);
                int[] eol = { 8, 12, 0, 0, 0, 0, 0 };

                HospiceClaim claim = buildClaimWithEol(dos, adm, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 10), eol, " ");

                PricingResult result = full.calculate(claim, fy2021);

                assertThat(result.returnCode()).isEqualTo("77");
                assertThat(result.highRhcDays()).isEqualTo(5);
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC14 — CHC >= 32 units (formula: CHC/24 * units/4)
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC14 — CHC 40 units (10 hours) → CHC formula, RTC=00")
        void tc14_chc40units_usingChcFormula() {
                LocalDate dos = LocalDate.of(2021, 2, 20);
                LocalDate adm = LocalDate.of(2021, 2, 15);

                HospiceClaim claim = buildClaim(dos, adm, WI_1, WI_1, 0,
                                null, li(RevenueLineItem.REV_CHC, dos, 40), null, null, " ");

                PricingResult result = full.calculate(claim, fy2021);

                // (1432.41 / 24) * (40/4) = 59.6837... * 10 = 596.84 (HALF_UP)
                assertThat(result.payAmt2()).isEqualByComparingTo("596.84");
                // CHC line does not set high/low RHC days → RTC=00
                assertThat(result.returnCode()).isEqualTo("00");
        }

        @Test
        @DisplayName("TC15 — CHC exactly 32 units → CHC formula (boundary)")
        void tc15_chc32units_boundaryUsesChcFormula() {
                LocalDate dos = LocalDate.of(2021, 2, 20);
                LocalDate adm = LocalDate.of(2021, 2, 15);

                HospiceClaim claim = buildClaim(dos, adm, WI_1, WI_1, 0,
                                null, li(RevenueLineItem.REV_CHC, dos, 32), null, null, " ");

                PricingResult result = full.calculate(claim, fy2021);

                // (1432.41 / 24) * 8 = 477.47
                assertThat(result.payAmt2()).isEqualByComparingTo("477.47");
        }

        @Test
        @DisplayName("TC16 — CHC 31 units < 32 → single RHC rate day")
        void tc16_chc31units_belowThreshold_paysRhcRate() {
                // adm close to DOS → in HIGH zone
                LocalDate adm = LocalDate.of(2021, 1, 10);
                LocalDate dos = LocalDate.of(2021, 2, 20); // ~41 days

                HospiceClaim claim = buildClaim(dos, adm, WI_1, WI_1, 0,
                                null, li(RevenueLineItem.REV_CHC, dos, 31), null, null, " ");

                PricingResult result = full.calculate(claim, fy2021);

                // Pays 1 RHC-rate day (high zone since priorSvcDays=41 < 60)
                // ((136.90 + 62.35) * 1) = 199.25
                assertThat(result.payAmt2()).isEqualByComparingTo("199.25");
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC17–TC19 — QIP for CHC, IRC, GIC
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC17 — QIP CHC 40 units → QIP CHC formula rates")
        void tc17_qipChc40units() {
                LocalDate dos = LocalDate.of(2021, 2, 20);
                LocalDate adm = LocalDate.of(2021, 2, 15);

                HospiceClaim noQip = buildClaim(dos, adm, WI_1, WI_1, 0,
                                null, li(RevenueLineItem.REV_CHC, dos, 40), null, null, " ");
                HospiceClaim withQip = buildClaim(dos, adm, WI_1, WI_1, 0,
                                null, li(RevenueLineItem.REV_CHC, dos, 40), null, null, "1");

                PricingResult r1 = modern.calculate(noQip, fy2021);
                PricingResult r2 = modern.calculate(withQip, fy2021);

                // QIP must be less than standard
                assertThat(r2.payAmt2()).isLessThan(r1.payAmt2());
                // QIP formula: (964.99 + 439.45) / 24 * 10 = 1404.44 / 24 * 10 = 58.52 * 10 =
                // 585.18
                assertThat(r2.payAmt2()).isEqualByComparingTo("585.18");
        }

        @Test
        @DisplayName("TC18 — QIP IRC 5 units → QIP IRC rates")
        void tc18_qipIrc5units() {
                LocalDate dos = LocalDate.of(2021, 2, 20);
                LocalDate adm = LocalDate.of(2021, 2, 15);

                HospiceClaim withQip = buildClaim(dos, adm, WI_1, WI_1, 0,
                                null, null, li(RevenueLineItem.REV_IRC, dos, 5), null, "1");

                PricingResult result = modern.calculate(withQip, fy2021);

                // ((244.71 * 1.0) + 207.37) * 5 = 452.08 * 5 = 2260.40
                assertThat(result.payAmt3()).isEqualByComparingTo("2260.40");
        }

        @Test
        @DisplayName("TC19 — QIP GIC 3 units → QIP GIC rates")
        void tc19_qipGic3units() {
                LocalDate dos = LocalDate.of(2021, 2, 20);
                LocalDate adm = LocalDate.of(2021, 2, 15);

                HospiceClaim withQip = buildClaim(dos, adm, WI_1, WI_1, 0,
                                null, null, null, li(RevenueLineItem.REV_GIC, dos, 3), "1");

                PricingResult result = modern.calculate(withQip, fy2021);

                // ((656.25 * 1.0) + 368.98) * 3 = 1025.23 * 3 = 3075.69
                assertThat(result.payAmt4()).isEqualByComparingTo("3075.69");
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC20 — QIP + SIA: SIA uses QIP-reduced CHC rates
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC20 — QIP + SIA → SIA uses QIP CHC rates, RTC=77")
        void tc20_qipWithSia_returnsRtc77() {
                LocalDate adm = LocalDate.of(2021, 1, 10);
                LocalDate dos = LocalDate.of(2021, 1, 15); // 5 days → all HIGH
                int[] eol = { 8, 12, 0, 0, 0, 0, 0 };

                HospiceClaim claim = buildClaimWithEol(dos, adm, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 5), eol, "1");

                PricingResult result = full.calculate(claim, fy2021);

                assertThat(result.returnCode()).isEqualTo("77");
                // SIA QIP rate = (964.99 + 439.45) / 24 = 58.52 (rounded 2dp)
                // day1: 2h * 58.52 = 117.04; day2: 3h * 58.52 = 175.56
                BigDecimal siaPay = result.eolAddOnDayPayments()[0]
                                .add(result.eolAddOnDayPayments()[1]);
                assertThat(siaPay).isEqualByComparingTo("292.60");
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC21 — SIA cap at 16 units (4 hours)
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC21 — SIA cap: 20 units → 4 hours, 16 units → 4 hours, 15 units → 3.75 hours")
        void tc21_siaCap16units() {
                LocalDate adm = LocalDate.of(2021, 1, 10);
                LocalDate dos = LocalDate.of(2021, 1, 15);
                int[] eol = { 20, 16, 15, 0, 0, 0, 0 };

                HospiceClaim claim = buildClaimWithEol(dos, adm, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 5), eol, " ");

                PricingResult result = full.calculate(claim, fy2021);

                // SIA rate = 59.68
                // day1: cap → 4h * 59.68 = 238.72
                // day2: cap → 4h * 59.68 = 238.72
                // day3: 15/4 = 3.75h * 59.68 = 223.80
                assertThat(result.eolAddOnDayPayments()[0]).isEqualByComparingTo("238.72");
                assertThat(result.eolAddOnDayPayments()[1]).isEqualByComparingTo("238.72");
                assertThat(result.eolAddOnDayPayments()[2]).isEqualByComparingTo("223.80");
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC22 — SIA with all 7 days
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC22 — SIA all 7 days with 8 units each → total = 7 × 119.36 = 835.52")
        void tc22_siaAllSevenDays() {
                LocalDate adm = LocalDate.of(2021, 1, 10);
                LocalDate dos = LocalDate.of(2021, 1, 15);
                int[] eol = { 8, 8, 8, 8, 8, 8, 8 };

                HospiceClaim claim = buildClaimWithEol(dos, adm, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 7), eol, " ");

                PricingResult result = full.calculate(claim, fy2021);

                BigDecimal siaTotal = BigDecimal.ZERO;
                for (BigDecimal pay : result.eolAddOnDayPayments()) {
                        siaTotal = siaTotal.add(pay);
                }
                // 7 * (2h * 59.68) = 7 * 119.36 = 835.52
                assertThat(siaTotal).isEqualByComparingTo("835.52");
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC23 — All 4 revenue codes simultaneously
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC23 — All 4 rev codes, ALL LOW (adm > 60 days), RTC=73")
        void tc23_allFourRevCodes_allLow() {
                LocalDate adm = LocalDate.of(2020, 10, 1);
                LocalDate dos = LocalDate.of(2021, 1, 15);

                HospiceClaim claim = buildClaim(dos, adm, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 30),
                                li(RevenueLineItem.REV_CHC, dos, 40),
                                li(RevenueLineItem.REV_IRC, dos, 5),
                                li(RevenueLineItem.REV_GIC, dos, 3), " ");

                PricingResult result = full.calculate(claim, fy2021);

                assertThat(result.returnCode()).isEqualTo("73");
                // RHC LOW: 157.49 * 30 = 4724.70
                assertThat(result.payAmt1()).isEqualByComparingTo("4724.70");
                // CHC: (1432.41/24) * 10 = 596.84
                assertThat(result.payAmt2()).isEqualByComparingTo("596.84");
                // IRC: (249.59 + 211.50) * 5 = 461.09 * 5 = 2305.45
                assertThat(result.payAmt3()).isEqualByComparingTo("2305.45");
                // GIC: (669.33 + 376.33) * 3 = 1045.66 * 3 = 3136.98
                assertThat(result.payAmt4()).isEqualByComparingTo("3136.98");

                BigDecimal expectedTotal = new BigDecimal("4724.70")
                                .add(new BigDecimal("596.84"))
                                .add(new BigDecimal("2305.45"))
                                .add(new BigDecimal("3136.98"));
                assertThat(result.payAmountTotal()).isEqualByComparingTo(expectedTotal);
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC24/TC25 — FY2014: standard vs QIP rates
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC24 — FY2014 without QIP → standard rates")
        void tc24_fy2014_noQip() {
                LocalDate dos = LocalDate.of(2014, 1, 15);

                HospiceClaim claim = buildClaim(dos, dos, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 10), null, null, null, " ");

                PricingResult result = modern.calculate(claim, fy2014);

                assertThat(result.returnCode()).isEqualTo("00");
                // (107.23 + 48.83) * 10 = 156.06 * 10 = 1560.60
                assertThat(result.payAmt1()).isEqualByComparingTo("1560.60");
        }

        @Test
        @DisplayName("TC25 — FY2014 with QIP → QIP-reduced rates (~2% less)")
        void tc25_fy2014_withQip() {
                LocalDate dos = LocalDate.of(2014, 1, 15);

                HospiceClaim claim = buildClaim(dos, dos, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 10), null, null, null, "1");

                PricingResult result = modern.calculate(claim, fy2014);

                // (105.12 + 47.87) * 10 = 152.99 * 10 = 1529.90
                assertThat(result.payAmt1()).isEqualByComparingTo("1529.90");
                // QIP must be less than TC24
                assertThat(result.payAmt1()).isLessThan(new BigDecimal("1560.60"));
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC27A/TC27B — FY2016 boundary (Oct 2015 vs Jan 2016)
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC27A — FY2016 (Oct 2015): no 60-day split, RTC=00")
        void tc27a_fy2016_noSplit() {
                LocalDate dos = LocalDate.of(2015, 11, 15);

                HospiceClaim claim = buildClaim(dos, dos, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 5), null, null, null, " ");

                PricingResult result = modern.calculate(claim, fy2016);

                assertThat(result.returnCode()).isEqualTo("00");
                assertThat(result.highRhcDays()).isEqualTo(0); // no split
        }

        @Test
        @DisplayName("TC27B — FY2016_1 (Jan 2016): 60-day split active, RTC=75 (all HIGH)")
        void tc27b_fy2016_1_splitActive() {
                LocalDate adm = LocalDate.of(2016, 1, 10);
                LocalDate dos = LocalDate.of(2016, 1, 15); // 5 days → all HIGH

                HospiceClaim claim = buildClaim(dos, adm, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 5), null, null, null, " ");

                PricingResult result = full.calculate(claim, fy2016_1);

                assertThat(result.returnCode()).isEqualTo("75");
                assertThat(result.highRhcDays()).isEqualTo(5);
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC28A/TC28B — FY2007 boundary (FY2007 vs FY2007_1 CHC formula)
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC28A — FY2007 (Oct 2006): CHC in full hours, min 8 → RTC=00")
        void tc28a_fy2007_chcInHours() {
                FiscalYearRates fy2007 = ratesSimple("FY2007",
                                "52.22", "23.79", // rhc
                                "419.83", "191.37", // chc
                                "107.93", "93.56", // irc
                                "291.22", "164.67"); // gic
                LocalDate dos = LocalDate.of(2006, 11, 15);

                HospiceClaim claim = buildClaim(dos, dos, WI_1, WI_1, 0,
                                null, li(RevenueLineItem.REV_CHC, dos, 8), null, null, " ");

                PricingResult result = simple.calculate(claim, fy2007);

                assertThat(result.returnCode()).isEqualTo("00");
                // CHC hourly: (419.83 + 191.37) / 24 * 8 = 611.20 / 24 * 8 = 25.47 * 8 = 203.73
                assertThat(result.payAmt2()).isEqualByComparingTo("203.73");
        }

        @Test
        @DisplayName("TC28B — FY2007_1 (Jan 2007): CHC in 15-min units, < 32 units → 1 RHC day")
        void tc28b_fy2007_1_chcIn15MinUnits() {
                LocalDate dos = LocalDate.of(2007, 2, 15);

                HospiceClaim claim = buildClaim(dos, dos, WI_1, WI_1, 0,
                                null, li(RevenueLineItem.REV_CHC, dos, 10), null, null, " ");

                PricingResult result = transition.calculate(claim, fy2007_1);

                // CHC < 32 units → pay 1 RHC day: (52.22 + 23.79) * 1 = 76.01
                assertThat(result.payAmt2()).isEqualByComparingTo("76.01");
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC33–TC36 — Representative FY coverage (post-2006)
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC33 — FY2013 RHC 10 days, WI=1.0 → RTC=00")
        void tc33_fy2013_rhc10days() {
                LocalDate dos = LocalDate.of(2013, 3, 15);

                HospiceClaim claim = buildClaim(dos, dos, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 10), null, null, null, " ");

                PricingResult result = transition.calculate(claim, fy2013);

                assertThat(result.returnCode()).isEqualTo("00");
                // (96.51 + 43.96) * 10 = 140.47 * 10 = 1404.70
                assertThat(result.payAmt1()).isEqualByComparingTo("1404.70");
        }

        @Test
        @DisplayName("TC34 — FY2020 RHC with WI=1.15 (high-cost area)")
        void tc34_fy2020_rhcHighWageIndex() {
                LocalDate adm = LocalDate.of(2020, 10, 1);
                LocalDate dos = LocalDate.of(2020, 10, 15); // 14 days → all HIGH

                HospiceClaim claim = buildClaim(dos, adm, WI_115, WI_115, 0,
                                li(RevenueLineItem.REV_RHC, dos, 5), null, null, null, " ");

                PricingResult result = full.calculate(claim, fy2020);

                assertThat(result.returnCode()).isEqualTo("75");
                // ((193.35 * 1.15) + 87.56) * 5 = (222.3525 + 87.56) * 5 = 309.9125 * 5 =
                // 1549.56
                assertThat(result.payAmt1()).isEqualByComparingTo("1549.56");
        }

        @Test
        @DisplayName("TC35 — FY2020 IRC uses PROVIDER wage index only")
        void tc35_fy2020_ircUsesProviderWageIndex() {
                LocalDate dos = LocalDate.of(2020, 11, 15);

                // Provider WI=1.15, Beneficiary WI=0.85 — IRC must use PROV WI
                HospiceClaim claim = buildClaim(dos, dos, WI_115, WI_085, 0,
                                null, null, li(RevenueLineItem.REV_IRC, dos, 3), null, " ");

                PricingResult result = full.calculate(claim, fy2020);

                // IRC: ((352.98 * 1.15) + 297.89) * 3 = (405.927 + 297.89) * 3 = 703.817 * 3 =
                // 2111.45
                assertThat(result.payAmt3()).isEqualByComparingTo("2111.45");
        }

        @Test
        @DisplayName("TC36 — FY2020 GIC uses PROVIDER wage index only")
        void tc36_fy2020_gicUsesProviderWageIndex() {
                LocalDate dos = LocalDate.of(2020, 11, 15);

                // Provider WI=0.85, Beneficiary WI=1.15 — GIC must use PROV WI
                HospiceClaim claim = buildClaim(dos, dos, WI_085, WI_115, 0,
                                null, null, null, li(RevenueLineItem.REV_GIC, dos, 2), " ");

                PricingResult result = full.calculate(claim, fy2020);

                // GIC: ((946.75 * 0.85) + 531.39) * 2 = (804.7375 + 531.39) * 2 = 1336.1275 * 2
                // = 2672.26
                assertThat(result.payAmt4()).isEqualByComparingTo("2672.26");
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // ALL LOW (TC allLow) — RTC=73 with no SIA
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC allLow — priorSvcDays >= 60, no SIA → RTC=73")
        void allLow_noSia_returnsRtc73() {
                LocalDate adm = LocalDate.of(2020, 10, 1);
                LocalDate dos = LocalDate.of(2021, 1, 15); // > 60 days

                HospiceClaim claim = buildClaim(dos, adm, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 10), null, null, null, " ");

                PricingResult result = full.calculate(claim, fy2021);

                assertThat(result.returnCode()).isEqualTo("73");
                assertThat(result.highRhcDays()).isEqualTo(0);
                assertThat(result.lowRhcDays()).isEqualTo(10);
                // ((108.21 + 49.28) * 10) = 1574.90
                assertThat(result.payAmt1()).isEqualByComparingTo("1574.90");
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // FY1999 — Simple strategy, CHC hourly
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC30 — FY1999 RHC 10 days, WI=1.0 → simple formula")
        void tc30_fy1999_rhc10days() {
                LocalDate dos = LocalDate.of(1999, 3, 15);

                HospiceClaim claim = buildClaim(dos, dos, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 10), null, null, null, " ");

                PricingResult result = simple.calculate(claim, fy1999);

                assertThat(result.returnCode()).isEqualTo("00");
                // (55.20 + 25.14) * 10 = 80.34 * 10 = 803.40
                assertThat(result.payAmt1()).isEqualByComparingTo("803.40");
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC01–TC07 — Original GENDATA test cases (WI=1.0000, FY2021/FY2020)
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC01 — FY2021 RHC 30 days, ALL LOW (ADM Oct 2020), RTC=73, pay=$4724.70")
        void tc01_fy2021_rhc30days_allLow() {
                LocalDate adm = LocalDate.of(2020, 10, 1);
                LocalDate dos = LocalDate.of(2021, 1, 15); // 106 days → ALL LOW

                HospiceClaim claim = buildClaim(dos, adm, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 30), null, null, null, " ");

                PricingResult result = full.calculate(claim, fy2021);

                assertThat(result.returnCode()).isEqualTo("73");
                assertThat(result.highRhcDays()).isEqualTo(0);
                assertThat(result.lowRhcDays()).isEqualTo(30);
                // ((108.21 * 1.0) + 49.28) * 30 = 157.49 * 30 = 4724.70
                assertThat(result.payAmt1()).isEqualByComparingTo("4724.70");
                assertThat(result.payAmountTotal()).isEqualByComparingTo("4724.70");
        }

        @Test
        @DisplayName("TC02 — FY2021 CHC 10 units (<32), HIGH zone (ADM 5d before DOS), RTC=75")
        void tc02_fy2021_chc10units_highZone() {
                LocalDate adm = LocalDate.of(2021, 2, 15);
                LocalDate dos = LocalDate.of(2021, 2, 20); // 5 days → priorSvcDays=5 → HIGH zone

                HospiceClaim claim = buildClaim(dos, adm, WI_1, WI_1, 0,
                                null, li(RevenueLineItem.REV_CHC, dos, 10), null, null, " ");

                PricingResult result = full.calculate(claim, fy2021);

                assertThat(result.returnCode()).isEqualTo("75");
                // CHC < 32 units → 1 day at HIGH RHC rate: ((136.90 + 62.35) * 1) = 199.25
                assertThat(result.payAmt2()).isEqualByComparingTo("199.25");
                assertThat(result.payAmountTotal()).isEqualByComparingTo("199.25");
        }

        @Test
        @DisplayName("TC03 — FY2021 IRC 5 units, uses PROVIDER wage index, RTC=00")
        void tc03_fy2021_irc5units() {
                LocalDate adm = LocalDate.of(2021, 3, 8);
                LocalDate dos = LocalDate.of(2021, 3, 10);

                HospiceClaim claim = buildClaim(dos, adm, WI_1, WI_1, 0,
                                null, null, li(RevenueLineItem.REV_IRC, dos, 5), null, " ");

                PricingResult result = full.calculate(claim, fy2021);

                assertThat(result.returnCode()).isEqualTo("00");
                // IRC uses provider WI: ((249.59 * 1.0) + 211.50) * 5 = 461.09 * 5 = 2305.45
                assertThat(result.payAmt3()).isEqualByComparingTo("2305.45");
                assertThat(result.payAmountTotal()).isEqualByComparingTo("2305.45");
        }

        @Test
        @DisplayName("TC04 — FY2021 GIC 7 units, uses PROVIDER wage index, RTC=00")
        void tc04_fy2021_gic7units() {
                LocalDate adm = LocalDate.of(2021, 3, 25);
                LocalDate dos = LocalDate.of(2021, 4, 1);

                HospiceClaim claim = buildClaim(dos, adm, WI_1, WI_1, 0,
                                null, null, null, li(RevenueLineItem.REV_GIC, dos, 7), " ");

                PricingResult result = full.calculate(claim, fy2021);

                assertThat(result.returnCode()).isEqualTo("00");
                // GIC uses provider WI: ((669.33 * 1.0) + 376.33) * 7 = 1045.66 * 7 = 7319.62
                assertThat(result.payAmt4()).isEqualByComparingTo("7319.62");
                assertThat(result.payAmountTotal()).isEqualByComparingTo("7319.62");
        }

        @Test
        @DisplayName("TC05 — FY2021 RHC 20 days with QIP, ALL LOW (ADM Jan 2021), RTC=73")
        void tc05_fy2021_rhcQip20days_allLow() {
                LocalDate adm = LocalDate.of(2021, 1, 1);
                LocalDate dos = LocalDate.of(2021, 5, 1); // 120 days → ALL LOW

                HospiceClaim claim = buildClaim(dos, adm, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 20), null, null, null, "1");

                PricingResult result = full.calculate(claim, fy2021);

                assertThat(result.returnCode()).isEqualTo("73");
                assertThat(result.highRhcDays()).isEqualTo(0);
                assertThat(result.lowRhcDays()).isEqualTo(20);
                // QIP LOW: ((106.10 * 1.0) + 48.32) * 20 = 154.42 * 20 = 3088.40
                assertThat(result.payAmt1()).isEqualByComparingTo("3088.40");
                assertThat(result.payAmountTotal()).isEqualByComparingTo("3088.40");
        }

        @Test
        @DisplayName("TC06 — FY2020 RHC 15 days, ALL LOW (ADM Jan 2020), RTC=73")
        void tc06_fy2020_rhc15days_allLow() {
                LocalDate adm = LocalDate.of(2020, 1, 1);
                LocalDate dos = LocalDate.of(2020, 3, 15); // 74 days → ALL LOW

                HospiceClaim claim = buildClaim(dos, adm, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 15), null, null, null, " ");

                PricingResult result = full.calculate(claim, fy2020);

                assertThat(result.returnCode()).isEqualTo("73");
                assertThat(result.highRhcDays()).isEqualTo(0);
                assertThat(result.lowRhcDays()).isEqualTo(15);
                // ((152.80 * 1.0) + 69.16) * 15 = 221.96 * 15 = 3329.40
                assertThat(result.payAmt1()).isEqualByComparingTo("3329.40");
                assertThat(result.payAmountTotal()).isEqualByComparingTo("3329.40");
        }

        @Test
        @DisplayName("TC07 — FY2021 RHC 25 days + SIA (day1=8, day2=10), ALL LOW, RTC=74")
        void tc07_fy2021_rhcWithSia_allLow() {
                LocalDate adm = LocalDate.of(2021, 1, 1);
                LocalDate dos = LocalDate.of(2021, 6, 1); // 151 days → ALL LOW
                int[] eol = { 8, 10, 0, 0, 0, 0, 0 };

                HospiceClaim claim = buildClaimWithEol(dos, adm, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 25), eol, " ");

                PricingResult result = full.calculate(claim, fy2021);

                assertThat(result.returnCode()).isEqualTo("74");
                assertThat(result.highRhcDays()).isEqualTo(0);
                assertThat(result.lowRhcDays()).isEqualTo(25);
                // RHC LOW: ((108.21 + 49.28) * 25) = 157.49 * 25 = 3937.25
                assertThat(result.payAmt1()).isEqualByComparingTo("3937.25");
                // SIA rate = (984.21 + 448.20) / 24 = 1432.41 / 24 = 59.68 (rounded)
                // day1: 8 units → 2 hours → 2 * 59.68 = 119.36
                // day2: 10 units → 2.5 hours → 2.5 * 59.68 = 149.20
                assertThat(result.eolAddOnDayPayments()[0]).isEqualByComparingTo("119.36");
                assertThat(result.eolAddOnDayPayments()[1]).isEqualByComparingTo("149.20");
                assertThat(result.payAmountTotal()).isEqualByComparingTo("4205.81");
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC26 — FY2015 with QIP (hard-coded QIP rates)
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC26 — FY2015 RHC 10 days with QIP → QIP-reduced rates, RTC=00")
        void tc26_fy2015_rhcWithQip() {
                LocalDate dos = LocalDate.of(2015, 1, 15);

                HospiceClaim claim = buildClaim(dos, dos, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 10), null, null, null, "1");

                PricingResult result = modern.calculate(claim, fy2015);

                assertThat(result.returnCode()).isEqualTo("00");
                // FY2015 QIP: LS=107.34, NLS=48.88 → (107.34 + 48.88) * 10 = 156.22 * 10 =
                // 1562.20
                assertThat(result.payAmt1()).isEqualByComparingTo("1562.20");
                // QIP rate must be less than standard (109.48 + 49.86) * 10 = 1593.40
                assertThat(result.payAmt1()).isLessThan(new BigDecimal("1593.40"));
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC29 — FY2001 boundary: FY2001 (Oct 2000–Mar 2001) vs FY2001-A (Apr–Sep 2001)
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC29A — FY2001 RHC 5 days (FROM=20010315) → LS=69.97, NLS=31.87, RTC=00")
        void tc29a_fy2001_rhc5days() {
                LocalDate dos = LocalDate.of(2001, 3, 15);

                HospiceClaim claim = buildClaim(dos, dos, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 5), null, null, null, " ");

                PricingResult result = simple.calculate(claim, fy2001);

                assertThat(result.returnCode()).isEqualTo("00");
                // (69.97 + 31.87) * 5 = 101.84 * 5 = 509.20
                assertThat(result.payAmt1()).isEqualByComparingTo("509.20");
        }

        @Test
        @DisplayName("TC29B — FY2001-A RHC 5 days (FROM=20010401) → LS=73.47, NLS=33.46 (~5% more)")
        void tc29b_fy2001a_rhc5days() {
                LocalDate dos = LocalDate.of(2001, 4, 1);

                HospiceClaim claim = buildClaim(dos, dos, WI_1, WI_1, 0,
                                li(RevenueLineItem.REV_RHC, dos, 5), null, null, null, " ");

                PricingResult result = simple.calculate(claim, fy2001a);

                assertThat(result.returnCode()).isEqualTo("00");
                // (73.47 + 33.46) * 5 = 106.93 * 5 = 534.65
                assertThat(result.payAmt1()).isEqualByComparingTo("534.65");
                // FY2001-A rate must be greater than FY2001 (~5% higher)
                assertThat(result.payAmt1()).isGreaterThan(new BigDecimal("509.20"));
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC31 — FY1999 CHC in full hours (minimum 8h — boundary exactly met)
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC31 — FY1999 CHC 10 hours → hourly formula applied (≥ 8h min), RTC=00")
        void tc31_fy1999_chc10hours() {
                LocalDate dos = LocalDate.of(1999, 11, 15);

                HospiceClaim claim = buildClaim(dos, dos, WI_1, WI_1, 0,
                                null, li(RevenueLineItem.REV_CHC, dos, 10), null, null, " ");

                PricingResult result = simple.calculate(claim, fy1999);

                assertThat(result.returnCode()).isEqualTo("00");
                // CHC hourly: ((440.95 * 1.0 + 201.00) / 24) * 10 = 641.95/24 * 10 = 267.48
                assertThat(result.payAmt2()).isEqualByComparingTo("267.48");
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // TC32 — FY2003 IRC uses PROVIDER wage index (not beneficiary)
        // ═══════════════════════════════════════════════════════════════════════════

        @Test
        @DisplayName("TC32 — FY2003 IRC 5 units, uses PROVIDER WI, RTC=00")
        void tc32_fy2003_irc5units_providerWI() {
                LocalDate dos = LocalDate.of(2003, 6, 1);

                // Provider WI=1.15 (high-cost area), Beneficiary WI=0.85 — IRC must use PROV WI
                HospiceClaim claim = buildClaim(dos, dos, WI_115, WI_085, 0,
                                null, null, li(RevenueLineItem.REV_IRC, dos, 5), null, " ");

                PricingResult result = simple.calculate(claim, fy2003);

                assertThat(result.returnCode()).isEqualTo("00");
                // IRC uses PROV WI=1.15: ((63.94 * 1.15) + 54.19) * 5 = (73.531 + 54.19) * 5
                // = 127.721 * 5 = 638.61 (rounded HALF_UP)
                assertThat(result.payAmt3()).isEqualByComparingTo("638.61");

                // Verify IRC uses PROV WI, not BENE WI: with BENE WI=0.85 result would be
                // different
                HospiceClaim claimWithBeneWI = buildClaim(dos, dos, WI_085, WI_085, 0,
                                null, null, li(RevenueLineItem.REV_IRC, dos, 5), null, " ");
                PricingResult resultWithBeneWI = simple.calculate(claimWithBeneWI, fy2003);
                // If IRC incorrectly used BENE WI: ((63.94 * 0.85) + 54.19) * 5 = 108.54 * 5 =
                // 542.70
                assertThat(result.payAmt3()).isNotEqualByComparingTo(resultWithBeneWI.payAmt3());
        }

        // ═══════════════════════════════════════════════════════════════════════════
        // Helper builders
        // ═══════════════════════════════════════════════════════════════════════════

        private HospiceClaim buildClaim(LocalDate fromDate, LocalDate admDate,
                        BigDecimal provWI, BigDecimal beneWI, int priorBenefitDays,
                        RevenueLineItem li1, RevenueLineItem li2,
                        RevenueLineItem li3, RevenueLineItem li4,
                        String qipInd) {
                return new HospiceClaim(
                                "1234567890", "PROV01", fromDate, admDate,
                                "16740", "16740",
                                provWI, beneWI,
                                priorBenefitDays, 0, new int[7],
                                qipInd, li1, li2, li3, li4);
        }

        private HospiceClaim buildClaimWithEol(LocalDate fromDate, LocalDate admDate,
                        BigDecimal provWI, BigDecimal beneWI, int priorBenefitDays,
                        RevenueLineItem li1, int[] eolUnits, String qipInd) {
                return new HospiceClaim(
                                "1234567890", "PROV01", fromDate, admDate,
                                "16740", "16740",
                                provWI, beneWI,
                                priorBenefitDays, 0, eolUnits,
                                qipInd, li1, null, null, null);
        }

        private RevenueLineItem li(String revCode, LocalDate dos, int units) {
                return new RevenueLineItem(revCode, null, dos, units);
        }

        private FiscalYearRates rates(String fy,
                        String rhcHLs, String rhcHNls, String rhcLLs, String rhcLNls,
                        String chcLs, String chcNls, String ircLs, String ircNls,
                        String gicLs, String gicNls,
                        String rhcHLsQ, String rhcHNlsQ, String rhcLLsQ, String rhcLNlsQ,
                        String chcLsQ, String chcNlsQ, String ircLsQ, String ircNlsQ,
                        String gicLsQ, String gicNlsQ,
                        boolean hasQip, boolean has60DaySplit, boolean hasSia,
                        boolean chcIn15Min, boolean minChc8h) {
                return new FiscalYearRates(fy,
                                bd(rhcHLs), bd(rhcHNls), bd(rhcLLs), bd(rhcLNls),
                                bd(chcLs), bd(chcNls), bd(ircLs), bd(ircNls), bd(gicLs), bd(gicNls),
                                rhcHLsQ != null ? bd(rhcHLsQ) : null,
                                rhcHNlsQ != null ? bd(rhcHNlsQ) : null,
                                rhcLLsQ != null ? bd(rhcLLsQ) : null,
                                rhcLNlsQ != null ? bd(rhcLNlsQ) : null,
                                chcLsQ != null ? bd(chcLsQ) : null,
                                chcNlsQ != null ? bd(chcNlsQ) : null,
                                ircLsQ != null ? bd(ircLsQ) : null,
                                ircNlsQ != null ? bd(ircNlsQ) : null,
                                gicLsQ != null ? bd(gicLsQ) : null,
                                gicNlsQ != null ? bd(gicNlsQ) : null,
                                hasQip, has60DaySplit, hasSia, chcIn15Min, minChc8h);
        }

        private FiscalYearRates ratesSimple(String fy,
                        String rhcLs, String rhcNls,
                        String chcLs, String chcNls,
                        String ircLs, String ircNls,
                        String gicLs, String gicNls) {
                return new FiscalYearRates(fy,
                                bd(rhcLs), bd(rhcNls), bd(rhcLs), bd(rhcNls),
                                bd(chcLs), bd(chcNls), bd(ircLs), bd(ircNls), bd(gicLs), bd(gicNls),
                                null, null, null, null, null, null, null, null, null, null,
                                false, false, false, false, true);
        }

        private BigDecimal bd(String val) {
                return new BigDecimal(val);
        }
}
