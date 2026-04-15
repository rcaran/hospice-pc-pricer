package com.cms.hospice.service;

import com.cms.hospice.config.RateProvider;
import com.cms.hospice.model.FiscalYearRates;
import com.cms.hospice.pricing.*;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.NavigableMap;
import java.util.TreeMap;

/**
 * Routes a claim's FROM-DATE to the correct {@link FiscalYearStrategy} and
 * {@link FiscalYearRates}.
 *
 * A NavigableMap is keyed by the first calendar date on which each fiscal year
 * (or mid-year update) becomes effective. {@code floorEntry(fromDate)} returns
 * the most recent entry whose key is ≤ the claim date — exactly the COBOL
 * sequential IF chain, but in O(log n) time.
 *
 * Mid-year transitions (FY2001A = Apr 1 2001, FY2007_1 = Jan 1 2007,
 * FY2016_1 = Jan 1 2016) are distinct keys, allowing accurate routing without
 * special-casing.
 *
 * The earliest supported claim date maps to FY1998 (Oct 1 1997).
 */
@Component
public class FiscalYearRouter {

    private final RateProvider rateProvider;
    private final SimplePricerStrategy simpleStrategy;
    private final TransitionPricerStrategy transitionStrategy;
    private final ModernPricerStrategy modernStrategy;
    private final FullPricerStrategy fullStrategy;

    /** Entry = (firstEffectiveDate → (fyId, strategy)) */
    private final NavigableMap<LocalDate, FyEntry> routeMap = new TreeMap<>();

    public FiscalYearRouter(RateProvider rateProvider,
            SimplePricerStrategy simpleStrategy,
            TransitionPricerStrategy transitionStrategy,
            ModernPricerStrategy modernStrategy,
            FullPricerStrategy fullStrategy) {
        this.rateProvider = rateProvider;
        this.simpleStrategy = simpleStrategy;
        this.transitionStrategy = transitionStrategy;
        this.modernStrategy = modernStrategy;
        this.fullStrategy = fullStrategy;
    }

    @PostConstruct
    void buildRouteMap() {
        // ── Simple (CHC-in-hours, min 8h) ──────────────────────────────────
        addSimple("1997-10-01", "FY1998");
        addSimple("1998-10-01", "FY1999");
        addSimple("1999-10-01", "FY2000");
        addSimple("2000-10-01", "FY2001");
        addSimple("2001-04-01", "FY2001A"); // mid-year Apr 2001
        addSimple("2001-10-01", "FY2002");
        addSimple("2002-10-01", "FY2003");
        addSimple("2003-10-01", "FY2004");
        addSimple("2004-10-01", "FY2005");
        addSimple("2005-10-01", "FY2006");
        addSimple("2006-10-01", "FY2007");

        // ── Transition (CHC in 15-min quarters) ────────────────────────────
        addTransition("2007-01-01", "FY2007_1"); // mid-year Jan 2007
        addTransition("2007-10-01", "FY2008");
        addTransition("2008-10-01", "FY2009");
        addTransition("2009-10-01", "FY2010");
        addTransition("2010-10-01", "FY2011");
        addTransition("2011-10-01", "FY2012");
        addTransition("2012-10-01", "FY2013");

        // ── Modern (adds QIP) ───────────────────────────────────────────────
        addModern("2013-10-01", "FY2014");
        addModern("2014-10-01", "FY2015");
        addModern("2015-10-01", "FY2016"); // Oct 2015 release — no split

        // ── Full (60-day split + SIA) ───────────────────────────────────────
        addFull("2016-01-01", "FY2016_1"); // mid-year Jan 2016
        addFull("2016-10-01", "FY2017");
        addFull("2017-10-01", "FY2018");
        addFull("2018-10-01", "FY2019");
        addFull("2019-10-01", "FY2020");
        addFull("2020-10-01", "FY2021");
    }

    /**
     * Resolves the effective strategy and rates for the given claim date.
     *
     * @param fromDate the BILL-FROM-DATE of the claim
     * @return resolved entry (never null if fromDate >= 1997-10-01)
     * @throws IllegalArgumentException if fromDate predates all supported FYs
     */
    public FyEntry resolve(LocalDate fromDate) {
        var entry = routeMap.floorEntry(fromDate);
        if (entry == null) {
            throw new IllegalArgumentException(
                    "Claim date " + fromDate + " predates the earliest supported fiscal year (FY1998).");
        }
        return entry.getValue();
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    private void addSimple(String date, String fyId) {
        routeMap.put(LocalDate.parse(date),
                new FyEntry(fyId, simpleStrategy, rateProvider.getRates(fyId)));
    }

    private void addTransition(String date, String fyId) {
        routeMap.put(LocalDate.parse(date),
                new FyEntry(fyId, transitionStrategy, rateProvider.getRates(fyId)));
    }

    private void addModern(String date, String fyId) {
        routeMap.put(LocalDate.parse(date),
                new FyEntry(fyId, modernStrategy, rateProvider.getRates(fyId)));
    }

    private void addFull(String date, String fyId) {
        routeMap.put(LocalDate.parse(date),
                new FyEntry(fyId, fullStrategy, rateProvider.getRates(fyId)));
    }

    // ── inner value type ─────────────────────────────────────────────────────

    /**
     * Immutable tuple: fiscal year ID + strategy + pre-loaded rates.
     */
    public record FyEntry(
            String fiscalYearId,
            FiscalYearStrategy strategy,
            FiscalYearRates rates) {
    }
}
