# BigQuery Comparative Review Report

**Group:** RX BUDGET  
**Consolidated File:** RX_BUDGET Consolidated Query_v1  
**Mapping File:** Columns_Mapping.csv  
**Review Date:** 2025-07-14  

---

## Summary

| Group | Files Missed | Tables Missed | CTEs Missed | Columns Missed | Filters Missed | Status |
|-------|-------------|---------------|-------------|----------------|----------------|--------|
| RX BUDGET | 0 of 10 | 0 of 8 | 0 of 19 | 17 of 109 | 2 of 28 | **Items Missed** |

> **Counts:** Files = 10 individual files checked. Tables = 8 distinct source tables referenced across all files. CTEs = 19 distinct CTEs defined across all individual files. Columns = 109 distinct output columns checked across all individual files. Filters = 28 distinct filter conditions checked across all individual files.

---

## Missed Items

| Group | Type | Item | Source (File and Line) | Consolidated (Line, or "not present") | Notes |
|-------|------|------|------------------------|---------------------------------------|-------|
| RX BUDGET | Filter | `MANDT IN ('110', '200')` on `AZSRP_DS052_VT_S4` (Frozen_Cube) | CV_BASE_FIN_WEEKLY_BUDGET_S4 — line not determinable (Frozen_Cube WHERE clause) | Consolidated CTE `Base_AZSRP_DS052_VT_S4`, line ~line 60: `mandt IN ('120', '200')` | Individual file filters MANDT on values **'110'** and '200'. Consolidated uses **'120'** and '200'. The value '110' is absent; '120' is used instead. This changes the rows returned. Mapping file confirms MANDT maps to `mandt` (STRING); no mapping entry reconciles '110' → '120'. |
| RX BUDGET | Filter | `MANDT IN ('110', '200')` on `AZSRP_DS041_VT_S4` (Live_Cube) | CV_BASE_FIN_WEEKLY_BUDGET_S4 — line not determinable (Live_Cube WHERE clause) | Consolidated CTE `Base_AZSRP_DS041_VT_S4`, line ~line 100: `mandt IN ('120', '200')` | Same as above — individual file uses '110' and '200'; consolidated uses '120' and '200'. Value '110' is missing from the IN list. |
| RX BUDGET | Filter | `_BIC_ZIO_SWEEK BETWEEN $$IP_WEEK_ENDING_FROM$$ AND $$IP_WEEK_ENDING_TO$$` | CV_COMP_FIN_BUDGET_STATIC — line not determinable (WEEKLY_SNAPSHOT_DS05 WHERE clause) | Consolidated CTE `WEEKLY_SNAPSHOT_DS05`, line ~line 230: `bic_zio_sweek = (Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)` | Individual file applies a **range filter** (BETWEEN two input parameters: IP_WEEK_ENDING_FROM and IP_WEEK_ENDING_TO). Consolidated replaces this with a **single equality** to the prior week number only. A range filter returns multiple weeks; a single equality returns only one week. This changes the rows returned. |
| RX BUDGET | Column | `SPRAS` | CV_BASE_MD_CEPCT_S4 — line not determinable (SELECT list of Projected_Profit_Center_Texts CTE) | not present | CV_BASE_MD_CEPCT_S4 selects SPRAS from SAP_S4.CEPCT (→ BQ: `v_cepct.spras`). The consolidated `PROFIT_CENTER_TEXT` CTE (line ~line 390) selects only `mandt`, `prctr`, and `ltext`. Column `spras` is absent from the consolidated. Mapping: CEPCT.SPRAS → v_cepct.spras (STRING). |
| RX BUDGET | Column | `DATBI` | CV_BASE_MD_CEPCT_S4 — line not determinable (SELECT list of Projected_Profit_Center_Texts CTE) | not present | CV_BASE_MD_CEPCT_S4 selects DATBI from SAP_S4.CEPCT (→ BQ: `v_cepct.datbi`). Not selected in consolidated `PROFIT_CENTER_TEXT` CTE. Mapping: CEPCT.DATBI → v_cepct.datbi (DATE). |
| RX BUDGET | Column | `KOKRS` | CV_BASE_MD_CEPCT_S4 — line not determinable (SELECT list of Projected_Profit_Center_Texts CTE) | not present | CV_BASE_MD_CEPCT_S4 selects KOKRS from SAP_S4.CEPCT (→ BQ: `v_cepct.kokrs`). Not selected in consolidated `PROFIT_CENTER_TEXT` CTE. Mapping: CEPCT.KOKRS → v_cepct.kokrs (STRING). |
| RX BUDGET | Column | `KTEXT` | CV_BASE_MD_CEPCT_S4 — line not determinable (SELECT list of Projected_Profit_Center_Texts CTE) | not present | CV_BASE_MD_CEPCT_S4 selects KTEXT from SAP_S4.CEPCT (→ BQ: `v_cepct.ktext`). Not selected in consolidated `PROFIT_CENTER_TEXT` CTE. Mapping: CEPCT.KTEXT → v_cepct.ktext (STRING). |
| RX BUDGET | Column | `MCTXT` | CV_BASE_MD_CEPCT_S4 — line not determinable (SELECT list of Projected_Profit_Center_Texts CTE) | not present | CV_BASE_MD_CEPCT_S4 selects MCTXT from SAP_S4.CEPCT (→ BQ: `v_cepct.mctxt`). Not selected in consolidated `PROFIT_CENTER_TEXT` CTE. Mapping: CEPCT.MCTXT → v_cepct.mctxt (STRING). |
| RX BUDGET | Column | `HRYID` | CV_BASE_MD_HRRP_NODE_S4 — line not determinable (SELECT list of Projected_HRRP_Node_Records CTE) | not present | CV_BASE_MD_HRRP_NODE_S4 selects HRYID from SAP_S4.HRRP_NODE (→ BQ: `v_hrrp_node.hryid`). Consolidated `HIER_NODE` CTE (line ~line 245) selects only `mandt`, `parnode`, `hryvalto`, `nodevalue`. Column `hryid` is absent. Mapping: HRRP_NODE.HRYID → v_hrrp_node.hryid (STRING). |
| RX BUDGET | Column | `HRYVER` | CV_BASE_MD_HRRP_NODE_S4 — line not determinable (SELECT list of Projected_HRRP_Node_Records CTE) | not present | CV_BASE_MD_HRRP_NODE_S4 selects HRYVER from SAP_S4.HRRP_NODE (→ BQ: `v_hrrp_node.hryver`). Not selected in consolidated `HIER_NODE` CTE. Mapping: HRRP_NODE.HRYVER → v_hrrp_node.hryver (STRING). |
| RX BUDGET | Column | `NODECLS` | CV_BASE_MD_HRRP_NODE_S4 — line not determinable (SELECT list of Projected_HRRP_Node_Records CTE) | not present | CV_BASE_MD_HRRP_NODE_S4 selects NODECLS from SAP_S4.HRRP_NODE (→ BQ: `v_hrrp_node.nodecls`). Not selected in consolidated `HIER_NODE` CTE. Mapping: HRRP_NODE.NODECLS → v_hrrp_node.nodecls (STRING). |
| RX BUDGET | Column | `HRYNODE` | CV_BASE_MD_HRRP_NODE_S4 — line not determinable (SELECT list of Projected_HRRP_Node_Records CTE) | not present | CV_BASE_MD_HRRP_NODE_S4 selects HRYNODE from SAP_S4.HRRP_NODE (→ BQ: `v_hrrp_node.hrynode`). Not selected in consolidated `HIER_NODE` CTE. Mapping: HRRP_NODE.HRYNODE → v_hrrp_node.hrynode (STRING). |
| RX BUDGET | Column | `HRYVALFROM` | CV_BASE_MD_HRRP_NODE_S4 — line not determinable (SELECT list of Projected_HRRP_Node_Records CTE) | not present | CV_BASE_MD_HRRP_NODE_S4 selects HRYVALFROM from SAP_S4.HRRP_NODE (→ BQ: `v_hrrp_node.hryvalfrom`). Not selected in consolidated `HIER_NODE` CTE. Mapping: HRRP_NODE.HRYVALFROM → v_hrrp_node.hryvalfrom (DATE). |
| RX BUDGET | Column | `BALIND` | CV_BASE_MD_HRRP_NODE_S4 — line not determinable (SELECT list of Projected_HRRP_Node_Records CTE) | not present | CV_BASE_MD_HRRP_NODE_S4 selects BALIND from SAP_S4.HRRP_NODE (→ BQ: `v_hrrp_node.balind`). Not selected in consolidated `HIER_NODE` CTE. Mapping: HRRP_NODE.BALIND → v_hrrp_node.balind (STRING). |
| RX BUDGET | Column | `NODETYPE` | CV_BASE_MD_HRRP_NODE_S4 — line not determinable (SELECT list of Projected_HRRP_Node_Records CTE) | not present | CV_BASE_MD_HRRP_NODE_S4 selects NODETYPE from SAP_S4.HRRP_NODE (→ BQ: `v_hrrp_node.nodetype`). Not selected in consolidated `HIER_NODE` CTE. Mapping: HRRP_NODE.NODETYPE → v_hrrp_node.nodetype (STRING). |
| RX BUDGET | Column | `ZCALYRP` | CV_BASE_MD_RCALWEEK_S4 — line not determinable (SELECT list, no CTE wrapper) | not present | CV_BASE_MD_RCALWEEK_S4 selects ZCALYRP from SAP_S4.ZTFIGL_RCALWEEK (→ BQ: `v_ztfigl_rcalweek.zcalyrp`). Consolidated `CAL_WEEK` CTE (line ~line 330) selects only `zzweek`, `zrwstrtdate`, `zrwenddate`, `rclnt`. Column `zcalyrp` is absent. Mapping: ZTFIGL_RCALWEEK.ZCALYRP → v_ztfigl_rcalweek.zcalyrp (STRING). |
| RX BUDGET | Column | `ZRYEAR` | CV_BASE_MD_RCALWEEK_S4 — line not determinable (SELECT list, no CTE wrapper) | not present | CV_BASE_MD_RCALWEEK_S4 selects ZRYEAR from SAP_S4.ZTFIGL_RCALWEEK (→ BQ: `v_ztfigl_rcalweek.zryear`). Not selected in consolidated `CAL_WEEK` CTE. Mapping: ZTFIGL_RCALWEEK.ZRYEAR → v_ztfigl_rcalweek.zryear (STRING). |
| RX BUDGET | Column | `ZRPERIOD` | CV_BASE_MD_RCALWEEK_S4 — line not determinable (SELECT list, no CTE wrapper) | not present | CV_BASE_MD_RCALWEEK_S4 selects ZRPERIOD from SAP_S4.ZTFIGL_RCALWEEK (→ BQ: `v_ztfigl_rcalweek.zrperiod`). Not selected in consolidated `CAL_WEEK` CTE. Mapping: ZTFIGL_RCALWEEK.ZRPERIOD → v_ztfigl_rcalweek.zrperiod (STRING). |
| RX BUDGET | Column | `ZRYRP` | CV_BASE_MD_RCALWEEK_S4 — line not determinable (SELECT list, no CTE wrapper) | not present | CV_BASE_MD_RCALWEEK_S4 selects ZRYRP from SAP_S4.ZTFIGL_RCALWEEK (→ BQ: `v_ztfigl_rcalweek.zryrp`). Not selected in consolidated `CAL_WEEK` CTE. Mapping: ZTFIGL_RCALWEEK.ZRYRP → v_ztfigl_rcalweek.zryrp (STRING). |
| RX BUDGET | Column | `ZRYRQTR` | CV_BASE_MD_RCALWEEK_S4 — line not determinable (SELECT list, no CTE wrapper) | not present | CV_BASE_MD_RCALWEEK_S4 selects ZRYRQTR from SAP_S4.ZTFIGL_RCALWEEK (→ BQ: `v_ztfigl_rcalweek.zryrqtr`). Not selected in consolidated `CAL_WEEK` CTE. Mapping: ZTFIGL_RCALWEEK.ZRYRQTR → v_ztfigl_rcalweek.zryrqtr (STRING). |

