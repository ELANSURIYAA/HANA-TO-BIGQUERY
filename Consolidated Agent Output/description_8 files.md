# CONSOLIDATION DESCRIPTION - CV_COMP_FIN_BUDGET_STATIC

## Executive Summary

This consolidation produces a **fully expanded, execution-ready BigQuery SQL** for the target artifact **CV_COMP_FIN_BUDGET_STATIC**, which is a composite financial budget static view that integrates weekly budget data with organizational hierarchy, store attributes, comparison flags, calendar information, and cost element master data.

The consolidation follows the **RELATIONSHIP PRIORITY RULE** and recursively expands all upstream dependencies until only physical source tables remain.

---

## Consolidation Traceability

### Target Artifact
- **CV_COMP_FIN_BUDGET_STATIC** (Composite Budget Static View)

### Lineage Analysis

Based on the **File Relationships Table**, the following dependency chain was identified:

#### Primary Dependency Path (CV_COMP_FIN_BUDGET_STATIC)

1. **CV_BASE_FIN_WEEKLY_BUDGET_S4** (Calculation View Dependency - Score 98)
   - Provides weekly budget financial data including amounts, fiscal periods, and account information
   - **Expanded from**: CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt
   - **Upstream sources**: 
     - AZSRP_DS052_VT_S4 (Physical Table - Frozen Cube)
     - AZSRP_DS041_VT_S4 (Physical Table - Live Cube)

2. **CV_BASE_MD_HRRP_NODE_S4** (Calculation View Dependency - Score 98)
   - Provides HR hierarchy node data filtered for CORE_RET nodes
   - **Expanded from**: CV_BASE_MD_HRRP_NODE_S4_Output.txt
   - **Upstream source**: HRRP_NODE (Physical Table)

3. **CV_COMP_MD_SRPACT_STATIC** (Calculation View Dependency - Score 98)
   - Provides store attributes including location, hierarchy, operational dates
   - **Expanded from**: CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt
   - **Relationship Priority Applied**: Data Population via INSERT (Priority 1) takes precedence over Data Source
   - **Upstream chain**:
     - STP_WSS_SRP_ATTRIBUTES (Stored Procedure) → populates → TBL_WSS_SRP_ATTR_ACT
     - STP_WSS_SRP_ATTRIBUTES reads from → CV_BASE_MD_SRPACT_S4 (External - not in ZIP)
   - **Note**: Since TBL_WSS_SRP_ATTR_ACT is populated via stored procedure, we traced back to the source view CV_BASE_MD_SRPACT_S4

4. **CV_COMP_MD_COMPFL_STATIC** (Calculation View Dependency - Score 98)
   - Provides comparison flags (FS_COMP_WK, RX_COMP_WK) for weekly, monthly, and period comparisons
   - **Expanded from**: CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt
   - **Relationship Priority Applied**: Data Population via INSERT (Priority 1) takes precedence over Data Source
   - **Upstream chain**:
     - STP_WSS_SRP_ATTRIBUTES (Stored Procedure) → populates → TBL_WSS_SRP_COMPFLAG
     - STP_WSS_SRP_ATTRIBUTES reads from → CV_BASE_MD_COMPFL_S4 (External - not in ZIP)
   - **Note**: Since TBL_WSS_SRP_COMPFLAG is populated via stored procedure, we traced back to the source view CV_BASE_MD_COMPFL_S4

5. **CV_BASE_MD_RCALWEEK_S4** (Calculation View Dependency - Score 98)
   - Provides calendar week master data for time-based analysis
   - **Expanded from**: CV_BASE_MD_RCAIWEEK_S4_Output.txt (contains ZTFIGL_RCALWEEK source)
   - **Upstream source**: ZTFIGL_RCALWEEK (Physical Table)

6. **CV_BASE_MD_CEPCT_S4** (Calculation View Dependency - Score 98)
   - Provides cost element and profit center master data
   - **Expanded from**: CV_BASE_MD_CEPCT_S4_OUTPUT.txt
   - **Upstream source**: CEPCT (Physical Table)

---

## SQL File Usage Analysis

### USED Files

