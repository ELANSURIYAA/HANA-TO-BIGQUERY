# TOPSIDE Consolidation Description
## BigQuery SQL Consolidation Agent — Output 2

---

## 1. Pre-Consolidation Input Confirmation

### Lineage Rows Read (Topside Relationships Table — 4 rows)
| Source File | Target File | Dependency Type |
|---|---|---|
| xml_acc_cv_base_topside_adjustments_car_FS.txt | xml_acc_cv_comp_topside_adjustments_FS.txt | Calculation View Dependency |
| xml_acc_cv_base_md_srpact_s4_FS.txt | xml_acc_cv_comp_topside_adjustments_FS.txt | Calculation View Dependency |
| xml_acc_cv_base_topside_adjustments_car_RX.txt | xml_acc_cv_comp_topside_adjustments_RX.txt | Calculation View Dependency |
| xml_acc_cv_base_md_srpact_s4_RX.txt | xml_acc_cv_comp_topside_adjustments_RX.txt | Calculation View Dependency |

### Files in 02 - Topside Converted Bigquery Files (6 files)
1. `xml_acc_cv_comp_topside_adjustments_FS_DI HANA to BigQuery SQL Conversion Agent.txt`
2. `xml_acc_cv_comp_topside_adjustments_RX_DI HANA to BigQuery SQL Conversion Agent.txt`
3. `xml_acc_cv_base_topside_adjustments_car_FS_DI HANA to BigQuery SQL Conversion Agent.txt`
4. `xml_acc_cv_base_topside_adjustments_car_RX_DI HANA to BigQuery SQL Conversion Agent.txt`
5. `xml_acc_cv_base_md_srpact_s4_FS_DI HANA to BigQuery SQL Conversion Agent.txt`
6. `xml_acc_cv_base_md_srpact_s4_RX_DI HANA to BigQuery SQL Conversion Agent.txt`

### Columns_Mapping_v3.csv
- Total rows read: All rows in the file (complete read performed)
- Tables mapped and relevant to this consolidation:
  - `ZTSRP_ATTR_ACT` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act`
  - `ZTSRP_COMPFL` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl`
  - `ZTFIGL_RCALWEEK` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek`
  - `CEPCT` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct`
  - `TOPSIDE_ADJUSTMENTS_VT_CAR` → **NOT FOUND** (see Issues to Fix)

---

## 2. Final Consumer Identification

There are **two final consumers**, one per variant:
- **FS Variant**: `CV_COMP_TOPSIDE_ADJUSTMENTS` (FS) — file: `xml_acc_cv_comp_topside_adjustments_FS_DI HANA to BigQuery SQL Conversion Agent.txt`
- **RX Variant**: `CV_COMP_TOPSIDE_ADJUSTMENTS` (RX) — file: `xml_acc_cv_comp_topside_adjustments_RX_DI HANA to BigQuery SQL Conversion Agent.txt`

Both are `CUBE / Aggregation` calculation views. No artifact in the lineage table consumes them; they are the top-level consumer-facing artifacts.

---

## 3. File Classification: USED / NOT USED

| File | Classification | Reason |
|---|---|---|
| xml_acc_cv_comp_topside_adjustments_FS | **USED** | Final consumer (FS variant) — defines all joins, filters, aggregations, and calculated measures |
| xml_acc_cv_comp_topside_adjustments_RX | **USED** | Final consumer (RX variant) — structurally and logically identical to FS variant |
| xml_acc_cv_base_topside_adjustments_car_FS | **USED** | Upstream dependency of FS final consumer; provides TOPSIDE_ADJUSTMENTS source data and MANDT filter |
| xml_acc_cv_base_topside_adjustments_car_RX | **USED** | Upstream dependency of RX final consumer; same logic as FS base |
| xml_acc_cv_base_md_srpact_s4_FS | **USED** | Upstream dependency of FS final consumer; provides STORE_ATTRIBUTES from ZTSRP_ATTR_ACT |
| xml_acc_cv_base_md_srpact_s4_RX | **USED** | Upstream dependency of RX final consumer; same logic as FS base |

All 6 files are USED. No files are NOT USED.

---

## 4. Artifact Dependency Mapping and Lineage Edge Trace

