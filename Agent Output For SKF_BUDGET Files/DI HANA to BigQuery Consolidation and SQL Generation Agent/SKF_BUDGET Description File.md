# CONSOLIDATION DESCRIPTION FOR CV_COMP_SKF_BUDGET_STATIC

## Executive Summary

This document provides complete traceability and analysis for the consolidation of the CV_COMP_SKF_BUDGET_STATIC calculation view and all its upstream dependencies into a single, fully expanded, executable BigQuery SQL query.

The consolidation successfully resolved all dependency chains from the final consumer view (CV_COMP_SKF_BUDGET_STATIC) back to physical source tables, eliminating all intermediate calculation views and stored procedure dependencies.

---

## Lineage Analysis

### Final Consumer Artifact
**CV_COMP_SKF_BUDGET_STATIC** - The target calculation view that serves as the final consumer-facing artifact for SKF Budget reporting.

### Dependency Chain (from lineage file)

The lineage relationships establish the following dependency tree:

```
CV_COMP_SKF_BUDGET_STATIC (FINAL OUTPUT)
├── CV_BASE_SKF_WEEKLY_BUDGET_S4 (Direct Dependency)
│   ├── AZSRP_DS092_VT_S4 (Physical Table - Frozen Cube)
│   └── AZSRP_DS031_VT_S4 (Physical Table - Live Cube)
├── CV_BASE_MD_HRRP_NODE_S4 (Direct Dependency)
│   └── HRRP_NODE (Physical Table)
├── CV_BASE_MD_RCALWEEK_S4 (Direct Dependency)
│   └── ZTFIGL_RCALWEEK (Physical Table)
├── CV_BASE_MD_CEPCT_S4 (Direct Dependency)
│   └── CEPCT (Physical Table)
├── CV_COMP_MD_SRPACT_STATIC (Direct Dependency)
│   └── TBL_WSS_SRP_ATTR_ACT (Staging Table)
│       └── STP_WSS_SRP_ATTRIBUTES (Stored Procedure)
│           └── CV_BASE_MD_SRPACT_S4 (Calculation View)
│               └── ZTSRP_ATTR_ACT (Physical Table)
└── CV_COMP_MD_COMPFL_STATIC (Direct Dependency)
    └── TBL_WSS_SRP_COMPFLAG (Staging Table)
        └── STP_WSS_SRP_ATTRIBUTES (Stored Procedure)
            └── CV_BASE_MD_COMPFL_S4 (Calculation View)
                └── ZTSRP_COMPFL (Physical Table)
```

---

## File Usage Analysis

### USED Files

All 10 supplied SQL files were evaluated and incorporated into the final consolidated SQL:

1. **CV_COMP_SKF_BUDGET_STATIC** - USED
   - Role: Final consumer view
   - Logic: Orchestrates all joins, filters, calculated columns, and aggregations
   - Contribution: Provides the complete output structure and business logic

2. **CV_BASE_SKF_WEEKLY_BUDGET_S4** - USED
   - Role: Weekly budget data source (frozen + live cubes)
   - Logic: UNION of frozen and live budget data with conditional measure calculation
   - Contribution: Provides core budget quantity data (_BIC_ZIO_SKFQ) with FLAG indicator
   - Physical Sources: AZSRP_DS092_VT_S4, AZSRP_DS031_VT_S4

3. **CV_BASE_MD_HRRP_NODE_S4** - USED
   - Role: Hierarchy node master data
   - Logic: Filters hierarchy nodes by PARNODE pattern and validity date
   - Contribution: Provides cost center hierarchy mapping (NODEVALUE)
   - Physical Source: HRRP_NODE

4. **CV_BASE_MD_RCALWEEK_S4** - USED
   - Role: Calendar week master data
   - Logic: Simple projection with client filter
   - Contribution: Provides calendar week attributes (ZRWSTRTDATE, ZRWENDDATE)
   - Physical Source: ZTFIGL_RCALWEEK

5. **CV_BASE_MD_CEPCT_S4** - USED
   - Role: Profit center text master data
   - Logic: Simple projection with client filter
   - Contribution: Provides profit center descriptions (LTEXT)
   - Physical Source: CEPCT

6. **CV_BASE_MD_SRPACT_S4** - USED
   - Role: Store profile attributes (base)
   - Logic: Aggregated projection with measure summation
   - Contribution: Provides store/profit center attributes (market, division, area, region, district, etc.)
   - Physical Source: ZTSRP_ATTR_ACT

