<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;margin-bottom:16px;padding-bottom:8px;">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> 2024-06-13<br>
  <b>Description:</b> Composite Calculation View for Weekly Static SKF Budget, designed to aggregate and join store, profit center, cost center, and retail week data using multiple projections, joins, and calculated fields. The object serves as a reporting-enabled cube, with explicit variable-driven filtering and hierarchical node processing.
</div>

<!-- 1. OVERVIEW OF PROGRAM -->
<p><b>Overview of Program:</b><br>
This HANA XML defines a Calculation View of type CUBE, named <b>CV_COMP_SKF_BUDGET_STATIC</b>. Its primary purpose is to provide a composite view for weekly static SKF budget data, integrating multiple data sources through projections, joins, and calculated attributes. The main processing includes filtering, joining, and calculation logic to produce a unified output for reporting.</p>

<!-- 2. CODE STRUCTURE AND DESIGN -->
<p>
<b>Structure:</b> The Calculation View is structured as a tree-based scenario with a series of projection, join, and aggregation nodes. It utilizes multiple data sources, local variables, variable mappings, and calculated fields. The design includes a logical model specifying output attributes and measures, and a layout representing node relationships.<br>
<b>Key Components:</b> Major components include local variables (<code>IP_VERSION</code>, <code>IP_WEEK_ENDING_FROM</code>, <code>IP_WEEK_ENDING_TO</code>), multiple projection nodes (e.g., <code>WEEKLY_SNAPSHOT_DS05</code>, <code>STORE_ATTR_ACTUAL</code>, <code>COMP_FLAG_BUDGET</code>), join nodes (<code>Join_1</code> to <code>Join_5</code>), calculated attributes and measures, and a logical model (<code>FLAGS</code>) detailing the output structure.<br>
<b>Dependencies & Performance:</b> The view depends on several referenced Calculation Views as data sources, including <code>CV_BASE_SKF_WEEKLY_BUDGET_S4</code>, <code>CV_BASE_MD_HRRP_NODE_S4</code>, <code>CV_COMP_MD_SRPACT_STATIC</code>, <code>CV_COMP_MD_COMPFL_STATIC</code>, <code>CV_BASE_MD_RCALWEEK_S4</code>, and <code>CV_BASE_MD_CEPCT_S4</code>. Performance-relevant aspects include multi-level joins, filter expressions, calculated fields, and aggregation logic, all visible in the XML structure.
</p>

<!-- 3. DATA FLOW AND PROCESSING LOGIC -->
<div style="overflow-x:auto;background:#f9f9f9;padding:16px;border-radius:8px;">
<style>
  .workflow-grid {
    display: grid;
    grid-template-columns: repeat(6, 220px);
    grid-auto-rows: 80px;
    gap: 16px;
    align-items: center;
    justify-items: center;
    font-family: Arial, sans-serif;
  }
  .workflow-box {
    background: #fff;
    border: 1px solid #b6b6b6;
    border-radius: 8px;
    box-shadow: 0 1px 4px rgba(0,0,0,0.07);
    padding: 12px 8px;
    text-align: center;
    font-size: 15px;
    min-width: 180px;
    min-height: 60px;
    position: relative;
  }
  .workflow-arrow {
    position: absolute;
    width: 40px;
    height: 2px;
    background: #6a6a6a;
    left: 100%;
    top: 50%;
    margin-top: -1px;
  }
  .workflow-connector {
    grid-column: span 1;
    height: 2px;
    width: 40px;
    background: #6a6a6a;
    margin-left: -20px;
    margin-right: -20px;
  }
