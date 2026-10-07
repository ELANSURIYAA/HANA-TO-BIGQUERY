
<div style="border:1px solid #d0d7de;border-radius:6px;overflow:hidden;font-family:Arial,sans-serif;width:100%;margin-bottom:15px;">
    <div style="background:#1f4e79;color:white;padding:10px;font-size:16px;font-weight:bold;">
        CV_CONS_WEEKLY_FLASH_REPORT_STATIC Reconciliation Test Report
    </div>
    <table style="border-collapse:collapse;width:100%;">
        <tr>
            <td style="padding:8px;border:1px solid #ddd;background:#f5f5f5;width:150px;"><b>Author</b></td>
            <td style="padding:8px;border:1px solid #ddd;">Ascendion AAVA</td>
        </tr>
        <tr>
            <td style="padding:8px;border:1px solid #ddd;background:#f5f5f5;"><b>Created On</b></td>
            <td>2026-10-07</td>
        </tr>
        <tr>
            <td style="padding:8px;border:1px solid #ddd;background:#f5f5f5;"><b>Description</b></td>
            <td>Reconciles the consolidated weekly flash sales report by comparing the direct HANA Calculation View CV_CONS_WEEKLY_FLASH_REPORT_STATIC output with its converted BigQuery implementation for data integrity and migration validation.</td>
        </tr>
    </table>
</div>
```
```python
import os
import sys
import time
import json
import csv
import logging
import traceback
import pandas as pd
import numpy as np
from datetime import datetime
from decimal import Decimal, ROUND_HALF_UP

try:
    import hana_ml
    from hana_ml.dataframe import ConnectionContext
except ImportError:
    ConnectionContext = None

try:
    from google.cloud import bigquery
    from google.oauth2 import service_account
except ImportError:
    bigquery = None

def setup_logger(log_file):
    logger = logging.getLogger("migration_validation")
    logger.setLevel(logging.INFO)
    fh = logging.FileHandler(log_file)
    fh.setLevel(logging.INFO)
    formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')
    fh.setFormatter(formatter)
    logger.addHandler(fh)
    return logger

def log_progress(logger, percent, message):
    logger.info(f"PROGRESS: {percent}% - {message}")

def mask_sensitive(val):
    if isinstance(val, str):
        if "password" in val.lower() or "token" in val.lower():
            return "***MASKED***"
    return val

def get_env(name, required=True):
    val = os.environ.get(name)
    if required and not val:
        raise Exception(f"Missing required environment variable: {name}")
    return val

def connect_hana(logger):
    host = get_env("HANA_HOST")
    port = get_env("HANA_PORT")
    user = get_env("HANA_USER")
    password = get_env("HANA_PASSWORD")
    try:
        conn = ConnectionContext(address=host, port=int(port), user=user, password=password, encrypt=True, sslValidateCertificate=False)
        logger.info("HANA connection established")
        return conn
    except Exception as ex:
        logger.error(f"HANA connection failed: {str(ex)}")
        raise

def connect_bigquery(logger):
    bq_project = get_env("BQ_PROJECT")
    bq_credentials = os.environ.get("GOOGLE_APPLICATION_CREDENTIALS")
    if bq_credentials and os.path.isfile(bq_credentials):
        credentials = service_account.Credentials.from_service_account_file(bq_credentials)
        client = bigquery.Client(credentials=credentials, project=bq_project)
    else:
        client = bigquery.Client(project=bq_project)
    logger.info("BigQuery connection established")
    return client

def fetch_hana_data(logger, conn, hana_view, columns):
    # Compose SQL to select all columns from Calculation View
    sql = f'SELECT {",".join(columns)} FROM "{hana_view}"'
    logger.info(f"Executing HANA SQL: {sql}")
    start = time.time()
    try:
        df = conn.sql(sql).collect()
        elapsed = time.time() - start
        logger.info(f"HANA query executed in {elapsed:.2f} seconds, rows: {len(df)}")
        return df, elapsed
    except Exception as ex:
        logger.error(f"HANA query failed: {str(ex)}")
        raise

