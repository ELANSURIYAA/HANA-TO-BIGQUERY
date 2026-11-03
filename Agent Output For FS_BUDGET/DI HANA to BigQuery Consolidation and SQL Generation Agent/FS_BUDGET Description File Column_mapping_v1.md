# FS_BUDGET Consolidation Description
## BigQuery SQL Consolidation Agent — Output 2

---

## 1. Final Consumer Identification

**Final Consumer:** `CV_COMP_FIN_BUDGET_STATIC`

This is the terminal consumer-facing artifact in the dependency chain. All other artifacts feed into it directly or transitively. It is a HANA Calculation View of type CUBE/Aggregation that produces the weekly financial budget dataset for downstream reporting.

---

## 2. Lineage Rows Read

All 10 rows from `FS_BUDGET Latest Relationships Table` were read:

| Source File | Target File | Dependency Type |
|---|---|---|
| CV_BASE_MD_SRPACT_S4 | STP_WSS_SRP_ATTRIBUTES | Source Dependency |
| CV_BASE_MD_COMPFL_S4 | STP_WSS_SRP_ATTRIBUTES | Source Dependency |
| STP_WSS_SRP_ATTRIBUTES | CV_COMP_MD_SRPACT_STATIC | Stored Procedure Dependency |
| STP_WSS_SRP_ATTRIBUTES | CV_COMP_MD_COMPFL_STATIC | Stored Procedure Dependency |
| CV_BASE_FIN_WEEKLY_BUDGET_S4 | CV_COMP_FIN_BUDGET_STATIC | Calculation View Dependency |
| CV_BASE_MD_HRRP_NODE_S4 | CV_COMP_FIN_BUDGET_STATIC | Calculation View Dependency |
| CV_COMP_MD_SRPACT_STATIC | CV_COMP_FIN_BUDGET_STATIC | Calculation View Dependency |
| CV_COMP_MD_COMPFL_STATIC | CV_COMP_FIN_BUDGET_STATIC | Calculation View Dependency |
| CV_BASE_MD_RCALWEEK_S4 | CV_COMP_FIN_BUDGET_STATIC | Calculation View Dependency |
| CV_BASE_MD_CEPCT_S4 | CV_COMP_FIN_BUDGET_STATIC | Calculation View Dependency |

---

## 3. Files in FS_BUDGET Latest Bigqueries — USED / NOT USED Classification

| File | Classification | Reason |
|---|---|---|
| CV_COMP_FIN_BUDGET_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Final consumer; defines the complete transformation flow |
| CV_BASE_FIN_WEEKLY_BUDGET_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency of CV_COMP_FIN_BUDGET_STATIC; provides WEEKLY_SNAPSHOT_DS05 |
| CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency; provides HIER_NODE for CORE_RET filter |
| CV_COMP_MD_SRPACT_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency; provides STORE_ATTR_ACTUAL (reads TBL_WSS_SRP_ATTR_ACT) |
| CV_COMP_MD_COMPFL_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency; provides COMP_FLAG_BUDGET (reads TBL_WSS_SRP_COMPFLAG) |
| CV_BASE_MD_RCALWEEK_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency; provides CAL_WEEK for week date enrichment |
| CV_BASE_MD_CEPCT_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency; provides PROFIT_CENTER_TEXT |
| STP_WSS_SRP_ATTRIBUTES_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Stored procedure that populates TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG; its INSERT…SELECT logic and filters (zweek = @v_week) are inlined into STORE_ATTR_ACTUAL and COMP_FLAG_BUDGET |
| CV_BASE_MD_SRPACT_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Source of STP_WSS_SRP_ATTRIBUTES INSERT into TBL_WSS_SRP_ATTR_ACT; its filter (mandt IN ('120','200')) and aggregation logic are inlined into STORE_ATTR_ACTUAL |
| CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Source of STP_WSS_SRP_ATTRIBUTES INSERT into TBL_WSS_SRP_COMPFLAG; its filter (mandt IN ('110','200')) is inlined into COMP_FLAG_BUDGET |

**All 10 files are USED.** No files are NOT USED.

---

## 4. Columns_Mapping Rows Read

The full Columns_Mapping.csv was read. It contains mappings for the following HANA tables referenced in the dependency chain:

| HANA Table | BQ_FULL_TABLE | Rows |
|---|---|---|
| CEPCT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct | 8 |
| ZTFIGL_RCALWEEK | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek | 9 |
| ZTSRP_COMPFL | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl | 13 |
| ZTSRP_ATTR_ACT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act | ~70 |
| HRRP_NODE | edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node | 12 |
| AZSRP_DS041_VT_S4 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds041 | 20 |
| AZSRP_DS052_VT_S4 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds202 | 19 |

