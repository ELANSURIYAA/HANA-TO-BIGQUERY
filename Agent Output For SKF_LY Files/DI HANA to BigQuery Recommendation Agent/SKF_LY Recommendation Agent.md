# SKF_LY Recommendation Agent — BigQuery Recommendations and Consolidation Analysis

---

## 1. EXECUTIVE SUMMARY

- **Actual number of SQLs analyzed:** 10
- **All supplied SQL files successfully analyzed:** Yes
- **Should all supplied SQLs be consolidated:** No; consolidation is recommended only for specific groups with shared logic
- **Major reusable logic identified:** 
  - Direct projections from source tables (dimension views)
  - Aggregation logic for CUBE views
  - Store attribute and comp flag logic reused in both static and snapshot tables
  - Shared calculation and lookup logic in composite actuals
- **Major redundancy identified:** 
  - Multiple projections of store attribute and comp flag tables (can be reused)
  - Repeated aggregation logic across similar CUBE views
- **Major consolidation groups:** 
  - Composite actuals and static actuals leveraging underlying base and static views
  - Store attribute and comp flag static views
- **SQLs that should remain independent:** 
  - Dimension projections with unique filters or direct mappings
  - Calculation views with unique aggregation/grouping logic
- **Existing objects that should be reused:** 
  - Base static attribute and comp flag tables
  - Base weekly actuals and cube aggregation logic
- **Major architectural recommendation:** 
  - Use Views for simple projections and CUBE aggregations with low reuse
  - Use Materialized Views for highly reused, costly aggregations and intermediate results
  - Use Physical Tables for snapshot/persisted outputs (audit, reporting, procedure-driven loads)
- **Major View / Materialized View / Physical Table recommendations:** 
  - Views for dimension and simple cube projections
  - Materialized Views for composite actuals and static aggregations
  - Physical Tables for snapshot tables loaded by procedures
- **Important dependency patterns:** 
  - Strong lineage from base views to static and composite actuals
  - Store attribute and comp flag logic flows from base to static to composite
- **Snapshot/circular patterns:** 
  - Controlled snapshot tables loaded by procedure, with audit columns and weekly logic
- **Key performance and cost opportunities:** 
  - Reuse intermediate projections and aggregations
  - Materialize costly aggregations
  - Early filtering on client (MANDT) and week columns
- **Overall recommendation confidence:** High (all logic explicitly defined, only mapping and datatype validation required)

---

## 2. INPUT VALIDATION

| Validation Item                | Result |
|--------------------------------|--------|
| Lineage provided               | Yes    |
| ZIP provided                   | Yes    |
| Actual SQL file count          | 10     |
| SQL files successfully analyzed| 10     |
| Unreadable/invalid files       | None   |
| Successfully analyzed          | Yes    |

**SQL files found:**
- CV_COMP_MD_COMPFL_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_MD_SRPACT_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_SKF_WEEKLY_ACTUAL_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_MD_CEPCT_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_COMP_SKF_ACTUAL_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_MD_RCALWEEK_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- STP_WSS_SRP_ATTRIBUTES_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_COMP_MD_SRPACT_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt

---

## 3. SQL INVENTORY

