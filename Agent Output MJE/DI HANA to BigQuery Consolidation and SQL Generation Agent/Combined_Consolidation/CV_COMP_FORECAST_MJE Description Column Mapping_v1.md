# CV_COMP_FORECAST_MJE — Consolidation Description

---

## 1. Input Confirmation

### Inputs Read

| Input | Status | Details |
|---|---|---|
| `mje cv comp forecast Relationships Table.txt` | ✅ Read | 5 lineage rows |
| `CV_COMP_FORECAST_MJE.txt` | ✅ Read | 1 converted SQL file |
| `Columns_Mapping.csv` | ✅ Read | Full CSV — ~700+ rows across 14 physical tables |

### Lineage Rows Read (5 total)

| Source File | Target File | Dependency Type |
|---|---|---|
| CV_COMP_FIN_FORECAST | CV_COMP_FORECAST_MJE | Calculation View Dependency |
| CV_COMP_SKF_FORECAST | CV_COMP_FORECAST_MJE | Calculation View Dependency |
| CV_COMP_FIN_SBT | CV_COMP_FORECAST_MJE | Calculation View Dependency |
| CV_COMP_FIN_MANUAL_JE | CV_COMP_FORECAST_MJE | Calculation View Dependency |
| CV_COMP_SKF_MANUAL_JE | CV_COMP_FORECAST_MJE | Calculation View Dependency |

### Files in CV_COMP_FORECAST_MJE (1 file)

| File | Classification | Reason |
|---|---|---|
| `CV_COMP_FORECAST_MJE.txt` | **USED** | Final consumer artifact. Contains the complete converted BigQuery SQL for CV_COMP_FORECAST_MJE including all 5 upstream projection CTEs, the COMBINED UNION ALL, the VARIANCES projection, and the final aggregation SELECT. |

> **Note:** No separate converted SQL files were supplied for the 5 upstream Calculation Views (CV_COMP_FIN_FORECAST, CV_COMP_SKF_FORECAST, CV_COMP_FIN_SBT, CV_COMP_FIN_MANUAL_JE, CV_COMP_SKF_MANUAL_JE). The converted SQL for CV_COMP_FORECAST_MJE treats them as external BigQuery objects. This is documented in the ISSUES TO FIX section.

---

## 2. Final Consumer Identification

**Final Consumer:** `CV_COMP_FORECAST_MJE`

- **HANA Artifact Type:** Calculation View (CUBE, outputViewType="Aggregation")
- **Role:** Consumer-facing aggregation view combining financial forecast, SKF forecast, Sales by Territory (SBT), financial manual journal entries, and SKF manual journal entries into a unified output.
- **Output Grain:** Aggregated (SUM) by all dimension columns; measures are summed.
- **Calculated Attributes (post-aggregation):** `cal_comp_flag_desc`, `cal_emerg_mkt_ind`

---

## 3. Artifact Dependency Mapping

| Lineage Edge | Producer | Consumer | SQL Location |
|---|---|---|---|
| Edge 1 | CV_COMP_FIN_FORECAST | CV_COMP_FORECAST_MJE | CTE `FIN_FORECAST` — SELECT from external view CV_COMP_FIN_FORECAST with filter `fs_rx_flag IN ('FS', 'RX')` |
| Edge 2 | CV_COMP_SKF_FORECAST | CV_COMP_FORECAST_MJE | CTE `SKF_FORECAST` — SELECT from external view CV_COMP_SKF_FORECAST |
| Edge 3 | CV_COMP_FIN_SBT | CV_COMP_FORECAST_MJE | CTE `FIN_SBT` — SELECT from external view CV_COMP_FIN_SBT |
| Edge 4 | CV_COMP_FIN_MANUAL_JE | CV_COMP_FORECAST_MJE | CTE `FIN_MANUAL_JE` — SELECT from external view CV_COMP_FIN_MANUAL_JE |
| Edge 5 | CV_COMP_SKF_MANUAL_JE | CV_COMP_FORECAST_MJE | CTE `SKF_MANUAL_JE` — SELECT from external view CV_COMP_SKF_MANUAL_JE |

