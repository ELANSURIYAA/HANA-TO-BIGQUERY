# 9-Projections-Layer Projection — Consolidation Description

---

## 1. Input Confirmation

### 1.1 Lineage Rows Read (9-projections-layer Relationships Table)

| Source File | Target File | Dependency Type |
|---|---|---|
| CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK | 9-projections-layer.xml | Calculation View Dependency |
| CV_COMP_FIN_FLASH_STATIC | 9-projections-layer.xml | Calculation View Dependency |
| CV_COMP_FIN_BUDGET_STATIC | 9-projections-layer.xml | Calculation View Dependency |
| CV_COMP_SKF_BUDGET_STATIC | 9-projections-layer.xml | Calculation View Dependency |
| CV_COMP_FORECAST_MJE_STATIC | 9-projections-layer.xml | Calculation View Dependency |
| CV_COMP_FIN_ACTUAL_STATIC | 9-projections-layer.xml | Calculation View Dependency |
| CV_COMP_SKF_ACTUAL_STATIC | 9-projections-layer.xml | Calculation View Dependency |
| CV_COMP_TOPSIDE_ADJUSTMENTS | 9-projections-layer.xml | Calculation View Dependency |

**Total lineage rows: 8**

### 1.2 Converted BigQuery SQL Files (9-projections-layer Converted Bigquery_v2)

One file was supplied:

| File | Classification | Reason |
|---|---|---|
| 9-projections-layer.xml → CV_COMP_FIN_FLASH_COMBINED_STATIC | **USED** | This is the final consumer artifact. Its full CTE chain (FLASH through DIFFERENCE_ADJUSTMENT and the final SELECT) was expanded into the consolidated SQL. |

No separate converted SQL files were supplied for the seven upstream calculation views (CV_COMP_FIN_FLASH_STATIC, CV_COMP_FIN_BUDGET_STATIC, CV_COMP_SKF_BUDGET_STATIC, CV_COMP_FORECAST_MJE_STATIC, CV_COMP_FIN_ACTUAL_STATIC, CV_COMP_SKF_ACTUAL_STATIC, CV_COMP_TOPSIDE_ADJUSTMENTS). These remain as terminal BigQuery sources referenced by name. Their `PROJECT.DATASET` placeholders must be replaced with the deployed dataset paths before execution.

### 1.3 Columns_Mapping_v3 Row Count

The full CSV was read. It contains mappings for the following HANA tables (among others): CEPCT, ZTFIGL_RCALWEEK, ZTSRP_COMPFL, ZTSRP_ATTR_ACT, HRRP_NODE, AZSRP_DS041_VT_S4, AZSRP_DS052_VT_S4, AZSRP_DS112_VT_S4, AZSRP_DS072_VT_S4, AZSRP_DS092_VT_S4, AZSRP_DS031_VT_S4, ACDOCA_VT_S4, BKPF, FAGLSKF_PN, FINSC_FISC_DATE. **Approximately 700+ rows were read in full.**

---

## 2. Final Consumer Identification

- **Final consumer artifact:** `CV_COMP_FIN_FLASH_COMBINED_STATIC`
- **Source file:** `9-projections-layer.xml`
- **HANA type:** Calculation View, `dataCategory=CUBE`, `outputViewType=Aggregation`
- **Input parameters:** `IP_WEEK_ENDING_FROM` (STRING), `IP_WEEK_ENDING_TO` (STRING)

---

## 3. Artifact Dependency Mapping

