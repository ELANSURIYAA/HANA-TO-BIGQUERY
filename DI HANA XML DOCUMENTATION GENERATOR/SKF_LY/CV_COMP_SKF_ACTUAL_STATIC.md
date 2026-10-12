<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:10px;margin-bottom:15px;">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> 2026-10-12<br>
  <b>Description:</b> Composite Calculation View for Weekly Static SKF Actuals. This HANA XML object models, aggregates, and joins multiple data sources to produce a cube output for reporting static SKF actuals, including week, version, market, and store attributes.
</div>

<!-- 1. Overview of Program -->
<p>
This object is a Calculation View of type <b>CUBE</b> defined in HANA XML. Its primary purpose is to integrate and aggregate weekly static SKF actuals from multiple sources, applying various projections, joins, and calculated fields. The view produces a reporting-enabled aggregation output combining fiscal, store, market, and flag data.
</p>

<!-- 2. Code Structure and Design -->
<p>
<b>Structure:</b> The Calculation View consists of a tree-based scenario with multiple modeling nodes, including projections, joins (inner and left outer), calculated fields, and filters. The structure features local variables, data sources, and a logical model defining attributes and measures. The processing flow starts from base calculation views and master data, proceeds through projections and joins, and culminates in aggregations and calculated fields.<br>
<b>Key Components:</b> Major components include data sources (base and composite calculation views), projection nodes (such as WEEKLY_SNAPSHOT_DS05, STORE_ATTR_ACTUAL, CC_HIER, COMP_FLAG_ACT01, RETAIL_CAL, PROFIT_CENTER_TEXT), join nodes (Join_1 to Join_5), calculated fields (e.g., CAL_WEEK, CAL_WEEK_NUMBER, CAL_ZIO_SKFQ_QTY), and a logical model (FLAGS) defining output attributes and measures. Filters and mapping relationships are applied throughout.<br>
<b>Dependencies & Performance:</b> The view depends on six external calculation views and applies multiple joins and filters, including inner and left outer joins, conditional expressions, and calculated fields. The aggregation output is defined by summing specific measures. Performance-relevant characteristics include nested joins, filters, calculated fields, and aggregation logic, all visible in the XML structure.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;background:#f9f9f9;padding:15px;border-radius:8px;max-width:100%;">
<style>
.workflow-grid {
  display: grid;
  grid-template-columns: repeat(7, 180px);
  grid-template-rows: repeat(7, 100px);
  gap: 20px;
  align-items: center;
  justify-items: center;
}
.workflow-box {
  background: #e3e8f0;
  border: 1px solid #b5b5b5;
  border-radius: 8px;
  padding: 16px 10px;
  font-size: 13px;
  text-align: center;
  width: 160px;
  height: 60px;
  box-shadow: 0 2px 8px #00000011;
}
.arrow {
  font-size: 32px;
  color: #888;
  margin: 0 10px;
}
</style>
<div class="workflow-grid">
  <!-- Row 1: Data Sources -->
  <div class="workflow-box" style="grid-column:1;grid-row:1;">CV_BASE_SKF_WEEKLY_ACTUAL_S4</div>
  <div class="workflow-box" style="grid-column:2;grid-row:1;">CV_COMP_MD_SRPACT_STATIC</div>
  <div class="workflow-box" style="grid-column:3;grid-row:1;">CV_BASE_MD_HRRP_NODE_S4</div>
  <div class="workflow-box" style="grid-column:4;grid-row:1;">CV_COMP_MD_COMPFL_STATIC</div>
  <div class="workflow-box" style="grid-column:5;grid-row:1;">CV_BASE_MD_RCALWEEK_S4</div>
  <div class="workflow-box" style="grid-column:6;grid-row:1;">CV_BASE_MD_CEPCT_S4</div>

  <!-- Row 2: Projections -->
  <div class="workflow-box" style="grid-column:1;grid-row:2;">WEEKLY_SNAPSHOT_DS05</div>
  <div class="workflow-box" style="grid-column:2;grid-row:2;">STORE_ATTR_ACTUAL</div>
  <div class="workflow-box" style="grid-column:3;grid-row:2;">CC_HIER</div>
  <div class="workflow-box" style="grid-column:4;grid-row:2;">COMP_FLAG_ACT01</div>
  <div class="workflow-box" style="grid-column:5;grid-row:2;">RETAIL_CAL</div>
  <div class="workflow-box" style="grid-column:6;grid-row:2;">PROFIT_CENTER_TEXT</div>

  <!-- Row 3: Joins & Projections -->
  <div class="workflow-box" style="grid-column:2;grid-row:3;">Join_3</div>
  <div class="workflow-box" style="grid-column:2;grid-row:4;">Projection_1</div>
  <div class="workflow-box" style="grid-column:2;grid-row:5;">Join_2</div>
  <div class="workflow-box" style="grid-column:3;grid-row:5;">Join_1</div>
  <div class="workflow-box" style="grid-column:4;grid-row:5;">Join_4</div>
  <div class="workflow-box" style="grid-column:5;grid-row:5;">Join_5</div>

  <!-- Row 6: Final Projection -->
  <div class="workflow-box" style="grid-column:5;grid-row:6;">FLAGS</div>

  <!-- Arrows -->
  <div style="grid-column:1;grid-row:1;">&#8595;</div>
  <div style="grid-column:2;grid-row:1;">&#8595;</div>
  <div style="grid-column:3;grid-row:1;">&#8595;</div>
  <div style="grid-column:4;grid-row:1;">&#8595;</div>
  <div style="grid-column:5;grid-row:1;">&#8595;</div>
  <div style="grid-column:6;grid-row:1;">&#8595;</div>

  <div style="grid-column:1;grid-row:2;">&#8595;</div>
  <div style="grid-column:2;grid-row:2;">&#8595;</div>
  <div style="grid-column:3;grid-row:2;">&#8595;</div>
  <div style="grid-column:4;grid-row:2;">&#8595;</div>
  <div style="grid-column:5;grid-row:2;">&#8595;</div>
  <div style="grid-column:6;grid-row:2;">&#8595;</div>

  <!-- Join arrows -->
  <div style="grid-column:1;grid-row:2;">&#8594;</div>
  <div style="grid-column:3;grid-row:2;">&#8594;</div>
  <div style="grid-column:2;grid-row:3;">&#8595;</div>
  <div style="grid-column:2;grid-row:4;">&#8595;</div>
  <div style="grid-column:2;grid-row:5;">&#8594;</div>
  <div style="grid-column:3;grid-row:5;">&#8594;</div>
  <div style="grid-column:4;grid-row:5;">&#8594;</div>
  <div style="grid-column:5;grid-row:5;">&#8595;</div>

  <div style="grid-column:5;grid-row:6;">&#8595;</div>
