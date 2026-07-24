
  CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0021_GET_SALES_PLAN_MEASUREINFO2" 
(
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn

    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0021_GET_SALES_PLAN_MEASUREINFO2
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/04/15  JYE         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.03.17  jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 * 2026.06.08  NextSCM      [PJ202650304] NextSCM Migration - EDIT_YN 권한조인 INNER→LEFT 보정(DIVISION_ID가 NULL인 SalesAmt 메저가 전탈락하여 항상 0행 반환되던 버그 수정, MSSQL 결과셋 동등 복원)
 */
AS

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN

    OPEN O_RC1 FOR
    SELECT COLUMN_NAME      AS CODE
         , COLUMN_LABEL_NAME AS NAME
         , SORT_ORDER_NO    AS DISPLAY_SEQ
         , NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM   SCM_MST_SHEET_MEASURE T1
        LEFT JOIN (SELECT * -- EDIT_YN
                     FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                     WHERE USER_ID = P_USER_ID
                     AND MNU_ID = P_MNU_ID
                     AND UNIT_TP_CD = 'D') T2
         ON T2.UNIT_ID in (
             SELECT TRIM(REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL))
             FROM   DUAL
             CONNECT BY REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
         )
    WHERE  PROGRAM_ID  = 'DMF1007'
    AND    SHEET_NAME  = 'Sales Plan'
    AND    COLUMN_NAME LIKE 'SalesAmt%'
    ORDER BY SORT_ORDER_NO;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  := JSON_OBJECT(
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID
        );
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END DMF0021_GET_SALES_PLAN_MEASUREINFO2;
/