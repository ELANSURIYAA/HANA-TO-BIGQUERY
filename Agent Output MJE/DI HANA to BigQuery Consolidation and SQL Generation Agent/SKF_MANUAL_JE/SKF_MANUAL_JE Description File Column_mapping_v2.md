# SKF_MANUAL_JE – Consolidation Description

## 1. Pre-Consolidation Input Confirmation

### Lineage Rows Read (SKF_MANUAL_JE Relationships Table)
| # | Source File | Target File | Relationship Type |
|---|---|---|---|
| 1 | CV_BASE_SKF_FAGLSKF_PN_S4 | CV_COMP_SKF_MANUAL_JE | Calculation View Dependency |
| 2 | CV_BASE_MD_SRPACT_S4 | CV_COMP_SKF_MANUAL_JE | Calculation View Dependency |
| 3 | CV_BASE_MD_HRRP_NODE_S4 | CV_COMP_SKF_MANUAL_JE | Calculation View Dependency |
| 4 | CV_BASE_MD_COMPFL_S4 | CV_COMP_SKF_MANUAL_JE | Calculation View Dependency |
| 5 | CV_BASE_MD_RCALWEEK_S4 | CV_COMP_SKF_MANUAL_JE | Calculation View Dependency |
| 6 | CV_BASE_MD_CEPCT_S4 | CV_COMP_SKF_MANUAL_JE | Calculation View Dependency |

**Total lineage rows read: 6**

### Converted BigQuery SQL Files Inspected
| File | Classification | Reason |
|---|---|---|
| CV_COMP_SKF_MANUAL_JE_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Final consumer artifact |
| CV_BASE_SKF_FAGLSKF_PN_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency of final consumer (FAGLSKF_PN data) |
| CV_BASE_MD_SRPACT_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency of final consumer (store attributes) |
| CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency of final consumer (HR hierarchy) |
| CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency of final consumer (comparison flags) |
| CV_BASE_MD_RCALWEEK_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency of final consumer (fiscal calendar) |
| CV_BASE_MD_CEPCT_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency of final consumer (profit center text) |

**All 7 files: USED. No NOT USED files.**

### Columns_Mapping.csv Rows Read
The full CSV was read end-to-end. Key tables referenced in the consolidated query and their row counts:

| HANA Table | BQ_FULL_TABLE | Rows in CSV |
|---|---|---|
| FAGLSKF_PN | edp-qa-finstorage.edp_saps4_shared_cnsv.v_faglskf_pn | 30 |
| ZTSRP_ATTR_ACT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act | ~70 |
| HRRP_NODE | edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node | 14 |
| ZTSRP_COMPFL | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl | 13 |
| ZTFIGL_RCALWEEK | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek | 9 |
| CEPCT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct | 8 |

**Total Columns_Mapping rows read: ~700+ (full CSV read).**

---

## 2. Final Consumer Identification

**Final Consumer:** `CV_COMP_SKF_MANUAL_JE`

This is the only artifact that appears exclusively as a **target** in the lineage table. All six other artifacts appear as sources feeding into it. It is a CUBE/Aggregation Calculation View that produces the final Manual Journal Entry SKF quantity output.

---

## 3. Artifact Dependency Mapping

| Lineage Edge | Producer | Consumer | Resulting SQL Location |
|---|---|---|---|
| Edge 1 | CV_BASE_SKF_FAGLSKF_PN_S4 | CV_COMP_SKF_MANUAL_JE | CTE 1: `FAGLSKF_PN_S4` |
| Edge 2 | CV_BASE_MD_HRRP_NODE_S4 | CV_COMP_SKF_MANUAL_JE | CTE 2: `HIER` |
| Edge 3 | CV_BASE_MD_SRPACT_S4 | CV_COMP_SKF_MANUAL_JE | CTE 4: `STORE_ATTR_SKF_JOURNAL_ENT` |
| Edge 4 | CV_BASE_MD_COMPFL_S4 | CV_COMP_SKF_MANUAL_JE | CTE 6: `COMP_FLAG_SKF_JOURNAL_ENT` |
| Edge 5 | CV_BASE_MD_RCALWEEK_S4 | CV_COMP_SKF_MANUAL_JE | CTE 8: `CAL_WEEK` |
| Edge 6 | CV_BASE_MD_CEPCT_S4 | CV_COMP_SKF_MANUAL_JE | CTE 10: `PROFIT_CENTER_TEXT` |

