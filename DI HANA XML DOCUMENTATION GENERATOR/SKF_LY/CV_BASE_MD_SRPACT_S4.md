<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse;">
  <tr>
    <td style="width:25%; font-weight:bold;">Author:</td>
    <td style="width:75%;">Ascendion AAVA</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Created On:</td>
    <td>2026-10-12</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Description:</td>
    <td>Technical documentation for Calculation View <b>CV_BASE_MD_SRPACT_S4</b>, which serves as the base view for ZTSRP_ATTR_ACT - Store Profile Attribute for Actuals. The object is defined as a TREE_BASED calculation scenario with CUBE data category and outputs store profile attributes and related measures.</td>
  </tr>
</table>
<br/>

<!-- 1. Overview of Program -->
<p>This HANA XML object is a Calculation View named <b>CV_BASE_MD_SRPACT_S4</b>. Its primary purpose is to model and expose store profile attributes and actuals using a single base table as the source. The object aggregates and projects store-related fields and measures for reporting and analytical use.</p>
<br/>

<!-- 2. Code Structure and Design -->
<p>
  <b>Structure:</b> The Calculation View is structured as a TREE_BASED scenario with a single projection node (<b>Projection_1</b>) sourcing data from the base table <b>ZTSRP_ATTR_ACT</b>. The projection node maps all relevant fields from the source, applies a filter on the <b>MANDT</b> field (IN 120, 200), and defines logical attributes and measures. No joins, unions, or calculated fields are present.
  <br/>
  <b>Key Components:</b> The major components include the <b>dataSources</b> section referencing <b>ZTSRP_ATTR_ACT</b>, the <b>Projection_1</b> node mapping source fields to output attributes and measures, logical model definitions for attributes and measures, and a filter on the <b>MANDT</b> attribute. The output view type is Aggregation.
  <br/>
  <b>Dependencies & Performance:</b> The only dependency is the base table <b>ZTSRP_ATTR_ACT</b>. No joins or unions are present. Aggregation is performed for four measures using SUM. No calculated expressions or complex processing logic are defined. The filter on <b>MANDT</b> may improve performance by limiting data volume.
</p>
<br/>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; padding:10px; background:#f8f9fa; border-radius:8px;">
  <div style="display:grid; grid-template-columns:repeat(3, 220px); grid-auto-rows:90px; align-items:center; justify-items:center; gap:32px;">
    <!-- Data Source -->
    <div style="grid-column:1; grid-row:1; background:#e3eafc; border:1px solid #b6c2d9; border-radius:6px; box-shadow:0 1px 3px #cfd8dc; width:200px; height:70px; display:flex; align-items:center; justify-content:center; font-weight:bold;">ZTSRP_ATTR_ACT (Base Table)</div>
    <!-- Arrow -->
    <div style="grid-column:2; grid-row:1; width:40px; height:70px; display:flex; align-items:center; justify-content:center;">
      <svg height="30" width="40"><line x1="0" y1="15" x2="40" y2="15" style="stroke:#5a5a5a;stroke-width:2"/><polygon points="40,15 30,10 30,20" style="fill:#5a5a5a;"/></svg>
    </div>
    <!-- Projection Node -->
    <div style="grid-column:3; grid-row:1; background:#fffbe7; border:1px solid #ffe29a; border-radius:6px; box-shadow:0 1px 3px #f0e6c2; width:200px; height:70px; display:flex; align-items:center; justify-content:center; font-weight:bold;">Projection_1<br/><span style="font-size:12px; color:#888;">Field Mapping & Filter<br/>MANDT IN (120, 200)</span></div>
    <!-- Arrow -->
    <div style="grid-column:2; grid-row:2; width:40px; height:70px; display:flex; align-items:center; justify-content:center;">
      <svg height="30" width="40"><line x1="0" y1="15" x2="40" y2="15" style="stroke:#5a5a5a;stroke-width:2"/><polygon points="40,15 30,10 30,20" style="fill:#5a5a5a;"/></svg>
    </div>
    <!-- Logical Model Output -->
    <div style="grid-column:3; grid-row:2; background:#e7fff7; border:1px solid #9aeedb; border-radius:6px; box-shadow:0 1px 3px #c2f0e6; width:200px; height:70px; display:flex; align-items:center; justify-content:center; font-weight:bold;">Output<br/><span style="font-size:12px; color:#888;">Attributes & Measures<br/>Aggregation</span></div>
  </div>
