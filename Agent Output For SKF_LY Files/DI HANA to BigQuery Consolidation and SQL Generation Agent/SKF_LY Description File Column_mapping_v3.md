# CONSOLIDATION DESCRIPTION: CV_COMP_SKF_ACTUAL_STATIC

## 1. FINAL CONSUMER IDENTIFICATION

**Final Consumer Artifact:** CV_COMP_SKF_ACTUAL_STATIC  
**Artifact Type:** HANA Calculation View (CUBE with Aggregation)  
**Purpose:** Weekly store-level SKF (Store Keeping Fee) actual data consolidated with store attributes, cost center hierarchy, retail calendar, comp flags, and profit center text.

---

## 2. ARTIFACT DEPENDENCY MAPPING

Based on `SKF_LY File Relationships Table`, the complete dependency chain is:

### Direct Dependencies (from CV_COMP_SKF_ACTUAL_STATIC):
1. **CV_BASE_SKF_WEEKLY_ACTUAL_S4** - Weekly actual snapshot data (Calculation View Dependency)
2. **CV_COMP_MD_SRPACT_STATIC** - Store attribute master data (Calculation View Dependency)
3. **CV_BASE_MD_HRRP_NODE_S4** - Cost center hierarchy nodes (Calculation View Dependency)
4. **CV_COMP_MD_COMPFL_STATIC** - Comp flag master data (Calculation View Dependency)
5. **CV_BASE_MD_RCALWEEK_S4** - Retail calendar week master (Calculation View Dependency)
6. **CV_BASE_MD_CEPCT_S4** - Profit center text master (Calculation View Dependency)

### Indirect Dependencies (upstream of direct dependencies):
7. **CV_BASE_MD_SRPACT_S4** - Source for STP_WSS_SRP_ATTRIBUTES → CV_COMP_MD_SRPACT_STATIC (Source Dependency)
8. **CV_BASE_MD_COMPFL_S4** - Source for STP_WSS_SRP_ATTRIBUTES → CV_COMP_MD_COMPFL_STATIC (Source Dependency)
9. **STP_WSS_SRP_ATTRIBUTES** - Stored procedure populating TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG (Logic Provider)

### Terminal Physical Sources:
- `edp-qa-finstorage.edp_saps4_shared_cnsv.bic_azsrp_ds112` (AZSRP_DS112_VT_S4)
- `edp-qa-finstorage.edp_saps4_shared_cnsv.ztsrp_attr_act` (ZTSRP_ATTR_ACT)
- `edp-qa-finstorage.edp_saps4_shared_cnsv.hrrp_node` (HRRP_NODE)
- `edp-qa-finstorage.edp_saps4_shared_cnsv.ztsrp_compfl` (ZTSRP_COMPFL)
- `edp-qa-finstorage.edp_saps4_shared_cnsv.ztfigl_rcalweek` (ZTFIGL_RCALWEEK)
- `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct` (CEPCT)

---

## 3. FINAL CONSUMER FLOW AND TRANSFORMATION ORDER

The final consumer (CV_COMP_SKF_ACTUAL_STATIC) follows this internal transformation sequence:

1. **WEEKLY_SNAPSHOT_DS05**: Filter and aggregate weekly actual data from CV_BASE_SKF_WEEKLY_ACTUAL_S4
2. **CC_HIER**: Filter cost center hierarchy nodes from CV_BASE_MD_HRRP_NODE_S4
3. **Join_3**: INNER JOIN WEEKLY_SNAPSHOT_DS05 with CC_HIER on cost center and client
4. **Projection_1**: Add calculated column CAL_WEEK (constant parameter @IP_WEEK_CY)
5. **STORE_ATTR_ACTUAL**: Aggregate store attributes from CV_COMP_MD_SRPACT_STATIC
6. **Join_2**: LEFT JOIN Projection_1 with STORE_ATTR_ACTUAL on profit center and client
7. **RETAIL_CAL**: Project retail calendar from CV_BASE_MD_RCALWEEK_S4
8. **Join_1**: LEFT JOIN Join_2 with RETAIL_CAL on CAL_WEEK = ZZWEEK
9. **COMP_FLAG_ACT01**: Filter comp flag data from CV_COMP_MD_COMPFL_STATIC
10. **Join_4**: LEFT JOIN Join_1 with COMP_FLAG_ACT01 on profit center and client
11. **PROFIT_CENTER_TEXT**: Project profit center text from CV_BASE_MD_CEPCT_S4
12. **Join_5**: LEFT JOIN Join_4 with PROFIT_CENTER_TEXT on profit center and client
13. **FLAGS**: Add calculated columns CAL_WEEK_NUMBER and CAL_ZIO_SKFQ_QTY
14. **Final SELECT**: Aggregate all measures (SUM) and group by all non-measure attributes