---

## Detailed Findings by Individual File

### CV_BASE_FIN_WEEKLY_BUDGET_S4
| Item Type | Item | Status | Notes |
|-----------|------|--------|-------|
| Table | AZSRP_DS052_VT_S4 → v_bic_azsrp_ds202 | Found | Mapped via Columns_Mapping.csv |
| Table | AZSRP_DS041_VT_S4 → v_bic_azsrp_ds041 | Found | Mapped via Columns_Mapping.csv |
| CTE | Frozen_Cube | Found | Logic present in consolidated `Base_AZSRP_DS052_VT_S4` |
| CTE | Live_Cube | Found | Logic present in consolidated `Base_AZSRP_DS041_VT_S4` |
| CTE | Combined_Frozen_Live_Cube (Union_1) | Found | Logic present in consolidated `Combined_Frozen_Live_Cube` |
| CTE | Aggregated_Weekly_Budget | Found | Logic present in consolidated `Aggregated_Weekly_Budget` |
| CTE | Summed_Measures / RES_AMOUNT logic | Found | Logic present in consolidated `Weekly_Budget_With_Calculated_Amount` |
| Filter | MANDT IN ('110', '200') — Frozen_Cube | **MISSED** | Consolidated uses ('120', '200'); value '110' replaced by '120' |
| Filter | MANDT IN ('110', '200') — Live_Cube | **MISSED** | Consolidated uses ('120', '200'); value '110' replaced by '120' |
| Filter | IP_FC_COUNT != 0 | Found | Present in consolidated |
| Filter | IP_FC_COUNT = 0 | Found | Present in consolidated |
| Column | All 21 output columns (FISCPER, FISCVARNT, _BIC_ZIO_SWEEK, FISCYEAR, FISCPER3, _B631_S_CHRTACCT, _B631_S_GL_ACCT, _B631_S_CO_AREA, _BIC_ZIO_CMPCD, _B631_S_PROFTCTR, _B631_S_COSTCNTR, _B631_S_FUNCAREA, _BIC_ZIO_VER, _BIC_ZIO_SAUDT, MANDT, _BIC_ZWWPC_PA1, _BIC_ZWWSC_PA1, RECORDMODE, CURRENCY, _BIC_ZIO_AMT, _B631_S_AMOUNT) | Found | All present in consolidated (mapped names) |
| Column | Calculated: _B631_S_AMOUNT = IF(ISNULL(RES_AMOUNT_FC), RES_AMOUNT_LC, RES_AMOUNT_FC) | Found | Present in consolidated as CASE WHEN res_amount_fc IS NULL OR res_amount_fc = 0 THEN res_amount_lc ELSE res_amount_fc END |

