# Consolidation Description
## CV_COMP_FORECAST_MJE_STATIC + STP_WSS_FORECAST_MJE

---

## 1. Inputs Read

### Main File Relationships Table
**37 lineage rows read** covering:
- CV_BASE_* → CV_COMP_FIN_FORECAST
- CV_BASE_* → CV_COMP_SKF_FORECAST
- CV_BASE_* → CV_COMP_FIN_SBT
- CV_BASE_* → CV_COMP_FIN_MANUAL_JE
- CV_BASE_* → CV_COMP_SKF_MANUAL_JE
- CV_COMP_FIN_FORECAST, CV_COMP_SKF_FORECAST, CV_COMP_FIN_SBT, CV_COMP_FIN_MANUAL_JE, CV_COMP_SKF_MANUAL_JE → **CV_COMP_FORECAST_MJE**
- **CV_COMP_FORECAST_MJE → STP_WSS_FORECAST_MJE** (Stored Procedure Dependency, score 95)
- **STP_WSS_FORECAST_MJE → CV_COMP_FORECAST_MJE_STATIC** (Logic Provider, score 95)
- GL_HEIR.CV_BASE_MD_HRRP_NODE_S4, PC_HEIR.CV_BASE_MD_HRRP_NODE_S4, PROD_CLASS_HEIR.CV_BASE_MD_HRRP_NODE_S4 → CV_COMP_FIN_MANUAL_JE

### main consolidation input files
| File | Classification | Reason |
|---|---|---|
| `CV_COMP_FORECAST_MJE_STATIC Bigquery.txt` | **USED** | Final consumer artifact — CUBE aggregation view over TBL_WSS_FORECAST_MJE |
| `STP_WSS_FORECAST_MJE Bigquery.txt` | **USED** | Stored procedure that populates TBL_WSS_FORECAST_MJE from CV_COMP_FORECAST_MJE; its SELECT body is inlined |

### Columns_Mapping.csv
**Full CSV read.** Tables mapped in the CSV:
- CEPCT → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct`
- ZTFIGL_RCALWEEK → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek`
- ZTSRP_COMPFL → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl`
- ZTSRP_ATTR_ACT → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act`
- HRRP_NODE → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node`
- AZSRP_DS041_VT_S4 → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds041`
- AZSRP_DS052_VT_S4 → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds202`
- AZSRP_DS112_VT_S4 → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds112`
- AZSRP_DS072_VT_S4 → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds212`
- AZSRP_DS092_VT_S4 → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds092`
- AZSRP_DS031_VT_S4 → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds031`
- ACDOCA_VT_S4 → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_acdoca`
- BKPF → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_bkpf`
- FAGLSKF_PN → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_faglskf_pn`

**TBL_WSS_FORECAST_MJE is NOT present in Columns_Mapping.csv.** (See Issues to Fix.)

---

## 2. Final Consumer Identification

**CV_COMP_FORECAST_MJE_STATIC** is the final consumer-facing artifact.

- HANA artifact type: Calculation View (CUBE / Aggregation)
- Source: `CVS_FRIP.Table::TBL_WSS_FORECAST_MJE` (staging table)
- Logic: Single Projection node → GROUP BY all non-measure columns, SUM six measure columns

---

## 3. Artifact Dependency Mapping

### Lineage Edge Trace

| Producer | Consumer | Type | Resulting SQL Location |
|---|---|---|---|
| CV_COMP_FORECAST_MJE | STP_WSS_FORECAST_MJE | Stored Procedure Dependency | Procedure SELECT body inlined as source of final SELECT |
| STP_WSS_FORECAST_MJE | CV_COMP_FORECAST_MJE_STATIC | Logic Provider | Procedure INSERT…SELECT body replaces TBL_WSS_FORECAST_MJE reference |

### Dependency Chain

```
CV_COMP_FORECAST_MJE_STATIC
  <- STP_WSS_FORECAST_MJE (procedure)
    <- CV_COMP_FORECAST_MJE (calculation view — NOT SUPPLIED)
      <- CV_COMP_FIN_FORECAST, CV_COMP_SKF_FORECAST, CV_COMP_FIN_SBT,
         CV_COMP_FIN_MANUAL_JE, CV_COMP_SKF_MANUAL_JE (NOT SUPPLIED)
        <- CV_BASE_* (NOT SUPPLIED)
```

