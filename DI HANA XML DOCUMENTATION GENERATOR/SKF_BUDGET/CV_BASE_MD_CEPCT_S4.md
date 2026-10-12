<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:8px;margin-bottom:16px;">
<b>Author:</b> Ascendion AAVA<br>
<b>Created On:</b> 2024-06-13<br>
<b>Description:</b> Technical documentation for HANA Calculation View <b>CV_BASE_MD_CEPCT_S4</b>. This view serves as the base for CEPCT, providing texts for Profit Center Master Data. All information is derived from the provided HANA XML definition.
</div>

<!-- 1. Overview of Program -->
<div style="margin-bottom:16px;">
<b>Overview of Program:</b><br>
This object is a HANA Calculation View of type <b>DIMENSION</b>, named <b>CV_BASE_MD_CEPCT_S4</b>. Its primary purpose is to expose textual information related to Profit Center Master Data from the underlying CEPCT table. The view applies a filter on the <b>MANDT</b> field and projects selected columns for consumption.
</div>

<!-- 2. Code Structure and Design -->
<div style="margin-bottom:16px;">
<b>Structure:</b> The Calculation View consists of a single projection node (<b>Projection_1</b>) sourcing data from the base table <b>CEPCT</b>. The projection node selects eight fields and applies a filter to the <b>MANDT</b> attribute, limiting values to 120 and 200. No calculated attributes, measures, joins, aggregations, or unions are defined.
<br>
<b>Key Components:</b> The major components are the <b>CEPCT</b> data source, the <b>Projection_1</b> node, and the logical model that defines output attributes. The view attributes are mapped directly from the source table, and descriptive labels are provided for each output field.
<br>
<b>Dependencies & Performance:</b> The only dependency is the <b>CEPCT</b> base table. No joins, aggregations, or complex processing logic are present. The filter on <b>MANDT</b> may improve selectivity. No explicit performance optimizations or data-volume handling are defined in the XML.
</div>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;background:#f9f9f9;border:1px solid #eee;padding:16px;margin-bottom:16px;">
<style>
.workflow-grid {
  display: grid;
  grid-template-columns: 180px 40px 180px;
  grid-template-rows: 80px 80px;
  gap: 8px;
  align-items: center;
  justify-items: center;
}
.workflow-box {
  background: #e3e7fa;
  border-radius: 8px;
  box-shadow: 0 1px 3px #bbb;
  width: 160px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  font-size: 15px;
  color: #25396b;
}
.arrow {
  font-size: 32px;
  color: #8e9ac6;
  padding-top: 10px;
}
</style>
<div class="workflow-grid">
  <div class="workflow-box" style="grid-column:1;grid-row:1;">CEPCT (Table)</div>
  <div class="arrow" style="grid-column:2;grid-row:1;">&#8594;</div>
  <div class="workflow-box" style="grid-column:3;grid-row:1;">Projection_1</div>
  <div class="arrow" style="grid-column:2;grid-row:2;">&#8594;</div>
  <div class="workflow-box" style="grid-column:3;grid-row:2;">Output (View)</div>
</div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;margin-bottom:16px;width:100%;background:#fafafa;">
<tr style="background:#e3e7fa;font-weight:bold;">
  <th>Target Object/Field Name</th>
  <th>Target Column Name</th>
  <th>Source Object/Field Name</th>
  <th>Source Column Name</th>
  <th>Remarks</th>
</tr>
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
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;margin-bottom:16px;width:100%;background:#fafafa;">
<tr style="background:#e3e7fa;font-weight:bold;">
  <th>Category</th>
  <th>Measurement</th>
</tr>
<tr>
  <td>Number of Objects/Nodes</td>
  <td>3 (CEPCT, Projection_1, Output)</td>
</tr>
<tr>
  <td>Sources Used</td>
  <td>1 (CEPCT table)</td>
</tr>
<tr>
  <td>Joins</td>
  <td>None identified</td>
</tr>
<tr>
  <td>Temporary/Cached Data</td>
  <td>None identified</td>
</tr>
<tr>
  <td>Aggregate Functions</td>
  <td>None identified</td>
</tr>
<tr>
  <td>Data Manipulation</td>
  <td>No data manipulation identified</td>
</tr>
<tr>
  <td>Conditional Logic</td>
  <td>Filter on MANDT (IN 120, 200)</td>
</tr>
<tr>
  <td>Workflow Complexity</td>
  <td>Simple linear flow: source table → projection → output</td>
</tr>
<tr>
  <td>Performance Considerations</td>
  <td>Single-table access with filter; no complex processing</td>
</tr>
<tr>
  <td>Data Volume Handling</td>
  <td>Not explicitly defined in XML</td>
</tr>
<tr>
  <td>Dependency Complexity</td>
  <td>Single dependency (CEPCT table)</td>
</tr>
<tr>
  <td>Overall Complexity Score</td>
  <td>Low</td>
</tr>
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