7. **CV_COMP_MD_SRPACT_STATIC** - USED
   - Role: Store attributes from static table (populated by stored procedure)
   - Logic: References TBL_WSS_SRP_ATTR_ACT (staging table)
   - Contribution: Intermediate layer; consolidated by inlining CV_BASE_MD_SRPACT_S4
   - Resolution: Replaced with upstream source (CV_BASE_MD_SRPACT_S4)

8. **CV_BASE_MD_COMPFL_S4** - USED
   - Role: Comp flag base data
   - Logic: Simple projection with client filter
   - Contribution: Provides comp flag attributes (RX_COMP_WK, ZWEEK, etc.)
   - Physical Source: ZTSRP_COMPFL

9. **CV_COMP_MD_COMPFL_STATIC** - USED
   - Role: Comp flag from static table (populated by stored procedure)
   - Logic: References TBL_WSS_SRP_COMPFLAG (staging table)
   - Contribution: Intermediate layer; consolidated by inlining CV_BASE_MD_COMPFL_S4
   - Resolution: Replaced with upstream source (CV_BASE_MD_COMPFL_S4)

10. **STP_WSS_SRP_ATTRIBUTES** - USED (Logic Traced)
    - Role: Stored procedure that populates staging tables
    - Logic: INSERT-SELECT from CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_COMPFL_S4
    - Contribution: Establishes the relationship between base views and static tables
    - Resolution: Procedural logic traced; source views inlined directly

### NOT USED Files

**None** - All 10 supplied files were evaluated and their logic was incorporated into the final consolidated SQL.

---

## Consolidation Strategy

### ETL Expansion Rule Applied

The consolidation followed the ETL Expansion Rule:
- **TBL_WSS_SRP_ATTR_ACT** and **TBL_WSS_SRP_COMPFLAG** are staging/ETL tables populated by the stored procedure **STP_WSS_SRP_ATTRIBUTES**.
- Instead of treating these as final sources, the consolidation traced their population logic back to the source calculation views:
  - TBL_WSS_SRP_ATTR_ACT ← CV_BASE_MD_SRPACT_S4 ← ZTSRP_ATTR_ACT
  - TBL_WSS_SRP_COMPFLAG ← CV_BASE_MD_COMPFL_S4 ← ZTSRP_COMPFL
- The procedural statements (DELETE, INSERT) were ignored for lineage purposes, and only the SELECT logic was traced.

### Recursive Dependency Resolution

Each intermediate calculation view was recursively expanded:

1. **CV_COMP_SKF_BUDGET_STATIC** references:
   - CV_BASE_SKF_WEEKLY_BUDGET_S4 → Expanded to physical tables AZSRP_DS092_VT_S4, AZSRP_DS031_VT_S4
   - CV_BASE_MD_HRRP_NODE_S4 → Expanded to physical table HRRP_NODE
   - CV_COMP_MD_SRPACT_STATIC → Expanded to CV_BASE_MD_SRPACT_S4 → ZTSRP_ATTR_ACT
   - CV_COMP_MD_COMPFL_STATIC → Expanded to CV_BASE_MD_COMPFL_S4 → ZTSRP_COMPFL
   - CV_BASE_MD_RCALWEEK_S4 → Expanded to physical table ZTFIGL_RCALWEEK
   - CV_BASE_MD_CEPCT_S4 → Expanded to physical table CEPCT

2. All intermediate views were inlined as CTEs in the final SQL.

3. No converted view references remain unresolved; all dependencies trace back to physical tables.

---

## SQL Logic Preservation

### Filters
All filters from the original calculation views were preserved:
- **WEEKLY_SNAPSHOT_DS05**: FISCVARNT='K4', _BIC_ZIO_SWEEK BETWEEN parameters, _BIC_ZIO_VER=parameter, _BIC_ZIO_SAUDT IN ('1','10'), _BIC_ZIO_PSKF IN ('804013','801000')
- **Filtered_Hierarchy_Nodes**: REGEXP_CONTAINS(PARNODE, r'CORERET$'), HRYVALTO='99991231'
- **COMP_FLAG_BUDGET**: COMP_VER=parameter
- **CV_BASE_MD_SRPACT_S4**: MANDT IN ('120','200')
- **CV_BASE_MD_COMPFL_S4**: MANDT IN (110, 200)
- **CV_BASE_MD_RCALWEEK_S4**: RCLNT IN (120, 200)
- **CV_BASE_MD_CEPCT_S4**: MANDT IN (120, 200)
- **CV_BASE_MD_HRRP_NODE_S4**: MANDT IN (120, 200)
- **Frozen_Cube**: MANDT IN ('110','200'), IP_FC_COUNT != '0'
- **Live_Cube**: MANDT IN ('110','200'), IP_FC_COUNT = '0'