All other tables in the CSV (AZSRP_DS112_VT_S4, AZSRP_DS072_VT_S4, AZSRP_DS092_VT_S4, AZSRP_DS031_VT_S4, ACDOCA_VT_S4, BKPF, FAGLSKF_PN) are **not referenced** by the expanded SQL of the final consumer and are ignored per instructions.

---

## 5. Artifact Dependency Mapping and Lineage Edges

### Lineage Edge Trace

| Producer | Consumer | Resulting SQL Location |
|---|---|---|
| CV_BASE_FIN_WEEKLY_BUDGET_S4 | CV_COMP_FIN_BUDGET_STATIC | CTEs 1–4 (Frozen_Cube, Live_Cube, Aggregated_Weekly_Budget_Snapshot, WEEKLY_SNAPSHOT_DS05) |
| CV_BASE_MD_HRRP_NODE_S4 | CV_COMP_FIN_BUDGET_STATIC | CTE 5 (HIER_NODE) |
| CV_COMP_MD_SRPACT_STATIC | CV_COMP_FIN_BUDGET_STATIC | CTE 7 (STORE_ATTR_ACTUAL) |
| CV_COMP_MD_COMPFL_STATIC | CV_COMP_FIN_BUDGET_STATIC | CTE 9 (COMP_FLAG_BUDGET) |
| CV_BASE_MD_RCALWEEK_S4 | CV_COMP_FIN_BUDGET_STATIC | CTE 11 (CAL_WEEK) |
| CV_BASE_MD_CEPCT_S4 | CV_COMP_FIN_BUDGET_STATIC | CTE 13 (PROFIT_CENTER_TEXT) |
| STP_WSS_SRP_ATTRIBUTES | CV_COMP_MD_SRPACT_STATIC | Inlined into CTE 7 (STORE_ATTR_ACTUAL): procedure's INSERT SELECT from CV_BASE_MD_SRPACT_S4 → v_ztsrp_attr_act |
| STP_WSS_SRP_ATTRIBUTES | CV_COMP_MD_COMPFL_STATIC | Inlined into CTE 9 (COMP_FLAG_BUDGET): procedure's INSERT SELECT from CV_BASE_MD_COMPFL_S4 WHERE zweek = @v_week → v_ztsrp_compfl |
| CV_BASE_MD_SRPACT_S4 | STP_WSS_SRP_ATTRIBUTES | Inlined into CTE 7 (STORE_ATTR_ACTUAL): source of procedure's INSERT into TBL_WSS_SRP_ATTR_ACT |
| CV_BASE_MD_COMPFL_S4 | STP_WSS_SRP_ATTRIBUTES | Inlined into CTE 9 (COMP_FLAG_BUDGET): source of procedure's INSERT into TBL_WSS_SRP_COMPFLAG |

---

## 6. Final Consumer Flow / Node Sequence

The CV_COMP_FIN_BUDGET_STATIC transformation flow is preserved exactly:

1. **WEEKLY_SNAPSHOT_DS05** — Projection from CV_BASE_FIN_WEEKLY_BUDGET_S4 with filters: fiscvarnt='K4', bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to, bic_zio_ver=@ip_version, bic_zio_saudt IN ('1','10')
2. **HIER_NODE** — Projection from CV_BASE_MD_HRRP_NODE_S4, filter: PARNODE ends with 'CORE_RET' AND hryvalto = DATE '9999-12-31'
3. **Join_1 / ONLY_CORE_RET_DATA** — INNER JOIN WEEKLY_SNAPSHOT_DS05 × HIER_NODE on b631_s_proftctr = nodevalue
4. **STORE_ATTR_ACTUAL** — Projection/aggregation from CV_COMP_MD_SRPACT_STATIC (inlined to v_ztsrp_attr_act)
5. **Join_2** — LEFT JOIN ONLY_CORE_RET_DATA × STORE_ATTR_ACTUAL on b631_s_proftctr = prctr; also computes cal_store_week_number (WEEK_NUMBER node combined)
6. **COMP_FLAG_BUDGET** — Projection from CV_COMP_MD_COMPFL_STATIC with filter comp_ver = @ip_version (inlined to v_ztsrp_compfl)
7. **Join_3** — LEFT JOIN Join_2 × COMP_FLAG_BUDGET on (b631_s_proftctr = prctr AND bic_zio_sweek = zweek)
8. **CAL_WEEK** — Projection from CV_BASE_MD_RCALWEEK_S4 (inlined to v_ztfigl_rcalweek)
9. **Join_4** — LEFT JOIN Join_3 × CAL_WEEK on bic_zio_sweek = zzweek
10. **PROFIT_CENTER_TEXT** — Projection from CV_BASE_MD_CEPCT_S4 (inlined to v_cepct)
11. **Join_5** — LEFT JOIN Join_4 × PROFIT_CENTER_TEXT on b631_s_proftctr = prctr
12. **FLAGS** — Projection adding cal_fs_rx_flag, cal_comp_flag, cal_week_number, b631_s_amount
13. **Final SELECT** — Aggregation (CUBE): GROUP BY all non-measures, SUM measures

