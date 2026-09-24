| Script Name                        | Recommended Deployment | Justification |
|-------------------------------------|-----------------------|--------------|
| CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt | Materialized View     | Heavily used as an intermediate aggregation for financial reporting, combines large tables, and performs significant aggregation and union logic. Materializing improves performance for downstream queries (like CV_BASE_MD_RCAIWEEK_S4), reduces compute cost, and ensures data freshness can be managed via scheduled refreshes. |
| CV_BASE_MD_CEPCT_S4_OUTPUT.txt      | Standard View         | Simple projection of cost element/profit center master data, rarely changes, lightweight, and used for lookups. No need for materialization. |
| CV_BASE_MD_HRRP_NODE_S4_Output.txt  | Standard View         | Simple hierarchy node extraction with basic filtering, infrequently changing, used for lookups and joins. Low complexity and cost. |
| CV_BASE_MD_RCAIWEEK_S4_Output.txt   | Merged View           | Central reporting view that integrates multiple upstream sources (6 dependencies). Merging logic from related views (as per lineage) will reduce redundancy and improve maintainability. Should remain a logical view, but with merged/optimized logic. |
| CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt| Materialized View     | Aggregates static budget information from several sources, used in reporting, benefits from pre-computation, and is fed by materialized/intermediate tables. Improves cost and query speed for repeated access. |
| CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt | Physical Table        | Populated via ETL (STP_WSS_SRP_ATTRIBUTES), acts as a static lookup for comparison flags, data only changes on ETL refresh, best as a physical table for fast access and minimal recomputation. |
| CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt | Physical Table        | Populated via ETL (STP_WSS_SRP_ATTRIBUTES), used for static store attributes, optimal as a physical table for fast access and to decouple from upstream changes. |
| STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt   | BigQuery Procedure    | Orchestrates ETL (DELETE/INSERT) for static tables, encapsulates data refresh logic, and should remain a procedure for maintainability and operational control. |

**Summary of Migration Optimization Opportunities:**
- Materializing core aggregation layers (CV_BASE_FIN_WEEKLY_BUDGET_S4, CV_COMP_FIN_BUDGET_STATIC) will significantly reduce query costs and improve performance for reporting.
- Static master data and lookup tables (CV_COMP_MD_COMPFL_STATIC, CV_COMP_MD_SRPACT_STATIC) should be implemented as physical tables, refreshed by ETL, to decouple reporting from source system volatility.
- Lightweight master data (CV_BASE_MD_CEPCT_S4, CV_BASE_MD_HRRP_NODE_S4) should remain standard views for simplicity and maintainability.
- Central reporting views (CV_BASE_MD_RCAIWEEK_S4) should be merged where possible to reduce redundancy, with logic optimized for BigQuery.
- ETL orchestration should be encapsulated in BigQuery Procedures for auditability and operational ease.
- These recommendations collectively reduce complexity, optimize resource consumption, and provide a scalable, maintainable architecture tailored to BigQuery’s strengths.

**Individual SQL Analysis and Recommendations Table:**

| Script Name                        | Current Logic Summary | Data Freshness Needs | Dependencies (from Lineage) | Recommendation | Notes |
|-------------------------------------|----------------------|----------------------|-----------------------------|---------------|-------|
| CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt | Multi-source union and aggregation of financial data; parameterized by FC count | Needs to be refreshed in sync with source data updates (typically daily/weekly) | AZSRP_DS052_VT_S4, AZSRP_DS041_VT_S4 | Materialized View | Used as base for further aggregations, high compute cost if run ad hoc |
| CV_BASE_MD_CEPCT_S4_OUTPUT.txt      | Simple select from CEPCT master table | Infrequent changes; refresh with master data updates | AZSRP_CEPCT_VT_S4 | Standard View | Lightweight, no need for materialization |
| CV_BASE_MD_HRRP_NODE_S4_Output.txt  | Simple select with filter for hierarchy nodes | Infrequent changes; refresh with master data updates | AZSRP_HRRP_NODE_VT_S4 | Standard View | Used for hierarchy lookups in reporting |
| CV_BASE_MD_RCAIWEEK_S4_Output.txt   | Aggregates, joins, and merges multiple upstream views for reporting | Needs to be up-to-date for reporting cycles | CV_BASE_FIN_WEEKLY_BUDGET_S4, CV_BASE_MD_HRRP_NODE_S4, CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC, CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_CEPCT_S4 | Merged View | Central reporting view, merging reduces redundancy |
| CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt| Aggregates budget data for static reporting | Refreshed with ETL cycles | TBL_WSS_SRP_COMPFLAG, CV_BASE_FIN_WEEKLY_BUDGET_S4 | Materialized View | Performance critical for repeated reporting |
| CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt | Simple select from comp flag physical table | Refreshed with ETL | TBL_WSS_SRP_COMPFLAG | Physical Table | Fast lookup, decoupled from upstream volatility |
| CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt | Simple select from store attr physical table | Refreshed with ETL | TBL_WSS_SRP_ATTR_ACT | Physical Table | Fast lookup, decoupled from upstream volatility |
| STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt   | Multi-statement ETL (delete/insert) for static tables | Orchestrates periodic refresh | CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4 | BigQuery Procedure | Maintains static tables, centralizes logic |

**Deployment Recommendation Table:**

| Script Name                        | Recommended Deployment | Justification |
|-------------------------------------|-----------------------|--------------|
| CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt | Materialized View     | Used in multiple downstream aggregations, high query cost, materialization reduces cost and improves performance. |
| CV_BASE_MD_CEPCT_S4_OUTPUT.txt      | Standard View         | Lightweight, rarely changes, used for lookups. |
| CV_BASE_MD_HRRP_NODE_S4_Output.txt  | Standard View         | Lightweight, rarely changes, used for hierarchy joins. |
| CV_BASE_MD_RCAIWEEK_S4_Output.txt   | Merged View           | Integrates multiple sources, merging reduces complexity and improves maintainability. |
| CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt| Materialized View     | Static report, benefits from pre-computation, used repeatedly. |
| CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt | Physical Table        | Static lookup, populated via ETL, fastest as a table. |
| CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt | Physical Table        | Static lookup, populated via ETL, fastest as a table. |
| STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt   | BigQuery Procedure    | Encapsulates ETL logic for static tables, operationally sound. |