| Lineage Edge | Producer | Consumer | Resulting SQL Location |
|---|---|---|---|
| 1 | CV_COMP_FIN_FLASH_STATIC | 9-projections-layer.xml | CTE 1: FLASH — terminal source `PROJECT.DATASET.CV_COMP_FIN_FLASH_STATIC` |
| 2 | CV_COMP_FIN_BUDGET_STATIC | 9-projections-layer.xml | CTE 2: FS_BUDGET and CTE 7: RX_BUDGET — terminal source `PROJECT.DATASET.CV_COMP_FIN_BUDGET_STATIC` |
| 3 | CV_COMP_SKF_BUDGET_STATIC | 9-projections-layer.xml | CTE 3: SKF_BUDGET — terminal source `PROJECT.DATASET.CV_COMP_SKF_BUDGET_STATIC` |
| 4 | CV_COMP_FORECAST_MJE_STATIC | 9-projections-layer.xml | CTE 4: FORECAST_MJE — terminal source `PROJECT.DATASET.CV_COMP_FORECAST_MJE_STATIC` |
| 5 | CV_COMP_FIN_ACTUAL_STATIC | 9-projections-layer.xml | CTE 5: FIN_LY — terminal source `PROJECT.DATASET.CV_COMP_FIN_ACTUAL_STATIC` |
| 6 | CV_COMP_SKF_ACTUAL_STATIC | 9-projections-layer.xml | CTE 6: SKF_LY — terminal source `PROJECT.DATASET.CV_COMP_SKF_ACTUAL_STATIC` |
| 7 | CV_COMP_TOPSIDE_ADJUSTMENTS | 9-projections-layer.xml | CTE 8: FS_TOPSIDE_ADJ and CTE 9: RX_TOPSIDE_ADJ — terminal source `PROJECT.DATASET.CV_COMP_TOPSIDE_ADJUSTMENTS` |
| 8 | SFN_PRIOR_FISCAL_WEEK | 9-projections-layer.xml | Runtime parameters `@ip_week_ending_from` / `@ip_week_ending_to` (see §9) |

---

## 4. Final-Consumer Flow / CTE Order

The consolidated SQL preserves the exact node sequence from the converted XML:

| Seq | CTE Name | Role |
|---|---|---|
| 1 | FLASH | Flash (transactional sales) source projection |
| 2 | FS_BUDGET | FS financial budget source projection + filter |
| 3 | SKF_BUDGET | SKF budget source projection + filter |
| 4 | FORECAST_MJE | Forecast + MJE source projection |
| 5 | FIN_LY | Last-year financial actuals source projection + filter |
| 6 | SKF_LY | Last-year SKF actuals source projection + filter |
| 7 | RX_BUDGET | RX budget source projection + filter |
| 8 | FS_TOPSIDE_ADJ | FS topside adjustments source projection + filter |
| 9 | RX_TOPSIDE_ADJ | RX topside adjustments source projection + filter |
| 10 | COMBINED | UNION ALL of all nine branches into a common schema |
| 11 | Aggregation_1 | Aggregation of COMBINED by all dimensions |
| 12 | VARIANCES | Variance and comp-level calculated measures |
| 13 | CONV_DRUG | Filter to CONVDRUG segment for ASP allocation |
| 14 | TOTAL_ASP_BASE | Week-level aggregation for total ASP |
| 15 | TOTAL_ASP_CALC | Budget ASP and flash ASP computation |
| 16 | TOTAL_ASP | ASP percentage change computation |
| 17 | STORE_FLASH_BASE | Store-level aggregation for stores without pre-allocated budget |
| 18 | STORE_FLASH | Store-level flash ASP computation |
| 19 | Join_4 | LEFT JOIN STORE_FLASH with TOTAL_ASP on week |
| 20 | ADJUSTED_ASP | Adjusted ASP computation |
| 21 | Join_5 | LEFT JOIN VARIANCES with ADJUSTED_ASP on prctr + week |
| 22 | BUDGET_ALLOCATION | RX budget allocation per store |
| 23 | EXCLUDE_PREALLOCATED | Filter for comp-level budget aggregation |
| 24 | COMP_LEVEL_ALLOCATED_BUDGET | Comp-level budget aggregation |
| 25 | Join_6 | LEFT JOIN BUDGET_ALLOCATION with COMP_LEVEL_ALLOCATED_BUDGET |
| 26 | DIFFERENCE_ADJUSTMENT | Final RX budget and comp RX budget adjustment |
| — | Final SELECT | Logical-model calculated measures + comp variances |

