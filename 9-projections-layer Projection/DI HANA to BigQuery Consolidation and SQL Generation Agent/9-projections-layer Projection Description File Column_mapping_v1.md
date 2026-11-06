# Consolidation Description
## 9-projections-layer Projection — CV_COMP_FIN_FLASH
### DI HANA to BigQuery Consolidation and SQL Generation Agent

---

## 1. Inputs Read

| Input | Status | Details |
|---|---|---|
| 9-projections-layer Relationships Table | ✅ Read | 8 lineage rows |
| 9-projections-layer Converted Bigquery | ✅ Read | 1 converted SQL file: CV_COMP_FIN_FLASH (9-projections-layer.xml) |
| Columns_Mapping_v3.csv | ✅ Read (full) | Tables present: CEPCT, ZTFIGL_RCALWEEK, ZTSRP_COMPFL, ZTSRP_ATTR_ACT, HRRP_NODE, AZSRP_DS041_VT_S4, AZSRP_DS052_VT_S4, AZSRP_DS112_VT_S4, AZSRP_DS072_VT_S4, AZSRP_DS092_VT_S4, AZSRP_DS031_VT_S4, ACDOCA_VT_S4, BKPF, FAGLSKF_PN, FINSC_FISC_DATE |

---

## 2. Final Consumer Identification

**Final Consumer:** `CV_COMP_FIN_FLASH` — defined in `9-projections-layer.xml` within the `CVS_FRIP.Composite.FI` package.

This is a SAP HANA Calculation View that serves as the consumer-facing projection artifact. It reads from nine upstream Calculation Views, applies joins, filters, a multi-step calculation chain, and produces a row-level output (no dataCategory="CUBE" or outputViewType="Aggregation" confirmed in the XML).

---

## 3. Artifact Dependency Mapping

### Lineage Rows Read (8 total):

| Source File | Target File | Dependency Type | Resulting SQL Location |
|---|---|---|---|
| CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK | 9-projections-layer.xml | Calculation View Dependency | CTE 1–9 filter placeholder (UNRESOLVED — no converted SQL supplied) |
| CV_COMP_FIN_FLASH_STATIC | 9-projections-layer.xml | Calculation View Dependency | CTE 1: Flash_Static |
| CV_COMP_FIN_BUDGET_STATIC | 9-projections-layer.xml | Calculation View Dependency | CTE 2: Budget_Static (main), CTE 7: Budget_Static_Comp (second reference) |
| CV_COMP_SKF_BUDGET_STATIC | 9-projections-layer.xml | Calculation View Dependency | CTE 3: SKF_Budget_Static |
| CV_COMP_FORECAST_MJE_STATIC | 9-projections-layer.xml | Calculation View Dependency | CTE 4: Forecast_MJE_Static |
| CV_COMP_FIN_ACTUAL_STATIC | 9-projections-layer.xml | Calculation View Dependency | CTE 5: Actual_Static |
| CV_COMP_SKF_ACTUAL_STATIC | 9-projections-layer.xml | Calculation View Dependency | CTE 6: SKF_Actual_Static |
| CV_COMP_TOPSIDE_ADJUSTMENTS | 9-projections-layer.xml | Calculation View Dependency | CTE 8: Topside_Adjustments_FS, CTE 9: Topside_Adjustments_RX (two references) |

---

## 4. File Classification

| File | Classification | Reason |
|---|---|---|
| CV_COMP_FIN_FLASH (9-projections-layer.xml) | **USED** | Final consumer artifact. Its converted BigQuery SQL defines the complete transformation flow. |

**No files classified as NOT USED.** Only one converted SQL file was supplied.

---

## 5. Dependency Expansion and Point-of-Consumption Mapping

The nine upstream Calculation Views are consumed in the following order within the final-consumer flow:

