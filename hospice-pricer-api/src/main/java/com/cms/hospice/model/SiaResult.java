package com.cms.hospice.model;

import java.math.BigDecimal;

public record SiaResult(
        BigDecimal[] dayPayments, // 7 days
        BigDecimal totalPayment,
        boolean hasSia) {
    public static SiaResult none() {
        BigDecimal[] zeros = new BigDecimal[7];
        for (int i = 0; i < 7; i++)
            zeros[i] = BigDecimal.ZERO;
        return new SiaResult(zeros, BigDecimal.ZERO, false);
    }
}
