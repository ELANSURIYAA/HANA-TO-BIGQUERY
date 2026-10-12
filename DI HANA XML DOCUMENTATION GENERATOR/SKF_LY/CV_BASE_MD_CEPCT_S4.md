<!-- DOCUMENT HEADER -->
<table style="width:100%;border-collapse:collapse;margin-bottom:16px;">
  <tr><td style="font-weight:bold;width:20%;">Author:</td><td>Ascendion AAVA</td></tr>
  <tr><td style="font-weight:bold;width:20%;">Created On:</td><td>2026-10-12</td></tr>
  <tr><td style="font-weight:bold;width:20%;">Description:</td><td>Technical documentation for HANA Calculation View <b>CV_BASE_MD_CEPCT_S4</b>, a dimension view providing base texts for Profit Center Master Data from table <b>CEPCT</b>. The view projects relevant fields and applies client filtering based on the XML definition.</td></tr>
</table>

<!-- 1. Overview of Program -->
<p>This HANA XML object is a Calculation View of type <b>DIMENSION</b>. Its primary purpose is to provide a base projection of text fields for Profit Center Master Data from the data source <b>CEPCT</b>. The view applies a filter on the client field and exposes key descriptive attributes for downstream modeling.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View is defined as a tree-based scenario with a single projection node (<b>Projection_1</b>). It sources data from the base table <b>CEPCT</b>, projecting eight fields and applying a filter on the <b>MANDT</b> field to include only values <b>120</b> and <b>200</b>. No calculated fields, joins, aggregations, or unions are present.<br>
<b>Key Components:</b> The major components are the data source (<b>CEPCT</b>), the projection node (<b>Projection_1</b>), and the logical model that defines the output attributes with descriptions. The filter applied to <b>MANDT</b> ensures selective client data exposure.<br>
<b>Dependencies & Performance:</b> The view depends solely on the <b>CEPCT</b> table. No joins, aggregations, or complex logic are present, indicating minimal dependency complexity and low performance overhead. The filter on <b>MANDT</b> is the only performance-relevant characteristic visible in the XML.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;padding:8px 0;background:#f9f9f9;border:1px solid #ddd;border-radius:8px;">
  <div style="display:grid;grid-template-columns:repeat(3,200px);grid-template-rows:repeat(3,80px);gap:32px 16px;align-items:center;justify-items:center;width:700px;">
    <div style="grid-column:2;grid-row:1;background:#e3eafc;border-radius:8px;padding:16px;text-align:center;font-weight:bold;border:1px solid #b6c2e7;">CEPCT<br><span style="font-size:12px;color:#666;">DATA_BASE_TABLE</span></div>
    <div style="grid-column:2;grid-row:2;background:#d0f5d8;border-radius:8px;padding:16px;text-align:center;font-weight:bold;border:1px solid #a3d9a5;">Projection_1<br><span style="font-size:12px;color:#666;">Projection Node<br/>Filter: MANDT IN (120, 200)</span></div>
    <div style="grid-column:2;grid-row:3;background:#fff6e3;border-radius:8px;padding:16px;text-align:center;font-weight:bold;border:1px solid #f7d59c;">Output<br><span style="font-size:12px;color:#666;">MANDT, SPRAS, PRCTR, DATBI, KOKRS, KTEXT, LTEXT, MCTXT</span></div>
    <!-- Arrows -->
    <div style="grid-column:2;grid-row:1;justify-self:end;align-self:end;width:0;height:0;">
      <svg width="200" height="40"><line x1="100" y1="0" x2="100" y2="40" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
    </div>
    <div style="grid-column:2;grid-row:2;justify-self:end;align-self:end;width:0;height:0;">
      <svg width="200" height="40"><line x1="100" y1="0" x2="100" y2="40" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
    </div>
    <!-- SVG Arrowhead Definition -->
    <svg width="0" height="0">
      <defs>
        <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
          <polygon points="0 0, 10 3.5, 0 7" fill="#888"/>
        </marker>
      </defs>
    </svg>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%;border-collapse:collapse;margin-bottom:16px;">
  <thead>
    <tr style="background:#e3eafc;">
      <th>Target Object/Field Name</th>
      <th>Target Column Name</th>
      <th>Source Object/Field Name</th>
      <th>Source Column Name</th>
      <th>Remarks</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>Projection_1 / MANDT</td><td>MANDT</td><td>CEPCT / MANDT</td><td>MANDT</td><td>Filter: IN (120, 200)</td></tr>
    <tr><td>Projection_1 / SPRAS</td><td>SPRAS</td><td>CEPCT / SPRAS</td><td>SPRAS</td><td></td></tr>
    <tr><td>Projection_1 / PRCTR</td><td>PRCTR</td><td>CEPCT / PRCTR</td><td>PRCTR</td><td></td></tr>
    <tr><td>Projection_1 / DATBI</td><td>DATBI</td><td>CEPCT / DATBI</td><td>DATBI</td><td></td></tr>
    <tr><td>Projection_1 / KOKRS</td><td>KOKRS</td><td>CEPCT / KOKRS</td><td>KOKRS</td><td></td></tr>
    <tr><td>Projection_1 / KTEXT</td><td>KTEXT</td><td>CEPCT / KTEXT</td><td>KTEXT</td><td></td></tr>
    <tr><td>Projection_1 / LTEXT</td><td>LTEXT</td><td>CEPCT / LTEXT</td><td>LTEXT</td><td></td></tr>
    <tr><td>Projection_1 / MCTXT</td><td>MCTXT</td><td>CEPCT / MCTXT</td><td>MCTXT</td><td></td></tr>
  </tbody>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%;border-collapse:collapse;margin-bottom:16px;">
  <thead>
    <tr style="background:#e3eafc;">
      <th>Category</th>
      <th>Measurement</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>Number of Objects/Nodes</td><td>2 (Data Source: CEPCT, Projection Node: Projection_1)</td></tr>
    <tr><td>Sources Used</td><td>CEPCT</td></tr>
    <tr><td>Joins</td><td>None identified</td></tr>
    <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
    <tr><td>Aggregate Functions</td><td>None identified</td></tr>
    <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
    <tr><td>Conditional Logic</td><td>MANDT filter (IN 120, 200)</td></tr>
    <tr><td>Workflow Complexity</td><td>Simple linear structure: Data source → Projection → Output</td></tr>
    <tr><td>Performance Considerations</td><td>Client filter on MANDT; minimal dependency complexity</td></tr>
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
