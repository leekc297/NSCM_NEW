PROCEDURE         PR_SCP_OPT_ENG_INPUT_BOD_BATCH
(
    P_PLAN_ID               IN VARCHAR2 DEFAULT NULL
  , P_DIVISION_ID           IN VARCHAR2 DEFAULT NULL
  , P_GROUP_ID              IN VARCHAR2 DEFAULT NULL
  , P_PLAN_START_YYYYMMDD   IN VARCHAR2 DEFAULT NULL
  , P_PLAN_END_YYYYMMDD     IN VARCHAR2 DEFAULT NULL
)
IS
/*
 * Program ID   : PR_SCP_OPT_ENG_INPUT_BOD_BATCH
 * Description  : 최적화 엔진 입력용 BOD(배송경로) 데이터를 생성하여 SCP_OPT_ENG_BOD_SN 에 적재한다.
 *                - 유효 BOD 를 출발/도착 Stage 로 가공하고 요일별 Lead Time 을 산출한다.
 *                - BOD Blocking(제외 구간) 이 있는 BOD 는 날짜 구간을 분할하여 생성한다.
 *                - Demand Group BOD 및 Packing Equipment 대상 BOD 를 추가 생성한다.
 *
 * Program History
 *===================================================================================================
 *   Date         In Charge   Description
 *===================================================================================================
 * 2025.02.11     TAEHYUN     Initial Release
 * 2026.10.07     JCH         MSSQL -> Oracle 전환
 */
    V_PROGRAM_NAME          VARCHAR2(150 CHAR)  := 'PR_SCP_OPT_ENG_INPUT_BOD_BATCH';
    V_PLAN_ID               VARCHAR2(50 CHAR)   := P_PLAN_ID;
    V_DIVISION_ID           VARCHAR2(20 CHAR)   := P_DIVISION_ID;
    V_GROUP_ID              VARCHAR2(20 CHAR)   := P_GROUP_ID;
    V_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR)    := P_PLAN_START_YYYYMMDD;
    V_PLAN_END_YYYYMMDD     VARCHAR2(8 CHAR)    := P_PLAN_END_YYYYMMDD;

    V_MESSAGE_TEXT          VARCHAR2(1000 CHAR);
    V_DETAIL_DATE           DATE;

    /* Set Param for Biz */
    V_P_PLAN_NAME           VARCHAR2(8 CHAR);
    V_D_PLAN_NAME           DATE;
    V_SHIP_FROZEN           NUMBER;
