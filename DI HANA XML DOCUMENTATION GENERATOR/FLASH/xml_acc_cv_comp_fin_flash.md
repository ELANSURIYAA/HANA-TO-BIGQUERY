<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:8px;margin-bottom:16px">
<b>Author:</b> Ascendion AAVA<br/>
<b>Created On:</b> {{CURRENT_DATE}}<br/>
<b>Description:</b> Composite Calculation View for Weekly Flash Sales (CAR). This HANA XML object models weekly flash sales, employee discounts, and store attributes, integrating multiple calculation views, projections, joins, aggregations, unions, and calculated fields to provide a unified reporting output.
</div>

<!-- 1. Overview of Program -->
<p>
This object is a Calculation View defined in HANA XML. Its primary purpose is to model and aggregate weekly flash sales and related store attributes, combining multiple sources and calculated fields. The view integrates data from base calculation views, applies filters, joins, unions, and aggregations to produce a composite output for reporting.
</p>

<!-- 2. Code Structure and Design -->
<p>
<b>Structure:</b> The Calculation View is structured as a tree-based scenario with multiple nodes including projections, joins, aggregations, and unions. Data sources are referenced via calculation views, and the modeling flow includes local variables, variable mappings, calculated fields, filters, and multi-stage joins. The logical model defines output attributes and measures, while the layout section provides node relationships.<br/>
<b>Key Components:</b> Major components include nodes such as FLASH, RETAIL_CALENDAR, WEEK, COMP_FLAG, HIERARCHY, STORE_ATTR, Join_6, Join_3, COMP_FLG, CALCULATIONS, EMPLOYEE_DISCOUNT, COMP_NONCOMP_STORE_ATTR, Join_4, Union_1, PROFIT_CENTER_TEXT, and Join_5. Each node performs specific processing such as projections, joins, aggregations, calculated fields, or union operations. Local variables and parameter mappings enable dynamic filtering and input control.<br/>
<b>Dependencies & Performance:</b> The object depends on multiple referenced calculation views and scalar functions for variable derivation. Performance-relevant characteristics include complex join structures (outer and inner joins), aggregation operations, calculated expressions, and filters. The presence of nested joins and unions, as well as calculated fields, indicates moderate-to-high processing complexity.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow:auto;max-width:1000px;background:#f9f9f9;padding:18px;border-radius:10px;">
<style>
.grid-wf { display:grid; grid-template-columns:repeat(5,210px); grid-template-rows:repeat(11,70px); gap:24px; }
.grid-box { background:#fff; border:1px solid #c4c4c4; border-radius:8px; box-shadow:0 2px 6px #e0e0e0; display:flex; align-items:center; justify-content:center; font-weight:600; font-size:15px; height:60px; }
.arrow { position:relative; width:100%; height:12px; }
.arrow:after { content:''; display:block; width:0; height:0; border-top:8px solid transparent; border-bottom:8px solid transparent; border-left:12px solid #aaa; position:absolute; left:50%; top:-8px; }
</style>
<div class="grid-wf">
  <div class="grid-box" style="grid-column:1;grid-row:1">CV_BASE_FIN_FLASH_SALES_CAR</div>
  <div class="arrow" style="grid-column:1;grid-row:2"></div>
  <div class="grid-box" style="grid-column:1;grid-row:3">FLASH</div>
  <div class="arrow" style="grid-column:2;grid-row:2"></div>
  <div class="grid-box" style="grid-column:2;grid-row:1">CV_BASE_MD_RCALWEEK_S4</div>
  <div class="arrow" style="grid-column:2;grid-row:2"></div>
  <div class="grid-box" style="grid-column:2;grid-row:3">RETAIL_CALENDAR</div>
  <div class="arrow" style="grid-column:2;grid-row:4"></div>
  <div class="grid-box" style="grid-column:2;grid-row:5">WEEK (Join: FLASH & RETAIL_CALENDAR)</div>
  <div class="arrow" style="grid-column:3;grid-row:4"></div>
  <div class="grid-box" style="grid-column:3;grid-row:1">CV_BASE_MD_COMPFL_S4</div>
  <div class="arrow" style="grid-column:3;grid-row:2"></div>
  <div class="grid-box" style="grid-column:3;grid-row:3">COMP_FLAG</div>
  <div class="arrow" style="grid-column:3;grid-row:4"></div>
  <div class="grid-box" style="grid-column:3;grid-row:5">COMP_FLG (Join: Join_3 & COMP_FLAG)</div>
  <div class="arrow" style="grid-column:4;grid-row:4"></div>
  <div class="grid-box" style="grid-column:4;grid-row:1">CV_BASE_MD_HRRP_NODE_S4</div>
  <div class="arrow" style="grid-column:4;grid-row:2"></div>
  <div class="grid-box" style="grid-column:4;grid-row:3">HIERARCHY</div>
  <div class="arrow" style="grid-column:4;grid-row:4"></div>
  <div class="grid-box" style="grid-column:4;grid-row:5">Join_3 (Join: Join_6 & HIERARCHY)</div>
  <div class="arrow" style="grid-column:5;grid-row:4"></div>
  <div class="grid-box" style="grid-column:5;grid-row:1">CV_BASE_MD_SRPACT_S4</div>
  <div class="arrow" style="grid-column:5;grid-row:2"></div>
  <div class="grid-box" style="grid-column:5;grid-row:3">STORE_ATTR</div>
  <div class="arrow" style="grid-column:5;grid-row:4"></div>
  <div class="grid-box" style="grid-column:5;grid-row:5">Join_6 (Join: WEEK & STORE_ATTR)</div>
  <div class="arrow" style="grid-column:3;grid-row:6"></div>
  <div class="grid-box" style="grid-column:3;grid-row:7">CALCULATIONS</div>
  <div class="arrow" style="grid-column:2;grid-row:6"></div>
  <div class="grid-box" style="grid-column:2;grid-row:7">EMPLOYEE_DISCOUNT</div>
  <div class="arrow" style="grid-column:1;grid-row:6"></div>
  <div class="grid-box" style="grid-column:1;grid-row:7">COMP_NONCOMP_STORE_ATTR</div>
  <div class="arrow" style="grid-column:2;grid-row:8"></div>
  <div class="grid-box" style="grid-column:2;grid-row:9">Join_4 (Join: EMPLOYEE_DISCOUNT & COMP_NONCOMP_STORE_ATTR)</div>
  <div class="arrow" style="grid-column:3;grid-row:8"></div>
  <div class="grid-box" style="grid-column:3;grid-row:9">Union_1 (Union: CALCULATIONS & Join_4)</div>
  <div class="arrow" style="grid-column:4;grid-row:8"></div>
  <div class="grid-box" style="grid-column:4;grid-row:9">CV_BASE_MD_CEPCT_S4</div>
  <div class="arrow" style="grid-column:4;grid-row:10"></div>
  <div class="grid-box" style="grid-column:4;grid-row:11">PROFIT_CENTER_TEXT</div>
  <div class="arrow" style="grid-column:3;grid-row:10"></div>
  <div class="grid-box" style="grid-column:3;grid-row:11">Join_5 (Join: Union_1 & PROFIT_CENTER_TEXT)</div>
</div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%">
<thead><tr>
<th>Target Object/Field Name</th>
<th>Target Column Name</th>
<th>Source Object/Field Name</th>
<th>Source Column Name</th>
<th>Remarks</th>
</tr></thead>
<tbody>
<tr><td>FLASH</td><td>CAL_WEEK_ENDING_DATE</td><td>FLASH</td><td>CAL_WEEK_ENDING_DATE</td><td>Calculated: REPLACE(TO_CHAR(add_days(TO_DATE("BUSINESSDAYDATE"),5-replace(weekday(TO_DATE("BUSINESSDAYDATE")),6,-1))),'-','')</td></tr>
<tr><td>COMP_FLAG</td><td>COMP_VER</td><td>COMP_FLAG</td><td>COMP_VER</td><td>Filter: COMP_VER = '$$IP_VERSION$$'</td></tr>
<tr><td>FLASH</td><td>BUSINESSDAYDATE</td><td>FLASH</td><td>BUSINESSDAYDATE</td><td>Filter: BUSINESSDAYDATE >= '$$IP_WEEK_ENDING_FROM$$' AND BUSINESSDAYDATE <= '$$IP_WEEK_ENDING_TO$$'</td></tr>
<tr><td>FLASH</td><td>RETAILSTOREID_CAR</td><td>FLASH</td><td>RETAILSTOREID_CAR</td><td>Filter: RETAILSTOREID_CAR &lt; '0000020000' or RETAILSTOREID_CAR > '0000024999'</td></tr>
<tr><td>CALCULATIONS</td><td>CAL_SCRIPTS_90AS3</td><td>CALCULATIONS</td><td>CAL_SCRIPTS_90AS3</td><td>Calculated: "CAL_RX_CNT_NS"+"CAL_RX_CNT_RE"+("CAL_RX_CNT_GE84_NS"+"CAL_RX_CNT_GE84_RE")*2</td></tr>
<tr><td>CALCULATIONS</td><td>CAL_COMP_FLAG</td><td>CALCULATIONS</td><td>CAL_COMP_FLAG</td><td>Calculated: IF(ISNULL(MAX("FS_COMP_WK","RX_COMP_WK")),'0',MAX("FS_COMP_WK","RX_COMP_WK"))</td></tr>
<tr><td>CALCULATIONS</td><td>CAL_WEEK_NUMBER</td><td>CALCULATIONS</td><td>CAL_WEEK_NUMBER</td><td>Calculated: RIGHTSTR("ZZWEEK",2)</td></tr>
<tr><td>EMPLOYEE_DISCOUNT</td><td>CAL_PRCTR</td><td>EMPLOYEE_DISCOUNT</td><td>CAL_PRCTR</td><td>Calculated: CASE("CAL_COMP_FLAG",'1','0000562075','0','0000562076',string(null))</td></tr>
<tr><td>Join_4</td><td>PRCTR</td><td>EMPLOYEE_DISCOUNT</td><td>CAL_PRCTR</td><td>Join: PRCTR</td></tr>
<tr><td>Join_5</td><td>PROFIT_CENTER_TEXT</td><td>PROFIT_CENTER_TEXT</td><td>PROFIT_CENTER_TEXT</td><td>Join: PRCTR</td></tr>
<tr><td>Union_1</td><td>EMP_REDUCTIONAMOUNT</td><td>Union_1</td><td>EMP_REDUCTIONAMOUNT</td><td>ConstantAttributeMapping: null value</td></tr>
<tr><td>Union_1</td><td>FS_SALESAMOUNT</td><td>Union_1</td><td>FS_SALESAMOUNT</td><td>ConstantAttributeMapping: null value</td></tr>
<tr><td>Union_1</td><td>REDUCTIONAMOUNT</td><td>Union_1</td><td>REDUCTIONAMOUNT</td><td>ConstantAttributeMapping: null value</td></tr>
<tr><td>Union_1</td><td>RX_SALESAMOUNT</td><td>Union_1</td><td>RX_SALESAMOUNT</td><td>ConstantAttributeMapping: null value</td></tr>
<tr><td>Union_1</td><td>CAL_FS_UNITS</td><td>Union_1</td><td>CAL_FS_UNITS</td><td>ConstantAttributeMapping: null value</td></tr>
<tr><td>Union_1</td><td>CAL_RX_CNT_GE84_NS</td><td>Union_1</td><td>CAL_RX_CNT_GE84_NS</td><td>ConstantAttributeMapping: null value</td></tr>
<tr><td>Union_1</td><td>CAL_RX_CNT_GE84_RE</td><td>Union_1</td><td>CAL_RX_CNT_GE84_RE</td><td>ConstantAttributeMapping: null value</td></tr>
<tr><td>Union_1</td><td>CAL_SCRIPTS_90AS3</td><td>Union_1</td><td>CAL_SCRIPTS_90AS3</td><td>ConstantAttributeMapping: null value</td></tr>
<tr><td>Union_1</td><td>CAL_RX_CNT_NS</td><td>Union_1</td><td>CAL_RX_CNT_NS</td><td>ConstantAttributeMapping: null value</td></tr>
<tr><td>Union_1</td><td>CAL_RX_CNT_RE</td><td>Union_1</td><td>CAL_RX_CNT_RE</td><td>ConstantAttributeMapping: null value</td></tr>
<tr><td>Union_1</td><td>CVD_AMOUNT</td><td>Union_1</td><td>CVD_AMOUNT</td><td>ConstantAttributeMapping: null value</td></tr>
<tr><td>Union_1</td><td>CAL_CVD_UNITS</td><td>Union_1</td><td>CAL_CVD_UNITS</td><td>ConstantAttributeMapping: null value</td></tr>
<tr><td>Join_6</td><td>RETAILSTOREID</td><td>STORE_ATTR</td><td>STRNUM</td><td>Join: RETAILSTOREID = STRNUM</td></tr>
<tr><td>Join_3</td><td>JOIN$NODEVALUE$PRCTR</td><td>HIERARCHY</td><td>NODEVALUE</td><td>Join: JOIN$NODEVALUE$PRCTR</td></tr>
<tr><td>Join_3</td><td>JOIN$NODEVALUE$PRCTR</td><td>Join_6</td><td>PRCTR</td><td>Join: JOIN$NODEVALUE$PRCTR</td></tr>
<tr><td>Join_5</td><td>PRCTR</td><td>Union_1</td><td>PRCTR</td><td>Join: PRCTR</td></tr>
<tr><td>Join_5</td><td>PRCTR</td><td>PROFIT_CENTER_TEXT</td><td>PRCTR</td><td>Join: PRCTR</td></tr>
</tbody>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%">
<thead><tr>
<th>Category</th>
<th>Measurement</th>
</tr></thead>
<tbody>
<tr><td>Number of Objects/Nodes</td><td>17 (Calculation View nodes including projections, joins, aggregations, unions)</td></tr>
<tr><td>Sources Used</td><td>7 (CV_BASE_FIN_FLASH_SALES_CAR, CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_COMPFL_S4, CV_BASE_MD_HRRP_NODE_S4, CV_BASE_MD_SRPACT_S4, COMP_NONCOMP_STORE_ATTR$$$$CV_BASE_MD_SRPACT_S4$$, CV_BASE_MD_CEPCT_S4)</td></tr>
<tr><td>Joins</td><td>7 (WEEK, Join_6, Join_3, COMP_FLG, Join_4, Join_5, COMP_NONCOMP_STORE_ATTR)</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>Sum, Max (on measures such as sales amounts, reduction amounts, units, update timestamps)</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>CASE, IF, filters, calculated expressions (e.g., CASE in CAL_PRCTR, IF in CAL_COMP_FLAG)</td></tr>
<tr><td>Workflow Complexity</td><td>High (multi-stage joins, unions, calculated fields, variable mappings, nested processing)</td></tr>
<tr><td>Performance Considerations</td><td>Complex joins, aggregations, calculated fields, multiple referenced views and functions; moderate-to-high performance relevance</td></tr>
<tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
<tr><td>Dependency Complexity</td><td>High (multiple referenced calculation views, scalar functions, variable mappings)</td></tr>
<tr><td>Overall Complexity Score</td><td>High</td></tr>
</tbody>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
<li>MANDT</li>
<li>RETAILSTOREID</li>
<li>PRCTR</li>
<li>BUSINESSDAYDATE</li>
<li>ZZWEEK</li>
<li>ZRYEAR</li>
<li>ZRPERIOD</li>
<li>ZRYRP</li>
<li>CAL_WEEK_ENDING_DATE</li>
<li>FS_COMP_WK</li>
<li>RX_COMP_WK</li>
<li>EMERG_MKT_IND</li>
<li>REP_MKT_CODE</li>
<li>REP_MKT_DESC</li>
<li>CAL_COMP_FLAG</li>
<li>DIVISION_CODE</li>
<li>DIVISION_DESC</li>
<li>REGION_CODE</li>
<li>REGION_DESC</li>
<li>DISTRICT_CODE</li>
<li>DISTRICT_DESC</li>
<li>ZRWENDDATE</li>
<li>ZRWSTRTDATE</li>
<li>CAL_WEEK_NUMBER</li>
<li>CITY</li>
<li>STATE</li>
<li>PROFIT_CENTER_TEXT</li>
<li>FS_OPEN_DAT</li>
<li>RX_OPEN_DAT</li>
<li>FS_SALESAMOUNT</li>
<li>REDUCTIONAMOUNT</li>
<li>RX_SALESAMOUNT</li>
<li>CAL_FS_UNITS</li>
<li>CAL_RX_CNT_GE84_NS</li>
<li>CAL_RX_CNT_GE84_RE</li>
<li>CAL_SCRIPTS_90AS3</li>
<li>CAL_RX_CNT_NS</li>
<li>CAL_RX_CNT_RE</li>
<li>EMP_REDUCTIONAMOUNT</li>
<li>RX_UPD_TIMESTAMP</li>
<li>FS_UPD_TIMESTAMP</li>
<li>SCRIPTS_UPD_TIMESTAMP</li>
<li>ZZ_UPD_TIMESTAMP</li>
<li>TRANSCURRENCY</li>
<li>AREA_CODE</li>
<li>AREA_DESC</li>
<li>CVD_AMOUNT</li>
<li>CAL_CVD_UNITS</li>
<li>RX_DIVISION_CODE</li>
<li>RX_AREA_CODE</li>
<li>RX_REGION_CODE</li>
<li>RX_DISTRICT_CODE</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
