<!-- DOCUMENT HEADER -->
<table style="width:100%;border-collapse:collapse;margin-bottom:20px;">
  <tr>
    <td style="font-weight:bold;width:20%;">Author:</td>
    <td>Ascendion AAVA</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Created On:</td>
    <td>2026-10-07</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Description:</td>
    <td>Technical documentation for a HANA Calculation View named <b>CV_BASE_TLOGF</b>, which serves as a base view for the Transaction Log Flat table. The view provides a structured aggregation and filtering of transactional data from a single source table.</td>
  </tr>
</table>

<!-- 1. Overview of Program -->
<p><b>Overview of Program:</b><br>
This HANA XML defines a Calculation View of type <b>CUBE</b> named <b>CV_BASE_TLOGF</b>. Its primary purpose is to model and aggregate transactional log data from the underlying database table <b>/POSDW/TLOGF</b>. The view applies specific filters to selected fields and exposes a set of attributes and measures for reporting and analytics.</p>

<!-- 2. Code Structure and Design -->
<p>
<b>Structure:</b> The Calculation View consists of a single projection node (<b>Projection_1</b>) sourcing data from the base table <b>/POSDW/TLOGF</b>. The projection applies filters to multiple fields, maps source columns directly to output attributes and measures, and defines aggregation on numerical fields. The logical model specifies the output structure, including attributes and measures, with aggregation type <b>sum</b> for sales and reduction amounts.<br>
<b>Key Components:</b> The major components are the <b>DataSource</b> referencing <b>/POSDW/TLOGF</b>, the <b>Projection_1</b> node, attribute mappings, field-level filters, and the logical model defining output attributes and measures. Filters are applied on <b>RECORDQUALIFIER</b>, <b>TRANSTYPECODE</b>, <b>WORKSTATIONID</b>, <b>ARCHIVED</b>, and <b>ZZ_UPD_TIMESTAMP</b>.<br>
<b>Dependencies & Performance:</b> The Calculation View depends on the single base table <b>/POSDW/TLOGF</b> and does not reference other views or tables. No joins, unions, or calculated fields are present. Performance is influenced by the applied filters and the aggregation of measures, with no explicit complex processing or nested logic. The view is read-only and does not manipulate data.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="width:100%;overflow-x:auto;padding:10px 0;">
  <div style="display:grid;grid-template-columns:repeat(4,220px);grid-template-rows:repeat(2,120px);gap:40px;align-items:center;justify-items:center;background:#f7f7fa;border-radius:12px;padding:24px;">
    <div style="grid-column:1;grid-row:1;background:#e0e7ff;border-radius:8px;padding:18px;text-align:center;font-weight:bold;box-shadow:0 1px 6px #b5b5b5;">DataSource<br><span style="font-size:13px;font-weight:normal;">/POSDW/TLOGF</span></div>
    <div style="grid-column:2;grid-row:1;background:#d1fae5;border-radius:8px;padding:18px;text-align:center;font-weight:bold;box-shadow:0 1px 6px #b5b5b5;">Projection_1<br><span style="font-size:13px;font-weight:normal;">Filters & Mapping</span></div>
    <div style="grid-column:3;grid-row:1;background:#fef3c7;border-radius:8px;padding:18px;text-align:center;font-weight:bold;box-shadow:0 1px 6px #b5b5b5;">Aggregation<br><span style="font-size:13px;font-weight:normal;">Sum: SALESAMOUNT, REDUCTIONAMOUNT</span></div>
    <div style="grid-column:4;grid-row:1;background:#c7d2fe;border-radius:8px;padding:18px;text-align:center;font-weight:bold;box-shadow:0 1px 6px #b5b5b5;">Output<br><span style="font-size:13px;font-weight:normal;">Attributes & Measures</span></div>
    <div style="grid-column:1;grid-row:2;"></div>
    <div style="grid-column:2;grid-row:2;"></div>
    <div style="grid-column:3;grid-row:2;"></div>
    <div style="grid-column:4;grid-row:2;"></div>
    <!-- Arrows -->
    <svg style="grid-column:1;grid-row:1;position:relative;left:190px;top:50px;" width="60" height="24">
      <defs><marker id="arrow" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto" markerUnits="strokeWidth"><path d="M0,0 L8,4 L0,8" fill="#6366f1"/></marker></defs>
      <line x1="0" y1="12" x2="60" y2="12" stroke="#6366f1" stroke-width="3" marker-end="url(#arrow)"/>
    </svg>
    <svg style="grid-column:2;grid-row:1;position:relative;left:190px;top:50px;" width="60" height="24">
      <defs><marker id="arrow2" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto" markerUnits="strokeWidth"><path d="M0,0 L8,4 L0,8" fill="#10b981"/></marker></defs>
      <line x1="0" y1="12" x2="60" y2="12" stroke="#10b981" stroke-width="3" marker-end="url(#arrow2)"/>
    </svg>
    <svg style="grid-column:3;grid-row:1;position:relative;left:190px;top:50px;" width="60" height="24">
      <defs><marker id="arrow3" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto" markerUnits="strokeWidth"><path d="M0,0 L8,4 L0,8" fill="#f59e42"/></marker></defs>
      <line x1="0" y1="12" x2="60" y2="12" stroke="#f59e42" stroke-width="3" marker-end="url(#arrow3)"/>
    </svg>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%;border-collapse:collapse;margin-bottom:24px;">
  <thead style="background:#f3f4f6;">
    <tr>
      <th style="padding:8px;border:1px solid #d1d5db;">Target Object/Field Name</th>
      <th style="padding:8px;border:1px solid #d1d5db;">Target Column Name</th>
      <th style="padding:8px;border:1px solid #d1d5db;">Source Object/Field Name</th>
      <th style="padding:8px;border:1px solid #d1d5db;">Source Column Name</th>
      <th style="padding:8px;border:1px solid #d1d5db;">Remarks</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>MANDT</td><td>MANDT</td><td>_POSDW_TLOGF</td><td>MANDT</td><td>Direct mapping</td></tr>
    <tr><td>RETAILSTOREID</td><td>RETAILSTOREID</td><td>_POSDW_TLOGF</td><td>RETAILSTOREID</td><td>Direct mapping</td></tr>
    <tr><td>BUSINESSDAYDATE</td><td>BUSINESSDAYDATE</td><td>_POSDW_TLOGF</td><td>BUSINESSDAYDATE</td><td>Direct mapping</td></tr>
    <tr><td>RECORDQUALIFIER</td><td>RECORDQUALIFIER</td><td>_POSDW_TLOGF</td><td>RECORDQUALIFIER</td><td>Filtered: IN (5,6)</td></tr>
    <tr><td>TRANSTYPECODE</td><td>TRANSTYPECODE</td><td>_POSDW_TLOGF</td><td>TRANSTYPECODE</td><td>Filtered: NOT IN (1107,1197,1020)</td></tr>
    <tr><td>WORKSTATIONID</td><td>WORKSTATIONID</td><td>_POSDW_TLOGF</td><td>WORKSTATIONID</td><td>Filtered: NOT "0000000000"</td></tr>
    <tr><td>SALESAMOUNT</td><td>SALESAMOUNT</td><td>_POSDW_TLOGF</td><td>SALESAMOUNT</td><td>Aggregated: SUM</td></tr>
    <tr><td>REDUCTIONAMOUNT</td><td>REDUCTIONAMOUNT</td><td>_POSDW_TLOGF</td><td>REDUCTIONAMOUNT</td><td>Aggregated: SUM</td></tr>
    <tr><td>ARCHIVED</td><td>ARCHIVED</td><td>_POSDW_TLOGF</td><td>ARCHIVED</td><td>Filtered: Single Value (empty string)</td></tr>
    <tr><td>RETAILTYPECODE</td><td>RETAILTYPECODE</td><td>_POSDW_TLOGF</td><td>RETAILTYPECODE</td><td>Direct mapping</td></tr>
    <tr><td>ZZ_UPD_TIMESTAMP</td><td>ZZ_UPD_TIMESTAMP</td><td>_POSDW_TLOGF</td><td>ZZ_UPD_TIMESTAMP</td><td>Filtered: NOT "0"</td></tr>
    <tr><td>DISCTYPECODE</td><td>DISCTYPECODE</td><td>_POSDW_TLOGF</td><td>DISCTYPECODE</td><td>Direct mapping</td></tr>
    <tr><td>TRANSCURRENCY</td><td>TRANSCURRENCY</td><td>_POSDW_TLOGF</td><td>TRANSCURRENCY</td><td>Direct mapping</td></tr>
  </tbody>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%;border-collapse:collapse;margin-bottom:24px;">
  <tr>
    <td style="padding:8px;border:1px solid #d1d5db;">Number of Objects/Nodes</td>
    <td style="padding:8px;border:1px solid #d1d5db;">2 (DataSource, Projection_1)</td>
  </tr>
  <tr>
    <td style="padding:8px;border:1px solid #d1d5db;">Sources Used</td>
    <td style="padding:8px;border:1px solid #d1d5db;">/POSDW/TLOGF</td>
  </tr>
  <tr>
    <td style="padding:8px;border:1px solid #d1d5db;">Joins</td>
    <td style="padding:8px;border:1px solid #d1d5db;">None identified</td>
  </tr>
  <tr>
    <td style="padding:8px;border:1px solid #d1d5db;">Temporary/Cached Data</td>
    <td style="padding:8px;border:1px solid #d1d5db;">None identified</td>
  </tr>
  <tr>
    <td style="padding:8px;border:1px solid #d1d5db;">Aggregate Functions</td>
    <td style="padding:8px;border:1px solid #d1d5db;">SUM (SALESAMOUNT, REDUCTIONAMOUNT)</td>
  </tr>
  <tr>
    <td style="padding:8px;border:1px solid #d1d5db;">Data Manipulation</td>
    <td style="padding:8px;border:1px solid #d1d5db;">No data manipulation identified</td>
  </tr>
  <tr>
    <td style="padding:8px;border:1px solid #d1d5db;">Conditional Logic</td>
    <td style="padding:8px;border:1px solid #d1d5db;">Field-level filters (IN, NOT IN, Single Value)</td>
  </tr>
  <tr>
    <td style="padding:8px;border:1px solid #d1d5db;">Workflow Complexity</td>
    <td style="padding:8px;border:1px solid #d1d5db;">Simple, linear projection with aggregation</td>
  </tr>
  <tr>
    <td style="padding:8px;border:1px solid #d1d5db;">Performance Considerations</td>
    <td style="padding:8px;border:1px solid #d1d5db;">Filters and aggregation may affect performance; no complex processing identified</td>
  </tr>
  <tr>
    <td style="padding:8px;border:1px solid #d1d5db;">Data Volume Handling</td>
    <td style="padding:8px;border:1px solid #d1d5db;">Not specified in XML</td>
  </tr>
  <tr>
    <td style="padding:8px;border:1px solid #d1d5db;">Dependency Complexity</td>
    <td style="padding:8px;border:1px solid #d1d5db;">Single source table dependency</td>
  </tr>
  <tr>
    <td style="padding:8px;border:1px solid #d1d5db;">Overall Complexity Score</td>
    <td style="padding:8px;border:1px solid #d1d5db;">Low</td>
  </tr>
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
  <li>SALESAMOUNT (aggregated sum)</li>
  <li>REDUCTIONAMOUNT (aggregated sum)</li>
  <li>ARCHIVED</li>
  <li>RETAILTYPECODE</li>
  <li>ZZ_UPD_TIMESTAMP</li>
  <li>DISCTYPECODE</li>
  <li>TRANSCURRENCY</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
