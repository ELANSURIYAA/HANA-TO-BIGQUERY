# BigQuery Recommendations and Consolidation Analysis for RX_BUDGET

---

## 1. EXECUTIVE SUMMARY

- **Actual number of SQLs analyzed:** 10
- **All supplied SQL files successfully analyzed:** Yes
- **Should all supplied SQLs be consolidated?** No; multiple SQLs serve distinct business purposes, have unique transformations, or act as reusable dimension/fact layers.
- **Major reusable logic identified:** 
  - Simple projection/filter logic for master/dimension tables (e.g., HRRP_NODE, RCALWEEK, CEPCT, COMPFL)
  - Store attribute and comp flag snapshot logic (used by both Calculation Views and Procedures)
- **Major redundancy identified:** 
  - Direct 1:1 projections of source tables to output in multiple Calculation Views (potential for reusable views).
  - Repeated filtering on MANDT/RCLNT columns.
- **Major consolidation groups:** 
  - None requiring full consolidation; however, several Calculation Views can be implemented as reusable views for dimension tables.
- **SQLs that should remain independent:** All except possible consolidation of similar dimension projections.
- **Existing objects that should be reused:** 
  - TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG as intermediate physical tables for snapshot data.
- **Major architectural recommendation:** 
  - Dimension Calculation Views should be implemented as Views for maximum reusability.
  - Fact Calculation Views with aggregations or complex joins should be Materialized Views for performance.
  - Snapshot/physical tables should be used for procedural snapshot logic.
- **Major View / Materialized View / Physical Table recommendations:** 
  - Dimension/master data: Views
  - Aggregated/fact data: Materialized Views
  - Snapshot tables: Physical Tables
- **Important dependency patterns:** 
  - Fact views depend on multiple dimension views.
  - Stored procedure populates snapshot tables, which are then consumed by other Calculation Views.
- **Snapshot/circular patterns:** 
  - Controlled snapshot process via STP_WSS_SRP_ATTRIBUTES must be preserved as physical tables.
- **Key performance and cost opportunities:** 
  - Materialize complex aggregations and join logic.
  - Reuse dimension Views to avoid repeated scans/filters.
- **Overall recommendation confidence:** High, with some areas requiring validation (e.g., unresolved function mapping, session user semantics, datatype compatibility).

---

## 2. INPUT VALIDATION

| Validation Item                   | Result   |
|-----------------------------------|----------|
| Lineage provided                  | Yes      |
| ZIP provided                      | Yes      |
| Actual SQL file count             | 10       |
| SQL files successfully analyzed   | 10       |
| Unreadable/invalid files          | None     |
| Successfully analyzed             | Yes      |

**SQL files found and analyzed:**
1. CV_BASE_FIN_WEEKLY_BUDGET_S4_DI HANA to BigQuery SQL Conversion Agent.txt
2. CV_BASE_MD_CEPCT_S4_DI HANA to BigQuery SQL Conversion Agent.txt
3. CV_BASE_MD_COMPFL_S4_DI HANA to BigQuery SQL Conversion Agent.txt
4. CV_BASE_MD_HRRP_NODE_S4_DI HANA to BigQuery SQL Conversion Agent.txt
5. CV_BASE_MD_RCALWEEK_S4_DI HANA to BigQuery SQL Conversion Agent.txt
6. CV_BASE_MD_SRPACT_S4_DI HANA to BigQuery SQL Conversion Agent.txt
7. CV_COMP_FIN_BUDGET_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt
8. CV_COMP_MD_COMPFL_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt
9. CV_COMP_MD_SRPACT_STATIC_DI HANA to BigQuery SQL Conversion Agent.txt
10. STP_WSS_SRP_ATTRIBUTES_DI HANA to BigQuery SQL Conversion Agent.txt

---

## 3. SQL INVENTORY

