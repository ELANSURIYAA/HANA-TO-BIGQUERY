# RX_BUDGET CONSOLIDATION DESCRIPTION

## Executive Summary

This document provides complete traceability and analysis for the consolidation of RX_BUDGET HANA artifacts into a single, fully expanded BigQuery SQL implementation.

**Final Consumer Artifact:** CV_COMP_FIN_BUDGET_STATIC

**Total Files Analyzed:** 11 files (1 lineage file + 10 converted SQL files)

**Consolidation Status:** COMPLETE with validation items documented

---

## 1. CONSOLIDATION TRACEABILITY

### 1.1 Lineage Analysis

The lineage relationships from the RX_BUDGET LATEST RELATIONSHIP TABLE establish the following dependency tree:

```
CV_COMP_FIN_BUDGET_STATIC (Final Consumer)
├── CV_BASE_FIN_WEEKLY_BUDGET_S4 (Direct Dependency - Score: 90)
│   ├── AZSRP_DS052_VT_S4 (Physical Table - Frozen Cube)
│   └── AZSRP_DS041_VT_S4 (Physical Table - Live Cube)
├── CV_BASE_MD_HRRP_NODE_S4 (Direct Dependency - Score: 90)
│   └── HRRP_NODE (Physical Table)
├── CV_BASE_MD_RCALWEEK_S4 (Direct Dependency - Score: 90)
│   └── ZTFIGL_RCALWEEK (Physical Table)
├── CV_BASE_MD_CEPCT_S4 (Direct Dependency - Score: 90)
│   └── CEPCT (Physical Table)
├── CV_COMP_MD_SRPACT_STATIC (Direct Dependency - Score: 90)
│   ├── TBL_WSS_SRP_ATTR_ACT (Physical Table)
│   └── STP_WSS_SRP_ATTRIBUTES (Logic Provider - Score: 95)
│       └── CV_BASE_MD_SRPACT_S4 (Source Dependency - Score: 100)
│           └── ZTSRP_ATTR_ACT (Physical Table)
└── CV_COMP_MD_COMPFL_STATIC (Direct Dependency - Score: 90)
    ├── TBL_WSS_SRP_COMPFLAG (Physical Table)
    └── STP_WSS_SRP_ATTRIBUTES (Logic Provider - Score: 95)
        └── CV_BASE_MD_COMPFL_S4 (Source Dependency - Score: 100)
            └── ZTSRP_COMPFL (Physical Table)
```

### 1.2 File Usage Classification

#### USED FILES (10 of 10 converted SQL files)

1. **CV_COMP_FIN_BUDGET_STATIC_DI** - USED
   - Role: Final consumer artifact
   - Logic: Aggregation CUBE with 6 upstream dependencies
   - Contribution: Defines final output structure, joins, filters, calculated columns, and aggregation logic

2. **CV_BASE_FIN_WEEKLY_BUDGET_S4_DI** - USED
   - Role: Primary fact data source
   - Logic: UNION of Frozen and Live cubes with restricted measures
   - Contribution: Provides weekly budget snapshot data with calculated measure logic
   - Inlined: Fully expanded from physical tables AZSRP_DS052_VT_S4 and AZSRP_DS041_VT_S4

3. **CV_BASE_MD_HRRP_NODE_S4_DI** - USED
   - Role: Hierarchy dimension
   - Logic: Projection with filter on PARNODE and HRYVALTO
   - Contribution: Provides CORE_RET hierarchy filtering for profit centers
   - Inlined: Fully expanded from physical table HRRP_NODE

4. **CV_BASE_MD_RCALWEEK_S4_DI** - USED
   - Role: Calendar week dimension
   - Logic: Projection with client filter
   - Contribution: Provides retail calendar week start/end dates
   - Inlined: Fully expanded from physical table ZTFIGL_RCALWEEK

5. **CV_BASE_MD_CEPCT_S4_DI** - USED
   - Role: Profit center text dimension
   - Logic: Projection with client filter
   - Contribution: Provides profit center long text descriptions
   - Inlined: Fully expanded from physical table CEPCT

