<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse;">
  <tr>
    <td style="width:20%; font-weight:bold;">Author:</td>
    <td style="width:80%;">Ascendion AAVA</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Created On:</td>
    <td id="created-date">[DATE_PLACEHOLDER]</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Description:</td>
    <td>Base Calculation View for HRRP_NODE Hierarchy Master Data, designed to project and filter hierarchy-related fields from a single table source.</td>
  </tr>
</table>

<!-- 1. Overview of Program -->
<p>This HANA XML object defines a Calculation View of type <b>TREE_BASED</b> with data category <b>DIMENSION</b>. Its primary purpose is to provide a base view for hierarchy master data from the HRRP_NODE table. The view projects relevant hierarchy fields and applies a filter on the client field (MANDT).</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View consists of a single Projection node (Projection_1) sourcing data from the HRRP_NODE base table. All view attributes from the source table are projected, with a filter applied to the MANDT field to restrict values to 120 and 200. No joins, aggregations, unions, or calculated fields are present.<br>
<b>Key Components:</b> The key components are the HRRP_NODE data source, the Projection_1 node, and the logical model attributes that define the output structure. The Projection node maps each field from the source to the output, and the logical model provides descriptions for each attribute.<br>
<b>Dependencies & Performance:</b> The object depends solely on the HRRP_NODE table as its source. The only filter applied is on MANDT. There are no joins, aggregations, or calculated expressions, resulting in a straightforward data flow with minimal dependency and low complexity.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; background:#f9f9fc; padding:16px; border-radius:8px; max-width:900px;">
  <div style="display:grid; grid-template-columns: 180px 50px 180px 50px 180px; grid-template-rows: 80px 80px 80px; align-items:center;">
    <!-- Source Table -->
    <div style="grid-column:1; grid-row:2; background:#e6eaff; border-radius:6px; box-shadow:0 1px 4px #d2d2f2; padding:16px; text-align:center; font-weight:bold;">HRRP_NODE<br/><span style="font-size:12px; color:#6a6a7a;">Base Table</span></div>
    <!-- Arrow -->
    <div style="grid-column:2; grid-row:2; text-align:center;">
      <svg width="50" height="40"><line x1="0" y1="20" x2="50" y2="20" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/><defs><marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#888"/></marker></defs></svg>
    </div>
    <!-- Projection Node -->
    <div style="grid-column:3; grid-row:2; background:#d9f7e9; border-radius:6px; box-shadow:0 1px 4px #b2e3cb; padding:16px; text-align:center; font-weight:bold;">Projection_1<br/><span style="font-size:12px; color:#6a6a7a;">Projection Node<br/>Filter: MANDT IN (120, 200)</span></div>
    <!-- Arrow -->
    <div style="grid-column:4; grid-row:2; text-align:center;">
      <svg width="50" height="40"><line x1="0" y1="20" x2="50" y2="20" stroke="#888" stroke-width="2" marker-end="url(#arrowhead2)"/><defs><marker id="arrowhead2" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#888"/></marker></defs></svg>
    </div>
    <!-- Output -->
    <div style="grid-column:5; grid-row:2; background:#fff4e6; border-radius:6px; box-shadow:0 1px 4px #ffe1c2; padding:16px; text-align:center; font-weight:bold;">Output<br/><span style="font-size:12px; color:#6a6a7a;">Logical Model<br/>11 Attributes</span></div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%; border-collapse:collapse;">
  <thead>
    <tr style="background:#e6eaff;">
      <th>Target Object/Field Name</th>
      <th>Target Column Name</th>
      <th>Source Object/Field Name</th>
      <th>Source Column Name</th>
      <th>Remarks</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Projection_1.MANDT</td>
      <td>MANDT</td>
      <td>HRRP_NODE.MANDT</td>
      <td>MANDT</td>
      <td>Filter applied: IN (120, 200)</td>
    </tr>
    <tr>
      <td>Projection_1.HRYID</td>
      <td>HRYID</td>
      <td>HRRP_NODE.HRYID</td>
      <td>HRYID</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1.HRYVER</td>
      <td>HRYVER</td>
      <td>HRRP_NODE.HRYVER</td>
      <td>HRYVER</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1.NODECLS</td>
      <td>NODECLS</td>
      <td>HRRP_NODE.NODECLS</td>
      <td>NODECLS</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1.HRYNODE</td>
      <td>HRYNODE</td>
      <td>HRRP_NODE.HRYNODE</td>
      <td>HRYNODE</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1.PARNODE</td>
      <td>PARNODE</td>
      <td>HRRP_NODE.PARNODE</td>
      <td>PARNODE</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1.HRYVALTO</td>
      <td>HRYVALTO</td>
      <td>HRRP_NODE.HRYVALTO</td>
      <td>HRYVALTO</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1.HRYVALFROM</td>
      <td>HRYVALFROM</td>
      <td>HRRP_NODE.HRYVALFROM</td>
      <td>HRYVALFROM</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1.BALIND</td>
      <td>BALIND</td>
      <td>HRRP_NODE.BALIND</td>
      <td>BALIND</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1.NODETYPE</td>
      <td>NODETYPE</td>
      <td>HRRP_NODE.NODETYPE</td>
      <td>NODETYPE</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>Projection_1.NODEVALUE</td>
      <td>NODEVALUE</td>
      <td>HRRP_NODE.NODEVALUE</td>
      <td>NODEVALUE</td>
      <td>Direct mapping</td>
    </tr>
  </tbody>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%; border-collapse:collapse;">
  <thead>
    <tr style="background:#e6eaff;">
      <th>Category</th>
      <th>Measurement</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>Number of Objects/Nodes</td><td>2 (HRRP_NODE table, Projection_1 node)</td></tr>
    <tr><td>Sources Used</td><td>1 (HRRP_NODE)</td></tr>
    <tr><td>Joins</td><td>None identified</td></tr>
    <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
    <tr><td>Aggregate Functions</td><td>None identified</td></tr>
    <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
    <tr><td>Conditional Logic</td><td>Filter: MANDT IN (120, 200)</td></tr>
    <tr><td>Workflow Complexity</td><td>Low; simple projection and filter from a single source</td></tr>
    <tr><td>Performance Considerations</td><td>Minimal; single filter, no joins or aggregations</td></tr>
    <tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
    <tr><td>Dependency Complexity</td><td>Low; only HRRP_NODE table referenced</td></tr>
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