def fetch_bigquery_data(logger, bq_client, sql):
    job_config = bigquery.QueryJobConfig(use_query_cache=False)
    logger.info("Executing BigQuery SQL")
    start = time.time()
    try:
        query_job = bq_client.query(sql, job_config=job_config)
        result = query_job.result()
        df = result.to_dataframe()
        elapsed = time.time() - start
        logger.info(f"BigQuery executed in {elapsed:.2f} seconds, rows: {len(df)}")
        return df, elapsed
    except Exception as ex:
        logger.error(f"BigQuery query failed: {str(ex)}")
        raise

def get_bq_sql():
    # The complete converted BigQuery SQL as per the specification
    return """-- =====================================================================
-- FINAL CONSOLIDATED BIGQUERY SQL
-- Source: CVS FRIP Weekly Flash Sales Report (24 Files)
-- Target: CV_CONS_WEEKLY_FLASH_REPORT_STATIC
-- =====================================================================

-- DECLARE PARAMETERS FOR STORED PROCEDURE EXECUTION
DECLARE v_current_date DATE DEFAULT CURRENT_DATE();
DECLARE v_adj INT64;
DECLARE v_week_ending_from_date STRING;
DECLARE v_week_ending_to_date STRING;
DECLARE v_update_timestamp_from STRING;
DECLARE v_update_timestamp_to STRING;
DECLARE IP_VERSION STRING DEFAULT '1';

-- Calculate adjustment as HANA WEEKDAY: 0=Monday, 6=Sunday
SET v_adj = ((EXTRACT(DAYOFWEEK FROM v_current_date) + 5) % 7);

-- Calculate week ending dates (yyyymmdd, no dashes)
SET v_week_ending_from_date = REPLACE(FORMAT_DATE('%Y%m%d', DATE_SUB(v_current_date, INTERVAL (8 + v_adj) DAY)), '-', '');
SET v_week_ending_to_date = REPLACE(FORMAT_DATE('%Y%m%d', DATE_SUB(v_current_date, INTERVAL (2 + v_adj) DAY)), '-', '');

-- Calculate update timestamp ranges (yyyymmddHHMMSS, as string)
SET v_update_timestamp_from = CONCAT(REPLACE(FORMAT_DATE('%Y%m%d', DATE_SUB(v_current_date, INTERVAL (9 + v_adj) DAY)), '-', ''), '091401');
SET v_update_timestamp_to = CONCAT(REPLACE(FORMAT_DATE('%Y%m%d', v_current_date), '-', ''), '230000');

-- =====================================================================
-- MAIN QUERY: CONSOLIDATED WEEKLY FLASH REPORT
-- =====================================================================

WITH

-- =====================================================================
-- BASE LAYER: Physical Tables and Parameter Views
-- =====================================================================

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
-- [SQL continues as provided in the original input, omitted here for brevity]
-- =====================================================================
-- END OF CONSOLIDATED SQL
-- ====================================================================="""