---

## 4. DEPENDENCY EXPANSION AND POINT-OF-CONSUMPTION MAPPING

### Dependency 1: CV_BASE_SKF_WEEKLY_ACTUAL_S4
- **Consumed at:** CTE 1 (WEEKLY_SNAPSHOT_DS05)
- **Expansion:** Replaced with direct SELECT from physical table `bic_azsrp_ds112` with filters and aggregation
- **Logic:** Filter by MANDT IN ('110', '200'), fiscal variant, week, version, audit trail, and account; aggregate all measures with SUM
- **Terminal source:** `edp-qa-finstorage.edp_saps4_shared_cnsv.bic_azsrp_ds112`

### Dependency 2: CV_BASE_MD_HRRP_NODE_S4
- **Consumed at:** CTE 2 (CC_HIER)
- **Expansion:** Replaced with direct SELECT from physical table `hrrp_node` with filters
- **Logic:** Filter by MANDT IN ('120', '200'), PARNODE LIKE '%CORERET%', HRYVALTO = '99991231'
- **Terminal source:** `edp-qa-finstorage.edp_saps4_shared_cnsv.hrrp_node`

### Dependency 3: CV_COMP_MD_SRPACT_STATIC
- **Consumed at:** CTE 5 (STORE_ATTR_ACTUAL)
- **Expansion:** Replaced staging table TBL_WSS_SRP_ATTR_ACT with source logic from CV_BASE_MD_SRPACT_S4
- **Upstream dependency:** CV_BASE_MD_SRPACT_S4 → physical table `ztsrp_attr_act`
- **Logic:** Filter by MANDT IN ('120', '200'), aggregate measures (rx_hrs_oper, fs_hrs_oper, rx_store, retail_sqft_amt, total_sqft_amt) with SUM
- **Terminal source:** `edp-qa-finstorage.edp_saps4_shared_cnsv.ztsrp_attr_act`
- **Note:** Stored procedure STP_WSS_SRP_ATTRIBUTES populates TBL_WSS_SRP_ATTR_ACT from CV_BASE_MD_SRPACT_S4; we bypass the staging table and use the source directly

### Dependency 4: CV_BASE_MD_RCALWEEK_S4
- **Consumed at:** CTE 7 (RETAIL_CAL)
- **Expansion:** Replaced with direct SELECT from physical table `ztfigl_rcalweek` with filter
- **Logic:** Filter by RCLNT IN ('120', '200')
- **Terminal source:** `edp-qa-finstorage.edp_saps4_shared_cnsv.ztfigl_rcalweek`

### Dependency 5: CV_COMP_MD_COMPFL_STATIC
- **Consumed at:** CTE 9 (COMP_FLAG_ACT01)
- **Expansion:** Replaced staging table TBL_WSS_SRP_COMPFLAG with source logic from CV_BASE_MD_COMPFL_S4
- **Upstream dependency:** CV_BASE_MD_COMPFL_S4 → physical table `ztsrp_compfl`
- **Logic:** Filter by MANDT IN ('110', '200'), ZWEEK between @IP_WEEK_ENDING_FROM and @IP_WEEK_ENDING_TO, COMP_VER = @IP_VERSION_COMP_FLAG
- **Terminal source:** `edp-qa-finstorage.edp_saps4_shared_cnsv.ztsrp_compfl`
- **Note:** Stored procedure STP_WSS_SRP_ATTRIBUTES populates TBL_WSS_SRP_COMPFLAG from CV_BASE_MD_COMPFL_S4; we bypass the staging table and use the source directly