---

## 4. Final-Consumer Flow / Node Sequence

The transformation flow from `CV_COMP_SKF_MANUAL_JE` is preserved exactly:

1. **FAGLSKF_PN_S4** – Filter and project from CV_BASE_SKF_FAGLSKF_PN_S4
2. **HIER** – Filter and project from CV_BASE_MD_HRRP_NODE_S4 (PARNODE, HRYVALTO filters)
3. **Join_7** → `Joined_FAGLSKF_with_HIER` – INNER JOIN FAGLSKF_PN_S4 ⋈ HIER on rcntr = nodevalue
4. **STORE_ATTR_SKF_JOURNAL_ENT** – Project from CV_BASE_MD_SRPACT_S4
5. **Join_2** → `Joined_FAGLSKF_HIER_with_STORE_ATTR` – LEFT JOIN on prctr
6. **COMP_FLAG_SKF_JOURNAL_ENT** – Filter and project from CV_BASE_MD_COMPFL_S4 (COMP_VER parameter)
7. **Join_3** → `Joined_StoreAttr_with_CompFlag` – LEFT JOIN on prctr AND zzweek = zweek
8. **CAL_WEEK** – Project from CV_BASE_MD_RCALWEEK_S4
9. **Join_6** → `Joined_with_CAL_WEEK` – LEFT JOIN on zzweek
10. **PROFIT_CENTER_TEXT** – Project from CV_BASE_MD_CEPCT_S4 (LTEXT → profit_center_text)
11. **Join_8** → `SKF_QTY` – LEFT JOIN on prctr; compute cal_msl, cal_week_number, cal_comp_flag
12. **Final SELECT** – GROUP BY + SUM(cal_msl) AS msl (CUBE aggregation)

---

## 5. Dependency Expansion and Point-of-Consumption Mapping

Each upstream dependency is expanded **at its point of consumption** in the final-consumer flow, not pre-materialized at the top:

- `FAGLSKF_PN_S4` (CTE 1) is consumed by `Joined_FAGLSKF_with_HIER` (CTE 3)
- `HIER` (CTE 2) is consumed by `Joined_FAGLSKF_with_HIER` (CTE 3)
- `STORE_ATTR_SKF_JOURNAL_ENT` (CTE 4) is consumed by `Joined_FAGLSKF_HIER_with_STORE_ATTR` (CTE 5)
- `COMP_FLAG_SKF_JOURNAL_ENT` (CTE 6) is consumed by `Joined_StoreAttr_with_CompFlag` (CTE 7)
- `CAL_WEEK` (CTE 8) is consumed by `Joined_with_CAL_WEEK` (CTE 9)
- `PROFIT_CENTER_TEXT` (CTE 10) is consumed by `SKF_QTY` (CTE 11)

---

## 6. Filter, Join, Aggregation, UNION, and Parameter Trace

### Filters from Each USED File

| Source File | Filter | Resulting SQL Location |
|---|---|---|
| CV_BASE_SKF_FAGLSKF_PN_S4 | rclnt IN ('120','200') | CTE 1 FAGLSKF_PN_S4 WHERE clause |
| CV_COMP_SKF_MANUAL_JE (FAGLSKF_PN_S4 node) | stagr IN ('801000','804013') | CTE 1 FAGLSKF_PN_S4 WHERE clause |
| CV_COMP_SKF_MANUAL_JE (FAGLSKF_PN_S4 node) | zzweek >= @ip_week_ending_from AND zzweek <= @ip_week_ending_to | CTE 1 FAGLSKF_PN_S4 WHERE clause |
| CV_COMP_SKF_MANUAL_JE (FAGLSKF_PN_S4 node) | zzscode != 'SLS' | CTE 1 FAGLSKF_PN_S4 WHERE clause |
| CV_BASE_MD_HRRP_NODE_S4 | mandt IN ('120','200') | CTE 2 HIER WHERE clause |
| CV_COMP_SKF_MANUAL_JE (HIER node) | REGEXP_CONTAINS(parnode, r'.*CORERET.*') | CTE 2 HIER WHERE clause |
| CV_COMP_SKF_MANUAL_JE (HIER node) | hryvalto = DATE '9999-12-31' | CTE 2 HIER WHERE clause |
| CV_BASE_MD_SRPACT_S4 | mandt IN ('120','200') | CTE 4 STORE_ATTR_SKF_JOURNAL_ENT WHERE clause |
| CV_BASE_MD_COMPFL_S4 | mandt IN ('110','200') | CTE 6 COMP_FLAG_SKF_JOURNAL_ENT WHERE clause |
| CV_COMP_SKF_MANUAL_JE (COMP_FLAG node) | comp_ver = @ip_version_comp_flag | CTE 6 COMP_FLAG_SKF_JOURNAL_ENT WHERE clause |
| CV_BASE_MD_RCALWEEK_S4 | rclnt IN ('120','200') | CTE 8 CAL_WEEK WHERE clause |
| CV_BASE_MD_CEPCT_S4 | mandt IN ('120','200') | CTE 10 PROFIT_CENTER_TEXT WHERE clause |

