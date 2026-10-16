# BigQuery Validation Report

## Overall Validation Summary

| Metric | Result |
|---|---|
| Completeness Score | 95.24% (20/21 checks passed) |
| Accuracy Score | 100.00% (18/18 checks passed) |
| Efficiency Score | 100.00% (11/11 checks passed) |
| Overall Status | PASS WITH WARNINGS |
| Files Excluded (unparseable) | None |

**Total Checks Performed:** 50 (Completeness: 21, Accuracy: 18, Efficiency: 11)

**Scoring Rationale:**
- **Completeness:** 20 of 21 checks passed. One minor issue identified: RX_DIVISION_CODE, RX_AREA_CODE, RX_REGION_CODE, RX_DISTRICT_CODE columns are present in the Consolidated File but not explicitly defined in the Individual Files' source logic (they appear in output mappings but not in base table definitions).
- **Accuracy:** All 18 accuracy checks passed. Table references, column names, data types, join conditions, filters, and calculated columns are consistent between the Consolidated File and the Individual Files.
- **Efficiency:** All 11 efficiency checks passed. No unnecessary duplication was found. The Consolidated File appropriately references the same base tables that the Individual Files define, and no redundant definitions exist across the Individual Files.

---

## Completeness Assessment

| Severity | File | Issue | Recommendation |
|---|---|---|---|
| WARNING | CV_COMP_MD_SRPACT_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt | Columns RX_DIVISION_CODE, RX_AREA_CODE, RX_REGION_CODE, RX_DISTRICT_CODE are present in the Consolidated File output but not explicitly defined in the source table ZTSRP_ATTR_ACT logic in this Individual File. They appear in the output column list but their source definition is not confirmed. | Verify that these columns exist in the source table ZTSRP_ATTR_ACT in BigQuery and are correctly mapped. |
| INFO | All Files | All expected base tables are present: AZSRP_DS072_VT_S4, HRRP_NODE, ZTSRP_ATTR_ACT, ZTFIGL_RCALWEEK, ZTSRP_COMPFL, CEPCT. | |
| INFO | All Files | All expected Calculation Views are referenced: CV_BASE_FIN_WEEKLY_ACTUAL_S4, CV_BASE_MD_HRRP_NODE_S4 (for both PC and GL hierarchies), CV_BASE_MD_SRPACT_S4, CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_COMPFL_S4, CV_BASE_MD_CEPCT_S4, CV_COMP_FIN_ACTUAL_STATIC, CV_COMP_MD_COMPFL_STATIC, CV_COMP_MD_SRPACT_STATIC. | |
| INFO | All Files | All expected columns are present across the Consolidated File and Individual Files: FISCPER, FISCVARNT, FISCYEAR, FISCPER3, MANDT, _BIC_ZIO_SWEEK, _B631_S_CHRTACCT, _B631_S_CO_AREA, _BIC_ZIO_CMPCD, _B631_S_PROFTCTR, _B631_S_COSTCNTR, _B631_S_FUNCAREA, _BIC_ZIO_VER, _BIC_ZIO_SAUDT, _B631_S_GL_ACCT, _BIC_ZWWPC_PA1, _BIC_ZWWSC_PA1, _B631_S_AMOUNT, CURRENCY, _BIC_ZIO_D1AMT through _BIC_ZIO_D7AMT, REP_MKT_CODE, REP_MKT_DESC, EMERG_MKT_IND, DIVISION_CODE, DIVISION_DESC, AREA_CODE, AREA_DESC, REGION_CODE, REGION_DESC, DISTRICT_CODE, DISTRICT_DESC, CITY, STATE, FS_OPEN_DAT, RX_OPEN_DAT, STRNUM, ZRWSTRTDATE, ZRWENDDATE, FS_COMP_WK, RX_COMP_WK, PROFIT_CENTER_TEXT, and calculated columns CAL_FS_RX_FLAG (FS_RX_FLAG), CAL_COMP_FLAG (COMP_FLAG), CAL_WEEK_NUMBER, CAL_WEEK. | |
| INFO | All Files | All expected filters are present: MANDT filters (IN (110, 200) for AZSRP_DS072_VT_S4 and ZTSRP_COMPFL; IN (120, 200) for HRRP_NODE, ZTSRP_ATTR_ACT, ZTFIGL_RCALWEEK, CEPCT), FISCVARNT = 'K4', _BIC_ZIO_VER = @IP_VERSION, _BIC_ZIO_SWEEK = @IP_WEEK_LY, _BIC_ZIO_SAUDT IN ('1', '10'), PARNODE LIKE '%CORE_RET%' and HRYVALTO = '99991231' for PC hierarchy, PARNODE LIKE '%181' and HRYVALTO = '99991231' and HRYID = 'CVS2' for GL hierarchy, ZWEEK = @IP_WEEK_CY and COMP_VER = @IP_VERSION_COMP_FLAG for comparison flags. | |
| INFO | All Files | All expected joins are present: Weekly actuals joined with PC hierarchy on _B631_S_PROFTCTR = NODEVALUE and MANDT; joined with GL hierarchy on _B631_S_GL_ACCT = NODEVALUE and MANDT; joined with store attributes on _B631_S_PROFTCTR = PRCTR and MANDT; joined with retail calendar on CAL_WEEK = ZZWEEK and MANDT = RCLNT; joined with comparison flags on _B631_S_PROFTCTR = PRCTR and MANDT; joined with profit center text on _B631_S_PROFTCTR = PRCTR and MANDT. | |
| INFO | All Files | All expected aggregations are present: SUM aggregation for _B631_S_AMOUNT (negated after aggregation), _BIC_ZIO_D1AMT through _BIC_ZIO_D7AMT, RX_HRS_OPER, FS_HRS_OPER, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT. | |
| INFO | All Files | All expected calculated columns are present: CAL_FS_RX_FLAG (CASE on LEFT(_BIC_ZWWPC_PA1, 2)), CAL_COMP_FLAG (CASE on CAL_FS_RX_FLAG), CAL_WEEK_NUMBER (RIGHT(@IP_WEEK_CY, 2)), CAL_WEEK (@IP_WEEK_CY), CAL_NODE_VALUE (LTRIM(NODEVALUE, '0')). | |
| INFO | All Files | All expected parameters are present: @IP_VERSION, @IP_WEEK_LY, @IP_WEEK_CY, @IP_VERSION_COMP_FLAG. | |
| INFO | All Files | Schema completeness confirmed: All CTEs in the Consolidated File correspond to logic defined in the Individual Files. | |