1. **Flash_Static (CTE 1)** — CV_COMP_FIN_FLASH_STATIC: provides dimension columns and flash measure columns (FS_SALESAMOUNT, RX_SALESAMOUNT, REDUCTIONAMOUNT, EMP_REDUCTIONAMOUNT, CAL_SCRIPTS_90AS3_CAR).
2. **Budget_Static (CTE 2)** — CV_COMP_FIN_BUDGET_STATIC (first reference): provides FIN_BUDGET_AMOUNT, RX_BUDGET.
3. **SKF_Budget_Static (CTE 3)** — CV_COMP_SKF_BUDGET_STATIC: provides SKF_BUDGET_QTY, SKF_FCST_QTY.
4. **Forecast_MJE_Static (CTE 4)** — CV_COMP_FORECAST_MJE_STATIC: provides CAL_FS_SALES_MJE, CAL_RX_SALES_MJE, SBT, SKF_MJE_QTY, FIN_FCST_AMOUNT.
5. **Actual_Static (CTE 5)** — CV_COMP_FIN_ACTUAL_STATIC: provides FIN_LY_AMOUNT.
6. **SKF_Actual_Static (CTE 6)** — CV_COMP_SKF_ACTUAL_STATIC: provides SKF_LY_QTY.
7. **Budget_Static_Comp (CTE 7)** — CV_COMP_FIN_BUDGET_STATIC (second reference): provides comp-level budget data (CAL_RX_BUDGET_COMP_LEVEL — UNRESOLVED).
8. **Topside_Adjustments_FS (CTE 8)** — CV_COMP_TOPSIDE_ADJUSTMENTS (first reference): provides TOPSIDE_FS_AMOUNT (column name UNRESOLVED).
9. **Topside_Adjustments_RX (CTE 9)** — CV_COMP_TOPSIDE_ADJUSTMENTS (second reference): provides TOPSIDE_RX_AMOUNT (column name UNRESOLVED).

All nine are joined in **CTE 10: Joined_Source_Data**. No converted SQL files were supplied for any of the upstream views; they remain as named references with placeholder BigQuery paths.

---

## 6. Final-Consumer Flow / Order

The consolidated SQL follows the exact transformation sequence from the converted XML:

| Step | CTE | Logic |
|---|---|---|
| 1–9 | Flash_Static … Topside_Adjustments_RX | Source reads with parameter filters |
| 10 | Joined_Source_Data | Multi-source join |
| 11 | FILTER_Segment | SEGMENT IS NULL OR UPPER(SEGMENT)='CONVDRUG' |
| 12 | Projected_Base_Calculations | Step A: CAL_FS_SALES, CAL_RX_SALES, CAL_SCRIPTS_90AS3; FS-based variances |
| 13 | Projected_Extended_Calculations | Step B/C: extended variances, comp-flag columns, initial ASP chain |
| 14 | Projected_ASP_Calculations | Step D: CAL_ASP_CHANGE_PERCT |
| 15 | Projected_ASP_Adj | Step D: CAL_ASP_ADJ_AMOUNT |
| 16 | Projected_RX_Budget | Step E: CAL_RX_BUDGET derivation |
| 17 | Projected_RX_Budget_Final | Step F: CAL_RX_BUDGET_FINAL, CAL_COMP_RX_BUDGET |
| 18 | Projected_RX_Budget_Variance | CAL_RX_BUDGET_VAR |
| 19 | Final_Output | Logical model: formatted dates/timestamps, CAL_COMP_FLAG, COMP_LABEL, EMERG_MKT_IND_LABEL, all comp-store variance measures |

---

## 7. Filter Trace

| Filter | Source File | Resulting SQL Clause |
|---|---|---|
| SEGMENT IS NULL OR UPPER(SEGMENT)='CONVDRUG' | 9-projections-layer.xml (node-level filter) | CTE 11: FILTER_Segment WHERE clause |
| (CAL_RX_BUDGET=0) OR isnull(CAL_RX_BUDGET) — gates ASP-based budget derivation | 9-projections-layer.xml (node-level filter) | CTE 16: Projected_RX_Budget — represented as the IF(RX_BUDGET=0 OR RX_BUDGET IS NULL, ...) expression |
| (NOT isNull(BUDGET_COMP_FLAG)) AND ((RX_BUDGET=0) OR isnull(RX_BUDGET)) — gates comp-level PRCTR derivation | 9-projections-layer.xml (node-level filter) | CTE 17: Projected_RX_Budget_Final — represented in the IF(PRCTR IN (...) AND BUDGET_COMP_FLAG IN ('0','1'), ...) expression |
| IP_WEEK_ENDING_FROM / IP_WEEK_ENDING_TO parameter filters on all source views | 9-projections-layer.xml (variableMapping section) | CTEs 1–9: WHERE TRUE placeholder — UNRESOLVED (actual filter logic depends on source view definitions) |
| SFN_PRIOR_FISCAL_WEEK filter on source views | 9-projections-layer.xml (variableMapping section) | CTEs 1–9: WHERE TRUE placeholder — UNRESOLVED (function definition not supplied) |

