# SKF_BUDGET: BigQuery Recommendations and Consolidation Analysis

---

## 1. EXECUTIVE SUMMARY

**Actual number of SQLs analyzed:** 10  
**All supplied SQL files successfully analyzed:** Yes  
**Consolidation:** Not all supplied SQLs should be consolidated into a single query.  
**Major reusable logic identified:**  
- Multiple Calculation Views use direct 1:1 projections from source tables with only filters.
- Aggregation logic (SUM, GROUP BY) for CUBE-type Calculation Views is structurally similar across several SQLs.
- Several views (e.g., CV_COMP_SKF_BUDGET_STATIC) depend on a shared set of reusable base Calculation Views.
**Major redundancy identified:**  
- Repeated 1:1 projections from the same source tables (e.g., TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG).
- Multiple SQLs (views and procedures) perform similar aggregations and projections on the same base tables.
**Major consolidation groups:**  
- No group is suitable for full consolidation into a single object due to unique business rules, filters, and output requirements.
- Partial consolidation and reuse opportunities exist for base projection/aggregation logic.
**SQLs that should remain independent:**  
- CV_COMP_SKF_BUDGET_STATIC (complex aggregation and joins)
- STP_WSS_SRP_ATTRIBUTES_DI (procedural logic for snapshot and table population)
- CV_BASE_SKF_WEEKLY_BUDGET_S4_DI (complex union and aggregation)
**Existing objects that should be reused:**  
- All base Calculation Views with simple projections/filters should be implemented as reusable Views.
- Aggregated CUBE views should be referenced by downstream consumers, not duplicated.
**Major architectural recommendation:**  
- Implement base projections and simple aggregations as reusable Views.
- Implement complex multi-join/aggregation logic (e.g., CV_COMP_SKF_BUDGET_STATIC) as Materialized Views or Tables if required for performance.
- Retain procedural/ETL logic as independent BigQuery scripts or scheduled jobs.
**Major View / Materialized View / Physical Table recommendations:**  
- Views for all simple projections and aggregation CUBE views.
- Materialized Views or Tables for complex, multi-join, multi-source aggregations with high downstream consumption or snapshot requirements.
**Important dependency patterns:**  
- Layered Calculation Views: base projections → intermediate aggregations → final consolidated view.
- Procedural logic (STP_WSS_SRP_ATTRIBUTES_DI) acts as the ETL layer, populating snapshot tables for reporting.
**Snapshot/circular patterns:**  
- Controlled snapshot process via STP_WSS_SRP_ATTRIBUTES_DI must be preserved.
**Key performance and cost opportunities:**  
- Eliminate repeated projections/aggregations by centralizing logic in reusable Views.
- Materialize expensive multi-join aggregations to avoid repeated computation.
**Overall recommendation confidence:**  
- High for base views and aggregation logic.
- Medium for complex consolidation and snapshot logic due to unresolved external function and parameter handling.

---

## 2. INPUT VALIDATION

| Validation Item                | Result |
|-------------------------------|--------|
| Lineage provided              | Yes    |
| ZIP provided                  | Yes    |
| Actual SQL file count         | 10     |
| SQL files successfully analyzed| 10     |
| Unreadable/invalid files      | None   |
| Successfully analyzed         | Yes    |

**SQL files found in ZIP:**
- CV_BASE_MD_CEPCT_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_MD_RCALWEEK_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_MD_SRPACT_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_SKF_WEEKLY_BUDGET_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_COMP_MD_COMPFL_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_COMP_MD_SRPACT_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_COMP_SKF_BUDGET_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt
- STP_WSS_SRP_ATTRIBUTES_DI HANA to BigQuery SQL Conversion Agent.txt

---

## 3. SQL INVENTORY

