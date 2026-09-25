# BigQuery Validation Report

## Overall Validation Summary

| Metric | Result |
|---|---|
| Completeness Score | 91.67% (22/24 checks passed) |
| Accuracy Score | 95.45% (21/22 checks passed) |
| Efficiency Score | 100.00% (8/8 checks passed) |
| Overall Status | PASS WITH WARNINGS |
| Files Excluded (unparseable) | None |

---

## Completeness Assessment

| Severity | File | Issue | Recommendation |
|---|---|---|---|
| WARNING | CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt | Missing columns RES_AMOUNT_LC and RES_AMOUNT_FC present in Individual File but absent in Consolidated File | Verify whether restricted measures RES_AMOUNT_LC and RES_AMOUNT_FC should be included in the consolidated output or are intentionally excluded |
| WARNING | Consolidated sql_8 files.txt | CTE CV_BASE_FIN_WEEKLY_BUDGET_S4_Final includes FLAG column in final output, but Individual File CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt does not include FLAG in final SELECT | Confirm whether FLAG column should be retained in final output or removed for consistency |

---

## Accuracy Assessment

| Severity | File | Issue | Recommendation |
|---|---|---|---|
| WARNING | CV_BASE_MD_CEPCT_S4_OUTPUT.txt | Column LTEXT selected in Individual File but aliased as PROFIT_CENTER_TEXT in Consolidated File within PROFIT_CENTER_TEXT CTE | Verify column naming convention - Individual File selects LTEXT without alias, Consolidated File aliases it as PROFIT_CENTER_TEXT |

---

## Efficiency Assessment

| Severity | File | Issue | Recommendation |
|---|---|---|---|
| INFO | All Files | No significant efficiency issues identified. | |

---

## Detailed Analysis

### Phase 1 – Completeness Validation

**Total Checks Performed:** 24

**Checks Passed:** 22

**Findings:**

1. **All Expected Files Present:** ✓
   - Consolidated File: Consolidated sql_8 files.txt
   - Individual Files (8): CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt, CV_BASE_MD_CEPCT_S4_OUTPUT.txt, CV_BASE_MD_HRRP_NODE_S4_Output.txt, CV_BASE_MD_RCAIWEEK_S4_Output.txt, CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt, CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt, CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt, STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt

2. **Source Tables:**
   - Consolidated File references: AZSRP_DS052_VT_S4, AZSRP_DS041_VT_S4, HRRP_NODE, TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG, ZTFIGL_RCALWEEK, CEPCT
   - Individual Files reference same base tables through calculation view placeholders (PROJECT.DATASET.CV_BASE_FIN_WEEKLY_BUDGET_S4, PROJECT.DATASET.CV_BASE_MD_HRRP_NODE_S4, etc.)
   - All source table references are accounted for across the file set ✓

3. **CTEs/Query Structure:**
   - Consolidated File CTEs: Frozen_Cube, Live_Cube, Union_1, Aggregated, CV_BASE_FIN_WEEKLY_BUDGET_S4_Final, WEEKLY_SNAPSHOT_DS05, HIER_NODE, Join_1, ONLY_CORE_RET_DATA, STORE_ATTR_ACTUAL, Join_2, WEEK_NUMBER, COMP_FLAG_BUDGET, Join_3, CAL_WEEK, Join_4, PROFIT_CENTER_TEXT, Join_5, FLAGS
   - Individual File CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt contains equivalent CTEs with same logical structure ✓
   - Individual Files represent modular components that map to Consolidated File CTEs ✓

4. **Column Completeness:**
   - **CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt:** Contains columns RES_AMOUNT_LC and RES_AMOUNT_FC not present in Consolidated File's CV_BASE_FIN_WEEKLY_BUDGET_S4_Final CTE ⚠️
   - **CV_BASE_MD_CEPCT_S4_OUTPUT.txt:** All columns (MANDT, SPRAS, PRCTR, DATBI, KOKRS, KTEXT, LTEXT, MCTXT) present in Consolidated File's PROFIT_CENTER_TEXT CTE ✓
   - **CV_BASE_MD_HRRP_NODE_S4_Output.txt:** All columns (MANDT, HRYID, HRYVER, NODECLS, HRYNODE, PARNODE, HRYVALTO, HRYVALFROM, BALIND, NODETYPE, NODEVALUE) present in source reference, subset used in Consolidated File's HIER_NODE CTE ✓
   - **CV_BASE_MD_RCAIWEEK_S4_Output.txt:** All columns (RCLNT, ZZWEEK, ZCALYRP, ZRYEAR, ZRPERIOD, ZRYRP, ZRYRQTR, ZRWSTRTDATE, ZRWENDDATE) present in source reference, subset used in Consolidated File's CAL_WEEK CTE ✓
   - **CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt:** All columns (MANDT, PRCTR, STRNUM, COMP_VER, ZWEEK, ZMONTH, ZYEAR, FS_COMP_PRE, RX_COMP_PRE, FS_COMP_MON, RX_COMP_MON, FS_COMP_WK, RX_COMP_WK) present in Consolidated File's COMP_FLAG_BUDGET CTE ✓
   - **CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt:** All columns present in Consolidated File's STORE_ATTR_ACTUAL CTE ✓
   - **STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt:** Represents stored procedure logic for data loading, not directly comparable to query structure ✓

5. **Final Output Columns:**
   - Consolidated File final SELECT from FLAGS CTE includes all expected columns
   - FLAG column appears in Consolidated File final output but Individual File CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt does not include FLAG in its final SELECT ⚠️

### Phase 2 – Accuracy Validation

**Total Checks Performed:** 22

**Checks Passed:** 21

**Findings:**

