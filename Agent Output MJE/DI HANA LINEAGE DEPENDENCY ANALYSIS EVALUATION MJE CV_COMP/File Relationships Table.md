# File Relationships Table

| Source File | Target File | Dependency Type | Score | Reason |
|------------|-------------|-----------------|-------|---------|
| SFN_PRIOR_WEEK_FIN_FORECAST_VERSION | CV_COMP_FORECAST_MJE | Calculation View Dependency | 90 | CV_COMP_FORECAST_MJE explicitly references CVS_FRIP.Composite.Master::SFN_PRIOR_WEEK_FIN_FORECAST_VERSION as a data source in its XML definition |
| SFN_PRIOR_FISCAL_WEEK | CV_COMP_FORECAST_MJE | Calculation View Dependency | 90 | CV_COMP_FORECAST_MJE explicitly references CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK as a data source (appears twice in XML definition) |
| SFN_PRIOR_WEEK_SKF_FORECAST_VERSION | CV_COMP_FORECAST_MJE | Calculation View Dependency | 90 | CV_COMP_FORECAST_MJE explicitly references CVS_FRIP.Composite.Master::SFN_PRIOR_WEEK_SKF_FORECAST_VERSION as a data source in its XML definition |
| CV_COMP_FIN_FORECAST | CV_COMP_FORECAST_MJE | Calculation View Dependency | 90 | CV_COMP_FORECAST_MJE explicitly references /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_FIN_FORECAST as a calculation view dependency in its XML structure |
| CV_COMP_SKF_FORECAST | CV_COMP_FORECAST_MJE | Calculation View Dependency | 90 | CV_COMP_FORECAST_MJE explicitly references /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_SKF_FORECAST as a calculation view dependency in its XML structure |
| CV_COMP_FIN_SBT | CV_COMP_FORECAST_MJE | Calculation View Dependency | 90 | CV_COMP_FORECAST_MJE explicitly references /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_FIN_SBT as a calculation view dependency in its XML structure |
| CV_COMP_FIN_MANUAL_JE | CV_COMP_FORECAST_MJE | Calculation View Dependency | 90 | CV_COMP_FORECAST_MJE explicitly references /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_FIN_MANUAL_JE as a calculation view dependency in its XML structure |
| CV_COMP_SKF_MANUAL_JE | CV_COMP_FORECAST_MJE | Calculation View Dependency | 90 | CV_COMP_FORECAST_MJE explicitly references /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_SKF_MANUAL_JE as a calculation view dependency in its XML structure |
