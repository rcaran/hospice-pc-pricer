# Integration Tests — 45 COBOL Parity Test Cases

## Objective

Create end-to-end integration tests for the `hospice-pricer-api` REST endpoint (`POST /api/v1/hospice/price`)
that validate all 45 test cases from the COBOL test suite (TC01–TC41, including TC08B and TC27A/B).

## Scope

- **Test type**: Spring Boot `@SpringBootTest` with `MockMvc`
- **Data source**: Real reference files (CBSA2021, MSAFILE, PROVFILE) from `classpath:data/`
- **Expected values**: From COBOL RATEFILE output with real CBSA wage indexes
- **Tolerance**: Payment amounts ±$0.01 (COBOL rounding differences)

## Key Design Decisions

### COBOL Slot vs Java Code Routing

The COBOL pricer processes revenue codes by fixed slot position (REV1→0651, REV2→0652, etc.).
The Java API routes by revenue code type regardless of request order.

**Impact**: 12 test cases (TC02-TC04, TC14-TC19, TC28A-B, TC31, TC32, TC34) placed non-RHC codes
in REV1 slot in the COBOL GENDATA. The COBOL pricer produced $0/RTC=00 for these.
The Java API correctly processes them, so expected values differ from RATEFILE.

**Strategy**:
- For 33 cases matching COBOL behavior: assert against RATEFILE values
- For 12 slot-mismatch cases: assert against hand-calculated values using COBOL rates + real CBSA WI

### Wage Index Sources

| Provider | CBSA  | FY Range       | WI      |
|----------|-------|----------------|---------|
| 341234   | 16740 | FY2021         | 0.9337  |
| 341234   | 16740 | FY2020         | 0.9337  |
| 341234   | 16740 | FY2014         | 0.9385  |
| 341234   | 16740 | FY2015         | 0.9535  |
| 341234   | 16740 | FY2008         | 1.0191  |
| 341234   | 16740 | FY2010         | 1.0128  |
| 341234   | 16740 | FY2011         | 0.9751  |
| 341234   | 16740 | FY2013         | 0.9385  |
| 341234   | 16740 | FY2007/2007_1  | 1.0369  |
| 341235   | 35614 | FY2020         | 1.2745  |
| 341236   | 10180 | FY2016/2016_1  | 0.8000  |
| 341234   | 6740  | Pre-2006 (MSA) | 1.0000  |

## Test Phases

| Phase | TCs                | Category                    | Count |
|-------|--------------------|-----------------------------|-------|
| 0     | TC01-TC07          | Base FY2021 cases           | 7     |
| 1     | TC08, TC08B, TC09  | Validation                  | 3     |
| 3     | TC10-TC13          | RHC 60-day split            | 4     |
| 4-5   | TC14-TC20          | CHC complete + QIP          | 7     |
| 6-7   | TC21-TC23          | SIA complete + multi-code   | 3     |
| 8-9   | TC24-TC29          | FY boundaries               | 8     |
| 10-11 | TC30-TC41          | Representative FYs + CHC    | 13    |
|       |                    | **Total**                   | **45**|

## File

`src/test/java/com/cms/hospice/regression/CobolParityIntegrationTest.java`
