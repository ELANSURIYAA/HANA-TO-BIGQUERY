# SKF_MANUAL_JE Consolidation Description

## 1. Pre-Consolidation Input Confirmation

### Lineage Rows Read (SKF_MANUAL_JE Relationships Table)
| Source File | Target File | Relationship Type |
|---|---|---|
| CV_BASE_SKF_FAGLSKF_PN_S4 | CV_COMP_SKF_MANUAL_JE | Calculation View Dependency |
| CV_BASE_MD_SRPACT_S4 | CV_COMP_SKF_MANUAL_JE | Calculation View Dependency |
| CV_BASE_MD_HRRP_NODE_S4 | CV_COMP_SKF_MANUAL_JE | Calculation View Dependency |
| CV_BASE_MD_COMPFL_S4 | CV_COMP_SKF_MANUAL_JE | Calculation View Dependency |
| CV_BASE_MD_RCALWEEK_S4 | CV_COMP_SKF_MANUAL_JE | Calculation View Dependency |
| CV_BASE_MD_CEPCT_S4 | CV_COMP_SKF_MANUAL_JE | Calculation View Dependency |

**Total lineage rows: 6**

### Converted BigQuery SQL Files Inspected
| File | Classification | Reason |
|---|---|---|
| CV_COMP_SKF_MANUAL_JE_DI HANA to BigQuery SQL Conversion Agent.txt | USED | Final consumer artifact |
| CV_BASE_SKF_FAGLSKF_PN_S4_DI HANA to BigQuery SQL Conversion Agent.txt | USED | Direct dependency of CV_COMP_SKF_MANUAL_JE; provides FAGLSKF financial ledger data |
| CV_BASE_MD_SRPACT_S4_DI HANA to BigQuery SQL Conversion Agent.txt | USED | Direct dependency of CV_COMP_SKF_MANUAL_JE; provides store/profit center attribute master |
| CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt | USED | Direct dependency of CV_COMP_SKF_MANUAL_JE; provides HR reporting node hierarchy |
| CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL Conversion Agent.txt | USED | Direct dependency of CV_COMP_SKF_MANUAL_JE; provides comparison flag master data |
| CV_BASE_MD_RCALWEEK_S4_DI HANA to BigQuery SQL Conversion Agent.txt | USED | Direct dependency of CV_COMP_SKF_MANUAL_JE; provides fiscal calendar week data |
| CV_BASE_MD_CEPCT_S4_DI HANA to BigQuery SQL Conversion Agent.txt | USED | Direct dependency of CV_COMP_SKF_MANUAL_JE; provides profit center text descriptions |

**Total files: 7 — All 7 USED, 0 NOT USED.**

### Columns_Mapping CSV Rows Read
The full Columns_Mapping.csv was read end-to-end. The following physical tables are referenced by the expanded SQL and were validated:

| HANA Table | BQ_FULL_TABLE |
|---|---|
| FAGLSKF_PN (FAGLSKF_PN_VT_S4) | edp-qa-finstorage.edp_saps4_shared_cnsv.v_faglskf_pn |
| HRRP_NODE | edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node |
| ZTSRP_ATTR_ACT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act |
| ZTSRP_COMPFL | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl |
| ZTFIGL_RCALWEEK | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek |
| CEPCT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct |

---

## 2. Final Consumer Identification

**Final Consumer:** `CV_COMP_SKF_MANUAL_JE`
- Type: Calculation View, CUBE / outputViewType = Aggregation
- All six upstream dependencies feed into this single final consumer.
- No further downstream consumers are identified in the supplied lineage.

---

## 3. Artifact Dependency Mapping and Lineage Edges

| Producer | Consumer | Resulting SQL Location |
|---|---|---|
| CV_BASE_SKF_FAGLSKF_PN_S4 | CV_COMP_SKF_MANUAL_JE | CTE 1: FAGLSKF_PN_S4 |
| CV_BASE_MD_HRRP_NODE_S4 | CV_COMP_SKF_MANUAL_JE | CTE 2: HIER |
| CV_BASE_MD_SRPACT_S4 | CV_COMP_SKF_MANUAL_JE | CTE 3: STORE_ATTR_SKF_JOURNAL_ENT |
| CV_BASE_MD_COMPFL_S4 | CV_COMP_SKF_MANUAL_JE | CTE 4: COMP_FLAG_SKF_JOURNAL_ENT |
| CV_BASE_MD_RCALWEEK_S4 | CV_COMP_SKF_MANUAL_JE | CTE 5: CAL_WEEK |
| CV_BASE_MD_CEPCT_S4 | CV_COMP_SKF_MANUAL_JE | CTE 6: PROFIT_CENTER_TEXT |

