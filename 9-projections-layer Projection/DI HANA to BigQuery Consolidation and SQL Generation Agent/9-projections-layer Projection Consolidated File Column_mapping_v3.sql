-- =============================================================================
-- CONSOLIDATED BIGQUERY SQL
-- Final Consumer  : CV_COMP_FIN_FLASH_COMBINED_STATIC  (9-projections-layer.xml)
-- Source Artifact : SAP HANA Calculation View (dataCategory=CUBE,
--                   outputViewType=Aggregation)
-- Parameters      :
--   @ip_week_ending_from  STRING  -- Lower bound of fiscal-week range filter
--                                    (replaces HANA input parameter IP_WEEK_ENDING_FROM;
--                                     originally derived from SFN_PRIOR_FISCAL_WEEK —
--                                     supply at runtime)
--   @ip_week_ending_to    STRING  -- Upper bound of fiscal-week range filter
--                                    (replaces HANA input parameter IP_WEEK_ENDING_TO;
--                                     originally derived from SFN_PRIOR_FISCAL_WEEK —
--                                     supply at runtime)
-- Notes           :
--   1. The seven upstream calculation views
--        CV_COMP_FIN_FLASH_STATIC, CV_COMP_FIN_BUDGET_STATIC,
--        CV_COMP_SKF_BUDGET_STATIC, CV_COMP_FORECAST_MJE_STATIC,
--        CV_COMP_FIN_ACTUAL_STATIC, CV_COMP_SKF_ACTUAL_STATIC,
--        CV_COMP_TOPSIDE_ADJUSTMENTS
--      are referenced as terminal sources because no converted SQL was supplied
--      for them.  Replace the PROJECT.DATASET placeholders with the deployed
--      BigQuery dataset paths before execution.
--   2. SFN_PRIOR_FISCAL_WEEK is an unresolved HANA scalar function.
--      Its two output values are supplied as runtime parameters
--      @ip_week_ending_from and @ip_week_ending_to.
--   3. SAFE_CAST is used in FORMAT_DATE expressions as in the original
--      converted SQL to handle potentially non-standard date strings.
-- =============================================================================

WITH

-- =====================================================================
-- CTE 1: FLASH
-- Logic: Projects all required columns from the Flash (transactional
--        sales) calculation view.  TRANSCURRENCY is aliased to
--        flash_transcurrency to avoid collision in downstream UNION.
-- Source: PROJECT.DATASET.CV_COMP_FIN_FLASH_STATIC
-- =====================================================================
FLASH AS (
  SELECT
    mandt,
    prctr,
    zzweek,
    cal_comp_flag,
    emerg_mkt_ind,
    rep_mkt_code,
    rep_mkt_desc,
    rx_salesamount,
    cal_scripts_90as3,
    emp_reductionamount,
    division_code,
    division_desc,
    region_code,
    region_desc,
    district_code,
    district_desc,
    retailstoreid,
    zrwstrtdate,
    zrwenddate,
    cal_week_number,
    city,
    state,
    fs_salesamount,
    profit_center_text,
    fs_open_dat,
    rx_open_dat,
    rx_upd_timestamp,
    fs_upd_timestamp,
    scripts_upd_timestamp,
    reductionamount,
    transcurrency        AS flash_transcurrency,
    area_code,
    area_desc,
    cvd_amount,
    cal_cvd_units,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
  FROM `PROJECT.DATASET.CV_COMP_FIN_FLASH_STATIC`
),

-- =====================================================================
-- CTE 2: FS_BUDGET
-- Logic: Projects FS financial budget columns from the budget
--        calculation view, filtered to FS_RX_FLAG = 'FS' and within
--        the supplied week-ending range.  COMP_FLAG aliased to
--        budget_comp_flag; CURRENCY aliased to fs_budget_currency.
-- Source: PROJECT.DATASET.CV_COMP_FIN_BUDGET_STATIC
-- Filters: fs_rx_flag = 'FS';
--          _bic_zio_sweek BETWEEN @ip_week_ending_from AND
--          @ip_week_ending_to (conditional on parameters being non-NULL)
-- =====================================================================
FS_BUDGET AS (
  SELECT
    mandt,
    fiscper,
    _bic_zio_sweek,
    _b631_s_amount,
    _b631_s_proftctr,
    emerg_mkt_ind,
    rep_mkt_code,
    rep_mkt_desc,
    comp_flag           AS budget_comp_flag,
    fs_rx_flag,
    division_code,
    division_desc,
    area_code,
    area_desc,
    district_code,
    district_desc,
    strnum,
    region_code,
    region_desc,
    zrwstrtdate,
    zrwenddate,
    cal_week_number,
    city,
    state,
    currency            AS fs_budget_currency,
    profit_center_text,
    fs_open_dat,
    rx_open_dat,
    fin_bud_cube,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
  FROM `PROJECT.DATASET.CV_COMP_FIN_BUDGET_STATIC`
  WHERE (
    _bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to
    OR @ip_week_ending_from IS NULL
    OR @ip_week_ending_to   IS NULL
  )
    AND fs_rx_flag = 'FS'
),

-- =====================================================================
-- CTE 3: SKF_BUDGET
-- Logic: Projects SKF (statistical key figure) budget columns from the
--        SKF budget calculation view, filtered to the week-ending range.
-- Source: PROJECT.DATASET.CV_COMP_SKF_BUDGET_STATIC
-- Filters: _bic_zio_sweek BETWEEN @ip_week_ending_from AND
--          @ip_week_ending_to (conditional on parameters being non-NULL)
-- =====================================================================
SKF_BUDGET AS (
  SELECT
    mandt,
    _b631_s_proftctr,
    _bic_zio_sweek,
    rep_mkt_code,
    rep_mkt_desc,
    emerg_mkt_ind,
    _bic_zio_skfq,
    rx_comp_wk,
    division_code,
    division_desc,
    area_code,
    area_desc,
    district_code,
    district_desc,
    region_code,
    region_desc,
    strnum,
    cal_week_number,
    zrwenddate,
    zrwstrtdate,
    city,
    state,
    profit_center_text,
    fs_open_dat,
    rx_open_dat,
    skf_bud_cube,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
  FROM `PROJECT.DATASET.CV_COMP_SKF_BUDGET_STATIC`
  WHERE (
    _bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to
    OR @ip_week_ending_from IS NULL
    OR @ip_week_ending_to   IS NULL
  )
),

-- =====================================================================
-- CTE 4: FORECAST_MJE
-- Logic: Projects forecast + MJE adjustment columns from the forecast
--        calculation view.  PRCTR aliased to _b631_s_proftctr;
--        FIN_FCST_AMOUNT aliased to _b631_s_amount;
--        FIN_FORECAST_CURRENCY aliased to forecast_currency.
--        No week-range filter applied (none in source converted SQL).
-- Source: PROJECT.DATASET.CV_COMP_FORECAST_MJE_STATIC
-- =====================================================================
FORECAST_MJE AS (
  SELECT
    mandt,
    _bic_zio_sweek,
    prctr               AS _b631_s_proftctr,
    fs_rx_flag,
    rep_mkt_code,
    rep_mkt_desc,
    emerg_mkt_ind,
    comp_flag,
    fin_fcst_amount     AS _b631_s_amount,
    division_code,
    division_desc,
    region_code,
    region_desc,
    district_code,
    district_desc,
    strnum,
    zrwstrtdate,
    zrwenddate,
    cal_week_number,
    city,
    state,
    fin_forecast_currency AS forecast_currency,
    profit_center_text,
    fs_open_dat,
    rx_open_dat,
    skf_fcst_qty,
    cal_data_category1,
    cal_data_category2,
    cal_source,
    cal_comp_flag_desc,
    cal_emerg_mkt_ind,
    fs_rx_flag_ext,
    sbt,
    skf_mje_qty,
    cal_fs_sales_mje,
    cal_rx_sales_mje,
    area_code,
    area_desc,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
  FROM `PROJECT.DATASET.CV_COMP_FORECAST_MJE_STATIC`
),

-- =====================================================================
-- CTE 5: FIN_LY
-- Logic: Projects last-year financial actuals, filtered to FS and RX
--        rows within the week-ending range.  CAL_WEEK aliased to
--        cal_week (used downstream as _bic_zio_sweek in COMBINED).
--        CURRENCY aliased to fin_ly_currency.
-- Source: PROJECT.DATASET.CV_COMP_FIN_ACTUAL_STATIC
-- Filters: fs_rx_flag IN ('FS','RX');
--          _bic_zio_sweek BETWEEN @ip_week_ending_from AND
--          @ip_week_ending_to (conditional)
-- =====================================================================
FIN_LY AS (
  SELECT
    mandt,
    _bic_zio_sweek,
    _b631_s_proftctr,
    fs_rx_flag,
    rep_mkt_code,
    rep_mkt_desc,
    emerg_mkt_ind,
    comp_flag,
    _b631_s_amount,
    division_code,
    division_desc,
    area_code,
    area_desc,
    region_code,
    region_desc,
    district_code,
    district_desc,
    strnum,
    city,
    state,
    zrwstrtdate,
    zrwenddate,
    cal_week_number,
    currency            AS fin_ly_currency,
    profit_center_text,
    fs_open_dat,
    rx_open_dat,
    cal_week,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
  FROM `PROJECT.DATASET.CV_COMP_FIN_ACTUAL_STATIC`
  WHERE (
    _bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to
    OR @ip_week_ending_from IS NULL
    OR @ip_week_ending_to   IS NULL
  )
    AND fs_rx_flag IN ('FS', 'RX')
),

