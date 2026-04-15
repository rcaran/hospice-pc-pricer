# COBOL-to-Java Migration Specification

## Problem Statement

The Hospice PC Pricer (HOSPR210/HOSDR210) is a 6,500+ line COBOL system running on z/OS mainframe with no unit tests, massive code duplication across 24 fiscal year blocks, hard-coded rates, and fragile sequential routing. Converting to a Java 21 + Spring Boot 4 REST API eliminates mainframe dependency, enables modern testing, and provides a maintainable architecture with externalized configuration.

## Goals

- [ ] 1:1 functional parity with COBOL system across all 24 fiscal years (FY1998–FY2021)
- [ ] All 40 existing test cases (TC01–TC36 + TC08B) pass with identical payment amounts (±$0.01 tolerance)
- [ ] REST API exposing the pricing engine via JSON request/response
- [ ] Comprehensive JUnit 5 test suite covering every FY path, revenue code, validation rule, and edge case
- [ ] Externalized rate configuration (no hard-coded rates in Java code)

## Out of Scope

| Feature | Reason |
|---------|--------|
| CICS online wrapper (HOSOP210) | Production transaction layer; not part of pricer logic |
| New fiscal years beyond FY2021 | Separate future feature after migration verified |
| Database persistence | API is stateless; reference data loaded from files/config |
| Authentication/authorization | Security layer added post-migration |
| Batch file processing mode | REST-only for v1; batch adapter is a future feature |
| UI/frontend | API-only deliverable |
| Production deployment | Plan covers code + tests only |

---

## User Stories

### P1: Core Pricing Engine ⭐ MVP

**User Story**: As a claims processing system, I want to submit a hospice claim and receive the correct payment amount so that I can process Medicare/Medicaid hospice payments.

**Why P1**: This is the core value — reproduce exact COBOL payment calculations.

**Acceptance Criteria**:

1. WHEN a valid claim is submitted with BILL-FROM-DATE in any FY (1998–2021) THEN system SHALL route to the correct fiscal year pricing logic and return the correct payment amount
2. WHEN revenue code 0651 (RHC) is submitted for FY2016.1+ THEN system SHALL apply the 60-day HIGH/LOW rate split based on admission date and prior service days
3. WHEN revenue code 0652 (CHC) is submitted with ≥32 units (FY2007.1+) THEN system SHALL calculate using CHC hourly formula `((LS × WI) + NLS) / 24 × (units / 4)`
4. WHEN revenue code 0652 (CHC) is submitted with <32 units (FY2007.1+) THEN system SHALL pay 1 day at RHC rate tier
5. WHEN revenue code 0655 (IRC) is submitted THEN system SHALL use PROVIDER wage index (not beneficiary)
6. WHEN revenue code 0656 (GIC) is submitted THEN system SHALL use PROVIDER wage index (not beneficiary)
7. WHEN QIP-IND = '1' and FY ≥ 2014 THEN system SHALL use QIP-reduced rate variants (~2% reduction)
8. WHEN EOL add-on units > 0 and FY ≥ 2016.1 THEN system SHALL calculate SIA payment at CHC hourly rate, capped at 4 hours/day, for up to 7 days
9. WHEN multiple revenue codes present in same claim THEN system SHALL calculate each independently and sum to PAY-AMT-TOTAL
10. WHEN a valid claim is processed THEN system SHALL return the correct RTC: 00 (pre-FY2016.1), 73/74/75/77 (FY2016.1+ based on 60-day position and SIA presence)

**Independent Test**: Submit the FY2021 example from business rules doc (RHC split + SIA, expected total $2,560.11) and verify exact match.

---

### P1: Input Validation ⭐ MVP

**User Story**: As a claims processing system, I want invalid claims rejected with the correct error code so that I can handle errors appropriately.

**Why P1**: Error handling is part of the contract — downstream systems depend on these RTCs.

**Acceptance Criteria**:

1. WHEN any UNITS field > 1,000 THEN system SHALL return RTC=10 with zero payments
2. WHEN revenue code 0652 has < 8 units in FY1998–FY2006 THEN system SHALL return RTC=20 with zero payments
3. WHEN CBSA/MSA code not found in wage index THEN system SHALL return RTC=30 with zero payments
4. WHEN provider wage index is zero or non-numeric THEN system SHALL return RTC=40 with zero payments
5. WHEN beneficiary wage index is zero or non-numeric THEN system SHALL return RTC=50 with zero payments
6. WHEN provider not found in provider table THEN system SHALL return RTC=51

**Independent Test**: Submit claim with UNITS=1500 and verify RTC=10, PAY-AMT-TOTAL=0.

---

### P1: Wage Index Lookup ⭐ MVP

**User Story**: As the pricing engine, I need to look up geographic wage indices for providers and beneficiaries so that payments are adjusted for regional cost differences.