---

### CV_BASE_MD_CEPCT_S4
| Item Type | Item | Status | Notes |
|-----------|------|--------|-------|
| Table | SAP_S4.CEPCT → v_cepct | Found | Mapped via Columns_Mapping.csv |
| CTE | Projected_Profit_Center_Texts | Found | Logic present in consolidated `PROFIT_CENTER_TEXT` CTE |
| Filter | MANDT IN (120, 200) | Found | Present in consolidated (numeric→string per mapping, not a missed item) |
| Column | MANDT | Found | Present in consolidated PROFIT_CENTER_TEXT CTE |
| Column | SPRAS | **MISSED** | Not selected in consolidated PROFIT_CENTER_TEXT CTE |
| Column | PRCTR | Found | Present in consolidated PROFIT_CENTER_TEXT CTE |
| Column | DATBI | **MISSED** | Not selected in consolidated PROFIT_CENTER_TEXT CTE |
| Column | KOKRS | **MISSED** | Not selected in consolidated PROFIT_CENTER_TEXT CTE |
| Column | KTEXT | **MISSED** | Not selected in consolidated PROFIT_CENTER_TEXT CTE |
| Column | LTEXT | Found | Present as `profit_center_text` alias in consolidated |
| Column | MCTXT | **MISSED** | Not selected in consolidated PROFIT_CENTER_TEXT CTE |

