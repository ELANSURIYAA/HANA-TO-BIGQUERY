<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse;">
<tr><td style="width:20%;"><b>Author:</b></td><td>Ascendion AAVA</td></tr>
<tr><td style="width:20%;"><b>Created On:</b></td><td>2026-10-12</td></tr>
<tr><td style="width:20%;"><b>Description:</b></td><td>This HANA XML object defines a Calculation View named <b>CV_COMP_MD_COMPFL_STATIC</b> that acts as a wrapper view on the snapshot table for store profile comp flag data. The view exposes selected fields from the underlying source table and provides a projection for dimensional analysis.</td></tr>
</table>

<!-- 1. Overview of Program -->
<p>This object is a HANA Calculation View of type <b>DIMENSION</b>. Its primary purpose is to project fields from the source table <b>TBL_WSS_SRP_COMPFLAG</b> for store profile comp flag analysis. The view provides a direct mapping of source fields without additional transformations or calculations.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View is structured with a single projection node (<b>Projection_1</b>) that sources its data from the CDS artifact <b>TBL_WSS_SRP_COMPFLAG</b>. All relevant attributes are directly projected from the source without calculated fields or aggregations. <b>Key Components:</b> Major components include the data source (<b>TBL_WSS_SRP_COMPFLAG</b>), the projection node (<b>Projection_1</b>), and the logical model defining output attributes. <b>Dependencies & Performance:</b> The object depends on the CDS artifact <b>CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</b> as its sole source. No joins, aggregations, filters, or calculated expressions are present, indicating minimal processing overhead and direct data access.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; padding:10px; background:#f6f8fa; border-radius:8px;">
  <div style="display:grid; grid-template-columns: 200px 40px 200px; grid-template-rows: 80px 80px; align-items:center; justify-items:center;">
    <div style="grid-column:1; grid-row:1; background:#e3e7ed; border-radius:6px; box-shadow:0 2px 6px #bfc6d2; width:180px; height:60px; display:flex; align-items:center; justify-content:center; font-weight:bold;">DataSource:<br>TBL_WSS_SRP_COMPFLAG</div>
    <div style="grid-column:2; grid-row:1;"> 
      <svg width="40" height="80">
        <defs><marker id="arrow" markerWidth="10" markerHeight="10" refX="5" refY="5" orient="auto" markerUnits="strokeWidth"><path d="M0,0 L10,5 L0,10 L2,5 Z" fill="#6c7a89"/></marker></defs>
        <line x1="0" y1="40" x2="40" y2="40" stroke="#6c7a89" stroke-width="2" marker-end="url(#arrow)" />
      </svg>
    </div>
    <div style="grid-column:3; grid-row:1; background:#e3e7ed; border-radius:6px; box-shadow:0 2px 6px #bfc6d2; width:180px; height:60px; display:flex; align-items:center; justify-content:center; font-weight:bold;">Projection Node:<br>Projection_1</div>
    <div style="grid-column:2; grid-row:2;"> 
      <svg width="40" height="80">
        <defs><marker id="arrow2" markerWidth="10" markerHeight="10" refX="5" refY="5" orient="auto" markerUnits="strokeWidth"><path d="M0,0 L10,5 L0,10 L2,5 Z" fill="#6c7a89"/></marker></defs>
        <line x1="20" y1="0" x2="20" y2="80" stroke="#6c7a89" stroke-width="2" marker-end="url(#arrow2)" />
      </svg>
    </div>
    <div style="grid-column:3; grid-row:2; background:#e3e7ed; border-radius:6px; box-shadow:0 2px 6px #bfc6d2; width:180px; height:60px; display:flex; align-items:center; justify-content:center; font-weight:bold;">Output:<br>View Attributes</div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%; border-collapse:collapse;">
