# FIN_SBT Consolidation Description
**Agent:** BigQuery SQL Consolidation and Implementation Agent
**Version:** Column_mapping_v1

---

## 1. Pre-Consolidation Input Verification

### 1.1 Lineage Rows Read (FIN_SBT Relationships Table)

| Source File | Target File | Dependency Type |
|---|---|---|
| CV_BASE_FIN_BKPF_S4 | CV_COMP_FIN_SBT | Calculation View Dependency |
| CV_BASE_FIN_ACDOCA_S4 | CV_COMP_FIN_SBT | Calculation View Dependency |
| CV_BASE_MD_SRPACT_S4 | CV_COMP_FIN_SBT | Calculation View Dependency |
| CV_BASE_MD_RCALWEEK_S4 | CV_COMP_FIN_SBT | Calculation View Dependency |
| CV_BASE_MD_CEPCT_S4 | CV_COMP_FIN_SBT | Calculation View Dependency |

**Total lineage rows read: 5**

### 1.2 FIN_SBT Converted BIGQUERIES Files

| File | Classification | Reason |
|---|---|---|
| CV_COMP_FIN_SBT_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Final consumer artifact |
| CV_BASE_FIN_BKPF_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency of CV_COMP_FIN_SBT (BKPF node) |
| CV_BASE_FIN_ACDOCA_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency of CV_COMP_FIN_SBT (ACDOCA node) |
| CV_BASE_MD_SRPACT_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency of CV_COMP_FIN_SBT (STORE_ATTRIBUTES node) |
| CV_BASE_MD_RCALWEEK_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency of CV_COMP_FIN_SBT (RETAIL_CALENAR node) |
| CV_BASE_MD_CEPCT_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency of CV_COMP_FIN_SBT (PROFIT_CENTER_TEXT node) |

**All 6 files classified. No NOT USED files.**

### 1.3 Columns_Mapping.csv

**Total rows read: Full CSV (all rows inspected before any mapping decision).**
Tables referenced by the consolidated SQL and their mapping status:

| HANA Table | BQ_FULL_TABLE | Columns Referenced | Status |
|---|---|---|---|
| BKPF (BKPF_VT_S4) | `edp-qa-finstorage.edp_saps4_shared_cnsv.v_bkpf` | mandt, bukrs, belnr, gjahr, xref2_hd, budat, blart | All OK |
| ACDOCA_VT_S4 | `edp-qa-finstorage.edp_saps4_shared_cnsv.v_acdoca` | rclnt, rbukrs, belnr, gjahr, wsl, prctr, racct, zzweek, rwcur | All OK |
| ZTSRP_ATTR_ACT | `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act` | mandt, strnum, prctr, rep_mkt_code, rep_mkt_desc, city, state, division_code, division_desc, area_code, area_desc, region_code, region_desc, district_code, district_desc, fs_open_dat, rx_open_dat, emerg_mkt_ind, rx_division_code, rx_area_code, rx_region_code, rx_district_code | All OK |
| ZTFIGL_RCALWEEK | `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek` | zzweek, zrwenddate, zrwstrtdate, rclnt | All OK |
| CEPCT | `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct` | mandt, prctr, ltext (→ profit_center_text) | All OK |

---

## 2. Final Consumer Identification

**Final Consumer:** `CV_COMP_FIN_SBT`
- Type: Calculation View XML, CUBE, outputViewType="Aggregation"
- All five upstream calculation views are direct dependencies, confirmed by both the Relationships Table and the dataSources section of the CV_COMP_FIN_SBT converted SQL.

---

## 3. Artifact Dependency Mapping (Lineage Edges)

| Producer | Consumer | Resulting SQL Location |
|---|---|---|
| CV_BASE_FIN_BKPF_S4 → BKPF_VT_S4 | CV_COMP_FIN_SBT BKPF node | CTE 1: BKPF |
| CV_BASE_FIN_ACDOCA_S4 → ACDOCA_VT_S4 | CV_COMP_FIN_SBT ACDOCA node | CTE 2: ACDOCA |
| CV_BASE_MD_SRPACT_S4 → ZTSRP_ATTR_ACT | CV_COMP_FIN_SBT STORE_ATTRIBUTES node | CTE 4: STORE_ATTRIBUTES |
| CV_BASE_MD_RCALWEEK_S4 → ZTFIGL_RCALWEEK | CV_COMP_FIN_SBT RETAIL_CALENAR node | CTE 6: RETAIL_CALENAR |
| CV_BASE_MD_CEPCT_S4 → CEPCT | CV_COMP_FIN_SBT PROFIT_CENTER_TEXT node | CTE 9: PROFIT_CENTER_TEXT |

