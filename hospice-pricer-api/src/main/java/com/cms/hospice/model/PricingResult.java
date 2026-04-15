package com.cms.hospice.model;

import java.math.BigDecimal;

public record PricingResult(
        BigDecimal payAmt1, // BILL-PAY-AMT1
        BigDecimal payAmt2, // BILL-PAY-AMT2
        BigDecimal payAmt3, // BILL-PAY-AMT3
        BigDecimal payAmt4, // BILL-PAY-AMT4
        BigDecimal payAmountTotal, // BILL-PAY-AMT-TOTAL
        String returnCode, // BILL-RTC
        int highRhcDays, // BILL-HIGH-RHC-DAYS (FY2016.1+)
        int lowRhcDays, // BILL-LOW-RHC-DAYS (FY2016.1+)
        BigDecimal[] eolAddOnDayPayments, // BILL-EOL-ADD-ON-DAY1-7-PAY (7 elements)
        BigDecimal naAddOnPay1, // BILL-NA-ADD-ON-DAY1-PAY
        BigDecimal naAddOnPay2 // BILL-NA-ADD-ON-DAY2-PAY
) {
    public static PricingResult error(ReturnCode rtc) {
        BigDecimal[] zeroEol = new BigDecimal[7];
        for (int i = 0; i < 7; i++)
            zeroEol[i] = BigDecimal.ZERO;
        return new PricingResult(
                BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO,
                BigDecimal.ZERO, rtc.getCode(), 0, 0, zeroEol,
                BigDecimal.ZERO, BigDecimal.ZERO);
    }

    public boolean isError() {
        return ReturnCode.fromCode(returnCode).isError();
    }
}
