-- =====================================================================
-- CONSOLIDATED BIGQUERY SQL FOR CV_COMP_SKF_BUDGET_STATIC
-- Generated from HANA Calculation View with full dependency expansion
-- Runtime Parameters: @ip_version, @ip_week_ending_from, @ip_week_ending_to
-- =====================================================================

-- =====================================================================
-- CTE 1: Frozen_Cube_DS092
-- Logic: Source frozen budget data from AZSRP_DS092_VT_S4 with client and freeze count filters
-- Source: edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds092
-- Filters: mandt IN ('120', '200') AND @ip_fc_count != '0'
-- =====================================================================
WITH Frozen_Cube_DS092 AS (
  SELECT
    fiscper,
    fiscvarnt,
    bic_zio_sweek,
    fiscyear,
    fiscper3,
    b631_s_chrtacct,
    bic_zio_psty,
    bic_zio_pskf,
    b631_s_co_area,
    bic_zio_cmpcd,
    b631_s_proftctr,
    b631_s_costcntr,
    b631_s_funcarea,
    bic_zio_ver,
    bic_zio_saudt,
    mandt,
    recordmode,
    unit,
    bic_zio_skfq
  FROM `edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds092`
  WHERE
    mandt IN ('120', '200')
    AND @ip_fc_count != '0'
),

-- =====================================================================
-- CTE 2: Live_Cube_DS031
-- Logic: Source live budget data from AZSRP_DS031_VT_S4 with client and freeze count filters
-- Source: edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds031
-- Filters: mandt IN ('120', '200') AND @ip_fc_count = '0'
-- =====================================================================
Live_Cube_DS031 AS (
  SELECT
    fiscper,
    fiscvarnt,
    bic_zio_sweek,
    fiscyear,
    fiscper3,
    b631_s_compcode,
    bic_zio_cctr,
    bic_zio_pctr,
    bic_zio_psty,
    bic_zio_pskf,
    b631_s_co_area,
    bic_zio_cmpcd,
    bic_zio_ver,
    bic_zio_saudt,
    mandt,
    recordmode,
    unit,
    bic_zio_skfq
  FROM `edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds031`
  WHERE
    mandt IN ('120', '200')
    AND @ip_fc_count = '0'
),

-- =====================================================================
-- CTE 3: Combined_Weekly_Budget
-- Logic: Union frozen and live budget data with FLAG indicator and conditional measure selection
-- Source: Frozen_Cube_DS092 UNION ALL Live_Cube_DS031
-- Calculation: Implements IF(ISNULL(RES_QUANT_FC), RES_QUANT_LC, RES_QUANT_FC) logic via CASE
-- =====================================================================
Combined_Weekly_Budget AS (
  SELECT
    fiscper,
    fiscvarnt,
    bic_zio_sweek,
    fiscyear,
    fiscper3,
    b631_s_chrtacct,
    bic_zio_psty,
    bic_zio_pskf,
    b631_s_co_area,
    bic_zio_cmpcd,
    b631_s_proftctr,
    b631_s_costcntr,
    b631_s_funcarea,
    bic_zio_ver,
    bic_zio_saudt,
    mandt,
    recordmode,
    unit,
    bic_zio_skfq,
    'FC' AS flag
  FROM Frozen_Cube_DS092
  
  UNION ALL
  
  SELECT
    fiscper,
    fiscvarnt,
    bic_zio_sweek,
    fiscyear,
    fiscper3,
    CAST(NULL AS STRING) AS b631_s_chrtacct,
    bic_zio_psty,
    bic_zio_pskf,
    b631_s_co_area,
    bic_zio_cmpcd,
    bic_zio_pctr AS b631_s_proftctr,
    bic_zio_cctr AS b631_s_costcntr,
    CAST(NULL AS STRING) AS b631_s_funcarea,
    bic_zio_ver,
    bic_zio_saudt,
    mandt,
    recordmode,
    unit,
    bic_zio_skfq,
    'LC' AS flag
  FROM Live_Cube_DS031
),

