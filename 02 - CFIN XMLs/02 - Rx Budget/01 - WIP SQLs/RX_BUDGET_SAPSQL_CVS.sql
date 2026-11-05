/**********************************************************************************************
  READ-ONLY reconstruction of Calculation View
      CVS_FRIP.Composite.FI::CV_COMP_FIN_BUDGET_STATIC
  Target : SAP HANA SQL (FHP editor) -- output validation vs. the calc view
  Nature : SELECT + CTEs only. No CREATE / no DDL / no object touched. 100% read-only.

  WHAT'S DIFFERENT IN THIS VERSION vs. the prior file
  ----------------------------------------------------
   CV_BASE_MD_HRRP_NODE_S4 is now INLINED directly from its own documented source
   (schema "SAP_S4", table "HRRP_NODE", filter MANDT IN ('120','200') -- per that
   view's own XML) instead of referencing the activated "_SYS_BIC" runtime path.
   This removes ONE guess-the-package-path dependency entirely -- HIER_NODE now
   builds on top of the inlined "HRRP_NODE_BASE" CTE below, not on _SYS_BIC.

   Every other object (fact tables, store attr, comp flag, cal week, PC text) still
   uses "_SYS_BIC" activated paths -- confirm those against the discovery script
   (Part A: _SYS_REPO.ACTIVE_OBJECTS) before running if you haven't already.

  NAMING : every CTE uses the EXACT node id from its source XML, so you can trace
           each block back to its diagram 1:1.

  PROD-SAFETY NOTES (read before running in FHP prod)
  -----------------------------------------------------
   1) Pure SELECT/CTE only -- cannot write, cannot alter schema, cannot touch data.
   2) Set IP_WEEK_FROM = IP_WEEK_TO to ONE real fiscal week before running --
      this is what prunes the DSO before the UNION/joins and avoids the
      [403] STATEMENT_MEMORY_LIMIT you hit earlier.
   3) Test row counts on WEEKLY_SNAPSHOT_DS05 alone first (see smoke-test block
      at the very bottom, commented out) before running the full chain.
**********************************************************************************************/

WITH "PARAMS" AS (
    SELECT
        N'LEDGER_BUD' AS IP_VERSION,        /* Store / Comp version                          */
        N'2026035'    AS IP_WEEK_FROM,      /* <-- SET real fiscal week (SFN_PRIOR_FISCAL_WEEK)*/
        N'2026035'    AS IP_WEEK_TO,        /* <-- SET real fiscal week (usually same week)   */
        N'1'          AS IP_FC_COUNT        /* N1 = Frozen DS052   N0 = Live DS041            */
    FROM DUMMY
),

/* ============================================================================
   Node: Frozen_Cube  (base view CV_BASE_FIN_WEEKLY_BUDGET_S4, inlined)
   ============================================================================ */
"Frozen_Cube" AS (
    SELECT
        T.FISCPER, T.FISCVARNT, T._BIC_ZIO_SWEEK, T.FISCYEAR, T.FISCPER3,
        T._B631_S_CHRTACCT, T._B631_S_GL_ACCT, T._B631_S_CO_AREA, T._BIC_ZIO_CMPCD,
        T._B631_S_PROFTCTR, T._B631_S_COSTCNTR, T._B631_S_FUNCAREA,
        T._BIC_ZIO_VER, T._BIC_ZIO_SAUDT, T.MANDT,
        T._BIC_ZWWPC_PA1, T._BIC_ZWWSC_PA1, T.RECORDMODE, T.CURRENCY,
        T._B631_S_AMOUNT, T._BIC_ZIO_AMT,
        N'FC' AS FLAG
    FROM "CVS_FRIP"."AZSRP_DS052_VT_S4" T
    CROSS JOIN "PARAMS" P
    WHERE T.MANDT IN ( N'110', N'200' )
      AND P.IP_FC_COUNT <> 0
      AND T.FISCVARNT      = N'K4'                                 -- perf pushdown
      AND T._BIC_ZIO_VER   = P.IP_VERSION                          -- perf pushdown
      AND T._BIC_ZIO_SAUDT IN ( N'1', N'10' )                      -- perf pushdown
      AND T._BIC_ZIO_SWEEK BETWEEN P.IP_WEEK_FROM AND P.IP_WEEK_TO  -- perf pushdown
),

