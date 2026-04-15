package com.cms.hospice.pricing;

import com.cms.hospice.model.FiscalYearRates;
import com.cms.hospice.model.HospiceClaim;
import com.cms.hospice.model.PricingResult;

/**
 * Strategy interface for fiscal-year-specific payment calculation.
 * Each implementation handles one group of fiscal years that share the same
 * pricing logic, eliminating the 5 000-line COBOL paragraph-per-FY pattern.
 */
public interface FiscalYearStrategy {

    /**
     * Computes the payment for a single hospice claim.
     *
     * @param claim the input claim (wage indexes already populated by
     *              DriverService)
     * @param rates the effective fiscal year rates
     * @return the complete pricing result
     */
    PricingResult calculate(HospiceClaim claim, FiscalYearRates rates);
}
