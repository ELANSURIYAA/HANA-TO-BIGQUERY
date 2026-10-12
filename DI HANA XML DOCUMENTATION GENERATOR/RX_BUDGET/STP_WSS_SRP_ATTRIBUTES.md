<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc; padding-bottom:10px; margin-bottom:20px;">
  <b>Author:</b> Ascendion AAVA<br/>
  <b>Created On:</b> 2026-10-12<br/>
  <b>Description:</b> This documentation describes the HANA SQLScript Procedure "CVS_FRIP"."CVS_FRIP.Procedure.FI::STP_WSS_SRP_ATTRIBUTES". The procedure loads store attribute and comparison flag data into target tables from calculation views, performing deletion and insertion operations based on prior fiscal week logic.
</div>

<!-- 1. Overview of Program -->
<p>
This HANA object is a SQLScript Procedure. Its primary purpose is to load store attribute and comparison flag data into target tables by processing data from calculation views. The procedure manages data insertion and deletion based on prior fiscal week logic.
</p>

<!-- 2. Code Structure and Design -->
<p>
<b>Structure:</b> The procedure declares variables for week calculation, initializes the week value using a function, deletes all data from two target tables, and then inserts new data into these tables from two calculation views. The insertions include mappings of multiple fields and use the current timestamp and session user for audit fields. <b>Key Components:</b> Major components include variable declarations, invocation of a function to determine prior fiscal week, deletion statements for clearing target tables, and insert statements for loading data from calculation views into tables. <b>Dependencies & Performance:</b> Dependencies include the calculation views "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4" and "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4", as well as the function "CVS_FRIP"."CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK". All data manipulation is performed in bulk, and audit fields are populated using built-in functions. No explicit aggregation, join, or filter logic is present beyond week-based filtering in the comparison flag insertion.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; background:#fafafa; padding:20px; border-radius:8px; border:1px solid #e0e0e0;">
  <div style="display:grid; grid-template-columns:repeat(4, 200px); grid-auto-rows:90px; gap:30px; align-items:center;">
    <div style="grid-column:1; grid-row:1; background:#e7f0fd; border-radius:6px; border:1px solid #b3c7e6; display:flex; align-items:center; justify-content:center;">Start</div>
    <div style="grid-column:2; grid-row:1; background:#fffbe7; border-radius:6px; border:1px solid #e6d5b3; display:flex; align-items:center; justify-content:center;">Declare V_WEEK, V_LY_WEEK</div>
    <div style="grid-column:3; grid-row:1; background:#e7f0fd; border-radius:6px; border:1px solid #b3c7e6; display:flex; align-items:center; justify-content:center;">Initialize V_WEEK<br/>(Call SFN_PRIOR_FISCAL_WEEK)</div>
    <div style="grid-column:4; grid-row:1; background:#ffe7e7; border-radius:6px; border:1px solid #e6b3b3; display:flex; align-items:center; justify-content:center;">Delete from TBL_WSS_SRP_ATTR_ACT</div>
    
    <div style="grid-column:4; grid-row:2; background:#ffe7e7; border-radius:6px; border:1px solid #e6b3b3; display:flex; align-items:center; justify-content:center;">Delete from TBL_WSS_SRP_COMPFLAG</div>
    
    <div style="grid-column:2; grid-row:3; background:#e7ffe7; border-radius:6px; border:1px solid #b3e6b3; display:flex; align-items:center; justify-content:center;">Insert into TBL_WSS_SRP_ATTR_ACT<br/>from CV_BASE_MD_SRPACT_S4</div>
    
    <div style="grid-column:3; grid-row:3; background:#e7ffe7; border-radius:6px; border:1px solid #b3e6b3; display:flex; align-items:center; justify-content:center;">Insert into TBL_WSS_SRP_COMPFLAG<br/>from CV_BASE_MD_COMPFL_S4<br/>where ZWEEK = V_WEEK</div>
    
    <div style="grid-column:2; grid-row:4; background:#e7f0fd; border-radius:6px; border:1px solid #b3c7e6; display:flex; align-items:center; justify-content:center;">Output Summary Message</div>
    
    <!-- Arrows -->
    <svg style="grid-column:1; grid-row:1; position:relative; left:180px; top:40px;" width="50" height="50">
      <line x1="0" y1="25" x2="50" y2="25" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/>
      <defs><marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#888"/></marker></defs>
    </svg>
    <svg style="grid-column:2; grid-row:1; position:relative; left:180px; top:40px;" width="50" height="50">
      <line x1="0" y1="25" x2="50" y2="25" stroke="#888" stroke-width="2" marker-end="url(#arrowhead2)"/>
      <defs><marker id="arrowhead2" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#888"/></marker></defs>
    </svg>
    <svg style="grid-column:3; grid-row:1; position:relative; left:180px; top:40px;" width="50" height="50">
      <line x1="0" y1="25" x2="50" y2="25" stroke="#888" stroke-width="2" marker-end="url(#arrowhead3)"/>
      <defs><marker id="arrowhead3" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#888"/></marker></defs>
    </svg>
    <svg style="grid-column:4; grid-row:1; position:relative; left:-80px; top:60px;" width="50" height="50">
      <line x1="25" y1="0" x2="25" y2="50" stroke="#888" stroke-width="2" marker-end="url(#arrowhead4)"/>
      <defs><marker id="arrowhead4" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#888"/></marker></defs>
    </svg>
    <svg style="grid-column:4; grid-row:2; position:relative; left:-320px; top:60px;" width="50" height="50">
      <line x1="25" y1="0" x2="-25" y2="50" stroke="#888" stroke-width="2" marker-end="url(#arrowhead5)"/>
      <defs><marker id="arrowhead5" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#888"/></marker></defs>
    </svg>
    <svg style="grid-column:2; grid-row:3; position:relative; left:180px; top:40px;" width="50" height="50">
      <line x1="0" y1="25" x2="50" y2="25" stroke="#888" stroke-width="2" marker-end="url(#arrowhead6)"/>
      <defs><marker id="arrowhead6" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#888"/></marker></defs>
    </svg>
    <svg style="grid-column:3; grid-row:3; position:relative; left:-180px; top:60px;" width="50" height="50">
      <line x1="25" y1="0" x2="-25" y2="50" stroke="#888" stroke-width="2" marker-end="url(#arrowhead7)"/>
      <defs><marker id="arrowhead7" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#888"/></marker></defs>
    </svg>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="5" cellspacing="0" style="border-collapse:collapse; margin-top:20px;">
