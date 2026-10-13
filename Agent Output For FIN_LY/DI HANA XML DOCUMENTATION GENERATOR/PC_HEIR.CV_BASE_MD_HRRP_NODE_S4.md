<!-- DOCUMENT HEADER -->
<table style="width:100%;border-collapse:collapse;margin-bottom:16px;">
  <tr>
    <td style="font-weight:bold;width:20%;">Author:</td>
    <td>Ascendion AAVA</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Created On:</td>
    <td>2026-10-12</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Description:</td>
    <td>Technical documentation for the HANA Calculation View <b>CV_BASE_MD_HRRP_NODE_S4</b>. This view serves as the base for HRRP_NODE hierarchy master data, projecting and filtering relevant fields from a single source table.</td>
  </tr>
</table>

<!-- 1. Overview of Program -->
<p><b>Overview of Program</b><br>
This HANA XML defines a Calculation View of type <b>DIMENSION</b> named <b>CV_BASE_MD_HRRP_NODE_S4</b>. Its primary purpose is to provide a base projection of the HRRP_NODE hierarchy master data from a single data source. The view applies attribute filtering and exposes key fields relevant to hierarchy nodes.</p>

<!-- 2. Code Structure and Design -->
<p>
<b>Structure:</b> The Calculation View is structured with a single projection node (<b>Projection_1</b>) sourcing data from the HRRP_NODE base table. It includes explicit attribute mapping and a filter on the <b>MANDT</b> field, projecting eleven attributes to the output. No joins, unions, aggregations, or calculated fields are present.<br>
<b>Key Components:</b> The major components are the <b>HRRP_NODE</b> data source (type: DATA_BASE_TABLE), the <b>Projection_1</b> node, view attribute mappings, and a logical model defining the output attributes with descriptions. The only filter applied is an <b>IN</b> condition on <b>MANDT</b> (values: 120, 200).<br>
<b>Dependencies & Performance:</b> The view depends solely on the HRRP_NODE table in the schema <b>SAP_S4</b>. No joins, aggregations, or complex processing are present, implying minimal dependency and low processing complexity. The filter on <b>MANDT</b> may improve selectivity; no further performance-relevant logic is observed.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;padding:16px;background:#f9f9f9;border-radius:8px;">
  <div style="display:grid;grid-template-columns:repeat(3,220px);grid-template-rows:repeat(2,120px);gap:40px;align-items:center;justify-items:center;">
    <div style="grid-column:1;grid-row:1;background:#e3e6f3;border-radius:8px;padding:24px;text-align:center;font-weight:bold;box-shadow:0 2px 8px #dbe2ef;">HRRP_NODE<br><span style="font-size:12px;font-weight:normal;">(DATA_BASE_TABLE)</span></div>
    <div style="grid-column:2;grid-row:2;background:#d4f4e5;border-radius:8px;padding:24px;text-align:center;font-weight:bold;box-shadow:0 2px 8px #c2e8d3;">Projection_1<br><span style="font-size:12px;font-weight:normal;">Attribute Mapping & Filter</span></div>
    <div style="grid-column:3;grid-row:1;background:#fce5cd;border-radius:8px;padding:24px;text-align:center;font-weight:bold;box-shadow:0 2px 8px #f8d4a3;">Output<br><span style="font-size:12px;font-weight:normal;">(Logical Model)</span></div>
    <!-- Arrows -->
    <div style="grid-column:1;grid-row:1;justify-self:end;align-self:center;">
      <svg width="80" height="40"><line x1="0" y1="20" x2="80" y2="100" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
    </div>
    <div style="grid-column:2;grid-row:2;justify-self:end;align-self:center;">
      <svg width="80" height="40"><line x1="0" y1="20" x2="80" y2="-80" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
    </div>
    <!-- Arrowhead definition -->
    <svg style="position:absolute;width:0;height:0;">
      <defs>
        <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
          <polygon points="0 0, 10 3.5, 0 7" fill="#888" />
        </marker>
      </defs>
    </svg>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%;border-collapse:collapse;margin-bottom:16px;">
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
    <tr><td>Projection_1.MANDT</td><td>MANDT</td><td>HRRP_NODE</td><td>MANDT</td><td>IN filter applied: 120, 200</td></tr>
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
<table style="width:100%;border-collapse:collapse;margin-bottom:16px;">
  <tr><td>Number of Objects/Nodes</td><td>2 (HRRP_NODE data source, Projection_1 projection node)</td></tr>
  <tr><td>Sources Used</td><td>HRRP_NODE (DATA_BASE_TABLE) in schema SAP_S4</td></tr>
  <tr><td>Joins</td><td>None</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>MANDT IN filter (values: 120, 200)</td></tr>
  <tr><td>Workflow Complexity</td><td>Low; single projection node, no joins or aggregations</td></tr>
  <tr><td>Performance Considerations</td><td>Simple projection; filter on MANDT may improve selectivity</td></tr>
  <tr><td>Data Volume Handling</td><td>No data-volume-specific logic identified</td></tr>
  <tr><td>Dependency Complexity</td><td>Single dependency (HRRP_NODE table)</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>MANDT</li>
  <li>HRYID</li>
  <li>HRYVER</li>
  <li>NODECLS</li>
  <li>HRYNODE</li>
  <li>PARNODE</li>
  <li>HRYVALTO</li>
  <li>HRYVALFROM</li>
  <li>BALIND</li>
  <li>NODETYPE</li>
  <li>NODEVALUE</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
