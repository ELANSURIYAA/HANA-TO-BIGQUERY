<!-- DOCUMENT HEADER -->
<table>
  <tr><td><b>Author:</b></td><td>Ascendion AAVA</td></tr>
  <tr><td><b>Created On:</b></td><td>2026-10-07</td></tr>
  <tr><td><b>Description:</b></td><td>This documentation describes the HANA Calculation View 'CV_BASE_MD_RCALWEEK_S4', which serves as a base view for retail calendar week master data, referencing the table 'ZTFIGL_RCALWEEK'.</td></tr>
</table>
<hr/>

<!-- 1. Overview of Program -->
<p>The object is a HANA Calculation View of type 'TREE_BASED' with data category 'DIMENSION'. Its primary purpose is to provide a projection of retail calendar week master data from the data source 'ZTFIGL_RCALWEEK'. The view applies a filter on the 'RCLNT' field and exposes a set of week-related attributes as output.</p>
<hr/>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View consists of a single Projection node ('Projection_1') that sources data from the base table 'ZTFIGL_RCALWEEK'. It defines a set of view attributes corresponding to week and period fields, and applies a filter to the 'RCLNT' field with values '120' and '200'. <b>Key Components:</b> The main components are the data source ('ZTFIGL_RCALWEEK'), the Projection node, view attributes, and the logical model mapping these attributes to output fields. <b>Dependencies & Performance:</b> The only dependency is the referenced table 'ZTFIGL_RCALWEEK'. No joins, aggregations, or calculated fields are present, indicating a straightforward projection with minimal processing overhead.</p>
<hr/>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; background:#f9f9f9; padding:16px; border-radius:8px;">
  <div style="display:grid; grid-template-columns:repeat(2, 220px); grid-template-rows:repeat(3, 80px); gap:32px; align-items:center;">
    <div style="grid-row:1; grid-column:1; background:#e3e7f1; border-radius:8px; padding:18px; text-align:center; font-weight:bold;">Data Source:<br/>ZTFIGL_RCALWEEK</div>
    <div style="grid-row:2; grid-column:2; background:#d8f6e6; border-radius:8px; padding:18px; text-align:center; font-weight:bold;">Projection_1<br/>(Filter: RCLNT IN [120, 200])</div>
    <div style="grid-row:3; grid-column:1; background:#fffbe6; border-radius:8px; padding:18px; text-align:center; font-weight:bold;">Output<br/>Retail Calendar Week Attributes</div>
    <svg style="grid-row:1; grid-column:1/2; height:80px; width:80px; position:relative; left:220px; top:0;" xmlns="http://www.w3.org/2000/svg">
      <defs><marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7"/></marker></defs>
      <line x1="0" y1="40" x2="80" y2="40" stroke="#888" stroke-width="3" marker-end="url(#arrowhead)" />
    </svg>
    <svg style="grid-row:2; grid-column:2/1; height:80px; width:80px; position:relative; left:-220px; top:80px;" xmlns="http://www.w3.org/2000/svg">
      <defs><marker id="arrowhead2" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7"/></marker></defs>
      <line x1="80" y1="40" x2="0" y2="40" stroke="#888" stroke-width="3" marker-end="url(#arrowhead2)" />
    </svg>
    <svg style="grid-row:3; grid-column:1/2; height:80px; width:80px; position:relative; left:220px; top:160px;" xmlns="http://www.w3.org/2000/svg">
      <defs><marker id="arrowhead3" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7"/></marker></defs>
      <line x1="0" y1="40" x2="80" y2="40" stroke="#888" stroke-width="3" marker-end="url(#arrowhead3)" />
    </svg>
  </div>
</div>
<hr/>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="4" cellspacing="0">
  <tr>
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr>
    <td>Projection_1 / RCLNT</td>
    <td>RCLNT</td>
    <td>ZTFIGL_RCALWEEK / RCLNT</td>
    <td>RCLNT</td>
    <td>Filter applied: IN (120, 200)</td>
  </tr>
  <tr>
    <td>Projection_1 / ZZWEEK</td>
    <td>ZZWEEK</td>
    <td>ZTFIGL_RCALWEEK / ZZWEEK</td>
    <td>ZZWEEK</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1 / ZCALYRP</td>
    <td>ZCALYRP</td>
    <td>ZTFIGL_RCALWEEK / ZCALYRP</td>
    <td>ZCALYRP</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1 / ZRYEAR</td>
    <td>ZRYEAR</td>
    <td>ZTFIGL_RCALWEEK / ZRYEAR</td>
    <td>ZRYEAR</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1 / ZRPERIOD</td>
    <td>ZRPERIOD</td>
    <td>ZTFIGL_RCALWEEK / ZRPERIOD</td>
    <td>ZRPERIOD</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1 / ZRYRP</td>
    <td>ZRYRP</td>
    <td>ZTFIGL_RCALWEEK / ZRYRP</td>
    <td>ZRYRP</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1 / ZRYRQTR</td>
    <td>ZRYRQTR</td>
    <td>ZTFIGL_RCALWEEK / ZRYRQTR</td>
    <td>ZRYRQTR</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1 / ZRWSTRTDATE</td>
    <td>ZRWSTRTDATE</td>
    <td>ZTFIGL_RCALWEEK / ZRWSTRTDATE</td>
    <td>ZRWSTRTDATE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1 / ZRWENDDATE</td>
    <td>ZRWENDDATE</td>
    <td>ZTFIGL_RCALWEEK / ZRWENDDATE</td>
    <td>ZRWENDDATE</td>
    <td>Direct mapping</td>
  </tr>
</table>
<hr/>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="4" cellspacing="0">
  <tr><th>Category</th><th>Measurement</th></tr>
  <tr><td>Number of Objects/Nodes</td><td>2 (Data Source, Projection Node)</td></tr>
  <tr><td>Sources Used</td><td>1 (ZTFIGL_RCALWEEK)</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None identified</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>Filter on RCLNT (IN 120, 200)</td></tr>
  <tr><td>Workflow Complexity</td><td>Simple linear flow: Data Source → Projection → Output</td></tr>
  <tr><td>Performance Considerations</td><td>Minimal processing; single filter, no joins or aggregations</td></tr>
  <tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single table dependency</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>
<hr/>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found
<hr/>

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
<hr/>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
