<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse; margin-bottom:20px;">
<tr><td><b>Author:</b></td><td>Ascendion AAVA</td></tr>
<tr><td><b>Created On:</b></td><td>2026-10-07</td></tr>
<tr><td><b>Description:</b></td><td>Technical documentation for Calculation View <b>CV_COMP_FIN_FLASH_STATIC</b>, a wrapper view on snapshot table <b>TBL_WSS_FLASH_SALES</b> for weekly flash reporting, as defined in the provided HANA XML.</td></tr>
</table>

<!-- 1. OVERVIEW OF PROGRAM -->
<p>This HANA XML defines a Calculation View object named <b>CV_COMP_FIN_FLASH_STATIC</b>. The primary purpose of this view is to serve as a wrapper on the snapshot table <b>TBL_WSS_FLASH_SALES</b> for weekly flash reporting. The view projects all fields from the source table and exposes them for aggregation and reporting without additional transformation or calculation logic.</p>

<!-- 2. CODE STRUCTURE AND DESIGN -->
<p><b>Structure:</b> The Calculation View is organized as a tree-based scenario with a single projection node (<b>Projection_1</b>) sourcing data from <b>TBL_WSS_FLASH_SALES</b>. All fields from the source are projected directly, with no calculated fields, filters, joins, unions, or additional modeling nodes present in the XML. <b>Key Components:</b> The major components include the <b>Projection_1</b> node, the referenced data source <b>TBL_WSS_FLASH_SALES</b>, view attributes, and base measures defined for aggregation. The logical model maps source columns to output attributes and measures, specifying aggregation types for measures. <b>Dependencies & Performance:</b> The only dependency is the CDS artifact <b>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</b>. No joins, filters, or calculated expressions are present. Aggregation is performed on several fields using SUM and MAX functions. No complex processing, nested logic, or performance-impacting features are visible beyond basic aggregation.</p>