**Why P1**: Wage index is a multiplier in every payment calculation — without it, all amounts are wrong.

**Acceptance Criteria**:

1. WHEN claim FROM-DATE > 2005-09-30 THEN system SHALL use CBSA code for wage index lookup
2. WHEN claim FROM-DATE ≤ 2005-09-30 THEN system SHALL use MSA code for wage index lookup (legacy path)
3. WHEN CBSA lookup finds multiple records THEN system SHALL select the record with effective date within the claim's fiscal year boundaries
4. WHEN wage index lookup succeeds THEN system SHALL populate both provider and beneficiary wage indices before pricing

**Independent Test**: Submit claim with CBSA=16740 for FY2021 and verify correct wage index applied to payment.

---

### P1: REST API Endpoint ⭐ MVP

**User Story**: As an API consumer, I want to submit a claim via HTTP POST and receive the pricing result as JSON so that I can integrate with modern systems.

**Why P1**: The delivery mechanism — replaces CALL-based COBOL linkage with HTTP.

**Acceptance Criteria**:

1. WHEN POST /api/v1/hospice/price with valid JSON claim THEN system SHALL return 200 with pricing result
2. WHEN POST with invalid/missing required fields THEN system SHALL return 400 with validation details
3. WHEN internal error occurs THEN system SHALL return 500 with error reference (no stack trace)
4. WHEN request received THEN system SHALL map JSON fields to the BILL-315-DATA equivalent domain model

**Independent Test**: `curl -X POST /api/v1/hospice/price` with TC01 data and verify JSON response matches COBOL output.

---

### P1: Reference Data Loading ⭐ MVP

**User Story**: As the system operator, I want reference data (providers, CBSA wage indices, MSA wage indices) loaded at startup from flat files so that the system functions without a database.

**Why P1**: The system cannot price claims without reference data.

**Acceptance Criteria**:

1. WHEN application starts THEN system SHALL load CBSA wage index file into memory (indexed by CBSA code + effective date)
2. WHEN application starts THEN system SHALL load MSA wage index file into memory (for legacy claims)
3. WHEN application starts THEN system SHALL load provider file into memory (indexed by provider number)
4. WHEN any reference file is missing or corrupt THEN system SHALL fail startup with clear error message

**Independent Test**: Start application with CBSA2021 file and verify health endpoint reports data loaded.

---

### P1: Regression Test Suite ⭐ MVP

**User Story**: As a developer, I want every COBOL test case reproduced as a JUnit test so that I can verify functional parity and prevent regressions.

**Why P1**: Without tests proving parity, the migration has no validation.

**Acceptance Criteria**:

1. WHEN test suite runs THEN system SHALL execute all 40 COBOL test cases (TC01–TC36 + TC08B) as parameterized JUnit tests
2. WHEN comparing results THEN system SHALL match PAY-AMT-TOTAL within ±$0.01 of COBOL output (rounding tolerance)
3. WHEN comparing results THEN system SHALL match RTC code exactly
4. WHEN comparing FY2016.1+ results THEN system SHALL match HIGH-RHC-DAYS and LOW-RHC-DAYS exactly
5. WHEN comparing SIA results THEN system SHALL match each EOL-ADD-ON-DAYn-PAY within ±$0.01

**Independent Test**: Run `mvn test` and all 40 parameterized tests pass green.

---

### P2: Rate Configuration Externalization

**User Story**: As a system maintainer, I want all fiscal year rates stored in configuration files so that rate audits and updates don't require code changes.

**Why P2**: Improves maintainability but not required for functional parity.

**Acceptance Criteria**:

1. WHEN system loads rates THEN system SHALL read from YAML/JSON configuration files (one per FY or consolidated)
2. WHEN rate configuration is missing for a required FY THEN system SHALL fail startup with clear error
3. WHEN configuration is loaded THEN system SHALL provide all rate variants: standard LS/NLS, QIP LS/NLS, per care type (RHC-HIGH, RHC-LOW, CHC, IRC, GIC)

**Independent Test**: Modify FY2021 rate in config, restart, and verify changed payment amount.

---

### P2: Comprehensive Unit Test Suite

**User Story**: As a developer, I want unit tests for each calculation component so that I can refactor safely and catch bugs at the function level.

**Why P2**: Goes beyond parity testing into sustainable development.

**Acceptance Criteria**:

1. WHEN unit tests run THEN system SHALL cover: fiscal year routing, each revenue code calculation, QIP reduction, 60-day split logic, SIA calculation, wage index lookup, input validation
2. WHEN all unit tests run THEN system SHALL achieve >90% line coverage on the pricing domain

**Independent Test**: Run `mvn test -pl pricer-core` with coverage report.

---

### P3: API Documentation

**User Story**: As an API consumer, I want OpenAPI/Swagger documentation so that I can understand the request/response contract.

**Why P3**: Nice-to-have for initial release; can be auto-generated from Spring Boot annotations.