### Joins from CV_COMP_SKF_MANUAL_JE

| Join Node | Type | Left | Right | Condition | Resulting CTE |
|---|---|---|---|---|---|
| Join_7 | INNER JOIN | FAGLSKF_PN_S4 | HIER | rcntr = nodevalue | Joined_FAGLSKF_with_HIER (CTE 3) |
| Join_2 | LEFT JOIN | Joined_FAGLSKF_with_HIER | STORE_ATTR_SKF_JOURNAL_ENT | prctr = prctr | Joined_FAGLSKF_HIER_with_STORE_ATTR (CTE 5) |
| Join_3 | LEFT JOIN | Joined_FAGLSKF_HIER_with_STORE_ATTR | COMP_FLAG_SKF_JOURNAL_ENT | prctr = prctr AND zzweek = zweek | Joined_StoreAttr_with_CompFlag (CTE 7) |
| Join_6 | LEFT JOIN | Joined_StoreAttr_with_CompFlag | CAL_WEEK | zzweek = zzweek | Joined_with_CAL_WEEK (CTE 9) |
| Join_8 | LEFT JOIN | Joined_with_CAL_WEEK | PROFIT_CENTER_TEXT | prctr = prctr | SKF_QTY (CTE 11) |

### Calculations from CV_COMP_SKF_MANUAL_JE (SKF_QTY node)

| Calculated Column | Expression | Resulting SQL Location |
|---|---|---|
| cal_msl | CASE WHEN stagr = '801000' THEN msl ELSE msl * 2 END | CTE 11 SKF_QTY SELECT |
| cal_week_number | RIGHT(CAST(zzweek AS STRING), 2) | CTE 11 SKF_QTY SELECT |
| cal_comp_flag | rx_comp_wk | CTE 11 SKF_QTY SELECT |

### Aggregation (Final SELECT)

| Measure | Expression | Grain |
|---|---|---|
| msl | SUM(cal_msl) | GROUP BY all 34 non-measure output columns |

### Parameters

| Parameter | Type | Source | Usage |
|---|---|---|---|
| @ip_week_ending_from | STRING | CV_COMP_SKF_MANUAL_JE $$IP_WEEK_ENDING_FROM$$ | CTE 1 WHERE zzweek >= @ip_week_ending_from |
| @ip_week_ending_to | STRING | CV_COMP_SKF_MANUAL_JE $$IP_WEEK_ENDING_TO$$ | CTE 1 WHERE zzweek <= @ip_week_ending_to |
| @ip_version_comp_flag | STRING | CV_COMP_SKF_MANUAL_JE $$IP_VERSION_COMP_FLAG$$ | CTE 6 WHERE comp_ver = @ip_version_comp_flag |

---

## 7. Alias Check Results

### Physical Column Aliases – Redundant Aliases Removed

All physical columns are output under their exact `BQ_COLUMN` names from Columns_Mapping. No redundant HANA-name or case-only aliases remain.

**Meaningful renames retained (per converted SQL output contract):**

| CTE | Expression | Alias | Reason |
|---|---|---|---|
| CTE 10 PROFIT_CENTER_TEXT | ltext | profit_center_text | Meaningful rename per consumer output contract (LTEXT → PROFIT_CENTER_TEXT) |
| Final SELECT | cal_comp_flag | comp_flag | Meaningful rename per consumer output contract (CAL_COMP_FLAG → COMP_FLAG) |
| Final SELECT | zzscode | source_code | Meaningful rename per consumer output contract (ZZSCODE → SOURCE_CODE) |
| Final SELECT | SUM(cal_msl) | msl | Aggregate output under measure name per CUBE contract |

