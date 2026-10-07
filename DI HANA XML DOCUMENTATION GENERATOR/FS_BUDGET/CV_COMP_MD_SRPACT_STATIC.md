<!-- DOCUMENT HEADER -->
<table style="width:100%;border-collapse:collapse;margin-bottom:16px;">
  <tr>
    <td style="font-weight:bold;width:20%;">Author:</td>
    <td>Ascendion AAVA</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Created On:</td>
    <td>2026-10-07</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Description:</td>
    <td>Technical documentation for HANA Calculation View <b>CV_COMP_MD_SRPACT_STATIC</b>, a wrapper view on snapshot table <b>TBL_WSS_SRP_ATTR_ACT</b> for Store Profile - Attributes Actuals. The view exposes store-related attributes and aggregates operational measures.</td>
  </tr>
</table>

<!-- 1. Overview of Program -->
<p><b>Overview of Program:</b><br>
This HANA XML defines a Calculation View of type <b>CUBE</b> named <b>CV_COMP_MD_SRPACT_STATIC</b>. Its primary purpose is to provide a reporting-enabled wrapper on the snapshot table <b>TBL_WSS_SRP_ATTR_ACT</b>, exposing store profile attributes and aggregating operational measures. The view performs a projection of all columns from the source table and applies aggregation to selected measures.</p>

