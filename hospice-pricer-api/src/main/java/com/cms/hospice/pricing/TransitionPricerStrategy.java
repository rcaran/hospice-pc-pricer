package com.cms.hospice.pricing;

import com.cms.hospice.model.*;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

/**
 * FY2007.1 – FY2013 pricing strategy.
 *
 * Key changes from SimplePricerStrategy:
 * - CHC (0652) units are now in 15-minute blocks (not whole hours)
 * - If CHC units < 32 (< 8 hours) AND units > 0: pay one RHC day rate
 * - If CHC units >= 32: pay CHC formula using UNITS/4 as hours
 * - No minimum hours check (RTC=20 no longer applies here)
 * - No QIP, no 60-day split, no SIA
 *
 * CHC formula when units >= 32:
 * (((chcLs * beneWI) + chcNls) / 24) * (units / 4) ROUNDED
 * CHC formula when 0 < units < 32:
 * ((rhcHighLs * beneWI) + rhcHighNls) ROUNDED (single day)
 *
 * RHC, IRC, GIC formulas: same as SimplePricerStrategy.
 */
@Component("transitionPricerStrategy")
public class TransitionPricerStrategy implements FiscalYearStrategy {

    @Override
    public PricingResult calculate(HospiceClaim claim, FiscalYearRates rates) {
        if (anyUnitOver1000(claim)) {
            return PricingResult.error(ReturnCode.ERROR_10);
        }

        BigDecimal pay1 = BigDecimal.ZERO;
        BigDecimal pay2 = BigDecimal.ZERO;
        BigDecimal pay3 = BigDecimal.ZERO;
        BigDecimal pay4 = BigDecimal.ZERO;

        RevenueLineItem li1 = claim.lineItem1();
        if (li1 != null && li1.isRhc() && li1.units() > 0) {
            pay1 = PaymentCalculator.perDiem(
                    rates.rhcHighLs(), rates.rhcHighNls(),
                    claim.beneficiaryWageIndex(), li1.units());
        }

        RevenueLineItem li2 = claim.lineItem2();
        if (li2 != null && li2.isChc() && li2.units() > 0) {
            if (li2.units() < 32) {
                // Pay a single RHC-rate day (no units multiplier)
                pay2 = PaymentCalculator.perDiem(
                        rates.rhcHighLs(), rates.rhcHighNls(),
                        claim.beneficiaryWageIndex(), 1);
            } else {
                pay2 = PaymentCalculator.chcFromQuarters(
                        rates.chcLs(), rates.chcNls(),
                        claim.beneficiaryWageIndex(), li2.units());
            }
        }

        RevenueLineItem li3 = claim.lineItem3();
        if (li3 != null && li3.isIrc() && li3.units() > 0) {
            pay3 = PaymentCalculator.perDiem(
                    rates.ircLs(), rates.ircNls(),
                    claim.providerWageIndex(), li3.units());
        }

        RevenueLineItem li4 = claim.lineItem4();
        if (li4 != null && li4.isGic() && li4.units() > 0) {
            pay4 = PaymentCalculator.perDiem(
                    rates.gicLs(), rates.gicNls(),
                    claim.providerWageIndex(), li4.units());
        }

        BigDecimal total = pay1.add(pay2).add(pay3).add(pay4);

        return new PricingResult(
                pay1, pay2, pay3, pay4, total,
                ReturnCode.SUCCESS_00.getCode(),
                0, 0,
                new BigDecimal[7],
                BigDecimal.ZERO, BigDecimal.ZERO);
    }

    private boolean anyUnitOver1000(HospiceClaim claim) {
        return unitOver1000(claim.lineItem1())
                || unitOver1000(claim.lineItem2())
                || unitOver1000(claim.lineItem3())
                || unitOver1000(claim.lineItem4());
    }

    private boolean unitOver1000(RevenueLineItem li) {
        return li != null && li.units() > 1000;
    }
}
