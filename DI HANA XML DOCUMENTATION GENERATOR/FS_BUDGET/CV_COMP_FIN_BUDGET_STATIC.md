<!-- DOCUMENT HEADER -->
<table style="width:100%;border-collapse:collapse;margin-bottom:16px;">
  <tr><td style="font-weight:bold;width:20%">Author:</td><td>Ascendion AAVA</td></tr>
  <tr><td style="font-weight:bold;">Created On:</td><td>2026-10-07</td></tr>
  <tr><td style="font-weight:bold;">Description:</td><td>Composite Calculation View for Weekly Static Financial Budget, designed to aggregate, join, and enrich financial and store-related data across multiple sources. The view supports parameterized filtering by version and week-ending range, and produces a cube output with calculated and mapped fields.</td></tr>
</table>

<!-- 1. Overview of Program -->
<p><b>Overview of Program:</b><br>
This HANA XML file defines a Calculation View of type CUBE, named <code>CV_COMP_FIN_BUDGET_STATIC</code>. Its primary purpose is to model and aggregate weekly static financial budget data, integrating multiple sources and enriching the output with store, profit center, and period details. The view processes input parameters, applies filters, performs joins, and computes calculated fields to deliver a structured, reporting-enabled output.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View is structured as a tree-based scenario with multiple interconnected nodes, including projections, joins, and calculated fields. It utilizes parameters for filtering (such as version and week-ending range), and references several calculation views as data sources. The workflow begins with projections and filters, continues through a sequence of joins that enrich the data with hierarchical, store, and profit center information, and concludes with calculated fields and a logical output model. <b>Key Components:</b> Major components include local variables (<code>IP_VERSION</code>, <code>IP_WEEK_ENDING_FROM</code>, <code>IP_WEEK_ENDING_TO</code>), data sources (referenced calculation views), projection nodes (such as <code>WEEKLY_SNAPSHOT_DS05</code>, <code>STORE_ATTR_ACTUAL</code>), join nodes (<code>Join_1</code> through <code>Join_5</code>), calculated fields (e.g., <code>CAL_STORE_WEEK_NUMBER</code>, <code>CAL_FS_RX_FLAG</code>, <code>CAL_COMP_FLAG</code>, <code>_B631_S_AMOUNT</code>), and a logical model that defines the output attributes and measures. <b>Dependencies & Performance:</b> The object depends on multiple calculation views and applies several joins and filters, including inner and left outer joins, range and single-value filters, and calculated expressions. The use of parameters, conditional logic, and calculated fields adds complexity. No explicit aggregation or caching is identified beyond standard aggregation for measures. Performance considerations include the number of joins, conditional logic, and dependency on external calculation views.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;max-width:100%;padding:8px;background:#f9f9f9;border-radius:8px;">
  <div style="display:grid;grid-template-columns:repeat(4,220px);grid-auto-rows:120px;gap:32px;align-items:center;justify-items:center;">
    <div style="grid-column:1;grid-row:1;background:#e3e7f1;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">CV_BASE_FIN_WEEKLY_BUDGET_S4</div>
    <div style="grid-column:2;grid-row:1;background:#e3e7f1;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">CV_BASE_MD_HRRP_NODE_S4</div>
    <div style="grid-column:3;grid-row:1;background:#e3e7f1;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">CV_COMP_MD_SRPACT_STATIC</div>
    <div style="grid-column:4;grid-row:1;background:#e3e7f1;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">CV_COMP_MD_COMPFL_STATIC</div>
    <div style="grid-column:1;grid-row:2;background:#cde2d6;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">WEEKLY_SNAPSHOT_DS05<br><span style="font-size:small;">Projection</span></div>
    <div style="grid-column:2;grid-row:2;background:#cde2d6;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">HIER_NODE<br><span style="font-size:small;">Projection</span></div>
    <div style="grid-column:1;grid-row:3;background:#f6e3c3;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">Join_1<br><span style="font-size:small;">Inner Join</span></div>
    <div style="grid-column:1;grid-row:4;background:#cde2d6;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">ONLY_CORE_RET_DATA<br><span style="font-size:small;">Projection</span></div>
    <div style="grid-column:2;grid-row:4;background:#cde2d6;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">STORE_ATTR_ACTUAL<br><span style="font-size:small;">Projection</span></div>
    <div style="grid-column:1;grid-row:5;background:#f6e3c3;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">Join_2<br><span style="font-size:small;">Left Outer Join</span></div>
    <div style="grid-column:1;grid-row:6;background:#cde2d6;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">WEEK_NUMBER<br><span style="font-size:small;">Projection<br/>Calculated Field</span></div>
    <div style="grid-column:4;grid-row:2;background:#cde2d6;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">COMP_FLAG_BUDGET<br><span style="font-size:small;">Projection</span></div>
    <div style="grid-column:1;grid-row:7;background:#f6e3c3;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">Join_3<br><span style="font-size:small;">Left Outer Join</span></div>
    <div style="grid-column:4;grid-row:3;background:#e3e7f1;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">CV_BASE_MD_RCALWEEK_S4</div>
    <div style="grid-column:4;grid-row:4;background:#cde2d6;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">CAL_WEEK<br><span style="font-size:small;">Projection</span></div>
    <div style="grid-column:1;grid-row:8;background:#f6e3c3;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">Join_4<br><span style="font-size:small;">Left Outer Join</span></div>
    <div style="grid-column:2;grid-row:5;background:#e3e7f1;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">CV_BASE_MD_CEPCT_S4</div>
    <div style="grid-column:2;grid-row:6;background:#cde2d6;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">PROFIT_CENTER_TEXT<br><span style="font-size:small;">Projection</span></div>
    <div style="grid-column:1;grid-row:9;background:#f6e3c3;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">Join_5<br><span style="font-size:small;">Left Outer Join</span></div>
    <div style="grid-column:1;grid-row:10;background:#cde2d6;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">FLAGS<br><span style="font-size:small;">Projection<br/>Calculated Fields</span></div>
    <!-- arrows/connectors -->
    <svg style="grid-column:1;grid-row:2;position:relative;left:90px;top:-40px;" width="40" height="40"><line x1="0" y1="0" x2="40" y2="40" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
    <svg style="grid-column:2;grid-row:2;position:relative;left:-100px;top:-40px;" width="40" height="40"><line x1="40" y1="0" x2="0" y2="40" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
    <svg style="grid-column:1;grid-row:3;position:relative;left:90px;top:-40px;" width="40" height="40"><line x1="0" y1="0" x2="40" y2="40" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
    <svg style="grid-column:1;grid-row:4;position:relative;left:90px;top:-40px;" width="40" height="40"><line x1="0" y1="0" x2="40" y2="40" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
    <svg style="grid-column:1;grid-row:5;position:relative;left:90px;top:-40px;" width="40" height="40"><line x1="0" y1="0" x2="40" y2="40" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
    <svg style="grid-column:1;grid-row:6;position:relative;left:90px;top:-40px;" width="40" height="40"><line x1="0" y1="0" x2="40" y2="40" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
    <svg style="grid-column:1;grid-row:7;position:relative;left:90px;top:-40px;" width="40" height="40"><line x1="0" y1="0" x2="40" y2="40" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
    <svg style="grid-column:1;grid-row:8;position:relative;left:90px;top:-40px;" width="40" height="40"><line x1="0" y1="0" x2="40" y2="40" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
    <svg style="grid-column:1;grid-row:9;position:relative;left:90px;top:-40px;" width="40" height="40"><line x1="0" y1="0" x2="40" y2="40" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
    <svg style="grid-column:1;grid-row:10;position:relative;left:90px;top:-40px;" width="40" height="40"><line x1="0" y1="0" x2="40" y2="40" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%;border-collapse:collapse;">
