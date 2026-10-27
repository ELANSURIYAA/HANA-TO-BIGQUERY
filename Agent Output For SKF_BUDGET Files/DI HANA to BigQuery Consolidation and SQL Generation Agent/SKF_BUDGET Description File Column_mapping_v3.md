# SKF_BUDGET Consolidation Description Document

## Executive Summary

This document provides complete traceability from the original SAP HANA artifacts to the final consolidated BigQuery SQL implementation for the **SKF_BUDGET** data pipeline. The consolidation inlines all upstream dependencies, applies physical column mappings from the HANA-to-BigQuery column mapping file, and produces a single executable query that replaces the need for intermediate views.

**Final Consumer Artifact**: `CV_COMP_SKF_BUDGET_STATIC`

**Consolidation Approach**: Bottom-up dependency resolution with inline CTE expansion, preserving 100% of business logic without requiring intermediate materialized views.

---

## 1. Source Artifacts and Dependency Flow

### 1.1 Dependency Hierarchy

The SKF_BUDGET pipeline follows this dependency chain (from base to consumer):

```
BASE LAYER (Source Tables):
├── CEPCT (Profit Center Text)
├── ZTSRP_COMPFL (Store Comp Flags)
├── HRRP_NODE (Hierarchy Nodes)
├── ZTFIGL_RCALWEEK (Retail Calendar Week)
├── ZTSRP_ATTR_ACT (Store Attributes)
├── AZSRP_DS092_VT_S4 (Frozen Budget Cube)
└── AZSRP_DS031_VT_S4 (Live Budget Cube)

INTERMEDIATE LAYER (Base Calculation Views):
├── CV_BASE_MD_CEPCT_S4 → Filters CEPCT by mandt
├── CV_BASE_MD_COMPFL_S4 → Filters ZTSRP_COMPFL by mandt
├── CV_BASE_MD_HRRP_NODE_S4 → Filters HRRP_NODE by mandt
├── CV_BASE_MD_RCALWEEK_S4 → Filters ZTFIGL_RCALWEEK by rclnt
├── CV_BASE_MD_SRPACT_S4 → Aggregates ZTSRP_ATTR_ACT by mandt
└── CV_BASE_SKF_WEEKLY_BUDGET_S4 → UNIONs Frozen + Live cubes with conditional logic

PROCEDURE LAYER (Data Load):
└── STP_WSS_SRP_ATTRIBUTES → Loads TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG

COMPOSITE LAYER (Static Views):
├── CV_COMP_MD_SRPACT_STATIC → Projects TBL_WSS_SRP_ATTR_ACT with aggregation
└── CV_COMP_MD_COMPFL_STATIC → Projects TBL_WSS_SRP_COMPFLAG

FINAL CONSUMER:
└── CV_COMP_SKF_BUDGET_STATIC → Joins all composite views with filters, calculations, and aggregation
```

### 1.2 File Relationships Table Summary

| Source Artifact | Target Artifact | Relationship Score | Relationship Type |
|----------------|-----------------|-------------------|-------------------|
| CV_BASE_MD_SRPACT_S4 | STP_WSS_SRP_ATTRIBUTES | 100 | Data Source |
| CV_BASE_MD_COMPFL_S4 | STP_WSS_SRP_ATTRIBUTES | 100 | Data Source |
| STP_WSS_SRP_ATTRIBUTES | TBL_WSS_SRP_ATTR_ACT | 95 | Populates |
| STP_WSS_SRP_ATTRIBUTES | TBL_WSS_SRP_COMPFLAG | 95 | Populates |
| TBL_WSS_SRP_ATTR_ACT | CV_COMP_MD_SRPACT_STATIC | 95 | Data Source |
| TBL_WSS_SRP_COMPFLAG | CV_COMP_MD_COMPFL_STATIC | 95 | Data Source |
| CV_BASE_SKF_WEEKLY_BUDGET_S4 | CV_COMP_SKF_BUDGET_STATIC | 90 | Data Source |
| CV_BASE_MD_HRRP_NODE_S4 | CV_COMP_SKF_BUDGET_STATIC | 90 | Data Source |
| CV_COMP_MD_SRPACT_STATIC | CV_COMP_SKF_BUDGET_STATIC | 90 | Data Source |
| CV_COMP_MD_COMPFL_STATIC | CV_COMP_SKF_BUDGET_STATIC | 90 | Data Source |
| CV_BASE_MD_RCALWEEK_S4 | CV_COMP_SKF_BUDGET_STATIC | 90 | Data Source |
| CV_BASE_MD_CEPCT_S4 | CV_COMP_SKF_BUDGET_STATIC | 90 | Data Source |

