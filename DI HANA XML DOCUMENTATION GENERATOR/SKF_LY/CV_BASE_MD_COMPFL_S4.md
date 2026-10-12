<!-- DOCUMENT HEADER -->
<table>
  <tr><td><b>Author:</b></td><td>Ascendion AAVA</td></tr>
  <tr><td><b>Created On:</b></td><td>2026-10-12</td></tr>
  <tr><td><b>Description:</b></td><td>Technical documentation for the HANA Calculation View <b>CV_BASE_MD_COMPFL_S4</b>, which serves as a base view for store profile comp flag information for frozens. The view is defined as a dimension and projects data from a single data source table with selected attributes and filtering applied.</td></tr>
</table>

<!-- 1. Overview of Program -->
<p>This object is a HANA Calculation View of type <b>TREE_BASED</b> and categorized as a <b>DIMENSION</b>. Its primary purpose is to provide a base projection of store profile comp flag data for frozens, sourced from a single database table. The view applies attribute selection and filtering, exposing key fields relevant to store profiling.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View is structured with a single projection node (<b>Projection_1</b>) that sources data from the data base table <b>ZTSRP_COMPFL</b>. The projection node maps all relevant attributes directly from the source table and applies a filter to the <b>MANDT</b> field to restrict values to <b>110</b> and <b>200</b>. No calculated fields, joins, aggregations, or unions are present.<br>
<b>Key Components:</b> Major components include the data source (<b>ZTSRP_COMPFL</b>), the projection node (<b>Projection_1</b>), and the logical model defining output attributes. Each attribute is mapped directly from the source table and described in the logical model.<br>
<b>Dependencies & Performance:</b> The view depends solely on the referenced table <b>ZTSRP_COMPFL</b> in schema <b>SAP_S4</b>. There are no joins, aggregations, or nested processing, suggesting low dependency and low complexity. The only filter applied is on <b>MANDT</b>, which may improve performance by reducing data volume at the projection node.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; padding:10px; background:#f8f9fa; border-radius:8px;">
  <div style="display:grid; grid-template-columns:repeat(3, 180px); grid-template-rows:repeat(3, 80px); align-items:center; justify-items:center; gap:40px;">
    <div style="grid-column:2; grid-row:1; background:#e3e7ed; border-radius:8px; box-shadow:0 2px 6px #ccc; width:160px; height:60px; display:flex; align-items:center; justify-content:center; font-weight:bold;">Data Source:<br>ZTSRP_COMPFL</div>
    <div style="grid-column:2; grid-row:2; background:#d1f2e1; border-radius:8px; box-shadow:0 2px 6px #ccc; width:160px; height:60px; display:flex; align-items:center; justify-content:center; font-weight:bold;">Projection_1<br>(Attribute Mapping & Filter)</div>
    <div style="grid-column:2; grid-row:3; background:#fff6d1; border-radius:8px; box-shadow:0 2px 6px #ccc; width:160px; height:60px; display:flex; align-items:center; justify-content:center; font-weight:bold;">Output<br>(Logical Model)</div>
    <!-- Arrows -->
    <div style="grid-column:2; grid-row:1; justify-self:end; align-self:end;">
      <svg width="30" height="40"><line x1="15" y1="0" x2="15" y2="40" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
    </div>
    <div style="grid-column:2; grid-row:2; justify-self:end; align-self:end;">
      <svg width="30" height="40"><line x1="15" y1="0" x2="15" y2="40" stroke="#888" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
    </div>
    <svg style="display:none">
      <defs>
        <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
          <polygon points="0 0, 10 3.5, 0 7" fill="#888"/>
        </marker>
      </defs>
    </svg>
  </div>
</div>

<!-- 4. Data Mapping -->
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse:collapse;">
  <tr>
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr><td>Projection_1.MANDT</td><td>MANDT</td><td>ZTSRP_COMPFL.MANDT</td><td>MANDT</td><td>Filter applied: IN (110, 200)</td></tr>
  <tr><td>Projection_1.PRCTR</td><td>PRCTR</td><td>ZTSRP_COMPFL.PRCTR</td><td>PRCTR</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.STRNUM</td><td>STRNUM</td><td>ZTSRP_COMPFL.STRNUM</td><td>STRNUM</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.COMP_VER</td><td>COMP_VER</td><td>ZTSRP_COMPFL.COMP_VER</td><td>COMP_VER</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZWEEK</td><td>ZWEEK</td><td>ZTSRP_COMPFL.ZWEEK</td><td>ZWEEK</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZMONTH</td><td>ZMONTH</td><td>ZTSRP_COMPFL.ZMONTH</td><td>ZMONTH</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.ZYEAR</td><td>ZYEAR</td><td>ZTSRP_COMPFL.ZYEAR</td><td>ZYEAR</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.FS_COMP_PRE</td><td>FS_COMP_PRE</td><td>ZTSRP_COMPFL.FS_COMP_PRE</td><td>FS_COMP_PRE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.RX_COMP_PRE</td><td>RX_COMP_PRE</td><td>ZTSRP_COMPFL.RX_COMP_PRE</td><td>RX_COMP_PRE</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.FS_COMP_MON</td><td>FS_COMP_MON</td><td>ZTSRP_COMPFL.FS_COMP_MON</td><td>FS_COMP_MON</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.RX_COMP_MON</td><td>RX_COMP_MON</td><td>ZTSRP_COMPFL.RX_COMP_MON</td><td>RX_COMP_MON</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.FS_COMP_WK</td><td>FS_COMP_WK</td><td>ZTSRP_COMPFL.FS_COMP_WK</td><td>FS_COMP_WK</td><td>Direct mapping</td></tr>
  <tr><td>Projection_1.RX_COMP_WK</td><td>RX_COMP_WK</td><td>ZTSRP_COMPFL.RX_COMP_WK</td><td>RX_COMP_WK</td><td>Direct mapping</td></tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse:collapse;">
  <tr><th>Category</th><th>Measurement</th></tr>
  <tr><td>Number of Objects/Nodes</td><td>2 (Data Source, Projection Node)</td></tr>
  <tr><td>Sources Used</td><td>ZTSRP_COMPFL</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>None identified</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>MANDT filter (IN 110, 200)</td></tr>
  <tr><td>Workflow Complexity</td><td>Simple linear projection from source to output</td></tr>
  <tr><td>Performance Considerations</td><td>Single filter on MANDT may improve selectivity; no joins or aggregations</td></tr>
  <tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single table dependency</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>MANDT</li>
  <li>PRCTR</li>
  <li>STRNUM</li>
  <li>COMP_VER</li>
  <li>ZWEEK</li>
  <li>ZMONTH</li>
  <li>ZYEAR</li>
  <li>FS_COMP_PRE</li>
  <li>RX_COMP_PRE</li>
  <li>FS_COMP_MON</li>
  <li>RX_COMP_MON</li>
  <li>FS_COMP_WK</li>
  <li>RX_COMP_WK</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
