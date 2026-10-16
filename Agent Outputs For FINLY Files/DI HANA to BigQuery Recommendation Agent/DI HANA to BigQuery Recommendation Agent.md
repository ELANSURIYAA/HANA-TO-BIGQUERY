# DI HANA to BigQuery Recommendation Agent
## Complete BigQuery Recommendations and Consolidation Analysis

---

## 1. EXECUTIVE SUMMARY

- **Actual number of SQLs analyzed:** 12
- **All supplied SQL files successfully analyzed:** Yes
- **Should all supplied SQLs be consolidated?:** No, consolidation is only recommended for logical groups with shared processing; most SQLs are wrappers or serve as distinct layers.
- **Major reusable logic identified:** Projection and filtering of master data tables (MANDT/RCLNT filters), aggregation cubes, snapshot/refresh patterns, and direct mappings.
- **Major redundancy identified:** Repeated filtering on MANDT/RCLNT, repeated projection logic for similar master data tables, snapshot population logic replicated in static views.
- **Major consolidation groups:** Store Profile (SRPACT/COMPFL), Static Snapshot Views, Master Data Projections.
- **SQLs that should remain independent:** Views representing distinct master data (CEPCT, RCALWEEK, HRRP_NODE), weekly actuals, and static snapshot views.
- **Existing objects that should be reused:** TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG, Calculation Views for base master data.
- **Major architectural recommendation:** Layered architecture with reusable base views, shared intermediate aggregation, and snapshot tables for periodic refresh.
- **Major View / Materialized View / Physical Table recommendations:** Views for projections, Materialized Views for cubes with aggregation, Physical Tables for snapshot population.
- **Important dependency patterns:** Upstream base views feed into snapshot tables and static views; procedural logic populates snapshot tables.
- **Snapshot/circular patterns:** Controlled snapshot/refresh logic via procedural population of TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG.
- **Key performance and cost opportunities:** Early filtering, materialization of aggregation cubes, reuse of snapshot tables, reduction of repeated projections.
- **Overall recommendation confidence:** High, except for unresolved mapping details and datatype validation (requires validation for some aspects).

---

## 2. INPUT VALIDATION

| Validation Item              | Result         |
|------------------------------|---------------|
| Lineage provided             | Yes           |
| ZIP provided                 | Yes           |
| Actual SQL file count        | 12            |
| SQL files successfully analyzed | 12         |
| Unreadable/invalid files     | None          |
| Successfully analyzed        | Yes           |

**SQL files found in ZIP:**
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
- File Relationships Table (2).txt

---

## 3. SQL INVENTORY

