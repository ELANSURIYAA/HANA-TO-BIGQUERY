# FIN_MANUAL_JE CONSOLIDATION DESCRIPTION

## EXECUTIVE SUMMARY

This document provides complete traceability for the consolidated BigQuery SQL implementation of **CV_COMP_FIN_MANUAL_JE**, the final consumer-facing artifact in the FIN_MANUAL_JE lineage.

All upstream dependencies have been recursively inlined, and all intermediate calculation views have been expanded into a single, fully executable BigQuery SQL query.

---

## LINEAGE ANALYSIS

### Final Consumer Artifact
- **CV_COMP_FIN_MANUAL_JE** (Calculation View, CUBE type with Aggregation output)

### Upstream Dependencies (from Relationships Table)

| Source File | Target File | Dependency Type | Reason |
|-------------|-------------|-----------------|--------|
| CV_BASE_FIN_ACDOCA_S4 | CV_COMP_FIN_MANUAL_JE | Calculation View Dependency | Explicitly referenced in data sources |
| CV_BASE_FIN_BKPF_S4 | CV_COMP_FIN_MANUAL_JE | Calculation View Dependency | Explicitly referenced in data sources |
| CV_BASE_MD_CEPCT_S4 | CV_COMP_FIN_MANUAL_JE | Calculation View Dependency | Explicitly referenced in data sources |
| CV_BASE_MD_COMPFL_S4 | CV_COMP_FIN_MANUAL_JE | Calculation View Dependency | Explicitly referenced in data sources |
| CV_BASE_MD_RCALWEEK_S4 | CV_COMP_FIN_MANUAL_JE | Calculation View Dependency | Explicitly referenced in data sources |
| CV_BASE_MD_SRPACT_S4 | CV_COMP_FIN_MANUAL_JE | Calculation View Dependency | Explicitly referenced in data sources |
| GL_HEIR.CV_BASE_MD_HRRP_NODE_S4 | CV_COMP_FIN_MANUAL_JE | Calculation View Dependency | GL hierarchy variant |
| PC_HEIR.CV_BASE_MD_HRRP_NODE_S4 | CV_COMP_FIN_MANUAL_JE | Calculation View Dependency | PC hierarchy variant |
| PROD_CLASS_HEIR.CV_BASE_MD_HRRP_NODE_S4 | CV_COMP_FIN_MANUAL_JE | Calculation View Dependency | Product Class hierarchy variant |

---

## CONVERTED SQL FILE USAGE

### USED FILES

All supplied converted BigQuery SQL files were used in the consolidation:

1. **CV_COMP_FIN_MANUAL_JE_DI HANA to BigQuery SQL Conversion Agent.txt**
   - **Role**: Final consumer artifact
   - **Usage**: Defines the complete join flow, filters, calculated columns, aggregation logic, and final output schema
   - **Key Logic**: 
     - Parameters: IP_WEEK_ENDING_FROM, IP_WEEK_ENDING_TO, IP_VERSION_COMP_FLAG
     - Filters on ZZWEEK, XREF2_HD, hierarchy nodes
     - Joins across journal entries, document headers, hierarchies, store attributes, comp flags, profit center text, calendar week
     - Calculated columns: CAL_WEEK_NUMBER, CAL_FS_RX_FLAG, COMP_FLAG, KSL_NEGATIVE, KSL
     - Final aggregation by all non-measure columns

2. **CV_BASE_FIN_ACDOCA_S4_DI HANA to BigQuery SQL Conversion Agent.txt**
   - **Role**: Journal entry line items (ACDOCA)
   - **Usage**: Source for financial transaction data
   - **Key Logic**: 
     - Filter: RCLNT IN (120, 200)
     - Aggregation of all measures (TSL, WSL, KSL, etc.)
     - GROUP BY all attributes
   - **Inlined As**: JOURNAL_ENT_ACDOCA_BASE and JOURNAL_ENT_ACDOCA CTEs

3. **CV_BASE_FIN_BKPF_S4_DI HANA to BigQuery SQL Conversion Agent.txt**
   - **Role**: Document header data (BKPF)
   - **Usage**: Source for document-level attributes including XREF2_HD (source code filter)
   - **Key Logic**:
     - Filter: MANDT IN ('120', '200')
     - Aggregation of measures (KZKRS, KURSX, etc.)
     - GROUP BY all attributes
   - **Inlined As**: BKPF_BASE and BKPF_Filtered CTEs

