# FIN_FORECAST Consolidation Description

---

## 1. Pre-Consolidation Input Confirmation

### Lineage Rows Read (FIN_FORECAST Relationships Table)
| Source File | Target File | Dependency Type |
|---|---|---|
| CV_BASE_FIN_WEEKLY_FORECAST_S4 | CV_COMP_FIN_FORECAST | Calculation View Dependency |
| CV_BASE_MD_SRPACT_S4 | CV_COMP_FIN_FORECAST | Calculation View Dependency |
| CV_BASE_MD_COMPFL_S4 | CV_COMP_FIN_FORECAST | Calculation View Dependency |
| CV_BASE_MD_RCALWEEK_S4 | CV_COMP_FIN_FORECAST | Calculation View Dependency |
| CV_BASE_MD_CEPCT_S4 | CV_COMP_FIN_FORECAST | Calculation View Dependency |

**Total lineage rows read: 5**

### Files in FIN_FORECAST Converted BIGQUERIES (All Inspected)
1. `CV_BASE_FIN_WEEKLY_FORECAST_S4_DI HANA to BigQuery SQL Conversion Agent.txt`
2. `CV_BASE_MD_SRPACT_S4_DI HANA to BigQuery SQL Conversion Agent.txt`
3. `CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL Conversion Agent.txt`
4. `CV_BASE_MD_RCALWEEK_S4_DI HANA to BigQuery SQL Conversion Agent.txt`
5. `CV_BASE_MD_CEPCT_S4_DI HANA to BigQuery SQL Conversion Agent.txt`
6. `CV_COMP_FIN_FORECAST_DI HANA to BigQuery SQL Conversion Agent.txt`

**Total files: 6**