-- =====================================================================
-- CTE 6: SKF_LY
-- Logic: Projects last-year SKF actuals, filtered to the week-ending
--        range.  CAL_WEEK aliased to cal_week (used downstream as
--        _bic_zio_sweek in COMBINED).
-- Source: PROJECT.DATASET.CV_COMP_SKF_ACTUAL_STATIC
-- Filters: _bic_zio_sweek BETWEEN @ip_week_ending_from AND
--          @ip_week_ending_to (conditional)
-- =====================================================================
SKF_LY AS (
  SELECT
    mandt,
    _bic_zio_sweek,
    _b631_s_proftctr,
    rep_mkt_code,
    rep_mkt_desc,
    emerg_mkt_ind,
    rx_comp_wk,
    _bic_zio_skfq,
    division_code,
    division_desc,
    area_code,
    area_desc,
    region_code,
    region_desc,
    district_code,
    district_desc,
    strnum,
    city,
    state,
    cal_week_number,
    zrwstrtdate,
    zrwenddate,
    profit_center_text,
    fs_open_dat,
    rx_open_dat,
    cal_week,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
  FROM `PROJECT.DATASET.CV_COMP_SKF_ACTUAL_STATIC`
  WHERE (
    _bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to
    OR @ip_week_ending_from IS NULL
    OR @ip_week_ending_to   IS NULL
  )
),

-- =====================================================================
-- CTE 7: RX_BUDGET
-- Logic: Projects RX budget rows from the financial budget view,
--        filtered to _bic_zwwpc_pa1 = 'RXGENRL', non-zero amounts,
--        and the week-ending range.  COMP_FLAG aliased to
--        budget_comp_flag.
-- Source: PROJECT.DATASET.CV_COMP_FIN_BUDGET_STATIC
-- Filters: _bic_zwwpc_pa1 = 'RXGENRL'; _b631_s_amount != 0;
--          _bic_zio_sweek BETWEEN @ip_week_ending_from AND
--          @ip_week_ending_to (conditional)
-- =====================================================================
RX_BUDGET AS (
  SELECT
    mandt,
    _bic_zwwpc_pa1,
    _b631_s_proftctr,
    fiscper,
    _bic_zio_sweek,
    _b631_s_amount,
    fs_rx_flag,
    rep_mkt_code,
    rep_mkt_desc,
    emerg_mkt_ind,
    division_code,
    division_desc,
    area_code,
    area_desc,
    district_code,
    district_desc,
    strnum,
    region_code,
    region_desc,
    zrwstrtdate,
    zrwenddate,
    comp_flag           AS budget_comp_flag,
    cal_week_number,
    city,
    state,
    profit_center_text,
    fs_open_dat,
    rx_open_dat,
    fin_bud_cube,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
  FROM `PROJECT.DATASET.CV_COMP_FIN_BUDGET_STATIC`
  WHERE (
    _bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to
    OR @ip_week_ending_from IS NULL
    OR @ip_week_ending_to   IS NULL
  )
    AND _bic_zwwpc_pa1 = 'RXGENRL'
    AND _b631_s_amount != 0
),

-- =====================================================================
-- CTE 8: FS_TOPSIDE_ADJ
-- Logic: Projects FS topside adjustment rows from the topside
--        adjustments calculation view, filtered to TYPE = 'FS'.
-- Source: PROJECT.DATASET.CV_COMP_TOPSIDE_ADJUSTMENTS
-- Filters: type = 'FS'
-- =====================================================================
FS_TOPSIDE_ADJ AS (
  SELECT
    application,
    description,
    mandt,
    prctr,
    s4_account,
    segment,
    type,
    week_year,
    zyear,
    fs_bud,
    fs_fct,
    fs_flash,
    fs_ly,
    rx_bud,
    rx_fct,
    rx_flash,
    rx_ly,
    sc_90as1_bud,
    sc_90as1_fct,
    sc_90as1_flash,
    sc_90as1_ly,
    cal_sc_90as3_flash,
    cal_sc_90as3_bud,
    cal_sc_90as3_fct,
    cal_sc_90as3_ly,
    cal_week_number,
    strnum,
    division_code,
    division_desc,
    district_code,
    district_desc,
    region_desc,
    region_code,
    rep_mkt_code,
    rep_mkt_desc,
    city,
    state,
    fs_open_dat,
    rx_open_dat,
    area_code,
    area_desc,
    emerg_mkt_ind,
    cal_comp_flag,
    zrwstrtdate,
    zrwenddate,
    profit_center_descr,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
  FROM `PROJECT.DATASET.CV_COMP_TOPSIDE_ADJUSTMENTS`
  WHERE type = 'FS'
),

-- =====================================================================
-- CTE 9: RX_TOPSIDE_ADJ
-- Logic: Projects RX topside adjustment rows from the topside
--        adjustments calculation view, filtered to TYPE != 'FS'.
-- Source: PROJECT.DATASET.CV_COMP_TOPSIDE_ADJUSTMENTS
-- Filters: type != 'FS'
-- =====================================================================
RX_TOPSIDE_ADJ AS (
  SELECT
    type,
    application,
    description,
    mandt,
    prctr,
    s4_account,
    segment,
    week_year,
    zyear,
    fs_bud,
    fs_fct,
    fs_flash,
    fs_ly,
    rx_bud,
    rx_flash,
    rx_ly,
    rx_fct,
    sc_90as1_bud,
    sc_90as1_fct,
    sc_90as1_flash,
    sc_90as1_ly,
    cal_sc_90as3_flash,
    cal_sc_90as3_bud,
    cal_sc_90as3_fct,
    cal_sc_90as3_ly,
    cal_week_number,
    strnum,
    division_code,
    division_desc,
    district_code,
    district_desc,
    region_desc,
    region_code,
    rep_mkt_code,
    rep_mkt_desc,
    city,
    state,
    fs_open_dat,
    rx_open_dat,
    area_code,
    area_desc,
    emerg_mkt_ind,
    cal_comp_flag,
    zrwstrtdate,
    zrwenddate,
    profit_center_descr,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
  FROM `PROJECT.DATASET.CV_COMP_TOPSIDE_ADJUSTMENTS`
  WHERE type != 'FS'
),

