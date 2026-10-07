<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse;">
  <tr>
    <td style="padding:8px; border:1px solid #ddd;"><b>Author:</b></td>
    <td style="padding:8px; border:1px solid #ddd;">Ascendion AAVA</td>
  </tr>
  <tr>
    <td style="padding:8px; border:1px solid #ddd;"><b>Created On:</b></td>
    <td style="padding:8px; border:1px solid #ddd;">2026-10-07</td>
  </tr>
  <tr>
    <td style="padding:8px; border:1px solid #ddd; vertical-align:top;"><b>Description:</b></td>
    <td style="padding:8px; border:1px solid #ddd;">This documentation describes the HANA Calculation View <b>CV_BASE_TLOGF</b>, which serves as a base view for a transaction log flat table. The view processes and filters data from a single database table source, projecting selected fields and applying explicit filter conditions as defined in the XML.</td>
  </tr>
</table>

<!-- 1. Overview of Program -->
<p><b>Overview of Program</b><br>
This object is a HANA Calculation View of type <b>CUBE</b> named <b>CV_BASE_TLOGF</b>. Its primary purpose is to provide a base aggregation view for transaction log flat table data. The view performs field projections and applies defined filter conditions to source data from the underlying database table.</p>

<!-- 2. Code Structure and Design -->
<p><b>Code Structure and Design</b><br>
<b>Structure:</b> The Calculation View is structured as a single Projection node (<b>Projection_1</b>) that sources data from the database table <b>/POSDW/TLOGF</b> (aliased as <b>_POSDW_TLOGF</b>). The Projection node selects and maps specific fields, applies list and single value filters to several attributes, and defines two measures with aggregation type <b>sum</b>. No joins, unions, or calculated fields are present.<br>
<b>Key Components:</b> Major components include the <b>Projection_1</b> node, the data source <b>_POSDW_TLOGF</b>, explicit attribute mappings, attribute filters, and two base measures (<b>SALESAMOUNT</b> and <b>REDUCTIONAMOUNT</b>). The logical model defines output attributes and measures.<br>
<b>Dependencies & Performance:</b> The view depends on the database table <b>/POSDW/TLOGF</b>. Performance-relevant characteristics include the use of attribute filters (IN, single value) and aggregation (SUM) on measures. No joins, calculated fields, or nested processing logic are present; the processing is straightforward and limited to projection, filtering, and aggregation.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; background:#f7f7f7; padding:16px; border-radius:8px;">
  <div style="display:grid; grid-template-columns:repeat(3, 220px); grid-template-rows:repeat(3, 80px); gap:32px; align-items:center;">
    <div style="grid-column:1; grid-row:2; background:#e3e8f2; border-radius:8px; box-shadow:0 2px 6px #ccc; display:flex; align-items:center; justify-content:center; height:60px;">Data Source<br><b>_POSDW_TLOGF</b><br>(/POSDW/TLOGF)</div>
    <div style="grid-column:2; grid-row:2; background:#e3e8f2; border-radius:8px; box-shadow:0 2px 6px #ccc; display:flex; align-items:center; justify-content:center; height:60px;">Projection Node<br><b>Projection_1</b></div>
    <div style="grid-column:3; grid-row:2; background:#e3e8f2; border-radius:8px; box-shadow:0 2px 6px #ccc; display:flex; align-items:center; justify-content:center; height:60px;">Output View<br><b>Aggregation</b></div>
    <!-- Arrows -->
    <div style="grid-column:1; grid-row:2; justify-self:end; align-self:center;">
      <svg width="40" height="20">
        <polygon points="0,10 30,10 30,5 40,15 30,25 30,20 0,20" fill="#7d8fa9"/>
      </svg>
    </div>
    <div style="grid-column:2; grid-row:2; justify-self:end; align-self:center;">
      <svg width="40" height="20">
        <polygon points="0,10 30,10 30,5 40,15 30,25 30,20 0,20" fill="#7d8fa9"/>
      </svg>
    </div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%; border-collapse:collapse;">
  <tr style="background:#e3e8f2;">
    <th style="padding:8px; border:1px solid #ddd;">Target Object/Field Name</th>
    <th style="padding:8px; border:1px solid #ddd;">Target Column Name</th>
    <th style="padding:8px; border:1px solid #ddd;">Source Object/Field Name</th>
    <th style="padding:8px; border:1px solid #ddd;">Source Column Name</th>
    <th style="padding:8px; border:1px solid #ddd;">Remarks</th>
  </tr>
  <tr><td>Projection_1</td><td>MANDT</td><td>_POSDW_TLOGF</td><td>MANDT</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>RETAILSTOREID</td><td>_POSDW_TLOGF</td><td>RETAILSTOREID</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>BUSINESSDAYDATE</td><td>_POSDW_TLOGF</td><td>BUSINESSDAYDATE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>RECORDQUALIFIER</td><td>_POSDW_TLOGF</td><td>RECORDQUALIFIER</td><td>Filter: IN (5, 6)</td></tr>
  <tr><td>Projection_1</td><td>TRANSTYPECODE</td><td>_POSDW_TLOGF</td><td>TRANSTYPECODE</td><td>Filter: NOT IN (1107, 1197, 1020)</td></tr>
  <tr><td>Projection_1</td><td>WORKSTATIONID</td><td>_POSDW_TLOGF</td><td>WORKSTATIONID</td><td>Filter: NOT value '0000000000'</td></tr>
  <tr><td>Projection_1</td><td>SALESAMOUNT</td><td>_POSDW_TLOGF</td><td>SALESAMOUNT</td><td>Aggregated: SUM</td></tr>
  <tr><td>Projection_1</td><td>REDUCTIONAMOUNT</td><td>_POSDW_TLOGF</td><td>REDUCTIONAMOUNT</td><td>Aggregated: SUM</td></tr>
  <tr><td>Projection_1</td><td>ARCHIVED</td><td>_POSDW_TLOGF</td><td>ARCHIVED</td><td>Filter: value "" (empty string)</td></tr>
  <tr><td>Projection_1</td><td>RETAILTYPECODE</td><td>_POSDW_TLOGF</td><td>RETAILTYPECODE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>ZZ_UPD_TIMESTAMP</td><td>_POSDW_TLOGF</td><td>ZZ_UPD_TIMESTAMP</td><td>Filter: NOT value '0'</td></tr>
  <tr><td>Projection_1</td><td>DISCTYPECODE</td><td>_POSDW_TLOGF</td><td>DISCTYPECODE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>TRANSCURRENCY</td><td>_POSDW_TLOGF</td><td>TRANSCURRENCY</td><td>Direct mapping</td></tr>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%; border-collapse:collapse;">
  <tr style="background:#e3e8f2;">
    <th style="padding:8px; border:1px solid #ddd;">Category</th>
    <th style="padding:8px; border:1px solid #ddd;">Measurement</th>
  </tr>
  <tr><td>Number of Objects/Nodes</td><td>2 (Projection node, Data Source)</td></tr>
  <tr><td>Sources Used</td><td>1 (/POSDW/TLOGF)</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>SUM (SALESAMOUNT, REDUCTIONAMOUNT)</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>Attribute filters (IN, NOT IN, single value exclusion)</td></tr>
  <tr><td>Workflow Complexity</td><td>Simple linear structure: Data source → Projection → Output</td></tr>
  <tr><td>Performance Considerations</td><td>Attribute filters and aggregation; no joins or complex logic</td></tr>
  <tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single dependency on /POSDW/TLOGF table</td></tr>
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