---

## 7. Dependency Expansion and Point-of-Consumption Mapping

### CV_BASE_FIN_WEEKLY_BUDGET_S4 → Expanded at WEEKLY_SNAPSHOT_DS05 (CTEs 1–4)
- Frozen_Cube reads `v_bic_azsrp_ds202` (AZSRP_DS052_VT_S4) with mandt IN ('110','200') and @ip_fc_count != '0', FLAG='FC'
- Live_Cube reads `v_bic_azsrp_ds041` (AZSRP_DS041_VT_S4) with mandt IN ('110','200') and @ip_fc_count = '0', FLAG='LC'; remaps bic_zio_pctr→b631_s_proftctr, bic_zio_cctr→b631_s_costcntr
- UNION ALL → Aggregated_Weekly_Budget_Snapshot (intermediate aggregation with FLAG retained)
- WEEKLY_SNAPSHOT_DS05 applies consumer filters and FC/LC precedence logic

### CV_BASE_MD_HRRP_NODE_S4 → Expanded at HIER_NODE (CTE 5)
- Reads `v_hrrp_node` with mandt IN ('120','200'), REGEXP_CONTAINS(parnode, r'CORE_RET$'), hryvalto = DATE '9999-12-31'

### STP_WSS_SRP_ATTRIBUTES → Inlined at STORE_ATTR_ACTUAL and COMP_FLAG_BUDGET
- The procedure's INSERT…SELECT for TBL_WSS_SRP_ATTR_ACT is replaced by reading v_ztsrp_attr_act directly (the terminal physical source of CV_BASE_MD_SRPACT_S4), with mandt IN ('120','200') and CUBE aggregation
- The procedure's INSERT…SELECT for TBL_WSS_SRP_COMPFLAG (WHERE zweek = @v_week) is replaced by reading v_ztsrp_compfl directly (terminal source of CV_BASE_MD_COMPFL_S4), with mandt IN ('110','200') AND zweek = @v_week AND comp_ver = @ip_version

### CV_COMP_MD_SRPACT_STATIC → Expanded at STORE_ATTR_ACTUAL (CTE 7)
- Reads `v_ztsrp_attr_act` with mandt IN ('120','200'); CUBE aggregation with SUM on rx_hrs_oper, fs_hrs_oper, rx_store, retail_sqft_amt, total_sqft_amt

### CV_COMP_MD_COMPFL_STATIC → Expanded at COMP_FLAG_BUDGET (CTE 9)
- Reads `v_ztsrp_compfl` with mandt IN ('110','200') AND zweek = @v_week AND comp_ver = @ip_version

### CV_BASE_MD_RCALWEEK_S4 → Expanded at CAL_WEEK (CTE 11)
- Reads `v_ztfigl_rcalweek` with rclnt IN ('120','200')

### CV_BASE_MD_CEPCT_S4 → Expanded at PROFIT_CENTER_TEXT (CTE 13)
- Reads `v_cepct` with mandt IN ('120','200'); aliases ltext AS profit_center_text

---

## 8. Procedure/ETL Handling — STP_WSS_SRP_ATTRIBUTES

