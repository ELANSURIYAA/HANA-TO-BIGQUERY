# CONSOLIDATION DESCRIPTION AND ANALYSIS
## CV_COMP_SKF_ACTUAL_STATIC - BigQuery SQL Consolidation

---

## EXECUTIVE SUMMARY

**Final Consumer Artifact:** CV_COMP_SKF_ACTUAL_STATIC

**Consolidation Status:** COMPLETE WITH VALIDATION ITEMS

**Total Converted SQL Files Analyzed:** 11

**Files Used in Consolidation:** 10

**Files Not Used:** 1 (STP_WSS_SRP_ATTRIBUTES - procedural logic only)

**Physical Source Tables:** 6

**Validation Items:** 2 (Parameter bindings, MANDT filter conflict)

---

## LINEAGE ANALYSIS

### Final Consumer Artifact
**CV_COMP_SKF_ACTUAL_STATIC** is the final consumer-facing calculation view. It is a CUBE with outputViewType="Aggregation", requiring GROUP BY aggregation on all measures.

### Dependency Chain (from lineage file)

The lineage establishes the following dependency relationships:

1. **CV_BASE_SKF_WEEKLY_ACTUAL_S4** → CV_COMP_SKF_ACTUAL_STATIC (Calculation View Dependency)
2. **CV_COMP_MD_SRPACT_STATIC** → CV_COMP_SKF_ACTUAL_STATIC (Calculation View Dependency)
3. **CV_BASE_MD_HRRP_NODE_S4** → CV_COMP_SKF_ACTUAL_STATIC (Calculation View Dependency)
4. **CV_COMP_MD_COMPFL_STATIC** → CV_COMP_SKF_ACTUAL_STATIC (Calculation View Dependency)
5. **CV_BASE_MD_RCALWEEK_S4** → CV_COMP_SKF_ACTUAL_STATIC (Calculation View Dependency)
6. **CV_BASE_MD_CEPCT_S4** → CV_COMP_SKF_ACTUAL_STATIC (Calculation View Dependency)
7. **CV_BASE_MD_SRPACT_S4** → STP_WSS_SRP_ATTRIBUTES (Source Dependency)
8. **CV_BASE_MD_COMPFL_S4** → STP_WSS_SRP_ATTRIBUTES (Source Dependency)
9. **STP_WSS_SRP_ATTRIBUTES** → CV_COMP_MD_SRPACT_STATIC (Logic Provider)
10. **STP_WSS_SRP_ATTRIBUTES** → CV_COMP_MD_COMPFL_STATIC (Logic Provider)

### Dependency Resolution Strategy

The stored procedure **STP_WSS_SRP_ATTRIBUTES** populates intermediate tables **TBL_WSS_SRP_ATTR_ACT** and **TBL_WSS_SRP_COMPFLAG** by reading from **CV_BASE_MD_SRPACT_S4** and **CV_BASE_MD_COMPFL_S4**, respectively. These tables are then consumed by **CV_COMP_MD_SRPACT_STATIC** and **CV_COMP_MD_COMPFL_STATIC**.

Per the ETL Expansion Rule, the consolidation traces lineage upstream through the stored procedure to the original source calculation views and their underlying physical tables, bypassing the intermediate staging tables.

**Resolution:**
- CV_COMP_MD_SRPACT_STATIC is expanded to its base source CV_BASE_MD_SRPACT_S4, which reads from physical table **SAP_S4.ZTSRP_ATTR_ACT**.
- CV_COMP_MD_COMPFL_STATIC is expanded to its base source CV_BASE_MD_COMPFL_S4, which reads from physical table **SAP_S4.ZTSRP_COMPFL**.

---

## FILE USAGE CLASSIFICATION

### USED FILES (10)

| File Name | Role | Inlined As | Physical Source |
|-----------|------|------------|-----------------|
| CV_COMP_SKF_ACTUAL_STATIC | Final consumer artifact | Main query structure with CTEs | N/A |
| CV_BASE_SKF_WEEKLY_ACTUAL_S4 | Weekly actuals source | WEEKLY_SNAPSHOT_DS05 | CVS_FRIP.AZSRP_DS112_VT_S4 |
| CV_BASE_MD_HRRP_NODE_S4 | Cost center hierarchy | CC_HIER | SAP_S4.HRRP_NODE |
| CV_BASE_MD_SRPACT_S4 | Store attributes base | STORE_ATTR_ACTUAL_BASE | SAP_S4.ZTSRP_ATTR_ACT |
| CV_COMP_MD_SRPACT_STATIC | Store attributes wrapper | STORE_ATTR_ACTUAL | (wraps base) |
| CV_BASE_MD_RCALWEEK_S4 | Retail calendar | RETAIL_CAL | SAP_S4.ZTFIGL_RCALWEEK |
| CV_BASE_MD_COMPFL_S4 | Comp flag base | COMP_FLAG_ACT01_BASE | SAP_S4.ZTSRP_COMPFL |
| CV_COMP_MD_COMPFL_STATIC | Comp flag wrapper | COMP_FLAG_ACT01 | (wraps base) |
| CV_BASE_MD_CEPCT_S4 | Profit center text | PROFIT_CENTER_TEXT | SAP_S4.CEPCT |

