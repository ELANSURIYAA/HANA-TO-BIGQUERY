<!-- DOCUMENT HEADER -->
<table style="width:100%;border-collapse:collapse;margin-bottom:16px;">
  <tr>
    <td style="width:25%;font-weight:bold;">Author:</td>
    <td>Ascendion AAVA</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Created On:</td>
    <td>2026-10-12</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Description:</td>
    <td>HANA Calculation View <b>CV_BASE_MD_SRPACT_S4</b> defines a base view for the object ZTSRP_ATTR_ACT, modeling store profile attributes for actuals. Its structure, mappings, and processing logic are entirely derived from the input HANA XML.</td>
  </tr>
</table>

<!-- 1. Overview of Program -->
<p><b>Overview of Program:</b><br>
This object is a HANA Calculation View of type TREE_BASED and data category CUBE. It provides a base aggregation and projection layer for store profile attribute actuals sourced from the ZTSRP_ATTR_ACT table. The view models a single projection node with direct mappings and filtered output, suitable for reporting enablement.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View CV_BASE_MD_SRPACT_S4 is structured with a single projection node (Projection_1) sourcing data from the base table ZTSRP_ATTR_ACT. The projection defines explicit view attributes and measures, with direct attribute mappings and a filter applied to the MANDT field. The logical model specifies output attributes and measures, including aggregation definitions, but no calculated or restricted fields.<br>
<b>Key Components:</b> Major components include the data source (ZTSRP_ATTR_ACT), the Projection_1 node, attribute and measure mappings, logical model definitions, and aggregation specifications. The output is organized as an Aggregation view with reporting enabled.<br>
<b>Dependencies & Performance:</b> The view depends on the ZTSRP_ATTR_ACT table within the schema SAP_S4. No joins, unions, or nested nodes are present. Performance-relevant characteristics include SUM aggregation on select measures and an IN filter on MANDT. No calculated fields or complex expressions are defined.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;background:#fafbfc;padding:24px 0;border-radius:12px;">
  <div style="display:grid;grid-template-columns:repeat(3,160px);grid-template-rows:repeat(2,80px);align-items:center;justify-items:center;gap:32px;">
    <!-- Data Source -->
    <div style="grid-column:1;grid-row:1;background:#e3f2fd;border-radius:8px;border:1px solid #90caf9;padding:16px;text-align:center;font-weight:bold;">ZTSRP_ATTR_ACT<br><span style="font-size:11px;font-weight:normal;">(DATA_BASE_TABLE)</span></div>
    <!-- Arrow -->
    <div style="grid-column:2;grid-row:1;text-align:center;">
      <svg width="60" height="40"><line x1="0" y1="20" x2="60" y2="20" stroke="#1976d2" stroke-width="2" marker-end="url(#arrowhead)"/><defs><marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#1976d2"/></marker></defs></svg>
    </div>
    <!-- Projection Node -->
    <div style="grid-column:3;grid-row:1;background:#fffde7;border-radius:8px;border:1px solid #ffe082;padding:16px;text-align:center;font-weight:bold;">Projection_1<br><span style="font-size:11px;font-weight:normal;">(Projection Node)<br>Filter: MANDT IN (120, 200)</span></div>
    <!-- Arrow -->
    <div style="grid-column:2;grid-row:2;text-align:center;">
      <svg width="60" height="40"><line x1="0" y1="20" x2="60" y2="20" stroke="#388e3c" stroke-width="2" marker-end="url(#arrowhead2)"/><defs><marker id="arrowhead2" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#388e3c"/></marker></defs></svg>
    </div>
    <!-- Output -->
    <div style="grid-column:3;grid-row:2;background:#e8f5e9;border-radius:8px;border:1px solid #81c784;padding:16px;text-align:center;font-weight:bold;">Output<br><span style="font-size:11px;font-weight:normal;">Aggregation View<br>Attributes & Measures</span></div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%;border-collapse:collapse;margin-top:16px;">
  <thead style="background:#f5f5f5;">
    <tr>
      <th style="border:1px solid #ccc;padding:8px;">Target Object/Field Name</th>
      <th style="border:1px solid #ccc;padding:8px;">Target Column Name</th>
      <th style="border:1px solid #ccc;padding:8px;">Source Object/Field Name</th>
      <th style="border:1px solid #ccc;padding:8px;">Source Column Name</th>
      <th style="border:1px solid #ccc;padding:8px;">Remarks</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>MANDT</td><td>MANDT</td><td>ZTSRP_ATTR_ACT</td><td>MANDT</td><td>IN filter applied: 120, 200</td></tr>
    <tr><td>STRNUM</td><td>STRNUM</td><td>ZTSRP_ATTR_ACT</td><td>STRNUM</td><td>Direct mapping</td></tr>
    <tr><td>PRCTR</td><td>PRCTR</td><td>ZTSRP_ATTR_ACT</td><td>PRCTR</td><td>Direct mapping</td></tr>
    <tr><td>KOKRS</td><td>KOKRS</td><td>ZTSRP_ATTR_ACT</td><td>KOKRS</td><td>Direct mapping</td></tr>
    <tr><td>KOSTL</td><td>KOSTL</td><td>ZTSRP_ATTR_ACT</td><td>KOSTL</td><td>Direct mapping</td></tr>
    <tr><td>RX_OPEN_DAT</td><td>RX_OPEN_DAT</td><td>ZTSRP_ATTR_ACT</td><td>RX_OPEN_DAT</td><td>Direct mapping</td></tr>
    <tr><td>RX_CLOSE_DAT</td><td>RX_CLOSE_DAT</td><td>ZTSRP_ATTR_ACT</td><td>RX_CLOSE_DAT</td><td>Direct mapping</td></tr>
    <tr><td>RX_HRS_OPER</td><td>RX_HRS_OPER</td><td>ZTSRP_ATTR_ACT</td><td>RX_HRS_OPER</td><td>SUM aggregation</td></tr>
    <tr><td>FS_OPEN_DAT</td><td>FS_OPEN_DAT</td><td>ZTSRP_ATTR_ACT</td><td>FS_OPEN_DAT</td><td>Direct mapping</td></tr>
    <tr><td>FS_CLOSE_DAT</td><td>FS_CLOSE_DAT</td><td>ZTSRP_ATTR_ACT</td><td>FS_CLOSE_DAT</td><td>Direct mapping</td></tr>
    <tr><td>FS_HRS_OPER</td><td>FS_HRS_OPER</td><td>ZTSRP_ATTR_ACT</td><td>FS_HRS_OPER</td><td>SUM aggregation</td></tr>
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
    <tr><td>RETAIL_SQFT_AMT</td><td>RETAIL_SQFT_AMT</td><td>ZTSRP_ATTR_ACT</td><td>RETAIL_SQFT_AMT</td><td>SUM aggregation</td></tr>
    <tr><td>TOTAL_SQFT_AMT</td><td>TOTAL_SQFT_AMT</td><td>ZTSRP_ATTR_ACT</td><td>TOTAL_SQFT_AMT</td><td>SUM aggregation</td></tr>
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

