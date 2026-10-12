<div style="border:1px solid #d0d7de;border-radius:6px;overflow:hidden;font-family:Arial,sans-serif;width:100%;margin-bottom:15px;">
<div style="background:#1f4e79;color:white;padding:10px;font-size:16px;font-weight:bold;">
CV_COMP_SKF_ACTUAL_STATIC Analyze Report
</div>
<table style="border-collapse:collapse;width:100%;">
<tr>
<td style="padding:8px;border:1px solid #ddd;background:#f5f5f5;width:150px;"><b>Author</b></td>
<td style="padding:8px;border:1px solid #ddd;">Ascendion AAVA</td>
</tr>
<tr>
<td style="padding:8px;border:1px solid #ddd;background:#f5f5f5;"><b>Created On</b></td>
<td style="padding:8px;border:1px solid #ddd;">2026-10-12</td>
</tr>
<tr>
<td style="padding:8px;border:1px solid #ddd;background:#f5f5f5;"><b>Description</b></td>
<td style="padding:8px;border:1px solid #ddd;">Composite Calculation View for Weekly Static SKF Actuals with parameterized filtering, multi-source joins, and aggregation logic for BigQuery migration.</td>
</tr>
</table>
</div>

---

## Asset Name: CV_COMP_SKF_ACTUAL_STATIC

---

## 1. BigQuery Recommendations

### (Best Fit)

**BigQuery Materialized View with Scheduled Query for Parameter-Driven Refresh**

**Reason 1:** The asset is a HANA Calculation View with outputViewType="Aggregation" and dataCategory="CUBE", containing 6 input variables (IP_VERSION, IP_VERSION_COMP_FLAG, IP_WEEK_ENDING_FROM, IP_WEEK_ENDING_TO, IP_WEEK_LY, IP_WEEK_CY) with derivation rules using scalar functions. This parameterized aggregation pattern maps best to a BigQuery Materialized View that pre-computes aggregated results, combined with a Scheduled Query that refreshes the view based on parameter values derived from BigQuery UDFs (replacing scalar function derivation rules).

**Reason 2:** The view contains complex multi-level join logic (5 JoinView nodes: Join_3, Join_2, Join_1, Join_4, Join_5) combining 6 data sources (CV_BASE_SKF_WEEKLY_ACTUAL_S4, CV_COMP_MD_SRPACT_STATIC, CV_BASE_MD_HRRP_NODE_S4, CV_COMP_MD_COMPFL_STATIC, CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_CEPCT_S4) with both inner and left outer joins. BigQuery Materialized Views can pre-compute these complex joins and aggregations, providing significant query performance improvements for reporting workloads.

**Reason 3:** The view includes calculated view attributes (CAL_WEEK using variable '$$IP_WEEK_CY$$', CAL_WEEK_NUMBER using RIGHTSTR function, CAL_ZIO_SKFQ_QTY using CASE logic) and multiple filter expressions in Projection nodes (FISCVARNT='K4', version filtering, IN clauses for _BIC_ZIO_SAUDT and _BIC_ZIO_PSKF, date range filtering). These transformations can be embedded in the BigQuery Materialized View definition, with parameters handled via Scheduled Queries that pass dynamic filter values.

---

### (Alternative)

**BigQuery View with Table-Valued Functions (TVF) for Parameterization**

**Reason 1:** The 6 input variables with derivation rules can be implemented as BigQuery Table-Valued Functions (TVFs) that accept parameters and return filtered/transformed result sets. This approach provides runtime flexibility for parameter-driven queries similar to HANA Calculation View variable behavior.

**Reason 2:** For scenarios requiring real-time data access without pre-aggregation, a BigQuery View with embedded TVF calls can replicate the calculation view logic while maintaining query-time flexibility. However, this approach may have slower performance compared to Materialized Views for complex aggregations.

---

## 2. Syntax Differences

