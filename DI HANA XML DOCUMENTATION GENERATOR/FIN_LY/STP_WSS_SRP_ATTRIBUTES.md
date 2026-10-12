<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ddd;padding-bottom:10px;margin-bottom:20px">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> 2026-10-12<br>
  <b>Description:</b> This documentation covers the HANA SQLScript Procedure "CVS_FRIP"."CVS_FRIP.Procedure.FI::STP_WSS_SRP_ATTRIBUTES". The procedure inserts data from calculation views into target tables, managing store attribute and comparison flag data for a specified fiscal week.
</div>

<!-- 1. OVERVIEW OF PROGRAM -->
<div style="margin-bottom:20px">
  <b>Overview of Program:</b><br>
  This HANA object is a SQLScript Procedure designed to insert data into two target tables from two calculation views. Its primary function is to load store attribute and comparison flag data for a prior fiscal week, performing deletion and insertion operations as part of the processing logic.
</div>

<!-- 2. CODE STRUCTURE AND DESIGN -->
<div style="margin-bottom:20px">
  <b>Structure:</b> The procedure declares two variables for week handling, initializes the current fiscal week, deletes existing data from two target tables, and then inserts data from two calculation views into these tables. The processing sequence is linear and consists of variable initialization, data deletion, and data insertion steps.
  <b>Key Components:</b> Major components include variable declarations (V_WEEK, V_LY_WEEK), invocation of the composite function SFN_PRIOR_FISCAL_WEEK, deletion statements for TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG, and insertion statements from CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_COMPFL_S4 calculation views. The procedure also produces a summary output.
  <b>Dependencies & Performance:</b> Dependencies include calculation views "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4" and "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4", the composite function "CVS_FRIP"."CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK", and target tables "CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT" and "CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG". Performance-relevant characteristics include batch deletion and insertion, and filtering by fiscal week in the second insert.
</div>

<!-- 3. DATA FLOW AND PROCESSING LOGIC -->
<div style="overflow:auto;max-width:100%;padding:10px;background:#f9f9f9;border-radius:8px">
  <style>
    .workflow-grid {
      display: grid;
      grid-template-columns: repeat(4, 220px);
      grid-auto-rows: 80px;
      gap: 24px 16px;
      align-items: center;
      justify-content: start;
    }
    .workflow-box {
      background: #fff;
      border-radius: 6px;
      box-shadow: 0 1px 4px #ddd;
      padding: 14px;
      font-family: Arial, sans-serif;
      font-size: 13px;
      text-align: center;
      border-left: 4px solid #2a7be4;
      position: relative;
    }
    .workflow-arrow {
      width: 40px;
      height: 2px;
      background: #2a7be4;
      margin-left: 180px;
      margin-top: -40px;
      margin-bottom: 40px;
    }
    .workflow-connector {
      grid-column: span 1;
      text-align: center;
      font-size: 18px;
      color: #2a7be4;
      margin-top: -20px;
    }
  </style>
  <div class="workflow-grid">
    <div class="workflow-box" style="grid-column:1;grid-row:1">Start Procedure</div>
    <div class="workflow-connector" style="grid-column:2;grid-row:1">&#8594;</div>
    <div class="workflow-box" style="grid-column:3;grid-row:1">Declare V_WEEK, V_LY_WEEK</div>
    <div class="workflow-connector" style="grid-column:4;grid-row:1">&#8594;</div>

    <div class="workflow-box" style="grid-column:1;grid-row:2">Initialize V_WEEK<br>SFN_PRIOR_FISCAL_WEEK()</div>
    <div class="workflow-connector" style="grid-column:2;grid-row:2">&#8594;</div>
    <div class="workflow-box" style="grid-column:3;grid-row:2">Delete from TBL_WSS_SRP_ATTR_ACT</div>
    <div class="workflow-connector" style="grid-column:4;grid-row:2">&#8594;</div>

    <div class="workflow-box" style="grid-column:1;grid-row:3">Delete from TBL_WSS_SRP_COMPFLAG</div>
    <div class="workflow-connector" style="grid-column:2;grid-row:3">&#8594;</div>
    <div class="workflow-box" style="grid-column:3;grid-row:3">Insert into TBL_WSS_SRP_ATTR_ACT<br>From CV_BASE_MD_SRPACT_S4</div>
    <div class="workflow-connector" style="grid-column:4;grid-row:3">&#8594;</div>

    <div class="workflow-box" style="grid-column:1;grid-row:4">Insert into TBL_WSS_SRP_COMPFLAG<br>From CV_BASE_MD_COMPFL_S4<br>Where ZWEEK = V_WEEK</div>
    <div class="workflow-connector" style="grid-column:2;grid-row:4">&#8594;</div>
    <div class="workflow-box" style="grid-column:3;grid-row:4">Output Summary</div>
    <div class="workflow-connector" style="grid-column:4;grid-row:4">&#8594;</div>
    <div class="workflow-box" style="grid-column:1;grid-row:5">End Procedure</div>
  </div>