| SQL File | Main Purpose | Sources | Main Transformations | Output | Upstream Dependencies | Downstream Usage |
|---|---|---|---|---|---|---|
| CV_BASE_MD_CEPCT_S4_DI | Profit Center Text Master | SAP_S4.CEPCT | Projection, filter on MANDT | Profit center text attributes | None | Used in CV_COMP_SKF_BUDGET_STATIC |
| CV_BASE_MD_COMPFL_S4_DI | Store Comp Flag Master | SAP_S4.ZTSRP_COMPFL | Projection, filter on MANDT | Store comp flag attributes | None | Used in STP_WSS_SRP_ATTRIBUTES_DI |
| CV_BASE_MD_HRRP_NODE_S4_DI | Hierarchy Node Master | SAP_S4.HRRP_NODE | Projection, filter on MANDT | Hierarchy node attributes | None | Used in CV_COMP_SKF_BUDGET_STATIC |
| CV_BASE_MD_RCALWEEK_S4_DI | Retail Calendar Master | SAP_S4.ZTFIGL_RCALWEEK | Projection, filter on RCLNT | Retail calendar week attributes | None | Used in CV_COMP_SKF_BUDGET_STATIC |
| CV_BASE_MD_SRPACT_S4_DI | Store Attribute Actuals | SAP_S4.ZTSRP_ATTR_ACT | Projection, filter, aggregation (SUM), GROUP BY | Store attribute actuals | None | Used in STP_WSS_SRP_ATTRIBUTES_DI |
| CV_BASE_SKF_WEEKLY_BUDGET_S4_DI | Weekly Budget Cube | AZSRP_DS092_VT_S4, AZSRP_DS031_VT_S4 | Union, mapping, aggregation, conditional logic | Weekly budget cube | None | Used in CV_COMP_SKF_BUDGET_STATIC |
| CV_COMP_MD_COMPFL_STATIC_DI | CompFlag Static | TBL_WSS_SRP_COMPFLAG | Projection | CompFlag static view | STP_WSS_SRP_ATTRIBUTES_DI | Used in CV_COMP_SKF_BUDGET_STATIC |
| CV_COMP_MD_SRPACT_STATIC_DI | Store Attribute Static | TBL_WSS_SRP_ATTR_ACT | Aggregation (SUM), GROUP BY | Store attribute static view | STP_WSS_SRP_ATTRIBUTES_DI | Used in CV_COMP_SKF_BUDGET_STATIC |
| CV_COMP_SKF_BUDGET_STATIC_DI | Consolidated Budget Cube | Multiple Calculation Views | Multi-join, filters, calculated columns, aggregation | Consolidated budget cube | All base/intermediate views | Final reporting/output |
| STP_WSS_SRP_ATTRIBUTES_DI | ETL: Populate Snapshot Tables | Calculation Views, Functions | Variable assignment, DELETE, INSERT, snapshot logic | TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG | CV_BASE_MD_SRPACT_S4_DI, CV_BASE_MD_COMPFL_S4_DI | CV_COMP_MD_SRPACT_STATIC_DI, CV_COMP_MD_COMPFL_STATIC_DI |

---

## 4. OBJECT TYPE RECOMMENDATION

| SQL File | Recommended Object | Data Freshness | Reuse Level | Rationale | Confidence |
|---|---|---|---|---|---|
| CV_BASE_MD_CEPCT_S4_DI | View | Near real-time | High | Simple projection, reusable in joins | High |
| CV_BASE_MD_COMPFL_S4_DI | View | Near real-time | High | Simple projection, reusable | High |
| CV_BASE_MD_HRRP_NODE_S4_DI | View | Near real-time | High | Simple projection, reusable | High |
| CV_BASE_MD_RCALWEEK_S4_DI | View | Near real-time | High | Simple projection, reusable | High |
| CV_BASE_MD_SRPACT_S4_DI | View | Near real-time | High | Aggregation, reusable in ETL and reporting | High |
| CV_BASE_SKF_WEEKLY_BUDGET_S4_DI | View | Near real-time | Medium | Complex aggregation/union, reusable | Medium |
| CV_COMP_MD_COMPFL_STATIC_DI | View | Near real-time | Medium | Simple projection, used in consolidated view | High |
| CV_COMP_MD_SRPACT_STATIC_DI | View | Near real-time | Medium | Aggregation, used in consolidated view | High |
| CV_COMP_SKF_BUDGET_STATIC_DI | Materialized View or Table | Scheduled/Snapshot | Low | Complex multi-join, heavy aggregation, snapshot/refresh needed | Medium |
| STP_WSS_SRP_ATTRIBUTES_DI | BigQuery Script/Table | Scheduled/Snapshot | N/A | Procedural ETL logic, snapshot creation | Medium |

