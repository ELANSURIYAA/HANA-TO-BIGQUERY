<!-- DOCUMENT HEADER -->
<table style="width:100%;border-collapse:collapse;">
  <tr>
    <td style="font-weight:bold;width:15%;">Author:</td>
    <td>Ascendion AAVA</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Created On:</td>
    <td>2026-10-12</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Description:</td>
    <td>Technical documentation for HANA Calculation View <b>CV_BASE_MD_HRRP_NODE_S4</b>, serving as a base view for HRRP_NODE hierarchy master data. The view projects fields from a single data source with applied filters and provides structured output for hierarchy node information.</td>
  </tr>
</table>

<!-- 1. Overview of Program -->
<p><b>Overview of Program</b><br>
This object is a HANA Calculation View of type <b>TREE_BASED</b> with data category <b>DIMENSION</b>. Its primary purpose is to project and filter hierarchy node master data from the HRRP_NODE table. The view delivers structured output for hierarchy-related fields based on filtered client values.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View comprises a single Projection node named <b>Projection_1</b> sourcing data from the HRRP_NODE base table. The projection defines view attributes corresponding to the source columns and applies a filter on the <b>MANDT</b> field for values 120 and 200. No calculated fields, joins, aggregations, or unions are present.<br>
<b>Key Components:</b> The major components are the data source <b>HRRP_NODE</b> (type: DATA_BASE_TABLE), the Projection node, explicit attribute mappings, and the logical model specifying the output attributes with descriptions. The filter on <b>MANDT</b> is a key element for restricting data.<br>
<b>Dependencies & Performance:</b> The view depends solely on the HRRP_NODE table as its source. No joins or complex processing are involved, and the filter on <b>MANDT</b> is the only performance-relevant characteristic visible from the XML. No aggregation or nested processing is defined.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;padding:10px;background:#f9f9f9;border-radius:8px;">
  <div style="display:grid;grid-template-columns:repeat(3,180px);grid-template-rows:repeat(3,100px);gap:40px;align-items:center;justify-items:center;">
    <!-- Data Source -->
    <div style="grid-column:2;grid-row:1;background:#e1eaff;border:1px solid #b3c6e7;border-radius:8px;padding:18px;text-align:center;font-weight:bold;">HRRP_NODE<br><span style="font-size:12px;">(Base Table)</span></div>
    <!-- Arrow -->
    <div style="grid-column:2;grid-row:2;text-align:center;">
      <svg width="40" height="60"><defs><marker id="arrowhead" markerWidth="10" markerHeight="7" refX="0" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#6c7a89"/></marker></defs><line x1="20" y1="0" x2="20" y2="60" stroke="#6c7a89" stroke-width="3" marker-end="url(#arrowhead)"/></svg>
    </div>
    <!-- Projection Node -->
    <div style="grid-column:2;grid-row:3;background:#e9ffe1;border:1px solid #b6ddb3;border-radius:8px;padding:18px;text-align:center;font-weight:bold;">Projection_1<br><span style="font-size:12px;">Filter: MANDT IN (120, 200)</span></div>
    <!-- Arrow -->
    <div style="grid-column:2;grid-row:4;text-align:center;">
      <svg width="40" height="60"><defs><marker id="arrowhead2" markerWidth="10" markerHeight="7" refX="0" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#6c7a89"/></marker></defs><line x1="20" y1="0" x2="20" y2="60" stroke="#6c7a89" stroke-width="3" marker-end="url(#arrowhead2)"/></svg>
    </div>
    <!-- Output -->
    <div style="grid-column:2;grid-row:5;background:#fff4e1;border:1px solid #e4cfa1;border-radius:8px;padding:18px;text-align:center;font-weight:bold;">Output<br><span style="font-size:12px;">View Attributes</span></div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%;border-collapse:collapse;">
  <thead>
    <tr style="background:#e1eaff;">
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
      <td>HRRP_NODE / MANDT</td>
      <td>MANDT</td>
      <td>Filter applied: IN (120, 200)</td>
    </tr>
    <tr>
      <td>Projection_1 / HRYID</td>
      <td>HRYID</td>
      <td>HRRP_NODE / HRYID</td>
      <td>HRYID</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1 / HRYVER</td>
      <td>HRYVER</td>
      <td>HRRP_NODE / HRYVER</td>
      <td>HRYVER</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1 / NODECLS</td>
      <td>NODECLS</td>
      <td>HRRP_NODE / NODECLS</td>
      <td>NODECLS</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1 / HRYNODE</td>
      <td>HRYNODE</td>
      <td>HRRP_NODE / HRYNODE</td>
      <td>HRYNODE</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1 / PARNODE</td>
      <td>PARNODE</td>
      <td>HRRP_NODE / PARNODE</td>
      <td>PARNODE</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1 / HRYVALTO</td>
      <td>HRYVALTO</td>
      <td>HRRP_NODE / HRYVALTO</td>
      <td>HRYVALTO</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1 / HRYVALFROM</td>
      <td>HRYVALFROM</td>
      <td>HRRP_NODE / HRYVALFROM</td>
      <td>HRYVALFROM</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1 / BALIND</td>
      <td>BALIND</td>
      <td>HRRP_NODE / BALIND</td>
      <td>BALIND</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1 / NODETYPE</td>
      <td>NODETYPE</td>
      <td>HRRP_NODE / NODETYPE</td>
      <td>NODETYPE</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1 / NODEVALUE</td>
      <td>NODEVALUE</td>
      <td>HRRP_NODE / NODEVALUE</td>
      <td>NODEVALUE</td>
      <td>Direct mapping</td>
    </tr>
  </tbody>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%;border-collapse:collapse;">
  <thead>
    <tr style="background:#e1eaff;">
      <th>Category</th>
      <th>Measurement</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>Number of Objects/Nodes</td><td>2 (Data Source: HRRP_NODE, Projection Node: Projection_1)</td></tr>
    <tr><td>Sources Used</td><td>1 (HRRP_NODE)</td></tr>
    <tr><td>Joins</td><td>None identified</td></tr>
    <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
    <tr><td>Aggregate Functions</td><td>None identified</td></tr>
    <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
    <tr><td>Conditional Logic</td><td>MANDT filter (IN condition)</td></tr>
    <tr><td>Workflow Complexity</td><td>Low (single projection node, direct mapping)</td></tr>
    <tr><td>Performance Considerations</td><td>Single filter on MANDT, no joins or aggregations</td></tr>
    <tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
    <tr><td>Dependency Complexity</td><td>Single data source dependency</td></tr>
    <tr><td>Overall Complexity Score</td><td>Low</td></tr>
  </tbody>
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
