<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:8px;margin-bottom:16px">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> 2024-06-10<br>
  <b>Description:</b> Base view for CEPCT - Texts for Profit Center Master Data. This HANA XML object defines a Calculation View for modeling profit center text data using a single data source table and projection logic.
</div>

<!-- 1. Overview of Program -->
<div style="margin-bottom:16px">
  <b>Overview of Program:</b><br>
  This object is a Calculation View defined in HANA XML. Its primary purpose is to provide a dimension view for profit center text master data (CEPCT) by projecting relevant columns from the underlying table. The view applies a filter to the client field and exposes key text attributes for downstream consumption.
</div>

<!-- 2. Code Structure and Design -->
<div style="margin-bottom:16px">
  <b>Structure:</b> The Calculation View is built as a TREE_BASED scenario with a single Projection node, which sources data from the CEPCT table. The Projection node selects eight fields and applies a filter on the MANDT field for specific client values (120, 200). No calculated fields, joins, unions, or aggregations are present. <br>
  <b>Key Components:</b> The major components include the data source table CEPCT, the Projection_1 node, and the logical model defining the output attributes. All fields are directly mapped from the source table, and only the MANDT field is filtered. <br>
  <b>Dependencies & Performance:</b> The view depends solely on the CEPCT table as its data source. No joins, unions, or nested views are present, and performance considerations are limited to the client filter applied. No complex processing logic or aggregations are defined in the XML.
</div>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;background:#f9f9f9;padding:16px;border-radius:8px;margin-bottom:16px">
<style>
.hana-grid { display: grid; grid-template-columns: 180px 40px 180px 40px 180px; grid-template-rows: 80px 80px; align-items: center; justify-content: center; }
.hana-box { background: #e3e8f7; border-radius: 6px; box-shadow: 0 1px 4px #b6b6b6; padding: 16px; text-align: center; font-weight: bold; font-size: 14px; }
.hana-arrow { grid-row: 1; grid-column: 2; align-self: center; justify-self: center; font-size: 24px; color: #555; }
.hana-arrow2 { grid-row: 1; grid-column: 4; align-self: center; justify-self: center; font-size: 24px; color: #555; }
</style>
<div class="hana-grid">
  <div class="hana-box" style="grid-row:1;grid-column:1;">CEPCT<br><span style="font-size:12px;color:#555">(DATA_BASE_TABLE)</span></div>
  <div class="hana-arrow">&#8594;</div>
  <div class="hana-box" style="grid-row:1;grid-column:3;">Projection_1<br><span style="font-size:12px;color:#555">(Projection Node)<br>MANDT Filter: IN (120, 200)</span></div>
  <div class="hana-arrow2">&#8594;</div>
  <div class="hana-box" style="grid-row:1;grid-column:5;">Output<br><span style="font-size:12px;color:#555">MANDT, SPRAS, PRCTR, DATBI, KOKRS, KTEXT, LTEXT, MCTXT</span></div>
</div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="6" style="border-collapse:collapse;margin-bottom:16px;width:100%">
<thead style="background:#e3e8f7">
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
  <td>Projection_1 / MANDT</td>
  <td>MANDT</td>
  <td>CEPCT / MANDT</td>
  <td>MANDT</td>
  <td>Filter applied: IN (120, 200)</td>
</tr>
<tr>
  <td>Projection_1 / SPRAS</td>
  <td>SPRAS</td>
  <td>CEPCT / SPRAS</td>
  <td>SPRAS</td>
  <td>Direct mapping</td>
</tr>
<tr>
  <td>Projection_1 / PRCTR</td>
  <td>PRCTR</td>
  <td>CEPCT / PRCTR</td>
  <td>PRCTR</td>
  <td>Direct mapping</td>
</tr>
<tr>
  <td>Projection_1 / DATBI</td>
  <td>DATBI</td>
  <td>CEPCT / DATBI</td>
  <td>DATBI</td>
  <td>Direct mapping</td>
</tr>
<tr>
  <td>Projection_1 / KOKRS</td>
  <td>KOKRS</td>
  <td>CEPCT / KOKRS</td>
  <td>KOKRS</td>
  <td>Direct mapping</td>
</tr>
<tr>
  <td>Projection_1 / KTEXT</td>
  <td>KTEXT</td>
  <td>CEPCT / KTEXT</td>
  <td>KTEXT</td>
  <td>Direct mapping</td>
</tr>
<tr>
  <td>Projection_1 / LTEXT</td>
  <td>LTEXT</td>
  <td>CEPCT / LTEXT</td>
  <td>LTEXT</td>
  <td>Direct mapping</td>
</tr>
<tr>
  <td>Projection_1 / MCTXT</td>
  <td>MCTXT</td>
  <td>CEPCT / MCTXT</td>
  <td>MCTXT</td>
  <td>Direct mapping</td>
</tr>
</tbody>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="6" style="border-collapse:collapse;margin-bottom:16px;width:100%">
<thead style="background:#e3e8f7">
<tr><th>Category</th><th>Measurement</th></tr>
</thead>
<tbody>
<tr><td>Number of Objects/Nodes</td><td>3 (CEPCT, Projection_1, Output)</td></tr>
<tr><td>Sources Used</td><td>CEPCT (DATA_BASE_TABLE)</td></tr>
<tr><td>Joins</td><td>None identified</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>None identified</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>MANDT filter: IN (120, 200)</td></tr>
<tr><td>Workflow Complexity</td><td>Simple linear flow: source table → projection → output</td></tr>
<tr><td>Performance Considerations</td><td>Single table filter; no joins or aggregations</td></tr>
<tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
<tr><td>Dependency Complexity</td><td>Single dependency: CEPCT table</td></tr>
<tr><td>Overall Complexity Score</td><td>Low</td></tr>
</tbody>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>MANDT (Client)</li>
  <li>SPRAS (Language Key)</li>
  <li>PRCTR (Profit Center)</li>
  <li>DATBI (Valid To Date)</li>
  <li>KOKRS (Controlling Area)</li>
  <li>KTEXT (General Name)</li>
  <li>LTEXT (Long Text)</li>
  <li>MCTXT (Search term for matchcode search)</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
