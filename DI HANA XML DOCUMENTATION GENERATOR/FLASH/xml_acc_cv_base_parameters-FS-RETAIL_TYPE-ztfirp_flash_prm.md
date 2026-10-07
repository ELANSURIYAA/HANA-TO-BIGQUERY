<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse; margin-bottom:16px;">
  <tr>
    <td style="width:25%; font-weight:bold;">Author:</td>
    <td style="width:75%;">Ascendion AAVA</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Created On:</td>
    <td>2026-10-07</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Description:</td>
    <td>Technical documentation for the HANA Calculation View 'CV_BASE_PARAMETERS', which serves as a base view for the Parameters table. The view projects selected fields from the underlying database table 'ZTFIRP_FLASH_PRM'.</td>
  </tr>
</table>

<!-- 1. Overview of Program -->
<p><b>Overview of Program:</b><br>
This object is a HANA Calculation View of type 'TREE_BASED' with data category 'DIMENSION'. Its primary purpose is to provide a base view for the Parameters table by projecting specific fields from the source database table. The view maps and exposes key parameter fields for downstream modeling or consumption.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View is structured with a single projection node ('Projection_1') that sources data from the database table 'ZTFIRP_FLASH_PRM'. The projection node selects and maps four fields: MANDT, PARAM_NAME, LOW_CHAR, and HIGH_CHAR, with LOW_CHAR and HIGH_CHAR mapped from PARAM_VALUE_LOW and PARAM_VALUE_HIGH, respectively. No calculated fields, joins, filters, unions, or aggregations are defined in this view.<br>
<b>Key Components:</b> The major components are the data source ('ZTFIRP_FLASH_PRM'), the projection node ('Projection_1'), and the logical model specifying the output attributes. The logical model defines the output attributes and their descriptions, directly mapping them to the projection node.<br>
<b>Dependencies & Performance:</b> The view depends solely on the database table 'ZTFIRP_FLASH_PRM' as its source. No joins, aggregations, or complex processing logic are present, indicating a simple and efficient structure. No explicit performance optimizations or data volume handling mechanisms are defined in the XML.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; background:#f8f9fa; padding:16px; border-radius:8px;">
  <div style="display:grid; grid-template-columns:repeat(3, 180px); grid-template-rows:repeat(2, 80px); align-items:center; justify-items:center; gap:32px;">
    <!-- Data Source -->
    <div style="grid-column:1; grid-row:1; background:#e3e6f3; border-radius:8px; box-shadow:0 2px 8px #d0d0d0; width:160px; height:60px; display:flex; align-items:center; justify-content:center; font-weight:bold;">ZTFIRP_FLASH_PRM<br/><span style='font-size:12px;'>Database Table</span></div>
    <!-- Arrow -->
    <div style="grid-column:2; grid-row:1;">
      <svg width="50" height="60"><line x1="0" y1="30" x2="50" y2="30" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/><defs><marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#888"/></marker></defs></svg>
    </div>
    <!-- Projection Node -->
    <div style="grid-column:3; grid-row:1; background:#d4f3e6; border-radius:8px; box-shadow:0 2px 8px #c0c0c0; width:160px; height:60px; display:flex; align-items:center; justify-content:center; font-weight:bold;">Projection_1<br/><span style='font-size:12px;'>Projection Node</span></div>
    <!-- Arrow -->
    <div style="grid-column:3; grid-row:1; grid-row-start:2;">
      <svg width="50" height="60"><line x1="25" y1="0" x2="25" y2="60" stroke="#888" stroke-width="2" marker-end="url(#arrowhead2)"/><defs><marker id="arrowhead2" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#888"/></marker></defs></svg>
    </div>
    <!-- Output -->
    <div style="grid-column:3; grid-row:2; background:#f3e6d4; border-radius:8px; box-shadow:0 2px 8px #c0c0c0; width:160px; height:60px; display:flex; align-items:center; justify-content:center; font-weight:bold;">CV_BASE_PARAMETERS<br/><span style='font-size:12px;'>Output View</span></div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%; border-collapse:collapse; margin-top:16px; margin-bottom:16px;">
  <thead style="background:#e3e6f3;">
    <tr>
      <th>Target Object/Field Name</th>
      <th>Target Column Name</th>
      <th>Source Object/Field Name</th>
      <th>Source Column Name</th>
      <th>Remarks</th>
    </tr>
  </thead>
  <tbody>
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
      <td>Mapped from PARAM_VALUE_LOW</td>
    </tr>
    <tr>
      <td>Projection_1 / HIGH_CHAR</td>
      <td>HIGH_CHAR</td>
      <td>ZTFIRP_FLASH_PRM / PARAM_VALUE_HIGH</td>
      <td>PARAM_VALUE_HIGH</td>
      <td>Mapped from PARAM_VALUE_HIGH</td>
    </tr>
  </tbody>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%; border-collapse:collapse; margin-bottom:16px;">
  <thead style="background:#e3e6f3;">
    <tr>
      <th>Category</th>
      <th>Measurement</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Number of Objects/Nodes</td>
      <td>2 (Projection node, Output View)</td>
    </tr>
    <tr>
      <td>Sources Used</td>
      <td>1 (ZTFIRP_FLASH_PRM database table)</td>
    </tr>
    <tr>
      <td>Joins</td>
      <td>None identified</td>
    </tr>
    <tr>
      <td>Temporary/Cached Data</td>
      <td>None identified</td>
    </tr>
    <tr>
      <td>Aggregate Functions</td>
      <td>None identified</td>
    </tr>
    <tr>
      <td>Data Manipulation</td>
      <td>No data manipulation identified</td>
    </tr>
    <tr>
      <td>Conditional Logic</td>
      <td>None identified</td>
    </tr>
    <tr>
      <td>Workflow Complexity</td>
      <td>Low (single projection node, direct mapping)</td>
    </tr>
    <tr>
      <td>Performance Considerations</td>
      <td>Simple structure; direct source-to-output mapping; no complex processing</td>
    </tr>
    <tr>
      <td>Data Volume Handling</td>
      <td>No explicit data volume handling defined</td>
    </tr>
    <tr>
      <td>Dependency Complexity</td>
      <td>Single dependency (ZTFIRP_FLASH_PRM database table)</td>
    </tr>
    <tr>
      <td>Overall Complexity Score</td>
      <td>Low</td>
    </tr>
  </tbody>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>MANDT</li>
  <li>PARAM_NAME</li>
  <li>LOW_CHAR</li>
  <li>HIGH_CHAR</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
