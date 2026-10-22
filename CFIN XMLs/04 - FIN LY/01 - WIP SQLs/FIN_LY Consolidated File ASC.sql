-- =====================================================================
-- FULLY CONSOLIDATED BIGQUERY SQL FOR CV_COMP_FIN_ACTUAL_STATIC
-- =====================================================================
-- This SQL consolidates all upstream dependencies from the FIN_LY lineage
-- All intermediate views have been recursively expanded to physical tables
-- No view dependencies remain - this is a fully executable query
-- =====================================================================

WITH
-- =====================================================================
-- CTE 1: WEEKLY_SNAPSHOT_BASE
-- Source: CV_BASE_FIN_WEEKLY_ACTUAL_S4
-- Physical Table: AZSRP_DS072_VT_S4
-- Logic: Filter by MANDT IN ('110', '200'), aggregate measures
-- =====================================================================
WEEKLY_SNAPSHOT_BASE AS (
  SELECT
    FISCPER,
    FISCVARNT,
    _BIC_ZIO_SWEEK,
    FISCYEAR,
    FISCPER3,
    _B631_S_CHRTACCT,
    _B631_S_CO_AREA,
    _BIC_ZIO_CMPCD,
    _B631_S_PROFTCTR,
    _B631_S_COSTCNTR,
    _B631_S_FUNCAREA,
    _BIC_ZIO_VER,
    _BIC_ZIO_SAUDT,
    MANDT,
    RECORDMODE,
    _B631_S_GL_ACCT,
    _BIC_ZWWPC_PA1,
    _BIC_ZWWSC_PA1,
    CURRENCY,
    _B631_S_LEDGER,
    SUM(_B631_S_AMOUNT) AS _B631_S_AMOUNT,
    SUM(_BIC_ZIO_D1AMT) AS _BIC_ZIO_D1AMT,
    SUM(_BIC_ZIO_D2AMT) AS _BIC_ZIO_D2AMT,
    SUM(_BIC_ZIO_D3AMT) AS _BIC_ZIO_D3AMT,
    SUM(_BIC_ZIO_D4AMT) AS _BIC_ZIO_D4AMT,
    SUM(_BIC_ZIO_D5AMT) AS _BIC_ZIO_D5AMT,
    SUM(_BIC_ZIO_D6AMT) AS _BIC_ZIO_D6AMT,
    SUM(_BIC_ZIO_D7AMT) AS _BIC_ZIO_D7AMT
  FROM `PROJECT.DATASET.AZSRP_DS072_VT_S4`
  WHERE MANDT IN ('110', '200')
  GROUP BY
    FISCPER,
    FISCVARNT,
    _BIC_ZIO_SWEEK,
    FISCYEAR,
    FISCPER3,
    _B631_S_CHRTACCT,
    _B631_S_CO_AREA,
    _BIC_ZIO_CMPCD,
    _B631_S_PROFTCTR,
    _B631_S_COSTCNTR,
    _B631_S_FUNCAREA,
    _BIC_ZIO_VER,
    _BIC_ZIO_SAUDT,
    MANDT,
    RECORDMODE,
    _B631_S_GL_ACCT,
    _BIC_ZWWPC_PA1,
    _BIC_ZWWSC_PA1,
    CURRENCY,
    _B631_S_LEDGER
),

-- =====================================================================
-- CTE 2: WEEKLY_SNAPSHOT_FILTERED
-- Logic: Apply CV_COMP_FIN_ACTUAL_STATIC filters on base actuals
-- Filters: FISCVARNT = 'K4', _BIC_ZIO_VER = @IP_VERSION, 
--          _BIC_ZIO_SWEEK = @IP_WEEK_LY, _BIC_ZIO_SAUDT IN ('1', '10')
-- =====================================================================
WEEKLY_SNAPSHOT_FILTERED AS (
  SELECT
    FISCPER,
    FISCVARNT,
    FISCYEAR,
    FISCPER3,
    MANDT,
    _BIC_ZIO_SWEEK,
    _B631_S_CHRTACCT,
    _B631_S_CO_AREA,
    _BIC_ZIO_CMPCD,
    _B631_S_PROFTCTR,
    _B631_S_COSTCNTR,
    _B631_S_FUNCAREA,
    _BIC_ZIO_VER,
    _BIC_ZIO_SAUDT,
    _B631_S_GL_ACCT,
    _BIC_ZWWPC_PA1,
    _BIC_ZWWSC_PA1,
    _B631_S_AMOUNT,
    CURRENCY,
    _BIC_ZIO_D1AMT,
    _BIC_ZIO_D2AMT,
    _BIC_ZIO_D3AMT,
    _BIC_ZIO_D4AMT,
    _BIC_ZIO_D5AMT,
    _BIC_ZIO_D6AMT,
    _BIC_ZIO_D7AMT
  FROM WEEKLY_SNAPSHOT_BASE
  WHERE FISCVARNT = 'K4'
    AND _BIC_ZIO_VER = @IP_VERSION
    AND _BIC_ZIO_SWEEK = @IP_WEEK_LY
    AND _BIC_ZIO_SAUDT IN ('1', '10')
),

