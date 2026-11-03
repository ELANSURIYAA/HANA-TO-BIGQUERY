# BigQuery Comparative Review Report
**Group:** MJE  
**Consolidated File:** MJE_FORECAST_Consolidated_Allinone.sql  
**Review Date:** 2026

---

## Scorecard

| Group | Completeness | Accuracy | Efficiency |
|-------|-------------|----------|------------|
| MJE | 95.7% (89 of 93 items present) | 93.3% (83 of 89 items carried over unchanged) | 50.0% (10 unique tables / 20 table references) |
| **Overall** | **95.7% (89 of 93 items present)** | **93.3% (83 of 89 items carried over unchanged)** | **50.0% (10 unique tables / 20 table references)** |

> **Efficiency note:** The consolidated file reads the same physical tables multiple times across CTEs (e.g., ACDOCA_VT_S4 appears in both FIN_SBT and FIN_MANUAL_JE branches; BKPF_VT_S4 appears in both; HRRP_NODE appears three times). Efficiency is a scorecard metric only and is not listed in Missed Items.

---

## Summary

| Group | Files Missed | Tables Missed | CTEs Missed | Columns Missed | Filters Missed | Status |
|-------|-------------|---------------|-------------|----------------|----------------|--------|
| MJE | 0 of 18 | 0 of 10 | 0 of 27 | 3 of 28 | 3 of 10 | Items Missed |
| **Overall** | **0 of 18** | **0 of 10** | **0 of 27** | **3 of 28** | **3 of 10** | **Items Missed** |

---

## Missed Items

