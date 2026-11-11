# VT_CAR Flash Sales – BigQuery Consolidation Description

---

## 1. Input Confirmation

### Files Read

| Input | Status |
|---|---|
| `VT_CAR Relationships Table.txt` | ✅ Read – 6 lineage rows |
| `Columns_Mapping_v3.csv` | ✅ Read – Full CSV read; tables present: CEPCT, ZTFIGL_RCALWEEK, ZTSRP_COMPFL, ZTSRP_ATTR_ACT, HRRP_NODE, AZSRP_DS041_VT_S4, AZSRP_DS052_VT_S4, AZSRP_DS112_VT_S4, AZSRP_DS072_VT_S4, AZSRP_DS092_VT_S4, AZSRP_DS031_VT_S4, ACDOCA_VT_S4, BKPF, FAGLSKF_PN, FINSC_FISC_DATE |
| `xml_acc_FLASH_SALES_VT_CAR_DI HANA to BigQuery SQL Conversion Agent.txt` | ✅ Read |
| `xml_acc_cv_comp_flash_sales-VT-table-CV_DI HANA to BigQuery SQL Conversion Agent.txt` | ✅ Read |
| `xml_acc_cv_base_NAVIX_DI HANA to BigQuery SQL Conversion Agent.txt` | ✅ Read |
| `xml_acc_cv_base_SCRIPTS-tlogf_x_DI HANA to BigQuery SQL Conversion Agent.txt` | ✅ Read |
| `xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES_DI HANA to BigQuery SQL Conversion Agent.txt` | ✅ Read |
| `xml_acc_cv_base_tlogf-EMP_DISCOUNT_DI HANA to BigQuery SQL Conversion Agent.txt` | ✅ Read |
| `xml_acc_cv_base_tlogf_COVID_sales_DI HANA to BigQuery SQL Conversion Agent.txt` | ✅ Read |

### Columns_Mapping_v3 Row Count
Full CSV read. Approximately 650+ rows covering 15 HANA tables. **None of the five physical source tables referenced by this dependency chain** (`/POSDW/NAVIX`, `/POSDW/TLOGF`, `/POSDW/TLOGF_X`, `ZTFIRP_FLASH_PRM`, `FLASH_SALES_VT_CAR`) **are present in Columns_Mapping_v3**.

---

## 2. Final Consumer Identification

**Final Consumer:** `xml_acc_FLASH_SALES_VT_CAR` → HANA artifact `CV_BASE_FIN_FLASH_SALES_CAR`

This is the top-level Flash Sales VT CAR view. It reads from the physical staging/reporting table `CVS_FRIP.FLASH_SALES_VT_CAR`, applies a timestamp filter using input parameters `IP_UPD_TIMESTAMP_FROM` / `IP_UPD_TIMESTAMP_TO`, and produces an aggregated CUBE output.

---

## 3. Artifact Dependency Mapping (Lineage Edges)

| Edge # | Producer | Consumer | Dependency Type | Resulting SQL Location |
|---|---|---|---|---|
| 1 | `xml_acc_cv_base_NAVIX` (CV_BASE_NAVIX) | `xml_acc_cv_comp_flash_sales-VT-table-CV` (CV_COMP_FLASH_SALES) | Calculation View Dependency | CTEs: `NAVIX`, `NAVIX_2` |
| 2 | `xml_acc_cv_base_SCRIPTS-tlogf_x` (CV_BASE_TLOGF_X) | `xml_acc_cv_comp_flash_sales-VT-table-CV` | Calculation View Dependency | CTE: `SCRIPTS` |
| 3 | `xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES` (CV_BASE_PARAMETERS) | `xml_acc_cv_comp_flash_sales-VT-table-CV` | Calculation View Dependency (×5 usages) | CTEs: `FS_RETAIL_TYPES`, `EMP_DISC_TYPES`, `RX_RETAIL_TYPES`, `FS_DISC_TYPES`, `RX_RETAIL_TYPES_COVID` |
| 4 | `xml_acc_cv_base_tlogf-EMP_DISCOUNT` (CV_BASE_TLOGF) | `xml_acc_cv_comp_flash_sales-VT-table-CV` | Calculation View Dependency (×4 usages) | CTEs: `FS_SALES`, `FS_DISCOUNT`, `RX_SALES`, `EMP_DISCOUNT` |
| 5 | `xml_acc_cv_base_tlogf_COVID_sales` (CV_BASE_TLOGF_COVID) | `xml_acc_cv_comp_flash_sales-VT-table-CV` | Calculation View Dependency | CTE: `COVID_SALES` |
| 6 | `xml_acc_cv_comp_flash_sales-VT-table-CV` (CV_COMP_FLASH_SALES) | `xml_acc_FLASH_SALES_VT_CAR` (CV_BASE_FIN_FLASH_SALES_CAR) | Calculation View Dependency | CTEs: `Joined_Scripts_With_Currency`, `SCRIPT_KPIs`, all joined CTEs, `Combined_Flash_Sales_Inputs`, `COMBINE_DATA`, `MERGED`, `Filtered_FLASH_SALES_VT_CAR` |

