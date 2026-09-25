<div style="border:1px solid #d0d7de;border-radius:6px;overflow:hidden;font-family:Arial,sans-serif;width:100%;margin-bottom:15px;">
<div style="background:#1f4e79;color:white;padding:10px;font-size:16px;font-weight:bold;">
CV_COMP_FIN_FLASH_COMBINED_STATIC Analyze Report
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
<td style="padding:8px;border:1px solid #ddd;">Complex SAP HANA Calculation View combining financial flash reporting data with budget, forecast, and actual data through multiple union operations, aggregations, and calculated fields for weekly retail analytics.</td>
</tr>
</table>
</div>

**Asset Name**: CV_COMP_FIN_FLASH_COMBINED_STATIC

## 1. BigQuery Recommendations

**(Best Fit)**
- **BigQuery Materialized Views**: The complex calculation view with multiple projection, union, aggregation, and join nodes can be efficiently implemented as materialized views to pre-compute the heavy aggregations and calculated fields
- **BigQuery Scheduled Queries**: The weekly flash reporting pattern with variable mappings (IP_WEEK_ENDING_FROM, IP_WEEK_ENDING_TO) can be automated using scheduled queries to refresh data periodically
- **BigQuery Table-Valued Functions (TVF)**: The complex calculated view attributes and variance calculations can be encapsulated in TVFs for reusability across different reporting scenarios

**(Alternative)**
- **BigQuery Views with Partitioned Tables**: Convert the underlying calculation views to partitioned tables based on _BIC_ZIO_SWEEK (week) and create views for the complex logic
- **BigQuery Stored Procedures**: The variable derivation rules and complex calculated attributes can be implemented as stored procedures with parameter handling

## 2. Syntax Differences

| SAP BW HANA Construct | BigQuery Equivalent | Notes |
|----------------------|-------------------|--------|
| Calculation View Projection Node | BigQuery View with SELECT | Column selection and filtering |
| Calculation View Union Node | BigQuery View with UNION ALL | Combining multiple data sources |
| Calculation View Aggregation Node | BigQuery View with GROUP BY | Aggregation with SUM, MAX functions |
| Calculation View Join Node | BigQuery View with LEFT OUTER JOIN | Table joins with join conditions |
| Variable Mapping | BigQuery Stored Procedure Parameters | Parameter passing between procedures |
| Calculated View Attributes | BigQuery Calculated Fields | CASE, IF, arithmetic expressions |
| Filter Expressions | BigQuery WHERE Clause | Row-level filtering |
| keepFlag attribute | BigQuery GROUP BY columns | Grouping dimension control |
| transparentFilter | BigQuery WHERE optimization | Query pruning |
| Scalar Function derivationRule | BigQuery User-Defined Functions | Custom function calls |

## 3. Manual Adjustments Post Agent Conversion

- Configure BigQuery dataset and table references for all 9 source calculation views
- Update variable parameter handling to use BigQuery stored procedure parameters instead of SAP variable mappings
- Replace SAP date formatting functions with BigQuery DATE and FORMAT functions
- Configure BigQuery partitioning on _BIC_ZIO_SWEEK field for performance optimization
- Update currency field handling from SAP currency semantics to BigQuery NUMERIC types
- Reconfigure filter expressions from SAP filter syntax to BigQuery WHERE clauses
- Set up BigQuery IAM permissions for accessing the materialized views and underlying tables
- Configure BigQuery scheduled query timing to match the weekly flash reporting cycle
- Update client applications to connect to BigQuery views instead of SAP HANA calculation views

## 4. Optimization Techniques

**Partitioning**: Time-unit partitioning on _BIC_ZIO_SWEEK (week field) for efficient weekly data access
**Clustering Keys**: PRCTR (profit center), DIVISION_CODE, REGION_CODE for optimal query performance
**Materialized Views**: Pre-compute the complex aggregations and calculated fields in the final projection
**Query Pruning**: Leverage CAL_DATA_CATEGORY1 and CAL_DATA_CATEGORY2 for partition elimination
**BI Engine**: Enable for frequently accessed calculated measures and variance calculations

**Refactor**: The complex calculation view with 20+ calculation nodes, multiple unions, and extensive calculated attributes should be refactored into simpler, more maintainable BigQuery components with clear data lineage.

## 5. Sensitive and Privacy Data Assessment

No sensitive data found

## 6. API Cost

API COST: 0.0832