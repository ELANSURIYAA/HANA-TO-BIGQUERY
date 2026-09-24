# BigQuery Migration Recommendations

## Summary
- Merging logic from `CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt` and `CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt` into a single Materialized View will reduce query cost and improve performance for recurring budget reporting workloads, as both share the same core aggregations and are consumed by downstream composite views (see File Relationships Table.md, relationships #1, #2, #5, #8).
- Static lookup views such as `CV_BASE_MD_CEPCT_S4_OUTPUT.txt`, `CV_BASE_MD_HRRP_NODE_S4_Output.txt`, and `CV_BASE_MD_RCAIWEEK_S4_Output.txt` should be retained as Standard Views for maintainability and low cost, as they are lightweight dimension tables (see File Relationships Table.md, relationships #3, #4, #12).
- The ETL logic within `STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt` should be implemented as a BigQuery Procedure, as it orchestrates batch operations and table refreshes, ensuring data freshness for dependent reporting views (`CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt`, `CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt`) (see File Relationships Table.md, relationships #14-19).
- Composite views (`CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt`, `CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt`) should be implemented as Materialized Views, as they aggregate and join large static tables, are referenced by multiple reporting layers, and benefit from pre-computation (see File Relationships Table.md, relationships #6, #7, #18, #19).
- The final store attribute aggregation (`STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt`) should remain as a Procedure, as it encapsulates multi-step ETL logic and batch table loads, optimizing both performance and maintenance (see File Relationships Table.md, relationships #16, #17).

## Recommendation Table
| Script Name                              | Recommended Deployment  | Justification |
|------------------------------------------|-------------------------|--------------|
| CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt  | Materialized View       | Core financial aggregation layer, used in downstream reporting (see File Relationships Table.md #1, #2, #8); high query cost, benefits from pre-computation. |
| CV_BASE_MD_CEPCT_S4_OUTPUT.txt           | Standard View           | Lightweight dimension/lookup, rarely changes, used for profit center text (see File Relationships Table.md #3, #13). |
| CV_BASE_MD_HRRP_NODE_S4_Output.txt       | Standard View           | Lightweight HR hierarchy lookup, used for filtering nodes (see File Relationships Table.md #4, #9). |
| CV_BASE_MD_RCAIWEEK_S4_Output.txt        | Standard View           | Lightweight calendar week lookup, used in time-based joins (see File Relationships Table.md #12). |
| CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt     | Merge with CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt as Materialized View | Shares core logic with CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt, merging reduces redundancy and cost (see File Relationships Table.md #5). |
| CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt      | Materialized View       | Aggregates static comparison flag data, referenced in reporting views, benefits from pre-computation (see File Relationships Table.md #6, #11, #19). |
| CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt      | Materialized View       | Aggregates static store attribute data, referenced in reporting views, benefits from pre-computation (see File Relationships Table.md #7, #10, #18). |
| STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt        | BigQuery Procedure      | Encapsulates ETL/batch logic, refreshes physical tables, enables downstream views (see File Relationships Table.md #14-17). |

## Individual vs Merged SQL Analysis
| Script Name | Individual SQL Usable | Merge Candidate | Combined SQL Recommended | Details |
|-------------|----------------------|-----------------|-------------------------|---------|
| CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt | Yes                 | Yes (with CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt) | Yes                    | Both perform core financial aggregations and are referenced together in reporting; merging as a Materialized View reduces cost and complexity. |
| CV_BASE_MD_CEPCT_S4_OUTPUT.txt          | Yes                 | No                      | No                      | Lookup table, best kept as a standalone Standard View for maintainability. |
| CV_BASE_MD_HRRP_NODE_S4_Output.txt      | Yes                 | No                      | No                      | Lookup table, best kept as a standalone Standard View for maintainability. |
| CV_BASE_MD_RCAIWEEK_S4_Output.txt       | Yes                 | No                      | No                      | Lookup table, best kept as a standalone Standard View for maintainability. |
| CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt    | No                  | Yes (with CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt) | Yes                    | Shares logic with base weekly budget view; merging eliminates duplication. |
| CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt     | Yes                 | No                      | No                      | Composite aggregation, best as a Materialized View for performance. |
| CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt     | Yes                 | No                      | No                      | Composite aggregation, best as a Materialized View for performance. |
| STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt       | Yes                 | No                      | No                      | ETL procedure, must remain as a procedure for orchestrating batch loads. |

## Migration Optimization Opportunities
- Merging `CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt` and `CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt` as a Materialized View will reduce query cost, improve data freshness, and simplify maintenance by eliminating redundant logic (File Relationships Table.md #1, #2, #5, #8).
- Retaining lookup views (`CV_BASE_MD_CEPCT_S4_OUTPUT.txt`, `CV_BASE_MD_HRRP_NODE_S4_Output.txt`, `CV_BASE_MD_RCAIWEEK_S4_Output.txt`) as Standard Views preserves maintainability and minimizes cost (File Relationships Table.md #3, #4, #12).
- Implementing composite views (`CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt`, `CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt`) as Materialized Views improves performance for downstream reporting and reduces resource consumption (File Relationships Table.md #6, #7, #10, #11, #18, #19).
- Keeping `STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt` as a BigQuery Procedure ensures scalable and maintainable ETL operations, supporting data freshness for all dependent reporting layers (File Relationships Table.md #14-17).
