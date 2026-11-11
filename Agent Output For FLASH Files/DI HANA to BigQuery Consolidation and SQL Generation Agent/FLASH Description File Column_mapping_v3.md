# FLASH Sales Consolidation Description
## HANA to BigQuery – Column_mapping_v3

---

## 1. Pre-Consolidation Input Confirmation

### 1.1 Lineage Rows Read (Flash sales Relationships Table)

| # | Source File | Target File | Dependency Type |
|---|---|---|---|
| 1 | xml_acc_FLASH_SALES_VT_CAR | xml_acc_cv_comp_fin_flash | Calculation View Dependency |
| 2 | xml_acc_cv_base_MD_RCALWEEK_S4 | xml_acc_cv_comp_fin_flash | Calculation View Dependency |
| 3 | xml_acc_cv_comp_fin_flash | STP_WSS_FLASH_SALES | Stored Procedure Dependency |
| 4 | STP_WSS_FLASH_SALES | xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales | Stored Procedure Dependency |

All 4 lineage rows were read in full.

### 1.2 Files in `flash sales converted bigqueries`

| File | Classification | Reason |
|---|---|---|
| `STP_WSS_FLASH_SALES_DI HANA to BigQuery SQL Conversion Agent.txt` | **USED** | Stored procedure that populates TBL_WSS_FLASH_SALES; its INSERT-SELECT body is inlined at the point of consumption |
| `xml_acc_cv_comp_fin_flash_DI HANA to BigQuery SQL Conversion Agent.txt` | **USED** | Composite calculation view CV_COMP_FIN_FLASH; its full CTE chain is inlined |
| `xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales_DI HANA to BigQuery SQL Conversion Agent.txt` | **USED** | Final consumer CV_COMP_FIN_FLASH_STATIC; its aggregation logic defines the final SELECT |
| `xml_acc_cv_base_MD_RCALWEEK_S4_DI HANA to BigQuery SQL Conversion Agent.txt` | **USED** | Retail calendar dimension; inlined as RETAIL_CALENDAR CTE |
| `VT_CAR Consolidated File Column_mapping_v1.txt` | **USED** | Previously consolidated CV_BASE_FIN_FLASH_SALES_CAR (xml_acc_FLASH_SALES_VT_CAR); its CTE chain (CTEs 1–22) is inlined as the source for FLASH CTE |

### 1.3 Columns_Mapping_v3.csv

Total rows read: **full file** (all rows inspected before any mapping decision).

Tables referenced by the expanded SQL and their mapping status:

| HANA Table | BQ_FULL_TABLE | Status |
|---|---|---|
| ZTFIGL_RCALWEEK | `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek` | OK |
| ZTSRP_COMPFL | `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl` | OK |
| ZTSRP_ATTR_ACT | `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act` | OK |
| HRRP_NODE | `edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node` | OK |
| CEPCT | `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct` | OK |
| /POSDW/NAVIX | **NOT IN CSV** | REQUIRES VALIDATION: MISSING TABLE MAPPING |
| /POSDW/TLOGF | **NOT IN CSV** | REQUIRES VALIDATION: MISSING TABLE MAPPING |
| /POSDW/TLOGF_X | **NOT IN CSV** | REQUIRES VALIDATION: MISSING TABLE MAPPING |
| ZTFIRP_FLASH_PRM | **NOT IN CSV** | REQUIRES VALIDATION: MISSING TABLE MAPPING |

---

## 2. Final Consumer Identification

**Final consumer:** `xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales`  
**HANA artifact:** `CV_COMP_FIN_FLASH_STATIC`  
**Type:** Calculation View XML, dataCategory=CUBE, outputViewType=Aggregation  
**Source table:** `CVS_FRIP.Table::TBL_WSS_FLASH_SALES`

This view reads from the staging table `TBL_WSS_FLASH_SALES`, which is populated by the stored procedure `STP_WSS_FLASH_SALES`. Because the procedure's INSERT-SELECT body is supplied, the staging table is replaced by that body and the procedure's full source logic is inlined.

---

## 3. Artifact Dependency Mapping and Lineage Edges

### Lineage Edge 1: xml_acc_FLASH_SALES_VT_CAR → xml_acc_cv_comp_fin_flash
- **Producer:** CV_BASE_FIN_FLASH_SALES_CAR (VT_CAR consolidated view)
- **Consumer:** CV_COMP_FIN_FLASH (FLASH CTE)
- **SQL location:** CTEs 1–23 (NAVIX through FLASH) inline the full VT_CAR dependency chain. CTE 23 (FLASH) is the point of consumption, applying the BUSINESSDAYDATE and zz_upd_timestamp filters passed from the procedure.

### Lineage Edge 2: xml_acc_cv_base_MD_RCALWEEK_S4 → xml_acc_cv_comp_fin_flash
- **Producer:** CV_BASE_MD_RCALWEEK_S4 (retail calendar)
- **Consumer:** CV_COMP_FIN_FLASH (WEEK CTE)
- **SQL location:** CTE 24 (RETAIL_CALENDAR) inlines CV_BASE_MD_RCALWEEK_S4 logic with its rclnt IN ('120','200') filter. CTE 25 (WEEK) is the point of consumption.