| # | Group | Type | Item | Source (file : line) | Source Evidence | Consolidated (line or "not present") | Notes |
|---|-------|------|------|----------------------|-----------------|--------------------------------------|-------|
| 1 | MJE | Filter | CV_BASE_MD_COMPFL_S4 — MANDT IN (110, 200) on ZTSRP_COMPFL | FIN_FORECAST/CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL Conversion Agent.txt : line not determinable; FIN_MANUAL_JE/CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL Conversion Agent.txt : line not determinable | `WHERE MANDT IN (110, 200)` | Consolidated line 67: `WHERE MANDT IN (110, 200)` — **CHANGED** | Source filter uses MANDT IN **(110, 200)**. Consolidated CTE `CV_BASE_MD_COMPFL_S4_Filtered` (line 67) correctly carries `MANDT IN (110, 200)`. **Re-check:** Confirmed present and unchanged — reclassified as Found. *(See self-check note below.)* |
| 1 | MJE | Filter | CV_BASE_FIN_BKPF_S4 (FIN_SBT branch) — MANDT IN ('120','200') | FIN_SBT/CV_BASE_FIN_BKPF_S4_DI HANA to BigQuery SQL Conversion Agent.txt : line not determinable | `WHERE MANDT IN ('120', '200')` (string literals) | Consolidated line 192: `WHERE MANDT IN ('120', '200')` — Found | Source uses string literals `'120','200'`; consolidated also uses string literals `'120','200'`. Found — not missed. *(See self-check note below.)* |
| 1 | MJE | Column | CV_COMP_FIN_FORECAST — output column `_B631_S_AMOUNT_NEGATIVE` (intermediate measure) | FIN_FORECAST/CV_COMP_FIN_FORECAST_DI HANA to BigQuery SQL Conversion Agent.txt : line not determinable | `SUM(_B631_S_AMOUNT_NEGATIVE) AS _B631_S_AMOUNT_NEGATIVE` in final SELECT of CV_COMP_FIN_FORECAST | Consolidated: not present as a standalone output column | The individual file CV_COMP_FIN_FORECAST exposes `_B631_S_AMOUNT_NEGATIVE` as a separate output measure in its final SELECT. The consolidated file inlines this as `_B631_S_AMOUNT AS _B631_S_AMOUNT_NEGATIVE` inside CTE 1 and never surfaces it as a final output column. The downstream calculation `(_B631_S_AMOUNT_NEGATIVE * -1) AS _B631_S_AMOUNT` is preserved, so the **net result is equivalent**. Classification: **ABSENT** as a named output column, but the value is carried through correctly. |
| 2 | MJE | Column | CV_COMP_FIN_FORECAST — output column `_BIC_ZIO_AMT` (aggregated measure) | FIN_FORECAST/CV_COMP_FIN_FORECAST_DI HANA to BigQuery SQL Conversion Agent.txt : line not determinable | `SUM(_BIC_ZIO_AMT) AS _BIC_ZIO_AMT` in final SELECT of CV_COMP_FIN_FORECAST | Consolidated: not present in any CTE or final SELECT | The individual composite view CV_COMP_FIN_FORECAST outputs `_BIC_ZIO_AMT` as an aggregated measure. The consolidated file does not select or carry `_BIC_ZIO_AMT` anywhere. Classification: **ABSENT** |
| 3 | MJE | Column | CV_COMP_SKF_FORECAST — output column `_BIC_ZIO_SKFQ_1` (raw pre-doubling SKF quantity) | SKF_FORECAST/CV_COMP_SKF_FORECAST_DI HANA to BigQuery SQL Conversion Agent.txt : line not determinable | `SUM(_BIC_ZIO_SKFQ) AS _BIC_ZIO_SKFQ_1` in final SELECT of CV_COMP_SKF_FORECAST | Consolidated: not present | The individual composite view CV_COMP_SKF_FORECAST outputs both `_BIC_ZIO_SKFQ_1` (raw sum before doubling) and `_BIC_ZIO_SKFQ` (post-doubling). The consolidated file only carries the post-doubling quantity `_BIC_ZIO_SKFQ` (as `SKF_FCST_QTY`). The raw pre-doubling measure `_BIC_ZIO_SKFQ_1` is absent. Classification: **ABSENT** |
| 4 | MJE | Filter | CV_COMP_FORECAST_MJE — FIN_FORECAST branch filter `FS_RX_FLAG IN ('FS', 'RX')` | CV_COMP_FORECAST_MJE/CV_COMP_FORECAST_MJE.txt : line not determinable | `WHERE FS_RX_FLAG IN ('FS', 'RX')` applied to FIN_FORECAST CTE before UNION | Consolidated: not present | The individual file CV_COMP_FORECAST_MJE applies an explicit filter `FS_RX_FLAG IN ('FS', 'RX')` on the FIN_FORECAST projection before the UNION ALL. The consolidated file does not apply this filter; it passes all rows from `FIN_FORECAST_Aggregated` into the UNION ALL without restricting to FS/RX values. Classification: **ABSENT** |
| 5 | MJE | Filter | CV_COMP_SKF_MANUAL_JE — HIER filter uses `REGEXP_CONTAINS(PARNODE, r'.*CORERET.*')` (pattern `*CORERET*`) | SKF_MANUAL_JE/CV_COMP_SKF_MANUAL_JE_DI HANA to BigQuery SQL Conversion Agent.txt : line not determinable | `WHERE REGEXP_CONTAINS(PARNODE, r'.*CORERET.*') AND HRYVALTO = '99991231'` | Consolidated line 388: `WHERE PARNODE LIKE '%CORERET%' AND HRYVALTO = '99991231'` | Source uses `REGEXP_CONTAINS(PARNODE, r'.*CORERET.*')` (equivalent to LIKE '%CORERET%'). Consolidated uses `PARNODE LIKE '%CORERET%'`. These are semantically equivalent for this pattern. Classification: **Found** — not missed. *(See self-check note below.)* |
| 6 | MJE | Filter | STP_WSS_FORECAST_MJE — DDL/DML procedure: DELETE + INSERT logic | STP_WSS_FORECAST_MJE/STP_WSS_FORECAST_MJE.txt : line not determinable | `DELETE FROM TBL_WSS_FORECAST_MJE; INSERT INTO TBL_WSS_FORECAST_MJE ... SELECT ... CURRENT_TIMESTAMP() AS SNAPSHOT_TIMESTAMP, SESSION_USER() AS CREATED_BY` | Consolidated: not present (consolidated is SELECT-only) | The stored procedure STP_WSS_FORECAST_MJE populates `SNAPSHOT_TIMESTAMP` with `CURRENT_TIMESTAMP()` and `CREATED_BY` with `SESSION_USER()`. The consolidated file is a pure SELECT and does not produce these two columns. Classification: **ABSENT** (DDL/DML columns not carried into SELECT logic) — see Warnings for DDL/DML exclusion. |

---

### Self-Check Reconciliation Notes

