<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse;">
  <tr>
    <td style="width:25%;"><b>Author:</b></td>
    <td style="width:75%;">Ascendion AAVA</td>
  </tr>
  <tr>
    <td><b>Created On:</b></td>
    <td>2024-06-10</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td>Calculation View <b>CV_BASE_MD_SRPACT_S4</b> provides a base view for the object <b>ZTSRP_ATTR_ACT</b>, modeling store profile attributes for actuals. The view is structured to expose a wide range of store-related fields and measures for reporting purposes, as defined in the XML.</td>
  </tr>
</table>
<br/>

<!-- 1. Overview of Program -->
<p><b>Type:</b> Calculation View (TREE_BASED, CUBE). <b>Purpose:</b> To model and expose store profile attributes and operational measures from the underlying data table <b>ZTSRP_ATTR_ACT</b>. <b>Main Processing:</b> The view projects all relevant fields from the source table, applies a filter on client (MANDT), and aggregates operational measures for reporting.</p>
<br/>

<!-- 2. Code Structure and Design -->
<p>
<b>Structure:</b> The Calculation View consists of a single Projection node (<b>Projection_1</b>) sourcing data from the base table <b>ZTSRP_ATTR_ACT</b>. All fields from the source are mapped directly, with a filter applied to the <b>MANDT</b> field for values 120 and 200. Logical model definitions specify attributes and measures, including aggregation types for operational hours and square footage.
<br/>
<b>Key Components:</b> The major components are the <b>Projection_1</b> node, the data source <b>ZTSRP_ATTR_ACT</b>, attribute mappings, measure definitions (RX_HRS_OPER, FS_HRS_OPER, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT), and the logical model outlining output structure. No calculated attributes or measures are defined in the XML.
<br/>
<b>Dependencies & Performance:</b> The view depends on the single source table <b>ZTSRP_ATTR_ACT</b>. There are no joins or unions, and only basic aggregation is performed. Filters on <b>MANDT</b> may improve performance by restricting data volume. No complex processing or nested logic is present.
</p>
<br/>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; padding:8px; background:#f8f9fa; border-radius:8px;">
  <div style="display:grid; grid-template-columns:repeat(3, 220px); grid-template-rows:repeat(2, 80px); gap:24px; align-items:center;">
    <!-- Data Source -->
    <div style="grid-column:1; grid-row:1; background:#e3e8ee; border-radius:8px; box-shadow:0 1px 4px #d1d5db; text-align:center; padding:16px; font-weight:bold;">ZTSRP_ATTR_ACT<br/><span style="font-size:12px; color:#888;">Base Table</span></div>
    <!-- Arrow to Projection -->
    <div style="grid-column:2; grid-row:1; text-align:center;">
      <svg width="60" height="80"><line x1="0" y1="40" x2="60" y2="40" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/><defs><marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#888"/></marker></defs></svg>
    </div>
    <!-- Projection Node -->
    <div style="grid-column:3; grid-row:1; background:#e3e8ee; border-radius:8px; box-shadow:0 1px 4px #d1d5db; text-align:center; padding:16px; font-weight:bold;">Projection_1<br/><span style="font-size:12px; color:#888;">Projection & Filter (MANDT)</span></div>
    <!-- Arrow to Logical Model -->
    <div style="grid-column:3; grid-row:1; text-align:center;">
      <svg width="60" height="80"><line x1="0" y1="40" x2="60" y2="40" stroke="#888" stroke-width="2" marker-end="url(#arrowhead2)"/><defs><marker id="arrowhead2" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#888"/></marker></defs></svg>
    </div>
    <!-- Logical Model / Output -->
    <div style="grid-column:2; grid-row:2; background:#e3e8ee; border-radius:8px; box-shadow:0 1px 4px #d1d5db; text-align:center; padding:16px; font-weight:bold;">Logical Model<br/><span style="font-size:12px; color:#888;">Attributes & Measures</span></div>
    <!-- Arrow to Output -->
    <div style="grid-column:2; grid-row:2; text-align:center;">
      <svg width="60" height="80"><line x1="30" y1="0" x2="30" y2="80" stroke="#888" stroke-width="2" marker-end="url(#arrowhead3)"/><defs><marker id="arrowhead3" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#888"/></marker></defs></svg>
    </div>
    <!-- Output View -->
    <div style="grid-column:2; grid-row:2; background:#e3e8ee; border-radius:8px; box-shadow:0 1px 4px #d1d5db; text-align:center; padding:16px; font-weight:bold;">Output View<br/><span style="font-size:12px; color:#888;">Aggregated Results</span></div>
  </div>
