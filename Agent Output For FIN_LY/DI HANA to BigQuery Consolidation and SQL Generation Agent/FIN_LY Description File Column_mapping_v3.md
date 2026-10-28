# FIN_LY Consolidation Description
## BigQuery SQL Consolidation Agent — CV_COMP_FIN_ACTUAL_STATIC

---

## 1. Pre-Consolidation Input Confirmation

### Lineage Rows Read (11 rows from FIN_LY File Relationships Table latest)

| # | Source File | Target File | Relationship |
|---|-------------|-------------|--------------|
| 1 | CV_BASE_MD_SRPACT_S4 | STP_WSS_SRP_ATTRIBUTES | Source Dependency |
| 2 | CV_BASE_MD_COMPFL_S4 | STP_WSS_SRP_ATTRIBUTES | Source Dependency |
| 3 | STP_WSS_SRP_ATTRIBUTES | CV_COMP_MD_SRPACT_STATIC | Stored Procedure Dependency |
| 4 | STP_WSS_SRP_ATTRIBUTES | CV_COMP_MD_COMPFL_STATIC | Stored Procedure Dependency |
| 5 | CV_BASE_FIN_WEEKLY_ACTUAL_S4 | CV_COMP_FIN_ACTUAL_STATIC | Calculation View Dependency |
| 6 | CV_COMP_MD_SRPACT_STATIC | CV_COMP_FIN_ACTUAL_STATIC | Calculation View Dependency |
| 7 | GL_HEIR.CV_BASE_MD_HRRP_NODE_S4 | CV_COMP_FIN_ACTUAL_STATIC | Calculation View Dependency |
| 8 | PC_HEIR.CV_BASE_MD_HRRP_NODE_S4 | CV_COMP_FIN_ACTUAL_STATIC | Calculation View Dependency |
| 9 | CV_BASE_MD_RCALWEEL_S4 | CV_COMP_FIN_ACTUAL_STATIC | Calculation View Dependency |
| 10 | CV_COMP_MD_COMPFL_STATIC | CV_COMP_FIN_ACTUAL_STATIC | Calculation View Dependency |
| 11 | CV_BASE_MD_CEPCT_S4 | CV_COMP_FIN_ACTUAL_STATIC | Calculation View Dependency |

### Files in FIN_LY latest BIGQUERY files (13 files — all read)

| File | Classification | Reason |
|------|----------------|--------|
| CV_COMP_FIN_ACTUAL_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Final consumer artifact |
| CV_BASE_FIN_WEEKLY_ACTUAL_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency of final consumer |
| STP_WSS_SRP_ATTRIBUTES_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Procedure that populates staging tables consumed by CV_COMP_MD_SRPACT_STATIC and CV_COMP_MD_COMPFL_STATIC |
| CV_COMP_MD_SRPACT_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency of final consumer (store attributes) |
| CV_COMP_MD_COMPFL_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency of final consumer (comp flags) |
| CV_BASE_MD_SRPACT_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Source of STP_WSS_SRP_ATTRIBUTES → feeds STORE_ATTR_ACTUAL |
| CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Source of STP_WSS_SRP_ATTRIBUTES → feeds COMP_FLAG_LY |
| CV_BASE_MD_RCALWEEL_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency of final consumer (retail calendar) |
| CV_BASE_MD_CEPCT_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | Direct dependency of final consumer (profit center text) |
| GL_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | G/L hierarchy dependency of final consumer |
| PC_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt | **USED** | PC hierarchy dependency of final consumer |

> **Note:** Both GL_HEIR and PC_HEIR files share the same base artifact (CV_BASE_MD_HRRP_NODE_S4 / HRRP_NODE) but are used with different filters in the final consumer. Both are classified USED.

### Columns_Mapping.csv — Rows Read
Full CSV read: **all rows** across tables CEPCT, ZTFIGL_RCALWEEK, ZTSRP_COMPFL, ZTSRP_ATTR_ACT, HRRP_NODE, AZSRP_DS041_VT_S4, AZSRP_DS052_VT_S4, AZSRP_DS112_VT_S4, AZSRP_DS072_VT_S4, AZSRP_DS092_VT_S4, AZSRP_DS031_VT_S4, ACDOCA_VT_S4, BKPF, FAGLSKF_PN.

---

## 2. Final Consumer Identification

**Final Consumer:** `CV_COMP_FIN_ACTUAL_STATIC`

This is the only artifact in the lineage that has no outbound edges (i.e., nothing depends on it in the supplied lineage table). All other artifacts are upstream dependencies.

---

## 3. Artifact Dependency Mapping and Lineage Edge Tracing

### Dependency Chain

