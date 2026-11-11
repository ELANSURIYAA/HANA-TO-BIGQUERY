# File Relationships Table

| Source File | Target File | Dependency Type | Score | Reason |
|---|---|---|---|---|
| xml_acc_FLASH_SALES_VT_CAR | xml_acc_cv_comp_fin_flash | Calculation View Dependency | 90 | xml_acc_cv_comp_fin_flash explicitly references the path `/CVS_FRIP.Base.FI/calculationviews/CV_BASE_FIN_FLASH_SALES_CAR` as a data source node, which corresponds to the CAR base view artifact xml_acc_FLASH_SALES_VT_CAR |
| xml_acc_cv_base_MD_RCALWEEK_S4 | xml_acc_cv_comp_fin_flash | Calculation View Dependency | 90 | xml_acc_cv_comp_fin_flash explicitly references the path `/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_RCALWEEK_S4` as a data source node, directly matching the artifact xml_acc_cv_base_MD_RCALWEEK_S4 |
| xml_acc_cv_comp_fin_flash | STP_WSS_FLASH_SALES | Stored Procedure Dependency | 95 | STP_WSS_FLASH_SALES explicitly queries `_SYS_BIC."CVS_FRIP.Composite.FI/CV_COMP_FIN_FLASH"` via INSERT-SELECT with input parameters, confirming xml_acc_cv_comp_fin_flash is the direct source for the stored procedure |
| STP_WSS_FLASH_SALES | xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales | Stored Procedure Dependency | 95 | STP_WSS_FLASH_SALES performs DELETE + INSERT INTO `CVS_FRIP.Table::TBL_WSS_FLASH_SALES`; xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales explicitly reads from `CVS_FRIP.Table::TBL_WSS_FLASH_SALES` as its sole data source node, confirming the stored procedure populates the table consumed by this static view |
