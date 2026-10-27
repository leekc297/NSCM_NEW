PROCEDURE           "PR_DM_PLN_DEMANDID_PEGGING" (P_DIVISION_ID VARCHAR2)

/*=====================================================================================================================================================
    * Program ID   : PR_DM_PLN_DEMANDID_PEGGING
    * Description  : Demand ID 생성으로 FCST 변경이력추적 및 원인을 파악하기 위해서
    * Program History
    *=====================================================================================================================================================
    *   Date       In Charge   Description
    *=====================================================================================================================================================
    * 2018.05.04                   Demand Pegging 정보를 생성하기 위한 프로시져
    * 2018.10.04 KHSONG            PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM 호출 추가
    * 2019.01.10 KHSONG            SEQ 2자리 -> 3자리로 변경
    * 2022.04.05   hwi1993         GM JV 작업
    * 2025.02.05 KANG.H.J      [PJ2025-50017] 소형 매출계획 동기화 개선
    * 2025.05.07 KANG.H.J      [PJ2025-50188] 기준수요 (SCM_FCST 기반 NET_DEMAND 생성)
    * 2025.05.14 KANG.H.J      [PJ2025-50188] DM_PLN_NET_DEMAND 생성 기준을 가장 최근의 버젼을 기반으로 생성하도록 정의
    * 2025.05.29 KANG.H.J      [PJ2025-50188] GT_DPDPE_MKT_FCST 임시테이블 시작/끝 부분에 DROP 기능 추가
    * 2026/03/22 김준규          [PJ20264226] NextSCM Pilot 설계 및 개발
 * 2026.07.06	ZIONEX		[PJ202650304] NextSCM Migration
    *===================================================================================================================================================*/
 AS

    V_DIVISION_ID              VARCHAR2(60 CHAR);
    V_MKT_FCST_VERSION_NO      VARCHAR2(100 CHAR);
    V_LAST_DEMANDID_VERSION_NO VARCHAR2(100 CHAR);
    V_PROJECT_CODE             VARCHAR2(100 CHAR);
    V_SCM_SITE_ID              VARCHAR2(60 CHAR);
    V_ITEM_ID                  VARCHAR2(100 CHAR);
    V_DOM_EXP                  VARCHAR2(6 CHAR);
    V_FCST_TYPE                VARCHAR2(40 CHAR);
    V_INCOTERMS                VARCHAR2(20 CHAR);
    V_MEASURE                  VARCHAR2(100 CHAR);
    V_PLANT_SITE_ID            VARCHAR2(60 CHAR);
    V_CELL_PROD_SITE_ID        VARCHAR2(60 CHAR);
    V_BASIS_YYYYMMDD           VARCHAR2(08 CHAR);
    V_DEMAND_ID                VARCHAR2(100 CHAR);
    V_YYYYMMDD                 VARCHAR2(8 CHAR);
    V_QTY                      INTEGER := 0;
    V_MKT_FCST_YYYYMMDD        VARCHAR2(8 CHAR);
    V_MKT_FCST_QTY             INTEGER := 0;
    V_WORK_WEEK                VARCHAR2(8 CHAR);
    V_SPLIT_DEMAND_ID          VARCHAR2(100 CHAR);
    V_TARGET_DATE              DATE;
    V_CUTOFF_VERSION_TYPE      VARCHAR2(10 CHAR);
    V_MEASURE_FCST_TYPE        VARCHAR2(10 CHAR);
    V_PROGRAM_NAME             VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE                 VARCHAR2(30 CHAR);
    N_LOG_COUNT                INTEGER := 0;
    V_LOG_MESSAGE              VARCHAR2(1000 CHAR);
    V_DESCRIPTION              VARCHAR2(500 CHAR);
    D_EVENT_DATE               DATE;
    V_CNT_1                    INTEGER := 0;
    V_CNT_2                    INTEGER := 0;
    V_CNT_3                    INTEGER := 0;
    V_CNT_4                    INTEGER := 0;
    V_IN_PARA_DATA             CLOB;
    V_STEP                     VARCHAR2(4000 CHAR) := NULL;
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;
    V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID);

    /*  000 **********************************************************************************
        DECLARATION
        ****************************************************************************************
    */
    /* CURSOR RETURN VALUE */
    /* [PJ2025-50188] 기준수요 (SCM_FCST 기반 NET_DEMAND 생성) Start */
    /* [PJ2025-50188] 기준수요 (SCM_FCST 기반 NET_DEMAND 생성) End */
    /* -- LOG 용 변수 설정 */
    /*
        -- --------------------------------------------------------------------------------------
            : START LOG
        -- --------------------------------------------------------------------------------------
    */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSTIMESTAMP;

    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

    /* -------------------------------------------------------------------------------------- */

    /* -------------------------------------------------------------------------------------- */
    /*      -- [PJ2025-50188] 삭제... 전주 또는 당주 버젼 체크하는 로직이 변경이 되어 삭제함. Start
                -- [PJ2025-50188] LOOKUP 기반 CUTOFF_TYPE, MEASURE(MKT_FCST/SCM_FCST) 선택 Start
                IF (p_division_id = '40')
                BEGIN

                    SELECT SEGMENT2,
        ATTRIBUTE1
      INTO v_cutoff_version_type, v_measure_fcst_type
                    FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                    WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_CUTOFF_TYPE'
                    AND   SEGMENT1      = p_division_id

                END
                -- [PJ2025-50188] LOOKUP 기반 CUTOFF_TYPE, MEASURE(MKT_FCST/SCM_FCST) 선택 Start

                SELECT v_mkt_fcst_version_no = MAX(A.VERSION_NO)
                  FROM DM_MST_VERSION A
                 WHERE A.DIVISION_ID    = p_division_id
    --             AND A.CUTOFF_TYPE    = 'MF_W'
                   AND A.VERSION_TYPE =   v_cutoff_version_type; -- [PJ2025-50188] MF_W / SF_W

                --   and a.CUTOFF_YYYYMMDD < '20181001'  -- 과거 주차를 돌릴때 사용.
    */ /* [PJ2025-50188] 삭제... 전주 또는 당주 버젼 체크하는 로직이 변경이 되어 삭제함. End */
    /* [PJ2025-50188] DM_PLN_NET_DEMAND 생성 기준을 가장 최근의 버젼을 기반으로 생성하도록 정의 Start */
    BEGIN
        /* [PJ2025-50188] 전주 기준의 VERSION_NO / CUTOFF_TYPE / MEASURE 정의 */
        SELECT A.VERSION_NO
              ,A.VERSION_TYPE /* [PJ2025-50188] ㅡMF_W / SF_W */
              ,CASE
                   WHEN A.VERSION_TYPE = 'MF_W' THEN
                    'MKT_FCST'
                   WHEN A.VERSION_TYPE = 'SF_W' THEN
                    'SCM_FCST'
                   ELSE
                    ''
               END
        INTO   V_MKT_FCST_VERSION_NO, V_CUTOFF_VERSION_TYPE, V_MEASURE_FCST_TYPE
        FROM   (
                /* SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ, CREATION_DATE, RANK() OVER (ORDER BY CREATION_DATE DESC, YYYYMMDD DESC, VER_CRE_SEQ DESC) RN -- [PJ2025-50188] 가장 최근의 버젼 */
                SELECT DIVISION_ID
                       ,VERSION_NO
                       ,VERSION_TYPE
                       ,YYYYMMDD
                       ,VER_CRE_SEQ
                       ,CREATION_DATE
                       ,ROW_NUMBER() OVER(ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC, VERSION_TYPE DESC) RN /* [PJ2025-50188] 가장 최근의 버젼이며, SF_W가 MF_W보다 우선함. */
                FROM   DM_MST_VERSION
                WHERE  DIVISION_ID = P_DIVISION_ID
                AND    VERSION_TYPE IN ('MF_W', 'SF_W')) A
        WHERE  RN = 1;

    END;
    /* [PJ2025-50188] DM_PLN_NET_DEMAND 생성 기준을 가장 최근의 버젼을 기반으로 생성하도록 정의 End */
    V_TARGET_DATE := TO_DATE(SUBSTR(V_MKT_FCST_VERSION_NO, 6, 8), 'YYYYMMDD'); /* 기준일자를 설정 */

    SELECT MAX(VERSION_NO)
    INTO   V_LAST_DEMANDID_VERSION_NO
    FROM   DM_PLN_DEMANDID_PEGGING A
    WHERE  DIVISION_ID = P_DIVISION_ID
    AND    CHANGE_DATE < TO_CHAR(FN_NEXT_DAY(V_TARGET_DATE, 'MON') + (-1) * 7, 'YYYYMMDD') /* 당주 월요일 */
    AND    CHANGE_DATE >= TO_CHAR(FN_NEXT_DAY(V_TARGET_DATE, 'MON') + (-2) * 7, 'YYYYMMDD'); /* 전주 월요일 */

    /* 이번주차 생성대상 있으면 삭제 */
    DELETE FROM DM_PLN_DEMANDID_PEGGING
    WHERE  DIVISION_ID = P_DIVISION_ID
    AND    VERSION_NO = V_MKT_FCST_VERSION_NO;

    /* 생성일 주차 */
    SELECT ISO_YYYYWW INTO V_WORK_WEEK FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = TO_CHAR(V_TARGET_DATE, 'YYYYMMDD');

    /* [PJ2025-50188] GT_DPDPE_MKT_FCST 임시테이블 시작/끝 부분에 DROP 기능 추가 */
    /* 당주 Cutoff MKT FCST 정보 */
    DELETE FROM GT_DPDPE_CUTOFF_TODAY_TBL;

    /* 전주 CUTOFF의 전주 계획 */
    DELETE FROM GT_DPDPE_BF_WEEK_TBL;

    DELETE FROM GT_DPDPE_CO_CHECK_TMP;
    DELETE FROM GT_DPDPE_CO_CHECK_TMP2;
    DELETE FROM GT_DPDPE_LAST_WEEK_DEMAND_PEGG;
    /* [PJ2025-50017] 소형 매출계획 동기화 개선 - 전주/당주 DM_PLN_CFM_MKT_DEMAND_PLAN / DM_PLN_MKT_FCST  -- VERSION_NO 별로 구분가능 */
    DELETE FROM GT_DPDPE_MKT_FCST;

    /* ----------------------------------------------------------------------------------------- CarryOver 수량 계산 (start) */
    BEGIN
        /* ---------------------------------------------------------------------------------------- */
        /* [PJ2025-50017] 소형 매출계획 동기화 개선 - 각 사업부별 공통정보 임시테블에 저장 Start */
        IF (P_DIVISION_ID = '40') THEN

            INSERT
            INTO GT_DPDPE_MKT_FCST
                (DIVISION_ID
                ,VERSION_NO
                ,CUTOFF_TYPE
                ,CUTOFF_YYYYMMDD
                ,PROJECT_CODE
                ,SCM_SITE_ID
                ,ITEM_ID
                ,DOM_EXP
                ,FCST_TYPE
                ,INCOTERMS
                ,PLANT_SITE_ID
                ,CELL_PROD_SITE_ID
                ,MEASURE
                ,YYYYMMDD
                ,QTY)
                SELECT DIVISION_ID
                      ,VERSION_NO
                      ,CUTOFF_TYPE
                      ,CUTOFF_YYYYMMDD
                      ,END_CUSTOMER PROJECT_CODE /* [PJ2025-50017] 타 사업부 밑 다른 기준정보와 통일성을 갖추기 위해 END_CUSTOMER를 PROJECT 코드에 반영 */
                      ,SCM_SITE_ID
                      ,ITEM_ID
                      ,DOM_EXP
                      ,FCST_TYPE
                      ,INCOTERMS
                      ,PLANT_SITE_ID
                      ,CELL_PROD_SITE_ID
                      ,MEASURE
                      ,YYYYMMDD
                      ,QTY
                FROM   DM_PLN_CFM_MKT_DEMAND_PLAN_C /* [PJ2025-50017] 40 사업부 기준테이블 */
                WHERE  DIVISION_ID = P_DIVISION_ID
                AND    VERSION_NO = V_MKT_FCST_VERSION_NO
                AND    MEASURE IN ('MKT_FCST', 'SCM_FCST', 'VMI_In_Req', 'AS_In_Req'); /* 해당 MEASURE로 국한하지 않으면, MKT_AMT_KRW로 인해 OVERFLOW 발생 가능함. */

        ELSE
            INSERT
            INTO GT_DPDPE_MKT_FCST
                (DIVISION_ID
                ,VERSION_NO
                ,CUTOFF_TYPE
                ,CUTOFF_YYYYMMDD
                ,PROJECT_CODE
                ,SCM_SITE_ID
                ,ITEM_ID
                ,DOM_EXP
                ,FCST_TYPE
                ,INCOTERMS
                ,PLANT_SITE_ID
                ,CELL_PROD_SITE_ID
                ,MEASURE
                ,YYYYMMDD
                ,QTY)
                SELECT DIVISION_ID
                      ,VERSION_NO
                      ,CUTOFF_TYPE
                      ,CUTOFF_YYYYMMDD
                      ,PROJECT_CODE
                      ,SCM_SITE_ID
                      ,ITEM_ID
                      ,DOM_EXP
                      ,FCST_TYPE
                      ,INCOTERMS
                      ,PLANT_SITE_ID
                      ,'-' AS CELL_PROD_SITE_ID /* [PJ2025-50017] 81/82 사업부는 MKT_FCST에 CELL_PROD_SITE_ID가 없으므로 '-'로 정의 */
                      ,MEASURE
                      ,YYYYMMDD
                      ,QTY
                FROM   DM_PLN_MKT_FCST_C /* [PJ2025-50017] 81/82 사업부 기준테이블 */
                WHERE  DIVISION_ID = P_DIVISION_ID
                AND    VERSION_NO = V_MKT_FCST_VERSION_NO
                AND    MEASURE IN ('MKT_FCST', 'SCM_FCST', 'VMI_In_Req', 'AS_In_Req'); /* 해당 MEASURE로 국한하지 않으면, MKT_AMT_KRW로 인해 OVERFLOW 발생 가능함. */
        END IF;
        /* [PJ2025-50017] 소형 매출계획 동기화 개선 - 각 사업부별 공통정보 임시테블에 저장 End */
        INSERT
        INTO GT_DPDPE_CO_CHECK_TMP
            (DIVISION_ID
            ,PROJECT_CODE
            ,SCM_SITE_ID
            ,ITEM_ID
            ,DOM_EXP
            ,FCST_TYPE
            ,INCOTERMS
            ,PLANT_SITE_ID
            ,CELL_PROD_SITE_ID /* [PJ2025-50017] 추가 */
            ,YYYYMMDD
            ,DEMAND_ID
            ,QTY
            ,ACCUM_SUM
            ,ACCUM_SUM2
            ,LASTWEEK_RESULT
            ,LASTWEEK_PEGGING_FROM_THIS_WEEK
            ,CUTOFF_FCST_FROM_THIS_WEEK)
            SELECT A.DIVISION_ID
                  ,A.PROJECT_CODE
                  ,A.SCM_SITE_ID
                  ,A.ITEM_ID
                  ,A.DOM_EXP
                  ,A.FCST_TYPE
                  ,A.INCOTERMS
                  ,A.PLANT_SITE_ID
                  ,A.CELL_PROD_SITE_ID /* [PJ2025-50017] 추가 */
                  ,YYYYMMDD
                  ,DEMAND_ID
                  ,QTY
                  ,SUM(QTY) OVER(PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID ORDER BY YYYYMMDD DESC, A.DEMAND_ID DESC ROWS UNBOUNDED PRECEDING) ACCUM_SUM
                  , /* [PJ2025-50017] 소형 매출계획 동기화 개선(CELL_PROD_SITE_ID 추가) */
                   SUM(QTY) OVER(PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID) ACCUM_SUM2
                  , /* [PJ2025-50017] 소형 매출계획 동기화 개선(CELL_PROD_SITE_ID 추가) */
                   (SELECT NVL(SUM(NVL(QTY, 0)), 0)
                    FROM   DM_PLN_MKT_FCST_RESULT B
                    WHERE  1 = 1
                    AND    B.DIVISION_ID = A.DIVISION_ID
                    AND    B.PROJECT_CODE = A.PROJECT_CODE
                    AND    B.SCM_SITE_ID = A.SCM_SITE_ID
                    AND    B.ITEM_ID = A.ITEM_ID
                    AND    B.DOM_EXP = A.DOM_EXP
                    AND    B.FCST_TYPE = A.FCST_TYPE
                    AND    B.INCOTERMS = A.INCOTERMS
                    AND    B.MEASURE = 'RTF'
                    AND    B.PLANT_SITE_ID = A.PLANT_SITE_ID
                    AND    B.YYYYMMDD BETWEEN TO_CHAR(FN_NEXT_DAY(V_TARGET_DATE, 'MON') + (-2) * 7, 'YYYYMMDD') AND /* 전주구간 */
                           TO_CHAR(FN_NEXT_DAY(V_TARGET_DATE, 'SUN') + (-1) * 7, 'YYYYMMDD')) LASTWEEK_RESULT
                  ,(SELECT NVL(SUM(NVL(QTY, 0)), 0)
                    FROM   DM_PLN_DEMANDID_PEGGING B
                    WHERE  1 = 1
                    AND    B.DIVISION_ID = A.DIVISION_ID
                    AND    B.PROJECT_CODE = A.PROJECT_CODE
                    AND    B.SCM_SITE_ID = A.SCM_SITE_ID
                    AND    B.ITEM_ID = A.ITEM_ID
                    AND    B.DOM_EXP = A.DOM_EXP
                    AND    B.FCST_TYPE = A.FCST_TYPE
                    AND    B.INCOTERMS = A.INCOTERMS
                    AND    B.PLANT_SITE_ID = A.PLANT_SITE_ID
                    AND    B.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID /* [PJ2025-50017] 추가 */
                    AND    B.VERSION_NO = A.VERSION_NO
                    AND    B.YYYYMMDD BETWEEN TO_CHAR(FN_NEXT_DAY(V_TARGET_DATE, 'MON') + (-1) * 7, 'YYYYMMDD') AND /* 당주~11주후 구간 */
                           TO_CHAR(FN_NEXT_DAY(V_TARGET_DATE, 'SUN') + (11) * 7, 'YYYYMMDD')) LASTWEEK_PEGGING_FROM_THIS_WEEK
                  ,(SELECT NVL(SUM(NVL(QTY, 0)), 0)
                    FROM   GT_DPDPE_MKT_FCST B /* [PJ2025-50017] / [PJ2025-50188] DM_PLN_MKT_FCST_C / DM_PLN_CFM_MKT_DEMAND_PLAN_C */
                    WHERE  1 = 1
                    AND    B.DIVISION_ID = A.DIVISION_ID
                    AND    B.PROJECT_CODE = A.PROJECT_CODE
                    AND    B.SCM_SITE_ID = A.SCM_SITE_ID
                    AND    B.ITEM_ID = A.ITEM_ID
                    AND    B.DOM_EXP = A.DOM_EXP
                    AND    B.FCST_TYPE = A.FCST_TYPE
                    AND    B.INCOTERMS = A.INCOTERMS
                          /* AND B.MEASURE     = 'MKT_FCST' */
                    AND    B.MEASURE = V_MEASURE_FCST_TYPE /* [PJ2025-50188] 기준수요 (MKT_FCST / SCM_FCST) */
                    AND    B.PLANT_SITE_ID = A.PLANT_SITE_ID
                    AND    B.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID /* [PJ2025-50017] 추가 */
                    AND    B.VERSION_NO = V_MKT_FCST_VERSION_NO /* max version_no */
                    AND    B.YYYYMMDD BETWEEN TO_CHAR(FN_NEXT_DAY(V_TARGET_DATE, 'MON') + (-1) * 7, 'YYYYMMDD') AND /* 당주~11주후 구간 */
                           TO_CHAR(FN_NEXT_DAY(V_TARGET_DATE, 'SUN') + (1 * 11) * 7, 'YYYYMMDD')) CUTOFF_FCST_FROM_THIS_WEEK
            FROM   DM_PLN_DEMANDID_PEGGING A
            WHERE  DIVISION_ID = P_DIVISION_ID
            AND    VERSION_NO = V_LAST_DEMANDID_VERSION_NO
            AND    YYYYMMDD < TO_CHAR(FN_NEXT_DAY(V_TARGET_DATE, 'MON') + (-1) * 7, 'YYYYMMDD') /* 전주구간 */
            AND    YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(V_TARGET_DATE, 'MON') + (-2) * 7, 'YYYYMMDD');

        INSERT
        INTO GT_DPDPE_CO_CHECK_TMP2
            SELECT A.DIVISION_ID
                  ,A.PROJECT_CODE
                  ,A.SCM_SITE_ID
                  ,A.ITEM_ID
                  ,A.DOM_EXP
                  ,A.FCST_TYPE
                  ,A.INCOTERMS
                  ,A.PLANT_SITE_ID
                  ,A.CELL_PROD_SITE_ID
                  ,A.YYYYMMDD
                  ,A.DEMAND_ID
                  ,A.QTY
                  ,A.ACCUM_SUM
                  ,A.ACCUM_SUM2
                  ,A.LASTWEEK_RESULT
                  ,A.LASTWEEK_PEGGING_FROM_THIS_WEEK
                  ,A.CUTOFF_FCST_FROM_THIS_WEEK
                  ,CASE
                       WHEN (CUTOFF_FCST_FROM_THIS_WEEK - LASTWEEK_PEGGING_FROM_THIS_WEEK) > (ACCUM_SUM2 - LASTWEEK_RESULT) THEN
                        (ACCUM_SUM2 - LASTWEEK_RESULT)
                       ELSE
                        (CUTOFF_FCST_FROM_THIS_WEEK - LASTWEEK_PEGGING_FROM_THIS_WEEK)
                   END CO_NEED_QTY
            /* A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, YYYYMMDD, DEMAND_ID */
            FROM   GT_DPDPE_CO_CHECK_TMP A
            WHERE  LASTWEEK_PEGGING_FROM_THIS_WEEK < CUTOFF_FCST_FROM_THIS_WEEK
            AND    LASTWEEK_RESULT < ACCUM_SUM2;

        /* 최종 적용대상 전주 DEMAND ID */
        /* CARRYOVER 대상 */
        INSERT
        INTO GT_DPDPE_LAST_WEEK_DEMAND_PEGG
            SELECT A.DIVISION_ID
                  ,A.PROJECT_CODE
                  ,A.SCM_SITE_ID
                  ,A.ITEM_ID
                  ,A.DOM_EXP
                  ,A.FCST_TYPE
                  ,A.INCOTERMS
                  ,A.PLANT_SITE_ID
                  ,A.CELL_PROD_SITE_ID /* [PJ2025-50017] 추가 */
                  ,YYYYMMDD
                  ,DEMAND_ID
                  ,CASE
                       WHEN (CO_NEED_QTY - (ACCUM_SUM - QTY)) <= 0 THEN
                        0
                       WHEN QTY > (CO_NEED_QTY - (ACCUM_SUM - QTY)) THEN
                        (CO_NEED_QTY - (ACCUM_SUM - QTY))
                       ELSE
                        QTY
                   END AS QTY
            FROM   GT_DPDPE_CO_CHECK_TMP2 A
            WHERE  CASE
                       WHEN (CO_NEED_QTY - (ACCUM_SUM - QTY)) <= 0 THEN
                        0
                       WHEN QTY > (CO_NEED_QTY - (ACCUM_SUM - QTY)) THEN
                        (CO_NEED_QTY - (ACCUM_SUM - QTY))
                       ELSE
                        QTY
                   END > 0;

        INSERT
        INTO GT_DPDPE_LAST_WEEK_DEMAND_PEGG
        /* 당주 이후 구간 DEMAND ID */
            SELECT A.DIVISION_ID
                  ,A.PROJECT_CODE
                  ,A.SCM_SITE_ID
                  ,A.ITEM_ID
                  ,A.DOM_EXP
                  ,A.FCST_TYPE
                  ,A.INCOTERMS
                  ,A.PLANT_SITE_ID
                  ,A.CELL_PROD_SITE_ID /* [PJ2025-50017] 추가 */
                  ,YYYYMMDD
                  ,DEMAND_ID
                  ,QTY
            FROM   DM_PLN_DEMANDID_PEGGING A
            WHERE  DIVISION_ID = P_DIVISION_ID
            AND    VERSION_NO = V_LAST_DEMANDID_VERSION_NO
            AND    YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(V_TARGET_DATE, 'MON') + (-1) * 7, 'YYYYMMDD');

        /* -------------------------------------------------------------------------------------- */
    END;
    /* ----------------------------------------------------------------------------------------- CarryOver 수량 계산 (end) */
    /* 전주 DemandID 전체 ( CarryOver 반영된 값 ) */
    INSERT
    INTO GT_DPDPE_BF_WEEK_TBL
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, DEMAND_ID, QTY) /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, DEMAND_ID, QTY /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
        FROM   GT_DPDPE_LAST_WEEK_DEMAND_PEGG;

    /* 당주 MKT FCST 전체 ( CarryOver 반영된 값 ) */
    INSERT
    INTO GT_DPDPE_CUTOFF_TODAY_TBL
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY) /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
        SELECT A.DIVISION_ID
              ,A.PROJECT_CODE
              ,A.SCM_SITE_ID
              ,A.ITEM_ID
              ,A.DOM_EXP
              ,A.FCST_TYPE
              ,A.INCOTERMS
              ,A.PLANT_SITE_ID
              ,A.CELL_PROD_SITE_ID
              ,YYYYMMDD
              ,QTY /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
        FROM   GT_DPDPE_MKT_FCST A
        WHERE  A.VERSION_NO = V_MKT_FCST_VERSION_NO
        AND    A.DIVISION_ID = P_DIVISION_ID
        AND    A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(V_TARGET_DATE, 'MON') + (-1) * 7, 'YYYYMMDD')
        AND    A.YYYYMMDD < TO_CHAR(FN_NEXT_DAY(V_TARGET_DATE, 'MON') + (10) * 7, 'YYYYMMDD') /* Demand Pegging 정보를 만들기 위한 구간. */
              /* AND A.MEASURE     = 'MKT_FCST' */
        AND    A.MEASURE = V_MEASURE_FCST_TYPE /* [PJ2025-50188] 기준수요 (MKT_FCST / SCM_FCST) */
        AND    A.QTY > 0;

    /* PEGGING_TARGET_CUR CURSOR FAST_FORWARD FOR */
    FOR REC_PEGGING IN (SELECT DISTINCT A.DIVISION_ID
                                       ,A.PROJECT_CODE
                                       ,A.SCM_SITE_ID
                                       ,A.ITEM_ID
                                       ,A.DOM_EXP
                                       ,A.FCST_TYPE
                                       ,A.INCOTERMS
                                       ,A.PLANT_SITE_ID
                                       ,A.CELL_PROD_SITE_ID /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                        FROM   GT_DPDPE_BF_WEEK_TBL A, GT_DPDPE_CUTOFF_TODAY_TBL B
                        WHERE  A.DIVISION_ID = B.DIVISION_ID
                        AND    A.PROJECT_CODE = B.PROJECT_CODE
                        AND    A.SCM_SITE_ID = B.SCM_SITE_ID
                        AND    A.ITEM_ID = B.ITEM_ID
                        AND    A.DOM_EXP = B.DOM_EXP
                        AND    A.FCST_TYPE = B.FCST_TYPE
                        AND    A.INCOTERMS = B.INCOTERMS
                        AND    A.PLANT_SITE_ID = B.PLANT_SITE_ID
                        AND    A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID /* [PJ2025-50017] 추가 */
                        ) LOOP
        V_DIVISION_ID       := REC_PEGGING.DIVISION_ID;
        V_PROJECT_CODE      := REC_PEGGING.PROJECT_CODE;
        V_SCM_SITE_ID       := REC_PEGGING.SCM_SITE_ID;
        V_ITEM_ID           := REC_PEGGING.ITEM_ID;
        V_DOM_EXP           := REC_PEGGING.DOM_EXP;
        V_FCST_TYPE         := REC_PEGGING.FCST_TYPE;
        V_INCOTERMS         := REC_PEGGING.INCOTERMS;
        V_PLANT_SITE_ID     := REC_PEGGING.PLANT_SITE_ID;
        V_CELL_PROD_SITE_ID := REC_PEGGING.CELL_PROD_SITE_ID; /* [PJ2025-50017] 추가 */

        /* LAST_WEEK_DEMANDID_CUR CURSOR FAST_FORWARD FOR */
        FOR REC_LASTWEEK IN (SELECT A.DEMAND_ID, A.YYYYMMDD, A.QTY
                             FROM   GT_DPDPE_BF_WEEK_TBL A
                             WHERE  A.DIVISION_ID = V_DIVISION_ID
                             AND    A.PROJECT_CODE = V_PROJECT_CODE
                             AND    A.SCM_SITE_ID = V_SCM_SITE_ID
                             AND    A.ITEM_ID = V_ITEM_ID
                             AND    A.DOM_EXP = V_DOM_EXP
                             AND    A.FCST_TYPE = V_FCST_TYPE
                             AND    A.INCOTERMS = V_INCOTERMS
                             AND    A.PLANT_SITE_ID = V_PLANT_SITE_ID
                             AND    A.CELL_PROD_SITE_ID = V_CELL_PROD_SITE_ID /* [PJ2025-50017] 추가 */
                             ORDER  BY YYYYMMDD, DEMAND_ID) LOOP
            /* key 정보는 상위 cursor에서 정의된 값을 같이 쓰면됨. */
            V_DEMAND_ID := REC_LASTWEEK.DEMAND_ID;
            V_YYYYMMDD  := REC_LASTWEEK.YYYYMMDD;
            V_QTY       := REC_LASTWEEK.QTY;

            /* THIS_WEEK_MKT_FCST_CUR CURSOR FAST_FORWARD FOR */
            FOR REC_THISWEEK IN (SELECT A.YYYYMMDD, A.QTY
                                 FROM   GT_DPDPE_CUTOFF_TODAY_TBL A
                                 WHERE  A.DIVISION_ID = V_DIVISION_ID
                                 AND    A.PROJECT_CODE = V_PROJECT_CODE
                                 AND    A.SCM_SITE_ID = V_SCM_SITE_ID
                                 AND    A.ITEM_ID = V_ITEM_ID
                                 AND    A.DOM_EXP = V_DOM_EXP
                                 AND    A.FCST_TYPE = V_FCST_TYPE
                                 AND    A.INCOTERMS = V_INCOTERMS
                                 AND    A.PLANT_SITE_ID = V_PLANT_SITE_ID
                                 AND    A.CELL_PROD_SITE_ID = V_CELL_PROD_SITE_ID /* [PJ2025-50017] 추가 */
                                 AND    A.QTY > 0
                                 ORDER  BY YYYYMMDD) LOOP
                /* key 정보는 상위 cursor에서 정의된 값을 같이 쓰면됨. */
                V_MKT_FCST_YYYYMMDD := REC_THISWEEK.YYYYMMDD;
                V_MKT_FCST_QTY      := REC_THISWEEK.QTY;

                IF (V_QTY <= V_MKT_FCST_QTY) AND (V_QTY > 0) THEN
                    /* UPDATE GT_DPDPE_CUTOFF_TODAY_TBL */
                    UPDATE GT_DPDPE_CUTOFF_TODAY_TBL
                    SET    QTY = V_MKT_FCST_QTY - V_QTY
                    WHERE  DIVISION_ID = V_DIVISION_ID
                    AND    PROJECT_CODE = V_PROJECT_CODE
                    AND    SCM_SITE_ID = V_SCM_SITE_ID
                    AND    ITEM_ID = V_ITEM_ID
                    AND    DOM_EXP = V_DOM_EXP
                    AND    FCST_TYPE = V_FCST_TYPE
                    AND    INCOTERMS = V_INCOTERMS
                    AND    PLANT_SITE_ID = V_PLANT_SITE_ID
                    AND    CELL_PROD_SITE_ID = V_CELL_PROD_SITE_ID /* [PJ2025-50017] 추가 */
                    AND    YYYYMMDD = V_MKT_FCST_YYYYMMDD;

                    INSERT INTO DM_PLN_DEMANDID_PEGGING
                        (DIVISION_ID
                        ,DEMAND_ID
                        ,VERSION_NO
                        ,M_DEMAND_ID
                        ,M_VERSION_NO
                        ,CHANGE_DATE
                        ,DEMAND_CHANGE_TYPE
                        ,PROJECT_CODE
                        ,SCM_SITE_ID
                        ,ITEM_ID
                        ,DOM_EXP
                        ,FCST_TYPE
                        ,INCOTERMS
                        ,MEASURE
                        ,PLANT_SITE_ID
                        ,CELL_PROD_SITE_ID /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                        ,YYYYMMDD
                        ,M_YYYYMMDD
                        ,CHANGE_REASON
                        ,CREATION_WEEK
                        ,QTY
                        ,CREATED_BY
                        ,CREATION_DATE
                        ,LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE)
                        SELECT V_DIVISION_ID
                              ,V_DEMAND_ID
                              ,V_MKT_FCST_VERSION_NO
                              ,V_DEMAND_ID
                              ,V_LAST_DEMANDID_VERSION_NO
                              ,TO_CHAR(V_TARGET_DATE, 'YYYYMMDD')
                              ,CASE
                                   WHEN V_YYYYMMDD < TO_CHAR(FN_NEXT_DAY(V_TARGET_DATE, 'MON') + (-1) * 7, 'YYYYMMDD') THEN
                                    'CO'
                                   ELSE
                                    'MOVE'
                               END
                              ,V_PROJECT_CODE
                              ,V_SCM_SITE_ID
                              ,V_ITEM_ID
                              ,V_DOM_EXP
                              ,V_FCST_TYPE
                              ,V_INCOTERMS
                              ,V_MEASURE_FCST_TYPE /* [PJ2025-50188] 기준수요 (MKT_FCST / SCM_FCST) */
                              ,V_PLANT_SITE_ID
                              ,V_CELL_PROD_SITE_ID /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                              ,V_MKT_FCST_YYYYMMDD
                              ,V_YYYYMMDD
                              ,''
                              ,V_WORK_WEEK
                              ,V_QTY
                              ,'SYSTEM'
                              ,SYSDATE
                              ,'SYSTEM'
                              ,SYSDATE
                        FROM   DUAL;

                    V_QTY := 0;
                ELSIF (V_QTY > V_MKT_FCST_QTY) AND (V_QTY > 0) THEN
                    /* Demand ID가 Split이 필요한 Case */
                    /* UPDATE GT_DPDPE_CUTOFF_TODAY_TBL */
                    UPDATE GT_DPDPE_CUTOFF_TODAY_TBL
                    SET    QTY = 0
                    WHERE  DIVISION_ID = V_DIVISION_ID
                    AND    PROJECT_CODE = V_PROJECT_CODE
                    AND    SCM_SITE_ID = V_SCM_SITE_ID
                    AND    ITEM_ID = V_ITEM_ID
                    AND    DOM_EXP = V_DOM_EXP
                    AND    FCST_TYPE = V_FCST_TYPE
                    AND    INCOTERMS = V_INCOTERMS
                    AND    PLANT_SITE_ID = V_PLANT_SITE_ID
                    AND    CELL_PROD_SITE_ID = V_CELL_PROD_SITE_ID /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                    AND    YYYYMMDD = V_MKT_FCST_YYYYMMDD;

                    SELECT SUBSTR(MAX(DEMAND_ID), 1, 14) || '_' ||
                           SUBSTR('000' || TO_CHAR(TO_NUMBER(MAX(TO_NUMBER(SUBSTR(DEMAND_ID, LENGTH(DEMAND_ID) - INSTR(REVERSE(DEMAND_ID), '_') + 2)))) + 1)
                                 ,-3) /* 20190110 KHSONG SEQ 2자리 -> 3자리로 변경 */
                    INTO   V_SPLIT_DEMAND_ID
                    FROM   DM_PLN_DEMANDID_PEGGING
                    WHERE  SUBSTR(DEMAND_ID, 1, 14) = SUBSTR(V_DEMAND_ID, 1, 14);

                    INSERT INTO DM_PLN_DEMANDID_PEGGING
                        (DIVISION_ID
                        ,DEMAND_ID
                        ,VERSION_NO
                        ,M_DEMAND_ID
                        ,M_VERSION_NO
                        ,CHANGE_DATE
                        ,DEMAND_CHANGE_TYPE
                        ,PROJECT_CODE
                        ,SCM_SITE_ID
                        ,ITEM_ID
                        ,DOM_EXP
                        ,FCST_TYPE
                        ,INCOTERMS
                        ,MEASURE
                        ,PLANT_SITE_ID
                        ,CELL_PROD_SITE_ID /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                        ,YYYYMMDD
                        ,M_YYYYMMDD
                        ,CHANGE_REASON
                        ,CREATION_WEEK
                        ,QTY
                        ,CREATED_BY
                        ,CREATION_DATE
                        ,LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE)
                        SELECT V_DIVISION_ID
                              ,V_SPLIT_DEMAND_ID
                              ,V_MKT_FCST_VERSION_NO
                              ,V_DEMAND_ID
                              ,V_LAST_DEMANDID_VERSION_NO
                              ,TO_CHAR(V_TARGET_DATE, 'YYYYMMDD')
                              ,'SMOVE'
                              ,V_PROJECT_CODE
                              ,V_SCM_SITE_ID
                              ,V_ITEM_ID
                              ,V_DOM_EXP
                              ,V_FCST_TYPE
                              ,V_INCOTERMS
                              ,V_MEASURE_FCST_TYPE /* [PJ2025-50188] 기준수요 (MKT_FCST / SCM_FCST) */
                              ,V_PLANT_SITE_ID
                              ,V_CELL_PROD_SITE_ID /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                              ,V_MKT_FCST_YYYYMMDD
                              ,V_YYYYMMDD
                              ,''
                              ,V_WORK_WEEK
                              ,V_MKT_FCST_QTY
                              ,'SYSTEM'
                              ,SYSDATE
                              ,'SYSTEM'
                              ,SYSDATE
                        FROM   DUAL;

                    V_QTY := V_QTY - V_MKT_FCST_QTY;
                END IF;

            END LOOP;

        END LOOP;

    END LOOP;

    INSERT INTO DM_PLN_DEMANDID_PEGGING
        (DIVISION_ID
        ,DEMAND_ID
        ,VERSION_NO
        ,M_DEMAND_ID
        ,M_VERSION_NO
        ,CHANGE_DATE
        ,DEMAND_CHANGE_TYPE
        ,PROJECT_CODE
        ,SCM_SITE_ID
        ,ITEM_ID
        ,DOM_EXP
        ,FCST_TYPE
        ,INCOTERMS
        ,MEASURE
        ,PLANT_SITE_ID
        ,CELL_PROD_SITE_ID /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
        ,YYYYMMDD
        ,M_YYYYMMDD
        ,CHANGE_REASON
        ,CREATION_WEEK
        ,QTY
        ,CREATED_BY
        ,CREATION_DATE
        ,LAST_UPDATED_BY
        ,LAST_UPDATE_DATE)
        SELECT DIVISION_ID
              ,TO_CHAR(FN_NEXT_DAY(V_TARGET_DATE, 'MON') + (-1) * 7, 'YYYYMMDD') || '_' ||
               SUBSTR('00000' || TO_CHAR(ROW_NUMBER() OVER(ORDER BY YYYYMMDD)), -5) || '_000'
              ,V_MKT_FCST_VERSION_NO
              ,TO_CHAR(FN_NEXT_DAY(V_TARGET_DATE, 'MON') + (-1) * 7, 'YYYYMMDD') || '_' ||
               SUBSTR('00000' || TO_CHAR(ROW_NUMBER() OVER(ORDER BY YYYYMMDD)), -5) || '_000'
              ,V_MKT_FCST_VERSION_NO
              ,TO_CHAR(V_TARGET_DATE, 'YYYYMMDD')
              ,'NEW'
              ,PROJECT_CODE
              ,SCM_SITE_ID
              ,ITEM_ID
              ,DOM_EXP
              ,FCST_TYPE
              ,INCOTERMS
              ,V_MEASURE_FCST_TYPE /* [PJ2025-50188] 기준수요 (MKT_FCST / SCM_FCST) */
              ,PLANT_SITE_ID
              ,CELL_PROD_SITE_ID /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
              ,YYYYMMDD
              ,YYYYMMDD
              ,''
              ,V_WORK_WEEK
              ,QTY
              ,'SYSTEM'
              ,SYSDATE
              ,'SYSTEM'
              ,SYSDATE
        FROM   (SELECT DIVISION_ID
                      ,PROJECT_CODE
                      ,SCM_SITE_ID
                      ,ITEM_ID
                      ,DOM_EXP
                      ,FCST_TYPE
                      ,INCOTERMS
                      ,PLANT_SITE_ID
                      ,CELL_PROD_SITE_ID /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                      ,YYYYMMDD
                      ,QTY
                FROM   GT_DPDPE_CUTOFF_TODAY_TBL
                WHERE  QTY > 0
                UNION ALL
                SELECT DIVISION_ID
                      ,PROJECT_CODE
                      ,SCM_SITE_ID
                      ,ITEM_ID
                      ,DOM_EXP
                      ,FCST_TYPE
                      ,INCOTERMS
                      ,PLANT_SITE_ID
                      ,CELL_PROD_SITE_ID /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                      ,YYYYMMDD
                      ,QTY
                FROM   GT_DPDPE_MKT_FCST A
                WHERE  A.DIVISION_ID = P_DIVISION_ID
                AND    A.CUTOFF_TYPE = V_CUTOFF_VERSION_TYPE /* [PJ2025-50188] 기준수요 (MF_W / SF_W) */
                AND    A.MEASURE = V_MEASURE_FCST_TYPE /* [PJ2025-50188] 기준수요 (MKT_FCST / SCM_FCST) */
                AND    A.VERSION_NO = V_MKT_FCST_VERSION_NO /* max version_no */
                AND    A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(V_TARGET_DATE, 'MON') + (10) * 7, 'YYYYMMDD') /* Demand Pegging 정보를 만들기 위한 구간. */
                AND    A.YYYYMMDD < TO_CHAR(FN_NEXT_DAY(V_TARGET_DATE, 'MON') + (11) * 7, 'YYYYMMDD') /* Demand Pegging 정보를 만들기 위한 구간. */
                ) ZZ;

    /* [PJ2025-50188] GT_DPDPE_MKT_FCST 임시테이블 시작/끝 부분에 DROP 기능 추가 */
    /* 원본(MSSQL): COMMIT TRAN 후 SECTION_SUM 호출 (SECTION_SUM은 커밋된 트랜잭션 밖에서 실행) */
    COMMIT;

    /* 20181004 KHSONG PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM 호출 추가 */
    PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM(P_DIVISION_ID);

    /* -------------------------------------------------------------------------------------- */
    /*     : END LOG */
    /* -------------------------------------------------------------------------------------- */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSTIMESTAMP;

    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    /* -------------------------------------------------------------------------------------- */

    /* -------------------------------------------------------------------------------------- */
    /* ERROR */
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                            ,'ERROR'
                            ,0
                            ,SQLERRM
                            ,NULL
                            ,SYSDATE
                            ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                            ,P_SQL_ERR_CODE  => SQLCODE
                            ,P_SQL_ERR_MSG   => SQLERRM
                            ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        /* -------------------------------------------------------------------------------------- */
        /*     : END LOG  (원본은 END LOG가 TRY/CATCH 밖이라 에러 경로에서도 항상 기록됨) */
        /* -------------------------------------------------------------------------------------- */
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

END;