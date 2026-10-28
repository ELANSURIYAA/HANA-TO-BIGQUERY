# FIN_LY Consolidation Description - Column Mapping v1

## Executive Summary

**Status:** `REQUIRES VALIDATION: MISSING COLUMN MAPPING`

**Reason:** Multiple columns referenced in the dependency chain are not mapped in `Columns_Mapping.csv`. Additionally, data type conflicts exist for client fields (MANDT/RCLNT) where numeric literals are used but BigQuery columns are STRING type.

---

## Final Consumer Identification

**Final Consumer:** `CV_COMP_FIN_ACTUAL_STATIC`

**Type:** Calculation View (CUBE with Aggregation output)

**Description:** Composite Financial Actual Static view that consolidates weekly financial actuals with store attributes, hierarchies, retail calendar, and comparison flags.

---

## Artifact Dependency Mapping

### Complete Dependency Chain

```
CV_BASE_MD_SRPACT_S4
  └─> STP_WSS_SRP_ATTRIBUTES (populates TBL_WSS_SRP_ATTR_ACT)
       └─> CV_COMP_MD_SRPACT_STATIC
            └─> CV_COMP_FIN_ACTUAL_STATIC

CV_BASE_MD_COMPFL_S4
  └─> STP_WSS_SRP_ATTRIBUTES (populates TBL_WSS_SRP_COMPFLAG)
       └─> CV_COMP_MD_COMPFL_STATIC
            └─> CV_COMP_FIN_ACTUAL_STATIC

CV_BASE_FIN_WEEKLY_ACTUAL_S4
  └─> CV_COMP_FIN_ACTUAL_STATIC

GL_HEIR.CV_BASE_MD_HRRP_NODE_S4
  └─> CV_COMP_FIN_ACTUAL_STATIC

PC_HEIR.CV_BASE_MD_HRRP_NODE_S4
  └─> CV_COMP_FIN_ACTUAL_STATIC

CV_BASE_MD_RCALWEEL_S4
  └─> CV_COMP_FIN_ACTUAL_STATIC

CV_BASE_MD_CEPCT_S4
  └─> CV_COMP_FIN_ACTUAL_STATIC
```

---

## File Classification

### USED Files

1. **CV_COMP_FIN_ACTUAL_STATIC** - Final consumer, orchestrates all joins and aggregations
2. **CV_BASE_FIN_WEEKLY_ACTUAL_S4** - Base weekly financial actuals from AZSRP_DS072_VT_S4
3. **CV_COMP_MD_SRPACT_STATIC** - Store profile attributes (static snapshot)
4. **GL_HEIR.CV_BASE_MD_HRRP_NODE_S4** - G/L account hierarchy
5. **PC_HEIR.CV_BASE_MD_HRRP_NODE_S4** - Profit center hierarchy
6. **CV_BASE_MD_RCALWEEL_S4** - Retail calendar week mapping
7. **CV_COMP_MD_COMPFL_STATIC** - Comparison flag static snapshot
8. **CV_BASE_MD_CEPCT_S4** - Profit center text
9. **STP_WSS_SRP_ATTRIBUTES** - Stored procedure that populates staging tables
10. **CV_BASE_MD_SRPACT_S4** - Base store profile attributes from ZTSRP_ATTR_ACT
11. **CV_BASE_MD_COMPFL_S4** - Base comparison flags from ZTSRP_COMPFL

### NOT USED Files

None - all supplied files are part of the dependency chain.

---

## Column Mapping Validation

### Mapped Columns (Validated)

**Total CSV Rows Read:** 1,442