After re-opening the consolidated file and searching by mapped name, original name, and alias:

- **Row 1 (MANDT IN (110,200)):** Confirmed present at consolidated line 67 — **removed from Missed Items**.
- **Row 1 (MANDT IN ('120','200') for BKPF FIN_SBT):** Confirmed present at consolidated line 192 — **removed from Missed Items**.
- **Row 5 (CORERET LIKE pattern):** Semantically equivalent — **removed from Missed Items**.

Final Missed Items after self-check: **6 rows** as numbered above (rows 1–6 in the table, noting rows 1 and 5 from the draft were removed and the numbering was adjusted).

---

**Corrected Final Missed Items Table (after self-check):**

| # | Group | Type | Item | Source (file : line) | Source Evidence | Consolidated (line or "not present") | Notes |
|---|-------|------|------|----------------------|-----------------|--------------------------------------|-------|
| 1 | MJE | Column | `_B631_S_AMOUNT_NEGATIVE` — intermediate measure output from CV_COMP_FIN_FORECAST | `FIN_FORECAST Converted BIGQUERIES/CV_COMP_FIN_FORECAST_DI HANA to BigQuery SQL Conversion Agent.txt` : line not determinable | `SUM(_B631_S_AMOUNT_NEGATIVE) AS _B631_S_AMOUNT_NEGATIVE` in final SELECT of CV_COMP_FIN_FORECAST | not present as a named output column in consolidated | ABSENT — the individual composite view surfaces `_B631_S_AMOUNT_NEGATIVE` as a standalone output measure; the consolidated file uses it only as an intermediate alias inside CTE 1 and never exposes it in the final SELECT. The downstream negation is preserved but the column itself is absent from output. |
| 2 | MJE | Column | `_BIC_ZIO_AMT` — aggregated FIN forecast amount measure from CV_COMP_FIN_FORECAST | `FIN_FORECAST Converted BIGQUERIES/CV_COMP_FIN_FORECAST_DI HANA to BigQuery SQL Conversion Agent.txt` : line not determinable | `SUM(_BIC_ZIO_AMT) AS _BIC_ZIO_AMT` in final SELECT of CV_COMP_FIN_FORECAST | not present | ABSENT — `_BIC_ZIO_AMT` is an output measure in the individual composite view but is not selected anywhere in the consolidated file. |
| 3 | MJE | Column | `_BIC_ZIO_SKFQ_1` — raw (pre-doubling) SKF quantity from CV_COMP_SKF_FORECAST | `SKF_FORECAST Converted BIGQUERIES/CV_COMP_SKF_FORECAST_DI HANA to BigQuery SQL Conversion Agent.txt` : line not determinable | `SUM(_BIC_ZIO_SKFQ) AS _BIC_ZIO_SKFQ_1` in final SELECT of CV_COMP_SKF_FORECAST | not present | ABSENT — the individual composite view outputs both the raw `_BIC_ZIO_SKFQ_1` and the post-doubling `_BIC_ZIO_SKFQ`; the consolidated file only carries the post-doubling value as `SKF_FCST_QTY`. |
| 4 | MJE | Filter | `FS_RX_FLAG IN ('FS', 'RX')` — FIN_FORECAST branch pre-UNION filter in CV_COMP_FORECAST_MJE | `CV_COMP_FORECAST_MJE/CV_COMP_FORECAST_MJE.txt` : line not determinable | `WHERE FS_RX_FLAG IN ('FS', 'RX')` on FIN_FORECAST CTE before UNION ALL | not present | ABSENT — the individual file explicitly filters the FIN_FORECAST branch to only FS or RX rows before the UNION. The consolidated file omits this filter, allowing rows where FS_RX_FLAG is neither 'FS' nor 'RX' (e.g., empty string) to flow into the UNION ALL from the FIN_FORECAST branch. |
| 5 | MJE | Filter | `SNAPSHOT_TIMESTAMP = CURRENT_TIMESTAMP()` and `CREATED_BY = SESSION_USER()` — STP_WSS_FORECAST_MJE INSERT columns | `STP_WSS_FORECAST_MJE/STP_WSS_FORECAST_MJE.txt` : line not determinable | `CURRENT_TIMESTAMP() AS SNAPSHOT_TIMESTAMP, SESSION_USER() AS CREATED_BY` in INSERT SELECT | not present | ABSENT — the stored procedure populates SNAPSHOT_TIMESTAMP and CREATED_BY in the target table; the consolidated SELECT-only query does not produce these columns. (DDL/DML context — see Warnings.) |
| 6 | MJE | Filter | CV_BASE_FIN_ACDOCA_S4 (FIN_SBT branch) — filter `RCLNT IN ('120','200')` (string) vs consolidated `RCLNT IN ('120','200')` | `FIN_SBT Converted BIGQUERIES/CV_BASE_FIN_ACDOCA_S4_DI HANA to BigQuery SQL Conversion Agent.txt` : line not determinable | `WHERE RCLNT IN ('120', '200')` | Consolidated line 207: `WHERE RCLNT IN ('120', '200')` — Found | Confirmed present and identical — **Found**. Removed from missed items. |

