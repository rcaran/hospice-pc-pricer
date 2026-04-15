package com.cms.hospice.pricing;

import com.cms.hospice.model.*;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Shared factory methods for building test fixtures.
 * Avoids duplicating record constructor calls across test classes.
 */
final class TestFixtures {

    private TestFixtures() {
    }

    static final BigDecimal WI_1 = new BigDecimal("1.0000");
    static final BigDecimal WI_115 = new BigDecimal("1.1500");
    static final BigDecimal WI_085 = new BigDecimal("0.8500");

    // ── FY2021 rates ─────────────────────────────────────────────────────────

    static FiscalYearRates fy2021() {
        return new FiscalYearRates(
                "FY2021",
                bd("136.90"), bd("62.35"), // rhcHighLs / rhcHighNls
                bd("108.21"), bd("49.28"), // rhcLowLs / rhcLowNls
                bd("984.21"), bd("448.20"), // chcLs / chcNls
                bd("249.59"), bd("211.50"), // ircLs / ircNls
                bd("669.33"), bd("376.33"), // gicLs / gicNls
                // QIP rates
                bd("134.23"), bd("61.13"), // rhcHighLsQ / rhcHighNlsQ
                bd("106.10"), bd("48.32"), // rhcLowLsQ / rhcLowNlsQ
                bd("964.99"), bd("439.45"), // chcLsQ / chcNlsQ
                bd("244.71"), bd("207.37"), // ircLsQ / ircNlsQ
                bd("656.25"), bd("368.98"), // gicLsQ / gicNlsQ
                // flags
                true, // hasQip
                true, // has60DaySplit
                true, // hasSia
                true, // chcIn15MinUnits
                false // hasMinChc8Hours
        );
    }

    static FiscalYearRates fy2014() {
        return new FiscalYearRates(
                "FY2014",
                bd("107.23"), bd("48.83"),
                bd("107.23"), bd("48.83"), // no low split — same as high
                bd("841.11"), bd("383.22"),
                bd("215.53"), bd("186.84"),
                bd("582.41"), bd("329.39"),
                // QIP
                bd("105.12"), bd("47.87"),
                bd("105.12"), bd("47.87"),
                bd("824.89"), bd("375.81"),
                bd("211.30"), bd("183.19"),
                bd("571.10"), bd("322.99"),
                true, false, false, true, false);
    }

    static FiscalYearRates fy2005() {
        return new FiscalYearRates(
                "FY2005",
                bd("83.81"), bd("38.17"),
                bd("83.81"), bd("38.17"), // same LS/NLS for both (no split)
                bd("728.14"), bd("331.77"),
                bd("153.79"), bd("133.37"),
                bd("412.41"), bd("233.29"),
                null, null, null, null, null, null, null, null, null, null,
                false, false, false, false, true);
    }

    // ── HospiceClaim builder ─────────────────────────────────────────────────

    /**
     * Builds a minimal claim for strategy unit tests.
     * DriverService wage-index resolution is bypassed —
     * provWI and beneWI must be supplied directly.
     */
    static HospiceClaim claim(
            String provNo, LocalDate fromDate, LocalDate admDate,
            BigDecimal provWI, BigDecimal beneWI,
            int priorDays, String qipInd,
            RevenueLineItem li1, RevenueLineItem li2,
            RevenueLineItem li3, RevenueLineItem li4) {
        return new HospiceClaim(
                "1234567890", provNo, fromDate, admDate,
                "16740", "16740",
                provWI, beneWI,
                priorDays, 0, new int[7], qipInd,
                li1, li2, li3, li4);
    }

    static HospiceClaim claimWithEol(
            LocalDate fromDate, LocalDate admDate,
            BigDecimal beneWI, int priorDays,
            int[] eolUnits, RevenueLineItem li1) {
        return new HospiceClaim(
                "1234567890", "PROV01", fromDate, admDate,
                "16740", "16740",
                WI_1, beneWI,
                priorDays, 0, eolUnits, " ",
                li1, null, null, null);
    }

    static RevenueLineItem rhc(LocalDate dos, int units) {
        return new RevenueLineItem(RevenueLineItem.REV_RHC, null, dos, units);
    }

    static RevenueLineItem chc(LocalDate dos, int units) {
        return new RevenueLineItem(RevenueLineItem.REV_CHC, null, dos, units);
    }

    static RevenueLineItem irc(LocalDate dos, int units) {
        return new RevenueLineItem(RevenueLineItem.REV_IRC, null, dos, units);
    }

    static RevenueLineItem gic(LocalDate dos, int units) {
        return new RevenueLineItem(RevenueLineItem.REV_GIC, null, dos, units);
    }

    static BigDecimal bd(String val) {
        return new BigDecimal(val);
    }
}