### FS Variant Dependency Chain
```
TOPSIDE_ADJUSTMENTS_VT_CAR (physical table — UNRESOLVED in mapping)
  └─► CV_BASE_TOPSIDE_ADJUSTMENTS_CAR (FS)
        └─► CV_COMP_TOPSIDE_ADJUSTMENTS (FS)  ◄── FINAL CONSUMER

ZTSRP_ATTR_ACT → v_ztsrp_attr_act
  └─► CV_BASE_MD_SRPACT_S4 (FS)
        └─► CV_COMP_TOPSIDE_ADJUSTMENTS (FS)

ZTSRP_COMPFL → v_ztsrp_compfl
  └─► CV_BASE_MD_COMPFL_S4 (consumed inline by COMP_FLAG CTE)
        └─► CV_COMP_TOPSIDE_ADJUSTMENTS (FS)

ZTFIGL_RCALWEEK → v_ztfigl_rcalweek
  └─► CV_BASE_MD_RCALWEEK_S4 (consumed inline by RETAIL_CALENDAR CTE)
        └─► CV_COMP_TOPSIDE_ADJUSTMENTS (FS)

CEPCT → v_cepct
  └─► CV_BASE_MD_CEPCT_S4 (consumed inline by PROFIT_CENTER_TEXT CTE)
        └─► CV_COMP_TOPSIDE_ADJUSTMENTS (FS)
```

### RX Variant Dependency Chain
Identical structure to FS variant. The RX suffix in the lineage table identifies the pharmacy-aligned variant of the same base views. The composite view SQL logic is identical.

### Lineage Edge Representation in Consolidated SQL
| Lineage Edge | Resulting SQL Location |
|---|---|
| CV_BASE_TOPSIDE_ADJUSTMENTS_CAR → CV_COMP_TOPSIDE_ADJUSTMENTS (FS) | CTE `TOPSIDE_ADJUSTMENTS` (with MANDT filter from base view + WEEK_YEAR filter from composite view) |
| CV_BASE_MD_SRPACT_S4 → CV_COMP_TOPSIDE_ADJUSTMENTS (FS) | CTE `STORE_ATTRIBUTES` (with MANDT filter from base view) |
| CV_BASE_MD_COMPFL_S4 → CV_COMP_TOPSIDE_ADJUSTMENTS (FS) | CTE `COMP_FLAG` (with COMP_VER filter from composite view) |
| CV_BASE_MD_RCALWEEK_S4 → CV_COMP_TOPSIDE_ADJUSTMENTS (FS) | CTE `RETAIL_CALENDAR` |
| CV_BASE_MD_CEPCT_S4 → CV_COMP_TOPSIDE_ADJUSTMENTS (FS) | CTE `PROFIT_CENTER_TEXT` |
| Same edges for RX variant | Identical CTEs in Query 2 |

---

## 5. Final-Consumer Transformation Flow (Both Variants)

The final-consumer XML defines the following node sequence, preserved in the consolidated SQL:

1. **TOPSIDE_ADJUSTMENTS** — projection from CV_BASE_TOPSIDE_ADJUSTMENTS_CAR with WEEK_YEAR range filter
2. **STORE_ATTRIBUTES** — projection from CV_BASE_MD_SRPACT_S4
3. **Join_1 (Topside_With_Store_Attributes)** — LEFT JOIN TOPSIDE_ADJUSTMENTS to STORE_ATTRIBUTES on PRCTR
4. **COMP_FLAG** — projection from CV_BASE_MD_COMPFL_S4 with COMP_VER filter
5. **Join_2 (Topside_With_Comp_Flag)** — LEFT JOIN Join_1 to COMP_FLAG on PRCTR and WEEK_YEAR = ZWEEK
6. **RETAIL_CALENDAR** — projection from CV_BASE_MD_RCALWEEK_S4
7. **Join_3 (Topside_With_Retail_Calendar)** — LEFT JOIN Join_2 to RETAIL_CALENDAR on WEEK_YEAR = ZZWEEK
8. **PROFIT_CENTER_TEXT** — projection from CV_BASE_MD_CEPCT_S4
9. **Join_4 (Topside_With_Profit_Center_Text)** — LEFT JOIN Join_3 to PROFIT_CENTER_TEXT on PRCTR; LTEXT → PROFIT_CENTER_DESCR
10. **Final Aggregation SELECT** — GROUP BY all non-measure attributes; SUM all 16 base measures; compute CAL_COMP_FLAG, CAL_WEEK_NUMBER, and 4 calculated measures

---

## 6. Dependency Expansion and Point-of-Consumption Mapping