All 5 lineage edges are represented. No edge is unresolved.

---

## 4. Final-Consumer Flow / Node Sequence

The CV_COMP_FIN_SBT data flow is preserved in the following CTE sequence:

1. **BKPF** – Filter BKPF records (client + document type + reference)
2. **ACDOCA** – Filter ACDOCA records (client + profit center + GL account + week range)
3. **SBT** – INNER JOIN BKPF × ACDOCA on (bukrs/rbukrs, belnr, gjahr)
4. **STORE_ATTRIBUTES** – Filter store profile attributes (client)
5. **Join_1** – LEFT OUTER JOIN SBT × STORE_ATTRIBUTES on prctr
6. **RETAIL_CALENAR** – Filter retail calendar (client)
7. **Join_2** – LEFT OUTER JOIN Join_1 × RETAIL_CALENAR on zzweek
8. **COMP_FLAG** – Add cal_comp_flag and cal_week_number calculated columns
9. **PROFIT_CENTER_TEXT** – Filter profit center texts (client), map ltext → profit_center_text
10. **Join_3** – LEFT OUTER JOIN COMP_FLAG × PROFIT_CENTER_TEXT on prctr
11. **Final SELECT** – GROUP BY all attributes, SUM(wsl) AS wsl_negative, SUM(wsl)*-1 AS wsl

---

## 5. Dependency Expansion and Point-of-Consumption Mapping

Each upstream dependency is expanded at its point of consumption in the final-consumer flow:

- **CV_BASE_FIN_BKPF_S4**: Its filter logic (mandt IN ('120','200')) is combined with the CV_COMP_FIN_SBT BKPF node filters (xref2_hd='A1', blart='ZT') into **CTE 1: BKPF**, reading directly from `v_bkpf`. No intermediate CTE is required.
- **CV_BASE_FIN_ACDOCA_S4**: Its filter logic (rclnt IN ('120','200')) is combined with the CV_COMP_FIN_SBT ACDOCA node filters (prctr IN (...), racct='0004403000', zzweek BETWEEN ...) into **CTE 2: ACDOCA**, reading directly from `v_acdoca`.
- **CV_BASE_MD_SRPACT_S4**: Its filter logic (mandt IN ('120','200')) is applied in **CTE 4: STORE_ATTRIBUTES**, reading directly from `v_ztsrp_attr_act`. Only columns consumed by CV_COMP_FIN_SBT are projected.
- **CV_BASE_MD_RCALWEEK_S4**: Its filter logic (rclnt IN ('120','200')) is applied in **CTE 6: RETAIL_CALENAR**, reading directly from `v_ztfigl_rcalweek`. Only columns consumed by CV_COMP_FIN_SBT are projected.
- **CV_BASE_MD_CEPCT_S4**: Its filter logic (mandt IN ('120','200')) is applied in **CTE 9: PROFIT_CENTER_TEXT**, reading directly from `v_cepct`. LTEXT is aliased to `profit_center_text` as required by CV_COMP_FIN_SBT.

---

## 6. Filter, Join, Aggregation, and Parameter Trace

### Filters

| Filter | Source File | Resulting SQL Clause |
|---|---|---|
| mandt IN ('120','200') | CV_BASE_FIN_BKPF_S4 | CTE 1 BKPF WHERE clause |
| xref2_hd = 'A1' | CV_COMP_FIN_SBT | CTE 1 BKPF WHERE clause |
| blart = 'ZT' | CV_COMP_FIN_SBT | CTE 1 BKPF WHERE clause |
| rclnt IN ('120','200') | CV_BASE_FIN_ACDOCA_S4 | CTE 2 ACDOCA WHERE clause |
| prctr IN ('0000562057','0000562058') | CV_COMP_FIN_SBT | CTE 2 ACDOCA WHERE clause |
| racct = '0004403000' | CV_COMP_FIN_SBT | CTE 2 ACDOCA WHERE clause |
| zzweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to | CV_COMP_FIN_SBT | CTE 2 ACDOCA WHERE clause |
| mandt IN ('120','200') | CV_BASE_MD_SRPACT_S4 | CTE 4 STORE_ATTRIBUTES WHERE clause |
| rclnt IN ('120','200') | CV_BASE_MD_RCALWEEK_S4 | CTE 6 RETAIL_CALENAR WHERE clause |
| mandt IN ('120','200') | CV_BASE_MD_CEPCT_S4 | CTE 9 PROFIT_CENTER_TEXT WHERE clause |