<!-- 2. Code Structure and Design -->
<p>
<b>Structure:</b> The Calculation View is structured as a single projection node (<b>Projection_1</b>) referencing the CDS artifact <b>TBL_WSS_SRP_ATTR_ACT</b>. All attributes and measures are mapped directly from the source, with no calculated fields, joins, unions, or filters present. <br>
<b>Key Components:</b> The main components include the <b>dataSource</b> (<b>TBL_WSS_SRP_ATTR_ACT</b>), the <b>Projection_1</b> node, a logical model defining attributes and measures, and aggregation logic for measures. <br>
<b>Dependencies & Performance:</b> The only dependency is the referenced table <b>TBL_WSS_SRP_ATTR_ACT</b>. Aggregation is performed on five measures, and no joins, filters, or complex processing logic are present. The view is reporting-enabled and does not enforce SQL execution, indicating standard Calculation View processing.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;background:#fafafa;padding:16px;border-radius:8px;max-width:100vw;">
  <div style="display:grid;grid-template-columns:repeat(4,180px);grid-template-rows:repeat(2,100px);gap:40px;align-items:center;justify-content:start;">
    <div style="grid-column:1;grid-row:1;background:#e3e7f1;border-radius:8px;padding:16px;text-align:center;font-weight:bold;border:1px solid #bfc7d5;">TBL_WSS_SRP_ATTR_ACT<br><span style="font-size:smaller;color:#555;">(CDS Artifact)</span></div>
    <div style="grid-column:2;grid-row:1;background:#e8f5e9;border-radius:8px;padding:16px;text-align:center;font-weight:bold;border:1px solid #bfc7d5;">Projection_1<br><span style="font-size:smaller;color:#555;">(Projection Node)</span></div>
    <div style="grid-column:3;grid-row:1;background:#fff3e0;border-radius:8px;padding:16px;text-align:center;font-weight:bold;border:1px solid #bfc7d5;">Logical Model<br><span style="font-size:smaller;color:#555;">(Attributes & Measures)</span></div>
    <div style="grid-column:4;grid-row:1;background:#f0f4c3;border-radius:8px;padding:16px;text-align:center;font-weight:bold;border:1px solid #bfc7d5;">Output View<br><span style="font-size:smaller;color:#555;">(Aggregation)</span></div>
    <div style="grid-column:1;grid-row:2;justify-self:center;width:0;height:0;border-left:20px solid transparent;border-right:20px solid transparent;border-top:20px solid #bfc7d5;"></div>
    <div style="grid-column:2;grid-row:2;justify-self:center;width:0;height:0;border-left:20px solid transparent;border-right:20px solid transparent;border-top:20px solid #bfc7d5;"></div>
    <div style="grid-column:3;grid-row:2;justify-self:center;width:0;height:0;border-left:20px solid transparent;border-right:20px solid transparent;border-top:20px solid #bfc7d5;"></div>
  </div>
  <div style="position:relative;top:-60px;left:80px;width:calc(180px * 3 + 120px);height:60px;">
    <svg width="720" height="60">
      <defs>
        <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
          <polygon points="0 0, 10 3.5, 0 7" fill="#bfc7d5" />
        </marker>
      </defs>
      <line x1="90" y1="30" x2="270" y2="30" stroke="#bfc7d5" stroke-width="2" marker-end="url(#arrowhead)" />
      <line x1="270" y1="30" x2="450" y2="30" stroke="#bfc7d5" stroke-width="2" marker-end="url(#arrowhead)" />
      <line x1="450" y1="30" x2="630" y2="30" stroke="#bfc7d5" stroke-width="2" marker-end="url(#arrowhead)" />
    </svg>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%;border-collapse:collapse;margin-bottom:16px;">
  <thead style="background:#e3e7f1;">
    <tr>
      <th>Target Object/Field Name</th>
      <th>Target Column Name</th>
      <th>Source Object/Field Name</th>
      <th>Source Column Name</th>
      <th>Remarks</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>Projection_1.MANDT</td><td>MANDT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>MANDT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.STRNUM</td><td>STRNUM</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>STRNUM</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.PRCTR</td><td>PRCTR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>PRCTR</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.KOKRS</td><td>KOKRS</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>KOKRS</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.KOSTL</td><td>KOSTL</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>KOSTL</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.RX_OPEN_DAT</td><td>RX_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_OPEN_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.RX_CLOSE_DAT</td><td>RX_CLOSE_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_CLOSE_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.RX_HRS_OPER</td><td>RX_HRS_OPER</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_HRS_OPER</td><td>Aggregation: sum</td></tr>
    <tr><td>Projection_1.FS_OPEN_DAT</td><td>FS_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>FS_OPEN_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.FS_CLOSE_DAT</td><td>FS_CLOSE_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>FS_CLOSE_DAT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.FS_HRS_OPER</td><td>FS_HRS_OPER</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>FS_HRS_OPER</td><td>Aggregation: sum</td></tr>
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
    <tr><td>Projection_1.RX_STORE</td><td>RX_STORE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_STORE</td><td>Aggregation: sum</td></tr>
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
    <tr><td>Projection_1.RETAIL_SQFT_AMT</td><td>RETAIL_SQFT_AMT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RETAIL_SQFT_AMT</td><td>Aggregation: sum</td></tr>
    <tr><td>Projection_1.TOTAL_SQFT_AMT</td><td>TOTAL_SQFT_AMT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>TOTAL_SQFT_AMT</td><td>Aggregation: sum</td></tr>
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
  </tbody>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%;border-collapse:collapse;margin-bottom:16px;">
  <thead style="background:#e3e7f1;">
    <tr>
      <th>Category</th>
      <th>Measurement</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>Number of Objects/Nodes</td><td>2 (Projection_1 node, Logical Model)</td></tr>
    <tr><td>Sources Used</td><td>1 (TBL_WSS_SRP_ATTR_ACT)</td></tr>
    <tr><td>Joins</td><td>None identified</td></tr>
    <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
    <tr><td>Aggregate Functions</td><td>5 (sum aggregation on RX_HRS_OPER, FS_HRS_OPER, RX_STORE, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT)</td></tr>
    <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
    <tr><td>Conditional Logic</td><td>None identified</td></tr>
    <tr><td>Workflow Complexity</td><td>Low (single projection, direct mapping, simple aggregation)</td></tr>
    <tr><td>Performance Considerations</td><td>Direct mapping and aggregation; no joins or filters; dependency on source table performance</td></tr>
    <tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
    <tr><td>Dependency Complexity</td><td>Low (single source dependency)</td></tr>
    <tr><td>Overall Complexity Score</td><td>Low</td></tr>
  </tbody>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>All store profile attributes from TBL_WSS_SRP_ATTR_ACT (as mapped in Projection_1)</li>
  <li>Aggregated measures: RX_HRS_OPER, FS_HRS_OPER, RX_STORE, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
