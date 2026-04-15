package com.cms.hospice.model;

import java.math.BigDecimal;

/**
 * All rate constants for a single fiscal year period.
 * For FY1998-FY2015: rhcHighLs/rhcHighNls == rhcLowLs/rhcLowNls (single RHC
 * rate, no split).
 * For FY2016.1+: HIGH and LOW are distinct rates.
 */
public record FiscalYearRates(
        String fiscalYear,

        // RHC rates — called "HIGH" for FY2016.1+ split; used as single rate otherwise
        BigDecimal rhcHighLs,
        BigDecimal rhcHighNls,
        // RHC LOW (only meaningful when has60DaySplit = true)
        BigDecimal rhcLowLs,
        BigDecimal rhcLowNls,

        // CHC rates
        BigDecimal chcLs,
        BigDecimal chcNls,

        // IRC rates
        BigDecimal ircLs,
        BigDecimal ircNls,

        // GIC rates
        BigDecimal gicLs,
        BigDecimal gicNls,

        // QIP variants (null/same as standard for pre-FY2014)
        BigDecimal rhcHighLsQ,
        BigDecimal rhcHighNlsQ,
        BigDecimal rhcLowLsQ,
        BigDecimal rhcLowNlsQ,
        BigDecimal chcLsQ,
        BigDecimal chcNlsQ,
        BigDecimal ircLsQ,
        BigDecimal ircNlsQ,
        BigDecimal gicLsQ,
        BigDecimal gicNlsQ,

        // Feature flags
        boolean hasQip, // FY2014+
        boolean has60DaySplit, // FY2016.1+
        boolean hasSia, // FY2016.1+
        boolean chcIn15MinUnits, // FY2007.1+
        boolean hasMinChc8Hours // FY1998-FY2007 only
) {
    /** Returns the effective RHC HIGH LS (or single-rate LS if no split). */
    public BigDecimal effectiveRhcHighLs(boolean qip) {
        return (qip && hasQip) ? rhcHighLsQ : rhcHighLs;
    }

    public BigDecimal effectiveRhcHighNls(boolean qip) {
        return (qip && hasQip) ? rhcHighNlsQ : rhcHighNls;
    }

    public BigDecimal effectiveRhcLowLs(boolean qip) {
        return (qip && hasQip) ? rhcLowLsQ : rhcLowLs;
    }

    public BigDecimal effectiveRhcLowNls(boolean qip) {
        return (qip && hasQip) ? rhcLowNlsQ : rhcLowNls;
    }

    public BigDecimal effectiveChcLs(boolean qip) {
        return (qip && hasQip) ? chcLsQ : chcLs;
    }

    public BigDecimal effectiveChcNls(boolean qip) {
        return (qip && hasQip) ? chcNlsQ : chcNls;
    }

    public BigDecimal effectiveIrcLs(boolean qip) {
        return (qip && hasQip) ? ircLsQ : ircLs;
    }

    public BigDecimal effectiveIrcNls(boolean qip) {
        return (qip && hasQip) ? ircNlsQ : ircNls;
    }

    public BigDecimal effectiveGicLs(boolean qip) {
        return (qip && hasQip) ? gicLsQ : gicLs;
    }

    public BigDecimal effectiveGicNls(boolean qip) {
        return (qip && hasQip) ? gicNlsQ : gicNls;
    }
}
