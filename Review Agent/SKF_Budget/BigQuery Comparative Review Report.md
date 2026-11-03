# BigQuery Comparative Review Report
**Group:** SKF_BUDGET  
**Consolidated File:** SKF_BUDGET Consolidated File_v2  
**Review Date:** 2025

---

## Scorecard

| Group | Completeness | Accuracy | Efficiency |
|-------|-------------|----------|------------|
| SKF_BUDGET | 98.8% (84 of 85 items present) | 97.6% (82 of 84 carried-over items unchanged) | 61.5% (8 unique tables / 13 table references) |
| **Overall** | **98.8% (84 of 85 items present)** | **97.6% (82 of 84 carried-over items unchanged)** | **61.5% (8 unique tables / 13 table references)** |

---

## Summary

| Group | Files Missed | Tables Missed | CTEs Missed | Columns Missed | Filters Missed | Status |
|-------|-------------|---------------|-------------|----------------|----------------|--------|
| SKF_BUDGET | 0 of 9 | 0 of 9 | 0 of 10 | 1 of 44 | 2 of 13 | Items Missed |
| **Overall** | **0 of 9** | **0 of 9** | **0 of 10** | **1 of 44** | **2 of 13** | **Items Missed** |

---

## Missed Items

| # | Group | Type | Item | Source (file : line) | Source Evidence | Consolidated (line or "not present") | Notes |
|---|-------|------|------|----------------------|-----------------|--------------------------------------|-------|
| 1 | SKF_BUDGET | Column | `SKF_BUD_CUBE` (FLAG AS SKF_BUD_CUBE) | CV_COMP_SKF_BUDGET_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt : line not determinable | `FLAG AS SKF_BUD_CUBE,` in final SELECT of CONVERTED_BIGQUERY_SQL | not present | ABSENT — The column `FLAG AS SKF_BUD_CUBE` is present in the individual file's final SELECT output but is absent from the consolidated file's final SELECT. The `flag` column is used only internally within `combined_weekly_budget` and `weekly_snapshot_filtered` CTEs in the consolidated file and is not surfaced as an output column. |
| 2 | SKF_BUDGET | Filter | `_BIC_ZIO_SWEEK BETWEEN @IP_WEEK_ENDING_FROM AND @IP_WEEK_ENDING_TO` | CV_COMP_SKF_BUDGET_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt : line not determinable | `AND _BIC_ZIO_SWEEK BETWEEN @IP_WEEK_ENDING_FROM AND @IP_WEEK_ENDING_TO` in WEEKLY_SNAPSHOT_DS05 WHERE clause | SKF_BUDGET Consolidated File_v2 : line 176 | CHANGED — The individual file applies a range filter (`BETWEEN @IP_WEEK_ENDING_FROM AND @IP_WEEK_ENDING_TO`) allowing any week within the specified range. The consolidated file replaces this with a single-value IN subquery (`bic_zio_sweek in (Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)`), which restricts to only the single prior week. A BETWEEN range filter became a single-value equality/IN filter; the parameters `@IP_WEEK_ENDING_FROM` and `@IP_WEEK_ENDING_TO` have no stated defaults in the source file. |
| 3 | SKF_BUDGET | Filter | `ZWEEK = @V_WEEK` | CV_COMP_SKF_BUDGET_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt : line not determinable | `AND jw._BIC_ZIO_SWEEK = c.ZWEEK` (join) and `COMP_VER = @IP_VERSION` in COMP_FLAG_BUDGET; source procedure STP_WSS_SRP_ATTRIBUTES_DI filters `WHERE ZWEEK = V_WEEK` | SKF_BUDGET Consolidated File_v2 : line 213 | CHANGED — The individual file (via STP_WSS_SRP_ATTRIBUTES_DI) populates the comp flag table with `WHERE ZWEEK = V_WEEK` (prior fiscal week from external function). The consolidated file replaces this with a dynamic subquery `zweek = (Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)`. The parameter `@V_WEEK` has no stated default value in the source files; the replacement is a dynamic subquery rather than a parameter, constituting a structural change. |

---

## Warnings

| Group | File | Reason |
|-------|------|--------|
| SKF_BUDGET | STP_WSS_SRP_ATTRIBUTES_DI HANA to BigQuery SQL Conversion Agent.txt | Excluded — DDL/DML. This file is a HANA SQLScript procedure that performs DELETE and INSERT operations (writes data to TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG). Its SELECT logic is covered by CV_BASE_MD_SRPACT_S4_DI and CV_BASE_MD_COMPFL_S4_DI, which are separately inventoried. |

---

## Inventory Reference

### File Layering

| File | Role |
|------|------|
| CV_BASE_SKF_WEEKLY_BUDGET_S4_DI | Base file — reads AZSRP_DS092_VT_S4 (frozen cube) and AZSRP_DS031_VT_S4 (live cube) |
| CV_BASE_MD_CEPCT_S4_DI | Base file — reads CEPCT (profit center text) |
| CV_BASE_MD_COMPFL_S4_DI | Base file — reads ZTSRP_COMPFL (comp flags) |
| CV_BASE_MD_HRRP_NODE_S4_DI | Base file — reads HRRP_NODE (hierarchy nodes) |
| CV_BASE_MD_RCALWEEK_S4_DI | Base file — reads ZTFIGL_RCALWEEK (retail calendar week) |
| CV_BASE_MD_SRPACT_S4_DI | Base file — reads ZTSRP_ATTR_ACT (store attributes) |
| CV_COMP_MD_COMPFL_STATIC_DI | Consuming file — reads TBL_WSS_SRP_COMPFLAG (static comp flag table populated by STP procedure) |
| CV_COMP_MD_SRPACT_STATIC_DI | Consuming file — reads TBL_WSS_SRP_ATTR_ACT (static store attributes table populated by STP procedure) |
| CV_COMP_SKF_BUDGET_STATIC_DI | Top-level consuming file — consumes all above views |
| STP_WSS_SRP_ATTRIBUTES_DI | DDL/DML procedure — excluded from inventory counts |

### Consolidated File Statistics

| Metric | Value |
|--------|-------|
| Table References (FROM/JOIN) | 13 |
| Unique Source Tables | 8 |
| CTEs Defined | 15 (WEEKDATES, FC_CONTROL, base_weekly_budget_frozen, base_weekly_budget_live, combined_weekly_budget, weekly_snapshot_filtered, hierarchy_nodes_filtered, store_attributes_actual, weekly_with_hierarchy, weekly_with_store_attrs, comp_flags_budget, weekly_with_comp_flags, calendar_week, weekly_with_calendar, profit_center_text, weekly_with_profit_center_text, flags_with_calculations — note: WEEKDATES and FC_CONTROL are new additions not in individual files) |

### Unique Source Tables Referenced in Consolidated File

| # | BQ Table | HANA Source |
|---|----------|-------------|
| 1 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek | ZTFIGL_RCALWEEK |
| 2 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_finsc_fisc_date | (new — not in individual files) |
| 3 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds092 | AZSRP_DS092_VT_S4 |
| 4 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds031 | AZSRP_DS031_VT_S4 |
| 5 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node | HRRP_NODE |
| 6 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act | ZTSRP_ATTR_ACT / TBL_WSS_SRP_ATTR_ACT |
| 7 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl | ZTSRP_COMPFL / TBL_WSS_SRP_COMPFLAG |
| 8 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct | CEPCT |