-- =====================================================================
-- CTE 10: COMBINED
-- Logic: UNION ALL of all nine data branches (Flash, FS Budget,
--        Forecast/MJE, FIN LY, SKF LY, SKF Budget, FS Topside Adj,
--        RX Topside Adj, RX Budget) into a common schema.  Each branch
--        fills only the columns relevant to its data category; all
--        other measure columns are NULL-padded with explicit types.
-- Source: FLASH, FS_BUDGET, FORECAST_MJE, FIN_LY, SKF_LY, SKF_BUDGET,
--         FS_TOPSIDE_ADJ, RX_TOPSIDE_ADJ, RX_BUDGET
-- =====================================================================
COMBINED AS (
  -- Branch 1: Flash (transactional sales)
  SELECT
    rx_salesamount,
    cal_scripts_90as3,
    emp_reductionamount,
    'FS'                            AS fs_rx_flag,
    CAST(NULL AS NUMERIC)           AS fin_budget_amount,
    CAST(NULL AS NUMERIC)           AS fin_fcst_amount,
    CAST(NULL AS NUMERIC)           AS skf_fcst_qty,
    CAST(NULL AS NUMERIC)           AS fin_ly_amount,
    CAST(NULL AS NUMERIC)           AS skf_ly_qty,
    'Flash'                         AS cal_source,
    retailstoreid                   AS strnum,
    district_desc,
    district_code,
    region_desc,
    region_code,
    division_desc,
    division_code,
    CAST(NULL AS NUMERIC)           AS skf_budget_qty,
    cal_comp_flag                   AS comp_flag,
    zzweek                          AS _bic_zio_sweek,
    rep_mkt_desc,
    rep_mkt_code,
    emerg_mkt_ind,
    prctr,
    mandt,
    CAST(NULL AS NUMERIC)           AS cal_rx_budget,
    'RX'                            AS fs_rx_flag_ext,
    zrwstrtdate,
    zrwenddate,
    cal_week_number,
    city,
    state,
    fs_salesamount,
    CAST(NULL AS STRING)            AS fs_budget_currency,
    CAST(NULL AS STRING)            AS fin_ly_currency,
    CAST(NULL AS STRING)            AS forecast_currency,
    profit_center_text,
    'FLASH'                         AS cal_data_category1,
    'FLASH'                         AS cal_data_category2,
    fs_open_dat,
    rx_open_dat,
    CAST(NULL AS STRING)            AS rx_budget_currency,
    fs_upd_timestamp,
    rx_upd_timestamp,
    scripts_upd_timestamp,
    CAST(NULL AS STRING)            AS budget_comp_flag,
    CAST(NULL AS NUMERIC)           AS skf_mje_qty,
    CAST(NULL AS NUMERIC)           AS cal_fs_sales_mje,
    CAST(NULL AS NUMERIC)           AS cal_rx_sales_mje,
    CAST(NULL AS NUMERIC)           AS sbt,
    reductionamount,
    flash_transcurrency,
    CAST(NULL AS STRING)            AS segment,
    CAST(NULL AS STRING)            AS description,
    CAST(NULL AS NUMERIC)           AS sc_90as1_bud,
    CAST(NULL AS NUMERIC)           AS sc_90as1_fct,
    CAST(NULL AS NUMERIC)           AS sc_90as1_flash,
    CAST(NULL AS NUMERIC)           AS sc_90as1_ly,
    'Transactional Sales'           AS sales_source,
    area_code,
    area_desc,
    CAST(NULL AS STRING)            AS fin_bud_cube,
    CAST(NULL AS STRING)            AS skf_bud_cube,
    cvd_amount,
    cal_cvd_units,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
  FROM FLASH

  UNION ALL

  -- Branch 2: FS Budget
  SELECT
    CAST(NULL AS NUMERIC)           AS rx_salesamount,
    CAST(NULL AS NUMERIC)           AS cal_scripts_90as3,
    CAST(NULL AS NUMERIC)           AS emp_reductionamount,
    'FS'                            AS fs_rx_flag,
    _b631_s_amount                  AS fin_budget_amount,
    CAST(NULL AS NUMERIC)           AS fin_fcst_amount,
    CAST(NULL AS NUMERIC)           AS skf_fcst_qty,
    CAST(NULL AS NUMERIC)           AS fin_ly_amount,
    CAST(NULL AS NUMERIC)           AS skf_ly_qty,
    'Budget'                        AS cal_source,
    strnum,
    district_desc,
    district_code,
    region_desc,
    region_code,
    division_desc,
    division_code,
    CAST(NULL AS NUMERIC)           AS skf_budget_qty,
    CAST(NULL AS STRING)            AS comp_flag,
    _bic_zio_sweek,
    rep_mkt_desc,
    rep_mkt_code,
    emerg_mkt_ind,
    _b631_s_proftctr                AS prctr,
    mandt,
    CAST(NULL AS NUMERIC)           AS cal_rx_budget,
    'FS'                            AS fs_rx_flag_ext,
    zrwstrtdate,
    zrwenddate,
    cal_week_number,
    city,
    state,
    CAST(NULL AS NUMERIC)           AS fs_salesamount,
    fs_budget_currency,
    CAST(NULL AS STRING)            AS fin_ly_currency,
    CAST(NULL AS STRING)            AS forecast_currency,
    profit_center_text,
    'FIN'                           AS cal_data_category1,
    'FS_BUD'                        AS cal_data_category2,
    fs_open_dat,
    rx_open_dat,
    CAST(NULL AS STRING)            AS rx_budget_currency,
    CAST(NULL AS STRING)            AS fs_upd_timestamp,
    CAST(NULL AS STRING)            AS rx_upd_timestamp,
    CAST(NULL AS STRING)            AS scripts_upd_timestamp,
    budget_comp_flag,
    CAST(NULL AS NUMERIC)           AS skf_mje_qty,
    CAST(NULL AS NUMERIC)           AS cal_fs_sales_mje,
    CAST(NULL AS NUMERIC)           AS cal_rx_sales_mje,
    CAST(NULL AS NUMERIC)           AS sbt,
    CAST(NULL AS NUMERIC)           AS reductionamount,
    CAST(NULL AS STRING)            AS flash_transcurrency,
    CAST(NULL AS STRING)            AS segment,
    CAST(NULL AS STRING)            AS description,
    CAST(NULL AS NUMERIC)           AS sc_90as1_bud,
    CAST(NULL AS NUMERIC)           AS sc_90as1_fct,
    CAST(NULL AS NUMERIC)           AS sc_90as1_flash,
    CAST(NULL AS NUMERIC)           AS sc_90as1_ly,
    'Transactional Sales'           AS sales_source,
    area_code,
    area_desc,
    fin_bud_cube,
    CAST(NULL AS STRING)            AS skf_bud_cube,
    CAST(NULL AS NUMERIC)           AS cvd_amount,
    CAST(NULL AS NUMERIC)           AS cal_cvd_units,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
  FROM FS_BUDGET

  UNION ALL

  -- Branch 3: Forecast / MJE
  SELECT
    CAST(NULL AS NUMERIC)           AS rx_salesamount,
    CAST(NULL AS NUMERIC)           AS cal_scripts_90as3,
    CAST(NULL AS NUMERIC)           AS emp_reductionamount,
    fs_rx_flag,
    CAST(NULL AS NUMERIC)           AS fin_budget_amount,
    _b631_s_amount                  AS fin_fcst_amount,
    skf_fcst_qty,
    CAST(NULL AS NUMERIC)           AS fin_ly_amount,
    CAST(NULL AS NUMERIC)           AS skf_ly_qty,
    cal_source,
    strnum,
    district_desc,
    district_code,
    region_desc,
    region_code,
    division_desc,
    division_code,
    CAST(NULL AS NUMERIC)           AS skf_budget_qty,
    comp_flag,
    _bic_zio_sweek,
    rep_mkt_desc,
    rep_mkt_code,
    emerg_mkt_ind,
    _b631_s_proftctr                AS prctr,
    mandt,
    CAST(NULL AS NUMERIC)           AS cal_rx_budget,
    fs_rx_flag_ext,
    zrwstrtdate,
    zrwenddate,
    cal_week_number,
    city,
    state,
    CAST(NULL AS NUMERIC)           AS fs_salesamount,
    CAST(NULL AS STRING)            AS fs_budget_currency,
    CAST(NULL AS STRING)            AS fin_ly_currency,
    forecast_currency,
    profit_center_text,
    cal_data_category1,
    cal_data_category2,
    fs_open_dat,
    rx_open_dat,
    CAST(NULL AS STRING)            AS rx_budget_currency,
    CAST(NULL AS STRING)            AS fs_upd_timestamp,
    CAST(NULL AS STRING)            AS rx_upd_timestamp,
    CAST(NULL AS STRING)            AS scripts_upd_timestamp,
    CAST(NULL AS STRING)            AS budget_comp_flag,
    skf_mje_qty,
    cal_fs_sales_mje,
    cal_rx_sales_mje,
    sbt,
    CAST(NULL AS NUMERIC)           AS reductionamount,
    CAST(NULL AS STRING)            AS flash_transcurrency,
    CAST(NULL AS STRING)            AS segment,
    CAST(NULL AS STRING)            AS description,
    CAST(NULL AS NUMERIC)           AS sc_90as1_bud,
    CAST(NULL AS NUMERIC)           AS sc_90as1_fct,
    CAST(NULL AS NUMERIC)           AS sc_90as1_flash,
    CAST(NULL AS NUMERIC)           AS sc_90as1_ly,
    cal_source                      AS sales_source,
    area_code,
    area_desc,
    CAST(NULL AS STRING)            AS fin_bud_cube,
    CAST(NULL AS STRING)            AS skf_bud_cube,
    CAST(NULL AS NUMERIC)           AS cvd_amount,
    CAST(NULL AS NUMERIC)           AS cal_cvd_units,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
  FROM FORECAST_MJE

  UNION ALL

  -- Branch 4: FIN LY (Last Year Financial Actuals)
  SELECT
    CAST(NULL AS NUMERIC)           AS rx_salesamount,
    CAST(NULL AS NUMERIC)           AS cal_scripts_90as3,
    CAST(NULL AS NUMERIC)           AS emp_reductionamount,
    fs_rx_flag,
    CAST(NULL AS NUMERIC)           AS fin_budget_amount,
    CAST(NULL AS NUMERIC)           AS fin_fcst_amount,
    CAST(NULL AS NUMERIC)           AS skf_fcst_qty,
    _b631_s_amount                  AS fin_ly_amount,
    CAST(NULL AS NUMERIC)           AS skf_ly_qty,
    'LY'                            AS cal_source,
    strnum,
    district_desc,
    district_code,
    region_desc,
    region_code,
    division_desc,
    division_code,
    CAST(NULL AS NUMERIC)           AS skf_budget_qty,
    comp_flag,
    cal_week                        AS _bic_zio_sweek,
    rep_mkt_desc,
    rep_mkt_code,
    emerg_mkt_ind,
    _b631_s_proftctr                AS prctr,
    mandt,
    CAST(NULL AS NUMERIC)           AS cal_rx_budget,
    fs_rx_flag                      AS fs_rx_flag_ext,
    zrwstrtdate,
    zrwenddate,
    cal_week_number,
    city,
    state,
    CAST(NULL AS NUMERIC)           AS fs_salesamount,
    CAST(NULL AS STRING)            AS fs_budget_currency,
    fin_ly_currency,
    CAST(NULL AS STRING)            AS forecast_currency,
    profit_center_text,
    'FIN'                           AS cal_data_category1,
    'FIN_LY'                        AS cal_data_category2,
    fs_open_dat,
    rx_open_dat,
    CAST(NULL AS STRING)            AS rx_budget_currency,
    CAST(NULL AS STRING)            AS fs_upd_timestamp,
    CAST(NULL AS STRING)            AS rx_upd_timestamp,
    CAST(NULL AS STRING)            AS scripts_upd_timestamp,
    CAST(NULL AS STRING)            AS budget_comp_flag,
    CAST(NULL AS NUMERIC)           AS skf_mje_qty,
    CAST(NULL AS NUMERIC)           AS cal_fs_sales_mje,
    CAST(NULL AS NUMERIC)           AS cal_rx_sales_mje,
    CAST(NULL AS NUMERIC)           AS sbt,
    CAST(NULL AS NUMERIC)           AS reductionamount,
    CAST(NULL AS STRING)            AS flash_transcurrency,
    CAST(NULL AS STRING)            AS segment,
    CAST(NULL AS STRING)            AS description,
    CAST(NULL AS NUMERIC)           AS sc_90as1_bud,
    CAST(NULL AS NUMERIC)           AS sc_90as1_fct,
    CAST(NULL AS NUMERIC)           AS sc_90as1_flash,
    CAST(NULL AS NUMERIC)           AS sc_90as1_ly,
    'Transactional Sales'           AS sales_source,
    area_code,
    area_desc,
    CAST(NULL AS STRING)            AS fin_bud_cube,
    CAST(NULL AS STRING)            AS skf_bud_cube,
    CAST(NULL AS NUMERIC)           AS cvd_amount,
    CAST(NULL AS NUMERIC)           AS cal_cvd_units,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
  FROM FIN_LY

  UNION ALL

  -- Branch 5: SKF LY (Last Year SKF Actuals)
  SELECT
    CAST(NULL AS NUMERIC)           AS rx_salesamount,
    CAST(NULL AS NUMERIC)           AS cal_scripts_90as3,
    CAST(NULL AS NUMERIC)           AS emp_reductionamount,
    'RX'                            AS fs_rx_flag,
    CAST(NULL AS NUMERIC)           AS fin_budget_amount,
    CAST(NULL AS NUMERIC)           AS fin_fcst_amount,
    CAST(NULL AS NUMERIC)           AS skf_fcst_qty,
    CAST(NULL AS NUMERIC)           AS fin_ly_amount,
    _bic_zio_skfq                   AS skf_ly_qty,
    'LY'                            AS cal_source,
    strnum,
    district_desc,
    district_code,
    region_desc,
    region_code,
    division_desc,
    division_code,
    CAST(NULL AS NUMERIC)           AS skf_budget_qty,
    rx_comp_wk                      AS comp_flag,
    cal_week                        AS _bic_zio_sweek,
    rep_mkt_desc,
    rep_mkt_code,
    emerg_mkt_ind,
    _b631_s_proftctr                AS prctr,
    mandt,
    CAST(NULL AS NUMERIC)           AS cal_rx_budget,
    'RX'                            AS fs_rx_flag_ext,
    zrwstrtdate,
    zrwenddate,
    cal_week_number,
    city,
    state,
    CAST(NULL AS NUMERIC)           AS fs_salesamount,
    CAST(NULL AS STRING)            AS fs_budget_currency,
    CAST(NULL AS STRING)            AS fin_ly_currency,
    CAST(NULL AS STRING)            AS forecast_currency,
    profit_center_text,
    'SKF'                           AS cal_data_category1,
    'SKF_LY'                        AS cal_data_category2,
    fs_open_dat,
    rx_open_dat,
    CAST(NULL AS STRING)            AS rx_budget_currency,
    CAST(NULL AS STRING)            AS fs_upd_timestamp,
    CAST(NULL AS STRING)            AS rx_upd_timestamp,
    CAST(NULL AS STRING)            AS scripts_upd_timestamp,
    CAST(NULL AS STRING)            AS budget_comp_flag,
    CAST(NULL AS NUMERIC)           AS skf_mje_qty,
    CAST(NULL AS NUMERIC)           AS cal_fs_sales_mje,
    CAST(NULL AS NUMERIC)           AS cal_rx_sales_mje,
    CAST(NULL AS NUMERIC)           AS sbt,
    CAST(NULL AS NUMERIC)           AS reductionamount,
    CAST(NULL AS STRING)            AS flash_transcurrency,
    CAST(NULL AS STRING)            AS segment,
    CAST(NULL AS STRING)            AS description,
    CAST(NULL AS NUMERIC)           AS sc_90as1_bud,
    CAST(NULL AS NUMERIC)           AS sc_90as1_fct,
    CAST(NULL AS NUMERIC)           AS sc_90as1_flash,
    CAST(NULL AS NUMERIC)           AS sc_90as1_ly,
    'Transactional Sales'           AS sales_source,
    area_code,
    area_desc,
    CAST(NULL AS STRING)            AS fin_bud_cube,
    CAST(NULL AS STRING)            AS skf_bud_cube,
    CAST(NULL AS NUMERIC)           AS cvd_amount,
    CAST(NULL AS NUMERIC)           AS cal_cvd_units,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
  FROM SKF_LY

  UNION ALL

  -- Branch 6: SKF Budget
  SELECT
    CAST(NULL AS NUMERIC)           AS rx_salesamount,
    CAST(NULL AS NUMERIC)           AS cal_scripts_90as3,
    CAST(NULL AS NUMERIC)           AS emp_reductionamount,
    'RX'                            AS fs_rx_flag,
    CAST(NULL AS NUMERIC)           AS fin_budget_amount,
    CAST(NULL AS NUMERIC)           AS fin_fcst_amount,
    CAST(NULL AS NUMERIC)           AS skf_fcst_qty,
    CAST(NULL AS NUMERIC)           AS fin_ly_amount,
    CAST(NULL AS NUMERIC)           AS skf_ly_qty,
    'Budget'                        AS cal_source,
    strnum,
    district_desc,
    district_code,
    region_desc,
    region_code,
    division_desc,
    division_code,
    _bic_zio_skfq                   AS skf_budget_qty,
    CAST(NULL AS STRING)            AS comp_flag,
    _bic_zio_sweek,
    rep_mkt_desc,
    rep_mkt_code,
    emerg_mkt_ind,
    _b631_s_proftctr                AS prctr,
    mandt,
    CAST(NULL AS NUMERIC)           AS cal_rx_budget,
    'RX'                            AS fs_rx_flag_ext,
    zrwstrtdate,
    zrwenddate,
    cal_week_number,
    city,
    state,
    CAST(NULL AS NUMERIC)           AS fs_salesamount,
    CAST(NULL AS STRING)            AS fs_budget_currency,
    CAST(NULL AS STRING)            AS fin_ly_currency,
    CAST(NULL AS STRING)            AS forecast_currency,
    profit_center_text,
    'SKF'                           AS cal_data_category1,
    'SKF_BUD'                       AS cal_data_category2,
    fs_open_dat,
    rx_open_dat,
    CAST(NULL AS STRING)            AS rx_budget_currency,
    CAST(NULL AS STRING)            AS fs_upd_timestamp,
    CAST(NULL AS STRING)            AS rx_upd_timestamp,
    CAST(NULL AS STRING)            AS scripts_upd_timestamp,
    rx_comp_wk                      AS budget_comp_flag,
    CAST(NULL AS NUMERIC)           AS skf_mje_qty,
    CAST(NULL AS NUMERIC)           AS cal_fs_sales_mje,
    CAST(NULL AS NUMERIC)           AS cal_rx_sales_mje,
    CAST(NULL AS NUMERIC)           AS sbt,
    CAST(NULL AS NUMERIC)           AS reductionamount,
    CAST(NULL AS STRING)            AS flash_transcurrency,
    CAST(NULL AS STRING)            AS segment,
    CAST(NULL AS STRING)            AS description,
    CAST(NULL AS NUMERIC)           AS sc_90as1_bud,
    CAST(NULL AS NUMERIC)           AS sc_90as1_fct,
    CAST(NULL AS NUMERIC)           AS sc_90as1_flash,
    CAST(NULL AS NUMERIC)           AS sc_90as1_ly,
    'Transactional Sales'           AS sales_source,
    area_code,
    area_desc,
    CAST(NULL AS STRING)            AS fin_bud_cube,
    skf_bud_cube,
    CAST(NULL AS NUMERIC)           AS cvd_amount,
    CAST(NULL AS NUMERIC)           AS cal_cvd_units,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
  FROM SKF_BUDGET

  UNION ALL

  -- Branch 7: FS Topside Adjustments
  SELECT
    CAST(NULL AS NUMERIC)           AS rx_salesamount,
    CAST(NULL AS NUMERIC)           AS cal_scripts_90as3,
    CAST(NULL AS NUMERIC)           AS emp_reductionamount,
    'FS'                            AS fs_rx_flag,
    fs_bud                          AS fin_budget_amount,
    fs_fct                          AS fin_fcst_amount,
    CAST(NULL AS NUMERIC)           AS skf_fcst_qty,
    fs_ly                           AS fin_ly_amount,
    CAST(NULL AS NUMERIC)           AS skf_ly_qty,
    'Topside'                       AS cal_source,
    strnum,
    district_desc,
    district_code,
    region_desc,
    region_code,
    division_desc,
    division_code,
    CAST(NULL AS NUMERIC)           AS skf_budget_qty,
    cal_comp_flag                   AS comp_flag,
    week_year                       AS _bic_zio_sweek,
    rep_mkt_desc,
    rep_mkt_code,
    emerg_mkt_ind,
    prctr,
    mandt,
    CAST(NULL AS NUMERIC)           AS cal_rx_budget,
    'FS'                            AS fs_rx_flag_ext,
    zrwstrtdate,
    zrwenddate,
    cal_week_number,
    city,
    state,
    fs_flash                        AS fs_salesamount,
    'USD'                           AS fs_budget_currency,
    'USD'                           AS fin_ly_currency,
    'USD'                           AS forecast_currency,
    profit_center_descr             AS profit_center_text,
    'FS_TOPSIDE'                    AS cal_data_category1,
    'FS_TOPSIDE'                    AS cal_data_category2,
    fs_open_dat,
    rx_open_dat,
    CAST(NULL AS STRING)            AS rx_budget_currency,
    CAST(NULL AS STRING)            AS fs_upd_timestamp,
    CAST(NULL AS STRING)            AS rx_upd_timestamp,
    CAST(NULL AS STRING)            AS scripts_upd_timestamp,
    CAST(NULL AS STRING)            AS budget_comp_flag,
    CAST(NULL AS NUMERIC)           AS skf_mje_qty,
    CAST(NULL AS NUMERIC)           AS cal_fs_sales_mje,
    CAST(NULL AS NUMERIC)           AS cal_rx_sales_mje,
    CAST(NULL AS NUMERIC)           AS sbt,
    CAST(NULL AS NUMERIC)           AS reductionamount,
    'USD'                           AS flash_transcurrency,
    segment,
    description,
    CAST(NULL AS NUMERIC)           AS sc_90as1_bud,
    CAST(NULL AS NUMERIC)           AS sc_90as1_fct,
    CAST(NULL AS NUMERIC)           AS sc_90as1_flash,
    CAST(NULL AS NUMERIC)           AS sc_90as1_ly,
    'Topside Adjustments'           AS sales_source,
    area_code,
    area_desc,
    CAST(NULL AS STRING)            AS fin_bud_cube,
    CAST(NULL AS STRING)            AS skf_bud_cube,
    CAST(NULL AS NUMERIC)           AS cvd_amount,
    CAST(NULL AS NUMERIC)           AS cal_cvd_units,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
  FROM FS_TOPSIDE_ADJ

  UNION ALL

  -- Branch 8: RX Topside Adjustments
  SELECT
    rx_flash                        AS rx_salesamount,
    cal_sc_90as3_flash              AS cal_scripts_90as3,
    CAST(NULL AS NUMERIC)           AS emp_reductionamount,
    'RX'                            AS fs_rx_flag,
    CAST(NULL AS NUMERIC)           AS fin_budget_amount,
    rx_fct                          AS fin_fcst_amount,
    cal_sc_90as3_fct                AS skf_fcst_qty,
    rx_ly                           AS fin_ly_amount,
    cal_sc_90as3_ly                 AS skf_ly_qty,
    'Topside'                       AS cal_source,
    strnum,
    district_desc,
    district_code,
    region_desc,
    region_code,
    division_desc,
    division_code,
    cal_sc_90as3_bud                AS skf_budget_qty,
    cal_comp_flag                   AS comp_flag,
    week_year                       AS _bic_zio_sweek,
    rep_mkt_desc,
    rep_mkt_code,
    emerg_mkt_ind,
    prctr,
    mandt,
    rx_bud                          AS cal_rx_budget,
    'RX'                            AS fs_rx_flag_ext,
    zrwstrtdate,
    zrwenddate,
    cal_week_number,
    city,
    state,
    CAST(NULL AS NUMERIC)           AS fs_salesamount,
    CAST(NULL AS STRING)            AS fs_budget_currency,
    'USD'                           AS fin_ly_currency,
    'USD'                           AS forecast_currency,
    profit_center_descr             AS profit_center_text,
    'RX_TOPSIDE'                    AS cal_data_category1,
    'RX_TOPSIDE'                    AS cal_data_category2,
    fs_open_dat,
    rx_open_dat,
    'USD'                           AS rx_budget_currency,
    CAST(NULL AS STRING)            AS fs_upd_timestamp,
    CAST(NULL AS STRING)            AS rx_upd_timestamp,
    CAST(NULL AS STRING)            AS scripts_upd_timestamp,
    CAST(NULL AS STRING)            AS budget_comp_flag,
    CAST(NULL AS NUMERIC)           AS skf_mje_qty,
    CAST(NULL AS NUMERIC)           AS cal_fs_sales_mje,
    CAST(NULL AS NUMERIC)           AS cal_rx_sales_mje,
    CAST(NULL AS NUMERIC)           AS sbt,
    CAST(NULL AS NUMERIC)           AS reductionamount,
    'USD'                           AS flash_transcurrency,
    segment,
    description,
    sc_90as1_bud,
    sc_90as1_fct,
    sc_90as1_flash,
    sc_90as1_ly,
    'Topside Adjustments'           AS sales_source,
    area_code,
    area_desc,
    CAST(NULL AS STRING)            AS fin_bud_cube,
    CAST(NULL AS STRING)            AS skf_bud_cube,
    CAST(NULL AS NUMERIC)           AS cvd_amount,
    CAST(NULL AS NUMERIC)           AS cal_cvd_units,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
  FROM RX_TOPSIDE_ADJ

  UNION ALL

  -- Branch 9: RX Budget
  SELECT
    CAST(NULL AS NUMERIC)           AS rx_salesamount,
    CAST(NULL AS NUMERIC)           AS cal_scripts_90as3,
    CAST(NULL AS NUMERIC)           AS emp_reductionamount,
    'RX'                            AS fs_rx_flag,
    CAST(NULL AS NUMERIC)           AS fin_budget_amount,
    CAST(NULL AS NUMERIC)           AS fin_fcst_amount,
    CAST(NULL AS NUMERIC)           AS skf_fcst_qty,
    CAST(NULL AS NUMERIC)           AS fin_ly_amount,
    CAST(NULL AS NUMERIC)           AS skf_ly_qty,
    'Budget'                        AS cal_source,
    strnum,
    district_desc,
    district_code,
    region_desc,
    region_code,
    division_desc,
    division_code,
    CAST(NULL AS NUMERIC)           AS skf_budget_qty,
    CAST(NULL AS STRING)            AS comp_flag,
    _bic_zio_sweek,
    rep_mkt_desc,
    rep_mkt_code,
    emerg_mkt_ind,
    _b631_s_proftctr                AS prctr,
    mandt,
    _b631_s_amount                  AS cal_rx_budget,
    'RX'                            AS fs_rx_flag_ext,
    zrwstrtdate,
    zrwenddate,
    cal_week_number,
    city,
    state,
    CAST(NULL AS NUMERIC)           AS fs_salesamount,
    CAST(NULL AS STRING)            AS fs_budget_currency,
    CAST(NULL AS STRING)            AS fin_ly_currency,
    CAST(NULL AS STRING)            AS forecast_currency,
    profit_center_text,
    'FIN'                           AS cal_data_category1,
    'RX_BUD'                        AS cal_data_category2,
    fs_open_dat,
    rx_open_dat,
    'USD'                           AS rx_budget_currency,
    CAST(NULL AS STRING)            AS fs_upd_timestamp,
    CAST(NULL AS STRING)            AS rx_upd_timestamp,
    CAST(NULL AS STRING)            AS scripts_upd_timestamp,
    budget_comp_flag,
    CAST(NULL AS NUMERIC)           AS skf_mje_qty,
    CAST(NULL AS NUMERIC)           AS cal_fs_sales_mje,
    CAST(NULL AS NUMERIC)           AS cal_rx_sales_mje,
    CAST(NULL AS NUMERIC)           AS sbt,
    CAST(NULL AS NUMERIC)           AS reductionamount,
    CAST(NULL AS STRING)            AS flash_transcurrency,
    CAST(NULL AS STRING)            AS segment,
    CAST(NULL AS STRING)            AS description,
    CAST(NULL AS NUMERIC)           AS sc_90as1_bud,
    CAST(NULL AS NUMERIC)           AS sc_90as1_fct,
    CAST(NULL AS NUMERIC)           AS sc_90as1_flash,
    CAST(NULL AS NUMERIC)           AS sc_90as1_ly,
    'Transactional Sales'           AS sales_source,
    area_code,
    area_desc,
    fin_bud_cube,
    CAST(NULL AS STRING)            AS skf_bud_cube,
    CAST(NULL AS NUMERIC)           AS cvd_amount,
    CAST(NULL AS NUMERIC)           AS cal_cvd_units,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
  FROM RX_BUDGET
),

