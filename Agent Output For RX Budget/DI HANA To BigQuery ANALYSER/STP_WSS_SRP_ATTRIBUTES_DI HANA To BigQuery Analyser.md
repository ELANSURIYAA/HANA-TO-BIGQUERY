Since the GitHub upload requires valid credentials that aren't available, I'll provide you with the complete markdown content as the final answer:

---

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
<td style="padding:8px;border:1px solid #ddd;">2026-10-09</td>
</tr>
<tr>
<td style="padding:8px;border:1px solid #ddd;background:#f5f5f5;"><b>Description</b></td>
<td style="padding:8px;border:1px solid #ddd;">SAP HANA SQLScript stored procedure that performs full load ETL operations by deleting and inserting store attribute and comparison flag data from calculation views into target tables with session timestamp tracking.</td>
</tr>
</table>
</div>

---

## Asset Name: STP_WSS_SRP_ATTRIBUTES

---

## 1. BigQuery Recommendations

### **(Best Fit) BigQuery Stored Procedure with Scheduled Query**

**Reason 1:** The asset is an SAP HANA SQLScript stored procedure with procedural logic including variable declarations (V_WEEK, V_LY_WEEK), scalar function calls (SFN_PRIOR_FISCAL_WEEK), DELETE statements, and INSERT...SELECT operations. BigQuery Stored Procedures using BigQuery Scripting support all these constructs natively including DECLARE, CALL, DELETE, and INSERT statements.

**Reason 2:** The procedure performs a full load pattern (DELETE followed by INSERT) on two target tables (TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG) from two source calculation views (CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_COMPFL_S4). This batch ETL workload pattern maps directly to BigQuery Stored Procedures which can orchestrate multiple DML operations in a single transaction, maintaining the same atomicity guarantees.

**Reason 3:** The procedure includes session metadata capture (CURRENT_TIMESTAMP, SESSION_USER) and conditional filtering (WHERE ZWEEK = :V_WEEK). BigQuery Stored Procedures support CURRENT_TIMESTAMP(), SESSION_USER(), and parameterized WHERE clauses, enabling direct migration of this logic. The scheduled execution can be handled via BigQuery Scheduled Queries to invoke the stored procedure on a recurring basis.

### **(Alternative) BigQuery Scheduled Queries with Temporary Tables**

**Reason 1:** The ETL logic could be decomposed into separate BigQuery Scheduled Queries—one for each target table—using CREATE OR REPLACE TABLE AS SELECT statements to achieve the full load pattern without explicit DELETE statements, simplifying the implementation.

**Reason 2:** The scalar function call to SFN_PRIOR_FISCAL_WEEK could be replaced with a BigQuery User-Defined Function (UDF) or inline SQL logic to calculate the prior fiscal week, eliminating the dependency on a separate function object.

**Trade-off:** This approach loses the procedural orchestration and atomicity of the original stored procedure. If one scheduled query fails, the other may still execute, potentially causing data inconsistency between the two target tables. The stored procedure approach maintains transactional integrity across both table loads.

---

## 2. Syntax Differences

