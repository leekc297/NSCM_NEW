PROCEDURE         PR_SCP_OPT_ENG_ESS_INPUT_BOD

(
     P_PLAN_ID              VARCHAR2
    ,V_DIVISION_ID          VARCHAR2
    ,V_GROUP_ID             VARCHAR2
    ,V_PLAN_START_YYYYMMDD  VARCHAR2
    ,V_PLAN_END_YYYYMMDD    VARCHAR2
)
/* ============================================================
 * Program ID   : PR_SCP_OPT_ENG_ESS_INPUT_BOD
 * Description  : SCP OPT ENG(ESS) - BOD 입력데이터 생성 (요일별 Lead Time 매트릭스 + Ship Frozen + 북미 LINK->PACKBIZ 수요 + BOD Blocking + 전진검사 A + 2nd OCV + Packing Equipment + GM 출하 LOT SIZE + TARGETBIZ)
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2025.02.11    TAEHYUN        Initial Release
 * 2025.05.20    Philsu Park    Packing Equipment 로직 변경 (기존 삭제마킹 후 신규 Insert)
 * 2025.05.28    Philsu Park    TO_DATE 는 하루 더해줌
 * 2025.06.13    Philsu Park    동일 PLANT CHAR to CHAR 로직 적용
 * 2025.06.19    김태현         FROZEN 신규 테이블(SCP_OPT_ENG_FROZEN_MASTER_SN) 참조로 수정
 * 2025.07.24    Philsu Park    Plan Horizon 내 PACKING EQP 정보만 추출
 * 2025.08.29    YSH            GM BOD 출하 LOT SIZE 적용
 * 2025.09.03    Philsu Park    ITEM 단위 LOT SIZE 룩업 적용
 * 2025.09.22    Philsu Park    BLOCKING From Date = To Date 인 경우 처리
 * 2025.09.23    Philsu Park    EFF_END_DATE = MAX(BASIS_YYYYMMDD) + 1일
 * 2025.09.24    THKIM          북미 링크 수요를 PACK BIZ 에서 소화하기 위한 BOD 추가
 * 2025.10.16    Philsu Park    BLOCKING 1 Day or N Days 전부 커버 가능하게 수정
 * 2025.10.20    Philsu Park    Ship Frozen by Item Temp 생성
 * 2025.11.13    Minyong Lee    TARGETBIZ 계획 CHAR->CHAR BOD 를 CHAR->TARGETBIZ 로 복사
 * 2025.11.24    Minyong Lee    Lookup -> UI 전환 (Packing Equipment)
 * 2026.04.29    Minyong Lee    Lookup -> UI 전환 (BOD Blocking)
 * 2026.05.26    Minyong Lee    ESS LINK 사내 공장 신설 대응 (FLOW_ID = 'PL450')
 * 2026.07.06    ZIONEX         [PJ202650304]  NextSCM Migration
 * ============================================================ */
AS
    V_PROGRAM_NAME    VARCHAR2(150 CHAR) := 'PR_SCP_OPT_ENG_ESS_INPUT_BOD';
    V_PLAN_ID         VARCHAR2(50 CHAR)  := P_PLAN_ID;
    V_MESSAGE_TEXT    VARCHAR2(1000 CHAR);
    V_DETAIL_DATE     DATE;
    P_PLAN_NAME       VARCHAR2(8 CHAR);
    D_PLAN_NAME       DATE;
    V_SHIP_FROZEN     NUMBER;
    V_SHIPFRZ_DATE    VARCHAR2(8 CHAR);
    V_COUNT           NUMBER;
