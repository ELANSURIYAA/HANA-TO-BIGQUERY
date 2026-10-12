<!-- DOCUMENT HEADER -->
<table style="width:100%;border-collapse:collapse;margin-bottom:20px;">
<tr><td style="font-weight:bold;width:20%;">Author:</td><td>Ascendion AAVA</td></tr>
<tr><td style="font-weight:bold;width:20%;">Created On:</td><td>{{CURRENT_DATE}}</td></tr>
<tr><td style="font-weight:bold;width:20%;">Description:</td><td>Base Calculation View for ZTFIGL_RCALWEEK - Retail Calendar Week Master Data. Provides a dimension view projecting retail calendar week attributes from the ZTFIGL_RCALWEEK table with client-level filtering.</td></tr>
</table>

<!-- 1. Overview of Program -->
<p>This HANA XML object is a Calculation View of type DIMENSION. Its primary purpose is to expose retail calendar week master data attributes from the ZTFIGL_RCALWEEK base table, applying a client filter. The view projects selected fields for downstream consumption and analysis.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View is structured as a single projection node (Projection_1) sourcing data from the ZTFIGL_RCALWEEK table. It defines a set of view attributes corresponding to retail calendar week fields and applies a filter on the RCLNT attribute. <b>Key Components:</b> Major components include the base table data source (ZTFIGL_RCALWEEK), the projection node, attribute mappings, and client filtering. The logical model specifies the output attributes with descriptive labels. <b>Dependencies & Performance:</b> The view depends on the ZTFIGL_RCALWEEK table and does not reference other views, joins, or aggregations. The filter on RCLNT may impact performance by reducing data volume; no complex processing or calculated attributes are present.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;background:#f8f9fa;padding:20px;border-radius:8px;">
  <div style="display:grid;grid-template-columns:repeat(3,180px);grid-template-rows:repeat(2,100px);align-items:center;justify-items:center;gap:40px;">
    <div style="grid-column:2;grid-row:1;background:#d3e8fc;border-radius:8px;padding:16px;font-weight:bold;text-align:center;box-shadow:0 2px 6px #ccc;">Data Source:<br>ZTFIGL_RCALWEEK</div>
    <div style="grid-column:2;grid-row:2;background:#e6f9e6;border-radius:8px;padding:16px;font-weight:bold;text-align:center;box-shadow:0 2px 6px #ccc;">Projection_1<br>(Client Filter & Attribute Mapping)</div>
    <div style="grid-column:3;grid-row:2;background:#fff7e6;border-radius:8px;padding:16px;font-weight:bold;text-align:center;box-shadow:0 2px 6px #ccc;">Output<br>(Retail Calendar Week Attributes)</div>
    <!-- Arrows -->
    <svg style="grid-column:2;grid-row:1;position:relative;top:60px;left:85px;" width="50" height="40">
      <defs><marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7"/></marker></defs>
      <line x1="0" y1="0" x2="50" y2="40" style="stroke:#555;stroke-width:2" marker-end="url(#arrowhead)"/>
    </svg>
    <svg style="grid-column:2;grid-row:2;position:relative;top:0px;left:180px;" width="60" height="20">
      <defs><marker id="arrowhead2" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7"/></marker></defs>
      <line x1="0" y1="10" x2="60" y2="10" style="stroke:#555;stroke-width:2" marker-end="url(#arrowhead2)"/>
    </svg>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%;border-collapse:collapse;margin-top:20px;">
<thead><tr style="background:#eaeaea;font-weight:bold;">
<td>Target Object/Field Name</td><td>Target Column Name</td><td>Source Object/Field Name</td><td>Source Column Name</td><td>Remarks</td>
</tr></thead>
<tbody>
<tr><td>Projection_1.RCLNT</td><td>RCLNT</td><td>ZTFIGL_RCALWEEK.RCLNT</td><td>RCLNT</td><td>Filter applied: IN (120, 200)</td></tr>
<tr><td>Projection_1.ZZWEEK</td><td>ZZWEEK</td><td>ZTFIGL_RCALWEEK.ZZWEEK</td><td>ZZWEEK</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZCALYRP</td><td>ZCALYRP</td><td>ZTFIGL_RCALWEEK.ZCALYRP</td><td>ZCALYRP</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZRYEAR</td><td>ZRYEAR</td><td>ZTFIGL_RCALWEEK.ZRYEAR</td><td>ZRYEAR</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZRPERIOD</td><td>ZRPERIOD</td><td>ZTFIGL_RCALWEEK.ZRPERIOD</td><td>ZRPERIOD</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZRYRP</td><td>ZRYRP</td><td>ZTFIGL_RCALWEEK.ZRYRP</td><td>ZRYRP</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZRYRQTR</td><td>ZRYRQTR</td><td>ZTFIGL_RCALWEEK.ZRYRQTR</td><td>ZRYRQTR</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZRWSTRTDATE</td><td>ZRWSTRTDATE</td><td>ZTFIGL_RCALWEEK.ZRWSTRTDATE</td><td>ZRWSTRTDATE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZRWENDDATE</td><td>ZRWENDDATE</td><td>ZTFIGL_RCALWEEK.ZRWENDDATE</td><td>ZRWENDDATE</td><td>Direct mapping</td></tr>
</tbody>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%;border-collapse:collapse;margin-top:20px;">
<thead><tr style="background:#eaeaea;font-weight:bold;">
<td>Category</td><td>Measurement</td>
</tr></thead>
<tbody>
<tr><td>Number of Objects/Nodes</td><td>2 (Data Source, Projection Node)</td></tr>
<tr><td>Sources Used</td><td>ZTFIGL_RCALWEEK (base table)</td></tr>
<tr><td>Joins</td><td>None identified</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>None identified</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>Filter on RCLNT (IN 120, 200)</td></tr>
<tr><td>Workflow Complexity</td><td>Simple, linear projection structure</td></tr>
<tr><td>Performance Considerations</td><td>Client filter may reduce data volume; no complex logic</td></tr>
<tr><td>Data Volume Handling</td><td>Not explicitly addressed in XML</td></tr>
<tr><td>Dependency Complexity</td><td>Single table dependency</td></tr>
<tr><td>Overall Complexity Score</td><td>Low</td></tr>
</tbody>
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
