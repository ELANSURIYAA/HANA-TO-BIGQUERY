<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:8px;margin-bottom:16px">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> 2026-10-12<br>
  <b>Description:</b> Technical documentation for the HANA Calculation View <b>CV_BASE_MD_HRRP_NODE_S4</b>, which serves as a base view for HRRP_NODE hierarchy master data. The object is structured as a dimension-type Calculation View, performing a direct projection of fields from a physical table with minimal processing logic.
</div>

<!-- 1. Overview of Program -->
<div style="margin-bottom:16px">
  The provided HANA XML defines a Calculation View of type <b>dimension</b> named <b>CV_BASE_MD_HRRP_NODE_S4</b>. Its primary purpose is to expose hierarchy master data from the HRRP_NODE base table via a 1:1 projection. The view applies a simple filter to the MANDT field and passes through all other columns without transformation or aggregation.
</div>

<!-- 2. Code Structure and Design -->
<div style="margin-bottom:16px">
  <b>Structure:</b> The Calculation View consists of a single projection node (<b>Projection_1</b>) sourcing data from the physical table <b>HRRP_NODE</b> within the schema <b>SAP_S4</b>. The projection node outputs eleven fields, with a filter applied to the <b>MANDT</b> field to restrict values to 120 and 200. No calculated fields, joins, aggregations, unions, or nested processing nodes are present. <br>
  <b>Key Components:</b> Major components include the <b>HRRP_NODE</b> data source (physical table), the <b>Projection_1</b> node for field mapping and filtering, and the logical model defining output attributes and their descriptions. All fields are mapped directly from source to output, with descriptive labels provided in the logical model.<br>
  <b>Dependencies & Performance:</b> The view depends solely on the <b>HRRP_NODE</b> table as its source. No additional dependencies, joins, or complex processing logic are present. The absence of aggregations, calculated fields, or nested nodes suggests minimal processing overhead and straightforward performance characteristics.
</div>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;background:#f9f9f9;border-radius:6px;padding:16px;margin-bottom:16px">
<style>
  .workflow-grid {
    display: grid;
    grid-template-columns: repeat(3, 220px);
    grid-template-rows: repeat(3, 80px);
    gap: 36px 20px;
    align-items: center;
    justify-items: center;
    min-width: 720px;
  }
  .workflow-box {
    background: #e6f2ff;
    border-radius: 6px;
    box-shadow: 0 1px 4px #c0c0c0;
    font-weight: 500;
    padding: 18px 16px;
    text-align: center;
    width: 180px;
    height: 48px;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .arrow {
    width: 40px;
    height: 0;
    border-top: 2px solid #888;
    position: relative;
    margin-bottom: 0;
  }
  .arrowhead {
    width: 0;
    height: 0;
    border-left: 7px solid transparent;
    border-right: 7px solid transparent;
    border-top: 12px solid #888;
    position: absolute;
    left: 16px;
    top: -8px;
  }
</style>
<div class="workflow-grid">
  <div class="workflow-box" style="grid-column:1;grid-row:1;">HRRP_NODE<br><span style="font-size:12px;color:#666">Physical Table</span></div>
  <div style="grid-column:2;grid-row:1;">
    <div class="arrow"></div>
    <div class="arrowhead"></div>
  </div>
  <div class="workflow-box" style="grid-column:3;grid-row:1;">Projection_1<br><span style="font-size:12px;color:#666">Projection Node</span></div>
  <div style="grid-column:3;grid-row:2;">
    <div class="arrow" style="transform:rotate(90deg);width:0;height:40px;margin-left:90px"></div>
    <div class="arrowhead" style="transform:rotate(90deg);left:-6px;top:32px"></div>
  </div>
  <div class="workflow-box" style="grid-column:3;grid-row:3;">Output<br><span style="font-size:12px;color:#666">View Output</span></div>
</div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;margin-bottom:16px">
  <tr style="background:#e6f2ff">
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
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
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;margin-bottom:16px">
  <tr style="background:#e6f2ff">
    <th>Category</th>
    <th>Measurement</th>
  </tr>
  <tr><td>Number of Objects/Nodes</td><td>2 (Data Source: HRRP_NODE, Projection Node: Projection_1)</td></tr>
  <tr><td>Sources Used</td><td>HRRP_NODE (physical table)</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None identified</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>MANDT filter: IN (120, 200)</td></tr>
  <tr><td>Workflow Complexity</td><td>Simple linear flow: source table &rarr; projection &rarr; output</td></tr>
  <tr><td>Performance Considerations</td><td>Minimal processing, single filter, direct mapping</td></tr>
  <tr><td>Data Volume Handling</td><td>Cannot be determined from the XML</td></tr>
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