---

## 5. COMMON LOGIC ANALYSIS

| Common Logic | SQLs Using It | Actual Similarity | Business Logic Match | Existing Object | Reusable? | Reuse Potential | Confidence |
|---|---|---|---|---|---|---|---|
| 1:1 projection from source table with filter | All base master views | Exact | Yes | Each base view | Yes | High | High |
| Aggregation (SUM, GROUP BY) of store attributes | CV_BASE_MD_SRPACT_S4_DI, CV_COMP_MD_SRPACT_STATIC_DI | High | Yes | CV_BASE_MD_SRPACT_S4_DI | Yes | High | High |
| Aggregation (SUM, GROUP BY) of comp flag | CV_BASE_MD_COMPFL_S4_DI, CV_COMP_MD_COMPFL_STATIC_DI | High | Yes | CV_BASE_MD_COMPFL_S4_DI | Yes | High | High |
| Multi-join/aggregation logic | CV_COMP_SKF_BUDGET_STATIC_DI | N/A | Unique | N/A | No | Low | High |
| Procedural ETL logic | STP_WSS_SRP_ATTRIBUTES_DI | Unique | No | N/A | No | N/A | High |

---

## 6. REDUNDANCY ANALYSIS

| Redundant Logic | SQLs Affected | What Is Repeated | Potential Reduction | Recommended Action | Confidence |
|---|---|---|---|---|---|
| 1:1 projections from source tables | All base views | Direct projections with filters | Centralize as reusable Views | Implement as reusable Views | High |
| Aggregation logic on TBL_WSS_SRP_ATTR_ACT | CV_COMP_MD_SRPACT_STATIC_DI, CV_BASE_MD_SRPACT_S4_DI | SUM, GROUP BY on same table | Use single base aggregation View | Reference single View | High |
| Aggregation logic on TBL_WSS_SRP_COMPFLAG | CV_COMP_MD_COMPFL_STATIC_DI, CV_BASE_MD_COMPFL_S4_DI | SUM, GROUP BY on same table | Use single base aggregation View | Reference single View | High |

---

## 7. REUSE RECOMMENDATIONS

| Common Logic | SQLs Using It | Existing Object | Existing Object Reusable? | Recommendation | Recommended Object Type | Rationale | Confidence |
|---|---|---|---|---|---|---|---|
| 1:1 projections with filters | All base master views | Each base view | Yes | Implement as reusable Views | View | Centralizes logic, avoids duplication | High |
| Aggregation on store attributes | CV_COMP_MD_SRPACT_STATIC_DI, CV_BASE_MD_SRPACT_S4_DI | CV_BASE_MD_SRPACT_S4_DI | Yes | Reference base aggregation View | View | Avoids duplicate aggregation logic | High |
| Aggregation on comp flag | CV_COMP_MD_COMPFL_STATIC_DI, CV_BASE_MD_COMPFL_S4_DI | CV_BASE_MD_COMPFL_S4_DI | Yes | Reference base aggregation View | View | Avoids duplicate aggregation logic | High |
| Multi-join/aggregation | CV_COMP_SKF_BUDGET_STATIC_DI | N/A | N/A | Implement as independent Materialized View/Table | Materialized View / Table | Unique logic, not reusable elsewhere | Medium |
| ETL/snapshot logic | STP_WSS_SRP_ATTRIBUTES_DI | N/A | N/A | Implement as BigQuery Script/Table | Script/Table | Unique procedural logic, not reusable | High |