The stored procedure STP_WSS_SRP_ATTRIBUTES performs:
1. DELETE all from TBL_WSS_SRP_ATTR_ACT → **Skipped** (DML wrapper, not part of SELECT logic)
2. DELETE all from TBL_WSS_SRP_COMPFLAG → **Skipped** (DML wrapper)
3. INSERT INTO TBL_WSS_SRP_ATTR_ACT SELECT … FROM CV_BASE_MD_SRPACT_S4 → **Inlined** into STORE_ATTR_ACTUAL: reads v_ztsrp_attr_act (terminal source of CV_BASE_MD_SRPACT_S4) with mandt IN ('120','200')
4. INSERT INTO TBL_WSS_SRP_COMPFLAG SELECT … FROM CV_BASE_MD_COMPFL_S4 WHERE ZWEEK = V_WEEK → **Inlined** into COMP_FLAG_BUDGET: reads v_ztsrp_compfl with mandt IN ('110','200') AND zweek = @v_week
5. SNAPSHOT_TIMESTAMP (CURRENT_TIMESTAMP) and SNAPSHOT_CREATED_BY (SESSION_USER) → **Dropped** (audit-only columns not used by downstream logic)
6. V_LY_WEEK → **Dropped** (unused in source logic per procedure file)

The procedure's filter `ZWEEK = V_WEEK` is preserved as `zweek = @v_week` in COMP_FLAG_BUDGET. The ATTR table has no week filter in the procedure (all rows inserted).

---

## 9. Table and Column Mapping Applied

### Physical Tables Referenced and Their BQ_FULL_TABLE

| HANA Table | BQ_FULL_TABLE |
|---|---|
| AZSRP_DS052_VT_S4 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds202 |
| AZSRP_DS041_VT_S4 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds041 |
| HRRP_NODE | edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node |
| ZTSRP_ATTR_ACT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act |
| ZTSRP_COMPFL | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl |
| ZTFIGL_RCALWEEK | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek |
| CEPCT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct |

### Key Column Mappings Applied (HANA → BQ_COLUMN)

**AZSRP_DS052_VT_S4 (v_bic_azsrp_ds202):**
- _B631_S_AMOUNT → b631_s_amount (NUMERIC)
- _B631_S_CHRTACCT → b631_s_chrtacct (STRING)
- _B631_S_COSTCNTR → b631_s_costcntr (STRING)
- _B631_S_CO_AREA → b631_s_co_area (STRING)
- _B631_S_FUNCAREA → b631_s_funcarea (STRING)
- _B631_S_GL_ACCT → b631_s_gl_acct (STRING)
- _B631_S_PROFTCTR → b631_s_proftctr (STRING)
- _BIC_ZIO_AMT → bic_zio_amt (NUMERIC)
- _BIC_ZIO_CMPCD → bic_zio_cmpcd (STRING)
- _BIC_ZIO_SAUDT → bic_zio_saudt (STRING)
- _BIC_ZIO_SWEEK → bic_zio_sweek (STRING)
- _BIC_ZIO_VER → bic_zio_ver (STRING)
- _BIC_ZWWPC_PA1 → bic_zwwpc_pa1 (STRING)
- _BIC_ZWWSC_PA1 → bic_zwwsc_pa1 (STRING)
- MANDT → mandt (STRING)

**AZSRP_DS041_VT_S4 (v_bic_azsrp_ds041):**
- _BIC_ZIO_PCTR → bic_zio_pctr (STRING) → aliased AS b631_s_proftctr (meaningful rename per source CV logic)
- _BIC_ZIO_CCTR → bic_zio_cctr (STRING) → aliased AS b631_s_costcntr (meaningful rename per source CV logic)
- All other columns same as DS052 pattern above

**HRRP_NODE (v_hrrp_node):**
- MANDT → mandt (STRING)
- PARNODE → parnode (STRING)
- HRYVALTO → hryvalto (DATE)
- NODEVALUE → nodevalue (STRING)

**ZTSRP_ATTR_ACT (v_ztsrp_attr_act):**
- All columns mapped 1:1 per Columns_Mapping; key ones: prctr (STRING), strnum (STRING), rep_mkt_code (STRING), emerg_mkt_ind (STRING), division_code/desc (STRING), area_code/desc (STRING), district_code/desc (STRING), region_code/desc (STRING), city/state (STRING), fs_open_dat/rx_open_dat (DATE), rx_division_code/rx_area_code/rx_region_code/rx_district_code (STRING), rx_hrs_oper/fs_hrs_oper/retail_sqft_amt/total_sqft_amt (NUMERIC), rx_store (INT64)

**ZTSRP_COMPFL (v_ztsrp_compfl):**
- MANDT → mandt (STRING)
- PRCTR → prctr (STRING)
- ZWEEK → zweek (STRING)
- COMP_VER → comp_ver (STRING)
- FS_COMP_WK → fs_comp_wk (STRING)
- RX_COMP_WK → rx_comp_wk (STRING)

**ZTFIGL_RCALWEEK (v_ztfigl_rcalweek):**
- RCLNT → rclnt (STRING)
- ZZWEEK → zzweek (STRING)
- ZRWSTRTDATE → zrwstrtdate (DATE)
- ZRWENDDATE → zrwenddate (DATE)

