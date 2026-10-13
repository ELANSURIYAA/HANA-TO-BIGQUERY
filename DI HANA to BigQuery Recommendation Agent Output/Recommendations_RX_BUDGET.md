# BigQuery Recommendations and Consolidation Analysis — SKF_BUDGET

---

## 1. EXECUTIVE SUMMARY

**Actual number of SQLs analyzed:** 10  
**All supplied SQL files successfully analyzed:** Yes  
**Should all supplied SQLs be consolidated:** No  
**Major reusable logic identified:**
- Row-level projections from source tables (dimension views)
- Aggregation/grouping logic for CUBE views
- Common filters on client (MANDT/RCLNT) columns
- Shared source-to-target mappings for store attributes and comp flag tables

**Major redundancy identified:**
- Repeated row-level projections with identical column mappings
- Multiple views/procedures referencing the same source tables for similar outputs

**Major consolidation groups:**
- Static dimension projections (can be partially consolidated or reused as views)
- Store attribute and comp flag aggregation logic (can share intermediate datasets)

**SQLs that should remain independent:**
- CV_COMP_SKF_BUDGET_STATIC (complex join/aggregation)
- STP_WSS_SRP_ATTRIBUTES (procedural snapshot logic)
- CV_BASE_SKF_WEEKLY_BUDGET_S4 (complex union/aggregation)

**Existing objects that should be reused:**
- TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG (as reusable tables/views)
- CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_COMPFL_S4 (as source views for snapshot logic)

**Major architectural recommendation:**
- Use Views for simple projections and reusable dimension logic
- Use Materialized Views for aggregation-heavy CUBE logic with frequent downstream usage
- Use Physical Tables for snapshot/persisted datasets (e.g., STP_WSS_SRP_ATTRIBUTES output tables)
- Consolidate static dimension projections where possible, but preserve unique business logic

**Major View / Materialized View / Physical Table recommendations:**
- Dimension projections: Views
- Aggregation/CUBE logic: Materialized Views (where reuse and performance justify)
- Snapshot tables: Physical Tables

**Important dependency patterns:**
- Calculation Views feed into composite views and procedures
- Stored procedure creates snapshot tables consumed by static views
- Complex join/aggregation views depend on multiple dimension and snapshot tables

**Snapshot/circular patterns:**
- STP_WSS_SRP_ATTRIBUTES establishes a controlled snapshot cycle for TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG
- CV_COMP_SKF_BUDGET_STATIC depends on snapshot tables and multiple dimension views

**Key performance and cost opportunities:**
- Early filtering on client columns
- Materialize aggregation-heavy logic for reuse
- Eliminate redundant projections by sharing reusable views

**Overall recommendation confidence:** High (with minor unresolved items requiring validation, e.g., datatype mapping, parameter handling)

---

## 2. INPUT VALIDATION

| Validation Item                | Result     |
|-------------------------------|------------|
| Lineage provided               | Yes        |
| ZIP provided                   | Yes        |
| Actual SQL file count          | 10         |
| SQL files successfully analyzed| 10         |
| Unreadable/invalid files       | None       |
| Successfully analyzed          | Yes        |

**SQL files found:**
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