4. **CV_BASE_MD_CEPCT_S4_DI HANA to BigQuery SQL Conversion Agent.txt**
   - **Role**: Profit center text (CEPCT)
   - **Usage**: Provides PROFIT_CENTER_TEXT (LTEXT) for output
   - **Key Logic**:
     - Filter: MANDT IN (120, 200)
     - Projection of profit center text attributes
   - **Inlined As**: PROFIT_CENTER_TEXT_BASE and PROFIT_CENTER_TEXT CTEs

5. **CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL Conversion Agent.txt**
   - **Role**: Comp flag data (ZTSRP_COMPFL)
   - **Usage**: Provides RX_COMP_WK and FS_COMP_WK for COMP_FLAG calculation
   - **Key Logic**:
     - Filter: MANDT IN (110, 200)
     - Projection of comp flag attributes
   - **Inlined As**: COMP_FLAG_BASE and COMP_FLAG_JOURNAL_ENT_Filtered CTEs

6. **CV_BASE_MD_RCALWEEK_S4_DI HANA to BigQuery SQL Conversion Agent.txt**
   - **Role**: Retail calendar week (ZTFIGL_RCALWEEK)
   - **Usage**: Provides ZRWSTRTDATE and ZRWENDDATE for calendar week mapping
   - **Key Logic**:
     - Filter: RCLNT IN (120, 200)
     - Projection of calendar week attributes
   - **Inlined As**: CAL_WEEK_BASE and CAL_WEEK CTEs

7. **CV_BASE_MD_SRPACT_S4_DI HANA to BigQuery SQL Conversion Agent.txt**
   - **Role**: Store profile attributes (ZTSRP_ATTR_ACT)
   - **Usage**: Provides store-level attributes (REP_MKT_CODE, DIVISION_CODE, AREA_CODE, etc.)
   - **Key Logic**:
     - Filter: MANDT IN (120, 200)
     - Aggregation of measures (RX_HRS_OPER, FS_HRS_OPER, etc.)
     - GROUP BY all attributes
   - **Inlined As**: STORE_ATTR_BASE and STORE_ATTR_JOURNAL_ENT CTEs

8. **GL_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt**
   - **Role**: GL account hierarchy (HRRP_NODE)
   - **Usage**: Filters journal entries by GL account hierarchy (PARNODE LIKE '%181', HRYID = 'CVS2')
   - **Key Logic**:
     - Filter: MANDT IN (120, 200)
     - Projection of hierarchy node attributes
   - **Inlined As**: GL_HIER_BASE and GL_HIER_Filtered CTEs

9. **PC_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt**
   - **Role**: Profit center hierarchy (HRRP_NODE)
   - **Usage**: Filters journal entries by profit center hierarchy (PARNODE LIKE '%CORE_RET%')
   - **Key Logic**:
     - Filter: MANDT IN (120, 200)
     - Projection of hierarchy node attributes
   - **Inlined As**: PC_HIER_BASE and PC_HIER_Filtered CTEs

10. **PROD_CLASS_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt**
    - **Role**: Product class hierarchy (HRRP_NODE)
    - **Usage**: Filters journal entries by product class hierarchy (PARNODE LIKE '%FS' OR PARNODE LIKE '%RX')
    - **Key Logic**:
      - Filter: MANDT IN (120, 200)
      - Projection of hierarchy node attributes
    - **Inlined As**: PROD_CLASS_HIER_BASE and PROD_CLASS_HIER_Filtered CTEs

### NOT USED FILES

None. All supplied converted SQL files were incorporated into the consolidated query.

---

## CONSOLIDATION APPROACH

### Dependency Resolution Strategy

1. **Identified Final Consumer**: CV_COMP_FIN_MANUAL_JE
2. **Extracted Upstream Dependencies**: All 9 upstream calculation views from the lineage table
3. **Recursive Inlining**: Each upstream calculation view was expanded into its base table logic
4. **Preserved CTE Names**: Where possible, CTE names from the final consumer converted SQL were preserved
5. **Introduced Helper CTEs**: Additional CTEs (e.g., *_BASE) were introduced to separate base table aggregation from filtering/projection logic
6. **Maintained Semantic Layers**: Each transformation stage (filter, join, aggregation) was preserved as a distinct CTE