| SQL File                                              | Main Purpose                          | Sources                                   | Main Transformations                | Output                                  | Upstream Dependencies                               | Downstream Usage                                |
|------------------------------------------------------|---------------------------------------|-------------------------------------------|-------------------------------------|------------------------------------------|-----------------------------------------------------|------------------------------------------------|
| CV_COMP_MD_COMPFL_STATIC_DI HANA to BigQuery SQL      | Static Comp Flag projection           | TBL_WSS_SRP_COMPFLAG                      | Direct projection                   | Comp flag static table                  | STP_WSS_SRP_ATTRIBUTES, CV_BASE_MD_COMPFL_S4         | CV_COMP_SKF_ACTUAL_STATIC                      |
| CV_BASE_MD_SRPACT_S4_DI HANA to BigQuery SQL         | Store Attribute Aggregation           | ZTSRP_ATTR_ACT                            | Aggregation (SUM), filter           | Store attribute cube                    | None                                                | STP_WSS_SRP_ATTRIBUTES, CV_COMP_MD_SRPACT_STATIC   |
| CV_BASE_SKF_WEEKLY_ACTUAL_S4_DI HANA to BigQuery SQL | Weekly Actuals Aggregation            | AZSRP_DS112_VT_S4                         | Aggregation (SUM), filter           | Weekly actuals cube                     | None                                                | CV_COMP_SKF_ACTUAL_STATIC                        |
| CV_BASE_MD_CEPCT_S4_DI HANA to BigQuery SQL          | Profit Center Text projection         | CEPCT                                     | Direct projection, filter           | Profit center text                      | None                                                | CV_COMP_SKF_ACTUAL_STATIC                        |
| CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL         | Comp Flag projection                  | ZTSRP_COMPFL                              | Direct projection, filter           | Comp flag dimension                     | None                                                | STP_WSS_SRP_ATTRIBUTES                           |
| CV_COMP_SKF_ACTUAL_STATIC_DI HANA to BigQuery SQL    | Composite Actuals Aggregation         | Multiple base/static views                | Joins, filters, aggregations, CTEs  | Composite actuals static cube           | CV_BASE_SKF_WEEKLY_ACTUAL_S4, CV_COMP_MD_SRPACT_STATIC, CV_BASE_MD_HRRP_NODE_S4, CV_COMP_MD_COMPFL_STATIC, CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_CEPCT_S4 | Final reporting/output layer                     |
| CV_BASE_MD_RCALWEEK_S4_DI HANA to BigQuery SQL       | Retail Calendar Week projection       | ZTFIGL_RCALWEEK                           | Direct projection, filter           | Retail calendar week                    | None                                                | CV_COMP_SKF_ACTUAL_STATIC                        |
| CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL      | Hierarchy Node projection             | HRRP_NODE                                 | Direct projection, filter           | Hierarchy node                          | None                                                | CV_COMP_SKF_ACTUAL_STATIC                        |
| STP_WSS_SRP_ATTRIBUTES_DI HANA to BigQuery SQL       | Procedure-driven snapshot load        | CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4| Delete, insert, audit columns        | Snapshot tables (attr, compflag)        | CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4           | CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC |
| CV_COMP_MD_SRPACT_STATIC_DI HANA to BigQuery SQL     | Static Store Attribute Aggregation    | TBL_WSS_SRP_ATTR_ACT                      | Aggregation (SUM)                   | Store attribute static cube             | STP_WSS_SRP_ATTRIBUTES, CV_BASE_MD_SRPACT_S4         | CV_COMP_SKF_ACTUAL_STATIC                        |

---

## 4. OBJECT TYPE RECOMMENDATION

| SQL File                                              | Recommended Object      | Data Freshness          | Reuse Level         | Rationale                                                                                          | Confidence |
|------------------------------------------------------|------------------------|------------------------|---------------------|-----------------------------------------------------------------------------------------------------|------------|
| CV_COMP_MD_COMPFL_STATIC_DI HANA to BigQuery SQL      | Materialized View      | Scheduled/snapshot     | High                | Used in composite actuals, procedure-driven, intermediate result, costly to recompute               | High       |
| CV_BASE_MD_SRPACT_S4_DI HANA to BigQuery SQL         | View                   | Near-real-time         | Moderate            | Base aggregation, used for snapshot and static, low transformation complexity                        | High       |
| CV_BASE_SKF_WEEKLY_ACTUAL_S4_DI HANA to BigQuery SQL | View                   | Near-real-time         | Moderate            | Base weekly actuals aggregation, used in composite actuals                                           | High       |
| CV_BASE_MD_CEPCT_S4_DI HANA to BigQuery SQL          | View                   | Near-real-time         | Moderate            | Simple projection, used for profit center text lookup                                                | High       |
| CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL         | View                   | Near-real-time         | Moderate            | Base comp flag projection, used for snapshot and static                                              | High       |
| CV_COMP_SKF_ACTUAL_STATIC_DI HANA to BigQuery SQL    | Materialized View      | Scheduled/refresh      | High                | Composite actuals, costly joins/aggregations, central reporting/output, high downstream usage        | High       |
| CV_BASE_MD_RCALWEEK_S4_DI HANA to BigQuery SQL       | View                   | Near-real-time         | Moderate            | Simple calendar projection, used for retail calendar lookup                                          | High       |
| CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL      | View                   | Near-real-time         | Moderate            | Hierarchy node projection, used for lookup in composite actuals                                      | High       |
| STP_WSS_SRP_ATTRIBUTES_DI HANA to BigQuery SQL       | Physical Table         | Snapshot               | High                | Procedure-driven snapshot load, audit columns, persisted storage required                            | High       |
| CV_COMP_MD_SRPACT_STATIC_DI HANA to BigQuery SQL     | Materialized View      | Scheduled/snapshot     | High                | Used in composite actuals, procedure-driven, intermediate result, costly to recompute               | High       |