</div>
<br/>

<!-- 4. Data Mapping -->
<table style="width:100%; border-collapse:collapse;">
  <tr style="background:#e3e8ee;">
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr>
    <td>Projection_1.MANDT</td>
    <td>MANDT</td>
    <td>ZTSRP_ATTR_ACT.MANDT</td>
    <td>MANDT</td>
    <td>Filter applied: IN (120, 200)</td>
  </tr>
  <tr>
    <td>Projection_1.STRNUM</td>
    <td>STRNUM</td>
    <td>ZTSRP_ATTR_ACT.STRNUM</td>
    <td>STRNUM</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.PRCTR</td>
    <td>PRCTR</td>
    <td>ZTSRP_ATTR_ACT.PRCTR</td>
    <td>PRCTR</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.KOKRS</td>
    <td>KOKRS</td>
    <td>ZTSRP_ATTR_ACT.KOKRS</td>
    <td>KOKRS</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.KOSTL</td>
    <td>KOSTL</td>
    <td>ZTSRP_ATTR_ACT.KOSTL</td>
    <td>KOSTL</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.RX_OPEN_DAT</td>
    <td>RX_OPEN_DAT</td>
    <td>ZTSRP_ATTR_ACT.RX_OPEN_DAT</td>
    <td>RX_OPEN_DAT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.RX_CLOSE_DAT</td>
    <td>RX_CLOSE_DAT</td>
    <td>ZTSRP_ATTR_ACT.RX_CLOSE_DAT</td>
    <td>RX_CLOSE_DAT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.RX_HRS_OPER</td>
    <td>RX_HRS_OPER</td>
    <td>ZTSRP_ATTR_ACT.RX_HRS_OPER</td>
    <td>RX_HRS_OPER</td>
    <td>Aggregation: SUM</td>
  </tr>
  <tr>
    <td>Projection_1.FS_OPEN_DAT</td>
    <td>FS_OPEN_DAT</td>
    <td>ZTSRP_ATTR_ACT.FS_OPEN_DAT</td>
    <td>FS_OPEN_DAT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.FS_CLOSE_DAT</td>
    <td>FS_CLOSE_DAT</td>
    <td>ZTSRP_ATTR_ACT.FS_CLOSE_DAT</td>
    <td>FS_CLOSE_DAT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.FS_HRS_OPER</td>
    <td>FS_HRS_OPER</td>
    <td>ZTSRP_ATTR_ACT.FS_HRS_OPER</td>
    <td>FS_HRS_OPER</td>
    <td>Aggregation: SUM</td>
  </tr>
  <tr>
    <td>Projection_1.REP_MKT_CODE</td>
    <td>REP_MKT_CODE</td>
    <td>ZTSRP_ATTR_ACT.REP_MKT_CODE</td>
    <td>REP_MKT_CODE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.REP_MKT_DESC</td>
    <td>REP_MKT_DESC</td>
    <td>ZTSRP_ATTR_ACT.REP_MKT_DESC</td>
    <td>REP_MKT_DESC</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.ADDRESS</td>
    <td>ADDRESS</td>
    <td>ZTSRP_ATTR_ACT.ADDRESS</td>
    <td>ADDRESS</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.CITY</td>
    <td>CITY</td>
    <td>ZTSRP_ATTR_ACT.CITY</td>
    <td>CITY</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.STATE</td>
    <td>STATE</td>
    <td>ZTSRP_ATTR_ACT.STATE</td>
    <td>STATE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.ZIPCODE</td>
    <td>ZIPCODE</td>
    <td>ZTSRP_ATTR_ACT.ZIPCODE</td>
    <td>ZIPCODE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.DIVISION_CODE</td>
    <td>DIVISION_CODE</td>
    <td>ZTSRP_ATTR_ACT.DIVISION_CODE</td>
    <td>DIVISION_CODE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.DIVISION_DESC</td>
    <td>DIVISION_DESC</td>
    <td>ZTSRP_ATTR_ACT.DIVISION_DESC</td>
    <td>DIVISION_DESC</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.DIVISION_MGR</td>
    <td>DIVISION_MGR</td>
    <td>ZTSRP_ATTR_ACT.DIVISION_MGR</td>
    <td>DIVISION_MGR</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.AREA_CODE</td>
    <td>AREA_CODE</td>
    <td>ZTSRP_ATTR_ACT.AREA_CODE</td>
    <td>AREA_CODE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.AREA_DESC</td>
    <td>AREA_DESC</td>
    <td>ZTSRP_ATTR_ACT.AREA_DESC</td>
    <td>AREA_DESC</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.AREA_MGR</td>
    <td>AREA_MGR</td>
    <td>ZTSRP_ATTR_ACT.AREA_MGR</td>
    <td>AREA_MGR</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.REGION_CODE</td>
    <td>REGION_CODE</td>
    <td>ZTSRP_ATTR_ACT.REGION_CODE</td>
    <td>REGION_CODE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.REGION_DESC</td>
    <td>REGION_DESC</td>
    <td>ZTSRP_ATTR_ACT.REGION_DESC</td>
    <td>REGION_DESC</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.REGION_MGR</td>
    <td>REGION_MGR</td>
    <td>ZTSRP_ATTR_ACT.REGION_MGR</td>
    <td>REGION_MGR</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.DISTRICT_CODE</td>
    <td>DISTRICT_CODE</td>
    <td>ZTSRP_ATTR_ACT.DISTRICT_CODE</td>
    <td>DISTRICT_CODE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.DISTRICT_DESC</td>
    <td>DISTRICT_DESC</td>
    <td>ZTSRP_ATTR_ACT.DISTRICT_DESC</td>
    <td>DISTRICT_DESC</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.ZONE_CODE</td>
    <td>ZONE_CODE</td>
    <td>ZTSRP_ATTR_ACT.ZONE_CODE</td>
    <td>ZONE_CODE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.DISTRICT_MGR</td>
    <td>DISTRICT_MGR</td>
    <td>ZTSRP_ATTR_ACT.DISTRICT_MGR</td>
    <td>DISTRICT_MGR</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.ZONE_DESC</td>
    <td>ZONE_DESC</td>
    <td>ZTSRP_ATTR_ACT.ZONE_DESC</td>
    <td>ZONE_DESC</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.MAJOR_REGION_CODE</td>
    <td>MAJOR_REGION_CODE</td>
    <td>ZTSRP_ATTR_ACT.MAJOR_REGION_CODE</td>
    <td>MAJOR_REGION_CODE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.MAJOR_REGION</td>
    <td>MAJOR_REGION</td>
    <td>ZTSRP_ATTR_ACT.MAJOR_REGION</td>
    <td>MAJOR_REGION</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.STORE_TYPE</td>
    <td>STORE_TYPE</td>
    <td>ZTSRP_ATTR_ACT.STORE_TYPE</td>
    <td>STORE_TYPE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.STORE_TYPE_DESC</td>
    <td>STORE_TYPE_DESC</td>
    <td>ZTSRP_ATTR_ACT.STORE_TYPE_DESC</td>
    <td>STORE_TYPE_DESC</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.RX_STORE</td>
    <td>RX_STORE</td>
    <td>ZTSRP_ATTR_ACT.RX_STORE</td>
    <td>RX_STORE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.RX_STORE_DESC</td>
    <td>RX_STORE_DESC</td>
    <td>ZTSRP_ATTR_ACT.RX_STORE_DESC</td>
    <td>RX_STORE_DESC</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.DISTRIBUTION_CNTR</td>
    <td>DISTRIBUTION_CNTR</td>
    <td>ZTSRP_ATTR_ACT.DISTRIBUTION_CNTR</td>
    <td>DISTRIBUTION_CNTR</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.DISTRIBUTION_CNTR_DESC</td>
    <td>DISTRIBUTION_CNTR_DESC</td>
    <td>ZTSRP_ATTR_ACT.DISTRIBUTION_CNTR_DESC</td>
    <td>DISTRIBUTION_CNTR_DESC</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.STORE_24_HR</td>
    <td>STORE_24_HR</td>
    <td>ZTSRP_ATTR_ACT.STORE_24_HR</td>
    <td>STORE_24_HR</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.BUDGET_OPEN_DAT</td>
    <td>BUDGET_OPEN_DAT</td>
    <td>ZTSRP_ATTR_ACT.BUDGET_OPEN_DAT</td>
    <td>BUDGET_OPEN_DAT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.BUDGET_CLOSED_DAT</td>
    <td>BUDGET_CLOSED_DAT</td>
    <td>ZTSRP_ATTR_ACT.BUDGET_CLOSED_DAT</td>
    <td>BUDGET_CLOSED_DAT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.BUDGET_RELOC_DAT</td>
    <td>BUDGET_RELOC_DAT</td>
    <td>ZTSRP_ATTR_ACT.BUDGET_RELOC_DAT</td>
    <td>BUDGET_RELOC_DAT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.CONST_OPEN_DAT</td>
    <td>CONST_OPEN_DAT</td>
    <td>ZTSRP_ATTR_ACT.CONST_OPEN_DAT</td>
    <td>CONST_OPEN_DAT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.CONST_CLOSE_DAT</td>
    <td>CONST_CLOSE_DAT</td>
    <td>ZTSRP_ATTR_ACT.CONST_CLOSE_DAT</td>
    <td>CONST_CLOSE_DAT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.CONST_RELO_DAT</td>
    <td>CONST_RELO_DAT</td>
    <td>ZTSRP_ATTR_ACT.CONST_RELO_DAT</td>
    <td>CONST_RELO_DAT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.RELOCATION_DAT</td>
    <td>RELOCATION_DAT</td>
    <td>ZTSRP_ATTR_ACT.RELOCATION_DAT</td>
    <td>RELOCATION_DAT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.EMERG_MKT_IND</td>
    <td>EMERG_MKT_IND</td>
    <td>ZTSRP_ATTR_ACT.EMERG_MKT_IND</td>
    <td>EMERG_MKT_IND</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.BUDGET_EMERG_MKT_IND</td>
    <td>BUDGET_EMERG_MKT_IND</td>
    <td>ZTSRP_ATTR_ACT.BUDGET_EMERG_MKT_IND</td>
    <td>BUDGET_EMERG_MKT_IND</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.COMPANY_CODE</td>
    <td>COMPANY_CODE</td>
    <td>ZTSRP_ATTR_ACT.COMPANY_CODE</td>
    <td>COMPANY_CODE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.COMPANY_CODE_DESC</td>
    <td>COMPANY_CODE_DESC</td>
    <td>ZTSRP_ATTR_ACT.COMPANY_CODE_DESC</td>
    <td>COMPANY_CODE_DESC</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.ORIGINAL_FS_OPEN_DAT</td>
    <td>ORIGINAL_FS_OPEN_DAT</td>
    <td>ZTSRP_ATTR_ACT.ORIGINAL_FS_OPEN_DAT</td>
    <td>ORIGINAL_FS_OPEN_DAT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.ORIGINAL_RX_OPEN_DAT</td>
    <td>ORIGINAL_RX_OPEN_DAT</td>
    <td>ZTSRP_ATTR_ACT.ORIGINAL_RX_OPEN_DAT</td>
    <td>ORIGINAL_RX_OPEN_DAT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.GROUP_ONE</td>
    <td>GROUP_ONE</td>
    <td>ZTSRP_ATTR_ACT.GROUP_ONE</td>
    <td>GROUP_ONE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.GROUP_TWO</td>
    <td>GROUP_TWO</td>
    <td>ZTSRP_ATTR_ACT.GROUP_TWO</td>
    <td>GROUP_TWO</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.ARD_SORT_KEY</td>
    <td>ARD_SORT_KEY</td>
    <td>ZTSRP_ATTR_ACT.ARD_SORT_KEY</td>
    <td>ARD_SORT_KEY</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.AREA_COST_CENTER</td>
    <td>AREA_COST_CENTER</td>
    <td>ZTSRP_ATTR_ACT.AREA_COST_CENTER</td>
    <td>AREA_COST_CENTER</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.REGIION_COST_CENTER</td>
    <td>REGIION_COST_CENTER</td>
    <td>ZTSRP_ATTR_ACT.REGIION_COST_CENTER</td>
    <td>REGIION_COST_CENTER</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.COUNTY_CODE</td>
    <td>COUNTY_CODE</td>
    <td>ZTSRP_ATTR_ACT.COUNTY_CODE</td>
    <td>COUNTY_CODE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.COUNTY_DESC</td>
    <td>COUNTY_DESC</td>
    <td>ZTSRP_ATTR_ACT.COUNTY_DESC</td>
    <td>COUNTY_DESC</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.RETAIL_SQFT_AMT</td>
    <td>RETAIL_SQFT_AMT</td>
    <td>ZTSRP_ATTR_ACT.RETAIL_SQFT_AMT</td>
    <td>RETAIL_SQFT_AMT</td>
    <td>Aggregation: SUM</td>
  </tr>
  <tr>
    <td>Projection_1.TOTAL_SQFT_AMT</td>
    <td>TOTAL_SQFT_AMT</td>
    <td>ZTSRP_ATTR_ACT.TOTAL_SQFT_AMT</td>
    <td>TOTAL_SQFT_AMT</td>
    <td>Aggregation: SUM</td>
  </tr>
  <tr>
    <td>Projection_1.SQFT_BRACKET_DESC</td>
    <td>SQFT_BRACKET_DESC</td>
    <td>ZTSRP_ATTR_ACT.SQFT_BRACKET_DESC</td>
    <td>SQFT_BRACKET_DESC</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.SQFT_SORT_KEY</td>
    <td>SQFT_SORT_KEY</td>
    <td>ZTSRP_ATTR_ACT.SQFT_SORT_KEY</td>
    <td>SQFT_SORT_KEY</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.ACQUISITION_CODE</td>
    <td>ACQUISITION_CODE</td>
    <td>ZTSRP_ATTR_ACT.ACQUISITION_CODE</td>
    <td>ACQUISITION_CODE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.ACQUISITION_DESC</td>
    <td>ACQUISITION_DESC</td>
    <td>ZTSRP_ATTR_ACT.ACQUISITION_DESC</td>
    <td>ACQUISITION_DESC</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.PHOTO_LAB_ADD_DAT</td>
    <td>PHOTO_LAB_ADD_DAT</td>
    <td>ZTSRP_ATTR_ACT.PHOTO_LAB_ADD_DAT</td>
    <td>PHOTO_LAB_ADD_DAT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.PHOTO_LAB_CLOSE_DAT</td>
    <td>PHOTO_LAB_CLOSE_DAT</td>
    <td>ZTSRP_ATTR_ACT.PHOTO_LAB_CLOSE_DAT</td>
    <td>PHOTO_LAB_CLOSE_DAT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.MIN_HRS_IND</td>
    <td>MIN_HRS_IND</td>
    <td>ZTSRP_ATTR_ACT.MIN_HRS_IND</td>
    <td>MIN_HRS_IND</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.CREATEDBY</td>
    <td>CREATEDBY</td>
    <td>ZTSRP_ATTR_ACT.CREATEDBY</td>
    <td>CREATEDBY</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.CREATED_ON</td>
    <td>CREATED_ON</td>
    <td>ZTSRP_ATTR_ACT.CREATED_ON</td>
    <td>CREATED_ON</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.RX_DIVISION_CODE</td>
    <td>RX_DIVISION_CODE</td>
    <td>ZTSRP_ATTR_ACT.RX_DIVISION_CODE</td>
    <td>RX_DIVISION_CODE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.RX_AREA_CODE</td>
    <td>RX_AREA_CODE</td>
    <td>ZTSRP_ATTR_ACT.RX_AREA_CODE</td>
    <td>RX_AREA_CODE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.RX_REGION_CODE</td>
    <td>RX_REGION_CODE</td>
    <td>ZTSRP_ATTR_ACT.RX_REGION_CODE</td>
    <td>RX_REGION_CODE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.RX_DISTRICT_CODE</td>
    <td>RX_DISTRICT_CODE</td>
    <td>ZTSRP_ATTR_ACT.RX_DISTRICT_CODE</td>
    <td>RX_DISTRICT_CODE</td>
    <td>Direct mapping</td>
  </tr>
</table>
<br/>

<!-- 5. Complexity Analysis -->
<table style="width:100%; border-collapse:collapse;">
  <tr style="background:#e3e8ee;">
    <th>Category</th>
    <th>Measurement</th>
  </tr>
  <tr><td>Number of Objects/Nodes</td><td>3 (Data Source, Projection Node, Logical Model/Output)</td></tr>
  <tr><td>Sources Used</td><td>1 (ZTSRP_ATTR_ACT)</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>SUM (RX_HRS_OPER, FS_HRS_OPER, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT)</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>MANDT filter (IN 120, 200)</td></tr>
  <tr><td>Workflow Complexity</td><td>Simple linear workflow (Source → Projection → Output)</td></tr>
  <tr><td>Performance Considerations</td><td>Single source, filter on MANDT, basic aggregation</td></tr>
  <tr><td>Data Volume Handling</td><td>Filter on MANDT restricts volume; no explicit handling otherwise</td></tr>
  <tr><td>Dependency Complexity</td><td>Low (single table dependency)</td></tr>
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
<br/>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD