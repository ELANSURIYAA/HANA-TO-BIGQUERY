<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc; padding-bottom:8px; margin-bottom:18px;">
  <b>Author:</b> Ascendion AAVA<br/>
  <b>Created On:</b> {{CURRENT_DATE}}<br/>
  <b>Description:</b> Base View for ZTSRP_ATTR_ACT - Store Profile Attribute for Actuals. This HANA Calculation View provides a structured aggregation of store profile attributes and related operational data, primarily sourced from the ZTSRP_ATTR_ACT base table.
</div>

<!-- 1. Overview of Program -->
<div style="margin-bottom:18px;">
  <b>Overview of Program:</b><br/>
  This object is a HANA Calculation View of type CUBE, designed to model and aggregate store profile attributes for actuals. It sources data from the ZTSRP_ATTR_ACT data base table and exposes a comprehensive set of attributes and measures for reporting and analysis. The view applies attribute filtering and aggregation logic to produce structured outputs.
</div>

<!-- 2. Code Structure and Design -->
<div style="margin-bottom:18px;">
  <b>Structure:</b> The Calculation View is structured as a TREE_BASED scenario with a single Projection node (Projection_1) sourcing all fields from the ZTSRP_ATTR_ACT data base table. The Projection node defines view attributes, applies a filter on the MANDT field, and maps all source fields to output fields. The logical model specifies attributes, measures, aggregation types, and descriptions, with no calculated or restricted measures present.<br/>
  <b>Key Components:</b> The main components are the ZTSRP_ATTR_ACT data source, the Projection_1 node, view attributes, base measures (RX_HRS_OPER, FS_HRS_OPER, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT), attribute filters, and the logical model specifying output structure. There are no joins, unions, calculated fields, or variable mappings beyond the direct mapping and aggregation.<br/>
  <b>Dependencies & Performance:</b> The view depends solely on the ZTSRP_ATTR_ACT base table from the database. Performance-relevant characteristics include attribute filtering on MANDT, sum aggregation of measures, and direct mapping of fields. No joins, calculated expressions, or complex processing logic are present, indicating a low-complexity structure.
</div>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; background:#f9f9fa; border:1px solid #e0e0e0; border-radius:8px; padding:16px; margin-bottom:18px;">
  <style>
    .workflow-grid {
      display: grid;
      grid-template-columns: 120px 40px 120px 40px 120px;
      grid-template-rows: 60px 60px 60px;
      align-items: center;
      justify-items: center;
      gap: 10px;
      min-width: 600px;
      min-height: 200px;
    }
    .workflow-box {
      background: #e8eef7;
      border: 1px solid #b4c7e7;
      border-radius: 6px;
      padding: 10px 14px;
      font-size: 15px;
      font-family: Arial, sans-serif;
      text-align: center;
      box-shadow: 1px 1px 3px #ccc;
      min-width: 100px;
      min-height: 40px;
      max-width: 140px;
      overflow-x: auto;
    }
    .workflow-arrow {
      font-size: 22px;
      color: #8a99b2;
      font-weight: bold;
      margin: 0;
    }
  </style>
  <div class="workflow-grid">
    <div class="workflow-box" style="grid-column:1; grid-row:2;">ZTSRP_ATTR_ACT<br/><small>Data Base Table</small></div>
    <div class="workflow-arrow" style="grid-column:2; grid-row:2;">&#8594;</div>
    <div class="workflow-box" style="grid-column:3; grid-row:2;">Projection_1<br/><small>Attribute Mapping & Filter</small></div>
    <div class="workflow-arrow" style="grid-column:4; grid-row:2;">&#8594;</div>
    <div class="workflow-box" style="grid-column:5; grid-row:2;">Output<br/><small>Logical Model<br/>Attributes & Measures</small></div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="5" cellspacing="0" style="border-collapse:collapse; margin-bottom:18px; width:100%;">
  <thead style="background:#e8eef7;">
    <tr>
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
    <tr><td>Projection_1.RX_HRS_OPER</td><td>RX_HRS_OPER</td><td>ZTSRP_ATTR_ACT.RX_HRS_OPER</td><td>RX_HRS_OPER</td><td>Sum aggregation</td></tr>
    <tr><td>Projection_1.FS_OPEN_DAT</td><td>FS_OPEN_DAT</td><td>ZTSRP_ATTR_ACT.FS_OPEN_DAT</td><td>FS_OPEN_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.FS_CLOSE_DAT</td><td>FS_CLOSE_DAT</td><td>ZTSRP_ATTR_ACT.FS_CLOSE_DAT</td><td>FS_CLOSE_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.FS_HRS_OPER</td><td>FS_HRS_OPER</td><td>ZTSRP_ATTR_ACT.FS_HRS_OPER</td><td>FS_HRS_OPER</td><td>Sum aggregation</td></tr>
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
    <tr><td>Projection_1.RETAIL_SQFT_AMT</td><td>RETAIL_SQFT_AMT</td><td>ZTSRP_ATTR_ACT.RETAIL_SQFT_AMT</td><td>RETAIL_SQFT_AMT</td><td>Sum aggregation</td></tr>
    <tr><td>Projection_1.TOTAL_SQFT_AMT</td><td>TOTAL_SQFT_AMT</td><td>ZTSRP_ATTR_ACT.TOTAL_SQFT_AMT</td><td>TOTAL_SQFT_AMT</td><td>Sum aggregation</td></tr>
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
<table border="1" cellpadding="5" cellspacing="0" style="border-collapse:collapse; margin-bottom:18px; width:100%;">
  <thead style="background:#e8eef7;">
    <tr><th>Category</th><th>Measurement</th></tr>
  </thead>
  <tbody>
    <tr><td>Number of Objects/Nodes</td><td>3 (Scenario, Projection_1, Output)</td></tr>
    <tr><td>Sources Used</td><td>ZTSRP_ATTR_ACT (data base table)</td></tr>
    <tr><td>Joins</td><td>None</td></tr>
    <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
    <tr><td>Aggregate Functions</td><td>Sum aggregation on RX_HRS_OPER, FS_HRS_OPER, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT</td></tr>
    <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
    <tr><td>Conditional Logic</td><td>Filter on MANDT (IN 120, 200)</td></tr>
    <tr><td>Workflow Complexity</td><td>Simple linear flow: Source → Projection → Output</td></tr>
    <tr><td>Performance Considerations</td><td>Direct mapping, attribute filtering, and aggregation; no joins or calculated fields</td></tr>
    <tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
    <tr><td>Dependency Complexity</td><td>Single dependency on ZTSRP_ATTR_ACT table</td></tr>
    <tr><td>Overall Complexity Score</td><td>Low</td></tr>
  </tbody>
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
  <li>RX_HRS_OPER (aggregated)</li>
  <li>FS_OPEN_DAT</li>
  <li>FS_CLOSE_DAT</li>
  <li>FS_HRS_OPER (aggregated)</li>
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
  <li>RETAIL_SQFT_AMT (aggregated)</li>
  <li>TOTAL_SQFT_AMT (aggregated)</li>
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