</div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse:collapse;width:100%;">
<tr><th>Target Object/Field Name</th><th>Target Column Name</th><th>Source Object/Field Name</th><th>Source Column Name</th><th>Remarks</th></tr>
<tr><td>FLAGS</td><td>CAL_WEEK</td><td>Projection_1</td><td>CAL_WEEK</td><td>Calculated as: '$$IP_WEEK_CY$$'</td></tr>
<tr><td>FLAGS</td><td>CAL_WEEK_NUMBER</td><td>FLAGS</td><td>CAL_WEEK_NUMBER</td><td>Calculated as: RIGHTSTR('$$IP_WEEK_CY$$',2)</td></tr>
<tr><td>FLAGS</td><td>CAL_ZIO_SKFQ_QTY</td><td>FLAGS</td><td>CAL_ZIO_SKFQ_QTY</td><td>CASE("_BIC_ZIO_PSKF",'804013',"_BIC_ZIO_SKFQ"*2,"_BIC_ZIO_SKFQ")</td></tr>
<tr><td>FLAGS</td><td>PROFIT_CENTER_TEXT</td><td>PROFIT_CENTER_TEXT</td><td>PROFIT_CENTER_TEXT</td><td>Mapped from LTEXT in CV_BASE_MD_CEPCT_S4</td></tr>
<tr><td>FLAGS</td><td>RX_COMP_WK</td><td>COMP_FLAG_ACT01</td><td>RX_COMP_WK</td><td>Filtered by ZWEEK and COMP_VER</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_SKFQ</td><td>FLAGS</td><td>CAL_ZIO_SKFQ_QTY</td><td>Aggregated SUM</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_D1SKQ</td><td>FLAGS</td><td>_BIC_ZIO_D1SKQ</td><td>Aggregated SUM</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_D2SKQ</td><td>FLAGS</td><td>_BIC_ZIO_D2SKQ</td><td>Aggregated SUM</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_D3SKQ</td><td>FLAGS</td><td>_BIC_ZIO_D3SKQ</td><td>Aggregated SUM</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_D4SKQ</td><td>FLAGS</td><td>_BIC_ZIO_D4SKQ</td><td>Aggregated SUM</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_D5SKQ</td><td>FLAGS</td><td>_BIC_ZIO_D5SKQ</td><td>Aggregated SUM</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_D6SKQ</td><td>FLAGS</td><td>_BIC_ZIO_D6SKQ</td><td>Aggregated SUM</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_D7SKQ</td><td>FLAGS</td><td>_BIC_ZIO_D7SKQ</td><td>Aggregated SUM</td></tr>
<tr><td>FLAGS</td><td>MANDT</td><td>Multiple Nodes</td><td>MANDT</td><td>Mapped across joins</td></tr>
<tr><td>FLAGS</td><td>_B631_S_PROFTCTR</td><td>Multiple Nodes</td><td>PRCTR/_B631_S_PROFTCTR</td><td>Mapped and joined across STORE_ATTR_ACTUAL, PROFIT_CENTER_TEXT</td></tr>
<tr><td>FLAGS</td><td>REP_MKT_CODE</td><td>STORE_ATTR_ACTUAL</td><td>REP_MKT_CODE</td><td>Mapped via Join_2</td></tr>
<tr><td>FLAGS</td><td>DIVISION_CODE</td><td>STORE_ATTR_ACTUAL</td><td>DIVISION_CODE</td><td>Mapped via Join_2</td></tr>
<tr><td>FLAGS</td><td>AREA_CODE</td><td>STORE_ATTR_ACTUAL</td><td>AREA_CODE</td><td>Mapped via Join_2</td></tr>
<tr><td>FLAGS</td><td>REGION_CODE</td><td>STORE_ATTR_ACTUAL</td><td>REGION_CODE</td><td>Mapped via Join_2</td></tr>
<tr><td>FLAGS</td><td>DISTRICT_CODE</td><td>STORE_ATTR_ACTUAL</td><td>DISTRICT_CODE</td><td>Mapped via Join_2</td></tr>
<tr><td>FLAGS</td><td>STRNUM</td><td>STORE_ATTR_ACTUAL</td><td>STRNUM</td><td>Mapped via Join_2</td></tr>
<tr><td>FLAGS</td><td>CITY</td><td>STORE_ATTR_ACTUAL</td><td>CITY</td><td>Mapped via Join_2</td></tr>
<tr><td>FLAGS</td><td>STATE</td><td>STORE_ATTR_ACTUAL</td><td>STATE</td><td>Mapped via Join_2</td></tr>
<tr><td>FLAGS</td><td>FS_OPEN_DAT</td><td>STORE_ATTR_ACTUAL</td><td>FS_OPEN_DAT</td><td>Mapped via Join_2</td></tr>
<tr><td>FLAGS</td><td>RX_OPEN_DAT</td><td>STORE_ATTR_ACTUAL</td><td>RX_OPEN_DAT</td><td>Mapped via Join_2</td></tr>
<tr><td>FLAGS</td><td>RX_DIVISION_CODE</td><td>STORE_ATTR_ACTUAL</td><td>RX_DIVISION_CODE</td><td>Mapped via Join_2</td></tr>
<tr><td>FLAGS</td><td>RX_AREA_CODE</td><td>STORE_ATTR_ACTUAL</td><td>RX_AREA_CODE</td><td>Mapped via Join_2</td></tr>
<tr><td>FLAGS</td><td>RX_REGION_CODE</td><td>STORE_ATTR_ACTUAL</td><td>RX_REGION_CODE</td><td>Mapped via Join_2</td></tr>
<tr><td>FLAGS</td><td>RX_DISTRICT_CODE</td><td>STORE_ATTR_ACTUAL</td><td>RX_DISTRICT_CODE</td><td>Mapped via Join_2</td></tr>
<tr><td>FLAGS</td><td>ZRWSTRTDATE</td><td>RETAIL_CAL</td><td>ZRWSTRTDATE</td><td>Mapped via Join_1</td></tr>
<tr><td>FLAGS</td><td>ZRWENDDATE</td><td>RETAIL_CAL</td><td>ZRWENDDATE</td><td>Mapped via Join_1</td></tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse:collapse;width:100%;">
<tr><th>Category</th><th>Measurement</th></tr>
<tr><td>Number of Objects/Nodes</td><td>15 (including projections, joins, logical model)</td></tr>
<tr><td>Sources Used</td><td>6 external calculation views</td></tr>
<tr><td>Joins</td><td>5 join nodes (Join_1 to Join_5), various join types</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>SUM aggregation on multiple measures</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>CASE expression in CAL_ZIO_SKFQ_QTY; filter conditions in projections</td></tr>
<tr><td>Workflow Complexity</td><td>High; multiple nested joins, projections, calculated fields, and aggregation output</td></tr>
<tr><td>Performance Considerations</td><td>Multiple joins, filters, calculated fields, and aggregation logic; dependencies on external views</td></tr>
<tr><td>Data Volume Handling</td><td>Aggregation logic present; explicit data volume not identified</td></tr>
<tr><td>Dependency Complexity</td><td>High; multiple external calculation views and nested processing nodes</td></tr>
<tr><td>Overall Complexity Score</td><td>High</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>Aggregated measures: _BIC_ZIO_SKFQ, _BIC_ZIO_D1SKQ, _BIC_ZIO_D2SKQ, _BIC_ZIO_D3SKQ, _BIC_ZIO_D4SKQ, _BIC_ZIO_D5SKQ, _BIC_ZIO_D6SKQ, _BIC_ZIO_D7SKQ, CAL_ZIO_SKFQ_QTY</li>
  <li>Reporting attributes: MANDT, FISCPER, FISCVARNT, FISCYEAR, FISCPER3, RECORDMODE, _BIC_ZIO_SWEEK, _B631_S_CO_AREA, _BIC_ZIO_CMPCD, _B631_S_PROFTCTR, _B631_S_COSTCNTR, _B631_S_FUNCAREA, _BIC_ZIO_VER, _BIC_ZIO_SAUDT, REP_MKT_CODE, REP_MKT_DESC, EMERG_MKT_IND, DIVISION_CODE, DIVISION_DESC, AREA_CODE, AREA_DESC, REGION_CODE, REGION_DESC, DISTRICT_CODE, DISTRICT_DESC, STRNUM, CITY, STATE, FS_OPEN_DAT, RX_OPEN_DAT, CAL_WEEK, CAL_WEEK_NUMBER, ZRWSTRTDATE, ZRWENDDATE, PROFIT_CENTER_TEXT, RX_DIVISION_CODE, RX_AREA_CODE, RX_REGION_CODE, RX_DISTRICT_CODE, RX_COMP_WK</li>
  <li>Calculated fields: CAL_WEEK, CAL_WEEK_NUMBER, CAL_ZIO_SKFQ_QTY</li>
  <li>Cube output for reporting static SKF actuals</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
