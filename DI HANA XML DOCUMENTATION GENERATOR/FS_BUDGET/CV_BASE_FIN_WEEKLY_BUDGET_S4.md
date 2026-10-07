<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse;">
  <tr><td style="font-weight:bold;">Author:</td><td>Ascendion AAVA</td></tr>
  <tr><td style="font-weight:bold;">Created On:</td><td>2026-10-07</td></tr>
  <tr><td style="font-weight:bold;">Description:</td><td>Base Calculation View for Store Reporting Financials Budget frozen DSO - DS05 (Weekly Snapshot). Provides a unioned output of budget data from frozen and live cubes based on input parameters and restricted measures.</td></tr>
</table>

<!-- 1. Overview of Program -->
<p>This HANA XML object is a Calculation View of type CUBE, designed for aggregation and reporting. Its primary function is to combine weekly budget snapshot data from frozen and live sources, applying conditional logic based on input parameters. The view uses union, projection, and restricted measures to generate a consolidated financial output.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The object is structured as a tree-based Calculation View with three main nodes: two Projection Views (Frozen_Cube and Live_Cube) and one Union View (Union_1). The Projections source data from two database tables, apply attribute mappings, and filter data based on the MANDT column and a parameter-driven condition. The Union node merges both projections, assigning a constant FLAG to indicate the source type. The logical model defines attributes, measures, calculated measures, and restricted measures for output aggregation.<br>
<b>Key Components:</b> Major components include input parameters (IP_VERSION, IP_FC_COUNT), two data sources (AZSRP_DS052_VT_S4 and AZSRP_DS041_VT_S4), projections (Frozen_Cube, Live_Cube), a union node (Union_1), calculated and restricted measures, and output attributes. Parameters control cube selection, and restricted measures filter data based on the FLAG.<br>
<b>Dependencies & Performance:</b> The view depends on two database tables and a scalar function for parameter derivation. Performance is affected by filters, union operations, and aggregation logic. No joins or complex nested processing are present, and the view is read-only with aggregation and conditional filtering.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="width:100%; overflow-x:auto; background:#f7f7fa; padding:18px; border-radius:8px;">
  <div style="display:grid; grid-template-columns:repeat(5, 180px); grid-template-rows:repeat(4, 80px); gap:30px; align-items:center;">
    <!-- Data Sources -->
    <div style="grid-column:1; grid-row:1; background:#e4eaf6; border-radius:8px; box-shadow:0 2px 6px #ccc; text-align:center; padding:16px;">AZSRP_DS052_VT_S4<br/><span style="font-size:12px;">(Data Source)</span></div>
    <div style="grid-column:5; grid-row:1; background:#e4eaf6; border-radius:8px; box-shadow:0 2px 6px #ccc; text-align:center; padding:16px;">AZSRP_DS041_VT_S4<br/><span style="font-size:12px;">(Data Source)</span></div>
    <!-- Projections -->
    <div style="grid-column:1; grid-row:2; background:#d6f5e6; border-radius:8px; box-shadow:0 2px 6px #ccc; text-align:center; padding:16px;">Frozen_Cube<br/><span style="font-size:12px;">(Projection)</span></div>
    <div style="grid-column:5; grid-row:2; background:#d6f5e6; border-radius:8px; box-shadow:0 2px 6px #ccc; text-align:center; padding:16px;">Live_Cube<br/><span style="font-size:12px;">(Projection)</span></div>
    <!-- Union -->
    <div style="grid-column:3; grid-row:3; background:#ffe4b2; border-radius:8px; box-shadow:0 2px 6px #ccc; text-align:center; padding:16px;">Union_1<br/><span style="font-size:12px;">(Union)</span></div>
    <!-- Output -->
    <div style="grid-column:3; grid-row:4; background:#b6e0f6; border-radius:8px; box-shadow:0 2px 6px #ccc; text-align:center; padding:16px;">Output<br/><span style="font-size:12px;">(Logical Model)</span></div>
    <!-- Arrows -->
    <svg style="grid-column:1; grid-row:1/2; z-index:1; position:relative; left:90px; top:25px;" width="40" height="80">
      <defs><marker id="arrow1" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto" markerUnits="strokeWidth"><path d="M0,0 L10,5 L0,10" fill="#555"/></marker></defs>
      <line x1="0" y1="0" x2="0" y2="80" stroke="#555" stroke-width="2" marker-end="url(#arrow1)" />
    </svg>
    <svg style="grid-column:5; grid-row:1/2; z-index:1; position:relative; left:-90px; top:25px;" width="40" height="80">
      <line x1="40" y1="0" x2="40" y2="80" stroke="#555" stroke-width="2" marker-end="url(#arrow1)" />
    </svg>
    <svg style="grid-column:1; grid-row:2/3; z-index:1; position:relative; left:90px; top:25px;" width="220" height="80">
      <line x1="0" y1="80" x2="220" y2="80" stroke="#555" stroke-width="2" marker-end="url(#arrow1)" />
    </svg>
    <svg style="grid-column:5; grid-row:2/3; z-index:1; position:relative; left:-90px; top:25px;" width="-220" height="80">
      <line x1="220" y1="80" x2="0" y2="80" stroke="#555" stroke-width="2" marker-end="url(#arrow1)" />
    </svg>
    <svg style="grid-column:3; grid-row:3/4; z-index:1; position:relative; left:0px; top:25px;" width="40" height="80">
      <line x1="20" y1="0" x2="20" y2="80" stroke="#555" stroke-width="2" marker-end="url(#arrow1)" />
    </svg>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%; border-collapse:collapse;">
  <tr style="background:#e9ecef;">
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr><td>Frozen_Cube</td><td>FISCPER</td><td>AZSRP_DS052_VT_S4</td><td>FISCPER</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>FISCVARNT</td><td>AZSRP_DS052_VT_S4</td><td>FISCVARNT</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>_BIC_ZIO_SWEEK</td><td>AZSRP_DS052_VT_S4</td><td>_BIC_ZIO_SWEEK</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>FISCYEAR</td><td>AZSRP_DS052_VT_S4</td><td>FISCYEAR</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>FISCPER3</td><td>AZSRP_DS052_VT_S4</td><td>FISCPER3</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>_B631_S_CHRTACCT</td><td>AZSRP_DS052_VT_S4</td><td>_B631_S_CHRTACCT</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>_B631_S_GL_ACCT</td><td>AZSRP_DS052_VT_S4</td><td>_B631_S_GL_ACCT</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>_B631_S_CO_AREA</td><td>AZSRP_DS052_VT_S4</td><td>_B631_S_CO_AREA</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>_BIC_ZIO_CMPCD</td><td>AZSRP_DS052_VT_S4</td><td>_BIC_ZIO_CMPCD</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>_B631_S_PROFTCTR</td><td>AZSRP_DS052_VT_S4</td><td>_B631_S_PROFTCTR</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>_B631_S_COSTCNTR</td><td>AZSRP_DS052_VT_S4</td><td>_B631_S_COSTCNTR</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>_B631_S_FUNCAREA</td><td>AZSRP_DS052_VT_S4</td><td>_B631_S_FUNCAREA</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>_BIC_ZIO_VER</td><td>AZSRP_DS052_VT_S4</td><td>_BIC_ZIO_VER</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>_BIC_ZIO_SAUDT</td><td>AZSRP_DS052_VT_S4</td><td>_BIC_ZIO_SAUDT</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>MANDT</td><td>AZSRP_DS052_VT_S4</td><td>MANDT</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>_BIC_ZWWPC_PA1</td><td>AZSRP_DS052_VT_S4</td><td>_BIC_ZWWPC_PA1</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>_BIC_ZWWSC_PA1</td><td>AZSRP_DS052_VT_S4</td><td>_BIC_ZWWSC_PA1</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>RECORDMODE</td><td>AZSRP_DS052_VT_S4</td><td>RECORDMODE</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>CURRENCY</td><td>AZSRP_DS052_VT_S4</td><td>CURRENCY</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>_B631_S_AMOUNT</td><td>AZSRP_DS052_VT_S4</td><td>_B631_S_AMOUNT</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>_BIC_ZIO_AMT</td><td>AZSRP_DS052_VT_S4</td><td>_BIC_ZIO_AMT</td><td>Direct mapping</td></tr>
  <tr><td>Frozen_Cube</td><td>FLAG</td><td>Union_1</td><td>FLAG</td><td>Constant value 'FC' assigned in union</td></tr>
  <tr><td>Live_Cube</td><td>FISCPER</td><td>AZSRP_DS041_VT_S4</td><td>FISCPER</td><td>Direct mapping</td></tr>
  <tr><td>Live_Cube</td><td>FISCVARNT</td><td>AZSRP_DS041_VT_S4</td><td>FISCVARNT</td><td>Direct mapping</td></tr>
  <tr><td>Live_Cube</td><td>_BIC_ZIO_SWEEK</td><td>AZSRP_DS041_VT_S4</td><td>_BIC_ZIO_SWEEK</td><td>Direct mapping</td></tr>
  <tr><td>Live_Cube</td><td>FISCYEAR</td><td>AZSRP_DS041_VT_S4</td><td>FISCYEAR</td><td>Direct mapping</td></tr>
  <tr><td>Live_Cube</td><td>FISCPER3</td><td>AZSRP_DS041_VT_S4</td><td>FISCPER3</td><td>Direct mapping</td></tr>
  <tr><td>Live_Cube</td><td>_B631_S_CHRTACCT</td><td>AZSRP_DS041_VT_S4</td><td>_B631_S_CHRTACCT</td><td>Direct mapping</td></tr>
  <tr><td>Live_Cube</td><td>_B631_S_GL_ACCT</td><td>AZSRP_DS041_VT_S4</td><td>_B631_S_GL_ACCT</td><td>Direct mapping</td></tr>
  <tr><td>Live_Cube</td><td>_B631_S_CO_AREA</td><td>AZSRP_DS041_VT_S4</td><td>_B631_S_CO_AREA</td><td>Direct mapping</td></tr>
  <tr><td>Live_Cube</td><td>_BIC_ZIO_CMPCD</td><td>AZSRP_DS041_VT_S4</td><td>_BIC_ZIO_CMPCD</td><td>Direct mapping</td></tr>
  <tr><td>Live_Cube</td><td>_B631_S_PROFTCTR</td><td>AZSRP_DS041_VT_S4</td><td>_BIC_ZIO_PCTR</td><td>Mapping from differently named source field</td></tr>
  <tr><td>Live_Cube</td><td>_B631_S_COSTCNTR</td><td>AZSRP_DS041_VT_S4</td><td>_BIC_ZIO_CCTR</td><td>Mapping from differently named source field</td></tr>
  <tr><td>Live_Cube</td><td>_B631_S_FUNCAREA</td><td>AZSRP_DS041_VT_S4</td><td>_B631_S_FUNCAREA</td><td>Direct mapping</td></tr>
  <tr><td>Live_Cube</td><td>_BIC_ZIO_VER</td><td>AZSRP_DS041_VT_S4</td><td>_BIC_ZIO_VER</td><td>Direct mapping</td></tr>
  <tr><td>Live_Cube</td><td>_BIC_ZIO_SAUDT</td><td>AZSRP_DS041_VT_S4</td><td>_BIC_ZIO_SAUDT</td><td>Direct mapping</td></tr>
  <tr><td>Live_Cube</td><td>MANDT</td><td>AZSRP_DS041_VT_S4</td><td>MANDT</td><td>Direct mapping</td></tr>
  <tr><td>Live_Cube</td><td>_BIC_ZWWPC_PA1</td><td>AZSRP_DS041_VT_S4</td><td>_BIC_ZWWPC_PA1</td><td>Direct mapping</td></tr>
  <tr><td>Live_Cube</td><td>_BIC_ZWWSC_PA1</td><td>AZSRP_DS041_VT_S4</td><td>_BIC_ZWWSC_PA1</td><td>Direct mapping</td></tr>
  <tr><td>Live_Cube</td><td>RECORDMODE</td><td>AZSRP_DS041_VT_S4</td><td>RECORDMODE</td><td>Direct mapping</td></tr>
  <tr><td>Live_Cube</td><td>CURRENCY</td><td>AZSRP_DS041_VT_S4</td><td>CURRENCY</td><td>Direct mapping</td></tr>
  <tr><td>Live_Cube</td><td>_B631_S_AMOUNT</td><td>AZSRP_DS041_VT_S4</td><td>_B631_S_AMOUNT</td><td>Direct mapping</td></tr>
  <tr><td>Live_Cube</td><td>_BIC_ZIO_AMT</td><td>AZSRP_DS041_VT_S4</td><td>_BIC_ZIO_AMT</td><td>Direct mapping</td></tr>
  <tr><td>Live_Cube</td><td>FLAG</td><td>Union_1</td><td>FLAG</td><td>Constant value 'LC' assigned in union</td></tr>
  <tr><td>Union_1</td><td>FISCPER</td><td>Frozen_Cube/Live_Cube</td><td>FISCPER</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>FISCVARNT</td><td>Frozen_Cube/Live_Cube</td><td>FISCVARNT</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>_BIC_ZIO_SWEEK</td><td>Frozen_Cube/Live_Cube</td><td>_BIC_ZIO_SWEEK</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>FISCYEAR</td><td>Frozen_Cube/Live_Cube</td><td>FISCYEAR</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>FISCPER3</td><td>Frozen_Cube/Live_Cube</td><td>FISCPER3</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>_B631_S_CHRTACCT</td><td>Frozen_Cube/Live_Cube</td><td>_B631_S_CHRTACCT</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>_B631_S_GL_ACCT</td><td>Frozen_Cube/Live_Cube</td><td>_B631_S_GL_ACCT</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>_B631_S_CO_AREA</td><td>Frozen_Cube/Live_Cube</td><td>_B631_S_CO_AREA</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>_BIC_ZIO_CMPCD</td><td>Frozen_Cube/Live_Cube</td><td>_BIC_ZIO_CMPCD</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>_B631_S_PROFTCTR</td><td>Frozen_Cube/Live_Cube</td><td>_B631_S_PROFTCTR</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>_B631_S_COSTCNTR</td><td>Frozen_Cube/Live_Cube</td><td>_B631_S_COSTCNTR</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>_B631_S_FUNCAREA</td><td>Frozen_Cube/Live_Cube</td><td>_B631_S_FUNCAREA</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>_BIC_ZIO_VER</td><td>Frozen_Cube/Live_Cube</td><td>_BIC_ZIO_VER</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>_BIC_ZIO_SAUDT</td><td>Frozen_Cube/Live_Cube</td><td>_BIC_ZIO_SAUDT</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>MANDT</td><td>Frozen_Cube/Live_Cube</td><td>MANDT</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>_BIC_ZWWPC_PA1</td><td>Frozen_Cube/Live_Cube</td><td>_BIC_ZWWPC_PA1</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>_BIC_ZWWSC_PA1</td><td>Frozen_Cube/Live_Cube</td><td>_BIC_ZWWSC_PA1</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>RECORDMODE</td><td>Frozen_Cube/Live_Cube</td><td>RECORDMODE</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>CURRENCY</td><td>Frozen_Cube/Live_Cube</td><td>CURRENCY</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>_B631_S_AMOUNT</td><td>Frozen_Cube/Live_Cube</td><td>_B631_S_AMOUNT</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>_BIC_ZIO_AMT</td><td>Frozen_Cube/Live_Cube</td><td>_BIC_ZIO_AMT</td><td>Union mapping</td></tr>
  <tr><td>Union_1</td><td>FLAG</td><td>Frozen_Cube/Live_Cube</td><td>FLAG</td><td>Union mapping; Constant value 'FC' or 'LC' assigned</td></tr>
  <tr><td>Logical Model</td><td>_B631_S_AMOUNT</td><td>Union_1</td><td>_B631_S_AMOUNT</td><td>Calculated measure: IF(isnull("RES_AMOUNT_FC"), "RES_AMOUNT_LC", "RES_AMOUNT_FC")</td></tr>
  <tr><td>Logical Model</td><td>RES_AMOUNT_LC</td><td>Union_1</td><td>_B631_S_AMOUNT</td><td>Restricted measure where FLAG = 'LC'</td></tr>
  <tr><td>Logical Model</td><td>RES_AMOUNT_FC</td><td>Union_1</td><td>_B631_S_AMOUNT</td><td>Restricted measure where FLAG = 'FC'</td></tr>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%; border-collapse:collapse;">
  <tr style="background:#e9ecef;"><th>Category</th><th>Measurement</th></tr>
  <tr><td>Number of Objects/Nodes</td><td>3 Calculation Views (Frozen_Cube, Live_Cube, Union_1), 2 Data Sources</td></tr>
  <tr><td>Sources Used</td><td>AZSRP_DS052_VT_S4, AZSRP_DS041_VT_S4</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>SUM aggregation on measures</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>IF expression for calculated measure; filter logic on input parameters</td></tr>
  <tr><td>Workflow Complexity</td><td>Moderate; union of two projections with parameter-driven filtering and calculated measures</td></tr>
  <tr><td>Performance Considerations</td><td>Filters, aggregations, and union operations; dependent on underlying data sources and parameter values</td></tr>
  <tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Depends on two database tables and a scalar function for parameter derivation</td></tr>
  <tr><td>Overall Complexity Score</td><td>Medium</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>FISCPER</li>
  <li>FISCVARNT</li>
  <li>_BIC_ZIO_SWEEK</li>
  <li>FISCYEAR</li>
  <li>FISCPER3</li>
  <li>_B631_S_CHRTACCT</li>
  <li>_B631_S_GL_ACCT</li>
  <li>_B631_S_CO_AREA</li>
  <li>_BIC_ZIO_CMPCD</li>
  <li>_B631_S_PROFTCTR</li>
  <li>_B631_S_COSTCNTR</li>
  <li>_B631_S_FUNCAREA</li>
  <li>_BIC_ZIO_VER</li>
  <li>_BIC_ZIO_SAUDT</li>
  <li>MANDT</li>
  <li>_BIC_ZWWPC_PA1</li>
  <li>_BIC_ZWWSC_PA1</li>
  <li>RECORDMODE</li>
  <li>CURRENCY</li>
  <li>_B631_S_AMOUNT</li>
  <li>_BIC_ZIO_AMT</li>
  <li>FLAG</li>
  <li>RES_AMOUNT_LC (restricted measure)</li>
  <li>RES_AMOUNT_FC (restricted measure)</li>
  <li>_B631_S_AMOUNT (calculated measure)</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