---

## 5. Dependency Expansion and Point-of-Consumption Mapping

Each upstream dependency is expanded at its first point of consumption in the final-consumer flow:

- **CV_COMP_FIN_FLASH_STATIC** → expanded inline as CTE 1 (FLASH), consumed in CTE 10 (COMBINED Branch 1).
- **CV_COMP_FIN_BUDGET_STATIC** → expanded inline as CTE 2 (FS_BUDGET) and CTE 7 (RX_BUDGET), consumed in CTE 10 (COMBINED Branches 2 and 9). The same source is read twice with different filters, matching the original XML.
- **CV_COMP_SKF_BUDGET_STATIC** → expanded inline as CTE 3 (SKF_BUDGET), consumed in CTE 10 (COMBINED Branch 6).
- **CV_COMP_FORECAST_MJE_STATIC** → expanded inline as CTE 4 (FORECAST_MJE), consumed in CTE 10 (COMBINED Branch 3).
- **CV_COMP_FIN_ACTUAL_STATIC** → expanded inline as CTE 5 (FIN_LY), consumed in CTE 10 (COMBINED Branch 4).
- **CV_COMP_SKF_ACTUAL_STATIC** → expanded inline as CTE 6 (SKF_LY), consumed in CTE 10 (COMBINED Branch 5).
- **CV_COMP_TOPSIDE_ADJUSTMENTS** → expanded inline as CTE 8 (FS_TOPSIDE_ADJ, TYPE='FS') and CTE 9 (RX_TOPSIDE_ADJ, TYPE!='FS'), consumed in CTE 10 (COMBINED Branches 7 and 8). The source is referenced twice, matching the XML note "referenced twice in the view".

---

## 6. USED / NOT USED File Classification

| File | Classification | Reason |
|---|---|---|
| 9-projections-layer.xml (CV_COMP_FIN_FLASH_COMBINED_STATIC) | **USED** | Final consumer; all CTEs and the final SELECT are derived from this file. |

No other converted SQL files were supplied. The seven upstream calculation views are terminal sources (no converted SQL supplied for them).

---

## 7. Filter Trace

| Filter | Source CTE | Converted SQL File | Resulting SQL Clause |
|---|---|---|---|
| `_bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to OR @ip_week_ending_from IS NULL OR @ip_week_ending_to IS NULL` | FS_BUDGET | 9-projections-layer.xml | CTE 2 WHERE clause |
| `fs_rx_flag = 'FS'` | FS_BUDGET | 9-projections-layer.xml | CTE 2 WHERE clause |
| `_bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to OR ...` | SKF_BUDGET | 9-projections-layer.xml | CTE 3 WHERE clause |
| `_bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to OR ...` | FIN_LY | 9-projections-layer.xml | CTE 5 WHERE clause |
| `fs_rx_flag IN ('FS','RX')` | FIN_LY | 9-projections-layer.xml | CTE 5 WHERE clause |
| `_bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to OR ...` | SKF_LY | 9-projections-layer.xml | CTE 6 WHERE clause |
| `_bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to OR ...` | RX_BUDGET | 9-projections-layer.xml | CTE 7 WHERE clause |
| `_bic_zwwpc_pa1 = 'RXGENRL'` | RX_BUDGET | 9-projections-layer.xml | CTE 7 WHERE clause |
| `_b631_s_amount != 0` | RX_BUDGET | 9-projections-layer.xml | CTE 7 WHERE clause |
| `type = 'FS'` | FS_TOPSIDE_ADJ | 9-projections-layer.xml | CTE 8 WHERE clause |
| `type != 'FS'` | RX_TOPSIDE_ADJ | 9-projections-layer.xml | CTE 9 WHERE clause |
| `segment IS NULL OR UPPER(segment) = 'CONVDRUG'` | CONV_DRUG | 9-projections-layer.xml | CTE 13 WHERE clause |
| `cal_rx_budget = 0 OR cal_rx_budget IS NULL` | STORE_FLASH_BASE | 9-projections-layer.xml | CTE 17 WHERE clause |
| `budget_comp_flag IS NOT NULL AND (rx_budget = 0 OR rx_budget IS NULL)` | EXCLUDE_PREALLOCATED | 9-projections-layer.xml | CTE 23 WHERE clause |

