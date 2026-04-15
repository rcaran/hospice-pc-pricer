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

### Integration Tests — 45 COBOL Parity Test Cases ✅

**Spec:** [.specs/features/integration-tests-45-cases/spec.md](../features/integration-tests-45-cases/spec.md)

Created full end-to-end integration test suite validating all 45 COBOL test cases (TC01–TC41) through the Spring Boot REST API pipeline.

- `CobolParityIntegrationTest.java` — 45 tests across 8 nested phases
- Test-specific `PROVFILE-TEST` with provider records covering FY1998–FY2021
- Real CBSA/MSA wage index lookups (no mocked data)
- Payment amount tolerance: ±$0.02
- 12 slot-mismatch cases validated with hand-calculated Java-correct values
- All 221 tests pass (45 integration + 176 existing)

---

## Planned

### Documentation Maintenance (Ongoing)

Keep `.specs/codebase/`, `.specs/project/`, and `docs/` synchronized with code changes.

---

### COBOL-to-Java Migration — COMPLETE ✅

**Priority:** P1
**Status:** Implemented and validated

**Goal:** Convert the entire Hospice PC Pricer from COBOL to a Java 21 + Spring Boot 4 REST API with full functional parity and comprehensive test coverage.

**Spec:** [.specs/features/cobol-to-java-migration/spec.md](../features/cobol-to-java-migration/spec.md)
**Design:** [.specs/features/cobol-to-java-migration/design.md](../features/cobol-to-java-migration/design.md)
**Tasks:** [.specs/features/cobol-to-java-migration/tasks.md](../features/cobol-to-java-migration/tasks.md)

**Scope:**
- 36 tasks across 8 phases
- 27 YAML rate config files (FY1998–FY2021 + mid-year variants)
- 31 Java source files, 11 test files (221 total test methods)
- 45 COBOL parity integration tests + 41 unit regression tests
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
