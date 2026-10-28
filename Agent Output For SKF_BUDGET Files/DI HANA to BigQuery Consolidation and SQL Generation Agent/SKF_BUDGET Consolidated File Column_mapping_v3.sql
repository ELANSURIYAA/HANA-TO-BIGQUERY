-- =====================================================================
-- CONSOLIDATED BIGQUERY SQL FOR CV_COMP_SKF_BUDGET_STATIC
-- Final Consumer: CV_COMP_SKF_BUDGET_STATIC
-- Generated from HANA Calculation View dependencies
-- All physical table and column names mapped via Columns_Mapping.csv
-- Runtime parameters: @ip_version, @ip_week_ending_from, @ip_week_ending_to
-- =====================================================================

-- =====================================================================
-- CTE 1: Frozen_Cube_Base
-- Logic: Source frozen budget data from AZSRP_DS092_VT_S4 with client and freeze count filters
-- Source: edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds092
-- Filters: mandt IN ('120','200'), @ip_fc_count != '0'
-- =====================================================================
WITH Frozen_Cube_Base AS (
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
  FROM
    `edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds092`
  WHERE
    mandt IN ('120', '200')
    AND @ip_fc_count != '0'
),

-- =====================================================================
-- CTE 2: Live_Cube_Base
-- Logic: Source live budget data from AZSRP_DS031_VT_S4 with client and freeze count filters
-- Source: edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds031
-- Filters: mandt IN ('120','200'), @ip_fc_count = '0'
-- =====================================================================
Live_Cube_Base AS (
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
  FROM
    `edp-qa-finstorage.edp_saps4_shared_cnsv.v_bic_azsrp_ds031`
  WHERE
    mandt IN ('120', '200')
    AND @ip_fc_count = '0'
),

-- =====================================================================
-- CTE 3: Combined_Budget_Data
-- Logic: Union frozen and live budget cubes with FLAG indicator, normalize columns
-- Source: Frozen_Cube_Base UNION ALL Live_Cube_Base
-- Calculation: FLAG='FC' for frozen, FLAG='LC' for live; map profit center and cost center from live cube
-- =====================================================================
Combined_Budget_Data AS (
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
  FROM
    Frozen_Cube_Base
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
  FROM
    Live_Cube_Base
),

-- =====================================================================
-- CTE 4: Weekly_Budget_Aggregated
-- Logic: Aggregate budget data by grouping dimensions, calculate final measure using frozen/live logic
-- Source: Combined_Budget_Data
-- Filters: fiscvarnt='K4', bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to, bic_zio_ver=@ip_version, bic_zio_saudt IN ('1','10'), bic_zio_pskf IN ('804013','801000')
-- Aggregation: GROUP BY all non-measure columns; measure = IF(SUM(FC) IS NULL, SUM(LC), SUM(FC))
-- =====================================================================
Weekly_Budget_Aggregated AS (
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
    IF(
      SUM(CASE WHEN flag = 'FC' THEN bic_zio_skfq ELSE NULL END) IS NULL,
      SUM(CASE WHEN flag = 'LC' THEN bic_zio_skfq ELSE NULL END),
      SUM(CASE WHEN flag = 'FC' THEN bic_zio_skfq ELSE NULL END)
    ) AS bic_zio_skfq
  FROM
    Combined_Budget_Data
  WHERE
    fiscvarnt = 'K4'
    AND bic_zio_sweek BETWEEN @ip_week_ending_from AND @ip_week_ending_to
    AND bic_zio_ver = @ip_version
    AND bic_zio_saudt IN ('1', '10')
    AND bic_zio_pskf IN ('804013', '801000')
  GROUP BY
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
    unit
),

-- =====================================================================
-- CTE 5: Hierarchy_Nodes_Filtered
-- Logic: Filter hierarchy nodes for CORERET parent and valid-to date
-- Source: edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node
-- Filters: mandt IN ('120','200'), REGEXP_CONTAINS(parnode, r'CORERET$'), hryvalto='99991231'
-- =====================================================================
Hierarchy_Nodes_Filtered AS (
  SELECT
    mandt,
    parnode,
    hryvalto,
    nodevalue
  FROM
    `edp-qa-finstorage.edp_saps4_shared_cnsv.v_hrrp_node`
  WHERE
    mandt IN ('120', '200')
    AND REGEXP_CONTAINS(parnode, r'CORERET$')
    AND hryvalto = '99991231'
),

