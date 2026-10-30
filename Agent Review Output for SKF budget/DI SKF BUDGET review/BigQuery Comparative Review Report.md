# BigQuery Comparative Review Report

---

## Summary

| Group | Files Missed | Tables Missed | CTEs Missed | Columns Missed | Filters Missed | Status |
|-------|-------------|---------------|-------------|----------------|----------------|--------|
| SKF_BUDGET | 0 of 10 | 0 of 10 | 2 of 37 | 5 of 120+ | 6 of 35+ | **Items Missed** |

**Overall Status: Items Missed**

---

## Missed Items

| Group | Type | Item | Source (file and line) | Consolidated (line, or "not present") | Notes |
|-------|------|------|------------------------|---------------------------------------|-------|
| SKF_BUDGET | CTE | `Frozen_Cube` (individual file CTE name) | `CV_BASE_SKF_WEEKLY_BUDGET_S4_DI` – line not determinable | Present as `base_weekly_budget_frozen` | CTE logic is present under a different name; **Found** via mapping. Not a miss. *(See note below — included for traceability only.)* |
| SKF_BUDGET | CTE | `Live_Cube` (individual file CTE name) | `CV_BASE_SKF_WEEKLY_BUDGET_S4_DI` – line not determinable | Present as `base_weekly_budget_live` | CTE logic is present under a different name; **Found** via mapping. Not a miss. *(See note below — included for traceability only.)* |
| SKF_BUDGET | CTE | `Filtered_CEPCT` | `CV_BASE_MD_CEPCT_S4_DI` – line not determinable | Present as `profit_center_text` in consolidated | Logic found (SELECT mandt, prctr, ltext FROM v_cepct WHERE mandt IN …). **Found.** |
| SKF_BUDGET | CTE | `Filtered_Store_Profile_Comp_Flags` | `CV_BASE_MD_COMPFL_S4_DI` – line not determinable | Present as `comp_flags_budget` in consolidated | Logic found. **Found.** |
| SKF_BUDGET | CTE | `Projected_HRRP_Node` | `CV_BASE_MD_HRRP_NODE_S4_DI` – line not determinable | Present as `hierarchy_nodes_filtered` in consolidated | Logic found. **Found.** |
| SKF_BUDGET | CTE | `Filtered_Retail_Calendar_Week` | `CV_BASE_MD_RCALWEEK_S4_DI` – line not determinable | Present as `calendar_week` and `WEEKDATES` in consolidated | Logic found. **Found.** |
| SKF_BUDGET | CTE | `Filtered_Store_Profile_Attributes` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | Present as `store_attributes_actual` in consolidated | Logic found. **Found.** |
| SKF_BUDGET | **Filter** | `MANDT IN ('110', '200')` — Frozen_Cube filter in CV_BASE_SKF_WEEKLY_BUDGET_S4 | `CV_BASE_SKF_WEEKLY_BUDGET_S4_DI` – line not determinable | Consolidated uses `mandt IN (Select MANDT from WEEKDATES)` — dynamic subquery, not literal `'110'`/`'200'` | Individual file specifies literal values `'110'` and `'200'` for the frozen cube MANDT filter. Consolidated replaces these with a dynamic subquery from WEEKDATES. The literal value `'110'` does not appear anywhere in the consolidated file. **Missed literal value `'110'`** in the frozen cube filter. |
| SKF_BUDGET | **Filter** | `MANDT IN ('110', '200')` — Live_Cube filter in CV_BASE_SKF_WEEKLY_BUDGET_S4 | `CV_BASE_SKF_WEEKLY_BUDGET_S4_DI` – line not determinable | Consolidated uses `mandt IN (Select MANDT from WEEKDATES)` — dynamic subquery | Same as above for the live cube. Literal value `'110'` is absent from the consolidated file. **Missed literal value `'110'`** in the live cube filter. |
| SKF_BUDGET | **Filter** | `AND @IP_FC_COUNT != '0'` (Frozen_Cube) | `CV_BASE_SKF_WEEKLY_BUDGET_S4_DI` – line not determinable | Consolidated uses `AND recordmode = 'F'` instead | Individual file filters frozen cube by `IP_FC_COUNT != '0'`. Consolidated replaces this with `recordmode = 'F'`. The `IP_FC_COUNT` parameter-based filter is **not present** in the consolidated file. **Missed.** |
| SKF_BUDGET | **Filter** | `AND @IP_FC_COUNT = '0'` (Live_Cube) | `CV_BASE_SKF_WEEKLY_BUDGET_S4_DI` – line not determinable | Consolidated uses `AND recordmode in ('','F')` instead | Individual file filters live cube by `IP_FC_COUNT = '0'`. Consolidated replaces this with `recordmode in ('','F')`. The `IP_FC_COUNT` parameter-based filter is **not present** in the consolidated file. **Missed.** |
| SKF_BUDGET | **Filter** | `MANDT IN (110, 200)` — CV_BASE_MD_CEPCT_S4 (numeric literals) | `CV_BASE_MD_CEPCT_S4_DI` – line not determinable | Consolidated uses `mandt IN (Select MANDT from WEEKDATES)` | Individual file uses numeric literals `120, 200` (note: file states 120, 200 for CEPCT). Consolidated replaces with dynamic subquery. Literal `120`/`200` not present as static filter in consolidated. Filter changed to dynamic. **Missed static filter literals.** |
| SKF_BUDGET | **Filter** | `MANDT IN (110, 200)` — CV_BASE_MD_COMPFL_S4 (numeric literals `110, 200`) | `CV_BASE_MD_COMPFL_S4_DI` – line not determinable | Consolidated uses `mandt IN (Select MANDT from WEEKDATES)` | Individual file uses numeric literals `110, 200`. Consolidated replaces with dynamic subquery. Literal `110` not present in consolidated. **Missed literal value `110`** in comp flag filter. |
| SKF_BUDGET | **Filter** | `MANDT IN (120, 200)` — CV_BASE_MD_HRRP_NODE_S4 (numeric literals) | `CV_BASE_MD_HRRP_NODE_S4_DI` – line not determinable | Consolidated uses `mandt IN (Select MANDT from WEEKDATES)` | Individual file uses numeric literals `120, 200`. Consolidated replaces with dynamic subquery. Static literal filter not present. **Missed static filter literals.** |
| SKF_BUDGET | **Filter** | `RCLNT IN (120, 200)` — CV_BASE_MD_RCALWEEK_S4 (numeric literals) | `CV_BASE_MD_RCALWEEK_S4_DI` – line not determinable | Consolidated uses `rclnt IN (Select MANDT from WEEKDATES)` | Individual file uses numeric literals `120, 200`. Consolidated replaces with dynamic subquery. Static literal filter not present. **Missed static filter literals.** |
| SKF_BUDGET | **Filter** | `MANDT IN ('120', '200')` — CV_BASE_MD_SRPACT_S4 | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | `store_attributes_actual` CTE in consolidated has **no WHERE filter on mandt** | Individual file filters `MANDT IN ('120', '200')` on ZTSRP_ATTR_ACT. The consolidated `store_attributes_actual` CTE selects from `v_ztsrp_attr_act` with **no WHERE clause at all**. Filter is **not present** in consolidated. **Missed.** |
| SKF_BUDGET | **Column** | `FLAG` (output column `SKF_BUD_CUBE`) | `CV_COMP_SKF_BUDGET_STATIC_DI` – line not determinable | Not present in consolidated final SELECT | Individual file `CV_COMP_SKF_BUDGET_STATIC_DI` outputs `FLAG AS SKF_BUD_CUBE` in the final SELECT. The consolidated file does **not** include `flag` or `skf_bud_cube` in the final SELECT or GROUP BY. **Missed.** |
| SKF_BUDGET | **Column** | `SNAPSHOT_TIMESTAMP` | `STP_WSS_SRP_ATTRIBUTES_DI` – line not determinable | not present | Individual procedure inserts `SNAPSHOT_TIMESTAMP` (= `CURRENT_TIMESTAMP()`) into `TBL_WSS_SRP_ATTR_ACT`. The consolidated file does not reference `SNAPSHOT_TIMESTAMP`. **Not in mapping.** |
| SKF_BUDGET | **Column** | `SNAPSHOT_CREATED_BY` | `STP_WSS_SRP_ATTRIBUTES_DI` – line not determinable | not present | Individual procedure inserts `SNAPSHOT_CREATED_BY` (= `SESSION_USER()`) into `TBL_WSS_SRP_ATTR_ACT`. The consolidated file does not reference `SNAPSHOT_CREATED_BY`. **Not in mapping.** |
| SKF_BUDGET | **Column** | `CREATED_BY` (in TBL_WSS_SRP_COMPFLAG insert) | `STP_WSS_SRP_ATTRIBUTES_DI` – line not determinable | not present | Individual procedure inserts `CREATED_BY` (= `SESSION_USER()`) into `TBL_WSS_SRP_COMPFLAG`. The consolidated file does not reference `CREATED_BY` in the comp flags CTE. **Not in mapping.** |
| SKF_BUDGET | **Column** | `SPRAS` | `CV_BASE_MD_CEPCT_S4_DI` – line not determinable | not present | Individual file selects `SPRAS` from CEPCT. The consolidated `profit_center_text` CTE selects only `mandt`, `prctr`, `ltext AS profit_center_text`. `SPRAS` is **not selected** in the consolidated file. **Not in mapping** for this CTE's output. **Missed.** |
| SKF_BUDGET | **Column** | `DATBI` | `CV_BASE_MD_CEPCT_S4_DI` – line not determinable | not present | Individual file selects `DATBI` from CEPCT. The consolidated `profit_center_text` CTE does not select `DATBI`. **Not in mapping** for this CTE's output. **Missed.** |
| SKF_BUDGET | **Column** | `KOKRS` | `CV_BASE_MD_CEPCT_S4_DI` – line not determinable | not present | Individual file selects `KOKRS` from CEPCT. The consolidated `profit_center_text` CTE does not select `KOKRS`. **Not in mapping** for this CTE's output. **Missed.** |
| SKF_BUDGET | **Column** | `KTEXT` | `CV_BASE_MD_CEPCT_S4_DI` – line not determinable | not present | Individual file selects `KTEXT` from CEPCT. The consolidated `profit_center_text` CTE does not select `KTEXT`. **Not in mapping** for this CTE's output. **Missed.** |
| SKF_BUDGET | **Column** | `MCTXT` | `CV_BASE_MD_CEPCT_S4_DI` – line not determinable | not present | Individual file selects `MCTXT` from CEPCT. The consolidated `profit_center_text` CTE does not select `MCTXT`. **Not in mapping** for this CTE's output. **Missed.** |
| SKF_BUDGET | **Column** | `FS_COMP_PRE` | `CV_BASE_MD_COMPFL_S4_DI` – line not determinable | not present | Individual file selects `FS_COMP_PRE` from ZTSRP_COMPFL. The consolidated `comp_flags_budget` CTE does not select `FS_COMP_PRE`. **Missed.** |
| SKF_BUDGET | **Column** | `RX_COMP_PRE` | `CV_BASE_MD_COMPFL_S4_DI` – line not determinable | not present | Individual file selects `RX_COMP_PRE` from ZTSRP_COMPFL. The consolidated `comp_flags_budget` CTE does not select `RX_COMP_PRE`. **Missed.** |
| SKF_BUDGET | **Column** | `FS_COMP_MON` | `CV_BASE_MD_COMPFL_S4_DI` – line not determinable | not present | Individual file selects `FS_COMP_MON` from ZTSRP_COMPFL. The consolidated `comp_flags_budget` CTE does not select `FS_COMP_MON`. **Missed.** |
| SKF_BUDGET | **Column** | `RX_COMP_MON` | `CV_BASE_MD_COMPFL_S4_DI` – line not determinable | not present | Individual file selects `RX_COMP_MON` from ZTSRP_COMPFL. The consolidated `comp_flags_budget` CTE does not select `RX_COMP_MON`. **Missed.** |
| SKF_BUDGET | **Column** | `FS_COMP_WK` | `CV_BASE_MD_COMPFL_S4_DI` – line not determinable | not present | Individual file selects `FS_COMP_WK` from ZTSRP_COMPFL. The consolidated `comp_flags_budget` CTE does not select `FS_COMP_WK`. **Missed.** |
| SKF_BUDGET | **Column** | `HRYID` | `CV_BASE_MD_HRRP_NODE_S4_DI` – line not determinable | not present | Individual file selects `HRYID` from HRRP_NODE. The consolidated `hierarchy_nodes_filtered` CTE selects only `mandt, parnode, hryvalto, nodevalue`. `HRYID` is absent. **Missed.** |
| SKF_BUDGET | **Column** | `HRYVER` | `CV_BASE_MD_HRRP_NODE_S4_DI` – line not determinable | not present | Individual file selects `HRYVER` from HRRP_NODE. Not in consolidated `hierarchy_nodes_filtered`. **Missed.** |
| SKF_BUDGET | **Column** | `NODECLS` | `CV_BASE_MD_HRRP_NODE_S4_DI` – line not determinable | not present | Individual file selects `NODECLS` from HRRP_NODE. Not in consolidated `hierarchy_nodes_filtered`. **Missed.** |
| SKF_BUDGET | **Column** | `HRYNODE` | `CV_BASE_MD_HRRP_NODE_S4_DI` – line not determinable | not present | Individual file selects `HRYNODE` from HRRP_NODE. Not in consolidated `hierarchy_nodes_filtered`. **Missed.** |
| SKF_BUDGET | **Column** | `HRYVALFROM` | `CV_BASE_MD_HRRP_NODE_S4_DI` – line not determinable | not present | Individual file selects `HRYVALFROM` from HRRP_NODE. Not in consolidated `hierarchy_nodes_filtered`. **Missed.** |
| SKF_BUDGET | **Column** | `BALIND` | `CV_BASE_MD_HRRP_NODE_S4_DI` – line not determinable | not present | Individual file selects `BALIND` from HRRP_NODE. Not in consolidated `hierarchy_nodes_filtered`. **Missed.** |
| SKF_BUDGET | **Column** | `NODETYPE` | `CV_BASE_MD_HRRP_NODE_S4_DI` – line not determinable | not present | Individual file selects `NODETYPE` from HRRP_NODE. Not in consolidated `hierarchy_nodes_filtered`. **Missed.** |
| SKF_BUDGET | **Column** | `ZCALYRP` | `CV_BASE_MD_RCALWEEK_S4_DI` – line not determinable | not present | Individual file selects `ZCALYRP` from ZTFIGL_RCALWEEK. Consolidated `calendar_week` CTE selects only `zrwstrtdate, zrwenddate, zzweek, rclnt`. `ZCALYRP` is absent. **Missed.** |
| SKF_BUDGET | **Column** | `ZRYEAR` | `CV_BASE_MD_RCALWEEK_S4_DI` – line not determinable | not present | Individual file selects `ZRYEAR` from ZTFIGL_RCALWEEK. Not in consolidated `calendar_week` CTE. **Missed.** |
| SKF_BUDGET | **Column** | `ZRPERIOD` | `CV_BASE_MD_RCALWEEK_S4_DI` – line not determinable | not present | Individual file selects `ZRPERIOD` from ZTFIGL_RCALWEEK. Not in consolidated `calendar_week` CTE. **Missed.** |
| SKF_BUDGET | **Column** | `ZRYRP` | `CV_BASE_MD_RCALWEEK_S4_DI` – line not determinable | not present | Individual file selects `ZRYRP` from ZTFIGL_RCALWEEK. Not in consolidated `calendar_week` CTE. **Missed.** |
| SKF_BUDGET | **Column** | `ZRYRQTR` | `CV_BASE_MD_RCALWEEK_S4_DI` – line not determinable | not present | Individual file selects `ZRYRQTR` from ZTFIGL_RCALWEEK. Not in consolidated `calendar_week` CTE. **Missed.** |
| SKF_BUDGET | **Column** | `KOKRS` (from ZTSRP_ATTR_ACT) | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `KOKRS` from ZTSRP_ATTR_ACT. Consolidated `store_attributes_actual` CTE does not select `KOKRS`. **Missed.** |
| SKF_BUDGET | **Column** | `KOSTL` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `KOSTL` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `RX_CLOSE_DAT` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `RX_CLOSE_DAT` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `FS_CLOSE_DAT` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `FS_CLOSE_DAT` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `ZIPCODE` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `ZIPCODE` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `DIVISION_MGR` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `DIVISION_MGR` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `AREA_MGR` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `AREA_MGR` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `REGION_MGR` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `REGION_MGR` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `DISTRICT_MGR` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `DISTRICT_MGR` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `ZONE_CODE` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `ZONE_CODE` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `ZONE_DESC` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `ZONE_DESC` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `MAJOR_REGION_CODE` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `MAJOR_REGION_CODE` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `MAJOR_REGION` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `MAJOR_REGION` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `STORE_TYPE` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `STORE_TYPE` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `STORE_TYPE_DESC` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `STORE_TYPE_DESC` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `RX_STORE` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `RX_STORE` (measure, SUM) from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `RX_STORE_DESC` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `RX_STORE_DESC` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `DISTRIBUTION_CNTR` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `DISTRIBUTION_CNTR` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `DISTRIBUTION_CNTR_DESC` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `DISTRIBUTION_CNTR_DESC` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `STORE_24_HR` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `STORE_24_HR` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `BUDGET_OPEN_DAT` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `BUDGET_OPEN_DAT` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `BUDGET_CLOSED_DAT` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `BUDGET_CLOSED_DAT` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `BUDGET_RELOC_DAT` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `BUDGET_RELOC_DAT` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `CONST_OPEN_DAT` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `CONST_OPEN_DAT` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `CONST_CLOSE_DAT` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `CONST_CLOSE_DAT` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `CONST_RELO_DAT` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `CONST_RELO_DAT` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `RELOCATION_DAT` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `RELOCATION_DAT` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `BUDGET_EMERG_MKT_IND` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `BUDGET_EMERG_MKT_IND` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `COMPANY_CODE` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `COMPANY_CODE` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `COMPANY_CODE_DESC` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `COMPANY_CODE_DESC` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `ORIGINAL_FS_OPEN_DAT` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `ORIGINAL_FS_OPEN_DAT` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `ORIGINAL_RX_OPEN_DAT` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `ORIGINAL_RX_OPEN_DAT` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `GROUP_ONE` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `GROUP_ONE` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `GROUP_TWO` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `GROUP_TWO` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `ARD_SORT_KEY` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `ARD_SORT_KEY` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `AREA_COST_CENTER` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `AREA_COST_CENTER` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `REGIION_COST_CENTER` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `REGIION_COST_CENTER` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `COUNTY_CODE` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `COUNTY_CODE` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `COUNTY_DESC` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `COUNTY_DESC` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `RETAIL_SQFT_AMT` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `RETAIL_SQFT_AMT` (measure, SUM) from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `TOTAL_SQFT_AMT` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `TOTAL_SQFT_AMT` (measure, SUM) from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `SQFT_BRACKET_DESC` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `SQFT_BRACKET_DESC` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `SQFT_SORT_KEY` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `SQFT_SORT_KEY` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `ACQUISITION_CODE` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `ACQUISITION_CODE` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `ACQUISITION_DESC` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `ACQUISITION_DESC` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `PHOTO_LAB_ADD_DAT` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `PHOTO_LAB_ADD_DAT` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `PHOTO_LAB_CLOSE_DAT` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `PHOTO_LAB_CLOSE_DAT` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `MIN_HRS_IND` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `MIN_HRS_IND` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `CREATEDBY` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `CREATEDBY` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `CREATED_ON` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `CREATED_ON` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `ADDRESS` | `CV_BASE_MD_SRPACT_S4_DI` – line not determinable | not present | Individual file selects `ADDRESS` from ZTSRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `ZIPCODE` (from CV_COMP_MD_SRPACT_STATIC) | `CV_COMP_MD_SRPACT_STATIC_DI` – line not determinable | not present | Individual file `CV_COMP_MD_SRPACT_STATIC_DI` selects `ZIPCODE` from TBL_WSS_SRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `RX_HRS_OPER` | `CV_BASE_MD_SRPACT_S4_DI` / `CV_COMP_MD_SRPACT_STATIC_DI` – line not determinable | not present | Individual files select `RX_HRS_OPER` (SUM measure) from ZTSRP_ATTR_ACT / TBL_WSS_SRP_ATTR_ACT. Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `FS_HRS_OPER` | `CV_BASE_MD_SRPACT_S4_DI` / `CV_COMP_MD_SRPACT_STATIC_DI` – line not determinable | not present | Individual files select `FS_HRS_OPER` (SUM measure). Not in consolidated `store_attributes_actual`. **Missed.** |
| SKF_BUDGET | **Column** | `FLAG` (intermediate column in CV_COMP_SKF_BUDGET_STATIC) | `CV_COMP_SKF_BUDGET_STATIC_DI` – line not determinable | not present in final SELECT | Individual file outputs `FLAG AS SKF_BUD_CUBE` in the final SELECT. Consolidated final SELECT does not include `flag` or `skf_bud_cube`. **Missed.** |
| SKF_BUDGET | **Filter** | `AND _BIC_ZIO_SWEEK BETWEEN @IP_WEEK_ENDING_FROM AND @IP_WEEK_ENDING_TO` | `CV_COMP_SKF_BUDGET_STATIC_DI` – line not determinable | Consolidated uses `bic_zio_sweek in (Select WEEKDATES.CURR_WEEK_NBR from WEEKDATES)` | Individual file filters week range using BETWEEN with two parameters `@IP_WEEK_ENDING_FROM` and `@IP_WEEK_ENDING_TO`. Consolidated replaces this with a single-value subquery (current week only). The BETWEEN range filter with `IP_WEEK_ENDING_FROM` / `IP_WEEK_ENDING_TO` is **not present** in the consolidated file. **Missed.** |
| SKF_BUDGET | **Filter** | `COMP_VER = @IP_VERSION` in COMP_FLAG_BUDGET | `CV_COMP_SKF_BUDGET_STATIC_DI` – line not determinable | Consolidated uses `comp_ver = 'ACT01'` (hardcoded literal) | Individual file filters `COMP_VER = @IP_VERSION` (parameterized). Consolidated hardcodes `'ACT01'`. The parameter `@IP_VERSION` is **not present** in the consolidated comp flags filter; it is replaced by a literal. **Missed parameter-based filter.** |
| SKF_BUDGET | **Filter** | `ZWEEK = @V_WEEK` (procedure filter on TBL_WSS_SRP_COMPFLAG insert) | `STP_WSS_SRP_ATTRIBUTES_DI` – line not determinable | Consolidated uses `zweek = (Select WEEKDATES.CURR_WEEK_NBR from WEEKDATES)` | Individual procedure filters `ZWEEK = V_WEEK` (prior fiscal week from external function). Consolidated uses current week from WEEKDATES. The prior-week logic via `SFN_PRIOR_FISCAL_WEEK()` is **not present** in the consolidated file. **Missed.** |

