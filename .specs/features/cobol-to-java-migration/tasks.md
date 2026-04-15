# COBOL-to-Java Migration Tasks

**Design**: `.specs/features/cobol-to-java-migration/design.md`
**Status**: Draft

---

## Execution Plan

### Phase 1: Project Scaffold + Foundation (Sequential)

Bootstrap the Maven project, domain models, and configuration infrastructure.

```
T1 → T2 → T3 → T4 → T5
```

### Phase 2: Rate Configuration (Sequential then Parallel)

Extract all COBOL rates into YAML and build the loading infrastructure.

```
T5 → T6 → T7
          ┌→ T8a (FY1998–FY2006 rates) ─┐
    T7 ───┼→ T8b (FY2007–FY2013 rates)  ┼→ T9
          ├→ T8c (FY2014–FY2015 rates)  │
          └→ T8d (FY2016–FY2021 rates) ──┘
```

### Phase 3: Reference Data Layer (Parallel)

File parsers and repositories can be built independently.

```
      ┌→ T10 (CBSA parser + repo) ─┐
T9 ───┼→ T11 (MSA parser + repo)   ┼→ T14
      └→ T12 (Provider parser)     ─┘
            T13 (ReferenceDataLoader) ──→ T14
```

### Phase 4: Core Pricing Engine (Sequential)

Build from the inside out: formula → calculators → strategies.

```
T14 → T15 → T16 → T17 → T18 → T19 → T20 → T21
```

### Phase 5: Service Layer + API (Sequential)

Wire services, validation, driver, router, controller.

```
T21 → T22 → T23 → T24 → T25
```

### Phase 6: Regression Tests (Sequential)

Build COBOL parity test suite and validate all 40 test cases.

```
T25 → T26 → T27 → T28
```

### Phase 7: Unit Tests + Polish (Parallel)

Comprehensive unit tests per component.

```
       ┌→ T29 (PaymentCalculator tests)     ─┐
       ├→ T30 (RhcSplitCalculator tests)     │
T28 ───┼→ T31 (SiaCalculator tests)          ┼→ T35
       ├→ T32 (Strategy unit tests)           │
       ├→ T33 (Validation + Router tests)     │
       └→ T34 (File parser tests)            ─┘
```

### Phase 8: Final Validation (Sequential)

```
T35 → T36
```

### Full Dependency Graph

```
T1 → T2 → T3 → T4 → T5 → T6 → T7 → T8a─┐
                                    ├→ T8b ┼→ T9 → T10─┐
                                    ├→ T8c │      T11─┼→ T14 → T15 → T16 → T17
                                    └→ T8d─┘      T12─┘
                                              T13──┘
T17 → T18 → T19 → T20 → T21 → T22 → T23 → T24 → T25 → T26 → T27 → T28
                                                                      │
T28 → T29─┐                                                          │
    → T30 ┼→ T35 → T36                                              │
    → T31 │                                                          │
    → T32 │                                                          │
    → T33 │                                                          │
    → T34─┘                                                          │
```

---

## Task Breakdown

### T1: Create Maven Project Scaffold

**What**: Initialize Spring Boot 4 + Java 21 Maven project with `pom.xml`, main class, and package structure
**Where**: `hospice-pricer-api/pom.xml`, `src/main/java/com/cms/hospice/HospicePricerApplication.java`
**Depends on**: None
**Reuses**: Spring Initializr pattern
**Requirement**: MIG-21

**Done when**:
- [ ] `pom.xml` with Spring Boot 4, Java 21, spring-boot-starter-web, spring-boot-starter-test, JUnit 5
- [ ] Package structure created: `api/`, `model/`, `service/`, `pricing/`, `data/`, `config/`
- [ ] `HospicePricerApplication.java` with `@SpringBootApplication`
- [ ] `application.yaml` with basic config (server port, data file paths)
- [ ] `mvn compile` passes

**Tests**: none
**Gate**: build

---

### T2: Create ReturnCode Enum

**What**: Define all RTC codes as a Java enum with descriptions
**Where**: `src/main/java/com/cms/hospice/model/ReturnCode.java`
**Depends on**: T1
**Reuses**: None
**Requirement**: MIG-11, MIG-12, MIG-13, MIG-14, MIG-15, MIG-16, MIG-17

**Done when**:
- [ ] Enum values: SUCCESS_00, SUCCESS_73, SUCCESS_74, SUCCESS_75, SUCCESS_77, ERROR_10, ERROR_20, ERROR_30, ERROR_40, ERROR_50, ERROR_51
- [ ] Each has `code` (String "00"–"77") and `description` field
- [ ] `isError()` method (RTC 10–51 = error)
- [ ] `fromCode(String)` factory method

**Tests**: unit
**Gate**: build

---

### T3: Create Domain Models (DTOs)

**What**: Create all domain records: `HospiceClaim`, `RevenueLineItem`, `PricingResult`, `RhcSplitResult`, `SiaResult`
**Where**: `src/main/java/com/cms/hospice/model/`
**Depends on**: T2
**Reuses**: BILL-315-DATA layout from COBOL analysis
**Requirement**: MIG-21

**Done when**:
- [ ] `HospiceClaim` record with all fields mapping to BILL-315-DATA input fields
- [ ] `RevenueLineItem` record (revenueCode, hcpcCode, dateOfService, units)
- [ ] `PricingResult` record with all output fields (lineItemPayments, payAmountTotal, returnCode, highRhcDays, lowRhcDays, eolAddOnDayPayments, naAddOnPayments)
- [ ] `RhcSplitResult` record (highDays, lowDays, highPayment, lowPayment, totalPayment)
- [ ] `SiaResult` record (dayPayments[7], totalPayment, hasSia)
- [ ] All use `BigDecimal` for monetary amounts
- [ ] `mvn compile` passes

