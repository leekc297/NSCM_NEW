PROCEDURE           "PR_DM_CUST_DEMAND_BY_ITM_SUMMARY" 
(
    P_DIVISION_ID  VARCHAR2
   ,P_REPLAN_YN    VARCHAR2
   ,P_EXE_YYYYMMDD VARCHAR2
)
/* ===================================================================================================
 * Program ID  : PR_DM_CUST_DEMAND_BY_ITM_SUMMARY
 * Description  : 고객수요증감분석 데이터 기초값 생성 및 인터페이스 전송
 * 메인테이블
 *   DM_CUST_DEMAND_ANL_SUMMARY
 *   XIF_DM_ANL_MKT_PSI_DW_S
 *   XIF_DM_ANL_MKT_PSI_DETAIL_DW_S
 * Program History
 *===================================================================================================
 *   Date       In Charge       Description
 *===================================================================================================
 * 2024.10.30     KANG.H.J        [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
 * 2025.02.03     KANG.H.J        [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선 - 단종예상 및 신규 데이터 기능 보완
 * 2025.02.05     Philsu Park     Item 단위 집계 반영 추가.
 * 2025.02.17     Philsu Park     Test
 * 2025.06.23     KANG.H.J        [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2026.03.22     김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 * Usage
 *   PR_DM_CUST_DEMAND_BY_ITM_SUMMARY('81', 'N', '20241210');
 * 2026.07.06	ZIONEX		[PJ202650304] NextSCM Migration
 * =================================================================================================== */
 AS

    V_PROGRAM_NAME             VARCHAR2(200 CHAR) := $$PLSQL_UNIT;
    V_IN_PARA_DATA             CLOB;
    V_STEP                     VARCHAR2(4000 CHAR) := NULL;
    V_LOG_TYPE                 VARCHAR2(30 CHAR);
    N_LOG_COUNT                INTEGER := 0;
    V_LOG_MESSAGE              VARCHAR2(1000 CHAR);
    V_DESCRIPTION              VARCHAR2(500 CHAR);
    D_EVENT_DATE               DATE;
    N_DELETE_COUNT             INTEGER := 0;
    N_INSERT_COUNT             INTEGER := 0;
    V_CREATED_BY               VARCHAR2(150 CHAR) := 'SYS_ADMIN';
    V_CURR_MONTH               VARCHAR2(06 CHAR);
    V_PREV1_MONTH              VARCHAR2(06 CHAR);
    V_PREV2_MONTH              VARCHAR2(06 CHAR);
    V_PREV3_MONTH              VARCHAR2(06 CHAR);
    V_PREV4_MONTH              VARCHAR2(06 CHAR);
    V_CURR_MONTH_TUESDAY       VARCHAR2(08 CHAR);
    V_CURR_MONTH_MONDAY        VARCHAR2(08 CHAR);
    V_CURR_MONTH_FIRSTDAY      VARCHAR2(08 CHAR);
    V_CURR_MONTH_LASTDAY       VARCHAR2(08 CHAR);
    V_CURR_MKT_FCST_VERSION_NO VARCHAR2(4000 CHAR);
    V_CURR_MONTH_SUMMARY_CNT   INTEGER := 0;
    V_EXE_YYYYMMDD             VARCHAR2(8 CHAR);
    V_DELIMITER                VARCHAR2(1 CHAR);
    V_DIVISION_ID              VARCHAR2(10 CHAR);
    V_REPLAN_YN                VARCHAR2(01 CHAR);
    V_CNT_RESULT               INTEGER := 0;
    V_CNT_FCST                 INTEGER := 0;
    V_STD_MONTH                VARCHAR2(10 CHAR);
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;

    V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID, 'p_replan_yn' VALUE P_REPLAN_YN, 'p_exe_yyyymmdd' VALUE P_EXE_YYYYMMDD);


    /* LOG 용 변수 설정 */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START OF PROCEDURE ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_CREATED_BY);

    DBMS_OUTPUT.PUT_LINE('TRUNCATE TABLE GT_DCDB_DM_DEMAND_RSLT');

    DELETE FROM GT_DCDB_DM_DEMAND_RSLT;

    DBMS_OUTPUT.PUT_LINE('TRUNCATE TABLE GT_DCDB_DM_DEMAND_PLAN');
    DELETE FROM GT_DCDB_DM_DEMAND_PLAN;

    DBMS_OUTPUT.PUT_LINE('TRUNCATE TABLE GT_DCDB_MST_PJT');
    DELETE FROM GT_DCDB_MST_PJT;

    V_DIVISION_ID := P_DIVISION_ID;
    V_REPLAN_YN   := P_REPLAN_YN;
    IF P_EXE_YYYYMMDD IS NULL THEN
        V_EXE_YYYYMMDD := TO_CHAR(SYSTIMESTAMP, 'YYYYMMDD');
    ELSE
        V_EXE_YYYYMMDD := P_EXE_YYYYMMDD;
    END IF;

    /* STEP01 : 오늘이 당월의 첫주 수요일보다 작으면 RETURN */
    /* 오늘기준의 당월 / 전월 */
    V_CURR_MONTH  := SUBSTR(V_EXE_YYYYMMDD, 1, 6);
    V_PREV1_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_EXE_YYYYMMDD, 'YYYYMMDD'), -1), 'YYYYMM');
    V_PREV2_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_EXE_YYYYMMDD, 'YYYYMMDD'), -2), 'YYYYMM');
    V_PREV3_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_EXE_YYYYMMDD, 'YYYYMMDD'), -3), 'YYYYMM');
    V_PREV4_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_EXE_YYYYMMDD, 'YYYYMMDD'), -4), 'YYYYMM');

    /* 당월의 첫날 구하기 */
    V_CURR_MONTH_FIRSTDAY := SUBSTR(V_EXE_YYYYMMDD, 1, 6) || '01';

    /* 당월의 마지막날 구하기 */
    SELECT MAX(BASIS_YYYYMMDD)
      INTO V_CURR_MONTH_LASTDAY
      FROM SCM_SYS_CALENDAR_M A
     WHERE A.BASIS_YYYYMM = SUBSTR(V_EXE_YYYYMMDD, 1, 6);

    /* 당월의 첫 수요일 구하기  (당월의 첫 수요일이 있는 주가 당월의 첫주로 인식함.) */
    SELECT MIN(BASIS_YYYYMMDD)
      INTO V_CURR_MONTH_TUESDAY
      FROM SCM_SYS_CALENDAR_M A
     WHERE DAYOFWEEK = 'WED'
       AND A.BASIS_YYYYMMDD >= V_CURR_MONTH_FIRSTDAY
       AND A.BASIS_YYYYMMDD <= V_CURR_MONTH_LASTDAY;

    /* 당월의 첫 수요일이 있는 월요일 날짜 */
    SELECT BASIS_YYYYMMDD
      INTO V_CURR_MONTH_MONDAY
      FROM SCM_SYS_CALENDAR_M
     WHERE ISO_YYYYWW IN (SELECT ISO_YYYYWW FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = V_CURR_MONTH_TUESDAY)
       AND DAYOFWEEK = 'MON';

    /* 당월 첫주의 MKT_FCST VERSION_NO 추출 */
    SELECT MAX(VERSION_NO)
      INTO V_CURR_MKT_FCST_VERSION_NO
      FROM DM_MST_VERSION
     WHERE DIVISION_ID = V_DIVISION_ID
       AND VERSION_TYPE = 'MF_W'
       AND YYYYMMDD >= V_CURR_MONTH_MONDAY
       AND YYYYMMDD < TO_CHAR(TO_DATE(V_CURR_MONTH_MONDAY, 'YYYYMMDD') + (1) * 7, 'YYYYMMDD');

    /* -----------------------------------------------------------------------------------------------------
       대상데이터 LOG (START)
       ----------------------------------------------------------------------------------------------------- */
    V_LOG_TYPE    := 'APPEND';
    V_LOG_MESSAGE := 'MKT_FCST : ' || V_DIVISION_ID;
    V_DESCRIPTION := 'VERSION(M+0) : ' || V_CURR_MKT_FCST_VERSION_NO;
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    IF (V_EXE_YYYYMMDD < V_CURR_MONTH_TUESDAY) THEN
        /* 종료 LOG */
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        RETURN;
    END IF;

    IF (V_CURR_MKT_FCST_VERSION_NO IS NULL) THEN
        /* 종료 LOG */
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        RETURN;
    END IF;

    /* STEP02 : REPLAN을 할 경우는 재수행을 위해서 당월 SUMMARY 데이터 삭제 */
    IF (V_REPLAN_YN = 'Y') THEN

        DELETE
          FROM DM_CUST_DEMAND_BY_ITEM_SUMMARY
         WHERE DIVISION_ID = V_DIVISION_ID
           AND PLAN_YYYYMM = V_CURR_MONTH;

    END IF;

    /* STEP03 : 당월의 DM_CUST_DEMAND_ANL_SUMMARY cnt=0이면 당월 Summary 수행 (단, 그렇지 않다면 프로시져 종료) */
    SELECT COUNT(*)
      INTO V_CURR_MONTH_SUMMARY_CNT
      FROM DM_CUST_DEMAND_BY_ITEM_SUMMARY
     WHERE DIVISION_ID = V_DIVISION_ID
       AND PLAN_YYYYMM = V_CURR_MONTH;

    IF (V_CURR_MONTH_SUMMARY_CNT != 0) THEN
        /* 종료 LOG */
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        RETURN;
    END IF;

    /* 여기서부터 TRANSACTION 처리 */
    DBMS_OUTPUT.PUT_LINE('BB1--전월 FINAL 생성 ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    /* STEP04 : DM_CUST_DEMAND_ANL_SUMMARY.YYYYMM(전월-MKT_FCST_FNL)의 값 생성 */
    SELECT COUNT(*)
      INTO V_CNT_RESULT
      FROM DM_PLN_MKT_FCST_RESULT_C
     WHERE DIVISION_ID = V_DIVISION_ID
       AND VERSION_NO = V_CURR_MKT_FCST_VERSION_NO
       AND CUTOFF_TYPE = 'MF_W';

    SELECT COUNT(*)
      INTO V_CNT_FCST
      FROM DM_PLN_MKT_FCST_C
     WHERE DIVISION_ID = V_DIVISION_ID
       AND VERSION_NO = V_CURR_MKT_FCST_VERSION_NO
       AND CUTOFF_TYPE = 'MF_W';

    IF (V_CNT_RESULT != 0) THEN
        INSERT
          INTO GT_DCDB_DM_DEMAND_RSLT
             ( DIVISION_ID
             , VERSION_NO
             , CUTOFF_TYPE
             , CUTOFF_YYYYMMDD
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , YYYYMMDD
             , QTY )
        SELECT DIVISION_ID
             , VERSION_NO
             , CUTOFF_TYPE
             , CUTOFF_YYYYMMDD
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , YYYYMMDD
               /* -------------------------------------------------------
                  [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (CELL_PROD_SITE_ID KEY 추가에 따른 GROUP BY 처리 및 SUM_QTY 처리
                  , QTY
                  ------------------------------------------------------- */
             , SUM(QTY) QTY
          FROM DM_PLN_MKT_FCST_RESULT_C A
         WHERE A.DIVISION_ID = V_DIVISION_ID
           AND A.VERSION_NO = V_CURR_MKT_FCST_VERSION_NO
           AND A.FCST_TYPE IN ('MPS', 'Mass')
           AND A.MEASURE IN ('RTF_SYS_RP', 'CUST_FCST')
               /* -------------------------------------------------------
                  [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 START */
         GROUP BY DIVISION_ID
                , VERSION_NO
                , CUTOFF_TYPE
                , CUTOFF_YYYYMMDD
                , PROJECT_CODE
                , SCM_SITE_ID
                , ITEM_ID
                , DOM_EXP
                , FCST_TYPE
                , INCOTERMS
                , MEASURE
                , PLANT_SITE_ID
                , YYYYMMDD
               /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 END
                  ------------------------------------------------------- */
             ;

    ELSE
        INSERT
          INTO GT_DCDB_DM_DEMAND_RSLT
             ( DIVISION_ID
             , VERSION_NO
             , CUTOFF_TYPE
             , CUTOFF_YYYYMMDD
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , YYYYMMDD
             , QTY )
        SELECT DIVISION_ID
             , VERSION_NO
             , CUTOFF_TYPE
             , CUTOFF_YYYYMMDD
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , YYYYMMDD
               /* -------------------------------------------------------
                  [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (CELL_PROD_SITE_ID KEY 추가에 따른 GROUP BY 처리 및 SUM_QTY 처리
                  , QTY
                  ------------------------------------------------------- */
             , SUM(QTY) QTY
          FROM DM_PLN_MKT_FCST_RESULT_C_KEEP A
         WHERE A.DIVISION_ID = V_DIVISION_ID
           AND A.VERSION_NO = V_CURR_MKT_FCST_VERSION_NO
           AND A.FCST_TYPE IN ('MPS', 'Mass')
           AND A.MEASURE IN ('RTF_SYS_RP', 'CUST_FCST')
               /* -------------------------------------------------------
                  [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 START */
         GROUP BY DIVISION_ID
                , VERSION_NO
                , CUTOFF_TYPE
                , CUTOFF_YYYYMMDD
                , PROJECT_CODE
                , SCM_SITE_ID
                , ITEM_ID
                , DOM_EXP
                , FCST_TYPE
                , INCOTERMS
                , MEASURE
                , PLANT_SITE_ID
                , YYYYMMDD
               /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 END
                  ------------------------------------------------------- */
             ;
    END IF;

    IF (V_CNT_FCST != 0) THEN
        INSERT
          INTO GT_DCDB_DM_DEMAND_PLAN
             ( DIVISION_ID
             , VERSION_NO
             , CUTOFF_TYPE
             , CUTOFF_YYYYMMDD
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , YYYYMMDD
             , QTY )
        SELECT DIVISION_ID
             , VERSION_NO
             , CUTOFF_TYPE
             , CUTOFF_YYYYMMDD
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , YYYYMMDD
             , QTY
          FROM DM_PLN_MKT_FCST_C A
         WHERE A.DIVISION_ID = V_DIVISION_ID
           AND A.VERSION_NO = V_CURR_MKT_FCST_VERSION_NO
           AND A.FCST_TYPE IN ('MPS', 'Mass')
           AND A.MEASURE IN ('MKT_FCST', 'CUST_FCST');

    ELSE
        INSERT
          INTO GT_DCDB_DM_DEMAND_PLAN
             ( DIVISION_ID
             , VERSION_NO
             , CUTOFF_TYPE
             , CUTOFF_YYYYMMDD
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , YYYYMMDD
             , QTY )
        SELECT DIVISION_ID
             , VERSION_NO
             , CUTOFF_TYPE
             , CUTOFF_YYYYMMDD
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , YYYYMMDD
             , QTY
          FROM DM_PLN_MKT_FCST_C_KEEP A
         WHERE A.DIVISION_ID = V_DIVISION_ID
           AND A.VERSION_NO = V_CURR_MKT_FCST_VERSION_NO
           AND A.FCST_TYPE IN ('MPS', 'Mass')
           AND A.MEASURE IN ('MKT_FCST', 'CUST_FCST');
    END IF;

    /* 2025.02.11 Philsu Park: 실적에서 생성된 신규 데이터가 있을 수 있어 Summary 테이블에 INSERT INTO 처리 */
    BEGIN
        INSERT
          INTO DM_CUST_DEMAND_BY_ITEM_SUMMARY
             ( DIVISION_ID
             , END_CUSTOMER
             , PROJECT_CODE
             , ITEM_ID
             , MEASURE
             , PLAN_YYYYMM
             , PROJECT_NAME
             , CREATED_BY )
        SELECT A.DIVISION_ID AS DIVISION_ID
             , MST.END_CUSTOMER END_CUSTOMER
             , A.PROJECT_CODE PROJECT_CODE
             , A.ITEM_ID ITEM_ID
             , 'MKT_FCST_FNL' AS MEASURE
             , SUBSTR(A.YYYYMMDD, 1, 6) PLAN_YYYYMM
             , MAX(PJT.PROJECT_NAME) PROJECT_NAME
             , 'ADDED_FROM_RESULT' AS CREATED_BY
          FROM GT_DCDB_DM_DEMAND_RSLT A
             , SCM_MST_SITE MST
             , SCM_MST_PROJECT PJT
         WHERE A.DIVISION_ID = MST.DIVISION_ID
           AND A.SCM_SITE_ID = MST.SCM_SITE_ID
           AND A.DIVISION_ID = PJT.DIVISION_ID
           AND A.PROJECT_CODE = PJT.PROJECT_CODE
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.VERSION_NO = V_CURR_MKT_FCST_VERSION_NO
               /* AND    A.MEASURE     = 'RTF_SYS_RP' */
           AND SUBSTR(A.YYYYMMDD, 1, 6) = V_PREV1_MONTH
           AND NOT EXISTS (SELECT 1
                             FROM DM_CUST_DEMAND_BY_ITEM_SUMMARY SMR
                            WHERE SMR.DIVISION_ID = A.DIVISION_ID
                              AND SMR.END_CUSTOMER = MST.END_CUSTOMER
                              AND SMR.PROJECT_CODE = A.PROJECT_CODE
                              AND SMR.ITEM_ID = A.ITEM_ID
                              AND SMR.MEASURE = 'MKT_FCST_FNL'
                              AND SMR.PLAN_YYYYMM = SUBSTR(A.YYYYMMDD, 1, 6))
         GROUP BY A.DIVISION_ID, MST.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID, SUBSTR(A.YYYYMMDD, 1, 6);
    END;

    BEGIN
        /* 당월 CUST_FCST_QTY 및 각 월별 CUST_FCST_QTY/MKT_FCST는 동일 월의 FIRST에서 가져옴 */
        /* UPDATE A
        SET   A.CUST_FCST_QTY   = B.CUST_FCST_QTY
            , A.M1_CUST_FCST_QTY    = B.M1_CUST_FCST_QTY
            , A.M2_CUST_FCST_QTY    = B.M2_CUST_FCST_QTY
            , A.M3_CUST_FCST_QTY    = B.M3_CUST_FCST_QTY
            , A.M1_MKT_FCST_QTY     = B.M1_MKT_FCST_QTY
            , A.M2_MKT_FCST_QTY     = B.M2_MKT_FCST_QTY
            , A.M3_MKT_FCST_QTY     = B.M3_MKT_FCST_QTY
            , A.LAST_UPDATED_BY     = V_CREATED_BY
            , A.LAST_UPDATE_DATE    = SYSDATE
        FROM DM_CUST_DEMAND_ANL_SUMMARY A
        INNER JOIN DM_CUST_DEMAND_ANL_SUMMARY B
        ON    A.DIVISION_ID     = B.DIVISION_ID
        AND     A.END_CUSTOMER  = B.END_CUSTOMER
        AND     A.PROJECT_CODE  = B.PROJECT_CODE
        AND     A.PLAN_YYYYMM   = B.PLAN_YYYYMM
        AND   B.MEASURE         = 'MKT_FCST_FST'
        WHERE A.DIVISION_ID = v_division_id
        AND   A.PLAN_YYYYMM = v_prev1_month
        AND   A.MEASURE     = 'MKT_FCST_FNL';
        ; */
        /* 2025.02.06 Philsu Park: By Item 추가 */
        /* 당월 CUST_FCST_QTY 및 각 월별 CUST_FCST_QTY/MKT_FCST는 동일 월의 FIRST에서 가져옴 */
        MERGE INTO DM_CUST_DEMAND_BY_ITEM_SUMMARY A
        USING (SELECT * FROM DM_CUST_DEMAND_BY_ITEM_SUMMARY WHERE MEASURE = 'MKT_FCST_FST') B
        ON (A.DIVISION_ID = B.DIVISION_ID AND A.END_CUSTOMER = B.END_CUSTOMER AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID AND A.PLAN_YYYYMM = B.PLAN_YYYYMM AND A.DIVISION_ID = V_DIVISION_ID AND A.PLAN_YYYYMM = V_PREV1_MONTH AND A.MEASURE = 'MKT_FCST_FNL')
        WHEN MATCHED THEN
            UPDATE
               SET A.CUST_FCST_QTY    = B.CUST_FCST_QTY
                 , A.M1_CUST_FCST_QTY = B.M1_CUST_FCST_QTY
                 , A.M2_CUST_FCST_QTY = B.M2_CUST_FCST_QTY
                 , A.M3_CUST_FCST_QTY = B.M3_CUST_FCST_QTY
                 , A.M1_MKT_FCST_QTY  = B.M1_MKT_FCST_QTY
                 , A.M2_MKT_FCST_QTY  = B.M2_MKT_FCST_QTY
                 , A.M3_MKT_FCST_QTY  = B.M3_MKT_FCST_QTY
                 , A.LAST_UPDATED_BY  = V_CREATED_BY
                 , A.LAST_UPDATE_DATE = SYSDATE;
    END;

    /* 전월(MKT_FCST_FNL) MKT_FCST_QTY는 전월 실적에서 가져옴. */
    /* 당월 첫주 월요일이 당월일 경우 전월은 모두 실적임. */
    IF (SUBSTR(V_CURR_MONTH_MONDAY, 1, 6) = V_CURR_MONTH) THEN

        /* UPDATE A
        SET   A.MKT_FCST_QTY        = B.SUM_QTY
            , A.LAST_UPDATED_BY     = V_CREATED_BY
            , A.LAST_UPDATE_DATE    = SYSDATE
        FROM DM_CUST_DEMAND_ANL_SUMMARY A
        INNER JOIN
        (
            SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE
                , SUBSTR(A.YYYYMMDD, 1, 6) PLAN_YYYYMM
                , SUM(A.QTY) SUM_QTY
            INNER JOIN SCM_MST_SITE B
            ON   A.DIVISION_ID = B.DIVISION_ID
            AND  A.SCM_SITE_ID = B.SCM_SITE_ID
            WHERE A.DIVISION_ID   = v_division_id
            AND   A.VERSION_NO  = v_curr_mkt_fcst_version_no
            AND     A.MEASURE   = 'RTF_SYS_RP'
            AND   SUBSTR(A.YYYYMMDD, 1, 6) = v_prev1_month
            GROUP BY  A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, SUBSTR(A.YYYYMMDD, 1, 6)
        ) B
        ON    A.DIVISION_ID     = B.DIVISION_ID
        AND     A.END_CUSTOMER  = B.END_CUSTOMER
        AND     A.PROJECT_CODE  = B.PROJECT_CODE
        AND     A.PLAN_YYYYMM   = B.PLAN_YYYYMM
        AND     A.MEASURE       = 'MKT_FCST_FNL';
        ; */
        /* 2025.02.06 Philsu Park: By Item 추가 */
        MERGE INTO DM_CUST_DEMAND_BY_ITEM_SUMMARY A
        USING (SELECT *
                 FROM (SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID, SUBSTR(A.YYYYMMDD, 1, 6) PLAN_YYYYMM, SUM(NVL(A.QTY, 0)) SUM_QTY
                         FROM GT_DCDB_DM_DEMAND_RSLT A
                            , SCM_MST_SITE B
                        WHERE A.DIVISION_ID = B.DIVISION_ID
                          AND A.SCM_SITE_ID = B.SCM_SITE_ID
                          AND A.DIVISION_ID = V_DIVISION_ID
                          AND A.VERSION_NO = V_CURR_MKT_FCST_VERSION_NO
                          AND A.MEASURE = 'RTF_SYS_RP'
                          AND SUBSTR(A.YYYYMMDD, 1, 6) = V_PREV1_MONTH
                        GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID, SUBSTR(A.YYYYMMDD, 1, 6)) B) SRC_UPD
        ON (A.DIVISION_ID = SRC_UPD.DIVISION_ID AND A.END_CUSTOMER = SRC_UPD.END_CUSTOMER AND A.PROJECT_CODE = SRC_UPD.PROJECT_CODE AND A.ITEM_ID = SRC_UPD.ITEM_ID AND A.PLAN_YYYYMM = SRC_UPD.PLAN_YYYYMM AND A.MEASURE = 'MKT_FCST_FNL' AND A.DIVISION_ID = V_DIVISION_ID)
        WHEN MATCHED THEN
            UPDATE SET A.MKT_FCST_QTY = SRC_UPD.SUM_QTY, A.LAST_UPDATED_BY = V_CREATED_BY, A.LAST_UPDATE_DATE = SYSDATE;

        /* 당월 첫주 월요일이 전월일 경우 전월은 모두 (실적+계획)이 포함됨 */
    ELSIF (SUBSTR(V_CURR_MONTH_MONDAY, 1, 6) = V_PREV1_MONTH) THEN

        /* UPDATE A
        SET   A.MKT_FCST_QTY        = B.SUM_QTY
            , A.LAST_UPDATED_BY     = V_CREATED_BY
            , A.LAST_UPDATE_DATE    = SYSDATE
        FROM DM_CUST_DEMAND_ANL_SUMMARY A
        INNER JOIN
        (
            SELECT A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE, A.PLAN_YYYYMM
                 , SUM(A.SUM_QTY) SUM_QTY
            FROM
            (
                SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE
                    , SUBSTR(A.YYYYMMDD, 1, 6) PLAN_YYYYMM
                    , SUM(A.QTY) SUM_QTY
                INNER JOIN SCM_MST_SITE B
                ON   A.DIVISION_ID = B.DIVISION_ID
                AND  A.SCM_SITE_ID = B.SCM_SITE_ID
                WHERE A.DIVISION_ID   = v_division_id
                AND   A.VERSION_NO  = v_curr_mkt_fcst_version_no
                AND     A.MEASURE   = 'RTF_SYS_RP'
                AND   SUBSTR(A.YYYYMMDD, 1, 6) = v_prev1_month  -- '202409'
                GROUP BY  A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, SUBSTR(A.YYYYMMDD, 1, 6)
                UNION ALL
                SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE
                    , SUBSTR(A.YYYYMMDD, 1, 6) PLAN_YYYYMM
                    , SUM(A.QTY) SUM_QTY
                INNER JOIN SCM_MST_SITE B
                ON   A.DIVISION_ID = B.DIVISION_ID
                AND  A.SCM_SITE_ID = B.SCM_SITE_ID
                WHERE A.DIVISION_ID   = v_division_id
                AND   A.VERSION_NO  = v_curr_mkt_fcst_version_no
                AND     A.MEASURE   = 'MKT_FCST'
                AND   A.YYYYMMDD    >= v_curr_month_monday          -- '20240930'
                AND   A.YYYYMMDD    < v_curr_month_firstday     -- '20241001'
                GROUP BY  A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, SUBSTR(A.YYYYMMDD, 1, 6)
            ) A
            GROUP BY A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE, A.PLAN_YYYYMM
        ) B
        ON    A.DIVISION_ID     = B.DIVISION_ID
        AND     A.END_CUSTOMER  = B.END_CUSTOMER
        AND     A.PROJECT_CODE  = B.PROJECT_CODE
        AND     A.PLAN_YYYYMM   = B.PLAN_YYYYMM
        AND     A.MEASURE       = 'MKT_FCST_FNL';
        ; */
        /* 2025.02.06 Philsu Park: By Item 추가 */
        MERGE INTO DM_CUST_DEMAND_BY_ITEM_SUMMARY A
        USING (SELECT *
                 FROM (SELECT A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID, A.PLAN_YYYYMM, SUM(A.SUM_QTY) SUM_QTY
                         FROM (SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID, SUBSTR(A.YYYYMMDD, 1, 6) PLAN_YYYYMM, SUM(NVL(A.QTY, 0)) SUM_QTY
                                 FROM GT_DCDB_DM_DEMAND_RSLT A
                                    , SCM_MST_SITE B
                                WHERE A.DIVISION_ID = B.DIVISION_ID
                                  AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                  AND A.DIVISION_ID = V_DIVISION_ID
                                  AND A.VERSION_NO = V_CURR_MKT_FCST_VERSION_NO
                                  AND A.MEASURE = 'RTF_SYS_RP'
                                  AND SUBSTR(A.YYYYMMDD, 1, 6) = V_PREV1_MONTH /* '202409' */
                                GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID, SUBSTR(A.YYYYMMDD, 1, 6)
                                UNION ALL
                               SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID, SUBSTR(A.YYYYMMDD, 1, 6) PLAN_YYYYMM, SUM(NVL(A.QTY, 0)) SUM_QTY
                                 FROM GT_DCDB_DM_DEMAND_PLAN A
                                    , SCM_MST_SITE B
                                WHERE A.DIVISION_ID = B.DIVISION_ID
                                  AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                  AND A.DIVISION_ID = V_DIVISION_ID
                                  AND A.VERSION_NO = V_CURR_MKT_FCST_VERSION_NO
                                  AND A.MEASURE = 'MKT_FCST'
                                  AND A.YYYYMMDD >= V_CURR_MONTH_MONDAY /* '20240930' */
                                  AND A.YYYYMMDD < V_CURR_MONTH_FIRSTDAY /* '20241001' */
                                GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID, SUBSTR(A.YYYYMMDD, 1, 6)) A
                        GROUP BY A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID, A.PLAN_YYYYMM) B) SRC_UPD
        ON (A.DIVISION_ID = SRC_UPD.DIVISION_ID AND A.END_CUSTOMER = SRC_UPD.END_CUSTOMER AND A.PROJECT_CODE = SRC_UPD.PROJECT_CODE AND A.ITEM_ID = SRC_UPD.ITEM_ID AND A.PLAN_YYYYMM = SRC_UPD.PLAN_YYYYMM AND A.MEASURE = 'MKT_FCST_FNL' AND A.DIVISION_ID = V_DIVISION_ID)
        WHEN MATCHED THEN
            UPDATE SET A.MKT_FCST_QTY = SRC_UPD.SUM_QTY, A.LAST_UPDATED_BY = V_CREATED_BY, A.LAST_UPDATE_DATE = SYSDATE;

    END IF;

    DBMS_OUTPUT.PUT_LINE('BB2--당월 FIRST 생성 기준마련' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    /* STEP05 : DM_PLN_MKT_FCST_RESULT_C (M-26 ~ M) 사이에 있는 division / end_customer / project 코드 생성 ==> GT_DCDB_MST_PJT */
    /* 당월은 아래 기준으로만 생성함. */
    /* 2025.02.06 Philsu Park: Item ID 추가. */

    INSERT
      INTO GT_DCDB_MST_PJT
    SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, C.PROJECT_NAME, A.ITEM_ID
      FROM GT_DCDB_DM_DEMAND_RSLT A
         , SCM_MST_SITE B
         , SCM_MST_PROJECT C
     WHERE A.DIVISION_ID = B.DIVISION_ID
       AND A.SCM_SITE_ID = B.SCM_SITE_ID
       AND A.DIVISION_ID = C.DIVISION_ID
       AND A.PROJECT_CODE = C.PROJECT_CODE
       AND A.DIVISION_ID = V_DIVISION_ID
       AND A.PROJECT_CODE IS NOT NULL
       AND B.END_CUSTOMER IS NOT NULL
       AND MEASURE = 'RTF_SYS_RP'
       AND YYYYMMDD >= TO_CHAR(ADD_MONTHS(TO_DATE(V_EXE_YYYYMMDD, 'YYYYMMDD'), -12), 'YYYYMMDD') /* 12개월 기준 실적이 있을 경우만 */
       AND YYYYMMDD <= V_EXE_YYYYMMDD
       AND QTY != 0 /* 실적이 있을 때만 */
     GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, C.PROJECT_NAME, A.ITEM_ID
     UNION
    SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, C.PROJECT_NAME, A.ITEM_ID
      FROM GT_DCDB_DM_DEMAND_PLAN A
         , SCM_MST_SITE B
         , SCM_MST_PROJECT C
     WHERE A.DIVISION_ID = B.DIVISION_ID
       AND A.SCM_SITE_ID = B.SCM_SITE_ID
       AND A.DIVISION_ID = C.DIVISION_ID
       AND A.PROJECT_CODE = C.PROJECT_CODE
       AND A.DIVISION_ID = V_DIVISION_ID
       AND A.PROJECT_CODE IS NOT NULL
       AND B.END_CUSTOMER IS NOT NULL
       AND MEASURE IN ('MKT_FCST', 'CUST_FCST')
       AND YYYYMMDD >= V_CURR_MONTH_FIRSTDAY
       AND YYYYMMDD <= V_CURR_MONTH_LASTDAY
     GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, C.PROJECT_NAME, A.ITEM_ID;

    DBMS_OUTPUT.PUT_LINE('BB3--당월 FIRST 생성 ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    /* STEP06 : DM_CUST_DEMAND_ANL_SUMMARY.YYYYMM(당월-MKT_FCST_FST)의 값 생성 */
    /* 과거 데이터는 집계시점의 데이터를 가져옴. */
    /* 당월 첫주 월요일이 당월일 경우 당월 계획은 (전주 실적+ 당월 계획) 이어야 함.. */
    IF (SUBSTR(V_CURR_MONTH_MONDAY, 1, 6) = V_CURR_MONTH) THEN
        DBMS_OUTPUT.PUT_LINE('BB3-1--당월 FIRST 생성(1) ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

        INSERT
          INTO DM_CUST_DEMAND_BY_ITEM_SUMMARY
             ( DIVISION_ID
             , END_CUSTOMER
             , PROJECT_CODE
             , ITEM_ID
             , MEASURE
             , PLAN_YYYYMM
             , PROJECT_NAME
             , CUST_FCST_QTY
             , MKT_FCST_QTY
               /* , M1_CUST_FCST_QTY,M2_CUST_FCST_QTY,M3_CUST_FCST_QTY */
               /* , M1_MKT_FCST_QTY,M2_MKT_FCST_QTY,M3_MKT_FCST_QTY */
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE )
        SELECT A.DIVISION_ID
             , A.END_CUSTOMER
             , A.PROJECT_CODE
             , A.ITEM_ID
             , 'MKT_FCST_FST' AS MEASURE
             , V_CURR_MONTH PLAN_YYYYMM
             , A.PROJECT_NAME
             , SUM(NVL(B.SUM_QTY, 0)) CUST_FCST_QTY
             , SUM(NVL(C.SUM_QTY, 0)) MKT_FCST_QTY
               /* , NVL(D.M1_CUST_FCST_QTY, 0) M1_CUST_FCST_QTY */
               /* , NVL(D.M2_CUST_FCST_QTY, 0) M2_CUST_FCST_QTY */
               /* , NVL(D.M3_CUST_FCST_QTY, 0) M3_CUST_FCST_QTY */
               /* , NVL(D.M1_MKT_FCST_QTY, 0) M1_MKT_FCST_QTY */
               /* , NVL(D.M2_MKT_FCST_QTY, 0) M2_MKT_FCST_QTY */
               /* , NVL(D.M3_MKT_FCST_QTY, 0) M3_MKT_FCST_QTY */
             , V_CREATED_BY CREATED_BY
             , SYSDATE      CREATION_DATE
             , V_CREATED_BY LAST_UPDATED_BY
             , SYSDATE      LAST_UPDATE_DATE
          FROM GT_DCDB_MST_PJT A
             , ( /* CUST_FCST_QTY는 DM_PLN_MKT_FCST_C (CUST_FCST)에서 가져옴. */
                 /* 단, 당월의 계획값이 Result에 있어도 가져옴 */
                 /* ==> 버젼은 당주 첫주차 version_no = "MF_W_20241001_V002" */
                 SELECT A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID, SUM(A.SUM_QTY) SUM_QTY
                   FROM ( /* 당월의 전주 실적 */
                          SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID, SUM(NVL(A.QTY, 0)) SUM_QTY
                            FROM GT_DCDB_DM_DEMAND_RSLT A
                               , SCM_MST_SITE B
                           WHERE A.DIVISION_ID = B.DIVISION_ID
                             AND A.SCM_SITE_ID = B.SCM_SITE_ID
                             AND A.DIVISION_ID = V_DIVISION_ID
                             AND A.VERSION_NO = V_CURR_MKT_FCST_VERSION_NO
                                 /* AND   A.MEASURE IN ('Customer FCST','CUST_FCST_EDI') */
                             AND A.MEASURE IN ('CUST_FCST') /* CUST_FCST = Customer FCST + CUST_FCST_EDI 임 */
                             AND A.YYYYMMDD >= V_CURR_MONTH_FIRSTDAY
                             AND A.YYYYMMDD < V_CURR_MONTH_MONDAY
                           GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID
                           UNION ALL
                           /* 당월의 당주 이후 계획 */
                          SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID, SUM(NVL(A.QTY, 0)) SUM_QTY
                            FROM GT_DCDB_DM_DEMAND_PLAN A
                               , SCM_MST_SITE B
                           WHERE A.DIVISION_ID = B.DIVISION_ID
                             AND A.SCM_SITE_ID = B.SCM_SITE_ID
                             AND A.DIVISION_ID = V_DIVISION_ID
                             AND A.VERSION_NO = V_CURR_MKT_FCST_VERSION_NO
                             AND A.CUTOFF_TYPE = 'MF_W'
                                 /* AND   A.MEASURE IN ('Customer FCST','CUST_FCST_EDI') */
                             AND A.MEASURE IN ('CUST_FCST') /* CUST_FCST = Customer FCST + CUST_FCST_EDI 임 */
                             AND A.YYYYMMDD >= V_CURR_MONTH_MONDAY
                             AND A.YYYYMMDD <= V_CURR_MONTH_LASTDAY
                           GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID) A
                  GROUP BY A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID) B
             , ( /* MTK_FCST는 당월 계획 (MKT_FCST_C.MKT_FCST mesaure.version_no = "MF_W_20241001_V002" )에서 가져옴. */
                 /* (단, 당월 첫주가 전주라면  DM_PLN_MKT_FCST_RESULT_C(RTF_SYS_RP)에서 전주 1일 실적부터 합산함) */
                 SELECT A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID, SUM(SUM_QTY) SUM_QTY
                   FROM ( /* 당월의 전주 실적 */
                          SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID, SUM(NVL(A.QTY, 0)) SUM_QTY
                            FROM GT_DCDB_DM_DEMAND_RSLT A
                               , SCM_MST_SITE B
                           WHERE A.DIVISION_ID = B.DIVISION_ID
                             AND A.SCM_SITE_ID = B.SCM_SITE_ID
                             AND A.DIVISION_ID = V_DIVISION_ID
                             AND A.VERSION_NO = V_CURR_MKT_FCST_VERSION_NO
                             AND A.MEASURE IN ('RTF_SYS_RP')
                             AND A.YYYYMMDD >= V_CURR_MONTH_FIRSTDAY /* '20241101' */
                             AND A.YYYYMMDD < V_CURR_MONTH_MONDAY /* '20241104' */
                           GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID
                           UNION ALL
                           /* 당월의 당주 이후 계획 */
                          SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID, SUM(NVL(A.QTY, 0)) SUM_QTY
                            FROM GT_DCDB_DM_DEMAND_PLAN A
                               , SCM_MST_SITE B
                           WHERE A.DIVISION_ID = B.DIVISION_ID
                             AND A.SCM_SITE_ID = B.SCM_SITE_ID
                             AND A.DIVISION_ID = V_DIVISION_ID
                             AND A.VERSION_NO = V_CURR_MKT_FCST_VERSION_NO
                             AND A.CUTOFF_TYPE = 'MF_W'
                             AND A.MEASURE IN ('MKT_FCST')
                             AND A.YYYYMMDD >= V_CURR_MONTH_MONDAY /* '20241104' */
                             AND A.YYYYMMDD <= V_CURR_MONTH_LASTDAY /* '20241130' */
                           GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID) A
                  GROUP BY A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID) C
         WHERE A.DIVISION_ID = B.DIVISION_ID(+)
           AND A.END_CUSTOMER = B.END_CUSTOMER(+)
           AND A.PROJECT_CODE = B.PROJECT_CODE(+)
           AND A.ITEM_ID = B.ITEM_ID(+)
           AND A.DIVISION_ID = C.DIVISION_ID(+)
           AND A.END_CUSTOMER = C.END_CUSTOMER(+)
           AND A.PROJECT_CODE = C.PROJECT_CODE(+)
           AND A.ITEM_ID = C.ITEM_ID(+)
         GROUP BY A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE, A.PROJECT_NAME, A.ITEM_ID;
        /* 아래 로직은 PR_DM_CUST_DEMAND_ANL_SUMMARY_SUB 에서 생성함 */
        /* LEFT OUTER JOIN
        (
         -- M1_CUST_FCST_QTY / M2_CUST_FCST_QTY / M3_CUST_FCST_QTY / M1_MKT_FCST_QTY / M2_MKT_FCST_QTY / M3_MKT_FCST_QTY는  DM_CUST_DEMAND_ANL_SUMMARY (Final) 에서 가져옴.
         SELECT DIVISION_ID, END_CUSTOMER, PROJECT_CODE
            , CUST_FCST_QTY M1_CUST_FCST_QTY   -- 전월의 현재는 당월은 M-1임
            , M1_CUST_FCST_QTY M2_CUST_FCST_QTY        -- 전월의 M-1는 당월은 M-2임
            , M2_CUST_FCST_QTY M3_CUST_FCST_QTY        -- 전월의 M-2는 당월은 M-3임
            , MKT_FCST_QTY M1_MKT_FCST_QTY
            , M1_MKT_FCST_QTY M2_MKT_FCST_QTY
            , M2_MKT_FCST_QTY M3_MKT_FCST_QTY
         FROM DM_CUST_DEMAND_ANL_SUMMARY A
         WHERE A.DIVISION_ID = v_division_id
         AND   A.MEASURE   = 'MKT_FCST_FNL'
         AND   A.PLAN_YYYYMM = v_prev1_month
        ) D
        ON   A.DIVISION_ID   = D.DIVISION_ID
        AND A.END_CUSTOMER   = D.END_CUSTOMER
        AND A.PROJECT_CODE   = D.PROJECT_CODE */

        /* 당월 첫주 월요일이 전월일 경우 당월은 모두 계획임. */
    ELSIF (SUBSTR(V_CURR_MONTH_MONDAY, 1, 6) = V_PREV1_MONTH) THEN
        DBMS_OUTPUT.PUT_LINE('BB3-2--당월 FIRST 생성(2) ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

        INSERT
          INTO DM_CUST_DEMAND_BY_ITEM_SUMMARY
             ( DIVISION_ID
             , END_CUSTOMER
             , PROJECT_CODE
             , ITEM_ID
             , MEASURE
             , PLAN_YYYYMM
             , PROJECT_NAME
             , CUST_FCST_QTY
             , MKT_FCST_QTY
               /* , M1_CUST_FCST_QTY,M2_CUST_FCST_QTY,M3_CUST_FCST_QTY */
               /* , M1_MKT_FCST_QTY,M2_MKT_FCST_QTY,M3_MKT_FCST_QTY */
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE )
        SELECT A.DIVISION_ID
             , A.END_CUSTOMER
             , A.PROJECT_CODE
             , A.ITEM_ID
             , 'MKT_FCST_FST' AS MEASURE
             , V_CURR_MONTH PLAN_YYYYMM
             , A.PROJECT_NAME
             , SUM(NVL(B.SUM_QTY, 0)) CUST_FCST_QTY
             , SUM(NVL(C.SUM_QTY, 0)) MKT_FCST_QTY
               /* , NVL(D.M1_CUST_FCST_QTY, 0) M1_CUST_FCST_QTY */
               /* , NVL(D.M2_CUST_FCST_QTY, 0) M2_CUST_FCST_QTY */
               /* , NVL(D.M3_CUST_FCST_QTY, 0) M3_CUST_FCST_QTY */
               /* , NVL(D.M1_MKT_FCST_QTY, 0) M1_MKT_FCST_QTY */
               /* , NVL(D.M2_MKT_FCST_QTY, 0) M2_MKT_FCST_QTY */
               /* , NVL(D.M3_MKT_FCST_QTY, 0) M3_MKT_FCST_QTY */
             , V_CREATED_BY CREATED_BY
             , SYSDATE      CREATION_DATE
             , V_CREATED_BY LAST_UPDATED_BY
             , SYSDATE      LAST_UPDATE_DATE
          FROM GT_DCDB_MST_PJT A
             , ( /* CUST_FCST_QTY는 DM_PLN_MKT_FCST_C(Cust.FCST_RPA[P+P], CUST_FCST, CUST_FCST_EDI)에서 가져옴. ==> 버젼은 당주 첫주차 version_no = "MF_W_20241001_V002" */
                 SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID, SUM(NVL(A.QTY, 0)) SUM_QTY
                   FROM GT_DCDB_DM_DEMAND_PLAN A
                      , SCM_MST_SITE B
                  WHERE A.DIVISION_ID = B.DIVISION_ID
                    AND A.SCM_SITE_ID = B.SCM_SITE_ID
                    AND A.DIVISION_ID = V_DIVISION_ID
                    AND A.VERSION_NO = V_CURR_MKT_FCST_VERSION_NO
                    AND A.CUTOFF_TYPE = 'MF_W'
                        /* AND   A.MEASURE IN ('Customer FCST','CUST_FCST_EDI') */
                    AND A.MEASURE IN ('CUST_FCST') /* CUST_FCST = Customer FCST + CUST_FCST_EDI 임 */
                    AND A.YYYYMMDD >= V_CURR_MONTH_FIRSTDAY
                    AND A.YYYYMMDD <= V_CURR_MONTH_LASTDAY
                  GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID) B
             , ( /* MTK_FCST는 당월 계획 (MKT_FCST_C.MKT_FCST mesaure.version_no = "MF_W_20241001_V002" )에서 가져옴. */
                 /* (단, 당월 첫주가 전주라면  DM_PLN_MKT_FCST_RESULT_C(RTF_SYS_RP)에서 전주 1일 실적부터 합산함) */
                 SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID, SUM(NVL(A.QTY, 0)) SUM_QTY
                   FROM GT_DCDB_DM_DEMAND_PLAN A
                      , SCM_MST_SITE B
                  WHERE A.DIVISION_ID = B.DIVISION_ID
                    AND A.SCM_SITE_ID = B.SCM_SITE_ID
                    AND A.DIVISION_ID = V_DIVISION_ID
                    AND A.VERSION_NO = V_CURR_MKT_FCST_VERSION_NO
                    AND A.CUTOFF_TYPE = 'MF_W'
                    AND A.MEASURE IN ('MKT_FCST')
                    AND A.YYYYMMDD >= V_CURR_MONTH_FIRSTDAY
                    AND A.YYYYMMDD <= V_CURR_MONTH_LASTDAY
                  GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID) C
         WHERE A.DIVISION_ID = B.DIVISION_ID(+)
           AND A.END_CUSTOMER = B.END_CUSTOMER(+)
           AND A.PROJECT_CODE = B.PROJECT_CODE(+)
           AND A.ITEM_ID = B.ITEM_ID(+)
           AND A.DIVISION_ID = C.DIVISION_ID(+)
           AND A.END_CUSTOMER = C.END_CUSTOMER(+)
           AND A.PROJECT_CODE = C.PROJECT_CODE(+)
           AND A.ITEM_ID = C.ITEM_ID(+)
         GROUP BY A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE, A.ITEM_ID, A.PROJECT_NAME;
        /* LEFT OUTER JOIN
        (
           -- M1_CUST_FCST_QTY / M2_CUST_FCST_QTY / M3_CUST_FCST_QTY / M1_MKT_FCST_QTY / M2_MKT_FCST_QTY / M3_MKT_FCST_QTY는  DM_CUST_DEMAND_ANL_SUMMARY (Final) 에서 가져옴.
         SELECT DIVISION_ID, END_CUSTOMER, PROJECT_CODE
            , CUST_FCST_QTY M1_CUST_FCST_QTY   -- 전월의 현재는 당월은 M-1임
            , M1_CUST_FCST_QTY M2_CUST_FCST_QTY        -- 전월의 M-1는 당월은 M-2임
            , M2_CUST_FCST_QTY M3_CUST_FCST_QTY        -- 전월의 M-2는 당월은 M-3임
            , MKT_FCST_QTY M1_MKT_FCST_QTY
            , M1_MKT_FCST_QTY M2_MKT_FCST_QTY
            , M2_MKT_FCST_QTY M3_MKT_FCST_QTY
         FROM DM_CUST_DEMAND_ANL_SUMMARY A
         WHERE A.DIVISION_ID = v_division_id
         AND   A.MEASURE   = 'MKT_FCST_FNL'
         AND   A.PLAN_YYYYMM = v_prev1_month
        ) D
        ON   A.DIVISION_ID   = D.DIVISION_ID
        AND A.END_CUSTOMER   = D.END_CUSTOMER
        AND A.PROJECT_CODE   = D.PROJECT_CODE */

    END IF;

    DBMS_OUTPUT.PUT_LINE('BB4--당월 FINAL 생성 ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    /* STEP07 : DM_CUST_DEMAND_ANL_SUMMARY.YYYYMM(당월-MKT_FCST_FNL)의 값 DEFALT로 생성 */
    INSERT
      INTO DM_CUST_DEMAND_BY_ITEM_SUMMARY
         ( DIVISION_ID
         , END_CUSTOMER
         , PROJECT_CODE
         , ITEM_ID
         , MEASURE
         , PLAN_YYYYMM
         , PROJECT_NAME
         , CUST_FCST_QTY
         , MKT_FCST_QTY
           /* , M1_CUST_FCST_QTY,M2_CUST_FCST_QTY,M3_CUST_FCST_QTY */
           /* , M1_MKT_FCST_QTY,M2_MKT_FCST_QTY,M3_MKT_FCST_QTY */
         , CREATED_BY
         , CREATION_DATE
         , LAST_UPDATED_BY
         , LAST_UPDATE_DATE )
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.PROJECT_CODE
         , A.ITEM_ID
         , 'MKT_FCST_FNL' AS MEASURE
         , V_CURR_MONTH PLAN_YYYYMM
         , A.PROJECT_NAME
         , NVL(B.CUST_FCST_QTY, 0) CUST_FCST_QTY
         , 0 MKT_FCST_QTY
           /* , NVL(D.M1_CUST_FCST_QTY, 0) M1_CUST_FCST_QTY */
           /* , NVL(D.M2_CUST_FCST_QTY, 0) M2_CUST_FCST_QTY */
           /* , NVL(D.M3_CUST_FCST_QTY, 0) M3_CUST_FCST_QTY */
           /* , NVL(D.M1_MKT_FCST_QTY, 0) M1_MKT_FCST_QTY */
           /* , NVL(D.M2_MKT_FCST_QTY, 0) M2_MKT_FCST_QTY */
           /* , NVL(D.M3_MKT_FCST_QTY, 0) M3_MKT_FCST_QTY */
         , V_CREATED_BY CREATED_BY
         , SYSDATE      CREATION_DATE
         , V_CREATED_BY LAST_UPDATED_BY
         , SYSDATE      LAST_UPDATE_DATE
      FROM GT_DCDB_MST_PJT A
         , (SELECT DIVISION_ID, END_CUSTOMER, PROJECT_CODE, ITEM_ID, NVL(CUST_FCST_QTY, 0) CUST_FCST_QTY /* 당월의 FIRST의 CUST_FCST 가져옴 */
              FROM DM_CUST_DEMAND_BY_ITEM_SUMMARY A
             WHERE A.DIVISION_ID = V_DIVISION_ID
               AND A.MEASURE = 'MKT_FCST_FST'
               AND A.PLAN_YYYYMM = V_CURR_MONTH) B
     WHERE A.DIVISION_ID = B.DIVISION_ID(+)
       AND A.END_CUSTOMER = B.END_CUSTOMER(+)
       AND A.PROJECT_CODE = B.PROJECT_CODE(+)
       AND A.ITEM_ID = B.ITEM_ID(+);
    /* LEFT OUTER JOIN
    (
        -- M1_CUST_FCST_QTY / M2_CUST_FCST_QTY / M3_CUST_FCST_QTY / M1_MKT_FCST_QTY / M2_MKT_FCST_QTY / M3_MKT_FCST_QTY는  DM_CUST_DEMAND_ANL_SUMMARY (Final) 에서 가져옴.
        SELECT DIVISION_ID, END_CUSTOMER, PROJECT_CODE
                , CUST_FCST_QTY M1_CUST_FCST_QTY        -- 전월의 현재는 당월은 M-1임
                , M1_CUST_FCST_QTY M2_CUST_FCST_QTY     -- 전월의 M-1는 당월은 M-2임
                , M2_CUST_FCST_QTY M3_CUST_FCST_QTY     -- 전월의 M-2는 당월은 M-3임
                , MKT_FCST_QTY M1_MKT_FCST_QTY
                , M1_MKT_FCST_QTY M2_MKT_FCST_QTY
                , M2_MKT_FCST_QTY M3_MKT_FCST_QTY
        FROM DM_CUST_DEMAND_ANL_SUMMARY A
        WHERE A.DIVISION_ID   = v_division_id
        AND   A.MEASURE     = 'MKT_FCST_FNL'
        AND   A.PLAN_YYYYMM   = v_prev1_month
    ) D
    ON  A.DIVISION_ID = D.DIVISION_ID
    AND A.END_CUSTOMER  = D.END_CUSTOMER
    AND A.PROJECT_CODE  = D.PROJECT_CODE */

    /* STEP08 : 당월 기준 데이터가 없는 내용 0으로 추가 */
    INSERT
      INTO DM_CUST_DEMAND_BY_ITEM_SUMMARY
         ( DIVISION_ID
         , END_CUSTOMER
         , PROJECT_CODE
         , ITEM_ID
         , MEASURE
         , PLAN_YYYYMM
         , PROJECT_NAME
         , CUST_FCST_QTY
         , MKT_FCST_QTY
         , M1_CUST_FCST_QTY
         , M2_CUST_FCST_QTY
         , M3_CUST_FCST_QTY
         , M1_MKT_FCST_QTY
         , M2_MKT_FCST_QTY
         , M3_MKT_FCST_QTY
         , CREATED_BY
         , CREATION_DATE
         , LAST_UPDATED_BY
         , LAST_UPDATE_DATE )
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.PROJECT_CODE
         , A.ITEM_ID
         , B.MEASURE
         , V_CURR_MONTH   PLAN_YYYYMM
         , A.PROJECT_NAME
         , 0              CUST_FCST_QTY
         , 0              MKT_FCST_QTY
         , 0              M1_CUST_FCST_QTY
         , 0              M2_CUST_FCST_QTY
         , 0              M3_CUST_FCST_QTY
         , 0              M1_MKT_FCST_QTY
         , 0              M2_MKT_FCST_QTY
         , 0              M3_MKT_FCST_QTY
         , V_CREATED_BY   CREATED_BY
         , SYSDATE        CREATION_DATE
         , V_CREATED_BY   LAST_UPDATED_BY
         , SYSDATE        LAST_UPDATE_DATE
      FROM (SELECT A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE, A.PROJECT_NAME, A.ITEM_ID
              FROM GT_DCDB_MST_PJT A
                 , (SELECT *
                      FROM DM_CUST_DEMAND_BY_ITEM_SUMMARY
                     WHERE DIVISION_ID = V_DIVISION_ID
                       AND PLAN_YYYYMM = V_CURR_MONTH) B
             WHERE A.DIVISION_ID = B.DIVISION_ID(+)
               AND A.END_CUSTOMER = B.END_CUSTOMER(+)
               AND A.PROJECT_CODE = B.PROJECT_CODE(+)
               AND A.ITEM_ID = B.ITEM_ID(+)
               AND B.DIVISION_ID IS NULL) A
         , (SELECT 'MKT_FCST_FST' AS MEASURE FROM DUAL UNION ALL SELECT 'MKT_FCST_FNL' AS MEASURE FROM DUAL) B;

    /* STEP09 : (M-1 ~ M-3) 기준의 당월 계획 수집 */
    V_STD_MONTH := V_CURR_MONTH;

    /* PR_DM_CUST_DEMAND_ANL_SUMMARY_SUB(v_division_id, v_std_month, v_prev1_month, 'M-1'); */
    /* PR_DM_CUST_DEMAND_ANL_SUMMARY_SUB(v_division_id, v_std_month, v_prev2_month, 'M-2'); */
    /* PR_DM_CUST_DEMAND_ANL_SUMMARY_SUB(v_division_id, v_std_month, v_prev3_month, 'M-3'); */

    /* STEP10 : null 데이터 0으로 치환 */
    UPDATE DM_CUST_DEMAND_BY_ITEM_SUMMARY
       SET CUST_FCST_QTY    = NVL(CUST_FCST_QTY, 0)
         , MKT_FCST_QTY     = NVL(MKT_FCST_QTY, 0)
         , M1_CUST_FCST_QTY = NVL(M1_CUST_FCST_QTY, 0)
         , M2_CUST_FCST_QTY = NVL(M2_CUST_FCST_QTY, 0)
         , M3_CUST_FCST_QTY = NVL(M3_CUST_FCST_QTY, 0)
         , M1_MKT_FCST_QTY  = NVL(M1_MKT_FCST_QTY, 0)
         , M2_MKT_FCST_QTY  = NVL(M2_MKT_FCST_QTY, 0)
         , M3_MKT_FCST_QTY  = NVL(M3_MKT_FCST_QTY, 0)
     WHERE DIVISION_ID = V_DIVISION_ID
       AND PLAN_YYYYMM >= V_PREV1_MONTH
       AND (CUST_FCST_QTY IS NULL OR MKT_FCST_QTY IS NULL OR M1_CUST_FCST_QTY IS NULL OR M2_CUST_FCST_QTY IS NULL OR M3_CUST_FCST_QTY IS NULL OR
          M1_MKT_FCST_QTY IS NULL OR M2_MKT_FCST_QTY IS NULL OR M3_MKT_FCST_QTY IS NULL);


    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSTIMESTAMP;

    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    DBMS_OUTPUT.PUT_LINE('BB13-- END ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

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

        DBMS_OUTPUT.PUT_LINE('BB12-- ERROR ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || SUBSTR(SQLERRM, 1, 1000));


        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        DBMS_OUTPUT.PUT_LINE('BB13-- END ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
END;