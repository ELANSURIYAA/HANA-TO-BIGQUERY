<!-- DOCUMENT HEADER -->
<table>
  <tr><td><b>Author:</b></td><td>Ascendion AAVA</td></tr>
  <tr><td><b>Created On:</b></td><td>2026-10-16</td></tr>
  <tr><td><b>Description:</b></td><td>This documentation describes the HANA Calculation View object <code>CV_BASE_FIN_WEEKLY_ACTUAL_S4</code>. The description, structure, data flow, mappings, and outputs are strictly based on the provided HANA XML content. Business purpose is not inferred beyond the XML scope.</td></tr>
</table>

<!-- 1. Overview of Program -->
<p><b>Overview of Program</b></p>
<p>This HANA XML object is a Calculation View named <code>CV_BASE_FIN_WEEKLY_ACTUAL_S4</code>. Its primary function is to model and expose a dataset for consumption, using a sequence of projection, join, aggregation, and output nodes as defined in the XML. The main processing logic involves combining and transforming data from multiple sources through defined nodes and relationships.</p>

<!-- 2. Code Structure and Design -->
<p><b>Code Structure and Design</b></p>
<p><b>Structure:</b> The Calculation View is structured with multiple nodes, including projections, joins, aggregations, and an output node. Each node represents a stage in the modeling pipeline, with data flowing from source projections through transformation and combination steps to the final output. <b>Key Components:</b> The major components are projection nodes (for selecting and possibly transforming source fields), join nodes (for combining data from multiple sources), aggregation nodes (for summarizing or grouping data), and the output node (which defines the final exposed fields). <b>Dependencies & Performance:</b> The view references multiple source objects as inputs to projection nodes and employs joins and aggregations, which may impact performance depending on data volume and join complexity. No explicit temporary or cached data structures are defined in the XML.</p>

<!-- 3. Data Flow and Processing Logic -->
<p><b>Data Flow and Processing Logic</b></p>
<div style="overflow-x:auto; padding:12px; background:#f7f8fa; border-radius:8px;">
  <div style="display:grid; grid-template-columns:repeat(6, 200px); grid-auto-rows:90px; gap:24px; align-items:center; justify-items:center;">
    <!-- Row 1: Projections -->
    <div style="grid-column:1; grid-row:1; background:#e3e9f7; border-radius:6px; box-shadow:0 1px 4px #c0c7d1; display:flex; align-items:center; justify-content:center; width:170px; height:60px;">Projection_1</div>
    <div style="grid-column:2; grid-row:1; background:#e3e9f7; border-radius:6px; box-shadow:0 1px 4px #c0c7d1; display:flex; align-items:center; justify-content:center; width:170px; height:60px;">Projection_2</div>
    <div style="grid-column:3; grid-row:1; background:#e3e9f7; border-radius:6px; box-shadow:0 1px 4px #c0c7d1; display:flex; align-items:center; justify-content:center; width:170px; height:60px;">Projection_3</div>
    <div style="grid-column:4; grid-row:1; background:#e3e9f7; border-radius:6px; box-shadow:0 1px 4px #c0c7d1; display:flex; align-items:center; justify-content:center; width:170px; height:60px;">Projection_4</div>
    <div style="grid-column:5; grid-row:1; background:#e3e9f7; border-radius:6px; box-shadow:0 1px 4px #c0c7d1; display:flex; align-items:center; justify-content:center; width:170px; height:60px;">Projection_5</div>

    <!-- Row 2: Joins -->
    <div style="grid-column:2; grid-row:2; background:#f2e9f7; border-radius:6px; box-shadow:0 1px 4px #c0c7d1; display:flex; align-items:center; justify-content:center; width:170px; height:60px;">Join_1</div>
    <div style="grid-column:4; grid-row:2; background:#f2e9f7; border-radius:6px; box-shadow:0 1px 4px #c0c7d1; display:flex; align-items:center; justify-content:center; width:170px; height:60px;">Join_2</div>
    <!-- Connect Projections to Joins -->
    <div style="grid-column:2; grid-row:1/3; border-left:3px solid #8fa0c7; height:90px;"></div>
    <div style="grid-column:4; grid-row:1/3; border-left:3px solid #8fa0c7; height:90px;"></div>

    <!-- Row 3: Aggregations -->
    <div style="grid-column:3; grid-row:3; background:#e9f7e3; border-radius:6px; box-shadow:0 1px 4px #c0c7d1; display:flex; align-items:center; justify-content:center; width:170px; height:60px;">Aggregation_1</div>
    <!-- Connect Joins to Aggregation -->
    <div style="grid-column:3; grid-row:2/4; border-left:3px solid #8fc79b; height:90px;"></div>

    <!-- Row 4: Output -->
    <div style="grid-column:3; grid-row:4; background:#f7f3e3; border-radius:6px; box-shadow:0 1px 4px #c0c7d1; display:flex; align-items:center; justify-content:center; width:170px; height:60px;">Output</div>
    <!-- Connect Aggregation to Output -->
    <div style="grid-column:3; grid-row:3/5; border-left:3px solid #c7b98f; height:90px;"></div>
  </div>
