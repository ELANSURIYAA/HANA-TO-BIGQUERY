---

Here is the complete analysis report for the SAP HANA Calculation View **CV_COMP_FIN_ACTUAL_STATIC**:

---

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
<td style="padding:8px;border:1px solid #ddd;">2026-10-09</td>
</tr>
<tr>
<td style="padding:8px;border:1px solid #ddd;background:#f5f5f5;"><b>Description</b></td>
<td style="padding:8px;border:1px solid #ddd;">SAP HANA Calculation View for weekly static financial actuals aggregation with multi-level joins, filters, and calculated attributes to be migrated as BigQuery views and stored procedures.</td>
</tr>
</table>
</div>

---

**Asset Name**: CV_COMP_FIN_ACTUAL_STATIC

---

## 1. BigQuery Recommendations

### **(Best Fit) BigQuery Materialized View with Scheduled Query Refresh**

**Reason 1**: The Calculation View is an aggregation-type view (outputViewType="Aggregation") with multiple join operations (7 joins), filters, and calculated attributes. This pattern is best suited for a BigQuery Materialized View to pre-compute and cache aggregated results, significantly improving query performance for reporting workloads.

**Reason 2**: The view contains 6 input parameters (IP_VERSION, IP_WEEK_ENDING_FROM, IP_WEEK_ENDING_TO, IP_VERSION_COMP_FLAG, IP_WEEK_LY, IP_WEEK_CY) with derivation rules using scalar functions (SFN_PRIOR_FISCAL_WEEK, SFN_ACTUALS_COMP_FLAG, SFN_LY_COMPARISON_WEEK). These parameters can be implemented as BigQuery Scheduled Queries that refresh the materialized view with computed parameter values at regular intervals, maintaining data freshness for weekly financial actuals.

**Reason 3**: The view performs complex transformations including left outer joins (Join_2, Join_1, Join_3, Join_5), inner joins (Join_4, Join_6), calculated view attributes (CAL_NODE_VALUE, CAL_WEEK, CAL_FS_RX_FLAG, CAL_COMP_FLAG, CAL_WEEK_NUMBER), and formula-based calculated measures (_B631_S_AMOUNT = _B631_S_AMOUNT_NEGATIVE * -1). Materializing these computations reduces query execution time for downstream reporting consumers.

### **(Alternative) BigQuery View with Table-Valued Functions (TVF)**

**Reason 1**: The Calculation View can be implemented as a parameterized BigQuery Table-Valued Function (TVF) to support dynamic parameter passing (IP_VERSION, IP_WEEK_LY, IP_WEEK_CY, etc.) at query time, providing flexibility for ad-hoc analysis scenarios where users need to specify different version or week values.

**Reason 2**: This approach preserves the on-demand computation model of the HANA Calculation View, ensuring real-time data access without the need for scheduled refresh cycles. However, this comes with the trade-off of higher query execution time compared to materialized views, especially for complex multi-join operations.

---

## 2. Syntax Differences

