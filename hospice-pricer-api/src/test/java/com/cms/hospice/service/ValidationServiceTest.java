package com.cms.hospice.service;

import com.cms.hospice.model.*;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Unit tests for ValidationService.
 * These tests instantiate the service directly (no Spring context).
 */
class ValidationServiceTest {

    private final ValidationService svc = new ValidationService();

    private HospiceClaim claim(String provNo, LocalDate fromDate, LocalDate admDate,
            BigDecimal provWI, BigDecimal beneWI) {
        return new HospiceClaim("1234567890", provNo, fromDate, admDate,
                "16740", "16740", provWI, beneWI,
                0, 0, new int[7], " ", null, null, null, null);
    }

    @Test
    void valid_claim_returnsNull() {
        HospiceClaim c = claim("P001", LocalDate.of(2021, 1, 15), LocalDate.of(2021, 1, 1),
                new BigDecimal("1.0000"), new BigDecimal("1.0000"));
        assertThat(svc.validate(c)).isNull();
    }

    @Test
    void missingProviderNumber_returnsError51() {
        HospiceClaim c = claim("", LocalDate.of(2021, 1, 15), null,
                new BigDecimal("1.0000"), new BigDecimal("1.0000"));
        PricingResult r = svc.validate(c);
        assertThat(r).isNotNull();
        assertThat(r.returnCode()).isEqualTo("51");
    }

    @Test
    void nullProviderNumber_returnsError51() {
        HospiceClaim c = claim(null, LocalDate.of(2021, 1, 15), null,
                new BigDecimal("1.0000"), new BigDecimal("1.0000"));
        assertThat(svc.validate(c).returnCode()).isEqualTo("51");
    }

    @Test
    void nullFromDate_returnsError10() {
        HospiceClaim c = claim("P001", null, null,
                new BigDecimal("1.0000"), new BigDecimal("1.0000"));
        assertThat(svc.validate(c).returnCode()).isEqualTo("10");
    }

    @Test
    void admissionDateAfterFromDate_returnsError10() {
        HospiceClaim c = claim("P001", LocalDate.of(2021, 1, 15), LocalDate.of(2021, 1, 20),
                new BigDecimal("1.0000"), new BigDecimal("1.0000"));
        assertThat(svc.validate(c).returnCode()).isEqualTo("10");
    }

    @Test
    void admissionDateEqualsFromDate_isValid() {
        HospiceClaim c = claim("P001", LocalDate.of(2021, 1, 15), LocalDate.of(2021, 1, 15),
                new BigDecimal("1.0000"), new BigDecimal("1.0000"));
        assertThat(svc.validate(c)).isNull();
    }

    @Test
    void zeroProviderWageIndex_returnsError40() {
        HospiceClaim c = claim("P001", LocalDate.of(2021, 1, 15), null,
                BigDecimal.ZERO, new BigDecimal("1.0000"));
        assertThat(svc.validate(c).returnCode()).isEqualTo("40");
    }

    @Test
    void nullProviderWageIndex_returnsError40() {
        HospiceClaim c = claim("P001", LocalDate.of(2021, 1, 15), null,
                null, new BigDecimal("1.0000"));
        assertThat(svc.validate(c).returnCode()).isEqualTo("40");
    }

    @Test
    void zeroBeneWageIndex_returnsError50() {
        HospiceClaim c = claim("P001", LocalDate.of(2021, 1, 15), null,
                new BigDecimal("1.0000"), BigDecimal.ZERO);
        assertThat(svc.validate(c).returnCode()).isEqualTo("50");
    }
}
