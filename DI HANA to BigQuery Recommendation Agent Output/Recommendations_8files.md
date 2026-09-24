# BigQuery Recommendations and Consolidation Analysis

---

## 1. EXECUTIVE SUMMARY

- **Actual number of SQLs analyzed:** 8
- **All supplied SQL files successfully analyzed:** Yes
- **All supplied SQLs should be consolidated:** No. Only partial consolidation is justified; several SQLs contain unique logic or serve as ETL/statics.
- **Major reusable logic identified:** 
  - Store attribute and comparison flag ETL logic (via STP_WSS_SRP_ATTRIBUTES, TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG, CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC)
  - Use of profit center and cost element master data
  - Common filtering and join patterns on MANDT, PRCTR, FISCPER, etc.
- **Major redundancy identified:** 
  - Repeated projections and aggregations on store attribute and comp flag tables
  - Multiple views consuming the same base tables with similar filters
- **Major consolidation groups:** 
  - Static composite views (CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC) can share ETL/intermediate tables
  - Final reporting view (CV_BASE_MD_RCAIWEEK_S4_Output) consolidates most upstream logic
- **SQLs that should remain independent:** 
  - ETL Stored Procedure (STP_WSS_SRP_ATTRIBUTES_OUTPUT)
  - Direct projections (CV_BASE_MD_CEPCT_S4_OUTPUT, CV_BASE_MD_HRRP_NODE_S4_Output)
- **Existing objects that should be reused:** 
  - TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG as intermediate tables
- **Major architectural recommendation:** 
  - Centralize ETL logic for static tables, materialize key intermediate datasets, use views for reporting, and avoid unnecessary duplication of join/filter logic.
- **Major View / Materialized View / Physical Table recommendations:** 
  - Views for reporting and master data
  - Materialized Views or Tables for static/intermediate ETL outputs
- **Important dependency patterns:** 
  - ETL → Static Table → Composite View → Final Reporting View
- **Snapshot/circular patterns:** 
  - Controlled snapshot ETL for store attributes and comp flags
- **Key performance and cost opportunities:** 
  - Reuse of intermediate static tables; avoid repeated scans/joins; materialize heavy aggregations
- **Overall recommendation confidence:** High, based on explicit lineage and clear SQL logic

---

## 2. INPUT VALIDATION

| Validation Item              | Result |
|------------------------------|--------|
| Lineage provided             | Yes    |
| ZIP provided                 | Yes    |
| Actual SQL file count        | 8      |
| SQL files successfully analyzed | 8   |
| Unreadable/invalid files     | None   |
| Successfully analyzed        | Yes    |

**SQL files found:**
1. CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt
2. CV_BASE_MD_CEPCT_S4_OUTPUT.txt
3. CV_BASE_MD_HRRP_NODE_S4_Output.txt
4. CV_BASE_MD_RCAIWEEK_S4_Output.txt
5. CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt
6. CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt
7. CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt
8. STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt

---

## 3. SQL INVENTORY

| SQL File                           | Main Purpose                                          | Sources                               | Main Transformations                                    | Output                         | Upstream Dependencies               | Downstream Usage                           |
|-------------------------------------|------------------------------------------------------|---------------------------------------|---------------------------------------------------------|-------------------------------|--------------------------------------|--------------------------------------------|
| CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt | Weekly financial budget base view                   | AZSRP_DS052_VT_S4, AZSRP_DS041_VT_S4  | Union, aggregation, parameterized filtering, measures   | Aggregated financials          | Physical tables                      | Feeds composite/reporting views            |
| CV_BASE_MD_CEPCT_S4_OUTPUT.txt      | Cost element/profit center master data               | CEPCT                                 | Direct projection, MANDT filter                         | Master data                    | Physical table                        | Used in reporting joins                    |
| CV_BASE_MD_HRRP_NODE_S4_Output.txt  | HR hierarchy nodes                                   | HRRP_NODE                             | Direct projection, MANDT filter                         | Hierarchy nodes                | Physical table                        | Used in reporting joins                    |
| CV_BASE_MD_RCAIWEEK_S4_Output.txt   | Final weekly reporting view                          | Multiple views/tables                 | Multi-way joins, calculated fields, aggregations        | Final report dataset           | All base/composite views, tables      | Final reporting layer                      |
| CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt| Static composite budget view                         | CV_BASE_FIN_WEEKLY_BUDGET_S4          | Filtering, joins with HR, store, comp flag, calendar    | Enriched static view           | Base view, composite views            | Used in static reporting                   |
| CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt | Static comp flag master data                         | TBL_WSS_SRP_COMPFLAG                  | Direct projection                                      | Static comp flag view          | Populated by ETL                      | Used in reporting joins                    |
| CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt | Static store attributes master data                  | TBL_WSS_SRP_ATTR_ACT                  | Aggregation, direct projection                         | Static store attribute view    | Populated by ETL                      | Used in reporting joins                    |
| STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt   | ETL for store attributes and comp flag tables        | CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4 | Delete/insert, snapshot, parameter logic              | Populates static tables        | Calculation views                      | Enables static composite views             |

