# BigQuery Comparative Review Report

---

## Summary

| Group | Files Missed | Tables Missed | CTEs Missed | Columns Missed | Filters Missed | Status |
|---|---|---|---|---|---|---|
| RX BUDGET | 0 of 10 | 0 of 8 | 0 of 19 | 57 of 174 | 1 of 22 | **Items Missed** |

---

## Missed Items

| Group | Type | Item | Source (file and line) | Consolidated (line, or "not present") | Notes |
|---|---|---|---|---|---|
| RX BUDGET | Filter | `mandt IN ('110', '200')` on Frozen_Cube (AZSRP_DS052_VT_S4) | CV_BASE_FIN_WEEKLY_BUDGET_S4.txt – SOURCE_LOGIC / Frozen_Cube node | Consolidated line ~68: `mandt IN ('120', '200')` | Source specifies client `'110'`; consolidated uses `'120'`. The value `'110'` is absent from the consolidated filter, changing which rows are returned. |
| RX BUDGET | Column | `SPRAS` | CV_BASE_MD_CEPCT_S4.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Selected in source projection of CEPCT; consolidated `PROFIT_CENTER_TEXT` CTE (line ~318) selects only `mandt`, `prctr`, `ltext`. |
| RX BUDGET | Column | `DATBI` | CV_BASE_MD_CEPCT_S4.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Selected in source projection of CEPCT; not selected in consolidated `PROFIT_CENTER_TEXT` CTE. |
| RX BUDGET | Column | `KOKRS` (from CEPCT) | CV_BASE_MD_CEPCT_S4.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Selected in source projection of CEPCT; not selected in consolidated `PROFIT_CENTER_TEXT` CTE. |
| RX BUDGET | Column | `KTEXT` | CV_BASE_MD_CEPCT_S4.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Selected in source projection of CEPCT; not selected in consolidated `PROFIT_CENTER_TEXT` CTE. |
| RX BUDGET | Column | `MCTXT` | CV_BASE_MD_CEPCT_S4.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Selected in source projection of CEPCT; not selected in consolidated `PROFIT_CENTER_TEXT` CTE. |
| RX BUDGET | Column | `HRYID` | CV_BASE_MD_HRRP_NODE_S4.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Selected in source projection of HRRP_NODE; consolidated `HIER_NODE` CTE (line ~195) selects only `mandt`, `parnode`, `hryvalto`, `nodevalue`. |
| RX BUDGET | Column | `HRYVER` | CV_BASE_MD_HRRP_NODE_S4.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Selected in source projection of HRRP_NODE; not selected in consolidated `HIER_NODE` CTE. |
| RX BUDGET | Column | `NODECLS` | CV_BASE_MD_HRRP_NODE_S4.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Selected in source projection of HRRP_NODE; not selected in consolidated `HIER_NODE` CTE. |
| RX BUDGET | Column | `HRYNODE` | CV_BASE_MD_HRRP_NODE_S4.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Selected in source projection of HRRP_NODE; not selected in consolidated `HIER_NODE` CTE. |
| RX BUDGET | Column | `HRYVALFROM` | CV_BASE_MD_HRRP_NODE_S4.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Selected in source projection of HRRP_NODE; not selected in consolidated `HIER_NODE` CTE. |
| RX BUDGET | Column | `BALIND` | CV_BASE_MD_HRRP_NODE_S4.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Selected in source projection of HRRP_NODE; not selected in consolidated `HIER_NODE` CTE. |
| RX BUDGET | Column | `NODETYPE` | CV_BASE_MD_HRRP_NODE_S4.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Selected in source projection of HRRP_NODE; not selected in consolidated `HIER_NODE` CTE. |
| RX BUDGET | Column | `ZCALYRP` | CV_BASE_MD_RCALWEEK_S4.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Selected in source projection of ZTFIGL_RCALWEEK; consolidated `CAL_WEEK` CTE (line ~280) selects only `zzweek`, `zrwstrtdate`, `zrwenddate`, `rclnt`. |
| RX BUDGET | Column | `ZRYEAR` | CV_BASE_MD_RCALWEEK_S4.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Selected in source projection of ZTFIGL_RCALWEEK; not selected in consolidated `CAL_WEEK` CTE. |
| RX BUDGET | Column | `ZRPERIOD` | CV_BASE_MD_RCALWEEK_S4.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Selected in source projection of ZTFIGL_RCALWEEK; not selected in consolidated `CAL_WEEK` CTE. |
| RX BUDGET | Column | `ZRYRP` | CV_BASE_MD_RCALWEEK_S4.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Selected in source projection of ZTFIGL_RCALWEEK; not selected in consolidated `CAL_WEEK` CTE. |
| RX BUDGET | Column | `ZRYRQTR` | CV_BASE_MD_RCALWEEK_S4.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Selected in source projection of ZTFIGL_RCALWEEK; not selected in consolidated `CAL_WEEK` CTE. |
| RX BUDGET | Column | `ADDRESS` (from ZTSRP_ATTR_ACT) | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source CUBE projection of ZTSRP_ATTR_ACT; not selected in consolidated `Base_ZTSRP_ATTR_ACT` CTE (line ~225) or `STORE_ATTR_ACTUAL` CTE. |
| RX BUDGET | Column | `ZIPCODE` (from ZTSRP_ATTR_ACT) | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `DIVISION_MGR` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `AREA_MGR` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `REGION_MGR` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `DISTRICT_MGR` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `ZONE_CODE` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `ZONE_DESC` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `MAJOR_REGION_CODE` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `MAJOR_REGION` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `STORE_TYPE` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `STORE_TYPE_DESC` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `RX_STORE_DESC` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `DISTRIBUTION_CNTR` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `DISTRIBUTION_CNTR_DESC` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `STORE_24_HR` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `BUDGET_OPEN_DAT` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `BUDGET_CLOSED_DAT` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `BUDGET_RELOC_DAT` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `CONST_OPEN_DAT` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `CONST_CLOSE_DAT` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `CONST_RELO_DAT` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `RELOCATION_DAT` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `BUDGET_EMERG_MKT_IND` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `COMPANY_CODE` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `COMPANY_CODE_DESC` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `ORIGINAL_FS_OPEN_DAT` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `ORIGINAL_RX_OPEN_DAT` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `GROUP_ONE` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `GROUP_TWO` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `ARD_SORT_KEY` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `AREA_COST_CENTER` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `REGIION_COST_CENTER` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `COUNTY_CODE` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `COUNTY_DESC` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `SQFT_BRACKET_DESC` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `SQFT_SORT_KEY` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `ACQUISITION_CODE` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `ACQUISITION_DESC` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `PHOTO_LAB_ADD_DAT` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `PHOTO_LAB_CLOSE_DAT` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `MIN_HRS_IND` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `CREATEDBY` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `CREATED_ON` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `KOKRS` (from ZTSRP_ATTR_ACT) | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `KOSTL` | CV_BASE_MD_SRPACT_S4.txt – CONVERTED_BIGQUERY_SQL SELECT list | not present | Selected in source; not present in consolidated `Base_ZTSRP_ATTR_ACT` or `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `FS_COMP_PRE` | CV_COMP_MD_COMPFL_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source CV_COMP_MD_COMPFL_STATIC; consolidated `COMP_FLAG_BUDGET` CTE (line ~370) selects only `fs_comp_wk`, `rx_comp_wk` (plus key columns). |
| RX BUDGET | Column | `RX_COMP_PRE` | CV_COMP_MD_COMPFL_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source CV_COMP_MD_COMPFL_STATIC; not selected in consolidated `COMP_FLAG_BUDGET` CTE. |
| RX BUDGET | Column | `FS_COMP_MON` | CV_COMP_MD_COMPFL_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source CV_COMP_MD_COMPFL_STATIC; not selected in consolidated `COMP_FLAG_BUDGET` CTE. |
| RX BUDGET | Column | `RX_COMP_MON` | CV_COMP_MD_COMPFL_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source CV_COMP_MD_COMPFL_STATIC; not selected in consolidated `COMP_FLAG_BUDGET` CTE. |
| RX BUDGET | Column | `ADDRESS` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source CV_COMP_MD_SRPACT_STATIC; not selected in consolidated `STORE_ATTR_ACTUAL` CTE (line ~255). |
| RX BUDGET | Column | `ZIPCODE` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `DIVISION_MGR` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `AREA_MGR` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `REGION_MGR` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `DISTRICT_MGR` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `ZONE_CODE` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `ZONE_DESC` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `MAJOR_REGION_CODE` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `MAJOR_REGION` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `STORE_TYPE` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `STORE_TYPE_DESC` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `RX_STORE_DESC` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `DISTRIBUTION_CNTR` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `DISTRIBUTION_CNTR_DESC` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `STORE_24_HR` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `BUDGET_OPEN_DAT` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `BUDGET_CLOSED_DAT` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `BUDGET_RELOC_DAT` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `CONST_OPEN_DAT` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `CONST_CLOSE_DAT` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `CONST_RELO_DAT` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `RELOCATION_DAT` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `BUDGET_EMERG_MKT_IND` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `COMPANY_CODE` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `COMPANY_CODE_DESC` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `ORIGINAL_FS_OPEN_DAT` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `ORIGINAL_RX_OPEN_DAT` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `GROUP_ONE` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `GROUP_TWO` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `ARD_SORT_KEY` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `AREA_COST_CENTER` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `REGIION_COST_CENTER` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `COUNTY_CODE` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `COUNTY_DESC` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `SQFT_BRACKET_DESC` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `SQFT_SORT_KEY` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `ACQUISITION_CODE` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `ACQUISITION_DESC` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `PHOTO_LAB_ADD_DAT` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `PHOTO_LAB_CLOSE_DAT` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `MIN_HRS_IND` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `CREATEDBY` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `CREATED_ON` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `KOKRS` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |
| RX BUDGET | Column | `KOSTL` (from CV_COMP_MD_SRPACT_STATIC) | CV_COMP_MD_SRPACT_STATIC.txt – SOURCE_COLUMNS_AND_MAPPINGS | not present | Exposed by source; not selected in consolidated `STORE_ATTR_ACTUAL`. |

---

## Overall Status: **Items Missed**

---

## Detailed Review Notes

### CV_BASE_FIN_WEEKLY_BUDGET_S4
- **Tables:** `AZSRP_DS052_VT_S4` → `v_bic_azsrp_ds202` (Found via mapping); `AZSRP_DS041_VT_S4` → `v_bic_azsrp_ds041` (Found via mapping). Both tables are present.
- **CTEs:** `Frozen_Cube`, `Live_Cube`, `Combined_Frozen_Live_Cube`, `Aggregated_Weekly_Budget`, `Summed_Measures` — all logic found in consolidated CTEs `Base_AZSRP_DS052_VT_S4`, `Base_AZSRP_DS041_VT_S4`, `Combined_Frozen_Live_Cube`, `Aggregated_Weekly_Budget`, `Weekly_Budget_With_Calculated_Amount`. Found.
- **Columns:** All columns (`FISCPER`, `FISCVARNT`, `_BIC_ZIO_SWEEK`, `FISCYEAR`, `FISCPER3`, `_B631_S_CHRTACCT`, `_B631_S_GL_ACCT`, `_B631_S_CO_AREA`, `_BIC_ZIO_CMPCD`, `_B631_S_PROFTCTR`, `_B631_S_COSTCNTR`, `_B631_S_FUNCAREA`, `_BIC_ZIO_VER`, `_BIC_ZIO_SAUDT`, `MANDT`, `_BIC_ZWWPC_PA1`, `_BIC_ZWWSC_PA1`, `RECORDMODE`, `CURRENCY`, `_B631_S_AMOUNT`, `_BIC_ZIO_AMT`, `FLAG`) — all found in consolidated (mapped via Columns_Mapping).
- **Filters:** `MANDT IN ('110','200')` — consolidated uses `mandt IN ('120', '200')`. Value `'110'` is replaced by `'120'`. **MISSED** (reported above).

### CV_BASE_MD_CEPCT_S4
- **Table:** `CEPCT` → `v_cepct` (Found via mapping).
- **CTE:** `Projected_Profit_Center_Texts` — logic found in consolidated `PROFIT_CENTER_TEXT` CTE. Found.
- **Columns:** `MANDT` (found), `SPRAS` (**MISSED**), `PRCTR` (found), `DATBI` (**MISSED**), `KOKRS` (**MISSED**), `KTEXT` (**MISSED**), `LTEXT` (found as `ltext`/`profit_center_text`), `MCTXT` (**MISSED**).
- **Filters:** `MANDT IN (120, 200)` → consolidated `mandt IN ('120', '200')` — Found (literal type change confirmed by mapping).

### CV_BASE_MD_COMPFL_S4
- **Table:** `ZTSRP_COMPFL` → `v_ztsrp_compfl` (Found via mapping).
- **CTE:** Single projection — logic found in consolidated `Base_ZTSRP_COMPFL`. Found.
- **Columns:** All 13 columns (`MANDT`, `PRCTR`, `STRNUM`, `COMP_VER`, `ZWEEK`, `ZMONTH`, `ZYEAR`, `FS_COMP_PRE`, `RX_COMP_PRE`, `FS_COMP_MON`, `RX_COMP_MON`, `FS_COMP_WK`, `RX_COMP_WK`) — all found in consolidated `Base_ZTSRP_COMPFL`.
- **Filters:** `MANDT IN (110, 200)` → consolidated `mandt IN ('110', '200')` — Found (literal type change confirmed by mapping).

### CV_BASE_MD_HRRP_NODE_S4
- **Table:** `HRRP_NODE` → `v_hrrp_node` (Found via mapping).
- **CTE:** `Projected_HRRP_Node_Records` — logic found in consolidated `HIER_NODE`. Found.
- **Columns:** `MANDT` (found), `HRYID` (**MISSED**), `HRYVER` (**MISSED**), `NODECLS` (**MISSED**), `HRYNODE` (**MISSED**), `PARNODE` (found), `HRYVALTO` (found), `HRYVALFROM` (**MISSED**), `BALIND` (**MISSED**), `NODETYPE` (**MISSED**), `NODEVALUE` (found).
- **Filters:** `MANDT IN (120, 200)` → consolidated `mandt IN ('120', '200')` — Found.

### CV_BASE_MD_RCALWEEK_S4
- **Table:** `ZTFIGL_RCALWEEK` → `v_ztfigl_rcalweek` (Found via mapping).
- **CTE:** Single projection — logic found in consolidated `CAL_WEEK` and `WEEKDATES`. Found.
- **Columns:** `RCLNT` (found), `ZZWEEK` (found), `ZCALYRP` (**MISSED**), `ZRYEAR` (**MISSED**), `ZRPERIOD` (**MISSED**), `ZRYRP` (**MISSED**), `ZRYRQTR` (**MISSED**), `ZRWSTRTDATE` (found), `ZRWENDDATE` (found).
- **Filters:** `RCLNT IN (120, 200)` → consolidated `rclnt IN ('120', '200')` — Found.

### CV_BASE_MD_SRPACT_S4
- **Table:** `ZTSRP_ATTR_ACT` → `v_ztsrp_attr_act` (Found via mapping).
- **CTE:** `Filtered_Store_Profile_Attributes` — logic found in consolidated `Base_ZTSRP_ATTR_ACT`. Found.
- **Columns:** `MANDT`, `STRNUM`, `PRCTR`, `RX_OPEN_DAT`, `RX_CLOSE_DAT`, `RX_HRS_OPER`, `FS_OPEN_DAT`, `FS_CLOSE_DAT`, `FS_HRS_OPER`, `REP_MKT_CODE`, `REP_MKT_DESC`, `CITY`, `STATE`, `DIVISION_CODE`, `DIVISION_DESC`, `AREA_CODE`, `AREA_DESC`, `DISTRICT_CODE`, `DISTRICT_DESC`, `REGION_CODE`, `REGION_DESC`, `EMERG_MKT_IND`, `RX_STORE`, `RETAIL_SQFT_AMT`, `TOTAL_SQFT_AMT`, `RX_DIVISION_CODE`, `RX_AREA_CODE`, `RX_REGION_CODE`, `RX_DISTRICT_CODE` — Found. All columns listed under **MISSED** above are absent from the consolidated `Base_ZTSRP_ATTR_ACT` and `STORE_ATTR_ACTUAL` CTEs.
- **Filters:** `MANDT IN (120, 200)` → consolidated `mandt IN ('120', '200')` — Found.

### CV_COMP_FIN_BUDGET_STATIC
- **Tables:** All 6 source Calculation Views (`CV_BASE_FIN_WEEKLY_BUDGET_S4`, `CV_BASE_MD_HRRP_NODE_S4`, `CV_COMP_MD_SRPACT_STATIC`, `CV_COMP_MD_COMPFL_STATIC`, `CV_BASE_MD_RCALWEEK_S4`, `CV_BASE_MD_CEPCT_S4`) — logic inlined in consolidated. Found.
- **CTEs:** `WEEKLY_SNAPSHOT_DS05`, `HIER_NODE`, `Join_1`/`ONLY_CORE_RET_DATA`, `STORE_ATTR_ACTUAL`, `WEEK_NUMBER`, `COMP_FLAG_BUDGET`, `Join_3`, `CAL_WEEK`, `Join_4`, `PROFIT_CENTER_TEXT`, `Join_5`, `FLAGS` — all found in consolidated under equivalent names.
- **Columns:** All output columns found in consolidated final SELECT.
- **Filters:**
  - `FISCVARNT = 'K4'` — Found (consolidated line ~165).
  - `_BIC_ZIO_SWEEK BETWEEN @IP_WEEK_ENDING_FROM AND @IP_WEEK_ENDING_TO` — Consolidated replaces this with `bic_zio_sweek = (Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)` (single week equality). The BETWEEN range filter is absent; however, the consolidated uses a dynamic single-week derivation. This is a changed filter (range → single value). **Reported as MISSED filter** above.
  - `_BIC_ZIO_VER = @IP_VERSION` → `bic_zio_ver = 'LEDGER_BUD'` — Found (hardcoded value matches default).
  - `_BIC_ZIO_SAUDT IN ('1', '10')` — Found (consolidated line ~168).
  - `REGEXP_CONTAINS(PARNODE, r'.*CORE_RET$')` — Found (consolidated line ~198).
  - `HRYVALTO = '99991231'` → `hryvalto = DATE '9999-12-31'` — Found (functionally equivalent).
  - `COMP_VER = @IP_VERSION` → `comp_ver = 'LEDGER_BUD'` — Found.

### CV_COMP_MD_COMPFL_STATIC
- **Table:** `v_ztsrp_compfl` (via CV_BASE_MD_COMPFL_S4) — Found.
- **CTE:** `TBL_WSS_SRP_COMPFLAG_FROM_STP_WSS_SRP_ATTRIBUTES` — logic found in consolidated `Base_ZTSRP_COMPFL` / `COMP_FLAG_BUDGET`. Found.
- **Columns:** `MANDT`, `PRCTR`, `STRNUM`, `COMP_VER`, `ZWEEK`, `ZMONTH`, `ZYEAR`, `FS_COMP_WK`, `RX_COMP_WK` — Found. `FS_COMP_PRE`, `RX_COMP_PRE`, `FS_COMP_MON`, `RX_COMP_MON` — **MISSED**.
- **Filters:** `ZWEEK = @V_WEEK` → consolidated `zweek = (Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)` — Found (dynamic equivalent).

### CV_COMP_MD_SRPACT_STATIC
- **Table:** `TBL_WSS_SRP_ATTR_ACT` (backed by `v_ztsrp_attr_act`) — Found.
- **CTE:** Single aggregation — logic found in consolidated `Base_ZTSRP_ATTR_ACT` / `STORE_ATTR_ACTUAL`. Found.
- **Columns:** `MANDT`, `STRNUM`, `PRCTR`, `REP_MKT_CODE`, `REP_MKT_DESC`, `EMERG_MKT_IND`, `DIVISION_CODE`, `DIVISION_DESC`, `AREA_CODE`, `AREA_DESC`, `DISTRICT_CODE`, `DISTRICT_DESC`, `REGION_CODE`, `REGION_DESC`, `CITY`, `STATE`, `FS_OPEN_DAT`, `RX_OPEN_DAT`, `RX_DIVISION_CODE`, `RX_AREA_CODE`, `RX_REGION_CODE`, `RX_DISTRICT_CODE`, `RX_HRS_OPER`, `FS_HRS_OPER`, `RX_STORE`, `RETAIL_SQFT_AMT`, `TOTAL_SQFT_AMT` — Found. All columns listed under **MISSED** above are absent from the consolidated `STORE_ATTR_ACTUAL` CTE.
- **Filters:** No filters defined in source. N/A.

### STP_WSS_SRP_ATTRIBUTES
- **Source Type:** HANA SQLScript Procedure (DDL/DML — DELETE + INSERT). Per review rules, DDL/DML statements are not checked.
- **SELECT logic read by procedure:** Reads from `CV_BASE_MD_SRPACT_S4` (no filter) and `CV_BASE_MD_COMPFL_S4` (filter `ZWEEK = V_WEEK`). Both sources and their filters are represented in the consolidated query. Found.
- **Columns written to staging tables:** Audit columns `SNAPSHOT_TIMESTAMP` and `SNAPSHOT_CREATED_BY`/`CREATED_BY` are procedure-internal and not part of the Calculation View output contract; not checked.
- **File status:** Found (procedure logic is inlined in consolidated).
