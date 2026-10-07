<!-- DOCUMENT HEADER -->
<table style="width:100%;border-collapse:collapse;margin-bottom:16px;">
  <tr>
    <td style="width:25%;"><b>Author:</b></td>
    <td style="width:75%;">Ascendion AAVA</td>
  </tr>
  <tr>
    <td><b>Created On:</b></td>
    <td>2026-10-07</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td>Technical documentation for a HANA Calculation View named <b>CV_BASE_FIN_FLASH_SALES_CAR</b>, serving as a base view for Flash Sales from CAR. The view is structured for aggregation and reporting of sales-related data, filtered by update timestamp parameters.</td>
  </tr>
</table>

<!-- 1. Overview of Program -->
<p><b>Type:</b> Calculation View (CUBE, TREE_BASED). This object provides an aggregated base view for Flash Sales data sourced from the table <b>FLASH_SALES_VT_CAR</b>. Its main processing involves projecting and aggregating sales-related fields, filtered by update timestamp parameters.</p>

<!-- 2. Code Structure and Design -->
<p>
<b>Structure:</b> The Calculation View is organized as a single projection node (<b>Projection_1</b>) that sources data from the base table <b>FLASH_SALES_VT_CAR</b> within the schema <b>CVS_FRIP</b>. It defines two input parameters for update timestamp filtering and includes calculated attributes based on these parameters. The projection node maps all relevant fields from the source and applies a filter to restrict records by update timestamp range. The logical model specifies attributes and measures, with aggregation (sum, max) applied to various sales and timestamp fields.<br>
<b>Key Components:</b> Major components include the data source (<b>FLASH_SALES_VT_CAR</b>), projection node (<b>Projection_1</b>), input parameters (<b>IP_UPD_TIMESTAMP_FROM</b>, <b>IP_UPD_TIMESTAMP_TO</b>), calculated attributes (<b>CAL_UPD_TIMESTAMP_FROM</b>, <b>CAL_UPD_TIMESTAMP_TO</b>), mapped view attributes, and aggregated measures. The output is structured for reporting, with aggregation semantics.<br>
<b>Dependencies & Performance:</b> The Calculation View depends on the underlying table <b>FLASH_SALES_VT_CAR</b> in schema <b>CVS_FRIP</b>. Performance-relevant features include the use of aggregation functions, a filter on update timestamp, and calculated attributes derived from input parameters. No joins or unions are present, and processing complexity is contained within a single projection node.
</p>