</style>
<div class="workflow-grid">
  <div class="workflow-box" style="grid-column:1;grid-row:1;">CV_BASE_SKF_WEEKLY_BUDGET_S4</div>
  <div class="workflow-box" style="grid-column:2;grid-row:1;">WEEKLY_SNAPSHOT_DS05<br><span style='font-size:12px;color:#888;'>Projection<br>Filters/Variables</span></div>
  <div class="workflow-connector" style="grid-column:1/2;grid-row:1;"></div>
  <div class="workflow-box" style="grid-column:1;grid-row:2;">CV_BASE_MD_HRRP_NODE_S4</div>
  <div class="workflow-box" style="grid-column:2;grid-row:2;">HIER_NODE<br><span style='font-size:12px;color:#888;'>Projection<br>Filter</span></div>
  <div class="workflow-connector" style="grid-column:1/2;grid-row:2;"></div>
  <div class="workflow-box" style="grid-column:3;grid-row:1;">Join_1<br><span style='font-size:12px;color:#888;'>Inner Join</span></div>
  <div class="workflow-connector" style="grid-column:2/3;grid-row:1;"></div>
  <div class="workflow-box" style="grid-column:1;grid-row:3;">CV_COMP_MD_SRPACT_STATIC</div>
  <div class="workflow-box" style="grid-column:2;grid-row:3;">STORE_ATTR_ACTUAL<br><span style='font-size:12px;color:#888;'>Projection</span></div>
  <div class="workflow-connector" style="grid-column:1/2;grid-row:3;"></div>
  <div class="workflow-box" style="grid-column:3;grid-row:2;">Join_2<br><span style='font-size:12px;color:#888;'>Left Outer Join</span></div>
  <div class="workflow-connector" style="grid-column:3/3;grid-row:1/3;"></div>
  <div class="workflow-box" style="grid-column:1;grid-row:4;">CV_COMP_MD_COMPFL_STATIC</div>
  <div class="workflow-box" style="grid-column:2;grid-row:4;">COMP_FLAG_BUDGET<br><span style='font-size:12px;color:#888;'>Projection<br>Filter</span></div>
  <div class="workflow-connector" style="grid-column:1/2;grid-row:4;"></div>
  <div class="workflow-box" style="grid-column:3;grid-row:3;">Join_3<br><span style='font-size:12px;color:#888;'>Left Outer Join</span></div>
  <div class="workflow-connector" style="grid-column:3/3;grid-row:2/4;"></div>
  <div class="workflow-box" style="grid-column:1;grid-row:5;">CV_BASE_MD_RCALWEEK_S4</div>
  <div class="workflow-box" style="grid-column:2;grid-row:5;">CAL_WEEK<br><span style='font-size:12px;color:#888;'>Projection</span></div>
  <div class="workflow-connector" style="grid-column:1/2;grid-row:5;"></div>
  <div class="workflow-box" style="grid-column:3;grid-row:4;">Join_4<br><span style='font-size:12px;color:#888;'>Left Outer Join</span></div>
  <div class="workflow-connector" style="grid-column:3/3;grid-row:3/5;"></div>
  <div class="workflow-box" style="grid-column:1;grid-row:6;">CV_BASE_MD_CEPCT_S4</div>
  <div class="workflow-box" style="grid-column:2;grid-row:6;">PROFIT_CENTER_TEXT<br><span style='font-size:12px;color:#888;'>Projection</span></div>
  <div class="workflow-connector" style="grid-column:1/2;grid-row:6;"></div>
  <div class="workflow-box" style="grid-column:3;grid-row:5;">Join_5<br><span style='font-size:12px;color:#888;'>Left Outer Join</span></div>
  <div class="workflow-connector" style="grid-column:3/3;grid-row:4/6;"></div>
  <div class="workflow-box" style="grid-column:4;grid-row:5;">FLAGS<br><span style='font-size:12px;color:#888;'>Projection<br>Calculated Fields</span></div>
  <div class="workflow-connector" style="grid-column:3/4;grid-row:5;"></div>
</div>
</div>

