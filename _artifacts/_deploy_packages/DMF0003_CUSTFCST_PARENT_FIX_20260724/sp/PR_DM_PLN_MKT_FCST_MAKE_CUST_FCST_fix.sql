CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST" (P_DIVISION_ID VARCHAR2)

/*===================================================================================================
    * Program ID   : PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST
    * Description  : DM_PLN_MKT_FCST의 Cust.FCST(P+P) = Excel + RPA + EDI를 하도록 작업하는 프로시져
    * Program History
    *===================================================================================================
    *   Date       In Charge   Description
    *===================================================================================================
    * 2024/11/26 JSSBAE            [E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정
    * 2026/03/22   김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
    ===================================================================================================*/
 AS

    V_PROGRAM_NAME VARCHAR2(200 CHAR) := $$PLSQL_UNIT;
    V_IN_PARA_DATA CLOB;
    V_STEP         VARCHAR2(4000 CHAR) := NULL;
    V_LOG_TYPE     VARCHAR2(30 CHAR);
    N_LOG_COUNT    INTEGER := 0;
    V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
    V_DESCRIPTION  VARCHAR2(500 CHAR);
    D_EVENT_DATE   DATE;
    V_BATCH_USER   VARCHAR2(150 CHAR) := 'MAKE_CUST_FCST';
    V_ROWCNT       INTEGER;
    V_DELETECNT    INTEGER;
    V_INSERTCNT    INTEGER;
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;

    V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID);

    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DPMFM_MKT_FCST_DATA';

    /* --------------------------------------------------------------------------------------------------- */
    /* LOG 용 변수 설정 */
    /* --------------------------------------------------------------------------------------------------- */
    /* TEMP 테이블 삭제한 후 시작한다. */
    /* --------------------------------------------------------------------------------------------------- */
    /* 시작 LOG (START) */
    /* --------------------------------------------------------------------------------------------------- */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */
    /* --------------------------------------------------------------------------------------------------- */
    /* 시작 LOG (END) */
    /* --------------------------------------------------------------------------------------------------- */
    /* 트랜잭션 (START) */
    /* --------------------------------------------------------------------------------------------------- */
    /* BEGIN TRY (Oracle: EXCEPTION 블록으로 대체) */
    /* 1. 데이터를 확인한다. */
    INSERT /*+ NO_PARALLEL */
      INTO GT_DPMFM_MKT_FCST_DATA
    SELECT A.DIVISION_ID
         , A.PROJECT_CODE
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.DOM_EXP
         , A.FCST_TYPE
         , A.INCOTERMS
         , 'CUST_FCST' AS MEASURE
         , A.YYYYMMDD
         , A.PLANT_SITE_ID
         , A.QTY
      FROM (SELECT DIVISION_ID
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , YYYYMMDD
                 , PLANT_SITE_ID
                 , SUM(QTY) QTY
              FROM DM_PLN_MKT_FCST
             WHERE DIVISION_ID = P_DIVISION_ID
               AND UPPER(MEASURE) IN ('CUSTOMER FCST', 'CUST_FCST_EDI') /* [20260724 FIX] MSSQL CI 등가 — 'Customer Fcst' 표기가 실데이터 'Customer FCST'와 Oracle CS 불일치 → EXCEL 업로드분 상위(CUST_FCST) 통합 누락 */
               AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD') /* 당주 월요일 이후 데이터 */
             GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, YYYYMMDD, PLANT_SITE_ID) A
     GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.YYYYMMDD, A.PLANT_SITE_ID, A.QTY;

    V_ROWCNT := SQL%ROWCOUNT;

    /* --------------------------------------------------------------------------------------------------- */
    /* 대상데이터 LOG (START) */
    /* --------------------------------------------------------------------------------------------------- */
    V_LOG_TYPE    := 'APPEND';
    V_LOG_MESSAGE := 'TARGET DATA';
    V_DESCRIPTION := 'GT_DPMFM_MKT_FCST_DATA INSERT: DIVISION_ID ' || P_DIVISION_ID;
    D_EVENT_DATE  := SYSTIMESTAMP;
    N_LOG_COUNT   := V_ROWCNT;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    /* --------------------------------------------------------------------------------------------------- */
    /* 대상데이터 LOG (END) */
    /* --------------------------------------------------------------------------------------------------- */
    /* 당주 월요일 이후의 대상이 될 데이터를 먼저 삭제한다. */
    DELETE
      FROM DM_PLN_MKT_FCST
     WHERE DIVISION_ID = P_DIVISION_ID
       AND MEASURE = 'CUST_FCST'
       AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD'); /* 당주 월요일 이후 데이터 */

    V_DELETECNT := SQL%ROWCOUNT;

    /* --------------------------------------------------------------------------------------------------- */
    /* DELETE FROM 데이터 LOG (START) */
    /* --------------------------------------------------------------------------------------------------- */
    V_LOG_TYPE    := 'APPEND';
    V_LOG_MESSAGE := 'MKT FCST DELETE FROM DATA';
    V_DESCRIPTION := 'MKT FCST DELETE: DIVISION_ID ' || P_DIVISION_ID;
    D_EVENT_DATE  := SYSTIMESTAMP;
    N_LOG_COUNT   := V_DELETECNT;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    /* --------------------------------------------------------------------------------------------------- */
    /* DELETE FROM 데이터 LOG (END) */
    /* --------------------------------------------------------------------------------------------------- */
    /* 삭제 후 데이터를 INSERT INTO 한다. */
    INSERT
      INTO DM_PLN_MKT_FCST
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
         , ATTRIBUTE10 )
    SELECT DIVISION_ID
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
         , V_BATCH_USER  CREATED_BY
         , SYSDATE       CREATION_DATE
         , V_BATCH_USER  LAST_UPDATED_BY
         , SYSDATE       LAST_UPDATE_DATE
         , NULL          ATTRIBUTE1
         , NULL          ATTRIBUTE2
         , NULL          ATTRIBUTE3
         , NULL          ATTRIBUTE4
         , NULL          ATTRIBUTE5
         , NULL          ATTRIBUTE6
         , NULL          ATTRIBUTE7
         , NULL          ATTRIBUTE8
         , NULL          ATTRIBUTE9
         , NULL          ATTRIBUTE10
      FROM GT_DPMFM_MKT_FCST_DATA;

    V_INSERTCNT := SQL%ROWCOUNT;

    /* --------------------------------------------------------------------------------------------------- */
    /* INSERT INTO 데이터 LOG (START) */
    /* --------------------------------------------------------------------------------------------------- */
    V_LOG_TYPE    := 'APPEND';
    V_LOG_MESSAGE := 'MKT FCST INSERT INTO DATA';
    V_DESCRIPTION := 'MKT FCST INSERT: DIVISION_ID ' || P_DIVISION_ID;
    D_EVENT_DATE  := SYSTIMESTAMP;
    N_LOG_COUNT   := V_INSERTCNT;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    /* --------------------------------------------------------------------------------------------------- */
    /* INSERT INTO 데이터 LOG (END) */
    /* --------------------------------------------------------------------------------------------------- */
    COMMIT;

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
        RAISE_APPLICATION_ERROR(-20001
                               ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
        /* END CATCH */
        /* --------------------------------------------------------------------------------------------------- */
        /* 트랜잭션 (END) */
        /* --------------------------------------------------------------------------------------------------- */
        /* 종료 LOG (START) */
        /* --------------------------------------------------------------------------------------------------- */
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := 'MKT FCST TARGET DIVISION_ID: ' || P_DIVISION_ID || ' DATA= ' || TO_CHAR(V_ROWCNT) || ' / MKT FCST DELETE FROM DATA= ' ||
                         TO_CHAR(V_DELETECNT) || ' / MKT FCST INSERT INTO DATA= ' || TO_CHAR(V_INSERTCNT);
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        /* --------------------------------------------------------------------------------------------------- */
        /* 종료 LOG (END) */
        /* --------------------------------------------------------------------------------------------------- */
END;
/
