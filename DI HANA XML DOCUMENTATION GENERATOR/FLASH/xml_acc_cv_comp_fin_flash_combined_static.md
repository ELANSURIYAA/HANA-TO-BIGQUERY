<!-- DOCUMENT HEADER -->
<table>
<tr><td><b>Author:</b></td><td>Ascendion AAVA</td></tr>
<tr><td><b>Created On:</b></td><td>2026-10-07</td></tr>
<tr><td><b>Description:</b></td><td>This HANA XML file defines a Calculation View named <b>CV_COMP_FIN_FLASH_COMBINED_STATIC</b> intended for generating a Weekly Flash Static Report Combined Composite View. It models, aggregates, and transforms financial and sales data across multiple sources, including budget, forecast, actual, and topside adjustment views, with complex union, join, aggregation, and calculated logic for reporting purposes.</td></tr>
</table>

<!-- 1. OVERVIEW OF PROGRAM -->
<p>This object is a <b>Calculation View</b> defined in HANA XML. Its primary purpose is to provide a combined, aggregated, and variance-driven reporting view of weekly financial and sales data. The view integrates multiple sources, applies union and join logic, and computes calculated measures and variances for composite reporting.</p>

<!-- 2. CODE STRUCTURE AND DESIGN -->
<p><b>Structure:</b> The Calculation View consists of a tree-based scenario with multiple projection, aggregation, union, and join nodes. Data sources include several calculation views for budgets, actuals, forecasts, and topside adjustments. Variables and parameters (e.g., <code>IP_WEEK_ENDING_FROM</code>, <code>IP_WEEK_ENDING_TO</code>) are mapped across input nodes. The workflow includes complex unions, aggregations, calculated attributes and measures, filters, and join relationships, culminating in a logical model with output mappings and calculated fields.<br>
<b>Key Components:</b> Major components are the projection nodes (FLASH, FS_BUDGET, SKF_BUDGET, etc.), union node (COMBINED), aggregation nodes (Aggregation_1, TOTAL_ASP, STORE_FLASH), join nodes (Join_4, Join_5, Join_6), calculated attributes and measures, local variables, and a logical model for output. Filters, constant mappings, and calculated expressions are extensively used.<br>
<b>Dependencies & Performance:</b> The view depends on multiple referenced calculation views and scalar functions, with deep variable mappings and complex join/union relationships. Aggregations, conditional logic, calculated fields, and union pruning contribute to processing complexity. Performance-relevant features include aggregation types, join cardinalities, filters, and calculated expressions, all visible in the XML structure.</p>

<!-- 3. DATA FLOW AND PROCESSING LOGIC -->
<div style="width:100%;overflow-x:auto;background:#f9f9f9;padding:18px 0 18px 0;">
<div style="display:grid;grid-template-columns:repeat(7,220px);grid-auto-rows:110px;gap:18px;align-items:center;justify-items:center;">
<!-- Source Nodes -->
<div style="grid-column:1;grid-row:1;background:#e2e6ea;border-radius:8px;padding:12px;border:1px solid #cfd8dc;">CV_COMP_FIN_FLASH_STATIC</div>
<div style="grid-column:2;grid-row:1;background:#e2e6ea;border-radius:8px;padding:12px;border:1px solid #cfd8dc;">CV_COMP_FIN_BUDGET_STATIC</div>
<div style="grid-column:3;grid-row:1;background:#e2e6ea;border-radius:8px;padding:12px;border:1px solid #cfd8dc;">CV_COMP_SKF_BUDGET_STATIC</div>
<div style="grid-column:4;grid-row:1;background:#e2e6ea;border-radius:8px;padding:12px;border:1px solid #cfd8dc;">CV_COMP_FORECAST_MJE_STATIC</div>
<div style="grid-column:5;grid-row:1;background:#e2e6ea;border-radius:8px;padding:12px;border:1px solid #cfd8dc;">CV_COMP_FIN_ACTUAL_STATIC</div>
<div style="grid-column:6;grid-row:1;background:#e2e6ea;border-radius:8px;padding:12px;border:1px solid #cfd8dc;">CV_COMP_SKF_ACTUAL_STATIC</div>
<div style="grid-column:7;grid-row:1;background:#e2e6ea;border-radius:8px;padding:12px;border:1px solid #cfd8dc;">CV_COMP_TOPSIDE_ADJUSTMENTS</div>

