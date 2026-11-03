# BigQuery Comparative Review Report
**Group:** RX BUDGET  
**Consolidated File:** RX_BUDGET Consolidated Query_v2.txt  
**Mapping File:** Columns_Mapping.csv  

---

## Scorecard

| Group | Completeness | Accuracy | Efficiency |
|-------|-------------|----------|------------|
| RX BUDGET | 89.5% (103 of 115 items present) | 85.4% (88 of 103 items carried over unchanged) | 54.5% (6 unique tables / 11 table references) |
| **Overall** | **89.5% (103 of 115 items present)** | **85.4% (88 of 103 items carried over unchanged)** | **54.5% (6 unique tables / 11 table references)** |

> **Efficiency note:** The consolidated file reads `v_ztfigl_rcalweek` 3 times (WEEKDATES CTE ×2 aliases + CAL_WEEK CTE), `v_bic_azsrp_ds202` 2 times (FC_CONTROL + Base_AZSRP_DS052_VT_S4), and each of `v_bic_azsrp_ds041`, `v_hrrp_node`, `v_ztsrp_attr_act`, `v_ztsrp_compfl`, `v_cepct` once = 11 total references, 6 unique tables.

---

## Summary

| Group | Files Missed | Tables Missed | CTEs Missed | Columns Missed | Filters Missed | Status |
|-------|-------------|---------------|-------------|----------------|----------------|--------|
| RX BUDGET | 0 of 10 | 0 of 7 | 0 of 19 | 3 of 67 | 9 of 12 | Items Missed |
| **Overall** | **0 of 10** | **0 of 7** | **0 of 19** | **3 of 67** | **9 of 12** | **Items Missed** |

---

## Missed Items

