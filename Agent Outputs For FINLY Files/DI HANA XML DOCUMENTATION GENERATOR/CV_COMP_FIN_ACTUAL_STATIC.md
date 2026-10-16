<!--
DOCUMENT HEADER
-->
<div style="border-bottom:1px solid #ccc;padding-bottom:12px;margin-bottom:18px;">
  <h2>HANA XML Object Documentation</h2>
  <b>Author:</b> Ascendion AAVA<br/>
  <b>Created On:</b> 2026-10-16<br/>
  <b>Description:</b> This document provides technical documentation for the HANA XML Calculation View <b>CV_COMP_FIN_ACTUAL_STATIC</b>. The view integrates multiple base and composite calculation views, applies filters, calculated fields, and conditional logic to produce a harmonized output for financial actuals analysis. All content below is strictly derived from the input HANA XML file.
</div>

<!--
1. OVERVIEW OF PROGRAM
-->
<h3>1. Overview of Program</h3>
<p>
  <b>CV_COMP_FIN_ACTUAL_STATIC</b> is a HANA Calculation View designed to combine and process financial actuals data. It references several base and composite calculation views, applies filters, and performs field-level calculations and conditional logic to generate its output. The view structures and transforms data for further analytical consumption within the HANA modeling environment.
</p>

<!--
2. CODE STRUCTURE AND DESIGN
-->
<h3>2. Code Structure and Design</h3>
<p>
  <b>Structure:</b> The Calculation View is composed of multiple modeling nodes, including data sources, projections, joins, and calculated columns. It references several external calculation views as sources, such as <b>CV_BASE_FIN_WEEKLY_ACTUAL_S4</b>, <b>CV_COMP_MD_SRPACT_STATIC</b>, <b>CV_BASE_MD_HRRP_NODE_S4</b>, <b>CV_BASE_MD_RCALWEEK_S4</b>, <b>CV_COMP_MD_COMPFL_STATIC</b>, and <b>CV_BASE_MD_CEPCT_S4</b>. The structure includes projections, filters, calculated columns (e.g., using <code>ltrim</code>, <code>CASE</code>, <code>RIGHTSTR</code>), and conditional logic based on input parameters and source fields.
  <br/>
  <b>Key Components:</b> Major components include input parameters (e.g., <code>$$IP_VERSION$$</code>, <code>$$IP_WEEK_LY$$</code>, <code>$$IP_WEEK_CY$$</code>, <code>$$IP_VERSION_COMP_FLAG$$</code>), filter expressions, calculated fields (such as <code>ltrim("NODEVALUE",'0')</code> and <code>_B631_S_AMOUNT_NEGATIVE * -1</code>), and case statements for field derivation. The view also utilizes join and union nodes to combine data from referenced sources.
  <br/>
  <b>Dependencies & Performance:</b> The Calculation View depends on multiple external calculation views and composite functions (e.g., <code>CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK</code>). Performance-relevant characteristics include the use of filters on input parameters, join conditions, conditional expressions, and calculated columns, all of which may impact query optimization and execution within the HANA environment. No explicit caching or materialization is defined in the XML.
</p>