---

## 4. Final-Consumer Flow / Order

CV_COMP_FORECAST_MJE_STATIC has a single transformation node:
1. **Projection** from TBL_WSS_FORECAST_MJE → all 44 columns (1:1)
2. **Aggregation** (CUBE): GROUP BY 36 attribute columns, SUM 6 measure columns

The procedure STP_WSS_FORECAST_MJE replaces TBL_WSS_FORECAST_MJE with its source:
- DELETE all rows from TBL_WSS_FORECAST_MJE (DML wrapper — skipped)
- INSERT INTO TBL_WSS_FORECAST_MJE SELECT [42 columns] FROM CV_COMP_FORECAST_MJE (SELECT body inlined)
- SNAPSHOT_TIMESTAMP and CREATED_BY are audit-only INSERT columns not used downstream — omitted

After inlining, the consolidated query is a single SELECT with GROUP BY directly from CV_COMP_FORECAST_MJE.

---

## 5. Dependency Expansion and Point-of-Consumption Mapping

### STP_WSS_FORECAST_MJE Inlining

The procedure INSERT…SELECT body is inlined at the point where CV_COMP_FORECAST_MJE_STATIC reads from TBL_WSS_FORECAST_MJE.

**Procedure SELECT inlined:**
- Source: `CV_COMP_FORECAST_MJE`
- Columns: 42 data columns (all columns except SNAPSHOT_TIMESTAMP and CREATED_BY)
- Filters carried by the procedure SELECT: **None** (no WHERE clause in the procedure SELECT)
- The procedure SELECT is a 1:1 pass-through; no transformations, calculations, or joins

**Filters from procedure SELECT:** None.
**Filters from CV_COMP_FORECAST_MJE_STATIC:** None (no input parameters or WHERE clause defined).

### CV_COMP_FORECAST_MJE

This calculation view converted SQL was **not supplied** in `main consolidation input`. It is referenced as a BigQuery object. Its BigQuery name is inferred as `cv_comp_forecast_mje` in the project/dataset pattern `edp-qa-finstorage.edp_saps4_shared_cnsv` (consistent with all other objects in the CSV). This must be validated — see Issues to Fix.

---

## 6. USED / NOT USED Classifications

| File | Status | Reason |
|---|---|---|
| `CV_COMP_FORECAST_MJE_STATIC Bigquery.txt` | USED | Final consumer; defines aggregation logic and output contract |
| `STP_WSS_FORECAST_MJE Bigquery.txt` | USED | Procedure that populates TBL_WSS_FORECAST_MJE; its SELECT body is inlined to replace the staging table |

---

## 7. Filter, Join, Aggregation, UNION, Parameter Trace

### CV_COMP_FORECAST_MJE_STATIC
- **Filters:** None
- **Joins:** None (single source)
- **Aggregation:** SUM(fin_fcst_amount), SUM(skf_fcst_qty), SUM(sbt), SUM(skf_mje_qty), SUM(cal_fs_sales_mje), SUM(cal_rx_sales_mje) — preserved in final SELECT
- **GROUP BY:** All 36 non-measure columns — preserved in final SELECT
- **UNION branches:** None
- **Parameters:** None

### STP_WSS_FORECAST_MJE (SELECT body)
- **Filters:** None (no WHERE clause)
- **Joins:** None (single source: CV_COMP_FORECAST_MJE)
- **Aggregation:** None (pass-through)
- **Calculations:** None (CURRENT_TIMESTAMP and SESSION_USER are audit-only, omitted)
- **Parameters:** None

---

## 8. Alias Check

### Column Name Conversions Applied

All column names from the converted SQL are converted to BigQuery style (lowercase, no leading underscores, / replaced with _):