| SQL File                                   | Main Purpose                                     | Sources                                      | Main Transformations | Output | Upstream Dependencies | Downstream Usage |
|---------------------------------------------|--------------------------------------------------|----------------------------------------------|----------------------|--------|----------------------|-----------------|
| GL_HEIR.CV_BASE_MD_HRRP_NODE_S4            | Projection of GL hierarchy master data           | SAP_S4.HRRP_NODE                             | Filter on MANDT      | Dim view| None                 | CV_COMP_FIN_ACTUAL_STATIC |
| PC_HEIR.CV_BASE_MD_HRRP_NODE_S4            | Projection of PC hierarchy master data           | SAP_S4.HRRP_NODE                             | Filter on MANDT      | Dim view| None                 | CV_COMP_FIN_ACTUAL_STATIC |
| CV_COMP_MD_COMPFL_STATIC                   | Static snapshot wrapper for comp flag            | TBL_WSS_SRP_COMPFLAG                         | Projection           | Static view | STP_WSS_SRP_ATTRIBUTES | CV_COMP_FIN_ACTUAL_STATIC |
| CV_BASE_MD_SRPACT_S4                       | Aggregated store profile attributes              | SAP_S4.ZTSRP_ATTR_ACT                        | Filter, Aggregation  | Cube view | None                 | STP_WSS_SRP_ATTRIBUTES |
| CV_BASE_MD_RCALWEEL_S4                     | Projection of retail calendar week master data   | SAP_S4.ZTFIGL_RCALWEEK                       | Filter on RCLNT      | Dim view| None                 | CV_COMP_FIN_ACTUAL_STATIC |
| CV_BASE_MD_CEPCT_S4                        | Projection of profit center text master data     | SAP_S4.CEPCT                                 | Filter on MANDT      | Dim view| None                 | CV_COMP_FIN_ACTUAL_STATIC |
| CV_BASE_MD_COMPFL_S4                       | Projection of comp flag master data              | SAP_S4.ZTSRP_COMPFL                          | Filter on MANDT      | Dim view| None                 | STP_WSS_SRP_ATTRIBUTES |
| CV_COMP_FIN_ACTUAL_STATIC                  | Aggregated actuals with master data joins        | Multiple Calculation Views                   | Joins, Aggregation, Calculations | Cube view | Multiple base views | Final reporting layer |
| CV_BASE_FIN_WEEKLY_ACTUAL_S4               | Aggregated weekly actuals                        | CVS_FRIP.AZSRP_DS072_VT_S4                   | Filter, Aggregation  | Cube view | None                 | CV_COMP_FIN_ACTUAL_STATIC |
| STP_WSS_SRP_ATTRIBUTES                     | Procedure: snapshot population                   | CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4   | Delete, Insert, Current Timestamp | Physical tables | None | CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC |
| CV_COMP_MD_SRPACT_STATIC                   | Static snapshot wrapper for store profile attrs  | TBL_WSS_SRP_ATTR_ACT                         | Aggregation          | Static view | STP_WSS_SRP_ATTRIBUTES | CV_COMP_FIN_ACTUAL_STATIC |
| File Relationships Table (2)               | Lineage and dependency mapping                   | N/A                                          | N/A                  | N/A    | N/A                  | N/A             |

---

## 4. OBJECT TYPE RECOMMENDATION

| SQL File                                   | Recommended Object   | Data Freshness         | Reuse Level         | Rationale                                             | Confidence |
|---------------------------------------------|----------------------|------------------------|---------------------|-------------------------------------------------------|------------|
| GL_HEIR.CV_BASE_MD_HRRP_NODE_S4            | View                 | Near real-time         | High                | Simple projection, reusable across reporting          | High       |
| PC_HEIR.CV_BASE_MD_HRRP_NODE_S4            | View                 | Near real-time         | High                | Simple projection, reusable across reporting          | High       |
| CV_COMP_MD_COMPFL_STATIC                   | Materialized View    | Periodic/snapshot      | Medium              | Static snapshot, used for reporting, periodic refresh | High       |
| CV_BASE_MD_SRPACT_S4                       | Materialized View    | Periodic/snapshot      | Medium              | Aggregation cube, used for snapshot population        | High       |
| CV_BASE_MD_RCALWEEL_S4                     | View                 | Near real-time         | High                | Projection, reusable for calendar joins               | High       |
| CV_BASE_MD_CEPCT_S4                        | View                 | Near real-time         | High                | Projection, reusable for profit center text           | High       |
| CV_BASE_MD_COMPFL_S4                       | Materialized View    | Periodic/snapshot      | Medium              | Projection, used for snapshot population              | High       |
| CV_COMP_FIN_ACTUAL_STATIC                  | Materialized View    | Periodic/snapshot      | High                | Aggregation with joins, complex, reused for reporting | Medium     |
| CV_BASE_FIN_WEEKLY_ACTUAL_S4               | Materialized View    | Periodic/snapshot      | Medium              | Aggregation cube, reused for reporting                | High       |
| STP_WSS_SRP_ATTRIBUTES                     | Physical Table       | Periodic/snapshot      | High                | Procedure populates snapshot tables                   | Medium     |
| CV_COMP_MD_SRPACT_STATIC                   | Materialized View    | Periodic/snapshot      | Medium              | Static snapshot, used for reporting                   | High       |
| File Relationships Table (2)               | N/A                  | N/A                    | N/A                 | Lineage input, not implemented as a BigQuery object   | N/A        |

---