<thead>
<tr style="background:#dde2e6;">
<th>Target Object/Field Name</th>
<th>Target Column Name</th>
<th>Source Object/Field Name</th>
<th>Source Column Name</th>
<th>Remarks</th>
</tr>
</thead>
<tbody>
<tr><td>Projection_1</td><td>MANDT</td><td>TBL_WSS_SRP_COMPFLAG</td><td>MANDT</td><td>Direct mapping</td></tr>
<tr><td>Projection_1</td><td>PRCTR</td><td>TBL_WSS_SRP_COMPFLAG</td><td>PRCTR</td><td>Direct mapping</td></tr>
<tr><td>Projection_1</td><td>STRNUM</td><td>TBL_WSS_SRP_COMPFLAG</td><td>STRNUM</td><td>Direct mapping</td></tr>
<tr><td>Projection_1</td><td>COMP_VER</td><td>TBL_WSS_SRP_COMPFLAG</td><td>COMP_VER</td><td>Direct mapping</td></tr>
<tr><td>Projection_1</td><td>ZWEEK</td><td>TBL_WSS_SRP_COMPFLAG</td><td>ZWEEK</td><td>Direct mapping</td></tr>
<tr><td>Projection_1</td><td>ZMONTH</td><td>TBL_WSS_SRP_COMPFLAG</td><td>ZMONTH</td><td>Direct mapping</td></tr>
<tr><td>Projection_1</td><td>ZYEAR</td><td>TBL_WSS_SRP_COMPFLAG</td><td>ZYEAR</td><td>Direct mapping</td></tr>
<tr><td>Projection_1</td><td>FS_COMP_PRE</td><td>TBL_WSS_SRP_COMPFLAG</td><td>FS_COMP_PRE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1</td><td>RX_COMP_PRE</td><td>TBL_WSS_SRP_COMPFLAG</td><td>RX_COMP_PRE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1</td><td>FS_COMP_MON</td><td>TBL_WSS_SRP_COMPFLAG</td><td>FS_COMP_MON</td><td>Direct mapping</td></tr>
<tr><td>Projection_1</td><td>RX_COMP_MON</td><td>TBL_WSS_SRP_COMPFLAG</td><td>RX_COMP_MON</td><td>Direct mapping</td></tr>
<tr><td>Projection_1</td><td>FS_COMP_WK</td><td>TBL_WSS_SRP_COMPFLAG</td><td>FS_COMP_WK</td><td>Direct mapping</td></tr>
<tr><td>Projection_1</td><td>RX_COMP_WK</td><td>TBL_WSS_SRP_COMPFLAG</td><td>RX_COMP_WK</td><td>Direct mapping</td></tr>
</tbody>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%; border-collapse:collapse;">
<tr><td>Number of Objects/Nodes</td><td>2 (DataSource, Projection Node)</td></tr>
<tr><td>Sources Used</td><td>1 (TBL_WSS_SRP_COMPFLAG)</td></tr>
<tr><td>Joins</td><td>0</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>None identified</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>None identified</td></tr>
<tr><td>Workflow Complexity</td><td>Simple linear structure: source → projection → output</td></tr>
<tr><td>Performance Considerations</td><td>Direct field projection; minimal processing overhead</td></tr>
<tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
<tr><td>Dependency Complexity</td><td>Single CDS artifact dependency</td></tr>
<tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>MANDT (Client)</li>
  <li>PRCTR (Profit Center/Retail Store)</li>
  <li>STRNUM (Store Number)</li>
  <li>COMP_VER (Comp flag version)</li>
  <li>ZWEEK (Week Number)</li>
  <li>ZMONTH (Month)</li>
  <li>ZYEAR (Year)</li>
  <li>FS_COMP_PRE (FS Comp Flag Prelim)</li>
  <li>RX_COMP_PRE (RX Comp Flag Prelim)</li>
  <li>FS_COMP_MON (FS Comp Flag Final Monthly)</li>
  <li>RX_COMP_MON (RX Comp Flag Final Monthly)</li>
  <li>FS_COMP_WK (FS Comp Flag Final Weekly)</li>
  <li>RX_COMP_WK (RX Comp Flag Final Weekly)</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
