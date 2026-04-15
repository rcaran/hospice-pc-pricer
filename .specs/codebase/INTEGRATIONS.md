# External Integrations

## File-Based Data Integrations

### CBSA Wage Index File (CBSAFILE)

**Purpose:** Provides geographic wage index values for CBSA (Core-Based Statistical Area) codes
**Implementation:** Flat file loaded into `CBSA-WI-TABLE` (9,000 entries) in HOSDR210
**Source:** CMS (Centers for Medicare and Medicaid Services) — annual publication
**Format:** Fixed-width positional: CBSA(5) + EffDate(8) + WageIndex(6) + Filler(6) + AreaName
**File in repo:** `CBSA2021`
**Refresh cycle:** Annual (each fiscal year starting October 1)

### MSA Wage Index File (MSAFILE)

**Purpose:** Legacy geographic wage index for MSA codes (pre-CBSA era, pre-FY2006)
**Implementation:** Flat file loaded into `MSA-WI-TABLE` (4,000 entries) in HOSDR210
**Source:** CMS — historical data
**Format:** Fixed-width: MSA(4) + Lugar(1) + EffDate(8) + WageIndex(signed 6)
**File in repo:** `run/MSAFILE` — 1 record (MSA 6740, WI=1.0000, EffDate=19981001)
**Production reference:** `HOSPV160.MSAH050`
**Note:** Only used for claims with `BILL-FROM-DATE < 20051001`. Local MSAFILE created with neutral wage index (1.0000) for 6 pre-FY2006 test cases.

### Provider File (PROVFILE)

**Purpose:** Provider reference data — geography, census division, special payment indicators
**Implementation:** Flat file loaded into `PROV-TABLE` (2,400 entries × 3 segments) in HOSDR210
**Source:** CMS provider enrollment data
**Format:** 3 × 80-byte fixed segments per provider (240 bytes total):
  - Segment 1: NPI, provider number, dates, waiver codes, MSA/CBSA data
  - Segment 2: Financial variables, CBSA special pay indicators
  - Segment 3: Pass-through amounts, capital data
**File in repo:** Not present (referenced as `HOSPV210.PROVFILE`)

### Bill Input File (BILLFILE)

**Purpose:** Hospice claim records to be priced
**Implementation:** 315-byte fixed records read by HOSOP210, passed to HOSDR210/HOSPR210
**Source:** CMS claims processing system
**Format:** BILL-315-DATA layout (defined in LINKAGE SECTION)
**File in repo:** Not present (referenced as `HOSPV210.PRODBILL.INPUT`)

## Program Integrations

### HOSOP210 (CICS Online Wrapper)

**Purpose:** Opens files, loads tables, and invokes HOSDR210 in a CICS transaction or batch environment
**Implementation:** Called by JCL as main program; CALLs HOSDR210 for each bill
**File in repo:** Not present (compiled load module only)
**Authentication:** z/OS RACF (assumed, standard for CMS mainframe)

## Output Integrations

### Rate Output File (RATEFILE)

**Purpose:** Priced claim records with payment amounts and return codes
**Format:** 315-byte fixed records (`RECFM=FB, LRECL=315`)
**Consumers:** SAS reporting step in TESTJCL; downstream CMS payment systems
**File in repo:** Generated at runtime

### SAS Report (SASLIST)

**Purpose:** Human-readable report of priced claims for validation
**Implementation:** Embedded SAS `DATA` step and `PROC PRINT` in TESTJCL
**Format:** Variable block ASCII (`RECFM=VBA, LRECL=137`)

## Background Jobs

**Queue system:** JES2 (Job Entry Subsystem) on z/OS
**Location:** TESTJCL defines the job stream
**Jobs:** Single batch job (`K1P6TEST`) with delete/run/report steps

## Webhooks

None — batch-only processing, no event-driven integrations.
