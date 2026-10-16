<div style="border:1px solid #d0d7de;border-radius:6px;overflow:hidden;font-family:Arial,sans-serif;width:100%;margin-bottom:15px;">
<div style="background:#1f4e79;color:white;padding:10px;font-size:16px;font-weight:bold;">
CV_COMP_FIN_ACTUAL_STATIC Analyze Report
</div>
<table style="border-collapse:collapse;width:100%;">
<tr>
<td style="padding:8px;border:1px solid #ddd;background:#f5f5f5;width:150px;"><b>Author</b></td>
<td style="padding:8px;border:1px solid #ddd;">Ascendion AAVA</td>
</tr>
<tr>
<td style="padding:8px;border:1px solid #ddd;background:#f5f5f5;"><b>Created On</b></td>
<td style="padding:8px;border:1px solid #ddd;">2026-10-16</td>
</tr>
<tr>
<td style="padding:8px;border:1px solid #ddd;background:#f5f5f5;"><b>Description</b></td>
<td style="padding:8px;border:1px solid #ddd;">HANA Calculation View aggregating weekly financial actuals from S4 with store attributes, hierarchies, and comparison flags for BigQuery migration.</td>
</tr>
</table>
</div>

---

## Asset Name : CV_COMP_FIN_ACTUAL_STATIC

---

## 1. BigQuery Recommendations

### (Best Fit)

**BigQuery Materialized View with Scheduled Refresh**

**Reason 1:** The Calculation View is an Aggregation type with multiple complex joins (7 data sources including CV_BASE_FIN_WEEKLY_ACTUAL_S4, CV_COMP_MD_SRPACT_STATIC, CV_BASE_MD_HRRP_NODE_S4, CV_BASE_MD_RCALWEEK_S4, CV_COMP_MD_COMPFL_STATIC, CV_BASE_MD_CEPCT_S4) and filters on hierarchies (PARNODE filters on '*CORE_RET*' and '*181', HRYVALTO='99991231', HRYID='CVS2'). Materialized Views in BigQuery pre-compute and store aggregated results, providing fast query performance for reporting workloads.

**Reason 2:** The view contains 6 input variables (IP_VERSION, IP_WEEK_ENDING_FROM, IP_WEEK_ENDING_TO, IP_VERSION_COMP_FLAG, IP_WEEK_LY, IP_WEEK_CY) with scalar function derivation rules (SFN_PRIOR_FISCAL_WEEK, SFN_ACTUALS_COMP_FLAG, SFN_LY_COMPARISON_WEEK). These can be implemented as BigQuery Scheduled Queries that refresh the Materialized View with parameterized values, maintaining the dynamic behavior.

**Reason 3:** The view has 8 base measures (_B631_S_AMOUNT, _BIC_ZIO_D1AMT through _BIC_ZIO_D7AMT representing daily amounts) and 1 calculated measure (_B631_S_AMOUNT = _B631_S_AMOUNT_NEGATIVE * -1) with 56 attributes. This aggregation-heavy structure with calculated fields aligns perfectly with BigQuery Materialized View capabilities, which support complex SQL expressions and aggregations.

### (Alternative)

**BigQuery View with Partitioned Base Tables**

**Reason 1:** For scenarios requiring real-time data access without pre-aggregation, a standard BigQuery View can replicate the Calculation View logic. The underlying base tables (CV_BASE_FIN_WEEKLY_ACTUAL_S4, CV_COMP_MD_SRPACT_STATIC, etc.) would be partitioned by date fields (FISCPER, _BIC_ZIO_SWEEK, ZRWENDDATE) to optimize query performance.

**Reason 2:** The filters on FISCVARNT='K4', _BIC_ZIO_VER='$$IP_VERSION$$', _BIC_ZIO_SWEEK='$$IP_WEEK_LY$$', and IN(_BIC_ZIO_SAUDT, '1', '10') can be parameterized in the BigQuery View definition, allowing flexible filtering at query time without requiring scheduled refreshes.

