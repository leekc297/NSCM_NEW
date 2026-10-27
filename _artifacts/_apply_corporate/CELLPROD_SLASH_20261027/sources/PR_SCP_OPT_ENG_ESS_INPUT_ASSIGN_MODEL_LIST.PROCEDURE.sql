PROCEDURE         PR_SCP_OPT_ENG_ESS_INPUT_ASSIGN_MODEL_LIST

(
     P_PLAN_ID              VARCHAR2
    ,V_DIVISION_ID          VARCHAR2
    ,V_GROUP_ID             VARCHAR2
    ,V_PLAN_START_YYYYMMDD  VARCHAR2
    ,V_PLAN_END_YYYYMMDD    VARCHAR2
)
/* ============================================================
 * Program ID   : PR_SCP_OPT_ENG_ESS_INPUT_ASSIGN_MODEL_LIST
 * Description  : ESS Optimization Engine 입력용 Model List(STAGE: ASSY/ASY_AGING/CHAR/PACK/BIZ) 생성
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2025.05.28    Philsu Park    Initial Release
 * 2025.05.30    Philsu Park    OPT ENG LOOKUP 반영
 * 2025.07.07    Philsu Park    Initial Release
 * 2026.07.06    ZIONEX         [PJ202650304]  NextSCM Migration
 * ============================================================ */
AS
    V_PROGRAM_NAME       VARCHAR2(150 CHAR) := 'PR_SCP_OPT_ENG_ESS_INPUT_ASSIGN_MODEL_LIST';
    V_PLAN_ID            VARCHAR2(50 CHAR)  := P_PLAN_ID;
    V_MESSAGE_TEXT       VARCHAR2(1000 CHAR);
    V_DETAIL_DATE        DATE;
    V_PLAN_START_YYYYMM  VARCHAR2(6 CHAR)   := SUBSTR(V_PLAN_START_YYYYMMDD,1,6);
    V_PLAN_END_YYYYMM    VARCHAR2(6 CHAR)   := SUBSTR(V_PLAN_END_YYYYMMDD,1,6);
    V_MAX_TUESDAY        VARCHAR2(8 CHAR);
    D_PLAN_NAME          DATE;
    V_DEMAND_CUTOFF_DAY  VARCHAR2(8 CHAR);
    V_DM_MAX_VERSION     VARCHAR2(50 CHAR);
