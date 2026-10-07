<!-- DOCUMENT HEADER -->
<table style="width:100%;border-collapse:collapse;margin-bottom:20px;">
  <tr>
    <td style="width:25%;font-weight:bold;">Author:</td>
    <td>Ascendion AAVA</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Created On:</td>
    <td>2026-10-07</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Description:</td>
    <td>Technical documentation for the HANA Calculation View 'CV_BASE_PARAMETERS', which serves as a base view for the Parameters table and provides mapped outputs for parameter-related fields.</td>
  </tr>
</table>

<!-- 1. Overview of Program -->
<p>The provided HANA XML defines a Calculation View named <b>CV_BASE_PARAMETERS</b> of type <b>TREE_BASED</b> with a data category of <b>DIMENSION</b>. Its primary purpose is to expose parameter data by projecting specific fields from the underlying database table <b>ZTFIRP_FLASH_PRM</b>. The view maps and renames fields for output, serving as a foundational layer for parameter information.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View comprises a single Projection node (<b>Projection_1</b>) that sources data from the database table <b>ZTFIRP_FLASH_PRM</b>. The view attributes defined are <b>MANDT</b>, <b>PARAM_NAME</b>, <b>LOW_CHAR</b>, and <b>HIGH_CHAR</b>, with mappings from the source table columns, including renaming of <b>PARAM_VALUE_LOW</b> to <b>LOW_CHAR</b> and <b>PARAM_VALUE_HIGH</b> to <b>HIGH_CHAR</b>. <b>Key Components:</b> The major components are the <b>Projection_1</b> node, the data source <b>ZTFIRP_FLASH_PRM</b>, and the logical model defining the output attributes. <b>Dependencies & Performance:</b> The view depends on the <b>ZTFIRP_FLASH_PRM</b> table in the <b>SAPABAP1</b> schema and does not include joins, aggregations, calculated fields, or filters, indicating a simple and efficient data retrieval design.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;background:#fafbfc;border:1px solid #d8dee2;padding:16px;border-radius:8px;max-width:900px;">
  <div style="display:grid;grid-template-columns:repeat(3,200px);grid-template-rows:repeat(2,100px);grid-gap:32px;align-items:center;justify-items:center;">
    <!-- Data Source -->
    <div style="grid-column:1;grid-row:1;background:#e3e9f3;border-radius:6px;border:1px solid #b4b9c7;padding:18px;text-align:center;font-weight:bold;">ZTFIRP_FLASH_PRM<br><span style="font-size:12px;">(Database Table)</span></div>
    <!-- Projection Node -->
    <div style="grid-column:2;grid-row:1;background:#d3f8e2;border-radius:6px;border:1px solid #a2d8c7;padding:18px;text-align:center;font-weight:bold;">Projection_1<br><span style="font-size:12px;">(Projection Node)</span></div>
    <!-- Output -->
    <div style="grid-column:3;grid-row:1;background:#ffe6e6;border-radius:6px;border:1px solid #e2b4b4;padding:18px;text-align:center;font-weight:bold;">Output<br><span style="font-size:12px;">(View Output)</span></div>
    <!-- Arrows -->
    <div style="grid-column:1;grid-row:2;text-align:center;">
      <svg width="200" height="40"><line x1="100" y1="0" x2="200" y2="40" stroke="#6c7a89" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
    </div>
    <div style="grid-column:2;grid-row:2;text-align:center;">
      <svg width="200" height="40"><line x1="0" y1="0" x2="200" y2="40" stroke="#6c7a89" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
    </div>
  </div>
  <svg width="0" height="0">
    <defs>
      <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
        <polygon points="0 0, 10 3.5, 0 7" fill="#6c7a89" />
      </marker>
    </defs>
  </svg>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%;border-collapse:collapse;margin-top:20px;margin-bottom:20px;">
  <thead>
    <tr style="background:#f4f6fa;">
      <th style="border:1px solid #d1d5db;padding:8px;">Target Object/Field Name</th>
      <th style="border:1px solid #d1d5db;padding:8px;">Target Column Name</th>
      <th style="border:1px solid #d1d5db;padding:8px;">Source Object/Field Name</th>
      <th style="border:1px solid #d1d5db;padding:8px;">Source Column Name</th>
      <th style="border:1px solid #d1d5db;padding:8px;">Remarks</th>
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
      <td>Renamed from PARAM_VALUE_LOW</td>
    </tr>
    <tr>
      <td>Projection_1 / HIGH_CHAR</td>
      <td>HIGH_CHAR</td>
      <td>ZTFIRP_FLASH_PRM / PARAM_VALUE_HIGH</td>
      <td>PARAM_VALUE_HIGH</td>
      <td>Renamed from PARAM_VALUE_HIGH</td>
    </tr>
  </tbody>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%;border-collapse:collapse;margin-bottom:20px;">
  <thead>
    <tr style="background:#f4f6fa;">
      <th style="border:1px solid #d1d5db;padding:8px;">Category</th>
      <th style="border:1px solid #d1d5db;padding:8px;">Measurement</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Number of Objects/Nodes</td>
      <td>2 (1 Data Source, 1 Projection Node)</td>
    </tr>
    <tr>
      <td>Sources Used</td>
      <td>ZTFIRP_FLASH_PRM (Database Table)</td>
    </tr>
    <tr>
      <td>Joins</td>
      <td>None</td>
    </tr>
    <tr>
      <td>Temporary/Cached Data</td>
      <td>None identified</td>
    </tr>
    <tr>
      <td>Aggregate Functions</td>
      <td>None</td>
    </tr>
    <tr>
      <td>Data Manipulation</td>
      <td>No data manipulation identified</td>
    </tr>
    <tr>
      <td>Conditional Logic</td>
      <td>None</td>
    </tr>
    <tr>
      <td>Workflow Complexity</td>
      <td>Simple linear projection from source to output</td>
    </tr>
    <tr>
      <td>Performance Considerations</td>
      <td>Direct read from single table; no joins, aggregations, or filters</td>
    </tr>
    <tr>
      <td>Data Volume Handling</td>
      <td>Not specified in XML</td>
    </tr>
    <tr>
      <td>Dependency Complexity</td>
      <td>Single dependency: ZTFIRP_FLASH_PRM table</td>
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