### Lineage Edge 3: xml_acc_cv_comp_fin_flash → STP_WSS_FLASH_SALES
- **Producer:** CV_COMP_FIN_FLASH
- **Consumer:** STP_WSS_FLASH_SALES (INSERT-SELECT)
- **SQL location:** CTEs 23–38 implement CV_COMP_FIN_FLASH in full. The procedure's four placeholder parameters ($$IP_WEEK_ENDING_FROM$$, $$IP_WEEK_ENDING_TO$$, $$IP_UPD_TIMESTAMP_FROM$$, $$IP_UPD_TIMESTAMP_TO$$) become runtime parameters @ip_week_ending_from, @ip_week_ending_to, @ip_upd_timestamp_from, @ip_upd_timestamp_to applied in CTE 23 (FLASH).

### Lineage Edge 4: STP_WSS_FLASH_SALES → xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales
- **Producer:** STP_WSS_FLASH_SALES (populates TBL_WSS_FLASH_SALES)
- **Consumer:** CV_COMP_FIN_FLASH_STATIC (reads TBL_WSS_FLASH_SALES)
- **SQL location:** The entire CTE chain (CTEs 1–38) replaces TBL_WSS_FLASH_SALES. The final SELECT implements CV_COMP_FIN_FLASH_STATIC's CUBE/Aggregation output contract.

---

## 4. Final Consumer Flow and CTE Sequence

The consolidated query follows the actual node sequence from the final-consumer and its dependency chain:

| CTE # | Name | Origin |
|---|---|---|
| 1 | NAVIX | CV_BASE_NAVIX (VT_CAR chain) |
| 2 | FS_SALES | CV_BASE_TLOGF / FS_SALES branch |
| 3 | FS_DISCOUNT | CV_BASE_TLOGF / FS_DISCOUNT branch |
| 4 | RX_SALES | CV_BASE_TLOGF / RX_SALES branch |
| 5 | EMP_DISCOUNT | CV_BASE_TLOGF / EMP_DISCOUNT branch |
| 6 | SCRIPTS | CV_BASE_TLOGF_X |
| 7 | Joined_Scripts_With_Currency | Join_1 (CV_COMP_FLASH_SALES) |
| 8 | SCRIPT_KPIs | SCRIPT_KPIs node |
| 9 | FS_RETAIL_TYPES | CV_BASE_PARAMETERS / FS_RETAIL_TYPE_CODE |
| 10 | Joined_FS_Sales_With_Retail_Types | Join_2 |
| 11 | EMP_DISC_TYPES | CV_BASE_PARAMETERS / EMP_DISC_TYPE_CODE |
| 12 | Joined_Employee_Discount_With_Discount_Types | Join_3 |
| 13 | RX_RETAIL_TYPES | CV_BASE_PARAMETERS / RX_RETAIL_TYPE_CODE |
| 14 | Joined_RX_Sales_With_Retail_Types | Join_4 |
| 15 | FS_DISC_TYPES | CV_BASE_PARAMETERS / FS_DISC_TYPE_CODE |
| 16 | Joined_FS_Discount_With_Discount_Types | Join_5 |
| 17 | COVID_SALES | CV_BASE_TLOGF_COVID |
| 18 | RX_RETAIL_TYPES_COVID | CV_BASE_PARAMETERS / RX_RETAIL_TYPE_CODE (COVID branch) |
| 19 | Joined_COVID_Sales_With_RX_Retail_Types | Join_6 |
| 20 | Combined_Flash_Sales_Inputs | Union_1 (CV_COMP_FLASH_SALES) |
| 21 | COMBINE_DATA | COMBINE_DATA aggregation node |
| 22 | MERGED | MERGED join node |
| 23 | FLASH | FLASH node of CV_COMP_FIN_FLASH + procedure filters |
| 24 | RETAIL_CALENDAR | CV_BASE_MD_RCALWEEK_S4 |
| 25 | WEEK | WEEK node of CV_COMP_FIN_FLASH |
| 26 | COMP_FLAG | COMP_FLAG node / CV_BASE_MD_COMPFL_S4 |
| 27 | HIERARCHY | HIERARCHY node / CV_BASE_MD_HRRP_NODE_S4 |
| 28 | STORE_ATTR | STORE_ATTR node / CV_BASE_MD_SRPACT_S4 |
| 29 | Joined_Week_Store_Attributes | Join_6 of CV_COMP_FIN_FLASH |
| 30 | Joined_Core_Retail_Hierarchy | Join_3 of CV_COMP_FIN_FLASH |
| 31 | Joined_Comp_Flag_Data | COMP_FLG of CV_COMP_FIN_FLASH |
| 32 | CALCULATIONS | CALCULATIONS node |
| 33 | EMPLOYEE_DISCOUNT | EMPLOYEE_DISCOUNT aggregation node |
| 34 | COMP_NONCOMP_STORE_ATTR | COMP_NONCOMP_STORE_ATTR node |
| 35 | Joined_Employee_Discount_Store_Attributes | Join_4 of CV_COMP_FIN_FLASH |
| 36 | Combined_Flash_And_Employee_Discount | Union_1 of CV_COMP_FIN_FLASH |
| 37 | PROFIT_CENTER_TEXT | PROFIT_CENTER_TEXT node |
| 38 | Join_5 | Join_5 of CV_COMP_FIN_FLASH |
| Final SELECT | — | CV_COMP_FIN_FLASH_STATIC CUBE/Aggregation |

---

