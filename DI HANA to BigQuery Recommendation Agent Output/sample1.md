| Script Name                       | Recommended Deployment | Justification |
|------------------------------------|-----------------------|--------------|
| CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt | Materialized View     | Aggregates high-volume financial data from two physical tables, performs complex logic and unions, and is consumed by multiple downstream views. Materialization will optimize query cost and performance for repeated reporting use. |
| CV_BASE_MD_CEPCT_S4_OUTPUT.txt     | Standard View         | Lightweight lookup for cost elements and profit center master data, rarely changes, minimal transformation, and is referenced in the reporting layer. No need for materialization. |
| CV_BASE_MD_HRRP_NODE_S4_Output.txt | Standard View         | Simple projection for HR hierarchy nodes, low data volume, and mainly used as a lookup. Retaining as a standard view ensures maintainability and flexibility. |
| CV_BASE_MD_RCAIWEEK_S4_Output.txt  | Merged View           | Central reporting view integrating 6 upstream sources. Merging logic from upstream composite and base views reduces query complexity and redundancy. Provides a single, optimized reporting layer. |
| CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Materialized View     | Composite view over static and master data with multiple joins and calculations. Used for budget reporting with static data sources. Materialization will significantly improve performance for repeated queries. |
| CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt | Materialized View     | Static comparison flag view sourced from a physical table. Used in multiple reporting scenarios. Materialization eliminates repeated computation and ensures data consistency. |
| CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt | Materialized View     | Static store attributes view built from a populated table. Materialization is optimal for repeated attribute lookups and reporting, improving performance and reducing resource consumption. |
| STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt  | BigQuery Procedure    | Implements ETL logic with DELETE-INSERT pattern, orchestrates data population for static tables, and is not suitable as a view. Should be retained as a procedure for maintainability and operational clarity. |

---

### SQL Usage/Merge Table

| Script Name                       | Individual SQL | Can Be Merged | Merge Recommendation |
|------------------------------------|---------------|---------------|----------------------|
| CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt | Yes           | Indirect (via reporting view) | Used individually, but logic is consumed/merged in reporting view (CV_BASE_MD_RCAIWEEK_S4) |
| CV_BASE_MD_CEPCT_S4_OUTPUT.txt     | Yes           | Indirect      | Used as a lookup, merged in reporting/reporting views |
| CV_BASE_MD_HRRP_NODE_S4_Output.txt | Yes           | Indirect      | Used as a lookup, merged in reporting/reporting views |
| CV_BASE_MD_RCAIWEEK_S4_Output.txt  | No            | Yes           | Should merge logic from upstream views for an optimized single reporting layer |
| CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Yes           | No            | Used as an individual materialized view |
| CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt | Yes           | No            | Used as an individual materialized view |
| CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt | Yes           | No            | Used as an individual materialized view |
| STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt  | No            | No            | Procedure orchestrates data loading, not suitable for merging with views |

---

### Summary of Migration Optimization Opportunities

- **Materializing high-cost, high-use views** (CV_BASE_FIN_WEEKLY_BUDGET_S4, CV_COMP_FIN_BUDGET_STATIC, CV_COMP_MD_COMPFL_STATIC, CV_COMP_MD_SRPACT_STATIC) will substantially reduce query cost and improve performance for reporting workloads.
- **Merging logic in the central reporting view (CV_BASE_MD_RCAIWEEK_S4)** reduces redundancy, simplifies maintenance, and provides a single, optimized access layer for downstream consumers.
- **Retaining simple master/lookup views as standard views** (CV_BASE_MD_CEPCT_S4, CV_BASE_MD_HRRP_NODE_S4) minimizes cost and maximizes flexibility for schema changes.
- **BigQuery Procedure (STP_WSS_SRP_ATTRIBUTES)** should be retained for ETL orchestration, ensuring data freshness and operational clarity for static tables consumed by materialized views.
- **No redundant or unnecessary views/tables identified**—all components serve clear, non-overlapping roles, and the lineage shows a well-structured, maintainable pipeline.
- **Refresh considerations:** Materialized views and static tables should be refreshed/loaded as per business needs (daily/weekly), orchestrated by the procedure for consistency.
- **Scalability:** The recommended deployment pattern supports horizontal scaling, as materialized/static views offload repeated computation from the query engine.

**Assumptions/Constraints:** All recommendations are based on explicit lineage and logic; external dependencies (e.g., calendar week, source ETL views) are assumed to be present and properly maintained. No unresolved relationships or ambiguous dependencies detected.
