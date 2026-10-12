<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse; margin-bottom:20px;">
  <tr>
    <td><b>Author:</b></td>
    <td>Ascendion AAVA</td>
  </tr>
  <tr>
    <td><b>Created On:</b></td>
    <td>2026-10-12</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td>This documentation describes a HANA Calculation View named <b>CV_BASE_MD_HRRP_NODE_S4</b>, which serves as a base view for HRRP_NODE Hierarchy Master Data. The view projects fields from the HRRP_NODE database table and applies a filter to the MANDT field.</td>
  </tr>
</table>

<!-- 1. Overview of Program -->
<p><b>Overview of Program:</b><br>
This object is a HANA Calculation View of type <b>TREE_BASED</b> with data category <b>DIMENSION</b>. Its primary purpose is to provide a projection of master data from the HRRP_NODE table, specifically for hierarchy-related attributes. The view filters the MANDT field and exposes relevant hierarchy node information as output attributes.</p>

<!-- 2. Code Structure and Design -->
<p>
<b>Structure:</b> The Calculation View consists of a single projection node (<b>Projection_1</b>) that sources its data from the <b>HRRP_NODE</b> database table. The projection includes eleven attributes, applies a filter on the MANDT field (IN 120, 200), and maps each output attribute directly to the corresponding source field. No calculated attributes, joins, unions, or aggregations are present.
<br><b>Key Components:</b> The major components are the <b>HRRP_NODE</b> data source (type: DATA_BASE_TABLE), the <b>Projection_1</b> node, and the logical model defining the output attributes. The filter applied to MANDT is the only transformation.
<br><b>Dependencies & Performance:</b> The Calculation View depends solely on the HRRP_NODE table. No joins, aggregations, or nested processing are present. The filter on MANDT may affect performance by reducing data volume at runtime, but no additional complexity or dependencies are introduced.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="width:100%; overflow-x:auto; background:#f7f7fa; padding:16px; border-radius:8px;">
  <div style="display:grid; grid-template-columns:repeat(3, 220px); grid-template-rows:repeat(2, 100px); gap:32px; align-items:center;">
    <!-- Data Source -->
    <div style="grid-column:1; grid-row:1; background:#e2e6f3; border-radius:8px; box-shadow:0 2px 8px #d4d4d4; text-align:center; padding:24px; font-weight:bold;">HRRP_NODE<br><span style="font-size:12px; color:#555;">(Database Table)</span></div>
    <!-- Arrow -->
    <div style="grid-column:2; grid-row:1; text-align:center;">
      <span style="display:inline-block; border-left:4px solid #7b7b9a; height:40px;"></span><br>
      <span style="display:inline-block; border-bottom:4px solid #7b7b9a; width:60px;"></span>
    </div>
    <!-- Projection Node -->
    <div style="grid-column:3; grid-row:1; background:#dde7e3; border-radius:8px; box-shadow:0 2px 8px #d4d4d4; text-align:center; padding:24px; font-weight:bold;">Projection_1<br><span style="font-size:12px; color:#555;">(Projection Node)<br>Filter: MANDT IN (120, 200)</span></div>
    <!-- Arrow -->
    <div style="grid-column:2; grid-row:2; text-align:center;">
      <span style="display:inline-block; border-left:4px solid #7b7b9a; height:40px;"></span><br>
      <span style="display:inline-block; border-bottom:4px solid #7b7b9a; width:60px;"></span>
    </div>
    <!-- Output -->
    <div style="grid-column:3; grid-row:2; background:#f9f2e7; border-radius:8px; box-shadow:0 2px 8px #d4d4d4; text-align:center; padding:24px; font-weight:bold;">Output<br><span style="font-size:12px; color:#555;">(View Attributes)</span></div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%; border-collapse:collapse; margin-top:20px;">
  <thead style="background:#ececec;">
    <tr>
      <th>Target Object/Field Name</th>
      <th>Target Column Name</th>
      <th>Source Object/Field Name</th>
      <th>Source Column Name</th>
      <th>Remarks</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>Projection_1.MANDT</td><td>MANDT</td><td>HRRP_NODE</td><td>MANDT</td><td>Filter: IN (120, 200)</td></tr>
    <tr><td>Projection_1.HRYID</td><td>HRYID</td><td>HRRP_NODE</td><td>HRYID</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.HRYVER</td><td>HRYVER</td><td>HRRP_NODE</td><td>HRYVER</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.NODECLS</td><td>NODECLS</td><td>HRRP_NODE</td><td>NODECLS</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.HRYNODE</td><td>HRYNODE</td><td>HRRP_NODE</td><td>HRYNODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.PARNODE</td><td>PARNODE</td><td>HRRP_NODE</td><td>PARNODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.HRYVALTO</td><td>HRYVALTO</td><td>HRRP_NODE</td><td>HRYVALTO</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.HRYVALFROM</td><td>HRYVALFROM</td><td>HRRP_NODE</td><td>HRYVALFROM</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.BALIND</td><td>BALIND</td><td>HRRP_NODE</td><td>BALIND</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.NODETYPE</td><td>NODETYPE</td><td>HRRP_NODE</td><td>NODETYPE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1.NODEVALUE</td><td>NODEVALUE</td><td>HRRP_NODE</td><td>NODEVALUE</td><td>Direct mapping</td></tr>
  </tbody>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%; border-collapse:collapse; margin-top:20px;">
  <tr><td>Number of Objects/Nodes</td><td>2 (HRRP_NODE table, Projection_1 node)</td></tr>
  <tr><td>Sources Used</td><td>1 (HRRP_NODE database table)</td></tr>
  <tr><td>Joins</td><td>None</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>MANDT field filter (IN 120, 200)</td></tr>
  <tr><td>Workflow Complexity</td><td>Simple: single source, single projection node, direct mapping</td></tr>
  <tr><td>Performance Considerations</td><td>Filter on MANDT reduces data volume; no joins or aggregations</td></tr>
  <tr><td>Data Volume Handling</td><td>Filter applied to MANDT field</td></tr>
  <tr><td>Dependency Complexity</td><td>Single dependency: HRRP_NODE table</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>MANDT (Client)</li>
  <li>HRYID (Hierarchy ID)</li>
  <li>HRYVER (Hierarchy version)</li>
  <li>NODECLS (Node class)</li>
  <li>HRYNODE (Hierarchy node)</li>
  <li>PARNODE (Hierarchy parent node)</li>
  <li>HRYVALTO (Valid To Date)</li>
  <li>HRYVALFROM (Valid-From Date)</li>
  <li>BALIND (Balance indicator)</li>
  <li>NODETYPE (Hierarchy node type)</li>
  <li>NODEVALUE (Node value)</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