/* ============================================================================
   Node: Live_Cube
   ============================================================================ */
"Live_Cube" AS (
    SELECT
        T.FISCPER, T.FISCVARNT, T._BIC_ZIO_SWEEK, T.FISCYEAR, T.FISCPER3,
        T._B631_S_CHRTACCT, T._B631_S_GL_ACCT, T._B631_S_CO_AREA, T._BIC_ZIO_CMPCD,
        T._BIC_ZIO_PCTR AS _B631_S_PROFTCTR,     -- rename per base view
        T._BIC_ZIO_CCTR AS _B631_S_COSTCNTR,     -- rename per base view
        T._B631_S_FUNCAREA,
        T._BIC_ZIO_VER, T._BIC_ZIO_SAUDT, T.MANDT,
        T._BIC_ZWWPC_PA1, T._BIC_ZWWSC_PA1, T.RECORDMODE, T.CURRENCY,
        T._B631_S_AMOUNT, T._BIC_ZIO_AMT,
        N'LC' AS FLAG
    FROM "CVS_FRIP"."AZSRP_DS041_VT_S4" T
    CROSS JOIN "PARAMS" P
    WHERE T.MANDT IN ( N'110', N'200' )
      AND P.IP_FC_COUNT = 0
      AND T.FISCVARNT      = N'K4'                                 -- perf pushdown
      AND T._BIC_ZIO_VER   = P.IP_VERSION                          -- perf pushdown
      AND T._BIC_ZIO_SAUDT IN ( N'1', N'10' )                      -- perf pushdown
      AND T._BIC_ZIO_SWEEK BETWEEN P.IP_WEEK_FROM AND P.IP_WEEK_TO  -- perf pushdown
),

/* ============================================================================
   Node: Union_1
   ============================================================================ */
"Union_1" AS (
    SELECT * FROM "Frozen_Cube"
    UNION ALL
    SELECT * FROM "Live_Cube"
),

/* ============================================================================
   Base view's own Aggregation output = what the parent calls "CV_BASE_FIN_WEEKLY_BUDGET_S4"
   ============================================================================ */
"CV_BASE_FIN_WEEKLY_BUDGET_S4" AS (
    SELECT
        FISCPER, FISCVARNT, FISCYEAR, FISCPER3, MANDT, _BIC_ZIO_SWEEK,
        _B631_S_CHRTACCT, _B631_S_CO_AREA, _BIC_ZIO_CMPCD, _B631_S_PROFTCTR,
        _B631_S_COSTCNTR, _B631_S_FUNCAREA, _BIC_ZIO_VER, _BIC_ZIO_SAUDT,
        _B631_S_GL_ACCT, _BIC_ZWWPC_PA1, _BIC_ZWWSC_PA1, CURRENCY, FLAG,
        COALESCE(
            SUM( CASE WHEN FLAG = N'FC' THEN _B631_S_AMOUNT END ),
            SUM( CASE WHEN FLAG = N'LC' THEN _B631_S_AMOUNT END )
        ) AS _B631_S_AMOUNT,
        SUM( _BIC_ZIO_AMT ) AS _BIC_ZIO_AMT
    FROM "Union_1"
    GROUP BY
        FISCPER, FISCVARNT, FISCYEAR, FISCPER3, MANDT, _BIC_ZIO_SWEEK,
        _B631_S_CHRTACCT, _B631_S_CO_AREA, _BIC_ZIO_CMPCD, _B631_S_PROFTCTR,
        _B631_S_COSTCNTR, _B631_S_FUNCAREA, _BIC_ZIO_VER, _BIC_ZIO_SAUDT,
        _B631_S_GL_ACCT, _BIC_ZWWPC_PA1, _BIC_ZWWSC_PA1, CURRENCY, FLAG
),

/* ============================================================================
   Node 1: WEEKLY_SNAPSHOT_DS05  (Projection on base view + the parent's OWN filters,
   placed exactly where the XML puts them)
   ============================================================================ */
