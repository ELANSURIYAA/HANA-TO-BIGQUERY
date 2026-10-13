# BigQuery Validation Report

## Overall Validation Summary

| Metric | Result |
|---|---|
| Completeness Score | 95.45% (21/22 checks passed) |
| Accuracy Score | 100.00% (18/18 checks passed) |
| Efficiency Score | 100.00% (10/10 checks passed) |
| Overall Status | PASS WITH WARNINGS |
| Files Excluded (unparseable) | None |

---

## Completeness Assessment

| Severity | File | Issue | Recommendation |
|---|---|---|---|
| WARNING | CV_COMP_SKF_ACTUAL_STATIC | References external Calculation Views as dependencies (CV_BASE_SKF_WEEKLY_ACTUAL_S4, CV_COMP_MD_SRPACT_STATIC, CV_BASE_MD_HRRP_NODE_S4, CV_COMP_MD_COMPFL_STATIC, CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_CEPCT_S4) but these are treated as external tables/views in the converted SQL. The Consolidated File inlines all this logic, while the Individual File references them as external objects. | Verify that the external Calculation View references in CV_COMP_SKF_ACTUAL_STATIC are correctly mapped to the inlined CTEs in the Consolidated File. |
| INFO | Consolidated File vs Individual Files | All base tables referenced in the Consolidated File (AZSRP_DS112_VT_S4, ZTSRP_ATTR_ACT, HRRP_NODE, ZTSRP_COMPFL, ZTFIGL_RCALWEEK, CEPCT) are present across the Individual Files. | No action required. |
| INFO | Consolidated File vs Individual Files | All key columns used in joins, filters, and aggregations in the Consolidated File are present in the corresponding Individual Files. | No action required. |
| INFO | Consolidated File vs Individual Files | All filters applied in the Consolidated File match the filters defined in the corresponding Individual Files. | No action required. |
| INFO | Consolidated File vs Individual Files | All calculated columns (CAL_WEEK, CAL_WEEK_NUMBER, CAL_ZIO_SKFQ_QTY) in the Consolidated File are present in CV_COMP_SKF_ACTUAL_STATIC. | No action required. |
| INFO | Consolidated File vs Individual Files | All input parameters (@IP_VERSION, @IP_VERSION_COMP_FLAG, @IP_WEEK_ENDING_FROM, @IP_WEEK_ENDING_TO, @IP_WEEK_LY, @IP_WEEK_CY) referenced in the Consolidated File are defined in CV_COMP_SKF_ACTUAL_STATIC. | No action required. |
| INFO | Consolidated File vs Individual Files | All measures (_BIC_ZIO_SKFQ, _BIC_ZIO_D1SKQ through _BIC_ZIO_D7SKQ, CAL_ZIO_SKFQ_QTY) in the Consolidated File are present in the Individual Files. | No action required. |
| INFO | Consolidated File vs Individual Files | The final aggregation logic (GROUP BY all non-measure columns, SUM all measures) in the Consolidated File matches the aggregation semantics defined in CV_COMP_SKF_ACTUAL_STATIC. | No action required. |
| INFO | Consolidated File vs Individual Files | All join conditions (INNER JOIN on CC_HIER, LEFT JOIN on STORE_ATTR_ACTUAL, RETAIL_CAL, COMP_FLAG_ACT01, PROFIT_CENTER_TEXT) in the Consolidated File match the join definitions in CV_COMP_SKF_ACTUAL_STATIC. | No action required. |
| INFO | STP_WSS_SRP_ATTRIBUTES | The stored procedure logic is present as a separate Individual File. It populates tables TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG, which are referenced in CV_COMP_MD_SRPACT_STATIC and CV_COMP_MD_COMPFL_STATIC respectively. | No action required. |

---

## Accuracy Assessment