---

### CV_BASE_MD_COMPFL_S4
| Item Type | Item | Status | Notes |
|-----------|------|--------|-------|
| Table | SAP_S4.ZTSRP_COMPFL → v_ztsrp_compfl | Found | Mapped via Columns_Mapping.csv |
| Filter | MANDT IN (110, 200) | Found | Present in consolidated Base_ZTSRP_COMPFL CTE as mandt IN ('110', '200') |
| Column | MANDT, PRCTR, STRNUM, COMP_VER, ZWEEK, ZMONTH, ZYEAR, FS_COMP_PRE, RX_COMP_PRE, FS_COMP_MON, RX_COMP_MON, FS_COMP_WK, RX_COMP_WK | Found | All 13 columns present in consolidated Base_ZTSRP_COMPFL CTE |

---

### CV_BASE_MD_HRRP_NODE_S4
| Item Type | Item | Status | Notes |
|-----------|------|--------|-------|
| Table | SAP_S4.HRRP_NODE → v_hrrp_node | Found | Mapped via Columns_Mapping.csv |
| CTE | Projected_HRRP_Node_Records | Found | Logic present in consolidated `HIER_NODE` CTE |
| Filter | MANDT IN (120, 200) | Found | Present in consolidated HIER_NODE CTE as mandt IN ('120', '200') |
| Column | MANDT | Found | Present in consolidated HIER_NODE CTE |
| Column | HRYID | **MISSED** | Not selected in consolidated HIER_NODE CTE |
| Column | HRYVER | **MISSED** | Not selected in consolidated HIER_NODE CTE |
| Column | NODECLS | **MISSED** | Not selected in consolidated HIER_NODE CTE |
| Column | HRYNODE | **MISSED** | Not selected in consolidated HIER_NODE CTE |
| Column | PARNODE | Found | Present in consolidated HIER_NODE CTE |
| Column | HRYVALTO | Found | Present in consolidated HIER_NODE CTE |
| Column | HRYVALFROM | **MISSED** | Not selected in consolidated HIER_NODE CTE |
| Column | BALIND | **MISSED** | Not selected in consolidated HIER_NODE CTE |
| Column | NODETYPE | **MISSED** | Not selected in consolidated HIER_NODE CTE |
| Column | NODEVALUE | Found | Present in consolidated HIER_NODE CTE |

