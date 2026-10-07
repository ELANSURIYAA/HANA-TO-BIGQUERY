<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #aaa;padding-bottom:8px;margin-bottom:16px">
  <b>Author:</b> Ascendion AAVA<br/>
  <b>Created On:</b> 2026-10-07<br/>
  <b>Description:</b> Composite Calculation View for Flash Sales Extract from CAR, designed to aggregate, join, and process retail sales, discounts, employee discounts, scripts, and COVID-related sales data from multiple calculation views and parameter sources. The view provides a unified, aggregated output for reporting purposes.
</div>

<!-- 1. OVERVIEW OF PROGRAM -->
<div style="margin-bottom:16px">
  <b>Overview of Program:</b><br/>
  This HANA XML defines a Calculation View named CV_COMP_FLASH_SALES, structured as a cube with reporting-enabled visibility. Its primary purpose is to extract, join, and aggregate flash sales, discounts, employee discounts, scripts, and COVID-related sales data from multiple calculation views and parameter sources. The object performs complex data modeling using projections, joins, unions, and aggregations to produce a consolidated output for reporting.
</div>

<!-- 2. CODE STRUCTURE AND DESIGN -->
<div style="margin-bottom:16px">
  <b>Structure:</b> The Calculation View consists of multiple interconnected nodes, including projections, joins, unions, and aggregations. Data sources reference calculation views for base sales, discounts, employee discounts, scripts, parameters, and COVID sales. Projections filter and map fields, joins merge related data (e.g., retail types, discount types), unions consolidate results, and aggregations summarize key metrics. Calculated fields are defined in projection nodes, and mapping is performed throughout the workflow.
  <br/><b>Key Components:</b> Major components include projection views (NAVIX, FS_SALES, FS_DISCOUNT, RX_SALES, SCRIPTS, NAVIX_2, EMP_DISCOUNT, FS_RETAIL_TYPES, EMP_DISC_TYPES, RX_RETAIL_TYPES, FS_DISC_TYPES, COVID_SALES, RX_RETAIL_TYPES_COVID), join views (Join_1, Join_2, Join_3, Join_4, Join_5, Join_6, MERGED), a union node (Union_1), and an aggregation node (COMBINE_DATA). Calculated fields such as CAL_FS_UNITS, CAL_RX_CNT_GE84_NS, CAL_RX_CNT_GE84_RE, CAL_RX_CNT_NS, CAL_RX_CNT_RE, and CAL_CVD_UNITS are defined with conditional logic and formulas.
  <br/><b>Dependencies & Performance:</b> The view depends on multiple calculation views and parameter sources, with extensive join operations, aggregation functions, and calculated expressions. The design includes nested joins, unions, and aggregations, which may impact performance depending on data volume and join cardinality. No explicit temporary or cached data is identified, and no data manipulation statements are present. The complexity is medium to high due to the depth of node structure and dependencies.
</div>

