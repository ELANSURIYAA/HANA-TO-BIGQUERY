<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse; margin-bottom:20px;">
  <tr>
    <td style="width:30%; font-weight:bold;">Author:</td>
    <td>Ascendion AAVA</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Created On:</td>
    <td>2024-06-11</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Description:</td>
    <td>Technical documentation for a HANA Calculation View named <b>CV_BASE_PARAMETERS</b>, which serves as a base view for parameters data, projecting selected fields from the underlying table source.</td>
  </tr>
</table>

<!-- 1. Overview of Program -->
<p><b>Overview of Program:</b><br>
This HANA XML defines a Calculation View of type <b>DIMENSION</b> named <b>CV_BASE_PARAMETERS</b>. Its primary function is to expose parameter-related fields from a single database table source. The view projects specific columns and provides descriptive metadata for each output field.</p>

<!-- 2. Code Structure and Design -->
<p>
<b>Structure:</b> The Calculation View consists of a single projection node (<b>Projection_1</b>) that maps fields from the data source table <b>ZTFIRP_FLASH_PRM</b>. There are no joins, aggregations, unions, filters, or calculated fields present. The logical model defines four attributes, each with descriptive metadata and direct mapping to the projection node.
<br><b>Key Components:</b> The key components include the data source (<b>ZTFIRP_FLASH_PRM</b>), projection node (<b>Projection_1</b>), and logical model attributes (<b>MANDT</b>, <b>PARAM_NAME</b>, <b>LOW_CHAR</b>, <b>HIGH_CHAR</b>). Each attribute is mapped directly from the source table and described in the logical model.
<br><b>Dependencies & Performance:</b> The Calculation View depends solely on the underlying database table <b>ZTFIRP_FLASH_PRM</b>. No joins, aggregations, or complex processing logic are present, indicating minimal dependency and low performance overhead for this view.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="width:100%; overflow-x:auto; margin-bottom:20px;">
  <div style="display:grid; grid-template-columns:repeat(3, 200px); grid-template-rows:repeat(2, 120px); gap:40px; align-items:center; justify-items:center; background:#f7f7fa; padding:30px 0;">
    <!-- Data Source -->
    <div style="grid-column:1; grid-row:1; background:#e3e7f1; border-radius:8px; box-shadow:0 1px 3px #ccc; text-align:center; padding:18px; font-weight:bold;">ZTFIRP_FLASH_PRM<br><span style="font-size:12px; color:#555;">(Database Table)</span></div>
    <!-- Arrow -->
    <div style="grid-column:2; grid-row:1; text-align:center;">
      <span style="font-size:32px; color:#888;">&#8594;</span>
    </div>
    <!-- Projection Node -->
    <div style="grid-column:3; grid-row:1; background:#e3e7f1; border-radius:8px; box-shadow:0 1px 3px #ccc; text-align:center; padding:18px; font-weight:bold;">Projection_1<br><span style="font-size:12px; color:#555;">(Projection Node)</span></div>
    <!-- Arrow -->
    <div style="grid-column:2; grid-row:2; text-align:center;">
      <span style="font-size:32px; color:#888;">&#8594;</span>
    </div>
    <!-- Output -->
    <div style="grid-column:3; grid-row:2; background:#d5e8d4; border-radius:8px; box-shadow:0 1px 3px #ccc; text-align:center; padding:18px; font-weight:bold;">Output<br><span style="font-size:12px; color:#555;">(MANDT, PARAM_NAME, LOW_CHAR, HIGH_CHAR)</span></div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%; border-collapse:collapse; margin-bottom:20px;">
  <thead>
    <tr style="background:#e3e7f1;">
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
      <td>Mapped as LOW_CHAR</td>
    </tr>
    <tr>
      <td>Projection_1 / HIGH_CHAR</td>
      <td>HIGH_CHAR</td>
      <td>ZTFIRP_FLASH_PRM / PARAM_VALUE_HIGH</td>
      <td>PARAM_VALUE_HIGH</td>
      <td>Mapped as HIGH_CHAR</td>
    </tr>
  </tbody>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%; border-collapse:collapse; margin-bottom:20px;">
  <thead>
    <tr style="background:#e3e7f1;">
      <th>Category</th>
      <th>Measurement</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>Number of Objects/Nodes</td><td>2 (Data Source, Projection Node)</td></tr>
    <tr><td>Sources Used</td><td>1 (ZTFIRP_FLASH_PRM)</td></tr>
    <tr><td>Joins</td><td>0</td></tr>
    <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
    <tr><td>Aggregate Functions</td><td>None identified</td></tr>
    <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
    <tr><td>Conditional Logic</td><td>None identified</td></tr>
    <tr><td>Workflow Complexity</td><td>Very simple, linear projection from table to output</td></tr>
    <tr><td>Performance Considerations</td><td>Minimal performance overhead; single table projection</td></tr>
    <tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
    <tr><td>Dependency Complexity</td><td>Single dependency (ZTFIRP_FLASH_PRM)</td></tr>
    <tr><td>Overall Complexity Score</td><td>Low</td></tr>
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
