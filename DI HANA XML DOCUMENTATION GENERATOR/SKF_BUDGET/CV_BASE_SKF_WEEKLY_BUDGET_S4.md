<!-- DOCUMENT HEADER -->
<table style="width:100%;border-collapse:collapse;margin-bottom:12px;">
<tr><td style="font-weight:bold;width:20%;">Author:</td><td>Ascendion AAVA</td></tr>
<tr><td style="font-weight:bold;">Created On:</td><td>2026-10-12</td></tr>
<tr><td style="font-weight:bold;">Description:</td><td>This HANA XML file defines a Calculation View named <b>CV_BASE_SKF_WEEKLY_BUDGET_S4</b>, designed as a base view for store reporting on SKF budget frozen DSO - DS09 (weekly snapshot). It models and aggregates data from two database tables, providing a unified output for reporting purposes.</td></tr>
</table>

<!-- 1. OVERVIEW OF PROGRAM -->
<p><b>Overview of Program:</b><br>
This object is a HANA Calculation View of type <b>CUBE</b> with a tree-based scenario. Its primary function is to unify and aggregate weekly budget data from two source tables, applying conditional logic and filters to distinguish between frozen and live data. The view outputs a consolidated dataset for store reporting, including calculated and restricted measures.</p>

<!-- 2. CODE STRUCTURE AND DESIGN -->
<p><b>Structure:</b> The Calculation View comprises three main nodes: <b>Frozen_Cube</b> and <b>Live_Cube</b> (both Projection Views), and <b>Union_1</b> (Union View). Data is sourced from two database tables (<b>AZSRP_DS092_VT_S4</b> and <b>AZSRP_DS031_VT_S4</b>). Each projection applies filters based on the <b>MANDT</b> field and the <b>IP_FC_COUNT</b> input parameter. The Union node combines the projections, mapping and transforming fields as required, and introduces a <b>FLAG</b> field to distinguish data types. The logical model defines output attributes, base measures, restricted measures, and calculated measures. <br><b>Key Components:</b> Major components include local variables (<b>IP_VERSION</b>, <b>IP_FC_COUNT</b>), two data sources, two projection nodes, a union node, and a logical model with defined attributes and measures. The <b>IP_FC_COUNT</b> variable is derived using a scalar function and variable mapping. The <b>Union_1</b> node consolidates data and applies constant mappings for certain fields. Measures include a dummy base measure, restricted measures for FC and LC quantities, and a calculated measure using conditional logic.<br><b>Dependencies & Performance:</b> The Calculation View depends on two database tables and a scalar function (<b>CVS_FRIP.Composite.Master::SFN_SKF_FC_FLAG</b>) for parameter derivation. Filters and restricted measures optimize data selection, while aggregation is performed on quantity fields. No explicit joins or materialized intermediate data are present. Performance considerations include filter expressions, aggregation, and conditional logic, but no runtime metrics are provided in the XML.</p>