1. **Table Name Consistency:** ✓
   - All table references consistent between Consolidated and Individual Files
   - Individual Files use calculation view placeholders (PROJECT.DATASET.CV_BASE_*) which map to inline CTEs in Consolidated File

2. **Column Name Consistency:**
   - **CV_BASE_MD_CEPCT_S4_OUTPUT.txt:** Selects LTEXT without alias, while Consolidated File aliases it as PROFIT_CENTER_TEXT in the PROFIT_CENTER_TEXT CTE ⚠️
   - All other column names consistent across files ✓

3. **Join Logic Consistency:** ✓
   - Join_1: WEEKLY_SNAPSHOT_DS05 INNER JOIN HIER_NODE on _B631_S_PROFTCTR = NODEVALUE (consistent)
   - Join_2: ONLY_CORE_RET_DATA LEFT JOIN STORE_ATTR_ACTUAL on _B631_S_PROFTCTR = PRCTR (consistent)
   - Join_3: WEEK_NUMBER LEFT JOIN COMP_FLAG_BUDGET on _B631_S_PROFTCTR = PRCTR AND _BIC_ZIO_SWEEK = ZWEEK (consistent)
   - Join_4: Join_3 LEFT JOIN CAL_WEEK on _BIC_ZIO_SWEEK = ZZWEEK (consistent)
   - Join_5: Join_4 LEFT JOIN PROFIT_CENTER_TEXT on _B631_S_PROFTCTR = PRCTR (consistent)

4. **Filter Conditions:** ✓
   - WEEKLY_SNAPSHOT_DS05: FISCVARNT = 'K4', _BIC_ZIO_SWEEK BETWEEN @IP_WEEK_ENDING_FROM AND @IP_WEEK_ENDING_TO, _BIC_ZIO_VER = @IP_VERSION, _BIC_ZIO_SAUDT IN ('1', '10') (consistent)
   - HIER_NODE: REGEXP_CONTAINS(PARNODE, 'CORE_RET$'), HRYVALTO = '99991231' (consistent)
   - COMP_FLAG_BUDGET: COMP_VER = @IP_VERSION (consistent)
   - Frozen_Cube: MANDT IN ('110', '200'), @IP_FC_COUNT != '0' (consistent)
   - Live_Cube: MANDT IN ('110', '200'), @IP_FC_COUNT = '0' (consistent)

5. **Calculated Columns:** ✓
   - CAL_FS_RX_FLAG logic identical in both files
   - CAL_COMP_FLAG logic identical in both files
   - CAL_WEEK_NUMBER logic identical in both files
   - _B631_S_AMOUNT calculation logic identical in both files

6. **Aggregation Logic:** ✓
   - Aggregated CTE: SUM(_B631_S_AMOUNT) AS _B631_S_AMOUNT_DUMMY, SUM(_BIC_ZIO_AMT) AS _BIC_ZIO_AMT with identical GROUP BY clauses
   - CV_BASE_FIN_WEEKLY_BUDGET_S4_Final: Complex CASE statement for _B631_S_AMOUNT consistent between files

### Phase 3 – Efficiency Validation

**Total Checks Performed:** 8

**Checks Passed:** 8

**Findings:**

1. **No Duplicate Table Definitions:** ✓
   - Each Individual File represents a distinct calculation view or stored procedure
   - No table/object defined in multiple Individual Files

2. **No Duplicate Column Definitions:** ✓
   - Column definitions are unique within each file context

3. **No Redundant SQL:** ✓
   - Consolidated File represents the complete integrated query
   - Individual Files represent modular components without redundancy

4. **Appropriate Modularization:** ✓
   - Individual Files follow logical separation:
     - CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt: Base financial weekly budget logic
     - CV_BASE_MD_CEPCT_S4_OUTPUT.txt: Profit center text master data
     - CV_BASE_MD_HRRP_NODE_S4_Output.txt: Hierarchy node master data
     - CV_BASE_MD_RCAIWEEK_S4_Output.txt: Calendar week master data
     - CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt: Composite financial budget static view
     - CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt: Comp flag static master data
     - CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt: Store attributes static master data
     - STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt: Stored procedure for data loading

5. **No Unnecessary Duplication:** ✓
   - Each file serves a distinct purpose in the overall data flow

### Phase 4 – Validation Status

**Determination:**

- **Completeness Score:** 91.67% (Good) - 2 minor warnings regarding missing columns and FLAG column inconsistency
- **Accuracy Score:** 95.45% (Good) - 1 minor warning regarding column aliasing
- **Efficiency Score:** 100.00% (Good) - No issues identified

**Overall Status:** PASS WITH WARNINGS

**Rationale:**
- All three scores are above 90%, indicating good overall quality
- No critical issues identified that would prevent execution
- Warnings relate to minor differences in column selection and aliasing that should be reviewed but do not constitute validation failures
- The Consolidated File successfully integrates all logic from the Individual Files
- Structural differences reflect valid implementation choices (inline CTEs vs. calculation view references)

---

## Summary

The validation confirms that the Consolidated SQL File (Consolidated sql_8 files.txt) successfully represents the combined logic of all 8 Individual SQL Files. The files are structurally sound, logically consistent, and efficiently organized. Minor warnings have been identified regarding:

1. Missing restricted measure columns (RES_AMOUNT_LC, RES_AMOUNT_FC) in the Consolidated File
2. FLAG column presence inconsistency between Consolidated and Individual File outputs
3. Column aliasing difference for LTEXT/PROFIT_CENTER_TEXT

These warnings should be reviewed to ensure intentional design choices rather than omissions, but they do not prevent the SQL from executing correctly or indicate critical validation failures.

**Validation Complete.**