<!-- 4. DATA MAPPING -->
<table border="1" cellspacing="0" cellpadding="4" style="border-collapse:collapse;width:100%;margin-top:16px;">
<tr><th>Target Object/Field Name</th><th>Target Column Name</th><th>Source Object/Field Name</th><th>Source Column Name</th><th>Remarks</th></tr>
<tr><td>FLAGS</td><td>MANDT</td><td>Join_5</td><td>MANDT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FISCPER</td><td>Join_5</td><td>FISCPER</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FISCVARNT</td><td>Join_5</td><td>FISCVARNT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FISCYEAR</td><td>Join_5</td><td>FISCYEAR</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FISCPER3</td><td>Join_5</td><td>FISCPER3</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RECORDMODE</td><td>Join_5</td><td>RECORDMODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_SWEEK</td><td>Join_5</td><td>_BIC_ZIO_SWEEK</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_B631_S_CO_AREA</td><td>Join_5</td><td>_B631_S_CO_AREA</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_CMPCD</td><td>Join_5</td><td>_BIC_ZIO_CMPCD</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_B631_S_PROFTCTR</td><td>Join_5</td><td>_B631_S_PROFTCTR</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_B631_S_COSTCNTR</td><td>Join_5</td><td>_B631_S_COSTCNTR</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_VER</td><td>Join_5</td><td>_BIC_ZIO_VER</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_SAUDT</td><td>Join_5</td><td>_BIC_ZIO_SAUDT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>REP_MKT_CODE</td><td>Join_5</td><td>REP_MKT_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>REP_MKT_DESC</td><td>Join_5</td><td>REP_MKT_DESC</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>EMERG_MKT_IND</td><td>Join_5</td><td>EMERG_MKT_IND</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_PSTY</td><td>Join_5</td><td>_BIC_ZIO_PSTY</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_PSKF</td><td>Join_5</td><td>_BIC_ZIO_PSKF</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>UNIT</td><td>Join_5</td><td>UNIT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>DIVISION_CODE</td><td>Join_5</td><td>DIVISION_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>DIVISION_DESC</td><td>Join_5</td><td>DIVISION_DESC</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>AREA_CODE</td><td>Join_5</td><td>AREA_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>AREA_DESC</td><td>Join_5</td><td>AREA_DESC</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>DISTRICT_CODE</td><td>Join_5</td><td>DISTRICT_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>DISTRICT_DESC</td><td>Join_5</td><td>DISTRICT_DESC</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>REGION_CODE</td><td>Join_5</td><td>REGION_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>REGION_DESC</td><td>Join_5</td><td>REGION_DESC</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>CAL_WEEK_NUMBER</td><td>FLAGS</td><td>CAL_WEEK_NUMBER</td><td>Calculated: rightstr("_BIC_ZIO_SWEEK",2)</td></tr>
<tr><td>FLAGS</td><td>STRNUM</td><td>Join_5</td><td>STRNUM</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>ZRWENDDATE</td><td>Join_5</td><td>ZRWENDDATE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>ZRWSTRTDATE</td><td>Join_5</td><td>ZRWSTRTDATE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>CITY</td><td>Join_5</td><td>CITY</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>STATE</td><td>Join_5</td><td>STATE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>PROFIT_CENTER_TEXT</td><td>Join_5</td><td>PROFIT_CENTER_TEXT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FS_OPEN_DAT</td><td>Join_5</td><td>FS_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RX_OPEN_DAT</td><td>Join_5</td><td>RX_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RX_COMP_WK</td><td>FLAGS</td><td>CAL_RX_COMP_WK</td><td>Calculated: IF(ISNULL("RX_COMP_WK"),'0',"RX_COMP_WK")</td></tr>
<tr><td>FLAGS</td><td>SKF_BUD_CUBE</td><td>Join_5</td><td>FLAG</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RX_DIVISION_CODE</td><td>Join_5</td><td>RX_DIVISION_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RX_AREA_CODE</td><td>Join_5</td><td>RX_AREA_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RX_REGION_CODE</td><td>Join_5</td><td>RX_REGION_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RX_DISTRICT_CODE</td><td>Join_5</td><td>RX_DISTRICT_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_SKFQ_NEGATIVE</td><td>FLAGS</td><td>_BIC_ZIO_SKFQ</td><td>Aggregated: sum(_BIC_ZIO_SKFQ)</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_SKFQ</td><td>FLAGS</td><td>CAL_BIC_ZIO_SKFQ</td><td>Calculated: CASE("_BIC_ZIO_PSKF",'804013',"_BIC_ZIO_SKFQ"*2,"_BIC_ZIO_SKFQ") aggregated by sum</td></tr>
</table>