| **SAP BW HANA Construct** | **BigQuery Equivalent** | **Example from Asset** |
|---------------------------|-------------------------|------------------------|
| Calculation View (outputViewType="Aggregation") | BigQuery Materialized View | CV_COMP_SKF_ACTUAL_STATIC with dataCategory="CUBE" and aggregation measures → `CREATE MATERIALIZED VIEW project.dataset.cv_comp_skf_actual_static AS SELECT ...` |
| Local Variables with derivationRule (Scalar Function) | BigQuery User-Defined Functions (UDF) or Scheduled Query with parameter logic | IP_VERSION_COMP_FLAG with `<scalarFunctionName>CVS_FRIP.Composite.Master::SFN_ACTUALS_COMP_FLAG</scalarFunctionName>` → `CREATE FUNCTION get_comp_flag_version() AS (...)` |
| Local Variables with default values | BigQuery Scripting DECLARE with default values | `<variable id="IP_VERSION" ... defaultValue="ACT01">` → `DECLARE IP_VERSION STRING DEFAULT 'ACT01';` |
| Projection View with filter expressions | BigQuery View with WHERE clause | WEEKLY_SNAPSHOT_DS05 filter: `("FISCVARNT" ='K4') AND ("_BIC_ZIO_SWEEK" = '$$IP_WEEK_LY$$')` → `WHERE FISCVARNT = 'K4' AND _BIC_ZIO_SWEEK = @IP_WEEK_LY` |
| JoinView with joinType="inner" | BigQuery INNER JOIN | Join_3 joining WEEKLY_SNAPSHOT_DS05 and CC_HIER on _B631_S_COSTCNTR and MANDT → `INNER JOIN ... ON a._B631_S_COSTCNTR = b.NODEVALUE AND a.MANDT = b.MANDT` |
| JoinView with joinType="leftOuter" | BigQuery LEFT OUTER JOIN | Join_2 joining Projection_1 and STORE_ATTR_ACTUAL → `LEFT OUTER JOIN ... ON a._B631_S_PROFTCTR = b.PRCTR AND a.MANDT = b.MANDT` |
| Calculated View Attribute with COLUMN_ENGINE expression | BigQuery calculated column in SELECT | CAL_WEEK: `<formula>'$$IP_WEEK_CY$$'</formula>` → `@IP_WEEK_CY AS CAL_WEEK` |
| Calculated View Attribute with RIGHTSTR function | BigQuery SUBSTR or RIGHT function | CAL_WEEK_NUMBER: `<formula>RIGHTSTR('$$IP_WEEK_CY$$',2)</formula>` → `RIGHT(@IP_WEEK_CY, 2) AS CAL_WEEK_NUMBER` |
| Calculated View Attribute with CASE expression | BigQuery CASE WHEN expression | CAL_ZIO_SKFQ_QTY: `<formula>CASE("_BIC_ZIO_PSKF",'804013',"_BIC_ZIO_SKFQ"*2,"_BIC_ZIO_SKFQ")</formula>` → `CASE WHEN _BIC_ZIO_PSKF = '804013' THEN _BIC_ZIO_SKFQ * 2 ELSE _BIC_ZIO_SKFQ END AS CAL_ZIO_SKFQ_QTY` |
| Base Measures with aggregationType="sum" | BigQuery SUM aggregation in GROUP BY | `<measure id="_BIC_ZIO_SKFQ_90as1" aggregationType="sum">` → `SUM(_BIC_ZIO_SKFQ) AS _BIC_ZIO_SKFQ_90as1` |
| Filter with IN clause | BigQuery IN operator | `IN("_BIC_ZIO_SAUDT",'1','10')` → `WHERE _BIC_ZIO_SAUDT IN ('1', '10')` |
| Filter with AND/OR logic | BigQuery AND/OR operators | `("ZWEEK" >='$$IP_WEEK_ENDING_FROM$$' AND "ZWEEK"<='$$IP_WEEK_ENDING_TO$$')` → `WHERE ZWEEK >= @IP_WEEK_ENDING_FROM AND ZWEEK <= @IP_WEEK_ENDING_TO` |
| Filter with pattern matching (CP operator) | BigQuery LIKE operator | CC_HIER filter: `<filter ... operator="CP" ... value="*CORERET*"/>` → `WHERE PARNODE LIKE '%CORERET%'` |
| Data Source reference (CALCULATION_VIEW) | BigQuery table/view reference | `<DataSource id="CV_BASE_SKF_WEEKLY_ACTUAL_S4" type="CALCULATION_VIEW">` → `FROM project.dataset.cv_base_skf_weekly_actual_s4` |
| Variable substitution syntax | BigQuery parameterized query syntax | `'$$IP_VERSION$$'` → `@IP_VERSION` |
| Attribute mapping in joins | BigQuery column aliasing in JOIN ON clause | `<mapping ... target="_B631_S_PROFTCTR" source="PRCTR"/>` → `source_table.PRCTR AS _B631_S_PROFTCTR` |

