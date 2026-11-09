# File Relationships Table

| Source File | Target File | Dependency Type | Score | Reason |
|------------|-------------|-----------------|-------|---------|
| **CV_BASE_NAVIX** | **CV_COMP_FLASH_SALES** | Calculation View Dependency | 90 | Explicitly referenced in CV_COMP_FLASH_SALES XML as data source node: `/SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_NAVIX` |
| **CV_BASE_TLOGF (FS_SALES)** | **CV_COMP_FLASH_SALES** | Calculation View Dependency | 90 | Explicitly referenced in CV_COMP_FLASH_SALES XML as data source node: `/SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_TLOGF` for FS sales calculations |
| **CV_BASE_TLOGF (RX_SALES)** | **CV_COMP_FLASH_SALES** | Calculation View Dependency | 90 | Explicitly referenced in CV_COMP_FLASH_SALES XML as data source node: `/SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_TLOGF` for RX sales calculations |
| **CV_BASE_TLOGF (EMP_DISCOUNT)** | **CV_COMP_FLASH_SALES** | Calculation View Dependency | 90 | Explicitly referenced in CV_COMP_FLASH_SALES XML as data source node: `/SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_TLOGF` for employee discount calculations |
| **CV_BASE_TLOGF (EMP_DISCOUNTS)** | **CV_COMP_FLASH_SALES** | Calculation View Dependency | 90 | Explicitly referenced in CV_COMP_FLASH_SALES XML as data source node: `/SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_TLOGF` for employee discounts calculations |
| **CV_BASE_TLOGF (EMP_DISC_TYPES)** | **CV_COMP_FLASH_SALES** | Calculation View Dependency | 90 | Explicitly referenced in CV_COMP_FLASH_SALES XML as data source node: `/SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_TLOGF` for employee discount types calculations |
| **CV_BASE_TLOGF (FS_DISCOUNT)** | **CV_COMP_FLASH_SALES** | Calculation View Dependency | 90 | Explicitly referenced in CV_COMP_FLASH_SALES XML as data source node: `/SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_TLOGF` for FS discount calculations |
| **CV_BASE_TLOGF_X (SCRIPTS)** | **CV_COMP_FLASH_SALES** | Calculation View Dependency | 90 | Explicitly referenced in CV_COMP_FLASH_SALES XML as data source node: `/SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_TLOGF_X` for prescription scripts |
| **CV_BASE_PARAMETERS (FS_RETAIL_TYPES)** | **CV_COMP_FLASH_SALES** | Calculation View Dependency | 90 | Explicitly referenced in CV_COMP_FLASH_SALES XML as data source node: `/SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_PARAMETERS` for FS retail type filtering |
| **CV_BASE_PARAMETERS (RX_RETAIL_TYPES)** | **CV_COMP_FLASH_SALES** | Calculation View Dependency | 90 | Explicitly referenced in CV_COMP_FLASH_SALES XML as data source node: `/SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_PARAMETERS` for RX retail type filtering |
| **CV_BASE_PARAMETERS (RX_RETAIL_TYPES_COVID)** | **CV_COMP_FLASH_SALES** | Calculation View Dependency | 90 | Explicitly referenced in CV_COMP_FLASH_SALES XML as data source node: `/SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_PARAMETERS` for COVID retail type filtering |
| **CV_BASE_PARAMETERS (FS_DISCOUNT_TYPES)** | **CV_COMP_FLASH_SALES** | Calculation View Dependency | 90 | Explicitly referenced in CV_COMP_FLASH_SALES XML as data source node: `/SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_PARAMETERS` for discount type filtering |
| **CV_BASE_TLOGF_COVID** | **CV_COMP_FLASH_SALES** | Calculation View Dependency | 90 | Explicitly referenced in CV_COMP_FLASH_SALES XML as data source node: `/SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_TLOGF_COVID` for COVID sales data |
| **CV_COMP_FLASH_SALES** | **CV_COMP_FIN_FLASH** | Calculation View Dependency | 90 | CV_COMP_FIN_FLASH references CV_BASE_FIN_FLASH_SALES_CAR which is the CAR version of CV_COMP_FLASH_SALES |
| **CV_BASE_MD_RCALWEEK_S4** | **CV_COMP_FIN_FLASH** | Calculation View Dependency | 90 | Explicitly referenced in CV_COMP_FIN_FLASH XML as data source: `/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_RCALWEEK_S4` for calendar week master data |
| **CV_BASE_MD_COMPFL_S4** | **CV_COMP_FIN_FLASH** | Calculation View Dependency | 90 | Explicitly referenced in CV_COMP_FIN_FLASH XML as data source: `/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_COMPFL_S4` for comp flag master data |
| **CV_BASE_MD_HRRP_NODE_S4** | **CV_COMP_FIN_FLASH** | Calculation View Dependency | 90 | Explicitly referenced in CV_COMP_FIN_FLASH XML as data source: `/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_HRRP_NODE_S4` for hierarchy node master data |
| **CV_BASE_MD_SRPACT_S4** | **CV_COMP_FIN_FLASH** | Calculation View Dependency | 90 | Explicitly referenced in CV_COMP_FIN_FLASH XML as data source: `/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_SRPACT_S4` for store activity master data (referenced twice) |
| **CV_BASE_MD_CEPCT_S4** | **CV_COMP_FIN_FLASH** | Calculation View Dependency | 90 | Explicitly referenced in CV_COMP_FIN_FLASH XML as data source: `/CVS_FRIP.Base.Text/calculationviews/CV_BASE_MD_CEPCT_S4` for profit center text |
| **CV_COMP_FIN_FLASH** | **STP_WSS_FLASH_SALES** | Stored Procedure Dependency | 95 | Explicitly referenced in stored procedure SQL: `FROM "_SYS_BIC"."CVS_FRIP.Composite.FI/CV_COMP_FIN_FLASH"` with placeholders for week ending and timestamp parameters |
| **STP_WSS_FLASH_SALES** | **TBL_WSS_FLASH_SALES** | Logic Provider | 95 | Stored procedure explicitly populates table: `INSERT INTO "CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_FLASH_SALES"` - This is an ETL target table, not a lineage endpoint |
| **TBL_WSS_FLASH_SALES** | **CV_COMP_FIN_FLASH_STATIC** | Source Dependency | 90 | CV_COMP_FIN_FLASH_STATIC reads from static table: `CVS_FRIP.Table::TBL_WSS_FLASH_SALES` as its data source |
| **CV_BASE_TLOGF (FS_SALES)** | **CV_BASE_FS_SALES_TLOGF** | Direct Dependency | 90 | CV_BASE_FS_SALES_TLOGF is a wrapper/alias for CV_BASE_TLOGF filtered for FS sales |
| **CV_BASE_TLOGF_X (SCRIPTS)** | **CV_BASE_SCRIPTS_TLOGF_X** | Direct Dependency | 90 | CV_BASE_SCRIPTS_TLOGF_X is a wrapper/alias for CV_BASE_TLOGF_X filtered for scripts |
| **CV_BASE_PARAMETERS** | **CV_BASE_PARAMETERS_FS_RETAIL_TYPE** | Direct Dependency | 90 | CV_BASE_PARAMETERS_FS_RETAIL_TYPE filters CV_BASE_PARAMETERS for FS retail types |
| **CV_BASE_PARAMETERS** | **CV_BASE_PARAMETERS_FS_DISCOUNT_TYPES** | Direct Dependency | 90 | CV_BASE_PARAMETERS_FS_DISCOUNT_TYPES filters CV_BASE_PARAMETERS for discount types |
| **CV_BASE_PARAMETERS** | **CV_BASE_PARAMETERS_FS_RETAIL_TYPES** | Direct Dependency | 90 | CV_BASE_PARAMETERS_FS_RETAIL_TYPES filters CV_BASE_PARAMETERS for FS retail types |
| **CV_BASE_PARAMETERS** | **CV_BASE_PARAMETERS_RX_RETAIL_TYPES** | Direct Dependency | 90 | CV_BASE_PARAMETERS_RX_RETAIL_TYPES filters CV_BASE_PARAMETERS for RX retail types |
| **CV_BASE_PARAMETERS** | **CV_BASE_PARAMETERS_RX_RETAIL_TYPES_COVID** | Direct Dependency | 90 | CV_BASE_PARAMETERS_RX_RETAIL_TYPES_COVID filters CV_BASE_PARAMETERS for COVID RX retail types |
| **CV_BASE_TLOGF (Multiple)** | **CV_COMP_FLASH_SALES** | Calculation View Dependency | 90 | Multiple TLOGF views provide calculated fields: CAL_FS_UNITS, CAL_RX_CNT_GE84_NS, CAL_RX_CNT_GE84_RE, CAL_RX_CNT_NS, CAL_RX_CNT_RE, EMP_REDUCTIONAMOUNT, CVD_AMOUNT, CAL_CVD_UNITS |
| **CV_BASE_TLOGF_X** | **CV_COMP_FLASH_SALES** | Calculation View Dependency | 90 | Provides calculated fields: CAL_SCRIPTS_90AS3 |
| **CV_COMP_FLASH_SALES** | **CV_COMP_FIN_FLASH** | Calculation View Dependency | 90 | Provides aggregated sales metrics: FS_SALESAMOUNT, RX_SALESAMOUNT, REDUCTIONAMOUNT, and all calculated fields |
| **CV_COMP_FIN_FLASH** | **STP_WSS_FLASH_SALES** | Stored Procedure Dependency | 95 | Provides all final calculated and aggregated fields to stored procedure for snapshot creation |
| **STP_WSS_FLASH_SALES** | **CV_COMP_FIN_FLASH** | Stored Procedure Dependency | 95 | Passes parameters: $$IP_WEEK_ENDING_TO$$, $$IP_WEEK_ENDING_FROM$$, $$IP_UPD_TIMESTAMP_FROM$$, $$IP_UPD_TIMESTAMP_TO$$ |
| **CV_COMP_FIN_FLASH** | **CV_BASE_FIN_FLASH_SALES_CAR** | Calculation View Dependency | 90 | Filters data using parameters: IP_WEEK_ENDING_FROM, IP_WEEK_ENDING_TO, IP_UPD_TIMESTAMP_FROM, IP_UPD_TIMESTAMP_TO |
| **CV_BASE_MD_RCALWEEK_S4** | **CV_COMP_FIN_FLASH** | Calculation View Dependency | 90 | Provides calendar week dimensions: ZZWEEK, ZRYEAR, ZRPERIOD, ZRYRP, ZRWENDDATE, ZRWSTRTDATE, CAL_WEEK_NUMBER |
| **CV_BASE_MD_COMPFL_S4** | **CV_COMP_FIN_FLASH** | Calculation View Dependency | 90 | Provides comp flag: CAL_COMP_FLAG, FS_COMP_WK, RX_COMP_WK |
| **CV_BASE_MD_HRRP_NODE_S4** | **CV_COMP_FIN_FLASH** | Calculation View Dependency | 90 | Provides organizational hierarchy: DIVISION_CODE, DIVISION_DESC, REGION_CODE, REGION_DESC, DISTRICT_CODE, DISTRICT_DESC, AREA_CODE, AREA_DESC |
| **CV_BASE_MD_SRPACT_S4** | **CV_COMP_FIN_FLASH** | Calculation View Dependency | 90 | Provides store activity dates: FS_OPEN_DAT, RX_OPEN_DAT (joined twice for FS and RX separately) |
| **CV_BASE_MD_CEPCT_S4** | **CV_COMP_FIN_FLASH** | Calculation View Dependency | 90 | Provides profit center text: PROFIT_CENTER_TEXT |
| **CV_BASE_TLOGF (Multiple)** | **CV_COMP_FLASH_SALES** | Calculation View Dependency | 90 | Provides update timestamps: FS_UPD_TIMESTAMP, ZZ_UPD_TIMESTAMP |
| **CV_BASE_TLOGF_X** | **CV_COMP_FLASH_SALES** | Calculation View Dependency | 90 | Provides update timestamp: SCRIPTS_UPD_TIMESTAMP |
| **CV_COMP_FLASH_SALES** | **CV_COMP_FIN_FLASH** | Calculation View Dependency | 90 | Passes all update timestamps for filtering and tracking |
| **CV_COMP_FIN_FLASH** | **STP_WSS_FLASH_SALES** | Stored Procedure Dependency | 95 | Uses ZZ_UPD_TIMESTAMP for filtering data within specified time ranges |