---

## 8. Join Trace

| Join | Source File | Resulting SQL Clause |
|---|---|---|
| Flash_Static LEFT JOIN Budget_Static | 9-projections-layer.xml (join node) | CTE 10: Joined_Source_Data — ON TRUE placeholder (UNRESOLVED) |
| Flash_Static LEFT JOIN SKF_Budget_Static | 9-projections-layer.xml (join node) | CTE 10: Joined_Source_Data — ON TRUE placeholder (UNRESOLVED) |
| Flash_Static LEFT JOIN Forecast_MJE_Static | 9-projections-layer.xml (join node) | CTE 10: Joined_Source_Data — ON TRUE placeholder (UNRESOLVED) |
| Flash_Static LEFT JOIN Actual_Static | 9-projections-layer.xml (join node) | CTE 10: Joined_Source_Data — ON TRUE placeholder (UNRESOLVED) |
| Flash_Static LEFT JOIN SKF_Actual_Static | 9-projections-layer.xml (join node) | CTE 10: Joined_Source_Data — ON TRUE placeholder (UNRESOLVED) |
| Flash_Static LEFT JOIN Budget_Static_Comp | 9-projections-layer.xml (join node) | CTE 10: Joined_Source_Data — ON TRUE placeholder (UNRESOLVED) |
| Flash_Static LEFT JOIN Topside_Adjustments_FS | 9-projections-layer.xml (join node) | CTE 10: Joined_Source_Data — ON TRUE placeholder (UNRESOLVED) |
| Flash_Static LEFT JOIN Topside_Adjustments_RX | 9-projections-layer.xml (join node) | CTE 10: Joined_Source_Data — ON TRUE placeholder (UNRESOLVED) |

**All join types and join key columns are UNRESOLVED from the XML.** The XML join nodes list projected columns but do not expose join type or key columns in the parsed text content.

---

## 9. Calculation Trace

| Calculated Column | Source File | Resulting SQL Clause |
|---|---|---|
| CAL_FS_SALES = FS_SALESAMOUNT - REDUCTIONAMOUNT - EMP_REDUCTIONAMOUNT + CAL_FS_SALES_MJE + SBT | 9-projections-layer.xml | CTE 12: Projected_Base_Calculations |
| CAL_RX_SALES = RX_SALESAMOUNT + CAL_RX_SALES_MJE | 9-projections-layer.xml | CTE 12: Projected_Base_Calculations |
| CAL_SCRIPTS_90AS3 = CAL_SCRIPTS_90AS3_CAR + SKF_MJE_QTY | 9-projections-layer.xml | CTE 12: Projected_Base_Calculations |
| CAL_FS_BUDGET_VAR, CAL_FS_FCST_VAR, CAL_FS_LY_VAR | 9-projections-layer.xml | CTE 12: Projected_Base_Calculations |
| CAL_FS_SALES_BUDGET_VAR, CAL_FS_SALES_FCST_VAR, CAL_FS_SALES_LY_VAR | 9-projections-layer.xml | CTE 13: Projected_Extended_Calculations |
| CAL_RX_FCST_VAR, CAL_RX_LY_VAR | 9-projections-layer.xml | CTE 13: Projected_Extended_Calculations |
| CAL_SCRIPTS_FCST_VAR, CAL_SCRIPTS_BUDGET_VAR, CAL_SCRIPTS_LY_VAR | 9-projections-layer.xml | CTE 13: Projected_Extended_Calculations |
| CAL_COMP_BUDGET_AMOUNT, CAL_COMP_FS_SALES, CAL_COMP_FS_SALESAMOUNT, CAL_COMP_RX_SALES, CAL_COMP_BUDGET_QTY, CAL_COMP_SCRIPTS, CAL_COMP_FCST_AMOUNT, CAL_COMP_FCST_QTY, CAL_COMP_LY_AMOUNT, CAL_COMP_LY_QTY | 9-projections-layer.xml | CTE 13: Projected_Extended_Calculations |
| CAL_TOTAL_BUDGET_ASP, CAL_STORE_FLASH_ASP, CAL_TOTAL_FLASH_ASP | 9-projections-layer.xml | CTE 13: Projected_Extended_Calculations |
| CAL_ASP_CHANGE_PERCT | 9-projections-layer.xml | CTE 14: Projected_ASP_Calculations |
| CAL_ASP_ADJ_AMOUNT | 9-projections-layer.xml | CTE 15: Projected_ASP_Adj |
| CAL_RX_BUDGET | 9-projections-layer.xml | CTE 16: Projected_RX_Budget |
| PRCTR_DERIVED, CAL_RX_BUDGET_FINAL, CAL_COMP_RX_BUDGET | 9-projections-layer.xml | CTE 17: Projected_RX_Budget_Final |
| CAL_RX_BUDGET_VAR | 9-projections-layer.xml | CTE 18: Projected_RX_Budget_Variance |
| CAL_COMP_FLAG, COMP_LABEL, EMERG_MKT_IND_LABEL | 9-projections-layer.xml | CTE 19: Final_Output |
| ZRWSTRTDATE_FMT, ZRWENDDATE_FMT, FS_OPEN_DAT_FMT, RX_OPEN_DAT_FMT | 9-projections-layer.xml | CTE 19: Final_Output |
| FS_UPD_TIMESTAMP_FMT, RX_UPD_TIMESTAMP_FMT | 9-projections-layer.xml | CTE 19: Final_Output |
| CAL_COMP_FS_VAR_BUDGET, CAL_COMP_FS_VAR_FCST, CAL_COMP_FS_VAR_LY | 9-projections-layer.xml | CTE 19: Final_Output |
| CAL_COMP_RX_VAR_BUDGET, CAL_COMP_RX_VAR_FCST, CAL_COMP_RX_VAR_LY | 9-projections-layer.xml | CTE 19: Final_Output |
| CAL_COMP_FLASH_VAR_FCST, CAL_COMP_FLASH_VAR_BUDGET, CAL_COMP_FLASH_VAR_LY | 9-projections-layer.xml | CTE 19: Final_Output — UNRESOLVED approximation |
| CAL_COMP_CORPFS_VAR_BUDGET, CAL_COMP_CORPFS_VAR_FCST, CAL_COMP_CORPFS_VAR_LY | 9-projections-layer.xml | CTE 19: Final_Output — UNRESOLVED approximation |

