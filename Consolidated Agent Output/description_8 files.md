# CONSOLIDATION DESCRIPTION - CV_COMP_FIN_BUDGET_STATIC

## Executive Summary

This consolidation produces a single, fully expanded BigQuery SQL implementation for **CV_COMP_FIN_BUDGET_STATIC**, which is the final consumer-facing artifact in the budget reporting lineage. All intermediate calculation views and dependencies have been recursively inlined to create an execution-ready query that requires no external view definitions.

---

## Lineage Analysis

### Source File: FS_Budget_Lineage_file.csv

The lineage file defines the following dependency relationships (ordered by priority):

#### Primary Lineage Path (Target: CV_COMP_FIN_BUDGET_STATIC)

1. **CV_BASE_FIN_WEEKLY_BUDGET_S4** → **CV_BASE_MD_RCAIWEEK_S4**
   - Relationship: Direct Dependency - Calculation View Reference
   - Score: 98
   - Reason: CV_BASE_MD_RCAIWEEK_S4 explicitly references CV_BASE_FIN_WEEKLY_BUDGET_S4 in its dataSources section

2. **CV_BASE_MD_HRRP_NODE_S4** → **CV_BASE_MD_RCAIWEEK_S4**
   - Relationship: Direct Dependency - Calculation View Reference
   - Score: 98
   - Reason: CV_BASE_MD_RCAIWEEK_S4 explicitly references CV_BASE_MD_HRRP_NODE_S4 for HR hierarchy data

3. **CV_COMP_MD_SRPACT_STATIC** → **CV_BASE_MD_RCAIWEEK_S4**
   - Relationship: Direct Dependency - Calculation View Reference
   - Score: 98
   - Reason: CV_BASE_MD_RCAIWEEK_S4 explicitly references CV_COMP_MD_SRPACT_STATIC for store reporting activity attributes

4. **CV_COMP_MD_COMPFL_STATIC** → **CV_BASE_MD_RCAIWEEK_S4**
   - Relationship: Direct Dependency - Calculation View Reference
   - Score: 98
   - Reason: CV_BASE_MD_RCAIWEEK_S4 explicitly references CV_COMP_MD_COMPFL_STATIC for comparison flag data

5. **CV_BASE_MD_CEPCT_S4** → **CV_BASE_MD_RCAIWEEK_S4**
   - Relationship: Direct Dependency - Calculation View Reference
   - Score: 98
   - Reason: CV_BASE_MD_RCAIWEEK_S4 explicitly references CV_BASE_MD_CEPCT_S4 for text/description data

#### Data Population Lineage (ETL/Stored Procedure)

6. **STP_WSS_SRP_ATTRIBUTES** → **CV_COMP_MD_SRPACT_STATIC**
   - Relationship: Direct Dependency - Table Population
   - Score: 96
   - Reason: The stored procedure STP_WSS_SRP_ATTRIBUTES inserts data into TBL_WSS_SRP_ATTR_ACT, which is the underlying table that CV_COMP_MD_SRPACT_STATIC reads from

7. **STP_WSS_SRP_ATTRIBUTES** → **CV_COMP_MD_COMPFL_STATIC**
   - Relationship: Direct Dependency - Table Population
   - Score: 96
   - Reason: The stored procedure STP_WSS_SRP_ATTRIBUTES inserts data into TBL_WSS_SRP_COMPFLAG, which is the underlying table that CV_COMP_MD_COMPFL_STATIC reads from

#### Circular Dependencies (Informational)

8. **CV_COMP_MD_SRPACT_STATIC** ↔ **STP_WSS_SRP_ATTRIBUTES**
   - Relationship: Circular Dependency - Data Consumer and Provider
   - Score: 94
   - Reason: CV_COMP_MD_SRPACT_STATIC reads from TBL_WSS_SRP_ATTR_ACT table, which is populated by STP_WSS_SRP_ATTRIBUTES procedure. The procedure also reads from CV_BASE_MD_SRPACT_S4 (a related view in the same lineage family), creating a circular data refresh pattern.

