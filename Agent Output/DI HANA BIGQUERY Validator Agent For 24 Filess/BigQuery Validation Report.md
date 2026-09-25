# Overall Validation Summary
| Metric | Result |
|---|---|
| Completeness Score | 88.89% (32/36 checks passed) - Acceptable |
| Accuracy Score | 92.86% (26/28 checks passed) - Good |
| Efficiency Score | 87.50% (14/16 checks passed) - Acceptable |
| Overall Status | PASS WITH WARNINGS |
| Files Excluded (unparseable) | None |

# Completeness Assessment
| Severity | File | Issue | Recommendation |
|---|---|---|---|
| WARNING | Consolidated_sql_24 files.txt; sql-procedure-acc-CVS_FRIP-Procedure-FI--STP_WSS_FLASH_SALES_DI HANA to BigQuery SQL Conversion Agent.txt; xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales_DI HANA to BigQuery SQL Conversion Agent.txt | Consolidated SQL includes procedure/static-table output columns `SNAPSHOT_TIMESTAMP` and `CREATED_BY` in the lineage notes and corresponding individual files, but these columns are not present in the consolidated final `FINAL_REPORT` output. | Confirm whether the consolidated file is intended to represent the procedure target table output or only the final report output, and align the documented scope consistently. |
| WARNING | Consolidated_sql_24 files.txt; xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales_DI HANA to BigQuery SQL Conversion Agent.txt | Individual static table file includes `SNAPSHOT_TIMESTAMP` and `CREATED_BY` in grouped output from `TBL_WSS_FLASH_SALES`, but these fields are not represented in the consolidated `FINAL_REPORT` projection. | If these fields are within scope, include them consistently or document that they are intentionally excluded from the consolidated final report. |
| WARNING | Consolidated_sql_24 files.txt; sql-procedure-acc-CVS_FRIP-Procedure-FI--STP_WSS_FLASH_SALES_DI HANA to BigQuery SQL Conversion Agent.txt | Procedure file inserts into `PROJECT.DATASET.TBL_WSS_FLASH_SALES`, but the consolidated SQL does not materialize or define that table output and instead terminates at `SELECT * FROM FINAL_REPORT`. | Clarify whether the consolidated artifact is expected to include the table-population step or only downstream query logic. |
| WARNING | xml_acc_cv_comp_fin_flash_combined_static_DI HANA to BigQuery SQL Conversion Agent.txt | File contains additional combined-static logic and many output columns not represented in the consolidated SQL scope. Direct inclusion cannot be confirmed from the consolidated artifact. | Confirm whether this file is intentionally out of scope; if so, document exclusion consistently across artifacts. |
| INFO | Multiple Individual SQL Files | Not available in supplied input for validating external object definitions referenced by both sides: `CV_BASE_MD_SRPACT_S4`, `CV_BASE_MD_HRRP_NODE_S4`, `CV_BASE_MD_COMPFL_S4`, `CV_BASE_MD_CEPCT_S4`. | |

# Accuracy Assessment
| Severity | File | Issue | Recommendation |
|---|---|---|---|
| WARNING | Consolidated_sql_24 files.txt; xml_acc_cv_comp_fin_flash_DI HANA to BigQuery SQL Conversion Agent.txt | `CAL_COMP_FLAG` logic is inconsistent. Consolidated SQL distinguishes null-handling separately (`FS_COMP_WK` null, `RX_COMP_WK` null, both null), while the individual composite file collapses any null in either field to `'0'`. | Align the `CAL_COMP_FLAG` expression across the consolidated and individual composite definitions. |
| WARNING | Consolidated_sql_24 files.txt; xml_acc_cv_comp_flash_sales-VT-table-CV_DI HANA to BigQuery SQL Conversion Agent.txt | Aggregation of script source columns differs. Consolidated `COMBINE_DATA` does not aggregate raw script count fields (`ZZ_RX_CNT_NS`, `ZZ_RX_CNT_REFILL`, `ZZ_RX_CNT_GE84_NS`, `ZZ_RX_CNT_GE84_RE`, `ZZ_RX_MCRX_GE84_NS`, `ZZ_RX_MCRX_GE84_RE`), while the individual VT-table file uses `COUNT(...)` for those fields. | Confirm whether raw script count fields are meant to be preserved; if yes, make the aggregation behavior consistent. |
| INFO | Both Files | No other significant accuracy issues identified from directly comparable tables, joins, filters, and projected columns. | |

# Efficiency Assessment
| Severity | File | Issue | Recommendation |
|---|---|---|---|
| WARNING | Multiple Individual SQL Files | Repeated identical base-parameter extraction appears across `xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES_DI HANA to BigQuery SQL Conversion Agent.txt`, `xml_acc_cv_base_parameters-FS_RETAIL_TYPES_DI HANA to BigQuery SQL Conversion Agent.txt`, `xml_acc_cv_base_parameters-FS-RETAIL_TYPE-ztfirp_flash_prm_DI HANA to BigQuery SQL Conversion Agent.txt`, `xml_acc_cv_base_parameters-RX_RETAIL_TYPES_DI HANA to BigQuery SQL Conversion Agent.txt`, and `xml_acc_cv_base_parameters-RX_RETAIL_TYPES-COVID_DI HANA to BigQuery SQL Conversion Agent.txt`. | Consolidate duplicated base parameter extraction where file-splitting rules allow, or explicitly document why separate copies are required. |
| WARNING | Multiple Individual SQL Files | Repeated base TLOGF extraction is defined in multiple files: `xml_acc_cv_base-FS_SALES-tlogf_DI HANA to BigQuery SQL Conversion Agent.txt`, `xml_acc_cv_base_tlogf-FS_SALES_DI HANA to BigQuery SQL Conversion Agent.txt`, `xml_acc_cv_base_tlogf-FS-DISCOUNT_DI HANA to BigQuery SQL Conversion Agent.txt`, `xml_acc_cv_base_tlogf-RX_SALES_DI HANA to BigQuery SQL Conversion Agent.txt`, `xml_acc_cv_base_tlogf-EMP_DISCOUNT_DI HANA to BigQuery SQL Conversion Agent.txt`, `xml_acc_cv_base_tlogf-EMP_DISCOUNTS_DI HANA to BigQuery SQL Conversion Agent.txt`, and `xml_acc_cv_base_tlogf_COVID_sales_DI HANA to BigQuery SQL Conversion Agent.txt`. | Reduce repeated base extraction definitions if these files are intended to be modular components over one shared base source. |
| INFO | Both Files | No other significant efficiency issues identified from directly observable duplication. | |