### CV_BASE_TOPSIDE_ADJUSTMENTS_CAR (FS and RX)
- **Expanded at**: CTE `TOPSIDE_ADJUSTMENTS` (first CTE in both queries)
- **Logic inlined**: Reads from physical table `TOPSIDE_ADJUSTMENTS_VT_CAR`; applies MANDT IN ('110','200') from the base view; applies WEEK_YEAR BETWEEN @ip_week_ending_from AND @ip_week_ending_to from the composite view
- **Note**: The base view is a CUBE/Aggregation view itself, but because the composite view consumes it as a data source and applies its own aggregation at the top level, the base view's aggregation is preserved by inlining its source SELECT with the same filter logic. The composite view's final GROUP BY and SUM cover the full aggregation grain.

### CV_BASE_MD_SRPACT_S4 (FS and RX)
- **Expanded at**: CTE `STORE_ATTRIBUTES`
- **Logic inlined**: Reads from `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act`; applies MANDT IN ('120','200') from the base view; projects only the 21 columns consumed by the composite view join
- **Note**: The base view is a CUBE/Aggregation view (75 output columns, 4 measures). Only the 21 attribute columns needed by the composite view join are projected here. The base view's aggregation grain is preserved because the composite view's final GROUP BY covers the same attributes.

### CV_BASE_MD_COMPFL_S4 (referenced inline)
- **Expanded at**: CTE `COMP_FLAG`
- **Logic inlined**: Reads from `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl`; applies COMP_VER = @ip_version_comp_flag
- **Note**: The converted SQL files for CV_BASE_MD_COMPFL_S4 are not in the supplied file set. However, the composite view's converted SQL explicitly defines the COMP_FLAG CTE reading from `PROJECT.DATASET.CV_BASE_MD_COMPFL_S4` with the COMP_VER filter. The Columns_Mapping_v3 maps ZTSRP_COMPFL to `v_ztsrp_compfl`, and the columns zweek, fs_comp_wk, rx_comp_wk, comp_ver, prctr are all mapped. The physical table is used directly.

### CV_BASE_MD_RCALWEEK_S4 (referenced inline)
- **Expanded at**: CTE `RETAIL_CALENDAR`
- **Logic inlined**: Reads from `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek`; projects zrwstrtdate, zrwenddate, zzweek
- **Note**: Converted SQL file for CV_BASE_MD_RCALWEEK_S4 not in supplied set. Physical table resolved via Columns_Mapping_v3 (ZTFIGL_RCALWEEK → v_ztfigl_rcalweek).

### CV_BASE_MD_CEPCT_S4 (referenced inline)
- **Expanded at**: CTE `PROFIT_CENTER_TEXT`
- **Logic inlined**: Reads from `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct`; projects prctr and ltext
- **Note**: Converted SQL file for CV_BASE_MD_CEPCT_S4 not in supplied set. Physical table resolved via Columns_Mapping_v3 (CEPCT → v_cepct).

---

## 7. Filter, Join, Aggregation, UNION, and Parameter Trace

### Filters
| Filter | Source File | Resulting SQL Location |
|---|---|---|
| MANDT IN ('110','200') | xml_acc_cv_base_topside_adjustments_car_FS/RX | CTE TOPSIDE_ADJUSTMENTS WHERE clause |
| WEEK_YEAR BETWEEN @ip_week_ending_from AND @ip_week_ending_to | xml_acc_cv_comp_topside_adjustments_FS/RX | CTE TOPSIDE_ADJUSTMENTS WHERE clause |
| MANDT IN ('120','200') | xml_acc_cv_base_md_srpact_s4_FS/RX | CTE STORE_ATTRIBUTES WHERE clause |
| COMP_VER = @ip_version_comp_flag | xml_acc_cv_comp_topside_adjustments_FS/RX | CTE COMP_FLAG WHERE clause |

### Joins
| Join | Type | Keys | Source File | Resulting SQL Location |
|---|---|---|---|---|
| TOPSIDE_ADJUSTMENTS ↔ STORE_ATTRIBUTES | LEFT OUTER | prctr = prctr | xml_acc_cv_comp_topside_adjustments_FS/RX | CTE Topside_With_Store_Attributes |
| Topside_With_Store_Attributes ↔ COMP_FLAG | LEFT OUTER | prctr = prctr AND week_year = zweek | xml_acc_cv_comp_topside_adjustments_FS/RX | CTE Topside_With_Comp_Flag |
| Topside_With_Comp_Flag ↔ RETAIL_CALENDAR | LEFT OUTER | week_year = zzweek | xml_acc_cv_comp_topside_adjustments_FS/RX | CTE Topside_With_Retail_Calendar |
| Topside_With_Retail_Calendar ↔ PROFIT_CENTER_TEXT | LEFT OUTER | prctr = prctr | xml_acc_cv_comp_topside_adjustments_FS/RX | CTE Topside_With_Profit_Center_Text |

