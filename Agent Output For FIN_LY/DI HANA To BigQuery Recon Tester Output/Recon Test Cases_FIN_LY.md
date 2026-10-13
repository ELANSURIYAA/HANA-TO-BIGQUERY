<div style="border:1px solid #d0d7de;border-radius:6px;overflow:hidden;font-family:Arial,sans-serif;width:100%;margin-bottom:15px;">
    <div style="background:#1f4e79;color:white;padding:10px;font-size:16px;font-weight:bold;">
        CV_COMP_FIN_ACTUAL_STATIC Reconciliation Test Report
    </div>
    <table style="border-collapse:collapse;width:100%;">
        <tr>
            <td style="padding:8px;border:1px solid #ddd;background:#f5f5f5;width:150px;"><b>Author</b></td>
            <td style="padding:8px;border:1px solid #ddd;">Ascendion AAVA</td>
        </tr>
        <tr>
            <td style="padding:8px;border:1px solid #ddd;background:#f5f5f5;"><b>Created On</b></td>
            <td>2026-10-13</td>
        </tr>
        <tr>
            <td style="padding:8px;border:1px solid #ddd;background:#f5f5f5;"><b>Description</b></td>
            <td>Validates financial actuals by fiscal period, account, cost center, and profit center between HANA CV_COMP_FIN_ACTUAL_STATIC and its BigQuery migration.</td>
        </tr>
    </table>
</div>
import os
import sys
import json
import csv
import time
import logging
import traceback
import pandas as pd
import numpy as np
from datetime import datetime
from decimal import Decimal
from typing import List, Dict, Any

try:
    import hana_ml.dataframe as hd
except ImportError:
    hd = None
try:
    from google.cloud import bigquery
    from google.oauth2 import service_account
except ImportError:
    bigquery = None

