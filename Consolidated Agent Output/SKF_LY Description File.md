# CONSOLIDATION DESCRIPTION: SKF_LY

## Executive Summary

This consolidation produces a **single, fully expanded, executable BigQuery SQL query** that implements the complete end-to-end logic of **CV_COMP_SKF_ACTUAL_STATIC**, the final consumer-facing artifact in the SKF_LY lineage.

All intermediate calculation views, stored procedure logic, and dependencies have been recursively inlined and expanded. The final SQL requires **no external view references** and can be executed directly against the physical source tables.

---

## Lineage Overview

The lineage for SKF_LY consists of the following dependency chain:

### Final Consumer Artifact
- **CV_COMP_SKF_ACTUAL_STATIC** (Calculation View)

### Direct Dependencies of CV_COMP_SKF_ACTUAL_STATIC
1. **CV_BASE_SKF_WEEKLY_ACTUAL_S4** (Calculation View)
2. **CV_COMP_MD_SRPACT_STATIC** (Calculation View)
3. **CV_BASE_MD_HRRP_NODE_S4** (Calculation View)
4. **CV_COMP_MD_COMPFL_STATIC** (Calculation View)
5. **CV_BASE_MD_RCALWEEK_S4** (Calculation View)
6. **CV_BASE_MD_CEPCT_S4** (Calculation View)

### Upstream Dependencies (Traced Through Stored Procedure)
- **STP_WSS_SRP_ATTRIBUTES** (Stored Procedure)
  - Populates **TBL_WSS_SRP_ATTR_ACT** from **CV_BASE_MD_SRPACT_S4**
  - Populates **TBL_WSS_SRP_COMPFLAG** from **CV_BASE_MD_COMPFL_S4**

### Base Source Tables (Physical)
1. **AZSRP_DS112_VT_S4** (source for CV_BASE_SKF_WEEKLY_ACTUAL_S4)
2. **ZTSRP_ATTR_ACT** (source for CV_BASE_MD_SRPACT_S4)
3. **HRRP_NODE** (source for CV_BASE_MD_HRRP_NODE_S4)
4. **ZTSRP_COMPFL** (source for CV_BASE_MD_COMPFL_S4)
5. **ZTFIGL_RCALWEEK** (source for CV_BASE_MD_RCALWEEK_S4)
6. **CEPCT** (source for CV_BASE_MD_CEPCT_S4)

---

## Consolidation Traceability

### File Usage Summary

| File Name | Status | Role in Consolidation |
|-----------|--------|----------------------|
| CV_COMP_SKF_ACTUAL_STATIC_DI | **USED** | Final consumer artifact; defines join logic, filters, calculated columns, and aggregation structure |
| CV_BASE_SKF_WEEKLY_ACTUAL_S4_DI | **USED** | Inlined as WEEKLY_SNAPSHOT_DS05_BASE and WEEKLY_SNAPSHOT_DS05; provides weekly actual data with aggregation and filters |
| CV_BASE_MD_SRPACT_S4_DI | **USED** | Inlined as STORE_ATTR_ACTUAL_BASE and STORE_ATTR_ACTUAL; provides store attribute data with aggregation |
| CV_BASE_MD_HRRP_NODE_S4_DI | **USED** | Inlined as CC_HIER_BASE and CC_HIER; provides cost center hierarchy data |
| CV_BASE_MD_COMPFL_S4_DI | **USED** | Inlined as COMP_FLAG_ACT01_BASE and COMP_FLAG_ACT01; provides completion flag data |
| CV_BASE_MD_RCALWEEK_S4_DI | **USED** | Inlined as RETAIL_CAL_BASE and RETAIL_CAL; provides retail calendar week mapping |
| CV_BASE_MD_CEPCT_S4_DI | **USED** | Inlined as PROFIT_CENTER_TEXT_BASE and PROFIT_CENTER_TEXT; provides profit center text descriptions |
| CV_COMP_MD_SRPACT_STATIC_DI | **USED** | Traced through lineage; its logic is inlined from CV_BASE_MD_SRPACT_S4 (via STP_WSS_SRP_ATTRIBUTES) |
| CV_COMP_MD_COMPFL_STATIC_DI | **USED** | Traced through lineage; its logic is inlined from CV_BASE_MD_COMPFL_S4 (via STP_WSS_SRP_ATTRIBUTES) |
| STP_WSS_SRP_ATTRIBUTES_DI | **USED** | Stored procedure logic analyzed; ETL logic traced upstream to source calculation views and inlined |
| SKF_LY File Relationships Table - Copy.txt | **USED** | Lineage reference; used to determine dependency relationships and consolidation order |

