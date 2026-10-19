PROCEDURE           "PR_DM_PLN_CFM_TO_MKT_FCST_ALL" 
(
    P_DIVISION   VARCHAR2
)
/*=====================================================================================================================================================
 * Program ID   : PR_DM_PLN_CFM_TO_MKT_FCST_ALL
 * Description  : FcstPrice MGMT화면 전체데이터 동기화
                  DM_PLN_CFM_MKT_DEMAND_PLAN -> DM_PLN_MKT_FCST
                  DM_PLN_CFM_SELLING_PRICE   -> SCM_MST_FUTURE_PRICE
                  해당 작업 후 DAILY CUTOFF 배치 실행하도록 배치셋팅
                  (만약, 해당 작업 후 DAILY CUTOFF 프로시져 수행하지 않는다면, SALES PLAN 동기화 따로 실행해줘야함)
 * Program History
 *=====================================================================================================================================================
 *  Date        In Charge       Description
 *=====================================================================================================================================================
 * 2025-12-29   JSSBAE          [E20251224-000842]_81사업부 FCST&PRICE MGMT UI Setup 공수 산정
 * 2026.07.06   ZIONEX          [PJ202650304]  NextSCM Migration
 * EXEC PR_DM_PLN_CFM_TO_MKT_FCST_ALL '40'
*====================================================================================================================================================*/
AS
    /* LOG 용 변수 설정 (START) */
    V_PROGRAM_NAME        VARCHAR2(150 CHAR) := 'PR_DM_PLN_CFM_TO_MKT_FCST_ALL';
    V_LOG_TYPE            VARCHAR2(30 CHAR);    /* START/END/ERROR/... */
    N_LOG_COUNT           INTEGER := 0;
    V_LOG_MESSAGE         VARCHAR2(1000 CHAR);
    V_DESCRIPTION         VARCHAR2(500 CHAR);
    D_EVENT_DATE          DATE;
    /* LOG 용 변수 설정 (END) */
    /* 프로시져 사용 변수 설정 (START) */
    V_PLAN_START_YYYYMMDD VARCHAR2(8 CHAR);
    V_CREATED_BY          VARCHAR2(100 CHAR);
    /* 프로시져 사용 변수 설정 (END) */
BEGIN

    V_PLAN_START_YYYYMMDD := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');   /* 월요일 */
    V_CREATED_BY          := 'BATCH_CFM_TO_ALL';

    /* 시작 LOG (START) */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '@p_created_by : ' || V_CREATED_BY;
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL;
    /* 시작 LOG (END) */

    /* 트랜잭션 (START) */
    BEGIN

        /* 1. DM_PLN_CFM_MKT_DEMAND_PLAN 기준으로 DM_PLN_MKT_FCST 데이터 동기화 (START) */
        /* 1). 당주 월요일 이후 DM_PLN_MKT_FCST 데이터를 삭제한다 */
        DELETE FROM DM_PLN_MKT_FCST
         WHERE DIVISION_ID = P_DIVISION
           AND YYYYMMDD    >= V_PLAN_START_YYYYMMDD
--         AND MEASURE IN ('MKT_FCST', 'SCM_FCST', 'VMI_IN_REQ');   --  2026.10.08 AJS
           AND MEASURE IN ('MKT_FCST', 'SCM_FCST', 'VMI_In_Req');   --  2026.10.08 AJS

        /* 2). DM_PLN_CFM_MKT_DEMAND_PLAN 데이터를 DM_PLN_MKT_FCST 적재기준으로 적재한다 */
        INSERT INTO DM_PLN_MKT_FCST
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
        , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
             , SUM(A.QTY), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
          FROM DM_PLN_CFM_MKT_DEMAND_PLAN A
         WHERE A.DIVISION_ID = P_DIVISION