<!-- Projection Nodes -->
<div style="grid-column:1;grid-row:2;background:#daeaf3;border-radius:8px;padding:12px;border:1px solid #bbdefb;">FLASH</div>
<div style="grid-column:2;grid-row:2;background:#daeaf3;border-radius:8px;padding:12px;border:1px solid #bbdefb;">FS_BUDGET</div>
<div style="grid-column:3;grid-row:2;background:#daeaf3;border-radius:8px;padding:12px;border:1px solid #bbdefb;">SKF_BUDGET</div>
<div style="grid-column:4;grid-row:2;background:#daeaf3;border-radius:8px;padding:12px;border:1px solid #bbdefb;">FORECAST_MJE</div>
<div style="grid-column:5;grid-row:2;background:#daeaf3;border-radius:8px;padding:12px;border:1px solid #bbdefb;">FIN_LY</div>
<div style="grid-column:6;grid-row:2;background:#daeaf3;border-radius:8px;padding:12px;border:1px solid #bbdefb;">SKF_LY</div>
<div style="grid-column:7;grid-row:2;background:#daeaf3;border-radius:8px;padding:12px;border:1px solid #bbdefb;">FS_TOPSIDE_ADJ</div>
<div style="grid-column:1;grid-row:3;background:#daeaf3;border-radius:8px;padding:12px;border:1px solid #bbdefb;">RX_BUDGET</div>
<div style="grid-column:2;grid-row:3;background:#daeaf3;border-radius:8px;padding:12px;border:1px solid #bbdefb;">RX_TOPSIDE_ADJ</div>

<!-- Union Node -->
<div style="grid-column:4;grid-row:4;background:#ffe0b2;border-radius:8px;padding:12px;border:1px solid #ffcc80;">COMBINED</div>

<!-- Aggregation Nodes -->
<div style="grid-column:4;grid-row:5;background:#c8e6c9;border-radius:8px;padding:12px;border:1px solid #a5d6a7;">Aggregation_1</div>
<div style="grid-column:4;grid-row:6;background:#c8e6c9;border-radius:8px;padding:12px;border:1px solid #a5d6a7;">VARIANCES</div>
<div style="grid-column:3;grid-row:7;background:#c8e6c9;border-radius:8px;padding:12px;border:1px solid #a5d6a7;">CONV_DRUG</div>
<div style="grid-column:3;grid-row:8;background:#c8e6c9;border-radius:8px;padding:12px;border:1px solid #a5d6a7;">TOTAL_ASP</div>
<div style="grid-column:2;grid-row:8;background:#c8e6c9;border-radius:8px;padding:12px;border:1px solid #a5d6a7;">STORE_FLASH</div>

<!-- Join Nodes -->
<div style="grid-column:4;grid-row:9;background:#b2dfdb;border-radius:8px;padding:12px;border:1px solid #80cbc4;">Join_4</div>
<div style="grid-column:4;grid-row:10;background:#b2dfdb;border-radius:8px;padding:12px;border:1px solid #80cbc4;">ADJUSTED_ASP</div>
<div style="grid-column:4;grid-row:11;background:#b2dfdb;border-radius:8px;padding:12px;border:1px solid #80cbc4;">Join_5</div>
<div style="grid-column:4;grid-row:12;background:#b2dfdb;border-radius:8px;padding:12px;border:1px solid #80cbc4;">BUDGET_ALLOCATION</div>
<div style="grid-column:3;grid-row:13;background:#b2dfdb;border-radius:8px;padding:12px;border:1px solid #80cbc4;">EXCLUDE_PREALLOCATED</div>
<div style="grid-column:3;grid-row:14;background:#b2dfdb;border-radius:8px;padding:12px;border:1px solid #80cbc4;">COMP_LEVEL_ALLOCATED_BUDGET</div>
<div style="grid-column:4;grid-row:15;background:#b2dfdb;border-radius:8px;padding:12px;border:1px solid #80cbc4;">Join_6</div>
<div style="grid-column:4;grid-row:16;background:#b2dfdb;border-radius:8px;padding:12px;border:1px solid #80cbc4;">DIFFERENCE_ADJUSTMENT</div>

<!-- Arrows/Connectors -->
<!-- Source to Projections -->
<div style="grid-column:1;grid-row:1/2;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:2;grid-row:1/2;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:3;grid-row:1/2;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:4;grid-row:1/2;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:5;grid-row:1/2;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:6;grid-row:1/2;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:7;grid-row:1/2;justify-self:center;align-self:end;">&#8595;</div>

<!-- Projections to Union -->
<div style="grid-column:1;grid-row:2/4;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:2;grid-row:2/4;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:3;grid-row:2/4;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:4;grid-row:2/4;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:5;grid-row:2/4;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:6;grid-row:2/4;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:7;grid-row:2/4;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:1;grid-row:3/4;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:2;grid-row:3/4;justify-self:center;align-self:end;">&#8595;</div>

