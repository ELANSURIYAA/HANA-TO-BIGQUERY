<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:8px;margin-bottom:16px">
<b>Author:</b> Ascendion AAVA<br>
<b>Created On:</b> 2026-10-12<br>
<b>Description:</b> Calculation View 'CV_COMP_MD_SRPACT_STATIC' is a wrapper view on the snapshot table for Store Profile - Attributes Actuals. It provides a structured aggregation of store profile data based on the underlying CDS artifact table.
</div>

<!-- 1. Overview of Program -->
<p>
The object is a Calculation View defined in HANA XML. Its primary purpose is to aggregate and expose store profile attributes and actuals from the underlying CDS artifact table. The main processing involves projecting all relevant fields from the source table and aggregating measure fields, enabling reporting and analysis of store profile data.
</p>

<!-- 2. Code Structure and Design -->
<p>
<b>Structure:</b> The Calculation View consists of a single projection node ('Projection_1') that sources data from the CDS artifact table 'CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT'. The projection exposes all view attributes and maps them directly from the source. The logical model defines both attributes and measures, with aggregation functions applied to measure fields. No joins, unions, filters, calculated fields, or variables are present.<br>
<b>Key Components:</b> The major components include the data source (CDS artifact table), the projection node, logical model attributes and measures, and output aggregation. Measures such as RX_HRS_OPER, FS_HRS_OPER, RX_STORE, RETAIL_SQFT_AMT, and TOTAL_SQFT_AMT are aggregated using SUM.<br>
<b>Dependencies & Performance:</b> The Calculation View depends on the CDS artifact 'CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT' as its sole source. No joins or complex processing logic are present. Performance is expected to be straightforward, as the view applies direct mapping and aggregation without additional transformations or nested processing.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;background:#f9f9f9;padding:16px;border-radius:8px;max-width:100%;">
<style>
.workflow-grid {
  display: grid;
  grid-template-columns: 180px 40px 180px 40px 180px;
  grid-auto-rows: 70px;
  align-items: center;
  justify-items: center;
}
.workflow-box {
  background: #e3eaff;
  border: 1px solid #b3c6e7;
  border-radius: 8px;
  padding: 12px 18px;
  font-size: 15px;
  font-weight: 500;
  box-shadow: 0 2px 5px #d1d5e5;
  min-width: 160px;
  text-align: center;
}
.arrow {
  font-size: 28px;
  color: #7c8db0;
}
</style>
<div class="workflow-grid">
  <div class="workflow-box" style="grid-column:1;grid-row:1">CDS Artifact<br>CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT</div>
  <div class="arrow" style="grid-column:2;grid-row:1">&#8594;</div>
  <div class="workflow-box" style="grid-column:3;grid-row:1">Projection_1<br>(All Attributes & Measures)</div>
  <div class="arrow" style="grid-column:4;grid-row:1">&#8594;</div>
  <div class="workflow-box" style="grid-column:5;grid-row:1">Calculation View Output<br>(Aggregated & Projected Fields)</div>
