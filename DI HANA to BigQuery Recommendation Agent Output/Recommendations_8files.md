# EXECUTIVE SUMMARY

- **Actual number of SQLs analyzed:** 8
- **All expected SQLs found:** No; only 8 out of 24
- **Should all SQLs be consolidated:** No; consolidation only recommended for specific groups with shared logic
- **Major reusable logic identified:** ETL pattern for static tables, union/aggregation for financial data, store attributes/comp flag handling
- **Major redundancy identified:** Overlapping ETL flows, repeated joins/filters, static table population
- **Major consolidation groups:** Financial budget aggregation, store attribute/comp flag ETL
- **SQLs that should remain independent:** Master data views, static projections
- **Existing objects that should be reused:** TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG, CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4
- **Major architectural recommendation:** Use materialized tables for ETL outputs, views for reporting/consolidation, avoid duplicating intermediate logic
- **Major View / Materialized View / Physical Table recommendations:** ETL output as physical tables, reporting as views/materialized views, master data as views
- **Important dependency patterns:** Physical → ETL → Static Table → Composite View → Reporting View
- **Snapshot/circular patterns:** ETL snapshot for store attributes/comp flags, must be preserved
- **Key performance and cost opportunities:** Eliminate repeated joins, materialize intermediate ETL results, reuse static tables
- **Overall recommendation confidence:** High for analyzed files; requires validation for missing files

---

# INPUT VALIDATION

| Validation Item           | Result           |
|---------------------------|------------------|
| Lineage provided          | Yes              |
| ZIP provided              | Yes              |
| Actual SQL file count     | 8                |
| Expected SQL count        | 24               |
| Missing files             | 16 (not present) |
| Unreadable files          | 0                |
| Successfully analyzed     | Yes (8 files)    |

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

# SQL INVENTORY

| SQL File                         | Main Purpose                          | Sources                              | Main Transformations                | Output                            | Upstream Dependencies              | Downstream Usage                   |
|-----------------------------------|---------------------------------------|--------------------------------------|-------------------------------------|------------------------------------|-------------------------------------|-------------------------------------|
| CV_BASE_FIN_WEEKLY_BUDGET_S4      | Aggregate weekly budget financials    | AZSRP_DS052_VT_S4, AZSRP_DS041_VT_S4 | UNION, aggregation, conditional sum | Aggregated financial dataset       | Physical tables                     | CV_BASE_MD_RCAIWEEK_S4             |
| CV_BASE_MD_CEPCT_S4               | Project cost element/profit center    | CEPCT                                | Filter, projection                  | Master data view                   | Physical table                      | CV_BASE_MD_RCAIWEEK_S4             |
| CV_BASE_MD_HRRP_NODE_S4           | HR hierarchy node master data         | HRRP_NODE                            | Filter, projection                  | Master data view                   | Physical table                      | CV_BASE_MD_RCAIWEEK_S4             |
| CV_BASE_MD_RCAIWEEK_S4            | Final weekly reporting                | Multiple calculation views           | Joins, calculated columns, flags    | Reporting view                     | Multiple views/tables               | Output/reporting layer             |
| CV_COMP_FIN_BUDGET_STATIC         | Composite budget static reporting     | CV_BASE_FIN_WEEKLY_BUDGET_S4         | Filters, joins                      | Static reporting view              | Calculation view                     | Output/reporting layer             |
| CV_COMP_MD_COMPFL_STATIC          | Composite comparison flag reporting   | TBL_WSS_SRP_COMPFLAG                 | Projection                          | Static master data view            | Physical table                       | CV_BASE_MD_RCAIWEEK_S4             |
| CV_COMP_MD_SRPACT_STATIC          | Composite store attributes reporting  | TBL_WSS_SRP_ATTR_ACT                 | Aggregation, projection             | Static master data view            | Physical table                       | CV_BASE_MD_RCAIWEEK_S4             |
| STP_WSS_SRP_ATTRIBUTES            | ETL for store attributes/comp flags   | CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4 | Delete, insert, snapshot          | Populate static tables             | Calculation views                     | CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC |

---

# OBJECT TYPE RECOMMENDATION