### Joins

| Join | Source File | Resulting SQL Clause |
|---|---|---|
| INNER JOIN BKPF × ACDOCA on bukrs/rbukrs, belnr, gjahr | CV_COMP_FIN_SBT | CTE 3 SBT |
| LEFT OUTER JOIN SBT × STORE_ATTRIBUTES on prctr | CV_COMP_FIN_SBT | CTE 5 Join_1 |
| LEFT OUTER JOIN Join_1 × RETAIL_CALENAR on zzweek | CV_COMP_FIN_SBT | CTE 7 Join_2 |
| LEFT OUTER JOIN COMP_FLAG × PROFIT_CENTER_TEXT on prctr | CV_COMP_FIN_SBT | CTE 10 Join_3 |

### Calculations

| Calculation | Source File | Resulting SQL Clause |
|---|---|---|
| CASE WHEN prctr = '0000562057' THEN '1' ELSE '0' END AS cal_comp_flag | CV_COMP_FIN_SBT | CTE 8 COMP_FLAG SELECT |
| RIGHT(zzweek, 2) AS cal_week_number | CV_COMP_FIN_SBT | CTE 8 COMP_FLAG SELECT |
| ltext AS profit_center_text | CV_COMP_FIN_SBT | CTE 9 PROFIT_CENTER_TEXT SELECT |

### Aggregation

| Measure | Source File | Resulting SQL Clause |
|---|---|---|
| SUM(wsl) AS wsl_negative | CV_COMP_FIN_SBT | Final SELECT |
| SUM(wsl) * -1 AS wsl | CV_COMP_FIN_SBT | Final SELECT |

### Parameters

| Parameter | Type | Source | Usage |
|---|---|---|---|
| @ip_week_ending_from | STRING | CV_COMP_FIN_SBT (derived from SFN_PRIOR_FISCAL_WEEK, unresolved) | CTE 2 ACDOCA WHERE zzweek BETWEEN ... |
| @ip_week_ending_to | STRING | CV_COMP_FIN_SBT (derived from SFN_PRIOR_FISCAL_WEEK, unresolved) | CTE 2 ACDOCA WHERE zzweek BETWEEN ... |

---

## 7. Column Mapping Applied

### HANA → BigQuery Column Replacements by Table

**BKPF (→ v_bkpf)**

| HANA Column | BQ Column | BQ Datatype |
|---|---|---|
| MANDT | mandt | STRING |
| BUKRS | bukrs | STRING |
| BELNR | belnr | STRING |
| GJAHR | gjahr | STRING |
| XREF2_HD | xref2_hd | STRING |
| BUDAT | budat | DATE |
| BLART | blart | STRING |

**ACDOCA_VT_S4 (→ v_acdoca)**

| HANA Column | BQ Column | BQ Datatype |
|---|---|---|
| RCLNT | rclnt | STRING |
| RBUKRS | rbukrs | STRING |
| BELNR | belnr | STRING |
| GJAHR | gjahr | STRING |
| WSL | wsl | NUMERIC |
| PRCTR | prctr | STRING |
| RACCT | racct | STRING |
| ZZWEEK | zzweek | STRING |
| RWCUR | rwcur | STRING |

**ZTSRP_ATTR_ACT (→ v_ztsrp_attr_act)**

| HANA Column | BQ Column | BQ Datatype |
|---|---|---|
| MANDT | mandt | STRING |
| STRNUM | strnum | STRING |
| PRCTR | prctr | STRING |
| REP_MKT_CODE | rep_mkt_code | STRING |
| REP_MKT_DESC | rep_mkt_desc | STRING |
| CITY | city | STRING |
| STATE | state | STRING |
| DIVISION_CODE | division_code | STRING |
| DIVISION_DESC | division_desc | STRING |
| AREA_CODE | area_code | STRING |
| AREA_DESC | area_desc | STRING |
| REGION_CODE | region_code | STRING |
| REGION_DESC | region_desc | STRING |
| DISTRICT_CODE | district_code | STRING |
| DISTRICT_DESC | district_desc | STRING |
| FS_OPEN_DAT | fs_open_dat | DATE |
| RX_OPEN_DAT | rx_open_dat | DATE |
| EMERG_MKT_IND | emerg_mkt_ind | STRING |
| RX_DIVISION_CODE | rx_division_code | STRING |
| RX_AREA_CODE | rx_area_code | STRING |
| RX_REGION_CODE | rx_region_code | STRING |
| RX_DISTRICT_CODE | rx_district_code | STRING |

