# Roadmap

## Completed

### FIX-GENDATA-001 — Fix Test Data Generator Bugs ✅

**Spec:** [.specs/features/fix-gendata-bugs/spec.md](../features/fix-gendata-bugs/spec.md)

Fixed 3 critical bugs + 1 infrastructure gap in `test/GENDATA.cbl` that were invalidating 15 of 40 test cases:

- REQ-01: QIP-IND `"Y"` → `"1"` (7 test cases) ✅
- REQ-02: Provider 2 missing INITIALIZE (TC06) ✅
- REQ-03: Missing run/MSAFILE for pre-FY2006 cases (6 test cases) ✅
- Bonus: MSA path in HOSDR210 was not calling pricer — fixed ✅

### Brownfield Mapping ✅

Codebase analysis documented in `.specs/codebase/` (7 docs).

---

## Planned

### Validate Test Output (Next)

**Priority:** P1
**Status:** Not started

Verify all 40 test cases (TC01–TC36 + TC08B) produce expected payment amounts and return codes against business rules in `docs/regras-negocio-HOSPR210-PricerModule.md`. Includes:

- Confirm REQ-04 (WI=0 for TC01–TC07) is resolved by CBSAFILE lookup override
- Spot-check QIP-reduced test cases (TC05, TC17–TC20, TC25–TC26) against expected rates
- Verify pre-FY2006 test cases (TC09, TC29A/B, TC30–TC32) reach pricer with correct MSA wage index

### Expand Test Coverage (Future)

**Priority:** P2
**Status:** Not started

The test plan (`docs/plano-execucao-casos-teste.md`) defines 38 additional test cases (TC08–TC46) covering:

- P1: Wage index validation, input validation (RTC 10/20), RHC 60-day logic
- P2: CHC ≥32 units, QIP variants (CHC/IRC/GIC), SIA edge cases, multi-revenue-code bills
- P3: FY boundary transitions, representative FYs across the FY1998–FY2021 range

Note: TC08–TC36 + TC08B are already implemented in GENDATA.cbl. TC37–TC46 are referenced in the plan total but not yet specified.

### Documentation Maintenance (Ongoing)

Keep `.specs/codebase/`, `.specs/project/`, and `docs/` synchronized with code changes.

---

### COBOL-to-Java Migration — PLANNED

**Priority:** P1
**Status:** Planning complete — awaiting execution

**Goal:** Convert the entire Hospice PC Pricer from COBOL to a Java 21 + Spring Boot 4 REST API with full functional parity and comprehensive test coverage.

**Spec:** [.specs/features/cobol-to-java-migration/spec.md](../features/cobol-to-java-migration/spec.md)
**Design:** [.specs/features/cobol-to-java-migration/design.md](../features/cobol-to-java-migration/design.md)
**Tasks:** [.specs/features/cobol-to-java-migration/tasks.md](../features/cobol-to-java-migration/tasks.md)

**Scope:**
- 36 tasks across 8 phases
- 26 YAML rate config files (FY1998–FY2021 + mid-year variants)
- ~30 Java source files, ~15 test files
- 40 COBOL parity regression tests (TC01–TC36 + TC08B)
- REST API: POST /api/v1/hospice/price
- Strategy pattern replacing 24 duplicated FY blocks
- All rates externalized to YAML (no hard-coded values)

**Requirements:** 29 traced requirements (MIG-01 through MIG-29)

---

## Future Considerations

- Add fiscal years beyond FY2021
- Database persistence layer (replace in-memory file loading)
- Authentication/authorization on the API
- Batch file processing mode (adapter over REST)
- OpenAPI/Swagger documentation (P3 in spec)
- Containerization (Docker) and CI/CD pipeline
