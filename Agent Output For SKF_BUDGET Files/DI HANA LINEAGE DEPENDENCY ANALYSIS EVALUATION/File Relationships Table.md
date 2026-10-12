# File Relationships Table

| Source File | Target File | Relationship | Score | Reason |
|------------|------------|--------------|-------|---------|
| CV_BASE_SKF_WEEKLY_BUDGET_S4 | CV_COMP_SKF_BUDGET_STATIC | Calculation View Dependency | 90 | Explicit XML reference found in CV_COMP_SKF_BUDGET_STATIC: `/CVS_FRIP.Base.FI/calculationviews/CV_BASE_SKF_WEEKLY_BUDGET_S4` |
| CV_BASE_MD_HRRP_NODE_S4 | CV_COMP_SKF_BUDGET_STATIC | Calculation View Dependency | 90 | Explicit XML reference found in CV_COMP_SKF_BUDGET_STATIC: `/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_HRRP_NODE_S4` |
| CV_BASE_MD_RCALWEEK_S4 | CV_COMP_SKF_BUDGET_STATIC | Calculation View Dependency | 90 | Explicit XML reference found in CV_COMP_SKF_BUDGET_STATIC: `/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_RCALWEEK_S4` |
| CV_BASE_MD_CEPCT_S4 | CV_COMP_SKF_BUDGET_STATIC | Calculation View Dependency | 90 | Explicit XML reference found in CV_COMP_SKF_BUDGET_STATIC: `/CVS_FRIP.Base.Text/calculationviews/CV_BASE_MD_CEPCT_S4` |
| CV_BASE_MD_SRPACT_S4 | STP_WSS_SRP_ATTRIBUTES | Source Dependency | 100 | Explicit SQL reference in stored procedure: `FROM "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4"` - Source for TBL_WSS_SRP_ATTR_ACT population |
| CV_BASE_MD_COMPFL_S4 | STP_WSS_SRP_ATTRIBUTES | Source Dependency | 100 | Explicit SQL reference in stored procedure: `FROM "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4"` - Source for TBL_WSS_SRP_COMPFLAG population |
| STP_WSS_SRP_ATTRIBUTES | CV_COMP_MD_SRPACT_STATIC | Logic Provider | 95 | Stored procedure populates TBL_WSS_SRP_ATTR_ACT which is consumed by CV_COMP_MD_SRPACT_STATIC. XML reference: `CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT` |
| STP_WSS_SRP_ATTRIBUTES | CV_COMP_MD_COMPFL_STATIC | Logic Provider | 95 | Stored procedure populates TBL_WSS_SRP_COMPFLAG which is consumed by CV_COMP_MD_COMPFL_STATIC. XML reference: `CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG` |
| CV_COMP_MD_SRPACT_STATIC | CV_COMP_SKF_BUDGET_STATIC | Calculation View Dependency | 90 | Explicit XML reference found in CV_COMP_SKF_BUDGET_STATIC: `/CVS_FRIP.Composite.Master/calculationviews/CV_COMP_MD_SRPACT_STATIC` |
| CV_COMP_MD_COMPFL_STATIC | CV_COMP_SKF_BUDGET_STATIC | Calculation View Dependency | 90 | Explicit XML reference found in CV_COMP_SKF_BUDGET_STATIC: `/CVS_FRIP.Composite.Master/calculationviews/CV_COMP_MD_COMPFL_STATIC` |