---

## 4. Final-Consumer Flow / Transformation Order

The flow follows the node sequence defined in the CV_COMP_FORECAST_MJE converted SQL:

1. **FIN_FORECAST** (CTE 1) — Projection + filter from CV_COMP_FIN_FORECAST
2. **SKF_FORECAST** (CTE 2) — Projection from CV_COMP_SKF_FORECAST
3. **FIN_SBT** (CTE 3) — Projection from CV_COMP_FIN_SBT
4. **FIN_MANUAL_JE** (CTE 4) — Projection from CV_COMP_FIN_MANUAL_JE
5. **SKF_MANUAL_JE** (CTE 5) — Projection from CV_COMP_SKF_MANUAL_JE
6. **COMBINED** (CTE 6) — UNION ALL of all 5 projections with explicit column mapping and constants
7. **VARIANCES** (CTE 7) — Projection over COMBINED with column renames (output contract alignment)
8. **Final SELECT** — SUM aggregation of measures, GROUP BY all dimensions, CASE expressions for calculated attributes

---

## 5. Dependency Expansion and Point-of-Consumption Mapping

Each upstream dependency is expanded at its point of consumption in the final-consumer flow:

- **CV_COMP_FIN_FORECAST** → expanded as CTE `FIN_FORECAST` (CTE 1), consumed in COMBINED Branch 1
- **CV_COMP_SKF_FORECAST** → expanded as CTE `SKF_FORECAST` (CTE 2), consumed in COMBINED Branch 2
- **CV_COMP_FIN_SBT** → expanded as CTE `FIN_SBT` (CTE 3), consumed in COMBINED Branch 3
- **CV_COMP_FIN_MANUAL_JE** → expanded as CTE `FIN_MANUAL_JE` (CTE 4), consumed in COMBINED Branch 4
- **CV_COMP_SKF_MANUAL_JE** → expanded as CTE `SKF_MANUAL_JE` (CTE 5), consumed in COMBINED Branch 5

The 5 upstream views are referenced as external BigQuery objects (their internal logic is not supplied). The projection CTEs preserve all columns required by the COMBINED UNION ALL.

---

## 6. USED / NOT USED Classification

| File | Classification | Reason |
|---|---|---|
| `CV_COMP_FORECAST_MJE.txt` | **USED** | Final consumer — all logic sourced from this file |

No files are classified NOT USED; only one file was supplied.

---

## 7. Filter, Join, Aggregation, UNION, and Parameter Trace

### Filters

| Filter | Source File | CTE | SQL Clause |
|---|---|---|---|
| `fs_rx_flag IN ('FS', 'RX')` | CV_COMP_FORECAST_MJE.txt | FIN_FORECAST | WHERE clause |

No other explicit filters are defined in the converted SQL. Input parameters are passed to the upstream views but their usage within those views is not defined in the supplied file.

### Joins

No joins are defined in CV_COMP_FORECAST_MJE. All logic is based on projections and UNION ALL.

### UNION ALL Branches

| Branch | Source CTE | cal_data_category1 | cal_data_category2 | Key Measure Column | fs_rx_flag |
|---|---|---|---|---|---|
| 1 | FIN_FORECAST | 'FIN' | 'FIN_FCST' | b631_s_amount → fin_fcst_amount | from source |
| 2 | SKF_FORECAST | 'SKF' | 'SKF_FCST' | bic_zio_skfq → skf_fcst_qty | 'RX' (constant) |
| 3 | FIN_SBT | 'FIN' | 'FIN_SBT' | wsl → sbt (via VARIANCES) | 'FS' (constant) |
| 4 | FIN_MANUAL_JE | 'FIN' | 'FIN_MJE' | cal_fs_sales, cal_rx_sales → cal_fs_sales_mje, cal_rx_sales_mje | cal_fs_rx_flag (from source) |
| 5 | SKF_MANUAL_JE | 'SKF' | 'SKF_MJE' | msl → skf_mje_qty (via VARIANCES) | 'RX' (constant) |