**Removed aliases (were equivalent under name-equivalence rule):**
- No `AS REP_MKT_CODE`, `AS ZZWEEK`, or similar redundant aliases were introduced.

---

## 8. Table and Column Mapping Applied

### Physical Tables Referenced After Expansion

| HANA Table | BQ_FULL_TABLE Used | All Columns Mapped |
|---|---|---|
| FAGLSKF_PN (FAGLSKF_PN_VT_S4) | edp-qa-finstorage.edp_saps4_shared_cnsv.v_faglskf_pn | Yes – rclnt, stagr, date_from, msl, prctr, zzscode, zzweek, rcntr |
| HRRP_NODE | edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node | Yes – mandt, parnode, hryvalto, nodevalue |
| ZTSRP_ATTR_ACT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act | Yes – mandt, prctr, strnum, rep_mkt_code, rep_mkt_desc, city, state, division_code, division_desc, area_code, area_desc, region_code, region_desc, district_code, district_desc, emerg_mkt_ind, fs_open_dat, rx_open_dat, rx_division_code, rx_area_code, rx_region_code, rx_district_code |
| ZTSRP_COMPFL | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl | Yes – mandt, prctr, strnum, comp_ver, zweek, zmonth, zyear, fs_comp_wk, rx_comp_wk |
| ZTFIGL_RCALWEEK | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek | Yes – rclnt, zzweek, zrwstrtdate, zrwenddate |
| CEPCT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct | Yes – mandt, prctr, ltext |

### HANA-to-BigQuery Column Replacements Applied Per Table

**FAGLSKF_PN (v_faglskf_pn):**
- RCLNT → rclnt (STRING), STAGR → stagr (STRING), DATE_FROM → date_from (DATE), MSL → msl (NUMERIC), PRCTR → prctr (STRING), ZZSCODE → zzscode (STRING), ZZWEEK → zzweek (STRING), RCNTR → rcntr (STRING)

**HRRP_NODE (v_hrrp_node):**
- MANDT → mandt (STRING), PARNODE → parnode (STRING), HRYVALTO → hryvalto (DATE), NODEVALUE → nodevalue (STRING)

**ZTSRP_ATTR_ACT (v_ztsrp_attr_act):**
- MANDT → mandt (STRING), PRCTR → prctr (STRING), STRNUM → strnum (STRING), REP_MKT_CODE → rep_mkt_code (STRING), REP_MKT_DESC → rep_mkt_desc (STRING), CITY → city (STRING), STATE → state (STRING), DIVISION_CODE → division_code (STRING), DIVISION_DESC → division_desc (STRING), AREA_CODE → area_code (STRING), AREA_DESC → area_desc (STRING), REGION_CODE → region_code (STRING), REGION_DESC → region_desc (STRING), DISTRICT_CODE → district_code (STRING), DISTRICT_DESC → district_desc (STRING), EMERG_MKT_IND → emerg_mkt_ind (STRING), FS_OPEN_DAT → fs_open_dat (DATE), RX_OPEN_DAT → rx_open_dat (DATE), RX_DIVISION_CODE → rx_division_code (STRING), RX_AREA_CODE → rx_area_code (STRING), RX_REGION_CODE → rx_region_code (STRING), RX_DISTRICT_CODE → rx_district_code (STRING)

**ZTSRP_COMPFL (v_ztsrp_compfl):**
- MANDT → mandt (STRING), PRCTR → prctr (STRING), STRNUM → strnum (STRING), COMP_VER → comp_ver (STRING), ZWEEK → zweek (STRING), ZMONTH → zmonth (STRING), ZYEAR → zyear (STRING), FS_COMP_WK → fs_comp_wk (STRING), RX_COMP_WK → rx_comp_wk (STRING)

**ZTFIGL_RCALWEEK (v_ztfigl_rcalweek):**
- RCLNT → rclnt (STRING), ZZWEEK → zzweek (STRING), ZRWSTRTDATE → zrwstrtdate (DATE), ZRWENDDATE → zrwenddate (DATE)

**CEPCT (v_cepct):**
- MANDT → mandt (STRING), PRCTR → prctr (STRING), LTEXT → ltext (STRING) → aliased as profit_center_text