---

## 4. File Classification: USED / NOT USED

| File | Classification | Reason |
|---|---|---|
| `xml_acc_FLASH_SALES_VT_CAR_DI HANA to BigQuery SQL Conversion Agent.txt` | **USED** | Final consumer. Provides timestamp filter, parameter definitions, and final aggregation grain (CUBE output). |
| `xml_acc_cv_comp_flash_sales-VT-table-CV_DI HANA to BigQuery SQL Conversion Agent.txt` | **USED** | Intermediate composite view. Provides the full join/union/aggregation logic (NAVIX, TLOGF branches, TLOGF_X, PARAMETERS, TLOGF_COVID, COMBINE_DATA, MERGED). |
| `xml_acc_cv_base_NAVIX_DI HANA to BigQuery SQL Conversion Agent.txt` | **USED** | Provides CV_BASE_NAVIX logic: projects MANDT, RETAILSTOREID, BUSINESSDAYDATE, CURRENCY from /POSDW/NAVIX. Used twice (NAVIX, NAVIX_2). |
| `xml_acc_cv_base_SCRIPTS-tlogf_x_DI HANA to BigQuery SQL Conversion Agent.txt` | **USED** | Provides CV_BASE_TLOGF_X logic: filters /POSDW/TLOGF_X to RECORDQUALIFIER=25, excludes WORKSTATIONID='0000000000' and ZZ_UPD_TIMESTAMP=0. |
| `xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES_DI HANA to BigQuery SQL Conversion Agent.txt` | **USED** | Provides CV_BASE_PARAMETERS logic: projects PARAM_NAME, PARAM_VALUE_LOW (LOW_CHAR), PARAM_VALUE_HIGH (HIGH_CHAR) from ZTFIRP_FLASH_PRM. Used five times with different PARAM_NAME filters. |
| `xml_acc_cv_base_tlogf-EMP_DISCOUNT_DI HANA to BigQuery SQL Conversion Agent.txt` | **USED** | Provides CV_BASE_TLOGF logic: filters /POSDW/TLOGF to RECORDQUALIFIER IN ('5','6'), excludes TRANSTYPECODE IN ('1107','1197','1020'), WORKSTATIONID='0000000000', ARCHIVED='', ZZ_UPD_TIMESTAMP='0'. Used four times (FS_SALES, FS_DISCOUNT, RX_SALES, EMP_DISCOUNT). |
| `xml_acc_cv_base_tlogf_COVID_sales_DI HANA to BigQuery SQL Conversion Agent.txt` | **USED** | Provides CV_BASE_TLOGF_COVID logic: same base filters as TLOGF plus ITEMID='A01-433556'. Used for COVID_SALES branch. |

---

## 5. Final-Consumer Flow and Dependency Expansion

The consolidation follows the actual node sequence from the composite view and final consumer:

1. **NAVIX** (CTE 1): CV_BASE_NAVIX logic → /POSDW/NAVIX projection
2. **FS_SALES** (CTE 2): CV_BASE_TLOGF logic filtered to RECORDQUALIFIER='5' for FS
3. **FS_DISCOUNT** (CTE 3): CV_BASE_TLOGF logic filtered to RECORDQUALIFIER='6' for FS discount
4. **RX_SALES** (CTE 4): CV_BASE_TLOGF logic filtered to RECORDQUALIFIER='5' for RX
5. **EMP_DISCOUNT** (CTE 5): CV_BASE_TLOGF logic filtered to RECORDQUALIFIER='6' for employee discount
6. **SCRIPTS** (CTE 6): CV_BASE_TLOGF_X logic → /POSDW/TLOGF_X filtered projection
7. **NAVIX_2** (CTE 7): Second usage of CV_BASE_NAVIX for CURRENCY join
8. **Joined_Scripts_With_Currency** (CTE 8): Join_1 from composite – SCRIPTS INNER JOIN NAVIX_2
9. **SCRIPT_KPIs** (CTE 9): Calculated attributes (CAL_FS_UNITS, CAL_RX_CNT_*, CAL_CVD_UNITS)
10. **FS_RETAIL_TYPES** (CTE 10): CV_BASE_PARAMETERS filtered to PARAM_NAME='FS_RETAIL_TYPE_CODE'
11. **Joined_FS_Sales_With_Retail_Types** (CTE 11): Join_2 – FS_SALES INNER JOIN FS_RETAIL_TYPES
12. **EMP_DISC_TYPES** (CTE 12): CV_BASE_PARAMETERS filtered to PARAM_NAME='EMP_DISC_TYPE_CODE'
13. **Joined_Employee_Discount_With_Discount_Types** (CTE 13): Join_3 – EMP_DISCOUNT INNER JOIN EMP_DISC_TYPES
14. **RX_RETAIL_TYPES** (CTE 14): CV_BASE_PARAMETERS filtered to PARAM_NAME='RX_RETAIL_TYPE_CODE'
15. **Joined_RX_Sales_With_Retail_Types** (CTE 15): Join_4 – RX_SALES INNER JOIN RX_RETAIL_TYPES
16. **FS_DISC_TYPES** (CTE 16): CV_BASE_PARAMETERS filtered to PARAM_NAME='FS_DISC_TYPE_CODE'
17. **Joined_FS_Discount_With_Discount_Types** (CTE 17): Join_5 – FS_DISCOUNT INNER JOIN FS_DISC_TYPES
18. **COVID_SALES** (CTE 18): CV_BASE_TLOGF_COVID logic → /POSDW/TLOGF with ITEMID filter
19. **RX_RETAIL_TYPES_COVID** (CTE 19): CV_BASE_PARAMETERS filtered to PARAM_NAME='RX_RETAIL_TYPE_CODE' (COVID usage)
20. **Joined_COVID_Sales_With_RX_Retail_Types** (CTE 20): Join_6 – COVID_SALES INNER JOIN RX_RETAIL_TYPES_COVID
21. **Combined_Flash_Sales_Inputs** (CTE 21): Union_1 – 6-branch UNION ALL
22. **COMBINE_DATA** (CTE 22): Aggregation node – GROUP BY grain + SUM/COUNT/MAX
23. **MERGED** (CTE 23): NAVIX INNER JOIN COMBINE_DATA
24. **Filtered_FLASH_SALES_VT_CAR** (CTE 24): Final-consumer timestamp filter
25. **Final SELECT**: Final CUBE aggregation with GROUP BY + SUM/MAX

---

## 6. Filter Traceability

| Filter | Source File | CTE Applied |
|---|---|---|
| RECORDQUALIFIER = '5' (FS sales) | xml_acc_cv_comp_flash_sales-VT-table-CV | FS_SALES (CTE 2) |
| RECORDQUALIFIER = '6' (FS discount) | xml_acc_cv_comp_flash_sales-VT-table-CV | FS_DISCOUNT (CTE 3) |
| RECORDQUALIFIER = '5' (RX sales) | xml_acc_cv_comp_flash_sales-VT-table-CV | RX_SALES (CTE 4) |
| RECORDQUALIFIER = '6' (EMP discount) | xml_acc_cv_comp_flash_sales-VT-table-CV | EMP_DISCOUNT (CTE 5) |
| TRANSTYPECODE NOT IN ('1107','1197','1020') | xml_acc_cv_base_tlogf-EMP_DISCOUNT | CTEs 2, 3, 4, 5 |
| WORKSTATIONID <> '0000000000' | xml_acc_cv_base_tlogf-EMP_DISCOUNT | CTEs 2, 3, 4, 5 |
| ARCHIVED = '' | xml_acc_cv_base_tlogf-EMP_DISCOUNT | CTEs 2, 3, 4, 5 |
| ZZ_UPD_TIMESTAMP <> '0' | xml_acc_cv_base_tlogf-EMP_DISCOUNT | CTEs 2, 3, 4, 5 |
| RECORDQUALIFIER = 25 (TLOGF_X) | xml_acc_cv_base_SCRIPTS-tlogf_x | SCRIPTS (CTE 6) |
| WORKSTATIONID <> '0000000000' (TLOGF_X) | xml_acc_cv_base_SCRIPTS-tlogf_x | SCRIPTS (CTE 6) |
| ZZ_UPD_TIMESTAMP <> 0 (TLOGF_X) | xml_acc_cv_base_SCRIPTS-tlogf_x | SCRIPTS (CTE 6) |
| PARAM_NAME = 'FS_RETAIL_TYPE_CODE' | xml_acc_cv_comp_flash_sales-VT-table-CV | FS_RETAIL_TYPES (CTE 10) |
| PARAM_NAME = 'EMP_DISC_TYPE_CODE' | xml_acc_cv_comp_flash_sales-VT-table-CV | EMP_DISC_TYPES (CTE 12) |
| PARAM_NAME = 'RX_RETAIL_TYPE_CODE' | xml_acc_cv_comp_flash_sales-VT-table-CV | RX_RETAIL_TYPES (CTE 14) |
| PARAM_NAME = 'FS_DISC_TYPE_CODE' | xml_acc_cv_comp_flash_sales-VT-table-CV | FS_DISC_TYPES (CTE 16) |
| RECORDQUALIFIER IN ('5','6') + ITEMID='A01-433556' | xml_acc_cv_base_tlogf_COVID_sales | COVID_SALES (CTE 18) |
| PARAM_NAME = 'RX_RETAIL_TYPE_CODE' (COVID) | xml_acc_cv_comp_flash_sales-VT-table-CV | RX_RETAIL_TYPES_COVID (CTE 19) |
| ZZ_UPD_TIMESTAMP >= @ip_upd_timestamp_from | xml_acc_FLASH_SALES_VT_CAR | Filtered_FLASH_SALES_VT_CAR (CTE 24) |
| ZZ_UPD_TIMESTAMP <= @ip_upd_timestamp_to | xml_acc_FLASH_SALES_VT_CAR | Filtered_FLASH_SALES_VT_CAR (CTE 24) |