<!-- 5. Complexity Analysis -->
<table style="width:100%;border-collapse:collapse;margin-top:16px;">
  <tr><td style="font-weight:bold;width:35%;border:1px solid #ccc;padding:8px;">Number of Objects/Nodes</td><td style="border:1px solid #ccc;padding:8px;">2 (Projection_1, Output)</td></tr>
  <tr><td style="font-weight:bold;border:1px solid #ccc;padding:8px;">Sources Used</td><td style="border:1px solid #ccc;padding:8px;">ZTSRP_ATTR_ACT (DATA_BASE_TABLE)</td></tr>
  <tr><td style="font-weight:bold;border:1px solid #ccc;padding:8px;">Joins</td><td style="border:1px solid #ccc;padding:8px;">None identified</td></tr>
  <tr><td style="font-weight:bold;border:1px solid #ccc;padding:8px;">Temporary/Cached Data</td><td style="border:1px solid #ccc;padding:8px;">None identified</td></tr>
  <tr><td style="font-weight:bold;border:1px solid #ccc;padding:8px;">Aggregate Functions</td><td style="border:1px solid #ccc;padding:8px;">SUM on RX_HRS_OPER, FS_HRS_OPER, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT</td></tr>
  <tr><td style="font-weight:bold;border:1px solid #ccc;padding:8px;">Data Manipulation</td><td style="border:1px solid #ccc;padding:8px;">No data manipulation identified</td></tr>
  <tr><td style="font-weight:bold;border:1px solid #ccc;padding:8px;">Conditional Logic</td><td style="border:1px solid #ccc;padding:8px;">IN filter on MANDT</td></tr>
  <tr><td style="font-weight:bold;border:1px solid #ccc;padding:8px;">Workflow Complexity</td><td style="border:1px solid #ccc;padding:8px;">Simple, linear sequence (source → projection → output)</td></tr>
  <tr><td style="font-weight:bold;border:1px solid #ccc;padding:8px;">Performance Considerations</td><td style="border:1px solid #ccc;padding:8px;">SUM aggregations; single source; filtered attribute</td></tr>
  <tr><td style="font-weight:bold;border:1px solid #ccc;padding:8px;">Data Volume Handling</td><td style="border:1px solid #ccc;padding:8px;">Not explicitly defined</td></tr>
  <tr><td style="font-weight:bold;border:1px solid #ccc;padding:8px;">Dependency Complexity</td><td style="border:1px solid #ccc;padding:8px;">Single dependency: ZTSRP_ATTR_ACT</td></tr>
  <tr><td style="font-weight:bold;border:1px solid #ccc;padding:8px;">Overall Complexity Score</td><td style="border:1px solid #ccc;padding:8px;">Low</td></tr>
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
