# Tech Stack

**Analyzed:** 2026-04-11

## Core

- Language: COBOL (IBM Enterprise COBOL)
- Runtime: IBM z/OS Mainframe (IBM-370 target)
- Transaction Monitor: CICS (referenced via HOSOP210 — online transaction wrapper)
- Job Control: JCL (Job Control Language)
- Reporting: SAS (embedded in JCL for output analysis)

## Build / Execution

- Compilation target: IBM-370 (`SOURCE-COMPUTER. IBM-370.` / `OBJECT-COMPUTER. IBM-370.`)
- Execution region: 9M (`REGION=9M` in JCL)
- Runtime library: `SYS1.@CEE.SCEERUN` (IBM Language Environment)
- Load library: User-defined (`HOSLOAD` PDS)

## Data Files

- Record format: Fixed Block (`RECFM=FB`)
- Bill record length: 315 bytes (upgraded from 135→215→315 over versions)
- Rate output record: 315 bytes (`LRECL=315`)
- SAS report output: Variable Block ASCII (`RECFM=VBA, LRECL=137`)

## External Data

- CBSA Wage Index file: Fixed-width positional data (CBSA code + effective date + wage index + area name)
- MSA Wage Index file: Fixed-width positional data (legacy, pre-2006)
- Provider file: Fixed-width 240-byte records (3 × 80-byte segments)

## Testing

- Framework: JCL batch test execution with SAS report comparison
- No unit test framework detected
- Validation via SAS `PROC PRINT` output analysis

## Local Test Environment (GnuCOBOL)

- Compiler: GnuCOBOL 3.2 (Arnold Trembley's GC32-NODB-SP1 build)
- Location: `tools/gnucobol32/`
- Platform: Windows x86-64
- Compilation: `-fixed -std=ibm` mode (IBM COBOL compatibility)
- Modules: Compiled as `.dll` (Windows) instead of `.so` (Linux)
- Source prep: Strip 6-digit IBM line numbers, patch COPY statements for `.cpy` extension
- Build automation: `test/build-and-run.bat` (7-step PowerShell/batch script)
- Output format: LINE SEQUENTIAL (trims trailing spaces; RATEFILE records ~275 bytes vs 315)

## Development Tools

- Version control: File-level naming convention (version suffix: 210, 200, 190, etc.)
- Build automation: `test/build-and-run.bat` for local GnuCOBOL builds
- No mainframe CI/CD detected