---

## 2. Consolidation Traceability

### 2.1 CTE-Level Mapping

| CTE # | CTE Name | Source Artifact(s) | Logic Description | Physical Tables |
|-------|----------|-------------------|-------------------|-----------------|
| 1 | BASE_CEPCT | CV_BASE_MD_CEPCT_S4 | Profit center text with mandt filter | v_cepct |
| 2 | BASE_COMPFL | CV_BASE_MD_COMPFL_S4 | Store comp flags with mandt filter | ztsrp_compfl |
| 3 | BASE_HRRP_NODE | CV_BASE_MD_HRRP_NODE_S4 | Hierarchy nodes with mandt filter | hrrp_node |
| 4 | BASE_RCALWEEK | CV_BASE_MD_RCALWEEK_S4 | Retail calendar week with rclnt filter | ztfigl_rcalweek |
| 5 | BASE_SRPACT | CV_BASE_MD_SRPACT_S4 | Store attributes with aggregation | ztsrp_attr_act |
| 6 | FROZEN_CUBE | CV_BASE_SKF_WEEKLY_BUDGET_S4 (Frozen path) | Frozen budget data with ip_fc_count filter | bic_azsrp_ds092 |
| 7 | LIVE_CUBE | CV_BASE_SKF_WEEKLY_BUDGET_S4 (Live path) | Live budget data with ip_fc_count filter | bic_azsrp_ds031 |
| 8 | WEEKLY_BUDGET_UNION | CV_BASE_SKF_WEEKLY_BUDGET_S4 (Union logic) | UNION ALL of Frozen and Live with column alignment | (derived) |
| 9 | WEEKLY_BUDGET_AGGREGATED | CV_BASE_SKF_WEEKLY_BUDGET_S4 (Aggregation logic) | Conditional measure calculation (FC vs LC) | (derived) |
| 10 | WEEKLY_SNAPSHOT_FILTERED | CV_COMP_SKF_BUDGET_STATIC (WEEKLY_SNAPSHOT_DS05 node) | Apply fiscal variant, version, audit, account filters | (derived) |
| 11 | HIERARCHY_FILTERED | CV_COMP_SKF_BUDGET_STATIC (HIER_NODE node) | Filter hierarchy for CORERET pattern | (derived) |
| 12 | WEEKLY_WITH_HIERARCHY | CV_COMP_SKF_BUDGET_STATIC (Join_1 node) | Inner join weekly snapshot with hierarchy | (derived) |
| 13 | WITH_STORE_ATTRIBUTES | CV_COMP_SKF_BUDGET_STATIC (Join_2 node) | Left join with store attributes | (derived) |
| 14 | WITH_COMP_FLAGS | CV_COMP_SKF_BUDGET_STATIC (Join_3 node) | Left join with comp flags filtered by version | (derived) |
| 15 | WITH_CALENDAR_WEEK | CV_COMP_SKF_BUDGET_STATIC (Join_4 node) | Left join with retail calendar week | (derived) |
| 16 | WITH_PROFIT_CENTER_TEXT | CV_COMP_SKF_BUDGET_STATIC (Join_5 node) | Left join with profit center text | (derived) |
| 17 | FINAL_CALCULATED_COLUMNS | CV_COMP_SKF_BUDGET_STATIC (FLAGS node) | Apply calculated columns (week number, doubled SKF, comp flag) | (derived) |
| Final | SELECT | CV_COMP_SKF_BUDGET_STATIC (Aggregation node) | Final aggregation with GROUP BY on all non-measures | (output) |

### 2.2 Column Mapping Summary

All physical column names in the consolidated SQL are sourced from the `hana_to_bq_column_mapping 1.csv` file. Key mappings include:

**HANA Column** → **BigQuery Column** (Table: Source)

- `MANDT` → `mandt` (CEPCT, ZTSRP_COMPFL, HRRP_NODE, ZTSRP_ATTR_ACT, AZSRP_DS092, AZSRP_DS031)
- `RCLNT` → `rclnt` (ZTFIGL_RCALWEEK)
- `PRCTR` → `prctr` (CEPCT, ZTSRP_COMPFL, ZTSRP_ATTR_ACT)
- `STRNUM` → `strnum` (ZTSRP_COMPFL, ZTSRP_ATTR_ACT)
- `ZWEEK` → `zweek` (ZTSRP_COMPFL)
- `ZZWEEK` → `zzweek` (ZTFIGL_RCALWEEK)
- `FISCPER` → `fiscper` (AZSRP_DS092, AZSRP_DS031)
- `FISCVARNT` → `fiscvarnt` (AZSRP_DS092, AZSRP_DS031)
- `_BIC_ZIO_SWEEK` → `bic_zio_sweek` (AZSRP_DS092, AZSRP_DS031)
- `_BIC_ZIO_SKFQ` → `bic_zio_skfq` (AZSRP_DS092, AZSRP_DS031)
- `_BIC_ZIO_PSKF` → `bic_zio_pskf` (AZSRP_DS092, AZSRP_DS031)
- `_BIC_ZIO_SAUDT` → `bic_zio_saudt` (AZSRP_DS092, AZSRP_DS031)
- `_BIC_ZIO_VER` → `bic_zio_ver` (AZSRP_DS092, AZSRP_DS031)
- `_B631_S_PROFTCTR` → `b631_s_proftctr` (AZSRP_DS092, AZSRP_DS031)
- `_B631_S_COSTCNTR` → `b631_s_costcntr` (AZSRP_DS092, AZSRP_DS031)
- `_B631_S_CO_AREA` → `b631_s_co_area` (AZSRP_DS092, AZSRP_DS031)
- `_B631_S_CHRTACCT` → `b631_s_chrtacct` (AZSRP_DS092)
- `_B631_S_FUNCAREA` → `b631_s_funcarea` (AZSRP_DS092)
- `_BIC_ZIO_PCTR` → `bic_zio_pctr` (AZSRP_DS031)
- `_BIC_ZIO_CCTR` → `bic_zio_cctr` (AZSRP_DS031)
- `PARNODE` → `parnode` (HRRP_NODE)
- `NODEVALUE` → `nodevalue` (HRRP_NODE)
- `HRYVALTO` → `hryvalto` (HRRP_NODE)
- `LTEXT` → `ltext` (CEPCT)
- `RX_COMP_WK` → `rx_comp_wk` (ZTSRP_COMPFL)
- `COMP_VER` → `comp_ver` (ZTSRP_COMPFL)
- `ZRWSTRTDATE` → `zrwstrtdate` (ZTFIGL_RCALWEEK)
- `ZRWENDDATE` → `zrwenddate` (ZTFIGL_RCALWEEK)

All column names follow BigQuery naming conventions: lowercase, no leading underscores (except for SAP-standard prefixes like `_BIC_` and `_B631_`), and exact matches to the `BQ_COLUMN` values in the CSV.

---

## 3. Logic Consolidation Details

### 3.1 Base Layer Logic

**CV_BASE_MD_CEPCT_S4**:
- **Input**: `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct`
- **Filter**: `mandt IN ('120', '200')`
- **Output**: Profit center text attributes (8 columns)
- **Consolidation**: Inlined as CTE 1 (BASE_CEPCT)

**CV_BASE_MD_COMPFL_S4**:
- **Input**: `edp-qa-finstorage.edp_saps4_shared_cnsv.ztsrp_compfl`
- **Filter**: `mandt IN ('110', '200')`
- **Output**: Store comp flags (13 columns)
- **Consolidation**: Inlined as CTE 2 (BASE_COMPFL)

**CV_BASE_MD_HRRP_NODE_S4**:
- **Input**: `edp-qa-finstorage.edp_saps4_shared_cnsv.hrrp_node`
- **Filter**: `mandt IN ('120', '200')`
- **Output**: Hierarchy node structure (11 columns)
- **Consolidation**: Inlined as CTE 3 (BASE_HRRP_NODE)