<!-- Union to Aggregation -->
<div style="grid-column:4;grid-row:4/5;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:4;grid-row:5/6;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:4;grid-row:6/7;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:3;grid-row:7/8;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:3;grid-row:8/9;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:2;grid-row:8/9;justify-self:center;align-self:end;">&#8595;</div>

<!-- Aggregations to Joins -->
<div style="grid-column:4;grid-row:9/10;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:4;grid-row:10/11;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:4;grid-row:11/12;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:4;grid-row:12/13;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:3;grid-row:13/14;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:3;grid-row:14/15;justify-self:center;align-self:end;">&#8595;</div>
<div style="grid-column:4;grid-row:15/16;justify-self:center;align-self:end;">&#8595;</div>
</div>
</div>

<!-- 4. DATA MAPPING -->
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse:collapse;width:100%;">
<thead>
<tr><th>Target Object/Field Name</th><th>Target Column Name</th><th>Source Object/Field Name</th><th>Source Column Name</th><th>Remarks</th></tr>
</thead>
<tbody>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_RX_BUDGET_FINAL</td><td>Join_6</td><td>RX_BUDGET, CAL_RX_BUDGET_COMP_LEVEL, CAL_RX_BUDGET</td><td>Calculated: IF(IN(PRCTR,'0000502656','0000502657') AND IN(BUDGET_COMP_FLAG,'0','1'), RX_BUDGET - CAL_RX_BUDGET_COMP_LEVEL, CAL_RX_BUDGET)</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_COMP_RX_BUDGET_AMOUNT</td><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_RX_BUDGET_FINAL</td><td>Calculated: IF(BUDGET_COMP_FLAG='1', CAL_RX_BUDGET_FINAL, 0)</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_COMP_FLAG_DESC</td><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_COMP_FLAG</td><td>Calculated: case(CAL_COMP_FLAG,'1','Comp','0','Non-Comp','')</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_EMERG_MKT_IND</td><td>DIFFERENCE_ADJUSTMENT</td><td>EMERG_MKT_IND</td><td>Calculated: if(EMERG_MKT_IND = 'Y','Yes',if(EMERG_MKT_IND = 'N','No', ''))</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>ZRWSTRTDATE</td><td>DIFFERENCE_ADJUSTMENT</td><td>ZRWSTRTDATE_SAP</td><td>Calculated: format(date(ZRWSTRTDATE_SAP),'MM/DD/YYYY')</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>ZRWENDDATE</td><td>DIFFERENCE_ADJUSTMENT</td><td>ZRWENDDATE_SAP</td><td>Calculated: format(date(ZRWENDDATE_SAP),'MM/DD/YYYY')</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>FS_UPD_TIMESTAMP</td><td>DIFFERENCE_ADJUSTMENT</td><td>FS_UPD_TIMESTAMP_SAP</td><td>Calculated: if(isnull(FS_UPD_TIMESTAMP_SAP), '', midstr(STRING(FS_UPD_TIMESTAMP_SAP),5,2) + '/' + midstr(STRING(FS_UPD_TIMESTAMP_SAP),7,2) + '/' + leftstr(STRING(FS_UPD_TIMESTAMP_SAP),4) + ' ' + midstr(STRING(FS_UPD_TIMESTAMP_SAP),9,2) + ':' + midstr(STRING(FS_UPD_TIMESTAMP_SAP),11,2) + ':' + rightstr(STRING(FS_UPD_TIMESTAMP_SAP),2))</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>RX_UPD_TIMESTAMP</td><td>DIFFERENCE_ADJUSTMENT</td><td>RX_UPD_TIMESTAMP_SAP</td><td>Calculated: if(isnull(RX_UPD_TIMESTAMP_SAP), '', midstr(STRING(RX_UPD_TIMESTAMP_SAP),5,2) + '/' + midstr(STRING(RX_UPD_TIMESTAMP_SAP),7,2) + '/' + leftstr(STRING(RX_UPD_TIMESTAMP_SAP),4) + ' ' + midstr(STRING(RX_UPD_TIMESTAMP_SAP),9,2) + ':' + midstr(STRING(RX_UPD_TIMESTAMP_SAP),11,2) + ':' + rightstr(STRING(RX_UPD_TIMESTAMP_SAP),2))</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>FS_OPEN_DAT</td><td>DIFFERENCE_ADJUSTMENT</td><td>FS_OPEN_DAT_SAP</td><td>Calculated: format(date(FS_OPEN_DAT_SAP),'MM/DD/YYYY')</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>RX_OPEN_DAT</td><td>DIFFERENCE_ADJUSTMENT</td><td>RX_OPEN_DAT_SAP</td><td>Calculated: format(date(RX_OPEN_DAT_SAP),'MM/DD/YYYY')</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>FIN_BUDGET_AMOUNT</td><td>BUDGET_ALLOCATION</td><td>FIN_BUDGET_AMOUNT</td><td>Aggregated: sum(FIN_BUDGET_AMOUNT)</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>FS_SALESAMOUNT</td><td>BUDGET_ALLOCATION</td><td>FS_SALESAMOUNT</td><td>Aggregated: sum(FS_SALESAMOUNT)</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>RX_SALESAMOUNT</td><td>BUDGET_ALLOCATION</td><td>RX_SALESAMOUNT</td><td>Aggregated: sum(RX_SALESAMOUNT)</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_RX_BUDGET</td><td>BUDGET_ALLOCATION</td><td>CAL_RX_BUDGET</td><td>Calculated: IF(RX_BUDGET=0 OR ISNULL(RX_BUDGET), round(SKF_BUDGET_QTY*CAL_ASP_ADJ_AMOUNT,2), RX_BUDGET)</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_FS_SALES</td><td>VARIANCES</td><td>FS_SALESAMOUNT, REDUCTIONAMOUNT, EMP_REDUCTIONAMOUNT, CAL_FS_SALES_MJE, SBT</td><td>Calculated: FS_SALESAMOUNT - REDUCTIONAMOUNT - EMP_REDUCTIONAMOUNT + CAL_FS_SALES_MJE + SBT</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_RX_SALES</td><td>VARIANCES</td><td>RX_SALESAMOUNT, CAL_RX_SALES_MJE</td><td>Calculated: RX_SALESAMOUNT + CAL_RX_SALES_MJE</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_SKF_BUD_VAR</td><td>VARIANCES</td><td>CAL_SCRIPTS_90AS3, SKF_BUDGET_QTY</td><td>Calculated: CAL_SCRIPTS_90AS3 - SKF_BUDGET_QTY</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_FS_BUD_VAR</td><td>VARIANCES</td><td>FS_SALESAMOUNT, FIN_BUDGET_AMOUNT</td><td>Calculated: FS_SALESAMOUNT - FIN_BUDGET_AMOUNT</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_FS_FORECAST_VAR</td><td>VARIANCES</td><td>FS_SALESAMOUNT, FIN_FCST_AMOUNT, FS_RX_FLAG</td><td>Calculated: IF(FS_RX_FLAG='FS', FS_SALESAMOUNT - FIN_FCST_AMOUNT, 0)</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_FS_LY_VAR</td><td>VARIANCES</td><td>FS_SALESAMOUNT, FIN_LY_AMOUNT, FS_RX_FLAG</td><td>Calculated: IF(FS_RX_FLAG='FS', FS_SALESAMOUNT - FIN_LY_AMOUNT, 0)</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_RX_BUD_VAR</td><td>VARIANCES</td><td>CAL_RX_SALES, CAL_RX_BUDGET</td><td>Calculated: CAL_RX_SALES - CAL_RX_BUDGET</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_SKF_FORECAST_VAR</td><td>VARIANCES</td><td>CAL_SCRIPTS_90AS3, SKF_FCST_QTY</td><td>Calculated: CAL_SCRIPTS_90AS3 - SKF_FCST_QTY</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_SKF_LY_VAR</td><td>VARIANCES</td><td>CAL_SCRIPTS_90AS3, SKF_LY_QTY</td><td>Calculated: CAL_SCRIPTS_90AS3 - SKF_LY_QTY</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_FS_BUD_CORP_VAR</td><td>VARIANCES</td><td>CAL_FS_SALES, FIN_BUDGET_AMOUNT</td><td>Calculated: CAL_FS_SALES - FIN_BUDGET_AMOUNT</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_FS_FORECAST_CORP_VAR</td><td>VARIANCES</td><td>CAL_FS_SALES, FIN_FCST_AMOUNT, FS_RX_FLAG</td><td>Calculated: IF(FS_RX_FLAG='FS', CAL_FS_SALES - FIN_FCST_AMOUNT, 0)</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_FS_LY_CORP_VAR</td><td>VARIANCES</td><td>CAL_FS_SALES, FIN_LY_AMOUNT, FS_RX_FLAG</td><td>Calculated: IF(FS_RX_FLAG='FS', CAL_FS_SALES - FIN_LY_AMOUNT, 0)</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_RX_FORECAST_VAR</td><td>VARIANCES</td><td>CAL_RX_SALES, FIN_FCST_AMOUNT, FS_RX_FLAG_EXT</td><td>Calculated: IF(FS_RX_FLAG_EXT='RX', CAL_RX_SALES - FIN_FCST_AMOUNT, 0)</td></tr>
<tr><td>DIFFERENCE_ADJUSTMENT</td><td>CAL_RX_LY_VAR</td><td>VARIANCES</td><td>CAL_RX_SALES, FIN_LY_AMOUNT, FS_RX_FLAG_EXT</td><td>Calculated: IF(FS_RX_FLAG_EXT='RX', CAL_RX_SALES - FIN_LY_AMOUNT, 0)</td></tr>
</tbody>
</table>

