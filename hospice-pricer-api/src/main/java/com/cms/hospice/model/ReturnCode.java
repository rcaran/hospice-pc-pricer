package com.cms.hospice.model;

public enum ReturnCode {
    SUCCESS_00("00", "Success"),
    SUCCESS_73("73", "Success — Low RHC, no SIA"),
    SUCCESS_74("74", "Success — Low RHC with SIA"),
    SUCCESS_75("75", "Success — High/Split RHC, no SIA"),
    SUCCESS_77("77", "Success — High/Split RHC with SIA"),
    ERROR_10("10", "Invalid units — one or more revenue code units exceed 1,000"),
    ERROR_20("20", "Invalid CHC units — minimum 8 hours required for this fiscal year"),
    ERROR_30("30", "CBSA/MSA code not found in wage index table"),
    ERROR_40("40", "Provider wage index is zero or missing"),
    ERROR_50("50", "Beneficiary wage index is zero or missing"),
    ERROR_51("51", "Provider not found in provider table");

    private final String code;
    private final String description;

    ReturnCode(String code, String description) {
        this.code = code;
        this.description = description;
    }

    public String getCode() {
        return code;
    }

    public String getDescription() {
        return description;
    }

    public boolean isError() {
        return switch (this) {
            case ERROR_10, ERROR_20, ERROR_30, ERROR_40, ERROR_50, ERROR_51 -> true;
            default -> false;
        };
    }

    public static ReturnCode fromCode(String code) {
        for (ReturnCode rc : values()) {
            if (rc.code.equals(code)) {
                return rc;
            }
        }
        throw new IllegalArgumentException("Unknown return code: " + code);
    }
}
