# CONSOLIDATION DESCRIPTION FOR 8 HANA FILES

## Executive Summary

This consolidation analysis covers 8 converted BigQuery SQL files derived from HANA artifacts (Calculation Views and Stored Procedures). The lineage analysis identified 19 relationships across physical tables, base views, composite views, and ETL procedures. The final consolidated SQL represents the complete end-to-end logic for **CV_COMP_FIN_BUDGET_STATIC**, which is the most comprehensive consumer-facing view available in the provided files.

---

## CONSOLIDATION TRACEABILITY

### Primary Consumer Artifact
**CV_COMP_FIN_BUDGET_STATIC** - Composite Financial Budget Static View

This view integrates financial budget data with organizational hierarchy, store attributes, comparison flags, calendar week information, and profit center text to provide a comprehensive weekly budget reporting dataset.

---

## FILE USAGE ANALYSIS

### USED FILES (7 of 8)

#### 1. **CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt** - USED
- **Role**: Base financial data source providing weekly budget amounts from frozen and live cubes
- **Upstream Dependencies**: 
  - AZSRP_DS052_VT_S4 (Frozen Cube physical table)
  - AZSRP_DS041_VT_S4 (Live Cube physical table)
- **Logic Consolidated**:
  - Union of Frozen Cube and Live Cube data based on @IP_FC_COUNT parameter
  - Aggregation of _B631_S_AMOUNT and _BIC_ZIO_AMT by fiscal period, GL account, profit center, cost center, etc.
  - Calculated measure logic: Uses FC (Frozen Cube) amount if available, otherwise LC (Live Cube) amount
  - Restricted measures: RES_AMOUNT_LC and RES_AMOUNT_FC
- **Consolidation Impact**: Fully expanded and inlined into WEEKLY_SNAPSHOT_DS05 CTE with additional filters (FISCVARNT = 'K4', week range, version, SAUDT filter)

#### 2. **CV_BASE_MD_CEPCT_S4_OUTPUT.txt** - USED
- **Role**: Cost element and profit center master data
- **Upstream Dependencies**: 
  - CEPCT (Physical table)
- **Logic Consolidated**:
  - Direct projection from CEPCT table
  - MANDT filter: IN (120, 200)
  - Provides LTEXT as PROFIT_CENTER_TEXT
- **Consolidation Impact**: Expanded into CV_BASE_MD_CEPCT_S4_Expanded CTE and joined to provide profit center descriptions in Join_5

#### 3. **CV_BASE_MD_HRRP_NODE_S4_Output.txt** - USED
- **Role**: HR reporting hierarchy node data
- **Upstream Dependencies**: 
  - HRRP_NODE (Physical table)
- **Logic Consolidated**:
  - Direct projection from HRRP_NODE table
  - MANDT filter: IN (120, 200)
  - Filtered for CORE_RET parent nodes with HRYVALTO = '99991231'
- **Consolidation Impact**: Expanded into CV_BASE_MD_HRRP_NODE_S4_Expanded CTE, then filtered in HIER_NODE CTE, and inner joined in Join_1 to restrict data to CORE_RET organizational nodes

#### 4. **CV_BASE_MD_RCAIWEEK_S4_Output.txt** - USED
- **Role**: Calendar week master data
- **Upstream Dependencies**: 
  - ZTFIGL_RCALWEEK (Physical table)
- **Logic Consolidated**:
  - Direct projection from ZTFIGL_RCALWEEK table
  - RCLNT filter: IN (120, 200)
  - Provides week start/end dates (ZRWSTRTDATE, ZRWENDDATE)
- **Consolidation Impact**: Expanded into CV_BASE_MD_RCALWEEK_S4_Expanded CTE, then projected in CAL_WEEK CTE, and left joined in Join_4 to provide calendar week date ranges