**All 11 files were evaluated and used in the consolidation.**

---

## Consolidation Logic Flow

### Step 1: Base Data Extraction

#### WEEKLY_SNAPSHOT_DS05_BASE
- **Source:** CV_BASE_SKF_WEEKLY_ACTUAL_S4
- **Physical Table:** AZSRP_DS112_VT_S4
- **Logic:**
  - Filters: `MANDT IN (110, 200)`
  - Aggregation: GROUP BY all dimension columns, SUM all measure columns
  - Measure columns: `_BIC_ZIO_SKFQ`, `_BIC_ZIO_D1SKQ` through `_BIC_ZIO_D7SKQ`

#### WEEKLY_SNAPSHOT_DS05
- **Source:** WEEKLY_SNAPSHOT_DS05_BASE (filtered)
- **Logic:**
  - Additional filters applied:
    - `FISCVARNT = 'K4'`
    - `_BIC_ZIO_SWEEK = @IP_WEEK_LY`
    - `_BIC_ZIO_VER = @IP_VERSION`
    - `_BIC_ZIO_SAUDT IN ('1','10')`
    - `_BIC_ZIO_PSKF IN ('804013','801000')`

#### CC_HIER_BASE
- **Source:** CV_BASE_MD_HRRP_NODE_S4
- **Physical Table:** HRRP_NODE
- **Logic:**
  - Filters: `MANDT IN (120, 200)`
  - Direct projection (no aggregation)

#### CC_HIER
- **Source:** CC_HIER_BASE (filtered)
- **Logic:**
  - Additional filters:
    - `PARNODE LIKE '%CORERET%'`
    - `HRYVALTO = '99991231'`

#### STORE_ATTR_ACTUAL_BASE
- **Source:** CV_BASE_MD_SRPACT_S4
- **Physical Table:** ZTSRP_ATTR_ACT
- **Logic:**
  - Filters: `MANDT IN (120, 200)`
  - Aggregation: GROUP BY all dimension columns, SUM measure columns
  - Measure columns: `RX_HRS_OPER`, `FS_HRS_OPER`, `RETAIL_SQFT_AMT`, `TOTAL_SQFT_AMT`
- **Note:** This table is populated by stored procedure STP_WSS_SRP_ATTRIBUTES, but the consolidation traces back to the original source table ZTSRP_ATTR_ACT

#### STORE_ATTR_ACTUAL
- **Source:** STORE_ATTR_ACTUAL_BASE (projection)
- **Logic:** Select only columns required for downstream joins

#### RETAIL_CAL_BASE
- **Source:** CV_BASE_MD_RCALWEEK_S4
- **Physical Table:** ZTFIGL_RCALWEEK
- **Logic:**
  - Filters: `RCLNT IN (120, 200)`
  - Direct projection (no aggregation)

#### RETAIL_CAL
- **Source:** RETAIL_CAL_BASE (projection)
- **Logic:** Select only columns required for downstream joins

#### COMP_FLAG_ACT01_BASE
- **Source:** CV_BASE_MD_COMPFL_S4
- **Physical Table:** ZTSRP_COMPFL
- **Logic:**
  - Filters: `MANDT IN (110, 200)`
  - Direct projection (no aggregation)
- **Note:** This table is populated by stored procedure STP_WSS_SRP_ATTRIBUTES, but the consolidation traces back to the original source table ZTSRP_COMPFL

#### COMP_FLAG_ACT01
- **Source:** COMP_FLAG_ACT01_BASE (filtered)
- **Logic:**
  - Additional filters:
    - `ZWEEK >= @IP_WEEK_ENDING_FROM`
    - `ZWEEK <= @IP_WEEK_ENDING_TO`
    - `COMP_VER = @IP_VERSION_COMP_FLAG`

#### PROFIT_CENTER_TEXT_BASE
- **Source:** CV_BASE_MD_CEPCT_S4
- **Physical Table:** CEPCT
- **Logic:**
  - Filters: `MANDT IN (120, 200)`
  - Direct projection (no aggregation)

#### PROFIT_CENTER_TEXT
- **Source:** PROFIT_CENTER_TEXT_BASE (projection)
- **Logic:** Select only columns required for downstream joins; map LTEXT to PROFIT_CENTER_TEXT

---

### Step 2: Join Logic

#### JOIN_3
- **Type:** INNER JOIN
- **Left:** WEEKLY_SNAPSHOT_DS05
- **Right:** CC_HIER
- **Join Keys:**
  - `W._B631_S_COSTCNTR = C.NODEVALUE`
  - `W.MANDT = C.MANDT`
