# SKF_FORECAST Consolidation Description

## 1. Pre-Consolidation Input Confirmation

### Lineage Rows Read
All 5 rows from `SKF_FORECAST Relationships Table` were read:

| Source File | Target File | Dependency Type |
|---|---|---|
| CV_BASE_SKF_WEEKLY_FORECAST_S4 | CV_COMP_SKF_FORECAST | Calculation View Dependency |
| CV_BASE_MD_SRPACT_S4 | CV_COMP_SKF_FORECAST | Calculation View Dependency |
| CV_BASE_MD_COMPFL_S4 | CV_COMP_SKF_FORECAST | Calculation View Dependency |
| CV_BASE_MD_RCALWEEK_S4 | CV_COMP_SKF_FORECAST | Calculation View Dependency |
| CV_BASE_MD_CEPCT_S4 | CV_COMP_SKF_FORECAST | Calculation View Dependency |

### Converted BigQuery Files Inspected (6 files)
1. `CV_COMP_SKF_FORECAST_DI HANA to BigQuery SQL Conversion Agent.txt` — **USED** (final consumer)
2. `CV_BASE_SKF_WEEKLY_FORECAST_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — **USED** (upstream dependency)
3. `CV_BASE_MD_SRPACT_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — **USED** (upstream dependency)
4. `CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — **USED** (upstream dependency)
5. `CV_BASE_MD_RCALWEEK_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — **USED** (upstream dependency)
6. `CV_BASE_MD_CEPCT_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — **USED** (upstream dependency)

All 6 files are classified **USED**. No files are classified NOT USED.

### Columns_Mapping CSV Rows Read
All rows from `Columns_Mapping.csv` were read in full before any mapping decision was made. The CSV contains mappings for the following physical tables relevant to this consolidation:
- `AZSRP_DS031_VT_S4` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds031`
- `ZTSRP_ATTR_ACT` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act`
- `ZTSRP_COMPFL` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl`
- `ZTFIGL_RCALWEEK` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek`
- `CEPCT` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct`

---

## 2. Final Consumer Identification

**Final Consumer:** `CV_COMP_SKF_FORECAST`

This is the only artifact that appears exclusively as a **Target** in the lineage table. All other artifacts appear as Sources feeding into it. It is a CUBE Calculation View with `outputViewType="Aggregation"`.

---

## 3. Artifact Dependency Mapping

| Lineage Edge | Producer | Consumer | Resulting SQL Location |
|---|---|---|---|
| Edge 1 | CV_BASE_SKF_WEEKLY_FORECAST_S4 | CV_COMP_SKF_FORECAST | CTE `WEEKLY_SNAPSHOT_DS05` — expanded inline from physical table `v_bic_azsrp_ds031` |
| Edge 2 | CV_BASE_MD_SRPACT_S4 | CV_COMP_SKF_FORECAST | CTE `STORE_ATTR_ACTUAL` — expanded inline from physical table `v_ztsrp_attr_act` |
| Edge 3 | CV_BASE_MD_COMPFL_S4 | CV_COMP_SKF_FORECAST | CTE `COMP_FLAG_FCST` — expanded inline from physical table `v_ztsrp_compfl` |
| Edge 4 | CV_BASE_MD_RCALWEEK_S4 | CV_COMP_SKF_FORECAST | CTE `CAL_WEEK` — expanded inline from physical table `v_ztfigl_rcalweek` |
| Edge 5 | CV_BASE_MD_CEPCT_S4 | CV_COMP_SKF_FORECAST | CTE `PROFIT_CENTER_TEXT` — expanded inline from physical table `v_cepct` |

---

## 4. Final-Consumer Flow / Transformation Order

The flow in `CV_COMP_SKF_FORECAST` follows this node sequence:

1. **WEEKLY_SNAPSHOT_DS05** — Projection + filter of `CV_BASE_SKF_WEEKLY_FORECAST_S4`
2. **STORE_ATTR_ACTUAL** — Projection + filter of `CV_BASE_MD_SRPACT_S4`
3. **Join_2** — LEFT OUTER JOIN of WEEKLY_SNAPSHOT_DS05 ⋈ STORE_ATTR_ACTUAL on `_B631_S_PROFTCTR = PRCTR`
4. **COMP_FLAG_FCST** — Projection + filter of `CV_BASE_MD_COMPFL_S4` with `COMP_VER = @IP_VERSION`
5. **Join_3** — LEFT OUTER JOIN of Join_2 ⋈ COMP_FLAG_FCST on `_B631_S_PROFTCTR = PRCTR AND _BIC_ZIO_SWEEK = ZWEEK`
6. **CAL_WEEK** — Projection + filter of `CV_BASE_MD_RCALWEEK_S4`
7. **Join_4** — LEFT OUTER JOIN of Join_3 ⋈ CAL_WEEK on `_BIC_ZIO_SWEEK = ZZWEEK`
8. **PROFIT_CENTER_TEXT** — Projection + filter of `CV_BASE_MD_CEPCT_S4`
9. **Join_1** — LEFT OUTER JOIN of Join_4 ⋈ PROFIT_CENTER_TEXT on `_B631_S_PROFTCTR = PRCTR`
10. **FLAGS** — Final projection + calculated columns (`CAL_WEEK_NUMBER`, `CAL_BIC_ZIO_SKFQ`)
11. **Final SELECT** — Aggregation (SUM) with GROUP BY on all non-measure columns

---

## 5. Dependency Expansion and Point-of-Consumption Mapping

### CV_BASE_SKF_WEEKLY_FORECAST_S4 → CTE `WEEKLY_SNAPSHOT_DS05`
- **Physical source:** `edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds031`
- **Logic expanded:** Single projection with `mandt IN ('120','200')` filter. Column renames: `bic_zio_pctr → b631_s_proftctr`, `bic_zio_cctr → b631_s_costcntr`.
- **Additional filters from consumer:** `fiscvarnt = 'K4'`, `bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to`, `bic_zio_ver = @ip_version`, `bic_zio_saudt IN ('1','10')`, `bic_zio_pskf IN ('804013','801000')`.
- **Point of consumption:** Directly used in `Joined_WeeklySnapshot_StoreAttr` (Join_2 left side).

### CV_BASE_MD_SRPACT_S4 → CTE `STORE_ATTR_ACTUAL`
- **Physical source:** `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act`
- **Logic expanded:** Projection with `mandt IN ('120','200')` filter. Aggregation (SUM) on measures `rx_hrs_oper`, `fs_hrs_oper`, `retail_sqft_amt`, `total_sqft_amt` with GROUP BY on all non-measure columns.
- **Point of consumption:** Directly used in `Joined_WeeklySnapshot_StoreAttr` (Join_2 right side).

### CV_BASE_MD_COMPFL_S4 → CTE `COMP_FLAG_FCST`
- **Physical source:** `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl`
- **Logic expanded:** Projection with `mandt IN ('110','200')` filter. Additional consumer-level filter: `comp_ver = @ip_version`.
- **Point of consumption:** Directly used in `Joined_With_CompFlag` (Join_3 right side).

### CV_BASE_MD_RCALWEEK_S4 → CTE `CAL_WEEK`
- **Physical source:** `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek`
- **Logic expanded:** Projection with `rclnt IN ('120','200')` filter.
- **Point of consumption:** Directly used in `Joined_With_CalWeek` (Join_4 right side).

### CV_BASE_MD_CEPCT_S4 → CTE `PROFIT_CENTER_TEXT`
- **Physical source:** `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct`
- **Logic expanded:** Projection with `mandt IN ('120','200')` filter. `ltext` aliased as `profit_center_text` (meaningful rename).
- **Point of consumption:** Directly used in `Joined_With_ProfitCenterText` (Join_1 right side).

---

## 6. USED / NOT USED Classifications

| File | Classification | Reason |
|---|---|---|
| CV_COMP_SKF_FORECAST_DI ... | USED | Final consumer — defines the entire transformation flow |
| CV_BASE_SKF_WEEKLY_FORECAST_S4_DI ... | USED | Upstream dependency; expanded into CTE WEEKLY_SNAPSHOT_DS05 |
| CV_BASE_MD_SRPACT_S4_DI ... | USED | Upstream dependency; expanded into CTE STORE_ATTR_ACTUAL |
| CV_BASE_MD_COMPFL_S4_DI ... | USED | Upstream dependency; expanded into CTE COMP_FLAG_FCST |
| CV_BASE_MD_RCALWEEK_S4_DI ... | USED | Upstream dependency; expanded into CTE CAL_WEEK |
| CV_BASE_MD_CEPCT_S4_DI ... | USED | Upstream dependency; expanded into CTE PROFIT_CENTER_TEXT |