---

## 8. Join Trace

| Join | Source CTE | Converted SQL File | Resulting SQL Clause |
|---|---|---|---|
| LEFT JOIN STORE_FLASH s, TOTAL_ASP t ON s._bic_zio_sweek = t._bic_zio_sweek | Join_4 | 9-projections-layer.xml | CTE 19 |
| LEFT JOIN VARIANCES v, ADJUSTED_ASP a ON v.prctr = a.prctr AND v._bic_zio_sweek = a._bic_zio_sweek | Join_5 | 9-projections-layer.xml | CTE 21 |
| LEFT JOIN BUDGET_ALLOCATION b, COMP_LEVEL_ALLOCATED_BUDGET c ON b.prctr = c.cal_profit_center AND b._bic_zio_sweek = c._bic_zio_sweek | Join_6 | 9-projections-layer.xml | CTE 25 |

---

## 9. Aggregation Trace

| Aggregation | Source CTE | Grain | Resulting SQL Clause |
|---|---|---|---|
| SUM of all measures, MAX of timestamps | Aggregation_1 | All dimension columns | CTE 11 GROUP BY |
| SUM(cal_rx_budget, skf_budget_qty, cal_rx_sales, cal_scripts_90as3) | TOTAL_ASP_BASE | mandt, _bic_zio_sweek | CTE 14 GROUP BY |
| SUM(cal_rx_sales, cal_scripts_90as3, cal_rx_budget) | STORE_FLASH_BASE | mandt, _bic_zio_sweek, prctr | CTE 17 GROUP BY |
| SUM(cal_rx_budget_comp_level, rx_budget) | COMP_LEVEL_ALLOCATED_BUDGET | budget_comp_flag, _bic_zio_sweek | CTE 24 GROUP BY |

---

## 10. UNION Branch Trace

All nine UNION ALL branches in CTE 10 (COMBINED) are preserved exactly as in the converted SQL:

| Branch | Source CTE | cal_data_category1 | cal_data_category2 | sales_source |
|---|---|---|---|---|
| 1 | FLASH | FLASH | FLASH | Transactional Sales |
| 2 | FS_BUDGET | FIN | FS_BUD | Transactional Sales |
| 3 | FORECAST_MJE | (from source) | (from source) | (from source cal_source) |
| 4 | FIN_LY | FIN | FIN_LY | Transactional Sales |
| 5 | SKF_LY | SKF | SKF_LY | Transactional Sales |
| 6 | SKF_BUDGET | SKF | SKF_BUD | Transactional Sales |
| 7 | FS_TOPSIDE_ADJ | FS_TOPSIDE | FS_TOPSIDE | Topside Adjustments |
| 8 | RX_TOPSIDE_ADJ | RX_TOPSIDE | RX_TOPSIDE | Topside Adjustments |
| 9 | RX_BUDGET | FIN | RX_BUD | Transactional Sales |

---

## 11. Parameter Documentation

| Parameter | Type | Source | Usage | Reason Unresolved |
|---|---|---|---|---|
| `@ip_week_ending_from` | STRING | HANA input parameter IP_WEEK_ENDING_FROM, originally derived from SFN_PRIOR_FISCAL_WEEK | Used in BETWEEN filter for _bic_zio_sweek in CTEs 2, 3, 5, 6, 7 | SFN_PRIOR_FISCAL_WEEK is a HANA scalar function not supplied in the converted files. Its output must be provided at runtime. |
| `@ip_week_ending_to` | STRING | HANA input parameter IP_WEEK_ENDING_TO, originally derived from SFN_PRIOR_FISCAL_WEEK | Used in BETWEEN filter for _bic_zio_sweek in CTEs 2, 3, 5, 6, 7 | Same as above. |

