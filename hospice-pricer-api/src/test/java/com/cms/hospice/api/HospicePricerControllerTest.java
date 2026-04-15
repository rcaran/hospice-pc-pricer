package com.cms.hospice.api;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

import java.math.BigDecimal;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * End-to-end integration test for POST /api/v1/hospice/price.
 *
 * Starts the full Spring Boot context with real data files (CBSA2021, PROVFILE,
 * MSAFILE)
 * and verifies the complete pricing pipeline from HTTP request to JSON
 * response.
 *
 * Uses provider 341234 (CBSA 16740, Charlotte NC) which is included in the
 * PROVFILE packaged in src/main/resources/data/.
 */
@SpringBootTest
@AutoConfigureMockMvc
@TestPropertySource(properties = {
    "hospice.data.cbsa-file=classpath:data/CBSA2021",
    "hospice.data.msa-file=classpath:data/MSAFILE",
    "hospice.data.provider-file=classpath:data/PROVFILE"
})
class HospicePricerControllerTest {

  @Autowired
  private MockMvc mockMvc;

  @Autowired
  private ObjectMapper objectMapper;

  private static final String PRICE_URL = "/api/v1/hospice/price";

  // ── Valid claim ────────────────────────────────────────────────────────────

  @Test
  void validClaim_rhcAllLow_returns200WithRtc73() throws Exception {
    // FY2021, RHC 30 units, ADM=2020-10-01, DOS=2021-01-15 → priorSvcDays=106 → ALL
    // LOW
    String request = """
        {
          "providerNumber": "341234",
          "npi": "1234567890",
          "fromDate": "20210115",
          "admissionDate": "20201001",
          "providerCbsa": "16740",
          "beneficiaryCbsa": "16740",
          "priorBenefitDays": 0,
          "priorBenefitDays2": 0,
          "qipIndicator": " ",
          "lineItems": [
            {
              "revenueCode": "0651",
              "dateOfService": "20210115",
              "units": 30
            }
          ]
        }
        """;

    String responseJson = mockMvc.perform(post(PRICE_URL)
        .contentType(MediaType.APPLICATION_JSON)
        .content(request))
        .andExpect(status().isOk())
        .andExpect(content().contentType(MediaType.APPLICATION_JSON))
        .andReturn()
        .getResponse()
        .getContentAsString();

    PricingResponse response = objectMapper.readValue(responseJson, PricingResponse.class);

    assertThat(response.returnCode()).isEqualTo("73");
    assertThat(response.highRhcDays()).isEqualTo(0);
    assertThat(response.lowRhcDays()).isEqualTo(30);
    assertThat(response.payAmountTotal()).isGreaterThan(BigDecimal.ZERO);
    assertThat(response.payAmt1()).isGreaterThan(BigDecimal.ZERO);
    // No SIA
    assertThat(response.eolAddOnDayPayments()).allMatch(p -> p.compareTo(BigDecimal.ZERO) == 0);
  }

  @Test
  void validClaim_rtc10_unitsOver1000_returns200WithZeroPayment() throws Exception {
    // Units > 1000 → RTC=10, all payments zero
    String request = """
        {
          "providerNumber": "341234",
          "npi": "1234567890",
          "fromDate": "20210115",
          "admissionDate": "20210110",
          "providerCbsa": "16740",
          "beneficiaryCbsa": "16740",
          "priorBenefitDays": 0,
          "priorBenefitDays2": 0,
          "qipIndicator": " ",
          "lineItems": [
            {
              "revenueCode": "0651",
              "dateOfService": "20210115",
              "units": 1500
            }
          ]
        }
        """;

    String responseJson = mockMvc.perform(post(PRICE_URL)
        .contentType(MediaType.APPLICATION_JSON)
        .content(request))
        .andExpect(status().isOk())
        .andReturn()
        .getResponse()
        .getContentAsString();

    PricingResponse response = objectMapper.readValue(responseJson, PricingResponse.class);

    assertThat(response.returnCode()).isEqualTo("10");
    assertThat(response.payAmountTotal()).isEqualByComparingTo("0.00");
  }

  // ── Invalid requests → 400 ─────────────────────────────────────────────────

  @Test
  void missingProviderNumber_returns400() throws Exception {
    // providerNumber is @NotBlank — omitting it triggers Bean Validation
    String request = """
        {
          "npi": "1234567890",
          "fromDate": "20210115",
          "priorBenefitDays": 0,
          "priorBenefitDays2": 0,
          "lineItems": [
            {
              "revenueCode": "0651",
              "dateOfService": "20210115",
              "units": 30
            }
          ]
        }
        """;

    mockMvc.perform(post(PRICE_URL)
        .contentType(MediaType.APPLICATION_JSON)
        .content(request))
        .andExpect(status().isBadRequest());
  }