-- =====================================================================
-- CTE 3: PC_HIERARCHY_BASE
-- Source: CV_BASE_MD_HRRP_NODE_S4 (Profit Center Hierarchy)
-- Physical Table: HRRP_NODE
-- Logic: Filter by MANDT IN (120, 200), PARNODE LIKE '%CORE_RET%', 
--        HRYVALTO = '99991231'
-- =====================================================================
PC_HIERARCHY_BASE AS (
  SELECT
    MANDT,
    HRYID,
    HRYVER,
    NODECLS,
    HRYNODE,
    PARNODE,
    HRYVALTO,
    HRYVALFROM,
    BALIND,
    NODETYPE,
    NODEVALUE
  FROM `PROJECT.DATASET.HRRP_NODE`
  WHERE MANDT IN (120, 200)
),

PC_HIERARCHY_FILTERED AS (
  SELECT
    MANDT,
    PARNODE,
    HRYVALTO,
    NODEVALUE
  FROM PC_HIERARCHY_BASE
  WHERE PARNODE LIKE '%CORE_RET%'
    AND HRYVALTO = '99991231'
),

-- =====================================================================
-- CTE 4: Join Weekly Snapshot with Profit Center Hierarchy
-- =====================================================================
WEEKLY_WITH_PC_HIER AS (
  SELECT
    ws.FISCPER,
    ws.FISCVARNT,
    ws.FISCYEAR,
    ws.FISCPER3,
    ws.MANDT,
    ws._BIC_ZIO_SWEEK,
    ws._B631_S_CHRTACCT,
    ws._B631_S_CO_AREA,
    ws._BIC_ZIO_CMPCD,
    ws._B631_S_PROFTCTR,
    ws._B631_S_COSTCNTR,
    ws._B631_S_FUNCAREA,
    ws._BIC_ZIO_VER,
    ws._BIC_ZIO_SAUDT,
    ws._B631_S_GL_ACCT,
    ws._BIC_ZWWPC_PA1,
    ws._BIC_ZWWSC_PA1,
    ws._B631_S_AMOUNT,
    ws.CURRENCY,
    ws._BIC_ZIO_D1AMT,
    ws._BIC_ZIO_D2AMT,
    ws._BIC_ZIO_D3AMT,
    ws._BIC_ZIO_D4AMT,
    ws._BIC_ZIO_D5AMT,
    ws._BIC_ZIO_D6AMT,
    ws._BIC_ZIO_D7AMT,
    ph.NODEVALUE AS PC_NODEVALUE
  FROM WEEKLY_SNAPSHOT_FILTERED ws
  INNER JOIN PC_HIERARCHY_FILTERED ph
    ON ws._B631_S_PROFTCTR = ph.NODEVALUE
    AND ws.MANDT = CAST(ph.MANDT AS STRING)
),

-- =====================================================================
-- CTE 5: GL_HIERARCHY_BASE
-- Source: CV_BASE_MD_HRRP_NODE_S4 (G/L Account Hierarchy)
-- Physical Table: HRRP_NODE
-- Logic: Filter by MANDT IN (120, 200), PARNODE LIKE '%181', 
--        HRYVALTO = '99991231', HRYID = 'CVS2'
-- =====================================================================
GL_HIERARCHY_BASE AS (
  SELECT
    MANDT,
    HRYID,
    HRYVER,
    NODECLS,
    HRYNODE,
    PARNODE,
    HRYVALTO,
    HRYVALFROM,
    BALIND,
    NODETYPE,
    NODEVALUE
  FROM `PROJECT.DATASET.HRRP_NODE`
  WHERE MANDT IN (120, 200)
),

GL_HIERARCHY_FILTERED AS (
  SELECT
    MANDT,
    PARNODE,
    HRYVALTO,
    NODEVALUE,
    HRYID,
    LTRIM(NODEVALUE, '0') AS CAL_NODE_VALUE
  FROM GL_HIERARCHY_BASE
  WHERE PARNODE LIKE '%181'
    AND HRYVALTO = '99991231'
    AND HRYID = 'CVS2'
),