**Tests**: none (records are data-only)
**Gate**: build

---

### T4: Create FiscalYearRates Model

**What**: Create `FiscalYearRates` record with all rate fields and feature flags
**Where**: `src/main/java/com/cms/hospice/model/FiscalYearRates.java`
**Depends on**: T3
**Reuses**: HOSPRATE copybook structure
**Requirement**: MIG-27

**Done when**:
- [ ] Record with LS/NLS for: RHC-HIGH, RHC-LOW, CHC, IRC, GIC (standard + QIP variants)
- [ ] Feature flags: `hasQip`, `has60DaySplit`, `hasSia`, `chcIn15MinUnits`, `hasMinChc8Hours`
- [ ] Builder or factory methods for clean construction
- [ ] `mvn compile` passes

**Tests**: none
**Gate**: build

---

### T5: Create ProviderData and WageIndexEntry Models

**What**: Create data models for reference data entities
**Where**: `src/main/java/com/cms/hospice/model/ProviderData.java`, `WageIndexEntry.java`
**Depends on**: T1
**Reuses**: PROV-TABLE and CBSA/MSA record layouts from COBOL analysis
**Requirement**: MIG-23, MIG-24, MIG-25

**Done when**:
- [ ] `ProviderData` record with fields from 240-byte provider record (npi, providerNumber, effectiveDate, fyBeginDate, cbsaGeoLoc, msaGeoLoc, censusDivision)
- [ ] `WageIndexEntry` record (code, effectiveDate, wageIndex as BigDecimal)
- [ ] `mvn compile` passes

**Tests**: none
**Gate**: build

---

### T6: Create RateProvider Component

**What**: Build the rate configuration loader that reads FY rates from YAML
**Where**: `src/main/java/com/cms/hospice/config/RateProvider.java`
**Depends on**: T4
**Reuses**: Spring `@ConfigurationProperties` or `YamlPropertiesFactoryBean`
**Requirement**: MIG-27

**Done when**:
- [ ] `RateProvider` Spring bean that loads YAML rate files from `classpath:rates/`
- [ ] `FiscalYearRates getRates(String fiscalYear)` method
- [ ] Throws clear exception if requested FY not found
- [ ] Startup validation: all 24+ FY configs present and valid
- [ ] `mvn compile` passes

**Tests**: unit (verify loading of sample rate file)
**Gate**: build

---

### T7: Create Rate YAML Template and FY2021 Rates

**What**: Define YAML format and create first rate file (FY2021) from HOSPRATE copybook
**Where**: `src/main/resources/rates/fy2021.yaml`
**Depends on**: T6
**Reuses**: HOSPRATE copybook values (directly transcribed)
**Requirement**: MIG-27

**Done when**:
- [ ] YAML schema defined with all rate fields
- [ ] FY2021 rates match HOSPRATE exactly:
  - RHC HIGH: LS=136.90, NLS=62.35; LOW: LS=108.21, NLS=49.28
  - CHC: LS=984.21, NLS=448.20
  - IRC: LS=249.59, NLS=211.50
  - GIC: LS=669.33, NLS=376.33
  - QIP variants: HIGH-Q LS=134.23, etc.
- [ ] Feature flags: hasQip=true, has60DaySplit=true, hasSia=true, chcIn15MinUnits=true
- [ ] RateProvider correctly loads FY2021

**Tests**: unit (RateProvider loads fy2021.yaml, values match)
**Gate**: build

---

### T8a: Create Rate YAML Files — FY1998–FY2006 [P]

**What**: Extract hard-coded rates from HOSPR210 paragraphs for FY1998 through FY2006
**Where**: `src/main/resources/rates/fy1998.yaml` through `fy2006.yaml` (9 files + FY2001-A)
**Depends on**: T7
**Reuses**: Hard-coded values from HOSPR210 COBOL source (each FY paragraph)
**Requirement**: MIG-27, MIG-01

**Done when**:
- [ ] 10 YAML files: fy1998, fy1999, fy2000, fy2001, fy2001a, fy2002, fy2003, fy2004, fy2005, fy2006
- [ ] Each with LS/NLS for RHC, CHC, IRC, GIC (no QIP, no split, no SIA)
- [ ] Feature flags: hasQip=false, has60DaySplit=false, hasSia=false, chcIn15MinUnits=false, hasMinChc8Hours=true
- [ ] Values verified against HOSPR210 source (e.g., FY2005: RHC LS=83.81, NLS=38.17)

**Tests**: unit (spot-check 3 FY files load correctly)
**Gate**: build

---

### T8b: Create Rate YAML Files — FY2007–FY2013 [P]

**What**: Extract hard-coded rates from HOSPR210 for FY2007 through FY2013
**Where**: `src/main/resources/rates/fy2007.yaml` through `fy2013.yaml` (8 files including FY2007.1)
**Depends on**: T7
**Reuses**: Hard-coded values from HOSPR210 COBOL source
**Requirement**: MIG-27, MIG-01

**Done when**:
- [ ] 8 YAML files: fy2007, fy2007_1, fy2008, fy2009, fy2010, fy2011, fy2012, fy2013
- [ ] FY2007: chcIn15MinUnits=false; FY2007.1+: chcIn15MinUnits=true
- [ ] hasMinChc8Hours=false for FY2007.1+ (threshold changes to 32 units)
- [ ] No QIP, no 60-day split, no SIA for any
- [ ] Values verified against HOSPR210 source