---

## 7. Filter, Join, Aggregation, and Parameter Trace

### Filters Traced to Output SQL

| Filter | Source File | SQL Location |
|---|---|---|
| `mandt IN ('120','200')` | CV_BASE_SKF_WEEKLY_FORECAST_S4 | CTE WEEKLY_SNAPSHOT_DS05 WHERE clause |
| `fiscvarnt = 'K4'` | CV_COMP_SKF_FORECAST (WEEKLY_SNAPSHOT_DS05 node) | CTE WEEKLY_SNAPSHOT_DS05 WHERE clause |
| `bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to` | CV_COMP_SKF_FORECAST (parameter IP_WEEK_ENDING_FROM/TO) | CTE WEEKLY_SNAPSHOT_DS05 WHERE clause |
| `bic_zio_ver = @ip_version` | CV_COMP_SKF_FORECAST (parameter IP_VERSION) | CTE WEEKLY_SNAPSHOT_DS05 WHERE clause |
| `bic_zio_saudt IN ('1','10')` | CV_COMP_SKF_FORECAST (WEEKLY_SNAPSHOT_DS05 node) | CTE WEEKLY_SNAPSHOT_DS05 WHERE clause |
| `bic_zio_pskf IN ('804013','801000')` | CV_COMP_SKF_FORECAST (WEEKLY_SNAPSHOT_DS05 node) | CTE WEEKLY_SNAPSHOT_DS05 WHERE clause |
| `mandt IN ('120','200')` | CV_BASE_MD_SRPACT_S4 | CTE STORE_ATTR_ACTUAL WHERE clause |
| `mandt IN ('110','200')` | CV_BASE_MD_COMPFL_S4 | CTE COMP_FLAG_FCST WHERE clause |
| `comp_ver = @ip_version` | CV_COMP_SKF_FORECAST (COMP_FLAG_FCST node) | CTE COMP_FLAG_FCST WHERE clause |
| `rclnt IN ('120','200')` | CV_BASE_MD_RCALWEEK_S4 | CTE CAL_WEEK WHERE clause |
| `mandt IN ('120','200')` | CV_BASE_MD_CEPCT_S4 | CTE PROFIT_CENTER_TEXT WHERE clause |

### Joins Traced to Output SQL

| Join | Source File | SQL Location |
|---|---|---|
| LEFT JOIN STORE_ATTR_ACTUAL ON b631_s_proftctr = prctr | CV_COMP_SKF_FORECAST (Join_2) | CTE Joined_WeeklySnapshot_StoreAttr |
| LEFT JOIN COMP_FLAG_FCST ON b631_s_proftctr = prctr AND bic_zio_sweek = zweek | CV_COMP_SKF_FORECAST (Join_3) | CTE Joined_With_CompFlag |
| LEFT JOIN CAL_WEEK ON bic_zio_sweek = zzweek | CV_COMP_SKF_FORECAST (Join_4) | CTE Joined_With_CalWeek |
| LEFT JOIN PROFIT_CENTER_TEXT ON b631_s_proftctr = prctr | CV_COMP_SKF_FORECAST (Join_1) | CTE Joined_With_ProfitCenterText |

### Calculations Traced to Output SQL

| Calculation | Source File | SQL Location |
|---|---|---|
| `RIGHT(bic_zio_sweek, 2) AS cal_week_number` | CV_COMP_SKF_FORECAST (FLAGS node) | CTE FLAGS SELECT |
| `CASE WHEN bic_zio_pskf = '804013' THEN bic_zio_skfq * 2 ELSE bic_zio_skfq END AS cal_bic_zio_skfq` | CV_COMP_SKF_FORECAST (FLAGS node) | CTE FLAGS SELECT |
| `bic_zio_pctr AS b631_s_proftctr` (rename) | CV_BASE_SKF_WEEKLY_FORECAST_S4 | CTE WEEKLY_SNAPSHOT_DS05 SELECT |
| `bic_zio_cctr AS b631_s_costcntr` (rename) | CV_BASE_SKF_WEEKLY_FORECAST_S4 | CTE WEEKLY_SNAPSHOT_DS05 SELECT |
| `ltext AS profit_center_text` (rename) | CV_COMP_SKF_FORECAST (PROFIT_CENTER_TEXT node) | CTE PROFIT_CENTER_TEXT SELECT |