---

## 8. CONSOLIDATION RECOMMENDATIONS

### Consolidation Group: Base Master Views

**SQLs involved:**  
- CV_BASE_MD_CEPCT_S4_DI
- CV_BASE_MD_COMPFL_S4_DI
- CV_BASE_MD_HRRP_NODE_S4_DI
- CV_BASE_MD_RCALWEEK_S4_DI

**Common logic:**  
- All are simple 1:1 projections from a single source table with an optional filter.

**Unique logic:**  
- Each projects different columns and filters from a different source table.

**What should be consolidated:**  
- None; each should remain as its own reusable View to maximize modularity and maintainability.

**What should remain separate:**  
- All, due to different sources and business meaning.

**Existing object that can be reused:**  
- Each base view.

**New intermediate object required:**  
- None.

**Recommended object type:**  
- View.

**Performance benefit:**  
- Centralizes logic, avoids repeated scans/logic in downstream objects.

**Cost benefit:**  
- Reduces compute by avoiding repeated logic.

**Maintainability benefit:**  
- Easier to update and audit logic.

**Reason:**  
- Each view is semantically and functionally distinct but can be reused as building blocks.

**Confidence:**  
- High.

---

### Consolidation Group: Aggregated Store/CompFlag Views

**SQLs involved:**  
- CV_COMP_MD_SRPACT_STATIC_DI, CV_BASE_MD_SRPACT_S4_DI
- CV_COMP_MD_COMPFL_STATIC_DI, CV_BASE_MD_COMPFL_S4_DI

**Common logic:**  
- Aggregation (SUM, GROUP BY) on the same base table.

**Unique logic:**  
- Minor differences in column selection or downstream usage.

**What should be consolidated:**  
- Aggregation logic can be implemented once as a reusable View.

**What should remain separate:**  
- Downstream objects that require further transformation.

**Existing object that can be reused:**  
- CV_BASE_MD_SRPACT_S4_DI, CV_BASE_MD_COMPFL_S4_DI

**New intermediate object required:**  
- None.

**Recommended object type:**  
- View.

**Performance benefit:**  
- Avoids duplicate aggregation.

**Cost benefit:**  
- Reduces compute.

**Maintainability benefit:**  
- Single point of change.

**Reason:**  
- Logic is identical; only output usage differs.

**Confidence:**  
- High.

---

### Consolidation Group: Final Consolidated Budget Cube

**SQLs involved:**  
- CV_COMP_SKF_BUDGET_STATIC_DI

**Common logic:**  
- Multi-join, aggregation, calculated columns.

**Unique logic:**  
- Complex business rules, parameterization, and snapshot logic.

**What should be consolidated:**  
- All logic required for the final output.

**What should remain separate:**  
- Upstream base and aggregation Views.

**Existing object that can be reused:**  
- All base and intermediate Views.

**New intermediate object required:**  
- Materialized View or Table for performance if needed.

**Recommended object type:**  
- Materialized View or Table.

**Performance benefit:**  
- Avoids repeated heavy computation.

**Cost benefit:**  
- Reduces compute at query time.

**Maintainability benefit:**  
- Centralizes complex logic.

**Reason:**  
- Complexity and downstream usage justify materialization.

**Confidence:**  
- Medium (due to unresolved parameter/external function handling).

---

**If a SQL should not be consolidated, explicitly explain why:**  
- STP_WSS_SRP_ATTRIBUTES_DI should remain independent as it contains procedural ETL/snapshot logic not suitable for consolidation into a View.

---

## 9. INDEPENDENT SQL RECOMMENDATIONS