---

## 7. Join Traceability

| Join | Type | Inputs | Condition | CTE |
|---|---|---|---|---|
| Join_1 | INNER | SCRIPTS, NAVIX_2 | MANDT, RETAILSTOREID, BUSINESSDAYDATE | Joined_Scripts_With_Currency (CTE 8) |
| Join_2 | INNER | FS_SALES, FS_RETAIL_TYPES | RETAILTYPECODE = low_char | Joined_FS_Sales_With_Retail_Types (CTE 11) |
| Join_3 | INNER | EMP_DISCOUNT, EMP_DISC_TYPES | DISCTYPECODE = low_char | Joined_Employee_Discount_With_Discount_Types (CTE 13) |
| Join_4 | INNER | RX_SALES, RX_RETAIL_TYPES | RETAILTYPECODE = low_char | Joined_RX_Sales_With_Retail_Types (CTE 15) |
| Join_5 | INNER | FS_DISCOUNT, FS_DISC_TYPES | DISCTYPECODE = low_char | Joined_FS_Discount_With_Discount_Types (CTE 17) |
| Join_6 | INNER | COVID_SALES, RX_RETAIL_TYPES_COVID | RETAILTYPECODE = low_char | Joined_COVID_Sales_With_RX_Retail_Types (CTE 20) |
| MERGED | INNER | NAVIX, COMBINE_DATA | MANDT, RETAILSTOREID, BUSINESSDAYDATE | MERGED (CTE 23) |

---

## 8. Aggregation Traceability

| Aggregation Stage | Grain | Aggregation Functions | CTE |
|---|---|---|---|
| COMBINE_DATA (intermediate) | MANDT, RETAILSTOREID, BUSINESSDAYDATE, TRANSCURRENCY, ZZ_UPD_TIMESTAMP | SUM(fs_salesamount, reductionamount, rx_salesamount, cal_fs_units, emp_reductionamount, cal_rx_cnt_ge84_ns, cal_rx_cnt_ge84_re, cal_rx_cnt_ns, cal_rx_cnt_re, cvd_amount, cal_cvd_units); COUNT(ZZ_RX_CNT_NS, ZZ_RX_CNT_REFILL, ZZ_RX_CNT_GE84_NS, ZZ_RX_CNT_GE84_RE, ZZ_RX_MCRX_GE84_NS, ZZ_RX_MCRX_GE84_RE); MAX(fs_upd_timestamp, rx_upd_timestamp, scripts_upd_timestamp) | COMBINE_DATA (CTE 22) |
| Final CUBE aggregation | MANDT, RETAILSTOREID, BUSINESSDAYDATE, ZZ_UPD_TIMESTAMP, TRANSCURRENCY | SUM(fs_salesamount, reductionamount, rx_salesamount, cal_fs_units, emp_reductionamount, cal_rx_cnt_ge84_ns, cal_rx_cnt_ge84_re, cal_rx_cnt_ns, cal_rx_cnt_re, cvd_amount, cal_cvd_units); MAX(rx_upd_timestamp, fs_upd_timestamp, scripts_upd_timestamp) | Final SELECT |

---

## 9. Calculation Traceability