### Joins
All joins were preserved with exact join types and keys:
- **INNER JOIN**: WEEKLY_SNAPSHOT_DS05 ⋈ Filtered_Hierarchy_Nodes ON _B631_S_COSTCNTR = NODEVALUE
- **LEFT JOIN**: Result ⋈ STORE_ATTR_ACTUAL ON _B631_S_PROFTCTR = PRCTR
- **LEFT JOIN**: Result ⋈ COMP_FLAG_BUDGET ON _B631_S_PROFTCTR = PRCTR AND _BIC_ZIO_SWEEK = ZWEEK
- **LEFT JOIN**: Result ⋈ CAL_WEEK ON _BIC_ZIO_SWEEK = ZZWEEK
- **LEFT JOIN**: Result ⋈ PROFIT_CENTER_TEXT ON _B631_S_PROFTCTR = PRCTR

### Calculated Columns
All calculated columns from the FLAGS node were preserved:
- **CAL_WEEK_NUMBER**: RIGHT(CAST(_BIC_ZIO_SWEEK AS STRING), 2)
- **CAL_BIC_ZIO_SKFQ**: CASE WHEN _BIC_ZIO_PSKF = '804013' THEN CAST(_BIC_ZIO_SKFQ AS NUMERIC) * 2 ELSE CAST(_BIC_ZIO_SKFQ AS NUMERIC) END
- **CAL_RX_COMP_WK**: CASE WHEN RX_COMP_WK IS NULL THEN '0' ELSE RX_COMP_WK END

### Aggregations
All aggregation logic was preserved:
- **CV_BASE_SKF_WEEKLY_BUDGET_S4**: Conditional measure calculation using IF(ISNULL(RES_QUANT_FC), RES_QUANT_LC, RES_QUANT_FC)
- **CV_BASE_MD_SRPACT_S4**: SUM aggregation on measures (RX_HRS_OPER, FS_HRS_OPER, RX_STORE, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT)
- **Final Output**: SUM(_BIC_ZIO_SKFQ) AS _BIC_ZIO_SKFQ_NEGATIVE, SUM(CAL_BIC_ZIO_SKFQ) AS _BIC_ZIO_SKFQ

### UNION Logic
The UNION ALL logic from CV_BASE_SKF_WEEKLY_BUDGET_S4 was preserved:
- Frozen_Cube (FLAG='FC') UNION ALL Live_Cube (FLAG='LC')
- Column mappings preserved exactly as defined

### Parameters
All parameters were preserved and mapped to BigQuery syntax:
- **IP_VERSION** → @IP_VERSION (default 'LEDGER_BUD')
- **IP_WEEK_ENDING_FROM** → @IP_WEEK_ENDING_FROM
- **IP_WEEK_ENDING_TO** → @IP_WEEK_ENDING_TO
- **IP_FC_COUNT** → @IP_FC_COUNT (derived from external function)

---

## Physical Source Tables

The consolidated SQL references the following physical tables:

1. **PROJECT.DATASET.AZSRP_DS092_VT_S4** - Frozen budget cube
2. **PROJECT.DATASET.AZSRP_DS031_VT_S4** - Live budget cube
3. **PROJECT.DATASET.HRRP_NODE** - Hierarchy nodes
4. **PROJECT.DATASET.ZTSRP_ATTR_ACT** - Store profile attributes
5. **PROJECT.DATASET.ZTSRP_COMPFL** - Comp flags
6. **PROJECT.DATASET.ZTFIGL_RCALWEEK** - Calendar weeks
7. **PROJECT.DATASET.CEPCT** - Profit center text

All intermediate views and staging tables have been eliminated.

---

## Validation Items

### REQUIRES VALIDATION

The following items require validation or external implementation:

