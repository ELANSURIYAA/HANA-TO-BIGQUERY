# FLASH SALES VT CAR – Consolidation Description

---

## 1. Input Confirmation

### Files Read

| Input | Status |
|---|---|
| `VT_CAR Relationships Table.txt` | ✅ Read – 6 lineage rows |
| `Columns_Mapping_v3.csv` | ✅ Read – full CSV (approx. 700+ rows across CEPCT, ZTFIGL_RCALWEEK, ZTSRP_COMPFL, ZTSRP_ATTR_ACT, HRRP_NODE, AZSRP_DS041_VT_S4, AZSRP_DS052_VT_S4, AZSRP_DS112_VT_S4, AZSRP_DS072_VT_S4, AZSRP_DS092_VT_S4, AZSRP_DS031_VT_S4, ACDOCA_VT_S4, BKPF, FAGLSKF_PN, FINSC_FISC_DATE) |
| `xml_acc_FLASH_SALES_VT_CAR_DI HANA to BigQuery SQL Conversion Agent.txt` | ✅ Read |
| `xml_acc_cv_comp_flash_sales-VT-table-CV_DI HANA to BigQuery SQL Conversion Agent.txt` | ✅ Read |
| `xml_acc_cv_base_NAVIX_DI HANA to BigQuery SQL Conversion Agent.txt` | ✅ Read |
| `xml_acc_cv_base_SCRIPTS-tlogf_x_DI HANA to BigQuery SQL Conversion Agent.txt` | ✅ Read |
| `xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES_DI HANA to BigQuery SQL Conversion Agent.txt` | ✅ Read |
| `xml_acc_cv_base_tlogf-EMP_DISCOUNT_DI HANA to BigQuery SQL Conversion Agent.txt` | ✅ Read |
| `xml_acc_cv_base_tlogf_COVID_sales_DI HANA to BigQuery SQL Conversion Agent.txt` | ✅ Read |

---

## 2. Final Consumer Identification

**Final Consumer:** `xml_acc_FLASH_SALES_VT_CAR` → HANA artifact `CV_BASE_FIN_FLASH_SALES_CAR`

This is the top-level Flash Sales VT CAR view. It reads from the staging table `CVS_FRIP.FLASH_SALES_VT_CAR`, applies a parameter-driven timestamp filter (`ZZ_UPD_TIMESTAMP BETWEEN @ip_upd_timestamp_from AND @ip_upd_timestamp_to`), and aggregates 14 measures with SUM/MAX over 5 GROUP BY keys.

The staging table `FLASH_SALES_VT_CAR` is populated by the intermediate composite view `CV_COMP_FLASH_SALES` (`xml_acc_cv_comp_flash_sales-VT-table-CV`), which in turn depends on five base views.

---

## 3. Lineage Rows Read

| Source File | Target File | Dependency Type |
|---|---|---|
| xml_acc_cv_base_NAVIX | xml_acc_cv_comp_flash_sales-VT-table-CV | Calculation View Dependency |
| xml_acc_cv_base_SCRIPTS-tlogf_x | xml_acc_cv_comp_flash_sales-VT-table-CV | Calculation View Dependency |
| xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES | xml_acc_cv_comp_flash_sales-VT-table-CV | Calculation View Dependency |
| xml_acc_cv_base_tlogf-EMP_DISCOUNT | xml_acc_cv_comp_flash_sales-VT-table-CV | Calculation View Dependency |
| xml_acc_cv_base_tlogf_COVID_sales | xml_acc_cv_comp_flash_sales-VT-table-CV | Calculation View Dependency |
| xml_acc_cv_comp_flash_sales-VT-table-CV | xml_acc_FLASH_SALES_VT_CAR | Calculation View Dependency |

---

## 4. File Classification (USED / NOT USED)