-- =====================================================================
-- CTE 6: Join with G/L Account Hierarchy
-- =====================================================================
WEEKLY_WITH_GL_HIER AS (
  SELECT
    w.FISCPER,
    w.FISCVARNT,
    w.FISCYEAR,
    w.FISCPER3,
    w.MANDT,
    w._BIC_ZIO_SWEEK,
    w._B631_S_CHRTACCT,
    w._B631_S_CO_AREA,
    w._BIC_ZIO_CMPCD,
    w._B631_S_PROFTCTR,
    w._B631_S_COSTCNTR,
    w._B631_S_FUNCAREA,
    w._BIC_ZIO_VER,
    w._BIC_ZIO_SAUDT,
    w._B631_S_GL_ACCT,
    w._BIC_ZWWPC_PA1,
    w._BIC_ZWWSC_PA1,
    w._B631_S_AMOUNT,
    w.CURRENCY,
    w._BIC_ZIO_D1AMT,
    w._BIC_ZIO_D2AMT,
    w._BIC_ZIO_D3AMT,
    w._BIC_ZIO_D4AMT,
    w._BIC_ZIO_D5AMT,
    w._BIC_ZIO_D6AMT,
    w._BIC_ZIO_D7AMT,
    gh.NODEVALUE AS GL_NODEVALUE
  FROM WEEKLY_WITH_PC_HIER w
  INNER JOIN GL_HIERARCHY_FILTERED gh
    ON w._B631_S_GL_ACCT = gh.NODEVALUE
    AND w.MANDT = CAST(gh.MANDT AS STRING)
),

-- =====================================================================
-- CTE 7: Add Current Week Parameter
-- =====================================================================
WEEKLY_WITH_CAL_WEEK AS (
  SELECT
    *,
    @IP_WEEK_CY AS CAL_WEEK
  FROM WEEKLY_WITH_GL_HIER
),

