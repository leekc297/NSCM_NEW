PROCEDURE PR_SCP_OPT_ENG_INPUT_SCHEDULED_MOVE
(
     P_PLAN_ID              VARCHAR2
    ,V_DIVISION_ID          VARCHAR2
    ,V_GROUP_ID             VARCHAR2
    ,V_PLAN_START_YYYYMMDD  VARCHAR2
    ,V_PLAN_END_YYYYMMDD    VARCHAR2
)
/* ============================================================
 * Program ID   : PR_SCP_OPT_ENG_INPUT_SCHEDULED_MOVE
 * Description  : SCP OPT ENG 엔진 Scheduled Move(선적 이동) 입력데이터 생성
 *                (SCP Shipment Plan FG/Semi 또는 SSP(SCM_DNM_SSP_PLAN_V) -> Scheduled Move 변환,
 *                 DEMAND 기반 PROJECT_CODE 보정, 셀 생산지 버퍼 반영, 전진검사 A TYPE 적용, 2nd OCV STAGE 변경)
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2025.02.14    Taehyun        Initial Release
 * 2025.11.24    Minyong Lee    Lookup -> UI 전환 (Packing Equipment)
 * 2025.12.15    jongykim2      Demand Group Master 적용
 * 2026.07.30    ZIONEX         [PJ202650304]  NextSCM Migration
 *                              (As-Is 시그니처에 TVP 없음(스칼라 5개) : 원본 CREATE PROCEDURE 실측 -> Oracle 스칼라 5개 그대로.
 *                                 #PACKING_EQUIPMENT -> GT_OPT_ENG_SCHMOV_PKGEQP    (신규. 적재만 하고 활성 참조 없음 = 원본 死코드, 그대로 보존)
 *                               상위 RUN_MAIN 이 호출하는 하위 단계이므로 내부 COMMIT 신설 없음(부모 트랜잭션 소유).
 *                                 있는 결합식은 CASE 로 감싸 전파를 재현한다(FROM_BUFFER_ID / TO_BUFFER_ID / TO_STAGE /
 *                                 TO_STAGE_SEMI / 2nd OCV FROM_BUFFER_ID). 미적용 시 TO_BUFFER_ID IS NOT NULL 필터를 통과해
 *                                 ★원본 quirk 보존 : @V_SHIP_FROZEN 조회는 SEGMENT3 = @V_SCP_PLAN_TYPE 인데 이 시점
 *                               UPDATE ... FROM JOIN 3건(PROJECT_CODE 보정 / 전진검사 DELETE 마킹 / 2nd OCV STAGE 변경)은
 *                                 Oracle 미지원 -> 상관 UPDATE + EXISTS 로 변환. 다중매칭 시 원본은 임의행 선택(비결정적)이므로
 *                                 @SM_TEMP 19키 자가조인은 SHIPPING_ORDER_ID 가 행마다 유일해 자기 자신만 매칭한다.
 *                                 순효과 = 대상행 재식별 + NULL 키 행 갱신 제외 이므로, ISNULL 로 감싸지 않은 17키에
 *                                 CASE WHEN PROJECT_CODE IS NULL THEN '' ... 로 옮긴다.
 *                               DATEADD(DD, ISNULL(B.LT_TOTAL,0), CONVERT(DATETIME, YYYYMMDD)) -> TO_CHAR(TO_DATE(...)+NVL(...,0))
 * ============================================================ */
AS
    /* 2025.02.14 Taehyun Initial Release */
    /* ------------------------------------------------------------------ */
    /* Set Param for Log                                                   */
    /* ------------------------------------------------------------------ */
    V_PROGRAM_NAME       VARCHAR2(150 CHAR) := 'PR_SCP_OPT_ENG_INPUT_SCHEDULED_MOVE';
    V_PLAN_ID            VARCHAR2(50 CHAR)  := P_PLAN_ID;
    V_MESSAGE_TEXT       VARCHAR2(1000 CHAR);
    /* ------------------------------------------------------------------ */
    /* Set Param for Biz                                                   */
    /* ------------------------------------------------------------------ */
    V_DETAIL_DATE        DATE;
    V_SHIP_FROZEN        NUMBER(10);   /* @V_SHIP_FROZEN INT (死변수 : 주석처리된 원 로직에서만 사용, 원본 보존) */
    V_MAX_NUM            NUMBER(10);
    V_SCP_PLAN_DATE      VARCHAR2(8 CHAR);
    V_SCP_PLAN_TYPE      VARCHAR2(8 CHAR);
    V_SCP_PLAN_SEQ       VARCHAR2(8 CHAR);
    V_FRZ_START_DATE     VARCHAR2(8 CHAR);
    V_FRZ_END_DATE       VARCHAR2(8 CHAR);
    V_SYS_DIVS_CD        VARCHAR2(8 CHAR);
