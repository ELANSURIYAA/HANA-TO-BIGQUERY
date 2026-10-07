<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc; padding-bottom:8px; margin-bottom:16px;">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> {{DATE_PLACEHOLDER}}<br>
  <b>Description:</b> Base View for Transaction Log Extensions table. This HANA Calculation View is designed to provide a dimensional projection of transaction log extension data, incorporating attribute-level filtering and field selection as defined in the XML.
</div>

<!-- 1. Overview of Program -->
<div style="margin-bottom:16px;">
  <b>Overview of Program:</b><br>
  This object is a HANA Calculation View of type TREE_BASED with data category DIMENSION. Its primary purpose is to project selected fields from a transaction log extensions base table, applying attribute-level filters to restrict and refine the output. The view is designed for internal visibility and does not perform aggregation or complex modeling beyond projection and filtering.
</div>

<!-- 2. Code Structure and Design -->
<div style="margin-bottom:16px;">
  <b>Structure:</b> The Calculation View consists of a single Projection node (Projection_1) which sources data from a base table (_POSDW_TLOGF_X). The node selects a set of attributes and applies filters to specific fields. No calculated fields, joins, unions, or aggregations are defined in the XML.
  <br><b>Key Components:</b> The main components are the Projection node (Projection_1), the base table data source (_POSDW_TLOGF_X), selected attributes, and attribute-level filters applied to RECORDQUALIFIER, WORKSTATIONID, and ZZ_UPD_TIMESTAMP. The logical model defines the output attributes corresponding to the projection.
  <br><b>Dependencies & Performance:</b> The Calculation View depends on the referenced base table /POSDW/TLOGF_X in schema SAPABAP1. No joins or aggregations are present, minimizing performance overhead. Attribute-level filters may reduce data volume, but no explicit data-volume handling or complex dependency logic is defined.
