PROCEDURE PR_SCP_OPT_ENG_SR_INPUT_ASSIGN_MODEL_LIST
(
      P_PLAN_ID             VARCHAR2
    , V_DIVISION_ID         VARCHAR2
    , V_GROUP_ID            VARCHAR2
    , V_PLAN_START_YYYYMMDD VARCHAR2
    , V_PLAN_END_YYYYMMDD   VARCHAR2
)
/* ============================================================
 * Program ID   : PR_SCP_OPT_ENG_SR_INPUT_ASSIGN_MODEL_LIST
 * Description  : OPT ENG SR INPUT - ASSIGN MODEL LIST 생성
 *                (ASSY / ASY_AGING / CHAR / BIZ / SUBMDLE 단계 통합 후 SCP_OPT_ENG_MODEL_LIST_N_SN 적재)
 * Program History
 *------------------------------------------------------------
 * Date          In Charge       Description
 *------------------------------------------------------------
 * 2025.07.07    Philsu Park     Initial Release
 * 2026.03.10    jongykim2       SHIP REQ
 * 2026.10.19    ZIONEX          [PJ202650304]  MSSQL -> Oracle 전환
 * ============================================================ */
AS
    /* MSSQL #ASSY_MODEL_LIST      -> Oracle GTT GT_OPT_SR_AML_ASSY  */
    /* MSSQL #ASY_AGING_MODEL_LIST -> Oracle GTT GT_OPT_SR_AML_AGING */
    /* MSSQL #CHAR_MODEL_LIST      -> Oracle GTT GT_OPT_SR_AML_CHAR  */
    /* MSSQL #BIZ_MODEL_LIST       -> Oracle GTT GT_OPT_SR_AML_BIZ   */
    /* MSSQL #SUBMDLE_MODEL_LIST   -> Oracle GTT GT_OPT_SR_AML_SUB   */

    /*------------------------------------------------------------------------*/
    /* Set Prameter                                                           */
    /*------------------------------------------------------------------------*/
    V_PROGRAM_NAME       VARCHAR2(150 CHAR) := 'PR_SCP_OPT_ENG_SR_INPUT_ASSIGN_MODEL_LIST';
    V_PLAN_ID            VARCHAR2(50 CHAR)  := P_PLAN_ID;
    V_MESSAGE_TEXT       VARCHAR2(1000 CHAR);
    V_DETAIL_DATE        DATE;
    /*------------------------------------------------------------------------*/
    /* Set Param for Biz                                                      */
    /*------------------------------------------------------------------------*/
    V_PLAN_START_YYYYMM  VARCHAR2(6 CHAR)   := SUBSTR(V_PLAN_START_YYYYMMDD,1,6);
    V_PLAN_END_YYYYMM    VARCHAR2(6 CHAR)   := SUBSTR(V_PLAN_END_YYYYMMDD,1,6);
    V_MAX_TUESDAY        VARCHAR2(8 CHAR);
    D_PLAN_NAME          DATE;
    V_DEMAND_CUTOFF_DAY  VARCHAR2(8 CHAR);
    V_DM_MAX_VERSION     VARCHAR2(50 CHAR);
