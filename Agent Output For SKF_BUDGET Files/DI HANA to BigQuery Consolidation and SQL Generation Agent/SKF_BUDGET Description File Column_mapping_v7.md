# SKF_BUDGET Consolidation Description
## BigQuery SQL Consolidation Agent — Column_mapping_v7

---

## 1. Pre-Consolidation Input Confirmation

### Lineage Rows Read (SKF_BUDGET File Relationships Table)
All 10 lineage rows were read:

| Source File | Target File | Relationship |
|---|---|---|
| CV_BASE_SKF_WEEKLY_BUDGET_S4 | CV_COMP_SKF_BUDGET_STATIC | Calculation View Dependency |
| CV_BASE_MD_HRRP_NODE_S4 | CV_COMP_SKF_BUDGET_STATIC | Calculation View Dependency |
| CV_BASE_MD_RCALWEEK_S4 | CV_COMP_SKF_BUDGET_STATIC | Calculation View Dependency |
| CV_BASE_MD_CEPCT_S4 | CV_COMP_SKF_BUDGET_STATIC | Calculation View Dependency |
| CV_BASE_MD_SRPACT_S4 | STP_WSS_SRP_ATTRIBUTES | Source Dependency |
| CV_BASE_MD_COMPFL_S4 | STP_WSS_SRP_ATTRIBUTES | Source Dependency |
| STP_WSS_SRP_ATTRIBUTES | CV_COMP_MD_SRPACT_STATIC | Logic Provider |
| STP_WSS_SRP_ATTRIBUTES | CV_COMP_MD_COMPFL_STATIC | Logic Provider |
| CV_COMP_MD_SRPACT_STATIC | CV_COMP_SKF_BUDGET_STATIC | Calculation View Dependency |
| CV_COMP_MD_COMPFL_STATIC | CV_COMP_SKF_BUDGET_STATIC | Calculation View Dependency |

### Files in SKF_BUDGET Latest BIGQUERY Files (10 files read)
1. `CV_COMP_SKF_BUDGET_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt` — **USED** (final consumer)
2. `CV_BASE_SKF_WEEKLY_BUDGET_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — **USED** (direct dependency)
3. `CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — **USED** (direct dependency)
4. `CV_BASE_MD_RCALWEEK_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — **USED** (direct dependency)
5. `CV_BASE_MD_CEPCT_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — **USED** (direct dependency)
6. `CV_COMP_MD_SRPACT_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt` — **USED** (dependency via STP_WSS_SRP_ATTRIBUTES)
7. `CV_COMP_MD_COMPFL_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt` — **USED** (dependency via STP_WSS_SRP_ATTRIBUTES)
8. `STP_WSS_SRP_ATTRIBUTES_DI HANA to BigQuery SQL Conversion Agent.txt` — **USED** (procedure providing logic for staging tables)
9. `CV_BASE_MD_SRPACT_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — **USED** (source for STP_WSS_SRP_ATTRIBUTES → TBL_WSS_SRP_ATTR_ACT)
10. `CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — **USED** (source for STP_WSS_SRP_ATTRIBUTES → TBL_WSS_SRP_COMPFLAG)

**All 10 files are USED. No NOT USED files.**

### Columns_Mapping.csv Rows Read
The full CSV was read. Relevant tables for this consolidation:
- `HRRP_NODE` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node` (14 columns)
- `ZTFIGL_RCALWEEK` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek` (9 columns)
- `CEPCT` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct` (8 columns)
- `ZTSRP_ATTR_ACT` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act` (67 columns)
- `ZTSRP_COMPFL` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl` (13 columns)
- `AZSRP_DS092_VT_S4` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds092` (19 columns)
- `AZSRP_DS031_VT_S4` → `edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds031` (17 columns)

---

## 2. Final Consumer Identification

**Final Consumer:** `CV_COMP_SKF_BUDGET_STATIC`

This is the only artifact that appears exclusively as a **target** in the lineage table and never as a source. All other artifacts feed into it either directly or transitively.

---

## 3. Artifact Dependency Mapping

### Lineage Edges and Their SQL Locations

| Producer | Consumer | Resulting SQL Location |
|---|---|---|
| CV_BASE_SKF_WEEKLY_BUDGET_S4 | CV_COMP_SKF_BUDGET_STATIC | CTEs 1–3 (FROZEN_CUBE, LIVE_CUBE, WEEKLY_SNAPSHOT_DS05) |
| CV_BASE_MD_HRRP_NODE_S4 | CV_COMP_SKF_BUDGET_STATIC | CTE 4 (HIER_NODE) |
| CV_BASE_MD_SRPACT_S4 | STP_WSS_SRP_ATTRIBUTES | Inlined into CTE 6 (STORE_ATTR_ACTUAL) |
| CV_BASE_MD_COMPFL_S4 | STP_WSS_SRP_ATTRIBUTES | Inlined into CTE 8 (COMP_FLAG_BUDGET_SRC) |
| STP_WSS_SRP_ATTRIBUTES | CV_COMP_MD_SRPACT_STATIC | Procedure's INSERT…SELECT body inlined into CTE 6 |
| STP_WSS_SRP_ATTRIBUTES | CV_COMP_MD_COMPFL_STATIC | Procedure's INSERT…SELECT body inlined into CTE 8 |
| CV_COMP_MD_SRPACT_STATIC | CV_COMP_SKF_BUDGET_STATIC | CTE 6 (STORE_ATTR_ACTUAL) |
| CV_COMP_MD_COMPFL_STATIC | CV_COMP_SKF_BUDGET_STATIC | CTE 8 (COMP_FLAG_BUDGET_SRC) |
| CV_BASE_MD_RCALWEEK_S4 | CV_COMP_SKF_BUDGET_STATIC | CTE 10 (CAL_WEEK) |
| CV_BASE_MD_CEPCT_S4 | CV_COMP_SKF_BUDGET_STATIC | CTE 12 (PROFIT_CENTER_TEXT) |