-- =====================================================================
-- CTE 11: Aggregation_1
-- Logic: Aggregates the COMBINED UNION ALL result by all dimension
--        columns, summing all measure columns and taking MAX for
--        timestamp columns, to produce the base aggregated grain.
-- Source: COMBINED
-- Aggregation: SUM for all numeric measures; MAX for timestamp strings.
--              GROUP BY all non-measure dimension columns.
-- =====================================================================
Aggregation_1 AS (
  SELECT
    mandt,
    cal_source,
    division_code,
    division_desc,
    region_code,
    region_desc,
    district_code,
    district_desc,
    strnum,
    prctr,
    emerg_mkt_ind,
    rep_mkt_code,
    rep_mkt_desc,
    fs_rx_flag,
    _bic_zio_sweek,
    fs_rx_flag_ext,
    zrwstrtdate,
    zrwenddate,
    cal_week_number,
    city,
    state,
    fs_budget_currency,
    fin_ly_currency,
    forecast_currency,
    profit_center_text,
    cal_data_category1,
    cal_data_category2,
    fs_open_dat,
    rx_open_dat,
    rx_budget_currency,
    scripts_upd_timestamp,
    flash_transcurrency,
    segment,
    description,
    sc_90as1_bud,
    sc_90as1_fct,
    sc_90as1_flash,
    sc_90as1_ly,
    sales_source,
    comp_flag,
    budget_comp_flag,
    area_code,
    area_desc,
    fin_bud_cube,
    skf_bud_cube,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code,
    SUM(rx_salesamount)         AS rx_salesamount,
    SUM(cal_scripts_90as3)      AS cal_scripts_90as3,
    SUM(emp_reductionamount)    AS emp_reductionamount,
    SUM(fin_budget_amount)      AS fin_budget_amount,
    SUM(skf_budget_qty)         AS skf_budget_qty,
    SUM(fin_fcst_amount)        AS fin_fcst_amount,
    SUM(skf_fcst_qty)           AS skf_fcst_qty,
    SUM(fin_ly_amount)          AS fin_ly_amount,
    SUM(skf_ly_qty)             AS skf_ly_qty,
    SUM(cal_rx_budget)          AS cal_rx_budget,
    SUM(fs_salesamount)         AS fs_salesamount,
    MAX(fs_upd_timestamp)       AS fs_upd_timestamp,
    MAX(rx_upd_timestamp)       AS rx_upd_timestamp,
    SUM(skf_mje_qty)            AS skf_mje_qty,
    SUM(cal_fs_sales_mje)       AS cal_fs_sales_mje,
    SUM(cal_rx_sales_mje)       AS cal_rx_sales_mje,
    SUM(sbt)                    AS sbt,
    SUM(reductionamount)        AS reductionamount,
    SUM(cvd_amount)             AS cvd_amount,
    SUM(cal_cvd_units)          AS cal_cvd_units
  FROM COMBINED
  GROUP BY
    mandt,
    cal_source,
    division_code,
    division_desc,
    region_code,
    region_desc,
    district_code,
    district_desc,
    strnum,
    prctr,
    emerg_mkt_ind,
    rep_mkt_code,
    rep_mkt_desc,
    fs_rx_flag,
    _bic_zio_sweek,
    fs_rx_flag_ext,
    zrwstrtdate,
    zrwenddate,
    cal_week_number,
    city,
    state,
    fs_budget_currency,
    fin_ly_currency,
    forecast_currency,
    profit_center_text,
    cal_data_category1,
    cal_data_category2,
    fs_open_dat,
    rx_open_dat,
    rx_budget_currency,
    scripts_upd_timestamp,
    flash_transcurrency,
    segment,
    description,
    sc_90as1_bud,
    sc_90as1_fct,
    sc_90as1_flash,
    sc_90as1_ly,
    sales_source,
    comp_flag,
    budget_comp_flag,
    area_code,
    area_desc,
    fin_bud_cube,
    skf_bud_cube,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
),