"WEEKLY_SNAPSHOT_DS05" AS (
    SELECT
        B.*
    FROM "CV_BASE_FIN_WEEKLY_BUDGET_S4" B
    CROSS JOIN "PARAMS" P
    WHERE B.FISCVARNT      = N'K4'                                  -- <viewAttribute FISCVARNT> filter
      AND B._BIC_ZIO_VER   = P.IP_VERSION                           -- <viewAttribute _BIC_ZIO_VER> filter
      AND B._BIC_ZIO_SAUDT IN ( N'1', N'10' )                       -- <viewAttribute _BIC_ZIO_SAUDT> filter
      AND B._BIC_ZIO_SWEEK BETWEEN P.IP_WEEK_FROM AND P.IP_WEEK_TO   -- <viewAttribute _BIC_ZIO_SWEEK> range filter
),

/* ============================================================================
   *** INLINED NODE LOGIC: CV_BASE_MD_HRRP_NODE_S4 ***
   Source XML: id="CV_BASE_MD_HRRP_NODE_S4", dataCategory="DIMENSION",
               outputViewType="Projection", node id "Projection_1"
   Raw source: schemaName="SAP_S4" columnObjectName="HRRP_NODE"
   Filter    : MANDT IN ('120','200')   -- this view's OWN filter, per its XML
   This is a 1:1 pass-through projection -- no renames, no calculated columns.
   Built here directly from the raw table so HIER_NODE below has ZERO dependency
   on guessing the "_SYS_BIC" activated package path for this object.
   ============================================================================ */
"HRRP_NODE_BASE" AS (
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
    FROM "SAP_S4"."HRRP_NODE"
    WHERE MANDT IN ( N'120', N'200' )        -- Projection_1 filter, per CV_BASE_MD_HRRP_NODE_S4 XML
),

/* ============================================================================
   Node 2: HIER_NODE  (from CV_COMP_FIN_BUDGET_STATIC -- now reads HRRP_NODE_BASE
   above instead of _SYS_BIC, adds the CORE_RET + "still valid" restriction)
   ============================================================================ */
"HIER_NODE" AS (
    SELECT
        MANDT, PARNODE, HRYVALTO, NODEVALUE
    FROM "HRRP_NODE_BASE"
    WHERE PARNODE   LIKE '%CORE_RET'      -- match("PARNODE",'*CORE_RET')
      AND HRYVALTO  = N'99991231'
),

/* ============================================================================
   Node 3: Join_1  (INNER, cardinality CN_1)
   join key: _B631_S_PROFTCTR = NODEVALUE   (PARNODE is a pass-through, NOT a join key)
   ============================================================================ */
"Join_1" AS (
    SELECT
        F.*,
        H.PARNODE            -- carried through per XML mapping target="PARNODE" source="PARNODE"
    FROM "WEEKLY_SNAPSHOT_DS05" F
    INNER JOIN "HIER_NODE" H
            ON F._B631_S_PROFTCTR = H.NODEVALUE     -- <joinAttribute name="_B631_S_PROFTCTR"/>
),

/* ============================================================================
   Node 4: ONLY_CORE_RET_DATA  (cleanup projection -- drops PARNODE, per XML viewAttributes)
   ============================================================================ */
"ONLY_CORE_RET_DATA" AS (
    SELECT
        FISCPER, FISCVARNT, FISCYEAR, FISCPER3, MANDT, _BIC_ZIO_SWEEK,
        _B631_S_CHRTACCT, _B631_S_CO_AREA, _BIC_ZIO_CMPCD, _B631_S_PROFTCTR,
        _B631_S_COSTCNTR, _B631_S_FUNCAREA, _BIC_ZIO_VER, _BIC_ZIO_SAUDT,
        _B631_S_GL_ACCT, _BIC_ZWWPC_PA1, _BIC_ZWWSC_PA1, _B631_S_AMOUNT,
        CURRENCY, _BIC_ZIO_AMT, FLAG
        -- PARNODE intentionally dropped here (not in XML viewAttributes for this node)
    FROM "Join_1"
),