```
CV_COMP_FIN_ACTUAL_STATIC  (final consumer)
├── CV_BASE_FIN_WEEKLY_ACTUAL_S4
│   └── AZSRP_DS072_VT_S4  →  BQ: edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds212
├── PC_HEIR.CV_BASE_MD_HRRP_NODE_S4
│   └── HRRP_NODE           →  BQ: edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node
├── GL_HEIR.CV_BASE_MD_HRRP_NODE_S4
│   └── HRRP_NODE           →  BQ: edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node
├── CV_COMP_MD_SRPACT_STATIC
│   └── STP_WSS_SRP_ATTRIBUTES (procedure)
│       └── CV_BASE_MD_SRPACT_S4
│           └── ZTSRP_ATTR_ACT  →  BQ: edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act
├── CV_BASE_MD_RCALWEEK_S4
│   └── ZTFIGL_RCALWEEK     →  BQ: edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek
├── CV_COMP_MD_COMPFL_STATIC
│   └── STP_WSS_SRP_ATTRIBUTES (procedure)
│       └── CV_BASE_MD_COMPFL_S4
│           └── ZTSRP_COMPFL  →  BQ: edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl
└── CV_BASE_MD_CEPCT_S4
    └── CEPCT               →  BQ: edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct
```

### Lineage Edge → SQL Location Mapping

| Lineage Edge | Resulting SQL Location |
|---|---|
| CV_BASE_FIN_WEEKLY_ACTUAL_S4 → CV_COMP_FIN_ACTUAL_STATIC | CTE 1: WEEKLY_SNAPSHOT_DS05 |
| PC_HEIR.CV_BASE_MD_HRRP_NODE_S4 → CV_COMP_FIN_ACTUAL_STATIC | CTE 2: PC_HIER + CTE 3: Join_WeeklySnapshot_PC_Hier |
| GL_HEIR.CV_BASE_MD_HRRP_NODE_S4 → CV_COMP_FIN_ACTUAL_STATIC | CTE 4: GL_HIER + CTE 5: Join_GL_Hier |
| CV_COMP_MD_SRPACT_STATIC → CV_COMP_FIN_ACTUAL_STATIC | CTE 6: STORE_ATTR_ACTUAL + CTE 7: Join_Projection_StoreAttr |
| STP_WSS_SRP_ATTRIBUTES → CV_COMP_MD_SRPACT_STATIC | Inlined into CTE 6 (procedure SELECT body replaces staging table) |
| CV_BASE_MD_SRPACT_S4 → STP_WSS_SRP_ATTRIBUTES | Inlined into CTE 6 (physical source v_ztsrp_attr_act) |
| CV_BASE_MD_RCALWEEL_S4 → CV_COMP_FIN_ACTUAL_STATIC | CTE 8: RETAIL_CAL + CTE 9: Join_RetailCal |
| CV_COMP_MD_COMPFL_STATIC → CV_COMP_FIN_ACTUAL_STATIC | CTE 10: COMP_FLAG_LY + CTE 11: Join_CompFlag |
| STP_WSS_SRP_ATTRIBUTES → CV_COMP_MD_COMPFL_STATIC | Inlined into CTE 10 (procedure SELECT body replaces staging table) |
| CV_BASE_MD_COMPFL_S4 → STP_WSS_SRP_ATTRIBUTES | Inlined into CTE 10 (physical source v_ztsrp_compfl) |
| CV_BASE_MD_CEPCT_S4 → CV_COMP_FIN_ACTUAL_STATIC | CTE 12: PROFIT_CENTER_TEXT + CTE 13: Join_ProfitCenterText |

---

## 4. Final-Consumer Transformation Flow / Node Sequence

The final consumer CV_COMP_FIN_ACTUAL_STATIC defines this node sequence (preserved exactly):

1. Read weekly actuals (CV_BASE_FIN_WEEKLY_ACTUAL_S4) with filters on FISCVARNT, _BIC_ZIO_VER, _BIC_ZIO_SWEEK, _BIC_ZIO_SAUDT → **CTE 1**
2. Inner-join with PC hierarchy (PC_HEIR.CV_BASE_MD_HRRP_NODE_S4) on PARNODE LIKE '%CORE_RET%' → **CTEs 2–3**
3. Inner-join with GL hierarchy (GL_HEIR.CV_BASE_MD_HRRP_NODE_S4) on PARNODE LIKE '%181' AND HRYID='CVS2' → **CTEs 4–5**
4. Add CAL_WEEK calculated column (@ip_week_cy) → **Inline in CTE 5**
5. Left-join with store attributes (CV_COMP_MD_SRPACT_STATIC) → **CTEs 6–7**
6. Left-join with retail calendar (CV_BASE_MD_RCALWEEK_S4) on CAL_WEEK = ZZWEEK → **CTEs 8–9**
7. Left-join with comp flags (CV_COMP_MD_COMPFL_STATIC) filtered by ZWEEK = @ip_week_cy AND COMP_VER = @ip_version_comp_flag → **CTEs 10–11**
8. Left-join with profit center text (CV_BASE_MD_CEPCT_S4) → **CTEs 12–13**
9. Compute CAL_FS_RX_FLAG, CAL_COMP_FLAG, CAL_WEEK_NUMBER → **CTE 14: FLAGS**
10. Final aggregation (CUBE/Aggregation): SUM measures, GROUP BY dimensions, calculated measure b631_s_amount = SUM * -1 → **Final SELECT**

---

## 5. Dependency Expansion and Point-of-Consumption Mapping

