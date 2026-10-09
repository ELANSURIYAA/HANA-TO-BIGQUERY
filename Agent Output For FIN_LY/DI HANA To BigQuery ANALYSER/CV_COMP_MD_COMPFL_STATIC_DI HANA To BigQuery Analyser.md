---

<div style="border:1px solid #d0d7de;border-radius:6px;overflow:hidden;font-family:Arial,sans-serif;width:100%;margin-bottom:15px;">
<div style="background:#1f4e79;color:white;padding:10px;font-size:16px;font-weight:bold;">
CV_COMP_MD_COMPFL_STATIC Analyze Report
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
<td style="padding:8px;border:1px solid #ddd;">SAP HANA Calculation View with Projection node reading from CDS artifact TBL_WSS_SRP_COMPFLAG for Store Profile Comp Flag dimension data, migrated to BigQuery as a View with direct column projection.</td>
</tr>
</table>
</div>

**Asset Name:** CV_COMP_MD_COMPFL_STATIC

---

## 1. BigQuery Recommendations

### **(Best Fit) BigQuery View**

**Reason 1:** The Calculation View is a simple Projection node that performs direct column selection from a single CDS artifact (TBL_WSS_SRP_COMPFLAG) with no transformations, aggregations, joins, or filters. This maps directly to a BigQuery View with SELECT statement projecting all columns.

**Reason 2:** The asset is categorized as a DIMENSION data category with visibility set to "internal" and outputViewType as "Projection", indicating it serves as a semantic layer for dimension data consumption. BigQuery Views are optimal for lightweight semantic layers that do not require materialization.

**Reason 3:** No complex logic, routines, or data manipulation operations are present. The Calculation View performs a 1:1 attribute mapping from source to output, making a BigQuery View the most straightforward and cost-effective implementation without additional storage overhead.

### **(Alternative) BigQuery Materialized View**

**Reason 1:** If the underlying source table TBL_WSS_SRP_COMPFLAG is large and frequently queried, materializing the projection can improve query performance by pre-computing and storing the result set.

**Reason 2:** Materialized Views in BigQuery automatically refresh when the base table changes, ensuring data consistency while providing faster query response times for downstream consumers.

**Reason 3:** Trade-off: Introduces storage costs for the materialized result set and refresh overhead. Only recommended if query performance analysis indicates significant latency in accessing the source table or if the view is accessed very frequently by reporting tools.

---

## 2. Syntax Differences

| SAP HANA Construct | BigQuery Equivalent | Description |
|-------------------|---------------------|-------------|
| Calculation View (Projection node, DIMENSION dataCategory) | BigQuery View | The HANA Calculation View with a single Projection node performing direct column selection is converted to a BigQuery View using a SELECT statement with all columns from the source table. |
| CDS Artifact DataSource (`CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG`) | BigQuery Table Reference | The CDS artifact reference in HANA is replaced with a fully qualified BigQuery table reference in the format `project.dataset.TBL_WSS_SRP_COMPFLAG`. |
| Attribute Mapping (Direct 1:1 mapping) | Column Aliasing in SELECT | The direct attribute mappings in the Projection node (e.g., `target="MANDT" source="MANDT"`) translate to column selections in BigQuery SELECT statement. Since source and target names are identical, no aliasing is required. |
| `defaultClient="crossClient"` | Application-level filtering or View WHERE clause | HANA's cross-client access configuration must be handled in BigQuery through application logic or by adding a WHERE clause to filter by client (MANDT) if single-client access is required. |
| `defaultLanguage="$$language$$"` | Application-level parameter or BigQuery Scripting variable | HANA's language variable must be replaced with application-level language handling or passed as a parameter in BigQuery Stored Procedures/Scripting if language-dependent logic exists. |
| `translationRelevant="true"` | External translation service or lookup table | Translation metadata in HANA must be handled through external translation services or by joining with translation lookup tables in BigQuery. |
| `visibility="internal"` | BigQuery Dataset/View IAM permissions | HANA's internal visibility is enforced in BigQuery through IAM roles and dataset-level permissions to restrict access to authorized users/service accounts. |
| `checkAnalyticPrivileges="false"` | BigQuery IAM and Row-Level Security | Analytic privilege checking in HANA is replaced with BigQuery's IAM permissions and row-level security policies if fine-grained access control is required. |
| Calculation View XML metadata (descriptions, keyMapping) | BigQuery View definition with column comments | HANA's rich metadata (descriptions, default descriptions) should be captured as column-level comments in BigQuery using `OPTIONS(description="...")` in the CREATE VIEW statement. |