## 5. Dependency Expansion and Point-of-Consumption Mapping

### STP_WSS_FLASH_SALES (Stored Procedure)
- **DML wrappers skipped:** `DELETE FROM TBL_WSS_FLASH_SALES WHERE TRUE` and `INSERT INTO TBL_WSS_FLASH_SALES (...)` — these are DML wrappers; the SELECT body is inlined.
- **Audit columns excluded:** `SNAPSHOT_TIMESTAMP` (CURRENT_TIMESTAMP) and `CREATED_BY` (SESSION_USER) are populated only by the INSERT statement, not by the SELECT logic of CV_COMP_FIN_FLASH. They appear in the final SELECT as `CAST(NULL AS TIMESTAMP)` and `CAST(NULL AS STRING)` respectively, because CV_COMP_FIN_FLASH_STATIC includes them as pass-through attributes from TBL_WSS_FLASH_SALES.
- **Procedure filters inlined at CTE 23 (FLASH):**
  - `BUSINESSDAYDATE >= @ip_week_ending_from` (from V_WEEK_ENDING_FROM_DATE)
  - `BUSINESSDAYDATE <= @ip_week_ending_to` (from V_WEEK_ENDING_TO_DATE)
  - `zz_upd_timestamp >= @ip_upd_timestamp_from` (from V_UPDATE_TIMESTAMP_FROM)
  - `zz_upd_timestamp <= @ip_upd_timestamp_to` (from V_UPDATE_TIMESTAMP_TO)

### CV_COMP_FIN_FLASH (Calculation View)
Fully expanded at CTEs 23–38 and the final SELECT. All nodes, joins, filters, calculations, aggregations, and the union are preserved.

### CV_BASE_MD_RCALWEEK_S4 (Calculation View)
Expanded at CTE 24 (RETAIL_CALENDAR). Filter `rclnt IN ('120', '200')` preserved. rclnt BQ_DATATYPE = STRING, so filter values remain as string literals.

### CV_BASE_FIN_FLASH_SALES_CAR / VT_CAR (Consolidated View)
Expanded at CTEs 1–22. The full VT_CAR dependency chain (NAVIX, six TLOGF/TLOGF_X branches, six parameter joins, union, aggregation, NAVIX inner join) is inlined. CTE 23 (FLASH) applies the additional CV_COMP_FIN_FLASH-level filters on top.

---

## 6. Filter Trace

| Filter | Source File | SQL Location |
|---|---|---|
| RECORDQUALIFIER = '5' (FS sales) | VT_CAR consolidated | CTE 2 (FS_SALES) WHERE |
| RECORDQUALIFIER = '6' (FS discount) | VT_CAR consolidated | CTE 3 (FS_DISCOUNT) WHERE |
| RECORDQUALIFIER = '5' (RX sales) | VT_CAR consolidated | CTE 4 (RX_SALES) WHERE |
| RECORDQUALIFIER = '6' (EMP discount) | VT_CAR consolidated | CTE 5 (EMP_DISCOUNT) WHERE |
| RECORDQUALIFIER = 25 (SCRIPTS) | VT_CAR consolidated | CTE 6 (SCRIPTS) WHERE |
| TRANSTYPECODE NOT IN ('1107','1197','1020') | VT_CAR consolidated | CTEs 2,3,4,5,17 WHERE |
| WORKSTATIONID <> '0000000000' | VT_CAR consolidated | CTEs 2,3,4,5,6,17 WHERE |
| ARCHIVED = '' | VT_CAR consolidated | CTEs 2,3,4,5,17 WHERE |
| ZZ_UPD_TIMESTAMP <> '0' | VT_CAR consolidated | CTEs 2,3,4,5,17 WHERE |
| ZZ_UPD_TIMESTAMP <> 0 | VT_CAR consolidated | CTE 6 (SCRIPTS) WHERE |
| ITEMID = 'A01-433556' | VT_CAR consolidated | CTE 17 (COVID_SALES) WHERE |
| PARAM_NAME = 'FS_RETAIL_TYPE_CODE' | VT_CAR consolidated | CTE 9 WHERE |
| PARAM_NAME = 'EMP_DISC_TYPE_CODE' | VT_CAR consolidated | CTE 11 WHERE |
| PARAM_NAME = 'RX_RETAIL_TYPE_CODE' | VT_CAR consolidated | CTEs 13, 18 WHERE |
| PARAM_NAME = 'FS_DISC_TYPE_CODE' | VT_CAR consolidated | CTE 15 WHERE |
| rclnt IN ('120', '200') | xml_acc_cv_base_MD_RCALWEEK_S4 | CTE 24 (RETAIL_CALENDAR) WHERE |
| RETAILSTOREID < '0000020000' OR > '0000024999' | xml_acc_cv_comp_fin_flash | CTE 23 (FLASH) WHERE |
| BUSINESSDAYDATE >= @ip_week_ending_from | STP_WSS_FLASH_SALES + xml_acc_cv_comp_fin_flash | CTE 23 (FLASH) WHERE |
| BUSINESSDAYDATE <= @ip_week_ending_to | STP_WSS_FLASH_SALES + xml_acc_cv_comp_fin_flash | CTE 23 (FLASH) WHERE |
| zz_upd_timestamp >= @ip_upd_timestamp_from | STP_WSS_FLASH_SALES | CTE 23 (FLASH) WHERE |
| zz_upd_timestamp <= @ip_upd_timestamp_to | STP_WSS_FLASH_SALES | CTE 23 (FLASH) WHERE |
| comp_ver = @ip_version | xml_acc_cv_comp_fin_flash | CTE 26 (COMP_FLAG) WHERE |
| REGEXP_CONTAINS(parnode, r'.*CORE_RET.*') | xml_acc_cv_comp_fin_flash | CTE 27 (HIERARCHY) WHERE |
| hryvalto = DATE '9999-12-31' | xml_acc_cv_comp_fin_flash | CTE 27 (HIERARCHY) WHERE |
| prctr IN ('0000562075','0000562076') | xml_acc_cv_comp_fin_flash | CTE 34 (COMP_NONCOMP_STORE_ATTR) WHERE |