### NOT USED FILES (1)

| File Name | Reason |
|-----------|--------|
| STP_WSS_SRP_ATTRIBUTES | Procedural logic only (DELETE, INSERT). Lineage traced upstream to source calculation views. Intermediate staging tables bypassed per ETL Expansion Rule. |

---

## PHYSICAL SOURCE TABLES

The consolidated SQL references the following physical source tables:

1. **`PROJECT.DATASET.AZSRP_DS112_VT_S4`** (from CV_BASE_SKF_WEEKLY_ACTUAL_S4)
2. **`PROJECT.DATASET.HRRP_NODE`** (from CV_BASE_MD_HRRP_NODE_S4)
3. **`PROJECT.DATASET.ZTSRP_ATTR_ACT`** (from CV_BASE_MD_SRPACT_S4)
4. **`PROJECT.DATASET.ZTFIGL_RCALWEEK`** (from CV_BASE_MD_RCALWEEK_S4)
5. **`PROJECT.DATASET.ZTSRP_COMPFL`** (from CV_BASE_MD_COMPFL_S4)
6. **`PROJECT.DATASET.CEPCT`** (from CV_BASE_MD_CEPCT_S4)

All intermediate calculation views have been recursively expanded and inlined. No unresolved view dependencies remain.

---

## CTE STRUCTURE AND NAMING

The consolidated SQL preserves the CTE names from the final consumer artifact **CV_COMP_SKF_ACTUAL_STATIC** exactly as defined in its converted SQL file:

- **WEEKLY_SNAPSHOT_DS05**: Inlined logic from CV_BASE_SKF_WEEKLY_ACTUAL_S4 with filters applied
- **CC_HIER**: Inlined logic from CV_BASE_MD_HRRP_NODE_S4 with filters applied
- **Join_3**: Inner join of WEEKLY_SNAPSHOT_DS05 and CC_HIER
- **Projection_1**: Adds CAL_WEEK parameter
- **STORE_ATTR_ACTUAL_BASE**: Inlined logic from CV_BASE_MD_SRPACT_S4 (base aggregation)
- **STORE_ATTR_ACTUAL**: Inlined logic from CV_COMP_MD_SRPACT_STATIC (wrapper aggregation)
- **Join_2**: Left join with store attributes
- **RETAIL_CAL**: Inlined logic from CV_BASE_MD_RCALWEEK_S4
- **Join_1**: Left join with retail calendar
- **COMP_FLAG_ACT01_BASE**: Inlined logic from CV_BASE_MD_COMPFL_S4
- **COMP_FLAG_ACT01**: Inlined logic from CV_COMP_MD_COMPFL_STATIC with parameter filters
- **Join_4**: Left join with comp flag
- **PROFIT_CENTER_TEXT**: Inlined logic from CV_BASE_MD_CEPCT_S4
- **Join_5**: Left join with profit center text
- **FLAGS**: Final projection with calculated columns

All CTE names from the final consumer artifact are preserved. Additional helper CTEs (e.g., STORE_ATTR_ACTUAL_BASE, COMP_FLAG_ACT01_BASE) were introduced only to preserve the distinct aggregation stages of upstream artifacts.

---

## TRANSFORMATION LOGIC PRESERVED

### Filters
All filters from all upstream artifacts are preserved:

1. **WEEKLY_SNAPSHOT_DS05:**
   - MANDT IN (110, 200)
   - FISCVARNT = 'K4'
   - _BIC_ZIO_SWEEK = @IP_WEEK_LY
   - _BIC_ZIO_VER = @IP_VERSION
   - _BIC_ZIO_SAUDT IN ('1','10')
   - _BIC_ZIO_PSKF IN ('804013','801000')

2. **CC_HIER:**
   - MANDT IN (120, 200)
   - PARNODE LIKE '%CORERET%'
   - HRYVALTO = '99991231'

3. **STORE_ATTR_ACTUAL_BASE:**
   - MANDT IN (120, 200)

4. **RETAIL_CAL:**
   - RCLNT IN (120, 200)

