# Hospice PC Pricer

**Purpose:** Medicare/Medicaid Hospice Prospective Payment System (PPS) pricer — calculates per-diem and hourly payment amounts for hospice claims across fiscal years FY1998–FY2021.

## Vision

Maintain and validate the CMS Hospice Pricer module (HOSPR210) with a reproducible local test environment, enabling safe modifications, rate audits, and regression testing outside the mainframe.

## Goals

1. **Reproducible local testing** — Build and run the full pricer pipeline on Windows using GnuCOBOL 3.2, without mainframe access
2. **Comprehensive test coverage** — Validate all fiscal year paths, revenue codes, QIP reductions, RHC 60-day splits, SIA add-ons, and error conditions
3. **Documentation** — Maintain accurate business rules documentation and codebase analysis for knowledge transfer
4. **Bug identification and fix** — Find and fix discrepancies between test data, driver logic, and pricer expectations

## Scope

- **In scope:** HOSDR210 (driver), HOSPR210 (pricer), HOSPRATE (rates copybook), CBSA2021 (wage index data), local test harness (GENDATA, HOSOP210), test data generation and validation
- **Out of scope:** CICS online wrapper (production HOSOP210), mainframe JCL execution, SAS reporting, production deployment

## Non-Goals

- Refactoring the 24 FY-duplicated paragraphs in HOSPR210 (tech debt acknowledged, not currently planned)
- Adding new fiscal years beyond FY2021
- Unit test framework adoption (no COBOL unit testing tooling in current environment)
