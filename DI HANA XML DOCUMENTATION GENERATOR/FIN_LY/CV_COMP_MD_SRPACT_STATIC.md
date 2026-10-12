<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:8px;margin-bottom:16px">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> 2026-10-12<br>
  <b>Description:</b> This HANA XML object defines a Calculation View named <b>CV_COMP_MD_SRPACT_STATIC</b>, serving as a wrapper view on a snapshot table for store profile attributes actuals. It exposes store-related attributes and measures, with direct mapping from a CDS artifact source table.
</div>

<!-- 1. Overview of Program -->
<p>
This object is a Calculation View of type <b>CUBE</b> defined in HANA XML. Its primary purpose is to present store profile attributes and actuals by projecting data from a snapshot table CDS artifact. The view performs direct attribute and measure mapping without additional calculation or aggregation logic beyond simple summations.
</p>

<!-- 2. Code Structure and Design -->
<p>
<b>Structure:</b> The Calculation View consists of a single projection node (<b>Projection_1</b>) that sources all fields from the CDS artifact <b>TBL_WSS_SRP_ATTR_ACT</b>. The structure includes mapped attributes and measures, logical model definitions, and output aggregation settings. <b>Key Components:</b> Major components include the data source (<b>TBL_WSS_SRP_ATTR_ACT</b>), projection node (<b>Projection_1</b>), mapped attributes, base measures with sum aggregation, and logical model output. <b>Dependencies & Performance:</b> The view depends on the CDS artifact <b>CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT</b> and utilizes only projection and aggregation nodes, with no joins, unions, or calculated fields. Performance considerations are minimal due to the direct mapping and absence of complex processing logic.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;background:#f8f9fa;padding:18px;border-radius:8px;max-width:100vw">
  <style>
    .workflow-grid {
      display: grid;
      grid-template-columns: 180px 40px 180px 40px 180px;
      grid-auto-rows: 80px;
      align-items: center;
      justify-items: center;
      gap: 12px;
    }
    .workflow-box {
      background: #e3e9f3;
      border: 1px solid #b6c3d6;
      border-radius: 7px;
      box-shadow: 0 1px 3px #d3dbe3;
      padding: 14px 18px;
      font-family: Arial, sans-serif;
      font-size: 15px;
      text-align: center;
      width: 160px;
    }
    .workflow-arrow {
      font-size: 24px;
      color: #6b7a8f;
      text-align: center;
      user-select: none;
    }
  </style>
  <div class="workflow-grid">
    <div class="workflow-box" style="grid-column:1;grid-row:1">CDS Artifact<br/>TBL_WSS_SRP_ATTR_ACT</div>
    <div class="workflow-arrow" style="grid-column:2;grid-row:1">&#8594;</div>
    <div class="workflow-box" style="grid-column:3;grid-row:1">Projection Node<br/>Projection_1</div>
    <div class="workflow-arrow" style="grid-column:4;grid-row:1">&#8594;</div>
    <div class="workflow-box" style="grid-column:5;grid-row:1">Calculation View<br/>CV_COMP_MD_SRPACT_STATIC<br/>Output</div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;background:#fcfcfc">