-- =====================================================================
-- CTE 4: Aggregated_Weekly_Budget
-- Logic: Aggregate budget data with conditional FC/LC measure selection
-- Aggregation: GROUP BY all non-measure columns, calculate final bic_zio_skfq measure
-- =====================================================================
Aggregated_Weekly_Budget AS (
  SELECT
    fiscper,
    fiscvarnt,
    bic_zio_sweek,
    fiscyear,
    fiscper3,
    b631_s_chrtacct,
    bic_zio_psty,
    bic_zio_pskf,
    b631_s_co_area,
    bic_zio_cmpcd,
    b631_s_proftctr,
    b631_s_costcntr,
    b631_s_funcarea,
    bic_zio_ver,
    bic_zio_saudt,
    mandt,
    recordmode,
    unit,
    COALESCE(
      SUM(CASE WHEN flag = 'FC' THEN bic_zio_skfq END),
      SUM(CASE WHEN flag = 'LC' THEN bic_zio_skfq END)
    ) AS bic_zio_skfq
  FROM Combined_Weekly_Budget
  GROUP BY
    fiscper, fiscvarnt, bic_zio_sweek, fiscyear, fiscper3, b631_s_chrtacct,
    bic_zio_psty, bic_zio_pskf, b631_s_co_area, bic_zio_cmpcd, b631_s_proftctr,
    b631_s_costcntr, b631_s_funcarea, bic_zio_ver, bic_zio_saudt, mandt,
    recordmode, unit
),

-- =====================================================================
-- CTE 5: Filtered_Weekly_Snapshot
-- Logic: Apply final-consumer filters to weekly budget data
-- Source: Aggregated_Weekly_Budget
-- Filters: fiscvarnt='K4', bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to, 
--          bic_zio_ver=@ip_version, bic_zio_saudt IN ('1','10'), bic_zio_pskf IN ('804013','801000')
-- =====================================================================
Filtered_Weekly_Snapshot AS (
  SELECT
    fiscper,
    fiscvarnt,
    fiscyear,
    fiscper3,
    mandt,
    recordmode,
    bic_zio_sweek,
    b631_s_co_area,
    bic_zio_cmpcd,
    b631_s_proftctr,
    b631_s_costcntr,
    bic_zio_ver,
    bic_zio_saudt,
    bic_zio_psty,
    bic_zio_pskf,
    unit,
    bic_zio_skfq
  FROM Aggregated_Weekly_Budget
  WHERE
    fiscvarnt = 'K4'
    AND bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to
    AND bic_zio_ver = @ip_version
    AND bic_zio_saudt IN ('1', '10')
    AND bic_zio_pskf IN ('804013', '801000')
),

-- =====================================================================
-- CTE 6: Filtered_Hierarchy_Nodes
-- Logic: Filter hierarchy nodes for CORERET parent nodes with valid-to date
-- Source: edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node
-- Filters: REGEXP_CONTAINS(parnode, r'CORERET$') AND hryvalto='99991231', mandt IN ('120','200')
-- =====================================================================
Filtered_Hierarchy_Nodes AS (
  SELECT
    mandt,
    parnode,
    hryvalto,
    nodevalue
  FROM `edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node`
  WHERE
    mandt IN ('120', '200')
    AND REGEXP_CONTAINS(parnode, r'CORERET$')
    AND hryvalto = '99991231'
),

-- =====================================================================
-- CTE 7: Joined_With_Hierarchy
-- Logic: Inner join weekly snapshot with hierarchy nodes to map cost centers
-- Join: b631_s_costcntr = nodevalue
-- =====================================================================
Joined_With_Hierarchy AS (
  SELECT
    ws.fiscper,
    ws.fiscvarnt,
    ws.fiscyear,
    ws.fiscper3,
    ws.mandt,
    ws.recordmode,
    ws.bic_zio_sweek,
    ws.b631_s_co_area,
    ws.bic_zio_cmpcd,
    ws.b631_s_proftctr,
    hn.nodevalue AS b631_s_costcntr,
    ws.bic_zio_ver,
    ws.bic_zio_saudt,
    ws.bic_zio_psty,
    ws.bic_zio_pskf,
    ws.unit,
    ws.bic_zio_skfq
  FROM Filtered_Weekly_Snapshot ws
  INNER JOIN Filtered_Hierarchy_Nodes hn
    ON ws.b631_s_costcntr = hn.nodevalue
),

-- =====================================================================
-- CTE 8: Store_Attributes_Actual
-- Logic: Source store/profit center attributes from staging table populated by STP_WSS_SRP_ATTRIBUTES
-- Source: edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act (via TBL_WSS_SRP_ATTR_ACT)
-- Note: Staging table populated by procedure with filter from CV_BASE_MD_SRPACT_S4
-- =====================================================================
Store_Attributes_Actual AS (
  SELECT
    mandt,
    strnum,
    prctr,
    rep_mkt_code,
    rep_mkt_desc,
    emerg_mkt_ind,
    division_code,
    division_desc,
    area_code,
    area_desc,
    district_code,
    district_desc,
    region_code,
    region_desc,
    city,
    state,
    fs_open_dat,
    rx_open_dat,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code
  FROM `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act`
),

