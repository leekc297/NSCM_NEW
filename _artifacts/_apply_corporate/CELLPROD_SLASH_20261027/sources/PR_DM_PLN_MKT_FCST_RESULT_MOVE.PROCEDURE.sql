PROCEDURE           "PR_DM_PLN_MKT_FCST_RESULT_MOVE" (P_DIVISION_ID VARCHAR2 /* division_id 전달받음 */
                                                           )
/*
    * Program ID   : PR_DM_PLN_MKT_FCST_RESULT_MOVE
    * Description  :
    * Program History
    *===================================================================================================
    *   Date          In Charge          Description
    *===================================================================================================
    * 2018. 03. 29    JHBAEK             Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
    *                                    [DM_PLN_MKT_FCST] -> [DM_PLN_MKT_FCST_RESULT] 테이블에 자료(과거 1주일) INSERT PROCEDURE
    *                                    WEEKLY RUNNNG.
    * 20180611 KHSONG      <> 'RTF' -> not in ('RTF','BALANCE') 로 수정 / DATEADD(DD, -7 -> DATEADD(DD, -14 로 수정
    * 20180917 KHSONG      테스트용 MEASURE 제외조건 추가
    * 20190709 KHSONG      [CSR ID:4027463] RTF_System[R+P] Measure 추가 요청의 건
    * 20200416 KHSONG      C20200413-000593 ESS사업부 RTF Measure 추가
    * 20220405 hwi1993     GM JV 작업
    * 20250623 KANG.H.J    [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
    * 2026.07.06   ZIONEX   [PJ202650304] NextSCM Migration
    */


    /* TO TEST
       SELECT * FROM DM_PLN_MKT_FCST
       SELECT * FROM DM_PLN_MKT_FCST_RESULT

    */
 AS

    V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE     VARCHAR2(30 CHAR);
    N_LOG_COUNT    INTEGER := 0;
    V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
    V_DESCRIPTION  VARCHAR2(500 CHAR);
    D_EVENT_DATE   DATE;
    V_DIVISION_ID  VARCHAR2(30 CHAR);
    V_IN_PARA_DATA CLOB;
    V_STEP         VARCHAR2(4000 CHAR) := NULL;
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;

    V_IN_PARA_DATA := JSON_OBJECT('P_DIVISION_ID' VALUE P_DIVISION_ID);

    /*
        -- --------------------------------------------------------------------------------------
        000
            : VARIABLE DECLARATION
        -- --------------------------------------------------------------------------------------
    */
    V_DIVISION_ID := NULL;

    /*
        -- --------------------------------------------------------------------------------------
            : START LOG
        -- --------------------------------------------------------------------------------------
    */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := 'p_division_id : ' || NVL(P_DIVISION_ID, 'NULL');
    D_EVENT_DATE  := SYSTIMESTAMP;

    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

    /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (임시테이블 생성. 40사업부와 그외 사업부 구분을 위함) */
    /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (임시테이블 생성. 40사업부와 그외 사업부 구분을 위함) */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DPMFR_RESULT_MOVE_MKT_FCST';


    IF P_DIVISION_ID = 'ALL' THEN
        V_DIVISION_ID := NULL;
    ELSE
        V_DIVISION_ID := P_DIVISION_ID;

        /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (임시테이블 생성. 40사업부와 그외 사업부 구분을 위함) START */
    END IF;
    IF P_DIVISION_ID = '40' THEN
        INSERT
          INTO GT_DPMFR_RESULT_MOVE_MKT_FCST
             ( DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , PLANT_SITE_ID
             , CELL_PROD_SITE_ID
             , MEASURE
             , YYYYMMDD
             , QTY
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
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
        SELECT DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , PLANT_SITE_ID
             , CELL_PROD_SITE_ID
             , MEASURE
             , YYYYMMDD
             , QTY
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
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
          FROM DM_PLN_CFM_MKT_DEMAND_PLAN
         WHERE DIVISION_ID = V_DIVISION_ID
           AND YYYYMMDD < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
           AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 2), 'YYYYMMDD')
           AND MEASURE NOT IN ('MKT_AMT_LOC', 'SalesAmt_KRW', 'SalesAmt_LOC', 'SalesAmt_USD', 'MKT_AMT_KRW'); /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (DM_PLN_MKT_FCST 에는 없는 MEASURE임. 참고적으로 MKT_AMT_KRW 추가시 QTY 칼럼의 자리수 에러 발생) */
    ELSE
        INSERT
          INTO GT_DPMFR_RESULT_MOVE_MKT_FCST
             ( DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , PLANT_SITE_ID
             , CELL_PROD_SITE_ID
             , MEASURE
             , YYYYMMDD
             , QTY
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
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
        SELECT DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID
             , MEASURE
             , YYYYMMDD
             , QTY
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
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
          FROM DM_PLN_MKT_FCST
         WHERE DIVISION_ID = V_DIVISION_ID
           AND YYYYMMDD < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
           AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 2), 'YYYYMMDD');
    END IF;
    /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (임시테이블 생성. 40사업부와 그외 사업부 구분을 위함) END */
    DELETE
      FROM DM_PLN_MKT_FCST
     WHERE DIVISION_ID = V_DIVISION_ID
       AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-14), 'YYYYMMDD') /* 20180611 KHSONG DATEADD(DD, -7 -> DATEADD(DD, -14 로 수정 */
       AND QTY = 0;

    DELETE
      FROM DM_PLN_CFM_MKT_DEMAND_PLAN
     WHERE DIVISION_ID = V_DIVISION_ID
       AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-14), 'YYYYMMDD') /* 20180611 KHSONG DATEADD(DD, -7 -> DATEADD(DD, -14 로 수정 */
       AND QTY = 0;

    DELETE
      FROM DM_PLN_MKT_FCST_RESULT
     WHERE DIVISION_ID = V_DIVISION_ID
           /* AND MEASURE   IN ( 'MKT_FCST', 'CUST_FCST', 'MKT_FCST_LATEST', 'CUST_FCST_LATEST' )            -- [2018-03-28]수정 */
       AND YYYYMMDD < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
       AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 2), 'YYYYMMDD')
       AND MEASURE NOT IN ('RTF', 'BALANCE', 'VMI_In_Plan', 'VMI_In_Req', 'VMI_Inv'); /* 20180611 KHSONG <> 'RTF' -> not in ('RTF','BALANCE') 로 수정 */

    INSERT
      INTO DM_PLN_MKT_FCST_RESULT
         ( DIVISION_ID
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
         , CREATED_BY
         , CREATION_DATE
         , LAST_UPDATED_BY
         , LAST_UPDATE_DATE
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
         , CELL_PROD_SITE_ID ) /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.YYYYMMDD
             , A.QTY
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , SYSDATE /* A.LAST_UPDATE_DATE */
             , A.ATTRIBUTE1
             , A.ATTRIBUTE2
             , A.ATTRIBUTE3
             , A.ATTRIBUTE4
             , A.ATTRIBUTE5
             , A.ATTRIBUTE6
             , A.ATTRIBUTE7
             , A.ATTRIBUTE8
             , A.ATTRIBUTE9
             , A.ATTRIBUTE10
             , A.CELL_PROD_SITE_ID /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
          FROM GT_DPMFR_RESULT_MOVE_MKT_FCST A /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (40:DM_PLN_CFM_MKT_DEMAND_PLAN / 그외 : DM_PLN_MKT_FCST) */
             , SCM_MST_DIVISION B
         WHERE A.DIVISION_ID = B.DIVISION_ID
           AND B.DIVISION_ID = V_DIVISION_ID
           AND 1 = 1
           AND YYYYMMDD < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
           AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 2), 'YYYYMMDD')
           /* AND MEASURE   IN ( 'MKT_FCST', 'CUST_FCST', 'MKT_FCST_LATEST', 'CUST_FCST_LATEST' ) */
           AND MEASURE NOT IN ('RTF_SYS_RP', 'RTF', 'BALANCE', 'VMI_In_Plan', 'VMI_In_Req', 'VMI_Inv'); /* 20180611 KHSONG <> 'RTF' -> not in ('RTF','BALANCE') 로 수정 --20190729 KHSONG RTF_SYS_RP MEASURE 추가 */

    /* 20190709 KHSONG [CSR ID:4027463] RTF_System[R+P] Measure 추가 요청의 건 (BEGIN) */
    INSERT
      INTO DM_PLN_MKT_FCST_RESULT
         ( DIVISION_ID
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
         , CREATED_BY
         , CREATION_DATE
         , LAST_UPDATED_BY
         , LAST_UPDATE_DATE
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
         , CELL_PROD_SITE_ID ) /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'RTF_SYS_RP' MEASURE
             , A.PLANT_SITE_ID
             , A.YYYYMMDD
             , A.QTY
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , SYSDATE /* A.LAST_UPDATE_DATE */
             , A.ATTRIBUTE1
             , A.ATTRIBUTE2
             , A.ATTRIBUTE3
             , A.ATTRIBUTE4
             , A.ATTRIBUTE5
             , A.ATTRIBUTE6
             , A.ATTRIBUTE7
             , A.ATTRIBUTE8
             , A.ATTRIBUTE9
             , A.ATTRIBUTE10
             , A.CELL_PROD_SITE_ID /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
          FROM DM_PLN_MKT_FCST_RESULT A
             , SCM_MST_DIVISION B
         WHERE A.DIVISION_ID = B.DIVISION_ID
           AND B.DIVISION_ID = V_DIVISION_ID
           AND 1 = 1
           AND YYYYMMDD < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
           AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 2), 'YYYYMMDD')
           AND MEASURE = 'RTF';
    /* AND A.DIVISION_ID IN ('40','81')  -- 20200416 KHSONG C20200413-000593 주석처리 ESS사업부 추가되면서 구분이 필요없이 코드 간소화됨 */
    /* 20190709 KHSONG [CSR ID:4027463] RTF_System[R+P] Measure 추가 요청의 건 (END) */
    /* [PJ2025-50188] 임시테이블 #T_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_RTF_ALLOCATION 이름변경 */


    COMMIT;

    /*
        -- --------------------------------------------------------------------------------------
            : END LOG (원본: TRY/CATCH 바깥에 위치 → 정상 종료 경로에서 항상 기록)
        -- --------------------------------------------------------------------------------------
    */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'p_division_id : ' || NVL(P_DIVISION_ID, 'NULL');
    D_EVENT_DATE  := SYSTIMESTAMP;

    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    /*
        -- --------------------------------------------------------------------------------------
            : ERROR TRAP
        -- --------------------------------------------------------------------------------------
    */
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

        /*
            -- --------------------------------------------------------------------------------------
                : END LOG (원본: TRY/CATCH 바깥에 위치 → 에러(삼킴) 경로에서도 항상 기록)
            -- --------------------------------------------------------------------------------------
        */
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := 'p_division_id : ' || NVL(P_DIVISION_ID, 'NULL');
        D_EVENT_DATE  := SYSTIMESTAMP;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
END;