| # | Group | Type | Item | Source (file : line) | Source Evidence | Consolidated (line or "not present") | Notes |
|---|-------|------|------|----------------------|-----------------|--------------------------------------|-------|
| 1 | RX BUDGET | Filter | `_BIC_ZIO_SWEEK BETWEEN @IP_WEEK_ENDING_FROM AND @IP_WEEK_ENDING_TO` | CV_COMP_FIN_BUDGET_STATIC.txt : line not determinable | `AND _BIC_ZIO_SWEEK BETWEEN $$IP_WEEK_ENDING_FROM$$ AND $$IP_WEEK_ENDING_TO$$` | WEEKLY_SNAPSHOT_DS05 CTE — `AND bic_zio_sweek = (Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)` | CHANGED — Source uses a parameterised BETWEEN range (`@IP_WEEK_ENDING_FROM` to `@IP_WEEK_ENDING_TO`); consolidated replaces it with a single-value equality derived from a computed WEEKDATES CTE (previous week only). A BETWEEN range became a single-value equality and the parameter was replaced by a hardcoded subquery. |
| 2 | RX BUDGET | Filter | `_BIC_ZIO_VER = @IP_VERSION` (parameter, default `'LEDGER_BUD'`) | CV_COMP_FIN_BUDGET_STATIC.txt : line not determinable | `AND _BIC_ZIO_VER = $$IP_VERSION$$` | WEEKLY_SNAPSHOT_DS05 CTE — `AND bic_zio_ver = 'LEDGER_BUD'` | CHANGED — Parameter `@IP_VERSION` replaced by hardcoded literal `'LEDGER_BUD'`. The default value of `@IP_VERSION` is `'LEDGER_BUD'` (stated in source), so the value matches the default; however, the parameter is no longer dynamic — any non-default runtime value cannot be passed. Per rules, a parameter replaced by a hardcoded value is Found only if the hardcoded value equals the parameter's default. The default is `'LEDGER_BUD'` and the hardcoded value is `'LEDGER_BUD'`, so this is technically Found. *(Reclassified to Found — see self-check note below.)* |
| 3 | RX BUDGET | Filter | `COMP_VER = @IP_VERSION` in COMP_FLAG_BUDGET | CV_COMP_FIN_BUDGET_STATIC.txt : line not determinable | `COMP_VER = $$IP_VERSION$$` | COMP_FLAG_BUDGET CTE — `comp_ver = 'LEDGER_BUD'` | CHANGED — Parameter `@IP_VERSION` replaced by hardcoded literal `'LEDGER_BUD'`. Default of `@IP_VERSION` is `'LEDGER_BUD'`; hardcoded value matches default → Found per rules. *(Reclassified to Found — see self-check note below.)* |
| 4 | RX BUDGET | Filter | `MANDT IN ('110', '200')` on `AZSRP_DS052_VT_S4` (Frozen_Cube) | CV_BASE_FIN_WEEKLY_BUDGET_S4.txt : line not determinable | `MANDT IN ('110', '200')` | Base_AZSRP_DS052_VT_S4 CTE — `mandt IN ('120', '200')` | CHANGED — Value `'110'` changed to `'120'` in the IN list. This is not a client/environment filter exclusion because MANDT on the BIC fact tables (AZSRP_DS052, AZSRP_DS041) is a data-filtering dimension, not the system client column (RCLNT/MANDT as a system client). The mapping file confirms these are data columns. Value `'110'` is absent; `'120'` appears instead. |
| 5 | RX BUDGET | Filter | `MANDT IN ('110', '200')` on `AZSRP_DS041_VT_S4` (Live_Cube) | CV_BASE_FIN_WEEKLY_BUDGET_S4.txt : line not determinable | `MANDT IN ('110', '200')` | Base_AZSRP_DS041_VT_S4 CTE — `mandt IN ('120', '200')` | CHANGED — Value `'110'` changed to `'120'`. Same reasoning as item 4. |
| 6 | RX BUDGET | Filter | `MANDT IN (110, 200)` on `ZTSRP_COMPFL` | CV_BASE_MD_COMPFL_S4.txt : line not determinable | `MANDT IN (110, 200)` | Base_ZTSRP_COMPFL CTE — `mandt IN ('110', '200')` | CHANGED — Source has numeric literals `110, 200`; consolidated has string literals `'110', '200'`. The mapping file (BQ_DATATYPE = STRING for ZTSRP_COMPFL.MANDT) confirms the BQ column is STRING, so string literals are correct in BigQuery. However, the source used numeric literals. Per rules, literal-type changes are Found only if the mapping file confirms them. The mapping file confirms MANDT is STRING in BigQuery, so this is a mapping-confirmed type change → Found. *(Reclassified to Found.)* |
| 7 | RX BUDGET | Filter | `ZWEEK = @V_WEEK` on `CV_BASE_MD_COMPFL_S4` (via procedure) | CV_COMP_MD_COMPFL_STATIC.txt : line not determinable | `WHERE ZWEEK = @V_WEEK` | Base_ZTSRP_COMPFL CTE — `AND zweek = (Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)` | CHANGED — Parameter `@V_WEEK` (set by `SFN_PRIOR_FISCAL_WEEK()`) replaced by a subquery `(Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)`. No default value for `@V_WEEK` is stated in the source (it is computed at runtime by an external function). The replacement is a computed subquery, not a hardcoded literal equal to a known default. This is a CHANGED filter — the mechanism for determining the week value differs. |
| 8 | RX BUDGET | Filter | `@IP_FC_COUNT != '0'` on Frozen_Cube | CV_BASE_FIN_WEEKLY_BUDGET_S4.txt : line not determinable | `AND @IP_FC_COUNT != '0'` | Base_AZSRP_DS052_VT_S4 CTE — `AND (SELECT FC_CONTROL.IP_FC_COUNT FROM FC_CONTROL) != 0` | CHANGED — Parameter `@IP_FC_COUNT` replaced by a subquery `(SELECT FC_CONTROL.IP_FC_COUNT FROM FC_CONTROL)`. No default value for `@IP_FC_COUNT` is stated in the source file (it is derived from an external function). The replacement is a computed subquery, not a hardcoded literal equal to a known default. Additionally, the source compares to string `'0'` while the consolidated compares to integer `0`. This is a CHANGED filter. |
| 9 | RX BUDGET | Filter | `@IP_FC_COUNT = '0'` on Live_Cube | CV_BASE_FIN_WEEKLY_BUDGET_S4.txt : line not determinable | `AND @IP_FC_COUNT = '0'` | Base_AZSRP_DS041_VT_S4 CTE — `AND (SELECT FC_CONTROL.IP_FC_COUNT FROM FC_CONTROL) = 0` | CHANGED — Same as item 8: parameter replaced by subquery; string `'0'` vs integer `0`. CHANGED filter. |
| 10 | RX BUDGET | Filter | `HRYVALTO = '99991231'` on HIER_NODE | CV_COMP_FIN_BUDGET_STATIC.txt : line not determinable | `AND HRYVALTO = '99991231'` | HIER_NODE CTE — `AND hryvalto = DATE '9999-12-31'` | CHANGED — Source uses string literal `'99991231'`; consolidated uses a DATE literal `DATE '9999-12-31'`. The mapping file shows HRYVALTO is mapped to BQ type DATE. A literal-type change from string to DATE is confirmed by the mapping file → Found per rules. *(Reclassified to Found.)* |
| 11 | RX BUDGET | Column | `_B631_S_AMOUNT_NEGATIVE` (intermediate column in FLAGS CTE) | CV_COMP_FIN_BUDGET_STATIC.txt : line not determinable | `_B631_S_AMOUNT_NEGATIVE` listed as a measure in FLAGS output; `_B631_S_AMOUNT = _B631_S_AMOUNT_NEGATIVE * -1` | FLAGS CTE — `b631_s_amount AS b631_s_amount_negative` then `(b631_s_amount * -1) AS b631_s_amount` | CHANGED — In the source, `_B631_S_AMOUNT_NEGATIVE` is a separate measure column that is the raw amount before negation, and `_B631_S_AMOUNT` is the negated result. In the consolidated, `b631_s_amount` from the upstream CTE is aliased as `b631_s_amount_negative`, and then `(b631_s_amount * -1)` produces `b631_s_amount`. The source's `_B631_S_AMOUNT_NEGATIVE` was a distinct aggregated measure in the final SELECT (`SUM(_B631_S_AMOUNT_NEGATIVE)`); in the consolidated it is also present as `SUM(b631_s_amount_negative)`. Found — the column and its aggregation are present. *(Reclassified to Found.)* |
| 12 | RX BUDGET | Column | `SPRAS` (from CV_BASE_MD_CEPCT_S4) | CV_BASE_MD_CEPCT_S4.txt : line not determinable | `SPRAS` selected from `CEPCT` | PROFIT_CENTER_TEXT CTE — only `mandt`, `prctr`, `ltext AS profit_center_text` selected | ABSENT — `SPRAS` is selected in the individual file CV_BASE_MD_CEPCT_S4 but is not carried into the consolidated PROFIT_CENTER_TEXT CTE or any downstream CTE/final SELECT. |
| 13 | RX BUDGET | Column | `DATBI` (from CV_BASE_MD_CEPCT_S4) | CV_BASE_MD_CEPCT_S4.txt : line not determinable | `DATBI` selected from `CEPCT` | PROFIT_CENTER_TEXT CTE — not present | ABSENT — `DATBI` is selected in CV_BASE_MD_CEPCT_S4 but absent from the consolidated PROFIT_CENTER_TEXT CTE and all downstream output. |
| 14 | RX BUDGET | Column | `KOKRS` (from CV_BASE_MD_CEPCT_S4) | CV_BASE_MD_CEPCT_S4.txt : line not determinable | `KOKRS` selected from `CEPCT` | PROFIT_CENTER_TEXT CTE — not present | ABSENT — `KOKRS` is selected in CV_BASE_MD_CEPCT_S4 but absent from the consolidated PROFIT_CENTER_TEXT CTE and all downstream output. |

