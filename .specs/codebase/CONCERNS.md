# Codebase Concerns

**Analysis Date:** 2026-04-11

## Tech Debt

**Massive code duplication across fiscal years (HOSPR210):**

- Issue: Each FY (1998–2021) has its own near-identical pricing paragraph. 24 FY blocks with duplicated validation, calculation, and output logic — only rate constants and minor rule variations differ.
- Files: `HOSPR210` (6,555 lines; ~5,500 lines are duplicated FY logic)
- Why: Each FY was added by copying the previous year's block and tweaking rates/rules. Pre-FY2016 rates are hard-coded inline.
- Impact: Any fix to calculation logic must be replicated across up to 24 FY blocks. High risk of inconsistent fixes. Obscures actual business rule differences between FYs.
- Fix approach: Extract common calculation patterns into shared paragraphs parameterized by rate values. Extend the HOSPRATE copybook approach (currently FY2016+ only) to cover all FYs.

**Hard-coded rates for FY1998–FY2015 (HOSPR210):**

- Issue: Payment rates for FY1998 through FY2015 are embedded as numeric literals in COMPUTE statements.
- Files: `HOSPR210` (FY paragraphs from `1998-PROCESS-DATA` through `2015-PROCESS-DATA`)
- Why: The HOSPRATE copybook pattern was only introduced in FY2016 (HOSPR160).
- Impact: Rates cannot be audited independently from code. Any rate correction requires a code change and recompile.
- Fix approach: Move all historical rates into the HOSPRATE copybook.

**Duplicate BILL-315-DATA LINKAGE definitions:**

- Issue: The 315-byte BILL-315-DATA record layout is defined identically in both HOSDR210 and HOSPR210 LINKAGE SECTIONs.
- Files: `HOSDR210` (lines 418–528), `HOSPR210` (lines 246–352)
- Why: Each program needs its own LINKAGE definition per COBOL standards, but the layout should be a shared copybook.
- Impact: Layout changes must be made in two places. A mismatch would cause silent data corruption.
- Fix approach: Create a `HOSBILL` copybook with the BILL-315-DATA layout and COPY it into both programs.

**Inconsistent COBOL sequence numbers:**

- Issue: Line numbers in `HOSPR210` are non-sequential and duplicated in multiple places (e.g., `003100` appears many times, `218800` reused across several lines).
- Files: `HOSPR210`, `HOSDR210`
- Why: Accumulated from decades of copy/paste edits without renumbering.
- Impact: Debugging with sequence number references is unreliable. No functional impact on compiled code.
- Fix approach: Renumber using IEBUPDTE or editor renumber utility.

## Fragile Areas

**Fiscal Year Date Routing (HOSPR210 PROCEDURE DIVISION):**

- Files: `HOSPR210` (lines ~450–570, the FY dispatch chain)
- Why fragile: Sequential `IF BILL-FROM-DATE > YYYYMMDD` checks depend on correct ordering (newest first). A new FY added in the wrong position or with an incorrect boundary date would silently route claims to the wrong FY's rates.
- Common failures: New FY inserted with wrong date boundary, or forgetting to add the new FY block entirely.
- Safe modification: Always add new FY block as the FIRST check (before existing checks). Verify the date boundary is exactly `YYYY0930` (Sept 30) of the prior FY.
- Test coverage: End-to-end JCL only. No unit test for the routing logic.

**MSA path missing HOSPR210 call (HOSDR210) — FIXED 2026-04-11:**

- Files: `HOSDR210` (paragraph `0350-GET-MSA`)
- Bug: The MSA wage index path (used for pre-FY2006 claims where `BILL-FROM-DATE <= 20050930`) performed wage index lookup but never called HOSPR210 (the pricer). The CBSA path (`0375-GET-CBSA`) correctly called `1000-CALL` (HOSPR210), but the MSA path fell through to `0350-EXIT` without invoking the pricer. Result: all pre-FY2006 bills returned RTC=00 with $0 payment.
- Fix: Added `PERFORM 1000-CALL THRU 1000-EXIT` before `0350-EXIT`, matching the CBSA path pattern.
- Impact: All pre-FY2006 test cases (TC09, TC29A, TC29B, TC30, TC31, TC32) now reach the pricer.

**Provider Table Sizing (HOSDR210):**

- Files: `HOSDR210` (lines 541–561: `OCCURS 2400`)
- Why fragile: Provider table is statically allocated for 2,400 entries. If provider file grows beyond this, the program will fail or corrupt memory with no graceful error.
- Common failures: Table overflow if provider count exceeds 2,400.
- Safe modification: Increase OCCURS value. Monitor actual provider count vs. table capacity.
- Test coverage: None — only tested implicitly by test data volume.

**CBSA/MSA Table Sizing:**

- Files: `HOSDR210` — `MSA-WI-TABLE OCCURS 4000`, `CBSA-WI-TABLE OCCURS 9000`
- Why fragile: Same static allocation concern. CBSA2021 has ~7,478 records fitting within 9,000, but annual growth could exceed capacity.
- Safe modification: Monitor CBSA record count each FY. Increase OCCURS if approaching limit.

**FY Boundary Date Calculation (HOSDR210):**

- Files: `HOSDR210` (lines 620–642)
- Why fragile: FY begin/end dates derived from claim discharge date using month range logic. Assumes fiscal year always starts Oct 1. A claim with invalid date fields could cause incorrect FY assignment.
- Safe modification: Add date validation before FY calculation.

## Test Coverage Gaps

**No unit tests for payment calculations:**

- What's not tested: Individual revenue code calculations (RHC/CHC/IRC/GIC), QIP reduction logic, SIA add-on calculations, RHC 60-day high/low rate split, date arithmetic for prior service days
- Risk: Calculation errors go unnoticed until end-to-end comparison catches discrepancies. Subtle rounding differences or edge cases (e.g., exactly 60 days, boundary units) are unlikely to be covered by a small test dataset.
- Priority: High
- Difficulty to test: Requires a COBOL unit testing framework or detailed test datasets covering edge cases.

**No tests for error paths:**

- What's not tested: Return codes 10, 20, 30, 40, 50, 51 — all error conditions rely on correct input data in the test bill file
- Risk: Error handling regressions undetected
- Priority: Medium
- Difficulty to test: Need test bill records that trigger each error condition.

**Missing test input files in repo:**

- What's not tested: BILLFILE, PROVFILE, MSAFILE not present in repository
- Risk: Tests cannot be reproduced from repo alone. No version control on test data.
- Priority: High
- Difficulty to test: Need to include sanitized test datasets in the repository.

## Missing Critical Features

**HOSOP210 not in repository:**

- Problem: The CICS online wrapper program that opens files and drives the processing is not present. The call chain is incomplete.
- Current workaround: Assumed to be compiled separately and stored in load libraries.
- Blocks: Cannot build the complete system from source in this repository alone.
- Implementation complexity: Low — HOSOP210 is a wrapper that opens files and iterates bill records.

---

_Concerns audit: 2026-04-11_
_Update as issues are fixed or new ones discovered_