| Calculated Column | Formula | Source File | CTE |
|---|---|---|---|
| cal_fs_units | CASE WHEN ZZ_CUSTTYPE IN ('F','M','R') THEN 1 WHEN IN ('X','Y','Z') THEN -1 ELSE 0 END | xml_acc_cv_comp_flash_sales-VT-table-CV | SCRIPT_KPIs (CTE 9) |
| cal_rx_cnt_ge84_ns | CASE WHEN ZZ_RX_CNT_GE84_NS='' THEN 0 ELSE CAST(ZZ_RX_CNT_GE84_NS AS INT64) END | xml_acc_cv_comp_flash_sales-VT-table-CV | SCRIPT_KPIs (CTE 9) |
| cal_rx_cnt_ge84_re | CASE WHEN ZZ_RX_CNT_GE84_RE='' THEN 0 ELSE CAST(ZZ_RX_CNT_GE84_RE AS INT64) END | xml_acc_cv_comp_flash_sales-VT-table-CV | SCRIPT_KPIs (CTE 9) |
| cal_rx_cnt_ns | CASE WHEN ZZ_RX_CNT_NS='' THEN 0 ELSE CAST(ZZ_RX_CNT_NS AS INT64) END | xml_acc_cv_comp_flash_sales-VT-table-CV | SCRIPT_KPIs (CTE 9) |
| cal_rx_cnt_re | CASE WHEN ZZ_RX_CNT_REFILL='' THEN 0 ELSE CAST(ZZ_RX_CNT_REFILL AS INT64) END | xml_acc_cv_comp_flash_sales-VT-table-CV | SCRIPT_KPIs (CTE 9) |
| cal_cvd_units | CASE WHEN WORKSTATIONID='0000000555' AND ZZ_CUSTTYPE='C' THEN 1 WHEN WORKSTATIONID='0000000555' AND ZZ_CUSTTYPE='W' THEN -1 ELSE 0 END | xml_acc_cv_comp_flash_sales-VT-table-CV | SCRIPT_KPIs (CTE 9) |
| LOW_CHAR (alias) | PARAM_VALUE_LOW AS low_char | xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES | CTEs 10, 12, 14, 16, 19 |

---

## 10. UNION Branch Traceability

| Branch | Source CTE | Metric Contributed | ZZ_UPD_TIMESTAMP Source |
|---|---|---|---|
| 1 (Scripts) | SCRIPT_KPIs | cal_fs_units, cal_rx_cnt_*, cal_cvd_units, ZZ_RX_* counters | scripts_upd_timestamp |
| 2 (FS Sales) | Joined_FS_Sales_With_Retail_Types | fs_salesamount | fs_upd_timestamp |
| 3 (Employee Discount) | Joined_Employee_Discount_With_Discount_Types | emp_reductionamount | emp_disc_upd_timestamp |
| 4 (RX Sales) | Joined_RX_Sales_With_Retail_Types | rx_salesamount | rx_upd_timestamp |
| 5 (FS Discount) | Joined_FS_Discount_With_Discount_Types | reductionamount | fs_disc_upd_timestamp |
| 6 (COVID Sales) | Joined_COVID_Sales_With_RX_Retail_Types | cvd_amount | cvd_upd_timestamp |

---

## 11. Parameter Documentation

| Parameter | BigQuery Name | Type | Source | Usage | Notes |
|---|---|---|---|---|---|
| IP_UPD_TIMESTAMP_FROM | @ip_upd_timestamp_from | STRING (REQUIRES VALIDATION) | xml_acc_FLASH_SALES_VT_CAR; HANA localVariable with default '19000101000000' | WHERE zz_upd_timestamp >= @ip_upd_timestamp_from in CTE 24 | Actual BQ type depends on zz_upd_timestamp column type; default documented in comments only |
| IP_UPD_TIMESTAMP_TO | @ip_upd_timestamp_to | STRING (REQUIRES VALIDATION) | xml_acc_FLASH_SALES_VT_CAR; HANA localVariable with default '99991231125959' | WHERE zz_upd_timestamp <= @ip_upd_timestamp_to in CTE 24 | Actual BQ type depends on zz_upd_timestamp column type; default documented in comments only |

---

## 12. Table and Column Mapping

### Tables Referenced vs Columns_Mapping_v3

| HANA Source Table | BigQuery Table Used in SQL | Columns_Mapping_v3 Status |
|---|---|---|
| SAPABAP1./POSDW/NAVIX | `PROJECT.DATASET.POSDW_NAVIX` (placeholder) | **MISSING** – not in CSV |
| SAPABAP1./POSDW/TLOGF | `PROJECT.DATASET.POSDW_TLOGF` (placeholder) | **MISSING** – not in CSV |
| SAPABAP1./POSDW/TLOGF_X | `PROJECT.DATASET.POSDW_TLOGF_X` (placeholder) | **MISSING** – not in CSV |
| SAPABAP1.ZTFIRP_FLASH_PRM | `PROJECT.DATASET.ZTFIRP_FLASH_PRM` (placeholder) | **MISSING** – not in CSV |
| CVS_FRIP.FLASH_SALES_VT_CAR | Inlined (replaced by composite view logic) | **MISSING** – not in CSV |