-- =====================================================================
-- CTE 12: VARIANCES
-- Logic: Computes all variance, sales, and comp-level calculated
--        measures from the aggregated base.  cal_scripts_90as3 is
--        renamed to cal_scripts_90as3_car (the raw pre-MJE value) and
--        the new cal_scripts_90as3 includes skf_mje_qty.
-- Source: Aggregation_1 (aliased as a)
-- Calculation:
--   cal_fs_sales       = fs_salesamount - reductionamount
--                        - emp_reductionamount + cal_fs_sales_mje + sbt
--   cal_rx_sales       = rx_salesamount + cal_rx_sales_mje
--   cal_scripts_90as3  = cal_scripts_90as3 (pre-MJE) + skf_mje_qty
--   cal_fs_bud_var     = fs_salesamount - fin_budget_amount
--   cal_fs_forecast_var= IF(fs_rx_flag='FS', fs_salesamount
--                           - fin_fcst_amount, 0)
--   cal_fs_ly_var      = IF(fs_rx_flag='FS', fs_salesamount
--                           - fin_ly_amount, 0)
--   cal_rx_bud_var     = (rx_salesamount+cal_rx_sales_mje)
--                        - cal_rx_budget
--   cal_skf_forecast_var = (cal_scripts_90as3+skf_mje_qty)
--                          - skf_fcst_qty
--   cal_skf_bud_var    = (cal_scripts_90as3+skf_mje_qty)
--                        - skf_budget_qty
--   cal_skf_ly_var     = (cal_scripts_90as3+skf_mje_qty) - skf_ly_qty
--   (plus corp and comp-level variants — see SQL)
-- =====================================================================
VARIANCES AS (
  SELECT
    a.* EXCEPT (cal_scripts_90as3),
    cal_scripts_90as3                                                                                                                                       AS cal_scripts_90as3_car,
    fs_salesamount - reductionamount - emp_reductionamount + cal_fs_sales_mje + sbt                                                                        AS cal_fs_sales,
    rx_salesamount + cal_rx_sales_mje                                                                                                                      AS cal_rx_sales,
    cal_scripts_90as3 + skf_mje_qty                                                                                                                        AS cal_scripts_90as3,
    fs_salesamount - fin_budget_amount                                                                                                                     AS cal_fs_bud_var,
    IF(fs_rx_flag = 'FS', fs_salesamount - fin_fcst_amount, 0)                                                                                            AS cal_fs_forecast_var,
    IF(fs_rx_flag = 'FS', fs_salesamount - fin_ly_amount, 0)                                                                                              AS cal_fs_ly_var,
    (rx_salesamount + cal_rx_sales_mje) - cal_rx_budget                                                                                                   AS cal_rx_bud_var,
    (cal_scripts_90as3 + skf_mje_qty) - skf_fcst_qty                                                                                                     AS cal_skf_forecast_var,
    (cal_scripts_90as3 + skf_mje_qty) - skf_budget_qty                                                                                                   AS cal_skf_bud_var,
    (cal_scripts_90as3 + skf_mje_qty) - skf_ly_qty                                                                                                       AS cal_skf_ly_var,
    (fs_salesamount - reductionamount - emp_reductionamount + cal_fs_sales_mje + sbt) - fin_budget_amount                                                 AS cal_fs_bud_corp_var,
    IF(fs_rx_flag = 'FS', (fs_salesamount - reductionamount - emp_reductionamount + cal_fs_sales_mje + sbt) - fin_fcst_amount, 0)                         AS cal_fs_forecast_corp_var,
    IF(fs_rx_flag = 'FS', (fs_salesamount - reductionamount - emp_reductionamount + cal_fs_sales_mje + sbt) - fin_ly_amount, 0)                           AS cal_fs_ly_corp_var,
    IF(fs_rx_flag_ext = 'RX', (rx_salesamount + cal_rx_sales_mje) - fin_fcst_amount, 0)                                                                  AS cal_rx_forecast_var,
    IF(fs_rx_flag_ext = 'RX', (rx_salesamount + cal_rx_sales_mje) - fin_ly_amount, 0)                                                                    AS cal_rx_ly_var,
    IF(budget_comp_flag = '1', fin_budget_amount, 0)                                                                                                      AS cal_comp_fs_budget_amount,
    IF(comp_flag = '1', fs_salesamount - reductionamount - emp_reductionamount + cal_fs_sales_mje + sbt, 0)                                               AS cal_comp_corpfs_sales_amount,
    IF(comp_flag = '1', fs_salesamount, 0)                                                                                                                AS cal_comp_fs_salesamount,
    IF(comp_flag = '1', rx_salesamount + cal_rx_sales_mje, 0)                                                                                            AS cal_comp_rx_salesamount,
    IF(budget_comp_flag = '1', skf_budget_qty, 0)                                                                                                        AS cal_comp_budget_90as3,
    IF(comp_flag = '1', cal_scripts_90as3 + skf_mje_qty, 0)                                                                                              AS cal_comp_flash_90as3,
    IF(comp_flag = '1', fin_fcst_amount, 0)                                                                                                               AS cal_comp_forecast_amount,
    IF(comp_flag = '1', skf_fcst_qty, 0)                                                                                                                  AS cal_comp_forecast_90as3,
    IF(comp_flag = '1', fin_ly_amount, 0)                                                                                                                 AS cal_comp_ly_amount,
    IF(comp_flag = '1', skf_ly_qty, 0)                                                                                                                   AS cal_comp_ly_90as3
  FROM Aggregation_1 a
),