9. **CV_COMP_MD_COMPFL_STATIC** ↔ **STP_WSS_SRP_ATTRIBUTES**
   - Relationship: Circular Dependency - Data Consumer and Provider
   - Score: 94
   - Reason: CV_COMP_MD_COMPFL_STATIC reads from TBL_WSS_SRP_COMPFLAG table, which is populated by STP_WSS_SRP_ATTRIBUTES procedure. The procedure also reads from CV_BASE_MD_COMPFL_S4 (a related view in the same lineage family), creating a circular data refresh pattern.

---

## Relationship Priority Application

Per the RELATIONSHIP PRIORITY RULE:

1. **Data Population via INSERT** (Highest Priority)
2. **Source View for Procedure**
3. **Calculation View Dependency**
4. **Data Source** (Terminal)

### Priority Resolution:

- **CV_COMP_MD_SRPACT_STATIC**: Has both "Data Source" and "Data Population via INSERT" relationships. Per priority rules, the **Data Population via INSERT** relationship is authoritative. However, the stored procedure STP_WSS_SRP_ATTRIBUTES references calculation views (CV_BASE_MD_SRPACT_S4) that are NOT provided in the supplied SQL files. Therefore, we treat **TBL_WSS_SRP_ATTR_ACT** as the terminal source for this consolidation.

- **CV_COMP_MD_COMPFL_STATIC**: Has both "Data Source" and "Data Population via INSERT" relationships. Per priority rules, the **Data Population via INSERT** relationship is authoritative. However, the stored procedure STP_WSS_SRP_ATTRIBUTES references calculation views (CV_BASE_MD_COMPFL_S4) that are NOT provided in the supplied SQL files. Therefore, we treat **TBL_WSS_SRP_COMPFLAG** as the terminal source for this consolidation.

---

## SQL File Usage Classification

### USED Files:

1. **CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt** - USED
   - Role: Provides weekly budget data from frozen/live cubes
   - Inlined into: WEEKLY_SNAPSHOT_DS05 CTE
   - Upstream sources: AZSRP_DS052_VT_S4 (Frozen Cube), AZSRP_DS041_VT_S4 (Live Cube)
   - Logic preserved: UNION of frozen/live cubes, aggregation with FLAG-based restricted measures, conditional calculation for _B631_S_AMOUNT

2. **CV_BASE_MD_HRRP_NODE_S4_Output.txt** - USED
   - Role: Provides HR hierarchy node data
   - Inlined into: HIER_NODE CTE
   - Upstream source: HRRP_NODE table
   - Logic preserved: Filter for PARNODE matching 'CORE_RET$' pattern and HRYVALTO = '99991231'

3. **CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt** - USED
   - Role: Provides store reporting attributes
   - Inlined into: STORE_ATTR_ACTUAL CTE
   - Upstream source: TBL_WSS_SRP_ATTR_ACT table
   - Logic preserved: Aggregation of store attributes with GROUP BY on all non-measure columns

4. **CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt** - USED
   - Role: Provides comparison flag data
   - Inlined into: COMP_FLAG_BUDGET CTE
   - Upstream source: TBL_WSS_SRP_COMPFLAG table
   - Logic preserved: Filter by COMP_VER = @IP_VERSION parameter

5. **CV_BASE_MD_RCAIWEEK_S4_Output.txt** - USED
   - Role: Provides calendar week mapping data
   - Inlined into: CAL_WEEK CTE
   - Upstream source: ZTFIGL_RCALWEEK table
   - Logic preserved: Filter for RCLNT IN (120, 200)

6. **CV_BASE_MD_CEPCT_S4_OUTPUT.txt** - USED
   - Role: Provides profit center text descriptions
   - Inlined into: PROFIT_CENTER_TEXT CTE
   - Upstream source: CEPCT table
   - Logic preserved: Filter for MANDT IN (120, 200), projection of LTEXT as PROFIT_CENTER_TEXT

7. **CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt** - USED
   - Role: Target/final output view - defines the complete transformation logic
   - Inlined into: Multiple CTEs (WEEKLY_SNAPSHOT_DS05, Join_1 through Join_5, FLAGS)
   - Logic preserved: All joins, filters, calculated columns, and final projection

### NOT USED Files:

8. **STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt** - NOT USED
   - Reason: This stored procedure populates TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG tables. Per the lineage, these tables are the data sources for CV_COMP_MD_SRPACT_STATIC and CV_COMP_MD_COMPFL_STATIC. However, the procedure references upstream calculation views (CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_COMPFL_S4) that are NOT provided in the supplied SQL files. Since we cannot fully expand the stored procedure logic without these missing dependencies, and since the target consolidated query (CV_COMP_FIN_BUDGET_STATIC) reads from the static views that reference the populated tables directly, we treat the tables as terminal sources rather than expanding through the stored procedure. The stored procedure logic is documented but not inlined into the final consolidated SQL.

---

## Consolidation Traceability

### Dependency Resolution Flow:

```
CV_COMP_FIN_BUDGET_STATIC (Target)
│
├─ CV_BASE_FIN_WEEKLY_BUDGET_S4
│  ├─ AZSRP_DS052_VT_S4 (Frozen Cube) [TERMINAL]
│  └─ AZSRP_DS041_VT_S4 (Live Cube) [TERMINAL]
│
├─ CV_BASE_MD_HRRP_NODE_S4
│  └─ HRRP_NODE [TERMINAL]
│
├─ CV_COMP_MD_SRPACT_STATIC
│  └─ TBL_WSS_SRP_ATTR_ACT [TERMINAL - Populated by STP_WSS_SRP_ATTRIBUTES]
│
├─ CV_COMP_MD_COMPFL_STATIC
│  └─ TBL_WSS_SRP_COMPFLAG [TERMINAL - Populated by STP_WSS_SRP_ATTRIBUTES]
│
├─ CV_BASE_MD_RCALWEEK_S4
│  └─ ZTFIGL_RCALWEEK [TERMINAL]
│
└─ CV_BASE_MD_CEPCT_S4
   └─ CEPCT [TERMINAL]
```

### CTE Mapping to Source Files:

| CTE Name | Source File | Original Object |
|----------|-------------|-----------------|
| Frozen_Cube | CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt | AZSRP_DS052_VT_S4 source |
| Live_Cube | CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt | AZSRP_DS041_VT_S4 source |
| Union_1 | CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt | Union of frozen/live cubes |
| Aggregated | CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt | First aggregation stage |
| CV_BASE_FIN_WEEKLY_BUDGET_S4_Final | CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt | Final aggregation with restricted measures |
| WEEKLY_SNAPSHOT_DS05 | CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Filtered budget data |
| CV_BASE_MD_HRRP_NODE_S4_Source | CV_BASE_MD_HRRP_NODE_S4_Output.txt | HRRP_NODE table source |
| HIER_NODE | CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Filtered HR hierarchy nodes |
| Join_1 | CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Budget data joined with HR hierarchy |
| ONLY_CORE_RET_DATA | CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Core retail data filter |
| CV_BASE_MD_SRPACT_S4_Source | CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt | TBL_WSS_SRP_ATTR_ACT source |
| STORE_ATTR_ACTUAL | CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Store attributes projection |
| Join_2 | CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Core retail data joined with store attributes |
| WEEK_NUMBER | CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Calendar week number calculation |
| CV_BASE_MD_COMPFL_S4_Source | CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt | TBL_WSS_SRP_COMPFLAG source |
| COMP_FLAG_BUDGET | CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Comparison flag data filtered by version |
| Join_3 | CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Week number data joined with comparison flags |
| CV_BASE_MD_RCALWEEK_S4_Source | CV_BASE_MD_RCALWEEK_S4_Output.txt | ZTFIGL_RCALWEEK source |
| CAL_WEEK | CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Calendar week mapping |
| Join_4 | CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Join with calendar week dates |
| CV_BASE_MD_CEPCT_S4_Source | CV_BASE_MD_CEPCT_S4_OUTPUT.txt | CEPCT table source |
| PROFIT_CENTER_TEXT | CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Profit center text projection |
| Join_5 | CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Join with profit center text |
| FLAGS | CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Final calculated columns and flags |

---

## Business Logic Preserved

### 1. Budget Data Selection (CV_BASE_FIN_WEEKLY_BUDGET_S4)

**Frozen vs. Live Cube Logic:**
- When `@IP_FC_COUNT != '0'`: Use Frozen Cube (AZSRP_DS052_VT_S4) with FLAG = 'FC'
- When `@IP_FC_COUNT = '0'`: Use Live Cube (AZSRP_DS041_VT_S4) with FLAG = 'LC'
- Both cubes filtered by MANDT IN ('110', '200')