### CV_BASE_FIN_WEEKLY_ACTUAL_S4
- **Expanded at:** CTE 1 (WEEKLY_SNAPSHOT_DS05)
- **Physical source:** `edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds212` (HANA: AZSRP_DS072_VT_S4)
- **Logic:** Project all columns, filter mandt IN ('110','200') [from CV_BASE_FIN_WEEKLY_ACTUAL_S4], then apply consumer filters fiscvarnt='K4', bic_zio_ver=@ip_version, bic_zio_sweek=@ip_week_ly, bic_zio_saudt IN ('1','10'). Aggregate measures by SUM (CUBE semantics).

### PC_HEIR.CV_BASE_MD_HRRP_NODE_S4
- **Expanded at:** CTE 2 (PC_HIER) + CTE 3 (Join_WeeklySnapshot_PC_Hier)
- **Physical source:** `edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node` (HANA: HRRP_NODE)
- **Logic:** Filter mandt IN ('120','200'), parnode LIKE '%CORE_RET%', hryvalto = DATE '9999-12-31'. INNER JOIN to actuals on b631_s_proftctr = nodevalue.

### GL_HEIR.CV_BASE_MD_HRRP_NODE_S4
- **Expanded at:** CTE 4 (GL_HIER) + CTE 5 (Join_GL_Hier)
- **Physical source:** `edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node` (same physical table, different filter)
- **Logic:** Filter mandt IN ('120','200'), parnode LIKE '%181', hryvalto = DATE '9999-12-31', hryid = 'CVS2'. Compute cal_node_value = LTRIM(nodevalue,'0'). INNER JOIN to actuals on b631_s_gl_acct = nodevalue.

### CV_COMP_MD_SRPACT_STATIC (via STP_WSS_SRP_ATTRIBUTES → CV_BASE_MD_SRPACT_S4)
- **Expanded at:** CTE 6 (STORE_ATTR_ACTUAL) + CTE 7 (Join_Projection_StoreAttr)
- **Physical source:** `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act` (HANA: ZTSRP_ATTR_ACT)
- **Procedure inlining:** STP_WSS_SRP_ATTRIBUTES performs DELETE → INSERT from CV_BASE_MD_SRPACT_S4 into TBL_WSS_SRP_ATTR_ACT (no row-level filter on the store-attributes INSERT). CV_BASE_MD_SRPACT_S4 applies mandt IN ('120','200') [note: source file shows 120,200 as numeric; mapped to STRING '120','200' per BQ_DATATYPE]. CV_COMP_MD_SRPACT_STATIC is a CUBE/Aggregation view over TBL_WSS_SRP_ATTR_ACT. All three layers are inlined into CTE 6.
- **Logic:** Filter mandt IN ('120','200'), aggregate measure columns (rx_hrs_oper, fs_hrs_oper, rx_store, retail_sqft_amt, total_sqft_amt) by SUM, GROUP BY all non-measure columns. LEFT JOIN to actuals on b631_s_proftctr = prctr.

### CV_BASE_MD_RCALWEEL_S4
- **Expanded at:** CTE 8 (RETAIL_CAL) + CTE 9 (Join_RetailCal)
- **Physical source:** `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek` (HANA: ZTFIGL_RCALWEEK)
- **Logic:** Filter rclnt IN ('120','200') [numeric 120,200 in source → STRING per BQ_DATATYPE]. LEFT JOIN to actuals on cal_week = zzweek AND mandt = rclnt.

### CV_COMP_MD_COMPFL_STATIC (via STP_WSS_SRP_ATTRIBUTES → CV_BASE_MD_COMPFL_S4)
- **Expanded at:** CTE 10 (COMP_FLAG_LY) + CTE 11 (Join_CompFlag)
- **Physical source:** `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl` (HANA: ZTSRP_COMPFL)
- **Procedure inlining:** STP_WSS_SRP_ATTRIBUTES inserts from CV_BASE_MD_COMPFL_S4 into TBL_WSS_SRP_COMPFLAG with filter ZWEEK = V_WEEK (= @v_week, the prior fiscal week from SFN_PRIOR_FISCAL_WEEK()). CV_BASE_MD_COMPFL_S4 applies mandt IN ('110','200'). CV_COMP_MD_COMPFL_STATIC is a DIMENSION/Projection view (row-level). The final consumer adds zweek = @ip_week_cy AND comp_ver = @ip_version_comp_flag. All filters are preserved at their respective logical stages in CTE 10.
- **Logic:** Filter mandt IN ('110','200'), zweek = @v_week (procedure), zweek = @ip_week_cy (consumer), comp_ver = @ip_version_comp_flag (consumer). LEFT JOIN to actuals on b631_s_proftctr = prctr.

### CV_BASE_MD_CEPCT_S4
- **Expanded at:** CTE 12 (PROFIT_CENTER_TEXT) + CTE 13 (Join_ProfitCenterText)
- **Physical source:** `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct` (HANA: CEPCT)
- **Logic:** Filter mandt IN ('120','200') [numeric 120,200 → STRING]. Output ltext as profit_center_text. LEFT JOIN to actuals on b631_s_proftctr = prctr.

---

## 6. USED / NOT USED Classification