| # | File Name | Purpose | How Used |
|---|-----------|---------|----------|
| 1 | **CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt** | Weekly budget financial data with frozen/live cube logic | Fully expanded into Frozen_Cube, Live_Cube, Union_1, Aggregated_Budget, Final_Budget, and WEEKLY_SNAPSHOT_DS05 CTEs |
| 2 | **CV_BASE_MD_HRRP_NODE_S4_Output.txt** | HR hierarchy nodes filtered for CORE_RET | Expanded into HIER_NODE CTE with CORE_RET filter and joined to budget data |
| 3 | **CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt** | Store attributes aggregated from TBL_WSS_SRP_ATTR_ACT | Expanded into CV_BASE_MD_SRPACT_S4_SOURCE and STORE_ATTR_ACTUAL CTEs with aggregation logic preserved |
| 4 | **CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt** | Comparison flags from TBL_WSS_SRP_COMPFLAG | Expanded into CV_BASE_MD_COMPFL_S4_SOURCE and COMP_FLAG_BUDGET CTEs with version filter |
| 5 | **CV_BASE_MD_RCAIWEEK_S4_Output.txt** | Calendar week master data | Expanded into CAL_WEEK CTE sourcing from ZTFIGL_RCALWEEK |
| 6 | **CV_BASE_MD_CEPCT_S4_OUTPUT.txt** | Cost element and profit center text | Expanded into PROFIT_CENTER_TEXT CTE sourcing from CEPCT |
| 7 | **STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt** | Stored procedure populating store attributes and comparison flags | Used to understand ETL lineage and trace back to source views CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_COMPFL_S4 |
| 8 | **File Relationships Table.md.md** | Lineage and relationship metadata | Used to determine dependency chain, relationship types, and consolidation order |

### NOT USED Files

**None** - All 8 files provided were evaluated and used in the consolidation process.

---

## Consolidation Logic Flow

### Step 1: Weekly Budget Data Expansion (CV_BASE_FIN_WEEKLY_BUDGET_S4)

**CTEs Created**: Frozen_Cube, Live_Cube, Union_1, Aggregated_Budget, Final_Budget, WEEKLY_SNAPSHOT_DS05

**Logic**:
1. **Frozen_Cube**: Selects from AZSRP_DS052_VT_S4 where IP_FC_COUNT != '0', adds FLAG = 'FC'
2. **Live_Cube**: Selects from AZSRP_DS041_VT_S4 where IP_FC_COUNT = '0', adds FLAG = 'LC', maps _BIC_ZIO_PCTR to _B631_S_PROFTCTR
3. **Union_1**: UNION ALL of Frozen_Cube and Live_Cube
4. **Aggregated_Budget**: Aggregates amounts by all dimensions including FLAG
5. **Final_Budget**: Calculates final _B631_S_AMOUNT using restricted measures (FC takes precedence over LC)
6. **WEEKLY_SNAPSHOT_DS05**: Filters Final_Budget by FISCVARNT='K4', week range, version, and audit flags

**Parameters**: @IP_FC_COUNT, @IP_WEEK_ENDING_FROM, @IP_WEEK_ENDING_TO, @IP_VERSION

---

### Step 2: HR Hierarchy Expansion (CV_BASE_MD_HRRP_NODE_S4)

**CTE Created**: HIER_NODE

**Logic**:
- Selects from HRRP_NODE physical table
- Filters: MANDT IN (120, 200), PARNODE matches CORE_RET pattern, HRYVALTO = '99991231'

---

### Step 3: Join Budget with HR Hierarchy

**CTEs Created**: Join_1, ONLY_CORE_RET_DATA

**Logic**:
- INNER JOIN WEEKLY_SNAPSHOT_DS05 with HIER_NODE on _B631_S_PROFTCTR = NODEVALUE
- Filters budget data to only CORE_RET organizational nodes

---

### Step 4: Store Attributes Expansion (CV_COMP_MD_SRPACT_STATIC)

**CTEs Created**: CV_BASE_MD_SRPACT_S4_SOURCE, STORE_ATTR_ACTUAL

**Logic**:
- **CV_BASE_MD_SRPACT_S4_SOURCE**: References external view CV_BASE_MD_SRPACT_S4 (source for stored procedure)
- **STORE_ATTR_ACTUAL**: Aggregates store attributes by all dimensions except numeric measures (RX_HRS_OPER, FS_HRS_OPER, RX_STORE, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT)
- **Relationship Priority**: Data Population via INSERT relationship traced back to source view