---

### Self-Check Notes (Step 3)

After re-checking items 2, 3, 6, 10, and 11 against the consolidated file:

- **Item 2** (`_BIC_ZIO_VER = @IP_VERSION`): Hardcoded `'LEDGER_BUD'` equals the stated default `'LEDGER_BUD'` → **Found** (removed from Missed Items).
- **Item 3** (`COMP_VER = @IP_VERSION`): Same reasoning → **Found** (removed from Missed Items).
- **Item 6** (`MANDT IN (110, 200)` numeric vs string): Mapping confirms STRING type in BQ → **Found** (removed from Missed Items).
- **Item 10** (`HRYVALTO = '99991231'` vs `DATE '9999-12-31'`): Mapping confirms DATE type → **Found** (removed from Missed Items).
- **Item 11** (`_B631_S_AMOUNT_NEGATIVE`): Present in consolidated as `b631_s_amount_negative` with `SUM()` → **Found** (removed from Missed Items).

**Final Missed Items (after self-check): 6 rows** — Items 1, 4, 5, 7, 8, 9 (Filters) + Items 12, 13, 14 (Columns) = **9 rows total**.

---

### Reconciled Missed Items Table

| # | Group | Type | Item | Source (file : line) | Source Evidence | Consolidated (line or "not present") | Notes |
|---|-------|------|------|----------------------|-----------------|--------------------------------------|-------|
| 1 | RX BUDGET | Filter | `_BIC_ZIO_SWEEK BETWEEN @IP_WEEK_ENDING_FROM AND @IP_WEEK_ENDING_TO` | CV_COMP_FIN_BUDGET_STATIC.txt : line not determinable | `AND _BIC_ZIO_SWEEK BETWEEN $$IP_WEEK_ENDING_FROM$$ AND $$IP_WEEK_ENDING_TO$$` | WEEKLY_SNAPSHOT_DS05 CTE: `AND bic_zio_sweek = (Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)` | CHANGED — BETWEEN range with two parameters replaced by single-value equality via computed subquery. |
| 2 | RX BUDGET | Filter | `MANDT IN ('110', '200')` on `AZSRP_DS052_VT_S4` (Frozen_Cube) | CV_BASE_FIN_WEEKLY_BUDGET_S4.txt : line not determinable | `MANDT IN ('110', '200')` | Base_AZSRP_DS052_VT_S4 CTE: `mandt IN ('120', '200')` | CHANGED — Value `'110'` dropped; `'120'` substituted. |
| 3 | RX BUDGET | Filter | `MANDT IN ('110', '200')` on `AZSRP_DS041_VT_S4` (Live_Cube) | CV_BASE_FIN_WEEKLY_BUDGET_S4.txt : line not determinable | `MANDT IN ('110', '200')` | Base_AZSRP_DS041_VT_S4 CTE: `mandt IN ('120', '200')` | CHANGED — Value `'110'` dropped; `'120'` substituted. |
| 4 | RX BUDGET | Filter | `ZWEEK = @V_WEEK` on comp flag source | CV_COMP_MD_COMPFL_STATIC.txt : line not determinable | `WHERE ZWEEK = @V_WEEK` | Base_ZTSRP_COMPFL CTE: `AND zweek = (Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)` | CHANGED — Parameter `@V_WEEK` (no stated default) replaced by computed subquery. |
| 5 | RX BUDGET | Filter | `@IP_FC_COUNT != '0'` on Frozen_Cube | CV_BASE_FIN_WEEKLY_BUDGET_S4.txt : line not determinable | `AND @IP_FC_COUNT != '0'` | Base_AZSRP_DS052_VT_S4 CTE: `AND (SELECT FC_CONTROL.IP_FC_COUNT FROM FC_CONTROL) != 0` | CHANGED — Parameter replaced by subquery; string `'0'` vs integer `0`. |
| 6 | RX BUDGET | Filter | `@IP_FC_COUNT = '0'` on Live_Cube | CV_BASE_FIN_WEEKLY_BUDGET_S4.txt : line not determinable | `AND @IP_FC_COUNT = '0'` | Base_AZSRP_DS041_VT_S4 CTE: `AND (SELECT FC_CONTROL.IP_FC_COUNT FROM FC_CONTROL) = 0` | CHANGED — Parameter replaced by subquery; string `'0'` vs integer `0`. |
| 7 | RX BUDGET | Column | `SPRAS` (from CV_BASE_MD_CEPCT_S4 / CEPCT) | CV_BASE_MD_CEPCT_S4.txt : line not determinable | `SPRAS` selected from `CEPCT` | not present | ABSENT — Column selected in individual file but not carried into consolidated PROFIT_CENTER_TEXT CTE or final output. |
| 8 | RX BUDGET | Column | `DATBI` (from CV_BASE_MD_CEPCT_S4 / CEPCT) | CV_BASE_MD_CEPCT_S4.txt : line not determinable | `DATBI` selected from `CEPCT` | not present | ABSENT — Column selected in individual file but not carried into consolidated PROFIT_CENTER_TEXT CTE or final output. |
| 9 | RX BUDGET | Column | `KOKRS` (from CV_BASE_MD_CEPCT_S4 / CEPCT) | CV_BASE_MD_CEPCT_S4.txt : line not determinable | `KOKRS` selected from `CEPCT` | not present | ABSENT — Column selected in individual file but not carried into consolidated PROFIT_CENTER_TEXT CTE or final output. |