| File | Status | Reason |
|------|--------|--------|
| CV_COMP_FIN_ACTUAL_STATIC | USED | Final consumer |
| CV_BASE_FIN_WEEKLY_ACTUAL_S4 | USED | Direct source of financial actuals |
| STP_WSS_SRP_ATTRIBUTES | USED | Procedure whose INSERT…SELECT bodies are inlined for both staging tables |
| CV_COMP_MD_SRPACT_STATIC | USED | Wrapper view over TBL_WSS_SRP_ATTR_ACT; aggregation logic inlined |
| CV_COMP_MD_COMPFL_STATIC | USED | Wrapper view over TBL_WSS_SRP_COMPFLAG; projection logic inlined |
| CV_BASE_MD_SRPACT_S4 | USED | Physical source logic for store attributes |
| CV_BASE_MD_COMPFL_S4 | USED | Physical source logic for comp flags |
| CV_BASE_MD_RCALWEEL_S4 | USED | Retail calendar dimension |
| CV_BASE_MD_CEPCT_S4 | USED | Profit center text dimension |
| GL_HEIR.CV_BASE_MD_HRRP_NODE_S4 | USED | G/L account hierarchy |
| PC_HEIR.CV_BASE_MD_HRRP_NODE_S4 | USED | Profit center hierarchy |

---

## 7. Filter Trace (per USED file → resulting SQL clause)

| Source File | Filter | Resulting SQL Location |
|---|---|---|
| CV_BASE_FIN_WEEKLY_ACTUAL_S4 | MANDT IN ('110','200') | CTE 1 WHERE clause |
| CV_COMP_FIN_ACTUAL_STATIC | FISCVARNT = 'K4' | CTE 1 WHERE clause |
| CV_COMP_FIN_ACTUAL_STATIC | _BIC_ZIO_VER = @IP_VERSION | CTE 1 WHERE clause (bic_zio_ver = @ip_version) |
| CV_COMP_FIN_ACTUAL_STATIC | _BIC_ZIO_SWEEK = @IP_WEEK_LY | CTE 1 WHERE clause (bic_zio_sweek = @ip_week_ly) |
| CV_COMP_FIN_ACTUAL_STATIC | _BIC_ZIO_SAUDT IN ('1','10') | CTE 1 WHERE clause |
| PC_HEIR.CV_BASE_MD_HRRP_NODE_S4 | MANDT IN ('120','200') | CTE 2 WHERE clause |
| PC_HEIR.CV_BASE_MD_HRRP_NODE_S4 | PARNODE LIKE '%CORE_RET%' | CTE 2 WHERE clause |
| PC_HEIR.CV_BASE_MD_HRRP_NODE_S4 | HRYVALTO = '99991231' (DATE '9999-12-31') | CTE 2 WHERE clause |
| GL_HEIR.CV_BASE_MD_HRRP_NODE_S4 | MANDT IN ('120','200') | CTE 4 WHERE clause |
| GL_HEIR.CV_BASE_MD_HRRP_NODE_S4 | PARNODE LIKE '%181' | CTE 4 WHERE clause |
| GL_HEIR.CV_BASE_MD_HRRP_NODE_S4 | HRYVALTO = '99991231' (DATE '9999-12-31') | CTE 4 WHERE clause |
| GL_HEIR.CV_BASE_MD_HRRP_NODE_S4 | HRYID = 'CVS2' | CTE 4 WHERE clause |
| CV_BASE_MD_SRPACT_S4 | MANDT IN ('120','200') | CTE 6 WHERE clause |
| CV_BASE_MD_RCALWEEL_S4 | RCLNT IN ('120','200') | CTE 8 WHERE clause |
| CV_BASE_MD_COMPFL_S4 | MANDT IN ('110','200') | CTE 10 WHERE clause |
| STP_WSS_SRP_ATTRIBUTES | ZWEEK = V_WEEK (= @v_week) | CTE 10 WHERE clause |
| CV_COMP_FIN_ACTUAL_STATIC | ZWEEK = @IP_WEEK_CY | CTE 10 WHERE clause |
| CV_COMP_FIN_ACTUAL_STATIC | COMP_VER = @IP_VERSION_COMP_FLAG | CTE 10 WHERE clause |
| CV_BASE_MD_CEPCT_S4 | MANDT IN ('120','200') | CTE 12 WHERE clause |

---

## 8. Join Trace

| Join | Type | Condition | SQL Location |
|---|---|---|---|
| Actuals × PC Hierarchy | INNER JOIN | b631_s_proftctr = nodevalue AND mandt = mandt | CTE 3 |
| PC-filtered Actuals × GL Hierarchy | INNER JOIN | b631_s_gl_acct = nodevalue AND mandt = mandt | CTE 5 |
| GL-filtered Actuals × Store Attributes | LEFT JOIN | b631_s_proftctr = prctr AND mandt = mandt | CTE 7 |
| Store-enriched Actuals × Retail Calendar | LEFT JOIN | cal_week = zzweek AND mandt = rclnt | CTE 9 |
| Calendar-enriched Actuals × Comp Flags | LEFT JOIN | b631_s_proftctr = prctr AND mandt = mandt | CTE 11 |
| Comp-flag-enriched Actuals × PC Text | LEFT JOIN | b631_s_proftctr = prctr AND mandt = mandt | CTE 13 |

---

## 9. Aggregation Trace