## 5. COMMON LOGIC ANALYSIS

| Common Logic              | SQLs Using It                  | Actual Similarity | Business Logic Match | Existing Object | Reusable? | Reuse Potential | Confidence |
|--------------------------|-------------------------------|-------------------|----------------------|-----------------|-----------|-----------------|------------|
| Projection/filter on MANDT/RCLNT | GL_HEIR.CV_BASE_MD_HRRP_NODE_S4, PC_HEIR.CV_BASE_MD_HRRP_NODE_S4, CV_BASE_MD_CEPCT_S4, CV_BASE_MD_COMPFL_S4, CV_BASE_MD_RCALWEEL_S4 | High (identical filter logic, column mapping) | Yes | Views | Yes | High | High |
| Aggregation cube (SUM, GROUP BY) | CV_BASE_MD_SRPACT_S4, CV_COMP_FIN_ACTUAL_STATIC, CV_BASE_FIN_WEEKLY_ACTUAL_S4, CV_COMP_MD_SRPACT_STATIC | Partial (different measures and groupings) | Partial | Materialized Views | Partial | Medium | Medium |
| Snapshot population logic | STP_WSS_SRP_ATTRIBUTES, CV_COMP_MD_COMPFL_STATIC, CV_COMP_MD_SRPACT_STATIC | High (same snapshot population, timestamp logic) | Yes | Physical Tables | Yes | High | High |

---

## 6. REDUNDANCY ANALYSIS

| Redundant Logic                  | SQLs Affected                                  | What Is Repeated                | Potential Reduction         | Recommended Action             | Confidence |
|----------------------------------|------------------------------------------------|---------------------------------|-----------------------------|-------------------------------|------------|
| Filtering on MANDT/RCLNT         | GL_HEIR.CV_BASE_MD_HRRP_NODE_S4, PC_HEIR.CV_BASE_MD_HRRP_NODE_S4, CV_BASE_MD_CEPCT_S4, CV_BASE_MD_COMPFL_S4, CV_BASE_MD_RCALWEEL_S4 | Filter logic on client columns  | Centralize filter in reusable views | Use base views for all downstream consumers | High       |
| Snapshot population logic        | STP_WSS_SRP_ATTRIBUTES, CV_COMP_MD_COMPFL_STATIC, CV_COMP_MD_SRPACT_STATIC | Insert with CURRENT_TIMESTAMP, SESSION_USER | None (business requirement for snapshot) | Preserve snapshot logic, do not consolidate | High       |
| Aggregation cubes                | CV_BASE_MD_SRPACT_S4, CV_COMP_FIN_ACTUAL_STATIC, CV_BASE_FIN_WEEKLY_ACTUAL_S4 | SUM and GROUP BY logic         | Only for identical measures/groupings | Separate cubes for distinct business logic | Medium     |

---

## 7. REUSE RECOMMENDATIONS

| Common Logic                  | SQLs Using It                  | Existing Object | Existing Object Reusable? | Recommendation              | Recommended Object Type | Rationale                                             | Confidence |
|-------------------------------|-------------------------------|-----------------|--------------------------|-----------------------------|------------------------|-------------------------------------------------------|------------|
| Projection/filter on MANDT/RCLNT | Multiple views                | Views           | Yes                      | Reuse base views for all consumers | View                   | Avoid repeated filtering, centralize projection logic | High       |
| Snapshot population logic     | Static snapshot views          | Physical Tables | Yes                      | Reuse snapshot tables for static views | Physical Table         | Preserve periodic refresh and snapshot semantics      | High       |
| Aggregation cube logic        | Aggregation views              | Materialized Views | Partial                  | Reuse aggregation logic only for identical groupings/measures | Materialized View      | Partial overlap, keep separate for unique business logic | Medium     |

---

## 8. CONSOLIDATION RECOMMENDATIONS

