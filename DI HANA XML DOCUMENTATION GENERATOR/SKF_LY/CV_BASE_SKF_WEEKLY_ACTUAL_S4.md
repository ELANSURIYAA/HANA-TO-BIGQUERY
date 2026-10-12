<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc; margin-bottom:16px; padding-bottom:8px;">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> 2024-06-12<br>
  <b>Description:</b> Base View for Store Reporting SKF Actuals frozen DSO - DS11 (Weekly Snapshot). This HANA Calculation View provides a cube-based aggregation of store reporting data, sourcing from a single database table and projecting relevant fiscal, store, and quantity fields for weekly snapshot analysis.
</div>

<!-- 1. Overview of Program -->
<div style="margin-bottom:16px;">
  <b>Overview of Program:</b><br>
  This object is a HANA Calculation View of type CUBE, designed for reporting and aggregation of store actuals based on weekly snapshots from the frozen DSO DS11. The view projects fields from a single database table and aggregates store quantity measures for various dimensions. Its primary processing involves projecting, filtering, and aggregating data from the source table for reporting purposes.
</div>

<!-- 2. Code Structure and Design -->
<div style="margin-bottom:16px;">
  <b>Structure:</b> The Calculation View consists of a single projection node named <code>Frozen_Cube</code> which sources data from the database table <code>AZSRP_DS112_VT_S4</code> in schema <code>CVS_FRIP</code>. All relevant fields are mapped directly from the source to the projection, with a filter applied on the <code>MANDT</code> field to include only values 110 and 200. The logical model defines attributes and measures, all mapped directly from the projection node.
  <b>Key Components:</b> Major components include the <code>Frozen_Cube</code> projection node, the data source <code>AZSRP_DS112_VT_S4</code>, view attributes (dimensions), and base measures (quantities), with sum aggregation specified for each measure. No calculated attributes or measures are defined, and no joins or unions are present.
  <b>Dependencies & Performance:</b> The Calculation View depends solely on the underlying database table <code>AZSRP_DS112_VT_S4</code> from schema <code>CVS_FRIP</code>. Performance-relevant characteristics include the application of a filter on <code>MANDT</code> and the use of sum aggregation for measures. No complex processing, joins, or nested logic are present, indicating a straightforward and efficient design.