### Aggregations Traced to Output SQL

| Aggregation | Source File | SQL Location |
|---|---|---|
| `SUM(bic_zio_skfq) AS bic_zio_skfq_1` | CV_COMP_SKF_FORECAST (FLAGS logical model, _BIC_ZIO_SKFQ_1) | Final SELECT |
| `SUM(cal_bic_zio_skfq) AS bic_zio_skfq` | CV_COMP_SKF_FORECAST (FLAGS logical model, _BIC_ZIO_SKFQ) | Final SELECT |
| `SUM(rx_hrs_oper)`, `SUM(fs_hrs_oper)`, `SUM(retail_sqft_amt)`, `SUM(total_sqft_amt)` | CV_BASE_MD_SRPACT_S4 (CUBE aggregation) | CTE STORE_ATTR_ACTUAL |

### Runtime Parameters

| Parameter | Type | Source | Usage |
|---|---|---|---|
| `@ip_version` | STRING | CV_COMP_SKF_FORECAST input parameter IP_VERSION | Filter: `bic_zio_ver = @ip_version` (WEEKLY_SNAPSHOT_DS05); `comp_ver = @ip_version` (COMP_FLAG_FCST) |
| `@ip_week_ending_from` | STRING | CV_COMP_SKF_FORECAST input parameter IP_WEEK_ENDING_FROM | Filter: `bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to` |
| `@ip_week_ending_to` | STRING | CV_COMP_SKF_FORECAST input parameter IP_WEEK_ENDING_TO | Filter: `bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to` |

**Note:** `bic_zio_sweek` has `BQ_DATATYPE = STRING` (NUMC in HANA). Parameters `@ip_week_ending_from` and `@ip_week_ending_to` must be supplied as STRING values at runtime. `bic_zio_ver` is STRING; `@ip_version` must be STRING. `comp_ver` is STRING; `@ip_version` is compatible.

---

## 8. Alias Check and Column Mapping Applied

### Physical Column Replacements by Table

#### `edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds031` (HANA: AZSRP_DS031_VT_S4)
| HANA Column | BQ_COLUMN | Used In |
|---|---|---|
| FISCPER | fiscper | WEEKLY_SNAPSHOT_DS05 |
| FISCVARNT | fiscvarnt | WEEKLY_SNAPSHOT_DS05 |
| FISCYEAR | fiscyear | WEEKLY_SNAPSHOT_DS05 |
| FISCPER3 | fiscper3 | WEEKLY_SNAPSHOT_DS05 |
| MANDT | mandt | WEEKLY_SNAPSHOT_DS05 |
| RECORDMODE | recordmode | WEEKLY_SNAPSHOT_DS05 |
| UNIT | unit | WEEKLY_SNAPSHOT_DS05 |
| _BIC_ZIO_SWEEK | bic_zio_sweek | WEEKLY_SNAPSHOT_DS05 |
| _BIC_ZIO_PSTY | bic_zio_psty | WEEKLY_SNAPSHOT_DS05 |
| _BIC_ZIO_PSKF | bic_zio_pskf | WEEKLY_SNAPSHOT_DS05 |
| _B631_S_CO_AREA | b631_s_co_area | WEEKLY_SNAPSHOT_DS05 |
| _BIC_ZIO_CMPCD | bic_zio_cmpcd | WEEKLY_SNAPSHOT_DS05 |
| _BIC_ZIO_PCTR | bic_zio_pctr → b631_s_proftctr (meaningful rename) | WEEKLY_SNAPSHOT_DS05 |
| _BIC_ZIO_CCTR | bic_zio_cctr → b631_s_costcntr (meaningful rename) | WEEKLY_SNAPSHOT_DS05 |
| _BIC_ZIO_VER | bic_zio_ver | WEEKLY_SNAPSHOT_DS05 |
| _BIC_ZIO_SAUDT | bic_zio_saudt | WEEKLY_SNAPSHOT_DS05 |
| _BIC_ZIO_SKFQ | bic_zio_skfq | WEEKLY_SNAPSHOT_DS05 |