---

## Scorecard (Reconciled)

> Recalculated after self-check reclassifications.

**Inventory Totals:**
- Files: 10 (CV_BASE_FIN_WEEKLY_BUDGET_S4, CV_BASE_MD_CEPCT_S4, CV_BASE_MD_COMPFL_S4, CV_BASE_MD_HRRP_NODE_S4, CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_SRPACT_S4, CV_COMP_FIN_BUDGET_STATIC, CV_COMP_MD_COMPFL_STATIC, CV_COMP_MD_SRPACT_STATIC, STP_WSS_SRP_ATTRIBUTES [DDL/DML excluded from counts])
- Effective individual files checked: 9 (STP_WSS_SRP_ATTRIBUTES excluded as DDL/DML)
- Tables (unique): 7
- CTEs (unique): 19
- Columns (unique, deduplicated): 67
- Filters (unique, excluding client/env filters): 12
- **Total Checked: 9 + 7 + 19 + 67 + 12 = 114** *(Files counted as 9 after DDL exclusion)*

**Missed:**
- Files Missed: 0
- Tables Missed: 0
- CTEs Missed: 0
- Columns Missed: 3 (SPRAS, DATBI, KOKRS — all ABSENT)
- Filters Missed: 6 (items 1–6 above — all CHANGED)
- **Total Missed: 9**