| **SAP HANA Construct** | **BigQuery Equivalent** | **Example from Asset** |
|------------------------|-------------------------|------------------------|
| Calculation View (Aggregation type) | BigQuery Materialized View or BigQuery View | `CV_COMP_FIN_ACTUAL_STATIC` with `outputViewType="Aggregation"` → BigQuery Materialized View with aggregation logic |
| Calculation View Input Parameters with Derivation Rules | BigQuery Scheduled Query with parameter computation using UDFs or Stored Procedures | `IP_VERSION` (default='ACT01'), `IP_WEEK_LY` (derivationRule: SFN_LY_COMPARISON_WEEK), `IP_WEEK_CY` (derivationRule: SFN_PRIOR_FISCAL_WEEK) → BigQuery Scheduled Query calling UDFs to compute week values |
| Calculation View Projection Node | BigQuery View with SELECT statement (column projection) | `WEEKLY_SNAPSHOT_DS05`, `STORE_ATTR_ACTUAL`, `PC_HIER`, `GL_HIER`, `RETAIL_CAL`, `COMP_FLAG_LY`, `PROFIT_CENTER_TEXT`, `Projection_1`, `WEEK_NUMBER`, `FLAGS` → BigQuery Views with SELECT column_list FROM source |
| Calculation View Join Node (Inner Join) | BigQuery View with INNER JOIN | `Join_4` (WEEKLY_SNAPSHOT_DS05 INNER JOIN PC_HIER ON _B631_S_PROFTCTR, MANDT), `Join_6` (Join_4 INNER JOIN GL_HIER ON _B631_S_GL_ACCT, MANDT) → BigQuery View with INNER JOIN clauses |
| Calculation View Join Node (Left Outer Join) | BigQuery View with LEFT OUTER JOIN | `Join_2` (Projection_1 LEFT OUTER JOIN STORE_ATTR_ACTUAL ON _B631_S_PROFTCTR, MANDT), `Join_1` (Join_2 LEFT OUTER JOIN RETAIL_CAL ON CAL_WEEK, MANDT), `Join_3` (WEEK_NUMBER LEFT OUTER JOIN COMP_FLAG_LY ON _B631_S_PROFTCTR, MANDT), `Join_5` (Join_3 LEFT OUTER JOIN PROFIT_CENTER_TEXT ON _B631_S_PROFTCTR, MANDT) → BigQuery View with LEFT OUTER JOIN clauses |
| Calculation View Filter (Column Engine) | BigQuery View with WHERE clause | `WEEKLY_SNAPSHOT_DS05` filter: `("FISCVARNT" ='K4') AND ("_BIC_ZIO_VER" ='$$IP_VERSION$$') AND ("_BIC_ZIO_SWEEK" = '$$IP_WEEK_LY$$') AND IN("_BIC_ZIO_SAUDT",'1','10')` → BigQuery WHERE FISCVARNT = 'K4' AND _BIC_ZIO_VER = @IP_VERSION AND _BIC_ZIO_SWEEK = @IP_WEEK_LY AND _BIC_ZIO_SAUDT IN ('1','10') |
| Calculation View Filter (Single Value Filter) | BigQuery View with WHERE clause | `PC_HIER` filter: `PARNODE` LIKE '%CORE_RET%' AND `HRYVALTO` = 99991231; `GL_HIER` filter: `PARNODE` LIKE '%181' AND `HRYVALTO` = 99991231 AND `HRYID` = 'CVS2' → BigQuery WHERE PARNODE LIKE '%CORE_RET%' AND HRYVALTO = 99991231 |
| Calculated View Attribute (Column Engine Expression) | BigQuery View with computed column using SQL expressions | `GL_HIER.CAL_NODE_VALUE`: `ltrim("NODEVALUE",'0')` → BigQuery SELECT LTRIM(NODEVALUE, '0') AS CAL_NODE_VALUE; `Projection_1.CAL_WEEK`: `'$$IP_WEEK_CY$$'` → BigQuery SELECT @IP_WEEK_CY AS CAL_WEEK |
| Calculated View Attribute (CASE expression) | BigQuery View with CASE WHEN statement | `FLAGS.CAL_FS_RX_FLAG`: `CASE(LEFTSTR("_BIC_ZWWPC_PA1",2),'FS','FS','RX','RX','')` → BigQuery SELECT CASE WHEN LEFT(_BIC_ZWWPC_PA1, 2) = 'FS' THEN 'FS' WHEN LEFT(_BIC_ZWWPC_PA1, 2) = 'RX' THEN 'RX' ELSE '' END AS CAL_FS_RX_FLAG |
| Calculated View Attribute (nested CASE) | BigQuery View with nested CASE WHEN | `FLAGS.CAL_COMP_FLAG`: `CASE("CAL_FS_RX_FLAG",'FS',"FS_COMP_WK",'RX',"RX_COMP_WK","FS_COMP_WK")` → BigQuery SELECT CASE WHEN CAL_FS_RX_FLAG = 'FS' THEN FS_COMP_WK WHEN CAL_FS_RX_FLAG = 'RX' THEN RX_COMP_WK ELSE FS_COMP_WK END AS CAL_COMP_FLAG |
| Calculated View Attribute (string function) | BigQuery View with string function | `FLAGS.CAL_WEEK_NUMBER`: `RIGHTSTR('$$IP_WEEK_CY$$',2)` → BigQuery SELECT RIGHT(@IP_WEEK_CY, 2) AS CAL_WEEK_NUMBER |
| Calculated Measure (formula) | BigQuery View with computed measure | `_B631_S_AMOUNT`: `"_B631_S_AMOUNT_NEGATIVE" * -1` → BigQuery SELECT _B631_S_AMOUNT_NEGATIVE * -1 AS _B631_S_AMOUNT |
| Base Measure (aggregationType="sum") | BigQuery View with SUM aggregation | `_B631_S_AMOUNT_NEGATIVE`, `_BIC_ZIO_D1AMT`, `_BIC_ZIO_D2AMT`, `_BIC_ZIO_D3AMT`, `_BIC_ZIO_D4AMT`, `_BIC_ZIO_D5AMT`, `_BIC_ZIO_D6AMT`, `_BIC_ZIO_D7AMT` → BigQuery SELECT SUM(column_name) AS measure_name GROUP BY dimension_columns |
| Scalar Function (custom derivation) | BigQuery User-Defined Function (UDF) | `SFN_PRIOR_FISCAL_WEEK`, `SFN_ACTUALS_COMP_FLAG`, `SFN_LY_COMPARISON_WEEK` → BigQuery CREATE FUNCTION project.dataset.SFN_PRIOR_FISCAL_WEEK() RETURNS STRING AS (...) |
| Dependent Calculation View (DataSource) | BigQuery View or Table | `CV_BASE_FIN_WEEKLY_ACTUAL_S4`, `CV_COMP_MD_SRPACT_STATIC`, `CV_BASE_MD_HRRP_NODE_S4`, `CV_BASE_MD_RCALWEEK_S4`, `CV_COMP_MD_COMPFL_STATIC`, `CV_BASE_MD_CEPCT_S4` → BigQuery Views or Tables in the same dataset |
| HANA Variable (parameter="true") | BigQuery Query Parameter or Stored Procedure Parameter | `IP_VERSION`, `IP_WEEK_ENDING_FROM`, `IP_WEEK_ENDING_TO`, `IP_VERSION_COMP_FLAG`, `IP_WEEK_LY`, `IP_WEEK_CY` → BigQuery @IP_VERSION, @IP_WEEK_LY, @IP_WEEK_CY as query parameters in TVF or Scheduled Query |