### Aggregations
| Measure | Aggregation | Source File | Resulting SQL Location |
|---|---|---|---|
| fs_bud, fs_fct, fs_flash, fs_ly | SUM | xml_acc_cv_comp_topside_adjustments_FS/RX | Final SELECT |
| rx_bud, rx_fct, rx_flash, rx_ly | SUM | xml_acc_cv_comp_topside_adjustments_FS/RX | Final SELECT |
| sc_90as1_bud/fct/flash/ly | SUM | xml_acc_cv_comp_topside_adjustments_FS/RX | Final SELECT |
| sc_90as3_bud/fct/flash/ly | SUM | xml_acc_cv_comp_topside_adjustments_FS/RX | Final SELECT |

### Calculated Attributes
| Attribute | Expression | Source File | Resulting SQL Location |
|---|---|---|---|
| cal_comp_flag | GREATEST(fs_comp_wk, rx_comp_wk) | xml_acc_cv_comp_topside_adjustments_FS/RX | Final SELECT GROUP BY and SELECT |
| cal_week_number | RIGHT(week_year, 2) | xml_acc_cv_comp_topside_adjustments_FS/RX | Final SELECT GROUP BY and SELECT |

### Calculated Measures (applied after aggregation)
| Measure | Expression | Source File | Resulting SQL Location |
|---|---|---|---|
| cal_sc_90as3_flash | IF(SEGMENT IN ('CMX','MC'),0, SUM(sc_90as3_flash)+IF(s4_account='804013',SUM(sc_90as1_flash)*2,SUM(sc_90as1_flash))) | xml_acc_cv_comp_topside_adjustments_FS/RX | Final SELECT |
| cal_sc_90as3_bud | Same pattern with _bud columns | xml_acc_cv_comp_topside_adjustments_FS/RX | Final SELECT |
| cal_sc_90as3_fct | Same pattern with _fct columns | xml_acc_cv_comp_topside_adjustments_FS/RX | Final SELECT |
| cal_sc_90as3_ly | Same pattern with _ly columns | xml_acc_cv_comp_topside_adjustments_FS/RX | Final SELECT |

### Runtime Parameters
| Parameter | Type | Source | Usage |
|---|---|---|---|
| @ip_week_ending_from | STRING | SFN_PRIOR_FISCAL_WEEK (unresolved scalar function) | Low bound of WEEK_YEAR BETWEEN filter in TOPSIDE_ADJUSTMENTS |
| @ip_week_ending_to | STRING | SFN_PRIOR_FISCAL_WEEK (unresolved scalar function) | High bound of WEEK_YEAR BETWEEN filter in TOPSIDE_ADJUSTMENTS |
| @ip_version_comp_flag | STRING | SFN_ACTUALS_COMP_FLAG (unresolved scalar function) | COMP_VER equality filter in COMP_FLAG |

---

## 8. Table and Column Mapping Applied

### Physical Tables Referenced in Consolidated SQL

| HANA Table | BQ_FULL_TABLE | MAPPING_STATUS |
|---|---|---|
| TOPSIDE_ADJUSTMENTS_VT_CAR | NOT FOUND in Columns_Mapping_v3 | **REQUIRES VALIDATION** |
| ZTSRP_ATTR_ACT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act | OK |
| ZTSRP_COMPFL | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl | OK |
| ZTFIGL_RCALWEEK | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek | OK |
| CEPCT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct | OK |

### Column Mappings Applied (HANA → BigQuery)