---

## 5. COMMON LOGIC ANALYSIS

| Common Logic                                | SQLs Using It                                                | Actual Similarity                  | Business Logic Match | Existing Object           | Reusable? | Reuse Potential      | Confidence |
|----------------------------------------------|--------------------------------------------------------------|-------------------------------------|----------------------|---------------------------|-----------|----------------------|------------|
| Store attribute aggregation/projection       | CV_BASE_MD_SRPACT_S4, CV_COMP_MD_SRPACT_STATIC, STP_WSS_SRP_ATTRIBUTES | Direct 1:1 mapping, aggregation     | Yes                  | TBL_WSS_SRP_ATTR_ACT      | Yes       | High                 | High       |
| Comp flag projection                        | CV_BASE_MD_COMPFL_S4, CV_COMP_MD_COMPFL_STATIC, STP_WSS_SRP_ATTRIBUTES | Direct 1:1 mapping, aggregation     | Yes                  | TBL_WSS_SRP_COMPFLAG      | Yes       | High                 | High       |
| Weekly actuals aggregation                  | CV_BASE_SKF_WEEKLY_ACTUAL_S4, CV_COMP_SKF_ACTUAL_STATIC      | Aggregation/grouping logic          | Yes                  | CV_BASE_SKF_WEEKLY_ACTUAL_S4 | Yes       | High                 | High       |
| Calendar week projection                    | CV_BASE_MD_RCALWEEK_S4, CV_COMP_SKF_ACTUAL_STATIC            | Direct projection                   | Yes                  | CV_BASE_MD_RCALWEEK_S4    | Yes       | Moderate             | High       |
| Profit center text projection               | CV_BASE_MD_CEPCT_S4, CV_COMP_SKF_ACTUAL_STATIC               | Direct projection                   | Yes                  | CV_BASE_MD_CEPCT_S4       | Yes       | Moderate             | High       |
| Hierarchy node projection                   | CV_BASE_MD_HRRP_NODE_S4, CV_COMP_SKF_ACTUAL_STATIC           | Direct projection                   | Yes                  | CV_BASE_MD_HRRP_NODE_S4   | Yes       | Moderate             | High       |
| Audit/snapshot logic                        | STP_WSS_SRP_ATTRIBUTES, CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC | Procedure-driven snapshot           | Yes                  | TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG | Yes | High | High       |

---

## 6. REDUNDANCY ANALYSIS

| Redundant Logic                | SQLs Affected                             | What Is Repeated                    | Potential Reduction                 | Recommended Action                          | Confidence |
|-------------------------------|-------------------------------------------|-------------------------------------|-------------------------------------|----------------------------------------------|------------|
| Store attribute projection     | CV_BASE_MD_SRPACT_S4, CV_COMP_MD_SRPACT_STATIC, STP_WSS_SRP_ATTRIBUTES | 1:1 projection/aggregation          | Reuse intermediate result           | Materialize static view, reuse in composite | High       |
| Comp flag projection           | CV_BASE_MD_COMPFL_S4, CV_COMP_MD_COMPFL_STATIC, STP_WSS_SRP_ATTRIBUTES | 1:1 projection/aggregation          | Reuse intermediate result           | Materialize static view, reuse in composite | High       |
| Aggregation logic for actuals  | CV_BASE_SKF_WEEKLY_ACTUAL_S4, CV_COMP_SKF_ACTUAL_STATIC                | Aggregation/grouping                | Reuse weekly actuals base view      | Use base view as reusable layer             | High       |
| Calendar/profit center lookup  | CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_CEPCT_S4, CV_COMP_SKF_ACTUAL_STATIC | Direct projection                   | Reuse lookup views                  | Use lookup views as reusable layer          | High       |

---

## 7. REUSE RECOMMENDATIONS