**Completeness %** = (114 − 3) / 114 × 100 = 111 / 114 × 100 = **97.4% (111 of 114 items present)**

**Accuracy %** = (114 − 3 − 6) / (114 − 3) × 100 = 105 / 111 × 100 = **94.6% (105 of 111 carried-over items unchanged)**

**Efficiency %** = 6 unique tables / 11 table references × 100 = **54.5%**

| Group | Completeness | Accuracy | Efficiency |
|-------|-------------|----------|------------|
| RX BUDGET | 97.4% (111 of 114 items present) | 94.6% (105 of 111 items carried over unchanged) | 54.5% (6 unique tables / 11 table references) |
| **Overall** | **97.4% (111 of 114 items present)** | **94.6% (105 of 111 items carried over unchanged)** | **54.5% (6 unique tables / 11 table references)** |

---

## Summary (Reconciled)

| Group | Files Missed | Tables Missed | CTEs Missed | Columns Missed | Filters Missed | Status |
|-------|-------------|---------------|-------------|----------------|----------------|--------|
| RX BUDGET | 0 of 9 | 0 of 7 | 0 of 19 | 3 of 67 | 6 of 12 | Items Missed |
| **Overall** | **0 of 9** | **0 of 7** | **0 of 19** | **3 of 67** | **6 of 12** | **Items Missed** |

---

## Warnings

| Group | File | Reason |
|-------|------|--------|
| RX BUDGET | STP_WSS_SRP_ATTRIBUTES.txt | Excluded — DDL/DML. File is a HANA SQLScript procedure containing DELETE and INSERT statements. Its SELECT logic (reading from CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_COMPFL_S4) is already covered by those individual files and their corresponding consolidated CTEs. |

---

## Inventory Reference (Step 1 Detail)

### Files (F)