---

## 7. Join Trace

| Join | Type | Condition | Source File | SQL Location |
|---|---|---|---|---|
| SCRIPTS ↔ NAVIX | INNER | MANDT, RETAILSTOREID, BUSINESSDAYDATE | VT_CAR | CTE 7 |
| FS_SALES ↔ FS_RETAIL_TYPES | INNER | RETAILTYPECODE = low_char | VT_CAR | CTE 10 |
| EMP_DISCOUNT ↔ EMP_DISC_TYPES | INNER | DISCTYPECODE = low_char | VT_CAR | CTE 12 |
| RX_SALES ↔ RX_RETAIL_TYPES | INNER | RETAILTYPECODE = low_char | VT_CAR | CTE 14 |
| FS_DISCOUNT ↔ FS_DISC_TYPES | INNER | DISCTYPECODE = low_char | VT_CAR | CTE 16 |
| COVID_SALES ↔ RX_RETAIL_TYPES_COVID | INNER | RETAILTYPECODE = low_char | VT_CAR | CTE 19 |
| NAVIX ↔ COMBINE_DATA | INNER | MANDT, RETAILSTOREID, BUSINESSDAYDATE | VT_CAR | CTE 22 |
| FLASH ↔ RETAIL_CALENDAR | LEFT | PARSE_DATE('%Y%m%d', cal_week_ending_date) = zrwenddate | xml_acc_cv_comp_fin_flash | CTE 25 |
| WEEK ↔ STORE_ATTR | LEFT | retailstoreid_car = strnum | xml_acc_cv_comp_fin_flash | CTE 29 |
| Joined_Week_Store_Attributes ↔ HIERARCHY | INNER | prctr = nodevalue | xml_acc_cv_comp_fin_flash | CTE 30 |
| Joined_Core_Retail_Hierarchy ↔ COMP_FLAG | LEFT | prctr = prctr AND zzweek = zweek | xml_acc_cv_comp_fin_flash | CTE 31 |
| EMPLOYEE_DISCOUNT ↔ COMP_NONCOMP_STORE_ATTR | LEFT | cal_prctr = prctr | xml_acc_cv_comp_fin_flash | CTE 35 |
| Combined_Flash_And_Employee_Discount ↔ PROFIT_CENTER_TEXT | LEFT | prctr = prctr | xml_acc_cv_comp_fin_flash | CTE 38 |

---

## 8. Aggregation Trace

| Aggregation | Grain | Source File | SQL Location |
|---|---|---|---|
| COMBINE_DATA: SUM/COUNT/MAX by MANDT, RETAILSTOREID, BUSINESSDAYDATE, transcurrency, zz_upd_timestamp | VT_CAR grain | VT_CAR | CTE 21 |
| EMPLOYEE_DISCOUNT: SUM(emp_reductionamount), MAX timestamps, GROUP BY dimensional attributes | CV_COMP_FIN_FLASH grain | xml_acc_cv_comp_fin_flash | CTE 33 |
| Final SELECT: SUM/MAX by all 40 logical-model attributes | CV_COMP_FIN_FLASH_STATIC logical model | xml_acc_cv_comp_fin_flash_static | Final SELECT |

---

## 9. Calculation Trace

| Calculation | Formula | Source File | SQL Location |
|---|---|---|---|
| cal_week_ending_date | FORMAT_DATE('%Y%m%d', DATE_ADD(PARSE_DATE('%Y%m%d', BUSINESSDAYDATE), INTERVAL (5 - CASE weekday_logic END) DAY)) | xml_acc_cv_comp_fin_flash | CTE 23 (FLASH) |
| cal_fs_units | CASE ZZ_CUSTTYPE IN ('F','M','R')→1, IN ('X','Y','Z')→-1, else 0 | VT_CAR | CTE 8 |
| cal_rx_cnt_ge84_ns | CASE ZZ_RX_CNT_GE84_NS=''→0, else CAST to INT64 | VT_CAR | CTE 8 |
| cal_rx_cnt_ge84_re | CASE ZZ_RX_CNT_GE84_RE=''→0, else CAST to INT64 | VT_CAR | CTE 8 |
| cal_rx_cnt_ns | CASE ZZ_RX_CNT_NS=''→0, else CAST to INT64 | VT_CAR | CTE 8 |
| cal_rx_cnt_re | CASE ZZ_RX_CNT_REFILL=''→0, else CAST to INT64 | VT_CAR | CTE 8 |
| cal_cvd_units | CASE WORKSTATIONID='0000000555' AND ZZ_CUSTTYPE='C'→1, 'W'→-1, else 0 | VT_CAR | CTE 8 |
| cal_scripts_90as3 | cal_rx_cnt_ns + cal_rx_cnt_re + (cal_rx_cnt_ge84_ns + cal_rx_cnt_ge84_re)*2 | xml_acc_cv_comp_fin_flash | CTE 32 |
| cal_comp_flag | CASE GREATEST(fs_comp_wk,rx_comp_wk) IS NULL→'0', else GREATEST(...) | xml_acc_cv_comp_fin_flash | CTE 32 |
| cal_week_number | RIGHT(zzweek, 2) | xml_acc_cv_comp_fin_flash | CTE 32 |
| cal_prctr | CASE cal_comp_flag='1'→'0000562075', '0'→'0000562076', else NULL | xml_acc_cv_comp_fin_flash | CTE 33 |