**Reason 3:** This approach provides flexibility for ad-hoc analysis and reduces storage costs compared to Materialized Views, though query performance will be slower due to on-the-fly computation of joins and aggregations across 7 data sources.

---

## 2. Syntax Differences

| SAP BW HANA Construct | SAP BW HANA Example from Asset | BigQuery Equivalent | BigQuery Example |
|----------------------|--------------------------------|---------------------|------------------|
| **Calculation View (Aggregation Type)** | `<Calculation:scenario calculationScenarioType="TREE_BASED" dataCategory="CUBE" outputViewType="Aggregation">` with id="CV_COMP_FIN_ACTUAL_STATIC" | **BigQuery Materialized View** | `CREATE MATERIALIZED VIEW dataset.cv_comp_fin_actual_static AS SELECT ... FROM base_tables WITH aggregations` |
| **Projection Node** | `<calculationView xsi:type="Calculation:ProjectionView" id="WEEKLY_SNAPSHOT_DS05">` with column mappings and filter `("FISCVARNT" ='K4') AND ("_BIC_ZIO_VER" ='$$IP_VERSION$$')` | **BigQuery View with SELECT and WHERE** | `CREATE VIEW weekly_snapshot_ds05 AS SELECT fiscper, fiscvarnt, ... FROM cv_base_fin_weekly_actual_s4 WHERE fiscvarnt = 'K4' AND _bic_zio_ver = @ip_version` |
| **Join Node (Inner Join)** | `<calculationView xsi:type="Calculation:JoinView" id="Join_4" joinType="inner">` joining WEEKLY_SNAPSHOT_DS05 and PC_HIER on _B631_S_PROFTCTR and MANDT | **BigQuery View with INNER JOIN** | `CREATE VIEW join_4 AS SELECT t1.*, t2.* FROM weekly_snapshot_ds05 t1 INNER JOIN pc_hier t2 ON t1._b631_s_proftctr = t2.nodevalue AND t1.mandt = t2.mandt` |
| **Join Node (Left Outer Join)** | `<calculationView xsi:type="Calculation:JoinView" id="Join_2" joinType="leftOuter">` joining Projection_1 and STORE_ATTR_ACTUAL on _B631_S_PROFTCTR=PRCTR and MANDT | **BigQuery View with LEFT OUTER JOIN** | `CREATE VIEW join_2 AS SELECT t1.*, t2.rep_mkt_code, t2.division_code, ... FROM projection_1 t1 LEFT OUTER JOIN store_attr_actual t2 ON t1._b631_s_proftctr = t2.prctr AND t1.mandt = t2.mandt` |
| **Calculated View Attribute** | `<calculatedViewAttribute id="CAL_NODE_VALUE" expressionLanguage="COLUMN_ENGINE"><formula>ltrim("NODEVALUE",'0')</formula>` in GL_HIER projection | **BigQuery Calculated Column** | `LTRIM(nodevalue, '0') AS cal_node_value` |
| **Calculated View Attribute (CASE)** | `<calculatedViewAttribute id="CAL_FS_RX_FLAG"><formula>CASE(LEFTSTR("_BIC_ZWWPC_PA1",2),'FS','FS','RX','RX','')</formula>` in FLAGS projection | **BigQuery CASE Expression** | `CASE WHEN LEFT(_bic_zwwpc_pa1, 2) = 'FS' THEN 'FS' WHEN LEFT(_bic_zwwpc_pa1, 2) = 'RX' THEN 'RX' ELSE '' END AS cal_fs_rx_flag` |
| **Calculated View Attribute (Nested CASE)** | `<calculatedViewAttribute id="CAL_COMP_FLAG"><formula>CASE("CAL_FS_RX_FLAG",'FS',"FS_COMP_WK",'RX',"RX_COMP_WK","FS_COMP_WK")</formula>` | **BigQuery Nested CASE** | `CASE WHEN cal_fs_rx_flag = 'FS' THEN fs_comp_wk WHEN cal_fs_rx_flag = 'RX' THEN rx_comp_wk ELSE fs_comp_wk END AS cal_comp_flag` |
| **Calculated Measure** | `<measure id="_B631_S_AMOUNT"><formula>"_B631_S_AMOUNT_NEGATIVE" *-1</formula>` in logicalModel | **BigQuery Calculated Field in SELECT** | `_b631_s_amount_negative * -1 AS _b631_s_amount` |
| **Input Variable with Default Value** | `<variable id="IP_VERSION"><variableProperties datatype="NVARCHAR" defaultValue="ACT01" length="20" mandatory="false">` | **BigQuery Query Parameter** | `DECLARE ip_version STRING DEFAULT 'ACT01';` or pass as parameter `@ip_version` |
| **Input Variable with Scalar Function Derivation** | `<variable id="IP_WEEK_ENDING_FROM"><derivationRule inputEnabled="true"><scalarFunctionName>CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK</scalarFunctionName>` | **BigQuery UDF or Stored Procedure** | `CREATE FUNCTION dataset.sfn_prior_fiscal_week() RETURNS STRING AS (...); DECLARE ip_week_ending_from STRING DEFAULT dataset.sfn_prior_fiscal_week();` |
| **Filter with Variable Substitution** | `<filter>("FISCVARNT" ='K4') AND ("_BIC_ZIO_VER" ='$$IP_VERSION$$') AND ("_BIC_ZIO_SWEEK" = '$$IP_WEEK_LY$$')</filter>` | **BigQuery WHERE with Parameters** | `WHERE fiscvarnt = 'K4' AND _bic_zio_ver = @ip_version AND _bic_zio_sweek = @ip_week_ly` |
| **Filter with IN Clause** | `<filter>IN("_BIC_ZIO_SAUDT",'1','10')</filter>` | **BigQuery IN Clause** | `WHERE _bic_zio_saudt IN ('1', '10')` |
| **Filter with LIKE Pattern** | `<viewAttribute id="PARNODE"><filter operator="CP" including="true" value="*CORE_RET*"/>` (CP = Contains Pattern) | **BigQuery LIKE** | `WHERE parnode LIKE '%CORE_RET%'` |
| **Aggregation (SUM)** | `<measure id="_BIC_ZIO_D1AMT" aggregationType="sum" engineAggregation="sum">` | **BigQuery SUM in GROUP BY** | `SUM(_bic_zio_d1amt) AS _bic_zio_d1amt` with appropriate GROUP BY clause |
| **Data Source Reference** | `<DataSource id="CV_BASE_FIN_WEEKLY_ACTUAL_S4" type="CALCULATION_VIEW"><resourceUri>/CVS_FRIP.Base.FI/calculationviews/CV_BASE_FIN_WEEKLY_ACTUAL_S4</resourceUri>` | **BigQuery Table/View Reference** | `FROM \`project.dataset.cv_base_fin_weekly_actual_s4\`` |
| **LEFTSTR Function** | `LEFTSTR("_BIC_ZWWPC_PA1",2)` in CAL_FS_RX_FLAG calculation | **BigQuery LEFT Function** | `LEFT(_bic_zwwpc_pa1, 2)` |
| **RIGHTSTR Function** | `RIGHTSTR('$$IP_WEEK_CY$$',2)` in CAL_WEEK_NUMBER calculation | **BigQuery RIGHT Function** | `RIGHT(@ip_week_cy, 2)` |
| **LTRIM Function** | `ltrim("NODEVALUE",'0')` in CAL_NODE_VALUE calculation | **BigQuery LTRIM Function** | `LTRIM(nodevalue, '0')` |