**Acceptance Criteria**:

1. WHEN accessing /swagger-ui THEN system SHALL display interactive API docs
2. WHEN viewing docs THEN system SHALL show all request fields, response fields, and error codes

---

## Edge Cases

- WHEN claim FROM-DATE is exactly on FY boundary (e.g., 2020-10-01) THEN system SHALL route to the newer FY (FY2021)
- WHEN claim FROM-DATE is on special mid-year boundary (2016-01-01, 2007-01-01, 2001-04-01) THEN system SHALL route to the mid-year variant
- WHEN RHC units exactly equal HIGH-RATE-DAYS-LEFT THEN system SHALL pay ALL at HIGH rate (no split)
- WHEN CHC units exactly equal 32 THEN system SHALL use CHC hourly formula (not RHC flat)
- WHEN SIA EOL units exactly equal 16 THEN system SHALL apply 4-hour cap (boundary)
- WHEN SIA EOL units > 16 THEN system SHALL cap at 4 hours (not calculate raw hours)
- WHEN all 4 revenue codes present THEN system SHALL calculate each independently and sum
- WHEN all 7 SIA EOL days have units THEN system SHALL calculate all 7 and sum
- WHEN claim has no revenue codes populated THEN system SHALL return PAY-AMT-TOTAL = 0 with RTC=00
- WHEN wage index = 1.0000 THEN labor share component SHALL equal the LS rate unchanged

---

## Requirement Traceability

| Requirement ID | Story | Description | Status |
|---------------|-------|-------------|--------|
| MIG-01 | P1: Core Pricing | FY routing (24 fiscal years) | Pending |
| MIG-02 | P1: Core Pricing | RHC (0651) calculation — all FYs | Pending |
| MIG-03 | P1: Core Pricing | CHC (0652) calculation — pre-FY2007.1 (hours) | Pending |
| MIG-04 | P1: Core Pricing | CHC (0652) calculation — FY2007.1+ (15-min, threshold 32) | Pending |
| MIG-05 | P1: Core Pricing | IRC (0655) calculation — provider WI | Pending |
| MIG-06 | P1: Core Pricing | GIC (0656) calculation — provider WI | Pending |
| MIG-07 | P1: Core Pricing | QIP reduction (FY2014+) | Pending |
| MIG-08 | P1: Core Pricing | RHC 60-day HIGH/LOW split (FY2016.1+) | Pending |
| MIG-09 | P1: Core Pricing | SIA end-of-life add-on (FY2016.1+) | Pending |
| MIG-10 | P1: Core Pricing | PAY-AMT-TOTAL summation | Pending |
| MIG-11 | P1: Core Pricing | RTC determination (00, 73, 74, 75, 77) | Pending |
| MIG-12 | P1: Validation | Units > 1,000 → RTC=10 | Pending |
| MIG-13 | P1: Validation | CHC < 8 units pre-FY2007 → RTC=20 | Pending |
| MIG-14 | P1: Validation | CBSA/MSA not found → RTC=30 | Pending |
| MIG-15 | P1: Validation | Provider WI zero → RTC=40 | Pending |
| MIG-16 | P1: Validation | Beneficiary WI zero → RTC=50 | Pending |
| MIG-17 | P1: Validation | Provider not found → RTC=51 | Pending |
| MIG-18 | P1: Wage Index | CBSA lookup (FY2006+) | Pending |
| MIG-19 | P1: Wage Index | MSA lookup (pre-FY2006) | Pending |
| MIG-20 | P1: Wage Index | Effective date filtering | Pending |
| MIG-21 | P1: REST API | POST endpoint + JSON mapping | Pending |
| MIG-22 | P1: REST API | Error responses (400, 500) | Pending |
| MIG-23 | P1: Reference Data | CBSA file loader | Pending |
| MIG-24 | P1: Reference Data | MSA file loader | Pending |
| MIG-25 | P1: Reference Data | Provider file loader | Pending |
| MIG-26 | P1: Regression | 40 parameterized parity tests | Pending |
| MIG-27 | P2: Rate Config | YAML/JSON rate externalization | Pending |
| MIG-28 | P2: Unit Tests | Component-level test coverage >90% | Pending |
| MIG-29 | P3: Docs | OpenAPI/Swagger | Pending |

**Coverage:** 29 total, 0 mapped to tasks, 29 unmapped ⚠️

---

## Success Criteria

- [ ] All 40 COBOL test cases (TC01–TC36 + TC08B) produce identical results in Java (PAY-AMT-TOTAL ±$0.01, RTC exact match)
- [ ] REST API returns correct pricing for any valid claim across FY1998–FY2021
- [ ] No hard-coded rates in Java source code — all rates in config files
- [ ] JUnit test suite passes with >90% line coverage on pricing domain
- [ ] Application starts and serves requests with reference data from flat files