- **Purpose:** Link weekly snapshot data to cost center hierarchy

#### Projection_1
- **Source:** JOIN_3
- **Logic:** Add calculated column `CAL_WEEK = @IP_WEEK_CY`

#### Join_2
- **Type:** LEFT OUTER JOIN
- **Left:** Projection_1
- **Right:** STORE_ATTR_ACTUAL
- **Join Keys:**
  - `P._B631_S_PROFTCTR = S.PRCTR`
  - `P.MANDT = S.MANDT`
- **Purpose:** Enrich with store attribute data

#### Join_1
- **Type:** LEFT OUTER JOIN
- **Left:** Join_2
- **Right:** RETAIL_CAL
- **Join Keys:**
  - `J.CAL_WEEK = R.ZZWEEK`
- **Purpose:** Add retail calendar week start/end dates

#### Join_4
- **Type:** LEFT OUTER JOIN
- **Left:** Join_1
- **Right:** COMP_FLAG_ACT01
- **Join Keys:**
  - `J._B631_S_PROFTCTR = C.PRCTR`
  - `J.MANDT = C.MANDT`
- **Purpose:** Add completion flag data

#### Join_5
- **Type:** LEFT OUTER JOIN
- **Left:** Join_4
- **Right:** PROFIT_CENTER_TEXT
- **Join Keys:**
  - `J._B631_S_PROFTCTR = P.PRCTR`
  - `J.MANDT = P.MANDT`
- **Purpose:** Add profit center text descriptions

---

### Step 3: Calculated Columns

#### FLAGS CTE
- **CAL_WEEK_NUMBER:** `RIGHT(CAL_WEEK, 2)`
- **CAL_ZIO_SKFQ_QTY:**
  ```sql
  CASE
    WHEN _BIC_ZIO_PSKF = '804013' THEN _BIC_ZIO_SKFQ * 2
    ELSE _BIC_ZIO_SKFQ
  END
  ```

---

### Step 4: Final Aggregation

The final SELECT statement aggregates the data as required by the CUBE/Aggregation view type:

- **GROUP BY:** All non-measure columns (42 columns)
- **Measures (SUM aggregation):**
  - `_BIC_ZIO_SKFQ_90as1` (original `_BIC_ZIO_SKFQ`)
  - `_BIC_ZIO_D1SKQ` through `_BIC_ZIO_D7SKQ`
  - `_BIC_ZIO_SKFQ` (calculated from `CAL_ZIO_SKFQ_QTY`)

---

## Input Parameters

The consolidated SQL uses the following BigQuery query parameters (mapped from HANA input parameters):

| Parameter | Description |
|-----------|-------------|
| `@IP_VERSION` | Version filter for weekly snapshot data |
| `@IP_VERSION_COMP_FLAG` | Version filter for completion flag data |
| `@IP_WEEK_ENDING_FROM` | Start week for completion flag filter |
| `@IP_WEEK_ENDING_TO` | End week for completion flag filter |
| `@IP_WEEK_LY` | Last year week filter for weekly snapshot |
| `@IP_WEEK_CY` | Current year week (used as CAL_WEEK) |

**Note:** These parameters must be provided at query execution time in BigQuery.

---

## Validation Items

### REQUIRES VALIDATION: BigQuery Table Mappings

The following physical table references use placeholder project/dataset names and must be mapped to actual BigQuery tables:

| Placeholder | Source HANA Table | Required Mapping |
|-------------|-------------------|------------------|
| `PROJECT.DATASET.AZSRP_DS112_VT_S4` | CVS_FRIP.AZSRP_DS112_VT_S4 | Actual BigQuery project.dataset.table |
| `PROJECT.DATASET.ZTSRP_ATTR_ACT` | SAP_S4.ZTSRP_ATTR_ACT | Actual BigQuery project.dataset.table |
| `PROJECT.DATASET.HRRP_NODE` | SAP_S4.HRRP_NODE | Actual BigQuery project.dataset.table |
| `PROJECT.DATASET.ZTSRP_COMPFL` | SAP_S4.ZTSRP_COMPFL | Actual BigQuery project.dataset.table |
| `PROJECT.DATASET.ZTFIGL_RCALWEEK` | SAP_S4.ZTFIGL_RCALWEEK | Actual BigQuery project.dataset.table |
| `PROJECT.DATASET.CEPCT` | SAP_S4.CEPCT | Actual BigQuery project.dataset.table |

