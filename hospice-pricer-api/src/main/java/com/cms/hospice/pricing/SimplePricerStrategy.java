package com.cms.hospice.pricing;

import com.cms.hospice.model.*;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

/**
 * FY1998 – FY2007 pricing strategy.
 *
 * Key characteristics:
 * - No 60-day RHC split (single RHC rate)
 * - No QIP reduction
 * - No SIA add-on
 * - CHC (0652) units are full hours; minimum 8 hours required
 * - RHC and CHC use beneficiary wage index
 * - IRC and GIC use provider wage index
 *
 * Formula per revenue code:
 * RHC: ((rhcHighLs * beneWI) + rhcHighNls) * units ROUNDED
 * CHC: (((chcLs * beneWI) + chcNls) / 24) * units ROUNDED
 * IRC: ((ircLs * provWI) + ircNls) * units ROUNDED
 * GIC: ((gicLs * provWI) + gicNls) * units ROUNDED
 *
 * Return codes:
 * 00 = success
 * 10 = any unit > 1000 (bad units)
 * 20 = CHC present AND UNITS2 < 8
 */
@Component("simplePricerStrategy")
public class SimplePricerStrategy implements FiscalYearStrategy {

    @Override
    public PricingResult calculate(HospiceClaim claim, FiscalYearRates rates) {
        // Validate units
        if (anyUnitOver1000(claim)) {
            return PricingResult.error(ReturnCode.ERROR_10);
        }

        RevenueLineItem li2 = claim.lineItem2();
        if (li2 != null && li2.isChc() && li2.units() < 8) {
            return PricingResult.error(ReturnCode.ERROR_20);
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

        if (li2 != null && li2.isChc() && li2.units() > 0) {
            pay2 = PaymentCalculator.chcHourly(
                    rates.chcLs(), rates.chcNls(),
                    claim.beneficiaryWageIndex(), li2.units());
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