---

## 3. Manual Adjustments Post Agent Conversion

1. **Configure BigQuery Project and Dataset References**: Update all data source references (CV_BASE_SKF_WEEKLY_ACTUAL_S4, CV_COMP_MD_SRPACT_STATIC, CV_BASE_MD_HRRP_NODE_S4, CV_COMP_MD_COMPFL_STATIC, CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_CEPCT_S4) to fully qualified BigQuery table names in the format `project_id.dataset_id.table_name`.

2. **Implement Scalar Function Derivation Rules as BigQuery UDFs**: Create BigQuery UDFs to replace the scalar function derivation rules for variables IP_VERSION_COMP_FLAG (CVS_FRIP.Composite.Master::SFN_ACTUALS_COMP_FLAG), IP_WEEK_ENDING_FROM and IP_WEEK_ENDING_TO (CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK), IP_WEEK_LY (CVS_FRIP.Composite.Master::SFN_LY_COMPARISON_WEEK), and IP_WEEK_CY (CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK).

3. **Configure BigQuery Scheduled Query for Materialized View Refresh**: Set up a BigQuery Scheduled Query to refresh the Materialized View based on parameter values. Configure the schedule to align with the data refresh frequency requirements (e.g., daily, weekly).

4. **Update IAM Permissions**: Grant appropriate BigQuery IAM roles (bigquery.dataViewer, bigquery.jobUser, bigquery.dataEditor) to service accounts and users who need to access the Materialized View and execute Scheduled Queries.

5. **Configure BigQuery Reservation and Slot Assignments**: Allocate BigQuery slots or configure on-demand pricing for the Materialized View refresh and query workloads. Adjust reservation settings based on expected query volume and performance requirements.

6. **Replace HANA-Specific Client Field (MANDT) Handling**: Review the usage of MANDT field in join conditions and filters. If multi-tenancy is not required in BigQuery, consider removing MANDT from join conditions or implementing an alternative tenant isolation strategy.

7. **Update Reporting Layer Connections**: If this Calculation View is consumed by BEx Queries, Analysis for Office, or other SAP reporting tools, reconfigure those tools to connect to BigQuery via ODBC/JDBC drivers, Looker Studio, or a compatible BI connector.

8. **Configure Materialized View Refresh Strategy**: Set the refresh strategy for the BigQuery Materialized View (automatic vs. manual refresh). For parameter-driven scenarios, implement a Scheduled Query that triggers refresh based on variable values.

---

## 4. Optimization Techniques