/* ============================================================================
   Node 5: STORE_ATTR_ACTUAL
   ============================================================================ */
"STORE_ATTR_ACTUAL" AS (
    SELECT
        PRCTR, REP_MKT_CODE, REP_MKT_DESC, EMERG_MKT_IND,
        DIVISION_CODE, DIVISION_DESC, AREA_CODE, AREA_DESC,
        DISTRICT_CODE, DISTRICT_DESC, REGION_CODE, REGION_DESC,
        STRNUM, CITY, STATE, FS_OPEN_DAT, RX_OPEN_DAT,
        RX_DIVISION_CODE, RX_AREA_CODE, RX_REGION_CODE, RX_DISTRICT_CODE
    FROM "_SYS_BIC"."CVS_FRIP.Composite.Master/CV_COMP_MD_SRPACT_STATIC"
),

/* ============================================================================
   Node 6: Join_2  (LEFT OUTER)   join key: _B631_S_PROFTCTR = PRCTR
   ============================================================================ */
"Join_2" AS (
    SELECT
        C.*,
        S.REP_MKT_CODE, S.REP_MKT_DESC, S.EMERG_MKT_IND,
        S.DIVISION_CODE, S.DIVISION_DESC, S.AREA_CODE, S.AREA_DESC,
        S.DISTRICT_CODE, S.DISTRICT_DESC, S.REGION_CODE, S.REGION_DESC,
        S.STRNUM, S.CITY, S.STATE, S.FS_OPEN_DAT, S.RX_OPEN_DAT,
        S.RX_DIVISION_CODE, S.RX_AREA_CODE, S.RX_REGION_CODE, S.RX_DISTRICT_CODE
    FROM "ONLY_CORE_RET_DATA" C
    LEFT OUTER JOIN "STORE_ATTR_ACTUAL" S
            ON C._B631_S_PROFTCTR = S.PRCTR
),

/* ============================================================================
   Node 7: WEEK_NUMBER  (Projection + 1 calc column)
   ============================================================================ */
"WEEK_NUMBER" AS (
    SELECT
        J2.*,
        RIGHT( J2._BIC_ZIO_SWEEK, 2 ) AS CAL_STORE_WEEK_NUMBER
    FROM "Join_2" J2
),

/* ============================================================================
   Node 8: COMP_FLAG_BUDGET  (filter COMP_VER = IP_VERSION)
   ============================================================================ */
"COMP_FLAG_BUDGET" AS (
    SELECT CF.PRCTR, CF.ZWEEK, CF.FS_COMP_WK, CF.RX_COMP_WK
    FROM "_SYS_BIC"."CVS_FRIP.Composite.Master/CV_COMP_MD_COMPFL_STATIC" CF
    CROSS JOIN "PARAMS" P
    WHERE CF.COMP_VER = P.IP_VERSION
),

/* ============================================================================
   Node 9: Join_3  (LEFT OUTER, 2 join keys)
   join keys: _B631_S_PROFTCTR = PRCTR   AND   _BIC_ZIO_SWEEK = ZWEEK
   ============================================================================ */
"Join_3" AS (
    SELECT
        W.*,
        CB.FS_COMP_WK, CB.RX_COMP_WK
    FROM "WEEK_NUMBER" W
    LEFT OUTER JOIN "COMP_FLAG_BUDGET" CB
            ON W._B631_S_PROFTCTR = CB.PRCTR
           AND W._BIC_ZIO_SWEEK   = CB.ZWEEK
),

/* ============================================================================
   Node 10: CAL_WEEK
   ============================================================================ */
"CAL_WEEK" AS (
    SELECT ZZWEEK, ZRWSTRTDATE, ZRWENDDATE
    FROM "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_RCALWEEK_S4"
),

/* ============================================================================
   Node 11: Join_4  (LEFT OUTER)   join key: _BIC_ZIO_SWEEK = ZZWEEK
   ============================================================================ */
"Join_4" AS (
    SELECT
        J3.*,
        CW.ZRWSTRTDATE, CW.ZRWENDDATE
    FROM "Join_3" J3
    LEFT OUTER JOIN "CAL_WEEK" CW
            ON J3._BIC_ZIO_SWEEK = CW.ZZWEEK
),