| Severity | File | Issue | Recommendation |
|---|---|---|---|
| INFO | Consolidated File vs Individual Files | Table names in the Consolidated File match the source tables defined in the Individual Files: AZSRP_DS112_VT_S4 (CV_BASE_SKF_WEEKLY_ACTUAL_S4), ZTSRP_ATTR_ACT (CV_BASE_MD_SRPACT_S4), HRRP_NODE (CV_BASE_MD_HRRP_NODE_S4), ZTSRP_COMPFL (CV_BASE_MD_COMPFL_S4), ZTFIGL_RCALWEEK (CV_BASE_MD_RCALWEEK_S4), CEPCT (CV_BASE_MD_CEPCT_S4). | No action required. |
| INFO | Consolidated File vs Individual Files | Column names used in the Consolidated File match the column mappings defined in the Individual Files across all base views and composite views. | No action required. |
| INFO | Consolidated File vs Individual Files | Filter conditions in the Consolidated File are consistent with the Individual Files: MANDT filters (110/200 for AZSRP_DS112_VT_S4 and ZTSRP_COMPFL; 120/200 for HRRP_NODE, ZTFIGL_RCALWEEK, CEPCT, ZTSRP_ATTR_ACT), FISCVARNT='K4', PARNODE LIKE '%CORERET%', HRYVALTO='99991231', and parameter-based filters. | No action required. |
| INFO | Consolidated File vs Individual Files | Join keys in the Consolidated File match the join definitions in CV_COMP_SKF_ACTUAL_STATIC: _B631_S_COSTCNTR=NODEVALUE (CC_HIER), _B631_S_PROFTCTR=PRCTR (STORE_ATTR_ACTUAL, COMP_FLAG_ACT01, PROFIT_CENTER_TEXT), CAL_WEEK=ZZWEEK (RETAIL_CAL), all with MANDT equality. | No action required. |
| INFO | Consolidated File vs Individual Files | Calculated column logic is consistent: CAL_WEEK=@IP_WEEK_CY, CAL_WEEK_NUMBER=RIGHT(CAL_WEEK,2), CAL_ZIO_SKFQ_QTY=CASE WHEN _BIC_ZIO_PSKF='804013' THEN _BIC_ZIO_SKFQ*2 ELSE _BIC_ZIO_SKFQ END. | No action required. |
| INFO | Consolidated File vs Individual Files | Aggregation logic is consistent: All measures use SUM aggregation, all non-measure columns are grouped, matching the CUBE/Aggregation semantics defined in CV_BASE_SKF_WEEKLY_ACTUAL_S4, CV_BASE_MD_SRPACT_S4, CV_COMP_MD_SRPACT_STATIC, and CV_COMP_SKF_ACTUAL_STATIC. | No action required. |
| INFO | Consolidated File vs Individual Files | The final SELECT output columns in the Consolidated File match the logical model output columns defined in CV_COMP_SKF_ACTUAL_STATIC, including the aliasing of _BIC_ZIO_SKFQ to _BIC_ZIO_SKFQ_90as1 and the separate aggregation of CAL_ZIO_SKFQ_QTY as _BIC_ZIO_SKFQ. | No action required. |
| INFO | CV_COMP_MD_SRPACT_STATIC vs CV_BASE_MD_SRPACT_S4 | CV_COMP_MD_SRPACT_STATIC sources from TBL_WSS_SRP_ATTR_ACT (a table), while CV_BASE_MD_SRPACT_S4 sources from ZTSRP_ATTR_ACT (a table). Both have the same column structure and aggregation logic. This is a valid implementation difference where the static view uses a snapshot table populated by STP_WSS_SRP_ATTRIBUTES. | No action required. |
| INFO | CV_COMP_MD_COMPFL_STATIC vs CV_BASE_MD_COMPFL_S4 | CV_COMP_MD_COMPFL_STATIC sources from TBL_WSS_SRP_COMPFLAG (a table), while CV_BASE_MD_COMPFL_S4 sources from ZTSRP_COMPFL (a table). Both have the same column structure. This is a valid implementation difference where the static view uses a snapshot table populated by STP_WSS_SRP_ATTRIBUTES. | No action required. |
| INFO | Consolidated File | The Consolidated File correctly inlines the logic from CV_BASE_SKF_WEEKLY_ACTUAL_S4 (including aggregation), CV_BASE_MD_HRRP_NODE_S4, CV_BASE_MD_SRPACT_S4 (including aggregation), CV_BASE_MD_COMPFL_S4, CV_BASE_MD_RCALWEEK_S4, and CV_BASE_MD_CEPCT_S4, applying the filters and transformations defined in CV_COMP_SKF_ACTUAL_STATIC. | No action required. |

---

## Efficiency Assessment