-- =====================================================================
-- CTE 9: Joined_With_Store_Attributes
-- Logic: Left join with store attributes to enrich profit center data
-- Join: b631_s_proftctr = prctr
-- =====================================================================
Joined_With_Store_Attributes AS (
  SELECT
    jh.*,
    sa.rep_mkt_code,
    sa.rep_mkt_desc,
    sa.emerg_mkt_ind,
    sa.strnum,
    sa.division_code,
    sa.division_desc,
    sa.area_code,
    sa.area_desc,
    sa.district_code,
    sa.district_desc,
    sa.region_code,
    sa.region_desc,
    sa.city,
    sa.state,
    sa.fs_open_dat,
    sa.rx_open_dat,
    sa.rx_division_code,
    sa.rx_area_code,
    sa.rx_region_code,
    sa.rx_district_code
  FROM Joined_With_Hierarchy jh
  LEFT JOIN Store_Attributes_Actual sa
    ON jh.b631_s_proftctr = sa.prctr
),

-- =====================================================================
-- CTE 10: Comp_Flag_Budget
-- Logic: Source comp flag data from staging table populated by STP_WSS_SRP_ATTRIBUTES with version filter
-- Source: edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl (via TBL_WSS_SRP_COMPFLAG)
-- Filters: comp_ver = @ip_version, zweek = @v_week (from procedure)
-- Note: Procedure filters by zweek = V_WEEK where V_WEEK = SFN_PRIOR_FISCAL_WEEK()
-- =====================================================================
Comp_Flag_Budget AS (
  SELECT
    mandt,
    prctr,
    strnum,
    rx_comp_wk,
    zweek,
    zmonth,
    zyear,
    comp_ver
  FROM `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl`
  WHERE comp_ver = @ip_version
),

-- =====================================================================
-- CTE 11: Joined_With_Comp_Flags
-- Logic: Left join with comp flags to add comparable store indicators
-- Join: b631_s_proftctr = prctr AND bic_zio_sweek = zweek
-- =====================================================================
Joined_With_Comp_Flags AS (
  SELECT
    js.*,
    cf.rx_comp_wk
  FROM Joined_With_Store_Attributes js
  LEFT JOIN Comp_Flag_Budget cf
    ON js.b631_s_proftctr = cf.prctr
    AND js.bic_zio_sweek = cf.zweek
),

-- =====================================================================
-- CTE 12: Calendar_Week
-- Logic: Source retail calendar week attributes
-- Source: edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek
-- Filters: rclnt IN ('120','200')
-- =====================================================================
Calendar_Week AS (
  SELECT
    zrwstrtdate,
    zrwenddate,
    zzweek,
    rclnt
  FROM `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek`
  WHERE rclnt IN ('120', '200')
),

-- =====================================================================
-- CTE 13: Joined_With_Calendar
-- Logic: Left join with calendar week to add week start/end dates
-- Join: bic_zio_sweek = zzweek
-- =====================================================================
Joined_With_Calendar AS (
  SELECT
    jc.*,
    cw.zrwenddate,
    cw.zrwstrtdate
  FROM Joined_With_Comp_Flags jc
  LEFT JOIN Calendar_Week cw
    ON jc.bic_zio_sweek = cw.zzweek
),

-- =====================================================================
-- CTE 14: Profit_Center_Text
-- Logic: Source profit center text descriptions
-- Source: edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct
-- Filters: mandt IN ('120','200')
-- =====================================================================
Profit_Center_Text AS (
  SELECT
    mandt,
    prctr,
    ltext AS profit_center_text
  FROM `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct`
  WHERE mandt IN ('120', '200')
),

-- =====================================================================
-- CTE 15: Joined_With_Profit_Center_Text
-- Logic: Left join with profit center text for descriptions
-- Join: b631_s_proftctr = prctr
-- =====================================================================
Joined_With_Profit_Center_Text AS (
  SELECT
    jcal.*,
    pct.profit_center_text
  FROM Joined_With_Calendar jcal
  LEFT JOIN Profit_Center_Text pct
    ON jcal.b631_s_proftctr = pct.prctr
),

