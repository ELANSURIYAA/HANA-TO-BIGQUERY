<div style="border:1px solid #d0d7de;border-radius:6px;overflow:hidden;font-family:Arial,sans-serif;width:100%;margin-bottom:15px;">
    <div style="background:#1f4e79;color:white;padding:10px;font-size:16px;font-weight:bold;">
        CV_COMP_FIN_BUDGET_STATIC Reconciliation Test Report
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
            <td>Validates data consistency between HANA CV_COMP_FIN_BUDGET_STATIC and its converted BigQuery implementation by comparing all output columns, aggregations, and logic for weekly budget consolidation.</td>
        </tr>
    </table>
</div>

import os
import sys
import json
import csv
import time
import traceback
import logging
import pandas as pd
from datetime import datetime
from decimal import Decimal, ROUND_HALF_UP
from typing import List, Dict, Any

try:
    import hana_ml.dataframe as hana_df
except ImportError:
    hana_df = None

try:
    from google.cloud import bigquery
except ImportError:
    bigquery = None

def mask_sensitive(val):
    if isinstance(val, str):
        return val[:3] + '***' + val[-3:] if len(val) > 6 else '***'
    return '***'

def setup_logger(log_file):
    logging.basicConfig(
        filename=log_file,
        filemode='w',
        level=logging.INFO,
        format='%(asctime)s %(levelname)s %(message)s'
    )
    return logging.getLogger('recon_logger')

def log_progress(logger, percent, message):
    logger.info(f"PROGRESS {percent}%: {message}")

def get_env(var, required=True):
    val = os.environ.get(var)
    if not val and required:
        raise EnvironmentError(f"Missing required environment variable: {var}")
    return val

def get_hana_connection(logger):
    if hana_df is None:
        logger.error('hana_ml is not installed.')
        raise ImportError('hana_ml is required for HANA connectivity.')
    host = get_env('HANA_HOST')
    port = get_env('HANA_PORT')
    user = get_env('HANA_USER')
    password = get_env('HANA_PASSWORD')
    try:
        conn = hana_df.ConnectionContext(
            address=host,
            port=int(port),
            user=user,
            password=password,
            encrypt=True
        )
        return conn
    except Exception as e:
        logger.error(f"HANA connection failed: {str(e)}")
        raise

def get_bigquery_client(logger):
    if bigquery is None:
        logger.error('google-cloud-bigquery is not installed.')
        raise ImportError('google-cloud-bigquery is required for BigQuery connectivity.')
    try:
        client = bigquery.Client()
        return client
    except Exception as e:
        logger.error(f"BigQuery connection failed: {str(e)}")
        raise

def execute_hana_query(conn, logger, query):
    try:
        start = time.time()
        df = conn.sql(query).collect()
        end = time.time()
        logger.info(f"HANA query executed in {end - start:.2f}s. Rows: {len(df)}")
        return df, {'execution_time': end - start, 'row_count': len(df), 'status': 'SUCCESS'}
    except Exception as e:
        logger.error(f"HANA query execution failed: {str(e)}")
        return None, {'execution_time': 0, 'row_count': 0, 'status': 'FAILED', 'error': str(e)}

def execute_bigquery_query(client, logger, query):
    try:
        start = time.time()
        job = client.query(query)
        df = job.result().to_dataframe()
        end = time.time()
        logger.info(f"BigQuery executed in {end - start:.2f}s. Rows: {len(df)}")
        return df, {'execution_time': end - start, 'row_count': len(df), 'status': 'SUCCESS', 'job_id': str(job.job_id)}
    except Exception as e:
        logger.error(f"BigQuery execution failed: {str(e)}")
        return None, {'execution_time': 0, 'row_count': 0, 'status': 'FAILED', 'error': str(e)}

def safe_float(val):
    try:
        if pd.isnull(val):
            return None
        return float(val)
    except Exception:
        return None

def safe_str(val):
    try:
        if pd.isnull(val):
            return None
        return str(val)
    except Exception:
        return None