---

## 3. Manual Adjustments Post Agent Conversion

1. **Configure BigQuery Project and Dataset References**
   - Update all table and view references to use BigQuery three-part naming convention: `project.dataset.table_name`
   - Replace SAP resource URIs (e.g., `/CVS_FRIP.Base.FI/calculationviews/CV_BASE_FIN_WEEKLY_ACTUAL_S4`) with BigQuery fully qualified table names
   - Map the 7 data sources (CV_BASE_FIN_WEEKLY_ACTUAL_S4, CV_COMP_MD_SRPACT_STATIC, CV_BASE_MD_HRRP_NODE_S4, CV_BASE_MD_RCALWEEK_S4, CV_COMP_MD_COMPFL_STATIC, CV_BASE_MD_CEPCT_S4) to corresponding BigQuery tables

2. **Implement Scalar Function UDFs**
   - Create BigQuery UDFs for the 3 scalar functions referenced in variable derivation rules:
     - `SFN_PRIOR_FISCAL_WEEK` (used by IP_WEEK_ENDING_FROM, IP_WEEK_ENDING_TO, IP_WEEK_CY)
     - `SFN_ACTUALS_COMP_FLAG` (used by IP_VERSION_COMP_FLAG)
     - `SFN_LY_COMPARISON_WEEK` (used by IP_WEEK_LY)
   - Deploy these UDFs in the target BigQuery dataset with equivalent business logic