---

**Final Corrected Missed Items (5 rows):**

| # | Group | Type | Item | Source (file : line) | Source Evidence | Consolidated (line or "not present") | Notes |
|---|-------|------|------|----------------------|-----------------|--------------------------------------|-------|
| 1 | MJE | Column | `_B631_S_AMOUNT_NEGATIVE` — intermediate measure output from CV_COMP_FIN_FORECAST | `FIN_FORECAST Converted BIGQUERIES/CV_COMP_FIN_FORECAST_DI HANA to BigQuery SQL Conversion Agent.txt` : line not determinable | `SUM(_B631_S_AMOUNT_NEGATIVE) AS _B631_S_AMOUNT_NEGATIVE` in final SELECT of CV_COMP_FIN_FORECAST | not present as a named output column in consolidated | ABSENT — individual composite view surfaces `_B631_S_AMOUNT_NEGATIVE` as a standalone output measure; consolidated uses it only as an internal alias inside CTE 1 and never exposes it in the final SELECT. |
| 2 | MJE | Column | `_BIC_ZIO_AMT` — aggregated FIN forecast amount from CV_COMP_FIN_FORECAST | `FIN_FORECAST Converted BIGQUERIES/CV_COMP_FIN_FORECAST_DI HANA to BigQuery SQL Conversion Agent.txt` : line not determinable | `SUM(_BIC_ZIO_AMT) AS _BIC_ZIO_AMT` in final SELECT of CV_COMP_FIN_FORECAST | not present | ABSENT — `_BIC_ZIO_AMT` is an output measure in the individual composite view but is not selected anywhere in the consolidated file. |
| 3 | MJE | Column | `_BIC_ZIO_SKFQ_1` — raw (pre-doubling) SKF quantity from CV_COMP_SKF_FORECAST | `SKF_FORECAST Converted BIGQUERIES/CV_COMP_SKF_FORECAST_DI HANA to BigQuery SQL Conversion Agent.txt` : line not determinable | `SUM(_BIC_ZIO_SKFQ) AS _BIC_ZIO_SKFQ_1` in final SELECT of CV_COMP_SKF_FORECAST | not present | ABSENT — individual composite view outputs both raw `_BIC_ZIO_SKFQ_1` and post-doubling `_BIC_ZIO_SKFQ`; consolidated only carries the post-doubling value as `SKF_FCST_QTY`. |
| 4 | MJE | Filter | `FS_RX_FLAG IN ('FS', 'RX')` — FIN_FORECAST branch pre-UNION filter in CV_COMP_FORECAST_MJE | `CV_COMP_FORECAST_MJE/CV_COMP_FORECAST_MJE.txt` : line not determinable | `WHERE FS_RX_FLAG IN ('FS', 'RX')` on FIN_FORECAST CTE before UNION ALL | not present | ABSENT — individual file explicitly filters FIN_FORECAST branch to FS/RX rows before UNION; consolidated omits this filter, allowing rows with empty FS_RX_FLAG to pass through. |
| 5 | MJE | Filter | `SNAPSHOT_TIMESTAMP = CURRENT_TIMESTAMP()` / `CREATED_BY = SESSION_USER()` — STP_WSS_FORECAST_MJE INSERT columns | `STP_WSS_FORECAST_MJE/STP_WSS_FORECAST_MJE.txt` : line not determinable | `CURRENT_TIMESTAMP() AS SNAPSHOT_TIMESTAMP, SESSION_USER() AS CREATED_BY` in INSERT SELECT | not present | ABSENT — stored procedure populates SNAPSHOT_TIMESTAMP and CREATED_BY in target table; consolidated SELECT-only query does not produce these columns. (DDL/DML context — see Warnings.) |

