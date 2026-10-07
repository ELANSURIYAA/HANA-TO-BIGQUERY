<!-- DOCUMENT HEADER -->
<table>
<tr><td><b>Author:</b></td><td>Ascendion AAVA</td></tr>
<tr><td><b>Created On:</b></td><td>2026-10-07</td></tr>
<tr><td><b>Description:</b></td><td>This documentation describes the HANA SQLScript Procedure "CVS_FRIP"."CVS_FRIP.Procedure.FI::STP_WSS_FLASH_SALES". The procedure takes a weekly snapshot of CAR data, performing data extraction and insertion into the target table "CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_FLASH_SALES" based on specified date and timestamp logic. The source data is retrieved from the composite view "_SYS_BIC"."CVS_FRIP.Composite.FI/CV_COMP_FIN_FLASH".</td></tr>
</table>

<!-- 1. OVERVIEW OF PROGRAM -->
<p>
This HANA object is a SQLScript Procedure. Its primary purpose is to capture a weekly snapshot of CAR data every Monday at 5am and insert it into a target table. The procedure extracts processed data from a composite view, applies date and timestamp logic, and loads the results into the target table.
</p>

<!-- 2. CODE STRUCTURE AND DESIGN -->
<p>
<b>Structure:</b> The procedure declares several variables for date and timestamp calculations, including V_CURRENT_DATE, V_ADJ, V_WEEK_ENDING_FROM_DATE, V_WEEK_ENDING_TO_DATE, V_UPDATE_TIMESTAMP_FROM, and V_UPDATE_TIMESTAMP_TO. The logic calculates the business week boundaries and timestamp ranges, deletes existing data from the target table, and inserts new data by selecting from the composite view with placeholders for date and timestamp parameters.<br>
<b>Key Components:</b> Major components include variable declarations and initializations, calculation of week-ending dates and update timestamps, deletion from the target table, insertion into the target table using a SELECT statement with mapped fields, and parameterized placeholders for filtering source data. The procedure also includes a log output for audit purposes.<br>
<b>Dependencies & Performance:</b> The procedure depends on the composite view "_SYS_BIC"."CVS_FRIP.Composite.FI/CV_COMP_FIN_FLASH" as the source and the table "CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_FLASH_SALES" as the target. Data manipulation is performed through DELETE and INSERT statements. Performance considerations include the wide timestamp range and parameterized filtering, which may impact data volume processed but are strictly defined by the procedure logic.
</p>

<!-- 3. DATA FLOW AND PROCESSING LOGIC -->
<div style="overflow-x:auto; padding:10px; background:#f8f9fa;">
<div style="display:grid; grid-template-columns:repeat(4, 220px); grid-auto-rows:120px; gap:20px; align-items:center;">

<!-- Step 1: Variable Initialization -->
<div style="grid-column:1; grid-row:1; background:#e3e6ef; border-radius:8px; box-shadow:0 1px 4px #bbb; text-align:center; padding:16px;">Variable Initialization<br/>(V_CURRENT_DATE, V_ADJ, V_WEEK_ENDING_FROM_DATE,<br/>V_WEEK_ENDING_TO_DATE, V_UPDATE_TIMESTAMP_FROM,<br/>V_UPDATE_TIMESTAMP_TO)</div>
<!-- Arrow -->
<div style="grid-column:2; grid-row:1; text-align:center;">➡️</div>

<!-- Step 2: Calculate Date & Timestamp Ranges -->
<div style="grid-column:3; grid-row:1; background:#e3e6ef; border-radius:8px; box-shadow:0 1px 4px #bbb; text-align:center; padding:16px;">Calculate Week Ending Dates &<br/>Timestamp Ranges</div>
<!-- Arrow -->
<div style="grid-column:4; grid-row:1; text-align:center;">➡️</div>

<!-- Step 3: Delete Target Table Data -->
<div style="grid-column:1; grid-row:2; background:#e3e6ef; border-radius:8px; box-shadow:0 1px 4px #bbb; text-align:center; padding:16px;">Delete Existing Data<br/>from Target Table<br/>("CVS_FRIP.Table::TBL_WSS_FLASH_SALES")</div>
<!-- Arrow -->
<div style="grid-column:2; grid-row:2; text-align:center;">➡️</div>

<!-- Step 4: Data Extraction & Insertion -->
<div style="grid-column:3; grid-row:2; background:#e3e6ef; border-radius:8px; box-shadow:0 1px 4px #bbb; text-align:center; padding:16px;">Extract Data from Composite View<br/>("_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH")<br/>with Placeholders<br/>Insert into Target Table</div>
<!-- Arrow -->
<div style="grid-column:4; grid-row:2; text-align:center;">➡️</div>

<!-- Step 5: Audit Log Output -->
<div style="grid-column:1; grid-row:3; background:#e3e6ef; border-radius:8px; box-shadow:0 1px 4px #bbb; text-align:center; padding:16px;">Audit Log Output<br/>(Week Ending Date,<br/>Week Starting Date,<br/>Update Date From,<br/>Update Date To)</div>
</div>
</div>