<!--
3. DATA FLOW AND PROCESSING LOGIC
-->
<h3>3. Data Flow and Processing Logic</h3>
<div style="overflow-x:auto;max-width:100%;padding:12px 0;">
  <div style="display:grid;grid-template-columns:repeat(6,220px);grid-auto-rows:80px;gap:24px;align-items:center;justify-items:center;background:#fafbfc;padding:18px 0;border-radius:10px;">
    <!-- Row 1: Source Nodes -->
    <div style="grid-column:1;grid-row:1;background:#e3e8f0;border-radius:8px;padding:18px 8px;text-align:center;font-weight:600;">CV_BASE_FIN_WEEKLY_ACTUAL_S4</div>
    <div style="grid-column:2;grid-row:1;background:#e3e8f0;border-radius:8px;padding:18px 8px;text-align:center;font-weight:600;">CV_COMP_MD_SRPACT_STATIC</div>
    <div style="grid-column:3;grid-row:1;background:#e3e8f0;border-radius:8px;padding:18px 8px;text-align:center;font-weight:600;">CV_BASE_MD_HRRP_NODE_S4</div>
    <div style="grid-column:4;grid-row:1;background:#e3e8f0;border-radius:8px;padding:18px 8px;text-align:center;font-weight:600;">CV_BASE_MD_RCALWEEK_S4</div>
    <div style="grid-column:5;grid-row:1;background:#e3e8f0;border-radius:8px;padding:18px 8px;text-align:center;font-weight:600;">CV_COMP_MD_COMPFL_STATIC</div>
    <div style="grid-column:6;grid-row:1;background:#e3e8f0;border-radius:8px;padding:18px 8px;text-align:center;font-weight:600;">CV_BASE_MD_CEPCT_S4</div>
    <!-- Row 2: Projections -->
    <div style="grid-column:1;grid-row:2;background:#d0f0e0;border-radius:8px;padding:14px 8px;text-align:center;">Projection 1</div>
    <div style="grid-column:2;grid-row:2;background:#d0f0e0;border-radius:8px;padding:14px 8px;text-align:center;">Projection 2</div>
    <div style="grid-column:3;grid-row:2;background:#d0f0e0;border-radius:8px;padding:14px 8px;text-align:center;">Projection 3</div>
    <div style="grid-column:4;grid-row:2;background:#d0f0e0;border-radius:8px;padding:14px 8px;text-align:center;">Projection 4</div>
    <div style="grid-column:5;grid-row:2;background:#d0f0e0;border-radius:8px;padding:14px 8px;text-align:center;">Projection 5</div>
    <div style="grid-column:6;grid-row:2;background:#d0f0e0;border-radius:8px;padding:14px 8px;text-align:center;">Projection 6</div>
    <!-- Row 3: Joins/Unions -->
    <div style="grid-column:2/4;grid-row:3;background:#f7e6c7;border-radius:8px;padding:14px 8px;text-align:center;">Join / Union</div>
    <div style="grid-column:4/6;grid-row:3;background:#f7e6c7;border-radius:8px;padding:14px 8px;text-align:center;">Join / Union</div>
    <!-- Row 4: Calculated Columns & Filters -->
    <div style="grid-column:3/5;grid-row:4;background:#e7d1f5;border-radius:8px;padding:14px 8px;text-align:center;">Calculated Fields & Filters</div>
    <!-- Row 5: Output Node -->
    <div style="grid-column:4;grid-row:5;background:#c2e0ff;border-radius:8px;padding:18px 8px;text-align:center;font-weight:600;">Output Node</div>
    <!-- Connectors (arrows) -->
    <div style="grid-column:1;grid-row:1/2;justify-self:center;width:2px;height:40px;background:#999;"></div>
    <div style="grid-column:2;grid-row:1/2;justify-self:center;width:2px;height:40px;background:#999;"></div>
    <div style="grid-column:3;grid-row:1/2;justify-self:center;width:2px;height:40px;background:#999;"></div>
    <div style="grid-column:4;grid-row:1/2;justify-self:center;width:2px;height:40px;background:#999;"></div>
    <div style="grid-column:5;grid-row:1/2;justify-self:center;width:2px;height:40px;background:#999;"></div>
    <div style="grid-column:6;grid-row:1/2;justify-self:center;width:2px;height:40px;background:#999;"></div>
    <div style="grid-column:2/4;grid-row:2/3;justify-self:center;width:80%;height:2px;background:#999;"></div>
    <div style="grid-column:4/6;grid-row:2/3;justify-self:center;width:80%;height:2px;background:#999;"></div>
    <div style="grid-column:3/5;grid-row:3/4;justify-self:center;width:80%;height:2px;background:#999;"></div>
    <div style="grid-column:4;grid-row:4/5;justify-self:center;width:2px;height:40px;background:#999;"></div>
  </div>
</div>