---

## 10. UNION Branch Trace

| Union | Branches | Source File | SQL Location |
|---|---|---|---|
| Combined_Flash_Sales_Inputs (Union_1 of VT_CAR) | 6 branches: SCRIPT_KPIs, FS_SALES+retail_types, EMP_DISCOUNT+disc_types, RX_SALES+retail_types, FS_DISCOUNT+disc_types, COVID_SALES+rx_retail_types | VT_CAR | CTE 20 |
| Combined_Flash_And_Employee_Discount (Union_1 of CV_COMP_FIN_FLASH) | 2 branches: CALCULATIONS (EMP_REDUCTIONAMOUNT=NULL), Joined_Employee_Discount_Store_Attributes (sales/script/cvd=NULL) | xml_acc_cv_comp_fin_flash | CTE 36 |

---

## 11. Parameter Documentation

| Parameter | Type | Source | Usage | Reason Unresolved |
|---|---|---|---|---|
| @ip_version | STRING | SFN_ACTUALS_COMP_FLAG (unresolved scalar function) | CTE 26 (COMP_FLAG) WHERE comp_ver = @ip_version | Function definition not supplied |
| @ip_week_ending_from | STRING | SFN_CURRENT_WEEK_START_DATE / V_WEEK_ENDING_FROM_DATE in procedure | CTE 23 (FLASH) WHERE BUSINESSDAYDATE >= @ip_week_ending_from | Function definition not supplied; procedure computes it at runtime |
| @ip_week_ending_to | STRING | SFN_CURRENT_WEEK_END_DATE / V_WEEK_ENDING_TO_DATE in procedure | CTE 23 (FLASH) WHERE BUSINESSDAYDATE <= @ip_week_ending_to | Function definition not supplied; procedure computes it at runtime |
| @ip_upd_timestamp_from | STRING | V_UPDATE_TIMESTAMP_FROM in procedure (YYYYMMDDHHMMSS format) | CTE 23 (FLASH) WHERE zz_upd_timestamp >= @ip_upd_timestamp_from | Procedure variable computed at runtime |
| @ip_upd_timestamp_to | STRING | V_UPDATE_TIMESTAMP_TO in procedure (YYYYMMDDHHMMSS format) | CTE 23 (FLASH) WHERE zz_upd_timestamp <= @ip_upd_timestamp_to | Procedure variable computed at runtime |

---

## 12. Table and Column Mapping Applied

### Mapped Physical Tables

#### `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek` (ZTFIGL_RCALWEEK)
Columns used and their BQ_COLUMN / BQ_DATATYPE:

| HANA_COLUMN_SQL | BQ_COLUMN | BQ_DATATYPE |
|---|---|---|
| RCLNT | rclnt | STRING |
| ZZWEEK | zzweek | STRING |
| ZRYEAR | zryear | STRING |
| ZRPERIOD | zrperiod | STRING |
| ZRYRP | zryrp | STRING |
| ZRWENDDATE | zrwenddate | DATE |
| ZRWSTRTDATE | zrwstrtdate | DATE |

Filter: `rclnt IN ('120', '200')` — rclnt is STRING, literals are quoted strings. ✓

#### `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl` (ZTSRP_COMPFL)
Columns used:

| HANA_COLUMN_SQL | BQ_COLUMN | BQ_DATATYPE |
|---|---|---|
| MANDT | mandt | STRING |
| PRCTR | prctr | STRING |
| STRNUM | strnum | STRING |
| COMP_VER | comp_ver | STRING |
| FS_COMP_WK | fs_comp_wk | STRING |
| RX_COMP_WK | rx_comp_wk | STRING |
| ZWEEK | zweek | STRING |

Filter: `comp_ver = @ip_version` — comp_ver is STRING, parameter is STRING. ✓

#### `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act` (ZTSRP_ATTR_ACT)
Columns used:

| HANA_COLUMN_SQL | BQ_COLUMN | BQ_DATATYPE |
|---|---|---|
| MANDT | mandt | STRING |
| STRNUM | strnum | STRING |
| PRCTR | prctr | STRING |
| EMERG_MKT_IND | emerg_mkt_ind | STRING |
| REP_MKT_CODE | rep_mkt_code | STRING |
| REP_MKT_DESC | rep_mkt_desc | STRING |
| DIVISION_CODE | division_code | STRING |
| DIVISION_DESC | division_desc | STRING |
| REGION_CODE | region_code | STRING |
| REGION_DESC | region_desc | STRING |
| DISTRICT_CODE | district_code | STRING |
| DISTRICT_DESC | district_desc | STRING |
| CITY | city | STRING |
| STATE | state | STRING |
| FS_OPEN_DAT | fs_open_dat | DATE |
| RX_OPEN_DAT | rx_open_dat | DATE |
| AREA_CODE | area_code | STRING |
| AREA_DESC | area_desc | STRING |
| RX_DIVISION_CODE | rx_division_code | STRING |
| RX_AREA_CODE | rx_area_code | STRING |
| RX_REGION_CODE | rx_region_code | STRING |
| RX_DISTRICT_CODE | rx_district_code | STRING |