| SQL File                                               | Main Purpose                                | Sources                                        | Main Transformations                            | Output                                   | Upstream Dependencies                   | Downstream Usage                      |
|--------------------------------------------------------|----------------------------------------------|------------------------------------------------|-------------------------------------------------|------------------------------------------|----------------------------------------|----------------------------------------|
| CV_BASE_FIN_WEEKLY_BUDGET_S4_DI                        | Weekly budget CUBE (fact)                    | AZSRP_DS052_VT_S4, AZSRP_DS041_VT_S4           | Projection, filter, union, aggregation          | Aggregated weekly budget                 | None                                   | CV_COMP_FIN_BUDGET_STATIC              |
| CV_BASE_MD_CEPCT_S4_DI                                 | Profit center text DIMENSION                 | SAP_S4.CEPCT                                   | Projection, filter                             | Profit center texts                      | None                                   | CV_COMP_FIN_BUDGET_STATIC              |
| CV_BASE_MD_COMPFL_S4_DI                                | Comp flag DIMENSION                          | SAP_S4.ZTSRP_COMPFL                            | Projection, filter                             | Comp flag master                         | None                                   | STP_WSS_SRP_ATTRIBUTES, CV_COMP_MD_COMPFL_STATIC |
| CV_BASE_MD_HRRP_NODE_S4_DI                             | Hierarchy node DIMENSION                     | SAP_S4.HRRP_NODE                               | Projection, filter                             | Hierarchy node master                    | None                                   | CV_COMP_FIN_BUDGET_STATIC              |
| CV_BASE_MD_RCALWEEK_S4_DI                              | Retail calendar week DIMENSION               | SAP_S4.ZTFIGL_RCALWEEK                         | Projection, filter                             | Calendar week master                      | None                                   | CV_COMP_FIN_BUDGET_STATIC              |
| CV_BASE_MD_SRPACT_S4_DI                                | Store profile attribute DIMENSION            | SAP_S4.ZTSRP_ATTR_ACT                          | Projection, filter, aggregation                | Store profile attributes                 | None                                   | STP_WSS_SRP_ATTRIBUTES                 |
| CV_COMP_FIN_BUDGET_STATIC_DI                           | Composite fact (final budget) CUBE           | Multiple Calculation Views (see below)         | Joins, filters, calculations, aggregations     | Aggregated budget with dimensions        | Multiple base Calculation Views         | Final reporting/output                  |
| CV_COMP_MD_COMPFL_STATIC_DI                            | Comp flag static DIMENSION                   | TBL_WSS_SRP_COMPFLAG (snapshot table)          | Projection                                     | Comp flag snapshot                       | STP_WSS_SRP_ATTRIBUTES                  | CV_COMP_FIN_BUDGET_STATIC              |
| CV_COMP_MD_SRPACT_STATIC_DI                            | Store attribute static DIMENSION             | TBL_WSS_SRP_ATTR_ACT (snapshot table)          | Projection, aggregation                        | Store attribute snapshot                 | STP_WSS_SRP_ATTRIBUTES                  | CV_COMP_FIN_BUDGET_STATIC              |
| STP_WSS_SRP_ATTRIBUTES_DI                              | Snapshot loader (procedure)                  | CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4     | Deletes, inserts, mapping to snapshot tables   | Loads TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG | CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4 | CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC |

---

## 4. OBJECT TYPE RECOMMENDATION

| SQL File                                 | Recommended Object  | Data Freshness      | Reuse Level       | Rationale                                                                 | Confidence |
|------------------------------------------|---------------------|---------------------|-------------------|--------------------------------------------------------------------------|------------|
| CV_BASE_FIN_WEEKLY_BUDGET_S4_DI          | Materialized View   | Scheduled/periodic  | High              | Complex aggregation, reused by composite views, performance critical     | High       |
| CV_BASE_MD_CEPCT_S4_DI                   | View                | Near real-time      | High              | Simple projection/filter, reusable dimension                             | High       |
| CV_BASE_MD_COMPFL_S4_DI                  | View                | Near real-time      | High              | Simple projection/filter, reusable dimension                             | High       |
| CV_BASE_MD_HRRP_NODE_S4_DI               | View                | Near real-time      | High              | Simple projection/filter, reusable dimension                             | High       |
| CV_BASE_MD_RCALWEEK_S4_DI                | View                | Near real-time      | High              | Simple projection/filter, reusable dimension                             | High       |
| CV_BASE_MD_SRPACT_S4_DI                  | View                | Near real-time      | High              | Projection/aggregation, reusable dimension                               | High       |
| CV_COMP_FIN_BUDGET_STATIC_DI             | Materialized View   | Scheduled/periodic  | High              | Complex joins, aggregations, fact output, performance benefit            | High       |
| CV_COMP_MD_COMPFL_STATIC_DI              | View                | Snapshot            | Medium            | Simple projection of snapshot table, supports static reporting           | High       |
| CV_COMP_MD_SRPACT_STATIC_DI              | View                | Snapshot            | Medium            | Aggregation on snapshot table, supports static reporting                 | High       |
| STP_WSS_SRP_ATTRIBUTES_DI                | Physical Table      | Snapshot            | N/A               | Implements snapshot logic, must persist data for static reporting        | High       |

---

## 5. COMMON LOGIC ANALYSIS