BEGIN
    PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'START',NULL,NULL,NULL,V_PLAN_ID);

    /* ---------------------------------------------------------------------- */
    /* 최신 Demand 버전 탐색용 파라미터 (As-Is TRY 밖) */
    /* ---------------------------------------------------------------------- */
    SELECT MAX(BASIS_YYYYMMDD)
      INTO V_MAX_TUESDAY
      FROM SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMMDD <= TO_CHAR(SYSDATE,'YYYYMMDD')
       AND DAYOFWEEK       = 'TUE';

    D_PLAN_NAME := TO_DATE(V_PLAN_START_YYYYMMDD,'YYYYMMDD');

    SELECT NVL(MAX(P.CUTOFF_YYYYMMDD), V_MAX_TUESDAY)
      INTO V_DEMAND_CUTOFF_DAY
      FROM DM_PLN_NET_DEMAND P
     WHERE P.DIVISION_ID      = V_DIVISION_ID
       AND P.CUTOFF_YYYYMMDD >= TO_CHAR(D_PLAN_NAME - 3,'YYYYMMDD')
       AND P.CUTOFF_YYYYMMDD <= TO_CHAR(D_PLAN_NAME + 6,'YYYYMMDD');

    SELECT MAX(P.VERSION_NO)
      INTO V_DM_MAX_VERSION
      FROM DM_PLN_NET_DEMAND P
     WHERE P.DIVISION_ID     = V_DIVISION_ID
       AND P.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY;

    BEGIN
        DELETE FROM GT_OPTENG_AML_ASSY;
        DELETE FROM GT_OPTENG_AML_AGING;
        DELETE FROM GT_OPTENG_AML_CHAR;
        DELETE FROM GT_OPTENG_AML_BIZ;
        DELETE FROM GT_OPTENG_AML_SUB;

        /* ---------------------------------------------------------------------- */
        /* 1. STAGE: ASSY/ASY_AGING 기준 */
        /* ---------------------------------------------------------------------- */
        INSERT
          INTO GT_OPTENG_AML_ASSY
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE
             , DIVISION_ID
             , PLANT_ID )
        WITH PLAN_GROUP AS (
             SELECT GR.OPMZ_PLAN_GR_NAME AS PLAN_GROUP_NAME
                  , T.OPMZ_PLAN_GR_ID     AS PLAN_GROUP_ID
                  , T.LINE_ID             AS LINE_ID
                  , T.OPERATION_ID        AS OPERATION_ID
                  , T.FACTORY_ID          AS FACTORY_ID
                  , T.PLANT_ID            AS PLANT_ID
                  , T.ITEM_ID             AS ITEM_ID
               FROM SCP_OPMZ_PLAN_GR_LINE_M T
         INNER JOIN SCP_OPMZ_PLAN_GR_M GR
                 ON T.OPMZ_PLAN_GR_ID = GR.OPMZ_PLAN_GR_ID
              WHERE GR.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                AND T.VALID_YN           = 'Y'
             )
        SELECT V_PLAN_ID
             , ST.SCM_SITE_ID
             , ILA.ITEM_ID
             , CASE WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P9500'            THEN 'PACK'
                    WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P5500'            THEN 'MDLE'
                    WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'PL450'            THEN 'LINK' /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                    WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID NOT IN ('P5500','P9500') THEN 'SUBMDLE'
                    WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8  = 'CP'               THEN 'CHAR'
                    WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8 <> 'CP'               THEN 'ASSY'
                    ELSE '-'
               END
             , ILA.DIVISION_ID
             , ILA.PLANT_ID
          FROM SCM_MST_ITEM_LINE_ASSIGN_SN ILA
    INNER JOIN PLAN_GROUP GRP
            ON ILA.LINE_ID      = GRP.LINE_ID
           AND ILA.OPERATION_ID = GRP.OPERATION_ID
           AND ILA.FACTORY_ID   = GRP.FACTORY_ID
           AND ILA.PLANT_ID     = GRP.PLANT_ID
           AND ILA.ITEM_ID      = CASE WHEN GRP.ITEM_ID = '-' THEN ILA.ITEM_ID ELSE GRP.ITEM_ID END
    INNER JOIN (
             SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
               FROM SCP_MST_FINAL_ITEM
              WHERE 1 = 1
                AND ( (DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A'))
                   OR (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A','P')) )
             ) FNL
            ON ILA.DIVISION_ID = FNL.DIVISION_ID
           AND ILA.ITEM_ID     = FNL.ITEM_ID
    INNER JOIN SCM_ITEM_M_SN SIM
            ON 1 = 1
           AND ILA.COMPANY_ID  = SIM.COMPANY_ID
           AND ILA.DIVISION_ID = SIM.DIVISION_ID
           AND ILA.SITE_ID     = SIM.SITE_ID
           AND ILA.ITEM_ID     = SIM.ITEM_ID
           AND SIM.ACTIVE_FLAG = 'Y'
    LEFT OUTER JOIN SCM_MST_SITE ST
            ON ILA.DIVISION_ID     = ST.DIVISION_ID
           AND ILA.PLANT_ID        = ST.PLANT_ID
           AND FNL.OPERATION_GROUP = ST.OPERATION_GROUP
           AND ST.VALID_YN         = 'Y'
         WHERE 1 = 1
           AND ILA.MONTH       BETWEEN V_PLAN_START_YYYYMM AND V_PLAN_END_YYYYMM
           AND ILA.ACTIVE_FLAG = 'Y'
           AND ILA.PRIORITY   <> 9
      GROUP BY ST.SCM_SITE_ID
             , ILA.ITEM_ID
             , CASE WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P9500'            THEN 'PACK'
                    WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P5500'            THEN 'MDLE'
                    WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'PL450'            THEN 'LINK' /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                    WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID NOT IN ('P5500','P9500') THEN 'SUBMDLE'
                    WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8  = 'CP'               THEN 'CHAR'
                    WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8 <> 'CP'               THEN 'ASSY'
                    ELSE '-'
               END
             , ILA.DIVISION_ID
             , ILA.PLANT_ID;

        /* ---------------------------------------------------------------------- */
        /* 2. STAGE: ASY_AGING */
        /* ---------------------------------------------------------------------- */
        INSERT
          INTO GT_OPTENG_AML_AGING
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE
             , DIVISION_ID
             , PLANT_ID )
        SELECT V_PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , 'ASY_AGING'
             , DIVISION_ID
             , PLANT_ID
          FROM GT_OPTENG_AML_ASSY
         WHERE ITEM_STAGE = 'ASSY';

        /* ---------------------------------------------------------------------- */
        /* 3. STAGE: CHAR (ASY_AGING 기준 PROD 모델 매핑) */
        /* ---------------------------------------------------------------------- */
        INSERT
          INTO GT_OPTENG_AML_CHAR
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE
             , DIVISION_ID
             , PLANT_ID )
        SELECT V_PLAN_ID
             , ST.SCM_SITE_ID
             , PRD.ITEM_ID_PROD
             , CASE WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P9500'            THEN 'PACK'
                    WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'PL450'            THEN 'LINK' /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                    WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P5500'            THEN 'MDLE'
                    WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID NOT IN ('P5500','P9500') THEN 'SUBMDLE'
                    WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8  = 'CP'               THEN 'CHAR'
                    WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8 <> 'CP'               THEN 'ASSY'
                    ELSE '-'
               END
             , PRD.DIVISION_ID
             , PRD.PLANT_ID
          FROM SCP_MST_CELL_PROD_ASSY_MAP PRD
    LEFT OUTER JOIN (
             SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
               FROM SCP_MST_FINAL_ITEM
              WHERE 1 = 1
                AND ( (DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A'))
                   OR (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A','P')) )
             ) FNL
            ON PRD.DIVISION_ID  = FNL.DIVISION_ID
           AND PRD.ITEM_ID_PROD = FNL.ITEM_ID
    LEFT OUTER JOIN SCM_MST_SITE ST
            ON PRD.DIVISION_ID     = ST.DIVISION_ID
           AND PRD.PLANT_ID        = ST.PLANT_ID
           AND FNL.OPERATION_GROUP = ST.OPERATION_GROUP
           AND ST.VALID_YN         = 'Y'
         WHERE EXISTS (SELECT 1
                         FROM GT_OPTENG_AML_AGING AG
                        WHERE AG.DIVISION_ID = PRD.DIVISION_ID
                          AND AG.PLANT_ID    = PRD.PLANT_ID
                          AND AG.ITEM_ID     = PRD.ITEM_ID_ASSY )
           AND PRD.CELL_TYPE = 'CA1'
           AND PRD.VALID_YN  = 'Y';

        /* ---------------------------------------------------------------------- */
        /* 4. STAGE: LINK/RACK/PACK 외주 TactTime(SCP_MST_TACT_TIME_OSP) -> #CHAR 추가 */
        /* ---------------------------------------------------------------------- */
        INSERT
          INTO GT_OPTENG_AML_CHAR
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE
             , DIVISION_ID
             , PLANT_ID )
        WITH PLAN_GROUP AS (
             SELECT GR.OPMZ_PLAN_GR_NAME AS PLAN_GROUP_NAME
                  , T.OPMZ_PLAN_GR_ID     AS PLAN_GROUP_ID
                  , T.LINE_ID             AS LINE_ID
                  , T.OPERATION_ID        AS OPERATION_ID
                  , T.FACTORY_ID          AS FACTORY_ID
                  , T.PLANT_ID            AS PLANT_ID
                  , T.ITEM_ID             AS ITEM_ID
               FROM SCP_OPMZ_PLAN_GR_LINE_M T
         INNER JOIN SCP_OPMZ_PLAN_GR_M GR
                 ON T.OPMZ_PLAN_GR_ID = GR.OPMZ_PLAN_GR_ID
              WHERE GR.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                AND T.VALID_YN           = 'Y'
             )
        SELECT V_PLAN_ID
             , ST.SCM_SITE_ID
             , ILA.ITEM_ID
             , CASE WHEN FNL.OPERATION_GROUP_ID = 'P' AND FNL.FLOW_ID = 'P9500'                              THEN 'LINK'
                    WHEN FNL.OPERATION_GROUP_ID = 'P' AND FNL.FLOW_ID = 'PL450'                              THEN 'LINK' /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                    WHEN FNL.OPERATION_GROUP_ID = 'P' AND FNL.FLOW_ID = 'R5500'                              THEN 'RACK'
                    WHEN FNL.OPERATION_GROUP_ID = 'B' AND FNL.FLOW_ID = 'P9500'                              THEN 'PACK'
                    WHEN FNL.OPERATION_GROUP_ID = 'B' AND FNL.FLOW_ID = 'P5500'                              THEN 'PACK'
                    WHEN FNL.OPERATION_GROUP_ID = 'M' AND FNL.FLOW_ID = 'P9500'                              THEN 'PACK'
                    WHEN FNL.OPERATION_GROUP_ID = 'M' AND FNL.FLOW_ID = 'P5000' AND ILA.ITEM_ID NOT LIKE 'EP%' THEN 'PACK'
                    WHEN FNL.OPERATION_GROUP_ID = 'M' AND FNL.FLOW_ID = 'P5000' AND ILA.ITEM_ID LIKE 'EP%'     THEN 'PACK'
                    ELSE '-'
               END
             , ILA.DIVISION_ID
             , ST.PLANT_ID
          FROM SCP_MST_TACT_TIME_OSP ILA
    INNER JOIN PLAN_GROUP GRP
            ON ILA.LINE_ID      = GRP.LINE_ID
           AND ILA.OPERATION_ID = GRP.OPERATION_ID
           AND ILA.ITEM_ID      = CASE WHEN GRP.ITEM_ID = '-' THEN ILA.ITEM_ID ELSE GRP.ITEM_ID END
    INNER JOIN (
             SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, OPERATION_GROUP_ID, FLOW_ID, ATTRIBUTE8
               FROM SCP_MST_FINAL_ITEM
              WHERE 1 = 1
                AND ( (DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A'))
                   OR (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A','P')) )
             ) FNL
            ON ILA.DIVISION_ID = FNL.DIVISION_ID
           AND ILA.ITEM_ID     = FNL.ITEM_ID
    LEFT OUTER JOIN SCM_MST_SITE ST
            ON ILA.DIVISION_ID     = ST.DIVISION_ID
           AND ILA.PLANT_SITE_ID   = ST.SCM_SITE_ID
           AND FNL.OPERATION_GROUP = ST.OPERATION_GROUP
           AND ST.VALID_YN         = 'Y'
         WHERE 1 = 1
           AND ILA.VALID_YN  = 'Y'
           AND ILA.PRIORITY <> 9
      GROUP BY ST.SCM_SITE_ID
             , ILA.ITEM_ID
             , CASE WHEN FNL.OPERATION_GROUP_ID = 'P' AND FNL.FLOW_ID = 'P9500'                              THEN 'LINK'
                    WHEN FNL.OPERATION_GROUP_ID = 'P' AND FNL.FLOW_ID = 'PL450'                              THEN 'LINK' /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                    WHEN FNL.OPERATION_GROUP_ID = 'P' AND FNL.FLOW_ID = 'R5500'                              THEN 'RACK'
                    WHEN FNL.OPERATION_GROUP_ID = 'B' AND FNL.FLOW_ID = 'P9500'                              THEN 'PACK'
                    WHEN FNL.OPERATION_GROUP_ID = 'B' AND FNL.FLOW_ID = 'P5500'                              THEN 'PACK'
                    WHEN FNL.OPERATION_GROUP_ID = 'M' AND FNL.FLOW_ID = 'P9500'                              THEN 'PACK'
                    WHEN FNL.OPERATION_GROUP_ID = 'M' AND FNL.FLOW_ID = 'P5000' AND ILA.ITEM_ID NOT LIKE 'EP%' THEN 'PACK'
                    WHEN FNL.OPERATION_GROUP_ID = 'M' AND FNL.FLOW_ID = 'P5000' AND ILA.ITEM_ID LIKE 'EP%'     THEN 'PACK'
                    ELSE '-'
               END
             , ILA.DIVISION_ID
             , ST.PLANT_ID;

        /* ---------------------------------------------------------------------- */
        /* 5. STAGE: BIZ (CHAR/PACK/RACK/LINK 기준 NET Demand 사이트별 모델) */
        /* ---------------------------------------------------------------------- */
        INSERT
          INTO GT_OPTENG_AML_BIZ
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE )
        SELECT DISTINCT
               V_PLAN_ID
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , CASE WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID = 'P9500'                              THEN 'LINKBIZ'
                    WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID = 'PL450'                              THEN 'LINKBIZ' /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                    WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID = 'R5500'                              THEN 'RACKBIZ'
                    WHEN B.OPERATION_GROUP_ID = 'B' AND B.FLOW_ID = 'P9500'                              THEN 'PACKBIZ'
                    WHEN B.OPERATION_GROUP_ID = 'B' AND B.FLOW_ID = 'P5500'                              THEN 'PACKBIZ'
                    WHEN B.OPERATION_GROUP_ID = 'M' AND B.FLOW_ID = 'P9500'                              THEN 'PACKBIZ'
                    WHEN B.OPERATION_GROUP_ID = 'M' AND B.FLOW_ID = 'P5000' AND A.ITEM_ID NOT LIKE 'EP%' THEN 'PACKBIZ'
                    WHEN B.OPERATION_GROUP_ID = 'M' AND B.FLOW_ID = 'P5000' AND A.ITEM_ID LIKE 'EP%'     THEN 'PACKBIZ'
                    WHEN B.OPERATION_GROUP_ID = 'A' AND B.FLOW_ID = 'A9000'                              THEN 'CELLBIZ'
                    ELSE '-'
               END
          FROM DM_PLN_NET_DEMAND A
    INNER JOIN (
             SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID
               FROM GT_OPTENG_AML_CHAR
              WHERE ITEM_STAGE IN ('CHAR','PACK','RACK','LINK')
             ) CM
            ON A.DIVISION_ID = CM.DIVISION_ID
           AND A.ITEM_ID     = CM.ITEM_ID
           AND A.CELL_PROD_SITE_ID = CASE WHEN V_DIVISION_ID = '40' THEN CM.SCM_SITE_ID ELSE A.CELL_PROD_SITE_ID END
    INNER JOIN (
             SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, OPERATION_GROUP_ID, FLOW_ID, ATTRIBUTE8
               FROM SCP_MST_FINAL_ITEM
              WHERE ( (DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A'))
                   OR (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A','P')) )
             ) B
            ON A.DIVISION_ID = B.DIVISION_ID
           AND A.ITEM_ID     = B.ITEM_ID
    LEFT OUTER JOIN (
             /* 2025.11.18 Sales Site Priority (Lookup -> UI 전환) */
             SELECT P.ITEM_ID         AS ITEM_ID
                  , P.SCM_SITE_ID     AS TO_SITE
                  , TO_CHAR(P.PRIO_RANK) AS PRIORITY
                  , FROM_YYYYMMDD     AS FROM_DATE
                  , TO_YYYYMMDD       AS TO_DATE
               FROM SCP_OPMZ_SALES_SITE_PRIORITY P
          LEFT JOIN SCP_OPMZ_PLAN_GR_M PG
                 ON P.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                AND PG.VALID_YN = 'Y'
              WHERE 1 = 1
                AND P.VALID_YN          = 'Y'
                AND P.DIVISION_ID       = V_DIVISION_ID
                AND PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
             ) TP
            ON A.SCM_SITE_ID = TP.TO_SITE
           AND A.ITEM_ID     = TP.ITEM_ID
           AND A.ATTRIBUTE1 BETWEEN TP.FROM_DATE AND TP.TO_DATE
    LEFT JOIN (
             /* 2025.11.17 Demand Exception (Lookup -> UI 전환) */
             SELECT D.DIVISION_ID        AS DIVISION_ID
                  , D.SCM_SITE_ID        AS SCM_SITE_ID
                  , D.ITEM_ID            AS ITEM_ID
                  , PG.OPMZ_PLAN_GR_NAME AS GROUP_ID
                  , CASE WHEN D.FROM_YYYYMMDD IS NULL THEN V_PLAN_END_YYYYMMDD ELSE D.FROM_YYYYMMDD END AS START_DATE
                  , CASE WHEN D.TO_YYYYMMDD   IS NULL THEN V_PLAN_END_YYYYMMDD ELSE D.TO_YYYYMMDD   END AS END_DATE
               FROM SCP_OPMZ_DEMAND_EXCEPTION D
          LEFT JOIN SCP_OPMZ_PLAN_GR_M PG
                 ON D.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                AND PG.VALID_YN = 'Y'
              WHERE 1 = 1
                AND D.VALID_YN          = 'Y'
                AND D.DIVISION_ID       = V_DIVISION_ID
                AND PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
             ) DE
            ON A.SCM_SITE_ID = DE.SCM_SITE_ID
           AND A.ITEM_ID     = DE.ITEM_ID
         WHERE A.DIVISION_ID     = V_DIVISION_ID
           AND A.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY
           AND A.VERSION_NO      = V_DM_MAX_VERSION
           AND A.ATTRIBUTE1     >= V_PLAN_START_YYYYMMDD
           AND A.ATTRIBUTE1     <  V_PLAN_END_YYYYMMDD
           AND A.QTY            >  0
           AND ( DE.ITEM_ID IS NULL
              OR (DE.ITEM_ID IS NOT NULL AND (A.ATTRIBUTE1 < DE.START_DATE OR A.ATTRIBUTE1 > DE.END_DATE)) );

        /* ---------------------------------------------------------------------- */
        /* 6-1. SUBMDLE: PACK 하위 SUBMDLE 모델 (ALTER BOM, CHILD 'AMD%') */
        /* ---------------------------------------------------------------------- */
        INSERT
          INTO GT_OPTENG_AML_SUB
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE
             , DIVISION_ID
             , PLANT_ID )
        SELECT DISTINCT
               V_PLAN_ID
             , M.SCM_SITE_ID
             , A.CHILD_ITEM_ID
             , 'SUBMDLE'
             , A.DIVISION_ID
             , A.PLANT_ID
          FROM SCM_MST_ALTER_BOM_V A
    INNER JOIN (
             SELECT * FROM GT_OPTENG_AML_CHAR WHERE ITEM_STAGE IN ('PACK')
              UNION ALL
             SELECT * FROM GT_OPTENG_AML_ASSY WHERE ITEM_STAGE IN ('PACK')
             ) M
            ON A.DIVISION_ID    = M.DIVISION_ID
           AND A.PARENT_ITEM_ID = M.ITEM_ID
         WHERE 1 = 1
           AND A.CHILD_ITEM_ID LIKE 'AMD%';

        /* ---------------------------------------------------------------------- */
        /* 6-2. 대치 없는 경우도 추가(LEAF_LEVEL IS NULL, CHILD 'AMD%', 중복 아닌 것) */
        /* ---------------------------------------------------------------------- */
        INSERT
          INTO GT_OPTENG_AML_SUB
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE
             , DIVISION_ID
             , PLANT_ID )
        SELECT DISTINCT
               V_PLAN_ID
             , M.SCM_SITE_ID
             , A.CHILD_ITEM_ID
             , 'SUBMDLE'
             , A.DIVISION_ID
             , A.PLANT_ID
          FROM SCM_MST_BOM_SN_V A
    INNER JOIN (
             SELECT * FROM GT_OPTENG_AML_CHAR WHERE ITEM_STAGE IN ('PACK')
              UNION ALL
             SELECT * FROM GT_OPTENG_AML_ASSY WHERE ITEM_STAGE IN ('PACK')
             ) M
            ON A.DIVISION_ID    = M.DIVISION_ID
           AND A.PARENT_ITEM_ID = M.ITEM_ID
         WHERE 1 = 1
           AND A.LEAF_LEVEL    IS NULL
           AND A.CHILD_ITEM_ID LIKE 'AMD%'
           AND NOT EXISTS (SELECT 1
                             FROM GT_OPTENG_AML_SUB LI
                            WHERE A.DIVISION_ID    = LI.DIVISION_ID
                              AND A.PLANT_ID       = LI.PLANT_ID
                              AND A.PARENT_ITEM_ID = LI.ITEM_ID );

        /* ---------------------------------------------------------------------- */
        /* 2025.11.12 TARGETBIZ 후처리 (_=단일 와일드카드, As-Is 보존) */
        /* ---------------------------------------------------------------------- */
        IF V_PLAN_ID LIKE '%_TARGETBIZ' THEN
            DELETE FROM GT_OPTENG_AML_CHAR WHERE ITEM_STAGE NOT IN ('CHAR','PACK');
            UPDATE GT_OPTENG_AML_CHAR SET PLAN_ID = PLAN_ID || '_PACK' WHERE ITEM_STAGE = 'PACK';
            DELETE FROM GT_OPTENG_AML_BIZ WHERE ITEM_STAGE <> 'CELLBIZ';
            DELETE FROM GT_OPTENG_AML_SUB;
        END IF;

        /* ---------------------------------------------------------------------- */
        /* 5. 최종 Model List INSERT (UNION 중복제거) */
        /* ---------------------------------------------------------------------- */
        INSERT
          INTO SCP_OPT_ENG_MODEL_LIST_N_SN
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , STAGE )
        SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE FROM GT_OPTENG_AML_ASSY
         UNION
        SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE FROM GT_OPTENG_AML_AGING
         UNION
        SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE FROM GT_OPTENG_AML_CHAR
         UNION
        SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE FROM GT_OPTENG_AML_BIZ
         UNION
        SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE FROM GT_OPTENG_AML_SUB;

    EXCEPTION
        WHEN OTHERS THEN
            V_MESSAGE_TEXT := SQLERRM;
            PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'ERROR',NULL,V_MESSAGE_TEXT,NULL,V_PLAN_ID);
            V_DETAIL_DATE  := SYSDATE;
            PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,V_DETAIL_DATE,NULL,V_MESSAGE_TEXT,'ERROR');
            RAISE_APPLICATION_ERROR(-20001, V_PROGRAM_NAME);
    END;

    IF V_MESSAGE_TEXT IS NULL THEN
        PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'END',NULL,NULL,NULL,V_PLAN_ID);
        PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,NULL,NULL,NULL,NULL);
    END IF;

END PR_SCP_OPT_ENG_ESS_INPUT_ASSIGN_MODEL_LIST;