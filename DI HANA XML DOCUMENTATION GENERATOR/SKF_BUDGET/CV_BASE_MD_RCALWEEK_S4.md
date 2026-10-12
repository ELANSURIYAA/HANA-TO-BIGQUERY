<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse;">
  <tr><td style="font-weight:bold; width:15%">Author:</td><td>Ascendion AAVA</td></tr>
  <tr><td style="font-weight:bold;">Created On:</td><td>2026-10-12</td></tr>
  <tr><td style="font-weight:bold;">Description:</td><td>Technical documentation for Calculation View 'CV_BASE_MD_RCALWEEK_S4', a base view for retail calendar week master data. The view projects fields from a single database table and applies a filter on the client field.</td></tr>
</table>

<!-- 1. Overview of Program -->
<p>This HANA XML file defines a Calculation View of type 'TREE_BASED' with data category 'DIMENSION'. Its primary purpose is to provide a base view for retail calendar week master data by projecting fields from a database table and filtering records based on client values. The main processing involves simple field projection and filtering without additional calculations or aggregations.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View consists of a single projection node ('Projection_1') sourcing data from the database table 'ZTFIGL_RCALWEEK'. The projection node selects all relevant fields and applies a filter on the 'RCLNT' field to include only specified client values (120, 200). <b>Key Components:</b> The major components are the data source ('ZTFIGL_RCALWEEK'), the projection node ('Projection_1'), view attributes, and the logical model defining output attributes. <b>Dependencies & Performance:</b> The view depends solely on the referenced database table and does not include joins, aggregations, or complex processing logic. The filter on 'RCLNT' may improve performance by restricting the data volume, and the absence of calculated fields or nested processing nodes indicates low processing complexity.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; background:#fafaff; border:1px solid #dde; padding:24px; border-radius:8px;">
  <div style="display:grid; grid-template-columns: repeat(3, 220px); grid-template-rows: repeat(2, 90px); gap:32px; align-items:center; justify-items:center;">
    <!-- Data Source -->
    <div style="grid-column:1; grid-row:1; background:#e8f2ff; border:1px solid #c2d4e9; border-radius:6px; padding:18px; font-weight:bold;">ZTFIGL_RCALWEEK<br><span style="font-size:0.9em; color:#666;">Database Table</span></div>
    <!-- Arrow -->
    <div style="grid-column:2; grid-row:1; text-align:center;">
      <svg width="60" height="60"><defs><marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#6c7"/></marker></defs><line x1="0" y1="30" x2="60" y2="30" stroke="#6c7" stroke-width="3" marker-end="url(#arrowhead)"/></svg>
    </div>
    <!-- Projection Node -->
    <div style="grid-column:3; grid-row:1; background:#eaffea; border:1px solid #b7e2b7; border-radius:6px; padding:18px; font-weight:bold;">Projection_1<br><span style="font-size:0.9em; color:#666;">Projection Node<br/>Filter: RCLNT IN (120, 200)</span></div>
    <!-- Arrow -->
    <div style="grid-column:2; grid-row:2; text-align:center;">
      <svg width="60" height="60"><defs><marker id="arrowhead2" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#77c"/></marker></defs><line x1="0" y1="30" x2="60" y2="30" stroke="#77c" stroke-width="3" marker-end="url(#arrowhead2)"/></svg>
    </div>
    <!-- Output -->
    <div style="grid-column:3; grid-row:2; background:#f9f5e7; border:1px solid #e3d6b3; border-radius:6px; padding:18px; font-weight:bold;">Output<br><span style="font-size:0.9em; color:#666;">Projected Fields</span></div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%; border-collapse:collapse;">
  <tr style="background:#eef;"><th>Target Object/Field Name</th><th>Target Column Name</th><th>Source Object/Field Name</th><th>Source Column Name</th><th>Remarks</th></tr>
  <tr><td>Projection_1/RCLNT</td><td>RCLNT</td><td>ZTFIGL_RCALWEEK/RCLNT</td><td>RCLNT</td><td>Filter applied: IN (120, 200)</td></tr>
  <tr><td>Projection_1/ZZWEEK</td><td>ZZWEEK</td><td>ZTFIGL_RCALWEEK/ZZWEEK</td><td>ZZWEEK</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1/ZCALYRP</td><td>ZCALYRP</td><td>ZTFIGL_RCALWEEK/ZCALYRP</td><td>ZCALYRP</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1/ZRYEAR</td><td>ZRYEAR</td><td>ZTFIGL_RCALWEEK/ZRYEAR</td><td>ZRYEAR</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1/ZRPERIOD</td><td>ZRPERIOD</td><td>ZTFIGL_RCALWEEK/ZRPERIOD</td><td>ZRPERIOD</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1/ZRYRP</td><td>ZRYRP</td><td>ZTFIGL_RCALWEEK/ZRYRP</td><td>ZRYRP</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1/ZRYRQTR</td><td>ZRYRQTR</td><td>ZTFIGL_RCALWEEK/ZRYRQTR</td><td>ZRYRQTR</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1/ZRWSTRTDATE</td><td>ZRWSTRTDATE</td><td>ZTFIGL_RCALWEEK/ZRWSTRTDATE</td><td>ZRWSTRTDATE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1/ZRWENDDATE</td><td>ZRWENDDATE</td><td>ZTFIGL_RCALWEEK/ZRWENDDATE</td><td>ZRWENDDATE</td><td>Direct mapping</td></tr>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%; border-collapse:collapse;">
  <tr style="background:#ffe;"><th>Category</th><th>Measurement</th></tr>
  <tr><td>Number of Objects/Nodes</td><td>2 (Data Source, Projection Node)</td></tr>
  <tr><td>Sources Used</td><td>1 (ZTFIGL_RCALWEEK)</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None identified</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>Filter: RCLNT IN (120, 200)</td></tr>
  <tr><td>Workflow Complexity</td><td>Simple linear projection and filtering</td></tr>
  <tr><td>Performance Considerations</td><td>Single source, filter on client field, no complex processing</td></tr>
  <tr><td>Data Volume Handling</td><td>Cannot be determined from the XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Low; single table dependency</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>RCLNT (Client)</li>
  <li>ZZWEEK (Week Number)</li>
  <li>ZCALYRP (Calendar Year Period)</li>
  <li>ZRYEAR (Retail Year)</li>
  <li>ZRPERIOD (Retail Period)</li>
  <li>ZRYRP (Retail Period/Year)</li>
  <li>ZRYRQTR (Retail Year Quarter)</li>
  <li>ZRWSTRTDATE (Retail Week Start Date)</li>
  <li>ZRWENDDATE (Retail Week End Date)</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
