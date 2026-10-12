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
<td style="padding:8px;border:1px solid #ddd;">2026-10-12</td>
</tr>
<tr>
<td style="padding:8px;border:1px solid #ddd;background:#f5f5f5;"><b>Description</b></td>
<td style="padding:8px;border:1px solid #ddd;">SAP HANA SQLScript procedure that deletes and reloads store attribute and comparison flag data from calculation views into target tables with weekly snapshot timestamps.</td>
</tr>
</table>
</div>

---

**Asset Name:** STP_WSS_SRP_ATTRIBUTES

---

## 1. BigQuery Recommendations

### **(Best Fit) BigQuery Scheduled Query with BigQuery Stored Procedure**

**Reason 1:** The procedure performs DELETE and INSERT operations with session-based execution logic, which maps directly to BigQuery Stored Procedures using BigQuery Scripting (DECLARE, DELETE, INSERT, SELECT INTO statements).

**Reason 2:** The weekly scheduled execution pattern (using prior fiscal week calculation via scalar function) aligns with BigQuery Scheduled Queries that can invoke stored procedures on a recurring schedule (e.g., weekly cron schedule).

**Reason 3:** The procedure reads from calculation views (CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4) and writes to target tables (TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG), which translates to BigQuery Views as sources and BigQuery Tables as targets, with full refresh pattern (DELETE + INSERT = TRUNCATE + INSERT or CREATE OR REPLACE TABLE AS SELECT).

### **(Alternative) BigQuery Scheduled Query with MERGE Statements**

**Reason 1:** Instead of DELETE + INSERT pattern, use BigQuery MERGE statements for more efficient upsert operations, reducing table rewrites and improving performance for large datasets.

**Reason 2:** MERGE allows conditional logic to handle incremental updates if the source calculation views support delta detection, though the current procedure uses full refresh.

**Reason 3:** Trade-off: Requires refactoring the full refresh logic to identify keys for matching (STRNUM, PRCTR for TBL_WSS_SRP_ATTR_ACT; PRCTR, STRNUM, ZWEEK for TBL_WSS_SRP_COMPFLAG), adding complexity compared to the straightforward DELETE + INSERT pattern.

---

## 2. Syntax Differences

| **SAP HANA Construct** | **BigQuery Equivalent** | **Example from Asset** |
|------------------------|-------------------------|------------------------|
| PROCEDURE with LANGUAGE SQLSCRIPT | BigQuery Stored Procedure using BigQuery Scripting | `PROCEDURE "CVS_FRIP"."CVS_FRIP.Procedure.FI::STP_WSS_SRP_ATTRIBUTES" ( )` → `CREATE OR REPLACE PROCEDURE CVS_FRIP.STP_WSS_SRP_ATTRIBUTES()` |
| DECLARE NVARCHAR(6) | DECLARE STRING | `DECLARE V_WEEK NVARCHAR(6);` → `DECLARE V_WEEK STRING;` |
| SELECT INTO FROM DUMMY | SELECT AS (assignment) | `select "CVS_FRIP"."CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK"() INTO V_WEEK FROM DUMMY;` → `SET V_WEEK = (SELECT CVS_FRIP.SFN_PRIOR_FISCAL_WEEK());` |
| Scalar Function call (SFN_PRIOR_FISCAL_WEEK) | BigQuery UDF (User-Defined Function) | `"CVS_FRIP"."CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK"()` → `CVS_FRIP.SFN_PRIOR_FISCAL_WEEK()` (requires UDF migration) |
| DELETE FROM table | DELETE FROM table WHERE TRUE | `DELETE FROM "CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT";` → `DELETE FROM CVS_FRIP.TBL_WSS_SRP_ATTR_ACT WHERE TRUE;` |
| INSERT INTO with explicit column list | INSERT INTO with explicit column list (same syntax) | `INSERT INTO "CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT" (columns...)` → `INSERT INTO CVS_FRIP.TBL_WSS_SRP_ATTR_ACT (columns...)` |
| SELECT FROM "_SYS_BIC"."schema.package/ViewName" (Calculation View) | SELECT FROM `project.dataset.view_name` (BigQuery View) | `FROM "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4"` → `FROM CVS_FRIP.CV_BASE_MD_SRPACT_S4` |
| CURRENT_TIMESTAMP | CURRENT_TIMESTAMP() | `CURRENT_TIMESTAMP` → `CURRENT_TIMESTAMP()` |
| SESSION_USER | SESSION_USER() | `SESSION_USER` → `SESSION_USER()` |
| WHERE ZWEEK = :V_WEEK (variable binding) | WHERE ZWEEK = V_WEEK (direct variable reference) | `WHERE ZWEEK = :V_WEEK` → `WHERE ZWEEK = V_WEEK` |
| SELECT 'message' as "Column" from dummy | SELECT 'message' as Column | `select 'Store attribute table loaded & Comp Flag table loaded for '||:V_WEEK as "Summary" from dummy` → `SELECT CONCAT('Store attribute table loaded & Comp Flag table loaded for ', V_WEEK) as Summary` |
| String concatenation with \|\| operator | CONCAT function or \|\| operator (both supported) | `'text'||:V_WEEK` → `CONCAT('text', V_WEEK)` or `'text' || V_WEEK` |
| SQL SECURITY DEFINER | Not directly supported (use authorized views/procedures with service account permissions) | `SQL SECURITY DEFINER` → Configure BigQuery stored procedure execution with appropriate service account and dataset-level IAM roles |
| DEFAULT SCHEMA "CVS_FRIP" | Use fully qualified table names or set default dataset in session | `DEFAULT SCHEMA "CVS_FRIP"` → Use `project.CVS_FRIP.table_name` or configure default dataset in BigQuery session/script |

