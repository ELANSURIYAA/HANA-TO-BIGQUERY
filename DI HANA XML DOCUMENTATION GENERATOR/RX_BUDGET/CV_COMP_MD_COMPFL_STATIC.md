<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:8px;margin-bottom:16px;">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> 2024-06-11<br>
  <b>Description:</b> This HANA Calculation View (CV_COMP_MD_COMPFL_STATIC) is a wrapper view on the snapshot table for store profile comp flag, designed to expose dimensional attributes and comp flag fields for further modeling or reporting.
</div>

<!-- 1. Overview of Program -->
<div style="margin-bottom:16px;">
  <b>Overview of Program:</b><br>
  This object is a HANA Calculation View of type DIMENSION. Its primary purpose is to project fields from the source table CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG, making comp flag and store profile attributes available. The view acts as a wrapper, exposing the selected fields without additional transformation or calculation.
</div>

<!-- 2. Code Structure and Design -->
<div style="margin-bottom:16px;">
  <b>Structure:</b> The Calculation View consists of a single Projection node (Projection_1) that directly references a CDS Artifact data source (TBL_WSS_SRP_COMPFLAG). All fields are projected as-is, with no calculated fields, aggregations, joins, or filters present. <b>Key Components:</b> Major components include the Projection_1 node, the data source CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG, and the set of view attributes mapped to output fields. <b>Dependencies & Performance:</b> The only dependency is the referenced table CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG. No joins, aggregations, or complex processing logic are present, indicating minimal performance overhead and direct data exposure.
</div>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;background:#f8f8fa;padding:16px;border-radius:8px;margin-bottom:16px;">
<style>
  .workflow-grid { display: grid; grid-template-columns: 120px 40px 120px; grid-auto-rows: 70px; align-items: center; }
  .workflow-box { background: #e5e9f7; border-radius: 8px; padding: 12px; text-align: center; font-weight: 500; box-shadow: 0 1px 4px #b3b3b3; }
  .arrow { text-align: center; font-size: 22px; color: #8b8b8b; }
</style>
<div class="workflow-grid">
  <div class="workflow-box" style="grid-column:1;grid-row:1;">TBL_WSS_SRP_COMPFLAG<br><span style="font-size:12px;color:#666;">(CDS Artifact)</span></div>
  <div class="arrow" style="grid-column:2;grid-row:1;">→</div>
  <div class="workflow-box" style="grid-column:3;grid-row:1;">Projection_1<br><span style="font-size:12px;color:#666;">(Projection Node)</span></div>
  <div class="arrow" style="grid-column:2;grid-row:2;">→</div>
  <div class="workflow-box" style="grid-column:3;grid-row:2;">Output<br><span style="font-size:12px;color:#666;">(View Fields)</span></div>
</div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;margin-bottom:16px;">
<thead style="background:#e5e9f7;">
<tr>
  <th>Target Object/Field Name</th>
  <th>Target Column Name</th>
  <th>Source Object/Field Name</th>
  <th>Source Column Name</th>
  <th>Remarks</th>
</tr>
</thead>
<tbody>
<tr><td>Projection_1.MANDT</td><td>MANDT</td><td>TBL_WSS_SRP_COMPFLAG</td><td>MANDT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.PRCTR</td><td>PRCTR</td><td>TBL_WSS_SRP_COMPFLAG</td><td>PRCTR</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.STRNUM</td><td>STRNUM</td><td>TBL_WSS_SRP_COMPFLAG</td><td>STRNUM</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.COMP_VER</td><td>COMP_VER</td><td>TBL_WSS_SRP_COMPFLAG</td><td>COMP_VER</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZWEEK</td><td>ZWEEK</td><td>TBL_WSS_SRP_COMPFLAG</td><td>ZWEEK</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZMONTH</td><td>ZMONTH</td><td>TBL_WSS_SRP_COMPFLAG</td><td>ZMONTH</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZYEAR</td><td>ZYEAR</td><td>TBL_WSS_SRP_COMPFLAG</td><td>ZYEAR</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.FS_COMP_PRE</td><td>FS_COMP_PRE</td><td>TBL_WSS_SRP_COMPFLAG</td><td>FS_COMP_PRE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_COMP_PRE</td><td>RX_COMP_PRE</td><td>TBL_WSS_SRP_COMPFLAG</td><td>RX_COMP_PRE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.FS_COMP_MON</td><td>FS_COMP_MON</td><td>TBL_WSS_SRP_COMPFLAG</td><td>FS_COMP_MON</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_COMP_MON</td><td>RX_COMP_MON</td><td>TBL_WSS_SRP_COMPFLAG</td><td>RX_COMP_MON</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.FS_COMP_WK</td><td>FS_COMP_WK</td><td>TBL_WSS_SRP_COMPFLAG</td><td>FS_COMP_WK</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_COMP_WK</td><td>RX_COMP_WK</td><td>TBL_WSS_SRP_COMPFLAG</td><td>RX_COMP_WK</td><td>Direct mapping</td></tr>
</tbody>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;margin-bottom:16px;">
<thead style="background:#e5e9f7;">
<tr><th>Category</th><th>Measurement</th></tr>
</thead>
<tbody>
<tr><td>Number of Objects/Nodes</td><td>2 (Projection_1, DataSource TBL_WSS_SRP_COMPFLAG)</td></tr>
<tr><td>Sources Used</td><td>1 (CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG)</td></tr>
<tr><td>Joins</td><td>0</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>None identified</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>None identified</td></tr>
<tr><td>Workflow Complexity</td><td>Simple linear projection with direct mapping</td></tr>
<tr><td>Performance Considerations</td><td>Minimal overhead; direct data exposure without transformation</td></tr>
<tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
<tr><td>Dependency Complexity</td><td>Single source dependency</td></tr>
<tr><td>Overall Complexity Score</td><td>Low</td></tr>
</tbody>
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