### Columns_Mapping.csv Rows Read
Full CSV read. Relevant tables for this consolidation:
- `AZSRP_DS041_VT_S4` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds041` (21 mapped columns used)
- `ZTSRP_ATTR_ACT` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act` (75 mapped columns, subset used)
- `ZTSRP_COMPFL` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl` (13 mapped columns used)
- `ZTFIGL_RCALWEEK` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek` (9 mapped columns, 3 used)
- `CEPCT` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct` (8 mapped columns, 3 used)

Additional tables in CSV not part of this dependency chain (HRRP_NODE, AZSRP_DS052_VT_S4, AZSRP_DS112_VT_S4, AZSRP_DS072_VT_S4, AZSRP_DS092_VT_S4, AZSRP_DS031_VT_S4, ACDOCA_VT_S4, BKPF, FAGLSKF_PN) are ignored per instructions.

---

## 2. Final Consumer Identification

**Final Consumer:** `CV_COMP_FIN_FORECAST`

This is the only artifact that appears as a **Target** in the Relationships Table. All other five artifacts appear only as **Sources** feeding into it. The final consumer is a CUBE-type Calculation View with `outputViewType="Aggregation"`.

---

## 3. File Classification: USED / NOT USED

| File | Classification | Reason |
|---|---|---|
| CV_COMP_FIN_FORECAST_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Final consumer; defines the complete transformation flow, joins, calculations, and aggregation |
| CV_BASE_FIN_WEEKLY_FORECAST_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Primary fact source; provides weekly financial forecast data (WEEKLY_SNAPSHOT_DS05 node) |
| CV_BASE_MD_SRPACT_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Store attribute dimension (STORE_ATTR_ACTUAL node); joined on profit center |
| CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Comp flag dimension (COMP_FLAG_FORECAST node); joined on profit center + week |
| CV_BASE_MD_RCALWEEK_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Calendar week dimension (CAL_WEEK node); joined on fiscal week |
| CV_BASE_MD_CEPCT_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Profit center text dimension (PROFIT_CENTER_TEXT node); joined on profit center |

**All 6 files are USED.**

---

## 4. Artifact Dependency Mapping and Lineage Edge Tracing

| Producer | Consumer | Lineage Edge | Resulting SQL Location |
|---|---|---|---|
| CV_BASE_FIN_WEEKLY_FORECAST_S4 | CV_COMP_FIN_FORECAST | WEEKLY_SNAPSHOT_DS05 node | CTE 1: `WEEKLY_SNAPSHOT_DS05` |
| CV_BASE_MD_SRPACT_S4 | CV_COMP_FIN_FORECAST | STORE_ATTR_ACTUAL node | CTE 2: `STORE_ATTR_ACTUAL` |
| CV_BASE_MD_COMPFL_S4 | CV_COMP_FIN_FORECAST | COMP_FLAG_FORECAST node | CTE 4: `COMP_FLAG_FORECAST` |
| CV_BASE_MD_RCALWEEK_S4 | CV_COMP_FIN_FORECAST | CAL_WEEK node | CTE 6: `CAL_WEEK` |
| CV_BASE_MD_CEPCT_S4 | CV_COMP_FIN_FORECAST | PROFIT_CENTER_TEXT node | CTE 8: `PROFIT_CENTER_TEXT` |

Every lineage edge is represented in the consolidated SQL at its point of consumption. No dependency is bypassed.

---

## 5. Final Consumer Flow / Transformation Order

The CV_COMP_FIN_FORECAST XML defines the following node sequence, preserved exactly in the consolidated SQL:

1. **WEEKLY_SNAPSHOT_DS05** – Filter and project from CV_BASE_FIN_WEEKLY_FORECAST_S4 (CTE 1)
2. **STORE_ATTR_ACTUAL** – Project from CV_BASE_MD_SRPACT_S4 (CTE 2)
3. **Join_2** – LEFT JOIN WEEKLY_SNAPSHOT_DS05 + STORE_ATTR_ACTUAL on profit center (CTE 3: `Joined_Weekly_Store`)
4. **WEEK_NUMBER** – Add CAL_STORE_WEEK_NUMBER calculation (combined into CTE 3)
5. **COMP_FLAG_FORECAST** – Filter and project from CV_BASE_MD_COMPFL_S4 (CTE 4)
6. **Join_3** – LEFT JOIN WEEK_NUMBER + COMP_FLAG_FORECAST on profit center + week (CTE 5: `Joined_Weekly_CompFlag`)
7. **CAL_WEEK** – Project from CV_BASE_MD_RCALWEEK_S4 (CTE 6)
8. **Join_4** – LEFT JOIN Join_3 + CAL_WEEK on fiscal week (CTE 7: `Joined_Weekly_CalWeek`)
9. **PROFIT_CENTER_TEXT** – Project from CV_BASE_MD_CEPCT_S4 (CTE 8)
10. **Join_1** – LEFT JOIN Join_4 + PROFIT_CENTER_TEXT on profit center (CTE 9: `FLAGS` — join embedded)
11. **FLAGS** – Final projection with calculated columns (CTE 9: `FLAGS`)
12. **Final Aggregation** – GROUP BY all dimensions, SUM measures (Final SELECT)

---

## 6. Dependency Expansion and Point-of-Consumption Mapping

Each upstream dependency is expanded **at its point of consumption** in the final consumer's flow, not pre-materialized at the top:

- **CV_BASE_FIN_WEEKLY_FORECAST_S4** → Expanded as CTE 1 (`WEEKLY_SNAPSHOT_DS05`). Its internal logic (projection from `v_bic_azsrp_ds041`, column renames `bic_zio_pctr → b631_s_proftctr`, `bic_zio_cctr → b631_s_costcntr`, `b631_s_amount → b631_s_amount_negative`, MANDT filter) is fully inlined. The outer aggregation of CV_BASE_FIN_WEEKLY_FORECAST_S4 is not separately materialized because CV_COMP_FIN_FORECAST performs its own final aggregation; the projection/filter logic is what is consumed.

- **CV_BASE_MD_SRPACT_S4** → Expanded as CTE 2 (`STORE_ATTR_ACTUAL`). Its CUBE aggregation (SUM of 4 measures, GROUP BY all non-measure columns) and MANDT filter are fully inlined.

- **CV_BASE_MD_COMPFL_S4** → Expanded as CTE 4 (`COMP_FLAG_FORECAST`). Its projection and MANDT filter are fully inlined. The `comp_ver = @ip_version` filter from CV_COMP_FIN_FORECAST is applied here.

- **CV_BASE_MD_RCALWEEK_S4** → Expanded as CTE 6 (`CAL_WEEK`). Its projection and `rclnt IN ('120','200')` filter are fully inlined.

- **CV_BASE_MD_CEPCT_S4** → Expanded as CTE 8 (`PROFIT_CENTER_TEXT`). Its projection (`ltext AS profit_center_text`) and MANDT filter are fully inlined.

---

## 7. CTE Structure and Justification

| CTE | Name | Justification |
|---|---|---|
| 1 | WEEKLY_SNAPSHOT_DS05 | Required: expansion of CV_BASE_FIN_WEEKLY_FORECAST_S4 with its filters and column renames; consumed as the left input of Join_2 |
| 2 | STORE_ATTR_ACTUAL | Required: expansion of CV_BASE_MD_SRPACT_S4 with CUBE aggregation; consumed as the right input of Join_2 |
| 3 | Joined_Weekly_Store | Required: Join_2 + WEEK_NUMBER combined (compatible operations); left input of Join_3 |
| 4 | COMP_FLAG_FORECAST | Required: expansion of CV_BASE_MD_COMPFL_S4 with filters; consumed as right input of Join_3 |
| 5 | Joined_Weekly_CompFlag | Required: Join_3 result; left input of Join_4 |
| 6 | CAL_WEEK | Required: expansion of CV_BASE_MD_RCALWEEK_S4; consumed as right input of Join_4 |
| 7 | Joined_Weekly_CalWeek | Required: Join_4 result; left input of Join_1 |
| 8 | PROFIT_CENTER_TEXT | Required: expansion of CV_BASE_MD_CEPCT_S4; consumed as right input of Join_1 |
| 9 | FLAGS | Required: Join_1 + calculated columns (FLAGS node); input to final aggregation |

**No helper CTEs were created merely to mirror HANA node structure.** WEEK_NUMBER node (a simple RIGHT() calculation) was combined into CTE 3 (`Joined_Weekly_Store`) as it is semantically compatible. Join_1 (profit center text join) was combined into CTE 9 (`FLAGS`) as the join and projection are compatible operations.

---

## 8. Table and Column Mapping Applied

### AZSRP_DS041_VT_S4 → edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds041

| HANA Column | BQ Column | BQ Datatype | Notes |
|---|---|---|---|
| FISCPER | fiscper | STRING | |
| FISCVARNT | fiscvarnt | STRING | |
| FISCYEAR | fiscyear | STRING | |
| FISCPER3 | fiscper3 | STRING | |
| MANDT | mandt | STRING | Filter changed from IN (120,200) to IN ('120','200') — STRING type |
| _BIC_ZIO_SWEEK | bic_zio_sweek | STRING | BETWEEN filter uses STRING parameters @ip_week_ending_from, @ip_week_ending_to |
| _B631_S_CHRTACCT | b631_s_chrtacct | STRING | |
| _B631_S_CO_AREA | b631_s_co_area | STRING | |
| _BIC_ZIO_CMPCD | bic_zio_cmpcd | STRING | |
| _BIC_ZIO_PCTR | bic_zio_pctr → b631_s_proftctr | STRING | Meaningful rename per CV_BASE_FIN_WEEKLY_FORECAST_S4 |
| _BIC_ZIO_CCTR | bic_zio_cctr → b631_s_costcntr | STRING | Meaningful rename per CV_BASE_FIN_WEEKLY_FORECAST_S4 |
| _B631_S_FUNCAREA | b631_s_funcarea | STRING | |
| _BIC_ZIO_VER | bic_zio_ver | STRING | Filter: = @ip_version (STRING) |
| _BIC_ZIO_SAUDT | bic_zio_saudt | STRING | Filter: IN ('1','10') — STRING type confirmed |
| _B631_S_GL_ACCT | b631_s_gl_acct | STRING | |
| _BIC_ZWWPC_PA1 | bic_zwwpc_pa1 | STRING | Used in LEFT() calculation for cal_fs_rx_flag |
| _BIC_ZWWSC_PA1 | bic_zwwsc_pa1 | STRING | |
| _B631_S_AMOUNT | b631_s_amount → b631_s_amount_negative | NUMERIC | Meaningful rename per CV_BASE_FIN_WEEKLY_FORECAST_S4 |
| CURRENCY | currency | STRING | |
| _BIC_ZIO_AMT | bic_zio_amt | NUMERIC | |

**Note on RECORDMODE:** CV_BASE_FIN_WEEKLY_FORECAST_S4 projects RECORDMODE, but CV_COMP_FIN_FORECAST does not reference it in its output contract or downstream logic. It is not included in the consolidated output.

### ZTSRP_ATTR_ACT → edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act

All 75 columns mapped. Columns referenced by CV_COMP_FIN_FORECAST's STORE_ATTR_ACTUAL node:
- mandt (STRING), strnum (STRING), prctr (STRING), rep_mkt_code (STRING), rep_mkt_desc (STRING), emerg_mkt_ind (STRING), division_code (STRING), division_desc (STRING), region_code (STRING), region_desc (STRING), district_code (STRING), district_desc (STRING), area_code (STRING), area_desc (STRING), city (STRING), state (STRING), fs_open_dat (DATE), rx_open_dat (DATE), rx_division_code (STRING), rx_area_code (STRING), rx_region_code (STRING), rx_district_code (STRING)
- Measures: rx_hrs_oper (NUMERIC), fs_hrs_oper (NUMERIC), retail_sqft_amt (NUMERIC), total_sqft_amt (NUMERIC)
- mandt filter: IN ('120','200') — STRING type

### ZTSRP_COMPFL → edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl

| HANA Column | BQ Column | BQ Datatype | Notes |
|---|---|---|---|
| MANDT | mandt | STRING | Filter IN ('110','200') — STRING type |
| PRCTR | prctr | STRING | Join key |
| STRNUM | strnum | STRING | |
| COMP_VER | comp_ver | STRING | Filter: = @ip_version (STRING) |
| ZWEEK | zweek | STRING | Join key; compared with bic_zio_sweek (STRING = STRING, compatible) |
| ZMONTH | zmonth | STRING | |
| ZYEAR | zyear | STRING | |
| FS_COMP_WK | fs_comp_wk | STRING | |
| RX_COMP_WK | rx_comp_wk | STRING | |

**Note:** CV_BASE_MD_COMPFL_S4 filters `MANDT IN (110, 200)`. Per Columns_Mapping, mandt is STRING. Filter corrected to `IN ('110', '200')`.

### ZTFIGL_RCALWEEK → edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek

| HANA Column | BQ Column | BQ Datatype | Notes |
|---|---|---|---|
| RCLNT | rclnt | STRING | Filter IN ('120','200') — STRING type |
| ZZWEEK | zzweek | STRING | Join key; compared with bic_zio_sweek (STRING = STRING, compatible) |
| ZRWSTRTDATE | zrwstrtdate | DATE | |
| ZRWENDDATE | zrwenddate | DATE | |

### CEPCT → edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct

| HANA Column | BQ Column | BQ Datatype | Notes |
|---|---|---|---|
| MANDT | mandt | STRING | Filter IN ('120','200') — STRING type |
| PRCTR | prctr | STRING | Join key |
| LTEXT | ltext → profit_center_text | STRING | Meaningful rename per CV_BASE_MD_CEPCT_S4 |

---

## 9. Data Type Corrections Applied

| Location | Column/Filter | Original (Converted SQL) | Corrected (BQ Datatype) | Reason |
|---|---|---|---|---|
| CTE 1 WEEKLY_SNAPSHOT_DS05 | mandt IN (...) | IN (120, 200) | IN ('120', '200') | mandt is STRING per Columns_Mapping |
| CTE 2 STORE_ATTR_ACTUAL | mandt IN (...) | IN (120, 200) | IN ('120', '200') | mandt is STRING per Columns_Mapping |
| CTE 4 COMP_FLAG_FORECAST | mandt IN (...) | IN (110, 200) | IN ('110', '200') | mandt is STRING per Columns_Mapping |
| CTE 6 CAL_WEEK | rclnt IN (...) | IN (120, 200) | IN ('120', '200') | rclnt is STRING per Columns_Mapping |
| CTE 8 PROFIT_CENTER_TEXT | mandt IN (...) | IN (120, 200) | IN ('120', '200') | mandt is STRING per Columns_Mapping |
| CTE 1 WEEKLY_SNAPSHOT_DS05 | bic_zio_sweek BETWEEN ... | BETWEEN @IP_WEEK_ENDING_FROM AND @IP_WEEK_ENDING_TO | BETWEEN @ip_week_ending_from AND @ip_week_ending_to | bic_zio_sweek is STRING; parameters are STRING; comparison is type-compatible |
| CTE 3 Joined_Weekly_Store | RIGHT(bic_zio_sweek, 2) | RIGHT(CAST(_BIC_ZIO_SWEEK AS STRING), 2) | RIGHT(bic_zio_sweek, 2) | bic_zio_sweek is already STRING; no CAST needed |
| CTE 9 FLAGS | LEFT(bic_zwwpc_pa1, 2) | LEFT(CAST(_BIC_ZWWPC_PA1 AS STRING), 2) | LEFT(bic_zwwpc_pa1, 2) | bic_zwwpc_pa1 is already STRING; no CAST needed |
| CTE 9 FLAGS | RIGHT(bic_zio_sweek, 2) | RIGHT(CAST(_BIC_ZIO_SWEEK AS STRING), 2) | RIGHT(bic_zio_sweek, 2) | bic_zio_sweek is already STRING; no CAST needed |
| CTE 5 Joined_Weekly_CompFlag | bic_zio_sweek = zweek | STRING = STRING | STRING = STRING | Both are STRING; compatible; no cast needed |
| CTE 7 Joined_Weekly_CalWeek | bic_zio_sweek = zzweek | STRING = STRING | STRING = STRING | Both are STRING; compatible; no cast needed |

---

## 10. Alias Check Results

### Removed Redundant Aliases (HANA-name or equivalent aliases)
The following aliases from the converted SQL were removed because the names before and after AS are equivalent under the name-equivalence rule (case, leading underscore, or `/` differences):

| CTE | Original Alias Expression | Action |
|---|---|---|
| STORE_ATTR_ACTUAL | `rep_mkt_code AS REP_MKT_CODE` | Removed — same name under rule |
| STORE_ATTR_ACTUAL | `SUM(rx_hrs_oper) AS RX_HRS_OPER` | Corrected to `SUM(rx_hrs_oper) AS rx_hrs_oper` |
| All CTEs | Any `column AS COLUMN` uppercase aliases | Removed/corrected to BQ style (lowercase) |

### Retained Meaningful Renames
| CTE | Expression | Rename Reason |
|---|---|---|
| CTE 1 | `bic_zio_pctr AS b631_s_proftctr` | Real rename: different base name; defined by CV_BASE_FIN_WEEKLY_FORECAST_S4 |
| CTE 1 | `bic_zio_cctr AS b631_s_costcntr` | Real rename: different base name; defined by CV_BASE_FIN_WEEKLY_FORECAST_S4 |
| CTE 1 | `b631_s_amount AS b631_s_amount_negative` | Real rename: different semantic meaning; defined by CV_BASE_FIN_WEEKLY_FORECAST_S4 |
| CTE 8 | `ltext AS profit_center_text` | Real rename: different name; defined by CV_BASE_MD_CEPCT_S4 |
| Final SELECT | `cal_fs_rx_flag AS fs_rx_flag` | Real rename: output alias defined by CV_COMP_FIN_FORECAST logical model |
| Final SELECT | `cal_comp_flag AS comp_flag` | Real rename: output alias defined by CV_COMP_FIN_FORECAST logical model |

---

## 11. Filter Tracing (Every Filter from Every USED File)

| Filter | Source File | CTE | Clause |
|---|---|---|---|
| mandt IN ('120','200') | CV_BASE_FIN_WEEKLY_FORECAST_S4 | CTE 1 WEEKLY_SNAPSHOT_DS05 | WHERE |
| fiscvarnt = 'K4' | CV_COMP_FIN_FORECAST (WEEKLY_SNAPSHOT_DS05 node) | CTE 1 WEEKLY_SNAPSHOT_DS05 | WHERE |
| bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to | CV_COMP_FIN_FORECAST (WEEKLY_SNAPSHOT_DS05 node) | CTE 1 WEEKLY_SNAPSHOT_DS05 | WHERE |
| bic_zio_ver = @ip_version | CV_COMP_FIN_FORECAST (WEEKLY_SNAPSHOT_DS05 node) | CTE 1 WEEKLY_SNAPSHOT_DS05 | WHERE |
| bic_zio_saudt IN ('1','10') | CV_COMP_FIN_FORECAST (WEEKLY_SNAPSHOT_DS05 node) | CTE 1 WEEKLY_SNAPSHOT_DS05 | WHERE |
| mandt IN ('120','200') | CV_BASE_MD_SRPACT_S4 | CTE 2 STORE_ATTR_ACTUAL | WHERE |
| mandt IN ('110','200') | CV_BASE_MD_COMPFL_S4 | CTE 4 COMP_FLAG_FORECAST | WHERE |
| comp_ver = @ip_version | CV_COMP_FIN_FORECAST (COMP_FLAG_FORECAST node) | CTE 4 COMP_FLAG_FORECAST | WHERE |
| rclnt IN ('120','200') | CV_BASE_MD_RCALWEEK_S4 | CTE 6 CAL_WEEK | WHERE |
| mandt IN ('120','200') | CV_BASE_MD_CEPCT_S4 | CTE 8 PROFIT_CENTER_TEXT | WHERE |

All 10 filters are preserved and traced to their originating source files.

---

## 12. Join Tracing

| Join | Type | Left Input | Right Input | Condition | CTE |
|---|---|---|---|---|---|
| Join_2 | LEFT JOIN | WEEKLY_SNAPSHOT_DS05 (f) | STORE_ATTR_ACTUAL (s) | f.b631_s_proftctr = s.prctr | CTE 3 Joined_Weekly_Store |
| Join_3 | LEFT JOIN | Joined_Weekly_Store (w) | COMP_FLAG_FORECAST (c) | w.b631_s_proftctr = c.prctr AND w.bic_zio_sweek = c.zweek | CTE 5 Joined_Weekly_CompFlag |
| Join_4 | LEFT JOIN | Joined_Weekly_CompFlag (j) | CAL_WEEK (cal) | j.bic_zio_sweek = cal.zzweek | CTE 7 Joined_Weekly_CalWeek |
| Join_1 | LEFT JOIN | Joined_Weekly_CalWeek (j) | PROFIT_CENTER_TEXT (p) | j.b631_s_proftctr = p.prctr | CTE 9 FLAGS |

All 4 joins are preserved with correct types and conditions.

---

## 13. Calculation Tracing

| Calculation | Source File | CTE | Expression |
|---|---|---|---|
| CAL_STORE_WEEK_NUMBER | CV_COMP_FIN_FORECAST (WEEK_NUMBER node) | CTE 3 Joined_Weekly_Store | `RIGHT(f.bic_zio_sweek, 2) AS cal_store_week_number` |
| CAL_FS_RX_FLAG | CV_COMP_FIN_FORECAST (FLAGS node) | CTE 9 FLAGS | `CASE WHEN LEFT(bic_zwwpc_pa1,2)='FS' THEN 'FS' WHEN LEFT(bic_zwwpc_pa1,2)='RX' THEN 'RX' ELSE '' END AS cal_fs_rx_flag` |
| CAL_COMP_FLAG | CV_COMP_FIN_FORECAST (FLAGS node) | CTE 9 FLAGS | `CASE WHEN LEFT(bic_zwwpc_pa1,2)='FS' THEN fs_comp_wk WHEN LEFT(bic_zwwpc_pa1,2)='RX' THEN rx_comp_wk ELSE fs_comp_wk END AS cal_comp_flag` |
| CAL_WEEK_NUMBER | CV_COMP_FIN_FORECAST (FLAGS node) | CTE 9 FLAGS | `RIGHT(bic_zio_sweek, 2) AS cal_week_number` |
| _B631_S_AMOUNT (negation) | CV_COMP_FIN_FORECAST (FLAGS node) | CTE 9 FLAGS | `(b631_s_amount_negative * -1) AS b631_s_amount` |

**Note on CAL_COMP_FLAG simplification:** The original converted SQL computed CAL_FS_RX_FLAG twice (inline) inside the CAL_COMP_FLAG CASE. In the consolidated SQL, the FLAGS CTE computes CAL_FS_RX_FLAG as a column, but since BigQuery does not allow referencing a SELECT-list alias in the same SELECT's CASE, the LEFT() expression is repeated directly in the CAL_COMP_FLAG CASE. This is semantically identical to the original logic and preserves the exact result.

---

## 14. Aggregation Tracing

| Measure | Aggregation | Source | Final SELECT |
|---|---|---|---|
| b631_s_amount_negative | SUM | CV_COMP_FIN_FORECAST logicalModel baseMeasures | `SUM(b631_s_amount_negative) AS b631_s_amount_negative` |
| bic_zio_amt | SUM | CV_COMP_FIN_FORECAST logicalModel baseMeasures | `SUM(bic_zio_amt) AS bic_zio_amt` |
| b631_s_amount | SUM | CV_COMP_FIN_FORECAST logicalModel (calculated after aggregation) | `SUM(b631_s_amount) AS b631_s_amount` |

GROUP BY grain: all non-measure columns in the final SELECT, including calculated columns (cal_fs_rx_flag, cal_comp_flag, cal_week_number). This matches the CUBE/Aggregation semantics of CV_COMP_FIN_FORECAST.

**Note on b631_s_amount aggregation:** The source logic defines b631_s_amount as a calculated measure (b631_s_amount_negative * -1) that is then aggregated with SUM. In the consolidated SQL, b631_s_amount is computed per row in FLAGS CTE and then SUM-aggregated in the final SELECT. This is semantically equivalent to SUM(b631_s_amount_negative * -1) = SUM(b631_s_amount_negative) * -1, preserving the exact result.

---

## 15. Runtime Parameters

| Parameter | Type | Source | Usage | Reason Unresolved |
|---|---|---|---|---|
| @ip_version | STRING | CV_COMP_FIN_FORECAST input parameter (NVARCHAR, optional) | CTE 1 WHERE bic_zio_ver = @ip_version; CTE 4 WHERE comp_ver = @ip_version | Runtime value supplied by caller |
| @ip_week_ending_from | STRING | CV_COMP_FIN_FORECAST input parameter (NVARCHAR, required) | CTE 1 WHERE bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to | Runtime value supplied by caller |
| @ip_week_ending_to | STRING | CV_COMP_FIN_FORECAST input parameter (NVARCHAR, required) | CTE 1 WHERE bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to | Runtime value supplied by caller |

Parameters are typed as STRING to match the BQ_DATATYPE of the columns they are compared with (bic_zio_sweek STRING, bic_zio_ver STRING, comp_ver STRING). No DECLARE or SET statements are used.

---

## 16. Duplicate Column Check

Each CTE's SELECT was checked for duplicate aliases. No duplicates were found. The following potential conflicts were resolved:

- `mandt` appears in both WEEKLY_SNAPSHOT_DS05 (f) and STORE_ATTR_ACTUAL (s). In CTE 3 (`Joined_Weekly_Store`), `f.mandt` is used (fact table is authoritative for client).
- `strnum` appears in both STORE_ATTR_ACTUAL and COMP_FLAG_FORECAST. In CTE 5 (`Joined_Weekly_CompFlag`), `w.strnum` is used (already carried from the left side).
- `profit_center_text` is a new column added from PROFIT_CENTER_TEXT join; no conflict.

---

## 17. Star Projection Handling

No star projections (`SELECT *`) are used in the final consolidated SQL. All columns are explicitly listed to prevent ambiguity and duplicate column issues arising from multiple joined inputs.

---

## 18. Procedure/ETL Handling

No stored procedures, INSERT-SELECT, CREATE TABLE AS SELECT, or MERGE statements are present in any of the 6 supplied files. All artifacts are Calculation View XMLs converted to SELECT statements. No procedural handling was required.

---

## 19. Parent Availability Validation

Every column referenced in each CTE was verified to exist in its parent CTE's output:

- CTE 3 references columns from CTE 1 (f.*) and CTE 2 (s.*) — all verified present.
- CTE 5 references columns from CTE 3 (w.*) and CTE 4 (c.fs_comp_wk, c.rx_comp_wk) — all verified present.
- CTE 7 references columns from CTE 5 (j.*) and CTE 6 (cal.zrwstrtdate, cal.zrwenddate) — all verified present.
- CTE 9 references columns from CTE 7 (j.*) and CTE 8 (p.profit_center_text) — all verified present.
- Final SELECT references columns from CTE 9 (FLAGS) — all verified present.

---

## 20. Final Quality Gate Results

| Check | Result |
|---|---|
| 1. Final consumer unambiguous | ✅ PASSED — CV_COMP_FIN_FORECAST |
| 2. Artifact dependencies match Relationships Table | ✅ PASSED — All 5 edges verified |
| 3. Final-consumer transformation order preserved | ✅ PASSED — Node sequence preserved exactly |
| 4. Dependencies expanded at point of consumption | ✅ PASSED |
| 5. No generic Source→Intermediate→Target ordering | ✅ PASSED |
| 6. Every file classified USED/NOT USED | ✅ PASSED — All 6 USED |
| 7. Every USED file participates in dependency chain | ✅ PASSED |
| 8. All converted dependencies expanded | ✅ PASSED |
| 9. Only terminal sources remain | ✅ PASSED |
| 10. Every physical source uses BQ_FULL_TABLE; no PROJECT.DATASET placeholder | ✅ PASSED |
| 11. Every physical column mapped via Columns_Mapping | ✅ PASSED — Full CSV read; all referenced columns mapped |
| 12. Type compatibility in all comparisons | ✅ PASSED — All mandt/rclnt filters corrected to STRING; BETWEEN uses STRING parameters; join conditions STRING=STRING |
| 13. Final-consumer CTE names and order preserved | ✅ PASSED — WEEKLY_SNAPSHOT_DS05, STORE_ATTR_ACTUAL, COMP_FLAG_FORECAST, CAL_WEEK, PROFIT_CENTER_TEXT, FLAGS all preserved |
| 14. Compatible operations combined | ✅ PASSED — WEEK_NUMBER combined into Joined_Weekly_Store; Join_1 combined into FLAGS |
| 15. No HANA node becomes separate CTE merely to mirror source | ✅ PASSED |
| 16. Every helper CTE justified by semantic boundary | ✅ PASSED |
| 17. Every CTE matches required output contract | ✅ PASSED |
| 18. Every column reference qualified; no ambiguity | ✅ PASSED |
| 19. No duplicate alias within any SELECT | ✅ PASSED |
| 20. No star projections used | ✅ PASSED |
| 21. Filters, joins, calculations, mappings, parameters preserved | ✅ PASSED |
| 22. Aggregation grain preserved | ✅ PASSED |
| 23. No DISTINCT/UNION/window functions present; N/A | ✅ N/A |
| 24. No conflict silently corrected | ✅ PASSED — All corrections documented |
| 25. No procedural behavior discarded | ✅ N/A — No procedures |
| 26. Runtime parameters documented; no DECLARE/SET | ✅ PASSED |
| 27. Every CTE has standardized comment header | ✅ PASSED |
| 28. CTE comments describe consolidated logic | ✅ PASSED |
| 29. 100% logic match with minimum CTE structure | ✅ PASSED |
| 30. Every lineage edge represented at point of consumption | ✅ PASSED |
| 31. Every filter/join/aggregation/parameter traced to output | ✅ PASSED |
| 32. Every physical column uses exact BQ_COLUMN; no HANA aliases | ✅ PASSED |

---

## 21. Issues to Fix

**None.** All quality gate checks passed. The consolidated SQL is complete and traceable. The following non-blocking findings are documented:

1. **Non-blocking — Data type corrections:** All MANDT/RCLNT integer filter literals corrected to STRING quoted values per Columns_Mapping BQ_DATATYPE. This is a correction, not an invention.

2. **Non-blocking — CAST removal:** The converted CV_COMP_FIN_FORECAST SQL used `CAST(_BIC_ZIO_SWEEK AS STRING)` and `CAST(_BIC_ZWWPC_PA1 AS STRING)` in string functions. Since both columns are already STRING per Columns_Mapping, these CASTs are unnecessary and were removed. The logic is unchanged.

3. **Non-blocking — RECORDMODE column:** CV_BASE_FIN_WEEKLY_FORECAST_S4 projects RECORDMODE. CV_COMP_FIN_FORECAST does not include RECORDMODE in its output contract or downstream logic. It is excluded from the consolidated output. This does not affect any downstream reference.

4. **Non-blocking — Runtime parameters:** @ip_version, @ip_week_ending_from, @ip_week_ending_to are runtime parameters. Their values must be supplied at query execution time. No default values are set.
