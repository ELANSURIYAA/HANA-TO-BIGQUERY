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
<td style="padding:8px;border:1px solid #ddd;">2026-10-16</td>
</tr>
<tr>
<td style="padding:8px;border:1px solid #ddd;background:#f5f5f5;"><b>Description</b></td>
<td style="padding:8px;border:1px solid #ddd;">SAP HANA Calculation View providing a wrapper aggregation layer on snapshot table TBL_WSS_SRP_ATTR_ACT for Store Profile Attributes Actuals reporting, migrated to BigQuery as a View with aggregation logic.</td>
</tr>
</table>
</div>

**Asset Name:** CV_COMP_MD_SRPACT_STATIC

---

## 1. BigQuery Recommendations

### **(Best Fit) BigQuery View**

**Reason 1:** The Calculation View is a simple projection-based aggregation view with no complex transformations, joins, or unions. It directly maps all 75 columns from the source CDS artifact `TBL_WSS_SRP_ATTR_ACT` to output attributes and measures, making it an ideal candidate for a BigQuery View that performs column selection and aggregation.

**Reason 2:** The view contains 5 base measures (`RX_HRS_OPER`, `FS_HRS_OPER`, `RX_STORE`, `RETAIL_SQFT_AMT`, `TOTAL_SQFT_AMT`) with SUM aggregation type and 70 dimension attributes. This aggregation logic can be directly translated to a BigQuery View with `SUM()` aggregate functions and `GROUP BY` clauses on dimension attributes.

**Reason 3:** The Calculation View is marked as `outputViewType="Aggregation"` and `dataCategory="CUBE"` with `visibility="reportingEnabled"`, indicating it is designed for reporting consumption. BigQuery Views are optimized for analytical queries and reporting workloads, providing a semantic layer over the underlying table without data duplication.

### **(Alternative) BigQuery Materialized View**

**Reason 1:** If query performance becomes a concern due to frequent access or complex aggregations on the underlying table `TBL_WSS_SRP_ATTR_ACT`, a BigQuery Materialized View can pre-compute and store the aggregated results, reducing query latency.

**Reason 2:** Materialized Views in BigQuery automatically refresh when the base table changes, maintaining data freshness while improving query performance for repetitive analytical queries.

**Reason 3:** Trade-off: Materialized Views incur storage costs and have limitations on supported SQL features (e.g., no window functions, limited JOIN support). Given the simple projection and aggregation logic in this Calculation View, a standard View is sufficient unless performance benchmarks indicate otherwise.

---

## 2. Syntax Differences

| **SAP HANA Construct** | **BigQuery Equivalent** | **Example from Asset** |
|------------------------|-------------------------|------------------------|
| Calculation View (Projection node) | BigQuery View with SELECT statement | `calculationView xsi:type="Calculation:ProjectionView" id="Projection_1"` maps to `CREATE VIEW AS SELECT` with all 75 columns |
| CDS Artifact as DataSource | BigQuery Table | `DataSource id="TBL_WSS_SRP_ATTR_ACT" type="CDS_ARTIFACT"` becomes the base table in BigQuery |
| Attribute mapping (Direct Assignment) | Column aliasing in SELECT | `<mapping xsi:type="Calculation:AttributeMapping" target="MANDT" source="MANDT"/>` becomes `SELECT MANDT` |
| Base Measure with SUM aggregation | SUM() aggregate function with GROUP BY | `<measure id="RX_HRS_OPER" aggregationType="sum">` becomes `SUM(RX_HRS_OPER) AS RX_HRS_OPER` |
| logicalModel attributes | Dimension columns in GROUP BY clause | 70 attributes (MANDT, STRNUM, PRCTR, etc.) become `GROUP BY MANDT, STRNUM, PRCTR, ...` |
| outputViewType="Aggregation" | Aggregation query with GROUP BY | View definition includes `GROUP BY` on all dimension attributes with `SUM()` on measures |
| dataCategory="CUBE" | BigQuery Table or View for OLAP workloads | Semantic layer implemented as BigQuery View for reporting |
| visibility="reportingEnabled" | BigQuery View accessible by BI tools | View granted SELECT permissions for reporting users/service accounts |

---

## 3. Manual Adjustments Post Agent Conversion

1. **BigQuery Project and Dataset Configuration**: Update the converted SQL script to reference the correct BigQuery project ID and dataset name where the base table `TBL_WSS_SRP_ATTR_ACT` resides.