---

## 4. OBJECT TYPE RECOMMENDATION

| SQL File                           | Recommended Object      | Data Freshness        | Reuse Level        | Rationale                                                                                  | Confidence |
|-------------------------------------|------------------------|----------------------|--------------------|-------------------------------------------------------------------------------------------|------------|
| CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt | View                   | Requires validation  | High               | Aggregated, parameterized logic reused in multiple downstream objects                      | High       |
| CV_BASE_MD_CEPCT_S4_OUTPUT.txt      | View                   | Requires validation  | Medium             | Simple master data, direct projection, reused in joins                                     | High       |
| CV_BASE_MD_HRRP_NODE_S4_Output.txt  | View                   | Requires validation  | Medium             | Simple hierarchy, reused in joins                                                          | High       |
| CV_BASE_MD_RCAIWEEK_S4_Output.txt   | View                   | Requires validation  | High               | Final reporting, consolidates all upstream data                                            | High       |
| CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt| View or Materialized View | Requires validation | Medium             | Static, filtered, multi-join, could benefit from materialization if performance required   | High       |
| CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt | Materialized View or Table | Snapshot/periodic   | High               | Populated by ETL, static for period, reused in multiple views                              | High       |
| CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt | Materialized View or Table | Snapshot/periodic   | High               | Populated by ETL, static for period, reused in multiple views                              | High       |
| STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt   | Procedure/Script       | Snapshot/periodic    | High               | Central ETL, orchestrates snapshot refresh of static tables                                | High       |

---

## 5. COMMON LOGIC ANALYSIS

| Common Logic                                    | SQLs Using It                                  | Actual Similarity                      | Business Logic Match | Existing Object                  | Reusable? | Reuse Potential | Confidence |
|-------------------------------------------------|------------------------------------------------|----------------------------------------|---------------------|----------------------------------|-----------|-----------------|------------|
| Store attribute static data (TBL_WSS_SRP_ATTR_ACT) | CV_COMP_MD_SRPACT_STATIC_OUTPUT, CV_BASE_MD_RCAIWEEK_S4_Output, CV_COMP_FIN_BUDGET_STATIC_OUTPUT | High: same table, similar projections/joins | Yes                 | TBL_WSS_SRP_ATTR_ACT             | Yes       | High            | High       |
| Comp flag static data (TBL_WSS_SRP_COMPFLAG)    | CV_COMP_MD_COMPFL_STATIC_OUTPUT, CV_BASE_MD_RCAIWEEK_S4_Output, CV_COMP_FIN_BUDGET_STATIC_OUTPUT | High: same table, similar projections/joins | Yes                 | TBL_WSS_SRP_COMPFLAG             | Yes       | High            | High       |
| MANDT-based filtering                           | Most views                                     | High: common filter on MANDT           | Yes                 | N/A                              | Yes       | Medium          | High       |
| Joins on PRCTR, STRNUM, ZWEEK                   | Reporting and composite views                   | Medium: join keys, but logic may differ | Yes (for join keys) | N/A                              | Partial   | Medium          | High       |

---

## 6. REDUNDANCY ANALYSIS

| Redundant Logic                   | SQLs Affected                                             | What Is Repeated                    | Potential Reduction      | Recommended Action                     | Confidence |
|-----------------------------------|----------------------------------------------------------|-------------------------------------|-------------------------|----------------------------------------|------------|
| Store attribute aggregation       | CV_COMP_MD_SRPACT_STATIC_OUTPUT, CV_BASE_MD_RCAIWEEK_S4_Output | Aggregation/projection from same table | Moderate                | Centralize/store as materialized view  | High       |
| Comp flag projection              | CV_COMP_MD_COMPFL_STATIC_OUTPUT, CV_BASE_MD_RCAIWEEK_S4_Output | Direct projection from same table   | Moderate                | Centralize/store as materialized view  | High       |
| MANDT filter logic                | All views                                                | Filter on MANDT                     | Low                     | Standardize as reusable filter macro   | Medium     |

---

## 7. REUSE RECOMMENDATIONS