### Aggregation

| Measure | Aggregation | Source Column | Output Column |
|---|---|---|---|
| Financial forecast amount | SUM | fin_fcst_amount | fin_fcst_amount |
| SKF forecast quantity | SUM | skf_fcst_qty | skf_fcst_qty |
| Sales by Territory | SUM | sbt (from wsl) | sbt |
| SKF MJE quantity | SUM | skf_mje_qty (from msl) | skf_mje_qty |
| FS sales MJE | SUM | cal_fs_sales_mje (from cal_fs_sales) | cal_fs_sales_mje |
| RX sales MJE | SUM | cal_rx_sales_mje (from cal_rx_sales) | cal_rx_sales_mje |

GROUP BY: All non-measure columns in the final SELECT (35 dimension columns).

### Calculated Attributes (Post-Aggregation)

| Output Column | Logic | Source Column |
|---|---|---|
| cal_comp_flag_desc | CASE comp_flag WHEN '1' THEN 'Comp' WHEN '0' THEN 'Non-Comp' ELSE '' END | comp_flag |
| cal_emerg_mkt_ind | CASE WHEN emerg_mkt_ind = 'Y' THEN 'Yes' WHEN emerg_mkt_ind = 'N' THEN 'No' ELSE '' END | emerg_mkt_ind |

### Parameters

| Parameter | Type | Usage | Source | Reason Unresolved |
|---|---|---|---|---|
| @ip_fin_version | STRING | Passed to CV_COMP_FIN_FORECAST | CV_COMP_FORECAST_MJE.txt (UNRESOLVED_ITEMS) | Usage inside upstream view not supplied |
| @ip_week_ending_from | STRING | Passed to upstream views | CV_COMP_FORECAST_MJE.txt (UNRESOLVED_ITEMS) | Usage inside upstream views not supplied |
| @ip_week_ending_to | STRING | Passed to upstream views | CV_COMP_FORECAST_MJE.txt (UNRESOLVED_ITEMS) | Usage inside upstream views not supplied |
| @ip_skf_version | STRING | Passed to CV_COMP_SKF_FORECAST | CV_COMP_FORECAST_MJE.txt (UNRESOLVED_ITEMS) | Usage inside upstream view not supplied |

> These parameters are documented as runtime parameters. Their values are supplied at query execution time. They are not declared or defaulted in the SQL. Since the internal logic of the upstream views is not supplied, these parameters cannot be inlined into the consolidated SQL. They must be passed to the upstream views at runtime.

---

## 8. Alias Check — Column Name Mapping Applied

### Name-Equivalence Rule Applied

All HANA-style column names in the converted SQL were converted to BigQuery style:
- Lowercase
- Leading underscore removed
- `/` replaced with `_`

### Key Column Name Transformations