| Common Logic                  | SQLs Using It                                                | Existing Object           | Existing Object Reusable? | Recommendation           | Recommended Object Type | Rationale                                       | Confidence |
|-------------------------------|--------------------------------------------------------------|---------------------------|---------------------------|--------------------------|------------------------|--------------------------------------------------|------------|
| Store attribute aggregation   | CV_BASE_MD_SRPACT_S4, CV_COMP_MD_SRPACT_STATIC, STP_WSS_SRP_ATTRIBUTES | TBL_WSS_SRP_ATTR_ACT      | Yes                       | Materialize static view  | Materialized View      | High downstream usage, costly aggregation         | High       |
| Comp flag projection          | CV_BASE_MD_COMPFL_S4, CV_COMP_MD_COMPFL_STATIC, STP_WSS_SRP_ATTRIBUTES | TBL_WSS_SRP_COMPFLAG      | Yes                       | Materialize static view  | Materialized View      | High downstream usage, costly aggregation         | High       |
| Weekly actuals aggregation    | CV_BASE_SKF_WEEKLY_ACTUAL_S4, CV_COMP_SKF_ACTUAL_STATIC      | CV_BASE_SKF_WEEKLY_ACTUAL_S4 | Yes                  | Reuse base view          | View                   | Central aggregation logic, multiple consumers     | High       |
| Calendar/profit center lookup | CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_CEPCT_S4, CV_COMP_SKF_ACTUAL_STATIC | CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_CEPCT_S4 | Yes | Reuse lookup views        | View                   | Simple projection, low cost, multiple consumers   | High       |
| Audit/snapshot logic          | STP_WSS_SRP_ATTRIBUTES, CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC | TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG | Yes | Reuse snapshot tables     | Physical Table         | Procedure-driven, audit required                  | High       |

---

## 8. CONSOLIDATION RECOMMENDATIONS

### Consolidation Group: Store Attribute & Comp Flag Static

**SQLs involved:**
- CV_COMP_MD_SRPACT_STATIC_DI HANA to BigQuery SQL
- CV_COMP_MD_COMPFL_STATIC_DI HANA to BigQuery SQL
- STP_WSS_SRP_ATTRIBUTES_DI HANA to BigQuery SQL

**Common logic:**
- Both static views aggregate/project from snapshot tables loaded by the procedure.
- Both are used as intermediate layers in composite actuals.

**Unique logic:**
- Store attribute and comp flag have distinct column sets and business rules (week filtering, audit columns).

**What should be consolidated:**
- Materialize both static views for reuse in composite actuals and reporting.

**What should remain separate:**
- Distinct aggregation logic and column sets.

**Existing object that can be reused:**
- TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG

**New intermediate object required:**
- Materialized static views

**Recommended object type:**
- Materialized View

**Performance benefit:**
- Eliminates repeated aggregation, speeds up composite actuals

**Cost benefit:**
- Reduces compute cost for repeated queries

**Maintainability benefit:**
- Centralizes static logic, easier audit/tracing

**Reason:**
- High downstream usage, snapshot-driven, costly aggregation

**Confidence:**
- High

---

### Consolidation Group: Composite Actuals

**SQLs involved:**
- CV_COMP_SKF_ACTUAL_STATIC_DI HANA to BigQuery SQL
- CV_BASE_SKF_WEEKLY_ACTUAL_S4_DI HANA to BigQuery SQL
- CV_COMP_MD_SRPACT_STATIC_DI HANA to BigQuery SQL
- CV_COMP_MD_COMPFL_STATIC_DI HANA to BigQuery SQL

**Common logic:**
- Composite actuals aggregate and join multiple static and base views, with common filters and CTEs.

**Unique logic:**
- Composite actuals have additional calculated columns, join logic, parameter-driven filtering.

**What should be consolidated:**
- Use materialized views for composite actuals, reusing static and base views.

**What should remain separate:**
- Unique business logic, calculated columns, parameter handling.

**Existing object that can be reused:**
- All referenced static and base views

**New intermediate object required:**
- Materialized composite actuals

**Recommended object type:**
- Materialized View

**Performance benefit:**
- Eliminates repeated joins/aggregations

**Cost benefit:**
- Reduces compute cost for reporting

**Maintainability benefit:**
- Centralizes composite logic, easier audit/tracing

**Reason:**
- High downstream usage, costly joins/aggregations

**Confidence:**
- High

---