</div>
<br/>

<!-- 4. Data Mapping -->
<table style="width:100%; border-collapse:collapse;">
  <thead>
    <tr style="background:#f0f0f0;">
      <th>Target Object/Field Name</th>
      <th>Target Column Name</th>
      <th>Source Object/Field Name</th>
      <th>Source Column Name</th>
      <th>Remarks</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>MANDT</td><td>MANDT</td><td>ZTSRP_ATTR_ACT</td><td>MANDT</td><td>MANDT filtered IN (120, 200)</td></tr>
    <tr><td>STRNUM</td><td>STRNUM</td><td>ZTSRP_ATTR_ACT</td><td>STRNUM</td><td>Direct mapping</td></tr>
    <tr><td>PRCTR</td><td>PRCTR</td><td>ZTSRP_ATTR_ACT</td><td>PRCTR</td><td>Direct mapping</td></tr>
    <tr><td>KOKRS</td><td>KOKRS</td><td>ZTSRP_ATTR_ACT</td><td>KOKRS</td><td>Direct mapping</td></tr>
    <tr><td>KOSTL</td><td>KOSTL</td><td>ZTSRP_ATTR_ACT</td><td>KOSTL</td><td>Direct mapping</td></tr>
    <tr><td>RX_OPEN_DAT</td><td>RX_OPEN_DAT</td><td>ZTSRP_ATTR_ACT</td><td>RX_OPEN_DAT</td><td>Direct mapping</td></tr>
    <tr><td>RX_CLOSE_DAT</td><td>RX_CLOSE_DAT</td><td>ZTSRP_ATTR_ACT</td><td>RX_CLOSE_DAT</td><td>Direct mapping</td></tr>
    <tr><td>RX_HRS_OPER</td><td>RX_HRS_OPER</td><td>ZTSRP_ATTR_ACT</td><td>RX_HRS_OPER</td><td>Aggregated (SUM)</td></tr>
    <tr><td>FS_OPEN_DAT</td><td>FS_OPEN_DAT</td><td>ZTSRP_ATTR_ACT</td><td>FS_OPEN_DAT</td><td>Direct mapping</td></tr>
    <tr><td>FS_CLOSE_DAT</td><td>FS_CLOSE_DAT</td><td>ZTSRP_ATTR_ACT</td><td>FS_CLOSE_DAT</td><td>Direct mapping</td></tr>
    <tr><td>FS_HRS_OPER</td><td>FS_HRS_OPER</td><td>ZTSRP_ATTR_ACT</td><td>FS_HRS_OPER</td><td>Aggregated (SUM)</td></tr>
    <tr><td>REP_MKT_CODE</td><td>REP_MKT_CODE</td><td>ZTSRP_ATTR_ACT</td><td>REP_MKT_CODE</td><td>Direct mapping</td></tr>
    <tr><td>REP_MKT_DESC</td><td>REP_MKT_DESC</td><td>ZTSRP_ATTR_ACT</td><td>REP_MKT_DESC</td><td>Direct mapping</td></tr>
    <tr><td>ADDRESS</td><td>ADDRESS</td><td>ZTSRP_ATTR_ACT</td><td>ADDRESS</td><td>Direct mapping</td></tr>
    <tr><td>CITY</td><td>CITY</td><td>ZTSRP_ATTR_ACT</td><td>CITY</td><td>Direct mapping</td></tr>
    <tr><td>STATE</td><td>STATE</td><td>ZTSRP_ATTR_ACT</td><td>STATE</td><td>Direct mapping</td></tr>
    <tr><td>ZIPCODE</td><td>ZIPCODE</td><td>ZTSRP_ATTR_ACT</td><td>ZIPCODE</td><td>Direct mapping</td></tr>
    <tr><td>DIVISION_CODE</td><td>DIVISION_CODE</td><td>ZTSRP_ATTR_ACT</td><td>DIVISION_CODE</td><td>Direct mapping</td></tr>
    <tr><td>DIVISION_DESC</td><td>DIVISION_DESC</td><td>ZTSRP_ATTR_ACT</td><td>DIVISION_DESC</td><td>Direct mapping</td></tr>
    <tr><td>DIVISION_MGR</td><td>DIVISION_MGR</td><td>ZTSRP_ATTR_ACT</td><td>DIVISION_MGR</td><td>Direct mapping</td></tr>
    <tr><td>AREA_CODE</td><td>AREA_CODE</td><td>ZTSRP_ATTR_ACT</td><td>AREA_CODE</td><td>Direct mapping</td></tr>
    <tr><td>AREA_DESC</td><td>AREA_DESC</td><td>ZTSRP_ATTR_ACT</td><td>AREA_DESC</td><td>Direct mapping</td></tr>
    <tr><td>AREA_MGR</td><td>AREA_MGR</td><td>ZTSRP_ATTR_ACT</td><td>AREA_MGR</td><td>Direct mapping</td></tr>
    <tr><td>REGION_CODE</td><td>REGION_CODE</td><td>ZTSRP_ATTR_ACT</td><td>REGION_CODE</td><td>Direct mapping</td></tr>
    <tr><td>REGION_DESC</td><td>REGION_DESC</td><td>ZTSRP_ATTR_ACT</td><td>REGION_DESC</td><td>Direct mapping</td></tr>
    <tr><td>REGION_MGR</td><td>REGION_MGR</td><td>ZTSRP_ATTR_ACT</td><td>REGION_MGR</td><td>Direct mapping</td></tr>
    <tr><td>DISTRICT_CODE</td><td>DISTRICT_CODE</td><td>ZTSRP_ATTR_ACT</td><td>DISTRICT_CODE</td><td>Direct mapping</td></tr>
    <tr><td>DISTRICT_DESC</td><td>DISTRICT_DESC</td><td>ZTSRP_ATTR_ACT</td><td>DISTRICT_DESC</td><td>Direct mapping</td></tr>
    <tr><td>ZONE_CODE</td><td>ZONE_CODE</td><td>ZTSRP_ATTR_ACT</td><td>ZONE_CODE</td><td>Direct mapping</td></tr>
    <tr><td>DISTRICT_MGR</td><td>DISTRICT_MGR</td><td>ZTSRP_ATTR_ACT</td><td>DISTRICT_MGR</td><td>Direct mapping</td></tr>
    <tr><td>ZONE_DESC</td><td>ZONE_DESC</td><td>ZTSRP_ATTR_ACT</td><td>ZONE_DESC</td><td>Direct mapping</td></tr>
    <tr><td>MAJOR_REGION_CODE</td><td>MAJOR_REGION_CODE</td><td>ZTSRP_ATTR_ACT</td><td>MAJOR_REGION_CODE</td><td>Direct mapping</td></tr>
    <tr><td>MAJOR_REGION</td><td>MAJOR_REGION</td><td>ZTSRP_ATTR_ACT</td><td>MAJOR_REGION</td><td>Direct mapping</td></tr>
    <tr><td>STORE_TYPE</td><td>STORE_TYPE</td><td>ZTSRP_ATTR_ACT</td><td>STORE_TYPE</td><td>Direct mapping</td></tr>
    <tr><td>STORE_TYPE_DESC</td><td>STORE_TYPE_DESC</td><td>ZTSRP_ATTR_ACT</td><td>STORE_TYPE_DESC</td><td>Direct mapping</td></tr>
    <tr><td>RX_STORE</td><td>RX_STORE</td><td>ZTSRP_ATTR_ACT</td><td>RX_STORE</td><td>Direct mapping</td></tr>
    <tr><td>RX_STORE_DESC</td><td>RX_STORE_DESC</td><td>ZTSRP_ATTR_ACT</td><td>RX_STORE_DESC</td><td>Direct mapping</td></tr>
    <tr><td>DISTRIBUTION_CNTR</td><td>DISTRIBUTION_CNTR</td><td>ZTSRP_ATTR_ACT</td><td>DISTRIBUTION_CNTR</td><td>Direct mapping</td></tr>
    <tr><td>DISTRIBUTION_CNTR_DESC</td><td>DISTRIBUTION_CNTR_DESC</td><td>ZTSRP_ATTR_ACT</td><td>DISTRIBUTION_CNTR_DESC</td><td>Direct mapping</td></tr>
    <tr><td>STORE_24_HR</td><td>STORE_24_HR</td><td>ZTSRP_ATTR_ACT</td><td>STORE_24_HR</td><td>Direct mapping</td></tr>
    <tr><td>BUDGET_OPEN_DAT</td><td>BUDGET_OPEN_DAT</td><td>ZTSRP_ATTR_ACT</td><td>BUDGET_OPEN_DAT</td><td>Direct mapping</td></tr>
    <tr><td>BUDGET_CLOSED_DAT</td><td>BUDGET_CLOSED_DAT</td><td>ZTSRP_ATTR_ACT</td><td>BUDGET_CLOSED_DAT</td><td>Direct mapping</td></tr>
    <tr><td>BUDGET_RELOC_DAT</td><td>BUDGET_RELOC_DAT</td><td>ZTSRP_ATTR_ACT</td><td>BUDGET_RELOC_DAT</td><td>Direct mapping</td></tr>
    <tr><td>CONST_OPEN_DAT</td><td>CONST_OPEN_DAT</td><td>ZTSRP_ATTR_ACT</td><td>CONST_OPEN_DAT</td><td>Direct mapping</td></tr>
    <tr><td>CONST_CLOSE_DAT</td><td>CONST_CLOSE_DAT</td><td>ZTSRP_ATTR_ACT</td><td>CONST_CLOSE_DAT</td><td>Direct mapping</td></tr>
    <tr><td>CONST_RELO_DAT</td><td>CONST_RELO_DAT</td><td>ZTSRP_ATTR_ACT</td><td>CONST_RELO_DAT</td><td>Direct mapping</td></tr>
    <tr><td>RELOCATION_DAT</td><td>RELOCATION_DAT</td><td>ZTSRP_ATTR_ACT</td><td>RELOCATION_DAT</td><td>Direct mapping</td></tr>
    <tr><td>EMERG_MKT_IND</td><td>EMERG_MKT_IND</td><td>ZTSRP_ATTR_ACT</td><td>EMERG_MKT_IND</td><td>Direct mapping</td></tr>
    <tr><td>BUDGET_EMERG_MKT_IND</td><td>BUDGET_EMERG_MKT_IND</td><td>ZTSRP_ATTR_ACT</td><td>BUDGET_EMERG_MKT_IND</td><td>Direct mapping</td></tr>
    <tr><td>COMPANY_CODE</td><td>COMPANY_CODE</td><td>ZTSRP_ATTR_ACT</td><td>COMPANY_CODE</td><td>Direct mapping</td></tr>
    <tr><td>COMPANY_CODE_DESC</td><td>COMPANY_CODE_DESC</td><td>ZTSRP_ATTR_ACT</td><td>COMPANY_CODE_DESC</td><td>Direct mapping</td></tr>
    <tr><td>ORIGINAL_FS_OPEN_DAT</td><td>ORIGINAL_FS_OPEN_DAT</td><td>ZTSRP_ATTR_ACT</td><td>ORIGINAL_FS_OPEN_DAT</td><td>Direct mapping</td></tr>
    <tr><td>ORIGINAL_RX_OPEN_DAT</td><td>ORIGINAL_RX_OPEN_DAT</td><td>ZTSRP_ATTR_ACT</td><td>ORIGINAL_RX_OPEN_DAT</td><td>Direct mapping</td></tr>
    <tr><td>GROUP_ONE</td><td>GROUP_ONE</td><td>ZTSRP_ATTR_ACT</td><td>GROUP_ONE</td><td>Direct mapping</td></tr>
    <tr><td>GROUP_TWO</td><td>GROUP_TWO</td><td>ZTSRP_ATTR_ACT</td><td>GROUP_TWO</td><td>Direct mapping</td></tr>
    <tr><td>ARD_SORT_KEY</td><td>ARD_SORT_KEY</td><td>ZTSRP_ATTR_ACT</td><td>ARD_SORT_KEY</td><td>Direct mapping</td></tr>
    <tr><td>AREA_COST_CENTER</td><td>AREA_COST_CENTER</td><td>ZTSRP_ATTR_ACT</td><td>AREA_COST_CENTER</td><td>Direct mapping</td></tr>
    <tr><td>REGIION_COST_CENTER</td><td>REGIION_COST_CENTER</td><td>ZTSRP_ATTR_ACT</td><td>REGIION_COST_CENTER</td><td>Direct mapping</td></tr>
    <tr><td>COUNTY_CODE</td><td>COUNTY_CODE</td><td>ZTSRP_ATTR_ACT</td><td>COUNTY_CODE</td><td>Direct mapping</td></tr>
    <tr><td>COUNTY_DESC</td><td>COUNTY_DESC</td><td>ZTSRP_ATTR_ACT</td><td>COUNTY_DESC</td><td>Direct mapping</td></tr>
    <tr><td>RETAIL_SQFT_AMT</td><td>RETAIL_SQFT_AMT</td><td>ZTSRP_ATTR_ACT</td><td>RETAIL_SQFT_AMT</td><td>Aggregated (SUM)</td></tr>
    <tr><td>TOTAL_SQFT_AMT</td><td>TOTAL_SQFT_AMT</td><td>ZTSRP_ATTR_ACT</td><td>TOTAL_SQFT_AMT</td><td>Aggregated (SUM)</td></tr>
    <tr><td>SQFT_BRACKET_DESC</td><td>SQFT_BRACKET_DESC</td><td>ZTSRP_ATTR_ACT</td><td>SQFT_BRACKET_DESC</td><td>Direct mapping</td></tr>
    <tr><td>SQFT_SORT_KEY</td><td>SQFT_SORT_KEY</td><td>ZTSRP_ATTR_ACT</td><td>SQFT_SORT_KEY</td><td>Direct mapping</td></tr>
    <tr><td>ACQUISITION_CODE</td><td>ACQUISITION_CODE</td><td>ZTSRP_ATTR_ACT</td><td>ACQUISITION_CODE</td><td>Direct mapping</td></tr>
    <tr><td>ACQUISITION_DESC</td><td>ACQUISITION_DESC</td><td>ZTSRP_ATTR_ACT</td><td>ACQUISITION_DESC</td><td>Direct mapping</td></tr>
    <tr><td>PHOTO_LAB_ADD_DAT</td><td>PHOTO_LAB_ADD_DAT</td><td>ZTSRP_ATTR_ACT</td><td>PHOTO_LAB_ADD_DAT</td><td>Direct mapping</td></tr>
    <tr><td>PHOTO_LAB_CLOSE_DAT</td><td>PHOTO_LAB_CLOSE_DAT</td><td>ZTSRP_ATTR_ACT</td><td>PHOTO_LAB_CLOSE_DAT</td><td>Direct mapping</td></tr>
    <tr><td>MIN_HRS_IND</td><td>MIN_HRS_IND</td><td>ZTSRP_ATTR_ACT</td><td>MIN_HRS_IND</td><td>Direct mapping</td></tr>
    <tr><td>CREATEDBY</td><td>CREATEDBY</td><td>ZTSRP_ATTR_ACT</td><td>CREATEDBY</td><td>Direct mapping</td></tr>
    <tr><td>CREATED_ON</td><td>CREATED_ON</td><td>ZTSRP_ATTR_ACT</td><td>CREATED_ON</td><td>Direct mapping</td></tr>
    <tr><td>RX_DIVISION_CODE</td><td>RX_DIVISION_CODE</td><td>ZTSRP_ATTR_ACT</td><td>RX_DIVISION_CODE</td><td>Direct mapping</td></tr>
    <tr><td>RX_AREA_CODE</td><td>RX_AREA_CODE</td><td>ZTSRP_ATTR_ACT</td><td>RX_AREA_CODE</td><td>Direct mapping</td></tr>
    <tr><td>RX_REGION_CODE</td><td>RX_REGION_CODE</td><td>ZTSRP_ATTR_ACT</td><td>RX_REGION_CODE</td><td>Direct mapping</td></tr>
    <tr><td>RX_DISTRICT_CODE</td><td>RX_DISTRICT_CODE</td><td>ZTSRP_ATTR_ACT</td><td>RX_DISTRICT_CODE</td><td>Direct mapping</td></tr>
  </tbody>
</table>
<br/>

<!-- 5. Complexity Analysis -->
<table style="width:100%; border-collapse:collapse;">
  <tr><td>Number of Objects/Nodes</td><td>3 (Calculation View, Projection_1, ZTSRP_ATTR_ACT)</td></tr>
  <tr><td>Sources Used</td><td>ZTSRP_ATTR_ACT (Base Table)</td></tr>
  <tr><td>Joins</td><td>None</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>SUM (RX_HRS_OPER, FS_HRS_OPER, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT)</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>MANDT filter (IN 120, 200)</td></tr>
  <tr><td>Workflow Complexity</td><td>Simple linear flow: Source → Projection → Output</td></tr>
  <tr><td>Performance Considerations</td><td>Single source, filter on MANDT, aggregation on selected measures</td></tr>
  <tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single dependency: ZTSRP_ATTR_ACT</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>
<br/>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found
<br/>

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
<br/>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
