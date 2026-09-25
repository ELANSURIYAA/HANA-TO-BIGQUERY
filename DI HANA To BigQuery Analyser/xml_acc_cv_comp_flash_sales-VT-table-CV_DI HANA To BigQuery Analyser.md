<div style="border:1px solid #d0d7de;border-radius:6px;overflow:hidden;font-family:Arial,sans-serif;width:100%;margin-bottom:15px;">
<div style="background:#1f4e79;color:white;padding:10px;font-size:16px;font-weight:bold;">
CV_COMP_FLASH_SALES Analyze Report
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
<td style="padding:8px;border:1px solid #ddd;">SAP HANA Calculation View for composite flash sales data extraction from retail pharmacy operations with multiple data source unions and aggregations</td>
</tr>
</table>
</div>

**Asset Name**: CV_COMP_FLASH_SALES

## 1. BigQuery Recommendations

**(Best Fit)**
- BigQuery Views with UNION ALL for combining multiple data sources (FS_SALES, RX_SALES, EMP_DISCOUNT, FS_DISCOUNT, COVID_SALES, SCRIPTS)
- BigQuery Materialized Views for the aggregated COMBINE_DATA layer to improve query performance
- BigQuery Scheduled Queries to refresh materialized views and maintain data freshness

**(Alternative)**
- BigQuery Stored Procedures to replicate complex calculated view attributes logic with CASE statements
- BigQuery Table-Valued Functions for reusable projection and join logic
- BigQuery Partitioned Tables on BUSINESSDAYDATE for improved query performance

## 2. Syntax Differences

| SAP HANA Feature | BigQuery Equivalent |
|------------------|-------------------|
| Calculation View Projection Node | BigQuery View with SELECT column projection |
| Calculation View Join Node (Inner Join) | BigQuery View with INNER JOIN |
| Calculation View Union Node | BigQuery View with UNION ALL |
| Calculation View Aggregation Node | BigQuery View with GROUP BY and aggregation functions |
| Calculated View Attributes with IF/IN expressions | BigQuery CASE WHEN statements or IF functions |
| Filter expressions (RECORDQUALIFIER = '5') | BigQuery WHERE clauses |
| Parameter-based filtering (PARAM_NAME = 'FS_RETAIL_TYPE_CODE') | BigQuery WHERE clauses with parameter substitution |
| HANA Column Engine expressions | BigQuery SQL expressions |
| Multiple data source references | BigQuery dataset.table references |

## 3. Manual Adjustments Post Agent Conversion

- Configure BigQuery project and dataset references for all calculation view data sources
- Update IAM permissions for BigQuery service accounts to access source tables
- Replace HANA-specific data types with BigQuery equivalents
- Configure BigQuery Scheduled Queries to replace real-time calculation view refresh
- Update external application connections to point to BigQuery views instead of HANA calculation views
- Reconfigure any downstream reporting tools to consume BigQuery views
- Set up BigQuery table partitioning on BUSINESSDAYDATE for performance optimization
- Configure clustering keys for frequently filtered columns (RETAILSTOREID, MANDT)

## 4. Optimization Techniques

**Partitioning**: Time-unit partitioning on BUSINESSDAYDATE field
**Clustering Keys**: RETAILSTOREID, MANDT for improved query pruning
**Materialized Views**: For COMBINE_DATA aggregation layer to pre-compute results
**Query Pruning**: Leverage partitioning and clustering for efficient data access
**BI Engine**: Enable for frequently accessed aggregated data
**Refactor**: Recommended due to complex multi-layered union and aggregation logic requiring optimization for BigQuery's columnar storage

## 5. Sensitive and Privacy Data Assessment

No sensitive data found

## 6. API Cost

API COST: 0.0832