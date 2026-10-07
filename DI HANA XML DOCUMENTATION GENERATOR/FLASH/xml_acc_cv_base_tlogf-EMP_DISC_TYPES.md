<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse;">
  <tr><td><b>Author:</b></td><td>Ascendion AAVA</td></tr>
  <tr><td><b>Created On:</b></td><td>2026-10-07</td></tr>
  <tr><td><b>Description:</b></td><td>Technical documentation for a HANA Calculation View named 'CV_BASE_PARAMETERS', designed as a dimension view for exposing base parameters from the table 'ZTFIRP_FLASH_PRM'. The view projects key fields and maps them to output attributes, enabling parameter management and analysis.</td></tr>
</table>

<!-- 1. Overview of Program -->
<p>The object is a HANA Calculation View of type TREE_BASED with data category DIMENSION. Its primary purpose is to provide a structured projection of parameter data from the base table 'ZTFIRP_FLASH_PRM'. The view exposes selected fields mapped to output attributes for downstream consumption and analysis.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View consists of a single projection node ('Projection_1') that sources data from the base table 'ZTFIRP_FLASH_PRM'. The projection selects and maps four key fields: 'MANDT', 'PARAM_NAME', 'LOW_CHAR', and 'HIGH_CHAR', with 'LOW_CHAR' and 'HIGH_CHAR' mapped from 'PARAM_VALUE_LOW' and 'PARAM_VALUE_HIGH' respectively. No joins, unions, aggregations, or calculated fields are defined.<br>
<b>Key Components:</b> The major components include the data source 'ZTFIRP_FLASH_PRM', the projection node 'Projection_1', and the logical model defining the output attributes. Each attribute is mapped directly from the source or via simple renaming.<br>
<b>Dependencies & Performance:</b> The view depends solely on the base table 'ZTFIRP_FLASH_PRM' and does not reference other views or tables. No performance-impacting elements such as joins, aggregations, or filters are present. The structure is straightforward, enabling efficient data retrieval without complex processing.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; background:#f8f9fa; padding:20px; border-radius:8px;">
  <div style="display:grid; grid-template-columns:repeat(2, 220px); grid-template-rows:repeat(2, 90px); gap:32px; align-items:center; justify-items:center;">
    <div style="grid-column:1; grid-row:1; background:#e3eafc; border:1px solid #b6c4e9; border-radius:8px; width:200px; height:70px; display:flex; align-items:center; justify-content:center; font-weight:bold;">Data Source:<br>ZTFIRP_FLASH_PRM</div>
    <div style="grid-column:2; grid-row:2; background:#d1e7dd; border:1px solid #bcd0c7; border-radius:8px; width:200px; height:70px; display:flex; align-items:center; justify-content:center; font-weight:bold;">Projection Node:<br>Projection_1</div>
    <div style="grid-column:1; grid-row:2; background:#f8d7da; border:1px solid #f5c6cb; border-radius:8px; width:200px; height:70px; display:flex; align-items:center; justify-content:center; font-weight:bold;">Output<br>(MANDT, PARAM_NAME,<br>LOW_CHAR, HIGH_CHAR)</div>
    <!-- Arrows -->
    <svg style="grid-column:1; grid-row:1; position:relative; left:210px; top:25px;" width="60" height="60">
      <defs>
        <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
          <polygon points="0 0, 10 3.5, 0 7" fill="#6c757d"/>
        </marker>
      </defs>
      <line x1="0" y1="10" x2="60" y2="50" stroke="#6c757d" stroke-width="2" marker-end="url(#arrowhead)"/>
    </svg>
    <svg style="grid-column:2; grid-row:2; position:relative; left:-220px; top:25px;" width="60" height="60">
      <defs>
        <marker id="arrowhead2" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
          <polygon points="0 0, 10 3.5, 0 7" fill="#198754"/>
        </marker>
      </defs>
      <line x1="60" y1="10" x2="0" y2="50" stroke="#198754" stroke-width="2" marker-end="url(#arrowhead2)"/>
    </svg>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%; border-collapse:collapse;">
  <tr style="background:#f1f1f1;">
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
    <td>Renamed from PARAM_VALUE_LOW</td>
  </tr>
  <tr>
    <td>Projection_1 / HIGH_CHAR</td>
    <td>HIGH_CHAR</td>
    <td>ZTFIRP_FLASH_PRM / PARAM_VALUE_HIGH</td>
    <td>PARAM_VALUE_HIGH</td>
    <td>Renamed from PARAM_VALUE_HIGH</td>
  </tr>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%; border-collapse:collapse;">
  <tr style="background:#f1f1f1;"><th>Category</th><th>Measurement</th></tr>
  <tr><td>Number of Objects/Nodes</td><td>2 (DataSource, Projection Node)</td></tr>
  <tr><td>Sources Used</td><td>ZTFIRP_FLASH_PRM</td></tr>
  <tr><td>Joins</td><td>None</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>None</td></tr>
  <tr><td>Workflow Complexity</td><td>Low; single projection node with direct mappings</td></tr>
  <tr><td>Performance Considerations</td><td>Straightforward structure; no joins or aggregations</td></tr>
  <tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single table dependency (ZTFIRP_FLASH_PRM)</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
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