<!-- 3. Data Flow and Processing Logic -->
<div style="overflow-x:auto; padding:10px; background:#f7f7fa; border-radius:8px;">
  <div style="display:grid; grid-template-columns:repeat(3, 220px); grid-template-rows:repeat(3, 80px); align-items:center; justify-items:center; gap:24px;">
    <!-- Data Source -->
    <div style="grid-column:1;grid-row:2;background:#e3e7fb;border-radius:6px;padding:18px;text-align:center;font-weight:bold;border:1px solid #b4b8d6;">FLASH_SALES_VT_CAR<br/><span style="font-size:12px;">(DATA_BASE_TABLE)</span></div>
    <!-- Arrow to Projection -->
    <div style="grid-column:2;grid-row:2;align-self:center;">
      <svg width="44" height="30"><line x1="2" y1="15" x2="42" y2="15" stroke="#5a5a77" stroke-width="2" marker-end="url(#arrowhead)"/></svg>
      <svg width="0" height="0">
        <defs>
          <marker id="arrowhead" markerWidth="6" markerHeight="6" refX="3" refY="3" orient="auto">
            <polygon points="0,0 6,3 0,6" fill="#5a5a77"/>
          </marker>
        </defs>
      </svg>
    </div>
    <!-- Projection Node -->
    <div style="grid-column:3;grid-row:2;background:#d7f7e7;border-radius:6px;padding:18px;text-align:center;font-weight:bold;border:1px solid #a7d7c7;">Projection_1<br/><span style="font-size:12px;">(Projection, Filtering, Calculated Attr.)</span></div>
    <!-- Parameters -->
    <div style="grid-column:1;grid-row:1;background:#fff7e7;border-radius:6px;padding:12px;text-align:center;font-weight:bold;border:1px solid #e7c7a7;">IP_UPD_TIMESTAMP_FROM<br/>IP_UPD_TIMESTAMP_TO<br/><span style="font-size:12px;">(Input Parameters)</span></div>
    <!-- Arrow from Parameters to Projection -->
    <div style="grid-column:2;grid-row:1;align-self:center;">
      <svg width="44" height="30"><line x1="2" y1="15" x2="42" y2="15" stroke="#5a5a77" stroke-width="2" marker-end="url(#arrowhead2)"/></svg>
      <svg width="0" height="0">
        <defs>
          <marker id="arrowhead2" markerWidth="6" markerHeight="6" refX="3" refY="3" orient="auto">
            <polygon points="0,0 6,3 0,6" fill="#5a5a77"/>
          </marker>
        </defs>
      </svg>
    </div>
    <!-- Calculated Attributes -->
    <div style="grid-column:3;grid-row:1;background:#e7f7f7;border-radius:6px;padding:12px;text-align:center;font-weight:bold;border:1px solid #b7d7d7;">CAL_UPD_TIMESTAMP_FROM<br/>CAL_UPD_TIMESTAMP_TO<br/><span style="font-size:12px;">(Calculated Attr.)</span></div>
    <!-- Arrow from Projection to Output -->
    <div style="grid-column:2;grid-row:3;align-self:center;">
      <svg width="44" height="30"><line x1="2" y1="15" x2="42" y2="15" stroke="#5a5a77" stroke-width="2" marker-end="url(#arrowhead3)"/></svg>
      <svg width="0" height="0">
        <defs>
          <marker id="arrowhead3" markerWidth="6" markerHeight="6" refX="3" refY="3" orient="auto">
            <polygon points="0,0 6,3 0,6" fill="#5a5a77"/>
          </marker>
        </defs>
      </svg>
    </div>
    <!-- Output -->
    <div style="grid-column:3;grid-row:3;background:#f7e7fa;border-radius:6px;padding:18px;text-align:center;font-weight:bold;border:1px solid #d7b7d7;">Output<br/><span style="font-size:12px;">(Aggregated Reporting View)</span></div>
  </div>
</div>

