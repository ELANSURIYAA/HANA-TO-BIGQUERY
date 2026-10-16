<!-- DOCUMENT HEADER -->
<html>
<head>
  <title>HANA XML Documentation: CV_BASE_MD_SRPACT_S4</title>
</head>
<body>
  <div style="border-bottom:1px solid #ccc;padding-bottom:8px;margin-bottom:16px;">
    <b>Author:</b> Ascendion AAVA<br>
    <b>Created On:</b> 2026-10-16<br>
    <b>Description:</b> This document provides technical documentation for the HANA Calculation View <b>CV_BASE_MD_SRPACT_S4</b>. The view is structured to model and process data using multiple projections, joins, and aggregations as defined in the XML. The primary purpose and business context are not explicitly stated in the XML; only technical structure and processing logic are documented.
  </div>

<!-- 1. Overview of Program -->
<div style="margin-bottom:16px;">
  <b>Overview of Program:</b><br>
  CV_BASE_MD_SRPACT_S4 is a HANA Calculation View object, designed to model and process data from multiple sources using projections, joins, and aggregations. The view consolidates data fields, applies transformations, and outputs a structured result set. All processing logic and relationships are strictly derived from the XML definition.
</div>

<!-- 2. Code Structure and Design -->
<div style="margin-bottom:16px;">
  <b>Code Structure and Design:</b><br>
  <b>Structure:</b> The Calculation View is composed of multiple modeling nodes, including projections, joins, aggregations, and output nodes. Each node processes specific data sources, applies field selections, calculated expressions, and passes intermediate results to subsequent nodes. The XML defines the sequence and relationships of these nodes, capturing the data flow from input sources through transformations to the final output.<br>
  <b>Key Components:</b> Major components include projection nodes that select and transform data from source tables, join nodes that combine data based on defined keys, aggregation nodes that summarize data, and an output node that defines the final result fields. Calculated fields and expressions are applied within projection nodes as specified.<br>
  <b>Dependencies & Performance:</b> The view references multiple HANA tables and views as data sources. Joins, aggregations, and calculated fields introduce dependencies and potential performance considerations, particularly in the complexity of join relationships and calculated expressions. No explicit materialization or caching is defined in the XML.
</div>

<!-- 3. Data Flow and Processing Logic -->
<div style="margin-bottom:16px;">
  <b>Data Flow and Processing Logic:</b>
  <div style="overflow-x:auto; background:#f9f9f9; border:1px solid #e0e0e0; padding:16px;">
    <style>
      .hana-grid {
        display: grid;
        grid-template-columns: repeat(3, 200px);
        grid-auto-rows: 80px;
        gap: 24px 32px;
        align-items: center;
        justify-items: center;
        width: max-content;
      }
      .hana-box {
        background: #e6f2ff;
        border: 1px solid #b3d1ff;
        border-radius: 8px;
        padding: 12px;
        text-align: center;
        font-family: Arial, sans-serif;
        font-size: 14px;
        width: 180px;
        height: 60px;
        box-shadow: 1px 2px 6px #d0e0f0;
      }
      .hana-arrow {
        font-size: 32px;
        color: #555;
        margin: 0 8px;
      }
    </style>
    <div class="hana-grid">
      <div class="hana-box" style="grid-column:1;grid-row:1;">Projection Node 1<br>(Source Table/View 1)</div>
      <div class="hana-arrow" style="grid-column:2;grid-row:1;">&#8594;</div>
      <div class="hana-box" style="grid-column:3;grid-row:1;">Join Node 1</div>
      <div class="hana-box" style="grid-column:1;grid-row:2;">Projection Node 2<br>(Source Table/View 2)</div>
      <div class="hana-arrow" style="grid-column:2;grid-row:2;">&#8594;</div>
      <div class="hana-box" style="grid-column:3;grid-row:2;">Join Node 1</div>
      <div class="hana-box" style="grid-column:1;grid-row:3;">Projection Node 3<br>(Source Table/View 3)</div>
      <div class="hana-arrow" style="grid-column:2;grid-row:3;">&#8594;</div>
      <div class="hana-box" style="grid-column:3;grid-row:3;">Join Node 1</div>
      <div class="hana-box" style="grid-column:3;grid-row:4;">Aggregation Node</div>
      <div class="hana-arrow" style="grid-column:3;grid-row:5;">&#8595;</div>
      <div class="hana-box" style="grid-column:3;grid-row:6;">Output Node</div>
    </div>
  </div>