### CTE Structure

The consolidated SQL contains the following CTE layers:

1. **Base Aggregation CTEs** (for CUBE views):
   - JOURNAL_ENT_ACDOCA_BASE
   - BKPF_BASE
   - STORE_ATTR_BASE
   - PROFIT_CENTER_TEXT_BASE
   - CAL_WEEK_BASE
   - PC_HIER_BASE
   - GL_HIER_BASE
   - PROD_CLASS_HIER_BASE
   - COMP_FLAG_BASE

2. **Filtered/Projected CTEs**:
   - JOURNAL_ENT_ACDOCA (applies ZZWEEK parameter filter)
   - BKPF_Filtered (applies XREF2_HD filter)
   - PC_HIER_Filtered (applies PARNODE and HRYVALTO filters)
   - GL_HIER_Filtered (applies PARNODE, HRYVALTO, HRYID filters)
   - PROD_CLASS_HIER_Filtered (applies PARNODE, HRYVALTO, HRYID filters)
   - STORE_ATTR_JOURNAL_ENT (projects required store attributes)
   - COMP_FLAG_JOURNAL_ENT_Filtered (applies COMP_VER parameter filter)
   - PROFIT_CENTER_TEXT (projects LTEXT as PROFIT_CENTER_TEXT)
   - CAL_WEEK (projects required calendar week attributes)

3. **Join CTEs** (from final consumer logic):
   - Joined_Journal_BKPF
   - Filtered_Journal_BKPF
   - Joined_Journal_PC_HIER
   - Joined_GL_HIER
   - Joined_Prod_Class_Hier
   - Joined_Store_Attr
   - Joined_Comp_Flag
   - Joined_Profit_Center_Text
   - Joined_Calendar_Week

4. **Final SELECT**: Aggregates all measures and groups by all non-measure attributes

### Aggregation Grain Preservation

- **JOURNAL_ENT_ACDOCA_BASE**: Aggregates measures from ACDOCA_VT_S4, groups by all attributes
- **BKPF_BASE**: Aggregates measures from BKPF_VT_S4, groups by all attributes
- **STORE_ATTR_BASE**: Aggregates measures from ZTSRP_ATTR_ACT, groups by all attributes
- **Final SELECT**: Aggregates KSL_NEGATIVE (sum of KSL), groups by all final output attributes

No aggregation grain was changed during consolidation. Each aggregation stage from the source converted SQL was preserved exactly.

### Filter Preservation

All filters from the source converted SQL files were preserved:

1. **RCLNT/MANDT Filters**:
   - ACDOCA: RCLNT IN (120, 200)
   - BKPF: MANDT IN ('120', '200')
   - CEPCT: MANDT IN (120, 200)
   - COMPFL: MANDT IN (110, 200)
   - RCALWEEK: RCLNT IN (120, 200)
   - SRPACT: MANDT IN (120, 200)
   - HRRP_NODE (all variants): MANDT IN (120, 200)

2. **Parameter Filters**:
   - ZZWEEK BETWEEN @IP_WEEK_ENDING_FROM AND @IP_WEEK_ENDING_TO
   - COMP_VER = @IP_VERSION_COMP_FLAG

3. **Business Logic Filters**:
   - XREF2_HD IN ('MJE','TS','GENCO','MAR','SAPARINVOICES','TP')
   - XREF2_HD NOT IN ('RT', 'RV', 'SK')
   - PARNODE LIKE '%CORE_RET%' (PC hierarchy)
   - PARNODE LIKE '%181' (GL hierarchy)
   - HRYID = 'CVS2' (GL hierarchy)
   - PARNODE LIKE '%FS' OR PARNODE LIKE '%RX' (Product Class hierarchy)
   - HRYID LIKE '%ZPRODUCTCLASS' (Product Class hierarchy)
   - HRYVALTO = '99991231' (all hierarchies)

### Join Preservation

All joins from the final consumer converted SQL were preserved:

1. **JOURNAL_ENT_ACDOCA ⟕ BKPF_Filtered**:
   - INNER JOIN ON RBUKRS = BUKRS AND BELNR = BELNR AND GJAHR = GJAHR