| Common Logic         | SQLs Using It                                    | Actual Similarity                                             | Business Logic Match      | Existing Object           | Reusable? | Reuse Potential | Confidence |
|----------------------|--------------------------------------------------|---------------------------------------------------------------|--------------------------|---------------------------|-----------|-----------------|------------|
| Projection + Filter on MANDT/RCLNT | CV_BASE_MD_CEPCT_S4_DI, CV_BASE_MD_COMPFL_S4_DI, CV_BASE_MD_HRRP_NODE_S4_DI, CV_BASE_MD_RCALWEEK_S4_DI | 1:1 projection, filter on client column, no calculations      | Yes                      | Each as View              | Yes       | High            | High       |
| Store attribute snapshot logic      | STP_WSS_SRP_ATTRIBUTES_DI, CV_COMP_MD_SRPACT_STATIC_DI        | Both use/store snapshot of store attributes, direct mapping   | Yes                      | TBL_WSS_SRP_ATTR_ACT      | Yes       | High            | High       |
| Comp flag snapshot logic            | STP_WSS_SRP_ATTRIBUTES_DI, CV_COMP_MD_COMPFL_STATIC_DI        | Both use/store snapshot of comp flags, direct mapping         | Yes                      | TBL_WSS_SRP_COMPFLAG      | Yes       | High            | High       |
| Aggregation/group by all non-measure columns | CV_BASE_FIN_WEEKLY_BUDGET_S4_DI, CV_BASE_MD_SRPACT_S4_DI, CV_COMP_FIN_BUDGET_STATIC_DI | Pattern of grouping all non-measure columns, SUM on measures | Yes                      | N/A                       | Yes       | High            | High       |

---

## 6. REDUNDANCY ANALYSIS

| Redundant Logic                | SQLs Affected                                      | What Is Repeated                       | Potential Reduction            | Recommended Action                  | Confidence |
|-------------------------------|----------------------------------------------------|----------------------------------------|-------------------------------|-------------------------------------|------------|
| Projection + Filter on MANDT/RCLNT | Multiple dimension Calculation Views             | Same filter and projection logic       | High                          | Implement as reusable Views         | High       |
| Snapshot table mapping         | STP_WSS_SRP_ATTRIBUTES_DI, CV_COMP_MD_SRPACT_STATIC_DI, CV_COMP_MD_COMPFL_STATIC_DI | Mapping from Calculation Views to snapshot tables | Medium                        | Use physical tables for snapshots   | High       |
| Aggregation/group by           | Multiple CUBE Calculation Views                    | Pattern repeated, but business logic differs | Low                           | Keep separate due to unique logic   | High       |

---

## 7. REUSE RECOMMENDATIONS

| Common Logic                  | SQLs Using It                                   | Existing Object          | Existing Object Reusable? | Recommendation                          | Recommended Object Type | Rationale                                                    | Confidence |
|-------------------------------|-------------------------------------------------|--------------------------|--------------------------|------------------------------------------|------------------------|---------------------------------------------------------------|------------|
| Projection + Filter on MANDT/RCLNT | All dimension Calculation Views               | Each as View             | Yes                      | Implement as reusable Views              | View                   | Simple, reusable, row-level, used by multiple fact views      | High       |
| Store attribute/comp flag snapshot | STP_WSS_SRP_ATTRIBUTES_DI, static Calculation Views | TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG | Yes                      | Use physical tables for snapshot logic   | Physical Table          | Required for snapshot/circular dependency                     | High       |
| Aggregation/group by pattern   | All CUBE Calculation Views                      | N/A                      | N/A                      | Implement as Materialized Views for facts | Materialized View      | Improves performance for repeated aggregations                | High       |

---

## 8. CONSOLIDATION RECOMMENDATIONS

### Consolidation Group: Dimension Projections

**SQLs involved:**  
CV_BASE_MD_CEPCT_S4_DI, CV_BASE_MD_COMPFL_S4_DI, CV_BASE_MD_HRRP_NODE_S4_DI, CV_BASE_MD_RCALWEEK_S4_DI

**Common logic:**  
Projection of all columns from a single table with a filter on the client column (MANDT/RCLNT).

**Unique logic:**  
Each uses a different source table and outputs different columns.

**What should be consolidated:**  
Implement as standardized Views with consistent naming and logic.

**What should remain separate:**  
Each dimension should remain its own View due to unique source and output columns.

**Existing object that can be reused:**  
Each respective View.

**New intermediate object required:**  
No.

**Recommended object type:**  
View.

**Performance benefit:**  
Avoids repeated scans and filters; enables simple joins from fact tables.

**Cost benefit:**  
Reduces repeated query cost for dimension lookups.

