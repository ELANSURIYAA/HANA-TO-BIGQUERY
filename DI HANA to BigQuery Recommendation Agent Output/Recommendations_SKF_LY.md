# BigQuery Recommendations and Consolidation Analysis

---

## 1. EXECUTIVE SUMMARY

- **Actual number of SQLs analyzed:** 10
- **SQL files successfully analyzed:** 10/10 (all present, readable, and valid)
- **Consolidation:** Not all supplied SQLs should be consolidated into a single query. The SQLs represent distinct layers (base, static, composite, and procedure-driven loads) with clear lineage separation and unique business logic.
- **Major reusable logic identified:** 
  - Multiple base Calculation Views are direct projections with only client filtering—these can be reused as foundational dimension Views.
  - Static Calculation Views (COMPFL_STATIC, SRPACT_STATIC) directly project from tables populated by the procedure—these are strong reuse candidates.
  - Composite/aggregation views (e.g., CV_COMP_SKF_ACTUAL_STATIC) reuse and integrate logic from multiple base/static views.
- **Major redundancy identified:** Repeated filtering on client columns (MANDT/RCLNT), repeated 1:1 projections, and repeated population of static tables via the procedure.
- **Major consolidation groups:** 
  - Base Calculation Views (projections with client filter) can be implemented as a reusable layer.
  - Static Calculation Views (projecting from procedure-populated tables) can be grouped.
- **SQLs that should remain independent:** 
  - STP_WSS_SRP_ATTRIBUTES_DI (procedure logic, snapshot/load)
  - CV_COMP_SKF_ACTUAL_STATIC_DI (composite/aggregation logic)
  - Each base Calculation View, as they serve as reusable dimensions.
- **Existing objects that should be reused:** 
  - Tables: TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG (populated by the procedure, reused by static views)
- **Major architectural recommendation:** 
  - Implement base Calculation Views as standard Views for reusability.
  - Implement static views as Views over the snapshot tables.
  - Use Materialized Views or Tables for snapshot tables populated by the procedure.
  - Implement composite/aggregation views as Views for flexibility and maintainability.
- **Major View / Materialized View / Physical Table recommendations:** 
  - Base Calculation Views: View
  - Static Calculation Views: View
  - Composite/aggregation views: View
  - Procedure-populated tables: Physical Table
- **Important dependency patterns:** 
  - Procedure loads base data into snapshot tables; static views expose these; composite views aggregate and join across all layers.
- **Snapshot/circular patterns:** 
  - Controlled snapshotting via the procedure, which truncates and reloads static tables.
- **Key performance and cost opportunities:** 
  - Early filtering at the base view layer, reuse of static tables, avoidance of redundant scans and joins, materialization of snapshot tables.
- **Overall recommendation confidence:** High (all logic and lineage are explicit; only minor datatype and function mapping require validation).

---

## 2. INPUT VALIDATION

| Validation Item                  | Result        |
|----------------------------------|--------------|
| Lineage provided                 | Yes          |
| ZIP provided                     | Yes          |
| Actual SQL file count            | 10           |
| SQL files successfully analyzed  | 10           |
| Unreadable/invalid files         | None         |
| Successfully analyzed            | Yes          |

**SQL files found:**
- CV_BASE_MD_CEPCT_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_MD_RCALWEEK_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_MD_SRPACT_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_BASE_SKF_WEEKLY_ACTUAL_S4_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_COMP_MD_COMPFL_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_COMP_MD_SRPACT_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt
- CV_COMP_SKF_ACTUAL_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt
- STP_WSS_SRP_ATTRIBUTES_DI HANA to BigQuery SQL Conversion Agent.txt

---

## 3. SQL INVENTORY

