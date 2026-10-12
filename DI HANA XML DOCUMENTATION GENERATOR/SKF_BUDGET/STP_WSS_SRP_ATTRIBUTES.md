<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse; margin-bottom:16px;">
  <tr>
    <td style="font-weight:bold; width:20%;">Author:</td>
    <td>Ascendion AAVA</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Created On:</td>
    <td>2026-10-12</td>
  </tr>
  <tr>
    <td style="font-weight:bold;">Description:</td>
    <td>This documentation describes the HANA SQLScript Procedure <b>CVS_FRIP.CVS_FRIP.Procedure.FI::STP_WSS_SRP_ATTRIBUTES</b>, which manages data loading and transformation from calculation views into target tables. The procedure performs deletion and insertion operations based on source calculation views, with field-level mappings and timestamp/user tracking.</td>
  </tr>
</table>

<!-- 1. Overview of Program -->
<p><b>Overview of Program</b></p>
<p>This HANA object is a SQLScript Procedure. Its primary purpose is to delete and reload data in two target tables by extracting data from calculation views and inserting mapped fields, including snapshot and user metadata. The procedure orchestrates sequential deletion and insertion operations for attribute and comp flag tables.</p>

<!-- 2. Code Structure and Design -->
<p><b>Code Structure and Design</b></p>
<p><b>Structure:</b> The procedure defines two local variables (<code>V_WEEK</code>, <code>V_LY_WEEK</code>) and initializes <code>V_WEEK</code> using a function call. It sequentially deletes all rows from two target tables, then inserts new data into each table using SELECT statements from calculation views, mapping multiple fields and adding metadata (<code>CURRENT_TIMESTAMP</code>, <code>SESSION_USER</code>). <b>Key Components:</b> The procedure consists of variable declarations, deletion statements, two INSERT operations (one for each target table), and a summary SELECT output. Major components are the calculation views (<code>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4</code>, <code>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4</code>), the prior fiscal week function, and the target tables (<code>CVS_FRIP.CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT</code>, <code>CVS_FRIP.CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</code>). <b>Dependencies & Performance:</b> The procedure depends on calculation views, a scalar function for prior fiscal week, and two target tables. It uses bulk deletion and insertion, and includes filtering in the second INSERT based on the prior week variable. No aggregations or joins are present; performance depends on calculation view processing and bulk operations.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; background:#f9f9f9; padding:16px; border-radius:8px;">
  <div style="display:grid; grid-template-columns:repeat(4, 220px); grid-auto-rows:96px; gap:32px; align-items:center;">
    <!-- Step 1: Init -->
    <div style="grid-column:1; grid-row:1; background:#e3eaff; border-radius:6px; text-align:center; font-weight:bold; box-shadow:0 1px 4px #bbb;">Start Procedure</div>
    <div style="grid-column:2; grid-row:1; background:#e3eaff; border-radius:6px; text-align:center; font-weight:bold; box-shadow:0 1px 4px #bbb;">Declare V_WEEK</div>
    <div style="grid-column:3; grid-row:1; background:#e3eaff; border-radius:6px; text-align:center; font-weight:bold; box-shadow:0 1px 4px #bbb;">Get Prior Fiscal Week<br><span style="font-size:smaller;">SFN_PRIOR_FISCAL_WEEK()</span></div>
    <div style="grid-column:4; grid-row:1; background:#e3eaff; border-radius:6px; text-align:center; font-weight:bold; box-shadow:0 1px 4px #bbb;">Set V_WEEK</div>
    <!-- Arrows -->
    <div style="grid-column:1/2; grid-row:2; justify-self:center;">→</div>
    <div style="grid-column:2/3; grid-row:2; justify-self:center;">→</div>
    <div style="grid-column:3/4; grid-row:2; justify-self:center;">→</div>

    <!-- Step 2: Delete Data -->
    <div style="grid-column:1; grid-row:3; background:#ffe3e3; border-radius:6px; text-align:center; font-weight:bold; box-shadow:0 1px 4px #bbb;">Delete All Rows<br>TBL_WSS_SRP_ATTR_ACT</div>
    <div style="grid-column:2; grid-row:3; background:#ffe3e3; border-radius:6px; text-align:center; font-weight:bold; box-shadow:0 1px 4px #bbb;">Delete All Rows<br>TBL_WSS_SRP_COMPFLAG</div>
    <!-- Arrows -->
    <div style="grid-column:1/2; grid-row:4; justify-self:center;">→</div>
    <div style="grid-column:2/3; grid-row:4; justify-self:center;">→</div>

    <!-- Step 3: Insert Data -->
    <div style="grid-column:1; grid-row:5; background:#e3ffe3; border-radius:6px; text-align:center; font-weight:bold; box-shadow:0 1px 4px #bbb;">Insert Rows<br>TBL_WSS_SRP_ATTR_ACT<br><span style="font-size:smaller;">From CV_BASE_MD_SRPACT_S4</span></div>
    <div style="grid-column:2; grid-row:5; background:#e3ffe3; border-radius:6px; text-align:center; font-weight:bold; box-shadow:0 1px 4px #bbb;">Insert Rows<br>TBL_WSS_SRP_COMPFLAG<br><span style="font-size:smaller;">From CV_BASE_MD_COMPFL_S4<br>WHERE ZWEEK = V_WEEK</span></div>
    <!-- Arrows -->
    <div style="grid-column:1/2; grid-row:6; justify-self:center;">→</div>
    <div style="grid-column:2/3; grid-row:6; justify-self:center;">→</div>

    <!-- Step 4: Summary Output -->
    <div style="grid-column:3; grid-row:7; background:#fffbe3; border-radius:6px; text-align:center; font-weight:bold; box-shadow:0 1px 4px #bbb;">Summary Output<br>"Store attribute table loaded & Comp Flag table loaded for V_WEEK"</div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="6" style="border-collapse:collapse; width:100%; margin-top:16px;">
  <tr style="background:#f0f0f0;">
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <!-- Mapping for TBL_WSS_SRP_ATTR_ACT -->
  <tr>
    <td>CVS_FRIP.CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT</td>
    <td>MANDT</td>
    <td>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4</td>
    <td>MANDT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>CVS_FRIP.CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT</td>
    <td>STRNUM</td>
    <td>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4</td>
    <td>STRNUM</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>CVS_FRIP.CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT</td>
    <td>PRCTR</td>
    <td>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4</td>
    <td>PRCTR</td>
    <td>Direct mapping</td>
  </tr>
  <!-- ... (all other direct mappings for TBL_WSS_SRP_ATTR_ACT fields) ... -->
  <tr>
    <td>CVS_FRIP.CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT</td>
    <td>SNAPSHOT_TIMESTAMP</td>
    <td>Procedure</td>
    <td>CURRENT_TIMESTAMP</td>
    <td>Derived: current timestamp at insert</td>
  </tr>
  <tr>
    <td>CVS_FRIP.CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT</td>
    <td>SNAPSHOT_CREATED_BY</td>
    <td>Procedure</td>
    <td>SESSION_USER</td>
    <td>Derived: session user at insert</td>
  </tr>
  <!-- Mapping for TBL_WSS_SRP_COMPFLAG -->
  <tr>
    <td>CVS_FRIP.CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</td>
    <td>MANDT</td>
    <td>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4</td>
    <td>MANDT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>CVS_FRIP.CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</td>
    <td>PRCTR</td>
    <td>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4</td>
    <td>PRCTR</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>CVS_FRIP.CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</td>
    <td>STRNUM</td>
    <td>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4</td>
    <td>STRNUM</td>
    <td>Direct mapping</td>
  </tr>
  <!-- ... (all other direct mappings for TBL_WSS_SRP_COMPFLAG fields) ... -->
  <tr>
    <td>CVS_FRIP.CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</td>
    <td>SNAPSHOT_TIMESTAMP</td>
    <td>Procedure</td>
    <td>CURRENT_TIMESTAMP</td>
    <td>Derived: current timestamp at insert</td>
  </tr>
  <tr>
    <td>CVS_FRIP.CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</td>
    <td>CREATED_BY</td>
    <td>Procedure</td>
    <td>SESSION_USER</td>
    <td>Derived: session user at insert</td>
  </tr>
  <tr>
    <td>CVS_FRIP.CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</td>
    <td>ZWEEK</td>
    <td>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4</td>
    <td>ZWEEK</td>
    <td>Filtered: ZWEEK = V_WEEK</td>
  </tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="6" style="border-collapse:collapse; width:100%; margin-top:16px;">
  <tr style="background:#f0f0f0;">
    <th>Category</th>
    <th>Measurement</th>
  </tr>
  <tr><td>Number of Objects/Nodes</td><td>6 (Procedure, 2 Calculation Views, 2 Target Tables, 1 Scalar Function)</td></tr>
  <tr><td>Sources Used</td><td>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4, _SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4, CVS_FRIP.CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None identified</td></tr>
  <tr><td>Data Manipulation</td><td>DELETE, INSERT</td></tr>
  <tr><td>Conditional Logic</td><td>WHERE clause in second INSERT (ZWEEK = V_WEEK)</td></tr>
  <tr><td>Workflow Complexity</td><td>Sequential deletion and insertion; moderate field mapping complexity</td></tr>
  <tr><td>Performance Considerations</td><td>Bulk deletion/insertion, dependency on calculation view performance</td></tr>
  <tr><td>Data Volume Handling</td><td>Bulk operations on entire tables; no row count specified</td></tr>
  <tr><td>Dependency Complexity</td><td>Multiple dependencies: calculation views, function, target tables</td></tr>
  <tr><td>Overall Complexity Score</td><td>Medium</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>Rows inserted into CVS_FRIP.CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT with mapped fields and snapshot metadata</li>
  <li>Rows inserted into CVS_FRIP.CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG with mapped fields, filtered by prior week, and snapshot metadata</li>
  <li>Summary output: "Store attribute table loaded & Comp Flag table loaded for V_WEEK"</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
