-- [BACKUP 2026-08-24] SCM_MGR.DMF0020_GET_MEASURE_COUNTINFO_SAVE_PRICE (PROCEDURE, VALID)
-- 원본 LAST_DDL = 2026-07-21 16:38:57

CREATE OR REPLACE PROCEDURE           "DMF0020_GET_MEASURE_COUNTINFO_SAVE_PRICE"
(
/* 보류 PCI 협의 3/19
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
*/
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0020_GET_MEASURE_COUNTINFO
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/04  kuniid         [C20210127-000163] GSCM Sales Price 일괄입력 기능 개선 요청
 * 2025.01.13	KJJ			[PJ2024-50611] Sales Price 로직 수정 - 별도 룩업이 아니라 해당화면의 메저에서 가져오게 변경
 * 2026.03.16  jcnam          [PJ20264226] NextSCM Pilot 설계 및 개발
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
    SELECT DISTINCT T1.COLUMN_LABEL_NAME AS LOOKUP_CODE
         , T1.COLUMN_LABEL_NAME AS DESCRIPTION
         , 99                AS DISPLAY_ALL
         -- ,NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM   SCM_MST_SHEET_MEASURE T1
    /* 보류 PCI 협의 3/19
        INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
     ON T2.UNIT_ID in (
         SELECT TRIM(REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL))
         FROM   DUAL
         CONNECT BY REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
     )
    */

    WHERE  T1.PROGRAM_ID  = 'DMF0020'
    AND    T1.SHEET_NAME  = 'Sales Price'
    AND    T1.VALID_YN    = 'Y'
    AND    T1.COLUMN_NAME = 'LOC';

    ----SELECT SEGMENT1 LOOKUP_CODE, SEGMENT2 [DESCRIPTION], 99 AS DISPLAY_ALL
    ----FROM SCM_ADM_LOOKUP_MASTER_DETAIL
    ----WHERE VALID_YN = 'Y'
    ----AND SEGMENT1 <> 'LOC'
    ----AND LOOKUP_TYPE = 'FUTUREMEASURE'
    ----UNION ALL
    /*
     SELECT SEGMENT1 LOOKUP_CODE, SEGMENT2 [DESCRIPTION], 99 AS DISPLAY_ALL
     FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE VALID_YN = 'Y'
     AND SEGMENT1 = 'LOC'
     AND LOOKUP_TYPE = 'FUTUREMEASURE'
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
        /* 보류 PCI 협의 3/19
        V_PROC_INPUT  :=
            JSON_OBJECT(
                'P_USER_ID'   VALUE P_USER_ID,
                'P_MNU_ID'   VALUE P_MNU_ID
            );
        */
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

END DMF0020_GET_MEASURE_COUNTINFO_SAVE_PRICE;
/