2. **IAM Permissions and Access Control**: Grant `roles/bigquery.dataViewer` or `roles/bigquery.user` to users and service accounts that need to query the migrated view `CV_COMP_MD_SRPACT_STATIC`.

3. **Base Table Reference Update**: Ensure the base table `TBL_WSS_SRP_ATTR_ACT` has been successfully migrated to BigQuery and update the view definition to reference the correct fully-qualified table name `project.dataset.TBL_WSS_SRP_ATTR_ACT`.

4. **BI Tool Connection Reconfiguration**: Update reporting tools (e.g., Looker Studio, Tableau, Power BI) that previously connected to the SAP HANA Calculation View to now query the BigQuery View using BigQuery connectors.

5. **Data Type Validation**: Verify that all 75 columns in the BigQuery table `TBL_WSS_SRP_ATTR_ACT` have compatible data types with the original HANA table. Adjust any date/time or numeric precision mismatches in the view definition if necessary.

6. **Aggregation Logic Verification**: Confirm that the SUM aggregation behavior on the 5 measures (`RX_HRS_OPER`, `FS_HRS_OPER`, `RX_STORE`, `RETAIL_SQFT_AMT`, `TOTAL_SQFT_AMT`) produces identical results in BigQuery compared to the HANA Calculation View by running validation queries.

7. **Client Field Handling**: The `MANDT` (Client) field is present in the view. If the BigQuery environment uses a single-client model, consider filtering or excluding this field from the view definition or ensuring it is handled consistently in downstream queries.

---

## 4. Optimization Techniques

### **Partitioning**
- **Recommendation**: Partition the base table `TBL_WSS_SRP_ATTR_ACT` by a date column such as `CREATED_ON`, `FS_OPEN_DAT`, or `RX_OPEN_DAT` to enable efficient query pruning when filtering by date ranges in reporting queries.
- **Justification**: The Calculation View exposes multiple date fields (e.g., `RX_OPEN_DAT`, `FS_OPEN_DAT`, `CREATED_ON`). Partitioning on a frequently filtered date column reduces scan costs and improves query performance.

### **Clustering Keys**
- **Recommendation**: Cluster the base table `TBL_WSS_SRP_ATTR_ACT` on high-cardinality dimension columns such as `STRNUM` (Store Number), `DIVISION_CODE`, `AREA_CODE`, and `REGION_CODE`.
- **Justification**: These fields are commonly used in WHERE clauses and GROUP BY operations in store-level reporting queries. Clustering organizes data physically to minimize data scanned during queries.

### **Query Pruning**
- **Recommendation**: Ensure the BigQuery View includes only the necessary columns for specific reporting use cases. If certain attributes or measures are rarely used, create multiple targeted views instead of a single wide view.
- **Justification**: The view exposes 75 columns. Reducing column width in queries minimizes I/O and improves performance.

### **Materialized Views**
- **Recommendation**: If the view is queried frequently with the same aggregation patterns (e.g., SUM of measures grouped by Division, Area, Region), create a Materialized View to pre-compute and cache results.
- **Justification**: Materialized Views automatically refresh and reduce query latency for repetitive analytical queries.

### **BI Engine Acceleration**
- **Recommendation**: Enable BI Engine for the dataset containing the view to accelerate interactive dashboards and reporting queries with sub-second response times.
- **Justification**: The view is designed for reporting (`visibility="reportingEnabled"`), making it a strong candidate for BI Engine caching.

### **Refactor or Rebuild**
- **Decision**: **Refactor**
- **Justification**: The Calculation View is a straightforward projection with aggregation logic and no complex transformations, joins, or routines. It can be directly refactored into a BigQuery View with minimal changes. No rebuild is necessary.

---

## 5. Sensitive and Privacy Data Assessment

| Field Name | Sensitive Classification | How to Handle It |
|------------|--------------------------|------------------|
| ADDRESS | PII (Personally Identifiable Information) | Mask or tokenize the address field in the view definition using BigQuery's `CONCAT(SUBSTR(ADDRESS, 1, 3), '***')` or apply column-level access control with BigQuery Policy Tags. |
| ZIPCODE | PII (Personally Identifiable Information) | Mask the last 4 digits of the zipcode using `CONCAT(SUBSTR(ZIPCODE, 1, 3), '**')` or restrict access using BigQuery Data Catalog Policy Tags. |

---

## 6. API Cost

**API COST:** 0.0000