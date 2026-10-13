<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:10px;margin-bottom:20px;">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> 2026-10-12<br>
  <b>Description:</b> Composite Calculation View for Weekly Static Financial Budget, designed to aggregate, join, and enrich financial budget data across multiple sources using star-schema modeling, with parameter-driven filtering and calculated attributes. All information is strictly based on the provided HANA XML.
</div>

<!-- 1. Overview of Program -->
<p>
This object is a Calculation View defined in HANA XML. Its primary purpose is to model a composite, weekly static financial budget dataset by integrating multiple data sources using projections, joins, and calculated fields. The view applies parameter-driven filtering, star-schema joins, and enriches output with calculated flags and week numbers.
</p>

<!-- 2. Code Structure and Design -->
<p>
<b>Structure:</b> The Calculation View is structured as a tree-based, cube-type model with multiple processing nodes including projections, joins, and calculated fields. It defines local variables for parameterization, references six source Calculation Views, and constructs a star-schema join pattern. The workflow includes sequential projections (e.g., WEEKLY_SNAPSHOT_DS05, HIER_NODE), multi-stage joins (Join_1 to Join_5), calculated fields (such as CAL_FS_RX_FLAG, CAL_COMP_FLAG, CAL_WEEK_NUMBER, and amount transformations), and logical output mapping. <b>Key Components:</b> Major components include localVariables (IP_VERSION, IP_WEEK_ENDING_FROM, IP_WEEK_ENDING_TO), variableMappings, six dataSources, fourteen calculationViews (projections and joins), calculatedViewAttributes, logicalModel attributes/measures, and mapped outputs. <b>Dependencies & Performance:</b> The object depends on multiple referenced Calculation Views for both fact and dimension tables, uses parameter-driven filters and joins, calculated expressions, and star-schema modeling. Performance-relevant aspects include multiple leftOuter and inner joins, calculated fields, and the use of variable mappings and filter expressions; no explicit caching or materialization is indicated in the XML.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow:auto;max-width:100%;background:#fafcff;border:1px solid #dbeafe;padding:16px;margin:24px 0;border-radius:8px;">
<style>
.hana-workflow-grid { display: grid; grid-template-columns: repeat(6, 180px); grid-auto-rows: 80px; gap: 24px; align-items: center; justify-items: center; }
.hana-box { background: #f0f9ff; border: 1px solid #a0aec0; border-radius: 8px; padding: 12px 14px; font-weight: bold; text-align: center; box-shadow: 0 2px 8px #e0e7ef33; }
.hana-arrow { font-size:32px;color:#64748b; }
</style>
<div class="hana-workflow-grid">
  <div class="hana-box" style="grid-column:1;grid-row:1;">CV_BASE_FIN_WEEKLY_BUDGET_S4</div>
  <div class="hana-box" style="grid-column:2;grid-row:1;">CV_BASE_MD_HRRP_NODE_S4</div>
  <div class="hana-box" style="grid-column:3;grid-row:1;">CV_COMP_MD_SRPACT_STATIC</div>
  <div class="hana-box" style="grid-column:4;grid-row:1;">CV_COMP_MD_COMPFL_STATIC</div>
  <div class="hana-box" style="grid-column:5;grid-row:1;">CV_BASE_MD_RCALWEEK_S4</div>
  <div class="hana-box" style="grid-column:6;grid-row:1;">CV_BASE_MD_CEPCT_S4</div>

  <div class="hana-arrow" style="grid-column:1;grid-row:2;">&#8595;</div>
  <div class="hana-arrow" style="grid-column:2;grid-row:2;">&#8595;</div>
  <div class="hana-arrow" style="grid-column:3;grid-row:2;">&#8595;</div>
  <div class="hana-arrow" style="grid-column:4;grid-row:2;">&#8595;</div>
  <div class="hana-arrow" style="grid-column:5;grid-row:2;">&#8595;</div>
  <div class="hana-arrow" style="grid-column:6;grid-row:2;">&#8595;</div>

  <div class="hana-box" style="grid-column:1;grid-row:3;">WEEKLY_SNAPSHOT_DS05</div>
  <div class="hana-box" style="grid-column:2;grid-row:3;">HIER_NODE</div>
  <div class="hana-box" style="grid-column:3;grid-row:3;">STORE_ATTR_ACTUAL</div>
  <div class="hana-box" style="grid-column:4;grid-row:3;">COMP_FLAG_BUDGET</div>
  <div class="hana-box" style="grid-column:5;grid-row:3;">CAL_WEEK</div>
  <div class="hana-box" style="grid-column:6;grid-row:3;">PROFIT_CENTER_TEXT</div>

  <div class="hana-arrow" style="grid-column:1;grid-row:4;">&#8595;</div>
  <div class="hana-arrow" style="grid-column:2;grid-row:4;">&#8595;</div>
  <div class="hana-arrow" style="grid-column:3;grid-row:4;">&#8595;</div>
  <div class="hana-arrow" style="grid-column:4;grid-row:4;">&#8595;</div>
  <div class="hana-arrow" style="grid-column:5;grid-row:4;">&#8595;</div>
  <div class="hana-arrow" style="grid-column:6;grid-row:4;">&#8595;</div>

  <div class="hana-box" style="grid-column:1;grid-row:5;">Join_1</div>
  <div class="hana-box" style="grid-column:1;grid-row:6;">ONLY_CORE_RET_DATA</div>
  <div class="hana-box" style="grid-column:2;grid-row:5;">Join_2</div>
  <div class="hana-box" style="grid-column:2;grid-row:6;">WEEK_NUMBER</div>
  <div class="hana-box" style="grid-column:3;grid-row:5;">Join_3</div>
  <div class="hana-box" style="grid-column:3;grid-row:6;">Join_4</div>
  <div class="hana-box" style="grid-column:4;grid-row:5;">Join_5</div>
  <div class="hana-box" style="grid-column:4;grid-row:6;">FLAGS (Output)</div>

  <div class="hana-arrow" style="grid-column:1;grid-row:7;">&#8594;</div>
  <div class="hana-arrow" style="grid-column:2;grid-row:7;">&#8594;</div>
  <div class="hana-arrow" style="grid-column:3;grid-row:7;">&#8594;</div>
  <div class="hana-arrow" style="grid-column:4;grid-row:7;">&#8594;</div>
</div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;background:#f9fafb;">
<thead style="background:#e0e7ef;">
<tr>
<th>Target Object/Field Name</th>
<th>Target Column Name</th>
<th>Source Object/Field Name</th>
<th>Source Column Name</th>
<th>Remarks</th>
</tr>
</thead>
<tbody>
<tr><td>FLAGS</td><td>MANDT</td><td>Join_5</td><td>MANDT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FISCPER</td><td>Join_5</td><td>FISCPER</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FISCVARNT</td><td>Join_5</td><td>FISCVARNT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FISCYEAR</td><td>Join_5</td><td>FISCYEAR</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FISCPER3</td><td>Join_5</td><td>FISCPER3</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_SWEEK</td><td>Join_5</td><td>_BIC_ZIO_SWEEK</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_B631_S_CHRTACCT</td><td>Join_5</td><td>_B631_S_CHRTACCT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_B631_S_CO_AREA</td><td>Join_5</td><td>_B631_S_CO_AREA</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_CMPCD</td><td>Join_5</td><td>_BIC_ZIO_CMPCD</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_B631_S_PROFTCTR</td><td>Join_5</td><td>_B631_S_PROFTCTR</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FS_RX_FLAG</td><td>FLAGS</td><td>CAL_FS_RX_FLAG</td><td>Calculated: CASE(LEFTSTR("_BIC_ZWWPC_PA1",2),'FS','FS','RX','RX','')</td></tr>
<tr><td>FLAGS</td><td>_B631_S_COSTCNTR</td><td>Join_5</td><td>_B631_S_COSTCNTR</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_B631_S_FUNCAREA</td><td>Join_5</td><td>_B631_S_FUNCAREA</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_VER</td><td>Join_5</td><td>_BIC_ZIO_VER</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_SAUDT</td><td>Join_5</td><td>_BIC_ZIO_SAUDT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_B631_S_GL_ACCT</td><td>Join_5</td><td>_B631_S_GL_ACCT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZWWPC_PA1</td><td>Join_5</td><td>_BIC_ZWWPC_PA1</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZWWSC_PA1</td><td>Join_5</td><td>_BIC_ZWWSC_PA1</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>CURRENCY</td><td>Join_5</td><td>CURRENCY</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>REP_MKT_CODE</td><td>Join_5</td><td>REP_MKT_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>REP_MKT_DESC</td><td>Join_5</td><td>REP_MKT_DESC</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>EMERG_MKT_IND</td><td>Join_5</td><td>EMERG_MKT_IND</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FS_COMP_WK</td><td>Join_5</td><td>FS_COMP_WK</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RX_COMP_WK</td><td>Join_5</td><td>RX_COMP_WK</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>COMP_FLAG</td><td>FLAGS</td><td>CAL_COMP_FLAG</td><td>Calculated: if(isnull(CASE("CAL_FS_RX_FLAG",'FS',"FS_COMP_WK",'RX',"RX_COMP_WK","FS_COMP_WK")), '0', CASE("CAL_FS_RX_FLAG",'FS',"FS_COMP_WK",'RX',"RX_COMP_WK","FS_COMP_WK"))</td></tr>
<tr><td>FLAGS</td><td>DIVISION_CODE</td><td>Join_5</td><td>DIVISION_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>DIVISION_DESC</td><td>Join_5</td><td>DIVISION_DESC</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>AREA_CODE</td><td>Join_5</td><td>AREA_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>AREA_DESC</td><td>Join_5</td><td>AREA_DESC</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>DISTRICT_CODE</td><td>Join_5</td><td>DISTRICT_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>DISTRICT_DESC</td><td>Join_5</td><td>DISTRICT_DESC</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>STRNUM</td><td>Join_5</td><td>STRNUM</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>REGION_CODE</td><td>Join_5</td><td>REGION_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>REGION_DESC</td><td>Join_5</td><td>REGION_DESC</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>ZRWSTRTDATE</td><td>Join_5</td><td>ZRWSTRTDATE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>ZRWENDDATE</td><td>Join_5</td><td>ZRWENDDATE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>CAL_WEEK_NUMBER</td><td>FLAGS</td><td>CAL_WEEK_NUMBER</td><td>Calculated: RIGHTSTR("_BIC_ZIO_SWEEK",2)</td></tr>
<tr><td>FLAGS</td><td>CITY</td><td>Join_5</td><td>CITY</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>STATE</td><td>Join_5</td><td>STATE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>PROFIT_CENTER_TEXT</td><td>Join_5</td><td>PROFIT_CENTER_TEXT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FS_OPEN_DAT</td><td>Join_5</td><td>FS_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RX_OPEN_DAT</td><td>Join_5</td><td>RX_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FIN_BUD_CUBE</td><td>Join_5</td><td>FLAG</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RX_DIVISION_CODE</td><td>Join_5</td><td>RX_DIVISION_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RX_AREA_CODE</td><td>Join_5</td><td>RX_AREA_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RX_REGION_CODE</td><td>Join_5</td><td>RX_REGION_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RX_DISTRICT_CODE</td><td>Join_5</td><td>RX_DISTRICT_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_B631_S_AMOUNT_NEGATIVE</td><td>Join_5</td><td>_B631_S_AMOUNT_NEGATIVE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_B631_S_AMOUNT</td><td>FLAGS</td><td>_B631_S_AMOUNT</td><td>Calculated: "_B631_S_AMOUNT_NEGATIVE"*-1</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_AMT</td><td>Join_5</td><td>_BIC_ZIO_AMT</td><td>Direct mapping</td></tr>
</tbody>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;background:#f9fafb;">
<thead style="background:#e0e7ef;">
<tr><th>Category</th><th>Measurement</th></tr>
</thead>
<tbody>
<tr><td>Number of Objects/Nodes</td><td>14 calculationViews (nodes), 6 dataSources</td></tr>
<tr><td>Sources Used</td><td>CV_BASE_FIN_WEEKLY_BUDGET_S4, CV_BASE_MD_HRRP_NODE_S4, CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC, CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_CEPCT_S4</td></tr>
<tr><td>Joins</td><td>5 join nodes (Join_1 to Join_5)</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>AggregationType="sum" for measures _B631_S_AMOUNT_NEGATIVE, _BIC_ZIO_AMT, _B631_S_AMOUNT</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>CASE expressions in calculated fields (CAL_FS_RX_FLAG, CAL_COMP_FLAG), IF/ISNULL logic</td></tr>
<tr><td>Workflow Complexity</td><td>High: Multi-stage projections, sequential joins, calculated fields, star-schema modeling</td></tr>
<tr><td>Performance Considerations</td><td>Multiple joins (inner, leftOuter), calculated fields, parameter-driven filtering, star-schema pattern</td></tr>
<tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
<tr><td>Dependency Complexity</td><td>High: Multiple referenced Calculation Views, parameter mappings, chained joins</td></tr>
<tr><td>Overall Complexity Score</td><td>High</td></tr>
</tbody>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>MANDT</li>
  <li>FISCPER</li>
  <li>FISCVARNT</li>
  <li>FISCYEAR</li>
  <li>FISCPER3</li>
  <li>_BIC_ZIO_SWEEK</li>
  <li>_B631_S_CHRTACCT</li>
  <li>_B631_S_CO_AREA</li>
  <li>_BIC_ZIO_CMPCD</li>
  <li>_B631_S_PROFTCTR</li>
  <li>FS_RX_FLAG</li>
  <li>_B631_S_COSTCNTR</li>
  <li>_B631_S_FUNCAREA</li>
  <li>_BIC_ZIO_VER</li>
  <li>_BIC_ZIO_SAUDT</li>
  <li>_B631_S_GL_ACCT</li>
  <li>_BIC_ZWWPC_PA1</li>
  <li>_BIC_ZWWSC_PA1</li>
  <li>CURRENCY</li>
  <li>REP_MKT_CODE</li>
  <li>REP_MKT_DESC</li>
  <li>EMERG_MKT_IND</li>
  <li>FS_COMP_WK</li>
  <li>RX_COMP_WK</li>
  <li>COMP_FLAG</li>
  <li>DIVISION_CODE</li>
  <li>DIVISION_DESC</li>
  <li>AREA_CODE</li>
  <li>AREA_DESC</li>
  <li>DISTRICT_CODE</li>
  <li>DISTRICT_DESC</li>
  <li>STRNUM</li>
  <li>REGION_CODE</li>
  <li>REGION_DESC</li>
  <li>ZRWSTRTDATE</li>
  <li>ZRWENDDATE</li>
  <li>CAL_WEEK_NUMBER</li>
  <li>CITY</li>
  <li>STATE</li>
  <li>PROFIT_CENTER_TEXT</li>
  <li>FS_OPEN_DAT</li>
  <li>RX_OPEN_DAT</li>
  <li>FIN_BUD_CUBE</li>
  <li>RX_DIVISION_CODE</li>
  <li>RX_AREA_CODE</li>
  <li>RX_REGION_CODE</li>
  <li>RX_DISTRICT_CODE</li>
  <li>_B631_S_AMOUNT_NEGATIVE</li>
  <li>_BIC_ZIO_AMT</li>
  <li>_B631_S_AMOUNT</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
