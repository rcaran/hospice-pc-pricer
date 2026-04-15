package com.cms.hospice.service;

import com.cms.hospice.model.FiscalYearRates;
import com.cms.hospice.pricing.*;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

/**
 * Unit tests for FiscalYearRouter.
 * Uses the full Spring context to load all rate YAML files.
 */
@SpringBootTest
@TestPropertySource(properties = {
        "hospice.data.cbsa-file=classpath:data/CBSA2021",
        "hospice.data.msa-file=classpath:data/MSAFILE",
        "hospice.data.provider-file=classpath:data/PROVFILE"
})
class FiscalYearRouterTest {

    @Autowired
    private FiscalYearRouter router;

    // ── Route to correct strategy ─────────────────────────────────────────────

    @Test
    void fy1998_routesToSimpleStrategy() {
        FiscalYearRouter.FyEntry entry = router.resolve(LocalDate.of(1998, 1, 15));
        assertThat(entry.fiscalYearId()).isEqualTo("FY1998");
        assertThat(entry.strategy()).isInstanceOf(SimplePricerStrategy.class);
    }

    @Test
    void fy2006_routesToSimpleStrategy() {
        // FY2006: Oct 2005 – Sep 2006
        FiscalYearRouter.FyEntry entry = router.resolve(LocalDate.of(2006, 3, 15));
        assertThat(entry.fiscalYearId()).isEqualTo("FY2006");
        assertThat(entry.strategy()).isInstanceOf(SimplePricerStrategy.class);
    }

    @Test
    void fy2007_oct_routesToSimpleStrategy() {
        // Oct 1 2006 = FY2007 (still Simple — CHC in hours)
        FiscalYearRouter.FyEntry entry = router.resolve(LocalDate.of(2006, 10, 1));
        assertThat(entry.fiscalYearId()).isEqualTo("FY2007");
        assertThat(entry.strategy()).isInstanceOf(SimplePricerStrategy.class);
    }

    @Test
    void fy2007_1_jan_routesToTransitionStrategy() {
        // Jan 1 2007 = FY2007_1 (CHC in 15-min units)
        FiscalYearRouter.FyEntry entry = router.resolve(LocalDate.of(2007, 1, 1));
        assertThat(entry.fiscalYearId()).isEqualTo("FY2007_1");
        assertThat(entry.strategy()).isInstanceOf(TransitionPricerStrategy.class);
    }

    @Test
    void fy2013_routesToTransitionStrategy() {
        FiscalYearRouter.FyEntry entry = router.resolve(LocalDate.of(2013, 5, 15));
        assertThat(entry.fiscalYearId()).isEqualTo("FY2013");
        assertThat(entry.strategy()).isInstanceOf(TransitionPricerStrategy.class);
    }

    @Test
    void fy2014_oct_routesToModernStrategy() {
        FiscalYearRouter.FyEntry entry = router.resolve(LocalDate.of(2013, 10, 1));
        assertThat(entry.fiscalYearId()).isEqualTo("FY2014");
        assertThat(entry.strategy()).isInstanceOf(ModernPricerStrategy.class);
    }

    @Test
    void fy2016_oct_routesToModernStrategy_noSplit() {
        // Oct 1 2015 = FY2016 (no 60-day split yet)
        FiscalYearRouter.FyEntry entry = router.resolve(LocalDate.of(2015, 10, 1));
        assertThat(entry.fiscalYearId()).isEqualTo("FY2016");
        assertThat(entry.strategy()).isInstanceOf(ModernPricerStrategy.class);
        assertThat(entry.rates().has60DaySplit()).isFalse();
    }

    @Test
    void fy2016_1_jan_routesToFullStrategy() {
        // Jan 1 2016 = FY2016_1 (60-day split + SIA)
        FiscalYearRouter.FyEntry entry = router.resolve(LocalDate.of(2016, 1, 1));
        assertThat(entry.fiscalYearId()).isEqualTo("FY2016_1");
        assertThat(entry.strategy()).isInstanceOf(FullPricerStrategy.class);
        assertThat(entry.rates().has60DaySplit()).isTrue();
        assertThat(entry.rates().hasSia()).isTrue();
    }

    @Test
    void fy2021_routesToFullStrategy() {
        FiscalYearRouter.FyEntry entry = router.resolve(LocalDate.of(2021, 6, 15));
        assertThat(entry.fiscalYearId()).isEqualTo("FY2021");
        assertThat(entry.strategy()).isInstanceOf(FullPricerStrategy.class);
    }

    @Test
    void fy2001a_midYearChange() {
        // Apr 1 2001 = FY2001A
        FiscalYearRouter.FyEntry entry = router.resolve(LocalDate.of(2001, 4, 1));
        assertThat(entry.fiscalYearId()).isEqualTo("FY2001A");
    }

    // ── Boundary: date before all FYs ─────────────────────────────────────────

    @Test
    void dateBefore1997Oct_throwsIllegalArgument() {
        assertThatThrownBy(() -> router.resolve(LocalDate.of(1997, 9, 30)))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("predates");
    }

    // ── Rates are pre-loaded ──────────────────────────────────────────────────

    @Test
    void ratesArePreLoadedInEntry() {
        FiscalYearRouter.FyEntry entry = router.resolve(LocalDate.of(2021, 6, 15));
        FiscalYearRates rates = entry.rates();

        assertThat(rates).isNotNull();
        assertThat(rates.rhcHighLs()).isGreaterThan(java.math.BigDecimal.ZERO);
    }
}