---

## 3. Manual Adjustments Post Agent Conversion

1. **Update BigQuery project and dataset references:** Replace the CDS artifact reference `CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG` with the fully qualified BigQuery table name in the format `<project_id>.<dataset_id>.TBL_WSS_SRP_COMPFLAG`. Ensure the target dataset exists in the BigQuery environment.

2. **Configure IAM roles and permissions:** Set up appropriate BigQuery IAM roles (e.g., `roles/bigquery.dataViewer`, `roles/bigquery.user`) to control access to the converted View, replacing HANA's internal visibility and analytic privilege settings.

3. **Implement client (MANDT) filtering logic:** Review business requirements for client handling. If single-client access is needed, add a WHERE clause to filter by MANDT or implement application-level filtering. If cross-client access is required, ensure the consuming applications handle multi-client data appropriately.

4. **Handle language parameter:** If the `$$language$$` variable is actively used by consuming applications, implement language handling through application-level parameters or BigQuery Scripting variables in downstream procedures/queries.

5. **Migrate column descriptions and metadata:** Manually add column-level descriptions to the BigQuery View using the `OPTIONS(description="...")` clause for each column, based on the descriptions present in the HANA Calculation View XML (e.g., "Client", "Profit Center(Retail Store)", "Store Number", etc.).

6. **Update downstream dependencies:** Identify and update all consuming BEx Queries, reports, or applications that reference the HANA Calculation View `CV_COMP_MD_COMPFL_STATIC` to point to the new BigQuery View. This may involve updating connection strings, query references, or BI tool configurations.

7. **Verify source table availability:** Ensure that the source table `TBL_WSS_SRP_COMPFLAG` has been successfully migrated to BigQuery and is accessible in the target dataset before creating the View.

8. **Configure BigQuery reservation and slot allocation:** If this View is part of a high-priority workload, configure BigQuery reservations and slot assignments to ensure consistent query performance.

---

## 4. Optimization Techniques

### **Partitioning**
Not applicable for this asset. The Calculation View performs a simple projection with no filters on time-based or range-based columns. If the source table `TBL_WSS_SRP_COMPFLAG` contains time-based columns (ZWEEK, ZMONTH, ZYEAR), consider partitioning the source table by a date-derived column (e.g., a calculated date from ZYEAR and ZMONTH) to enable partition pruning when queries filter on these fields.

### **Clustering Keys**
Recommend clustering the source table `TBL_WSS_SRP_COMPFLAG` on frequently filtered columns such as `PRCTR` (Profit Center), `STRNUM` (Store Number), and `ZYEAR` (Year). This will improve query performance when the View is consumed with filters on these dimensions.

### **Query Pruning**
Since the View projects all columns without filters, query pruning will depend on the consuming queries. Encourage downstream consumers to select only required columns and apply WHERE clause filters to leverage BigQuery's columnar storage and reduce data scanned.

### **Materialized Views**
Consider creating a Materialized View if performance analysis indicates that the View is frequently queried and the source table is large. Materialized Views can significantly reduce query latency by pre-computing and caching the result set. Monitor query patterns and costs before implementing.

### **Temporary Tables**
Not applicable. No complex transformations or intermediate result sets are present in this asset.

### **BI Engine Acceleration**
If the View is consumed by interactive dashboards or reporting tools (e.g., Looker Studio, Tableau), enable BI Engine acceleration for the underlying dataset to cache frequently accessed data in memory and improve dashboard load times.

### **Query Rewrite Opportunities**
No query rewrite opportunities identified. The Calculation View performs a straightforward projection with no redundant logic, suboptimal joins, or inefficient constructs.

### **Refactor or Rebuild**
**Recommendation:** Refactor

**Justification:** The Calculation View is a simple Projection node with direct attribute mapping and no complex logic. It can be directly refactored as a BigQuery View with minimal effort. The structure is straightforward, and no rebuild is necessary. The conversion involves translating the XML metadata to a SQL CREATE VIEW statement with appropriate column selections and metadata annotations.

---

## 5. Sensitive and Privacy Data Assessment

No sensitive data found

---

## 6. API Cost

**API COST:** 0.0000