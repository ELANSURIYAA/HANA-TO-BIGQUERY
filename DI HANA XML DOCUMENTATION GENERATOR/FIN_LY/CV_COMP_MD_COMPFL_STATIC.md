<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #bbb;padding-bottom:8px;margin-bottom:12px;">
  <b>Author:</b> Ascendion AAVA<br/>
  <b>Created On:</b> {{CURRENT_DATE}}<br/>
  <b>Description:</b> Wrapper Calculation View on snapshot table for Store Profile Comp Flag, providing direct field-level projection of store and comp flag attributes.
</div>

<!-- 1. Overview of Program -->
<div style="margin-bottom:16px;">
  This HANA XML defines a Calculation View named <b>CV_COMP_MD_COMPFL_STATIC</b> of data category <b>DIMENSION</b>. The view acts as a wrapper on the snapshot table <b>TBL_WSS_SRP_COMPFLAG</b>, projecting store profile and comp flag fields without additional transformations. Its primary function is to expose source fields for downstream consumption.
</div>

<!-- 2. Code Structure and Design -->
<div style="margin-bottom:16px;">
  <b>Structure:</b> The Calculation View consists of a single projection node (<b>Projection_1</b>) sourcing from the CDS artifact <b>TBL_WSS_SRP_COMPFLAG</b>. All fields from the source are projected directly, with no joins, aggregations, filters, calculated fields, or variable mappings defined.<br/>
  <b>Key Components:</b> The major components are the data source (<b>TBL_WSS_SRP_COMPFLAG</b>), the projection node (<b>Projection_1</b>), and the logical model mapping each field to the output. No calculated attributes, measures, or hierarchies are present.<br/>
  <b>Dependencies & Performance:</b> The only dependency is the referenced CDS artifact <b>CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</b>. The view is structurally simple, with no joins or complex processing logic, suggesting minimal performance overhead and direct data retrieval from the source.
</div>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;padding:12px 0 12px 0;">
  <style>
    .workflow-grid {
      display: grid;
      grid-template-columns: 180px 60px 180px 60px 180px;
      grid-template-rows: 80px 80px;
      align-items: center;
      justify-items: center;
      gap: 10px;
      min-width: 700px;
      background: #fafcff;
      border-radius: 8px;
      box-shadow: 0 2px 8px #e4e9f2;
      padding: 18px;
    }
    .workflow-box {
      background: #e8f0fe;
      border: 1px solid #bcd6fa;
      border-radius: 8px;
      width: 170px;
      height: 60px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 600;
      font-size: 15px;
      color: #2a3d66;
      box-shadow: 0 1px 3px #b3c6e0;
    }
    .workflow-arrow {
      width: 40px;
      height: 0;
      border-top: 2px solid #8fa2c9;
      position: relative;
    }
    .workflow-arrow:after {
      content: '';
      position: absolute;
      top: -6px;
      right: -10px;
      border-width: 8px;
      border-style: solid;
      border-color: transparent transparent transparent #8fa2c9;
    }
  </style>
  <div class="workflow-grid">
    <div class="workflow-box" style="grid-column:1;grid-row:1;">CDS Artifact<br/>TBL_WSS_SRP_COMPFLAG</div>
    <div class="workflow-arrow" style="grid-column:2;grid-row:1;"></div>
    <div class="workflow-box" style="grid-column:3;grid-row:1;">Projection Node<br/>Projection_1</div>
    <div class="workflow-arrow" style="grid-column:4;grid-row:1;"></div>
    <div class="workflow-box" style="grid-column:5;grid-row:1;">Calculation View<br/>CV_COMP_MD_COMPFL_STATIC</div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;margin-bottom:18px;width:100%;">
  <tr style="background:#e7eaf2;font-weight:600;">
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr><td>Projection_1.MANDT</td><td>MANDT</td><td>TBL_WSS_SRP_COMPFLAG.MANDT</td><td>MANDT</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.PRCTR</td><td>PRCTR</td><td>TBL_WSS_SRP_COMPFLAG.PRCTR</td><td>PRCTR</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.STRNUM</td><td>STRNUM</td><td>TBL_WSS_SRP_COMPFLAG.STRNUM</td><td>STRNUM</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.COMP_VER</td><td>COMP_VER</td><td>TBL_WSS_SRP_COMPFLAG.COMP_VER</td><td>COMP_VER</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZWEEK</td><td>ZWEEK</td><td>TBL_WSS_SRP_COMPFLAG.ZWEEK</td><td>ZWEEK</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZMONTH</td><td>ZMONTH</td><td>TBL_WSS_SRP_COMPFLAG.ZMONTH</td><td>ZMONTH</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZYEAR</td><td>ZYEAR</td><td>TBL_WSS_SRP_COMPFLAG.ZYEAR</td><td>ZYEAR</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.FS_COMP_PRE</td><td>FS_COMP_PRE</td><td>TBL_WSS_SRP_COMPFLAG.FS_COMP_PRE</td><td>FS_COMP_PRE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.RX_COMP_PRE</td><td>RX_COMP_PRE</td><td>TBL_WSS_SRP_COMPFLAG.RX_COMP_PRE</td><td>RX_COMP_PRE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.FS_COMP_MON</td><td>FS_COMP_MON</td><td>TBL_WSS_SRP_COMPFLAG.FS_COMP_MON</td><td>FS_COMP_MON</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.RX_COMP_MON</td><td>RX_COMP_MON</td><td>TBL_WSS_SRP_COMPFLAG.RX_COMP_MON</td><td>RX_COMP_MON</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.FS_COMP_WK</td><td>FS_COMP_WK</td><td>TBL_WSS_SRP_COMPFLAG.FS_COMP_WK</td><td>FS_COMP_WK</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.RX_COMP_WK</td><td>RX_COMP_WK</td><td>TBL_WSS_SRP_COMPFLAG.RX_COMP_WK</td><td>RX_COMP_WK</td><td>Direct mapping</td></tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;margin-bottom:18px;width:100%;">
  <tr style="background:#e7eaf2;font-weight:600;">
    <th>Category</th>
    <th>Measurement</th>
  </tr>
  <tr><td>Number of Objects/Nodes</td><td>2 (Calculation View, Projection Node)</td></tr>
  <tr><td>Sources Used</td><td>1 (TBL_WSS_SRP_COMPFLAG)</td></tr>
  <tr><td>Joins</td><td>None</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>None</td></tr>
  <tr><td>Workflow Complexity</td><td>Simple linear projection from source to output</td></tr>
  <tr><td>Performance Considerations</td><td>Direct field projection; minimal overhead</td></tr>
  <tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single source dependency (CDS artifact)</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>MANDT</li>
  <li>PRCTR</li>
  <li>STRNUM</li>
  <li>COMP_VER</li>
  <li>ZWEEK</li>
  <li>ZMONTH</li>
  <li>ZYEAR</li>
  <li>FS_COMP_PRE</li>
  <li>RX_COMP_PRE</li>
  <li>FS_COMP_MON</li>
  <li>RX_COMP_MON</li>
  <li>FS_COMP_WK</li>
  <li>RX_COMP_WK</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