#### `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act` (HANA: ZTSRP_ATTR_ACT)
All columns mapped one-to-one from CSV. Key columns used downstream:
`mandt`, `strnum`, `prctr`, `rep_mkt_code`, `rep_mkt_desc`, `emerg_mkt_ind`, `division_code`, `division_desc`, `area_code`, `area_desc`, `region_code`, `region_desc`, `district_code`, `district_desc`, `city`, `state`, `fs_open_dat`, `rx_open_dat`, `rx_division_code`, `rx_area_code`, `rx_region_code`, `rx_district_code`, `rx_hrs_oper`, `fs_hrs_oper`, `retail_sqft_amt`, `total_sqft_amt`.

#### `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl` (HANA: ZTSRP_COMPFL)
| HANA Column | BQ_COLUMN | Used In |
|---|---|---|
| MANDT | mandt | COMP_FLAG_FCST |
| PRCTR | prctr | COMP_FLAG_FCST |
| STRNUM | strnum | COMP_FLAG_FCST |
| COMP_VER | comp_ver | COMP_FLAG_FCST |
| ZWEEK | zweek | COMP_FLAG_FCST |
| ZMONTH | zmonth | COMP_FLAG_FCST |
| ZYEAR | zyear | COMP_FLAG_FCST |
| FS_COMP_PRE | fs_comp_pre | COMP_FLAG_FCST |
| RX_COMP_PRE | rx_comp_pre | COMP_FLAG_FCST |
| FS_COMP_MON | fs_comp_mon | COMP_FLAG_FCST |
| RX_COMP_MON | rx_comp_mon | COMP_FLAG_FCST |
| FS_COMP_WK | fs_comp_wk | COMP_FLAG_FCST |
| RX_COMP_WK | rx_comp_wk | COMP_FLAG_FCST |

#### `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek` (HANA: ZTFIGL_RCALWEEK)
| HANA Column | BQ_COLUMN | Used In |
|---|---|---|
| RCLNT | rclnt | CAL_WEEK |
| ZZWEEK | zzweek | CAL_WEEK |
| ZCALYRP | zcalyrp | CAL_WEEK |
| ZRYEAR | zryear | CAL_WEEK |
| ZRPERIOD | zrperiod | CAL_WEEK |
| ZRYRP | zryrp | CAL_WEEK |
| ZRYRQTR | zryrqtr | CAL_WEEK |
| ZRWSTRTDATE | zrwstrtdate | CAL_WEEK |
| ZRWENDDATE | zrwenddate | CAL_WEEK |

#### `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct` (HANA: CEPCT)
| HANA Column | BQ_COLUMN | Used In |
|---|---|---|
| MANDT | mandt | PROFIT_CENTER_TEXT |
| SPRAS | spras | PROFIT_CENTER_TEXT |
| PRCTR | prctr | PROFIT_CENTER_TEXT |
| DATBI | datbi | PROFIT_CENTER_TEXT |
| KOKRS | kokrs | PROFIT_CENTER_TEXT |
| KTEXT | ktext | PROFIT_CENTER_TEXT |
| LTEXT | ltext → profit_center_text (meaningful rename) | PROFIT_CENTER_TEXT |
| MCTXT | mctxt | PROFIT_CENTER_TEXT |

### Alias Check Results
- All physical column names in the SQL exactly match their `BQ_COLUMN` values from the CSV.
- Redundant HANA-name aliases (e.g., `bic_zio_sweek AS _BIC_ZIO_SWEEK`) have been removed.
- Retained meaningful renames:
  - `bic_zio_pctr AS b631_s_proftctr` — required by CV_BASE_SKF_WEEKLY_FORECAST_S4 output contract
  - `bic_zio_cctr AS b631_s_costcntr` — required by CV_BASE_SKF_WEEKLY_FORECAST_S4 output contract
  - `ltext AS profit_center_text` — required by CV_COMP_SKF_FORECAST PROFIT_CENTER_TEXT node
- No aliases that merely change case, leading underscore, or `/` vs `_` remain.

---

## 9. Data Type Conversions and Casts Applied

### MANDT / RCLNT Filters (CLNT → STRING)
All `mandt` and `rclnt` columns have `BQ_DATATYPE = STRING`. The converted SQL files used numeric literals (120, 200, 110). These have been corrected to quoted STRING literals in all CTEs:
- `mandt IN ('120', '200')` — WEEKLY_SNAPSHOT_DS05, STORE_ATTR_ACTUAL, PROFIT_CENTER_TEXT
- `mandt IN ('110', '200')` — COMP_FLAG_FCST
- `rclnt IN ('120', '200')` — CAL_WEEK