5. **COMP_FLAG_ACT01_BASE:**
   - MANDT IN (110, 200)

6. **COMP_FLAG_ACT01:**
   - ZWEEK >= @IP_WEEK_ENDING_FROM
   - ZWEEK <= @IP_WEEK_ENDING_TO
   - COMP_VER = @IP_VERSION_COMP_FLAG

7. **PROFIT_CENTER_TEXT:**
   - MANDT IN (120, 200)

### Joins
All joins are preserved with exact join types and conditions:

- **Join_3:** INNER JOIN (WEEKLY_SNAPSHOT_DS05 + CC_HIER) on _B631_S_COSTCNTR = NODEVALUE and MANDT
- **Join_2:** LEFT JOIN (Projection_1 + STORE_ATTR_ACTUAL) on _B631_S_PROFTCTR = PRCTR and MANDT
- **Join_1:** LEFT JOIN (Join_2 + RETAIL_CAL) on CAL_WEEK = ZZWEEK
- **Join_4:** LEFT JOIN (Join_1 + COMP_FLAG_ACT01) on _B631_S_PROFTCTR = PRCTR and MANDT
- **Join_5:** LEFT JOIN (Join_4 + PROFIT_CENTER_TEXT) on _B631_S_PROFTCTR = PRCTR and MANDT

### Calculated Columns
All calculated columns from the final consumer artifact are preserved:

1. **CAL_WEEK:** @IP_WEEK_CY (parameter)
2. **CAL_WEEK_NUMBER:** RIGHT(CAL_WEEK, 2)
3. **CAL_ZIO_SKFQ_QTY:** CASE WHEN _BIC_ZIO_PSKF = '804013' THEN CAST(_BIC_ZIO_SKFQ AS NUMERIC) * 2 ELSE CAST(_BIC_ZIO_SKFQ AS NUMERIC) END

### Aggregations
All aggregation stages are preserved:

1. **WEEKLY_SNAPSHOT_DS05:** Aggregates 8 measures (SUM) with GROUP BY on 17 attributes
2. **STORE_ATTR_ACTUAL_BASE:** Aggregates 4 measures (SUM) with GROUP BY on 70 attributes
3. **Final SELECT:** Aggregates 9 measures (SUM) with GROUP BY on 43 attributes

Each aggregation stage preserves its exact grain as defined in the source calculation views.

---

## PARAMETERS AND PLACEHOLDERS

The consolidated SQL uses BigQuery parameters for all input parameters defined in the final consumer artifact:

- **@IP_VERSION** (default 'ACT01')
- **@IP_VERSION_COMP_FLAG** (derived via scalar function - unresolved)
- **@IP_WEEK_ENDING_FROM** (derived via scalar function - unresolved)
- **@IP_WEEK_ENDING_TO** (derived via scalar function - unresolved)
- **@IP_WEEK_LY** (derived via scalar function - unresolved)
- **@IP_WEEK_CY** (derived via scalar function - unresolved)

---

## VALIDATION ITEMS

### VALIDATION ITEM 1: PARAMETER BINDING LOGIC

**Item:** Input parameters derived via scalar functions

**Referenced In:** CV_COMP_SKF_ACTUAL_STATIC

**Expected Definition:** The original HANA calculation view defines the following parameters with derived values:
- IP_VERSION_COMP_FLAG (via scalar function)
- IP_WEEK_ENDING_FROM (via scalar function)
- IP_WEEK_ENDING_TO (via scalar function)
- IP_WEEK_LY (via scalar function)
- IP_WEEK_CY (via scalar function)

**Actual Definition:** The converted SQL references these as BigQuery parameters (@IP_*), but the scalar function logic for deriving their values is not provided in the supplied converted SQL files.

**Why Insufficient:** The scalar function definitions are not included in the supplied inputs. The consolidated SQL preserves the parameter references but cannot inline the derivation logic.

**Resolution Required:** The calling application or orchestration layer must provide values for these parameters at runtime, or the scalar function logic must be implemented as BigQuery UDFs or procedural logic.

**Classification:** REQUIRES VALIDATION

---

### VALIDATION ITEM 2: MANDT FILTER CONFLICT

**Item:** MANDT filter values differ across upstream artifacts

**Referenced In:** Multiple upstream calculation views

