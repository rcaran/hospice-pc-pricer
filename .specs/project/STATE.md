# Project State

**Last updated:** 2026-04-11

## Current Focus

Documentation refresh — all `.specs/` and `docs/` files updated to reflect current codebase state after FIX-GENDATA-001 completion.

## Decisions

| Date | Decision | Context |
|------|----------|---------|
| 2026-04-11 | Use GnuCOBOL 3.2 on Windows for local testing | No mainframe access available; GnuCOBOL at `tools/gnucobol32/` |
| 2026-04-11 | MSAFILE uses WI=1.0000 (neutral reference) | Simplifies expected payment verification for pre-FY2006 test cases |
| 2026-04-11 | GENDATA bugs fixed before expanding test coverage | 15 of 40 test cases were invalid; no point adding more until existing ones work |

## Blockers

None currently.

## Lessons Learned

- **QIP-IND check:** HOSPR210 uses `'1'` not `'Y'` for QIP flag. The COBOL `IF BILL-QIP-IND = '1'` pattern is consistent across all 24 FY blocks.
- **Provider INITIALIZE:** COBOL working storage segments must be explicitly initialized between provider blocks to avoid field inheritance.
- **MSA path bug:** HOSDR210 paragraph `0350-GET-MSA` was missing the `PERFORM 1000-CALL` to invoke the pricer. The parallel CBSA path (`0375-GET-CBSA`) had it. This pattern — two parallel paths where one is missing a critical step — is a common COBOL maintenance bug.
- **LINE SEQUENTIAL truncation:** GnuCOBOL LINE SEQUENTIAL output trims trailing spaces. RATEFILE records come out as ~275 bytes instead of 315. Fields near the end of the record (PAY-TOTAL, RTC) may be truncated.

## Deferred Ideas

- Extract common FY calculation logic into shared paragraphs (major refactor, 24 FY blocks)
- Move FY1998–FY2015 hard-coded rates into HOSPRATE copybook
- Create shared HOSBILL copybook for BILL-315-DATA layout (currently duplicated in HOSDR210 and HOSPR210)
- Adopt COBOL unit testing framework (COBOLcheck or similar)

## Preferences

- **Language:** Documentation in Portuguese where user-facing; English for `.specs/` technical docs
- **Build:** Use `test/build-and-run.bat` for full rebuild; bash commands documented in repo memory for manual builds