| HANA/Source Name | BigQuery Name | Action |
|---|---|---|
| CAL_COMP_FLAG_DESC | cal_comp_flag_desc | Lowercased; no alias needed |
| CAL_EMERG_MKT_IND | cal_emerg_mkt_ind | Lowercased |
| MANDT | mandt | Lowercased |
| CAL_SOURCE | cal_source | Lowercased |
| DIVISION_CODE | division_code | Lowercased |
| DIVISION_DESC | division_desc | Lowercased |
| REGION_CODE | region_code | Lowercased |
| REGION_DESC | region_desc | Lowercased |
| DISTRICT_CODE | district_code | Lowercased |
| DISTRICT_DESC | district_desc | Lowercased |
| RX_DIVISION_CODE | rx_division_code | Lowercased |
| RX_AREA_CODE | rx_area_code | Lowercased |
| RX_REGION_CODE | rx_region_code | Lowercased |
| RX_DISTRICT_CODE | rx_district_code | Lowercased |
| STRNUM | strnum | Lowercased |
| PRCTR | prctr | Lowercased |
| EMERG_MKT_IND | emerg_mkt_ind | Lowercased |
| REP_MKT_CODE | rep_mkt_code | Lowercased |
| REP_MKT_DESC | rep_mkt_desc | Lowercased |
| COMP_FLAG | comp_flag | Lowercased |
| FS_RX_FLAG | fs_rx_flag | Lowercased |
| _BIC_ZIO_SWEEK | bic_zio_sweek | Leading underscore removed, lowercased; name-equivalence rule applied |
| FS_RX_FLAG_EXT | fs_rx_flag_ext | Lowercased |
| ZRWSTRTDATE | zrwstrtdate | Lowercased |
| ZRWENDDATE | zrwenddate | Lowercased |
| CAL_WEEK_NUMBER | cal_week_number | Lowercased |
| CITY | city | Lowercased |
| STATE | state | Lowercased |
| FIN_FORECAST_CURRENCY | fin_forecast_currency | Lowercased |
| PROFIT_CENTER_TEXT | profit_center_text | Lowercased |
| CAL_DATA_CATEGORY1 | cal_data_category1 | Lowercased |
| CAL_DATA_CATEGORY2 | cal_data_category2 | Lowercased |
| FS_OPEN_DAT | fs_open_dat | Lowercased |
| RX_OPEN_DAT | rx_open_dat | Lowercased |
| AREA_CODE | area_code | Lowercased |
| AREA_DESC | area_desc | Lowercased |
| FIN_FCST_AMOUNT | fin_fcst_amount | Lowercased (aggregate alias) |
| SKF_FCST_QTY | skf_fcst_qty | Lowercased (aggregate alias) |
| SBT | sbt | Lowercased (aggregate alias) |
| SKF_MJE_QTY | skf_mje_qty | Lowercased (aggregate alias) |
| CAL_FS_SALES_MJE | cal_fs_sales_mje | Lowercased (aggregate alias) |
| CAL_RX_SALES_MJE | cal_rx_sales_mje | Lowercased (aggregate alias) |

**Redundant aliases removed:** All aliases in the converted SQL that only changed case are replaced with BigQuery-style lowercase aliases. No HANA-name aliases are retained.

**Meaningful renames retained:** None required — all columns are 1:1 pass-throughs.

---

## 9. CTE / Helper Mapping

The consolidated SQL requires **no CTEs**. The logic is a single SELECT with GROUP BY directly from the source object (`cv_comp_forecast_mje`). No intermediate CTEs are needed because:
- The procedure SELECT is a 1:1 pass-through (no transformation)
- The CV_COMP_FORECAST_MJE_STATIC logic is a single aggregation over a single source
- No semantic boundaries require separation

---

## 10. CTE Documentation Comment Validation

A single standardized comment block is placed before the SELECT statement. It documents:
- CTE sequence (1, as the only query block)
- Logic: aggregation of CV_COMP_FORECAST_MJE columns
- Source: CV_COMP_FORECAST_MJE
- Aggregation: SUM of 6 measure columns, GROUP BY 36 attribute columns

---

## 11. Table and Column Mapping Applied

### Terminal Physical Source

After inlining the procedure SELECT body, the terminal source is:
- **CV_COMP_FORECAST_MJE** (BigQuery object — not a physical HANA table in Columns_Mapping.csv)

