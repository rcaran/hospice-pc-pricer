# Hospice PC Pricer API

Java/Spring Boot REST API that reimplements the CMS Medicare/Medicaid Hospice payment calculation engine originally coded in COBOL (HOSPR210/HOSDR210). The API provides functional parity with the legacy batch pricer for all fiscal years FY1998–FY2021.

## Overview

The original COBOL system processes hospice claims in a 315-byte fixed-width batch record. This API exposes the same logic as a JSON REST endpoint, enabling:

- On-demand pricing for individual claims
- Modern integration with web/microservice architectures
- Testable, traceable calculation results

The calculation flow mirrors the COBOL architecture:

```
POST /api/v1/hospice/price
        │
        ▼
  DriverService           (mirrors HOSDR210: provider lookup, wage index resolution)
        │
        ▼
  ValidationService       (input validation — return codes 10, 30, 40, 50, 51)
        │
        ▼
  FiscalYearRouter        (date-based routing to FY strategy, O(log n) NavigableMap)
        │
        ▼
  FiscalYearStrategy      (Simple | Transition | Modern | Full)
        │
        ▼
  PaymentCalculator       (revenue code rate × wage index × units)
  RhcSplitCalculator      (FY2016.1+ high/low rate split at 60 days)
  SiaCalculator           (FY2016.1+ SIA end-of-life add-on per day)
```

## Prerequisites

