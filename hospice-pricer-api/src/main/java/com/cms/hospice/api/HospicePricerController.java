package com.cms.hospice.api;

import com.cms.hospice.model.*;
import com.cms.hospice.service.DriverService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * REST endpoint for hospice claim pricing.
 *
 * POST /api/v1/hospice/price
 * → 200 PricingResponse (success or pricing error with RTC 10–51)
 * → 400 validation problem detail (missing/invalid JSON fields)
 * → 422 unprocessable entity (date parse failure)
 * → 500 generic error (unexpected exception)
 */
@Tag(name = "Hospice Pricer", description = "Medicare/Medicaid hospice claim payment calculation")
@RestController
@RequestMapping("/api/v1/hospice")
public class HospicePricerController {

    private static final Logger log = LoggerFactory.getLogger(HospicePricerController.class);
    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyyMMdd");

    private final DriverService driverService;

    public HospicePricerController(DriverService driverService) {
        this.driverService = driverService;
    }

    /**
     * Prices a single hospice claim.
     *
     * @param request inbound claim data (validated by Bean Validation)
     * @return 200 with pricing result; even pricing errors (RTC 10–51) return 200
     *         because they carry business error codes in the response body
     */
    @Operation(summary = "Price a hospice claim", description = "Calculates Medicare/Medicaid payment amounts for a hospice claim. "
            +
            "Returns 200 for both successful pricing and business-level errors (RTC 10–51); " +
            "check `returnCode` in the response body to distinguish them.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Claim priced (check returnCode for business errors)", content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE, schema = @Schema(implementation = PricingResponse.class))),
            @ApiResponse(responseCode = "400", description = "Invalid request — missing required fields or constraint violation", content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE, schema = @Schema(implementation = ErrorResponse.class))),
            @ApiResponse(responseCode = "422", description = "Unprocessable entity — invalid date format", content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE, schema = @Schema(implementation = ErrorResponse.class))),
            @ApiResponse(responseCode = "500", description = "Unexpected server error", content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE, schema = @Schema(implementation = ErrorResponse.class)))
    })
    @PostMapping("/price")
    public ResponseEntity<PricingResponse> price(@Valid @RequestBody PricingRequest request) {
        HospiceClaim claim = mapToClaim(request);
        PricingResult result = driverService.price(claim);
        return ResponseEntity.ok(PricingResponse.from(result));
    }

    // ── mapping ────────────────────────────────────────────────────────────────

    private HospiceClaim mapToClaim(PricingRequest req) {
        LocalDate fromDate = parseDate(req.fromDate());
        LocalDate admissionDate = req.admissionDate() != null ? parseDate(req.admissionDate()) : null;

        int[] eolUnits = new int[7];
        if (req.eolAddOnDayUnits() != null) {
            List<Integer> list = req.eolAddOnDayUnits();
            for (int i = 0; i < Math.min(7, list.size()); i++) {
                Integer v = list.get(i);
                eolUnits[i] = v != null ? v : 0;
            }
        }

        RevenueLineItem li1 = null;
        RevenueLineItem li2 = null;
        RevenueLineItem li3 = null;
        RevenueLineItem li4 = null;

        if (req.lineItems() != null) {
            for (PricingRequest.LineItemRequest li : req.lineItems()) {
                LocalDate dos = li.dateOfService() != null ? parseDate(li.dateOfService()) : null;
                RevenueLineItem item = new RevenueLineItem(
                        li.revenueCode(), li.hcpcCode(), dos, li.units());
                switch (li.revenueCode()) {
                    case RevenueLineItem.REV_RHC -> li1 = item;
                    case RevenueLineItem.REV_CHC -> li2 = item;
                    case RevenueLineItem.REV_IRC -> li3 = item;
                    case RevenueLineItem.REV_GIC -> li4 = item;
                }
            }
        }

        // providerWageIndex and beneficiaryWageIndex start null —
        // DriverService resolves them from CBSA/MSA reference files
        return new HospiceClaim(
                req.npi(),
                req.providerNumber().trim().toUpperCase(),
                fromDate,
                admissionDate,
                req.providerCbsa() != null ? req.providerCbsa().trim() : null,
                req.beneficiaryCbsa() != null ? req.beneficiaryCbsa().trim() : null,
                null, // providerWageIndex — resolved by DriverService
                null, // beneficiaryWageIndex — resolved by DriverService
                req.priorBenefitDays(),
                req.priorBenefitDays2(),
                eolUnits,
                req.qipIndicator() != null ? req.qipIndicator().trim() : " ",
                li1, li2, li3, li4);
    }

    private LocalDate parseDate(String s) {
        if (s == null || s.isBlank())
            return null;
        try {
            return LocalDate.parse(s.trim(), DATE_FMT);
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException("Invalid date format (expected yyyyMMdd): " + s, e);
        }
    }

    // ── exception handlers ─────────────────────────────────────────────────────

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ErrorResponse> handleDateParseError(IllegalArgumentException ex) {
        log.debug("Request rejected: {}", ex.getMessage());
        return ResponseEntity.unprocessableEntity()
                .body(new ErrorResponse("INVALID_DATE", ex.getMessage()));
    }

    @ExceptionHandler({ MethodArgumentNotValidException.class, HttpMessageNotReadableException.class })
    public ResponseEntity<ErrorResponse> handleBadRequest(Exception ex) {
        log.debug("Request rejected - validation/parse error: {}", ex.getMessage());
        return ResponseEntity.badRequest()
                .body(new ErrorResponse("BAD_REQUEST", "Invalid request"));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleUnexpected(Exception ex) {
        log.error("Unexpected error pricing claim", ex);
        return ResponseEntity.internalServerError()
                .body(new ErrorResponse("INTERNAL_ERROR", "An unexpected error occurred"));
    }

    /** Minimal error body that avoids leaking stack traces. */
    public record ErrorResponse(String code, String message) {
    }
}