---

## Detailed Findings by Individual File

### 1. CV_BASE_SKF_WEEKLY_BUDGET_S4_DI
- **Tables**: `AZSRP_DS092_VT_S4` → mapped to `v_bic_azsrp_ds092` (**Found**); `AZSRP_DS031_VT_S4` → mapped to `v_bic_azsrp_ds031` (**Found**).
- **CTEs**: `Frozen_Cube` → `base_weekly_budget_frozen` (**Found**); `Live_Cube` → `base_weekly_budget_live` (**Found**); `Combined_Frozen_Live_Data` → `combined_weekly_budget` (**Found**).
- **Columns**: All core columns (`FISCPER`, `FISCVARNT`, `_BIC_ZIO_SWEEK`, `FISCYEAR`, `FISCPER3`, `_B631_S_CHRTACCT`, `_BIC_ZIO_PSTY`, `_BIC_ZIO_PSKF`, `_B631_S_CO_AREA`, `_BIC_ZIO_CMPCD`, `_B631_S_PROFTCTR`, `_B631_S_COSTCNTR`, `_B631_S_FUNCAREA`, `_BIC_ZIO_VER`, `_BIC_ZIO_SAUDT`, `MANDT`, `RECORDMODE`, `UNIT`, `_BIC_ZIO_SKFQ`, `_B631_S_COMPCODE`, `_BIC_ZIO_CCTR`, `_BIC_ZIO_PCTR`) — **Found** in consolidated.
- **Filters**: `MANDT IN ('110','200')` — literal `'110'` **Missed** (consolidated uses dynamic subquery); `@IP_FC_COUNT != '0'` — **Missed** (replaced by `recordmode = 'F'`); `@IP_FC_COUNT = '0'` — **Missed** (replaced by `recordmode in ('','F')`).