<thead style="background:#e2e6ea">
<tr>
<th>Target Object/Field Name</th>
<th>Target Column Name</th>
<th>Source Object/Field Name</th>
<th>Source Column Name</th>
<th>Remarks</th>
</tr>
</thead>
<tbody>
<tr><td>MANDT</td><td>MANDT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>MANDT</td><td>Direct mapping</td></tr>
<tr><td>STRNUM</td><td>STRNUM</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>STRNUM</td><td>Direct mapping</td></tr>
<tr><td>PRCTR</td><td>PRCTR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>PRCTR</td><td>Direct mapping</td></tr>
<tr><td>KOKRS</td><td>KOKRS</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>KOKRS</td><td>Direct mapping</td></tr>
<tr><td>KOSTL</td><td>KOSTL</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>KOSTL</td><td>Direct mapping</td></tr>
<tr><td>RX_OPEN_DAT</td><td>RX_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>RX_CLOSE_DAT</td><td>RX_CLOSE_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_CLOSE_DAT</td><td>Direct mapping</td></tr>
<tr><td>RX_HRS_OPER</td><td>RX_HRS_OPER</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_HRS_OPER</td><td>Sum aggregation</td></tr>
<tr><td>FS_OPEN_DAT</td><td>FS_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>FS_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>FS_CLOSE_DAT</td><td>FS_CLOSE_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>FS_CLOSE_DAT</td><td>Direct mapping</td></tr>
<tr><td>FS_HRS_OPER</td><td>FS_HRS_OPER</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>FS_HRS_OPER</td><td>Sum aggregation</td></tr>
<tr><td>REP_MKT_CODE</td><td>REP_MKT_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>REP_MKT_CODE</td><td>Direct mapping</td></tr>
<tr><td>REP_MKT_DESC</td><td>REP_MKT_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>REP_MKT_DESC</td><td>Direct mapping</td></tr>
<tr><td>ADDRESS</td><td>ADDRESS</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ADDRESS</td><td>Direct mapping</td></tr>
<tr><td>CITY</td><td>CITY</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>CITY</td><td>Direct mapping</td></tr>
<tr><td>STATE</td><td>STATE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>STATE</td><td>Direct mapping</td></tr>
<tr><td>ZIPCODE</td><td>ZIPCODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ZIPCODE</td><td>Direct mapping</td></tr>
<tr><td>DIVISION_CODE</td><td>DIVISION_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DIVISION_CODE</td><td>Direct mapping</td></tr>
<tr><td>DIVISION_DESC</td><td>DIVISION_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DIVISION_DESC</td><td>Direct mapping</td></tr>
<tr><td>DIVISION_MGR</td><td>DIVISION_MGR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DIVISION_MGR</td><td>Direct mapping</td></tr>
<tr><td>AREA_CODE</td><td>AREA_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>AREA_CODE</td><td>Direct mapping</td></tr>
<tr><td>AREA_DESC</td><td>AREA_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>AREA_DESC</td><td>Direct mapping</td></tr>
<tr><td>AREA_MGR</td><td>AREA_MGR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>AREA_MGR</td><td>Direct mapping</td></tr>
<tr><td>REGION_CODE</td><td>REGION_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>REGION_CODE</td><td>Direct mapping</td></tr>
<tr><td>REGION_DESC</td><td>REGION_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>REGION_DESC</td><td>Direct mapping</td></tr>
<tr><td>REGION_MGR</td><td>REGION_MGR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>REGION_MGR</td><td>Direct mapping</td></tr>
<tr><td>DISTRICT_CODE</td><td>DISTRICT_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRICT_CODE</td><td>Direct mapping</td></tr>
<tr><td>DISTRICT_DESC</td><td>DISTRICT_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRICT_DESC</td><td>Direct mapping</td></tr>
<tr><td>ZONE_CODE</td><td>ZONE_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ZONE_CODE</td><td>Direct mapping</td></tr>
<tr><td>DISTRICT_MGR</td><td>DISTRICT_MGR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRICT_MGR</td><td>Direct mapping</td></tr>
<tr><td>ZONE_DESC</td><td>ZONE_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ZONE_DESC</td><td>Direct mapping</td></tr>
<tr><td>MAJOR_REGION_CODE</td><td>MAJOR_REGION_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>MAJOR_REGION_CODE</td><td>Direct mapping</td></tr>
<tr><td>MAJOR_REGION</td><td>MAJOR_REGION</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>MAJOR_REGION</td><td>Direct mapping</td></tr>
<tr><td>STORE_TYPE</td><td>STORE_TYPE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>STORE_TYPE</td><td>Direct mapping</td></tr>
<tr><td>STORE_TYPE_DESC</td><td>STORE_TYPE_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>STORE_TYPE_DESC</td><td>Direct mapping</td></tr>
<tr><td>RX_STORE</td><td>RX_STORE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_STORE</td><td>Sum aggregation</td></tr>
<tr><td>RX_STORE_DESC</td><td>RX_STORE_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_STORE_DESC</td><td>Direct mapping</td></tr>
<tr><td>DISTRIBUTION_CNTR</td><td>DISTRIBUTION_CNTR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRIBUTION_CNTR</td><td>Direct mapping</td></tr>
<tr><td>DISTRIBUTION_CNTR_DESC</td><td>DISTRIBUTION_CNTR_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRIBUTION_CNTR_DESC</td><td>Direct mapping</td></tr>
<tr><td>STORE_24_HR</td><td>STORE_24_HR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>STORE_24_HR</td><td>Direct mapping</td></tr>
<tr><td>BUDGET_OPEN_DAT</td><td>BUDGET_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>BUDGET_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>BUDGET_CLOSED_DAT</td><td>BUDGET_CLOSED_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>BUDGET_CLOSED_DAT</td><td>Direct mapping</td></tr>
<tr><td>BUDGET_RELOC_DAT</td><td>BUDGET_RELOC_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>BUDGET_RELOC_DAT</td><td>Direct mapping</td></tr>
<tr><td>CONST_OPEN_DAT</td><td>CONST_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>CONST_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>CONST_CLOSE_DAT</td><td>CONST_CLOSE_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>CONST_CLOSE_DAT</td><td>Direct mapping</td></tr>
<tr><td>CONST_RELO_DAT</td><td>CONST_RELO_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>CONST_RELO_DAT</td><td>Direct mapping</td></tr>
<tr><td>RELOCATION_DAT</td><td>RELOCATION_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RELOCATION_DAT</td><td>Direct mapping</td></tr>
<tr><td>EMERG_MKT_IND</td><td>EMERG_MKT_IND</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>EMERG_MKT_IND</td><td>Direct mapping</td></tr>
<tr><td>BUDGET_EMERG_MKT_IND</td><td>BUDGET_EMERG_MKT_IND</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>BUDGET_EMERG_MKT_IND</td><td>Direct mapping</td></tr>
<tr><td>COMPANY_CODE</td><td>COMPANY_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>COMPANY_CODE</td><td>Direct mapping</td></tr>
<tr><td>COMPANY_CODE_DESC</td><td>COMPANY_CODE_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>COMPANY_CODE_DESC</td><td>Direct mapping</td></tr>
<tr><td>ORIGINAL_FS_OPEN_DAT</td><td>ORIGINAL_FS_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ORIGINAL_FS_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>ORIGINAL_RX_OPEN_DAT</td><td>ORIGINAL_RX_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ORIGINAL_RX_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>GROUP_ONE</td><td>GROUP_ONE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>GROUP_ONE</td><td>Direct mapping</td></tr>
<tr><td>GROUP_TWO</td><td>GROUP_TWO</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>GROUP_TWO</td><td>Direct mapping</td></tr>
<tr><td>ARD_SORT_KEY</td><td>ARD_SORT_KEY</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ARD_SORT_KEY</td><td>Direct mapping</td></tr>
<tr><td>AREA_COST_CENTER</td><td>AREA_COST_CENTER</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>AREA_COST_CENTER</td><td>Direct mapping</td></tr>
<tr><td>REGIION_COST_CENTER</td><td>REGIION_COST_CENTER</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>REGIION_COST_CENTER</td><td>Direct mapping</td></tr>
<tr><td>COUNTY_CODE</td><td>COUNTY_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>COUNTY_CODE</td><td>Direct mapping</td></tr>
<tr><td>COUNTY_DESC</td><td>COUNTY_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>COUNTY_DESC</td><td>Direct mapping</td></tr>
<tr><td>RETAIL_SQFT_AMT</td><td>RETAIL_SQFT_AMT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RETAIL_SQFT_AMT</td><td>Sum aggregation</td></tr>
<tr><td>TOTAL_SQFT_AMT</td><td>TOTAL_SQFT_AMT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>TOTAL_SQFT_AMT</td><td>Sum aggregation</td></tr>
<tr><td>SQFT_BRACKET_DESC</td><td>SQFT_BRACKET_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>SQFT_BRACKET_DESC</td><td>Direct mapping</td></tr>
<tr><td>SQFT_SORT_KEY</td><td>SQFT_SORT_KEY</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>SQFT_SORT_KEY</td><td>Direct mapping</td></tr>
<tr><td>ACQUISITION_CODE</td><td>ACQUISITION_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ACQUISITION_CODE</td><td>Direct mapping</td></tr>
<tr><td>ACQUISITION_DESC</td><td>ACQUISITION_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ACQUISITION_DESC</td><td>Direct mapping</td></tr>
<tr><td>PHOTO_LAB_ADD_DAT</td><td>PHOTO_LAB_ADD_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>PHOTO_LAB_ADD_DAT</td><td>Direct mapping</td></tr>
<tr><td>PHOTO_LAB_CLOSE_DAT</td><td>PHOTO_LAB_CLOSE_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>PHOTO_LAB_CLOSE_DAT</td><td>Direct mapping</td></tr>
<tr><td>MIN_HRS_IND</td><td>MIN_HRS_IND</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>MIN_HRS_IND</td><td>Direct mapping</td></tr>
<tr><td>CREATEDBY</td><td>CREATEDBY</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>CREATEDBY</td><td>Direct mapping</td></tr>
<tr><td>CREATED_ON</td><td>CREATED_ON</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>CREATED_ON</td><td>Direct mapping</td></tr>
<tr><td>RX_DIVISION_CODE</td><td>RX_DIVISION_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_DIVISION_CODE</td><td>Direct mapping</td></tr>
<tr><td>RX_AREA_CODE</td><td>RX_AREA_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_AREA_CODE</td><td>Direct mapping</td></tr>
<tr><td>RX_REGION_CODE</td><td>RX_REGION_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_REGION_CODE</td><td>Direct mapping</td></tr>
<tr><td>RX_DISTRICT_CODE</td><td>RX_DISTRICT_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_DISTRICT_CODE</td><td>Direct mapping</td></tr>
</tbody>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;background:#fcfcfc">
<thead style="background:#e2e6ea">
<tr><th>Category</th><th>Measurement</th></tr>
</thead>
<tbody>
<tr><td>Number of Objects/Nodes</td><td>3 (Calculation View, Projection_1, DataSource)</td></tr>
<tr><td>Sources Used</td><td>1 (TBL_WSS_SRP_ATTR_ACT)</td></tr>
<tr><td>Joins</td><td>None identified</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>Sum aggregation on RX_HRS_OPER, FS_HRS_OPER, RX_STORE, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>None identified</td></tr>
<tr><td>Workflow Complexity</td><td>Simple single projection and output</td></tr>
<tr><td>Performance Considerations</td><td>Direct mapping, minimal processing, no joins or calculated fields</td></tr>
<tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
<tr><td>Dependency Complexity</td><td>Single CDS artifact dependency</td></tr>
<tr><td>Overall Complexity Score</td><td>Low</td></tr>
</tbody>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>All mapped store profile attribute fields as defined in Projection_1</li>
  <li>Aggregated measures: RX_HRS_OPER, FS_HRS_OPER, RX_STORE, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT</li>
  <li>Direct output from Calculation View CV_COMP_MD_SRPACT_STATIC</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