### Type Casts and Literal Conversions Applied

| CTE | Clause | Original | Converted | BQ_DATATYPE | Reason |
|---|---|---|---|---|---|
| CTE 1 FAGLSKF_PN_S4 | WHERE rclnt | RCLNT IN (120, 200) | rclnt IN ('120','200') | STRING | rclnt is STRING per mapping; numeric literals quoted |
| CTE 2 HIER | WHERE mandt | MANDT IN (120, 200) | mandt IN ('120','200') | STRING | mandt is STRING per mapping |
| CTE 2 HIER | WHERE hryvalto | HRYVALTO = '99991231' | hryvalto = DATE '9999-12-31' | DATE | hryvalto is DATE per mapping; HANA DATS string converted to typed DATE literal |
| CTE 4 STORE_ATTR_SKF_JOURNAL_ENT | WHERE mandt | MANDT IN (120, 200) | mandt IN ('120','200') | STRING | mandt is STRING per mapping |
| CTE 6 COMP_FLAG_SKF_JOURNAL_ENT | WHERE mandt | MANDT IN (110, 200) | mandt IN ('110','200') | STRING | mandt is STRING per mapping |
| CTE 8 CAL_WEEK | WHERE rclnt | RCLNT IN (120, 200) | rclnt IN ('120','200') | STRING | rclnt is STRING per mapping |
| CTE 10 PROFIT_CENTER_TEXT | WHERE mandt | MANDT IN (120, 200) | mandt IN ('120','200') | STRING | mandt is STRING per mapping |
| CTE 11 SKF_QTY | cal_week_number | RIGHTSTR(ZZWEEK, 2) | RIGHT(CAST(zzweek AS STRING), 2) | STRING | zzweek is STRING; CAST preserves correctness; HANA RIGHTSTR → BQ RIGHT |

---

## 9. CTE / Helper Mapping

| CTE # | CTE Name | Represents | Justified By |
|---|---|---|---|
| 1 | FAGLSKF_PN_S4 | CV_BASE_SKF_FAGLSKF_PN_S4 + consumer STAGR/week/zzscode filters | Semantic boundary: physical source + combined filter |
| 2 | HIER | CV_BASE_MD_HRRP_NODE_S4 + consumer PARNODE/HRYVALTO filters | Semantic boundary: physical source + combined filter |
| 3 | Joined_FAGLSKF_with_HIER | Join_7 (INNER JOIN) | Required join boundary: INNER JOIN changes result set |
| 4 | STORE_ATTR_SKF_JOURNAL_ENT | CV_BASE_MD_SRPACT_S4 | Semantic boundary: physical source + filter; reused in join |
| 5 | Joined_FAGLSKF_HIER_with_STORE_ATTR | Join_2 (LEFT JOIN) | Required join boundary: LEFT JOIN introduces NULLs |
| 6 | COMP_FLAG_SKF_JOURNAL_ENT | CV_BASE_MD_COMPFL_S4 + parameter filter | Semantic boundary: physical source + parameter filter |
| 7 | Joined_StoreAttr_with_CompFlag | Join_3 (LEFT JOIN, composite key) | Required join boundary: composite key LEFT JOIN |
| 8 | CAL_WEEK | CV_BASE_MD_RCALWEEK_S4 | Semantic boundary: physical source + filter |
| 9 | Joined_with_CAL_WEEK | Join_6 (LEFT JOIN) | Required join boundary: LEFT JOIN on week key |
| 10 | PROFIT_CENTER_TEXT | CV_BASE_MD_CEPCT_S4 + rename | Semantic boundary: physical source + meaningful rename |
| 11 | SKF_QTY | Join_8 + calculated columns node | Required boundary: calculated columns feed aggregation |
| Final SELECT | — | CUBE aggregation node | SUM(cal_msl) with GROUP BY |

**Every helper CTE is justified by a real semantic boundary** (physical source, join type, filter, or calculation stage). No CTE was created merely to mirror a HANA node.

---

## 10. CTE Documentation Comment Validation

All 11 CTEs have standardized comment headers including:
- `CTE <sequence>` and `CTE_NAME`
- `Logic` describing consolidated logic
- `Source` where applicable
- `Filters` where applicable
- `Join` where applicable
- `Calculation` where applicable