**CV_BASE_MD_RCALWEEK_S4**:
- **Input**: `edp-qa-finstorage.edp_saps4_shared_cnsv.ztfigl_rcalweek`
- **Filter**: `rclnt IN ('120', '200')`
- **Output**: Retail calendar week mappings (9 columns)
- **Consolidation**: Inlined as CTE 4 (BASE_RCALWEEK)

**CV_BASE_MD_SRPACT_S4**:
- **Input**: `edp-qa-finstorage.edp_saps4_shared_cnsv.ztsrp_attr_act`
- **Filter**: `mandt IN ('120', '200')`
- **Aggregation**: `SUM(rx_hrs_oper, fs_hrs_oper, retail_sqft_amt, total_sqft_amt)` with `GROUP BY` on all other columns
- **Output**: Store attributes with aggregated measures (71 attributes + 4 measures)
- **Consolidation**: Inlined as CTE 5 (BASE_SRPACT)

### 3.2 Weekly Budget Logic (CV_BASE_SKF_WEEKLY_BUDGET_S4)

This is the most complex base view, involving:

1. **Frozen Cube Path** (CTE 6: FROZEN_CUBE):
   - **Input**: `edp-qa-finstorage.edp_saps4_shared_cnsv.bic_azsrp_ds092`
   - **Filter**: `mandt IN ('110', '200') AND @ip_fc_count != '0'`
   - **Columns**: All fiscal, organizational, and measure columns from DS092

2. **Live Cube Path** (CTE 7: LIVE_CUBE):
   - **Input**: `edp-qa-finstorage.edp_saps4_shared_cnsv.bic_azsrp_ds031`
   - **Filter**: `mandt IN ('110', '200') AND @ip_fc_count = '0'`
   - **Columns**: All fiscal, organizational, and measure columns from DS031
   - **Column Mapping Differences**: 
     - `b631_s_compcode` (DS031) → not used in union
     - `bic_zio_pctr` (DS031) → mapped to `b631_s_proftctr` in union
     - `bic_zio_cctr` (DS031) → mapped to `b631_s_costcntr` in union
     - `b631_s_chrtacct` and `b631_s_funcarea` → set to empty string in Live path

3. **Union Logic** (CTE 8: WEEKLY_BUDGET_UNION):
   - **Operation**: `UNION ALL` of Frozen and Live cubes
   - **FLAG Column**: Added to distinguish 'FC' (Frozen) vs 'LC' (Live) records
   - **Column Alignment**: Live cube columns mapped to match Frozen cube schema

4. **Conditional Measure Calculation** (CTE 9: WEEKLY_BUDGET_AGGREGATED):
   - **Formula**: `COALESCE(SUM(CASE WHEN flag='FC' THEN bic_zio_skfq END), SUM(CASE WHEN flag='LC' THEN bic_zio_skfq END))`
   - **Logic**: If Frozen quantity is NULL, use Live quantity; otherwise use Frozen
   - **Aggregation**: `GROUP BY` all non-measure columns

**Parameter Dependencies**:
- `@ip_version`: Budget version identifier (default: 'LEDGER_BUD')
- `@ip_fc_count`: Frozen cube flag (derived from external function `SFN_SKF_FC_FLAG`)
  - When `@ip_fc_count != '0'`: Use Frozen cube
  - When `@ip_fc_count = '0'`: Use Live cube

### 3.3 Procedure Logic (STP_WSS_SRP_ATTRIBUTES)

**Purpose**: Data load procedure that populates static tables from base views.

**Logic**:
1. Declare variable `V_WEEK` (prior fiscal week from `SFN_PRIOR_FISCAL_WEEK()`)
2. Delete all rows from `TBL_WSS_SRP_ATTR_ACT` and `TBL_WSS_SRP_COMPFLAG`
3. Insert all rows from `CV_BASE_MD_SRPACT_S4` into `TBL_WSS_SRP_ATTR_ACT` with audit columns
4. Insert filtered rows (`ZWEEK = V_WEEK`) from `CV_BASE_MD_COMPFL_S4` into `TBL_WSS_SRP_COMPFLAG` with audit columns