-- =====================================================================
-- CTE 6: Budget_With_Hierarchy
-- Logic: Join budget data with hierarchy nodes on cost center
-- Source: Weekly_Budget_Aggregated INNER JOIN Hierarchy_Nodes_Filtered
-- Join: b631_s_costcntr = nodevalue
-- =====================================================================
Budget_With_Hierarchy AS (
  SELECT
    w.fiscper,
    w.fiscvarnt,
    w.fiscyear,
    w.fiscper3,
    w.mandt,
    w.recordmode,
    w.bic_zio_sweek,
    w.b631_s_co_area,
    w.bic_zio_cmpcd,
    w.b631_s_proftctr,
    h.nodevalue AS b631_s_costcntr,
    w.bic_zio_ver,
    w.bic_zio_saudt,
    w.bic_zio_psty,
    w.bic_zio_pskf,
    w.unit,
    w.bic_zio_skfq
  FROM
    Weekly_Budget_Aggregated w
  INNER JOIN
    Hierarchy_Nodes_Filtered h
    ON w.b631_s_costcntr = h.nodevalue
),

-- =====================================================================
-- CTE 7: Store_Attributes_Actual
-- Logic: Source store/profit center attributes from staging table populated by STP_WSS_SRP_ATTRIBUTES
-- Source: edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act (populated from CV_BASE_MD_SRPACT_S4)
-- Filters: mandt IN ('120','200')
-- Note: Staging table populated by procedure with all store attributes
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
  FROM
    `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_attr_act`
  WHERE
    mandt IN ('120', '200')
),

-- =====================================================================
-- CTE 8: Budget_With_Store_Attributes
-- Logic: Left join budget data with store attributes on profit center
-- Source: Budget_With_Hierarchy LEFT JOIN Store_Attributes_Actual
-- Join: b631_s_proftctr = prctr
-- =====================================================================
Budget_With_Store_Attributes AS (
  SELECT
    b.*,
    s.rep_mkt_code,
    s.rep_mkt_desc,
    s.emerg_mkt_ind,
    s.strnum,
    s.division_code,
    s.division_desc,
    s.area_code,
    s.area_desc,
    s.district_code,
    s.district_desc,
    s.region_code,
    s.region_desc,
    s.city,
    s.state,
    s.fs_open_dat,
    s.rx_open_dat,
    s.rx_division_code,
    s.rx_area_code,
    s.rx_region_code,
    s.rx_district_code
  FROM
    Budget_With_Hierarchy b
  LEFT JOIN
    Store_Attributes_Actual s
    ON b.b631_s_proftctr = s.prctr
),

-- =====================================================================
-- CTE 9: Comp_Flag_Budget
-- Logic: Source comp flag data from staging table populated by STP_WSS_SRP_ATTRIBUTES, filtered by version
-- Source: edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl (populated from CV_BASE_MD_COMPFL_S4 WHERE zweek=@v_week)
-- Filters: mandt IN ('120','200'), comp_ver=@ip_version
-- Note: Staging table populated by procedure with zweek filter
-- =====================================================================
Comp_Flag_Budget AS (
  SELECT
    mandt,
    prctr,
    strnum,
    rx_comp_wk,
    zweek,
    comp_ver
  FROM
    `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztsrp_compfl`
  WHERE
    mandt IN ('120', '200')
    AND comp_ver = @ip_version
),

-- =====================================================================
-- CTE 10: Budget_With_Comp_Flags
-- Logic: Left join budget data with comp flags on profit center and week
-- Source: Budget_With_Store_Attributes LEFT JOIN Comp_Flag_Budget
-- Join: b631_s_proftctr=prctr AND bic_zio_sweek=zweek
-- =====================================================================
Budget_With_Comp_Flags AS (
  SELECT
    b.*,
    c.rx_comp_wk
  FROM
    Budget_With_Store_Attributes b
  LEFT JOIN
    Comp_Flag_Budget c
    ON b.b631_s_proftctr = c.prctr
    AND b.bic_zio_sweek = c.zweek
),

-- =====================================================================
-- CTE 11: Calendar_Week
-- Logic: Source calendar week attributes
-- Source: edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek
-- Filters: rclnt IN ('120','200')
-- =====================================================================
Calendar_Week AS (
  SELECT
    zrwstrtdate,
    zrwenddate,
    zzweek,
    rclnt
  FROM
    `edp-qa-finstorage.edp_saps4_shared_cnsv.v_ztfigl_rcalweek`
  WHERE
    rclnt IN ('120', '200')
),

