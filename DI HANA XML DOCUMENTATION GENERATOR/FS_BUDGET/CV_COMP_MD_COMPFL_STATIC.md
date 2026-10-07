<!-- DOCUMENT HEADER -->
<table style="width:100%;border-collapse:collapse;margin-bottom:20px;">
  <tr>
    <td style="width:25%;font-weight:bold;">Author:</td>
    <td>Ascendion AAVA</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Created On:</td>
    <td>2026-10-07</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Description:</td>
    <td>Technical documentation for Calculation View <b>CV_COMP_MD_COMPFL_STATIC</b>. This view acts as a wrapper on the snapshot table for Store Profile - Comp Flag, exposing dimensional attributes and comp flag indicators as defined in the underlying data source.</td>
  </tr>
</table>

<!-- 1. Overview of Program -->
<p><b>Overview of Program:</b><br>
This HANA XML file defines a Calculation View of type <b>DIMENSION</b> named <b>CV_COMP_MD_COMPFL_STATIC</b>. The view serves as a wrapper over the snapshot table <b>TBL_WSS_SRP_COMPFLAG</b>, projecting key store profile and comp flag fields for further consumption. The main processing involves direct projection of fields from the source without additional transformation or aggregation.</p>

<!-- 2. Code Structure and Design -->
<p>
<b>Structure:</b> The Calculation View is structured with a single Projection node (<b>Projection_1</b>) that maps fields directly from the CDS artifact data source <b>TBL_WSS_SRP_COMPFLAG</b>. The logical model defines 13 attributes corresponding to the projected fields, each mapped one-to-one from the source table. No calculated attributes, joins, aggregations, filters, or unions are present. <br>
<b>Key Components:</b> The major components are the data source (<b>TBL_WSS_SRP_COMPFLAG</b>), the Projection node (<b>Projection_1</b>), and the logical model attributes. The Projection node selects and maps all relevant fields from the source table. <br>
<b>Dependencies & Performance:</b> The view depends solely on the CDS artifact <b>CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</b>. No joins, aggregations, or calculated expressions are used, indicating minimal processing complexity and direct data access. No explicit performance optimizations or data-volume handling logic are present in the XML.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;padding:10px;background:#f9f9f9;border-radius:8px;">
  <div style="display:grid;grid-template-columns:repeat(3,200px);grid-template-rows:repeat(2,100px);gap:40px;align-items:center;justify-items:center;width:700px;">
    <div style="grid-column:2;grid-row:1;background:#e3eafc;border:1px solid #b6c8ee;border-radius:8px;padding:20px;text-align:center;font-weight:bold;">Data Source<br>TBL_WSS_SRP_COMPFLAG</div>
    <div style="grid-column:2;grid-row:2;background:#d1f2e3;border:1px solid #a7e4c1;border-radius:8px;padding:20px;text-align:center;font-weight:bold;">Projection Node<br>Projection_1</div>
    <div style="grid-column:3;grid-row:2;background:#fff4d6;border:1px solid #ffe0a3;border-radius:8px;padding:20px;text-align:center;font-weight:bold;">Output<br>View Attributes</div>
    <svg style="grid-column:2;grid-row:1/2;z-index:10;width:0;height:0;position:absolute;">
      <defs>
        <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
          <polygon points="0 0, 10 3.5, 0 7" fill="#a7e4c1"/>
        </marker>
      </defs>
      <line x1="100" y1="100" x2="100" y2="200" stroke="#a7e4c1" stroke-width="3" marker-end="url(#arrowhead)"/>
    </svg>
    <div style="position:absolute;left:320px;top:220px;width:80px;height:0;border-top:3px solid #ffe0a3;"></div>
    <div style="position:absolute;left:400px;top:220px;width:0;height:0;border-left:3px solid #ffe0a3;"></div>
  </div>
  <div style="position:relative;width:700px;height:250px;"></div>
  <svg width="700" height="250" style="position:absolute;top:0;left:0;pointer-events:none;">
    <defs>
      <marker id="arrowhead2" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
        <polygon points="0 0, 10 3.5, 0 7" fill="#ffe0a3"/>
      </marker>
    </defs>
    <line x1="320" y1="170" x2="520" y2="170" stroke="#ffe0a3" stroke-width="3" marker-end="url(#arrowhead2)"/>
  </svg>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%;border-collapse:collapse;margin-top:20px;">
  <thead>
    <tr style="background:#e3eafc;">
      <th>Target Object/Field Name</th>
      <th>Target Column Name</th>
      <th>Source Object/Field Name</th>
      <th>Source Column Name</th>
      <th>Remarks</th>
    </tr>
  </thead>
  <tbody>
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
  </tbody>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%;border-collapse:collapse;margin-top:20px;">
  <thead>
    <tr style="background:#e3eafc;">
      <th>Category</th>
      <th>Measurement</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>Number of Objects/Nodes</td><td>2 (Data Source, Projection Node)</td></tr>
    <tr><td>Sources Used</td><td>TBL_WSS_SRP_COMPFLAG (CDS Artifact)</td></tr>
    <tr><td>Joins</td><td>None</td></tr>
    <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
    <tr><td>Aggregate Functions</td><td>None</td></tr>
    <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
    <tr><td>Conditional Logic</td><td>None</td></tr>
    <tr><td>Workflow Complexity</td><td>Very low; single projection node with direct mapping</td></tr>
    <tr><td>Performance Considerations</td><td>Direct access to source; minimal processing</td></tr>
    <tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
    <tr><td>Dependency Complexity</td><td>Single dependency on CDS Artifact</td></tr>
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