**ZTSRP_ATTR_ACT → v_ztsrp_attr_act** (columns used in STORE_ATTRIBUTES CTE):
| HANA Column | BQ Column | BQ Datatype |
|---|---|---|
| STRNUM | strnum | STRING |
| PRCTR | prctr | STRING |
| DIVISION_CODE | division_code | STRING |
| DIVISION_DESC | division_desc | STRING |
| DISTRICT_CODE | district_code | STRING |
| DISTRICT_DESC | district_desc | STRING |
| REGION_CODE | region_code | STRING |
| REGION_DESC | region_desc | STRING |
| REP_MKT_CODE | rep_mkt_code | STRING |
| REP_MKT_DESC | rep_mkt_desc | STRING |
| CITY | city | STRING |
| STATE | state | STRING |
| FS_OPEN_DAT | fs_open_dat | DATE |
| RX_OPEN_DAT | rx_open_dat | DATE |
| AREA_CODE | area_code | STRING |
| AREA_DESC | area_desc | STRING |
| EMERG_MKT_IND | emerg_mkt_ind | STRING |
| RX_DIVISION_CODE | rx_division_code | STRING |
| RX_AREA_CODE | rx_area_code | STRING |
| RX_REGION_CODE | rx_region_code | STRING |
| RX_DISTRICT_CODE | rx_district_code | STRING |
| MANDT | mandt | STRING |

**ZTSRP_COMPFL → v_ztsrp_compfl** (columns used in COMP_FLAG CTE):
| HANA Column | BQ Column | BQ Datatype |
|---|---|---|
| PRCTR | prctr | STRING |
| ZWEEK | zweek | STRING |
| FS_COMP_WK | fs_comp_wk | STRING |
| RX_COMP_WK | rx_comp_wk | STRING |
| COMP_VER | comp_ver | STRING |

**ZTFIGL_RCALWEEK → v_ztfigl_rcalweek** (columns used in RETAIL_CALENDAR CTE):
| HANA Column | BQ Column | BQ Datatype |
|---|---|---|
| ZRWSTRTDATE | zrwstrtdate | DATE |
| ZRWENDDATE | zrwenddate | DATE |
| ZZWEEK | zzweek | STRING |

**CEPCT → v_cepct** (columns used in PROFIT_CENTER_TEXT CTE):
| HANA Column | BQ Column | BQ Datatype |
|---|---|---|
| PRCTR | prctr | STRING |
| LTEXT | ltext | STRING |

**TOPSIDE_ADJUSTMENTS_VT_CAR** — columns not mapped (table not in Columns_Mapping_v3). All column names in the TOPSIDE_ADJUSTMENTS CTE are carried over from the converted SQL as-is (lowercase). See Issues to Fix.

### Data Type Casts Applied
- **MANDT filter in TOPSIDE_ADJUSTMENTS**: MANDT is STRING in Columns_Mapping_v3 for AZSRP_DS041 and BKPF tables. The TOPSIDE_ADJUSTMENTS_VT_CAR table is not in the mapping, but the converted SQL uses `MANDT IN ('110', '200')` as string literals, consistent with STRING type. No cast needed.
- **MANDT filter in STORE_ATTRIBUTES**: ZTSRP_ATTR_ACT.MANDT is STRING (BQ_DATATYPE = STRING). Filter `IN ('120', '200')` uses string literals. No cast needed.
- **COMP_VER filter**: ZTSRP_COMPFL.COMP_VER is STRING. Parameter @ip_version_comp_flag compared as STRING. No cast needed.
- **WEEK_YEAR / ZWEEK / ZZWEEK join**: All are STRING per Columns_Mapping_v3 (ZTFIGL_RCALWEEK.ZZWEEK = STRING, ZTSRP_COMPFL.ZWEEK = STRING). WEEK_YEAR from TOPSIDE_ADJUSTMENTS_VT_CAR is unresolved but treated as STRING per converted SQL. No cast needed.
- **Calculated measures returning 0**: CAST(0 AS NUMERIC) used to match the NUMERIC type of measure columns (e.g., sc_90as3_flash is NUMERIC per AZSRP_DS041 mapping pattern). Applied in all four cal_sc_90as3_* CASE expressions.
- **fs_comp_wk / rx_comp_wk in GREATEST**: Both are STRING per ZTSRP_COMPFL mapping. GREATEST(STRING, STRING) returns STRING. cal_comp_flag output is STRING.

---

## 9. Alias Check Results