---

## 3. Manual Adjustments Post Agent Conversion

1. **Update BigQuery Project and Dataset References**: Replace HANA schema references (`"CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT"`) with BigQuery fully qualified names (`project_id.CVS_FRIP.TBL_WSS_SRP_ATTR_ACT`). Configure the target BigQuery project and dataset.

2. **Migrate Scalar Function SFN_PRIOR_FISCAL_WEEK**: Convert the HANA scalar function `"CVS_FRIP"."CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK"()` to a BigQuery UDF (SQL or JavaScript). Ensure the function logic for calculating prior fiscal week is accurately replicated.

3. **Migrate Source Calculation Views**: Convert HANA Calculation Views `"_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4"` and `"_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4"` to BigQuery Views or Materialized Views. Update references in the stored procedure to point to the new BigQuery view names.

4. **Configure BigQuery Scheduled Query**: Replace the HANA-based scheduling mechanism with a BigQuery Scheduled Query that invokes the converted stored procedure on a weekly basis (e.g., every Monday at a specified time). Configure the schedule using cron syntax or BigQuery's scheduling UI.

5. **Update IAM Roles and Permissions**: Grant the BigQuery service account appropriate permissions for executing stored procedures, reading from source views, and writing to target tables. Replace HANA SQL SECURITY DEFINER behavior with BigQuery dataset-level and table-level IAM roles (e.g., `roles/bigquery.dataEditor`, `roles/bigquery.jobUser`).

6. **Replace SESSION_USER with Service Account Identifier**: Update the `CREATED_BY` and `SNAPSHOT_CREATED_BY` column population logic. Replace `SESSION_USER` with a service account identifier or use BigQuery's `SESSION_USER()` function if applicable, ensuring it captures the correct execution context.

7. **Update Table Schema Definitions**: Ensure target tables `TBL_WSS_SRP_ATTR_ACT` and `TBL_WSS_SRP_COMPFLAG` are created in BigQuery with matching column names, data types, and constraints. Map HANA data types (e.g., NVARCHAR, DATE) to BigQuery equivalents (STRING, DATE).

8. **Configure Monitoring and Logging**: Set up BigQuery audit logs and monitoring for the scheduled query and stored procedure execution. Replace HANA-specific logging (e.g., the final SELECT statement returning 'Summary') with BigQuery logging or Cloud Logging integration.

9. **Test Variable Declaration and Assignment**: Validate that variable declarations (`DECLARE V_WEEK STRING;`) and assignments (`SET V_WEEK = ...;`) work correctly in BigQuery Scripting. Test the WHERE clause filtering logic (`WHERE ZWEEK = V_WEEK`) to ensure variable binding behaves as expected.

10. **Update Snapshot Timestamp Logic**: Verify that `CURRENT_TIMESTAMP()` in BigQuery produces the expected timestamp format and timezone. Adjust if necessary to match HANA's `CURRENT_TIMESTAMP` behavior (e.g., UTC vs. local timezone).

---

## 4. Optimization Techniques

### **Partitioning**
- **TBL_WSS_SRP_ATTR_ACT**: Partition by `SNAPSHOT_TIMESTAMP` (time-unit column partitioning, daily or monthly) to improve query performance when filtering by snapshot date and reduce full table scans during DELETE operations.
- **TBL_WSS_SRP_COMPFLAG**: Partition by `ZWEEK` (integer-range partitioning) to optimize filtering by fiscal week and enable partition pruning during INSERT and SELECT operations.

