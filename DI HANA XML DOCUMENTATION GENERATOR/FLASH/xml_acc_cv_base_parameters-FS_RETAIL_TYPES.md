<!-- DOCUMENT HEADER -->
<table>
<tr><td><b>Author:</b></td><td>Ascendion AAVA</td></tr>
<tr><td><b>Created On:</b></td><td>2026-10-07</td></tr>
<tr><td><b>Description:</b></td><td>Technical documentation for a HANA Calculation View named <b>CV_BASE_PARAMETERS</b>. This view acts as a base projection for parameter-related data, exposing selected fields from the underlying data source for further modeling or consumption.</td></tr>
</table>
<br/>

<!-- 1. Overview of Program -->
<p>This HANA XML defines a Calculation View of type <b>DIMENSION</b> named <b>CV_BASE_PARAMETERS</b>. Its primary purpose is to project specific fields from a single database table, enabling structured access to parameter data. The view performs straightforward field mapping from the source table to the output without additional transformations or logic.</p>
<br/>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View is structured as a single projection node (<b>Projection_1</b>) that sources data from the database table <b>ZTFIRP_FLASH_PRM</b>. The view defines four output attributes: <b>MANDT</b>, <b>PARAM_NAME</b>, <b>LOW_CHAR</b>, and <b>HIGH_CHAR</b>, each mapped directly from the source or renamed source fields. No joins, unions, filters, calculated fields, or aggregations are present.<br/>
<b>Key Components:</b> The major components are the data source (<b>ZTFIRP_FLASH_PRM</b>), the projection node (<b>Projection_1</b>), and the output attributes. The logical model specifies the output structure and descriptions for each attribute.<br/>
<b>Dependencies & Performance:</b> The Calculation View depends solely on the database table <b>ZTFIRP_FLASH_PRM</b> in schema <b>SAPABAP1</b>. No joins, aggregations, or complex processing are involved, indicating low dependency and minimal performance impact.</p>
<br/>

<!-- 3. Data Flow and Processing Logic -->
<div style="width:100%;overflow-x:auto;background:#f9f9f9;padding:20px;border-radius:8px;font-family:sans-serif;">
  <div style="display:grid;grid-template-columns:repeat(3,200px);grid-template-rows:repeat(2,120px);align-items:center;justify-items:center;">
    <!-- Source Table -->
    <div style="grid-column:1;grid-row:1;background:#e3e6ee;border:1px solid #b3b6b8;border-radius:8px;padding:20px;text-align:center;font-weight:bold;">ZTFIRP_FLASH_PRM<br/><span style="font-size:smaller;">(Database Table)</span></div>
    <!-- Arrow -->
    <div style="grid-column:2;grid-row:1;text-align:center;">
      <svg width="60" height="40"><line x1="0" y1="20" x2="60" y2="20" stroke="#888" stroke-width="2"/><polygon points="60,20 50,15 50,25" style="fill:#888;"/></svg>
    </div>
    <!-- Projection Node -->
    <div style="grid-column:3;grid-row:1;background:#e3e6ee;border:1px solid #b3b6b8;border-radius:8px;padding:20px;text-align:center;font-weight:bold;">Projection_1<br/><span style="font-size:smaller;">(Projection Node)</span></div>
    <!-- Arrow Down -->
    <div style="grid-column:3;grid-row:2;text-align:center;">
      <svg width="40" height="60"><line x1="20" y1="0" x2="20" y2="60" stroke="#888" stroke-width="2"/><polygon points="20,60 15,50 25,50" style="fill:#888;"/></svg>
    </div>
    <!-- Output -->
    <div style="grid-column:3;grid-row:2;background:#d4f1d6;border:1px solid #b3b6b8;border-radius:8px;padding:20px;text-align:center;font-weight:bold;">Output<br/><span style="font-size:smaller;">MANDT, PARAM_NAME, LOW_CHAR, HIGH_CHAR</span></div>
  </div>
</div>
<br/>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="5" cellspacing="0" style="border-collapse:collapse;width:100%;">
<tr style="background:#e3e6ee;font-weight:bold;">
  <td>Target Object/Field Name</td>
  <td>Target Column Name</td>
  <td>Source Object/Field Name</td>
  <td>Source Column Name</td>
  <td>Remarks</td>
</tr>
<tr>
  <td>Projection_1 / MANDT</td>
  <td>MANDT</td>
  <td>ZTFIRP_FLASH_PRM / MANDT</td>
  <td>MANDT</td>
  <td>Direct mapping</td>
</tr>
<tr>
  <td>Projection_1 / PARAM_NAME</td>
  <td>PARAM_NAME</td>
  <td>ZTFIRP_FLASH_PRM / PARAM_NAME</td>
  <td>PARAM_NAME</td>
  <td>Direct mapping</td>
</tr>
<tr>
  <td>Projection_1 / LOW_CHAR</td>
  <td>LOW_CHAR</td>
  <td>ZTFIRP_FLASH_PRM / PARAM_VALUE_LOW</td>
  <td>PARAM_VALUE_LOW</td>
  <td>Renamed mapping</td>
</tr>
<tr>
  <td>Projection_1 / HIGH_CHAR</td>
  <td>HIGH_CHAR</td>
  <td>ZTFIRP_FLASH_PRM / PARAM_VALUE_HIGH</td>
  <td>PARAM_VALUE_HIGH</td>
  <td>Renamed mapping</td>
</tr>
</table>
<br/>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="5" cellspacing="0" style="border-collapse:collapse;width:100%;">
<tr style="background:#e3e6ee;font-weight:bold;">
  <td>Category</td>
  <td>Measurement</td>
</tr>
<tr><td>Number of Objects/Nodes</td><td>2 (Data Source, Projection Node)</td></tr>
<tr><td>Sources Used</td><td>ZTFIRP_FLASH_PRM (Database Table)</td></tr>
<tr><td>Joins</td><td>None identified</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>None identified</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>None identified</td></tr>
<tr><td>Workflow Complexity</td><td>Simple linear projection from source to output</td></tr>
<tr><td>Performance Considerations</td><td>Minimal; direct field projection without joins or calculations</td></tr>
<tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
<tr><td>Dependency Complexity</td><td>Single table dependency</td></tr>
<tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>
<br/>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found
<br/>

<!-- 7. Key Outputs -->
<ul>
  <li>MANDT</li>
  <li>PARAM_NAME</li>
  <li>LOW_CHAR</li>
  <li>HIGH_CHAR</li>
</ul>
<br/>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