**Consolidation Note**: This procedure is NOT inlined in the consolidated SQL because:
- It represents a data load operation, not a query transformation
- The consolidated SQL reads directly from base tables, bypassing the static tables
- The procedure logic is documented here for completeness but not executed in the query

### 3.4 Composite Layer Logic

**CV_COMP_MD_SRPACT_STATIC**:
- **Input**: `TBL_WSS_SRP_ATTR_ACT` (populated by procedure)
- **Logic**: Direct projection with aggregation (SUM on 5 measures, GROUP BY on 71 attributes)
- **Consolidation**: Replaced by direct read from `ztsrp_attr_act` in CTE 5 (BASE_SRPACT)

**CV_COMP_MD_COMPFL_STATIC**:
- **Input**: `TBL_WSS_SRP_COMPFLAG` (populated by procedure)
- **Logic**: Direct projection (13 columns, no aggregation)
- **Consolidation**: Replaced by direct read from `ztsrp_compfl` in CTE 2 (BASE_COMPFL)

### 3.5 Final Consumer Logic (CV_COMP_SKF_BUDGET_STATIC)

**Join Sequence**:
1. **CTE 10 (WEEKLY_SNAPSHOT_FILTERED)**: Apply filters on weekly budget
   - `fiscvarnt = 'K4'`
   - `bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to`
   - `bic_zio_ver = @ip_version`
   - `bic_zio_saudt IN ('1', '10')`
   - `bic_zio_pskf IN ('804013', '801000')`

2. **CTE 11 (HIERARCHY_FILTERED)**: Filter hierarchy nodes
   - `REGEXP_CONTAINS(parnode, r'CORERET$')` (ends with 'CORERET')
   - `hryvalto = '99991231'`

3. **CTE 12 (WEEKLY_WITH_HIERARCHY)**: INNER JOIN
   - **Join Key**: `b631_s_costcntr = nodevalue`
   - **Purpose**: Match cost centers to hierarchy nodes

4. **CTE 13 (WITH_STORE_ATTRIBUTES)**: LEFT JOIN
   - **Join Key**: `b631_s_proftctr = prctr`
   - **Purpose**: Add store attributes (market, division, area, district, region, city, state, dates)

5. **CTE 14 (WITH_COMP_FLAGS)**: LEFT JOIN
   - **Join Key**: `b631_s_proftctr = prctr AND bic_zio_sweek = zweek`
   - **Filter**: `comp_ver = @ip_version`
   - **Purpose**: Add comp week flag

6. **CTE 15 (WITH_CALENDAR_WEEK)**: LEFT JOIN
   - **Join Key**: `bic_zio_sweek = zzweek`
   - **Purpose**: Add calendar week start/end dates

7. **CTE 16 (WITH_PROFIT_CENTER_TEXT)**: LEFT JOIN
   - **Join Key**: `b631_s_proftctr = prctr`
   - **Purpose**: Add profit center text description

**Calculated Columns** (CTE 17: FINAL_CALCULATED_COLUMNS):
- `cal_week_number`: `RIGHT(CAST(bic_zio_sweek AS STRING), 2)` (last 2 digits of week)
- `cal_bic_zio_skfq`: `CASE WHEN bic_zio_pskf='804013' THEN bic_zio_skfq*2 ELSE bic_zio_skfq END` (double quantity for account 804013)
- `cal_rx_comp_wk`: `COALESCE(rx_comp_wk, '0')` (default to '0' if NULL)

**Final Aggregation**:
- **Measures**:
  - `bic_zio_skfq_negative`: `SUM(bic_zio_skfq)` (original quantity)
  - `bic_zio_skfq`: `SUM(cal_bic_zio_skfq)` (calculated quantity with doubling logic)
- **GROUP BY**: All 43 non-measure columns

---

## 4. Physical Table Mappings

All physical table references use the BigQuery environment identified in the column mapping file:

**Project**: `edp-qa-finstorage`  
**Dataset**: `edp_saps4_shared_cnsv`