The physical HANA tables that ultimately feed CV_COMP_FORECAST_MJE (ACDOCA, BKPF, FAGLSKF_PN, etc.) are mapped in Columns_Mapping.csv, but CV_COMP_FORECAST_MJE converted SQL was not supplied, so expansion to those physical tables is not possible.

### Columns_Mapping Usage

Since TBL_WSS_FORECAST_MJE is not in the CSV and CV_COMP_FORECAST_MJE is not in the CSV (it is a calculation view, not a physical table), no direct column-by-column CSV lookup is applicable for the terminal source in this consolidation. The column names are taken from the converted SQL and converted to BigQuery style per the name-equivalence rule.

### Type Casts Applied

None required. No filters, join conditions, CASE expressions, or BETWEEN/IN predicates are present in the consolidated SQL. The SUM aggregates operate on the columns as provided by CV_COMP_FORECAST_MJE; data type compatibility is assumed from the upstream view (to be validated — see Issues to Fix).

### Procedure SELECT Inlined

- **Procedure file:** STP_WSS_FORECAST_MJE Bigquery.txt
- **SELECT inlined from:** CV_COMP_FORECAST_MJE
- **Filters carried:** None
- **Audit columns omitted:** SNAPSHOT_TIMESTAMP (CURRENT_TIMESTAMP), CREATED_BY (SESSION_USER) — not consumed by downstream logic

---

## 12. Duplicate, Ambiguous-Column, Parent-Availability, and Aggregation Validation

- **Duplicates:** No duplicate column aliases in the final SELECT. Each of the 42 output columns appears exactly once.
- **Ambiguous columns:** None — single source table, no joins.
- **Parent availability:** All columns referenced in the SELECT and GROUP BY are available from cv_comp_forecast_mje (confirmed by the procedure 1:1 column mapping).
- **Aggregation grain:** Preserved exactly as defined in CV_COMP_FORECAST_MJE_STATIC. Six measure columns are summed; 36 attribute columns are grouped. No extra grouping columns added; no grouping columns removed.

---

## 13. Star Validation

No star projections used. All columns are explicitly listed.

---

## 14. Parameter Documentation

No runtime parameters are required by the consolidated SQL. The procedure STP_WSS_FORECAST_MJE has no input parameters. CV_COMP_FORECAST_MJE_STATIC has no input parameters.

---

## 15. Procedure / ETL Handling

### STP_WSS_FORECAST_MJE

- **DML wrappers skipped:** DELETE FROM TBL_WSS_FORECAST_MJE; INSERT INTO TBL_WSS_FORECAST_MJE (...) — both wrappers omitted
- **SELECT body inlined:** SELECT [42 data columns] FROM CV_COMP_FORECAST_MJE
- **Audit columns omitted:** SNAPSHOT_TIMESTAMP (CURRENT_TIMESTAMP()), CREATED_BY (SESSION_USER()) — these are INSERT-only audit columns not consumed by CV_COMP_FORECAST_MJE_STATIC
- **Representability:** The procedure is a full-table DELETE + INSERT SELECT with no loops, cursors, or state-dependent logic. It is fully representable as a SELECT query. Non-blocking finding.

---

## 16. Conflicts and Validation Findings

### Non-Blocking Findings

1. **Audit columns omitted (non-blocking):** SNAPSHOT_TIMESTAMP and CREATED_BY are populated only by the INSERT statement and are not referenced by CV_COMP_FORECAST_MJE_STATIC. Omitting them does not affect the result logic.

2. **Column name style conversion (non-blocking):** _BIC_ZIO_SWEEK -> bic_zio_sweek applied per name-equivalence rule. This is a BigQuery-style conversion, not a semantic rename.

---

## 17. ISSUES TO FIX

### ISSUE 1 — REQUIRES VALIDATION: CV_COMP_FORECAST_MJE NOT SUPPLIED