| SQL File                                                | Main Purpose                                   | Sources                                             | Main Transformations                           | Output                                | Upstream Dependencies                       | Downstream Usage                                |
|--------------------------------------------------------|------------------------------------------------|-----------------------------------------------------|-----------------------------------------------|---------------------------------------|-----------------------------------------------|-------------------------------------------------|
| CV_BASE_MD_CEPCT_S4_DI                                 | Profit center text dimension                   | SAP_S4.CEPCT                                       | Projection, filter on MANDT                   | Row-level profit center text          | None                                          | Used by composite views, PROFIT_CENTER_TEXT      |
| CV_BASE_MD_COMPFL_S4_DI                                | Comp flag dimension                            | SAP_S4.ZTSRP_COMPFL                                | Projection, filter on MANDT                   | Row-level comp flag                  | None                                          | Used by procedure, static views                  |
| CV_BASE_MD_HRRP_NODE_S4_DI                             | Cost center hierarchy node                     | SAP_S4.HRRP_NODE                                   | Projection, filter on MANDT                   | Row-level hierarchy node             | None                                          | Used by composite view (CC_HIER)                 |
| CV_BASE_MD_RCALWEEK_S4_DI                              | Retail calendar week                           | SAP_S4.ZTFIGL_RCALWEEK                             | Projection, filter on RCLNT                   | Row-level calendar week              | None                                          | Used by composite view (RETAIL_CAL)              |
| CV_BASE_MD_SRPACT_S4_DI                                | Store attributes (base)                        | SAP_S4.ZTSRP_ATTR_ACT                              | Projection, filter on MANDT, aggregation      | Aggregated store attributes           | None                                          | Used by procedure                                 |
| CV_BASE_SKF_WEEKLY_ACTUAL_S4_DI                        | Weekly actuals (base)                          | CVS_FRIP.AZSRP_DS112_VT_S4                         | Projection, filter, aggregation               | Aggregated weekly actuals             | None                                          | Used by composite view                            |
| CV_COMP_MD_COMPFL_STATIC_DI                            | Comp flag static view                          | TBL_WSS_SRP_COMPFLAG                               | Projection                                   | Row-level comp flag static            | Procedure populates table                      | Used by composite view                            |
| CV_COMP_MD_SRPACT_STATIC_DI                            | Store attributes static view                   | TBL_WSS_SRP_ATTR_ACT                               | Projection                                   | Row-level store attributes static      | Procedure populates table                      | Used by composite view                            |
| CV_COMP_SKF_ACTUAL_STATIC_DI                           | Composite: SKF actual static                   | Multiple (all above, static and base views)         | Joins, filters, calculations, aggregation     | Aggregated composite actuals           | All base and static views                       | Final output/reporting                            |
| STP_WSS_SRP_ATTRIBUTES_DI                              | Procedure: snapshot/load static tables         | CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4          | Deletes, inserts, audit columns, filter       | Loads TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG | Base views, HANA function (prior week)           | Static views, composite view                      |

---

## 4. OBJECT TYPE RECOMMENDATION

| SQL File                              | Recommended Object      | Data Freshness        | Reuse Level    | Rationale                                                                                  | Confidence |
|---------------------------------------|------------------------|----------------------|---------------|--------------------------------------------------------------------------------------------|------------|
| CV_BASE_MD_CEPCT_S4_DI                | View                   | Near real-time       | High          | Simple projection, reusable dimension, low transformation                                   | High       |
| CV_BASE_MD_COMPFL_S4_DI               | View                   | Near real-time       | High          | Simple projection, reusable, used by procedure and static view                              | High       |
| CV_BASE_MD_HRRP_NODE_S4_DI            | View                   | Near real-time       | High          | Simple projection, reusable, used by composite                                              | High       |
| CV_BASE_MD_RCALWEEK_S4_DI             | View                   | Near real-time       | High          | Simple projection, reusable, used by composite                                              | High       |
| CV_BASE_MD_SRPACT_S4_DI               | View                   | Near real-time       | Medium        | Aggregated base, used by procedure, aggregation only                                        | High       |
| CV_BASE_SKF_WEEKLY_ACTUAL_S4_DI       | View                   | Near real-time       | Medium        | Aggregated base, used by composite, aggregation only                                        | High       |
| CV_COMP_MD_COMPFL_STATIC_DI           | View                   | Snapshot (daily/periodic) | High          | Projects from static table, reusable by composite, refreshed by procedure                   | High       |
| CV_COMP_MD_SRPACT_STATIC_DI           | View                   | Snapshot (daily/periodic) | High          | Projects from static table, reusable by composite, refreshed by procedure                   | High       |
| CV_COMP_SKF_ACTUAL_STATIC_DI          | View                   | Near real-time to snapshot | High          | Composite, aggregates and joins across all layers, reporting/final output                   | High       |
| STP_WSS_SRP_ATTRIBUTES_DI             | Physical Table (target of procedure) | Snapshot (scheduled) | High          | Loads static tables, controls snapshotting, central to refresh process                      | High       |

---

## 5. COMMON LOGIC ANALYSIS

