# SKF_LY Consolidation Description

## Status: REQUIRES VALIDATION

## Final Consumer Identification
**Final Consumer:** CV_COMP_SKF_ACTUAL_STATIC

**Type:** Calculation View (CUBE with Aggregation)

**Purpose:** Provides weekly SKF (Store Key Figures) actuals with store attributes, comp flags, profit center hierarchy, retail calendar, and profit center text.

---

## Artifact Dependency Mapping

### Dependency Chain (from SKF_LY File Relationships Table)

1. **CV_BASE_MD_SRPACT_S4** (Score: 100)
   - Relationship: Source Dependency → STP_WSS_SRP_ATTRIBUTES
   - Reason: Stored procedure reads from this view to populate TBL_WSS_SRP_ATTR_ACT

2. **CV_BASE_MD_COMPFL_S4** (Score: 100)
   - Relationship: Source Dependency → STP_WSS_SRP_ATTRIBUTES
   - Reason: Stored procedure reads from this view to populate TBL_WSS_SRP_COMPFLAG

3. **STP_WSS_SRP_ATTRIBUTES** (Score: 95)
   - Relationship: Logic Provider → CV_COMP_MD_SRPACT_STATIC
   - Relationship: Logic Provider → CV_COMP_MD_COMPFL_STATIC
   - Reason: Populates tables that are data sources for these views

4. **CV_COMP_MD_SRPACT_STATIC** (Score: 90)
   - Relationship: Calculation View Dependency → CV_COMP_SKF_ACTUAL_STATIC
   - Reason: Provides store attribute data

5. **CV_COMP_MD_COMPFL_STATIC** (Score: 90)
   - Relationship: Calculation View Dependency → CV_COMP_SKF_ACTUAL_STATIC
   - Reason: Provides comp flag data

6. **CV_BASE_SKF_WEEKLY_ACTUAL_S4** (Score: 90)
   - Relationship: Calculation View Dependency → CV_COMP_SKF_ACTUAL_STATIC
   - Reason: Provides weekly actuals data

7. **CV_BASE_MD_HRRP_NODE_S4** (Score: 90)
   - Relationship: Calculation View Dependency → CV_COMP_SKF_ACTUAL_STATIC
   - Reason: Provides profit center hierarchy

8. **CV_BASE_MD_RCALWEEK_S4** (Score: 90)
   - Relationship: Calculation View Dependency → CV_COMP_SKF_ACTUAL_STATIC
   - Reason: Provides retail calendar week data

9. **CV_BASE_MD_CEPCT_S4** (Score: 90)
   - Relationship: Calculation View Dependency → CV_COMP_SKF_ACTUAL_STATIC
   - Reason: Provides profit center text

---

## File Classification

### USED Files (11 total)

1. **CV_BASE_MD_SRPACT_S4** - USED
   - Reason: Source for STP_WSS_SRP_ATTRIBUTES procedure

2. **CV_BASE_MD_COMPFL_S4** - USED
   - Reason: Source for STP_WSS_SRP_ATTRIBUTES procedure

3. **STP_WSS_SRP_ATTRIBUTES** - USED
   - Reason: Populates tables consumed by CV_COMP_MD_SRPACT_STATIC and CV_COMP_MD_COMPFL_STATIC

4. **CV_COMP_MD_SRPACT_STATIC** - USED
   - Reason: Direct dependency of CV_COMP_SKF_ACTUAL_STATIC (store attributes)

5. **CV_COMP_MD_COMPFL_STATIC** - USED
   - Reason: Direct dependency of CV_COMP_SKF_ACTUAL_STATIC (comp flags)

6. **CV_BASE_SKF_WEEKLY_ACTUAL_S4** - USED
   - Reason: Direct dependency of CV_COMP_SKF_ACTUAL_STATIC (weekly actuals)

7. **CV_BASE_MD_HRRP_NODE_S4** - USED
   - Reason: Direct dependency of CV_COMP_SKF_ACTUAL_STATIC (hierarchy)

8. **CV_BASE_MD_RCALWEEK_S4** - USED
   - Reason: Direct dependency of CV_COMP_SKF_ACTUAL_STATIC (calendar)

