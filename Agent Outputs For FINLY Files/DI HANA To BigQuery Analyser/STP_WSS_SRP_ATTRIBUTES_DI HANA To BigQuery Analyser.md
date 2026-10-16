<div style="border:1px solid #d0d7de;border-radius:6px;overflow:hidden;font-family:Arial,sans-serif;width:100%;margin-bottom:15px;">
<div style="background:#1f4e79;color:white;padding:10px;font-size:16px;font-weight:bold;">
STP_WSS_SRP_ATTRIBUTES Analyze Report
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
<td style="padding:8px;border:1px solid #ddd;">SQLScript procedure that truncates and reloads store attributes and comp flag data from HANA calculation views into BigQuery tables with timestamp tracking.</td>
</tr>
</table>
</div>

## Asset Name: STP_WSS_SRP_ATTRIBUTES

## 1. BigQuery Recommendations

### (Best Fit)
**BigQuery Scheduled Query with Stored Procedure**

**Reason 1:** The procedure performs full truncate-and-load operations (DELETE followed by INSERT) on two target tables, which aligns perfectly with BigQuery Scheduled Queries executing stored procedures that perform `TRUNCATE TABLE` or `DELETE` followed by `INSERT` statements.

**Reason 2:** The procedure uses scalar function calls (`SFN_PRIOR_FISCAL_WEEK()`) and variable declarations (`V_WEEK`, `V_LY_WEEK`), which can be directly implemented in BigQuery Scripting with DECLARE statements and user-defined functions (UDFs) or scalar subqueries.

**Reason 3:** The procedure reads from HANA Calculation Views (`CV_BASE_MD_SRPACT_S4`, `CV_BASE_MD_COMPFL_S4`) and writes to target tables with session metadata (`CURRENT_TIMESTAMP`, `SESSION_USER`), which maps naturally to BigQuery Views as source and BigQuery native functions (`CURRENT_TIMESTAMP()`, `SESSION_USER()`) for metadata tracking.

### (Alternative)
**BigQuery Data Transfer Service with Materialized Views**

**Reason 1:** If the source HANA Calculation Views are refreshed on a regular schedule, BigQuery Data Transfer Service could automate the data ingestion from external sources into staging tables, followed by transformation logic in materialized views.

**Reason 2:** This approach reduces the need for custom stored procedure logic by leveraging native BigQuery refresh mechanisms, but requires additional configuration for external data connectivity.

## 2. Syntax Differences

| SAP BW HANA Construct | BigQuery Equivalent | Example from Asset |
|----------------------|---------------------|-------------------|
| SQLScript Procedure with `LANGUAGE SQLSCRIPT` | BigQuery Stored Procedure with `LANGUAGE SQL` | `PROCEDURE "CVS_FRIP"."CVS_FRIP.Procedure.FI::STP_WSS_SRP_ATTRIBUTES" ( ) LANGUAGE SQLSCRIPT` → `CREATE OR REPLACE PROCEDURE CVS_FRIP.STP_WSS_SRP_ATTRIBUTES() BEGIN ... END;` |
| `DECLARE V_WEEK NVARCHAR(6);` | `DECLARE V_WEEK STRING;` | `DECLARE V_WEEK NVARCHAR(6);` → `DECLARE V_WEEK STRING;` |
| Scalar function call: `"CVS_FRIP"."CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK"()` | BigQuery UDF or inline SQL expression | `select "CVS_FRIP"."CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK"() INTO V_WEEK FROM DUMMY;` → `SET V_WEEK = (SELECT CVS_FRIP.SFN_PRIOR_FISCAL_WEEK());` or inline calculation |
| `DELETE FROM "CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT";` | `DELETE FROM CVS_FRIP.TBL_WSS_SRP_ATTR_ACT WHERE TRUE;` or `TRUNCATE TABLE CVS_FRIP.TBL_WSS_SRP_ATTR_ACT;` | Full table delete → BigQuery `TRUNCATE TABLE` for performance |
| Reading from Calculation View: `FROM "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4"` | `FROM CVS_FRIP.CV_BASE_MD_SRPACT_S4` (BigQuery View) | Calculation View as source → BigQuery View |
| `INSERT INTO "CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT" (column_list) SELECT ...` | `INSERT INTO CVS_FRIP.TBL_WSS_SRP_ATTR_ACT (column_list) SELECT ...` | Direct mapping with schema-qualified table names |
| `CURRENT_TIMESTAMP` | `CURRENT_TIMESTAMP()` | Metadata column population |
| `SESSION_USER` | `SESSION_USER()` | User tracking column |
| `WHERE ZWEEK = :V_WEEK` | `WHERE ZWEEK = V_WEEK` | Variable binding syntax (remove colon prefix) |
| `FROM DUMMY` | Not required in BigQuery | `SELECT ... FROM DUMMY;` → `SELECT ...;` |
| `select 'Store attribute table loaded & Comp Flag table loaded for '||:V_WEEK as "Summary" from dummy;` | `SELECT CONCAT('Store attribute table loaded & Comp Flag table loaded for ', V_WEEK) AS Summary;` | String concatenation operator change (`||` → `CONCAT()`) |

