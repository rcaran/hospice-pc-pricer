package com.cms.hospice.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public record WageIndexEntry(
        String code, // CBSA code (5-char) or MSA code
        LocalDate effectiveDate,
        BigDecimal wageIndex) {
}