<!--
4. DATA MAPPING
-->
<h3>4. Data Mapping</h3>
<table border="1" cellpadding="6" style="border-collapse:collapse;width:100%;">
  <thead style="background:#f2f2f2;">
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
      <td>Output Node</td>
      <td>NODEVALUE</td>
      <td>Projection</td>
      <td>NODEVALUE</td>
      <td>Trimmed using <code>ltrim("NODEVALUE",'0')</code></td>
    </tr>
    <tr>
      <td>Output Node</td>
      <td>_B631_S_AMOUNT_NEGATIVE</td>
      <td>Projection</td>
      <td>_B631_S_AMOUNT_NEGATIVE</td>
      <td>Multiplied by -1 for negative value</td>
    </tr>
    <tr>
      <td>Output Node</td>
      <td>CAL_FS_RX_FLAG</td>
      <td>Projection</td>
      <td>_BIC_ZWWPC_PA1</td>
      <td>Derived using CASE expression: <code>CASE(LEFTSTR("_BIC_ZWWPC_PA1",2),'FS','FS','RX','RX','')</code></td>
    </tr>
    <tr>
      <td>Output Node</td>
      <td>FS_RX_COMP_WK</td>
      <td>Projection</td>
      <td>CAL_FS_RX_FLAG, FS_COMP_WK, RX_COMP_WK</td>
      <td>Derived using CASE expression: <code>CASE("CAL_FS_RX_FLAG",'FS','FS_COMP_WK','RX','RX_COMP_WK','FS_COMP_WK')</code></td>
    </tr>
    <tr>
      <td>Output Node</td>
      <td>WEEK_SUFFIX</td>
      <td>Input Parameter</td>
      <td>$$IP_WEEK_CY$$</td>
      <td>Derived using <code>RIGHTSTR('$$IP_WEEK_CY$$',2)</code></td>
    </tr>
  </tbody>
</table>

<!--
5. COMPLEXITY ANALYSIS
-->
<h3>5. Complexity Analysis</h3>
<table border="1" cellpadding="6" style="border-collapse:collapse;width:100%;">
  <thead style="background:#f2f2f2;"><tr><th>Category</th><th>Measurement</th></tr></thead>
  <tbody>
    <tr><td>Number of Objects/Nodes</td><td>6 source calculation views, multiple projections, joins, calculated columns, and an output node</td></tr>
    <tr><td>Sources Used</td><td>CV_BASE_FIN_WEEKLY_ACTUAL_S4, CV_COMP_MD_SRPACT_STATIC, CV_BASE_MD_HRRP_NODE_S4, CV_BASE_MD_RCALWEEK_S4, CV_COMP_MD_COMPFL_STATIC, CV_BASE_MD_CEPCT_S4</td></tr>
    <tr><td>Joins</td><td>Multiple joins/unions between projections and source views</td></tr>
    <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
    <tr><td>Aggregate Functions</td><td>Not explicitly identified in the XML</td></tr>
    <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
    <tr><td>Conditional Logic</td><td>CASE expressions and filter conditions based on input parameters and fields</td></tr>
    <tr><td>Workflow Complexity</td><td>Moderate; involves multiple sources, projections, joins, calculated fields, and filters</td></tr>
    <tr><td>Performance Considerations</td><td>Multiple joins, calculated columns, and input parameter-driven filters may impact performance</td></tr>
    <tr><td>Data Volume Handling</td><td>Not explicitly defined in the XML</td></tr>
    <tr><td>Dependency Complexity</td><td>Depends on 6 external calculation views and several composite functions</td></tr>
    <tr><td>Overall Complexity Score</td><td>Medium</td></tr>
  </tbody>
</table>

<!--
6. SENSITIVE AND PRIVACY DATA ASSESSMENT
-->
<h3>6. Sensitive and Privacy Data Assessment</h3>
No sensitive data found

<!--
7. KEY OUTPUTS
-->
<h3>7. Key Outputs</h3>
<ul>
  <li>NODEVALUE (trimmed)</li>
  <li>_B631_S_AMOUNT_NEGATIVE (negated value)</li>
  <li>CAL_FS_RX_FLAG (derived via CASE)</li>
  <li>FS_RX_COMP_WK (derived via CASE)</li>
  <li>WEEK_SUFFIX (last two characters of input parameter)</li>
</ul>

<!--
8. API COST CALCULATIONS
-->
<h3>8. API Cost Calculations</h3>
API COST : 0.0000 USD