---

### CV_BASE_MD_RCALWEEK_S4
| Item Type | Item | Status | Notes |
|-----------|------|--------|-------|
| Table | SAP_S4.ZTFIGL_RCALWEEK → v_ztfigl_rcalweek | Found | Mapped via Columns_Mapping.csv |
| Filter | RCLNT IN (120, 200) | Found | Present in consolidated CAL_WEEK CTE as rclnt IN ('120', '200') |
| Column | RCLNT | Found | Present in consolidated CAL_WEEK CTE |
| Column | ZZWEEK | Found | Present in consolidated CAL_WEEK CTE |
| Column | ZCALYRP | **MISSED** | Not selected in consolidated CAL_WEEK CTE |
| Column | ZRYEAR | **MISSED** | Not selected in consolidated CAL_WEEK CTE |
| Column | ZRPERIOD | **MISSED** | Not selected in consolidated CAL_WEEK CTE |
| Column | ZRYRP | **MISSED** | Not selected in consolidated CAL_WEEK CTE |
| Column | ZRYRQTR | **MISSED** | Not selected in consolidated CAL_WEEK CTE |
| Column | ZRWSTRTDATE | Found | Present in consolidated CAL_WEEK CTE |
| Column | ZRWENDDATE | Found | Present in consolidated CAL_WEEK CTE |

---