<!-- 4. DATA MAPPING -->
<table border="1" cellpadding="6" style="border-collapse:collapse;">
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
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>MANDT</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>MANDT</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>RETAILSTOREID</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>RETAILSTOREID</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>PRCTR</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>PRCTR</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>BUSINESSDAYDATE</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>BUSINESSDAYDATE</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>ZZWEEK</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>ZZWEEK</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>ZRYEAR</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>ZRYEAR</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>ZRPERIOD</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>ZRPERIOD</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>ZRYRP</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>ZRYRP</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>CAL_WEEK_ENDING_DATE</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>CAL_WEEK_ENDING_DATE</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>FS_COMP_WK</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>FS_COMP_WK</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>RX_COMP_WK</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>RX_COMP_WK</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>EMERG_MKT_IND</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>EMERG_MKT_IND</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>REP_MKT_CODE</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>REP_MKT_CODE</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>REP_MKT_DESC</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>REP_MKT_DESC</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>CAL_COMP_FLAG</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>CAL_COMP_FLAG</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>DIVISION_CODE</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>DIVISION_CODE</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>DIVISION_DESC</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>DIVISION_DESC</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>REGION_CODE</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>REGION_CODE</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>REGION_DESC</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>REGION_DESC</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>DISTRICT_CODE</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>DISTRICT_CODE</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>DISTRICT_DESC</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>DISTRICT_DESC</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>RX_DIVISION_CODE</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>RX_DIVISION_CODE</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>RX_AREA_CODE</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>RX_AREA_CODE</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>RX_REGION_CODE</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>RX_REGION_CODE</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>RX_DISTRICT_CODE</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>RX_DISTRICT_CODE</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>ZRWENDDATE</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>ZRWENDDATE</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>ZRWSTRTDATE</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>ZRWSTRTDATE</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>CAL_WEEK_NUMBER</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>CAL_WEEK_NUMBER</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>CITY</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>CITY</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>STATE</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>STATE</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>FS_SALESAMOUNT</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>FS_SALESAMOUNT</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>REDUCTIONAMOUNT</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>REDUCTIONAMOUNT</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>RX_SALESAMOUNT</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>RX_SALESAMOUNT</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>CAL_FS_UNITS</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>CAL_FS_UNITS</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>CAL_RX_CNT_GE84_NS</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>CAL_RX_CNT_GE84_NS</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>CAL_RX_CNT_GE84_RE</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>CAL_RX_CNT_GE84_RE</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>CAL_SCRIPTS_90AS3</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>CAL_SCRIPTS_90AS3</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>CAL_RX_CNT_NS</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>CAL_RX_CNT_NS</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>CAL_RX_CNT_RE</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>CAL_RX_CNT_RE</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>EMP_REDUCTIONAMOUNT</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>EMP_REDUCTIONAMOUNT</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>PROFIT_CENTER_TEXT</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>PROFIT_CENTER_TEXT</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>FS_OPEN_DAT</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>FS_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>RX_OPEN_DAT</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>RX_OPEN_DAT</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>RX_UPD_TIMESTAMP</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>RX_UPD_TIMESTAMP</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>FS_UPD_TIMESTAMP</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>FS_UPD_TIMESTAMP</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>SCRIPTS_UPD_TIMESTAMP</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>SCRIPTS_UPD_TIMESTAMP</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>ZZ_UPD_TIMESTAMP</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>ZZ_UPD_TIMESTAMP</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>SNAPSHOT_TIMESTAMP</td><td>Procedure</td><td>CURRENT_TIMESTAMP</td><td>Derived: uses CURRENT_TIMESTAMP</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>CREATED_BY</td><td>Procedure</td><td>SESSION_USER</td><td>Derived: uses SESSION_USER</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>TRANSCURRENCY</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>TRANSCURRENCY</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>AREA_CODE</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>AREA_CODE</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>AREA_DESC</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>AREA_DESC</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>CVD_AMOUNT</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>CVD_AMOUNT</td><td>Direct mapping</td></tr>
<tr><td>CVS_FRIP.Table::TBL_WSS_FLASH_SALES</td><td>CAL_CVD_UNITS</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td><td>CAL_CVD_UNITS</td><td>Direct mapping</td></tr>
</tbody>
</table>

<!-- 5. COMPLEXITY ANALYSIS -->
<table border="1" cellpadding="6" style="border-collapse:collapse;">
<tr><td>Number of Objects/Nodes</td><td>3 (Procedure, Source Composite View, Target Table)</td></tr>
<tr><td>Sources Used</td><td>_SYS_BIC.Composite.FI/CV_COMP_FIN_FLASH</td></tr>
<tr><td>Joins</td><td>None identified</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>None identified</td></tr>
<tr><td>Data Manipulation</td><td>DELETE, INSERT</td></tr>
<tr><td>Conditional Logic</td><td>Conditional timestamp calculations and variable assignments</td></tr>
<tr><td>Workflow Complexity</td><td>Linear workflow with parameterized filtering and direct data manipulation</td></tr>
<tr><td>Performance Considerations</td><td>Wide timestamp range, parameterized filtering, bulk data manipulation</td></tr>
<tr><td>Data Volume Handling</td><td>Bulk deletion and insertion based on weekly snapshot logic</td></tr>
<tr><td>Dependency Complexity</td><td>Depends on source composite view and target table</td></tr>
<tr><td>Overall Complexity Score</td><td>Medium</td></tr>
</table>

<!-- 6. SENSITIVE AND PRIVACY DATA ASSESSMENT -->
No sensitive data found

<!-- 7. KEY OUTPUTS -->
<ul>
<li>Weekly snapshot data inserted into "CVS_FRIP.Table::TBL_WSS_FLASH_SALES"</li>
<li>Audit log output: Week Ending Date, Week Starting Date, Update Date From, Update Date To</li>
</ul>

<!-- 8. API COST CALCULATIONS -->
API COST : 0.0000 USD
