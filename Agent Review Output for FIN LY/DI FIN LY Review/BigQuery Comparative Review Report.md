# BigQuery Comparative Review Report

**Group:** FIN LY  
**Consolidated File:** FIN_LY Consolidated File_v1.sql  
**Review Date:** 2025-07-14  

---

## Summary

| Group | Files Missed | Tables Missed | CTEs Missed | Columns Missed | Filters Missed | Status |
|-------|-------------|---------------|-------------|----------------|----------------|--------|
| FIN LY | 1 of 11 | 0 of 8 | 0 of 17 | 17 of 131 | 2 of 38 | **Items Missed** |

---

## Missed Items

| Group | Type | Item | Source (File and Line) | Consolidated (Line, or "not present") | Notes |
|-------|------|------|------------------------|---------------------------------------|-------|
| FIN LY | File | STP_WSS_SRP_ATTRIBUTES_DI | `STP_WSS_SRP_ATTRIBUTES_DI HANA to BigQuery SQL Conversion Agent.txt` — entire file | not present | The source artifact is a HANA SQLScript procedure containing DML logic: DECLARE variables, SET V_WEEK via scalar function SFN_PRIOR_FISCAL_WEEK(), DELETE FROM TBL_WSS_SRP_ATTR_ACT, DELETE FROM TBL_WSS_SRP_COMPFLAG, INSERT INTO TBL_WSS_SRP_ATTR_ACT (from CV_BASE_MD_SRPACT_S4), INSERT INTO TBL_WSS_SRP_COMPFLAG (from CV_BASE_MD_COMPFL_S4 WHERE ZWEEK = V_WEEK), and a summary SELECT. The consolidated file is a pure SELECT query; none of the procedural DML logic (DELETE, INSERT, variable assignment, summary output) is present. |
| FIN LY | Column | HRYVER (GL_HEIR hierarchy) | `GL_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — SOURCE_COLUMNS_AND_MAPPINGS, line not determinable | not present | GL_HIER CTE in consolidated (approx. line 130–148) selects only `mandt, parnode, hryvalto, nodevalue, hryid, LTRIM(nodevalue,'0') AS cal_node_value`. Column `hryver` (mapped from HANA HRYVER) is absent. |
| FIN LY | Column | NODECLS (GL_HEIR hierarchy) | `GL_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — SOURCE_COLUMNS_AND_MAPPINGS, line not determinable | not present | GL_HIER CTE in consolidated does not select `nodecls`. |
| FIN LY | Column | HRYNODE (GL_HEIR hierarchy) | `GL_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — SOURCE_COLUMNS_AND_MAPPINGS, line not determinable | not present | GL_HIER CTE in consolidated does not select `hrynode`. |
| FIN LY | Column | HRYVALFROM (GL_HEIR hierarchy) | `GL_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — SOURCE_COLUMNS_AND_MAPPINGS, line not determinable | not present | GL_HIER CTE in consolidated does not select `hryvalfrom`. |
| FIN LY | Column | BALIND (GL_HEIR hierarchy) | `GL_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — SOURCE_COLUMNS_AND_MAPPINGS, line not determinable | not present | GL_HIER CTE in consolidated does not select `balind`. |
| FIN LY | Column | NODETYPE (GL_HEIR hierarchy) | `GL_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — SOURCE_COLUMNS_AND_MAPPINGS, line not determinable | not present | GL_HIER CTE in consolidated does not select `nodetype`. |
| FIN LY | Column | HRYID (PC_HEIR hierarchy) | `PC_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — SOURCE_COLUMNS_AND_MAPPINGS, line not determinable | not present | PC_HIER CTE in consolidated (approx. line 90–105) selects only `mandt, parnode, hryvalto, nodevalue`. Column `hryid` (mapped from HANA HRYID) is absent. |
| FIN LY | Column | HRYVER (PC_HEIR hierarchy) | `PC_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — SOURCE_COLUMNS_AND_MAPPINGS, line not determinable | not present | PC_HIER CTE in consolidated does not select `hryver`. |
| FIN LY | Column | NODECLS (PC_HEIR hierarchy) | `PC_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — SOURCE_COLUMNS_AND_MAPPINGS, line not determinable | not present | PC_HIER CTE in consolidated does not select `nodecls`. |
| FIN LY | Column | HRYNODE (PC_HEIR hierarchy) | `PC_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — SOURCE_COLUMNS_AND_MAPPINGS, line not determinable | not present | PC_HIER CTE in consolidated does not select `hrynode`. |
| FIN LY | Column | HRYVALFROM (PC_HEIR hierarchy) | `PC_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — SOURCE_COLUMNS_AND_MAPPINGS, line not determinable | not present | PC_HIER CTE in consolidated does not select `hryvalfrom`. |
| FIN LY | Column | BALIND (PC_HEIR hierarchy) | `PC_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — SOURCE_COLUMNS_AND_MAPPINGS, line not determinable | not present | PC_HIER CTE in consolidated does not select `balind`. |
| FIN LY | Column | NODETYPE (PC_HEIR hierarchy) | `PC_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt` — SOURCE_COLUMNS_AND_MAPPINGS, line not determinable | not present | PC_HIER CTE in consolidated does not select `nodetype`. |
| FIN LY | Column | SNAPSHOT_TIMESTAMP (TBL_WSS_SRP_ATTR_ACT insert) | `STP_WSS_SRP_ATTRIBUTES_DI HANA to BigQuery SQL Conversion Agent.txt` — INSERT INTO TBL_WSS_SRP_ATTR_ACT column list, line not determinable | not present | The procedure inserts CURRENT_TIMESTAMP as SNAPSHOT_TIMESTAMP into TBL_WSS_SRP_ATTR_ACT. This column and its value are absent from the consolidated SELECT query. |
| FIN LY | Column | SNAPSHOT_CREATED_BY (TBL_WSS_SRP_ATTR_ACT insert) | `STP_WSS_SRP_ATTRIBUTES_DI HANA to BigQuery SQL Conversion Agent.txt` — INSERT INTO TBL_WSS_SRP_ATTR_ACT column list, line not determinable | not present | The procedure inserts SESSION_USER as SNAPSHOT_CREATED_BY into TBL_WSS_SRP_ATTR_ACT. This column and its value are absent from the consolidated SELECT query. |
| FIN LY | Column | SNAPSHOT_TIMESTAMP (TBL_WSS_SRP_COMPFLAG insert) | `STP_WSS_SRP_ATTRIBUTES_DI HANA to BigQuery SQL Conversion Agent.txt` — INSERT INTO TBL_WSS_SRP_COMPFLAG column list, line not determinable | not present | The procedure inserts CURRENT_TIMESTAMP as SNAPSHOT_TIMESTAMP into TBL_WSS_SRP_COMPFLAG. This column and its value are absent from the consolidated SELECT query. |
| FIN LY | Column | CREATED_BY (TBL_WSS_SRP_COMPFLAG insert) | `STP_WSS_SRP_ATTRIBUTES_DI HANA to BigQuery SQL Conversion Agent.txt` — INSERT INTO TBL_WSS_SRP_COMPFLAG column list, line not determinable | not present | The procedure inserts SESSION_USER as CREATED_BY into TBL_WSS_SRP_COMPFLAG. This column and its value are absent from the consolidated SELECT query. |
| FIN LY | Filter | `_BIC_ZIO_VER = @IP_VERSION` (runtime parameter) | `CV_COMP_FIN_ACTUAL_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt` — WEEKLY_SNAPSHOT_DS05 filter, line not determinable | Consolidated approx. line 97: `AND bic_zio_ver = 'ACT01'` | The individual file defines this as a runtime parameter `@IP_VERSION` (mapped from HANA `$$IP_VERSION$$`), allowing callers to supply any version value at runtime. The consolidated file hardcodes the literal `'ACT01'`, which changes the filter so it returns different rows for any caller that would supply a version other than `'ACT01'`. The filter is no longer parameterised. |
| FIN LY | Filter | `COMP_VER = @IP_VERSION_COMP_FLAG` (runtime parameter) | `CV_COMP_FIN_ACTUAL_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt` — COMP_FLAG_LY filter, line not determinable | Consolidated approx. line 330: `AND comp_ver = 'ACT01'` | The individual file defines this as a runtime parameter `@IP_VERSION_COMP_FLAG` (mapped from HANA `$$IP_VERSION_COMP_FLAG$$`), allowing callers to supply any comp-flag version at runtime. The consolidated file hardcodes the literal `'ACT01'`, which changes the filter so it returns different rows for any caller that would supply a version other than `'ACT01'`. The filter is no longer parameterised. |

