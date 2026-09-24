# Overall Validation Summary

| Metric | Result |
|---|---|
| Completeness Score | 92% (Good) |
| Accuracy Score | 84% (Acceptable) |
| Efficiency Score | 93% (Good) |
| Overall Status | PASS WITH WARNINGS |

# Completeness Assessment

| Severity | File | Issue | Recommendation |
|---|---|---|---|
| INFO | Consolidated sql_8 files.txt and supplied SQL files | External source objects, functions, and target table definitions are referenced but not fully defined in the supplied input. This does not prevent understanding of the supplied logic, but full end-to-end validation of external dependencies is not available from the provided files. | Review external objects only if end-to-end deployment validation is required. |
| WARNING | CV_BASE_MD_CEPCT_S4.txt | Supplied content is not readable SQL or calculation-view logic in the provided file extract, so detailed validation of this artifact is not available from the supplied input. | Recheck the extracted file content if detailed object-level validation is needed. |
| WARNING | CV_BASE_MD_HRRP_NODE_S4.txt | Supplied content is not readable SQL or calculation-view logic in the provided file extract, so detailed validation of this artifact is not available from the supplied input. | Recheck the extracted file content if detailed object-level validation is needed. |
| WARNING | CV_BASE_MD_RCAIWEEK_S4.txt | Supplied content is not readable SQL or calculation-view logic in the provided file extract, so detailed validation of this artifact is not available from the supplied input. | Recheck the extracted file content if detailed object-level validation is needed. |
| WARNING | CV_COMP_FIN_BUDGET_STATIC.txt | Supplied content is not readable SQL or calculation-view logic in the provided file extract, so detailed validation of this artifact is not available from the supplied input. | Recheck the extracted file content if detailed object-level validation is needed. |

# Accuracy Assessment

| Severity | File | Issue | Recommendation |
|---|---|---|---|
| WARNING | Consolidated sql_8 files.txt vs CV_BASE_FIN_WEEKLY_BUDGET_S4.txt | Client filter values are inconsistent between related logic blocks. The consolidated SQL uses MANDT IN (120, 200) for HIER_NODE, CAL_WEEK, and PROFIT_CENTER_TEXT, while CV_BASE_FIN_WEEKLY_BUDGET_S4.txt uses MANDT IN ('110','200') in its visible budget-source logic. Based on the supplied files, the mixed 110/120 usage is a confirmed inconsistency requiring review. | Verify whether client 110 or 120 is the intended value and align the filters consistently across dependent objects. |
| WARNING | Consolidated sql_8 files.txt | The HIER_NODE filter uses REGEXP_CONTAINS(PARNODE, 'CORE_RET$'), while the corresponding supplied implementation text shows match("PARNODE",'*CORE_RET'). These patterns are not equivalent: one anchors at the end, while the other matches a suffix-style wildcard expression. This may change which hierarchy nodes are included. | Confirm the intended hierarchy-node match rule and align the BigQuery predicate to the source logic. |
| WARNING | Consolidated sql_8 files.txt vs STP_WSS_SRP_ATTRIBUTES.txt | Object naming is inconsistent for dependent views referenced by the procedure and consolidated SQL. The procedure header and inserts reference CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_COMPFL_S4, while the supplied companion files are named CV_COMP_MD_SRPACT_STATIC.txt and CV_COMP_MD_COMPFL_STATIC.txt and the consolidated SQL reads physical tables instead. Structural differences alone are acceptable, but the supplied files do not establish a clear one-to-one object mapping for these dependencies. | Confirm dependency lineage or provide the matching source object definitions if strict object traceability is required. |

# Efficiency Assessment

| Severity | File | Issue | Recommendation |
|---|---|---|---|
| INFO | Supplied SQL files | No significant efficiency issues identified. |