| Stage | Aggregation | Location |
|---|---|---|
| CV_BASE_FIN_WEEKLY_ACTUAL_S4 (CUBE) | SUM(b631_s_amount, bic_zio_d1amt..d7amt) GROUP BY all dimensions | CTE 1 |
| CV_BASE_MD_SRPACT_S4 / CV_COMP_MD_SRPACT_STATIC (CUBE) | SUM(rx_hrs_oper, fs_hrs_oper, rx_store, retail_sqft_amt, total_sqft_amt) GROUP BY all non-measure columns | CTE 6 |
| CV_COMP_FIN_ACTUAL_STATIC (CUBE — final) | SUM(b631_s_amount)*-1, SUM(bic_zio_d1amt..d7amt) GROUP BY all non-measure output columns | Final SELECT |

---

## 10. Calculation Trace

| Calculated Column | Logic | Source File | SQL Location |
|---|---|---|---|
| fs_rx_flag (CAL_FS_RX_FLAG) | CASE LEFT(bic_zwwpc_pa1,2): 'FS'→'FS', 'RX'→'RX', else '' | CV_COMP_FIN_ACTUAL_STATIC | CTE 14 FLAGS |
| comp_flag (CAL_COMP_FLAG) | CASE fs_rx_flag: 'FS'→fs_comp_wk, 'RX'→rx_comp_wk, else fs_comp_wk | CV_COMP_FIN_ACTUAL_STATIC | CTE 14 FLAGS |
| cal_week_number | RIGHT(@ip_week_cy, 2) | CV_COMP_FIN_ACTUAL_STATIC | CTE 14 FLAGS |
| cal_week | @ip_week_cy (literal parameter) | CV_COMP_FIN_ACTUAL_STATIC | CTE 5 Join_GL_Hier |
| cal_node_value | LTRIM(nodevalue,'0') | GL_HEIR.CV_BASE_MD_HRRP_NODE_S4 | CTE 4 GL_HIER |
| b631_s_amount (final) | SUM(b631_s_amount) * -1 | CV_COMP_FIN_ACTUAL_STATIC | Final SELECT |

---

## 11. Parameter Documentation

| Parameter | Type | Source | Usage | Notes |
|---|---|---|---|---|
| @ip_version | STRING | CV_COMP_FIN_ACTUAL_STATIC input parameter IP_VERSION | Filter bic_zio_ver = @ip_version in CTE 1 | Supplied at runtime |
| @ip_week_ly | STRING | CV_COMP_FIN_ACTUAL_STATIC input parameter IP_WEEK_LY | Filter bic_zio_sweek = @ip_week_ly in CTE 1 | Supplied at runtime |
| @ip_week_cy | STRING | CV_COMP_FIN_ACTUAL_STATIC input parameter IP_WEEK_CY | cal_week column (CTE 5), cal_week_number RIGHT(@ip_week_cy,2) (CTE 14), zweek = @ip_week_cy filter (CTE 10) | Supplied at runtime |
| @ip_version_comp_flag | STRING | CV_COMP_FIN_ACTUAL_STATIC input parameter IP_VERSION_COMP_FLAG | Filter comp_ver = @ip_version_comp_flag in CTE 10 | Supplied at runtime |
| @v_week | STRING | STP_WSS_SRP_ATTRIBUTES variable V_WEEK = SFN_PRIOR_FISCAL_WEEK() | Filter zweek = @v_week in CTE 10 | Replaces unresolved HANA scalar function SFN_PRIOR_FISCAL_WEEK(); value must be supplied at runtime. Non-blocking finding. |

---

## 12. Table and Column Mapping Applied

### Physical Tables Referenced and Their BQ Mappings

| HANA Table | BQ_FULL_TABLE | Used In |
|---|---|---|
| AZSRP_DS072_VT_S4 | edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds212 | CTE 1 |
| HRRP_NODE | edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node | CTEs 2, 4 |
| ZTSRP_ATTR_ACT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act | CTE 6 |
| ZTFIGL_RCALWEEK | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek | CTE 8 |
| ZTSRP_COMPFL | edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl | CTE 10 |
| CEPCT | edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct | CTE 12 |

### Key Column Mappings Applied (HANA → BQ_COLUMN)