<!-- 3. DATA FLOW AND PROCESSING LOGIC -->
<div style="overflow-x:auto; background:#f9f9f9; padding:18px; border-radius:8px; border:1px solid #e0e0e0; width:100%;">
<style>
.grid-diagram { display: grid; grid-template-columns: repeat(3, 240px); grid-template-rows: repeat(3, 120px); gap: 36px; justify-content: center; align-items: center; }
.grid-box { background: #ffffff; border: 2px solid #b0b0b0; border-radius: 8px; box-shadow: 0 2px 8px #d0d0d0; text-align: center; font-weight: 600; font-size: 16px; padding: 24px 8px; }
.arrow { font-size: 36px; color: #888888; text-align: center; }
</style>
<div class="grid-diagram">
  <div class="grid-box" style="grid-column:1; grid-row:2;">Data Source<br><b>TBL_WSS_FLASH_SALES</b></div>
  <div class="arrow" style="grid-column:2; grid-row:2;">&#8594;</div>
  <div class="grid-box" style="grid-column:3; grid-row:2;">Projection Node<br><b>Projection_1</b></div>
  <div class="arrow" style="grid-column:3; grid-row:3;">&#8593;</div>
  <div class="grid-box" style="grid-column:3; grid-row:1;">Output<br><b>CV_COMP_FIN_FLASH_STATIC</b></div>
</div>
</div>

<!-- 4. DATA MAPPING -->
<table style="width:100%; border-collapse:collapse; margin-top:20px;">
<thead>
<tr style="background:#e8e8e8;">
<th>Target Object/Field Name</th>
<th>Target Column Name</th>
<th>Source Object/Field Name</th>
<th>Source Column Name</th>
<th>Remarks</th>
</tr>
</thead>
<tbody>
<tr><td>Projection_1.MANDT</td><td>MANDT</td><td>TBL_WSS_FLASH_SALES</td><td>MANDT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RETAILSTOREID</td><td>RETAILSTOREID</td><td>TBL_WSS_FLASH_SALES</td><td>RETAILSTOREID</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.PRCTR</td><td>PRCTR</td><td>TBL_WSS_FLASH_SALES</td><td>PRCTR</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.BUSINESSDAYDATE</td><td>BUSINESSDAYDATE</td><td>TBL_WSS_FLASH_SALES</td><td>BUSINESSDAYDATE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZZWEEK</td><td>ZZWEEK</td><td>TBL_WSS_FLASH_SALES</td><td>ZZWEEK</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZRYEAR</td><td>ZRYEAR</td><td>TBL_WSS_FLASH_SALES</td><td>ZRYEAR</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZRPERIOD</td><td>ZRPERIOD</td><td>TBL_WSS_FLASH_SALES</td><td>ZRPERIOD</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZRYRP</td><td>ZRYRP</td><td>TBL_WSS_FLASH_SALES</td><td>ZRYRP</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.CAL_WEEK_ENDING_DATE</td><td>CAL_WEEK_ENDING_DATE</td><td>TBL_WSS_FLASH_SALES</td><td>CAL_WEEK_ENDING_DATE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.FS_COMP_WK</td><td>FS_COMP_WK</td><td>TBL_WSS_FLASH_SALES</td><td>FS_COMP_WK</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_COMP_WK</td><td>RX_COMP_WK</td><td>TBL_WSS_FLASH_SALES</td><td>RX_COMP_WK</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.EMERG_MKT_IND</td><td>EMERG_MKT_IND</td><td>TBL_WSS_FLASH_SALES</td><td>EMERG_MKT_IND</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.REP_MKT_CODE</td><td>REP_MKT_CODE</td><td>TBL_WSS_FLASH_SALES</td><td>REP_MKT_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.REP_MKT_DESC</td><td>REP_MKT_DESC</td><td>TBL_WSS_FLASH_SALES</td><td>REP_MKT_DESC</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.CAL_COMP_FLAG</td><td>CAL_COMP_FLAG</td><td>TBL_WSS_FLASH_SALES</td><td>CAL_COMP_FLAG</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.DIVISION_CODE</td><td>DIVISION_CODE</td><td>TBL_WSS_FLASH_SALES</td><td>DIVISION_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.DIVISION_DESC</td><td>DIVISION_DESC</td><td>TBL_WSS_FLASH_SALES</td><td>DIVISION_DESC</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.REGION_CODE</td><td>REGION_CODE</td><td>TBL_WSS_FLASH_SALES</td><td>REGION_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.REGION_DESC</td><td>REGION_DESC</td><td>TBL_WSS_FLASH_SALES</td><td>REGION_DESC</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.DISTRICT_CODE</td><td>DISTRICT_CODE</td><td>TBL_WSS_FLASH_SALES</td><td>DISTRICT_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.DISTRICT_DESC</td><td>DISTRICT_DESC</td><td>TBL_WSS_FLASH_SALES</td><td>DISTRICT_DESC</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZRWENDDATE</td><td>ZRWENDDATE</td><td>TBL_WSS_FLASH_SALES</td><td>ZRWENDDATE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZRWSTRTDATE</td><td>ZRWSTRTDATE</td><td>TBL_WSS_FLASH_SALES</td><td>ZRWSTRTDATE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.CAL_WEEK_NUMBER</td><td>CAL_WEEK_NUMBER</td><td>TBL_WSS_FLASH_SALES</td><td>CAL_WEEK_NUMBER</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.CITY</td><td>CITY</td><td>TBL_WSS_FLASH_SALES</td><td>CITY</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.STATE</td><td>STATE</td><td>TBL_WSS_FLASH_SALES</td><td>STATE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.FS_SALESAMOUNT</td><td>FS_SALESAMOUNT</td><td>TBL_WSS_FLASH_SALES</td><td>FS_SALESAMOUNT</td><td>Direct mapping; SUM aggregation</td></tr>
<tr><td>Projection_1.REDUCTIONAMOUNT</td><td>REDUCTIONAMOUNT</td><td>TBL_WSS_FLASH_SALES</td><td>REDUCTIONAMOUNT</td><td>Direct mapping; SUM aggregation</td></tr>
<tr><td>Projection_1.RX_SALESAMOUNT</td><td>RX_SALESAMOUNT</td><td>TBL_WSS_FLASH_SALES</td><td>RX_SALESAMOUNT</td><td>Direct mapping; SUM aggregation</td></tr>
<tr><td>Projection_1.CAL_FS_UNITS</td><td>CAL_FS_UNITS</td><td>TBL_WSS_FLASH_SALES</td><td>CAL_FS_UNITS</td><td>Direct mapping; SUM aggregation</td></tr>
<tr><td>Projection_1.CAL_RX_CNT_GE84_NS</td><td>CAL_RX_CNT_GE84_NS</td><td>TBL_WSS_FLASH_SALES</td><td>CAL_RX_CNT_GE84_NS</td><td>Direct mapping; SUM aggregation</td></tr>
<tr><td>Projection_1.CAL_RX_CNT_GE84_RE</td><td>CAL_RX_CNT_GE84_RE</td><td>TBL_WSS_FLASH_SALES</td><td>CAL_RX_CNT_GE84_RE</td><td>Direct mapping; SUM aggregation</td></tr>
<tr><td>Projection_1.CAL_SCRIPTS_90AS3</td><td>CAL_SCRIPTS_90AS3</td><td>TBL_WSS_FLASH_SALES</td><td>CAL_SCRIPTS_90AS3</td><td>Direct mapping; SUM aggregation</td></tr>
<tr><td>Projection_1.CAL_RX_CNT_NS</td><td>CAL_RX_CNT_NS</td><td>TBL_WSS_FLASH_SALES</td><td>CAL_RX_CNT_NS</td><td>Direct mapping; SUM aggregation</td></tr>
<tr><td>Projection_1.CAL_RX_CNT_RE</td><td>CAL_RX_CNT_RE</td><td>TBL_WSS_FLASH_SALES</td><td>CAL_RX_CNT_RE</td><td>Direct mapping; SUM aggregation</td></tr>
<tr><td>Projection_1.EMP_REDUCTIONAMOUNT</td><td>EMP_REDUCTIONAMOUNT</td><td>TBL_WSS_FLASH_SALES</td><td>EMP_REDUCTIONAMOUNT</td><td>Direct mapping; SUM aggregation</td></tr>
<tr><td>Projection_1.PROFIT_CENTER_TEXT</td><td>PROFIT_CENTER_TEXT</td><td>TBL_WSS_FLASH_SALES</td><td>PROFIT_CENTER_TEXT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.FS_OPEN_DAT</td><td>FS_OPEN_DAT</td><td>TBL_WSS_FLASH_SALES</td><td>FS_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_OPEN_DAT</td><td>RX_OPEN_DAT</td><td>TBL_WSS_FLASH_SALES</td><td>RX_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_UPD_TIMESTAMP</td><td>RX_UPD_TIMESTAMP</td><td>TBL_WSS_FLASH_SALES</td><td>RX_UPD_TIMESTAMP</td><td>Direct mapping; MAX aggregation</td></tr>
<tr><td>Projection_1.FS_UPD_TIMESTAMP</td><td>FS_UPD_TIMESTAMP</td><td>TBL_WSS_FLASH_SALES</td><td>FS_UPD_TIMESTAMP</td><td>Direct mapping; MAX aggregation</td></tr>
<tr><td>Projection_1.SCRIPTS_UPD_TIMESTAMP</td><td>SCRIPTS_UPD_TIMESTAMP</td><td>TBL_WSS_FLASH_SALES</td><td>SCRIPTS_UPD_TIMESTAMP</td><td>Direct mapping; MAX aggregation</td></tr>
<tr><td>Projection_1.ZZ_UPD_TIMESTAMP</td><td>ZZ_UPD_TIMESTAMP</td><td>TBL_WSS_FLASH_SALES</td><td>ZZ_UPD_TIMESTAMP</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.SNAPSHOT_TIMESTAMP</td><td>SNAPSHOT_TIMESTAMP</td><td>TBL_WSS_FLASH_SALES</td><td>SNAPSHOT_TIMESTAMP</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.CREATED_BY</td><td>CREATED_BY</td><td>TBL_WSS_FLASH_SALES</td><td>CREATED_BY</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.TRANSCURRENCY</td><td>TRANSCURRENCY</td><td>TBL_WSS_FLASH_SALES</td><td>TRANSCURRENCY</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.AREA_CODE</td><td>AREA_CODE</td><td>TBL_WSS_FLASH_SALES</td><td>AREA_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.AREA_DESC</td><td>AREA_DESC</td><td>TBL_WSS_FLASH_SALES</td><td>AREA_DESC</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.CVD_AMOUNT</td><td>CVD_AMOUNT</td><td>TBL_WSS_FLASH_SALES</td><td>CVD_AMOUNT</td><td>Direct mapping; SUM aggregation</td></tr>
<tr><td>Projection_1.CAL_CVD_UNITS</td><td>CAL_CVD_UNITS</td><td>TBL_WSS_FLASH_SALES</td><td>CAL_CVD_UNITS</td><td>Direct mapping; SUM aggregation</td></tr>
<tr><td>Projection_1.RX_DIVISION_CODE</td><td>RX_DIVISION_CODE</td><td>TBL_WSS_FLASH_SALES</td><td>RX_DIVISION_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_AREA_CODE</td><td>RX_AREA_CODE</td><td>TBL_WSS_FLASH_SALES</td><td>RX_AREA_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_REGION_CODE</td><td>RX_REGION_CODE</td><td>TBL_WSS_FLASH_SALES</td><td>RX_REGION_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_DISTRICT_CODE</td><td>RX_DISTRICT_CODE</td><td>TBL_WSS_FLASH_SALES</td><td>RX_DISTRICT_CODE</td><td>Direct mapping</td></tr>
</tbody>
</table>

<!-- 5. COMPLEXITY ANALYSIS -->
<table style="width:100%; border-collapse:collapse; margin-top:20px;">
<tr><td>Number of Objects/Nodes</td><td>2 (Calculation View, Projection Node)</td></tr>
<tr><td>Sources Used</td><td>1 (TBL_WSS_FLASH_SALES via CDS artifact CVS_FRIP.Table::TBL_WSS_FLASH_SALES)</td></tr>
<tr><td>Joins</td><td>None identified</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>SUM, MAX (on measures)</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>None identified</td></tr>
<tr><td>Workflow Complexity</td><td>Simple, linear projection from source to output</td></tr>
<tr><td>Performance Considerations</td><td>Basic aggregation; no complex logic or joins present</td></tr>
<tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
<tr><td>Dependency Complexity</td><td>Single source dependency (CDS artifact)</td></tr>
<tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. SENSITIVE AND PRIVACY DATA ASSESSMENT -->
No sensitive data found

<!-- 7. KEY OUTPUTS -->
<ul>
<li>All projected fields from TBL_WSS_FLASH_SALES (as listed in the Data Mapping table)</li>
<li>Aggregated measures (SUM and MAX) as defined in the logical model</li>
<li>Output view exposing weekly flash snapshot data for reporting</li>
</ul>

<!-- 8. API COST CALCULATIONS -->
API COST : 0.0000 USD
