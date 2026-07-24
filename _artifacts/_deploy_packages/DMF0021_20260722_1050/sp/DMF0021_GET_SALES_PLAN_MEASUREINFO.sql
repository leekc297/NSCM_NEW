
  CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0021_GET_SALES_PLAN_MEASUREINFO" 
(
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0021_GET_SALES_PLAN_MEASUREINFO
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/04/15	JYE         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2024.11.15	KJJ			[PJ2024-50611] 소형사업부 Sales Plan 기타매출 입력 추가
							룩업에 등록된 메저 가져옴(DM_SALES_PLAN_MEASURE)
 * 2026.03.17  jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 EXEC DMF0021_GET_SALES_PLAN_MEASUREINFO
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
    SELECT SEGMENT1    AS CODE
         , SEGMENT2    AS NAME
         , DISPLAY_SEQ
    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'DM_SALES_PLAN_MEASURE'
    AND    VALID_YN    = 'Y'
    ORDER BY DISPLAY_SEQ;
    --[PJ2024-50611]기존 쿼리 주석처리
    /*
    SELECT  COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME, SORT_ORDER_NO AS DISPLAY_SEQ
    FROM     SCM_MST_SHEET_MEASURE
    WHERE
    PROGRAM_ID = 'DMF1007' AND SHEET_NAME = 'Sales Plan'
    */

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
        V_PROC_INPUT  := JSON_OBJECT('NO_PARAM' VALUE 'N/A');
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

END DMF0021_GET_SALES_PLAN_MEASUREINFO;
/