### bic_zio_sweek (NUMC → STRING)
`bic_zio_sweek` has `BQ_DATATYPE = STRING`. The `RIGHT()` function in `cal_week_number` operates directly on the STRING value — no cast required. The BETWEEN filter uses `@ip_week_ending_from` and `@ip_week_ending_to` which must be supplied as STRING values.

### bic_zio_skfq (FLTP → FLOAT64)
`bic_zio_skfq` has `BQ_DATATYPE = FLOAT64`. The expression `bic_zio_skfq * 2` is valid FLOAT64 arithmetic. No cast required.

### Date columns (DATS → DATE)
`zrwstrtdate`, `zrwenddate`, `fs_open_dat`, `rx_open_dat`, `datbi`, `created_on`, etc. are all `BQ_DATATYPE = DATE`. No casts required as they are passed through without comparison to literals.

---

## 10. CTE Structure and Justification

| CTE | Justified By |
|---|---|
| WEEKLY_SNAPSHOT_DS05 | Required semantic boundary: upstream CUBE aggregation from CV_BASE_SKF_WEEKLY_FORECAST_S4 with column renames and multi-filter set. Named per final-consumer node. |
| STORE_ATTR_ACTUAL | Required semantic boundary: upstream CUBE aggregation (SUM of measures + GROUP BY) from CV_BASE_MD_SRPACT_S4. Named per final-consumer node. |
| Joined_WeeklySnapshot_StoreAttr | Required: represents Join_2 LEFT OUTER JOIN in CV_COMP_SKF_FORECAST. Intermediate result needed for subsequent joins. |
| COMP_FLAG_FCST | Required semantic boundary: upstream DIMENSION projection from CV_BASE_MD_COMPFL_S4 with consumer-level filter on comp_ver. Named per final-consumer node. |
| Joined_With_CompFlag | Required: represents Join_3 LEFT OUTER JOIN in CV_COMP_SKF_FORECAST. |
| CAL_WEEK | Required semantic boundary: upstream DIMENSION projection from CV_BASE_MD_RCALWEEK_S4. Named per final-consumer node. |
| Joined_With_CalWeek | Required: represents Join_4 LEFT OUTER JOIN in CV_COMP_SKF_FORECAST. |
| PROFIT_CENTER_TEXT | Required semantic boundary: upstream DIMENSION projection from CV_BASE_MD_CEPCT_S4 with meaningful rename. Named per final-consumer node. |
| Joined_With_ProfitCenterText | Required: represents Join_1 LEFT OUTER JOIN in CV_COMP_SKF_FORECAST. Feeds FLAGS. |
| FLAGS | Required semantic boundary: final projection + calculated columns (cal_week_number, cal_bic_zio_skfq) must be computed before aggregation. Named per final-consumer logical model. |
| Final SELECT | Required: CUBE aggregation (SUM + GROUP BY) as defined by CV_COMP_SKF_FORECAST outputViewType="Aggregation". |

---

## 11. Duplicate, Ambiguous-Column, and Aggregation Validation

- **Duplicate columns:** No duplicate aliases exist within any single SELECT. Each CTE explicitly qualifies all column references with table aliases where multiple inputs are in scope.
- **Ambiguous column references:** All columns in join CTEs are fully qualified with their input alias (e.g., `ws.fiscper`, `sa.prctr`).
- **Aggregation grain:** The final aggregation grain matches the FLAGS logical model output contract. The STORE_ATTR_ACTUAL aggregation grain matches CV_BASE_MD_SRPACT_S4's CUBE output contract.
- **DISTINCT/UNION:** No DISTINCT or UNION logic is present in any source file.
- **Window functions:** None present.

---

## 12. Star Projection Validation

The original converted SQL for CV_BASE_MD_SRPACT_S4 used `SELECT *` in the CTE. This has been expanded to explicit column lists in `STORE_ATTR_ACTUAL` to prevent ambiguity and ensure the output contract is deterministic. All other CTEs use explicit column lists.

---

## 13. Procedure / ETL Handling

No stored procedures, INSERT-SELECT, CREATE TABLE AS SELECT, or MERGE statements are present in any of the supplied converted SQL files. All artifacts are Calculation View XML conversions producing SELECT-based logic only.

---

## 14. Quality Gate Results