-- =====================================================================
-- CTE 16: Calculated_Attributes
-- Logic: Apply final calculated columns from CV_COMP_SKF_BUDGET_STATIC FLAGS node
-- Calculation: CAL_WEEK_NUMBER = RIGHT(bic_zio_sweek, 2)
--              CAL_BIC_ZIO_SKFQ = CASE WHEN bic_zio_pskf='804013' THEN bic_zio_skfq*2 ELSE bic_zio_skfq END
--              CAL_RX_COMP_WK = IFNULL(rx_comp_wk, '0')
-- =====================================================================
Calculated_Attributes AS (
  SELECT
    mandt,
    fiscper,
    fiscvarnt,
    fiscyear,
    fiscper3,
    recordmode,
    bic_zio_sweek,
    b631_s_co_area,
    bic_zio_cmpcd,
    b631_s_proftctr,
    b631_s_costcntr,
    bic_zio_ver,
    bic_zio_saudt,
    rep_mkt_code,
    rep_mkt_desc,
    emerg_mkt_ind,
    bic_zio_psty,
    bic_zio_pskf,
    unit,
    division_code,
    division_desc,
    area_code,
    area_desc,
    district_code,
    district_desc,
    region_code,
    region_desc,
    strnum,
    zrwenddate,
    zrwstrtdate,
    city,
    state,
    profit_center_text,
    fs_open_dat,
    rx_open_dat,
    rx_division_code,
    rx_area_code,
    rx_region_code,
    rx_district_code,
    bic_zio_skfq,
    -- Calculated columns
    RIGHT(CAST(bic_zio_sweek AS STRING), 2) AS cal_week_number,
    CASE 
      WHEN bic_zio_pskf = '804013' THEN CAST(bic_zio_skfq AS NUMERIC) * 2 
      ELSE CAST(bic_zio_skfq AS NUMERIC) 
    END AS cal_bic_zio_skfq,
    IFNULL(rx_comp_wk, '0') AS cal_rx_comp_wk
  FROM Joined_With_Profit_Center_Text
)

-- =====================================================================
-- FINAL SELECT: CV_COMP_SKF_BUDGET_STATIC Output
-- Logic: Final aggregation with GROUP BY on all attributes and SUM on measures
-- Aggregation: SUM(bic_zio_skfq) AS bic_zio_skfq_negative, SUM(cal_bic_zio_skfq) AS bic_zio_skfq
-- Output: All attributes plus two aggregated measures as per CUBE definition
-- =====================================================================
SELECT
  mandt,
  fiscper,
  fiscvarnt,
  fiscyear,
  fiscper3,
  recordmode,
  bic_zio_sweek,
  b631_s_co_area,
  bic_zio_cmpcd,
  b631_s_proftctr,
  b631_s_costcntr,
  bic_zio_ver,
  bic_zio_saudt,
  rep_mkt_code,
  rep_mkt_desc,
  emerg_mkt_ind,
  bic_zio_psty,
  bic_zio_pskf,
  unit,
  division_code,
  division_desc,
  area_code,
  area_desc,
  district_code,
  district_desc,
  region_code,
  region_desc,
  cal_week_number,
  strnum,
  zrwenddate,
  zrwstrtdate,
  city,
  state,
  profit_center_text,
  fs_open_dat,
  rx_open_dat,
  cal_rx_comp_wk AS rx_comp_wk,
  rx_division_code,
  rx_area_code,
  rx_region_code,
  rx_district_code,
  -- Measures
  SUM(bic_zio_skfq) AS bic_zio_skfq_negative,
  SUM(cal_bic_zio_skfq) AS bic_zio_skfq
FROM Calculated_Attributes
GROUP BY
  mandt, fiscper, fiscvarnt, fiscyear, fiscper3, recordmode, bic_zio_sweek,
  b631_s_co_area, bic_zio_cmpcd, b631_s_proftctr, b631_s_costcntr, bic_zio_ver,
  bic_zio_saudt, rep_mkt_code, rep_mkt_desc, emerg_mkt_ind, bic_zio_psty,
  bic_zio_pskf, unit, division_code, division_desc, area_code, area_desc,
  district_code, district_desc, region_code, region_desc, cal_week_number,
  strnum, zrwenddate, zrwstrtdate, city, state, profit_center_text,
  fs_open_dat, rx_open_dat, cal_rx_comp_wk, rx_division_code, rx_area_code,
  rx_region_code, rx_district_code