---

## 10. Parameter Documentation

| Parameter | Type | Source | Usage | Reason Unresolved |
|---|---|---|---|---|
| @ip_week_ending_from | STRING (assumed) | 9-projections-layer.xml variableMapping section | Passed as PLACEHOLDER to all nine source Calculation Views to filter to fiscal week range start | Source view definitions not supplied; actual filter logic unknown |
| @ip_week_ending_to | STRING (assumed) | 9-projections-layer.xml variableMapping section | Passed as PLACEHOLDER to all nine source Calculation Views to filter to fiscal week range end | Source view definitions not supplied; actual filter logic unknown |

**Note:** DECLARE/SET statements from the original converted SQL have been removed. Both parameters are represented as `@ip_week_ending_from` and `@ip_week_ending_to` runtime parameters. Their actual data types must be confirmed against the source view definitions.

---

## 11. Alias Check Results

The source Calculation Views (CV_COMP_FIN_FLASH_STATIC, CV_COMP_FIN_BUDGET_STATIC, etc.) are **not present in Columns_Mapping_v3.csv** as physical tables. They are intermediate HANA Calculation Views. Therefore:

- **No physical column mappings can be applied** to the output columns of the nine source CTEs (CTEs 1–9) or to the columns flowing through the join (CTE 10).
- All column names in the consolidated SQL retain their HANA/converted-SQL names as-is, because no BQ_COLUMN mapping exists for these intermediate views.
- The Columns_Mapping_v3.csv contains mappings for physical SAP tables (CEPCT, ZTFIGL_RCALWEEK, ZTSRP_COMPFL, ZTSRP_ATTR_ACT, HRRP_NODE, AZSRP_DS041_VT_S4, AZSRP_DS052_VT_S4, AZSRP_DS112_VT_S4, AZSRP_DS072_VT_S4, AZSRP_DS092_VT_S4, AZSRP_DS031_VT_S4, ACDOCA_VT_S4, BKPF, FAGLSKF_PN, FINSC_FISC_DATE) — none of which are terminal sources in the expanded SQL of CV_COMP_FIN_FLASH.
- The terminal sources in the consolidated SQL are the nine Calculation Views, which are not physical tables and have no entries in the CSV.

**Alias check result:** No redundant HANA-name aliases were introduced. Calculated column aliases follow the converted SQL naming. No BigQuery-style rename violations were introduced beyond what the converted SQL defines.