**Affected artifact:** CV_COMP_FORECAST_MJE
**Evidence:** The Main File Relationships Table shows CV_COMP_FORECAST_MJE as a direct dependency of STP_WSS_FORECAST_MJE (score 95). The procedure SELECT reads from _SYS_BIC.CVS_FRIP.Composite.FI/CV_COMP_FORECAST_MJE. No converted SQL file for CV_COMP_FORECAST_MJE was supplied in main consolidation input.
**Impact:** The consolidated SQL cannot be fully expanded to terminal physical sources. CV_COMP_FORECAST_MJE is referenced as a BigQuery object placeholder. Its internal logic (joins, filters, calculations, aggregations across CV_COMP_FIN_FORECAST, CV_COMP_SKF_FORECAST, CV_COMP_FIN_SBT, CV_COMP_FIN_MANUAL_JE, CV_COMP_SKF_MANUAL_JE) is not represented in the consolidated SQL.
**Resolution needed:** Supply the converted BigQuery SQL file for CV_COMP_FORECAST_MJE. Once supplied, the consolidation can be expanded to inline its logic and ultimately reach the terminal physical BigQuery tables.

### ISSUE 2 — REQUIRES VALIDATION: TBL_WSS_FORECAST_MJE NOT IN COLUMNS_MAPPING

**Affected table:** TBL_WSS_FORECAST_MJE (HANA staging table)
**Evidence:** The full Columns_Mapping.csv was read. No row exists for HANA_TABLE = TBL_WSS_FORECAST_MJE.
**Impact:** The BigQuery full table name for TBL_WSS_FORECAST_MJE cannot be confirmed from the CSV. Since the procedure SELECT body is inlined (replacing TBL_WSS_FORECAST_MJE with its source CV_COMP_FORECAST_MJE), this does not affect the consolidated SQL directly — but it means the staging table BigQuery schema cannot be validated from the CSV.
**Resolution needed:** Add TBL_WSS_FORECAST_MJE to Columns_Mapping.csv if it exists as a physical BigQuery table, or confirm that it is always replaced by the procedure SELECT body.

### ISSUE 3 — REQUIRES VALIDATION: CV_COMP_FORECAST_MJE BIGQUERY OBJECT NAME UNCONFIRMED

**Affected object:** cv_comp_forecast_mje in the consolidated SQL
**Evidence:** The procedure converted SQL uses the placeholder PROJECT.DATASET.CV_COMP_FORECAST_MJE. The Columns_Mapping.csv uses the project edp-qa-finstorage and dataset edp_saps4_shared_cnsv for all mapped objects. The BigQuery object name cv_comp_forecast_mje is inferred from the HANA artifact name.
**Impact:** If the actual BigQuery object name differs (e.g., it may be a view named differently, or in a different dataset), the consolidated SQL will fail at runtime.
**Resolution needed:** Confirm the actual BigQuery project, dataset, and object name for CV_COMP_FORECAST_MJE and replace the placeholder in the SQL.

### ISSUE 4 — REQUIRES VALIDATION: COLUMN DATA TYPES FOR CV_COMP_FORECAST_MJE UNCONFIRMED

**Affected columns:** All 42 columns in the consolidated SELECT
**Evidence:** TBL_WSS_FORECAST_MJE and CV_COMP_FORECAST_MJE are not in Columns_Mapping.csv. Data types for the output columns (e.g., zrwstrtdate, zrwenddate, fs_open_dat, rx_open_dat — likely DATE; fin_fcst_amount, skf_fcst_qty, sbt, skf_mje_qty, cal_fs_sales_mje, cal_rx_sales_mje — likely NUMERIC) cannot be confirmed from the CSV.
**Impact:** SUM aggregates require NUMERIC-compatible types. DATE columns must not be aggregated. If any column type is incompatible, the SQL will fail.
**Resolution needed:** Validate data types for all columns in the BigQuery CV_COMP_FORECAST_MJE object. Confirm that the six measure columns are NUMERIC and the date columns are DATE type.

### ISSUE 5 — REQUIRES VALIDATION: UPSTREAM CV_COMP_* VIEWS NOT SUPPLIED