| SQL File                                         | Main Purpose                                         | Sources                                      | Main Transformations                          | Output                                | Upstream Dependencies                    | Downstream Usage                         |
|--------------------------------------------------|------------------------------------------------------|-----------------------------------------------|-----------------------------------------------|----------------------------------------|------------------------------------------|------------------------------------------|
| CV_BASE_MD_CEPCT_S4_DI                           | Project profit center text dimension                 | SAP_S4.CEPCT                                 | Row-level projection, filter on MANDT         | Profit center text dimension           | None                                     | CV_COMP_SKF_BUDGET_STATIC, others        |
| CV_BASE_MD_COMPFL_S4_DI                          | Project comp flag dimension                          | SAP_S4.ZTSRP_COMPFL                          | Row-level projection, filter on MANDT         | Comp flag dimension                    | None                                     | STP_WSS_SRP_ATTRIBUTES, others           |
| CV_BASE_MD_HRRP_NODE_S4_DI                       | Project hierarchy node dimension                     | SAP_S4.HRRP_NODE                             | Row-level projection, filter on MANDT         | Hierarchy node dimension               | None                                     | CV_COMP_SKF_BUDGET_STATIC, others        |
| CV_BASE_MD_RCALWEEK_S4_DI                        | Project calendar week dimension                      | SAP_S4.ZTFIGL_RCALWEEK                       | Row-level projection, filter on RCLNT         | Calendar week dimension                | None                                     | CV_COMP_SKF_BUDGET_STATIC, others        |
| CV_BASE_MD_SRPACT_S4_DI                          | Store attribute aggregation                          | SAP_S4.ZTSRP_ATTR_ACT                        | Aggregation (SUM), filter on MANDT            | Store attribute aggregation            | None                                     | STP_WSS_SRP_ATTRIBUTES                   |
| CV_BASE_SKF_WEEKLY_BUDGET_S4_DI                  | Weekly budget aggregation (union of cubes)           | AZSRP_DS092_VT_S4, AZSRP_DS031_VT_S4         | Union, aggregation, restricted measures       | Weekly budget cube                     | None                                     | CV_COMP_SKF_BUDGET_STATIC                |
| CV_COMP_MD_COMPFL_STATIC_DI                      | Static projection of comp flag snapshot table        | TBL_WSS_SRP_COMPFLAG                         | Row-level projection                         | Comp flag snapshot dimension           | STP_WSS_SRP_ATTRIBUTES                   | CV_COMP_SKF_BUDGET_STATIC                |
| CV_COMP_MD_SRPACT_STATIC_DI                      | Static projection of store attribute snapshot table  | TBL_WSS_SRP_ATTR_ACT                         | Aggregation (SUM)                            | Store attribute snapshot dimension     | STP_WSS_SRP_ATTRIBUTES                   | CV_COMP_SKF_BUDGET_STATIC                |
| CV_COMP_SKF_BUDGET_STATIC_DI                     | Composite budget cube (complex join/aggregation)     | Multiple: CV_BASE_SKF_WEEKLY_BUDGET_S4, etc. | Joins, filters, calculations, aggregation     | Composite budget cube                  | Multiple dimension views, snapshots      | Final reporting/output                   |
| STP_WSS_SRP_ATTRIBUTES_DI                        | Procedural snapshot population                       | CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4   | Deletes, inserts, procedural logic            | TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG | CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4 | CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC |

---

## 4. OBJECT TYPE RECOMMENDATION

| SQL File                        | Recommended Object       | Data Freshness         | Reuse Level             | Rationale                                                                                     | Confidence |
|----------------------------------|-------------------------|------------------------|------------------------|-----------------------------------------------------------------------------------------------|------------|
| CV_BASE_MD_CEPCT_S4_DI           | View                    | Near real-time         | High                   | Simple projection, reusable dimension, low transformation complexity                          | High       |
| CV_BASE_MD_COMPFL_S4_DI          | View                    | Near real-time         | Medium                 | Simple projection, reusable for comp flag logic                                                | High       |
| CV_BASE_MD_HRRP_NODE_S4_DI       | View                    | Near real-time         | Medium                 | Simple projection, reusable for hierarchy logic                                                | High       |
| CV_BASE_MD_RCALWEEK_S4_DI        | View                    | Near real-time         | Medium                 | Simple projection, reusable for calendar week logic                                            | High       |
| CV_BASE_MD_SRPACT_S4_DI          | Materialized View       | Daily/scheduled        | High                   | Aggregation-heavy, feeds snapshot logic, reused in multiple downstream objects                 | High       |
| CV_BASE_SKF_WEEKLY_BUDGET_S4_DI  | Materialized View       | Daily/scheduled        | High                   | Union/aggregation logic, reused in composite cube, performance benefit for materialization     | Medium     |
| CV_COMP_MD_COMPFL_STATIC_DI      | View                    | Snapshot               | Medium                 | Row-level snapshot, reusable as static comp flag dimension                                    | High       |
| CV_COMP_MD_SRPACT_STATIC_DI      | Materialized View       | Snapshot               | High                   | Aggregation-heavy snapshot, feeds composite cube, performance benefit for materialization      | High       |
| CV_COMP_SKF_BUDGET_STATIC_DI     | Materialized View       | Daily/scheduled        | High                   | Complex join/aggregation, feeds reporting/output, performance benefit for materialization      | Medium     |
| STP_WSS_SRP_ATTRIBUTES_DI        | Physical Table          | Snapshot               | High                   | Procedural logic, creates snapshot tables, must persist for downstream views                   | High       |