<thead><tr style="background:#e3e7f1;">
<th>Target Object/Field Name</th><th>Target Column Name</th><th>Source Object/Field Name</th><th>Source Column Name</th><th>Remarks</th>
</tr></thead>
<tbody>
<tr><td>FLAGS</td><td>CAL_FS_RX_FLAG</td><td>Join_5</td><td>_BIC_ZWWPC_PA1</td><td>CASE(LEFTSTR("_BIC_ZWWPC_PA1",2),'FS','FS','RX','RX','')</td></tr>
<tr><td>FLAGS</td><td>CAL_COMP_FLAG</td><td>Join_5</td><td>FS_COMP_WK, RX_COMP_WK, CAL_FS_RX_FLAG</td><td>if(isnull(CASE("CAL_FS_RX_FLAG",'FS',"FS_COMP_WK",'RX',"RX_COMP_WK","FS_COMP_WK")), '0', CASE("CAL_FS_RX_FLAG",'FS',"FS_COMP_WK",'RX',"RX_COMP_WK","FS_COMP_WK"))</td></tr>
<tr><td>FLAGS</td><td>CAL_WEEK_NUMBER</td><td>Join_5</td><td>_BIC_ZIO_SWEEK</td><td>RIGHTSTR("_BIC_ZIO_SWEEK",2)</td></tr>
<tr><td>FLAGS</td><td>_B631_S_AMOUNT</td><td>Join_5</td><td>_B631_S_AMOUNT_NEGATIVE</td><td>"_B631_S_AMOUNT_NEGATIVE"*-1</td></tr>
<tr><td>FLAGS</td><td>PROFIT_CENTER_TEXT</td><td>PROFIT_CENTER_TEXT</td><td>LTEXT</td><td>Profit Center Description</td></tr>
<tr><td>FLAGS</td><td>FS_COMP_WK</td><td>COMP_FLAG_BUDGET</td><td>FS_COMP_WK</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RX_COMP_WK</td><td>COMP_FLAG_BUDGET</td><td>RX_COMP_WK</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_SWEEK</td><td>COMP_FLAG_BUDGET</td><td>ZWEEK</td><td>Join on week</td></tr>
<tr><td>FLAGS</td><td>_B631_S_PROFTCTR</td><td>COMP_FLAG_BUDGET</td><td>PRCTR</td><td>Join on profit center</td></tr>
<tr><td>FLAGS</td><td>_B631_S_AMOUNT_NEGATIVE</td><td>Join_5</td><td>_B631_S_AMOUNT</td><td>Negative transformation</td></tr>
<tr><td>FLAGS</td><td>ZRWSTRTDATE</td><td>CAL_WEEK</td><td>ZRWSTRTDATE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>ZRWENDDATE</td><td>CAL_WEEK</td><td>ZRWENDDATE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RX_DIVISION_CODE</td><td>STORE_ATTR_ACTUAL</td><td>RX_DIVISION_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RX_AREA_CODE</td><td>STORE_ATTR_ACTUAL</td><td>RX_AREA_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RX_REGION_CODE</td><td>STORE_ATTR_ACTUAL</td><td>RX_REGION_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RX_DISTRICT_CODE</td><td>STORE_ATTR_ACTUAL</td><td>RX_DISTRICT_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FS_OPEN_DAT</td><td>STORE_ATTR_ACTUAL</td><td>FS_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RX_OPEN_DAT</td><td>STORE_ATTR_ACTUAL</td><td>RX_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>STRNUM</td><td>STORE_ATTR_ACTUAL</td><td>STRNUM</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>MANDT</td><td>Join_5</td><td>MANDT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FISCPER</td><td>Join_5</td><td>FISCPER</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FISCVARNT</td><td>Join_5</td><td>FISCVARNT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FISCYEAR</td><td>Join_5</td><td>FISCYEAR</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FISCPER3</td><td>Join_5</td><td>FISCPER3</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_B631_S_CHRTACCT</td><td>Join_5</td><td>_B631_S_CHRTACCT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_B631_S_CO_AREA</td><td>Join_5</td><td>_B631_S_CO_AREA</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_CMPCD</td><td>Join_5</td><td>_BIC_ZIO_CMPCD</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_B631_S_COSTCNTR</td><td>Join_5</td><td>_B631_S_COSTCNTR</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_B631_S_FUNCAREA</td><td>Join_5</td><td>_B631_S_FUNCAREA</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_VER</td><td>Join_5</td><td>_BIC_ZIO_VER</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_SAUDT</td><td>Join_5</td><td>_BIC_ZIO_SAUDT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_B631_S_GL_ACCT</td><td>Join_5</td><td>_B631_S_GL_ACCT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZWWPC_PA1</td><td>Join_5</td><td>_BIC_ZWWPC_PA1</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZWWSC_PA1</td><td>Join_5</td><td>_BIC_ZWWSC_PA1</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>CURRENCY</td><td>Join_5</td><td>CURRENCY</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_AMT</td><td>Join_5</td><td>_BIC_ZIO_AMT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>REP_MKT_CODE</td><td>Join_5</td><td>REP_MKT_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>REP_MKT_DESC</td><td>Join_5</td><td>REP_MKT_DESC</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>EMERG_MKT_IND</td><td>Join_5</td><td>EMERG_MKT_IND</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>DIVISION_CODE</td><td>Join_5</td><td>DIVISION_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>DIVISION_DESC</td><td>Join_5</td><td>DIVISION_DESC</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>AREA_CODE</td><td>Join_5</td><td>AREA_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>AREA_DESC</td><td>Join_5</td><td>AREA_DESC</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>DISTRICT_CODE</td><td>Join_5</td><td>DISTRICT_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>DISTRICT_DESC</td><td>Join_5</td><td>DISTRICT_DESC</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>REGION_CODE</td><td>Join_5</td><td>REGION_CODE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>REGION_DESC</td><td>Join_5</td><td>REGION_DESC</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>CITY</td><td>Join_5</td><td>CITY</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>STATE</td><td>Join_5</td><td>STATE</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FS_OPEN_DAT</td><td>Join_5</td><td>FS_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>RX_OPEN_DAT</td><td>Join_5</td><td>RX_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>FLAGS</td><td>FLAG</td><td>Join_5</td><td>FLAG</td><td>Direct mapping</td></tr>
</tbody>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%;border-collapse:collapse;">
<thead><tr style="background:#e3e7f1;">
<th>Category</th><th>Measurement</th>
</tr></thead>
<tbody>
<tr><td>Number of Objects/Nodes</td><td>21 (including projections, joins, and logical model)</td></tr>
<tr><td>Sources Used</td><td>6 calculation views referenced as sources</td></tr>
<tr><td>Joins</td><td>5 join nodes (Join_1 to Join_5)</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>Sum aggregation for measures (_B631_S_AMOUNT_NEGATIVE, _BIC_ZIO_AMT, _B631_S_AMOUNT)</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>CASE, IF, ISNULL expressions in calculated fields</td></tr>
<tr><td>Workflow Complexity</td><td>High: Multiple projections, joins, filters, calculated fields, and logical output model</td></tr>
<tr><td>Performance Considerations</td><td>Multiple joins, parameterized filters, calculated fields, dependency on external calculation views</td></tr>
<tr><td>Data Volume Handling</td><td>Not explicitly defined in the XML</td></tr>
<tr><td>Dependency Complexity</td><td>High: Multiple calculation view dependencies and join relationships</td></tr>
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
<li>FS_RX_FLAG (CAL_FS_RX_FLAG)</li>
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
<li>COMP_FLAG (CAL_COMP_FLAG)</li>
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
<li>FIN_BUD_CUBE (FLAG)</li>
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