**Aggregation Logic:**
- First aggregation: SUM(_B631_S_AMOUNT) and SUM(_BIC_ZIO_AMT) grouped by all dimensions including FLAG
- Second aggregation: 
  - Calculate restricted measures: RES_AMOUNT_LC and RES_AMOUNT_FC based on FLAG
  - Calculate _B631_S_AMOUNT: Use FC amount if available, otherwise use LC amount
  - Final GROUP BY excludes FLAG (aggregation grain change)

### 2. Core Retail Filter (HIER_NODE Join)

**HR Hierarchy Filter:**
- Filter HRRP_NODE for PARNODE matching 'CORE_RET$' pattern
- Filter for HRYVALTO = '99991231' (valid to date)
- Inner join on _B631_S_PROFTCTR = NODEVALUE ensures only Core Retail profit centers are included

### 3. Store Attributes Enrichment

**Store Reporting Attributes:**
- Source: TBL_WSS_SRP_ATTR_ACT (populated by STP_WSS_SRP_ATTRIBUTES procedure)
- Aggregated by all non-measure columns
- Left join on _B631_S_PROFTCTR = PRCTR
- Provides: Market codes, divisions, areas, districts, regions, store details, open dates

### 4. Comparison Flag Logic

**Comparison Flag Determination:**
- Source: TBL_WSS_SRP_COMPFLAG (populated by STP_WSS_SRP_ATTRIBUTES procedure)
- Filtered by COMP_VER = @IP_VERSION
- Left join on _B631_S_PROFTCTR = PRCTR AND _BIC_ZIO_SWEEK = ZWEEK
- Provides: FS_COMP_WK and RX_COMP_WK flags

### 5. Calendar Week Mapping

**Week Date Mapping:**
- Source: ZTFIGL_RCALWEEK table
- Filtered by RCLNT IN (120, 200)
- Left join on _BIC_ZIO_SWEEK = ZZWEEK
- Provides: ZRWSTRTDATE (week start date) and ZRWENDDATE (week end date)

### 6. Profit Center Text

**Text Description:**
- Source: CEPCT table
- Filtered by MANDT IN (120, 200)
- Left join on _B631_S_PROFTCTR = PRCTR
- Provides: LTEXT as PROFIT_CENTER_TEXT

### 7. Calculated Columns (FLAGS CTE)

**CAL_FS_RX_FLAG:**
```sql
CASE
  WHEN LEFT(CAST(_BIC_ZWWPC_PA1 AS STRING), 2) = 'FS' THEN 'FS'
  WHEN LEFT(CAST(_BIC_ZWWPC_PA1 AS STRING), 2) = 'RX' THEN 'RX'
  ELSE ''
END
```

**CAL_COMP_FLAG:**
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

**CAL_WEEK_NUMBER:**
```sql
RIGHT(CAST(_BIC_ZIO_SWEEK AS STRING), 2)
```

**_B631_S_AMOUNT (Final Calculation):**
```sql
(_B631_S_AMOUNT * -1)
```
Note: The original field is renamed to _B631_S_AMOUNT_NEGATIVE, then multiplied by -1 to produce the final _B631_S_AMOUNT

### 8. Parameter Filters

**WEEKLY_SNAPSHOT_DS05 Filters:**
- FISCVARNT = 'K4'
- _BIC_ZIO_SWEEK BETWEEN @IP_WEEK_ENDING_FROM AND @IP_WEEK_ENDING_TO
- _BIC_ZIO_VER = @IP_VERSION
- _BIC_ZIO_SAUDT IN ('1', '10')

---

## Validation Items

### REQUIRES VALIDATION: SOURCE SQL CONFLICT

**Issue:** Column name mismatch between upstream and downstream SQL

**Details:**
- **Downstream SQL:** CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt references column `_B631_S_AMOUNT_NEGATIVE`
- **Upstream SQL:** CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt produces column `_B631_S_AMOUNT`
- **Location:** FLAGS CTE in CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt

**Resolution Applied:**
The consolidated SQL preserves the exact logic from both files:
1. CV_BASE_FIN_WEEKLY_BUDGET_S4 produces `_B631_S_AMOUNT` (calculated from FC/LC amounts)
2. This column flows through joins as `_B631_S_AMOUNT`
3. In the FLAGS CTE, it is aliased/referenced as `_B631_S_AMOUNT_NEGATIVE`
4. The final calculation applies: `(_B631_S_AMOUNT_NEGATIVE * -1) AS _B631_S_AMOUNT`