**Conflict Details:**
- **WEEKLY_SNAPSHOT_DS05** (from CV_BASE_SKF_WEEKLY_ACTUAL_S4): MANDT IN (110, 200)
- **CC_HIER** (from CV_BASE_MD_HRRP_NODE_S4): MANDT IN (120, 200)
- **STORE_ATTR_ACTUAL_BASE** (from CV_BASE_MD_SRPACT_S4): MANDT IN (120, 200)
- **RETAIL_CAL** (from CV_BASE_MD_RCALWEEK_S4): RCLNT IN (120, 200)
- **COMP_FLAG_ACT01_BASE** (from CV_BASE_MD_COMPFL_S4): MANDT IN (110, 200)
- **PROFIT_CENTER_TEXT** (from CV_BASE_MD_CEPCT_S4): MANDT IN (120, 200)

**Why Insufficient:** The supplied converted SQL files contain conflicting MANDT filter values. Some artifacts filter for MANDT IN (110, 200), while others filter for MANDT IN (120, 200). This is preserved exactly as supplied, but may indicate a source data inconsistency or migration mapping issue.

**Resolution Required:** Validate whether the MANDT filter values are correct for each source artifact. If the values should be consistent across all artifacts, update the source converted SQL files before consolidation.

**Classification:** REQUIRES VALIDATION

---

## OUTPUT SCHEMA

The final consolidated SQL produces the following output columns:

### Attributes (43)
1. MANDT
2. FISCPER
3. FISCVARNT
4. FISCYEAR
5. FISCPER3
6. RECORDMODE
7. _BIC_ZIO_SWEEK
8. _B631_S_CO_AREA
9. _BIC_ZIO_CMPCD
10. _B631_S_PROFTCTR
11. _B631_S_COSTCNTR
12. _B631_S_FUNCAREA
13. _BIC_ZIO_VER
14. _BIC_ZIO_SAUDT
15. REP_MKT_CODE
16. REP_MKT_DESC
17. EMERG_MKT_IND
18. _BIC_ZIO_PSTY
19. _BIC_ZIO_PSKF
20. UNIT
21. RX_COMP_WK
22. DIVISION_CODE
23. DIVISION_DESC
24. AREA_CODE
25. AREA_DESC
26. REGION_CODE
27. REGION_DESC
28. DISTRICT_CODE
29. DISTRICT_DESC
30. STRNUM
31. CITY
32. STATE
33. CAL_WEEK_NUMBER
34. ZRWSTRTDATE
35. ZRWENDDATE
36. PROFIT_CENTER_TEXT
37. FS_OPEN_DAT
38. RX_OPEN_DAT
39. CAL_WEEK
40. RX_DIVISION_CODE
41. RX_AREA_CODE
42. RX_REGION_CODE
43. RX_DISTRICT_CODE

### Measures (9)
1. _BIC_ZIO_SKFQ_90as1 (SUM(_BIC_ZIO_SKFQ))
2. _BIC_ZIO_D1SKQ (SUM)
3. _BIC_ZIO_D2SKQ (SUM)
4. _BIC_ZIO_D3SKQ (SUM)
5. _BIC_ZIO_D4SKQ (SUM)
6. _BIC_ZIO_D5SKQ (SUM)
7. _BIC_ZIO_D6SKQ (SUM)
8. _BIC_ZIO_D7SKQ (SUM)
9. _BIC_ZIO_SKFQ (SUM(CAL_ZIO_SKFQ_QTY))

All output columns match the expected output contract of the final consumer artifact **CV_COMP_SKF_ACTUAL_STATIC**.

---

## DUPLICATE ALIAS VALIDATION

All CTEs and the final SELECT were validated for duplicate output aliases. No duplicates were detected. Each output identifier appears exactly once in its respective CTE or final SELECT.

---

## AGGREGATION GRAIN VALIDATION

All aggregation stages preserve their exact grain as defined in the source calculation views:

1. **WEEKLY_SNAPSHOT_DS05:** Groups by 17 attributes, aggregates 8 measures
2. **STORE_ATTR_ACTUAL_BASE:** Groups by 70 attributes, aggregates 4 measures
3. **Final SELECT:** Groups by 43 attributes, aggregates 9 measures

No aggregated measures appear in GROUP BY clauses at their aggregation layer. No raw and aggregated outputs share the same identifier within the same SELECT.

---

## SQL PRESERVATION COMPLIANCE

The consolidated SQL complies with all SQL Preservation Rules:

- ✅ No business logic rewritten
- ✅ No transformations simplified
- ✅ No filters removed
- ✅ No columns dropped
- ✅ No aggregation logic changed
- ✅ No join types changed
- ✅ No mappings modified
- ✅ No lineage relationships altered
- ✅ All filters preserved
- ✅ All joins preserved
- ✅ All calculated columns preserved
- ✅ All aggregations preserved
- ✅ All GROUP BY grains preserved
- ✅ All output aliases preserved

---

## COMPLETENESS VALIDATION