**Affected artifacts:** CV_COMP_FIN_FORECAST, CV_COMP_SKF_FORECAST, CV_COMP_FIN_SBT, CV_COMP_FIN_MANUAL_JE, CV_COMP_SKF_MANUAL_JE (all dependencies of CV_COMP_FORECAST_MJE per lineage)
**Evidence:** Main File Relationships Table shows these five views as direct dependencies of CV_COMP_FORECAST_MJE. None of their converted SQL files were supplied.
**Impact:** Full end-to-end expansion to terminal physical sources (ACDOCA, BKPF, FAGLSKF_PN, etc.) is not possible from the supplied inputs.
**Resolution needed:** Supply converted BigQuery SQL files for CV_COMP_FORECAST_MJE and all its upstream dependencies to enable full consolidation to terminal physical sources.

---

## 18. Final Quality Gate Results

| Check | Result |
|---|---|
| 1. Final consumer unambiguous | PASS — CV_COMP_FORECAST_MJE_STATIC |
| 2. Artifact dependencies match lineage | PASS — STP_WSS_FORECAST_MJE -> CV_COMP_FORECAST_MJE_STATIC confirmed |
| 3. Final-consumer transformation order preserved | PASS — Aggregation logic preserved exactly |
| 4. Dependencies expanded at point of consumption | PASS — Procedure SELECT inlined at TBL_WSS_FORECAST_MJE reference |
| 5. No generic Source->Intermediate->Target ordering | PASS |
| 6. Every file classified USED/NOT USED | PASS |
| 7. Every USED file participates in dependency chain | PASS |
| 8. All converted dependencies expanded | PARTIAL — CV_COMP_FORECAST_MJE not supplied; cannot expand further |
| 9. Only terminal sources remain | PARTIAL — CV_COMP_FORECAST_MJE remains as BigQuery object reference |
| 10. Every physical source uses BQ_FULL_TABLE | ISSUE 3 — CV_COMP_FORECAST_MJE BQ name unconfirmed |
| 11. Every referenced column mapped via Columns_Mapping | ISSUE 2, 4 — TBL_WSS_FORECAST_MJE not in CSV; columns not directly mappable |
| 12. Type comparisons consistent | PASS — No filters, joins, or comparisons in consolidated SQL |
| 13. Final-consumer CTE names and order preserved | PASS — Single SELECT, no CTEs needed |
| 14. Compatible operations combined | PASS — Procedure pass-through + aggregation combined into single SELECT |
| 15. No source node becomes separate CTE | PASS |
| 16. Every helper CTE justified | PASS — No helper CTEs |
| 17. Every CTE matches output contract | PASS — 42 output columns match CV_COMP_FORECAST_MJE_STATIC contract |
| 18. Column references qualified | PASS — Single source, no ambiguity |
| 19. No duplicate aliases | PASS |
| 20. Star projections valid | PASS — No stars used |
| 21. Filters, joins, calculations preserved | PASS — None exist in supplied logic |
| 22. Aggregation grain preserved | PASS — 36 GROUP BY columns, 6 SUM measures |
| 23. DISTINCT, UNION, window behavior preserved | PASS — None present |
| 24. No conflict silently corrected | PASS — All issues disclosed |
| 25. Procedure staging table replaced by SELECT body | PASS — TBL_WSS_FORECAST_MJE replaced by CV_COMP_FORECAST_MJE |
| 26. Runtime parameters documented | PASS — None required |
| 27. Every CTE has standardized comment header | PASS |
| 28. CTE comments accurate | PASS |
| 29. 100% logic match with minimum CTE structure | PASS — Single SELECT |
| 30. Every lineage edge represented | PARTIAL — CV_COMP_FORECAST_MJE edge unresolved (not supplied) |
| 31. Every filter/join/aggregation/parameter traced | PASS — All traced; none omitted |
| 32. Physical column outputs use exact BQ_COLUMN | ISSUE 2, 4 — Cannot confirm from CSV for TBL_WSS_FORECAST_MJE columns |

**Overall Status: NOT PRODUCTION-READY — See Issues to Fix above.**

The consolidated SQL is complete and correct for the supplied inputs. Full production readiness requires resolution of the five issues listed above, primarily the supply of the converted BigQuery SQL for CV_COMP_FORECAST_MJE.
