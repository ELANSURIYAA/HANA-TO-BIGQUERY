<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse;">
  <tr>
    <td><b>Author:</b></td>
    <td>Ascendion AAVA</td>
  </tr>
  <tr>
    <td><b>Created On:</b></td>
    <td>2026-10-12</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td>This document describes the technical structure, processing logic, data flow, and outputs of the HANA SQLScript Procedure <code>CVS_FRIP.CVS_FRIP.Procedure.FI::STP_WSS_SRP_ATTRIBUTES</code>, which inserts data into target tables from calculation views and performs deletion and mapping operations as defined in the input HANA XML.</td>
  </tr>
</table>

<!-- 1. OVERVIEW OF PROGRAM -->
<b>Overview of Program</b><br>
This HANA object is a SQLScript Procedure named <code>STP_WSS_SRP_ATTRIBUTES</code>. Its primary purpose is to delete existing records and insert new data into two target tables using data from calculation views. The procedure orchestrates the end-to-end data movement and mapping logic between source calculation views and target tables.

<!-- 2. CODE STRUCTURE AND DESIGN -->
<b>Code Structure and Design</b><br>
<b>Structure:</b> The procedure begins by declaring two variables, followed by initializing one variable with the prior fiscal week via a function call. It then deletes data from two target tables, and subsequently inserts mapped data from two calculation views into these tables. The insert statements map multiple fields directly from the calculation views to the target tables, and use system functions for audit fields. Finally, a summary select statement outputs a status message.<br>
<b>Key Components:</b> The major components include variable declaration and initialization, deletion of existing records in target tables, insertion of mapped data from calculation views (<code>CV_BASE_MD_SRPACT_S4</code> and <code>CV_BASE_MD_COMPFL_S4</code>), usage of system fields (<code>CURRENT_TIMESTAMP</code>, <code>SESSION_USER</code>), and a summary output.<br>
<b>Dependencies & Performance:</b> The procedure depends on calculation views (<code>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4</code>, <code>_SYS_BIC.CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4</code>), a function (<code>CVS_FRIP.CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK</code>), and the target tables. The use of DELETE and INSERT operations, as well as the mapping of numerous fields, are performance-relevant. Filtering is applied in the second insert based on the fiscal week variable.

