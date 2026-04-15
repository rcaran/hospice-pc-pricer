package com.cms.hospice.api;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;

import java.util.List;

/**
 * Inbound JSON request for hospice claim pricing.
 * All string codes are trimmed and upper-cased by the controller before use.
 */
@Schema(description = "Hospice claim pricing request")
public record PricingRequest(
                @Schema(description = "CMS provider number (6 digits)", example = "341234") @NotBlank String providerNumber,

                @Schema(description = "National Provider Identifier (10 digits)", example = "1234567890") @NotBlank String npi,

                /** Claim FROM date, format YYYYMMDD. */
                @Schema(description = "Claim FROM date in YYYYMMDD format", example = "20210115") @NotBlank @Pattern(regexp = "\\d{8}") String fromDate,

                /** Admission date, format YYYYMMDD. Required for FY2016.1+ split. */
                @Schema(description = "Beneficiary admission date in YYYYMMDD format (required for FY2016.1+ RHC 60-day split)", example = "20201001") @Pattern(regexp = "\\d{8}") String admissionDate,

                /**
                 * Provider CBSA code (5 digits). Used for claims ≥ 2008-01-01;
                 * provider record's CBSA is used for 2006–2007 claims.
                 */
                @Schema(description = "Provider CBSA code (5 digits); used for claims ≥ 2008-01-01", example = "16740") String providerCbsa,

                /** Beneficiary CBSA (or MSA for pre-2006) code. */
                @Schema(description = "Beneficiary CBSA code (5 digits) or MSA code for pre-2006 claims", example = "16740") String beneficiaryCbsa,

                /** Prior RHC benefit days before service date (BILL-NA-ADD-ON-DAY1-UNITS). */
                @Schema(description = "Prior RHC benefit days before the service date", example = "0") @Min(0) @Max(9999) int priorBenefitDays,

                /** Second prior benefit days field (BILL-NA-ADD-ON-DAY2-UNITS). */
                @Schema(description = "Second prior benefit days field", example = "0") @Min(0) @Max(9999) int priorBenefitDays2,

                /** EOL SIA add-on units for up to 7 days (15-min units, max 7 elements). */
                @Schema(description = "End-of-life SIA add-on units for up to 7 days (15-minute units each; FY2016.1+ only)", example = "[8, 12, 0, 0, 0, 0, 0]") List<@Min(0) @Max(99) Integer> eolAddOnDayUnits,

                /** QIP indicator: "1" = QIP applies, " " or null = no QIP. */
                @Schema(description = "Quality Improvement Program indicator: '1' = QIP applies, ' ' or omit = no QIP", example = " ") String qipIndicator,

                /** Revenue line items (1–4 items, each with revenue code, HCPC, DOS, units). */
                @Schema(description = "Revenue line items (1–4 items)") @NotEmpty @Size(max = 4) @Valid List<LineItemRequest> lineItems) {

        @Schema(description = "A single revenue line item")
        public record LineItemRequest(
                        @Schema(description = "Revenue code: 0651=RHC, 0652=CHC, 0655=IRC, 0656=GIC", example = "0651", allowableValues = {
                                        "0651", "0652", "0655",
                                        "0656" }) @NotBlank @Pattern(regexp = "0651|0652|0655|0656") String revenueCode,

                        @Schema(description = "HCPC/CPT procedure code (optional)", example = "Q5010") String hcpcCode,

                        /** Date of service, format YYYYMMDD. */
                        @Schema(description = "Date of service in YYYYMMDD format", example = "20210115") @Pattern(regexp = "\\d{8}") String dateOfService,

                        @Schema(description = "Units of service (days for RHC/IRC/GIC; 15-min units for CHC)", example = "30") @Min(0) @Max(9999999) int units) {
        }
}