**Tests**: unit (spot-check 2 FY files)
**Gate**: build

---

### T8c: Create Rate YAML Files — FY2014–FY2015 [P]

**What**: Extract hard-coded rates from HOSPR210 for FY2014–FY2015 (first FYs with QIP)
**Where**: `src/main/resources/rates/fy2014.yaml`, `fy2015.yaml`
**Depends on**: T7
**Reuses**: Hard-coded values from HOSPR210 COBOL source
**Requirement**: MIG-27, MIG-07

**Done when**:
- [ ] 2 YAML files with standard AND QIP rates
- [ ] hasQip=true, has60DaySplit=false, hasSia=false, chcIn15MinUnits=true
- [ ] FY2014 standard: RHC LS=107.23, NLS=48.83; QIP: LS=105.12, NLS=47.87
- [ ] FY2015 standard and QIP rates verified

**Tests**: unit (verify QIP rate loading)
**Gate**: build

---

### T8d: Create Rate YAML Files — FY2016–FY2020 [P]

**What**: Transcribe rates from HOSPRATE copybook for FY2016–FY2020 (FY2021 done in T7)
**Where**: `src/main/resources/rates/fy2016.yaml` through `fy2020.yaml` (6 files including FY2016.1)
**Depends on**: T7
**Reuses**: HOSPRATE copybook values (direct transcription)
**Requirement**: MIG-27

**Done when**:
- [ ] 6 YAML files: fy2016 (single RHC, no split), fy2016_1 (HIGH/LOW split + SIA), fy2017, fy2018, fy2019, fy2020
- [ ] FY2016: has60DaySplit=false, hasSia=false; FY2016.1+: has60DaySplit=true, hasSia=true
- [ ] All have hasQip=true, chcIn15MinUnits=true
- [ ] Values match HOSPRATE copybook exactly

**Tests**: unit (verify FY2016 vs FY2016.1 feature flag difference)
**Gate**: build

---

### T9: Validate All Rate Files Load Successfully

**What**: Integration test that loads all 26+ rate YAML files and validates completeness
**Where**: `src/test/java/com/cms/hospice/config/RateProviderIntegrationTest.java`
**Depends on**: T8a, T8b, T8c, T8d
**Reuses**: RateProvider from T6
**Requirement**: MIG-27

**Done when**:
- [ ] Test verifies all 26 FY configurations load without error
- [ ] Test verifies each FY has non-null LS/NLS for RHC, CHC, IRC, GIC
- [ ] Test verifies QIP rates present only for FY2014+
- [ ] Test verifies feature flags match expected per FY group
- [ ] `mvn test` passes (this test)

**Tests**: integration
**Gate**: full

---

### T10: Create CBSA File Parser + WageIndexRepository (CBSA) [P]

**What**: Parse CBSA2021 fixed-width file and build in-memory CBSA wage index lookup
**Where**: `src/main/java/com/cms/hospice/data/CbsaFileParser.java`, `WageIndexRepository.java`
**Depends on**: T5
**Reuses**: CBSA2021 file format (5-byte code + 8-byte date + 6-byte WI)
**Requirement**: MIG-18, MIG-20, MIG-23

**Done when**:
- [ ] `CbsaFileParser` reads 80-byte fixed-width CBSA records
- [ ] Correctly parses: CBSA code (5), effective date (8), wage index (6 digits → BigDecimal)
- [ ] `WageIndexRepository.findCbsaWageIndex(cbsaCode, effectiveDate, fyBegin, fyEnd)` works
- [ ] Effective date filtering: returns WI record where eff date is within FY boundaries
- [ ] Returns `Optional.empty()` for unknown CBSA codes
- [ ] Unit test with sample CBSA data passes

**Tests**: unit
**Gate**: build

---

### T11: Create MSA File Parser + WageIndexRepository (MSA) [P]

**What**: Parse MSA flat file and add legacy MSA lookup to WageIndexRepository
**Where**: `src/main/java/com/cms/hospice/data/MsaFileParser.java`, update `WageIndexRepository.java`
**Depends on**: T5
**Reuses**: MSA file format (4-byte MSA + 1-byte lugar + 8-byte date + 6-byte WI)
**Requirement**: MIG-19, MIG-24

**Done when**:
- [ ] `MsaFileParser` reads fixed-width MSA records
- [ ] `WageIndexRepository.findMsaWageIndex(msaCode)` works
- [ ] Returns `Optional.empty()` for unknown MSA codes
- [ ] Unit test with sample MSA data passes

**Tests**: unit
**Gate**: build

---

### T12: Create Provider File Parser + ProviderRepository [P]

**What**: Parse 240-byte provider records and build in-memory provider lookup
**Where**: `src/main/java/com/cms/hospice/data/ProviderFileParser.java`, `ProviderRepository.java`
**Depends on**: T5
**Reuses**: Provider record layout (3 × 80-byte segments)
**Requirement**: MIG-25

**Done when**:
- [ ] `ProviderFileParser` reads 240-byte fixed-width provider records (3 segments)
- [ ] Extracts: NPI, provider number, FY dates, CBSA geo, MSA geo, census division
- [ ] `ProviderRepository.findByProviderNumber(provNo)` works
- [ ] Returns `Optional.empty()` for unknown providers
- [ ] Unit test with sample provider data passes

**Tests**: unit
**Gate**: build

---

### T13: Create ReferenceDataLoader

**What**: Spring bean that loads all reference data at startup using `@PostConstruct`
**Where**: `src/main/java/com/cms/hospice/data/ReferenceDataLoader.java`
**Depends on**: T10, T11, T12
**Reuses**: All three parsers + repositories
**Requirement**: MIG-23, MIG-24, MIG-25

**Done when**:
- [ ] `@PostConstruct` method calls all parsers and populates repositories
- [ ] File paths configurable via `application.yaml`
- [ ] Clear error messages if any file missing or corrupt
- [ ] Logs record counts after loading (e.g., "Loaded 7,478 CBSA records, 1 MSA record, 2 providers")
- [ ] `mvn compile` passes

**Tests**: none (integration tested via T9 and T26)
**Gate**: build

---

### T14: Implement PaymentCalculator

**What**: Core formula engine with BigDecimal arithmetic matching COBOL `ROUNDED`
**Where**: `src/main/java/com/cms/hospice/pricing/PaymentCalculator.java`
**Depends on**: T3
**Reuses**: Common formula from all COBOL FY paragraphs: `(LS × WI + NLS) × units`
**Requirement**: MIG-02, MIG-03, MIG-04, MIG-05, MIG-06

**Done when**:
- [ ] `calculatePerDiem(ls, nls, wageIndex, units)` → `BigDecimal` with HALF_UP rounding to 2 decimal places
- [ ] `calculateChcHourly(ls, nls, wageIndex, hours)` → `((LS×WI+NLS)/24) × hours` for pre-FY2007.1
- [ ] `calculateChcFromQuarters(ls, nls, wageIndex, quarterUnits)` → `((LS×WI+NLS)/24) × (units/4)` for FY2007.1+
- [ ] RHC/IRC/GIC use per-diem; CHC uses hourly
- [ ] IRC/GIC use provider WI; RHC/CHC use beneficiary WI (caller responsibility, calculator is WI-agnostic)
- [ ] Verified: FY2021 RHC with WI=1.0000, 10 units → ((136.90 + 62.35) × 10) = $1,992.50

**Tests**: unit (core formula with known values)
**Gate**: build

---

### T15: Implement RhcSplitCalculator

**What**: 60-day HIGH/LOW rate split logic for RHC (FY2016.1+)
**Where**: `src/main/java/com/cms/hospice/pricing/RhcSplitCalculator.java`
**Depends on**: T14
**Reuses**: PaymentCalculator for per-diem formula
**Requirement**: MIG-08

**Done when**:
- [ ] Calculates priorServiceDays = `ChronoUnit.DAYS.between(admissionDate, serviceDate) + priorBenefitDays`
- [ ] ALL LOW: priorServiceDays ≥ 60 → all units at LOW rate
- [ ] ALL HIGH: priorServiceDays < 60 AND units ≤ (60 - priorServiceDays) → all units at HIGH rate
- [ ] SPLIT: priorServiceDays < 60 AND units > (60 - priorServiceDays) → split between HIGH and LOW
- [ ] Returns `RhcSplitResult` with highDays, lowDays, highPayment, lowPayment, totalPayment
- [ ] Uses QIP rates when isQip=true
- [ ] Verified: Admission 2021-01-19, Service 2021-03-15, 10 units → 5 HIGH + 5 LOW

**Tests**: unit (ALL LOW, ALL HIGH, SPLIT, boundary at exactly 60)
**Gate**: build

---

### T16: Implement SiaCalculator

**What**: Service Intensity Add-on (EOL) hourly calculation with 4-hour cap
**Where**: `src/main/java/com/cms/hospice/pricing/SiaCalculator.java`
**Depends on**: T14
**Reuses**: PaymentCalculator for CHC hourly rate
**Requirement**: MIG-09

**Done when**:
- [ ] `calculate(eolDayUnits[7], rates, beneWageIndex, isQip)` → `SiaResult`
- [ ] Hourly rate = `((CHC-LS × WI) + CHC-NLS) / 24` (uses QIP variant if isQip)
- [ ] Per-day: units ≥ 16 → 4 hours (cap); else units / 4
- [ ] Payment per day = hours × hourly rate
- [ ] Sum all 7 days for totalPayment
- [ ] `hasSia` = true if any day has units > 0
- [ ] Verified: FY2021, WI=1.0000, day1=12, day2=20, day3=8 → correct totals

**Tests**: unit (no SIA, partial days, full 7 days, cap at 16 units)
**Gate**: build

---

### T17: Implement FiscalYearStrategy Interface

**What**: Define the strategy interface and common helper methods
**Where**: `src/main/java/com/cms/hospice/pricing/FiscalYearStrategy.java`
**Depends on**: T14, T3, T4
**Reuses**: None
**Requirement**: MIG-01

**Done when**:
- [ ] Interface: `PricingResult price(HospiceClaim claim, FiscalYearRates rates)`
- [ ] Default helper methods for shared patterns (e.g., selecting WI by revenue code, applying to all 4 rev groups)
- [ ] `mvn compile` passes

**Tests**: none (interface only)
**Gate**: build

---

### T18: Implement SimplePricerStrategy (FY1998–FY2006)

**What**: Strategy for the earliest fiscal years — basic formula, CHC in hours, min 8h check
**Where**: `src/main/java/com/cms/hospice/pricing/SimplePricerStrategy.java`
**Depends on**: T17, T14
**Reuses**: PaymentCalculator
**Requirement**: MIG-02, MIG-03, MIG-05, MIG-06, MIG-13