<!-- 3. DATA FLOW AND PROCESSING LOGIC -->
<div style="overflow-x:auto; padding:10px; background:#f9f9f9; border:1px solid #ddd;">
  <div style="display:grid; grid-template-columns:repeat(4, 220px); grid-template-rows:repeat(7, 70px); gap:20px; align-items:center;">
    <div style="grid-column:1; grid-row:1; background:#e3f2fd; border-radius:8px; padding:14px; text-align:center;">Start Procedure</div>
    <div style="grid-column:2; grid-row:2; background:#fffde7; border-radius:8px; padding:14px; text-align:center;">Declare V_WEEK, V_LY_WEEK</div>
    <div style="grid-column:3; grid-row:3; background:#e8f5e9; border-radius:8px; padding:14px; text-align:center;">Initialize V_WEEK<br>Call SFN_PRIOR_FISCAL_WEEK</div>
    <div style="grid-column:1; grid-row:4; background:#ffe0b2; border-radius:8px; padding:14px; text-align:center;">Delete TBL_WSS_SRP_ATTR_ACT</div>
    <div style="grid-column:2; grid-row:4; background:#ffe0b2; border-radius:8px; padding:14px; text-align:center;">Delete TBL_WSS_SRP_COMPFLAG</div>
    <div style="grid-column:3; grid-row:5; background:#bbdefb; border-radius:8px; padding:14px; text-align:center;">Insert into TBL_WSS_SRP_ATTR_ACT<br>From CV_BASE_MD_SRPACT_S4</div>
    <div style="grid-column:4; grid-row:6; background:#bbdefb; border-radius:8px; padding:14px; text-align:center;">Insert into TBL_WSS_SRP_COMPFLAG<br>From CV_BASE_MD_COMPFL_S4<br>Where ZWEEK = V_WEEK</div>
    <div style="grid-column:3; grid-row:7; background:#d1c4e9; border-radius:8px; padding:14px; text-align:center;">Summary Output</div>
    <!-- Arrows -->
    <svg style="grid-column:1; grid-row:2; width:60px; height:30px;" xmlns="http://www.w3.org/2000/svg">
      <line x1="30" y1="0" x2="30" y2="30" stroke="#1976d2" stroke-width="2" marker-end="url(#arrow)"/>
      <defs><marker id="arrow" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto"><polygon points="0,0 8,4 0,8" fill="#1976d2"/></marker></defs>
    </svg>
    <svg style="grid-column:2; grid-row:3; width:60px; height:30px;" xmlns="http://www.w3.org/2000/svg">
      <line x1="30" y1="0" x2="30" y2="30" stroke="#fbc02d" stroke-width="2" marker-end="url(#arrow2)"/>
      <defs><marker id="arrow2" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto"><polygon points="0,0 8,4 0,8" fill="#fbc02d"/></marker></defs>
    </svg>
    <svg style="grid-column:3; grid-row:4; width:60px; height:30px;" xmlns="http://www.w3.org/2000/svg">
      <line x1="30" y1="0" x2="30" y2="30" stroke="#388e3c" stroke-width="2" marker-end="url(#arrow3)"/>
      <defs><marker id="arrow3" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto"><polygon points="0,0 8,4 0,8" fill="#388e3c"/></marker></defs>
    </svg>
    <svg style="grid-column:1; grid-row:4; width:60px; height:30px;" xmlns="http://www.w3.org/2000/svg">
      <line x1="30" y1="0" x2="30" y2="30" stroke="#f57c00" stroke-width="2" marker-end="url(#arrow4)"/>
      <defs><marker id="arrow4" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto"><polygon points="0,0 8,4 0,8" fill="#f57c00"/></marker></defs>
    </svg>
    <svg style="grid-column:2; grid-row:4; width:60px; height:30px;" xmlns="http://www.w3.org/2000/svg">
      <line x1="30" y1="0" x2="30" y2="30" stroke="#f57c00" stroke-width="2" marker-end="url(#arrow5)"/>
      <defs><marker id="arrow5" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto"><polygon points="0,0 8,4 0,8" fill="#f57c00"/></marker></defs>
    </svg>
    <svg style="grid-column:3; grid-row:5; width:60px; height:30px;" xmlns="http://www.w3.org/2000/svg">
      <line x1="30" y1="0" x2="30" y2="30" stroke="#1976d2" stroke-width="2" marker-end="url(#arrow6)"/>
      <defs><marker id="arrow6" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto"><polygon points="0,0 8,4 0,8" fill="#1976d2"/></marker></defs>
    </svg>
    <svg style="grid-column:4; grid-row:6; width:60px; height:30px;" xmlns="http://www.w3.org/2000/svg">
      <line x1="30" y1="0" x2="30" y2="30" stroke="#1976d2" stroke-width="2" marker-end="url(#arrow7)"/>
      <defs><marker id="arrow7" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto"><polygon points="0,0 8,4 0,8" fill="#1976d2"/></marker></defs>
    </svg>
    <svg style="grid-column:3; grid-row:7; width:60px; height:30px;" xmlns="http://www.w3.org/2000/svg">
      <line x1="30" y1="0" x2="30" y2="30" stroke="#7e57c2" stroke-width="2" marker-end="url(#arrow8)"/>
      <defs><marker id="arrow8" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto"><polygon points="0,0 8,4 0,8" fill="#7e57c2"/></marker></defs>
    </svg>
  </div>
</div>