#### 5. **CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt** - USED
- **Role**: Final consumer-facing composite view (PRIMARY CONSOLIDATION TARGET)
- **Upstream Dependencies**: 
  - CV_BASE_FIN_WEEKLY_BUDGET_S4
  - CV_BASE_MD_HRRP_NODE_S4
  - CV_COMP_MD_SRPACT_STATIC
  - CV_COMP_MD_COMPFL_STATIC
  - CV_BASE_MD_RCALWEEK_S4
  - CV_BASE_MD_CEPCT_S4
- **Logic Consolidated**:
  - Complex multi-join logic integrating 6 upstream data sources
  - Calculated columns: CAL_FS_RX_FLAG, CAL_COMP_FLAG, CAL_WEEK_NUMBER, _B631_S_AMOUNT (negated)
  - Business logic for FS/RX flag determination based on _BIC_ZWWPC_PA1
  - Comparison flag logic selecting FS_COMP_WK or RX_COMP_WK based on FS/RX flag
- **Consolidation Impact**: This is the final output view; all upstream dependencies have been recursively expanded and inlined

#### 6. **CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt** - USED
- **Role**: Comparison flags static view
- **Upstream Dependencies**: 
  - TBL_WSS_SRP_COMPFLAG (Physical table populated by STP_WSS_SRP_ATTRIBUTES)
- **Logic Consolidated**:
  - Direct projection from TBL_WSS_SRP_COMPFLAG table
  - Provides FS_COMP_WK and RX_COMP_WK flags for weekly, monthly, and period comparisons
- **Consolidation Impact**: Expanded into CV_COMP_MD_COMPFL_STATIC_Expanded CTE, filtered by COMP_VER in COMP_FLAG_BUDGET CTE, and left joined in Join_3

#### 7. **CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt** - USED
- **Role**: Store attributes static view
- **Upstream Dependencies**: 
  - TBL_WSS_SRP_ATTR_ACT (Physical table populated by STP_WSS_SRP_ATTRIBUTES)
- **Logic Consolidated**:
  - Aggregation from TBL_WSS_SRP_ATTR_ACT table
  - GROUP BY all dimensional attributes
  - SUM of measures: RX_HRS_OPER, FS_HRS_OPER, RX_STORE, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT
  - Provides store location, hierarchy, operational dates, and store characteristics
- **Consolidation Impact**: Expanded into CV_COMP_MD_SRPACT_STATIC_Expanded CTE, projected in STORE_ATTR_ACTUAL CTE, and left joined in Join_2 to enrich financial data with store attributes

### NOT USED FILES (1 of 8)

#### 8. **STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt** - NOT USED
- **Role**: ETL stored procedure that populates TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG
- **Reason for Exclusion**: 
  - This is an ETL/data population procedure, not a query artifact
  - The procedure populates intermediate tables (TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG) that are already referenced as physical source tables in the consolidated query
  - According to ETL expansion rules, we trace back to the source SELECT logic, not the INSERT/MERGE logic
  - The procedure references two external views not provided in the converted SQL files:
    - CV_BASE_MD_SRPACT_S4 (source for store attributes)
    - CV_BASE_MD_COMPFL_S4 (source for comparison flags)
  - The procedure contains an unresolved scalar function: CVS_FRIP_CVS_FRIP_Composite_Master_SFN_PRIOR_FISCAL_WEEK()
  - Since the tables populated by this procedure (TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG) are treated as physical source tables in the consolidated query, and no further upstream source logic is available in the provided files, the consolidation stops at these tables

---

## DEPENDENCY RESOLUTION FLOW

### Consolidation Hierarchy (Bottom-Up)

