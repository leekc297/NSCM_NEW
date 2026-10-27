PROCEDURE         PR_SCP_OPT_ENG_INPUT_SCHEDULED_MOVE_BATCH
(
    P_PLAN_ID               IN VARCHAR2 DEFAULT NULL
  , V_DIVISION_ID           IN VARCHAR2 DEFAULT NULL
  , V_GROUP_ID              IN VARCHAR2 DEFAULT NULL
  , V_PLAN_START_YYYYMMDD   IN VARCHAR2 DEFAULT NULL
  , V_PLAN_END_YYYYMMDD     IN VARCHAR2 DEFAULT NULL
)
IS
/*
 * Program ID   : PR_SCP_OPT_ENG_INPUT_SCHEDULED_MOVE_BATCH
 * Description  : SCP 최적화 엔진 입력용 Scheduled Move 데이터를 생성한다.
 *                - Shipment Plan(FG/Semi) 또는 SSP Plan 을 BOD/사이트/최종품목 기준으로 가공하여
 *                  SCP_OPT_ENG_SCHEDULED_MOVE_SN 에 적재한다.
 *                - Demand 정보에서 Project Code 를 보정한다.
 *
 * Program History
 *===================================================================================================
 *   Date         In Charge   Description
 *===================================================================================================
 * 2025.02.14     Taehyun     Initial Release
 * 2025.05.20     Philsu Park Packing Equipment Temp 생성
 * 2025.06.20     김태현      FROZEN 정보 확인
 * 2025.11.24     Minyong Lee Lookup -> UI 전환 (Packing Equipment)
 * 2025.12.15     jongykim2   Demand Group Master 적용
 * 2026.10.07     JCH         MSSQL -> Oracle 전환
 */
    V_PROGRAM_NAME     VARCHAR2(150 CHAR)  := 'PR_SCP_OPT_ENG_INPUT_SCHEDULED_MOVE_BATCH';
    V_PLAN_ID          VARCHAR2(50 CHAR)   := P_PLAN_ID;
    V_MESSAGE_TEXT     VARCHAR2(1000 CHAR);

    V_DETAIL_DATE      DATE;
    V_SHIP_FROZEN      NUMBER;
    V_MAX_NUM          NUMBER;
    V_SCP_PLAN_DATE    VARCHAR2(8 CHAR);
    V_SCP_PLAN_TYPE    VARCHAR2(8 CHAR);
    V_SCP_PLAN_SEQ     VARCHAR2(8 CHAR);
    V_FRZ_START_DATE   VARCHAR2(8 CHAR);
    V_FRZ_END_DATE     VARCHAR2(8 CHAR);
    V_SYS_DIVS_CD      VARCHAR2(8 CHAR);
    
    V_REF_PLAN_VERSION_ID     VARCHAR2(20 CHAR);
    V_REF_PLAN_START_YYYYMMDD VARCHAR2(8 CHAR);
    V_REF_PLAN_TYPE           VARCHAR2(8 CHAR);
    V_REF_PLAN_SEQ            VARCHAR2(8 CHAR);