-- =====================================================================
-- CTE 8: STORE_ATTRIBUTES_BASE
-- Source: CV_COMP_MD_SRPACT_STATIC → CV_BASE_MD_SRPACT_S4
-- Physical Table: ZTSRP_ATTR_ACT
-- Logic: Filter by MANDT IN (120, 200), aggregate measures
-- =====================================================================
STORE_ATTRIBUTES_BASE AS (
  SELECT
    MANDT,
    STRNUM,
    PRCTR,
    KOKRS,
    KOSTL,
    RX_OPEN_DAT,
    RX_CLOSE_DAT,
    FS_OPEN_DAT,
    FS_CLOSE_DAT,
    REP_MKT_CODE,
    REP_MKT_DESC,
    ADDRESS,
    CITY,
    STATE,
    ZIPCODE,
    DIVISION_CODE,
    DIVISION_DESC,
    DIVISION_MGR,
    AREA_CODE,
    AREA_DESC,
    AREA_MGR,
    REGION_CODE,
    REGION_DESC,
    REGION_MGR,
    DISTRICT_CODE,
    DISTRICT_DESC,
    ZONE_CODE,
    DISTRICT_MGR,
    ZONE_DESC,
    MAJOR_REGION_CODE,
    MAJOR_REGION,
    STORE_TYPE,
    STORE_TYPE_DESC,
    RX_STORE,
    RX_STORE_DESC,
    DISTRIBUTION_CNTR,
    DISTRIBUTION_CNTR_DESC,
    STORE_24_HR,
    BUDGET_OPEN_DAT,
    BUDGET_CLOSED_DAT,
    BUDGET_RELOC_DAT,
    CONST_OPEN_DAT,
    CONST_CLOSE_DAT,
    CONST_RELO_DAT,
    RELOCATION_DAT,
    EMERG_MKT_IND,
    BUDGET_EMERG_MKT_IND,
    COMPANY_CODE,
    COMPANY_CODE_DESC,
    ORIGINAL_FS_OPEN_DAT,
    ORIGINAL_RX_OPEN_DAT,
    GROUP_ONE,
    GROUP_TWO,
    ARD_SORT_KEY,
    AREA_COST_CENTER,
    REGIION_COST_CENTER,
    COUNTY_CODE,
    COUNTY_DESC,
    SQFT_BRACKET_DESC,
    SQFT_SORT_KEY,
    ACQUISITION_CODE,
    ACQUISITION_DESC,
    PHOTO_LAB_ADD_DAT,
    PHOTO_LAB_CLOSE_DAT,
    MIN_HRS_IND,
    CREATEDBY,
    CREATED_ON,
    RX_DIVISION_CODE,
    RX_AREA_CODE,
    RX_REGION_CODE,
    RX_DISTRICT_CODE,
    SUM(RX_HRS_OPER) AS RX_HRS_OPER,
    SUM(FS_HRS_OPER) AS FS_HRS_OPER,
    SUM(RETAIL_SQFT_AMT) AS RETAIL_SQFT_AMT,
    SUM(TOTAL_SQFT_AMT) AS TOTAL_SQFT_AMT
  FROM `PROJECT.DATASET.ZTSRP_ATTR_ACT`
  WHERE MANDT IN (120, 200)
  GROUP BY
    MANDT,
    STRNUM,
    PRCTR,
    KOKRS,
    KOSTL,
    RX_OPEN_DAT,
    RX_CLOSE_DAT,
    FS_OPEN_DAT,
    FS_CLOSE_DAT,
    REP_MKT_CODE,
    REP_MKT_DESC,
    ADDRESS,
    CITY,
    STATE,
    ZIPCODE,
    DIVISION_CODE,
    DIVISION_DESC,
    DIVISION_MGR,
    AREA_CODE,
    AREA_DESC,
    AREA_MGR,
    REGION_CODE,
    REGION_DESC,
    REGION_MGR,
    DISTRICT_CODE,
    DISTRICT_DESC,
    ZONE_CODE,
    DISTRICT_MGR,
    ZONE_DESC,
    MAJOR_REGION_CODE,
    MAJOR_REGION,
    STORE_TYPE,
    STORE_TYPE_DESC,
    RX_STORE,
    RX_STORE_DESC,
    DISTRIBUTION_CNTR,
    DISTRIBUTION_CNTR_DESC,
    STORE_24_HR,
    BUDGET_OPEN_DAT,
    BUDGET_CLOSED_DAT,
    BUDGET_RELOC_DAT,
    CONST_OPEN_DAT,
    CONST_CLOSE_DAT,
    CONST_RELO_DAT,
    RELOCATION_DAT,
    EMERG_MKT_IND,
    BUDGET_EMERG_MKT_IND,
    COMPANY_CODE,
    COMPANY_CODE_DESC,
    ORIGINAL_FS_OPEN_DAT,
    ORIGINAL_RX_OPEN_DAT,
    GROUP_ONE,
    GROUP_TWO,
    ARD_SORT_KEY,
    AREA_COST_CENTER,
    REGIION_COST_CENTER,
    COUNTY_CODE,
    COUNTY_DESC,
    SQFT_BRACKET_DESC,
    SQFT_SORT_KEY,
    ACQUISITION_CODE,
    ACQUISITION_DESC,
    PHOTO_LAB_ADD_DAT,
    PHOTO_LAB_CLOSE_DAT,
    MIN_HRS_IND,
    CREATEDBY,
    CREATED_ON,
    RX_DIVISION_CODE,
    RX_AREA_CODE,
    RX_REGION_CODE,
    RX_DISTRICT_CODE
),

-- =====================================================================
-- CTE 9: Join with Store Attributes
-- =====================================================================
WEEKLY_WITH_STORE_ATTR AS (
  SELECT
    w.FISCPER,
    w.FISCVARNT,
    w.FISCYEAR,
    w.FISCPER3,
    w.MANDT,
    w._BIC_ZIO_SWEEK,
    w._B631_S_CHRTACCT,
    w._B631_S_CO_AREA,
    w._BIC_ZIO_CMPCD,
    w._B631_S_PROFTCTR,
    w._B631_S_COSTCNTR,
    w._B631_S_FUNCAREA,
    w._BIC_ZIO_VER,
    w._BIC_ZIO_SAUDT,
    w._B631_S_GL_ACCT,
    w._BIC_ZWWPC_PA1,
    w._BIC_ZWWSC_PA1,
    w._B631_S_AMOUNT,
    w.CURRENCY,
    w._BIC_ZIO_D1AMT,
    w._BIC_ZIO_D2AMT,
    w._BIC_ZIO_D3AMT,
    w._BIC_ZIO_D4AMT,
    w._BIC_ZIO_D5AMT,
    w._BIC_ZIO_D6AMT,
    w._BIC_ZIO_D7AMT,
    w.CAL_WEEK,
    sa.REP_MKT_CODE,
    sa.REP_MKT_DESC,
    sa.EMERG_MKT_IND,
    sa.DIVISION_CODE,
    sa.DIVISION_DESC,
    sa.AREA_CODE,
    sa.AREA_DESC,
    sa.REGION_CODE,
    sa.REGION_DESC,
    sa.DISTRICT_CODE,
    sa.DISTRICT_DESC,
    sa.CITY,
    sa.STATE,
    sa.FS_OPEN_DAT,
    sa.RX_OPEN_DAT,
    sa.STRNUM,
    sa.RX_DIVISION_CODE,
    sa.RX_AREA_CODE,
    sa.RX_REGION_CODE,
    sa.RX_DISTRICT_CODE
  FROM WEEKLY_WITH_CAL_WEEK w
  LEFT JOIN STORE_ATTRIBUTES_BASE sa
    ON w._B631_S_PROFTCTR = sa.PRCTR
    AND w.MANDT = CAST(sa.MANDT AS STRING)
),