| File | Type | Notes |
|------|------|-------|
| CV_BASE_FIN_WEEKLY_BUDGET_S4.txt | Base Calculation View (CUBE/Aggregation) | Reads AZSRP_DS052_VT_S4 and AZSRP_DS041_VT_S4 |
| CV_BASE_MD_CEPCT_S4.txt | Base Calculation View (DIMENSION/Projection) | Reads CEPCT |
| CV_BASE_MD_COMPFL_S4.txt | Base Calculation View (DIMENSION/Projection) | Reads ZTSRP_COMPFL |
| CV_BASE_MD_HRRP_NODE_S4.txt | Base Calculation View (DIMENSION/Projection) | Reads HRRP_NODE |
| CV_BASE_MD_RCALWEEK_S4.txt | Base Calculation View (DIMENSION/Projection) | Reads ZTFIGL_RCALWEEK |
| CV_BASE_MD_SRPACT_S4.txt | Base Calculation View (CUBE/Aggregation) | Reads ZTSRP_ATTR_ACT |
| CV_COMP_FIN_BUDGET_STATIC.txt | Composite Calculation View (CUBE/Aggregation) | Consuming file — reads all 6 base views above |
| CV_COMP_MD_COMPFL_STATIC.txt | Composite Calculation View (DIMENSION/Projection) | Reads TBL_WSS_SRP_COMPFLAG (procedure-populated from CV_BASE_MD_COMPFL_S4) |
| CV_COMP_MD_SRPACT_STATIC.txt | Composite Calculation View (CUBE/Aggregation) | Reads TBL_WSS_SRP_ATTR_ACT (procedure-populated from CV_BASE_MD_SRPACT_S4) |
| STP_WSS_SRP_ATTRIBUTES.txt | HANA SQLScript Procedure | **Excluded — DDL/DML** |

### Tables (T) — Unique Source Tables

| Table (HANA) | BQ Mapped Name | Source Files |
|---|---|---|
| AZSRP_DS052_VT_S4 | `v_bic_azsrp_ds202` | CV_BASE_FIN_WEEKLY_BUDGET_S4, CV_COMP_FIN_BUDGET_STATIC |
| AZSRP_DS041_VT_S4 | `v_bic_azsrp_ds041` | CV_BASE_FIN_WEEKLY_BUDGET_S4, CV_COMP_FIN_BUDGET_STATIC |
| HRRP_NODE | `v_hrrp_node` | CV_BASE_MD_HRRP_NODE_S4, CV_COMP_FIN_BUDGET_STATIC |
| ZTSRP_ATTR_ACT | `v_ztsrp_attr_act` | CV_BASE_MD_SRPACT_S4, CV_COMP_MD_SRPACT_STATIC, CV_COMP_FIN_BUDGET_STATIC |
| ZTSRP_COMPFL | `v_ztsrp_compfl` | CV_BASE_MD_COMPFL_S4, CV_COMP_MD_COMPFL_STATIC, CV_COMP_FIN_BUDGET_STATIC |
| ZTFIGL_RCALWEEK | `v_ztfigl_rcalweek` | CV_BASE_MD_RCALWEEK_S4, CV_COMP_FIN_BUDGET_STATIC |
| CEPCT | `v_cepct` | CV_BASE_MD_CEPCT_S4, CV_COMP_FIN_BUDGET_STATIC |

**All 7 tables found in consolidated file.** ✓

### CTEs / Subquery Blocks (C) — Unique Logic Blocks