BEGIN

    ------------------------------------------------------------------------
    -- Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성
    ------------------------------------------------------------------------
    PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'START',NULL,NULL,NULL,V_PLAN_ID);

    ------------------------------------------------------------------------
    -- Transaction (START)
    ------------------------------------------------------------------------
    BEGIN
        /* 임시 테이블(GTT) 초기화 : TRUNCATE 가 아닌 DELETE 로 비운다 */
        DELETE FROM GT_ISMB_DM;
        DELETE FROM GT_ISMB_SM;
        DELETE FROM GT_ISMB_CELL_PROD_SITE;
        DELETE FROM GT_ISMB_PACKING_EQP;
        DELETE FROM GT_ISMB_DEMAND_GROUP;

        ------------------------------------------------------------------------
        -- Data Insert Start
        ------------------------------------------------------------------------
        -- PR_SCP_OPT_ENG_INPUT_BOD 에서도 사용
        SELECT  MAX(SEGMENT4)
          INTO  V_SHIP_FROZEN
          FROM  SCP_OPMZ_LOOKUP_MASTER_DETAIL LV
         WHERE  LOOKUP_TYPE = 'SCP_OPT_SHIP_FROZEN'
           AND  VALID_YN    = 'Y'
           AND  SEGMENT1    = V_DIVISION_ID
           AND  SEGMENT2    = V_GROUP_ID
        --AND     SEGMENT3    = 'PR' --임시
           AND  SEGMENT3    = V_SCP_PLAN_TYPE;
        ------------------------------------------------------------------------
        -- 셀 생산지 버퍼 추가
        ------------------------------------------------------------------------
        INSERT INTO GT_ISMB_CELL_PROD_SITE
        SELECT  SEGMENT3 AS SALES_SITE_ID
               ,SEGMENT4 AS ITEM_ID
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL 
        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CELL_PROD_SITE'
        AND     SEGMENT1 = V_DIVISION_ID
        ;
        ------------------------------------------------------------------------
        -- 2025.06.20 김태현 : FROZEN 정보 확인
        ------------------------------------------------------------------------
        SELECT  MAX(PLAN_YYYYMMDD)
              , MAX(PLAN_TYPE)
              , MAX(PLAN_SEQ)
              , MAX(FROZEN_START_DATE)
              , MAX(FROZEN_END_DATE)
              , MAX(SYS_DIVS_CD)
          INTO  V_SCP_PLAN_DATE
              , V_SCP_PLAN_TYPE
              , V_SCP_PLAN_SEQ
              , V_FRZ_START_DATE
              , V_FRZ_END_DATE
              , V_SYS_DIVS_CD
          FROM  SCP_OPT_ENG_FROZEN_MASTER_SN
         WHERE  1=1
           AND  PLAN_ID     = V_PLAN_ID
           AND  DIVISION_ID = V_DIVISION_ID
           AND  FROZEN_TYPE = 'SHIP';

        ------------------------------------------------------------------------
        -- 2026.10.20 JCH : FROZEN 참조 변수 확인
        ------------------------------------------------------------------------
        SELECT SHIP_REF_SYS_PLAN_ID
          INTO V_REF_PLAN_VERSION_ID
          FROM SCP_OPMZ_PLAN_M
         WHERE OPMZ_PLAN_ID = V_PLAN_ID
        ;
        
        SELECT PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , PLAN_SEQ
          INTO V_REF_PLAN_START_YYYYMMDD
             , V_REF_PLAN_TYPE          
             , V_REF_PLAN_SEQ
          FROM (
                SELECT PLAN_VERSION_ID
                     , DIVISION_ID
                     , PLAN_START_YYYYMMDD
                     , PLAN_TYPE
                     , PLAN_SEQ
                  FROM SCP_PLAN_VERSION_V
                 WHERE DIVISION_ID     = V_DIVISION_ID
                   AND PLAN_VERSION_ID = V_REF_PLAN_VERSION_ID
               ) IA
        ;
        ------------------------------------------------------------------------------------------
        -- 2025.05.20 Philsu Park: Packing Equipment Temp 생성.
        ------------------------------------------------------------------------------------------
        /* 원문의 #PACKING_EQUIPMENT 재생성(IF OBJECT_ID .. DROP)은 GTT 사용으로 불필요. 위에서 DELETE 로 초기화함. */

        -- Model 별 Input: Model GROUP 단위로 동일 MIN, MAX 적용.
        -- 2025.05.28 Philsu Park: TO_DATE 는 하루 더해줌.
        -- 2025.07.24 Philsu Park: Plan Horizon 내에 해당하는 PACKING EQP 정보만 추출.
        INSERT INTO GT_ISMB_PACKING_EQP
        (
            DIVISION, PLAN_GROUP, MODEL, MODEL_GROUP, FROM_SITE, STAGE, TO_SITE, FROM_DATE, TO_DATE, LOWER_QTY, UPPER_QTY
        )
        WITH MODEL_GROUP AS (
                --SELECT    SEGMENT2                                  AS DIVISION
                --        , SEGMENT3                                  AS PLAN_GROUP
                --        , SEGMENT5                                  AS MODEL_GROUP
                --        , GREATEST(@V_PLAN_START_YYYYMMDD, MIN(ATTRIBUTE4))                           AS FROM_DATE
                --        , LEAST(@V_PLAN_END_YYYYMMDD, CONVERT(NVARCHAR, DATEADD(DAY, 1, CONVERT(DATE, MAX(ATTRIBUTE5), 112)), 112)) AS TO_DATE
                --        , MIN(CONVERT(NUMERIC(20,10), ATTRIBUTE6))  AS LOWER_QTY
                --        , MAX(CONVERT(NUMERIC(20,10), ATTRIBUTE7))  AS UPPER_QTY
                --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
                --WHERE   D.LOOKUP_TYPE   = 'SCP_OPT_ENG_CONST_PACKING_EQUIPMENT'
                --AND     D.VALID_YN      = 'Y'  -- ***!!!Valid Flag는 나중에 살려야됨!!!***
                --AND     D.SEGMENT2      = @V_DIVISION_ID
                --AND     D.SEGMENT3      = @V_GROUP_ID
                --GROUP BY SEGMENT2, SEGMENT3, SEGMENT5

                -- 2025.11.24 Minyong Lee : Lookup -> UI 전환 (Packing Equipment)
                SELECT    CS.DIVISION_ID                                 AS DIVISION
                        , PG.OPMZ_PLAN_GR_NAME                           AS PLAN_GROUP
                        --, @V_GROUP_ID                                    AS PLAN_GROUP
                        , CS.MDL_GR_NM                                   AS MODEL_GROUP
                        , GREATEST(V_PLAN_START_YYYYMMDD, MIN(CS.FROM_YYYYMMDD))                           AS FROM_DATE
                        , LEAST(V_PLAN_END_YYYYMMDD, TO_CHAR(TO_DATE(MAX(CS.TO_YYYYMMDD), 'YYYYMMDD') + 1, 'YYYYMMDD')) AS TO_DATE
                        , MIN(TO_NUMBER(CS.SIPM_MIN_QYT))                AS LOWER_QTY
                        , MAX(TO_NUMBER(CS.SIPM_MAX_QTY))                AS UPPER_QTY
                FROM    SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY CS
                    LEFT JOIN SCP_OPMZ_PLAN_GR_M PG
                        ON  CS.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                        AND PG.VALID_YN = 'Y'
                WHERE   1=1
                AND     CS.VALID_YN          = 'Y'
                AND     CS.DIVISION_ID       = V_DIVISION_ID
                GROUP BY CS.DIVISION_ID, PG.OPMZ_PLAN_GR_NAME, CS.MDL_GR_NM
            )
        SELECT    DISTINCT
                  CS.DIVISION_ID                        AS DIVISION
                , PG.OPMZ_PLAN_GR_NAME                  AS PLAN_GROUP
                , CS.ITEM_ID                            AS MODEL
                , CS.MDL_GR_NM                          AS MODEL_GROUP
                , CS.FROM_STE_ID                        AS FROM_SITE
                , CS.STAGE                              AS STAGE
                , CS.TO_STE_ID                          AS TO_SITE
                , GRP.FROM_DATE                         AS FROM_DATE
                , GRP.TO_DATE                           AS TO_DATE
                , GRP.LOWER_QTY                         AS LOWER_QTY
                , GRP.UPPER_QTY                         AS UPPER_QTY
        FROM    SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY CS
            LEFT JOIN SCP_OPMZ_PLAN_GR_M PG
                ON  CS.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                AND PG.VALID_YN = 'Y'
            INNER JOIN MODEL_GROUP GRP
                ON  GRP.DIVISION    = CS.DIVISION_ID
                AND GRP.PLAN_GROUP  = PG.OPMZ_PLAN_GR_NAME
                AND GRP.MODEL_GROUP = CS.MDL_GR_NM
        WHERE   1=1
        AND     CS.VALID_YN          = 'Y'
        AND     CS.DIVISION_ID       = V_DIVISION_ID
        AND     1=1 /* _BATCH T3: 계획그룹 필터 제거(사업부 전체) */
        AND     GRP.FROM_DATE        < V_PLAN_END_YYYYMMDD
        AND     GRP.TO_DATE          >= V_PLAN_START_YYYYMMDD
        ;

        --------------------------------------------------------
        -- PROJECT CODE UPDATE 용도
        -- INCOTERMS가 있는 DM정보와, 없는 DM정보를 각각 가져옴 -> DUE DATE가 가장 빠른 날짜 기준
        --------------------------------------------------------
        INSERT INTO GT_ISMB_DM
        (
            SITE_ID, ITEM_ID, INCOTERMS, PROJECT_CODE
        )
        SELECT SITE_ID
              ,ITEM_ID
              ,INCOTERMS
              ,PROJECT_CODE
        FROM(
            SELECT SITE_ID
                  ,ITEM_ID
                  ,INCOTERMS
                  ,PROJECT_CODE
                  ,ROW_NUMBER() OVER( PARTITION BY SITE_ID,ITEM_ID,INCOTERMS,PROJECT_CODE ORDER BY MIN_DUE ) AS ROW_NUM
            FROM(
                 SELECT ATTRIBUTE1    AS SITE_ID
                       ,ATTRIBUTE2    AS ITEM_ID
                       ,ATTRIBUTE4    AS INCOTERMS
                       ,ATTRIBUTE5    AS PROJECT_CODE
                       ,MIN(DUE_DATE) AS MIN_DUE
                 FROM SCP_OPT_ENG_DEMAND_SN
                 WHERE   PLAN_ID = V_PLAN_ID
                 AND     ATTRIBUTE5 IS NOT NULL --PROJECT_CODE
                 AND     ATTRIBUTE4 IS NOT NULL --INCOTERMS
                 GROUP BY ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE4,ATTRIBUTE5
                 ) DM
            ) RM
        WHERE ROW_NUM =1
        UNION ALL
        SELECT SITE_ID
              ,ITEM_ID
              ,INCOTERMS
              ,PROJECT_CODE
        FROM(
            SELECT SITE_ID
                  ,ITEM_ID
                  ,INCOTERMS
                  ,PROJECT_CODE
                  ,ROW_NUMBER() OVER( PARTITION BY SITE_ID,ITEM_ID,PROJECT_CODE ORDER BY MIN_DUE ) AS ROW_NUM
            FROM(
                 SELECT ATTRIBUTE1    AS SITE_ID
                       ,ATTRIBUTE2    AS ITEM_ID
                       ,NULL          AS INCOTERMS
                       ,ATTRIBUTE5    AS PROJECT_CODE
                       ,MIN(DUE_DATE) AS MIN_DUE
                 FROM SCP_OPT_ENG_DEMAND_SN
                 WHERE   PLAN_ID = V_PLAN_ID
                 AND     ATTRIBUTE5 IS NOT NULL
                 AND     ATTRIBUTE4 IS NULL
                 GROUP BY ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE5
                 ) DM
            ) RM
        WHERE ROW_NUM =1
        ;
    -------------------------------------------------
    -- 임시 적용 : W07 Final Plan 정보 : START
    -------------------------------------------------
        IF V_SYS_DIVS_CD = 'SCP' THEN
                INSERT INTO GT_ISMB_SM
                (
                    PLAN_ID, SHIPPING_ORDER_ID, FROM_BUFFER_ID, TO_BUFFER_ID, DEPARTURE_DATE, ARRIVAL_DATE
                  , TRANSPORT_MODE, QTY, RESOURCE_ID, LOAD_PER, FROM_SITE, ITEM_ID, FROM_STAGE, TO_SITE
                  , TO_STAGE_SEMI, FENCE_IN_OUT, BOD_ID, SITE_TYPE, INCOTERMS, PROJECT_CODE
                )
                SELECT V_PLAN_ID                              AS PLAN_ID
                      ,SHIPPING_ORDER_ID                      AS SHIPPING_ORDER_ID
                      ,CASE WHEN FROM_STAGE IS NULL THEN NULL ELSE FROM_SITE||'::'||ITEM_ID||'::'||FROM_STAGE END AS FROM_BUFFER_ID
                      ,CASE WHEN TO_STAGE   IS NULL THEN NULL ELSE TO_SITE  ||'::'||ITEM_ID||'::'||TO_STAGE   END AS TO_BUFFER_ID
                      ,DEPARTURE_DATE                         AS DEPARTURE_DATE
                      ,ARRIVAL_DATE                           AS ARRIVAL_DATE
                      ,TRANSPORT_MODE                         AS TRANSPORT_MODE
                      ,QTY                                    AS QTY
                      ,NULL                                   AS RESOURCE_ID
                      ,NULL                                   AS LOAD_PER
                      ,FROM_SITE                              AS FROM_SITE
                      ,ITEM_ID                                AS ITEM_ID
                      ,FROM_STAGE                             AS FROM_STAGE
                      ,TO_SITE                                AS TO_SITE
                      ,TO_STAGE_SEMI                          AS TO_STAGE_SEMI
                      ,'IN'                                   AS FENCE_IN_OUT -- OUT DATA를 넣어줄 때 확정 구간 내에있는 데이터를 구분하기 위한 FLAG
                      ,BOD_ID                                 AS BOD_ID
                      ,SITE_TYPE                              AS SITE_TYPE
                      ,INCOTERMS                              AS INCOTERMS
                      ,PROJECT_CODE                           AS PROJECT_CODE
                FROM(
                    SELECT  ROW_NUMBER() OVER(ORDER BY ITEM_ID) AS SHIPPING_ORDER_ID
                           ,FROM_SITE         AS FROM_SITE
                           ,TO_SITE           AS TO_SITE
                           ,TRANSPORT_MODE    AS TRANSPORT_MODE
                           ,ITEM_ID           AS ITEM_ID
                           ,FROM_STAGE        AS FROM_STAGE
                           ,TO_STAGE          AS TO_STAGE
                           ,DEPARTURE_DATE    AS DEPARTURE_DATE
                           ,ARRIVAL_DATE      AS ARRIVAL_DATE
                           ,SUM(QTY)          AS QTY
                           ,BOD_ID            AS BOD_ID
                           ,SITE_TYPE         AS SITE_TYPE
                           ,INCOTERMS         AS INCOTERMS
                           ,TO_STAGE_SEMI     AS TO_STAGE_SEMI
                           ,PROJECT_CODE      AS PROJECT_CODE
                    FROM (
                          -- Shipment Plan FG : Sales 향
                            SELECT   NULL                         AS SHIPPING_ORDER_ID
                                    ,A.FROM_SITE                          AS FROM_SITE
                                    ,A.TO_SITE                            AS TO_SITE
                                    ,B.TRANSPORT_MODE                     AS TRANSPORT_MODE
                                    ,A.ITEM_ID                            AS ITEM_ID
                                    ,B.BOD_ID                             AS BOD_ID
                                    ,TS.SITE_TYPE                         AS SITE_TYPE
                                    ,B.INCOTERMS                          AS INCOTERMS
                                    --,'CHAR'                             AS FROM_STAGE
                                    --,'CELL BIZ'                         AS TO_STAGE

                                    ,CASE WHEN FS.OPERATION_GROUP = 'A'                          THEN 'CHAR' -- CELL PLANT 출발
                                        WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P9500' THEN 'PACK' -- PACK PLANT 출발
                                        WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P5500' THEN 'MDLE' -- PACK PLANT 출발
                                        WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLE' -- PACK PLANT 출발
                                     END AS FROM_STAGE
                                    ,CASE WHEN FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'SALES'                          THEN 'CELLBIZ' || '@' || B.INCOTERMS -- CELL PLANT 출발 -> SALES 도착
                                        WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P9500' THEN 'PACKBIZ' || '@' || B.INCOTERMS -- PACK PLANT 출발 -> SALES 도착
                                        WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P5500' THEN 'MDLEBIZ' || '@' || B.INCOTERMS -- PACK PLANT 출발 -> SALES 도착
                                        WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLEBIZ' || '@' || B.INCOTERMS -- PACK PLANT 출발 -> SALES 도착
                                        WHEN A.DIVISION_ID = '40'  AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT' THEN  NULL  -- 소형은 CEll Biz 용 Demand - CELL PLANT 출발 -> PLANT 도착 : To Buffer ID 도 NULL 됨
                                        WHEN A.DIVISION_ID <> '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT' THEN 'CHAR' -- CELL PLANT 출발 -> PLANT 도착
                                        WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P9500' THEN 'PACK' -- PACK PLANT 출발 -> PLANT 도착
                                        WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P5500' THEN 'MDLE' -- PACK PLANT 출발 -> PLANT 도착
                                        WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLE' -- PACK PLANT 출발 -> PLANT 도착
                                     END AS TO_STAGE
                                    ,CASE WHEN FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'SALES'                          THEN 'CELLBIZ' -- INCOTERMS 제거
                                        WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P9500' THEN 'PACKBIZ'   -- INCOTERMS 제거
                                        WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P5500' THEN 'MDLEBIZ'   -- INCOTERMS 제거
                                        WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLEBIZ'   -- INCOTERMS 제거
                                        WHEN A.DIVISION_ID = '40'  AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT' THEN  NULL  -- 소형은 CEll Biz 용 Demand - CELL PLANT 출발 -> PLANT 도착 : To Buffer ID 도 NULL 됨
                                        WHEN A.DIVISION_ID <> '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT' THEN 'CHAR' -- CELL PLANT 출발 -> PLANT 도착
                                        WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P9500' THEN 'PACK' -- PACK PLANT 출발 -> PLANT 도착
                                        WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P5500' THEN 'MDLE' -- PACK PLANT 출발 -> PLANT 도착
                                        WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLE' -- PACK PLANT 출발 -> PLANT 도착
                                     END AS TO_STAGE_SEMI -- ATTRIBUTE 저장을 위한 INCOTERMS제거

                                    ,A.YYYYMMDD                           AS DEPARTURE_DATE
                                    ,TO_CHAR(TO_DATE(A.YYYYMMDD,'YYYYMMDD') + NVL(B.LT_TOTAL, 0), 'YYYYMMDD')  AS ARRIVAL_DATE
                                    ,A.QTY
                                    ,A.PROJECT_CODE
                            FROM SCP_ANL_SHIPMENT_PLAN_FG A   ----****anl 활용

                            INNER JOIN SCP_MST_BOD_N_V B
                            ON  B.DIVISION_ID    = A.DIVISION_ID
                            AND B.BOD_ID         = A.BOD_ID
                            AND B.FROM_YYYYMMDD <= A.YYYYMMDD    --유효한 기간의 BOD
                            AND B.TO_YYYYMMDD   >= A.YYYYMMDD    --유효한 기간의 BOD


                            INNER JOIN SCM_MST_SITE FS
                            ON  A.DIVISION_ID    = FS.DIVISION_ID
                            AND A.FROM_SITE      = FS.SCM_SITE_ID
                            --AND FS.SITE_TYPE      = 'PLANT'
                            AND FS.VALID_YN      = 'Y'
                            AND ((FS.DIVISION_ID  = '40' AND FS.OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
                                OR  (FS.DIVISION_ID <> '40' AND FS.OPERATION_GROUP IN ('A', 'P') )
                                )

                            INNER JOIN SCM_MST_SITE TS
                            ON  A.DIVISION_ID    = TS.DIVISION_ID
                            AND A.TO_SITE        = TS.SCM_SITE_ID
                            --AND TS.SITE_TYPE      = 'SALES'
                            AND TS.VALID_YN       = 'Y'

                            LEFT JOIN (SELECT DISTINCT DIVISION_ID
                                                      ,ITEM_ID
                                                      ,OPERATION_GROUP
                                                      ,FLOW_ID
                                                      ,ATTRIBUTE8
                                        FROM   SCP_MST_FINAL_ITEM
                                        WHERE  DIVISION_ID = V_DIVISION_ID--@P_DIVISION_ID
                                        AND    OPERATION_GROUP IN ('A', 'P')
                                       ) FI
                            ON    A.ITEM_ID     = FI.ITEM_ID
                            AND   A.DIVISION_ID = FI.DIVISION_ID

                            WHERE A.DIVISION_ID         = V_DIVISION_ID
                            AND   A.PLAN_START_YYYYMMDD = V_REF_PLAN_START_YYYYMMDD
                            --AND   A.plan_type           = 'PR'  --임시
                            AND   A.PLAN_TYPE           = V_REF_PLAN_TYPE
                            AND   A.SEQ                 = V_REF_PLAN_SEQ
                            AND   A.MEASURE             = 'SHIP_PLAN_AMEND'
                            AND   A.QTY                 >  0
                            AND   A.YYYYMMDD            >= V_FRZ_START_DATE
                            AND   A.YYYYMMDD            < V_FRZ_END_DATE
                            AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                            FROM   SCP_OPT_ENG_MODEL_LIST_N_SN
                                            WHERE  PLAN_ID = V_PLAN_ID
                                            )

                          -- Shipment Plan Semi : Plant 향
                        --   2025.06.13 Philsu Park: From Plant = To Plant 인 케이스는 생성 제외.(남혁 선임님 요청)
                          UNION ALL
                            SELECT   NULL                         AS SHIPPING_ORDER_ID
                                    ,A.FROM_SITE                          AS FROM_SITE
                                    ,A.TO_SITE                            AS TO_SITE
                                    ,B.TRANSPORT_MODE                     AS TRANSPORT_MODE
                                    ,A.ITEM_ID                            AS ITEM_ID
                                    ,B.BOD_ID                             AS BOD_ID
                                    ,TS.SITE_TYPE                         AS SITE_TYPE
                                    ,B.INCOTERMS                          AS INCOTERMS
                                    --,'CHAR'                             AS FROM_STAGE
                                    --,'CELL BIZ'                         AS TO_STAGE

                                    ,CASE WHEN FS.OPERATION_GROUP = 'A'                          THEN 'CHAR' -- CELL PLANT 출발
                                        WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P9500' THEN 'PACK' -- PACK PLANT 출발
                                        WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P5500' THEN 'MDLE' -- PACK PLANT 출발
                                        WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLE' -- PACK PLANT 출발
                                     END AS FROM_STAGE
                                    ,CASE WHEN FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'SALES'                          THEN 'CELLBIZ' || '@' || B.INCOTERMS -- CELL PLANT 출발 -> SALES 도착
                                        WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P9500' THEN 'PACKBIZ' || '@' || B.INCOTERMS -- PACK PLANT 출발 -> SALES 도착
                                        WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P5500' THEN 'MDLEBIZ' || '@' || B.INCOTERMS -- PACK PLANT 출발 -> SALES 도착
                                        WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLEBIZ' || '@' || B.INCOTERMS -- PACK PLANT 출발 -> SALES 도착
                                        WHEN A.DIVISION_ID  = '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT' THEN  NULL  -- 소형은 CEll Biz 용 Demand - CELL PLANT 출발 -> PLANT 도착 : To Buffer ID 도 NULL 됨
                                        WHEN A.DIVISION_ID <> '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT' THEN 'CHAR' -- CELL PLANT 출발 -> PLANT 도착
                                        WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P9500' THEN 'PACK' -- PACK PLANT 출발 -> PLANT 도착
                                        WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P5500' THEN 'MDLE' -- PACK PLANT 출발 -> PLANT 도착
                                        WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLE' -- PACK PLANT 출발 -> PLANT 도착
                                     END AS TO_STAGE
                                    ,CASE WHEN FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'SALES'                          THEN 'CELLBIZ'-- INCOTERMS 제거
                                        WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P9500'   THEN 'PACKBIZ'-- INCOTERMS 제거
                                        WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P5500'   THEN 'MDLEBIZ'-- INCOTERMS 제거
                                        WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID NOT IN ('P5500', 'P9500')   THEN 'SUBMDLEBIZ'-- INCOTERMS 제거
                                        WHEN A.DIVISION_ID  = '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT' THEN  NULL  -- 소형은 CEll Biz 용 Demand - CELL PLANT 출발 -> PLANT 도착 : To Buffer ID 도 NULL 됨
                                        WHEN A.DIVISION_ID <> '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT' THEN 'CHAR' -- CELL PLANT 출발 -> PLANT 도착
                                        WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P9500' THEN 'PACK' -- PACK PLANT 출발 -> PLANT 도착
                                        WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P5500' THEN 'MDLE' -- PACK PLANT 출발 -> PLANT 도착
                                        WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLE' -- PACK PLANT 출발 -> PLANT 도착
                                     END AS TO_STAGE_SEMI--ATTRIBUTE 저장을 위해 INCOTERMS제거
                                    ,A.YYYYMMDD                           AS DEPARTURE_DATE
                                    --,CONVERT(CHAR(8), DATEADD(DD, ISNULL(B.LT_TOTAL, 0), CONVERT(DATETIME, A.YYYYMMDD)), 112)  AS ARRIVAL_DATE
                                    ,CASE WHEN A.DIVISION_ID  = '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT'
                                              THEN  A.YYYYMMDD  -- 소형 CEll Biz 용 Demand : 소형 CEll Req 용은 LT 0
                                          ELSE TO_CHAR(TO_DATE(A.YYYYMMDD,'YYYYMMDD') + NVL(B.LT_TOTAL, 0), 'YYYYMMDD')
                                     END AS ARRIVAL_DATE

                                    ,A.QTY
                                    ,'' AS PROJECT_CODE -- UNION을 위한 값이며, 실제로 BUFFER_ID에 넣진 않음.
                            FROM SCP_ANL_SHIPMENT_PLAN_SEMI A

                            INNER JOIN SCP_MST_BOD_N_V B
                            ON  B.DIVISION_ID    = A.DIVISION_ID
                            AND B.BOD_ID         = A.BOD_ID
                            AND B.FROM_YYYYMMDD <= A.YYYYMMDD    --유효한 기간의 BOD
                            AND B.TO_YYYYMMDD   >= A.YYYYMMDD    --유효한 기간의 BOD

                            INNER JOIN SCM_MST_SITE FS
                            ON  A.DIVISION_ID    = FS.DIVISION_ID
                            AND A.FROM_SITE      = FS.SCM_SITE_ID
                            --AND FS.SITE_TYPE      = 'PLANT'
                            AND FS.VALID_YN      = 'Y'
                            AND V_DIVISION_ID  <> '40' -- 소형 CEll Biz 용 Demand 만 처리 : 소형 Cell -> Pack 제외
                            --AND ((FS.DIVISION_ID  = '40' AND FS.OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
                            --  OR  (FS.DIVISION_ID <> '40' AND FS.OPERATION_GROUP IN ('A', 'P') )
                            --  )

                            INNER JOIN SCM_MST_SITE TS
                            ON  A.DIVISION_ID    = TS.DIVISION_ID
                            AND A.TO_SITE        = TS.SCM_SITE_ID
                            --AND TS.SITE_TYPE      = 'SALES'
                            AND TS.VALID_YN       = 'Y'

                            LEFT JOIN (SELECT DISTINCT DIVISION_ID
                                                      ,ITEM_ID
                                                      ,OPERATION_GROUP
                                                      ,FLOW_ID
                                                      ,ATTRIBUTE8
                                        FROM   SCP_MST_FINAL_ITEM
                                        WHERE  DIVISION_ID = V_DIVISION_ID--@P_DIVISION_ID
                                        AND    OPERATION_GROUP IN ('A', 'P')
                                       ) FI
                            ON    A.ITEM_ID     = FI.ITEM_ID
                            AND   A.DIVISION_ID = FI.DIVISION_ID

                            WHERE A.DIVISION_ID         = V_DIVISION_ID
                            AND   A.PLAN_START_YYYYMMDD = V_REF_PLAN_START_YYYYMMDD
                            --AND   A.plan_type           = 'PR' --임시
                            AND   A.PLAN_TYPE           = V_REF_PLAN_TYPE
                            AND   A.SEQ                 = V_REF_PLAN_SEQ
                            AND   A.MEASURE             = 'SHIP_PLAN_AMEND'
                            AND   A.QTY                 >  0
                            AND   A.YYYYMMDD            >= V_FRZ_START_DATE
                            AND   A.YYYYMMDD            < V_FRZ_END_DATE
                            AND   NVL(FS.PLANT_ID, '@NULL@') != NVL(TS.PLANT_ID, '@NULL@') /* 원문 ISNULL(,'') != ISNULL(,'') : Oracle 은 ''=NULL 이므로 센티넬로 치환 */
                            AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                            FROM   SCP_OPT_ENG_MODEL_LIST_N_SN
                                            WHERE  PLAN_ID = V_PLAN_ID
                                            )

                          ) AA
                    GROUP BY SHIPPING_ORDER_ID, FROM_SITE, TO_SITE, TRANSPORT_MODE, ITEM_ID, FROM_STAGE, TO_STAGE, DEPARTURE_DATE, ARRIVAL_DATE, BOD_ID, SITE_TYPE, INCOTERMS,TO_STAGE_SEMI,PROJECT_CODE
                    ) A
                ;
        END IF;
        IF V_SYS_DIVS_CD = 'SSP' THEN
                INSERT INTO GT_ISMB_SM
                (
                    PLAN_ID, SHIPPING_ORDER_ID, FROM_BUFFER_ID, TO_BUFFER_ID, DEPARTURE_DATE, ARRIVAL_DATE
                  , TRANSPORT_MODE, QTY, RESOURCE_ID, LOAD_PER, FROM_SITE, ITEM_ID, FROM_STAGE, TO_SITE
                  , TO_STAGE_SEMI, FENCE_IN_OUT, BOD_ID, SITE_TYPE, INCOTERMS, PROJECT_CODE
                )
                SELECT V_PLAN_ID                              AS PLAN_ID
                      ,SHIPPING_ORDER_ID                      AS SHIPPING_ORDER_ID
                      ,CASE WHEN FROM_STAGE IS NULL THEN NULL ELSE FROM_SITE||'::'||ITEM_ID||'::'||FROM_STAGE END AS FROM_BUFFER_ID
                      ,CASE WHEN TO_STAGE   IS NULL THEN NULL ELSE TO_SITE  ||'::'||ITEM_ID||'::'||TO_STAGE   END AS TO_BUFFER_ID
                      ,DEPARTURE_DATE                         AS DEPARTURE_DATE
                      ,ARRIVAL_DATE                           AS ARRIVAL_DATE
                      ,TRANSPORT_MODE                         AS TRANSPORT_MODE
                      ,QTY                                    AS QTY
                      ,NULL                                   AS RESOURCE_ID
                      ,NULL                                   AS LOAD_PER
                      ,FROM_SITE                              AS FROM_SITE
                      ,ITEM_ID                                AS ITEM_ID
                      ,FROM_STAGE                             AS FROM_STAGE
                      ,TO_SITE                                AS TO_SITE
                      ,TO_STAGE_SEMI                          AS TO_STAGE_SEMI
                      ,'IN'                                   AS FENCE_IN_OUT -- OUT DATA를 넣어줄 때 확정 구간 내에있는 데이터를 구분하기 위한 FLAG
                      ,BOD_ID                                 AS BOD_ID
                      ,SITE_TYPE                              AS SITE_TYPE
                      ,INCOTERMS                              AS INCOTERMS
                      ,PROJECT_CODE                           AS PROJECT_CODE
                FROM(
                    SELECT  ROW_NUMBER() OVER(ORDER BY ITEM_ID) AS SHIPPING_ORDER_ID
                           ,FROM_SITE         AS FROM_SITE
                           ,TO_SITE           AS TO_SITE
                           ,TRANSPORT_MODE    AS TRANSPORT_MODE
                           ,ITEM_ID           AS ITEM_ID
                           ,FROM_STAGE        AS FROM_STAGE
                           ,TO_STAGE          AS TO_STAGE
                           ,DEPARTURE_DATE    AS DEPARTURE_DATE
                           ,ARRIVAL_DATE      AS ARRIVAL_DATE
                           ,SUM(QTY)          AS QTY
                           ,BOD_ID            AS BOD_ID
                           ,SITE_TYPE         AS SITE_TYPE
                           ,INCOTERMS         AS INCOTERMS
                           ,TO_STAGE_SEMI     AS TO_STAGE_SEMI
                           ,PROJECT_CODE      AS PROJECT_CODE
                    FROM (
                            SELECT   NULL                         AS SHIPPING_ORDER_ID
                                    ,SSP.FROM_SITE                          AS FROM_SITE
                                    ,SSP.TO_SITE                            AS TO_SITE
                                    ,B.TRANSPORT_MODE                     AS TRANSPORT_MODE
                                    ,SSP.ITEM_ID                            AS ITEM_ID
                                    ,B.BOD_ID                             AS BOD_ID
                                    ,TS.SITE_TYPE                         AS SITE_TYPE
                                    ,B.INCOTERMS                          AS INCOTERMS
                                    --,'CHAR'                             AS FROM_STAGE
                                    --,'CELL BIZ'                         AS TO_STAGE

                                    ,CASE WHEN FS.OPERATION_GROUP = 'A'                          THEN 'CHAR' -- CELL PLANT 출발
                                        WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P9500' THEN 'PACK' -- PACK PLANT 출발
                                        WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P5500' THEN 'MDLE' -- PACK PLANT 출발
                                        WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLE' -- PACK PLANT 출발
                                     END AS FROM_STAGE
                                    ,CASE WHEN FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'SALES'                          THEN 'CELLBIZ' || '@' || B.INCOTERMS -- CELL PLANT 출발 -> SALES 도착
                                        WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P9500' THEN 'PACKBIZ' || '@' || B.INCOTERMS -- PACK PLANT 출발 -> SALES 도착
                                        WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P5500' THEN 'MDLEBIZ' || '@' || B.INCOTERMS -- PACK PLANT 출발 -> SALES 도착
                                        WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLEBIZ' || '@' || B.INCOTERMS -- PACK PLANT 출발 -> SALES 도착
                                        WHEN SSP.DIVISION_ID = '40'  AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT' THEN  NULL  -- 소형은 CEll Biz 용 Demand - CELL PLANT 출발 -> PLANT 도착 : To Buffer ID 도 NULL 됨
                                        WHEN SSP.DIVISION_ID <> '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT' THEN 'CHAR' -- CELL PLANT 출발 -> PLANT 도착
                                        WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P9500' THEN 'PACK' -- PACK PLANT 출발 -> PLANT 도착
                                        WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P5500' THEN 'MDLE' -- PACK PLANT 출발 -> PLANT 도착
                                        WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLE' -- PACK PLANT 출발 -> PLANT 도착
                                     END AS TO_STAGE
                                    ,CASE WHEN FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'SALES'                          THEN 'CELLBIZ' -- INCOTERMS 제거
                                        WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P9500' THEN 'PACKBIZ'   -- INCOTERMS 제거
                                        WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P5500' THEN 'MDLEBIZ'   -- INCOTERMS 제거
                                        WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLEBIZ'   -- INCOTERMS 제거
                                        WHEN SSP.DIVISION_ID = '40'  AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT' THEN  NULL  -- 소형은 CEll Biz 용 Demand - CELL PLANT 출발 -> PLANT 도착 : To Buffer ID 도 NULL 됨
                                        WHEN SSP.DIVISION_ID <> '40' AND FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT' THEN 'CHAR' -- CELL PLANT 출발 -> PLANT 도착
                                        WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P9500' THEN 'PACK' -- PACK PLANT 출발 -> PLANT 도착
                                        WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P5500' THEN 'MDLE' -- PACK PLANT 출발 -> PLANT 도착
                                        WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLE' -- PACK PLANT 출발 -> PLANT 도착
                                     END AS TO_STAGE_SEMI -- ATTRIBUTE 저장을 위한 INCOTERMS제거

                                    ,SSP.YYYYMMDD                           AS DEPARTURE_DATE
                                    ,TO_CHAR(TO_DATE(SSP.YYYYMMDD,'YYYYMMDD') + NVL(B.LT_TOTAL, 0), 'YYYYMMDD')  AS ARRIVAL_DATE
                                    ,SSP.QTY
                                    ,SSP.PROJECT_CODE
                            FROM    SCM_DNM_SSP_PLAN_V SSP
                                INNER JOIN(SELECT  DIVISION_ID
                                                  ,SCM_SITE_ID
                                                  ,TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD,'YYYYMMDD') + NVL(MAX(SHIP_FROZEN),0),'YYYYMMDD') AS SSP_CONFIRM_DATE
                                           FROM    SCM_MST_SITE
                                           WHERE   DIVISION_ID = V_DIVISION_ID
                                           GROUP BY DIVISION_ID, SCM_SITE_ID
                                           ) SMS
                                    ON  SSP.DIVISION_ID = SMS.DIVISION_ID
                                    AND SSP.FROM_SITE   = SMS.SCM_SITE_ID
                                INNER JOIN SCP_MST_BOD_N_V B
                                    ON  B.DIVISION_ID    = SSP.DIVISION_ID
                                    AND B.BOD_ID         = SSP.BOD_ID
                                    AND B.FROM_YYYYMMDD <= SSP.YYYYMMDD    --유효한 기간의 BOD
                                    AND B.TO_YYYYMMDD   >= SSP.YYYYMMDD    --유효한 기간의 BOD
                                --속도 개선을 위해 UNION ALL로 변경
                                INNER JOIN (
                                            SELECT  DIVISION_ID
                                                   ,SCM_SITE_ID
                                                   ,OPERATION_GROUP
                                            FROM    SCM_MST_SITE
                                            WHERE   1=1
                                            AND     VALID_YN = 'Y'
                                            AND     DIVISION_ID = '40'
                                            AND     OPERATION_GROUP = 'A'
                                            UNION ALL
                                            SELECT  DIVISION_ID
                                                   ,SCM_SITE_ID
                                                   ,OPERATION_GROUP
                                            FROM    SCM_MST_SITE
                                            WHERE   1=1
                                            AND     VALID_YN = 'Y'
                                            AND     DIVISION_ID != '40'
                                            AND     OPERATION_GROUP IN('A','P')
                                            ) FS
                                    ON  1=1
                                    AND SSP.DIVISION_ID    = FS.DIVISION_ID
                                    AND SSP.FROM_SITE      = FS.SCM_SITE_ID
                                INNER JOIN SCM_MST_SITE TS
                                    ON  SSP.DIVISION_ID    = TS.DIVISION_ID
                                    AND SSP.TO_SITE        = TS.SCM_SITE_ID
                                    --AND TS.SITE_TYPE      = 'SALES'
                                    AND TS.VALID_YN       = 'Y'
                                LEFT JOIN (SELECT DISTINCT DIVISION_ID
                                                          ,ITEM_ID
                                                          ,OPERATION_GROUP
                                                          ,FLOW_ID
                                                          ,ATTRIBUTE8
                                            FROM   SCP_MST_FINAL_ITEM
                                            WHERE  DIVISION_ID = V_DIVISION_ID--@P_DIVISION_ID
                                            AND    OPERATION_GROUP IN ('A', 'P')
                                           ) FI
                                    ON    SSP.ITEM_ID     = FI.ITEM_ID
                                    AND   SSP.DIVISION_ID = FI.DIVISION_ID
                            WHERE SSP.DIVISION_ID         = V_DIVISION_ID
                            AND   SSP.QTY                 >  0
                            AND   SSP.YYYYMMDD            >= V_FRZ_START_DATE
                            AND   SSP.YYYYMMDD            < V_FRZ_END_DATE
                            AND   SSP.SSP_TYPE = CASE WHEN SSP.YYYYMMDD>=SMS.SSP_CONFIRM_DATE THEN 'REQ' ELSE 'CFM' END
                            AND   SSP.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                            FROM   SCP_OPT_ENG_MODEL_LIST_N_SN
                                            WHERE  PLAN_ID = V_PLAN_ID
                                            )
                          ) AA
                    GROUP BY SHIPPING_ORDER_ID, FROM_SITE, TO_SITE, TRANSPORT_MODE, ITEM_ID, FROM_STAGE, TO_STAGE, DEPARTURE_DATE, ARRIVAL_DATE, BOD_ID, SITE_TYPE, INCOTERMS,TO_STAGE_SEMI,PROJECT_CODE
                    ) A
                ;
        END IF;
    -------------------------------------------------
    --PROJECT CODE가 없는 데이터 DEMAND에서 찾아서 UPDATE
    -------------------------------------------------
    -- START 2025-12-15 jongykim2: Demand Group Master
    INSERT INTO GT_ISMB_DEMAND_GROUP
    (
        DIVISION_ID, ITEM_ID, DEMAND_GROUP, PROJECT_CODE
    )
    SELECT T2.DIVISION_ID
         , T2.ITEM_ID
         , T.GROUP_NAME AS DEMAND_GROUP
         , T2.PROJECT_CODE
    FROM   SCP_MST_ITEM_GROUP T
    INNER JOIN SCP_MST_ITEM_GROUP_DETAIL T2
    ON     T2.DIVISION_ID = T.DIVISION_ID
    AND    T2.GROUP_ID = T.GROUP_ID
    WHERE  1 = 1
    AND    T.DIVISION_ID = V_DIVISION_ID
    AND    T.VALID_YN = 'Y'
    AND    NVL(T.ATTRIBUTE1, 'N') <> 'Y'
    AND    T2.VALID_YN = 'Y'
    ;
    -- END 2025-12-15 jongykim2:

    /* 원문은 UPDATE @SM_TEMP ... FROM 조인 형태. Oracle 은 UPDATE JOIN 불가이므로 MERGE 로 전환.
       SM_TEMP 한 행에 복수 DM 행이 매칭되면 MSSQL 은 임의 1건으로 갱신하나 Oracle MERGE 는 ORA-30926 발생.
       PLAN_ID + SHIPPING_ORDER_ID 로 소스를 1건으로 축약(RN=1)하여 동일 의미를 결정적으로 보장한다. */
    MERGE INTO GT_ISMB_SM SMT
    USING (
            SELECT PLAN_ID
                  ,SHIPPING_ORDER_ID
                  ,FROM_BUFFER_ID
                  ,TO_BUFFER_ID
                  ,DEPARTURE_DATE
                  ,ARRIVAL_DATE
                  ,TRANSPORT_MODE
                  ,QTY
                  ,RESOURCE_ID
                  ,LOAD_PER
                  ,FROM_SITE
                  ,ITEM_ID
                  ,MDF_ITEM_ID
                  ,FROM_STAGE
                  ,TO_SITE
                  ,TO_STAGE_SEMI
                  ,FENCE_IN_OUT
                  ,BOD_ID
                  ,SITE_TYPE
                  ,INCOTERMS
                  ,PROJECT_CODE
              FROM (
                    SELECT SMT.PLAN_ID
                          ,SMT.SHIPPING_ORDER_ID
                          ,SMT.FROM_BUFFER_ID
                          ,SMT.TO_BUFFER_ID
                          ,SMT.DEPARTURE_DATE
                          ,SMT.ARRIVAL_DATE
                          ,SMT.TRANSPORT_MODE
                          ,SMT.QTY
                          ,SMT.RESOURCE_ID
                          ,SMT.LOAD_PER
                          ,SMT.FROM_SITE
                          ,SMT.ITEM_ID
                          ,SMT.MDF_ITEM_ID
                          ,SMT.FROM_STAGE
                          ,SMT.TO_SITE
                          ,SMT.TO_STAGE_SEMI
                          ,SMT.FENCE_IN_OUT
                          ,SMT.BOD_ID
                          ,SMT.SITE_TYPE
                          ,SMT.INCOTERMS
                          ,DT.PROJECT_CODE
                          ,ROW_NUMBER() OVER( PARTITION BY SMT.PLAN_ID, SMT.SHIPPING_ORDER_ID ORDER BY DT.PROJECT_CODE ) AS RN
                    FROM(
                         SELECT SMT.PLAN_ID
                               ,SMT.SHIPPING_ORDER_ID
                               ,SMT.FROM_BUFFER_ID
                               ,SMT.TO_BUFFER_ID
                               ,SMT.DEPARTURE_DATE
                               ,SMT.ARRIVAL_DATE
                               ,SMT.TRANSPORT_MODE
                               ,SMT.QTY
                               ,SMT.RESOURCE_ID
                               ,SMT.LOAD_PER
                               ,SMT.FROM_SITE
                               ,SMT.ITEM_ID
                               --,IIF(LU.SEGMENT3 IS NULL, SMT.ITEM_ID, LU.SEGMENT4) AS MDF_ITEM_ID
                               ,CASE WHEN LU.ITEM_ID IS NULL THEN SMT.ITEM_ID ELSE LU.DEMAND_GROUP END AS MDF_ITEM_ID
                               ,SMT.FROM_STAGE
                               ,SMT.TO_SITE
                               ,SMT.TO_STAGE_SEMI
                               ,SMT.FENCE_IN_OUT
                               ,SMT.BOD_ID
                               ,SMT.SITE_TYPE
                               ,SMT.INCOTERMS
                               ,SMT.PROJECT_CODE
                         FROM    GT_ISMB_SM SMT
                             /*LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                 ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                 AND LU.SEGMENT2 = @V_DIVISION_ID
                                 AND SMT.ITEM_ID = LU.SEGMENT3
                                 AND LU.VALID_YN = 'Y'*/ -- blocked 2025-12-15 jongykim2
                                 -- Added 2025-12-15 jongykim2: Demand Group Master
                                 LEFT OUTER JOIN GT_ISMB_DEMAND_GROUP LU
                                 ON  SMT.ITEM_ID = LU.ITEM_ID
                         WHERE   1=1
                         AND     SMT.PROJECT_CODE = '-'
                         ) SMT
                        INNER JOIN GT_ISMB_DM DT
                            ON  SMT.TO_SITE = DT.SITE_ID
                            AND SMT.MDF_ITEM_ID     = DT.ITEM_ID
                            AND (   (SMT.INCOTERMS IS NULL AND DT.INCOTERMS IS NULL)
                                 OR (SMT.INCOTERMS = DT.INCOTERMS)
                                 OR (SMT.INCOTERMS IS NOT NULL AND DT.INCOTERMS IS NULL)
                                )
                   )
            WHERE RN = 1
          ) DJ
       ON (    SMT.PLAN_ID                = DJ.PLAN_ID
           AND SMT.SHIPPING_ORDER_ID      = DJ.SHIPPING_ORDER_ID
           AND SMT.FROM_BUFFER_ID         = DJ.FROM_BUFFER_ID
           AND SMT.TO_BUFFER_ID           = DJ.TO_BUFFER_ID
           AND SMT.DEPARTURE_DATE         = DJ.DEPARTURE_DATE
           AND SMT.ARRIVAL_DATE           = DJ.ARRIVAL_DATE
           AND SMT.TRANSPORT_MODE         = DJ.TRANSPORT_MODE
           AND SMT.QTY                    = DJ.QTY
           AND NVL(SMT.RESOURCE_ID,'@NULL@') = NVL(DJ.RESOURCE_ID,'@NULL@')
           AND NVL(SMT.LOAD_PER   ,'@NULL@') = NVL(DJ.LOAD_PER   ,'@NULL@')
           AND SMT.FROM_SITE              = DJ.FROM_SITE
           AND SMT.ITEM_ID                = DJ.ITEM_ID
           AND SMT.FROM_STAGE             = DJ.FROM_STAGE
           AND SMT.TO_SITE                = DJ.TO_SITE
           AND SMT.TO_STAGE_SEMI          = DJ.TO_STAGE_SEMI
           AND SMT.FENCE_IN_OUT           = DJ.FENCE_IN_OUT
           AND SMT.BOD_ID                 = DJ.BOD_ID
           AND SMT.SITE_TYPE              = DJ.SITE_TYPE
           AND SMT.INCOTERMS              = DJ.INCOTERMS )
    WHEN MATCHED THEN
        UPDATE SET SMT.PROJECT_CODE = DJ.PROJECT_CODE
    ;

    -------------------------------------------------
    --TO_BUFFER에 PROJECT_CODE 추가해서 INSERT
    -------------------------------------------------
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
                                           ,ATTRIBUTE1
                                           ,ATTRIBUTE2
                                           ,ATTRIBUTE3
                                           ,ATTRIBUTE4
                                           ,ATTRIBUTE5
                                           ,ATTRIBUTE6
                                           ,ATTRIBUTE7
                                           ,ATTRIBUTE8
                                           ,ATTRIBUTE9
                                           ,ATTRIBUTE10
                                          )
    SELECT  ST.PLAN_ID
           ,ST.SHIPPING_ORDER_ID
           ,ST.FROM_BUFFER_ID
           ,ST.TO_BUFFER_ID||CASE WHEN ST.PROJECT_CODE IS NULL THEN '' ELSE '@'||ST.PROJECT_CODE END||CASE WHEN CPS.ITEM_ID IS NULL THEN '' ELSE '::'||ST.FROM_SITE END
           ,ST.DEPARTURE_DATE
           ,ST.ARRIVAL_DATE
           ,ST.TRANSPORT_MODE
           ,ST.QTY
           ,ST.RESOURCE_ID
           ,ST.LOAD_PER
           ,ST.FROM_SITE
           ,ST.ITEM_ID
           ,ST.FROM_STAGE
           ,ST.TO_SITE
           ,ST.TO_STAGE_SEMI
           ,ST.FENCE_IN_OUT
           ,ST.BOD_ID
           ,ST.SITE_TYPE
           ,ST.INCOTERMS
           ,ST.PROJECT_CODE
    FROM    GT_ISMB_SM ST
        LEFT OUTER JOIN GT_ISMB_CELL_PROD_SITE CPS
            ON  1=1
            AND ST.TO_SITE = CPS.SALES_SITE_ID
            AND ST.ITEM_ID = CPS.ITEM_ID
    WHERE   1=1
    AND     ST.FROM_BUFFER_ID IS NOT NULL
    AND     ST.TO_BUFFER_ID   IS NOT NULL
    ;

    ------------------------------------------------------------------------
    -- 전진검사 A TYPE 적용
    ------------------------------------------------------------------------
    --0. 만들어진 데이터의 MAX SEQ를 찾기위한 변수 설정
    SELECT MAX(TO_NUMBER(SHIPPING_ORDER_ID))
      INTO V_MAX_NUM
      FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN
     WHERE PLAN_ID = V_PLAN_ID;

    --3. 기존 SM 삭제
    DELETE FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN
    WHERE   1=1
    AND     PLAN_ID = V_PLAN_ID
    AND     ATTRIBUTE15 = 'DELETE'
    ;

        /* 정상 경로 종료 : 원문 BEGIN/COMMIT TRAN 은 주석이나, MSSQL 자동커밋과 동일하게 반영 확정 */
        COMMIT;

    EXCEPTION
        ------------------------------------------------------------------------
        -- ERROR LOG
        ------------------------------------------------------------------------
        WHEN OTHERS THEN
            V_MESSAGE_TEXT := SUBSTR(SQLERRM, 1, 1000);
            IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
                ROLLBACK;   /* 실패 스텝의 미완성 데이터 제거 */
            END IF;
            PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'ERROR',NULL,V_MESSAGE_TEXT,NULL,V_PLAN_ID);
            PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,SYSDATE,NULL,V_MESSAGE_TEXT,'ERROR');
            COMMIT;         /* 로그 보존 — 아래 참고 */
            RAISE_APPLICATION_ERROR(-20001, V_PROGRAM_NAME);
    END;

    ------------------------------------------------------------------------
    -- 종료 LOG
    ------------------------------------------------------------------------
    IF V_MESSAGE_TEXT IS NULL THEN
        PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'END',NULL,NULL,NULL,V_PLAN_ID);
        PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,NULL,NULL,NULL,NULL);
    END IF;
END;