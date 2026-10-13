# BigQuery Recommendations and Consolidation Analysis

---

## 1. EXECUTIVE SUMMARY

**Actual number of SQLs analyzed:** 12  
**All supplied SQL files successfully analyzed:** Yes  
**Should all supplied SQLs be consolidated?** No  
**Major reusable logic identified:**  
- Common projection/filter logic across several dimension views (client filter, direct mapping).
- Shared aggregation logic in multiple CUBE views.
- Repeated joins and source access in composite views.
- Snapshot ETL logic in procedure and static table population.

**Major redundancy identified:**  
- Multiple views and procedures repeatedly filter by client (MANDT/RCLNT) and project columns 1:1.
- Aggregation and group-by logic is repeated across reporting views.
- Repeated joins to hierarchies and reference tables.

**Major consolidation groups:**  
- Composite reporting views (e.g., CV_COMP_FIN_ACTUAL_STATIC) and their upstream dependencies.
- Static dimension views and snapshot ETL procedure logic.

**SQLs that should remain independent:**  
- Dimension views with unique business logic or output requirements.
- Hierarchy views (GL_HEIR/PC_HEIR).
- ETL procedure (STP_WSS_SRP_ATTRIBUTES_DI).

**Existing objects that should be reused:**  
- Dimension tables and Calculation Views mapped 1:1 to BigQuery.
- Intermediate snapshot tables (TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG).

**Major architectural recommendation:**  
- Use Views for simple projections and dimension access.
- Use Materialized Views for repeated intermediate aggregations and composite logic.
- Use Physical Tables for snapshot/ETL results.
- Consolidate composite reporting logic where possible.
- Share intermediate datasets when aggregation or transformation logic is repeated.

**Major View / Materialized View / Physical Table recommendations:**  
- Views for dimension projections.
- Materialized Views for composite/aggregation layers.
- Physical Tables for snapshot/ETL outputs.

**Important dependency patterns:**  
- Composite views depend on multiple upstream dimension and hierarchy views.
- ETL procedure populates snapshot tables consumed by static views.
- Hierarchy views used as join targets in reporting logic.

**Snapshot/circular patterns:**  
- ETL procedure (STP_WSS_SRP_ATTRIBUTES_DI) manages snapshot population, and static views consume those snapshots.

**Key performance and cost opportunities:**  
- Early filtering on client columns.
- Materialization of large/repeated intermediate results.
- Reuse of dimension and hierarchy views.
- Elimination of repeated joins and aggregations.

**Overall recommendation confidence:**  
High for most dimension and aggregation logic; Medium for composite joins and unresolved parameter/function mappings.

---

## 2. INPUT VALIDATION

| Validation Item           | Result |
|--------------------------|--------|
| Lineage provided          | Yes    |
| ZIP provided              | Yes    |
| Actual SQL file count     | 12     |
| SQL files successfully analyzed | 12     |
| Unreadable/invalid files  | None   |
| Successfully analyzed     | Yes    |

**SQL files found:**
- GL_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- PC_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_COMP_MD_COMPFL_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_MD_SRPACT_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_MD_RCALWEEL_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_MD_CEPCT_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_COMP_FIN_ACTUAL_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_FIN_WEEKLY_ACTUAL_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- STP_WSS_SRP_ATTRIBUTES_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_COMP_MD_SRPACT_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_MD_RCALWEEL_S4_DI HANA to BigQuery SQL Conversion Agent.txt

---

## 3. SQL INVENTORY

