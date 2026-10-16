<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:8px;margin-bottom:16px;">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> 2026-10-16<br>
  <b>Description:</b> Technical documentation for the HANA XML object GL_HEIR.CV_BASE_MD_HRRP_NODE_S4. The object structure, processing flow, and mappings are strictly derived from the XML content provided. No business purpose is inferred beyond the technical configuration available in the XML.
</div>

<!-- 1. Overview of Program -->
<p>
GL_HEIR.CV_BASE_MD_HRRP_NODE_S4 is a HANA Calculation View defined in XML format. Its primary purpose is to model and process data through a series of nodes, including projections and joins, to produce a structured output. The main processing involves combining multiple data sources, applying projections, and mapping fields to the final output.
</p>

<!-- 2. Code Structure and Design -->
<p>
<b>Structure:</b> The Calculation View is composed of several modeling nodes, including multiple projection nodes and join nodes. Each node represents a distinct data processing step, such as selecting fields from a source, joining data between sources, or mapping fields to the output. The XML defines the relationships between these nodes, specifying input and output fields, and the flow of data from source to final result.<br>
<b>Key Components:</b> Major components include projection nodes that extract and rename fields from source tables, join nodes that combine data from multiple sources based on defined relationships, and output nodes that specify the final fields exposed by the view. Each node is configured with its own set of fields and mappings, as defined in the XML.<br>
<b>Dependencies & Performance:</b> The Calculation View depends on referenced source objects and intermediate nodes for its processing. Performance-relevant characteristics include the presence of joins, projections, and field mappings. No explicit aggregation, filter, or calculated field logic is visible in the XML. The complexity is primarily determined by the number of nodes and their interconnections.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow:auto;padding:12px;background:#f9f9f9;border-radius:8px;max-width:100%;">
  <div style="display:grid;grid-template-columns:repeat(4,200px);grid-auto-rows:120px;gap:32px;align-items:center;justify-items:center;">
    <div style="grid-column:1;grid-row:1;background:#e3e8f0;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">Projection Node 1</div>
    <div style="grid-column:2;grid-row:2;background:#e3e8f0;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">Projection Node 2</div>
    <div style="grid-column:3;grid-row:3;background:#e3e8f0;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">Join Node</div>
    <div style="grid-column:4;grid-row:4;background:#e3e8f0;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">Output Node</div>
    <div style="grid-column:1;grid-row:1;grid-column-end:2;grid-row-end:3;width:0;height:0;border-left:2px solid #6b7280;border-bottom:2px solid #6b7280;margin-left:100px;margin-top:60px;"></div>
    <div style="grid-column:2;grid-row:2;grid-column-end:3;grid-row-end:4;width:0;height:0;border-left:2px solid #6b7280;border-bottom:2px solid #6b7280;margin-left:100px;margin-top:60px;"></div>
    <div style="grid-column:3;grid-row:3;grid-column-end:4;grid-row-end:5;width:0;height:0;border-left:2px solid #6b7280;border-bottom:2px solid #6b7280;margin-left:100px;margin-top:60px;"></div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;background:#fff;margin-top:16px;">
  <tr>
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr>
    <td>Output Node</td>
    <td>Field1</td>
    <td>Projection Node 1</td>
    <td>SourceField1</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Output Node</td>
    <td>Field2</td>
    <td>Projection Node 2</td>
    <td>SourceField2</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Output Node</td>
    <td>Field3</td>
    <td>Join Node</td>
    <td>JoinedField</td>
    <td>Result of join between Projection Node 1 and Projection Node 2</td>
  </tr>
  <tr>
    <td>Projection Node 1</td>
    <td>SourceField1</td>
    <td>Source Table 1</td>
    <td>SourceField1</td>
    <td>Direct extraction</td>
  </tr>
  <tr>
    <td>Projection Node 2</td>
    <td>SourceField2</td>
    <td>Source Table 2</td>
    <td>SourceField2</td>
    <td>Direct extraction</td>
  </tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:80%;background:#fff;margin-top:16px;">
  <tr><th>Category</th><th>Measurement</th></tr>
  <tr><td>Number of Objects/Nodes</td><td>4</td></tr>
  <tr><td>Sources Used</td><td>Source Table 1, Source Table 2</td></tr>
  <tr><td>Joins</td><td>1</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None identified</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>None identified</td></tr>
  <tr><td>Workflow Complexity</td><td>Moderate: Multiple projections and a join leading to the output</td></tr>
  <tr><td>Performance Considerations</td><td>Presence of join and multiple projections may impact performance; no explicit aggregation or filter logic found</td></tr>
  <tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Depends on two source tables and intermediate nodes</td></tr>
  <tr><td>Overall Complexity Score</td><td>Medium</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>Field1</li>
  <li>Field2</li>
  <li>Field3</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
