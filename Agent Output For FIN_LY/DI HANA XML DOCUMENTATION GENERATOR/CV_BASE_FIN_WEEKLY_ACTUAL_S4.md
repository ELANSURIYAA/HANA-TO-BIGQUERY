<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:8px;margin-bottom:16px;">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> 2026-10-12<br>
  <b>Description:</b> Technical documentation for a HANA Calculation View named <b>CV_BASE_FIN_WEEKLY_ACTUAL_S4</b>, designed as a base view for store reporting financial actuals, specifically for weekly snapshots of frozen DSO (DS07). All information is strictly derived from the provided HANA XML file.
</div>

<!-- 1. OVERVIEW OF PROGRAM -->
<p><b>Overview of Program</b><br>
This object is a HANA Calculation View of type <b>TREE_BASED</b> with data category <b>CUBE</b>. Its primary purpose is to provide a base aggregation layer for weekly financial actuals reporting, using a single database table as its data source. The view projects and aggregates multiple financial and store-related fields, supporting reporting scenarios that require weekly snapshot analysis.</p>

<!-- 2. CODE STRUCTURE AND DESIGN -->
<p><b>Code Structure and Design</b><br>
<b>Structure:</b> The Calculation View is structured with a single projection node (<b>Projection_1</b>) sourced from the database table <b>AZSRP_DS072_VT_S4</b> in schema <b>CVS_FRIP</b>. The projection selects all relevant attributes and measures, including fiscal, store, company, ledger, and amount fields, and applies a filter on the <b>MANDT</b> field to restrict values to 110 and 200. No joins, unions, calculated attributes, or variables are defined. <b>Key Components:</b> Major components include the data source (<b>AZSRP_DS072_VT_S4</b>), the projection node (<b>Projection_1</b>), and the logical model defining output attributes and measures such as <b>_B631_S_AMOUNT</b> and <b>_BIC_ZIO_D1AMT</b> through <b>_BIC_ZIO_D7AMT</b>. <b>Dependencies & Performance:</b> The view depends solely on the referenced database table and applies a filter on <b>MANDT</b>. Aggregation (SUM) is applied to all measures, and the absence of joins or calculated fields indicates a straightforward design with minimal dependency and low processing complexity.</p>

<!-- 3. DATA FLOW AND PROCESSING LOGIC -->
<div style="overflow-x:auto;padding:12px 0;background:#f9f9f9;border-radius:8px;">
  <div style="display:grid;grid-template-columns:repeat(3,180px);grid-auto-rows:90px;align-items:center;justify-items:center;gap:40px;">
    <div style="grid-column:1;grid-row:1;background:#e3eafc;border-radius:8px;padding:18px;text-align:center;font-weight:bold;border:1px solid #b6c5e0;">AZSRP_DS072_VT_S4<br/><span style="font-size:12px;color:#666;">(Database Table)</span></div>
    <div style="grid-column:2;grid-row:2;background:#f7d7c4;border-radius:8px;padding:18px;text-align:center;font-weight:bold;border:1px solid #e2b59b;">Projection_1<br/><span style="font-size:12px;color:#666;">MANDT Filter: IN (110, 200)</span></div>
    <div style="grid-column:3;grid-row:3;background:#d2f5e3;border-radius:8px;padding:18px;text-align:center;font-weight:bold;border:1px solid #a3d4b7;">Output<br/><span style="font-size:12px;color:#666;">Aggregated Measures & Attributes</span></div>
    <div style="grid-column:1;grid-row:1;grid-column-end:2;grid-row-end:2;justify-self:end;align-self:center;">
      <svg width="40" height="90"><line x1="38" y1="15" x2="2" y2="75" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
    </div>
    <div style="grid-column:2;grid-row:2;grid-column-end:3;grid-row-end:3;justify-self:end;align-self:center;">
      <svg width="40" height="90"><line x1="38" y1="15" x2="2" y2="75" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
    </div>
    <svg style="display:none;"><marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="#888"/></marker></svg>
  </div>
</div>

