<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse; margin-bottom:20px;">
  <tr>
    <td style="font-weight:bold; width:20%;">Author:</td>
    <td>Ascendion AAVA</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Created On:</td>
    <td>2026-10-12</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Description:</td>
    <td>HANA Calculation View <b>CV_BASE_MD_SRPACT_S4</b> is a base view for ZTSRP_ATTR_ACT, designed to provide store profile attributes for actuals. It is structured as a CUBE-type calculation scenario and is intended for reporting enablement.</td>
  </tr>
</table>

<!-- 1. Overview of Program -->
<p><b>CV_BASE_MD_SRPACT_S4</b> is a HANA Calculation View of type CUBE. Its primary purpose is to expose store profile attributes for actuals, sourced from the underlying table ZTSRP_ATTR_ACT. The view organizes, filters, and aggregates store-related data for reporting and analytical use.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View is composed of a single projection node (<b>Projection_1</b>) sourcing data from the base table <b>ZTSRP_ATTR_ACT</b>. The projection includes all relevant attributes and measures, with a filter applied to the <b>MANDT</b> field for values 120 and 200. The logical model defines output attributes and measures, mapping them directly from the projection. <b>Key Components:</b> The primary components are the data source (<b>ZTSRP_ATTR_ACT</b>), the projection node (<b>Projection_1</b>), and the logical model that maps attributes and measures to the output. No joins, unions, calculated attributes, or calculated measures are present. <b>Dependencies & Performance:</b> The view depends solely on the <b>ZTSRP_ATTR_ACT</b> table. Aggregation is performed for measures using SUM, and a filter is applied to <b>MANDT</b>. No complex processing, joins, or nested logic are present, indicating straightforward performance characteristics.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; background:#f8f8fc; padding:20px; border-radius:10px; max-width:900px;">
  <div style="display:grid; grid-template-columns: 170px 40px 170px 40px 170px; grid-template-rows: 110px 110px; align-items:center; justify-items:center;">
    <div style="grid-column:1; grid-row:1; background:#dfe7fd; border-radius:8px; padding:18px; box-shadow:0 2px 8px #aaa; font-weight:bold;">Data Source:<br>ZTSRP_ATTR_ACT</div>
    <div style="grid-column:2; grid-row:1;">&rarr;</div>
    <div style="grid-column:3; grid-row:1; background:#c1e1c1; border-radius:8px; padding:18px; box-shadow:0 2px 8px #aaa; font-weight:bold;">Projection_1<br>(MANDT Filter:<br>IN [120, 200])</div>
    <div style="grid-column:4; grid-row:1;">&rarr;</div>
    <div style="grid-column:5; grid-row:1; background:#f9e79f; border-radius:8px; padding:18px; box-shadow:0 2px 8px #aaa; font-weight:bold;">Logical Model<br>(Attributes &amp; Measures)</div>
    <div style="grid-column:5; grid-row:2; background:#aed6f1; border-radius:8px; padding:18px; box-shadow:0 2px 8px #aaa; font-weight:bold;">Output View<br>(Aggregation)</div>
    <div style="grid-column:5; grid-row:1 / span 2; border-left:2px solid #bbb; height:120px;"></div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%; border-collapse:collapse; margin-top:20px;">
  <thead>
    <tr style="background:#e8eaf6;">
      <th>Target Object/Field Name</th>
      <th>Target Column Name</th>
      <th>Source Object/Field Name</th>
      <th>Source Column Name</th>
      <th>Remarks</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>Projection_1.MANDT</td><td>MANDT</td><td>ZTSRP_ATTR_ACT.MANDT</td><td>MANDT</td><td>Filter applied: IN (120, 200)</td></tr>
    <tr><td>Projection_1.STRNUM</td><td>STRNUM</td><td>ZTSRP_ATTR_ACT.STRNUM</td><td>STRNUM</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.PRCTR</td><td>PRCTR</td><td>ZTSRP_ATTR_ACT.PRCTR</td><td>PRCTR</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.KOKRS</td><td>KOKRS</td><td>ZTSRP_ATTR_ACT.KOKRS</td><td>KOKRS</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.KOSTL</td><td>KOSTL</td><td>ZTSRP_ATTR_ACT.KOSTL</td><td>KOSTL</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.RX_OPEN_DAT</td><td>RX_OPEN_DAT</td><td>ZTSRP_ATTR_ACT.RX_OPEN_DAT</td><td>RX_OPEN_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.RX_CLOSE_DAT</td><td>RX_CLOSE_DAT</td><td>ZTSRP_ATTR_ACT.RX_CLOSE_DAT</td><td>RX_CLOSE_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.RX_HRS_OPER</td><td>RX_HRS_OPER</td><td>ZTSRP_ATTR_ACT.RX_HRS_OPER</td><td>RX_HRS_OPER</td><td>Aggregation: SUM</td></tr>
    <tr><td>Projection_1.FS_OPEN_DAT</td><td>FS_OPEN_DAT</td><td>ZTSRP_ATTR_ACT.FS_OPEN_DAT</td><td>FS_OPEN_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.FS_CLOSE_DAT</td><td>FS_CLOSE_DAT</td><td>ZTSRP_ATTR_ACT.FS_CLOSE_DAT</td><td>FS_CLOSE_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.FS_HRS_OPER</td><td>FS_HRS_OPER</td><td>ZTSRP_ATTR_ACT.FS_HRS_OPER</td><td>FS_HRS_OPER</td><td>Aggregation: SUM</td></tr>
    <tr><td>Projection_1.REP_MKT_CODE</td><td>REP_MKT_CODE</td><td>ZTSRP_ATTR_ACT.REP_MKT_CODE</td><td>REP_MKT_CODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.REP_MKT_DESC</td><td>REP_MKT_DESC</td><td>ZTSRP_ATTR_ACT.REP_MKT_DESC</td><td>REP_MKT_DESC</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.ADDRESS</td><td>ADDRESS</td><td>ZTSRP_ATTR_ACT.ADDRESS</td><td>ADDRESS</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.CITY</td><td>CITY</td><td>ZTSRP_ATTR_ACT.CITY</td><td>CITY</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.STATE</td><td>STATE</td><td>ZTSRP_ATTR_ACT.STATE</td><td>STATE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.ZIPCODE</td><td>ZIPCODE</td><td>ZTSRP_ATTR_ACT.ZIPCODE</td><td>ZIPCODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.DIVISION_CODE</td><td>DIVISION_CODE</td><td>ZTSRP_ATTR_ACT.DIVISION_CODE</td><td>DIVISION_CODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.DIVISION_DESC</td><td>DIVISION_DESC</td><td>ZTSRP_ATTR_ACT.DIVISION_DESC</td><td>DIVISION_DESC</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.DIVISION_MGR</td><td>DIVISION_MGR</td><td>ZTSRP_ATTR_ACT.DIVISION_MGR</td><td>DIVISION_MGR</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.AREA_CODE</td><td>AREA_CODE</td><td>ZTSRP_ATTR_ACT.AREA_CODE</td><td>AREA_CODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.AREA_DESC</td><td>AREA_DESC</td><td>ZTSRP_ATTR_ACT.AREA_DESC</td><td>AREA_DESC</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.AREA_MGR</td><td>AREA_MGR</td><td>ZTSRP_ATTR_ACT.AREA_MGR</td><td>AREA_MGR</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.REGION_CODE</td><td>REGION_CODE</td><td>ZTSRP_ATTR_ACT.REGION_CODE</td><td>REGION_CODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.REGION_DESC</td><td>REGION_DESC</td><td>ZTSRP_ATTR_ACT.REGION_DESC</td><td>REGION_DESC</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.REGION_MGR</td><td>REGION_MGR</td><td>ZTSRP_ATTR_ACT.REGION_MGR</td><td>REGION_MGR</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.DISTRICT_CODE</td><td>DISTRICT_CODE</td><td>ZTSRP_ATTR_ACT.DISTRICT_CODE</td><td>DISTRICT_CODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.DISTRICT_DESC</td><td>DISTRICT_DESC</td><td>ZTSRP_ATTR_ACT.DISTRICT_DESC</td><td>DISTRICT_DESC</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.ZONE_CODE</td><td>ZONE_CODE</td><td>ZTSRP_ATTR_ACT.ZONE_CODE</td><td>ZONE_CODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.DISTRICT_MGR</td><td>DISTRICT_MGR</td><td>ZTSRP_ATTR_ACT.DISTRICT_MGR</td><td>DISTRICT_MGR</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.ZONE_DESC</td><td>ZONE_DESC</td><td>ZTSRP_ATTR_ACT.ZONE_DESC</td><td>ZONE_DESC</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.MAJOR_REGION_CODE</td><td>MAJOR_REGION_CODE</td><td>ZTSRP_ATTR_ACT.MAJOR_REGION_CODE</td><td>MAJOR_REGION_CODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.MAJOR_REGION</td><td>MAJOR_REGION</td><td>ZTSRP_ATTR_ACT.MAJOR_REGION</td><td>MAJOR_REGION</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.STORE_TYPE</td><td>STORE_TYPE</td><td>ZTSRP_ATTR_ACT.STORE_TYPE</td><td>STORE_TYPE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.STORE_TYPE_DESC</td><td>STORE_TYPE_DESC</td><td>ZTSRP_ATTR_ACT.STORE_TYPE_DESC</td><td>STORE_TYPE_DESC</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.RX_STORE</td><td>RX_STORE</td><td>ZTSRP_ATTR_ACT.RX_STORE</td><td>RX_STORE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.RX_STORE_DESC</td><td>RX_STORE_DESC</td><td>ZTSRP_ATTR_ACT.RX_STORE_DESC</td><td>RX_STORE_DESC</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.DISTRIBUTION_CNTR</td><td>DISTRIBUTION_CNTR</td><td>ZTSRP_ATTR_ACT.DISTRIBUTION_CNTR</td><td>DISTRIBUTION_CNTR</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.DISTRIBUTION_CNTR_DESC</td><td>DISTRIBUTION_CNTR_DESC</td><td>ZTSRP_ATTR_ACT.DISTRIBUTION_CNTR_DESC</td><td>DISTRIBUTION_CNTR_DESC</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.STORE_24_HR</td><td>STORE_24_HR</td><td>ZTSRP_ATTR_ACT.STORE_24_HR</td><td>STORE_24_HR</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.BUDGET_OPEN_DAT</td><td>BUDGET_OPEN_DAT</td><td>ZTSRP_ATTR_ACT.BUDGET_OPEN_DAT</td><td>BUDGET_OPEN_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.BUDGET_CLOSED_DAT</td><td>BUDGET_CLOSED_DAT</td><td>ZTSRP_ATTR_ACT.BUDGET_CLOSED_DAT</td><td>BUDGET_CLOSED_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.BUDGET_RELOC_DAT</td><td>BUDGET_RELOC_DAT</td><td>ZTSRP_ATTR_ACT.BUDGET_RELOC_DAT</td><td>BUDGET_RELOC_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.CONST_OPEN_DAT</td><td>CONST_OPEN_DAT</td><td>ZTSRP_ATTR_ACT.CONST_OPEN_DAT</td><td>CONST_OPEN_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.CONST_CLOSE_DAT</td><td>CONST_CLOSE_DAT</td><td>ZTSRP_ATTR_ACT.CONST_CLOSE_DAT</td><td>CONST_CLOSE_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.CONST_RELO_DAT</td><td>CONST_RELO_DAT</td><td>ZTSRP_ATTR_ACT.CONST_RELO_DAT</td><td>CONST_RELO_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.RELOCATION_DAT</td><td>RELOCATION_DAT</td><td>ZTSRP_ATTR_ACT.RELOCATION_DAT</td><td>RELOCATION_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.EMERG_MKT_IND</td><td>EMERG_MKT_IND</td><td>ZTSRP_ATTR_ACT.EMERG_MKT_IND</td><td>EMERG_MKT_IND</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.BUDGET_EMERG_MKT_IND</td><td>BUDGET_EMERG_MKT_IND</td><td>ZTSRP_ATTR_ACT.BUDGET_EMERG_MKT_IND</td><td>BUDGET_EMERG_MKT_IND</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.COMPANY_CODE</td><td>COMPANY_CODE</td><td>ZTSRP_ATTR_ACT.COMPANY_CODE</td><td>COMPANY_CODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.COMPANY_CODE_DESC</td><td>COMPANY_CODE_DESC</td><td>ZTSRP_ATTR_ACT.COMPANY_CODE_DESC</td><td>COMPANY_CODE_DESC</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.ORIGINAL_FS_OPEN_DAT</td><td>ORIGINAL_FS_OPEN_DAT</td><td>ZTSRP_ATTR_ACT.ORIGINAL_FS_OPEN_DAT</td><td>ORIGINAL_FS_OPEN_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.ORIGINAL_RX_OPEN_DAT</td><td>ORIGINAL_RX_OPEN_DAT</td><td>ZTSRP_ATTR_ACT.ORIGINAL_RX_OPEN_DAT</td><td>ORIGINAL_RX_OPEN_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.GROUP_ONE</td><td>GROUP_ONE</td><td>ZTSRP_ATTR_ACT.GROUP_ONE</td><td>GROUP_ONE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.GROUP_TWO</td><td>GROUP_TWO</td><td>ZTSRP_ATTR_ACT.GROUP_TWO</td><td>GROUP_TWO</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.ARD_SORT_KEY</td><td>ARD_SORT_KEY</td><td>ZTSRP_ATTR_ACT.ARD_SORT_KEY</td><td>ARD_SORT_KEY</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.AREA_COST_CENTER</td><td>AREA_COST_CENTER</td><td>ZTSRP_ATTR_ACT.AREA_COST_CENTER</td><td>AREA_COST_CENTER</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.REGIION_COST_CENTER</td><td>REGIION_COST_CENTER</td><td>ZTSRP_ATTR_ACT.REGIION_COST_CENTER</td><td>REGIION_COST_CENTER</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.COUNTY_CODE</td><td>COUNTY_CODE</td><td>ZTSRP_ATTR_ACT.COUNTY_CODE</td><td>COUNTY_CODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.COUNTY_DESC</td><td>COUNTY_DESC</td><td>ZTSRP_ATTR_ACT.COUNTY_DESC</td><td>COUNTY_DESC</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.RETAIL_SQFT_AMT</td><td>RETAIL_SQFT_AMT</td><td>ZTSRP_ATTR_ACT.RETAIL_SQFT_AMT</td><td>RETAIL_SQFT_AMT</td><td>Aggregation: SUM</td></tr>
    <tr><td>Projection_1.TOTAL_SQFT_AMT</td><td>TOTAL_SQFT_AMT</td><td>ZTSRP_ATTR_ACT.TOTAL_SQFT_AMT</td><td>TOTAL_SQFT_AMT</td><td>Aggregation: SUM</td></tr>
    <tr><td>Projection_1.SQFT_BRACKET_DESC</td><td>SQFT_BRACKET_DESC</td><td>ZTSRP_ATTR_ACT.SQFT_BRACKET_DESC</td><td>SQFT_BRACKET_DESC</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.SQFT_SORT_KEY</td><td>SQFT_SORT_KEY</td><td>ZTSRP_ATTR_ACT.SQFT_SORT_KEY</td><td>SQFT_SORT_KEY</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.ACQUISITION_CODE</td><td>ACQUISITION_CODE</td><td>ZTSRP_ATTR_ACT.ACQUISITION_CODE</td><td>ACQUISITION_CODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.ACQUISITION_DESC</td><td>ACQUISITION_DESC</td><td>ZTSRP_ATTR_ACT.ACQUISITION_DESC</td><td>ACQUISITION_DESC</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.PHOTO_LAB_ADD_DAT</td><td>PHOTO_LAB_ADD_DAT</td><td>ZTSRP_ATTR_ACT.PHOTO_LAB_ADD_DAT</td><td>PHOTO_LAB_ADD_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.PHOTO_LAB_CLOSE_DAT</td><td>PHOTO_LAB_CLOSE_DAT</td><td>ZTSRP_ATTR_ACT.PHOTO_LAB_CLOSE_DAT</td><td>PHOTO_LAB_CLOSE_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.MIN_HRS_IND</td><td>MIN_HRS_IND</td><td>ZTSRP_ATTR_ACT.MIN_HRS_IND</td><td>MIN_HRS_IND</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.CREATEDBY</td><td>CREATEDBY</td><td>ZTSRP_ATTR_ACT.CREATEDBY</td><td>CREATEDBY</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.CREATED_ON</td><td>CREATED_ON</td><td>ZTSRP_ATTR_ACT.CREATED_ON</td><td>CREATED_ON</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.RX_DIVISION_CODE</td><td>RX_DIVISION_CODE</td><td>ZTSRP_ATTR_ACT.RX_DIVISION_CODE</td><td>RX_DIVISION_CODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.RX_AREA_CODE</td><td>RX_AREA_CODE</td><td>ZTSRP_ATTR_ACT.RX_AREA_CODE</td><td>RX_AREA_CODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.RX_REGION_CODE</td><td>RX_REGION_CODE</td><td>ZTSRP_ATTR_ACT.RX_REGION_CODE</td><td>RX_REGION_CODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.RX_DISTRICT_CODE</td><td>RX_DISTRICT_CODE</td><td>ZTSRP_ATTR_ACT.RX_DISTRICT_CODE</td><td>RX_DISTRICT_CODE</td><td>Direct mapping</td></tr>
  </tbody>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%; border-collapse:collapse; margin-top:20px;">
  <tr><td>Number of Objects/Nodes</td><td>2 (Data Source: ZTSRP_ATTR_ACT, Projection_1)</td></tr>
  <tr><td>Sources Used</td><td>ZTSRP_ATTR_ACT</td></tr>
  <tr><td>Joins</td><td>None</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>SUM (RX_HRS_OPER, FS_HRS_OPER, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT)</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>MANDT filter (IN [120, 200])</td></tr>
  <tr><td>Workflow Complexity</td><td>Low complexity, single projection node, direct mapping</td></tr>
  <tr><td>Performance Considerations</td><td>Direct table access, simple filter, aggregation</td></tr>
  <tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single source dependency (ZTSRP_ATTR_ACT)</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>MANDT</li>
  <li>STRNUM</li>
  <li>PRCTR</li>
  <li>KOKRS</li>
  <li>KOSTL</li>
  <li>RX_OPEN_DAT</li>
  <li>RX_CLOSE_DAT</li>
  <li>RX_HRS_OPER (SUM)</li>
  <li>FS_OPEN_DAT</li>
  <li>FS_CLOSE_DAT</li>
  <li>FS_HRS_OPER (SUM)</li>
  <li>REP_MKT_CODE</li>
  <li>REP_MKT_DESC</li>
  <li>ADDRESS</li>
  <li>CITY</li>
  <li>STATE</li>
  <li>ZIPCODE</li>
  <li>DIVISION_CODE</li>
  <li>DIVISION_DESC</li>
  <li>DIVISION_MGR</li>
  <li>AREA_CODE</li>
  <li>AREA_DESC</li>
  <li>AREA_MGR</li>
  <li>REGION_CODE</li>
  <li>REGION_DESC</li>
  <li>REGION_MGR</li>
  <li>DISTRICT_CODE</li>
  <li>DISTRICT_DESC</li>
  <li>ZONE_CODE</li>
  <li>DISTRICT_MGR</li>
  <li>ZONE_DESC</li>
  <li>MAJOR_REGION_CODE</li>
  <li>MAJOR_REGION</li>
  <li>STORE_TYPE</li>
  <li>STORE_TYPE_DESC</li>
  <li>RX_STORE</li>
  <li>RX_STORE_DESC</li>
  <li>DISTRIBUTION_CNTR</li>
  <li>DISTRIBUTION_CNTR_DESC</li>
  <li>STORE_24_HR</li>
  <li>BUDGET_OPEN_DAT</li>
  <li>BUDGET_CLOSED_DAT</li>
  <li>BUDGET_RELOC_DAT</li>
  <li>CONST_OPEN_DAT</li>
  <li>CONST_CLOSE_DAT</li>
  <li>CONST_RELO_DAT</li>
  <li>RELOCATION_DAT</li>
  <li>EMERG_MKT_IND</li>
  <li>BUDGET_EMERG_MKT_IND</li>
  <li>COMPANY_CODE</li>
  <li>COMPANY_CODE_DESC</li>
  <li>ORIGINAL_FS_OPEN_DAT</li>
  <li>ORIGINAL_RX_OPEN_DAT</li>
  <li>GROUP_ONE</li>
  <li>GROUP_TWO</li>
  <li>ARD_SORT_KEY</li>
  <li>AREA_COST_CENTER</li>
  <li>REGIION_COST_CENTER</li>
  <li>COUNTY_CODE</li>
  <li>COUNTY_DESC</li>
  <li>RETAIL_SQFT_AMT (SUM)</li>
  <li>TOTAL_SQFT_AMT (SUM)</li>
  <li>SQFT_BRACKET_DESC</li>
  <li>SQFT_SORT_KEY</li>
  <li>ACQUISITION_CODE</li>
  <li>ACQUISITION_DESC</li>
  <li>PHOTO_LAB_ADD_DAT</li>
  <li>PHOTO_LAB_CLOSE_DAT</li>
  <li>MIN_HRS_IND</li>
  <li>CREATEDBY</li>
  <li>CREATED_ON</li>
  <li>RX_DIVISION_CODE</li>
  <li>RX_AREA_CODE</li>
  <li>RX_REGION_CODE</li>
  <li>RX_DISTRICT_CODE</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