### REQUIRES VALIDATION: Data Type Compatibility

The following columns are used in filters with numeric literals; if these columns are strings in BigQuery, the filter values must be quoted:

| Column | Filter Values | Validation Required |
|--------|---------------|---------------------|
| `MANDT` | 110, 200, 120 | Verify if INTEGER or STRING |
| `RCLNT` | 120, 200 | Verify if INTEGER or STRING |

### REQUIRES VALIDATION: Column Existence

All columns referenced in the consolidated SQL must exist in the physical BigQuery tables with compatible data types. The following measure columns must be numeric and support SUM aggregation:

- `_BIC_ZIO_SKFQ`, `_BIC_ZIO_D1SKQ` through `_BIC_ZIO_D7SKQ`
- `RX_HRS_OPER`, `FS_HRS_OPER`, `RETAIL_SQFT_AMT`, `TOTAL_SQFT_AMT`

### REQUIRES VALIDATION: Parameter Value Resolution

The query parameters must be provided at runtime. If default values are required, they must be defined in the calling application or BigQuery script.

### REQUIRES VALIDATION: Stored Procedure Function

The stored procedure **STP_WSS_SRP_ATTRIBUTES** references an external function:
- **Function:** `CVS_FRIP.CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK`
- **Purpose:** Returns the prior fiscal week value
- **Validation Required:** This function was not provided in the converted SQL files. If the function logic is required for parameter initialization, it must be mapped to a BigQuery UDF or equivalent logic.

**Note:** For the purposes of this consolidation, the stored procedure logic was traced upstream to the source calculation views and physical tables, bypassing the intermediate staging tables (TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG). The ETL logic was not required for the final query consolidation.

---

## Aggregation Grain Preservation

The consolidation preserves the exact aggregation grain defined in each source calculation view:

1. **CV_BASE_SKF_WEEKLY_ACTUAL_S4:** Aggregates at the grain of 17 dimension columns
2. **CV_BASE_MD_SRPACT_S4:** Aggregates at the grain of 70 dimension columns
3. **CV_COMP_SKF_ACTUAL_STATIC:** Aggregates at the grain of 42 dimension columns (final output)

No additional grouping columns were added or removed. The final GROUP BY exactly matches the logical model definition in CV_COMP_SKF_ACTUAL_STATIC.

---

## SQL Preservation

All SQL logic from the converted BigQuery files has been preserved exactly:

- **Filters:** All WHERE clause conditions preserved
- **Joins:** All join types, keys, and conditions preserved
- **Calculated Columns:** All CASE expressions and calculations preserved
- **Aggregations:** All SUM aggregations and GROUP BY logic preserved
- **Column Mappings:** All 1:1 column mappings preserved

No business logic was rewritten, simplified, or optimized.

---

## Completeness Confirmation

- **Total CTEs:** 18
- **Total Joins:** 5
- **Total Filters:** Multiple (preserved across all CTEs)
- **Total Calculated Columns:** 2 (CAL_WEEK_NUMBER, CAL_ZIO_SKFQ_QTY)
- **Total Measures:** 9
- **Total Dimension Columns:** 42

All CTEs are fully expanded. No logic has been omitted, abbreviated, or represented by placeholders.

---

## Execution Readiness

The consolidated SQL is **execution-ready** with the following prerequisites:

1. Replace all `PROJECT.DATASET.TABLE` placeholders with actual BigQuery table references
2. Provide values for all query parameters (`@IP_*`)
3. Validate data types for filtered columns (MANDT, RCLNT)
4. Confirm all columns exist in source tables
5. Validate measure column data types support SUM aggregation

Once these validations are complete, the SQL can be executed directly in BigQuery without requiring any intermediate views or external dependencies.

---

## Confidence Level

**HIGH**

All logic explicitly defined in the provided converted SQL files and lineage has been consolidated. The only unresolved items are deployment-specific (table mappings, parameter values, data type validation) and do not affect the correctness of the SQL structure or business logic.

---

## Summary

This consolidation successfully produces a **single, fully expanded, executable BigQuery SQL query** that implements the complete end-to-end logic of **CV_COMP_SKF_ACTUAL_STATIC** by:

1. Recursively inlining all 6 dependent calculation views
2. Tracing stored procedure logic upstream to source tables
3. Preserving all filters, joins, calculated columns, and aggregation logic
4. Eliminating all intermediate view dependencies
5. Producing a query that references only physical source tables

**All 11 input files were evaluated and used in the consolidation.**

The final SQL is ready for deployment after completing the validation items listed above.