| Severity | File | Issue | Recommendation |
|---|---|---|---|
| INFO | Individual Files | No duplicate table definitions found across the Individual Files. Each file defines a distinct view or procedure. | No action required. |
| INFO | Individual Files | No duplicate column definitions found. Each view defines its own output columns without unnecessary repetition. | No action required. |
| INFO | Individual Files | No redundant SQL logic found. The base views (CV_BASE_*) provide foundational data, the composite static views (CV_COMP_*_STATIC) provide filtered/snapshot data, and the main composite view (CV_COMP_SKF_ACTUAL_STATIC) orchestrates the joins and transformations. | No action required. |
| INFO | Individual Files | The stored procedure STP_WSS_SRP_ATTRIBUTES populates snapshot tables (TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG) that are used by CV_COMP_MD_SRPACT_STATIC and CV_COMP_MD_COMPFL_STATIC. This is a valid pattern for creating static/snapshot data and does not represent unnecessary duplication. | No action required. |
| INFO | Consolidated File | The Consolidated File eliminates all external dependencies by inlining the logic from all referenced Calculation Views. This is an efficient consolidation approach that removes the need for intermediate view materialization. | No action required. |
| INFO | Consolidated File vs Individual Files | The Consolidated File does not contain unnecessary duplication relative to the Individual Files. It represents a single executable query that combines all the logic from the Individual Files. | No action required. |
| INFO | Individual Files | CV_COMP_MD_SRPACT_STATIC and CV_BASE_MD_SRPACT_S4 both define aggregation logic over store attributes, but they source from different tables (TBL_WSS_SRP_ATTR_ACT vs ZTSRP_ATTR_ACT). This is not duplication; it represents a snapshot pattern where the static view uses pre-loaded data. | No action required. |
| INFO | Individual Files | CV_COMP_MD_COMPFL_STATIC and CV_BASE_MD_COMPFL_S4 both define projection logic over comp flag data, but they source from different tables (TBL_WSS_SRP_COMPFLAG vs ZTSRP_COMPFL). This is not duplication; it represents a snapshot pattern where the static view uses pre-loaded data. | No action required. |
| INFO | Individual Files | The measure RX_STORE is defined in CV_COMP_MD_SRPACT_STATIC but not in CV_BASE_MD_SRPACT_S4 (which has RX_STORE_DESC as an attribute). This is a valid difference in the view definitions and does not represent duplication. | No action required. |
| INFO | Individual Files | All Individual Files are necessary to represent the full scope of the Consolidated File. No Individual File is redundant or unnecessary. | No action required. |

---

## Validation Details

### Completeness Checks Performed: 22
1. ✅ Consolidated File is parseable and contains valid SQL
2. ✅ All 10 Individual Files are parseable and contain valid content
3. ✅ Base table AZSRP_DS112_VT_S4 present in Consolidated File and CV_BASE_SKF_WEEKLY_ACTUAL_S4
4. ✅ Base table ZTSRP_ATTR_ACT present in Consolidated File and CV_BASE_MD_SRPACT_S4
5. ✅ Base table HRRP_NODE present in Consolidated File and CV_BASE_MD_HRRP_NODE_S4
6. ✅ Base table ZTSRP_COMPFL present in Consolidated File and CV_BASE_MD_COMPFL_S4
7. ✅ Base table ZTFIGL_RCALWEEK present in Consolidated File and CV_BASE_MD_RCALWEEK_S4
8. ✅ Base table CEPCT present in Consolidated File and CV_BASE_MD_CEPCT_S4
9. ✅ All key columns from CV_BASE_SKF_WEEKLY_ACTUAL_S4 present in Consolidated File
10. ✅ All key columns from CV_BASE_MD_SRPACT_S4 present in Consolidated File
11. ✅ All key columns from CV_BASE_MD_HRRP_NODE_S4 present in Consolidated File
12. ✅ All key columns from CV_BASE_MD_COMPFL_S4 present in Consolidated File
13. ✅ All key columns from CV_BASE_MD_RCALWEEK_S4 present in Consolidated File
14. ✅ All key columns from CV_BASE_MD_CEPCT_S4 present in Consolidated File
15. ✅ All input parameters from CV_COMP_SKF_ACTUAL_STATIC present in Consolidated File
16. ✅ All calculated columns from CV_COMP_SKF_ACTUAL_STATIC present in Consolidated File
17. ✅ All measures from CV_COMP_SKF_ACTUAL_STATIC present in Consolidated File
18. ✅ All join definitions from CV_COMP_SKF_ACTUAL_STATIC present in Consolidated File
19. ✅ All filter conditions from Individual Files present in Consolidated File
20. ✅ Final aggregation logic from CV_COMP_SKF_ACTUAL_STATIC present in Consolidated File
21. ⚠️ CV_COMP_SKF_ACTUAL_STATIC references external Calculation Views as dependencies; Consolidated File inlines them
22. ✅ STP_WSS_SRP_ATTRIBUTES procedure logic present as separate Individual File