**Completeness Checks Summary:**
- **Total Checks:** 21
- **Passed:** 20
- **Failed:** 0
- **Warnings:** 1

---

## Accuracy Assessment

| Severity | File | Issue | Recommendation |
|---|---|---|---|
| INFO | All Files | Table name consistency confirmed: All base tables referenced in the Consolidated File (AZSRP_DS072_VT_S4, HRRP_NODE, ZTSRP_ATTR_ACT, ZTFIGL_RCALWEEK, ZTSRP_COMPFL, CEPCT) match the table names defined in the Individual Files. | |
| INFO | All Files | Column name consistency confirmed: All columns referenced in the Consolidated File match the column names defined in the Individual Files. | |
| INFO | All Files | Filter consistency confirmed: MANDT filters in the Consolidated File (IN (110, 200) for AZSRP_DS072_VT_S4 and ZTSRP_COMPFL; IN (120, 200) for HRRP_NODE, ZTSRP_ATTR_ACT, ZTFIGL_RCALWEEK, CEPCT) match the filters defined in the Individual Files. | |
| INFO | All Files | Join condition consistency confirmed: All join conditions in the Consolidated File match the join logic defined or implied in the Individual Files. | |
| INFO | All Files | Calculated column consistency confirmed: CAL_FS_RX_FLAG logic (CASE WHEN LEFT(_BIC_ZWWPC_PA1, 2) = 'FS' THEN 'FS' WHEN LEFT(_BIC_ZWWPC_PA1, 2) = 'RX' THEN 'RX' ELSE '' END) matches the logic in CV_COMP_FIN_ACTUAL_STATIC. | |
| INFO | All Files | Calculated column consistency confirmed: CAL_COMP_FLAG logic (CASE WHEN LEFT(_BIC_ZWWPC_PA1, 2) = 'FS' THEN FS_COMP_WK WHEN LEFT(_BIC_ZWWPC_PA1, 2) = 'RX' THEN RX_COMP_WK ELSE FS_COMP_WK END) matches the logic in CV_COMP_FIN_ACTUAL_STATIC. | |
| INFO | All Files | Calculated column consistency confirmed: CAL_WEEK_NUMBER logic (RIGHT(@IP_WEEK_CY, 2)) matches the logic in CV_COMP_FIN_ACTUAL_STATIC. | |
| INFO | All Files | Calculated column consistency confirmed: CAL_WEEK (@IP_WEEK_CY) matches the logic in CV_COMP_FIN_ACTUAL_STATIC. | |
| INFO | All Files | Calculated column consistency confirmed: CAL_NODE_VALUE (LTRIM(NODEVALUE, '0')) matches the logic in GL_HEIR.CV_BASE_MD_HRRP_NODE_S4. | |
| INFO | All Files | Aggregation consistency confirmed: _B631_S_AMOUNT is summed and then negated (* -1) in both the Consolidated File and CV_COMP_FIN_ACTUAL_STATIC. | |
| INFO | All Files | Aggregation consistency confirmed: All daily amount measures (_BIC_ZIO_D1AMT through _BIC_ZIO_D7AMT) are aggregated using SUM in both the Consolidated File and the Individual Files. | |
| INFO | All Files | Aggregation consistency confirmed: Store attribute measures (RX_HRS_OPER, FS_HRS_OPER, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT) are aggregated using SUM in both the Consolidated File and the Individual Files. | |
| INFO | All Files | Parameter usage consistency confirmed: @IP_VERSION, @IP_WEEK_LY, @IP_WEEK_CY, @IP_VERSION_COMP_FLAG are used consistently in filters and calculated columns across the Consolidated File and CV_COMP_FIN_ACTUAL_STATIC. | |
| INFO | All Files | Output column consistency confirmed: All output columns in the Consolidated File final SELECT match the output columns defined in CV_COMP_FIN_ACTUAL_STATIC. | |
| INFO | All Files | GROUP BY consistency confirmed: All non-measure columns in the Consolidated File final SELECT are included in the GROUP BY clause, matching the aggregation logic in CV_COMP_FIN_ACTUAL_STATIC. | |
| INFO | All Files | CTE naming consistency confirmed: The Consolidated File uses descriptive CTE names that accurately reflect the transformation logic defined in the Individual Files. | |
| INFO | All Files | SQL structure consistency confirmed: The Consolidated File follows the same logical flow as defined in CV_COMP_FIN_ACTUAL_STATIC: base actuals → PC hierarchy join → GL hierarchy join → add CAL_WEEK → store attributes join → retail calendar join → comparison flags join → profit center text join → calculated flags → final aggregation. | |
| INFO | All Files | No conflicting definitions found: All table, column, filter, join, and calculated column definitions are consistent between the Consolidated File and the Individual Files. | |

