<!-- DOCUMENT HEADER -->
<table style="width:100%; border-collapse:collapse;">
<tr><td style="width:20%;"><b>Author:</b></td><td>Ascendion AAVA</td></tr>
<tr><td><b>Created On:</b></td><td>{{CURRENT_DATE}}</td></tr>
<tr><td><b>Description:</b></td><td>HANA Calculation View 'CV_BASE_MD_COMPFL_S4' serves as a base view for store profile comp flag for frozens, projecting and filtering data from a single database table source.</td></tr>
</table>
<br/>

<!-- 1. Overview of Program -->
<p>CV_BASE_MD_COMPFL_S4 is a HANA Calculation View of type 'TREE_BASED' with a data category 'DIMENSION'. Its primary purpose is to provide a base view for store profile comp flag information related to frozens by projecting relevant fields from a database table. The view applies a filter on the 'MANDT' field and exposes key store profile attributes for downstream consumption.</p>
<br/>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View consists of a single projection node ('Projection_1') sourcing data from the database table 'ZTSRP_COMPFL'. The projection includes explicit mappings for thirteen fields, with a filter applied to the 'MANDT' field for values '110' and '200'. No calculated fields, joins, unions, or aggregations are present. <b>Key Components:</b> The main components are the data source ('ZTSRP_COMPFL'), the projection node, field mappings, and the filter on 'MANDT'. The logical model defines attributes for each output field with corresponding descriptions. <b>Dependencies & Performance:</b> The view depends solely on the database table 'ZTSRP_COMPFL'. No joins or aggregations are used, minimizing complexity and potential performance overhead. The filter on 'MANDT' may improve selectivity and efficiency. No temporary or cached data processing is identified.</p>
<br/>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; background:#f9f9f9; padding:20px; border-radius:10px;">
<div style="display:grid; grid-template-columns:repeat(3, 200px); grid-template-rows:repeat(3, 100px); align-items:center; justify-items:center; gap:40px;">
  <div style="grid-column:2; grid-row:1; background:#e3e6f3; border-radius:8px; box-shadow:0 2px 8px #ccc; padding:20px; text-align:center; font-weight:bold;">Data Source<br/>ZTSRP_COMPFL</div>
  <div style="grid-column:2; grid-row:2; background:#d1f7e0; border-radius:8px; box-shadow:0 2px 8px #ccc; padding:20px; text-align:center; font-weight:bold;">Projection_1<br/>Filter: MANDT IN (110, 200)</div>
  <div style="grid-column:2; grid-row:3; background:#ffe6c1; border-radius:8px; box-shadow:0 2px 8px #ccc; padding:20px; text-align:center; font-weight:bold;">Output<br/>13 Attributes</div>
  <svg style="grid-column:2; grid-row:1/3; width:30px; height:100px; align-self:end; justify-self:center;" xmlns="http://www.w3.org/2000/svg"><defs><marker id="arrow" markerWidth="10" markerHeight="10" refX="10" refY="5" orient="auto" markerUnits="strokeWidth"><path d="M0,0 L10,5 L0,10 Z" fill="#7a7a7a"/></marker></defs><line x1="15" y1="0" x2="15" y2="100" stroke="#7a7a7a" stroke-width="3" marker-end="url(#arrow)"/></svg>
  <svg style="grid-column:2; grid-row:2/4; width:30px; height:100px; align-self:end; justify-self:center;" xmlns="http://www.w3.org/2000/svg"><defs><marker id="arrow2" markerWidth="10" markerHeight="10" refX="10" refY="5" orient="auto" markerUnits="strokeWidth"><path d="M0,0 L10,5 L0,10 Z" fill="#7a7a7a"/></marker></defs><line x1="15" y1="0" x2="15" y2="100" stroke="#7a7a7a" stroke-width="3" marker-end="url(#arrow2)"/></svg>
</div>
</div>
<br/>

<!-- 4. Data Mapping -->
<table style="width:100%; border-collapse:collapse;">
<thead><tr style="background:#ededed;">
<th>Target Object/Field Name</th><th>Target Column Name</th><th>Source Object/Field Name</th><th>Source Column Name</th><th>Remarks</th>
</tr></thead>
<tbody>
<tr><td>Projection_1.MANDT</td><td>MANDT</td><td>ZTSRP_COMPFL</td><td>MANDT</td><td>Filter applied: IN (110, 200)</td></tr>
<tr><td>Projection_1.PRCTR</td><td>PRCTR</td><td>ZTSRP_COMPFL</td><td>PRCTR</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.STRNUM</td><td>STRNUM</td><td>ZTSRP_COMPFL</td><td>STRNUM</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.COMP_VER</td><td>COMP_VER</td><td>ZTSRP_COMPFL</td><td>COMP_VER</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZWEEK</td><td>ZWEEK</td><td>ZTSRP_COMPFL</td><td>ZWEEK</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZMONTH</td><td>ZMONTH</td><td>ZTSRP_COMPFL</td><td>ZMONTH</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.ZYEAR</td><td>ZYEAR</td><td>ZTSRP_COMPFL</td><td>ZYEAR</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.FS_COMP_PRE</td><td>FS_COMP_PRE</td><td>ZTSRP_COMPFL</td><td>FS_COMP_PRE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_COMP_PRE</td><td>RX_COMP_PRE</td><td>ZTSRP_COMPFL</td><td>RX_COMP_PRE</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.FS_COMP_MON</td><td>FS_COMP_MON</td><td>ZTSRP_COMPFL</td><td>FS_COMP_MON</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_COMP_MON</td><td>RX_COMP_MON</td><td>ZTSRP_COMPFL</td><td>RX_COMP_MON</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.FS_COMP_WK</td><td>FS_COMP_WK</td><td>ZTSRP_COMPFL</td><td>FS_COMP_WK</td><td>Direct mapping</td></tr>
<tr><td>Projection_1.RX_COMP_WK</td><td>RX_COMP_WK</td><td>ZTSRP_COMPFL</td><td>RX_COMP_WK</td><td>Direct mapping</td></tr>
</tbody>
</table>
<br/>

<!-- 5. Complexity Analysis -->
<table style="width:100%; border-collapse:collapse;">
<tr><td><b>Category</b></td><td><b>Measurement</b></td></tr>
<tr><td>Number of Objects/Nodes</td><td>2 (Data Source, Projection)</td></tr>
<tr><td>Sources Used</td><td>ZTSRP_COMPFL (database table)</td></tr>
<tr><td>Joins</td><td>None</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>None</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>Filter: MANDT IN (110, 200)</td></tr>
<tr><td>Workflow Complexity</td><td>Low; single projection node with direct field mappings</td></tr>
<tr><td>Performance Considerations</td><td>Minimal; single table access and filter</td></tr>
<tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
<tr><td>Dependency Complexity</td><td>Single dependency on ZTSRP_COMPFL</td></tr>
<tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>
<br/>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found
<br/>

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
<br/>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