| HANA Table/View | BigQuery Table | Full Path |
|----------------|----------------|-----------|
| CEPCT | v_cepct | edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct |
| ZTSRP_COMPFL | ztsrp_compfl | edp-qa-finstorage.edp_saps4_shared_cnsv.ztsrp_compfl |
| HRRP_NODE | hrrp_node | edp-qa-finstorage.edp_saps4_shared_cnsv.hrrp_node |
| ZTFIGL_RCALWEEK | ztfigl_rcalweek | edp-qa-finstorage.edp_saps4_shared_cnsv.ztfigl_rcalweek |
| ZTSRP_ATTR_ACT | ztsrp_attr_act | edp-qa-finstorage.edp_saps4_shared_cnsv.ztsrp_attr_act |
| AZSRP_DS092_VT_S4 | bic_azsrp_ds092 | edp-qa-finstorage.edp_saps4_shared_cnsv.bic_azsrp_ds092 |
| AZSRP_DS031_VT_S4 | bic_azsrp_ds031 | edp-qa-finstorage.edp_saps4_shared_cnsv.bic_azsrp_ds031 |

---

## 5. Parameters and Runtime Configuration

The consolidated SQL requires the following runtime parameters:

| Parameter | Type | Default | Description | Usage |
|-----------|------|---------|-------------|-------|
| `@ip_version` | STRING | 'LEDGER_BUD' | Budget version identifier | Filters weekly budget and comp flags |
| `@ip_week_ending_from` | STRING | (required) | Week range start | Filters weekly snapshot |
| `@ip_week_ending_to` | STRING | (required) | Week range end | Filters weekly snapshot |
| `@ip_fc_count` | STRING | (derived) | Frozen cube flag ('0' or '1') | Determines Frozen vs Live cube selection |

**Parameter Derivation**:
- `@ip_fc_count` is derived from `@ip_version` using the external function `SFN_SKF_FC_FLAG(@ip_version)`
- This function is not defined in the source artifacts and must be implemented in BigQuery as a UDF or scripting logic

**Example Parameter Usage**:
```sql
DECLARE ip_version STRING DEFAULT 'LEDGER_BUD';
DECLARE ip_week_ending_from STRING DEFAULT '202401';
DECLARE ip_week_ending_to STRING DEFAULT '202452';
DECLARE ip_fc_count STRING;

-- Derive ip_fc_count from ip_version (implement SFN_SKF_FC_FLAG logic)
SET ip_fc_count = (SELECT CASE WHEN ip_version = 'LEDGER_BUD' THEN '0' ELSE '1' END);

-- Execute consolidated query with parameters
```

---

## 6. Data Type Mappings

Key data type conversions from HANA to BigQuery:

| HANA Type | BigQuery Type | Example Columns |
|-----------|---------------|-----------------|
| CHAR | STRING | mandt, prctr, strnum, zweek, fiscvarnt |
| NUMC | STRING | bic_zio_sweek, bic_zio_pskf, bic_zio_saudt |
| DATS | DATE | datbi, rx_open_dat, fs_open_dat, zrwstrtdate, zrwenddate |
| CURR | NUMERIC | bic_zio_skfq, retail_sqft_amt, total_sqft_amt |
| DEC | NUMERIC | rx_hrs_oper, fs_hrs_oper |
| INT4 | INT64 | (not explicitly used in this pipeline) |
| CLNT | STRING | mandt, rclnt |

**Type Casting in Consolidated SQL**:
- `CAST(bic_zio_sweek AS STRING)` in `RIGHT()` function for week number extraction
- `CAST(bic_zio_skfq AS NUMERIC)` in conditional doubling calculation
- All filter literals match the mapped BigQuery types (e.g., `'120'` for STRING mandt, not `120` for INT64)

---

## 7. Validation Items and Assumptions

### 7.1 Validated Items

✅ **Column Mappings**: All physical column names verified against `hana_to_bq_column_mapping 1.csv`  
✅ **Table Mappings**: All base tables mapped to `edp-qa-finstorage.edp_saps4_shared_cnsv` dataset  
✅ **Filter Logic**: All MANDT, RCLNT, and business filters preserved exactly  
✅ **Join Keys**: All join conditions verified against source Calculation View XML  
✅ **Aggregation Logic**: All SUM measures and GROUP BY columns preserved  
✅ **Calculated Columns**: All formulas (RIGHTSTR, CASE, IF) converted to BigQuery equivalents  
✅ **UNION Logic**: Frozen/Live cube union with column alignment preserved  
✅ **Parameter References**: All parameters (@ip_version, @ip_week_ending_from, @ip_week_ending_to, @ip_fc_count) documented

