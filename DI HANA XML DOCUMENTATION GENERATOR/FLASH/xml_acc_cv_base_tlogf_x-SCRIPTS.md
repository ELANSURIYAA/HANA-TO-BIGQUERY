<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse;">
  <tr>
    <td style="font-weight:bold; width:25%">Author:</td>
    <td>Ascendion AAVA</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Created On:</td>
    <td>2026-10-07</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Description:</td>
    <td>Technical documentation for the HANA Calculation View <b>CV_BASE_TLOGF_X</b>, which serves as a base projection for the Transaction Log Extensions table. The view projects and filters fields from the referenced database table and applies specific value-based filters to certain attributes.</td>
  </tr>
</table>

<!-- 1. OVERVIEW OF PROGRAM -->
<p><b>Overview of Program</b></p>
<p>This HANA XML object is a Calculation View of type <b>DIMENSION</b> named <b>CV_BASE_TLOGF_X</b>. Its primary purpose is to project selected fields from the Transaction Log Extensions table and apply attribute-level filters to refine the output. The view acts as a foundational layer for further modeling or consumption, focusing on field selection and value-based filtering.</p>

<!-- 2. CODE STRUCTURE AND DESIGN -->
<p><b>Code Structure and Design</b></p>
<p>
  <b>Structure:</b> The Calculation View is structured with a single Projection node (<b>Projection_1</b>) that sources data from the database table <b>/POSDW/TLOGF_X</b> via the data source <b>_POSDW_TLOGF_X</b>. The projection node selects fourteen attributes, with filters applied to <b>RECORDQUALIFIER</b>, <b>WORKSTATIONID</b>, and <b>ZZ_UPD_TIMESTAMP</b> based on specific values. No calculated fields, aggregations, joins, or unions are defined in this view.
  <br><b>Key Components:</b> The major components are: the data source (<b>_POSDW_TLOGF_X</b>), the Projection node (<b>Projection_1</b>), the attribute selection and mapping, and the attribute-level filters. Each attribute is mapped directly from the source table to the output.
  <br><b>Dependencies & Performance:</b> The view depends on the database table <b>/POSDW/TLOGF_X</b> as its sole source. Performance-relevant characteristics include the use of attribute-level filters, which may reduce data volume in the output. No joins, aggregations, or complex processing logic are present, suggesting a straightforward and efficient structure.
</p>

<!-- 3. DATA FLOW AND PROCESSING LOGIC -->
<p><b>Data Flow and Processing Logic</b></p>
<div style="overflow-x:auto; padding:10px; background:#f9f9f9;">
  <div style="display:grid; grid-template-columns: 200px 40px 200px; grid-template-rows: 80px 80px 80px; align-items:center;">
    <div style="grid-row:1; grid-column:1; background:#e3e6f2; border-radius:8px; padding:20px; text-align:center; font-weight:bold; box-shadow:0 2px 6px #b0b0b0;">Data Source:<br>_POSDW_TLOGF_X<br>/POSDW/TLOGF_X</div>
    <div style="grid-row:1; grid-column:2; text-align:center; font-size:32px;">→</div>
    <div style="grid-row:1; grid-column:3; background:#e3f2e3; border-radius:8px; padding:20px; text-align:center; font-weight:bold; box-shadow:0 2px 6px #b0b0b0;">Projection Node:<br>Projection_1<br><span style='font-size:12px;'>Attribute Selection & Filtering</span></div>
    <div style="grid-row:2; grid-column:3; background:#f2e3e3; border-radius:8px; padding:10px; text-align:left; font-size:13px; box-shadow:0 2px 6px #b0b0b0;">
      <b>Filters Applied:</b>
      <ul style="margin:0 0 0 15px;">
        <li>RECORDQUALIFIER = 25 (include)</li>
        <li>WORKSTATIONID = 0000000000 (exclude)</li>
        <li>ZZ_UPD_TIMESTAMP = 0 (exclude)</li>
      </ul>
    </div>
    <div style="grid-row:2; grid-column:2; text-align:center; font-size:32px;">↓</div>
    <div style="grid-row:3; grid-column:3; background:#e3e6f2; border-radius:8px; padding:20px; text-align:center; font-weight:bold; box-shadow:0 2px 6px #b0b0b0;">Output:<br>Projection_1<br>Selected Attributes</div>
  </div>
</div>