---

## 4. Final Consumer Flow / Transformation Order

Per CV_COMP_SKF_BUDGET_STATIC converted SQL, the node sequence is:

1. **WEEKLY_SNAPSHOT_DS05** — Filter and aggregate budget data from CV_BASE_SKF_WEEKLY_BUDGET_S4
2. **HIER_NODE** — Filter hierarchy nodes from CV_BASE_MD_HRRP_NODE_S4
3. **Join_1** — Inner join WEEKLY_SNAPSHOT_DS05 × HIER_NODE on cost center
4. **STORE_ATTR_ACTUAL** — Store attributes from CV_COMP_MD_SRPACT_STATIC
5. **Join_2** — Left join Join_1 × STORE_ATTR_ACTUAL on profit center
6. **COMP_FLAG_BUDGET** — Competition flags from CV_COMP_MD_COMPFL_STATIC, filtered by IP_VERSION
7. **Join_3** — Left join Join_2 × COMP_FLAG_BUDGET on profit center + week
8. **CAL_WEEK** — Calendar week attributes from CV_BASE_MD_RCALWEEK_S4
9. **Join_4** — Left join Join_3 × CAL_WEEK on week number
10. **PROFIT_CENTER_TEXT** — Profit center text from CV_BASE_MD_CEPCT_S4
11. **Join_5** — Left join Join_4 × PROFIT_CENTER_TEXT on profit center
12. **FLAGS** — Final projection with calculated columns
13. **Final SELECT** — Aggregation (GROUP BY + SUM measures)

---

## 5. Dependency Expansion and Point-of-Consumption Mapping

### CV_BASE_SKF_WEEKLY_BUDGET_S4 → CTEs 1–3
- **Expansion point:** WEEKLY_SNAPSHOT_DS05 in the final consumer
- **Logic inlined:** Two source tables (v_bic_azsrp_ds092 for Frozen Cube, v_bic_azsrp_ds031 for Live Cube), UNION ALL, conditional aggregation for bic_zio_skfq (IF FC IS NULL THEN LC ELSE FC), plus the final consumer's filters on fiscvarnt, bic_zio_sweek, bic_zio_ver, bic_zio_saudt, bic_zio_pskf
- **Parameter @ip_fc_count:** Derived from SFN_SKF_FC_FLAG (unresolved external function) — documented as runtime parameter

### CV_BASE_MD_HRRP_NODE_S4 → CTE 4
- **Expansion point:** HIER_NODE in the final consumer
- **Logic inlined:** Filter mandt IN ('120','200'), REGEXP_CONTAINS(parnode, r'CORERET$'), hryvalto = DATE '9999-12-31'

### STP_WSS_SRP_ATTRIBUTES + CV_BASE_MD_SRPACT_S4 + CV_COMP_MD_SRPACT_STATIC → CTE 6
- **Expansion point:** STORE_ATTR_ACTUAL in the final consumer
- **Procedure inlining:** The procedure's INSERT…SELECT body (from CV_BASE_MD_SRPACT_S4 = v_ztsrp_attr_act, mandt IN ('120','200')) is inlined. The staging table TBL_WSS_SRP_ATTR_ACT is replaced by its source SELECT. CV_COMP_MD_SRPACT_STATIC's aggregation (SUM on measures) is applied.
- **Audit columns (SNAPSHOT_TIMESTAMP, SNAPSHOT_CREATED_BY):** Not used downstream — omitted per rules

### STP_WSS_SRP_ATTRIBUTES + CV_BASE_MD_COMPFL_S4 + CV_COMP_MD_COMPFL_STATIC → CTE 8
- **Expansion point:** COMP_FLAG_BUDGET in the final consumer
- **Procedure inlining:** The procedure's INSERT…SELECT body (from CV_BASE_MD_COMPFL_S4 = v_ztsrp_compfl, mandt IN ('110','200'), zweek = @v_week) is inlined. The staging table TBL_WSS_SRP_COMPFLAG is replaced by its source SELECT. CV_COMP_MD_COMPFL_STATIC's projection is applied. The final consumer's filter COMP_VER = @ip_version is also applied here.
- **@v_week:** Derived from SFN_PRIOR_FISCAL_WEEK() (unresolved external function) — documented as runtime parameter

### CV_BASE_MD_RCALWEEK_S4 → CTE 10
- **Expansion point:** CAL_WEEK in the final consumer
- **Logic inlined:** Filter rclnt IN ('120','200')

