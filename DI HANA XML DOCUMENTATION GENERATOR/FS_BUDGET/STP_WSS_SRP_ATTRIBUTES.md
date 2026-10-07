<!-- DOCUMENT HEADER -->
<table style="width:100%;border-collapse:collapse;margin-bottom:20px;">
<tr><td style="font-weight:bold;width:20%">Author:</td><td>Ascendion AAVA</td></tr>
<tr><td style="font-weight:bold;width:20%">Created On:</td><td>2026-10-07</td></tr>
<tr><td style="font-weight:bold;width:20%">Description:</td><td>This documentation describes the HANA SQLScript Procedure <b>CVS_FRIP.Procedure.FI::STP_WSS_SRP_ATTRIBUTES</b>, which processes and loads data from calculation views into target tables, including deletion and insertion operations, based strictly on the logic and structure defined in the XML.</td></tr>
</table>

<!-- 1. Overview of Program -->
<b>Overview of Program</b><br>
This object is a HANA SQLScript Procedure. Its primary purpose is to extract data from calculation views and load it into target tables by performing deletion and insertion operations. The procedure orchestrates data refresh for store attributes and comparison flags using SQLScript logic.

<!-- 2. Code Structure and Design -->
<b>Code Structure and Design</b><br>
<b>Structure:</b> The procedure begins by declaring two variables, then initializes one variable by calling a composite function. It deletes existing data from two target tables, then inserts new data into these tables from two calculation views. The first insertion maps multiple fields from the calculation view to the target table, while the second insertion includes a filter based on the initialized variable. A summary SELECT statement concludes the procedure.<br>
<b>Key Components:</b> Major components include variable declarations, function invocation for week calculation, DELETE statements for clearing target tables, INSERT statements mapping calculation view outputs to table fields, and a summary output. The procedure references calculation views (<b>CV_BASE_MD_SRPACT_S4</b>, <b>CV_BASE_MD_COMPFL_S4</b>), a function (<b>SFN_PRIOR_FISCAL_WEEK</b>), and two target tables (<b>TBL_WSS_SRP_ATTR_ACT</b>, <b>TBL_WSS_SRP_COMPFLAG</b>).<br>
<b>Dependencies & Performance:</b> The procedure depends on calculation views and a function for its logic. Performance-relevant characteristics include bulk DELETE and INSERT operations, reliance on calculation views for source data, and use of a session variable and timestamp for auditability. No aggregation or join operations are performed within the procedure itself.

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;padding:10px;background:#f9f9f9;border-radius:8px;">
<div style="display:grid;grid-template-columns:repeat(4,220px);grid-auto-rows:80px;gap:24px;align-items:center;">
  <div style="grid-column:1;grid-row:1;border:1px solid #bbb;border-radius:8px;background:#fff;text-align:center;font-weight:bold;padding:18px;">Start<br>(Procedure Invocation)</div>
  <div style="grid-column:2;grid-row:1;border:1px solid #bbb;border-radius:8px;background:#e8f0fe;text-align:center;padding:18px;">Declare Variables<br>V_WEEK, V_LY_WEEK</div>
  <div style="grid-column:3;grid-row:1;border:1px solid #bbb;border-radius:8px;background:#e3ffe3;text-align:center;padding:18px;">Initialize V_WEEK<br>Call SFN_PRIOR_FISCAL_WEEK</div>

  <div style="grid-column:2;grid-row:2;border:1px solid #bbb;border-radius:8px;background:#ffe7e7;text-align:center;padding:18px;">Delete Data<br>TBL_WSS_SRP_ATTR_ACT</div>
  <div style="grid-column:3;grid-row:2;border:1px solid #bbb;border-radius:8px;background:#ffe7e7;text-align:center;padding:18px;">Delete Data<br>TBL_WSS_SRP_COMPFLAG</div>

  <div style="grid-column:2;grid-row:3;border:1px solid #bbb;border-radius:8px;background:#e8f0fe;text-align:center;padding:18px;">Insert Data<br>From CV_BASE_MD_SRPACT_S4<br>to TBL_WSS_SRP_ATTR_ACT</div>
  <div style="grid-column:3;grid-row:3;border:1px solid #bbb;border-radius:8px;background:#e8f0fe;text-align:center;padding:18px;">Insert Data<br>From CV_BASE_MD_COMPFL_S4<br>to TBL_WSS_SRP_COMPFLAG<br>(Filter: ZWEEK = V_WEEK)</div>

  <div style="grid-column:2;grid-row:4;border:1px solid #bbb;border-radius:8px;background:#fff;text-align:center;padding:18px;">Summary Output<br>"Store attribute table loaded & Comp Flag table loaded for V_WEEK"</div>

  <!-- Arrows -->
  <div style="grid-column:1;grid-row:1/2;justify-self:center;align-self:center;font-size:2em;">→</div>
  <div style="grid-column:2;grid-row:1/2;justify-self:center;align-self:center;font-size:2em;">→</div>
  <div style="grid-column:3;grid-row:1/2;justify-self:center;align-self:center;font-size:2em;">→</div>
  <div style="grid-column:2;grid-row:2/3;justify-self:center;align-self:center;font-size:2em;">↓</div>
  <div style="grid-column:3;grid-row:2/3;justify-self:center;align-self:center;font-size:2em;">↓</div>
  <div style="grid-column:2;grid-row:3/4;justify-self:center;align-self:center;font-size:2em;">↓</div>
  <div style="grid-column:3;grid-row:3/4;justify-self:center;align-self:center;font-size:2em;">↓</div>
