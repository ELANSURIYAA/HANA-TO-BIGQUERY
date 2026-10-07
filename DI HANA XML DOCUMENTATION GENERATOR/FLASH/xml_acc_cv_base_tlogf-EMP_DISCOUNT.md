<!-- DOCUMENT HEADER -->
<table>
  <tr><td><b>Author:</b></td><td>Ascendion AAVA</td></tr>
  <tr><td><b>Created On:</b></td><td>2026-10-07</td></tr>
  <tr><td><b>Description:</b></td><td>This documentation describes a HANA Calculation View (ID: CV_BASE_TLOGF) defined as a TREE_BASED CUBE, serving as a base view for the Transaction Log Flat table. The view projects and aggregates fields from a single database table with specific filters applied to selected columns.</td></tr>
</table>

<!-- 1. Overview of Program -->
<p>This HANA XML object is a Calculation View of type TREE_BASED with a data category of CUBE. Its primary purpose is to provide a base aggregation and projection layer for the Transaction Log Flat table, exposing key transactional fields and measures. The object applies filters to certain columns and aggregates sales-related amounts for reporting purposes.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View consists of a single projection node (Projection_1) that sources data from a database table identified as /POSDW/TLOGF. The projection maps and exposes multiple attributes and two measures, applies explicit filters to several fields, and outputs the result as an aggregation view. <b>Key Components:</b> The major components include the data source (_POSDW_TLOGF), projection node (Projection_1), mapped attributes (e.g., MANDT, RETAILSTOREID), measures (SALESAMOUNT, REDUCTIONAMOUNT), and filters applied to RECORDQUALIFIER, TRANSTYPECODE, WORKSTATIONID, ARCHIVED, and ZZ_UPD_TIMESTAMP. <b>Dependencies & Performance:</b> The view depends on the referenced database table and applies attribute-level filters, with aggregation defined for the measures. No joins or unions are present, and the structure is straightforward, supporting efficient data access and reporting.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; background:#f9f9f9; padding:24px; border-radius:8px;">
  <div style="display:grid; grid-template-columns:repeat(3, 180px); grid-template-rows:repeat(3, 80px); align-items:center; justify-items:center; gap:32px;">
    <div style="grid-column:2; grid-row:1; background:#e3eafc; border:1px solid #b6c8f9; border-radius:8px; padding:18px; font-weight:bold;">Data Source<br/>/POSDW/TLOGF<br/>(_POSDW_TLOGF)</div>
    <div style="grid-column:2; grid-row:2; background:#eaf7ea; border:1px solid #b6f9c8; border-radius:8px; padding:18px; font-weight:bold;">Projection Node<br/>Projection_1<br/>Filters + Mapping</div>
    <div style="grid-column:2; grid-row:3; background:#fcf3e3; border:1px solid #f9e6b6; border-radius:8px; padding:18px; font-weight:bold;">Aggregation Output<br/>CUBE View<br/>Measures & Attributes</div>
    <div style="grid-column:2; grid-row:1; grid-column-end:2; grid-row-end:2; width:0; height:0; border-left:2px solid #b6c8f9; border-bottom:2px solid #b6c8f9; margin-top:40px;"></div>
    <div style="grid-column:2; grid-row:2; grid-column-end:2; grid-row-end:3; width:0; height:0; border-left:2px solid #b6f9c8; border-bottom:2px solid #b6f9c8; margin-top:40px;"></div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="6" cellspacing="0">
  <tr>
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr><td>Projection_1.MANDT</td><td>MANDT</td><td>_POSDW_TLOGF</td><td>MANDT</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.RETAILSTOREID</td><td>RETAILSTOREID</td><td>_POSDW_TLOGF</td><td>RETAILSTOREID</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.BUSINESSDAYDATE</td><td>BUSINESSDAYDATE</td><td>_POSDW_TLOGF</td><td>BUSINESSDAYDATE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.RECORDQUALIFIER</td><td>RECORDQUALIFIER</td><td>_POSDW_TLOGF</td><td>RECORDQUALIFIER</td><td>Filter: IN (5, 6)</td></tr>
  <tr><td>Projection_1.TRANSTYPECODE</td><td>TRANSTYPECODE</td><td>_POSDW_TLOGF</td><td>TRANSTYPECODE</td><td>Filter: NOT IN (1107, 1197, 1020)</td></tr>
  <tr><td>Projection_1.WORKSTATIONID</td><td>WORKSTATIONID</td><td>_POSDW_TLOGF</td><td>WORKSTATIONID</td><td>Filter: NOT 0000000000</td></tr>
  <tr><td>Projection_1.SALESAMOUNT</td><td>SALESAMOUNT</td><td>_POSDW_TLOGF</td><td>SALESAMOUNT</td><td>Aggregated (SUM)</td></tr>
  <tr><td>Projection_1.REDUCTIONAMOUNT</td><td>REDUCTIONAMOUNT</td><td>_POSDW_TLOGF</td><td>REDUCTIONAMOUNT</td><td>Aggregated (SUM)</td></tr>
  <tr><td>Projection_1.ARCHIVED</td><td>ARCHIVED</td><td>_POSDW_TLOGF</td><td>ARCHIVED</td><td>Filter: SingleValue (empty)</td></tr>
  <tr><td>Projection_1.RETAILTYPECODE</td><td>RETAILTYPECODE</td><td>_POSDW_TLOGF</td><td>RETAILTYPECODE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZZ_UPD_TIMESTAMP</td><td>ZZ_UPD_TIMESTAMP</td><td>_POSDW_TLOGF</td><td>ZZ_UPD_TIMESTAMP</td><td>Filter: NOT 0</td></tr>
  <tr><td>Projection_1.DISCTYPECODE</td><td>DISCTYPECODE</td><td>_POSDW_TLOGF</td><td>DISCTYPECODE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.TRANSCURRENCY</td><td>TRANSCURRENCY</td><td>_POSDW_TLOGF</td><td>TRANSCURRENCY</td><td>Direct mapping</td></tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="6" cellspacing="0">
  <tr><th>Category</th><th>Measurement</th></tr>
  <tr><td>Number of Objects/Nodes</td><td>3 (Data Source, Projection Node, Aggregation Output)</td></tr>
  <tr><td>Sources Used</td><td>1 (Database Table: /POSDW/TLOGF)</td></tr>
  <tr><td>Joins</td><td>None</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>SUM on SALESAMOUNT, REDUCTIONAMOUNT</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>Attribute-level filters on RECORDQUALIFIER, TRANSTYPECODE, WORKSTATIONID, ARCHIVED, ZZ_UPD_TIMESTAMP</td></tr>
  <tr><td>Workflow Complexity</td><td>Low; simple linear projection and aggregation</td></tr>
  <tr><td>Performance Considerations</td><td>Single source, attribute filters, aggregation; efficient structure for reporting</td></tr>
  <tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single dependency on database table /POSDW/TLOGF</td></tr>
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
  <li>SALESAMOUNT (Aggregated)</li>
  <li>REDUCTIONAMOUNT (Aggregated)</li>
  <li>ARCHIVED</li>
  <li>RETAILTYPECODE</li>
  <li>ZZ_UPD_TIMESTAMP</li>
  <li>DISCTYPECODE</li>
  <li>TRANSCURRENCY</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