This appears to be intentional business logic where the amount is negated in the final output. The consolidated SQL preserves this exact transformation without modification.

### REQUIRES VALIDATION: UNRESOLVED STORED PROCEDURE DEPENDENCIES

**Issue:** Stored procedure references calculation views not provided in supplied SQL files

**Details:**
- **Stored Procedure:** STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt
- **Missing Dependencies:**
  - CV_BASE_MD_SRPACT_S4 (referenced in INSERT to TBL_WSS_SRP_ATTR_ACT)
  - CV_BASE_MD_COMPFL_S4 (referenced in INSERT to TBL_WSS_SRP_COMPFLAG)
- **Impact:** Cannot fully expand the stored procedure logic

**Resolution Applied:**
Per the RELATIONSHIP PRIORITY RULE, "Data Population via INSERT" takes precedence over "Data Source". However, since the stored procedure references calculation views that are not provided, we cannot recursively expand the procedure. Instead:
1. We treat TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG as terminal sources
2. The consolidated SQL reads directly from these tables (as the static views do)
3. The stored procedure logic is documented but not inlined

**Recommendation:**
If full end-to-end expansion is required, the following SQL files must be provided:
- CV_BASE_MD_SRPACT_S4 (calculation view definition)
- CV_BASE_MD_COMPFL_S4 (calculation view definition)

### REQUIRES VALIDATION: UNRESOLVED FUNCTION

**Issue:** Stored procedure uses external scalar function not available in BigQuery

**Details:**
- **Function:** CVS_FRIP.CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK()
- **Usage:** SET V_WEEK = (SELECT CVS_FRIP_CVS_FRIP_Composite_Master_SFN_PRIOR_FISCAL_WEEK());
- **Location:** STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt
- **Impact:** Cannot execute stored procedure without this function

**Resolution Applied:**
The function is documented as UNRESOLVED in the stored procedure SQL. Since the stored procedure is not inlined into the final consolidated SQL (due to missing upstream dependencies), this does not impact the final output.

**Recommendation:**
If the stored procedure needs to be executed, implement the SFN_PRIOR_FISCAL_WEEK function as a BigQuery UDF or provide it as a parameter.

---

## Parameters Required for Execution

The consolidated SQL requires the following parameters to be set before execution:

1. **@IP_FC_COUNT** (STRING)
   - Purpose: Determines whether to use Frozen Cube or Live Cube data
   - Values: '0' = Live Cube, any other value = Frozen Cube
   - Used in: Frozen_Cube and Live_Cube CTEs

2. **@IP_WEEK_ENDING_FROM** (STRING or DATE)
   - Purpose: Start week for budget data filter
   - Format: Should match _BIC_ZIO_SWEEK format
   - Used in: WEEKLY_SNAPSHOT_DS05 CTE

3. **@IP_WEEK_ENDING_TO** (STRING or DATE)
   - Purpose: End week for budget data filter
   - Format: Should match _BIC_ZIO_SWEEK format
   - Used in: WEEKLY_SNAPSHOT_DS05 CTE

4. **@IP_VERSION** (STRING)
   - Purpose: Version filter for budget and comparison flag data
   - Used in: WEEKLY_SNAPSHOT_DS05 and COMP_FLAG_BUDGET CTEs

---

## Physical Table Mappings Required

The following placeholders must be replaced with actual BigQuery table references:

1. **PROJECT.DATASET.AZSRP_DS052_VT_S4** - Frozen Cube budget data
2. **PROJECT.DATASET.AZSRP_DS041_VT_S4** - Live Cube budget data
3. **PROJECT.DATASET.HRRP_NODE** - HR hierarchy node data
4. **PROJECT.DATASET.TBL_WSS_SRP_ATTR_ACT** - Store reporting attributes (populated by ETL)
5. **PROJECT.DATASET.TBL_WSS_SRP_COMPFLAG** - Comparison flags (populated by ETL)
6. **PROJECT.DATASET.ZTFIGL_RCALWEEK** - Calendar week mapping
7. **PROJECT.DATASET.CEPCT** - Profit center text