| HANA Name (in converted SQL) | BigQuery Style Name | Rule Applied |
|---|---|---|
| `_BIC_ZIO_SWEEK` | `bic_zio_sweek` | Remove leading `_`, lowercase |
| `_B631_S_PROFTCTR` | `b631_s_proftctr` | Remove leading `_`, lowercase |
| `_B631_S_AMOUNT` | `b631_s_amount` | Remove leading `_`, lowercase |
| `_BIC_ZIO_SKFQ` | `bic_zio_skfq` | Remove leading `_`, lowercase |
| `MANDT` | `mandt` | Lowercase |
| `FS_RX_FLAG` | `fs_rx_flag` | Lowercase |
| `REP_MKT_CODE` | `rep_mkt_code` | Lowercase |
| `REP_MKT_DESC` | `rep_mkt_desc` | Lowercase |
| `EMERG_MKT_IND` | `emerg_mkt_ind` | Lowercase |
| `COMP_FLAG` | `comp_flag` | Lowercase |
| `DIVISION_CODE` | `division_code` | Lowercase |
| `DIVISION_DESC` | `division_desc` | Lowercase |
| `REGION_CODE` | `region_code` | Lowercase |
| `REGION_DESC` | `region_desc` | Lowercase |
| `DISTRICT_CODE` | `district_code` | Lowercase |
| `DISTRICT_DESC` | `district_desc` | Lowercase |
| `AREA_CODE` | `area_code` | Lowercase |
| `AREA_DESC` | `area_desc` | Lowercase |
| `STRNUM` | `strnum` | Lowercase |
| `ZRWSTRTDATE` | `zrwstrtdate` | Lowercase |
| `ZRWENDDATE` | `zrwenddate` | Lowercase |
| `CAL_WEEK_NUMBER` | `cal_week_number` | Lowercase |
| `CITY` | `city` | Lowercase |
| `STATE` | `state` | Lowercase |
| `CURRENCY` | `currency` (aliased to `forecast_currency`) | Lowercase; meaningful rename preserved |
| `PROFIT_CENTER_TEXT` | `profit_center_text` | Lowercase |
| `FS_OPEN_DAT` | `fs_open_dat` | Lowercase |
| `RX_OPEN_DAT` | `rx_open_dat` | Lowercase |
| `RX_DIVISION_CODE` | `rx_division_code` | Lowercase |
| `RX_AREA_CODE` | `rx_area_code` | Lowercase |
| `RX_REGION_CODE` | `rx_region_code` | Lowercase |
| `RX_DISTRICT_CODE` | `rx_district_code` | Lowercase |
| `RX_COMP_WK` | `rx_comp_wk` | Lowercase |
| `PRCTR` | `prctr` | Lowercase |
| `ZZWEEK` | `zzweek` | Lowercase |
| `CAL_COMP_FLAG` | `cal_comp_flag` | Lowercase |
| `WSL` | `wsl` | Lowercase |
| `RCLNT` | `rclnt` | Lowercase |
| `CAL_FS_RX_FLAG` | `cal_fs_rx_flag` | Lowercase |
| `CAL_FS_SALES` | `cal_fs_sales` | Lowercase |
| `CAL_RX_SALES` | `cal_rx_sales` | Lowercase |
| `MSL` | `msl` | Lowercase |
| `SOURCE_CODE` | `source_code` | Lowercase |
| `DATE_FROM` | `date_from` | Lowercase |
| `STAGR` | `stagr` | Lowercase |
| `RCNTR` | `rcntr` | Lowercase |
| `KSL` | `ksl` | Lowercase |
| `PARNODE` | `parnode` | Lowercase |
| `BUDAT` | `budat` | Lowercase |
| `XREF2_HD` | `xref2_hd` | Lowercase |
| `GJAHR` | `gjahr` | Lowercase |
| `BELNR` | `belnr` | Lowercase |
| `BUKRS` | `bukrs` | Lowercase |
| `RWCUR` | `rwcur` | Lowercase |

### Meaningful Renames Retained