### CV_BASE_MD_SRPACT_S4
| Item Type | Item | Status | Notes |
|-----------|------|--------|-------|
| Table | SAP_S4.ZTSRP_ATTR_ACT → v_ztsrp_attr_act | Found | Mapped via Columns_Mapping.csv |
| CTE | Filtered_Store_Profile_Attributes | Found | Logic present in consolidated `Base_ZTSRP_ATTR_ACT` CTE |
| Filter | MANDT IN (120, 200) | Found | Present in consolidated Base_ZTSRP_ATTR_ACT CTE as mandt IN ('120', '200') |
| Column | All 71 output columns (MANDT, STRNUM, PRCTR, KOKRS, KOSTL, RX_OPEN_DAT, RX_CLOSE_DAT, FS_OPEN_DAT, FS_CLOSE_DAT, REP_MKT_CODE, REP_MKT_DESC, ADDRESS, CITY, STATE, ZIPCODE, DIVISION_CODE, DIVISION_DESC, DIVISION_MGR, AREA_CODE, AREA_DESC, AREA_MGR, REGION_CODE, REGION_DESC, REGION_MGR, DISTRICT_CODE, DISTRICT_DESC, ZONE_CODE, DISTRICT_MGR, ZONE_DESC, MAJOR_REGION_CODE, MAJOR_REGION, STORE_TYPE, STORE_TYPE_DESC, RX_STORE_DESC, DISTRIBUTION_CNTR, DISTRIBUTION_CNTR_DESC, STORE_24_HR, BUDGET_OPEN_DAT, BUDGET_CLOSED_DAT, BUDGET_RELOC_DAT, CONST_OPEN_DAT, CONST_CLOSE_DAT, CONST_RELO_DAT, RELOCATION_DAT, EMERG_MKT_IND, BUDGET_EMERG_MKT_IND, COMPANY_CODE, COMPANY_CODE_DESC, ORIGINAL_FS_OPEN_DAT, ORIGINAL_RX_OPEN_DAT, GROUP_ONE, GROUP_TWO, ARD_SORT_KEY, AREA_COST_CENTER, REGIION_COST_CENTER, COUNTY_CODE, COUNTY_DESC, SQFT_BRACKET_DESC, SQFT_SORT_KEY, ACQUISITION_CODE, ACQUISITION_DESC, PHOTO_LAB_ADD_DAT, PHOTO_LAB_CLOSE_DAT, MIN_HRS_IND, CREATEDBY, CREATED_ON, RX_DIVISION_CODE, RX_AREA_CODE, RX_REGION_CODE, RX_DISTRICT_CODE, RX_HRS_OPER, FS_HRS_OPER, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT) | Found | All columns present in consolidated Base_ZTSRP_ATTR_ACT CTE |

---

### CV_COMP_FIN_BUDGET_STATIC
| Item Type | Item | Status | Notes |
|-----------|------|--------|-------|
| Table (via sub-view) | CV_BASE_FIN_WEEKLY_BUDGET_S4 → v_bic_azsrp_ds202 / v_bic_azsrp_ds041 | Found | Inlined in consolidated |
| Table (via sub-view) | CV_BASE_MD_HRRP_NODE_S4 → v_hrrp_node | Found | Present in consolidated HIER_NODE CTE |
| Table (via sub-view) | CV_COMP_MD_SRPACT_STATIC → v_ztsrp_attr_act | Found | Present in consolidated Base_ZTSRP_ATTR_ACT CTE |
| Table (via sub-view) | CV_COMP_MD_COMPFL_STATIC → v_ztsrp_compfl | Found | Present in consolidated Base_ZTSRP_COMPFL CTE |
| Table (via sub-view) | CV_BASE_MD_RCALWEEK_S4 → v_ztfigl_rcalweek | Found | Present in consolidated CAL_WEEK CTE |
| Table (via sub-view) | CV_BASE_MD_CEPCT_S4 → v_cepct | Found | Present in consolidated PROFIT_CENTER_TEXT CTE |
| CTE | WEEKLY_SNAPSHOT_DS05 | Found | Present in consolidated |
| CTE | HIER_NODE | Found | Present in consolidated |
| CTE | ONLY_CORE_RET_DATA | Found | Present in consolidated |
| CTE | STORE_ATTR_ACTUAL | Found | Present in consolidated |
| CTE | WEEK_NUMBER | Found | Logic present in consolidated (CAL_STORE_WEEK_NUMBER / cal_week_number) |
| CTE | COMP_FLAG_BUDGET | Found | Present in consolidated |
| CTE | CAL_WEEK | Found | Present in consolidated |
| CTE | PROFIT_CENTER_TEXT | Found | Present in consolidated |
| CTE | FLAGS | Found | Present in consolidated |
| Filter | FISCVARNT = 'K4' | Found | Present in consolidated WEEKLY_SNAPSHOT_DS05 WHERE clause |
| Filter | _BIC_ZIO_SWEEK BETWEEN @IP_WEEK_ENDING_FROM AND @IP_WEEK_ENDING_TO | **MISSED** | Consolidated replaces range with single equality: `bic_zio_sweek = (Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)`. A BETWEEN range returns multiple weeks; a single equality returns only one week. |
| Filter | _BIC_ZIO_VER = @IP_VERSION (default 'LEDGER_BUD') | Found | Consolidated uses hardcoded 'LEDGER_BUD' — same value as default |
| Filter | _BIC_ZIO_SAUDT IN ('1', '10') | Found | Present in consolidated |
| Filter | HIER_NODE: match(PARNODE, '*CORE_RET') | Found | Present as REGEXP_CONTAINS(parnode, r'.CORE_RET$') |
| Filter | HIER_NODE: HRYVALTO = '99991231' | Found | Present as hryvalto = DATE '9999-12-31' |
| Filter | COMP_FLAG_BUDGET: COMP_VER = @IP_VERSION | Found | Present as comp_ver = 'LEDGER_BUD' |
| Column | CAL_FS_RX_FLAG (CASE LEFTSTR(_BIC_ZWWPC_PA1,2)…) | Found | Present in consolidated FLAGS CTE as CASE LEFT(CAST(bic_zwwpc_pa1 AS STRING), 2)… |
| Column | CAL_COMP_FLAG (IF(ISNULL(CASE…))) | Found | Present in consolidated FLAGS CTE as IFNULL(CASE…) |
| Column | CAL_WEEK_NUMBER (RIGHTSTR(_BIC_ZIO_SWEEK,2)) | Found | Present in consolidated FLAGS CTE as RIGHT(CAST(bic_zio_sweek AS STRING), 2) |
| Column | _B631_S_AMOUNT = _B631_S_AMOUNT_NEGATIVE * -1 | Found | Present in consolidated FLAGS CTE as (b631_s_amount * -1) |
| Column | All other output columns (MANDT, FISCPER, FISCVARNT, FISCYEAR, FISCPER3, _BIC_ZIO_SWEEK, _B631_S_CHRTACCT, _B631_S_CO_AREA, _BIC_ZIO_CMPCD, _B631_S_PROFTCTR, FS_RX_FLAG, _B631_S_COSTCNTR, _B631_S_FUNCAREA, _BIC_ZIO_VER, _BIC_ZIO_SAUDT, _B631_S_GL_ACCT, _BIC_ZWWPC_PA1, _BIC_ZWWSC_PA1, _B631_S_AMOUNT_NEGATIVE, CURRENCY, _BIC_ZIO_AMT, REP_MKT_CODE, REP_MKT_DESC, EMERG_MKT_IND, FS_COMP_WK, RX_COMP_WK, COMP_FLAG, DIVISION_CODE, DIVISION_DESC, AREA_CODE, AREA_DESC, DISTRICT_CODE, DISTRICT_DESC, STRNUM, REGION_CODE, REGION_DESC, ZRWSTRTDATE, ZRWENDDATE, CAL_WEEK_NUMBER, CITY, STATE, PROFIT_CENTER_TEXT, FS_OPEN_DAT, RX_OPEN_DAT, FIN_BUD_CUBE, RX_DIVISION_CODE, RX_AREA_CODE, RX_REGION_CODE, RX_DISTRICT_CODE, _B631_S_AMOUNT) | Found | All present in consolidated final SELECT |

