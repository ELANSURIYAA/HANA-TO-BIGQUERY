<!-- DOCUMENT HEADER -->
<div style="border-bottom:2px solid #888;padding-bottom:8px;margin-bottom:20px;">
  <b>Author:</b> Ascendion AAVA<br/>
  <b>Created On:</b> 2026-10-12<br/>
  <b>Description:</b> Calculation View <b>CV_BASE_MD_SRPACT_S4</b> serves as a base view for the object ZTSRP_ATTR_ACT, providing store profile attributes for actuals. The view is structured for reporting enablement and outputs a cube-type aggregation scenario.
</div>

<!-- 1. Overview of Program -->
<div style="margin-bottom:20px;">
  <b>Overview of Program:</b><br/>
  This HANA XML object is a Calculation View configured as a CUBE aggregation scenario. Its primary purpose is to expose store profile attributes for actuals from the base table ZTSRP_ATTR_ACT. The view performs projection and aggregation of store-related fields for reporting.
</div>

<!-- 2. Code Structure and Design -->
<div style="margin-bottom:20px;">
  <b>Structure:</b> The Calculation View consists of a single projection node (Projection_1) sourcing data from the data base table ZTSRP_ATTR_ACT. The view defines a comprehensive set of attributes and measures, mapping directly from the source table, with a filter applied to the MANDT field. No calculated fields, joins, or unions are present; the output is structured for aggregation.<br/>
  <b>Key Components:</b> The major components are the Projection_1 node, the ZTSRP_ATTR_ACT data source, mapped attributes and measures, a filter on MANDT, and the logical model defining output fields. The view is designed for reporting, with all attributes and measures mapped from the source.<br/>
  <b>Dependencies & Performance:</b> The view depends on the ZTSRP_ATTR_ACT table as its sole source. No joins, unions, or nested processing are implemented. Aggregation is performed on select measures. The filter on MANDT may impact performance by reducing data volume. No temporary or cached data processing is present.
</div>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;background:#f9f9f9;padding:12px;border-radius:8px;margin-bottom:20px;">
  <style>
    .workflow-grid {
      display: grid;
      grid-template-columns: 180px 40px 180px 40px 180px;
      grid-auto-rows: 60px;
      align-items: center;
      justify-items: center;
      gap: 8px;
      font-family: Arial, sans-serif;
    }
    .workflow-box {
      background: #e6e6fa;
      border: 1px solid #bbb;
      border-radius: 8px;
      box-shadow: 1px 1px 6px #ddd;
      width: 170px;
      height: 50px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: bold;
      font-size: 15px;
    }
    .workflow-arrow {
      font-size: 28px;
      color: #888;
      width: 40px;
      text-align: center;
    }
  </style>
  <div class="workflow-grid">
    <div class="workflow-box" style="grid-column:1;grid-row:1;">ZTSRP_ATTR_ACT<br/><span style="font-size:12px;font-weight:normal;">(Data Source)</span></div>
    <div class="workflow-arrow" style="grid-column:2;grid-row:1;">→</div>
    <div class="workflow-box" style="grid-column:3;grid-row:1;">Projection_1<br/><span style="font-size:12px;font-weight:normal;">(Projection Node)</span></div>
    <div class="workflow-arrow" style="grid-column:4;grid-row:1;">→</div>
    <div class="workflow-box" style="grid-column:5;grid-row:1;">Output<br/><span style="font-size:12px;font-weight:normal;">(Aggregation)</span></div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellspacing="0" cellpadding="6" style="width:100%;border-collapse:collapse;margin-bottom:20px;">
<thead style="background:#e6e6fa;">
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
<tr><td>Projection_1.RX_HRS_OPER</td><td>RX_HRS_OPER</td><td>ZTSRP_ATTR_ACT.RX_HRS_OPER</td><td>RX_HRS_OPER</td><td>Aggregated: SUM</td></tr>
<tr><td>Projection_1.FS_OPEN_DAT</td><td>FS_OPEN_DAT</td><td>ZTSRP_ATTR_ACT.FS_OPEN_DAT</td><td>FS_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.FS_CLOSE_DAT</td><td>FS_CLOSE_DAT</td><td>ZTSRP_ATTR_ACT.FS_CLOSE_DAT</td><td>FS_CLOSE_DAT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.FS_HRS_OPER</td><td>FS_HRS_OPER</td><td>ZTSRP_ATTR_ACT.FS_HRS_OPER</td><td>FS_HRS_OPER</td><td>Aggregated: SUM</td></tr>
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
<tr><td>Projection_1.RETAIL_SQFT_AMT</td><td>RETAIL_SQFT_AMT</td><td>ZTSRP_ATTR_ACT.RETAIL_SQFT_AMT</td><td>RETAIL_SQFT_AMT</td><td>Aggregated: SUM</td></tr>
<tr><td>Projection_1.TOTAL_SQFT_AMT</td><td>TOTAL_SQFT_AMT</td><td>ZTSRP_ATTR_ACT.TOTAL_SQFT_AMT</td><td>TOTAL_SQFT_AMT</td><td>Aggregated: SUM</td></tr>
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
<table border="1" cellspacing="0" cellpadding="6" style="width:100%;border-collapse:collapse;margin-bottom:20px;">
<thead style="background:#e6e6fa;">
<tr><th>Category</th><th>Measurement</th></tr>
</thead>
<tbody>
<tr><td>Number of Objects/Nodes</td><td>3 (Calculation View, Projection_1, Data Source ZTSRP_ATTR_ACT)</td></tr>
<tr><td>Sources Used</td><td>ZTSRP_ATTR_ACT (Data Base Table)</td></tr>
<tr><td>Joins</td><td>None identified</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>SUM on RX_HRS_OPER, FS_HRS_OPER, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>Filter on MANDT (IN 120, 200)</td></tr>
<tr><td>Workflow Complexity</td><td>Simple linear workflow: Source → Projection → Output</td></tr>
<tr><td>Performance Considerations</td><td>Single source, filter on MANDT, aggregation on measures</td></tr>
<tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
<tr><td>Dependency Complexity</td><td>Single dependency (ZTSRP_ATTR_ACT)</td></tr>
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
