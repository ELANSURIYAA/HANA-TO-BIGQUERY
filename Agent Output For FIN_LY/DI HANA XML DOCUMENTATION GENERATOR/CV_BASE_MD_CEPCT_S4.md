<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse;">
  <tr><td style="width:20%; font-weight:bold;">Author:</td><td>Ascendion AAVA</td></tr>
  <tr><td style="font-weight:bold;">Created On:</td><td>{CURRENT_DATE}</td></tr>
  <tr><td style="font-weight:bold;">Description:</td><td>Base view for CEPCT - Texts for Profit Center Master Data. This HANA XML defines a Calculation View used to expose dimension data from the CEPCT table for profit center texts.</td></tr>
</table>

<!-- 1. Overview of Program -->
<p>This object is a Calculation View of type DIMENSION, designed to provide textual master data from the CEPCT database table. Its primary purpose is to project selected fields with client and language filtering. The view exposes relevant profit center text fields for downstream consumption.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View is structured with a single Projection node referencing the CEPCT data source. The Projection node selects all relevant fields and applies a filter on the MANDT field for values 120 and 200. No joins, unions, aggregations, or calculated fields are defined. <b>Key Components:</b> Major components include the CEPCT table as the data source, the Projection_1 node, and the logical model mapping output attributes. <b>Dependencies & Performance:</b> The view is dependent on the CEPCT table in the schema SAP_S4. No complex processing, aggregation, or calculated expressions are present; performance is expected to be straightforward due to the simple projection and filter.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; padding:10px; background:#f7f7fa; border-radius:8px;">
  <div style="display:grid; grid-template-columns:repeat(3, 180px); grid-template-rows:repeat(3, 90px); align-items:center; justify-items:center; gap:32px;">
    <div style="grid-column:2; grid-row:1; background:#e3e6f8; border:1px solid #b5b8d6; border-radius:6px; padding:16px; font-weight:bold;">CEPCT<br><span style="font-size:12px; color:#666;">Data Source (Table)</span></div>
    <div style="grid-column:2; grid-row:2; background:#e3f8e6; border:1px solid #b5d6b8; border-radius:6px; padding:16px; font-weight:bold;">Projection_1<br><span style="font-size:12px; color:#666;">Projection Node<br>MANDT Filter: IN (120, 200)</span></div>
    <div style="grid-column:2; grid-row:3; background:#f8e3e6; border:1px solid #d6b5b8; border-radius:6px; padding:16px; font-weight:bold;">Output<br><span style="font-size:12px; color:#666;">View Output</span></div>
    <div style="grid-column:2; grid-row:1; justify-self:end; align-self:center; width:0; height:0; border-left:16px solid transparent; border-right:16px solid transparent; border-top:24px solid #b5b8d6; margin-top:0px;"></div>
    <div style="grid-column:2; grid-row:2; justify-self:end; align-self:center; width:0; height:0; border-left:16px solid transparent; border-right:16px solid transparent; border-top:24px solid #b5d6b8; margin-top:0px;"></div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%; border-collapse:collapse;">
  <tr style="background:#eaeaea; font-weight:bold;">
    <td>Target Object/Field Name</td>
    <td>Target Column Name</td>
    <td>Source Object/Field Name</td>
    <td>Source Column Name</td>
    <td>Remarks</td>
  </tr>
  <tr><td>Projection_1.MANDT</td><td>MANDT</td><td>CEPCT.MANDT</td><td>MANDT</td><td>Filter applied: IN (120, 200)</td></tr>
  <tr><td>Projection_1.SPRAS</td><td>SPRAS</td><td>CEPCT.SPRAS</td><td>SPRAS</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.PRCTR</td><td>PRCTR</td><td>CEPCT.PRCTR</td><td>PRCTR</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.DATBI</td><td>DATBI</td><td>CEPCT.DATBI</td><td>DATBI</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.KOKRS</td><td>KOKRS</td><td>CEPCT.KOKRS</td><td>KOKRS</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.KTEXT</td><td>KTEXT</td><td>CEPCT.KTEXT</td><td>KTEXT</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.LTEXT</td><td>LTEXT</td><td>CEPCT.LTEXT</td><td>LTEXT</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.MCTXT</td><td>MCTXT</td><td>CEPCT.MCTXT</td><td>MCTXT</td><td>Direct mapping</td></tr>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%; border-collapse:collapse;">
  <tr style="background:#eaeaea; font-weight:bold;">
    <td>Category</td>
    <td>Measurement</td>
  </tr>
  <tr><td>Number of Objects/Nodes</td><td>2 (Data Source CEPCT, Projection_1)</td></tr>
  <tr><td>Sources Used</td><td>CEPCT (table)</td></tr>
  <tr><td>Joins</td><td>None</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>MANDT filter: IN (120, 200)</td></tr>
  <tr><td>Workflow Complexity</td><td>Simple linear projection with filter</td></tr>
  <tr><td>Performance Considerations</td><td>Simple projection and filter; minimal processing overhead</td></tr>
  <tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single dependency: CEPCT table</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
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