---

### CV_COMP_MD_COMPFL_STATIC
| Item Type | Item | Status | Notes |
|-----------|------|--------|-------|
| Table | TBL_WSS_SRP_COMPFLAG (procedure-replaced) → v_ztsrp_compfl | Found | Mapped via Columns_Mapping.csv; logic inlined in consolidated Base_ZTSRP_COMPFL CTE |
| CTE | TBL_WSS_SRP_COMPFLAG_FROM_STP_WSS_SRP_ATTRIBUTES | Found | Logic present in consolidated Base_ZTSRP_COMPFL CTE |
| Filter | ZWEEK = @V_WEEK | Found | Present in consolidated as `zweek = (Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)` |
| Column | MANDT, PRCTR, STRNUM, COMP_VER, ZWEEK, ZMONTH, ZYEAR, FS_COMP_PRE, RX_COMP_PRE, FS_COMP_MON, RX_COMP_MON, FS_COMP_WK, RX_COMP_WK | Found | All 13 columns present in consolidated Base_ZTSRP_COMPFL CTE |

---

### CV_COMP_MD_SRPACT_STATIC
| Item Type | Item | Status | Notes |
|-----------|------|--------|-------|
| Table | TBL_WSS_SRP_ATTR_ACT → v_ztsrp_attr_act | Found | Mapped via Columns_Mapping.csv; logic inlined in consolidated Base_ZTSRP_ATTR_ACT CTE |
| Filter | None defined in this view | N/A | No filters to check |
| Column | All output columns (MANDT, STRNUM, PRCTR, KOKRS, KOSTL, RX_OPEN_DAT, RX_CLOSE_DAT, FS_OPEN_DAT, FS_CLOSE_DAT, REP_MKT_CODE, REP_MKT_DESC, ADDRESS, CITY, STATE, ZIPCODE, DIVISION_CODE, DIVISION_DESC, DIVISION_MGR, AREA_CODE, AREA_DESC, AREA_MGR, REGION_CODE, REGION_DESC, REGION_MGR, DISTRICT_CODE, DISTRICT_DESC, ZONE_CODE, DISTRICT_MGR, ZONE_DESC, MAJOR_REGION_CODE, MAJOR_REGION, STORE_TYPE, STORE_TYPE_DESC, RX_STORE_DESC, DISTRIBUTION_CNTR, DISTRIBUTION_CNTR_DESC, STORE_24_HR, BUDGET_OPEN_DAT, BUDGET_CLOSED_DAT, BUDGET_RELOC_DAT, CONST_OPEN_DAT, CONST_CLOSE_DAT, CONST_RELO_DAT, RELOCATION_DAT, EMERG_MKT_IND, BUDGET_EMERG_MKT_IND, COMPANY_CODE, COMPANY_CODE_DESC, ORIGINAL_FS_OPEN_DAT, ORIGINAL_RX_OPEN_DAT, GROUP_ONE, GROUP_TWO, ARD_SORT_KEY, AREA_COST_CENTER, REGIION_COST_CENTER, COUNTY_CODE, COUNTY_DESC, SQFT_BRACKET_DESC, SQFT_SORT_KEY, ACQUISITION_CODE, ACQUISITION_DESC, PHOTO_LAB_ADD_DAT, PHOTO_LAB_CLOSE_DAT, MIN_HRS_IND, CREATEDBY, CREATED_ON, RX_DIVISION_CODE, RX_AREA_CODE, RX_REGION_CODE, RX_DISTRICT_CODE, RX_HRS_OPER, FS_HRS_OPER, RX_STORE, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT) | Found | All columns present in consolidated Base_ZTSRP_ATTR_ACT CTE |

