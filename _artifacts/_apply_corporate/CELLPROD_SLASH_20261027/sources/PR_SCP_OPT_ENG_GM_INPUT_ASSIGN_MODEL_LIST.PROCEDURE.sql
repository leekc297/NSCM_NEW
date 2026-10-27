PROCEDURE PR_SCP_OPT_ENG_GM_INPUT_ASSIGN_MODEL_LIST
(
     P_PLAN_ID              VARCHAR2
    ,V_DIVISION_ID          VARCHAR2
    ,V_GROUP_ID             VARCHAR2
    ,V_PLAN_START_YYYYMMDD  VARCHAR2
    ,V_PLAN_END_YYYYMMDD    VARCHAR2
)
/* ============================================================
 * Program ID   : PR_SCP_OPT_ENG_GM_INPUT_ASSIGN_MODEL_LIST
 * Description  : GM Optimization Engine 입력용 Model List(STAGE: STK/ASSY/A_DEGAS/B_DEGAS/EOL/CHAR/CELLBIZ) 생성
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2025.07.07    Philsu Park    Initial Release
 * 2026.07.29    ZIONEX         [PJ202650304]  NextSCM Migration
 * ============================================================ */
AS
    /* 2025.05.28 Philsu Park Initial Release. */
    /* 2025.05.30 Philsu Park: OPT ENG LOOKUP 반영. */
    /* ---------------------------------------------------------------------- */
    /* Procedure 기본조건. */
    /* ---------------------------------------------------------------------- */
    /*        SET TRANSACTION ISOLATION LEVEL READ COMMITTED; */
    /* ---------------------------------------------------------------------- */
    /* Set Prameter */
    /* ---------------------------------------------------------------------- */
    V_PROGRAM_NAME        VARCHAR2(150 CHAR) := 'PR_SCP_OPT_ENG_GM_INPUT_ASSIGN_MODEL_LIST';
    V_PLAN_ID             VARCHAR2(50 CHAR)  := P_PLAN_ID;
    V_MESSAGE_TEXT        VARCHAR2(1000 CHAR);
    V_DETAIL_DATE         DATE;
    /* ---------------------------------------------------------------------- */
    /* Set Param for Biz */
    /* ---------------------------------------------------------------------- */
    V_PLAN_START_YYYYMM   VARCHAR2(6 CHAR)   := SUBSTR(V_PLAN_START_YYYYMMDD, 1, 6);
    V_PLAN_END_YYYYMM     VARCHAR2(6 CHAR)   := SUBSTR(V_PLAN_END_YYYYMMDD, 1, 6);
    V_MAX_TUESDAY         VARCHAR2(8 CHAR);
    D_PLAN_NAME           DATE;
    V_DEMAND_CUTOFF_DAY   VARCHAR2(8 CHAR);
    V_DM_MAX_VERSION      VARCHAR2(50 CHAR);
