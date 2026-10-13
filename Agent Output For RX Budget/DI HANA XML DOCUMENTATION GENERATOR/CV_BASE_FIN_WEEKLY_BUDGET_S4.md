<!-- DOCUMENT HEADER -->
<table style="width:100%;border-collapse:collapse;margin-bottom:16px;">
  <tr><td style="width:25%;font-weight:bold;">Author:</td><td>Ascendion AAVA</td></tr>
  <tr><td style="font-weight:bold;">Created On:</td><td>2026-10-12</td></tr>
  <tr><td style="font-weight:bold;">Description:</td><td>HANA Calculation View 'CV_BASE_FIN_WEEKLY_BUDGET_S4' models weekly financial budget snapshots for store reporting. It consolidates data from two source tables, applies conditional filtering, and outputs aggregated budget and amount measures with versioning and flag indicators.</td></tr>
</table>

<!-- 1. Overview of Program -->
<p>The provided HANA XML defines a Calculation View with dataCategory="CUBE" and calculationScenarioType="TREE_BASED". Its primary purpose is to deliver a unified, aggregated output of weekly financial budget data from both frozen and live data sources, distinguished by versioning and flag logic. The view processes and merges data from two source tables, applies conditional filters, and produces aggregated measures for reporting.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View consists of two main projection nodes ('Frozen_Cube' and 'Live_Cube'), each sourcing data from distinct database tables ('AZSRP_DS052_VT_S4' and 'AZSRP_DS041_VT_S4'). Filters are applied based on client and flag logic, followed by a union node ('Union_1') that consolidates both streams and introduces a constant FLAG field. The logical model defines attributes and measures, including calculated and restricted measures, with final aggregation and formula logic.<br>
<b>Key Components:</b> Major components include local variables (IP_VERSION, IP_FC_COUNT), two data sources, two projection views, a union view, and a logical model with calculated and restricted measures. The IP_FC_COUNT variable is derived using an external scalar function, and the union node merges data streams while assigning FLAG values ('FC' or 'LC').<br>
<b>Dependencies & Performance:</b> The view depends on two database tables and an external scalar function for variable derivation. Performance-relevant features include conditional filters on client and flag, aggregation of measures, and calculated logic for output fields. No joins or complex nested processing are present, but aggregation and filter logic may influence performance.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="width:100%;overflow-x:auto;background:#f9f9f9;padding:16px;border-radius:8px;">
  <div style="display:grid;grid-template-columns:repeat(5,200px);grid-template-rows:repeat(4,80px);align-items:center;justify-items:center;gap:24px;">
    <div style="grid-column:1;grid-row:1;background:#e3eaff;border-radius:6px;padding:12px;text-align:center;font-weight:bold;">AZSRP_DS052_VT_S4<br/><span style="font-size:12px;">Data Source</span></div>
    <div style="grid-column:5;grid-row:1;background:#e3eaff;border-radius:6px;padding:12px;text-align:center;font-weight:bold;">AZSRP_DS041_VT_S4<br/><span style="font-size:12px;">Data Source</span></div>
    <div style="grid-column:1;grid-row:2;background:#d1f7d1;border-radius:6px;padding:12px;text-align:center;font-weight:bold;">Frozen_Cube<br/><span style="font-size:12px;">Projection</span></div>
    <div style="grid-column:5;grid-row:2;background:#d1f7d1;border-radius:6px;padding:12px;text-align:center;font-weight:bold;">Live_Cube<br/><span style="font-size:12px;">Projection</span></div>
    <div style="grid-column:3;grid-row:3;background:#fff3cd;border-radius:6px;padding:12px;text-align:center;font-weight:bold;">Union_1<br/><span style="font-size:12px;">Union</span></div>
    <div style="grid-column:3;grid-row:4;background:#cfe2f3;border-radius:6px;padding:12px;text-align:center;font-weight:bold;">Logical Model<br/><span style="font-size:12px;">Output</span></div>
    <!-- Arrows -->
    <div style="grid-column:1;grid-row:1;justify-self:center;align-self:end;">
      <svg width="2" height="40"><line x1="1" y1="0" x2="1" y2="40" stroke="#888" stroke-width="2"/></svg>
    </div>
    <div style="grid-column:5;grid-row:1;justify-self:center;align-self:end;">
      <svg width="2" height="40"><line x1="1" y1="0" x2="1" y2="40" stroke="#888" stroke-width="2"/></svg>
    </div>
    <div style="grid-column:1;grid-row:2;justify-self:center;align-self:end;">
      <svg width="40" height="2"><line x1="0" y1="1" x2="40" y2="1" stroke="#888" stroke-width="2"/></svg>
    </div>
    <div style="grid-column:5;grid-row:2;justify-self:center;align-self:end;">
      <svg width="-40" height="2"><line x1="40" y1="1" x2="0" y2="1" stroke="#888" stroke-width="2"/></svg>
    </div>
    <div style="grid-column:1;grid-row:2;justify-self:end;align-self:center;">
      <svg width="120" height="2"><line x1="0" y1="1" x2="120" y2="1" stroke="#888" stroke-width="2"/></svg>
    </div>
    <div style="grid-column:5;grid-row:2;justify-self:start;align-self:center;">
      <svg width="-120" height="2"><line x1="120" y1="1" x2="0" y2="1" stroke="#888" stroke-width="2"/></svg>
    </div>
    <div style="grid-column:2;grid-row:2;justify-self:end;align-self:center;">
      <svg width="80" height="80"><polyline points="0,40 80,40 80,80" fill="none" stroke="#888" stroke-width="2"/></svg>
    </div>
    <div style="grid-column:4;grid-row:2;justify-self:start;align-self:center;">
      <svg width="80" height="80"><polyline points="80,40 0,40 0,80" fill="none" stroke="#888" stroke-width="2"/></svg>
    </div>
    <div style="grid-column:3;grid-row:3;justify-self:center;align-self:end;">
      <svg width="2" height="40"><line x1="1" y1="0" x2="1" y2="40" stroke="#888" stroke-width="2"/></svg>
    </div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%;border-collapse:collapse;margin-bottom:16px;">
  <thead>
    <tr style="background:#e3eaff;">
      <th>Target Object/Field Name</th>
      <th>Target Column Name</th>
      <th>Source Object/Field Name</th>
      <th>Source Column Name</th>
      <th>Remarks</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>Frozen_Cube</td><td>_B631_S_PROFTCTR</td><td>AZSRP_DS052_VT_S4</td><td>_B631_S_PROFTCTR</td><td>Direct mapping</td></tr>
    <tr><td>Live_Cube</td><td>_B631_S_PROFTCTR</td><td>AZSRP_DS041_VT_S4</td><td>_BIC_ZIO_PCTR</td><td>Renamed mapping</td></tr>
    <tr><td>Frozen_Cube</td><td>_B631_S_COSTCNTR</td><td>AZSRP_DS052_VT_S4</td><td>_B631_S_COSTCNTR</td><td>Direct mapping</td></tr>
    <tr><td>Live_Cube</td><td>_B631_S_COSTCNTR</td><td>AZSRP_DS041_VT_S4</td><td>_BIC_ZIO_CCTR</td><td>Renamed mapping</td></tr>
    <tr><td>Union_1</td><td>FLAG</td><td>Frozen_Cube</td><td>FLAG</td><td>Constant value 'FC' assigned</td></tr>
    <tr><td>Union_1</td><td>FLAG</td><td>Live_Cube</td><td>FLAG</td><td>Constant value 'LC' assigned</td></tr>
    <tr><td>Logical Model</td><td>RES_AMOUNT_LC</td><td>Union_1</td><td>_B631_S_AMOUNT</td><td>Restricted measure, FLAG = 'LC'</td></tr>
    <tr><td>Logical Model</td><td>RES_AMOUNT_FC</td><td>Union_1</td><td>_B631_S_AMOUNT</td><td>Restricted measure, FLAG = 'FC'</td></tr>
    <tr><td>Logical Model</td><td>_B631_S_AMOUNT</td><td>RES_AMOUNT_LC / RES_AMOUNT_FC</td><td></td><td>Calculated measure: IF(isnull("RES_AMOUNT_FC"), "RES_AMOUNT_LC", "RES_AMOUNT_FC")</td></tr>
    <tr><td>Logical Model</td><td>_BIC_ZIO_AMT</td><td>Union_1</td><td>_BIC_ZIO_AMT</td><td>Aggregated measure (sum)</td></tr>
    <tr><td>Frozen_Cube</td><td>Filter</td><td>AZSRP_DS052_VT_S4</td><td>MANDT, IP_FC_COUNT</td><td>Filter: (in("MANDT", '110', '200')) AND ('$$IP_FC_COUNT$$' != 0)</td></tr>
    <tr><td>Live_Cube</td><td>Filter</td><td>AZSRP_DS041_VT_S4</td><td>MANDT, IP_FC_COUNT</td><td>Filter: (in("MANDT", '110', '200')) AND ('$$IP_FC_COUNT$$' = 0)</td></tr>
    <tr><td>IP_FC_COUNT</td><td></td><td>SFN_FC_FLAG</td><td>IP_VERSION</td><td>Derived by scalar function</td></tr>
  </tbody>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%;border-collapse:collapse;margin-bottom:16px;">
  <tr><td>Number of Objects/Nodes</td><td>5 (2 Projection Views, 1 Union View, 2 Data Sources)</td></tr>
  <tr><td>Sources Used</td><td>AZSRP_DS052_VT_S4, AZSRP_DS041_VT_S4</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>SUM aggregation, restricted and calculated measures</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>Conditional filters, calculated measure using IF and ISNULL</td></tr>
  <tr><td>Workflow Complexity</td><td>Moderate complexity: two parallel projections, union, calculated and restricted measures</td></tr>
  <tr><td>Performance Considerations</td><td>Filter logic, aggregation, and use of scalar function for variable derivation</td></tr>
  <tr><td>Data Volume Handling</td><td>Filtering by client and flag; no explicit volume handling logic</td></tr>
  <tr><td>Dependency Complexity</td><td>Depends on two tables and one external scalar function</td></tr>
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
  <li>FLAG</li>
  <li>_B631_S_AMOUNT (calculated measure)</li>
  <li>_BIC_ZIO_AMT (aggregated measure)</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