---

## 3. Manual Adjustments Post Agent Conversion

1. **Update BigQuery Project and Dataset References**: Replace SAP HANA schema references (CVS_FRIP.Base.FI, CVS_FRIP.Composite.Master, CVS_FRIP.Base.Master, CVS_FRIP.Base.Text) with BigQuery project.dataset notation (e.g., `my_project.cvs_frip_base_fi`, `my_project.cvs_frip_composite_master`).

2. **Configure BigQuery Scheduled Query for Parameter Derivation**: Implement scheduled queries to compute derived parameter values (IP_WEEK_LY, IP_WEEK_CY, IP_VERSION_COMP_FLAG) using BigQuery UDFs (SFN_PRIOR_FISCAL_WEEK, SFN_ACTUALS_COMP_FLAG, SFN_LY_COMPARISON_WEEK) and store results in a parameter configuration table or use them directly in materialized view refresh queries.

3. **Assign IAM Roles for BigQuery Resources**: Grant appropriate IAM roles (BigQuery Data Viewer, BigQuery Data Editor, BigQuery Job User) to service accounts and user groups for accessing the migrated calculation view (materialized view or view) and dependent data sources.

4. **Update Dependent Calculation View References**: Ensure all 7 dependent calculation views (CV_BASE_FIN_WEEKLY_ACTUAL_S4, CV_COMP_MD_SRPACT_STATIC, CV_BASE_MD_HRRP_NODE_S4, CV_BASE_MD_RCALWEEK_S4, CV_COMP_MD_COMPFL_STATIC, CV_BASE_MD_CEPCT_S4) are migrated to BigQuery and referenced correctly in the FROM clauses of the converted view.

5. **Configure Materialized View Refresh Schedule**: Set up a refresh schedule for the BigQuery Materialized View (if chosen as the best fit) to align with the weekly financial actuals data load frequency, ensuring data freshness for reporting consumers.

6. **Replace HANA Scalar Functions with BigQuery UDFs**: Migrate the three scalar functions (SFN_PRIOR_FISCAL_WEEK, SFN_ACTUALS_COMP_FLAG, SFN_LY_COMPARISON_WEEK) to BigQuery SQL UDFs or JavaScript UDFs, ensuring equivalent logic for fiscal week and comparison flag derivation.

7. **Update Reporting Layer Connections**: Reconfigure downstream reporting tools (BEx Query equivalents, Looker Studio, Tableau, or other BI tools) to connect to the BigQuery materialized view or view instead of the HANA Calculation View.

8. **Configure BigQuery Slot Reservations (Optional)**: For predictable query performance and cost management, configure BigQuery slot reservations or use on-demand pricing based on workload requirements.

9. **Update Filter Expressions for BigQuery Syntax**: Convert HANA Column Engine filter expressions (e.g., `IN("_BIC_ZIO_SAUDT",'1','10')`, `PARNODE LIKE '*CORE_RET*'`) to BigQuery SQL syntax (e.g., `_BIC_ZIO_SAUDT IN ('1','10')`, `PARNODE LIKE '%CORE_RET%'`).

10. **Test Join Cardinality and Performance**: Validate that the 7 join operations (4 inner joins, 3 left outer joins) produce correct results and acceptable performance in BigQuery, adjusting join order or adding clustering keys if necessary.

---

## 4. Optimization Techniques