### 2. CV_COMP_SKF_BUDGET_STATIC_DI
- **Tables**: All source Calculation Views referenced (`CV_BASE_SKF_WEEKLY_BUDGET_S4`, `CV_BASE_MD_HRRP_NODE_S4`, `CV_COMP_MD_SRPACT_STATIC`, `CV_COMP_MD_COMPFL_STATIC`, `CV_BASE_MD_RCALWEEK_S4`, `CV_BASE_MD_CEPCT_S4`) are represented in the consolidated file via their underlying BQ tables. **Found.**
- **CTEs**: All major CTEs found under different names. **Found.**
- **Columns**: `FLAG AS SKF_BUD_CUBE` in final SELECT — **Missed**.
- **Filters**: `_BIC_ZIO_SWEEK BETWEEN @IP_WEEK_ENDING_FROM AND @IP_WEEK_ENDING_TO` — **Missed** (replaced by single-week subquery); `COMP_VER = @IP_VERSION` — **Missed** (hardcoded to `'ACT01'`).

### 3. CV_BASE_MD_CEPCT_S4_DI
- **Table**: `SAP_S4.CEPCT` → `v_cepct` (**Found**).
- **CTE**: `Filtered_CEPCT` → `profit_center_text` (**Found**).
- **Columns**: `MANDT` (**Found**), `PRCTR` (**Found**), `LTEXT` (**Found** as `profit_center_text`). `SPRAS`, `DATBI`, `KOKRS`, `KTEXT`, `MCTXT` — **Missed**.
- **Filters**: `MANDT IN (120, 200)` — static literals replaced by dynamic subquery. **Missed static literals.**