### CV_BASE_MD_CEPCT_S4 → CTE 12
- **Expansion point:** PROFIT_CENTER_TEXT in the final consumer
- **Logic inlined:** Filter mandt IN ('120','200'); ltext used as profit_center_text

---

## 6. USED / NOT USED Classification

| File | Classification | Reason |
|---|---|---|
| CV_COMP_SKF_BUDGET_STATIC | USED | Final consumer — defines the complete transformation flow |
| CV_BASE_SKF_WEEKLY_BUDGET_S4 | USED | Direct dependency; provides budget quantity data (CTEs 1–3) |
| CV_BASE_MD_HRRP_NODE_S4 | USED | Direct dependency; provides hierarchy filter (CTE 4) |
| CV_BASE_MD_RCALWEEK_S4 | USED | Direct dependency; provides calendar week data (CTE 10) |
| CV_BASE_MD_CEPCT_S4 | USED | Direct dependency; provides profit center text (CTE 12) |
| CV_COMP_MD_SRPACT_STATIC | USED | Direct dependency; provides store attributes (CTE 6) |
| CV_COMP_MD_COMPFL_STATIC | USED | Direct dependency; provides competition flags (CTE 8) |
| STP_WSS_SRP_ATTRIBUTES | USED | Logic provider for staging tables TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG; INSERT…SELECT body inlined into CTEs 6 and 8 |
| CV_BASE_MD_SRPACT_S4 | USED | Source for STP_WSS_SRP_ATTRIBUTES → TBL_WSS_SRP_ATTR_ACT; physical source inlined in CTE 6 |
| CV_BASE_MD_COMPFL_S4 | USED | Source for STP_WSS_SRP_ATTRIBUTES → TBL_WSS_SRP_COMPFLAG; physical source inlined in CTE 8 |

---

## 7. Filter, Join, Aggregation, UNION, and Parameter Trace

### Filters Traced to Output SQL

| Filter | Source File | SQL Location |
|---|---|---|
| fiscvarnt = 'K4' | CV_COMP_SKF_BUDGET_STATIC (WEEKLY_SNAPSHOT_DS05 node) | CTE 3 (WEEKLY_SNAPSHOT_DS05) WHERE clause |
| bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to | CV_COMP_SKF_BUDGET_STATIC | CTE 3 WHERE clause |
| bic_zio_ver = @ip_version | CV_COMP_SKF_BUDGET_STATIC | CTE 3 WHERE clause |
| bic_zio_saudt IN ('1','10') | CV_COMP_SKF_BUDGET_STATIC | CTE 3 WHERE clause |
| bic_zio_pskf IN ('804013','801000') | CV_COMP_SKF_BUDGET_STATIC | CTE 3 WHERE clause |
| mandt IN ('110','200') [DS092/DS031] | CV_BASE_SKF_WEEKLY_BUDGET_S4 | CTEs 1 and 2 WHERE clauses |
| @ip_fc_count != '0' [Frozen] | CV_BASE_SKF_WEEKLY_BUDGET_S4 | CTE 1 WHERE clause |
| @ip_fc_count = '0' [Live] | CV_BASE_SKF_WEEKLY_BUDGET_S4 | CTE 2 WHERE clause |
| mandt IN ('120','200') [HRRP_NODE] | CV_BASE_MD_HRRP_NODE_S4 | CTE 4 WHERE clause |
| REGEXP_CONTAINS(parnode, r'CORERET$') | CV_COMP_SKF_BUDGET_STATIC (HIER_NODE node) | CTE 4 WHERE clause |
| hryvalto = DATE '9999-12-31' | CV_COMP_SKF_BUDGET_STATIC (HIER_NODE node) | CTE 4 WHERE clause |
| mandt IN ('120','200') [ZTSRP_ATTR_ACT] | CV_BASE_MD_SRPACT_S4 (via STP_WSS_SRP_ATTRIBUTES) | CTE 6 WHERE clause |
| mandt IN ('110','200') [ZTSRP_COMPFL] | CV_BASE_MD_COMPFL_S4 (via STP_WSS_SRP_ATTRIBUTES) | CTE 8 WHERE clause |
| zweek = @v_week | STP_WSS_SRP_ATTRIBUTES (procedure INSERT…SELECT) | CTE 8 WHERE clause |
| comp_ver = @ip_version | CV_COMP_SKF_BUDGET_STATIC (COMP_FLAG_BUDGET node) | CTE 8 WHERE clause |
| rclnt IN ('120','200') | CV_BASE_MD_RCALWEEK_S4 | CTE 10 WHERE clause |
| mandt IN ('120','200') [CEPCT] | CV_BASE_MD_CEPCT_S4 | CTE 12 WHERE clause |

### Joins Traced to Output SQL