<!-- 3. DATA FLOW AND PROCESSING LOGIC -->
<div style="overflow-x:auto;background:#f9f9f9;padding:16px;border-radius:8px;border:1px solid #ddd">
<style>
.workflow-grid {
  display: grid;
  grid-template-columns: repeat(7, 220px);
  grid-auto-rows: 80px;
  gap: 16px;
  align-items: center;
}
.workflow-box {
  background: #e3e7f3;
  border-radius: 8px;
  border: 1px solid #b4b9c7;
  text-align: center;
  font-weight: bold;
  padding: 16px;
  font-size: 14px;
  box-shadow: 0 2px 6px #b4b9c733;
}
.workflow-arrow {
  text-align: center;
  font-size: 32px;
  color: #888;
}
</style>
<div class="workflow-grid">
  <div class="workflow-box" style="grid-column:1;grid-row:1">CV_BASE_NAVIX</div>
  <div class="workflow-arrow" style="grid-column:2;grid-row:1">→</div>
  <div class="workflow-box" style="grid-column:3;grid-row:1">NAVIX</div>
  <div class="workflow-arrow" style="grid-column:4;grid-row:1">→</div>
  <div class="workflow-box" style="grid-column:5;grid-row:1">MERGED</div>

  <div class="workflow-box" style="grid-column:1;grid-row:2">CV_BASE_TLOGF</div>
  <div class="workflow-arrow" style="grid-column:2;grid-row:2">→</div>
  <div class="workflow-box" style="grid-column:3;grid-row:2">FS_SALES</div>
  <div class="workflow-arrow" style="grid-column:4;grid-row:2">→</div>
  <div class="workflow-box" style="grid-column:5;grid-row:2">Join_2</div>
  <div class="workflow-arrow" style="grid-column:6;grid-row:2">→</div>
  <div class="workflow-box" style="grid-column:7;grid-row:2">Union_1</div>

  <div class="workflow-box" style="grid-column:1;grid-row:3">FS_DISCOUNT$$$$CV_BASE_TLOGF$$</div>
  <div class="workflow-arrow" style="grid-column:2;grid-row:3">→</div>
  <div class="workflow-box" style="grid-column:3;grid-row:3">FS_DISCOUNT</div>
  <div class="workflow-arrow" style="grid-column:4;grid-row:3">→</div>
  <div class="workflow-box" style="grid-column:5;grid-row:3">Join_5</div>
  <div class="workflow-arrow" style="grid-column:6;grid-row:3">→</div>
  <div class="workflow-box" style="grid-column:7;grid-row:3">Union_1</div>

  <div class="workflow-box" style="grid-column:1;grid-row:4">RX_SALES$$$$CV_BASE_TLOGF$$</div>
  <div class="workflow-arrow" style="grid-column:2;grid-row:4">→</div>
  <div class="workflow-box" style="grid-column:3;grid-row:4">RX_SALES</div>
  <div class="workflow-arrow" style="grid-column:4;grid-row:4">→</div>
  <div class="workflow-box" style="grid-column:5;grid-row:4">Join_4</div>
  <div class="workflow-arrow" style="grid-column:6;grid-row:4">→</div>
  <div class="workflow-box" style="grid-column:7;grid-row:4">Union_1</div>

  <div class="workflow-box" style="grid-column:1;grid-row:5">CV_BASE_TLOGF_X</div>
  <div class="workflow-arrow" style="grid-column:2;grid-row:5">→</div>
  <div class="workflow-box" style="grid-column:3;grid-row:5">SCRIPTS</div>
  <div class="workflow-arrow" style="grid-column:4;grid-row:5">→</div>
  <div class="workflow-box" style="grid-column:5;grid-row:5">Join_1</div>
  <div class="workflow-arrow" style="grid-column:6;grid-row:5">→</div>
  <div class="workflow-box" style="grid-column:7;grid-row:5">SCRIPT_KPIs</div>
  <div class="workflow-arrow" style="grid-column:1;grid-row:6">↓</div>
  <div class="workflow-box" style="grid-column:1;grid-row:7">Union_1</div>

  <div class="workflow-box" style="grid-column:1;grid-row:6">NAVIX_2$$$$CV_BASE_NAVIX$$</div>
  <div class="workflow-arrow" style="grid-column:2;grid-row:6">→</div>
  <div class="workflow-box" style="grid-column:3;grid-row:6">NAVIX_2</div>
  <div class="workflow-arrow" style="grid-column:4;grid-row:6">→</div>
  <div class="workflow-box" style="grid-column:5;grid-row:6">Join_1</div>

  <div class="workflow-box" style="grid-column:1;grid-row:7">CV_BASE_PARAMETERS</div>
  <div class="workflow-arrow" style="grid-column:2;grid-row:7">→</div>
  <div class="workflow-box" style="grid-column:3;grid-row:7">FS_RETAIL_TYPES / EMP_DISC_TYPES / RX_RETAIL_TYPES / FS_DISC_TYPES</div>
  <div class="workflow-arrow" style="grid-column:4;grid-row:7">→</div>
  <div class="workflow-box" style="grid-column:5;grid-row:7">Join_2 / Join_3 / Join_4 / Join_5</div>

  <div class="workflow-box" style="grid-column:1;grid-row:8">EMP_DISCOUNT$$$$CV_BASE_TLOGF$$</div>
  <div class="workflow-arrow" style="grid-column:2;grid-row:8">→</div>
  <div class="workflow-box" style="grid-column:3;grid-row:8">EMP_DISCOUNT</div>
  <div class="workflow-arrow" style="grid-column:4;grid-row:8">→</div>
  <div class="workflow-box" style="grid-column:5;grid-row:8">Join_3</div>
  <div class="workflow-arrow" style="grid-column:6;grid-row:8">→</div>
  <div class="workflow-box" style="grid-column:7;grid-row:8">Union_1</div>

  <div class="workflow-box" style="grid-column:1;grid-row:9">CV_BASE_TLOGF_COVID</div>
  <div class="workflow-arrow" style="grid-column:2;grid-row:9">→</div>
  <div class="workflow-box" style="grid-column:3;grid-row:9">COVID_SALES</div>
  <div class="workflow-arrow" style="grid-column:4;grid-row:9">→</div>
  <div class="workflow-box" style="grid-column:5;grid-row:9">Join_6</div>
  <div class="workflow-arrow" style="grid-column:6;grid-row:9">→</div>
  <div class="workflow-box" style="grid-column:7;grid-row:9">Union_1</div>

  <div class="workflow-box" style="grid-column:1;grid-row:10">RX_RETAIL_TYPES_COVID$$$$CV_BASE_PARAMETERS$$</div>
  <div class="workflow-arrow" style="grid-column:2;grid-row:10">→</div>
  <div class="workflow-box" style="grid-column:3;grid-row:10">RX_RETAIL_TYPES_COVID</div>
  <div class="workflow-arrow" style="grid-column:4;grid-row:10">→</div>
  <div class="workflow-box" style="grid-column:5;grid-row:10">Join_6</div>

  <div class="workflow-arrow" style="grid-column:2;grid-row:11">↓</div>
  <div class="workflow-box" style="grid-column:3;grid-row:11">COMBINE_DATA</div>
  <div class="workflow-arrow" style="grid-column:4;grid-row:11">→</div>
  <div class="workflow-box" style="grid-column:5;grid-row:11">MERGED</div>
</div>
</div>

<!-- 4. DATA MAPPING -->
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse:collapse;width:100%;margin-bottom:16px">
<thead><tr><th>Target Object/Field Name</th><th>Target Column Name</th><th>Source Object/Field Name</th><th>Source Column Name</th><th>Remarks</th></tr></thead>
<tbody>
<tr><td>MERGED</td><td>MANDT</td><td>NAVIX</td><td>MANDT</td><td>Direct mapping</td></tr>
<tr><td>MERGED</td><td>RETAILSTOREID</td><td>NAVIX</td><td>RETAILSTOREID</td><td>Direct mapping</td></tr>
<tr><td>MERGED</td><td>BUSINESSDAYDATE</td><td>NAVIX</td><td>BUSINESSDAYDATE</td><td>Direct mapping</td></tr>
<tr><td>MERGED</td><td>FS_SALESAMOUNT</td><td>COMBINE_DATA</td><td>FS_SALESAMOUNT</td><td>Aggregated (sum)</td></tr>
<tr><td>MERGED</td><td>REDUCTIONAMOUNT</td><td>COMBINE_DATA</td><td>REDUCTIONAMOUNT</td><td>Aggregated (sum)</td></tr>
<tr><td>MERGED</td><td>RX_SALESAMOUNT</td><td>COMBINE_DATA</td><td>RX_SALESAMOUNT</td><td>Aggregated (sum)</td></tr>
<tr><td>MERGED</td><td>ZZ_RX_CNT_NS</td><td>COMBINE_DATA</td><td>ZZ_RX_CNT_NS</td><td>Aggregated (count)</td></tr>
<tr><td>MERGED</td><td>ZZ_RX_CNT_REFILL</td><td>COMBINE_DATA</td><td>ZZ_RX_CNT_REFILL</td><td>Aggregated (count)</td></tr>
<tr><td>MERGED</td><td>ZZ_RX_CNT_GE84_NS</td><td>COMBINE_DATA</td><td>ZZ_RX_CNT_GE84_NS</td><td>Aggregated (count)</td></tr>
<tr><td>MERGED</td><td>ZZ_RX_CNT_GE84_RE</td><td>COMBINE_DATA</td><td>ZZ_RX_CNT_GE84_RE</td><td>Aggregated (count)</td></tr>
<tr><td>MERGED</td><td>ZZ_RX_MCRX_GE84_NS</td><td>COMBINE_DATA</td><td>ZZ_RX_MCRX_GE84_NS</td><td>Aggregated (count)</td></tr>
<tr><td>MERGED</td><td>ZZ_RX_MCRX_GE84_RE</td><td>COMBINE_DATA</td><td>ZZ_RX_MCRX_GE84_RE</td><td>Aggregated (count)</td></tr>
<tr><td>MERGED</td><td>CAL_FS_UNITS</td><td>COMBINE_DATA</td><td>CAL_FS_UNITS</td><td>Aggregated (sum); Conditional formula: IF(IN("ZZ_CUSTTYPE",'F','M','R'),1,IF(IN("ZZ_CUSTTYPE",'X','Y','Z'),-1,0))</td></tr>
<tr><td>MERGED</td><td>EMP_REDUCTIONAMOUNT</td><td>COMBINE_DATA</td><td>EMP_REDUCTIONAMOUNT</td><td>Aggregated (sum)</td></tr>
<tr><td>MERGED</td><td>CAL_RX_CNT_GE84_NS</td><td>COMBINE_DATA</td><td>CAL_RX_CNT_GE84_NS</td><td>Aggregated (sum); Formula: if("ZZ_RX_CNT_GE84_NS" = '',0,int("ZZ_RX_CNT_GE84_NS"))</td></tr>
<tr><td>MERGED</td><td>CAL_RX_CNT_GE84_RE</td><td>COMBINE_DATA</td><td>CAL_RX_CNT_GE84_RE</td><td>Aggregated (sum); Formula: if("ZZ_RX_CNT_GE84_RE"='',0,int("ZZ_RX_CNT_GE84_RE"))</td></tr>
<tr><td>MERGED</td><td>CAL_RX_CNT_NS</td><td>COMBINE_DATA</td><td>CAL_RX_CNT_NS</td><td>Aggregated (sum); Formula: if("ZZ_RX_CNT_NS" = '',0,int("ZZ_RX_CNT_NS"))</td></tr>
<tr><td>MERGED</td><td>CAL_RX_CNT_RE</td><td>COMBINE_DATA</td><td>CAL_RX_CNT_RE</td><td>Aggregated (sum); Formula: if("ZZ_RX_CNT_REFILL"='',0,int("ZZ_RX_CNT_REFILL"))</td></tr>
<tr><td>MERGED</td><td>TRANSCURRENCY</td><td>COMBINE_DATA</td><td>TRANSCURRENCY</td><td>Direct mapping</td></tr>
<tr><td>MERGED</td><td>FS_UPD_TIMESTAMP</td><td>COMBINE_DATA</td><td>FS_UPD_TIMESTAMP</td><td>Aggregated (max)</td></tr>
<tr><td>MERGED</td><td>RX_UPD_TIMESTAMP</td><td>COMBINE_DATA</td><td>RX_UPD_TIMESTAMP</td><td>Aggregated (max)</td></tr>
<tr><td>MERGED</td><td>SCRIPTS_UPD_TIMESTAMP</td><td>COMBINE_DATA</td><td>SCRIPTS_UPD_TIMESTAMP</td><td>Aggregated (max)</td></tr>
<tr><td>MERGED</td><td>ZZ_UPD_TIMESTAMP</td><td>COMBINE_DATA</td><td>ZZ_UPD_TIMESTAMP</td><td>Aggregated (max)</td></tr>
<tr><td>MERGED</td><td>CVD_AMOUNT</td><td>COMBINE_DATA</td><td>CVD_AMOUNT</td><td>Aggregated (sum)</td></tr>
<tr><td>MERGED</td><td>CAL_CVD_UNITS</td><td>COMBINE_DATA</td><td>CAL_CVD_UNITS</td><td>Aggregated (sum); Formula: IF("WORKSTATIONID" = '0000000555',IF(IN("ZZ_CUSTTYPE",'C'),1,IF(IN("ZZ_CUSTTYPE",'W'),-1,0)),0)</td></tr>
</tbody>
</table>