<!-- 5. COMPLEXITY ANALYSIS -->
<table border="1" cellspacing="0" cellpadding="4" style="border-collapse:collapse;width:100%;margin-top:16px;">
<tr><th>Category</th><th>Measurement</th></tr>
<tr><td>Number of Objects/Nodes</td><td>13 Calculation View nodes (6 projections, 5 joins, 1 logical model, 1 calculated projection)</td></tr>
<tr><td>Sources Used</td><td>6 referenced Calculation Views</td></tr>
<tr><td>Joins</td><td>5 join nodes (Join_1 to Join_5)</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>sum aggregation on _BIC_ZIO_SKFQ, CAL_BIC_ZIO_SKFQ</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>CASE and IF expressions in calculated fields</td></tr>
<tr><td>Workflow Complexity</td><td>Medium; multi-level joins, projections, calculated fields, and variable-driven filters</td></tr>
<tr><td>Performance Considerations</td><td>Multiple joins, calculated fields, filters, and aggregations may impact performance depending on data volume and referenced view complexity</td></tr>
<tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
<tr><td>Dependency Complexity</td><td>High; depends on 6 external Calculation Views and complex join relationships</td></tr>
<tr><td>Overall Complexity Score</td><td>Medium</td></tr>
</table>

<!-- 6. SENSITIVE AND PRIVACY DATA ASSESSMENT -->
No sensitive data found

<!-- 7. KEY OUTPUTS -->
<ul>
  <li>MANDT</li>
  <li>FISCPER</li>
  <li>FISCVARNT</li>
  <li>FISCYEAR</li>
  <li>FISCPER3</li>
  <li>RECORDMODE</li>
  <li>_BIC_ZIO_SWEEK</li>
  <li>_B631_S_CO_AREA</li>
  <li>_BIC_ZIO_CMPCD</li>
  <li>_B631_S_PROFTCTR</li>
  <li>_B631_S_COSTCNTR</li>
  <li>_BIC_ZIO_VER</li>
  <li>_BIC_ZIO_SAUDT</li>
  <li>REP_MKT_CODE</li>
  <li>REP_MKT_DESC</li>
  <li>EMERG_MKT_IND</li>
  <li>_BIC_ZIO_PSTY</li>
  <li>_BIC_ZIO_PSKF</li>
  <li>UNIT</li>
  <li>DIVISION_CODE</li>
  <li>DIVISION_DESC</li>
  <li>AREA_CODE</li>
  <li>AREA_DESC</li>
  <li>DISTRICT_CODE</li>
  <li>DISTRICT_DESC</li>
  <li>REGION_CODE</li>
  <li>REGION_DESC</li>
  <li>CAL_WEEK_NUMBER</li>
  <li>STRNUM</li>
  <li>ZRWENDDATE</li>
  <li>ZRWSTRTDATE</li>
  <li>CITY</li>
  <li>STATE</li>
  <li>PROFIT_CENTER_TEXT</li>
  <li>FS_OPEN_DAT</li>
  <li>RX_OPEN_DAT</li>
  <li>RX_COMP_WK</li>
  <li>SKF_BUD_CUBE</li>
  <li>RX_DIVISION_CODE</li>
  <li>RX_AREA_CODE</li>
  <li>RX_REGION_CODE</li>
  <li>RX_DISTRICT_CODE</li>
  <li>_BIC_ZIO_SKFQ_NEGATIVE</li>
  <li>_BIC_ZIO_SKFQ</li>
</ul>

<!-- 8. API COST CALCULATIONS -->
API COST : 0.0000 USD