<!-- 4. DATA MAPPING -->
<table style="width:100%; border-collapse:collapse;">
  <tr style="background:#f1f1f1;">
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <!-- TBL_WSS_SRP_ATTR_ACT Mappings -->
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>MANDT</td><td>CV_BASE_MD_SRPACT_S4</td><td>MANDT</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>STRNUM</td><td>CV_BASE_MD_SRPACT_S4</td><td>STRNUM</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>PRCTR</td><td>CV_BASE_MD_SRPACT_S4</td><td>PRCTR</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>KOKRS</td><td>CV_BASE_MD_SRPACT_S4</td><td>KOKRS</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>KOSTL</td><td>CV_BASE_MD_SRPACT_S4</td><td>KOSTL</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_OPEN_DAT</td><td>CV_BASE_MD_SRPACT_S4</td><td>RX_OPEN_DAT</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_CLOSE_DAT</td><td>CV_BASE_MD_SRPACT_S4</td><td>RX_CLOSE_DAT</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_HRS_OPER</td><td>CV_BASE_MD_SRPACT_S4</td><td>RX_HRS_OPER</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>FS_OPEN_DAT</td><td>CV_BASE_MD_SRPACT_S4</td><td>FS_OPEN_DAT</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>FS_CLOSE_DAT</td><td>CV_BASE_MD_SRPACT_S4</td><td>FS_CLOSE_DAT</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>FS_HRS_OPER</td><td>CV_BASE_MD_SRPACT_S4</td><td>FS_HRS_OPER</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>REP_MKT_CODE</td><td>CV_BASE_MD_SRPACT_S4</td><td>REP_MKT_CODE</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>REP_MKT_DESC</td><td>CV_BASE_MD_SRPACT_S4</td><td>REP_MKT_DESC</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>ADDRESS</td><td>CV_BASE_MD_SRPACT_S4</td><td>ADDRESS</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>CITY</td><td>CV_BASE_MD_SRPACT_S4</td><td>CITY</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>STATE</td><td>CV_BASE_MD_SRPACT_S4</td><td>STATE</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>ZIPCODE</td><td>CV_BASE_MD_SRPACT_S4</td><td>ZIPCODE</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>DIVISION_CODE</td><td>CV_BASE_MD_SRPACT_S4</td><td>DIVISION_CODE</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>DIVISION_DESC</td><td>CV_BASE_MD_SRPACT_S4</td><td>DIVISION_DESC</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>DIVISION_MGR</td><td>CV_BASE_MD_SRPACT_S4</td><td>DIVISION_MGR</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>AREA_CODE</td><td>CV_BASE_MD_SRPACT_S4</td><td>AREA_CODE</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>AREA_DESC</td><td>CV_BASE_MD_SRPACT_S4</td><td>AREA_DESC</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>AREA_MGR</td><td>CV_BASE_MD_SRPACT_S4</td><td>AREA_MGR</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>REGION_CODE</td><td>CV_BASE_MD_SRPACT_S4</td><td>REGION_CODE</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>REGION_DESC</td><td>CV_BASE_MD_SRPACT_S4</td><td>REGION_DESC</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>REGION_MGR</td><td>CV_BASE_MD_SRPACT_S4</td><td>REGION_MGR</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRICT_CODE</td><td>CV_BASE_MD_SRPACT_S4</td><td>DISTRICT_CODE</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRICT_DESC</td><td>CV_BASE_MD_SRPACT_S4</td><td>DISTRICT_DESC</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRICT_MGR</td><td>CV_BASE_MD_SRPACT_S4</td><td>DISTRICT_MGR</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>ZONE_CODE</td><td>CV_BASE_MD_SRPACT_S4</td><td>ZONE_CODE</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>ZONE_DESC</td><td>CV_BASE_MD_SRPACT_S4</td><td>ZONE_DESC</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>MAJOR_REGION_CODE</td><td>CV_BASE_MD_SRPACT_S4</td><td>MAJOR_REGION_CODE</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>MAJOR_REGION</td><td>CV_BASE_MD_SRPACT_S4</td><td>MAJOR_REGION</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>STORE_TYPE</td><td>CV_BASE_MD_SRPACT_S4</td><td>STORE_TYPE</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>STORE_TYPE_DESC</td><td>CV_BASE_MD_SRPACT_S4</td><td>STORE_TYPE_DESC</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_STORE</td><td>CV_BASE_MD_SRPACT_S4</td><td>RX_STORE</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>RX_STORE_DESC</td><td>CV_BASE_MD_SRPACT_S4</td><td>RX_STORE_DESC</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRIBUTION_CNTR</td><td>CV_BASE_MD_SRPACT_S4</td><td>DISTRIBUTION_CNTR</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>DISTRIBUTION_CNTR_DESC</td><td>CV_BASE_MD_SRPACT_S4</td><td>DISTRIBUTION_CNTR_DESC</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>STORE_24_HR</td><td>CV_BASE_MD_SRPACT_S4</td><td>STORE_24_HR</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>BUDGET_OPEN_DAT</td><td>CV_BASE_MD_SRPACT_S4</td><td>BUDGET_OPEN_DAT</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>BUDGET_CLOSED_DAT</td><td>CV_BASE_MD_SRPACT_S4</td><td>BUDGET_CLOSED_DAT</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>BUDGET_RELOC_DAT</td><td>CV_BASE_MD_SRPACT_S4</td><td>BUDGET_RELOC_DAT</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>CONST_OPEN_DAT</td><td>CV_BASE_MD_SRPACT_S4</td><td>CONST_OPEN_DAT</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>CONST_CLOSE_DAT</td><td>CV_BASE_MD_SRPACT_S4</td><td>CONST_CLOSE_DAT</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>CONST_RELO_DAT</td><td>CV_BASE_MD_SRPACT_S4</td><td>CONST_RELO_DAT</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>RELOCATION_DAT</td><td>CV_BASE_MD_SRPACT_S4</td><td>RELOCATION_DAT</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>EMERG_MKT_IND</td><td>CV_BASE_MD_SRPACT_S4</td><td>EMERG_MKT_IND</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>BUDGET_EMERG_MKT_IND</td><td>CV_BASE_MD_SRPACT_S4</td><td>BUDGET_EMERG_MKT_IND</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>COMPANY_CODE</td><td>CV_BASE_MD_SRPACT_S4</td><td>COMPANY_CODE</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>COMPANY_CODE_DESC</td><td>CV_BASE_MD_SRPACT_S4</td><td>COMPANY_CODE_DESC</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>ORIGINAL_FS_OPEN_DAT</td><td>CV_BASE_MD_SRPACT_S4</td><td>ORIGINAL_FS_OPEN_DAT</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>ORIGINAL_RX_OPEN_DAT</td><td>CV_BASE_MD_SRPACT_S4</td><td>ORIGINAL_RX_OPEN_DAT</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>GROUP_ONE</td><td>CV_BASE_MD_SRPACT_S4</td><td>GROUP_ONE</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>GROUP_TWO</td><td>CV_BASE_MD_SRPACT_S4</td><td>GROUP_TWO</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>ARD_SORT_KEY</td><td>CV_BASE_MD_SRPACT_S4</td><td>ARD_SORT_KEY</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>AREA_COST_CENTER</td><td>CV_BASE_MD_SRPACT_S4</td><td>AREA_COST_CENTER</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>REGIION_COST_CENTER</td><td>CV_BASE_MD_SRPACT_S4</td><td>REGIION_COST_CENTER</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>COUNTY_CODE</td><td>CV_BASE_MD_SRPACT_S4</td><td>COUNTY_CODE</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>COUNTY_DESC</td><td>CV_BASE_MD_SRPACT_S4</td><td>COUNTY_DESC</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>RETAIL_SQFT_AMT</td><td>CV_BASE_MD_SRPACT_S4</td><td>RETAIL_SQFT_AMT</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>TOTAL_SQFT_AMT</td><td>CV_BASE_MD_SRPACT_S4</td><td>TOTAL_SQFT_AMT</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>SQFT_BRACKET_DESC</td><td>CV_BASE_MD_SRPACT_S4</td><td>SQFT_BRACKET_DESC</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>SQFT_SORT_KEY</td><td>CV_BASE_MD_SRPACT_S4</td><td>SQFT_SORT_KEY</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>ACQUISITION_CODE</td><td>CV_BASE_MD_SRPACT_S4</td><td>ACQUISITION_CODE</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>ACQUISITION_DESC</td><td>CV_BASE_MD_SRPACT_S4</td><td>ACQUISITION_DESC</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>PHOTO_LAB_ADD_DAT</td><td>CV_BASE_MD_SRPACT_S4</td><td>PHOTO_LAB_ADD_DAT</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>PHOTO_LAB_CLOSE_DAT</td><td>CV_BASE_MD_SRPACT_S4</td><td>PHOTO_LAB_CLOSE_DAT</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>MIN_HRS_IND</td><td>CV_BASE_MD_SRPACT_S4</td><td>MIN_HRS_IND</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>CREATEDBY</td><td>CV_BASE_MD_SRPACT_S4</td><td>CREATEDBY</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>CREATED_ON</td><td>CV_BASE_MD_SRPACT_S4</td><td>CREATED_ON</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>SNAPSHOT_TIMESTAMP</td><td>System</td><td>CURRENT_TIMESTAMP</td><td>System-generated timestamp</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>SNAPSHOT_CREATED_BY</td><td>System</td><td>SESSION_USER</td><td>System-generated user</td></tr>
  <!-- TBL_WSS_SRP_COMPFLAG Mappings -->
  <tr><td>TBL_WSS_SRP_COMPFLAG</td><td>MANDT</td><td>CV_BASE_MD_COMPFL_S4</td><td>MANDT</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_COMPFLAG</td><td>PRCTR</td><td>CV_BASE_MD_COMPFL_S4</td><td>PRCTR</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_COMPFLAG</td><td>STRNUM</td><td>CV_BASE_MD_COMPFL_S4</td><td>STRNUM</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_COMPFLAG</td><td>COMP_VER</td><td>CV_BASE_MD_COMPFL_S4</td><td>COMP_VER</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_COMPFLAG</td><td>ZWEEK</td><td>CV_BASE_MD_COMPFL_S4</td><td>ZWEEK</td><td>Filtered by V_WEEK</td></tr>
  <tr><td>TBL_WSS_SRP_COMPFLAG</td><td>ZMONTH</td><td>CV_BASE_MD_COMPFL_S4</td><td>ZMONTH</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_COMPFLAG</td><td>ZYEAR</td><td>CV_BASE_MD_COMPFL_S4</td><td>ZYEAR</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_COMPFLAG</td><td>FS_COMP_PRE</td><td>CV_BASE_MD_COMPFL_S4</td><td>FS_COMP_PRE</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_COMPFLAG</td><td>RX_COMP_PRE</td><td>CV_BASE_MD_COMPFL_S4</td><td>RX_COMP_PRE</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_COMPFLAG</td><td>FS_COMP_MON</td><td>CV_BASE_MD_COMPFL_S4</td><td>FS_COMP_MON</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_COMPFLAG</td><td>RX_COMP_MON</td><td>CV_BASE_MD_COMPFL_S4</td><td>RX_COMP_MON</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_COMPFLAG</td><td>FS_COMP_WK</td><td>CV_BASE_MD_COMPFL_S4</td><td>FS_COMP_WK</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_COMPFLAG</td><td>RX_COMP_WK</td><td>CV_BASE_MD_COMPFL_S4</td><td>RX_COMP_WK</td><td>Direct mapping</td></tr>
  <tr><td>TBL_WSS_SRP_COMPFLAG</td><td>SNAPSHOT_TIMESTAMP</td><td>System</td><td>CURRENT_TIMESTAMP</td><td>System-generated timestamp</td></tr>
  <tr><td>TBL_WSS_SRP_COMPFLAG</td><td>CREATED_BY</td><td>System</td><td>SESSION_USER</td><td>System-generated user</td></tr>