**CEPCT (v_cepct):**
- MANDT → mandt (STRING)
- PRCTR → prctr (STRING)
- LTEXT → ltext (STRING) → aliased AS profit_center_text (meaningful rename per consumer CV)

---

## 10. Data Type Casts and Literal Conversions

| Location | Column/Filter | Original Type | BQ_DATATYPE | Action Taken |
|---|---|---|---|---|
| Frozen_Cube WHERE | mandt IN ('110','200') | NUMC/STRING | STRING | Quoted as strings |
| Live_Cube WHERE | mandt IN ('110','200') | NUMC/STRING | STRING | Quoted as strings |
| HIER_NODE WHERE | mandt IN ('120','200') | CLNT | STRING | Quoted as strings |
| HIER_NODE WHERE | hryvalto = '99991231' | DATS | DATE | Converted to DATE '9999-12-31' |
| STORE_ATTR_ACTUAL WHERE | mandt IN ('120','200') | CLNT | STRING | Quoted as strings |
| COMP_FLAG_BUDGET WHERE | mandt IN ('110','200') | CLNT | STRING | Quoted as strings |
| CAL_WEEK WHERE | rclnt IN ('120','200') | CLNT | STRING | Quoted as strings |
| PROFIT_CENTER_TEXT WHERE | mandt IN ('120','200') | CLNT | STRING | Quoted as strings |
| WEEKLY_SNAPSHOT_DS05 WHERE | bic_zio_saudt IN ('1','10') | NUMC | STRING | Already strings in converted SQL |
| WEEKLY_SNAPSHOT_DS05 WHERE | fiscvarnt = 'K4' | CHAR | STRING | Already string literal |

---

## 11. Alias Check Results

All physical column aliases were reviewed:
- **Removed redundant aliases**: No alias of the form `col AS col` (same name) was retained.
- **Retained meaningful renames**:
  - `bic_zio_pctr AS b631_s_proftctr` in Live_Cube — meaningful rename per source CV logic
  - `bic_zio_cctr AS b631_s_costcntr` in Live_Cube — meaningful rename per source CV logic
  - `ltext AS profit_center_text` in PROFIT_CENTER_TEXT — meaningful rename per consumer CV
  - `cal_fs_rx_flag AS fs_rx_flag` in final SELECT — meaningful rename per output contract
  - `cal_comp_flag AS comp_flag` in final SELECT — meaningful rename per output contract
  - `flag AS fin_bud_cube` in final SELECT — meaningful rename per output contract (FLAG column represents FIN_BUD_CUBE)
- All aggregate aliases use the exact BQ_COLUMN name (e.g., `SUM(b631_s_amount_negative) AS b631_s_amount_negative`)

---

## 12. Filter Trace — Every Filter from Every USED File

| Filter | Source File | Resulting SQL Location |
|---|---|---|
| FISCVARNT = 'K4' | CV_COMP_FIN_BUDGET_STATIC | WEEKLY_SNAPSHOT_DS05 WHERE |
| bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to | CV_COMP_FIN_BUDGET_STATIC | WEEKLY_SNAPSHOT_DS05 WHERE |
| bic_zio_ver = @ip_version | CV_COMP_FIN_BUDGET_STATIC | WEEKLY_SNAPSHOT_DS05 WHERE |
| bic_zio_saudt IN ('1','10') | CV_COMP_FIN_BUDGET_STATIC | WEEKLY_SNAPSHOT_DS05 WHERE |
| PARNODE matches '*CORE_RET' (HANA match) | CV_COMP_FIN_BUDGET_STATIC | HIER_NODE WHERE REGEXP_CONTAINS(parnode, r'CORE_RET$') |
| HRYVALTO = '99991231' | CV_COMP_FIN_BUDGET_STATIC | HIER_NODE WHERE hryvalto = DATE '9999-12-31' |
| COMP_VER = @ip_version | CV_COMP_FIN_BUDGET_STATIC | COMP_FLAG_BUDGET WHERE comp_ver = @ip_version |
| mandt IN ('110','200') [DS052] | CV_BASE_FIN_WEEKLY_BUDGET_S4 | Frozen_Cube WHERE |
| @ip_fc_count != '0' | CV_BASE_FIN_WEEKLY_BUDGET_S4 | Frozen_Cube WHERE |
| mandt IN ('110','200') [DS041] | CV_BASE_FIN_WEEKLY_BUDGET_S4 | Live_Cube WHERE |
| @ip_fc_count = '0' | CV_BASE_FIN_WEEKLY_BUDGET_S4 | Live_Cube WHERE |
| mandt IN ('120','200') [HRRP_NODE] | CV_BASE_MD_HRRP_NODE_S4 | HIER_NODE WHERE |
| mandt IN ('120','200') [ZTSRP_ATTR_ACT] | CV_BASE_MD_SRPACT_S4 | STORE_ATTR_ACTUAL WHERE |
| mandt IN ('110','200') [ZTSRP_COMPFL] | CV_BASE_MD_COMPFL_S4 | COMP_FLAG_BUDGET WHERE |
| zweek = @v_week | STP_WSS_SRP_ATTRIBUTES (procedure INSERT filter) | COMP_FLAG_BUDGET WHERE |
| rclnt IN ('120','200') [ZTFIGL_RCALWEEK] | CV_BASE_MD_RCALWEEK_S4 | CAL_WEEK WHERE |
| mandt IN ('120','200') [CEPCT] | CV_BASE_MD_CEPCT_S4 | PROFIT_CENTER_TEXT WHERE |