---

## Detailed Review Notes

### Files Checked (11 total)

| # | Individual File | Logic Found in Consolidated | Result |
|---|----------------|----------------------------|--------|
| 1 | CV_BASE_FIN_WEEKLY_ACTUAL_S4_DI | Yes — WEEKLY_SNAPSHOT_DS05 CTE reads from `v_bic_azsrp_ds212` (mapped from AZSRP_DS072_VT_S4) with all columns and filters | Found |
| 2 | CV_BASE_MD_CEPCT_S4_DI | Yes — PROFIT_CENTER_TEXT CTE reads from `v_cepct` (mapped from CEPCT) with all columns and MANDT filter | Found |
| 3 | CV_BASE_MD_COMPFL_S4_DI | Yes — COMP_FLAG_LY CTE reads from `v_ztsrp_compfl` (mapped from ZTSRP_COMPFL / TBL_WSS_SRP_COMPFLAG) with all columns | Found |
| 4 | CV_BASE_MD_RCALWEEL_S4_DI | Yes — RETAIL_CAL CTE reads from `v_ztfigl_rcalweek` (mapped from ZTFIGL_RCALWEEK) with all columns and RCLNT filter | Found |
| 5 | CV_BASE_MD_SRPACT_S4_DI | Yes — STORE_ATTR_ACTUAL CTE reads from `v_ztsrp_attr_act` (mapped from ZTSRP_ATTR_ACT) with all columns and MANDT filter | Found |
| 6 | CV_COMP_FIN_ACTUAL_STATIC_DI | Yes — all join/projection/flag logic is present across CTEs; two filter parameters are hardcoded (see Missed Items) | Found (with missed filters) |
| 7 | CV_COMP_MD_COMPFL_STATIC_DI | Yes — COMP_FLAG_LY CTE covers all 13 columns from TBL_WSS_SRP_COMPFLAG | Found |
| 8 | CV_COMP_MD_SRPACT_STATIC_DI | Yes — STORE_ATTR_ACTUAL CTE covers all columns from TBL_WSS_SRP_ATTR_ACT | Found |
| 9 | GL_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI | Partial — GL_HIER CTE reads from `v_hrrp_node` with correct filters, but 6 of 11 columns are absent | Found (with missed columns) |
| 10 | PC_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI | Partial — PC_HIER CTE reads from `v_hrrp_node` with correct filters, but 7 of 11 columns are absent | Found (with missed columns) |
| 11 | STP_WSS_SRP_ATTRIBUTES_DI | No — procedural DML logic (DELETE, INSERT, variable assignment, summary output) is entirely absent | **Missed** |