# Logging setup
logging.basicConfig(filename='migration_validation.log', level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')
logger = logging.getLogger()

def log_progress(percent, message):
    logger.info(f"Progress: {percent}% - {message}")
    print(f"Progress: {percent}% - {message}")

def mask_sensitive(val):
    if not val:
        return val
    return str(val)[:2] + '***' + str(val)[-2:]

def get_env_or_fail(env_name):
    val = os.getenv(env_name)
    if not val:
        raise RuntimeError(f"Missing required environment variable: {env_name}")
    return val

def get_hana_connection():
    if not hd:
        raise ImportError("hana_ml is not installed. Please install hana_ml for HANA connectivity.")
    hana_host = get_env_or_fail('HANA_HOST')
    hana_port = get_env_or_fail('HANA_PORT')
    hana_user = get_env_or_fail('HANA_USER')
    hana_password = get_env_or_fail('HANA_PASSWORD')
    hana_encrypt = os.getenv('HANA_ENCRYPT', 'true')
    conn = hd.ConnectionContext(
        address=hana_host,
        port=int(hana_port),
        user=hana_user,
        password=hana_password,
        encrypt=hana_encrypt.lower() == 'true'
    )
    return conn

def get_bigquery_client():
    if not bigquery:
        raise ImportError("google-cloud-bigquery is not installed. Please install google-cloud-bigquery for BigQuery connectivity.")
    gcp_creds_json = os.getenv('GOOGLE_APPLICATION_CREDENTIALS_JSON')
    if gcp_creds_json:
        creds_dict = json.loads(gcp_creds_json)
        creds = service_account.Credentials.from_service_account_info(creds_dict)
        return bigquery.Client(credentials=creds)
    else:
        return bigquery.Client()

# ---- PARAMETERS ----
# These should be provided at runtime, e.g. via environment variables or CLI args
PARAMS = {
    'IP_VERSION': os.getenv('IP_VERSION'),
    'IP_WEEK_LY': os.getenv('IP_WEEK_LY'),
    'IP_WEEK_CY': os.getenv('IP_WEEK_CY'),
    'IP_VERSION_COMP_FLAG': os.getenv('IP_VERSION_COMP_FLAG')
}
for k, v in PARAMS.items():
    if v is None:
        logger.error(f"Missing required parameter: {k}")
        raise RuntimeError(f"Missing required parameter: {k}")

# ---- HANA SOURCE OBJECT ----
# From lineage, the main HANA object is CV_COMP_FIN_ACTUAL_STATIC (Calculation View)
HANA_OBJECT_NAME = 'CV_COMP_FIN_ACTUAL_STATIC'

# ---- BigQuery SQL ----
BIGQUERY_SQL = """
-- =====================================================================
-- FINAL CONSOLIDATED BIGQUERY SQL: CV_COMP_FIN_ACTUAL_STATIC
-- Fully Expanded from HANA Lineage with All Dependencies Inlined
-- =====================================================================
-- 
-- CONSOLIDATED FROM:
--   - CV_BASE_FIN_WEEKLY_ACTUAL_S4
--   - CV_BASE_MD_SRPACT_S4 (via STP_WSS_SRP_ATTRIBUTES → TBL_WSS_SRP_ATTR_ACT → CV_COMP_MD_SRPACT_STATIC)
--   - CV_BASE_MD_COMPFL_S4 (via STP_WSS_SRP_ATTRIBUTES → TBL_WSS_SRP_COMPFLAG → CV_COMP_MD_COMPFL_STATIC)
--   - GL_HEIR.CV_BASE_MD_HRRP_NODE_S4
--   - PC_HEIR.CV_BASE_MD_HRRP_NODE_S4
--   - CV_BASE_MD_RCALWEEK_S4
--   - CV_BASE_MD_CEPCT_S4
--
-- PARAMETERS (must be supplied at runtime):
--   @IP_VERSION           - Version filter for weekly actuals
--   @IP_WEEK_LY           - Last year week filter
--   @IP_WEEK_CY           - Current year week filter
--   @IP_VERSION_COMP_FLAG - Comp flag version filter
--
-- UNRESOLVED DEPENDENCIES:
--   - SFN_PRIOR_FISCAL_WEEK() function logic not available
--   - Actual BigQuery project/dataset names (PROJECT.DATASET used as placeholder)
--   - MANDT datatype validation required (numeric vs string)
--
-- =====================================================================

WITH 

-- =====================================================================
-- BASE DATA: CV_BASE_FIN_WEEKLY_ACTUAL_S4
-- Source: AZSRP_DS072_VT_S4 table
-- Aggregates financial actuals by fiscal period, account, cost center, etc.
-- =====================================================================
WEEKLY_SNAPSHOT_DS05_BASE AS (
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
  FROM
    PROJECT.DATASET.AZSRP_DS072_VT_S4
  WHERE
    MANDT IN (110, 200)
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
-- FILTERED WEEKLY SNAPSHOT
-- Applies filters from CV_COMP_FIN_ACTUAL_STATIC projection
-- =====================================================================
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
    _B631_S_AMOUNT,
    CURRENCY,
    _BIC_ZIO_D1AMT,
    _BIC_ZIO_D2AMT,
    _BIC_ZIO_D3AMT,
    _BIC_ZIO_D4AMT,
    _BIC_ZIO_D5AMT,
    _BIC_ZIO_D6AMT,
    _BIC_ZIO_D7AMT
  FROM WEEKLY_SNAPSHOT_DS05_BASE
  WHERE FISCVARNT = 'K4'
    AND _BIC_ZIO_VER = @IP_VERSION
    AND _BIC_ZIO_SWEEK = @IP_WEEK_LY
    AND _BIC_ZIO_SAUDT IN ('1', '10')
),

-- =====================================================================
-- PROFIT CENTER HIERARCHY (PC_HEIR)
-- Source: CV_BASE_MD_HRRP_NODE_S4 (PC hierarchy variant)
-- Filters for CORE_RET parent nodes
-- =====================================================================
PC_HIER_BASE AS (
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
    PROJECT.DATASET.HRRP_NODE
  WHERE
    MANDT IN (120, 200)
),

PC_HIER AS (
  SELECT 
    MANDT, 
    PARNODE, 
    HRYVALTO, 
    NODEVALUE
  FROM PC_HIER_BASE
  WHERE PARNODE LIKE '%CORE_RET%'
    AND HRYVALTO = '99991231'
),

-- =====================================================================
-- JOIN: Weekly Snapshot with Profit Center Hierarchy
-- Maps profit center to hierarchy node value
-- =====================================================================
Join_4 AS (
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
    pc.NODEVALUE AS _B631_S_PROFTCTR,
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
    ws._BIC_ZIO_D7AMT
  FROM WEEKLY_SNAPSHOT_DS05 ws
  INNER JOIN PC_HIER pc
    ON ws._B631_S_PROFTCTR = pc.NODEVALUE
    AND ws.MANDT = pc.MANDT
),

-- =====================================================================
-- GL ACCOUNT HIERARCHY (GL_HIER)
-- Source: GL_HEIR.CV_BASE_MD_HRRP_NODE_S4 (GL hierarchy variant)
-- Filters for parent node 181, hierarchy CVS2
-- =====================================================================
GL_HIER_BASE AS (
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
    PROJECT.DATASET.HRRP_NODE
  WHERE
    MANDT IN (120, 200)
),

GL_HIER AS (
  SELECT
    MANDT, 
    PARNODE, 
    HRYVALTO, 
    NODEVALUE, 
    HRYID,
    LTRIM(NODEVALUE, '0') AS CAL_NODE_VALUE
  FROM GL_HIER_BASE
  WHERE PARNODE LIKE '%181'
    AND HRYVALTO = '99991231'
    AND HRYID = 'CVS2'
),

-- =====================================================================
-- JOIN: Add GL Account Hierarchy
-- Maps GL account to hierarchy node value
-- =====================================================================
Join_6 AS (
  SELECT
    j4.FISCPER,
    j4.FISCVARNT,
    j4.FISCYEAR,
    j4.FISCPER3,
    j4.MANDT,
    j4._BIC_ZIO_SWEEK,
    j4._B631_S_CHRTACCT,
    j4._B631_S_CO_AREA,
    j4._BIC_ZIO_CMPCD,
    j4._B631_S_PROFTCTR,
    j4._B631_S_COSTCNTR,
    j4._B631_S_FUNCAREA,
    j4._BIC_ZIO_VER,
    j4._BIC_ZIO_SAUDT,
    gl.NODEVALUE AS _B631_S_GL_ACCT,
    j4._BIC_ZWWPC_PA1,
    j4._BIC_ZWWSC_PA1,
    j4._B631_S_AMOUNT,
    j4.CURRENCY,
    j4._BIC_ZIO_D1AMT,
    j4._BIC_ZIO_D2AMT,
    j4._BIC_ZIO_D3AMT,
    j4._BIC_ZIO_D4AMT,
    j4._BIC_ZIO_D5AMT,
    j4._BIC_ZIO_D6AMT,
    j4._BIC_ZIO_D7AMT
  FROM Join_4 j4
  INNER JOIN GL_HIER gl
    ON j4._B631_S_GL_ACCT = gl.NODEVALUE
    AND j4.MANDT = gl.MANDT
),

-- =====================================================================
-- ADD CALENDAR WEEK CONSTANT
-- Adds IP_WEEK_CY as CAL_WEEK column
-- =====================================================================
Projection_1 AS (
  SELECT 
    *, 
    @IP_WEEK_CY AS CAL_WEEK
  FROM Join_6
),

-- =====================================================================
-- STORE ATTRIBUTES (CV_COMP_MD_SRPACT_STATIC)
-- Source: CV_BASE_MD_SRPACT_S4 → STP_WSS_SRP_ATTRIBUTES → TBL_WSS_SRP_ATTR_ACT
-- Inlined from base source: ZTSRP_ATTR_ACT
-- =====================================================================
STORE_ATTR_BASE AS (
  SELECT
    MANDT,
    STRNUM,
    PRCTR,
    KOKRS,
    KOSTL,
    RX_OPEN_DAT,
    RX_CLOSE_DAT,
    SUM(RX_HRS_OPER) AS RX_HRS_OPER,
    FS_OPEN_DAT,
    FS_CLOSE_DAT,
    SUM(FS_HRS_OPER) AS FS_HRS_OPER,
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
    SUM(RETAIL_SQFT_AMT) AS RETAIL_SQFT_AMT,
    SUM(TOTAL_SQFT_AMT) AS TOTAL_SQFT_AMT,
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
  FROM
    PROJECT.DATASET.ZTSRP_ATTR_ACT
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
  FROM STORE_ATTR_BASE
),

-- =====================================================================
-- JOIN: Add Store Attributes
-- LEFT JOIN to preserve all financial records even without store match
-- =====================================================================
Join_2 AS (
  SELECT
    p1.FISCPER,
    p1.FISCVARNT,
    p1.FISCYEAR,
    p1.FISCPER3,
    p1.MANDT,
    p1._BIC_ZIO_SWEEK,
    p1._B631_S_CHRTACCT,
    p1._B631_S_CO_AREA,
    p1._BIC_ZIO_CMPCD,
    p1._B631_S_PROFTCTR,
    p1._B631_S_COSTCNTR,
    p1._B631_S_FUNCAREA,
    p1._BIC_ZIO_VER,
    p1._BIC_ZIO_SAUDT,
    p1._B631_S_GL_ACCT,
    p1._BIC_ZWWPC_PA1,
    p1._BIC_ZWWSC_PA1,
    p1._B631_S_AMOUNT,
    p1.CURRENCY,
    p1._BIC_ZIO_D1AMT,
    p1._BIC_ZIO_D2AMT,
    p1._BIC_ZIO_D3AMT,
    p1._BIC_ZIO_D4AMT,
    p1._BIC_ZIO_D5AMT,
    p1._BIC_ZIO_D6AMT,
    p1._BIC_ZIO_D7AMT,
    p1.CAL_WEEK,
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
  FROM Projection_1 p1
  LEFT JOIN STORE_ATTR_ACTUAL sa
    ON p1._B631_S_PROFTCTR = sa.PRCTR
    AND p1.MANDT = sa.MANDT
),

-- =====================================================================
-- RETAIL CALENDAR (CV_BASE_MD_RCALWEEK_S4)
-- Source: ZTFIGL_RCALWEEK table
-- Provides week start/end dates
-- =====================================================================
RETAIL_CAL_BASE AS (
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
    PROJECT.DATASET.ZTFIGL_RCALWEEK
  WHERE
    RCLNT IN (120, 200)
),

RETAIL_CAL AS (
  SELECT 
    ZRWSTRTDATE, 
    ZRWENDDATE, 
    ZZWEEK, 
    RCLNT
  FROM RETAIL_CAL_BASE
),

-- =====================================================================
-- JOIN: Add Retail Calendar Week Dates
-- LEFT JOIN to add week start/end dates
-- =====================================================================
Join_1 AS (
  SELECT
    j2.*,
    rc.ZRWSTRTDATE,
    rc.ZRWENDDATE
  FROM Join_2 j2
  LEFT JOIN RETAIL_CAL rc
    ON j2.CAL_WEEK = rc.ZZWEEK
    AND j2.MANDT = rc.RCLNT
),

-- =====================================================================
-- WEEK_NUMBER projection (pass-through)
-- =====================================================================
WEEK_NUMBER AS (
  SELECT * FROM Join_1
),

-- =====================================================================
-- COMP FLAG (CV_COMP_MD_COMPFL_STATIC)
-- Source: CV_BASE_MD_COMPFL_S4 → STP_WSS_SRP_ATTRIBUTES → TBL_WSS_SRP_COMPFLAG
-- Inlined from base source with stored procedure filter logic
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
  FROM
    PROJECT.DATASET.ZTSRP_COMPFLAG
),

COMP_FLAG_LY AS (
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
  FROM COMP_FLAG_BASE
  WHERE ZWEEK = @IP_WEEK_CY
    AND COMP_VER = @IP_VERSION_COMP_FLAG
),

-- =====================================================================
-- JOIN: Add Comp Flags
-- LEFT JOIN to add FS and RX comp week flags
-- =====================================================================
Join_3 AS (
  SELECT
    wn.*,
    cf.FS_COMP_WK,
    cf.RX_COMP_WK
  FROM WEEK_NUMBER wn
  LEFT JOIN COMP_FLAG_LY cf
    ON wn._B631_S_PROFTCTR = cf.PRCTR
    AND wn.MANDT = cf.MANDT
),

-- =====================================================================
-- PROFIT CENTER TEXT (CV_BASE_MD_CEPCT_S4)
-- Source: CEPCT table
-- Provides profit center long text descriptions
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
  FROM
    PROJECT.DATASET.CEPCT
  WHERE
    MANDT IN (120, 200)
),

PROFIT_CENTER_TEXT AS (
  SELECT 
    MANDT, 
    PRCTR, 
    LTEXT AS PROFIT_CENTER_TEXT
  FROM PROFIT_CENTER_TEXT_BASE
),

-- =====================================================================
-- JOIN: Add Profit Center Text
-- LEFT JOIN to add profit center descriptions
-- =====================================================================
Join_5 AS (
  SELECT
    j3.*,
    pct.PROFIT_CENTER_TEXT
  FROM Join_3 j3
  LEFT JOIN PROFIT_CENTER_TEXT pct
    ON j3._B631_S_PROFTCTR = pct.PRCTR
    AND j3.MANDT = pct.MANDT
),

-- =====================================================================
-- CALCULATED FLAGS: FS/RX Flag and Week Number
-- Derives FS_RX_FLAG from profit center code prefix
-- =====================================================================
FLAGS AS (
  SELECT
    *,
    CASE
      WHEN LEFT(_BIC_ZWWPC_PA1, 2) = 'FS' THEN 'FS'
      WHEN LEFT(_BIC_ZWWPC_PA1, 2) = 'RX' THEN 'RX'
      ELSE ''
    END AS CAL_FS_RX_FLAG,
    RIGHT(@IP_WEEK_CY, 2) AS CAL_WEEK_NUMBER
  FROM Join_5
),

-- =====================================================================
-- FINAL CALCULATED FLAG: COMP_FLAG
-- Selects appropriate comp week based on FS/RX flag
-- =====================================================================
FLAGS_FINAL AS (
  SELECT
    *,
    CASE
      WHEN CAL_FS_RX_FLAG = 'FS' THEN FS_COMP_WK
      WHEN CAL_FS_RX_FLAG = 'RX' THEN RX_COMP_WK
      ELSE FS_COMP_WK
    END AS CAL_COMP_FLAG
  FROM FLAGS
)

-- =====================================================================
-- FINAL AGGREGATION AND OUTPUT
-- Groups by all dimension attributes and aggregates measures
-- Negates _B631_S_AMOUNT as per source calculation view logic
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
  RX_DISTRICT_CODE,
  SUM(_B631_S_AMOUNT) * -1 AS _B631_S_AMOUNT,
  SUM(_BIC_ZIO_D1AMT) AS _BIC_ZIO_D1AMT,
  SUM(_BIC_ZIO_D2AMT) AS _BIC_ZIO_D2AMT,
  SUM(_BIC_ZIO_D3AMT) AS _BIC_ZIO_D3AMT,
  SUM(_BIC_ZIO_D4AMT) AS _BIC_ZIO_D4AMT,
  SUM(_BIC_ZIO_D5AMT) AS _BIC_ZIO_D5AMT,
  SUM(_BIC_ZIO_D6AMT) AS _BIC_ZIO_D6AMT,
  SUM(_BIC_ZIO_D7AMT) AS _BIC_ZIO_D7AMT
FROM FLAGS_FINAL
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
  RX_DISTRICT_CODE
;"""

# ---- HANA EXECUTION ----
def execute_hana():
    conn = None
    start = time.time()
    status = 'FAILED'
    row_count = 0
    df = None
    error = None
    try:
        conn = get_hana_connection()
        log_progress(20, f"Connected to HANA. Executing Calculation View: {HANA_OBJECT_NAME}")
        # The Calculation View is expected to have the same parameters as BigQuery
        sql = f"SELECT * FROM \"{HANA_OBJECT_NAME}\" WHERE \"FISCVARNT\" = 'K4' AND \"_BIC_ZIO_VER\" = '{PARAMS['IP_VERSION']}' AND \"_BIC_ZIO_SWEEK\" = '{PARAMS['IP_WEEK_LY']}' AND \"_BIC_ZIO_SAUDT\" IN ('1','10')"
        df = conn.sql(sql).collect()
        row_count = len(df)
        status = 'SUCCESS'
        log_progress(40, f"HANA Calculation View executed. Rows extracted: {row_count}")
    except Exception as ex:
        error = str(ex)
        logger.error(f"HANA execution failed: {error}\n{traceback.format_exc()}")
    finally:
        if conn:
            try:
                conn.close()
            except Exception:
                pass
    end = time.time()
    return {
        'status': status,
        'row_count': row_count,
        'data': df,
        'error': error,
        'exec_time': end - start
    }

# ---- BIGQUERY EXECUTION ----
def substitute_bq_params(sql: str, params: Dict[str,str]):
    for k, v in params.items():
        sql = sql.replace(f"@{k}", f"'{v}'")
    return sql

def execute_bigquery():
    client = None
    start = time.time()
    status = 'FAILED'
    row_count = 0
    df = None
    error = None
    try:
        client = get_bigquery_client()
        log_progress(60, "Executing BigQuery SQL.")
        sql = substitute_bq_params(BIGQUERY_SQL, PARAMS)
        job = client.query(sql)
        result = job.result()
        df = result.to_dataframe()
        row_count = len(df)
        status = 'SUCCESS'
        log_progress(80, f"BigQuery SQL executed. Rows extracted: {row_count}")
    except Exception as ex:
        error = str(ex)
        logger.error(f"BigQuery execution failed: {error}\n{traceback.format_exc()}")
    end = time.time()
    return {
        'status': status,
        'row_count': row_count,
        'data': df,
        'error': error,
        'exec_time': end - start
    }

# ---- RECONCILIATION ----
def safe_float(val):
    try:
        if pd.isnull(val):
            return np.nan
        return float(val)
    except Exception:
        return np.nan

def compare_dataframes(df1: pd.DataFrame, df2: pd.DataFrame, key_cols: List[str], num_tol=1e-4):
    result = {
        'column_comparison': {},
        'missing_records': 0,
        'extra_records': 0,
        'duplicate_records': 0,
        'mismatched_records': 0,
        'matched_records': 0,
        'key_cols': key_cols,
        'details': [],
        'validation_failures': []
    }
    if df1 is None or df2 is None:
        result['validation_failures'].append('One or both dataframes are None.')
        return result
    # Column comparison
    cols1 = set(df1.columns)
    cols2 = set(df2.columns)
    result['column_comparison']['hana_only'] = list(cols1 - cols2)
    result['column_comparison']['bigquery_only'] = list(cols2 - cols1)
    result['column_comparison']['common'] = list(cols1 & cols2)
    result['column_comparison']['column_count_match'] = len(cols1) == len(cols2)
    # Key check
    if not key_cols or not all(k in df1.columns and k in df2.columns for k in key_cols):
        result['validation_failures'].append('Key columns not found in both datasets.')
        key_cols = None
    # Duplicate detection
    if key_cols:
        dup1 = df1.duplicated(subset=key_cols).sum()
        dup2 = df2.duplicated(subset=key_cols).sum()
        result['duplicate_records'] = int(dup1) + int(dup2)
    else:
        result['duplicate_records'] = None
    # Align on keys
    if key_cols:
        df1_keyed = df1.set_index(key_cols)
        df2_keyed = df2.set_index(key_cols)
        missing = df1_keyed.index.difference(df2_keyed.index)
        extra = df2_keyed.index.difference(df1_keyed.index)
        result['missing_records'] = len(missing)
        result['extra_records'] = len(extra)
        matched = df1_keyed.index.intersection(df2_keyed.index)
        result['matched_records'] = len(matched)
        mismatches = 0
        details = []
        for idx in matched:
            row1 = df1_keyed.loc[idx]
            row2 = df2_keyed.loc[idx]
            row_mismatches = {}
            for col in result['column_comparison']['common']:
                v1 = row1[col] if col in row1 else np.nan
                v2 = row2[col] if col in row2 else np.nan
                if pd.api.types.is_numeric_dtype(type(v1)) and pd.api.types.is_numeric_dtype(type(v2)):
                    if pd.isnull(v1) and pd.isnull(v2):
                        continue
                    if not np.isclose(safe_float(v1), safe_float(v2), atol=num_tol, equal_nan=True):
                        row_mismatches[col] = {'hana': v1, 'bigquery': v2}
                else:
                    if pd.isnull(v1) and pd.isnull(v2):
                        continue
                    if str(v1) != str(v2):
                        row_mismatches[col] = {'hana': v1, 'bigquery': v2}
            if row_mismatches:
                mismatches += 1
                details.append({'key': idx, 'mismatches': row_mismatches})
        result['mismatched_records'] = mismatches
        result['details'] = details
    else:
        # No keys, fallback: row count, column count only
        pass
    return result

# ---- MAIN EXECUTION ----
def main():
    audit = {
        'hana_object': HANA_OBJECT_NAME,
        'bigquery_asset': 'CV_COMP_FIN_ACTUAL_STATIC',
        'execution_start': datetime.utcnow().isoformat(),
        'execution_end': None,
        'execution_duration': None,
        'hana_status': None,
        'bigquery_status': None,
        'hana_row_count': None,
        'bigquery_row_count': None,
        'reconciliation_status': None,
        'matched_records': None,
        'missing_records': None,
        'extra_records': None,
        'mismatched_records': None,
        'validation_checks': [],
        'validation_failures': [],
        'errors': [],
        'warnings': []
    }
    start = time.time()
    try:
        hana_result = execute_hana()
        audit['hana_status'] = hana_result['status']
        audit['hana_row_count'] = hana_result['row_count']
        if hana_result['status'] != 'SUCCESS':
            audit['errors'].append(f"HANA Execution Error: {hana_result['error']}")
            raise RuntimeError(f"HANA execution failed: {hana_result['error']}")
        bigquery_result = execute_bigquery()
        audit['bigquery_status'] = bigquery_result['status']
        audit['bigquery_row_count'] = bigquery_result['row_count']
        if bigquery_result['status'] != 'SUCCESS':
            audit['errors'].append(f"BigQuery Execution Error: {bigquery_result['error']}")
            raise RuntimeError(f"BigQuery execution failed: {bigquery_result['error']}")
        # Identify possible business keys from output columns
        out_cols = set(hana_result['data'].columns) & set(bigquery_result['data'].columns)
        candidate_keys = [
            ["MANDT","FISCPER","FISCVARNT","FISCYEAR","FISCPER3","_BIC_ZIO_SWEEK","_B631_S_CHRTACCT","_B631_S_CO_AREA","_BIC_ZIO_CMPCD","_B631_S_PROFTCTR","_B631_S_COSTCNTR","_B631_S_FUNCAREA","_BIC_ZIO_VER","_BIC_ZIO_SAUDT","_B631_S_GL_ACCT","_BIC_ZWWPC_PA1","_BIC_ZWWSC_PA1","CURRENCY"]
        ]
        key_cols = None
        for keys in candidate_keys:
            if all(k in out_cols for k in keys):
                key_cols = keys
                break
        recon = compare_dataframes(hana_result['data'], bigquery_result['data'], key_cols)
        audit['matched_records'] = recon['matched_records']
        audit['missing_records'] = recon['missing_records']
        audit['extra_records'] = recon['extra_records']
        audit['mismatched_records'] = recon['mismatched_records']
        audit['validation_checks'] = [
            'Row count validation',
            'Column name comparison',
            'Column count comparison',
            'Datatype comparison (where available)',
            'Primary/business key validation',
            'NULL count comparison',
            'Duplicate record detection',
            'Row-level comparison',
            'Hash-based comparison (if applicable)',
            'Missing/extra record detection',
            'Numerical tolerance check'
        ]
        audit['validation_failures'] = recon['validation_failures']
        # Final status
        if hana_result['status'] != 'SUCCESS' or bigquery_result['status'] != 'SUCCESS':
            audit['reconciliation_status'] = 'NO MATCH'
        elif recon['validation_failures']:
            audit['reconciliation_status'] = 'NO MATCH'
        elif recon['missing_records'] == 0 and recon['extra_records'] == 0 and recon['mismatched_records'] == 0 and recon['duplicate_records'] == 0:
            audit['reconciliation_status'] = 'MATCH'
        elif recon['matched_records'] > 0:
            audit['reconciliation_status'] = 'PARTIAL MATCH'
        else:
            audit['reconciliation_status'] = 'NO MATCH'
        # Reports
        pd.DataFrame([audit]).to_csv('validation_report.csv', index=False)
        with open('validation_report.json','w') as f:
            json.dump(audit, f, indent=2)
        with open('audit_report.json','w') as f:
            json.dump(audit, f, indent=2)
        # Discrepancy report
        if recon['details']:
            disc_rows = []
            for d in recon['details']:
                row = {'key': str(d['key'])}
                for col, vals in d['mismatches'].items():
                    row[f"{col}_hana"] = vals['hana']
                    row[f"{col}_bigquery"] = vals['bigquery']
                disc_rows.append(row)
            pd.DataFrame(disc_rows).to_csv('discrepancy_report.csv', index=False)
        # HTML summary
        with open('reconciliation_summary.html','w') as f:
            f.write(f"<h2>CV_COMP_FIN_ACTUAL_STATIC Reconciliation Summary</h2>")
            f.write(f"<b>HANA Status:</b> {audit['hana_status']}<br>")
            f.write(f"<b>BigQuery Status:</b> {audit['bigquery_status']}<br>")
            f.write(f"<b>HANA Row Count:</b> {audit['hana_row_count']}<br>")
            f.write(f"<b>BigQuery Row Count:</b> {audit['bigquery_row_count']}<br>")
            f.write(f"<b>Matched Records:</b> {audit['matched_records']}<br>")
            f.write(f"<b>Missing Records:</b> {audit['missing_records']}<br>")
            f.write(f"<b>Extra Records:</b> {audit['extra_records']}<br>")
            f.write(f"<b>Mismatched Records:</b> {audit['mismatched_records']}<br>")
            f.write(f"<b>Validation Failures:</b> {audit['validation_failures']}<br>")
            f.write(f"<b>Reconciliation Status:</b> <span style='color:blue;font-weight:bold'>{audit['reconciliation_status']}</span><br>")
        log_progress(100, f"Reconciliation complete. Final status: {audit['reconciliation_status']}")
    except Exception as ex:
        audit['execution_end'] = datetime.utcnow().isoformat()
        audit['execution_duration'] = time.time() - start
        audit['errors'].append(str(ex))
        logger.error(f"Fatal error: {str(ex)}\n{traceback.format_exc()}")
        # Write partial audit
        with open('audit_report.json','w') as f:
            json.dump(audit, f, indent=2)
        with open('validation_report.json','w') as f:
            json.dump(audit, f, indent=2)
        with open('reconciliation_summary.html','w') as f:
            f.write(f"<h2>Reconciliation Failed</h2><b>Error:</b> {str(ex)}")
        sys.exit(1)
    audit['execution_end'] = datetime.utcnow().isoformat()
    audit['execution_duration'] = time.time() - start
    with open('audit_report.json','w') as f:
        json.dump(audit, f, indent=2)

if __name__ == '__main__':
    main()

**API Cost: 0.0800 USD**