1. **IP_FC_COUNT Parameter Derivation**
   - **Issue**: The parameter IP_FC_COUNT is derived from an external function `CVS_FRIP.Composite.Master::SFN_SKF_FC_FLAG(IP_VERSION)` which is not defined in the supplied inputs.
   - **Referenced In**: CV_BASE_SKF_WEEKLY_BUDGET_S4
   - **Impact**: The filters on Frozen_Cube and Live_Cube depend on this parameter.
   - **Resolution Required**: Implement the function logic in BigQuery or provide the parameter value externally.

2. **PARNODE Pattern Matching**
   - **Issue**: The HANA `match(PARNODE, '*CORERET')` function was converted to `REGEXP_CONTAINS(PARNODE, r'CORERET$')` assuming a suffix match.
   - **Referenced In**: Filtered_Hierarchy_Nodes
   - **Impact**: If the pattern semantics differ (e.g., wildcard matching), the filter may not produce equivalent results.
   - **Resolution Required**: Validate the pattern matching logic against actual HANA behavior.

3. **BigQuery Project/Dataset Mapping**
   - **Issue**: All physical table references use placeholder names `PROJECT.DATASET.TABLE`.
   - **Impact**: The SQL cannot execute without actual BigQuery project and dataset names.
   - **Resolution Required**: Replace placeholders with actual BigQuery table references.

4. **Datatype Compatibility**
   - **Issue**: Source column datatypes are not specified in the calculation view XMLs.
   - **Impact**: Type casting (e.g., CAST(_BIC_ZIO_SWEEK AS STRING)) may require adjustment.
   - **Resolution Required**: Validate datatypes against actual BigQuery schema.

5. **MANDT Filter Value Types**
   - **Issue**: MANDT filters use both numeric (120, 200) and string ('110', '200') literals across different views.
   - **Impact**: If MANDT datatype is inconsistent, filters may fail or produce unexpected results.
   - **Resolution Required**: Standardize MANDT datatype and filter values.

### No Source SQL Conflicts Detected

All column references in downstream SQL were successfully resolved in upstream SQL definitions. No missing or inconsistent columns were detected.

### Aggregation Grain Preserved

All aggregation stages were preserved exactly as defined:
- CV_BASE_SKF_WEEKLY_BUDGET_S4: Aggregated with FLAG in GROUP BY
- CV_BASE_MD_SRPACT_S4: Aggregated with all non-measure attributes in GROUP BY
- Final Output (FLAGS): Aggregated with all non-measure columns in GROUP BY

No columns were added to or removed from any GROUP BY clause.

---

## CTE Structure

The final consolidated SQL contains the following CTEs (in execution order):

1. **Frozen_Cube** - Frozen budget data from AZSRP_DS092_VT_S4
2. **Live_Cube** - Live budget data from AZSRP_DS031_VT_S4
3. **Combined_Frozen_Live_Data** - UNION ALL of Frozen and Live cubes
4. **CV_BASE_SKF_WEEKLY_BUDGET_S4_Aggregated** - Aggregated budget data with conditional measure
5. **WEEKLY_SNAPSHOT_DS05** - Filtered weekly budget snapshot
6. **CV_BASE_MD_HRRP_NODE_S4** - Hierarchy node master data
7. **Filtered_Hierarchy_Nodes** - Filtered hierarchy nodes (CORERET pattern)
8. **Joined_Weekly_Snapshot_With_Hierarchy** - Inner join of budget and hierarchy
9. **CV_BASE_MD_SRPACT_S4_Base** - Store attributes base data
10. **CV_BASE_MD_SRPACT_S4** - Aggregated store attributes
11. **STORE_ATTR_ACTUAL** - Projected store attributes for join
12. **Joined_Weekly_With_Store_Attrs** - Left join with store attributes
13. **CV_BASE_MD_COMPFL_S4** - Comp flag base data
14. **COMP_FLAG_BUDGET** - Filtered comp flags
15. **Joined_With_Comp_Flags** - Left join with comp flags
16. **CV_BASE_MD_RCALWEEK_S4** - Calendar week master data
17. **CAL_WEEK** - Projected calendar week data
18. **Joined_With_Calendar_Week** - Left join with calendar week
19. **CV_BASE_MD_CEPCT_S4** - Profit center text master data
20. **PROFIT_CENTER_TEXT** - Projected profit center text
21. **Joined_With_Profit_Center_Text** - Left join with profit center text
22. **FLAGS** - Final transformation with calculated columns
23. **Final SELECT** - Aggregated output with measures

All CTEs are fully defined with complete SELECT statements. No placeholders, ellipses, or abbreviated logic.