| SQL | Unique Logic | Reason for Independence | Reusable Portion | Recommended Object Type | Confidence |
|---|---|---|---|---|---|
| STP_WSS_SRP_ATTRIBUTES_DI | Procedural ETL, snapshot, delete/insert, external function | Procedural logic, not suitable for View/Materialized View | Uses base/aggregation Views as sources | BigQuery Script/Table | High |
| CV_COMP_SKF_BUDGET_STATIC_DI | Multi-join, business rules, calculated columns, aggregation, parameterization | Complex, unique business logic, heavy transformation | Uses all base/intermediate Views | Materialized View / Table | Medium |
| CV_BASE_SKF_WEEKLY_BUDGET_S4_DI | Union, aggregation, conditional logic | Unique logic for weekly budget cube | None | View | Medium |

---

## 10. PERFORMANCE AND COST OPTIMIZATION

- **Repeated source scans:**  
  - All base projections and aggregations should be implemented as Views to avoid repeated scans in downstream queries.
- **Repeated joins/aggregations:**  
  - Materialize complex multi-join/aggregation logic (CV_COMP_SKF_BUDGET_STATIC_DI) to avoid repeated computation.
- **Early filtering:**  
  - All filters on MANDT/RCLNT should be applied as early as possible in the base Views.
- **Intermediate result reuse:**  
  - All base and aggregation Views should be referenced by downstream objects, not duplicated.
- **Materialization:**  
  - Use Materialized Views or Tables for snapshot or high-cost queries (e.g., CV_COMP_SKF_BUDGET_STATIC_DI).
- **Storage vs compute trade-offs:**  
  - For snapshot tables populated by ETL (STP_WSS_SRP_ATTRIBUTES_DI), use Physical Tables.

**Expected benefit:**  
- Reduced compute cost, improved query performance, easier maintainability.

**Confidence:**  
- High for base/intermediate Views; Medium for materialized/snapshot layers (requires validation of data volumes and refresh frequency).

---

## 11. DATA FRESHNESS AND REFRESH RECOMMENDATIONS

| SQL / Object | Required Freshness | Recommended Refresh Approach | Reason | Confidence |
|---|---|---|---|---|
| All base Views | Near real-time | On query | Source is transactional, rarely changes | High |
| Aggregation Views | Near real-time | On query | Fast aggregation, low cost | High |
| CV_COMP_SKF_BUDGET_STATIC_DI | Snapshot/Scheduled | Materialized View/Table, scheduled refresh | Heavy aggregation, used in reporting | Medium |
| STP_WSS_SRP_ATTRIBUTES_DI | Snapshot/Scheduled | Scheduled BigQuery Script/Table | ETL populates snapshot tables | Medium |

**If freshness cannot be determined:**  
- Requires validation for actual business requirements on refresh frequency.

---

## 12. FINAL BIGQUERY ARCHITECTURE

### Layer 1 — Existing Source / Reusable Objects
- All base master tables (e.g., SAP_S4.CEPCT, SAP_S4.ZTSRP_COMPFL, SAP_S4.HRRP_NODE, SAP_S4.ZTFIGL_RCALWEEK, AZSRP_DS092_VT_S4, AZSRP_DS031_VT_S4).
- Implemented as BigQuery external tables or native tables.

### Layer 2 — Shared Intermediate Logic
- Base Views:  
  - CV_BASE_MD_CEPCT_S4_DI  
  - CV_BASE_MD_COMPFL_S4_DI  
  - CV_BASE_MD_HRRP_NODE_S4_DI  
  - CV_BASE_MD_RCALWEEK_S4_DI  
  - CV_BASE_MD_SRPACT_S4_DI  
  - CV_BASE_SKF_WEEKLY_BUDGET_S4_DI

### Layer 3 — Consolidated Processing
- Aggregated/Static Views:  
  - CV_COMP_MD_COMPFL_STATIC_DI  
  - CV_COMP_MD_SRPACT_STATIC_DI

### Layer 4 — Independent Processing
- Final consolidated cube:  
  - CV_COMP_SKF_BUDGET_STATIC_DI (Materialized View or Table for reporting)