-- =====================================================================
-- CTE 10: RETAIL_CALENDAR_BASE
-- Source: CV_BASE_MD_RCALWEEL_S4
-- Physical Table: ZTFIGL_RCALWEEK
-- Logic: Filter by RCLNT IN (120, 200)
-- =====================================================================
RETAIL_CALENDAR_BASE AS (
  SELECT
    RCLNT,
    ZZWEEK,
    ZCALYRP,
    ZRYEAR,
    ZRPERIOD,
    ZRYRP,
    ZRYRQTR,
    ZRWSTRTDATE,
    ZRWENDDATE
  FROM `PROJECT.DATASET.ZTFIGL_RCALWEEK`
  WHERE RCLNT IN (120, 200)
),

-- =====================================================================
-- CTE 11: Join with Retail Calendar
-- =====================================================================
WEEKLY_WITH_RETAIL_CAL AS (
  SELECT
    w.FISCPER,
    w.FISCVARNT,
    w.FISCYEAR,
    w.FISCPER3,
    w.MANDT,
    w._BIC_ZIO_SWEEK,
    w._B631_S_CHRTACCT,
    w._B631_S_CO_AREA,
    w._BIC_ZIO_CMPCD,
    w._B631_S_PROFTCTR,
    w._B631_S_COSTCNTR,
    w._B631_S_FUNCAREA,
    w._BIC_ZIO_VER,
    w._BIC_ZIO_SAUDT,
    w._B631_S_GL_ACCT,
    w._BIC_ZWWPC_PA1,
    w._BIC_ZWWSC_PA1,
    w._B631_S_AMOUNT,
    w.CURRENCY,
    w._BIC_ZIO_D1AMT,
    w._BIC_ZIO_D2AMT,
    w._BIC_ZIO_D3AMT,
    w._BIC_ZIO_D4AMT,
    w._BIC_ZIO_D5AMT,
    w._BIC_ZIO_D6AMT,
    w._BIC_ZIO_D7AMT,
    w.CAL_WEEK,
    w.REP_MKT_CODE,
    w.REP_MKT_DESC,
    w.EMERG_MKT_IND,
    w.DIVISION_CODE,
    w.DIVISION_DESC,
    w.AREA_CODE,
    w.AREA_DESC,
    w.REGION_CODE,
    w.REGION_DESC,
    w.DISTRICT_CODE,
    w.DISTRICT_DESC,
    w.CITY,
    w.STATE,
    w.FS_OPEN_DAT,
    w.RX_OPEN_DAT,
    w.STRNUM,
    w.RX_DIVISION_CODE,
    w.RX_AREA_CODE,
    w.RX_REGION_CODE,
    w.RX_DISTRICT_CODE,
    rc.ZRWSTRTDATE,
    rc.ZRWENDDATE
  FROM WEEKLY_WITH_STORE_ATTR w
  LEFT JOIN RETAIL_CALENDAR_BASE rc
    ON w.CAL_WEEK = rc.ZZWEEK
    AND w.MANDT = CAST(rc.RCLNT AS STRING)
),

-- =====================================================================
-- CTE 12: COMP_FLAG_BASE
-- Source: CV_COMP_MD_COMPFL_STATIC → CV_BASE_MD_COMPFL_S4
-- Physical Table: ZTSRP_COMPFL
-- Logic: Filter by MANDT IN (110, 200), ZWEEK = @IP_WEEK_CY, 
--        COMP_VER = @IP_VERSION_COMP_FLAG
-- =====================================================================
COMP_FLAG_BASE AS (
  SELECT
    MANDT,
    PRCTR,
    STRNUM,
    COMP_VER,
    ZWEEK,
    ZMONTH,
    ZYEAR,
    FS_COMP_PRE,
    RX_COMP_PRE,
    FS_COMP_MON,
    RX_COMP_MON,
    FS_COMP_WK,
    RX_COMP_WK
  FROM `PROJECT.DATASET.ZTSRP_COMPFL`
  WHERE MANDT IN (110, 200)
    AND ZWEEK = @IP_WEEK_CY
    AND COMP_VER = @IP_VERSION_COMP_FLAG
),