**Done when**:
- [ ] RHC (0651): `(LS × BENE_WI + NLS) × units`
- [ ] CHC (0652): `((LS × BENE_WI + NLS) / 24) × hours`; validates min 8 hours → RTC=20 if not
- [ ] IRC (0655): `(LS × PROV_WI + NLS) × units`
- [ ] GIC (0656): `(LS × PROV_WI + NLS) × units`
- [ ] No QIP, no 60-day split, no SIA
- [ ] Returns RTC=00 on success, RTC=20 for CHC < 8h
- [ ] Verified against FY2005 example: RHC LS=83.81, NLS=38.17, WI=1.0200, 20 units = $2,473.20

**Tests**: unit (one FY, all 4 rev codes, CHC < 8h error)
**Gate**: build

---

### T19: Implement TransitionPricerStrategy (FY2007–FY2013)

**What**: Strategy for FY2007.1+ — CHC 15-min units with 32-unit threshold, no QIP
**Where**: `src/main/java/com/cms/hospice/pricing/TransitionPricerStrategy.java`
**Depends on**: T17, T14
**Reuses**: PaymentCalculator
**Requirement**: MIG-02, MIG-04, MIG-05, MIG-06

**Done when**:
- [ ] RHC (0651): same formula as Simple
- [ ] CHC (0652) with 15-min units:
  - < 32 units: pay 1 day at RHC rate (flat)
  - ≥ 32 units: `((CHC_LS × WI + CHC_NLS) / 24) × (units / 4)`
- [ ] IRC/GIC: same as Simple
- [ ] No QIP, no 60-day split, no SIA
- [ ] RTC=00 on success
- [ ] Also handles FY2007 (pre-2007.1): CHC in hours, min 8h check (via feature flag)
- [ ] Verified: FY2007.1, CHC 40 units, WI=1.0 → $318.07

**Tests**: unit (CHC < 32 → RHC flat, CHC ≥ 32 → hourly, boundary at 32)
**Gate**: build

---

### T20: Implement ModernPricerStrategy (FY2014–FY2015)

**What**: Strategy adding QIP support to transition logic
**Where**: `src/main/java/com/cms/hospice/pricing/ModernPricerStrategy.java`
**Depends on**: T19
**Reuses**: TransitionPricerStrategy patterns, PaymentCalculator
**Requirement**: MIG-02, MIG-04, MIG-05, MIG-06, MIG-07

**Done when**:
- [ ] Same as Transition BUT checks `qipIndicator == "1"` to select QIP rate variants
- [ ] All 4 revenue codes use QIP rates when QIP active
- [ ] No 60-day split, no SIA
- [ ] Verified: FY2014 RHC, QIP=1, LS=105.12, NLS=47.87 vs standard LS=107.23, NLS=48.83

**Tests**: unit (with and without QIP, all 4 rev codes with QIP)
**Gate**: build

---

### T21: Implement FullPricerStrategy (FY2016–FY2021)

**What**: Complete strategy with QIP + 60-day split + SIA
**Where**: `src/main/java/com/cms/hospice/pricing/FullPricerStrategy.java`
**Depends on**: T15, T16, T20
**Reuses**: RhcSplitCalculator, SiaCalculator, PaymentCalculator
**Requirement**: MIG-02, MIG-04, MIG-05, MIG-06, MIG-07, MIG-08, MIG-09, MIG-10, MIG-11

**Done when**:
- [ ] RHC (0651): Uses RhcSplitCalculator for HIGH/LOW determination + SiaCalculator for EOL
- [ ] CHC (0652): 15-min units, threshold 32; < 32 units → pay at RHC rate tier (HIGH or LOW based on 60-day position)
- [ ] IRC/GIC: Same formula, QIP-aware
- [ ] SIA: Calculated when any EOL day units > 0
- [ ] RTC determination:
  - 73: LOW RHC, no SIA
  - 74: LOW RHC + SIA
  - 75: HIGH RHC (or SPLIT), no SIA
  - 77: HIGH RHC (or SPLIT) + SIA
- [ ] PAY-AMT-TOTAL = sum of all line items + SIA total
- [ ] FY2016 (pre-2016.1): Single RHC rate, no split, no SIA → RTC=00
- [ ] Verified: FY2021 full example (RHC split + SIA) → total $2,560.11

**Tests**: unit (ALL LOW, ALL HIGH, SPLIT, SIA, QIP, FY2016 single rate)
**Gate**: build

---

### T22: Implement ValidationService

**What**: Input validation matching all COBOL validation rules
**Where**: `src/main/java/com/cms/hospice/service/ValidationService.java`
**Depends on**: T2, T3
**Reuses**: ReturnCode enum
**Requirement**: MIG-12, MIG-13, MIG-14, MIG-15, MIG-16, MIG-17

**Done when**:
- [ ] `Optional<ReturnCode> validate(HospiceClaim claim)` — returns first RTC error or empty
- [ ] RTC=10: any of UNITS1-4 > 1,000
- [ ] RTC=20: rev 0652, units < 8, FY1998–FY2006 (based on fromDate)
- [ ] RTC=40: providerWageIndex is null, zero, or non-numeric
- [ ] RTC=50: beneficiaryWageIndex is null, zero, or non-numeric
- [ ] Validation order matches COBOL: units (10) → CHC min (20) → WI (40, 50)
- [ ] Note: RTC=30 and RTC=51 are checked in DriverService (lookup failures), not here

**Tests**: unit (each RTC, valid claim returns empty)
**Gate**: build

---

### T23: Implement FiscalYearRouter

**What**: Date-based dispatch to FY strategy using NavigableMap
**Where**: `src/main/java/com/cms/hospice/service/FiscalYearRouter.java`
**Depends on**: T18, T19, T20, T21
**Reuses**: All strategy implementations
**Requirement**: MIG-01