| **SAP HANA Construct** | **BigQuery Equivalent** | **Mapping Details** |
|------------------------|-------------------------|---------------------|
| `PROCEDURE "CVS_FRIP"."CVS_FRIP.Procedure.FI::STP_WSS_SRP_ATTRIBUTES" ( ) LANGUAGE SQLSCRIPT SQL SECURITY DEFINER DEFAULT SCHEMA "CVS_FRIP"` | `CREATE OR REPLACE PROCEDURE `project.dataset.STP_WSS_SRP_ATTRIBUTES`()` | SAP HANA stored procedure declaration maps to BigQuery Stored Procedure. SQL SECURITY DEFINER maps to BigQuery's default execution context (caller's permissions). DEFAULT SCHEMA is replaced by explicit project.dataset qualification in BigQuery. |
| `DECLARE V_WEEK NVARCHAR(6);` | `DECLARE V_WEEK STRING;` | NVARCHAR data type maps to STRING in BigQuery. Length constraints are not enforced in BigQuery STRING type. |
| `select "CVS_FRIP"."CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK"() INTO V_WEEK FROM DUMMY;` | `SET V_WEEK = (SELECT `project.dataset.SFN_PRIOR_FISCAL_WEEK`());` | SAP HANA SELECT...INTO...FROM DUMMY pattern maps to BigQuery SET with scalar subquery. DUMMY table is not needed in BigQuery. Scalar function call syntax changes from double-colon notation to standard SQL function call. |
| `DELETE FROM "CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT";` | `DELETE FROM `project.dataset.TBL_WSS_SRP_ATTR_ACT` WHERE TRUE;` | Unconditional DELETE statement maps directly to BigQuery DELETE with WHERE TRUE clause (required in BigQuery for unconditional deletes). |
| `INSERT INTO "CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT" (...) SELECT ... FROM "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4";` | `INSERT INTO `project.dataset.TBL_WSS_SRP_ATTR_ACT` (...) SELECT ... FROM `project.dataset.CV_BASE_MD_SRPACT_S4`;` | INSERT...SELECT statement syntax is identical. SAP HANA Calculation View (CV_BASE_MD_SRPACT_S4) in _SYS_BIC schema maps to BigQuery View or Table in a dataset. Double-colon and slash notation replaced with dot notation. |
| `CURRENT_TIMESTAMP` | `CURRENT_TIMESTAMP()` | SAP HANA CURRENT_TIMESTAMP keyword maps to BigQuery CURRENT_TIMESTAMP() function (requires parentheses). |
| `SESSION_USER` | `SESSION_USER()` | SAP HANA SESSION_USER keyword maps to BigQuery SESSION_USER() function (requires parentheses). |
| `WHERE ZWEEK = :V_WEEK` | `WHERE ZWEEK = V_WEEK` | SAP HANA variable reference with colon prefix (:V_WEEK) maps to BigQuery variable reference without prefix (V_WEEK). |
| `select 'Store attribute table loaded & Comp Flag table loaded for '\|\|:V_WEEK as "Summary" from dummy;` | `SELECT CONCAT('Store attribute table loaded & Comp Flag table loaded for ', V_WEEK) as Summary;` | String concatenation operator \|\| maps to CONCAT() function in BigQuery. DUMMY table not needed. Double-quoted identifiers map to backtick-quoted or unquoted identifiers in BigQuery. |
| SAP HANA Calculation View `"_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4"` | BigQuery View `project.dataset.CV_BASE_MD_SRPACT_S4` | SAP HANA Calculation Views accessed via _SYS_BIC schema map to BigQuery Views (or Materialized Views) in a dataset. The calculation view logic (Projection, Join, Aggregation nodes) must be converted to standard SQL SELECT statements. |
| SAP HANA Scalar Function `"CVS_FRIP"."CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK"()` | BigQuery UDF `project.dataset.SFN_PRIOR_FISCAL_WEEK()` | SAP HANA scalar functions map to BigQuery SQL User-Defined Functions (UDFs). Function body must be rewritten in BigQuery SQL or JavaScript. |

---

## 3. Manual Adjustments Post Agent Conversion

1. **Update BigQuery Project and Dataset References:** Replace all SAP HANA schema references ("CVS_FRIP", "_SYS_BIC") with appropriate BigQuery project and dataset identifiers in the format `project_id.dataset_id.object_name`. Update references to source calculation views (CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4) and target tables (TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG).

2. **Convert SAP HANA Calculation Views to BigQuery Views:** The source calculation views "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4" and "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4" must be separately converted to BigQuery Views or Materialized Views. Ensure these views are created in the target BigQuery dataset before executing the stored procedure.

3. **Migrate Scalar Function SFN_PRIOR_FISCAL_WEEK:** The scalar function "CVS_FRIP"."CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK" must be converted to a BigQuery SQL UDF. Analyze the function's logic and rewrite it using BigQuery SQL syntax. Update the function call in the stored procedure to reference the new BigQuery UDF.

4. **Configure BigQuery Scheduled Query for Procedure Execution:** Since the original SAP HANA procedure is likely invoked by a process chain or scheduled job, create a BigQuery Scheduled Query to execute the converted stored procedure on the required schedule (e.g., weekly, based on the fiscal week logic). Configure the schedule, time zone, and notification settings in the BigQuery console or via Terraform/API.

