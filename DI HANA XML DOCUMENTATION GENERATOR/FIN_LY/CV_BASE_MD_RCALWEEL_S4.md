<!-- DOCUMENT HEADER -->
<table>
  <tr><td><b>Author:</b></td><td>Ascendion AAVA</td></tr>
  <tr><td><b>Created On:</b></td><td>2026-10-12</td></tr>
  <tr><td><b>Description:</b></td><td>Technical documentation for the HANA Calculation View <code>CV_BASE_MD_RCALWEEK_S4</code>, a base view for retail calendar week master data, as defined in the provided HANA XML. The object is structured to project fields from the underlying table <code>ZTFIGL_RCALWEEK</code> and applies a filter on the client field.</td></tr>
</table>

<!-- 1. Overview of Program -->
<p>The provided HANA XML defines a Calculation View named <code>CV_BASE_MD_RCALWEEK_S4</code> of type <b>Dimension</b>. Its primary purpose is to serve as a base view for retail calendar week master data, projecting relevant fields from the source table <code>ZTFIGL_RCALWEEK</code>. The view applies a filter to the <code>RCLNT</code> field and exposes a set of attributes for downstream consumption.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View is structured as a single projection node (<code>Projection_1</code>) sourcing data from the database table <code>ZTFIGL_RCALWEEK</code>. The projection maps nine fields directly and applies a filter to the <code>RCLNT</code> field, restricting values to <code>120</code> and <code>200</code>. No calculated fields, joins, aggregations, or unions are present in the view.<br>
<b>Key Components:</b> Major components include the <code>ZTFIGL_RCALWEEK</code> data source, the <code>Projection_1</code> projection node, and the logical model defining output attributes. The view attributes correspond to retail calendar week information, such as week number, year, period, quarter, and start/end dates.<br>
<b>Dependencies & Performance:</b> The object depends solely on the underlying table <code>ZTFIGL_RCALWEEK</code>. No joins, aggregations, or nested processing are present, and the only filter applied is on the client field. Performance considerations are minimal due to the simple structure and direct mapping.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; padding:10px; background:#f9f9f9; border-radius:8px;">
  <div style="display:grid; grid-template-columns:repeat(3, 200px); grid-template-rows:repeat(2, 80px); align-items:center; justify-items:center; gap:40px;">
    <!-- Source Table -->
    <div style="grid-column:1; grid-row:1; background:#e2e6ea; border-radius:6px; padding:18px; box-shadow:0 2px 6px #ccc; text-align:center; font-weight:600;">ZTFIGL_RCALWEEK<br><span style="font-size:12px; color:#666;">Data Source</span></div>
    <!-- Arrow -->
    <div style="grid-column:2; grid-row:1; text-align:center;">
      <span style="font-size:36px; color:#888;">→</span>
    </div>
    <!-- Projection Node -->
    <div style="grid-column:3; grid-row:1; background:#d7f3e3; border-radius:6px; padding:18px; box-shadow:0 2px 6px #ccc; text-align:center; font-weight:600;">Projection_1<br><span style="font-size:12px; color:#666;">Projection Node<br>Filter: RCLNT IN (120, 200)</span></div>
    <!-- Arrow -->
    <div style="grid-column:2; grid-row:2; text-align:center;">
      <span style="font-size:36px; color:#888;">→</span>
    </div>
    <!-- Output -->
    <div style="grid-column:3; grid-row:2; background:#e7e1fa; border-radius:6px; padding:18px; box-shadow:0 2px 6px #ccc; text-align:center; font-weight:600;">Output<br><span style="font-size:12px; color:#666;">RCLNT, ZZWEEK, ZCALYRP, ZRYEAR, ZRPERIOD, ZRYRP, ZRYRQTR, ZRWSTRTDATE, ZRWENDDATE</span></div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse:collapse; width:100%;">
  <tr>
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr><td>Projection_1.RCLNT</td><td>RCLNT</td><td>ZTFIGL_RCALWEEK.RCLNT</td><td>RCLNT</td><td>Filter applied: IN (120, 200)</td></tr>
  <tr><td>Projection_1.ZZWEEK</td><td>ZZWEEK</td><td>ZTFIGL_RCALWEEK.ZZWEEK</td><td>ZZWEEK</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZCALYRP</td><td>ZCALYRP</td><td>ZTFIGL_RCALWEEK.ZCALYRP</td><td>ZCALYRP</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZRYEAR</td><td>ZRYEAR</td><td>ZTFIGL_RCALWEEK.ZRYEAR</td><td>ZRYEAR</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZRPERIOD</td><td>ZRPERIOD</td><td>ZTFIGL_RCALWEEK.ZRPERIOD</td><td>ZRPERIOD</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZRYRP</td><td>ZRYRP</td><td>ZTFIGL_RCALWEEK.ZRYRP</td><td>ZRYRP</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZRYRQTR</td><td>ZRYRQTR</td><td>ZTFIGL_RCALWEEK.ZRYRQTR</td><td>ZRYRQTR</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZRWSTRTDATE</td><td>ZRWSTRTDATE</td><td>ZTFIGL_RCALWEEK.ZRWSTRTDATE</td><td>ZRWSTRTDATE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZRWENDDATE</td><td>ZRWENDDATE</td><td>ZTFIGL_RCALWEEK.ZRWENDDATE</td><td>ZRWENDDATE</td><td>Direct mapping</td></tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse:collapse; width:80%;">
  <tr><th>Category</th><th>Measurement</th></tr>
  <tr><td>Number of Objects/Nodes</td><td>2 (Calculation View, Projection Node)</td></tr>
  <tr><td>Sources Used</td><td>1 (ZTFIGL_RCALWEEK)</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None identified</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>Filter on RCLNT (IN 120, 200)</td></tr>
  <tr><td>Workflow Complexity</td><td>Low (single projection, direct mapping)</td></tr>
  <tr><td>Performance Considerations</td><td>Minimal; direct field mapping and simple filter</td></tr>
  <tr><td>Data Volume Handling</td><td>Cannot be determined from XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Low (single source table dependency)</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>RCLNT</li>
  <li>ZZWEEK</li>
  <li>ZCALYRP</li>
  <li>ZRYEAR</li>
  <li>ZRPERIOD</li>
  <li>ZRYRP</li>
  <li>ZRYRQTR</li>
  <li>ZRWSTRTDATE</li>
  <li>ZRWENDDATE</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