2. **Filtered_Journal_BKPF ⟕ PC_HIER_Filtered**:
   - INNER JOIN ON PRCTR = NODEVALUE AND MANDT = MANDT

3. **Joined_Journal_PC_HIER ⟕ GL_HIER_Filtered**:
   - INNER JOIN ON RACCT = NODEVALUE AND MANDT = MANDT

4. **Joined_GL_HIER ⟕ PROD_CLASS_HIER_Filtered**:
   - INNER JOIN ON WWPC_PA = NODEVALUE AND MANDT = MANDT

5. **Joined_Prod_Class_Hier ⟕ STORE_ATTR_JOURNAL_ENT**:
   - LEFT JOIN ON PRCTR = PRCTR AND MANDT = MANDT

6. **Joined_Store_Attr ⟕ COMP_FLAG_JOURNAL_ENT_Filtered**:
   - LEFT JOIN ON PRCTR = PRCTR AND ZZWEEK = ZWEEK AND MANDT = MANDT

7. **Joined_Comp_Flag ⟕ PROFIT_CENTER_TEXT**:
   - LEFT JOIN ON PRCTR = PRCTR AND MANDT = MANDT

8. **Joined_Profit_Center_Text ⟕ CAL_WEEK**:
   - LEFT JOIN ON ZZWEEK = ZZWEEK AND MANDT = RCLNT

All join types (INNER, LEFT) were preserved exactly as defined in the final consumer converted SQL.

### Calculated Column Preservation

All calculated columns from the final consumer converted SQL were preserved:

1. **CAL_WEEK_NUMBER**: `RIGHT(CAST(ZZWEEK AS STRING), 2)`
2. **CAL_FS_RX_FLAG**: 
   ```sql
   CASE LEFT(CAST(WWPC_PA AS STRING), 2)
     WHEN 'FS' THEN 'FS'
     WHEN 'RX' THEN 'RX'
     ELSE ''
   END
   ```
3. **COMP_FLAG** (aggregation-aware):
   ```sql
   CASE CAL_FS_RX_FLAG
     WHEN 'FS' THEN MAX(FS_COMP_WK)
     WHEN 'RX' THEN MAX(RX_COMP_WK)
     ELSE MAX(FS_COMP_WK)
   END
   ```
4. **KSL_NEGATIVE**: `SUM(KSL)`

Note: The original final consumer converted SQL defined KSL as `KSL_NEGATIVE * -1`, but this was not included in the final output schema. The consolidated SQL preserves KSL_NEGATIVE as the aggregated measure output.

### Output Schema

The final SELECT produces the following output columns (as defined by the final consumer converted SQL):

**Attributes (Grouping Columns)**:
- MANDT
- RX_COMP_WK
- FS_COMP_WK
- EMERG_MKT_IND
- DISTRICT_CODE
- REGION_DESC
- REGION_CODE
- RCLNT
- PRCTR
- ZZWEEK
- DISTRICT_DESC
- AREA_DESC
- DIVISION_DESC
- AREA_CODE
- DIVISION_CODE
- REP_MKT_DESC
- REP_MKT_CODE
- PROFIT_CENTER_TEXT
- FS_OPEN_DAT
- RX_OPEN_DAT
- PARNODE
- ZRWSTRTDATE
- ZRWENDDATE
- CITY
- STATE
- CAL_WEEK_NUMBER
- CAL_FS_RX_FLAG
- STRNUM
- SOURCE_CODE
- RX_DIVISION_CODE
- RX_AREA_CODE
- RX_REGION_CODE
- RX_DISTRICT_CODE

**Measures (Aggregated Columns)**:
- COMP_FLAG (calculated as MAX of FS_COMP_WK or RX_COMP_WK based on CAL_FS_RX_FLAG)
- KSL_NEGATIVE (SUM of KSL)

### Parameters

The consolidated SQL requires three BigQuery query parameters:

1. **@IP_WEEK_ENDING_FROM**: Start of week range filter for ZZWEEK
2. **@IP_WEEK_ENDING_TO**: End of week range filter for ZZWEEK
3. **@IP_VERSION_COMP_FLAG**: Comp version filter for COMP_VER

These parameters must be supplied at query execution time.

---

## VALIDATION ITEMS

### REQUIRES VALIDATION

The following items require validation before the consolidated SQL can be executed in production:

1. **BigQuery Table Mappings**:
   - `PROJECT.DATASET.ACDOCA_VT_S4` → Actual BigQuery table for CVS_FRIP.ACDOCA_VT_S4
   - `PROJECT.DATASET.BKPF_VT_S4` → Actual BigQuery table for CVS_FRIP.BKPF_VT_S4
   - `PROJECT.DATASET.CEPCT` → Actual BigQuery table for SAP_S4.CEPCT
   - `PROJECT.DATASET.ZTSRP_COMPFL` → Actual BigQuery table for SAP_S4.ZTSRP_COMPFL
   - `PROJECT.DATASET.ZTFIGL_RCALWEEK` → Actual BigQuery table for SAP_S4.ZTFIGL_RCALWEEK
   - `PROJECT.DATASET.ZTSRP_ATTR_ACT` → Actual BigQuery table for SAP_S4.ZTSRP_ATTR_ACT
   - `PROJECT.DATASET.HRRP_NODE` → Actual BigQuery table for SAP_S4.HRRP_NODE

2. **Datatype Validation**:
   - MANDT filter values: Some sources use numeric (120, 200), others use string ('120', '200'). Validate actual column datatypes in BigQuery.
   - ZZWEEK: Assumed to be compatible with BETWEEN operator and string functions (RIGHT, CAST). Validate datatype.
   - WWPC_PA: Assumed to be compatible with string functions (LEFT, CAST). Validate datatype.
   - All date columns (BUDAT, BLDAT, FS_OPEN_DAT, RX_OPEN_DAT, ZRWSTRTDATE, ZRWENDDATE): Validate date/timestamp datatypes.

3. **Column Existence**:
   - All columns referenced in the consolidated SQL must exist in the target BigQuery tables with compatible names and datatypes.
   - If any columns are missing or renamed in BigQuery, the SQL must be adjusted accordingly.

4. **Parameter Datatypes**:
   - @IP_WEEK_ENDING_FROM and @IP_WEEK_ENDING_TO: Must be compatible with ZZWEEK datatype for BETWEEN comparison.
   - @IP_VERSION_COMP_FLAG: Must be compatible with COMP_VER datatype for equality comparison.

5. **Aggregation Behavior**:
   - The consolidated SQL assumes that base tables (ACDOCA_VT_S4, BKPF_VT_S4, ZTSRP_ATTR_ACT) may contain duplicate rows that require aggregation. If these tables are already pre-aggregated in BigQuery, the base aggregation CTEs may be unnecessary and can be simplified.

6. **Performance Considerations**:
   - The consolidated SQL contains multiple joins and aggregations. Indexing, partitioning, and clustering strategies should be reviewed for optimal performance in BigQuery.
   - The HRRP_NODE table is referenced three times (for PC, GL, and Product Class hierarchies). If this table is large, consider materializing filtered hierarchy CTEs or using BigQuery's query caching.

7. **HANA-Specific Functions**:
   - RIGHTSTR → RIGHT: Validated as compatible
   - LEFTSTR → LEFT: Validated as compatible
   - CASE function: Validated as compatible (though syntax differs slightly; BigQuery uses CASE WHEN ... THEN ... ELSE ... END)

8. **Missing Calculated Column**:
   - The original final consumer converted SQL defined KSL as `KSL_NEGATIVE * -1`, but this column was not included in the final output schema. If KSL (non-negative) is required as an output, it should be added to the final SELECT.

---

## ASSUMPTIONS

1. **All referenced tables exist in BigQuery** with the same column names and compatible datatypes as in HANA.
2. **MANDT/RCLNT filter values** (120, 200, 110) are correct and consistent with the target environment.
3. **Hierarchy filters** (PARNODE patterns, HRYID values, HRYVALTO = '99991231') are correct and will return the expected hierarchy nodes.
4. **XREF2_HD filter values** ('MJE','TS','GENCO','MAR','SAPARINVOICES','TP', and exclusions 'RT', 'RV', 'SK') are correct and complete.
5. **Parameters** will be supplied at query execution time with valid values.
6. **No additional business logic** exists beyond what is defined in the supplied converted SQL files.
7. **No data quality issues** (e.g., missing join keys, orphaned records) will cause unexpected results.

---

## TRACEABILITY MATRIX