| File | Classification | Reason |
|---|---|---|
| `xml_acc_FLASH_SALES_VT_CAR` | **USED** | Final consumer; defines the timestamp filter and final CUBE/Aggregation output contract |
| `xml_acc_cv_comp_flash_sales-VT-table-CV` | **USED** | Intermediate composite view; defines all join/union/aggregation logic feeding the final consumer |
| `xml_acc_cv_base_NAVIX` | **USED** | Provides NAVIX dimension grain (MANDT, RETAILSTOREID, BUSINESSDAYDATE, CURRENCY) |
| `xml_acc_cv_base_SCRIPTS-tlogf_x` | **USED** | Provides RX script counters, customer type, workstation from TLOGF_X |
| `xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES` | **USED** | Provides parameter code lists (FS_RETAIL_TYPE_CODE, EMP_DISC_TYPE_CODE, RX_RETAIL_TYPE_CODE, FS_DISC_TYPE_CODE) |
| `xml_acc_cv_base_tlogf-EMP_DISCOUNT` | **USED** | Provides TLOGF base logic (filters, aggregation) for FS/RX sales and discount branches |
| `xml_acc_cv_base_tlogf_COVID_sales` | **USED** | Provides COVID-specific TLOGF logic with additional ITEMID = 'A01-433556' filter |

All 7 supplied files are **USED**.

---

## 5. Artifact Dependency Mapping and Lineage Edges

| Lineage Edge | Producer | Consumer | Resulting SQL Location |
|---|---|---|---|
| Edge 1 | CV_BASE_NAVIX | CV_COMP_FLASH_SALES | CTEs 1 (NAVIX) and 2 (NAVIX_2) |
| Edge 2 | CV_BASE_TLOGF_X | CV_COMP_FLASH_SALES | CTE 8 (SCRIPTS) |
| Edge 3 | CV_BASE_PARAMETERS | CV_COMP_FLASH_SALES | CTEs 11, 13, 15, 17, 21 (parameter code lists) |
| Edge 4 | CV_BASE_TLOGF | CV_COMP_FLASH_SALES | CTE 3 (Filtered_TLOGF) → CTEs 4–7 |
| Edge 5 | CV_BASE_TLOGF_COVID | CV_COMP_FLASH_SALES | CTE 19 (Filtered_TLOGF_COVID) → CTE 20 |
| Edge 6 | CV_COMP_FLASH_SALES | CV_BASE_FIN_FLASH_SALES_CAR | CTE 26 (CV_COMP_FLASH_SALES_AGG) → Final SELECT |

---

## 6. Final-Consumer Transformation Flow

The final-consumer `CV_BASE_FIN_FLASH_SALES_CAR` reads `FLASH_SALES_VT_CAR` (populated by `CV_COMP_FLASH_SALES`) through a single projection node with:
- A timestamp range filter: `ZZ_UPD_TIMESTAMP >= @ip_upd_timestamp_from AND ZZ_UPD_TIMESTAMP <= @ip_upd_timestamp_to`
- A CUBE/Aggregation output with GROUP BY on 5 keys and SUM/MAX on 14 measures

The consolidated SQL inlines the `CV_COMP_FLASH_SALES` logic (CTEs 1–26) and applies the final-consumer filter and aggregation in the final SELECT.

---

## 7. Dependency Expansion and Point-of-Consumption Mapping

### CV_BASE_NAVIX
- Expanded at: CTEs 1 (NAVIX) and 2 (NAVIX_2)
- NAVIX is used twice in CV_COMP_FLASH_SALES: once for the final MERGED join and once for the SCRIPTS currency join (Join_1). Both are represented as separate CTEs to preserve the two distinct join roles.

### CV_BASE_TLOGF (via xml_acc_cv_base_tlogf-EMP_DISCOUNT)
- Expanded at: CTE 3 (Filtered_TLOGF)
- The TLOGF base view applies filters (RECORDQUALIFIER IN ('5','6'), TRANSTYPECODE NOT IN ('1107','1197','1020'), WORKSTATIONID <> '0000000000', ARCHIVED = '', ZZ_UPD_TIMESTAMP <> '0') and aggregates SALESAMOUNT and REDUCTIONAMOUNT.
- CTEs 4–7 (FS_SALES, FS_DISCOUNT, RX_SALES, EMP_DISCOUNT) further filter Filtered_TLOGF by RECORDQUALIFIER for their respective branch roles.

### CV_BASE_TLOGF_X (via xml_acc_cv_base_SCRIPTS-tlogf_x)
- Expanded at: CTE 8 (SCRIPTS)
- Filters: RECORDQUALIFIER = 25, WORKSTATIONID <> '0000000000', ZZ_UPD_TIMESTAMP <> '0'

### CV_BASE_PARAMETERS (via xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES)
- Expanded at: CTEs 11, 13, 15, 17, 21
- Each CTE filters ZTFIRP_FLASH_PRM by a different PARAM_NAME value:
  - CTE 11: FS_RETAIL_TYPE_CODE
  - CTE 13: EMP_DISC_TYPE_CODE
  - CTE 15: RX_RETAIL_TYPE_CODE
  - CTE 17: FS_DISC_TYPE_CODE
  - CTE 21: RX_RETAIL_TYPE_CODE (COVID branch)

### CV_BASE_TLOGF_COVID (via xml_acc_cv_base_tlogf_COVID_sales)
- Expanded at: CTE 19 (Filtered_TLOGF_COVID)
- Same base table as TLOGF but adds ITEMID = 'A01-433556' filter.

---

## 8. CTE Structure Summary

| CTE # | Name | Purpose |
|---|---|---|
| 1 | NAVIX | NAVIX dimension grain for MERGED join |
| 2 | NAVIX_2 | NAVIX dimension grain for SCRIPTS currency join |
| 3 | Filtered_TLOGF | CV_BASE_TLOGF with all filters + SUM aggregation |
| 4 | FS_SALES | TLOGF RECORDQUALIFIER='5' for FS sales |
| 5 | FS_DISCOUNT | TLOGF RECORDQUALIFIER='6' for FS discounts |
| 6 | RX_SALES | TLOGF RECORDQUALIFIER='5' for RX sales |
| 7 | EMP_DISCOUNT | TLOGF RECORDQUALIFIER='6' for employee discounts |
| 8 | SCRIPTS | CV_BASE_TLOGF_X with filters |
| 9 | Joined_Scripts_With_Currency | SCRIPTS INNER JOIN NAVIX_2 (Join_1) |
| 10 | SCRIPT_KPIs | Calculated KPI columns from scripts |
| 11 | FS_RETAIL_TYPES | Parameters: FS_RETAIL_TYPE_CODE |
| 12 | Joined_FS_Sales_With_Retail_Types | FS_SALES INNER JOIN FS_RETAIL_TYPES (Join_2) |
| 13 | EMP_DISC_TYPES | Parameters: EMP_DISC_TYPE_CODE |
| 14 | Joined_Employee_Discount_With_Discount_Types | EMP_DISCOUNT INNER JOIN EMP_DISC_TYPES (Join_3) |
| 15 | RX_RETAIL_TYPES | Parameters: RX_RETAIL_TYPE_CODE |
| 16 | Joined_RX_Sales_With_Retail_Types | RX_SALES INNER JOIN RX_RETAIL_TYPES (Join_4) |
| 17 | FS_DISC_TYPES | Parameters: FS_DISC_TYPE_CODE |
| 18 | Joined_FS_Discount_With_Discount_Types | FS_DISCOUNT INNER JOIN FS_DISC_TYPES (Join_5) |
| 19 | Filtered_TLOGF_COVID | CV_BASE_TLOGF_COVID with all filters + SUM |
| 20 | COVID_SALES | COVID sales projection |
| 21 | RX_RETAIL_TYPES_COVID | Parameters: RX_RETAIL_TYPE_CODE (COVID) |
| 22 | Joined_COVID_Sales_With_RX_Retail_Types | COVID_SALES INNER JOIN RX_RETAIL_TYPES_COVID (Join_6) |
| 23 | Combined_Flash_Sales_Inputs | UNION ALL of 6 branches (Union_1) |
| 24 | COMBINE_DATA | Aggregation of union result |
| 25 | MERGED | NAVIX INNER JOIN COMBINE_DATA |
| 26 | CV_COMP_FLASH_SALES_AGG | Final aggregation of MERGED (CV_COMP_FLASH_SALES output contract) |
| — | Final SELECT | Final-consumer filter + CUBE/Aggregation |

---

## 9. Filter Trace

| Filter | Source File | Resulting SQL Location |
|---|---|---|
| RECORDQUALIFIER IN ('5','6') | xml_acc_cv_base_tlogf-EMP_DISCOUNT | CTE 3 (Filtered_TLOGF) WHERE clause |
| TRANSTYPECODE NOT IN ('1107','1197','1020') | xml_acc_cv_base_tlogf-EMP_DISCOUNT | CTE 3 (Filtered_TLOGF) WHERE clause |
| WORKSTATIONID <> '0000000000' | xml_acc_cv_base_tlogf-EMP_DISCOUNT | CTE 3 (Filtered_TLOGF) WHERE clause |
| ARCHIVED = '' | xml_acc_cv_base_tlogf-EMP_DISCOUNT | CTE 3 (Filtered_TLOGF) WHERE clause |
| ZZ_UPD_TIMESTAMP <> '0' (TLOGF) | xml_acc_cv_base_tlogf-EMP_DISCOUNT | CTE 3 (Filtered_TLOGF) WHERE clause |
| RECORDQUALIFIER = '5' (FS_SALES) | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 4 (FS_SALES) WHERE clause |
| RECORDQUALIFIER = '6' (FS_DISCOUNT) | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 5 (FS_DISCOUNT) WHERE clause |
| RECORDQUALIFIER = '5' (RX_SALES) | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 6 (RX_SALES) WHERE clause |
| RECORDQUALIFIER = '6' (EMP_DISCOUNT) | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 7 (EMP_DISCOUNT) WHERE clause |
| RECORDQUALIFIER = 25 (TLOGF_X) | xml_acc_cv_base_SCRIPTS-tlogf_x | CTE 8 (SCRIPTS) WHERE clause |
| WORKSTATIONID <> '0000000000' (TLOGF_X) | xml_acc_cv_base_SCRIPTS-tlogf_x | CTE 8 (SCRIPTS) WHERE clause |
| ZZ_UPD_TIMESTAMP <> '0' (TLOGF_X) | xml_acc_cv_base_SCRIPTS-tlogf_x | CTE 8 (SCRIPTS) WHERE clause |
| PARAM_NAME = 'FS_RETAIL_TYPE_CODE' | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 11 (FS_RETAIL_TYPES) WHERE clause |
| PARAM_NAME = 'EMP_DISC_TYPE_CODE' | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 13 (EMP_DISC_TYPES) WHERE clause |
| PARAM_NAME = 'RX_RETAIL_TYPE_CODE' | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 15 (RX_RETAIL_TYPES) WHERE clause |
| PARAM_NAME = 'FS_DISC_TYPE_CODE' | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 17 (FS_DISC_TYPES) WHERE clause |
| PARAM_NAME = 'RX_RETAIL_TYPE_CODE' (COVID) | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 21 (RX_RETAIL_TYPES_COVID) WHERE clause |
| RECORDQUALIFIER IN ('5','6') (COVID) | xml_acc_cv_base_tlogf_COVID_sales | CTE 19 (Filtered_TLOGF_COVID) WHERE clause |
| TRANSTYPECODE NOT IN ('1107','1197','1020') (COVID) | xml_acc_cv_base_tlogf_COVID_sales | CTE 19 WHERE clause |
| WORKSTATIONID <> '0000000000' (COVID) | xml_acc_cv_base_tlogf_COVID_sales | CTE 19 WHERE clause |
| ARCHIVED = '' (COVID) | xml_acc_cv_base_tlogf_COVID_sales | CTE 19 WHERE clause |
| ZZ_UPD_TIMESTAMP <> '0' (COVID) | xml_acc_cv_base_tlogf_COVID_sales | CTE 19 WHERE clause |
| ITEMID = 'A01-433556' | xml_acc_cv_base_tlogf_COVID_sales | CTE 19 WHERE clause |
| ZZ_UPD_TIMESTAMP >= @ip_upd_timestamp_from | xml_acc_FLASH_SALES_VT_CAR | Final SELECT WHERE clause |
| ZZ_UPD_TIMESTAMP <= @ip_upd_timestamp_to | xml_acc_FLASH_SALES_VT_CAR | Final SELECT WHERE clause |