| Original Column | Alias | Reason |
|---|---|---|
| `currency` (from FIN_FORECAST) | `forecast_currency` | Meaningful rename defined in converted SQL |
| `b631_s_proftctr` (from FIN_FORECAST, SKF_FORECAST) | `prctr` | Meaningful rename defined in converted SQL |
| `b631_s_amount` (from FIN_FORECAST) | `fin_fcst_amount` | Meaningful rename defined in COMBINED |
| `bic_zio_skfq` (from SKF_FORECAST) | `skf_fcst_qty` | Meaningful rename defined in COMBINED |
| `rx_comp_wk` (from SKF_FORECAST) | `comp_flag` | Meaningful rename defined in COMBINED |
| `cal_comp_flag` (from FIN_SBT) | `comp_flag` | Meaningful rename defined in COMBINED |
| `zzweek` (from FIN_SBT, FIN_MANUAL_JE, SKF_MANUAL_JE) | `bic_zio_sweek` | Meaningful rename defined in COMBINED |
| `rclnt` (from FIN_MANUAL_JE, SKF_MANUAL_JE) | `mandt` | Meaningful rename defined in COMBINED |
| `cal_fs_rx_flag` (from FIN_MANUAL_JE) | `fs_rx_flag` | Meaningful rename defined in COMBINED |
| `wsl` (from COMBINED) | `sbt` | Meaningful rename defined in VARIANCES |
| `msl` (from COMBINED) | `skf_mje_qty` | Meaningful rename defined in VARIANCES |
| `cal_fs_sales` (from COMBINED) | `cal_fs_sales_mje` | Meaningful rename defined in VARIANCES |
| `cal_rx_sales` (from COMBINED) | `cal_rx_sales_mje` | Meaningful rename defined in VARIANCES |
| `forecast_currency` (from COMBINED) | `fin_forecast_currency` | Meaningful rename defined in VARIANCES |

### Redundant Aliases Removed

All aliases that only changed case, leading underscores, or `/` vs `_` were removed. No such aliases remain in the consolidated SQL.

---

## 9. CTE / Helper Mapping

| CTE | Type | Justification |
|---|---|---|
| FIN_FORECAST | Final-consumer CTE | Preserved from converted SQL; required semantic boundary for filter and projection from upstream view |
| SKF_FORECAST | Final-consumer CTE | Preserved from converted SQL; required projection from upstream view |
| FIN_SBT | Final-consumer CTE | Preserved from converted SQL; required projection from upstream view |
| FIN_MANUAL_JE | Final-consumer CTE | Preserved from converted SQL; required projection from upstream view |
| SKF_MANUAL_JE | Final-consumer CTE | Preserved from converted SQL; required projection from upstream view |
| COMBINED | Final-consumer CTE | Required semantic boundary — UNION ALL of 5 branches with explicit column mapping and constants |
| VARIANCES | Final-consumer CTE | Required semantic boundary — column renames for output contract alignment |

No helper CTEs were added. All 7 CTEs are preserved from the final-consumer converted SQL.

---

## 10. Table and Column Mapping Applied

### Physical Table Mapping

The 5 upstream Calculation Views are intermediate artifacts, not terminal physical tables. They do not appear in `Columns_Mapping.csv`. Their BigQuery full table paths are not available from the supplied inputs.

The Columns_Mapping.csv maps the following physical terminal tables (not directly referenced by the consolidated SQL since upstream view internal logic is not supplied):

| HANA Table | BQ_FULL_TABLE |
|---|---|
| ACDOCA_VT_S4 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_acdoca |
| BKPF | edp-qa-finstorage.edp_saps4_shared_cnsv.v_bkpf |
| FAGLSKF_PN | edp-qa-finstorage.edp_saps4_shared_cnsv.v_faglskf_pn |
| AZSRP_DS041_VT_S4 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds041 |
| AZSRP_DS052_VT_S4 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds202 |
| AZSRP_DS112_VT_S4 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds112 |
| AZSRP_DS072_VT_S4 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds212 |
| AZSRP_DS092_VT_S4 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds092 |
| AZSRP_DS031_VT_S4 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds031 |
| CEPCT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct |
| ZTFIGL_RCALWEEK | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek |
| ZTSRP_COMPFL | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl |
| ZTSRP_ATTR_ACT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act |
| HRRP_NODE | edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node |

### Data Type Handling

