<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #bbb;padding-bottom:8px;margin-bottom:16px">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> 2026-10-07<br>
  <b>Description:</b> HANA Calculation View 'CV_BASE_NAVIX' is a dimension-type object designed as a base view for navigation index modeling at store and day granularity. The XML defines a projection of selected fields from a single database table source, without additional calculated fields, joins, or aggregation logic.
</div>

<!-- 1. Overview of Program -->
<p>CV_BASE_NAVIX is a HANA Calculation View of type 'DIMENSION'. Its primary purpose is to provide a base projection of navigation index data for stores and business days by exposing selected fields from a database table. The view does not perform aggregation, calculation, or complex modeling, serving as a foundational structure for further navigation index analysis.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View is structured with a single projection node (Projection_1) that sources data from the database table '/POSDW/NAVIX' (aliased as _POSDW_NAVIX). No joins, unions, filters, or calculated attributes are defined, and the view exposes four fields: MANDT, RETAILSTOREID, BUSINESSDAYDATE, and CURRENCY. <b>Key Components:</b> The major components are the data source (_POSDW_NAVIX), the projection node (Projection_1), and the logical model mapping attributes directly to output columns. <b>Dependencies & Performance:</b> The only dependency is the referenced database table '/POSDW/NAVIX'. No performance-relevant features such as joins, aggregations, or calculated fields are present; the view is simple and direct, with minimal processing overhead.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow:auto;padding:12px 0 12px 0;max-width:100%">
  <style>
    .cv-grid { display: grid; grid-template-columns: repeat(3, 180px); grid-template-rows: repeat(2, 90px); gap: 28px; align-items: center; justify-items: center; }
    .cv-box { background: #f7fafc; border: 1px solid #d3dbe3; border-radius: 8px; box-shadow: 0 1px 6px #ececec; padding: 18px 16px; font-family: sans-serif; font-size: 15px; text-align: center; min-width: 150px; min-height: 44px; }
    .cv-arrow { font-size: 24px; color: #7d8fa7; margin: 0 4px; }
  </style>
  <div class="cv-grid">
    <div class="cv-box" style="grid-column:1;grid-row:1">Data Source<br><span style="font-size:13px;color:#888">_POSDW_NAVIX<br>/POSDW/NAVIX</span></div>
    <div class="cv-arrow" style="grid-column:2;grid-row:1">&#8594;</div>
    <div class="cv-box" style="grid-column:3;grid-row:1">Projection Node<br><span style="font-size:13px;color:#888">Projection_1</span></div>
    <div class="cv-arrow" style="grid-column:2;grid-row:2">&#8593;</div>
    <div class="cv-box" style="grid-column:3;grid-row:2">Output<br><span style="font-size:13px;color:#888">MANDT, RETAILSTOREID,<br>BUSINESSDAYDATE, CURRENCY</span></div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellspacing="0" cellpadding="6" style="border-collapse:collapse;font-family:sans-serif;font-size:15px;width:100%">
  <tr style="background:#f4f6fb">
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr>
    <td>Projection_1.MANDT</td>
    <td>MANDT</td>
    <td>_POSDW_NAVIX.MANDT</td>
    <td>MANDT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.RETAILSTOREID</td>
    <td>RETAILSTOREID</td>
    <td>_POSDW_NAVIX.RETAILSTOREID</td>
    <td>RETAILSTOREID</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.BUSINESSDAYDATE</td>
    <td>BUSINESSDAYDATE</td>
    <td>_POSDW_NAVIX.BUSINESSDAYDATE</td>
    <td>BUSINESSDAYDATE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.CURRENCY</td>
    <td>CURRENCY</td>
    <td>_POSDW_NAVIX.CURRENCY</td>
    <td>CURRENCY</td>
    <td>Direct mapping</td>
  </tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellspacing="0" cellpadding="6" style="border-collapse:collapse;font-family:sans-serif;font-size:15px;width:100%">
  <tr style="background:#f4f6fb"><th>Category</th><th>Measurement</th></tr>
  <tr><td>Number of Objects/Nodes</td><td>2 (Data Source, Projection Node)</td></tr>
  <tr><td>Sources Used</td><td>1 (/POSDW/NAVIX)</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None identified</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>None identified</td></tr>
  <tr><td>Workflow Complexity</td><td>Very low; single projection node with direct mapping</td></tr>
  <tr><td>Performance Considerations</td><td>Minimal processing; direct read from source table</td></tr>
  <tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single dependency on database table /POSDW/NAVIX</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>MANDT</li>
  <li>RETAILSTOREID</li>
  <li>BUSINESSDAYDATE</li>
  <li>CURRENCY</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