**Note:** The BETWEEN filter is conditional — when either parameter is NULL, the filter is bypassed (matching the original HANA logic).

---

## 12. Alias Check

### Physical Column Aliases Applied

All physical column names from the upstream calculation views are used as-is in their respective CTEs (lowercase BigQuery style). The following meaningful renames are applied per the converted SQL logic:

| CTE | HANA/Source Column | BigQuery Alias | Reason |
|---|---|---|---|
| FLASH | TRANSCURRENCY | flash_transcurrency | Disambiguates from other currency columns in UNION |
| FS_BUDGET | COMP_FLAG | budget_comp_flag | Semantic rename per converted SQL |
| FS_BUDGET | CURRENCY | fs_budget_currency | Disambiguates currency type |
| FORECAST_MJE | PRCTR | _b631_s_proftctr | Semantic rename per converted SQL |
| FORECAST_MJE | FIN_FCST_AMOUNT | _b631_s_amount | Semantic rename per converted SQL |
| FORECAST_MJE | FIN_FORECAST_CURRENCY | forecast_currency | Disambiguates currency type |
| FIN_LY | CURRENCY | fin_ly_currency | Disambiguates currency type |
| RX_BUDGET | COMP_FLAG | budget_comp_flag | Semantic rename per converted SQL |
| FS_TOPSIDE_ADJ | PROFIT_CENTER_DESCR | profit_center_text | Aligns with other branches |
| RX_TOPSIDE_ADJ | PROFIT_CENTER_DESCR | profit_center_text | Aligns with other branches |
| VARIANCES | cal_scripts_90as3 (pre-MJE) | cal_scripts_90as3_car | Preserves pre-MJE value per converted SQL |

All redundant HANA-name aliases (e.g., `` `MANDT` AS `MANDT` ``) have been removed. Only meaningful renames are retained.

---

## 13. Column Mapping Applied

### Terminal Physical Sources and Their BQ_FULL_TABLE Values

The seven upstream calculation views are referenced as terminal sources. Their `PROJECT.DATASET` placeholders must be replaced with the actual deployed BigQuery paths. No rows in `Columns_Mapping_v3` directly map these calculation view names (they are intermediate HANA artifacts, not raw physical tables). The CSV maps the underlying physical tables (e.g., AZSRP_DS041_VT_S4, AZSRP_DS052_VT_S4, AZSRP_DS112_VT_S4, etc.) that feed those calculation views.

**Finding:** The columns used in the consolidated SQL (e.g., `mandt`, `prctr`, `zzweek`, `_bic_zio_sweek`, `_b631_s_amount`, `_b631_s_proftctr`, `_bic_zio_skfq`, etc.) match the `BQ_COLUMN` values in `Columns_Mapping_v3` for the underlying physical tables. The calculation view column names in the converted SQL already use the BigQuery-style names (lowercase, no leading underscores for the output aliases). All column names in the consolidated SQL are in BigQuery style.

### Data Type Observations

- `zrwstrtdate` and `zrwenddate`: mapped as DATE in `Columns_Mapping_v3` (ZTSRP_ATTR_ACT). The converted SQL applies `SAFE_CAST(... AS DATE)` in `FORMAT_DATE` expressions — preserved as-is.
- `fs_open_dat`, `rx_open_dat`: mapped as DATE in `Columns_Mapping_v3` (ZTSRP_ATTR_ACT) — used as-is (no cast needed in comparisons).
- All `_bic_zio_sweek` comparisons use STRING type (NUMC → STRING per CSV) and `@ip_week_ending_from` / `@ip_week_ending_to` are declared STRING — types match.
- `_b631_s_amount`, `_bic_zio_skfq`: mapped as NUMERIC and FLOAT64 respectively — used in arithmetic expressions as-is.

---

## 14. CTE Documentation Comment Validation

All 26 CTEs and the final SELECT have standardized comment headers with:
- Sequential CTE number
- CTE name
- Logic description
- Source (where applicable)
- Filters (where applicable)
- Join (where applicable)
- Aggregation (where applicable)
- Calculation (where applicable)

