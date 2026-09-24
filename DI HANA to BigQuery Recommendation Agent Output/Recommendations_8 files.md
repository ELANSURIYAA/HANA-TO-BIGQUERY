**Summary:**
- Merging CV_BASE_MD_CEPCT_S4, CV_BASE_MD_HRRP_NODE_S4, CV_COMP_MD_SRPACT_STATIC, and CV_COMP_MD_COMPFL_STATIC logic into CV_BASE_MD_RCAIWEEK_S4 as a Merged View will reduce query redundancy and improve reporting performance (see CV_BASE_MD_RCAIWEEK_S4_OUTPUT.txt, CV_BASE_MD_CEPCT_S4_OUTPUT.txt, CV_BASE_MD_HRRP_NODE_S4_Output.txt, CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt, CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt, File Relationships Table.md).
- Materializing CV_BASE_FIN_WEEKLY_BUDGET_S4 as a Materialized View will accelerate aggregations reused in reporting (see CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt, File Relationships Table.md).
- Retaining CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_CEPCT_S4, and CV_BASE_MD_HRRP_NODE_S4 as Standard Views maintains flexibility for master data that changes infrequently (see CV_BASE_MD_CEPCT_S4_OUTPUT.txt, CV_BASE_MD_HRRP_NODE_S4_Output.txt, CV_BASE_MD_RCAIWEEK_S4_Output.txt).
- Implementing STP_WSS_SRP_ATTRIBUTES as a BigQuery Procedure enables efficient ETL for static tables and supports refresh operations (see STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt, File Relationships Table.md).
- CV_COMP_FIN_BUDGET_STATIC and CV_COMP_MD_COMPFL_STATIC should be implemented as Physical Tables for static reporting and downstream view dependencies (see CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt, CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt, File Relationships Table.md).
- Merging is recommended for CV_COMP_MD_SRPACT_STATIC and CV_COMP_MD_COMPFL_STATIC if reporting always requires both, otherwise retain as individual views (see CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt, CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt, File Relationships Table.md).

| Script Name                        | Recommended Deployment | Justification |
|------------------------------------|-----------------------|--------------|
| CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt | Materialized View     | Aggregates large fact data from AZSRP_DS052_VT_S4 and AZSRP_DS041_VT_S4; used by CV_BASE_MD_RCAIWEEK_S4 for reporting; materialization reduces compute cost and improves refresh performance. (File Relationships Table.md, CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt) |
| CV_BASE_MD_CEPCT_S4_OUTPUT.txt     | Standard View         | Lightweight profit center/cost element lookup; changes infrequently; referenced by CV_BASE_MD_RCAIWEEK_S4 and can be joined as needed without materialization. (CV_BASE_MD_CEPCT_S4_OUTPUT.txt, File Relationships Table.md) |
| CV_BASE_MD_HRRP_NODE_S4_Output.txt | Standard View         | Hierarchy master data; rarely changes; referenced by CV_BASE_MD_RCAIWEEK_S4; standard view keeps maintenance low and allows for easy refresh. (CV_BASE_MD_HRRP_NODE_S4_Output.txt, File Relationships Table.md) |
| CV_BASE_MD_RCAIWEEK_S4_Output.txt  | Merged View           | Central reporting view integrating logic from multiple upstream sources (financials, HR, attributes, flags); merging logic reduces query complexity, improves maintainability, and enhances reporting performance. (CV_BASE_MD_RCAIWEEK_S4_Output.txt, File Relationships Table.md) |
| CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Physical Table        | Static budget snapshot; loaded via ETL, not expected to change frequently; supports fast reporting and downstream dependencies. (CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt, File Relationships Table.md) |
| CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt | Physical Table        | Static comparison flags; loaded by ETL; referenced by CV_BASE_MD_RCAIWEEK_S4; physical table reduces compute cost and accelerates queries. (CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt, File Relationships Table.md) |
| CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt | Merged View           | Store attributes; can be merged with CV_COMP_MD_COMPFL_STATIC if always queried together in reporting, otherwise retain as individual view; merging reduces redundancy. (CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt, File Relationships Table.md) |
| STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt  | BigQuery Procedure    | ETL logic for loading static tables (TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG); enables scheduled refresh and repeatable data loads. (STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt, File Relationships Table.md) |

| Script Name                        | Can Be Used Individually | Can Be Merged | Best Option (with Reason) |
|------------------------------------|-------------------------|---------------|--------------------------|
| CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt | Yes                    | No            | Materialized View for performance and cost efficiency (see File Relationships Table.md) |
| CV_BASE_MD_CEPCT_S4_OUTPUT.txt     | Yes                    | Yes (with RCAIWEEK) | Merged View if always joined in reporting (see File Relationships Table.md) |
| CV_BASE_MD_HRRP_NODE_S4_Output.txt | Yes                    | Yes (with RCAIWEEK) | Merged View if always joined in reporting (see File Relationships Table.md) |
| CV_BASE_MD_RCAIWEEK_S4_Output.txt  | No                     | Yes           | Merged View to consolidate all reporting logic (see File Relationships Table.md) |
| CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Yes                    | No            | Physical Table for static reporting (see File Relationships Table.md) |
| CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt | Yes                    | Yes (with SRPACT) | Merged View if reporting always needs both (see File Relationships Table.md) |
| CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt | Yes                    | Yes (with COMPFL) | Merged View if reporting always needs both (see File Relationships Table.md) |
| STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt  | No                     | No            | BigQuery Procedure for ETL (see File Relationships Table.md) |

---

**Migration Optimization Opportunities:**
- CV_BASE_FIN_WEEKLY_BUDGET_S4_OUTPUT.txt should be materialized to accelerate repeated aggregations and reduce on-demand compute cost.
- CV_BASE_MD_RCAIWEEK_S4_OUTPUT.txt should merge logic from CV_BASE_MD_CEPCT_S4_OUTPUT.txt, CV_BASE_MD_HRRP_NODE_S4_Output.txt, CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt, and CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt to reduce query complexity and improve reporting performance.
- CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt and CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt should be deployed as physical tables for static, infrequently changing data to optimize query speed.
- STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt should be implemented as a BigQuery Procedure to orchestrate ETL for static tables, supporting scheduled refresh and minimizing manual intervention.
- Merging CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt and CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt is recommended if reporting always requires both, otherwise retain as individual views for flexibility.

---