-- =====================================================================
-- CTE 13: CONV_DRUG
-- Logic: Filters VARIANCES to rows where SEGMENT is NULL or equals
--        'CONVDRUG' (case-insensitive), selecting only the columns
--        needed for ASP allocation calculations.
-- Source: VARIANCES
-- Filters: segment IS NULL OR UPPER(segment) = 'CONVDRUG'
-- =====================================================================
CONV_DRUG AS (
  SELECT
    mandt,
    _bic_zio_sweek,
    cal_rx_budget,
    skf_budget_qty,
    cal_rx_sales,
    cal_scripts_90as3,
    segment,
    prctr
  FROM VARIANCES
  WHERE segment IS NULL OR UPPER(segment) = 'CONVDRUG'
),

-- =====================================================================
-- CTE 14: TOTAL_ASP_BASE
-- Logic: Aggregates CONV_DRUG to the mandt + week level, summing the
--        four measures needed for total-ASP calculation.
-- Source: CONV_DRUG
-- Aggregation: SUM(cal_rx_budget), SUM(skf_budget_qty),
--              SUM(cal_rx_sales), SUM(cal_scripts_90as3)
--              GROUP BY mandt, _bic_zio_sweek
-- =====================================================================
TOTAL_ASP_BASE AS (
  SELECT
    mandt,
    _bic_zio_sweek,
    SUM(cal_rx_budget)      AS cal_rx_budget,
    SUM(skf_budget_qty)     AS skf_budget_qty,
    SUM(cal_rx_sales)       AS cal_rx_sales,
    SUM(cal_scripts_90as3)  AS cal_scripts_90as3
  FROM CONV_DRUG
  GROUP BY mandt, _bic_zio_sweek
),