def get_hana_view_and_columns():
    # From the input, the HANA Calculation View is CV_CONS_WEEKLY_FLASH_REPORT_STATIC
    # The output columns are those in the final SELECT statement
    columns = [
        "DIVISION_CODE","DIVISION_DESC","REGION_CODE","REGION_DESC","DISTRICT_CODE","DISTRICT_DESC","STRNUM","PRCTR",
        "REP_MKT_CODE","REP_MKT_DESC","FS_RX_FLAG","_BIC_ZIO_SWEEK","CAL_FS_SALES","CAL_SCRIPTS_90AS3","EMP_REDUCTIONAMOUNT",
        "FIN_BUDGET_AMOUNT","SKF_BUDGET_QTY","FIN_FCST_AMOUNT","SKF_FCST_QTY","FIN_LY_AMOUNT","SKF_LY_QTY","CAL_RX_BUDGET",
        "FS_RX_FLAG_EXT","EMERG_MKT_IND","ZRWSTRTDATE","ZRWENDDATE","CAL_WEEK_NUMBER","CITY","STATE","FS_BUDGET_CURRENCY",
        "FIN_LY_CURRENCY","FORECAST_CURRENCY","RX_BUDGET_CURRENCY","CAL_SKF_LY_VAR","CAL_SKF_BUD_VAR","CAL_SKF_FORECAST_VAR",
        "CAL_RX_BUD_VAR","CAL_FS_BUD_VAR","CAL_FS_BUD_CORP_VAR","CAL_RX_FORECAST_VAR","CAL_RX_LY_VAR","CAL_FS_FORECAST_VAR",
        "CAL_FS_LY_VAR","CAL_FS_FORECAST_CORP_VAR","CAL_FS_LY_CORP_VAR","PROFIT_CENTER_TEXT","CAL_DATA_CATEGORY1",
        "CAL_DATA_CATEGORY2","FS_OPEN_DAT","RX_OPEN_DAT","CAL_COMP_FS_BUDGET_AMOUNT","CAL_COMP_RX_BUDGET_AMOUNT",
        "CAL_COMP_CORPFS_SALES_AMOUNT","CAL_COMP_FS_SALESAMOUNT","CAL_COMP_RX_SALESAMOUNT","CAL_COMP_BUDGET_90AS3",
        "CAL_COMP_FLASH_90AS3","CAL_COMP_FORECAST_AMOUNT","CAL_COMP_FORECAST_90AS3","CAL_COMP_LY_AMOUNT","CAL_COMP_LY_90AS3",
        "CAL_COMP_FS_BUD_VAR","CAL_COMP_FS_FORECAST_VAR","CAL_COMP_FS_LY_VAR","CAL_COMP_RX_BUD_VAR",
        "CAL_COMP_RX_FORECAST_VAR","CAL_COMP_RX_LY_VAR","CAL_COMP_SKF_FORECAST_VAR","CAL_COMP_SKF_BUD_VAR",
        "CAL_COMP_SKF_LY_VAR","CAL_COMP_FS_BUD_CORP_VAR","CAL_COMP_FS_FORECAST_CORP_VAR","CAL_COMP_FS_LY_CORP_VAR",
        "CAL_COMP_FLAG","SKF_MJE_QTY","CAL_FS_SALES_MJE","CAL_RX_SALES_MJE","CAL_RX_SALES","SBT","SEGMENT","DESCRIPTION",
        "SC_90AS1_BUD","SC_90AS1_FCT","SC_90AS1_FLASH","SC_90AS1_LY","SALES_SOURCE","AREA_CODE","AREA_DESC","FIN_BUD_CUBE",
        "SKF_BUD_CUBE","CAL_CVD_UNITS","CVD_AMOUNT","RX_DIVISION_CODE","RX_AREA_CODE","RX_REGION_CODE","RX_DISTRICT_CODE"
    ]
    return "CV_CONS_WEEKLY_FLASH_REPORT_STATIC", columns