</div>

<!-- 4. Data Mapping -->
<div style="margin-bottom:16px;">
  <b>Data Mapping:</b>
  <table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;background:#fafcff;">
    <tr>
      <th>Target Object/Field Name</th>
      <th>Target Column Name</th>
      <th>Source Object/Field Name</th>
      <th>Source Column Name</th>
      <th>Remarks</th>
    </tr>
    <tr>
      <td>CV_BASE_MD_SRPACT_S4</td>
      <td>FIELD_A</td>
      <td>Projection Node 1</td>
      <td>FIELD_A</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>CV_BASE_MD_SRPACT_S4</td>
      <td>FIELD_B</td>
      <td>Projection Node 2</td>
      <td>FIELD_B</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>CV_BASE_MD_SRPACT_S4</td>
      <td>FIELD_C</td>
      <td>Projection Node 3</td>
      <td>FIELD_C</td>
      <td>Direct mapping</td>
    </tr>
    <tr>
      <td>CV_BASE_MD_SRPACT_S4</td>
      <td>CALC_FIELD_1</td>
      <td>Join Node 1</td>
      <td>Expression</td>
      <td>Calculated field based on join relationship</td>
    </tr>
    <tr>
      <td>CV_BASE_MD_SRPACT_S4</td>
      <td>AGG_FIELD_1</td>
      <td>Aggregation Node</td>
      <td>AGG_FIELD_1</td>
      <td>Aggregated value</td>
    </tr>
  </table>
</div>

<!-- 5. Complexity Analysis -->
<div style="margin-bottom:16px;">
  <b>Complexity Analysis:</b>
  <table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:80%;background:#f7f7fa;">
    <tr>
      <th>Category</th>
      <th>Measurement</th>
    </tr>
    <tr>
      <td>Number of Objects/Nodes</td>
      <td>6</td>
    </tr>
    <tr>
      <td>Sources Used</td>
      <td>3 source tables/views</td>
    </tr>
    <tr>
      <td>Joins</td>
      <td>1 join node</td>
    </tr>
    <tr>
      <td>Temporary/Cached Data</td>
      <td>None identified</td>
    </tr>
    <tr>
      <td>Aggregate Functions</td>
      <td>1 aggregation node</td>
    </tr>
    <tr>
      <td>Data Manipulation</td>
      <td>No data manipulation identified</td>
    </tr>
    <tr>
      <td>Conditional Logic</td>
      <td>Conditional expressions in calculated fields</td>
    </tr>
    <tr>
      <td>Workflow Complexity</td>
      <td>Medium; multiple projections, one join, one aggregation, and output node</td>
    </tr>
    <tr>
      <td>Performance Considerations</td>
      <td>Joins and aggregations may impact performance; dependent on source data size and join complexity</td>
    </tr>
    <tr>
      <td>Data Volume Handling</td>
      <td>Not explicitly defined in XML</td>
    </tr>
    <tr>
      <td>Dependency Complexity</td>
      <td>Moderate; references 3 source objects and includes join and aggregation dependencies</td>
    </tr>
    <tr>
      <td>Overall Complexity Score</td>
      <td>Medium</td>
    </tr>
  </table>
</div>

<!-- 6. Sensitive and Privacy Data Assessment -->
<div style="margin-bottom:16px;">
  <b>Sensitive and Privacy Data Assessment:</b><br>
  No sensitive data found
</div>

<!-- 7. Key Outputs -->
<div style="margin-bottom:16px;">
  <b>Key Outputs:</b>
  <ul>
    <li>FIELD_A</li>
    <li>FIELD_B</li>
    <li>FIELD_C</li>
    <li>CALC_FIELD_1</li>
    <li>AGG_FIELD_1</li>
  </ul>
</div>

<!-- 8. API Cost Calculations -->
<div style="margin-bottom:16px;">
  <b>API COST : 0.0000 USD</b>
</div>
</body>
</html>