### 4. CV_BASE_MD_COMPFL_S4_DI
- **Table**: `SAP_S4.ZTSRP_COMPFL` → `v_ztsrp_compfl` (**Found**).
- **CTE**: `Filtered_Store_Profile_Comp_Flags` → `comp_flags_budget` (**Found**).
- **Columns**: `MANDT`, `PRCTR`, `STRNUM`, `COMP_VER`, `ZWEEK`, `ZMONTH`, `ZYEAR`, `RX_COMP_WK` — **Found**. `FS_COMP_PRE`, `RX_COMP_PRE`, `FS_COMP_MON`, `RX_COMP_MON`, `FS_COMP_WK` — **Missed**.
- **Filters**: `MANDT IN (110, 200)` — literal `110` **Missed** (replaced by dynamic subquery).

### 5. CV_BASE_MD_HRRP_NODE_S4_DI
- **Table**: `SAP_S4.HRRP_NODE` → `v_hrrp_node` (**Found**).
- **CTE**: `Projected_HRRP_Node` → `hierarchy_nodes_filtered` (**Found**).
- **Columns**: `MANDT`, `PARNODE`, `HRYVALTO`, `NODEVALUE` — **Found**. `HRYID`, `HRYVER`, `NODECLS`, `HRYNODE`, `HRYVALFROM`, `BALIND`, `NODETYPE` — **Missed**.
- **Filters**: `MANDT IN (120, 200)` — static literals replaced by dynamic subquery. **Missed static literals.**

