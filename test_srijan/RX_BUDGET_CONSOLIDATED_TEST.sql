-- =====================================================================
-- CONSOLIDATED BIGQUERY SQL FOR CV_COMP_FIN_BUDGET_STATIC
-- =====================================================================
-- This consolidated SQL represents the complete end-to-end logic from
-- physical source tables through all intermediate transformations to
-- the final consumer-facing artifact CV_COMP_FIN_BUDGET_STATIC.
--
-- All intermediate calculation views and stored procedure logic have
-- been recursively expanded and inlined.
-- =====================================================================

WITH
-- =====================================================================
-- SECTION 1: BASE DATA SOURCES (Physical Tables)
-- =====================================================================

-- Source: AZSRP_DS052_VT_S4 (Frozen Cube)
Frozen_Cube AS (
  SELECT
    FISCPER,
    FISCVARNT,
    _BIC_ZIO_SWEEK,
    FISCYEAR,
    FISCPER3,
    _B631_S_CHRTACCT,
    _B631_S_GL_ACCT,
    _B631_S_CO_AREA,
    _BIC_ZIO_CMPCD,
    _B631_S_PROFTCTR,
    _B631_S_COSTCNTR,
    _B631_S_FUNCAREA,
    _BIC_ZIO_VER,
    _BIC_ZIO_SAUDT,
    MANDT,
    _BIC_ZWWPC_PA1,
    _BIC_ZWWSC_PA1,
    RECORDMODE,
    CURRENCY,
    _B631_S_AMOUNT,
    _BIC_ZIO_AMT,
    'FC' AS FLAG
  FROM
    `PROJECT.DATASET.AZSRP_DS052_VT_S4`
  WHERE
    MANDT IN ('110', '200')
    AND @IP_FC_COUNT != 0
),

-- Source: AZSRP_DS041_VT_S4 (Live Cube)
Live_Cube AS (
  SELECT
    FISCPER,
    FISCVARNT,
    _BIC_ZIO_SWEEK,
    FISCYEAR,
    FISCPER3,
    _B631_S_CHRTACCT,
    _B631_S_GL_ACCT,
    _B631_S_CO_AREA,
    _BIC_ZIO_CMPCD,
    _BIC_ZIO_PCTR AS _B631_S_PROFTCTR,
    _BIC_ZIO_CCTR AS _B631_S_COSTCNTR,
    _B631_S_FUNCAREA,
    _BIC_ZIO_VER,
    _BIC_ZIO_SAUDT,
    MANDT,
    _BIC_ZWWPC_PA1,
    _BIC_ZWWSC_PA1,
    RECORDMODE,
    CURRENCY,
    _B631_S_AMOUNT,
    _BIC_ZIO_AMT,
    'LC' AS FLAG
  FROM
    `PROJECT.DATASET.AZSRP_DS041_VT_S4`
  WHERE
    MANDT IN ('110', '200')
    AND @IP_FC_COUNT = 0
),

-- =====================================================================
-- SECTION 2: CV_BASE_FIN_WEEKLY_BUDGET_S4 (Inlined)
-- =====================================================================

Union_1 AS (
  SELECT * FROM Frozen_Cube
  UNION ALL
  SELECT * FROM Live_Cube
),

Aggregated AS (
  SELECT
    FISCPER,
    FISCVARNT,
    _BIC_ZIO_SWEEK,
    FISCYEAR,
    FISCPER3,
    _B631_S_CHRTACCT,
    _B631_S_GL_ACCT,
    _B631_S_CO_AREA,
    _BIC_ZIO_CMPCD,
    _B631_S_PROFTCTR,
    _B631_S_COSTCNTR,
    _B631_S_FUNCAREA,
    _BIC_ZIO_VER,
    _BIC_ZIO_SAUDT,
    MANDT,
    _BIC_ZWWPC_PA1,
    _BIC_ZWWSC_PA1,
    RECORDMODE,
    CURRENCY,
    FLAG,
    SUM(_B631_S_AMOUNT) AS _B631_S_AMOUNT_DUMMY,
    SUM(_BIC_ZIO_AMT) AS _BIC_ZIO_AMT
  FROM
    Union_1
  GROUP BY
    FISCPER,
    FISCVARNT,
    _BIC_ZIO_SWEEK,
    FISCYEAR,
    FISCPER3,
    _B631_S_CHRTACCT,
    _B631_S_GL_ACCT,
    _B631_S_CO_AREA,
    _BIC_ZIO_CMPCD,
    _B631_S_PROFTCTR,
    _B631_S_COSTCNTR,
    _B631_S_FUNCAREA,
    _BIC_ZIO_VER,
    _BIC_ZIO_SAUDT,
    MANDT,
    _BIC_ZWWPC_PA1,
    _BIC_ZWWSC_PA1,
    RECORDMODE,
    CURRENCY,
    FLAG
),

