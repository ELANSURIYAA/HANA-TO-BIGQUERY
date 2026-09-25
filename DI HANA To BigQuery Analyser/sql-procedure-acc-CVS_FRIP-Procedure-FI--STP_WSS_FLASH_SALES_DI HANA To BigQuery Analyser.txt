<div style="border:1px solid #d0d7de;border-radius:6px;overflow:hidden;font-family:Arial,sans-serif;width:100%;margin-bottom:15px;">
<div style="background:#1f4e79;color:white;padding:10px;font-size:16px;font-weight:bold;">
STP_WSS_FLASH_SALES Analyze Report
</div>
<table style="border-collapse:collapse;width:100%;">
<tr>
<td style="padding:8px;border:1px solid #ddd;background:#f5f5f5;width:150px;"><b>Author</b></td>
<td style="padding:8px;border:1px solid #ddd;">Ascendion AAVA</td>
</tr>
<tr>
<td style="padding:8px;border:1px solid #ddd;background:#f5f5f5;"><b>Created On</b></td>
<td style="padding:8px;border:1px solid #ddd;">2026-09-25</td>
</tr>
<tr>
<td style="padding:8px;border:1px solid #ddd;background:#f5f5f5;"><b>Description</b></td>
<td style="padding:8px;border:1px solid #ddd;">SAP HANA SQLScript procedure that takes weekly snapshots of CAR data and loads it into a target table with date-based filtering and placeholder parameters.</td>
</tr>
</table>
</div>

**Asset Name**: STP_WSS_FLASH_SALES

## 1. BigQuery Recommendations

**(Best Fit)**
- **BigQuery Stored Procedure**: The SQLScript procedure contains complex variable declarations, date calculations, DELETE/INSERT operations, and placeholder parameter usage that maps directly to BigQuery Scripting capabilities
- **BigQuery Scheduled Query**: The weekly snapshot pattern (Monday 5am execution) can be implemented using BigQuery's native scheduling with the same date calculation logic
- **BigQuery Partitioned Table**: The target table with date-based filtering (BUSINESSDAYDATE, CAL_WEEK_ENDING_DATE) would benefit from time-unit partitioning for optimal query performance

**(Alternative)**
- **BigQuery Data Transfer Service + Cloud Composer**: For orchestrating the weekly data movement from source calculation view to target table with external scheduling control
- **BigQuery Materialized View**: Could replace the snapshot pattern with automatic refresh, though would lose the specific Monday 5am timing requirement

## 2. Syntax Differences

| SAP BW HANA Construct | BigQuery Equivalent |
|----------------------|-------------------|
| `PROCEDURE "CVS_FRIP"."CVS_FRIP.Procedure.FI::STP_WSS_FLASH_SALES" ()` | `CREATE OR REPLACE PROCEDURE dataset.STP_WSS_FLASH_SALES()` |
| `LANGUAGE SQLSCRIPT` | `BEGIN ... END` (BigQuery Scripting) |
| `DECLARE V_CURRENT_DATE DATE := TO_DATE(CURRENT_DATE);` | `DECLARE V_CURRENT_DATE DATE DEFAULT CURRENT_DATE();` |
| `SELECT WEEKDAY(:V_CURRENT_DATE) INTO V_ADJ FROM DUMMY` | `SET V_ADJ = EXTRACT(DAYOFWEEK FROM V_CURRENT_DATE);` |
| `ADD_DAYS(V_CURRENT_DATE,-8-:V_ADJ)` | `DATE_ADD(V_CURRENT_DATE, INTERVAL -(8+V_ADJ) DAY)` |
| `TO_DECIMAL(REPLACE(TO_CHAR(...),'-',''))` | `CAST(REPLACE(CAST(... AS STRING), '-', '') AS NUMERIC)` |
| `DELETE FROM "CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_FLASH_SALES"` | `DELETE FROM dataset.TBL_WSS_FLASH_SALES WHERE TRUE` |
| `FROM "_SYS_BIC"."CVS_FRIP.Composite.FI/CV_COMP_FIN_FLASH"` | `FROM dataset.CV_COMP_FIN_FLASH` |
| `PLACEHOLDER."$$IP_WEEK_ENDING_TO$$" => :V_WEEK_ENDING_TO_DATE` | Parameter passed as procedure argument or session variable |
| `CURRENT_TIMESTAMP, SESSION_USER` | `CURRENT_TIMESTAMP(), SESSION_USER()` |

## 3. Manual Adjustments Post Agent Conversion

- Configure BigQuery dataset and table references replacing SAP schema notation ("CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_FLASH_SALES")
- Update source calculation view reference from "_SYS_BIC"."CVS_FRIP.Composite.FI/CV_COMP_FIN_FLASH" to BigQuery dataset.table format
- Replace SAP HANA placeholder parameter syntax with BigQuery procedure parameters or session variables
- Configure BigQuery Scheduled Query to run weekly on Monday at 5am replacing SAP Process Chain scheduling
- Update IAM permissions for BigQuery service account to access source and target datasets
- Modify date calculation logic from SAP HANA WEEKDAY function to BigQuery EXTRACT(DAYOFWEEK FROM date) with adjusted numbering (SAP: 0-6, BigQuery: 1-7)
- Replace DUMMY table references with BigQuery equivalent or remove where unnecessary

## 4. Optimization Techniques

- **Partitioning**: Implement time-unit partitioning on target table TBL_WSS_FLASH_SALES using BUSINESSDAYDATE or CAL_WEEK_ENDING_DATE columns
- **Clustering Keys**: Add clustering on RETAILSTOREID and PRCTR for store-level query optimization
- **Query Pruning**: Partition pruning will automatically optimize queries filtering on date columns
- **Materialized Views**: Consider materializing the source calculation view CV_COMP_FIN_FLASH if it's computationally expensive
- **Temporary Tables**: Use temporary tables for intermediate date calculations if procedure becomes complex

**Refactor or Rebuild**: Refactor
- The procedure logic is straightforward with clear date calculations and single INSERT operation
- Complex timestamp logic and business rules are well-documented and can be preserved
- Weekly snapshot pattern aligns well with BigQuery Scheduled Query capabilities

## 5. Sensitive and Privacy Data Assessment

No sensitive data found

## 6. API Cost

API COST: 0.0832