| Common Logic                       | SQLs Using It                                    | Actual Similarity                                   | Business Logic Match | Existing Object | Reusable? | Reuse Potential | Confidence |
|------------------------------------|--------------------------------------------------|-----------------------------------------------------|---------------------|-----------------|-----------|-----------------|------------|
| Client filtering (MANDT/RCLNT)     | All base Calculation Views, procedure            | All filter on client columns in WHERE clause         | Yes                 | None            | Yes       | High            | High       |
| Projection of all columns          | All base and static Calculation Views            | All project all columns 1:1 from source             | Yes                 | None            | Yes       | High            | High       |
| Static table population            | Procedure, static views                          | Procedure truncates and reloads static tables       | Yes                 | TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG | Yes | High | High |
| Aggregation (SUM)                  | Aggregated base views, composite view            | SUM on measures, GROUP BY on attributes             | Yes                 | None            | Yes       | High            | High       |
| Joins across static/base views     | Composite view                                   | Joins across all static/base views                  | Yes                 | None            | Yes       | High            | High       |

---

## 6. REDUNDANCY ANALYSIS

| Redundant Logic                | SQLs Affected                          | What Is Repeated                   | Potential Reduction                   | Recommended Action                | Confidence |
|-------------------------------|----------------------------------------|------------------------------------|---------------------------------------|-----------------------------------|------------|
| Client column filter           | All base and static views              | WHERE MANDT/RCLNT IN (...)         | Centralize in reusable base views     | Implement as reusable views       | High       |
| 1:1 column projection          | All base/static views                  | SELECT all columns from source     | None (by design for dimension views)  | Accept as necessary               | High       |
| Truncate and reload static tables | Procedure, static views             | Repeated deletes and inserts       | None (required for snapshot logic)    | Accept as required for snapshot   | High       |

---

## 7. REUSE RECOMMENDATIONS

| Common Logic                   | SQLs Using It                            | Existing Object              | Existing Object Reusable? | Recommendation                | Recommended Object Type | Rationale                                                        | Confidence |
|-------------------------------|------------------------------------------|------------------------------|--------------------------|-------------------------------|------------------------|-------------------------------------------------------------------|------------|
| Base dimension projections     | All base Calculation Views               | None                         | N/A                      | Implement as reusable Views   | View                   | All downstream logic depends on these; centralize for reuse       | High       |
| Static table projections       | Static Calculation Views                 | TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG | Yes             | Use as source for static views | View                   | Procedure populates these; static views expose them               | High       |
| Composite joins/aggregations   | CV_COMP_SKF_ACTUAL_STATIC_DI             | All base/static views         | Yes                      | Use as final reporting View   | View                   | Centralizes all logic for reporting, enables downstream flexibility| High       |

---

## 8. CONSOLIDATION RECOMMENDATIONS

### Consolidation Group: Base Calculation Views

**SQLs involved:**  
CV_BASE_MD_CEPCT_S4_DI, CV_BASE_MD_COMPFL_S4_DI, CV_BASE_MD_HRRP_NODE_S4_DI, CV_BASE_MD_RCALWEEK_S4_DI, CV_BASE_MD_SRPACT_S4_DI, CV_BASE_SKF_WEEKLY_ACTUAL_S4_DI

**Common logic:**  
Projection of all columns from source, client filter, no joins/calculations.

**Unique logic:**  
Different source tables, different output columns, different target business entities.

**What should be consolidated:**  
Each as a reusable View; do not merge into a single View due to business domain separation.

**What should remain separate:**  
Each base view should remain separate.

**Existing object that can be reused:**  
N/A (these are the reusable base layer).

**New intermediate object required:**  
No.

**Recommended object type:**  
View.

**Performance benefit:**  
Reduces redundancy, enables downstream reuse, avoids repeated source scans.

**Cost benefit:**  
Minimizes compute by enabling downstream views to leverage already-filtered/projection logic.

**Maintainability benefit:**  
Clear separation, easier maintenance, centralizes business logic.

**Reason:**  
Business domains are distinct; consolidation would obscure lineage and complicate maintenance.

**Confidence:**  
High.

---

### Consolidation Group: Static Calculation Views

**SQLs involved:**  
CV_COMP_MD_COMPFL_STATIC_DI, CV_COMP_MD_SRPACT_STATIC_DI

**Common logic:**  
Projection from procedure-populated static tables.

**Unique logic:**  
Different static tables, different output columns.

**What should be consolidated:**  
Implement each as a View over its respective static table.

**What should remain separate:**  
Each static view remains separate due to different business logic.

**Existing object that can be reused:**  
TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG

**New intermediate object required:**  
No.

**Recommended object type:**  
View.

**Performance benefit:**  
Enables reuse, avoids repeated logic.

