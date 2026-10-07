<!-- DOCUMENT HEADER -->
<table style="width:100%;border-collapse:collapse;margin-bottom:16px;">
  <tr>
    <td style="font-weight:bold;width:15%;">Author:</td>
    <td>Ascendion AAVA</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Created On:</td>
    <td>2026-10-07</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Description:</td>
    <td>HANA Calculation View 'CV_BASE_TLOGF' defines a base reporting-enabled view for transaction log flat table data, applying specific filters and aggregations to support downstream analytics.</td>
  </tr>
</table>

<!-- 1. Overview of Program -->
<p>CV_BASE_TLOGF is a HANA Calculation View of type CUBE, designed to provide a base aggregation layer for transaction log flat table data. The view performs filtering on selected fields and aggregates sales and reduction amounts, exposing a structured dataset for further reporting or analytical use. Its processing is based on a single projection node sourcing from a database table.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View consists of a single projection node ('Projection_1') sourcing from the database table '/POSDW/TLOGF', with all view attributes mapped directly from the source. Several attributes are filtered via list or single value filters, and two measures (SALESAMOUNT, REDUCTIONAMOUNT) are aggregated using SUM. <b>Key Components:</b> The major components are the data source (_POSDW_TLOGF), the projection node (Projection_1), attribute and measure definitions, applied filters on attributes, and the logical model defining output fields and measures. <b>Dependencies & Performance:</b> The view depends solely on the referenced database table. No joins or unions are present, and performance is influenced mainly by the applied attribute filters and SUM aggregations, with no complex processing or calculated fields.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;padding:12px 0;background:#f9f9f9;border-radius:8px;">
  <div style="display:grid;grid-template-columns:repeat(3,220px);grid-template-rows:repeat(3,80px);gap:32px 24px;align-items:center;justify-items:center;">
    <div style="grid-column:2;grid-row:1;background:#e3eafc;border-radius:8px;padding:18px 14px;text-align:center;font-weight:bold;border:1px solid #b6c5e6;">Data Source<br/>_POSDW_TLOGF<br/>(/POSDW/TLOGF)</div>
    <div style="grid-column:2;grid-row:2;background:#e6f5ea;border-radius:8px;padding:18px 14px;text-align:center;font-weight:bold;border:1px solid #b6e6c5;">Projection Node<br/>Projection_1<br/>Attribute Filters<br/>SUM Aggregation</div>
    <div style="grid-column:2;grid-row:3;background:#fff4e6;border-radius:8px;padding:18px 14px;text-align:center;font-weight:bold;border:1px solid #e6c5b6;">Output<br/>Logical Model<br/>Aggregated View</div>
    <svg style="grid-column:2;grid-row:1/2;width:24px;height:80px;align-self:end;justify-self:center;" xmlns="http://www.w3.org/2000/svg"><line x1="12" y1="0" x2="12" y2="80" stroke="#6b7b8c" stroke-width="2" marker-end="url(#arrowhead)"/><defs><marker id="arrowhead" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto"><polygon points="0,0 8,4 0,8" fill="#6b7b8c"/></marker></defs></svg>
    <svg style="grid-column:2;grid-row:2/3;width:24px;height:80px;align-self:end;justify-self:center;" xmlns="http://www.w3.org/2000/svg"><line x1="12" y1="0" x2="12" y2="80" stroke="#6b7b8c" stroke-width="2" marker-end="url(#arrowhead2)"/><defs><marker id="arrowhead2" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto"><polygon points="0,0 8,4 0,8" fill="#6b7b8c"/></marker></defs></svg>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%;border-collapse:collapse;margin-bottom:16px;">
  <thead>
    <tr style="background:#e3eafc;">
      <th>Target Object/Field Name</th>
      <th>Target Column Name</th>
      <th>Source Object/Field Name</th>
      <th>Source Column Name</th>
      <th>Remarks</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>Projection_1</td><td>MANDT</td><td>_POSDW_TLOGF</td><td>MANDT</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1</td><td>RETAILSTOREID</td><td>_POSDW_TLOGF</td><td>RETAILSTOREID</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1</td><td>BUSINESSDAYDATE</td><td>_POSDW_TLOGF</td><td>BUSINESSDAYDATE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1</td><td>RECORDQUALIFIER</td><td>_POSDW_TLOGF</td><td>RECORDQUALIFIER</td><td>Filter: IN (5,6)</td></tr>
    <tr><td>Projection_1</td><td>TRANSTYPECODE</td><td>_POSDW_TLOGF</td><td>TRANSTYPECODE</td><td>Filter: NOT IN (1107,1197,1020)</td></tr>
    <tr><td>Projection_1</td><td>WORKSTATIONID</td><td>_POSDW_TLOGF</td><td>WORKSTATIONID</td><td>Filter: NOT "0000000000"</td></tr>
    <tr><td>Projection_1</td><td>SALESAMOUNT</td><td>_POSDW_TLOGF</td><td>SALESAMOUNT</td><td>Aggregated: SUM</td></tr>
    <tr><td>Projection_1</td><td>REDUCTIONAMOUNT</td><td>_POSDW_TLOGF</td><td>REDUCTIONAMOUNT</td><td>Aggregated: SUM</td></tr>
    <tr><td>Projection_1</td><td>ARCHIVED</td><td>_POSDW_TLOGF</td><td>ARCHIVED</td><td>Filter: IN (empty string)</td></tr>
    <tr><td>Projection_1</td><td>RETAILTYPECODE</td><td>_POSDW_TLOGF</td><td>RETAILTYPECODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1</td><td>ZZ_UPD_TIMESTAMP</td><td>_POSDW_TLOGF</td><td>ZZ_UPD_TIMESTAMP</td><td>Filter: NOT "0"</td></tr>
    <tr><td>Projection_1</td><td>DISCTYPECODE</td><td>_POSDW_TLOGF</td><td>DISCTYPECODE</td><td>Direct mapping</td></tr>
    <tr><td>Projection_1</td><td>TRANSCURRENCY</td><td>_POSDW_TLOGF</td><td>TRANSCURRENCY</td><td>Direct mapping</td></tr>
  </tbody>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%;border-collapse:collapse;margin-bottom:16px;">
  <tr><td>Number of Objects/Nodes</td><td>3 (Data Source, Projection Node, Logical Model)</td></tr>
  <tr><td>Sources Used</td><td>1 (_POSDW_TLOGF / /POSDW/TLOGF)</td></tr>
  <tr><td>Joins</td><td>None</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>SUM (SALESAMOUNT, REDUCTIONAMOUNT)</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>Attribute filters (IN, NOT IN, NOT value)</td></tr>
  <tr><td>Workflow Complexity</td><td>Low; single projection node, direct mappings, basic filters, simple aggregation</td></tr>
  <tr><td>Performance Considerations</td><td>Performance mainly affected by filters and aggregation; no complex joins or calculations</td></tr>
  <tr><td>Data Volume Handling</td><td>Not explicitly addressed in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Low; single source table dependency</td></tr>
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
  <li>SALESAMOUNT (SUM)</li>
  <li>REDUCTIONAMOUNT (SUM)</li>
  <li>ARCHIVED</li>
  <li>RETAILTYPECODE</li>
  <li>ZZ_UPD_TIMESTAMP</li>
  <li>DISCTYPECODE</li>
  <li>TRANSCURRENCY</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