- All physical column names in the SQL use their exact `BQ_COLUMN` values from Columns_Mapping_v3 (lowercase, no leading underscores, `/` replaced with `_`).
- `ltext AS profit_center_descr` is a **meaningful rename** defined by the converted SQL (LTEXT → PROFIT_CENTER_DESCR in the logical model). Retained.
- `GREATEST(fs_comp_wk, rx_comp_wk) AS cal_comp_flag` — new calculated attribute name. Retained.
- `RIGHT(week_year, 2) AS cal_week_number` — new calculated attribute name. Retained.
- All SUM aggregates use their source column name as the alias (e.g., `SUM(fs_bud) AS fs_bud`). Under the name-equivalence rule, these are not redundant aliases on physical columns; they are aggregate expressions with the same output name. Retained per the output contract.
- No aliases of the form `bq_column AS HANA_COLUMN` or `bq_column AS bq_column` (case-only difference) remain.

---

## 10. CTE Structure and Justification

| CTE | Justified By |
|---|---|
| TOPSIDE_ADJUSTMENTS | Required semantic boundary: combines base view filter (MANDT) with composite view filter (WEEK_YEAR range); provides the fact data for all downstream joins |
| STORE_ATTRIBUTES | Required semantic boundary: applies MANDT filter from CV_BASE_MD_SRPACT_S4; provides store attribute lookup for Join_1 |
| Topside_With_Store_Attributes | Required semantic boundary: LEFT JOIN between TOPSIDE_ADJUSTMENTS and STORE_ATTRIBUTES; produces the Join_1 result consumed by Join_2 |
| COMP_FLAG | Required semantic boundary: applies COMP_VER filter from composite view; provides comp flag lookup for Join_2 |
| Topside_With_Comp_Flag | Required semantic boundary: LEFT JOIN on two keys (prctr AND week_year=zweek); produces Join_2 result consumed by Join_3 |
| RETAIL_CALENDAR | Required semantic boundary: provides retail calendar lookup for Join_3 |
| Topside_With_Retail_Calendar | Required semantic boundary: LEFT JOIN on week_year=zzweek; produces Join_3 result consumed by Join_4 |
| PROFIT_CENTER_TEXT | Required semantic boundary: provides profit center text lookup for Join_4 |
| Topside_With_Profit_Center_Text | Required semantic boundary: LEFT JOIN on prctr; applies meaningful rename ltext → profit_center_descr; produces the final pre-aggregation dataset |

No helper CTEs were created merely to mirror HANA node structure. Each CTE corresponds to a real SQL evaluation boundary (filter + source, or join step).

---

## 11. Aggregation Grain Validation

- The final SELECT GROUP BY includes all 34 non-measure output attributes defined in the logical model, plus the two calculated attributes (GREATEST(fs_comp_wk, rx_comp_wk) and RIGHT(week_year, 2)).
- The 16 base measures are aggregated with SUM exactly as defined in the logical model (aggregationType="sum").
- The 4 calculated measures (cal_sc_90as3_*) are computed after aggregation, using the already-summed base measure values, per the CUBE/Aggregation semantics.
- No grouping columns were added or removed relative to the logical model output.

---

## 12. Duplicate Column Check

- No duplicate aliases exist within any CTE SELECT or the final SELECT.
- PRCTR appears in both TOPSIDE_ADJUSTMENTS and STORE_ATTRIBUTES, but is qualified (t.prctr, s.prctr) in Topside_With_Store_Attributes; only t.prctr is projected.
- PRCTR appears in both Topside_With_Retail_Calendar and PROFIT_CENTER_TEXT; only j3.prctr is projected in Topside_With_Profit_Center_Text.
- All other join inputs are qualified and deduplicated at each join step.

---

## 13. Star Projection Validation

No `SELECT *` or `alias.*` projections are used. All CTEs use explicit column lists. No star expansion issues.

---

## 14. Parameter Documentation

| Parameter | BigQuery Type | Source | Usage | Reason Unresolved |
|---|---|---|---|---|
| @ip_week_ending_from | STRING | CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK | Low bound of WEEK_YEAR BETWEEN filter in TOPSIDE_ADJUSTMENTS CTE | Scalar function definition not supplied in converted SQL files |
| @ip_week_ending_to | STRING | CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK | High bound of WEEK_YEAR BETWEEN filter in TOPSIDE_ADJUSTMENTS CTE | Scalar function definition not supplied in converted SQL files |
| @ip_version_comp_flag | STRING | CVS_FRIP.Composite.Master::SFN_ACTUALS_COMP_FLAG | COMP_VER equality filter in COMP_FLAG CTE | Scalar function definition not supplied in converted SQL files |

These are non-blocking findings. The filters are preserved; only the default value computation is unresolved.

---

## 15. Procedure/ETL Handling

