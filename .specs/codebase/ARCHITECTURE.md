# Architecture

**Pattern:** Layered batch processing — Driver/Pricer/Copybook with CALL-based module separation

## High-Level Structure

```
┌─────────────────────────────────────────────────────┐
│                   TESTJCL (JCL)                     │
│            Job orchestration & SAS reporting         │
└────────────────────────┬────────────────────────────┘
                         │ executes
                         ▼
┌─────────────────────────────────────────────────────┐
│               HOSOP210 (not in repo)                │
│       CICS Online wrapper / File opener             │
│       Opens files, invokes driver                   │
└────────────────────────┬────────────────────────────┘
                         │ CALL
                         ▼
┌─────────────────────────────────────────────────────┐
│                 HOSDR210 (Driver)                    │
│  - Receives BILL-315-DATA via LINKAGE SECTION       │
│  - Loads PROV-TABLE, MSA-WI-TABLE, CBSA-WI-TABLE   │
│  - Looks up provider, wage index by MSA/CBSA        │
│  - Sets fiscal year boundaries                      │
│  - Delegates pricing to HOSPR210                    │
└────────────────────────┬────────────────────────────┘
                         │ CALL HOSPR210
                         ▼
┌─────────────────────────────────────────────────────┐
│                 HOSPR210 (Pricer)                    │
│  - Determines fiscal year from BILL-FROM-DATE       │
│  - Routes to FY-specific pricing paragraph          │
│  - Calculates payment per revenue code (0651-0656)  │
│  - Applies wage index, QIP reduction, SIA add-on    │
│  - Returns payment amounts + return code (RTC)      │
└─────────────────────────────────────────────────────┘
         │ COPY
         ▼
┌─────────────────────────────────────────────────────┐
│               HOSPRATE (Copybook)                   │
│  - Payment rate constants by fiscal year            │
│  - FY2016 through FY2021 rates                      │
│  - LS (labor share) and NLS (non-labor share) rates │
│  - QIP-adjusted (-Q) rate variants                  │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│                CBSA2021 (Data File)                  │
│  - CBSA wage index reference data                   │
│  - Multi-year entries (FY2006–FY2021)               │
│  - ~7,478 records, positional fixed-width            │
└─────────────────────────────────────────────────────┘
```

## Identified Patterns

### 1. Fiscal Year Routing (Date-Based Dispatch)

**Location:** `HOSPR210` PROCEDURE DIVISION, main flow
**Purpose:** Route each claim to the correct fiscal year pricing logic
**Implementation:** Sequential `IF BILL-FROM-DATE > YYYYMMDD` checks, descending from FY2021 to FY1998. Each branch PERFORMs a FY-specific paragraph then GOBACKs.
**Example:** `IF BILL-FROM-DATE > 20200930 PERFORM 2021-V210-PROCESS-DATA THRU 2021-V210-PROCESS-EXIT GOBACK.`

### 2. Wage-Index Lookup (Table Search)

**Location:** `HOSDR210` paragraphs 0400/0450/0500/0525/0550/0575
**Purpose:** Find the applicable wage index for provider and beneficiary locations
**Implementation:** COBOL `SEARCH` verb on in-memory tables (MSA-WI-TABLE, CBSA-WI-TABLE) loaded from flat files. Provider wage index uses provider CBSA; beneficiary wage index uses beneficiary CBSA. FY boundary validation ensures correct effective date.
**Two paths:**
- **CBSA path** (`0375-GET-CBSA`): For claims with `BILL-FROM-DATE > 20050930`. Performs CBSA lookup then invokes pricer via `1000-CALL`.
- **MSA path** (`0350-GET-MSA`): For claims with `BILL-FROM-DATE <= 20050930`. Performs legacy MSA lookup then invokes pricer via `1000-CALL`. *(Note: MSA path was missing the pricer call prior to 2026-04-11 fix.)*
**Example:** `SEARCH M-CBSA-DATA VARYING CU1 ... WHEN M-CBSA(CU1) = SEARCH-CBSA`

### 3. Revenue Code Payment Calculation

**Location:** Each FY paragraph in `HOSPR210` (e.g., `2021-V210-RHC-0651`)
**Purpose:** Calculate per-diem or hourly payment based on service type
**Implementation:** Formula: `(LS-RATE × WAGE-INDEX + NLS-RATE) × UNITS`. Four revenue codes map to four levels of care:
- 0651: RHC (Routine Home Care) — 1 unit = 1 day
- 0652: CHC (Continuous Home Care) — 1 unit = 15 minutes
- 0655: IRC (Inpatient Respite Care) — 1 unit = 1 day
- 0656: GIC (General Inpatient Care) — 1 unit = 1 day

### 4. RHC High/Low Rate Split (60-Day Rule)

**Location:** `V210-EVAL-RHC-DAYS` and related paragraphs
**Purpose:** Apply different per-diem rates based on days since admission
**Implementation:** From FY2016 onward (CR #9289), RHC has two rates: HIGH (first 60 days) and LOW (after 60 days). Prior service days calculated from admission date + prior benefit days. Days are split between high and low rates when a claim spans the 60-day boundary.

### 5. QIP (Quality Indicator Percentage) Reduction

**Location:** Throughout FY2014+ pricing paragraphs
**Purpose:** Apply reduced rates if provider's quality metrics trigger QIP
**Implementation:** `IF BILL-QIP-IND = '1'` selects `-Q` (reduced) rate variants from HOSPRATE copybook. Standard rates used otherwise.

### 6. SIA (Service Intensity Add-on) End-of-Life

**Location:** `V210-CALC-RHC-EOL-SIA` and related paragraphs
**Purpose:** Calculate additional payment for intensive end-of-life care
**Implementation:** Up to 7 days of EOL add-on. Each day capped at 4 hours (16 units × 15 min). Payment = hourly CHC rate × hours. Added to total claim payment.

## Data Flow

### Claim Pricing Flow

```
1. JCL submits job with input files (BILLFILE, PROVFILE, CBSAFILE, MSAFILE)
2. HOSOP210 opens files, loads tables into memory
3. For each bill record:
   a. HOSDR210 receives BILL-315-DATA
   b. Calculates FY begin/end dates from discharge date
   c. Looks up provider in PROV-TABLE (SEARCH by PROV-NO)
   d. Looks up wage indices in CBSA-WI-TABLE or MSA-WI-TABLE
   e. CALLs HOSPR210 with populated BILL-315-DATA
   f. HOSPR210 routes to FY-specific logic
   g. Calculates payments per revenue code
   h. Returns: PAY-AMT1-4, PAY-AMT-TOTAL, RTC, RHC-DAYS
4. Output written to RATEFILE (315-byte fixed records)
5. SAS step reads output, generates formatted report
```

## Code Organization

**Approach:** Module-based separation with CALL/COPY linkage

- **Driver** (HOSDR210): Data access, lookups, orchestration
- **Pricer** (HOSPR210): Business rules, payment calculations
- **Copybook** (HOSPRATE): Externalized rate constants (FY2016+)
- **Data** (CBSA2021): Reference data for wage index lookups
- **JCL** (TESTJCL): Batch execution and reporting

**Module boundaries:** LINKAGE SECTION defines the contract — BILL-315-DATA (315 bytes) is the shared I/O record passed between driver and pricer.