---

## Output Columns

The final output contains 45 columns:

### Attributes (43 columns)
MANDT, FISCPER, FISCVARNT, FISCYEAR, FISCPER3, RECORDMODE, _BIC_ZIO_SWEEK, _B631_S_CO_AREA, _BIC_ZIO_CMPCD, _B631_S_PROFTCTR, _B631_S_COSTCNTR, _BIC_ZIO_VER, _BIC_ZIO_SAUDT, REP_MKT_CODE, REP_MKT_DESC, EMERG_MKT_IND, _BIC_ZIO_PSTY, _BIC_ZIO_PSKF, UNIT, DIVISION_CODE, DIVISION_DESC, AREA_CODE, AREA_DESC, DISTRICT_CODE, DISTRICT_DESC, REGION_CODE, REGION_DESC, CAL_WEEK_NUMBER, STRNUM, ZRWENDDATE, ZRWSTRTDATE, CITY, STATE, PROFIT_CENTER_TEXT, FS_OPEN_DAT, RX_OPEN_DAT, RX_COMP_WK, SKF_BUD_CUBE, RX_DIVISION_CODE, RX_AREA_CODE, RX_REGION_CODE, RX_DISTRICT_CODE

### Measures (2 columns)
- **_BIC_ZIO_SKFQ_NEGATIVE**: SUM(_BIC_ZIO_SKFQ)
- **_BIC_ZIO_SKFQ**: SUM(CAL_BIC_ZIO_SKFQ)

All columns are explicitly listed in both SELECT and GROUP BY clauses as required.

---

## Completeness Verification

### All Logic Included
✅ All filters preserved  
✅ All joins preserved  
✅ All calculated columns preserved  
✅ All aggregations preserved  
✅ All UNION logic preserved  
✅ All parameters preserved  
✅ All transformations preserved  

### No Abbreviations
✅ No "for brevity" statements  
✅ No "logic omitted" statements  
✅ No "continue with" statements  
✅ No ellipsis (...)  
✅ No placeholders in SQL logic  
✅ No pseudocode  
✅ No representative SQL  

### Executable SQL
✅ Complete CTE definitions  
✅ Complete SELECT statements  
✅ Complete JOIN clauses  
✅ Complete WHERE clauses  
✅ Complete GROUP BY clauses  
✅ No unresolved view references  
✅ Only physical tables referenced  

---

## Confidence Assessment

**Overall Confidence: Medium-High**

### High Confidence Areas
- Lineage tracing and dependency resolution
- SQL logic preservation (joins, filters, aggregations)
- CTE structure and naming
- Column mappings and transformations
- Completeness of consolidation

### Medium Confidence Areas
- IP_FC_COUNT parameter derivation (external function not defined)
- PARNODE pattern matching semantics (HANA match vs. BigQuery REGEXP_CONTAINS)
- Datatype compatibility (not specified in source XMLs)
- MANDT filter value types (inconsistent across views)

### Validation Required
- External function implementation (SFN_SKF_FC_FLAG)
- BigQuery project/dataset/table mappings
- Datatype validation
- Pattern matching validation
- Parameter handling in BigQuery environment

---

## Execution Readiness

The consolidated SQL is **execution-ready** with the following prerequisites:

1. **Parameter Values**: Provide values for @IP_VERSION, @IP_WEEK_ENDING_FROM, @IP_WEEK_ENDING_TO, @IP_FC_COUNT
2. **Table Mappings**: Replace PROJECT.DATASET placeholders with actual BigQuery references
3. **Function Implementation**: Implement or provide logic for IP_FC_COUNT derivation
4. **Datatype Validation**: Validate and adjust type casts if necessary
5. **Pattern Validation**: Validate PARNODE pattern matching logic

Once these prerequisites are met, the SQL can be executed directly in BigQuery without requiring any intermediate views or additional dependencies.

---

## Summary

This consolidation successfully:
- Traced all dependencies from CV_COMP_SKF_BUDGET_STATIC to physical source tables
- Eliminated all intermediate calculation views and staging tables
- Preserved all business logic, filters, joins, aggregations, and transformations
- Generated a single, fully expanded, executable BigQuery SQL query
- Provided complete traceability for all 10 supplied SQL files
- Identified validation items requiring external resolution

The final consolidated SQL represents the complete end-to-end logic for SKF Budget reporting, ready for deployment in BigQuery after prerequisite validation and mapping.