**Cost benefit:**  
Reduces repeated scans, leverages snapshotting.

**Maintainability benefit:**  
Clear separation, aligns with snapshot logic.

**Reason:**  
Each static view exposes a different business entity.

**Confidence:**  
High.

---

### Consolidation Group: Composite View

**SQLs involved:**  
CV_COMP_SKF_ACTUAL_STATIC_DI

**Common logic:**  
Joins, aggregations, calculations integrating all base/static logic.

**Unique logic:**  
Business logic for reporting/analytics, parameterization.

**What should be consolidated:**  
All aggregation, joins, calculations should be centralized in this composite View.

**What should remain separate:**  
Base and static views.

**Existing object that can be reused:**  
All base and static views.

**New intermediate object required:**  
No.

**Recommended object type:**  
View.

**Performance benefit:**  
Centralizes heavy processing, enables reuse for reporting.

**Cost benefit:**  
Reduces repeated joins/aggregations in downstream queries.

**Maintainability benefit:**  
Centralizes business rules, easier to audit.

**Reason:**  
Composite logic is unique and requires integration of all layers.

**Confidence:**  
High.

---

If a SQL should not be consolidated, explicitly explain why:

- **STP_WSS_SRP_ATTRIBUTES_DI** should not be merged with any view logic. It is a procedural load responsible for snapshotting and audit logic, and merging it would obscure refresh cycles and break lineage.

---

## 9. INDEPENDENT SQL RECOMMENDATIONS

| SQL                                   | Unique Logic                                      | Reason for Independence                        | Reusable Portion                    | Recommended Object Type | Confidence |
|---------------------------------------|---------------------------------------------------|-----------------------------------------------|-------------------------------------|------------------------|------------|
| STP_WSS_SRP_ATTRIBUTES_DI             | Snapshot, load, audit columns, procedural logic   | Controls refresh/snapshot, cannot merge with views | None (except static tables produced) | Physical Table (target) | High       |
| CV_COMP_SKF_ACTUAL_STATIC_DI          | Composite aggregation, joins, business calculations | Integrates all base/static logic for analytics | All base/static views                | View                   | High       |
| Each base Calculation View            | Unique source, output, business entity            | Different sources/entities, clean separation   | Client filter/projection logic       | View                   | High       |
| Each static Calculation View          | Unique static table, output                       | Different tables/entities, clean separation    | None (except base logic reused)      | View                   | High       |

---

## 10. PERFORMANCE AND COST OPTIMIZATION

- **Repeated source scans:** Avoided by implementing reusable base views with early filtering.
- **Repeated joins:** Centralized in composite view; no unnecessary repeated joins elsewhere.
- **Repeated aggregations:** Aggregations only in base and composite views; not repeated unnecessarily.
- **Repeated calculations:** Only performed in composite view where required.
- **Early filtering:** All base views apply client filter at the source.
- **Partition pruning:** Not explicitly implemented; recommend partitioning snapshot tables by load date if volumes are high (requires validation).
- **Clustering:** Not explicitly present; recommend clustering on key columns if query patterns support (requires validation).
- **Intermediate result reuse:** Static tables (populated by procedure) are the main reusable intermediate datasets.
- **Materialization:** Static tables are materialized (physical tables) via the procedure; all other logic is in Views.
- **Unnecessary processing:** None identified; all processing is justified by business logic.
- **Storage vs. compute trade-offs:** Static tables trade storage for reduced compute during analytics/reporting.

---

## 11. DATA FRESHNESS AND REFRESH RECOMMENDATIONS

| SQL / Object                  | Required Freshness        | Recommended Refresh Approach      | Reason                                      | Confidence |
|-------------------------------|--------------------------|-----------------------------------|---------------------------------------------|------------|
| Base Calculation Views        | Near real-time           | On-demand/View                    | Source tables are current                   | High       |
| Static Calculation Views      | Snapshot (daily/periodic)| Refresh via procedure (scheduled) | Populated by procedure, snapshot logic      | High       |
| Composite View                | Near real-time to snapshot| View (on-demand)                  | Consumes static and base views              | High       |
| Static Tables                 | Snapshot (daily/periodic)| Loaded by procedure (scheduled)   | Controlled snapshot/load                    | High       |
| Procedure                     | Snapshot (daily/periodic)| Scheduled execution               | Controls refresh/snapshot                   | High       |

---

## 12. FINAL BIGQUERY ARCHITECTURE