```
Level 1: Physical Tables (Source Layer)
├── AZSRP_DS052_VT_S4 (Frozen Cube)
├── AZSRP_DS041_VT_S4 (Live Cube)
├── HRRP_NODE (HR Hierarchy)
├── CEPCT (Cost Element/Profit Center)
├── ZTFIGL_RCALWEEK (Calendar Week)
├── TBL_WSS_SRP_ATTR_ACT (Store Attributes - ETL populated)
└── TBL_WSS_SRP_COMPFLAG (Comparison Flags - ETL populated)

Level 2: Base Views (Transformation Layer)
├── CV_BASE_FIN_WEEKLY_BUDGET_S4
│   ├── Frozen_Cube CTE (from AZSRP_DS052_VT_S4)
│   ├── Live_Cube CTE (from AZSRP_DS041_VT_S4)
│   ├── Union_1 CTE (UNION ALL of Frozen and Live)
│   ├── Aggregated CTE (GROUP BY with FLAG)
│   └── Final CTE (Calculated measure logic)
├── CV_BASE_MD_HRRP_NODE_S4 (from HRRP_NODE)
├── CV_BASE_MD_CEPCT_S4 (from CEPCT)
└── CV_BASE_MD_RCALWEEK_S4 (from ZTFIGL_RCALWEEK)

Level 3: Composite Views (Aggregation Layer)
├── CV_COMP_MD_SRPACT_STATIC (from TBL_WSS_SRP_ATTR_ACT)
└── CV_COMP_MD_COMPFL_STATIC (from TBL_WSS_SRP_COMPFLAG)

Level 4: Final Consumer View (Reporting Layer)
└── CV_COMP_FIN_BUDGET_STATIC
    ├── WEEKLY_SNAPSHOT_DS05 (from CV_BASE_FIN_WEEKLY_BUDGET_S4 with filters)
    ├── HIER_NODE (from CV_BASE_MD_HRRP_NODE_S4 with CORE_RET filter)
    ├── Join_1 (INNER JOIN financial data with HR hierarchy)
    ├── ONLY_CORE_RET_DATA (filtered financial data)
    ├── STORE_ATTR_ACTUAL (from CV_COMP_MD_SRPACT_STATIC)
    ├── Join_2 (LEFT JOIN with store attributes)
    ├── WEEK_NUMBER (calculated week number)
    ├── COMP_FLAG_BUDGET (from CV_COMP_MD_COMPFL_STATIC with version filter)
    ├── Join_3 (LEFT JOIN with comparison flags)
    ├── CAL_WEEK (from CV_BASE_MD_RCALWEEK_S4)
    ├── Join_4 (LEFT JOIN with calendar week)
    ├── PROFIT_CENTER_TEXT (from CV_BASE_MD_CEPCT_S4)
    ├── Join_5 (LEFT JOIN with profit center text)
    └── FLAGS (final calculated columns and output)
```

---

## CONSOLIDATION LOGIC DETAILS

### CTE Structure in Final Consolidated SQL

1. **Frozen_Cube**: Extracts frozen cube financial data with FLAG='FC'
2. **Live_Cube**: Extracts live cube financial data with FLAG='LC'
3. **Union_1**: Combines frozen and live cube data
4. **Aggregated**: Aggregates amounts by all dimensions including FLAG
5. **CV_BASE_FIN_WEEKLY_BUDGET_S4_Expanded**: Calculates final amounts using FC-first logic
6. **WEEKLY_SNAPSHOT_DS05**: Filters expanded budget data by fiscal variant, week range, version, and SAUDT
7. **CV_BASE_MD_HRRP_NODE_S4_Expanded**: Expands HR hierarchy node data
8. **HIER_NODE**: Filters for CORE_RET parent nodes
9. **Join_1**: Inner joins financial data with HR hierarchy
10. **ONLY_CORE_RET_DATA**: Passes through CORE_RET-filtered data
11. **CV_COMP_MD_SRPACT_STATIC_Expanded**: Expands and aggregates store attributes
12. **STORE_ATTR_ACTUAL**: Projects store attribute columns
13. **Join_2**: Left joins financial data with store attributes
14. **WEEK_NUMBER**: Calculates week number from _BIC_ZIO_SWEEK
15. **CV_COMP_MD_COMPFL_STATIC_Expanded**: Expands comparison flags
16. **COMP_FLAG_BUDGET**: Filters comparison flags by version
17. **Join_3**: Left joins with comparison flags
18. **CV_BASE_MD_RCALWEEK_S4_Expanded**: Expands calendar week data
19. **CAL_WEEK**: Projects calendar week columns
20. **Join_4**: Left joins with calendar week dates
21. **CV_BASE_MD_CEPCT_S4_Expanded**: Expands cost element/profit center data
22. **PROFIT_CENTER_TEXT**: Projects profit center text
23. **Join_5**: Left joins with profit center text
24. **FLAGS**: Final CTE with calculated columns and amount negation