-- =====================================================================
-- CTE 13: Join with Comparison Flags
-- =====================================================================
WEEKLY_WITH_COMP_FLAG AS (
  SELECT
    w.FISCPER,
    w.FISCVARNT,
    w.FISCYEAR,
    w.FISCPER3,
    w.MANDT,
    w._BIC_ZIO_SWEEK,
    w._B631_S_CHRTACCT,
    w._B631_S_CO_AREA,
    w._BIC_ZIO_CMPCD,
    w._B631_S_PROFTCTR,
    w._B631_S_COSTCNTR,
    w._B631_S_FUNCAREA,
    w._BIC_ZIO_VER,
    w._BIC_ZIO_SAUDT,
    w._B631_S_GL_ACCT,
    w._BIC_ZWWPC_PA1,
    w._BIC_ZWWSC_PA1,
    w._B631_S_AMOUNT,
    w.CURRENCY,
    w._BIC_ZIO_D1AMT,
    w._BIC_ZIO_D2AMT,
    w._BIC_ZIO_D3AMT,
    w._BIC_ZIO_D4AMT,
    w._BIC_ZIO_D5AMT,
    w._BIC_ZIO_D6AMT,
    w._BIC_ZIO_D7AMT,
    w.CAL_WEEK,
    w.REP_MKT_CODE,
    w.REP_MKT_DESC,
    w.EMERG_MKT_IND,
    w.DIVISION_CODE,
    w.DIVISION_DESC,
    w.AREA_CODE,
    w.AREA_DESC,
    w.REGION_CODE,
    w.REGION_DESC,
    w.DISTRICT_CODE,
    w.DISTRICT_DESC,
    w.CITY,
    w.STATE,
    w.FS_OPEN_DAT,
    w.RX_OPEN_DAT,
    w.STRNUM,
    w.RX_DIVISION_CODE,
    w.RX_AREA_CODE,
    w.RX_REGION_CODE,
    w.RX_DISTRICT_CODE,
    w.ZRWSTRTDATE,
    w.ZRWENDDATE,
    cf.FS_COMP_WK,
    cf.RX_COMP_WK
  FROM WEEKLY_WITH_RETAIL_CAL w
  LEFT JOIN COMP_FLAG_BASE cf
    ON w._B631_S_PROFTCTR = cf.PRCTR
    AND w.MANDT = CAST(cf.MANDT AS STRING)
),

-- =====================================================================
-- CTE 14: PROFIT_CENTER_TEXT_BASE
-- Source: CV_BASE_MD_CEPCT_S4
-- Physical Table: CEPCT
-- Logic: Filter by MANDT IN (120, 200)
-- =====================================================================
PROFIT_CENTER_TEXT_BASE AS (
  SELECT
    MANDT,
    SPRAS,
    PRCTR,
    DATBI,
    KOKRS,
    KTEXT,
    LTEXT,
    MCTXT
  FROM `PROJECT.DATASET.CEPCT`
  WHERE MANDT IN (120, 200)
),

-- =====================================================================
-- CTE 15: Join with Profit Center Text
-- =====================================================================
WEEKLY_WITH_PC_TEXT AS (
  SELECT
    w.FISCPER,
    w.FISCVARNT,
    w.FISCYEAR,
    w.FISCPER3,
    w.MANDT,
    w._BIC_ZIO_SWEEK,
    w._B631_S_CHRTACCT,
    w._B631_S_CO_AREA,
    w._BIC_ZIO_CMPCD,
    w._B631_S_PROFTCTR,
    w._B631_S_COSTCNTR,
    w._B631_S_FUNCAREA,
    w._BIC_ZIO_VER,
    w._BIC_ZIO_SAUDT,
    w._B631_S_GL_ACCT,
    w._BIC_ZWWPC_PA1,
    w._BIC_ZWWSC_PA1,
    w._B631_S_AMOUNT,
    w.CURRENCY,
    w._BIC_ZIO_D1AMT,
    w._BIC_ZIO_D2AMT,
    w._BIC_ZIO_D3AMT,
    w._BIC_ZIO_D4AMT,
    w._BIC_ZIO_D5AMT,
    w._BIC_ZIO_D6AMT,
    w._BIC_ZIO_D7AMT,
    w.CAL_WEEK,
    w.REP_MKT_CODE,
    w.REP_MKT_DESC,
    w.EMERG_MKT_IND,
    w.DIVISION_CODE,
    w.DIVISION_DESC,
    w.AREA_CODE,
    w.AREA_DESC,
    w.REGION_CODE,
    w.REGION_DESC,
    w.DISTRICT_CODE,
    w.DISTRICT_DESC,
    w.CITY,
    w.STATE,
    w.FS_OPEN_DAT,
    w.RX_OPEN_DAT,
    w.STRNUM,
    w.RX_DIVISION_CODE,
    w.RX_AREA_CODE,
    w.RX_REGION_CODE,
    w.RX_DISTRICT_CODE,
    w.ZRWSTRTDATE,
    w.ZRWENDDATE,
    w.FS_COMP_WK,
    w.RX_COMP_WK,
    pct.LTEXT AS PROFIT_CENTER_TEXT
  FROM WEEKLY_WITH_COMP_FLAG w
  LEFT JOIN PROFIT_CENTER_TEXT_BASE pct
    ON w._B631_S_PROFTCTR = pct.PRCTR
    AND w.MANDT = CAST(pct.MANDT AS STRING)
),