Every lineage edge is represented at its point of consumption in the final-consumer flow.

---

## 4. Final Consumer Flow / Transformation Order

The CV_COMP_SKF_MANUAL_JE data flow is implemented in the following sequence, as defined by the converted XML:

1. **FAGLSKF_PN_S4** — Filter and project FAGLSKF_PN financial ledger rows.
2. **HIER** — Filter and project HRRP_NODE hierarchy rows (CORERET, valid-to = 9999-12-31).
3. **Join_7 (inlined into SKF_QTY)** — INNER JOIN FAGLSKF_PN_S4 with HIER on `rcntr = nodevalue`.
4. **STORE_ATTR_SKF_JOURNAL_ENT** — Project store attribute master rows.
5. **Join_2 (inlined into SKF_QTY)** — LEFT JOIN result with STORE_ATTR_SKF_JOURNAL_ENT on `prctr`.
6. **COMP_FLAG_SKF_JOURNAL_ENT** — Filter and project comparison flag rows.
7. **Join_3 (inlined into SKF_QTY)** — LEFT JOIN result with COMP_FLAG_SKF_JOURNAL_ENT on `prctr` and `zzweek = zweek`.
8. **CAL_WEEK** — Project fiscal calendar week rows.
9. **Join_6 (inlined into SKF_QTY)** — LEFT JOIN result with CAL_WEEK on `zzweek`.
10. **PROFIT_CENTER_TEXT** — Project profit center text rows.
11. **Join_8 (inlined into SKF_QTY)** — LEFT JOIN result with PROFIT_CENTER_TEXT on `prctr`.
12. **SKF_QTY** — Final projection with calculated columns (cal_msl, cal_week_number, cal_comp_flag).
13. **Final SELECT** — GROUP BY all dimensions, SUM(cal_msl) AS msl.

Intermediate join nodes (Join_7, Join_2, Join_3, Join_6, Join_8) and the final projection node (SKF_QTY) are combined into a single CTE (CTE 7: SKF_QTY) because they form a linear chain with no semantic boundaries that would require separate materialization. This satisfies the minimum-CTE rule while preserving all join logic, filters, and calculations.

---

## 5. Dependency Expansion and Point-of-Consumption Mapping

Each upstream dependency is expanded inline at its point of consumption:

- **CV_BASE_SKF_FAGLSKF_PN_S4** → expanded as CTE 1 (FAGLSKF_PN_S4). Terminal source: `edp-qa-finstorage.edp_saps4_shared_cnsv.v_faglskf_pn`. The upstream view's own aggregation (SUM(MSL) GROUP BY) is not re-applied here because CV_COMP_SKF_MANUAL_JE consumes the row-level detail from this view and applies its own aggregation at the final stage. The upstream filter `rclnt IN ('120','200')` is preserved and combined with the consumer's additional filters (stagr, zzweek, zzscode).
- **CV_BASE_MD_HRRP_NODE_S4** → expanded as CTE 2 (HIER). Terminal source: `edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node`. Filters from the upstream view (`mandt IN ('120','200')`) and from the consumer node (`REGEXP_CONTAINS(parnode, r'.*CORERET.*')`, `hryvalto = DATE '9999-12-31'`) are both preserved.
- **CV_BASE_MD_SRPACT_S4** → expanded as CTE 3 (STORE_ATTR_SKF_JOURNAL_ENT). Terminal source: `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act`. Filter `mandt IN ('120','200')` preserved. Only the columns consumed by CV_COMP_SKF_MANUAL_JE are projected.
- **CV_BASE_MD_COMPFL_S4** → expanded as CTE 4 (COMP_FLAG_SKF_JOURNAL_ENT). Terminal source: `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl`. Upstream filter `mandt IN ('110','200')` preserved (note: the upstream view uses 110, not 120, as documented below). Consumer filter `comp_ver = @ip_version_comp_flag` applied.
- **CV_BASE_MD_RCALWEEK_S4** → expanded as CTE 5 (CAL_WEEK). Terminal source: `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek`. Filter `rclnt IN ('120','200')` preserved.
- **CV_BASE_MD_CEPCT_S4** → expanded as CTE 6 (PROFIT_CENTER_TEXT). Terminal source: `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct`. Filter `mandt IN ('120','200')` preserved. LTEXT aliased as `profit_center_text` per the output contract.