BEGIN

    /* Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성 (시작 로그) */
    PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'START', NULL, NULL, NULL, V_PLAN_ID);

    /* Transaction (START) */
    BEGIN
        /* 작업용 임시 테이블 초기화 (GTT 는 TRUNCATE 대신 DELETE 로 비운다) */
        DELETE FROM GT_OPT_INPUT_BOD_PKEQ;
        DELETE FROM GT_OPT_INPUT_BOD_CPS;
        DELETE FROM GT_OPT_INPUT_BOD_TMP;
        DELETE FROM GT_OPT_INPUT_BOD_INS;

        /* SET Param */
        /* 해당 주 월요일 YYYYMMDD */
        V_P_PLAN_NAME := TO_CHAR(FN_NEXT_DAY(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD');
        V_D_PLAN_NAME := TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD');

        /* 2025.06.19 김태현 : FROZEN 신규 테이블을 바라보도록 수정 */
        SELECT  MAX(FROZEN_DAYS)
          INTO  V_SHIP_FROZEN
          FROM  SCP_OPT_ENG_FROZEN_MASTER_SN
         WHERE  1 = 1
           AND  PLAN_ID     = V_PLAN_ID
           AND  FROZEN_TYPE = 'SHIP';

        ------------------------------------------------------------------------------------------
        -- 2025.05.20 Philsu Park: Packing Equipment Temp 생성.
        -- Model 별 Input: Model GROUP 단위로 동일 MIN, MAX 적용.
        -- 2025.05.28 Philsu Park: TO_DATE는 하루 더해줌.
        -- 2025.07.24 Philsu Park: Plan Horizon 내에 해당하는 PACKING EQP 정보만 추출.
        ------------------------------------------------------------------------------------------
        INSERT INTO GT_OPT_INPUT_BOD_PKEQ
        (
            DIVISION
          , PLAN_GROUP
          , MODEL
          , MODEL_GROUP
          , FROM_SITE
          , STAGE
          , TO_SITE
          , FROM_DATE
          , TO_DATE
          , LOWER_QTY
          , UPPER_QTY
        )
        WITH MODEL_GROUP AS
        (
                -- 2025.11.24 Minyong Lee : Lookup -> UI 전환 (Packing Equipment)
                SELECT    CS.DIVISION_ID                                 AS DIVISION
                        , V_GROUP_ID                                     AS PLAN_GROUP
                        , CS.MDL_GR_NM                                   AS MODEL_GROUP
                        , GREATEST(V_PLAN_START_YYYYMMDD, MIN(CS.FROM_YYYYMMDD))                                            AS FROM_DATE
                        , LEAST(V_PLAN_END_YYYYMMDD, TO_CHAR(TO_DATE(MAX(CS.TO_YYYYMMDD), 'YYYYMMDD') + 1, 'YYYYMMDD'))     AS TO_DATE
                        , MIN(CS.SIPM_MIN_QYT)                           AS LOWER_QTY
                        , MAX(CS.SIPM_MAX_QTY)                           AS UPPER_QTY
                FROM    SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY CS
                WHERE   1=1
                AND     CS.VALID_YN          = 'Y'
                AND     CS.DIVISION_ID       = V_DIVISION_ID
                AND     1=1 /* _BATCH T3: 계획그룹 필터 제거(사업부 전체) */
                GROUP BY CS.DIVISION_ID, CS.MDL_GR_NM
        )
        -- 2025.11.24 Minyong Lee : Lookup -> UI 전환 (Packing Equipment)
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

        ------------------------------------------------------------------------
        -- 셀 생산지 버퍼 추가
        ------------------------------------------------------------------------
        INSERT INTO GT_OPT_INPUT_BOD_CPS
        SELECT  SEGMENT3 AS SALES_SITE_ID
               ,SEGMENT4 AS ITEM_ID
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL
        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CELL_PROD_SITE'
        AND     SEGMENT1 = V_DIVISION_ID
        AND     SEGMENT2 = V_GROUP_ID
        ;

        ------------------------------------------------------------------------
        -- BOD DATA INSERT TO TEMP TABLE (속도 ISSUE)
        ------------------------------------------------------------------------
        INSERT INTO GT_OPT_INPUT_BOD_TMP
        SELECT  PLAN_ID
               ,BOD_ID
               ,FROM_BUFFER_ID
               ,TO_BUFFER_ID
               ,TRANSPORT_MODE
               --,PRIORITY
               ,RANK() OVER ( PARTITION BY BOD.FROM_BUFFER_ID, BOD.TO_BUFFER_ID ORDER BY BOD.PRIORITY) AS PRIORITY
               ,TRANSIT_COST
               ,EFF_START_DATE
               ,EFF_END_DATE
               ,DEFAULT_LEAD_TIME
               ,SUNDAY_LEAD_TIME
               ,MONDAY_LEAD_TIME
               ,TUESDAY_LEAD_TIME
               ,WEDNESDAY_LEAD_TIME
               ,THURSDAY_LEAD_TIME
               ,FRIDAY_LEAD_TIME
               ,SATURDAY_LEAD_TIME
               ,RESOURCE_ID
               ,LOAD_PER
               ,CONTAINER_CATEGORY
               ,CONTAINER_SIZE
               ,TYPE
               ,ATTRIBUTE1
               ,ATTRIBUTE2
               ,ATTRIBUTE3
               ,ATTRIBUTE4
               ,ATTRIBUTE5
               ,ATTRIBUTE6
               ,ATTRIBUTE7
               ,ATTRIBUTE8
               ,ATTRIBUTE9
        FROM(
             SELECT V_PLAN_ID                                                      AS PLAN_ID
                   ,TRANSPORT_MODE||'::'||FROM_SITE||'::'||BOD.ITEM_ID||'::'||FROM_STAGE
                    ||'::'||TO_SITE||'::'||BOD.ITEM_ID||'::'||TO_STAGE
                    ||CASE WHEN ITS.ATTRIBUTE2 IS NULL THEN '' ELSE '@'||ITS.ATTRIBUTE2 END||'::'||BOD_ID AS BOD_ID
                   ,FROM_SITE||'::'||BOD.ITEM_ID||'::'||FROM_STAGE                  AS FROM_BUFFER_ID
                   ,TO_SITE||'::'||BOD.ITEM_ID||'::'||TO_STAGE
                   ||CASE WHEN ITS.ATTRIBUTE2 IS NULL THEN '' ELSE '@' ||ITS.ATTRIBUTE2 END
                   ||CASE WHEN CPS.ITEM_ID    IS NULL THEN '' ELSE '::'||FROM_SITE      END AS TO_BUFFER_ID --------******
                   ,TRANSPORT_MODE                                                  AS TRANSPORT_MODE
                   ,PRIORITY                                                        AS PRIORITY
                   ,NULL                                                            AS TRANSIT_COST
                   ,EFF_START                                                       AS EFF_START_DATE
                   ,EFF_END                                                         AS EFF_END_DATE
                   ,LT_TOTAL                                                        AS DEFAULT_LEAD_TIME
                   ,CASE WHEN SUN_DE = 1 THEN NVL(LT_TOTAL, 0)
                         WHEN MON_DE = 1 THEN NVL(LT_TOTAL, 0)
                         WHEN TUE_DE = 1 THEN NVL(LT_TOTAL, 0)
                         WHEN WED_DE = 1 THEN NVL(LT_TOTAL, 0)
                         WHEN THU_DE = 1 THEN NVL(LT_TOTAL, 0)
                         WHEN FRI_DE = 1 THEN NVL(LT_TOTAL, 0)
                         WHEN SAT_DE = 1 THEN NVL(LT_TOTAL, 0)
                         ELSE NULL
                    END AS SUNDAY_LEAD_TIME
                   ,CASE WHEN SUN_DE = 2 THEN NVL(LT_TOTAL, 0)
                         WHEN MON_DE = 2 THEN NVL(LT_TOTAL, 0)
                         WHEN TUE_DE = 2 THEN NVL(LT_TOTAL, 0)
                         WHEN WED_DE = 2 THEN NVL(LT_TOTAL, 0)
                         WHEN THU_DE = 2 THEN NVL(LT_TOTAL, 0)
                         WHEN FRI_DE = 2 THEN NVL(LT_TOTAL, 0)
                         WHEN SAT_DE = 2 THEN NVL(LT_TOTAL, 0)
                         ELSE NULL
                    END AS MONDAY_LEAD_TIME
                   ,CASE WHEN SUN_DE = 3 THEN NVL(LT_TOTAL, 0)
                         WHEN MON_DE = 3 THEN NVL(LT_TOTAL, 0)
                         WHEN TUE_DE = 3 THEN NVL(LT_TOTAL, 0)
                         WHEN WED_DE = 3 THEN NVL(LT_TOTAL, 0)
                         WHEN THU_DE = 3 THEN NVL(LT_TOTAL, 0)
                         WHEN FRI_DE = 3 THEN NVL(LT_TOTAL, 0)
                         WHEN SAT_DE = 3 THEN NVL(LT_TOTAL, 0)
                         ELSE NULL
                    END AS TUESDAY_LEAD_TIME
                   ,CASE WHEN SUN_DE = 4 THEN NVL(LT_TOTAL, 0)
                         WHEN MON_DE = 4 THEN NVL(LT_TOTAL, 0)
                         WHEN TUE_DE = 4 THEN NVL(LT_TOTAL, 0)
                         WHEN WED_DE = 4 THEN NVL(LT_TOTAL, 0)
                         WHEN THU_DE = 4 THEN NVL(LT_TOTAL, 0)
                         WHEN FRI_DE = 4 THEN NVL(LT_TOTAL, 0)
                         WHEN SAT_DE = 4 THEN NVL(LT_TOTAL, 0)
                         ELSE NULL
                    END AS WEDNESDAY_LEAD_TIME
                   ,CASE WHEN SUN_DE = 5 THEN NVL(LT_TOTAL, 0)
                         WHEN MON_DE = 5 THEN NVL(LT_TOTAL, 0)
                         WHEN TUE_DE = 5 THEN NVL(LT_TOTAL, 0)
                         WHEN WED_DE = 5 THEN NVL(LT_TOTAL, 0)
                         WHEN THU_DE = 5 THEN NVL(LT_TOTAL, 0)
                         WHEN FRI_DE = 5 THEN NVL(LT_TOTAL, 0)
                         WHEN SAT_DE = 5 THEN NVL(LT_TOTAL, 0)
                         ELSE NULL
                    END AS THURSDAY_LEAD_TIME
                   ,CASE WHEN SUN_DE = 6 THEN NVL(LT_TOTAL, 0)
                         WHEN MON_DE = 6 THEN NVL(LT_TOTAL, 0)
                         WHEN TUE_DE = 6 THEN NVL(LT_TOTAL, 0)
                         WHEN WED_DE = 6 THEN NVL(LT_TOTAL, 0)
                         WHEN THU_DE = 6 THEN NVL(LT_TOTAL, 0)
                         WHEN FRI_DE = 6 THEN NVL(LT_TOTAL, 0)
                         WHEN SAT_DE = 6 THEN NVL(LT_TOTAL, 0)
                         ELSE NULL
                    END AS FRIDAY_LEAD_TIME
                   ,CASE WHEN SUN_DE = 7 THEN NVL(LT_TOTAL, 0)
                         WHEN MON_DE = 7 THEN NVL(LT_TOTAL, 0)
                         WHEN TUE_DE = 7 THEN NVL(LT_TOTAL, 0)
                         WHEN WED_DE = 7 THEN NVL(LT_TOTAL, 0)
                         WHEN THU_DE = 7 THEN NVL(LT_TOTAL, 0)
                         WHEN FRI_DE = 7 THEN NVL(LT_TOTAL, 0)
                         WHEN SAT_DE = 7 THEN NVL(LT_TOTAL, 0)
                         ELSE NULL
                    END AS SATURDAY_LEAD_TIME
                   ,NULL                                                       AS RESOURCE_ID
                   ,NULL                                                       AS LOAD_PER
                   ,NULL                                                       AS CONTAINER_CATEGORY
                   ,NULL                                                       AS CONTAINER_SIZE
                   ,NULL                                                       AS TYPE
                   ,FROM_SITE                                                  AS ATTRIBUTE1
                   ,BOD.ITEM_ID                                                AS ATTRIBUTE2
                   ,FROM_STAGE                                                 AS ATTRIBUTE3
                   ,TO_SITE                                                    AS ATTRIBUTE4
                   ,TO_STAGE                                                   AS ATTRIBUTE5
                   ,INCOTERMS                                                  AS ATTRIBUTE6
                   ,BOD_ID                                                     AS ATTRIBUTE7
                   ,BOD_TYPE                                                   AS ATTRIBUTE8
                   ,ITS.ATTRIBUTE2                                             AS ATTRIBUTE9
             FROM(
                  SELECT FROM_SITE
                        ,TO_SITE
                        ,TRANSPORT_MODE
                        ,ITEM_ID
                        ,FROM_STAGE
                        ,TO_STAGE
                        -- ,EFF_START
                        ,CASE WHEN (FROM_STAGE = 'CHAR' AND TO_STAGE = 'CHAR' AND FROM_PLANT_ID = TO_PLANT_ID)
                                THEN LEAST(EFF_START, GREATEST(FROM_YYYYMMDD, V_PLAN_START_YYYYMMDD))
                                ELSE EFF_START
                                END AS EFF_START
                        ,EFF_END
                        ,PRIORITY
                        ,LT_TOTAL
                        ,SUN_LT
                        ,MON_LT
                        ,TUE_LT
                        ,WED_LT
                        ,THU_LT
                        ,FRI_LT
                        ,SAT_LT
                        ,SUN_DE
                        ,MON_DE
                        ,TUE_DE
                        ,WED_DE
                        ,THU_DE
                        ,FRI_DE
                        ,SAT_DE
                        ,INCOTERMS
                        ,BOD_ID
                        ,BOD_TYPE
                  FROM (
                      SELECT B.FROM_SITE
                            ,B.TO_SITE, B.TRANSPORT_MODE
                            ,BIE.ITEM_ID AS ITEM_ID
                            ,CASE WHEN FS.OPERATION_GROUP = 'A'                          THEN 'CHAR' -- CELL PLANT 출발
                                  WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P9500' THEN 'PACK' -- PACK PLANT 출발
                                  WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P5500' THEN 'MDLE' -- PACK PLANT 출발
                                  WHEN FS.OPERATION_GROUP = 'P' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLE' -- PACK PLANT 출발
                             END AS FROM_STAGE
                            ,CASE WHEN FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'SALES'                          THEN 'CELLBIZ' || '@' || B.INCOTERMS -- CELL PLANT 출발 -> SALES 도착
                                  WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P9500' THEN 'PACKBIZ' || '@' || B.INCOTERMS -- PACK PLANT 출발 -> SALES 도착
                                  WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P5500' THEN 'MDLEBIZ' || '@' || B.INCOTERMS -- PACK PLANT 출발 -> SALES 도착
                                  WHEN FS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLEBIZ' || '@' || B.INCOTERMS -- PACK PLANT 출발 -> SALES 도착
                                  WHEN FS.OPERATION_GROUP = 'A' AND TS.SITE_TYPE = 'PLANT'                          THEN 'CHAR' -- CELL PLANT 출발 -> PLANT 도착
                                  WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P9500' THEN 'PACK' -- PACK PLANT 출발 -> PLANT 도착
                                  WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P5500' THEN 'MDLE' -- PACK PLANT 출발 -> PLANT 도착
                                  WHEN TS.OPERATION_GROUP = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLE' -- PACK PLANT 출발 -> PLANT 도착
                             END AS TO_STAGE
                            -- (Plan 시작일자 + Ship Frozen) 과 BOD의 FROM YYYYMMDD 중 큰 일자를 EFF_START 로 지정
                            ,CASE WHEN B.FROM_YYYYMMDD >= TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + NVL(V_SHIP_FROZEN, 0), 'YYYYMMDD')
                                  THEN B.FROM_YYYYMMDD
                                  ELSE TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + NVL(V_SHIP_FROZEN, 0), 'YYYYMMDD')
                             END AS EFF_START
                            -- [(Plan 시작일자 + Ship Frozen) 과 BOD의 TO YYYYMMDD 중 큰 일자]와 V_PLAN_END_YYYYMMDD 중 작은 일자를 EFF_END 로 지정
                            ,CASE WHEN ( CASE WHEN B.TO_YYYYMMDD >= TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + NVL(V_SHIP_FROZEN, 0), 'YYYYMMDD')
                                              THEN B.TO_YYYYMMDD
                                              ELSE TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + NVL(V_SHIP_FROZEN, 0), 'YYYYMMDD')
                                         END ) <= V_PLAN_END_YYYYMMDD
                                  THEN TO_CHAR(TO_DATE( CASE WHEN B.TO_YYYYMMDD >= TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + NVL(V_SHIP_FROZEN, 0), 'YYYYMMDD')
                                                             THEN B.TO_YYYYMMDD
                                                             ELSE TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + NVL(V_SHIP_FROZEN, 0), 'YYYYMMDD')
                                                        END, 'YYYYMMDD') + 1, 'YYYYMMDD')
                                  ELSE V_PLAN_END_YYYYMMDD
                             END AS EFF_END
                            ,B.PRIORITY
                            ,NVL(B.LT_TOTAL, 0) AS LT_TOTAL
                            ,CASE WHEN V_DIVISION_ID != '81' AND B.DAYS_SUN = 'Y' OR INC.SEGMENT5 = 'N' THEN NVL(B.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND B.DAYS_SUN = 'Y' THEN NVL(B.LT_TOTAL, 0) ELSE NULL END AS SUN_LT
                            ,CASE WHEN V_DIVISION_ID != '81' AND B.DAYS_MON = 'Y' OR INC.SEGMENT5 = 'N' THEN NVL(B.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND B.DAYS_MON = 'Y' THEN NVL(B.LT_TOTAL, 0) ELSE NULL END AS MON_LT
                            ,CASE WHEN V_DIVISION_ID != '81' AND B.DAYS_TUE = 'Y' OR INC.SEGMENT5 = 'N' THEN NVL(B.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND B.DAYS_TUE = 'Y' THEN NVL(B.LT_TOTAL, 0) ELSE NULL END AS TUE_LT
                            ,CASE WHEN V_DIVISION_ID != '81' AND B.DAYS_WED = 'Y' OR INC.SEGMENT5 = 'N' THEN NVL(B.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND B.DAYS_WED = 'Y' THEN NVL(B.LT_TOTAL, 0) ELSE NULL END AS WED_LT
                            ,CASE WHEN V_DIVISION_ID != '81' AND B.DAYS_THU = 'Y' OR INC.SEGMENT5 = 'N' THEN NVL(B.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND B.DAYS_THU = 'Y' THEN NVL(B.LT_TOTAL, 0) ELSE NULL END AS THU_LT
                            ,CASE WHEN V_DIVISION_ID != '81' AND B.DAYS_FRI = 'Y' OR INC.SEGMENT5 = 'N' THEN NVL(B.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND B.DAYS_FRI = 'Y' THEN NVL(B.LT_TOTAL, 0) ELSE NULL END AS FRI_LT
                            ,CASE WHEN V_DIVISION_ID != '81' AND B.DAYS_SAT = 'Y' OR INC.SEGMENT5 = 'N' THEN NVL(B.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND B.DAYS_SAT = 'Y' THEN NVL(B.LT_TOTAL, 0) ELSE NULL END AS SAT_LT
                            -- 선적 기준 요일이므로 공장 출하 기준 요일로 전환하기 위한 정보 : 아래에서 요일 전환 처리
                            ,CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 1
                                  WHEN B.DAYS_SUN = 'Y' THEN CASE WHEN (1 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (1 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) + 7  ELSE (1 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) END
                                  ELSE NULL END AS SUN_DE
                            ,CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 2
                                  WHEN B.DAYS_MON = 'Y' THEN CASE WHEN (2 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (2 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) + 7  ELSE (2 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) END
                                  ELSE NULL END AS MON_DE
                            ,CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 3
                                  WHEN B.DAYS_TUE = 'Y' THEN CASE WHEN (3 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (3 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) + 7  ELSE (3 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) END
                                  ELSE NULL END AS TUE_DE
                            ,CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 4
                                  WHEN B.DAYS_WED = 'Y' THEN CASE WHEN (4 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (4 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) + 7  ELSE (4 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) END
                                  ELSE NULL END AS WED_DE
                            ,CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 5
                                  WHEN B.DAYS_THU = 'Y' THEN CASE WHEN (5 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (5 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) + 7  ELSE (5 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) END
                                  ELSE NULL END AS THU_DE
                            ,CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 6
                                  WHEN B.DAYS_FRI = 'Y' THEN CASE WHEN (6 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (6 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) + 7  ELSE (6 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) END
                                  ELSE NULL END AS FRI_DE
                            ,CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 7
                                  WHEN B.DAYS_SAT = 'Y' THEN CASE WHEN (7 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (7 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) + 7  ELSE (7 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) END
                                  ELSE NULL END AS SAT_DE
                            ,B.INCOTERMS
                            ,B.BOD_ID
                            ,B.BOD_TYPE
                            --   2025.06.13 Philsu Park: 동일 PLANT CHAR to CHAR 로직 적용을 위한 필요 Col.
                            , B.FROM_YYYYMMDD
                            , NVL(FS.PLANT_ID, '') AS FROM_PLANT_ID
                            , NVL(TS.PLANT_ID, '') AS TO_PLANT_ID
                      FROM SCP_MST_BOD_N_V B  --20210707 기간별 VIEW로 변경(SCP_MST_BOD_V -> SCP_MST_BOD_N_V)

                      INNER JOIN SCP_MST_BOD_ITEM BIE
                      ON  B.DIVISION_ID    = BIE.DIVISION_ID
                      AND B.BOD_ID         = BIE.BOD_ID
                      AND BIE.VALID_YN     = 'Y'

                      INNER JOIN SCM_MST_SITE FS
                      ON  B.DIVISION_ID    = FS.DIVISION_ID
                      AND B.FROM_SITE      = FS.SCM_SITE_ID
                      --AND FS.SITE_TYPE      = 'PLANT'
                      AND FS.VALID_YN      = 'Y'
                      AND ((FS.DIVISION_ID  = '40' AND FS.OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
                         OR  (FS.DIVISION_ID <> '40' AND FS.OPERATION_GROUP IN ('A', 'P') )
                         )

                      INNER JOIN SCM_MST_SITE TS
                      ON  B.DIVISION_ID    = TS.DIVISION_ID
                      AND B.TO_SITE        = TS.SCM_SITE_ID
                      AND TS.VALID_YN       = 'Y'
                      --AND ((TS.DIVISION_ID  = '40' AND TS.SITE_TYPE = 'SALES' )      -- 소형은 CEll Biz 용 Demand 만 처리
                      --    OR  (TS.DIVISION_ID <> '40' )
                      --    )
                      AND ( TS.SITE_TYPE = 'SALES'       -- 소형은 CEll Biz 용 Demand 만 처리
                          OR  (TS.DIVISION_ID <> '40' AND TS.OPERATION_GROUP IN ('A', 'P')  )  -- 'W' 제외
                          )
                      LEFT JOIN (SELECT DISTINCT DIVISION_ID
                                                ,ITEM_ID
                                                ,OPERATION_GROUP
                                                ,FLOW_ID
                                                ,ATTRIBUTE8
                                  FROM   SCP_MST_FINAL_ITEM
                                  WHERE  DIVISION_ID = V_DIVISION_ID--@P_DIVISION_ID
                                  AND    OPERATION_GROUP IN ('A', 'P')
                                 ) FI
                      ON    BIE.ITEM_ID     = FI.ITEM_ID
                      AND   BIE.DIVISION_ID = FI.DIVISION_ID

                      LEFT JOIN (SELECT SEGMENT1 AS INCOTERMS
                                      , SEGMENT5  -- 항차적용여부
                                  FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
                                  WHERE  LOOKUP_TYPE = 'INCOTERMS'
                                  AND    VALID_YN = 'Y'
                                 ) INC
                      ON    B.INCOTERMS     = INC.INCOTERMS

                      WHERE 1 = 1
                      AND   B.DIVISION_ID                  = V_DIVISION_ID
                      AND   B.BOD_VALID_YN                 = 'Y'
                      AND   B.FROM_YYYYMMDD               <= V_PLAN_END_YYYYMMDD              --유효한 기간의 BOD만 생성 조건 추가, 2021.07.14, BY KKC
                      AND   B.TO_YYYYMMDD                 >= V_PLAN_START_YYYYMMDD    --유효한 기간의 BOD만 생성 조건 추가, 2021.07.14, BY KKC
                      AND   FS.OPERATION_GROUP            IN ('A', 'P') -- CELL / PACK 만
                      AND (   TS.SITE_TYPE = 'SALES'
                           OR FS.OPERATION_GROUP <> TS.OPERATION_GROUP
                           OR (    FS.OPERATION_GROUP = TS.OPERATION_GROUP
                               AND (FS.OSP_YN = 'Y' OR TS.OSP_YN = 'Y')
                               )
                          )
                      ) A
                  GROUP BY FROM_SITE,TO_SITE,TRANSPORT_MODE,ITEM_ID,FROM_STAGE,TO_STAGE
                        -- ,EFF_START
                        ,CASE WHEN (FROM_STAGE = 'CHAR' AND TO_STAGE = 'CHAR' AND FROM_PLANT_ID = TO_PLANT_ID)
                                THEN LEAST(EFF_START, GREATEST(FROM_YYYYMMDD, V_PLAN_START_YYYYMMDD))
                                ELSE EFF_START
                                END
                        ,EFF_END,PRIORITY,LT_TOTAL,SUN_LT,MON_LT,TUE_LT,WED_LT,THU_LT,FRI_LT,SAT_LT
                        ,SUN_DE,MON_DE,TUE_DE,WED_DE,THU_DE,FRI_DE,SAT_DE,INCOTERMS,BOD_ID,BOD_TYPE
             ) BOD
                 LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS
                     ON  1=1
                     AND ITS.PLAN_ID   = V_PLAN_ID
                     AND BOD.TO_SITE   = ITS.SITE_ID
                     AND BOD.ITEM_ID   = ITS.ITEM_ID
                     AND BOD.TO_STAGE  = ITS.STAGE||CASE WHEN ITS.ATTRIBUTE1 IS NULL THEN '' ELSE '@'||ITS.ATTRIBUTE1 END
                     AND BOD.INCOTERMS = ITS.ATTRIBUTE1
                 LEFT OUTER JOIN GT_OPT_INPUT_BOD_CPS CPS
                     ON  1=1
                     AND BOD.TO_SITE = CPS.SALES_SITE_ID
                     AND BOD.ITEM_ID = CPS.ITEM_ID
             /*WHERE (BOD.FROM_SITE || BOD.ITEM_ID
                           IN( SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                               FROM    SCP_OPT_ENG_MODEL_LIST_N_SN
                               WHERE   PLAN_ID = V_PLAN_ID
                               )
                  )*/
        ) BOD
        ;
        
        ------------------------------------------------------------------------
        -- BOD DATA INSERT
        -- BOD BLOCKING 제약을 위해 제약이 없는 경우와 제약이 있는 경우를 나눠서 계산
        -- 2025.09.22 Philsu Park: BLOCKING From Date = To Date 인 경우 DATEADD 0 일로 처리.
        -- 2025.09.23 Philsu Park: EFF_END_DATE = MAX(BASIS_YYYYMMDD) + 1일
        -- 2025.10.16 Philsu Park: 1 Day or N Days 전부 커버 가능하게 수정
        --                          -> BLOCKING 구간 계산할 때 DATE_ADD 하는 부분 제거, EFF_END_DATE 계산 시에만 +1일 더하게 유지.
        ------------------------------------------------------------------------
        INSERT INTO GT_OPT_INPUT_BOD_INS(PLAN_ID
                                ,BOD_ID
                                ,FROM_BUFFER_ID
                                ,TO_BUFFER_ID
                                ,TRANSPORT_MODE
                                ,PRIORITY
                                ,TRANSIT_COST
                                ,EFF_START_DATE
                                ,EFF_END_DATE
                                ,DEFAULT_LEAD_TIME
                                ,SUNDAY_LEAD_TIME
                                ,MONDAY_LEAD_TIME
                                ,TUESDAY_LEAD_TIME
                                ,WEDNESDAY_LEAD_TIME
                                ,THURSDAY_LEAD_TIME
                                ,FRIDAY_LEAD_TIME
                                ,SATURDAY_LEAD_TIME
                                ,RESOURCE_ID
                                ,LOAD_PER
                                ,CONTAINER_CATEGORY
                                ,CONTAINER_SIZE
                                ,TYPE
                                ,ATTRIBUTE1
                                ,ATTRIBUTE2
                                ,ATTRIBUTE3
                                ,ATTRIBUTE4
                                ,ATTRIBUTE5
                                ,ATTRIBUTE6
                                ,ATTRIBUTE7
                                ,ATTRIBUTE8
                                ,ATTRIBUTE9
                                )
        SELECT BOD.PLAN_ID
            ,BOD.BOD_ID||'::'||BOD.EFF_START_DATE AS BOD_ID
            ,BOD.FROM_BUFFER_ID
            ,BOD.TO_BUFFER_ID
            ,BOD.TRANSPORT_MODE
            ,BOD.PRIORITY
            ,BOD.TRANSIT_COST
            ,BOD.EFF_START_DATE
            ,BOD.EFF_END_DATE
            ,BOD.DEFAULT_LEAD_TIME
            ,BOD.SUNDAY_LEAD_TIME
            ,BOD.MONDAY_LEAD_TIME
            ,BOD.TUESDAY_LEAD_TIME
            ,BOD.WEDNESDAY_LEAD_TIME
            ,BOD.THURSDAY_LEAD_TIME
            ,BOD.FRIDAY_LEAD_TIME
            ,BOD.SATURDAY_LEAD_TIME
            ,BOD.RESOURCE_ID
            ,BOD.LOAD_PER
            ,BOD.CONTAINER_CATEGORY
            ,BOD.CONTAINER_SIZE
            ,BOD.TYPE
            ,BOD.ATTRIBUTE1
            ,BOD.ATTRIBUTE2
            ,BOD.ATTRIBUTE3
            ,BOD.ATTRIBUTE4
            ,BOD.ATTRIBUTE5
            ,BOD.ATTRIBUTE6
            ,BOD.ATTRIBUTE7
            ,BOD.ATTRIBUTE8
            ,BOD.ATTRIBUTE9
        FROM GT_OPT_INPUT_BOD_TMP BOD
            -- 2026.04.29 Minyong Lee : Lookup -> UI 전환 (BOD Blocking)
          /*  LEFT OUTER JOIN SCP_OPMZ_BOD_EXCLUDED_ITEM BE
                ON      1=1
                AND     BOD.ATTRIBUTE2 = BE.ITEM_ID
                AND     BOD.ATTRIBUTE7 = BE.BOD_ID
                AND     BE.VALID_YN    ='Y'
                AND     BE.DIVISION_ID = V_DIVISION_ID
        WHERE   BE.BOD_ID IS NULL*/
        UNION ALL
        SELECT PLAN_ID
            ,BOD_ID||'::'||MIN(BASIS_YYYYMMDD) AS BOD_ID
            ,FROM_BUFFER_ID
            ,TO_BUFFER_ID
            ,TRANSPORT_MODE
            ,PRIORITY
            ,TRANSIT_COST
            ,MIN(BASIS_YYYYMMDD) AS EFF_START_DATE
            ,TO_CHAR(TO_DATE(MAX(BASIS_YYYYMMDD), 'YYYYMMDD') + 1, 'YYYYMMDD') AS EFF_END_DATE
            --   ,MAX(BASIS_YYYYMMDD) AS EFF_END_DATE
            ,DEFAULT_LEAD_TIME
            ,SUNDAY_LEAD_TIME
            ,MONDAY_LEAD_TIME
            ,TUESDAY_LEAD_TIME
            ,WEDNESDAY_LEAD_TIME
            ,THURSDAY_LEAD_TIME
            ,FRIDAY_LEAD_TIME
            ,SATURDAY_LEAD_TIME
            ,RESOURCE_ID
            ,LOAD_PER
            ,CONTAINER_CATEGORY
            ,CONTAINER_SIZE
            ,TYPE
            ,ATTRIBUTE1
            ,ATTRIBUTE2
            ,ATTRIBUTE3
            ,ATTRIBUTE4
            ,ATTRIBUTE5
            ,ATTRIBUTE6
            ,ATTRIBUTE7
            ,ATTRIBUTE8
            ,ATTRIBUTE9
        FROM(
            SELECT BOD.PLAN_ID
                ,TO_DATE(BOD.BASIS_YYYYMMDD, 'YYYYMMDD') - ROW_NUMBER() OVER(PARTITION BY BOD.BOD_ID ORDER BY BOD.BASIS_YYYYMMDD) AS GRP
                ,BOD.BOD_ID
                ,BOD.FROM_BUFFER_ID
                ,BOD.TO_BUFFER_ID
                ,BOD.TRANSPORT_MODE
                ,BOD.PRIORITY
                ,BOD.TRANSIT_COST
                ,BOD.EFF_START_DATE
                ,BOD.EFF_END_DATE
                ,BOD.DEFAULT_LEAD_TIME
                ,BOD.SUNDAY_LEAD_TIME
                ,BOD.MONDAY_LEAD_TIME
                ,BOD.TUESDAY_LEAD_TIME
                ,BOD.WEDNESDAY_LEAD_TIME
                ,BOD.THURSDAY_LEAD_TIME
                ,BOD.FRIDAY_LEAD_TIME
                ,BOD.SATURDAY_LEAD_TIME
                ,BOD.RESOURCE_ID
                ,BOD.LOAD_PER
                ,BOD.CONTAINER_CATEGORY
                ,BOD.CONTAINER_SIZE
                ,BOD.TYPE
                ,BOD.ATTRIBUTE1
                ,BOD.ATTRIBUTE2
                ,BOD.ATTRIBUTE3
                ,BOD.ATTRIBUTE4
                ,BOD.ATTRIBUTE5
                ,BOD.ATTRIBUTE6
                ,BOD.ATTRIBUTE7
                ,BOD.ATTRIBUTE8
                ,BOD.ATTRIBUTE9
                ,BOD.BASIS_YYYYMMDD
            FROM(
                SELECT BOD.PLAN_ID
                    ,BOD.BOD_ID
                    ,BOD.FROM_BUFFER_ID
                    ,BOD.TO_BUFFER_ID
                    ,BOD.TRANSPORT_MODE
                    ,BOD.PRIORITY
                    ,BOD.TRANSIT_COST
                    ,BOD.EFF_START_DATE
                    ,BOD.EFF_END_DATE
                    ,BOD.DEFAULT_LEAD_TIME
                    ,BOD.SUNDAY_LEAD_TIME
                    ,BOD.MONDAY_LEAD_TIME
                    ,BOD.TUESDAY_LEAD_TIME
                    ,BOD.WEDNESDAY_LEAD_TIME
                    ,BOD.THURSDAY_LEAD_TIME
                    ,BOD.FRIDAY_LEAD_TIME
                    ,BOD.SATURDAY_LEAD_TIME
                    ,BOD.RESOURCE_ID
                    ,BOD.LOAD_PER
                    ,BOD.CONTAINER_CATEGORY
                    ,BOD.CONTAINER_SIZE
                    ,BOD.TYPE
                    ,BOD.ATTRIBUTE1
                    ,BOD.ATTRIBUTE2
                    ,BOD.ATTRIBUTE3
                    ,BOD.ATTRIBUTE4
                    ,BOD.ATTRIBUTE5
                    ,BOD.ATTRIBUTE6
                    ,BOD.ATTRIBUTE7
                    ,BOD.ATTRIBUTE8
                    ,BOD.ATTRIBUTE9
                    ,CAL1.BASIS_YYYYMMDD
                FROM GT_OPT_INPUT_BOD_TMP BOD
                    INNER JOIN SCM_SYS_CALENDAR_M CAL1 
                        ON CAL1.BASIS_YYYYMMDD BETWEEN BOD.EFF_START_DATE AND BOD.EFF_END_DATE
                    GROUP BY BOD.PLAN_ID,BOD.BOD_ID,BOD.FROM_BUFFER_ID,BOD.TO_BUFFER_ID,BOD.TRANSPORT_MODE,BOD.PRIORITY,BOD.TRANSIT_COST,BOD.EFF_START_DATE,BOD.EFF_END_DATE,BOD.DEFAULT_LEAD_TIME,BOD.SUNDAY_LEAD_TIME,BOD.MONDAY_LEAD_TIME,BOD.TUESDAY_LEAD_TIME,BOD.WEDNESDAY_LEAD_TIME
                        ,BOD.THURSDAY_LEAD_TIME ,BOD.FRIDAY_LEAD_TIME,BOD.SATURDAY_LEAD_TIME ,BOD.RESOURCE_ID,BOD.LOAD_PER,BOD.CONTAINER_CATEGORY,BOD.CONTAINER_SIZE,BOD.TYPE,BOD.ATTRIBUTE1,BOD.ATTRIBUTE2,BOD.ATTRIBUTE3,BOD.ATTRIBUTE4,BOD.ATTRIBUTE5,BOD.ATTRIBUTE6,BOD.ATTRIBUTE7,BOD.ATTRIBUTE8,BOD.ATTRIBUTE9,CAL1.BASIS_YYYYMMDD
                ) BOD
            )GRP
            GROUP BY PLAN_ID,BOD_ID,FROM_BUFFER_ID,TO_BUFFER_ID,TRANSPORT_MODE,PRIORITY,TRANSIT_COST,DEFAULT_LEAD_TIME,SUNDAY_LEAD_TIME,MONDAY_LEAD_TIME,TUESDAY_LEAD_TIME,WEDNESDAY_LEAD_TIME,THURSDAY_LEAD_TIME,FRIDAY_LEAD_TIME,SATURDAY_LEAD_TIME,RESOURCE_ID,LOAD_PER
                ,CONTAINER_CATEGORY,CONTAINER_SIZE,TYPE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,GRP
        ;
    
        ------------------------------------------------------------------------
        -- BOD DATA INSERT
        -- 속도 이슈로 TEMP에 넣은 후 본 테이블에 INSERT
        -- 2025.09.23 Philsu Park: EFF_END_DATE 가 PED 보다 작거나 같게 수정.
        ------------------------------------------------------------------------
        DELETE FROM SCP_OPT_ENG_BOD_SN WHERE PLAN_ID = V_PLAN_ID;
        INSERT INTO SCP_OPT_ENG_BOD_SN(PLAN_ID
                                      ,BOD_ID
                                      ,FROM_BUFFER_ID
                                      ,TO_BUFFER_ID
                                      ,TRANSPORT_MODE
                                      ,PRIORITY
                                      ,TRANSIT_COST
                                      ,EFF_START_DATE
                                      ,EFF_END_DATE
                                      ,DEFAULT_LEAD_TIME
                                      ,SUNDAY_LEAD_TIME
                                      ,MONDAY_LEAD_TIME
                                      ,TUESDAY_LEAD_TIME
                                      ,WEDNESDAY_LEAD_TIME
                                      ,THURSDAY_LEAD_TIME
                                      ,FRIDAY_LEAD_TIME
                                      ,SATURDAY_LEAD_TIME
                                      ,RESOURCE_ID
                                      ,LOAD_PER
                                      ,CONTAINER_CATEGORY
                                      ,CONTAINER_SIZE
                                      ,TYPE
                                      ,ATTRIBUTE1
                                      ,ATTRIBUTE2
                                      ,ATTRIBUTE3
                                      ,ATTRIBUTE4
                                      ,ATTRIBUTE5
                                      ,ATTRIBUTE6
                                      ,ATTRIBUTE7
                                      ,ATTRIBUTE8
                                      ,ATTRIBUTE9
                                      )
        SELECT  DISTINCT 
                PLAN_ID
               ,BOD_ID
               ,FROM_BUFFER_ID
               ,TO_BUFFER_ID
               ,TRANSPORT_MODE
               ,PRIORITY
               ,TRANSIT_COST
               ,EFF_START_DATE
               ,LEAST(EFF_END_DATE, V_PLAN_END_YYYYMMDD) AS EFF_END_DATE
               ,DEFAULT_LEAD_TIME
               ,SUNDAY_LEAD_TIME
               ,MONDAY_LEAD_TIME
               ,TUESDAY_LEAD_TIME
               ,WEDNESDAY_LEAD_TIME
               ,THURSDAY_LEAD_TIME
               ,FRIDAY_LEAD_TIME
               ,SATURDAY_LEAD_TIME
               ,RESOURCE_ID
               ,LOAD_PER
               ,CONTAINER_CATEGORY
               ,CONTAINER_SIZE
               ,TYPE
               ,ATTRIBUTE1
               ,ATTRIBUTE2
               ,ATTRIBUTE3
               ,ATTRIBUTE4
               ,ATTRIBUTE5
               ,ATTRIBUTE6
               ,ATTRIBUTE7
               ,ATTRIBUTE8
               ,ATTRIBUTE9
        FROM    GT_OPT_INPUT_BOD_INS
        ;
        
        ------------------------------------------------------------------------
        -- Demand Group BOD Insert
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_BOD_SN(
               PLAN_ID
              ,BOD_ID
              ,FROM_BUFFER_ID
              ,TO_BUFFER_ID
              ,TRANSPORT_MODE
              ,PRIORITY
              ,TRANSIT_COST
              ,EFF_START_DATE
              ,EFF_END_DATE
              ,DEFAULT_LEAD_TIME
              ,SUNDAY_LEAD_TIME
              ,MONDAY_LEAD_TIME
              ,TUESDAY_LEAD_TIME
              ,WEDNESDAY_LEAD_TIME
              ,THURSDAY_LEAD_TIME
              ,FRIDAY_LEAD_TIME
              ,SATURDAY_LEAD_TIME
              ,RESOURCE_ID
              ,LOAD_PER
              ,CONTAINER_CATEGORY
              ,CONTAINER_SIZE
              ,TYPE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
              )
        SELECT DISTINCT 
               V_PLAN_ID
              ,DM1.BUFFER_ID || DM2.BUFFER_ID AS BOD_ID
              ,DM1.BUFFER_ID          AS FROM_BUFFER_ID
              ,DM2.BUFFER_ID          AS TO_BUFFER_ID
              ,'TRK'                  AS TRANSPORT_MODE
              ,'1'                    AS PRIORITY
              ,NULL                   AS TRANSIT_COST
              ,V_PLAN_START_YYYYMMDD  AS EFF_START_DATE
              ,V_PLAN_END_YYYYMMDD    AS EFF_END_DATE
              ,'0'                    AS DEFAULT_LEAD_TIME
              ,'0'                    AS SUNDAY_LEAD_TIME
              ,'0'                    AS MONDAY_LEAD_TIME
              ,'0'                    AS TUESDAY_LEAD_TIME
              ,'0'                    AS WEDNESDAY_LEAD_TIME
              ,'0'                    AS THURSDAY_LEAD_TIME
              ,'0'                    AS FRIDAY_LEAD_TIME
              ,'0'                    AS SATURDAY_LEAD_TIME
              ,NULL                   AS RESOURCE_ID
              ,NULL                   AS LOAD_PER
              ,NULL                   AS CONTAINER_CATEGORY
              ,NULL                   AS CONTAINER_SIZE
              ,NULL                   AS TYPE
              ,DM1.ATTRIBUTE1         AS ATTRIBUTE1
              ,DM1.ATTRIBUTE2         AS ATTRIBUTE2
              ,DM1.ATTRIBUTE3         AS ATTRIBUTE3
              ,DM2.ATTRIBUTE1         AS ATTRIBUTE4
              ,DM2.ATTRIBUTE2         AS ATTRIBUTE5
        FROM SCP_OPT_ENG_DEMAND_SN DM1 -- 원래 DEMAND
        INNER JOIN SCP_OPT_ENG_DEMAND_SN DM2    -- GROUP DEMAND
        ON  DM1.PLAN_ID = DM2.PLAN_ID
        AND DM1.DEMAND_ID = 'D_'||DM2.DEMAND_ID
        AND DM1.ATTRIBUTE13 = 'GROUP_DEMAND'
        AND DM2.ATTRIBUTE12 = 'DEMAND_GROUP'
        WHERE DM1.PLAN_ID = V_PLAN_ID
        GROUP BY DM1.BUFFER_ID, DM2.BUFFER_ID,DM1.ATTRIBUTE1,DM1.ATTRIBUTE2,DM1.ATTRIBUTE3,DM2.ATTRIBUTE1,DM2.ATTRIBUTE2
        ;
        COMMIT;
---------------------------------------------------------------------------------------------------------------------------------;
        -- 4. 기존 BOD 삭제
--        DELETE FROM SCP_OPT_ENG_BOD_SN
--        WHERE   1=1
--        AND     PLAN_ID = V_PLAN_ID
--        AND     ATTRIBUTE15 = 'DELETE'
--        ;

        ------------------------------------------------------------------------
        -- PACKING EQUIPMENT CONSTRAINTS UPDATE
        -- 2025.05.20 Philsu Park: 기존 BOD는 삭제 마킹해놓고, PACKING 대상 새로 Insert.
        ------------------------------------------------------------------------
        -- 1. 삭제대상 업데이트.
--        MERGE INTO SCP_OPT_ENG_BOD_SN BOD
--        USING (
--                    SELECT   DISTINCT
--                             PK.FROM_SITE
--                            ,PK.MODEL
--                            ,PK.TO_SITE
--                            ,PK.STAGE
--                    FROM    GT_OPT_INPUT_BOD_PKEQ PK
--              ) PE
--        ON  (   BOD.PLAN_ID    = V_PLAN_ID
--            AND BOD.ATTRIBUTE1 = PE.FROM_SITE
--            AND BOD.ATTRIBUTE2 = PE.MODEL
--            AND BOD.ATTRIBUTE3 = PE.STAGE
--            AND BOD.ATTRIBUTE4 = PE.TO_SITE )
--        WHEN MATCHED THEN
--            UPDATE SET  BOD.ATTRIBUTE15 = 'DELETE'
--                      , BOD.BOD_ID      = BOD.BOD_ID || '_D'
--        ;

        /* ------------------------------------------------------------------------
        -- 2025.05.20 Philsu Park
        PACKING EQUIPMENT 대상 BOD 신규 INSERT
        -- WITH절로 필요한거 땡겨다 놓고, 날짜는 다시 널어놓는 방식으로 처리.
        -- 1. ORG_DATA: PREV_YYYYMMDD - Packing EQP 대상 식별하고 날짜 GAP 비교를 위한 분리단위 PREV_YMD 만들어줌.(LAG 함수 활용)
        -- 2. GROUPED_DATA: NEW_GROUP - 날짜 GAP이 1이 아니면 신규 그룹으로 간주하기 위해 1을 채번.
        -- 3. SEGMENTED_DATA: SEGMENT_ID - NEW_GROUP 값을 누적SUM 처리. 실제 GROUP형태로 구분
        -- 4. 본문 SELECT: GROUP BY 시 SEGMENT_ID 를 포함해서 GROUP 별 구분된 RECORD 반영.
        ------------------------------------------------------------------------ */
--        INSERT INTO  SCP_OPT_ENG_BOD_SN(PLAN_ID
--                                       ,BOD_ID
--                                       ,FROM_BUFFER_ID
--                                       ,TO_BUFFER_ID
--                                       ,TRANSPORT_MODE
--                                       ,PRIORITY
--                                       ,TRANSIT_COST
--                                       ,EFF_START_DATE
--                                       ,EFF_END_DATE
--                                       ,DEFAULT_LEAD_TIME
--                                       ,SUNDAY_LEAD_TIME
--                                       ,MONDAY_LEAD_TIME
--                                       ,TUESDAY_LEAD_TIME
--                                       ,WEDNESDAY_LEAD_TIME
--                                       ,THURSDAY_LEAD_TIME
--                                       ,FRIDAY_LEAD_TIME
--                                       ,SATURDAY_LEAD_TIME
--                                       ,RESOURCE_ID
--                                       ,LOAD_PER
--                                       ,CONTAINER_CATEGORY
--                                       ,CONTAINER_SIZE
--                                       ,USER_ATTB1
--                                       ,USER_ATTB2
--                                       ,USER_ATTB3
--                                       ,USER_ATTB4
--                                       ,USER_ATTB5
--                                       ,USER_ATTB6
--                                       ,USER_ATTB7
--                                       ,USER_ATTB8
--                                       ,TYPE
--                                       ,ATTRIBUTE1
--                                       ,ATTRIBUTE2
--                                       ,ATTRIBUTE3
--                                       ,ATTRIBUTE4
--                                       ,ATTRIBUTE5
--                                       ,ATTRIBUTE6
--                                       ,ATTRIBUTE7
--                                       ,ATTRIBUTE8
--                                       ,ATTRIBUTE9
--                                       ,ATTRIBUTE15
--                                       )
--        WITH ORG_DATA AS (
--            SELECT CAL.BASIS_YYYYMMDD
--                , PKG.RSC_ID
--                , PKG.LD_PER
--                , PKG.PKG_TYPE
--                , LAG(CAL.BASIS_YYYYMMDD, 1, NULL)OVER(PARTITION BY FROM_BUFFER_ID, TO_BUFFER_ID, TRANSPORT_MODE, NVL(PKG.RSC_ID, 'X') ORDER BY CAL.BASIS_YYYYMMDD) AS PREV_YYYYMMDD
--                , BOD.*
--            FROM SCP_OPT_ENG_BOD_SN BOD
--            INNER JOIN SCM_SYS_CALENDAR_M CAL
--                ON CAL.BASIS_YYYYMMDD >= BOD.EFF_START_DATE
--                AND CAL.BASIS_YYYYMMDD < BOD.EFF_END_DATE
--            LEFT OUTER JOIN (   SELECT    DISTINCT -- Test용 6월 데이터.
--                                          PK.*
--                                        , PK.FROM_SITE || '::' || 'PACKING_EQUIPMENT' || '_' || PK.MODEL_GROUP || '@' || PK.STAGE || '::' || PK.TO_SITE AS RSC_ID
--                                        , '1' AS LD_PER
--                                        , '1' AS PKG_TYPE
--                                FROM    GT_OPT_INPUT_BOD_PKEQ PK
--                                ) PKG
--                ON  1=1
--                AND PKG.FROM_SITE   = BOD.ATTRIBUTE1
--                AND PKG.MODEL       = BOD.ATTRIBUTE2
--                AND PKG.STAGE       = BOD.ATTRIBUTE3
--                AND PKG.TO_SITE     = BOD.ATTRIBUTE4
--                AND PKG.FROM_DATE  <= CAL.BASIS_YYYYMMDD
--                AND PKG.TO_DATE     > CAL.BASIS_YYYYMMDD
--            WHERE   1=1
--            AND     BOD.PLAN_ID = V_PLAN_ID
--            AND     EXISTS (SELECT  1
--                            FROM    GT_OPT_INPUT_BOD_PKEQ P
--                            WHERE   1=1
--                            AND     P.FROM_SITE = BOD.ATTRIBUTE1
--                            AND     P.MODEL     = BOD.ATTRIBUTE2
--                            AND     P.STAGE     = BOD.ATTRIBUTE3
--                            AND     P.TO_SITE   = BOD.ATTRIBUTE4
--                            )
--            )
--            , GROUPED_DATA AS (
--                SELECT CASE WHEN (TO_DATE(BASIS_YYYYMMDD, 'YYYYMMDD') - TO_DATE(PREV_YYYYMMDD, 'YYYYMMDD')) <> 1 OR PREV_YYYYMMDD IS NULL THEN 1 ELSE 0 END AS NEW_GROUP
--                , OD.*
--                FROM ORG_DATA OD
--            )
--            , SEGMENTED_DATA AS (
--                SELECT  SUM(NEW_GROUP)OVER(PARTITION BY PLAN_ID, FROM_BUFFER_ID, TO_BUFFER_ID, TRANSPORT_MODE ORDER BY BASIS_YYYYMMDD) AS SEGMENT_ID
--                        , GRP.*
--                FROM    GROUPED_DATA GRP
--            )
--            SELECT   BOD.PLAN_ID                                                                             AS PLAN_ID
--                    ,BOD.TRANSPORT_MODE || '::' || BOD.FROM_BUFFER_ID || '::' || BOD.TO_BUFFER_ID || '::' || BOD.ATTRIBUTE7 || '::' || MIN(BOD.BASIS_YYYYMMDD) AS BOD_ID
--                    ,BOD.FROM_BUFFER_ID                                                                     AS FROM_BUFFER_ID
--                    ,BOD.TO_BUFFER_ID                                                                       AS TO_BUFFER_ID
--                    ,BOD.TRANSPORT_MODE                                                                     AS TRANSPORT_MODE
--                    ,MAX(BOD.PRIORITY)                                                                      AS PRIORITY
--                    ,MAX(BOD.TRANSIT_COST)                                                                  AS TRANSIT_COST
--                    ,MIN(BOD.BASIS_YYYYMMDD)                                                                AS EFF_START_DATE
--                    ,TO_CHAR(TO_DATE(MAX(BOD.BASIS_YYYYMMDD), 'YYYYMMDD') + 1, 'YYYYMMDD')                  AS EFF_END_DATE
--                    ,MAX(BOD.DEFAULT_LEAD_TIME)                                                             AS DEFAULT_LEAD_TIME
--                    ,MAX(BOD.SUNDAY_LEAD_TIME)                                                              AS SUNDAY_LEAD_TIME
--                    ,MAX(BOD.MONDAY_LEAD_TIME)                                                              AS MONDAY_LEAD_TIME
--                    ,MAX(BOD.TUESDAY_LEAD_TIME)                                                             AS TUESDAY_LEAD_TIME
--                    ,MAX(BOD.WEDNESDAY_LEAD_TIME)                                                           AS WEDNESDAY_LEAD_TIME
--                    ,MAX(BOD.THURSDAY_LEAD_TIME)                                                            AS THURSDAY_LEAD_TIME
--                    ,MAX(BOD.FRIDAY_LEAD_TIME)                                                              AS FRIDAY_LEAD_TIME
--                    ,MAX(BOD.SATURDAY_LEAD_TIME)                                                            AS SATURDAY_LEAD_TIME
--                    ,BOD.RSC_ID                                                                             AS RESOURCE_ID
--                    ,MAX(BOD.LD_PER)                                                                        AS LOAD_PER
--                    ,MAX(BOD.CONTAINER_CATEGORY)                                                            AS CONTAINER_CATEGORY
--                    ,MAX(BOD.CONTAINER_SIZE)                                                                AS CONTAINER_SIZE
--                    ,MAX(BOD.USER_ATTB1)                                                                    AS USER_ATTB1
--                    ,MAX(BOD.USER_ATTB2)                                                                    AS USER_ATTB2
--                    ,MAX(BOD.USER_ATTB3)                                                                    AS USER_ATTB3
--                    ,MAX(BOD.USER_ATTB4)                                                                    AS USER_ATTB4
--                    ,MAX(BOD.USER_ATTB5)                                                                    AS USER_ATTB5
--                    ,MAX(BOD.USER_ATTB6)                                                                    AS USER_ATTB6
--                    ,MAX(BOD.USER_ATTB7)                                                                    AS USER_ATTB7
--                    ,MAX(BOD.USER_ATTB8)                                                                    AS USER_ATTB8
--                    ,MAX(BOD.PKG_TYPE)                                                                      AS TYPE
--                    ,MAX(BOD.ATTRIBUTE1)                                                                    AS ATTRIBUTE1
--                    ,MAX(BOD.ATTRIBUTE2)                                                                    AS ATTRIBUTE2
--                    ,MAX(BOD.ATTRIBUTE3)                                                                    AS ATTRIBUTE3
--                    ,MAX(BOD.ATTRIBUTE4)                                                                    AS ATTRIBUTE4
--                    ,MAX(BOD.ATTRIBUTE5)                                                                    AS ATTRIBUTE5
--                    ,MAX(BOD.ATTRIBUTE6)                                                                    AS ATTRIBUTE6
--                    ,MAX(BOD.ATTRIBUTE7)                                                                    AS ATTRIBUTE7
--                    ,MAX(BOD.ATTRIBUTE8)                                                                    AS ATTRIBUTE8
--                    ,MAX(BOD.ATTRIBUTE9)                                                                    AS ATTRIBUTE9
--                    ,'BY_PACKING_EQUIPMENT'                                                                 AS ATTRIBUTE15
--            FROM    SEGMENTED_DATA BOD
--            WHERE   1=1
--            AND     BOD.PLAN_ID = V_PLAN_ID
--            GROUP BY BOD.SEGMENT_ID, BOD.PLAN_ID, BOD.FROM_BUFFER_ID, BOD.TO_BUFFER_ID, BOD.TRANSPORT_MODE, BOD.ATTRIBUTE7, BOD.RSC_ID
--            ;
--
--        -- 6. 기존 BOD 삭제
--        DELETE FROM SCP_OPT_ENG_BOD_SN
--        WHERE   1=1
--        AND     PLAN_ID = V_PLAN_ID
--        AND     ATTRIBUTE15 = 'DELETE'
--        ;
--        COMMIT;
---------------------------------------------------------------------------------------------------------------------------------;

    EXCEPTION
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
        PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'END', NULL, NULL, NULL, V_PLAN_ID);
        PR_SCP_OPT_ENG_LOG_DTL_PROC('U', V_PLAN_ID, 'STEP01', NULL, NULL, NULL, NULL, NULL, NULL);
    END IF;
END;