-- =====================================================================
-- CTE 16: Calculate Derived Columns
-- =====================================================================
CALCULATED_FLAGS AS (
  SELECT
    FISCPER,
    FISCVARNT,
    FISCYEAR,
    FISCPER3,
    MANDT,
    _BIC_ZIO_SWEEK,
    _B631_S_CHRTACCT,
    _B631_S_CO_AREA,
    _BIC_ZIO_CMPCD,
    _B631_S_PROFTCTR,
    _B631_S_COSTCNTR,
    _B631_S_FUNCAREA,
    _BIC_ZIO_VER,
    _BIC_ZIO_SAUDT,
    _B631_S_GL_ACCT,
    _BIC_ZWWPC_PA1,
    _BIC_ZWWSC_PA1,
    _B631_S_AMOUNT,
    CURRENCY,
    _BIC_ZIO_D1AMT,
    _BIC_ZIO_D2AMT,
    _BIC_ZIO_D3AMT,
    _BIC_ZIO_D4AMT,
    _BIC_ZIO_D5AMT,
    _BIC_ZIO_D6AMT,
    _BIC_ZIO_D7AMT,
    CAL_WEEK,
    REP_MKT_CODE,
    REP_MKT_DESC,
    EMERG_MKT_IND,
    DIVISION_CODE,
    DIVISION_DESC,
    AREA_CODE,
    AREA_DESC,
    REGION_CODE,
    REGION_DESC,
    DISTRICT_CODE,
    DISTRICT_DESC,
    CITY,
    STATE,
    FS_OPEN_DAT,
    RX_OPEN_DAT,
    STRNUM,
    RX_DIVISION_CODE,
    RX_AREA_CODE,
    RX_REGION_CODE,
    RX_DISTRICT_CODE,
    ZRWSTRTDATE,
    ZRWENDDATE,
    FS_COMP_WK,
    RX_COMP_WK,
    PROFIT_CENTER_TEXT,
    CASE
      WHEN LEFT(_BIC_ZWWPC_PA1, 2) = 'FS' THEN 'FS'
      WHEN LEFT(_BIC_ZWWPC_PA1, 2) = 'RX' THEN 'RX'
      ELSE ''
    END AS CAL_FS_RX_FLAG,
    CASE
      WHEN LEFT(_BIC_ZWWPC_PA1, 2) = 'FS' THEN FS_COMP_WK
      WHEN LEFT(_BIC_ZWWPC_PA1, 2) = 'RX' THEN RX_COMP_WK
      ELSE FS_COMP_WK
    END AS CAL_COMP_FLAG,
    RIGHT(@IP_WEEK_CY, 2) AS CAL_WEEK_NUMBER
  FROM WEEKLY_WITH_PC_TEXT
)