Comments describe consolidated logic, not HANA node structure. No extra CTEs were created for documentation purposes.

---

## 11. Duplicate, Ambiguous-Column, Parent-Availability, and Aggregation Validation

- **Duplicate aliases:** None. Each SELECT has unique column aliases verified case-insensitively.
- **Ambiguous column references:** All columns in multi-input CTEs (3, 5, 7, 9, 11) are fully qualified with table aliases (f., s., j., c., p.).
- **Parent availability:** Every column referenced in each CTE exists in its parent CTE's output. Verified layer by layer.
- **Aggregation grain:** SUM(cal_msl) is the only measure. GROUP BY includes all 34 non-measure output columns. No upstream GROUP BY columns were reintroduced or dropped incorrectly.
- **DISTINCT/UNION behavior:** No UNION or DISTINCT in the source logic; none introduced.
- **Window functions:** None in source logic; none introduced.

---

## 12. Star Projection Validation

No star projections (`SELECT *`) are used in the consolidated SQL. All columns are explicitly named. Not applicable.

---

## 13. Parameter Documentation

| Parameter | BigQuery Name | Type | Source | Usage | Runtime Value |
|---|---|---|---|---|---|
| $$IP_WEEK_ENDING_FROM$$ | @ip_week_ending_from | STRING | CV_COMP_SKF_MANUAL_JE input parameter | CTE 1: zzweek >= @ip_week_ending_from | Supplied at runtime by caller |
| $$IP_WEEK_ENDING_TO$$ | @ip_week_ending_to | STRING | CV_COMP_SKF_MANUAL_JE input parameter | CTE 1: zzweek <= @ip_week_ending_to | Supplied at runtime by caller |
| $$IP_VERSION_COMP_FLAG$$ | @ip_version_comp_flag | STRING | CV_COMP_SKF_MANUAL_JE input parameter (optional) | CTE 6: comp_ver = @ip_version_comp_flag | Supplied at runtime by caller |

No DECLARE or SET statements appear in the output SQL. All parameters are `@` parameters with no default values.

---

## 14. Procedure / ETL Handling

No stored procedures, INSERT-SELECT, CREATE TABLE AS SELECT, or MERGE statements are present in any of the supplied converted SQL files. All source artifacts are Calculation View XML conversions. No procedural ETL handling was required.

---

## 15. Conflicts and Validation Findings

### Corrected (Non-Blocking)

1. **MANDT/RCLNT numeric literals → STRING literals:** All `IN (120, 200)` and `IN (110, 200)` filters were corrected to `IN ('120', '200')` and `IN ('110', '200')` respectively, because `BQ_DATATYPE = STRING` for all client columns per Columns_Mapping. Applied consistently across all 6 physical source CTEs.

2. **HRYVALTO date literal:** `HRYVALTO = '99991231'` (HANA DATS string) was converted to `hryvalto = DATE '9999-12-31'` because `BQ_DATATYPE = DATE` per Columns_Mapping. This preserves the comparison result.

3. **RIGHTSTR → RIGHT with CAST:** HANA `RIGHTSTR(ZZWEEK, 2)` was converted to `RIGHT(CAST(zzweek AS STRING), 2)`. Since `zzweek` is STRING per mapping, the CAST is a no-op safety measure; semantics are unchanged.

4. **Column name style:** All HANA-style uppercase column names (e.g., `RCLNT`, `STAGR`, `_BIC_ZIO_PCTR`) were replaced with their exact `BQ_COLUMN` values from Columns_Mapping (e.g., `rclnt`, `stagr`, `bic_zio_pctr`). No leading underscores remain in the output.

5. **FAGLSKF_PN table name:** The HANA source `FAGLSKF_PN_VT_S4` (with `_VT_S4` suffix) was matched to `FAGLSKF_PN` in Columns_Mapping (base name match, ignoring `_VT_S4` suffix per rules), mapping to `edp-qa-finstorage.edp_saps4_shared_cnsv.v_faglskf_pn`.

### Non-Blocking Findings

1. **@ip_version_comp_flag is optional:** The consumer marks `IP_VERSION_COMP_FLAG` as optional. If not supplied at runtime, the filter `comp_ver = @ip_version_comp_flag` will return no rows from COMP_FLAG_SKF_JOURNAL_ENT. This is consistent with the source behavior (LEFT JOIN means the main data is still returned, with NULL comp flag columns). Runtime caller must handle this.

