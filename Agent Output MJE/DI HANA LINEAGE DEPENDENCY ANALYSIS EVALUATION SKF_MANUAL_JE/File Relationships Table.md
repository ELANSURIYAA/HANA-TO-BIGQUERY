# File Relationships Table

| Source File | Target File | Relationship Type | Score | Reason |
|-------------|-------------|-------------------|-------|--------|
| **CV_BASE_SKF_FAGLSKF_PN_S4** | **CV_COMP_SKF_MANUAL_JE** | Calculation View Dependency | 90 | Explicitly declared in XML dependencies section: `/CVS_FRIP.Base.FI/calculationviews/CV_BASE_SKF_FAGLSKF_PN_S4`. Provides financial ledger data (FAGLSKF) for manual journal entries. |
| **CV_BASE_MD_SRPACT_S4** | **CV_COMP_SKF_MANUAL_JE** | Calculation View Dependency | 90 | Explicitly declared in XML dependencies section: `/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_SRPACT_S4`. Provides SRP Activity master data. |
| **CV_BASE_MD_HRRP_NODE_S4** | **CV_COMP_SKF_MANUAL_JE** | Calculation View Dependency | 90 | Explicitly declared in XML dependencies section: `/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_HRRP_NODE_S4`. Provides HR Reporting Node hierarchy data with filter condition: `(match("PARNODE",'*CORERET*')) AND ("HRYVALTO" ='99991231')`. |
| **CV_BASE_MD_COMPFL_S4** | **CV_COMP_SKF_MANUAL_JE** | Calculation View Dependency | 90 | Explicitly declared in XML dependencies section: `/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_COMPFL_S4`. Provides Comparison Flag master data with filter: `("COMP_VER" = '$$IP_VERSION_COMP_FLAG$$')`. |
| **CV_BASE_MD_RCALWEEK_S4** | **CV_COMP_SKF_MANUAL_JE** | Calculation View Dependency | 90 | Explicitly declared in XML dependencies section: `/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_RCALWEEK_S4`. Provides Fiscal Calendar Week master data. |
| **CV_BASE_MD_CEPCT_S4** | **CV_COMP_SKF_MANUAL_JE** | Calculation View Dependency | 90 | Explicitly declared in XML dependencies section: `/CVS_FRIP.Base.Text/calculationviews/CV_BASE_MD_CEPCT_S4`. Provides Cost Element/Profit Center text descriptions. |