---

## 6. Filter, Join, Aggregation, UNION, and Parameter Trace

### Filters
| Filter | Source File | Resulting SQL Location |
|---|---|---|
| `rclnt IN ('120','200')` | CV_BASE_SKF_FAGLSKF_PN_S4 | CTE 1 WHERE clause |
| `stagr IN ('801000','804013')` | CV_COMP_SKF_MANUAL_JE (node FAGLSKF_PN_S4) | CTE 1 WHERE clause |
| `zzweek >= @ip_week_ending_from AND zzweek <= @ip_week_ending_to` | CV_COMP_SKF_MANUAL_JE (node FAGLSKF_PN_S4) | CTE 1 WHERE clause |
| `zzscode != 'SLS'` | CV_COMP_SKF_MANUAL_JE (node FAGLSKF_PN_S4) | CTE 1 WHERE clause |
| `mandt IN ('120','200')` | CV_BASE_MD_HRRP_NODE_S4 | CTE 2 WHERE clause |
| `REGEXP_CONTAINS(parnode, r'.*CORERET.*')` | CV_COMP_SKF_MANUAL_JE (node HIER) | CTE 2 WHERE clause |
| `hryvalto = DATE '9999-12-31'` | CV_COMP_SKF_MANUAL_JE (node HIER) | CTE 2 WHERE clause |
| `mandt IN ('120','200')` | CV_BASE_MD_SRPACT_S4 | CTE 3 WHERE clause |
| `mandt IN ('110','200')` | CV_BASE_MD_COMPFL_S4 | CTE 4 WHERE clause |
| `comp_ver = @ip_version_comp_flag` | CV_COMP_SKF_MANUAL_JE (node COMP_FLAG_SKF_JOURNAL_ENT) | CTE 4 WHERE clause |
| `rclnt IN ('120','200')` | CV_BASE_MD_RCALWEEK_S4 | CTE 5 WHERE clause |
| `mandt IN ('120','200')` | CV_BASE_MD_CEPCT_S4 | CTE 6 WHERE clause |

### Joins
| Join | Type | Condition | Source File | Resulting SQL Location |
|---|---|---|---|---|
| FAGLSKF_PN_S4 ⋈ HIER | INNER JOIN | f.rcntr = h.nodevalue | CV_COMP_SKF_MANUAL_JE (Join_7) | CTE 7 SKF_QTY |
| result ⋈ STORE_ATTR_SKF_JOURNAL_ENT | LEFT JOIN | f.prctr = s.prctr | CV_COMP_SKF_MANUAL_JE (Join_2) | CTE 7 SKF_QTY |
| result ⋈ COMP_FLAG_SKF_JOURNAL_ENT | LEFT JOIN | f.prctr = c.prctr AND f.zzweek = c.zweek | CV_COMP_SKF_MANUAL_JE (Join_3) | CTE 7 SKF_QTY |
| result ⋈ CAL_WEEK | LEFT JOIN | f.zzweek = cw.zzweek | CV_COMP_SKF_MANUAL_JE (Join_6) | CTE 7 SKF_QTY |
| result ⋈ PROFIT_CENTER_TEXT | LEFT JOIN | f.prctr = p.prctr | CV_COMP_SKF_MANUAL_JE (Join_8) | CTE 7 SKF_QTY |

### Calculations
| Calculation | Expression | Source File | Resulting SQL Location |
|---|---|---|---|
| cal_msl | CASE WHEN stagr = '801000' THEN msl ELSE msl * 2 END | CV_COMP_SKF_MANUAL_JE (node SKF_QTY) | CTE 7 SKF_QTY SELECT |
| cal_week_number | RIGHT(CAST(zzweek AS STRING), 2) | CV_COMP_SKF_MANUAL_JE (node SKF_QTY) | CTE 7 SKF_QTY SELECT |
| cal_comp_flag | rx_comp_wk | CV_COMP_SKF_MANUAL_JE (node SKF_QTY) | CTE 7 SKF_QTY SELECT |

