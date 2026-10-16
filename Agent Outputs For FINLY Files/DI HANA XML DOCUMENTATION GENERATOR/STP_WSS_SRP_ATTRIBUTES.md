<!-- DOCUMENT HEADER -->
<table>
  <tr><td><b>Author:</b></td><td>Ascendion AAVA</td></tr>
  <tr><td><b>Created On:</b></td><td>2026-10-16</td></tr>
  <tr><td><b>Description:</b></td><td>This HANA SQLScript Procedure inserts and manages store attribute and competitive flag data in target tables, using data sourced from calculation views. The procedure initializes variables, deletes existing records, and loads fresh data from calculation views into the target tables, supporting reporting and analytical needs.</td></tr>
</table>

<!-- 1. Overview of Program -->
<p>This object is a HANA SQLScript Procedure. Its primary purpose is to populate two target tables with store attributes and competitive flag data by extracting, transforming, and loading data from calculation views. The procedure handles variable initialization, data deletion, and data insertion operations based on calculation view sources.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The procedure declares variables, initializes the fiscal week via a scalar function call, deletes existing records from two target tables, and then performs two insert operations using SELECT statements from calculation views. <b>Key Components:</b> The major components are variable declarations (<code>V_WEEK</code>, <code>V_LY_WEEK</code>), a call to a scalar function to determine the prior fiscal week, DELETE operations for cleaning target tables, and INSERT operations that map and transfer fields from calculation views (<code>CV_BASE_MD_SRPACT_S4</code> and <code>CV_BASE_MD_COMPFL_S4</code>) into target tables (<code>TBL_WSS_SRP_ATTR_ACT</code> and <code>TBL_WSS_SRP_COMPFLAG</code>). <b>Dependencies & Performance:</b> The procedure depends on two calculation views and a scalar function. It utilizes direct field mapping and filtering (WHERE clause on ZWEEK), with no complex joins or aggregations, and manages data freshness by truncating and reloading target tables.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; background:#f8f8fa; padding:24px; border-radius:10px;">
  <div style="display:grid; grid-template-columns:repeat(5, 220px); grid-template-rows:repeat(6, 75px); align-items:center; justify-items:center; gap:16px;">
    <!-- Row 1 -->
    <div style="grid-column:1; grid-row:1; background:#e7edf8; border-radius:8px; padding:12px; border:1px solid #c3d0e8;">Scalar Function<br><b>SFN_PRIOR_FISCAL_WEEK</b></div>
    <div style="grid-column:2; grid-row:1; background:#e7edf8; border-radius:8px; padding:12px; border:1px solid #c3d0e8;">Calculation View<br><b>CV_BASE_MD_SRPACT_S4</b></div>
    <div style="grid-column:4; grid-row:1; background:#e7edf8; border-radius:8px; padding:12px; border:1px solid #c3d0e8;">Calculation View<br><b>CV_BASE_MD_COMPFL_S4</b></div>
    <!-- Row 2 -->
    <div style="grid-column:1; grid-row:2; background:#f7f7f7; border-radius:8px; padding:12px; border:1px solid #d4d4d4;">Variable<br><b>V_WEEK</b></div>
    <!-- Row 3 -->
    <div style="grid-column:3; grid-row:3; background:#f7f7f7; border-radius:8px; padding:12px; border:1px solid #d4d4d4;">Delete<br><b>TBL_WSS_SRP_ATTR_ACT</b></div>
    <div style="grid-column:5; grid-row:3; background:#f7f7f7; border-radius:8px; padding:12px; border:1px solid #d4d4d4;">Delete<br><b>TBL_WSS_SRP_COMPFLAG</b></div>
    <!-- Row 4 -->
    <div style="grid-column:2; grid-row:4; background:#c8e6c9; border-radius:8px; padding:12px; border:1px solid #aedfa3;">Insert<br><b>TBL_WSS_SRP_ATTR_ACT</b></div>
    <div style="grid-column:4; grid-row:4; background:#c8e6c9; border-radius:8px; padding:12px; border:1px solid #aedfa3;">Insert<br><b>TBL_WSS_SRP_COMPFLAG</b></div>
    <!-- Row 5 -->
    <div style="grid-column:2; grid-row:5; background:#fffde7; border-radius:8px; padding:12px; border:1px solid #f7e9b5;">Output<br><b>Summary</b></div>
    <!-- Arrows -->
    <div style="grid-column:1; grid-row:1/3; justify-self:end; align-self:center; font-size:32px; color:#90a4ae;">&#8595;</div>
    <div style="grid-column:2; grid-row:1/4; justify-self:center; align-self:center; font-size:32px; color:#90a4ae;">&#8595;</div>
    <div style="grid-column:4; grid-row:1/4; justify-self:center; align-self:center; font-size:32px; color:#90a4ae;">&#8595;</div>
    <div style="grid-column:3; grid-row:3/5; justify-self:center; align-self:center; font-size:32px; color:#90a4ae;">&#8595;</div>
    <div style="grid-column:5; grid-row:3/5; justify-self:center; align-self:center; font-size:32px; color:#90a4ae;">&#8595;</div>
    <div style="grid-column:2; grid-row:4/6; justify-self:center; align-self:center; font-size:32px; color:#90a4ae;">&#8595;</div>
    <div style="grid-column:4; grid-row:4/6; justify-self:center; align-self:center; font-size:32px; color:#90a4ae;">&#8595;</div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse:collapse;">