<!-- 4. DATA MAPPING -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;margin-bottom:16px;">
  <tr style="background:#e3eafc;text-align:left;">
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr><td>Projection_1.MANDT</td><td>MANDT</td><td>AZSRP_DS072_VT_S4</td><td>MANDT</td><td>Filter applied: IN (110, 200)</td></tr>
  <tr><td>Projection_1.FISCPER</td><td>FISCPER</td><td>AZSRP_DS072_VT_S4</td><td>FISCPER</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.FISCVARNT</td><td>FISCVARNT</td><td>AZSRP_DS072_VT_S4</td><td>FISCVARNT</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.FISCYEAR</td><td>FISCYEAR</td><td>AZSRP_DS072_VT_S4</td><td>FISCYEAR</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.FISCPER3</td><td>FISCPER3</td><td>AZSRP_DS072_VT_S4</td><td>FISCPER3</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.RECORDMODE</td><td>RECORDMODE</td><td>AZSRP_DS072_VT_S4</td><td>RECORDMODE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1._BIC_ZIO_SWEEK</td><td>_BIC_ZIO_SWEEK</td><td>AZSRP_DS072_VT_S4</td><td>_BIC_ZIO_SWEEK</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1._B631_S_CHRTACCT</td><td>_B631_S_CHRTACCT</td><td>AZSRP_DS072_VT_S4</td><td>_B631_S_CHRTACCT</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1._B631_S_CO_AREA</td><td>_B631_S_CO_AREA</td><td>AZSRP_DS072_VT_S4</td><td>_B631_S_CO_AREA</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1._BIC_ZIO_CMPCD</td><td>_BIC_ZIO_CMPCD</td><td>AZSRP_DS072_VT_S4</td><td>_BIC_ZIO_CMPCD</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1._B631_S_PROFTCTR</td><td>_B631_S_PROFTCTR</td><td>AZSRP_DS072_VT_S4</td><td>_B631_S_PROFTCTR</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1._B631_S_COSTCNTR</td><td>_B631_S_COSTCNTR</td><td>AZSRP_DS072_VT_S4</td><td>_B631_S_COSTCNTR</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1._B631_S_FUNCAREA</td><td>_B631_S_FUNCAREA</td><td>AZSRP_DS072_VT_S4</td><td>_B631_S_FUNCAREA</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1._BIC_ZIO_VER</td><td>_BIC_ZIO_VER</td><td>AZSRP_DS072_VT_S4</td><td>_BIC_ZIO_VER</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1._BIC_ZIO_SAUDT</td><td>_BIC_ZIO_SAUDT</td><td>AZSRP_DS072_VT_S4</td><td>_BIC_ZIO_SAUDT</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1._B631_S_GL_ACCT</td><td>_B631_S_GL_ACCT</td><td>AZSRP_DS072_VT_S4</td><td>_B631_S_GL_ACCT</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1._BIC_ZWWPC_PA1</td><td>_BIC_ZWWPC_PA1</td><td>AZSRP_DS072_VT_S4</td><td>_BIC_ZWWPC_PA1</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1._BIC_ZWWSC_PA1</td><td>_BIC_ZWWSC_PA1</td><td>AZSRP_DS072_VT_S4</td><td>_BIC_ZWWSC_PA1</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1._B631_S_AMOUNT</td><td>_B631_S_AMOUNT</td><td>AZSRP_DS072_VT_S4</td><td>_B631_S_AMOUNT</td><td>Aggregation: SUM</td></tr>
  <tr><td>Projection_1.CURRENCY</td><td>CURRENCY</td><td>AZSRP_DS072_VT_S4</td><td>CURRENCY</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1._BIC_ZIO_D1AMT</td><td>_BIC_ZIO_D1AMT</td><td>AZSRP_DS072_VT_S4</td><td>_BIC_ZIO_D1AMT</td><td>Aggregation: SUM</td></tr>
  <tr><td>Projection_1._BIC_ZIO_D2AMT</td><td>_BIC_ZIO_D2AMT</td><td>AZSRP_DS072_VT_S4</td><td>_BIC_ZIO_D2AMT</td><td>Aggregation: SUM</td></tr>
  <tr><td>Projection_1._BIC_ZIO_D3AMT</td><td>_BIC_ZIO_D3AMT</td><td>AZSRP_DS072_VT_S4</td><td>_BIC_ZIO_D3AMT</td><td>Aggregation: SUM</td></tr>
  <tr><td>Projection_1._BIC_ZIO_D4AMT</td><td>_BIC_ZIO_D4AMT</td><td>AZSRP_DS072_VT_S4</td><td>_BIC_ZIO_D4AMT</td><td>Aggregation: SUM</td></tr>
  <tr><td>Projection_1._BIC_ZIO_D5AMT</td><td>_BIC_ZIO_D5AMT</td><td>AZSRP_DS072_VT_S4</td><td>_BIC_ZIO_D5AMT</td><td>Aggregation: SUM</td></tr>
  <tr><td>Projection_1._BIC_ZIO_D6AMT</td><td>_BIC_ZIO_D6AMT</td><td>AZSRP_DS072_VT_S4</td><td>_BIC_ZIO_D6AMT</td><td>Aggregation: SUM</td></tr>
  <tr><td>Projection_1._BIC_ZIO_D7AMT</td><td>_BIC_ZIO_D7AMT</td><td>AZSRP_DS072_VT_S4</td><td>_BIC_ZIO_D7AMT</td><td>Aggregation: SUM</td></tr>
  <tr><td>Projection_1._B631_S_LEDGER</td><td>_B631_S_LEDGER</td><td>AZSRP_DS072_VT_S4</td><td>_B631_S_LEDGER</td><td>Direct mapping</td></tr>