### Layer 1 — Existing Source / Reusable Objects
- SAP_S4 source tables (CEPCT, ZTSRP_COMPFL, HRRP_NODE, ZTFIGL_RCALWEEK, ZTSRP_ATTR_ACT, AZSRP_DS112_VT_S4)
- CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT, CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG

### Layer 2 — Shared Intermediate Logic
- Base Calculation Views (CV_BASE_MD_CEPCT_S4_DI, CV_BASE_MD_COMPFL_S4_DI, CV_BASE_MD_HRRP_NODE_S4_DI, CV_BASE_MD_RCALWEEK_S4_DI, CV_BASE_MD_SRPACT_S4_DI, CV_BASE_SKF_WEEKLY_ACTUAL_S4_DI)

### Layer 3 — Consolidated Processing
- Static Calculation Views (CV_COMP_MD_COMPFL_STATIC_DI, CV_COMP_MD_SRPACT_STATIC_DI) as Views over static tables

### Layer 4 — Independent Processing
- STP_WSS_SRP_ATTRIBUTES_DI (procedure) for snapshotting/loading static tables

### Layer 5 — Reporting / Output
- CV_COMP_SKF_ACTUAL_STATIC_DI (composite view for analytics/reporting)

### Layer 6 — Snapshot / Physical Tables
- TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG (populated by procedure, consumed by static views)

### Dependencies
- Base Calculation Views ← SAP_S4 source tables
- Procedure (STP_WSS_SRP_ATTRIBUTES_DI) ← Base Calculation Views → Loads static tables
- Static Calculation Views ← Static tables (populated by procedure)
- Composite View ← All base and static views
- Reporting/analytics consume composite view

### Snapshot / Circular Dependencies
- Controlled snapshot cycle: procedure truncates and reloads static tables, ensuring all downstream static and composite views reflect the latest snapshot. No circular logic; snapshotting is explicitly managed by the procedure.

---

# FINAL DECISION SUMMARY

- **Should all supplied SQLs be consolidated into one query?**
  - No. They represent distinct architectural layers with unique business logic, dependencies, and refresh cycles.

- **If not, why should they not all be merged?**
  - Merging would obscure lineage, complicate maintenance, break snapshot logic, and violate business domain separation.

- **Which SQLs should be consolidated?**
  - Base Calculation Views and Static Calculation Views should be implemented as reusable, independent Views (not merged).

- **Which SQLs should only be partially consolidated?**
  - Composite view (CV_COMP_SKF_ACTUAL_STATIC_DI) consolidates logic from all base and static views.

- **Which should remain independent?**
  - Procedure (STP_WSS_SRP_ATTRIBUTES_DI), each base Calculation View, each static Calculation View, composite view.

- **What logic is duplicated?**
  - Client filtering and 1:1 column projection in base/static views; snapshot table loading in procedure.

- **Which SQLs are duplicating that logic?**
  - All base/static views for client filter/projection; static views and procedure for snapshot table logic.

- **Can the duplicated logic actually be reused?**
  - Yes—by implementing as reusable Views and centralizing snapshot logic in the procedure.

- **What existing objects can already be reused?**
  - TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG (populated by the procedure, used by static views).

- **What new reusable intermediate objects are required, if any?**
  - None required; all necessary intermediate objects already exist or are justified as Views.

- **What object type should be used for each supplied SQL: View, Materialized View, or Physical Table?**
  - Base/static/composite Calculation Views: View
  - Static tables: Physical Table (populated by procedure)
  - Procedure: Physical Table (target), not a View

- **Why is that object type appropriate?**
  - Views maximize reuse and maintainability for projections/aggregations; physical tables are required for snapshotting and procedural loads.

- **What redundancy can be removed?**
  - Centralize client filtering and projection logic in base views to avoid repeated source scans.

- **What performance and cost optimizations are possible?**
  - Early filtering, reuse of static tables, centralized joins/aggregations, avoid repeated full table scans.

- **What data freshness considerations apply?**
  - Base and composite views provide near real-time data; static views/tables reflect last snapshot loaded by the procedure.

- **What is the recommended dependency and execution flow?**
  - Sources → Base Views → Procedure (loads static tables) → Static Views → Composite View → Reporting

- **What architecture maximizes reuse without changing business logic?**
  - Layered architecture with reusable base views, snapshot-managed static tables/views, and a composite reporting view.

---

**This recommendation is based strictly on the actual SQL logic and lineage provided in the current execution. All SQLs are accounted for, and recommendations are justified with explicit evidence. No final SQL is generated.**

---