9. **CV_BASE_MD_CEPCT_S4** - USED
   - Reason: Direct dependency of CV_COMP_SKF_ACTUAL_STATIC (profit center text)

10. **SKF_LY File Relationships Table** - USED
    - Reason: Defines all dependencies and relationships

11. **hana_to_bq_column_mapping 1.csv** - USED
    - Reason: Provides table and column mappings (incomplete)

### NOT USED Files
None - all files participate in the dependency chain.

---

## Validation Issues

### 1. PROCEDURAL SEMANTICS CANNOT BE REPRESENTED AS A SINGLE QUERY

**Issue:** The stored procedure STP_WSS_SRP_ATTRIBUTES contains procedural logic that cannot be safely consolidated into a single SELECT query:

**Procedural Steps:**
```
1. DECLARE V_WEEK (computed via SFN_PRIOR_FISCAL_WEEK function)
2. DELETE FROM TBL_WSS_SRP_ATTR_ACT
3. DELETE FROM TBL_WSS_SRP_COMPFLAG
4. INSERT INTO TBL_WSS_SRP_ATTR_ACT (from CV_BASE_MD_SRPACT_S4)
5. INSERT INTO TBL_WSS_SRP_COMPFLAG (from CV_BASE_MD_COMPFL_S4, filtered by V_WEEK)
```

**Why This Cannot Be Consolidated:**
- The DELETE operations clear existing data before INSERT
- The INSERT operations populate tables that are then read by downstream views
- Session-dependent values (CURRENT_TIMESTAMP, SESSION_USER) are materialized
- The execution order (DELETE → INSERT → SELECT) is semantically significant
- The V_WEEK parameter is computed dynamically and used as a filter

**Impact:**
- CV_COMP_MD_SRPACT_STATIC reads from TBL_WSS_SRP_ATTR_ACT
- CV_COMP_MD_COMPFL_STATIC reads from TBL_WSS_SRP_COMPFLAG
- These tables must be populated before the final consumer query runs

**Recommended Solution:**
1. Implement STP_WSS_SRP_ATTRIBUTES as a separate BigQuery stored procedure
2. Schedule the procedure to run before CV_COMP_SKF_ACTUAL_STATIC is queried
3. Treat TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG as materialized staging tables

---

### 2. UNRESOLVED FUNCTION

**Function:** `CVS_FRIP.CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK()`

**Usage:** Called in STP_WSS_SRP_ATTRIBUTES to compute V_WEEK parameter

**Issue:** No BigQuery equivalent exists for this HANA scalar function

**Current Placeholder:**
```sql
DECLARE V_WEEK STRING;
SET V_WEEK = (SELECT CAST(NULL AS STRING));  -- UNRESOLVED
```

**Required Action:**
- Implement as a BigQuery UDF that returns the prior fiscal week as STRING
- OR provide V_WEEK as a runtime parameter
- OR implement the fiscal week logic inline

**Business Logic (Unknown):**
- The function computes the prior fiscal week based on some calendar logic
- The exact logic is not present in the provided files
- Must be obtained from the HANA function definition or business requirements

---

### 3. MISSING COLUMN MAPPINGS

**Issue:** The column mapping file `hana_to_bq_column_mapping 1.csv` does not contain mappings for all columns referenced in the final consumer query.

**Missing Mappings:**
- Calculated columns (e.g., `CAL_ZIO_SKFQ_QTY`, `CAL_WEEK_NUMBER`)
- Renamed measures (e.g., `_BIC_ZIO_SKFQ_90as1`)
- Intermediate view columns not present in terminal sources

**Impact:**
- Cannot safely map all terminal source tables and columns
- Cannot validate that all BigQuery table/column references are correct

**Required Action:**
- Provide complete column mappings for all referenced columns
- OR confirm that calculated columns do not require mapping
- OR provide terminal source mappings for all intermediate views

---

## Dependency Expansion and Point-of-Consumption Mapping

### Final Consumer Flow (CV_COMP_SKF_ACTUAL_STATIC)

The final consumer follows this transformation flow:

1. **WEEKLY_SNAPSHOT_DS05** (from CV_BASE_SKF_WEEKLY_ACTUAL_S4)
   - Filters: FISCVARNT = 'K4', _BIC_ZIO_SWEEK = @IP_WEEK_LY, _BIC_ZIO_VER = @IP_VERSION, _BIC_ZIO_SAUDT IN ('1','10'), _BIC_ZIO_PSKF IN ('804013','801000')

2. **CC_HIER** (from CV_BASE_MD_HRRP_NODE_S4)
   - Filters: PARNODE LIKE '%CORERET%', HRYVALTO = '99991231'

3. **Join_3** (INNER JOIN)
   - WEEKLY_SNAPSHOT_DS05 ⋈ CC_HIER
   - ON: _B631_S_COSTCNTR = NODEVALUE AND MANDT

4. **Projection_1**
   - Adds CAL_WEEK = @IP_WEEK_CY

5. **STORE_ATTR_ACTUAL** (from CV_COMP_MD_SRPACT_STATIC)
   - Source: TBL_WSS_SRP_ATTR_ACT (populated by STP_WSS_SRP_ATTRIBUTES)

6. **Join_2** (LEFT OUTER JOIN)
   - Projection_1 ⋈ STORE_ATTR_ACTUAL
   - ON: _B631_S_PROFTCTR = PRCTR AND MANDT

7. **RETAIL_CAL** (from CV_BASE_MD_RCALWEEK_S4)

8. **Join_1** (LEFT OUTER JOIN)
   - Join_2 ⋈ RETAIL_CAL
   - ON: CAL_WEEK = ZZWEEK

9. **COMP_FLAG_ACT01** (from CV_COMP_MD_COMPFL_STATIC)
   - Source: TBL_WSS_SRP_COMPFLAG (populated by STP_WSS_SRP_ATTRIBUTES)
   - Filters: ZWEEK >= @IP_WEEK_ENDING_FROM, ZWEEK <= @IP_WEEK_ENDING_TO, COMP_VER = @IP_VERSION_COMP_FLAG

10. **Join_4** (LEFT OUTER JOIN)
    - Join_1 ⋈ COMP_FLAG_ACT01
    - ON: _B631_S_PROFTCTR = PRCTR AND MANDT

11. **PROFIT_CENTER_TEXT** (from CV_BASE_MD_CEPCT_S4)

12. **Join_5** (LEFT OUTER JOIN)
    - Join_4 ⋈ PROFIT_CENTER_TEXT
    - ON: _B631_S_PROFTCTR = PRCTR AND MANDT

13. **FLAGS**
    - Adds calculated columns: CAL_WEEK_NUMBER = RIGHT(CAL_WEEK, 2), CAL_ZIO_SKFQ_QTY = CASE WHEN _BIC_ZIO_PSKF = '804013' THEN _BIC_ZIO_SKFQ * 2 ELSE _BIC_ZIO_SKFQ END

14. **Final Output**
    - GROUP BY all non-measure columns
    - SUM all measures

---

## CTE Mapping

### Preserved Final-Consumer CTEs
- WEEKLY_SNAPSHOT_DS05
- CC_HIER
- STORE_ATTR_ACTUAL
- RETAIL_CAL
- COMP_FLAG_ACT01
- PROFIT_CENTER_TEXT
- FLAGS

### Helper CTEs (Preserved)
- Join_3
- Projection_1
- Join_2
- Join_1
- Join_4
- Join_5

**Justification:** All CTEs are preserved as they represent distinct semantic boundaries (filters, joins, projections, calculated columns) that cannot be safely combined without changing behavior.

---

## Table and Column Mapping Applied

### Terminal Sources Identified

1. **CV_BASE_SKF_WEEKLY_ACTUAL_S4**
   - Terminal Source: `edp-qa-finstorage.edp_saps4_shared_cnsv.bic_azsrp_ds112`
   - Mapping Status: Partial (not all columns mapped)

2. **CV_BASE_MD_HRRP_NODE_S4**
   - Terminal Source: `edp-qa-finstorage.edp_saps4_shared_cnsv.hrrp_node`
   - Mapping Status: Complete

3. **CV_COMP_MD_SRPACT_STATIC**
   - Terminal Source: TBL_WSS_SRP_ATTR_ACT (populated by procedure)
   - Mapping Status: Not in mapping file (staging table)

4. **CV_BASE_MD_RCALWEEK_S4**
   - Terminal Source: `edp-qa-finstorage.edp_saps4_shared_cnsv.ztfigl_rcalweek`
   - Mapping Status: Complete

5. **CV_COMP_MD_COMPFL_STATIC**
   - Terminal Source: TBL_WSS_SRP_COMPFLAG (populated by procedure)
   - Mapping Status: Not in mapping file (staging table)

6. **CV_BASE_MD_CEPCT_S4**
   - Terminal Source: `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct`
   - Mapping Status: Complete

### REVIEW Items
None identified in the provided mapping file.

### Missing Mappings
- TBL_WSS_SRP_ATTR_ACT (staging table, not in mapping file)
- TBL_WSS_SRP_COMPFLAG (staging table, not in mapping file)
- Calculated columns (CAL_WEEK_NUMBER, CAL_ZIO_SKFQ_QTY)
- Renamed measures (_BIC_ZIO_SKFQ_90as1)

---

## Parameter Documentation

### Input Parameters (from CV_COMP_SKF_ACTUAL_STATIC)

1. **@IP_VERSION**
   - Type: STRING
   - Default: 'ACT01'
   - Usage: Filters _BIC_ZIO_VER in WEEKLY_SNAPSHOT_DS05
   - Source: Runtime parameter
   - Reason Unresolved: No default value mechanism in BigQuery; must be provided by caller

2. **@IP_VERSION_COMP_FLAG**
   - Type: STRING
   - Default: Derived via scalar function (not provided)
   - Usage: Filters COMP_VER in COMP_FLAG_ACT01
   - Source: Derived from @IP_VERSION
   - Reason Unresolved: Scalar function logic not provided

3. **@IP_WEEK_ENDING_FROM**
   - Type: STRING
   - Default: Derived via scalar function (not provided)
   - Usage: Filters ZWEEK >= in COMP_FLAG_ACT01
   - Source: Derived from @IP_VERSION
   - Reason Unresolved: Scalar function logic not provided

4. **@IP_WEEK_ENDING_TO**
   - Type: STRING
   - Default: Derived via scalar function (not provided)
   - Usage: Filters ZWEEK <= in COMP_FLAG_ACT01
   - Source: Derived from @IP_VERSION
   - Reason Unresolved: Scalar function logic not provided

5. **@IP_WEEK_LY**
   - Type: STRING
   - Default: Derived via scalar function (not provided)
   - Usage: Filters _BIC_ZIO_SWEEK in WEEKLY_SNAPSHOT_DS05
   - Source: Derived from @IP_VERSION
   - Reason Unresolved: Scalar function logic not provided

6. **@IP_WEEK_CY**
   - Type: STRING
   - Default: Derived via scalar function (not provided)
   - Usage: Assigned to CAL_WEEK in Projection_1
   - Source: Derived from @IP_VERSION
   - Reason Unresolved: Scalar function logic not provided

### Procedure Parameters (from STP_WSS_SRP_ATTRIBUTES)

1. **V_WEEK**
   - Type: STRING
   - Source: SFN_PRIOR_FISCAL_WEEK() function
   - Usage: Filters ZWEEK in INSERT to TBL_WSS_SRP_COMPFLAG
   - Reason Unresolved: Function not implemented in BigQuery

---

## Conflicts and Validation Findings

### 1. Procedural Semantics
**Status:** REQUIRES VALIDATION

**Issue:** STP_WSS_SRP_ATTRIBUTES cannot be represented as a single query

**Details:** See "Validation Issues" section above

### 2. Unresolved Function
**Status:** REQUIRES VALIDATION

**Function:** SFN_PRIOR_FISCAL_WEEK()

**Details:** See "Validation Issues" section above

### 3. Missing Column Mappings
**Status:** REQUIRES VALIDATION

**Details:** See "Validation Issues" section above

### 4. Parameter Derivation Logic
**Status:** REQUIRES VALIDATION