<thead>
<tr>
<th>Target Object/Field Name</th><th>Target Column Name</th><th>Source Object/Field Name</th><th>Source Column Name</th><th>Remarks</th>
</tr>
</thead>
<tbody>
<!-- TBL_WSS_SRP_ATTR_ACT Mapping -->
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
<tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>SNAPSHOT_TIMESTAMP</td><td>Generated</td><td>CURRENT_TIMESTAMP</td><td>System timestamp at insert</td></tr>
<tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>SNAPSHOT_CREATED_BY</td><td>Generated</td><td>SESSION_USER</td><td>Current session user</td></tr>
<!-- TBL_WSS_SRP_COMPFLAG Mapping -->
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
<tr><td>TBL_WSS_SRP_COMPFLAG</td><td>SNAPSHOT_TIMESTAMP</td><td>Generated</td><td>CURRENT_TIMESTAMP</td><td>System timestamp at insert</td></tr>
<tr><td>TBL_WSS_SRP_COMPFLAG</td><td>CREATED_BY</td><td>Generated</td><td>SESSION_USER</td><td>Current session user</td></tr>
</tbody>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse:collapse;">
<tr><td>Number of Objects/Nodes</td><td>7 (Procedure, 2 Calculation Views, 2 Tables, 1 Scalar Function, 1 DUMMY table)</td></tr>
<tr><td>Sources Used</td><td>CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4, SFN_PRIOR_FISCAL_WEEK</td></tr>
<tr><td>Joins</td><td>None identified</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>None identified</td></tr>
<tr><td>Data Manipulation</td><td>DELETE, INSERT</td></tr>
<tr><td>Conditional Logic</td><td>WHERE clause on ZWEEK = V_WEEK</td></tr>
<tr><td>Workflow Complexity</td><td>Medium; sequential deletes and inserts, variable initialization, and use of calculation views</td></tr>
<tr><td>Performance Considerations</td><td>Table truncation and reload, dependency on calculation views, direct mapping, filter on ZWEEK</td></tr>
<tr><td>Data Volume Handling</td><td>Not explicitly described in the XML</td></tr>
<tr><td>Dependency Complexity</td><td>Depends on 2 calculation views and 1 scalar function</td></tr>
<tr><td>Overall Complexity Score</td><td>Medium</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>Rows inserted into TBL_WSS_SRP_ATTR_ACT with mapped store attribute fields and system-generated metadata</li>
  <li>Rows inserted into TBL_WSS_SRP_COMPFLAG with mapped competitive flag fields filtered by fiscal week and system-generated metadata</li>
  <li>Summary output indicating load completion for the selected week</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