---

## 5. COMMON LOGIC ANALYSIS

| Common Logic                   | SQLs Using It                               | Actual Similarity    | Business Logic Match | Existing Object           | Reusable? | Reuse Potential | Confidence |
|--------------------------------|---------------------------------------------|----------------------|---------------------|---------------------------|-----------|-----------------|------------|
| Row-level projection           | CV_BASE_MD_CEPCT_S4, CV_BASE_MD_COMPFL_S4, CV_BASE_MD_HRRP_NODE_S4, CV_BASE_MD_RCALWEEK_S4 | High                 | Yes                 | Views                      | Yes       | High            | High       |
| Aggregation (SUM, GROUP BY)    | CV_BASE_MD_SRPACT_S4, CV_COMP_MD_SRPACT_STATIC | High                 | Yes                 | Materialized View/Tables   | Yes       | High            | High       |
| Snapshot population            | STP_WSS_SRP_ATTRIBUTES, CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC | Medium               | Yes                 | Physical Table/Views        | Yes       | Medium           | Medium     |
| Complex join/aggregation       | CV_COMP_SKF_BUDGET_STATIC                   | Unique, partial      | Partial             | Materialized View          | Partial   | Medium           | Medium     |

---

## 6. REDUNDANCY ANALYSIS

| Redundant Logic                | SQLs Affected                               | What Is Repeated     | Potential Reduction | Recommended Action         | Confidence |
|-------------------------------|---------------------------------------------|----------------------|---------------------|----------------------------|------------|
| Row-level projection           | Multiple dimension views                    | Identical column mapping | Consolidate as reusable views | Create shared views for projections | High       |
| Aggregation logic              | Store attribute aggregation/snapshot views  | SUM, GROUP BY on same columns | Materialize and reuse intermediate results | Use materialized views for aggregation | High       |
| Snapshot logic                 | STP_WSS_SRP_ATTRIBUTES, static views        | Snapshot population and projection | Share snapshot tables as reusable sources | Use physical tables for snapshots, views for projections | High       |

---

## 7. REUSE RECOMMENDATIONS

| Common Logic                   | SQLs Using It                               | Existing Object      | Existing Object Reusable? | Recommendation             | Recommended Object Type | Rationale                                     | Confidence |
|-------------------------------|---------------------------------------------|----------------------|--------------------------|----------------------------|------------------------|-----------------------------------------------|------------|
| Dimension projection           | Multiple dimension views                    | View                 | Yes                      | Consolidate as reusable views | View                   | Simple projections, reused in downstream logic | High       |
| Store attribute aggregation    | CV_BASE_MD_SRPACT_S4, static views          | Materialized View    | Yes                      | Materialize and reuse        | Materialized View      | Aggregation-heavy logic, reused by snapshots   | High       |
| Comp flag snapshot             | STP_WSS_SRP_ATTRIBUTES, static views        | Physical Table       | Yes                      | Use snapshot tables as source| Physical Table         | Procedural snapshot, must persist for reuse    | High       |

---

## 8. CONSOLIDATION RECOMMENDATIONS

### Consolidation Group: Dimension Projections