| Join | Type | Condition | SQL Location |
|---|---|---|---|
| WEEKLY_SNAPSHOT_DS05 × HIER_NODE | INNER JOIN | b631_s_costcntr = nodevalue | CTE 5 (Join_1) |
| Join_1 × STORE_ATTR_ACTUAL | LEFT JOIN | b631_s_proftctr = prctr | CTE 7 (Join_2) |
| Join_2 × COMP_FLAG_BUDGET_SRC | LEFT JOIN | b631_s_proftctr = prctr AND bic_zio_sweek = zweek | CTE 9 (Join_3) |
| Join_3 × CAL_WEEK | LEFT JOIN | bic_zio_sweek = zzweek | CTE 11 (Join_4) |
| Join_4 × PROFIT_CENTER_TEXT | LEFT JOIN | b631_s_proftctr = prctr | CTE 13 (Join_5) |

### Aggregations

| Aggregation | Source | SQL Location |
|---|---|---|
| IF(SUM(FC) IS NULL, SUM(LC), SUM(FC)) AS bic_zio_skfq | CV_BASE_SKF_WEEKLY_BUDGET_S4 (CUBE/Aggregation) | CTE 3 (WEEKLY_SNAPSHOT_DS05) |
| SUM(rx_hrs_oper), SUM(fs_hrs_oper), SUM(rx_store), SUM(retail_sqft_amt), SUM(total_sqft_amt) | CV_COMP_MD_SRPACT_STATIC (CUBE/Aggregation) | CTE 6 (STORE_ATTR_ACTUAL) |
| SUM(bic_zio_skfq) AS bic_zio_skfq_negative | CV_COMP_SKF_BUDGET_STATIC (logicalModel measure) | Final SELECT |
| SUM(cal_bic_zio_skfq) AS bic_zio_skfq | CV_COMP_SKF_BUDGET_STATIC (logicalModel measure) | Final SELECT |

### UNION Branches

| UNION | Source | SQL Location |
|---|---|---|
| FROZEN_CUBE (FLAG='FC') UNION ALL LIVE_CUBE (FLAG='LC') | CV_BASE_SKF_WEEKLY_BUDGET_S4 (Union_1 node) | Inline subquery inside CTE 3 |

### Calculated Columns

| Calculated Column | Formula | Source | SQL Location |
|---|---|---|---|
| cal_week_number | RIGHT(bic_zio_sweek, 2) | CV_COMP_SKF_BUDGET_STATIC (FLAGS node) | CTE 14 (FLAGS) |
| cal_bic_zio_skfq | CASE WHEN bic_zio_pskf='804013' THEN bic_zio_skfq*2 ELSE bic_zio_skfq END | CV_COMP_SKF_BUDGET_STATIC (FLAGS node) | CTE 14 (FLAGS) |
| cal_rx_comp_wk | CASE WHEN rx_comp_wk IS NULL THEN '0' ELSE rx_comp_wk END | CV_COMP_SKF_BUDGET_STATIC (FLAGS node) | CTE 14 (FLAGS) |

---

## 8. Alias Check Results

### Physical Column Aliases — Removed (Redundant/HANA-name)
All physical columns use their exact `BQ_COLUMN` values from Columns_Mapping.csv. No HANA-name aliases (e.g., `_BIC_ZIO_SWEEK`, `_B631_S_PROFTCTR`) remain in the output. All leading underscores and `/` prefixes have been removed per the mapping rules.

### Meaningful Renames Retained
| Expression | Alias | Reason |
|---|---|---|
| cal_rx_comp_wk | rx_comp_wk | Output contract alias per CV_COMP_SKF_BUDGET_STATIC logicalModel |
| flag | skf_bud_cube | Output contract alias per CV_COMP_SKF_BUDGET_STATIC logicalModel |
| ltext | profit_center_text | Semantic rename: ltext is the long text column used as profit center description |
| bic_zio_pctr | b631_s_proftctr | Union mapping in CV_BASE_SKF_WEEKLY_BUDGET_S4 (Live Cube) |
| bic_zio_cctr | b631_s_costcntr | Union mapping in CV_BASE_SKF_WEEKLY_BUDGET_S4 (Live Cube) |

---

## 9. Table and Column Mapping Applied

### Physical Sources After Full Expansion

| HANA Table | BQ_FULL_TABLE | Used In |
|---|---|---|
| AZSRP_DS092_VT_S4 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds092 | CTE 1 (FROZEN_CUBE) |
| AZSRP_DS031_VT_S4 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds031 | CTE 2 (LIVE_CUBE) |
| HRRP_NODE | edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node | CTE 4 (HIER_NODE) |
| ZTSRP_ATTR_ACT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act | CTE 6 (STORE_ATTR_ACTUAL) |
| ZTSRP_COMPFL | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl | CTE 8 (COMP_FLAG_BUDGET_SRC) |
| ZTFIGL_RCALWEEK | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek | CTE 10 (CAL_WEEK) |
| CEPCT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct | CTE 12 (PROFIT_CENTER_TEXT) |

### Key Column Mappings Applied (HANA → BQ_COLUMN)