--         AND A.MEASURE IN ('MKT_FCST', 'SCM_FCST', 'VMI_IN_REQ')   /* [PJ2025-50188] 기준수요 포함 */   --  2026.10.08 AJS
           AND A.MEASURE IN ('MKT_FCST', 'SCM_FCST', 'VMI_In_Req')   /* [PJ2025-50188] 기준수요 포함 */   --  2026.10.08 AJS
           AND A.YYYYMMDD >= V_PLAN_START_YYYYMMDD
         GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD;
        /* 1. DM_PLN_CFM_MKT_DEMAND_PLAN 기준으로 DM_PLN_MKT_FCST 데이터 동기화 (END) */

        /* 2. DM_PLN_CFM_SELLING_PRICE 기준으로 SCM_MST_FUTURE_PRICE 데이터 동기화 (START) */
        /* 1). 당주 월요일 이후 SCM_MST_FUTURE_PRICE 데이터를 삭제한다 */
        DELETE FROM SCM_MST_FUTURE_PRICE
         WHERE DIVISION_ID = P_DIVISION
           AND YYYYMMDD    >= V_PLAN_START_YYYYMMDD;

        /* 2). DM_PLN_CFM_SELLING_PRICE 데이터를 SCM_MST_FUTURE_PRICE 적재기준으로 적재한다.        */
        /*     데이터가 하나 이상인 경우가 존재할 수 있고, CURRENCY가 중복될수있으니,               */
        /*     가장 마지막 수정한 데이터 기반으로 평균값으로 저장한다.                              */

        INSERT INTO SCM_MST_FUTURE_PRICE
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE
        , INCOTERMS, PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE
             , A.INCOTERMS, AVG(A.PRICE), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
          FROM DM_PLN_CFM_SELLING_PRICE A
             , ( SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, CURRENCY, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, DOM_EXP
                   FROM ( SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, CURRENCY, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, DOM_EXP
                               , ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, DOM_EXP
                                                     ORDER BY LAST_UPDATE_DATE DESC ) AS ROW_NUM
                            FROM DM_PLN_CFM_SELLING_PRICE
                           WHERE DIVISION_ID = P_DIVISION
                             AND MEASURE = 'LOC'
                             AND YYYYMMDD >= V_PLAN_START_YYYYMMDD
                           GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, CURRENCY, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, DOM_EXP, LAST_UPDATE_DATE )
                  WHERE ROW_NUM = 1 ) B
         WHERE A.DIVISION_ID = B.DIVISION_ID
           AND A.PROJECT_CODE = B.PROJECT_CODE
           AND A.END_CUSTOMER = B.END_CUSTOMER
           AND A.SCM_SITE_ID = B.SCM_SITE_ID
           AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
           AND A.ITEM_ID = B.ITEM_ID
           AND A.DOM_EXP = B.DOM_EXP
           AND A.FCST_TYPE = B.FCST_TYPE
           AND A.INCOTERMS = B.INCOTERMS
           AND A.CURRENCY = B.CURRENCY
           AND A.DIVISION_ID = P_DIVISION
           AND A.YYYYMMDD >= V_PLAN_START_YYYYMMDD
           AND A.MEASURE IN ('LOC', 'KRW', 'USD')
         GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS;
        /* 2. DM_PLN_CFM_SELLING_PRICE 기준으로 SCM_MST_FUTURE_PRICE 데이터 동기화 (END) */

        COMMIT;
    /* 트랜잭션 (END) */

    /* 오류 발생시 TRANSACTION 롤백 및 로그적재 (START) */
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            /* ERROR LOG VALUE SAVE */
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            D_EVENT_DATE  := SYSTIMESTAMP;
            DBMS_OUTPUT.PUT_LINE('[' || TO_CHAR(SQLCODE) || ']' || V_LOG_MESSAGE);   /* 에러메시지 DISPLAY */
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END;
    /* 오류 발생시 TRANSACTION 롤백 및 로그적재 (END) */

    /* 종료 LOG (START) */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    /* 종료 LOG (END) */

END;