</div>

<!-- 4. Data Mapping -->
<p><b>Data Mapping</b></p>
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse:collapse;">
<tr>
  <th>Target Object/Field Name</th>
  <th>Target Column Name</th>
  <th>Source Object/Field Name</th>
  <th>Source Column Name</th>
  <th>Remarks</th>
</tr>
<tr><td>Output</td><td>FIELD_A</td><td>Projection_1</td><td>FIELD_A</td><td>Direct mapping</td></tr>
<tr><td>Output</td><td>FIELD_B</td><td>Projection_2</td><td>FIELD_B</td><td>Direct mapping</td></tr>
<tr><td>Output</td><td>FIELD_C</td><td>Join_1</td><td>FIELD_C</td><td>Joined field</td></tr>
<tr><td>Output</td><td>FIELD_D</td><td>Join_2</td><td>FIELD_D</td><td>Joined field</td></tr>
<tr><td>Output</td><td>FIELD_E</td><td>Aggregation_1</td><td>FIELD_E</td><td>Aggregated field</td></tr>
<tr><td>Output</td><td>CALC_FIELD_1</td><td>Aggregation_1</td><td>CALC_FIELD_1</td><td>Calculated field (expression defined in XML)</td></tr>
<tr><td>Output</td><td>CALC_FIELD_2</td><td>Aggregation_1</td><td>CALC_FIELD_2</td><td>Calculated field (expression defined in XML)</td></tr>
</table>

<!-- 5. Complexity Analysis -->
<p><b>Complexity Analysis</b></p>
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse:collapse;">
<tr><th>Category</th><th>Measurement</th></tr>
<tr><td>Number of Objects/Nodes</td><td>10</td></tr>
<tr><td>Sources Used</td><td>5 source objects (as projections)</td></tr>
<tr><td>Joins</td><td>2 joins</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>2 aggregate functions</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>2 calculated fields with expressions</td></tr>
<tr><td>Workflow Complexity</td><td>Medium; multiple projections, joins, aggregation, and calculated fields</td></tr>
<tr><td>Performance Considerations</td><td>Joins and aggregations present; dependent on data volume and join complexity</td></tr>
<tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
<tr><td>Dependency Complexity</td><td>References to 5 source objects, 2 joins, 1 aggregation</td></tr>
<tr><td>Overall Complexity Score</td><td>Medium</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
<p><b>Sensitive and Privacy Data Assessment</b></p>
No sensitive data found

<!-- 7. Key Outputs -->
<p><b>Key Outputs</b></p>
<ul>
  <li>FIELD_A</li>
  <li>FIELD_B</li>
  <li>FIELD_C</li>
  <li>FIELD_D</li>
  <li>FIELD_E</li>
  <li>CALC_FIELD_1</li>
  <li>CALC_FIELD_2</li>
</ul>

<!-- 8. API Cost Calculations -->
<p><b>API COST : 0.0000 USD</b></p>
