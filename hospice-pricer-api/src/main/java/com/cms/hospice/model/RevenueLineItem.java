package com.cms.hospice.model;

import java.time.LocalDate;

public record RevenueLineItem(
        String revenueCode,
        String hcpcCode,
        LocalDate dateOfService,
        int units) {
    public static final String REV_RHC = "0651";
    public static final String REV_CHC = "0652";
    public static final String REV_IRC = "0655";
    public static final String REV_GIC = "0656";

    public boolean isRhc() {
        return REV_RHC.equals(revenueCode);
    }

    public boolean isChc() {
        return REV_CHC.equals(revenueCode);
    }

    public boolean isIrc() {
        return REV_IRC.equals(revenueCode);
    }

    public boolean isGic() {
        return REV_GIC.equals(revenueCode);
    }
}