### Aggregation
| Measure | Expression | Source File | Resulting SQL Location |
|---|---|---|---|
| msl | SUM(cal_msl) | CV_COMP_SKF_MANUAL_JE (CUBE/Aggregation) | Final SELECT |

### UNION Branches
None. No UNION logic is present in any supplied file.

### Parameters
| Parameter | Type | Source | Usage |
|---|---|---|---|
| @ip_week_ending_from | STRING | CV_COMP_SKF_MANUAL_JE ($$IP_WEEK_ENDING_FROM$$) | CTE 1 WHERE: zzweek >= @ip_week_ending_from |
| @ip_week_ending_to | STRING | CV_COMP_SKF_MANUAL_JE ($$IP_WEEK_ENDING_TO$$) | CTE 1 WHERE: zzweek <= @ip_week_ending_to |
| @ip_version_comp_flag | STRING | CV_COMP_SKF_MANUAL_JE ($$IP_VERSION_COMP_FLAG$$) | CTE 4 WHERE: comp_ver = @ip_version_comp_flag |

---

## 7. Table and Column Mapping Applied

### Physical Table Replacements
| HANA Source | BQ_FULL_TABLE Applied |
|---|---|
| CVS_FRIP.FAGLSKF_PN_VT_S4 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_faglskf_pn |
| SAP_S4.HRRP_NODE | edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node |
| SAP_S4.ZTSRP_ATTR_ACT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act |
| SAP_S4.ZTSRP_COMPFL | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl |
| SAP_S4.ZTFIGL_RCALWEEK | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek |
| SAP_S4.CEPCT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct |

### Column Replacements (HANA → BQ_COLUMN) by Table

**v_faglskf_pn (FAGLSKF_PN_VT_S4):**
| HANA Column | BQ_COLUMN | BQ_DATATYPE |
|---|---|---|
| RCLNT | rclnt | STRING |
| STAGR | stagr | STRING |
| DATE_FROM | date_from | DATE |
| MSL | msl | NUMERIC |
| PRCTR | prctr | STRING |
| ZZSCODE | zzscode | STRING |
| ZZWEEK | zzweek | STRING |
| RCNTR | rcntr | STRING |

**v_hrrp_node (HRRP_NODE):**
| HANA Column | BQ_COLUMN | BQ_DATATYPE |
|---|---|---|
| MANDT | mandt | STRING |
| PARNODE | parnode | STRING |
| HRYVALTO | hryvalto | DATE |
| NODEVALUE | nodevalue | STRING |

**v_ztsrp_attr_act (ZTSRP_ATTR_ACT):**
| HANA Column | BQ_COLUMN | BQ_DATATYPE |
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
| EMERG_MKT_IND | emerg_mkt_ind | STRING |
| FS_OPEN_DAT | fs_open_dat | DATE |
| RX_OPEN_DAT | rx_open_dat | DATE |
| RX_DIVISION_CODE | rx_division_code | STRING |
| RX_AREA_CODE | rx_area_code | STRING |
| RX_REGION_CODE | rx_region_code | STRING |
| RX_DISTRICT_CODE | rx_district_code | STRING |

**v_ztsrp_compfl (ZTSRP_COMPFL):**
| HANA Column | BQ_COLUMN | BQ_DATATYPE |
|---|---|---|
| MANDT | mandt | STRING |
| PRCTR | prctr | STRING |
| STRNUM | strnum | STRING |
| COMP_VER | comp_ver | STRING |
| ZWEEK | zweek | STRING |
| ZMONTH | zmonth | STRING |
| ZYEAR | zyear | STRING |
| FS_COMP_WK | fs_comp_wk | STRING |
| RX_COMP_WK | rx_comp_wk | STRING |

**v_ztfigl_rcalweek (ZTFIGL_RCALWEEK):**
| HANA Column | BQ_COLUMN | BQ_DATATYPE |
|---|---|---|
| RCLNT | rclnt | STRING |
| ZZWEEK | zzweek | STRING |
| ZRWSTRTDATE | zrwstrtdate | DATE |
| ZRWENDDATE | zrwenddate | DATE |

**v_cepct (CEPCT):**
| HANA Column | BQ_COLUMN | BQ_DATATYPE |
|---|---|---|
| MANDT | mandt | STRING |
| PRCTR | prctr | STRING |
| LTEXT | ltext | STRING |