def hash_row(row, key_cols):
    return '|'.join([str(row[k]) if k in row and not pd.isnull(row[k]) else '' for k in key_cols])

def compare_dataframes(df1, df2, key_cols, numeric_tol=0.01, logger=None):
    summary = {
        'matched': 0,
        'missing': 0,
        'extra': 0,
        'mismatched': 0,
        'col_mismatches': [],
        'null_mismatches': [],
        'dtype_mismatches': [],
        'duplicates': {'hana': 0, 'bq': 0},
        'key': key_cols,
        'row_count_hana': len(df1),
        'row_count_bq': len(df2)
    }
    discrepancies = []
    if not key_cols:
        summary['error'] = 'No key columns provided for reconciliation.'
        return summary, discrepancies
    # Detect duplicates
    dups_hana = df1.duplicated(subset=key_cols).sum()
    dups_bq = df2.duplicated(subset=key_cols).sum()
    summary['duplicates']['hana'] = int(dups_hana)
    summary['duplicates']['bq'] = int(dups_bq)
    if dups_hana > 0 or dups_bq > 0:
        if logger: logger.warning(f"Duplicates detected: HANA={dups_hana}, BQ={dups_bq}")
    # Set index for join
    df1i = df1.set_index(key_cols)
    df2i = df2.set_index(key_cols)
    # Find missing and extra
    idx1 = set(df1i.index)
    idx2 = set(df2i.index)
    missing = idx1 - idx2
    extra = idx2 - idx1
    summary['missing'] = len(missing)
    summary['extra'] = len(extra)
    for k in missing:
        discrepancies.append({'type': 'missing', 'key': k})
    for k in extra:
        discrepancies.append({'type': 'extra', 'key': k})
    # Matched keys
    common = idx1 & idx2
    summary['matched'] = len(common)
    # Compare values
    col_mismatches = []
    for k in common:
        row1 = df1i.loc[k]
        row2 = df2i.loc[k]
        if isinstance(row1, pd.DataFrame):
            row1 = row1.iloc[0]
        if isinstance(row2, pd.DataFrame):
            row2 = row2.iloc[0]
        for col in df1.columns:
            if col not in df2.columns:
                summary['col_mismatches'].append(col)
                continue
            v1 = row1[col]
            v2 = row2[col]
            if pd.isnull(v1) and pd.isnull(v2):
                continue
            if (isinstance(v1, float) or isinstance(v1, int)) and (isinstance(v2, float) or isinstance(v2, int)):
                if abs(float(v1) - float(v2)) > numeric_tol:
                    discrepancies.append({'type': 'value_mismatch', 'key': k, 'column': col, 'hana': v1, 'bq': v2})
            else:
                if str(v1) != str(v2):
                    discrepancies.append({'type': 'value_mismatch', 'key': k, 'column': col, 'hana': v1, 'bq': v2})
    summary['mismatched'] = len([d for d in discrepancies if d['type'] == 'value_mismatch'])
    return summary, discrepancies

def write_json(filename, data):
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, default=str)

def write_csv(filename, data, fieldnames=None):
    with open(filename, 'w', newline='', encoding='utf-8') as f:
        if not fieldnames and data:
            fieldnames = list(data[0].keys())
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(data)

def write_html_summary(filename, summary, status):
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(f'<html><head><title>Reconciliation Summary</title></head><body>')
        f.write(f'<h2>Reconciliation Status: {status}</h2>')
        f.write('<pre>')
        f.write(json.dumps(summary, indent=2))
        f.write('</pre></body></html>')