<!-- 5. COMPLEXITY ANALYSIS -->
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse:collapse;width:100%;margin-bottom:16px">
<thead><tr><th>Category</th><th>Measurement</th></tr></thead>
<tbody>
<tr><td>Number of Objects/Nodes</td><td>27 (Projections, Joins, Union, Aggregation, Logical Model)</td></tr>
<tr><td>Sources Used</td><td>13 calculation views and parameter sources</td></tr>
<tr><td>Joins</td><td>7 join nodes (Join_1, Join_2, Join_3, Join_4, Join_5, Join_6, MERGED)</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>Sum, Count, Max aggregation functions in COMBINE_DATA</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>Conditional formulas in calculated fields (IF, CASE, int casting)</td></tr>
<tr><td>Workflow Complexity</td><td>High: Deep node structure with multiple joins, unions, aggregations, and calculated fields</td></tr>
<tr><td>Performance Considerations</td><td>Multiple joins and aggregations; dependency on calculation views; join cardinality and nested processing may impact performance</td></tr>
<tr><td>Data Volume Handling</td><td>Aggregation and union nodes indicate handling of potentially large data sets; no explicit data volume limits</td></tr>
<tr><td>Dependency Complexity</td><td>High: Multiple calculation views and parameter sources referenced</td></tr>
<tr><td>Overall Complexity Score</td><td>High</td></tr>
</tbody>
</table>