</table>

<!-- 5. COMPLEXITY ANALYSIS -->
<table style="width:100%; border-collapse:collapse;">
  <tr style="background:#f1f1f1;">
    <th>Category</th>
    <th>Measurement</th>
  </tr>
  <tr><td>Number of Objects/Nodes</td><td>7 (Procedure, 2 variables, 1 function call, 2 deletes, 2 inserts, 1 select output)</td></tr>
  <tr><td>Sources Used</td><td>CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4, SFN_PRIOR_FISCAL_WEEK</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None identified</td></tr>
  <tr><td>Data Manipulation</td><td>DELETE, INSERT operations present</td></tr>
  <tr><td>Conditional Logic</td><td>Filtering in second insert (WHERE ZWEEK = V_WEEK)</td></tr>
  <tr><td>Workflow Complexity</td><td>Medium; sequential deletes, inserts, and variable initialization</td></tr>
  <tr><td>Performance Considerations</td><td>Bulk deletes and inserts; filtered insert for compflag table</td></tr>
  <tr><td>Data Volume Handling</td><td>Bulk operations implied by DELETE and INSERT statements</td></tr>
  <tr><td>Dependency Complexity</td><td>Depends on two calculation views, one function, two target tables</td></tr>
  <tr><td>Overall Complexity Score</td><td>Medium</td></tr>
</table>

<!-- 6. SENSITIVE AND PRIVACY DATA ASSESSMENT -->
No sensitive data found

<!-- 7. KEY OUTPUTS -->
<ul>
  <li>Records inserted into TBL_WSS_SRP_ATTR_ACT with mapped fields from CV_BASE_MD_SRPACT_S4</li>
  <li>Records inserted into TBL_WSS_SRP_COMPFLAG with mapped fields from CV_BASE_MD_COMPFL_S4 (filtered by fiscal week)</li>
  <li>Summary output: status message indicating tables loaded for the prior week</li>
</ul>

<!-- 8. API COST CALCULATIONS -->
API COST : 0.0000 USD
