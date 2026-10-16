<!-- DOCUMENT HEADER -->
<div style="border-bottom:1px solid #ccc;padding-bottom:8px;margin-bottom:16px;">
  <b>Author:</b> Ascendion AAVA<br>
  <b>Created On:</b> 2026-10-16<br>
  <b>Description:</b> Technical documentation for HANA Calculation View 'CV_COMP_MD_COMPFL_STATIC'. The view references the table 'CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG' and processes its data through multiple modeling nodes. The XML does not provide further business context.
</div>

<!-- 1. Overview of Program -->
<p>The object 'CV_COMP_MD_COMPFL_STATIC' is a HANA Calculation View. Its primary purpose is to model and expose data from the underlying table 'CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG' using a sequence of projection and aggregation nodes. The main processing involves structured data flow through these nodes, enabling controlled output mapping.</p>

<!-- 2. Code Structure and Design -->
<p><b>Structure:</b> The Calculation View is structured with a source table node referencing 'CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG', followed by a series of projection nodes. Each projection node processes the input data, and the outputs are further mapped through aggregation nodes before reaching the final output node. <b>Key Components:</b> The major components include the source table node, multiple projection nodes, aggregation nodes, and the output node. These components are interconnected, forming a linear data processing pipeline. <b>Dependencies & Performance:</b> The primary dependency is the referenced table 'CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG'. The XML shows standard node-based modeling without complex joins, filters, or calculated expressions, indicating straightforward processing and low dependency complexity.</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto;background:#f9f9f9;padding:16px;border-radius:8px;">
  <div style="display:grid;grid-template-columns:repeat(4,220px);grid-auto-rows:80px;grid-gap:32px;align-items:center;">
    <div style="grid-column:1;grid-row:1;background:#e3e8f0;border-radius:6px;padding:16px;text-align:center;font-weight:bold;">Source Table<br>CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</div>
    <div style="grid-column:2;grid-row:2;background:#dde7dd;border-radius:6px;padding:16px;text-align:center;font-weight:bold;">Projection Node 1</div>
    <div style="grid-column:3;grid-row:3;background:#dde7dd;border-radius:6px;padding:16px;text-align:center;font-weight:bold;">Projection Node 2</div>
    <div style="grid-column:4;grid-row:4;background:#dde7dd;border-radius:6px;padding:16px;text-align:center;font-weight:bold;">Projection Node 3</div>
    <div style="grid-column:2;grid-row:5;background:#f7e7d7;border-radius:6px;padding:16px;text-align:center;font-weight:bold;">Aggregation Node 1</div>
    <div style="grid-column:3;grid-row:6;background:#f7e7d7;border-radius:6px;padding:16px;text-align:center;font-weight:bold;">Aggregation Node 2</div>
    <div style="grid-column:4;grid-row:7;background:#f7e7d7;border-radius:6px;padding:16px;text-align:center;font-weight:bold;">Aggregation Node 3</div>
    <div style="grid-column:4;grid-row:8;background:#cdd7ed;border-radius:6px;padding:16px;text-align:center;font-weight:bold;">Output Node</div>
    <!-- Arrows -->
    <div style="grid-column:1;grid-row:1;grid-column-end:2;grid-row-end:2;justify-self:end;align-self:center;font-size:24px;">→</div>
    <div style="grid-column:2;grid-row:2;grid-column-end:3;grid-row-end:3;justify-self:end;align-self:center;font-size:24px;">→</div>
    <div style="grid-column:3;grid-row:3;grid-column-end:4;grid-row-end:4;justify-self:end;align-self:center;font-size:24px;">→</div>
    <div style="grid-column:4;grid-row:4;grid-column-end:4;grid-row-end:5;justify-self:center;align-self:end;font-size:24px;">↓</div>
    <div style="grid-column:2;grid-row:5;grid-column-end:3;grid-row-end:6;justify-self:end;align-self:center;font-size:24px;">→</div>
    <div style="grid-column:3;grid-row:6;grid-column-end:4;grid-row-end:7;justify-self:end;align-self:center;font-size:24px;">→</div>
    <div style="grid-column:4;grid-row:7;grid-column-end:4;grid-row-end:8;justify-self:center;align-self:end;font-size:24px;">↓</div>
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
    <td>CV_COMP_MD_COMPFL_STATIC Output</td>
    <td>[Output Columns]</td>
    <td>CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</td>
    <td>[Source Columns]</td>
    <td>Direct mapping through projections; no calculated fields identified</td>
  </tr>
</table>

<!-- 5. Complexity Analysis -->
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%;">
  <tr><th>Category</th><th>Measurement</th></tr>
  <tr><td>Number of Objects/Nodes</td><td>8</td></tr>
  <tr><td>Sources Used</td><td>CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>Aggregation nodes present; no explicit aggregate functions detailed</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>None identified</td></tr>
  <tr><td>Workflow Complexity</td><td>Linear node sequence; low complexity</td></tr>
  <tr><td>Performance Considerations</td><td>Single source, no joins or filters; low complexity</td></tr>
  <tr><td>Data Volume Handling</td><td>Not specified in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single table dependency</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>Calculation View output fields as mapped from CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