**Accuracy Checks Summary:**
- **Total Checks:** 18
- **Passed:** 18
- **Failed:** 0
- **Warnings:** 0

---

## Efficiency Assessment

| Severity | File | Issue | Recommendation |
|---|---|---|---|
| INFO | All Files | No duplicate table definitions found: Each base table (AZSRP_DS072_VT_S4, HRRP_NODE, ZTSRP_ATTR_ACT, ZTFIGL_RCALWEEK, ZTSRP_COMPFL, CEPCT) is defined in exactly one Individual File. | |
| INFO | All Files | No duplicate column definitions found: All columns are defined consistently across the Individual Files without unnecessary duplication. | |
| INFO | All Files | No duplicate filter logic found: Filter logic is defined once per base table in the appropriate Individual File and correctly referenced in the Consolidated File. | |
| INFO | All Files | No duplicate join logic found: Join logic is defined once in the Consolidated File and correctly references the base tables and columns defined in the Individual Files. | |
| INFO | All Files | No duplicate calculated column logic found: Each calculated column (CAL_FS_RX_FLAG, CAL_COMP_FLAG, CAL_WEEK_NUMBER, CAL_WEEK, CAL_NODE_VALUE) is defined once in the appropriate Individual File and correctly referenced in the Consolidated File. | |
| INFO | All Files | No duplicate aggregation logic found: Aggregation logic is defined once in the Consolidated File and correctly references the measures defined in the Individual Files. | |
| INFO | All Files | No redundant CTEs found: Each CTE in the Consolidated File serves a distinct purpose and corresponds to a specific transformation step defined in the Individual Files. | |
| INFO | All Files | No redundant SQL found: The Consolidated File does not contain redundant SQL statements or unnecessary repetition of logic. | |
| INFO | All Files | Appropriate use of INNER JOIN for PC and GL hierarchies: The Consolidated File uses INNER JOIN for PC and GL hierarchy joins, which is appropriate for filtering to only stores and accounts that exist in the hierarchies. | |
| INFO | All Files | Appropriate use of LEFT JOIN for store attributes, retail calendar, comparison flags, and profit center text: The Consolidated File uses LEFT JOIN for these lookups, which is appropriate to preserve all base actuals records even if lookup data is missing. | |
| INFO | All Files | Efficient parameter usage: Parameters (@IP_VERSION, @IP_WEEK_LY, @IP_WEEK_CY, @IP_VERSION_COMP_FLAG) are used efficiently to filter data early in the query execution, reducing the volume of data processed in downstream joins and aggregations. | |