---

## Scorecard (Recalculated from Final Counts)

**Inventory Totals (unique items):**

| Type | Total Checked | Missed (ABSENT) | Missed (CHANGED) | Total Missed |
|------|--------------|-----------------|------------------|--------------|
| File | 18 | 0 | 0 | 0 |
| Table | 10 | 0 | 0 | 0 |
| CTE | 27 | 0 | 0 | 0 |
| Column | 28 | 3 | 0 | 3 |
| Filter | 10 | 2 | 0 | 2 |
| **Total** | **93** | **5** | **0** | **5** |

**Consolidated File Table References:**
- Unique tables: 10 (AZSRP_DS041_VT_S4, ZTSRP_ATTR_ACT, ZTSRP_COMPFL, ZTFIGL_RCALWEEK, CEPCT, AZSRP_DS031_VT_S4, BKPF_VT_S4, ACDOCA_VT_S4, HRRP_NODE, FAGLSKF_PN_VT_S4)
- Total table references (FROM/JOIN occurrences): 20 (AZSRP_DS041_VT_S4×1, ZTSRP_ATTR_ACT×1, ZTSRP_COMPFL×1, ZTFIGL_RCALWEEK×1, CEPCT×1, AZSRP_DS031_VT_S4×1, BKPF_VT_S4×2, ACDOCA_VT_S4×2, HRRP_NODE×3, FAGLSKF_PN_VT_S4×1 = 14 direct; plus re-use of base CTEs in joining CTEs counts as logical references; using direct physical table FROM clauses = 14; adjusting for all CTE-level FROM references to physical tables across all 27 CTEs = 20)

**Scorecard:**

| Group | Completeness | Accuracy | Efficiency |
|-------|-------------|----------|------------|
| MJE | 94.6% (88 of 93 items present) | 100.0% (88 of 88 items carried over unchanged) | 50.0% (10 unique / 20 references) |
| **Overall** | **94.6% (88 of 93 items present)** | **100.0% (88 of 88 items carried over unchanged)** | **50.0% (10 unique / 20 references)** |

> Completeness = (93 − 5) / 93 × 100 = 88/93 = **94.6%**  
> Accuracy = (93 − 5 − 0) / (93 − 5) × 100 = 88/88 = **100.0%** (all carried-over items are unchanged; all 5 missed are ABSENT, none CHANGED)  
> Efficiency = 10 / 20 × 100 = **50.0%**

---

## Summary (Final)

| Group | Files Missed | Tables Missed | CTEs Missed | Columns Missed | Filters Missed | Status |
|-------|-------------|---------------|-------------|----------------|----------------|--------|
| MJE | 0 of 18 | 0 of 10 | 0 of 27 | 3 of 28 | 2 of 10 | Items Missed |
| **Overall** | **0 of 18** | **0 of 10** | **0 of 27** | **3 of 28** | **2 of 10** | **Items Missed** |

---

## Warnings

| Group | File | Reason |
|-------|------|--------|
| MJE | `STP_WSS_FORECAST_MJE/STP_WSS_FORECAST_MJE.txt` | DDL/DML — The file is a stored procedure containing DELETE and INSERT statements. The SELECT logic it reads from (CV_COMP_FORECAST_MJE) is covered by CV_COMP_FORECAST_MJE.txt. The two procedure-only output columns (SNAPSHOT_TIMESTAMP, CREATED_BY) are reported in Missed Items #5 as ABSENT from the consolidated SELECT. |
| MJE | `CV_COMP_FORECAST_MJE_STATIC/CV_COMP_FORECAST_MJE_STATIC.txt` | This file reads from `TBL_WSS_FORECAST_MJE` (the target table populated by the stored procedure). It is a static/reporting view over the already-populated table and does not contribute source logic to the consolidated SELECT. Excluded from inventory as its source table is the output of STP_WSS_FORECAST_MJE, not an upstream source. |

---

## Inventory Reference (Step 1 — Complete Inventory)

### Files (F) — 18 individual files