### Tables Checked (8 unique source tables)

| HANA Table | BQ Mapped Table | Referenced in Consolidated | Result |
|-----------|----------------|---------------------------|--------|
| AZSRP_DS072_VT_S4 | v_bic_azsrp_ds212 | Yes — WEEKLY_SNAPSHOT_DS05 CTE | Found |
| CEPCT | v_cepct | Yes — PROFIT_CENTER_TEXT CTE | Found |
| ZTFIGL_RCALWEEK | v_ztfigl_rcalweek | Yes — RETAIL_CAL CTE and WEEKDATES CTE | Found |
| ZTSRP_ATTR_ACT | v_ztsrp_attr_act | Yes — STORE_ATTR_ACTUAL CTE | Found |
| ZTSRP_COMPFL (TBL_WSS_SRP_COMPFLAG) | v_ztsrp_compfl | Yes — COMP_FLAG_LY CTE | Found |
| HRRP_NODE (GL_HEIR usage) | v_hrrp_node | Yes — GL_HIER CTE | Found |
| HRRP_NODE (PC_HEIR usage) | v_hrrp_node | Yes — PC_HIER CTE | Found |
| v_finsc_fisc_date (new in consolidated) | v_finsc_fisc_date | Yes — WEEKDATES CTE (added logic, not checked) | N/A |

### CTEs Checked (17 from CV_COMP_FIN_ACTUAL_STATIC_DI)

| Individual CTE | Consolidated Equivalent | Result |
|---------------|------------------------|--------|
| WEEKLY_SNAPSHOT_DS05 | WEEKLY_SNAPSHOT_DS05 | Found |
| PC_HIER | PC_HIER | Found |
| Join_4 | Join_WeeklySnapshot_PC_Hier | Found |
| GL_HIER | GL_HIER | Found |
| Join_6 | Join_GL_Hier | Found |
| Projection_1 (adds CAL_WEEK) | Join_GL_Hier (cal_week added inline) | Found |
| STORE_ATTR_ACTUAL | STORE_ATTR_ACTUAL | Found |
| Join_2 | Join_Projection_StoreAttr | Found |
| RETAIL_CAL | RETAIL_CAL | Found |
| Join_1 | Join_RetailCal | Found |
| WEEK_NUMBER | Join_RetailCal (pass-through) | Found |
| COMP_FLAG_LY | COMP_FLAG_LY | Found |
| Join_3 | Join_CompFlag | Found |
| PROFIT_CENTER_TEXT | PROFIT_CENTER_TEXT | Found |
| Join_5 | Join_ProfitCenterText | Found |
| FLAGS | FLAGS | Found |
| FLAGS_FINAL | Final SELECT (inline) | Found |

---

## Overall Status: **Items Missed**
