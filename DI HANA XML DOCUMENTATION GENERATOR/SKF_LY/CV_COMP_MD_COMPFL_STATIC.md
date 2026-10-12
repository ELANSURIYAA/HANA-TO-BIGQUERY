<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse; margin-bottom:20px;">
  <tr><td style="font-weight:bold; width:20%">Author:</td><td>Ascendion AAVA</td></tr>
  <tr><td style="font-weight:bold;">Created On:</td><td>2026-10-12</td></tr>
  <tr><td style="font-weight:bold;">Description:</td><td>Technical documentation for the HANA Calculation View <b>CV_COMP_MD_COMPFL_STATIC</b>, which acts as a wrapper view on a snapshot table for Store Profile - Comp Flag. The view exposes attributes related to store, profit center, comp flag versions, and comp flag indicators at various time granularities. No business logic beyond field projection is present in the XML.</td></tr>
</table>

<!-- 1. Overview of Program -->
<p><b>Overview of Program:</b><br>
This object is a HANA Calculation View of type <b>TREE_BASED</b> with <b>DIMENSION</b> data category. Its primary purpose is to provide a projection of fields from the source table <b>TBL_WSS_SRP_COMPFLAG</b>, serving as a wrapper for store profile comp flag data. The view offers direct mapping of source fields to output attributes without additional processing or transformation.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View consists of a single Projection node (<b>Projection_1</b>) that directly maps fields from the source table <b>TBL_WSS_SRP_COMPFLAG</b>. There are no joins, unions, aggregations, calculated fields, filters, or variable/parameter definitions present. <b>Key Components:</b> The main components are the Projection node, the referenced CDS artifact data source, and the logical model defining output attributes. Each attribute is mapped one-to-one from the source table. <b>Dependencies & Performance:</b> The only dependency is the CDS artifact <b>CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</b>. No performance-impacting processing such as joins, aggregations, or calculated expressions is visible. The view is read-only and projects all fields as defined in the logical model.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; padding:10px; background:#fafbfc; border:1px solid #e1e4e8; border-radius:8px;">
  <div style="display:grid; grid-template-columns:repeat(3, 220px); grid-template-rows:repeat(2, 80px); gap:40px; align-items:center; justify-content:center;">
    <div style="grid-column:1; grid-row:1; background:#e9f5ff; border-radius:8px; box-shadow:0 2px 8px #d0dbe6; text-align:center; padding:18px; font-weight:bold;">DataSource:<br>TBL_WSS_SRP_COMPFLAG<br><span style="font-size:12px; color:#888;">CDS_ARTIFACT</span></div>
    <div style="grid-column:2; grid-row:2; background:#fffbe9; border-radius:8px; box-shadow:0 2px 8px #e6e1d0; text-align:center; padding:18px; font-weight:bold;">Projection Node:<br>Projection_1</div>
    <div style="grid-column:3; grid-row:1; background:#eaffea; border-radius:8px; box-shadow:0 2px 8px #d0e6d0; text-align:center; padding:18px; font-weight:bold;">Output:<br>Logical Model<br><span style="font-size:12px; color:#888;">13 Attributes</span></div>
    <!-- Arrows -->
    <div style="grid-column:1; grid-row:1; grid-column-end:2; grid-row-end:2; justify-self:center; align-self:center;">
      <svg width="90" height="40"><defs><marker id="arrow" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto" markerUnits="strokeWidth"><path d="M0,0 L8,4 L0,8 L2,4 L0,0" fill="#3b82f6"/></marker></defs><line x1="10" y1="20" x2="80" y2="60" stroke="#3b82f6" stroke-width="2" marker-end="url(#arrow)"/></svg>
    </div>
    <div style="grid-column:2; grid-row:2; grid-column-end:3; grid-row-end:1; justify-self:center; align-self:center;">
      <svg width="90" height="40"><defs><marker id="arrow2" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto" markerUnits="strokeWidth"><path d="M0,0 L8,4 L0,8 L2,4 L0,0" fill="#22c55e"/></marker></defs><line x1="10" y1="20" x2="80" y2="-20" stroke="#22c55e" stroke-width="2" marker-end="url(#arrow2)"/></svg>
    </div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%; border-collapse:collapse; margin-top:20px;">
  <tr style="background:#e1e4e8;">
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr><td>Projection_1 / MANDT</td><td>MANDT</td><td>TBL_WSS_SRP_COMPFLAG / MANDT</td><td>MANDT</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1 / PRCTR</td><td>PRCTR</td><td>TBL_WSS_SRP_COMPFLAG / PRCTR</td><td>PRCTR</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1 / STRNUM</td><td>STRNUM</td><td>TBL_WSS_SRP_COMPFLAG / STRNUM</td><td>STRNUM</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1 / COMP_VER</td><td>COMP_VER</td><td>TBL_WSS_SRP_COMPFLAG / COMP_VER</td><td>COMP_VER</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1 / ZWEEK</td><td>ZWEEK</td><td>TBL_WSS_SRP_COMPFLAG / ZWEEK</td><td>ZWEEK</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1 / ZMONTH</td><td>ZMONTH</td><td>TBL_WSS_SRP_COMPFLAG / ZMONTH</td><td>ZMONTH</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1 / ZYEAR</td><td>ZYEAR</td><td>TBL_WSS_SRP_COMPFLAG / ZYEAR</td><td>ZYEAR</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1 / FS_COMP_PRE</td><td>FS_COMP_PRE</td><td>TBL_WSS_SRP_COMPFLAG / FS_COMP_PRE</td><td>FS_COMP_PRE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1 / RX_COMP_PRE</td><td>RX_COMP_PRE</td><td>TBL_WSS_SRP_COMPFLAG / RX_COMP_PRE</td><td>RX_COMP_PRE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1 / FS_COMP_MON</td><td>FS_COMP_MON</td><td>TBL_WSS_SRP_COMPFLAG / FS_COMP_MON</td><td>FS_COMP_MON</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1 / RX_COMP_MON</td><td>RX_COMP_MON</td><td>TBL_WSS_SRP_COMPFLAG / RX_COMP_MON</td><td>RX_COMP_MON</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1 / FS_COMP_WK</td><td>FS_COMP_WK</td><td>TBL_WSS_SRP_COMPFLAG / FS_COMP_WK</td><td>FS_COMP_WK</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1 / RX_COMP_WK</td><td>RX_COMP_WK</td><td>TBL_WSS_SRP_COMPFLAG / RX_COMP_WK</td><td>RX_COMP_WK</td><td>Direct mapping</td></tr>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%; border-collapse:collapse; margin-top:20px;">
  <tr style="background:#e1e4e8;">
    <th>Category</th>
    <th>Measurement</th>
  </tr>
  <tr><td>Number of Objects/Nodes</td><td>2 (Projection node, DataSource)</td></tr>
  <tr><td>Sources Used</td><td>1 (TBL_WSS_SRP_COMPFLAG)</td></tr>
  <tr><td>Joins</td><td>0</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None identified</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>None identified</td></tr>
  <tr><td>Workflow Complexity</td><td>Simple linear projection from source to output</td></tr>
  <tr><td>Performance Considerations</td><td>Minimal processing; direct projection; no joins or aggregations</td></tr>
  <tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single CDS artifact dependency</td></tr>
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