| Tool | Version |
|------|---------|
| Java | 21 |
| Maven | 3.9+ |
| Reference data files | See [Reference Data](#reference-data) |

## Building

```bash
cd hospice-pricer-api
mvn clean package
```

To build and run all tests including the COBOL parity regression suite:

```bash
mvn verify
```

## Running

### With Maven

```bash
mvn spring-boot:run
```

### With the packaged JAR

```bash
java -jar target/hospice-pricer-api-1.0.0-SNAPSHOT.jar
```

The API starts on port **8080** by default.

## Reference Data

The following reference files must be present under `src/main/resources/data/` (they are read at startup):

| File | Description |
|------|-------------|
| `CBSA2021` | Core-Based Statistical Area wage index — ~7,478 records, covering FY2006–FY2021 |
| `MSAFILE` | Legacy MSA wage index for claims prior to 2005-10-01 |
| `PROVFILE` | Provider master (240-byte records; 3 × 80-byte segments, up to 2,400 entries) |

Paths are configurable in `application.yaml`:

```yaml
hospice:
  data:
    cbsa-file: classpath:data/CBSA2021
    msa-file: classpath:data/MSAFILE
    provider-file: classpath:data/PROVFILE
  rates:
    base-path: classpath:rates/
```

Fiscal year payment rates are loaded from `src/main/resources/rates/fy*.yaml` (27 files, FY1998–FY2021). All rate files must be present or the application will refuse to start.

## API Reference

### `POST /api/v1/hospice/price`

Prices a single hospice claim.

#### Request

```json
{
  "providerNumber": "123456",
  "npi": "1234567890",
  "fromDate": "20210101",
  "admissionDate": "20201201",
  "providerCbsa": "35620",
  "beneficiaryCbsa": "35620",
  "priorBenefitDays": 45,
  "priorBenefitDays2": 0,
  "qipIndicator": " ",
  "eolAddOnDayUnits": [4, 4, 4, 0, 0, 0, 0],
  "lineItems": [
    {
      "revenueCode": "0651",
      "hcpcCode": "Q5001",
      "dateOfService": "20210101",
      "units": 1
    }
  ]
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `providerNumber` | string | Yes | 6-character provider number |
| `npi` | string | Yes | 10-digit National Provider Identifier |
| `fromDate` | string | Yes | Claim FROM date, format `YYYYMMDD` |
| `admissionDate` | string | No | Hospice admission date, format `YYYYMMDD` |
| `providerCbsa` | string | No | Provider CBSA code (5 digits); used for claims ≥ 2008-01-01 |
| `beneficiaryCbsa` | string | No | Beneficiary CBSA (or MSA for pre-2006) code |
| `priorBenefitDays` | integer | Yes | Prior RHC benefit days before the service date (0–9999) |
| `priorBenefitDays2` | integer | Yes | Second prior benefit days field (0–9999) |
| `qipIndicator` | string | No | `"1"` = QIP reduction applies; `" "` or omit = no QIP |
| `eolAddOnDayUnits` | integer[] | No | EOL SIA add-on units for up to 7 days (CHC 15-min units, 0–99 each) |
| `lineItems` | array | Yes | 1–4 revenue line items (see below) |

**Line item fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `revenueCode` | string | Yes | One of `0651` (RHC), `0652` (CHC), `0655` (IRC), `0656` (GIC) |
| `hcpcCode` | string | No | HCPC/CPT procedure code |
| `dateOfService` | string | No | Date of service, format `YYYYMMDD` |
| `units` | integer | Yes | Service units (0–9,999,999) |

#### Response

```json
{
  "payAmt1": 136.90,
  "payAmt2": null,
  "payAmt3": null,
  "payAmt4": null,
  "payAmountTotal": 136.90,
  "returnCode": "75",
  "highRhcDays": 1,
  "lowRhcDays": 0,
  "eolAddOnDayPayments": [],
  "naAddOnPay1": null,
  "naAddOnPay2": null
}
```

| Field | Description |
|-------|-------------|
| `payAmt1` | Payment for rev `0651` (RHC) |
| `payAmt2` | Payment for rev `0652` (CHC) |
| `payAmt3` | Payment for rev `0655` (IRC) |
| `payAmt4` | Payment for rev `0656` (GIC) |
| `payAmountTotal` | Sum of all line item payments |
| `returnCode` | Result code (see table below) |
| `highRhcDays` | RHC days priced at HIGH rate (FY2016.1+ only) |
| `lowRhcDays` | RHC days priced at LOW rate (FY2016.1+ only) |
| `eolAddOnDayPayments` | Per-day EOL SIA add-on amounts, up to 7 days (FY2016.1+ only) |
| `naAddOnPay1` / `naAddOnPay2` | Non-administrative add-on payments |

Null fields are omitted from the JSON response.

#### Return Codes

| Code | Status | Description |
|------|--------|-------------|
| `00` | Success | Standard pricing success (FY1998–FY2015 and FY2016) |
| `73` | Success | FY2016.1+: Low RHC days only, no SIA add-on |
| `74` | Success | FY2016.1+: Low RHC days with SIA end-of-life add-on |
| `75` | Success | FY2016.1+: High/split RHC days, no SIA add-on |
| `77` | Success | FY2016.1+: High/split RHC days with SIA end-of-life add-on |
| `10` | Error | Invalid units — one or more revenue code units exceed 1,000 |
| `20` | Error | Invalid CHC units — minimum 8 hours required for this fiscal year |
| `30` | Error | CBSA/MSA code not found in wage index table |
| `40` | Error | Provider wage index is zero or missing |
| `50` | Error | Beneficiary wage index is zero or missing |
| `51` | Error | Provider not found in provider table |

> Business errors (codes 10–51) return HTTP **200** with the error code in the response body, matching the COBOL program's behavior of returning a populated output record in all cases.

#### HTTP Status Codes

| Status | Condition |
|--------|-----------|
| `200` | Successful pricing or business error (RTC 10–51) |
| `400` | Invalid JSON, missing required fields, or constraint violations |
| `422` | Unparseable date fields |
| `500` | Unexpected server error |

## Fiscal Year Coverage

The router supports 27 fiscal year periods, including mid-year updates:

| Period | Effective Date | Strategy |
|--------|----------------|----------|
| FY1998–FY2001 | Oct 1997–Mar 2001 | Simple (CHC in hours, min 8h) |
| FY2001A | Apr 1, 2001 | Simple (mid-year rate update) |
| FY2002–FY2006 | Oct 2001–Sep 2006 | Simple |
| FY2007 | Oct 1, 2006 | Transition (CHC switches to 15-min units) |
| FY2007_1 | Jan 1, 2007 | Transition (mid-year boundary) |
| FY2008–FY2013 | Oct 2007–Sep 2013 | Modern (wage index blending) |
| FY2014–FY2015 | Oct 2013–Sep 2015 | Modern with QIP |
| FY2016 | Oct 1, 2015 | Modern with QIP (no RHC split) |
| FY2016_1 | Jan 1, 2016 | Full (RHC 60-day high/low split + SIA) |
| FY2017–FY2021 | Oct 2016–Sep 2021 | Full |

## Testing

```bash
# Run all tests
mvn test

# Run only the COBOL parity regression suite
mvn test -Dtest=CobolParityRegressionTest

# Generate JaCoCo coverage report (output: target/site/jacoco/index.html)
mvn verify
```

### Test Suites

| Suite | Description |
|-------|-------------|
| `CobolParityRegressionTest` | 1:1 parity checks against HOSPR210/HOSDR210 calculations across all FY strategies; tolerance ±$0.01 |
| `StrategyTest` | Unit tests for each pricing strategy (Simple, Transition, Modern, Full) |
| `PaymentCalculatorTest` | Wage index application and rate multiplication |
| `RhcSplitCalculatorTest` | FY2016.1+ high/low day boundary calculation |
| `SiaCalculatorTest` | End-of-life SIA per-day add-on computation |
| `FiscalYearRouterTest` | Date-to-FY routing coverage including mid-year boundaries |
| `ValidationServiceTest` | Input validation return code coverage |
| `FileParserTest` | Provider and wage index file parsing |
| `RateProviderIntegrationTest` | YAML rate file loading and validation |
| `HospicePricerControllerTest` | REST layer request/response mapping |

## Project Structure

```
hospice-pricer-api/
├── src/main/java/com/cms/hospice/
│   ├── api/                    # REST controller, request/response records
│   ├── config/                 # RateProvider (YAML rate file loader)
│   ├── data/                   # File parsers and repositories (provider, wage index)
│   ├── model/                  # Domain model (HospiceClaim, FiscalYearRates, etc.)
│   ├── pricing/                # Calculation engine (strategies, calculators)
│   ├── service/                # Orchestration (DriverService, FiscalYearRouter, ValidationService)
│   └── HospicePricerApplication.java
├── src/main/resources/
│   ├── application.yaml
│   ├── data/                   # CBSA2021, MSAFILE, PROVFILE reference files
│   └── rates/                  # fy1998.yaml … fy2021.yaml payment rate configs
└── src/test/java/com/cms/hospice/
    ├── api/
    ├── config/
    ├── data/
    ├── pricing/
    ├── regression/             # CobolParityRegressionTest
    └── service/
```

## Related

- **HOSPR210** — Original COBOL pricer module (6,555 lines, `build/HOSPR210.cbl`)
- **HOSDR210** — Original COBOL driver module (997 lines, `build/HOSDR210.cbl`)
- **HOSPRATE** — Payment rates copybook (`build/copy/HOSPRATE.cpy`)
- **docs/regras-negocio-HOSPR210-PricerModule.md** — Detailed business rules documentation (Portuguese)
