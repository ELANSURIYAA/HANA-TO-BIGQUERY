# File Relationships Table

| Source File | Target File | Relationship Type | Score | Reason |
|------------|-------------|-------------------|-------|---------|
| **CV_BASE_FIN_WEEKLY_FORECAST_S4** | **CV_COMP_FIN_FORECAST** | Calculation View Dependency | 90 | Explicit XML reference in CV_COMP_FIN_FORECAST calculation view definition |
| **CV_BASE_MD_SRPACT_S4** | **CV_COMP_FIN_FORECAST** | Calculation View Dependency | 90 | Explicit XML reference for store activity master data |
| **CV_BASE_MD_COMPFL_S4** | **CV_COMP_FIN_FORECAST** | Calculation View Dependency | 90 | Explicit XML reference for comp flag master data |
| **CV_BASE_MD_RCALWEEK_S4** | **CV_COMP_FIN_FORECAST** | Calculation View Dependency | 90 | Explicit XML reference for calendar week master data |
| **CV_BASE_MD_CEPCT_S4** | **CV_COMP_FIN_FORECAST** | Calculation View Dependency | 90 | Explicit XML reference for profit center text |
| **CV_BASE_SKF_WEEKLY_FORECAST_S4** | **CV_COMP_SKF_FORECAST** | Calculation View Dependency | 90 | Explicit XML reference in CV_COMP_SKF_FORECAST calculation view definition |
| **CV_BASE_MD_SRPACT_S4** | **CV_COMP_SKF_FORECAST** | Calculation View Dependency | 90 | Explicit XML reference for store activity master data |
| **CV_BASE_MD_COMPFL_S4** | **CV_COMP_SKF_FORECAST** | Calculation View Dependency | 90 | Explicit XML reference for comp flag master data |
| **CV_BASE_MD_RCALWEEK_S4** | **CV_COMP_SKF_FORECAST** | Calculation View Dependency | 90 | Explicit XML reference for calendar week master data |
| **CV_BASE_MD_CEPCT_S4** | **CV_COMP_SKF_FORECAST** | Calculation View Dependency | 90 | Explicit XML reference for profit center text |
| **CV_BASE_FIN_BKPF_S4** | **CV_COMP_FIN_SBT** | Calculation View Dependency | 90 | Explicit XML reference for accounting document header |
| **CV_BASE_FIN_ACDOCA_S4** | **CV_COMP_FIN_SBT** | Calculation View Dependency | 90 | Explicit XML reference for financial accounting document |
| **CV_BASE_MD_SRPACT_S4** | **CV_COMP_FIN_SBT** | Calculation View Dependency | 90 | Explicit XML reference for store activity master data |
| **CV_BASE_MD_RCALWEEK_S4** | **CV_COMP_FIN_SBT** | Calculation View Dependency | 90 | Explicit XML reference for calendar week master data |
| **CV_BASE_MD_CEPCT_S4** | **CV_COMP_FIN_SBT** | Calculation View Dependency | 90 | Explicit XML reference for profit center text |
| **CV_BASE_FIN_ACDOCA_S4** | **CV_COMP_FIN_MANUAL_JE** | Calculation View Dependency | 90 | Explicit XML reference for financial accounting document |
| **CV_BASE_MD_SRPACT_S4** | **CV_COMP_FIN_MANUAL_JE** | Calculation View Dependency | 90 | Explicit XML reference for store activity master data |
| **CV_BASE_MD_HRRP_NODE_S4** | **CV_COMP_FIN_MANUAL_JE** | Calculation View Dependency | 90 | Explicit XML reference for hierarchy node master data |
| **CV_BASE_FIN_BKPF_S4** | **CV_COMP_FIN_MANUAL_JE** | Calculation View Dependency | 90 | Explicit XML reference for accounting document header |
| **GL_HEIR.CV_BASE_MD_HRRP_NODE_S4** | **CV_COMP_FIN_MANUAL_JE** | Calculation View Dependency | 90 | Explicit XML reference for GL hierarchy |
| **PC_HEIR.CV_BASE_MD_HRRP_NODE_S4** | **CV_COMP_FIN_MANUAL_JE** | Calculation View Dependency | 90 | Explicit XML reference for profit center hierarchy |
| **PROD_CLASS_HEIR.CV_BASE_MD_HRRP_NODE_S4** | **CV_COMP_FIN_MANUAL_JE** | Calculation View Dependency | 90 | Explicit XML reference for product class hierarchy |
| **CV_BASE_MD_COMPFL_S4** | **CV_COMP_FIN_MANUAL_JE** | Calculation View Dependency | 90 | Explicit XML reference for comp flag master data |
| **CV_BASE_MD_CEPCT_S4** | **CV_COMP_FIN_MANUAL_JE** | Calculation View Dependency | 90 | Explicit XML reference for profit center text |
| **CV_BASE_MD_RCALWEEK_S4** | **CV_COMP_FIN_MANUAL_JE** | Calculation View Dependency | 90 | Explicit XML reference for calendar week master data |
| **CV_BASE_SKF_FAGLSKF_PN_S4** | **CV_COMP_SKF_MANUAL_JE** | Calculation View Dependency | 90 | Explicit XML reference for SKF financial data |
| **CV_BASE_MD_SRPACT_S4** | **CV_COMP_SKF_MANUAL_JE** | Calculation View Dependency | 90 | Explicit XML reference for store activity master data |
| **CV_BASE_MD_HRRP_NODE_S4** | **CV_COMP_SKF_MANUAL_JE** | Calculation View Dependency | 90 | Explicit XML reference for hierarchy node master data |
| **CV_BASE_MD_COMPFL_S4** | **CV_COMP_SKF_MANUAL_JE** | Calculation View Dependency | 90 | Explicit XML reference for comp flag master data |
| **CV_BASE_MD_RCALWEEK_S4** | **CV_COMP_SKF_MANUAL_JE** | Calculation View Dependency | 90 | Explicit XML reference for calendar week master data |
| **CV_BASE_MD_CEPCT_S4** | **CV_COMP_SKF_MANUAL_JE** | Calculation View Dependency | 90 | Explicit XML reference for profit center text |
| **CV_COMP_FIN_FORECAST** | **CV_COMP_FORECAST_MJE** | Calculation View Dependency | 90 | Explicit XML reference as data source in CV_COMP_FORECAST_MJE |
| **CV_COMP_SKF_FORECAST** | **CV_COMP_FORECAST_MJE** | Calculation View Dependency | 90 | Explicit XML reference as data source in CV_COMP_FORECAST_MJE |
| **CV_COMP_FIN_SBT** | **CV_COMP_FORECAST_MJE** | Calculation View Dependency | 90 | Explicit XML reference as data source in CV_COMP_FORECAST_MJE |
| **CV_COMP_FIN_MANUAL_JE** | **CV_COMP_FORECAST_MJE** | Calculation View Dependency | 90 | Explicit XML reference as data source in CV_COMP_FORECAST_MJE |
| **CV_COMP_SKF_MANUAL_JE** | **CV_COMP_FORECAST_MJE** | Calculation View Dependency | 90 | Explicit XML reference as data source in CV_COMP_FORECAST_MJE |
| **CV_COMP_FORECAST_MJE** | **STP_WSS_FORECAST_MJE** | Logic Provider | 100 | Explicit SQL reference: SELECT FROM "_SYS_BIC"."CVS_FRIP.Composite.FI/CV_COMP_FORECAST_MJE" |
| **STP_WSS_FORECAST_MJE** | **CV_COMP_FORECAST_MJE_STATIC** | Stored Procedure Dependency | 95 | Stored procedure explicitly populates TBL_WSS_FORECAST_MJE table via INSERT statement |