**Done when**:
- [ ] `NavigableMap<LocalDate, FiscalYearStrategy>` with all 26 FY boundaries
- [ ] `FiscalYearStrategy resolve(LocalDate fromDate)` returns correct strategy
- [ ] Correct mapping for mid-year boundaries: FY2001-A (Apr 1), FY2007.1 (Jan 1), FY2016.1 (Jan 1)
- [ ] Pairs each strategy with its fiscal year ID for rate lookup
- [ ] Falls through to FY1998 for earliest dates

**Tests**: unit (each boundary date, mid-year transitions, edge cases)
**Gate**: build

---

### T24: Implement DriverService

**What**: Main orchestrator — replaces HOSDR210 workflow
**Where**: `src/main/java/com/cms/hospice/service/DriverService.java`
**Depends on**: T22, T23, T10, T11, T12, T6
**Reuses**: All services and repositories
**Requirement**: MIG-18, MIG-19, MIG-20

**Done when**:
- [ ] `PricingResult priceClaim(HospiceClaim claim)` full pipeline:
  1. Validate input (ValidationService) → return RTC on error
  2. Lookup provider (ProviderRepository) → RTC=51 if not found
  3. Determine CBSA vs MSA path based on fromDate
  4. Lookup wage indices (WageIndexRepository) → RTC=30 if not found
  5. Validate wage indices → RTC=40/50 if zero
  6. Route to FY strategy (FiscalYearRouter)
  7. Execute pricing (FiscalYearStrategy)
  8. Return result
- [ ] CBSA path used for fromDate > 2005-09-30; MSA path otherwise
- [ ] Effective date filtering for CBSA lookup

**Tests**: unit (mock dependencies, test orchestration flow)
**Gate**: build

---

### T25: Implement REST Controller + Request/Response Mapping

**What**: Spring REST controller with JSON request/response mapping
**Where**: `src/main/java/com/cms/hospice/api/HospicePricerController.java`, `PricingRequest.java`, `PricingResponse.java`
**Depends on**: T24
**Reuses**: DriverService
**Requirement**: MIG-21, MIG-22

**Done when**:
- [ ] `POST /api/v1/hospice/price` accepts `PricingRequest` JSON, returns `PricingResponse` JSON
- [ ] `PricingRequest` maps JSON fields to `HospiceClaim` domain model
- [ ] `PricingResponse` maps `PricingResult` to JSON (camelCase)
- [ ] `GET /api/v1/hospice/health` returns data loading status
- [ ] 400 for malformed JSON / missing required fields (via Bean Validation)
- [ ] 500 for unexpected errors (generic error response, no stack trace)
- [ ] `mvn compile` passes

**Tests**: unit (MockMvc test with sample request/response)
**Gate**: build

---

### T26: Create COBOL Parity Test Data

**What**: Transcribe all 40 COBOL test cases (TC01–TC36 + TC08B) into Java test constants
**Where**: `src/test/java/com/cms/hospice/regression/TestCaseData.java`
**Depends on**: T3
**Reuses**: Test case definitions from `test/GENDATA.cbl` and `docs/plano-execucao-casos-teste.md`
**Requirement**: MIG-26

**Done when**:
- [ ] Java class with static `HospiceClaim` objects for all 40 test cases
- [ ] Each includes all input fields exactly matching GENDATA.cbl values
- [ ] Expected outputs documented (expected RTC, expected PAY-AMT-TOTAL, expected HIGH/LOW days)
- [ ] Expected outputs from COBOL `run/RATEFILE` output (actual COBOL results)
- [ ] Includes TC metadata: test case ID, description, FY, expected RTC

**Tests**: none (data-only)
**Gate**: build

---

### T27: Run COBOL System and Capture Baseline Outputs

**What**: Execute the COBOL test suite and capture exact output for each test case as the regression baseline
**Where**: `src/test/resources/baseline/` (expected output files or inline constants in T26)
**Depends on**: T26
**Reuses**: `test/build-and-run.bat`, existing COBOL test infrastructure
**Requirement**: MIG-26

**Done when**:
- [ ] COBOL system built and run via `build-and-run.bat`
- [ ] RATEFILE output parsed: for each TC, extract PAY-AMT-TOTAL, RTC, HIGH-RHC-DAYS, LOW-RHC-DAYS, PAY-AMT1-4, EOL-DAYn-PAY
- [ ] Baseline values stored as test constants or JSON fixture file
- [ ] Known issues documented (LINE SEQUENTIAL truncation for PAY-TOTAL/RTC at positions >275)

**Tests**: none (data capture)
**Gate**: manual

---

### T28: Implement CobolParityTest (40 Parameterized Tests)

**What**: JUnit 5 parameterized test that runs all 40 COBOL test cases through the Java pricing engine and compares against COBOL baseline
**Where**: `src/test/java/com/cms/hospice/regression/CobolParityTest.java`
**Depends on**: T26, T27, T25 (full stack available)
**Reuses**: TestCaseData, DriverService, Spring test context
**Requirement**: MIG-26

**Done when**:
- [ ] `@ParameterizedTest` + `@MethodSource` iterating all 40 test cases
- [ ] Each test: creates `HospiceClaim` from test data → calls `DriverService.priceClaim()` → asserts results
- [ ] PAY-AMT-TOTAL matches within ±$0.01 (COBOL rounding tolerance)
- [ ] RTC matches exactly
- [ ] HIGH-RHC-DAYS and LOW-RHC-DAYS match exactly (FY2016.1+)
- [ ] EOL-ADD-ON-DAYn-PAY matches within ±$0.01 (SIA cases)
- [ ] Clear failure messages: "TC05: expected RTC=77, got RTC=00; expected PAY=$2560.11, got $2558.00"
- [ ] All 40 tests pass green