</div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;background:#fcfcfc">
<tr style="background:#e3eaff">
<th>Target Object/Field Name</th>
<th>Target Column Name</th>
<th>Source Object/Field Name</th>
<th>Source Column Name</th>
<th>Remarks</th>
</tr>
<tr><td>Projection_1.MANDT</td><td>MANDT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>MANDT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.STRNUM</td><td>STRNUM</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>STRNUM</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.PRCTR</td><td>PRCTR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>PRCTR</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.KOKRS</td><td>KOKRS</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>KOKRS</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.KOSTL</td><td>KOSTL</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>KOSTL</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_OPEN_DAT</td><td>RX_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_CLOSE_DAT</td><td>RX_CLOSE_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_CLOSE_DAT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_HRS_OPER</td><td>RX_HRS_OPER</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_HRS_OPER</td><td>Aggregated: SUM</td></tr>
<tr><td>Projection_1.FS_OPEN_DAT</td><td>FS_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>FS_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.FS_CLOSE_DAT</td><td>FS_CLOSE_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>FS_CLOSE_DAT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.FS_HRS_OPER</td><td>FS_HRS_OPER</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>FS_HRS_OPER</td><td>Aggregated: SUM</td></tr>
<tr><td>Projection_1.REP_MKT_CODE</td><td>REP_MKT_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>REP_MKT_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.REP_MKT_DESC</td><td>REP_MKT_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>REP_MKT_DESC</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ADDRESS</td><td>ADDRESS</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ADDRESS</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.CITY</td><td>CITY</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>CITY</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.STATE</td><td>STATE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>STATE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZIPCODE</td><td>ZIPCODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ZIPCODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.DIVISION_CODE</td><td>DIVISION_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DIVISION_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.DIVISION_DESC</td><td>DIVISION_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DIVISION_DESC</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.DIVISION_MGR</td><td>DIVISION_MGR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DIVISION_MGR</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.AREA_CODE</td><td>AREA_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>AREA_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.AREA_DESC</td><td>AREA_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>AREA_DESC</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.AREA_MGR</td><td>AREA_MGR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>AREA_MGR</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.REGION_CODE</td><td>REGION_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>REGION_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.REGION_DESC</td><td>REGION_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>REGION_DESC</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.REGION_MGR</td><td>REGION_MGR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>REGION_MGR</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.DISTRICT_CODE</td><td>DISTRICT_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRICT_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.DISTRICT_DESC</td><td>DISTRICT_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRICT_DESC</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZONE_CODE</td><td>ZONE_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ZONE_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.DISTRICT_MGR</td><td>DISTRICT_MGR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRICT_MGR</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZONE_DESC</td><td>ZONE_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ZONE_DESC</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.MAJOR_REGION_CODE</td><td>MAJOR_REGION_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>MAJOR_REGION_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.MAJOR_REGION</td><td>MAJOR_REGION</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>MAJOR_REGION</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.STORE_TYPE</td><td>STORE_TYPE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>STORE_TYPE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.STORE_TYPE_DESC</td><td>STORE_TYPE_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>STORE_TYPE_DESC</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_STORE</td><td>RX_STORE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_STORE</td><td>Aggregated: SUM</td></tr>
<tr><td>Projection_1.RX_STORE_DESC</td><td>RX_STORE_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_STORE_DESC</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.DISTRIBUTION_CNTR</td><td>DISTRIBUTION_CNTR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRIBUTION_CNTR</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.DISTRIBUTION_CNTR_DESC</td><td>DISTRIBUTION_CNTR_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRIBUTION_CNTR_DESC</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.STORE_24_HR</td><td>STORE_24_HR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>STORE_24_HR</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.BUDGET_OPEN_DAT</td><td>BUDGET_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>BUDGET_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.BUDGET_CLOSED_DAT</td><td>BUDGET_CLOSED_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>BUDGET_CLOSED_DAT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.BUDGET_RELOC_DAT</td><td>BUDGET_RELOC_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>BUDGET_RELOC_DAT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.CONST_OPEN_DAT</td><td>CONST_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>CONST_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.CONST_CLOSE_DAT</td><td>CONST_CLOSE_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>CONST_CLOSE_DAT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.CONST_RELO_DAT</td><td>CONST_RELO_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>CONST_RELO_DAT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RELOCATION_DAT</td><td>RELOCATION_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RELOCATION_DAT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.EMERG_MKT_IND</td><td>EMERG_MKT_IND</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>EMERG_MKT_IND</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.BUDGET_EMERG_MKT_IND</td><td>BUDGET_EMERG_MKT_IND</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>BUDGET_EMERG_MKT_IND</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.COMPANY_CODE</td><td>COMPANY_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>COMPANY_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.COMPANY_CODE_DESC</td><td>COMPANY_CODE_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>COMPANY_CODE_DESC</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ORIGINAL_FS_OPEN_DAT</td><td>ORIGINAL_FS_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ORIGINAL_FS_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ORIGINAL_RX_OPEN_DAT</td><td>ORIGINAL_RX_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ORIGINAL_RX_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.GROUP_ONE</td><td>GROUP_ONE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>GROUP_ONE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.GROUP_TWO</td><td>GROUP_TWO</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>GROUP_TWO</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ARD_SORT_KEY</td><td>ARD_SORT_KEY</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ARD_SORT_KEY</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.AREA_COST_CENTER</td><td>AREA_COST_CENTER</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>AREA_COST_CENTER</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.REGIION_COST_CENTER</td><td>REGIION_COST_CENTER</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>REGIION_COST_CENTER</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.COUNTY_CODE</td><td>COUNTY_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>COUNTY_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.COUNTY_DESC</td><td>COUNTY_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>COUNTY_DESC</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RETAIL_SQFT_AMT</td><td>RETAIL_SQFT_AMT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RETAIL_SQFT_AMT</td><td>Aggregated: SUM</td></tr>
<tr><td>Projection_1.TOTAL_SQFT_AMT</td><td>TOTAL_SQFT_AMT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>TOTAL_SQFT_AMT</td><td>Aggregated: SUM</td></tr>
<tr><td>Projection_1.SQFT_BRACKET_DESC</td><td>SQFT_BRACKET_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>SQFT_BRACKET_DESC</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.SQFT_SORT_KEY</td><td>SQFT_SORT_KEY</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>SQFT_SORT_KEY</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ACQUISITION_CODE</td><td>ACQUISITION_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ACQUISITION_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ACQUISITION_DESC</td><td>ACQUISITION_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ACQUISITION_DESC</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.PHOTO_LAB_ADD_DAT</td><td>PHOTO_LAB_ADD_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>PHOTO_LAB_ADD_DAT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.PHOTO_LAB_CLOSE_DAT</td><td>PHOTO_LAB_CLOSE_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>PHOTO_LAB_CLOSE_DAT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.MIN_HRS_IND</td><td>MIN_HRS_IND</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>MIN_HRS_IND</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.CREATEDBY</td><td>CREATEDBY</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>CREATEDBY</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.CREATED_ON</td><td>CREATED_ON</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>CREATED_ON</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_DIVISION_CODE</td><td>RX_DIVISION_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_DIVISION_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_AREA_CODE</td><td>RX_AREA_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_AREA_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_REGION_CODE</td><td>RX_REGION_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_REGION_CODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_DISTRICT_CODE</td><td>RX_DISTRICT_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_DISTRICT_CODE</td><td>Direct mapping</td></tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;background:#fcfcfc">
<tr style="background:#e3eaff"><th>Category</th><th>Measurement</th></tr>
<tr><td>Number of Objects/Nodes</td><td>2 (Calculation View, Projection_1)</td></tr>
<tr><td>Sources Used</td><td>1 (CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT)</td></tr>
<tr><td>Joins</td><td>None identified</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>SUM (RX_HRS_OPER, FS_HRS_OPER, RX_STORE, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT)</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>None identified</td></tr>
<tr><td>Workflow Complexity</td><td>Low; single projection node, direct mapping, basic aggregation</td></tr>
<tr><td>Performance Considerations</td><td>Direct mapping and aggregation; no joins or calculated fields</td></tr>
<tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
<tr><td>Dependency Complexity</td><td>Single dependency (CDS artifact table)</td></tr>
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
<li>RX_STORE (SUM)</li>
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