### Dependency 6: CV_BASE_MD_CEPCT_S4
- **Consumed at:** CTE 11 (PROFIT_CENTER_TEXT)
- **Expansion:** Replaced with direct SELECT from physical table `v_cepct` with filter
- **Logic:** Filter by MANDT IN ('120', '200'), project LTEXT as profit_center_text
- **Terminal source:** `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct`

---

## 5. USED / NOT USED FILE CLASSIFICATIONS

### USED Files (11 total):

1. **CV_COMP_SKF_ACTUAL_STATIC** - Final consumer artifact (USED)
2. **CV_BASE_SKF_WEEKLY_ACTUAL_S4** - Direct dependency, expanded in CTE 1 (USED)
3. **CV_BASE_MD_HRRP_NODE_S4** - Direct dependency, expanded in CTE 2 (USED)
4. **CV_COMP_MD_SRPACT_STATIC** - Direct dependency, expanded in CTE 5 (USED)
5. **CV_BASE_MD_RCALWEEK_S4** - Direct dependency, expanded in CTE 7 (USED)
6. **CV_COMP_MD_COMPFL_STATIC** - Direct dependency, expanded in CTE 9 (USED)
7. **CV_BASE_MD_CEPCT_S4** - Direct dependency, expanded in CTE 11 (USED)
8. **CV_BASE_MD_SRPACT_S4** - Upstream source for CV_COMP_MD_SRPACT_STATIC, expanded in CTE 5 (USED)
9. **CV_BASE_MD_COMPFL_S4** - Upstream source for CV_COMP_MD_COMPFL_STATIC, expanded in CTE 9 (USED)
10. **STP_WSS_SRP_ATTRIBUTES** - Stored procedure populating staging tables; logic replaced by direct source expansion (USED)
11. **SKF_LY File Relationships Table** - Lineage metadata used to determine dependencies (USED)
12. **hana_to_bq_column_mapping 1** - Column mapping CSV used for all physical table and column mappings (USED)

### NOT USED Files (0 total):
All supplied files were used in the consolidation.

---

## 6. CTE / HELPER MAPPING AND JUSTIFICATION

### CTEs Retained from Final Consumer:
- **WEEKLY_SNAPSHOT_DS05** - Functional name from final consumer, preserved
- **CC_HIER** - Functional name from final consumer, preserved
- **STORE_ATTR_ACTUAL** - Functional name from final consumer, preserved
- **RETAIL_CAL** - Functional name from final consumer, preserved
- **COMP_FLAG_ACT01** - Functional name from final consumer, preserved
- **PROFIT_CENTER_TEXT** - Functional name from final consumer, preserved
- **FLAGS** - Functional name from final consumer, preserved

### CTEs with Generic Names (preserved as-is):
- **Join_3** - Structural join CTE, no clear business name available
- **Projection_1** - Structural projection CTE, no clear business name available
- **Join_2** - Structural join CTE, no clear business name available
- **Join_1** - Structural join CTE, no clear business name available
- **Join_4** - Structural join CTE, no clear business name available
- **Join_5** - Structural join CTE, no clear business name available

**Justification:** All CTEs represent required semantic boundaries:
- **WEEKLY_SNAPSHOT_DS05**: Aggregation boundary for weekly snapshot data
- **CC_HIER**: Filter and projection for cost center hierarchy
- **Join_3**: INNER JOIN boundary preserving only matching cost centers
- **Projection_1**: Adds calculated column CAL_WEEK
- **STORE_ATTR_ACTUAL**: Aggregation boundary for store attributes
- **Join_2**: LEFT JOIN boundary for store attributes
- **RETAIL_CAL**: Filter and projection for retail calendar
- **Join_1**: LEFT JOIN boundary for retail calendar
- **COMP_FLAG_ACT01**: Filter and projection for comp flags
- **Join_4**: LEFT JOIN boundary for comp flags
- **PROFIT_CENTER_TEXT**: Filter and projection for profit center text
- **Join_5**: LEFT JOIN boundary for profit center text
- **FLAGS**: Adds calculated columns CAL_WEEK_NUMBER and CAL_ZIO_SKFQ_QTY
- **Final SELECT**: Final aggregation boundary with SUM and GROUP BY

No CTEs were created solely for lineage representation or artifact boundaries. Each CTE serves a functional purpose in the data flow.

---

## 7. CTE DOCUMENTATION COMMENT VALIDATION

All CTEs include standardized comment headers with:
- CTE sequence number
- CTE name
- Logic description
- Source (when applicable)
- Filters (when applicable)
- Join (when applicable)
- Aggregation (when applicable)
- Calculation (when applicable)

Comments accurately describe the consolidated logic, not the original HANA node structure.

---

## 8. TABLE AND COLUMN MAPPING

### Mapping Source:
`hana_to_bq_column_mapping 1.csv` (full CSV read and validated)

### Physical Tables Referenced and Mapped:

#### Table 1: AZSRP_DS112_VT_S4
- **HANA:** SAPSEP.AZSRP_DS112_VT_S4
- **BigQuery:** `edp-qa-finstorage.edp_saps4_shared_cnsv.bic_azsrp_ds112`
- **Columns mapped:** All columns (fiscper, fiscvarnt, fiscyear, fiscper3, mandt, recordmode, bic_zio_sweek, b631_s_co_area, bic_zio_cmpcd, b631_s_proftctr, b631_s_costcntr, b631_s_funcarea, bic_zio_ver, bic_zio_saudt, bic_zio_psty, bic_zio_pskf, unit, bic_zio_skfq, bic_zio_d1skq, bic_zio_d2skq, bic_zio_d3skq, bic_zio_d4skq, bic_zio_d5skq, bic_zio_d6skq, bic_zio_d7skq)
- **Mapping status:** OK
- **Type casts:** MANDT filter values changed from numeric (110, 200) to string ('110', '200') to match BQ_DATATYPE = STRING

#### Table 2: HRRP_NODE
- **HANA:** SAPSEP.HRRP_NODE
- **BigQuery:** `edp-qa-finstorage.edp_saps4_shared_cnsv.hrrp_node`
- **Columns mapped:** mandt, parnode, hryvalto, nodevalue
- **Mapping status:** OK
- **Type casts:** MANDT filter values changed from numeric (120, 200) to string ('120', '200') to match BQ_DATATYPE = STRING

#### Table 3: ZTSRP_ATTR_ACT
- **HANA:** SAPSEP.ZTSRP_ATTR_ACT
- **BigQuery:** `edp-qa-finstorage.edp_saps4_shared_cnsv.ztsrp_attr_act`
- **Columns mapped:** All 91 columns from the source table
- **Mapping status:** OK
- **Type casts:** MANDT filter values changed from numeric (120, 200) to string ('120', '200') to match BQ_DATATYPE = STRING

#### Table 4: ZTFIGL_RCALWEEK
- **HANA:** SAPSEP.ZTFIGL_RCALWEEK
- **BigQuery:** `edp-qa-finstorage.edp_saps4_shared_cnsv.ztfigl_rcalweek`
- **Columns mapped:** rclnt, zzweek, zrwstrtdate, zrwenddate
- **Mapping status:** OK
- **Type casts:** RCLNT filter values changed from numeric (120, 200) to string ('120', '200') to match BQ_DATATYPE = STRING

#### Table 5: ZTSRP_COMPFL
- **HANA:** SAPSEP.ZTSRP_COMPFL
- **BigQuery:** `edp-qa-finstorage.edp_saps4_shared_cnsv.ztsrp_compfl`
- **Columns mapped:** mandt, prctr, strnum, comp_ver, zweek, zmonth, zyear, fs_comp_pre, rx_comp_pre, fs_comp_mon, rx_comp_mon, fs_comp_wk, rx_comp_wk
- **Mapping status:** OK
- **Type casts:** MANDT filter values changed from numeric (110, 200) to string ('110', '200') to match BQ_DATATYPE = STRING

#### Table 6: CEPCT
- **HANA:** SAPSEP.CEPCT
- **BigQuery:** `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct`
- **Columns mapped:** mandt, prctr, ltext (aliased as profit_center_text)
- **Mapping status:** OK
- **Type casts:** MANDT filter values changed from numeric (120, 200) to string ('120', '200') to match BQ_DATATYPE = STRING

### Column Name Transformations:
All HANA column names with leading underscores and forward slashes were converted to BigQuery style:
- `_BIC_ZIO_SWEEK` → `bic_zio_sweek`
- `_B631_S_PROFTCTR` → `b631_s_proftctr`
- `/BIC/ZIO_SWEEK` → `bic_zio_sweek`
- All column names lowercased, leading underscores removed, `/` replaced with `_`

### Redundant Aliases Removed:
No redundant aliases (same name before and after AS under name-equivalence rules) were present in the final SQL.

### Real Renames Preserved:
- `LTEXT AS profit_center_text` (real rename, preserved in BigQuery style)
- `_BIC_ZIO_SKFQ AS bic_zio_skfq_90as1` (real rename, preserved in BigQuery style)
- All calculated columns follow BigQuery style (e.g., `cal_week_number`, `cal_zio_skfq_qty`)

### Unmapped Columns:
None. All referenced columns were successfully mapped through `hana_to_bq_column_mapping 1.csv`.

### REVIEW Status Columns:
None. All mapped columns have status OK or CORRECTED.

---

## 9. DUPLICATE, AMBIGUOUS COLUMN, AND PARENT AVAILABILITY VALIDATION

### Duplicate Columns:
None. Each SELECT statement outputs each column exactly once.

### Ambiguous Columns:
None. All column references are qualified with their source CTE alias where multiple inputs are in scope.

### Parent Availability:
All columns referenced in each CTE exist in the output of their parent CTE, subquery, or source table. No missing columns detected.

---

## 10. AGGREGATION VALIDATION

### Aggregation Grain Preserved:
- **WEEKLY_SNAPSHOT_DS05:** Aggregates by all non-measure columns from `bic_azsrp_ds112`
- **STORE_ATTR_ACTUAL:** Aggregates by all non-measure columns from `ztsrp_attr_act`
- **Final SELECT:** Aggregates by all non-measure columns from FLAGS CTE

### Measures Aggregated:
- **WEEKLY_SNAPSHOT_DS05:** SUM(bic_zio_skfq), SUM(bic_zio_d1skq), ..., SUM(bic_zio_d7skq)
- **STORE_ATTR_ACTUAL:** SUM(rx_hrs_oper), SUM(fs_hrs_oper), SUM(rx_store), SUM(retail_sqft_amt), SUM(total_sqft_amt)
- **Final SELECT:** SUM(bic_zio_skfq), SUM(bic_zio_d1skq), ..., SUM(bic_zio_d7skq), SUM(cal_zio_skfq_qty)

All aggregation stages preserve required grain. No extra grouping columns added or removed.

---

## 11. STAR PROJECTION VALIDATION

No star projections (`SELECT *`) are present in the consolidated SQL. All columns are explicitly listed.

---

## 12. PARAMETER DOCUMENTATION

### Runtime Parameters:
1. **@IP_VERSION** (STRING) - Version code for weekly snapshot data (e.g., 'ACT01')
   - **Source:** Input parameter $$IP_VERSION$$ from CV_COMP_SKF_ACTUAL_STATIC
   - **Usage:** Filter in WEEKLY_SNAPSHOT_DS05 WHERE clause
   - **Reason unresolved:** Requires runtime binding in BigQuery
   - **Expected runtime value:** Provided by calling application or orchestration layer