-- =====================================================================
-- CTE 15: TOTAL_ASP_CALC
-- Logic: Computes budget ASP and flash ASP at the total (week) level.
--        Division-by-zero is guarded with IF(...=0,0,...).
-- Source: TOTAL_ASP_BASE
-- Calculation:
--   cal_total_budget_asp = IF(skf_budget_qty=0, 0,
--                             ROUND(SAFE_DIVIDE(cal_rx_budget,
--                                   skf_budget_qty), 2))
--   cal_total_flash_asp  = IF(cal_scripts_90as3=0, 0,
--                             ROUND(SAFE_DIVIDE(cal_rx_sales,
--                                   cal_scripts_90as3), 2))
-- =====================================================================
TOTAL_ASP_CALC AS (
  SELECT
    *,
    IF(skf_budget_qty = 0, 0,
       ROUND(SAFE_DIVIDE(cal_rx_budget, skf_budget_qty), 2))     AS cal_total_budget_asp,
    IF(cal_scripts_90as3 = 0, 0,
       ROUND(SAFE_DIVIDE(cal_rx_sales, cal_scripts_90as3), 2))   AS cal_total_flash_asp
  FROM TOTAL_ASP_BASE
),

-- =====================================================================
-- CTE 16: TOTAL_ASP
-- Logic: Computes the ASP percentage change at the total (week) level.
--        Division-by-zero is guarded.
-- Source: TOTAL_ASP_CALC
-- Calculation:
--   cal_asp_change_perct = IF(cal_total_budget_asp=0, 0,
--                             ROUND(SAFE_DIVIDE(cal_total_flash_asp,
--                                   cal_total_budget_asp) - 1, 4))
-- =====================================================================
TOTAL_ASP AS (
  SELECT
    *,
    IF(cal_total_budget_asp = 0, 0,
       ROUND(SAFE_DIVIDE(cal_total_flash_asp, cal_total_budget_asp) - 1, 4)) AS cal_asp_change_perct
  FROM TOTAL_ASP_CALC
),

-- =====================================================================
-- CTE 17: STORE_FLASH_BASE
-- Logic: Aggregates CONV_DRUG rows where cal_rx_budget is zero or NULL
--        (i.e., stores with no pre-allocated RX budget) to the
--        mandt + week + profit-center grain.
-- Source: CONV_DRUG
-- Filters: cal_rx_budget = 0 OR cal_rx_budget IS NULL
-- Aggregation: SUM(cal_rx_sales), SUM(cal_scripts_90as3),
--              SUM(cal_rx_budget)
--              GROUP BY mandt, _bic_zio_sweek, prctr
-- =====================================================================
STORE_FLASH_BASE AS (
  SELECT
    mandt,
    _bic_zio_sweek,
    prctr,
    SUM(cal_rx_sales)       AS cal_rx_sales,
    SUM(cal_scripts_90as3)  AS cal_scripts_90as3,
    SUM(cal_rx_budget)      AS cal_rx_budget
  FROM CONV_DRUG
  WHERE cal_rx_budget = 0 OR cal_rx_budget IS NULL
  GROUP BY mandt, _bic_zio_sweek, prctr
),

-- =====================================================================
-- CTE 18: STORE_FLASH
-- Logic: Computes store-level flash ASP for stores without a
--        pre-allocated RX budget.
-- Source: STORE_FLASH_BASE
-- Calculation:
--   cal_store_flash_asp = IF(cal_scripts_90as3=0, 0,
--                            ROUND(SAFE_DIVIDE(cal_rx_sales,
--                                  cal_scripts_90as3), 2))
-- =====================================================================
STORE_FLASH AS (
  SELECT
    *,
    IF(cal_scripts_90as3 = 0, 0,
       ROUND(SAFE_DIVIDE(cal_rx_sales, cal_scripts_90as3), 2)) AS cal_store_flash_asp
  FROM STORE_FLASH_BASE
),

-- =====================================================================
-- CTE 19: Join_4
-- Logic: LEFT JOINs STORE_FLASH with TOTAL_ASP on _bic_zio_sweek to
--        bring the total ASP change percentage alongside each store's
--        flash ASP.
-- Source: STORE_FLASH (s), TOTAL_ASP (t)
-- Join: LEFT JOIN STORE_FLASH s LEFT JOIN TOTAL_ASP t
--       ON s._bic_zio_sweek = t._bic_zio_sweek
-- =====================================================================
Join_4 AS (
  SELECT
    s.prctr,
    s._bic_zio_sweek,
    s.cal_store_flash_asp,
    t.cal_asp_change_perct
  FROM STORE_FLASH s
  LEFT JOIN TOTAL_ASP t
    USING (_bic_zio_sweek)
),

-- =====================================================================
-- CTE 20: ADJUSTED_ASP
-- Logic: Computes the adjusted ASP for stores without a pre-allocated
--        RX budget, using the total ASP change percentage.
--        Guards against cal_asp_change_perct = -1 (division by zero).
-- Source: Join_4
-- Calculation:
--   cal_asp_adj_amount = IF(cal_asp_change_perct = -1, 0,
--                           ROUND(SAFE_DIVIDE(cal_store_flash_asp,
--                                 1 + cal_asp_change_perct), 2))
-- =====================================================================
ADJUSTED_ASP AS (
  SELECT
    *,
    IF(cal_asp_change_perct = -1, 0,
       ROUND(SAFE_DIVIDE(cal_store_flash_asp,
                         1 + cal_asp_change_perct), 2)) AS cal_asp_adj_amount
  FROM Join_4
),

-- =====================================================================
-- CTE 21: Join_5
-- Logic: LEFT JOINs the full VARIANCES result with ADJUSTED_ASP on
--        prctr + _bic_zio_sweek to attach the adjusted ASP amount to
--        each variance row.
-- Source: VARIANCES (v), ADJUSTED_ASP (a)
-- Join: LEFT JOIN VARIANCES v LEFT JOIN ADJUSTED_ASP a
--       ON v.prctr = a.prctr AND v._bic_zio_sweek = a._bic_zio_sweek
-- =====================================================================
Join_5 AS (
  SELECT
    v.*,
    a.cal_asp_adj_amount
  FROM VARIANCES v
  LEFT JOIN ADJUSTED_ASP a
    USING (prctr, _bic_zio_sweek)
),

-- =====================================================================
-- CTE 22: BUDGET_ALLOCATION
-- Logic: Allocates RX budget per store.  The original cal_rx_budget is
--        preserved as rx_budget; the new cal_rx_budget uses the
--        adjusted ASP amount for stores with no pre-allocated budget
--        (cal_rx_budget = 0 or NULL), otherwise keeps the original.
-- Source: Join_5 (j)
-- Calculation:
--   rx_budget      = original cal_rx_budget (before allocation)
--   cal_rx_budget  = IF(cal_rx_budget=0 OR cal_rx_budget IS NULL,
--                       ROUND(skf_budget_qty * cal_asp_adj_amount, 2),
--                       cal_rx_budget)
-- =====================================================================
BUDGET_ALLOCATION AS (
  SELECT
    j.* EXCEPT (cal_rx_budget),
    cal_rx_budget                                                          AS rx_budget,
    IF(cal_rx_budget = 0 OR cal_rx_budget IS NULL,
       ROUND(skf_budget_qty * cal_asp_adj_amount, 2),
       cal_rx_budget)                                                      AS cal_rx_budget
  FROM Join_5 j
),