---

## 12. Table and Column Mapping Applied

**Physical table mapping:** None applicable. The nine source Calculation Views referenced in the consolidated SQL are not physical SAP tables and do not appear in Columns_Mapping_v3.csv. Their BigQuery equivalents (project, dataset, table/view names) are UNRESOLVED.

**Column mapping:** No column-level mappings from Columns_Mapping_v3.csv were applied, because no terminal physical source tables from the CSV appear in the dependency chain of CV_COMP_FIN_FLASH. All column names flow from the intermediate Calculation Views whose definitions were not supplied.

**Type casts applied (from converted SQL logic):**
- `CAST(ZRWSTRTDATE_SAP AS STRING)` — applied before PARSE_DATE in Final_Output; data type of source column UNRESOLVED (assumed YYYYMMDD integer or string).
- `CAST(ZRWENDDATE_SAP AS STRING)` — same as above.
- `CAST(FS_OPEN_DAT_SAP AS STRING)` — same as above.
- `CAST(RX_OPEN_DAT_SAP AS STRING)` — same as above.
- `CAST(FS_UPD_TIMESTAMP_SAP AS STRING)` — applied before SUBSTR in Final_Output; data type UNRESOLVED (assumed 14-digit YYYYMMDDHHMMSS numeric).
- `CAST(RX_UPD_TIMESTAMP_SAP AS STRING)` — same as above.

---

## 13. CTE / Helper Mapping

| CTE | Type | Justification |
|---|---|---|
| Flash_Static (1) | Source read | Required separate CTE: distinct source view with parameter filter |
| Budget_Static (2) | Source read | Required separate CTE: distinct source view with parameter filter |
| SKF_Budget_Static (3) | Source read | Required separate CTE: distinct source view with parameter filter |
| Forecast_MJE_Static (4) | Source read | Required separate CTE: distinct source view with parameter filter |
| Actual_Static (5) | Source read | Required separate CTE: distinct source view with parameter filter |
| SKF_Actual_Static (6) | Source read | Required separate CTE: distinct source view with parameter filter |
| Budget_Static_Comp (7) | Source read | Required separate CTE: second reference to CV_COMP_FIN_BUDGET_STATIC (comp-level) |
| Topside_Adjustments_FS (8) | Source read | Required separate CTE: first reference to CV_COMP_TOPSIDE_ADJUSTMENTS (FS) |
| Topside_Adjustments_RX (9) | Source read | Required separate CTE: second reference to CV_COMP_TOPSIDE_ADJUSTMENTS (RX) |
| Joined_Source_Data (10) | Join | Required: multi-source join of all nine views |
| FILTER_Segment (11) | Filter | Required: node-level SEGMENT filter must be applied after join, before calculations |
| Projected_Base_Calculations (12) | Calculation | Required: Step A base calculations needed by downstream CTEs |
| Projected_Extended_Calculations (13) | Calculation | Required: extended variances and comp-flag columns depend on Step A outputs |
| Projected_ASP_Calculations (14) | Calculation | Required: CAL_ASP_CHANGE_PERCT depends on CAL_TOTAL_FLASH_ASP and CAL_TOTAL_BUDGET_ASP from CTE 13 |
| Projected_ASP_Adj (15) | Calculation | Required: CAL_ASP_ADJ_AMOUNT depends on CAL_ASP_CHANGE_PERCT from CTE 14 |
| Projected_RX_Budget (16) | Calculation | Required: CAL_RX_BUDGET depends on CAL_ASP_ADJ_AMOUNT from CTE 15 |
| Projected_RX_Budget_Final (17) | Calculation | Required: CAL_RX_BUDGET_FINAL and CAL_COMP_RX_BUDGET depend on CAL_RX_BUDGET from CTE 16 |
| Projected_RX_Budget_Variance (18) | Calculation | Required: CAL_RX_BUDGET_VAR depends on CAL_RX_BUDGET from CTE 17 |
| Final_Output (19) | Logical model | Required: final output layer with formatted dates, labels, and comp-store variance measures |

All CTEs are justified by real semantic boundaries (evaluation order dependencies, filter placement, or multi-step calculation chains). No CTE was created merely to mirror a HANA node.

---

## 14. Aggregation Validation

