---

<div style="border:1px solid #d0d7de;border-radius:6px;overflow:hidden;font-family:Arial,sans-serif;width:100%;margin-bottom:15px;">
<div style="background:#1f4e79;color:white;padding:10px;font-size:16px;font-weight:bold;">
CV_BASE_MD_HRRP_NODE_S4 Analyze Report
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
<td style="padding:8px;border:1px solid #ddd;">SAP HANA Calculation View for Hierarchy Master Data (HRRP_NODE) with client filtering migrated to BigQuery View with WHERE clause filtering.</td>
</tr>
</table>
</div>

**Asset Name:** CV_BASE_MD_HRRP_NODE_S4

---

## 1. BigQuery Recommendations

### **(Best Fit) BigQuery View**

**Reason 1:** The Calculation View is a simple Projection node that performs column selection and client filtering (MANDT IN ('120', '200')) on the HRRP_NODE table. This maps directly to a BigQuery View with a SELECT statement and WHERE clause.

**Reason 2:** The asset is categorized as DIMENSION data (dataCategory="DIMENSION") with outputViewType="Projection", indicating it serves as a semantic layer for master data access. BigQuery Views are ideal for providing reusable, lightweight semantic layers without data duplication.

**Reason 3:** No complex transformations, aggregations, joins, or procedural logic are present. The view simply exposes filtered columns from a single base table, making a BigQuery View the most straightforward and performant implementation approach.

### **(Alternative) BigQuery Materialized View**

**Reason 1:** If query performance becomes critical and the underlying HRRP_NODE table is large with frequent reads, a Materialized View could pre-compute and cache the filtered result set.

**Reason 2:** The filter condition on MANDT (client) is static and deterministic, making it suitable for materialization. However, this introduces storage costs and refresh overhead.

**Reason 3:** This approach is only recommended if access patterns show high query frequency and the base table size justifies the materialization trade-off. For typical master data dimensions, a standard View is sufficient.

---

## 2. Syntax Differences

| **SAP HANA Construct** | **BigQuery Equivalent** | **Details** |
|------------------------|-------------------------|-------------|
| Calculation View (Projection node) | BigQuery View | The Calculation View with a single Projection node maps to a BigQuery View with SELECT and WHERE clauses. |
| DATA_BASE_TABLE (HRRP_NODE) | BigQuery Table | The source table `HRRP_NODE` in schema `SAP_S4` becomes a BigQuery table in a BigQuery dataset. |
| Filter on MANDT (ListValueFilter with IN operator) | WHERE clause with IN predicate | The filter `<filter xsi:type="AccessControl:ListValueFilter" operator="IN" including="true"><operands value="120"/><operands value="200"/></filter>` becomes `WHERE MANDT IN ('120', '200')` in BigQuery SQL. |
| viewAttributes (column selection) | SELECT column list | The 11 attributes (MANDT, HRYID, HRYVER, NODECLS, HRYNODE, PARNODE, HRYVALTO, HRYVALFROM, BALIND, NODETYPE, NODEVALUE) map to a SELECT statement listing these columns. |
| AttributeMapping (source to target) | Column aliasing (if needed) | Direct 1:1 mappings (e.g., `target="MANDT" source="MANDT"`) translate to column names in the SELECT clause. No aliasing is required here. |
| dataCategory="DIMENSION" | BigQuery View (semantic layer) | The dimension categorization indicates this is a master data view, implemented as a BigQuery View for reusable semantic access. |
| defaultClient="crossClient" | Multi-client filtering logic | The cross-client setting with explicit MANDT filter translates to WHERE clause filtering on the client field in BigQuery. |
| translationRelevant="true" | Metadata annotation | Translation relevance is a metadata property; in BigQuery, this would be handled via external documentation or BI tool configuration, not in the view definition itself. |
| defaultLanguage="$$language$$" | Parameter or session variable | The language variable would be replaced with a BigQuery session variable or parameter if dynamic language filtering is required. |