2. **@IP_WEEK_LY** (STRING) - Last year week number for weekly snapshot data
   - **Source:** Derived via scalar function in CV_COMP_SKF_ACTUAL_STATIC
   - **Usage:** Filter in WEEKLY_SNAPSHOT_DS05 WHERE clause
   - **Reason unresolved:** Scalar function not available in BigQuery
   - **Expected runtime value:** Provided by calling application or orchestration layer

3. **@IP_WEEK_CY** (STRING) - Current year week number for calculated column CAL_WEEK
   - **Source:** Derived via scalar function in CV_COMP_SKF_ACTUAL_STATIC
   - **Usage:** Constant value in Projection_1 calculated column
   - **Reason unresolved:** Scalar function not available in BigQuery
   - **Expected runtime value:** Provided by calling application or orchestration layer

4. **@IP_WEEK_ENDING_FROM** (STRING) - Start week for comp flag filter
   - **Source:** Derived via scalar function in CV_COMP_SKF_ACTUAL_STATIC
   - **Usage:** Filter in COMP_FLAG_ACT01 WHERE clause
   - **Reason unresolved:** Scalar function not available in BigQuery
   - **Expected runtime value:** Provided by calling application or orchestration layer

5. **@IP_WEEK_ENDING_TO** (STRING) - End week for comp flag filter
   - **Source:** Derived via scalar function in CV_COMP_SKF_ACTUAL_STATIC
   - **Usage:** Filter in COMP_FLAG_ACT01 WHERE clause
   - **Reason unresolved:** Scalar function not available in BigQuery
   - **Expected runtime value:** Provided by calling application or orchestration layer

6. **@IP_VERSION_COMP_FLAG** (STRING) - Version code for comp flag filter
   - **Source:** Derived via scalar function in CV_COMP_SKF_ACTUAL_STATIC
   - **Usage:** Filter in COMP_FLAG_ACT01 WHERE clause
   - **Reason unresolved:** Scalar function not available in BigQuery
   - **Expected runtime value:** Provided by calling application or orchestration layer

All parameters are non-blocking findings. The SQL is production-ready pending runtime parameter binding.

---

## 13. PROCEDURE / ETL HANDLING

### Stored Procedure: STP_WSS_SRP_ATTRIBUTES
- **Purpose:** Populates staging tables TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG from CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_COMPFL_S4
- **Handling:** Staging tables bypassed; source Calculation Views expanded directly
- **DML skipped:** DELETE statements (truncate staging tables) not included in consolidated SQL
- **Audit columns skipped:** SNAPSHOT_TIMESTAMP, SNAPSHOT_CREATED_BY, CREATED_BY not included (not used in downstream logic)
- **Logic preserved:** All result-affecting SELECT logic from source Calculation Views preserved

No procedural semantics require REQUIRES VALIDATION. All logic is representable as a single query.

---

## 14. CONFLICTS AND VALIDATION FINDINGS

### Blocking Findings:
None.

### Non-Blocking Findings:
1. **Runtime parameters:** Six input parameters require runtime binding (@IP_VERSION, @IP_WEEK_LY, @IP_WEEK_CY, @IP_WEEK_ENDING_FROM, @IP_WEEK_ENDING_TO, @IP_VERSION_COMP_FLAG)
2. **Scalar functions converted to parameters:** All HANA scalar functions (e.g., SFN_PRIOR_FISCAL_WEEK) converted to BigQuery parameters
3. **Skipped DML:** DELETE statements from STP_WSS_SRP_ATTRIBUTES not included (staging table population logic)
4. **Dropped audit columns:** SNAPSHOT_TIMESTAMP, SNAPSHOT_CREATED_BY, CREATED_BY not included (not used in downstream logic)

All non-blocking findings are documented and do not affect the correctness of the consolidated SQL.

---

## 15. FINAL QUALITY GATE RESULTS