<!-- 4. Data Mapping -->
<table style="width:100%;border-collapse:collapse;margin-top:16px;margin-bottom:16px;">
  <tr style="background:#f2f2f2;">
    <th>Target Object/Field Name</th>
    <th>Target Column Name</th>
    <th>Source Object/Field Name</th>
    <th>Source Column Name</th>
    <th>Remarks</th>
  </tr>
  <tr>
    <td>Projection_1 / MANDT</td>
    <td>MANDT</td>
    <td>FLASH_SALES_VT_CAR</td>
    <td>MANDT</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1 / RETAILSTOREID</td>
    <td>RETAILSTOREID</td>
    <td>FLASH_SALES_VT_CAR</td>
    <td>RETAILSTOREID</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1 / BUSINESSDAYDATE</td>
    <td>BUSINESSDAYDATE</td>
    <td>FLASH_SALES_VT_CAR</td>
    <td>BUSINESSDAYDATE</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1 / FS_SALESAMOUNT</td>
    <td>FS_SALESAMOUNT</td>
    <td>FLASH_SALES_VT_CAR</td>
    <td>FS_SALESAMOUNT</td>
    <td>Aggregated (sum)</td>
  </tr>
  <tr>
    <td>Projection_1 / REDUCTIONAMOUNT</td>
    <td>REDUCTIONAMOUNT</td>
    <td>FLASH_SALES_VT_CAR</td>
    <td>REDUCTIONAMOUNT</td>
    <td>Aggregated (sum)</td>
  </tr>
  <tr>
    <td>Projection_1 / RX_SALESAMOUNT</td>
    <td>RX_SALESAMOUNT</td>
    <td>FLASH_SALES_VT_CAR</td>
    <td>RX_SALESAMOUNT</td>
    <td>Aggregated (sum)</td>
  </tr>
  <tr>
    <td>Projection_1 / CAL_FS_UNITS</td>
    <td>CAL_FS_UNITS</td>
    <td>FLASH_SALES_VT_CAR</td>
    <td>CAL_FS_UNITS</td>
    <td>Aggregated (sum)</td>
  </tr>
  <tr>
    <td>Projection_1 / EMP_REDUCTIONAMOUNT</td>
    <td>EMP_REDUCTIONAMOUNT</td>
    <td>FLASH_SALES_VT_CAR</td>
    <td>EMP_REDUCTIONAMOUNT</td>
    <td>Aggregated (sum)</td>
  </tr>
  <tr>
    <td>Projection_1 / CAL_RX_CNT_GE84_NS</td>
    <td>CAL_RX_CNT_GE84_NS</td>
    <td>FLASH_SALES_VT_CAR</td>
    <td>CAL_RX_CNT_GE84_NS</td>
    <td>Aggregated (sum)</td>
  </tr>
  <tr>
    <td>Projection_1 / CAL_RX_CNT_GE84_RE</td>
    <td>CAL_RX_CNT_GE84_RE</td>
    <td>FLASH_SALES_VT_CAR</td>
    <td>CAL_RX_CNT_GE84_RE</td>
    <td>Aggregated (sum)</td>
  </tr>
  <tr>
    <td>Projection_1 / CAL_RX_CNT_NS</td>
    <td>CAL_RX_CNT_NS</td>
    <td>FLASH_SALES_VT_CAR</td>
    <td>CAL_RX_CNT_NS</td>
    <td>Aggregated (sum)</td>
  </tr>
  <tr>
    <td>Projection_1 / CAL_RX_CNT_RE</td>
    <td>CAL_RX_CNT_RE</td>
    <td>FLASH_SALES_VT_CAR</td>
    <td>CAL_RX_CNT_RE</td>
    <td>Aggregated (sum)</td>
  </tr>
  <tr>
    <td>Projection_1 / RX_UPD_TIMESTAMP</td>
    <td>RX_UPD_TIMESTAMP</td>
    <td>FLASH_SALES_VT_CAR</td>
    <td>RX_UPD_TIMESTAMP</td>
    <td>Aggregated (max)</td>
  </tr>
  <tr>
    <td>Projection_1 / FS_UPD_TIMESTAMP</td>
    <td>FS_UPD_TIMESTAMP</td>
    <td>FLASH_SALES_VT_CAR</td>
    <td>FS_UPD_TIMESTAMP</td>
    <td>Aggregated (max)</td>
  </tr>
  <tr>
    <td>Projection_1 / SCRIPTS_UPD_TIMESTAMP</td>
    <td>SCRIPTS_UPD_TIMESTAMP</td>
    <td>FLASH_SALES_VT_CAR</td>
    <td>SCRIPTS_UPD_TIMESTAMP</td>
    <td>Aggregated (max)</td>
  </tr>
  <tr>
    <td>Projection_1 / ZZ_UPD_TIMESTAMP</td>
    <td>ZZ_UPD_TIMESTAMP</td>
    <td>FLASH_SALES_VT_CAR</td>
    <td>ZZ_UPD_TIMESTAMP</td>
    <td>Direct mapping; filter applied</td>
  </tr>
  <tr>
    <td>Projection_1 / TRANSCURRENCY</td>
    <td>TRANSCURRENCY</td>
    <td>FLASH_SALES_VT_CAR</td>
    <td>TRANSCURRENCY</td>
    <td>Direct mapping</td>
  </tr>
  <tr>
    <td>Projection_1 / CVD_AMOUNT</td>
    <td>CVD_AMOUNT</td>
    <td>FLASH_SALES_VT_CAR</td>
    <td>CVD_AMOUNT</td>
    <td>Aggregated (sum)</td>
  </tr>
  <tr>
    <td>Projection_1 / CAL_CVD_UNITS</td>
    <td>CAL_CVD_UNITS</td>
    <td>FLASH_SALES_VT_CAR</td>
    <td>CAL_CVD_UNITS</td>
    <td>Aggregated (sum)</td>
  </tr>
  <tr>
    <td>Projection_1 / CAL_UPD_TIMESTAMP_FROM</td>
    <td>CAL_UPD_TIMESTAMP_FROM</td>
    <td>Parameter</td>
    <td>IP_UPD_TIMESTAMP_FROM</td>
    <td>Calculated: formula = '$$IP_UPD_TIMESTAMP_FROM$$'</td>
  </tr>
  <tr>
    <td>Projection_1 / CAL_UPD_TIMESTAMP_TO</td>
    <td>CAL_UPD_TIMESTAMP_TO</td>
    <td>Parameter</td>
    <td>IP_UPD_TIMESTAMP_TO</td>
    <td>Calculated: formula = '$$IP_UPD_TIMESTAMP_TO$$'</td>
  </tr>