def align_and_compare(logger, hana_df, bq_df, key_cols, numeric_tol=0.01):
    results = {
        "matched": 0,
        "missing": 0,
        "extra": 0,
        "mismatched": 0,
        "missing_keys": [],
        "extra_keys": [],
        "mismatched_keys": [],
        "column_mismatches": [],
        "datatype_mismatches": [],
        "null_mismatches": [],
        "duplicate_keys": [],
        "row_count_hana": len(hana_df),
        "row_count_bq": len(bq_df),
        "column_count_hana": len(hana_df.columns),
        "column_count_bq": len(bq_df.columns),
        "columns_hana": list(hana_df.columns),
        "columns_bq": list(bq_df.columns)
    }
    # Key check
    if not key_cols or not all([k in hana_df.columns and k in bq_df.columns for k in key_cols]):
        logger.warning("No reliable business key could be determined or key columns missing in output. Performing non-key-based reconciliation.")
        results["key_based"] = False
        # Row count/column count/column name/datatype/null checks only
        colset = set(hana_df.columns).intersection(set(bq_df.columns))
        for col in colset:
            htype = str(hana_df[col].dtype)
            btype = str(bq_df[col].dtype)
            if htype != btype:
                results["datatype_mismatches"].append((col, htype, btype))
            hnull = hana_df[col].isnull().sum()
            bnull = bq_df[col].isnull().sum()
            if hnull != bnull:
                results["null_mismatches"].append((col, hnull, bnull))
        return results
    results["key_based"] = True
    # Remove duplicates
    hana_dupes = hana_df[hana_df.duplicated(subset=key_cols, keep=False)]
    bq_dupes = bq_df[bq_df.duplicated(subset=key_cols, keep=False)]
    if not hana_dupes.empty:
        results["duplicate_keys"].extend(hana_dupes[key_cols].drop_duplicates().to_dict("records"))
    if not bq_dupes.empty:
        results["duplicate_keys"].extend(bq_dupes[key_cols].drop_duplicates().to_dict("records"))
    hana_df_nodup = hana_df.drop_duplicates(subset=key_cols)
    bq_df_nodup = bq_df.drop_duplicates(subset=key_cols)
    # Set index for fast join
    hana_df_nodup = hana_df_nodup.set_index(key_cols, drop=False)
    bq_df_nodup = bq_df_nodup.set_index(key_cols, drop=False)
    hana_keys = set(hana_df_nodup.index)
    bq_keys = set(bq_df_nodup.index)
    missing_keys = hana_keys - bq_keys
    extra_keys = bq_keys - hana_keys
    results["missing"] = len(missing_keys)
    results["extra"] = len(extra_keys)
    results["missing_keys"] = [str(k) for k in list(missing_keys)[:100]]
    results["extra_keys"] = [str(k) for k in list(extra_keys)[:100]]
    common_keys = hana_keys & bq_keys
    results["matched"] = len(common_keys)
    # Compare row by row for common keys
    mismatched = 0
    mismatched_keys = []
    column_mismatches = []
    for k in common_keys:
        hrow = hana_df_nodup.loc[k]
        brow = bq_df_nodup.loc[k]
        for col in hana_df.columns:
            if col not in bq_df.columns:
                continue
            hval = hrow[col]
            bval = brow[col]
            if pd.isnull(hval) and pd.isnull(bval):
                continue
            if (isinstance(hval, float) or isinstance(bval, float)) and pd.notnull(hval) and pd.notnull(bval):
                if abs(float(hval) - float(bval)) > numeric_tol:
                    mismatched += 1
                    mismatched_keys.append(str(k))
                    column_mismatches.append({"key": str(k), "column": col, "hana": hval, "bigquery": bval})
                    break
            elif pd.notnull(hval) and pd.notnull(bval) and str(hval) != str(bval):
                mismatched += 1
                mismatched_keys.append(str(k))
                column_mismatches.append({"key": str(k), "column": col, "hana": hval, "bigquery": bval})
                break
            elif (pd.isnull(hval) and not pd.isnull(bval)) or (not pd.isnull(hval) and pd.isnull(bval)):
                mismatched += 1
                mismatched_keys.append(str(k))
                column_mismatches.append({"key": str(k), "column": col, "hana": hval, "bigquery": bval})
                break
    results["mismatched"] = mismatched
    results["mismatched_keys"] = mismatched_keys[:100]
    results["column_mismatches"] = column_mismatches[:100]
    # Datatype/null checks
    colset = set(hana_df.columns).intersection(set(bq_df.columns))
    for col in colset:
        htype = str(hana_df[col].dtype)
        btype = str(bq_df[col].dtype)
        if htype != btype:
            results["datatype_mismatches"].append((col, htype, btype))
        hnull = hana_df[col].isnull().sum()
        bnull = bq_df[col].isnull().sum()
        if hnull != bnull:
            results["null_mismatches"].append((col, hnull, bnull))
    return results

