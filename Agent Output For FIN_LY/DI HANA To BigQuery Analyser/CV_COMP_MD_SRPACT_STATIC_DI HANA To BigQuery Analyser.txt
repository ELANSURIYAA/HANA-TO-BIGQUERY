---

<div style="border:1px solid #d0d7de;border-radius:6px;overflow:hidden;font-family:Arial,sans-serif;width:100%;margin-bottom:15px;">
<div style="background:#1f4e79;color:white;padding:10px;font-size:16px;font-weight:bold;">
CV_COMP_MD_SRPACT_STATIC Analyze Report
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
<td style="padding:8px;border:1px solid #ddd;">SAP HANA Calculation View wrapper on Store Profile Attributes Actuals snapshot table, providing aggregated reporting view for store master data with 75 attributes and 5 measures.</td>
</tr>
</table>
</div>

---

## Asset Name: CV_COMP_MD_SRPACT_STATIC

---

## 1. BigQuery Recommendations

### **(Best Fit) BigQuery Materialized View**

**Reason 1:** The Calculation View is a simple wrapper on a single CDS artifact (`TBL_WSS_SRP_ATTR_ACT`) with a Projection node performing direct column mapping without transformations, filters, or joins. This pattern is ideal for a BigQuery Materialized View, which can cache the projection and provide fast query performance for reporting workloads.

**Reason 2:** The asset is explicitly marked as `visibility="reportingEnabled"` and `dataCategory="CUBE"` with `outputViewType="Aggregation"`, indicating it serves as a reporting layer. BigQuery Materialized Views are optimized for analytical queries and can automatically refresh to reflect changes in the underlying table, matching the reporting use case.

**Reason 3:** The view contains 5 base measures with aggregation types (`RX_HRS_OPER`, `FS_HRS_OPER`, `RX_STORE`, `RETAIL_SQFT_AMT`, `TOTAL_SQFT_AMT`) using SUM aggregation. BigQuery Materialized Views support pre-aggregated results, enabling efficient query execution for analytical workloads accessing these measures.

### **(Alternative) BigQuery View**

**Reason 1:** If the underlying table `TBL_WSS_SRP_ATTR_ACT` is frequently updated and real-time data access is required without refresh latency, a standard BigQuery View would provide always-current results by querying the base table directly.

**Reason 2:** The Calculation View performs only direct attribute mapping (1:1 column projection) without complex transformations, making it straightforward to implement as a lightweight BigQuery View using a simple SELECT statement.

**Reason 3:** If storage costs are a concern and query frequency is low, a BigQuery View avoids the storage overhead of a Materialized View while still providing the logical abstraction layer for reporting consumers.

---

## 2. Syntax Differences