3. **Configure Query Parameters and Scheduled Queries**
   - Convert the 6 input variables (IP_VERSION, IP_WEEK_ENDING_FROM, IP_WEEK_ENDING_TO, IP_VERSION_COMP_FLAG, IP_WEEK_LY, IP_WEEK_CY) to BigQuery query parameters
   - Set up BigQuery Scheduled Queries to refresh the Materialized View with parameter values derived from UDFs
   - Configure default values: IP_VERSION='ACT01' as specified in the variable definition

4. **Update IAM Permissions**
   - Grant BigQuery Data Viewer role to users/service accounts consuming the view
   - Grant BigQuery Data Editor role to service accounts executing scheduled queries
   - Configure access controls for the 7 underlying base tables

5. **Adjust Hierarchy Filter Logic**
   - Verify that hierarchy filters (PARNODE LIKE '%CORE_RET%', PARNODE LIKE '%181', HRYVALTO='99991231', HRYID='CVS2') correctly map to BigQuery dimension tables
   - Ensure the GL_HIER and PC_HIER filtering logic (from CV_BASE_MD_HRRP_NODE_S4) is preserved in BigQuery joins

6. **Configure Materialized View Refresh Strategy**
   - Set appropriate refresh intervals for the Materialized View based on data freshness requirements
   - Consider enabling automatic refresh or scheduling manual refresh via Cloud Scheduler
   - Configure partition expiration if time-based partitioning is implemented on base tables

7. **Update BI Tool Connections**
   - Reconfigure reporting tools (equivalent to BEx Query consumption) to connect to the BigQuery Materialized View
   - Update connection strings, authentication methods, and query syntax in downstream BI applications
   - Map the 56 attributes and 9 measures to BI tool semantic layer

8. **Validate Calculated Field Logic**
   - Test the 4 calculated view attributes (CAL_NODE_VALUE, CAL_FS_RX_FLAG, CAL_COMP_FLAG, CAL_WEEK_NUMBER) in BigQuery
   - Verify the calculated measure (_B631_S_AMOUNT = _B631_S_AMOUNT_NEGATIVE * -1) produces identical results
   - Validate CASE expressions and string functions (LEFTSTR, RIGHTSTR, LTRIM) behavior

9. **Configure Cross-Client Query Behavior**
   - The view is defined with `defaultClient="crossClient"`, indicating multi-client data access
   - Ensure BigQuery tables include MANDT field and joins correctly filter or aggregate across clients
   - Adjust WHERE clauses if single-client access is required in BigQuery environment

---

## 4. Optimization Techniques

### Partitioning
- **Recommendation:** Partition the base table `cv_base_fin_weekly_actual_s4` by `_BIC_ZIO_SWEEK` (weekly snapshot date) using time-unit column partitioning if the field is DATE type, or integer-range partitioning if stored as numeric week identifier
- **Justification:** The view filters on `_BIC_ZIO_SWEEK = '$$IP_WEEK_LY$$'` in the WEEKLY_SNAPSHOT_DS05 projection, enabling partition pruning to scan only relevant weekly data
- **Additional Partitioning:** Partition `cv_comp_md_compfl_static` by `ZWEEK` field (filtered by `'$$IP_WEEK_CY$$'` in COMP_FLAG_LY projection) to optimize comparison flag lookups