**AZSRP_DS092_VT_S4 / v_bic_azsrp_ds092:**
- `_B631_S_PROFTCTR` → `b631_s_proftctr`
- `_B631_S_COSTCNTR` → `b631_s_costcntr`
- `_B631_S_CO_AREA` → `b631_s_co_area`
- `_BIC_ZIO_SWEEK` → `bic_zio_sweek`
- `_BIC_ZIO_SKFQ` → `bic_zio_skfq`
- `_BIC_ZIO_PSKF` → `bic_zio_pskf`
- `_BIC_ZIO_VER` → `bic_zio_ver`
- `_BIC_ZIO_SAUDT` → `bic_zio_saudt`
- `_BIC_ZIO_PSTY` → `bic_zio_psty`
- `_BIC_ZIO_CMPCD` → `bic_zio_cmpcd`
- `_B631_S_CHRTACCT` → `b631_s_chrtacct`
- `_B631_S_FUNCAREA` → `b631_s_funcarea`

**AZSRP_DS031_VT_S4 / v_bic_azsrp_ds031:**
- `_BIC_ZIO_PCTR` → `bic_zio_pctr` (then aliased to `b631_s_proftctr` per union mapping)
- `_BIC_ZIO_CCTR` → `bic_zio_cctr` (then aliased to `b631_s_costcntr` per union mapping)
- `_BIC_ZIO_SKFQ` → `bic_zio_skfq`

**HRRP_NODE / v_hrrp_node:**
- `PARNODE` → `parnode`
- `HRYVALTO` → `hryvalto` (BQ_DATATYPE: DATE)
- `NODEVALUE` → `nodevalue`
- `MANDT` → `mandt` (BQ_DATATYPE: STRING)

**ZTSRP_ATTR_ACT / v_ztsrp_attr_act:**
- `PRCTR` → `prctr`
- `STRNUM` → `strnum`
- `REP_MKT_CODE` → `rep_mkt_code`
- `EMERG_MKT_IND` → `emerg_mkt_ind`
- `RX_HRS_OPER` → `rx_hrs_oper` (BQ_DATATYPE: NUMERIC, measure)
- `FS_HRS_OPER` → `fs_hrs_oper` (BQ_DATATYPE: NUMERIC, measure)
- `RX_STORE` → `rx_store` (BQ_DATATYPE: INT64, measure)
- `RETAIL_SQFT_AMT` → `retail_sqft_amt` (BQ_DATATYPE: NUMERIC, measure)
- `TOTAL_SQFT_AMT` → `total_sqft_amt` (BQ_DATATYPE: NUMERIC, measure)
- All other 62 columns mapped 1:1

**ZTSRP_COMPFL / v_ztsrp_compfl:**
- `ZWEEK` → `zweek` (BQ_DATATYPE: STRING)
- `COMP_VER` → `comp_ver`
- `RX_COMP_WK` → `rx_comp_wk`
- `PRCTR` → `prctr`
- `MANDT` → `mandt` (BQ_DATATYPE: STRING)

**ZTFIGL_RCALWEEK / v_ztfigl_rcalweek:**
- `ZZWEEK` → `zzweek` (BQ_DATATYPE: STRING)
- `ZRWSTRTDATE` → `zrwstrtdate` (BQ_DATATYPE: DATE)
- `ZRWENDDATE` → `zrwenddate` (BQ_DATATYPE: DATE)
- `RCLNT` → `rclnt` (BQ_DATATYPE: STRING)

**CEPCT / v_cepct:**
- `PRCTR` → `prctr`
- `LTEXT` → `ltext`
- `MANDT` → `mandt` (BQ_DATATYPE: STRING)

### Data Type Casts and Literal Conversions Applied

| Location | Original | Converted | BQ_DATATYPE | Reason |
|---|---|---|---|---|
| CTE 1, CTE 2 — mandt filter | `MANDT IN (110, 200)` (numeric in HANA) | `mandt IN ('110', '200')` | STRING | BQ_DATATYPE for mandt (AZSRP_DS092/DS031) = STRING |
| CTE 4 — mandt filter | `MANDT IN (120, 200)` (numeric in HANA) | `mandt IN ('120', '200')` | STRING | BQ_DATATYPE for mandt (HRRP_NODE) = STRING |
| CTE 4 — hryvalto filter | `HRYVALTO = '99991231'` (HANA DATS string) | `hryvalto = DATE '9999-12-31'` | DATE | BQ_DATATYPE for hryvalto = DATE; HANA DATS format YYYYMMDD converted to ISO |
| CTE 6 — mandt filter | `MANDT IN (120, 200)` (numeric in HANA) | `mandt IN ('120', '200')` | STRING | BQ_DATATYPE for mandt (ZTSRP_ATTR_ACT) = STRING |
| CTE 8 — mandt filter | `MANDT IN (110, 200)` (numeric in HANA) | `mandt IN ('110', '200')` | STRING | BQ_DATATYPE for mandt (ZTSRP_COMPFL) = STRING |
| CTE 10 — rclnt filter | `RCLNT IN (120, 200)` (numeric in HANA) | `rclnt IN ('120', '200')` | STRING | BQ_DATATYPE for rclnt (ZTFIGL_RCALWEEK) = STRING |
| CTE 12 — mandt filter | `MANDT IN (120, 200)` (numeric in HANA) | `mandt IN ('120', '200')` | STRING | BQ_DATATYPE for mandt (CEPCT) = STRING |
| CTE 3 — bic_zio_saudt filter | `_BIC_ZIO_SAUDT IN (1, 10)` | `bic_zio_saudt IN ('1', '10')` | STRING | BQ_DATATYPE for bic_zio_saudt (AZSRP_DS092/DS031) = STRING |
| CTE 3 — bic_zio_pskf filter | `_BIC_ZIO_PSKF IN (804013, 801000)` | `bic_zio_pskf IN ('804013', '801000')` | STRING | BQ_DATATYPE for bic_zio_pskf (AZSRP_DS092/DS031) = STRING |
| CTE 14 — cal_bic_zio_skfq | `_BIC_ZIO_PSKF = '804013'` | `bic_zio_pskf = '804013'` | STRING | Already string in CTE 3 filter; consistent |
| CTE 14 — bic_zio_skfq * 2 | FLOAT64 * 2 | FLOAT64 (no cast needed) | FLOAT64 | BQ_DATATYPE for bic_zio_skfq (AZSRP_DS092) = FLOAT64 |