### Data Type Casts and Literal Conversions Applied

| CTE | Clause | Original | Converted | BQ_DATATYPE | Reason |
|---|---|---|---|---|---|
| CTE 1 FAGLSKF_PN_S4 | WHERE rclnt IN (...) | IN (120, 200) | IN ('120', '200') | STRING | rclnt BQ_DATATYPE = STRING; numeric literals converted to quoted strings |
| CTE 2 HIER | WHERE mandt IN (...) | IN (120, 200) | IN ('120', '200') | STRING | mandt BQ_DATATYPE = STRING |
| CTE 2 HIER | WHERE hryvalto = ... | = '99991231' | = DATE '9999-12-31' | DATE | hryvalto BQ_DATATYPE = DATE; HANA-style YYYYMMDD string converted to typed DATE literal |
| CTE 3 STORE_ATTR | WHERE mandt IN (...) | IN (120, 200) | IN ('120', '200') | STRING | mandt BQ_DATATYPE = STRING |
| CTE 4 COMP_FLAG | WHERE mandt IN (...) | IN (110, 200) | IN ('110', '200') | STRING | mandt BQ_DATATYPE = STRING |
| CTE 5 CAL_WEEK | WHERE rclnt IN (...) | IN (120, 200) | IN ('120', '200') | STRING | rclnt BQ_DATATYPE = STRING |
| CTE 6 PROFIT_CENTER_TEXT | WHERE mandt IN (...) | IN (120, 200) | IN ('120', '200') | STRING | mandt BQ_DATATYPE = STRING |
| CTE 7 SKF_QTY | CASE WHEN stagr = ... | '801000' | '801000' | STRING | stagr BQ_DATATYPE = STRING; already quoted, no change |
| CTE 7 SKF_QTY | cal_week_number | RIGHTSTR(ZZWEEK,2) | RIGHT(CAST(zzweek AS STRING), 2) | STRING | zzweek BQ_DATATYPE = STRING; CAST is defensive; HANA RIGHTSTR → BigQuery RIGHT |

---

## 8. Alias Check Results

### Redundant Aliases Removed
The following aliases were present in the converted SQL files but are redundant under the name-equivalence rule (names match after lowercasing, removing leading underscores, replacing `/` with `_`) and have been removed:

- `REP_MKT_CODE AS REP_MKT_CODE` → output as `rep_mkt_code` (no alias)
- `ZZSCODE AS ZZSCODE` → aliased as `source_code` per the output contract (meaningful rename retained)
- `RX_COMP_WK AS CAL_COMP_FLAG` → retained as `cal_comp_flag` (meaningful rename per output contract)
- `LTEXT AS PROFIT_CENTER_TEXT` → retained (meaningful rename per output contract)

### Meaningful Renames Retained
| Column | Alias | Reason |
|---|---|---|
| zzscode | source_code | Output contract alias defined in CV_COMP_SKF_MANUAL_JE node SKF_QTY |
| rx_comp_wk (in cal_comp_flag) | cal_comp_flag | Calculated column alias defined in CV_COMP_SKF_MANUAL_JE |
| cal_comp_flag | comp_flag | Final output alias defined in CV_COMP_SKF_MANUAL_JE final SELECT |
| ltext | profit_center_text | Output contract alias defined in CV_COMP_SKF_MANUAL_JE node PROFIT_CENTER_TEXT |

---

## 9. CTE / Helper Mapping

| CTE | Represents | Justification for Separate CTE |
|---|---|---|
| FAGLSKF_PN_S4 | CV_BASE_SKF_FAGLSKF_PN_S4 expansion + consumer filters | Required as a named input to the INNER JOIN in SKF_QTY |
| HIER | CV_BASE_MD_HRRP_NODE_S4 expansion + consumer filters | Required as a named input to the INNER JOIN in SKF_QTY |
| STORE_ATTR_SKF_JOURNAL_ENT | CV_BASE_MD_SRPACT_S4 expansion | Required as a named input to the LEFT JOIN in SKF_QTY |
| COMP_FLAG_SKF_JOURNAL_ENT | CV_BASE_MD_COMPFL_S4 expansion + consumer filter | Required as a named input to the LEFT JOIN in SKF_QTY |
| CAL_WEEK | CV_BASE_MD_RCALWEEK_S4 expansion | Required as a named input to the LEFT JOIN in SKF_QTY |
| PROFIT_CENTER_TEXT | CV_BASE_MD_CEPCT_S4 expansion | Required as a named input to the LEFT JOIN in SKF_QTY |
| SKF_QTY | All join nodes + final projection + calculated columns | Required to separate the row-level calculation of cal_msl from the final GROUP BY aggregation; combining into the final SELECT would change the aggregation grain |

