# CONSOLIDATION DESCRIPTION AND ANALYSIS

## Executive Summary

This consolidation produces a **fully expanded, execution-ready BigQuery SQL** for the final consumer-facing artifact **CV_COMP_FIN_BUDGET_STATIC**. All upstream dependencies have been recursively inlined, eliminating the need for intermediate views to exist in the target environment.

---

## Lineage Analysis

### Lineage Relationships (from FS_Budget_Lineage_file.csv)

The lineage file defines the following key relationships:

1. **CV_BASE_FIN_WEEKLY_BUDGET_S4** → **CV_BASE_MD_RCAIWEEK_S4** (Direct Dependency - Calculation View Reference)
2. **CV_BASE_MD_HRRP_NODE_S4** → **CV_BASE_MD_RCAIWEEK_S4** (Direct Dependency - Calculation View Reference)
3. **CV_COMP_MD_SRPACT_STATIC** → **CV_BASE_MD_RCAIWEEK_S4** (Direct Dependency - Calculation View Reference)
4. **CV_COMP_MD_COMPFL_STATIC** → **CV_BASE_MD_RCAIWEEK_S4** (Direct Dependency - Calculation View Reference)
5. **CV_BASE_MD_CEPCT_S4** → **CV_BASE_MD_RCAIWEEK_S4** (Direct Dependency - Calculation View Reference)
6. **STP_WSS_SRP_ATTRIBUTES** → **CV_COMP_MD_SRPACT_STATIC** (Direct Dependency - Table Population)
7. **STP_WSS_SRP_ATTRIBUTES** → **CV_COMP_MD_COMPFL_STATIC** (Direct Dependency - Table Population)

### Relationship Priority Applied

Following the **RELATIONSHIP PRIORITY RULE**, the consolidation prioritized:

1. **Data Population via INSERT** (highest priority)
2. **Source View for Procedure**
3. **Calculation View Dependency**
4. **Data Source** (lowest priority)

**Key Decision:**
- **CV_COMP_MD_SRPACT_STATIC** and **CV_COMP_MD_COMPFL_STATIC** both read from tables populated by **STP_WSS_SRP_ATTRIBUTES**.
- However, the stored procedure **STP_WSS_SRP_ATTRIBUTES** references calculation views **CV_BASE_MD_SRPACT_S4** and **CV_BASE_MD_COMPFL_S4** which are **NOT provided** in the supplied SQL files.
- Per the lineage, these views are **NOT** in the file list, creating a circular/indirect dependency pattern.
- The consolidation therefore uses the **table-based static views** as terminal sources, since the upstream calculation views referenced by the procedure are unavailable.

---

## Consolidation Traceability

### Final Target: CV_COMP_FIN_BUDGET_STATIC

**File:** CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt

**Purpose:** Final consumer-facing calculation view providing budget data with store attributes, comparison flags, hierarchy filters, and profit center text.

**Dependencies Resolved:**

1. **CV_BASE_FIN_WEEKLY_BUDGET_S4** (USED)
   - **File:** CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt
   - **Expanded:** Yes - Fully inlined with all CTEs (Frozen_Cube, Live_Cube, Union_1, Aggregated, Final)
   - **Logic Preserved:** 
     - Union of Frozen Cube (AZSRP_DS052_VT_S4) and Live Cube (AZSRP_DS041_VT_S4)
     - Parameter-driven filtering (@IP_FC_COUNT)
     - Aggregation with FLAG-based restricted measures
     - Calculated measure logic (FC takes precedence over LC)
   - **Contribution:** Provides weekly budget financial data filtered by fiscal variant, week range, version, and audit type

2. **CV_BASE_MD_HRRP_NODE_S4** (USED)
   - **File:** CV_BASE_MD_HRRP_NODE_S4_Output.txt
   - **Expanded:** Yes - Inlined as HIER_NODE CTE
   - **Logic Preserved:**
     - Reads from HRRP_NODE table
     - Filters MANDT IN (120, 200)
     - Further filtered by PARNODE matching 'CORE_RET$' pattern and HRYVALTO = '99991231'
   - **Contribution:** Provides HR hierarchy nodes to filter only CORE_RET profit centers via INNER JOIN