<!-- 6. SENSITIVE AND PRIVACY DATA ASSESSMENT -->
No sensitive data found

<!-- 7. KEY OUTPUTS -->
<ul>
  <li>MANDT</li>
  <li>RETAILSTOREID</li>
  <li>BUSINESSDAYDATE</li>
  <li>FS_SALESAMOUNT</li>
  <li>REDUCTIONAMOUNT</li>
  <li>RX_SALESAMOUNT</li>
  <li>ZZ_RX_CNT_NS</li>
  <li>ZZ_RX_CNT_REFILL</li>
  <li>ZZ_RX_CNT_GE84_NS</li>
  <li>ZZ_RX_CNT_GE84_RE</li>
  <li>ZZ_RX_MCRX_GE84_NS</li>
  <li>ZZ_RX_MCRX_GE84_RE</li>
  <li>CAL_FS_UNITS</li>
  <li>EMP_REDUCTIONAMOUNT</li>
  <li>CAL_RX_CNT_GE84_NS</li>
  <li>CAL_RX_CNT_GE84_RE</li>
  <li>CAL_RX_CNT_NS</li>
  <li>CAL_RX_CNT_RE</li>
  <li>TRANSCURRENCY</li>
  <li>FS_UPD_TIMESTAMP</li>
  <li>RX_UPD_TIMESTAMP</li>
  <li>SCRIPTS_UPD_TIMESTAMP</li>
  <li>ZZ_UPD_TIMESTAMP</li>
  <li>CVD_AMOUNT</li>
  <li>CAL_CVD_UNITS</li>
</ul>

<!-- 8. API COST CALCULATIONS -->
API COST : 0.0000 USD