| **SAP HANA Construct** | **BigQuery Equivalent** | **Mapping Details** |
|------------------------|-------------------------|---------------------|
| Calculation View (Projection Node) | BigQuery View or Materialized View | The Projection node `Projection_1` performs direct column mapping from source `TBL_WSS_SRP_ATTR_ACT`. In BigQuery, this translates to a `SELECT` statement with all columns listed explicitly. |
| CDS Artifact Data Source (`TBL_WSS_SRP_ATTR_ACT`) | BigQuery Table | The source CDS artifact `CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT` maps to a BigQuery table reference in the format `project.dataset.TBL_WSS_SRP_ATTR_ACT`. |
| Attribute Mapping (`<mapping xsi:type="Calculation:AttributeMapping">`) | Column Alias in SELECT | Each attribute mapping (e.g., `target="MANDT" source="MANDT"`) becomes a column selection in BigQuery: `MANDT AS MANDT` or simply `MANDT` when source and target names match. |
| Base Measures with Aggregation (`aggregationType="sum"`) | Aggregated Columns in Materialized View or View with GROUP BY | Measures like `RX_HRS_OPER` with `aggregationType="sum"` translate to `SUM(RX_HRS_OPER) AS RX_HRS_OPER` in BigQuery when aggregation is required. For a direct projection without grouping, these are selected as regular numeric columns. |
| Logical Model Attributes (70 attributes) | SELECT column list | All 70 attributes defined in the `<attributes>` section map to individual columns in the BigQuery SELECT statement, preserving names and descriptions as column comments if needed. |
| `outputViewType="Aggregation"` | Materialized View with Aggregation or View | The output view type indicates the view supports aggregation queries. In BigQuery, this is implemented as a Materialized View (for pre-aggregated performance) or a standard View that allows aggregation at query time. |
| `dataCategory="CUBE"` | BigQuery Table/Materialized View for OLAP | The CUBE data category indicates an analytical/OLAP workload. BigQuery Tables or Materialized Views serve this purpose, with optional partitioning and clustering for performance. |
| `visibility="reportingEnabled"` | BigQuery View/Materialized View exposed to BI tools | Reporting-enabled visibility means the view is consumed by reporting tools (e.g., BEx Query). In BigQuery, this translates to a View or Materialized View that can be queried by BI tools like Looker Studio, Tableau, or Power BI. |
| `calculationScenarioType="TREE_BASED"` | BigQuery View/Materialized View (no direct equivalent) | Tree-based calculation scenarios in HANA define the node structure. In BigQuery, the equivalent is the SQL query structure (subqueries, CTEs) within a View or Materialized View definition. |
| `defaultClient="crossClient"` | Filter or Partition by Client (MANDT) | The `crossClient` setting means data spans multiple clients. In BigQuery, this can be handled by including `MANDT` as a partition key or filter condition to isolate client-specific data. |
| `translationRelevant="true"` | Language-specific Views or Joins to Text Tables | Translation relevance indicates multi-language support. In BigQuery, this requires joining to language-dependent text tables or creating separate views per language. |

---

## 3. Manual Adjustments Post Agent Conversion

1. **Update BigQuery Project, Dataset, and Table References**  
   Replace the SAP HANA CDS artifact reference `CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT` with the corresponding BigQuery table reference in the format `<project_id>.<dataset_id>.TBL_WSS_SRP_ATTR_ACT`. Ensure the dataset and table names match the migrated BigQuery environment.

2. **Configure IAM Roles and Permissions**  
   Grant appropriate IAM roles (e.g., `roles/bigquery.dataViewer`, `roles/bigquery.user`) to service accounts and users who will query the migrated Materialized View or View. Ensure permissions align with the original SAP HANA authorization model.

3. **Set Up Materialized View Refresh Schedule**  
   If implementing as a BigQuery Materialized View, configure the automatic refresh policy or use a Scheduled Query to refresh the Materialized View at intervals matching the source table update frequency (e.g., daily, hourly).

4. **Update BI Tool Connections**  
   Reconfigure BEx Query consumers or other reporting tools (e.g., Analysis for Office, SAP Analytics Cloud) to connect to the BigQuery View or Materialized View instead of the HANA Calculation View. This may involve updating connection strings, ODBC/JDBC configurations, or BI connector settings.

5. **Map Client (MANDT) Handling**  
   The Calculation View uses `defaultClient="crossClient"`, meaning it processes data across multiple SAP clients. In BigQuery, add a `WHERE MANDT = '<client_id>'` filter in downstream queries or partition the table by `MANDT` to optimize client-specific queries.

6. **Apply Partitioning and Clustering**  
   Evaluate date fields (e.g., `RX_OPEN_DAT`, `FS_OPEN_DAT`, `CREATED_ON`) for time-unit partitioning and high-cardinality fields (e.g., `STRNUM`, `PRCTR`, `DIVISION_CODE`) for clustering to optimize query performance and cost.

7. **Migrate Descriptions and Metadata**  
   Transfer the `defaultDescription` values from the Calculation View attributes (e.g., "Store Number", "Profit Center(Retail Store)") to BigQuery column descriptions using `ALTER TABLE` or `bq update` commands to preserve business metadata.

8. **Validate Aggregation Behavior**  
   The Calculation View defines 5 measures with `aggregationType="sum"`. Verify that BigQuery queries applying SUM aggregations on these measures (`RX_HRS_OPER`, `FS_HRS_OPER`, `RX_STORE`, `RETAIL_SQFT_AMT`, `TOTAL_SQFT_AMT`) produce identical results to the HANA view.