Filter (COMP_NONCOMP_STORE_ATTR): `prctr IN ('0000562075', '0000562076')` — prctr is STRING. ✓

#### `edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node` (HRRP_NODE)
Columns used:

| HANA_COLUMN_SQL | BQ_COLUMN | BQ_DATATYPE |
|---|---|---|
| MANDT | mandt | STRING |
| PARNODE | parnode | STRING |
| HRYVALTO | hryvalto | DATE |
| NODEVALUE | nodevalue | STRING |

Filter: `hryvalto = DATE '9999-12-31'` — hryvalto is DATE; typed DATE literal used. ✓  
Filter: `REGEXP_CONTAINS(parnode, r'.*CORE_RET.*')` — parnode is STRING. ✓

#### `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct` (CEPCT)
Columns used:

| HANA_COLUMN_SQL | BQ_COLUMN | BQ_DATATYPE |
|---|---|---|
| MANDT | mandt | STRING |
| PRCTR | prctr | STRING |
| LTEXT | ltext → aliased as profit_center_text | STRING |

### Unmapped Physical Tables (REQUIRES VALIDATION)

The following tables are referenced in the VT_CAR section (CTEs 1–22) and are **absent from Columns_Mapping_v3.csv**. Placeholder table names and HANA-style column names are used throughout those CTEs.

| HANA Table | Placeholder BQ Name | Columns Affected |
|---|---|---|
| /POSDW/NAVIX | `PROJECT.DATASET.POSDW_NAVIX` | MANDT, RETAILSTOREID, BUSINESSDAYDATE, CURRENCY |
| /POSDW/TLOGF | `PROJECT.DATASET.POSDW_TLOGF` | MANDT, RETAILSTOREID, BUSINESSDAYDATE, SALESAMOUNT, REDUCTIONAMOUNT, RETAILTYPECODE, TRANSCURRENCY, ZZ_UPD_TIMESTAMP, RECORDQUALIFIER, TRANSTYPECODE, WORKSTATIONID, ARCHIVED, DISCTYPECODE, ITEMID |
| /POSDW/TLOGF_X | `PROJECT.DATASET.POSDW_TLOGF_X` | MANDT, RETAILSTOREID, BUSINESSDAYDATE, ZZ_RX_CNT_NS, ZZ_RX_CNT_REFILL, ZZ_RX_CNT_GE84_NS, ZZ_RX_CNT_GE84_RE, ZZ_RX_MCRX_GE84_NS, ZZ_RX_MCRX_GE84_RE, ZZ_CUSTTYPE, ZZ_UPD_TIMESTAMP, WORKSTATIONID, RECORDQUALIFIER |
| ZTFIRP_FLASH_PRM | `PROJECT.DATASET.ZTFIRP_FLASH_PRM` | PARAM_NAME, PARAM_VALUE_LOW |

---

## 13. Type Cast and Literal Conversion Log

| Location | Column / Expression | Original Type | BQ_DATATYPE | Cast Applied | Notes |
|---|---|---|---|---|---|
| CTE 24 RETAIL_CALENDAR WHERE | rclnt | CLNT (STRING) | STRING | None — string literals '120','200' already correct | ✓ |
| CTE 25 WEEK JOIN | cal_week_ending_date vs zrwenddate | STRING vs DATE | DATE | PARSE_DATE('%Y%m%d', cal_week_ending_date) = zrwenddate | Required because cal_week_ending_date is a computed YYYYMMDD string |
| CTE 27 HIERARCHY WHERE | hryvalto | DATS (DATE) | DATE | DATE '9999-12-31' typed literal | Converted from string '99991231' to DATE literal |
| CTE 26 COMP_FLAG WHERE | comp_ver | CHAR (STRING) | STRING | None — @ip_version is STRING | ✓ |
| CTE 36 UNION branch 2 | cal_scripts_90as3 | INT64 | INT64 | CAST(NULL AS INT64) | Ensures type consistency across UNION branches |
| CTE 36 UNION branch 2 | fs_salesamount, reductionamount, etc. | NUMERIC | NUMERIC | CAST(NULL AS NUMERIC) | Ensures type consistency across UNION branches |
| Final SELECT | snapshot_timestamp | TIMESTAMP | TIMESTAMP | CAST(NULL AS TIMESTAMP) | Audit column not produced by SELECT logic |
| Final SELECT | created_by | STRING | STRING | CAST(NULL AS STRING) | Audit column not produced by SELECT logic |

---

## 14. Alias Check Results

### Physical Column Aliases — Redundant Aliases Removed
All physical columns from mapped tables use their exact `BQ_COLUMN` names (lowercase, no leading underscore). No aliases that merely change case, add/remove leading underscores, or swap `/` for `_` were retained.