---

## 10. Procedure/ETL Handling

### STP_WSS_SRP_ATTRIBUTES Inlining

The stored procedure STP_WSS_SRP_ATTRIBUTES performs:
1. DELETE all from TBL_WSS_SRP_ATTR_ACT
2. INSERT INTO TBL_WSS_SRP_ATTR_ACT SELECT * FROM CV_BASE_MD_SRPACT_S4 (no WHERE on week)
3. DELETE all from TBL_WSS_SRP_COMPFLAG
4. INSERT INTO TBL_WSS_SRP_COMPFLAG SELECT * FROM CV_BASE_MD_COMPFL_S4 WHERE ZWEEK = V_WEEK

**Inlining applied:**
- The DELETE + INSERT pattern is a full-table replacement. The SELECT body is inlined at the point of consumption.
- **TBL_WSS_SRP_ATTR_ACT** → replaced by SELECT from `v_ztsrp_attr_act` WHERE mandt IN ('120','200') + CV_COMP_MD_SRPACT_STATIC aggregation (CTE 6)
- **TBL_WSS_SRP_COMPFLAG** → replaced by SELECT from `v_ztsrp_compfl` WHERE mandt IN ('110','200') AND zweek = @v_week + CV_COMP_MD_COMPFL_STATIC projection + CV_COMP_SKF_BUDGET_STATIC's comp_ver = @ip_version filter (CTE 8)
- **Audit columns** (SNAPSHOT_TIMESTAMP, SNAPSHOT_CREATED_BY, CREATED_BY): Not referenced by any downstream layer — omitted per rules
- **DML wrappers** (DELETE, INSERT INTO): Skipped per rules

### Procedure SELECT Bodies Inlined

| Staging Table | Procedure File | SELECT Inlined | Filters Carried |
|---|---|---|---|
| TBL_WSS_SRP_ATTR_ACT | STP_WSS_SRP_ATTRIBUTES | SELECT from v_ztsrp_attr_act | mandt IN ('120','200') |
| TBL_WSS_SRP_COMPFLAG | STP_WSS_SRP_ATTRIBUTES | SELECT from v_ztsrp_compfl | mandt IN ('110','200'); zweek = @v_week |

---

## 11. Runtime Parameters

| Parameter | Type | Compared With | Source | Usage |
|---|---|---|---|---|
| `@ip_version` | STRING | bic_zio_ver (STRING), comp_ver (STRING) | CV_COMP_SKF_BUDGET_STATIC input parameter | Filter in WEEKLY_SNAPSHOT_DS05 (bic_zio_ver = @ip_version) and COMP_FLAG_BUDGET_SRC (comp_ver = @ip_version) |
| `@ip_week_ending_from` | STRING | bic_zio_sweek (STRING) | CV_COMP_SKF_BUDGET_STATIC input parameter | BETWEEN filter in WEEKLY_SNAPSHOT_DS05 |
| `@ip_week_ending_to` | STRING | bic_zio_sweek (STRING) | CV_COMP_SKF_BUDGET_STATIC input parameter | BETWEEN filter in WEEKLY_SNAPSHOT_DS05 |
| `@ip_fc_count` | STRING | Literal '0' | CV_BASE_SKF_WEEKLY_BUDGET_S4; derived from SFN_SKF_FC_FLAG(IP_VERSION) — unresolved external function | Frozen vs. Live Cube selection (CTEs 1 and 2) |
| `@v_week` | STRING | zweek (STRING) | STP_WSS_SRP_ATTRIBUTES; derived from SFN_PRIOR_FISCAL_WEEK() — unresolved external function | Competition flag week filter (CTE 8) |

**Non-blocking findings:**
- `@ip_fc_count`: The function `CVS_FRIP.Composite.Master::SFN_SKF_FC_FLAG` is not defined in any supplied file. Its role is clear (determines frozen vs. live cube selection). Replaced with `@ip_fc_count` runtime parameter.
- `@v_week`: The function `CVS_FRIP.CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK` is not defined in any supplied file. Its role is clear (returns prior fiscal week for competition flag loading). Replaced with `@v_week` runtime parameter.

---

## 12. CTE/Helper Mapping