**All 15 tables in Columns_Mapping_v3** (CEPCT, ZTFIGL_RCALWEEK, ZTSRP_COMPFL, ZTSRP_ATTR_ACT, HRRP_NODE, AZSRP_DS041_VT_S4, AZSRP_DS052_VT_S4, AZSRP_DS112_VT_S4, AZSRP_DS072_VT_S4, AZSRP_DS092_VT_S4, AZSRP_DS031_VT_S4, ACDOCA_VT_S4, BKPF, FAGLSKF_PN, FINSC_FISC_DATE) are **not referenced** by this dependency chain and are therefore ignored per the validation rules.

### Column Mapping Status

Because all five physical source tables are absent from Columns_Mapping_v3, **no column-level mappings could be applied**. All column names in the consolidated SQL retain their HANA/source names as provided in the converted SQL files. This is a blocking validation item.

---

## 13. Alias Check

- All output column aliases in the final SELECT and in each CTE are written in BigQuery style (lowercase).
- No redundant HANA-name aliases were introduced.
- Meaningful renames preserved:
  - `SALESAMOUNT AS fs_salesamount` (FS_SALES CTE 2) – meaningful rename per composite view mapping
  - `ZZ_UPD_TIMESTAMP AS fs_upd_timestamp` (FS_SALES CTE 2)
  - `SALESAMOUNT AS rx_salesamount` (RX_SALES CTE 4)
  - `ZZ_UPD_TIMESTAMP AS rx_upd_timestamp` (RX_SALES CTE 4)
  - `REDUCTIONAMOUNT AS emp_reductionamount` (EMP_DISCOUNT CTE 5)
  - `ZZ_UPD_TIMESTAMP AS scripts_upd_timestamp` (SCRIPT_KPIs CTE 9)
  - `SALESAMOUNT AS cvd_amount` (COVID_SALES CTE 18)
  - `ZZ_UPD_TIMESTAMP AS cvd_upd_timestamp` (COVID_SALES CTE 18)
  - `PARAM_VALUE_LOW AS low_char` (all parameter CTEs)
  - `ZZ_UPD_TIMESTAMP AS emp_disc_upd_timestamp` (Joined_Employee_Discount_With_Discount_Types CTE 13)
  - `ZZ_UPD_TIMESTAMP AS fs_disc_upd_timestamp` (Joined_FS_Discount_With_Discount_Types CTE 17)

---

## 14. Data Type Handling

- **ZZ_UPD_TIMESTAMP**: Datatype is unresolved (not in Columns_Mapping_v3). Used as STRING in filter comparisons (`<> '0'`) and as STRING in UNION NULL casts (`CAST(NULL AS STRING)`). Comparison with @ip_upd_timestamp_from and @ip_upd_timestamp_to uses the same type. **REQUIRES VALIDATION.**
- **RECORDQUALIFIER in TLOGF**: Compared to string literals ('5', '6'). **REQUIRES VALIDATION** – actual BQ type unknown.
- **RECORDQUALIFIER in TLOGF_X**: Compared to numeric literal 25. **REQUIRES VALIDATION** – actual BQ type unknown.
- **TRANSTYPECODE**: Compared to string literals ('1107', '1197', '1020'). **REQUIRES VALIDATION.**
- **SALESAMOUNT, REDUCTIONAMOUNT, cvd_amount**: Assumed NUMERIC for SUM aggregation and CAST(NULL AS NUMERIC) in UNION. **REQUIRES VALIDATION.**
- **Timestamp fields (fs_upd_timestamp, rx_upd_timestamp, scripts_upd_timestamp)**: Used as STRING in UNION NULL casts. **REQUIRES VALIDATION** – may need TIMESTAMP or DATETIME type.
- **cal_fs_units, cal_rx_cnt_***: INT64 from CAST expressions and UNION NULL casts.
- **ZZ_RX_CNT_*** fields: STRING (compared to '' in CASE expressions).

---

## 15. CTE Helper Justification

