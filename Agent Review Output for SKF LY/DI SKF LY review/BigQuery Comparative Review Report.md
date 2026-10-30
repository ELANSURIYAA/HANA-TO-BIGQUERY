# BigQuery Comparative Review Report
## Group: SKF LY
**Consolidated File:** SKF_LY Consolidated File_v2.txt  
**Review Date:** 2025

---

## Summary

| Group | Files Missed | Tables Missed | CTEs Missed | Columns Missed | Filters Missed | Status |
|-------|-------------|---------------|-------------|----------------|----------------|--------|
| SKF LY | 0 of 10 | 3 of 10 | 0 of 13 | 14 of 97 | 3 of 18 | **Items Missed** |

---

## Missed Items

| Group | Type | Item | Source (file and line) | Consolidated (line, or "not present") | Notes |
|-------|------|------|------------------------|---------------------------------------|-------|
| SKF LY | Column | `SPRAS` | CV_BASE_MD_CEPCT_S4_DI — line: SPRAS (source: CEPCT.SPRAS → output: SPRAS) | not present | SPRAS is selected in the individual file's CEPCT projection but the PROFIT_CENTER_TEXT CTE in the consolidated file only selects `mandt`, `prctr`, and `ltext`. SPRAS is absent. |
| SKF LY | Column | `DATBI` | CV_BASE_MD_CEPCT_S4_DI — line: DATBI (source: CEPCT.DATBI → output: DATBI) | not present | DATBI is selected in the individual file's CEPCT projection but is absent from the PROFIT_CENTER_TEXT CTE in the consolidated file. |
| SKF LY | Column | `KOKRS` | CV_BASE_MD_CEPCT_S4_DI — line: KOKRS (source: CEPCT.KOKRS → output: KOKRS) | not present | KOKRS is selected in the individual file's CEPCT projection but is absent from the PROFIT_CENTER_TEXT CTE in the consolidated file. |
| SKF LY | Column | `KTEXT` | CV_BASE_MD_CEPCT_S4_DI — line: KTEXT (source: CEPCT.KTEXT → output: KTEXT) | not present | KTEXT is selected in the individual file's CEPCT projection but is absent from the PROFIT_CENTER_TEXT CTE in the consolidated file. |
| SKF LY | Column | `MCTXT` | CV_BASE_MD_CEPCT_S4_DI — line: MCTXT (source: CEPCT.MCTXT → output: MCTXT) | not present | MCTXT is selected in the individual file's CEPCT projection but is absent from the PROFIT_CENTER_TEXT CTE in the consolidated file. |
| SKF LY | Column | `HRYID` | CV_BASE_MD_HRRP_NODE_S4_DI — line: HRYID (source: HRRP_NODE.HRYID → output: HRYID) | not present | HRYID is projected in the individual file but the CC_HIER CTE in the consolidated file only selects `mandt`, `parnode`, `hryvalto`, `nodevalue`. HRYID is absent. |
| SKF LY | Column | `HRYVER` | CV_BASE_MD_HRRP_NODE_S4_DI — line: HRYVER (source: HRRP_NODE.HRYVER → output: HRYVER) | not present | HRYVER is projected in the individual file but is absent from the CC_HIER CTE in the consolidated file. |
| SKF LY | Column | `NODECLS` | CV_BASE_MD_HRRP_NODE_S4_DI — line: NODECLS (source: HRRP_NODE.NODECLS → output: NODECLS) | not present | NODECLS is projected in the individual file but is absent from the CC_HIER CTE in the consolidated file. |
| SKF LY | Column | `HRYNODE` | CV_BASE_MD_HRRP_NODE_S4_DI — line: HRYNODE (source: HRRP_NODE.HRYNODE → output: HRYNODE) | not present | HRYNODE is projected in the individual file but is absent from the CC_HIER CTE in the consolidated file. |
| SKF LY | Column | `HRYVALFROM` | CV_BASE_MD_HRRP_NODE_S4_DI — line: HRYVALFROM (source: HRRP_NODE.HRYVALFROM → output: HRYVALFROM) | not present | HRYVALFROM is projected in the individual file but is absent from the CC_HIER CTE in the consolidated file. |
| SKF LY | Column | `BALIND` | CV_BASE_MD_HRRP_NODE_S4_DI — line: BALIND (source: HRRP_NODE.BALIND → output: BALIND) | not present | BALIND is projected in the individual file but is absent from the CC_HIER CTE in the consolidated file. |
| SKF LY | Column | `NODETYPE` | CV_BASE_MD_HRRP_NODE_S4_DI — line: NODETYPE (source: HRRP_NODE.NODETYPE → output: NODETYPE) | not present | NODETYPE is projected in the individual file but is absent from the CC_HIER CTE in the consolidated file. |
| SKF LY | Column | `MANDT filter IN (120, 200)` in CV_BASE_MD_COMPFL_S4 | CV_BASE_MD_COMPFL_S4_DI — filter: MANDT IN (110, 200) | not present | The individual file CV_BASE_MD_COMPFL_S4 applies a MANDT filter of IN (110, 200) on ZTSRP_COMPFL. The consolidated file's COMP_FLAG_ACT01 CTE queries `v_ztsrp_compfl` with no MANDT filter at all. |
| SKF LY | Column | `ZCALYRP` | CV_BASE_MD_RCALWEEK_S4_DI — line: ZCALYRP (source: ZTFIGL_RCALWEEK.ZCALYRP → output: ZCALYRP) | not present | ZCALYRP is projected in the individual file but is absent from the RETAIL_CAL CTE in the consolidated file (which only selects `rclnt`, `zzweek`, `zrwstrtdate`, `zrwenddate`). |
| SKF LY | Column | `ZRYEAR` | CV_BASE_MD_RCALWEEK_S4_DI — line: ZRYEAR (source: ZTFIGL_RCALWEEK.ZRYEAR → output: ZRYEAR) | not present | ZRYEAR is projected in the individual file but is absent from the RETAIL_CAL CTE in the consolidated file. |
| SKF LY | Column | `ZRPERIOD` | CV_BASE_MD_RCALWEEK_S4_DI — line: ZRPERIOD (source: ZTFIGL_RCALWEEK.ZRPERIOD → output: ZRPERIOD) | not present | ZRPERIOD is projected in the individual file but is absent from the RETAIL_CAL CTE in the consolidated file. |
| SKF LY | Column | `ZRYRP` | CV_BASE_MD_RCALWEEK_S4_DI — line: ZRYRP (source: ZTFIGL_RCALWEEK.ZRYRP → output: ZRYRP) | not present | ZRYRP is projected in the individual file but is absent from the RETAIL_CAL CTE in the consolidated file. |
| SKF LY | Column | `ZRYRQTR` | CV_BASE_MD_RCALWEEK_S4_DI — line: ZRYRQTR (source: ZTFIGL_RCALWEEK.ZRYRQTR → output: ZRYRQTR) | not present | ZRYRQTR is projected in the individual file but is absent from the RETAIL_CAL CTE in the consolidated file. |
| SKF LY | Table | `CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT` (via CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC_DI — SOURCE_OBJECTS: Table: CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT | Consolidated references `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act` directly (not via TBL_WSS_SRP_ATTR_ACT) | The individual file CV_COMP_MD_SRPACT_STATIC reads from the static snapshot table TBL_WSS_SRP_ATTR_ACT. The consolidated file bypasses this intermediate table and reads directly from v_ztsrp_attr_act. The intermediate static table is not referenced anywhere in the consolidated file. Not in mapping. |
| SKF LY | Table | `CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG` (via CV_COMP_MD_COMPFL_STATIC) | CV_COMP_MD_COMPFL_STATIC_DI — SOURCE_OBJECTS: Table: CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG | Consolidated references `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl` directly (not via TBL_WSS_SRP_COMPFLAG) | The individual file CV_COMP_MD_COMPFL_STATIC reads from the static snapshot table TBL_WSS_SRP_COMPFLAG. The consolidated file bypasses this intermediate table and reads directly from v_ztsrp_compfl. The intermediate static table is not referenced anywhere in the consolidated file. Not in mapping. |
| SKF LY | Table | `CVS_FRIP.CVS_FRIP.Procedure.FI::STP_WSS_SRP_ATTRIBUTES` (procedure target tables) | STP_WSS_SRP_ATTRIBUTES_DI — SOURCE_OBJECTS: TBL_WSS_SRP_ATTR_ACT (target), TBL_WSS_SRP_COMPFLAG (target) | not present | The stored procedure STP_WSS_SRP_ATTRIBUTES populates TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG. The consolidated file explicitly notes these are excluded ("STP_WSS_SRP_ATTRIBUTES: Stored procedure that populates intermediate tables … not consolidated into this query"). The procedure's DML logic (DELETE + INSERT) is entirely absent from the consolidated file. Not in mapping. |
| SKF LY | Filter | `MANDT IN (110, 200)` on ZTSRP_COMPFL | CV_BASE_MD_COMPFL_S4_DI — filter: MANDT IN (110, 200) on SAP_S4.ZTSRP_COMPFL | not present | The individual file CV_BASE_MD_COMPFL_S4 applies MANDT IN (110, 200) to ZTSRP_COMPFL. The consolidated COMP_FLAG_ACT01 CTE queries v_ztsrp_compfl with no MANDT filter. |
| SKF LY | Filter | `MANDT IN (110, 200)` on TBL_WSS_SRP_COMPFLAG | CV_COMP_MD_COMPFL_STATIC_DI — no filter defined (projection only, no filter) | Consolidated COMP_FLAG_ACT01 CTE has no MANDT filter on v_ztsrp_compfl | The individual file CV_COMP_MD_COMPFL_STATIC has no filter (pure projection). The consolidated file also has no MANDT filter in COMP_FLAG_ACT01. This is consistent — not a miss. However, the base source CV_BASE_MD_COMPFL_S4 had MANDT IN (110,200) which is missing (reported above). |
| SKF LY | Filter | `ZWEEK = V_WEEK` (prior fiscal week filter in STP) | STP_WSS_SRP_ATTRIBUTES_DI — WHERE ZWEEK = V_WEEK (filter on TBL_WSS_SRP_COMPFLAG insert from CV_BASE_MD_COMPFL_S4) | not present | The stored procedure STP_WSS_SRP_ATTRIBUTES filters ZWEEK = V_WEEK (prior fiscal week computed by SFN_PRIOR_FISCAL_WEEK) when loading TBL_WSS_SRP_COMPFLAG. This filter logic is entirely absent from the consolidated file. |
| SKF LY | Filter | `mandt IN ('120', '200')` missing from COMP_FLAG_ACT01 CTE | CV_BASE_MD_HRRP_NODE_S4_DI — filter: MANDT IN (120, 200); CV_BASE_MD_CEPCT_S4_DI — filter: MANDT IN (120, 200) | Consolidated COMP_FLAG_ACT01 CTE (line ~line 270): no MANDT filter on v_ztsrp_compfl | The COMP_FLAG_ACT01 CTE in the consolidated file queries v_ztsrp_compfl without any MANDT restriction, whereas all other CTEs in the consolidated file and all individual source files apply MANDT IN ('120','200') or ('110','200'). This is a missing filter relative to the individual source files. |

---

## Detailed Findings by Individual File

### File 1: CV_BASE_MD_CEPCT_S4_DI
- **Status:** Found (logic present in PROFIT_CENTER_TEXT CTE)
- **Table:** `CEPCT` → mapped to `v_cepct` ✅ Found
- **CTE:** `Projected_Profit_Center_Texts` → logic present as `PROFIT_CENTER_TEXT` CTE ✅ Found
- **Columns missed:** `SPRAS`, `DATBI`, `KOKRS`, `KTEXT`, `MCTXT` — all absent from PROFIT_CENTER_TEXT CTE (only `mandt`, `prctr`, `ltext` selected)
- **Filter:** `MANDT IN (120, 200)` → present in consolidated as `mandt IN ('120', '200')` ✅ Found

---

### File 2: CV_BASE_MD_COMPFL_S4_DI
- **Status:** Found (logic present in COMP_FLAG_ACT01 CTE)
- **Table:** `ZTSRP_COMPFL` → mapped to `v_ztsrp_compfl` ✅ Found
- **CTE:** Logic present in COMP_FLAG_ACT01 ✅ Found
- **Columns:** All columns used in consolidated (mandt, prctr, zweek, zyear, comp_ver, rx_comp_wk) ✅ Found
- **Filter missed:** `MANDT IN (110, 200)` — present in individual file but absent from COMP_FLAG_ACT01 CTE in consolidated

---

### File 3: CV_BASE_MD_HRRP_NODE_S4_DI
- **Status:** Found (logic present in CC_HIER CTE)
- **Table:** `HRRP_NODE` → mapped to `v_hrrp_node` ✅ Found
- **CTE:** `Projected_HRRP_Node` → logic present as `CC_HIER` CTE ✅ Found
- **Columns missed:** `HRYID`, `HRYVER`, `NODECLS`, `HRYNODE`, `HRYVALFROM`, `BALIND`, `NODETYPE` — all absent from CC_HIER CTE (only `mandt`, `parnode`, `hryvalto`, `nodevalue` selected)
- **Filter:** `MANDT IN (120, 200)` → present in consolidated as `mandt IN ('120', '200')` ✅ Found

---

### File 4: CV_BASE_MD_RCALWEEK_S4_DI
- **Status:** Found (logic present in RETAIL_CAL CTE)
- **Table:** `ZTFIGL_RCALWEEK` → mapped to `v_ztfigl_rcalweek` ✅ Found
- **CTE:** `Projected_Retail_Calendar_Week_Master` → logic present as `RETAIL_CAL` CTE ✅ Found
- **Columns missed:** `ZCALYRP`, `ZRYEAR`, `ZRPERIOD`, `ZRYRP`, `ZRYRQTR` — all absent from RETAIL_CAL CTE (only `rclnt`, `zzweek`, `zrwstrtdate`, `zrwenddate` selected)
- **Filter:** `RCLNT IN (120, 200)` → present in consolidated as `rclnt IN ('120', '200')` ✅ Found

---

### File 5: CV_BASE_MD_SRPACT_S4_DI
- **Status:** Found (logic present in STORE_ATTR_ACTUAL CTE)
- **Table:** `ZTSRP_ATTR_ACT` → mapped to `v_ztsrp_attr_act` ✅ Found
- **CTE:** Logic present as `STORE_ATTR_ACTUAL` CTE ✅ Found
- **Columns:** All columns used in consolidated output are present ✅ Found (note: many columns from the individual file such as KOKRS, KOSTL, ADDRESS, ZIPCODE, DIVISION_MGR, AREA_MGR, REGION_MGR, DISTRICT_MGR, ZONE_CODE, ZONE_DESC, STORE_TYPE, STORE_TYPE_DESC, RX_STORE_DESC, DISTRIBUTION_CNTR, DISTRIBUTION_CNTR_DESC, STORE_24_HR, BUDGET_*, CONST_*, RELOCATION_DAT, BUDGET_EMERG_MKT_IND, COMPANY_CODE, COMPANY_CODE_DESC, ORIGINAL_*, GROUP_ONE, GROUP_TWO, ARD_SORT_KEY, AREA_COST_CENTER, REGIION_COST_CENTER, COUNTY_CODE, COUNTY_DESC, SQFT_BRACKET_DESC, SQFT_SORT_KEY, ACQUISITION_CODE, ACQUISITION_DESC, PHOTO_LAB_*, MIN_HRS_IND, CREATEDBY, CREATED_ON are not in the consolidated output, but these are dimension columns not carried forward — the consolidated file is a narrower projection for its specific purpose, not a full pass-through. The columns that ARE used in the final output are all present.)
- **Filter:** `MANDT IN (120, 200)` → present in consolidated as `mandt IN ('120', '200')` ✅ Found

---

### File 6: CV_BASE_SKF_WEEKLY_ACTUAL_S4_DI
- **Status:** Found (logic present in WEEKLY_SNAPSHOT_DS05 CTE)
- **Table:** `AZSRP_DS112_VT_S4` → mapped to `v_bic_azsrp_ds112` ✅ Found
- **CTE:** Logic present as `WEEKLY_SNAPSHOT_DS05` CTE ✅ Found
- **Columns:** All 17 attributes and 8 measures present ✅ Found
- **Filters:** `MANDT IN (110, 200)` → present as `mandt IN ('110','200')` ✅ Found; `FISCVARNT = 'K4'` ✅ Found; `_BIC_ZIO_SWEEK = @IP_WEEK_LY` → present as `bic_zio_sweek = '202101'` ✅ Found; `_BIC_ZIO_VER = @IP_VERSION` → present as `bic_zio_ver = 'ACT01'` ✅ Found; `_BIC_ZIO_SAUDT IN ('1','10')` ✅ Found; `_BIC_ZIO_PSKF IN ('804013','801000')` ✅ Found

---

### File 7: CV_COMP_MD_COMPFL_STATIC_DI
- **Status:** Found (logic present in COMP_FLAG_ACT01 CTE — consolidated reads directly from v_ztsrp_compfl)
- **Table (intermediate):** `TBL_WSS_SRP_COMPFLAG` → **Missed** — consolidated bypasses this static table and reads directly from `v_ztsrp_compfl`
- **CTE:** Logic present in COMP_FLAG_ACT01 ✅ Found (logic equivalent)
- **Columns:** All 13 columns defined in individual file are present in consolidated ✅ Found
- **Filter:** No filter in individual file (pure projection) — consistent with consolidated ✅ Found

---

### File 8: CV_COMP_MD_SRPACT_STATIC_DI
- **Status:** Found (logic present in STORE_ATTR_ACTUAL CTE — consolidated reads directly from v_ztsrp_attr_act)
- **Table (intermediate):** `TBL_WSS_SRP_ATTR_ACT` → **Missed** — consolidated bypasses this static table and reads directly from `v_ztsrp_attr_act`
- **CTE:** Logic present as STORE_ATTR_ACTUAL ✅ Found
- **Columns:** All columns used in consolidated output are present ✅ Found
- **Filter:** No filter in individual file — consistent with consolidated ✅ Found

---

### File 9: CV_COMP_SKF_ACTUAL_STATIC_DI
- **Status:** Found (this is the top-level view; its full logic is the consolidated file itself)
- **All CTEs:** WEEKLY_SNAPSHOT_DS05, CC_HIER, Join_3, Projection_1, STORE_ATTR_ACTUAL, Join_2, RETAIL_CAL, Join_1, COMP_FLAG_ACT01, Join_4, PROFIT_CENTER_TEXT, Join_5, FLAGS — all present ✅ Found
- **All filters, columns, and calculated columns:** Present ✅ Found

---

### File 10: STP_WSS_SRP_ATTRIBUTES_DI
- **Status:** Found (procedure logic acknowledged in consolidated file comments, but DML excluded by design)
- **Table (procedure target):** `TBL_WSS_SRP_ATTR_ACT` and `TBL_WSS_SRP_COMPFLAG` → **Missed** — the consolidated file explicitly excludes the stored procedure's DML (DELETE + INSERT) logic
- **Filter missed:** `ZWEEK = V_WEEK` (prior fiscal week filter applied when loading TBL_WSS_SRP_COMPFLAG) — absent from consolidated file
- **Filter missed:** `MANDT IN (110, 200)` on ZTSRP_COMPFL (applied via CV_BASE_MD_COMPFL_S4 within the procedure) — absent from COMP_FLAG_ACT01 CTE in consolidated

---

*Overall Status: **Items Missed***