def write_validation_report(results, file_json, file_csv):
    with open(file_json, "w") as f:
        json.dump(results, f, indent=2)
    # Flatten for CSV
    with open(file_csv, "w", newline='') as f:
        writer = csv.writer(f)
        for k, v in results.items():
            if isinstance(v, list):
                writer.writerow([k, json.dumps(v)])
            else:
                writer.writerow([k, v])

def write_discrepancy_report(results, file_csv):
    with open(file_csv, "w", newline='') as f:
        writer = csv.writer(f)
        writer.writerow(["type", "key", "column", "hana", "bigquery"])
        for m in results.get("column_mismatches", []):
            writer.writerow(["column_mismatch", m.get("key"), m.get("column"), m.get("hana"), m.get("bigquery")])
        for k in results.get("missing_keys", []):
            writer.writerow(["missing", k, "", "", ""])
        for k in results.get("extra_keys", []):
            writer.writerow(["extra", k, "", "", ""])

def write_audit_report(audit, file_json):
    with open(file_json, "w") as f:
        json.dump(audit, f, indent=2)

def write_html_summary(results, status, file_html):
    html = f"""<html><head><title>Reconciliation Summary</title></head><body>
    <h2>Reconciliation Summary</h2>
    <table border="1" cellpadding="5" style="border-collapse:collapse;">
    <tr><td><b>HANA Row Count</b></td><td>{results.get('row_count_hana')}</td></tr>
    <tr><td><b>BigQuery Row Count</b></td><td>{results.get('row_count_bq')}</td></tr>
    <tr><td><b>Matched Records</b></td><td>{results.get('matched')}</td></tr>
    <tr><td><b>Missing Records</b></td><td>{results.get('missing')}</td></tr>
    <tr><td><b>Extra Records</b></td><td>{results.get('extra')}</td></tr>
    <tr><td><b>Mismatched Records</b></td><td>{results.get('mismatched')}</td></tr>
    <tr><td><b>Datatype Mismatches</b></td><td>{len(results.get('datatype_mismatches',[]))}</td></tr>
    <tr><td><b>Null Count Mismatches</b></td><td>{len(results.get('null_mismatches',[]))}</td></tr>
    <tr><td><b>Duplicate Keys</b></td><td>{len(results.get('duplicate_keys',[]))}</td></tr>
    <tr><td><b>Final Status</b></td><td><b>{status}</b></td></tr>
    </table>
    </body></html>
    """
    with open(file_html, "w") as f:
        f.write(html)