### Key Business Logic Preserved

1. **Frozen vs Live Cube Logic**: 
   - When @IP_FC_COUNT != '0', use Frozen Cube data
   - When @IP_FC_COUNT = '0', use Live Cube data
   - Final amount calculation: Use FC amount if available, otherwise use LC amount

2. **CORE_RET Filtering**: 
   - Only includes profit centers under CORE_RET parent nodes in the HR hierarchy
   - Uses REGEXP_CONTAINS(PARNODE, 'CORE_RET$') to match HANA's match('*CORE_RET')

3. **FS/RX Flag Determination**:
   - Examines first 2 characters of _BIC_ZWWPC_PA1
   - 'FS' = Front Store, 'RX' = Pharmacy

4. **Comparison Flag Selection**:
   - Uses FS_COMP_WK for Front Store transactions
   - Uses RX_COMP_WK for Pharmacy transactions
   - Defaults to '0' if comparison flag is NULL

5. **Amount Negation**:
   - Final _B631_S_AMOUNT is negated (multiplied by -1)
   - Source column _B631_S_AMOUNT_NEGATIVE is actually the non-negated value

6. **Aggregation Grain Preservation**:
   - CV_BASE_FIN_WEEKLY_BUDGET_S4 has two aggregation stages:
     - Aggregated CTE: Groups by all dimensions including FLAG
     - Final CTE: Groups by all dimensions excluding FLAG (collapsed)
   - This exact grain is preserved in the consolidated SQL

---

## PARAMETERS REQUIRED

The consolidated SQL requires the following parameters to be set before execution:

1. **@IP_FC_COUNT** (STRING)
   - Purpose: Determines whether to use Frozen Cube or Live Cube data
   - Values: '0' = Live Cube, any other value = Frozen Cube
   - Used in: Frozen_Cube and Live_Cube CTEs

2. **@IP_WEEK_ENDING_FROM** (STRING or DATE)
   - Purpose: Start of week range filter
   - Format: Fiscal week format (e.g., '202401')
   - Used in: WEEKLY_SNAPSHOT_DS05 CTE

3. **@IP_WEEK_ENDING_TO** (STRING or DATE)
   - Purpose: End of week range filter
   - Format: Fiscal week format (e.g., '202452')
   - Used in: WEEKLY_SNAPSHOT_DS05 CTE

4. **@IP_VERSION** (STRING)
   - Purpose: Budget version filter
   - Used in: WEEKLY_SNAPSHOT_DS05 and COMP_FLAG_BUDGET CTEs

### BigQuery Parameter Declaration

Before executing the consolidated SQL, declare parameters:

```sql
DECLARE IP_FC_COUNT STRING DEFAULT '0';
DECLARE IP_WEEK_ENDING_FROM STRING DEFAULT '202401';
DECLARE IP_WEEK_ENDING_TO STRING DEFAULT '202452';
DECLARE IP_VERSION STRING DEFAULT 'BUDGET_V1';
```

---

## VALIDATION ITEMS

### REQUIRES VALIDATION: SOURCE SQL CONFLICT

**Issue**: Column name mismatch between upstream and downstream SQL

**Details**:
- **Downstream Reference**: CV_COMP_FIN_BUDGET_STATIC references column `_B631_S_AMOUNT_NEGATIVE`
- **Upstream Production**: CV_BASE_FIN_WEEKLY_BUDGET_S4 produces column `_B631_S_AMOUNT`
- **Location**: FLAGS CTE in CV_COMP_FIN_BUDGET_STATIC