**If a SQL should not be consolidated, explicitly explain why:**
- Dimension projections (calendar, profit center, hierarchy node) should remain independent due to unique filters, simple logic, and low transformation complexity.

---

## 9. INDEPENDENT SQL RECOMMENDATIONS

| SQL | Unique Logic | Reason for Independence | Reusable Portion | Recommended Object Type | Confidence |
|-----|-------------|------------------------|------------------|------------------------|------------|
| CV_BASE_MD_CEPCT_S4_DI HANA to BigQuery SQL | Profit center text projection, filter | Unique lookup logic, low transformation, used for lookup only | Yes (projection) | View | High |
| CV_BASE_MD_RCALWEEK_S4_DI HANA to BigQuery SQL | Retail calendar week projection, filter | Unique calendar logic, used for lookup only | Yes (projection) | View | High |
| CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL | Hierarchy node projection, filter | Unique hierarchy logic, used for lookup only | Yes (projection) | View | High |
| CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL | Comp flag projection, filter | Unique comp flag logic, used for snapshot/static only | Yes (projection) | View | High |
| CV_BASE_MD_SRPACT_S4_DI HANA to BigQuery SQL | Store attribute aggregation, filter | Unique aggregation, used for snapshot/static only | Yes (aggregation) | View | High |
| CV_BASE_SKF_WEEKLY_ACTUAL_S4_DI HANA to BigQuery SQL | Weekly actuals aggregation, filter | Unique aggregation, used for composite only | Yes (aggregation) | View | High |

---

## 10. PERFORMANCE AND COST OPTIMIZATION

| SQLs affected                      | Current issue                           | Recommended approach                  | Expected benefit                      | Confidence |
|-------------------------------------|-----------------------------------------|---------------------------------------|---------------------------------------|------------|
| CV_COMP_SKF_ACTUAL_STATIC, CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC | Repeated costly joins/aggregations     | Materialize static and composite views| Reduce compute cost, speed up queries | High       |
| CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4, CV_BASE_SKF_WEEKLY_ACTUAL_S4      | Repeated aggregation                   | Use base views as reusable layers     | Reduce repeated aggregation           | High       |
| All views with client/week filters  | Late filtering                          | Early filtering on client/week columns| Reduce scanned data volume            | High       |
| CV_BASE_MD_CEPCT_S4, CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_HRRP_NODE_S4          | Repeated lookup joins                  | Use lookup views as reusable layers   | Reduce repeated joins                 | High       |

---

## 11. DATA FRESHNESS AND REFRESH RECOMMENDATIONS

| SQL / Object                                 | Required Freshness         | Recommended Refresh Approach | Reason                                 | Confidence |
|-----------------------------------------------|---------------------------|------------------------------|----------------------------------------|------------|
| CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC | Scheduled/snapshot         | On procedure completion      | Snapshot tables loaded weekly          | High       |
| CV_COMP_SKF_ACTUAL_STATIC                    | Scheduled/refresh          | Scheduled/materialized view  | Central reporting, periodic refresh    | High       |
| CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4, CV_BASE_SKF_WEEKLY_ACTUAL_S4 | Near-real-time               | On demand/view                   | Used for intermediate aggregation      | High       |
| CV_BASE_MD_CEPCT_S4, CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_HRRP_NODE_S4 | Near-real-time               | On demand/view                   | Used for lookup only                   | High       |
| STP_WSS_SRP_ATTRIBUTES                       | Snapshot                   | Procedure-driven load         | Audit/snapshot, loaded weekly          | High       |

---

## 12. FINAL BIGQUERY ARCHITECTURE

### Layer 1 — Existing Source / Reusable Objects
- TBL_WSS_SRP_ATTR_ACT (store attribute snapshot table)
- TBL_WSS_SRP_COMPFLAG (comp flag snapshot table)
- AZSRP_DS112_VT_S4 (weekly actuals source)
- ZTSRP_ATTR_ACT (store attribute source)
- ZTSRP_COMPFL (comp flag source)
- CEPCT (profit center text source)
- ZTFIGL_RCALWEEK (retail calendar week source)
- HRRP_NODE (hierarchy node source)

### Layer 2 — Shared Intermediate Logic
- CV_COMP_MD_SRPACT_STATIC (materialized view, store attribute static aggregation)
- CV_COMP_MD_COMPFL_STATIC (materialized view, comp flag static aggregation)
- CV_BASE_SKF_WEEKLY_ACTUAL_S4 (view, weekly actuals aggregation)

