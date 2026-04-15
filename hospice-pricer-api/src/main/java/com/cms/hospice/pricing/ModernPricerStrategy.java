package com.cms.hospice.pricing;

import com.cms.hospice.model.*;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

/**
 * FY2014 – FY2016 (Oct 2015 release) pricing strategy.
 *
 * Key addition over TransitionPricerStrategy:
 * - QIP indicator: if BILL-QIP-IND = '1', use QIP-reduced rates (Q variants)
 * - Otherwise identical to TransitionPricerStrategy (CHC in 15-min units)
 * - Still no 60-day RHC split; still no SIA
 *
 * Covers fiscalYears: FY2014, FY2015, FY2016 (Oct 2015 release only).
 * FY2016.1 (Jan 2016+) is handled by FullPricerStrategy.
 */
@Component("modernPricerStrategy")
public class ModernPricerStrategy implements FiscalYearStrategy {

    @Override
    public PricingResult calculate(HospiceClaim claim, FiscalYearRates rates) {
        if (anyUnitOver1000(claim)) {
            return PricingResult.error(ReturnCode.ERROR_10);
        }

        boolean qip = claim.isQip();

        BigDecimal pay1 = BigDecimal.ZERO;
        BigDecimal pay2 = BigDecimal.ZERO;
        BigDecimal pay3 = BigDecimal.ZERO;
        BigDecimal pay4 = BigDecimal.ZERO;

        RevenueLineItem li1 = claim.lineItem1();
        if (li1 != null && li1.isRhc() && li1.units() > 0) {
            pay1 = PaymentCalculator.perDiem(
                    rates.effectiveRhcHighLs(qip), rates.effectiveRhcHighNls(qip),
                    claim.beneficiaryWageIndex(), li1.units());
        }

        RevenueLineItem li2 = claim.lineItem2();
        if (li2 != null && li2.isChc() && li2.units() > 0) {
            if (li2.units() < 32) {
                // Pay single RHC-rate day
                pay2 = PaymentCalculator.perDiem(
                        rates.effectiveRhcHighLs(qip), rates.effectiveRhcHighNls(qip),
                        claim.beneficiaryWageIndex(), 1);
            } else {
                pay2 = PaymentCalculator.chcFromQuarters(
                        rates.effectiveChcLs(qip), rates.effectiveChcNls(qip),
                        claim.beneficiaryWageIndex(), li2.units());
            }
        }

        RevenueLineItem li3 = claim.lineItem3();
        if (li3 != null && li3.isIrc() && li3.units() > 0) {
            pay3 = PaymentCalculator.perDiem(
                    rates.effectiveIrcLs(qip), rates.effectiveIrcNls(qip),
                    claim.providerWageIndex(), li3.units());
        }

        RevenueLineItem li4 = claim.lineItem4();
        if (li4 != null && li4.isGic() && li4.units() > 0) {
            pay4 = PaymentCalculator.perDiem(
                    rates.effectiveGicLs(qip), rates.effectiveGicNls(qip),
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