BEGIN
    /* Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성 */
    PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'START',NULL,NULL,NULL,V_PLAN_ID);

    /* ---------------------------------------------------------------------- */
    /* Set Param For Find latest demand version. */
    /* ---------------------------------------------------------------------- */
    SELECT MAX(BASIS_YYYYMMDD)
      INTO V_MAX_TUESDAY
      FROM SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMMDD <= V_PLAN_START_YYYYMMDD
       AND DAYOFWEEK       = 'TUE';

    D_PLAN_NAME := TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD');

    SELECT MAX(P.CUTOFF_YYYYMMDD)
      INTO V_DEMAND_CUTOFF_DAY
      FROM DM_PLN_NET_DEMAND P
     WHERE P.DIVISION_ID      = V_DIVISION_ID
       AND P.CUTOFF_YYYYMMDD <= V_PLAN_START_YYYYMMDD
       AND P.CUTOFF_YYYYMMDD >= TO_CHAR(TO_DATE(V_MAX_TUESDAY, 'YYYYMMDD') - 28, 'YYYYMMDD');

    /* ---------------------------------------------------------------------- */
    SELECT MAX(P.VERSION_NO)
      INTO V_DM_MAX_VERSION
      FROM DM_PLN_NET_DEMAND P
     WHERE P.DIVISION_ID     = V_DIVISION_ID
       AND P.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY;

    /* ---------------------------------------------------------------------- */
    /* Transaction (START) */
    /* BEGIN TRANSACTION SCP_OPT_ENG_RUN_MAIN_PROC; */
    /* ---------------------------------------------------------------------- */
    BEGIN


        DELETE
          FROM GT_OPT_ENG_GMAML_STK;

        DELETE
          FROM GT_OPT_ENG_GMAML_ASSY;

        DELETE
          FROM GT_OPT_ENG_GMAML_DEGAS;

        DELETE
          FROM GT_OPT_ENG_GMAML_EOL;

        DELETE
          FROM GT_OPT_ENG_GMAML_CHAR;

        DELETE
          FROM GT_OPT_ENG_GMAML_BIZ;

        /* ---------------------------------------------------------------------- */
        /* Data Insert Start */
        /* 1. STAGE: STK */
        /* STK는 룩업 ITEM 정보 기반으로 1레벨 하위 BOM 에서 찾아옴. */
        /* ---------------------------------------------------------------------- */
        INSERT
          INTO GT_OPT_ENG_GMAML_STK
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE
             , ORG_STAGE
             , DIVISION_ID
             , PLANT_ID )
        SELECT V_PLAN_ID
             , ST.SCM_SITE_ID
             , BOM.CHILD_ITEM_ID
             , 'STK' || '@' || LK.LINE_SIDE
             , 'STK'
             , BOM.DIVISION_ID
             , BOM.PLANT_ID
          FROM SCM_MST_BOM_ENG_SN BOM
             , SCM_ITEM_M_SN SIM
             , SCM_MST_SITE ST
             , (SELECT SEGMENT3 AS SCM_SITE_ID
                     , SEGMENT4 AS ITEM_ID
                     , SEGMENT5 AS LINE_SIDE
                  FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL
                 WHERE LOOKUP_TYPE = 'SCP_OPT_ENG_GM_ITEM'
                   AND VALID_YN    = 'Y'
                   AND SEGMENT1    = V_DIVISION_ID
                   AND SEGMENT2    = V_GROUP_ID
               ) LK
             , SCM_MST_ALTER_BOM_V B
         WHERE BOM.COMPANY_ID     = SIM.COMPANY_ID
           AND BOM.DIVISION_ID    = SIM.DIVISION_ID
           AND BOM.SITE_ID        = SIM.SITE_ID
           AND BOM.CHILD_ITEM_ID  = SIM.ITEM_ID
           AND SIM.ACTIVE_FLAG    = 'Y'
           AND BOM.DIVISION_ID    = ST.DIVISION_ID
           AND BOM.PLANT_ID       = ST.PLANT_ID
           AND BOM.SITE_ID        = ST.SITE_ID
           AND ST.OPERATION_GROUP = 'A' /* 조립만. */
           AND ST.VALID_YN        = 'Y'
           AND ST.SCM_SITE_ID     = LK.SCM_SITE_ID
           AND BOM.PARENT_ITEM_ID = LK.ITEM_ID
           AND BOM.DIVISION_ID    = B.DIVISION_ID(+)
           AND BOM.SITE_ID        = B.SITE_ID(+)
           AND BOM.PLANT_ID       = B.PLANT_ID(+)
           AND BOM.PARENT_ITEM_ID = B.PARENT_ITEM_ID(+)
           AND BOM.CHILD_ITEM_ID  = B.CHILD_ITEM_ID(+)
           AND SIM.FLOW_ID        = 'A8000' /* STK */
           AND BOM.CHILD_QTY      > 0
           AND BOM.ACTIVE_FLAG    = 'Y'
           AND BOM.DIVISION_ID    = V_DIVISION_ID
           AND BOM.EFF_END_DATE  >= TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD')
           AND ( BOM.ALT_ID IS NULL
              OR (BOM.ALT_ID IS NOT NULL AND B.SCP_PLAN_YN IS NULL AND NVL(BOM.ALT_PRIORITY, 1) = 1)
              OR (BOM.ALT_ID IS NOT NULL AND B.SCP_PLAN_YN IS NOT NULL AND B.SCP_PLAN_YN = 'Y') );

        /* ---------------------------------------------------------------------- */
        /* 2. STAGE: ASSY */
        /* ASSY는 FLOW_ID 기준으로 LINE_ASSIGN에서 추출. */
        /* ---------------------------------------------------------------------- */
        INSERT
          INTO GT_OPT_ENG_GMAML_ASSY
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE
             , ORG_STAGE
             , DIVISION_ID
             , PLANT_ID )
        WITH PLAN_GROUP AS (
             SELECT GR.OPMZ_PLAN_GR_NAME AS PLAN_GROUP_NAME
                  , T.OPMZ_PLAN_GR_ID    AS PLAN_GROUP_ID
                  , T.LINE_ID            AS LINE_ID
                  , T.OPERATION_ID       AS OPERATION_ID
                  , T.FACTORY_ID         AS FACTORY_ID
                  , T.PLANT_ID           AS PLANT_ID
                  , T.ITEM_ID            AS ITEM_ID
               FROM SCP_OPMZ_PLAN_GR_LINE_M T
                  , SCP_OPMZ_PLAN_GR_M GR
              WHERE T.OPMZ_PLAN_GR_ID    = GR.OPMZ_PLAN_GR_ID
                AND GR.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                AND T.VALID_YN           = 'Y'
             )
        SELECT V_PLAN_ID
             , ST.SCM_SITE_ID
             , ILA.ITEM_ID
             , 'ASSY' || '@' || LK.LINE_SIDE
             , 'ASSY'
             , ILA.DIVISION_ID
             , ILA.PLANT_ID
          FROM SCM_MST_ITEM_LINE_ASSIGN_SN ILA
             , (SELECT SEGMENT4 AS ITEM_ID
                     , SEGMENT5 AS LINE_SIDE
                  FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL
                 WHERE LOOKUP_TYPE = 'SCP_OPT_ENG_GM_ITEM'
                   AND VALID_YN    = 'Y'
                   AND SEGMENT1    = V_DIVISION_ID
                   AND SEGMENT2    = V_GROUP_ID
               ) LK
             , PLAN_GROUP GRP
             , SCM_ITEM_M_SN SIM
             , SCM_MST_SITE ST
         WHERE ILA.ITEM_ID          = LK.ITEM_ID
           AND ILA.LINE_ID          = GRP.LINE_ID
           AND ILA.OPERATION_ID     = GRP.OPERATION_ID
           AND ILA.FACTORY_ID       = GRP.FACTORY_ID
           AND ILA.PLANT_ID         = GRP.PLANT_ID
           AND ILA.ITEM_ID          = CASE WHEN GRP.ITEM_ID = '-' THEN ILA.ITEM_ID ELSE GRP.ITEM_ID END /* item 명시 안되어있으면 assign 전체. */
           AND ILA.COMPANY_ID       = SIM.COMPANY_ID
           AND ILA.DIVISION_ID      = SIM.DIVISION_ID
           AND ILA.SITE_ID          = SIM.SITE_ID
           AND ILA.ITEM_ID          = SIM.ITEM_ID
           AND SIM.ACTIVE_FLAG      = 'Y'
           AND ILA.DIVISION_ID      = ST.DIVISION_ID(+)
           AND ILA.PLANT_ID         = ST.PLANT_ID(+)
           AND ILA.SITE_ID          = ST.SITE_ID(+)
           AND ST.OPERATION_GROUP(+) = 'A' /* 조립만. */
           AND ST.VALID_YN(+)        = 'Y'
           AND ILA.ACTIVE_FLAG      = 'Y'
           AND ILA.PRIORITY        <> 9 /* 신재욱 책임님 요청. 9순위 제외. */
           AND SIM.FLOW_ID          = 'A9000' /* STK, ASSY 공정만. */
           AND ILA.DIVISION_ID      = V_DIVISION_ID
           AND ILA.MONTH      BETWEEN V_PLAN_START_YYYYMM AND V_PLAN_END_YYYYMM
      GROUP BY ST.SCM_SITE_ID
             , ILA.ITEM_ID
             , LK.LINE_SIDE
             , ILA.DIVISION_ID
             , ILA.PLANT_ID;

        /* ---------------------------------------------------------------------- */
        /* 3. STAGE: DEGAS: ASSY -> A_DEGAS, B_DEGAS 모델 변경없이 동일. */
        /* ---------------------------------------------------------------------- */
        INSERT
          INTO GT_OPT_ENG_GMAML_DEGAS
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE
             , ORG_STAGE
             , DIVISION_ID
             , PLANT_ID )
        SELECT V_PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , 'A_DEGAS' || SUBSTR(ITEM_STAGE, -2)
             , 'A_DEGAS'
             , DIVISION_ID
             , PLANT_ID
          FROM GT_OPT_ENG_GMAML_ASSY
         WHERE ITEM_STAGE LIKE 'ASSY%'
         UNION ALL
        SELECT V_PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , 'B_DEGAS' || SUBSTR(ITEM_STAGE, -2)
             , 'B_DEGAS'
             , DIVISION_ID
             , PLANT_ID
          FROM GT_OPT_ENG_GMAML_ASSY
         WHERE ITEM_STAGE LIKE 'ASSY%';

        /* ---------------------------------------------------------------------- */
        /* 4. STAGE: EOL: B_DEGAS -> EOL 모델 변경없이 동일. */
        /* ---------------------------------------------------------------------- */
        INSERT
          INTO GT_OPT_ENG_GMAML_EOL
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE
             , ORG_STAGE
             , DIVISION_ID
             , PLANT_ID )
        SELECT V_PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , 'EOL' || SUBSTR(ITEM_STAGE, -2)
             , 'EOL'
             , DIVISION_ID
             , PLANT_ID
          FROM GT_OPT_ENG_GMAML_DEGAS
         WHERE ITEM_STAGE LIKE 'B_DEGAS%';

        /* ---------------------------------------------------------------------- */
        /* 5. STAGE: CHAR: EOL 기준으로 PROD 모델 Mapping 정보를 찾아옴. */
        /* ---------------------------------------------------------------------- */
        INSERT
          INTO GT_OPT_ENG_GMAML_CHAR
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE
             , ORG_STAGE
             , DIVISION_ID
             , PLANT_ID )
        SELECT V_PLAN_ID
             , ST.SCM_SITE_ID
             , PRD.ITEM_ID_PROD
             , 'CHAR'
             , 'CHAR'
             , PRD.DIVISION_ID
             , PRD.PLANT_ID
          FROM SCP_MST_CELL_PROD_ASSY_MAP PRD
             , GT_OPT_ENG_GMAML_EOL AG
             , SCM_MST_SITE ST
         WHERE AG.DIVISION_ID      = PRD.DIVISION_ID
           AND AG.PLANT_ID         = PRD.PLANT_ID
           AND AG.ITEM_ID          = PRD.ITEM_ID_ASSY
           AND PRD.DIVISION_ID     = ST.DIVISION_ID(+)
           AND PRD.PLANT_ID        = ST.PLANT_ID(+)
           AND ST.OPERATION_GROUP(+) = 'A'
           AND ST.VALID_YN(+)        = 'Y'
           AND PRD.CELL_TYPE       = 'CA1'
           AND PRD.VALID_YN        = 'Y'
        /* AND     EXISTS ( SELECT 1
                        FROM   #EOL_MODEL_LIST AG
                        WHERE  AG.DIVISION_ID  = PRD.DIVISION_ID
                        AND    AG.PLANT_ID     = PRD.PLANT_ID
                        AND    AG.ITEM_ID      = PRD.ITEM_ID_ASSY
                        ) */
      GROUP BY ST.SCM_SITE_ID
             , PRD.ITEM_ID_PROD
             , PRD.DIVISION_ID
             , PRD.PLANT_ID;

        /* ---------------------------------------------------------------------- */
        /* 6. STAGE: BIZ: CHAR 기준으로 NET Demand에서 각 Site 별 모델 정보를 추출. */
        /* ---------------------------------------------------------------------- */
        INSERT
          INTO GT_OPT_ENG_GMAML_BIZ
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE
             , ORG_STAGE )
        SELECT DISTINCT
               V_PLAN_ID
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , CASE WHEN B.OPERATION_GROUP = 'A' THEN 'CELLBIZ' ELSE '-' END
             , 'CELLBIZ'
          FROM DM_PLN_NET_DEMAND A
             , (SELECT DISTINCT DIVISION_ID, ITEM_ID
                  FROM GT_OPT_ENG_GMAML_CHAR
                /*  UNION
                    SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID
                    FROM   #ASSY_MODEL_LIST
                    WHERE  ITEM_STAGE IN ('MDLE', 'PACK')
                    AND    DIVISION_ID != '40' */
               ) CM
             , (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                  FROM SCP_MST_FINAL_ITEM
                 WHERE ( (DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A')) /* 소형은 CEll Biz 용 Demand 만 처리 */
                      OR (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P')) )
               ) B
        /* ---------------------------------------------------------------------- */
        /* DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리 */
        /* 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3) */
        /* ---------------------------------------------------------------------- */
             , (
                /* SELECT  SEGMENT2   AS DIVISION_ID
                           , SEGMENT3   AS SCM_SITE_ID
                           , SEGMENT4   AS ITEM_ID
                           , SEGMENT5   AS GROUP_ID
                           , CASE WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                               ELSE ATTRIBUTE2
                           END AS START_DATE  -- PLAN 제외 시작일자
                           , CASE WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                               ELSE ATTRIBUTE3
                           END AS END_DATE  -- PLAN 제외 끝일자
                   FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                   WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                   AND    VALID_YN    = 'Y'
                   AND    SEGMENT2    = @V_DIVISION_ID
                   AND    SEGMENT5    = @V_GROUP_ID */
                /* 2025.11.17 Minyong Lee : Demand Exception Lookup -> UI 전환 */
                SELECT D.DIVISION_ID        AS DIVISION_ID
                     , D.SCM_SITE_ID        AS SCM_SITE_ID
                     , D.ITEM_ID            AS ITEM_ID
                     , PG.OPMZ_PLAN_GR_NAME AS GROUP_ID
                     , CASE WHEN D.FROM_YYYYMMDD IS NULL THEN V_PLAN_END_YYYYMMDD
                            ELSE D.FROM_YYYYMMDD
                       END                  AS START_DATE
                     , CASE WHEN D.TO_YYYYMMDD IS NULL THEN V_PLAN_END_YYYYMMDD
                            ELSE D.TO_YYYYMMDD
                       END                  AS END_DATE
                  FROM SCP_OPMZ_DEMAND_EXCEPTION D
                     , SCP_OPMZ_PLAN_GR_M PG
                 WHERE D.OPMZ_PLAN_GR_ID    = PG.OPMZ_PLAN_GR_ID(+)
                   AND PG.VALID_YN(+)       = 'Y'
                   AND D.VALID_YN           = 'Y'
                   AND D.DIVISION_ID        = V_DIVISION_ID
                   AND PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
               ) DE
         WHERE A.DIVISION_ID     = CM.DIVISION_ID
           AND A.ITEM_ID         = CM.ITEM_ID
        /* AND A.CELL_PROD_SITE_ID = IIF(@V_DIVISION_ID = '40', CM.SCM_SITE_ID, A.CELL_PROD_SITE_ID) */
           AND A.DIVISION_ID     = B.DIVISION_ID
           AND A.ITEM_ID         = B.ITEM_ID
           AND A.SCM_SITE_ID     = DE.SCM_SITE_ID(+)
           AND A.ITEM_ID         = DE.ITEM_ID(+)
        /* LEFT OUTER JOIN( --TOSITE PRIORITY CONSTRAINT
                        SELECT  SEGMENT3   AS ITEM_ID
                                ,SEGMENT4   AS TO_SITE
                                ,SEGMENT5   AS PRIORITY
                                ,ATTRIBUTE1 AS FROM_DATE
                                ,ATTRIBUTE2 AS TO_DATE
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY'
                        AND     SEGMENT2    = @V_DIVISION_ID
                        AND     VALID_YN    = 'Y'
                        ) TP
        ON  A.SCM_SITE_ID = TP.TO_SITE
        AND A.ITEM_ID     = TP.ITEM_ID
        AND A.ATTRIBUTE1 BETWEEN TP.FROM_DATE AND TP.TO_DATE */
           AND A.QTY             > 0
           AND A.DIVISION_ID     = V_DIVISION_ID
           AND A.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY
           AND A.VERSION_NO      = V_DM_MAX_VERSION
           AND A.ATTRIBUTE1     >= V_PLAN_START_YYYYMMDD
           AND A.ATTRIBUTE1      < V_PLAN_END_YYYYMMDD
           AND ( DE.ITEM_ID IS NULL /* LOOKUP 에 등록되어 있지 않은 정보 */
              OR (DE.ITEM_ID IS NOT NULL AND (A.ATTRIBUTE1 < DE.START_DATE OR A.ATTRIBUTE1 > DE.END_DATE)) /* LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보 */
               );

        INSERT
          INTO GT_OPT_ENG_GMAML_BIZ
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE
             , ORG_STAGE )
        SELECT CH.PLAN_ID
             , BZ.SCM_SITE_ID
             , CH.ITEM_ID
             , 'CELLBIZ'
             , 'CELLBIZ'
          FROM GT_OPT_ENG_GMAML_CHAR CH
             , (SELECT DISTINCT SCM_SITE_ID
                  FROM GT_OPT_ENG_GMAML_BIZ
               ) BZ
         WHERE NOT EXISTS ( SELECT 1
                              FROM GT_OPT_ENG_GMAML_BIZ BIZ
                             WHERE BIZ.PLAN_ID     = CH.PLAN_ID
                               AND BIZ.SCM_SITE_ID = BZ.SCM_SITE_ID
                               AND BIZ.ITEM_ID     = CH.ITEM_ID );

        /* ---------------------------------------------------------------------- */
        /* 6. 최종 Model List INSERT : 중복 제외를 위해 UNION 적용 */
        /* ---------------------------------------------------------------------- */
        INSERT
          INTO SCP_OPT_ENG_MODEL_LIST_N_SN
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , STAGE
             , ITEM_CLASS_ID )
        /* STK Model */
        SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE, ORG_STAGE
          FROM GT_OPT_ENG_GMAML_STK STK
        /* ASSY Model */
         UNION
        SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE, ORG_STAGE
          FROM GT_OPT_ENG_GMAML_ASSY LV
        /* ASY_AGING */
         UNION
        SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE, ORG_STAGE
          FROM GT_OPT_ENG_GMAML_DEGAS A
        /* EOL */
         UNION
        SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE, ORG_STAGE
          FROM GT_OPT_ENG_GMAML_EOL A
        /* PACK/MDLE 기준 CHAR Model */
         UNION
        SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE, ORG_STAGE
          FROM GT_OPT_ENG_GMAML_CHAR A
        /* BIZ Model */
         UNION
        SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE, ORG_STAGE
          FROM GT_OPT_ENG_GMAML_BIZ A;

        /* ---------------------------------------------------------------------- */
        /* Data Insert End */
        /* ---------------------------------------------------------------------- */

    /* ---------------------------------------------------------------------- */
    /* ROLLBACK TRANSACTION PR_SCP_OPT_ENG_RUN_MAIN_PROC; */
    /* ERROR LOG */
    /* ---------------------------------------------------------------------- */
    EXCEPTION
        WHEN OTHERS THEN
            V_MESSAGE_TEXT := SQLERRM;
            PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'ERROR',NULL,V_MESSAGE_TEXT,NULL,V_PLAN_ID);
            V_DETAIL_DATE  := SYSDATE;
            PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,V_DETAIL_DATE,NULL,V_MESSAGE_TEXT,'ERROR');
            RAISE_APPLICATION_ERROR(-20001, V_PROGRAM_NAME);
    END;

    /* ---------------------------------------------------------------------- */
    /* 종료 LOG */
    /* ---------------------------------------------------------------------- */
    IF V_MESSAGE_TEXT IS NULL THEN
        PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'END',NULL,NULL,NULL,V_PLAN_ID);
        PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,NULL,NULL,NULL,NULL);
    END IF;

END PR_SCP_OPT_ENG_GM_INPUT_ASSIGN_MODEL_LIST;