3. **CV_COMP_MD_SRPACT_STATIC** (USED)
   - **File:** CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt
   - **Expanded:** Yes - Inlined as STORE_ATTR_ACTUAL CTE
   - **Logic Preserved:**
     - Reads from TBL_WSS_SRP_ATTR_ACT table (populated by STP_WSS_SRP_ATTRIBUTES procedure)
     - Aggregates store attributes (RX_HRS_OPER, FS_HRS_OPER, RX_STORE, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT)
     - Groups by all non-aggregated columns
   - **Contribution:** Provides store reporting attributes (market codes, divisions, areas, districts, regions, store metadata) via LEFT JOIN on PRCTR

4. **CV_COMP_MD_COMPFL_STATIC** (USED)
   - **File:** CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt
   - **Expanded:** Yes - Inlined as COMP_FLAG_BUDGET CTE
   - **Logic Preserved:**
     - Reads from TBL_WSS_SRP_COMPFLAG table (populated by STP_WSS_SRP_ATTRIBUTES procedure)
     - Filters by COMP_VER = @IP_VERSION
   - **Contribution:** Provides comparison flags (FS_COMP_WK, RX_COMP_WK) for Front Store and Pharmacy via LEFT JOIN on PRCTR and ZWEEK

5. **CV_BASE_MD_RCALWEEK_S4** (USED)
   - **File:** CV_BASE_MD_RCALWEEK_S4_Output.txt
   - **Expanded:** Yes - Inlined as CAL_WEEK CTE
   - **Logic Preserved:**
     - Reads from ZTFIGL_RCALWEEK table
     - Filters RCLNT IN (120, 200)
   - **Contribution:** Provides calendar week start/end dates (ZRWSTRTDATE, ZRWENDDATE) via LEFT JOIN on ZZWEEK

6. **CV_BASE_MD_CEPCT_S4** (USED)
   - **File:** CV_BASE_MD_CEPCT_S4_OUTPUT.txt
   - **Expanded:** Yes - Inlined as PROFIT_CENTER_TEXT CTE
   - **Logic Preserved:**
     - Reads from CEPCT table
     - Filters MANDT IN (120, 200)
     - Selects LTEXT as PROFIT_CENTER_TEXT
   - **Contribution:** Provides profit center long text descriptions via LEFT JOIN on PRCTR

7. **STP_WSS_SRP_ATTRIBUTES** (NOT USED - Indirect)
   - **File:** STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt
   - **Reason NOT USED:** This stored procedure populates tables TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG. The consolidation reads directly from these tables via CV_COMP_MD_SRPACT_STATIC and CV_COMP_MD_COMPFL_STATIC. The procedure itself is an ETL/data loading process and is not part of the query execution path. The procedure's INSERT logic is not expanded because:
     - The procedure references **CV_BASE_MD_SRPACT_S4** and **CV_BASE_MD_COMPFL_S4** which are **NOT provided** in the supplied SQL files
     - The tables it populates (TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG) are used as terminal sources
     - The procedure contains an unresolved function: **CVS_FRIP_CVS_FRIP_Composite_Master_SFN_PRIOR_FISCAL_WEEK()**
   - **Classification:** ETL process, not query logic

---

## SQL File Usage Summary

| SQL File | Status | Reason |
|----------|--------|--------|
| CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt | **USED** | Expanded as source for WEEKLY_SNAPSHOT_DS05 CTE with all upstream logic (Frozen_Cube, Live_Cube, Union_1, Aggregated, Final) |
| CV_BASE_MD_HRRP_NODE_S4_Output.txt | **USED** | Expanded as HIER_NODE CTE for CORE_RET hierarchy filtering |
| CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt | **USED** | Expanded as STORE_ATTR_ACTUAL CTE for store attributes |
| CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt | **USED** | Expanded as COMP_FLAG_BUDGET CTE for comparison flags |
| CV_BASE_MD_RCALWEEK_S4_Output.txt | **USED** | Expanded as CAL_WEEK CTE for calendar week dates |
| CV_BASE_MD_CEPCT_S4_OUTPUT.txt | **USED** | Expanded as PROFIT_CENTER_TEXT CTE for profit center descriptions |
| STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt | **NOT USED** | Stored procedure for ETL table population; tables it populates are used as terminal sources; upstream views CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_COMPFL_S4 not provided; contains unresolved function |
| FS_Budget_Lineage_file.csv | **USED** | Lineage metadata used to determine dependency relationships and consolidation order |