### Consolidation Group: Store Profile Snapshot Population
**SQLs involved:** STP_WSS_SRP_ATTRIBUTES, CV_COMP_MD_COMPFL_STATIC, CV_COMP_MD_SRPACT_STATIC  
**Common logic:** Snapshot population, timestamp, session user, direct mapping from master data views  
**Unique logic:** Comp flag vs store profile attributes, different target tables  
**What should be consolidated:** Procedural snapshot logic (delete, insert, timestamp)  
**What should remain separate:** Separate static views for comp flag and store profile  
**Existing object that can be reused:** TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG  
**New intermediate object required:** None  
**Recommended object type:** Physical Table for snapshot, Materialized View for static reporting  
**Performance benefit:** Efficient periodic refresh, avoids repeated snapshot processing  
**Cost benefit:** Centralized snapshot reduces redundant processing  
**Maintainability benefit:** Clear separation of snapshot and reporting layers  
**Reason:** Business requirement for periodic snapshot; downstream static views depend on snapshot tables  
**Confidence:** High

### Consolidation Group: Master Data Projections
**SQLs involved:** GL_HEIR.CV_BASE_MD_HRRP_NODE_S4, PC_HEIR.CV_BASE_MD_HRRP_NODE_S4, CV_BASE_MD_CEPCT_S4, CV_BASE_MD_COMPFL_S4, CV_BASE_MD_RCALWEEL_S4  
**Common logic:** Projection and filtering on client columns  
**Unique logic:** Different master data domains (GL, PC, CEPCT, COMPFL, RCALWEEL)  
**What should be consolidated:** Centralized reusable views for each master data type  
**What should remain separate:** Views for each distinct master data domain  
**Existing object that can be reused:** Views  
**New intermediate object required:** None  
**Recommended object type:** View  
**Performance benefit:** Early filtering, avoids repeated scans  
**Cost benefit:** Shared logic reduces compute cost  
**Maintainability benefit:** Centralized master data views  
**Reason:** Each master data domain serves different reporting/aggregation needs  
**Confidence:** High

### Consolidation Group: Aggregation Cubes
**SQLs involved:** CV_BASE_MD_SRPACT_S4, CV_BASE_FIN_WEEKLY_ACTUAL_S4, CV_COMP_FIN_ACTUAL_STATIC  
**Common logic:** Aggregation (SUM, GROUP BY)  
**Unique logic:** Different measures, groupings, downstream usage  
**What should be consolidated:** Only identical aggregation logic  
**What should remain separate:** Distinct cubes for store profile, weekly actuals, composite actuals  
**Existing object that can be reused:** Materialized Views  
**New intermediate object required:** None  
**Recommended object type:** Materialized View  
**Performance benefit:** Materialization reduces repeated aggregation  
**Cost benefit:** Efficient query execution  
**Maintainability benefit:** Separate cubes for distinct business logic  
**Reason:** Partial overlap, but unique business requirements for each cube  
**Confidence:** Medium

**If a SQL should not be consolidated:**  
- Most views represent distinct business domains or snapshot requirements; merging all would increase complexity and reduce maintainability.

---

## 9. INDEPENDENT SQL RECOMMENDATIONS

| SQL                                   | Unique Logic                           | Reason for Independence               | Reusable Portion         | Recommended Object Type | Confidence |
|---------------------------------------|----------------------------------------|---------------------------------------|-------------------------|------------------------|------------|
| GL_HEIR.CV_BASE_MD_HRRP_NODE_S4       | GL hierarchy master data               | Distinct domain, used in reporting    | Projection/filter logic  | View                   | High       |
| PC_HEIR.CV_BASE_MD_HRRP_NODE_S4       | PC hierarchy master data               | Distinct domain, used in reporting    | Projection/filter logic  | View                   | High       |
| CV_BASE_MD_CEPCT_S4                   | Profit center text master data         | Distinct domain, used in reporting    | Projection/filter logic  | View                   | High       |
| CV_BASE_MD_RCALWEEL_S4                | Retail calendar week master data       | Distinct domain, used in reporting    | Projection/filter logic  | View                   | High       |
| CV_BASE_MD_COMPFL_S4                  | Comp flag master data                  | Distinct domain, used in snapshot     | Projection/filter logic  | Materialized View      | High       |
| CV_COMP_FIN_ACTUAL_STATIC             | Composite actuals cube with joins      | Complex aggregation/joins, unique     | Aggregation logic        | Materialized View      | Medium     |
| CV_BASE_FIN_WEEKLY_ACTUAL_S4          | Weekly actuals cube                    | Unique aggregation, used in reporting | Aggregation logic        | Materialized View      | High       |