-- =====================================================================
-- CTE 23: EXCLUDE_PREALLOCATED
-- Logic: Selects rows from BUDGET_ALLOCATION where budget_comp_flag is
--        not NULL and the original rx_budget is zero or NULL (i.e.,
--        rows that were not pre-allocated and have a comp flag).
--        Used to compute comp-level allocated budget totals.
-- Source: BUDGET_ALLOCATION
-- Filters: budget_comp_flag IS NOT NULL;
--          rx_budget = 0 OR rx_budget IS NULL
-- =====================================================================
EXCLUDE_PREALLOCATED AS (
  SELECT
    budget_comp_flag,
    cal_rx_budget   AS cal_rx_budget_comp_level,
    rx_budget,
    _bic_zio_sweek
  FROM BUDGET_ALLOCATION
  WHERE budget_comp_flag IS NOT NULL
    AND (rx_budget = 0 OR rx_budget IS NULL)
),

-- =====================================================================
-- CTE 24: COMP_LEVEL_ALLOCATED_BUDGET
-- Logic: Aggregates EXCLUDE_PREALLOCATED to the comp-flag + week grain
--        and assigns a representative profit center based on the comp
--        flag value ('1' → '0000502656', else → '0000502657').
-- Source: EXCLUDE_PREALLOCATED
-- Aggregation: SUM(cal_rx_budget_comp_level), SUM(rx_budget)
--              GROUP BY budget_comp_flag, _bic_zio_sweek
-- Calculation:
--   cal_profit_center = IF(budget_comp_flag='1','0000502656','0000502657')
-- =====================================================================
COMP_LEVEL_ALLOCATED_BUDGET AS (
  SELECT
    budget_comp_flag,
    SUM(cal_rx_budget_comp_level)   AS cal_rx_budget_comp_level,
    SUM(rx_budget)                  AS rx_budget,
    _bic_zio_sweek,
    IF(budget_comp_flag = '1', '0000502656', '0000502657') AS cal_profit_center
  FROM EXCLUDE_PREALLOCATED
  GROUP BY budget_comp_flag, _bic_zio_sweek
),

-- =====================================================================
-- CTE 25: Join_6
-- Logic: LEFT JOINs BUDGET_ALLOCATION with COMP_LEVEL_ALLOCATED_BUDGET
--        on prctr = cal_profit_center AND _bic_zio_sweek to attach the
--        comp-level allocated budget total to each allocation row.
-- Source: BUDGET_ALLOCATION (b), COMP_LEVEL_ALLOCATED_BUDGET (c)
-- Join: LEFT JOIN on b.prctr = c.cal_profit_center
--                AND b._bic_zio_sweek = c._bic_zio_sweek
-- =====================================================================
Join_6 AS (
  SELECT
    b.*,
    c.cal_rx_budget_comp_level
  FROM BUDGET_ALLOCATION b
  LEFT JOIN COMP_LEVEL_ALLOCATED_BUDGET c
    ON b.prctr = c.cal_profit_center
   AND b._bic_zio_sweek = c._bic_zio_sweek
),

-- =====================================================================
-- CTE 26: DIFFERENCE_ADJUSTMENT
-- Logic: Computes the final RX budget (cal_rx_budget_final) and the
--        comp-level RX budget amount (cal_comp_rx_budget_amount) by
--        adjusting the allocation for the two representative profit
--        centers ('0000502656', '0000502657') when budget_comp_flag is
--        '0' or '1'.
-- Source: Join_6 (j)
-- Calculation:
--   cal_rx_budget_final =
--     IF(prctr IN ('0000502656','0000502657')
--        AND budget_comp_flag IN ('0','1'),
--        rx_budget - cal_rx_budget_comp_level,
--        cal_rx_budget)
--   cal_comp_rx_budget_amount =
--     IF(budget_comp_flag='1',
--        IF(prctr IN ('0000502656','0000502657')
--           AND budget_comp_flag IN ('0','1'),
--           rx_budget - cal_rx_budget_comp_level,
--           cal_rx_budget),
--        0)
-- =====================================================================
DIFFERENCE_ADJUSTMENT AS (
  SELECT
    j.*,
    IF(prctr IN ('0000502656', '0000502657')
       AND budget_comp_flag IN ('0', '1'),
       rx_budget - cal_rx_budget_comp_level,
       cal_rx_budget)                                                      AS cal_rx_budget_final,
    IF(budget_comp_flag = '1',
       IF(prctr IN ('0000502656', '0000502657')
          AND budget_comp_flag IN ('0', '1'),
          rx_budget - cal_rx_budget_comp_level,
          cal_rx_budget),
       0)                                                                  AS cal_comp_rx_budget_amount
  FROM Join_6 j
)

-- =====================================================================
-- Final SELECT
-- Logic: Expands DIFFERENCE_ADJUSTMENT with all logical-model
--        calculated measures: comp flag derivation, comp flag
--        description, emerging market indicator label, formatted date
--        strings, and all comp-level variance calculations.
-- Source: DIFFERENCE_ADJUSTMENT (d)
-- Calculation:
--   cal_comp_flag      = GREATEST(COALESCE(comp_flag,'0'),
--                                 COALESCE(budget_comp_flag,'0'))
--   cal_comp_flag_desc = CASE cal_comp_flag
--                          WHEN '1' THEN 'Comp'
--                          WHEN '0' THEN 'Non-Comp'
--                          ELSE ''
--                        END
--   cal_emerg_mkt_ind  = IF(emerg_mkt_ind='Y','Yes',
--                           IF(emerg_mkt_ind='N','No',''))
--   zrwstrtdate_formatted = FORMAT_DATE('%m/%d/%Y',
--                             SAFE_CAST(zrwstrtdate AS DATE))
--   zrwenddate_formatted  = FORMAT_DATE('%m/%d/%Y',
--                             SAFE_CAST(zrwenddate AS DATE))
--   (plus all comp-level variance expressions — see below)
-- =====================================================================
SELECT
  d.*,
  GREATEST(COALESCE(comp_flag, '0'), COALESCE(budget_comp_flag, '0'))                                        AS cal_comp_flag,
  CASE GREATEST(COALESCE(comp_flag, '0'), COALESCE(budget_comp_flag, '0'))
    WHEN '1' THEN 'Comp'
    WHEN '0' THEN 'Non-Comp'
    ELSE ''
  END                                                                                                         AS cal_comp_flag_desc,
  IF(emerg_mkt_ind = 'Y', 'Yes', IF(emerg_mkt_ind = 'N', 'No', ''))                                         AS cal_emerg_mkt_ind,
  FORMAT_DATE('%m/%d/%Y', SAFE_CAST(zrwstrtdate AS DATE))                                                    AS zrwstrtdate_formatted,
  FORMAT_DATE('%m/%d/%Y', SAFE_CAST(zrwenddate AS DATE))                                                     AS zrwenddate_formatted,
  cal_comp_fs_salesamount - cal_comp_fs_budget_amount                                                        AS cal_comp_fs_bud_var,
  IF(fs_rx_flag = 'FS', cal_comp_fs_salesamount - cal_comp_forecast_amount, 0)                               AS cal_comp_fs_forecast_var,
  IF(fs_rx_flag = 'FS', cal_comp_fs_salesamount - cal_comp_ly_amount, 0)                                     AS cal_comp_fs_ly_var,
  cal_comp_rx_salesamount - cal_comp_rx_budget_amount                                                        AS cal_comp_rx_bud_var,
  IF(fs_rx_flag_ext = 'RX', cal_comp_rx_salesamount - cal_comp_forecast_amount, 0)                           AS cal_comp_rx_forecast_var,
  IF(fs_rx_flag_ext = 'RX', cal_comp_rx_salesamount - cal_comp_ly_amount, 0)                                 AS cal_comp_rx_ly_var,
  cal_comp_flash_90as3 - cal_comp_forecast_90as3                                                             AS cal_comp_skf_forecast_var,
  cal_comp_flash_90as3 - cal_comp_budget_90as3                                                               AS cal_comp_skf_bud_var,
  cal_comp_flash_90as3 - cal_comp_ly_90as3                                                                   AS cal_comp_skf_ly_var,
  cal_comp_corpfs_sales_amount - cal_comp_fs_budget_amount                                                   AS cal_comp_fs_bud_corp_var,
  IF(fs_rx_flag = 'FS', cal_comp_corpfs_sales_amount - cal_comp_forecast_amount, 0)                          AS cal_comp_fs_forecast_corp_var,
  IF(fs_rx_flag = 'FS', cal_comp_corpfs_sales_amount - cal_comp_ly_amount, 0)                                AS cal_comp_fs_ly_corp_var
FROM DIFFERENCE_ADJUSTMENT d;