All 7 CTEs are justified by real semantic boundaries (join inputs and aggregation stage). No CTE was created merely to mirror a HANA node.

---

## 10. Duplicate, Ambiguous-Column, Parent-Availability, and Aggregation Validation

- **Duplicate aliases:** No duplicate column aliases exist within any CTE or the final SELECT.
- **Ambiguous column references:** All columns in SKF_QTY are qualified with their source alias (f., s., c., cw., p.) to eliminate ambiguity.
- **Parent availability:** Every column referenced in SKF_QTY is confirmed to exist in its parent CTE output. Every column in the final SELECT exists in SKF_QTY.
- **Aggregation grain:** The final SELECT groups by all non-measure dimension columns and applies SUM(cal_msl) AS msl. The grain matches the CUBE/Aggregation specification of CV_COMP_SKF_MANUAL_JE. cal_msl is computed at row level in SKF_QTY and aggregated in the final SELECT, preserving the two-stage logic.

---

## 11. Star Projection Validation

No star projections (`SELECT *`) are used in the consolidated SQL. All columns are explicitly listed.

---

## 12. Parameter Documentation

| Parameter | Type | Source | Usage | Notes |
|---|---|---|---|---|
| @ip_week_ending_from | STRING | CV_COMP_SKF_MANUAL_JE $$IP_WEEK_ENDING_FROM$$ | CTE 1 WHERE zzweek >= @ip_week_ending_from | Mandatory; lower bound of fiscal week range; compared with zzweek (STRING) |
| @ip_week_ending_to | STRING | CV_COMP_SKF_MANUAL_JE $$IP_WEEK_ENDING_TO$$ | CTE 1 WHERE zzweek <= @ip_week_ending_to | Mandatory; upper bound of fiscal week range; compared with zzweek (STRING) |
| @ip_version_comp_flag | STRING | CV_COMP_SKF_MANUAL_JE $$IP_VERSION_COMP_FLAG$$ | CTE 4 WHERE comp_ver = @ip_version_comp_flag | Optional; comparison flag version; compared with comp_ver (STRING) |

All parameters are lowercase BigQuery `@` parameters. No DECLARE or SET statements are present. No default values are assigned.

---

## 13. Procedure / ETL Handling

No stored procedures, INSERT-SELECT, CREATE TABLE AS SELECT, or MERGE statements are present in any supplied file. All source artifacts are Calculation View XML definitions. No procedural handling was required.

---

## 14. Conflicts and Validation Findings

### Corrected (Non-Blocking)
1. **MANDT/RCLNT literal type correction:** All `IN (120, 200)` and `IN (110, 200)` integer literals converted to `IN ('120', '200')` / `IN ('110', '200')` because the BQ_DATATYPE for these columns is STRING. Applied consistently in all six CTEs.
2. **HRYVALTO date literal:** `= '99991231'` (HANA DATS string) converted to `= DATE '9999-12-31'` (BigQuery typed DATE literal) because hryvalto BQ_DATATYPE = DATE.
3. **HANA RIGHTSTR function:** `RIGHTSTR(ZZWEEK, 2)` converted to `RIGHT(CAST(zzweek AS STRING), 2)` per BigQuery standard SQL.
4. **HANA match() pattern filter:** `match("PARNODE",'*CORERET*')` converted to `REGEXP_CONTAINS(parnode, r'.*CORERET.*')` per BigQuery standard SQL.
5. **Redundant HANA-style aliases removed:** All aliases of the form `col AS COL` or `col AS _COL` that are equivalent under the name-equivalence rule have been removed.

### Issues to Fix (Unresolved)