| CTE / Logic Block | Source File | Found in Consolidated |
|---|---|---|
| Frozen_Cube (projection from AZSRP_DS052) | CV_BASE_FIN_WEEKLY_BUDGET_S4 | ✓ Base_AZSRP_DS052_VT_S4 |
| Live_Cube (projection from AZSRP_DS041) | CV_BASE_FIN_WEEKLY_BUDGET_S4 | ✓ Base_AZSRP_DS041_VT_S4 |
| Combined_Frozen_Live_Cube (UNION ALL) | CV_BASE_FIN_WEEKLY_BUDGET_S4 | ✓ Combined_Frozen_Live_Cube |
| Aggregated_Weekly_Budget (GROUP BY + SUM) | CV_BASE_FIN_WEEKLY_BUDGET_S4 | ✓ Aggregated_Weekly_Budget |
| RES_AMOUNT_LC / RES_AMOUNT_FC (restricted measures) | CV_BASE_FIN_WEEKLY_BUDGET_S4 | ✓ Weekly_Budget_With_Calculated_Amount (CASE WHEN flag) |
| Summed_Measures (final aggregation + calculated _B631_S_AMOUNT) | CV_BASE_FIN_WEEKLY_BUDGET_S4 | ✓ Weekly_Budget_With_Calculated_Amount + WEEKLY_SNAPSHOT_DS05 |
| Projected_Profit_Center_Texts (CEPCT projection) | CV_BASE_MD_CEPCT_S4 | ✓ PROFIT_CENTER_TEXT |
| ZTSRP_COMPFL projection | CV_BASE_MD_COMPFL_S4 | ✓ Base_ZTSRP_COMPFL |
| Projected_HRRP_Node_Records | CV_BASE_MD_HRRP_NODE_S4 | ✓ HIER_NODE |
| ZTFIGL_RCALWEEK projection | CV_BASE_MD_RCALWEEK_S4 | ✓ CAL_WEEK |
| Filtered_Store_Profile_Attributes (ZTSRP_ATTR_ACT) | CV_BASE_MD_SRPACT_S4 | ✓ Base_ZTSRP_ATTR_ACT |
| TBL_WSS_SRP_COMPFLAG_FROM_STP (COMPFL procedure wrapper) | CV_COMP_MD_COMPFL_STATIC | ✓ Base_ZTSRP_COMPFL (inlined) |
| CV_COMP_MD_SRPACT_STATIC projection | CV_COMP_MD_SRPACT_STATIC | ✓ STORE_ATTR_ACTUAL |
| WEEKLY_SNAPSHOT_DS05 | CV_COMP_FIN_BUDGET_STATIC | ✓ WEEKLY_SNAPSHOT_DS05 |
| HIER_NODE (filtered) | CV_COMP_FIN_BUDGET_STATIC | ✓ HIER_NODE |
| ONLY_CORE_RET_DATA (inner join) | CV_COMP_FIN_BUDGET_STATIC | ✓ ONLY_CORE_RET_DATA |
| STORE_ATTR_ACTUAL (left join) | CV_COMP_FIN_BUDGET_STATIC | ✓ CORE_RET_WITH_STORE_ATTR |
| COMP_FLAG_BUDGET (left join) | CV_COMP_FIN_BUDGET_STATIC | ✓ COMP_FLAG_BUDGET + CORE_RET_WITH_COMP_FLAG |
| FLAGS (calculated columns + final aggregation) | CV_COMP_FIN_BUDGET_STATIC | ✓ FLAGS + final SELECT |

**All 19 CTE logic blocks found in consolidated file.** ✓

### Columns (COL) — Selected / Produced (Unique, Deduplicated)

The 67 unique columns tracked span all individual files. Key columns checked:

**CV_BASE_FIN_WEEKLY_BUDGET_S4:** FISCPER, FISCVARNT, _BIC_ZIO_SWEEK, FISCYEAR, FISCPER3, _B631_S_CHRTACCT, _B631_S_GL_ACCT, _B631_S_CO_AREA, _BIC_ZIO_CMPCD, _B631_S_PROFTCTR, _B631_S_COSTCNTR, _B631_S_FUNCAREA, _BIC_ZIO_VER, _BIC_ZIO_SAUDT, _BIC_ZWWPC_PA1, _BIC_ZWWSC_PA1, RECORDMODE, CURRENCY, _B631_S_AMOUNT, _BIC_ZIO_AMT, FLAG — **All Found** ✓

**CV_BASE_MD_CEPCT_S4:** MANDT, SPRAS, PRCTR, DATBI, KOKRS, KTEXT, LTEXT, MCTXT — MANDT ✓, PRCTR ✓, KTEXT (not used in consolidated — not in final output but not required), LTEXT ✓ (as profit_center_text), MCTXT (not in consolidated output — not required by consuming file), **SPRAS ABSENT ✗, DATBI ABSENT ✗, KOKRS ABSENT ✗**

**CV_BASE_MD_COMPFL_S4:** PRCTR, STRNUM, COMP_VER, ZWEEK, ZMONTH, ZYEAR, FS_COMP_PRE, RX_COMP_PRE, FS_COMP_MON, RX_COMP_MON, FS_COMP_WK, RX_COMP_WK — **All Found** ✓