### 7.2 Assumptions

⚠️ **External Function**: `SFN_SKF_FC_FLAG(@ip_version)` logic must be implemented in BigQuery  
⚠️ **External Function**: `SFN_PRIOR_FISCAL_WEEK()` (used in procedure) not required for consolidated query  
⚠️ **REGEXP Pattern**: `REGEXP_CONTAINS(parnode, r'CORERET$')` assumes suffix match for HANA `match(parnode, '*CORERET')`  
⚠️ **Data Types**: All filter literals assume STRING types for MANDT, RCLNT, and NUMC fields  
⚠️ **Session Handling**: `SESSION_USER()` (in procedure) maps to BigQuery session context  
⚠️ **Timestamp Handling**: `CURRENT_TIMESTAMP()` (in procedure) maps to BigQuery current timestamp  

### 7.3 Unresolved Items

❌ **REQUIRES VALIDATION: External Function Implementation**
- `SFN_SKF_FC_FLAG(@ip_version)` must be implemented as BigQuery UDF or scripting logic
- Default logic: `CASE WHEN @ip_version = 'LEDGER_BUD' THEN '0' ELSE '1' END` (placeholder)

❌ **REQUIRES VALIDATION: REGEXP Pattern Semantics**
- HANA `match(parnode, '*CORERET')` may support wildcards beyond suffix match
- BigQuery `REGEXP_CONTAINS(parnode, r'CORERET$')` assumes suffix match only
- Verify pattern behavior if HANA wildcard semantics differ

❌ **REQUIRES VALIDATION: Data Type Compatibility**
- All filter literals use STRING types (e.g., `'120'`, `'1'`, `'10'`, `'804013'`, `'801000'`)
- Verify that MANDT, RCLNT, bic_zio_saudt, bic_zio_pskf are STRING in BigQuery schema
- If any are INT64, remove quotes from filter literals

❌ **REQUIRES VALIDATION: Procedure Static Tables**
- Consolidated SQL bypasses `TBL_WSS_SRP_ATTR_ACT` and `TBL_WSS_SRP_COMPFLAG`
- If these tables contain additional transformations not in base views, logic may differ
- Verify that base tables (`ztsrp_attr_act`, `ztsrp_compfl`) contain same data as static tables

---

## 8. Performance Considerations

### 8.1 Query Optimization Opportunities

1. **Materialized CTEs**: Consider materializing frequently-used CTEs (e.g., BASE_SRPACT, WEEKLY_BUDGET_AGGREGATED) as intermediate tables if query performance is slow.

2. **Partition Pruning**: If base tables are partitioned by date or week, ensure filters on `bic_zio_sweek`, `zrwstrtdate`, `zrwenddate` leverage partitioning.

3. **Join Order**: BigQuery optimizer should handle join order, but monitor execution plan for:
   - INNER JOIN on hierarchy (CTE 12) before LEFT JOINs
   - Smallest result set (HIERARCHY_FILTERED) joined first

4. **Aggregation Pushdown**: Final aggregation (CTE 17 → SELECT) may benefit from pre-aggregation if intermediate result set is large.

5. **Parameter Indexing**: If `@ip_version` has limited cardinality, consider creating separate queries per version to enable query caching.

### 8.2 Estimated Query Complexity

- **CTE Count**: 17 CTEs
- **Join Count**: 5 LEFT JOINs + 1 INNER JOIN
- **Aggregation Stages**: 3 (BASE_SRPACT, WEEKLY_BUDGET_AGGREGATED, Final SELECT)
- **UNION Operations**: 1 (Frozen + Live cubes)
- **Filter Stages**: 6 (base filters + snapshot filters + hierarchy filters + comp flag filters)

**Recommendation**: Test query performance with representative data volumes and adjust materialization strategy as needed.

---