Every CTE in the consolidated SQL is justified by a real semantic boundary:
- **NAVIX / NAVIX_2**: Two distinct usages of CV_BASE_NAVIX in the composite view (grain keys vs. currency join). Separate CTEs required to avoid self-join ambiguity.
- **FS_SALES / FS_DISCOUNT / RX_SALES / EMP_DISCOUNT**: Four distinct RECORDQUALIFIER-filtered branches of the same source table. Separate CTEs required because each feeds a different UNION branch with different column projections.
- **SCRIPTS**: Distinct source table (TLOGF_X) with different filters.
- **Joined_Scripts_With_Currency**: Required join boundary (Join_1).
- **SCRIPT_KPIs**: Required calculation boundary (CASE expressions over joined data).
- **FS_RETAIL_TYPES / EMP_DISC_TYPES / RX_RETAIL_TYPES / FS_DISC_TYPES / RX_RETAIL_TYPES_COVID**: Five distinct PARAM_NAME-filtered projections of the same parameters table. Each feeds a different join.
- **Joined_* CTEs (11, 13, 15, 17, 20)**: Required join boundaries for each of the five inner joins.
- **COVID_SALES**: Distinct filter (ITEMID='A01-433556') on the same TLOGF source.
- **Combined_Flash_Sales_Inputs**: Required UNION ALL boundary.
- **COMBINE_DATA**: Required aggregation boundary (intermediate grain).
- **MERGED**: Required join boundary (NAVIX × COMBINE_DATA).
- **Filtered_FLASH_SALES_VT_CAR**: Required filter boundary (final-consumer timestamp filter applied after composite view logic).

---

## 16. Procedure / ETL Handling

No stored procedures, INSERT-SELECT, CREATE TABLE AS SELECT, or MERGE statements were present in the supplied converted SQL files. All artifacts are Calculation View XMLs interpreted as SELECT logic.

---

## 17. Star Projection Validation

No `SELECT *` projections were used. All CTEs use explicit column lists.

---

## 18. Duplicate Column Check

Each CTE and the final SELECT were reviewed for duplicate aliases. No duplicate output aliases were found within any single SELECT.

---

## 19. Lineage Edge Validation

All 6 lineage edges from `VT_CAR Relationships Table` are represented:
- Edge 1 (NAVIX → COMP): ✅ CTEs 1, 7
- Edge 2 (TLOGF_X → COMP): ✅ CTE 6
- Edge 3 (PARAMETERS → COMP ×5): ✅ CTEs 10, 12, 14, 16, 19
- Edge 4 (TLOGF → COMP ×4): ✅ CTEs 2, 3, 4, 5
- Edge 5 (TLOGF_COVID → COMP): ✅ CTE 18
- Edge 6 (COMP → FINAL): ✅ CTEs 8–24 + Final SELECT

---

## 20. Final Quality Gate Results

| Check | Result |
|---|---|
| Final consumer unambiguous | ✅ PASS |
| Artifact dependencies match lineage | ✅ PASS |
| Final-consumer transformation order preserved | ✅ PASS |
| Dependencies expanded at point of consumption | ✅ PASS |
| No generic Source→Intermediate→Target ordering | ✅ PASS |
| Every file classified USED/NOT USED | ✅ PASS |
| All converted dependencies expanded | ✅ PASS |
| Only terminal sources remain | ⚠️ FAIL – terminal source tables not in Columns_Mapping_v3 (see Issues) |
| Every physical source uses BQ_FULL_TABLE | ⚠️ FAIL – placeholders used (see Issues) |
| Every referenced column mapped via Columns_Mapping_v3 | ⚠️ FAIL – no mappings available (see Issues) |
| All comparisons type-consistent | ⚠️ FAIL – types unresolved for ZZ_UPD_TIMESTAMP, RECORDQUALIFIER, TRANSTYPECODE (see Issues) |
| Final-consumer CTE names and order preserved | ✅ PASS |
| Compatible operations combined | ✅ PASS |
| No source node becomes CTE merely to mirror structure | ✅ PASS |
| Every helper CTE justified by semantic boundary | ✅ PASS |
| Every CTE matches output contract | ✅ PASS |
| All column references qualified where ambiguous | ✅ PASS |
| No duplicate aliases within any SELECT | ✅ PASS |
| No star projections with ambiguity | ✅ PASS |
| All filters preserved | ✅ PASS |
| All aggregation stages preserve grain | ✅ PASS |
| UNION branches type-consistent | ⚠️ PARTIAL – timestamp/numeric types assumed; REQUIRES VALIDATION |
| No procedural semantics discarded | ✅ PASS (no procedures) |
| Runtime parameters documented | ✅ PASS |
| Single query, no DECLARE/SET | ✅ PASS |
| Every CTE has standardized comment header | ✅ PASS |
| All lineage edges represented | ✅ PASS |

---

## 21. ISSUES TO FIX

