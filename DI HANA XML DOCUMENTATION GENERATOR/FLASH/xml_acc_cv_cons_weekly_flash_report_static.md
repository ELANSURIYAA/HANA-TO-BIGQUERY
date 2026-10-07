<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:12px;margin-bottom:16px;">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> 2024-06-13<br>
  <b>Description:</b> Technical documentation for the HANA Calculation View <b>CV_CONS_WEEKLY_FLASH_REPORT_STATIC</b>. This view provides a static consumption model for weekly flash reports, aggregating and exposing financial and operational metrics based on the underlying calculation view <b>CV_COMP_FIN_FLASH_COMBINED_STATIC</b>.
</div>

<!-- 1. Overview of Program -->
<p>
This HANA XML defines a <b>Calculation View</b> named <b>CV_CONS_WEEKLY_FLASH_REPORT_STATIC</b>. Its primary purpose is to provide a static consumption view for weekly flash reporting, aggregating financial, budget, and operational metrics. The view projects and maps fields from the underlying calculation view <b>CV_COMP_FIN_FLASH_COMBINED_STATIC</b> and exposes them for reporting.
</p>

<!-- 2. Code Structure and Design -->
<p>
<b>Structure:</b> The Calculation View is structured as a tree-based cube, with a single projection node (<b>WEEKLY_FLASH</b>) sourcing all fields from the calculation view <b>CV_COMP_FIN_FLASH_COMBINED_STATIC</b>. The projection node defines multiple view attributes and measures, which are mapped directly from the source. The logical model specifies attributes, base measures, and two local hierarchical dimensions. <br>
<b>Key Components:</b> Major components include the <b>dataSources</b> section referencing <b>CV_COMP_FIN_FLASH_COMBINED_STATIC</b>, the <b>calculationViews</b> section with the <b>WEEKLY_FLASH</b> projection node, the <b>logicalModel</b> defining attributes and measures, and <b>localDimensions</b> for region and market hierarchies. <br>
<b>Dependencies & Performance:</b> The view depends on the calculation view <b>CV_COMP_FIN_FLASH_COMBINED_STATIC</b>. No joins, unions, filters, or calculated fields are defined within this view. Aggregation is performed on several measures with SUM operations. No explicit performance optimizations or temporary data handling are indicated in the XML.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;background:#fafbfc;padding:16px;border-radius:8px;max-width:100%;">
<style>
.grid-wf { display: grid; grid-template-columns: repeat(4, 220px); grid-auto-rows: 70px; gap: 24px 16px; align-items: center; }
.grid-wf .wf-box { background: #f0f4f8; border-radius: 8px; box-shadow: 0 1px 4px #0001; padding: 16px; text-align: center; font-weight: 500; }
.grid-wf .wf-arrow { text-align: center; font-size: 32px; color: #888; }
</style>
<div class="grid-wf">
  <div class="wf-box" style="grid-column:1;grid-row:1;">CV_COMP_FIN_FLASH_COMBINED_STATIC<br><span style="font-size:13px;color:#666;">(Calculation View)</span></div>
  <div class="wf-arrow" style="grid-column:2;grid-row:1;">&#8594;</div>
  <div class="wf-box" style="grid-column:3;grid-row:1;">Projection Node<br><b>WEEKLY_FLASH</b></div>
  <div class="wf-arrow" style="grid-column:4;grid-row:1;">&#8594;</div>
  <div class="wf-box" style="grid-column:1 / span 4;grid-row:2;">Logical Model<br><span style="font-size:13px;color:#666;">Attributes, Measures, Hierarchies</span></div>
  <div class="wf-box" style="grid-column:1 / span 4;grid-row:3;">Output View<br><span style="font-size:13px;color:#666;">Aggregated for Reporting</span></div>
</div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellspacing="0" cellpadding="5" style="border-collapse:collapse;width:100%;margin-top:12px;">
<tr style="background:#e8f0fe;font-weight:bold;">
  <td>Target Object/Field Name</td>
  <td>Target Column Name</td>
  <td>Source Object/Field Name</td>
  <td>Source Column Name</td>
  <td>Remarks</td>
</tr>
<tr><td>WEEKLY_FLASH.DIVISION_CODE</td><td>DIVISION_CODE</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.DIVISION_CODE</td><td>DIVISION_CODE</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.DIVISION_DESC</td><td>DIVISION_DESC</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.DIVISION_DESC</td><td>DIVISION_DESC</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.REGION_CODE</td><td>REGION_CODE</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.REGION_CODE</td><td>REGION_CODE</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.REGION_DESC</td><td>REGION_DESC</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.REGION_DESC</td><td>REGION_DESC</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.DISTRICT_CODE</td><td>DISTRICT_CODE</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.DISTRICT_CODE</td><td>DISTRICT_CODE</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.DISTRICT_DESC</td><td>DISTRICT_DESC</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.DISTRICT_DESC</td><td>DISTRICT_DESC</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.STRNUM</td><td>STRNUM</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.STRNUM</td><td>STRNUM</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.PRCTR</td><td>PRCTR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.PRCTR</td><td>PRCTR</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.REP_MKT_CODE</td><td>REP_MKT_CODE</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.REP_MKT_CODE</td><td>REP_MKT_CODE</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.REP_MKT_DESC</td><td>REP_MKT_DESC</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.REP_MKT_DESC</td><td>REP_MKT_DESC</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.FS_RX_FLAG</td><td>FS_RX_FLAG</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.FS_RX_FLAG</td><td>FS_RX_FLAG</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH._BIC_ZIO_SWEEK</td><td>_BIC_ZIO_SWEEK</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC._BIC_ZIO_SWEEK</td><td>_BIC_ZIO_SWEEK</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.CAL_FS_SALES</td><td>CAL_FS_SALES</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_FS_SALES</td><td>CAL_FS_SALES</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_SCRIPTS_90AS3</td><td>CAL_SCRIPTS_90AS3</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_SCRIPTS_90AS3</td><td>CAL_SCRIPTS_90AS3</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.EMP_REDUCTIONAMOUNT</td><td>EMP_REDUCTIONAMOUNT</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.EMP_REDUCTIONAMOUNT</td><td>EMP_REDUCTIONAMOUNT</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.FIN_BUDGET_AMOUNT</td><td>FIN_BUDGET_AMOUNT</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.FIN_BUDGET_AMOUNT</td><td>FIN_BUDGET_AMOUNT</td><td>SUM aggregation, currency attribute: FS_BUDGET_CURRENCY</td></tr>
<tr><td>WEEKLY_FLASH.SKF_BUDGET_QTY</td><td>SKF_BUDGET_QTY</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.SKF_BUDGET_QTY</td><td>SKF_BUDGET_QTY</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.FIN_FCST_AMOUNT</td><td>FIN_FCST_AMOUNT</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.FIN_FCST_AMOUNT</td><td>FIN_FCST_AMOUNT</td><td>SUM aggregation, currency attribute: FIN_FORECAST_CURRENCY</td></tr>
<tr><td>WEEKLY_FLASH.SKF_FCST_QTY</td><td>SKF_FCST_QTY</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.SKF_FCST_QTY</td><td>SKF_FCST_QTY</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.FIN_LY_AMOUNT</td><td>FIN_LY_AMOUNT</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.FIN_LY_AMOUNT</td><td>FIN_LY_AMOUNT</td><td>SUM aggregation, currency attribute: FIN_LY_CURRENCY</td></tr>
<tr><td>WEEKLY_FLASH.SKF_LY_QTY</td><td>SKF_LY_QTY</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.SKF_LY_QTY</td><td>SKF_LY_QTY</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_RX_BUDGET</td><td>CAL_RX_BUDGET</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_RX_BUDGET</td><td>CAL_RX_BUDGET</td><td>SUM aggregation, currency attribute: RX_BUDGET_CURRENCY</td></tr>
<tr><td>WEEKLY_FLASH.FS_RX_FLAG_EXT</td><td>FS_RX_FLAG_EXT</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.FS_RX_FLAG_EXT</td><td>FS_RX_FLAG_EXT</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.EMERG_MKT_IND</td><td>EMERG_MKT_IND</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_EMERG_MKT_IND</td><td>CAL_EMERG_MKT_IND</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.ZRWSTRTDATE</td><td>ZRWSTRTDATE</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.ZRWSTRTDATE</td><td>ZRWSTRTDATE</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.ZRWENDDATE</td><td>ZRWENDDATE</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.ZRWENDDATE</td><td>ZRWENDDATE</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.CAL_WEEK_NUMBER</td><td>CAL_WEEK_NUMBER</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_WEEK_NUMBER</td><td>CAL_WEEK_NUMBER</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.CITY</td><td>CITY</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CITY</td><td>CITY</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.STATE</td><td>STATE</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.STATE</td><td>STATE</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.FS_BUDGET_CURRENCY</td><td>FS_BUDGET_CURRENCY</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.FS_BUDGET_CURRENCY</td><td>FS_BUDGET_CURRENCY</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.FIN_LY_CURRENCY</td><td>FIN_LY_CURRENCY</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.FIN_LY_CURRENCY</td><td>FIN_LY_CURRENCY</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.FIN_FORECAST_CURRENCY</td><td>FIN_FORECAST_CURRENCY</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.FIN_FORECAST_CURRENCY</td><td>FIN_FORECAST_CURRENCY</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.RX_BUDGET_CURRENCY</td><td>RX_BUDGET_CURRENCY</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.RX_BUDGET_CURRENCY</td><td>RX_BUDGET_CURRENCY</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.CAL_SKF_LY_VAR</td><td>CAL_SKF_LY_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_SKF_LY_VAR</td><td>CAL_SKF_LY_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_SKF_BUD_VAR</td><td>CAL_SKF_BUD_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_SKF_BUD_VAR</td><td>CAL_SKF_BUD_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_SKF_FORECAST_VAR</td><td>CAL_SKF_FORECAST_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_SKF_FORECAST_VAR</td><td>CAL_SKF_FORECAST_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_RX_BUD_VAR</td><td>CAL_RX_BUD_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_RX_BUD_VAR</td><td>CAL_RX_BUD_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_FS_BUD_VAR</td><td>CAL_FS_BUD_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_FS_BUD_VAR</td><td>CAL_FS_BUD_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_FS_BUD_CORP_VAR</td><td>CAL_FS_BUD_CORP_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_FS_BUD_CORP_VAR</td><td>CAL_FS_BUD_CORP_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_RX_FORECAST_VAR</td><td>CAL_RX_FORECAST_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_RX_FORECAST_VAR</td><td>CAL_RX_FORECAST_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_RX_LY_VAR</td><td>CAL_RX_LY_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_RX_LY_VAR</td><td>CAL_RX_LY_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_FS_FORECAST_VAR</td><td>CAL_FS_FORECAST_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_FS_FORECAST_VAR</td><td>CAL_FS_FORECAST_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_FS_LY_VAR</td><td>CAL_FS_LY_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_FS_LY_VAR</td><td>CAL_FS_LY_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_FS_FORECAST_CORP_VAR</td><td>CAL_FS_FORECAST_CORP_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_FS_FORECAST_CORP_VAR</td><td>CAL_FS_FORECAST_CORP_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_FS_LY_CORP_VAR</td><td>CAL_FS_LY_CORP_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_FS_LY_CORP_VAR</td><td>CAL_FS_LY_CORP_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.PROFIT_CENTER_TEXT</td><td>PROFIT_CENTER_TEXT</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.PROFIT_CENTER_TEXT</td><td>PROFIT_CENTER_TEXT</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.CAL_DATA_CATEGORY1</td><td>CAL_DATA_CATEGORY1</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_DATA_CATEGORY1</td><td>CAL_DATA_CATEGORY1</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.CAL_DATA_CATEGORY2</td><td>CAL_DATA_CATEGORY2</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_DATA_CATEGORY2</td><td>CAL_DATA_CATEGORY2</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.FS_OPEN_DAT</td><td>FS_OPEN_DAT</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.FS_OPEN_DAT</td><td>FS_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.RX_OPEN_DAT</td><td>RX_OPEN_DAT</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.RX_OPEN_DAT</td><td>RX_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_FS_BUDGET_AMOUNT</td><td>CAL_COMP_FS_BUDGET_AMOUNT</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_FS_BUDGET_AMOUNT</td><td>CAL_COMP_FS_BUDGET_AMOUNT</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_RX_BUDGET_AMOUNT</td><td>CAL_COMP_RX_BUDGET_AMOUNT</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_RX_BUDGET_AMOUNT</td><td>CAL_COMP_RX_BUDGET_AMOUNT</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_CORPFS_SALES_AMOUNT</td><td>CAL_COMP_CORPFS_SALES_AMOUNT</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_CORPFS_SALES_AMOUNT</td><td>CAL_COMP_CORPFS_SALES_AMOUNT</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_FS_SALESAMOUNT</td><td>CAL_COMP_FS_SALESAMOUNT</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_FS_SALESAMOUNT</td><td>CAL_COMP_FS_SALESAMOUNT</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_RX_SALESAMOUNT</td><td>CAL_COMP_RX_SALESAMOUNT</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_RX_SALESAMOUNT</td><td>CAL_COMP_RX_SALESAMOUNT</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_BUDGET_90AS3</td><td>CAL_COMP_BUDGET_90AS3</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_BUDGET_90AS3</td><td>CAL_COMP_BUDGET_90AS3</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_FLASH_90AS3</td><td>CAL_COMP_FLASH_90AS3</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_FLASH_90AS3</td><td>CAL_COMP_FLASH_90AS3</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_FORECAST_AMOUNT</td><td>CAL_COMP_FORECAST_AMOUNT</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_FORECAST_AMOUNT</td><td>CAL_COMP_FORECAST_AMOUNT</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_FORECAST_90AS3</td><td>CAL_COMP_FORECAST_90AS3</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_FORECAST_90AS3</td><td>CAL_COMP_FORECAST_90AS3</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_LY_AMOUNT</td><td>CAL_COMP_LY_AMOUNT</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_LY_AMOUNT</td><td>CAL_COMP_LY_AMOUNT</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_LY_90AS3</td><td>CAL_COMP_LY_90AS3</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_LY_90AS3</td><td>CAL_COMP_LY_90AS3</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_FS_BUD_VAR</td><td>CAL_COMP_FS_BUD_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_FS_BUD_VAR</td><td>CAL_COMP_FS_BUD_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_FS_FORECAST_VAR</td><td>CAL_COMP_FS_FORECAST_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_FS_FORECAST_VAR</td><td>CAL_COMP_FS_FORECAST_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_FS_LY_VAR</td><td>CAL_COMP_FS_LY_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_FS_LY_VAR</td><td>CAL_COMP_FS_LY_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_RX_BUD_VAR</td><td>CAL_COMP_RX_BUD_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_RX_BUD_VAR</td><td>CAL_COMP_RX_BUD_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_RX_FORECAST_VAR</td><td>CAL_COMP_RX_FORECAST_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_RX_FORECAST_VAR</td><td>CAL_COMP_RX_FORECAST_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_RX_LY_VAR</td><td>CAL_COMP_RX_LY_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_RX_LY_VAR</td><td>CAL_COMP_RX_LY_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_SKF_FORECAST_VAR</td><td>CAL_COMP_SKF_FORECAST_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_SKF_FORECAST_VAR</td><td>CAL_COMP_SKF_FORECAST_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_SKF_BUD_VAR</td><td>CAL_COMP_SKF_BUD_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_SKF_BUD_VAR</td><td>CAL_COMP_SKF_BUD_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_SKF_LY_VAR</td><td>CAL_COMP_SKF_LY_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_SKF_LY_VAR</td><td>CAL_COMP_SKF_LY_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_FS_BUD_CORP_VAR</td><td>CAL_COMP_FS_BUD_CORP_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_FS_BUD_CORP_VAR</td><td>CAL_COMP_FS_BUD_CORP_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_FS_FORECAST_CORP_VAR</td><td>CAL_COMP_FS_FORECAST_CORP_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_FS_FORECAST_CORP_VAR</td><td>CAL_COMP_FS_FORECAST_CORP_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_FS_LY_CORP_VAR</td><td>CAL_COMP_FS_LY_CORP_VAR</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_FS_LY_CORP_VAR</td><td>CAL_COMP_FS_LY_CORP_VAR</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CAL_COMP_FLAG</td><td>CAL_COMP_FLAG</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_COMP_FLAG</td><td>CAL_COMP_FLAG</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.SKF_MJE_QTY</td><td>SKF_MJE_QTY</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.SKF_MJE_QTY</td><td>SKF_MJE_QTY</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.CAL_FS_SALES_MJE</td><td>CAL_FS_SALES_MJE</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_FS_SALES_MJE</td><td>CAL_FS_SALES_MJE</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.CAL_RX_SALES_MJE</td><td>CAL_RX_SALES_MJE</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_RX_SALES_MJE</td><td>CAL_RX_SALES_MJE</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.CAL_RX_SALES</td><td>CAL_RX_SALES</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_RX_SALES</td><td>CAL_RX_SALES</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.SBT</td><td>SBT</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.SBT</td><td>SBT</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.SEGMENT</td><td>SEGMENT</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.SEGMENT</td><td>SEGMENT</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.DESCRIPTION</td><td>DESCRIPTION</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.DESCRIPTION</td><td>DESCRIPTION</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.SC_90AS1_BUD</td><td>SC_90AS1_BUD</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.SC_90AS1_BUD</td><td>SC_90AS1_BUD</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.SC_90AS1_FCT</td><td>SC_90AS1_FCT</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.SC_90AS1_FCT</td><td>SC_90AS1_FCT</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.SC_90AS1_FLASH</td><td>SC_90AS1_FLASH</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.SC_90AS1_FLASH</td><td>SC_90AS1_FLASH</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.SC_90AS1_LY</td><td>SC_90AS1_LY</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.SC_90AS1_LY</td><td>SC_90AS1_LY</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.SALES_SOURCE</td><td>SALES_SOURCE</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.SALES_SOURCE</td><td>SALES_SOURCE</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.AREA_CODE</td><td>AREA_CODE</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.AREA_CODE</td><td>AREA_CODE</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.AREA_DESC</td><td>AREA_DESC</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.AREA_DESC</td><td>AREA_DESC</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.FIN_BUD_CUBE</td><td>FIN_BUD_CUBE</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.FIN_BUD_CUBE</td><td>FIN_BUD_CUBE</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.SKF_BUD_CUBE</td><td>SKF_BUD_CUBE</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.SKF_BUD_CUBE</td><td>SKF_BUD_CUBE</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.CAL_CVD_UNITS</td><td>CAL_CVD_UNITS</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CAL_CVD_UNITS</td><td>CAL_CVD_UNITS</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.CVD_AMOUNT</td><td>CVD_AMOUNT</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.CVD_AMOUNT</td><td>CVD_AMOUNT</td><td>SUM aggregation</td></tr>
<tr><td>WEEKLY_FLASH.RX_DIVISION_CODE</td><td>RX_DIVISION_CODE</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.RX_DIVISION_CODE</td><td>RX_DIVISION_CODE</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.RX_AREA_CODE</td><td>RX_AREA_CODE</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.RX_AREA_CODE</td><td>RX_AREA_CODE</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.RX_REGION_CODE</td><td>RX_REGION_CODE</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.RX_REGION_CODE</td><td>RX_REGION_CODE</td><td>Direct mapping</td></tr>
<tr><td>WEEKLY_FLASH.RX_DISTRICT_CODE</td><td>RX_DISTRICT_CODE</td><td>CV_COMP_FIN_FLASH_COMBINED_STATIC.RX_DISTRICT_CODE</td><td>RX_DISTRICT_CODE</td><td>Direct mapping</td></tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellspacing="0" cellpadding="5" style="border-collapse:collapse;width:70%;margin-top:12px;">
<tr style="background:#e8f0fe;font-weight:bold;">
  <td>Category</td>
  <td>Measurement</td>
</tr>
<tr><td>Number of Objects/Nodes</td><td>3 (Calculation View, Projection Node, Logical Model)</td></tr>
<tr><td>Sources Used</td><td>1 (CV_COMP_FIN_FLASH_COMBINED_STATIC)</td></tr>
<tr><td>Joins</td><td>None identified</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>SUM aggregation on multiple measures</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>None identified</td></tr>
<tr><td>Workflow Complexity</td><td>Simple linear flow: source &rarr; projection &rarr; logical model &rarr; output</td></tr>
<tr><td>Performance Considerations</td><td>Aggregation on measures, direct field mapping; no explicit performance optimizations</td></tr>
<tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
<tr><td>Dependency Complexity</td><td>Single dependency on CV_COMP_FIN_FLASH_COMBINED_STATIC</td></tr>
<tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>Attributes and measures projected from CV_COMP_FIN_FLASH_COMBINED_STATIC</li>
  <li>Aggregated financial, budget, and operational metrics</li>
  <li>Hierarchical region and market dimensions</li>
  <li>Static output view for weekly flash reporting</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
