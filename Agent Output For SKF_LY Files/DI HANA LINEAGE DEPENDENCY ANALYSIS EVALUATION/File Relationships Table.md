| Source File | Target File | Relationship | Score | Reason |
|------------|-------------|--------------|-------|---------|
| CV_BASE_MD_SRPACT_S4 | STP_WSS_SRP_ATTRIBUTES | Source Dependency | 100 | Stored procedure explicitly reads from "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4" via SELECT statement to populate TBL_WSS_SRP_ATTR_ACT |
| CV_BASE_MD_COMPFL_S4 | STP_WSS_SRP_ATTRIBUTES | Source Dependency | 100 | Stored procedure explicitly reads from "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4" via SELECT statement to populate TBL_WSS_SRP_COMPFLAG |
| STP_WSS_SRP_ATTRIBUTES | CV_COMP_MD_SRPACT_STATIC | Logic Provider | 95 | Stored procedure populates TBL_WSS_SRP_ATTR_ACT which is the data source for CV_COMP_MD_SRPACT_STATIC as defined in XML datasource element |
| STP_WSS_SRP_ATTRIBUTES | CV_COMP_MD_COMPFL_STATIC | Logic Provider | 95 | Stored procedure populates TBL_WSS_SRP_COMPFLAG which is the data source for CV_COMP_MD_COMPFL_STATIC as defined in XML datasource element |
| CV_BASE_SKF_WEEKLY_ACTUAL_S4 | CV_COMP_SKF_ACTUAL_STATIC | Calculation View Dependency | 90 | Explicitly referenced in XML input node: /CVS_FRIP.Base.FI/calculationviews/CV_BASE_SKF_WEEKLY_ACTUAL_S4 |
| CV_COMP_MD_SRPACT_STATIC | CV_COMP_SKF_ACTUAL_STATIC | Calculation View Dependency | 90 | Explicitly referenced in XML input node: /CVS_FRIP.Composite.Master/calculationviews/CV_COMP_MD_SRPACT_STATIC |
| CV_BASE_MD_HRRP_NODE_S4 | CV_COMP_SKF_ACTUAL_STATIC | Calculation View Dependency | 90 | Explicitly referenced in XML input node: /CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_HRRP_NODE_S4 |
| CV_COMP_MD_COMPFL_STATIC | CV_COMP_SKF_ACTUAL_STATIC | Calculation View Dependency | 90 | Explicitly referenced in XML input node: /CVS_FRIP.Composite.Master/calculationviews/CV_COMP_MD_COMPFL_STATIC |
| CV_BASE_MD_RCALWEEK_S4 | CV_COMP_SKF_ACTUAL_STATIC | Calculation View Dependency | 90 | Explicitly referenced in XML input node: /CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_RCALWEEK_S4 |
| CV_BASE_MD_CEPCT_S4 | CV_COMP_SKF_ACTUAL_STATIC | Calculation View Dependency | 90 | Explicitly referenced in XML input node: /CVS_FRIP.Base.Text/calculationviews/CV_BASE_MD_CEPCT_S4 |