**SQLs involved:**  
CV_BASE_MD_CEPCT_S4_DI, CV_BASE_MD_COMPFL_S4_DI, CV_BASE_MD_HRRP_NODE_S4_DI, CV_BASE_MD_RCALWEEK_S4_DI

**Common logic:**  
Row-level projection, filter on client columns, 1:1 source-to-output mapping

**Unique logic:**  
Different source tables, different column sets

**What should be consolidated:**  
Reusable as views for downstream logic

**What should remain separate:**  
Each dimension should have its own view due to unique columns/business context

**Existing object that can be reused:**  
None (each is unique but can be reused as a view)

**New intermediate object required:**  
No

**Recommended object type:**  
View

**Performance benefit:**  
Reduced repeated source scans

**Cost benefit:**  
Minimal, but improved maintainability

**Maintainability benefit:**  
High, clear separation of dimension logic

**Reason:**  
Logic is identical in structure but unique in content; views maximize reuse

**Confidence:**  
High

---

### Consolidation Group: Store Attribute Aggregation/Snapshot

**SQLs involved:**  
CV_BASE_MD_SRPACT_S4_DI, CV_COMP_MD_SRPACT_STATIC_DI, STP_WSS_SRP_ATTRIBUTES_DI

**Common logic:**  
Aggregation (SUM, GROUP BY), snapshot population

**Unique logic:**  
Procedural snapshot logic in STP_WSS_SRP_ATTRIBUTES_DI

**What should be consolidated:**  
Aggregation logic can be materialized and reused for snapshot and static views

**What should remain separate:**  
Procedural logic for snapshot population must remain in stored procedure

**Existing object that can be reused:**  
TBL_WSS_SRP_ATTR_ACT, CV_BASE_MD_SRPACT_S4

**New intermediate object required:**  
Materialized view for aggregation logic

**Recommended object type:**  
Materialized View (for aggregation), Physical Table (for snapshot)

**Performance benefit:**  
Reduced repeated aggregations

**Cost benefit:**  
Reduced compute for downstream snapshot views

**Maintainability benefit:**  
Clear separation of aggregation and snapshot logic

**Reason:**  
Aggregation logic is reused; snapshot must persist

**Confidence:**  
High

---

### Consolidation Group: Composite Budget Cube

**SQLs involved:**  
CV_COMP_SKF_BUDGET_STATIC_DI, CV_BASE_SKF_WEEKLY_BUDGET_S4_DI

**Common logic:**  
Complex join/aggregation, union of cubes, parameterized filters

**Unique logic:**  
Multiple joins, calculated columns, parameter mapping

**What should be consolidated:**  
Aggregation and join logic can be materialized as a composite cube

**What should remain separate:**  
Parameter handling, unique business logic for composite cube

**Existing object that can be reused:**  
Dimension views, materialized views for aggregation

**New intermediate object required:**  
Materialized view for composite cube

**Recommended object type:**  
Materialized View

**Performance benefit:**  
Reduced repeated joins/aggregations

**Cost benefit:**  
Reduced compute for reporting/output

**Maintainability benefit:**  
Clear separation of complex logic

**Reason:**  
Composite cube logic is unique but can reuse underlying views

**Confidence:**  
Medium

---

**If a SQL should not be consolidated, explicitly explain why:**  
- Dimension views should remain independent due to unique business context and column sets.
- Procedural snapshot logic must remain in stored procedure to preserve snapshot cycle.
- Composite cube logic is unique and should not be merged with unrelated projections.

---

## 9. INDEPENDENT SQL RECOMMENDATIONS