---

## 13. Aggregation Grain Validation

| CTE | Aggregation | Grain |
|---|---|---|
| Aggregated_Weekly_Budget_Snapshot | SUM(b631_s_amount), SUM(bic_zio_amt) | All attribute columns + flag |
| WEEKLY_SNAPSHOT_DS05 | MAX(FC/LC pivot), SUM(bic_zio_amt) | All attribute columns (flag collapsed) |
| STORE_ATTR_ACTUAL | SUM(rx_hrs_oper, fs_hrs_oper, rx_store, retail_sqft_amt, total_sqft_amt) | All non-measure attribute columns |
| Final SELECT | SUM(b631_s_amount_negative, bic_zio_amt, b631_s_amount) | All non-measure output columns |

No aggregation grain was changed, collapsed, or reintroduced incorrectly.

---

## 14. CTE Structure and Justification

| CTE | Justification |
|---|---|
| Frozen_Cube | Required: separate UNION branch with distinct source table and filter |
| Live_Cube | Required: separate UNION branch with distinct source table, filter, and column remapping |
| Aggregated_Weekly_Budget_Snapshot | Required: intermediate aggregation stage of CV_BASE_FIN_WEEKLY_BUDGET_S4 with FLAG retained for FC/LC pivot |
| WEEKLY_SNAPSHOT_DS05 | Required: consumer-level filters + FC/LC precedence calculation + final aggregation of base view |
| HIER_NODE | Required: separate source with distinct filter logic (CORE_RET hierarchy) |
| ONLY_CORE_RET_DATA | Combined with Join_1 (pass-through); no separate CTE needed |
| STORE_ATTR_ACTUAL | Required: separate source with aggregation (CUBE) from v_ztsrp_attr_act |
| Join_2 | Required: LEFT JOIN semantic boundary; WEEK_NUMBER node combined (simple projection) |
| COMP_FLAG_BUDGET | Required: separate source with distinct filter (zweek = @v_week, comp_ver = @ip_version) |
| Join_3 | Required: LEFT JOIN semantic boundary |
| CAL_WEEK | Required: separate source with distinct filter |
| Join_4 | Required: LEFT JOIN semantic boundary |
| PROFIT_CENTER_TEXT | Required: separate source with distinct filter and alias |
| Join_5 | Required: LEFT JOIN semantic boundary |
| FLAGS | Required: calculated column evaluation stage (cal_fs_rx_flag, cal_comp_flag, cal_week_number, b631_s_amount) before final aggregation |

---

## 15. Runtime Parameters

| Parameter | Type | Source | Usage | Reason Unresolved |
|---|---|---|---|---|
| @ip_version | STRING | CV_COMP_FIN_BUDGET_STATIC input parameter (IP_VERSION, default 'LEDGER_BUD') | bic_zio_ver = @ip_version (WEEKLY_SNAPSHOT_DS05); comp_ver = @ip_version (COMP_FLAG_BUDGET) | Runtime input parameter |
| @ip_week_ending_from | STRING | CV_COMP_FIN_BUDGET_STATIC input parameter (IP_WEEK_ENDING_FROM) | bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to | Runtime input parameter |
| @ip_week_ending_to | STRING | CV_COMP_FIN_BUDGET_STATIC input parameter (IP_WEEK_ENDING_TO) | bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to | Runtime input parameter |
| @ip_fc_count | STRING | Derived from SFN_FC_FLAG(@ip_version) — unresolved scalar function | Frozen_Cube WHERE @ip_fc_count != '0'; Live_Cube WHERE @ip_fc_count = '0' | SFN_FC_FLAG definition not supplied; replaced with runtime parameter per instructions |
| @v_week | STRING | Derived from SFN_PRIOR_FISCAL_WEEK() — unresolved scalar function | COMP_FLAG_BUDGET WHERE zweek = @v_week | SFN_PRIOR_FISCAL_WEEK definition not supplied; replaced with runtime parameter per instructions |