-- =====================================================================
-- CTE 12: Budget_With_Calendar
-- Logic: Left join budget data with calendar week on week number
-- Source: Budget_With_Comp_Flags LEFT JOIN Calendar_Week
-- Join: bic_zio_sweek=zzweek
-- =====================================================================
Budget_With_Calendar AS (
  SELECT
    b.*,
    c.zrwenddate,
    c.zrwstrtdate
  FROM
    Budget_With_Comp_Flags b
  LEFT JOIN
    Calendar_Week c
    ON b.bic_zio_sweek = c.zzweek
),

-- =====================================================================
-- CTE 13: Profit_Center_Text
-- Logic: Source profit center text descriptions
-- Source: edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct
-- Filters: mandt IN ('120','200')
-- =====================================================================
Profit_Center_Text AS (
  SELECT
    mandt,
    prctr,
    ltext AS profit_center_text
  FROM
    `edp-qa-finstorage.edp_saps4_shared_cnsv.v_cepct`
  WHERE
    mandt IN ('120', '200')
),

-- =====================================================================
-- CTE 14: Budget_With_Profit_Center_Text
-- Logic: Left join budget data with profit center text on profit center
-- Source: Budget_With_Calendar LEFT JOIN Profit_Center_Text
-- Join: b631_s_proftctr=prctr
-- Calculation: cal_week_number = RIGHT(bic_zio_sweek, 2), cal_bic_zio_skfq = CASE bic_zio_pskf='804013' THEN bic_zio_skfq*2 ELSE bic_zio_skfq, cal_rx_comp_wk = IFNULL(rx_comp_wk,'0')
-- =====================================================================
Budget_With_Profit_Center_Text AS (
  SELECT
    b.bic_zio_skfq,
    b.unit,
    b.bic_zio_pskf,
    b.bic_zio_psty,
    b.rx_comp_wk,
    b.fiscper,
    b.fiscvarnt,
    b.fiscyear,
    b.fiscper3,
    b.mandt,
    b.recordmode,
    b.bic_zio_sweek,
    b.b631_s_co_area,
    b.bic_zio_cmpcd,
    b.b631_s_proftctr,
    b.b631_s_costcntr,
    b.bic_zio_ver,
    b.bic_zio_saudt,
    b.rep_mkt_code,
    b.rep_mkt_desc,
    b.emerg_mkt_ind,
    b.division_code,
    b.division_desc,
    b.area_code,
    b.area_desc,
    b.district_code,
    b.district_desc,
    b.region_code,
    b.region_desc,
    b.strnum,
    b.zrwenddate,
    b.zrwstrtdate,
    b.city,
    b.state,
    p.profit_center_text,
    b.fs_open_dat,
    b.rx_open_dat,
    b.rx_division_code,
    b.rx_area_code,
    b.rx_region_code,
    b.rx_district_code,
    RIGHT(CAST(b.bic_zio_sweek AS STRING), 2) AS cal_week_number,
    CASE 
      WHEN b.bic_zio_pskf = '804013' THEN CAST(b.bic_zio_skfq AS NUMERIC) * 2 
      ELSE CAST(b.bic_zio_skfq AS NUMERIC) 
    END AS cal_bic_zio_skfq,
    IFNULL(b.rx_comp_wk, '0') AS cal_rx_comp_wk
  FROM
    Budget_With_Calendar b
  LEFT JOIN
    Profit_Center_Text p
    ON b.b631_s_proftctr = p.prctr
)

-- =====================================================================
-- FINAL SELECT: CV_COMP_SKF_BUDGET_STATIC Output
-- Logic: Final aggregation of budget data with all dimensions and calculated measures
-- Source: Budget_With_Profit_Center_Text
-- Aggregation: GROUP BY all non-measure columns; measures = SUM(bic_zio_skfq), SUM(cal_bic_zio_skfq)
-- Output: All dimension columns plus two aggregated measures
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
  'SKF_BUD_CUBE' AS skf_bud_cube,
  rx_division_code,
  rx_area_code,
  rx_region_code,
  rx_district_code,
  SUM(bic_zio_skfq) AS bic_zio_skfq_negative,
  SUM(cal_bic_zio_skfq) AS bic_zio_skfq
FROM
  Budget_With_Profit_Center_Text
GROUP BY
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
  cal_rx_comp_wk,
  rx_division_code,
  rx_area_code,
  rx_region_code,
  rx_district_code
