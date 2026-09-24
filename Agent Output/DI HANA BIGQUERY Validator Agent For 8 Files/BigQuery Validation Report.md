# Overall Validation Summary

| Metric | Result |
|---|---|
| Completeness Score | 86% |
| Accuracy Score | 84% |
| Efficiency Score | 92% |
| Overall Status | PASS WITH WARNINGS |

# Completeness Assessment

| Severity | File | Issue | Recommendation |
|---|---|---|---|
| WARN | CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | References `PROJECT.DATASET.CV_BASE_MD_RCALWEEK_S4`, but the supplied comparable file is `CV_BASE_MD_RCAIWEEK_S4_Output.txt`. A directly matching referenced object name is not available in the supplied input. | Align the referenced object name with the supplied base weekly calendar object if they are intended to represent the same source. |
| WARN | STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt | References `PROJECT.DATASET.CV_BASE_MD_SRPACT_S4`, but no supplied SQL file for `CV_BASE_MD_SRPACT_S4` is available for validation. | Provide the referenced `CV_BASE_MD_SRPACT_S4` SQL artifact if validation against that dependency is required. |
| WARN | STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt | References `PROJECT.DATASET.CV_BASE_MD_COMPFL_S4`, but no supplied SQL file for `CV_BASE_MD_COMPFL_S4` is available for validation. | Provide the referenced `CV_BASE_MD_COMPFL_S4` SQL artifact if validation against that dependency is required. |
| WARN | CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Uses column `_B631_S_AMOUNT_NEGATIVE` in `FLAGS`, but that column is not directly defined in the visible upstream supplied SQL objects in this input set. | Add or expose the direct definition path for `_B631_S_AMOUNT_NEGATIVE` if this column is expected to be validated from supplied files. |
| INFO | Both Files | Data types are not available in supplied input for direct cross-file validation. | Not available in supplied input |

# Accuracy Assessment

| Severity | File | Issue | Recommendation |
|---|---|---|---|
| WARN | CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | Object reference inconsistency observed: `CV_BASE_MD_RCALWEEK_S4` is referenced, while the supplied comparable file name is `CV_BASE_MD_RCAIWEEK_S4_Output.txt`. | Verify and standardize the object naming if both are intended to represent the same calendar-week source. |
| WARN | STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt | Source object naming differs from supplied comparable file set: references `CV_BASE_MD_COMPFL_S4`, while supplied implementation file is `CV_COMP_MD_COMPFL_STATIC_OUTPUT.txt`. The supplied files do not establish them as equivalent. | Confirm whether these are different objects or rename consistently where equivalence is intended. |
| WARN | STP_WSS_SRP_ATTRIBUTES_OUTPUT.txt | Source object naming differs from supplied comparable file set: references `CV_BASE_MD_SRPACT_S4`, while supplied implementation file is `CV_COMP_MD_SRPACT_STATIC_OUTPUT.txt`. The supplied files do not establish them as equivalent. | Confirm whether these are different objects or rename consistently where equivalence is intended. |
| WARN | CV_COMP_FIN_BUDGET_STATIC_OUTPUT.txt | The query projects `_B631_S_AMOUNT_NEGATIVE`, but the supplied upstream weekly budget file exposes `_B631_S_AMOUNT` and does not directly expose `_B631_S_AMOUNT_NEGATIVE`. | Verify the column mapping and ensure the projected measure name matches the supplied upstream definition where applicable. |
| INFO | Both Files | No directly comparable explicit data type definitions were supplied. | Not available in supplied input |

# Efficiency Assessment

| Severity | File | Issue | Recommendation |
|---|---|---|---|
| INFO | Both Files | No significant efficiency issues identified. | Maintain the current level of duplication control unless additional supplied files establish redundant definitions. |