### Mandatory Checks:
- ✅ Final consumer unambiguous: CV_COMP_SKF_ACTUAL_STATIC
- ✅ Artifact dependencies match lineage table
- ✅ Final-consumer transformation order preserved
- ✅ Dependencies expanded at point of consumption
- ✅ No generic Source → Intermediate → Target ordering
- ✅ Every file classified USED or NOT USED
- ✅ Every USED file participates in dependency chain
- ✅ All converted dependencies expanded
- ✅ Only terminal sources remain
- ✅ Every physical source uses BQ_FULL_TABLE name
- ✅ No PROJECT.DATASET placeholders remain
- ✅ Every referenced physical-source column mapped 1:1 through CSV
- ✅ Filter literals match mapped BigQuery data types (MANDT, RCLNT cast to STRING)
- ✅ No redundant aliases (same name before/after AS under equivalence rules)
- ✅ Every column name and alias in BigQuery style
- ✅ Final-consumer functional CTE names preserved
- ✅ Compatible steps combined when logically safe
- ✅ No source/HANA node becomes separate CTE merely for structure
- ✅ Every helper CTE justified by semantic boundary
- ✅ Every CTE matches required output contract
- ✅ Every column reference exists in parent output
- ✅ Every column reference qualified where multiple inputs in scope
- ✅ No duplicate alias within a SELECT
- ✅ No invalid star projections
- ✅ Filters, joins, calculations, mappings, parameters preserved
- ✅ Every aggregation stage preserves required grain
- ✅ DISTINCT, UNION, window behavior preserved (none present)
- ✅ No conflict silently corrected
- ✅ No result-affecting procedural behavior discarded
- ✅ Runtime parameters documented
- ✅ Every CTE has standardized comment header
- ✅ CTE comments describe consolidated logic
- ✅ Complete query achieves 100% logic match

### Non-Blocking Findings:
- Runtime parameters (6 total)
- Functions converted to parameters (scalar functions)
- Skipped DML (DELETE statements)
- Dropped audit columns (SNAPSHOT_TIMESTAMP, SNAPSHOT_CREATED_BY, CREATED_BY)

### Final Status:
**PRODUCTION-READY** (pending runtime parameter binding)

---

## 16. CONSOLIDATION TRACEABILITY SUMMARY

| Original File | Consolidated Location | Logic Contribution |
|---------------|----------------------|-------------------|
| CV_COMP_SKF_ACTUAL_STATIC | Final SELECT, FLAGS CTE | Final aggregation, calculated columns CAL_WEEK_NUMBER and CAL_ZIO_SKFQ_QTY, all join logic |
| CV_BASE_SKF_WEEKLY_ACTUAL_S4 | CTE 1 (WEEKLY_SNAPSHOT_DS05) | Weekly snapshot data with filters and aggregation |
| CV_BASE_MD_HRRP_NODE_S4 | CTE 2 (CC_HIER) | Cost center hierarchy filter |
| CV_COMP_MD_SRPACT_STATIC | CTE 5 (STORE_ATTR_ACTUAL) | Store attributes (replaced staging table with source logic) |
| CV_BASE_MD_SRPACT_S4 | CTE 5 (STORE_ATTR_ACTUAL) | Source for store attributes (upstream of CV_COMP_MD_SRPACT_STATIC) |
| CV_BASE_MD_RCALWEEK_S4 | CTE 7 (RETAIL_CAL) | Retail calendar week master |
| CV_COMP_MD_COMPFL_STATIC | CTE 9 (COMP_FLAG_ACT01) | Comp flag data (replaced staging table with source logic) |
| CV_BASE_MD_COMPFL_S4 | CTE 9 (COMP_FLAG_ACT01) | Source for comp flags (upstream of CV_COMP_MD_COMPFL_STATIC) |
| CV_BASE_MD_CEPCT_S4 | CTE 11 (PROFIT_CENTER_TEXT) | Profit center text master |
| STP_WSS_SRP_ATTRIBUTES | CTE 5, CTE 9 | Stored procedure logic replaced by direct source expansion |
| hana_to_bq_column_mapping 1 | All CTEs | Physical table and column mappings for all terminal sources |

---

## 17. VALIDATION ITEMS

None. All logic, dependencies, and SQL are safely consolidated from the provided inputs.

---

## END OF CONSOLIDATION DESCRIPTION