| Common Logic                  | SQLs Using It                                  | Existing Object            | Existing Object Reusable? | Recommendation         | Recommended Object Type | Rationale                                                   | Confidence |
|-------------------------------|------------------------------------------------|----------------------------|--------------------------|------------------------|------------------------|-------------------------------------------------------------|------------|
| Store attribute static table  | CV_COMP_MD_SRPACT_STATIC_OUTPUT, CV_BASE_MD_RCAIWEEK_S4_Output, CV_COMP_FIN_BUDGET_STATIC_OUTPUT | TBL_WSS_SRP_ATTR_ACT       | Yes                     | Reuse                  | Table                  | Central ETL output, avoid reprocessing                       | High       |
| Comp flag static table        | CV_COMP_MD_COMPFL_STATIC_OUTPUT, CV_BASE_MD_RCAIWEEK_S4_Output, CV_COMP_FIN_BUDGET_STATIC_OUTPUT | TBL_WSS_SRP_COMPFLAG       | Yes                     | Reuse                  | Table                  | Central ETL output, avoid reprocessing                       | High       |
| Master data views             | CV_BASE_MD_CEPCT_S4_OUTPUT, CV_BASE_MD_HRRP_NODE_S4_Output | Physical tables            | Yes                     | Reuse                  | View                   | Simple, direct projections                                  | High       |

---

## 8. CONSOLIDATION RECOMMENDATIONS

### Consolidation Group: Static Composite Views

**SQLs involved:**
- CV_COMP_MD_SRPACT_STATIC_OUTPUT
- CV_COMP_MD_COMPFL_STATIC_OUTPUT

**Common logic:**
- Both use static tables populated by ETL
- Both provide master/static data for reporting

**Unique logic:**
- Different tables, different attributes

**What should be consolidated:**
- Centralize ETL and static table materialization

**What should remain separate:**
- Individual projections/aggregations

**Existing object that can be reused:**
- TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG

**New intermediate object required:**
- None

**Recommended object type:**
- Materialized View or Table

**Performance benefit:**
- Avoid repeated scans/aggregations

**Cost benefit:**
- Reduced compute for static data

**Maintainability benefit:**
- Clear separation of ETL and reporting

**Reason:**
- Both serve as static data sources for reporting

**Confidence:**
- High

---

**If a SQL should not be consolidated:**

- The final reporting view (CV_BASE_MD_RCAIWEEK_S4_Output) should not be merged with ETL or base views due to unique reporting logic and multi-source dependencies.
- ETL procedure (STP_WSS_SRP_ATTRIBUTES_OUTPUT) should remain independent as it implements a snapshot/refresh pattern.

---

## 9. INDEPENDENT SQL RECOMMENDATIONS

| SQL                              | Unique Logic                            | Reason for Independence                | Reusable Portion                      | Recommended Object Type | Confidence |
|----------------------------------|-----------------------------------------|----------------------------------------|---------------------------------------|------------------------|------------|
| STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt| ETL/snapshot population, procedure logic| Central ETL, distinct refresh pattern  | Populated tables                      | Procedure/Script       | High       |
| CV_BASE_MD_CEPCT_S4_OUTPUT.txt   | Cost element/profit center master data  | Simple master, used in joins           | Data projection                       | View                   | High       |
| CV_BASE_MD_HRRP_NODE_S4_Output.txt| HR hierarchy nodes                      | Simple master, used in joins           | Data projection                       | View                   | High       |
| CV_BASE_MD_RCAIWEEK_S4_Output.txt| Final reporting, multi-join, calculations| Unique final reporting requirements    | Upstream views/tables                 | View                   | High       |

---

## 10. PERFORMANCE AND COST OPTIMIZATION

| SQLs affected                                             | Current issue                        | Recommended approach                                | Expected benefit                  | Confidence |
|----------------------------------------------------------|--------------------------------------|-----------------------------------------------------|-----------------------------------|------------|
| All consumers of static tables (composite views, reporting views) | Repeated scans/joins on same static data | Materialize static tables, centralize ETL           | Reduced compute, faster queries   | High       |
| Reporting/composite views                                | Multiple joins, aggregations         | Early filtering, partitioning on key columns        | Pruned data scans, lower cost     | Medium     |
| All views with MANDT filter                              | Repeated filter logic                | Standardize as reusable macro/function              | Code maintainability              | Medium     |

---

## 11. DATA FRESHNESS AND REFRESH RECOMMENDATIONS