**ISSUE 1: MANDT filter discrepancy in CV_BASE_MD_COMPFL_S4**
- **Artifact:** CV_BASE_MD_COMPFL_S4 / CTE 4 COMP_FLAG_SKF_JOURNAL_ENT
- **Evidence:** The converted SQL file for CV_BASE_MD_COMPFL_S4 specifies `MANDT IN (110, 200)`, while all other upstream views use `MANDT IN (120, 200)` or `RCLNT IN (120, 200)`. The value 110 differs from the 120 used elsewhere.
- **Impact:** If the intended client is 120 (not 110), the comparison flag join will return fewer or no matching rows, silently affecting the comp_flag output columns. The consolidated SQL preserves the value as supplied (110) because no authoritative correction is available from the supplied inputs.
- **Resolution needed:** Confirm whether MANDT = 110 is correct for ZTSRP_COMPFL or whether it should be 120. Update CTE 4 accordingly.

**ISSUE 2: CV_BASE_SKF_FAGLSKF_PN_S4 aggregation boundary**
- **Artifact:** CV_BASE_SKF_FAGLSKF_PN_S4
- **Evidence:** The upstream view CV_BASE_SKF_FAGLSKF_PN_S4 is itself a CUBE/Aggregation view that applies SUM(MSL) GROUP BY. When expanded inline as CTE 1, the row-level detail is used directly (not pre-aggregated), because CV_COMP_SKF_MANUAL_JE applies its own aggregation. This is consistent with the consumer's flow, which reads individual rows from this dependency. However, if the HANA runtime pre-aggregated this view before passing rows to the consumer, the grain may differ.
- **Impact:** Low risk; the final GROUP BY in CV_COMP_SKF_MANUAL_JE produces the same result whether or not an intermediate aggregation is applied, because the GROUP BY keys in the upstream view are a superset of those in the consumer. Validated as non-blocking.
- **Resolution needed:** Confirm that no intermediate aggregation is required between CTE 1 and SKF_QTY.

---

## 15. Final Quality Gate Results

| Check | Result |
|---|---|
| 1. Final consumer unambiguous | PASS — CV_COMP_SKF_MANUAL_JE |
| 2. Artifact dependencies match lineage | PASS — All 6 lineage edges represented |
| 3. Final-consumer transformation order preserved | PASS |
| 4. Dependencies expanded at point of consumption | PASS |
| 5. No generic Source→Intermediate→Target ordering | PASS |
| 6. Every file classified USED/NOT USED | PASS — 7 USED, 0 NOT USED |
| 7. Every USED file participates in dependency chain | PASS |
| 8. All converted dependencies expanded | PASS |
| 9. Only terminal sources remain | PASS |
| 10. Every physical source uses BQ_FULL_TABLE | PASS |
| 11. Every referenced physical column mapped via Columns_Mapping | PASS — All columns verified against full CSV |
| 12. All comparisons type-consistent; date/string literals corrected | PASS (with corrections documented) |
| 13. Final-consumer CTE names and order preserved | PASS |
| 14. Compatible operations combined | PASS — Join chain inlined into SKF_QTY |
| 15. No HANA node becomes a CTE merely to mirror source structure | PASS |
| 16. Every helper CTE justified by semantic boundary | PASS |
| 17. Every CTE matches required output contract | PASS |
| 18. All column references qualified; no ambiguity | PASS |
| 19. No duplicate alias within any SELECT | PASS |
| 20. No star projections | PASS |
| 21. Filters, joins, calculations, parameters preserved | PASS |
| 22. Aggregation grain preserved | PASS |
| 23. DISTINCT, UNION, window behavior preserved | PASS — None present |
| 24. No conflict silently corrected | PASS — All corrections documented |
| 25. No result-affecting procedural behavior discarded | PASS — No procedures present |
| 26. Runtime parameters documented; no DECLARE/SET | PASS |
| 27. Every CTE has standardized comment header | PASS |
| 28. CTE comments describe consolidated logic | PASS |
| 29. 100% logic match with minimum CTE structure | PASS |
| 30. Every lineage edge represented; no dependency bypassed | PASS (Issue 1 documented) |
| 31. Every filter/join/aggregation/parameter traced | PASS |
| 32. Every physical-column output uses exact BQ_COLUMN | PASS |

**Overall Status: COMPLETE WITH ISSUES TO FIX**

The consolidated SQL is complete and logically correct based on the supplied inputs. Two issues require validation before production deployment:
- **ISSUE 1** (MANDT 110 vs 120 in COMPFL) — requires business confirmation.
- **ISSUE 2** (upstream aggregation boundary) — low risk, requires confirmation.

The SQL is **not claimed to be production-ready** until these issues are resolved.
