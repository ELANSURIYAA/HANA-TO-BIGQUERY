<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc; padding-bottom:8px; margin-bottom:16px;">
<b>Author:</b> Ascendion AAVA<br>
<b>Created On:</b> 2024-06-13<br>
<b>Description:</b> Composite Calculation View for Weekly Static Financial Actuals, modeling weekly actuals, comparison flags, and retail calendar information across multiple source views and hierarchies. The view aggregates and joins financial, store, and calendar data with calculated flags and week numbers.
</div>

<!-- 1. Overview of Program -->
<div style="margin-bottom:16px;">
This HANA XML file defines a Calculation View with a data category of CUBE. Its primary purpose is to model and aggregate weekly static financial actuals, including comparison flags and retail calendar information. The object performs multiple joins, projections, and calculated fields to produce a composite output for reporting and analysis.
</div>

<!-- 2. Code Structure and Design -->
<div style="margin-bottom:16px;">
<b>Structure:</b> The Calculation View is structured as a tree-based scenario, comprising multiple projection and join nodes, referencing seven calculation views as data sources. Processing includes variable-driven filters, calculated attributes, and aggregation logic. The workflow consists of projections (e.g., WEEKLY_SNAPSHOT_DS05, STORE_ATTR_ACTUAL), inner and left outer joins (e.g., Join_4, Join_6, Join_2, Join_1, Join_3, Join_5), calculated fields (e.g., CAL_WEEK, CAL_FS_RX_FLAG, CAL_COMP_FLAG, CAL_WEEK_NUMBER), and logical model output via the FLAGS node.
<b>Key Components:</b> Major components include local variables (parameters), multiple calculation views as sources, projection and join nodes for combining store, financial, hierarchy, and calendar data, calculated attributes for flag and week logic, and a logical model defining output attributes and measures. Filters and derivation rules are applied at several nodes for parameter-driven and comparison logic.
<b>Dependencies & Performance:</b> The Calculation View is dependent on seven referenced calculation views and several scalar functions for variable derivation. Multiple joins, projections, and calculated fields contribute to processing complexity. Filters and cardinality definitions, along with aggregation, affect performance, especially due to nested joins and calculated expressions. No explicit caching or materialization is identified in the XML.
</div>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow:auto; max-width:100%; background:#f9f9fa; padding:16px; border-radius:8px;">
<style>
.hana-grid { display:grid; grid-template-columns:repeat(6,180px); grid-auto-rows:80px; gap:24px; }
.hana-box { background:#fff; border:1px solid #bbb; border-radius:6px; box-shadow:0 2px 6px #eee; display:flex; align-items:center; justify-content:center; font-weight:bold; font-size:14px; padding:8px; text-align:center; }
.hana-arrow { grid-column:span 6; text-align:center; font-size:18px; color:#888; margin-top:-16px; margin-bottom:-16px; }
</style>
<div class="hana-grid">
<div class="hana-box" style="grid-column:1;grid-row:1;">CV_BASE_FIN_WEEKLY_ACTUAL_S4</div>
<div class="hana-box" style="grid-column:2;grid-row:1;">CV_COMP_MD_SRPACT_STATIC</div>
<div class="hana-box" style="grid-column:3;grid-row:1;">CV_BASE_MD_HRRP_NODE_S4</div>
<div class="hana-box" style="grid-column:4;grid-row:1;">GL_HIER$$$$CV_BASE_MD_HRRP_NODE_S4$$</div>
<div class="hana-box" style="grid-column:5;grid-row:1;">CV_BASE_MD_RCALWEEK_S4</div>
<div class="hana-box" style="grid-column:6;grid-row:1;">CV_COMP_MD_COMPFL_STATIC</div>
<div class="hana-box" style="grid-column:1;grid-row:2;">CV_BASE_MD_CEPCT_S4</div>
<div class="hana-arrow">&#8595;</div>
<div class="hana-box" style="grid-column:1;grid-row:3;">WEEKLY_SNAPSHOT_DS05</div>
<div class="hana-box" style="grid-column:2;grid-row:3;">STORE_ATTR_ACTUAL</div>
<div class="hana-box" style="grid-column:3;grid-row:3;">PC_HIER</div>
<div class="hana-box" style="grid-column:4;grid-row:3;">GL_HIER</div>
<div class="hana-box" style="grid-column:5;grid-row:3;">RETAIL_CAL</div>
<div class="hana-box" style="grid-column:6;grid-row:3;">COMP_FLAG_LY</div>
<div class="hana-arrow">&#8595;</div>
<div class="hana-box" style="grid-column:1;grid-row:4;">Join_4</div>
<div class="hana-box" style="grid-column:4;grid-row:4;">Join_6</div>
<div class="hana-box" style="grid-column:2;grid-row:4;">Projection_1</div>
<div class="hana-box" style="grid-column:3;grid-row:4;">Join_2</div>
<div class="hana-box" style="grid-column:5;grid-row:4;">Join_1</div>
<div class="hana-box" style="grid-column:6;grid-row:4;">WEEK_NUMBER</div>
<div class="hana-arrow">&#8595;</div>
<div class="hana-box" style="grid-column:1;grid-row:5;">Join_3</div>
<div class="hana-box" style="grid-column:2;grid-row:5;">PROFIT_CENTER_TEXT</div>
<div class="hana-box" style="grid-column:3;grid-row:5;">Join_5</div>
<div class="hana-arrow">&#8595;</div>
<div class="hana-box" style="grid-column:1;grid-row:6;">FLAGS</div>
</div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellspacing="0" cellpadding="4" style="border-collapse:collapse; width:100%; background:#fff;">
<tr style="background:#eee;">
<th>Target Object/Field Name</th><th>Target Column Name</th><th>Source Object/Field Name</th><th>Source Column Name</th><th>Remarks</th>
</tr>
<tr><td>FLAGS</td><td>MANDT</td><td>STORE_ATTR_ACTUAL</td><td>MANDT</td><td>Direct mapping via join</td></tr>
<tr><td>FLAGS</td><td>FISCPER</td><td>WEEKLY_SNAPSHOT_DS05</td><td>FISCPER</td><td>Direct mapping via projection</td></tr>
<tr><td>FLAGS</td><td>FISCVARNT</td><td>WEEKLY_SNAPSHOT_DS05</td><td>FISCVARNT</td><td>Direct mapping via projection</td></tr>
<tr><td>FLAGS</td><td>FISCYEAR</td><td>WEEKLY_SNAPSHOT_DS05</td><td>FISCYEAR</td><td>Direct mapping via projection</td></tr>
<tr><td>FLAGS</td><td>FISCPER3</td><td>WEEKLY_SNAPSHOT_DS05</td><td>FISCPER3</td><td>Direct mapping via projection</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_SWEEK</td><td>WEEKLY_SNAPSHOT_DS05</td><td>_BIC_ZIO_SWEEK</td><td>Direct mapping via projection</td></tr>
<tr><td>FLAGS</td><td>_B631_S_AMOUNT</td><td>Projection_1</td><td>_B631_S_AMOUNT</td><td>Aggregated measure, sum</td></tr>
<tr><td>FLAGS</td><td>CAL_FS_RX_FLAG</td><td>FLAGS</td><td>CAL_FS_RX_FLAG</td><td>Calculated: CASE(LEFTSTR("_BIC_ZWWPC_PA1",2),'FS','FS','RX','RX','')</td></tr>
<tr><td>FLAGS</td><td>CAL_COMP_FLAG</td><td>FLAGS</td><td>CAL_COMP_FLAG</td><td>Calculated: CASE("CAL_FS_RX_FLAG",'FS',"FS_COMP_WK",'RX',"RX_COMP_WK","FS_COMP_WK")</td></tr>
<tr><td>FLAGS</td><td>CAL_WEEK_NUMBER</td><td>FLAGS</td><td>CAL_WEEK_NUMBER</td><td>Calculated: RIGHTSTR('$$IP_WEEK_CY$$',2)</td></tr>
<tr><td>FLAGS</td><td>PROFIT_CENTER_TEXT</td><td>PROFIT_CENTER_TEXT</td><td>PROFIT_CENTER_TEXT</td><td>Direct mapping via join</td></tr>
<tr><td>FLAGS</td><td>FS_COMP_WK</td><td>COMP_FLAG_LY</td><td>FS_COMP_WK</td><td>Direct mapping via join</td></tr>
<tr><td>FLAGS</td><td>RX_COMP_WK</td><td>COMP_FLAG_LY</td><td>RX_COMP_WK</td><td>Direct mapping via join</td></tr>
<tr><td>FLAGS</td><td>CAL_WEEK</td><td>Projection_1</td><td>CAL_WEEK</td><td>Calculated: '$$IP_WEEK_CY$$'</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_D1AMT</td><td>Projection_1</td><td>_BIC_ZIO_D1AMT</td><td>Aggregated measure, sum</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_D2AMT</td><td>Projection_1</td><td>_BIC_ZIO_D2AMT</td><td>Aggregated measure, sum</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_D3AMT</td><td>Projection_1</td><td>_BIC_ZIO_D3AMT</td><td>Aggregated measure, sum</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_D4AMT</td><td>Projection_1</td><td>_BIC_ZIO_D4AMT</td><td>Aggregated measure, sum</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_D5AMT</td><td>Projection_1</td><td>_BIC_ZIO_D5AMT</td><td>Aggregated measure, sum</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_D6AMT</td><td>Projection_1</td><td>_BIC_ZIO_D6AMT</td><td>Aggregated measure, sum</td></tr>
<tr><td>FLAGS</td><td>_BIC_ZIO_D7AMT</td><td>Projection_1</td><td>_BIC_ZIO_D7AMT</td><td>Aggregated measure, sum</td></tr>
<tr><td>FLAGS</td><td>ZRWSTRTDATE</td><td>RETAIL_CAL</td><td>ZRWSTRTDATE</td><td>Direct mapping via join</td></tr>
<tr><td>FLAGS</td><td>ZRWENDDATE</td><td>RETAIL_CAL</td><td>ZRWENDDATE</td><td>Direct mapping via join</td></tr>
<tr><td>FLAGS</td><td>STRNUM</td><td>STORE_ATTR_ACTUAL</td><td>STRNUM</td><td>Direct mapping via join</td></tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellspacing="0" cellpadding="4" style="border-collapse:collapse; width:100%; background:#fff;">
<tr style="background:#eee;">
<th>Category</th><th>Measurement</th>
</tr>
<tr><td>Number of Objects/Nodes</td><td>19 (including projections, joins, logical model, and data sources)</td></tr>
<tr><td>Sources Used</td><td>7 Calculation Views referenced as data sources</td></tr>
<tr><td>Joins</td><td>6 join nodes (inner and left outer joins)</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>Aggregation (sum) on measures</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>CASE expressions in calculated attributes</td></tr>
<tr><td>Workflow Complexity</td><td>High; multi-layered joins, projections, calculated fields, and variable-driven filters</td></tr>
<tr><td>Performance Considerations</td><td>Multiple joins, filters, calculated fields, and aggregation; dependent on referenced calculation views and scalar functions</td></tr>
<tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
<tr><td>Dependency Complexity</td><td>High; multiple referenced calculation views and scalar functions</td></tr>
<tr><td>Overall Complexity Score</td><td>High</td></tr>
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
<li>REGION_CODE</li>
<li>REGION_DESC</li>
<li>DISTRICT_CODE</li>
<li>DISTRICT_DESC</li>
<li>CITY</li>
<li>STATE</li>
<li>ZRWSTRTDATE</li>
<li>ZRWENDDATE</li>
<li>CAL_WEEK_NUMBER</li>
<li>PROFIT_CENTER_TEXT</li>
<li>FS_OPEN_DAT</li>
<li>RX_OPEN_DAT</li>
<li>CAL_WEEK</li>
<li>STRNUM</li>
<li>RX_DIVISION_CODE</li>
<li>RX_AREA_CODE</li>
<li>RX_REGION_CODE</li>
<li>RX_DISTRICT_CODE</li>
<li>_B631_S_AMOUNT</li>
<li>_BIC_ZIO_D1AMT</li>
<li>_BIC_ZIO_D2AMT</li>
<li>_BIC_ZIO_D3AMT</li>
<li>_BIC_ZIO_D4AMT</li>
<li>_BIC_ZIO_D5AMT</li>
<li>_BIC_ZIO_D6AMT</li>
<li>_BIC_ZIO_D7AMT</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