---

## Join Strategy Summary

The consolidated SQL performs the following join sequence:

1. **INNER JOIN**: Budget data (WEEKLY_SNAPSHOT_DS05) with HR hierarchy (HIER_NODE)
   - Join key: _B631_S_PROFTCTR = NODEVALUE
   - Purpose: Filter to Core Retail profit centers only

2. **LEFT JOIN**: Core retail data with store attributes (STORE_ATTR_ACTUAL)
   - Join key: _B631_S_PROFTCTR = PRCTR
   - Purpose: Enrich with store reporting attributes

3. **LEFT JOIN**: Store-enriched data with comparison flags (COMP_FLAG_BUDGET)
   - Join keys: _B631_S_PROFTCTR = PRCTR AND _BIC_ZIO_SWEEK = ZWEEK
   - Purpose: Add FS/RX comparison week flags

4. **LEFT JOIN**: Flag-enriched data with calendar week (CAL_WEEK)
   - Join key: _BIC_ZIO_SWEEK = ZZWEEK
   - Purpose: Add week start/end dates

5. **LEFT JOIN**: Week-enriched data with profit center text (PROFIT_CENTER_TEXT)
   - Join key: _B631_S_PROFTCTR = PRCTR
   - Purpose: Add profit center descriptions

---

## Aggregation Grain Preservation

The consolidated SQL preserves the exact aggregation grain from the source files:

### CV_BASE_FIN_WEEKLY_BUDGET_S4 Aggregation:

**First Aggregation (Aggregated CTE):**
- GROUP BY includes FLAG
- Produces: _B631_S_AMOUNT_DUMMY, _BIC_ZIO_AMT

**Second Aggregation (CV_BASE_FIN_WEEKLY_BUDGET_S4_Final CTE):**
- GROUP BY excludes FLAG
- Produces: RES_AMOUNT_LC, RES_AMOUNT_FC, _B631_S_AMOUNT, _BIC_ZIO_AMT
- This aggregation grain change is intentional and preserved exactly as in the source

### CV_COMP_MD_SRPACT_STATIC Aggregation:

**Single Aggregation (CV_BASE_MD_SRPACT_S4_Source CTE):**
- GROUP BY all non-measure columns
- Aggregates: RX_HRS_OPER, FS_HRS_OPER, RX_STORE, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT

---

## Completeness Verification

### All SQL Logic Included:
✅ All joins from CV_COMP_FIN_BUDGET_STATIC
✅ All filters from all source views
✅ All calculated columns (CAL_FS_RX_FLAG, CAL_COMP_FLAG, CAL_WEEK_NUMBER, _B631_S_AMOUNT)
✅ All aggregations from CV_BASE_FIN_WEEKLY_BUDGET_S4
✅ All UNION logic (Frozen_Cube UNION ALL Live_Cube)
✅ All CASE expressions
✅ All parameter filters
✅ All data type conversions (CAST operations)
✅ All business rules (FC/LC selection, flag determination, amount negation)

### No Placeholders:
✅ No <CTE_NAME> placeholders
✅ No <TABLE_NAME> placeholders
✅ No <COLUMN_NAME> placeholders
✅ No "for brevity" statements
✅ No "logic omitted" statements
✅ No ellipsis (...)
✅ No unresolved view references (all views inlined)

### Execution Readiness:
✅ Single executable SQL statement
✅ Starts with WITH clause
✅ Ends with SELECT * FROM FLAGS
✅ Can be copied and pasted directly into BigQuery (after parameter and table mapping)

---

## Summary

This consolidation successfully produces a complete, execution-ready BigQuery SQL implementation for CV_COMP_FIN_BUDGET_STATIC by:

1. ✅ Recursively expanding all 6 dependent calculation views
2. ✅ Preserving all business logic, joins, filters, and calculations
3. ✅ Maintaining exact aggregation grain from source files
4. ✅ Resolving all dependencies to physical tables
5. ✅ Documenting validation items for unresolved dependencies
6. ✅ Providing complete traceability from source files to final SQL

The consolidated SQL is fully expanded with no intermediate view dependencies remaining. All required logic has been inlined, and the query can be executed directly in BigQuery once parameters and table mappings are provided.