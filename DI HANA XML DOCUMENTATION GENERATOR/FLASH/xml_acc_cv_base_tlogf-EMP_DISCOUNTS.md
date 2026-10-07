<!-- DOCUMENT HEADER -->
<table>
  <tr><td><b>Author:</b></td><td>Ascendion AAVA</td></tr>
  <tr><td><b>Created On:</b></td><td>2026-10-07</td></tr>
  <tr><td><b>Description:</b></td><td>Technical documentation for a HANA Calculation View (CV_BASE_TLOGF) defined as a base view for the Transaction Log Flat table, outlining its structure, data flow, mappings, and complexity based strictly on the provided HANA XML.</td></tr>
</table>

<!-- 1. Overview of Program -->
<p>This HANA XML defines a Calculation View named <b>CV_BASE_TLOGF</b> with a CUBE data category. Its primary purpose is to provide a base aggregation layer for the Transaction Log Flat table, selecting and filtering relevant fields. The view performs projections, filtering, and aggregation of sales and reduction amounts from a single data source.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View consists of a single projection node (<b>Projection_1</b>) sourcing data from the database table <b>/POSDW/TLOGF</b> via the data source <b>_POSDW_TLOGF</b>. The projection node selects multiple attributes and applies explicit filters to fields such as RECORDQUALIFIER, TRANSTYPECODE, WORKSTATIONID, ARCHIVED, and ZZ_UPD_TIMESTAMP. Two measures, SALESAMOUNT and REDUCTIONAMOUNT, are defined with SUM aggregation. No joins, unions, calculated fields, or variables are present.<br><b>Key Components:</b> The major components are the Projection_1 node, the _POSDW_TLOGF data source, explicit attribute filters, and base measures. The logical model defines output attributes and measures, directly mapped from the projection.<br><b>Dependencies & Performance:</b> The Calculation View depends on the underlying database table /POSDW/TLOGF. Performance-relevant characteristics include direct attribute filtering and SUM aggregation, with no joins or nested processing, indicating a straightforward processing structure.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; background:#f8f9fa; padding:16px; border-radius:8px;">
  <div style="display:grid; grid-template-columns:repeat(3, 200px); grid-auto-rows:120px; align-items:center; justify-items:center; gap:40px;">
    <div style="grid-column:1; grid-row:1; background:#e3e6f7; border-radius:8px; box-shadow:0 2px 6px #c3c6d7; width:180px; height:100px; display:flex; align-items:center; justify-content:center; font-weight:bold;">Data Source<br>_POSDW_TLOGF<br>/POSDW/TLOGF</div>
    <div style="grid-column:2; grid-row:2; background:#d7f7e3; border-radius:8px; box-shadow:0 2px 6px #b7d7c7; width:180px; height:100px; display:flex; align-items:center; justify-content:center; font-weight:bold;">Projection Node<br>Projection_1<br>Attribute Filtering</div>
    <div style="grid-column:3; grid-row:3; background:#f7e3e3; border-radius:8px; box-shadow:0 2px 6px #d7c3c3; width:180px; height:100px; display:flex; align-items:center; justify-content:center; font-weight:bold;">Output<br>Logical Model<br>Aggregated Measures</div>
    <svg style="grid-column:1; grid-row:1 / span 2; width:40px; height:120px;" xmlns="http://www.w3.org/2000/svg">
      <polyline points="20,100 20,120 220,120" stroke="#888" stroke-width="2" fill="none" marker-end="url(#arrowhead)"/>
      <defs><marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#888"/></marker></defs>
    </svg>
    <svg style="grid-column:2; grid-row:2 / span 2; width:40px; height:120px;" xmlns="http://www.w3.org/2000/svg">
      <polyline points="20,100 20,120 420,120" stroke="#888" stroke-width="2" fill="none" marker-end="url(#arrowhead2)"/>
      <defs><marker id="arrowhead2" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#888"/></marker></defs>
    </svg>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse:collapse;">
  <tr>
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr><td>Projection_1</td><td>MANDT</td><td>_POSDW_TLOGF</td><td>MANDT</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>RETAILSTOREID</td><td>_POSDW_TLOGF</td><td>RETAILSTOREID</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>BUSINESSDAYDATE</td><td>_POSDW_TLOGF</td><td>BUSINESSDAYDATE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>RECORDQUALIFIER</td><td>_POSDW_TLOGF</td><td>RECORDQUALIFIER</td><td>Filter: IN (5,6)</td></tr>
  <tr><td>Projection_1</td><td>TRANSTYPECODE</td><td>_POSDW_TLOGF</td><td>TRANSTYPECODE</td><td>Filter: NOT IN (1107,1197,1020)</td></tr>
  <tr><td>Projection_1</td><td>WORKSTATIONID</td><td>_POSDW_TLOGF</td><td>WORKSTATIONID</td><td>Filter: NOT "0000000000"</td></tr>
  <tr><td>Projection_1</td><td>SALESAMOUNT</td><td>_POSDW_TLOGF</td><td>SALESAMOUNT</td><td>Measure, SUM aggregation</td></tr>
  <tr><td>Projection_1</td><td>REDUCTIONAMOUNT</td><td>_POSDW_TLOGF</td><td>REDUCTIONAMOUNT</td><td>Measure, SUM aggregation</td></tr>
  <tr><td>Projection_1</td><td>ARCHIVED</td><td>_POSDW_TLOGF</td><td>ARCHIVED</td><td>Filter: value=""</td></tr>
  <tr><td>Projection_1</td><td>RETAILTYPECODE</td><td>_POSDW_TLOGF</td><td>RETAILTYPECODE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>ZZ_UPD_TIMESTAMP</td><td>_POSDW_TLOGF</td><td>ZZ_UPD_TIMESTAMP</td><td>Filter: NOT "0"</td></tr>
  <tr><td>Projection_1</td><td>DISCTYPECODE</td><td>_POSDW_TLOGF</td><td>DISCTYPECODE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>TRANSCURRENCY</td><td>_POSDW_TLOGF</td><td>TRANSCURRENCY</td><td>Direct mapping</td></tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse:collapse;">
  <tr><th>Category</th><th>Measurement</th></tr>
  <tr><td>Number of Objects/Nodes</td><td>3 (Data Source, Projection Node, Logical Model)</td></tr>
  <tr><td>Sources Used</td><td>1 (/POSDW/TLOGF)</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>SUM (SALESAMOUNT, REDUCTIONAMOUNT)</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>Attribute filters (IN, NOT IN, NOT value)</td></tr>
  <tr><td>Workflow Complexity</td><td>Simple linear workflow with single projection and aggregation</td></tr>
  <tr><td>Performance Considerations</td><td>Direct attribute filtering and aggregation, no joins or nested logic</td></tr>
  <tr><td>Data Volume Handling</td><td>Not explicitly specified in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single dependency on /POSDW/TLOGF</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>MANDT</li>
  <li>RETAILSTOREID</li>
  <li>BUSINESSDAYDATE</li>
  <li>RECORDQUALIFIER</li>
  <li>TRANSTYPECODE</li>
  <li>WORKSTATIONID</li>
  <li>SALESAMOUNT (SUM aggregation)</li>
  <li>REDUCTIONAMOUNT (SUM aggregation)</li>
  <li>ARCHIVED</li>
  <li>RETAILTYPECODE</li>
  <li>ZZ_UPD_TIMESTAMP</li>
  <li>DISCTYPECODE</li>
  <li>TRANSCURRENCY</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