**ZTFIGL_RCALWEEK (→ v_ztfigl_rcalweek)**

| HANA Column | BQ Column | BQ Datatype |
|---|---|---|
| ZZWEEK | zzweek | STRING |
| ZRWENDDATE | zrwenddate | DATE |
| ZRWSTRTDATE | zrwstrtdate | DATE |
| RCLNT | rclnt | STRING |

**CEPCT (→ v_cepct)**

| HANA Column | BQ Column | BQ Datatype |
|---|---|---|
| MANDT | mandt | STRING |
| PRCTR | prctr | STRING |
| LTEXT | ltext → profit_center_text | STRING |

---

## 8. Data Type Casts and Literal Conversions

### Filter Literal Type Checks

| Table | Column | BQ Datatype | Filter Literal | Action |
|---|---|---|---|---|
| v_bkpf | mandt | STRING | '120', '200' | Already STRING — no cast needed |
| v_bkpf | xref2_hd | STRING | 'A1' | Already STRING — no cast needed |
| v_bkpf | blart | STRING | 'ZT' | Already STRING — no cast needed |
| v_acdoca | rclnt | STRING | '120', '200' | Already STRING — no cast needed |
| v_acdoca | prctr | STRING | '0000562057', '0000562058' | Already STRING — no cast needed |
| v_acdoca | racct | STRING | '0004403000' | Already STRING — no cast needed |
| v_acdoca | zzweek | STRING | @ip_week_ending_from / @ip_week_ending_to | Parameters typed STRING to match column — no cast needed |
| v_ztsrp_attr_act | mandt | STRING | '120', '200' | Already STRING — no cast needed |
| v_ztfigl_rcalweek | rclnt | STRING | '120', '200' | Already STRING — no cast needed |
| v_cepct | mandt | STRING | '120', '200' | Already STRING — no cast needed |

**Note on CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_RCALWEEK_S4 converted SQL:** The original converted SQL used `MANDT IN (120, 200)` and `RCLNT IN (120, 200)` (unquoted integers). The Columns_Mapping confirms these columns are STRING in BigQuery. The consolidated SQL corrects these to `IN ('120', '200')` in all affected CTEs to ensure type safety.

### JOIN Type Checks

| Join | Left Column (type) | Right Column (type) | Action |
|---|---|---|---|
| SBT: BKPF.bukrs = ACDOCA.rbukrs | STRING | STRING | No cast needed |
| SBT: BKPF.belnr = ACDOCA.belnr | STRING | STRING | No cast needed |
| SBT: BKPF.gjahr = ACDOCA.gjahr | STRING | STRING | No cast needed |
| Join_1: SBT.prctr = SA.prctr | STRING | STRING | No cast needed |
| Join_2: J1.zzweek = RC.zzweek | STRING | STRING | No cast needed |
| Join_3: CF.prctr = PCT.prctr | STRING | STRING | No cast needed |

---

## 9. Alias Check

### Physical Column Aliases Removed (Redundant HANA-name aliases)

All physical columns are output under their exact `BQ_COLUMN` name from Columns_Mapping. No HANA-name aliases were retained. The following meaningful alias was kept:

- `ltext AS profit_center_text` — This is a **meaningful rename** required by the CV_COMP_FIN_SBT output contract (PROFIT_CENTER_TEXT node maps LTEXT to output name PROFIT_CENTER_TEXT). Written in BigQuery style as `ltext AS profit_center_text`.

All other columns are projected without aliases (column name equals BQ_COLUMN directly).

---

## 10. CTE / Helper Mapping