---

### STP_WSS_SRP_ATTRIBUTES
| Item Type | Item | Status | Notes |
|-----------|------|--------|-------|
| Table | CV_BASE_MD_SRPACT_S4 → v_ztsrp_attr_act | Found | Logic inlined in consolidated Base_ZTSRP_ATTR_ACT CTE |
| Table | CV_BASE_MD_COMPFL_S4 → v_ztsrp_compfl | Found | Logic inlined in consolidated Base_ZTSRP_COMPFL CTE |
| Table | TBL_WSS_SRP_ATTR_ACT → v_ztsrp_attr_act | Found | Mapped via Columns_Mapping.csv |
| Table | TBL_WSS_SRP_COMPFLAG → v_ztsrp_compfl | Found | Mapped via Columns_Mapping.csv |
| Filter | ZWEEK = V_WEEK (for TBL_WSS_SRP_COMPFLAG INSERT) | Found | Present in consolidated Base_ZTSRP_COMPFL CTE |
| Column | All 68 target columns for TBL_WSS_SRP_ATTR_ACT (excluding audit columns SNAPSHOT_TIMESTAMP, SNAPSHOT_CREATED_BY per source file note) | Found | All present in consolidated Base_ZTSRP_ATTR_ACT CTE |
| Column | All 13 target columns for TBL_WSS_SRP_COMPFLAG (excluding audit columns SNAPSHOT_TIMESTAMP, CREATED_BY per source file note) | Found | All present in consolidated Base_ZTSRP_COMPFL CTE |

---

## Overall Status: **Items Missed**

**Missed Items Count: 19**
- Filters Missed: 2 (MANDT IN ('110','200') filter value '110' replaced by '120' in both Frozen_Cube and Live_Cube; BETWEEN range filter replaced by single equality in WEEKLY_SNAPSHOT_DS05)
- Columns Missed: 17 (5 from CV_BASE_MD_CEPCT_S4; 7 from CV_BASE_MD_HRRP_NODE_S4; 5 from CV_BASE_MD_RCALWEEK_S4)

---

*Report generated by Data Engineer Agent. Review only — no SQL modifications made.*