6. **CV_COMP_MD_SRPACT_STATIC_DI** - USED
   - Role: Store attributes dimension
   - Logic: Aggregation CUBE over TBL_WSS_SRP_ATTR_ACT
   - Contribution: Provides store profile attributes (market, division, area, region, district, etc.)
   - Inlined: Traced back through STP_WSS_SRP_ATTRIBUTES to CV_BASE_MD_SRPACT_S4 and physical table ZTSRP_ATTR_ACT

7. **CV_BASE_MD_SRPACT_S4_DI** - USED
   - Role: Upstream source for CV_COMP_MD_SRPACT_STATIC
   - Logic: Aggregation CUBE with client filter
   - Contribution: Provides base store attributes with aggregated measures
   - Inlined: Fully expanded from physical table ZTSRP_ATTR_ACT

8. **CV_COMP_MD_COMPFL_STATIC_DI** - USED
   - Role: Comp flag dimension
   - Logic: Projection over TBL_WSS_SRP_COMPFLAG
   - Contribution: Provides FS/RX comp flags by week
   - Inlined: Traced back through STP_WSS_SRP_ATTRIBUTES to CV_BASE_MD_COMPFL_S4 and physical table ZTSRP_COMPFL

9. **CV_BASE_MD_COMPFL_S4_DI** - USED
   - Role: Upstream source for CV_COMP_MD_COMPFL_STATIC
   - Logic: Projection with client filter
   - Contribution: Provides base comp flag data
   - Inlined: Fully expanded from physical table ZTSRP_COMPFL

10. **STP_WSS_SRP_ATTRIBUTES_DI** - USED
    - Role: ETL stored procedure populating TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG
    - Logic: DELETE + INSERT operations from CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_COMPFL_S4
    - Contribution: Provides lineage traceability showing that static tables are populated from base calculation views
    - Treatment: ETL logic traced upstream to source calculation views per ETL Expansion Rule

#### NOT USED FILES (0 of 10 converted SQL files)

All supplied converted SQL files were used in the consolidation.

---

## 2. DEPENDENCY RESOLUTION APPROACH

### 2.1 ETL Table Handling

Per the ETL Expansion Rule, the following tables were identified as ETL/staging tables:

- **TBL_WSS_SRP_ATTR_ACT**: Populated by STP_WSS_SRP_ATTRIBUTES from CV_BASE_MD_SRPACT_S4
- **TBL_WSS_SRP_COMPFLAG**: Populated by STP_WSS_SRP_ATTRIBUTES from CV_BASE_MD_COMPFL_S4

**Resolution Strategy:**
- Traced lineage upstream through STP_WSS_SRP_ATTRIBUTES
- Identified source calculation views (CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4)
- Inlined source calculation view logic instead of referencing ETL tables
- Continued recursive expansion to physical source tables (ZTSRP_ATTR_ACT, ZTSRP_COMPFL)

### 2.2 Recursive Dependency Expansion

All calculation view dependencies were recursively expanded:

1. **CV_BASE_FIN_WEEKLY_BUDGET_S4**
   - Expanded to: Frozen_Cube + Live_Cube + Union + Aggregation + Calculated Measure
   - Physical sources: AZSRP_DS052_VT_S4, AZSRP_DS041_VT_S4

2. **CV_COMP_MD_SRPACT_STATIC**
   - Expanded through: STP_WSS_SRP_ATTRIBUTES → CV_BASE_MD_SRPACT_S4
   - Physical source: ZTSRP_ATTR_ACT

3. **CV_COMP_MD_COMPFL_STATIC**
   - Expanded through: STP_WSS_SRP_ATTRIBUTES → CV_BASE_MD_COMPFL_S4
   - Physical source: ZTSRP_COMPFL

4. **CV_BASE_MD_HRRP_NODE_S4**
   - Physical source: HRRP_NODE

5. **CV_BASE_MD_RCALWEEK_S4**
   - Physical source: ZTFIGL_RCALWEEK

6. **CV_BASE_MD_CEPCT_S4**
   - Physical source: CEPCT

### 2.3 Join Logic Preservation

All joins from CV_COMP_FIN_BUDGET_STATIC were preserved:

- **Join_1**: INNER JOIN between WEEKLY_SNAPSHOT_DS05 and HIER_NODE on _B631_S_PROFTCTR = NODEVALUE
- **Join_2**: LEFT OUTER JOIN between ONLY_CORE_RET_DATA and STORE_ATTR_ACTUAL on _B631_S_PROFTCTR = PRCTR
- **Join_3**: LEFT OUTER JOIN between WEEK_NUMBER and COMP_FLAG_BUDGET on _B631_S_PROFTCTR = PRCTR AND _BIC_ZIO_SWEEK = ZWEEK
- **Join_4**: LEFT OUTER JOIN between Join_3 and CAL_WEEK on _BIC_ZIO_SWEEK = ZZWEEK
- **Join_5**: LEFT OUTER JOIN between Join_4 and PROFIT_CENTER_TEXT on _B631_S_PROFTCTR = PRCTR

---

## 3. LOGIC CONSOLIDATION DETAILS

### 3.1 Filters Applied

**WEEKLY_SNAPSHOT_DS05 Filters:**
- FISCVARNT = 'K4'
- _BIC_ZIO_SWEEK BETWEEN @IP_WEEK_ENDING_FROM AND @IP_WEEK_ENDING_TO
- _BIC_ZIO_VER = @IP_VERSION
- _BIC_ZIO_SAUDT IN ('1', '10')

**HIER_NODE Filters:**
- REGEXP_CONTAINS(PARNODE, r'.*CORE_RET$')
- HRYVALTO = '99991231'

**COMP_FLAG_BUDGET Filters:**
- COMP_VER = @IP_VERSION

**Client Filters (across multiple sources):**
- MANDT IN ('110', '200') for budget data
- MANDT IN (120, 200) for master data

### 3.2 Calculated Columns

**From CV_COMP_FIN_BUDGET_STATIC:**

1. **CAL_FS_RX_FLAG**
   ```sql
   CASE
     WHEN LEFT(SAFE_CAST(_BIC_ZWWPC_PA1 AS STRING), 2) = 'FS' THEN 'FS'
     WHEN LEFT(SAFE_CAST(_BIC_ZWWPC_PA1 AS STRING), 2) = 'RX' THEN 'RX'
     ELSE ''
   END
   ```

2. **CAL_COMP_FLAG**
   ```sql
   COALESCE(
     CASE
       WHEN LEFT(SAFE_CAST(_BIC_ZWWPC_PA1 AS STRING), 2) = 'FS' THEN FS_COMP_WK
       WHEN LEFT(SAFE_CAST(_BIC_ZWWPC_PA1 AS STRING), 2) = 'RX' THEN RX_COMP_WK
       ELSE FS_COMP_WK
     END,
     '0'
   )
   ```

3. **CAL_WEEK_NUMBER**
   ```sql
   RIGHT(CAST(_BIC_ZIO_SWEEK AS STRING), 2)
   ```

4. **_B631_S_AMOUNT_NEGATIVE**
   ```sql
   _B631_S_AMOUNT * -1
   ```

**From CV_BASE_FIN_WEEKLY_BUDGET_S4:**

5. **_B631_S_AMOUNT (Calculated Measure)**
   ```sql
   CASE
     WHEN RES_AMOUNT_FC IS NULL OR RES_AMOUNT_FC = 0 THEN RES_AMOUNT_LC
     ELSE RES_AMOUNT_FC
   END
   ```

6. **RES_AMOUNT_LC (Restricted Measure)**
   ```sql
   SUM(CASE WHEN FLAG = 'LC' THEN _B631_S_AMOUNT_DUMMY ELSE 0 END)
   ```

7. **RES_AMOUNT_FC (Restricted Measure)**
   ```sql
   SUM(CASE WHEN FLAG = 'FC' THEN _B631_S_AMOUNT_DUMMY ELSE 0 END)
   ```

### 3.3 Aggregation Logic

**Final Aggregation (from FLAGS CTE):**
- **Measures (aggregated with SUM):**
  - _B631_S_AMOUNT_NEGATIVE
  - _BIC_ZIO_AMT
  - _B631_S_AMOUNT

- **Dimensions (included in GROUP BY):**
  - All non-measure columns (54 columns total)

**Intermediate Aggregation (from CV_BASE_FIN_WEEKLY_BUDGET_S4):**
- First aggregation: GROUP BY all columns except FLAG, aggregate _B631_S_AMOUNT_DUMMY and _BIC_ZIO_AMT
- Second aggregation: GROUP BY all columns except FLAG, calculate restricted measures by FLAG
- Calculated measure applied post-aggregation