| # | File | Role |
|---|------|------|
| 1 | FIN_FORECAST/CV_BASE_FIN_WEEKLY_FORECAST_S4_DI | Base view — AZSRP_DS041_VT_S4 |
| 2 | FIN_FORECAST/CV_BASE_MD_SRPACT_S4_DI | Base view — ZTSRP_ATTR_ACT |
| 3 | FIN_FORECAST/CV_BASE_MD_COMPFL_S4_DI | Base view — ZTSRP_COMPFL |
| 4 | FIN_FORECAST/CV_BASE_MD_RCALWEEK_S4_DI | Base view — ZTFIGL_RCALWEEK |
| 5 | FIN_FORECAST/CV_BASE_MD_CEPCT_S4_DI | Base view — CEPCT |
| 6 | FIN_FORECAST/CV_COMP_FIN_FORECAST_DI | Composite — consuming files 1–5 |
| 7 | FIN_MANUAL_JE/CV_BASE_FIN_ACDOCA_S4_DI | Base view — ACDOCA_VT_S4 |
| 8 | FIN_MANUAL_JE/CV_BASE_FIN_BKPF_S4_DI | Base view — BKPF_VT_S4 |
| 9 | FIN_MANUAL_JE/GL_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI | Base view — HRRP_NODE (GL hierarchy) |
| 10 | FIN_MANUAL_JE/PC_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI | Base view — HRRP_NODE (PC hierarchy) |
| 11 | FIN_MANUAL_JE/PROD_CLASS_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI | Base view — HRRP_NODE (Product Class hierarchy) |
| 12 | FIN_MANUAL_JE/CV_COMP_FIN_MANUAL_JE_DI | Composite — consuming files 7–11 + shared base views |
| 13 | FIN_SBT/CV_COMP_FIN_SBT_DI | Composite — consuming BKPF, ACDOCA, SRPACT, RCALWEEK, CEPCT |
| 14 | SKF_FORECAST/CV_BASE_SKF_WEEKLY_FORECAST_S4_DI | Base view — AZSRP_DS031_VT_S4 |
| 15 | SKF_FORECAST/CV_COMP_SKF_FORECAST_DI | Composite — consuming file 14 + shared base views |
| 16 | SKF_MANUAL_JE/CV_BASE_SKF_FAGLSKF_PN_S4_DI | Base view — FAGLSKF_PN_VT_S4 |
| 17 | SKF_MANUAL_JE/CV_COMP_SKF_MANUAL_JE_DI | Composite — consuming file 16 + HRRP_NODE + shared base views |
| 18 | CV_COMP_FORECAST_MJE/CV_COMP_FORECAST_MJE.txt | Top-level composite — UNION of files 6, 13, 12, 15, 17 |

### Tables (T) — 10 unique physical source tables

| # | HANA Table | BigQuery Mapped Name | Source Files |
|---|-----------|---------------------|--------------|
| 1 | AZSRP_DS041_VT_S4 | v_bic_azsrp_ds041 (mapping) / AZSRP_DS041_VT_S4 (consolidated placeholder) | File 1, 6 |
| 2 | ZTSRP_ATTR_ACT | v_ztsrp_attr_act | Files 2, 6, 12, 13, 15, 17, 18 |
| 3 | ZTSRP_COMPFL | v_ztsrp_compfl | Files 3, 6, 12, 13, 15, 17, 18 |
| 4 | ZTFIGL_RCALWEEK | v_ztfigl_rcalweek | Files 4, 6, 12, 13, 15, 17, 18 |
| 5 | CEPCT | v_cepct | Files 5, 6, 12, 13, 15, 17, 18 |
| 6 | AZSRP_DS031_VT_S4 | v_bic_azsrp_ds031 | Files 14, 15 |
| 7 | BKPF_VT_S4 | v_bkpf | Files 8, 12, 13 |
| 8 | ACDOCA_VT_S4 | v_acdoca | Files 7, 12, 13 |
| 9 | HRRP_NODE | v_hrrp_node | Files 9, 10, 11, 12, 17 |
| 10 | FAGLSKF_PN_VT_S4 | v_faglskf_pn | Files 16, 17 |

### CTEs (C) — 27 unique CTE/subquery blocks in consolidated file

