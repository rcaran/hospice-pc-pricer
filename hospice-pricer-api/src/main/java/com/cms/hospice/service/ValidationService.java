package com.cms.hospice.service;

import com.cms.hospice.model.HospiceClaim;
import com.cms.hospice.model.PricingResult;
import com.cms.hospice.model.ReturnCode;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

/**
 * Validates hospice claim input data prior to pricing.
 * Mirrors the validation logic distributed across COBOL paragraphs
 * 0100-VALIDATE-* in HOSDR210 / HOSPR210.
 */
@Component
public class ValidationService {

    /**
     * Validates the claim. Returns a {@link PricingResult} error if validation
     * fails, or {@code null} if the claim is valid and may proceed to pricing.
     */
    public PricingResult validate(HospiceClaim claim) {

        // Provider number must be present
        if (isEmpty(claim.providerNumber())) {
            return PricingResult.error(ReturnCode.ERROR_51);
        }

        // Claim must have a FROM date
        if (claim.fromDate() == null) {
            return PricingResult.error(ReturnCode.ERROR_10);
        }

        // Admission date must not be after FROM date
        if (claim.admissionDate() != null
                && claim.admissionDate().isAfter(claim.fromDate())) {
            return PricingResult.error(ReturnCode.ERROR_10);
        }

        // Wage indexes must be positive (zero would produce zero payment silently)
        if (!isPositive(claim.providerWageIndex())) {
            return PricingResult.error(ReturnCode.ERROR_40);
        }
        if (!isPositive(claim.beneficiaryWageIndex())) {
            return PricingResult.error(ReturnCode.ERROR_50);
        }

        return null; // valid
    }

    private boolean isEmpty(String s) {
        return s == null || s.isBlank();
    }

    private boolean isPositive(BigDecimal bd) {
        return bd != null && bd.compareTo(BigDecimal.ZERO) > 0;
    }
}