---

## Consolidation Logic Flow

### CTE Structure (in execution order):

1. **Frozen_Cube** - Extracts budget data from frozen cube (AZSRP_DS052_VT_S4) when @IP_FC_COUNT != '0'
2. **Live_Cube** - Extracts budget data from live cube (AZSRP_DS041_VT_S4) when @IP_FC_COUNT = '0'
3. **Union_1** - Unions Frozen and Live cube data with FLAG differentiation
4. **Aggregated** - First aggregation level: groups by all dimensions including FLAG
5. **CV_BASE_FIN_WEEKLY_BUDGET_S4_Final** - Second aggregation level: removes FLAG from GROUP BY, applies restricted measures and calculated measure logic
6. **WEEKLY_SNAPSHOT_DS05** - Filters weekly budget data by fiscal variant, week range, version, and audit type
7. **HIER_NODE** - Filters HR hierarchy to CORE_RET nodes with valid-to date 99991231
8. **Join_1** - INNER JOIN to filter only CORE_RET profit centers
9. **ONLY_CORE_RET_DATA** - Pass-through CTE for filtered data
10. **STORE_ATTR_ACTUAL** - Aggregated store attributes from TBL_WSS_SRP_ATTR_ACT
11. **Join_2** - LEFT JOIN to add store attributes by PRCTR
12. **WEEK_NUMBER** - Calculates CAL_STORE_WEEK_NUMBER (last 2 digits of week)
13. **COMP_FLAG_BUDGET** - Filters comparison flags by version
14. **Join_3** - LEFT JOIN to add comparison flags by PRCTR and ZWEEK
15. **CAL_WEEK** - Calendar week dimension from ZTFIGL_RCALWEEK
16. **Join_4** - LEFT JOIN to add week start/end dates by ZZWEEK
17. **PROFIT_CENTER_TEXT** - Profit center text from CEPCT
18. **Join_5** - LEFT JOIN to add profit center text by PRCTR
19. **FLAGS** - Final projection with calculated columns:
    - **CAL_FS_RX_FLAG**: Derives 'FS' or 'RX' from _BIC_ZWWPC_PA1
    - **CAL_COMP_FLAG**: Selects appropriate comparison flag based on FS/RX
    - **CAL_WEEK_NUMBER**: Last 2 digits of week
    - **_B631_S_AMOUNT**: Negates _B631_S_AMOUNT_NEGATIVE (multiplies by -1)

### Join Strategy:

- **INNER JOIN** on HIER_NODE: Ensures only CORE_RET hierarchy nodes are included
- **LEFT JOIN** on STORE_ATTR_ACTUAL: Preserves all budget records even without store attributes
- **LEFT JOIN** on COMP_FLAG_BUDGET: Preserves all budget records even without comparison flags
- **LEFT JOIN** on CAL_WEEK: Preserves all budget records even without calendar week details
- **LEFT JOIN** on PROFIT_CENTER_TEXT: Preserves all budget records even without profit center text

---

## Validation Items

### REQUIRES VALIDATION: SOURCE SQL CONFLICT

**Issue:** Column name mismatch between upstream and downstream SQL

**Details:**
- **Downstream SQL:** CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt references column **_B631_S_AMOUNT_NEGATIVE**
- **Upstream SQL:** CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt produces column **_B631_S_AMOUNT**
- **Supplied SQL:** The upstream CV_BASE_FIN_WEEKLY_BUDGET_S4 does NOT contain any logic that creates **_B631_S_AMOUNT_NEGATIVE**

**Resolution Applied:**
- The consolidation preserves the upstream column name **_B631_S_AMOUNT** throughout the expansion
- In the final FLAGS CTE, the column is aliased as **_B631_S_AMOUNT_NEGATIVE** to match the downstream reference
- The final calculated column **_B631_S_AMOUNT** is then derived by multiplying **_B631_S_AMOUNT_NEGATIVE** by -1

**Assumption:**
- The naming convention suggests that the amount should be negated in the final output
- The supplied SQL from CV_COMP_FIN_BUDGET_STATIC confirms this with the calculation: `(_B631_S_AMOUNT_NEGATIVE * -1) AS _B631_S_AMOUNT`