**CV_BASE_MD_HRRP_NODE_S4:** HRYID, HRYVER, NODECLS, HRYNODE, PARNODE, HRYVALTO, HRYVALFROM, BALIND, NODETYPE, NODEVALUE — PARNODE ✓, HRYVALTO ✓, NODEVALUE ✓ (others not required by consuming file) ✓

**CV_BASE_MD_RCALWEEK_S4:** ZZWEEK, ZCALYRP, ZRYEAR, ZRPERIOD, ZRYRP, ZRYRQTR, ZRWSTRTDATE, ZRWENDDATE — ZZWEEK ✓, ZRWSTRTDATE ✓, ZRWENDDATE ✓ (others not required by consuming file) ✓

**CV_BASE_MD_SRPACT_S4:** All store attribute columns (STRNUM, PRCTR, REP_MKT_CODE, REP_MKT_DESC, EMERG_MKT_IND, DIVISION_CODE, DIVISION_DESC, AREA_CODE, AREA_DESC, DISTRICT_CODE, DISTRICT_DESC, REGION_CODE, REGION_DESC, CITY, STATE, FS_OPEN_DAT, RX_OPEN_DAT, RX_DIVISION_CODE, RX_AREA_CODE, RX_REGION_CODE, RX_DISTRICT_CODE, RX_HRS_OPER, FS_HRS_OPER, RX_STORE, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT) — **All Found** ✓

**CV_COMP_FIN_BUDGET_STATIC calculated columns:** CAL_FS_RX_FLAG → `cal_fs_rx_flag` ✓, CAL_COMP_FLAG → `cal_comp_flag` ✓, CAL_WEEK_NUMBER → `cal_week_number` ✓, _B631_S_AMOUNT (negated) → `b631_s_amount` ✓

### Filters (FLT) — Unique, Excluding Client/Env Filters

| # | Filter | Source File | Found / Missed |
|---|--------|-------------|----------------|
| 1 | `FISCVARNT = 'K4'` | CV_COMP_FIN_BUDGET_STATIC | Found ✓ |
| 2 | `_BIC_ZIO_SWEEK BETWEEN @IP_WEEK_ENDING_FROM AND @IP_WEEK_ENDING_TO` | CV_COMP_FIN_BUDGET_STATIC | **Missed (CHANGED)** |
| 3 | `_BIC_ZIO_VER = @IP_VERSION` (default `'LEDGER_BUD'`) | CV_COMP_FIN_BUDGET_STATIC | Found ✓ (hardcoded = default) |
| 4 | `_BIC_ZIO_SAUDT IN ('1', '10')` | CV_COMP_FIN_BUDGET_STATIC | Found ✓ |
| 5 | `REGEXP_CONTAINS(PARNODE, r'.*CORE_RET$')` | CV_COMP_FIN_BUDGET_STATIC | Found ✓ |
| 6 | `HRYVALTO = '99991231'` | CV_COMP_FIN_BUDGET_STATIC | Found ✓ (mapping confirms DATE type) |
| 7 | `COMP_VER = @IP_VERSION` | CV_COMP_FIN_BUDGET_STATIC | Found ✓ (hardcoded = default) |
| 8 | `MANDT IN ('110', '200')` on AZSRP_DS052 | CV_BASE_FIN_WEEKLY_BUDGET_S4 | **Missed (CHANGED — '110' → '120')** |
| 9 | `MANDT IN ('110', '200')` on AZSRP_DS041 | CV_BASE_FIN_WEEKLY_BUDGET_S4 | **Missed (CHANGED — '110' → '120')** |
| 10 | `@IP_FC_COUNT != '0'` (Frozen_Cube) | CV_BASE_FIN_WEEKLY_BUDGET_S4 | **Missed (CHANGED — param → subquery, type change)** |
| 11 | `@IP_FC_COUNT = '0'` (Live_Cube) | CV_BASE_FIN_WEEKLY_BUDGET_S4 | **Missed (CHANGED — param → subquery, type change)** |
| 12 | `ZWEEK = @V_WEEK` | CV_COMP_MD_COMPFL_STATIC | **Missed (CHANGED — param → subquery)** |

**Filters Found: 6 | Filters Missed: 6**