---

## 10. Join Trace

| Join | Type | Inputs | Condition | Source File | SQL Location |
|---|---|---|---|---|---|
| Join_1 | INNER | SCRIPTS, NAVIX_2 | MANDT, RETAILSTOREID, BUSINESSDAYDATE | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 9 |
| Join_2 | INNER | FS_SALES, FS_RETAIL_TYPES | RETAILTYPECODE = LOW_CHAR | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 12 |
| Join_3 | INNER | EMP_DISCOUNT, EMP_DISC_TYPES | DISCTYPECODE = LOW_CHAR | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 14 |
| Join_4 | INNER | RX_SALES, RX_RETAIL_TYPES | RETAILTYPECODE = LOW_CHAR | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 16 |
| Join_5 | INNER | FS_DISCOUNT, FS_DISC_TYPES | DISCTYPECODE = LOW_CHAR | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 18 |
| Join_6 | INNER | COVID_SALES, RX_RETAIL_TYPES_COVID | RETAILTYPECODE = LOW_CHAR | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 22 |
| MERGED | INNER | NAVIX, COMBINE_DATA | MANDT, RETAILSTOREID, BUSINESSDAYDATE | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 25 |

---

## 11. Aggregation Trace

| Aggregation Stage | GROUP BY Keys | Aggregations | Source File | SQL Location |
|---|---|---|---|---|
| Filtered_TLOGF | MANDT, RETAILSTOREID, BUSINESSDAYDATE, RECORDQUALIFIER, TRANSTYPECODE, WORKSTATIONID, ARCHIVED, RETAILTYPECODE, ZZ_UPD_TIMESTAMP, DISCTYPECODE, TRANSCURRENCY | SUM(SALESAMOUNT), SUM(REDUCTIONAMOUNT) | xml_acc_cv_base_tlogf-EMP_DISCOUNT | CTE 3 |
| Filtered_TLOGF_COVID | Same 11 keys | SUM(SALESAMOUNT) | xml_acc_cv_base_tlogf_COVID_sales | CTE 19 |
| COMBINE_DATA | MANDT, RETAILSTOREID, BUSINESSDAYDATE, TRANSCURRENCY, ZZ_UPD_TIMESTAMP | SUM 11 measures, COUNT 6 script counters, MAX 3 timestamps | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 24 |
| CV_COMP_FLASH_SALES_AGG | MANDT, RETAILSTOREID, BUSINESSDAYDATE, TRANSCURRENCY | MAX(ZZ_UPD_TIMESTAMP), SUM 11 measures, MAX 3 timestamps | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 26 |
| Final SELECT | MANDT, RETAILSTOREID, BUSINESSDAYDATE, ZZ_UPD_TIMESTAMP, TRANSCURRENCY | SUM 11 measures, MAX 3 timestamps | xml_acc_FLASH_SALES_VT_CAR | Final SELECT |

---

## 12. UNION Branch Trace