## 3. Manual Adjustments Post Agent Conversion

1. **Update BigQuery project and dataset references**: Replace HANA schema references (`"CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT"`) with BigQuery fully-qualified table names (`project_id.CVS_FRIP.TBL_WSS_SRP_ATTR_ACT`).

2. **Replace scalar function call**: Convert the HANA scalar function `SFN_PRIOR_FISCAL_WEEK()` to a BigQuery UDF or inline SQL logic. If the function logic is available, create a BigQuery SQL UDF; otherwise, implement equivalent date calculation logic inline.

3. **Configure BigQuery Scheduled Query**: Set up a BigQuery Scheduled Query to execute the converted stored procedure on the required schedule (replacing any SAP Process Chain or job scheduler dependency).

4. **Update IAM permissions**: Grant the service account executing the stored procedure appropriate roles (`bigquery.dataEditor`, `bigquery.jobUser`) on the target dataset and tables.

5. **Replace `SESSION_USER` logic**: Verify that `SESSION_USER()` returns the expected identifier in BigQuery context (service account email). If business logic requires a specific user identifier, replace with a parameter or configuration value.

6. **Remove `FROM DUMMY` references**: Eliminate all `FROM DUMMY` clauses in SELECT statements, as BigQuery does not require a dummy table for scalar queries.

7. **Update source view references**: Ensure that the HANA Calculation Views (`CV_BASE_MD_SRPACT_S4`, `CV_BASE_MD_COMPFL_S4`) have been migrated to BigQuery Views and update the `FROM` clauses accordingly.

8. **Configure external data source (if applicable)**: If the HANA Calculation Views source data from external systems, configure BigQuery External Tables or Data Transfer Service connections to replicate the data pipeline.

## 4. Optimization Techniques

### Partitioning
- **TBL_WSS_SRP_ATTR_ACT**: Consider partitioning by `SNAPSHOT_TIMESTAMP` (time-unit column) to enable efficient time-based queries and reduce scan costs.
- **TBL_WSS_SRP_COMPFLAG**: Partition by `ZWEEK` (fiscal week) to optimize filtering by week in downstream queries.

### Clustering Keys
- **TBL_WSS_SRP_ATTR_ACT**: Cluster by `STRNUM`, `PRCTR`, `STATE` to optimize queries filtering or joining on store number, profit center, or state.
- **TBL_WSS_SRP_COMPFLAG**: Cluster by `STRNUM`, `ZWEEK`, `PRCTR` to optimize week-based and store-based lookups.

### Query Pruning
- Add `WHERE` clauses in the source views (`CV_BASE_MD_SRPACT_S4`, `CV_BASE_MD_COMPFL_S4`) to filter data at the source if only a subset of records is needed, reducing data transfer and processing costs.

### Materialized Views
- If the source calculation views (`CV_BASE_MD_SRPACT_S4`, `CV_BASE_MD_COMPFL_S4`) involve complex joins or aggregations, consider converting them to BigQuery Materialized Views to pre-compute results and reduce query latency.

### Temporary Tables
- Not applicable for this asset, as the procedure performs direct INSERT operations without intermediate result sets.

### BI Engine Acceleration
- Enable BI Engine for the target tables (`TBL_WSS_SRP_ATTR_ACT`, `TBL_WSS_SRP_COMPFLAG`) if they are frequently queried by BI tools for sub-second response times.

### Query Rewrite Opportunities
- Replace the full `DELETE` + `INSERT` pattern with `TRUNCATE TABLE` + `INSERT` for better performance in BigQuery, as `TRUNCATE` is more efficient for full table refreshes.
- If incremental load logic can be introduced (based on `SNAPSHOT_TIMESTAMP` or `ZWEEK`), replace the full load with a `MERGE` statement to reduce data processing volume.

### Refactor or Rebuild
**Recommendation:** Refactor

**Justification:** The procedure is straightforward with clear truncate-and-load logic, variable declarations, and scalar function calls. It can be directly converted to BigQuery Scripting with minimal refactoring (removing HANA-specific syntax, updating function calls, and optimizing DELETE operations). The logic does not involve complex control flow, cursors, or nested procedures that would require a full rebuild.

## 5. Sensitive and Privacy Data Assessment

| Field Name | Sensitive Classification | How to Handle It |
|-----------|-------------------------|------------------|
| ADDRESS | Personally Identifiable Information (PII) | Apply column-level encryption or tokenization; restrict access using BigQuery column-level security policies |
| CITY | Potentially Identifiable Information (combined with other fields) | Consider masking or restricting access when combined with ADDRESS and ZIPCODE |
| ZIPCODE | Potentially Identifiable Information (combined with other fields) | Consider masking or restricting access when combined with ADDRESS and CITY |

## 6. API Cost

**API COST:** 0.0000

---

**Note:** The API cost is calculated based on the function calls made during the analysis. No external API calls were required for this asset analysis beyond the current date retrieval.