| SQL File | Main Purpose | Sources | Main Transformations | Output | Upstream Dependencies | Downstream Usage |
|---|---|---|---|---|---|---|
| GL_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI | GL Hierarchy projection | SAP_S4.HRRP_NODE | Filter (MANDT IN 120,200), direct mapping | Hierarchy view | None | Composite reporting views |
| PC_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI | PC Hierarchy projection | SAP_S4.HRRP_NODE | Filter (MANDT IN 120,200), direct mapping | Hierarchy view | None | Composite reporting views |
| CV_COMP_MD_COMPFL_STATIC_DI | Comp Flag static dimension | TBL_WSS_SRP_COMPFLAG | Direct mapping | Static comp flag dimension | STP_WSS_SRP_ATTRIBUTES_DI | Composite reporting views |
| CV_BASE_MD_SRPACT_S4_DI | Store attribute dimension | SAP_S4.ZTSRP_ATTR_ACT | Filter (MANDT IN 120,200), aggregation (SUM) | Store attribute aggregation | None | ETL procedure, reporting views |
| CV_BASE_MD_RCALWEEL_S4_DI | Retail calendar dimension | SAP_S4.ZTFIGL_RCALWEEK | Filter (RCLNT IN 120,200), direct mapping | Calendar dimension | None | Composite reporting views |
| CV_BASE_MD_CEPCT_S4_DI | Profit center text dimension | SAP_S4.CEPCT | Filter (MANDT IN 120,200), direct mapping | Profit center text | None | Composite reporting views |
| CV_BASE_MD_COMPFL_S4_DI | Comp flag base dimension | TBL_WSS_SRP_COMPFLAG | Direct mapping | Comp flag dimension | STP_WSS_SRP_ATTRIBUTES_DI | ETL procedure, reporting views |
| CV_COMP_FIN_ACTUAL_STATIC_DI | Composite reporting view | Multiple Calculation Views | Joins, projections, calculated columns, aggregations | Composite reporting | Multiple dimension and hierarchy views | Reporting/output layer |
| CV_BASE_FIN_WEEKLY_ACTUAL_S4_DI | Weekly actuals aggregation | AZSRP_DS072_VT_S4 | Filter (MANDT IN 110,200), aggregation (SUM) | Weekly actuals | None | Composite reporting views |
| STP_WSS_SRP_ATTRIBUTES_DI | ETL snapshot procedure | Calculation Views, tables | Delete, insert, snapshot timestamp, session user | Snapshot tables | CV_BASE_MD_SRPACT_S4_DI, CV_BASE_MD_COMPFL_S4_DI | Static dimension views |
| CV_COMP_MD_SRPACT_STATIC_DI | Store attribute static dimension | TBL_WSS_SRP_ATTR_ACT | Direct mapping, aggregation (SUM) | Static store attribute | STP_WSS_SRP_ATTRIBUTES_DI | Composite reporting views |
| CV_BASE_MD_RCALWEEL_S4_DI | Retail calendar dimension | SAP_S4.ZTFIGL_RCALWEEK | Filter (RCLNT IN 120,200), direct mapping | Calendar dimension | None | Composite reporting views |

---

## 4. OBJECT TYPE RECOMMENDATION

| SQL File | Recommended Object | Data Freshness | Reuse Level | Rationale | Confidence |
|---|---|---|---|---|---|
| GL_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI | View | Near-real-time | High | Simple projection/filter; reusable hierarchy | High |
| PC_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI | View | Near-real-time | High | Simple projection/filter; reusable hierarchy | High |
| CV_COMP_MD_COMPFL_STATIC_DI | View | Snapshot | Medium | Static dimension; consumes snapshot table | High |
| CV_BASE_MD_SRPACT_S4_DI | Materialized View | Scheduled refresh | Medium | Aggregation; used in ETL and reporting | Medium |
| CV_BASE_MD_RCALWEEL_S4_DI | View | Near-real-time | Medium | Simple projection/filter; calendar reference | High |
| CV_BASE_MD_CEPCT_S4_DI | View | Near-real-time | Medium | Simple projection/filter; profit center text | Medium |
| CV_BASE_MD_COMPFL_S4_DI | View | Near-real-time | Medium | Simple projection/filter; comp flag reference | High |
| CV_COMP_FIN_ACTUAL_STATIC_DI | Materialized View | Scheduled refresh | High | Composite reporting; repeated joins/aggregations | Medium |
| CV_BASE_FIN_WEEKLY_ACTUAL_S4_DI | Materialized View | Scheduled refresh | Medium | Aggregation; reused in composite views | High |
| STP_WSS_SRP_ATTRIBUTES_DI | Physical Table | Snapshot | Medium | ETL logic; manages snapshot tables | Medium |
| CV_COMP_MD_SRPACT_STATIC_DI | View | Snapshot | Medium | Static dimension; consumes snapshot table | High |
| CV_BASE_MD_RCALWEEL_S4_DI | View | Near-real-time | Medium | Simple projection/filter; calendar reference | High |