| HANA Table | HANA_COLUMN_SQL | BQ_COLUMN | BQ_DATATYPE | Used In |
|---|---|---|---|---|
| AZSRP_DS072_VT_S4 | _B631_S_AMOUNT | b631_s_amount | NUMERIC | CTE 1, Final SELECT |
| AZSRP_DS072_VT_S4 | _B631_S_CHRTACCT | b631_s_chrtacct | STRING | CTE 1 |
| AZSRP_DS072_VT_S4 | _B631_S_CO_AREA | b631_s_co_area | STRING | CTE 1 |
| AZSRP_DS072_VT_S4 | _B631_S_PROFTCTR | b631_s_proftctr | STRING | CTEs 1,3,5,7,9,11,13 |
| AZSRP_DS072_VT_S4 | _B631_S_COSTCNTR | b631_s_costcntr | STRING | CTE 1 |
| AZSRP_DS072_VT_S4 | _B631_S_FUNCAREA | b631_s_funcarea | STRING | CTE 1 |
| AZSRP_DS072_VT_S4 | _B631_S_GL_ACCT | b631_s_gl_acct | STRING | CTEs 1,5 |
| AZSRP_DS072_VT_S4 | _BIC_ZIO_SWEEK | bic_zio_sweek | STRING | CTE 1 |
| AZSRP_DS072_VT_S4 | _BIC_ZIO_VER | bic_zio_ver | STRING | CTE 1 |
| AZSRP_DS072_VT_S4 | _BIC_ZIO_SAUDT | bic_zio_saudt | STRING | CTE 1 |
| AZSRP_DS072_VT_S4 | _BIC_ZIO_CMPCD | bic_zio_cmpcd | STRING | CTE 1 |
| AZSRP_DS072_VT_S4 | _BIC_ZWWPC_PA1 | bic_zwwpc_pa1 | STRING | CTE 1, CTE 14 |
| AZSRP_DS072_VT_S4 | _BIC_ZWWSC_PA1 | bic_zwwsc_pa1 | STRING | CTE 1 |
| AZSRP_DS072_VT_S4 | /BIC/ZIO_D1AMT..D7AMT | bic_zio_d1amt..d7amt | NUMERIC | CTE 1, Final SELECT |
| HRRP_NODE | MANDT | mandt | STRING | CTEs 2, 4 |
| HRRP_NODE | HRYVALTO | hryvalto | DATE | CTEs 2, 4 |
| HRRP_NODE | NODEVALUE | nodevalue | STRING | CTEs 2, 4 |
| HRRP_NODE | PARNODE | parnode | STRING | CTEs 2, 4 |
| HRRP_NODE | HRYID | hryid | STRING | CTE 4 |
| ZTSRP_ATTR_ACT | PRCTR | prctr | STRING | CTE 6 |
| ZTSRP_ATTR_ACT | MANDT | mandt | STRING | CTE 6 |
| ZTSRP_ATTR_ACT | REP_MKT_CODE | rep_mkt_code | STRING | CTE 6 |
| ZTSRP_ATTR_ACT | EMERG_MKT_IND | emerg_mkt_ind | STRING | CTE 6 |
| ZTSRP_ATTR_ACT | RX_HRS_OPER | rx_hrs_oper | NUMERIC | CTE 6 |
| ZTSRP_ATTR_ACT | FS_HRS_OPER | fs_hrs_oper | NUMERIC | CTE 6 |
| ZTSRP_ATTR_ACT | RX_STORE | rx_store | INT64 | CTE 6 |
| ZTSRP_ATTR_ACT | RETAIL_SQFT_AMT | retail_sqft_amt | NUMERIC | CTE 6 |
| ZTSRP_ATTR_ACT | TOTAL_SQFT_AMT | total_sqft_amt | NUMERIC | CTE 6 |
| ZTFIGL_RCALWEEK | RCLNT | rclnt | STRING | CTE 8 |
| ZTFIGL_RCALWEEK | ZZWEEK | zzweek | STRING | CTE 8 |
| ZTFIGL_RCALWEEK | ZRWSTRTDATE | zrwstrtdate | DATE | CTE 8 |
| ZTFIGL_RCALWEEK | ZRWENDDATE | zrwenddate | DATE | CTE 8 |
| ZTSRP_COMPFL | MANDT | mandt | STRING | CTE 10 |
| ZTSRP_COMPFL | PRCTR | prctr | STRING | CTE 10 |
| ZTSRP_COMPFL | ZWEEK | zweek | STRING | CTE 10 |
| ZTSRP_COMPFL | COMP_VER | comp_ver | STRING | CTE 10 |
| ZTSRP_COMPFL | FS_COMP_WK | fs_comp_wk | STRING | CTE 10 |
| ZTSRP_COMPFL | RX_COMP_WK | rx_comp_wk | STRING | CTE 10 |
| CEPCT | MANDT | mandt | STRING | CTE 12 |
| CEPCT | PRCTR | prctr | STRING | CTE 12 |
| CEPCT | LTEXT | ltext | STRING | CTE 12 (aliased as profit_center_text) |

---

## 13. Data Type Casts and Literal Conversions Applied

| Location | Original Value / Type | Converted Value / Type | Reason |
|---|---|---|---|
| CTE 1 WHERE mandt | Numeric 110, 200 (HANA CLNT) | STRING '110','200' | BQ_DATATYPE for AZSRP_DS072_VT_S4.MANDT = STRING |
| CTE 2 WHERE mandt | Numeric 120, 200 (HANA CLNT) | STRING '120','200' | BQ_DATATYPE for HRRP_NODE.MANDT = STRING |
| CTE 2 WHERE hryvalto | String '99991231' (HANA DATS) | DATE '9999-12-31' | BQ_DATATYPE for HRRP_NODE.HRYVALTO = DATE |
| CTE 4 WHERE mandt | Numeric 120, 200 | STRING '120','200' | BQ_DATATYPE for HRRP_NODE.MANDT = STRING |
| CTE 4 WHERE hryvalto | String '99991231' | DATE '9999-12-31' | BQ_DATATYPE for HRRP_NODE.HRYVALTO = DATE |
| CTE 6 WHERE mandt | Numeric 120, 200 | STRING '120','200' | BQ_DATATYPE for ZTSRP_ATTR_ACT.MANDT = STRING |
| CTE 8 WHERE rclnt | Numeric 120, 200 | STRING '120','200' | BQ_DATATYPE for ZTFIGL_RCALWEEK.RCLNT = STRING |
| CTE 10 WHERE mandt | Numeric 110, 200 | STRING '110','200' | BQ_DATATYPE for ZTSRP_COMPFL.MANDT = STRING |
| CTE 10 WHERE zweek | @v_week, @ip_week_cy | STRING parameters | BQ_DATATYPE for ZTSRP_COMPFL.ZWEEK = STRING |
| CTE 12 WHERE mandt | Numeric 120, 200 | STRING '120','200' | BQ_DATATYPE for CEPCT.MANDT = STRING |