<!-- 5. COMPLEXITY ANALYSIS -->
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse:collapse;width:100%;">
<tr><td>Number of Objects/Nodes</td><td>28 (including projections, aggregations, unions, joins, filters, logical model)</td></tr>
<tr><td>Sources Used</td><td>9 calculation views (CV_COMP_FIN_FLASH_STATIC, CV_COMP_FIN_BUDGET_STATIC, CV_COMP_SKF_BUDGET_STATIC, CV_COMP_FORECAST_MJE_STATIC, CV_COMP_FIN_ACTUAL_STATIC, CV_COMP_SKF_ACTUAL_STATIC, RX_BUDGET$$$$CV_COMP_FIN_BUDGET_STATIC$$, CV_COMP_TOPSIDE_ADJUSTMENTS, RX_TOPSIDE_ADJ$$$$CV_COMP_TOPSIDE_ADJUSTMENTS$$)</td></tr>
<tr><td>Joins</td><td>4 join nodes (Join_4, Join_5, Join_6, plus joins within projections)</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>Multiple aggregation nodes and aggregationType="sum" and "max" on measures and view attributes</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>Extensive use of IF, CASE, and conditional expressions in calculated fields and measures</td></tr>
<tr><td>Workflow Complexity</td><td>High; multi-level unions, joins, aggregations, calculated fields, variable mappings, and union pruning</td></tr>
<tr><td>Performance Considerations</td><td>Performance features include aggregation types, join cardinalities, filters, calculated expressions, and union pruning. No measured performance provided.</td></tr>
<tr><td>Data Volume Handling</td><td>Aggregation and union nodes suggest handling of large data sets, but no explicit data volume parameters identified.</td></tr>
<tr><td>Dependency Complexity</td><td>Multiple referenced calculation views, scalar functions, and variable mappings across nodes</td></tr>
<tr><td>Overall Complexity Score</td><td>High</td></tr>
</table>

