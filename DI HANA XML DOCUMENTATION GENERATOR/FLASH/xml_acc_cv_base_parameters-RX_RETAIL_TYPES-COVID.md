<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:8px;margin-bottom:16px">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> 2026-10-07<br>
  <b>Description:</b> Technical documentation for HANA Calculation View 'CV_BASE_PARAMETERS', designed as a base view for parameters table. The view projects selected fields from the source database table and establishes mappings for parameter-related character fields.
</div>

<!-- 1. Overview of Program -->
<p>
This HANA XML defines a Calculation View named 'CV_BASE_PARAMETERS' of type DIMENSION. Its primary purpose is to provide a base view for parameter data by projecting specific fields from a single database table. The view facilitates the mapping and exposure of parameter-related attributes for downstream modeling or consumption.
</p>

<!-- 2. Code Structure and Design -->
<p>
<b>Structure:</b> The Calculation View consists of one Projection node ('Projection_1') that sources data from the database table 'ZTFIRP_FLASH_PRM'. The projection node selects four fields: MANDT, PARAM_NAME, LOW_CHAR, and HIGH_CHAR, with LOW_CHAR and HIGH_CHAR mapped from PARAM_VALUE_LOW and PARAM_VALUE_HIGH in the source table, respectively. No calculated fields, joins, aggregations, or filters are present.<br>
<b>Key Components:</b> The major components are the Projection node, the data source ('ZTFIRP_FLASH_PRM'), and the logical model defining output attributes. The logical model specifies the output fields and their descriptions, directly reflecting the structure of the projection.<br>
<b>Dependencies & Performance:</b> The view depends solely on the referenced database table 'ZTFIRP_FLASH_PRM'. No joins, unions, aggregations, or complex processing logic are implemented. The structure is simple and optimized for direct field mapping, with no explicit performance-impacting features identified in the XML.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow:auto;background:#f9f9f9;border:1px solid #e0e0e0;padding:16px;border-radius:8px;width:100%">
  <div style="display:grid;grid-template-columns:repeat(3,180px);grid-template-rows:repeat(3,90px);gap:32px;align-items:center;justify-content:center">
    <div style="grid-column:2;grid-row:1;background:#e6f2ff;border-radius:8px;padding:16px;text-align:center;font-weight:bold;border:1px solid #b3d1ff">Data Source<br>ZTFIRP_FLASH_PRM</div>
    <div style="grid-column:2;grid-row:2;background:#fffbe6;border-radius:8px;padding:16px;text-align:center;font-weight:bold;border:1px solid #ffe066">Projection_1<br>(Projection Node)</div>
    <div style="grid-column:2;grid-row:3;background:#e6ffe6;border-radius:8px;padding:16px;text-align:center;font-weight:bold;border:1px solid #b3ffb3">Output<br>CV_BASE_PARAMETERS</div>
    <div style="grid-column:2;grid-row:1;justify-self:center;width:0;height:0;border-left:16px solid transparent;border-right:16px solid transparent;border-bottom:24px solid #b3d1ff;margin-top:54px"></div>
    <div style="grid-column:2;grid-row:2;justify-self:center;width:0;height:0;border-left:16px solid transparent;border-right:16px solid transparent;border-bottom:24px solid #ffe066;margin-top:54px"></div>
    <div style="grid-column:2;grid-row:1;grid-row-end:span 2;align-self:end;justify-self:center">
      <svg width="2" height="90" style="display:block;margin:auto"><line x1="1" y1="0" x2="1" y2="90" stroke="#b3d1ff" stroke-width="2"/></svg>
    </div>
    <div style="grid-column:2;grid-row:2;grid-row-end:span 2;align-self:end;justify-self:center">
      <svg width="2" height="90" style="display:block;margin:auto"><line x1="1" y1="0" x2="1" y2="90" stroke="#ffe066" stroke-width="2"/></svg>
    </div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;margin-top:16px">
  <tr>
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
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
    <td>Mapped to output field LOW_CHAR</td>
  </tr>
  <tr>
    <td>Projection_1 / HIGH_CHAR</td>
    <td>HIGH_CHAR</td>
    <td>ZTFIRP_FLASH_PRM / PARAM_VALUE_HIGH</td>
    <td>PARAM_VALUE_HIGH</td>
    <td>Mapped to output field HIGH_CHAR</td>
  </tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;margin-top:16px">
  <tr><th>Category</th><th>Measurement</th></tr>
  <tr><td>Number of Objects/Nodes</td><td>2 (Projection node, Data source)</td></tr>
  <tr><td>Sources Used</td><td>1 (ZTFIRP_FLASH_PRM)</td></tr>
  <tr><td>Joins</td><td>None</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>None</td></tr>
  <tr><td>Workflow Complexity</td><td>Low (single projection node, direct mapping)</td></tr>
  <tr><td>Performance Considerations</td><td>Direct field mapping, no complex processing</td></tr>
  <tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single table dependency</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>MANDT (Client)</li>
  <li>PARAM_NAME (Parameter Name)</li>
  <li>LOW_CHAR (Low value of character data type)</li>
  <li>HIGH_CHAR (High value of character data type)</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