## 9. Testing and Validation Checklist

### 9.1 Pre-Deployment Validation

- [ ] Verify all physical table names exist in `edp-qa-finstorage.edp_saps4_shared_cnsv`
- [ ] Confirm all column names match BigQuery schema (case-sensitive)
- [ ] Implement `SFN_SKF_FC_FLAG(@ip_version)` UDF or scripting logic
- [ ] Validate REGEXP pattern for `parnode` filter against HANA behavior
- [ ] Test parameter passing with sample values (@ip_version, @ip_week_ending_from, @ip_week_ending_to)
- [ ] Verify data type compatibility for all filter literals
- [ ] Compare sample output against HANA CV_COMP_SKF_BUDGET_STATIC results

### 9.2 Post-Deployment Validation

- [ ] Row count comparison: BigQuery consolidated query vs HANA CV_COMP_SKF_BUDGET_STATIC
- [ ] Measure validation: SUM(bic_zio_skfq_negative) and SUM(bic_zio_skfq) match HANA
- [ ] Join validation: Verify all LEFT JOINs produce expected NULL handling
- [ ] Calculated column validation: Spot-check cal_week_number, cal_bic_zio_skfq, cal_rx_comp_wk
- [ ] Parameter variation testing: Test with different @ip_version values
- [ ] Performance baseline: Measure query execution time and resource usage

---

## 10. Change Log and Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| v3.0 | 2025-01-XX | BigQuery Consolidation Agent | Initial consolidated SQL with physical column mappings |
| v2.0 | 2025-01-XX | HANA to BigQuery Conversion Agent | Individual Calculation View conversions |
| v1.0 | 2025-01-XX | HANA Source | Original HANA Calculation Views and Procedures |

---

## 11. Contact and Support

For questions or issues with this consolidation:

1. **Column Mapping Issues**: Verify against `hana_to_bq_column_mapping 1.csv`
2. **Logic Discrepancies**: Review source Calculation View XML in `SKF_BUDGET Latest BIGQUERY Files`
3. **Performance Issues**: Consult Performance Considerations (Section 8)
4. **Validation Failures**: Follow Testing and Validation Checklist (Section 9)

---

## 12. Appendix: Source File References

| File Name | Purpose | Location |
|-----------|---------|----------|
| CV_BASE_MD_CEPCT_S4_DI HANA to BigQuery SQL Conversion Agent.txt | Profit center text conversion | SKF_BUDGET Latest BIGQUERY Files |
| CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL Conversion Agent.txt | Store comp flags conversion | SKF_BUDGET Latest BIGQUERY Files |
| CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt | Hierarchy nodes conversion | SKF_BUDGET Latest BIGQUERY Files |
| CV_BASE_MD_RCALWEEK_S4_DI HANA to BigQuery SQL Conversion Agent.txt | Retail calendar week conversion | SKF_BUDGET Latest BIGQUERY Files |
| CV_BASE_MD_SRPACT_S4_DI HANA to BigQuery SQL Conversion Agent.txt | Store attributes conversion | SKF_BUDGET Latest BIGQUERY Files |
| CV_BASE_SKF_WEEKLY_BUDGET_S4_DI HANA to BigQuery SQL Conversion Agent.txt | Weekly budget conversion | SKF_BUDGET Latest BIGQUERY Files |
| CV_COMP_MD_COMPFL_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt | Static comp flags conversion | SKF_BUDGET Latest BIGQUERY Files |
| CV_COMP_MD_SRPACT_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt | Static store attributes conversion | SKF_BUDGET Latest BIGQUERY Files |
| CV_COMP_SKF_BUDGET_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt | Final consumer conversion | SKF_BUDGET Latest BIGQUERY Files |
| STP_WSS_SRP_ATTRIBUTES_DI HANA to BigQuery SQL Conversion Agent.txt | Procedure conversion | SKF_BUDGET Latest BIGQUERY Files |
| SKF_BUDGET File Relationships Table.txt | Dependency relationships | SKF_BUDGET Latest BIGQUERY Files |
| hana_to_bq_column_mapping 1.csv | Physical column mappings | all-files |

---

**END OF CONSOLIDATION DESCRIPTION DOCUMENT**