**Issue:** Multiple input parameters are derived via scalar functions whose logic is not provided

**Parameters Affected:**
- @IP_VERSION_COMP_FLAG
- @IP_WEEK_ENDING_FROM
- @IP_WEEK_ENDING_TO
- @IP_WEEK_LY
- @IP_WEEK_CY

**Required Action:** Provide scalar function definitions or parameter derivation logic

---

## Final Quality Gate Results

### Mandatory Checks

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 1 | Final consumer unambiguous | ✅ PASS | CV_COMP_SKF_ACTUAL_STATIC |
| 2 | Artifact dependencies match lineage | ✅ PASS | All dependencies mapped |
| 3 | Transformation order preserved | ✅ PASS | Join sequence preserved |
| 4 | Dependencies expanded at consumption | ❌ FAIL | Procedural logic prevents expansion |
| 5 | No generic ordering inferred | ✅ PASS | Actual flow followed |
| 6 | All files classified | ✅ PASS | 11 USED, 0 NOT USED |
| 7 | All USED files participate | ✅ PASS | All in dependency chain |
| 8 | All dependencies expanded | ❌ FAIL | Procedural logic prevents expansion |
| 9 | Only terminal sources remain | ❌ FAIL | Staging tables not terminal |
| 10 | All sources use BQ_FULL_TABLE | ❌ FAIL | Staging tables not mapped |
| 11 | All columns mapped 1:1 | ❌ FAIL | Missing mappings |
| 12 | Filter literals match types | ⚠️ PARTIAL | Assumed numeric for MANDT |
| 13 | Final-consumer CTE names preserved | ✅ PASS | All preserved |
| 14 | Compatible operations combined | ✅ PASS | Where logically safe |
| 15 | No unnecessary CTEs | ✅ PASS | All justified |
| 16 | Every CTE matches output contract | ✅ PASS | Validated |
| 17 | All columns exist in parent | ✅ PASS | Validated |
| 18 | No duplicate aliases | ✅ PASS | Validated |
| 19 | Star projections valid | ✅ PASS | None used |
| 20 | Logic preserved | ✅ PASS | All preserved |
| 21 | Aggregation grain preserved | ✅ PASS | All preserved |
| 22 | DISTINCT/UNION preserved | ✅ PASS | None present |
| 23 | No silent conflicts | ✅ PASS | All documented |
| 24 | Procedural behavior preserved | ❌ FAIL | Cannot represent in single query |
| 25 | Parameters documented | ✅ PASS | All documented |
| 26 | CTE headers present | N/A | Not generated due to validation failures |
| 27 | Headers accurate | N/A | Not generated due to validation failures |
| 28 | Complete query | ❌ FAIL | Cannot generate due to validation issues |
| 29 | 100% logic match | ❌ FAIL | Procedural logic cannot be matched |

### Overall Status: REQUIRES VALIDATION

**Critical Failures:**
- Procedural semantics cannot be represented as a single query
- Unresolved function (SFN_PRIOR_FISCAL_WEEK)
- Missing column mappings
- Staging tables not mapped to terminal sources

---

## Recommended Next Steps

1. **Implement STP_WSS_SRP_ATTRIBUTES as BigQuery Stored Procedure**
   - Convert DELETE/INSERT logic to BigQuery scripting
   - Implement SFN_PRIOR_FISCAL_WEEK as UDF or parameter
   - Schedule to run before CV_COMP_SKF_ACTUAL_STATIC

2. **Provide Complete Column Mappings**
   - Add mappings for TBL_WSS_SRP_ATTR_ACT
   - Add mappings for TBL_WSS_SRP_COMPFLAG
   - Confirm calculated columns do not require mapping

3. **Implement Parameter Derivation Logic**
   - Provide scalar function definitions for all derived parameters
   - OR provide parameters as runtime inputs

4. **Re-run Consolidation**
   - After resolving validation issues
   - Generate complete consolidated SQL

---

## Confidence: Medium

**Rationale:**
- All artifact relationships are clearly identified and validated
- All file classifications are correct
- All logic preservation rules are followed
- Cannot generate complete consolidated SQL due to procedural semantics
- Missing information prevents full consolidation
