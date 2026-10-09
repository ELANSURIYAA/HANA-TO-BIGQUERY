# File Relationships Table

| Source File | Target File | Dependency Type | Score | Reason |
|------------|------------|-----------------|--------|---------|
| CV_BASE_MD_SRPACT_S4 | STP_WSS_SRP_ATTRIBUTES | Source Dependency | 100 | Stored procedure explicitly reads from "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4" in INSERT statement |
| CV_BASE_MD_COMPFL_S4 | STP_WSS_SRP_ATTRIBUTES | Source Dependency | 100 | Stored procedure explicitly reads from "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4" in INSERT statement with WHERE ZWEEK = :V_WEEK |
| STP_WSS_SRP_ATTRIBUTES | CV_COMP_MD_SRPACT_STATIC | Stored Procedure Dependency | 95 | Stored procedure populates TBL_WSS_SRP_ATTR_ACT which is the data source for CV_COMP_MD_SRPACT_STATIC (dataSource="CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT") |
| STP_WSS_SRP_ATTRIBUTES | CV_COMP_MD_COMPFL_STATIC | Stored Procedure Dependency | 95 | Stored procedure populates TBL_WSS_SRP_COMPFLAG which is the data source for CV_COMP_MD_COMPFL_STATIC (dataSource="CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG") |
| CV_BASE_FIN_WEEKLY_ACTUAL_S4 | CV_COMP_FIN_ACTUAL_STATIC | Calculation View Dependency | 90 | CV_COMP_FIN_ACTUAL_STATIC explicitly references /CVS_FRIP.Base.FI/calculationviews/CV_BASE_FIN_WEEKLY_ACTUAL_S4 in its input node |
| CV_COMP_MD_SRPACT_STATIC | CV_COMP_FIN_ACTUAL_STATIC | Calculation View Dependency | 90 | CV_COMP_FIN_ACTUAL_STATIC explicitly references /CVS_FRIP.Composite.Master/calculationviews/CV_COMP_MD_SRPACT_STATIC in its input node |
| GL_HEIR.CV_BASE_MD_HRRP_NODE_S4 | CV_COMP_FIN_ACTUAL_STATIC | Calculation View Dependency | 90 | CV_COMP_FIN_ACTUAL_STATIC explicitly references /CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_HRRP_NODE_S4 (GL hierarchy) in its input node |
| PC_HEIR.CV_BASE_MD_HRRP_NODE_S4 | CV_COMP_FIN_ACTUAL_STATIC | Calculation View Dependency | 90 | CV_COMP_FIN_ACTUAL_STATIC explicitly references /CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_HRRP_NODE_S4 (PC hierarchy) in its input node |
| CV_BASE_MD_RCALWEEL_S4 | CV_COMP_FIN_ACTUAL_STATIC | Calculation View Dependency | 90 | CV_COMP_FIN_ACTUAL_STATIC explicitly references /CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_RCALWEEK_S4 in its input node |
| CV_COMP_MD_COMPFL_STATIC | CV_COMP_FIN_ACTUAL_STATIC | Calculation View Dependency | 90 | CV_COMP_FIN_ACTUAL_STATIC explicitly references /CVS_FRIP.Composite.Master/calculationviews/CV_COMP_MD_COMPFL_STATIC in its input node |
| CV_BASE_MD_CEPCT_S4 | CV_COMP_FIN_ACTUAL_STATIC | Calculation View Dependency | 90 | CV_COMP_FIN_ACTUAL_STATIC explicitly references /CVS_FRIP.Base.Text/calculationviews/CV_BASE_MD_CEPCT_S4 in its input node |