<!-- 4. DATA MAPPING -->
<p><b>Data Mapping</b></p>
<table style="width:100%; border-collapse:collapse;">
  <tr style="background:#e3e6f2;">
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr><td>Projection_1</td><td>MANDT</td><td>_POSDW_TLOGF_X</td><td>MANDT</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>RETAILSTOREID</td><td>_POSDW_TLOGF_X</td><td>RETAILSTOREID</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>BUSINESSDAYDATE</td><td>_POSDW_TLOGF_X</td><td>BUSINESSDAYDATE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>RECORDQUALIFIER</td><td>_POSDW_TLOGF_X</td><td>RECORDQUALIFIER</td><td>Filter: Include value 25</td></tr>
  <tr><td>Projection_1</td><td>WORKSTATIONID</td><td>_POSDW_TLOGF_X</td><td>WORKSTATIONID</td><td>Filter: Exclude value 0000000000</td></tr>
  <tr><td>Projection_1</td><td>ARCHIVED</td><td>_POSDW_TLOGF_X</td><td>ARCHIVED</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>ZZ_UPD_TIMESTAMP</td><td>_POSDW_TLOGF_X</td><td>ZZ_UPD_TIMESTAMP</td><td>Filter: Exclude value 0</td></tr>
  <tr><td>Projection_1</td><td>ZZ_CUSTTYPE</td><td>_POSDW_TLOGF_X</td><td>ZZ_CUSTTYPE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>ZZ_RX_CNT_NS</td><td>_POSDW_TLOGF_X</td><td>ZZ_RX_CNT_NS</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>ZZ_RX_CNT_REFILL</td><td>_POSDW_TLOGF_X</td><td>ZZ_RX_CNT_REFILL</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>ZZ_RX_CNT_GE84_NS</td><td>_POSDW_TLOGF_X</td><td>ZZ_RX_CNT_GE84_NS</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>ZZ_RX_CNT_GE84_RE</td><td>_POSDW_TLOGF_X</td><td>ZZ_RX_CNT_GE84_RE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>ZZ_RX_MCRX_GE84_NS</td><td>_POSDW_TLOGF_X</td><td>ZZ_RX_MCRX_GE84_NS</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1</td><td>ZZ_RX_MCRX_GE84_RE</td><td>_POSDW_TLOGF_X</td><td>ZZ_RX_MCRX_GE84_RE</td><td>Direct mapping</td></tr>
</table>

<!-- 5. COMPLEXITY ANALYSIS -->
<p><b>Complexity Analysis</b></p>
<table style="width:100%; border-collapse:collapse;">
  <tr style="background:#e3e6f2;">
    <th>Category</th>
    <th>Measurement</th>
  </tr>
  <tr><td>Number of Objects/Nodes</td><td>2 (Data Source, Projection Node)</td></tr>
  <tr><td>Sources Used</td><td>1 (Database Table: /POSDW/TLOGF_X)</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None identified</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>Attribute-level filters on three fields</td></tr>
  <tr><td>Workflow Complexity</td><td>Simple linear flow: source → projection → output</td></tr>
  <tr><td>Performance Considerations</td><td>Attribute-level filters may improve efficiency by reducing output data volume</td></tr>
  <tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single dependency on database table /POSDW/TLOGF_X</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. SENSITIVE AND PRIVACY DATA ASSESSMENT -->
<p><b>Sensitive and Privacy Data Assessment</b></p>
No sensitive data found

<!-- 7. KEY OUTPUTS -->
<p><b>Key Outputs</b></p>
<ul>
  <li>MANDT</li>
  <li>RETAILSTOREID</li>
  <li>BUSINESSDAYDATE</li>
  <li>RECORDQUALIFIER</li>
  <li>WORKSTATIONID</li>
  <li>ARCHIVED</li>
  <li>ZZ_UPD_TIMESTAMP</li>
  <li>ZZ_CUSTTYPE</li>
  <li>ZZ_RX_CNT_NS</li>
  <li>ZZ_RX_CNT_REFILL</li>
  <li>ZZ_RX_CNT_GE84_NS</li>
  <li>ZZ_RX_CNT_GE84_RE</li>
  <li>ZZ_RX_MCRX_GE84_NS</li>
  <li>ZZ_RX_MCRX_GE84_RE</li>
</ul>

<!-- 8. API COST CALCULATIONS -->
<p><b>API COST : 0.0000 USD</b></p>