| CTE | Justification | Semantic Boundary |
|---|---|---|
| BKPF | Final-consumer node; combines CV_BASE_FIN_BKPF_S4 client filter with CV_COMP_FIN_SBT document filters | Filter boundary |
| ACDOCA | Final-consumer node; combines CV_BASE_FIN_ACDOCA_S4 client filter with CV_COMP_FIN_SBT fiscal/account filters | Filter boundary |
| SBT | Final-consumer INNER JOIN node | Join boundary |
| STORE_ATTRIBUTES | Final-consumer node; CV_BASE_MD_SRPACT_S4 client filter applied | Filter boundary |
| Join_1 | Final-consumer LEFT OUTER JOIN node | Join boundary |
| RETAIL_CALENAR | Final-consumer node; CV_BASE_MD_RCALWEEK_S4 client filter applied | Filter boundary |
| Join_2 | Final-consumer LEFT OUTER JOIN node | Join boundary |
| COMP_FLAG | Final-consumer calculation node (cal_comp_flag, cal_week_number) | Calculation boundary |
| PROFIT_CENTER_TEXT | Final-consumer node; CV_BASE_MD_CEPCT_S4 client filter applied, ltext renamed | Filter + rename boundary |
| Join_3 | Final-consumer LEFT OUTER JOIN node (pre-aggregation) | Join boundary |
| Final SELECT | Aggregation (CUBE) as required by CV_COMP_FIN_SBT | Aggregation boundary |

No helper CTEs were created beyond those required by the final-consumer node sequence. Each CTE corresponds to a functional transformation node in CV_COMP_FIN_SBT.

---

## 11. Aggregation Grain Validation

- The final SELECT aggregates over all non-measure output columns as required by `dataCategory="CUBE"` and `outputViewType="Aggregation"` in CV_COMP_FIN_SBT.
- `wsl_negative = SUM(wsl)` — intermediate aggregated measure.
- `wsl = SUM(wsl) * -1` — final calculated measure (formula applied after aggregation, per CUBE semantics).
- GROUP BY includes all 35 non-measure output columns exactly as defined in the CV_COMP_FIN_SBT logicalModel.
- No upstream GROUP BY from CV_BASE_FIN_BKPF_S4 or CV_BASE_FIN_ACDOCA_S4 was copied into the consolidated SQL. Those views' aggregation stages are not required because CV_COMP_FIN_SBT reads their full projection (all columns used in the SBT join are dimension/key columns, not measures), and the final aggregation is performed once at the CV_COMP_FIN_SBT level.

---

## 12. Star Projection Validation

No star projections (`SELECT *`) remain in the final consolidated SQL. All CTEs use explicit column lists. The `J1.*` star used in the original CV_COMP_FIN_SBT converted SQL for Join_2 was expanded to explicit columns to prevent ambiguity and ensure the output contract is deterministic.

---

## 13. Parameter Documentation

| Parameter | BigQuery Name | Type | Source | Usage | Reason Unresolved |
|---|---|---|---|---|---|
| IP_WEEK_ENDING_FROM | @ip_week_ending_from | STRING | CV_COMP_FIN_SBT; derived from scalar function CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK | CTE 2 ACDOCA WHERE zzweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to | SFN_PRIOR_FISCAL_WEEK definition not supplied in FIN_SBT Converted BIGQUERIES |
| IP_WEEK_ENDING_TO | @ip_week_ending_to | STRING | CV_COMP_FIN_SBT; derived from scalar function CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK | CTE 2 ACDOCA WHERE zzweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to | SFN_PRIOR_FISCAL_WEEK definition not supplied in FIN_SBT Converted BIGQUERIES |

Parameters are runtime-supplied. No DECLARE, SET, or default values are present in the SQL.

---

## 14. Procedure / ETL Handling

No stored procedures, INSERT-SELECT, CREATE TABLE AS SELECT, or MERGE statements are present in any of the supplied converted SQL files. All artifacts are Calculation View XML conversions. No procedure inlining was required.

---

## 15. Duplicate Column Validation

Each CTE and the final SELECT were checked for duplicate aliases:
- No duplicate column aliases exist within any CTE or the final SELECT.
- `mandt` appears in both BKPF and STORE_ATTRIBUTES, but only `BKPF.mandt` is carried through the SBT → Join_1 → Join_2 → COMP_FLAG → Join_3 chain. `STORE_ATTRIBUTES.mandt` is not selected in Join_1, eliminating any ambiguity.
- `prctr` appears in both SBT (from ACDOCA) and STORE_ATTRIBUTES. Only `SBT.prctr` is carried through Join_1 (SA.prctr is not re-selected). No duplicate.
- `zzweek` appears in both Join_1 and RETAIL_CALENAR. Only `J1.zzweek` is carried through Join_2. No duplicate.

