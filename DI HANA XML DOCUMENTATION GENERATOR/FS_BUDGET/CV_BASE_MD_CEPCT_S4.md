<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:8px;margin-bottom:20px;">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> {{CURRENT_DATE}}<br>
  <b>Description:</b> Base view for CEPCT - Texts for Profit Center Master Data. This HANA XML defines a Calculation View intended to provide text information for Profit Center Master Data, using a single projection from a database table.
</div>

<!-- 1. Overview of Program -->
<p>This HANA XML object is a Calculation View of type <b>TREE_BASED</b> with data category <b>DIMENSION</b>. Its primary purpose is to provide text information for Profit Center Master Data by projecting relevant fields from the underlying CEPCT table. The main processing consists of filtering, mapping, and exposing text-related fields for consumption.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View is structured with a single projection node (Projection_1) that sources data from the CEPCT database table. The projection includes eight fields, with a filter applied to the MANDT field for specific client values. No calculated fields, joins, unions, or aggregations are present.<br>
<b>Key Components:</b> The major components are the CEPCT data source, the Projection_1 node, view attributes, and the logical model defining output attributes. The view attributes are mapped directly from the source table, with descriptive metadata for each field.<br>
<b>Dependencies & Performance:</b> The only dependency is the CEPCT table from the referenced schema. No joins, aggregations, or complex processing are present. The filter on MANDT restricts output to specified client values, which may impact performance minimally by reducing result set size. No temporary tables or advanced logic are used.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;background:#f9f9f9;padding:16px;border-radius:8px;">
  <div style="display:grid;grid-template-columns:repeat(3,220px);grid-auto-rows:100px;align-items:center;justify-items:center;gap:40px;">
    <div style="grid-column:1;grid-row:1;background:#e0e7ff;border-radius:8px;padding:20px;border:1px solid #b3b3b3;font-weight:bold;">CEPCT<br/><span style="font-size:12px;color:#555;">DATA_BASE_TABLE</span></div>
    <div style="grid-column:2;grid-row:2;background:#ffe7d6;border-radius:8px;padding:20px;border:1px solid #b3b3b3;font-weight:bold;">Projection_1<br/><span style="font-size:12px;color:#555;">Projection Node</span></div>
    <div style="grid-column:3;grid-row:3;background:#e6f7d6;border-radius:8px;padding:20px;border:1px solid #b3b3b3;font-weight:bold;">Output<br/><span style="font-size:12px;color:#555;">Logical Model</span></div>
    <svg style="grid-column:1;grid-row:1/3;z-index:1;position:relative;width:40px;height:100px;" xmlns="http://www.w3.org/2000/svg">
      <defs><marker id="arrow" markerWidth="10" markerHeight="10" refX="5" refY="5" orient="auto" markerUnits="strokeWidth"><path d="M0,0 L0,10 L10,5 Z" fill="#555"/></marker></defs>
      <line x1="20" y1="80" x2="220" y2="100" stroke="#555" stroke-width="3" marker-end="url(#arrow)"/>
    </svg>
    <svg style="grid-column:2;grid-row:2/4;z-index:1;position:relative;width:40px;height:100px;" xmlns="http://www.w3.org/2000/svg">
      <defs><marker id="arrow2" markerWidth="10" markerHeight="10" refX="5" refY="5" orient="auto" markerUnits="strokeWidth"><path d="M0,0 L0,10 L10,5 Z" fill="#555"/></marker></defs>
      <line x1="20" y1="80" x2="220" y2="100" stroke="#555" stroke-width="3" marker-end="url(#arrow2)"/>
    </svg>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;">
  <tr>
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr>
    <td>Projection_1.MANDT</td>
    <td>MANDT</td>
    <td>CEPCT.MANDT</td>
    <td>MANDT</td>
    <td>Filter applied: IN (120, 200)</td>
  </tr>
  <tr>
    <td>Projection_1.SPRAS</td>
    <td>SPRAS</td>
    <td>CEPCT.SPRAS</td>
    <td>SPRAS</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.PRCTR</td>
    <td>PRCTR</td>
    <td>CEPCT.PRCTR</td>
    <td>PRCTR</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.DATBI</td>
    <td>DATBI</td>
    <td>CEPCT.DATBI</td>
    <td>DATBI</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.KOKRS</td>
    <td>KOKRS</td>
    <td>CEPCT.KOKRS</td>
    <td>KOKRS</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.KTEXT</td>
    <td>KTEXT</td>
    <td>CEPCT.KTEXT</td>
    <td>KTEXT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.LTEXT</td>
    <td>LTEXT</td>
    <td>CEPCT.LTEXT</td>
    <td>LTEXT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1.MCTXT</td>
    <td>MCTXT</td>
    <td>CEPCT.MCTXT</td>
    <td>MCTXT</td>
    <td>Direct mapping</td>
  </tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;">
  <tr><th>Category</th><th>Measurement</th></tr>
  <tr><td>Number of Objects/Nodes</td><td>3 (CEPCT table, Projection_1 node, Logical Model)</td></tr>
  <tr><td>Sources Used</td><td>CEPCT (DATA_BASE_TABLE)</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None identified</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>MANDT filter: IN (120, 200)</td></tr>
  <tr><td>Workflow Complexity</td><td>Simple linear projection from source to output</td></tr>
  <tr><td>Performance Considerations</td><td>Single filter on MANDT; minimal complexity</td></tr>
  <tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
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