### Layer 3 — Consolidated Processing
- CV_COMP_SKF_ACTUAL_STATIC (materialized view, composite actuals aggregation and joins)

### Layer 4 — Independent Processing
- CV_BASE_MD_SRPACT_S4 (view, store attribute aggregation)
- CV_BASE_MD_COMPFL_S4 (view, comp flag projection)
- CV_BASE_MD_CEPCT_S4 (view, profit center text projection)
- CV_BASE_MD_RCALWEEK_S4 (view, retail calendar week projection)
- CV_BASE_MD_HRRP_NODE_S4 (view, hierarchy node projection)

### Layer 5 — Reporting / Output
- CV_COMP_SKF_ACTUAL_STATIC (materialized view, central reporting/output)

### Layer 6 — Snapshot / Physical Tables
- STP_WSS_SRP_ATTRIBUTES (procedure-driven snapshot load, physical tables for audit)

### Dependencies
- Procedure STP_WSS_SRP_ATTRIBUTES loads TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG
- Static views (CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC) aggregate from snapshot tables
- Composite actuals (CV_COMP_SKF_ACTUAL_STATIC) join static and base views
- Lookup views (calendar, profit center, hierarchy node) provide auxiliary data for composite actuals

### Snapshot / Circular Dependencies
- Snapshot tables loaded by procedure must be preserved as physical tables with audit columns
- Static views depend on snapshot tables, composite actuals depend on static views

---

# FINAL DECISION SUMMARY

- **Should all supplied SQLs be consolidated into one query?**
  - No. Only specific groups with shared logic should be consolidated. Dimension projections and base aggregations should remain independent.

- **If not, why should they not all be merged?**
  - Unique business logic, filters, transformations, output requirements, and snapshot behavior require separation for maintainability, performance, and data freshness.

- **Which SQLs should be consolidated?**
  - Composite actuals and static views (store attribute and comp flag) should be consolidated/materialized for reuse.

- **Which SQLs should only be partially consolidated?**
  - Static views and composite actuals, with shared intermediate logic.

- **Which SQLs should remain independent?**
  - Dimension projections (calendar, profit center, hierarchy node), base aggregations (weekly actuals, store attribute, comp flag).

- **What logic is duplicated?**
  - Store attribute and comp flag projections/aggregations, weekly actuals aggregation, lookup projections.

- **Which SQLs are duplicating that logic?**
  - CV_BASE_MD_SRPACT_S4, CV_COMP_MD_SRPACT_STATIC, STP_WSS_SRP_ATTRIBUTES; CV_BASE_MD_COMPFL_S4, CV_COMP_MD_COMPFL_STATIC, STP_WSS_SRP_ATTRIBUTES; CV_BASE_SKF_WEEKLY_ACTUAL_S4, CV_COMP_SKF_ACTUAL_STATIC.

- **Can the duplicated logic actually be reused?**
  - Yes. Materialize static and composite views for reuse.

- **What existing objects can already be reused?**
  - Snapshot tables (TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG), base weekly actuals view, lookup views.

- **What new reusable intermediate objects are required, if any?**
  - Materialized static and composite views.

- **What object type should be used for each supplied SQL: View, Materialized View, or Physical Table?**
  - See Object Type Recommendation section above.

- **Why is that object type appropriate?**
  - Based on transformation complexity, reuse level, downstream usage, performance, cost, and data freshness.

- **What redundancy can be removed?**
  - Repeated aggregation and projection logic by materializing static and composite views.

- **What performance and cost optimizations are possible?**
  - Materialize costly aggregations, early filtering, reuse lookup views, reduce repeated joins/aggregations.

- **What data freshness considerations apply?**
  - Snapshot tables should be loaded on schedule via procedure; static and composite views refreshed/materialized as needed; lookup views on demand.

- **What is the recommended dependency and execution flow?**
  - Procedure loads snapshot tables → static views aggregate from snapshot tables → composite actuals join static and base views → reporting outputs from composite actuals.

- **What architecture maximizes reuse without changing business logic?**
  - Materialize static and composite views, reuse base and lookup views, preserve snapshot tables and audit logic.

- **Recommendation confidence:** High

---

## GITHUB OUTPUT

Now proceeding to write the complete recommendation output to the specified GitHub repository.