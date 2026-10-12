<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse;">
  <tr>
    <td style="font-weight:bold;">Author:</td>
    <td>Ascendion AAVA</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Created On:</td>
    <td>2026-10-12</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Description:</td>
    <td>This documentation describes the HANA Calculation View <b>CV_COMP_MD_SRPACT_STATIC</b>, which serves as a wrapper view on the snapshot table for Store Profile - Attributes Actuals. The view is defined as a cube-type calculation scenario with reporting enabled and utilizes a single CDS artifact as its data source.</td>
  </tr>
</table>

<!-- 1. Overview of Program -->
<p>
<b>Type:</b> Calculation View<br>
<b>Purpose:</b> Provides a reporting-enabled wrapper on the snapshot table <b>TBL_WSS_SRP_ATTR_ACT</b> for store profile attribute actuals.<br>
<b>Functionality:</b> The view projects fields and measures from the underlying CDS artifact, exposing them for aggregation and reporting without additional calculated fields or joins.
</p>

<!-- 2. Code Structure and Design -->
<p>
<b>Structure:</b> The Calculation View consists of a single projection node (<b>Projection_1</b>) that sources all fields from the CDS artifact <b>TBL_WSS_SRP_ATTR_ACT</b>. The structure includes a logical model that defines attributes and measures, with aggregation functions applied to measures. No joins, unions, filters, calculated fields, or variable mappings are present, and the view outputs all mapped fields directly.
<br>
<b>Key Components:</b> The main components are the CDS artifact <b>TBL_WSS_SRP_ATTR_ACT</b> as the data source, the projection node <b>Projection_1</b>, and the logical model specifying attributes and measures. Measures are aggregated using the sum function, and all fields are mapped directly from the source to the output.
<br>
<b>Dependencies & Performance:</b> The Calculation View depends solely on the referenced CDS artifact <b>CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT</b>. No performance-impacting joins or calculated expressions are present. Aggregation is performed on selected measures, and the scenario is optimized for reporting by exposing all relevant fields.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; padding:10px; background:#fafafa; border:1px solid #ddd;">
  <div style="display:grid; grid-template-columns:repeat(3, 220px); grid-template-rows:repeat(3, 80px); gap:40px; align-items:center; justify-items:center;">
    <!-- Data Source -->
    <div style="grid-column:2; grid-row:1; background:#e3e8f2; border-radius:8px; box-shadow:0 2px 8px #e3e8f2; padding:18px; text-align:center; font-weight:bold;">CDS Artifact<br>TBL_WSS_SRP_ATTR_ACT</div>
    <!-- Arrow -->
    <div style="grid-column:2; grid-row:2; text-align:center;">
      <svg width="40" height="40">
        <defs>
          <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
            <polygon points="0 0, 10 3.5, 0 7" fill="#34495e"/>
          </marker>
        </defs>
        <line x1="20" y1="0" x2="20" y2="40" stroke="#34495e" stroke-width="3" marker-end="url(#arrowhead)"/>
      </svg>
    </div>
    <!-- Projection Node -->
    <div style="grid-column:2; grid-row:3; background:#f0f7e8; border-radius:8px; box-shadow:0 2px 8px #f0f7e8; padding:18px; text-align:center; font-weight:bold;">Projection_1<br>(All Fields Projected)</div>
    <!-- Arrow to Output -->
    <div style="grid-column:2; grid-row:4; text-align:center;">
      <svg width="40" height="40">
        <defs>
          <marker id="arrowhead2" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
            <polygon points="0 0, 10 3.5, 0 7" fill="#27ae60"/>
          </marker>
        </defs>
        <line x1="20" y1="0" x2="20" y2="40" stroke="#27ae60" stroke-width="3" marker-end="url(#arrowhead2)"/>
      </svg>
    </div>
    <!-- Output -->
    <div style="grid-column:2; grid-row:5; background:#f9e3e3; border-radius:8px; box-shadow:0 2px 8px #f9e3e3; padding:18px; text-align:center; font-weight:bold;">Output<br>(Aggregated View Fields & Measures)</div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="6" style="border-collapse:collapse; width:100%; background:#fff;">
  <thead style="background:#f2f2f2;">
    <tr>
      <th>Target Object/Field Name</th>
      <th>Target Column Name</th>
      <th>Source Object/Field Name</th>
      <th>Source Column Name</th>
      <th>Remarks</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>Projection_1.MANDT</td><td>MANDT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>MANDT</td><td>Direct mapping (Client)</td></tr>
    <tr><td>Projection_1.STRNUM</td><td>STRNUM</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>STRNUM</td><td>Direct mapping (Store Number)</td></tr>
    <tr><td>Projection_1.PRCTR</td><td>PRCTR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>PRCTR</td><td>Direct mapping (Profit Center)</td></tr>
    <tr><td>Projection_1.KOKRS</td><td>KOKRS</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>KOKRS</td><td>Direct mapping (Controlling Area)</td></tr>
    <tr><td>Projection_1.KOSTL</td><td>KOSTL</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>KOSTL</td><td>Direct mapping (Cost Center)</td></tr>
    <tr><td>Projection_1.RX_OPEN_DAT</td><td>RX_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_OPEN_DAT</td><td>Direct mapping (Pharmacy Open Date)</td></tr>
    <tr><td>Projection_1.RX_CLOSE_DAT</td><td>RX_CLOSE_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_CLOSE_DAT</td><td>Direct mapping (Pharmacy Close Date)</td></tr>
    <tr><td>Projection_1.RX_HRS_OPER</td><td>RX_HRS_OPER</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_HRS_OPER</td><td>Aggregated (sum) Pharmacy Hours of Operation</td></tr>
    <tr><td>Projection_1.FS_OPEN_DAT</td><td>FS_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>FS_OPEN_DAT</td><td>Direct mapping (Front Store Open Date)</td></tr>
    <tr><td>Projection_1.FS_CLOSE_DAT</td><td>FS_CLOSE_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>FS_CLOSE_DAT</td><td>Direct mapping (Front Store Close Date)</td></tr>
    <tr><td>Projection_1.FS_HRS_OPER</td><td>FS_HRS_OPER</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>FS_HRS_OPER</td><td>Aggregated (sum) Front Store Hours of Operation</td></tr>
    <tr><td>Projection_1.REP_MKT_CODE</td><td>REP_MKT_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>REP_MKT_CODE</td><td>Direct mapping (Report Market Code)</td></tr>
    <tr><td>Projection_1.REP_MKT_DESC</td><td>REP_MKT_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>REP_MKT_DESC</td><td>Direct mapping (Report Market Description)</td></tr>
    <tr><td>Projection_1.ADDRESS</td><td>ADDRESS</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ADDRESS</td><td>Direct mapping (Address)</td></tr>
    <tr><td>Projection_1.CITY</td><td>CITY</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>CITY</td><td>Direct mapping (City)</td></tr>
    <tr><td>Projection_1.STATE</td><td>STATE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>STATE</td><td>Direct mapping (State)</td></tr>
    <tr><td>Projection_1.ZIPCODE</td><td>ZIPCODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ZIPCODE</td><td>Direct mapping (Zipcode)</td></tr>
    <tr><td>Projection_1.DIVISION_CODE</td><td>DIVISION_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DIVISION_CODE</td><td>Direct mapping (Division Code)</td></tr>
    <tr><td>Projection_1.DIVISION_DESC</td><td>DIVISION_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DIVISION_DESC</td><td>Direct mapping (Division Description)</td></tr>
    <tr><td>Projection_1.DIVISION_MGR</td><td>DIVISION_MGR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DIVISION_MGR</td><td>Direct mapping (Division Manager)</td></tr>
    <tr><td>Projection_1.AREA_CODE</td><td>AREA_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>AREA_CODE</td><td>Direct mapping (Area Code)</td></tr>
    <tr><td>Projection_1.AREA_DESC</td><td>AREA_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>AREA_DESC</td><td>Direct mapping (Area Description)</td></tr>
    <tr><td>Projection_1.AREA_MGR</td><td>AREA_MGR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>AREA_MGR</td><td>Direct mapping (Area Manager)</td></tr>
    <tr><td>Projection_1.REGION_CODE</td><td>REGION_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>REGION_CODE</td><td>Direct mapping (Region Code)</td></tr>
    <tr><td>Projection_1.REGION_DESC</td><td>REGION_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>REGION_DESC</td><td>Direct mapping (Region Description)</td></tr>
    <tr><td>Projection_1.REGION_MGR</td><td>REGION_MGR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>REGION_MGR</td><td>Direct mapping (Region Manager)</td></tr>
    <tr><td>Projection_1.DISTRICT_CODE</td><td>DISTRICT_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRICT_CODE</td><td>Direct mapping (District Code)</td></tr>
    <tr><td>Projection_1.DISTRICT_DESC</td><td>DISTRICT_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRICT_DESC</td><td>Direct mapping (District Description)</td></tr>
    <tr><td>Projection_1.ZONE_CODE</td><td>ZONE_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ZONE_CODE</td><td>Direct mapping (Zone Code)</td></tr>
    <tr><td>Projection_1.DISTRICT_MGR</td><td>DISTRICT_MGR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRICT_MGR</td><td>Direct mapping (District Manager)</td></tr>
    <tr><td>Projection_1.ZONE_DESC</td><td>ZONE_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ZONE_DESC</td><td>Direct mapping (Zone Description)</td></tr>
    <tr><td>Projection_1.MAJOR_REGION_CODE</td><td>MAJOR_REGION_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>MAJOR_REGION_CODE</td><td>Direct mapping (Major Region Code)</td></tr>
    <tr><td>Projection_1.MAJOR_REGION</td><td>MAJOR_REGION</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>MAJOR_REGION</td><td>Direct mapping (Major Region Description)</td></tr>
    <tr><td>Projection_1.STORE_TYPE</td><td>STORE_TYPE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>STORE_TYPE</td><td>Direct mapping (Store Type)</td></tr>
    <tr><td>Projection_1.STORE_TYPE_DESC</td><td>STORE_TYPE_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>STORE_TYPE_DESC</td><td>Direct mapping (Store Type Description)</td></tr>
    <tr><td>Projection_1.RX_STORE</td><td>RX_STORE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_STORE</td><td>Aggregated (sum) Pharmacy Store</td></tr>
    <tr><td>Projection_1.RX_STORE_DESC</td><td>RX_STORE_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_STORE_DESC</td><td>Direct mapping (Pharmacy Store Description)</td></tr>
    <tr><td>Projection_1.DISTRIBUTION_CNTR</td><td>DISTRIBUTION_CNTR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRIBUTION_CNTR</td><td>Direct mapping (Distribution Center)</td></tr>
    <tr><td>Projection_1.DISTRIBUTION_CNTR_DESC</td><td>DISTRIBUTION_CNTR_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRIBUTION_CNTR_DESC</td><td>Direct mapping (Distribution Center Description)</td></tr>
    <tr><td>Projection_1.STORE_24_HR</td><td>STORE_24_HR</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>STORE_24_HR</td><td>Direct mapping (24 Hour Store)</td></tr>
    <tr><td>Projection_1.BUDGET_OPEN_DAT</td><td>BUDGET_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>BUDGET_OPEN_DAT</td><td>Direct mapping (Budget Open Date)</td></tr>
    <tr><td>Projection_1.BUDGET_CLOSED_DAT</td><td>BUDGET_CLOSED_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>BUDGET_CLOSED_DAT</td><td>Direct mapping (Budget Closed Date)</td></tr>
    <tr><td>Projection_1.BUDGET_RELOC_DAT</td><td>BUDGET_RELOC_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>BUDGET_RELOC_DAT</td><td>Direct mapping (Budget Relo Date)</td></tr>
    <tr><td>Projection_1.CONST_OPEN_DAT</td><td>CONST_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>CONST_OPEN_DAT</td><td>Direct mapping (Construction Open Date)</td></tr>
    <tr><td>Projection_1.CONST_CLOSE_DAT</td><td>CONST_CLOSE_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>CONST_CLOSE_DAT</td><td>Direct mapping (Construction Close Date)</td></tr>
    <tr><td>Projection_1.CONST_RELO_DAT</td><td>CONST_RELO_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>CONST_RELO_DAT</td><td>Direct mapping (Construction Relo Date)</td></tr>
    <tr><td>Projection_1.RELOCATION_DAT</td><td>RELOCATION_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RELOCATION_DAT</td><td>Direct mapping (Relocation Date)</td></tr>
    <tr><td>Projection_1.EMERG_MKT_IND</td><td>EMERG_MKT_IND</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>EMERG_MKT_IND</td><td>Direct mapping (Emerging Market Indicator)</td></tr>
    <tr><td>Projection_1.BUDGET_EMERG_MKT_IND</td><td>BUDGET_EMERG_MKT_IND</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>BUDGET_EMERG_MKT_IND</td><td>Direct mapping (Budget Emerging Market Indicator)</td></tr>
    <tr><td>Projection_1.COMPANY_CODE</td><td>COMPANY_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>COMPANY_CODE</td><td>Direct mapping (Company Code)</td></tr>
    <tr><td>Projection_1.COMPANY_CODE_DESC</td><td>COMPANY_CODE_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>COMPANY_CODE_DESC</td><td>Direct mapping (Company Code Description)</td></tr>
    <tr><td>Projection_1.ORIGINAL_FS_OPEN_DAT</td><td>ORIGINAL_FS_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ORIGINAL_FS_OPEN_DAT</td><td>Direct mapping (Original Front Store Open Date)</td></tr>
    <tr><td>Projection_1.ORIGINAL_RX_OPEN_DAT</td><td>ORIGINAL_RX_OPEN_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ORIGINAL_RX_OPEN_DAT</td><td>Direct mapping (Original Pharmacy Open Date)</td></tr>
    <tr><td>Projection_1.GROUP_ONE</td><td>GROUP_ONE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>GROUP_ONE</td><td>Direct mapping (Group One)</td></tr>
    <tr><td>Projection_1.GROUP_TWO</td><td>GROUP_TWO</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>GROUP_TWO</td><td>Direct mapping (Group Two)</td></tr>
    <tr><td>Projection_1.ARD_SORT_KEY</td><td>ARD_SORT_KEY</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ARD_SORT_KEY</td><td>Direct mapping (ARD Sort Key)</td></tr>
    <tr><td>Projection_1.AREA_COST_CENTER</td><td>AREA_COST_CENTER</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>AREA_COST_CENTER</td><td>Direct mapping (Area Cost Center)</td></tr>
    <tr><td>Projection_1.REGIION_COST_CENTER</td><td>REGIION_COST_CENTER</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>REGIION_COST_CENTER</td><td>Direct mapping (Region Cost Center)</td></tr>
    <tr><td>Projection_1.COUNTY_CODE</td><td>COUNTY_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>COUNTY_CODE</td><td>Direct mapping (County Code)</td></tr>
    <tr><td>Projection_1.COUNTY_DESC</td><td>COUNTY_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>COUNTY_DESC</td><td>Direct mapping (County Description)</td></tr>
    <tr><td>Projection_1.RETAIL_SQFT_AMT</td><td>RETAIL_SQFT_AMT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RETAIL_SQFT_AMT</td><td>Aggregated (sum) Retail Sq.Ft Amount</td></tr>
    <tr><td>Projection_1.TOTAL_SQFT_AMT</td><td>TOTAL_SQFT_AMT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>TOTAL_SQFT_AMT</td><td>Aggregated (sum) Total Sq.Ft Amount</td></tr>
    <tr><td>Projection_1.SQFT_BRACKET_DESC</td><td>SQFT_BRACKET_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>SQFT_BRACKET_DESC</td><td>Direct mapping (Sq.Ft Bracket Description)</td></tr>
    <tr><td>Projection_1.SQFT_SORT_KEY</td><td>SQFT_SORT_KEY</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>SQFT_SORT_KEY</td><td>Direct mapping (Sq.Ft Sort Key)</td></tr>
    <tr><td>Projection_1.ACQUISITION_CODE</td><td>ACQUISITION_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ACQUISITION_CODE</td><td>Direct mapping (Acquisition Code)</td></tr>
    <tr><td>Projection_1.ACQUISITION_DESC</td><td>ACQUISITION_DESC</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>ACQUISITION_DESC</td><td>Direct mapping (Acquisition Description)</td></tr>
    <tr><td>Projection_1.PHOTO_LAB_ADD_DAT</td><td>PHOTO_LAB_ADD_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>PHOTO_LAB_ADD_DAT</td><td>Direct mapping (Photo Lab Add Date)</td></tr>
    <tr><td>Projection_1.PHOTO_LAB_CLOSE_DAT</td><td>PHOTO_LAB_CLOSE_DAT</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>PHOTO_LAB_CLOSE_DAT</td><td>Direct mapping (Photo Lab Close Date)</td></tr>
    <tr><td>Projection_1.MIN_HRS_IND</td><td>MIN_HRS_IND</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>MIN_HRS_IND</td><td>Direct mapping (Minimum Hours Indicator)</td></tr>
    <tr><td>Projection_1.CREATEDBY</td><td>CREATEDBY</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>CREATEDBY</td><td>Direct mapping (Created By)</td></tr>
    <tr><td>Projection_1.CREATED_ON</td><td>CREATED_ON</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>CREATED_ON</td><td>Direct mapping (Created On)</td></tr>
    <tr><td>Projection_1.RX_DIVISION_CODE</td><td>RX_DIVISION_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_DIVISION_CODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.RX_AREA_CODE</td><td>RX_AREA_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_AREA_CODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.RX_REGION_CODE</td><td>RX_REGION_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_REGION_CODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.RX_DISTRICT_CODE</td><td>RX_DISTRICT_CODE</td><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_DISTRICT_CODE</td><td>Direct mapping</td></tr>
  </tbody>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="6" style="border-collapse:collapse; width:100%; background:#fff;">
  <tr><td>Number of Objects/Nodes</td><td>2 (CDS Artifact, Projection Node)</td></tr>
  <tr><td>Sources Used</td><td>1 (TBL_WSS_SRP_ATTR_ACT)</td></tr>
  <tr><td>Joins</td><td>0</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>Sum aggregation on measures (RX_HRS_OPER, FS_HRS_OPER, RX_STORE, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT)</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>None identified</td></tr>
  <tr><td>Workflow Complexity</td><td>Simple linear flow: Source &rarr; Projection &rarr; Output</td></tr>
  <tr><td>Performance Considerations</td><td>Single source, no joins, sum aggregation; optimized for reporting</td></tr>
  <tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single CDS artifact dependency</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>All projected attributes and measures from TBL_WSS_SRP_ATTR_ACT via Projection_1</li>
  <li>Aggregated measures: RX_HRS_OPER, FS_HRS_OPER, RX_STORE, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT</li>
  <li>Directly mapped fields for store profile attributes actuals</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