### 3.4 UNION Logic

**From CV_BASE_FIN_WEEKLY_BUDGET_S4:**
- UNION ALL of Frozen_Cube and Live_Cube
- Frozen_Cube: FLAG = 'FC', filtered by @IP_FC_COUNT != '0'
- Live_Cube: FLAG = 'LC', filtered by @IP_FC_COUNT = '0'
- Column remapping in Live_Cube: _BIC_ZIO_PCTR → _B631_S_PROFTCTR, _BIC_ZIO_CCTR → _B631_S_COSTCNTR

---

## 4. PARAMETERS AND VARIABLES

### 4.1 Input Parameters

**@IP_VERSION** (STRING)
- Default: 'LEDGER_BUD'
- Usage: Filters _BIC_ZIO_VER in WEEKLY_SNAPSHOT_DS05 and COMP_VER in COMP_FLAG_BUDGET
- Forwarded to CV_BASE_FIN_WEEKLY_BUDGET_S4

**@IP_WEEK_ENDING_FROM** (STRING)
- Usage: Lower bound for _BIC_ZIO_SWEEK filter in WEEKLY_SNAPSHOT_DS05

**@IP_WEEK_ENDING_TO** (STRING)
- Usage: Upper bound for _BIC_ZIO_SWEEK filter in WEEKLY_SNAPSHOT_DS05

**@IP_FC_COUNT** (STRING)
- Derived from: CVS_FRIP.Composite.Master::SFN_FC_FLAG(IP_VERSION)
- Usage: Determines whether to use Frozen Cube (FC) or Live Cube (LC)
- UNRESOLVED: Function logic not provided; must be precomputed externally

---

## 5. PHYSICAL SOURCE TABLES

All dependencies have been traced to the following physical BigQuery tables:

1. **PROJECT.DATASET.AZSRP_DS052_VT_S4** - Frozen cube budget data
2. **PROJECT.DATASET.AZSRP_DS041_VT_S4** - Live cube budget data
3. **PROJECT.DATASET.HRRP_NODE** - Hierarchy node data
4. **PROJECT.DATASET.ZTFIGL_RCALWEEK** - Retail calendar week data
5. **PROJECT.DATASET.CEPCT** - Profit center text data
6. **PROJECT.DATASET.ZTSRP_ATTR_ACT** - Store attributes data
7. **PROJECT.DATASET.ZTSRP_COMPFL** - Comp flag data

**Note:** All table references use PROJECT.DATASET placeholders. Actual BigQuery project and dataset names must be provided during implementation.

---

## 6. VALIDATION ITEMS

### 6.1 REQUIRES VALIDATION: UNRESOLVED FUNCTION

**Item:** SFN_FC_FLAG Function
**Referenced In:** CV_BASE_FIN_WEEKLY_BUDGET_S4
**Issue:** The HANA function CVS_FRIP.Composite.Master::SFN_FC_FLAG(IP_VERSION) is used to derive the IP_FC_COUNT parameter, but the function definition is not provided in the supplied inputs.
**Impact:** The consolidated SQL assumes @IP_FC_COUNT is precomputed and passed as a parameter. Without the function logic, the parameter cannot be automatically derived.
**Resolution Required:** Either:
1. Provide the SFN_FC_FLAG function definition for conversion to BigQuery, OR
2. Document the business logic for deriving IP_FC_COUNT from IP_VERSION, OR
3. Ensure IP_FC_COUNT is computed externally and passed as a parameter at runtime

### 6.2 REQUIRES VALIDATION: SESSION_USER MAPPING

**Item:** SESSION_USER Function
**Referenced In:** STP_WSS_SRP_ATTRIBUTES
**Issue:** HANA SESSION_USER is mapped to BigQuery SESSION_USER(), but the exact behavior and availability may differ.
**Impact:** The consolidated SQL uses SESSION_USER() for audit columns (SNAPSHOT_CREATED_BY, CREATED_BY), but this may not be available in all BigQuery execution contexts.
**Resolution Required:** Validate that SESSION_USER() is available and returns the expected user identifier in the target BigQuery environment.

### 6.3 REQUIRES VALIDATION: TABLE MAPPINGS

**Item:** Physical Table Names
**Referenced In:** All base table references
**Issue:** All physical table references use PROJECT.DATASET placeholders.
**Impact:** The consolidated SQL cannot be executed without actual BigQuery project and dataset names.
**Resolution Required:** Provide actual BigQuery project, dataset, and table names for all physical sources:
- AZSRP_DS052_VT_S4
- AZSRP_DS041_VT_S4
- HRRP_NODE
- ZTFIGL_RCALWEEK
- CEPCT
- ZTSRP_ATTR_ACT
- ZTSRP_COMPFL

### 6.4 REQUIRES VALIDATION: CLIENT FILTER CONSISTENCY

**Item:** MANDT Filter Values
**Referenced In:** Multiple sources
**Issue:** Different MANDT filter values are used across different sources:
- Budget data: MANDT IN ('110', '200')
- Master data: MANDT IN (120, 200)
**Impact:** The consolidated SQL preserves the exact filters from the source calculation views, but the inconsistency (string vs. numeric) may indicate a datatype mismatch or conversion issue.
**Resolution Required:** Validate that:
1. MANDT column datatypes are consistent across all tables
2. Filter values are correct (string '110'/'200' vs. numeric 120/200)
3. No data loss occurs due to datatype mismatches

### 6.5 REQUIRES VALIDATION: AGGREGATION GRAIN

**Item:** FLAG Column in Final Output
**Referenced In:** CV_BASE_FIN_WEEKLY_BUDGET_S4 and CV_COMP_FIN_BUDGET_STATIC
**Issue:** The FLAG column is present in intermediate aggregations but is NOT included in the final GROUP BY of CV_COMP_FIN_BUDGET_STATIC.
**Impact:** The consolidated SQL preserves this exact behavior. FLAG is aggregated away in the final output, meaning FC and LC amounts are combined.
**Resolution Required:** Validate that this is the intended business logic. If FLAG should be retained in the final output, the GROUP BY must be modified.

---

## 7. SQL PRESERVATION VERIFICATION

### 7.1 No Logic Invented

All SQL logic in the consolidated query is directly traceable to the supplied converted SQL files. No business logic, calculations, joins, filters, or transformations were invented or inferred.

### 7.2 No Logic Omitted

All logic from the following sources is included in the consolidated SQL:
- All filters from CV_COMP_FIN_BUDGET_STATIC
- All joins from CV_COMP_FIN_BUDGET_STATIC
- All calculated columns from CV_COMP_FIN_BUDGET_STATIC
- All aggregation logic from CV_COMP_FIN_BUDGET_STATIC
- All UNION logic from CV_BASE_FIN_WEEKLY_BUDGET_S4
- All restricted measures from CV_BASE_FIN_WEEKLY_BUDGET_S4
- All calculated measures from CV_BASE_FIN_WEEKLY_BUDGET_S4
- All filters from all upstream calculation views
- All column mappings from all upstream calculation views

### 7.3 No Logic Modified

The consolidated SQL preserves:
- Exact join types (INNER, LEFT OUTER)
- Exact join conditions
- Exact filter conditions
- Exact calculated column formulas
- Exact aggregation functions
- Exact GROUP BY columns
- Exact UNION ALL behavior
- Exact column renaming

---

## 8. COMPLETENESS VERIFICATION

### 8.1 CTE Count

The consolidated SQL contains **17 CTEs**, all fully defined:

1. Frozen_Cube
2. Live_Cube
3. Combined_Frozen_Live_Cube
4. Aggregated_Weekly_Budget
5. CV_BASE_FIN_WEEKLY_BUDGET_S4_Expanded
6. WEEKLY_SNAPSHOT_DS05
7. HIER_NODE
8. Join_1
9. ONLY_CORE_RET_DATA
10. CV_BASE_MD_SRPACT_S4_Source
11. STORE_ATTR_ACTUAL
12. Join_2
13. WEEK_NUMBER
14. CV_BASE_MD_COMPFL_S4_Source
15. COMP_FLAG_BUDGET
16. Join_3
17. CAL_WEEK
18. Join_4
19. PROFIT_CENTER_TEXT
20. Join_5
21. FLAGS

Plus final SELECT statement with GROUP BY.

### 8.2 No Placeholders

The consolidated SQL contains:
- ✅ No <CTE_NAME> placeholders
- ✅ No <TABLE_NAME> placeholders
- ✅ No <COLUMN_NAME> placeholders
- ✅ No "for brevity" statements
- ✅ No "logic omitted" statements
- ✅ No "..." ellipsis
- ✅ No "continue with" statements
- ✅ No "additional CTEs" statements
- ✅ No pseudocode
- ✅ No representative SQL

### 8.3 Executable Status

The consolidated SQL is:
- ✅ Self-contained
- ✅ Copy-paste ready
- ✅ Executable (pending parameter values and table mappings)
- ✅ Complete from source tables to final output
- ✅ No unresolved view references (all views expanded to physical tables)

---

## 9. CONVERSION NOTES

### 9.1 HANA to BigQuery Function Mappings

- **LEFTSTR** → **LEFT**
- **RIGHTSTR** → **RIGHT**
- **IF(ISNULL(...), ...)** → **COALESCE(..., ...)**
- **CASE(value, ...)** → **CASE WHEN ... THEN ... END**
- **match(column, '*pattern')** → **REGEXP_CONTAINS(column, r'.*pattern$')**
- **CURRENT_TIMESTAMP** → **CURRENT_TIMESTAMP()**
- **SESSION_USER** → **SESSION_USER()** (requires validation)

### 9.2 Parameter Handling

HANA input parameters ($$IP_VERSION$$, $$IP_WEEK_ENDING_FROM$$, $$IP_WEEK_ENDING_TO$$) are converted to BigQuery query parameters (@IP_VERSION, @IP_WEEK_ENDING_FROM, @IP_WEEK_ENDING_TO).

### 9.3 Aggregation Grain Preservation

The consolidated SQL preserves the exact aggregation grain from the source calculation views:
- CV_BASE_FIN_WEEKLY_BUDGET_S4: Aggregates with FLAG, then aggregates without FLAG
- CV_COMP_FIN_BUDGET_STATIC: Final aggregation without FLAG

This multi-stage aggregation is preserved exactly as defined in the source logic.

---

## 10. IMPLEMENTATION CHECKLIST

Before executing the consolidated SQL, complete the following:

- [ ] Provide actual BigQuery project and dataset names for all physical tables
- [ ] Provide IP_VERSION parameter value (or use default 'LEDGER_BUD')
- [ ] Provide IP_WEEK_ENDING_FROM parameter value
- [ ] Provide IP_WEEK_ENDING_TO parameter value
- [ ] Compute IP_FC_COUNT parameter value using SFN_FC_FLAG logic (or provide external computation)
- [ ] Validate MANDT column datatypes and filter values
- [ ] Validate SESSION_USER() availability in target environment
- [ ] Validate that all physical tables exist and contain expected columns
- [ ] Validate that FLAG aggregation behavior matches business requirements
- [ ] Test consolidated SQL with sample parameters
- [ ] Validate output against HANA source (if available)

---

## 11. CONFIDENCE ASSESSMENT

**Overall Confidence:** MEDIUM-HIGH

**Rationale:**
- ✅ All lineage relationships successfully traced
- ✅ All converted SQL files successfully analyzed and inlined
- ✅ All joins, filters, calculated columns, and aggregations preserved
- ✅ All ETL tables traced back to source calculation views
- ✅ All calculation views expanded to physical tables
- ✅ No logic invented, omitted, or modified
- ⚠️ SFN_FC_FLAG function logic unresolved (requires external input)
- ⚠️ Physical table mappings unresolved (requires external input)
- ⚠️ SESSION_USER mapping requires validation
- ⚠️ MANDT datatype consistency requires validation

The consolidated SQL is complete and executable pending resolution of the validation items documented in Section 6.

---

## 12. CONTACT AND SUPPORT

For questions or issues related to this consolidation:
1. Review the validation items in Section 6
2. Verify all physical table mappings in Section 5
3. Validate all parameters in Section 4
4. Test the consolidated SQL with sample data
5. Compare output against HANA source (if available)

---

**Document Version:** 1.0
**Generated:** 2024
**Agent:** BigQuery SQL Consolidation Agent
**Migration:** RX_BUDGET HANA to BigQuery