**Maintainability benefit:**  
Centralizes logic for master data; easy to update logic for all consumers.

**Reason:**  
Logic is identical except for source/output columns; consolidation into a single object is not appropriate, but standardization and reuse as Views is optimal.

**Confidence:**  
High.

---

## 9. INDEPENDENT SQL RECOMMENDATIONS

| SQL                                   | Unique Logic                                                                    | Reason for Independence                        | Reusable Portion           | Recommended Object Type | Confidence |
|----------------------------------------|---------------------------------------------------------------------------------|------------------------------------------------|----------------------------|------------------------|------------|
| CV_BASE_FIN_WEEKLY_BUDGET_S4_DI        | Aggregation, union, restricted measures, calculated fields                      | Unique transformation logic; fact table        | Aggregation pattern        | Materialized View      | High       |
| CV_COMP_FIN_BUDGET_STATIC_DI           | Complex joins, filters, calculated columns, parameter propagation               | Final composite fact view; unique business logic| Joins/aggregation pattern  | Materialized View      | High       |
| STP_WSS_SRP_ATTRIBUTES_DI              | Procedural snapshot logic, deletes, inserts, external function dependency       | Implements snapshot/circular dependency        | None (procedure only)      | Physical Table         | High       |
| CV_COMP_MD_SRPACT_STATIC_DI            | Aggregation on snapshot table                                                   | Consumes snapshot, unique aggregation logic    | Aggregation pattern        | View                   | High       |
| CV_COMP_MD_COMPFL_STATIC_DI            | Projection on snapshot table                                                    | Consumes snapshot, unique projection logic     | Projection pattern         | View                   | High       |
| CV_BASE_MD_SRPACT_S4_DI                | Aggregation on store profile attribute table                                    | Source for snapshot, unique filter/aggregation | Aggregation pattern        | View                   | High       |
| CV_BASE_MD_CEPCT_S4_DI                 | Profit center text projection with filter                                       | Unique output columns, source table            | Projection pattern         | View                   | High       |
| CV_BASE_MD_COMPFL_S4_DI                | Comp flag master projection with filter                                         | Unique output columns, source table            | Projection pattern         | View                   | High       |
| CV_BASE_MD_HRRP_NODE_S4_DI             | Hierarchy node projection with filter                                           | Unique output columns, source table            | Projection pattern         | View                   | High       |
| CV_BASE_MD_RCALWEEK_S4_DI              | Calendar week projection with filter                                            | Unique output columns, source table            | Projection pattern         | View                   | High       |

---

## 10. PERFORMANCE AND COST OPTIMIZATION

| SQLs affected                                         | Current issue                                           | Recommended approach                         | Expected benefit             | Confidence |
|-------------------------------------------------------|--------------------------------------------------------|----------------------------------------------|------------------------------|------------|
| All Calculation Views with projection + filter        | Repeated scans/filters on same tables                  | Implement as reusable Views                  | Reduces repeated I/O         | High       |
| Fact Calculation Views with complex joins/aggregations| Repeated complex processing per query                  | Materialize as Materialized Views            | Improves query performance   | High       |
| Snapshot table consumers                              | Potential repeated reloads, unnecessary recompute      | Use physical tables for snapshots            | Avoids unnecessary compute   | High       |
| All CUBE Calculation Views                            | Repeated aggregation/group by on large datasets        | Materialize intermediate results where reused | Reduces query cost/time      | High       |
| All                                                   | Potential for early filtering on client columns        | Apply filters as early as possible           | Partition pruning, less data | High       |

---

## 11. DATA FRESHNESS AND REFRESH RECOMMENDATIONS

| SQL / Object                        | Required Freshness   | Recommended Refresh Approach         | Reason                                             | Confidence |
|-------------------------------------|----------------------|--------------------------------------|----------------------------------------------------|------------|
| Fact/Materialized Views             | Scheduled/periodic   | Scheduled refresh (e.g., daily)      | Aggregated, not real-time, supports batch reporting | High       |
| Dimension Views                     | Near real-time       | On-demand or scheduled as needed     | Slow-changing, minimal transformation               | High       |
| Snapshot/Physical Tables            | Snapshot             | Loaded by procedure, as per schedule | Controlled snapshot process, preserves lineage      | High       |
| Session user, external function use | Requires validation  | Requires validation                  | Unresolved mapping for session user/external func   | Medium     |

---

## 12. FINAL BIGQUERY ARCHITECTURE

### Layer 1 — Existing Source / Reusable Objects
- SAP_S4 tables (e.g., ZTSRP_ATTR_ACT, ZTSRP_COMPFL, HRRP_NODE, CEPCT, ZTFIGL_RCALWEEK)
- TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG (physical snapshot tables)