**Tests**: regression (this IS the test)
**Gate**: full (`mvn test`)

---

### T29: Unit Tests — PaymentCalculator [P]

**What**: Comprehensive unit tests for the core formula engine
**Where**: `src/test/java/com/cms/hospice/pricing/PaymentCalculatorTest.java`
**Depends on**: T14
**Reuses**: Known calculation examples from business rules doc
**Requirement**: MIG-28

**Done when**:
- [ ] Test per-diem: known LS/NLS/WI/units → expected result
- [ ] Test CHC hourly (pre-FY2007.1): known rates, hours → expected
- [ ] Test CHC from quarters (FY2007.1+): known rates, quarter units → expected
- [ ] Test rounding: verify HALF_UP matches COBOL ROUNDED (specific edge cases)
- [ ] Test with WI = 1.0000 (neutral), WI > 1 (high), WI < 1 (low)
- [ ] Test with units = 0, units = 1, units = 1000

**Tests**: unit
**Gate**: quick (`mvn test -pl ... -Dtest=PaymentCalculatorTest`)

---

### T30: Unit Tests — RhcSplitCalculator [P]

**What**: Unit tests for 60-day HIGH/LOW split logic
**Where**: `src/test/java/com/cms/hospice/pricing/RhcSplitCalculatorTest.java`
**Depends on**: T15
**Reuses**: Split examples from business rules doc
**Requirement**: MIG-28

**Done when**:
- [ ] Test ALL LOW: priorServiceDays ≥ 60
- [ ] Test ALL HIGH: priorServiceDays < 60, units fit
- [ ] Test SPLIT: priorServiceDays < 60, units exceed threshold
- [ ] Test boundary: exactly 60 days → ALL LOW
- [ ] Test boundary: units exactly = daysLeft → ALL HIGH (no split)
- [ ] Test with priorBenefitDays > 0
- [ ] Test with QIP and without QIP

**Tests**: unit
**Gate**: quick

---

### T31: Unit Tests — SiaCalculator [P]

**What**: Unit tests for EOL add-on calculation
**Where**: `src/test/java/com/cms/hospice/pricing/SiaCalculatorTest.java`
**Depends on**: T16
**Reuses**: SIA examples from business rules doc
**Requirement**: MIG-28

**Done when**:
- [ ] Test no SIA (all zeros) → hasSia=false, total=0
- [ ] Test single day with units < 16
- [ ] Test single day with units = 16 (boundary: exactly 4 hours)
- [ ] Test single day with units > 16 (cap at 4 hours)
- [ ] Test all 7 days populated
- [ ] Test with QIP rates
- [ ] Test with high wage index

**Tests**: unit
**Gate**: quick

---

### T32: Unit Tests — All Strategy Implementations [P]

**What**: Unit tests for each FY strategy group
**Where**: `src/test/java/com/cms/hospice/pricing/` (one test per strategy)
**Depends on**: T18, T19, T20, T21
**Reuses**: Known examples per FY from business rules doc
**Requirement**: MIG-28

**Done when**:
- [ ] SimplePricerStrategyTest: FY2005 all 4 rev codes, CHC < 8h → RTC=20
- [ ] TransitionPricerStrategyTest: FY2007.1 CHC < 32 and ≥ 32 units
- [ ] ModernPricerStrategyTest: FY2014 with QIP and without
- [ ] FullPricerStrategyTest: FY2021 split + SIA, FY2016 single rate, QIP combinations
- [ ] Each strategy tested for all supported revenue codes

**Tests**: unit
**Gate**: quick

---

### T33: Unit Tests — ValidationService + FiscalYearRouter [P]

**What**: Unit tests for validation rules and FY routing
**Where**: `src/test/java/com/cms/hospice/service/`
**Depends on**: T22, T23
**Reuses**: RTC definitions, FY boundary table
**Requirement**: MIG-28

**Done when**:
- [ ] ValidationServiceTest: each RTC error code, valid claim → empty
- [ ] FiscalYearRouterTest: all 26 boundaries, mid-year transitions (FY2001-A, FY2007.1, FY2016.1)
- [ ] Boundary edge cases: exact date on boundary, one day before, one day after

**Tests**: unit
**Gate**: quick

---

### T34: Unit Tests — File Parsers [P]

**What**: Unit tests for CBSA, MSA, and Provider file parsers
**Where**: `src/test/java/com/cms/hospice/data/`
**Depends on**: T10, T11, T12
**Reuses**: Sample records from actual data files
**Requirement**: MIG-28

**Done when**:
- [ ] CbsaFileParserTest: parse sample line, verify CBSA code + date + WI
- [ ] MsaFileParserTest: parse sample line, verify MSA code + WI
- [ ] ProviderFileParserTest: parse 240-byte record, verify all extracted fields
- [ ] Edge cases: malformed records, empty files

**Tests**: unit
**Gate**: quick

---

### T35: Coverage Report and Gap Analysis

**What**: Run full test suite with coverage reporting, verify >90% on pricing domain
**Where**: `pom.xml` (JaCoCo plugin), coverage report
**Depends on**: T28, T29, T30, T31, T32, T33, T34
**Reuses**: JaCoCo Maven plugin
**Requirement**: MIG-28