RES_AMOUNTS AS (
  SELECT
    FISCPER,
    FISCVARNT,
    _BIC_ZIO_SWEEK,
    FISCYEAR,
    FISCPER3,
    _B631_S_CHRTACCT,
    _B631_S_GL_ACCT,
    _B631_S_CO_AREA,
    _BIC_ZIO_CMPCD,
    _B631_S_PROFTCTR,
    _B631_S_COSTCNTR,
    _B631_S_FUNCAREA,
    _BIC_ZIO_VER,
    _BIC_ZIO_SAUDT,
    MANDT,
    _BIC_ZWWPC_PA1,
    _BIC_ZWWSC_PA1,
    RECORDMODE,
    CURRENCY,
    SUM(CASE WHEN FLAG = 'LC' THEN _B631_S_AMOUNT_DUMMY ELSE 0 END) AS RES_AMOUNT_LC,
    SUM(CASE WHEN FLAG = 'FC' THEN _B631_S_AMOUNT_DUMMY ELSE 0 END) AS RES_AMOUNT_FC,
    SUM(_BIC_ZIO_AMT) AS _BIC_ZIO_AMT
  FROM
    Aggregated
  GROUP BY
    FISCPER,
    FISCVARNT,
    _BIC_ZIO_SWEEK,
    FISCYEAR,
    FISCPER3,
    _B631_S_CHRTACCT,
    _B631_S_GL_ACCT,
    _B631_S_CO_AREA,
    _BIC_ZIO_CMPCD,
    _B631_S_PROFTCTR,
    _B631_S_COSTCNTR,
    _B631_S_FUNCAREA,
    _BIC_ZIO_VER,
    _BIC_ZIO_SAUDT,
    MANDT,
    _BIC_ZWWPC_PA1,
    _BIC_ZWWSC_PA1,
    RECORDMODE,
    CURRENCY
),

WEEKLY_SNAPSHOT_DS05 AS (
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
    IF(RES_AMOUNT_FC IS NULL OR RES_AMOUNT_FC = 0, RES_AMOUNT_LC, RES_AMOUNT_FC) AS _B631_S_AMOUNT,
    CURRENCY,
    _BIC_ZIO_AMT,
    'FC' AS FLAG
  FROM
    RES_AMOUNTS
  WHERE
    FISCVARNT = 'K4'
    AND _BIC_ZIO_SWEEK BETWEEN @IP_WEEK_ENDING_FROM AND @IP_WEEK_ENDING_TO
    AND _BIC_ZIO_VER = @IP_VERSION
    AND _BIC_ZIO_SAUDT IN ('1', '10')
),

-- =====================================================================
-- SECTION 3: CV_BASE_MD_HRRP_NODE_S4 (Inlined)
-- =====================================================================

HIER_NODE AS (
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
  FROM
    `PROJECT.DATASET.HRRP_NODE`
  WHERE
    MANDT IN (120, 200)
    AND (PARNODE LIKE '%CORE_RET')
    AND HRYVALTO = '99991231'
),

-- =====================================================================
-- SECTION 4: Join WEEKLY_SNAPSHOT with HIER_NODE
-- =====================================================================

Join_1 AS (
  SELECT
    w.*,
    h.PARNODE
  FROM WEEKLY_SNAPSHOT_DS05 w
  INNER JOIN HIER_NODE h
    ON w._B631_S_PROFTCTR = h.NODEVALUE
),

ONLY_CORE_RET_DATA AS (
  SELECT
    *
  FROM Join_1
),

-- =====================================================================
-- SECTION 5: CV_BASE_MD_SRPACT_S4 (Inlined - Source for STP)
-- =====================================================================