### Issue 1 – REQUIRES VALIDATION: MISSING TABLE MAPPING
**Affected tables:** `/POSDW/NAVIX`, `/POSDW/TLOGF`, `/POSDW/TLOGF_X`, `ZTFIRP_FLASH_PRM`, `FLASH_SALES_VT_CAR`  
**Evidence:** Full Columns_Mapping_v3.csv read; none of these tables appear in any row.  
**Impact:** All five physical source tables use placeholder names (`PROJECT.DATASET.POSDW_NAVIX`, etc.). The SQL cannot execute until actual BigQuery `project.dataset.table` values are substituted.  
**Resolution needed:** Provide Columns_Mapping_v3 rows for these five tables with BQ_FULL_TABLE values.

### Issue 2 – REQUIRES VALIDATION: MISSING COLUMN MAPPING
**Affected columns:** All columns of the five tables above (MANDT, RETAILSTOREID, BUSINESSDAYDATE, CURRENCY, SALESAMOUNT, REDUCTIONAMOUNT, RECORDQUALIFIER, TRANSTYPECODE, WORKSTATIONID, ARCHIVED, RETAILTYPECODE, ZZ_UPD_TIMESTAMP, DISCTYPECODE, TRANSCURRENCY, ITEMID, ZZ_RX_CNT_NS, ZZ_RX_CNT_REFILL, ZZ_RX_CNT_GE84_NS, ZZ_RX_CNT_GE84_RE, ZZ_RX_MCRX_GE84_NS, ZZ_RX_MCRX_GE84_RE, ZZ_CUSTTYPE, WORKSTATIONID, PARAM_NAME, PARAM_VALUE_LOW, PARAM_VALUE_HIGH)  
**Evidence:** No rows for these tables in Columns_Mapping_v3.  
**Impact:** Column names in the SQL retain HANA/source spelling. BQ_COLUMN values and BQ_DATATYPE values cannot be applied.  
**Resolution needed:** Provide column-level mappings for all five tables.

### Issue 3 – REQUIRES VALIDATION: ZZ_UPD_TIMESTAMP DATA TYPE
**Affected:** All CTEs reading from /POSDW/TLOGF, /POSDW/TLOGF_X, and the final filter in CTE 24.  
**Evidence:** Datatype not in Columns_Mapping_v3; converted SQL files note it as unresolved.  
**Impact:** Filter comparisons (`<> '0'`, `>= @ip_upd_timestamp_from`, `<= @ip_upd_timestamp_to`) and UNION NULL casts (`CAST(NULL AS STRING)`) may be incorrect.  
**Resolution needed:** Confirm BQ_DATATYPE for ZZ_UPD_TIMESTAMP and adjust literals, casts, and parameter types accordingly.

### Issue 4 – REQUIRES VALIDATION: RECORDQUALIFIER FILTER TYPE (TLOGF_X)
**Affected:** SCRIPTS CTE (CTE 6), filter `RECORDQUALIFIER = 25`  
**Evidence:** xml_acc_cv_base_SCRIPTS-tlogf_x notes the filter value as numeric 25; actual BQ column type unknown.  
**Impact:** If RECORDQUALIFIER is STRING in BigQuery, the filter must be `RECORDQUALIFIER = '25'`.  
**Resolution needed:** Confirm BQ_DATATYPE for RECORDQUALIFIER in /POSDW/TLOGF_X.

### Issue 5 – REQUIRES VALIDATION: TIMESTAMP FIELD TYPES IN UNION BRANCHES
**Affected:** Combined_Flash_Sales_Inputs (CTE 21), CAST(NULL AS STRING) for fs_upd_timestamp, rx_upd_timestamp, scripts_upd_timestamp  
**Evidence:** Actual datatype of ZZ_UPD_TIMESTAMP (which feeds these timestamp fields) is unresolved.  
**Impact:** If the actual type is TIMESTAMP or DATETIME, the NULL casts must be updated accordingly.  
**Resolution needed:** Confirm BQ_DATATYPE for ZZ_UPD_TIMESTAMP and update UNION NULL casts.

### Issue 6 – NON-BLOCKING: FLASH_SALES_VT_CAR Physical Table Bypassed
**Note:** The final consumer (CV_BASE_FIN_FLASH_SALES_CAR) reads from `CVS_FRIP.FLASH_SALES_VT_CAR`, which is a physical reporting/staging table populated by the composite view. Since the composite view logic is fully supplied and inlined, the consolidated SQL replaces the staging table read with the inline composite logic. This is the correct consolidation approach per the system prompt (do not read a staging table directly when its population logic is supplied). This is non-blocking but should be validated that the inlined logic produces equivalent results.

---

*This consolidation is NOT production-ready due to the missing table and column mappings listed above. The SQL structure, logic, filters, joins, calculations, aggregations, and UNION branches are complete and faithful to the supplied converted SQL files.*