-- =====================================================================
-- FINAL OUTPUT: Aggregate and Transform
-- All measures are summed, _B631_S_AMOUNT is negated after aggregation
-- All non-measure columns are grouped
-- =====================================================================
SELECT
  MANDT,
  FISCPER,
  FISCVARNT,
  FISCYEAR,
  FISCPER3,
  _BIC_ZIO_SWEEK,
  _B631_S_CHRTACCT,
  _B631_S_CO_AREA,
  _BIC_ZIO_CMPCD,
  _B631_S_PROFTCTR,
  CAL_FS_RX_FLAG AS FS_RX_FLAG,
  _B631_S_COSTCNTR,
  _B631_S_FUNCAREA,
  _BIC_ZIO_VER,
  _BIC_ZIO_SAUDT,
  _B631_S_GL_ACCT,
  _BIC_ZWWPC_PA1,
  _BIC_ZWWSC_PA1,
  SUM(_B631_S_AMOUNT) * -1 AS _B631_S_AMOUNT,
  SUM(_BIC_ZIO_D1AMT) AS _BIC_ZIO_D1AMT,
  SUM(_BIC_ZIO_D2AMT) AS _BIC_ZIO_D2AMT,
  SUM(_BIC_ZIO_D3AMT) AS _BIC_ZIO_D3AMT,
  SUM(_BIC_ZIO_D4AMT) AS _BIC_ZIO_D4AMT,
  SUM(_BIC_ZIO_D5AMT) AS _BIC_ZIO_D5AMT,
  SUM(_BIC_ZIO_D6AMT) AS _BIC_ZIO_D6AMT,
  SUM(_BIC_ZIO_D7AMT) AS _BIC_ZIO_D7AMT,
  CURRENCY,
  REP_MKT_CODE,
  REP_MKT_DESC,
  EMERG_MKT_IND,
  FS_COMP_WK,
  RX_COMP_WK,
  CAL_COMP_FLAG AS COMP_FLAG,
  DIVISION_CODE,
  DIVISION_DESC,
  AREA_CODE,
  AREA_DESC,
  REGION_CODE,
  REGION_DESC,
  DISTRICT_CODE,
  DISTRICT_DESC,
  CITY,
  STATE,
  ZRWSTRTDATE,
  ZRWENDDATE,
  CAL_WEEK_NUMBER,
  PROFIT_CENTER_TEXT,
  FS_OPEN_DAT,
  RX_OPEN_DAT,
  CAL_WEEK,
  STRNUM,
  RX_DIVISION_CODE,
  RX_AREA_CODE,
  RX_REGION_CODE,
  RX_DISTRICT_CODE
FROM CALCULATED_FLAGS
GROUP BY
  MANDT,
  FISCPER,
  FISCVARNT,
  FISCYEAR,
  FISCPER3,
  _BIC_ZIO_SWEEK,
  _B631_S_CHRTACCT,
  _B631_S_CO_AREA,
  _BIC_ZIO_CMPCD,
  _B631_S_PROFTCTR,
  CAL_FS_RX_FLAG,
  _B631_S_COSTCNTR,
  _B631_S_FUNCAREA,
  _BIC_ZIO_VER,
  _BIC_ZIO_SAUDT,
  _B631_S_GL_ACCT,
  _BIC_ZWWPC_PA1,
  _BIC_ZWWSC_PA1,
  CURRENCY,
  REP_MKT_CODE,
  REP_MKT_DESC,
  EMERG_MKT_IND,
  FS_COMP_WK,
  RX_COMP_WK,
  CAL_COMP_FLAG,
  DIVISION_CODE,
  DIVISION_DESC,
  AREA_CODE,
  AREA_DESC,
  REGION_CODE,
  REGION_DESC,
  DISTRICT_CODE,
  DISTRICT_DESC,
  CITY,
  STATE,
  ZRWSTRTDATE,
  ZRWENDDATE,
  CAL_WEEK_NUMBER,
  PROFIT_CENTER_TEXT,
  FS_OPEN_DAT,
  RX_OPEN_DAT,
  CAL_WEEK,
  STRNUM,
  RX_DIVISION_CODE,
  RX_AREA_CODE,
  RX_REGION_CODE,
  RX_DISTRICT_CODE;

-- =====================================================================
-- END OF CONSOLIDATED SQL
-- =====================================================================
-- PARAMETERS REQUIRED AT RUNTIME:
-- @IP_VERSION: Version parameter for filtering weekly actuals
-- @IP_WEEK_LY: Last year week parameter for filtering weekly actuals
-- @IP_WEEK_CY: Current year week parameter for calendar week and comp flag
-- @IP_VERSION_COMP_FLAG: Version parameter for comparison flags
-- =====================================================================
-- PHYSICAL TABLES REFERENCED (Replace PROJECT.DATASET with actual values):
-- 1. PROJECT.DATASET.AZSRP_DS072_VT_S4 (Weekly actuals base table)
-- 2. PROJECT.DATASET.HRRP_NODE (Hierarchy nodes for PC and GL)
-- 3. PROJECT.DATASET.ZTSRP_ATTR_ACT (Store attributes base table)
-- 4. PROJECT.DATASET.ZTFIGL_RCALWEEK (Retail calendar week base table)
-- 5. PROJECT.DATASET.ZTSRP_COMPFL (Comparison flags base table)
-- 6. PROJECT.DATASET.CEPCT (Profit center text base table)
-- =====================================================================