- ETL/Procedural logic:  
  - STP_WSS_SRP_ATTRIBUTES_DI (BigQuery Script or scheduled job)

### Layer 5 — Reporting / Output
- Final reporting queries or dashboards reference CV_COMP_SKF_BUDGET_STATIC_DI or snapshot tables.

### Layer 6 — Snapshot / Physical Tables
- TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG (populated by STP_WSS_SRP_ATTRIBUTES_DI for snapshot reporting).

### Dependencies

- Base tables → Base Views (projections/filters) → Aggregated/Static Views (SUM, GROUP BY) → Consolidated Cube (multi-join/aggregation) → Reporting.
- ETL/Procedural logic (STP_WSS_SRP_ATTRIBUTES_DI) populates snapshot tables used by static reporting Views.

### Snapshot / Circular Dependencies

- The snapshot process in STP_WSS_SRP_ATTRIBUTES_DI must be preserved.  
- Do **not** convert snapshot tables to direct dependencies—retain ETL population and scheduled refresh.

---

# FINAL DECISION SUMMARY

- **Should all supplied SQLs be consolidated into one query?**  
  No. Only partial consolidation is appropriate; unique business logic and ETL requirements prevent full consolidation.

- **If not, why should they not all be merged?**  
  - Unique business rules, filters, and output requirements.
  - Procedural ETL/snapshot logic cannot be merged with reporting Views.
  - Complexity, maintainability, and performance would suffer.

- **Which SQLs should be consolidated?**  
  - Base projections and aggregations should be implemented as reusable Views.
  - Aggregation logic should be consolidated into single Views where possible.

- **Which SQLs should only be partially consolidated?**  
  - Aggregated Views (e.g., CV_COMP_MD_SRPACT_STATIC_DI, CV_BASE_MD_SRPACT_S4_DI).

- **Which should remain independent?**  
  - STP_WSS_SRP_ATTRIBUTES_DI (ETL/procedural logic)
  - CV_COMP_SKF_BUDGET_STATIC_DI (final reporting cube)
  - CV_BASE_SKF_WEEKLY_BUDGET_S4_DI (unique union/aggregation logic)

- **What logic is duplicated?**  
  - 1:1 projections and aggregation logic on the same base tables.

- **Which SQLs are duplicating that logic?**  
  - CV_COMP_MD_SRPACT_STATIC_DI, CV_BASE_MD_SRPACT_S4_DI (store attributes)
  - CV_COMP_MD_COMPFL_STATIC_DI, CV_BASE_MD_COMPFL_S4_DI (comp flag)

- **Can the duplicated logic actually be reused?**  
  - Yes, by centralizing aggregation logic in reusable Views.

- **What existing objects can already be reused?**  
  - All base master and aggregation Views.

- **What new reusable intermediate objects are required, if any?**  
  - None, provided aggregation logic is implemented once as a View.

- **What object type should be used for each supplied SQL: View, Materialized View, or Physical Table?**  
  - See Object Type Recommendation table above.

- **Why is that object type appropriate?**  
  - Views for simple projections/aggregations (reusable, lightweight).
  - Materialized View/Table for heavy, multi-join, snapshot, or reporting logic.

- **What redundancy can be removed?**  
  - Duplicate aggregation/projection logic by referencing centralized Views.

- **What performance and cost optimizations are possible?**  
  - Early filtering, centralization of logic, materialization of heavy queries, snapshot table usage for reporting.

- **What data freshness considerations apply?**  
  - Views provide near real-time data; materialized/snapshot tables require scheduled refresh.

- **What is the recommended dependency and execution flow?**  
  - Source tables → Base Views → Aggregation Views → Consolidated Cube → Reporting/Snapshot Tables.

- **What architecture maximizes reuse without changing business logic?**  
  - Layered architecture with reusable Views for base/aggregation logic, independent Materialized Views/Tables for reporting/snapshot, and separate ETL logic for snapshot population.

---

**End of Recommendation**

---