CV_BASE_MD_SRPACT_S4_SOURCE AS (
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
  FROM
    `PROJECT.DATASET.ZTSRP_ATTR_ACT`
  WHERE
    MANDT IN (120, 200)
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
-- SECTION 6: CV_COMP_MD_SRPACT_STATIC (Inlined - Uses STP output logic)
-- =====================================================================

STORE_ATTR_ACTUAL AS (
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
  FROM CV_BASE_MD_SRPACT_S4_SOURCE
),

-- =====================================================================
-- SECTION 7: Join with STORE_ATTR_ACTUAL
-- =====================================================================

Join_2 AS (
  SELECT
    o.*,
    s.REP_MKT_CODE,
    s.REP_MKT_DESC,
    s.EMERG_MKT_IND,
    s.DIVISION_CODE,
    s.DIVISION_DESC,
    s.AREA_CODE,
    s.AREA_DESC,
    s.DISTRICT_CODE,
    s.DISTRICT_DESC,
    s.STRNUM,
    s.REGION_CODE,
    s.REGION_DESC,
    s.CITY,
    s.STATE,
    s.FS_OPEN_DAT,
    s.RX_OPEN_DAT,
    s.RX_DIVISION_CODE,
    s.RX_AREA_CODE,
    s.RX_REGION_CODE,
    s.RX_DISTRICT_CODE
  FROM ONLY_CORE_RET_DATA o
  LEFT JOIN STORE_ATTR_ACTUAL s
    ON o._B631_S_PROFTCTR = s.PRCTR
),

WEEK_NUMBER AS (
  SELECT
    *,
    RIGHT(CAST(_BIC_ZIO_SWEEK AS STRING), 2) AS CAL_STORE_WEEK_NUMBER
  FROM Join_2
),

-- =====================================================================
-- SECTION 8: CV_BASE_MD_COMPFL_S4 (Inlined - Source for STP)
-- =====================================================================

CV_BASE_MD_COMPFL_S4_SOURCE AS (
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
  FROM
    `PROJECT.DATASET.TBL_WSS_SRP_COMPFLAG_SOURCE`
),

-- =====================================================================
-- SECTION 9: CV_COMP_MD_COMPFL_STATIC (Inlined - Uses STP output logic)
-- =====================================================================

COMP_FLAG_BUDGET AS (
  SELECT
    MANDT,
    PRCTR,
    STRNUM,
    FS_COMP_WK,
    RX_COMP_WK,
    ZWEEK,
    ZMONTH,
    ZYEAR,
    COMP_VER
  FROM CV_BASE_MD_COMPFL_S4_SOURCE
  WHERE COMP_VER = @IP_VERSION
),

-- =====================================================================
-- SECTION 10: Join with COMP_FLAG_BUDGET
-- =====================================================================

Join_3 AS (
  SELECT
    w.*,
    c.FS_COMP_WK,
    c.RX_COMP_WK
  FROM WEEK_NUMBER w
  LEFT JOIN COMP_FLAG_BUDGET c
    ON w._B631_S_PROFTCTR = c.PRCTR AND w._BIC_ZIO_SWEEK = c.ZWEEK
),

-- =====================================================================
-- SECTION 11: CV_BASE_MD_RCALWEEK_S4 (Inlined)
-- =====================================================================

CAL_WEEK AS (
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
  FROM
    `PROJECT.DATASET.ZTFIGL_RCALWEEK`
  WHERE
    RCLNT IN (120, 200)
),

-- =====================================================================
-- SECTION 12: Join with CAL_WEEK
-- =====================================================================

Join_4 AS (
  SELECT
    j.*,
    c.ZRWSTRTDATE,
    c.ZRWENDDATE
  FROM Join_3 j
  LEFT JOIN CAL_WEEK c
    ON j._BIC_ZIO_SWEEK = c.ZZWEEK
),

-- =====================================================================
-- SECTION 13: CV_BASE_MD_CEPCT_S4 (Inlined)
-- =====================================================================

PROFIT_CENTER_TEXT AS (
  SELECT
    MANDT,
    SPRAS,
    PRCTR,
    DATBI,
    KOKRS,
    KTEXT,
    LTEXT,
    MCTXT
  FROM
    `PROJECT.DATASET.CEPCT`
  WHERE
    MANDT IN (120, 200)
),

-- =====================================================================
-- SECTION 14: Join with PROFIT_CENTER_TEXT
-- =====================================================================

Join_5 AS (
  SELECT
    j.*,
    p.LTEXT AS PROFIT_CENTER_TEXT
  FROM Join_4 j
  LEFT JOIN PROFIT_CENTER_TEXT p
    ON j._B631_S_PROFTCTR = p.PRCTR
),

-- =====================================================================
-- SECTION 15: FLAGS and Calculated Columns (Pre-Aggregation)
-- =====================================================================

FLAGS_PRE_AGG AS (
  SELECT
    RX_COMP_WK,
    FS_COMP_WK,
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
    _B631_S_AMOUNT AS _B631_S_AMOUNT_NEGATIVE,
    CURRENCY,
    _BIC_ZIO_AMT,
    REP_MKT_CODE,
    REP_MKT_DESC,
    EMERG_MKT_IND,
    DIVISION_CODE,
    DIVISION_DESC,
    AREA_CODE,
    AREA_DESC,
    DISTRICT_CODE,
    DISTRICT_DESC,
    STRNUM,
    REGION_CODE,
    REGION_DESC,
    ZRWSTRTDATE,
    ZRWENDDATE,
    CITY,
    STATE,
    PROFIT_CENTER_TEXT,
    FS_OPEN_DAT,
    RX_OPEN_DAT,
    FLAG AS FIN_BUD_CUBE,
    RX_DIVISION_CODE,
    RX_AREA_CODE,
    RX_REGION_CODE,
    RX_DISTRICT_CODE,
    CASE
      WHEN LEFT(CAST(_BIC_ZWWPC_PA1 AS STRING), 2) = 'FS' THEN 'FS'
      WHEN LEFT(CAST(_BIC_ZWWPC_PA1 AS STRING), 2) = 'RX' THEN 'RX'
      ELSE ''
    END AS CAL_FS_RX_FLAG,
    CASE
      WHEN (CASE
              WHEN LEFT(CAST(_BIC_ZWWPC_PA1 AS STRING), 2) = 'FS' THEN FS_COMP_WK
              WHEN LEFT(CAST(_BIC_ZWWPC_PA1 AS STRING), 2) = 'RX' THEN RX_COMP_WK
              ELSE FS_COMP_WK
            END) IS NULL
        THEN '0'
      ELSE (CASE
              WHEN LEFT(CAST(_BIC_ZWWPC_PA1 AS STRING), 2) = 'FS' THEN FS_COMP_WK
              WHEN LEFT(CAST(_BIC_ZWWPC_PA1 AS STRING), 2) = 'RX' THEN RX_COMP_WK
              ELSE FS_COMP_WK
            END)
    END AS CAL_COMP_FLAG,
    RIGHT(CAST(_BIC_ZIO_SWEEK AS STRING), 2) AS CAL_WEEK_NUMBER,
    (_B631_S_AMOUNT * -1) AS _B631_S_AMOUNT
  FROM Join_5
)

-- =====================================================================
-- SECTION 16: FINAL OUTPUT (Aggregated)
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
  DISTRICT_CODE,
  DISTRICT_DESC,
  STRNUM,
  REGION_CODE,
  REGION_DESC,
  ZRWSTRTDATE,
  ZRWENDDATE,
  CAL_WEEK_NUMBER,
  CITY,
  STATE,
  PROFIT_CENTER_TEXT,
  FS_OPEN_DAT,
  RX_OPEN_DAT,
  FIN_BUD_CUBE,
  RX_DIVISION_CODE,
  RX_AREA_CODE,
  RX_REGION_CODE,
  RX_DISTRICT_CODE,
  SUM(_B631_S_AMOUNT_NEGATIVE) AS _B631_S_AMOUNT_NEGATIVE,
  SUM(_BIC_ZIO_AMT) AS _BIC_ZIO_AMT,
  SUM(_B631_S_AMOUNT) AS _B631_S_AMOUNT
FROM FLAGS_PRE_AGG
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
  DISTRICT_CODE,
  DISTRICT_DESC,
  STRNUM,
  REGION_CODE,
  REGION_DESC,
  ZRWSTRTDATE,
  ZRWENDDATE,
  CAL_WEEK_NUMBER,
  CITY,
  STATE,
  PROFIT_CENTER_TEXT,
  FS_OPEN_DAT,
  RX_OPEN_DAT,
  FIN_BUD_CUBE,
  RX_DIVISION_CODE,
  RX_AREA_CODE,
  RX_REGION_CODE,
  RX_DISTRICT_CODE
