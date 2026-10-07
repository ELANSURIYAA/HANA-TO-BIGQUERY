<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:8px;margin-bottom:16px;">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> 2024-06-13<br>
  <b>Description:</b> This HANA Calculation View (CV_BASE_TLOGF_COVID) defines a base view for a transaction log flat table, projecting and filtering fields from a single source table with aggregation capabilities for sales amount.
</div>

<!-- 1. Overview of Program -->
<p>This object is a HANA Calculation View of type CUBE with aggregation output. Its primary purpose is to provide a base view over a transaction log flat table, projecting and filtering relevant fields. The main processing involves selecting fields, applying filters, and aggregating sales amounts from the source table.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View is structured with a single Projection node (Projection_1) that sources data from the database table /POSDW/TLOGF. The Projection node defines view attributes, applies filters to specific fields, and maps source columns directly to output fields. The logical model specifies attributes and a single measure (SALESAMOUNT) with aggregation type 'sum'.<br>
<b>Key Components:</b> Major components include the Projection node, the source table (_POSDW_TLOGF), attribute mappings, applied filters, and the aggregation measure. Filters are applied to RECORDQUALIFIER, TRANSTYPECODE, WORKSTATIONID, ARCHIVED, ZZ_UPD_TIMESTAMP, and ITEMID fields. The output consists of selected attributes and the aggregated SALESAMOUNT.<br>
<b>Dependencies & Performance:</b> The view depends on the underlying database table /POSDW/TLOGF. No joins or unions are defined. Performance-relevant characteristics include field-level filtering and aggregation, with no complex calculations or nested processing present.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;background:#f7f7f7;padding:20px;border-radius:8px;width:100%;max-width:900px;">
  <div style="display:grid;grid-template-columns:repeat(3,180px);grid-template-rows:repeat(3,80px);gap:24px;align-items:center;justify-items:center;">
    <!-- Source Table -->
    <div style="grid-column:1;grid-row:1;background:#e3eaff;border-radius:6px;padding:16px;text-align:center;font-weight:bold;box-shadow:0 2px 8px #ccc;">/POSDW/TLOGF<br><span style="font-size:smaller;color:#555;">(Data Base Table)</span></div>
    <!-- Projection Node -->
    <div style="grid-column:2;grid-row:2;background:#d8f7e3;border-radius:6px;padding:16px;text-align:center;font-weight:bold;box-shadow:0 2px 8px #ccc;">Projection_1<br><span style="font-size:smaller;color:#555;">(Projection Node)</span></div>
    <!-- Output -->
    <div style="grid-column:3;grid-row:3;background:#ffe6e6;border-radius:6px;padding:16px;text-align:center;font-weight:bold;box-shadow:0 2px 8px #ccc;">Output<br><span style="font-size:smaller;color:#555;">(Aggregation View)</span></div>
    <!-- Connectors -->
    <svg style="grid-column:1;grid-row:1/2;z-index:2;" width="180" height="80">
      <defs><marker id="arrow" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto" markerUnits="strokeWidth"><path d="M0,0 L8,4 L0,8" fill="#666"/></marker></defs>
      <line x1="90" y1="70" x2="270" y2="110" stroke="#666" stroke-width="2" marker-end="url(#arrow)"/>
    </svg>
    <svg style="grid-column:2;grid-row:2/3;z-index:2;" width="180" height="80">
      <defs><marker id="arrow2" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto" markerUnits="strokeWidth"><path d="M0,0 L8,4 L0,8" fill="#666"/></marker></defs>
      <line x1="90" y1="70" x2="270" y2="110" stroke="#666" stroke-width="2" marker-end="url(#arrow2)"/>
    </svg>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;">
<tr><th>Target Object/Field Name</th><th>Target Column Name</th><th>Source Object/Field Name</th><th>Source Column Name</th><th>Remarks</th></tr>
<tr><td>Projection_1.MANDT</td><td>MANDT</td><td>_POSDW_TLOGF.MANDT</td><td>MANDT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RETAILSTOREID</td><td>RETAILSTOREID</td><td>_POSDW_TLOGF.RETAILSTOREID</td><td>RETAILSTOREID</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.BUSINESSDAYDATE</td><td>BUSINESSDAYDATE</td><td>_POSDW_TLOGF.BUSINESSDAYDATE</td><td>BUSINESSDAYDATE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RECORDQUALIFIER</td><td>RECORDQUALIFIER</td><td>_POSDW_TLOGF.RECORDQUALIFIER</td><td>RECORDQUALIFIER</td><td>Filter: IN (5, 6)</td></tr>
<tr><td>Projection_1.TRANSTYPECODE</td><td>TRANSTYPECODE</td><td>_POSDW_TLOGF.TRANSTYPECODE</td><td>TRANSTYPECODE</td><td>Filter: NOT IN (1107, 1197, 1020)</td></tr>
<tr><td>Projection_1.WORKSTATIONID</td><td>WORKSTATIONID</td><td>_POSDW_TLOGF.WORKSTATIONID</td><td>WORKSTATIONID</td><td>Filter: NOT "0000000000"</td></tr>
<tr><td>Projection_1.SALESAMOUNT</td><td>SALESAMOUNT</td><td>_POSDW_TLOGF.SALESAMOUNT</td><td>SALESAMOUNT</td><td>Direct mapping; Aggregation: sum</td></tr>
<tr><td>Projection_1.ARCHIVED</td><td>ARCHIVED</td><td>_POSDW_TLOGF.ARCHIVED</td><td>ARCHIVED</td><td>Filter: Value = ""</td></tr>
<tr><td>Projection_1.RETAILTYPECODE</td><td>RETAILTYPECODE</td><td>_POSDW_TLOGF.RETAILTYPECODE</td><td>RETAILTYPECODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZZ_UPD_TIMESTAMP</td><td>ZZ_UPD_TIMESTAMP</td><td>_POSDW_TLOGF.ZZ_UPD_TIMESTAMP</td><td>ZZ_UPD_TIMESTAMP</td><td>Filter: NOT "0"</td></tr>
<tr><td>Projection_1.DISCTYPECODE</td><td>DISCTYPECODE</td><td>_POSDW_TLOGF.DISCTYPECODE</td><td>DISCTYPECODE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.TRANSCURRENCY</td><td>TRANSCURRENCY</td><td>_POSDW_TLOGF.TRANSCURRENCY</td><td>TRANSCURRENCY</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ITEMID</td><td>ITEMID</td><td>_POSDW_TLOGF.ITEMID</td><td>ITEMID</td><td>Filter: Value = "A01-433556"</td></tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;">
<tr><th>Category</th><th>Measurement</th></tr>
<tr><td>Number of Objects/Nodes</td><td>2 (Projection node, Output node)</td></tr>
<tr><td>Sources Used</td><td>1 (/POSDW/TLOGF)</td></tr>
<tr><td>Joins</td><td>0</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>sum (SALESAMOUNT)</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>Field-level filters applied</td></tr>
<tr><td>Workflow Complexity</td><td>Simple linear workflow (source → projection → output)</td></tr>
<tr><td>Performance Considerations</td><td>Field-level filtering and aggregation; no joins or nested logic</td></tr>
<tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
<tr><td>Dependency Complexity</td><td>Single table dependency</td></tr>
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
  <li>SALESAMOUNT (aggregated)</li>
  <li>ARCHIVED</li>
  <li>RETAILTYPECODE</li>
  <li>ZZ_UPD_TIMESTAMP</li>
  <li>DISCTYPECODE</li>
  <li>TRANSCURRENCY</li>
  <li>ITEMID</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