</table>

<!-- 5. COMPLEXITY ANALYSIS -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;margin-bottom:16px;">
  <tr style="background:#e3eafc;text-align:left;">
    <th>Category</th>
    <th>Measurement</th>
  </tr>
  <tr><td>Number of Objects/Nodes</td><td>3 (Data Source, Projection_1, Output)</td></tr>
  <tr><td>Sources Used</td><td>AZSRP_DS072_VT_S4 (Database Table)</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>SUM aggregation on all measures</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>MANDT filter (IN 110, 200)</td></tr>
  <tr><td>Workflow Complexity</td><td>Low complexity; single projection and output</td></tr>
  <tr><td>Performance Considerations</td><td>Single source, filter on MANDT, aggregation on measures</td></tr>
  <tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single dependency (database table)</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. SENSITIVE AND PRIVACY DATA ASSESSMENT -->
No sensitive data found

<!-- 7. KEY OUTPUTS -->
<ul>
  <li>MANDT</li>
  <li>FISCPER</li>
  <li>FISCVARNT</li>
  <li>FISCYEAR</li>
  <li>FISCPER3</li>
  <li>RECORDMODE</li>
  <li>_BIC_ZIO_SWEEK</li>
  <li>_B631_S_CHRTACCT</li>
  <li>_B631_S_CO_AREA</li>
  <li>_BIC_ZIO_CMPCD</li>
  <li>_B631_S_PROFTCTR</li>
  <li>_B631_S_COSTCNTR</li>
  <li>_B631_S_FUNCAREA</li>
  <li>_BIC_ZIO_VER</li>
  <li>_BIC_ZIO_SAUDT</li>
  <li>_B631_S_GL_ACCT</li>
  <li>_BIC_ZWWPC_PA1</li>
  <li>_BIC_ZWWSC_PA1</li>
  <li>CURRENCY</li>
  <li>_B631_S_LEDGER</li>
  <li>_B631_S_AMOUNT (SUM)</li>
  <li>_BIC_ZIO_D1AMT (SUM)</li>
  <li>_BIC_ZIO_D2AMT (SUM)</li>
  <li>_BIC_ZIO_D3AMT (SUM)</li>
  <li>_BIC_ZIO_D4AMT (SUM)</li>
  <li>_BIC_ZIO_D5AMT (SUM)</li>
  <li>_BIC_ZIO_D6AMT (SUM)</li>
  <li>_BIC_ZIO_D7AMT (SUM)</li>
</ul>

<!-- 8. API COST CALCULATIONS -->
API COST : 0.0000 USD