No extra CTEs were created solely for documentation purposes.

---

## 15. Star Projection Validation

- CTE 12 (VARIANCES) uses `a.* EXCEPT (cal_scripts_90as3)` — valid because the input schema of Aggregation_1 is deterministically known, no duplicate columns are introduced, and the EXCEPT clause removes exactly the one column that is recalculated.
- CTE 15 (TOTAL_ASP_CALC), CTE 16 (TOTAL_ASP), CTE 18 (STORE_FLASH), CTE 20 (ADJUSTED_ASP) use `*` — valid because each builds on a single input CTE with a known schema and adds new calculated columns.
- CTE 22 (BUDGET_ALLOCATION) uses `j.* EXCEPT (cal_rx_budget)` — valid for the same reason.
- CTE 26 (DIFFERENCE_ADJUSTMENT) uses `j.*` — valid.
- Final SELECT uses `d.*` — valid.

---

## 16. Procedure / ETL Handling

No stored procedures, INSERT-SELECT, or MERGE statements are involved. The final consumer is a pure Calculation View (SELECT-based). No procedural semantics need to be represented.

---

## 17. Conflicts and Validation Findings

### Non-Blocking Findings

1. **SFN_PRIOR_FISCAL_WEEK unresolved:** The HANA scalar function `SFN_PRIOR_FISCAL_WEEK` is not supplied in the converted files. Its two output values are replaced by runtime parameters `@ip_week_ending_from` and `@ip_week_ending_to`. The filter logic is fully preserved. **Non-blocking.**

2. **Upstream calculation view SQL not supplied:** No converted SQL was supplied for the seven upstream calculation views (CV_COMP_FIN_FLASH_STATIC, CV_COMP_FIN_BUDGET_STATIC, CV_COMP_SKF_BUDGET_STATIC, CV_COMP_FORECAST_MJE_STATIC, CV_COMP_FIN_ACTUAL_STATIC, CV_COMP_SKF_ACTUAL_STATIC, CV_COMP_TOPSIDE_ADJUSTMENTS). These are retained as terminal BigQuery sources with `PROJECT.DATASET` placeholders. **Non-blocking — deployment action required.**

3. **`PROJECT.DATASET` placeholders:** All seven terminal sources use `PROJECT.DATASET.*` placeholders. These must be replaced with the actual deployed BigQuery dataset paths before execution. **Non-blocking — deployment action required.**

4. **`Aggregation_1` references `FIN_FORECAST_CURRENCY` column:** The converted SQL groups by `FIN_FORECAST_CURRENCY` in Aggregation_1 but the COMBINED CTE outputs this column as `forecast_currency`. The consolidated SQL uses `forecast_currency` consistently throughout, which is the correct BigQuery-style name. **Corrected.**

5. **`SAFE_CAST` in FORMAT_DATE:** The original converted SQL uses `SAFE_CAST(ZRWSTRTDATE AS DATE)` and `SAFE_CAST(ZRWENDDATE AS DATE)` in the final SELECT. These are preserved as-is. If the source date strings are guaranteed valid, `CAST` could be used instead, but `SAFE_CAST` is retained to match the converted SQL. **Non-blocking.**

---

## 18. ISSUES TO FIX

The following items require action before production deployment:

### ISSUE 1 — Terminal Source Placeholders (Deployment Required)
**Affected:** All seven terminal source CTEs (FLASH, FS_BUDGET, SKF_BUDGET, FORECAST_MJE, FIN_LY, SKF_LY, RX_BUDGET, FS_TOPSIDE_ADJ, RX_TOPSIDE_ADJ)  
**Evidence:** Converted SQL uses `PROJECT.DATASET.*` placeholders  
**Impact:** Query will not execute until placeholders are replaced  
**Resolution:** Replace `PROJECT.DATASET.CV_COMP_FIN_FLASH_STATIC`, `PROJECT.DATASET.CV_COMP_FIN_BUDGET_STATIC`, `PROJECT.DATASET.CV_COMP_SKF_BUDGET_STATIC`, `PROJECT.DATASET.CV_COMP_FORECAST_MJE_STATIC`, `PROJECT.DATASET.CV_COMP_FIN_ACTUAL_STATIC`, `PROJECT.DATASET.CV_COMP_SKF_ACTUAL_STATIC`, and `PROJECT.DATASET.CV_COMP_TOPSIDE_ADJUSTMENTS` with the actual deployed BigQuery full table paths.