<thead>
<tr>
<th>Target Object/Field Name</th>
<th>Target Column Name</th>
<th>Source Object/Field Name</th>
<th>Source Column Name</th>
<th>Remarks</th>
</tr>
</thead>
<tbody>
<!-- Store Attribute Table Mappings -->
<tr><td>CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT</td><td>MANDT</td><td>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4</td><td>MANDT</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT</td><td>STRNUM</td><td>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4</td><td>STRNUM</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT</td><td>PRCTR</td><td>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4</td><td>PRCTR</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT</td><td>KOKRS</td><td>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4</td><td>KOKRS</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT</td><td>KOSTL</td><td>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4</td><td>KOSTL</td><td>Direct mapping</td></tr>
<!-- ... (repeat for all fields mapped from CV_BASE_MD_SRPACT_S4) ... -->
<tr><td>CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT</td><td>SNAPSHOT_TIMESTAMP</td><td>Procedure</td><td>CURRENT_TIMESTAMP</td><td>Derived: system timestamp</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT</td><td>SNAPSHOT_CREATED_BY</td><td>Procedure</td><td>SESSION_USER</td><td>Derived: session user</td></tr>
<!-- Comp Flag Table Mappings -->
<tr><td>CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</td><td>MANDT</td><td>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4</td><td>MANDT</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</td><td>PRCTR</td><td>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4</td><td>PRCTR</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</td><td>STRNUM</td><td>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4</td><td>STRNUM</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</td><td>COMP_VER</td><td>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4</td><td>COMP_VER</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</td><td>ZWEEK</td><td>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4</td><td>ZWEEK</td><td>Direct mapping; filtered by V_WEEK</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</td><td>SNAPSHOT_TIMESTAMP</td><td>Procedure</td><td>CURRENT_TIMESTAMP</td><td>Derived: system timestamp</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</td><td>CREATED_BY</td><td>Procedure</td><td>SESSION_USER</td><td>Derived: session user</td></tr>
<!-- ... (repeat for all fields mapped from CV_BASE_MD_COMPFL_S4) ... -->
</tbody>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="5" cellspacing="0" style="border-collapse:collapse; margin-top:20px;">
<thead>
<tr><th>Category</th><th>Measurement</th></tr>
</thead>
<tbody>
<tr><td>Number of Objects/Nodes</td><td>6 (Procedure, 2 Calculation Views, 2 Target Tables, 1 Function)</td></tr>
<tr><td>Sources Used</td><td>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4, _SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4</td></tr>
<tr><td>Joins</td><td>None identified</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>None identified</td></tr>
<tr><td>Data Manipulation</td><td>DELETE, INSERT</td></tr>
<tr><td>Conditional Logic</td><td>WHERE clause on ZWEEK = V_WEEK</td></tr>
<tr><td>Workflow Complexity</td><td>Linear, multi-step process with variable initialization, deletion, and bulk insertion</td></tr>
<tr><td>Performance Considerations</td><td>Bulk data operations; audit fields populated with system functions; filtering by fiscal week</td></tr>
<tr><td>Data Volume Handling</td><td>Bulk operations; no explicit row count or volume logic</td></tr>
<tr><td>Dependency Complexity</td><td>Multiple dependencies: calculation views, function, and tables</td></tr>
<tr><td>Overall Complexity Score</td><td>Medium</td></tr>
</tbody>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>Rows inserted into CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT with mapped fields and audit columns</li>
  <li>Rows inserted into CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG with mapped fields and audit columns</li>
  <li>Summary output message indicating completion and week processed</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