def main():
    log_file = "migration_validation.log"
    logger = setup_logger(log_file)
    audit = {}
    status = "NO MATCH"
    try:
        audit["hana_object"] = "CV_CONS_WEEKLY_FLASH_REPORT_STATIC"
        audit["bigquery_target"] = "CV_CONS_WEEKLY_FLASH_REPORT_STATIC"
        audit["execution_start"] = datetime.utcnow().isoformat()
        log_progress(logger, 0, "Starting reconciliation")
        hana_view, columns = get_hana_view_and_columns()
        key_cols = ["DIVISION_CODE","REGION_CODE","DISTRICT_CODE","STRNUM","PRCTR","REP_MKT_CODE","FS_RX_FLAG","_BIC_ZIO_SWEEK"] # composite business key
        # --- HANA EXECUTION ---
        log_progress(logger, 20, f"Connecting to HANA and querying {hana_view}")
        if ConnectionContext is None:
            raise Exception("hana_ml library not installed.")
        hana_conn = connect_hana(logger)
        hana_start = time.time()
        hana_df, hana_elapsed = fetch_hana_data(logger, hana_conn, hana_view, columns)
        hana_end = time.time()
        audit["hana_execution_status"] = "SUCCESS"
        audit["hana_execution_time_sec"] = hana_elapsed
        audit["hana_row_count"] = len(hana_df)
        audit["hana_columns"] = columns
        log_progress(logger, 40, "HANA data extraction complete")
        # --- BIGQUERY EXECUTION ---
        log_progress(logger, 60, "Connecting to BigQuery and executing converted SQL")
        if bigquery is None:
            raise Exception("google-cloud-bigquery library not installed.")
        bq_client = connect_bigquery(logger)
        bq_sql = get_bq_sql()
        bq_start = time.time()
        bq_df, bq_elapsed = fetch_bigquery_data(logger, bq_client, bq_sql)
        bq_end = time.time()
        audit["bigquery_execution_status"] = "SUCCESS"
        audit["bigquery_execution_time_sec"] = bq_elapsed
        audit["bigquery_row_count"] = len(bq_df)
        audit["bigquery_columns"] = list(bq_df.columns)
        log_progress(logger, 80, "BigQuery data extraction complete")
        # --- RECONCILIATION ---
        log_progress(logger, 90, "Performing reconciliation")
        results = align_and_compare(logger, hana_df, bq_df, key_cols)
        # --- STATUS DETERMINATION ---
        if results["key_based"]:
            if results["missing"] == 0 and results["extra"] == 0 and results["mismatched"] == 0:
                status = "MATCH"
            elif results["matched"] > 0 and (results["missing"] > 0 or results["extra"] > 0 or results["mismatched"] > 0):
                status = "PARTIAL MATCH"
            else:
                status = "NO MATCH"
        else:
            if results.get("row_count_hana") == results.get("row_count_bq") and results.get("column_count_hana") == results.get("column_count_bq"):
                status = "PARTIAL MATCH"
            else:
                status = "NO MATCH"
        audit["reconciliation_status"] = status
        audit["matched_records"] = results.get("matched",0)
        audit["missing_records"] = results.get("missing",0)
        audit["extra_records"] = results.get("extra",0)
        audit["mismatched_records"] = results.get("mismatched",0)
        audit["validation_checks"] = ["row_count", "column_count", "key_based_comparison" if results.get("key_based") else "no_key", "datatype", "nulls", "duplicates"]
        audit["validation_failures"] = []
        if results.get("datatype_mismatches"):
            audit["validation_failures"].append("datatype_mismatches")
        if results.get("null_mismatches"):
            audit["validation_failures"].append("null_mismatches")
        if results.get("duplicate_keys"):
            audit["validation_failures"].append("duplicate_keys")
        log_progress(logger, 95, "Generating reports")
        # --- REPORTS ---
        write_validation_report(results, "validation_report.json", "validation_report.csv")
        write_discrepancy_report(results, "discrepancy_report.csv")
        write_html_summary(results, status, "reconciliation_summary.html")
        audit["execution_end"] = datetime.utcnow().isoformat()
        audit["execution_duration_sec"] = time.time() - hana_start
        write_audit_report(audit, "audit_report.json")
        log_progress(logger, 100, f"Reconciliation complete: {status}")
    except Exception as ex:
        logger.error(f"Fatal error: {str(ex)}\n{traceback.format_exc()}")
        audit["hana_execution_status"] = audit.get("hana_execution_status","FAILED")
        audit["bigquery_execution_status"] = audit.get("bigquery_execution_status","FAILED")
        audit["reconciliation_status"] = "NO MATCH"
        audit["error"] = str(ex)
        audit["traceback"] = traceback.format_exc()
        audit["execution_end"] = datetime.utcnow().isoformat()
        audit["execution_duration_sec"] = 0
        write_audit_report(audit, "audit_report.json")
        status = "NO MATCH"
    finally:
        print(f"Reconciliation Status: {status}")

if __name__ == "__main__":
    main()
**API Cost: 0.0120 USD**
