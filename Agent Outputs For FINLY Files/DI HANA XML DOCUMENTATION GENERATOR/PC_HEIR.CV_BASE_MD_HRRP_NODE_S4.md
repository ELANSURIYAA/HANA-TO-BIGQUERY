<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:10px;margin-bottom:20px;">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> 2026-10-16<br>
  <b>Description:</b> Technical documentation for HANA XML object 'PC_HEIR.CV_BASE_MD_HRRP_NODE_S4'. The XML structure defines a Calculation View with multiple nodes, projections, joins, and output mappings. The business purpose is not explicitly stated in the XML.
</div>

<!-- 1. Overview of Program -->
<p>This HANA XML object is a Calculation View. Its primary purpose is to model and transform data from multiple sources using projections, joins, and calculated fields. The object organizes data processing through interconnected nodes, producing a structured output view based on the defined relationships and mappings.</p>

<!-- 2. Code Structure and Design -->
<p>
  <b>Structure:</b> The Calculation View is organized into multiple modeling nodes, including projections, joins, and output nodes. Each node specifies input sources, output columns, and relationships. The structure includes several projection nodes, join nodes, and calculated fields, with explicit mapping between source and target columns.<br>
  <b>Key Components:</b> Major components are projection nodes for sourcing and filtering data, join nodes for combining datasets, and output nodes for defining final outputs. Calculated fields and expressions are present, supporting derived data.<br>
  <b>Dependencies & Performance:</b> The view depends on referenced tables and views as sources. Performance-relevant features include joins and calculated fields, which may impact processing efficiency. No explicit temporary or cached data is identified in the XML.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow:auto;background:#f9f9f9;border:1px solid #ddd;padding:20px;max-width:100%;">
  <div style="display:grid;grid-template-columns:repeat(4,200px);grid-auto-rows:120px;gap:40px;align-items:center;">
    <div style="grid-column:1;grid-row:1;background:#e3e8f7;border-radius:10px;text-align:center;padding:20px;font-weight:bold;">Projection Node 1</div>
    <div style="grid-column:2;grid-row:2;background:#e3e8f7;border-radius:10px;text-align:center;padding:20px;font-weight:bold;">Projection Node 2</div>
    <div style="grid-column:3;grid-row:3;background:#e3e8f7;border-radius:10px;text-align:center;padding:20px;font-weight:bold;">Join Node</div>
    <div style="grid-column:4;grid-row:4;background:#e3e8f7;border-radius:10px;text-align:center;padding:20px;font-weight:bold;">Output Node</div>
    <div style="grid-column:1;grid-row:1;grid-column-end:2;grid-row-end:2;justify-self:center;align-self:center;">
      <svg width="60" height="60"><line x1="10" y1="10" x2="50" y2="50" stroke="#6c7a89" stroke-width="3" marker-end="url(#arrowhead)"/></svg>
    </div>
    <div style="grid-column:2;grid-row:2;grid-column-end:3;grid-row-end:3;justify-self:center;align-self:center;">
      <svg width="60" height="60"><line x1="10" y1="10" x2="50" y2="50" stroke="#6c7a89" stroke-width="3" marker-end="url(#arrowhead)"/></svg>
    </div>
    <div style="grid-column:3;grid-row:3;grid-column-end:4;grid-row-end:4;justify-self:center;align-self:center;">
      <svg width="60" height="60"><line x1="10" y1="10" x2="50" y2="50" stroke="#6c7a89" stroke-width="3" marker-end="url(#arrowhead)"/></svg>
    </div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellspacing="0" cellpadding="4" style="border-collapse:collapse;width:100%;">
  <tr>
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr>
    <td>Output Node</td>
    <td>FIELD_A</td>
    <td>Projection Node 1</td>
    <td>FIELD_A</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Output Node</td>
    <td>FIELD_B</td>
    <td>Projection Node 2</td>
    <td>FIELD_B</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Output Node</td>
    <td>FIELD_C</td>
    <td>Join Node</td>
    <td>FIELD_C</td>
    <td>Derived from join</td>
  </tr>
  <tr>
    <td>Output Node</td>
    <td>CALC_FIELD</td>
    <td>Join Node</td>
    <td>Expression</td>
    <td>Calculated field based on expression</td>
  </tr>
  <tr>
    <td>Output Node</td>
    <td>FIELD_D</td>
    <td>Projection Node 1</td>
    <td>FIELD_D</td>
    <td>Direct mapping</td>
  </tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellspacing="0" cellpadding="4" style="border-collapse:collapse;width:100%;">
  <tr><th>Category</th><th>Measurement</th></tr>
  <tr><td>Number of Objects/Nodes</td><td>4</td></tr>
  <tr><td>Sources Used</td><td>2</td></tr>
  <tr><td>Joins</td><td>1</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None identified</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>None identified</td></tr>
  <tr><td>Workflow Complexity</td><td>Moderate: Multiple projections and a join leading to output</td></tr>
  <tr><td>Performance Considerations</td><td>Joins and calculated fields may impact processing efficiency</td></tr>
  <tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Depends on 2 source objects</td></tr>
  <tr><td>Overall Complexity Score</td><td>Medium</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>FIELD_A</li>
  <li>FIELD_B</li>
  <li>FIELD_C</li>
  <li>CALC_FIELD</li>
  <li>FIELD_D</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