### Clustering Keys
- **Recommendation:** Apply clustering on the following columns in order of filter selectivity:
  1. `_BIC_ZIO_VER` (filtered by IP_VERSION parameter)
  2. `_B631_S_PROFTCTR` (used in 3 joins: Join_4, Join_2, Join_3, Join_5)
  3. `_B631_S_GL_ACCT` (used in Join_6 with GL_HIER)
  4. `MANDT` (used in all joins for multi-client filtering)
- **Justification:** These fields appear in WHERE clauses and JOIN conditions across multiple calculation view nodes, and clustering will co-locate related rows for faster join and filter operations

### Query Pruning
- **Recommendation:** Leverage the filters defined in projection nodes to minimize data scanned:
  - `FISCVARNT = 'K4'` filter in WEEKLY_SNAPSHOT_DS05
  - `PARNODE LIKE '%CORE_RET%'` and `HRYVALTO = '99991231'` in PC_HIER
  - `PARNODE LIKE '%181'`, `HRYVALTO = '99991231'`, `HRYID = 'CVS2'` in GL_HIER
  - `IN(_BIC_ZIO_SAUDT, '1', '10')` filter in WEEKLY_SNAPSHOT_DS05
- **Justification:** These filters are applied early in the calculation view flow (at projection level), and should be pushed down to base table scans in BigQuery to reduce I/O

### Materialized Views
- **Recommendation:** Create a Materialized View for the final FLAGS projection output, pre-computing the 4 calculated attributes (CAL_NODE_VALUE, CAL_FS_RX_FLAG, CAL_COMP_FLAG, CAL_WEEK_NUMBER) and all 7 joins
- **Justification:** The view has `outputViewType="Aggregation"` with 8 base measures using `aggregationType="sum"`, indicating heavy aggregation workload suitable for pre-computation. The view is marked as `visibility="reportingEnabled"`, suggesting frequent consumption by reporting tools

### Temporary Tables
- **Recommendation:** Use temporary tables for intermediate join results, particularly for the hierarchy filtering steps (PC_HIER and GL_HIER) which involve pattern matching on PARNODE
- **Justification:** The GL_HIER projection includes a calculated attribute `CAL_NODE_VALUE = ltrim("NODEVALUE",'0')` which could benefit from materialization before the Join_6 operation

### BI Engine Acceleration
- **Recommendation:** Enable BI Engine for the final Materialized View to cache aggregated results in-memory
- **Justification:** The view contains 56 attributes and 9 measures with multiple aggregations, and is designed for reporting consumption (`visibility="reportingEnabled"`). BI Engine will accelerate interactive dashboard queries

### Query Rewrite Opportunities
- **Opportunity 1:** The view performs 3 left outer joins (Join_2, Join_1, Join_3, Join_5) which could be rewritten as INNER JOINs if NULL handling is not required for store attributes, retail calendar, and profit center text
- **Opportunity 2:** The calculated measure `_B631_S_AMOUNT = _B631_S_AMOUNT_NEGATIVE * -1` could be pre-computed in the base table or an intermediate view to avoid runtime calculation
- **Opportunity 3:** The CASE expressions in FLAGS projection (CAL_FS_RX_FLAG, CAL_COMP_FLAG) could be replaced with lookup tables if the logic is complex and frequently reused

### Refactor or Rebuild
- **Recommendation:** **Refactor**
- **Justification:** The Calculation View has a well-structured node hierarchy with 14 calculation views (projections and joins) that can be systematically converted to BigQuery Views and Materialized Views. The logic is complex but deterministic, with clear filter and join patterns. Rebuilding from scratch would risk introducing logic errors in the 7-way join structure and 4 calculated attributes. Refactoring allows preservation of the existing business logic while optimizing for BigQuery's architecture (partitioning, clustering, materialized views).

---

## 5. Sensitive and Privacy Data Assessment

No sensitive data found

---

## API Cost

API COST: 0.0000