| SQL / Object                          | Required Freshness     | Recommended Refresh Approach        | Reason                                       | Confidence       |
|---------------------------------------|-----------------------|-------------------------------------|----------------------------------------------|------------------|
| TBL_WSS_SRP_ATTR_ACT                  | Snapshot/periodic     | ETL-driven, controlled refresh      | Populated by ETL, static for reporting period| High             |
| TBL_WSS_SRP_COMPFLAG                  | Snapshot/periodic     | ETL-driven, controlled refresh      | Populated by ETL, static for reporting period| High             |
| CV_COMP_MD_SRPACT_STATIC_OUTPUT       | Snapshot/periodic     | On ETL completion                   | Depends on ETL, static for period            | High             |
| CV_COMP_MD_COMPFL_STATIC_OUTPUT       | Snapshot/periodic     | On ETL completion                   | Depends on ETL, static for period            | High             |
| Reporting/other views                 | Requires validation   | Requires validation                 | Not enough info for SLA/refresh requirement  | Requires validation |

---

## 12. FINAL BIGQUERY ARCHITECTURE

### Layer 1 — Existing Source / Reusable Objects

- Physical tables: AZSRP_DS052_VT_S4, AZSRP_DS041_VT_S4, CEPCT, HRRP_NODE, TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG

### Layer 2 — Shared Intermediate Logic

- TBL_WSS_SRP_ATTR_ACT (populated by ETL)
- TBL_WSS_SRP_COMPFLAG (populated by ETL)

### Layer 3 — Consolidated Processing

- CV_COMP_MD_SRPACT_STATIC_OUTPUT (Materialized View/Table)
- CV_COMP_MD_COMPFL_STATIC_OUTPUT (Materialized View/Table)
- CV_COMP_FIN_BUDGET_STATIC_OUTPUT (View/Materialized View)

### Layer 4 — Independent Processing

- STP_WSS_SRP_ATTRIBUTES_OUTPUT (Procedure/Script)
- CV_BASE_MD_CEPCT_S4_OUTPUT (View)
- CV_BASE_MD_HRRP_NODE_S4_Output (View)

### Layer 5 — Reporting / Output

- CV_BASE_MD_RCAIWEEK_S4_Output (View)
- CV_COMP_FIN_BUDGET_STATIC_OUTPUT (View/Materialized View)

### Layer 6 — Snapshot / Physical Tables

- TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG (refreshed by ETL)

### Dependencies

- ETL procedure populates static tables
- Static tables feed composite views
- Composite views and base master data feed final reporting views

### Snapshot / Circular Dependencies

- Controlled snapshot dependency: ETL procedure deletes/inserts static tables, which are then used by composite and reporting views. This must be preserved to avoid direct dependency and maintain snapshot isolation.

---

# FINAL DECISION SUMMARY

- **Should all supplied SQLs be consolidated into one query?**
  - No.
- **If not, why should they not all be merged?**
  - ETL logic, static data population, and reporting logic are distinct, with different refresh and processing requirements. Merging would increase complexity, reduce maintainability, and break snapshot isolation.
- **Which SQLs should be consolidated?**
  - Only composite static views sharing the same ETL/intermediate logic.
- **Which SQLs should only be partially consolidated?**
  - Composite views can share common intermediate tables but retain separate projections/aggregations.
- **Which SQLs should remain independent?**
  - ETL procedure, base master data views, final reporting view.
- **What logic is duplicated?**
  - Store attribute and comp flag projection/aggregation; MANDT filters.
- **Which SQLs are duplicating that logic?**
  - Reporting and composite views.
- **Can the duplicated logic actually be reused?**
  - Yes, via materialized static tables.
- **What existing objects can already be reused?**
  - TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG.
- **What new reusable intermediate objects are required, if any?**
  - None; existing static tables suffice.
- **What object type should be used for each supplied SQL: View, Materialized View, or Physical Table?**
  - See recommendations above; use Views for reporting/master data, Materialized Views/Tables for static/intermediate ETL outputs.
- **Why is that object type appropriate?**
  - Views for live/parameterized reporting, materialized for static/snapshot data.
- **What redundancy can be removed?**
  - Centralize static data processing, standardize filters, avoid repeated aggregations.
- **What performance and cost optimizations are possible?**
  - Materialize static tables, early filtering, avoid unnecessary repeated joins.
- **What data freshness considerations apply?**
  - Static tables require controlled ETL refresh; reporting views require validation.
- **What is the recommended dependency and execution flow?**
  - ETL → Static Table → Composite View → Reporting View.
- **What architecture maximizes reuse without changing business logic?**
  - Centralized ETL, materialized static tables, views for reporting, clear separation of concerns.

---

## GITHUB OUTPUT

Uploading this recommendation to the specified GitHub repository.