The view does **not** have `dataCategory="CUBE"` or `outputViewType="Aggregation"` confirmed in the XML. The final output is treated as a **row-level projection view** — no GROUP BY aggregation is applied at the final SELECT level. This is consistent with the converted SQL.

---

## 15. Star Projection Validation

`SELECT *` is used in:
- CTEs 1–9 (source reads): valid — input schema is deterministically known from the source view, no duplicate columns introduced at this stage, and no explicit column list is available without the source view definitions.
- CTEs 14–18 (intermediate calculations): valid — each adds exactly one new calculated column to the full pass-through of the parent CTE's schema; no duplicate aliases are introduced within each SELECT.
- Final SELECT: `SELECT * FROM Final_Output` — valid; Final_Output CTE explicitly projects all required output columns with no duplicates.

---

## 16. Procedure / ETL Handling

No stored procedures, INSERT-SELECT, CREATE TABLE AS SELECT, or MERGE statements were present in the supplied converted SQL. Not applicable.

---

## 17. HANA Function Conversions Applied

| HANA Function | BigQuery Equivalent | Applied In |
|---|---|---|
| IF(condition, true, false) | IF(condition, true, false) | CTEs 12–19 |
| ISNULL(col) | col IS NULL | CTEs 16–17 |
| ROUND(val, n) | ROUND(val, n) | CTEs 13–17 |
| IN(col, val1, val2) | col IN (val1, val2) | CTE 17 |
| UPPER(col) | UPPER(col) | CTE 11 |
| COALESCE(col, default) | COALESCE(col, default) | CTE 19 |
| max(coalesce(...), coalesce(...)) scalar | GREATEST(COALESCE(...), COALESCE(...)) | CTE 19 |
| CASE(col, val1, r1, val2, r2, default) | CASE col WHEN val1 THEN r1 ... ELSE default END | CTE 19 |
| format(date(col), 'MM/DD/YYYY') | FORMAT_DATE('%m/%d/%Y', PARSE_DATE('%Y%m%d', CAST(col AS STRING))) | CTE 19 |
| STRING(col) | CAST(col AS STRING) | CTE 19 |
| LEFTSTR(str, n) | SUBSTR(str, 1, n) | CTE 19 |
| MIDSTR(str, pos, len) | SUBSTR(str, pos, len) | CTE 19 |
| RIGHTSTR(str, n) | RIGHT(str, n) | CTE 19 |

---

## 18. Duplicate / Ambiguous Column Validation