  @Test
  void missingFromDate_returns400() throws Exception {
    // fromDate is @NotBlank
    String request = """
        {
          "providerNumber": "341234",
          "npi": "1234567890",
          "priorBenefitDays": 0,
          "priorBenefitDays2": 0,
          "lineItems": [
            {
              "revenueCode": "0651",
              "dateOfService": "20210115",
              "units": 30
            }
          ]
        }
        """;

    mockMvc.perform(post(PRICE_URL)
        .contentType(MediaType.APPLICATION_JSON)
        .content(request))
        .andExpect(status().isBadRequest());
  }

  @Test
  void emptyLineItems_returns400() throws Exception {
    // lineItems is @NotEmpty
    String request = """
        {
          "providerNumber": "341234",
          "npi": "1234567890",
          "fromDate": "20210115",
          "priorBenefitDays": 0,
          "priorBenefitDays2": 0,
          "lineItems": []
        }
        """;

    mockMvc.perform(post(PRICE_URL)
        .contentType(MediaType.APPLICATION_JSON)
        .content(request))
        .andExpect(status().isBadRequest());
  }

  @Test
  void invalidRevenueCode_returns400() throws Exception {
    // revenueCode must be @Pattern(0651|0652|0655|0656)
    String request = """
        {
          "providerNumber": "341234",
          "npi": "1234567890",
          "fromDate": "20210115",
          "priorBenefitDays": 0,
          "priorBenefitDays2": 0,
          "lineItems": [
            {
              "revenueCode": "9999",
              "dateOfService": "20210115",
              "units": 10
            }
          ]
        }
        """;

    mockMvc.perform(post(PRICE_URL)
        .contentType(MediaType.APPLICATION_JSON)
        .content(request))
        .andExpect(status().isBadRequest());
  }

  @Test
  void malformedJson_returns400() throws Exception {
    mockMvc.perform(post(PRICE_URL)
        .contentType(MediaType.APPLICATION_JSON)
        .content("{not-valid-json}"))
        .andExpect(status().isBadRequest());
  }

  // ── FY2021 RHC with SIA (full pipeline, split + EOL add-on) ───────────────

  @Test
  void validClaim_rhcSplitWithSia_returns200WithRtc77() throws Exception {
    // FY2021, RHC 10 units, ADM=2021-01-19, DOS=2021-03-15 → 55 days → SPLIT (5H +
    // 5L)
    // + SIA EOL days 1=8, 2=12 → RTC=77
    String request = """
        {
          "providerNumber": "341234",
          "npi": "1234567890",
          "fromDate": "20210315",
          "admissionDate": "20210119",
          "providerCbsa": "16740",
          "beneficiaryCbsa": "16740",
          "priorBenefitDays": 0,
          "priorBenefitDays2": 0,
          "eolAddOnDayUnits": [8, 12, 0, 0, 0, 0, 0],
          "qipIndicator": " ",
          "lineItems": [
            {
              "revenueCode": "0651",
              "dateOfService": "20210315",
              "units": 10
            }
          ]
        }
        """;

    String responseJson = mockMvc.perform(post(PRICE_URL)
        .contentType(MediaType.APPLICATION_JSON)
        .content(request))
        .andExpect(status().isOk())
        .andReturn()
        .getResponse()
        .getContentAsString();

    PricingResponse response = objectMapper.readValue(responseJson, PricingResponse.class);

    assertThat(response.returnCode()).isEqualTo("77");
    assertThat(response.highRhcDays()).isEqualTo(5);
    assertThat(response.lowRhcDays()).isEqualTo(5);
    assertThat(response.payAmountTotal()).isGreaterThan(BigDecimal.ZERO);
    // SIA day1 and day2 should have payments > 0
    assertThat(response.eolAddOnDayPayments().get(0)).isGreaterThan(BigDecimal.ZERO);
    assertThat(response.eolAddOnDayPayments().get(1)).isGreaterThan(BigDecimal.ZERO);
  }

  // ── Swagger / OpenAPI availability ────────────────────────────────────────

  @Test
  void swaggerUiIsAvailable() throws Exception {
    mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
        .get("/swagger-ui/index.html"))
        .andExpect(status().isOk());
  }

  @Test
  void openApiJsonIsAvailable() throws Exception {
    mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
        .get("/v3/api-docs"))
        .andExpect(status().isOk())
        .andExpect(content().contentType(MediaType.APPLICATION_JSON));
  }
}
