<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:8px;margin-bottom:16px;">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> 2026-10-07<br>
  <b>Description:</b> Base view for HRRP_NODE - Hierarchy Master Data. This HANA XML object defines a Calculation View for exposing hierarchy-related master data fields, with filtering applied to the client (MANDT) field.
</div>

<!-- 1. Overview of Program -->
<div style="margin-bottom:16px;">
  This object is a HANA Calculation View of type DIMENSION. Its primary purpose is to provide a projection of hierarchy master data from the HRRP_NODE table, exposing key hierarchy fields. The view applies a filter to the MANDT field and maps source columns directly to the output.
</div>

<!-- 2. Code Structure and Design -->
<div style="margin-bottom:16px;">
  <b>Structure:</b> The Calculation View is structured with a single projection node (Projection_1) sourcing data from the HRRP_NODE base table. The projection defines explicit view attributes corresponding to hierarchy master data fields, with a filter applied to the MANDT field for specific client values (120, 200). No calculated fields, joins, aggregations, or unions are present.<br>
  <b>Key Components:</b> The main components are the HRRP_NODE data source (type DATA_BASE_TABLE), the Projection_1 node, and the logical model mapping output attributes. Each output field is directly mapped from the corresponding source column, and only the MANDT field has an explicit filter.<br>
  <b>Dependencies & Performance:</b> The Calculation View depends on the HRRP_NODE table in the schema SAP_S4. No joins, aggregations, or complex processing are defined, and the absence of calculated fields or nested nodes indicates low structural complexity. The filter on MANDT may slightly optimize data access by restricting client values.
</div>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;padding:12px 0;background:#f9f9f9;border-radius:8px;">
  <style>
    .workflow-grid {
      display: grid;
      grid-template-columns: 160px 40px 160px;
      grid-template-rows: 60px 60px;
      align-items: center;
      justify-items: center;
      gap: 0px 0px;
      min-width: 400px;
      width: 100%;
    }
    .workflow-box {
      background: #e6f0fa;
      border: 1px solid #b2c2d2;
      border-radius: 8px;
      width: 150px;
      height: 50px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 14px;
      font-weight: 500;
      box-shadow: 0 1px 3px rgba(30,60,90,0.07);
    }
    .workflow-arrow {
      font-size: 32px;
      color: #8ca1b3;
      user-select: none;
    }
  </style>
  <div class="workflow-grid">
    <div class="workflow-box" style="grid-row:1;grid-column:1;">HRRP_NODE<br>(Base Table)</div>
    <div class="workflow-arrow" style="grid-row:1;grid-column:2;">→</div>
    <div class="workflow-box" style="grid-row:1;grid-column:3;">Projection_1<br>(Projection Node)<br>MANDT Filter</div>
    <div></div>
    <div></div>
    <div class="workflow-box" style="grid-row:2;grid-column:3;">Output<br>(Logical Model)</div>
    <div style="grid-row:2;grid-column:2;">↑</div>
    <div></div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="5" cellspacing="0" style="border-collapse:collapse;width:100%;margin-bottom:16px;">
  <tr>
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr>
    <td>Projection_1.MANDT</td>
    <td>MANDT</td>
    <td>HRRP_NODE</td>
    <td>MANDT</td>
    <td>Filter applied: IN (120, 200)</td>
  </tr>
  <tr>
    <td>Projection_1.HRYID</td>
    <td>HRYID</td>
    <td>HRRP_NODE</td>
    <td>HRYID</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.HRYVER</td>
    <td>HRYVER</td>
    <td>HRRP_NODE</td>
    <td>HRYVER</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.NODECLS</td>
    <td>NODECLS</td>
    <td>HRRP_NODE</td>
    <td>NODECLS</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.HRYNODE</td>
    <td>HRYNODE</td>
    <td>HRRP_NODE</td>
    <td>HRYNODE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.PARNODE</td>
    <td>PARNODE</td>
    <td>HRRP_NODE</td>
    <td>PARNODE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.HRYVALTO</td>
    <td>HRYVALTO</td>
    <td>HRRP_NODE</td>
    <td>HRYVALTO</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.HRYVALFROM</td>
    <td>HRYVALFROM</td>
    <td>HRRP_NODE</td>
    <td>HRYVALFROM</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.BALIND</td>
    <td>BALIND</td>
    <td>HRRP_NODE</td>
    <td>BALIND</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.NODETYPE</td>
    <td>NODETYPE</td>
    <td>HRRP_NODE</td>
    <td>NODETYPE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.NODEVALUE</td>
    <td>NODEVALUE</td>
    <td>HRRP_NODE</td>
    <td>NODEVALUE</td>
    <td>Direct mapping</td>
  </tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="5" cellspacing="0" style="border-collapse:collapse;width:100%;margin-bottom:16px;">
  <tr><th>Category</th><th>Measurement</th></tr>
  <tr><td>Number of Objects/Nodes</td><td>3 (HRRP_NODE data source, Projection_1 node, Logical Model)</td></tr>
  <tr><td>Sources Used</td><td>HRRP_NODE (DATA_BASE_TABLE)</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None identified</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>MANDT filter (IN operator)</td></tr>
  <tr><td>Workflow Complexity</td><td>Simple linear projection; single node, direct mapping</td></tr>
  <tr><td>Performance Considerations</td><td>Filter on MANDT may reduce data volume; otherwise minimal processing</td></tr>
  <tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single dependency on HRRP_NODE table</td></tr>
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
