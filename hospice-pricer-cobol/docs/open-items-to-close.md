## Task Verification Report — COBOL-to-Java Migration

**Test run**: 2026-04-11 | `mvn verify` → **BUILD SUCCESS** | 147 tests, 0 failures | JaCoCo: **All coverage checks have been met** (85% threshold)

---

### Phase 1 — Project Scaffold + Foundation

| Task | Status | Notes |
|------|--------|-------|
| **T1** — Maven scaffold | ✅ Complete | Spring Boot **3.3.4** (spec said 4), Java 21, all packages present |
| **T2** — ReturnCode enum | ✅ Complete | All codes, `isError()`, `fromCode()` |
| **T3** — Domain models | ✅ Complete | `HospiceClaim`, `RevenueLineItem`, `PricingResult`, `RhcSplitResult`, `SiaResult` |
| **T4** — FiscalYearRates model | ✅ Complete | All rate fields + feature flags |
| **T5** — ProviderData + WageIndexEntry | ✅ Complete | Both records present |

---

### Phase 2 — Rate Configuration

| Task | Status | Notes |
|------|--------|-------|
| **T6** — RateProvider | ✅ Complete | Loads 27 FY configs at startup |
| **T7** — FY2021 YAML template | ✅ Complete | |
| **T8a** — FY1998–FY2006 YAMLs | ✅ Complete | 10 files (fy2001a included) |
| **T8b** — FY2007–FY2013 YAMLs | ✅ Complete | 8 files (fy2007_1 included) |
| **T8c** — FY2014–FY2015 YAMLs | ✅ Complete | 2 files with QIP rates |
| **T8d** — FY2016–FY2020 YAMLs | ✅ Complete | 6 files (fy2016_1 included) |
| **T9** — Rate integration test | ✅ Complete | 32 tests pass (RateProviderIntegrationTest) |

---

### Phase 3 — Reference Data Layer

| Task | Status | Notes |
|------|--------|-------|
| **T10** — CBSA parser + repo | ✅ Complete | 7,478 entries loaded at startup |
| **T11** — MSA parser | ✅ Complete | 1 entry loaded (test data) |
| **T12** — Provider parser + repo | ✅ Complete | 3 providers loaded |
| **T13** — ReferenceDataLoader | ✅ Complete | `@PostConstruct`, configurable paths |

---

### Phase 4 — Core Pricing Engine

| Task | Status | Notes |
|------|--------|-------|
| **T14** — PaymentCalculator | ✅ Complete | `perDiem`, `chcHourly`, `chcFromQuarters`, `siaHourlyRate` |
| **T15** — RhcSplitCalculator | ✅ Complete | HIGH/LOW/SPLIT logic |
| **T16** — SiaCalculator | ✅ Complete | 7-day EOL with 4h cap |
| **T17** — FiscalYearStrategy interface | ✅ Complete | `calculate(HospiceClaim, FiscalYearRates)` |
| **T18** — SimplePricerStrategy | ✅ Complete | FY1998–FY2007 |
| **T19** — TransitionPricerStrategy | ✅ Complete | FY2007.1–FY2013 |
| **T20** — ModernPricerStrategy | ✅ Complete | FY2014–FY2016 Oct (QIP) |
| **T21** — FullPricerStrategy | ✅ Complete | FY2016.1–FY2021 (split + SIA) |

---

### Phase 5 — Service Layer + API

| Task | Status | Notes |
|------|--------|-------|
| **T22** — ValidationService | ✅ Complete | All RTC error codes |
| **T23** — FiscalYearRouter | ✅ Complete | NavigableMap with all 26 FY boundaries |
| **T24** — DriverService | ✅ Complete | Full pricing pipeline |
| **T25** — REST Controller | ✅ Complete | `POST /api/v1/hospice/price`, Bean Validation |

---

### Phase 6 — Regression Tests

| Task | Status | Notes |
|------|--------|-------|
| **T26** — COBOL parity test data | ⚠️ Partial | **29/40 test cases** defined. Missing: TC01–TC07, TC26, TC29, TC31, TC32 |
| **T27** — Run COBOL + baseline | ⚠️ Partial | `baseline/` dir exists but **is empty**. COBOL baseline not captured. |
| **T28** — CobolParityTest | ⚠️ Partial | 29 tests pass; non-parameterized (`@Test` per case, not `@ParameterizedTest`); **11 test cases missing** |

---

### Phase 7 — Unit Tests

| Task | Status | Notes |
|------|--------|-------|
| **T29** — PaymentCalculator tests | ✅ Complete | 17 tests (per-diem, CHC hourly/quarterly, rounding) |
| **T30** — RhcSplitCalculator tests | ✅ Complete | 7 tests (HIGH, LOW, boundary cases) |
| **T31** — SiaCalculator tests | ✅ Complete | 10 tests (zero, cap at 16 units, 7-day) |
| **T32** — Strategy unit tests | ✅ Complete | 17 tests covering all 4 strategies (Simple, Transition, Modern, Full) |
| **T33** — ValidationService + FiscalYearRouter | ✅ Complete | 9 + 12 = 21 tests, all boundaries covered |
| **T34** — File parser tests | ⚠️ Partial | CBSA + MSA tested (14 tests); **ProviderFileParser has no unit tests** |

---

### Phase 8 — Final Validation

| Task | Status | Notes |
|------|--------|-------|
| **T35** — Coverage report | ✅ Complete | JaCoCo 85% threshold met, `mvn verify` passes |
| **T36** — E2E integration test | ❌ Not started | `src/test/java/.../api/` folder is **empty** — `HospicePricerControllerTest` not created |

---

### Summary

| | Count |
|---|---|
| ✅ Complete | **32 tasks** |
| ⚠️ Partial | **4 tasks** (T26, T27, T28, T34) |
| ❌ Not started | **1 task** (T36) |

### Open Items to Close

1. **T27** (manual gate) — Run build-and-run.bat, parse the RATEFILE output, and store baseline values in `src/test/resources/baseline/`.
2. **T26/T28** — Add the 11 missing test cases: `tc01`–`tc07`, `tc26`, `tc29`, `tc31`, `tc32`.
3. **T34** — Add `ProviderFileParser` unit tests to `FileParserTest.java`.
4. **T36** — Create `HospicePricerControllerTest` with MockMvc tests for `POST /api/v1/hospice/price`.