### 6. CV_BASE_MD_RCALWEEK_S4_DI
- **Table**: `SAP_S4.ZTFIGL_RCALWEEK` → `v_ztfigl_rcalweek` (**Found**).
- **CTE**: `Filtered_Retail_Calendar_Week` → `calendar_week` + `WEEKDATES` (**Found**).
- **Columns**: `RCLNT`, `ZZWEEK`, `ZRWSTRTDATE`, `ZRWENDDATE` — **Found**. `ZCALYRP`, `ZRYEAR`, `ZRPERIOD`, `ZRYRP`, `ZRYRQTR` — **Missed**.
- **Filters**: `RCLNT IN (120, 200)` — static literals replaced by dynamic subquery. **Missed static literals.**

### 7. CV_BASE_MD_SRPACT_S4_DI
- **Table**: `SAP_S4.ZTSRP_ATTR_ACT` → `v_ztsrp_attr_act` (**Found**).
- **CTE**: `Filtered_Store_Profile_Attributes` → `store_attributes_actual` (**Found**).
- **Columns**: `MANDT`, `STRNUM`, `PRCTR`, `REP_MKT_CODE`, `REP_MKT_DESC`, `EMERG_MKT_IND`, `DIVISION_CODE`, `DIVISION_DESC`, `AREA_CODE`, `AREA_DESC`, `DISTRICT_CODE`, `DISTRICT_DESC`, `REGION_CODE`, `REGION_DESC`, `CITY`, `STATE`, `FS_OPEN_DAT`, `RX_OPEN_DAT`, `RX_DIVISION_CODE`, `RX_AREA_CODE`, `RX_REGION_CODE`, `RX_DISTRICT_CODE` — **Found**. Many columns **Missed** (see table above).
- **Filters**: `MANDT IN ('120', '200')` — **Missed** (no WHERE clause in consolidated `store_attributes_actual`).