---

## 5. COMMON LOGIC ANALYSIS

| Common Logic | SQLs Using It | Actual Similarity | Business Logic Match | Existing Object | Reusable? | Reuse Potential | Confidence |
|---|---|---|---|---|---|---|---|
| Client filter (MANDT/RCLNT IN 120,200) | GL_HEIR, PC_HEIR, CV_BASE_MD_SRPACT_S4, CV_BASE_MD_RCALWEEL_S4, CV_BASE_MD_CEPCT_S4 | Identical filter logic | Yes | Dimension Views | Yes | High | High |
| Simple projection of source table | GL_HEIR, PC_HEIR, CV_BASE_MD_CEPCT_S4, CV_BASE_MD_RCALWEEL_S4 | Identical mapping | Yes | Dimension Views | Yes | High | High |
| Aggregation/group-by logic | CV_BASE_MD_SRPACT_S4, CV_BASE_FIN_WEEKLY_ACTUAL_S4, CV_COMP_FIN_ACTUAL_STATIC, CV_COMP_MD_SRPACT_STATIC | SUM/group-by aggregation | Yes | Materialized Views | Yes | High | Medium |
| ETL snapshot population | STP_WSS_SRP_ATTRIBUTES_DI, CV_COMP_MD_COMPFL_STATIC_DI, CV_COMP_MD_SRPACT_STATIC_DI | Snapshot table population | Yes | Physical Tables | Yes | Medium | Medium |

---

## 6. REDUNDANCY ANALYSIS

| Redundant Logic | SQLs Affected | What Is Repeated | Potential Reduction | Recommended Action | Confidence |
|---|---|---|---|---|---|
| Client filter (MANDT/RCLNT) | Multiple dimension views | Same filter applied in each view | Centralize filter in reusable view | Use reusable filtered views | High |
| Simple projection | Multiple dimension views | Direct mapping of all columns | Centralize projection logic | Use reusable views | High |
| Aggregation/group-by | Multiple reporting views | SUM/group-by on similar columns | Materialize intermediate result | Create/reuse Materialized View | Medium |
| Joins to hierarchies | Composite reporting views | Repeated joins to hierarchy views | Materialize joined result | Create/reuse Materialized View | Medium |

---

## 7. REUSE RECOMMENDATIONS

| Common Logic | SQLs Using It | Existing Object | Existing Object Reusable? | Recommendation | Recommended Object Type | Rationale | Confidence |
|---|---|---|---|---|---|---|---|
| Client filter/projection | GL_HEIR, PC_HEIR, CV_BASE_MD_CEPCT_S4, CV_BASE_MD_RCALWEEL_S4 | Dimension Views | Yes | Reuse dimension views | View | Centralizes filter/projection | High |
| Aggregation/group-by | CV_BASE_MD_SRPACT_S4, CV_BASE_FIN_WEEKLY_ACTUAL_S4, CV_COMP_FIN_ACTUAL_STATIC, CV_COMP_MD_SRPACT_STATIC | Materialized Views | Yes | Materialize intermediate aggregation | Materialized View | Reduces repeated aggregation | Medium |
| ETL snapshot population | STP_WSS_SRP_ATTRIBUTES_DI, CV_COMP_MD_COMPFL_STATIC_DI, CV_COMP_MD_SRPACT_STATIC_DI | Physical Tables | Yes | Reuse snapshot tables | Physical Table | Preserves snapshot logic | Medium |

---

## 8. CONSOLIDATION RECOMMENDATIONS

### Consolidation Group: Composite Reporting Views