### Meaningful Renames Retained
| CTE | Expression | Alias | Reason |
|---|---|---|---|
| CTE 23 (FLASH) | RETAILSTOREID | retailstoreid_car | Meaningful rename to distinguish from the RETAILSTOREID output column; required by downstream join logic |
| CTE 37 (PROFIT_CENTER_TEXT) | ltext | profit_center_text | Meaningful rename; output contract of CV_COMP_FIN_FLASH requires PROFIT_CENTER_TEXT |
| CTEs 2,4 | SALESAMOUNT | fs_salesamount / rx_salesamount | Meaningful renames distinguishing FS vs RX sales amounts |
| CTEs 5 | REDUCTIONAMOUNT | emp_reductionamount | Meaningful rename for employee discount amount |
| CTE 6 | ZZ_UPD_TIMESTAMP | scripts_upd_timestamp | Meaningful rename for scripts update timestamp |
| CTEs 2,4 | ZZ_UPD_TIMESTAMP | fs_upd_timestamp / rx_upd_timestamp | Meaningful renames for FS/RX update timestamps |
| CTE 17 | SALESAMOUNT | cvd_amount | Meaningful rename for COVID sales amount |
| CTE 17 | ZZ_UPD_TIMESTAMP | cvd_upd_timestamp | Meaningful rename for COVID update timestamp |
| CTE 12 | ZZ_UPD_TIMESTAMP | emp_disc_upd_timestamp | Meaningful rename for employee discount update timestamp |
| CTE 16 | ZZ_UPD_TIMESTAMP | fs_disc_upd_timestamp | Meaningful rename for FS discount update timestamp |

---

## 15. Duplicate Column Check

Each SELECT was checked for duplicate aliases case-insensitively. No duplicate aliases were found within any individual SELECT.

---

## 16. Aggregation Grain Validation

- **CTE 21 (COMBINE_DATA):** Groups by MANDT, RETAILSTOREID, BUSINESSDAYDATE, transcurrency, zz_upd_timestamp. This is the VT_CAR composite grain. ✓
- **CTE 33 (EMPLOYEE_DISCOUNT):** Groups by all dimensional attributes of the employee discount rows. PRCTR is grouped (as prctr_org) and not in the GROUP BY output alias; it is used to derive cal_prctr. ✓
- **Final SELECT:** Groups by all 40 logical-model attributes of CV_COMP_FIN_FLASH_STATIC (including snapshot_timestamp and created_by as NULL constants). Measures are aggregated per the logical model. ✓

---

## 17. Procedure / ETL Handling

**STP_WSS_FLASH_SALES:**
- Type: HANA SQLScript stored procedure (DELETE + INSERT-SELECT)
- DML wrappers (DELETE, INSERT INTO) skipped as permitted.
- The SELECT body inside the INSERT is fully inlined.
- All four placeholder parameters are preserved as runtime parameters.
- SNAPSHOT_TIMESTAMP (CURRENT_TIMESTAMP) and CREATED_BY (SESSION_USER) are audit-only INSERT columns; excluded from SELECT logic and represented as NULL constants in the final SELECT.
- The procedure's date/timestamp variable computations (V_ADJ, V_WEEK_ENDING_FROM_DATE, etc.) are not declarative SELECT logic; they are replaced by runtime parameters as documented above.

---

## 18. Star Projection Validation

No star projections (`SELECT *`) were used. All columns are explicitly named. ✓

---

## 19. Quality Gate Results

| Gate | Result |
|---|---|
| 1. Final consumer unambiguous | ✓ PASS — CV_COMP_FIN_FLASH_STATIC |
| 2. Artifact dependencies match lineage | ✓ PASS — all 4 edges traced |
| 3. Final-consumer transformation order preserved | ✓ PASS |
| 4. Dependencies expanded at point of consumption | ✓ PASS |
| 5. No generic Source→Intermediate→Target ordering | ✓ PASS |
| 6. Every file classified USED/NOT USED | ✓ PASS — all 5 files classified |
| 7. Every USED file participates in dependency chain | ✓ PASS |
| 8. All converted dependencies expanded | ✓ PASS |
| 9. Only terminal sources remain | ✓ PASS (with REQUIRES VALIDATION for 4 unmapped tables) |
| 10. Every physical source uses BQ_FULL_TABLE | ⚠️ PARTIAL — 4 tables use placeholder names (MISSING TABLE MAPPING) |
| 11. Every referenced physical column mapped | ⚠️ PARTIAL — 4 tables have no column mappings in CSV |
| 12. All comparisons use correct types | ✓ PASS for mapped tables; REQUIRES VALIDATION for unmapped tables |
| 13. Final-consumer CTE names and order preserved | ✓ PASS |
| 14. Compatible steps combined | ✓ PASS |
| 15. No source node becomes a CTE merely to mirror structure | ✓ PASS |
| 16. Every helper CTE justified | ✓ PASS |
| 17. Every CTE matches output contract | ✓ PASS |
| 18. Column references qualified, no ambiguity | ✓ PASS |
| 19. No duplicate aliases within a SELECT | ✓ PASS |
| 20. No star projections | ✓ PASS |
| 21. Filters, joins, calculations, parameters preserved | ✓ PASS |
| 22. Aggregation stages preserve grain | ✓ PASS |
| 23. DISTINCT, UNION, window behavior preserved | ✓ PASS |
| 24. No conflict silently corrected | ✓ PASS — all issues documented |
| 25. Procedure staging table replaced by INSERT-SELECT body | ✓ PASS |
| 26. Runtime parameters documented, no DECLARE/SET | ✓ PASS |
| 27. Every CTE has standardized comment header | ✓ PASS |
| 28. CTE comments describe consolidated logic | ✓ PASS |
| 29. Complete query, minimum logical CTE structure | ✓ PASS |
| 30. Every lineage edge represented | ✓ PASS |
| 31. Every filter/join/aggregation/UNION/parameter traced | ✓ PASS |
| 32. Physical column outputs use exact BQ_COLUMN | ⚠️ PARTIAL — mapped tables: PASS; unmapped tables: REQUIRES VALIDATION |