| CTE Name | Sequence | Origin | Justification |
|---|---|---|---|
| FROZEN_CUBE | 1 | CV_BASE_SKF_WEEKLY_BUDGET_S4 | Required semantic boundary: separate filter (@ip_fc_count != '0') for Frozen Cube source |
| LIVE_CUBE | 2 | CV_BASE_SKF_WEEKLY_BUDGET_S4 | Required semantic boundary: separate filter (@ip_fc_count = '0') for Live Cube source; different column mapping (bic_zio_pctr → b631_s_proftctr) |
| WEEKLY_SNAPSHOT_DS05 | 3 | CV_COMP_SKF_BUDGET_STATIC + CV_BASE_SKF_WEEKLY_BUDGET_S4 | Required: UNION ALL + conditional aggregation + final consumer filters; preserves final consumer CTE name |
| HIER_NODE | 4 | CV_COMP_SKF_BUDGET_STATIC + CV_BASE_MD_HRRP_NODE_S4 | Required: hierarchy filter; preserves final consumer CTE name |
| Join_1 | 5 | CV_COMP_SKF_BUDGET_STATIC | Required: INNER JOIN semantic boundary (restricts to CORERET hierarchy) |
| STORE_ATTR_ACTUAL | 6 | CV_COMP_SKF_BUDGET_STATIC + CV_COMP_MD_SRPACT_STATIC + STP_WSS_SRP_ATTRIBUTES + CV_BASE_MD_SRPACT_S4 | Required: aggregation boundary (SUM measures); preserves final consumer CTE name |
| Join_2 | 7 | CV_COMP_SKF_BUDGET_STATIC | Required: LEFT JOIN with store attributes |
| COMP_FLAG_BUDGET_SRC | 8 | CV_COMP_SKF_BUDGET_STATIC + CV_COMP_MD_COMPFL_STATIC + STP_WSS_SRP_ATTRIBUTES + CV_BASE_MD_COMPFL_S4 | Required: procedure filter (zweek = @v_week) + version filter; renamed from COMP_FLAG_BUDGET to avoid collision with inline logic |
| Join_3 | 9 | CV_COMP_SKF_BUDGET_STATIC | Required: LEFT JOIN with competition flags |
| CAL_WEEK | 10 | CV_COMP_SKF_BUDGET_STATIC + CV_BASE_MD_RCALWEEK_S4 | Required: calendar week lookup; preserves final consumer CTE name |
| Join_4 | 11 | CV_COMP_SKF_BUDGET_STATIC | Required: LEFT JOIN with calendar week |
| PROFIT_CENTER_TEXT | 12 | CV_COMP_SKF_BUDGET_STATIC + CV_BASE_MD_CEPCT_S4 | Required: profit center text lookup; preserves final consumer CTE name |
| Join_5 | 13 | CV_COMP_SKF_BUDGET_STATIC | Required: LEFT JOIN with profit center text |
| FLAGS | 14 | CV_COMP_SKF_BUDGET_STATIC | Required: calculated columns (cal_week_number, cal_bic_zio_skfq, cal_rx_comp_wk) must be computed before final aggregation; preserves final consumer CTE name |

---

## 13. Duplicate, Ambiguous-Column, Parent-Availability, and Aggregation Validation

- **Duplicate aliases:** No duplicate column aliases exist within any single SELECT. Each CTE outputs a unique set of column names.
- **Ambiguous column references:** All columns in multi-input CTEs (Join_1 through Join_5) are fully qualified with their input alias (j., s., c., cw., pct.).
- **Parent availability:** Every column referenced in each CTE exists in its parent CTE's output. Verified by tracing each column from its physical source through the CTE chain.
- **Aggregation grain:** 
  - WEEKLY_SNAPSHOT_DS05: GROUP BY all non-measure columns; SUM(FC)/SUM(LC) conditional measure — preserves CV_BASE_SKF_WEEKLY_BUDGET_S4 CUBE grain
  - STORE_ATTR_ACTUAL: GROUP BY all non-measure columns; SUM on 5 measures — preserves CV_COMP_MD_SRPACT_STATIC CUBE grain
  - Final SELECT: GROUP BY all non-measure output columns; SUM(bic_zio_skfq) and SUM(cal_bic_zio_skfq) — preserves CV_COMP_SKF_BUDGET_STATIC CUBE grain

---

## 14. Star Projection Validation

No `SELECT *` or `alias.*` projections remain in the final consolidated SQL. All columns are explicitly listed in every CTE and the final SELECT.

---

## 15. CTE Documentation Comment Validation

All 14 CTEs have standardized comment headers with:
- Sequential CTE number and name
- Logic description (consolidated, not per-node)
- Source, Filters, Join, Aggregation, and Calculation sections where applicable
- No extra CTEs created solely for documentation purposes

---

## 16. Final Quality Gate Results