<!-- 3. DATA FLOW AND PROCESSING LOGIC -->
<div style="width:100%;overflow-x:auto;background:#fafbfc;border:1px solid #e1e4e8;padding:16px 8px 16px 8px;border-radius:8px;">
<div style="display:grid;grid-template-columns:repeat(5,180px);grid-template-rows:repeat(4,80px);align-items:center;justify-items:center;gap:32px;">
  <div style="grid-column:1;grid-row:1;background:#e6f7ff;border-radius:6px;padding:12px 0;width:160px;text-align:center;font-weight:bold;">AZSRP_DS092_VT_S4<br/><span style="font-size:12px;color:#888;">Data Source</span></div>
  <div style="grid-column:5;grid-row:1;background:#e6f7ff;border-radius:6px;padding:12px 0;width:160px;text-align:center;font-weight:bold;">AZSRP_DS031_VT_S4<br/><span style="font-size:12px;color:#888;">Data Source</span></div>
  <div style="grid-column:1;grid-row:2;background:#fff7e6;border-radius:6px;padding:12px 0;width:160px;text-align:center;font-weight:bold;">Frozen_Cube<br/><span style="font-size:12px;color:#888;">Projection</span></div>
  <div style="grid-column:5;grid-row:2;background:#fff7e6;border-radius:6px;padding:12px 0;width:160px;text-align:center;font-weight:bold;">Live_Cube<br/><span style="font-size:12px;color:#888;">Projection</span></div>
  <div style="grid-column:3;grid-row:3;background:#e6ffe6;border-radius:6px;padding:12px 0;width:160px;text-align:center;font-weight:bold;">Union_1<br/><span style="font-size:12px;color:#888;">Union</span></div>
  <div style="grid-column:3;grid-row:4;background:#eaeaea;border-radius:6px;padding:12px 0;width:160px;text-align:center;font-weight:bold;">Output<br/><span style="font-size:12px;color:#888;">Measure Group</span></div>

  <!-- Connectors -->
  <svg style="grid-column:1;grid-row:1/2;justify-self:end;align-self:end;" width="80" height="40"><line x1="80" y1="20" x2="160" y2="60" stroke="#1890ff" stroke-width="2" marker-end="url(#arrowhead)"/><defs><marker id="arrowhead" markerWidth="6" markerHeight="6" refX="5" refY="3" orient="auto"><polygon points="0 0,6 3,0 6" fill="#1890ff"/></marker></defs></svg>
  <svg style="grid-column:5;grid-row:1/2;justify-self:start;align-self:end;" width="80" height="40"><line x1="0" y1="20" x2="-80" y2="60" stroke="#1890ff" stroke-width="2" marker-end="url(#arrowhead2)"/><defs><marker id="arrowhead2" markerWidth="6" markerHeight="6" refX="5" refY="3" orient="auto"><polygon points="0 0,6 3,0 6" fill="#1890ff"/></marker></defs></svg>
  <svg style="grid-column:1;grid-row:2/3;justify-self:end;align-self:center;" width="180" height="40"><line x1="180" y1="20" x2="360" y2="60" stroke="#faad14" stroke-width="2" marker-end="url(#arrowhead3)"/><defs><marker id="arrowhead3" markerWidth="6" markerHeight="6" refX="5" refY="3" orient="auto"><polygon points="0 0,6 3,0 6" fill="#faad14"/></marker></defs></svg>
  <svg style="grid-column:5;grid-row:2/3;justify-self:start;align-self:center;" width="180" height="40"><line x1="0" y1="20" x2="-180" y2="60" stroke="#faad14" stroke-width="2" marker-end="url(#arrowhead4)"/><defs><marker id="arrowhead4" markerWidth="6" markerHeight="6" refX="5" refY="3" orient="auto"><polygon points="0 0,6 3,0 6" fill="#faad14"/></marker></defs></svg>
  <svg style="grid-column:3;grid-row:3/4;justify-self:center;align-self:start;" width="0" height="80"><line x1="80" y1="0" x2="80" y2="80" stroke="#52c41a" stroke-width="2" marker-end="url(#arrowhead5)"/><defs><marker id="arrowhead5" markerWidth="6" markerHeight="6" refX="5" refY="3" orient="auto"><polygon points="0 0,6 3,0 6" fill="#52c41a"/></marker></defs></svg>
</div>
</div>