### Partitioning
- **Recommendation**: Implement time-unit column partitioning on the _BIC_ZIO_SWEEK (LY Week) or CAL_WEEK field in the base fact table (CV_BASE_SKF_WEEKLY_ACTUAL_S4) and the Materialized View. This aligns with the asset's filter logic that uses week-based parameters (IP_WEEK_ENDING_FROM, IP_WEEK_ENDING_TO, IP_WEEK_LY, IP_WEEK_CY).
- **Justification**: The Projection node WEEKLY_SNAPSHOT_DS05 filters on _BIC_ZIO_SWEEK = '$$IP_WEEK_LY$$', and COMP_FLAG_ACT01 filters on ZWEEK range. Partitioning by week enables query pruning and reduces scan costs.

### Clustering Keys
- **Recommendation**: Apply clustering on _B631_S_PROFTCTR (Profit Center), _B631_S_COSTCNTR (Cost Center), _BIC_ZIO_VER (Version), and _BIC_ZIO_PSKF (Plan SKF Account) in the Materialized View.
- **Justification**: These fields are used in multiple join conditions (Join_2, Join_3, Join_4, Join_5 all join on _B631_S_PROFTCTR or _B631_S_COSTCNTR) and filter predicates (IN(_BIC_ZIO_PSKF,'804013','801000'), _BIC_ZIO_VER='$$IP_VERSION$$'). Clustering improves join performance and filter efficiency.

### Query Pruning
- **Recommendation**: Leverage partition pruning by ensuring all queries against the Materialized View include filters on the partitioned column (_BIC_ZIO_SWEEK or CAL_WEEK). Use clustering columns in WHERE clauses to enable block-level pruning.
- **Justification**: The asset's filter expressions in WEEKLY_SNAPSHOT_DS05 and COMP_FLAG_ACT01 demonstrate week-based and profit center-based filtering patterns that benefit from pruning.

### Materialized Views
- **Recommendation**: Create the primary Materialized View for the full aggregation output (FLAGS node with all 8 measures: _BIC_ZIO_SKFQ_90as1, _BIC_ZIO_D1SKQ through _BIC_ZIO_D7SKQ, and _BIC_ZIO_SKFQ). Consider additional Materialized Views for intermediate join results (e.g., Join_2 output) if those are frequently queried independently.
- **Justification**: The asset is an Aggregation-type Calculation View with 8 base measures using sum aggregation. Pre-computing these aggregations in a Materialized View significantly improves query performance.

### Temporary Tables
- **Recommendation**: For complex multi-step transformations in Scheduled Queries that refresh the Materialized View, use temporary tables to stage intermediate results (e.g., results of Join_3 or Join_4) before final aggregation.
- **Justification**: The asset has 5 sequential join operations. Breaking these into temporary tables in a Scheduled Query can improve debugging and performance tuning.

### BI Engine Acceleration
- **Recommendation**: Enable BI Engine for the Materialized View to cache frequently accessed aggregated data in memory, especially for interactive reporting queries.
- **Justification**: The asset is marked as visibility="reportingEnabled", indicating it is designed for reporting consumption. BI Engine acceleration reduces query latency for dashboards and reports.

### Query Rewrite Opportunities
- **Recommendation**: Simplify the calculated attribute CAL_ZIO_SKFQ_QTY logic (CASE statement multiplying _BIC_ZIO_SKFQ by 2 when _BIC_ZIO_PSKF='804013') by pre-computing this in the base table or an intermediate view to avoid repeated calculation.
- **Justification**: This CASE logic appears in the FLAGS projection node and is applied to a measure. Pre-computing reduces runtime overhead.

### Refactor or Rebuild
- **Recommendation**: **Refactor** - The asset's structure (6 data sources, 5 joins, 3 calculated attributes, 8 aggregated measures) is moderately complex but follows a clear hierarchical pattern. The logic can be refactored into a BigQuery Materialized View with supporting UDFs for scalar function derivation rules, without requiring a full rebuild.
- **Justification**: The asset does not contain ABAP routines, cursors, or procedural logic that would necessitate a complete rebuild. The join and aggregation logic is declarative and maps directly to SQL.

---

## 5. Sensitive and Privacy Data Assessment

No sensitive data found

---

## 6. API Cost

API COST: 0.0000