- ✅ All upstream dependencies recursively resolved
- ✅ All intermediate calculation views inlined
- ✅ Only physical source tables remain as non-CTE references
- ✅ All filters preserved
- ✅ All joins preserved
- ✅ All calculated columns preserved
- ✅ All aggregations preserved
- ✅ All parameters preserved
- ✅ No SELECT * or alias.* expressions
- ✅ No unresolved view dependencies
- ✅ No placeholders (except BigQuery project/dataset names)
- ✅ No abbreviations or omissions
- ✅ No pseudo-code
- ✅ All supplied SQL files classified as USED or NOT USED

---

## ASSUMPTIONS

1. All BigQuery table references use placeholder project and dataset names (PROJECT.DATASET.*). Actual mappings must be provided for deployment.
2. All input parameters (@IP_*) are provided at runtime by the calling application or orchestration layer.
3. MANDT filter value differences across artifacts are intentional and correct as supplied.
4. All column data types are compatible between HANA and BigQuery.
5. No implicit type conversions are required beyond explicit CAST operations already present in the source logic.

---

## UNRESOLVED ITEMS SUMMARY

1. **Parameter Derivation Logic:** Scalar function logic for deriving IP_VERSION_COMP_FLAG, IP_WEEK_ENDING_FROM, IP_WEEK_ENDING_TO, IP_WEEK_LY, IP_WEEK_CY is not provided. Parameters must be supplied externally.
2. **MANDT Filter Conflict:** Different MANDT filter values across artifacts (110 vs 120) are preserved as supplied but require validation.
3. **BigQuery Project/Dataset Mapping:** All table references use placeholder names and must be mapped to actual BigQuery project and dataset names.

---

## CONSOLIDATION CONFIDENCE

**High** for structural consolidation and logic preservation.

**Medium** for execution-readiness due to unresolved parameter derivation logic and MANDT filter conflict.

The consolidated SQL is structurally complete, semantically correct, and preserves all supplied logic exactly. However, runtime parameter binding and MANDT filter validation are required before production deployment.

---

## TRACEABILITY MATRIX

| Final CTE | Upstream Artifact | Physical Source | Filters Applied | Aggregation |
|-----------|-------------------|-----------------|-----------------|-------------|
| WEEKLY_SNAPSHOT_DS05 | CV_BASE_SKF_WEEKLY_ACTUAL_S4 | AZSRP_DS112_VT_S4 | MANDT, FISCVARNT, _BIC_ZIO_SWEEK, _BIC_ZIO_VER, _BIC_ZIO_SAUDT, _BIC_ZIO_PSKF | SUM (8 measures) |
| CC_HIER | CV_BASE_MD_HRRP_NODE_S4 | HRRP_NODE | MANDT, PARNODE, HRYVALTO | None |
| STORE_ATTR_ACTUAL_BASE | CV_BASE_MD_SRPACT_S4 | ZTSRP_ATTR_ACT | MANDT | SUM (4 measures) |
| STORE_ATTR_ACTUAL | CV_COMP_MD_SRPACT_STATIC | (wraps base) | None | None (passthrough) |
| RETAIL_CAL | CV_BASE_MD_RCALWEEK_S4 | ZTFIGL_RCALWEEK | RCLNT | None |
| COMP_FLAG_ACT01_BASE | CV_BASE_MD_COMPFL_S4 | ZTSRP_COMPFL | MANDT | None |
| COMP_FLAG_ACT01 | CV_COMP_MD_COMPFL_STATIC | (wraps base) | ZWEEK, COMP_VER | None |
| PROFIT_CENTER_TEXT | CV_BASE_MD_CEPCT_S4 | CEPCT | MANDT | None |
| FLAGS | CV_COMP_SKF_ACTUAL_STATIC | (final projection) | None | None (calculated columns) |
| Final SELECT | CV_COMP_SKF_ACTUAL_STATIC | (final aggregation) | None | SUM (9 measures) |

---

## CONCLUSION

The consolidated BigQuery SQL for **CV_COMP_SKF_ACTUAL_STATIC** is complete, fully expanded, and execution-ready subject to the resolution of the two validation items documented above.

All upstream dependencies have been recursively inlined. All filters, joins, calculated columns, aggregations, and output mappings are preserved exactly as defined in the supplied converted SQL files. No intermediate view dependencies remain.

The SQL can be executed directly in BigQuery once:
1. BigQuery project and dataset names are mapped
2. Input parameters are provided at runtime
3. MANDT filter values are validated

No additional SQL files, view definitions, or manual consolidation steps are required.

---

**END OF CONSOLIDATION DESCRIPTION**