**Validation Required:**
- Confirm that **_B631_S_AMOUNT** from CV_BASE_FIN_WEEKLY_BUDGET_S4 should be treated as a negative value and negated in the final output
- Verify the business logic for amount sign conventions

---

### REQUIRES VALIDATION: MISSING UPSTREAM CALCULATION VIEWS

**Issue:** Stored procedure references calculation views not provided in supplied SQL files

**Details:**
- **Stored Procedure:** STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt
- **References:** 
  - `_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4`
  - `_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4`
- **Supplied Files:** These calculation views are NOT included in the provided SQL files
- **Impact:** Cannot expand the stored procedure's INSERT SELECT logic because source views are unavailable

**Resolution Applied:**
- The consolidation uses the tables populated by the procedure (TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG) as terminal sources
- The static views CV_COMP_MD_SRPACT_STATIC and CV_COMP_MD_COMPFL_STATIC read from these tables and are inlined

**Validation Required:**
- Provide the SQL definitions for CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_COMPFL_S4 if full ETL logic expansion is required
- Confirm that using the populated tables as terminal sources is acceptable for the consolidation objective

---

### REQUIRES VALIDATION: UNRESOLVED FUNCTION

**Issue:** Stored procedure calls an external scalar function not available in BigQuery

**Details:**
- **Function:** `CVS_FRIP.CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK()`
- **Referenced In:** STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt
- **Purpose:** Returns the prior fiscal week value for filtering comparison flag data
- **BigQuery Equivalent:** Not provided

**Resolution Applied:**
- The stored procedure is not expanded in the final consolidated SQL
- The tables it populates are used as terminal sources

**Validation Required:**
- Provide the BigQuery UDF implementation for SFN_PRIOR_FISCAL_WEEK()
- Or provide the prior fiscal week value as a parameter if the procedure logic needs to be expanded

---

### REQUIRES VALIDATION: PLACEHOLDER TABLE REFERENCE

**Issue:** CV_COMP_MD_COMPFL_STATIC references a placeholder table name

**Details:**
- **File:** CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt
- **Reference:** `FROM PROJECT.DATASET.TABLE`
- **Expected:** `FROM PROJECT.DATASET.TBL_WSS_SRP_COMPFLAG`

**Resolution Applied:**
- The consolidation preserves the placeholder reference as provided in the supplied SQL
- Based on lineage analysis and the stored procedure logic, the actual table should be TBL_WSS_SRP_COMPFLAG

**Validation Required:**
- Replace `PROJECT.DATASET.TABLE` with the actual BigQuery table reference `PROJECT.DATASET.TBL_WSS_SRP_COMPFLAG`
- Confirm the correct project and dataset names

---

### REQUIRES VALIDATION: PARAMETER DEFINITIONS

**Issue:** The consolidated SQL references multiple parameters that must be supplied at execution time

**Parameters Required:**
1. **@IP_FC_COUNT** - Controls whether to use Frozen Cube or Live Cube data
   - Type: STRING
   - Values: '0' (Live Cube) or any other value (Frozen Cube)
   
2. **@IP_WEEK_ENDING_FROM** - Start of week range filter
   - Type: Matches _BIC_ZIO_SWEEK data type
   - Format: Likely YYYYWW (e.g., 202401)
   
3. **@IP_WEEK_ENDING_TO** - End of week range filter
   - Type: Matches _BIC_ZIO_SWEEK data type
   - Format: Likely YYYYWW (e.g., 202452)
   
4. **@IP_VERSION** - Budget version filter
   - Type: Matches _BIC_ZIO_VER data type
   - Example values: Version codes like 'V1', 'V2', etc.

**Resolution Applied:**
- Parameters are preserved in the consolidated SQL as declared in the original converted SQL files
- BigQuery scripting syntax using DECLARE statements may be required

**Validation Required:**
- Confirm parameter data types and valid value ranges
- Provide sample parameter values for testing
- Determine if parameters should be converted to BigQuery scripting variables or passed as query parameters

---

### REQUIRES VALIDATION: MANDT VALUE INCONSISTENCY

**Issue:** Different MANDT filter values across source tables

