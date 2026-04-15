package com.cms.hospice.model;

import java.math.BigDecimal;

public record RhcSplitResult(
        int highDays,
        int lowDays,
        BigDecimal highPayment,
        BigDecimal lowPayment,
        BigDecimal totalPayment) {
    public static RhcSplitResult zero() {
        return new RhcSplitResult(0, 0, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO);
    }

    public boolean hasHighDays() {
        return highDays > 0;
    }

    public boolean hasLowDays() {
        return lowDays > 0;
    }
}