9. **Handle Translation-Relevant Fields**  
   The Calculation View has `translationRelevant="true"`, indicating potential multi-language support. If language-dependent text fields exist (e.g., `DIVISION_DESC`, `AREA_DESC`), create joins to BigQuery text tables or implement language-specific views.

10. **Update Orchestration for Data Refresh**  
    If the source table `TBL_WSS_SRP_ATTR_ACT` is populated via a Process Chain or ETL job, replace the SAP Process Chain with Cloud Composer (Airflow) or Workflows to orchestrate the data load into BigQuery and trigger Materialized View refresh if needed.

---

## 4. Optimization Techniques

### **Partitioning**
- **Time-Unit Partitioning:** Partition the underlying BigQuery table `TBL_WSS_SRP_ATTR_ACT` by date fields such as `CREATED_ON`, `RX_OPEN_DAT`, `FS_OPEN_DAT`, `BUDGET_OPEN_DAT`, or `CONST_OPEN_DAT` to enable query pruning and reduce scan costs for time-based queries.
- **Integer-Range Partitioning:** Consider integer-range partitioning on `STRNUM` (Store Number) if queries frequently filter by store ranges.

### **Clustering Keys**
- Apply clustering on high-cardinality filter columns: `STRNUM`, `PRCTR`, `DIVISION_CODE`, `AREA_CODE`, `REGION_CODE`, `DISTRICT_CODE`, `STATE`, `ZIPCODE`. Clustering improves query performance by co-locating related data and reducing data scanned.

### **Query Pruning**
- Leverage partitioning and clustering to enable automatic query pruning. Queries filtering on partitioned date columns or clustered keys will scan only relevant data blocks, reducing cost and latency.

### **Materialized Views**
- Implement the Calculation View as a BigQuery Materialized View to pre-compute and cache the projection of all 75 columns. This is especially beneficial for reporting workloads that repeatedly query the same dataset.
- Enable automatic refresh for the Materialized View to keep it synchronized with the base table `TBL_WSS_SRP_ATTR_ACT`.

### **BI Engine Acceleration**
- Enable BigQuery BI Engine for the Materialized View or underlying table to accelerate interactive queries from BI tools. BI Engine caches frequently accessed data in memory, reducing query latency for dashboards and reports.

### **Query Rewrite Opportunities**
- BigQuery's query optimizer can automatically rewrite queries against the base table to use the Materialized View when applicable. Ensure the Materialized View definition matches common query patterns (e.g., selecting all columns, applying SUM aggregations on measures).

### **Temporary Tables**
- For ad-hoc analytical queries requiring intermediate results, use BigQuery temporary tables to stage filtered or aggregated subsets of the data, avoiding repeated full table scans.

### **Refactor or Rebuild**
- **Recommendation:** **Refactor**  
- **Justification:** The Calculation View is a simple, single-node projection with no complex transformations, joins, filters, or routines. It can be directly converted to a BigQuery View or Materialized View using a straightforward SELECT statement. No rebuild is necessary; refactoring the SQL syntax is sufficient for migration.

---

## 5. Sensitive and Privacy Data Assessment

| **Field Name** | **Sensitive Classification** | **How to Handle It** |
|----------------|------------------------------|----------------------|
| ADDRESS | Personally Identifiable Information (PII) | Mask or tokenize the address field in non-production environments. Apply column-level security in BigQuery using IAM policies or data masking rules. Restrict access to authorized users only. |
| ZIPCODE | Potentially Sensitive (PII - Location Data) | While ZIP codes alone may not identify individuals, they can be combined with other fields to infer location. Apply access controls and consider aggregating to broader geographic regions (e.g., state level) for reporting. |

---

## 6. API Cost

**API COST:** 0.0000

---

**Note:** The API cost is calculated based on the analysis of the provided SAP HANA Calculation View XML file. Since this is a metadata analysis task with no actual BigQuery API calls (e.g., query execution, table scans, data loading), the cost is zero. Actual migration costs will depend on data volume, query frequency, and BigQuery operations performed during and after migration.