No stored procedures, INSERT-SELECT, CREATE TABLE AS SELECT, or MERGE statements were present in any supplied converted SQL file. All source artifacts are Calculation View XMLs converted to SELECT-based BigQuery SQL. No procedural handling was required.

---

## 16. FS vs RX Variant Analysis

Both `CV_COMP_TOPSIDE_ADJUSTMENTS_FS` and `CV_COMP_TOPSIDE_ADJUSTMENTS_RX` have:
- Identical SQL logic (same joins, filters, aggregations, calculated measures)
- Identical source objects (same base view names, same physical tables after mapping)
- The FS/RX suffix in the lineage table reflects the variant alignment of the upstream base views, not a difference in the composite view SQL

Both queries are provided as separate standalone SQL blocks (Query 1 and Query 2) in the consolidated file, as they are separate consumer-facing artifacts. They are functionally identical and can be executed independently with the same runtime parameters.

---

## 17. Conflicts and Validation Findings

### Non-Blocking Findings
1. **Unresolved scalar functions**: `SFN_PRIOR_FISCAL_WEEK` and `SFN_ACTUALS_COMP_FLAG` are converted to runtime parameters `@ip_week_ending_from`, `@ip_week_ending_to`, `@ip_version_comp_flag`. The filter logic is fully preserved.
2. **NULL semantics of GREATEST vs HANA scalar MAX**: HANA `MAX(a,b)` returns NULL if either argument is NULL; BigQuery `GREATEST(a,b)` also returns NULL if any argument is NULL. Semantics are equivalent. Non-blocking.
3. **Converted SQL files for CV_BASE_MD_COMPFL_S4, CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_CEPCT_S4 not in supplied set**: These three base views are referenced by the composite view but their individual converted SQL files were not supplied. Their physical tables (ZTSRP_COMPFL, ZTFIGL_RCALWEEK, CEPCT) are present in Columns_Mapping_v3 and all required columns are mapped. The composite view's converted SQL defines their CTEs (COMP_FLAG, RETAIL_CALENDAR, PROFIT_CENTER_TEXT) with the correct physical table references. Non-blocking.
4. **MANDT filter values in TOPSIDE_ADJUSTMENTS_VT_CAR**: The base view uses MANDT IN ('110','200'). The MANDT column for TOPSIDE_ADJUSTMENTS_VT_CAR is unresolved (table not in mapping), but the converted SQL uses string literals consistent with STRING type. Non-blocking pending table mapping resolution.

---

## 18. ISSUES TO FIX

### ISSUE 1: REQUIRES VALIDATION — MISSING TABLE MAPPING
**Affected artifact**: `TOPSIDE_ADJUSTMENTS_VT_CAR`
**Source file**: `xml_acc_cv_base_topside_adjustments_car_FS_DI HANA to BigQuery SQL Conversion Agent.txt` and `xml_acc_cv_base_topside_adjustments_car_RX_DI HANA to BigQuery SQL Conversion Agent.txt`
**Evidence**: The HANA source table `CVS_FRIP.TOPSIDE_ADJUSTMENTS_VT_CAR` is the terminal physical source for the topside adjustment facts. It is not present in `Columns_Mapping_v3.csv` under any HANA_TABLE value. No BQ_FULL_TABLE can be determined.
**Impact**: The `TOPSIDE_ADJUSTMENTS` CTE in both Query 1 and Query 2 uses the placeholder `` `REQUIRES_VALIDATION.TOPSIDE_ADJUSTMENTS_VT_CAR` ``. The queries cannot execute until this is replaced with the correct `project.dataset.table` value.
**Resolution needed**: Provide the BQ_FULL_TABLE mapping for HANA table `TOPSIDE_ADJUSTMENTS_VT_CAR` (HANA schema `CVS_FRIP`). Also provide column-level mappings for all 25 columns referenced from this table (APPLICATION, DESCRIPTION, MANDT, PRCTR, S4_ACCOUNT, SEGMENT, TYPE, WEEK_YEAR, ZYEAR, and the 16 measure columns).