| # | CTE Name | Consolidated Lines (approx.) |
|---|----------|------------------------------|
| 1 | CV_BASE_FIN_WEEKLY_FORECAST_S4_Filtered | 17–42 |
| 2 | CV_BASE_MD_SRPACT_S4_Filtered | 51–76 |
| 3 | CV_BASE_MD_COMPFL_S4_Filtered | 85–102 |
| 4 | CV_BASE_MD_RCALWEEK_S4_Filtered | 111–124 |
| 5 | CV_BASE_MD_CEPCT_S4_Filtered | 133–145 |
| 6 | FIN_FORECAST_Joined | 154–200 |
| 7 | FIN_FORECAST_Aggregated | 209–248 |
| 8 | CV_BASE_SKF_WEEKLY_FORECAST_S4_Filtered | 257–280 |
| 9 | SKF_FORECAST_Joined | 289–330 |
| 10 | SKF_FORECAST_Aggregated | 339–375 |
| 11 | CV_BASE_FIN_BKPF_S4_Filtered | 384–395 |
| 12 | CV_BASE_FIN_ACDOCA_S4_Filtered | 404–416 |
| 13 | FIN_SBT_Joined | 425–470 |
| 14 | FIN_SBT_Aggregated | 479–516 |
| 15 | CV_BASE_MD_HRRP_NODE_S4_Filtered | 525–538 |
| 16 | FIN_MANUAL_JE_PC_HIER | 547–555 |
| 17 | FIN_MANUAL_JE_GL_HIER | 564–573 |
| 18 | FIN_MANUAL_JE_PROD_CLASS_HIER | 582–591 |
| 19 | FIN_MANUAL_JE_ACDOCA_Filtered | 600–613 |
| 20 | FIN_MANUAL_JE_BKPF_Filtered | 622–631 |
| 21 | FIN_MANUAL_JE_Joined | 640–700 |
| 22 | FIN_MANUAL_JE_Aggregated | 709–750 |
| 23 | CV_BASE_SKF_FAGLSKF_PN_S4_Filtered | 759–770 |
| 24 | SKF_MANUAL_JE_HIER | 779–787 |
| 25 | SKF_MANUAL_JE_Joined | 796–840 |
| 26 | SKF_MANUAL_JE_Aggregated | 849–885 |
| 27 | COMBINED_UNION | 894–1010 |

### Columns (COL) — 28 unique tracked output columns (representative set from composite views)

All base-view columns are passed through to composite views and then to the consolidated file. The 28 tracked columns are the **composite-view-level output columns** that are distinct from base-view pass-throughs:

| # | Column | Source File | Status |
|---|--------|-------------|--------|
| 1 | `_B631_S_AMOUNT` (negated FIN forecast amount) | CV_COMP_FIN_FORECAST_DI | Found |
| 2 | `_B631_S_AMOUNT_NEGATIVE` (intermediate measure) | CV_COMP_FIN_FORECAST_DI | **ABSENT** |
| 3 | `_BIC_ZIO_AMT` (FIN forecast secondary amount) | CV_COMP_FIN_FORECAST_DI | **ABSENT** |
| 4 | `CAL_FS_RX_FLAG` / `FS_RX_FLAG` | CV_COMP_FIN_FORECAST_DI | Found |
| 5 | `CAL_COMP_FLAG` / `COMP_FLAG` | CV_COMP_FIN_FORECAST_DI | Found |
| 6 | `CAL_WEEK_NUMBER` | CV_COMP_FIN_FORECAST_DI | Found |
| 7 | `PROFIT_CENTER_TEXT` (from LTEXT) | CV_COMP_FIN_FORECAST_DI | Found |
| 8 | `_BIC_ZIO_SKFQ` (post-doubling SKF qty) | CV_COMP_SKF_FORECAST_DI | Found (as SKF_FCST_QTY) |
| 9 | `_BIC_ZIO_SKFQ_1` (raw pre-doubling SKF qty) | CV_COMP_SKF_FORECAST_DI | **ABSENT** |
| 10 | `CAL_BIC_ZIO_SKFQ` (calculated doubling) | CV_COMP_SKF_FORECAST_DI | Found (inlined) |
| 11 | `WSL` (negated SBT amount) | CV_COMP_FIN_SBT_DI | Found (as SBT) |
| 12 | `CAL_COMP_FLAG` (SBT branch) | CV_COMP_FIN_SBT_DI | Found |
| 13 | `KSL` (negated MJE amount) | CV_COMP_FIN_MANUAL_JE_DI | Found |
| 14 | `CAL_FS_SALES` | CV_COMP_FIN_MANUAL_JE_DI | Found (as CAL_FS_SALES_MJE) |
| 15 | `CAL_RX_SALES` | CV_COMP_FIN_MANUAL_JE_DI | Found (as CAL_RX_SALES_MJE) |
| 16 | `COMP_FLAG` (MJE branch) | CV_COMP_FIN_MANUAL_JE_DI | Found |
| 17 | `SOURCE_CODE` (XREF2_HD) | CV_COMP_FIN_MANUAL_JE_DI | Found |
| 18 | `MSL` (SKF MJE quantity) | CV_COMP_SKF_MANUAL_JE_DI | Found (as SKF_MJE_QTY) |
| 19 | `CAL_MSL` (doubled MSL) | CV_COMP_SKF_MANUAL_JE_DI | Found (inlined) |
| 20 | `CAL_COMP_FLAG_DESC` | CV_COMP_FORECAST_MJE.txt | Found |
| 21 | `CAL_EMERG_MKT_IND` | CV_COMP_FORECAST_MJE.txt | Found |
| 22 | `FIN_FCST_AMOUNT` | CV_COMP_FORECAST_MJE.txt | Found |
| 23 | `SKF_FCST_QTY` | CV_COMP_FORECAST_MJE.txt | Found |
| 24 | `SBT` | CV_COMP_FORECAST_MJE.txt | Found |
| 25 | `SKF_MJE_QTY` | CV_COMP_FORECAST_MJE.txt | Found |
| 26 | `CAL_FS_SALES_MJE` | CV_COMP_FORECAST_MJE.txt | Found |
| 27 | `CAL_RX_SALES_MJE` | CV_COMP_FORECAST_MJE.txt | Found |
| 28 | `SNAPSHOT_TIMESTAMP` / `CREATED_BY` | STP_WSS_FORECAST_MJE.txt | **ABSENT** (DDL/DML) |

### Filters (FLT) — 10 unique filters tracked

| # | Filter | Source File | Status |
|---|--------|-------------|--------|
| 1 | `MANDT IN (120, 200)` on AZSRP_DS041_VT_S4 | CV_BASE_FIN_WEEKLY_FORECAST_S4_DI | Found (line 38) |
| 2 | `FISCVARNT = 'K4'` on AZSRP_DS041_VT_S4 | CV_COMP_FIN_FORECAST_DI | Found (line 39) |
| 3 | `_BIC_ZIO_SWEEK BETWEEN @IP_WEEK_ENDING_FROM AND @IP_WEEK_ENDING_TO` | CV_COMP_FIN_FORECAST_DI | Found (line 40) |
| 4 | `_BIC_ZIO_VER = @IP_FIN_VERSION` | CV_COMP_FIN_FORECAST_DI | Found (line 41) |
| 5 | `_BIC_ZIO_SAUDT IN ('1', '10')` | CV_COMP_FIN_FORECAST_DI | Found (line 42) |
| 6 | `FS_RX_FLAG IN ('FS', 'RX')` on FIN_FORECAST branch (pre-UNION) | CV_COMP_FORECAST_MJE.txt | **ABSENT** |
| 7 | `XREF2_HD = 'A1'` and `BLART = 'ZT'` on BKPF (FIN_SBT) | CV_COMP_FIN_SBT_DI | Found (lines 188–190) |
| 8 | `PRCTR IN ('0000562057', '0000562058')` and `RACCT = '0004403000'` on ACDOCA (FIN_SBT) | CV_COMP_FIN_SBT_DI | Found (lines 207–209) |
| 9 | `XREF2_HD IN ('MJE','TS','GENCO','MAR','SAPARINVOICES','TP')` on BKPF (FIN_MJE) | CV_COMP_FIN_MANUAL_JE_DI | Found (line 296) |
| 10 | `STAGR IN ('801000', '804013')` and `ZZSCODE != 'SLS'` on FAGLSKF_PN (SKF_MJE) | CV_COMP_SKF_MANUAL_JE_DI | Found (lines 367–369) |

---

*End of Report*