**Details:**
- **CV_BASE_FIN_WEEKLY_BUDGET_S4:** Filters MANDT IN ('110', '200') - STRING values
- **CV_BASE_MD_HRRP_NODE_S4:** Filters MANDT IN (120, 200) - INTEGER values
- **CV_BASE_MD_RCALWEEK_S4:** Filters MANDT IN (120, 200) - INTEGER values
- **CV_BASE_MD_CEPCT_S4:** Filters MANDT IN (120, 200) - INTEGER values

**Resolution Applied:**
- The consolidation preserves the exact filter values as provided in each supplied SQL file
- This creates a potential data type inconsistency if MANDT is defined differently across tables

**Validation Required:**
- Confirm the correct MANDT values and data types for each source table
- Standardize MANDT filtering if necessary (e.g., all STRING or all INTEGER)
- Verify if MANDT '110' vs 120 is intentional or a data type conversion issue

---

## Physical Source Tables (Terminal Dependencies)

The following physical tables are referenced in the final consolidated SQL and must exist in the target BigQuery environment:

1. **PROJECT.DATASET.AZSRP_DS052_VT_S4** - Frozen Cube budget data
2. **PROJECT.DATASET.AZSRP_DS041_VT_S4** - Live Cube budget data
3. **PROJECT.DATASET.HRRP_NODE** - HR hierarchy nodes
4. **PROJECT.DATASET.TBL_WSS_SRP_ATTR_ACT** - Store attributes (populated by STP_WSS_SRP_ATTRIBUTES)
5. **PROJECT.DATASET.TABLE** - Comparison flags (should be TBL_WSS_SRP_COMPFLAG, populated by STP_WSS_SRP_ATTRIBUTES)
6. **PROJECT.DATASET.ZTFIGL_RCALWEEK** - Calendar week dimension
7. **PROJECT.DATASET.CEPCT** - Profit center text

**Action Required:**
- Replace all `PROJECT.DATASET` placeholders with actual BigQuery project and dataset names
- Ensure all tables exist and are accessible
- Verify table schemas match the column references in the consolidated SQL

---

## Aggregation Grain Preservation

The consolidation preserves the exact aggregation grain from the supplied SQL files:

### CV_BASE_FIN_WEEKLY_BUDGET_S4 Aggregation:

**First Aggregation (Aggregated CTE):**
- Groups by all dimensions INCLUDING FLAG
- Aggregates: SUM(_B631_S_AMOUNT) AS _B631_S_AMOUNT_DUMMY, SUM(_BIC_ZIO_AMT)

**Second Aggregation (CV_BASE_FIN_WEEKLY_BUDGET_S4_Final CTE):**
- Groups by all dimensions EXCLUDING FLAG
- Applies restricted measures based on FLAG values
- Calculates final _B631_S_AMOUNT using CASE logic (FC takes precedence over LC)

### CV_COMP_MD_SRPACT_STATIC Aggregation:

- Groups by all non-measure columns
- Aggregates: SUM(RX_HRS_OPER), SUM(FS_HRS_OPER), SUM(RX_STORE), SUM(RETAIL_SQFT_AMT), SUM(TOTAL_SQFT_AMT)

**No additional aggregation is introduced in the consolidation.** The final FLAGS CTE performs projection and calculation only, without aggregation.

---

## Business Logic Preserved

### 1. Frozen vs Live Cube Logic
- **Parameter-driven:** @IP_FC_COUNT controls data source
- **Frozen Cube:** Used when @IP_FC_COUNT != '0'
- **Live Cube:** Used when @IP_FC_COUNT = '0'
- **Column Mapping:** Live Cube maps _BIC_ZIO_PCTR → _B631_S_PROFTCTR and _BIC_ZIO_CCTR → _B631_S_COSTCNTR

### 2. Restricted Measures
- **RES_AMOUNT_LC:** Sum of amounts where FLAG = 'LC'
- **RES_AMOUNT_FC:** Sum of amounts where FLAG = 'FC'

### 3. Calculated Measure Priority
- **_B631_S_AMOUNT:** Uses FC amount if available, otherwise uses LC amount
- **Logic:** `CASE WHEN SUM(FC) IS NULL THEN SUM(LC) ELSE SUM(FC) END`