</div>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; background:#f9f9f9; border-radius:8px; padding:16px; margin-bottom:16px;">
  <style>
    .workflow-grid {
      display: grid;
      grid-template-columns: 180px 60px 180px 60px 180px;
      grid-template-rows: 80px 80px;
      gap: 16px;
      align-items: center;
      justify-items: center;
    }
    .workflow-box {
      background: #e3eafc;
      border-radius: 8px;
      box-shadow: 0 2px 6px #d2d8ef;
      padding: 18px 14px;
      font-weight: bold;
      font-size: 15px;
      text-align: center;
      min-width: 140px;
      min-height: 40px;
    }
    .arrow {
      font-size: 30px;
      color: #8a8a8a;
      user-select: none;
    }
  </style>
  <div class="workflow-grid">
    <div class="workflow-box" style="grid-column:1; grid-row:1;">Data Source<br>AZSRP_DS112_VT_S4<br>(CVS_FRIP)</div>
    <div class="arrow" style="grid-column:2; grid-row:1;">&#8594;</div>
    <div class="workflow-box" style="grid-column:3; grid-row:1;">Projection Node<br>Frozen_Cube</div>
    <div class="arrow" style="grid-column:4; grid-row:1;">&#8594;</div>
    <div class="workflow-box" style="grid-column:5; grid-row:1;">Output<br>Aggregated Cube<br>View</div>
    <div style="grid-column:3; grid-row:2;">
      <div class="workflow-box" style="background:#f3e3e3;">Filter<br>MANDT IN (110, 200)</div>
    </div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellspacing="0" cellpadding="6" style="border-collapse:collapse; width:100%; margin-bottom:16px;">
  <tr style="background:#e3eafc;">
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr><td>Frozen_Cube.FISCPER</td><td>FISCPER</td><td>AZSRP_DS112_VT_S4</td><td>FISCPER</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube.FISCVARNT</td><td>FISCVARNT</td><td>AZSRP_DS112_VT_S4</td><td>FISCVARNT</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube.FISCYEAR</td><td>FISCYEAR</td><td>AZSRP_DS112_VT_S4</td><td>FISCYEAR</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube.FISCPER3</td><td>FISCPER3</td><td>AZSRP_DS112_VT_S4</td><td>FISCPER3</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube.MANDT</td><td>MANDT</td><td>AZSRP_DS112_VT_S4</td><td>MANDT</td><td>Filter: IN (110, 200)</td></tr>
  <tr><td>Frozen_Cube.RECORDMODE</td><td>RECORDMODE</td><td>AZSRP_DS112_VT_S4</td><td>RECORDMODE</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube.UNIT</td><td>UNIT</td><td>AZSRP_DS112_VT_S4</td><td>UNIT</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube._BIC_ZIO_SWEEK</td><td>_BIC_ZIO_SWEEK</td><td>AZSRP_DS112_VT_S4</td><td>_BIC_ZIO_SWEEK</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube._BIC_ZIO_PSTY</td><td>_BIC_ZIO_PSTY</td><td>AZSRP_DS112_VT_S4</td><td>_BIC_ZIO_PSTY</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube._BIC_ZIO_PSKF</td><td>_BIC_ZIO_PSKF</td><td>AZSRP_DS112_VT_S4</td><td>_BIC_ZIO_PSKF</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube._B631_S_CO_AREA</td><td>_B631_S_CO_AREA</td><td>AZSRP_DS112_VT_S4</td><td>_B631_S_CO_AREA</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube._BIC_ZIO_CMPCD</td><td>_BIC_ZIO_CMPCD</td><td>AZSRP_DS112_VT_S4</td><td>_BIC_ZIO_CMPCD</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube._B631_S_PROFTCTR</td><td>_B631_S_PROFTCTR</td><td>AZSRP_DS112_VT_S4</td><td>_B631_S_PROFTCTR</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube._B631_S_COSTCNTR</td><td>_B631_S_COSTCNTR</td><td>AZSRP_DS112_VT_S4</td><td>_B631_S_COSTCNTR</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube._B631_S_FUNCAREA</td><td>_B631_S_FUNCAREA</td><td>AZSRP_DS112_VT_S4</td><td>_B631_S_FUNCAREA</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube._BIC_ZIO_VER</td><td>_BIC_ZIO_VER</td><td>AZSRP_DS112_VT_S4</td><td>_BIC_ZIO_VER</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube._BIC_ZIO_SAUDT</td><td>_BIC_ZIO_SAUDT</td><td>AZSRP_DS112_VT_S4</td><td>_BIC_ZIO_SAUDT</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube._BIC_ZIO_SKFQ</td><td>_BIC_ZIO_SKFQ</td><td>AZSRP_DS112_VT_S4</td><td>_BIC_ZIO_SKFQ</td><td>Aggregation: SUM</td></tr>
  <tr><td>Frozen_Cube._BIC_ZIO_D1SKQ</td><td>_BIC_ZIO_D1SKQ</td><td>AZSRP_DS112_VT_S4</td><td>_BIC_ZIO_D1SKQ</td><td>Aggregation: SUM</td></tr>
  <tr><td>Frozen_Cube._BIC_ZIO_D2SKQ</td><td>_BIC_ZIO_D2SKQ</td><td>AZSRP_DS112_VT_S4</td><td>_BIC_ZIO_D2SKQ</td><td>Aggregation: SUM</td></tr>
  <tr><td>Frozen_Cube._BIC_ZIO_D3SKQ</td><td>_BIC_ZIO_D3SKQ</td><td>AZSRP_DS112_VT_S4</td><td>_BIC_ZIO_D3SKQ</td><td>Aggregation: SUM</td></tr>
  <tr><td>Frozen_Cube._BIC_ZIO_D4SKQ</td><td>_BIC_ZIO_D4SKQ</td><td>AZSRP_DS112_VT_S4</td><td>_BIC_ZIO_D4SKQ</td><td>Aggregation: SUM</td></tr>
  <tr><td>Frozen_Cube._BIC_ZIO_D5SKQ</td><td>_BIC_ZIO_D5SKQ</td><td>AZSRP_DS112_VT_S4</td><td>_BIC_ZIO_D5SKQ</td><td>Aggregation: SUM</td></tr>
  <tr><td>Frozen_Cube._BIC_ZIO_D6SKQ</td><td>_BIC_ZIO_D6SKQ</td><td>AZSRP_DS112_VT_S4</td><td>_BIC_ZIO_D6SKQ</td><td>Aggregation: SUM</td></tr>
  <tr><td>Frozen_Cube._BIC_ZIO_D7SKQ</td><td>_BIC_ZIO_D7SKQ</td><td>AZSRP_DS112_VT_S4</td><td>_BIC_ZIO_D7SKQ</td><td>Aggregation: SUM</td></tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellspacing="0" cellpadding="6" style="border-collapse:collapse; width:100%; margin-bottom:16px;">
  <tr style="background:#e3eafc;">
    <th>Category</th>
    <th>Measurement</th>
  </tr>
  <tr><td>Number of Objects/Nodes</td><td>2 (Data Source, Projection Node)</td></tr>
  <tr><td>Sources Used</td><td>1 (AZSRP_DS112_VT_S4)</td></tr>
  <tr><td>Joins</td><td>None</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>SUM (on measures)</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>MANDT filter (IN 110, 200)</td></tr>
  <tr><td>Workflow Complexity</td><td>Low; single projection and aggregation node</td></tr>
  <tr><td>Performance Considerations</td><td>Direct source access, single filter, aggregation</td></tr>
  <tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single source table dependency</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>FISCPER</li>
  <li>FISCVARNT</li>
  <li>FISCYEAR</li>
  <li>FISCPER3</li>
  <li>MANDT</li>
  <li>RECORDMODE</li>
  <li>UNIT</li>
  <li>_BIC_ZIO_SWEEK</li>
  <li>_BIC_ZIO_PSTY</li>
  <li>_BIC_ZIO_PSKF</li>
  <li>_B631_S_CO_AREA</li>
  <li>_BIC_ZIO_CMPCD</li>
  <li>_B631_S_PROFTCTR</li>
  <li>_B631_S_COSTCNTR</li>
  <li>_B631_S_FUNCAREA</li>
  <li>_BIC_ZIO_VER</li>
  <li>_BIC_ZIO_SAUDT</li>
  <li>_BIC_ZIO_SKFQ (SUM)</li>
  <li>_BIC_ZIO_D1SKQ (SUM)</li>
  <li>_BIC_ZIO_D2SKQ (SUM)</li>
  <li>_BIC_ZIO_D3SKQ (SUM)</li>
  <li>_BIC_ZIO_D4SKQ (SUM)</li>
  <li>_BIC_ZIO_D5SKQ (SUM)</li>
  <li>_BIC_ZIO_D6SKQ (SUM)</li>
  <li>_BIC_ZIO_D7SKQ (SUM)</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