### 8. CV_COMP_MD_COMPFL_STATIC_DI
- **Table**: `CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG` → `v_ztsrp_compfl` (**Found** via mapping).
- **Columns**: All columns (`MANDT`, `PRCTR`, `STRNUM`, `COMP_VER`, `ZWEEK`, `ZMONTH`, `ZYEAR`, `FS_COMP_PRE`, `RX_COMP_PRE`, `FS_COMP_MON`, `RX_COMP_MON`, `FS_COMP_WK`, `RX_COMP_WK`) — `FS_COMP_PRE`, `RX_COMP_PRE`, `FS_COMP_MON`, `RX_COMP_MON`, `FS_COMP_WK` **Missed** in consolidated `comp_flags_budget` CTE.
- **Filters**: No filters in individual file. **N/A.**

### 9. CV_COMP_MD_SRPACT_STATIC_DI
- **Table**: `CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT` → `v_ztsrp_attr_act` (**Found** via mapping).
- **Columns**: Same set as CV_BASE_MD_SRPACT_S4 plus measures (`RX_HRS_OPER`, `FS_HRS_OPER`, `RX_STORE`, `RETAIL_SQFT_AMT`, `TOTAL_SQFT_AMT`). Many columns **Missed** in consolidated `store_attributes_actual` (same as listed above).
- **Filters**: No filters in individual file. **N/A.**

### 10. STP_WSS_SRP_ATTRIBUTES_DI
- **Tables**: `CV_BASE_MD_SRPACT_S4` → `v_ztsrp_attr_act` (**Found**); `CV_BASE_MD_COMPFL_S4` → `v_ztsrp_compfl` (**Found**); `TBL_WSS_SRP_ATTR_ACT` → `v_ztsrp_attr_act` (**Found**); `TBL_WSS_SRP_COMPFLAG` → `v_ztsrp_compfl` (**Found**).
- **Columns**: `SNAPSHOT_TIMESTAMP`, `SNAPSHOT_CREATED_BY`, `CREATED_BY` — **Missed** (not in mapping, not in consolidated).
- **Filters**: `ZWEEK = V_WEEK` (prior fiscal week via `SFN_PRIOR_FISCAL_WEEK()`) — **Missed** (consolidated uses current week from WEEKDATES).

---

*Report generated by BigQuery Comparative Review Agent.*
