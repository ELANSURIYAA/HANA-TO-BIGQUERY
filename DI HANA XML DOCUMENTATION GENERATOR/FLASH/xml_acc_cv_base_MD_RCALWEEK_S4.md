<!-- DOCUMENT HEADER -->
<table style="width:100%;border-collapse:collapse;">
  <tr>
    <td style="width:33%;"><b>Author:</b> Ascendion AAVA</td>
    <td style="width:33%;"><b>Created On:</b> {{CURRENT_DATE}}</td>
    <td style="width:33%;"><b>Description:</b> Base View for ZTFIGL_RCALWEEK - Retail Calendar Week Master Data. Provides dimensional data for retail calendar weeks as defined in the underlying database table.</td>
  </tr>
</table>

<!-- 1. Overview of Program -->
<p>This HANA XML object is a Calculation View of type DIMENSION, designed to provide a base view for retail calendar week master data. It projects fields from the ZTFIGL_RCALWEEK database table and applies a filter on the RCLNT field. The main processing involves projecting relevant week and period attributes for downstream consumption.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View consists of a single projection node (Projection_1) that sources data from the ZTFIGL_RCALWEEK table. The projection defines nine view attributes, including a filter on the RCLNT field with values 120 and 200. No calculated fields, joins, unions, or aggregations are present. <b>Key Components:</b> The major components are the data source (ZTFIGL_RCALWEEK), the projection node (Projection_1), and the logical model defining output attributes mapped directly to the source columns. <b>Dependencies & Performance:</b> The only dependency is the ZTFIGL_RCALWEEK table. The absence of joins, aggregations, or calculated fields suggests a low-complexity structure with minimal performance overhead.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;background:#f8f9fa;padding:16px;border-radius:8px;width:100%;max-width:900px;">
  <div style="display:grid;grid-template-columns:repeat(3,220px);grid-template-rows:repeat(2,120px);gap:40px;align-items:center;justify-items:center;">
    <div style="grid-column:1;grid-row:1;background:#e3e7ef;border-radius:8px;padding:18px;text-align:center;font-weight:bold;border:1px solid #c3c7cf;">Data Source<br/>ZTFIGL_RCALWEEK</div>
    <div style="grid-column:2;grid-row:2;background:#e3e7ef;border-radius:8px;padding:18px;text-align:center;font-weight:bold;border:1px solid #c3c7cf;">Projection Node<br/>Projection_1</div>
    <div style="grid-column:3;grid-row:1;background:#e3e7ef;border-radius:8px;padding:18px;text-align:center;font-weight:bold;border:1px solid #c3c7cf;">Output<br/>View Attributes</div>
    <div style="grid-column:1;grid-row:1;grid-column-end:2;grid-row-end:2;"></div>
    <svg style="grid-column:1;grid-row:1;position:relative;top:60px;left:110px;" width="80" height="40">
      <defs><marker id="arrow" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto" markerUnits="strokeWidth"><polygon points="0 0, 10 3.5, 0 7" fill="#6c757d"/></marker></defs>
      <line x1="0" y1="20" x2="80" y2="100" stroke="#6c757d" stroke-width="3" marker-end="url(#arrow)"/>
    </svg>
    <svg style="grid-column:2;grid-row:2;position:relative;top:-60px;left:110px;" width="80" height="40">
      <defs><marker id="arrow2" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto" markerUnits="strokeWidth"><polygon points="0 0, 10 3.5, 0 7" fill="#6c757d"/></marker></defs>
      <line x1="0" y1="20" x2="80" y2="-80" stroke="#6c757d" stroke-width="3" marker-end="url(#arrow2)"/>
    </svg>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%;border-collapse:collapse;border:1px solid #ccc;">
  <thead style="background:#f1f1f1;">
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
      <td>Projection_1.RCLNT</td>
      <td>RCLNT</td>
      <td>ZTFIGL_RCALWEEK.RCLNT</td>
      <td>RCLNT</td>
      <td>Filter applied: IN (120, 200)</td>
    </tr>
    <tr>
      <td>Projection_1.ZZWEEK</td>
      <td>ZZWEEK</td>
      <td>ZTFIGL_RCALWEEK.ZZWEEK</td>
      <td>ZZWEEK</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1.ZCALYRP</td>
      <td>ZCALYRP</td>
      <td>ZTFIGL_RCALWEEK.ZCALYRP</td>
      <td>ZCALYRP</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1.ZRYEAR</td>
      <td>ZRYEAR</td>
      <td>ZTFIGL_RCALWEEK.ZRYEAR</td>
      <td>ZRYEAR</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1.ZRPERIOD</td>
      <td>ZRPERIOD</td>
      <td>ZTFIGL_RCALWEEK.ZRPERIOD</td>
      <td>ZRPERIOD</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1.ZRYRP</td>
      <td>ZRYRP</td>
      <td>ZTFIGL_RCALWEEK.ZRYRP</td>
      <td>ZRYRP</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1.ZRYRQTR</td>
      <td>ZRYRQTR</td>
      <td>ZTFIGL_RCALWEEK.ZRYRQTR</td>
      <td>ZRYRQTR</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1.ZRWSTRTDATE</td>
      <td>ZRWSTRTDATE</td>
      <td>ZTFIGL_RCALWEEK.ZRWSTRTDATE</td>
      <td>ZRWSTRTDATE</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1.ZRWENDDATE</td>
      <td>ZRWENDDATE</td>
      <td>ZTFIGL_RCALWEEK.ZRWENDDATE</td>
      <td>ZRWENDDATE</td>
      <td>Direct mapping</td>
    </tr>
  </tbody>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%;border-collapse:collapse;border:1px solid #ccc;">
  <tr><td>Number of Objects/Nodes</td><td>2 (Data Source, Projection Node)</td></tr>
  <tr><td>Sources Used</td><td>ZTFIGL_RCALWEEK (database table)</td></tr>
  <tr><td>Joins</td><td>None</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>Filter on RCLNT (IN 120, 200)</td></tr>
  <tr><td>Workflow Complexity</td><td>Simple linear projection from data source to output</td></tr>
  <tr><td>Performance Considerations</td><td>Minimal, due to absence of joins, aggregations, or calculated fields</td></tr>
  <tr><td>Data Volume Handling</td><td>Not specified in the XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single dependency: ZTFIGL_RCALWEEK</td></tr>
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