### **Clustering**
- **TBL_WSS_SRP_ATTR_ACT**: Cluster by `STRNUM`, `PRCTR` to optimize queries filtering or joining on store number and profit center, which are likely key dimensions for downstream reporting.
- **TBL_WSS_SRP_COMPFLAG**: Cluster by `PRCTR`, `STRNUM`, `ZWEEK` to improve performance for queries filtering by profit center, store number, and fiscal week.

### **Materialized Views**
- Convert source calculation views `CV_BASE_MD_SRPACT_S4` and `CV_BASE_MD_COMPFL_S4` to BigQuery Materialized Views if they involve complex joins, aggregations, or expensive computations. This precomputes results and reduces query latency during the INSERT operations.

### **Query Pruning**
- Use partitioning and clustering (as described above) to enable automatic query pruning, reducing the amount of data scanned during DELETE and INSERT operations.

### **Temporary Tables**
- Not applicable for this procedure, as it performs direct DELETE + INSERT operations. Temporary tables would be useful if intermediate transformations or staging logic were required before final INSERT.

### **BI Engine Acceleration**
- Enable BI Engine for downstream reporting queries that read from `TBL_WSS_SRP_ATTR_ACT` and `TBL_WSS_SRP_COMPFLAG`. This in-memory analysis service accelerates queries with filters and aggregations on these tables.

### **Query Rewrite Opportunities**
- **Replace DELETE + INSERT with TRUNCATE + INSERT**: Since the procedure deletes all rows from `TBL_WSS_SRP_ATTR_ACT` before inserting, replace `DELETE FROM table WHERE TRUE;` with `TRUNCATE TABLE table;` for faster execution and reduced metadata overhead.
- **Use CREATE OR REPLACE TABLE AS SELECT for Full Refresh**: Instead of DELETE + INSERT, consider `CREATE OR REPLACE TABLE TBL_WSS_SRP_ATTR_ACT AS SELECT ... FROM CV_BASE_MD_SRPACT_S4;` for a more efficient full refresh pattern, eliminating the DELETE step entirely.
- **Optimize WHERE ZWEEK = V_WEEK Filtering**: Ensure the source view `CV_BASE_MD_COMPFL_S4` supports partition pruning on `ZWEEK` if converted to a partitioned table or materialized view, reducing data scanned during the INSERT for `TBL_WSS_SRP_COMPFLAG`.

### **Refactor or Rebuild**
- **Refactor**: The procedure logic is straightforward (DELETE + INSERT with variable-based filtering) and can be directly converted to BigQuery Stored Procedure with minimal refactoring. Apply the query rewrite opportunities (TRUNCATE, CREATE OR REPLACE) to optimize performance.
- **Justification**: The procedure does not contain complex ABAP routines, nested cursors, or intricate control flow logic. The main complexity lies in migrating the scalar function `SFN_PRIOR_FISCAL_WEEK` and the source calculation views, which are external dependencies. Once these are migrated, the procedure itself requires only syntax adjustments and optimization tweaks.

---

## 5. Sensitive and Privacy Data Assessment

| **Field Name** | **Sensitive Classification** | **How to Handle It** |
|----------------|------------------------------|----------------------|
| ADDRESS | Potentially Sensitive (PII - Physical Address) | Apply column-level encryption or masking. Restrict access using BigQuery column-level security. Consider tokenization or hashing if address is not required for analytics. |

---

## 6. API Cost

**API COST:** 0.0000

---

**Notes:**
- The API cost is calculated as $0.0000 because the asset is a stored procedure definition (DDL/metadata) with no query execution or data processing performed during analysis. Actual runtime costs in BigQuery will depend on the data volume processed during DELETE, INSERT, and SELECT operations when the procedure is executed.
- The procedure processes data from two calculation views (`CV_BASE_MD_SRPACT_S4`, `CV_BASE_MD_COMPFL_S4`) and writes to two tables (`TBL_WSS_SRP_ATTR_ACT`, `TBL_WSS_SRP_COMPFLAG`). Runtime costs will be based on bytes scanned from source views and bytes written to target tables.
- The DELETE operations on `TBL_WSS_SRP_ATTR_ACT` and `TBL_WSS_SRP_COMPFLAG` are full table deletes, which in BigQuery are free (metadata operations), but subsequent INSERT operations will incur storage and DML costs based on the number of rows and columns inserted.
- The WHERE clause `WHERE ZWEEK = V_WEEK` in the second INSERT statement filters data, which will benefit from partitioning on `ZWEEK` to reduce bytes scanned and lower query costs.

---