<!-- 4. DATA MAPPING -->
<table style="width:100%;border-collapse:collapse;">
<thead>
<tr style="background:#f5f5f5;">
<th>Target Object/Field Name</th><th>Target Column Name</th><th>Source Object/Field Name</th><th>Source Column Name</th><th>Remarks</th>
</tr>
</thead>
<tbody>
<tr><td>Frozen_Cube</td><td>FISCPER</td><td>AZSRP_DS092_VT_S4</td><td>FISCPER</td><td>Direct mapping</td></tr>
<tr><td>Frozen_Cube</td><td>FISCVARNT</td><td>AZSRP_DS092_VT_S4</td><td>FISCVARNT</td><td>Direct mapping</td></tr>
<tr><td>Frozen_Cube</td><td>_BIC_ZIO_SWEEK</td><td>AZSRP_DS092_VT_S4</td><td>_BIC_ZIO_SWEEK</td><td>Direct mapping</td></tr>
<tr><td>Frozen_Cube</td><td>FISCYEAR</td><td>AZSRP_DS092_VT_S4</td><td>FISCYEAR</td><td>Direct mapping</td></tr>
<tr><td>Frozen_Cube</td><td>FISCPER3</td><td>AZSRP_DS092_VT_S4</td><td>FISCPER3</td><td>Direct mapping</td></tr>
<tr><td>Frozen_Cube</td><td>_B631_S_CHRTACCT</td><td>AZSRP_DS092_VT_S4</td><td>_B631_S_CHRTACCT</td><td>Direct mapping</td></tr>
<tr><td>Frozen_Cube</td><td>_BIC_ZIO_PSTY</td><td>AZSRP_DS092_VT_S4</td><td>_BIC_ZIO_PSTY</td><td>Direct mapping</td></tr>
<tr><td>Frozen_Cube</td><td>_BIC_ZIO_PSKF</td><td>AZSRP_DS092_VT_S4</td><td>_BIC_ZIO_PSKF</td><td>Direct mapping</td></tr>
<tr><td>Frozen_Cube</td><td>_B631_S_CO_AREA</td><td>AZSRP_DS092_VT_S4</td><td>_B631_S_CO_AREA</td><td>Direct mapping</td></tr>
<tr><td>Frozen_Cube</td><td>_BIC_ZIO_CMPCD</td><td>AZSRP_DS092_VT_S4</td><td>_BIC_ZIO_CMPCD</td><td>Direct mapping</td></tr>
<tr><td>Frozen_Cube</td><td>_B631_S_PROFTCTR</td><td>AZSRP_DS092_VT_S4</td><td>_B631_S_PROFTCTR</td><td>Direct mapping</td></tr>
<tr><td>Frozen_Cube</td><td>_B631_S_COSTCNTR</td><td>AZSRP_DS092_VT_S4</td><td>_B631_S_COSTCNTR</td><td>Direct mapping</td></tr>
<tr><td>Frozen_Cube</td><td>_B631_S_FUNCAREA</td><td>AZSRP_DS092_VT_S4</td><td>_B631_S_FUNCAREA</td><td>Direct mapping</td></tr>
<tr><td>Frozen_Cube</td><td>_BIC_ZIO_VER</td><td>AZSRP_DS092_VT_S4</td><td>_BIC_ZIO_VER</td><td>Direct mapping</td></tr>
<tr><td>Frozen_Cube</td><td>_BIC_ZIO_SAUDT</td><td>AZSRP_DS092_VT_S4</td><td>_BIC_ZIO_SAUDT</td><td>Direct mapping</td></tr>
<tr><td>Frozen_Cube</td><td>MANDT</td><td>AZSRP_DS092_VT_S4</td><td>MANDT</td><td>Direct mapping</td></tr>
<tr><td>Frozen_Cube</td><td>RECORDMODE</td><td>AZSRP_DS092_VT_S4</td><td>RECORDMODE</td><td>Direct mapping</td></tr>
<tr><td>Frozen_Cube</td><td>UNIT</td><td>AZSRP_DS092_VT_S4</td><td>UNIT</td><td>Direct mapping</td></tr>
<tr><td>Frozen_Cube</td><td>_BIC_ZIO_SKFQ</td><td>AZSRP_DS092_VT_S4</td><td>_BIC_ZIO_SKFQ</td><td>Direct mapping</td></tr>
<tr><td>Frozen_Cube</td><td>Filter</td><td>Frozen_Cube</td><td>MANDT, IP_FC_COUNT</td><td>(in ("MANDT",'110','200')) AND ('$$IP_FC_COUNT$$' != 0 )</td></tr>
<tr><td>Live_Cube</td><td>FISCPER</td><td>AZSRP_DS031_VT_S4</td><td>FISCPER</td><td>Direct mapping</td></tr>
<tr><td>Live_Cube</td><td>FISCVARNT</td><td>AZSRP_DS031_VT_S4</td><td>FISCVARNT</td><td>Direct mapping</td></tr>
<tr><td>Live_Cube</td><td>_BIC_ZIO_SWEEK</td><td>AZSRP_DS031_VT_S4</td><td>_BIC_ZIO_SWEEK</td><td>Direct mapping</td></tr>
<tr><td>Live_Cube</td><td>FISCYEAR</td><td>AZSRP_DS031_VT_S4</td><td>FISCYEAR</td><td>Direct mapping</td></tr>
<tr><td>Live_Cube</td><td>FISCPER3</td><td>AZSRP_DS031_VT_S4</td><td>FISCPER3</td><td>Direct mapping</td></tr>
<tr><td>Live_Cube</td><td>_B631_S_COMPCODE</td><td>AZSRP_DS031_VT_S4</td><td>_B631_S_COMPCODE</td><td>Direct mapping</td></tr>
<tr><td>Live_Cube</td><td>_BIC_ZIO_CCTR</td><td>AZSRP_DS031_VT_S4</td><td>_BIC_ZIO_CCTR</td><td>Direct mapping</td></tr>
<tr><td>Live_Cube</td><td>_BIC_ZIO_PCTR</td><td>AZSRP_DS031_VT_S4</td><td>_BIC_ZIO_PCTR</td><td>Direct mapping</td></tr>
<tr><td>Live_Cube</td><td>_BIC_ZIO_PSTY</td><td>AZSRP_DS031_VT_S4</td><td>_BIC_ZIO_PSTY</td><td>Direct mapping</td></tr>
<tr><td>Live_Cube</td><td>_BIC_ZIO_PSKF</td><td>AZSRP_DS031_VT_S4</td><td>_BIC_ZIO_PSKF</td><td>Direct mapping</td></tr>
<tr><td>Live_Cube</td><td>_B631_S_CO_AREA</td><td>AZSRP_DS031_VT_S4</td><td>_B631_S_CO_AREA</td><td>Direct mapping</td></tr>
<tr><td>Live_Cube</td><td>_BIC_ZIO_CMPCD</td><td>AZSRP_DS031_VT_S4</td><td>_BIC_ZIO_CMPCD</td><td>Direct mapping</td></tr>
<tr><td>Live_Cube</td><td>_BIC_ZIO_VER</td><td>AZSRP_DS031_VT_S4</td><td>_BIC_ZIO_VER</td><td>Direct mapping</td></tr>
<tr><td>Live_Cube</td><td>_BIC_ZIO_SAUDT</td><td>AZSRP_DS031_VT_S4</td><td>_BIC_ZIO_SAUDT</td><td>Direct mapping</td></tr>
<tr><td>Live_Cube</td><td>MANDT</td><td>AZSRP_DS031_VT_S4</td><td>MANDT</td><td>Direct mapping</td></tr>
<tr><td>Live_Cube</td><td>RECORDMODE</td><td>AZSRP_DS031_VT_S4</td><td>RECORDMODE</td><td>Direct mapping</td></tr>
<tr><td>Live_Cube</td><td>UNIT</td><td>AZSRP_DS031_VT_S4</td><td>UNIT</td><td>Direct mapping</td></tr>
<tr><td>Live_Cube</td><td>_BIC_ZIO_SKFQ</td><td>AZSRP_DS031_VT_S4</td><td>_BIC_ZIO_SKFQ</td><td>Direct mapping</td></tr>
<tr><td>Live_Cube</td><td>Filter</td><td>Live_Cube</td><td>MANDT, IP_FC_COUNT</td><td>(in ("MANDT",'110','200')) AND ('$$IP_FC_COUNT$$' = 0 )</td></tr>
<tr><td>Union_1</td><td>FISCPER</td><td>Frozen_Cube / Live_Cube</td><td>FISCPER</td><td>Direct mapping</td></tr>
<tr><td>Union_1</td><td>FISCVARNT</td><td>Frozen_Cube / Live_Cube</td><td>FISCVARNT</td><td>Direct mapping</td></tr>
<tr><td>Union_1</td><td>_BIC_ZIO_SWEEK</td><td>Frozen_Cube / Live_Cube</td><td>_BIC_ZIO_SWEEK</td><td>Direct mapping</td></tr>
<tr><td>Union_1</td><td>FISCYEAR</td><td>Frozen_Cube / Live_Cube</td><td>FISCYEAR</td><td>Direct mapping</td></tr>
<tr><td>Union_1</td><td>FISCPER3</td><td>Frozen_Cube / Live_Cube</td><td>FISCPER3</td><td>Direct mapping</td></tr>
<tr><td>Union_1</td><td>_B631_S_CHRTACCT</td><td>Frozen_Cube</td><td>_B631_S_CHRTACCT</td><td>Direct mapping</td></tr>
<tr><td>Union_1</td><td>_B631_S_CHRTACCT</td><td>Live_Cube</td><td>Constant</td><td>Constant mapping: "" (empty string)</td></tr>
<tr><td>Union_1</td><td>_BIC_ZIO_PSTY</td><td>Frozen_Cube / Live_Cube</td><td>_BIC_ZIO_PSTY</td><td>Direct mapping</td></tr>
<tr><td>Union_1</td><td>_BIC_ZIO_PSKF</td><td>Frozen_Cube / Live_Cube</td><td>_BIC_ZIO_PSKF</td><td>Direct mapping</td></tr>
<tr><td>Union_1</td><td>_B631_S_CO_AREA</td><td>Frozen_Cube / Live_Cube</td><td>_B631_S_CO_AREA</td><td>Direct mapping</td></tr>
<tr><td>Union_1</td><td>_BIC_ZIO_CMPCD</td><td>Frozen_Cube / Live_Cube</td><td>_BIC_ZIO_CMPCD</td><td>Direct mapping</td></tr>
<tr><td>Union_1</td><td>_B631_S_PROFTCTR</td><td>Frozen_Cube</td><td>_B631_S_PROFTCTR</td><td>Direct mapping</td></tr>
<tr><td>Union_1</td><td>_B631_S_PROFTCTR</td><td>Live_Cube</td><td>_BIC_ZIO_PCTR</td><td>Renamed mapping</td></tr>
<tr><td>Union_1</td><td>_B631_S_COSTCNTR</td><td>Frozen_Cube</td><td>_B631_S_COSTCNTR</td><td>Direct mapping</td></tr>
<tr><td>Union_1</td><td>_B631_S_COSTCNTR</td><td>Live_Cube</td><td>_BIC_ZIO_CCTR</td><td>Renamed mapping</td></tr>
<tr><td>Union_1</td><td>_B631_S_FUNCAREA</td><td>Frozen_Cube</td><td>_B631_S_FUNCAREA</td><td>Direct mapping</td></tr>
<tr><td>Union_1</td><td>_B631_S_FUNCAREA</td><td>Live_Cube</td><td>Constant</td><td>Constant mapping: "" (empty string)</td></tr>
<tr><td>Union_1</td><td>_BIC_ZIO_VER</td><td>Frozen_Cube / Live_Cube</td><td>_BIC_ZIO_VER</td><td>Direct mapping</td></tr>
<tr><td>Union_1</td><td>_BIC_ZIO_SAUDT</td><td>Frozen_Cube / Live_Cube</td><td>_BIC_ZIO_SAUDT</td><td>Direct mapping</td></tr>
<tr><td>Union_1</td><td>MANDT</td><td>Frozen_Cube / Live_Cube</td><td>MANDT</td><td>Direct mapping</td></tr>
<tr><td>Union_1</td><td>RECORDMODE</td><td>Frozen_Cube / Live_Cube</td><td>RECORDMODE</td><td>Direct mapping</td></tr>
<tr><td>Union_1</td><td>UNIT</td><td>Frozen_Cube / Live_Cube</td><td>UNIT</td><td>Direct mapping</td></tr>
<tr><td>Union_1</td><td>_BIC_ZIO_SKFQ</td><td>Frozen_Cube / Live_Cube</td><td>_BIC_ZIO_SKFQ</td><td>Direct mapping</td></tr>
<tr><td>Union_1</td><td>FLAG</td><td>Frozen_Cube</td><td>Constant</td><td>Constant mapping: "FC"</td></tr>
<tr><td>Union_1</td><td>FLAG</td><td>Live_Cube</td><td>Constant</td><td>Constant mapping: "LC"</td></tr>
<tr><td>Logical Model</td><td>_BIC_ZIO_SKFQ_DUMMY</td><td>Union_1</td><td>_BIC_ZIO_SKFQ</td><td>Base measure (sum aggregation)</td></tr>
<tr><td>Logical Model</td><td>RES_QUANT_FC</td><td>_BIC_ZIO_SKFQ_DUMMY</td><td>Union_1</td><td>Restricted measure: FLAG = "FC"</td></tr>
<tr><td>Logical Model</td><td>RES_QUANT_LC</td><td>_BIC_ZIO_SKFQ_DUMMY</td><td>Union_1</td><td>Restricted measure: FLAG = "LC"</td></tr>
<tr><td>Logical Model</td><td>_BIC_ZIO_SKFQ</td><td>RES_QUANT_FC / RES_QUANT_LC</td><td>Calculated measure</td><td>IF(isnull("RES_QUANT_FC"), "RES_QUANT_LC", "RES_QUANT_FC")</td></tr>
<tr><td>IP_FC_COUNT</td><td>Derived</td><td>Scalar Function</td><td>CVS_FRIP.Composite.Master::SFN_SKF_FC_FLAG</td><td>Derivation rule using IP_VERSION mapping</td></tr>
</tbody>
</table>

<!-- 5. COMPLEXITY ANALYSIS -->
<table style="width:100%;border-collapse:collapse;">
<tr><th>Category</th><th>Measurement</th></tr>
<tr><td>Number of Objects/Nodes</td><td>3 Calculation Views (Frozen_Cube, Live_Cube, Union_1); 2 Data Sources; Logical Model</td></tr>
<tr><td>Sources Used</td><td>AZSRP_DS092_VT_S4, AZSRP_DS031_VT_S4</td></tr>
<tr><td>Joins</td><td>None identified</td></tr>
<tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
<tr><td>Aggregate Functions</td><td>Sum aggregation on measures; restricted and calculated measures</td></tr>
<tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
<tr><td>Conditional Logic</td><td>Conditional expressions in calculated measure (IF)</td></tr>
<tr><td>Workflow Complexity</td><td>Medium: Multiple projections, union, conditional logic, measure calculations</td></tr>
<tr><td>Performance Considerations</td><td>Use of filters, aggregation, and restricted measures; dependency on scalar function for parameter derivation</td></tr>
<tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
<tr><td>Dependency Complexity</td><td>2 database tables; scalar function dependency</td></tr>
<tr><td>Overall Complexity Score</td><td>Medium</td></tr>
</table>

<!-- 6. SENSITIVE AND PRIVACY DATA ASSESSMENT -->
No sensitive data found

<!-- 7. KEY OUTPUTS -->
<ul>
<li>FISCPER</li>
<li>FISCVARNT</li>
<li>_BIC_ZIO_SWEEK</li>
<li>FISCYEAR</li>
<li>FISCPER3</li>
<li>_B631_S_CHRTACCT</li>
<li>_BIC_ZIO_PSTY</li>
<li>_BIC_ZIO_PSKF</li>
<li>_B631_S_CO_AREA</li>
<li>_BIC_ZIO_CMPCD</li>
<li>_B631_S_PROFTCTR</li>
<li>_B631_S_COSTCNTR</li>
<li>_B631_S_FUNCAREA</li>
<li>_BIC_ZIO_VER</li>
<li>_BIC_ZIO_SAUDT</li>
<li>MANDT</li>
<li>RECORDMODE</li>
<li>UNIT</li>
<li>FLAG</li>
<li>_BIC_ZIO_SKFQ (calculated measure)</li>
</ul>

<!-- 8. API COST CALCULATIONS -->
API COST : 0.0000 USD