| SQL File                       | Recommended Object         | View / Materialized View / Physical Table | Data Freshness        | Reuse Level         | Rationale                                                   | Confidence |
|-------------------------------|----------------------------|------------------------------------------|----------------------|---------------------|-------------------------------------------------------------|------------|
| CV_BASE_FIN_WEEKLY_BUDGET_S4   | Aggregated Financial View  | Materialized View                        | Scheduled refresh    | High                | Large aggregation, reused downstream, performance critical   | High       |
| CV_BASE_MD_CEPCT_S4            | Cost Element Master        | View                                     | Near real-time       | Moderate            | Simple filter/projection, low transformation                 | High       |
| CV_BASE_MD_HRRP_NODE_S4        | HR Hierarchy Master        | View                                     | Near real-time       | Moderate            | Simple filter/projection, low transformation                 | High       |
| CV_BASE_MD_RCAIWEEK_S4         | Final Reporting View       | View                                     | Near real-time       | High                | Integrates multiple sources, complex joins/calculations      | High       |
| CV_COMP_FIN_BUDGET_STATIC      | Composite Static View      | Materialized View                        | Scheduled refresh    | Moderate            | Static snapshot logic, reused in reporting                   | High       |
| CV_COMP_MD_COMPFL_STATIC       | Comp Flag Static View      | Materialized View                        | Scheduled refresh    | Moderate            | Static snapshot logic, reused in reporting                   | High       |
| CV_COMP_MD_SRPACT_STATIC       | Store Attribute Static View| Materialized View                        | Scheduled refresh    | Moderate            | Static snapshot logic, reused in reporting                   | High       |
| STP_WSS_SRP_ATTRIBUTES         | ETL Procedure Output       | Physical Table                           | Batch/snapshot       | High                | ETL pattern, must persist intermediate results               | High       |

---

# COMMON LOGIC ANALYSIS

| Common Logic              | SQLs Using It                       | Actual Similarity | Business Logic Match | Existing Object Reusable? | Reuse Potential | Confidence |
|--------------------------|--------------------------------------|-------------------|----------------------|--------------------------|-----------------|------------|
| ETL static table pattern  | STP_WSS_SRP_ATTRIBUTES, CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC | High              | Yes                  | Yes (physical tables)    | High            | High       |
| Financial aggregation     | CV_BASE_FIN_WEEKLY_BUDGET_S4, CV_COMP_FIN_BUDGET_STATIC                   | Moderate          | Partial               | Yes (aggregation view)   | Moderate         | High       |
| Store attribute join      | CV_BASE_MD_RCAIWEEK_S4, CV_COMP_MD_SRPACT_STATIC                          | Moderate          | Partial               | Yes (static table/view)  | Moderate         | High       |
| Comparison flag join      | CV_BASE_MD_RCAIWEEK_S4, CV_COMP_MD_COMPFL_STATIC                          | Moderate          | Partial               | Yes (static table/view)  | Moderate         | High       |

---

# REDUNDANCY ANALYSIS

| Redundant Logic           | SQLs Affected                        | What Is Repeated             | Potential Reduction     | Recommended Action            | Confidence |
|--------------------------|--------------------------------------|------------------------------|------------------------|-------------------------------|------------|
| ETL snapshot population   | STP_WSS_SRP_ATTRIBUTES, static views | Delete/insert logic          | Shared ETL output      | Materialize intermediate table | High       |
| Joins to static tables    | Reporting views, static views        | Store attribute/comp flag join| Single materialized view| Reuse materialized static view | High       |
| Aggregation of financials | Financial views, composite views     | Group by/aggregation         | Single aggregation view| Materialize aggregation view   | High       |

---

# REUSE RECOMMENDATIONS

| Common Logic              | SQLs Using It                       | Existing Object      | Existing Object Reusable? | Recommendation           | Recommended Object Type | Rationale                                         | Confidence |
|--------------------------|--------------------------------------|----------------------|--------------------------|--------------------------|------------------------|---------------------------------------------------|------------|
| ETL static table output   | STP_WSS_SRP_ATTRIBUTES, static views | TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG | Yes                     | Reuse as intermediate   | Physical Table          | Centralized ETL, avoids repeated population        | High       |
| Financial aggregation     | CV_BASE_FIN_WEEKLY_BUDGET_S4, composite views | Aggregation view     | Yes                     | Reuse aggregation view   | Materialized View      | Avoid repeated aggregation, improve performance    | High       |

---

# CONSOLIDATION RECOMMENDATIONS

**Consolidation Group: Financial Aggregation**
- SQLs involved: CV_BASE_FIN_WEEKLY_BUDGET_S4, CV_COMP_FIN_BUDGET_STATIC
- Common logic: Aggregation of weekly budget financials
- Unique logic: Filtering, joins for static reporting
- What should be consolidated: Aggregation logic
- What should remain separate: Reporting/filters
- Existing object that can be reused: Aggregation view
- New intermediate object required: None
- Recommended object type: Materialized View
- Performance benefit: Reduced repeated aggregation
- Cost benefit: Lower compute for reporting
- Maintainability benefit: Centralized logic
- Reason: Shared aggregation, unique reporting requirements
- Confidence: High

**Consolidation Group: ETL Static Table**
- SQLs involved: STP_WSS_SRP_ATTRIBUTES, CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC
- Common logic: ETL delete/insert, snapshot population
- Unique logic: Projection/aggregation for reporting
- What should be consolidated: ETL population
- What should remain separate: Reporting views
- Existing object that can be reused: Physical tables
- New intermediate object required: None
- Recommended object type: Physical Table, Materialized View
- Performance benefit: Avoid repeated ETL
- Cost benefit: Lower compute for reporting
- Maintainability benefit: Centralized ETL
- Reason: Shared population, unique reporting requirements
- Confidence: High

---