| Column / Context | BQ_DATATYPE | Cast Applied | Notes |
|---|---|---|---|
| `skf_fcst_qty` (NULL in non-SKF branches) | FLOAT64 | `CAST(NULL AS FLOAT64)` | UNION ALL type consistency |
| `fin_fcst_amount` (NULL in non-FIN branches) | NUMERIC | `CAST(NULL AS NUMERIC)` | UNION ALL type consistency |
| `wsl` (NULL in non-SBT branches) | NUMERIC | `CAST(NULL AS NUMERIC)` | UNION ALL type consistency |
| `cal_fs_sales` (NULL in non-MJE branches) | NUMERIC | `CAST(NULL AS NUMERIC)` | UNION ALL type consistency |
| `cal_rx_sales` (NULL in non-MJE branches) | NUMERIC | `CAST(NULL AS NUMERIC)` | UNION ALL type consistency |
| `msl` (NULL in non-SKF-MJE branches) | NUMERIC | `CAST(NULL AS NUMERIC)` | UNION ALL type consistency |
| `forecast_currency` (NULL in non-FIN-FCST branches) | STRING | `CAST(NULL AS STRING)` | UNION ALL type consistency |
| `source_code` (NULL in FIN_FORECAST, SKF_FORECAST, FIN_SBT branches) | STRING | `CAST(NULL AS STRING)` | UNION ALL type consistency |

---

## 11. Duplicate, Ambiguous-Column, Parent-Availability, and Aggregation Validation

- **Duplicates:** No duplicate aliases within any SELECT.
- **Ambiguous columns:** No ambiguity — each CTE has a single input source.
- **Parent availability:** All columns referenced in each CTE exist in the output of their parent CTE or external source.
- **Aggregation grain:** Preserved exactly. SUM on 6 measures. GROUP BY covers all 35 dimension columns. Calculated attributes computed after aggregation per HANA CUBE semantics.

---

## 12. Star Validation

No star projections used. All columns explicitly listed.

---

## 13. Parameter Documentation

| Parameter | Type | Source | Usage | Reason Unresolved |
|---|---|---|---|---|
| @ip_fin_version | STRING | CV_COMP_FORECAST_MJE.txt | Financial forecast version — passed to CV_COMP_FIN_FORECAST | Internal logic of upstream view not supplied |
| @ip_week_ending_from | STRING | CV_COMP_FORECAST_MJE.txt | Week ending from — passed to upstream views | Internal logic not supplied |
| @ip_week_ending_to | STRING | CV_COMP_FORECAST_MJE.txt | Week ending to — passed to upstream views | Internal logic not supplied |
| @ip_skf_version | STRING | CV_COMP_FORECAST_MJE.txt | SKF forecast version — passed to CV_COMP_SKF_FORECAST | Internal logic not supplied |

---

## 14. Procedure / ETL Handling

No stored procedures, INSERT-SELECT, CREATE TABLE AS SELECT, or MERGE statements present. No procedural handling required.

---

## 15. Conflicts and Validation Findings

### Corrected Items (Non-Blocking)

| Item | Correction Applied |
|---|---|
| HANA-style column names with leading `_` | Converted to BigQuery style per name-equivalence rule |
| All HANA uppercase column names | Converted to lowercase BigQuery style |
| NULL values in UNION ALL branches without explicit types | Added `CAST(NULL AS <type>)` for FLOAT64, NUMERIC, STRING |

### Non-Blocking Findings

| Finding | Impact | Resolution |
|---|---|---|
| Input parameters used in upstream views but usage not defined | Cannot be inlined; documented as runtime parameters | Runtime parameters documented |
| External scalar functions referenced in variable derivation | Not referenced in consolidated SQL directly | Non-blocking; upstream views handle at runtime |

---

## 16. ISSUES TO FIX

### Issue 1: Upstream Calculation View BigQuery Paths Not Mapped

**Affected:** CV_COMP_FIN_FORECAST, CV_COMP_SKF_FORECAST, CV_COMP_FIN_SBT, CV_COMP_FIN_MANUAL_JE, CV_COMP_SKF_MANUAL_JE

**Impact:** SQL references these views by HANA names. BigQuery full paths unknown. SQL will not execute until replaced with valid BigQuery view/table references.

**Resolution:** Provide BigQuery full table/view paths for each of the 5 upstream Calculation Views.

### Issue 2: Internal Logic of Upstream Calculation Views Not Supplied