---

## 10. PERFORMANCE AND COST OPTIMIZATION

| SQLs affected                                 | Current issue                       | Recommended approach                   | Expected benefit                  | Confidence |
|------------------------------------------------|--------------------------------------|----------------------------------------|-----------------------------------|------------|
| All master data projections                    | Repeated filtering on client columns | Centralize filter in base views        | Reduced source scans, compute     | High       |
| Aggregation cubes                              | Repeated aggregation/grouping        | Materialize cubes, reuse for reporting | Faster queries, lower compute     | Medium     |
| Static snapshot views                          | Repeated snapshot population         | Use physical tables for snapshot, static views for reporting | Efficient refresh, avoids duplication | High       |
| Composite actuals cube                         | Multiple joins, complex calculations | Materialize composite cube, optimize joins | Improved performance, maintainability | Medium     |

---

## 11. DATA FRESHNESS AND REFRESH RECOMMENDATIONS

| SQL / Object                  | Required Freshness         | Recommended Refresh Approach               | Reason                                  | Confidence |
|-------------------------------|---------------------------|--------------------------------------------|-----------------------------------------|------------|
| GL_HEIR.CV_BASE_MD_HRRP_NODE_S4, PC_HEIR.CV_BASE_MD_HRRP_NODE_S4, CV_BASE_MD_CEPCT_S4, CV_BASE_MD_RCALWEEL_S4 | Near real-time | On demand / scheduled view refresh         | Master data rarely changes, but may need periodic update | High       |
| CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4, CV_COMP_MD_COMPFL_STATIC, CV_COMP_MD_SRPACT_STATIC | Periodic/snapshot | Refresh via procedural population (STP_WSS_SRP_ATTRIBUTES) | Business requirement for snapshot/periodic refresh       | High       |
| CV_BASE_FIN_WEEKLY_ACTUAL_S4, CV_COMP_FIN_ACTUAL_STATIC | Periodic/snapshot | Materialize, refresh on schedule           | Used for reporting, requires periodic update            | Medium     |
| STP_WSS_SRP_ATTRIBUTES        | Periodic/snapshot         | Procedure-driven snapshot refresh           | Controlled snapshot process                              | High       |
| File Relationships Table (2)  | N/A                      | N/A                                         | Lineage input, not implemented as a BigQuery object       | N/A        |

---

## 12. FINAL BIGQUERY ARCHITECTURE

### Layer 1 — Existing Source / Reusable Objects
- SAP_S4.HRRP_NODE, SAP_S4.CEPCT, SAP_S4.ZTSRP_COMPFL, SAP_S4.ZTSRP_ATTR_ACT, SAP_S4.ZTFIGL_RCALWEEK, CVS_FRIP.AZSRP_DS072_VT_S4

### Layer 2 — Shared Intermediate Logic
- Views for master data projections (GL/PC hierarchy, profit center text, retail calendar week, comp flag)
- Materialized Views for aggregation cubes (store profile, weekly actuals)

### Layer 3 — Consolidated Processing
- STP_WSS_SRP_ATTRIBUTES procedure populates snapshot tables (TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG) from base views
- Static snapshot views (CV_COMP_MD_COMPFL_STATIC, CV_COMP_MD_SRPACT_STATIC) wrap snapshot tables

### Layer 4 — Independent Processing
- Composite actuals cube (CV_COMP_FIN_ACTUAL_STATIC) joins multiple base views and cubes for reporting

### Layer 5 — Reporting / Output
- CV_COMP_FIN_ACTUAL_STATIC serves as the final reporting layer for actuals

### Layer 6 — Snapshot / Physical Tables
- TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG are physical tables populated via periodic snapshot logic (STP_WSS_SRP_ATTRIBUTES)