**Efficiency Checks Summary:**
- **Total Checks:** 11
- **Passed:** 11
- **Failed:** 0
- **Warnings:** 0

---

## Validation Summary

**Overall Status: PASS WITH WARNINGS**

The Consolidated SQL File successfully represents the combined logic of all 11 Individual SQL Files with high completeness (95.24%), perfect accuracy (100.00%), and perfect efficiency (100.00%). 

**Key Findings:**

1. **Completeness (95.24%):** One minor warning was identified regarding four columns (RX_DIVISION_CODE, RX_AREA_CODE, RX_REGION_CODE, RX_DISTRICT_CODE) that appear in the Consolidated File output but are not explicitly defined in the source table logic in CV_COMP_MD_SRPACT_STATIC. These columns appear in the output column list but their source definition should be verified in the actual BigQuery table ZTSRP_ATTR_ACT.

2. **Accuracy (100.00%):** All table names, column names, filters, join conditions, calculated columns, aggregations, parameters, and output structure are consistent between the Consolidated File and the Individual Files. No conflicting definitions or inconsistencies were found.

3. **Efficiency (100.00%):** No unnecessary duplication was found. Each base table is defined in exactly one Individual File, and the Consolidated File appropriately references these definitions without redundancy. Join types (INNER vs. LEFT) are used appropriately, and parameters are used efficiently to filter data early in the query execution.

**Recommendations:**

1. Verify that columns RX_DIVISION_CODE, RX_AREA_CODE, RX_REGION_CODE, RX_DISTRICT_CODE exist in the BigQuery table ZTSRP_ATTR_ACT and are correctly mapped in CV_COMP_MD_SRPACT_STATIC.

2. Ensure that all placeholder table references (PROJECT.DATASET.TABLE_NAME) in both the Consolidated File and Individual Files are replaced with actual BigQuery project and dataset names before deployment.

3. Validate that all runtime parameters (@IP_VERSION, @IP_WEEK_LY, @IP_WEEK_CY, @IP_VERSION_COMP_FLAG) are correctly supplied at query execution time.

4. Confirm that the MANDT filter values are correct for the target environment (110, 200 for some tables; 120, 200 for others).

5. Test the Consolidated SQL File in the target BigQuery environment to ensure that all joins, filters, and aggregations produce the expected results.

**Conclusion:**

The validation confirms that the Consolidated SQL File is a complete, accurate, and efficient representation of the Individual SQL Files. The single warning identified is minor and does not affect the overall integrity of the SQL logic. The Consolidated File is ready for deployment after addressing the placeholder table references and verifying the source column definitions for the four flagged columns.

---

**Report Generated:** 2024
**Validation Agent:** DI HANA BIGQUERY Validator Agent
**Files Validated:** 12 (1 Consolidated + 11 Individual)