**Physical Source Tables Validated:**
- `v_acdoca` (ACDOCA_VT_S4) - All referenced columns mapped
- `v_bkpf` (BKPF) - All referenced columns mapped
- `v_faglskf_pn` (FAGLSKF_PN) - All referenced columns mapped
- `v_cepct` (CEPCT) - All referenced columns mapped: mandt, spras, prctr, datbi, kokrs, ktext, ltext, mctxt
- `v_ztfigl_rcalweek` (ZTFIGL_RCALWEEK) - All referenced columns mapped: rclnt, zzweek, zcalyrp, zryear, zrperiod, zryrp, zryrqtr, zrwstrtdate, zrwenddate
- `v_ztsrp_compfl` (ZTSRP_COMPFL) - All referenced columns mapped: mandt, prctr, strnum, comp_ver, zweek, zmonth, zyear, fs_comp_pre, rx_comp_pre, fs_comp_mon, rx_comp_mon, fs_comp_wk, rx_comp_wk
- `v_bic_azsrp_ds212` (AZSRP_DS072_VT_S4) - All referenced columns mapped

### MISSING COLUMN MAPPINGS

**REQUIRES VALIDATION: The following columns are referenced in the dependency chain but NOT present in `Columns_Mapping.csv`:**

#### HRRP_NODE Table (used by GL and PC hierarchies):
- `HRYSEQNBR` - Hierarchy sequence number
- `HRYTYPE` - Hierarchy type
- `HRYLEVEL` - Hierarchy level
- `UHNODEID` - Universal hierarchy node ID

**Impact:** Both GL_HEIR.CV_BASE_MD_HRRP_NODE_S4 and PC_HEIR.CV_BASE_MD_HRRP_NODE_S4 reference these columns, but they are not mapped to BigQuery column names.

#### ZTSRP_ATTR_ACT Table:
- `FS_MULTI` - Front store multiple indicator
- `RX_MULTI` - Pharmacy multiple indicator

**Impact:** CV_BASE_MD_SRPACT_S4 references these columns, but they are not mapped to BigQuery column names.

**Columns Present in CSV:** mandt, hryid, hryver, nodecls, hrynode, parnode, hryvalto, hryvalfrom, balind, nodetype, nodevalue (for HRRP_NODE)

**Columns Missing:** hryseqnbr, hrytype, hrylevel, uhnodeid, fs_multi, rx_multi

---

## Data Type Conflicts

**REQUIRES VALIDATION: DATA TYPE CONFLICT**

### Client Field Type Mismatch

**Issue:** The `Columns_Mapping.csv` maps client fields to STRING type in BigQuery:
- `MANDT` (all tables) → `BQ_DATATYPE` = `STRING`
- `RCLNT` (ZTFIGL_RCALWEEK) → `BQ_DATATYPE` = `STRING`

**Conflict:** The converted SQL files use numeric literals in filters:
- `MANDT IN (120, 200)` (multiple files)
- `MANDT IN (110, 200)` (CV_BASE_MD_COMPFL_S4)
- `RCLNT IN (120, 200)` (CV_BASE_MD_RCALWEEL_S4)

**Required Fix:** All client field filters must use string literals:
- `MANDT IN ('120', '200')`
- `MANDT IN ('110', '200')`
- `RCLNT IN ('120', '200')`

**Affected Files:**
1. CV_BASE_MD_HRRP_NODE_S4 (both GL and PC)
2. CV_BASE_MD_SRPACT_S4
3. CV_BASE_MD_RCALWEEL_S4
4. CV_BASE_MD_CEPCT_S4
5. CV_BASE_MD_COMPFL_S4
6. CV_BASE_FIN_WEEKLY_ACTUAL_S4

---

## Procedural Logic Handling

### STP_WSS_SRP_ATTRIBUTES Procedure

**Source:** HANA SQLScript stored procedure

**Purpose:** Populates two staging tables:
1. `TBL_WSS_SRP_ATTR_ACT` from `CV_BASE_MD_SRPACT_S4`
2. `TBL_WSS_SRP_COMPFLAG` from `CV_BASE_MD_COMPFL_S4` (filtered by week)

**Logic Inlined:**
- DELETE statements are skipped (not part of query logic)
- INSERT...SELECT bodies are inlined where staging tables are consumed
- Variable `V_WEEK` (from `SFN_PRIOR_FISCAL_WEEK()`) becomes runtime parameter `@v_week`
- Filters: `ZWEEK = V_WEEK` becomes `ZWEEK = @v_week`
- Audit columns (`SNAPSHOT_TIMESTAMP`, `SNAPSHOT_CREATED_BY`) are dropped (not used downstream)