# INDEPENDENT SQL RECOMMENDATIONS

| SQL                                | Unique Logic                    | Reason for Independence                | Reusable Portion           | Recommended Object Type | Confidence |
|------------------------------------|---------------------------------|----------------------------------------|----------------------------|------------------------|------------|
| CV_BASE_MD_CEPCT_S4                | Cost element/profit center      | Unique master data, simple filter      | None                      | View                   | High       |
| CV_BASE_MD_HRRP_NODE_S4            | HR hierarchy node               | Unique master data, simple filter      | None                      | View                   | High       |

---

# PERFORMANCE AND COST OPTIMIZATION

| SQLs affected                     | Current issue                   | Recommended approach                   | Expected benefit           | Confidence |
|-----------------------------------|---------------------------------|----------------------------------------|----------------------------|------------|
| Reporting views, static views     | Repeated joins                  | Materialize static tables/views        | Lower compute, faster query| High       |
| ETL procedures                    | Repeated delete/insert          | Centralize ETL, materialize output     | Lower compute, faster refresh| High    |
| Financial aggregation             | Repeated group by/aggregation   | Materialize aggregation view           | Lower compute, faster reporting| High  |

---

# DATA FRESHNESS AND REFRESH RECOMMENDATIONS

| SQL / Object                      | Required Freshness              | Recommended Refresh Approach           | Reason                     | Confidence |
|-----------------------------------|---------------------------------|----------------------------------------|----------------------------|------------|
| Physical ETL tables               | Batch/snapshot                  | Scheduled ETL job                      | Snapshot pattern           | High       |
| Materialized aggregation views    | Scheduled refresh               | Scheduled materialization              | Performance, reporting     | High       |
| Master data views                 | Near real-time                  | On-demand view query                   | Low transformation         | High       |
| Reporting view                    | Near real-time                  | On-demand view query                   | Integrates current data    | High       |

---

# FINAL BIGQUERY ARCHITECTURE

**Layer 1 — Existing Source / Reusable Objects**
- Physical tables: AZSRP_DS052_VT_S4, AZSRP_DS041_VT_S4, CEPCT, HRRP_NODE, TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG

**Layer 2 — Shared Intermediate Logic**
- ETL output: TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG (materialized via STP_WSS_SRP_ATTRIBUTES)
- Aggregation: CV_BASE_FIN_WEEKLY_BUDGET_S4 (materialized view)

**Layer 3 — Consolidated Processing**
- Materialized views: CV_COMP_FIN_BUDGET_STATIC, CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC

**Layer 4 — Independent Processing**
- Views: CV_BASE_MD_CEPCT_S4, CV_BASE_MD_HRRP_NODE_S4

**Layer 5 — Reporting / Output**
- Final reporting view: CV_BASE_MD_RCAIWEEK_S4

**Layer 6 — Snapshot / Physical Tables**
- ETL snapshot tables: TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG

**Dependencies**
- Physical tables → ETL → Static tables → Composite views → Reporting view

**Snapshot / Circular Dependencies**
- ETL snapshot pattern (delete/insert) for store attributes and comparison flags must be preserved; do not convert to direct dependency

---

# FINAL DECISION SUMMARY

- **Should all 24 SQLs be consolidated into one query?** No, only specific groups with shared logic should be consolidated.
- **Why should they not all be merged?** Unique business logic, reporting requirements, maintainability, performance, and cost considerations.
- **Which SQLs should be consolidated?** Financial aggregation, ETL static table population.
- **Which SQLs should only be partially consolidated?** Composite and reporting views using shared intermediate logic.
- **Which should remain independent?** Master data views (cost element, HR hierarchy).
- **What logic is duplicated?** ETL population, aggregation, joins to static tables.
- **Which SQLs are duplicating that logic?** STP_WSS_SRP_ATTRIBUTES, composite views, reporting views.
- **Can the duplicated logic actually be reused?** Yes, via materialized intermediate tables/views.
- **What existing objects can already be reused?** TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG, aggregation views.
- **What new reusable objects are justified?** None for analyzed files; materialize existing aggregation and ETL outputs.
- **What object type should be used for each SQL: View, Materialized View, or Physical Table?** See object type recommendation table above.
- **Why is that object type appropriate?** Based on transformation complexity, reuse, freshness, performance, cost, and dependency analysis.
- **What redundancy can be removed?** Repeated ETL population, repeated aggregation, repeated joins.
- **What performance and cost optimizations are possible?** Materialize intermediate results, centralize ETL, reuse static tables/views.
- **What data freshness considerations apply?** Preserve ETL snapshot, schedule refresh for materialized views, use views for master data.
- **What is the recommended dependency and execution flow?** Physical tables → ETL → Static tables → Composite views → Reporting view.
- **What architecture maximizes reuse without changing business logic?** Materialize ETL and aggregation outputs, use views for reporting/master data, preserve snapshot patterns.

---

## GITHUB OUTPUT

BigQuery Recommendations and Consolidation Analysis for 8 files.