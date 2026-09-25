<div style="border:1px solid #d0d7de;border-radius:6px;overflow:hidden;font-family:Arial,sans-serif;width:100%;margin-bottom:15px;">
<div style="background:#1f4e79;color:white;padding:10px;font-size:16px;font-weight:bold;">
CV_BASE_PARAMETERS Analyze Report
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
<td style="padding:8px;border:1px solid #ddd;">SAP HANA Calculation View with Projection node for parameter management converted to BigQuery View implementation.</td>
</tr>
</table>
</div>

**Asset Name:** CV_BASE_PARAMETERS

## 1. BigQuery Recommendations

**(Best Fit)**
- **BigQuery View**: The Calculation View contains only a Projection node with simple column mapping and renaming, making it ideal for a BigQuery View implementation
- **Column Selection and Renaming**: The view performs straightforward column projection (PARAM_VALUE_LOW → LOW_CHAR, PARAM_VALUE_HIGH → HIGH_CHAR) which maps directly to BigQuery SELECT with column aliases
- **Dimension Category**: The dataCategory="DIMENSION" indicates this is a lookup/reference table suitable for BigQuery View consumption patterns

**(Alternative)**
- **BigQuery Table-Valued Function (TVF)**: Could encapsulate the column mapping logic in a reusable function
- **BigQuery Materialized View**: For performance optimization if the underlying table ZTFIRP_FLASH_PRM is large and frequently accessed

## 2. Syntax Differences

| SAP BW HANA Construct | BigQuery Equivalent | Description |
|----------------------|-------------------|-------------|
| Calculation View Projection Node | BigQuery View with SELECT | Column projection and renaming |
| AttributeMapping (PARAM_VALUE_LOW → LOW_CHAR) | Column Alias (PARAM_VALUE_LOW AS LOW_CHAR) | Column renaming in SELECT statement |
| AttributeMapping (PARAM_VALUE_HIGH → HIGH_CHAR) | Column Alias (PARAM_VALUE_HIGH AS HIGH_CHAR) | Column renaming in SELECT statement |
| DATA_BASE_TABLE DataSource | BigQuery Table Reference | Source table reference |
| viewAttributes allViewAttributes="true" | SELECT * or explicit column list | Column selection pattern |

## 3. Manual Adjustments Post Agent Conversion

- Update BigQuery project and dataset references for table ZTFIRP_FLASH_PRM
- Configure BigQuery service account permissions for accessing the source table
- Update IAM roles to grant appropriate access to the BigQuery View
- Modify any consuming applications to reference the new BigQuery View instead of the HANA Calculation View
- Update dataset location and region settings in BigQuery configuration

## 4. Optimization Techniques

**Refactor**

- **Clustering Keys**: Apply clustering on PARAM_NAME column for parameter lookup optimization
- **Query Pruning**: Implement WHERE clause filters on MANDT (client) field for multi-tenant scenarios
- **Materialized Views**: Consider materialized view if ZTFIRP_FLASH_PRM table is frequently updated but parameters are accessed often
- **BI Engine**: Enable BI Engine acceleration for frequent parameter lookups in reporting scenarios

## 5. Sensitive and Privacy Data Assessment

No sensitive data found

## 6. API Cost

**API COST:** 0.0425