</table>

<!-- 5. Complexity Analysis -->
<table style="width:100%;border-collapse:collapse;margin-top:16px;margin-bottom:16px;">
  <tr style="background:#f2f2f2;">
    <th>Category</th>
    <th>Measurement</th>
  </tr>
  <tr><td>Number of Objects/Nodes</td><td>3 (Data Source, Projection Node, Output)</td></tr>
  <tr><td>Sources Used</td><td>FLASH_SALES_VT_CAR (schema: CVS_FRIP)</td></tr>
  <tr><td>Joins</td><td>None identified</td></tr>
  <tr><td>Temporary/Cached Data</td><td>None identified</td></tr>
  <tr><td>Aggregate Functions</td><td>sum, max</td></tr>
  <tr><td>Data Manipulation</td><td>No data manipulation identified</td></tr>
  <tr><td>Conditional Logic</td><td>Filter: ZZ_UPD_TIMESTAMP >= CAL_UPD_TIMESTAMP_FROM and ZZ_UPD_TIMESTAMP <= CAL_UPD_TIMESTAMP_TO</td></tr>
  <tr><td>Workflow Complexity</td><td>Single projection node, direct mapping and aggregation; low complexity</td></tr>
  <tr><td>Performance Considerations</td><td>Aggregation and filtering on update timestamp; dependent on source table size</td></tr>
  <tr><td>Data Volume Handling</td><td>Not explicitly defined in XML</td></tr>
  <tr><td>Dependency Complexity</td><td>Single source table dependency</td></tr>
  <tr><td>Overall Complexity Score</td><td>Low</td></tr>
</table>

<!-- 6. Sensitive and Privacy Data Assessment -->
No sensitive data found

<!-- 7. Key Outputs -->
<ul>
  <li>MANDT</li>
  <li>RETAILSTOREID</li>
  <li>BUSINESSDAYDATE</li>
  <li>FS_SALESAMOUNT</li>
  <li>REDUCTIONAMOUNT</li>
  <li>RX_SALESAMOUNT</li>
  <li>CAL_FS_UNITS</li>
  <li>EMP_REDUCTIONAMOUNT</li>
  <li>CAL_RX_CNT_GE84_NS</li>
  <li>CAL_RX_CNT_GE84_RE</li>
  <li>CAL_RX_CNT_NS</li>
  <li>CAL_RX_CNT_RE</li>
  <li>RX_UPD_TIMESTAMP</li>
  <li>FS_UPD_TIMESTAMP</li>
  <li>SCRIPTS_UPD_TIMESTAMP</li>
  <li>ZZ_UPD_TIMESTAMP</li>
  <li>TRANSCURRENCY</li>
  <li>CVD_AMOUNT</li>
  <li>CAL_CVD_UNITS</li>
  <li>CAL_UPD_TIMESTAMP_FROM</li>
  <li>CAL_UPD_TIMESTAMP_TO</li>
</ul>

<!-- 8. API Cost Calculations -->
API COST : 0.0000 USD