**Inlining Points:**
1. `CV_COMP_MD_SRPACT_STATIC` reads `TBL_WSS_SRP_ATTR_ACT` → replaced with SELECT from `CV_BASE_MD_SRPACT_S4`
2. `CV_COMP_MD_COMPFL_STATIC` reads `TBL_WSS_SRP_COMPFLAG` → replaced with SELECT from `CV_BASE_MD_COMPFL_S4` WHERE `ZWEEK = @v_week`

**Unresolved Function:**
- `SFN_PRIOR_FISCAL_WEEK()` - Converted to runtime parameter `@v_week` (type: STRING)

---

## Runtime Parameters

The consolidated query requires the following runtime parameters (all STRING type):

1. **@ip_version** - Version filter for financial actuals
2. **@ip_week_ly** - Last year week for financial actuals
3. **@ip_week_cy** - Current year week for financial actuals
4. **@ip_week_ending_from** - Week ending range start (declared but not used in logic)
5. **@ip_week_ending_to** - Week ending range end (declared but not used in logic)
6. **@ip_version_comp_flag** - Version filter for comparison flags
7. **@v_week** - Prior fiscal week (from SFN_PRIOR_FISCAL_WEEK function)

**Note:** Parameters 4 and 5 are declared in the original calculation view but not referenced in any filter or calculation logic.

---

## Validation Findings

### Blocking Issues

1. **MISSING COLUMN MAPPING** - 6 columns (hryseqnbr, hrytype, hrylevel, uhnodeid, fs_multi, rx_multi) are not mapped in `Columns_Mapping.csv`
2. **DATA TYPE CONFLICT** - Client field filters use numeric literals but BigQuery columns are STRING type

### Non-Blocking Findings

1. **Unresolved Function** - `SFN_PRIOR_FISCAL_WEEK()` converted to runtime parameter `@v_week`
2. **Unused Parameters** - `@ip_week_ending_from` and `@ip_week_ending_to` declared but not used
3. **Audit Columns Dropped** - `SNAPSHOT_TIMESTAMP`, `SNAPSHOT_CREATED_BY`, `CREATED_BY` from staging tables are not used downstream

---

## Quality Gate Results

### Mandatory Checks

❌ **Final consumer identification** - PASSED (CV_COMP_FIN_ACTUAL_STATIC)
❌ **Artifact dependencies match lineage** - PASSED
❌ **All files classified** - PASSED (all USED)
❌ **All converted dependencies expanded** - PASSED
❌ **Physical source table mapping** - **FAILED** (6 columns unmapped)
❌ **Physical column mapping** - **FAILED** (6 columns unmapped)
❌ **Data type compatibility** - **FAILED** (client field type mismatch)
❌ **No duplicate aliases** - PASSED
❌ **Aggregation grain preserved** - PASSED
❌ **Procedural logic inlined** - PASSED
❌ **Runtime parameters documented** - PASSED

**Overall Status:** **FAILED** - Cannot produce production-ready SQL due to missing column mappings and data type conflicts.

---

## Recommended Actions

1. **Add Missing Columns to Columns_Mapping.csv:**
   - HRRP_NODE: HRYSEQNBR, HRYTYPE, HRYLEVEL, UHNODEID
   - ZTSRP_ATTR_ACT: FS_MULTI, RX_MULTI

2. **Verify Client Field Data Types:**
   - Confirm MANDT and RCLNT are STRING in BigQuery
   - Update all filters to use string literals

3. **Implement SFN_PRIOR_FISCAL_WEEK:**
   - Create BigQuery UDF or provide runtime value for @v_week parameter

4. **Validate Unused Parameters:**
   - Confirm @ip_week_ending_from and @ip_week_ending_to can be removed or require implementation

---

## Confidence Level

**Medium** - All logic is traceable and preserved, but missing mappings and type conflicts prevent full validation.