</div>

<!-- 4. DATA MAPPING -->
<table border="1" cellpadding="6" style="border-collapse:collapse;width:100%;margin-bottom:20px">
  <tr>
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
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>SNAPSHOT_TIMESTAMP</td><td>Procedure</td><td>CURRENT_TIMESTAMP</td><td>Derived: CURRENT_TIMESTAMP</td></tr>
  <tr><td>TBL_WSS_SRP_ATTR_ACT</td><td>SNAPSHOT_CREATED_BY</td><td>Procedure</td><td>SESSION_USER</td><td>Derived: SESSION_USER</td></tr>
  <!-- TBL_WSS_SRP_COMPFLAG Mappings -->
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
  <tr><td>TBL_WSS_SRP_COMPFLAG</td><td>SNAPSHOT_TIMESTAMP</td><td>Procedure</td><td>CURRENT_TIMESTAMP</td><td>Derived: CURRENT_TIMESTAMP</td></tr>
  <tr><td>TBL_WSS_SRP_COMPFLAG</td><td>CREATED_BY</td><td>Procedure</td><td>SESSION_USER</td><td>Derived: SESSION_USER</td></tr>
</table>

<!-- 5. COMPLEXITY ANALYSIS -->
<table border="1" cellpadding="6" style="border-collapse:collapse;width:100%;margin-bottom:20px">
  <tr><th>Category</th><th>Measurement</th></tr>
  <tr><td>Number of Objects/Nodes</td><td>7 (Procedure, 2 Calculation Views, 2 Target Tables, 1 Composite Function, 2 Declared Variables)</td></tr>
  <tr><td>Sources Used</td><td>CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4, SFN_PRIOR_FISCAL_WEEK</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None identified</td></tr>
  <tr><td>Data Manipulation</td><td>DELETE, INSERT</td></tr>
  <tr><td>Conditional Logic</td><td>WHERE clause filtering by V_WEEK</td></tr>
  <tr><td>Workflow Complexity</td><td>Linear sequence with multiple data manipulation steps</td></tr>
  <tr><td>Performance Considerations</td><td>Batch deletion and insertion; filtering by fiscal week</td></tr>
  <tr><td>Data Volume Handling</td><td>Not explicitly handled in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Multiple dependencies: calculation views, function, and target tables</td></tr>
  <tr><td>Overall Complexity Score</td><td>Medium</td></tr>
</table>

<!-- 6. SENSITIVE AND PRIVACY DATA ASSESSMENT -->
No sensitive data found

<!-- 7. KEY OUTPUTS -->
<ul>
  <li>Rows inserted into TBL_WSS_SRP_ATTR_ACT with mapped fields and derived columns SNAPSHOT_TIMESTAMP, SNAPSHOT_CREATED_BY</li>
  <li>Rows inserted into TBL_WSS_SRP_COMPFLAG with mapped fields and derived columns SNAPSHOT_TIMESTAMP, CREATED_BY</li>
  <li>Summary output: 'Store attribute table loaded & Comp Flag table loaded for '||V_WEEK</li>
</ul>

<!-- 8. API COST CALCULATIONS -->
API COST : 0.0000 USD