def main():
    log_file = 'migration_validation.log'
    logger = setup_logger(log_file)
    audit = {'hana_object': 'CV_COMP_FIN_BUDGET_STATIC', 'bigquery_artifact': 'CV_COMP_FIN_BUDGET_STATIC'}
    start_time = datetime.utcnow()
    audit['execution_start'] = start_time.isoformat()
    try:
        log_progress(logger, 20, 'Connecting to HANA and executing source object.')
        hana_conn = get_hana_connection(logger)
        # The HANA Calculation View name is CV_COMP_FIN_BUDGET_STATIC
        hana_query = 'SELECT * FROM CV_COMP_FIN_BUDGET_STATIC'
        hana_df, hana_meta = execute_hana_query(hana_conn, logger, hana_query)
        audit['hana_execution'] = hana_meta
        if hana_meta['status'] != 'SUCCESS' or hana_df is None or hana_df.empty:
            raise Exception('HANA execution failed or returned no data.')
        log_progress(logger, 40, 'Extracted HANA output.')
        log_progress(logger, 60, 'Executing BigQuery implementation.')
        bq_client = get_bigquery_client(logger)
        bigquery_sql = """
WITH
-- =====================================================================================
-- BASE DATA SOURCES (Physical Tables)
-- =====================================================================================

-- Source: AZSRP_DS052_VT_S4 (Frozen Cube data for budget)
Frozen_Cube_Base AS (
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

-- Source: AZSRP_DS041_VT_S4 (Live Cube data for budget)
Live_Cube_Base AS (
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

-- =====================================================================================
-- CV_BASE_FIN_WEEKLY_BUDGET_S4 (Inlined)
-- Union of Frozen and Live Cube with calculated measure logic
-- =====================================================================================

Union_Budget AS (
  SELECT * FROM Frozen_Cube_Base
  UNION ALL
  SELECT * FROM Live_Cube_Base
),

Aggregated_Budget AS (
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
    Union_Budget
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

RES_AMOUNTS_Budget AS (
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
    Aggregated_Budget
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

CV_BASE_FIN_WEEKLY_BUDGET_S4 AS (
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
    IF(RES_AMOUNT_FC IS NULL OR RES_AMOUNT_FC = 0, RES_AMOUNT_LC, RES_AMOUNT_FC) AS _B631_S_AMOUNT,
    _BIC_ZIO_AMT
  FROM
    RES_AMOUNTS_Budget
),

-- =====================================================================================
-- CV_BASE_MD_HRRP_NODE_S4 (Inlined)
-- Hierarchy node data
-- =====================================================================================

CV_BASE_MD_HRRP_NODE_S4 AS (
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
),

-- =====================================================================================
-- CV_BASE_MD_SRPACT_S4 (Inlined)
-- Store attributes from base table (used by stored procedure)
-- =====================================================================================

CV_BASE_MD_SRPACT_S4 AS (
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

-- =====================================================================================
-- CV_BASE_MD_COMPFL_S4 (Inlined - NOT USED in final lineage)
-- This view is used by STP_WSS_SRP_ATTRIBUTES but not directly by CV_COMP_FIN_BUDGET_STATIC
-- Included for completeness but marked as NOT USED in final consolidation
-- =====================================================================================

CV_BASE_MD_COMPFL_S4 AS (
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

-- =====================================================================================
-- CV_COMP_MD_SRPACT_STATIC (Inlined)
-- Store attributes aggregated from ETL table (populated by stored procedure from CV_BASE_MD_SRPACT_S4)
-- For consolidation, we trace back to the original source: CV_BASE_MD_SRPACT_S4
-- =====================================================================================

CV_COMP_MD_SRPACT_STATIC AS (
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
    RX_DISTRICT_CODE,
    RX_HRS_OPER,
    FS_HRS_OPER,
    RX_STORE,
    RETAIL_SQFT_AMT,
    TOTAL_SQFT_AMT
  FROM
    CV_BASE_MD_SRPACT_S4
),

-- =====================================================================================
-- CV_COMP_MD_COMPFL_STATIC (Inlined)
-- Comp flags from ETL table (populated by stored procedure)
-- For consolidation, we use the ETL table directly as the stored procedure is procedural
-- =====================================================================================

CV_COMP_MD_COMPFL_STATIC AS (
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
    `PROJECT.DATASET.TBL_WSS_SRP_COMPFLAG`
),

-- =====================================================================================
-- CV_BASE_MD_RCALWEEK_S4 (Inlined)
-- Calendar week master data
-- =====================================================================================

CV_BASE_MD_RCALWEEK_S4 AS (
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

-- =====================================================================================
-- CV_BASE_MD_CEPCT_S4 (Inlined)
-- Profit center text
-- =====================================================================================

CV_BASE_MD_CEPCT_S4 AS (
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

-- =====================================================================================
-- CV_COMP_FIN_BUDGET_STATIC - MAIN CONSOLIDATION LOGIC
-- =====================================================================================

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
    _BIC_ZIO_AMT,
    'BUDGET' AS FLAG
  FROM CV_BASE_FIN_WEEKLY_BUDGET_S4
  WHERE
    FISCVARNT = 'K4'
    AND _BIC_ZIO_SWEEK BETWEEN @IP_WEEK_ENDING_FROM AND @IP_WEEK_ENDING_TO
    AND _BIC_ZIO_VER = @IP_VERSION
    AND _BIC_ZIO_SAUDT IN ('1', '10')
),

HIER_NODE AS (
  SELECT
    MANDT,
    PARNODE,
    HRYVALTO,
    NODEVALUE
  FROM CV_BASE_MD_HRRP_NODE_S4
  WHERE
    (PARNODE LIKE '%CORE_RET')
    AND HRYVALTO = '99991231'
),

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

STORE_ATTR_ACTUAL AS (
  SELECT
    MANDT,
    STRNUM,
    PRCTR,
    REP_MKT_CODE,
    REP_MKT_DESC,
    EMERG_MKT_IND,
    DIVISION_CODE,
    DIVISION_DESC,
    AREA_CODE,
    AREA_DESC,
    DISTRICT_CODE,
    DISTRICT_DESC,
    REGION_CODE,
    REGION_DESC,
    CITY,
    STATE,
    FS_OPEN_DAT,
    RX_OPEN_DAT,
    RX_DIVISION_CODE,
    RX_AREA_CODE,
    RX_REGION_CODE,
    RX_DISTRICT_CODE
  FROM CV_COMP_MD_SRPACT_STATIC
),

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
  FROM CV_COMP_MD_COMPFL_STATIC
  WHERE COMP_VER = @IP_VERSION
),

Join_3 AS (
  SELECT
    w.*,
    c.FS_COMP_WK,
    c.RX_COMP_WK
  FROM WEEK_NUMBER w
  LEFT JOIN COMP_FLAG_BUDGET c
    ON w._B631_S_PROFTCTR = c.PRCTR AND w._BIC_ZIO_SWEEK = c.ZWEEK
),

CAL_WEEK AS (
  SELECT
    ZZWEEK,
    ZRWSTRTDATE,
    ZRWENDDATE,
    RCLNT
  FROM CV_BASE_MD_RCALWEEK_S4
),

Join_4 AS (
  SELECT
    j.*,
    c.ZRWSTRTDATE,
    c.ZRWENDDATE
  FROM Join_3 j
  LEFT JOIN CAL_WEEK c
    ON j._BIC_ZIO_SWEEK = c.ZZWEEK
),

PROFIT_CENTER_TEXT AS (
  SELECT
    MANDT,
    PRCTR,
    LTEXT AS PROFIT_CENTER_TEXT
  FROM CV_BASE_MD_CEPCT_S4
),

Join_5 AS (
  SELECT
    j.*,
    p.PROFIT_CENTER_TEXT
  FROM Join_4 j
  LEFT JOIN PROFIT_CENTER_TEXT p
    ON j._B631_S_PROFTCTR = p.PRCTR
),

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
    FLAG,
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
  FLAG AS FIN_BUD_CUBE,
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
  FLAG,
  RX_DIVISION_CODE,
  RX_AREA_CODE,
  RX_REGION_CODE,
  RX_DISTRICT_CODE
"""
        bq_df, bq_meta = execute_bigquery_query(bq_client, logger, bigquery_sql)
        audit['bigquery_execution'] = bq_meta
        if bq_meta['status'] != 'SUCCESS' or bq_df is None or bq_df.empty:
            raise Exception('BigQuery execution failed or returned no data.')
        log_progress(logger, 80, 'Reconciling HANA and BigQuery outputs.')
        # Identify business keys (from GROUP BY in SQL and Calculation View)
        key_cols = [
            'MANDT','FISCPER','FISCVARNT','FISCYEAR','FISCPER3','_BIC_ZIO_SWEEK','_B631_S_CHRTACCT','_B631_S_CO_AREA',
            '_BIC_ZIO_CMPCD','_B631_S_PROFTCTR','FS_RX_FLAG','_B631_S_COSTCNTR','_B631_S_FUNCAREA','_BIC_ZIO_VER',
            '_BIC_ZIO_SAUDT','_B631_S_GL_ACCT','_BIC_ZWWPC_PA1','_BIC_ZWWSC_PA1','CURRENCY','REP_MKT_CODE',
            'REP_MKT_DESC','EMERG_MKT_IND','FS_COMP_WK','RX_COMP_WK','COMP_FLAG','DIVISION_CODE','DIVISION_DESC',
            'AREA_CODE','AREA_DESC','DISTRICT_CODE','DISTRICT_DESC','STRNUM','REGION_CODE','REGION_DESC','ZRWSTRTDATE',
            'ZRWENDDATE','CAL_WEEK_NUMBER','CITY','STATE','PROFIT_CENTER_TEXT','FS_OPEN_DAT','RX_OPEN_DAT',
            'FIN_BUD_CUBE','RX_DIVISION_CODE','RX_AREA_CODE','RX_REGION_CODE','RX_DISTRICT_CODE'
        ]
        # Standardize column names
        hana_df.columns = [c.upper() for c in hana_df.columns]
        bq_df.columns = [c.upper() for c in bq_df.columns]
        # Ensure key columns exist
        missing_keys = [k for k in key_cols if k not in hana_df.columns or k not in bq_df.columns]
        if missing_keys:
            logger.error(f"Key columns missing: {missing_keys}")
            raise Exception(f"Key columns missing: {missing_keys}")
        summary, discrepancies = compare_dataframes(hana_df, bq_df, key_cols, numeric_tol=0.01, logger=logger)
        log_progress(logger, 95, 'Generating discrepancy and validation results.')
        write_json('validation_report.json', summary)
        write_csv('validation_report.csv', [summary])
        write_csv('discrepancy_report.csv', discrepancies)
        status = 'MATCH' if summary['missing']==0 and summary['extra']==0 and summary['mismatched']==0 else ('PARTIAL MATCH' if summary['matched']>0 else 'NO MATCH')
        log_progress(logger, 100, 'Generating final reports and audit output.')
        write_html_summary('reconciliation_summary.html', summary, status)
        audit['execution_end'] = datetime.utcnow().isoformat()
        audit['execution_duration_sec'] = (datetime.utcnow() - start_time).total_seconds()
        audit['reconciliation_status'] = status
        audit['validation_summary'] = summary
        audit['discrepancy_count'] = len(discrepancies)
        audit['error'] = None
        write_json('audit_report.json', audit)
    except Exception as ex:
        audit['execution_end'] = datetime.utcnow().isoformat()
        audit['execution_duration_sec'] = (datetime.utcnow() - start_time).total_seconds()
        audit['reconciliation_status'] = 'NO MATCH'
        audit['error'] = str(ex)
        logger.error(traceback.format_exc())
        write_json('audit_report.json', audit)
        with open('reconciliation_summary.html', 'w', encoding='utf-8') as f:
            f.write(f'<html><head><title>Reconciliation Summary</title></head><body>')
            f.write(f'<h2>Reconciliation Status: NO MATCH</h2>')
            f.write(f'<pre>{str(ex)}</pre></body></html>')
        sys.exit(1)

if __name__ == '__main__':
    main()

**API Cost: 0.1600 USD**