| Gate | Result |
|---|---|
| 1. Final consumer unambiguous | ✅ PASSED — CV_COMP_SKF_FORECAST |
| 2. Artifact dependencies match lineage | ✅ PASSED — all 5 lineage edges represented |
| 3. Final-consumer transformation order preserved | ✅ PASSED — Join_2, Join_3, Join_4, Join_1, FLAGS, Final SELECT |
| 4. Dependencies expanded at point of consumption | ✅ PASSED |
| 5. No generic Source→Intermediate→Target ordering | ✅ PASSED |
| 6. Every file classified USED/NOT USED | ✅ PASSED — all 6 files USED |
| 7. Every USED file participates in dependency chain | ✅ PASSED |
| 8. All converted dependencies expanded | ✅ PASSED |
| 9. Only terminal sources remain | ✅ PASSED |
| 10. Every physical source uses BQ_FULL_TABLE name | ✅ PASSED — no PROJECT.DATASET placeholders remain |
| 11. Every referenced physical-source column mapped via CSV | ✅ PASSED — all columns verified against full CSV |
| 12. Type consistency in comparisons | ✅ PASSED — MANDT/RCLNT corrected to STRING literals; FLOAT64 arithmetic valid |
| 13. Final-consumer CTE names preserved | ✅ PASSED — WEEKLY_SNAPSHOT_DS05, STORE_ATTR_ACTUAL, COMP_FLAG_FCST, CAL_WEEK, PROFIT_CENTER_TEXT, FLAGS preserved |
| 14. Compatible operations combined | ✅ PASSED — projection + filter combined in each source CTE |
| 15. No source node becomes CTE merely to mirror structure | ✅ PASSED |
| 16. Every helper CTE justified by semantic boundary | ✅ PASSED |
| 17. Every CTE matches required output contract | ✅ PASSED |
| 18. Column references qualified and unambiguous | ✅ PASSED |
| 19. No duplicate alias within a SELECT | ✅ PASSED |
| 20. Star projections valid | ✅ PASSED — expanded to explicit lists |
| 21. Filters, joins, calculations, parameters preserved | ✅ PASSED |
| 22. Aggregation grain preserved | ✅ PASSED |
| 23. DISTINCT, UNION, window behavior preserved | ✅ PASSED — none present |
| 24. No conflict silently corrected | ✅ PASSED — MANDT type correction documented |
| 25. No result-affecting procedural behavior discarded | ✅ PASSED — no procedures present |
| 26. Runtime parameters documented, no DECLARE/SET | ✅ PASSED |
| 27. Every CTE has standardized comment header | ✅ PASSED |
| 28. CTE comments describe consolidated logic | ✅ PASSED |
| 29. 100% logic match with minimum CTE structure | ✅ PASSED |
| 30. Every lineage edge represented by correct supplied logic | ✅ PASSED |
| 31. Every filter/join/aggregation/parameter traced to output | ✅ PASSED |
| 32. Physical-column outputs use exact BQ_COLUMN | ✅ PASSED |

---

## 15. ISSUES TO FIX

### Non-Blocking (Corrected in SQL)
1. **MANDT/RCLNT STRING type correction:** The converted SQL files used numeric literals `IN (120, 200)` and `IN (110, 200)` for `mandt` and `rclnt` columns. The CSV maps these as `BQ_DATATYPE = STRING`. All occurrences have been corrected to quoted STRING literals `IN ('120', '200')` and `IN ('110', '200')` in the consolidated SQL.

2. **Star projection expansion:** `CV_BASE_MD_SRPACT_S4` used `SELECT *` in its CTE. Expanded to explicit column list in `STORE_ATTR_ACTUAL` to ensure deterministic output contract.

3. **GROUP BY typo in CV_BASE_SKF_WEEKLY_FORECAST_S4:** The original converted file contained `_BIC_ZIO_PROFTCTR` (incorrect) in the GROUP BY instead of `_B631_S_PROFTCTR`. This has been corrected in the consolidated SQL — the renamed column `b631_s_proftctr` is used consistently.

### Non-Blocking (Runtime Parameters)
4. **@ip_version, @ip_week_ending_from, @ip_week_ending_to:** These are input parameters defined in `CV_COMP_SKF_FORECAST` and are represented as BigQuery runtime parameters. Their values must be supplied by the caller at query execution time. No default values are set in the SQL.

### No Unresolved Issues Remain
All lineage edges are fully resolved. No missing mappings, ambiguous dependencies, or unresolvable conflicts were found. The consolidated SQL is complete and traceable to all supplied inputs.