### Layer 2 — Shared Intermediate Logic
- Views for dimension/master data with standardized projection/filter logic:
  - CV_BASE_MD_CEPCT_S4_DI (Profit Center Texts)
  - CV_BASE_MD_COMPFL_S4_DI (Comp Flag Master)
  - CV_BASE_MD_HRRP_NODE_S4_DI (Hierarchy Node)
  - CV_BASE_MD_RCALWEEK_S4_DI (Calendar Week)
  - CV_BASE_MD_SRPACT_S4_DI (Store Profile Attributes)

### Layer 3 — Consolidated Processing
- Materialized Views for facts:
  - CV_BASE_FIN_WEEKLY_BUDGET_S4_DI (Weekly Budget Cube)
  - CV_COMP_FIN_BUDGET_STATIC_DI (Final Budget Composite Cube)

### Layer 4 — Independent Processing
- Views on snapshot tables:
  - CV_COMP_MD_SRPACT_STATIC_DI (Aggregated Store Attribute Snapshot)
  - CV_COMP_MD_COMPFL_STATIC_DI (Comp Flag Snapshot)

### Layer 5 — Reporting / Output
- Materialized View: CV_COMP_FIN_BUDGET_STATIC_DI (final reporting layer)

### Layer 6 — Snapshot / Physical Tables
- Physical Tables: TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG (populated by STP_WSS_SRP_ATTRIBUTES_DI)

### Dependencies
- Fact views depend on dimension views for joins/filters.
- Snapshot tables are loaded by the procedure, then consumed by static Calculation Views.
- Final reporting depends on consolidated fact Materialized Views.

### Snapshot / Circular Dependencies
- The controlled snapshot process (STP_WSS_SRP_ATTRIBUTES_DI) must be preserved. Physical tables must be used for TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG. Do not convert this to direct dependency—this would break snapshot logic and lineage.

---

# FINAL DECISION SUMMARY

- **Should all supplied SQLs be consolidated into one query?**
  - No. Each Calculation View or Procedure serves a distinct business or technical purpose, with dimension/fact separation, snapshot logic, or unique transformation requirements.

- **If not, why should they not all be merged?**
  - Merging would increase complexity, reduce maintainability, and obscure business logic. Dimension tables must remain separate for reuse; snapshot logic must be physically persisted.

- **Which SQLs should be consolidated?**
  - Only dimension Calculation Views with identical logic patterns should be standardized as reusable Views, but not merged into a single object.

- **Which SQLs should only be partially consolidated?**
  - None; each serves a unique role.

- **Which should remain independent?**
  - All fact Calculation Views, all dimension Calculation Views, and the snapshot loader procedure.

- **What logic is duplicated?**
  - Projection/filter on MANDT/RCLNT columns across dimension Calculation Views.

- **Which SQLs are duplicating that logic?**
  - All dimension Calculation Views.

- **Can the duplicated logic actually be reused?**
  - Yes, by implementing as standardized Views.

- **What existing objects can already be reused?**
  - TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG (physical snapshot tables).

- **What new reusable intermediate objects are required, if any?**
  - None beyond standardized Views for dimension logic.

- **What object type should be used for each supplied SQL: View, Materialized View, or Physical Table?**
  - Dimension/master data: View
  - Fact/aggregation: Materialized View
  - Snapshot: Physical Table

- **Why is that object type appropriate?**
  - Views maximize reuse for dimension data, Materialized Views improve performance for facts, Physical Tables are required for snapshots.

- **What redundancy can be removed?**
  - Repeated projection/filter logic can be standardized into reusable Views.

- **What performance and cost optimizations are possible?**
  - Materialize complex aggregations, avoid repeated scans, centralize dimension logic, and preserve snapshot tables for static reporting.

- **What data freshness considerations apply?**
  - Materialized Views and snapshots should be refreshed on schedule; Views provide near real-time data.

- **What is the recommended dependency and execution flow?**
  - Load snapshot tables via procedure; update Views as needed; refresh Materialized Views on schedule; reporting queries use final Materialized View.

- **What architecture maximizes reuse without changing business logic?**
  - Layered architecture with reusable dimension Views, Materialized Views for facts, and preserved snapshot tables.

---

**Requires validation:**  
- Actual mapping of BigQuery project/dataset/table names.
- Data type compatibility for all columns.
- Implementation of session user and external function logic (e.g., SFN_PRIOR_FISCAL_WEEK).
- Schedule/frequency of snapshot and Materialized View refresh.

---

**End of Recommendation.**