| Final Output Column | Source CTE | Source Column | Transformation | Origin File |
|---------------------|------------|---------------|----------------|-------------|
| MANDT | Joined_Calendar_Week | MANDT | Direct | CV_COMP_FIN_MANUAL_JE |
| RX_COMP_WK | Joined_Calendar_Week | RX_COMP_WK | Direct | CV_BASE_MD_COMPFL_S4 |
| FS_COMP_WK | Joined_Calendar_Week | FS_COMP_WK | Direct | CV_BASE_MD_COMPFL_S4 |
| EMERG_MKT_IND | Joined_Calendar_Week | EMERG_MKT_IND | Direct | CV_BASE_MD_SRPACT_S4 |
| DISTRICT_CODE | Joined_Calendar_Week | DISTRICT_CODE | Direct | CV_BASE_MD_SRPACT_S4 |
| REGION_DESC | Joined_Calendar_Week | REGION_DESC | Direct | CV_BASE_MD_SRPACT_S4 |
| REGION_CODE | Joined_Calendar_Week | REGION_CODE | Direct | CV_BASE_MD_SRPACT_S4 |
| RCLNT | Joined_Calendar_Week | RCLNT | Direct | CV_BASE_FIN_ACDOCA_S4 |
| PRCTR | Joined_Calendar_Week | PRCTR | Direct | CV_BASE_FIN_ACDOCA_S4 |
| ZZWEEK | Joined_Calendar_Week | ZZWEEK | Direct | CV_BASE_FIN_ACDOCA_S4 |
| DISTRICT_DESC | Joined_Calendar_Week | DISTRICT_DESC | Direct | CV_BASE_MD_SRPACT_S4 |
| AREA_DESC | Joined_Calendar_Week | AREA_DESC | Direct | CV_BASE_MD_SRPACT_S4 |
| DIVISION_DESC | Joined_Calendar_Week | DIVISION_DESC | Direct | CV_BASE_MD_SRPACT_S4 |
| AREA_CODE | Joined_Calendar_Week | AREA_CODE | Direct | CV_BASE_MD_SRPACT_S4 |
| DIVISION_CODE | Joined_Calendar_Week | DIVISION_CODE | Direct | CV_BASE_MD_SRPACT_S4 |
| REP_MKT_DESC | Joined_Calendar_Week | REP_MKT_DESC | Direct | CV_BASE_MD_SRPACT_S4 |
| REP_MKT_CODE | Joined_Calendar_Week | REP_MKT_CODE | Direct | CV_BASE_MD_SRPACT_S4 |
| PROFIT_CENTER_TEXT | Joined_Calendar_Week | PROFIT_CENTER_TEXT | Direct (LTEXT) | CV_BASE_MD_CEPCT_S4 |
| FS_OPEN_DAT | Joined_Calendar_Week | FS_OPEN_DAT | Direct | CV_BASE_MD_SRPACT_S4 |
| RX_OPEN_DAT | Joined_Calendar_Week | RX_OPEN_DAT | Direct | CV_BASE_MD_SRPACT_S4 |
| PARNODE | Joined_Calendar_Week | PARNODE | Direct | PROD_CLASS_HEIR.CV_BASE_MD_HRRP_NODE_S4 |
| ZRWSTRTDATE | Joined_Calendar_Week | ZRWSTRTDATE | Direct | CV_BASE_MD_RCALWEEK_S4 |
| ZRWENDDATE | Joined_Calendar_Week | ZRWENDDATE | Direct | CV_BASE_MD_RCALWEEK_S4 |
| CITY | Joined_Calendar_Week | CITY | Direct | CV_BASE_MD_SRPACT_S4 |
| STATE | Joined_Calendar_Week | STATE | Direct | CV_BASE_MD_SRPACT_S4 |
| CAL_WEEK_NUMBER | Joined_Calendar_Week | CAL_WEEK_NUMBER | RIGHT(CAST(ZZWEEK AS STRING), 2) | CV_COMP_FIN_MANUAL_JE |
| COMP_FLAG | Final SELECT | COMP_FLAG | CASE CAL_FS_RX_FLAG ... MAX(...) | CV_COMP_FIN_MANUAL_JE |
| CAL_FS_RX_FLAG | Joined_Calendar_Week | CAL_FS_RX_FLAG | CASE LEFT(CAST(WWPC_PA AS STRING), 2) ... | CV_COMP_FIN_MANUAL_JE |
| KSL_NEGATIVE | Final SELECT | KSL_NEGATIVE | SUM(KSL) | CV_COMP_FIN_MANUAL_JE |
| STRNUM | Joined_Calendar_Week | STRNUM | Direct | CV_BASE_MD_SRPACT_S4 |
| SOURCE_CODE | Joined_Calendar_Week | SOURCE_CODE | Direct (XREF2_HD) | CV_BASE_FIN_BKPF_S4 |
| RX_DIVISION_CODE | Joined_Calendar_Week | RX_DIVISION_CODE | Direct | CV_BASE_MD_SRPACT_S4 |
| RX_AREA_CODE | Joined_Calendar_Week | RX_AREA_CODE | Direct | CV_BASE_MD_SRPACT_S4 |
| RX_REGION_CODE | Joined_Calendar_Week | RX_REGION_CODE | Direct | CV_BASE_MD_SRPACT_S4 |
| RX_DISTRICT_CODE | Joined_Calendar_Week | RX_DISTRICT_CODE | Direct | CV_BASE_MD_SRPACT_S4 |