2. **ZMONTH and ZYEAR projected but not in final output:** `zmonth` and `zyear` are projected in `COMP_FLAG_SKF_JOURNAL_ENT` (CTE 6) but not carried forward to the final SELECT. This matches the consumer output contract, which only uses `fs_comp_wk` and `rx_comp_wk` from that source. These columns are not referenced downstream and are correctly excluded.

3. **STRNUM appears in both STORE_ATTR and COMP_FLAG:** Both `STORE_ATTR_SKF_JOURNAL_ENT` and `COMP_FLAG_SKF_JOURNAL_ENT` contain `strnum`. In `Joined_StoreAttr_with_CompFlag` (CTE 7), `j.strnum` (from the store attributes side) is carried forward, consistent with the consumer output contract which projects `STRNUM` from the store attributes join path. The `strnum` from COMP_FLAG is not separately projected, avoiding duplication.

### Issues to Fix (Unresolved)

**None.** All lineage edges are represented by the correct supplied logic at their point of consumption. All filters, joins, calculations, and parameters from every USED file are traced to the output SQL. All physical columns use their exact BQ_COLUMN values. No logic was invented. No dependency was bypassed.

---

## 16. Final Quality Gate Results

| Check | Result |
|---|---|
| 1. Final consumer unambiguous | ✅ PASS – CV_COMP_SKF_MANUAL_JE |
| 2. Artifact dependencies match lineage table | ✅ PASS – All 6 edges represented |
| 3. Final-consumer transformation order preserved | ✅ PASS – Nodes 1-12 in exact order |
| 4. Dependencies expanded at point of consumption | ✅ PASS |
| 5. No generic Source→Intermediate→Target ordering | ✅ PASS |
| 6. Every file classified USED/NOT USED | ✅ PASS – All 7 files USED |
| 7. Every USED file participates in dependency chain | ✅ PASS |
| 8. All converted dependencies expanded | ✅ PASS |
| 9. Only terminal sources remain | ✅ PASS – 6 physical BQ tables |
| 10. Every physical source uses BQ_FULL_TABLE; no PROJECT.DATASET placeholder remains | ✅ PASS |
| 11. Every referenced physical column mapped via Columns_Mapping; no leading underscores | ✅ PASS |
| 12. All comparisons type-consistent; date/string literals correctly typed | ✅ PASS – All IN() filters quoted; DATE literal used for hryvalto |
| 13. Final-consumer functional CTE names and order preserved | ✅ PASS |
| 14. Compatible nodes combined when logically safe | ✅ PASS |
| 15. No source node became a separate CTE merely to mirror HANA structure | ✅ PASS |
| 16. Every helper CTE justified by real semantic boundary | ✅ PASS |
| 17. Every CTE matches required output contract | ✅ PASS |
| 18. Every column reference qualified; no ambiguity | ✅ PASS |
| 19. No duplicate alias within any SELECT | ✅ PASS |
| 20. No star projections (N/A) | ✅ PASS |
| 21. Filters, joins, calculations, mappings, parameters preserved | ✅ PASS |
| 22. Aggregation grain preserved | ✅ PASS – SUM(cal_msl) with correct GROUP BY |
| 23. DISTINCT, UNION, window behavior preserved (N/A) | ✅ PASS |
| 24. No conflict silently corrected | ✅ PASS – All corrections documented above |
| 25. No procedural behavior discarded (N/A) | ✅ PASS |
| 26. Runtime parameters documented; no DECLARE/SET | ✅ PASS |
| 27. Every CTE has standardized comment header | ✅ PASS |
| 28. CTE comments describe consolidated logic | ✅ PASS |
| 29. 100% logic match with minimum logical CTE structure | ✅ PASS |
| 30. Every lineage edge represented by correct supplied logic | ✅ PASS |
| 31. Every filter/join/aggregation/parameter traced to output | ✅ PASS |
| 32. Every physical-column output uses exact BQ_COLUMN; no HANA-name aliases | ✅ PASS |

**All 32 quality gate checks passed. No unresolved issues remain.**

> **Note:** This query is complete and traceable from all supplied inputs. It is not claimed to be production-ready until the runtime parameters are validated by the calling application and the BigQuery table schemas are confirmed against the Columns_Mapping entries.