### **Partitioning**
- Apply **time-unit partitioning** on the `FISCPER` (Fiscal year/period) or `_BIC_ZIO_SWEEK` (LY Week) column in the base table `CV_BASE_FIN_WEEKLY_ACTUAL_S4` to enable partition pruning and reduce query scan costs for weekly financial actuals.
- Apply **time-unit partitioning** on the `ZWEEK` (Week) column in the `CV_COMP_MD_COMPFL_STATIC` table to optimize the filter `("ZWEEK" = '$$IP_WEEK_CY$$')` in the `COMP_FLAG_LY` projection.

### **Clustering Keys**
- Define **clustering keys** on frequently filtered and joined columns in the base tables:
  - `CV_BASE_FIN_WEEKLY_ACTUAL_S4`: Cluster by `_BIC_ZIO_VER`, `_BIC_ZIO_SWEEK`, `_B631_S_PROFTCTR`, `_B631_S_GL_ACCT` to optimize filters and join conditions in `WEEKLY_SNAPSHOT_DS05`, `Join_4`, and `Join_6`.
  - `CV_COMP_MD_SRPACT_STATIC`: Cluster by `PRCTR`, `MANDT` to optimize the left outer join in `Join_2`.
  - `CV_BASE_MD_HRRP_NODE_S4`: Cluster by `PARNODE`, `HRYVALTO`, `NODEVALUE` to optimize filters in `PC_HIER` and `GL_HIER`.
  - `CV_COMP_MD_COMPFL_STATIC`: Cluster by `ZWEEK`, `COMP_VER`, `PRCTR` to optimize the filter in `COMP_FLAG_LY` and the join in `Join_3`.

### **Query Pruning**
- Leverage partition pruning by ensuring filter predicates on partitioned columns (`FISCPER`, `_BIC_ZIO_SWEEK`, `ZWEEK`) are applied early in the query execution plan.
- Use clustering to reduce data scanned for filters on `_BIC_ZIO_VER`, `_BIC_ZIO_SAUDT`, `PARNODE`, `HRYVALTO`, `HRYID`, `COMP_VER`.

### **Materialized Views**
- Implement the **Best Fit recommendation**: Create a BigQuery Materialized View for `CV_COMP_FIN_ACTUAL_STATIC` to pre-compute the 7 join operations, 10 calculated view attributes, and 1 calculated measure, significantly reducing query execution time for downstream reporting consumers.
- Schedule materialized view refresh to align with weekly data load cycles (e.g., daily or weekly refresh based on data availability).

### **Temporary Tables**
- For complex multi-step transformations, consider breaking down the view into intermediate temporary tables (e.g., storing results of `Join_4`, `Join_6`, `Join_2`, `Join_1`, `Join_3`, `Join_5` as temporary tables) to improve debugging and potentially optimize execution plans.

### **BI Engine Acceleration**
- Enable **BI Engine** for the materialized view or base tables to cache frequently accessed data in memory, accelerating queries from BI tools and reducing query latency for interactive reporting.

### **Query Rewrite Opportunities**
- **Eliminate redundant joins**: Review the join sequence (Join_4 → Join_6 → Projection_1 → Join_2 → Join_1 → Join_3 → Join_5) to identify opportunities to merge or reorder joins for better performance.
- **Push down filters**: Ensure filters in `WEEKLY_SNAPSHOT_DS05` (`FISCVARNT = 'K4'`, `_BIC_ZIO_VER = $$IP_VERSION$$`, `_BIC_ZIO_SWEEK = $$IP_WEEK_LY$$`, `_BIC_ZIO_SAUDT IN ('1','10')`) are applied as early as possible to reduce data volume before joins.
- **Optimize calculated attributes**: Pre-compute calculated attributes (`CAL_NODE_VALUE`, `CAL_WEEK`, `CAL_FS_RX_FLAG`, `CAL_COMP_FLAG`, `CAL_WEEK_NUMBER`) in base tables or intermediate views to avoid repeated computation.

### **Refactor or Rebuild**
**Recommendation**: **Refactor**

**Justification**: The Calculation View contains 7 join operations, 10 calculated view attributes, 1 calculated measure, and 6 input parameters with derivation rules, indicating moderate complexity. The logic is well-structured with clear projection, join, and aggregation nodes, making it suitable for automated conversion to BigQuery views or materialized views with manual adjustments for parameter handling and scalar function migration. A full rebuild is not necessary unless the underlying business logic needs to be redesigned for BigQuery-specific optimizations (e.g., denormalization, pre-aggregation strategies).

---

## 5. Sensitive and Privacy Data Assessment

No sensitive data found

---

## API Cost

**API COST**: 0.0000