</div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%;border-collapse:collapse;">
<thead style="background:#e8e8e8;">
<tr>
<th>Target Object/Field Name</th>
<th>Target Column Name</th>
<th>Source Object/Field Name</th>
<th>Source Column Name</th>
<th>Remarks</th>
</tr>
</thead>
<tbody>
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
<tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>SNAPSHOT_TIMESTAMP</td><td>Procedure</td><td>CURRENT_TIMESTAMP</td><td>Derived: Current timestamp at insert</td></tr>
<tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>SNAPSHOT_CREATED_BY</td><td>Procedure</td><td>SESSION_USER</td><td>Derived: User executing the procedure</td></tr>
<tr><td>TBL_WSS_SRP_COMPFLAG</td><td>MANDT</td><td>CV_BASE_MD_COMPFL_S4</td><td>MANDT</td><td>Direct mapping</td></tr>
<tr><td>TBL_WSS_SRP_COMPFLAG</td><td>PRCTR</td><td>CV_BASE_MD_COMPFL_S4</td><td>PRCTR</td><td>Direct mapping</td></tr>
<tr><td>TBL_WSS_SRP_COMPFLAG</td><td>STRNUM</td><td>CV_BASE_MD_COMPFL_S4</td><td>STRNUM</td><td>Direct mapping</td></tr>
<tr><td>TBL_WSS_SRP_COMPFLAG</td><td>COMP_VER</td><td>CV_BASE_MD_COMPFL_S4</td><td>COMP_VER</td><td>Direct mapping</td></tr>
<tr><td>TBL_WSS_SRP_COMPFLAG</td><td>ZWEEK</td><td>CV_BASE_MD_COMPFL_S4</td><td>ZWEEK</td><td>Direct mapping; filtered by V_WEEK</td></tr>
<tr><td>TBL_WSS_SRP_COMPFLAG</td><td>ZMONTH</td><td>CV_BASE_MD_COMPFL_S4</td><td>ZMONTH</td><td>Direct mapping</td></tr>
<tr><td>TBL_WSS_SRP_COMPFLAG</td><td>ZYEAR</td><td>CV_BASE_MD_COMPFL_S4</td><td>ZYEAR</td><td>Direct mapping</td></tr>
<tr><td>TBL_WSS_SRP_COMPFLAG</td><td>FS_COMP_PRE</td><td>CV_BASE_MD_COMPFL_S4</td><td>FS_COMP_PRE</td><td>Direct mapping</td></tr>
<tr><td>TBL_WSS_SRP_COMPFLAG</td><td>RX_COMP_PRE</td><td>CV_BASE_MD_COMPFL_S4</td><td>RX_COMP_PRE</td><td>Direct mapping</td></tr>
<tr><td>TBL_WSS_SRP_COMPFLAG</td><td>FS_COMP_MON</td><td>CV_BASE_MD_COMPFL_S4</td><td>FS_COMP_MON</td><td>Direct mapping</td></tr>
<tr><td>TBL_WSS_SRP_COMPFLAG</td><td>RX_COMP_MON</td><td>CV_BASE_MD_COMPFL_S4</td><td>RX_COMP_MON</td><td>Direct mapping</td></tr>
<tr><td>TBL_WSS_SRP_COMPFLAG</td><td>FS_COMP_WK</td><td>CV_BASE_MD_COMPFL_S4</td><td>FS_COMP_WK</td><td>Direct mapping</td></tr>
<tr><td>TBL_WSS_SRP_COMPFLAG</td><td>RX_COMP_WK</td><td>CV_BASE_MD_COMPFL_S4</td><td>RX_COMP_WK</td><td>Direct mapping</td></tr>
<tr><td>TBL_WSS_SRP_COMPFLAG</td><td>SNAPSHOT_TIMESTAMP</td><td>Procedure</td><td>CURRENT_TIMESTAMP</td><td>Derived: Current timestamp at insert</td></tr>
<tr><td>TBL_WSS_SRP_COMPFLAG</td><td>CREATED_BY</td><td>Procedure</td><td>SESSION_USER</td><td>Derived: User executing the procedure</td></tr>
</tbody>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%;border-collapse:collapse;">
<tr><td>Number of Objects/Nodes</td><td>6 (Procedure, 2 Calculation Views, 2 Target Tables, 1 Function)</td></tr>
<tr><td>Sources Used</td><td>CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4, SFN_PRIOR_FISCAL_WEEK</td></tr>
<tr><td>Joins</td><td>None identified</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>None identified</td></tr>
<tr><td>Data Manipulation</td><td>DELETE, INSERT (performed on two tables)</td></tr>
<tr><td>Conditional Logic</td><td>WHERE clause in second INSERT (ZWEEK = V_WEEK)</td></tr>
<tr><td>Workflow Complexity</td><td>Medium; sequential variable initialization, deletion, two bulk insertions, and summary output</td></tr>
<tr><td>Performance Considerations</td><td>Bulk DELETE and INSERT operations; dependency on calculation views for source data</td></tr>
<tr><td>Data Volume Handling</td><td>Bulk operations; no explicit volume limits in XML</td></tr>
<tr><td>Dependency Complexity</td><td>Multiple dependencies: calculation views, function, and tables</td></tr>
<tr><td>Overall Complexity Score</td><td>Medium</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
<li>Inserted rows in TBL_WSS_SRP_ATTR_ACT (store attributes)</li>
<li>Inserted rows in TBL_WSS_SRP_COMPFLAG (comparison flags)</li>
<li>Summary output: "Store attribute table loaded & Comp Flag table loaded for V_WEEK"</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