<!-- 6. SENSITIVE AND PRIVACY DATA ASSESSMENT -->
No sensitive data found

<!-- 7. KEY OUTPUTS -->
<ul>
<li>CAL_RX_BUDGET_FINAL</li>
<li>CAL_COMP_RX_BUDGET_AMOUNT</li>
<li>CAL_COMP_FLAG_DESC</li>
<li>CAL_EMERG_MKT_IND</li>
<li>ZRWSTRTDATE</li>
<li>ZRWENDDATE</li>
<li>FS_UPD_TIMESTAMP</li>
<li>RX_UPD_TIMESTAMP</li>
<li>FS_OPEN_DAT</li>
<li>RX_OPEN_DAT</li>
<li>FIN_BUDGET_AMOUNT</li>
<li>FS_SALESAMOUNT</li>
<li>RX_SALESAMOUNT</li>
<li>CAL_RX_BUDGET</li>
<li>CAL_FS_SALES</li>
<li>CAL_RX_SALES</li>
<li>CAL_SKF_BUD_VAR</li>
<li>CAL_FS_BUD_VAR</li>
<li>CAL_FS_FORECAST_VAR</li>
<li>CAL_FS_LY_VAR</li>
<li>CAL_RX_BUD_VAR</li>
<li>CAL_SKF_FORECAST_VAR</li>
<li>CAL_SKF_LY_VAR</li>
<li>CAL_FS_BUD_CORP_VAR</li>
<li>CAL_FS_FORECAST_CORP_VAR</li>
<li>CAL_FS_LY_CORP_VAR</li>
<li>CAL_RX_FORECAST_VAR</li>
<li>CAL_RX_LY_VAR</li>
</ul>

<!-- 8. API COST CALCULATIONS -->
API COST : 0.0000 USD