/* ============================================================================
   Node 12: PROFIT_CENTER_TEXT
   ============================================================================ */
"PROFIT_CENTER_TEXT" AS (
    SELECT PRCTR, LTEXT AS PROFIT_CENTER_TEXT
    FROM "_SYS_BIC"."CVS_FRIP.Base.Text/CV_BASE_MD_CEPCT_S4"
),

/* ============================================================================
   Node 13: Join_5  (LEFT OUTER)   join key: _B631_S_PROFTCTR = PRCTR
   Renames the fact amount -> _B631_S_AMOUNT_NEGATIVE (per XML mapping)
   ============================================================================ */
"Join_5" AS (
    SELECT
        J4.FISCPER, J4.FISCVARNT, J4.FISCYEAR, J4.FISCPER3, J4.MANDT, J4._BIC_ZIO_SWEEK,
        J4._B631_S_CHRTACCT, J4._B631_S_CO_AREA, J4._BIC_ZIO_CMPCD, J4._B631_S_PROFTCTR,
        J4._B631_S_COSTCNTR, J4._B631_S_FUNCAREA, J4._BIC_ZIO_VER, J4._BIC_ZIO_SAUDT,
        J4._B631_S_GL_ACCT, J4._BIC_ZWWPC_PA1, J4._BIC_ZWWSC_PA1,
        J4._B631_S_AMOUNT AS _B631_S_AMOUNT_NEGATIVE,     -- <mapping target="_B631_S_AMOUNT_NEGATIVE" source="_B631_S_AMOUNT"/>
        J4.CURRENCY, J4._BIC_ZIO_AMT, J4.FLAG,
        J4.REP_MKT_CODE, J4.REP_MKT_DESC, J4.EMERG_MKT_IND,
        J4.DIVISION_CODE, J4.DIVISION_DESC, J4.AREA_CODE, J4.AREA_DESC,
        J4.DISTRICT_CODE, J4.DISTRICT_DESC, J4.STRNUM, J4.REGION_CODE, J4.REGION_DESC,
        J4.ZRWSTRTDATE, J4.ZRWENDDATE, J4.CITY, J4.STATE,
        J4.FS_OPEN_DAT, J4.RX_OPEN_DAT,
        J4.RX_DIVISION_CODE, J4.RX_AREA_CODE, J4.RX_REGION_CODE, J4.RX_DISTRICT_CODE,
        J4.FS_COMP_WK, J4.RX_COMP_WK,
        PT.PROFIT_CENTER_TEXT
    FROM "Join_4" J4
    LEFT OUTER JOIN "PROFIT_CENTER_TEXT" PT
            ON J4._B631_S_PROFTCTR = PT.PRCTR
),

/* ============================================================================
   Node 14: FLAGS  (4 calculated columns, exact XML formulas)
   ============================================================================ */
"FLAGS" AS (
    SELECT
        F.*,
        CASE LEFT(F._BIC_ZWWPC_PA1, 2)
             WHEN N'FS' THEN N'FS'
             WHEN N'RX' THEN N'RX'
             ELSE N''
        END AS CAL_FS_RX_FLAG,
        COALESCE(
            CASE
                WHEN LEFT(F._BIC_ZWWPC_PA1, 2) = N'FS' THEN F.FS_COMP_WK
                WHEN LEFT(F._BIC_ZWWPC_PA1, 2) = N'RX' THEN F.RX_COMP_WK
                ELSE F.FS_COMP_WK
            END, N'0'
        ) AS CAL_COMP_FLAG,
        RIGHT(F._BIC_ZIO_SWEEK, 2) AS CAL_WEEK_NUMBER,
        F._B631_S_AMOUNT_NEGATIVE * -1 AS _B631_S_AMOUNT   -- exact XML name, no invented suffix
    FROM "Join_5" F
)

/* ============================================================================
   logicalModel "FLAGS"  (final Aggregation node)
   ============================================================================ */