**SQLs involved:**  
- CV_COMP_FIN_ACTUAL_STATIC_DI  
- CV_BASE_FIN_WEEKLY_ACTUAL_S4_DI  
- CV_COMP_MD_COMPFL_STATIC_DI  
- CV_COMP_MD_SRPACT_STATIC_DI  
- CV_BASE_MD_SRPACT_S4_DI  
- CV_BASE_MD_RCALWEEL_S4_DI  
- CV_BASE_MD_CEPCT_S4_DI  
- GL_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI  
- PC_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI

**Common logic:**  
- Joins to dimension/hierarchy views.
- Aggregation/group-by logic.
- Client filtering.

**Unique logic:**  
- Calculated columns in composite reporting view.
- Snapshot-specific logic in static dimension views.

**What should be consolidated:**  
- Shared aggregation and join logic.
- Materialization of intermediate aggregation results.

**What should remain separate:**  
- Unique calculated columns.
- Snapshot ETL logic.

**Existing object that can be reused:**  
- Materialized Views for aggregation.
- Dimension Views for projections.

**New intermediate object required:**  
- Materialized View for composite aggregation and join results.

**Recommended object type:**  
- Materialized View.

**Performance benefit:**  
- Reduces repeated aggregation and join processing.

**Cost benefit:**  
- Avoids repeated scans and joins.

**Maintainability benefit:**  
- Centralizes complex reporting logic.

**Reason:**  
- Composite reporting logic is complex and heavily dependent on upstream dimension views; materialization improves performance and maintainability.

**Confidence:**  
Medium (due to unresolved parameter mapping and external function definitions).

---

## 9. INDEPENDENT SQL RECOMMENDATIONS

| SQL | Unique Logic | Reason for Independence | Reusable Portion | Recommended Object Type | Confidence |
|---|---|---|---|---|---|
| GL_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI | GL hierarchy projection | Unique hierarchy logic | Client filter/projection | View | High |
| PC_HEIR.CV_BASE_MD_HRRP_NODE_S4_DI | PC hierarchy projection | Unique hierarchy logic | Client filter/projection | View | High |
| CV_BASE_MD_CEPCT_S4_DI | Profit center text | Unique dimension output | Client filter/projection | View | Medium |
| CV_BASE_MD_RCALWEEL_S4_DI | Calendar dimension | Unique calendar output | Client filter/projection | View | High |
| STP_WSS_SRP_ATTRIBUTES_DI | ETL snapshot procedure | ETL/snapshot logic | Table population | Physical Table | Medium |

---

## 10. PERFORMANCE AND COST OPTIMIZATION

| SQLs affected | Current issue | Recommended approach | Expected benefit | Confidence |
|---|---|---|---|---|
| Composite reporting views | Repeated joins/aggregations | Materialize intermediate aggregation | Reduced compute, improved performance | Medium |
| Dimension views | Repeated client filtering | Centralize filter in reusable views | Reduced scan cost, maintainability | High |
| ETL snapshot logic | Repeated table population | Materialize snapshot tables | Reduced data movement, preserves snapshot | Medium |
| All aggregation views | Repeated SUM/group-by | Materialize aggregation | Reduced compute | Medium |

---

## 11. DATA FRESHNESS AND REFRESH RECOMMENDATIONS

| SQL / Object | Required Freshness | Recommended Refresh Approach | Reason | Confidence |
|---|---|---|---|---|
| Dimension Views | Near-real-time | On-demand or scheduled | Simple projection; minimal transformation | High |
| Materialized Views | Scheduled refresh | Daily or batch | Aggregation, composite logic | Medium |
| Physical Tables (Snapshots) | Snapshot | ETL-driven, batch | ETL procedure manages snapshot | Medium |
| Composite Reporting Views | Scheduled refresh | Batch/materialized | Heavy joins/aggregation | Medium |

---

## 12. FINAL BIGQUERY ARCHITECTURE