**Affected:** All 5 upstream Calculation Views

**Impact:** Full end-to-end consolidation to terminal physical tables not possible. SQL cannot be fully expanded to terminal physical sources.

**Resolution:** Supply converted BigQuery SQL files for CV_COMP_FIN_FORECAST, CV_COMP_SKF_FORECAST, CV_COMP_FIN_SBT, CV_COMP_FIN_MANUAL_JE, CV_COMP_SKF_MANUAL_JE.

### Issue 3: Input Parameter Usage in Upstream Views Unresolved

**Affected Parameters:** @ip_fin_version, @ip_week_ending_from, @ip_week_ending_to, @ip_skf_version

**Impact:** Parameters cannot be applied at the correct logical stage.

**Resolution:** Once upstream view SQL files are supplied (Issue 2), inline parameter filters at the correct logical stage.

---

## 17. Final Quality Gate Results

| Check | Result | Notes |
|---|---|---|
| 1. Final consumer unambiguous | PASS | CV_COMP_FORECAST_MJE |
| 2. Artifact dependencies match lineage | PASS | All 5 lineage edges represented |
| 3. Final-consumer transformation order preserved | PASS | 7-CTE flow preserved |
| 4. Dependencies expanded at point of consumption | PASS | Each upstream view expanded as CTE at COMBINED branch |
| 5. No generic Source→Intermediate→Target ordering | PASS | Flow follows converted SQL node sequence |
| 6. Every file classified USED/NOT USED | PASS | 1 file: USED |
| 7. Every USED file participates in dependency chain | PASS | |
| 8. All converted dependencies expanded | ISSUE | Upstream view SQL files not supplied — Issue 2 |
| 9. Only terminal sources remain | ISSUE | Upstream views remain as external references — Issue 1 |
| 10. Every physical source uses BQ_FULL_TABLE | ISSUE | Upstream view BQ paths not available — Issue 1 |
| 11. Every referenced physical-source column mapped | ISSUE | Upstream view columns not in CSV — Issue 2 |
| 12. Type consistency in comparisons and UNION branches | PASS | CAST(NULL AS type) applied |
| 13. Final-consumer CTE names and order preserved | PASS | All 7 CTEs preserved |
| 14. Compatible operations combined | PASS | No unnecessary CTE splits |
| 15. No source node becomes separate CTE merely to mirror structure | PASS | |
| 16. Every helper CTE justified | PASS | All CTEs are functional boundaries |
| 17. Every CTE matches required output contract | PASS | |
| 18. All column references qualified where needed | PASS | Single input per CTE |
| 19. No duplicate alias within a SELECT | PASS | |
| 20. Retained star projections valid | PASS | No star projections |
| 21. Filters, joins, calculations, mappings, parameters preserved | PASS | |
| 22. Aggregation grain preserved | PASS | SUM on 6 measures, GROUP BY 35 dimensions |
| 23. DISTINCT, UNION, window behavior preserved | PASS | UNION ALL with 5 branches |
| 24. No conflict silently corrected | PASS | All corrections documented |
| 25. No result-affecting procedural behavior discarded | PASS | No procedures in scope |
| 26. Runtime parameters documented, no DECLARE/SET | PASS | 4 parameters documented |
| 27. Every CTE has standardized comment header | PASS | All 7 CTEs have headers |
| 28. CTE comments accurate | PASS | |
| 29. 100% logic match with minimum CTE structure | PASS | 7 CTEs = minimum required |
| 30. Every lineage edge represented | ISSUE | Full expansion blocked by missing upstream SQL — Issue 2 |
| 31. Every filter, join, aggregation, UNION, parameter traced | PASS | All traced in Section 7 |
| 32. Physical column outputs use exact BQ_COLUMN | ISSUE | Upstream view columns not in CSV — Issue 2 |

**Overall Status:** SQL is complete and logically correct based on supplied inputs. **Not production-ready** due to unresolved Issues 1, 2, and 3. See ISSUES TO FIX section.