</div>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; background:#f9f9f9; padding:16px; border-radius:8px;">
  <style>
    .workflow-grid {
      display: grid;
      grid-template-columns: 180px 40px 180px 40px 180px;
      grid-template-rows: 80px 80px 80px;
      align-items: center;
      justify-items: center;
      gap: 0px 0px;
    }
    .workflow-box {
      background: #fff;
      border: 1px solid #d1d1d1;
      border-radius: 8px;
      padding: 16px;
      font-size: 14px;
      box-shadow: 0 1px 4px rgba(0,0,0,0.06);
      min-width: 160px;
      text-align: center;
    }
    .workflow-arrow {
      font-size: 32px;
      color: #888;
      text-align: center;
      user-select: none;
    }
  </style>
  <div class="workflow-grid">
    <div class="workflow-box" style="grid-column:1; grid-row:2;">Data Source:<br>_POSDW_TLOGF_X<br>(/POSDW/TLOGF_X)</div>
    <div class="workflow-arrow" style="grid-column:2; grid-row:2;">&#8594;</div>
    <div class="workflow-box" style="grid-column:3; grid-row:2;">Projection Node:<br>Projection_1<br><span style="font-size:12px; color:#555;">Attribute Selection<br>+ Filters</span></div>
    <div class="workflow-arrow" style="grid-column:4; grid-row:2;">&#8594;</div>
    <div class="workflow-box" style="grid-column:5; grid-row:2;">Output<br>Attributes</div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellspacing="0" cellpadding="6" style="border-collapse:collapse; width:100%; margin-bottom:16px;">
  <tr style="background:#eaeaea;">
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr><td>Projection_1.MANDT</td><td>MANDT</td><td>_POSDW_TLOGF_X.MANDT</td><td>MANDT</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.RETAILSTOREID</td><td>RETAILSTOREID</td><td>_POSDW_TLOGF_X.RETAILSTOREID</td><td>RETAILSTOREID</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.BUSINESSDAYDATE</td><td>BUSINESSDAYDATE</td><td>_POSDW_TLOGF_X.BUSINESSDAYDATE</td><td>BUSINESSDAYDATE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.RECORDQUALIFIER</td><td>RECORDQUALIFIER</td><td>_POSDW_TLOGF_X.RECORDQUALIFIER</td><td>RECORDQUALIFIER</td><td>Filter: including value '25'</td></tr>
  <tr><td>Projection_1.WORKSTATIONID</td><td>WORKSTATIONID</td><td>_POSDW_TLOGF_X.WORKSTATIONID</td><td>WORKSTATIONID</td><td>Filter: excluding value '0000000000'</td></tr>
  <tr><td>Projection_1.ARCHIVED</td><td>ARCHIVED</td><td>_POSDW_TLOGF_X.ARCHIVED</td><td>ARCHIVED</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZZ_UPD_TIMESTAMP</td><td>ZZ_UPD_TIMESTAMP</td><td>_POSDW_TLOGF_X.ZZ_UPD_TIMESTAMP</td><td>ZZ_UPD_TIMESTAMP</td><td>Filter: excluding value '0'</td></tr>
  <tr><td>Projection_1.ZZ_CUSTTYPE</td><td>ZZ_CUSTTYPE</td><td>_POSDW_TLOGF_X.ZZ_CUSTTYPE</td><td>ZZ_CUSTTYPE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZZ_RX_CNT_NS</td><td>ZZ_RX_CNT_NS</td><td>_POSDW_TLOGF_X.ZZ_RX_CNT_NS</td><td>ZZ_RX_CNT_NS</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZZ_RX_CNT_REFILL</td><td>ZZ_RX_CNT_REFILL</td><td>_POSDW_TLOGF_X.ZZ_RX_CNT_REFILL</td><td>ZZ_RX_CNT_REFILL</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZZ_RX_CNT_GE84_NS</td><td>ZZ_RX_CNT_GE84_NS</td><td>_POSDW_TLOGF_X.ZZ_RX_CNT_GE84_NS</td><td>ZZ_RX_CNT_GE84_NS</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZZ_RX_CNT_GE84_RE</td><td>ZZ_RX_CNT_GE84_RE</td><td>_POSDW_TLOGF_X.ZZ_RX_CNT_GE84_RE</td><td>ZZ_RX_CNT_GE84_RE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZZ_RX_MCRX_GE84_NS</td><td>ZZ_RX_MCRX_GE84_NS</td><td>_POSDW_TLOGF_X.ZZ_RX_MCRX_GE84_NS</td><td>ZZ_RX_MCRX_GE84_NS</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZZ_RX_MCRX_GE84_RE</td><td>ZZ_RX_MCRX_GE84_RE</td><td>_POSDW_TLOGF_X.ZZ_RX_MCRX_GE84_RE</td><td>ZZ_RX_MCRX_GE84_RE</td><td>Direct mapping</td></tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellspacing="0" cellpadding="6" style="border-collapse:collapse; width:100%; margin-bottom:16px;">
  <tr style="background:#eaeaea;">
    <th>Category</th>
    <th>Measurement</th>
  </tr>
  <tr><td>Number of Objects/Nodes</td><td>2 (Projection node, Data Source)</td></tr>
  <tr><td>Sources Used</td><td>1 (Base table: /POSDW/TLOGF_X)</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None identified</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>Attribute-level filters (RECORDQUALIFIER, WORKSTATIONID, ZZ_UPD_TIMESTAMP)</td></tr>
  <tr><td>Workflow Complexity</td><td>Simple linear workflow: Data Source → Projection → Output</td></tr>
  <tr><td>Performance Considerations</td><td>Attribute filters may reduce data volume; minimal processing overhead</td></tr>
  <tr><td>Data Volume Handling</td><td>No explicit data-volume handling identified</td></tr>
  <tr><td>Dependency Complexity</td><td>Single dependency (base table /POSDW/TLOGF_X)</td></tr>
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

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