BEGIN
    PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'START',NULL,NULL,NULL,V_PLAN_ID);

    BEGIN
        /* ---------------------------------------------------------------------- */

        /* ---------------------------------------------------------------------- */
        DELETE FROM GT_OPT_ENG_BOD_TMP;
        DELETE FROM GT_OPT_ENG_BOD_INS;
        DELETE FROM GT_OPT_ENG_BOD_PKGEQP;
        DELETE FROM GT_OPT_ENG_BOD_CELLPROD;
        DELETE FROM GT_OPT_ENG_BOD_SHIPFRZ;

        /* ---------------------------------------------------------------------- */
        /* Set Param : 해당 주 월요일 YYYYMMDD (미사용, 원본 유지) */
        /* ---------------------------------------------------------------------- */
        P_PLAN_NAME := TO_CHAR(FN_NEXT_DAY(TO_DATE(V_PLAN_START_YYYYMMDD,'YYYYMMDD'),'MON') - 7, 'YYYYMMDD');
        D_PLAN_NAME := TO_DATE(P_PLAN_NAME,'YYYYMMDD');

        /* ---------------------------------------------------------------------- */
        /* 2025.06.19 김태현 : FROZEN 신규 테이블을 바라보도록 수정 (Ship Frozen) */
        /* ---------------------------------------------------------------------- */
        BEGIN
            SELECT FROZEN_DAYS INTO V_SHIP_FROZEN
              FROM SCP_OPT_ENG_FROZEN_MASTER_SN
             WHERE 1=1
               AND PLAN_ID     = V_PLAN_ID
               AND FROZEN_TYPE = 'SHIP';
        EXCEPTION
            WHEN NO_DATA_FOUND  THEN V_SHIP_FROZEN := NULL;
            WHEN TOO_MANY_ROWS  THEN V_SHIP_FROZEN := NULL;
        END;
        /* (Plan 시작일자 + Ship Frozen) YYYYMMDD : 원본 반복식(CONVERT+DATEADD)의 불변 선계산 */
        V_SHIPFRZ_DATE := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD,'YYYYMMDD') + NVL(V_SHIP_FROZEN,0), 'YYYYMMDD');

        /* ---------------------------------------------------------------------- */
        /* 2025.05.20 Philsu Park : Packing Equipment Temp 생성 */
        /* 2025.11.24 Minyong Lee : Lookup -> UI 전환 (Packing Equipment) */
        /* Model GROUP 단위로 동일 MIN, MAX 적용. Plan Horizon 내 PACKING EQP 만 추출. */
        /* ---------------------------------------------------------------------- */
        INSERT INTO GT_OPT_ENG_BOD_PKGEQP
            ( DIVISION, PLAN_GROUP, MODEL, MODEL_GROUP, FROM_SITE, STAGE, TO_SITE, FROM_DATE, TO_DATE, LOWER_QTY, UPPER_QTY )
        WITH MODEL_GROUP AS (
                SELECT  CS.DIVISION_ID           AS DIVISION
                      , PG.OPMZ_PLAN_GR_NAME     AS PLAN_GROUP
                      , CS.MDL_GR_NM             AS MODEL_GROUP
                      , GREATEST(V_PLAN_START_YYYYMMDD, NVL(MIN(CS.FROM_YYYYMMDD), V_PLAN_START_YYYYMMDD))                                    AS FROM_DATE
                      , LEAST(V_PLAN_END_YYYYMMDD, NVL(TO_CHAR(TO_DATE(MAX(CS.TO_YYYYMMDD),'YYYYMMDD') + 1,'YYYYMMDD'), V_PLAN_END_YYYYMMDD)) AS TO_DATE
                      , MIN(CAST(CS.SIPM_MIN_QYT AS NUMBER(20,10)))  AS LOWER_QTY
                      , MAX(CAST(CS.SIPM_MAX_QTY AS NUMBER(20,10)))  AS UPPER_QTY
                FROM    SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY CS
                LEFT JOIN SCP_OPMZ_PLAN_GR_M PG
                    ON  CS.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                    AND PG.VALID_YN        = 'Y'
                WHERE   1=1
                AND     CS.VALID_YN          = 'Y'
                AND     CS.DIVISION_ID       = V_DIVISION_ID
                AND     PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                GROUP BY CS.DIVISION_ID, PG.OPMZ_PLAN_GR_NAME, CS.MDL_GR_NM
            )
        SELECT DISTINCT
               CS.DIVISION_ID          AS DIVISION
             , PG.OPMZ_PLAN_GR_NAME    AS PLAN_GROUP
             , CS.ITEM_ID              AS MODEL
             , CS.MDL_GR_NM            AS MODEL_GROUP
             , CS.FROM_STE_ID          AS FROM_SITE
             , CS.STAGE                AS STAGE
             , CS.TO_STE_ID            AS TO_SITE
             , GRP.FROM_DATE           AS FROM_DATE
             , GRP.TO_DATE             AS TO_DATE
             , GRP.LOWER_QTY           AS LOWER_QTY
             , GRP.UPPER_QTY           AS UPPER_QTY
        FROM   SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY CS
        LEFT JOIN SCP_OPMZ_PLAN_GR_M PG
            ON  CS.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
            AND PG.VALID_YN        = 'Y'
        INNER JOIN MODEL_GROUP GRP
            ON  GRP.DIVISION    = CS.DIVISION_ID
            AND GRP.PLAN_GROUP  = PG.OPMZ_PLAN_GR_NAME
            AND GRP.MODEL_GROUP = CS.MDL_GR_NM
        WHERE  1=1
        AND    CS.VALID_YN          = 'Y'
        AND    CS.DIVISION_ID       = V_DIVISION_ID
        AND    PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
        AND    GRP.FROM_DATE        < V_PLAN_END_YYYYMMDD
        AND    GRP.TO_DATE         >= V_PLAN_START_YYYYMMDD;

        /* ---------------------------------------------------------------------- */
        /* 셀 생산지 버퍼 추가 */
        /* ---------------------------------------------------------------------- */
        INSERT INTO GT_OPT_ENG_BOD_CELLPROD ( SALES_SITE_ID, ITEM_ID )
        SELECT SEGMENT3, SEGMENT4
        FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL
        WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CELL_PROD_SITE'
        AND    SEGMENT1    = V_DIVISION_ID
        AND    SEGMENT2    = V_GROUP_ID;

        /* ---------------------------------------------------------------------- */
        /* 2025.10.20 Philsu Park : Ship Frozen by Item Temp 생성 + 건수 */
        /* ---------------------------------------------------------------------- */
        INSERT INTO GT_OPT_ENG_BOD_SHIPFRZ ( ITEM_ID, FROM_SITE, FROM_STAGE, TO_SITE, TO_STAGE )
        SELECT SEGMENT3, SEGMENT4, SEGMENT5, SEGMENT6, SEGMENT7
        FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LK
        WHERE  LK.LOOKUP_TYPE = 'SCP_OPT_SHIP_FROZEN_BY_ITEM'
        AND    LK.SEGMENT1    = V_DIVISION_ID
        AND    LK.SEGMENT2    = V_GROUP_ID
        AND    LK.VALID_YN    = 'Y';

        SELECT COUNT(*) INTO V_COUNT FROM GT_OPT_ENG_BOD_SHIPFRZ;

        /* ---------------------------------------------------------------------- */
        /* BOD DATA INSERT TO @BOD_TMP (블록1 : 요일별 LT 매트릭스 + PRIORITY 재채번(RANK)) */
        /* ---------------------------------------------------------------------- */
        INSERT INTO GT_OPT_ENG_BOD_TMP
            ( PLAN_ID, BOD_ID, FROM_BUFFER_ID, TO_BUFFER_ID, TRANSPORT_MODE, PRIORITY, TRANSIT_COST, EFF_START_DATE, EFF_END_DATE
            , DEFAULT_LEAD_TIME, SUNDAY_LEAD_TIME, MONDAY_LEAD_TIME, TUESDAY_LEAD_TIME, WEDNESDAY_LEAD_TIME, THURSDAY_LEAD_TIME, FRIDAY_LEAD_TIME, SATURDAY_LEAD_TIME
            , RESOURCE_ID, LOAD_PER, CONTAINER_CATEGORY, CONTAINER_SIZE, TYPE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9 )
        SELECT  PLAN_ID
              , BOD_ID
              , FROM_BUFFER_ID
              , TO_BUFFER_ID
              , TRANSPORT_MODE
              , RANK() OVER ( PARTITION BY BOD2.FROM_BUFFER_ID, BOD2.TO_BUFFER_ID ORDER BY BOD2.PRIORITY ) AS PRIORITY
              , TRANSIT_COST
              , EFF_START_DATE
              , EFF_END_DATE
              , DEFAULT_LEAD_TIME
              , SUNDAY_LEAD_TIME
              , MONDAY_LEAD_TIME
              , TUESDAY_LEAD_TIME
              , WEDNESDAY_LEAD_TIME
              , THURSDAY_LEAD_TIME
              , FRIDAY_LEAD_TIME
              , SATURDAY_LEAD_TIME
              , RESOURCE_ID
              , LOAD_PER
              , CONTAINER_CATEGORY
              , CONTAINER_SIZE
              , TYPE
              , ATTRIBUTE1
              , ATTRIBUTE2
              , ATTRIBUTE3
              , ATTRIBUTE4
              , ATTRIBUTE5
              , ATTRIBUTE6
              , ATTRIBUTE7
              , ATTRIBUTE8
              , ATTRIBUTE9
        FROM (
            SELECT  V_PLAN_ID                                                                                          AS PLAN_ID
                  , TRANSPORT_MODE ||'::'|| FROM_SITE ||'::'|| BOD.ITEM_ID ||'::'|| FROM_STAGE
                    ||'::'|| TO_SITE ||'::'|| BOD.ITEM_ID ||'::'|| TO_STAGE
                    || (CASE WHEN ITS.ATTRIBUTE2 IS NULL THEN '' ELSE '@'|| ITS.ATTRIBUTE2 END) ||'::'|| BOD_ID        AS BOD_ID
                  , FROM_SITE ||'::'|| BOD.ITEM_ID ||'::'|| FROM_STAGE                                                 AS FROM_BUFFER_ID
                  , TO_SITE ||'::'|| BOD.ITEM_ID ||'::'|| TO_STAGE
                    || (CASE WHEN ITS.ATTRIBUTE2 IS NULL THEN '' ELSE '@'|| ITS.ATTRIBUTE2 END)
                    || (CASE WHEN CPS.ITEM_ID IS NULL   THEN '' ELSE '::'|| FROM_SITE END)                            AS TO_BUFFER_ID
                  , TRANSPORT_MODE                                                                                    AS TRANSPORT_MODE
                  , PRIORITY                                                                                          AS PRIORITY
                  , NULL                                                                                              AS TRANSIT_COST
                  , EFF_START                                                                                         AS EFF_START_DATE
                  , EFF_END                                                                                           AS EFF_END_DATE
                  , LT_TOTAL                                                                                          AS DEFAULT_LEAD_TIME
                  , CASE WHEN SUN_DE = 1 THEN NVL(LT_TOTAL, 0) WHEN MON_DE = 1 THEN NVL(LT_TOTAL, 0) WHEN TUE_DE = 1 THEN NVL(LT_TOTAL, 0) WHEN WED_DE = 1 THEN NVL(LT_TOTAL, 0) WHEN THU_DE = 1 THEN NVL(LT_TOTAL, 0) WHEN FRI_DE = 1 THEN NVL(LT_TOTAL, 0) WHEN SAT_DE = 1 THEN NVL(LT_TOTAL, 0) ELSE NULL END AS SUNDAY_LEAD_TIME
                  , CASE WHEN SUN_DE = 2 THEN NVL(LT_TOTAL, 0) WHEN MON_DE = 2 THEN NVL(LT_TOTAL, 0) WHEN TUE_DE = 2 THEN NVL(LT_TOTAL, 0) WHEN WED_DE = 2 THEN NVL(LT_TOTAL, 0) WHEN THU_DE = 2 THEN NVL(LT_TOTAL, 0) WHEN FRI_DE = 2 THEN NVL(LT_TOTAL, 0) WHEN SAT_DE = 2 THEN NVL(LT_TOTAL, 0) ELSE NULL END AS MONDAY_LEAD_TIME
                  , CASE WHEN SUN_DE = 3 THEN NVL(LT_TOTAL, 0) WHEN MON_DE = 3 THEN NVL(LT_TOTAL, 0) WHEN TUE_DE = 3 THEN NVL(LT_TOTAL, 0) WHEN WED_DE = 3 THEN NVL(LT_TOTAL, 0) WHEN THU_DE = 3 THEN NVL(LT_TOTAL, 0) WHEN FRI_DE = 3 THEN NVL(LT_TOTAL, 0) WHEN SAT_DE = 3 THEN NVL(LT_TOTAL, 0) ELSE NULL END AS TUESDAY_LEAD_TIME
                  , CASE WHEN SUN_DE = 4 THEN NVL(LT_TOTAL, 0) WHEN MON_DE = 4 THEN NVL(LT_TOTAL, 0) WHEN TUE_DE = 4 THEN NVL(LT_TOTAL, 0) WHEN WED_DE = 4 THEN NVL(LT_TOTAL, 0) WHEN THU_DE = 4 THEN NVL(LT_TOTAL, 0) WHEN FRI_DE = 4 THEN NVL(LT_TOTAL, 0) WHEN SAT_DE = 4 THEN NVL(LT_TOTAL, 0) ELSE NULL END AS WEDNESDAY_LEAD_TIME
                  , CASE WHEN SUN_DE = 5 THEN NVL(LT_TOTAL, 0) WHEN MON_DE = 5 THEN NVL(LT_TOTAL, 0) WHEN TUE_DE = 5 THEN NVL(LT_TOTAL, 0) WHEN WED_DE = 5 THEN NVL(LT_TOTAL, 0) WHEN THU_DE = 5 THEN NVL(LT_TOTAL, 0) WHEN FRI_DE = 5 THEN NVL(LT_TOTAL, 0) WHEN SAT_DE = 5 THEN NVL(LT_TOTAL, 0) ELSE NULL END AS THURSDAY_LEAD_TIME
                  , CASE WHEN SUN_DE = 6 THEN NVL(LT_TOTAL, 0) WHEN MON_DE = 6 THEN NVL(LT_TOTAL, 0) WHEN TUE_DE = 6 THEN NVL(LT_TOTAL, 0) WHEN WED_DE = 6 THEN NVL(LT_TOTAL, 0) WHEN THU_DE = 6 THEN NVL(LT_TOTAL, 0) WHEN FRI_DE = 6 THEN NVL(LT_TOTAL, 0) WHEN SAT_DE = 6 THEN NVL(LT_TOTAL, 0) ELSE NULL END AS FRIDAY_LEAD_TIME
                  , CASE WHEN SUN_DE = 7 THEN NVL(LT_TOTAL, 0) WHEN MON_DE = 7 THEN NVL(LT_TOTAL, 0) WHEN TUE_DE = 7 THEN NVL(LT_TOTAL, 0) WHEN WED_DE = 7 THEN NVL(LT_TOTAL, 0) WHEN THU_DE = 7 THEN NVL(LT_TOTAL, 0) WHEN FRI_DE = 7 THEN NVL(LT_TOTAL, 0) WHEN SAT_DE = 7 THEN NVL(LT_TOTAL, 0) ELSE NULL END AS SATURDAY_LEAD_TIME
                  , NULL         AS RESOURCE_ID
                  , NULL         AS LOAD_PER
                  , NULL         AS CONTAINER_CATEGORY
                  , NULL         AS CONTAINER_SIZE
                  , NULL         AS TYPE
                  , FROM_SITE    AS ATTRIBUTE1
                  , BOD.ITEM_ID  AS ATTRIBUTE2
                  , FROM_STAGE   AS ATTRIBUTE3
                  , TO_SITE      AS ATTRIBUTE4
                  , TO_STAGE     AS ATTRIBUTE5
                  , INCOTERMS    AS ATTRIBUTE6
                  , BOD_ID       AS ATTRIBUTE7
                  , BOD_TYPE     AS ATTRIBUTE8
                  , ITS.ATTRIBUTE2 AS ATTRIBUTE9
            FROM (
                SELECT  A.FROM_SITE
                      , A.TO_SITE
                      , A.TRANSPORT_MODE
                      , A.ITEM_ID
                      , A.FROM_STAGE
                      , A.TO_STAGE
                      /* ②EFF_START : Ship Frozen by Item 건수(V_COUNT) 분기 (=0 정본동일, >0 F 존재시 EFF, 미존재시 FROM_YMD_ORG) */
                      , CASE WHEN V_COUNT = 0 THEN
                                 CASE WHEN (A.FROM_STAGE = 'CHAR' AND A.TO_STAGE = 'CHAR' AND FROM_PLANT_ID = TO_PLANT_ID)
                                      THEN LEAST(EFF_START, GREATEST(FROM_YYYYMMDD, V_PLAN_START_YYYYMMDD))
                                      ELSE EFF_START END
                             ELSE
                                 CASE WHEN (A.FROM_STAGE = 'CHAR' AND A.TO_STAGE = 'CHAR' AND FROM_PLANT_ID = TO_PLANT_ID)
                                      THEN LEAST(CASE WHEN F.ITEM_ID IS NOT NULL THEN EFF_START ELSE FROM_YMD_ORG END, GREATEST(FROM_YYYYMMDD, V_PLAN_START_YYYYMMDD))
                                      ELSE CASE WHEN F.ITEM_ID IS NOT NULL THEN EFF_START ELSE FROM_YMD_ORG END END
                        END AS EFF_START
                      , CASE WHEN V_COUNT = 0 THEN EFF_END ELSE CASE WHEN F.ITEM_ID IS NOT NULL THEN EFF_END ELSE TO_YMD_ORG END END AS EFF_END
                      , PRIORITY, LT_TOTAL, SUN_LT, MON_LT, TUE_LT, WED_LT, THU_LT, FRI_LT, SAT_LT
                      , SUN_DE, MON_DE, TUE_DE, WED_DE, THU_DE, FRI_DE, SAT_DE, INCOTERMS, BOD_ID, BOD_TYPE
                FROM (
                    SELECT  B.FROM_SITE
                          , B.TO_SITE
                          , B.TRANSPORT_MODE
                          , BIE.ITEM_ID AS ITEM_ID
                          , CASE WHEN FI.OPERATION_GROUP_ID = 'A'                                             THEN 'CHAR'
                                 WHEN FI.OPERATION_GROUP_ID = 'B' AND FI.FLOW_ID = 'P9500'                    THEN 'PACK'
                                 WHEN FI.OPERATION_GROUP_ID = 'B' AND FI.FLOW_ID = 'P5500'                    THEN 'PACK'
                                 WHEN FI.OPERATION_GROUP_ID = 'M' AND FI.FLOW_ID = 'P9500'                    THEN 'PACK'
                                 WHEN FI.OPERATION_GROUP_ID = 'M' AND FI.FLOW_ID = 'P5000' AND BIE.ITEM_ID NOT LIKE 'EP%' THEN 'PACK'
                                 WHEN FI.OPERATION_GROUP_ID = 'M' AND FI.FLOW_ID = 'P5000' AND BIE.ITEM_ID LIKE 'EP%'     THEN 'PACK'
                                 WHEN FI.OPERATION_GROUP_ID = 'P' AND FI.FLOW_ID = 'R5500'                    THEN 'RACK'
                                 WHEN FI.OPERATION_GROUP_ID = 'P' AND FI.FLOW_ID = 'P9500'                    THEN 'LINK'
                                 WHEN FI.OPERATION_GROUP_ID = 'P' AND FI.FLOW_ID = 'PL450'                    THEN 'LINK'   /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                                 WHEN FS.OPERATION_GROUP    = 'A'                                             THEN 'CHAR'
                                 ELSE '-' END AS FROM_STAGE
                          , CASE WHEN FI.OPERATION_GROUP_ID = 'A' AND TS.SITE_TYPE = 'SALES'                                         THEN 'CELLBIZ@'|| B.INCOTERMS  /* CELL PLANT 출발 -> SALES 도착 */
                                 WHEN FI.OPERATION_GROUP_ID = 'B' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P9500'                THEN 'PACKBIZ@'|| B.INCOTERMS  /* PACK PLANT 출발 -> SALES 도착 */
                                 WHEN FI.OPERATION_GROUP_ID = 'B' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P5500'                THEN 'PACKBIZ@'|| B.INCOTERMS
                                 WHEN FI.OPERATION_GROUP_ID = 'M' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P9500'                THEN 'PACKBIZ@'|| B.INCOTERMS
                                 WHEN FI.OPERATION_GROUP_ID = 'M' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P5000' AND BIE.ITEM_ID NOT LIKE 'EP%' THEN 'PACKBIZ@'|| B.INCOTERMS
                                 WHEN FI.OPERATION_GROUP_ID = 'M' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P5000' AND BIE.ITEM_ID LIKE 'EP%'     THEN 'PACKBIZ@'|| B.INCOTERMS
                                 WHEN FI.OPERATION_GROUP_ID = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'R5500'                THEN 'RACKBIZ@'|| B.INCOTERMS  /* RACK PLANT 출발 -> SALES 도착 */
                                 WHEN FI.OPERATION_GROUP_ID = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'P9500'                THEN 'LINKBIZ@'|| B.INCOTERMS  /* LINK PLANT 출발 -> SALES 도착 */
                                 WHEN FI.OPERATION_GROUP_ID = 'P' AND TS.SITE_TYPE = 'SALES' AND FI.FLOW_ID = 'PL450'                THEN 'LINKBIZ@'|| B.INCOTERMS  /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                                 WHEN FI.OPERATION_GROUP_ID = 'A' AND TS.SITE_TYPE = 'PLANT'                                         THEN 'CHAR'   /* CHAR TO PACK */
                                 WHEN FI.OPERATION_GROUP_ID = 'B' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P9500'                THEN 'PACK'   /* PACK TO LINK */
                                 WHEN FI.OPERATION_GROUP_ID = 'B' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P5500'                THEN 'PACK'
                                 WHEN FI.OPERATION_GROUP_ID = 'M' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P9500'                THEN 'PACK'
                                 WHEN FI.OPERATION_GROUP_ID = 'M' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P5000' AND BIE.ITEM_ID NOT LIKE 'EP%' THEN 'PACK'
                                 WHEN FI.OPERATION_GROUP_ID = 'M' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P5000' AND BIE.ITEM_ID LIKE 'EP%'     THEN 'PACK'
                                 WHEN FI.OPERATION_GROUP_ID = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'R5500'                THEN 'RACK'
                                 WHEN FI.OPERATION_GROUP_ID = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'P9500'                THEN 'LINK'
                                 WHEN FI.OPERATION_GROUP_ID = 'P' AND TS.SITE_TYPE = 'PLANT' AND FI.FLOW_ID = 'PL450'                THEN 'LINK'   /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                                 WHEN FS.OPERATION_GROUP    = 'A'                                                                    THEN 'CHAR'
                                 ELSE '-' END AS TO_STAGE
                          /* (Plan 시작일자 + Ship Frozen) 과 BOD의 FROM YYYYMMDD 중 큰 일자를 EFF_START 로 지정 */
                          , CASE WHEN B.FROM_YYYYMMDD >= V_SHIPFRZ_DATE THEN B.FROM_YYYYMMDD ELSE V_SHIPFRZ_DATE END AS EFF_START
                          /* [(Plan 시작일자 + Ship Frozen) 과 BOD의 TO YYYYMMDD 중 큰 일자]와 V_PLAN_END 중 작은 일자를 EFF_END 로 지정 */
                          , CASE WHEN (CASE WHEN B.TO_YYYYMMDD >= V_SHIPFRZ_DATE THEN B.TO_YYYYMMDD ELSE V_SHIPFRZ_DATE END) <= V_PLAN_END_YYYYMMDD
                                 THEN TO_CHAR(TO_DATE(CASE WHEN B.TO_YYYYMMDD >= V_SHIPFRZ_DATE THEN B.TO_YYYYMMDD ELSE V_SHIPFRZ_DATE END,'YYYYMMDD') + 1,'YYYYMMDD')
                                 ELSE V_PLAN_END_YYYYMMDD END AS EFF_END
                          , B.PRIORITY
                          , NVL(B.LT_TOTAL, 0) AS LT_TOTAL
                          , CASE WHEN (V_DIVISION_ID != '81' AND B.DAYS_SUN = 'Y') OR INC.SEGMENT5 = 'N' THEN NVL(B.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND B.DAYS_SUN = 'Y' THEN NVL(B.LT_TOTAL, 0) ELSE NULL END AS SUN_LT
                          , CASE WHEN (V_DIVISION_ID != '81' AND B.DAYS_MON = 'Y') OR INC.SEGMENT5 = 'N' THEN NVL(B.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND B.DAYS_MON = 'Y' THEN NVL(B.LT_TOTAL, 0) ELSE NULL END AS MON_LT
                          , CASE WHEN (V_DIVISION_ID != '81' AND B.DAYS_TUE = 'Y') OR INC.SEGMENT5 = 'N' THEN NVL(B.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND B.DAYS_TUE = 'Y' THEN NVL(B.LT_TOTAL, 0) ELSE NULL END AS TUE_LT
                          , CASE WHEN (V_DIVISION_ID != '81' AND B.DAYS_WED = 'Y') OR INC.SEGMENT5 = 'N' THEN NVL(B.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND B.DAYS_WED = 'Y' THEN NVL(B.LT_TOTAL, 0) ELSE NULL END AS WED_LT
                          , CASE WHEN (V_DIVISION_ID != '81' AND B.DAYS_THU = 'Y') OR INC.SEGMENT5 = 'N' THEN NVL(B.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND B.DAYS_THU = 'Y' THEN NVL(B.LT_TOTAL, 0) ELSE NULL END AS THU_LT
                          , CASE WHEN (V_DIVISION_ID != '81' AND B.DAYS_FRI = 'Y') OR INC.SEGMENT5 = 'N' THEN NVL(B.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND B.DAYS_FRI = 'Y' THEN NVL(B.LT_TOTAL, 0) ELSE NULL END AS FRI_LT
                          , CASE WHEN (V_DIVISION_ID != '81' AND B.DAYS_SAT = 'Y') OR INC.SEGMENT5 = 'N' THEN NVL(B.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND B.DAYS_SAT = 'Y' THEN NVL(B.LT_TOTAL, 0) ELSE NULL END AS SAT_LT
                          /* 선적 기준 요일이므로 공장 출하 기준 요일로 전환 (아래에서 요일 전환 처리) */
                          , CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 1 WHEN B.DAYS_SUN = 'Y' THEN CASE WHEN (1 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (1 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) + 7 ELSE (1 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) END ELSE NULL END AS SUN_DE
                          , CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 2 WHEN B.DAYS_MON = 'Y' THEN CASE WHEN (2 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (2 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) + 7 ELSE (2 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) END ELSE NULL END AS MON_DE
                          , CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 3 WHEN B.DAYS_TUE = 'Y' THEN CASE WHEN (3 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (3 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) + 7 ELSE (3 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) END ELSE NULL END AS TUE_DE
                          , CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 4 WHEN B.DAYS_WED = 'Y' THEN CASE WHEN (4 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (4 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) + 7 ELSE (4 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) END ELSE NULL END AS WED_DE
                          , CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 5 WHEN B.DAYS_THU = 'Y' THEN CASE WHEN (5 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (5 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) + 7 ELSE (5 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) END ELSE NULL END AS THU_DE
                          , CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 6 WHEN B.DAYS_FRI = 'Y' THEN CASE WHEN (6 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (6 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) + 7 ELSE (6 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) END ELSE NULL END AS FRI_DE
                          , CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 7 WHEN B.DAYS_SAT = 'Y' THEN CASE WHEN (7 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (7 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) + 7 ELSE (7 - MOD(NVL(B.SHIP_LT_TOTAL, 0), 7)) END ELSE NULL END AS SAT_DE
                          , B.INCOTERMS
                          , B.BOD_ID
                          , B.BOD_TYPE
                          /* 2025.06.13 Philsu Park : 동일 PLANT CHAR to CHAR 로직 적용을 위한 필요 Col. */
                          , B.FROM_YYYYMMDD
                          , NVL(FS.PLANT_ID, ' ') AS FROM_PLANT_ID
                          , NVL(TS.PLANT_ID, ' ') AS TO_PLANT_ID
                          , GREATEST(B.FROM_YYYYMMDD, V_PLAN_START_YYYYMMDD) AS FROM_YMD_ORG
                          , LEAST(TO_CHAR(TO_DATE(B.TO_YYYYMMDD,'YYYYMMDD') + 1,'YYYYMMDD'), V_PLAN_END_YYYYMMDD) AS TO_YMD_ORG
                    FROM SCP_MST_BOD_N_V B   /* 20210707 기간별 VIEW로 변경(SCP_MST_BOD_V -> SCP_MST_BOD_N_V) */
                    INNER JOIN SCP_MST_BOD_ITEM BIE
                        ON  B.DIVISION_ID = BIE.DIVISION_ID
                        AND B.BOD_ID      = BIE.BOD_ID
                        AND BIE.VALID_YN  = 'Y'
                    INNER JOIN SCM_MST_SITE FS
                        ON  B.DIVISION_ID = FS.DIVISION_ID
                        AND B.FROM_SITE   = FS.SCM_SITE_ID
                        AND FS.VALID_YN   = 'Y'
                        AND ( (FS.DIVISION_ID  = '40' AND FS.OPERATION_GROUP IN ('A'))       /* 소형은 CEll Biz 용 Demand 만 처리 */
                           OR (FS.DIVISION_ID <> '40' AND FS.OPERATION_GROUP IN ('A','P')) )
                    INNER JOIN SCM_MST_SITE TS
                        ON  B.DIVISION_ID = TS.DIVISION_ID
                        AND B.TO_SITE     = TS.SCM_SITE_ID
                        AND TS.VALID_YN   = 'Y'
                        AND ( TS.SITE_TYPE = 'SALES'                                         /* 소형은 CEll Biz 용 Demand 만 처리 */
                           OR (TS.DIVISION_ID <> '40' AND TS.OPERATION_GROUP IN ('A','P')) ) /* 'W' 제외 */
                    LEFT JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, OPERATION_GROUP_ID, FLOW_ID, ATTRIBUTE8
                                FROM   SCP_MST_FINAL_ITEM
                                WHERE  DIVISION_ID = V_DIVISION_ID
                                AND    OPERATION_GROUP IN ('A','P') ) FI
                        ON  BIE.ITEM_ID     = FI.ITEM_ID
                        AND BIE.DIVISION_ID = FI.DIVISION_ID
                    LEFT JOIN ( SELECT SEGMENT1 AS INCOTERMS, SEGMENT5   /* 항차적용여부 */
                                FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
                                WHERE  LOOKUP_TYPE = 'INCOTERMS'
                                AND    VALID_YN    = 'Y' ) INC
                        ON  B.INCOTERMS = INC.INCOTERMS
                    WHERE 1 = 1
                    AND   B.DIVISION_ID     = V_DIVISION_ID
                    AND   B.BOD_VALID_YN    = 'Y'
                    AND   B.FROM_YYYYMMDD  <= V_PLAN_END_YYYYMMDD     /* 유효한 기간의 BOD만 생성 조건 추가, 2021.07.14, BY KKC */
                    AND   B.TO_YYYYMMDD    >= V_PLAN_START_YYYYMMDD   /* 유효한 기간의 BOD만 생성 조건 추가, 2021.07.14, BY KKC */
                    AND   FS.OPERATION_GROUP IN ('A','P')            /* CELL / PACK 만 */
                    AND ( TS.SITE_TYPE = 'SALES'
                       OR FS.OPERATION_GROUP <> TS.OPERATION_GROUP
                       OR ( FS.OPERATION_GROUP = TS.OPERATION_GROUP AND (FS.OSP_YN = 'Y' OR TS.OSP_YN = 'Y') ) )
                ) A
                LEFT OUTER JOIN GT_OPT_ENG_BOD_SHIPFRZ F
                    ON  F.ITEM_ID = A.ITEM_ID AND F.FROM_SITE = A.FROM_SITE AND F.FROM_STAGE = A.FROM_STAGE AND F.TO_SITE = A.TO_SITE AND F.TO_STAGE = A.TO_STAGE
                GROUP BY A.FROM_SITE, A.TO_SITE, A.TRANSPORT_MODE, A.ITEM_ID, A.FROM_STAGE, A.TO_STAGE
                       , CASE WHEN V_COUNT = 0 THEN
                                  CASE WHEN (A.FROM_STAGE = 'CHAR' AND A.TO_STAGE = 'CHAR' AND FROM_PLANT_ID = TO_PLANT_ID)
                                       THEN LEAST(EFF_START, GREATEST(FROM_YYYYMMDD, V_PLAN_START_YYYYMMDD))
                                       ELSE EFF_START END
                              ELSE
                                  CASE WHEN (A.FROM_STAGE = 'CHAR' AND A.TO_STAGE = 'CHAR' AND FROM_PLANT_ID = TO_PLANT_ID)
                                       THEN LEAST(CASE WHEN F.ITEM_ID IS NOT NULL THEN EFF_START ELSE FROM_YMD_ORG END, GREATEST(FROM_YYYYMMDD, V_PLAN_START_YYYYMMDD))
                                       ELSE CASE WHEN F.ITEM_ID IS NOT NULL THEN EFF_START ELSE FROM_YMD_ORG END END
                         END
                       , CASE WHEN V_COUNT = 0 THEN EFF_END ELSE CASE WHEN F.ITEM_ID IS NOT NULL THEN EFF_END ELSE TO_YMD_ORG END END
                       , PRIORITY, LT_TOTAL, SUN_LT, MON_LT, TUE_LT, WED_LT, THU_LT, FRI_LT, SAT_LT
                       , SUN_DE, MON_DE, TUE_DE, WED_DE, THU_DE, FRI_DE, SAT_DE, INCOTERMS, BOD_ID, BOD_TYPE
            ) BOD
            LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS
                ON  1=1
                AND ITS.PLAN_ID   = V_PLAN_ID
                AND BOD.TO_SITE   = ITS.SITE_ID
                AND BOD.ITEM_ID   = ITS.ITEM_ID
                AND BOD.TO_STAGE  = ITS.STAGE || (CASE WHEN ITS.ATTRIBUTE1 IS NULL THEN '' ELSE '@'|| ITS.ATTRIBUTE1 END)
                AND BOD.INCOTERMS = ITS.ATTRIBUTE1
            LEFT OUTER JOIN GT_OPT_ENG_BOD_CELLPROD CPS
                ON  1=1
                AND BOD.TO_SITE = CPS.SALES_SITE_ID
                AND BOD.ITEM_ID = CPS.ITEM_ID
            WHERE ( BOD.FROM_SITE || BOD.ITEM_ID
                    IN ( SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                         FROM   SCP_OPT_ENG_MODEL_LIST_N_SN
                         WHERE  PLAN_ID = V_PLAN_ID ) )
        ) BOD2;

        /* ---------------------------------------------------------------------- */
        /* 2025.09.24 THKIM : 북미 링크 수요를 PACK BIZ 에서 소화하기 위한 BOD 추가 (블록2) */
        /* ---------------------------------------------------------------------- */
        INSERT INTO GT_OPT_ENG_BOD_TMP
            ( PLAN_ID, BOD_ID, FROM_BUFFER_ID, TO_BUFFER_ID, TRANSPORT_MODE, PRIORITY, TRANSIT_COST, EFF_START_DATE, EFF_END_DATE
            , DEFAULT_LEAD_TIME, SUNDAY_LEAD_TIME, MONDAY_LEAD_TIME, TUESDAY_LEAD_TIME, WEDNESDAY_LEAD_TIME, THURSDAY_LEAD_TIME, FRIDAY_LEAD_TIME, SATURDAY_LEAD_TIME
            , RESOURCE_ID, LOAD_PER, CONTAINER_CATEGORY, CONTAINER_SIZE, TYPE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9 )
        SELECT  PLAN_ID
              , BOD_ID
              , FROM_BUFFER_ID
              , TO_BUFFER_ID
              , TRANSPORT_MODE
              , RANK() OVER ( PARTITION BY BOD2.FROM_BUFFER_ID, BOD2.TO_BUFFER_ID ORDER BY BOD2.PRIORITY ) AS PRIORITY
              , TRANSIT_COST
              , EFF_START_DATE
              , EFF_END_DATE
              , DEFAULT_LEAD_TIME
              , SUNDAY_LEAD_TIME
              , MONDAY_LEAD_TIME
              , TUESDAY_LEAD_TIME
              , WEDNESDAY_LEAD_TIME
              , THURSDAY_LEAD_TIME
              , FRIDAY_LEAD_TIME
              , SATURDAY_LEAD_TIME
              , RESOURCE_ID
              , LOAD_PER
              , CONTAINER_CATEGORY
              , CONTAINER_SIZE
              , TYPE
              , ATTRIBUTE1
              , ATTRIBUTE2
              , ATTRIBUTE3
              , ATTRIBUTE4
              , ATTRIBUTE5
              , ATTRIBUTE6
              , ATTRIBUTE7
              , ATTRIBUTE8
              , ATTRIBUTE9
        FROM (
            SELECT  V_PLAN_ID                                                                                          AS PLAN_ID
                  , TRANSPORT_MODE ||'::'|| FROM_SITE ||'::'|| BOD.ITEM_ID ||'::'|| FROM_STAGE
                    ||'::'|| TO_SITE ||'::'|| BOD.ITEM_ID ||'::'|| TO_STAGE
                    || (CASE WHEN ITS.ATTRIBUTE2 IS NULL THEN '' ELSE '@'|| ITS.ATTRIBUTE2 END) ||'::'|| BOD_ID        AS BOD_ID
                  , FROM_SITE ||'::'|| BOD.ITEM_ID ||'::'|| FROM_STAGE                                                 AS FROM_BUFFER_ID
                  , TO_SITE ||'::'|| BOD.ITEM_ID ||'::'|| TO_STAGE
                    || (CASE WHEN ITS.ATTRIBUTE2 IS NULL THEN '' ELSE '@'|| ITS.ATTRIBUTE2 END)
                    || (CASE WHEN CPS.ITEM_ID IS NULL   THEN '' ELSE '::'|| FROM_SITE END)                            AS TO_BUFFER_ID
                  , TRANSPORT_MODE                                                                                    AS TRANSPORT_MODE
                  , PRIORITY                                                                                          AS PRIORITY
                  , NULL                                                                                              AS TRANSIT_COST
                  , EFF_START                                                                                         AS EFF_START_DATE
                  , EFF_END                                                                                           AS EFF_END_DATE
                  , LT_TOTAL                                                                                          AS DEFAULT_LEAD_TIME
                  , CASE WHEN SUN_DE = 1 THEN NVL(LT_TOTAL, 0) WHEN MON_DE = 1 THEN NVL(LT_TOTAL, 0) WHEN TUE_DE = 1 THEN NVL(LT_TOTAL, 0) WHEN WED_DE = 1 THEN NVL(LT_TOTAL, 0) WHEN THU_DE = 1 THEN NVL(LT_TOTAL, 0) WHEN FRI_DE = 1 THEN NVL(LT_TOTAL, 0) WHEN SAT_DE = 1 THEN NVL(LT_TOTAL, 0) ELSE NULL END AS SUNDAY_LEAD_TIME
                  , CASE WHEN SUN_DE = 2 THEN NVL(LT_TOTAL, 0) WHEN MON_DE = 2 THEN NVL(LT_TOTAL, 0) WHEN TUE_DE = 2 THEN NVL(LT_TOTAL, 0) WHEN WED_DE = 2 THEN NVL(LT_TOTAL, 0) WHEN THU_DE = 2 THEN NVL(LT_TOTAL, 0) WHEN FRI_DE = 2 THEN NVL(LT_TOTAL, 0) WHEN SAT_DE = 2 THEN NVL(LT_TOTAL, 0) ELSE NULL END AS MONDAY_LEAD_TIME
                  , CASE WHEN SUN_DE = 3 THEN NVL(LT_TOTAL, 0) WHEN MON_DE = 3 THEN NVL(LT_TOTAL, 0) WHEN TUE_DE = 3 THEN NVL(LT_TOTAL, 0) WHEN WED_DE = 3 THEN NVL(LT_TOTAL, 0) WHEN THU_DE = 3 THEN NVL(LT_TOTAL, 0) WHEN FRI_DE = 3 THEN NVL(LT_TOTAL, 0) WHEN SAT_DE = 3 THEN NVL(LT_TOTAL, 0) ELSE NULL END AS TUESDAY_LEAD_TIME
                  , CASE WHEN SUN_DE = 4 THEN NVL(LT_TOTAL, 0) WHEN MON_DE = 4 THEN NVL(LT_TOTAL, 0) WHEN TUE_DE = 4 THEN NVL(LT_TOTAL, 0) WHEN WED_DE = 4 THEN NVL(LT_TOTAL, 0) WHEN THU_DE = 4 THEN NVL(LT_TOTAL, 0) WHEN FRI_DE = 4 THEN NVL(LT_TOTAL, 0) WHEN SAT_DE = 4 THEN NVL(LT_TOTAL, 0) ELSE NULL END AS WEDNESDAY_LEAD_TIME
                  , CASE WHEN SUN_DE = 5 THEN NVL(LT_TOTAL, 0) WHEN MON_DE = 5 THEN NVL(LT_TOTAL, 0) WHEN TUE_DE = 5 THEN NVL(LT_TOTAL, 0) WHEN WED_DE = 5 THEN NVL(LT_TOTAL, 0) WHEN THU_DE = 5 THEN NVL(LT_TOTAL, 0) WHEN FRI_DE = 5 THEN NVL(LT_TOTAL, 0) WHEN SAT_DE = 5 THEN NVL(LT_TOTAL, 0) ELSE NULL END AS THURSDAY_LEAD_TIME
                  , CASE WHEN SUN_DE = 6 THEN NVL(LT_TOTAL, 0) WHEN MON_DE = 6 THEN NVL(LT_TOTAL, 0) WHEN TUE_DE = 6 THEN NVL(LT_TOTAL, 0) WHEN WED_DE = 6 THEN NVL(LT_TOTAL, 0) WHEN THU_DE = 6 THEN NVL(LT_TOTAL, 0) WHEN FRI_DE = 6 THEN NVL(LT_TOTAL, 0) WHEN SAT_DE = 6 THEN NVL(LT_TOTAL, 0) ELSE NULL END AS FRIDAY_LEAD_TIME
                  , CASE WHEN SUN_DE = 7 THEN NVL(LT_TOTAL, 0) WHEN MON_DE = 7 THEN NVL(LT_TOTAL, 0) WHEN TUE_DE = 7 THEN NVL(LT_TOTAL, 0) WHEN WED_DE = 7 THEN NVL(LT_TOTAL, 0) WHEN THU_DE = 7 THEN NVL(LT_TOTAL, 0) WHEN FRI_DE = 7 THEN NVL(LT_TOTAL, 0) WHEN SAT_DE = 7 THEN NVL(LT_TOTAL, 0) ELSE NULL END AS SATURDAY_LEAD_TIME
                  , NULL         AS RESOURCE_ID
                  , NULL         AS LOAD_PER
                  , NULL         AS CONTAINER_CATEGORY
                  , NULL         AS CONTAINER_SIZE
                  , NULL         AS TYPE
                  , FROM_SITE    AS ATTRIBUTE1
                  , BOD.ITEM_ID  AS ATTRIBUTE2
                  , FROM_STAGE   AS ATTRIBUTE3
                  , TO_SITE      AS ATTRIBUTE4
                  , TO_STAGE     AS ATTRIBUTE5
                  , INCOTERMS    AS ATTRIBUTE6
                  , BOD_ID       AS ATTRIBUTE7
                  , BOD_TYPE     AS ATTRIBUTE8
                  , ITS.ATTRIBUTE2 AS ATTRIBUTE9
            FROM (
                SELECT  BOD.FROM_SITE
                      , BOD.TO_SITE
                      , BOD.TRANSPORT_MODE
                      , BOD.ITEM_ID
                      , BOD.FROM_STAGE
                      , BOD.TO_STAGE
                      , CASE WHEN V_COUNT = 0 THEN
                                 CASE WHEN (BOD.FROM_STAGE = 'CHAR' AND BOD.TO_STAGE = 'CHAR' AND FROM_PLANT_ID = TO_PLANT_ID)
                                      THEN LEAST(EFF_START, GREATEST(FROM_YYYYMMDD, V_PLAN_START_YYYYMMDD))
                                      ELSE EFF_START END
                             ELSE
                                 CASE WHEN (BOD.FROM_STAGE = 'CHAR' AND BOD.TO_STAGE = 'CHAR' AND FROM_PLANT_ID = TO_PLANT_ID)
                                      THEN LEAST(CASE WHEN F.ITEM_ID IS NOT NULL THEN EFF_START ELSE FROM_YMD_ORG END, GREATEST(FROM_YYYYMMDD, V_PLAN_START_YYYYMMDD))
                                      ELSE CASE WHEN F.ITEM_ID IS NOT NULL THEN EFF_START ELSE FROM_YMD_ORG END END
                        END AS EFF_START
                      , CASE WHEN V_COUNT = 0 THEN EFF_END ELSE CASE WHEN F.ITEM_ID IS NOT NULL THEN EFF_END ELSE TO_YMD_ORG END END AS EFF_END
                      , PRIORITY, LT_TOTAL, SUN_LT, MON_LT, TUE_LT, WED_LT, THU_LT, FRI_LT, SAT_LT
                      , SUN_DE, MON_DE, TUE_DE, WED_DE, THU_DE, FRI_DE, SAT_DE, INCOTERMS, BOD_ID, BOD_TYPE
                FROM (
                    SELECT  V_PLAN_ID AS PLAN_ID
                          , BOD.FROM_SITE
                          , BOD.TO_SITE
                          , BOD.TRANSPORT_MODE
                          , DA.ITEM_ID
                          , CASE WHEN FI.OPERATION_GROUP_ID = 'A'                                             THEN 'CHAR'
                                 WHEN FI.OPERATION_GROUP_ID = 'B' AND FI.FLOW_ID = 'P9500'                    THEN 'PACK'
                                 WHEN FI.OPERATION_GROUP_ID = 'B' AND FI.FLOW_ID = 'P5500'                    THEN 'PACK'
                                 WHEN FI.OPERATION_GROUP_ID = 'M' AND FI.FLOW_ID = 'P9500'                    THEN 'PACK'
                                 WHEN FI.OPERATION_GROUP_ID = 'M' AND FI.FLOW_ID = 'P5000' AND BIE.ITEM_ID NOT LIKE 'EP%' THEN 'PACK'
                                 WHEN FI.OPERATION_GROUP_ID = 'M' AND FI.FLOW_ID = 'P5000' AND BIE.ITEM_ID LIKE 'EP%'     THEN 'PACK'
                                 WHEN FI.OPERATION_GROUP_ID = 'P' AND FI.FLOW_ID = 'R5500'                    THEN 'RACK'
                                 WHEN FI.OPERATION_GROUP_ID = 'P' AND FI.FLOW_ID = 'P9500'                    THEN 'LINK'
                                 WHEN FI.OPERATION_GROUP_ID = 'P' AND FI.FLOW_ID = 'PL450'                    THEN 'LINK'   /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                                 WHEN FS.OPERATION_GROUP    = 'A'                                             THEN 'CHAR'
                                 ELSE '-' END AS FROM_STAGE
                          , DA.STAGE ||'@'|| BOD.INCOTERMS AS TO_STAGE
                          /* (Plan 시작일자 + Ship Frozen) 과 BOD의 FROM YYYYMMDD 중 큰 일자를 EFF_START 로 지정 */
                          , CASE WHEN BOD.FROM_YYYYMMDD >= V_SHIPFRZ_DATE THEN BOD.FROM_YYYYMMDD ELSE V_SHIPFRZ_DATE END AS EFF_START
                          /* [(Plan 시작일자 + Ship Frozen) 과 BOD의 TO YYYYMMDD 중 큰 일자]와 V_PLAN_END 중 작은 일자를 EFF_END 로 지정 */
                          , CASE WHEN (CASE WHEN BOD.TO_YYYYMMDD >= V_SHIPFRZ_DATE THEN BOD.TO_YYYYMMDD ELSE V_SHIPFRZ_DATE END) <= V_PLAN_END_YYYYMMDD
                                 THEN TO_CHAR(TO_DATE(CASE WHEN BOD.TO_YYYYMMDD >= V_SHIPFRZ_DATE THEN BOD.TO_YYYYMMDD ELSE V_SHIPFRZ_DATE END,'YYYYMMDD') + 1,'YYYYMMDD')
                                 ELSE V_PLAN_END_YYYYMMDD END AS EFF_END
                          , BOD.PRIORITY
                          , NVL(BOD.LT_TOTAL, 0) AS LT_TOTAL
                          , CASE WHEN (V_DIVISION_ID != '81' AND BOD.DAYS_SUN = 'Y') OR INC.SEGMENT5 = 'N' THEN NVL(BOD.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND BOD.DAYS_SUN = 'Y' THEN NVL(BOD.LT_TOTAL, 0) ELSE NULL END AS SUN_LT
                          , CASE WHEN (V_DIVISION_ID != '81' AND BOD.DAYS_MON = 'Y') OR INC.SEGMENT5 = 'N' THEN NVL(BOD.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND BOD.DAYS_MON = 'Y' THEN NVL(BOD.LT_TOTAL, 0) ELSE NULL END AS MON_LT
                          , CASE WHEN (V_DIVISION_ID != '81' AND BOD.DAYS_TUE = 'Y') OR INC.SEGMENT5 = 'N' THEN NVL(BOD.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND BOD.DAYS_TUE = 'Y' THEN NVL(BOD.LT_TOTAL, 0) ELSE NULL END AS TUE_LT
                          , CASE WHEN (V_DIVISION_ID != '81' AND BOD.DAYS_WED = 'Y') OR INC.SEGMENT5 = 'N' THEN NVL(BOD.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND BOD.DAYS_WED = 'Y' THEN NVL(BOD.LT_TOTAL, 0) ELSE NULL END AS WED_LT
                          , CASE WHEN (V_DIVISION_ID != '81' AND BOD.DAYS_THU = 'Y') OR INC.SEGMENT5 = 'N' THEN NVL(BOD.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND BOD.DAYS_THU = 'Y' THEN NVL(BOD.LT_TOTAL, 0) ELSE NULL END AS THU_LT
                          , CASE WHEN (V_DIVISION_ID != '81' AND BOD.DAYS_FRI = 'Y') OR INC.SEGMENT5 = 'N' THEN NVL(BOD.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND BOD.DAYS_FRI = 'Y' THEN NVL(BOD.LT_TOTAL, 0) ELSE NULL END AS FRI_LT
                          , CASE WHEN (V_DIVISION_ID != '81' AND BOD.DAYS_SAT = 'Y') OR INC.SEGMENT5 = 'N' THEN NVL(BOD.LT_TOTAL, 0) WHEN V_DIVISION_ID = '81' AND BOD.DAYS_SAT = 'Y' THEN NVL(BOD.LT_TOTAL, 0) ELSE NULL END AS SAT_LT
                          , CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 1 WHEN BOD.DAYS_SUN = 'Y' THEN CASE WHEN (1 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (1 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) + 7 ELSE (1 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) END ELSE NULL END AS SUN_DE
                          , CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 2 WHEN BOD.DAYS_MON = 'Y' THEN CASE WHEN (2 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (2 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) + 7 ELSE (2 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) END ELSE NULL END AS MON_DE
                          , CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 3 WHEN BOD.DAYS_TUE = 'Y' THEN CASE WHEN (3 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (3 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) + 7 ELSE (3 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) END ELSE NULL END AS TUE_DE
                          , CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 4 WHEN BOD.DAYS_WED = 'Y' THEN CASE WHEN (4 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (4 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) + 7 ELSE (4 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) END ELSE NULL END AS WED_DE
                          , CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 5 WHEN BOD.DAYS_THU = 'Y' THEN CASE WHEN (5 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (5 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) + 7 ELSE (5 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) END ELSE NULL END AS THU_DE
                          , CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 6 WHEN BOD.DAYS_FRI = 'Y' THEN CASE WHEN (6 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (6 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) + 7 ELSE (6 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) END ELSE NULL END AS FRI_DE
                          , CASE WHEN V_DIVISION_ID != '81' AND INC.SEGMENT5 = 'N' THEN 7 WHEN BOD.DAYS_SAT = 'Y' THEN CASE WHEN (7 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) <= 0 THEN (7 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) + 7 ELSE (7 - MOD(NVL(BOD.SHIP_LT_TOTAL, 0), 7)) END ELSE NULL END AS SAT_DE
                          , BOD.INCOTERMS
                          , BOD.BOD_ID
                          , BOD.BOD_TYPE
                          /* 2025.06.13 Philsu Park : 동일 PLANT CHAR to CHAR 로직 적용을 위한 필요 Col. */
                          , BOD.FROM_YYYYMMDD
                          , NVL(FS.PLANT_ID, ' ') AS FROM_PLANT_ID
                          , NVL(TS.PLANT_ID, ' ') AS TO_PLANT_ID
                          , GREATEST(BOD.FROM_YYYYMMDD, V_PLAN_START_YYYYMMDD) AS FROM_YMD_ORG
                          , LEAST(TO_CHAR(TO_DATE(BOD.TO_YYYYMMDD,'YYYYMMDD') + 1,'YYYYMMDD'), V_PLAN_END_YYYYMMDD) AS TO_YMD_ORG
                    FROM SCP_MST_BOD_N_V BOD
                    INNER JOIN ( SELECT  SEGMENT8 AS BOD_ID
                                       , SEGMENT4 AS STAGE
                                       , SEGMENT5 AS ITEM_ID
                                 FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV
                                 WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_ADD'
                                 AND    VALID_YN    = 'Y'
                                 AND    SEGMENT1    = V_DIVISION_ID
                                 AND    SEGMENT2    = V_GROUP_ID
                                 GROUP BY SEGMENT8, SEGMENT4, SEGMENT5 ) DA
                        ON  BOD.DIVISION_ID = V_DIVISION_ID
                        AND BOD.BOD_ID      = DA.BOD_ID
                    INNER JOIN SCP_MST_BOD_ITEM BIE
                        ON  BOD.DIVISION_ID = BIE.DIVISION_ID
                        AND BOD.BOD_ID      = BIE.BOD_ID
                        AND BIE.ITEM_ID     = DA.ITEM_ID
                        AND BIE.VALID_YN    = 'Y'
                    LEFT JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, OPERATION_GROUP_ID, FLOW_ID, ATTRIBUTE8
                                FROM   SCP_MST_FINAL_ITEM
                                WHERE  DIVISION_ID = V_DIVISION_ID
                                AND    OPERATION_GROUP IN ('A','P') ) FI
                        ON  BIE.ITEM_ID     = FI.ITEM_ID
                        AND BIE.DIVISION_ID = FI.DIVISION_ID
                    INNER JOIN SCM_MST_SITE FS
                        ON  BOD.DIVISION_ID = FS.DIVISION_ID
                        AND BOD.FROM_SITE   = FS.SCM_SITE_ID
                        AND FS.VALID_YN     = 'Y'
                        AND ( (FS.DIVISION_ID  = '40' AND FS.OPERATION_GROUP IN ('A'))       /* 소형은 CEll Biz 용 Demand 만 처리 */
                           OR (FS.DIVISION_ID <> '40' AND FS.OPERATION_GROUP IN ('A','P')) )
                    LEFT JOIN ( SELECT SEGMENT1 AS INCOTERMS, SEGMENT5   /* 항차적용여부 */
                                FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
                                WHERE  LOOKUP_TYPE = 'INCOTERMS'
                                AND    VALID_YN    = 'Y' ) INC
                        ON  BOD.INCOTERMS = INC.INCOTERMS
                    INNER JOIN SCM_MST_SITE TS
                        ON  BOD.DIVISION_ID = TS.DIVISION_ID
                        AND BOD.TO_SITE     = TS.SCM_SITE_ID
                        AND TS.VALID_YN     = 'Y'
                        AND ( TS.SITE_TYPE = 'SALES'                                         /* 소형은 CEll Biz 용 Demand 만 처리 */
                           OR (TS.DIVISION_ID <> '40' AND TS.OPERATION_GROUP IN ('A','P')) ) /* 'W' 제외 */
                ) BOD
                LEFT OUTER JOIN GT_OPT_ENG_BOD_SHIPFRZ F
                    ON  F.ITEM_ID = BOD.ITEM_ID AND F.FROM_SITE = BOD.FROM_SITE AND F.FROM_STAGE = BOD.FROM_STAGE AND F.TO_SITE = BOD.TO_SITE AND F.TO_STAGE = BOD.TO_STAGE
            ) BOD
            LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS
                ON  1=1
                AND ITS.PLAN_ID   = V_PLAN_ID
                AND BOD.TO_SITE   = ITS.SITE_ID
                AND BOD.ITEM_ID   = ITS.ITEM_ID
                AND BOD.TO_STAGE  = ITS.STAGE || (CASE WHEN ITS.ATTRIBUTE1 IS NULL THEN '' ELSE '@'|| ITS.ATTRIBUTE1 END)
                AND BOD.INCOTERMS = ITS.ATTRIBUTE1
            LEFT OUTER JOIN GT_OPT_ENG_BOD_CELLPROD CPS
                ON  1=1
                AND BOD.TO_SITE = CPS.SALES_SITE_ID
                AND BOD.ITEM_ID = CPS.ITEM_ID
            WHERE ( BOD.FROM_SITE || BOD.ITEM_ID
                    IN ( SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                         FROM   SCP_OPT_ENG_MODEL_LIST_N_SN
                         WHERE  PLAN_ID = V_PLAN_ID ) )
        ) BOD2;

        /* ---------------------------------------------------------------------- */
        /* BOD DATA INSERT @BOD_INS_TEMP */
        /* BOD BLOCKING : 제약이 없는 경우와 제약이 있는 경우를 나눠서 계산 */
        /* 2025.09.22 Philsu Park : BLOCKING From Date = To Date 처리 */
        /* 2025.09.23 Philsu Park : EFF_END_DATE = MAX(BASIS_YYYYMMDD) + 1일 */
        /* 2025.10.16 Philsu Park : 1 Day or N Days 전부 커버 (구간계산 시 +1일은 EFF_END 계산에만) */
        /* 2026.04.29 Minyong Lee : Lookup -> UI 전환 (BOD Blocking) */
        /* ---------------------------------------------------------------------- */
        INSERT INTO GT_OPT_ENG_BOD_INS
            ( PLAN_ID, BOD_ID, FROM_BUFFER_ID, TO_BUFFER_ID, TRANSPORT_MODE, PRIORITY, TRANSIT_COST, EFF_START_DATE, EFF_END_DATE
            , DEFAULT_LEAD_TIME, SUNDAY_LEAD_TIME, MONDAY_LEAD_TIME, TUESDAY_LEAD_TIME, WEDNESDAY_LEAD_TIME, THURSDAY_LEAD_TIME, FRIDAY_LEAD_TIME, SATURDAY_LEAD_TIME
            , RESOURCE_ID, LOAD_PER, CONTAINER_CATEGORY, CONTAINER_SIZE, TYPE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9 )
        SELECT  BOD.PLAN_ID
              , BOD.BOD_ID ||'::'|| BOD.EFF_START_DATE AS BOD_ID
              , BOD.FROM_BUFFER_ID
              , BOD.TO_BUFFER_ID
              , BOD.TRANSPORT_MODE
              , BOD.PRIORITY
              , BOD.TRANSIT_COST
              , BOD.EFF_START_DATE
              , BOD.EFF_END_DATE
              , BOD.DEFAULT_LEAD_TIME
              , BOD.SUNDAY_LEAD_TIME
              , BOD.MONDAY_LEAD_TIME
              , BOD.TUESDAY_LEAD_TIME
              , BOD.WEDNESDAY_LEAD_TIME
              , BOD.THURSDAY_LEAD_TIME
              , BOD.FRIDAY_LEAD_TIME
              , BOD.SATURDAY_LEAD_TIME
              , BOD.RESOURCE_ID
              , BOD.LOAD_PER
              , BOD.CONTAINER_CATEGORY
              , BOD.CONTAINER_SIZE
              , BOD.TYPE
              , BOD.ATTRIBUTE1
              , BOD.ATTRIBUTE2
              , BOD.ATTRIBUTE3
              , BOD.ATTRIBUTE4
              , BOD.ATTRIBUTE5
              , BOD.ATTRIBUTE6
              , BOD.ATTRIBUTE7
              , BOD.ATTRIBUTE8
              , BOD.ATTRIBUTE9
        FROM GT_OPT_ENG_BOD_TMP BOD
        LEFT OUTER JOIN SCP_OPMZ_BOD_EXCLUDED_ITEM BE
            ON  1=1
            AND BOD.ATTRIBUTE2 = BE.ITEM_ID
            AND BOD.ATTRIBUTE7 = BE.BOD_ID
            AND BE.VALID_YN    = 'Y'
            AND BE.DIVISION_ID = V_DIVISION_ID
        WHERE BE.BOD_ID IS NULL
        UNION ALL
        SELECT  PLAN_ID
              , BOD_ID ||'::'|| MIN(BASIS_YYYYMMDD) AS BOD_ID
              , FROM_BUFFER_ID
              , TO_BUFFER_ID
              , TRANSPORT_MODE
              , PRIORITY
              , TRANSIT_COST
              , MIN(BASIS_YYYYMMDD) AS EFF_START_DATE
              , TO_CHAR(TO_DATE(MAX(BASIS_YYYYMMDD),'YYYYMMDD') + 1,'YYYYMMDD') AS EFF_END_DATE
              , DEFAULT_LEAD_TIME
              , SUNDAY_LEAD_TIME
              , MONDAY_LEAD_TIME
              , TUESDAY_LEAD_TIME
              , WEDNESDAY_LEAD_TIME
              , THURSDAY_LEAD_TIME
              , FRIDAY_LEAD_TIME
              , SATURDAY_LEAD_TIME
              , RESOURCE_ID
              , LOAD_PER
              , CONTAINER_CATEGORY
              , CONTAINER_SIZE
              , TYPE
              , ATTRIBUTE1
              , ATTRIBUTE2
              , ATTRIBUTE3
              , ATTRIBUTE4
              , ATTRIBUTE5
              , ATTRIBUTE6
              , ATTRIBUTE7
              , ATTRIBUTE8
              , ATTRIBUTE9
        FROM (
            SELECT  BOD.PLAN_ID
                  , TO_DATE(BOD.BASIS_YYYYMMDD,'YYYYMMDD') - ROW_NUMBER() OVER ( PARTITION BY BOD.BOD_ID ORDER BY BOD.BASIS_YYYYMMDD ) AS GRP
                  , BOD.BOD_ID, BOD.FROM_BUFFER_ID, BOD.TO_BUFFER_ID, BOD.TRANSPORT_MODE, BOD.PRIORITY, BOD.TRANSIT_COST, BOD.EFF_START_DATE, BOD.EFF_END_DATE
                  , BOD.DEFAULT_LEAD_TIME, BOD.SUNDAY_LEAD_TIME, BOD.MONDAY_LEAD_TIME, BOD.TUESDAY_LEAD_TIME, BOD.WEDNESDAY_LEAD_TIME, BOD.THURSDAY_LEAD_TIME, BOD.FRIDAY_LEAD_TIME, BOD.SATURDAY_LEAD_TIME
                  , BOD.RESOURCE_ID, BOD.LOAD_PER, BOD.CONTAINER_CATEGORY, BOD.CONTAINER_SIZE, BOD.TYPE
                  , BOD.ATTRIBUTE1, BOD.ATTRIBUTE2, BOD.ATTRIBUTE3, BOD.ATTRIBUTE4, BOD.ATTRIBUTE5, BOD.ATTRIBUTE6, BOD.ATTRIBUTE7, BOD.ATTRIBUTE8, BOD.ATTRIBUTE9
                  , BOD.BASIS_YYYYMMDD
            FROM (
                SELECT  BOD.PLAN_ID, BOD.BOD_ID, BOD.FROM_BUFFER_ID, BOD.TO_BUFFER_ID, BOD.TRANSPORT_MODE, BOD.PRIORITY, BOD.TRANSIT_COST, BOD.EFF_START_DATE, BOD.EFF_END_DATE
                      , BOD.DEFAULT_LEAD_TIME, BOD.SUNDAY_LEAD_TIME, BOD.MONDAY_LEAD_TIME, BOD.TUESDAY_LEAD_TIME, BOD.WEDNESDAY_LEAD_TIME, BOD.THURSDAY_LEAD_TIME, BOD.FRIDAY_LEAD_TIME, BOD.SATURDAY_LEAD_TIME
                      , BOD.RESOURCE_ID, BOD.LOAD_PER, BOD.CONTAINER_CATEGORY, BOD.CONTAINER_SIZE, BOD.TYPE
                      , BOD.ATTRIBUTE1, BOD.ATTRIBUTE2, BOD.ATTRIBUTE3, BOD.ATTRIBUTE4, BOD.ATTRIBUTE5, BOD.ATTRIBUTE6, BOD.ATTRIBUTE7, BOD.ATTRIBUTE8, BOD.ATTRIBUTE9
                      , CAL1.BASIS_YYYYMMDD
                FROM GT_OPT_ENG_BOD_TMP BOD
                LEFT JOIN SCP_OPMZ_BOD_EXCLUDED_ITEM BE
                    ON  1=1
                    AND BOD.ATTRIBUTE2 = BE.ITEM_ID
                    AND BOD.ATTRIBUTE7 = BE.BOD_ID
                    AND BE.VALID_YN    = 'Y'
                    AND BE.DIVISION_ID = V_DIVISION_ID
                INNER JOIN SCM_SYS_CALENDAR_M CAL1
                    ON  CAL1.BASIS_YYYYMMDD BETWEEN BOD.EFF_START_DATE AND BOD.EFF_END_DATE
                LEFT OUTER JOIN (
                        SELECT  BE.ITEM_ID          AS ITEM_ID
                              , BE.BOD_ID           AS BOD_ID
                              , CAL2.BASIS_YYYYMMDD  AS NO_YYYYMMDD
                        FROM SCP_OPMZ_BOD_EXCLUDED_ITEM BE
                        LEFT OUTER JOIN SCM_SYS_CALENDAR_M CAL2
                            ON  CAL2.BASIS_YYYYMMDD BETWEEN BE.BOD_EX_FROM_YYYYMMDD AND BE.BOD_EX_TO_YYYYMMDD
                        WHERE 1=1
                        AND   BE.VALID_YN    = 'Y'
                        AND   BE.DIVISION_ID = V_DIVISION_ID
                    ) BB
                    ON  BOD.ATTRIBUTE2       = BB.ITEM_ID
                    AND BOD.ATTRIBUTE7       = BB.BOD_ID
                    AND CAL1.BASIS_YYYYMMDD  = BB.NO_YYYYMMDD
                WHERE   BE.BOD_ID     IS NOT NULL
                AND     BB.NO_YYYYMMDD IS NULL
                GROUP BY BOD.PLAN_ID, BOD.BOD_ID, BOD.FROM_BUFFER_ID, BOD.TO_BUFFER_ID, BOD.TRANSPORT_MODE, BOD.PRIORITY, BOD.TRANSIT_COST, BOD.EFF_START_DATE, BOD.EFF_END_DATE, BOD.DEFAULT_LEAD_TIME, BOD.SUNDAY_LEAD_TIME, BOD.MONDAY_LEAD_TIME, BOD.TUESDAY_LEAD_TIME, BOD.WEDNESDAY_LEAD_TIME
                       , BOD.THURSDAY_LEAD_TIME, BOD.FRIDAY_LEAD_TIME, BOD.SATURDAY_LEAD_TIME, BOD.RESOURCE_ID, BOD.LOAD_PER, BOD.CONTAINER_CATEGORY, BOD.CONTAINER_SIZE, BOD.TYPE, BOD.ATTRIBUTE1, BOD.ATTRIBUTE2, BOD.ATTRIBUTE3, BOD.ATTRIBUTE4, BOD.ATTRIBUTE5, BOD.ATTRIBUTE6, BOD.ATTRIBUTE7, BOD.ATTRIBUTE8, BOD.ATTRIBUTE9, CAL1.BASIS_YYYYMMDD
            ) BOD
        ) GRP
        GROUP BY PLAN_ID, BOD_ID, FROM_BUFFER_ID, TO_BUFFER_ID, TRANSPORT_MODE, PRIORITY, TRANSIT_COST, DEFAULT_LEAD_TIME, SUNDAY_LEAD_TIME, MONDAY_LEAD_TIME, TUESDAY_LEAD_TIME, WEDNESDAY_LEAD_TIME, THURSDAY_LEAD_TIME, FRIDAY_LEAD_TIME, SATURDAY_LEAD_TIME, RESOURCE_ID, LOAD_PER
               , CONTAINER_CATEGORY, CONTAINER_SIZE, TYPE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, GRP;

        /* ---------------------------------------------------------------------- */
        /* BOD DATA INSERT (본 테이블) */
        /* 2025.09.23 Philsu Park : EFF_END_DATE 가 PED 보다 작거나 같게 수정. */
        /* ---------------------------------------------------------------------- */
        INSERT INTO SCP_OPT_ENG_BOD_SN
            ( PLAN_ID, BOD_ID, FROM_BUFFER_ID, TO_BUFFER_ID, TRANSPORT_MODE, PRIORITY, TRANSIT_COST, EFF_START_DATE, EFF_END_DATE
            , DEFAULT_LEAD_TIME, SUNDAY_LEAD_TIME, MONDAY_LEAD_TIME, TUESDAY_LEAD_TIME, WEDNESDAY_LEAD_TIME, THURSDAY_LEAD_TIME, FRIDAY_LEAD_TIME, SATURDAY_LEAD_TIME
            , RESOURCE_ID, LOAD_PER, CONTAINER_CATEGORY, CONTAINER_SIZE, TYPE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9 )
        SELECT  PLAN_ID
              , BOD_ID
              , FROM_BUFFER_ID
              , TO_BUFFER_ID
              , TRANSPORT_MODE
              , PRIORITY
              , TRANSIT_COST
              , EFF_START_DATE
              , LEAST(EFF_END_DATE, V_PLAN_END_YYYYMMDD) AS EFF_END_DATE
              , DEFAULT_LEAD_TIME
              , SUNDAY_LEAD_TIME
              , MONDAY_LEAD_TIME
              , TUESDAY_LEAD_TIME
              , WEDNESDAY_LEAD_TIME
              , THURSDAY_LEAD_TIME
              , FRIDAY_LEAD_TIME
              , SATURDAY_LEAD_TIME
              , RESOURCE_ID
              , LOAD_PER
              , CONTAINER_CATEGORY
              , CONTAINER_SIZE
              , TYPE
              , ATTRIBUTE1
              , ATTRIBUTE2
              , ATTRIBUTE3
              , ATTRIBUTE4
              , ATTRIBUTE5
              , ATTRIBUTE6
              , ATTRIBUTE7
              , ATTRIBUTE8
              , ATTRIBUTE9
        FROM GT_OPT_ENG_BOD_INS;

        /* ---------------------------------------------------------------------- */
        /* Demand Group BOD Insert */
        /* ---------------------------------------------------------------------- */
        INSERT INTO SCP_OPT_ENG_BOD_SN
            ( PLAN_ID, BOD_ID, FROM_BUFFER_ID, TO_BUFFER_ID, TRANSPORT_MODE, PRIORITY, TRANSIT_COST, EFF_START_DATE, EFF_END_DATE
            , DEFAULT_LEAD_TIME, SUNDAY_LEAD_TIME, MONDAY_LEAD_TIME, TUESDAY_LEAD_TIME, WEDNESDAY_LEAD_TIME, THURSDAY_LEAD_TIME, FRIDAY_LEAD_TIME, SATURDAY_LEAD_TIME
            , RESOURCE_ID, LOAD_PER, CONTAINER_CATEGORY, CONTAINER_SIZE, TYPE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5 )
        SELECT  V_PLAN_ID
              , DM1.BUFFER_ID || DM2.BUFFER_ID AS BOD_ID
              , DM1.BUFFER_ID          AS FROM_BUFFER_ID
              , DM2.BUFFER_ID          AS TO_BUFFER_ID
              , 'TRK'                  AS TRANSPORT_MODE
              , 1                      AS PRIORITY
              , NULL                   AS TRANSIT_COST
              , V_PLAN_START_YYYYMMDD  AS EFF_START_DATE
              , V_PLAN_END_YYYYMMDD    AS EFF_END_DATE
              , 0                      AS DEFAULT_LEAD_TIME
              , 0                      AS SUNDAY_LEAD_TIME
              , 0                      AS MONDAY_LEAD_TIME
              , 0                      AS TUESDAY_LEAD_TIME
              , 0                      AS WEDNESDAY_LEAD_TIME
              , 0                      AS THURSDAY_LEAD_TIME
              , 0                      AS FRIDAY_LEAD_TIME
              , 0                      AS SATURDAY_LEAD_TIME
              , NULL                   AS RESOURCE_ID
              , NULL                   AS LOAD_PER
              , NULL                   AS CONTAINER_CATEGORY
              , NULL                   AS CONTAINER_SIZE
              , NULL                   AS TYPE
              , DM1.ATTRIBUTE1         AS ATTRIBUTE1
              , DM1.ATTRIBUTE2         AS ATTRIBUTE2
              , DM1.ATTRIBUTE3         AS ATTRIBUTE3
              , DM2.ATTRIBUTE1         AS ATTRIBUTE4
              , DM2.ATTRIBUTE2         AS ATTRIBUTE5
        FROM SCP_OPT_ENG_DEMAND_SN DM1   /* 원래 DEMAND */
        INNER JOIN SCP_OPT_ENG_DEMAND_SN DM2   /* GROUP DEMAND */
            ON  DM1.PLAN_ID     = DM2.PLAN_ID
            AND DM1.DEMAND_ID   = 'D_' || DM2.DEMAND_ID
            AND DM1.ATTRIBUTE13 = 'GROUP_DEMAND'
            AND DM2.ATTRIBUTE12 = 'DEMAND_GROUP'
        WHERE DM1.PLAN_ID = V_PLAN_ID
        GROUP BY DM1.BUFFER_ID, DM2.BUFFER_ID, DM1.ATTRIBUTE1, DM1.ATTRIBUTE2, DM1.ATTRIBUTE3, DM2.ATTRIBUTE1, DM2.ATTRIBUTE2;

        /* ---------------------------------------------------------------------- */
        /* 전진검사 A TYPE 적용 */

        /* ---------------------------------------------------------------------- */
        UPDATE SCP_OPT_ENG_BOD_SN BOD
        SET    BOD.ATTRIBUTE15 = 'DELETE'
        WHERE  1=1
        AND    BOD.PLAN_ID = V_PLAN_ID
        AND    EXISTS ( SELECT 1
                        FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                        WHERE  LU.LOOKUP_TYPE      = 'SCP_OPT_ENG_CONST_FORWARD_INSPECTION'
                        AND    LU.SEGMENT3         = V_DIVISION_ID
                        AND    LU.SEGMENT2         = V_GROUP_ID
                        AND    LU.SEGMENT4         = 'A'
                        AND    BOD.ATTRIBUTE1      = LU.ATTRIBUTE1
                        AND    BOD.ATTRIBUTE2      = LU.SEGMENT5
                        AND    BOD.ATTRIBUTE3      = LU.ATTRIBUTE2
                        AND    BOD.ATTRIBUTE4      = LU.ATTRIBUTE3
                        AND    BOD.ATTRIBUTE5      = LU.ATTRIBUTE4 || '@' || LU.ATTRIBUTE9
                        AND    BOD.TRANSPORT_MODE  = LU.ATTRIBUTE11 );

        /* ---------------------------------------------------------------------- */
        /* 2. BOD_ID,TO_BUFFER_ID,ATTRIBUTE 값을 바꾸고 나머지는 다 복사 */
        /* 3. BOD_ID,FROM_BUFFER_ID,LEAD_TIME,ATTRIBUTE 값을 바꾸고 나머지는 다 복사 */
        /* ---------------------------------------------------------------------- */
        INSERT INTO SCP_OPT_ENG_BOD_SN
            ( PLAN_ID, BOD_ID, FROM_BUFFER_ID, TO_BUFFER_ID, TRANSPORT_MODE, PRIORITY, TRANSIT_COST, EFF_START_DATE, EFF_END_DATE
            , DEFAULT_LEAD_TIME, SUNDAY_LEAD_TIME, MONDAY_LEAD_TIME, TUESDAY_LEAD_TIME, WEDNESDAY_LEAD_TIME, THURSDAY_LEAD_TIME, FRIDAY_LEAD_TIME, SATURDAY_LEAD_TIME
            , RESOURCE_ID, LOAD_PER, CONTAINER_CATEGORY, CONTAINER_SIZE, USER_ATTB1, USER_ATTB2, USER_ATTB3, USER_ATTB4, USER_ATTB5, USER_ATTB6, USER_ATTB7, USER_ATTB8
            , TYPE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9 )
        SELECT  BOD.PLAN_ID                                                                             AS PLAN_ID
              , BOD.TRANSPORT_MODE ||'::'|| BOD.FROM_BUFFER_ID ||'::'|| LU.ATTRIBUTE3 ||'::'|| LU.SEGMENT5 ||'::'|| LU.ATTRIBUTE2 ||'@'|| BOD.ATTRIBUTE6 ||'@'|| LU.ATTRIBUTE10 ||'::'|| BOD.ATTRIBUTE7 ||'::'|| BOD.EFF_START_DATE AS BOD_ID
              , BOD.FROM_BUFFER_ID                                                                      AS FROM_BUFFER_ID
              , LU.ATTRIBUTE3 ||'::'|| LU.SEGMENT5 ||'::'|| LU.ATTRIBUTE2 ||'@'|| BOD.ATTRIBUTE6 ||'@'|| LU.ATTRIBUTE10 AS TO_BUFFER_ID
              , BOD.TRANSPORT_MODE                                                                      AS TRANSPORT_MODE
              , BOD.PRIORITY                                                                            AS PRIORITY
              , BOD.TRANSIT_COST                                                                        AS TRANSIT_COST
              , BOD.EFF_START_DATE                                                                      AS EFF_START_DATE
              , BOD.EFF_END_DATE                                                                        AS EFF_END_DATE
              , BOD.DEFAULT_LEAD_TIME                                                                   AS DEFAULT_LEAD_TIME
              , BOD.SUNDAY_LEAD_TIME                                                                     AS SUNDAY_LEAD_TIME
              , BOD.MONDAY_LEAD_TIME                                                                     AS MONDAY_LEAD_TIME
              , BOD.TUESDAY_LEAD_TIME                                                                    AS TUESDAY_LEAD_TIME
              , BOD.WEDNESDAY_LEAD_TIME                                                                  AS WEDNESDAY_LEAD_TIME
              , BOD.THURSDAY_LEAD_TIME                                                                   AS THURSDAY_LEAD_TIME
              , BOD.FRIDAY_LEAD_TIME                                                                     AS FRIDAY_LEAD_TIME
              , BOD.SATURDAY_LEAD_TIME                                                                   AS SATURDAY_LEAD_TIME
              , BOD.RESOURCE_ID                                                                          AS RESOURCE_ID
              , BOD.LOAD_PER                                                                             AS LOAD_PER
              , BOD.CONTAINER_CATEGORY                                                                   AS CONTAINER_CATEGORY
              , BOD.CONTAINER_SIZE                                                                       AS CONTAINER_SIZE
              , BOD.USER_ATTB1                                                                           AS USER_ATTB1
              , BOD.USER_ATTB2                                                                           AS USER_ATTB2
              , BOD.USER_ATTB3                                                                           AS USER_ATTB3
              , BOD.USER_ATTB4                                                                           AS USER_ATTB4
              , BOD.USER_ATTB5                                                                           AS USER_ATTB5
              , BOD.USER_ATTB6                                                                           AS USER_ATTB6
              , BOD.USER_ATTB7                                                                           AS USER_ATTB7
              , BOD.USER_ATTB8                                                                           AS USER_ATTB8
              , BOD.TYPE                                                                                 AS TYPE
              , BOD.ATTRIBUTE1                                                                           AS ATTRIBUTE1
              , BOD.ATTRIBUTE2                                                                           AS ATTRIBUTE2
              , BOD.ATTRIBUTE3                                                                           AS ATTRIBUTE3
              , LU.ATTRIBUTE3                                                                            AS ATTRIBUTE4
              , LU.ATTRIBUTE2 ||'@'|| BOD.ATTRIBUTE6                                                     AS ATTRIBUTE5
              , BOD.ATTRIBUTE6                                                                           AS ATTRIBUTE6
              , BOD.ATTRIBUTE7                                                                           AS ATTRIBUTE7
              , BOD.ATTRIBUTE8                                                                           AS ATTRIBUTE8
              , LU.ATTRIBUTE10                                                                           AS ATTRIBUTE9
        FROM SCP_OPT_ENG_BOD_SN BOD
        INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
            ON  LU.LOOKUP_TYPE      = 'SCP_OPT_ENG_CONST_FORWARD_INSPECTION'
            AND LU.SEGMENT3         = V_DIVISION_ID
            AND LU.SEGMENT2         = V_GROUP_ID
            AND LU.SEGMENT4         = 'A'
            AND BOD.ATTRIBUTE1      = LU.ATTRIBUTE1
            AND BOD.ATTRIBUTE2      = LU.SEGMENT5
            AND BOD.ATTRIBUTE3      = LU.ATTRIBUTE2
            AND BOD.ATTRIBUTE4      = LU.ATTRIBUTE3
            AND BOD.ATTRIBUTE5      = LU.ATTRIBUTE4 || '@' || LU.ATTRIBUTE9
            AND BOD.TRANSPORT_MODE  = LU.ATTRIBUTE11
        WHERE 1=1
        AND   BOD.PLAN_ID = V_PLAN_ID
        UNION ALL
        SELECT  BOD.PLAN_ID                                                                             AS PLAN_ID
              , BOD.TRANSPORT_MODE ||'::'|| LU.ATTRIBUTE3 ||'::'|| LU.SEGMENT5 ||'::'|| LU.ATTRIBUTE2 ||'@'|| BOD.ATTRIBUTE6 ||'@'|| LU.ATTRIBUTE10 ||'::'|| BOD.TO_BUFFER_ID ||'::'|| 'DUMMY' ||'::'|| BOD.EFF_START_DATE AS BOD_ID
              , LU.ATTRIBUTE3 ||'::'|| LU.SEGMENT5 ||'::'|| LU.ATTRIBUTE2 ||'@'|| BOD.ATTRIBUTE6 ||'@'|| LU.ATTRIBUTE10 AS FROM_BUFFER_ID
              , BOD.TO_BUFFER_ID                                                                        AS TO_BUFFER_ID
              , BOD.TRANSPORT_MODE                                                                      AS TRANSPORT_MODE
              , BOD.PRIORITY                                                                            AS PRIORITY
              , BOD.TRANSIT_COST                                                                        AS TRANSIT_COST
              , BOD.EFF_START_DATE                                                                      AS EFF_START_DATE
              , BOD.EFF_END_DATE                                                                        AS EFF_END_DATE
              , TO_NUMBER(LU.ATTRIBUTE7)                                                                AS DEFAULT_LEAD_TIME
              , TO_NUMBER(LU.ATTRIBUTE7)                                                                AS SUNDAY_LEAD_TIME
              , TO_NUMBER(LU.ATTRIBUTE7)                                                                AS MONDAY_LEAD_TIME
              , TO_NUMBER(LU.ATTRIBUTE7)                                                                AS TUESDAY_LEAD_TIME
              , TO_NUMBER(LU.ATTRIBUTE7)                                                                AS WEDNESDAY_LEAD_TIME
              , TO_NUMBER(LU.ATTRIBUTE7)                                                                AS THURSDAY_LEAD_TIME
              , TO_NUMBER(LU.ATTRIBUTE7)                                                                AS FRIDAY_LEAD_TIME
              , TO_NUMBER(LU.ATTRIBUTE7)                                                                AS SATURDAY_LEAD_TIME
              , BOD.RESOURCE_ID                                                                         AS RESOURCE_ID
              , BOD.LOAD_PER                                                                            AS LOAD_PER
              , BOD.CONTAINER_CATEGORY                                                                  AS CONTAINER_CATEGORY
              , BOD.CONTAINER_SIZE                                                                      AS CONTAINER_SIZE
              , BOD.USER_ATTB1                                                                          AS USER_ATTB1
              , BOD.USER_ATTB2                                                                          AS USER_ATTB2
              , BOD.USER_ATTB3                                                                          AS USER_ATTB3
              , BOD.USER_ATTB4                                                                          AS USER_ATTB4
              , BOD.USER_ATTB5                                                                          AS USER_ATTB5
              , BOD.USER_ATTB6                                                                          AS USER_ATTB6
              , BOD.USER_ATTB7                                                                          AS USER_ATTB7
              , BOD.USER_ATTB8                                                                          AS USER_ATTB8
              , BOD.TYPE                                                                                AS TYPE
              , LU.ATTRIBUTE3                                                                           AS ATTRIBUTE1
              , BOD.ATTRIBUTE2                                                                          AS ATTRIBUTE2
              , LU.ATTRIBUTE2                                                                           AS ATTRIBUTE3
              , BOD.ATTRIBUTE4                                                                          AS ATTRIBUTE4
              , BOD.ATTRIBUTE5                                                                          AS ATTRIBUTE5
              , BOD.ATTRIBUTE6                                                                          AS ATTRIBUTE6
              , 'DUMMY'                                                                                 AS ATTRIBUTE7
              , BOD.ATTRIBUTE8                                                                          AS ATTRIBUTE8
              , BOD.ATTRIBUTE9                                                                          AS ATTRIBUTE9
        FROM SCP_OPT_ENG_BOD_SN BOD
        INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
            ON  LU.LOOKUP_TYPE      = 'SCP_OPT_ENG_CONST_FORWARD_INSPECTION'
            AND LU.SEGMENT3         = V_DIVISION_ID
            AND LU.SEGMENT2         = V_GROUP_ID
            AND LU.SEGMENT4         = 'A'
            AND BOD.ATTRIBUTE1      = LU.ATTRIBUTE1
            AND BOD.ATTRIBUTE2      = LU.SEGMENT5
            AND BOD.ATTRIBUTE3      = LU.ATTRIBUTE2
            AND BOD.ATTRIBUTE4      = LU.ATTRIBUTE3
            AND BOD.ATTRIBUTE5      = LU.ATTRIBUTE4 || '@' || LU.ATTRIBUTE9
            AND BOD.TRANSPORT_MODE  = LU.ATTRIBUTE11
        WHERE 1=1
        AND   BOD.PLAN_ID = V_PLAN_ID;

        /* ---------------------------------------------------------------------- */
        /* 4. 기존 BOD 삭제 */
        /* ---------------------------------------------------------------------- */
        DELETE FROM SCP_OPT_ENG_BOD_SN
        WHERE 1=1
        AND   PLAN_ID     = V_PLAN_ID
        AND   ATTRIBUTE15 = 'DELETE';

        /* ---------------------------------------------------------------------- */
        /* 2nd OCV 적용을 위한 BOD UPDATE (원본 UPDATE..FROM JOIN -> MERGE, 다중매치 MAX) */
        /* ---------------------------------------------------------------------- */
        MERGE INTO SCP_OPT_ENG_BOD_SN BOD
        USING ( SELECT  SEGMENT4          AS FROM_SITE_ID
                      , SEGMENT5          AS ITEM_ID
                      , MAX(ATTRIBUTE3)   AS LU_STAGE
                FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL
                WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                AND     VALID_YN    = 'Y'
                AND     SEGMENT2    = V_DIVISION_ID
                AND     SEGMENT3    = V_GROUP_ID
                GROUP BY SEGMENT4, SEGMENT5 ) S_OCV
        ON ( BOD.ATTRIBUTE1 = S_OCV.FROM_SITE_ID
         AND BOD.ATTRIBUTE2 = S_OCV.ITEM_ID
         AND BOD.PLAN_ID    = V_PLAN_ID )
        WHEN MATCHED THEN UPDATE SET
              BOD.BOD_ID         = BOD.TRANSPORT_MODE ||'::'|| BOD.ATTRIBUTE1 ||'::'|| BOD.ATTRIBUTE2 ||'::'|| S_OCV.LU_STAGE ||'::'|| BOD.TO_BUFFER_ID ||'::'|| BOD.ATTRIBUTE7 ||'::'|| BOD.EFF_START_DATE
            , BOD.FROM_BUFFER_ID = BOD.ATTRIBUTE1 ||'::'|| BOD.ATTRIBUTE2 ||'::'|| S_OCV.LU_STAGE
            , BOD.ATTRIBUTE3     = S_OCV.LU_STAGE;

        /* ---------------------------------------------------------------------- */
        /* PACKING EQUIPMENT CONSTRAINTS UPDATE */
        /* 2025.05.20 Philsu Park : 기존 BOD는 삭제 마킹, PACKING 대상 새로 Insert. */
        /* 1. 삭제대상 업데이트 (원본 UPDATE..FROM JOIN -> 상관 EXISTS) */
        /* ---------------------------------------------------------------------- */
        UPDATE SCP_OPT_ENG_BOD_SN BOD
        SET    BOD.ATTRIBUTE15 = 'DELETE'
             , BOD.BOD_ID      = BOD.BOD_ID || '_D'
        WHERE  1=1
        AND    BOD.PLAN_ID = V_PLAN_ID
        AND    EXISTS ( SELECT 1
                        FROM   GT_OPT_ENG_BOD_PKGEQP PE
                        WHERE  BOD.ATTRIBUTE1 = PE.FROM_SITE
                        AND    BOD.ATTRIBUTE2 = PE.MODEL
                        AND    BOD.ATTRIBUTE3 = PE.STAGE
                        AND    BOD.ATTRIBUTE4 = PE.TO_SITE );

        /* ---------------------------------------------------------------------- */
        /* 2025.05.20 Philsu Park : PACKING EQUIPMENT 대상 BOD 신규 INSERT */

        /* ---------------------------------------------------------------------- */
        INSERT INTO SCP_OPT_ENG_BOD_SN
            ( PLAN_ID, BOD_ID, FROM_BUFFER_ID, TO_BUFFER_ID, TRANSPORT_MODE, PRIORITY, TRANSIT_COST, EFF_START_DATE, EFF_END_DATE
            , DEFAULT_LEAD_TIME, SUNDAY_LEAD_TIME, MONDAY_LEAD_TIME, TUESDAY_LEAD_TIME, WEDNESDAY_LEAD_TIME, THURSDAY_LEAD_TIME, FRIDAY_LEAD_TIME, SATURDAY_LEAD_TIME
            , RESOURCE_ID, LOAD_PER, CONTAINER_CATEGORY, CONTAINER_SIZE, USER_ATTB1, USER_ATTB2, USER_ATTB3, USER_ATTB4, USER_ATTB5, USER_ATTB6, USER_ATTB7, USER_ATTB8
            , TYPE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE15 )
        WITH ORG_DATA AS (
            SELECT  CAL.BASIS_YYYYMMDD
                  , PKG.RSC_ID
                  , PKG.LD_PER
                  , PKG.PKG_TYPE
                  , LAG(CAL.BASIS_YYYYMMDD, 1, NULL) OVER ( PARTITION BY BOD.FROM_BUFFER_ID, BOD.TO_BUFFER_ID, BOD.TRANSPORT_MODE, NVL(PKG.RSC_ID, 'X') ORDER BY CAL.BASIS_YYYYMMDD ) AS PREV_YYYYMMDD
                  , BOD.PLAN_ID, BOD.BOD_ID, BOD.FROM_BUFFER_ID, BOD.TO_BUFFER_ID, BOD.TRANSPORT_MODE, BOD.PRIORITY, BOD.TRANSIT_COST
                  , BOD.DEFAULT_LEAD_TIME, BOD.SUNDAY_LEAD_TIME, BOD.MONDAY_LEAD_TIME, BOD.TUESDAY_LEAD_TIME, BOD.WEDNESDAY_LEAD_TIME, BOD.THURSDAY_LEAD_TIME, BOD.FRIDAY_LEAD_TIME, BOD.SATURDAY_LEAD_TIME
                  , BOD.CONTAINER_CATEGORY, BOD.CONTAINER_SIZE, BOD.USER_ATTB1, BOD.USER_ATTB2, BOD.USER_ATTB3, BOD.USER_ATTB4, BOD.USER_ATTB5, BOD.USER_ATTB6, BOD.USER_ATTB7, BOD.USER_ATTB8
                  , BOD.ATTRIBUTE1, BOD.ATTRIBUTE2, BOD.ATTRIBUTE3, BOD.ATTRIBUTE4, BOD.ATTRIBUTE5, BOD.ATTRIBUTE6, BOD.ATTRIBUTE7, BOD.ATTRIBUTE8, BOD.ATTRIBUTE9
            FROM SCP_OPT_ENG_BOD_SN BOD
            INNER JOIN SCM_SYS_CALENDAR_M CAL
                ON  CAL.BASIS_YYYYMMDD >= BOD.EFF_START_DATE
                AND CAL.BASIS_YYYYMMDD  < BOD.EFF_END_DATE
            LEFT OUTER JOIN (
                    SELECT DISTINCT
                           PK.FROM_SITE, PK.MODEL, PK.STAGE, PK.TO_SITE, PK.MODEL_GROUP, PK.FROM_DATE, PK.TO_DATE
                         , PK.FROM_SITE ||'::'|| 'PACKING_EQUIPMENT' ||'_'|| PK.MODEL_GROUP ||'@'|| PK.STAGE ||'::'|| PK.TO_SITE AS RSC_ID
                         , '1' AS LD_PER
                         , '1' AS PKG_TYPE
                    FROM GT_OPT_ENG_BOD_PKGEQP PK
                ) PKG
                ON  1=1
                AND PKG.FROM_SITE  = BOD.ATTRIBUTE1
                AND PKG.MODEL      = BOD.ATTRIBUTE2
                AND PKG.STAGE      = BOD.ATTRIBUTE3
                AND PKG.TO_SITE    = BOD.ATTRIBUTE4
                AND PKG.FROM_DATE <= CAL.BASIS_YYYYMMDD
                AND PKG.TO_DATE    > CAL.BASIS_YYYYMMDD
            WHERE 1=1
            AND   BOD.PLAN_ID = V_PLAN_ID
            AND   EXISTS ( SELECT 1
                           FROM   GT_OPT_ENG_BOD_PKGEQP P
                           WHERE  1=1
                           AND    P.FROM_SITE = BOD.ATTRIBUTE1
                           AND    P.MODEL     = BOD.ATTRIBUTE2
                           AND    P.STAGE     = BOD.ATTRIBUTE3
                           AND    P.TO_SITE   = BOD.ATTRIBUTE4 )
        )
        , GROUPED_DATA AS (
            SELECT  CASE WHEN (TO_DATE(BASIS_YYYYMMDD,'YYYYMMDD') - TO_DATE(PREV_YYYYMMDD,'YYYYMMDD')) <> 1 OR PREV_YYYYMMDD IS NULL THEN 1 ELSE 0 END AS NEW_GROUP
                  , OD.*
            FROM ORG_DATA OD
        )
        , SEGMENTED_DATA AS (
            SELECT  SUM(NEW_GROUP) OVER ( PARTITION BY PLAN_ID, FROM_BUFFER_ID, TO_BUFFER_ID, TRANSPORT_MODE ORDER BY BASIS_YYYYMMDD ) AS SEGMENT_ID
                  , GRP.*
            FROM GROUPED_DATA GRP
        )
        SELECT  BOD.PLAN_ID                                                                             AS PLAN_ID
              , BOD.TRANSPORT_MODE ||'::'|| BOD.FROM_BUFFER_ID ||'::'|| BOD.TO_BUFFER_ID ||'::'|| BOD.ATTRIBUTE7 ||'::'|| MIN(BOD.BASIS_YYYYMMDD) AS BOD_ID
              , BOD.FROM_BUFFER_ID                                                                      AS FROM_BUFFER_ID
              , BOD.TO_BUFFER_ID                                                                        AS TO_BUFFER_ID
              , BOD.TRANSPORT_MODE                                                                      AS TRANSPORT_MODE
              , MAX(BOD.PRIORITY)                                                                       AS PRIORITY
              , MAX(BOD.TRANSIT_COST)                                                                   AS TRANSIT_COST
              , MIN(BOD.BASIS_YYYYMMDD)                                                                 AS EFF_START_DATE
              , TO_CHAR(TO_DATE(MAX(BOD.BASIS_YYYYMMDD),'YYYYMMDD') + 1,'YYYYMMDD')                     AS EFF_END_DATE
              , MAX(BOD.DEFAULT_LEAD_TIME)                                                              AS DEFAULT_LEAD_TIME
              , MAX(BOD.SUNDAY_LEAD_TIME)                                                               AS SUNDAY_LEAD_TIME
              , MAX(BOD.MONDAY_LEAD_TIME)                                                               AS MONDAY_LEAD_TIME
              , MAX(BOD.TUESDAY_LEAD_TIME)                                                              AS TUESDAY_LEAD_TIME
              , MAX(BOD.WEDNESDAY_LEAD_TIME)                                                            AS WEDNESDAY_LEAD_TIME
              , MAX(BOD.THURSDAY_LEAD_TIME)                                                             AS THURSDAY_LEAD_TIME
              , MAX(BOD.FRIDAY_LEAD_TIME)                                                               AS FRIDAY_LEAD_TIME
              , MAX(BOD.SATURDAY_LEAD_TIME)                                                             AS SATURDAY_LEAD_TIME
              , BOD.RSC_ID                                                                              AS RESOURCE_ID
              , MAX(BOD.LD_PER)                                                                         AS LOAD_PER
              , MAX(BOD.CONTAINER_CATEGORY)                                                             AS CONTAINER_CATEGORY
              , MAX(BOD.CONTAINER_SIZE)                                                                 AS CONTAINER_SIZE
              , MAX(BOD.USER_ATTB1)                                                                     AS USER_ATTB1
              , MAX(BOD.USER_ATTB2)                                                                     AS USER_ATTB2
              , MAX(BOD.USER_ATTB3)                                                                     AS USER_ATTB3
              , MAX(BOD.USER_ATTB4)                                                                     AS USER_ATTB4
              , MAX(BOD.USER_ATTB5)                                                                     AS USER_ATTB5
              , MAX(BOD.USER_ATTB6)                                                                     AS USER_ATTB6
              , MAX(BOD.USER_ATTB7)                                                                     AS USER_ATTB7
              , MAX(BOD.USER_ATTB8)                                                                     AS USER_ATTB8
              , MAX(BOD.PKG_TYPE)                                                                       AS TYPE
              , MAX(BOD.ATTRIBUTE1)                                                                     AS ATTRIBUTE1
              , MAX(BOD.ATTRIBUTE2)                                                                     AS ATTRIBUTE2
              , MAX(BOD.ATTRIBUTE3)                                                                     AS ATTRIBUTE3
              , MAX(BOD.ATTRIBUTE4)                                                                     AS ATTRIBUTE4
              , MAX(BOD.ATTRIBUTE5)                                                                     AS ATTRIBUTE5
              , MAX(BOD.ATTRIBUTE6)                                                                     AS ATTRIBUTE6
              , MAX(BOD.ATTRIBUTE7)                                                                     AS ATTRIBUTE7
              , MAX(BOD.ATTRIBUTE8)                                                                     AS ATTRIBUTE8
              , MAX(BOD.ATTRIBUTE9)                                                                     AS ATTRIBUTE9
              , 'BY_PACKING_EQUIPMENT'                                                                  AS ATTRIBUTE15
        FROM SEGMENTED_DATA BOD
        WHERE 1=1
        AND   BOD.PLAN_ID = V_PLAN_ID
        GROUP BY BOD.SEGMENT_ID, BOD.PLAN_ID, BOD.FROM_BUFFER_ID, BOD.TO_BUFFER_ID, BOD.TRANSPORT_MODE, BOD.ATTRIBUTE7, BOD.RSC_ID;

        /* ---------------------------------------------------------------------- */
        /* 6. 기존 BOD 삭제 */
        /* ---------------------------------------------------------------------- */
        DELETE FROM SCP_OPT_ENG_BOD_SN
        WHERE 1=1
        AND   PLAN_ID     = V_PLAN_ID
        AND   ATTRIBUTE15 = 'DELETE';

        /* ---------------------------------------------------------------------- */
        /* 2025.08.29 YSH / 2025.09.03 Philsu Park : GM BOD 출하 LOT SIZE 적용 (ITEM 단위 LOT SIZE 룩업) */
        /* ---------------------------------------------------------------------- */
        INSERT INTO SCP_OPT_ENG_BOD_SN
            ( PLAN_ID, BOD_ID, FROM_BUFFER_ID, TO_BUFFER_ID, TRANSPORT_MODE, PRIORITY, TRANSIT_COST, EFF_START_DATE, EFF_END_DATE
            , DEFAULT_LEAD_TIME, SUNDAY_LEAD_TIME, MONDAY_LEAD_TIME, TUESDAY_LEAD_TIME, WEDNESDAY_LEAD_TIME, THURSDAY_LEAD_TIME, FRIDAY_LEAD_TIME, SATURDAY_LEAD_TIME
            , RESOURCE_ID, LOAD_PER, CONTAINER_CATEGORY, CONTAINER_SIZE, USER_ATTB1, USER_ATTB2, USER_ATTB3, USER_ATTB4, USER_ATTB5, USER_ATTB6, USER_ATTB7, USER_ATTB8
            , TYPE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE15 )
        SELECT  V_PLAN_ID                    AS PLAN_ID
              , BOD.BOD_ID ||'::'|| LU.SEGMENT3 AS BOD_ID
              , BOD.FROM_BUFFER_ID           AS FROM_BUFFER_ID
              , BOD.TO_BUFFER_ID             AS TO_BUFFER_ID
              , LU.SEGMENT3                  AS TRANSPORT_MODE
              , LU.ATTRIBUTE2                AS PRIORITY
              , BOD.TRANSIT_COST             AS TRANSIT_COST
              , BOD.EFF_START_DATE           AS EFF_START_DATE
              , BOD.EFF_END_DATE             AS EFF_END_DATE
              , BOD.DEFAULT_LEAD_TIME        AS DEFAULT_LEAD_TIME
              , BOD.SUNDAY_LEAD_TIME         AS SUNDAY_LEAD_TIME
              , BOD.MONDAY_LEAD_TIME         AS MONDAY_LEAD_TIME
              , BOD.TUESDAY_LEAD_TIME        AS TUESDAY_LEAD_TIME
              , BOD.WEDNESDAY_LEAD_TIME      AS WEDNESDAY_LEAD_TIME
              , BOD.THURSDAY_LEAD_TIME       AS THURSDAY_LEAD_TIME
              , BOD.FRIDAY_LEAD_TIME         AS FRIDAY_LEAD_TIME
              , BOD.SATURDAY_LEAD_TIME       AS SATURDAY_LEAD_TIME
              , BOD.RESOURCE_ID              AS RESOURCE_ID
              , BOD.LOAD_PER                 AS LOAD_PER
              , LU.SEGMENT3                  AS CONTAINER_CATEGORY
              , LU.ATTRIBUTE1                AS CONTAINER_SIZE
              , BOD.USER_ATTB1               AS USER_ATTB1
              , BOD.USER_ATTB2               AS USER_ATTB2
              , BOD.USER_ATTB3               AS USER_ATTB3
              , BOD.USER_ATTB4               AS USER_ATTB4
              , BOD.USER_ATTB5               AS USER_ATTB5
              , BOD.USER_ATTB6               AS USER_ATTB6
              , BOD.USER_ATTB7               AS USER_ATTB7
              , BOD.USER_ATTB8               AS USER_ATTB8
              , BOD.TYPE                     AS TYPE
              , BOD.ATTRIBUTE1               AS ATTRIBUTE1
              , BOD.ATTRIBUTE2               AS ATTRIBUTE2
              , BOD.ATTRIBUTE3               AS ATTRIBUTE3
              , BOD.ATTRIBUTE4               AS ATTRIBUTE4
              , BOD.ATTRIBUTE5               AS ATTRIBUTE5
              , BOD.ATTRIBUTE6               AS ATTRIBUTE6
              , BOD.ATTRIBUTE7               AS ATTRIBUTE7
              , BOD.ATTRIBUTE8               AS ATTRIBUTE8
              , BOD.ATTRIBUTE9               AS ATTRIBUTE9
              , BOD.ATTRIBUTE15              AS ATTRIBUTE15
        FROM SCP_OPT_ENG_BOD_SN BOD
        INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
            ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_SHIP_LOT_SIZE_NEW'
            AND LU.VALID_YN    = 'Y'
            AND LU.SEGMENT1    = V_DIVISION_ID
            AND LU.SEGMENT2    = V_GROUP_ID
            AND LU.SEGMENT6    = BOD.ATTRIBUTE1                                              /* FROM_SITE */
            AND LU.SEGMENT4    = CASE WHEN LU.SEGMENT4 = '-' THEN LU.SEGMENT4 ELSE BOD.ATTRIBUTE2 END  /* ITEM */
            AND LU.SEGMENT5    = BOD.ATTRIBUTE3                                              /* STAGE */
            AND LU.SEGMENT7    = BOD.ATTRIBUTE4                                              /* TO_SITE */
            AND LU.ATTRIBUTE2 != '1'
        WHERE BOD.PLAN_ID = V_PLAN_ID;

        /* ---------------------------------------------------------------------- */
        /* LOT SIZE UPDATE (ATTRIBUTE2='1' AND =PRIORITY, 원본 UPDATE..FROM JOIN -> 상관 UPDATE, 다중매치 MAX 가드) */
        /* ---------------------------------------------------------------------- */
        UPDATE SCP_OPT_ENG_BOD_SN BOD
        SET ( BOD.CONTAINER_CATEGORY, BOD.CONTAINER_SIZE, BOD.RESOURCE_ID, BOD.LOAD_PER, BOD.UPDATE_ID, BOD.UPDATE_TIME ) =
            ( SELECT  MAX(LU.SEGMENT3)
                    , MAX(LU.ATTRIBUTE1)
                    , MAX(LU.SEGMENT6 ||'::'|| LU.SEGMENT8)
                    , MAX(ROUND(1 / TO_NUMBER(CASE WHEN LU.ATTRIBUTE1 IS NULL THEN '1' ELSE LU.ATTRIBUTE1 END), 10))
                    , 'LOT_SIZE_UPDATE'
                    , SYSDATE
              FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
              WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_SHIP_LOT_SIZE_NEW'
              AND     LU.VALID_YN    = 'Y'
              AND     LU.SEGMENT1    = V_DIVISION_ID
              AND     LU.SEGMENT2    = V_GROUP_ID
              AND     LU.SEGMENT6    = BOD.ATTRIBUTE1
              AND     LU.SEGMENT4    = CASE WHEN LU.SEGMENT4 = '-' THEN LU.SEGMENT4 ELSE BOD.ATTRIBUTE2 END
              AND     LU.SEGMENT5    = BOD.ATTRIBUTE3
              AND     LU.SEGMENT7    = BOD.ATTRIBUTE4
              AND     LU.ATTRIBUTE2  = '1'
              AND     LU.ATTRIBUTE2  = BOD.PRIORITY )
        WHERE BOD.PLAN_ID = V_PLAN_ID
        AND   EXISTS ( SELECT 1
                       FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                       WHERE  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_SHIP_LOT_SIZE_NEW'
                       AND    LU.VALID_YN    = 'Y'
                       AND    LU.SEGMENT1    = V_DIVISION_ID
                       AND    LU.SEGMENT2    = V_GROUP_ID
                       AND    LU.SEGMENT6    = BOD.ATTRIBUTE1
                       AND    LU.SEGMENT4    = CASE WHEN LU.SEGMENT4 = '-' THEN LU.SEGMENT4 ELSE BOD.ATTRIBUTE2 END
                       AND    LU.SEGMENT5    = BOD.ATTRIBUTE3
                       AND    LU.SEGMENT7    = BOD.ATTRIBUTE4
                       AND    LU.ATTRIBUTE2  = '1'
                       AND    LU.ATTRIBUTE2  = BOD.PRIORITY );

        /* ---------------------------------------------------------------------- */
        /* 2025.11.13 Minyong Lee : TARGETBIZ 계획의 경우 CHAR -> CHAR BOD를 CHAR -> TARGETBIZ BOD로 복사 */
        /* 원본 SELECT * INTO #TGT_BOD -> UPDATE 3컬럼 -> INSERT SELECT * : 단일 INSERT..SELECT(전컬럼 명시)로 이식 */
        /* ---------------------------------------------------------------------- */
        IF V_PLAN_ID LIKE '%_TARGETBIZ' THEN
            INSERT INTO SCP_OPT_ENG_BOD_SN
                ( PLAN_ID, BOD_ID, FROM_BUFFER_ID, TO_BUFFER_ID, TRANSPORT_MODE, PRIORITY, TRANSIT_COST, EFF_START_DATE, EFF_END_DATE
                , DEFAULT_LEAD_TIME, SUNDAY_LEAD_TIME, MONDAY_LEAD_TIME, TUESDAY_LEAD_TIME, WEDNESDAY_LEAD_TIME, THURSDAY_LEAD_TIME, FRIDAY_LEAD_TIME, SATURDAY_LEAD_TIME
                , RESOURCE_ID, LOAD_PER, CONTAINER_CATEGORY, CONTAINER_SIZE, USER_ATTB1, USER_ATTB2, USER_ATTB3, USER_ATTB4, USER_ATTB5, USER_ATTB6, USER_ATTB7, USER_ATTB8
                , TYPE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME )
            SELECT  PLAN_ID
                  , TRANSPORT_MODE ||'::'|| FROM_BUFFER_ID ||'::'|| ATTRIBUTE4 ||'::'|| ATTRIBUTE2 ||'::'|| 'TARGETBIZ@DAP@-' ||'::'|| ATTRIBUTE7 ||'::'|| EFF_START_DATE AS BOD_ID
                  , FROM_BUFFER_ID
                  , ATTRIBUTE4 ||'::'|| ATTRIBUTE2 ||'::'|| 'TARGETBIZ@DAP@-' AS TO_BUFFER_ID
                  , TRANSPORT_MODE, PRIORITY, TRANSIT_COST, EFF_START_DATE, EFF_END_DATE
                  , DEFAULT_LEAD_TIME, SUNDAY_LEAD_TIME, MONDAY_LEAD_TIME, TUESDAY_LEAD_TIME, WEDNESDAY_LEAD_TIME, THURSDAY_LEAD_TIME, FRIDAY_LEAD_TIME, SATURDAY_LEAD_TIME
                  , RESOURCE_ID, LOAD_PER, CONTAINER_CATEGORY, CONTAINER_SIZE, USER_ATTB1, USER_ATTB2, USER_ATTB3, USER_ATTB4, USER_ATTB5, USER_ATTB6, USER_ATTB7, USER_ATTB8
                  , TYPE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, 'TARGETBIZ', ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                  , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
            FROM SCP_OPT_ENG_BOD_SN
            WHERE PLAN_ID    = V_PLAN_ID
            AND   ATTRIBUTE3 = 'CHAR'
            AND   ATTRIBUTE5 = 'CHAR';
        END IF;

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

END PR_SCP_OPT_ENG_ESS_INPUT_BOD;