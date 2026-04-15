package com.cms.hospice.api;

import com.cms.hospice.model.PricingResult;
import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.v3.oas.annotations.media.Schema;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;

/**
 * Outbound JSON response for a hospice claim pricing operation.
 * Maps directly from {@link PricingResult}.
 */
@Schema(description = "Hospice claim pricing response")
@JsonInclude(JsonInclude.Include.NON_NULL)
public record PricingResponse(
                @Schema(description = "Payment amount for revenue code 0651 (RHC)", example = "195.45") BigDecimal payAmt1,

                @Schema(description = "Payment amount for revenue code 0652 (CHC)", example = "0.00") BigDecimal payAmt2,

                @Schema(description = "Payment amount for revenue code 0655 (IRC)", example = "0.00") BigDecimal payAmt3,

                @Schema(description = "Payment amount for revenue code 0656 (GIC)", example = "0.00") BigDecimal payAmt4,

                @Schema(description = "Sum of all line item payments", example = "5863.50") BigDecimal payAmountTotal,

                @Schema(description = "Return/reason code: '00'=success (pre-FY2016.1); '73'/'74'/'75'/'77'=FY2016.1+ success variants; "
                                +
                                "'10'=units>1000; '20'=invalid revenue code; '30'=invalid date; '40'=provider not found; "
                                +
                                "'50'/'51'=wage index not found", example = "73") String returnCode,

                @Schema(description = "Number of RHC days priced at HIGH rate (FY2016.1+ only, ≤60 days from admission)", example = "5") int highRhcDays,

                @Schema(description = "Number of RHC days priced at LOW rate (FY2016.1+ only, >60 days from admission)", example = "5") int lowRhcDays,

                @Schema(description = "End-of-life SIA add-on payment per day for up to 7 days (FY2016.1+ only)") List<BigDecimal> eolAddOnDayPayments,

                @Schema(description = "Non-applicable add-on payment 1", example = "0.00") BigDecimal naAddOnPay1,

                @Schema(description = "Non-applicable add-on payment 2", example = "0.00") BigDecimal naAddOnPay2) {

        public static PricingResponse from(PricingResult result) {
                List<BigDecimal> eolList = result.eolAddOnDayPayments() != null
                                ? Arrays.asList(result.eolAddOnDayPayments())
                                : List.of();
                return new PricingResponse(
                                result.payAmt1(),
                                result.payAmt2(),
                                result.payAmt3(),
                                result.payAmt4(),
                                result.payAmountTotal(),
                                result.returnCode(),
                                result.highRhcDays(),
                                result.lowRhcDays(),
                                eolList,
                                result.naAddOnPay1(),
                                result.naAddOnPay2());
        }
}