5. **Update IAM Permissions and Service Accounts:** Grant appropriate BigQuery IAM roles to the service account or user executing the stored procedure. Required permissions include `bigquery.tables.updateData` (for DELETE and INSERT operations), `bigquery.tables.getData` (for SELECT from source views), and `bigquery.routines.call` (for invoking the stored procedure and UDF).

6. **Replace Session Metadata Capture:** Verify that SESSION_USER() in BigQuery returns the expected user or service account identifier. If the original SAP HANA SESSION_USER tracked a different identifier (e.g., application user vs. database user), implement alternative logic to capture the appropriate user context, potentially using a procedure parameter or environment variable.

7. **Implement Error Handling and Logging:** The original SAP HANA procedure does not include explicit error handling. Add BEGIN...EXCEPTION...END blocks in the BigQuery Stored Procedure to handle potential errors (e.g., source view not found, constraint violations). Implement logging to a dedicated audit table or use Cloud Logging to track procedure execution status, row counts, and errors.

8. **Test Full Load Pattern and Transaction Behavior:** Validate that the DELETE followed by INSERT pattern in BigQuery maintains the expected atomicity. BigQuery Stored Procedures execute in a transactional context, but test rollback behavior in case of failures. Consider using CREATE OR REPLACE TABLE AS SELECT as an alternative to DELETE + INSERT for improved performance and atomicity.

9. **Update Downstream Dependencies:** Identify any downstream processes, reports, or applications that consume data from TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG. Update connection strings, dataset references, and queries to point to the new BigQuery tables. If the tables were previously consumed via SAP BEx queries or HANA views, migrate those consumption layers to BigQuery Views or BI tools like Looker Studio.

10. **Remove Unused Variable V_LY_WEEK:** The procedure declares `DECLARE V_LY_WEEK NVARCHAR(6);` but never uses this variable. Remove this declaration from the converted BigQuery Stored Procedure to clean up the code.

---

## 4. Optimization Techniques

### **Partitioning**
- **TBL_WSS_SRP_ATTR_ACT:** Implement time-unit column partitioning on the `SNAPSHOT_TIMESTAMP` column (ingestion-time partitioning alternative). Since the procedure performs a full DELETE and INSERT on every execution, partition pruning will not benefit the load process itself, but will significantly improve downstream query performance when filtering by snapshot date. Alternatively, if the table retains historical snapshots, partition on a date column derived from SNAPSHOT_TIMESTAMP (e.g., DATE(SNAPSHOT_TIMESTAMP)).

- **TBL_WSS_SRP_COMPFLAG:** Implement integer-range partitioning on the `ZWEEK` column (fiscal week) or time-unit partitioning on a derived date column from ZWEEK. The procedure inserts data filtered by `WHERE ZWEEK = :V_WEEK`, indicating weekly incremental loads. Partitioning by ZWEEK will enable partition pruning for downstream queries filtering by fiscal week and allow efficient partition-level DELETE operations if the load pattern changes from full to incremental.

### **Clustering Keys**
- **TBL_WSS_SRP_ATTR_ACT:** Apply clustering on `STRNUM` (store number), `PRCTR` (profit center), and `STATE` columns. These appear to be primary business keys for store attributes and are likely used in JOIN and WHERE clauses in downstream queries. Clustering will co-locate related rows and improve query performance.

- **TBL_WSS_SRP_COMPFLAG:** Apply clustering on `PRCTR` (profit center), `STRNUM` (store number), and `ZWEEK` (fiscal week) columns. These are likely filter and join keys in analytical queries. Clustering on ZWEEK in combination with partitioning will maximize query pruning efficiency.

### **Materialized Views**
- Consider creating a Materialized View on top of the source calculation view `CV_BASE_MD_SRPACT_S4` if the calculation view involves complex joins or aggregations and is queried frequently by multiple downstream processes. This would reduce the computational cost of the INSERT...SELECT operation in the stored procedure. However, since the procedure already materializes the result into TBL_WSS_SRP_ATTR_ACT, this optimization is only beneficial if the calculation view is consumed by other processes as well.