### 4. CORE_RET Hierarchy Filter
- **INNER JOIN** on HIER_NODE ensures only profit centers under CORE_RET hierarchy are included
- **Filter:** PARNODE matches 'CORE_RET$' pattern AND HRYVALTO = '99991231'

### 5. FS/RX Flag Derivation
- **CAL_FS_RX_FLAG:** Derived from first 2 characters of _BIC_ZWWPC_PA1
- **Logic:** 'FS' if starts with 'FS', 'RX' if starts with 'RX', else empty string

### 6. Comparison Flag Logic
- **CAL_COMP_FLAG:** Selects FS_COMP_WK or RX_COMP_WK based on CAL_FS_RX_FLAG
- **Default:** Uses FS_COMP_WK if neither FS nor RX
- **Null Handling:** Returns '0' if selected flag is NULL

### 7. Amount Negation
- **Final _B631_S_AMOUNT:** Multiplies _B631_S_AMOUNT_NEGATIVE by -1
- **Purpose:** Converts negative budget amounts to positive for reporting

### 8. Week Number Calculation
- **CAL_WEEK_NUMBER:** Extracts last 2 digits of _BIC_ZIO_SWEEK
- **Method:** `RIGHT(CAST(_BIC_ZIO_SWEEK AS STRING), 2)`

---

## Data Type Conversions

The consolidated SQL includes the following data type conversions from the supplied SQL:

1. **_BIC_ZWWPC_PA1:** Cast to STRING for LEFT() function
2. **_BIC_ZIO_SWEEK:** Cast to STRING for RIGHT() function

**Note:** BigQuery may handle these conversions implicitly depending on the actual column data types. Explicit CAST statements are preserved from the supplied SQL.

---

## Execution Readiness

### Prerequisites for Execution:

1. **Replace Placeholders:**
   - All `PROJECT.DATASET` references must be replaced with actual BigQuery project and dataset names
   - `PROJECT.DATASET.TABLE` should be replaced with `PROJECT.DATASET.TBL_WSS_SRP_COMPFLAG`

2. **Provide Parameters:**
   - @IP_FC_COUNT
   - @IP_WEEK_ENDING_FROM
   - @IP_WEEK_ENDING_TO
   - @IP_VERSION

3. **Verify Table Existence:**
   - AZSRP_DS052_VT_S4
   - AZSRP_DS041_VT_S4
   - HRRP_NODE
   - TBL_WSS_SRP_ATTR_ACT
   - TBL_WSS_SRP_COMPFLAG
   - ZTFIGL_RCALWEEK
   - CEPCT

4. **Resolve MANDT Inconsistency:**
   - Standardize MANDT filter values and data types across all source tables

5. **Test Parameter Values:**
   - Validate parameter values with sample data to ensure correct filtering

### Post-Execution Validation:

1. **Row Count Validation:** Compare row counts with source HANA system
2. **Amount Validation:** Verify sum of _B631_S_AMOUNT matches expected totals
3. **Hierarchy Filter Validation:** Confirm only CORE_RET profit centers are included
4. **Join Validation:** Verify LEFT JOIN behavior preserves all budget records
5. **Calculated Column Validation:** Spot-check CAL_FS_RX_FLAG, CAL_COMP_FLAG, CAL_WEEK_NUMBER, and _B631_S_AMOUNT calculations

---

## Completeness Certification

✅ **All supplied SQL files evaluated**
✅ **All dependencies recursively expanded**
✅ **All CTEs explicitly defined**
✅ **All joins included**
✅ **All filters preserved**
✅ **All aggregations preserved**
✅ **All calculated columns included**
✅ **All CASE expressions included**
✅ **All business logic preserved**
✅ **No placeholders in CTE names**
✅ **No abbreviated SQL**
✅ **No omitted logic**
✅ **No pseudocode**
✅ **Execution-ready (pending placeholder replacement and parameter values)**

---

## Summary

The consolidated SQL successfully combines logic from **6 calculation views** into a single, fully expanded BigQuery query. The stored procedure **STP_WSS_SRP_ATTRIBUTES** is not expanded because:
1. It is an ETL process, not query logic
2. Its upstream source views (CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4) are not provided
3. The tables it populates are used as terminal sources

All validation items are clearly documented, and the SQL is ready for execution once placeholders are replaced and parameters are provided.

---

**End of Consolidation Analysis**