### Dependencies
- Base views feed into snapshot tables (via STP_WSS_SRP_ATTRIBUTES)
- Static snapshot views wrap snapshot tables
- Composite actuals cube joins base views, cubes, and static snapshot views
- Reporting layer consumes composite actuals cube

### Snapshot / Circular Dependencies
- Controlled snapshot/refresh cycle: STP_WSS_SRP_ATTRIBUTES periodically deletes and inserts into snapshot tables, which are then used by static views and reporting cubes.
- This pattern must be preserved to maintain business logic and periodic refresh requirements.

---

# FINAL DECISION SUMMARY

- **Should all supplied SQLs be consolidated into one query?**  
  No. Most SQLs serve distinct business domains (master data, aggregation cubes, snapshot population, reporting) and consolidation would increase complexity and reduce maintainability.

- **If not, why should they not all be merged?**  
  Each SQL represents a unique business logic, domain, or periodic snapshot requirement. Merging would obscure dependencies, refresh cycles, and reporting requirements.

- **Which SQLs should be consolidated?**  
  Only logical groups with shared snapshot population (STP_WSS_SRP_ATTRIBUTES, CV_COMP_MD_COMPFL_STATIC, CV_COMP_MD_SRPACT_STATIC) and master data projections (GL/PC hierarchy, profit center, comp flag, retail calendar week).

- **Which SQLs should only be partially consolidated?**  
  Aggregation cubes (CV_BASE_MD_SRPACT_S4, CV_BASE_FIN_WEEKLY_ACTUAL_S4, CV_COMP_FIN_ACTUAL_STATIC) share aggregation logic but must remain separate for unique business requirements.

- **Which SQLs should remain independent?**  
  Views for distinct master data domains, composite actuals cube, weekly actuals cube, static snapshot views.

- **What logic is duplicated?**  
  Filtering on client columns (MANDT/RCLNT), snapshot population logic, aggregation cubes.

- **Which SQLs are duplicating that logic?**  
  GL_HEIR.CV_BASE_MD_HRRP_NODE_S4, PC_HEIR.CV_BASE_MD_HRRP_NODE_S4, CV_BASE_MD_CEPCT_S4, CV_BASE_MD_COMPFL_S4, CV_BASE_MD_RCALWEEL_S4 (filtering); STP_WSS_SRP_ATTRIBUTES, CV_COMP_MD_COMPFL_STATIC, CV_COMP_MD_SRPACT_STATIC (snapshot logic).

- **Can the duplicated logic actually be reused?**  
  Yes, centralize filtering and projection in base views; reuse snapshot tables for static views.

- **What existing objects can already be reused?**  
  TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG, base views for master data.

- **What new reusable intermediate objects are required, if any?**  
  None; all required intermediate objects are already defined as views or snapshot tables.

- **What object type should be used for each supplied SQL: View, Materialized View, or Physical Table?**  
  - Views: Master data projections
  - Materialized Views: Aggregation cubes, static snapshot views
  - Physical Tables: Snapshot population targets

- **Why is that object type appropriate?**  
  Views for reusable projections; Materialized Views for aggregation and reporting; Physical Tables for snapshot and periodic refresh.

- **What redundancy can be removed?**  
  Centralize filtering and projection logic; avoid repeated snapshot population by reusing physical tables.

- **What performance and cost optimizations are possible?**  
  Early filtering, materialization of cubes, reuse of snapshot tables, reduction of repeated projections and aggregations.

- **What data freshness considerations apply?**  
  Master data projections can be refreshed on demand; snapshot tables and cubes require periodic refresh as per business requirements.

- **What is the recommended dependency and execution flow?**  
  Base views → snapshot tables (via procedure) → static snapshot views → aggregation cubes → composite actuals cube → reporting layer.

- **What architecture maximizes reuse without changing business logic?**  
  Layered architecture with reusable base views, snapshot tables for periodic refresh, materialized views for reporting and aggregation, and clear separation of domains.

---

# END OF RECOMMENDATION

---
