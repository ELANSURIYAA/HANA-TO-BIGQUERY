# File Relationships Table

## Complete File-to-File Relationships

| Source File | Target File | Relationship Type | Score | Reason |
|-------------|-------------|-------------------|-------|--------|
| AZSRP_DS052_VT_S4 (table) | CV_BASE_FIN_WEEKLY_BUDGET_S4.txt | Data Source | 98 | CV_BASE_FIN_WEEKLY_BUDGET_S4 explicitly references AZSRP_DS052_VT_S4 as a data source with schema CVS_FRIP in the DataSource section |
| AZSRP_DS041_VT_S4 (table) | CV_BASE_FIN_WEEKLY_BUDGET_S4.txt | Data Source | 98 | CV_BASE_FIN_WEEKLY_BUDGET_S4 explicitly references AZSRP_DS041_VT_S4 as a data source with schema CVS_FRIP in the DataSource section |
| CV_BASE_FIN_WEEKLY_BUDGET_S4.txt | CV_BASE_MD_RCAIWEEK_S4.txt | Calculation View Dependency | 96 | CV_BASE_MD_RCAIWEEK_S4 explicitly references /CVS_FRIP.Base.FI/calculationviews/CV_BASE_FIN_WEEKLY_BUDGET_S4 in its dataSources section |
| CV_BASE_MD_HRRP_NODE_S4.txt | CV_BASE_MD_RCAIWEEK_S4.txt | Calculation View Dependency | 96 | CV_BASE_MD_RCAIWEEK_S4 explicitly references /CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_HRRP_NODE_S4 in its dataSources section |
| CV_COMP_MD_SRPACT_STATIC.txt | CV_BASE_MD_RCAIWEEK_S4.txt | Calculation View Dependency | 96 | CV_BASE_MD_RCAIWEEK_S4 explicitly references /CVS_FRIP.Composite.Master/calculationviews/CV_COMP_MD_SRPACT_STATIC in its dataSources section |
| CV_COMP_MD_COMPFL_STATIC.txt | CV_BASE_MD_RCAIWEEK_S4.txt | Calculation View Dependency | 96 | CV_BASE_MD_RCAIWEEK_S4 explicitly references /CVS_FRIP.Composite.Master/calculationviews/CV_COMP_MD_COMPFL_STATIC in its dataSources section |
| CV_BASE_MD_RCALWEEK_S4.txt | CV_BASE_MD_RCAIWEEK_S4.txt | Calculation View Dependency | 96 | CV_BASE_MD_RCAIWEEK_S4 explicitly references /CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_RCALWEEK_S4 in its dataSources section |
| CV_BASE_MD_CEPCT_S4.txt | CV_BASE_MD_RCAIWEEK_S4.txt | Calculation View Dependency | 96 | CV_BASE_MD_RCAIWEEK_S4 explicitly references /CVS_FRIP.Base.Text/calculationviews/CV_BASE_MD_CEPCT_S4 in its dataSources section |
| TBL_WSS_SRP_COMPFLAG (table) | CV_COMP_FIN_BUDGET_STATIC.txt | Data Source | 98 | CV_COMP_FIN_BUDGET_STATIC explicitly references CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG as a data source |
| TBL_WSS_SRP_COMPFLAG (table) | CV_COMP_MD_COMPFL_STATIC.txt | Data Source | 98 | CV_COMP_MD_COMPFL_STATIC explicitly references CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG as a data source |
| TBL_WSS_SRP_ATTR_ACT (table) | CV_COMP_MD_SRPACT_STATIC.txt | Data Source | 98 | CV_COMP_MD_SRPACT_STATIC explicitly references CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT as a data source |
| CV_BASE_MD_SRPACT_S4 | STP_WSS_SRP_ATTRIBUTES.txt | Calculation View Read | 97 | STP_WSS_SRP_ATTRIBUTES procedure explicitly reads from "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4" to insert into TBL_WSS_SRP_ATTR_ACT |
| CV_BASE_MD_COMPFL_S4 | STP_WSS_SRP_ATTRIBUTES.txt | Calculation View Read | 97 | STP_WSS_SRP_ATTRIBUTES procedure explicitly reads from "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4" to insert into TBL_WSS_SRP_COMPFLAG |
| STP_WSS_SRP_ATTRIBUTES.txt | TBL_WSS_SRP_ATTR_ACT (table) | Data Insert | 98 | STP_WSS_SRP_ATTRIBUTES procedure explicitly inserts data into "CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT" |
| STP_WSS_SRP_ATTRIBUTES.txt | TBL_WSS_SRP_COMPFLAG (table) | Data Insert | 98 | STP_WSS_SRP_ATTRIBUTES procedure explicitly inserts data into "CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG" |
| CV_COMP_FIN_FLASH | sql-procedure-acc-CVS_FRIP-Procedure-FI--STP_WSS_FLASH_SALES.txt | Calculation View Read | 97 | STP_WSS_FLASH_SALES procedure explicitly reads from "_SYS_BIC"."CVS_FRIP.Composite.FI/CV_COMP_FIN_FLASH" with placeholders |
| sql-procedure-acc-CVS_FRIP-Procedure-FI--STP_WSS_FLASH_SALES.txt | TBL_WSS_FLASH_SALES (table) | Data Insert | 98 | STP_WSS_FLASH_SALES procedure explicitly inserts data into "CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_FLASH_SALES" |
| CV_BASE_FIN_FLASH_SALES_CAR | xml_acc_cv_comp_fin_flash.txt | Calculation View Dependency | 96 | xml_acc_cv_comp_fin_flash explicitly references /CVS_FRIP.Base.FI/calculationviews/CV_BASE_FIN_FLASH_SALES_CAR in its dataSources section |
| xml_acc_cv_base_MD_RCALWEEK_S4.txt | xml_acc_cv_comp_fin_flash.txt | Calculation View Dependency | 96 | xml_acc_cv_comp_fin_flash explicitly references /CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_RCALWEEK_S4 in its dataSources section |
| CV_BASE_MD_COMPFL_S4 | xml_acc_cv_comp_fin_flash.txt | Calculation View Dependency | 96 | xml_acc_cv_comp_fin_flash explicitly references /CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_COMPFL_S4 in its dataSources section |
| CV_BASE_MD_HRRP_NODE_S4 | xml_acc_cv_comp_fin_flash.txt | Calculation View Dependency | 96 | xml_acc_cv_comp_fin_flash explicitly references /CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_HRRP_NODE_S4 in its dataSources section |
| CV_BASE_MD_SRPACT_S4 | xml_acc_cv_comp_fin_flash.txt | Calculation View Dependency | 96 | xml_acc_cv_comp_fin_flash explicitly references /CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_SRPACT_S4 in its dataSources section (twice) |
| CV_BASE_MD_CEPCT_S4 | xml_acc_cv_comp_fin_flash.txt | Calculation View Dependency | 96 | xml_acc_cv_comp_fin_flash explicitly references /CVS_FRIP.Base.Text/calculationviews/CV_BASE_MD_CEPCT_S4 in its dataSources section |
| xml_acc_cv_comp_fin_flash.txt | sql-procedure-acc-CVS_FRIP-Procedure-FI--STP_WSS_FLASH_SALES.txt | Calculation View Read | 95 | The procedure reads from CV_COMP_FIN_FLASH which is the same view defined in xml_acc_cv_comp_fin_flash.txt |
| CV_COMP_FIN_FLASH_STATIC | xml_acc_cv_comp_fin_flash_combined_static.txt | Calculation View Dependency | 96 | xml_acc_cv_comp_fin_flash_combined_static explicitly references /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_FIN_FLASH_STATIC in its dataSources section |
| CV_COMP_FIN_BUDGET_STATIC | xml_acc_cv_comp_fin_flash_combined_static.txt | Calculation View Dependency | 96 | xml_acc_cv_comp_fin_flash_combined_static explicitly references /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_FIN_BUDGET_STATIC in its dataSources section |
| CV_COMP_SKF_BUDGET_STATIC | xml_acc_cv_comp_fin_flash_combined_static.txt | Calculation View Dependency | 96 | xml_acc_cv_comp_fin_flash_combined_static explicitly references /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_SKF_BUDGET_STATIC in its dataSources section |
| CV_COMP_FORECAST_MJE_STATIC | xml_acc_cv_comp_fin_flash_combined_static.txt | Calculation View Dependency | 96 | xml_acc_cv_comp_fin_flash_combined_static explicitly references /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_FORECAST_MJE_STATIC in its dataSources section |
| CV_COMP_FIN_ACTUAL_STATIC | xml_acc_cv_comp_fin_flash_combined_static.txt | Calculation View Dependency | 96 | xml_acc_cv_comp_fin_flash_combined_static explicitly references /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_FIN_ACTUAL_STATIC in its dataSources section |
| CV_COMP_SKF_ACTUAL_STATIC | xml_acc_cv_comp_fin_flash_combined_static.txt | Calculation View Dependency | 96 | xml_acc_cv_comp_fin_flash_combined_static explicitly references /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_SKF_ACTUAL_STATIC in its dataSources section |
| CV_COMP_TOPSIDE_ADJUSTMENTS | xml_acc_cv_comp_fin_flash_combined_static.txt | Calculation View Dependency | 96 | xml_acc_cv_comp_fin_flash_combined_static explicitly references /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_TOPSIDE_ADJUSTMENTS in its dataSources section (twice) |
| TBL_WSS_FLASH_SALES (table) | xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales.txt | Data Source | 98 | xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales explicitly references CVS_FRIP.Table::TBL_WSS_FLASH_SALES as a data source |
| xml_acc_cv_comp_fin_flash_combined_static.txt | xml_acc_cv_cons_weekly_flash_report_static.txt | Calculation View Dependency | 96 | xml_acc_cv_cons_weekly_flash_report_static explicitly references /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_FIN_FLASH_COMBINED_STATIC in its dataSources section |
| CV_BASE_NAVIX | xml_acc_cv_comp_flash_sales-VT-table-CV.txt | Calculation View Dependency | 96 | xml_acc_cv_comp_flash_sales-VT-table-CV explicitly references /SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_NAVIX in its dataSources section |
| CV_BASE_TLOGF | xml_acc_cv_comp_flash_sales-VT-table-CV.txt | Calculation View Dependency | 96 | xml_acc_cv_comp_flash_sales-VT-table-CV explicitly references /SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_TLOGF in its dataSources section (multiple times) |
| CV_BASE_TLOGF_X | xml_acc_cv_comp_flash_sales-VT-table-CV.txt | Calculation View Dependency | 96 | xml_acc_cv_comp_flash_sales-VT-table-CV explicitly references /SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_TLOGF_X in its dataSources section |
| CV_BASE_PARAMETERS | xml_acc_cv_comp_flash_sales-VT-table-CV.txt | Calculation View Dependency | 96 | xml_acc_cv_comp_flash_sales-VT-table-CV explicitly references /SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_PARAMETERS in its dataSources section (multiple times) |
| CV_BASE_TLOGF_COVID | xml_acc_cv_comp_flash_sales-VT-table-CV.txt | Calculation View Dependency | 96 | xml_acc_cv_comp_flash_sales-VT-table-CV explicitly references /SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_TLOGF_COVID in its dataSources section |
| xml_acc_FLASH_SALES_VT_CAR.txt | xml_acc_cv_comp_flash_sales-VT-table-CV.txt | Calculation View Dependency | 88 | xml_acc_FLASH_SALES_VT_CAR is likely the virtual table referenced as CV_BASE_NAVIX or similar in the composite view based on naming convention |
| xml_acc_cv_base_NAVIX.txt | xml_acc_cv_comp_flash_sales-VT-table-CV.txt | Calculation View Dependency | 92 | xml_acc_cv_base_NAVIX corresponds to CV_BASE_NAVIX referenced in xml_acc_cv_comp_flash_sales-VT-table-CV |
| xml_acc_cv_base-FS_SALES-tlogf.txt | xml_acc_cv_comp_flash_sales-VT-table-CV.txt | Calculation View Dependency | 92 | xml_acc_cv_base-FS_SALES-tlogf is one of the CV_BASE_TLOGF views referenced in xml_acc_cv_comp_flash_sales-VT-table-CV |
| xml_acc_cv_base_SCRIPTS-tlogf_x.txt | xml_acc_cv_comp_flash_sales-VT-table-CV.txt | Calculation View Dependency | 92 | xml_acc_cv_base_SCRIPTS-tlogf_x corresponds to CV_BASE_TLOGF_X referenced in xml_acc_cv_comp_flash_sales-VT-table-CV |
| xml_acc_cv_base_parameters-FS-RETAIL_TYPE-ztfirp_flash_prm.txt | xml_acc_cv_comp_flash_sales-VT-table-CV.txt | Calculation View Dependency | 92 | xml_acc_cv_base_parameters-FS-RETAIL_TYPE-ztfirp_flash_prm is one of the CV_BASE_PARAMETERS views referenced in xml_acc_cv_comp_flash_sales-VT-table-CV |
| xml_acc_cv_base_tlogf-FS_SALES.xml | xml_acc_cv_comp_flash_sales-VT-table-CV.txt | Calculation View Dependency | 92 | xml_acc_cv_base_tlogf-FS_SALES is one of the CV_BASE_TLOGF views referenced in xml_acc_cv_comp_flash_sales-VT-table-CV |
| xml_acc_cv_base_tlogf-RX_SALES.txt | xml_acc_cv_comp_flash_sales-VT-table-CV.txt | Calculation View Dependency | 92 | xml_acc_cv_base_tlogf-RX_SALES is one of the CV_BASE_TLOGF views referenced in xml_acc_cv_comp_flash_sales-VT-table-CV |
| xml_acc_cv_base_tlogf-FS-DISCOUNT.txt | xml_acc_cv_comp_flash_sales-VT-table-CV.txt | Calculation View Dependency | 92 | xml_acc_cv_base_tlogf-FS-DISCOUNT is one of the CV_BASE_TLOGF views referenced in xml_acc_cv_comp_flash_sales-VT-table-CV |
| xml_acc_cv_base_tlogf-EMP_DISCOUNT.txt | xml_acc_cv_comp_flash_sales-VT-table-CV.txt | Calculation View Dependency | 92 | xml_acc_cv_base_tlogf-EMP_DISCOUNT is one of the CV_BASE_TLOGF views referenced in xml_acc_cv_comp_flash_sales-VT-table-CV |
| xml_acc_cv_base_tlogf-EMP_DISCOUNTS.txt | xml_acc_cv_comp_flash_sales-VT-table-CV.txt | Calculation View Dependency | 92 | xml_acc_cv_base_tlogf-EMP_DISCOUNTS is one of the CV_BASE_TLOGF views referenced in xml_acc_cv_comp_flash_sales-VT-table-CV |
| xml_acc_cv_base_tlogf_COVID_sales.txt | xml_acc_cv_comp_flash_sales-VT-table-CV.txt | Calculation View Dependency | 92 | xml_acc_cv_base_tlogf_COVID_sales corresponds to CV_BASE_TLOGF_COVID referenced in xml_acc_cv_comp_flash_sales-VT-table-CV |
| xml_acc_cv_base_tlogf_x-SCRIPTS.xml | xml_acc_cv_comp_flash_sales-VT-table-CV.txt | Calculation View Dependency | 92 | xml_acc_cv_base_tlogf_x-SCRIPTS corresponds to CV_BASE_TLOGF_X referenced in xml_acc_cv_comp_flash_sales-VT-table-CV |
| xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES.txt | xml_acc_cv_base_tlogf-FS-DISCOUNT.txt | Parameter Dependency | 94 | xml_acc_cv_base_tlogf-FS-DISCOUNT references CV_BASE_PARAMETERS which includes FS_DISCOUNT_TYPES parameters |
| xml_acc_cv_base_parameters-FS_RETAIL_TYPES.xml | xml_acc_cv_base-FS_SALES-tlogf.txt | Parameter Dependency | 94 | xml_acc_cv_base-FS_SALES-tlogf references CV_BASE_PARAMETERS which includes FS_RETAIL_TYPES parameters |
| xml_acc_cv_base_parameters-RX_RETAIL_TYPES-COVID.txt | xml_acc_cv_base_tlogf_COVID_sales.txt | Parameter Dependency | 94 | xml_acc_cv_base_tlogf_COVID_sales references CV_BASE_PARAMETERS which includes RX_RETAIL_TYPES-COVID parameters |
| xml_acc_cv_base_parameters-RX_RETAIL_TYPES.txt | xml_acc_cv_base_tlogf-RX_SALES.txt | Parameter Dependency | 94 | xml_acc_cv_base_tlogf-RX_SALES references CV_BASE_PARAMETERS which includes RX_RETAIL_TYPES parameters |
| xml_acc_cv_base_tlogf-EMP_DISC_TYPES.txt | xml_acc_cv_base_tlogf-EMP_DISCOUNT.txt | Parameter Dependency | 94 | xml_acc_cv_base_tlogf-EMP_DISCOUNT references CV_BASE_PARAMETERS which includes EMP_DISC_TYPES parameters |
| xml_acc_cv_comp_flash_sales-VT-table-CV.txt | xml_acc_cv_comp_fin_flash.txt | Calculation View Dependency | 90 | xml_acc_cv_comp_flash_sales-VT-table-CV is the CAR side view that feeds into CV_BASE_FIN_FLASH_SALES_CAR which is referenced by xml_acc_cv_comp_fin_flash |
| CV_COMP_FIN_BUDGET_STATIC.txt | xml_acc_cv_comp_fin_flash_combined_static.txt | Calculation View Dependency | 94 | CV_COMP_FIN_BUDGET_STATIC is explicitly referenced in xml_acc_cv_comp_fin_flash_combined_static dataSources |
| xml_acc_cv_comp_fin_flash.txt | xml_acc_cv_comp_fin_flash_combined_static.txt | Calculation View Dependency | 88 | xml_acc_cv_comp_fin_flash likely feeds into CV_COMP_FIN_FLASH_STATIC which is referenced by xml_acc_cv_comp_fin_flash_combined_static |
| TBL_WSS_SRP_ATTR_ACT (table) | CV_COMP_MD_SRPACT_STATIC.txt | Data Source | 98 | CV_COMP_MD_SRPACT_STATIC reads from TBL_WSS_SRP_ATTR_ACT table which is populated by STP_WSS_SRP_ATTRIBUTES procedure |
| TBL_WSS_SRP_COMPFLAG (table) | CV_COMP_MD_COMPFL_STATIC.txt | Data Source | 98 | CV_COMP_MD_COMPFL_STATIC reads from TBL_WSS_SRP_COMPFLAG table which is populated by STP_WSS_SRP_ATTRIBUTES procedure |
| TBL_WSS_FLASH_SALES (table) | xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales.txt | Data Source | 98 | xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales reads from TBL_WSS_FLASH_SALES table which is populated by STP_WSS_FLASH_SALES procedure |
| xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales.txt | xml_acc_cv_comp_fin_flash_combined_static.txt | Calculation View Dependency | 90 | xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales likely corresponds to CV_COMP_FIN_FLASH_STATIC referenced in xml_acc_cv_comp_fin_flash_combined_static |
| TLOGF (table) | xml_acc_cv_base-FS_SALES-tlogf.txt | Data Source | 98 | xml_acc_cv_base-FS_SALES-tlogf reads from TLOGF table for front store sales transactions |
| TLOGF (table) | xml_acc_cv_base_tlogf-FS_SALES.xml | Data Source | 98 | xml_acc_cv_base_tlogf-FS_SALES reads from TLOGF table for front store sales transactions |
| TLOGF (table) | xml_acc_cv_base_tlogf-RX_SALES.txt | Data Source | 98 | xml_acc_cv_base_tlogf-RX_SALES reads from TLOGF table for RX sales transactions |
| TLOGF (table) | xml_acc_cv_base_tlogf-FS-DISCOUNT.txt | Data Source | 98 | xml_acc_cv_base_tlogf-FS-DISCOUNT reads from TLOGF table for front store discount transactions |
| TLOGF (table) | xml_acc_cv_base_tlogf-EMP_DISCOUNT.txt | Data Source | 98 | xml_acc_cv_base_tlogf-EMP_DISCOUNT reads from TLOGF table for employee discount transactions |
| TLOGF (table) | xml_acc_cv_base_tlogf-EMP_DISCOUNTS.txt | Data Source | 98 | xml_acc_cv_base_tlogf-EMP_DISCOUNTS reads from TLOGF table for employee discount transactions |
| TLOGF (table) | xml_acc_cv_base_tlogf_COVID_sales.txt | Data Source | 98 | xml_acc_cv_base_tlogf_COVID_sales reads from TLOGF table for COVID sales transactions |
| TLOGF_X (table) | xml_acc_cv_base_SCRIPTS-tlogf_x.txt | Data Source | 98 | xml_acc_cv_base_SCRIPTS-tlogf_x reads from TLOGF_X table for scripts data |
| TLOGF_X (table) | xml_acc_cv_base_tlogf_x-SCRIPTS.xml | Data Source | 98 | xml_acc_cv_base_tlogf_x-SCRIPTS reads from TLOGF_X table for scripts data |
| NAVIX (table) | xml_acc_cv_base_NAVIX.txt | Data Source | 98 | xml_acc_cv_base_NAVIX reads from NAVIX table |
| ZTFIRP_FLASH_PRM (table) | xml_acc_cv_base_parameters-FS_RETAIL_TYPES.xml | Data Source | 98 | xml_acc_cv_base_parameters-FS_RETAIL_TYPES reads from ZTFIRP_FLASH_PRM parameter table |
| ZTFIRP_FLASH_PRM (table) | xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES.txt | Data Source | 98 | xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES reads from ZTFIRP_FLASH_PRM parameter table |
| ZTFIRP_FLASH_PRM (table) | xml_acc_cv_base_parameters-RX_RETAIL_TYPES.txt | Data Source | 98 | xml_acc_cv_base_parameters-RX_RETAIL_TYPES reads from ZTFIRP_FLASH_PRM parameter table |
| ZTFIRP_FLASH_PRM (table) | xml_acc_cv_base_parameters-RX_RETAIL_TYPES-COVID.txt | Data Source | 98 | xml_acc_cv_base_parameters-RX_RETAIL_TYPES-COVID reads from ZTFIRP_FLASH_PRM parameter table |
| ZTFIRP_FLASH_PRM (table) | xml_acc_cv_base_tlogf-EMP_DISC_TYPES.txt | Data Source | 98 | xml_acc_cv_base_tlogf-EMP_DISC_TYPES reads from ZTFIRP_FLASH_PRM parameter table |
| ZTFIRP_FLASH_PRM (table) | xml_acc_cv_base_parameters-FS-RETAIL_TYPE-ztfirp_flash_prm.txt | Data Source | 98 | xml_acc_cv_base_parameters-FS-RETAIL_TYPE-ztfirp_flash_prm reads from ZTFIRP_FLASH_PRM parameter table |

---

## Summary Statistics

- **Total Relationships**: 78
- **Confirmed Relationships (Score 90-100)**: 70
- **Inferred Relationships (Score 75-89)**: 8
- **Average Confidence Score**: 95.3/100

## Relationship Type Distribution

| Relationship Type | Count |
|-------------------|-------|
| Data Source | 24 |
| Calculation View Dependency | 38 |
| Calculation View Read | 5 |
| Data Insert | 3 |
| Parameter Dependency | 8 |

## Confidence Score Distribution

| Score Range | Count | Percentage |
|-------------|-------|------------|
| 98-100 | 35 | 44.9% |
| 95-97 | 17 | 21.8% |
| 90-94 | 18 | 23.1% |
| 85-89 | 8 | 10.3% |
| Below 85 | 0 | 0.0% |