### ISSUE 2 — Runtime Parameters Required (Deployment Required)
**Affected:** `@ip_week_ending_from`, `@ip_week_ending_to`  
**Evidence:** HANA function SFN_PRIOR_FISCAL_WEEK not supplied; parameters replace it  
**Impact:** Query requires these parameters to be supplied at runtime  
**Resolution:** Supply both STRING parameters at query execution time. When both are NULL, the week filter is bypassed (all weeks returned). Implement SFN_PRIOR_FISCAL_WEEK as a BigQuery UDF or procedure if automatic derivation is required.

### ISSUE 3 — Upstream Calculation View Logic Not Validated
**Affected:** All seven upstream calculation views  
**Evidence:** No converted SQL supplied for these views  
**Impact:** The business logic within each upstream view (filters, joins, calculations applied before data reaches this layer) is not validated in this consolidation  
**Resolution:** Supply the converted BigQuery SQL for each upstream calculation view to enable full end-to-end consolidation and validation.

### ISSUE 4 — Source Date/Timestamp Format Validation Required
**Affected:** `zrwstrtdate`, `zrwenddate` in the final SELECT FORMAT_DATE expressions  
**Evidence:** SAFE_CAST used; source format not confirmed  
**Impact:** If source strings are not valid DATE format, SAFE_CAST returns NULL and FORMAT_DATE returns NULL  
**Resolution:** Validate source date string formats in the upstream calculation views before production deployment.

---

## 19. Final Quality Gate Results

| Check | Result |
|---|---|
| Final consumer unambiguous | ✅ CV_COMP_FIN_FLASH_COMBINED_STATIC |
| Artifact dependencies match lineage table | ✅ All 8 lineage edges accounted for |
| Final-consumer transformation order preserved | ✅ 26 CTEs in exact XML node order |
| Dependencies expanded at point of consumption | ✅ Each upstream view expanded at its COMBINED branch |
| No generic Source→Intermediate→Target ordering | ✅ |
| Every file classified USED/NOT USED | ✅ |
| Every USED file participates in dependency chain | ✅ |
| All converted dependencies expanded | ✅ (upstream views retained as terminal — no SQL supplied) |
| Only terminal sources remain | ✅ |
| Every physical source uses BQ_FULL_TABLE name | ⚠️ PROJECT.DATASET placeholders — see ISSUE 1 |
| Every referenced physical column mapped | ⚠️ Upstream view columns not directly in CSV — see ISSUE 3 |
| All comparisons type-safe | ✅ STRING parameters vs STRING columns; NUMERIC measures |
| Final-consumer CTE names preserved | ✅ |
| Compatible steps combined | ✅ No unnecessary CTE splits |
| No HANA node becomes a separate CTE | ✅ |
| Every helper CTE justified by semantic boundary | ✅ |
| Every CTE matches output contract | ✅ |
| No duplicate alias within any SELECT | ✅ |
| Star projections valid | ✅ |
| Filters, joins, calculations, parameters preserved | ✅ |
| Aggregation grain preserved | ✅ |
| UNION behavior preserved | ✅ All 9 branches |
| No conflict silently corrected | ✅ All corrections documented |
| No procedural behavior discarded | ✅ No procedures involved |
| Runtime parameters documented | ✅ |
| Single query, no DECLARE/SET | ✅ |
| Every CTE has standardized comment header | ✅ |
| 100% logic match | ✅ Subject to ISSUES 1–4 above |

**This SQL is not production-ready until ISSUES 1–4 are resolved.**
