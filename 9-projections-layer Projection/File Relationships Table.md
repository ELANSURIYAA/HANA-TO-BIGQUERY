# File Relationships Table

| Source File | Target File | Dependency Type | Score | Reason |
|------------|------------|-----------------|--------|---------|
| CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK | 9-projections-layer.xml | Calculation View Dependency | 90 | Explicitly referenced in XML as data source in variableMapping section with multiple input parameter mappings (IP_WEEK_ENDING_FROM, IP_WEEK_ENDING_TO) |
| CV_COMP_FIN_FLASH_STATIC | 9-projections-layer.xml | Calculation View Dependency | 90 | Explicitly referenced in XML as input node at path /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_FIN_FLASH_STATIC with multiple column mappings |
| CV_COMP_FIN_BUDGET_STATIC | 9-projections-layer.xml | Calculation View Dependency | 90 | Explicitly referenced in XML as input node at path /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_FIN_BUDGET_STATIC with multiple column mappings |
| CV_COMP_SKF_BUDGET_STATIC | 9-projections-layer.xml | Calculation View Dependency | 90 | Explicitly referenced in XML as input node at path /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_SKF_BUDGET_STATIC with multiple column mappings |
| CV_COMP_FORECAST_MJE_STATIC | 9-projections-layer.xml | Calculation View Dependency | 90 | Explicitly referenced in XML as input node at path /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_FORECAST_MJE_STATIC with multiple column mappings |
| CV_COMP_FIN_ACTUAL_STATIC | 9-projections-layer.xml | Calculation View Dependency | 90 | Explicitly referenced in XML as input node at path /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_FIN_ACTUAL_STATIC with multiple column mappings |
| CV_COMP_SKF_ACTUAL_STATIC | 9-projections-layer.xml | Calculation View Dependency | 90 | Explicitly referenced in XML as input node at path /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_SKF_ACTUAL_STATIC with multiple column mappings |
| CV_COMP_TOPSIDE_ADJUSTMENTS | 9-projections-layer.xml | Calculation View Dependency | 90 | Explicitly referenced in XML as input node at path /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_TOPSIDE_ADJUSTMENTS with multiple column mappings (referenced twice in the view) |