| SQL                              | Unique Logic                                         | Reason for Independence           | Reusable Portion                   | Recommended Object Type | Confidence |
|----------------------------------|------------------------------------------------------|-----------------------------------|------------------------------------|------------------------|------------|
| CV_BASE_MD_CEPCT_S4_DI           | Profit center text projection                        | Unique source/table, unique columns | Projection logic                   | View                   | High       |
| CV_BASE_MD_COMPFL_S4_DI          | Comp flag projection                                 | Unique source/table, unique columns | Projection logic                   | View                   | High       |
| CV_BASE_MD_HRRP_NODE_S4_DI       | Hierarchy node projection                            | Unique source/table, unique columns | Projection logic                   | View                   | High       |
| CV_BASE_MD_RCALWEEK_S4_DI        | Calendar week projection                             | Unique source/table, unique columns | Projection logic                   | View                   | High       |
| CV_BASE_MD_SRPACT_S4_DI          | Store attribute aggregation                          | Unique aggregation, filter logic    | Aggregation logic                  | Materialized View      | High       |
| CV_BASE_SKF_WEEKLY_BUDGET_S4_DI  | Weekly budget cube                                   | Unique union/aggregation logic      | Aggregation logic                  | Materialized View      | Medium     |
| CV_COMP_MD_COMPFL_STATIC_DI      | Comp flag snapshot projection                        | Unique snapshot dimension           | Projection logic                   | View                   | High       |
| CV_COMP_MD_SRPACT_STATIC_DI      | Store attribute snapshot aggregation                 | Unique snapshot aggregation         | Aggregation logic                  | Materialized View      | High       |
| CV_COMP_SKF_BUDGET_STATIC_DI     | Composite budget cube                                | Unique join/aggregation logic       | Aggregation/join logic             | Materialized View      | Medium     |
| STP_WSS_SRP_ATTRIBUTES_DI        | Procedural snapshot population                       | Unique procedural logic             | None                              | Physical Table         | High       |

---

## 10. PERFORMANCE AND COST OPTIMIZATION

| SQLs affected                       | Current issue                                | Recommended approach                           | Expected benefit                  | Confidence |
|-------------------------------------|----------------------------------------------|------------------------------------------------|-----------------------------------|------------|
| Dimension projections               | Repeated row-level scans                     | Use reusable views for projections             | Reduced source scans              | High       |
| Aggregation logic                   | Repeated SUM/GROUP BY processing             | Materialize aggregation-heavy logic            | Reduced compute, faster queries   | High       |
| Composite cube                      | Complex join/aggregation                     | Materialize composite cube as MV               | Reduced repeated joins/aggregations| Medium     |
| Snapshot tables                     | Procedural snapshot population               | Use physical tables for persisted snapshots    | Accurate snapshot, reuse benefit  | High       |
| Filtering on client columns         | Late filtering                               | Apply early filtering in all views             | Reduced data scanned              | High       |

---

## 11. DATA FRESHNESS AND REFRESH RECOMMENDATIONS

| SQL / Object                       | Required Freshness      | Recommended Refresh Approach           | Reason                                 | Confidence |
|------------------------------------|------------------------|----------------------------------------|----------------------------------------|------------|
| Dimension Views                    | Near real-time         | On-demand or scheduled refresh         | Low transformation, used in joins      | High       |
| Aggregation MVs                    | Daily/scheduled        | Scheduled materialization              | Aggregation-heavy, reused often        | High       |
| Composite Cube MV                  | Daily/scheduled        | Scheduled materialization              | Complex join/aggregation, reporting    | Medium     |
| Snapshot Tables                    | Snapshot               | Controlled procedural refresh (via STP)| Business logic requires snapshot cycle | High       |
| Procedural Table Population        | Snapshot               | Controlled refresh via procedure       | Preserves original snapshot behavior   | High       |

If freshness cannot be determined:  
**Requires validation**

---

## 12. FINAL BIGQUERY ARCHITECTURE

### Layer 1 — Existing Source / Reusable Objects

- SAP_S4.CEPCT, SAP_S4.ZTSRP_COMPFL, SAP_S4.HRRP_NODE, SAP_S4.ZTFIGL_RCALWEEK, SAP_S4.ZTSRP_ATTR_ACT, AZSRP_DS092_VT_S4, AZSRP_DS031_VT_S4