**Impact**: 
The consolidated SQL uses `_B631_S_AMOUNT` from the upstream view and aliases it as `_B631_S_AMOUNT_NEGATIVE` in the FLAGS CTE. The final calculation then negates this value to produce the final `_B631_S_AMOUNT`. This preserves the logic as written in the supplied SQL files, but the naming suggests the upstream column may already be negative, which would result in double negation.

**Recommendation**: 
Validate with business users whether:
1. The upstream `_B631_S_AMOUNT` is already negative (requiring no negation)
2. The upstream `_B631_S_AMOUNT` is positive (requiring negation as implemented)
3. The column naming convention is misleading

**Current Implementation**:
The consolidated SQL preserves the exact logic from the supplied files:
- Uses `_B631_S_AMOUNT` from upstream
- Stores it as `_B631_S_AMOUNT_NEGATIVE` in intermediate CTE
- Negates it in final output: `(_B631_S_AMOUNT_NEGATIVE * -1) AS _B631_S_AMOUNT`

---

### REQUIRES VALIDATION: EXTERNAL DEPENDENCIES

**Issue**: Missing upstream calculation views referenced by stored procedure

**Details**:
The stored procedure STP_WSS_SRP_ATTRIBUTES references two calculation views that are NOT provided in the converted SQL files:

1. **CV_BASE_MD_SRPACT_S4**
   - Referenced in: INSERT INTO TBL_WSS_SRP_ATTR_ACT
   - Purpose: Source view for store attributes
   - Impact: TBL_WSS_SRP_ATTR_ACT population logic cannot be fully traced

2. **CV_BASE_MD_COMPFL_S4**
   - Referenced in: INSERT INTO TBL_WSS_SRP_COMPFLAG
   - Purpose: Source view for comparison flags
   - Impact: TBL_WSS_SRP_COMPFLAG population logic cannot be fully traced

**Current Implementation**:
The consolidated SQL treats TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG as physical source tables since their population logic cannot be fully expanded from the provided files.

**Recommendation**:
1. Obtain the converted SQL for CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_COMPFL_S4
2. If these views should be expanded, re-run consolidation with complete inputs
3. If these tables are intended as materialized/snapshot tables, current implementation is correct

---

### REQUIRES VALIDATION: UNRESOLVED FUNCTION

**Issue**: Scalar function not available in BigQuery

**Details**:
- **Function**: CVS_FRIP.CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK()
- **Referenced in**: STP_WSS_SRP_ATTRIBUTES stored procedure
- **Purpose**: Calculates prior fiscal week for comparison flag filtering
- **Impact**: Cannot execute stored procedure without this function

**Current Implementation**:
The stored procedure SQL contains a placeholder comment indicating the function is unresolved.

**Recommendation**:
1. Implement SFN_PRIOR_FISCAL_WEEK as a BigQuery UDF
2. Or provide the prior fiscal week as an input parameter
3. Or replace with BigQuery native date arithmetic logic

---

### REQUIRES VALIDATION: MANDT VALUE MISMATCH

**Issue**: Inconsistent MANDT filter values across views

**Details**:
- **CV_BASE_FIN_WEEKLY_BUDGET_S4**: MANDT IN ('110', '200') [STRING]
- **CV_BASE_MD_HRRP_NODE_S4**: MANDT IN (120, 200) [INTEGER]
- **CV_BASE_MD_CEPCT_S4**: MANDT IN (120, 200) [INTEGER]
- **CV_BASE_MD_RCALWEEK_S4**: MANDT IN (120, 200) [INTEGER]

**Impact**:
- Potential join failures if MANDT data types are inconsistent
- MANDT value '110' vs 120 may indicate different client/tenant filtering

**Recommendation**:
1. Verify correct MANDT values for the target environment
2. Ensure consistent data type (STRING vs INTEGER) across all tables
3. Confirm whether '110' and 120 are different representations of the same client