| Branch | Source CTE | Metric Contributed | ZZ_UPD_TIMESTAMP Source |
|---|---|---|---|
| 1 | SCRIPT_KPIs | CAL_FS_UNITS, CAL_RX_CNT_*, CAL_CVD_UNITS | SCRIPTS_UPD_TIMESTAMP |
| 2 | Joined_FS_Sales_With_Retail_Types | FS_SALESAMOUNT | FS_UPD_TIMESTAMP |
| 3 | Joined_Employee_Discount_With_Discount_Types | EMP_REDUCTIONAMOUNT | EMP_DISC_UPD_TIMESTAMP |
| 4 | Joined_RX_Sales_With_Retail_Types | RX_SALESAMOUNT | RX_UPD_TIMESTAMP |
| 5 | Joined_FS_Discount_With_Discount_Types | REDUCTIONAMOUNT | FS_DISC_UPD_TIMESTAMP |
| 6 | Joined_COVID_Sales_With_RX_Retail_Types | CVD_AMOUNT | CVD_UPD_TIMESTAMP |

---

## 13. Calculation Trace

| Calculated Column | Formula | Source File | SQL Location |
|---|---|---|---|
| CAL_FS_UNITS | CASE ZZ_CUSTTYPE IN ('F','M','R') THEN 1; IN ('X','Y','Z') THEN -1; ELSE 0 | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 10 (SCRIPT_KPIs) |
| CAL_RX_CNT_GE84_NS | IF ZZ_RX_CNT_GE84_NS='' THEN 0 ELSE CAST AS INT64 | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 10 |
| CAL_RX_CNT_GE84_RE | IF ZZ_RX_CNT_GE84_RE='' THEN 0 ELSE CAST AS INT64 | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 10 |
| CAL_RX_CNT_NS | IF ZZ_RX_CNT_NS='' THEN 0 ELSE CAST AS INT64 | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 10 |
| CAL_RX_CNT_RE | IF ZZ_RX_CNT_REFILL='' THEN 0 ELSE CAST AS INT64 | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 10 |
| CAL_CVD_UNITS | IF WORKSTATIONID='0000000555' AND ZZ_CUSTTYPE='C' THEN 1; 'W' THEN -1; ELSE 0 | xml_acc_cv_comp_flash_sales-VT-table-CV | CTE 10 |

---

## 14. Runtime Parameters

| Parameter | Type | Default | Source | Usage |
|---|---|---|---|---|
| @ip_upd_timestamp_from | STRING | '19000101000000' | xml_acc_FLASH_SALES_VT_CAR (IP_UPD_TIMESTAMP_FROM) | Final SELECT WHERE ZZ_UPD_TIMESTAMP >= @ip_upd_timestamp_from |
| @ip_upd_timestamp_to | STRING | '99991231125959' | xml_acc_FLASH_SALES_VT_CAR (IP_UPD_TIMESTAMP_TO) | Final SELECT WHERE ZZ_UPD_TIMESTAMP <= @ip_upd_timestamp_to |

Default values are documented in comments only. BigQuery runtime must supply these parameters.

---

## 15. Table and Column Mapping Applied

### Tables Referenced in Consolidated SQL

| HANA Source Object | BQ_FULL_TABLE Used | Mapping Status |
|---|---|---|
| SAPABAP1./POSDW/NAVIX | `PROJECT.DATASET.POSDW_NAVIX` | **PLACEHOLDER – NOT IN Columns_Mapping_v3** |
| SAPABAP1./POSDW/TLOGF | `PROJECT.DATASET.POSDW_TLOGF` | **PLACEHOLDER – NOT IN Columns_Mapping_v3** |
| SAPABAP1./POSDW/TLOGF_X | `PROJECT.DATASET.POSDW_TLOGF_X` | **PLACEHOLDER – NOT IN Columns_Mapping_v3** |
| SAPABAP1.ZTFIRP_FLASH_PRM | `PROJECT.DATASET.ZTFIRP_FLASH_PRM` | **PLACEHOLDER – NOT IN Columns_Mapping_v3** |
| CVS_FRIP.FLASH_SALES_VT_CAR | `PROJECT.DATASET.FLASH_SALES_VT_CAR` | **PLACEHOLDER – NOT IN Columns_Mapping_v3** |

None of the five terminal physical source tables used by the FLASH SALES dependency chain appear in `Columns_Mapping_v3.csv`. The CSV contains mappings for SAP ERP/BW tables (CEPCT, ZTFIGL_RCALWEEK, ZTSRP_COMPFL, ZTSRP_ATTR_ACT, HRRP_NODE, AZSRP_DS0xx, ACDOCA, BKPF, FAGLSKF_PN, FINSC_FISC_DATE) that are not part of this Flash Sales dependency chain.