---

## 16. Conflicts and Validation Findings

### Corrected Items (Non-Blocking)

1. **MANDT filter type**: Converted SQL files used numeric literals (120, 200) for MANDT/RCLNT filters. Per Columns_Mapping, all MANDT/RCLNT columns are STRING. Corrected to quoted string literals ('120', '200'), ('110', '200') in all CTEs.

2. **HRYVALTO date literal**: Converted SQL used string '99991231'. Per Columns_Mapping, hryvalto is DATE. Corrected to `DATE '9999-12-31'`.

3. **@ip_fc_count comparison**: Converted SQL used SAFE_CAST; replaced with direct string comparison since @ip_fc_count is STRING per its usage context.

4. **Redundant aliases removed**: All aliases of the form `col AS col` (case/underscore equivalent) were removed. Only meaningful renames retained.

5. **ONLY_CORE_RET_DATA CTE**: Was a pass-through of Join_1 in the converted SQL. Combined into a single CTE to minimize CTE count without changing semantics.

6. **WEEK_NUMBER node**: Was a separate CTE in the converted SQL. Combined into Join_2 as it is a simple projection (RIGHT(bic_zio_sweek, 2)) with no semantic boundary.

### Non-Blocking Findings

1. **SFN_FC_FLAG unresolved**: The scalar function `CVS_FRIP.Composite.Master::SFN_FC_FLAG($$IP_VERSION$$)` is not supplied. Its result is replaced with runtime parameter `@ip_fc_count`. The filter logic is preserved exactly.

2. **SFN_PRIOR_FISCAL_WEEK unresolved**: The scalar function `CVS_FRIP.CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK()` is not supplied. Its result is replaced with runtime parameter `@v_week`. The procedure's filter `ZWEEK = V_WEEK` is preserved as `zweek = @v_week`.

3. **SNAPSHOT_TIMESTAMP / SNAPSHOT_CREATED_BY / CREATED_BY**: Audit-only columns populated by the procedure (CURRENT_TIMESTAMP, SESSION_USER). Not used by any downstream consumer logic. Dropped per instructions.

4. **REGEXP_CONTAINS for HANA match '*CORE_RET'**: The HANA `match` function with wildcard `*CORE_RET` is converted to `REGEXP_CONTAINS(parnode, r'CORE_RET$')`. This requires validation that the HANA wildcard `*CORE_RET` means "ends with CORE_RET" (which is the standard HANA match wildcard behavior). Noted in the converted SQL file as requiring validation.

5. **b631_s_amount_negative in FLAGS CTE**: The CV_COMP_FIN_BUDGET_STATIC source uses `_B631_S_AMOUNT_NEGATIVE` as the raw pre-negation amount passed through from WEEKLY_SNAPSHOT_DS05, and `_B631_S_AMOUNT = _B631_S_AMOUNT_NEGATIVE * -1` as the final calculated measure. The WEEKLY_SNAPSHOT_DS05 CTE produces `b631_s_amount_negative` (the FC/LC-resolved amount before negation), which is then negated in FLAGS. This two-step approach matches the source CV's measure definition exactly.

---

## 17. ISSUES TO FIX

### Issue 1: REGEXP_CONTAINS Pattern Validation Required
- **Affected**: HIER_NODE CTE, PARNODE filter
- **Source file**: CV_COMP_FIN_BUDGET_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt
- **Evidence**: HANA uses `match(PARNODE, '*CORE_RET')` wildcard. Converted to `REGEXP_CONTAINS(parnode, r'CORE_RET$')`.
- **Impact**: If HANA `*CORE_RET` matches any position (not just end), the regex pattern should be `r'CORE_RET'` instead of `r'CORE_RET$'`. If it means "ends with", the current pattern is correct.
- **Resolution needed**: Validate the exact HANA `match` function wildcard semantics for `*CORE_RET` against actual data.