### **Query Pruning**
- The INSERT statement for TBL_WSS_SRP_COMPFLAG includes `WHERE ZWEEK = :V_WEEK`, which is an effective filter. Ensure that the source calculation view `CV_BASE_MD_COMPFL_S4` is optimized to push down this filter predicate. If the calculation view is converted to a BigQuery View, verify that the WHERE clause is applied early in the query plan to minimize data scanned.

### **Temporary Tables**
- The procedure does not currently use temporary tables. However, if the source calculation views involve complex multi-step transformations, consider breaking the INSERT...SELECT logic into intermediate temporary tables within the stored procedure. This can improve debugging, enable incremental checkpointing, and reduce memory pressure for large datasets. Use `CREATE TEMP TABLE` within the stored procedure for intermediate results.

### **BI Engine Acceleration**
- Not applicable for this ETL stored procedure, as BI Engine is designed to accelerate interactive queries and dashboards, not batch data loading operations. However, if downstream BI tools query TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG frequently, enable BI Engine on the dataset to cache query results and improve dashboard performance.

### **Query Rewrite Opportunities**
- **Replace DELETE + INSERT with CREATE OR REPLACE TABLE:** The current full load pattern uses DELETE followed by INSERT. In BigQuery, this can be optimized by using `CREATE OR REPLACE TABLE TBL_WSS_SRP_ATTR_ACT AS SELECT ... FROM CV_BASE_MD_SRPACT_S4`. This approach is more efficient as it avoids the DELETE operation and leverages BigQuery's atomic table replacement. However, this changes the table's metadata (creation timestamp), which may impact downstream processes that rely on table metadata. Evaluate this trade-off based on downstream dependencies.

- **Batch INSERT Optimization:** The INSERT...SELECT statements already follow best practices by inserting all rows in a single operation. No further optimization needed for insert batching.

- **Eliminate Unused Variable:** Remove the unused variable `V_LY_WEEK` to simplify the procedure and reduce memory overhead.

### **Refactor or Rebuild**
**Recommendation:** **Refactor**

**Justification:** The procedure is relatively straightforward with clear ETL logic: variable initialization, DELETE operations, INSERT...SELECT operations, and a summary SELECT statement. The procedural constructs (DECLARE, SET, DELETE, INSERT) map directly to BigQuery Stored Procedure syntax with minimal complexity. The main refactoring effort involves:
1. Converting the scalar function SFN_PRIOR_FISCAL_WEEK to a BigQuery UDF.
2. Converting the two source calculation views (CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4) to BigQuery Views.
3. Updating schema references and syntax (e.g., CURRENT_TIMESTAMP(), SESSION_USER(), CONCAT()).

A full rebuild is not necessary as the logic does not involve complex control flow (no loops, cursors, or nested procedures), advanced HANA-specific features (no HANA-specific analytic functions, SDA, or complex calculation view nodes), or performance-critical transformations that would benefit from a complete redesign. Refactoring the existing procedure to BigQuery Scripting syntax is the most efficient migration path.

---

## 5. Sensitive and Privacy Data Assessment

| Field Name | Sensitive Classification | How to Handle It |
|------------|-------------------------|------------------|
| ADDRESS | Personally Identifiable Information (PII) - Physical Address | Apply column-level encryption using Cloud KMS or implement field-level tokenization. Restrict access using BigQuery column-level security policies. Consider masking or redacting for non-production environments. |
| ZIPCODE | Personally Identifiable Information (PII) - Geographic Identifier | While ZIPCODE alone may not uniquely identify an individual, in combination with other fields (ADDRESS, CITY, STATE) it can be used for re-identification. Apply the same access controls as ADDRESS. Consider generalizing to 3-digit ZIP codes for analytical use cases that don't require full precision. |

---

## 6. API Cost

**API COST: 0.0000**

**Calculation Basis:** The provided asset is a stored procedure definition (DDL/metadata) and does not contain actual data or query execution. API cost for BigQuery is incurred during query execution based on data scanned. Since this is a static code analysis of the procedure structure, no data is processed and no API cost is incurred. Actual execution cost will depend on:
- Volume of data in source calculation views (CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4)
- Number of rows inserted into target tables (TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG)
- Frequency of scheduled execution
- Use of partitioning and clustering to optimize data scanned

Estimated runtime cost should be calculated during testing phase based on actual data volumes.

---