**Done when**:
- [ ] JaCoCo plugin configured in `pom.xml`
- [ ] `mvn verify` generates coverage report
- [ ] `com.cms.hospice.pricing` package: >90% line coverage
- [ ] `com.cms.hospice.service` package: >90% line coverage
- [ ] Coverage gaps documented, additional tests added if needed

**Tests**: none (meta-task)
**Gate**: full (`mvn verify`)

---

### T36: End-to-End Integration Test

**What**: Full Spring Boot integration test — start app, POST request, verify response
**Where**: `src/test/java/com/cms/hospice/api/HospicePricerControllerTest.java`
**Depends on**: T35
**Reuses**: TestCaseData from T26
**Requirement**: MIG-21, MIG-22

**Done when**:
- [ ] `@SpringBootTest` with `TestRestTemplate`
- [ ] POST valid claim → 200 with correct pricing
- [ ] POST invalid JSON → 400
- [ ] POST claim triggering RTC=10 → 200 with RTC=10 and zero payments
- [ ] Health endpoint returns 200 with data loading counts
- [ ] All integration tests pass

**Tests**: integration
**Gate**: full (`mvn verify`)

---

## Validation Tables

### Diagram-Definition Cross-Check

| Task | Depends on (definition) | Matches diagram? |
|------|------------------------|-----------------|
| T1 | None | ✅ |
| T2 | T1 | ✅ |
| T3 | T2 | ✅ |
| T4 | T3 | ✅ |
| T5 | T1 | ✅ |
| T6 | T4 | ✅ |
| T7 | T6 | ✅ |
| T8a | T7 | ✅ |
| T8b | T7 | ✅ |
| T8c | T7 | ✅ |
| T8d | T7 | ✅ |
| T9 | T8a, T8b, T8c, T8d | ✅ |
| T10 | T5 | ✅ |
| T11 | T5 | ✅ |
| T12 | T5 | ✅ |
| T13 | T10, T11, T12 | ✅ |
| T14 | T3 | ✅ |
| T15 | T14 | ✅ |
| T16 | T14 | ✅ |
| T17 | T14, T3, T4 | ✅ |
| T18 | T17, T14 | ✅ |
| T19 | T17, T14 | ✅ |
| T20 | T19 | ✅ |
| T21 | T15, T16, T20 | ✅ |
| T22 | T2, T3 | ✅ |
| T23 | T18, T19, T20, T21 | ✅ |
| T24 | T22, T23, T10, T11, T12, T6 | ✅ |
| T25 | T24 | ✅ |
| T26 | T3 | ✅ |
| T27 | T26 | ✅ |
| T28 | T26, T27, T25 | ✅ |
| T29 | T14 | ✅ |
| T30 | T15 | ✅ |
| T31 | T16 | ✅ |
| T32 | T18, T19, T20, T21 | ✅ |
| T33 | T22, T23 | ✅ |
| T34 | T10, T11, T12 | ✅ |
| T35 | T28, T29–T34 | ✅ |
| T36 | T35 | ✅ |

### Test Co-location Validation

| Task | Creates/Modifies | Required Tests (Matrix) | Task Tests Field | Matches? |
|------|-----------------|------------------------|-----------------|----------|
| T1 | Project scaffold | none | none | ✅ |
| T2 | ReturnCode enum | none → unit added for quality | unit | ✅ |
| T3 | Domain models | none | none | ✅ |
| T4 | FiscalYearRates | none | none | ✅ |
| T5 | Provider/WI models | none | none | ✅ |
| T6 | RateProvider | none → unit added | unit | ✅ |
| T7 | Rate YAML FY2021 | none → unit added | unit | ✅ |
| T8a-d | Rate YAML files | none → unit spot-checks | unit | ✅ |
| T9 | Rate integration test | integration | integration | ✅ |
| T10 | CBSA parser + repo | none → unit added | unit | ✅ |
| T11 | MSA parser + repo | none → unit added | unit | ✅ |
| T12 | Provider parser | none → unit added | unit | ✅ |
| T13 | DataLoader | none | none | ✅ |
| T14 | PaymentCalculator | none → unit added | unit | ✅ |
| T15 | RhcSplitCalculator | none → unit added | unit | ✅ |
| T16 | SiaCalculator | none → unit added | unit | ✅ |
| T17 | Strategy interface | none | none | ✅ |
| T18 | SimplePricerStrategy | none → unit added | unit | ✅ |
| T19 | TransitionPricerStrategy | none → unit added | unit | ✅ |
| T20 | ModernPricerStrategy | none → unit added | unit | ✅ |
| T21 | FullPricerStrategy | none → unit added | unit | ✅ |
| T22 | ValidationService | none → unit added | unit | ✅ |
| T23 | FiscalYearRouter | none → unit added | unit | ✅ |
| T24 | DriverService | none → unit added | unit | ✅ |
| T25 | REST Controller | none → unit added | unit | ✅ |
| T26 | Test data class | none | none | ✅ |
| T27 | Baseline capture | none | none | ✅ |
| T28 | Parity test | regression | regression | ✅ |
| T29-T34 | Unit test suites | unit | unit | ✅ |
| T35 | Coverage report | none | none | ✅ |
| T36 | E2E integration test | integration | integration | ✅ |

---

## Summary

| Metric | Count |
|--------|-------|
| Total tasks | 36 (+ 4 parallel sub-tasks T8a-d) |
| Phases | 8 |
| Parallel opportunities | T8a-d, T10-T12, T29-T34 |
| Requirement IDs covered | 29/29 (MIG-01 through MIG-29) |
| Estimated YAML rate files | 26 (24 FYs + 2 mid-year variants) |
| Estimated Java source files | ~30 |
| Estimated test files | ~15 |
