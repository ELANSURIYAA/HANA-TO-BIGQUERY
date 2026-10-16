<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:10px;margin-bottom:20px;">
<b>Author:</b> Ascendion AAVA<br>
<b>Created On:</b> 2026-10-16<br>
<b>Description:</b> Calculation View CV_COMP_MD_SRPACT_STATIC is a HANA XML-defined modeling object that integrates data from the source table CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT. The XML defines a multi-node modeling structure for transforming and projecting source data, but does not specify additional business logic or purpose beyond the technical modeling.
</div>

<!-- 1. Overview of Program -->
<p>
CV_COMP_MD_SRPACT_STATIC is a Calculation View defined in HANA XML. Its primary function is to model and expose data from the source table CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT through a series of projections and transformations. The view organizes and structures data for consumption, with processing steps strictly based on the XML definition.
</p>

<!-- 2. Code Structure and Design -->
<p>
<b>Structure:</b> The Calculation View is structured with a single main data source node referencing CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT. The XML indicates multiple projection nodes, each mapping fields from the source table and organizing them for output. No joins, unions, aggregations, filters, variables, or parameters are explicitly defined in the XML. <b>Key Components:</b> The key component is the projection node, which selects and maps fields from the source table. <b>Dependencies & Performance:</b> The view depends on CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT as its sole data source. No performance-relevant characteristics such as aggregations, filters, or complex processing logic are present; the structure is straightforward and read-only.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;background:#f9f9f9;padding:12px;border-radius:8px;border:1px solid #eee;">
<style>
.grid-workflow { display: grid; grid-template-columns: 180px 40px 180px; grid-auto-rows: 60px; gap: 12px; align-items: center; }
.grid-box { background: #e3e8f0; border-radius: 6px; text-align: center; padding: 14px; font-weight: 600; box-shadow: 0 2px 6px #0001; }
.arrow { text-align: center; font-size: 32px; color: #888; }
</style>
<div class="grid-workflow">
  <div class="grid-box" style="grid-column:1;grid-row:1;">Source Table<br>CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT</div>
  <div class="arrow" style="grid-column:2;grid-row:1;">→</div>
  <div class="grid-box" style="grid-column:3;grid-row:1;">Projection Node(s)</div>
  <div class="arrow" style="grid-column:2;grid-row:2;">→</div>
  <div class="grid-box" style="grid-column:3;grid-row:2;">Calculation View Output</div>
</div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;background:#fff;">
<thead style="background:#e3e8f0;">
<tr>
<th>Target Object/Field Name</th>
<th>Target Column Name</th>
<th>Source Object/Field Name</th>
<th>Source Column Name</th>
<th>Remarks</th>
</tr>
</thead>
<tbody>
<tr>
<td>CV_COMP_MD_SRPACT_STATIC Output</td>
<td>All projected columns</td>
<td>CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT</td>
<td>All columns</td>
<td>Direct mapping; no transformations or calculations defined</td>
</tr>
</tbody>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;background:#fff;">
<thead style="background:#e3e8f0;">
<tr><th>Category</th><th>Measurement</th></tr>
</thead>
<tbody>
<tr><td>Number of Objects/Nodes</td><td>2 (Source Table, Projection Node)</td></tr>
<tr><td>Sources Used</td><td>1 (CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT)</td></tr>
<tr><td>Joins</td><td>0</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>0</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>None identified</td></tr>
<tr><td>Workflow Complexity</td><td>Low; simple projection from source to output</td></tr>
<tr><td>Performance Considerations</td><td>Direct mapping; no performance-impacting features present</td></tr>
<tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
<tr><td>Dependency Complexity</td><td>Single dependency (source table)</td></tr>
<tr><td>Overall Complexity Score</td><td>Low</td></tr>
</tbody>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
<li>Calculation View Output: All columns projected from CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
