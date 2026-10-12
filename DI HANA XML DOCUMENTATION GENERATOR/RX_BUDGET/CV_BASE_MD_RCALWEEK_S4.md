<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:8px;margin-bottom:12px;">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> {{CURRENT_DATE}}<br>
  <b>Description:</b> Base View for ZTFIGL_RCALWEEK - Retail Calendar Week Master Data. This HANA Calculation View provides a dimensional representation of retail calendar week data sourced from the ZTFIGL_RCALWEEK database table, enabling structured access to week, period, year, and date attributes.
</div>

<!-- 1. OVERVIEW OF PROGRAM -->
<p>This object is a HANA Calculation View of type DIMENSION. Its primary purpose is to expose retail calendar week master data attributes from the ZTFIGL_RCALWEEK table. The view applies a filter on the RCLNT attribute and projects relevant week, period, year, and date fields for downstream consumption.</p>

<!-- 2. CODE STRUCTURE AND DESIGN -->
<p>
  <b>Structure:</b> The Calculation View is defined as a TREE_BASED scenario with a single Projection node (Projection_1) sourcing data from the ZTFIGL_RCALWEEK table. The Projection node selects and filters fields, with the RCLNT attribute filtered for values 120 and 200. No joins, unions, calculated fields, or aggregations are present.<br>
  <b>Key Components:</b> The main components are the Projection node, the ZTFIGL_RCALWEEK data source, and the output attributes including RCLNT, ZZWEEK, ZCALYRP, ZRYEAR, ZRPERIOD, ZRYRP, ZRYRQTR, ZRWSTRTDATE, and ZRWENDDATE. Logical mapping is performed from the source table fields to the output attributes.<br>
  <b>Dependencies & Performance:</b> The Calculation View depends solely on the ZTFIGL_RCALWEEK table. No performance-impacting joins, aggregations, or calculated fields are present; the only processing is attribute filtering and projection, indicating low complexity and minimal dependency.
</p>

<!-- 3. DATA FLOW AND PROCESSING LOGIC -->
<div style="overflow-x:auto;background:#f9f9f9;padding:16px;border-radius:8px;">
  <div style="display:grid;grid-template-columns:repeat(3,180px);grid-template-rows:repeat(3,80px);gap:36px;align-items:center;justify-items:center;">
    <div style="grid-column:2;grid-row:1;background:#e3e8f0;border:1px solid #bfc5ce;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">ZTFIGL_RCALWEEK<br><span style="font-size:12px;font-weight:normal;">Data Source</span></div>
    <div style="grid-column:2;grid-row:2;background:#f6f8fa;border:1px solid #bfc5ce;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">Projection_1<br><span style="font-size:12px;font-weight:normal;">Projection Node<br>RCLNT Filter: IN (120, 200)</span></div>
    <div style="grid-column:2;grid-row:3;background:#e3e8f0;border:1px solid #bfc5ce;border-radius:8px;padding:16px;text-align:center;font-weight:bold;">Output<br><span style="font-size:12px;font-weight:normal;">RCLNT, ZZWEEK, ZCALYRP, ZRYEAR, ZRPERIOD, ZRYRP, ZRYRQTR, ZRWSTRTDATE, ZRWENDDATE</span></div>
    <div style="grid-column:2;grid-row:1;grid-column-end:2;grid-row-end:2;width:0;height:0;border-left:2px solid #8392a7;border-bottom:2px solid #8392a7;margin-top:12px;"></div>
    <div style="grid-column:2;grid-row:2;grid-column-end:2;grid-row-end:3;width:0;height:0;border-left:2px solid #8392a7;border-bottom:2px solid #8392a7;margin-top:12px;"></div>
  </div>
</div>

<!-- 4. DATA MAPPING -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;margin-top:12px;margin-bottom:12px;width:100%;">
  <tr>
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr>
    <td>Projection_1/RCLNT</td>
    <td>RCLNT</td>
    <td>ZTFIGL_RCALWEEK/RCLNT</td>
    <td>RCLNT</td>
    <td>Filter applied: IN (120, 200)</td>
  </tr>
  <tr>
    <td>Projection_1/ZZWEEK</td>
    <td>ZZWEEK</td>
    <td>ZTFIGL_RCALWEEK/ZZWEEK</td>
    <td>ZZWEEK</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1/ZCALYRP</td>
    <td>ZCALYRP</td>
    <td>ZTFIGL_RCALWEEK/ZCALYRP</td>
    <td>ZCALYRP</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1/ZRYEAR</td>
    <td>ZRYEAR</td>
    <td>ZTFIGL_RCALWEEK/ZRYEAR</td>
    <td>ZRYEAR</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1/ZRPERIOD</td>
    <td>ZRPERIOD</td>
    <td>ZTFIGL_RCALWEEK/ZRPERIOD</td>
    <td>ZRPERIOD</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1/ZRYRP</td>
    <td>ZRYRP</td>
    <td>ZTFIGL_RCALWEEK/ZRYRP</td>
    <td>ZRYRP</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1/ZRYRQTR</td>
    <td>ZRYRQTR</td>
    <td>ZTFIGL_RCALWEEK/ZRYRQTR</td>
    <td>ZRYRQTR</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1/ZRWSTRTDATE</td>
    <td>ZRWSTRTDATE</td>
    <td>ZTFIGL_RCALWEEK/ZRWSTRTDATE</td>
    <td>ZRWSTRTDATE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1/ZRWENDDATE</td>
    <td>ZRWENDDATE</td>
    <td>ZTFIGL_RCALWEEK/ZRWENDDATE</td>
    <td>ZRWENDDATE</td>
    <td>Direct mapping</td>
  </tr>
</table>

<!-- 5. COMPLEXITY ANALYSIS -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;margin-bottom:12px;width:100%;">
  <tr><th>Category</th><th>Measurement</th></tr>
  <tr><td>Number of Objects/Nodes</td><td>2 (Projection_1 node, ZTFIGL_RCALWEEK data source)</td></tr>
  <tr><td>Sources Used</td><td>ZTFIGL_RCALWEEK</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None identified</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>RCLNT filter: IN (120, 200)</td></tr>
  <tr><td>Workflow Complexity</td><td>Simple linear projection with attribute filtering</td></tr>
  <tr><td>Performance Considerations</td><td>Minimal processing; no joins or aggregations</td></tr>
  <tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single source dependency</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. SENSITIVE AND PRIVACY DATA ASSESSMENT -->
No sensitive data found

<!-- 7. KEY OUTPUTS -->
<ul>
  <li>RCLNT</li>
  <li>ZZWEEK</li>
  <li>ZCALYRP</li>
  <li>ZRYEAR</li>
  <li>ZRPERIOD</li>
  <li>ZRYRP</li>
  <li>ZRYRQTR</li>
  <li>ZRWSTRTDATE</li>
  <li>ZRWENDDATE</li>
</ul>

<!-- 8. API COST CALCULATIONS -->
API COST : 0.0000 USD