### Layer 1 — Existing Source / Reusable Objects
- Dimension Views: GL_HEIR, PC_HEIR, CV_BASE_MD_CEPCT_S4, CV_BASE_MD_RCALWEEL_S4
- Hierarchy Views: GL_HEIR, PC_HEIR

### Layer 2 — Shared Intermediate Logic
- Materialized Views for aggregation: CV_BASE_MD_SRPACT_S4, CV_BASE_FIN_WEEKLY_ACTUAL_S4

### Layer 3 — Consolidated Processing
- Composite Reporting View: CV_COMP_FIN_ACTUAL_STATIC_DI (materialized, joins/intermediate logic)

### Layer 4 — Independent Processing
- Static dimension views: CV_COMP_MD_COMPFL_STATIC_DI, CV_COMP_MD_SRPACT_STATIC_DI
- ETL Procedure: STP_WSS_SRP_ATTRIBUTES_DI

### Layer 5 — Reporting / Output
- Final reporting layer: CV_COMP_FIN_ACTUAL_STATIC_DI (materialized)

### Layer 6 — Snapshot / Physical Tables
- Snapshot tables: TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG (populated by ETL procedure, consumed by static dimension views)

### Dependencies
- Composite reporting views depend on materialized aggregation and dimension views.
- Static dimension views depend on snapshot tables populated by ETL procedure.
- ETL procedure depends on upstream Calculation Views for snapshot population.

### Snapshot / Circular Dependencies
- ETL procedure manages snapshot population, which is consumed by static dimension views for reporting.
- Composite reporting views depend on both real-time and snapshot data.

---

# FINAL DECISION SUMMARY

- **Should all supplied SQLs be consolidated into one query?**  
  No. Composite reporting logic should be consolidated, but dimension, hierarchy, and ETL logic should remain independent.

- **If not, why should they not all be merged?**  
  Merging all would increase complexity, reduce maintainability, and risk snapshot logic integrity.

- **Which SQLs should be consolidated?**  
  Composite reporting views and their aggregation/join logic.

- **Which SQLs should only be partially consolidated?**  
  Materialized aggregation logic shared across reporting views.

- **Which SQLs should remain independent?**  
  Dimension views, hierarchy views, ETL procedure.

- **What logic is duplicated?**  
  Client filtering, projection, aggregation/group-by, joins to hierarchies.

- **Which SQLs are duplicating that logic?**  
  GL_HEIR, PC_HEIR, CV_BASE_MD_CEPCT_S4, CV_BASE_MD_RCALWEEL_S4, CV_BASE_MD_SRPACT_S4, CV_BASE_FIN_WEEKLY_ACTUAL_S4, CV_COMP_FIN_ACTUAL_STATIC_DI.

- **Can the duplicated logic actually be reused?**  
  Yes, via reusable Views and Materialized Views.

- **What existing objects can already be reused?**  
  Dimension Views, Materialized aggregation Views, snapshot tables.

- **What new reusable intermediate objects are required, if any?**  
  Materialized Views for composite aggregation/join results.

- **What object type should be used for each supplied SQL: View, Materialized View, or Physical Table?**  
  See section 4 above.

- **Why is that object type appropriate?**  
  Views for simple projections; Materialized Views for repeated aggregation/join logic; Physical Tables for snapshot ETL results.

- **What redundancy can be removed?**  
  Repeated filtering, projection, aggregation, and joins.

- **What performance and cost optimizations are possible?**  
  Materialization, early filtering, reuse of intermediate datasets.

- **What data freshness considerations apply?**  
  Dimension views can be near-real-time; materialized/composite views require scheduled refresh; snapshot tables depend on ETL schedule.

- **What is the recommended dependency and execution flow?**  
  ETL populates snapshot tables → static dimension views consume snapshots → composite reporting views join to dimension/materialized views → reporting/output layer.

- **What architecture maximizes reuse without changing business logic?**  
  Layered approach: reusable dimension views, materialized aggregation, composite reporting, snapshot/ETL logic preserved.

---

## GITHUB OUTPUT

Now writing the above complete recommendation output to GitHub...