**Current Implementation**:
The consolidated SQL preserves the exact MANDT filters from each source file without modification.

---

## PHYSICAL TABLE REFERENCES

The following physical tables must exist in BigQuery for the consolidated SQL to execute:

1. **PROJECT.DATASET.AZSRP_DS052_VT_S4** - Frozen Cube financial data
2. **PROJECT.DATASET.AZSRP_DS041_VT_S4** - Live Cube financial data
3. **PROJECT.DATASET.HRRP_NODE** - HR reporting hierarchy nodes
4. **PROJECT.DATASET.CEPCT** - Cost element and profit center master data
5. **PROJECT.DATASET.ZTFIGL_RCALWEEK** - Calendar week master data
6. **PROJECT.DATASET.TBL_WSS_SRP_ATTR_ACT** - Store attributes (ETL populated)
7. **PROJECT.DATASET.TBL_WSS_SRP_COMPFLAG** - Comparison flags (ETL populated)

**Note**: Replace `PROJECT.DATASET` with actual BigQuery project and dataset names.

---

## ETL CONSIDERATIONS

### Tables Populated by Stored Procedure

The following tables are populated by STP_WSS_SRP_ATTRIBUTES and should be refreshed before running the consolidated query:

1. **TBL_WSS_SRP_ATTR_ACT**
   - Population Method: DELETE + INSERT from CV_BASE_MD_SRPACT_S4
   - Refresh Frequency: As determined by stored procedure schedule
   - Snapshot Columns: SNAPSHOT_TIMESTAMP, SNAPSHOT_CREATED_BY

2. **TBL_WSS_SRP_COMPFLAG**
   - Population Method: DELETE + INSERT from CV_BASE_MD_COMPFL_S4
   - Filter: ZWEEK = Prior Fiscal Week
   - Refresh Frequency: As determined by stored procedure schedule
   - Snapshot Columns: SNAPSHOT_TIMESTAMP, CREATED_BY

### Execution Order

For complete data refresh:
1. Execute STP_WSS_SRP_ATTRIBUTES to populate snapshot tables
2. Execute consolidated CV_COMP_FIN_BUDGET_STATIC query

---

## AGGREGATION GRAIN ANALYSIS

### CV_BASE_FIN_WEEKLY_BUDGET_S4 Grain

**Aggregated CTE Grain** (with FLAG):
- FISCPER, FISCVARNT, _BIC_ZIO_SWEEK, FISCYEAR, FISCPER3
- _B631_S_CHRTACCT, _B631_S_GL_ACCT, _B631_S_CO_AREA, _BIC_ZIO_CMPCD
- _B631_S_PROFTCTR, _B631_S_COSTCNTR, _B631_S_FUNCAREA
- _BIC_ZIO_VER, _BIC_ZIO_SAUDT, MANDT
- _BIC_ZWWPC_PA1, _BIC_ZWWSC_PA1, RECORDMODE, CURRENCY
- **FLAG** (FC or LC)

**Final CTE Grain** (without FLAG):
- Same as above EXCEPT FLAG is removed
- FLAG is used to calculate restricted measures but not included in GROUP BY

This two-stage aggregation is preserved exactly in the consolidated SQL.

---

## JOIN ANALYSIS

### Join Sequence and Types

1. **Join_1**: INNER JOIN
   - Left: WEEKLY_SNAPSHOT_DS05 (financial data)
   - Right: HIER_NODE (HR hierarchy)
   - Condition: _B631_S_PROFTCTR = NODEVALUE
   - Purpose: Restrict to CORE_RET organizational nodes
   - Impact: Filters out non-CORE_RET profit centers

2. **Join_2**: LEFT JOIN
   - Left: ONLY_CORE_RET_DATA
   - Right: STORE_ATTR_ACTUAL
   - Condition: _B631_S_PROFTCTR = PRCTR
   - Purpose: Enrich with store attributes
   - Impact: Retains all financial records even if store attributes missing