BEGIN
    /* ------------------------------------------------------------------ */
    /* Procedure 기본조건.
         SET TRANSACTION ISOLATION LEVEL READ COMMITTED;   Oracle 기본 격리수준이 READ COMMITTED */
    /* ------------------------------------------------------------------ */

    /* ------------------------------------------------------------------ */
    /* Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성                     */
    /* ------------------------------------------------------------------ */
    PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'START',NULL,NULL,NULL,V_PLAN_ID);

    /* ------------------------------------------------------------------ */
    /* Transaction (START)                                                 */
    /*   BEGIN TRANSACTION SCP_OPT_ENG_RUN_MAIN_PROC;                      */
    /* ------------------------------------------------------------------ */
    BEGIN
        /* ------------------------------------------------------------------ */
        /* Data Insert Start                                                   */
        /* ------------------------------------------------------------------ */

        DELETE
          FROM GT_OPT_ENG_SCHMOV_DM;

        DELETE
          FROM GT_OPT_ENG_SCHMOV_SM;

        DELETE
          FROM GT_OPT_ENG_SCHMOV_CELLPROD;

        DELETE
          FROM GT_OPT_ENG_SCHMOV_PKGEQP;

        DELETE
          FROM GT_OPT_ENG_SCHMOV_DMGRP;

        /* PR_SCP_OPT_ENG_INPUT_BOD 에서도 사용
           원본 quirk 보존 : 이 시점 V_SCP_PLAN_TYPE 는 아직 NULL(FROZEN_MASTER 조회 전) -> 항상 무행 -> V_SHIP_FROZEN 은 死변수 */
        BEGIN
            SELECT SEGMENT4
              INTO V_SHIP_FROZEN
              FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LV
             WHERE LOOKUP_TYPE = 'SCP_OPT_SHIP_FROZEN'
               AND VALID_YN    = 'Y'
               AND SEGMENT1    = V_DIVISION_ID
               AND SEGMENT2    = V_GROUP_ID
               /* AND     SEGMENT3    = 'PR' --임시 */
               AND SEGMENT3    = V_SCP_PLAN_TYPE;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN V_SHIP_FROZEN := NULL;
            WHEN TOO_MANY_ROWS THEN V_SHIP_FROZEN := NULL;
        END;

        /* ------------------------------------------------------------------ */
        /* 셀 생산지 버퍼 추가                                                  */
        /* ------------------------------------------------------------------ */
        INSERT
          INTO GT_OPT_ENG_SCHMOV_CELLPROD
             ( SALES_SITE_ID
             , ITEM_ID )
        SELECT SEGMENT3  AS SALES_SITE_ID
             , SEGMENT4  AS ITEM_ID
          FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CELL_PROD_SITE'
           AND SEGMENT1    = V_DIVISION_ID
           AND SEGMENT2    = V_GROUP_ID;

        /* ------------------------------------------------------------------ */
        /* 2025.06.20 김태현 : FROZEN 정보 확인                                 */
        /* ------------------------------------------------------------------ */
        BEGIN
            SELECT PLAN_YYYYMMDD
                 , PLAN_TYPE
                 , PLAN_SEQ
                 , FROZEN_START_DATE
                 , FROZEN_END_DATE
                 , SYS_DIVS_CD
              INTO V_SCP_PLAN_DATE
                 , V_SCP_PLAN_TYPE
                 , V_SCP_PLAN_SEQ
                 , V_FRZ_START_DATE
                 , V_FRZ_END_DATE
                 , V_SYS_DIVS_CD
              FROM SCP_OPT_ENG_FROZEN_MASTER_SN
             WHERE 1 = 1
               AND PLAN_ID     = V_PLAN_ID
               AND DIVISION_ID = V_DIVISION_ID
               AND FROZEN_TYPE = 'SHIP';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
            WHEN TOO_MANY_ROWS THEN NULL;
        END;

        /* ------------------------------------------------------------------ */
        /* 2025.05.20 Philsu Park: Packing Equipment Temp 생성.                */
        /* ------------------------------------------------------------------ */
        /*             BEGIN
                 DROP TABLE  #PACKING_EQUIPMENT;
             END; */

        /* Model 별 Input: Model GROUP 단위로 동일 MIN, MAX 적용.
           2025.05.28 Philsu Park: TO_DATE 는 하루 더해줌.
           2025.07.24 Philsu Park: Plan Horizon 내에 해당하는 PACKING EQP 정보만 추출. */
        INSERT
          INTO GT_OPT_ENG_SCHMOV_PKGEQP
             ( DIVISION
             , PLAN_GROUP
             , MODEL
             , MODEL_GROUP
             , FROM_SITE
             , STAGE
             , TO_SITE
             , FROM_DATE
             , TO_DATE
             , LOWER_QTY
             , UPPER_QTY )
        WITH MODEL_GROUP AS (
             /*   SELECT    SEGMENT2                                  AS DIVISION
                        , SEGMENT3                                  AS PLAN_GROUP
                        , SEGMENT5                                  AS MODEL_GROUP
                        , GREATEST(@V_PLAN_START_YYYYMMDD, MIN(ATTRIBUTE4))                           AS FROM_DATE
                        , LEAST(@V_PLAN_END_YYYYMMDD, CONVERT(NVARCHAR, DATEADD(DAY, 1, CONVERT(DATE, MAX(ATTRIBUTE5), 112)), 112)) AS TO_DATE
                        , MIN(CONVERT(NUMERIC(20,10), ATTRIBUTE6))  AS LOWER_QTY
                        , MAX(CONVERT(NUMERIC(20,10), ATTRIBUTE7))  AS UPPER_QTY
                  FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
                  WHERE   D.LOOKUP_TYPE   = 'SCP_OPT_ENG_CONST_PACKING_EQUIPMENT'
                  AND     D.VALID_YN      = 'Y'  -- ***!!!Valid Flag는 나중에 살려야됨!!!***
                  AND     D.SEGMENT2      = @V_DIVISION_ID
                  AND     D.SEGMENT3      = @V_GROUP_ID
                  GROUP BY SEGMENT2, SEGMENT3, SEGMENT5 */

             /* 2025.11.24 Minyong Lee : Lookup -> UI 전환 (Packing Equipment) */
             SELECT CS.DIVISION_ID                                   AS DIVISION
                  , PG.OPMZ_PLAN_GR_NAME                             AS PLAN_GROUP
                  , CS.MDL_GR_NM                                     AS MODEL_GROUP
                  , CASE WHEN V_PLAN_START_YYYYMMDD IS NULL   THEN MIN(CS.FROM_YYYYMMDD)
                         WHEN MIN(CS.FROM_YYYYMMDD) IS NULL   THEN V_PLAN_START_YYYYMMDD
                         ELSE GREATEST(V_PLAN_START_YYYYMMDD, MIN(CS.FROM_YYYYMMDD))
                    END                                              AS FROM_DATE
                  , CASE WHEN V_PLAN_END_YYYYMMDD IS NULL                                               THEN TO_CHAR(TO_DATE(MAX(CS.TO_YYYYMMDD),'YYYYMMDD') + 1,'YYYYMMDD')
                         WHEN TO_CHAR(TO_DATE(MAX(CS.TO_YYYYMMDD),'YYYYMMDD') + 1,'YYYYMMDD') IS NULL   THEN V_PLAN_END_YYYYMMDD
                         ELSE LEAST(V_PLAN_END_YYYYMMDD, TO_CHAR(TO_DATE(MAX(CS.TO_YYYYMMDD),'YYYYMMDD') + 1,'YYYYMMDD'))
                    END                                              AS TO_DATE
                  , MIN(CAST(CS.SIPM_MIN_QYT AS NUMBER(20,10)))      AS LOWER_QTY
                  , MAX(CAST(CS.SIPM_MAX_QTY AS NUMBER(20,10)))      AS UPPER_QTY
               FROM SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY CS
                  , SCP_OPMZ_PLAN_GR_M                  PG
              WHERE CS.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID(+)
                AND PG.VALID_YN(+)     = 'Y'
                AND 1 = 1
                AND CS.VALID_YN          = 'Y'
                AND CS.DIVISION_ID       = V_DIVISION_ID
                AND PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
              GROUP BY CS.DIVISION_ID, PG.OPMZ_PLAN_GR_NAME, CS.MDL_GR_NM
             )
        /* 동일 모델 여러줄 나오는 경우가 있어 DISTINCT 처리.
           SELECT    DISTINCT
                     D.SEGMENT2                                  AS DIVISION
                   , D.SEGMENT3                                  AS PLAN_GROUP
                   , D.SEGMENT4                                  AS MODEL
                   , D.SEGMENT5                                  AS MODEL_GROUP
                   , D.ATTRIBUTE1                                AS FROM_SITE
                   , D.ATTRIBUTE2                                AS STAGE
                   , D.ATTRIBUTE3                                AS TO_SITE
                   , GRP.FROM_DATE                               AS FROM_DATE
                   , GRP.TO_DATE                                 AS TO_DATE
                   , GRP.LOWER_QTY                               AS LOWER_QTY
                   , GRP.UPPER_QTY                               AS UPPER_QTY
           INTO    #PACKING_EQUIPMENT
           FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
           INNER JOIN MODEL_GROUP GRP
               ON  GRP.DIVISION    = D.SEGMENT2
               AND GRP.PLAN_GROUP  = D.SEGMENT3
               AND GRP.MODEL_GROUP = D.SEGMENT5
           WHERE   D.LOOKUP_TYPE   = 'SCP_OPT_ENG_CONST_PACKING_EQUIPMENT'
           AND     D.VALID_YN      = 'Y'
           AND     D.SEGMENT2      = @V_DIVISION_ID
           AND     D.SEGMENT3      = @V_GROUP_ID
           AND     GRP.FROM_DATE   < @V_PLAN_END_YYYYMMDD
           AND     GRP.TO_DATE    >= @V_PLAN_START_YYYYMMDD

           2025.11.24 Minyong Lee : Lookup -> UI 전환 (Packing Equipment) */
        SELECT DISTINCT
               CS.DIVISION_ID                       AS DIVISION
             , PG.OPMZ_PLAN_GR_NAME                 AS PLAN_GROUP
             , CS.ITEM_ID                           AS MODEL
             , CS.MDL_GR_NM                         AS MODEL_GROUP
             , CS.FROM_STE_ID                       AS FROM_SITE
             , CS.STAGE                             AS STAGE
             , CS.TO_STE_ID                         AS TO_SITE
             , GRP.FROM_DATE                        AS FROM_DATE
             , GRP.TO_DATE                          AS TO_DATE
             , GRP.LOWER_QTY                        AS LOWER_QTY
             , GRP.UPPER_QTY                        AS UPPER_QTY
          FROM SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY CS
             , SCP_OPMZ_PLAN_GR_M                   PG
             , MODEL_GROUP                          GRP
         WHERE CS.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID(+)
           AND PG.VALID_YN(+)     = 'Y'
           AND GRP.DIVISION       = CS.DIVISION_ID
           AND GRP.PLAN_GROUP     = PG.OPMZ_PLAN_GR_NAME
           AND GRP.MODEL_GROUP    = CS.MDL_GR_NM
           AND 1 = 1
           AND CS.VALID_YN          = 'Y'
           AND CS.DIVISION_ID       = V_DIVISION_ID
           AND PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
           AND GRP.FROM_DATE        < V_PLAN_END_YYYYMMDD
           AND GRP.TO_DATE         >= V_PLAN_START_YYYYMMDD;

        /* ------------------------------------------------------------------ */
        /* PROJECT CODE UPDATE 용도                                            */
        /* INCOTERMS가 있는 DM정보와, 없는 DM정보를 각각 가져옴 -> DUE DATE가 가장 빠른 날짜 기준 */
        /* ------------------------------------------------------------------ */
        INSERT
          INTO GT_OPT_ENG_SCHMOV_DM
             ( SITE_ID
             , ITEM_ID
             , INCOTERMS
             , PROJECT_CODE )
        SELECT SITE_ID
             , ITEM_ID
             , INCOTERMS
             , PROJECT_CODE
          FROM (SELECT SITE_ID
                     , ITEM_ID
                     , INCOTERMS
                     , PROJECT_CODE
                     , ROW_NUMBER() OVER( PARTITION BY SITE_ID,ITEM_ID,INCOTERMS,PROJECT_CODE ORDER BY MIN_DUE ) AS ROW_NUM
                  FROM (SELECT ATTRIBUTE1     AS SITE_ID
                             , ATTRIBUTE2     AS ITEM_ID
                             , ATTRIBUTE4     AS INCOTERMS
                             , ATTRIBUTE5     AS PROJECT_CODE
                             , MIN(DUE_DATE)  AS MIN_DUE
                          FROM SCP_OPT_ENG_DEMAND_SN
                         WHERE PLAN_ID    = V_PLAN_ID
                           AND ATTRIBUTE5 IS NOT NULL   /* PROJECT_CODE */
                           AND ATTRIBUTE4 IS NOT NULL   /* INCOTERMS */
                         GROUP BY ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE4,ATTRIBUTE5) DM) RM
         WHERE ROW_NUM = 1
        UNION ALL
        SELECT SITE_ID
             , ITEM_ID
             , INCOTERMS
             , PROJECT_CODE
          FROM (SELECT SITE_ID
                     , ITEM_ID
                     , INCOTERMS
                     , PROJECT_CODE
                     , ROW_NUMBER() OVER( PARTITION BY SITE_ID,ITEM_ID,PROJECT_CODE ORDER BY MIN_DUE ) AS ROW_NUM
                  FROM (SELECT ATTRIBUTE1     AS SITE_ID
                             , ATTRIBUTE2     AS ITEM_ID
                             , CAST(NULL AS VARCHAR2(150 CHAR)) AS INCOTERMS
                             , ATTRIBUTE5     AS PROJECT_CODE
                             , MIN(DUE_DATE)  AS MIN_DUE
                          FROM SCP_OPT_ENG_DEMAND_SN
                         WHERE PLAN_ID    = V_PLAN_ID
                           AND ATTRIBUTE5 IS NOT NULL
                           AND ATTRIBUTE4 IS NULL
                         GROUP BY ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE5) DM) RM
         WHERE ROW_NUM = 1;

        /* ------------------------------------------------------------------ */
        /* 임시 적용 : W07 Final Plan 정보 : START                             */
        /* ------------------------------------------------------------------ */
        IF V_SYS_DIVS_CD = 'SCP' THEN
        INSERT
          INTO GT_OPT_ENG_SCHMOV_SM
             ( PLAN_ID
             , SHIPPING_ORDER_ID
             , FROM_BUFFER_ID
             , TO_BUFFER_ID
             , DEPARTURE_DATE
             , ARRIVAL_DATE
             , TRANSPORT_MODE
             , QTY
             , RESOURCE_ID
             , LOAD_PER
             , FROM_SITE
             , ITEM_ID
             , FROM_STAGE
             , TO_SITE
             , TO_STAGE_SEMI
             , FENCE_IN_OUT
             , BOD_ID
             , SITE_TYPE
             , INCOTERMS
             , PROJECT_CODE )
        SELECT V_PLAN_ID                             AS PLAN_ID
             , SHIPPING_ORDER_ID                     AS SHIPPING_ORDER_ID
               /* MSSQL 결합 + 의 NULL 전파 재현 : FROM_STAGE 는 ELSE 없는 CASE 산출이라 NULL 가능 */
             , CASE WHEN FROM_SITE IS NULL OR ITEM_ID IS NULL OR FROM_STAGE IS NULL THEN NULL
                    ELSE FROM_SITE||'::'||ITEM_ID||'::'||FROM_STAGE END              AS FROM_BUFFER_ID
               /* MSSQL 결합 + 의 NULL 전파 재현 : TO_STAGE 는 명시 THEN NULL 분기가 있어 NULL 가능 */
             , CASE WHEN TO_SITE IS NULL OR ITEM_ID IS NULL OR TO_STAGE IS NULL THEN NULL
                    ELSE TO_SITE||'::'||ITEM_ID||'::'||TO_STAGE END                  AS TO_BUFFER_ID
             , DEPARTURE_DATE                        AS DEPARTURE_DATE
             , ARRIVAL_DATE                          AS ARRIVAL_DATE
             , TRANSPORT_MODE                        AS TRANSPORT_MODE
             , QTY                                   AS QTY
             , NULL                                  AS RESOURCE_ID
             , NULL                                  AS LOAD_PER
             , FROM_SITE                             AS FROM_SITE
             , ITEM_ID                               AS ITEM_ID
             , FROM_STAGE                            AS FROM_STAGE
             , TO_SITE                               AS TO_SITE
             , TO_STAGE_SEMI                         AS TO_STAGE_SEMI
             , 'IN'                                  AS FENCE_IN_OUT   /* OUT DATA를 넣어줄 때 확정 구간 내에있는 데이터를 구분하기 위한 FLAG */
             , BOD_ID                                AS BOD_ID
             , SITE_TYPE                             AS SITE_TYPE
             , INCOTERMS                             AS INCOTERMS
             , PROJECT_CODE                          AS PROJECT_CODE
          FROM (SELECT ROW_NUMBER() OVER(ORDER BY ITEM_ID)  AS SHIPPING_ORDER_ID
                     , FROM_SITE       AS FROM_SITE
                     , TO_SITE         AS TO_SITE
                     , TRANSPORT_MODE  AS TRANSPORT_MODE
                     , ITEM_ID         AS ITEM_ID
                     , FROM_STAGE      AS FROM_STAGE
                     , TO_STAGE        AS TO_STAGE
                     , DEPARTURE_DATE  AS DEPARTURE_DATE
                     , ARRIVAL_DATE    AS ARRIVAL_DATE
                     , SUM(QTY)        AS QTY
                     , BOD_ID          AS BOD_ID
                     , SITE_TYPE       AS SITE_TYPE
                     , INCOTERMS       AS INCOTERMS
                     , TO_STAGE_SEMI   AS TO_STAGE_SEMI
                     , PROJECT_CODE    AS PROJECT_CODE
                  FROM (
                        /* Shipment Plan FG : Sales 향 */
                        SELECT NULL                            AS SHIPPING_ORDER_ID
                             , A.FROM_SITE                     AS FROM_SITE
                             , A.TO_SITE                       AS TO_SITE
                             , B.TRANSPORT_MODE                AS TRANSPORT_MODE
                             , A.ITEM_ID                       AS ITEM_ID
                             , B.BOD_ID                        AS BOD_ID
                             , TS.SITE_TYPE                    AS SITE_TYPE
                             , B.INCOTERMS                     AS INCOTERMS
                               /* , 'CHAR'      AS FROM_STAGE
                                  , 'CELL BIZ'  AS TO_STAGE */
                             , CASE WHEN FS.OPERATION_GROUP = 'A'                                                          THEN 'CHAR'     /* CELL PLANT 출발 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P9500'                                 THEN 'PACK'     /* PACK PLANT 출발 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P5500'                                 THEN 'MDLE'     /* PACK PLANT 출발 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID NOT IN ('P5500', 'P9500')                 THEN 'SUBMDLE'  /* PACK PLANT 출발 */
                               END                             AS FROM_STAGE

                             , CASE WHEN FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'SALES'                                                       THEN CASE WHEN B.INCOTERMS IS NULL THEN NULL ELSE 'CELLBIZ' || '@' || B.INCOTERMS END     /* CELL PLANT 출발 -> SALES 도착 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P9500'                              THEN CASE WHEN B.INCOTERMS IS NULL THEN NULL ELSE 'PACKBIZ' || '@' || B.INCOTERMS END     /* PACK PLANT 출발 -> SALES 도착 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P5500'                              THEN CASE WHEN B.INCOTERMS IS NULL THEN NULL ELSE 'MDLEBIZ' || '@' || B.INCOTERMS END     /* PACK PLANT 출발 -> SALES 도착 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID NOT IN ('P5500', 'P9500')              THEN CASE WHEN B.INCOTERMS IS NULL THEN NULL ELSE 'SUBMDLEBIZ' || '@' || B.INCOTERMS END  /* PACK PLANT 출발 -> SALES 도착 */
                                    WHEN A.DIVISION_ID = '40'  AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT'                             THEN NULL       /* 소형은 CEll Biz 용 Demand - CELL PLANT 출발 -> PLANT 도착 : To Buffer ID 도 NULL 됨 */
                                    WHEN A.DIVISION_ID <> '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT'                             THEN 'CHAR'     /* CELL PLANT 출발 -> PLANT 도착 */
                                    WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P9500'                              THEN 'PACK'     /* PACK PLANT 출발 -> PLANT 도착 */
                                    WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P5500'                              THEN 'MDLE'     /* PACK PLANT 출발 -> PLANT 도착 */
                                    WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID NOT IN ('P5500', 'P9500')              THEN 'SUBMDLE'  /* PACK PLANT 출발 -> PLANT 도착 */
                               END                             AS TO_STAGE
                             , CASE WHEN FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'SALES'                                                       THEN 'CELLBIZ'     /* INCOTERMS 제거 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P9500'                              THEN 'PACKBIZ'     /* INCOTERMS 제거 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P5500'                              THEN 'MDLEBIZ'     /* INCOTERMS 제거 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID NOT IN ('P5500', 'P9500')              THEN 'SUBMDLEBIZ'  /* INCOTERMS 제거 */
                                    WHEN A.DIVISION_ID = '40'  AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT'                             THEN NULL          /* 소형은 CEll Biz 용 Demand - CELL PLANT 출발 -> PLANT 도착 : To Buffer ID 도 NULL 됨 */
                                    WHEN A.DIVISION_ID <> '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT'                             THEN 'CHAR'        /* CELL PLANT 출발 -> PLANT 도착 */
                                    WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P9500'                              THEN 'PACK'        /* PACK PLANT 출발 -> PLANT 도착 */
                                    WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P5500'                              THEN 'MDLE'        /* PACK PLANT 출발 -> PLANT 도착 */
                                    WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID NOT IN ('P5500', 'P9500')              THEN 'SUBMDLE'     /* PACK PLANT 출발 -> PLANT 도착 */
                               END                             AS TO_STAGE_SEMI   /* ATTRIBUTE 저장을 위한 INCOTERMS제거 */
                             , A.YYYYMMDD                      AS DEPARTURE_DATE
                             , TO_CHAR(TO_DATE(A.YYYYMMDD,'YYYYMMDD') + NVL(B.LT_TOTAL, 0), 'YYYYMMDD')  AS ARRIVAL_DATE
                             , A.QTY
                             , A.PROJECT_CODE
                          FROM SCP_ANL_SHIPMENT_PLAN_FG A
                             , SCP_MST_BOD_N_V B
                             , SCM_MST_SITE FS
                             , SCM_MST_SITE TS
                             , (SELECT DISTINCT DIVISION_ID
                                     , ITEM_ID
                                     , OPERATION_GROUP
                                     , FLOW_ID
                                     , ATTRIBUTE8
                                  FROM SCP_MST_FINAL_ITEM
                                 WHERE DIVISION_ID     = V_DIVISION_ID   /* @P_DIVISION_ID */
                                   AND OPERATION_GROUP IN ('A', 'P')) FI
                         WHERE B.DIVISION_ID    = A.DIVISION_ID
                           AND B.BOD_ID         = A.BOD_ID
                           AND B.FROM_YYYYMMDD <= A.YYYYMMDD   /* 유효한 기간의 BOD */
                           AND B.TO_YYYYMMDD   >= A.YYYYMMDD   /* 유효한 기간의 BOD */
                           AND A.DIVISION_ID    = FS.DIVISION_ID
                           AND A.FROM_SITE      = FS.SCM_SITE_ID
                               /* AND FS.SITE_TYPE      = 'PLANT' */
                           AND FS.VALID_YN      = 'Y'
                           AND ((FS.DIVISION_ID  = '40' AND FS.OPERATION_GROUP IN ('A') )   /* 소형은 CEll Biz 용 Demand 만 처리 */
                                OR (FS.DIVISION_ID <> '40' AND FS.OPERATION_GROUP IN ('A', 'P') ))
                           AND A.DIVISION_ID    = TS.DIVISION_ID
                           AND A.TO_SITE        = TS.SCM_SITE_ID
                               /* AND TS.SITE_TYPE      = 'SALES' */
                           AND TS.VALID_YN      = 'Y'
                           AND A.ITEM_ID        = FI.ITEM_ID(+)
                           AND A.DIVISION_ID    = FI.DIVISION_ID(+)
                           AND A.DIVISION_ID         = V_DIVISION_ID
                           AND A.PLAN_START_YYYYMMDD = V_SCP_PLAN_DATE
                               /* AND   A.plan_type           = 'PR'  --임시 */
                           AND A.PLAN_TYPE           = V_SCP_PLAN_TYPE
                           AND A.SEQ                 = V_SCP_PLAN_SEQ
                           AND A.MEASURE             = 'SHIP_PLAN_AMEND'
                           AND A.QTY                 > 0
                           AND A.YYYYMMDD           >= V_FRZ_START_DATE
                           AND A.YYYYMMDD            < V_FRZ_END_DATE
                           AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                               FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                              WHERE PLAN_ID = V_PLAN_ID)
                        /* Shipment Plan Semi : Plant 향
                           2025.06.13 Philsu Park: From Plant = To Plant 인 케이스는 생성 제외.(남혁 선임님 요청) */
                        UNION ALL
                        SELECT NULL                            AS SHIPPING_ORDER_ID
                             , A.FROM_SITE                     AS FROM_SITE
                             , A.TO_SITE                       AS TO_SITE
                             , B.TRANSPORT_MODE                AS TRANSPORT_MODE
                             , A.ITEM_ID                       AS ITEM_ID
                             , B.BOD_ID                        AS BOD_ID
                             , TS.SITE_TYPE                    AS SITE_TYPE
                             , B.INCOTERMS                     AS INCOTERMS
                               /* , 'CHAR'      AS FROM_STAGE
                                  , 'CELL BIZ'  AS TO_STAGE */
                             , CASE WHEN FS.OPERATION_GROUP = 'A'                                                          THEN 'CHAR'     /* CELL PLANT 출발 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P9500'                                 THEN 'PACK'     /* PACK PLANT 출발 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P5500'                                 THEN 'MDLE'     /* PACK PLANT 출발 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID NOT IN ('P5500', 'P9500')                 THEN 'SUBMDLE'  /* PACK PLANT 출발 */
                               END                             AS FROM_STAGE
                             , CASE WHEN FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'SALES'                                                       THEN CASE WHEN B.INCOTERMS IS NULL THEN NULL ELSE 'CELLBIZ' || '@' || B.INCOTERMS END     /* CELL PLANT 출발 -> SALES 도착 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P9500'                              THEN CASE WHEN B.INCOTERMS IS NULL THEN NULL ELSE 'PACKBIZ' || '@' || B.INCOTERMS END     /* PACK PLANT 출발 -> SALES 도착 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P5500'                              THEN CASE WHEN B.INCOTERMS IS NULL THEN NULL ELSE 'MDLEBIZ' || '@' || B.INCOTERMS END     /* PACK PLANT 출발 -> SALES 도착 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID NOT IN ('P5500', 'P9500')              THEN CASE WHEN B.INCOTERMS IS NULL THEN NULL ELSE 'SUBMDLEBIZ' || '@' || B.INCOTERMS END  /* PACK PLANT 출발 -> SALES 도착 */
                                    WHEN A.DIVISION_ID  = '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT'                             THEN NULL       /* 소형은 CEll Biz 용 Demand - CELL PLANT 출발 -> PLANT 도착 : To Buffer ID 도 NULL 됨 */
                                    WHEN A.DIVISION_ID <> '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT'                             THEN 'CHAR'     /* CELL PLANT 출발 -> PLANT 도착 */
                                    WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P9500'                              THEN 'PACK'     /* PACK PLANT 출발 -> PLANT 도착 */
                                    WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P5500'                              THEN 'MDLE'     /* PACK PLANT 출발 -> PLANT 도착 */
                                    WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID NOT IN ('P5500', 'P9500')              THEN 'SUBMDLE'  /* PACK PLANT 출발 -> PLANT 도착 */
                               END                             AS TO_STAGE
                             , CASE WHEN FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'SALES'                                                       THEN 'CELLBIZ'     /* INCOTERMS 제거 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P9500'                              THEN 'PACKBIZ'     /* INCOTERMS 제거 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P5500'                              THEN 'MDLEBIZ'     /* INCOTERMS 제거 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID NOT IN ('P5500', 'P9500')              THEN 'SUBMDLEBIZ'  /* INCOTERMS 제거 */
                                    WHEN A.DIVISION_ID  = '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT'                             THEN NULL          /* 소형은 CEll Biz 용 Demand - CELL PLANT 출발 -> PLANT 도착 : To Buffer ID 도 NULL 됨 */
                                    WHEN A.DIVISION_ID <> '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT'                             THEN 'CHAR'        /* CELL PLANT 출발 -> PLANT 도착 */
                                    WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P9500'                              THEN 'PACK'        /* PACK PLANT 출발 -> PLANT 도착 */
                                    WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P5500'                              THEN 'MDLE'        /* PACK PLANT 출발 -> PLANT 도착 */
                                    WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID NOT IN ('P5500', 'P9500')              THEN 'SUBMDLE'     /* PACK PLANT 출발 -> PLANT 도착 */
                               END                             AS TO_STAGE_SEMI   /* ATTRIBUTE 저장을 위해 INCOTERMS제거 */
                             , A.YYYYMMDD                      AS DEPARTURE_DATE
                               /* ,CONVERT(CHAR(8), DATEADD(DD, ISNULL(B.LT_TOTAL, 0), CONVERT(DATETIME, A.YYYYMMDD)), 112)  AS ARRIVAL_DATE */
                             , CASE WHEN A.DIVISION_ID  = '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT'
                                         THEN A.YYYYMMDD   /* 소형 CEll Biz 용 Demand : 소형 CEll Req 용은 LT 0 */
                                    ELSE TO_CHAR(TO_DATE(A.YYYYMMDD,'YYYYMMDD') + NVL(B.LT_TOTAL, 0), 'YYYYMMDD')
                               END                             AS ARRIVAL_DATE
                             , A.QTY
                             , ''                              AS PROJECT_CODE   /* UNION을 위한 값이며, 실제로 BUFFER_ID에 넣진 않음. */
                          FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
                             , SCP_MST_BOD_N_V B
                             , SCM_MST_SITE FS
                             , SCM_MST_SITE TS
                             , (SELECT DISTINCT DIVISION_ID
                                     , ITEM_ID
                                     , OPERATION_GROUP
                                     , FLOW_ID
                                     , ATTRIBUTE8
                                  FROM SCP_MST_FINAL_ITEM
                                 WHERE DIVISION_ID     = V_DIVISION_ID   /* @P_DIVISION_ID */
                                   AND OPERATION_GROUP IN ('A', 'P')) FI
                         WHERE B.DIVISION_ID    = A.DIVISION_ID
                           AND B.BOD_ID         = A.BOD_ID
                           AND B.FROM_YYYYMMDD <= A.YYYYMMDD   /* 유효한 기간의 BOD */
                           AND B.TO_YYYYMMDD   >= A.YYYYMMDD   /* 유효한 기간의 BOD */
                           AND A.DIVISION_ID    = FS.DIVISION_ID
                           AND A.FROM_SITE      = FS.SCM_SITE_ID
                               /* AND FS.SITE_TYPE      = 'PLANT' */
                           AND FS.VALID_YN      = 'Y'
                           AND V_DIVISION_ID   <> '40'   /* 소형 CEll Biz 용 Demand 만 처리 : 소형 Cell -> Pack 제외 */
                               /* AND ((FS.DIVISION_ID  = '40' AND FS.OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
                                    OR  (FS.DIVISION_ID <> '40' AND FS.OPERATION_GROUP IN ('A', 'P') )
                                    ) */
                           AND A.DIVISION_ID    = TS.DIVISION_ID
                           AND A.TO_SITE        = TS.SCM_SITE_ID
                               /* AND TS.SITE_TYPE      = 'SALES' */
                           AND TS.VALID_YN      = 'Y'
                           AND A.ITEM_ID        = FI.ITEM_ID(+)
                           AND A.DIVISION_ID    = FI.DIVISION_ID(+)
                           AND A.DIVISION_ID         = V_DIVISION_ID
                           AND A.PLAN_START_YYYYMMDD = V_SCP_PLAN_DATE
                               /* AND   A.plan_type           = 'PR' --임시 */
                           AND A.PLAN_TYPE           = V_SCP_PLAN_TYPE
                           AND A.SEQ                 = V_SCP_PLAN_SEQ
                           AND A.MEASURE             = 'SHIP_PLAN_AMEND'
                           AND A.QTY                 > 0
                           AND A.YYYYMMDD           >= V_FRZ_START_DATE
                           AND A.YYYYMMDD            < V_FRZ_END_DATE
                           AND NVL(FS.PLANT_ID, ' ') != NVL(TS.PLANT_ID, ' ')
                           AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                               FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                              WHERE PLAN_ID = V_PLAN_ID)) AA
                 GROUP BY SHIPPING_ORDER_ID, FROM_SITE, TO_SITE, TRANSPORT_MODE, ITEM_ID, FROM_STAGE, TO_STAGE, DEPARTURE_DATE, ARRIVAL_DATE, BOD_ID, SITE_TYPE, INCOTERMS,TO_STAGE_SEMI,PROJECT_CODE) A;
        END IF;

        IF V_SYS_DIVS_CD = 'SSP' THEN
        INSERT
          INTO GT_OPT_ENG_SCHMOV_SM
             ( PLAN_ID
             , SHIPPING_ORDER_ID
             , FROM_BUFFER_ID
             , TO_BUFFER_ID
             , DEPARTURE_DATE
             , ARRIVAL_DATE
             , TRANSPORT_MODE
             , QTY
             , RESOURCE_ID
             , LOAD_PER
             , FROM_SITE
             , ITEM_ID
             , FROM_STAGE
             , TO_SITE
             , TO_STAGE_SEMI
             , FENCE_IN_OUT
             , BOD_ID
             , SITE_TYPE
             , INCOTERMS
             , PROJECT_CODE )
        SELECT V_PLAN_ID                             AS PLAN_ID
             , SHIPPING_ORDER_ID                     AS SHIPPING_ORDER_ID
               /* MSSQL 결합 + 의 NULL 전파 재현 : FROM_STAGE 는 ELSE 없는 CASE 산출이라 NULL 가능 */
             , CASE WHEN FROM_SITE IS NULL OR ITEM_ID IS NULL OR FROM_STAGE IS NULL THEN NULL
                    ELSE FROM_SITE||'::'||ITEM_ID||'::'||FROM_STAGE END              AS FROM_BUFFER_ID
               /* MSSQL 결합 + 의 NULL 전파 재현 : TO_STAGE 는 명시 THEN NULL 분기가 있어 NULL 가능 */
             , CASE WHEN TO_SITE IS NULL OR ITEM_ID IS NULL OR TO_STAGE IS NULL THEN NULL
                    ELSE TO_SITE||'::'||ITEM_ID||'::'||TO_STAGE END                  AS TO_BUFFER_ID
             , DEPARTURE_DATE                        AS DEPARTURE_DATE
             , ARRIVAL_DATE                          AS ARRIVAL_DATE
             , TRANSPORT_MODE                        AS TRANSPORT_MODE
             , QTY                                   AS QTY
             , NULL                                  AS RESOURCE_ID
             , NULL                                  AS LOAD_PER
             , FROM_SITE                             AS FROM_SITE
             , ITEM_ID                               AS ITEM_ID
             , FROM_STAGE                            AS FROM_STAGE
             , TO_SITE                               AS TO_SITE
             , TO_STAGE_SEMI                         AS TO_STAGE_SEMI
             , 'IN'                                  AS FENCE_IN_OUT   /* OUT DATA를 넣어줄 때 확정 구간 내에있는 데이터를 구분하기 위한 FLAG */
             , BOD_ID                                AS BOD_ID
             , SITE_TYPE                             AS SITE_TYPE
             , INCOTERMS                             AS INCOTERMS
             , PROJECT_CODE                          AS PROJECT_CODE
          FROM (SELECT ROW_NUMBER() OVER(ORDER BY ITEM_ID)  AS SHIPPING_ORDER_ID
                     , FROM_SITE       AS FROM_SITE
                     , TO_SITE         AS TO_SITE
                     , TRANSPORT_MODE  AS TRANSPORT_MODE
                     , ITEM_ID         AS ITEM_ID
                     , FROM_STAGE      AS FROM_STAGE
                     , TO_STAGE        AS TO_STAGE
                     , DEPARTURE_DATE  AS DEPARTURE_DATE
                     , ARRIVAL_DATE    AS ARRIVAL_DATE
                     , SUM(QTY)        AS QTY
                     , BOD_ID          AS BOD_ID
                     , SITE_TYPE       AS SITE_TYPE
                     , INCOTERMS       AS INCOTERMS
                     , TO_STAGE_SEMI   AS TO_STAGE_SEMI
                     , PROJECT_CODE    AS PROJECT_CODE
                  FROM (SELECT NULL                            AS SHIPPING_ORDER_ID
                             , SSP.FROM_SITE                   AS FROM_SITE
                             , SSP.TO_SITE                     AS TO_SITE
                             , B.TRANSPORT_MODE                AS TRANSPORT_MODE
                             , SSP.ITEM_ID                     AS ITEM_ID
                             , B.BOD_ID                        AS BOD_ID
                             , TS.SITE_TYPE                    AS SITE_TYPE
                             , B.INCOTERMS                     AS INCOTERMS
                               /* , 'CHAR'      AS FROM_STAGE
                                  , 'CELL BIZ'  AS TO_STAGE */
                             , CASE WHEN FS.OPERATION_GROUP = 'A'                                                          THEN 'CHAR'     /* CELL PLANT 출발 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P9500'                                 THEN 'PACK'     /* PACK PLANT 출발 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P5500'                                 THEN 'MDLE'     /* PACK PLANT 출발 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID NOT IN ('P5500', 'P9500')                 THEN 'SUBMDLE'  /* PACK PLANT 출발 */
                               END                             AS FROM_STAGE
                             , CASE WHEN FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'SALES'                                                       THEN CASE WHEN B.INCOTERMS IS NULL THEN NULL ELSE 'CELLBIZ' || '@' || B.INCOTERMS END     /* CELL PLANT 출발 -> SALES 도착 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P9500'                              THEN CASE WHEN B.INCOTERMS IS NULL THEN NULL ELSE 'PACKBIZ' || '@' || B.INCOTERMS END     /* PACK PLANT 출발 -> SALES 도착 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P5500'                              THEN CASE WHEN B.INCOTERMS IS NULL THEN NULL ELSE 'MDLEBIZ' || '@' || B.INCOTERMS END     /* PACK PLANT 출발 -> SALES 도착 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID NOT IN ('P5500', 'P9500')              THEN CASE WHEN B.INCOTERMS IS NULL THEN NULL ELSE 'SUBMDLEBIZ' || '@' || B.INCOTERMS END  /* PACK PLANT 출발 -> SALES 도착 */
                                    WHEN SSP.DIVISION_ID = '40'  AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT'                           THEN NULL       /* 소형은 CEll Biz 용 Demand - CELL PLANT 출발 -> PLANT 도착 : To Buffer ID 도 NULL 됨 */
                                    WHEN SSP.DIVISION_ID <> '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT'                           THEN 'CHAR'     /* CELL PLANT 출발 -> PLANT 도착 */
                                    WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P9500'                              THEN 'PACK'     /* PACK PLANT 출발 -> PLANT 도착 */
                                    WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P5500'                              THEN 'MDLE'     /* PACK PLANT 출발 -> PLANT 도착 */
                                    WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID NOT IN ('P5500', 'P9500')              THEN 'SUBMDLE'  /* PACK PLANT 출발 -> PLANT 도착 */
                               END                             AS TO_STAGE
                             , CASE WHEN FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'SALES'                                                       THEN 'CELLBIZ'     /* INCOTERMS 제거 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P9500'                              THEN 'PACKBIZ'     /* INCOTERMS 제거 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P5500'                              THEN 'MDLEBIZ'     /* INCOTERMS 제거 */
                                    WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID NOT IN ('P5500', 'P9500')              THEN 'SUBMDLEBIZ'  /* INCOTERMS 제거 */
                                    WHEN SSP.DIVISION_ID = '40'  AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT'                           THEN NULL          /* 소형은 CEll Biz 용 Demand - CELL PLANT 출발 -> PLANT 도착 : To Buffer ID 도 NULL 됨 */
                                    WHEN SSP.DIVISION_ID <> '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT'                           THEN 'CHAR'        /* CELL PLANT 출발 -> PLANT 도착 */
                                    WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P9500'                              THEN 'PACK'        /* PACK PLANT 출발 -> PLANT 도착 */
                                    WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P5500'                              THEN 'MDLE'        /* PACK PLANT 출발 -> PLANT 도착 */
                                    WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID NOT IN ('P5500', 'P9500')              THEN 'SUBMDLE'     /* PACK PLANT 출발 -> PLANT 도착 */
                               END                             AS TO_STAGE_SEMI   /* ATTRIBUTE 저장을 위한 INCOTERMS제거 */
                             , SSP.YYYYMMDD                    AS DEPARTURE_DATE
                             , TO_CHAR(TO_DATE(SSP.YYYYMMDD,'YYYYMMDD') + NVL(B.LT_TOTAL, 0), 'YYYYMMDD')  AS ARRIVAL_DATE
                             , SSP.QTY
                             , SSP.PROJECT_CODE
                          FROM SCM_DNM_SSP_PLAN_V SSP
                             , (SELECT DIVISION_ID
                                     , SCM_SITE_ID
                                     , TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD,'YYYYMMDD') + NVL(MAX(SHIP_FROZEN),0),'YYYYMMDD') AS SSP_CONFIRM_DATE
                                  FROM SCM_MST_SITE
                                 WHERE DIVISION_ID = V_DIVISION_ID
                                 GROUP BY DIVISION_ID, SCM_SITE_ID) SMS
                             , SCP_MST_BOD_N_V B
                               /* 속도 개선을 위해 UNION ALL로 변경 */
                             , (SELECT DIVISION_ID
                                     , SCM_SITE_ID
                                     , OPERATION_GROUP
                                  FROM SCM_MST_SITE
                                 WHERE 1 = 1
                                   AND VALID_YN        = 'Y'
                                   AND DIVISION_ID     = '40'
                                   AND OPERATION_GROUP = 'A'
                                UNION ALL
                                SELECT DIVISION_ID
                                     , SCM_SITE_ID
                                     , OPERATION_GROUP
                                  FROM SCM_MST_SITE
                                 WHERE 1 = 1
                                   AND VALID_YN        = 'Y'
                                   AND DIVISION_ID    != '40'
                                   AND OPERATION_GROUP IN('A','P')) FS
                             , SCM_MST_SITE TS
                             , (SELECT DISTINCT DIVISION_ID
                                     , ITEM_ID
                                     , OPERATION_GROUP
                                     , FLOW_ID
                                     , ATTRIBUTE8
                                  FROM SCP_MST_FINAL_ITEM
                                 WHERE DIVISION_ID     = V_DIVISION_ID   /* @P_DIVISION_ID */
                                   AND OPERATION_GROUP IN ('A', 'P')) FI
                         WHERE SSP.DIVISION_ID  = SMS.DIVISION_ID
                           AND SSP.FROM_SITE    = SMS.SCM_SITE_ID
                           AND B.DIVISION_ID    = SSP.DIVISION_ID
                           AND B.BOD_ID         = SSP.BOD_ID
                           AND B.FROM_YYYYMMDD <= SSP.YYYYMMDD   /* 유효한 기간의 BOD */
                           AND B.TO_YYYYMMDD   >= SSP.YYYYMMDD   /* 유효한 기간의 BOD */
                           AND 1 = 1
                           AND SSP.DIVISION_ID  = FS.DIVISION_ID
                           AND SSP.FROM_SITE    = FS.SCM_SITE_ID
                           AND SSP.DIVISION_ID  = TS.DIVISION_ID
                           AND SSP.TO_SITE      = TS.SCM_SITE_ID
                               /* AND TS.SITE_TYPE      = 'SALES' */
                           AND TS.VALID_YN      = 'Y'
                           AND SSP.ITEM_ID      = FI.ITEM_ID(+)
                           AND SSP.DIVISION_ID  = FI.DIVISION_ID(+)
                           AND SSP.DIVISION_ID  = V_DIVISION_ID
                           AND SSP.QTY          > 0
                           AND SSP.YYYYMMDD    >= V_FRZ_START_DATE
                           AND SSP.YYYYMMDD     < V_FRZ_END_DATE
                           AND SSP.SSP_TYPE     = CASE WHEN SSP.YYYYMMDD>=SMS.SSP_CONFIRM_DATE THEN 'REQ' ELSE 'CFM' END
                           AND SSP.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                 FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                WHERE PLAN_ID = V_PLAN_ID)) AA
                 GROUP BY SHIPPING_ORDER_ID, FROM_SITE, TO_SITE, TRANSPORT_MODE, ITEM_ID, FROM_STAGE, TO_STAGE, DEPARTURE_DATE, ARRIVAL_DATE, BOD_ID, SITE_TYPE, INCOTERMS,TO_STAGE_SEMI,PROJECT_CODE) A;
        END IF;

        /* ------------------------------------------------------------------ */
        /* PROJECT CODE가 없는 데이터 DEMAND에서 찾아서 UPDATE                  */
        /* ------------------------------------------------------------------ */
        /* START 2025-12-15 jongykim2: Demand Group Master */
        /*             BEGIN
             END; */
        INSERT
          INTO GT_OPT_ENG_SCHMOV_DMGRP
             ( DIVISION_ID
             , ITEM_ID
             , DEMAND_GROUP
             , PROJECT_CODE )
        SELECT T2.DIVISION_ID
             , T2.ITEM_ID
             , T.GROUP_NAME  AS DEMAND_GROUP
             , T2.PROJECT_CODE
          FROM SCP_MST_ITEM_GROUP        T
             , SCP_MST_ITEM_GROUP_DETAIL T2
         WHERE T2.DIVISION_ID = T.DIVISION_ID
           AND T2.GROUP_ID    = T.GROUP_ID
           AND 1 = 1
           AND T.DIVISION_ID = V_DIVISION_ID
           AND T.VALID_YN    = 'Y'
           AND NVL(T.ATTRIBUTE1, 'N') <> 'Y'
           AND T2.VALID_YN   = 'Y';
        /* END 2025-12-15 jongykim2: */

        /* As-Is : UPDATE @SM_TEMP SET PROJECT_CODE = DJ.PROJECT_CODE FROM @SM_TEMP SMT INNER JOIN (파생 DJ) ON (19개 키 일치)
           파생 DJ = (@SM_TEMP WHERE PROJECT_CODE = '-') 에 #DEMAND_GROUP_T 를 ITEM_ID 로 LEFT OUTER JOIN 해
           MDF_ITEM_ID = IIF(LU.ITEM_ID IS NULL, SMT.ITEM_ID, LU.DEMAND_GROUP) 를 산출한 뒤 @DM_TEMP 와 조인한 집합.
           SHIPPING_ORDER_ID 가 ROW_NUMBER 로 행마다 유일하므로 19키 자가조인은 '자기 자신'만 매칭한다.
           (b) 를 보존하려고 ISNULL(...,'') 로 감싸지 않은 17개 키에 IS NOT NULL 조건을 그대로 남긴다.
           MDF_ITEM_ID 집합 판정은 LEFT OUTER JOIN 의미 그대로 : 매칭 LU 가 있으면 그 DEMAND_GROUP 들, 없으면 SMT.ITEM_ID. */
        /*                                  ,IIF(LU.SEGMENT3 IS NULL, SMT.ITEM_ID, LU.SEGMENT4) AS MDF_ITEM_ID
                                LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                    ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                    AND LU.SEGMENT2 = @V_DIVISION_ID
                                    AND SMT.ITEM_ID = LU.SEGMENT3
                                    AND LU.VALID_YN = 'Y'
                                    blocked 2025-12-15 jongykim2
                                    Added 2025-12-15 jongykim2: Demand Group Master */
        UPDATE GT_OPT_ENG_SCHMOV_SM SMT
           SET SMT.PROJECT_CODE = (SELECT MAX(DT.PROJECT_CODE)
                                     FROM GT_OPT_ENG_SCHMOV_DM DT
                                    WHERE DT.SITE_ID = SMT.TO_SITE
                                      AND ( EXISTS (SELECT 1
                                                      FROM GT_OPT_ENG_SCHMOV_DMGRP LU
                                                     WHERE LU.ITEM_ID      = SMT.ITEM_ID
                                                       AND LU.DEMAND_GROUP = DT.ITEM_ID)
                                         OR ( DT.ITEM_ID = SMT.ITEM_ID
                                              AND NOT EXISTS (SELECT 1
                                                                FROM GT_OPT_ENG_SCHMOV_DMGRP LU2
                                                               WHERE LU2.ITEM_ID = SMT.ITEM_ID) ) )
                                      AND ( (SMT.INCOTERMS IS NULL AND DT.INCOTERMS IS NULL)
                                         OR (SMT.INCOTERMS = DT.INCOTERMS)
                                         OR (SMT.INCOTERMS IS NOT NULL AND DT.INCOTERMS IS NULL) ))
         WHERE SMT.PROJECT_CODE = '-'
           AND SMT.PLAN_ID           IS NOT NULL
           AND SMT.SHIPPING_ORDER_ID IS NOT NULL
           AND SMT.FROM_BUFFER_ID    IS NOT NULL
           AND SMT.TO_BUFFER_ID      IS NOT NULL
           AND SMT.DEPARTURE_DATE    IS NOT NULL
           AND SMT.ARRIVAL_DATE      IS NOT NULL
           AND SMT.TRANSPORT_MODE    IS NOT NULL
           AND SMT.QTY               IS NOT NULL
           AND SMT.FROM_SITE         IS NOT NULL
           AND SMT.ITEM_ID           IS NOT NULL
           AND SMT.FROM_STAGE        IS NOT NULL
           AND SMT.TO_SITE           IS NOT NULL
           AND SMT.TO_STAGE_SEMI     IS NOT NULL
           AND SMT.FENCE_IN_OUT      IS NOT NULL
           AND SMT.BOD_ID            IS NOT NULL
           AND SMT.SITE_TYPE         IS NOT NULL
           AND SMT.INCOTERMS         IS NOT NULL
           AND EXISTS (SELECT 1
                         FROM GT_OPT_ENG_SCHMOV_DM DT
                        WHERE DT.SITE_ID = SMT.TO_SITE
                          AND ( EXISTS (SELECT 1
                                          FROM GT_OPT_ENG_SCHMOV_DMGRP LU
                                         WHERE LU.ITEM_ID      = SMT.ITEM_ID
                                           AND LU.DEMAND_GROUP = DT.ITEM_ID)
                             OR ( DT.ITEM_ID = SMT.ITEM_ID
                                  AND NOT EXISTS (SELECT 1
                                                    FROM GT_OPT_ENG_SCHMOV_DMGRP LU2
                                                   WHERE LU2.ITEM_ID = SMT.ITEM_ID) ) )
                          AND ( (SMT.INCOTERMS IS NULL AND DT.INCOTERMS IS NULL)
                             OR (SMT.INCOTERMS = DT.INCOTERMS)
                             OR (SMT.INCOTERMS IS NOT NULL AND DT.INCOTERMS IS NULL) ));

        /* ------------------------------------------------------------------ */
        /* TO_BUFFER에 PROJECT_CODE 추가해서 INSERT                             */
        /* ------------------------------------------------------------------ */
        INSERT
          INTO SCP_OPT_ENG_SCHEDULED_MOVE_SN
             ( PLAN_ID
             , SHIPPING_ORDER_ID
             , FROM_BUFFER_ID
             , TO_BUFFER_ID
             , DEPARTURE_DATE
             , ARRIVAL_DATE
             , TRANSPORT_MODE
             , QUANTITY
             , RESOURCE_ID
             , LOAD_PER
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10 )
        SELECT ST.PLAN_ID
             , ST.SHIPPING_ORDER_ID
             , ST.FROM_BUFFER_ID
             , ST.TO_BUFFER_ID||CASE WHEN ST.PROJECT_CODE IS NULL THEN '' ELSE '@'||ST.PROJECT_CODE END||CASE WHEN CPS.ITEM_ID IS NULL THEN '' ELSE '::'||ST.FROM_SITE END
             , ST.DEPARTURE_DATE
             , ST.ARRIVAL_DATE
             , ST.TRANSPORT_MODE
             , ST.QTY
             , ST.RESOURCE_ID
             , ST.LOAD_PER
             , ST.FROM_SITE
             , ST.ITEM_ID
             , ST.FROM_STAGE
             , ST.TO_SITE
             , ST.TO_STAGE_SEMI
             , ST.FENCE_IN_OUT
             , ST.BOD_ID
             , ST.SITE_TYPE
             , ST.INCOTERMS
             , ST.PROJECT_CODE
          FROM GT_OPT_ENG_SCHMOV_SM ST
             , GT_OPT_ENG_SCHMOV_CELLPROD CPS
         WHERE 1 = 1
           AND ST.TO_SITE = CPS.SALES_SITE_ID(+)
           AND ST.ITEM_ID = CPS.ITEM_ID(+)
           AND 1 = 1
           AND ST.FROM_BUFFER_ID IS NOT NULL
           AND ST.TO_BUFFER_ID   IS NOT NULL;

        /* ------------------------------------------------------------------ */
        /* PACKING EQUIPMENT CONSTRAINTS UPDATE                                */
        /* 2025.05.21 Philsu Park: Packing EQP 로직 변경에 따른 기존 소스 주석처리. */
        /* ------------------------------------------------------------------ */
        /* UPDATE SCP_OPT_ENG_SCHEDULED_MOVE_SN
           SET SCP_OPT_ENG_SCHEDULED_MOVE_SN.RESOURCE_ID = PE.FROM_SITE_ID +'::PACKING_EQUIPMENT@'+ STAGE+'::'+PE.TO_SITE_ID
           ,   SCP_OPT_ENG_SCHEDULED_MOVE_SN.LOAD_PER    =  1
           FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN WITH(NOLOCK)
               INNER JOIN(
                         SELECT SEGMENT3                      AS ITEM_ID
                               ,SEGMENT4                      AS FROM_SITE_ID
                               ,SEGMENT5                      AS STAGE
                               ,'PACKING_EQUIPMENT@'+SEGMENT5 AS RESOURCE_NAME
                               ,ATTRIBUTE1                      AS TO_SITE_ID
                               ,ATTRIBUTE2                    AS FROM_DATE
                               ,ATTRIBUTE3                    AS TO_DATE
                               ,ATTRIBUTE4                    AS LOWER_VALUE
                               ,ATTRIBUTE5                    AS UPPER_VALUE
                         FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                         WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_EQUIPMENT'
                         AND    VALID_YN    = 'Y'
                         AND    SEGMENT2    = @V_DIVISION_ID
                         ) AS PE
               ON  SCP_OPT_ENG_SCHEDULED_MOVE_SN.ATTRIBUTE1 = PE.FROM_SITE_ID
               AND SCP_OPT_ENG_SCHEDULED_MOVE_SN.ATTRIBUTE2 = PE.ITEM_ID
               AND SCP_OPT_ENG_SCHEDULED_MOVE_SN.ATTRIBUTE3 = PE.STAGE
               AND SCP_OPT_ENG_SCHEDULED_MOVE_SN.ATTRIBUTE4 = PE.TO_SITE_ID
           WHERE SCP_OPT_ENG_SCHEDULED_MOVE_SN.PLAN_ID = @V_PLAN_ID */

        /* ------------------------------------------------------------------ */
        /* PACKING EQUIPMENT CONSTRAINTS UPDATE                                */
        /* 2025.05.21 Philsu Park: Packing EQP 구간 내 충족되는 Departure Date에 대해 Resource 정보 업데이트. */
        /* 2025.05.28 Philsu Park: TO_DATE에 하루 더해줬으므로 등호 제거.        */
        /* 2025.06.23 Philsu Park: Scheduled Move가 Panelty를 먹기 때문에 주석 처리.(NH요청) */
        /* ------------------------------------------------------------------ */
        /* UPDATE SCP_OPT_ENG_SCHEDULED_MOVE_SN
           SET SCP_OPT_ENG_SCHEDULED_MOVE_SN.RESOURCE_ID = PE.FROM_SITE +'::PACKING_EQUIPMENT_' + PE.MODEL_GROUP + '@' + STAGE+'::'+PE.TO_SITE
           ,   SCP_OPT_ENG_SCHEDULED_MOVE_SN.LOAD_PER    =  1
           FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN WITH(NOLOCK)
           INNER JOIN #PACKING_EQUIPMENT PE
               ON  1=1
               AND SCP_OPT_ENG_SCHEDULED_MOVE_SN.ATTRIBUTE1        = PE.FROM_SITE
               AND SCP_OPT_ENG_SCHEDULED_MOVE_SN.ATTRIBUTE2        = PE.MODEL
               AND SCP_OPT_ENG_SCHEDULED_MOVE_SN.ATTRIBUTE3        = PE.STAGE
               AND SCP_OPT_ENG_SCHEDULED_MOVE_SN.ATTRIBUTE4        = PE.TO_SITE
               AND SCP_OPT_ENG_SCHEDULED_MOVE_SN.DEPARTURE_DATE   >= PE.FROM_DATE
               AND SCP_OPT_ENG_SCHEDULED_MOVE_SN.DEPARTURE_DATE    < PE.TO_DATE
           WHERE SCP_OPT_ENG_SCHEDULED_MOVE_SN.PLAN_ID = @V_PLAN_ID
           ; */

        /* ------------------------------------------------------------------ */
        /* 전진검사 A TYPE 적용                                                */
        /* ------------------------------------------------------------------ */
        /* 0. 만들어진 데이터의 MAX SEQ를 찾기위한 변수 설정 */
        SELECT MAX(TO_NUMBER(SHIPPING_ORDER_ID))
          INTO V_MAX_NUM
          FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN
         WHERE PLAN_ID = V_PLAN_ID;

        /* 1. 기존 데이터 삭제를 위한 UPDATE
           As-Is : UPDATE ... FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN SM INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
           -> Oracle 미지원이므로 상관 UPDATE + EXISTS 로 변환(SET 대상이 상수라 다중매칭도 결과 동일). */
        UPDATE SCP_OPT_ENG_SCHEDULED_MOVE_SN SM
           SET SM.ATTRIBUTE15 = 'DELETE'
         WHERE 1 = 1
           AND SM.PLAN_ID = V_PLAN_ID
           AND EXISTS (SELECT 1
                         FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                        WHERE SM.ATTRIBUTE1     = LU.ATTRIBUTE1
                          AND SM.ATTRIBUTE2     = LU.SEGMENT5
                          AND SM.ATTRIBUTE3     = LU.ATTRIBUTE2
                          AND SM.ATTRIBUTE4     = LU.ATTRIBUTE3
                          AND SM.ATTRIBUTE5     = LU.ATTRIBUTE4
                          AND SM.ATTRIBUTE9     = LU.ATTRIBUTE9
                          AND SM.ATTRIBUTE10    = LU.ATTRIBUTE10
                          AND SM.TRANSPORT_MODE = LU.ATTRIBUTE11
                          AND LU.LOOKUP_TYPE    = 'SCP_OPT_ENG_CONST_FORWARD_INSPECTION'
                          AND LU.SEGMENT4       = 'A'
                          AND LU.SEGMENT3       = V_DIVISION_ID
                          AND LU.SEGMENT2       = V_GROUP_ID);

        /* 2. 수정한 데이터 INSERT */
        INSERT
          INTO SCP_OPT_ENG_SCHEDULED_MOVE_SN
             ( PLAN_ID
             , SHIPPING_ORDER_ID
             , FROM_BUFFER_ID
             , TO_BUFFER_ID
             , DEPARTURE_DATE
             , ARRIVAL_DATE
             , TRANSPORT_MODE
             , QUANTITY
             , RESOURCE_ID
             , LOAD_PER
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10 )
        SELECT PLAN_ID
             , V_MAX_NUM+ ROW_NUMBER() OVER(ORDER BY PLAN_ID,FROM_BUFFER_ID,TO_BUFFER_ID,DEPARTURE_DATE,ARRIVAL_DATE,TRANSPORT_MODE,QUANTITY,RESOURCE_ID,LOAD_PER,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10) AS SHI
             , FROM_BUFFER_ID
             , TO_BUFFER_ID
             , DEPARTURE_DATE
             , ARRIVAL_DATE
             , TRANSPORT_MODE
             , QUANTITY
             , RESOURCE_ID
             , LOAD_PER
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
          FROM (
                /* 2.1 TO_BUFFER를 TO_SITE의 MDLE STAGE로 변경 */
                SELECT SM.PLAN_ID                                                                                  AS PLAN_ID
                     , SM.FROM_BUFFER_ID                                                                           AS FROM_BUFFER_ID
                     , SM.ATTRIBUTE4||'::'||SM.ATTRIBUTE2||'::'||LU.ATTRIBUTE2||'@'||SM.ATTRIBUTE9||'@'||LU.ATTRIBUTE10  AS TO_BUFFER_ID
                     , SM.DEPARTURE_DATE                                                                           AS DEPARTURE_DATE
                     , SUBSTR(SM.ARRIVAL_DATE, 1, 8)                                                               AS ARRIVAL_DATE
                     , SM.TRANSPORT_MODE                                                                           AS TRANSPORT_MODE
                     , SM.QUANTITY                                                                                 AS QUANTITY
                     , SM.RESOURCE_ID                                                                              AS RESOURCE_ID
                     , SM.LOAD_PER                                                                                 AS LOAD_PER
                     , SM.ATTRIBUTE1                                                                               AS ATTRIBUTE1
                     , SM.ATTRIBUTE2                                                                               AS ATTRIBUTE2
                     , SM.ATTRIBUTE3                                                                               AS ATTRIBUTE3
                     , SM.ATTRIBUTE4                                                                               AS ATTRIBUTE4
                     , LU.ATTRIBUTE2                                                                               AS ATTRIBUTE5
                     , SM.ATTRIBUTE6                                                                               AS ATTRIBUTE6
                     , SM.ATTRIBUTE7                                                                               AS ATTRIBUTE7
                     , SM.ATTRIBUTE8                                                                               AS ATTRIBUTE8
                     , SM.ATTRIBUTE9                                                                               AS ATTRIBUTE9
                     , SM.ATTRIBUTE10                                                                              AS ATTRIBUTE10
                  FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN SM
                     , SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                 WHERE SM.ATTRIBUTE1     = LU.ATTRIBUTE1
                   AND SM.ATTRIBUTE2     = LU.SEGMENT5
                   AND SM.ATTRIBUTE3     = LU.ATTRIBUTE2
                   AND SM.ATTRIBUTE4     = LU.ATTRIBUTE3
                   AND SM.ATTRIBUTE5     = LU.ATTRIBUTE4
                   AND SM.ATTRIBUTE9     = LU.ATTRIBUTE9
                   AND SM.ATTRIBUTE10    = LU.ATTRIBUTE10
                   AND SM.TRANSPORT_MODE = LU.ATTRIBUTE11
                   AND LU.LOOKUP_TYPE    = 'SCP_OPT_ENG_CONST_FORWARD_INSPECTION'
                   AND LU.SEGMENT4       = 'A'
                   AND LU.SEGMENT3       = V_DIVISION_ID
                   AND LU.SEGMENT2       = V_GROUP_ID
                   AND 1 = 1
                   AND SM.PLAN_ID = V_PLAN_ID
                UNION ALL
                /* 2.2 FROM_BUFFER를 TO_SITE의 MDLE STAGE로 변경, TO_SITE의 STAGE는 MDLEBIZ로 변경, 기간은 LOOKUP에 정의되어있는 날짜만큼 + */
                SELECT SM.PLAN_ID                                                                                  AS PLAN_ID
                     , SM.ATTRIBUTE4||'::'||SM.ATTRIBUTE2||'::'||LU.ATTRIBUTE2||'@'||SM.ATTRIBUTE9||'@'||LU.ATTRIBUTE10  AS FROM_BUFFER_ID
                     , SM.TO_BUFFER_ID                                                                             AS TO_BUFFER_ID
                     , SM.ARRIVAL_DATE                                                                             AS DEPARTURE_DATE
                     , TO_CHAR(TO_DATE(SM.ARRIVAL_DATE,'YYYYMMDD') + TO_NUMBER(LU.ATTRIBUTE7),'YYYYMMDD')          AS ARRIVAL_DATE
                     , SM.TRANSPORT_MODE                                                                           AS TRANSPORT_MODE
                     , SM.QUANTITY                                                                                 AS QUANTITY
                     , SM.RESOURCE_ID                                                                              AS RESOURCE_ID
                     , SM.LOAD_PER                                                                                 AS LOAD_PER
                     , SM.ATTRIBUTE4                                                                               AS ATTRIBUTE1
                     , SM.ATTRIBUTE2                                                                               AS ATTRIBUTE2
                     , LU.ATTRIBUTE2                                                                               AS ATTRIBUTE3
                     , SM.ATTRIBUTE4                                                                               AS ATTRIBUTE4
                     , SM.ATTRIBUTE5                                                                               AS ATTRIBUTE5
                     , SM.ATTRIBUTE6                                                                               AS ATTRIBUTE6
                     , SM.ATTRIBUTE7                                                                               AS ATTRIBUTE7
                     , SM.ATTRIBUTE8                                                                               AS ATTRIBUTE8
                     , SM.ATTRIBUTE9                                                                               AS ATTRIBUTE9
                     , SM.ATTRIBUTE10                                                                              AS ATTRIBUTE10
                  FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN SM
                     , SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                 WHERE SM.ATTRIBUTE1     = LU.ATTRIBUTE1
                   AND SM.ATTRIBUTE2     = LU.SEGMENT5
                   AND SM.ATTRIBUTE3     = LU.ATTRIBUTE2
                   AND SM.ATTRIBUTE4     = LU.ATTRIBUTE3
                   AND SM.ATTRIBUTE5     = LU.ATTRIBUTE4
                   AND SM.ATTRIBUTE9     = LU.ATTRIBUTE9
                   AND SM.ATTRIBUTE10    = LU.ATTRIBUTE10
                   AND SM.TRANSPORT_MODE = LU.ATTRIBUTE11
                   AND LU.LOOKUP_TYPE    = 'SCP_OPT_ENG_CONST_FORWARD_INSPECTION'
                   AND LU.SEGMENT4       = 'A'
                   AND LU.SEGMENT3       = V_DIVISION_ID
                   AND LU.SEGMENT2       = V_GROUP_ID
                   AND 1 = 1
                   AND SM.PLAN_ID = V_PLAN_ID) SM;

        /* 3. 기존 SM 삭제 */
        DELETE
          FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN
         WHERE 1 = 1
           AND PLAN_ID     = V_PLAN_ID
           AND ATTRIBUTE15 = 'DELETE';

        /* ------------------------------------------------------------------ */
        /* 2nd OCV 적용을 위해 STAGE 변경                                       */
        /* ------------------------------------------------------------------ */
        /* As-Is : UPDATE ... FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN SM INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
           -> Oracle 미지원이므로 상관 UPDATE + EXISTS 로 변환. LU 다중매칭 시 원본은 임의행 선택 -> ROWNUM = 1 로 등가.
           SM.ATTRIBUTE1 / SM.ATTRIBUTE2 는 LU.SEGMENT4 / SEGMENT5(NOT NULL) 등호로 NOT NULL 이 보장된다. */
        UPDATE SCP_OPT_ENG_SCHEDULED_MOVE_SN SM
           SET ( SM.FROM_BUFFER_ID, SM.ATTRIBUTE3 ) =
               (SELECT CASE WHEN LU.ATTRIBUTE3 IS NULL THEN NULL
                            ELSE SM.ATTRIBUTE1||'::'||SM.ATTRIBUTE2||'::'||LU.ATTRIBUTE3 END
                     , LU.ATTRIBUTE3
                  FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                 WHERE LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                   AND LU.VALID_YN    = 'Y'
                   AND LU.SEGMENT2    = V_DIVISION_ID
                   AND LU.SEGMENT3    = V_GROUP_ID
                   AND SM.ATTRIBUTE1  = LU.SEGMENT4
                   AND SM.ATTRIBUTE2  = LU.SEGMENT5
                   AND ROWNUM = 1)
         WHERE SM.PLAN_ID = V_PLAN_ID
           AND EXISTS (SELECT 1
                         FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                        WHERE LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                          AND LU.VALID_YN    = 'Y'
                          AND LU.SEGMENT2    = V_DIVISION_ID
                          AND LU.SEGMENT3    = V_GROUP_ID
                          AND SM.ATTRIBUTE1  = LU.SEGMENT4
                          AND SM.ATTRIBUTE2  = LU.SEGMENT5);

        /* ------------------------------------------------------------------ */
        /* 임시 적용 : W07 Final Plan 정보 : END                               */
        /* ------------------------------------------------------------------ */

        /* --원래 적용 로직 : START

        INSERT INTO SCP_OPT_ENG_SCHEDULED_MOVE_SN( PLAN_ID
                                               ,SHIPPING_ORDER_ID
                                               ,FROM_BUFFER_ID
                                               ,TO_BUFFER_ID
                                               ,DEPARTURE_DATE
                                               ,ARRIVAL_DATE
                                               ,TRANSPORT_MODE
                                               ,QUANTITY
                                               ,RESOURCE_ID
                                               ,LOAD_PER
                                              )
        SELECT @V_PLAN_ID                             AS PLAN_ID
              ,SHIPPING_ORDER_ID                      AS SHIPPING_ORDER_ID
              ,FROM_SITE+'::'+ITEM_ID+'::'+FROM_STAGE AS FROM_BUFFER_ID
              ,TO_SITE+'::'+ITEM_ID+'::'+TO_STAGE     AS TO_BUFFER_ID
              ,DEPARTURE_DATE                         AS DEPARTURE_DATE
              ,ARRIVAL_DATE                           AS ARRIVAL_DATE
              ,TRANSPORT_MODE                         AS TRANSPORT_MODE
              ,QTY                                    AS QTY
              ,NULL                                   AS RESOURCE_ID
              ,NULL                                   AS LOAD_PER
        FROM(
            SELECT  SHIPPING_ORDER_ID AS SHIPPING_ORDER_ID
                   ,FROM_SITE         AS FROM_SITE
                   ,TO_SITE           AS TO_SITE
                   ,TRANSPORT_MODE    AS TRANSPORT_MODE
                   ,ITEM_ID           AS ITEM_ID
                   ,FROM_STAGE        AS FROM_STAGE
                   ,TO_STAGE          AS TO_STAGE
                   ,DEPARTURE_DATE    AS DEPARTURE_DATE
                   ,ARRIVAL_DATE      AS ARRIVAL_DATE
                   ,SUM(QTY)          AS QTY
            FROM (
			        SELECT   A.CONFIRM_ID                         AS SHIPPING_ORDER_ID
            				,A.FROM_SITE                          AS FROM_SITE
            				,A.TO_SITE                            AS TO_SITE
            				,A.TRANSPORT_MODE                     AS TRANSPORT_MODE
            				,A.ITEM_ID                            AS ITEM_ID
            				--,'CHAR'                             AS FROM_STAGE
            				--,'CELL BIZ'                         AS TO_STAGE

                			,CASE WHEN FS.OPERATION_GROUP = 'A'                          THEN 'CHAR' -- CELL PLANT 출발
                				WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P9500' THEN 'PACK' -- PACK PLANT 출발
                				WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P5500' THEN 'MDLE' -- PACK PLANT 출발
                				WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P5000' THEN 'MDLE' -- PACK PLANT 출발
                			 END AS FROM_STAGE
                			,CASE WHEN FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'SALES'                          THEN 'CELLBIZ' + '@' + A.INCOTERMS -- CELL PLANT 출발 -> SALES 도착
                				WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P9500' THEN 'PACKBIZ' + '@' + A.INCOTERMS -- PACK PLANT 출발 -> SALES 도착
                				WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P5500' THEN 'MDLEBIZ' + '@' + A.INCOTERMS -- PACK PLANT 출발 -> SALES 도착
                				WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P5000' THEN 'MDLEBIZ' + '@' + A.INCOTERMS -- PACK PLANT 출발 -> SALES 도착
								WHEN A.DIVISION_ID  = '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT' THEN  NULL  -- 소형은 CEll Biz 용 Demand - CELL PLANT 출발 -> PLANT 도착 : To Buffer ID 도 NULL 됨
								WHEN A.DIVISION_ID <> '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT' THEN 'CHAR' -- CELL PLANT 출발 -> PLANT 도착
                				WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P9500' THEN 'PACK' -- PACK PLANT 출발 -> PLANT 도착
                				WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P5500' THEN 'MDLE' -- PACK PLANT 출발 -> PLANT 도착
                				WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P5000' THEN 'MDLE' -- PACK PLANT 출발 -> PLANT 도착
                			END AS TO_STAGE

            				,A.YYYYMMDD                           AS DEPARTURE_DATE
            				--,CONVERT(VARCHAR(8), A.ETA_DATE, 112) AS ARRIVAL_DATE
                			,CASE WHEN A.DIVISION_ID  = '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT'
							          THEN  A.YYYYMMDD  -- 소형 CEll Biz 용 Demand : 소형 CEll Req 용은 LT 0
								  ELSE CONVERT(VARCHAR(8), A.ETA_DATE, 112)
                			 END AS ARRIVAL_DATE
            				,A.QTY
					FROM SCM_DNM_SSP_PLAN_V A WITH (NOLOCK)

					INNER JOIN SCM_MST_SITE FS WITH (NOLOCK)
					ON  A.DIVISION_ID    = FS.DIVISION_ID
					AND A.FROM_SITE      = FS.SCM_SITE_ID
					--AND FS.SITE_TYPE      = 'PLANT'
					AND FS.VALID_YN      = 'Y'
					AND ((FS.DIVISION_ID  = '40' AND FS.OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
						OR  (FS.DIVISION_ID <> '40' AND FS.OPERATION_GROUP IN ('A', 'P') )
						)

					INNER JOIN SCM_MST_SITE TS WITH (NOLOCK)
					ON  A.DIVISION_ID    = TS.DIVISION_ID
					AND A.TO_SITE        = TS.SCM_SITE_ID
					--AND TS.SITE_TYPE      = 'SALES'
					AND TS.VALID_YN       = 'Y'
					AND ((TS.DIVISION_ID  = '40' AND TS.SITE_TYPE      = 'SALES' )      -- 소형은 CEll Biz 용 Demand 만 처리
						OR  (TS.DIVISION_ID <> '40' )
						)

					LEFT JOIN (SELECT DISTINCT DIVISION_ID
											  ,ITEM_ID
											  ,OPERATION_GROUP
											  ,FLOW_ID
											  ,ATTRIBUTE8
								FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK)
								WHERE  DIVISION_ID = @V_DIVISION_ID--@P_DIVISION_ID
								AND    OPERATION_GROUP IN ('A', 'P')
							   ) FI
					ON    A.ITEM_ID     = FI.ITEM_ID
					AND   A.DIVISION_ID = FI.DIVISION_ID

					WHERE A.DIVISION_ID  = @V_DIVISION_ID
					AND A.QTY          > 0
					AND A.YYYYMMDD     >= @V_PLAN_START_YYYYMMDD
					AND A.YYYYMMDD     < DATEADD(DD, ISNULL(@V_SHIP_FROZEN, 0), @V_PLAN_START_YYYYMMDD )
					AND A.SSP_TYPE     = 'CFM'
					AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
									FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
									WHERE  PLAN_ID = @V_PLAN_ID
									)
            	  ) AA
            GROUP BY SHIPPING_ORDER_ID, FROM_SITE, TO_SITE, TRANSPORT_MODE, ITEM_ID, FROM_STAGE, TO_STAGE, DEPARTURE_DATE, ARRIVAL_DATE
            ) A

        -- 원래 적용 로직 : END */

        /* ------------------------------------------------------------------ */
        /* Data Insert End                                                     */
        /* ------------------------------------------------------------------ */

    /* ------------------------------------------------------------------ */
    /*   ROLLBACK TRANSACTION PR_SCP_OPT_ENG_RUN_MAIN_PROC;                */
    /*   ERROR LOG                                                         */
    /* ------------------------------------------------------------------ */
    EXCEPTION
        WHEN OTHERS THEN
            V_MESSAGE_TEXT := SUBSTR(SQLERRM,1,1000);
            PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'ERROR',NULL,V_MESSAGE_TEXT,NULL,V_PLAN_ID);
            V_DETAIL_DATE := SYSDATE;
            PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,V_DETAIL_DATE,NULL,V_MESSAGE_TEXT,'ERROR');
            RAISE_APPLICATION_ERROR(-20001, V_PROGRAM_NAME);
    END;

    /* ------------------------------------------------------------------ */
    /* 종료 LOG                                                            */
    /* ------------------------------------------------------------------ */
    IF V_MESSAGE_TEXT IS NULL THEN
        PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'END',NULL,NULL,NULL,V_PLAN_ID);
        PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,NULL,NULL,NULL,NULL);
    END IF;
    /* ------------------------------------------------------------------ */
END PR_SCP_OPT_ENG_INPUT_SCHEDULED_MOVE;