---

## 20. ISSUES TO FIX

### Issue 1 — BLOCKING: REQUIRES VALIDATION: MISSING TABLE MAPPING
**Affected tables:** /POSDW/NAVIX, /POSDW/TLOGF, /POSDW/TLOGF_X, ZTFIRP_FLASH_PRM  
**Evidence:** No rows exist in Columns_Mapping_v3.csv for these tables after reading the full CSV.  
**Impact:** CTEs 1–22 use placeholder table names (`PROJECT.DATASET.POSDW_NAVIX`, etc.) and HANA-style column names. The query will not execute until these are replaced with actual BigQuery table paths.  
**Resolution needed:** Provide BQ_FULL_TABLE and BQ_COLUMN mappings for all four tables in Columns_Mapping_v3.

### Issue 2 — BLOCKING: REQUIRES VALIDATION: MISSING COLUMN MAPPING
**Affected columns:** All columns of /POSDW/NAVIX, /POSDW/TLOGF, /POSDW/TLOGF_X, ZTFIRP_FLASH_PRM  
**Evidence:** No rows exist in Columns_Mapping_v3.csv for these tables.  
**Impact:** Column names in CTEs 1–22 use HANA/placeholder names. The query will not execute correctly until actual BigQuery column names are substituted.  
**Resolution needed:** Same as Issue 1.

### Issue 3 — NON-BLOCKING: zz_upd_timestamp datatype
**Affected location:** CTE 23 (FLASH) WHERE clause; @ip_upd_timestamp_from / @ip_upd_timestamp_to parameters  
**Evidence:** The column zz_upd_timestamp originates from /POSDW/TLOGF (unmapped) and is typed STRING in the VT_CAR consolidated file. The procedure computes V_UPDATE_TIMESTAMP_FROM as CAST(... AS NUMERIC). The actual BigQuery type is unresolved.  
**Impact:** If zz_upd_timestamp is NUMERIC or TIMESTAMP in BigQuery, the filter comparison may fail or produce incorrect results.  
**Resolution needed:** Confirm BQ_DATATYPE of zz_upd_timestamp and cast parameters accordingly.

### Issue 4 — NON-BLOCKING: RECORDQUALIFIER = 25 type in TLOGF_X
**Affected location:** CTE 6 (SCRIPTS) WHERE clause  
**Evidence:** The VT_CAR converted file uses `RECORDQUALIFIER = 25` (numeric literal). The actual BigQuery type of RECORDQUALIFIER in /POSDW/TLOGF_X is unknown.  
**Impact:** If RECORDQUALIFIER is STRING, the filter must use `'25'`.  
**Resolution needed:** Confirm BQ_DATATYPE of RECORDQUALIFIER in /POSDW/TLOGF_X.

### Issue 5 — NON-BLOCKING: HANA MATCH vs REGEXP_CONTAINS
**Affected location:** CTE 27 (HIERARCHY) WHERE clause  
**Evidence:** HANA `match(PARNODE, '*CORE_RET*')` was converted to `REGEXP_CONTAINS(parnode, r'.*CORE_RET.*')`. HANA MATCH uses wildcard semantics; REGEXP_CONTAINS uses regex.  
**Impact:** Potential false positives/negatives if HANA wildcard semantics differ from regex contains.  
**Resolution needed:** Validate that `.*CORE_RET.*` correctly represents the intended HANA MATCH pattern.

### Issue 6 — NON-BLOCKING: GREATEST vs HANA scalar MAX
**Affected location:** CTE 32 (CALCULATIONS) cal_comp_flag  
**Evidence:** HANA `MAX(FS_COMP_WK, RX_COMP_WK)` (scalar two-argument MAX) was converted to `GREATEST(fs_comp_wk, rx_comp_wk)`. NULL handling may differ.  
**Impact:** If one argument is NULL, GREATEST returns NULL; HANA scalar MAX may return the non-NULL value.  
**Resolution needed:** Validate NULL handling behavior for fs_comp_wk and rx_comp_wk.

### Issue 7 — NON-BLOCKING: Unresolved scalar functions
**Affected parameters:** @ip_version, @ip_week_ending_from, @ip_week_ending_to  
**Evidence:** SFN_ACTUALS_COMP_FLAG, SFN_CURRENT_WEEK_START_DATE, SFN_CURRENT_WEEK_END_DATE are not in the supplied converted SQL files.  
**Impact:** These parameters must be supplied by the caller at runtime. The query is correct for any valid runtime value.  
**Resolution needed:** Document the expected runtime values in the execution environment.

---

*This consolidation is not production-ready due to Issues 1 and 2 (blocking). Issues 3–7 are non-blocking and require validation before production deployment.*