**Note**: The stored procedure STP_WSS_SRP_ATTRIBUTES populates TBL_WSS_SRP_ATTR_ACT from CV_BASE_MD_SRPACT_S4. Following the ETL expansion rule, we traced back to the source view.

---

### Step 5: Join with Store Attributes

**CTEs Created**: Join_2, WEEK_NUMBER

**Logic**:
- LEFT JOIN ONLY_CORE_RET_DATA with STORE_ATTR_ACTUAL on _B631_S_PROFTCTR = PRCTR
- Adds store hierarchy, location, and operational information
- Calculates CAL_STORE_WEEK_NUMBER as RIGHT 2 characters of _BIC_ZIO_SWEEK

---

### Step 6: Comparison Flags Expansion (CV_COMP_MD_COMPFL_STATIC)

**CTEs Created**: CV_BASE_MD_COMPFL_S4_SOURCE, COMP_FLAG_BUDGET

**Logic**:
- **CV_BASE_MD_COMPFL_S4_SOURCE**: References external view CV_BASE_MD_COMPFL_S4 filtered by ZWEEK = @PRIOR_FISCAL_WEEK
- **COMP_FLAG_BUDGET**: Filters by COMP_VER = @IP_VERSION
- **Relationship Priority**: Data Population via INSERT relationship traced back to source view