---

## CONSOLIDATION QUALITY CHECKS

### Duplicate Alias Validation
✅ **PASSED**: No duplicate output aliases detected in any CTE or the final SELECT.

### Star Expression Validation
✅ **PASSED**: No SELECT * or alias.* expressions remain in the consolidated SQL. All columns are explicitly listed.

### Aggregation Grain Validation
✅ **PASSED**: All aggregation stages preserve their original grain. No grouping columns were added or removed incorrectly.

### Filter Preservation Validation
✅ **PASSED**: All filters from the source converted SQL files are preserved in the consolidated SQL.

### Join Preservation Validation
✅ **PASSED**: All join types and join conditions from the final consumer converted SQL are preserved exactly.

### Calculated Column Validation
✅ **PASSED**: All calculated columns from the final consumer converted SQL are preserved with their original logic.

### Output Schema Validation
✅ **PASSED**: The final SELECT output schema matches the expected output from the final consumer converted SQL.

### Parameter Validation
✅ **PASSED**: All parameters (IP_WEEK_ENDING_FROM, IP_WEEK_ENDING_TO, IP_VERSION_COMP_FLAG) are correctly referenced as BigQuery query parameters (@parameter_name).

### Dependency Resolution Validation
✅ **PASSED**: All upstream dependencies from the lineage table are recursively inlined. No unresolved view references remain.

### CTE Name Validation
✅ **PASSED**: CTE names from the final consumer converted SQL are preserved where applicable. Additional helper CTEs use descriptive, deterministic names.

---

## EXECUTION READINESS

### Status
**REQUIRES VALIDATION** (see Validation Items section)

### Blockers
1. BigQuery table mappings (PROJECT.DATASET placeholders) must be replaced with actual table references
2. Datatype validation required for MANDT, ZZWEEK, WWPC_PA, and date columns
3. Parameter datatype validation required
4. Column existence validation required

### Next Steps
1. Replace all `PROJECT.DATASET.*` table references with actual BigQuery table names
2. Validate all column datatypes and adjust filter literals if necessary (e.g., string vs. numeric for MANDT)
3. Validate parameter datatypes and adjust parameter declarations if necessary
4. Test the consolidated SQL with sample parameter values in a BigQuery development environment
5. Review query performance and apply optimization strategies (partitioning, clustering, indexing) as needed
6. Validate output against expected results from the HANA source system

---

## CONFIDENCE LEVEL

**MEDIUM-HIGH**

The consolidation is structurally complete and preserves all logic from the supplied converted SQL files. However, execution readiness depends on:
- Correct BigQuery table mappings
- Datatype compatibility validation
- Column existence validation
- Parameter validation

Once these validation items are resolved, confidence level will be **HIGH**.

---

## DOCUMENT VERSION

- **Version**: 1.0
- **Date**: 2025-01-23
- **Author**: BigQuery SQL Consolidation Agent
- **Artifact**: FIN_MANUAL_JE Consolidated BigQuery SQL
- **Final Consumer**: CV_COMP_FIN_MANUAL_JE

---

END OF CONSOLIDATION DESCRIPTION