Because no mapping row exists for any of these five tables, all `BQ_FULL_TABLE` values and all column names remain as placeholders from the converted SQL files.

### Column Mapping Status

All column names in the consolidated SQL are carried through unchanged from the converted SQL files because no `Columns_Mapping_v3` rows exist for the terminal tables. No column renaming was applied.

---

## 16. Alias Check

- All output column aliases in the final SELECT match the output contract of `CV_BASE_FIN_FLASH_SALES_CAR` exactly.
- Aggregate aliases (e.g., `SUM(FS_SALESAMOUNT) AS FS_SALESAMOUNT`) use the same name as the source column, which is the correct BigQuery style for this case (no HANA-name alias violation).
- No redundant HANA-name aliases were introduced.
- The UNION ALL branches use explicit `CAST(NULL AS <type>)` for absent metrics; no alias violations exist.

---

## 17. Data Type Notes

- ZZ_UPD_TIMESTAMP comparison to @ip_upd_timestamp_from / @ip_upd_timestamp_to: both are treated as STRING because the physical datatype of ZZ_UPD_TIMESTAMP is not in Columns_Mapping_v3 and the converted SQL files treat it as a string-compatible value.
- RECORDQUALIFIER filter in TLOGF: kept as string literal ('5','6') per the converted SQL. Requires validation against actual BigQuery schema.
- RECORDQUALIFIER filter in TLOGF_X: kept as numeric literal (25) per the converted SQL. Requires validation.
- ZZ_UPD_TIMESTAMP <> '0' and <> 0: kept as-is from the respective converted SQL files. Requires validation.
- CAST(NULL AS NUMERIC/STRING/INT64/STRING) in UNION branches: types assigned based on the converted SQL file's best-effort assignments. Require validation against actual schemas.
- CAST(ZZ_RX_CNT_* AS INT64): applied per the converted SQL's representation of HANA int() function.

---

## 18. Duplicate Column Check

- CTE 24 (COMBINE_DATA): The intermediate count columns ZZ_RX_CNT_GE84_NS and ZZ_RX_CNT_GE84_RE would collide with the SUM columns of the same name. Resolved by aliasing the COUNT versions as `ZZ_RX_CNT_GE84_NS_CNT` and `ZZ_RX_CNT_GE84_RE_CNT`. These intermediate count columns are not exposed in the final output (consistent with the logical model).
- No other duplicate aliases exist within any SELECT.

---

## 19. Procedure / ETL Handling

No stored procedures or INSERT-SELECT patterns were present in the supplied files. All artifacts are Calculation View XMLs interpreted as SELECT logic.

---

## 20. Quality Gate Results