---

## 16. Final Quality Gate Results

| Check | Result |
|---|---|
| 1. Final consumer unambiguous | ✅ CV_COMP_FIN_SBT |
| 2. Artifact dependencies match Relationships Table | ✅ All 5 edges confirmed |
| 3. Final-consumer transformation order preserved | ✅ BKPF→ACDOCA→SBT→Join_1→Join_2→COMP_FLAG→Join_3→Final SELECT |
| 4. Dependencies expanded at point of consumption | ✅ Each upstream view inlined at its node |
| 5. No generic Source→Intermediate→Target ordering | ✅ Follows CV_COMP_FIN_SBT node sequence |
| 6. Every file classified USED/NOT USED | ✅ All 6 files USED |
| 7. Every USED file participates in dependency chain | ✅ |
| 8. All converted dependencies expanded | ✅ |
| 9. Only terminal sources remain | ✅ v_bkpf, v_acdoca, v_ztsrp_attr_act, v_ztfigl_rcalweek, v_cepct |
| 10. Every physical source uses BQ_FULL_TABLE; no PROJECT.DATASET placeholder | ✅ All 5 tables use full `edp-qa-finstorage.edp_saps4_shared_cnsv.*` paths |
| 11. Every referenced physical column mapped one-to-one via Columns_Mapping | ✅ All columns verified against full CSV |
| 12. Type safety in all comparisons | ✅ All filter literals and join columns match BQ_DATATYPE; INTEGER literals corrected to STRING |
| 13. Final-consumer CTE names and dependency order preserved | ✅ BKPF, ACDOCA, SBT, STORE_ATTRIBUTES, Join_1, RETAIL_CALENAR, Join_2, COMP_FLAG, PROFIT_CENTER_TEXT, Join_3 |
| 14. Compatible steps combined | ✅ Upstream client filters merged into final-consumer CTEs |
| 15. No source node becomes separate CTE merely to mirror source structure | ✅ |
| 16. Every helper CTE justified by real semantic boundary | ✅ |
| 17. Every CTE matches required output contract | ✅ |
| 18. All column references qualified where multiple inputs in scope | ✅ |
| 19. No duplicate alias within any SELECT | ✅ |
| 20. No star projections remain | ✅ All expanded to explicit column lists |
| 21. Filters, joins, calculations, mappings, parameters preserved | ✅ |
| 22. Aggregation grain preserved | ✅ SUM(wsl) AS wsl_negative; SUM(wsl)*-1 AS wsl; GROUP BY 35 attributes |
| 23. DISTINCT, UNION, window behavior | N/A — none present |
| 24. No conflict silently corrected | ✅ Integer→STRING literal correction documented |
| 25. No result-affecting procedural behavior discarded | N/A — no procedures |
| 26. Runtime parameters documented; no DECLARE/SET | ✅ @ip_week_ending_from, @ip_week_ending_to |
| 27. Every CTE has standardized comment header | ✅ |
| 28. CTE comments describe consolidated logic | ✅ |
| 29. 100% logic match with minimum CTE structure | ✅ |
| 30. Every lineage edge represented | ✅ All 5 edges resolved |
| 31. Every filter/join/aggregation/parameter traced to output SQL | ✅ See Section 6 |
| 32. Physical-column outputs use exact BQ_COLUMN; no HANA-name aliases | ✅ Only meaningful rename: ltext AS profit_center_text |

---

## 17. Issues to Fix

### Non-Blocking Findings

1. **Runtime Parameters Unresolved** — `@ip_week_ending_from` and `@ip_week_ending_to` are derived from the scalar function `CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK`, which is not supplied in the converted SQL files. These are documented runtime parameters. The filter logic is fully preserved; only the value source is unresolved. **Impact:** The query is functionally complete but requires the caller to supply the correct fiscal week values at runtime.

2. **Integer Literal Correction (Non-Blocking)** — The CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_RCALWEEK_S4 converted SQL files used `MANDT IN (120, 200)` and `RCLNT IN (120, 200)` (unquoted integers). The Columns_Mapping confirms these columns are `STRING` in BigQuery. The consolidated SQL corrects these to `IN ('120', '200')` to match the BQ_DATATYPE. This is a type-safety correction, not a logic change.

### No Unresolved Issues Blocking SQL Generation

The consolidated SQL is complete and all logic from the supplied inputs is represented. The two findings above are non-blocking.