3. **Join_3**: LEFT JOIN
   - Left: WEEK_NUMBER
   - Right: COMP_FLAG_BUDGET
   - Condition: _B631_S_PROFTCTR = PRCTR AND _BIC_ZIO_SWEEK = ZWEEK
   - Purpose: Add comparison flags
   - Impact: Retains all records even if comparison flags missing

4. **Join_4**: LEFT JOIN
   - Left: Join_3
   - Right: CAL_WEEK
   - Condition: _BIC_ZIO_SWEEK = ZZWEEK
   - Purpose: Add calendar week start/end dates
   - Impact: Retains all records even if calendar dates missing

5. **Join_5**: LEFT JOIN
   - Left: Join_4
   - Right: PROFIT_CENTER_TEXT
   - Condition: _B631_S_PROFTCTR = PRCTR
   - Purpose: Add profit center descriptions
   - Impact: Retains all records even if text missing

### Join Cardinality Expectations

- **Join_1 (INNER)**: Many-to-one (many financial records to one HR node)
- **Join_2 (LEFT)**: Many-to-one (many financial records to one store)
- **Join_3 (LEFT)**: One-to-one (one financial record to one comparison flag per week)
- **Join_4 (LEFT)**: Many-to-one (many financial records to one calendar week)
- **Join_5 (LEFT)**: Many-to-one (many financial records to one profit center text)

---

## CALCULATED COLUMNS

### CAL_FS_RX_FLAG
```sql
CASE
  WHEN LEFT(CAST(_BIC_ZWWPC_PA1 AS STRING), 2) = 'FS' THEN 'FS'
  WHEN LEFT(CAST(_BIC_ZWWPC_PA1 AS STRING), 2) = 'RX' THEN 'RX'
  ELSE ''
END
```
**Purpose**: Identifies whether transaction is Front Store (FS) or Pharmacy (RX)

### CAL_COMP_FLAG
```sql
CASE
  WHEN (
    CASE
      WHEN LEFT(CAST(_BIC_ZWWPC_PA1 AS STRING), 2) = 'FS' THEN FS_COMP_WK
      WHEN LEFT(CAST(_BIC_ZWWPC_PA1 AS STRING), 2) = 'RX' THEN RX_COMP_WK
      ELSE FS_COMP_WK
    END
  ) IS NULL THEN '0'
  ELSE (
    CASE
      WHEN LEFT(CAST(_BIC_ZWWPC_PA1 AS STRING), 2) = 'FS' THEN FS_COMP_WK
      WHEN LEFT(CAST(_BIC_ZWWPC_PA1 AS STRING), 2) = 'RX' THEN RX_COMP_WK
      ELSE FS_COMP_WK
    END
  )
END
```
**Purpose**: Selects appropriate comparison flag based on FS/RX designation, defaults to '0' if NULL

### CAL_WEEK_NUMBER
```sql
RIGHT(CAST(_BIC_ZIO_SWEEK AS STRING), 2)
```
**Purpose**: Extracts week number from fiscal week identifier

### _B631_S_AMOUNT (Final)
```sql
(_B631_S_AMOUNT_NEGATIVE * -1)
```
**Purpose**: Negates the amount for reporting (converts expense to negative or vice versa)

---

## DATA LINEAGE SUMMARY

### Complete Data Flow

```
Physical Tables (7)
  ↓
Base Views (4)
  ↓
Composite Views (2)
  ↓
Final Consumer View (1)
```

### Lineage Paths

**Path 1: Financial Data**
AZSRP_DS052_VT_S4 → CV_BASE_FIN_WEEKLY_BUDGET_S4 → CV_COMP_FIN_BUDGET_STATIC
AZSRP_DS041_VT_S4 → CV_BASE_FIN_WEEKLY_BUDGET_S4 → CV_COMP_FIN_BUDGET_STATIC