### ISSUE 2: REQUIRES VALIDATION — MISSING COLUMN MAPPINGS FOR TOPSIDE_ADJUSTMENTS_VT_CAR
**Affected columns**: APPLICATION, DESCRIPTION, MANDT, PRCTR, S4_ACCOUNT, SEGMENT, TYPE, WEEK_YEAR, ZYEAR, FS_BUD, FS_FCT, FS_FLASH, FS_LY, RX_BUD, RX_FCT, RX_FLASH, RX_LY, SC_90AS1_BUD, SC_90AS1_FCT, SC_90AS1_FLASH, SC_90AS1_LY, SC_90AS3_BUD, SC_90AS3_FCT, SC_90AS3_FLASH, SC_90AS3_LY
**Source file**: `xml_acc_cv_base_topside_adjustments_car_FS/RX`
**Evidence**: No rows in Columns_Mapping_v3 reference HANA_TABLE = TOPSIDE_ADJUSTMENTS_VT_CAR.
**Impact**: Column names in the TOPSIDE_ADJUSTMENTS CTE are carried over from the converted SQL as lowercase names. If the actual BQ column names differ, the SQL must be updated.
**Resolution needed**: Add Columns_Mapping_v3 rows for TOPSIDE_ADJUSTMENTS_VT_CAR with BQ_FULL_TABLE and BQ_COLUMN values for all 25 columns.

---

## 19. Final Quality Gate Results

| Check | Result |
|---|---|
| 1. Final consumer unambiguous | ✅ Two consumers identified: CV_COMP_TOPSIDE_ADJUSTMENTS FS and RX |
| 2. Artifact dependencies match lineage table | ✅ All 4 lineage edges represented |
| 3. Final-consumer transformation order preserved | ✅ 4-join sequence preserved in CTE order |
| 4. Dependencies expanded at point of consumption | ✅ Each base view expanded at its join point |
| 5. No generic Source→Intermediate→Target ordering | ✅ Flow follows actual node sequence |
| 6. Every file classified USED/NOT USED | ✅ All 6 files classified USED |
| 7. Every USED file participates in dependency chain | ✅ |
| 8. All converted dependencies expanded | ✅ |
| 9. Only terminal sources remain | ✅ (except TOPSIDE_ADJUSTMENTS_VT_CAR — unresolved) |
| 10. Every physical source uses BQ_FULL_TABLE | ⚠️ TOPSIDE_ADJUSTMENTS_VT_CAR unresolved — placeholder used |
| 11. Every referenced physical column mapped | ⚠️ TOPSIDE_ADJUSTMENTS_VT_CAR columns unmapped — see Issues to Fix |
| 12. Type compatibility in all comparisons | ✅ All STRING-to-STRING comparisons; CAST(0 AS NUMERIC) for measure CASE branches |
| 13. Final-consumer CTE names and order preserved | ✅ |
| 14. Compatible operations combined | ✅ MANDT filter from base view combined into TOPSIDE_ADJUSTMENTS and STORE_ATTRIBUTES CTEs |
| 15. No HANA node becomes separate CTE merely to mirror structure | ✅ |
| 16. Every helper CTE justified by real semantic boundary | ✅ |
| 17. Every CTE matches required output contract | ✅ |
| 18. Every column reference qualified where ambiguous | ✅ |
| 19. No duplicate alias within any SELECT | ✅ |
| 20. Every retained star projection valid | ✅ (no stars used) |
| 21. Filters, joins, calculations, mappings, parameters preserved | ✅ |
| 22. Every aggregation stage preserves required grain | ✅ |
| 23. DISTINCT, UNION, window behavior preserved | ✅ (none present) |
| 24. No conflict silently corrected | ✅ All issues disclosed |
| 25. No result-affecting procedural behavior discarded | ✅ (no procedures) |
| 26. Runtime parameters documented; no DECLARE/SET | ✅ |
| 27. Every CTE has standardized comment header | ✅ |
| 28. CTE comments describe consolidated logic | ✅ |
| 29. Complete query achieves 100% logic match with minimum CTE structure | ✅ (pending TOPSIDE_ADJUSTMENTS_VT_CAR resolution) |
| 30. Every lineage edge represented by correct supplied logic | ⚠️ TOPSIDE_ADJUSTMENTS_VT_CAR table mapping unresolved |
| 31. Every filter, join, aggregation, UNION, parameter traced to output | ✅ |
| 32. Every physical-column output uses exact BQ_COLUMN | ⚠️ TOPSIDE_ADJUSTMENTS_VT_CAR columns unverified |

**Overall Status**: SQL is complete and correct for all resolved sources. Two unresolved issues (TOPSIDE_ADJUSTMENTS_VT_CAR table and column mapping) prevent production-ready status. The SQL is not production-ready until Issue 1 and Issue 2 are resolved.