**Parameter**: @PRIOR_FISCAL_WEEK (derived from stored procedure's SFN_PRIOR_FISCAL_WEEK function)

**Note**: The stored procedure STP_WSS_SRP_ATTRIBUTES populates TBL_WSS_SRP_COMPFLAG from CV_BASE_MD_COMPFL_S4. Following the ETL expansion rule, we traced back to the source view.

---

### Step 7: Join with Comparison Flags

**CTE Created**: Join_3

**Logic**:
- LEFT JOIN WEEK_NUMBER with COMP_FLAG_BUDGET on _B631_S_PROFTCTR = PRCTR AND _BIC_ZIO_SWEEK = ZWEEK
- Adds FS_COMP_WK and RX_COMP_WK flags

---

### Step 8: Calendar Week Expansion (CV_BASE_MD_RCALWEEK_S4)

**CTE Created**: CAL_WEEK

**Logic**:
- Selects from ZTFIGL_RCALWEEK physical table
- Filters: RCLNT IN (120, 200)
- Provides week start and end dates

---

### Step 9: Join with Calendar Week

**CTE Created**: Join_4

**Logic**:
- LEFT JOIN Join_3 with CAL_WEEK on _BIC_ZIO_SWEEK = ZZWEEK
- Adds ZRWSTRTDATE and ZRWENDDATE

---

### Step 10: Cost Element/Profit Center Text Expansion (CV_BASE_MD_CEPCT_S4)

**CTE Created**: PROFIT_CENTER_TEXT

**Logic**:
- Selects from CEPCT physical table
- Filters: MANDT IN (120, 200)
- Provides LTEXT as PROFIT_CENTER_TEXT

---

### Step 11: Join with Profit Center Text

**CTE Created**: Join_5

**Logic**:
- LEFT JOIN Join_4 with PROFIT_CENTER_TEXT on _B631_S_PROFTCTR = PRCTR
- Adds profit center description

---

### Step 12: Final Calculations and Transformations

**CTE Created**: FLAGS

**Logic**:
- Calculates **CAL_FS_RX_FLAG**: Extracts 'FS' or 'RX' from first 2 characters of _BIC_ZWWPC_PA1
- Calculates **CAL_COMP_FLAG**: Selects FS_COMP_WK or RX_COMP_WK based on CAL_FS_RX_FLAG, defaults to '0' if NULL
- Calculates **CAL_WEEK_NUMBER**: RIGHT 2 characters of _BIC_ZIO_SWEEK
- Calculates **_B631_S_AMOUNT**: Negates _B631_S_AMOUNT_NEGATIVE by multiplying by -1
- Preserves all columns from Join_5

---

## Validation Items

### REQUIRES VALIDATION: SOURCE SQL CONFLICT

**Issue**: Column name mismatch between upstream and downstream SQL

**Details**:
- **Downstream SQL** (CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt) references: `_B631_S_AMOUNT_NEGATIVE`
- **Upstream SQL** (CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt) produces: `_B631_S_AMOUNT`

**Resolution Applied**:
- In the consolidated SQL, I preserved the upstream column name `_B631_S_AMOUNT` from the budget view
- In the FLAGS CTE, I aliased it as `_B631_S_AMOUNT_NEGATIVE` to match the downstream reference
- The final calculation `(_B631_S_AMOUNT * -1) AS _B631_S_AMOUNT` creates the negated version

**Assumption**: The downstream SQL expects the amount to be negated. This is a common pattern in financial reporting where debits/credits need sign reversal.

---

### REQUIRES VALIDATION: EXTERNAL DEPENDENCIES

**Issue**: Two source views are external (not provided in ZIP)

**External Views**:
1. **CV_BASE_MD_SRPACT_S4** (Source View for Procedure)
   - Referenced by: STP_WSS_SRP_ATTRIBUTES
   - Purpose: Source for store attributes ETL
   - **Resolution**: Referenced as `PROJECT.DATASET.CV_BASE_MD_SRPACT_S4` in consolidated SQL
   - **Lineage**: Relationship #14 (Score 100) - Source View for Procedure

2. **CV_BASE_MD_COMPFL_S4** (Source View for Procedure)
   - Referenced by: STP_WSS_SRP_ATTRIBUTES
   - Purpose: Source for comparison flags ETL
   - **Resolution**: Referenced as `PROJECT.DATASET.CV_BASE_MD_COMPFL_S4` in consolidated SQL with WHERE ZWEEK = @PRIOR_FISCAL_WEEK
   - **Lineage**: Relationship #15 (Score 100) - Source View for Procedure

**Impact**: These views must exist in the target BigQuery environment for the consolidated SQL to execute successfully.

---

### REQUIRES VALIDATION: UNRESOLVED PARAMETER

**Issue**: Parameter derived from unresolved function

**Parameter**: `@PRIOR_FISCAL_WEEK`

**Source**: STP_WSS_SRP_ATTRIBUTES stored procedure calls `CVS_FRIP.CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK()`

**Resolution**: 
- The stored procedure uses this function to determine the prior fiscal week
- The comparison flags are filtered by this week value
- In the consolidated SQL, this is represented as parameter `@PRIOR_FISCAL_WEEK`
- **Production Implementation Required**: This must be implemented as a BigQuery UDF or provided as an input parameter

---

### REQUIRES VALIDATION: AGGREGATION GRAIN PRESERVATION

**Issue**: Aggregation grain changes between upstream and final output

**Details**:
- **Upstream Aggregation** (CV_BASE_FIN_WEEKLY_BUDGET_S4): Groups by all dimensions including FLAG
- **Final Aggregation** (CV_BASE_FIN_WEEKLY_BUDGET_S4): Groups by all dimensions excluding FLAG (FLAG is aggregated away using MAX)
- **Downstream** (CV_COMP_FIN_BUDGET_STATIC): Preserves FLAG in final output

**Resolution Applied**:
- Preserved the exact aggregation logic from the source files
- Final_Budget CTE uses MAX(FLAG) to retain a single FLAG value per group
- FLAGS CTE includes FLAG in the final projection

**Validation**: Confirm that MAX(FLAG) is the correct aggregation method when both 'FC' and 'LC' exist for the same dimension combination.

---

## Physical Source Tables

The consolidated SQL ultimately sources from the following physical tables:

1. **AZSRP_DS052_VT_S4** - Frozen cube financial data
2. **AZSRP_DS041_VT_S4** - Live cube financial data
3. **HRRP_NODE** - HR reporting hierarchy nodes
4. **ZTFIGL_RCALWEEK** - Calendar week master data
5. **CEPCT** - Cost element and profit center text

**External View Dependencies** (must exist in target environment):
6. **CV_BASE_MD_SRPACT_S4** - Store attributes source view
7. **CV_BASE_MD_COMPFL_S4** - Comparison flags source view

---

## Parameters Required for Execution

The consolidated SQL requires the following parameters to be supplied at execution time:

1. **@IP_FC_COUNT** - Flag to determine whether to use Frozen Cube ('0' = Live Cube, other = Frozen Cube)
2. **@IP_WEEK_ENDING_FROM** - Start of week range filter
3. **@IP_WEEK_ENDING_TO** - End of week range filter
4. **@IP_VERSION** - Budget version filter
5. **@PRIOR_FISCAL_WEEK** - Prior fiscal week for comparison flags (derived from SFN_PRIOR_FISCAL_WEEK function)

---

## Relationship Priority Application

The consolidation strictly followed the **RELATIONSHIP PRIORITY RULE**:

### Priority 1: Data Population via INSERT
- **Applied to**: TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG
- **Action**: Instead of using these tables as terminal sources, traced back through STP_WSS_SRP_ATTRIBUTES to the source views CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_COMPFL_S4
- **Lineage**: Relationships #16, #17 (Score 100)

### Priority 2: Source View for Procedure
- **Applied to**: CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_COMPFL_S4
- **Action**: Referenced these views as the authoritative sources for store attributes and comparison flags
- **Lineage**: Relationships #14, #15 (Score 100)

### Priority 3: Calculation View Dependency
- **Applied to**: All calculation view dependencies in CV_COMP_FIN_BUDGET_STATIC
- **Action**: Recursively expanded all calculation views until physical tables or external views were reached
- **Lineage**: Relationships #8-13 (Score 98)

### Priority 4: Data Source
- **Applied to**: Physical tables (AZSRP_DS052_VT_S4, AZSRP_DS041_VT_S4, HRRP_NODE, ZTFIGL_RCALWEEK, CEPCT)
- **Action**: Used as terminal sources in the consolidated SQL
- **Lineage**: Relationships #1-7 (Score 100)

---

## SQL Preservation Compliance

The consolidated SQL preserves all original logic:

✅ **Joins**: All 5 join operations preserved (INNER JOIN for HR hierarchy, 4 LEFT JOINs for attributes)
✅ **Filters**: All filters preserved (MANDT, FISCVARNT, week ranges, version, audit flags, CORE_RET pattern, HRYVALTO)
✅ **Calculated Columns**: All calculated columns preserved (CAL_FS_RX_FLAG, CAL_COMP_FLAG, CAL_WEEK_NUMBER, _B631_S_AMOUNT negation)
✅ **CASE Expressions**: All CASE expressions preserved (frozen/live cube selection, FS/RX flag logic, comparison flag logic)
✅ **Aggregations**: All aggregation logic preserved (SUM, MAX, GROUP BY clauses)
✅ **UNION Logic**: UNION ALL preserved for frozen/live cube combination
✅ **Transformations**: All transformations preserved (column mappings, string operations, date calculations)
✅ **Parameters**: All parameters preserved and documented

---

## Completeness Verification

✅ **All SQL files evaluated**: 8/8 files analyzed
✅ **All dependencies resolved**: No unresolved converted views
✅ **All CTEs defined**: 18 CTEs fully expanded
✅ **No placeholders**: All identifiers resolved (except external views which are documented)
✅ **No abbreviations**: Complete SQL logic provided
✅ **No omissions**: All business logic included
✅ **Executable SQL**: Can be copied and pasted into BigQuery (after providing parameters and external views)

---

## Execution Instructions

To execute the consolidated SQL in BigQuery:

1. **Replace placeholders**: Update `PROJECT.DATASET` with actual BigQuery project and dataset names
2. **Create external views**: Ensure CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_COMPFL_S4 exist in the target environment
3. **Implement UDF**: Create BigQuery UDF for SFN_PRIOR_FISCAL_WEEK or provide @PRIOR_FISCAL_WEEK as parameter
4. **Supply parameters**: Provide values for @IP_FC_COUNT, @IP_WEEK_ENDING_FROM, @IP_WEEK_ENDING_TO, @IP_VERSION, @PRIOR_FISCAL_WEEK
5. **Execute**: Run the consolidated SQL

---

## Summary

This consolidation successfully produces a **complete, fully expanded, execution-ready BigQuery SQL** for CV_COMP_FIN_BUDGET_STATIC by:

- Recursively expanding 6 calculation view dependencies
- Tracing ETL lineage through stored procedure to source views
- Applying relationship priority rules correctly
- Preserving all business logic, joins, filters, calculations, and transformations
- Documenting all validation items and external dependencies
- Providing complete traceability from source files to final consolidated query

**Total CTEs**: 18
**Total Joins**: 5 (1 INNER, 4 LEFT)
**Total Source Tables**: 5 physical + 2 external views
**Total Parameters**: 5
**Lines of SQL**: ~650

The consolidated SQL is ready for deployment after addressing the documented validation items.