### Layer 2 — Shared Intermediate Logic

- Dimension Views: CV_BASE_MD_CEPCT_S4, CV_BASE_MD_COMPFL_S4, CV_BASE_MD_HRRP_NODE_S4, CV_BASE_MD_RCALWEEK_S4
- Store Attribute Aggregation MV: CV_BASE_MD_SRPACT_S4 (Materialized View)

### Layer 3 — Consolidated Processing

- Composite Budget Cube MV: CV_COMP_SKF_BUDGET_STATIC (Materialized View)
- Weekly Budget Cube MV: CV_BASE_SKF_WEEKLY_BUDGET_S4 (Materialized View)

### Layer 4 — Independent Processing

- Static Snapshot Views: CV_COMP_MD_SRPACT_STATIC (Materialized View), CV_COMP_MD_COMPFL_STATIC (View)
- Procedural Snapshot Population: STP_WSS_SRP_ATTRIBUTES (Physical Table population)

### Layer 5 — Reporting / Output

- Final reporting layer: CV_COMP_SKF_BUDGET_STATIC (Materialized View)

### Layer 6 — Snapshot / Physical Tables

- TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG (Physical Tables populated via STP_WSS_SRP_ATTRIBUTES)

### Dependencies

- Dimension views feed into composite cube and snapshot views
- Aggregation MVs feed into snapshot and composite cube
- Procedural snapshot population feeds into static snapshot views
- Composite cube MV feeds into reporting/output

### Snapshot / Circular Dependencies

- STP_WSS_SRP_ATTRIBUTES establishes a controlled snapshot cycle for TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG
- Static snapshot views depend on snapshot tables
- Composite cube depends on both dimension and snapshot views/tables

---

## FINAL DECISION SUMMARY

- **Should all supplied SQLs be consolidated into one query?**  
  No. Each has unique business logic, sources, transformations, and output requirements.

- **If not, why should they not all be merged?**  
  Merging would increase complexity, reduce maintainability, and obscure unique business logic. Independent processing is required for snapshot, aggregation, and dimension logic.

- **Which SQLs should be consolidated?**  
  Dimension projections can be consolidated as reusable views; aggregation logic can be materialized for reuse.

- **Which SQLs should only be partially consolidated?**  
  Aggregation/snapshot logic can be partially consolidated as materialized views, but procedural snapshot logic must remain independent.

- **Which SQLs should remain independent?**  
  Composite cube, procedural snapshot, and unique dimension projections.

- **What logic is duplicated?**  
  Row-level projections, aggregation logic, snapshot population.

- **Which SQLs are duplicating that logic?**  
  Dimension views, aggregation views, snapshot views.

- **Can the duplicated logic actually be reused?**  
  Yes, as reusable views and materialized views.

- **What existing objects can already be reused?**  
  TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG, dimension views.

- **What new reusable intermediate objects are required, if any?**  
  Materialized views for aggregation-heavy logic.

- **What object type should be used for each supplied SQL: View, Materialized View, or Physical Table?**  
  See section 4 above.

- **Why is that object type appropriate?**  
  Based on transformation complexity, reuse, freshness, performance, and maintainability.

- **What redundancy can be removed?**  
  Repeated projections and aggregations via reusable views/materialized views.

- **What performance and cost optimizations are possible?**  
  Materialize aggregation-heavy logic, early filtering, reuse of intermediate datasets.

- **What data freshness considerations apply?**  
  Dimension views: near real-time; aggregation MVs: daily/scheduled; snapshot tables: controlled refresh.

- **What is the recommended dependency and execution flow?**  
  Source tables → dimension/aggregation views → snapshot tables → composite cube → reporting/output.

- **What architecture maximizes reuse without changing business logic?**  
  Layered architecture with reusable views, materialized aggregation logic, independent procedural snapshot, and composite cube for reporting.

---

## GITHUB OUTPUT

The complete content above will be written to the specified GitHub repository as required.