BEGIN
    /* 2025.05.28 Philsu Park Initial Release. */
    /* 2025.05.30 Philsu Park: OPT ENG LOOKUP 반영. */
    /*------------------------------------------------------------------------*/
    /* Procedure 기본조건.                                                     */
    /*------------------------------------------------------------------------*/
    /* SET XACT_ABORT ON; */
    /* SET NOCOUNT ON; */
    /* SET TRANSACTION ISOLATION LEVEL READ COMMITTED; */
    /*------------------------------------------------------------------------*/

    /* Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성 */
    /*------------------------------------------------------------------------*/
    PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'START',NULL,NULL,NULL,V_PLAN_ID);

    /*------------------------------------------------------------------------*/
    /* Set Param For Find latest demand version.                              */
    /*------------------------------------------------------------------------*/
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
       AND P.CUTOFF_YYYYMMDD >= TO_CHAR(D_PLAN_NAME - 3,'YYYYMMDD')   /* 월요일 기준 최근 3일 이내 */
       AND P.CUTOFF_YYYYMMDD <= TO_CHAR(D_PLAN_NAME + 6,'YYYYMMDD');  /* 해당 주차 일요일 이전 */

    /*------------------------------------------------------------------------*/
    SELECT MAX(P.VERSION_NO)
      INTO V_DM_MAX_VERSION
      FROM DM_PLN_NET_DEMAND P
     WHERE P.DIVISION_ID     = V_DIVISION_ID
       AND P.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY;

    /*------------------------------------------------------------------------*/
    /* Transaction (START)                                                    */
    /*------------------------------------------------------------------------*/
    /* BEGIN TRANSACTION SCP_OPT_ENG_RUN_MAIN_PROC; */
    /*------------------------------------------------------------------------*/
    BEGIN

        DELETE
          FROM GT_OPT_SR_AML_ASSY;

        DELETE
          FROM GT_OPT_SR_AML_AGING;

        DELETE
          FROM GT_OPT_SR_AML_CHAR;

        DELETE
          FROM GT_OPT_SR_AML_BIZ;

        DELETE
          FROM GT_OPT_SR_AML_SUB;

        /*------------------------------------------------------------------------*/
        /* Data Insert Start                                                      */
        /*------------------------------------------------------------------------*/
        /* 1. STAGE: ASY                                                          */
        /* 2025.06.13 Philsu Park: FINAL ITEM에 미등록된 모델은 제외(INNER JOIN으로 변경) */
        /*------------------------------------------------------------------------*/
        /*
        WITH PLAN_GROUP AS (
                    SELECT    GR.OPMZ_PLAN_GR_NAME  AS PLAN_GROUP_NAME
                            , T.OPMZ_PLAN_GR_ID     AS PLAN_GROUP_ID
                            , T.LINE_ID             AS LINE_ID
                            , T.OPERATION_ID        AS OPERATION_ID
                            , T.FACTORY_ID          AS FACTORY_ID
                            , T.PLANT_ID            AS PLANT_ID
                            , T.ITEM_ID             AS ITEM_ID
                    FROM    SCP_OPMZ_PLAN_GR_LINE_M T WITH(NOLOCK)
                    INNER JOIN SCP_OPMZ_PLAN_GR_M GR WITH(NOLOCK)
                        ON  T.OPMZ_PLAN_GR_ID       = GR.OPMZ_PLAN_GR_ID
                    WHERE   GR.OPMZ_PLAN_GR_NAME    = @V_GROUP_ID
                    AND     T.VALID_YN              = 'Y'
            )
        -- 위 정의된 라인 기준으로 Item List 추출.
        -- STAGE: ASSY, ASY_AGING 동일 기준으로 생성.
        SELECT    @V_PLAN_ID        AS PLAN_ID
                , ST.SCM_SITE_ID    AS SCM_SITE_ID
                , ILA.ITEM_ID       AS ITEM_ID
                , CASE  WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P9500'    THEN 'PACK'
                        WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P5500'    THEN 'MDLE'
                        WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID   NOT IN ('P5500', 'P9500') THEN 'SUBMDLE'
                        WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8  = 'CP'       THEN 'CHAR'
                        WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8 <> 'CP'       THEN 'ASSY'
                        ELSE '-'
                   END              AS ITEM_STAGE
                , ILA.DIVISION_ID   AS DIVISION_ID
                , ILA.PLANT_ID      AS PLANT_ID
        INTO    #ASSY_MODEL_LIST
        FROM    SCM_MST_ITEM_LINE_ASSIGN_SN ILA WITH(NOLOCK)
        INNER JOIN PLAN_GROUP GRP
            ON  ILA.LINE_ID         = GRP.LINE_ID
            AND ILA.OPERATION_ID    = GRP.OPERATION_ID
            AND ILA.FACTORY_ID      = GRP.FACTORY_ID
            AND ILA.PLANT_ID        = GRP.PLANT_ID
            AND ILA.ITEM_ID         = IIF(GRP.ITEM_ID='-', ILA.ITEM_ID, GRP.ITEM_ID)  -- item 명시 안되어있으면 assign 전체.
        INNER JOIN (
                    SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                    FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK)
                    WHERE  1=1
                    AND    DIVISION_ID = @V_DIVISION_ID
                    AND    OPERATION_GROUP IN ('A', 'P') -- 2026-03-10, 소형 특화제거에 따른 추가
                    -- 2026-03-10, 소형 특화제거
                    --AND   ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
                    --    OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
                    --        )
                    ) FNL
            ON  ILA.DIVISION_ID = FNL.DIVISION_ID
            AND ILA.ITEM_ID     = FNL.ITEM_ID
        INNER  JOIN SCM_ITEM_M_SN SIM
            ON 1=1
            AND ILA.COMPANY_ID  = SIM.COMPANY_ID
            AND ILA.DIVISION_ID = SIM.DIVISION_ID
            AND ILA.SITE_ID 	= SIM.SITE_ID
            AND ILA.ITEM_ID 	= SIM.ITEM_ID
            AND SIM.ACTIVE_FLAG = 'Y'
        LEFT OUTER JOIN SCM_MST_SITE ST WITH(NOLOCK)
            ON  ILA.DIVISION_ID         = ST.DIVISION_ID
            AND ILA.PLANT_ID            = ST.PLANT_ID
            AND FNL.OPERATION_GROUP     = ST.OPERATION_GROUP
            AND ST.VALID_YN             = 'Y'
        WHERE   1=1
        AND     ILA.MONTH         BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
        AND     ILA.ACTIVE_FLAG         = 'Y'
        AND     ILA.PRIORITY           <> 9                       -- 신재욱 책임님 요청. 9순위 제외.
        GROUP BY  ST.SCM_SITE_ID
                , ILA.ITEM_ID
                , CASE  WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P9500'    THEN 'PACK'
                        WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P5500'    THEN 'MDLE'
                        WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID   NOT IN ('P5500', 'P9500') THEN 'SUBMDLE'
                        WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8  = 'CP'       THEN 'CHAR'
                        WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8 <> 'CP'       THEN 'ASSY'
                        ELSE '-'
                END
                , ILA.DIVISION_ID
                , ILA.PLANT_ID
        ;
        */
        /* ==================================== */
        /* 2026-03-10, 사업부 통합적용           */
        /* ==================================== */
        INSERT
          INTO GT_OPT_SR_AML_ASSY
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE
             , DIVISION_ID
             , PLANT_ID )
        WITH ASSY_MODEL_LIST AS (
            /* ==================================== */
            /* LINE ASSIGN 기반                      */
            /* ==================================== */
            SELECT V_PLAN_ID         AS PLAN_ID
                  ,ST.SCM_SITE_ID    AS SCM_SITE_ID
                  ,ILA.ITEM_ID       AS ITEM_ID
                  ,CASE  WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P9500'    THEN 'PACK'
                         WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P5500'    THEN 'MDLE'
                         WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID   NOT IN ('P5500', 'P9500') THEN 'SUBMDLE'
                         WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8  = 'CP'       THEN 'CHAR'
                         WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8 <> 'CP'       THEN 'ASSY'
                         ELSE '-'
                    END              AS ITEM_STAGE
                   ,ILA.DIVISION_ID  AS DIVISION_ID
                   ,ILA.PLANT_ID     AS PLANT_ID
            FROM    SCM_MST_ITEM_LINE_ASSIGN_SN ILA
            INNER JOIN (
                        SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                        FROM   SCP_MST_FINAL_ITEM
                        WHERE  1=1
                        AND    DIVISION_ID = V_DIVISION_ID
                        AND    OPERATION_GROUP IN ('A', 'P')
                        ) FNL
                ON  ILA.DIVISION_ID = FNL.DIVISION_ID
                AND ILA.ITEM_ID     = FNL.ITEM_ID
            INNER  JOIN SCM_ITEM_M_SN SIM
                ON 1=1
                AND ILA.COMPANY_ID  = SIM.COMPANY_ID
                AND ILA.DIVISION_ID = SIM.DIVISION_ID
                AND ILA.SITE_ID   = SIM.SITE_ID
                AND ILA.ITEM_ID   = SIM.ITEM_ID
                AND SIM.ACTIVE_FLAG = 'Y'
            LEFT OUTER JOIN SCM_MST_SITE ST
                ON  ILA.DIVISION_ID         = ST.DIVISION_ID
                AND ILA.PLANT_ID            = ST.PLANT_ID
                AND FNL.OPERATION_GROUP     = ST.OPERATION_GROUP
                AND ST.VALID_YN             = 'Y'
            WHERE   1=1
            AND     ILA.MONTH         BETWEEN V_PLAN_START_YYYYMM AND V_PLAN_END_YYYYMM
            AND     ILA.ACTIVE_FLAG         = 'Y'
            AND     ILA.PRIORITY           <> 9                       /* 신재욱 책임님 요청. 9순위 제외. */
            GROUP BY ST.SCM_SITE_ID
                    ,ILA.ITEM_ID
                    ,CASE  WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P9500'    THEN 'PACK'
                           WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P5500'    THEN 'MDLE'
                           WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID   NOT IN ('P5500', 'P9500') THEN 'SUBMDLE'
                           WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8  = 'CP'       THEN 'CHAR'
                           WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8 <> 'CP'       THEN 'ASSY'
                           ELSE '-'
                     END
                    ,ILA.DIVISION_ID
                    ,ILA.PLANT_ID
            UNION
            /* ==================================== */
            /* OSP 외주 Line CAPA 기반               */
            /* ==================================== */
            SELECT V_PLAN_ID         AS PLAN_ID
                  ,SMS.SCM_SITE_ID   AS SCM_SITE_ID
                  ,SMO.ITEM_ID       AS ITEM_ID
                  ,CASE  WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P9500'    THEN 'PACK'
                         WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P5500'    THEN 'MDLE'
                         WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID   NOT IN ('P5500', 'P9500') THEN 'SUBMDLE'
                         WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8  = 'CP'       THEN 'CHAR'
                         WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8 <> 'CP'       THEN 'ASSY'
                         ELSE '-'
                   END               AS ITEM_STAGE
                  ,SMO.DIVISION_ID   AS DIVISION_ID
                  ,SMS.PLANT_ID      AS PLANT_ID
            /* FROM   SCP_MST_TACT_TIME_OSP SMO WITH(NOLOCK) -- 82 전용 */
            FROM   SCP_MST_OUTSOURCING_CAPA SMO
                /* LEFT OUTER JOIN SCM_MST_SITE SMS WITH(NOLOCK) -- blocked */
                INNER JOIN SCM_MST_SITE SMS /* inner로 변경 */
                  ON  SMO.DIVISION_ID   = SMS.DIVISION_ID
                  AND SMO.PLANT_SITE_ID = SMS.SCM_SITE_ID
                INNER JOIN (
                      SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, OPERATION_GROUP_ID,  FLOW_ID, ATTRIBUTE8
                      FROM   SCP_MST_FINAL_ITEM
                      WHERE  1=1
                      AND    DIVISION_ID = V_DIVISION_ID
                      AND    OPERATION_GROUP IN ('A','P')
                      /*AND   ( (DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A','P') )      -- 소형은 CEll Biz 용 Demand 만 처리
                        OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
                          ) */
                      ) FNL
                  ON  SMO.DIVISION_ID = FNL.DIVISION_ID
                  AND SMO.ITEM_ID     = FNL.ITEM_ID
            WHERE 1=1
            GROUP BY SMS.SCM_SITE_ID
                    ,SMO.ITEM_ID
                    ,SMO.ITEM_ID
                    ,CASE WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P9500'    THEN 'PACK'
                          WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P5500'    THEN 'MDLE'
                          WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID   NOT IN ('P5500', 'P9500') THEN 'SUBMDLE'
                          WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8  = 'CP'       THEN 'CHAR'
                          WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8 <> 'CP'       THEN 'ASSY'
                          ELSE '-'
                     END
                    ,SMO.DIVISION_ID
                    ,SMS.PLANT_ID
        )
        SELECT ML.PLAN_ID
              ,ML.SCM_SITE_ID
              ,ML.ITEM_ID
              ,ML.ITEM_STAGE
              ,ML.DIVISION_ID
              ,ML.PLANT_ID
        FROM   ASSY_MODEL_LIST ML
        WHERE  1=1
        ;

        /*------------------------------------------------------------------------*/
        /* 2. STAGE: ASY_AGING: ASSY -> ASY_AGING 모델 변경없이 동일.               */
        /*------------------------------------------------------------------------*/
        INSERT
          INTO GT_OPT_SR_AML_AGING
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE
             , DIVISION_ID
             , PLANT_ID )
        SELECT V_PLAN_ID     AS PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , 'ASY_AGING'   AS ITEM_STAGE
             , DIVISION_ID
             , PLANT_ID
          FROM GT_OPT_SR_AML_ASSY
         WHERE ITEM_STAGE = 'ASSY'
        ;

        /*------------------------------------------------------------------------*/
        /* 3. STAGE: CHAR: ASY_AGING 기준으로 PROD 모델 Mapping 정보를 찾아옴.      */
        /*------------------------------------------------------------------------*/
        INSERT
          INTO GT_OPT_SR_AML_CHAR
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE
             , DIVISION_ID
             , PLANT_ID )
        SELECT V_PLAN_ID              AS PLAN_ID
             , ST.SCM_SITE_ID         AS SCM_SITE_ID
             , PRD.ITEM_ID_PROD       AS ITEM_ID
             , CASE WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID      = 'P9500'               THEN 'PACK'
                    WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID      = 'P5500'               THEN 'MDLE'
                    WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID    NOT IN ('P5500', 'P9500') THEN 'SUBMDLE'
                    WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8   = 'CP'                  THEN 'CHAR'
                    WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8  <> 'CP'                  THEN 'ASSY'
                    ELSE '-'
               END                    AS ITEM_STAGE
             , PRD.DIVISION_ID        AS DIVISION_ID
             , PRD.PLANT_ID           AS PLANT_ID
          FROM SCP_MST_CELL_PROD_ASSY_MAP PRD
          LEFT OUTER JOIN (
                            SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                            FROM   SCP_MST_FINAL_ITEM
                            WHERE  1=1
                            AND    DIVISION_ID = V_DIVISION_ID
                            AND    OPERATION_GROUP IN ('A', 'P') /* 2026-03-10, 소형 특화제거에 따른 추가 */
                            /* 2026-03-10, 소형 특화제거 */
                            /*AND   ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
                                OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
                                    ) */
                            ) FNL
            ON  PRD.DIVISION_ID     = FNL.DIVISION_ID
            AND PRD.ITEM_ID_PROD    = FNL.ITEM_ID
          LEFT OUTER JOIN SCM_MST_SITE ST
            ON  PRD.DIVISION_ID         = ST.DIVISION_ID
            AND PRD.PLANT_ID            = ST.PLANT_ID
            AND FNL.OPERATION_GROUP     = ST.OPERATION_GROUP
            AND ST.VALID_YN             = 'Y'
         WHERE EXISTS ( SELECT 1
                          FROM GT_OPT_SR_AML_AGING AG
                         WHERE AG.DIVISION_ID  = PRD.DIVISION_ID
                           AND AG.PLANT_ID     = PRD.PLANT_ID
                           AND AG.ITEM_ID      = PRD.ITEM_ID_ASSY
                      )
           AND PRD.CELL_TYPE   = 'CA1'
           AND PRD.VALID_YN    = 'Y'
        ;

        /*------------------------------------------------------------------------*/
        /* 3. STAGE: BIZ: CHAR 기준으로 NET Demand에서 각 Site 별 모델 정보를 추출. */
        /*------------------------------------------------------------------------*/
        INSERT
          INTO GT_OPT_SR_AML_BIZ
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE )
        SELECT DISTINCT
               DM.PLAN_ID
             , DM.SCM_SITE_ID
             , DM.ITEM_ID
             , DM.ITEM_STAGE
          FROM (
                SELECT V_PLAN_ID                AS PLAN_ID
                     , A.DIVISION_ID            AS DIVISION_ID
                     , A.SCM_SITE_ID            AS SCM_SITE_ID
                     , A.ITEM_ID                AS ITEM_ID
                     , CASE WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500'        THEN 'PACKBIZ'
                            WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500'        THEN 'MDLEBIZ'
                            WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLEBIZ'
                            WHEN B.OPERATION_GROUP = 'A'    THEN 'CELLBIZ'
                            ELSE '-'
                       END                      AS ITEM_STAGE
                     , A.ATTRIBUTE1             AS DUE_DATE
                  FROM DM_PLN_NET_DEMAND A
                 INNER JOIN ( SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID
                                FROM GT_OPT_SR_AML_CHAR
                               UNION
                              SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID
                                FROM GT_OPT_SR_AML_ASSY
                               WHERE ITEM_STAGE IN ('MDLE', 'PACK')
                              /*  AND    DIVISION_ID != '40' */
                            ) CM
                    ON  A.DIVISION_ID   = CM.DIVISION_ID
                   AND  A.ITEM_ID       = CM.ITEM_ID
                   AND  A.CELL_PROD_SITE_ID = CASE WHEN V_DIVISION_ID = '40' THEN CM.SCM_SITE_ID ELSE A.CELL_PROD_SITE_ID END
                 /*------------------------------------------------------------------------*/
                 INNER JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                                FROM SCP_MST_FINAL_ITEM
                               WHERE 1=1
                                 AND DIVISION_ID = V_DIVISION_ID
                                 AND OPERATION_GROUP IN ('A', 'P') /* 2026-03-10, 소형 특화제거에 따른 추가 */
                                 /* 2026-03-10, 소형 특화제거 */
                                 /*AND    ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
                                     OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
                                         ) */
                            ) B
                    ON  A.DIVISION_ID = B.DIVISION_ID
                   AND  A.ITEM_ID     = B.ITEM_ID
                 /*------------------------------------------------------------------------*/
                  LEFT OUTER JOIN( /* TOSITE PRIORITY CONSTRAINT */
                                   /*
                                   SELECT   SEGMENT4   AS ITEM_ID
                                           ,SEGMENT5   AS TO_SITE
                                           ,SEGMENT6   AS PRIORITY
                                           ,ATTRIBUTE1 AS FROM_DATE
                                           ,ATTRIBUTE2 AS TO_DATE
                                   FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                   WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY_NEW'
                                   AND     SEGMENT2    = @V_DIVISION_ID
                                   AND     SEGMENT3    = @V_GROUP_ID
                                   AND     VALID_YN    = 'Y'
                                   */

                                   /* 2025.11.18 Minyong Lee : Sales Site Priority Lookup -> UI 전환 */
                                   SELECT  P.ITEM_ID       AS ITEM_ID
                                         , P.SCM_SITE_ID   AS TO_SITE
                                         , TO_CHAR(P.PRIO_RANK)     AS PRIORITY
                                         , FROM_YYYYMMDD   AS FROM_DATE
                                         , TO_YYYYMMDD     AS TO_DATE
                                   FROM    SCP_OPMZ_SALES_SITE_PRIORITY P
                                       LEFT JOIN SCP_OPMZ_PLAN_GR_M PG
                                           ON  P.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                           AND PG.VALID_YN = 'Y'
                                   WHERE   1=1
                                   AND     P.VALID_YN = 'Y'
                                   AND     P.DIVISION_ID = V_DIVISION_ID
                                   AND     PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                                   ) TP
                    ON  A.SCM_SITE_ID = TP.TO_SITE
                   AND  A.ITEM_ID     = TP.ITEM_ID
                   AND  A.ATTRIBUTE1 BETWEEN TP.FROM_DATE AND TP.TO_DATE
                 WHERE A.DIVISION_ID     =  V_DIVISION_ID
                   AND A.CUTOFF_YYYYMMDD =  V_DEMAND_CUTOFF_DAY
                   AND A.VERSION_NO      =  V_DM_MAX_VERSION
                   AND A.ATTRIBUTE1      >= V_PLAN_START_YYYYMMDD
                   AND A.ATTRIBUTE1      <  V_PLAN_END_YYYYMMDD
                   AND A.QTY             >  0
               ) DM
                 /*------------------------------------------------------------------------*/
                 /* DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리           */
                 /* 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3) */
                 /* 2025.11.10 Minyong Lee : 소형 Demand 제외 조건에 Stage 추가 적용에 따른 JOIN Depth 변경 */
                 /*------------------------------------------------------------------------*/
          LEFT JOIN (
                     /*
                     SELECT SEGMENT2   AS DIVISION_ID
                         , SEGMENT3   AS SCM_SITE_ID
                         , SEGMENT4   AS ITEM_ID
                         , SEGMENT5   AS GROUP_ID
                         , ATTRIBUTE1 AS STAGE
                         , CASE
                                 WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
                                 ELSE ATTRIBUTE2
                             END AS START_DATE  -- PLAN 제외 시작일자
                         , CASE
                                 WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                                 ELSE ATTRIBUTE3
                             END AS END_DATE  -- PLAN 제외 끝일자
                     FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                     WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                     AND    VALID_YN    = 'Y'
                     AND    SEGMENT2    = @V_DIVISION_ID
                     AND    SEGMENT5    = @V_GROUP_ID
                     */

                     /* 2025.11.17 Minyong Lee : Demand Exception Lookup -> UI 전환 */
                     SELECT  D.DIVISION_ID           AS DIVISION_ID
                           , D.SCM_SITE_ID           AS SCM_SITE_ID
                           , D.ITEM_ID               AS ITEM_ID
                           , PG.OPMZ_PLAN_GR_NAME    AS GROUP_ID
                           , D.STAGE                 AS STAGE
                           , CASE
                                 WHEN D.FROM_YYYYMMDD IS NULL THEN V_PLAN_END_YYYYMMDD
                                 ELSE D.FROM_YYYYMMDD
                             END                     AS START_DATE
                           , CASE
                                 WHEN D.TO_YYYYMMDD IS NULL THEN V_PLAN_END_YYYYMMDD
                                 ELSE D.TO_YYYYMMDD
                             END                     AS END_DATE
                     FROM    SCP_OPMZ_DEMAND_EXCEPTION D
                         LEFT JOIN SCP_OPMZ_PLAN_GR_M PG
                             ON  D.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                             AND PG.VALID_YN = 'Y'
                     WHERE   1=2 /* 2026-03-10, 제약제거 */
                     AND     D.VALID_YN = 'Y'
                     AND     D.DIVISION_ID = V_DIVISION_ID
                     AND     PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                    ) DE
            ON  DM.SCM_SITE_ID   = DE.SCM_SITE_ID
           AND  DM.ITEM_ID       = DE.ITEM_ID
           AND  ((DM.DIVISION_ID = '40' AND DM.ITEM_STAGE = DE.STAGE) OR  /* 소형의 경우 JOIN 조건에 STAGE까지 고려 */
                   DM.DIVISION_ID <> '40')
        /* DEMAND 제외 대상 처리 */
         WHERE 1=1
           AND (DE.ITEM_ID IS NULL OR                                                             /* 수요 제외 대상이 아니거나 */
                (DE.ITEM_ID IS NOT NULL AND (DM.DUE_DATE < DE.START_DATE OR DM.DUE_DATE > DE.END_DATE))) /* 수요 제외 대상이어도 기간 범위 밖인 것 */
        ;

        /*------------------------------------------------------------------------*/
        /* 4. STAGE: SUBMDLE: PACK, MDLE 하위 SUBMDLE 모델 추출                    */
        /*------------------------------------------------------------------------*/
        /*-----------------------------------------------------*/
        /* 4-1. PACK/MDLE 하위의 SUBMDLE Model                  */
        /*-----------------------------------------------------*/
        INSERT
          INTO GT_OPT_SR_AML_SUB
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE
             , DIVISION_ID
             , PLANT_ID )
        SELECT DISTINCT
               P_PLAN_ID        AS PLAN_ID
             , M.SCM_SITE_ID    AS SCM_SITE_ID
             , A.CHILD_ITEM_ID  AS ITEM_ID
             , 'SUBMDLE'        AS ITEM_STAGE
             , A.DIVISION_ID    AS DIVISION_ID
             , A.PLANT_ID       AS PLANT_ID
          FROM SCM_MST_ALTER_BOM_V A
         INNER JOIN (SELECT *
                     FROM   GT_OPT_SR_AML_ASSY
                     WHERE  ITEM_STAGE in ('MDLE', 'PACK')
                    ) M
            ON  A.DIVISION_ID    = M.DIVISION_ID
           AND  A.PLANT_ID       = M.PLANT_ID
           AND  A.PARENT_ITEM_ID = M.ITEM_ID
           AND  A.SCP_PLAN_YN    = 'Y'
        ;

        /*----------------------------------------------------------------------------------------------------------*/
        /* 2-2. 대치 없는 경우도 찾아야하기 때문에 한 번 더 INSERT                                                    */
        /* 2025.06.19 Philsu Park: SUBMDLE 불필요 자재 제외 처리(LEAF_LEVEL 조건 추가.)                               */
        /*----------------------------------------------------------------------------------------------------------*/
        INSERT
          INTO GT_OPT_SR_AML_SUB
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , ITEM_STAGE
             , DIVISION_ID
             , PLANT_ID )
        SELECT DISTINCT
               P_PLAN_ID        AS PLAN_ID
             , M.SCM_SITE_ID    AS SCM_SITE_ID
             , A.CHILD_ITEM_ID  AS ITEM_ID
             , 'SUBMDLE'        AS ITEM_STAGE
             , A.DIVISION_ID    AS DIVISION_ID
             , A.PLANT_ID       AS PLANT_ID
          FROM SCM_MST_BOM_SN_V A
         INNER JOIN (SELECT *
                     FROM   GT_OPT_SR_AML_ASSY
                     WHERE  ITEM_STAGE in ('MDLE', 'PACK')
                    ) M
            ON  A.DIVISION_ID       = M.DIVISION_ID
           AND  A.PLANT_ID          = M.PLANT_ID
           AND  A.PARENT_ITEM_ID    = M.ITEM_ID
           AND  A.LEAF_LEVEL       IS NULL
           AND  NOT EXISTS (
                            SELECT  'X'
                            FROM    GT_OPT_SR_AML_SUB LI
                            WHERE   A.DIVISION_ID    = LI.DIVISION_ID
                            AND     A.PLANT_ID       = LI.PLANT_ID
                            AND     A.PARENT_ITEM_ID = LI.ITEM_ID
                           )
        /* WHERE   A.SCP_PLAN_YN = 'Y' */
        ;

        /*-----------------------------------------------------*/
        /* 3. PACK/MDLE 기준 CHAR Model                         */
        /*-----------------------------------------------------*/
        /* SELECT @P_PLAN_ID      AS PLAN_ID
              ,A.DIVISION_ID   AS DIVISION_ID
              ,M.SCM_SITE_ID   AS SCM_SITE_ID
              ,A.CHILD_ITEM_ID AS ITEM_ID
              ,M.GROUP_ID      AS GROUP_ID
              ,'CHAR'          AS STAGE
              ,'CHAR'          AS ITEM_STAGE
              ,A.PLANT_ID      AS PLANT_ID
        INTO #CHAR_LIST
        FROM SCM_MST_ALTER_BOM_V A WITH(NOLOCK)
        INNER JOIN #SUBMDLE_LIST M WITH(NOLOCK)

        ON  A.DIVISION_ID    = M.DIVISION_ID
        AND A.PLANT_ID       = M.PLANT_ID
        AND A.PARENT_ITEM_ID = M.ITEM_ID
        AND A.SCP_PLAN_YN    = 'Y'
         */
        /*-----------------------------------------------------*/
        /* 4. CHAR 하위의 ASY_AGING Model                       */
        /*-----------------------------------------------------*/
        /* SELECT @P_PLAN_ID      AS PLAN_ID
              ,A.DIVISION_ID   AS DIVISION_ID
              ,M.SCM_SITE_ID   AS SCM_SITE_ID
              ,A.ITEM_ID_ASSY  AS ITEM_ID
              ,M.GROUP_ID      AS GROUP_ID
              ,'ASY_AGING'     AS STAGE
              ,'ASY_AGING'     AS ITEM_STAGE
              ,A.PLANT_ID      AS PLANT_ID
        FROM SCP_MST_CELL_PROD_ASSY_MAP A WITH(NOLOCK)
        INNER JOIN (SELECT *
                    FROM   #MODEL_LIST
                    WHERE  ITEM_STAGE in ('CHAR')
                   ) M

        ON  A.DIVISION_ID    = M.DIVISION_ID
        AND A.PLANT_ID       = M.PLANT_ID
        AND A.ITEM_ID_PROD   = M.ITEM_ID
        AND A.VALID_YN       = 'Y'
        AND A.CELL_TYPE      = 'CA1'
        */
        /*-----------------------------------------------------*/
        /* 5. 최종 Model List INSERT : 중복 제외를 위해 UNION 적용 */
        /*-----------------------------------------------------*/
        INSERT
          INTO SCP_OPT_ENG_MODEL_LIST_N_SN
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , STAGE )
        /* Line Assign Model */
        SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE
          FROM GT_OPT_SR_AML_ASSY LV
        /* ASY_AGING */
         UNION
        SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE
          FROM GT_OPT_SR_AML_AGING A
        /* PACK/MDLE 기준 CHAR Model */
         UNION
        SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE
          FROM GT_OPT_SR_AML_CHAR A
        /* BIZ Model */
         UNION
        SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE
          FROM GT_OPT_SR_AML_BIZ A
        /* SUBModule Model */
         UNION
        SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE
          FROM GT_OPT_SR_AML_SUB A
        ;

        /*------------------------------------------------------------------------*/
        /* Data Insert End                                                        */
        /*------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------*/
    EXCEPTION
        WHEN OTHERS THEN
    /*------------------------------------------------------------------------*/
    /* ROLLBACK TRANSACTION PR_SCP_OPT_ENG_RUN_MAIN_PROC; */
    /*------------------------------------------------------------------------*/
    /* ERROR LOG                                                              */
    /*------------------------------------------------------------------------*/
            V_MESSAGE_TEXT := SUBSTR(SQLERRM, 1, 1000);
            /*------------------------------------------------------------------------*/
            PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'ERROR',NULL,V_MESSAGE_TEXT,NULL,V_PLAN_ID);
            /*------------------------------------------------------------------------*/
            V_DETAIL_DATE := SYSDATE;
            /*------------------------------------------------------------------------*/
            PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,V_DETAIL_DATE,NULL,V_MESSAGE_TEXT,'ERROR');
            /*------------------------------------------------------------------------*/
            RAISE_APPLICATION_ERROR(-20001, V_PROGRAM_NAME);
            /*------------------------------------------------------------------------*/
    END;
    /*------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------*/
    /* 종료 LOG                                                                */
    /*------------------------------------------------------------------------*/
    IF V_MESSAGE_TEXT IS NULL THEN
    /*------------------------------------------------------------------------*/
        PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'END',NULL,NULL,NULL,V_PLAN_ID);
        PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,NULL,NULL,NULL,NULL);
    END IF;
    /*------------------------------------------------------------------------*/
END PR_SCP_OPT_ENG_SR_INPUT_ASSIGN_MODEL_LIST;