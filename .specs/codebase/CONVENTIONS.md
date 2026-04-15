# Code Conventions

## Naming Conventions

**Files:**
No file extensions. Files named by program ID or data type:
- `HOSDR210` — Driver module (HOS=Hospice, DR=Driver, 210=FY2021 version)
- `HOSPR210` — Pricer module (PR=Pricer)
- `HOSPRATE` — Copybook (RATE=rates)
- `CBSA2021` — Data file (CBSA type + fiscal year)
- `TESTJCL` — Job control language for testing

**Version scheme:** 3-digit suffix encodes fiscal year: `210`=FY2021, `200`=FY2020, `190`=FY2019, etc.

**Programs:**
Pattern: `HOS{MODULE}{VERSION}` (8-char COBOL limit)
Examples: `HOSDR210`, `HOSPR210`, `HOSOP210`

**Paragraphs/Sections:**
- Numeric prefix for driver paragraphs: `0200-PROCESS-RECORDS`, `0700-GET-PROVIDER`
- FY-prefixed for pricer paragraphs: `2021-V210-PROCESS-DATA`, `2021-V210-RHC-0651`
- Common utility paragraphs: `V210-CALC-PRIOR-SVC-DAYS`, `V210-EVAL-RHC-DAYS`
- Every paragraph has a matching `*-EXIT` paragraph

**Variables:**
- `BILL-` prefix: Bill/claim record fields (I/O via LINKAGE)
- `P-NEW-` prefix: Provider record fields
- `W-` or `WRK-` prefix: Working storage temporaries
- `M-` prefix: Table data (MSA/CBSA)
- Suffix `-LS-RATE` / `-NLS-RATE`: Labor share / Non-labor share rate components
- Suffix `-Q`: QIP-adjusted (reduced) rate variant

**Constants:**
FY-year prefixed: `2021-V210-HIGH-RHC-LS-RATE`, `2016-RHC-LS-RATE`

**88-Level Conditions:**
Named with `P-N-` prefix for provider conditions:
Examples: `P-N-SOLE-COMMUNITY-PROV`, `P-N-REDESIGNATED-RURAL-YR1`

## Code Organization

**COBOL Division Structure:**
Each program follows standard order:
1. IDENTIFICATION DIVISION (PROGRAM-ID, history comments)
2. ENVIRONMENT DIVISION (SOURCE-COMPUTER/OBJECT-COMPUTER)
3. DATA DIVISION (FILE SECTION, WORKING-STORAGE, LINKAGE)
4. PROCEDURE DIVISION

**Line numbering:** COBOL sequence numbers in columns 1-6 (e.g., `000100`, `017800`)

**Import/Dependency:**
- `COPY HOSPRATE.` — single COPY statement to include rate copybook
- `CALL HOSPR210 USING BILL-315-DATA.` — inter-module calls

## Code Structure Within Files

**History comments:** Extensive version history at top of every program, documenting every FY revision from current back to earliest version.

**Paragraph flow:**
- Main control flow at top of PROCEDURE DIVISION
- FY routing uses descending date checks (newest FY first)
- Each FY block is self-contained with its own sub-paragraphs
- `PERFORM...THRU...EXIT` pattern used consistently throughout
- `GOBACK` terminates after each FY block processes

## Error Handling

**Pattern:** Return code (`BILL-RTC`) in output record
- `00` = Success (home rate returned)
- `10` = Bad units (>1000)
- `20` = Bad units2 (<8 for CHC)
- `30` = Bad MSA/CBSA code (not found in table)
- `40` = Bad provider wage index
- `50` = Bad beneficiary wage index
- `51` = Bad provider number
- `73-77` = Success with RHC rate detail (low/high, with/without SIA)

## Comments/Documentation

**Style:** `*` in column 7 for full-line comments. Extensive use of:
- Box comments (`*****...`) for section headers
- Separator lines (`*-------...`) for paragraph boundaries
- Inline narrative explaining business rules
- `==>>>>` arrows to highlight breaking changes (e.g., record length changes)
- `CR #NNNN` references to change requests