| Gate | Result |
|---|---|
| Final consumer unambiguous | ✅ PASS |
| Artifact dependencies match lineage table | ✅ PASS |
| Final-consumer transformation order preserved | ✅ PASS |
| Dependencies expanded at point of consumption | ✅ PASS |
| No generic Source→Intermediate→Target ordering inferred | ✅ PASS |
| Every file classified USED or NOT USED | ✅ PASS (all 7 USED) |
| All converted dependencies expanded | ✅ PASS |
| Only terminal sources remain | ✅ PASS |
| Every physical source uses BQ_FULL_TABLE | ⚠️ PLACEHOLDER (see Issues to Fix #1) |
| Every referenced column mapped via Columns_Mapping_v3 | ⚠️ NOT MAPPED (see Issues to Fix #2) |
| Type compatibility in comparisons | ⚠️ REQUIRES VALIDATION (see Issues to Fix #3) |
| Final-consumer CTE names and order preserved | ✅ PASS |
| Compatible steps combined where logically safe | ✅ PASS |
| No source/HANA node becomes a separate CTE without justification | ✅ PASS |
| Every CTE matches required output contract | ✅ PASS |
| No duplicate aliases within any SELECT | ✅ PASS |
| All filters preserved | ✅ PASS |
| All joins preserved | ✅ PASS |
| All calculations preserved | ✅ PASS |
| All aggregations preserved | ✅ PASS |
| All UNION branches preserved | ✅ PASS |
| Runtime parameters documented | ✅ PASS |
| No DECLARE/SET statements in output | ✅ PASS |
| Every CTE has standardized comment header | ✅ PASS |
| No conflicts silently corrected | ✅ PASS |

---

## 21. ISSUES TO FIX

### Issue 1 – Missing BQ_FULL_TABLE Mappings (BLOCKING for execution)
**Affected tables:** `/POSDW/NAVIX`, `/POSDW/TLOGF`, `/POSDW/TLOGF_X`, `ZTFIRP_FLASH_PRM`, `FLASH_SALES_VT_CAR`
**Evidence:** Full scan of Columns_Mapping_v3.csv found no rows for these table names.
**Impact:** All five `PROJECT.DATASET.*` references in the SQL are placeholders and will fail at execution time.
**Resolution needed:** Provide the correct `BQ_FULL_TABLE` values for each of these five HANA source objects and update the SQL accordingly.

### Issue 2 – Missing Column Mappings (BLOCKING for execution)
**Affected columns:** All columns from the five tables above (MANDT, RETAILSTOREID, BUSINESSDAYDATE, CURRENCY, SALESAMOUNT, REDUCTIONAMOUNT, RECORDQUALIFIER, TRANSTYPECODE, WORKSTATIONID, ARCHIVED, RETAILTYPECODE, ZZ_UPD_TIMESTAMP, DISCTYPECODE, TRANSCURRENCY, ITEMID, ZZ_RX_CNT_NS, ZZ_RX_CNT_REFILL, ZZ_RX_CNT_GE84_NS, ZZ_RX_CNT_GE84_RE, ZZ_RX_MCRX_GE84_NS, ZZ_RX_MCRX_GE84_RE, ZZ_CUSTTYPE, WORKSTATIONID, PARAM_NAME, PARAM_VALUE_LOW, PARAM_VALUE_HIGH)
**Evidence:** No CSV rows exist for the terminal tables.
**Impact:** Column names are carried through from the converted SQL files unchanged. If BigQuery column names differ from HANA names, the SQL will fail.
**Resolution needed:** Add Columns_Mapping_v3 rows for all five tables, then re-run consolidation to apply correct BQ_COLUMN names.

### Issue 3 – Data Type Compatibility Requires Validation (NON-BLOCKING for logic, BLOCKING for execution)
**Affected predicates:**
- `ZZ_UPD_TIMESTAMP >= @ip_upd_timestamp_from` and `<= @ip_upd_timestamp_to`
- `RECORDQUALIFIER IN ('5','6')` vs numeric literal `25` in TLOGF_X
- `ZZ_UPD_TIMESTAMP <> '0'` vs `<> 0`
- CAST(NULL AS NUMERIC/STRING/INT64) in UNION branches
**Evidence:** Physical datatypes not available in Columns_Mapping_v3 for these tables.
**Impact:** Type mismatch errors at runtime if actual BigQuery column types differ from assumed types.
**Resolution needed:** Confirm BigQuery column types for all five terminal tables and apply explicit CASTs where needed.

### Issue 4 – SCRIPTS_UPD_TIMESTAMP / FS_UPD_TIMESTAMP / RX_UPD_TIMESTAMP / EMP_DISC_UPD_TIMESTAMP Type (NON-BLOCKING)
These timestamp fields are treated as STRING in the UNION branches (CAST(NULL AS STRING)) based on the converted SQL file's treatment of ZZ_UPD_TIMESTAMP as a string-comparable value. If the actual BigQuery type is TIMESTAMP or DATETIME, the CAST types in the UNION branches must be updated.

---

*This consolidation is NOT production-ready until Issues 1, 2, and 3 are resolved.*