---

## 14. Alias Check Results

All physical column names in the consolidated SQL use their exact `BQ_COLUMN` values from Columns_Mapping. No aliases of the form `bq_column AS HANA_NAME` or equivalent-name aliases remain. Meaningful renames retained:

| Expression | Alias | Justification |
|---|---|---|
| pct.ltext | profit_center_text | Real rename: ltext → profit_center_text, defined by CV_COMP_FIN_ACTUAL_STATIC output contract |
| CASE...END (fs_rx_flag) | fs_rx_flag | Calculated column defined by CV_COMP_FIN_ACTUAL_STATIC (CAL_FS_RX_FLAG → fs_rx_flag) |
| CASE...END (comp_flag) | comp_flag | Calculated column defined by CV_COMP_FIN_ACTUAL_STATIC (CAL_COMP_FLAG → comp_flag) |
| RIGHT(@ip_week_cy,2) | cal_week_number | Calculated column defined by CV_COMP_FIN_ACTUAL_STATIC |
| @ip_week_cy | cal_week | Calculated column defined by CV_COMP_FIN_ACTUAL_STATIC |
| SUM(b631_s_amount)*-1 | b631_s_amount | Calculated measure: negated sum, output alias matches BQ_COLUMN |

---

## 15. Procedure / ETL Handling

### STP_WSS_SRP_ATTRIBUTES
- **Pattern:** DELETE → INSERT…SELECT (two branches)
- **DML wrappers skipped:** DELETE FROM TBL_WSS_SRP_ATTR_ACT, DELETE FROM TBL_WSS_SRP_COMPFLAG, INSERT INTO lines, COMMIT. Non-blocking.
- **Branch 1 inlined:** INSERT INTO TBL_WSS_SRP_ATTR_ACT SELECT * FROM CV_BASE_MD_SRPACT_S4 (no WHERE filter on this branch). Inlined into CTE 6 by reading directly from v_ztsrp_attr_act with mandt IN ('120','200').
- **Branch 2 inlined:** INSERT INTO TBL_WSS_SRP_COMPFLAG SELECT * FROM CV_BASE_MD_COMPFL_S4 WHERE ZWEEK = V_WEEK. Inlined into CTE 10 with filter zweek = @v_week.
- **SNAPSHOT_TIMESTAMP / SNAPSHOT_CREATED_BY / CREATED_BY:** Audit-only columns filled by CURRENT_TIMESTAMP() and SESSION_USER() in the procedure. Not referenced by any downstream consumer logic. Dropped from the consolidated SELECT. Non-blocking.
- **V_LY_WEEK:** Declared but never used in the procedure. Dropped. Non-blocking.

---

## 16. CTE Documentation Comment Validation

All 14 CTEs and the final SELECT have standardized comment headers with accurate Logic, Source, Filters, Join, Aggregation, and Calculation fields as applicable. Comments describe consolidated logic, not individual HANA nodes.

---

## 17. Star Projection Validation

No `SELECT *` is used in the final consolidated SQL. All columns are explicitly listed. Star projections were not required.

---

## 18. Duplicate Column Check

Each CTE's SELECT was checked for duplicate aliases. No duplicates found. The column `mandt` appears in multiple CTEs (expected, as each CTE is independently scoped). Within each CTE, every alias is unique.

---

## 19. Aggregation Grain Validation

- **CTE 1:** Grain = all non-measure dimensions of AZSRP_DS072_VT_S4 after applying all filters. Correct CUBE semantics.
- **CTE 6:** Grain = all non-measure dimensions of ZTSRP_ATTR_ACT after mandt filter. Correct CUBE semantics.
- **Final SELECT:** Grain = all non-measure output columns of CV_COMP_FIN_ACTUAL_STATIC. Correct CUBE/Aggregation semantics.
- No aggregation stages collapsed or merged incorrectly.

---

## 20. Quality Gate Results