- Each CTE's SELECT was inspected for duplicate aliases.
- No duplicate aliases were found within any single SELECT.
- PRCTR_DERIVED is computed in CTE 17 but is not projected to the Final_Output SELECT (it is an internal calculation used only within that CTE's logic).
- CAL_COMP_FLAG is computed in CTE 19's SELECT using an inline expression (not referencing a prior CTE column named CAL_COMP_FLAG), so no ambiguity exists.

---

## 19. Quality Gate Results

| Gate | Result |
|---|---|
| 1. Final consumer unambiguous | PASS — CV_COMP_FIN_FLASH (9-projections-layer.xml) |
| 2. Artifact dependencies match Relationships Table | PASS — all 8 lineage rows represented |
| 3. Final-consumer transformation order preserved | PASS — 19 CTEs follow exact XML node sequence |
| 4. Dependencies expanded at point of consumption | PASS — all nine source views consumed in CTE 10 |
| 5. No generic Source to Intermediate to Target ordering inferred | PASS |
| 6. Every file classified USED or NOT USED | PASS — 1 file: USED |
| 7. Every USED file participates in dependency chain | PASS |
| 8. All converted dependencies expanded | PARTIAL — nine upstream Calculation View converted SQL files were not supplied; they remain as named references |
| 9. Only terminal sources remain | PARTIAL — nine source Calculation Views remain as named references (no converted SQL to inline) |
| 10. Every physical source uses BQ_FULL_TABLE name | ISSUES TO FIX — nine source views have UNRESOLVED BQ paths (PROJECT.DATASET.* placeholders) |
| 11. Every referenced physical-source column mapped via Columns_Mapping_v3 | ISSUES TO FIX — nine source views not in CSV; no physical column mappings applicable |
| 12. Type comparisons consistent | PASS for logic visible in converted SQL; UNRESOLVED for source view columns |
| 13. Final-consumer functional CTE names and order preserved | PASS |
| 14. Compatible steps combined | PASS — no unnecessary CTE splitting |
| 15. No HANA node becomes a separate CTE merely to mirror source structure | PASS |
| 16. Every helper CTE justified by real semantic boundary | PASS |
| 17. Every CTE matches required output contract | PASS for logic visible in converted SQL |
| 18. Every column reference qualified where multiple inputs in scope | PASS — CTE 10 qualifies all columns with source aliases |
| 19. No duplicate alias within any SELECT | PASS |
| 20. Every retained star projection valid | PASS |
| 21. Filters, joins, calculations, mappings, parameters preserved | PASS for logic visible in converted SQL; UNRESOLVED items documented |
| 22. Every aggregation stage preserves required grain | PASS — row-level projection, no aggregation |
| 23. DISTINCT, UNION, window behavior preserved | PASS — none present |
| 24. No conflict silently corrected | PASS — all conflicts documented |
| 25. No result-affecting procedural behavior discarded | PASS — no procedures present |
| 26. Runtime parameters documented; single query with no DECLARE/SET | PASS |
| 27. Every CTE has standardized comment header | PASS |
| 28. CTE comments describe consolidated logic without causing extra CTE creation | PASS |
| 29. Complete query achieves 100% logic match using minimum CTE structure | PARTIAL — 100% of visible logic preserved; unresolved items block full validation |
| 30. Every lineage edge represented by correct supplied logic | ISSUES TO FIX — see below |
| 31. Every filter, join, aggregation, UNION, parameter traced to output SQL | PARTIAL — all visible logic traced; unresolved items documented |
| 32. Every physical-column output uses exact BQ_COLUMN | ISSUES TO FIX — source views not in CSV; no BQ_COLUMN mappings available |

---

## 20. ISSUES TO FIX

> **This SQL is NOT production-ready.** The following unresolved items must be addressed before execution.

### Issue 1 — UNRESOLVED: Source Calculation View BigQuery Paths (HIGH PRIORITY)
- **Affected artifacts:** All nine source CTEs (CTEs 1–9)
- **Evidence:** Converted SQL uses PROJECT.DATASET.view_name placeholders; source view definitions not supplied; none appear in Columns_Mapping_v3.csv
- **Impact:** SQL cannot execute without actual BigQuery project, dataset, and table/view names
- **Resolution needed:** Provide actual BQ_FULL_TABLE paths for all nine source Calculation Views

### Issue 2 — UNRESOLVED: Join Types and Join Key Columns (HIGH PRIORITY)
- **Affected artifact:** CTE 10: Joined_Source_Data
- **Evidence:** XML join nodes list projected columns but do not expose join type or key columns in parsed text; converted SQL uses LEFT JOIN with ON TRUE placeholder
- **Impact:** Incorrect join type or missing join keys will produce wrong results (cross joins or incorrect row counts)
- **Resolution needed:** Validate actual join types (INNER/LEFT/RIGHT/FULL) and join key columns from the HANA model

### Issue 3 — UNRESOLVED: SFN_PRIOR_FISCAL_WEEK Scalar Function Filter
- **Affected artifact:** CTEs 1–9 (filter conditions)
- **Evidence:** Function CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK referenced in variableMapping section; definition not supplied
- **Impact:** Filter logic using this function is missing from all source CTEs
- **Resolution needed:** Supply the function definition or its BigQuery equivalent logic

### Issue 4 — UNRESOLVED: CAL_RX_BUDGET_COMP_LEVEL Source Column
- **Affected artifact:** CTE 17: Projected_RX_Budget_Final
- **Evidence:** Column referenced in formula CAL_RX_BUDGET_FINAL = RX_BUDGET - CAL_RX_BUDGET_COMP_LEVEL; source not defined in XML; likely from Budget_Static_Comp but unconfirmed
- **Impact:** CAL_RX_BUDGET_FINAL and CAL_COMP_RX_BUDGET calculations are incorrect until this column is resolved
- **Resolution needed:** Identify the source column and table for CAL_RX_BUDGET_COMP_LEVEL; confirm it comes from Budget_Static_Comp

### Issue 5 — UNRESOLVED: Comp-Store Variance Source Columns
- **Affected artifact:** CTE 19: Final_Output
- **Evidence:** XML references CAL_COMP_FLASH_90AS3, CAL_COMP_FORECAST_90AS3, CAL_COMP_BUDGET_90AS3, CAL_COMP_LY_90AS3, CAL_COMP_CORPFS_SALES_AMOUNT, CAL_COMP_RX_BUDGET_AMOUNT, CAL_COMP_RX_SALESAMOUNT, CAL_COMP_FS_BUDGET_AMOUNT, CAL_COMP_FORECAST_AMOUNT; derivation nodes not visible in XML
- **Impact:** CAL_COMP_FLASH_VAR_FCST, CAL_COMP_FLASH_VAR_BUDGET, CAL_COMP_FLASH_VAR_LY, CAL_COMP_CORPFS_VAR_BUDGET, CAL_COMP_CORPFS_VAR_FCST, CAL_COMP_CORPFS_VAR_LY use closest available approximations, not the exact source columns
- **Resolution needed:** Identify derivation of all nine unresolved comp-store variance source columns

### Issue 6 — UNRESOLVED: Topside Adjustment Column Names
- **Affected artifact:** CTE 10: Joined_Source_Data
- **Evidence:** Actual column names from CV_COMP_TOPSIDE_ADJUSTMENTS that feed TOPSIDE_FS_AMOUNT and TOPSIDE_RX_AMOUNT are unknown
- **Impact:** Column references TOPSIDE_FS_AMOUNT and TOPSIDE_RX_AMOUNT are placeholders
- **Resolution needed:** Supply actual column names from CV_COMP_TOPSIDE_ADJUSTMENTS

### Issue 7 — REQUIRES VALIDATION: CAL_TOTAL_BUDGET_ASP Circular Dependency
- **Affected artifact:** CTE 13: Projected_Extended_Calculations
- **Evidence:** In HANA, CAL_TOTAL_BUDGET_ASP = IF(SKF_BUDGET_QTY=0, 0, ROUND(CAL_RX_BUDGET/SKF_BUDGET_QTY, 2)), but CAL_RX_BUDGET depends on CAL_ASP_ADJ_AMOUNT which depends on CAL_ASP_CHANGE_PERCT which depends on CAL_TOTAL_BUDGET_ASP. BigQuery conversion uses RX_BUDGET (raw) as proxy.
- **Impact:** CAL_TOTAL_BUDGET_ASP may differ from HANA result if the HANA node execution order resolves this differently
- **Resolution needed:** Validate actual HANA node execution order for CAL_TOTAL_BUDGET_ASP

### Issue 8 — UNRESOLVED: Date/Timestamp Column Data Types
- **Affected artifact:** CTE 19: Final_Output
- **Evidence:** ZRWSTRTDATE_SAP, ZRWENDDATE_SAP, FS_OPEN_DAT_SAP, RX_OPEN_DAT_SAP, FS_UPD_TIMESTAMP_SAP, RX_UPD_TIMESTAMP_SAP — data types not in Columns_Mapping_v3.csv (columns come from source Calculation Views, not physical tables)
- **Impact:** CAST and PARSE_DATE wrappers may be incorrect if columns are already DATE or STRING type
- **Resolution needed:** Confirm data types of these columns in the source Calculation Views

### Issue 9 — UNRESOLVED: Input Parameter Data Types
- **Affected artifacts:** CTEs 1–9 (filter conditions)
- **Evidence:** IP_WEEK_ENDING_FROM and IP_WEEK_ENDING_TO declared as STRING in converted SQL; actual types not specified in XML
- **Impact:** Parameter type mismatch may cause filter errors
- **Resolution needed:** Confirm actual data types of IP_WEEK_ENDING_FROM and IP_WEEK_ENDING_TO

### Issue 10 — UNRESOLVED: Measure Column Source Assignments in Join
- **Affected artifact:** CTE 10: Joined_Source_Data
- **Evidence:** Without source view definitions, the exact source view and column for each measure (FIN_BUDGET_AMOUNT, FIN_FCST_AMOUNT, FIN_LY_AMOUNT, SKF_BUDGET_QTY, SKF_FCST_QTY, SKF_LY_QTY, CAL_FS_SALES_MJE, CAL_RX_SALES_MJE, SBT, SKF_MJE_QTY, REDUCTIONAMOUNT, EMP_REDUCTIONAMOUNT, CAL_SCRIPTS_90AS3_CAR, RX_BUDGET) cannot be confirmed
- **Impact:** Column source assignments in Joined_Source_Data may be incorrect
- **Resolution needed:** Validate measure column source assignments against actual source view output contracts

---

*This consolidation was produced from the supplied inputs only. No logic was invented. All unresolved items are documented above.*