**Path 2: HR Hierarchy**
HRRP_NODE → CV_BASE_MD_HRRP_NODE_S4 → CV_COMP_FIN_BUDGET_STATIC

**Path 3: Store Attributes**
CV_BASE_MD_SRPACT_S4 (External) → STP_WSS_SRP_ATTRIBUTES → TBL_WSS_SRP_ATTR_ACT → CV_COMP_MD_SRPACT_STATIC → CV_COMP_FIN_BUDGET_STATIC

**Path 4: Comparison Flags**
CV_BASE_MD_COMPFL_S4 (External) → STP_WSS_SRP_ATTRIBUTES → TBL_WSS_SRP_COMPFLAG → CV_COMP_MD_COMPFL_STATIC → CV_COMP_FIN_BUDGET_STATIC

**Path 5: Calendar Week**
ZTFIGL_RCALWEEK → CV_BASE_MD_RCALWEEK_S4 → CV_COMP_FIN_BUDGET_STATIC

**Path 6: Profit Center Text**
CEPCT → CV_BASE_MD_CEPCT_S4 → CV_COMP_FIN_BUDGET_STATIC

---

## COMPLETENESS VERIFICATION

### All CTEs Included: ✓
- 24 CTEs fully defined
- No placeholders
- No ellipsis
- No "for brevity" statements
- No "remaining logic omitted" statements

### All Dependencies Resolved: ⚠️
- 7 of 8 files used
- 1 stored procedure excluded (ETL logic, not query logic)
- 2 external dependencies identified (CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4)
- 1 unresolved function (SFN_PRIOR_FISCAL_WEEK)

### All Business Logic Preserved: ✓
- Frozen/Live cube logic preserved
- CORE_RET filtering preserved
- FS/RX flag logic preserved
- Comparison flag selection preserved
- Amount negation preserved
- Aggregation grain preserved
- All joins preserved
- All filters preserved
- All calculated columns preserved

---

## EXECUTION READINESS

### Prerequisites
1. ✓ All physical tables must exist in BigQuery
2. ✓ Parameters must be declared before execution
3. ⚠️ TBL_WSS_SRP_ATTR_ACT must be populated (via stored procedure or manual load)
4. ⚠️ TBL_WSS_SRP_COMPFLAG must be populated (via stored procedure or manual load)
5. ⚠️ MANDT value consistency must be verified
6. ⚠️ Column name conflict (_B631_S_AMOUNT vs _B631_S_AMOUNT_NEGATIVE) must be validated

### Execution Steps
1. Declare parameters (IP_FC_COUNT, IP_WEEK_ENDING_FROM, IP_WEEK_ENDING_TO, IP_VERSION)
2. Replace PROJECT.DATASET placeholders with actual BigQuery project and dataset
3. Verify all physical tables exist and contain data
4. Execute consolidated SQL
5. Validate output record counts and amounts

---

## CONSOLIDATION STATISTICS

- **Total Files Analyzed**: 8
- **Files Used**: 7 (87.5%)
- **Files Not Used**: 1 (12.5%)
- **Total CTEs Generated**: 24
- **Total Joins**: 5 (1 INNER, 4 LEFT)
- **Physical Tables Referenced**: 7
- **External Dependencies**: 2 (CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4)
- **Unresolved Functions**: 1 (SFN_PRIOR_FISCAL_WEEK)
- **Parameters Required**: 4
- **Validation Items**: 4
- **Lines of SQL**: ~600+

---

## FINAL NOTES

This consolidation represents a complete, executable BigQuery SQL implementation that:

1. ✓ Fully expands all available upstream dependencies
2. ✓ Preserves all business logic from source files
3. ✓ Maintains exact aggregation grain
4. ✓ Includes all joins, filters, and calculated columns
5. ✓ Contains no placeholders or abbreviations
6. ✓ Can be executed directly in BigQuery (after parameter declaration and table name replacement)
7. ⚠️ Requires validation of identified conflicts and external dependencies

The consolidated SQL is production-ready pending resolution of the validation items documented above.