| Gate | Result |
|---|---|
| 1. Final consumer unambiguous | ✅ PASSED — CV_COMP_FIN_ACTUAL_STATIC |
| 2. Artifact dependencies match lineage | ✅ PASSED — all 11 lineage edges traced |
| 3. Final-consumer transformation order preserved | ✅ PASSED |
| 4. Dependencies expanded at point of consumption | ✅ PASSED |
| 5. No generic Source→Intermediate→Target ordering | ✅ PASSED |
| 6. Every file classified USED/NOT USED | ✅ PASSED — all 11 USED |
| 7. Every USED file participates in dependency chain | ✅ PASSED |
| 8. All converted dependencies expanded | ✅ PASSED |
| 9. Only terminal sources remain | ✅ PASSED |
| 10. Every physical source uses BQ_FULL_TABLE | ✅ PASSED — no PROJECT.DATASET placeholders remain |
| 11. Every referenced physical column mapped via Columns_Mapping | ✅ PASSED — full CSV read; all referenced columns have OK mappings |
| 12. Type consistency in all comparisons | ✅ PASSED — all literal/parameter types converted to match BQ_DATATYPE |
| 13. Final-consumer CTE names and order preserved | ✅ PASSED |
| 14. Compatible operations combined | ✅ PASSED — 14 CTEs vs. many more HANA nodes |
| 15. No HANA node becomes separate CTE merely to mirror source | ✅ PASSED |
| 16. Every helper CTE justified by real semantic boundary | ✅ PASSED |
| 17. Every CTE matches required output contract | ✅ PASSED |
| 18. All column references qualified where multiple inputs in scope | ✅ PASSED |
| 19. No duplicate aliases within any SELECT | ✅ PASSED |
| 20. No star projections requiring expansion | ✅ PASSED — no stars used |
| 21. All filters, joins, calculations, mappings, parameters preserved | ✅ PASSED |
| 22. All aggregation stages preserve required grain | ✅ PASSED |
| 23. DISTINCT, UNION, window behavior preserved | N/A — none present |
| 24. No conflict silently corrected | ✅ PASSED — all issues documented |
| 25. No result-affecting procedural behavior discarded | ✅ PASSED — both INSERT…SELECT bodies inlined with all filters |
| 26. Runtime parameters documented; single query with no DECLARE/SET | ✅ PASSED |
| 27. Every CTE has standardized comment header | ✅ PASSED |
| 28. CTE comments describe consolidated logic | ✅ PASSED |
| 29. 100% logic match using minimum CTE structure | ✅ PASSED |
| 30. Every lineage edge represented by correct supplied logic | ✅ PASSED |
| 31. Every filter, join, aggregation, parameter traced to output | ✅ PASSED |
| 32. Every physical-column output uses exact BQ_COLUMN | ✅ PASSED |

---

## 21. ISSUES TO FIX

### Non-Blocking Findings (do not prevent execution)

1. **@v_week parameter — unresolved scalar function SFN_PRIOR_FISCAL_WEEK()**
   - **Artifact:** STP_WSS_SRP_ATTRIBUTES
   - **Evidence:** Procedure sets V_WEEK = SFN_PRIOR_FISCAL_WEEK(); function definition not supplied in any converted file.
   - **Impact:** @v_week must be supplied at runtime. The filter `zweek = @v_week` in CTE 10 is preserved and correct; only the runtime value is unresolved.
   - **Resolution needed:** Provide the prior fiscal week value as @v_week at query execution time, or implement SFN_PRIOR_FISCAL_WEEK() as a BigQuery function and replace @v_week with its call.

2. **Dual zweek filter in CTE 10 (zweek = @v_week AND zweek = @ip_week_cy)**
   - **Artifact:** STP_WSS_SRP_ATTRIBUTES (procedure filter) + CV_COMP_FIN_ACTUAL_STATIC (consumer filter)
   - **Evidence:** Both filters are preserved as required by the system prompt. They are logically equivalent to requiring zweek = @v_week = @ip_week_cy at runtime (i.e., the caller must supply the same week value for both parameters, or the query returns no comp-flag rows).
   - **Impact:** If @v_week ≠ @ip_week_cy at runtime, no comp-flag rows will match. This is the correct combined effect of the procedure and consumer predicates. Validation required to confirm whether these parameters should always be equal or whether one should be removed.
   - **Resolution needed:** Confirm with business whether @v_week and @ip_week_cy are always the same value. If so, a single parameter can replace both; if not, the dual filter is intentional.

3. **SNAPSHOT_TIMESTAMP, SNAPSHOT_CREATED_BY, CREATED_BY columns dropped**
   - **Artifact:** STP_WSS_SRP_ATTRIBUTES
   - **Evidence:** These are audit columns filled by CURRENT_TIMESTAMP() and SESSION_USER() in the procedure. No downstream CTE references them.
   - **Impact:** None on business logic. Non-blocking.

4. **V_LY_WEEK variable dropped**
   - **Artifact:** STP_WSS_SRP_ATTRIBUTES
   - **Evidence:** Declared but never used in the procedure.
   - **Impact:** None. Non-blocking.

5. **HANA MANDT filter values as numeric (120, 200 / 110, 200) converted to STRING**
   - **Artifact:** CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4, CV_BASE_MD_RCALWEEL_S4, CV_BASE_MD_CEPCT_S4, GL_HEIR/PC_HEIR.CV_BASE_MD_HRRP_NODE_S4
   - **Evidence:** Source converted SQL uses numeric literals (120, 200); BQ_DATATYPE in Columns_Mapping = STRING for all mandt/rclnt columns.
   - **Impact:** Corrected — string literals '120','200','110','200' used throughout. Non-blocking.