| Check | Result |
|---|---|
| 1. Final consumer unambiguous | ✅ CV_COMP_SKF_BUDGET_STATIC |
| 2. Artifact dependencies match lineage table | ✅ All 10 lineage edges represented |
| 3. Final-consumer transformation order preserved | ✅ WEEKLY_SNAPSHOT_DS05 → HIER_NODE → Join_1 → STORE_ATTR_ACTUAL → Join_2 → COMP_FLAG_BUDGET → Join_3 → CAL_WEEK → Join_4 → PROFIT_CENTER_TEXT → Join_5 → FLAGS → Final SELECT |
| 4. Dependencies expanded at point of consumption | ✅ Each dependency expanded inline at its first use |
| 5. No generic Source→Intermediate→Target ordering | ✅ Follows actual node sequence |
| 6. Every file classified USED/NOT USED | ✅ All 10 files: USED |
| 7. Every USED file participates in dependency chain | ✅ Verified |
| 8. All converted dependencies expanded | ✅ No intermediate object remains referenced only by name |
| 9. Only terminal sources remain | ✅ 7 physical BQ tables |
| 10. Every physical source uses BQ_FULL_TABLE | ✅ No PROJECT.DATASET placeholders remain |
| 11. Every referenced physical-source column mapped via Columns_Mapping | ✅ All columns verified against full CSV |
| 12. Type consistency in all comparisons | ✅ All mandt/rclnt filters converted to STRING; hryvalto converted to DATE literal; bic_zio_saudt and bic_zio_pskf filters converted to STRING |
| 13. Final-consumer CTE names preserved | ✅ WEEKLY_SNAPSHOT_DS05, HIER_NODE, STORE_ATTR_ACTUAL, CAL_WEEK, PROFIT_CENTER_TEXT, FLAGS all preserved |
| 14. Compatible operations combined | ✅ Projection+filter nodes combined into functional CTEs |
| 15. No source node becomes separate CTE merely to mirror source | ✅ |
| 16. Every helper CTE justified by real semantic boundary | ✅ |
| 17. Every CTE matches required output contract | ✅ |
| 18. Column references qualified where multiple inputs in scope | ✅ |
| 19. No duplicate alias within a SELECT | ✅ |
| 20. No star projections remain | ✅ |
| 21. Filters, joins, calculations, mappings, parameters preserved | ✅ |
| 22. Aggregation grain preserved at each stage | ✅ |
| 23. DISTINCT, UNION, window behavior preserved | ✅ UNION ALL preserved; no DISTINCT or window functions in source |
| 24. No conflict silently corrected | ✅ All corrections documented |
| 25. No result-affecting procedural behavior discarded | ✅ zweek = @v_week filter from procedure preserved in CTE 8 |
| 26. Runtime parameters documented; no DECLARE/SET in output | ✅ 5 parameters documented; SQL starts with WITH |
| 27. Every CTE has standardized comment header | ✅ |
| 28. CTE comments describe consolidated logic | ✅ |
| 29. Complete query achieves 100% logic match with minimum CTEs | ✅ |
| 30. Every lineage edge represented by correct supplied logic | ✅ |
| 31. Every filter/join/aggregation/UNION/parameter traced to output | ✅ |
| 32. Every physical-column output uses exact BQ_COLUMN | ✅ |

---

## 17. Issues to Fix (Non-Blocking)

### Issue 1: @ip_fc_count — Unresolved External Function
- **Artifact:** CV_BASE_SKF_WEEKLY_BUDGET_S4
- **Function:** `CVS_FRIP.Composite.Master::SFN_SKF_FC_FLAG(IP_VERSION)`
- **Impact:** The value of @ip_fc_count determines whether FROZEN_CUBE or LIVE_CUBE data is used. The function definition is not in any supplied file.
- **Resolution needed:** Implement `SFN_SKF_FC_FLAG` as a BigQuery UDF or provide the logic to compute the frozen forecast count from IP_VERSION. Until resolved, @ip_fc_count must be supplied as a runtime parameter.
- **Classification:** Non-blocking (runtime parameter documented)

### Issue 2: @v_week — Unresolved External Function
- **Artifact:** STP_WSS_SRP_ATTRIBUTES
- **Function:** `CVS_FRIP.CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK()`
- **Impact:** The value of @v_week determines which week's competition flags are loaded into TBL_WSS_SRP_COMPFLAG. The function definition is not in any supplied file.
- **Resolution needed:** Implement `SFN_PRIOR_FISCAL_WEEK` as a BigQuery UDF or provide the prior fiscal week computation logic. Until resolved, @v_week must be supplied as a runtime parameter.
- **Classification:** Non-blocking (runtime parameter documented)

### Issue 3: PARNODE Pattern Match Approximation
- **Artifact:** CV_COMP_SKF_BUDGET_STATIC (HIER_NODE node)
- **HANA function:** `match(PARNODE, '*CORERET')` — HANA wildcard match with trailing pattern
- **BigQuery equivalent used:** `REGEXP_CONTAINS(parnode, r'CORERET$')` — regex suffix match
- **Impact:** If the HANA `match()` function with `*CORERET` means "ends with CORERET", the regex is correct. If it means "contains CORERET anywhere", the regex should be `r'CORERET'`. The exact semantics of HANA `match()` with a leading `*` wildcard should be validated.
- **Resolution needed:** Confirm whether `match(PARNODE, '*CORERET')` means suffix match or contains match, and adjust the regex if needed.
- **Classification:** Non-blocking (approximation documented; suffix match is the most common interpretation of `*CORERET`)

---

*This consolidation description was generated by the BigQuery SQL Consolidation Agent. The SQL is complete and traceable from all supplied inputs. The three issues above are non-blocking and do not prevent execution; they require runtime parameter values or validation of one regex pattern.*