### Accuracy Checks Performed: 18
1. ✅ Table name AZSRP_DS112_VT_S4 consistent between Consolidated File and CV_BASE_SKF_WEEKLY_ACTUAL_S4
2. ✅ Table name ZTSRP_ATTR_ACT consistent between Consolidated File and CV_BASE_MD_SRPACT_S4
3. ✅ Table name HRRP_NODE consistent between Consolidated File and CV_BASE_MD_HRRP_NODE_S4
4. ✅ Table name ZTSRP_COMPFL consistent between Consolidated File and CV_BASE_MD_COMPFL_S4
5. ✅ Table name ZTFIGL_RCALWEEK consistent between Consolidated File and CV_BASE_MD_RCALWEEK_S4
6. ✅ Table name CEPCT consistent between Consolidated File and CV_BASE_MD_CEPCT_S4
7. ✅ Column names consistent across all base views between Consolidated File and Individual Files
8. ✅ MANDT filter values consistent: 110/200 for AZSRP_DS112_VT_S4 and ZTSRP_COMPFL; 120/200 for others
9. ✅ FISCVARNT filter consistent: 'K4' in both Consolidated File and CV_COMP_SKF_ACTUAL_STATIC
10. ✅ PARNODE filter consistent: LIKE '%CORERET%' in both Consolidated File and CV_COMP_SKF_ACTUAL_STATIC
11. ✅ HRYVALTO filter consistent: '99991231' in both Consolidated File and CV_COMP_SKF_ACTUAL_STATIC
12. ✅ Join key consistency: _B631_S_COSTCNTR=NODEVALUE with MANDT equality
13. ✅ Join key consistency: _B631_S_PROFTCTR=PRCTR with MANDT equality (multiple joins)
14. ✅ Join key consistency: CAL_WEEK=ZZWEEK
15. ✅ Calculated column CAL_WEEK logic consistent: @IP_WEEK_CY
16. ✅ Calculated column CAL_WEEK_NUMBER logic consistent: RIGHT(CAL_WEEK,2)
17. ✅ Calculated column CAL_ZIO_SKFQ_QTY logic consistent: CASE WHEN _BIC_ZIO_PSKF='804013' THEN _BIC_ZIO_SKFQ*2 ELSE _BIC_ZIO_SKFQ END
18. ✅ Aggregation logic consistent: SUM for all measures, GROUP BY for all non-measure columns

### Efficiency Checks Performed: 10
1. ✅ No duplicate table definitions across Individual Files
2. ✅ No duplicate column definitions across Individual Files
3. ✅ No redundant SQL logic across Individual Files
4. ✅ CV_COMP_MD_SRPACT_STATIC vs CV_BASE_MD_SRPACT_S4: Valid snapshot pattern, not duplication
5. ✅ CV_COMP_MD_COMPFL_STATIC vs CV_BASE_MD_COMPFL_S4: Valid snapshot pattern, not duplication
6. ✅ STP_WSS_SRP_ATTRIBUTES: Valid data loading procedure, not duplication
7. ✅ Consolidated File inlining: Efficient consolidation approach
8. ✅ No unnecessary duplication between Consolidated File and Individual Files
9. ✅ All Individual Files are necessary and non-redundant
10. ✅ No repeated structures or definitions that can be eliminated

---

## Summary

The validation has been completed successfully. The Consolidated SQL File (SKF_LY Consolidated File) accurately represents the combined logic of all 10 Individual SQL Files. The Consolidated File inlines all dependencies from the base Calculation Views (CV_BASE_*) and composite views (CV_COMP_*) into a single executable BigQuery query, eliminating external dependencies.

**Key Findings:**
- **Completeness:** 95.45% - One minor warning regarding the architectural difference between the Consolidated File (which inlines all logic) and CV_COMP_SKF_ACTUAL_STATIC (which references external Calculation Views). This is an expected and valid implementation difference.
- **Accuracy:** 100.00% - All table names, column names, filters, joins, calculated columns, and aggregation logic are consistent between the Consolidated File and the Individual Files.
- **Efficiency:** 100.00% - No unnecessary duplication found. The snapshot pattern (CV_COMP_*_STATIC views using TBL_WSS_* tables populated by STP_WSS_SRP_ATTRIBUTES) is a valid architectural pattern and does not represent inefficiency.

**Architectural Pattern Identified:**
The Individual Files follow a layered architecture:
1. **Base Views (CV_BASE_*)**: Source directly from SAP tables with basic filters and aggregations
2. **Snapshot Tables (TBL_WSS_*)**: Populated by STP_WSS_SRP_ATTRIBUTES procedure
3. **Static Views (CV_COMP_*_STATIC)**: Source from snapshot tables for performance
4. **Composite View (CV_COMP_SKF_ACTUAL_STATIC)**: Orchestrates joins and transformations using parameters

The Consolidated File collapses this architecture into a single query by inlining all base view logic and applying all filters and transformations directly.

**Overall Status: PASS WITH WARNINGS**

The single warning is informational and does not indicate a validation failure. It highlights the architectural difference between the modular Individual Files and the consolidated single-query approach. Both approaches are valid and serve different purposes (modularity/reusability vs. single-execution efficiency).