---

## 3. Manual Adjustments Post Agent Conversion

1. **Update BigQuery dataset and table references:** Replace the schema reference `SAP_S4.HRRP_NODE` with the appropriate BigQuery project, dataset, and table name (e.g., `project_id.dataset_name.HRRP_NODE`).

2. **Configure BigQuery IAM roles and grants:** Ensure the service account or users accessing the converted BigQuery View have the necessary IAM permissions (e.g., `roles/bigquery.dataViewer` on the dataset, `roles/bigquery.jobUser` for query execution).

3. **Replace language variable `$$language$$`:** If the `defaultLanguage="$$language$$"` variable is used in downstream logic or BI tools, replace it with a BigQuery scripting variable, session parameter, or remove it if not applicable.

4. **Update BI tool connections:** If the Calculation View was consumed by SAP BEx Query, Analysis for Office, or other reporting tools, reconfigure these tools to point to the new BigQuery View (e.g., via Looker Studio, Tableau, or a BigQuery BI connector).

5. **Verify client filtering logic:** Confirm that the hardcoded client filter values ('120', '200') are still valid in the target BigQuery environment. Update the WHERE clause if different client values are required post-migration.

6. **Set up BigQuery project and reservation/slot assignments:** Configure the BigQuery project settings, including slot reservations or on-demand pricing, to ensure appropriate query performance and cost management.

7. **Document metadata properties:** The SAP HANA metadata properties such as `translationRelevant="true"`, `visibility="internal"`, and `checkAnalyticPrivileges="false"` should be documented externally, as BigQuery Views do not support equivalent metadata annotations natively.

---

## 4. Optimization Techniques

### **Partitioning**
- **Recommendation:** If the underlying `HRRP_NODE` table in BigQuery is large and queries frequently filter by date fields (e.g., `HRYVALTO` or `HRYVALFROM`), consider partitioning the base table by one of these date columns (time-unit partitioning).
- **Justification:** The Calculation View exposes `HRYVALTO` (Valid To Date) and `HRYVALFROM` (Valid-From Date). If downstream queries filter by these date ranges, partitioning will reduce scan costs and improve query performance.

### **Clustering Keys**
- **Recommendation:** Apply clustering on frequently filtered or joined columns such as `MANDT`, `HRYID`, `HRYVER`, or `HRYNODE` on the base `HRRP_NODE` table.
- **Justification:** The view filters by `MANDT` and exposes hierarchical fields (`HRYID`, `HRYVER`, `HRYNODE`, `PARNODE`). Clustering on these columns will optimize query pruning and reduce data scanned.

### **Query Pruning**
- **Recommendation:** Ensure the WHERE clause filter on `MANDT IN ('120', '200')` is preserved in the BigQuery View definition to enable partition and cluster pruning at query execution time.
- **Justification:** The filter is explicitly defined in the Calculation View and should be retained in the BigQuery View to minimize data scanned.

### **Materialized Views**
- **Recommendation:** Consider creating a Materialized View only if query frequency is high and the base table is large (>1TB) with infrequent updates.
- **Justification:** The Calculation View is a simple projection with filtering. A standard View is sufficient unless performance testing indicates a need for materialization.

### **BI Engine Acceleration**
- **Recommendation:** Enable BI Engine for the dataset if the view is frequently queried by BI tools for interactive dashboards.
- **Justification:** The asset is categorized as a DIMENSION view, likely used for reporting and analytics. BI Engine can cache frequently accessed dimension data for sub-second query response times.

### **Refactor or Rebuild**
- **Decision:** Refactor
- **Justification:** The Calculation View is straightforward with a single Projection node, client filtering, and no complex logic. It can be directly refactored into a BigQuery View with minimal effort. No rebuild is necessary.

---

## 5. Sensitive and Privacy Data Assessment

No sensitive data found

---

## 6. API Cost

**API COST:** 0.0000