SELECT
    MANDT, FISCPER, FISCVARNT, FISCYEAR, FISCPER3, _BIC_ZIO_SWEEK,
    _B631_S_CHRTACCT, _B631_S_CO_AREA, _BIC_ZIO_CMPCD, _B631_S_PROFTCTR,
    CAL_FS_RX_FLAG AS FS_RX_FLAG,
    _B631_S_COSTCNTR, _B631_S_FUNCAREA, _BIC_ZIO_VER, _BIC_ZIO_SAUDT,
    _B631_S_GL_ACCT, _BIC_ZWWPC_PA1, _BIC_ZWWSC_PA1, CURRENCY,
    REP_MKT_CODE, REP_MKT_DESC, EMERG_MKT_IND,
    FS_COMP_WK, RX_COMP_WK, CAL_COMP_FLAG AS COMP_FLAG,
    DIVISION_CODE, DIVISION_DESC, AREA_CODE, AREA_DESC,
    DISTRICT_CODE, DISTRICT_DESC, STRNUM, REGION_CODE, REGION_DESC,
    ZRWSTRTDATE, ZRWENDDATE, CAL_WEEK_NUMBER, CITY, STATE,
    PROFIT_CENTER_TEXT, FS_OPEN_DAT, RX_OPEN_DAT,
    FLAG AS FIN_BUD_CUBE,
    RX_DIVISION_CODE, RX_AREA_CODE, RX_REGION_CODE, RX_DISTRICT_CODE,

    SUM( _B631_S_AMOUNT_NEGATIVE ) AS _B631_S_AMOUNT_NEGATIVE,
    SUM( _BIC_ZIO_AMT )            AS _BIC_ZIO_AMT,
    SUM( _B631_S_AMOUNT )          AS _B631_S_AMOUNT
FROM "FLAGS"
GROUP BY
    MANDT, FISCPER, FISCVARNT, FISCYEAR, FISCPER3, _BIC_ZIO_SWEEK,
    _B631_S_CHRTACCT, _B631_S_CO_AREA, _BIC_ZIO_CMPCD, _B631_S_PROFTCTR,
    CAL_FS_RX_FLAG,
    _B631_S_COSTCNTR, _B631_S_FUNCAREA, _BIC_ZIO_VER, _BIC_ZIO_SAUDT,
    _B631_S_GL_ACCT, _BIC_ZWWPC_PA1, _BIC_ZWWSC_PA1, CURRENCY,
    REP_MKT_CODE, REP_MKT_DESC, EMERG_MKT_IND,
    FS_COMP_WK, RX_COMP_WK, CAL_COMP_FLAG,
    DIVISION_CODE, DIVISION_DESC, AREA_CODE, AREA_DESC,
    DISTRICT_CODE, DISTRICT_DESC, STRNUM, REGION_CODE, REGION_DESC,
    ZRWSTRTDATE, ZRWENDDATE, CAL_WEEK_NUMBER, CITY, STATE,
    PROFIT_CENTER_TEXT, FS_OPEN_DAT, RX_OPEN_DAT,
    FLAG,
    RX_DIVISION_CODE, RX_AREA_CODE, RX_REGION_CODE, RX_DISTRICT_CODE;


/* ============================================================================================
   OPTIONAL PROD-SAFE SMOKE TEST -- run this ALONE first (comment out the block above)
   to check row-count order of magnitude before running the full 14-node chain in prod.
   ============================================================================================
WITH "PARAMS" AS (
    SELECT N'LEDGER_BUD' AS IP_VERSION, N'2026035' AS IP_WEEK_FROM,
           N'2026035' AS IP_WEEK_TO, N'1' AS IP_FC_COUNT
    FROM DUMMY
)
SELECT COUNT(*) AS row_count_one_week
FROM "CVS_FRIP"."AZSRP_DS052_VT_S4" T
CROSS JOIN "PARAMS" P
WHERE T.MANDT IN ( N'110', N'200' )
  AND T.FISCVARNT = N'K4'
  AND T._BIC_ZIO_VER = P.IP_VERSION
  AND T._BIC_ZIO_SAUDT IN ( N'1', N'10' )
  AND T._BIC_ZIO_SWEEK BETWEEN P.IP_WEEK_FROM AND P.IP_WEEK_TO
============================================================================================ */
