<!--
DOCUMENT HEADER
-->
<html>
<head>
  <title>HANA Calculation View Documentation - CV_BASE_MD_HRRP_NODE_S4</title>
</head>
<body>
  <h1>HANA Calculation View Documentation</h1>
  <table border="1" cellpadding="4" cellspacing="0">
    <tr>
      <td><b>Author</b></td>
      <td>Ascendion AAVA</td>
    </tr>
    <tr>
      <td><b>Created On</b></td>
      <td><!--#DATE#--><script>document.write(new Date().toISOString().substring(0,10));</script></td>
    </tr>
    <tr>
      <td><b>Description</b></td>
      <td>Base view for HRRP_NODE - Hierarchy Master Data. This Calculation View provides projection and filtering of hierarchy master data from the SAP_S4.HRRP_NODE table for use in further modeling or reporting scenarios.</td>
    </tr>
  </table>
  <br/>

<!--
1. OVERVIEW OF PROGRAM
-->
  <h2>1. Overview of Program</h2>
  <p>
    This object is a HANA Calculation View of type <b>Dimension</b> named <b>CV_BASE_MD_HRRP_NODE_S4</b>. Its primary purpose is to provide a structured projection of hierarchy master data from the underlying database table <b>SAP_S4.HRRP_NODE</b>. The view selects and filters relevant attributes for use in downstream data modeling.
  </p>

<!--
2. CODE STRUCTURE AND DESIGN
-->
  <h2>2. Code Structure and Design</h2>
  <p>
    <b>Structure:</b> The Calculation View is defined as a tree-based dimension model with a single projection node (<b>Projection_1</b>). It sources data from the base table <b>SAP_S4.HRRP_NODE</b>, mapping all relevant columns directly to the output, and applies a filter on the <b>MANDT</b> (client) field to restrict values to 120 and 200. There are no joins, unions, calculated fields, or aggregations present.<br/>
    <b>Key Components:</b> The main components are the data source (<b>HRRP_NODE</b>), the projection node (<b>Projection_1</b>), and the logical model that defines the output attributes. Each attribute in the output is directly mapped from the corresponding source field, with descriptive labels provided. The only filter logic is applied to the <b>MANDT</b> field.<br/>
    <b>Dependencies & Performance:</b> The Calculation View depends solely on the <b>SAP_S4.HRRP_NODE</b> table as its data source. No joins, aggregations, or calculated fields are present, indicating a straightforward data flow with minimal processing overhead. The presence of an attribute filter on <b>MANDT</b> may limit data volume for specific clients.
  </p>

<!--
3. DATA FLOW AND PROCESSING LOGIC
-->
  <h2>3. Data Flow and Processing Logic</h2>
  <div style="overflow-x:auto; background:#f9f9f9; padding:18px; border-radius:8px; max-width:900px;">
    <style>
      .hana-grid {
        display: grid;
        grid-template-columns: 180px 80px 180px 80px 180px;
        grid-template-rows: 100px 100px;
        align-items: center;
        justify-items: center;
        gap: 0px 0px;
      }
      .hana-box {
        background: #e3eafc;
        border: 2px solid #b1c4e6;
        border-radius: 8px;
        width: 170px;
        height: 60px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        box-shadow: 1px 1px 4px #e0e0e0;
      }
      .hana-arrow {
        width: 60px;
        height: 2px;
        background: #b1c4e6;
        position: relative;
      }
      .hana-arrow:after {
        content: '';
        position: absolute;
        right: -8px;
        top: -6px;
        border-top: 8px solid transparent;
        border-bottom: 8px solid transparent;
        border-left: 10px solid #b1c4e6;
      }
    </style>
    <div class="hana-grid">
      <div class="hana-box" style="grid-column:1;grid-row:1;">SAP_S4.HRRP_NODE<br/><span style='font-size:12px;'>(Data Source)</span></div>
      <div class="hana-arrow" style="grid-column:2;grid-row:1;"></div>
      <div class="hana-box" style="grid-column:3;grid-row:1;">Projection_1<br/><span style='font-size:12px;'>(Projection & Filter)</span></div>
      <div class="hana-arrow" style="grid-column:4;grid-row:1;"></div>
      <div class="hana-box" style="grid-column:5;grid-row:1;">Output<br/><span style='font-size:12px;'>(Logical Model)</span></div>
    </div>
  </div>

<!--
4. DATA MAPPING
-->
  <h2>4. Data Mapping</h2>
  <table border="1" cellpadding="4" cellspacing="0">
    <tr>
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
      <td>Direct mapping; Filter: IN (120, 200)</td>
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

<!--
5. COMPLEXITY ANALYSIS
-->
  <h2>5. Complexity Analysis</h2>
  <table border="1" cellpadding="4" cellspacing="0">
    <tr>
      <th>Category</th>
      <th>Measurement</th>
    </tr>
    <tr>
      <td>Number of Objects/Nodes</td>
      <td>2 (1 Data Source, 1 Projection Node)</td>
    </tr>
    <tr>
      <td>Sources Used</td>
      <td>SAP_S4.HRRP_NODE</td>
    </tr>
    <tr>
      <td>Joins</td>
      <td>0</td>
    </tr>
    <tr>
      <td>Temporary/Cached Data</td>
      <td>None identified</td>
    </tr>
    <tr>
      <td>Aggregate Functions</td>
      <td>None</td>
    </tr>
    <tr>
      <td>Data Manipulation</td>
      <td>No data manipulation identified</td>
    </tr>
    <tr>
      <td>Conditional Logic</td>
      <td>MANDT filter (IN 120, 200)</td>
    </tr>
    <tr>
      <td>Workflow Complexity</td>
      <td>Very simple linear flow: Data Source → Projection → Output</td>
    </tr>
    <tr>
      <td>Performance Considerations</td>
      <td>Single-table read with attribute filter; no joins or aggregations</td>
    </tr>
    <tr>
      <td>Data Volume Handling</td>
      <td>Not explicitly defined; filter on MANDT may reduce row count</td>
    </tr>
    <tr>
      <td>Dependency Complexity</td>
      <td>Single dependency: SAP_S4.HRRP_NODE</td>
    </tr>
    <tr>
      <td>Overall Complexity Score</td>
      <td>Low</td>
    </tr>
  </table>

<!--
6. SENSITIVE AND PRIVACY DATA ASSESSMENT
-->
  <h2>6. Sensitive and Privacy Data Assessment</h2>
  No sensitive data found

<!--
7. KEY OUTPUTS
-->
  <h2>7. Key Outputs</h2>
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

<!--
8. API COST CALCULATIONS
-->
  <h2>8. API Cost Calculations</h2>
  API COST : 0.0000 USD

</body>
</html>