### Issue 2: @ip_fc_count Runtime Parameter — SFN_FC_FLAG Not Supplied
- **Affected**: Frozen_Cube and Live_Cube CTEs
- **Source file**: CV_BASE_FIN_WEEKLY_BUDGET_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- **Evidence**: `$$IP_FC_COUNT$$` is derived from `CVS_FRIP.Composite.Master::SFN_FC_FLAG($$IP_VERSION$$)`. Function definition not in FS_BUDGET Latest Bigqueries.
- **Impact**: The FC/LC branch selection logic depends on this value. The caller must supply the correct value at runtime.
- **Resolution needed**: Implement or supply the BigQuery equivalent of SFN_FC_FLAG, or confirm that @ip_fc_count will always be provided correctly by the calling context.

### Issue 3: @v_week Runtime Parameter — SFN_PRIOR_FISCAL_WEEK Not Supplied
- **Affected**: COMP_FLAG_BUDGET CTE
- **Source file**: STP_WSS_SRP_ATTRIBUTES_DI HANA to BigQuery SQL Conversion Agent.txt
- **Evidence**: `V_WEEK = CVS_FRIP.CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK()`. Function definition not in FS_BUDGET Latest Bigqueries.
- **Impact**: The comp flag week filter depends on this value. The caller must supply the correct prior fiscal week value.
- **Resolution needed**: Implement or supply the BigQuery equivalent of SFN_PRIOR_FISCAL_WEEK, or confirm that @v_week will always be provided correctly by the calling context.

---

## 18. Quality Gate Results

| Check | Result |
|---|---|
| Final consumer unambiguous | ✅ PASSED — CV_COMP_FIN_BUDGET_STATIC |
| Artifact dependencies match lineage table | ✅ PASSED — All 10 lineage edges represented |
| Final-consumer transformation order preserved | ✅ PASSED — Nodes 1–13 in correct sequence |
| Dependencies expanded at point of consumption | ✅ PASSED |
| No generic Source→Intermediate→Target ordering | ✅ PASSED |
| Every file classified USED/NOT USED | ✅ PASSED — All 10 files USED |
| Every USED file participates in dependency chain | ✅ PASSED |
| All converted dependencies expanded | ✅ PASSED |
| Only terminal sources remain | ✅ PASSED |
| Every physical source uses BQ_FULL_TABLE | ✅ PASSED — All 7 physical tables use exact BQ_FULL_TABLE values |
| No PROJECT.DATASET placeholder remains | ✅ PASSED |
| Every referenced physical column mapped via Columns_Mapping | ✅ PASSED — All columns verified against full CSV |
| No column keeps leading underscore or / | ✅ PASSED — All BQ_COLUMN names used |
| All comparisons type-consistent | ✅ PASSED — STRING literals for STRING columns, DATE literals for DATE columns |
| Final-consumer CTE names preserved | ✅ PASSED — WEEKLY_SNAPSHOT_DS05, HIER_NODE, ONLY_CORE_RET_DATA, STORE_ATTR_ACTUAL, Join_2, COMP_FLAG_BUDGET, CAL_WEEK, Join_4, PROFIT_CENTER_TEXT, Join_5, FLAGS all preserved |
| Compatible operations combined | ✅ PASSED — WEEK_NUMBER combined into Join_2; ONLY_CORE_RET_DATA combined with Join_1 |
| No source node becomes separate CTE merely to mirror source structure | ✅ PASSED |
| Every helper CTE justified by semantic boundary | ✅ PASSED |
| Every CTE matches output contract | ✅ PASSED |
| No duplicate alias within a SELECT | ✅ PASSED |
| All filters preserved | ✅ PASSED — 17 filters traced to output |
| All aggregation stages preserve grain | ✅ PASSED |
| UNION behavior preserved | ✅ PASSED — UNION ALL of Frozen_Cube and Live_Cube |
| No result-affecting procedural behavior discarded | ✅ PASSED — zweek = @v_week filter preserved |
| Runtime parameters documented | ✅ PASSED — 5 parameters documented |
| Single query with no DECLARE/SET | ✅ PASSED |
| Every CTE has standardized comment header | ✅ PASSED |
| REGEXP_CONTAINS pattern validation | ⚠️ ISSUE TO FIX (Issue 1) |
| SFN_FC_FLAG unresolved | ⚠️ NON-BLOCKING (Issue 2) |
| SFN_PRIOR_FISCAL_WEEK unresolved | ⚠️ NON-BLOCKING (Issue 3) |

**This output is NOT production-ready due to Issues 1–3 listed above. The SQL is complete and logically correct based on all supplied inputs; the issues require external validation or implementation before deployment.**
