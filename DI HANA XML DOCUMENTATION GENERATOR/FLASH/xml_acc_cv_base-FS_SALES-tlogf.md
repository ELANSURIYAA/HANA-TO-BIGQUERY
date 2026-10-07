<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse;">
  <tr>
    <td style="font-weight:bold;">Author:</td>
    <td>Ascendion AAVA</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Created On:</td>
    <td>2026-10-07</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Description:</td>
    <td>Technical documentation for Calculation View 'CV_BASE_TLOGF', which serves as a base view for the transaction log flat table, modeling data from the underlying table '/POSDW/TLOGF'.</td>
  </tr>
</table>

<!-- 1. Overview of Program -->
<p>The provided HANA XML defines a Calculation View named 'CV_BASE_TLOGF'. Its primary purpose is to project and aggregate data from the database table '/POSDW/TLOGF'. The view applies specific filters and exposes selected fields and measures for reporting or further modeling.</p>

<!-- 2. Code Structure and Design -->
<p>
  <b>Structure:</b> The Calculation View consists of a single projection node ('Projection_1') sourcing data from the base table '/POSDW/TLOGF' via the data source '_POSDW_TLOGF'. The projection applies a series of filters to specific fields and maps all relevant attributes and measures directly from the source.
  <b>Key Components:</b> Major components include the data source definition, projection node, view attributes, filters (IN, SingleValue), measure definitions (SALESAMOUNT, REDUCTIONAMOUNT), logical model mapping, and aggregation settings. The view outputs both key attributes and aggregated measures.
  <b>Dependencies & Performance:</b> The Calculation View depends solely on the base table '/POSDW/TLOGF' with no joins or unions. Filters are applied at the projection node, and measures are aggregated using SUM. No calculated attributes or complex processing logic are present, indicating straightforward dependency and low processing overhead.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; padding:10px; background:#f8f9fa; border-radius:8px;">
  <div style="display:grid; grid-template-columns:repeat(3, 200px); grid-template-rows:repeat(3, 80px); align-items:center; justify-items:center; gap:40px;">
    <div style="grid-column:2; grid-row:1; background:#e3eafc; border-radius:8px; box-shadow:0 2px 6px #d1d5db; padding:20px; font-weight:bold;">_POSDW_TLOGF<br><span style="font-size:12px;">(DATA_BASE_TABLE)</span></div>
    <div style="grid-column:2; grid-row:2; background:#c7e6e6; border-radius:8px; box-shadow:0 2px 6px #d1d5db; padding:20px; font-weight:bold;">Projection_1<br><span style="font-size:12px;">(Projection Node)</span></div>
    <div style="grid-column:2; grid-row:3; background:#ffe5b4; border-radius:8px; box-shadow:0 2px 6px #d1d5db; padding:20px; font-weight:bold;">Output<br><span style="font-size:12px;">(Aggregated View)</span></div>
    <!-- Connectors -->
    <div style="grid-column:2; grid-row:1; justify-self:center; align-self:end;">
      <svg width="20" height="40"><line x1="10" y1="0" x2="10" y2="40" stroke="#666" stroke-width="2" marker-end="url(#arrow)"/></svg>
    </div>
    <div style="grid-column:2; grid-row:2; justify-self:center; align-self:end;">
      <svg width="20" height="40"><line x1="10" y1="0" x2="10" y2="40" stroke="#666" stroke-width="2" marker-end="url(#arrow)"/></svg>
    </div>
  </div>
  <svg style="position:absolute; visibility:hidden;">
    <defs>
      <marker id="arrow" markerWidth="10" markerHeight="10" refX="5" refY="5" orient="auto" markerUnits="strokeWidth">
        <path d="M0,0 L0,10 L10,5 z" fill="#666" />
      </marker>
    </defs>
  </svg>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%; border-collapse:collapse;">
  <tr style="background:#f2f2f2;">
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr><td>Projection_1.MANDT</td><td>MANDT</td><td>_POSDW_TLOGF.MANDT</td><td>MANDT</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.RETAILSTOREID</td><td>RETAILSTOREID</td><td>_POSDW_TLOGF.RETAILSTOREID</td><td>RETAILSTOREID</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.BUSINESSDAYDATE</td><td>BUSINESSDAYDATE</td><td>_POSDW_TLOGF.BUSINESSDAYDATE</td><td>BUSINESSDAYDATE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.RECORDQUALIFIER</td><td>RECORDQUALIFIER</td><td>_POSDW_TLOGF.RECORDQUALIFIER</td><td>RECORDQUALIFIER</td><td>Filter: IN (5, 6)</td></tr>
  <tr><td>Projection_1.TRANSTYPECODE</td><td>TRANSTYPECODE</td><td>_POSDW_TLOGF.TRANSTYPECODE</td><td>TRANSTYPECODE</td><td>Filter: NOT IN (1107, 1197, 1020)</td></tr>
  <tr><td>Projection_1.WORKSTATIONID</td><td>WORKSTATIONID</td><td>_POSDW_TLOGF.WORKSTATIONID</td><td>WORKSTATIONID</td><td>Filter: NOT '0000000000'</td></tr>
  <tr><td>Projection_1.SALESAMOUNT</td><td>SALESAMOUNT</td><td>_POSDW_TLOGF.SALESAMOUNT</td><td>SALESAMOUNT</td><td>Direct mapping; Aggregation: SUM</td></tr>
  <tr><td>Projection_1.REDUCTIONAMOUNT</td><td>REDUCTIONAMOUNT</td><td>_POSDW_TLOGF.REDUCTIONAMOUNT</td><td>REDUCTIONAMOUNT</td><td>Direct mapping; Aggregation: SUM</td></tr>
  <tr><td>Projection_1.ARCHIVED</td><td>ARCHIVED</td><td>_POSDW_TLOGF.ARCHIVED</td><td>ARCHIVED</td><td>Filter: SingleValue (empty string)</td></tr>
  <tr><td>Projection_1.RETAILTYPECODE</td><td>RETAILTYPECODE</td><td>_POSDW_TLOGF.RETAILTYPECODE</td><td>RETAILTYPECODE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZZ_UPD_TIMESTAMP</td><td>ZZ_UPD_TIMESTAMP</td><td>_POSDW_TLOGF.ZZ_UPD_TIMESTAMP</td><td>ZZ_UPD_TIMESTAMP</td><td>Filter: NOT '0'</td></tr>
  <tr><td>Projection_1.DISCTYPECODE</td><td>DISCTYPECODE</td><td>_POSDW_TLOGF.DISCTYPECODE</td><td>DISCTYPECODE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.TRANSCURRENCY</td><td>TRANSCURRENCY</td><td>_POSDW_TLOGF.TRANSCURRENCY</td><td>TRANSCURRENCY</td><td>Direct mapping</td></tr>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%; border-collapse:collapse;">
  <tr style="background:#f2f2f2;"><th>Category</th><th>Measurement</th></tr>
  <tr><td>Number of Objects/Nodes</td><td>3 (Data Source, Projection Node, Output)</td></tr>
  <tr><td>Sources Used</td><td>1 (/_POSDW_TLOGF mapped to /POSDW/TLOGF)</td></tr>
  <tr><td>Joins</td><td>None</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>SUM (SALESAMOUNT, REDUCTIONAMOUNT)</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>Filters on RECORDQUALIFIER, TRANSTYPECODE, WORKSTATIONID, ARCHIVED, ZZ_UPD_TIMESTAMP</td></tr>
  <tr><td>Workflow Complexity</td><td>Low (single projection, no joins or unions)</td></tr>
  <tr><td>Performance Considerations</td><td>Direct source access, filtered projection, aggregation; minimal complexity</td></tr>
  <tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
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
