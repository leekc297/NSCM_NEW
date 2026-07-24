CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP" 
(
    P_DIVISION_ID     IN VARCHAR2,
    P_YEAR            IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_VERSION_NO      IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : [DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP]                                                           */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2020/03/23  P.C.I        Initial Release [prepare] Sales Report Exchange Rate Popup              */
/* 2026.03.20   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                  */
/*                                                                                                  */
/****************************************************************************************************/
IS

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    /* Case 17: CASE WHEN @p_division_id = 'ALL' 패턴 → UNION ALL 분기 */
    OPEN O_RC1 FOR
    SELECT
        T1.DIVISION_ID
        , CURRENCY
        , UNIT_CURRENCY
        , CURRENCY || '/' || UNIT_CURRENCY AS CURRENCY_UNITCURRENCY
        , NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM DM_PLN_SALES_REPORT_EXCHANGE_C T1
        INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
        ON T1.DIVISION_ID = T2.UNIT_ID
    WHERE  YYYYMMDD LIKE P_YEAR || '%'
    AND    VERSION_NO = P_VERSION_NO
    AND    P_DIVISION_ID <> 'ALL'
    AND    T1.DIVISION_ID IN (
               SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL)) AS TOKEN
               FROM DUAL
               CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
           )
    GROUP BY T1.DIVISION_ID, CURRENCY, UNIT_CURRENCY, EDIT_YN

    UNION ALL

    SELECT
        T1.DIVISION_ID
        , CURRENCY
        , UNIT_CURRENCY
        , CURRENCY || '/' || UNIT_CURRENCY AS CURRENCY_UNITCURRENCY
        , NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM DM_PLN_SALES_REPORT_EXCHANGE_C T1
        INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
        ON T1.DIVISION_ID = T2.UNIT_ID
    WHERE  YYYYMMDD LIKE P_YEAR || '%'
    AND    VERSION_NO = P_VERSION_NO
    AND    P_DIVISION_ID = 'ALL'
    GROUP BY T1.DIVISION_ID, CURRENCY, UNIT_CURRENCY, EDIT_YN;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_YEAR'        VALUE P_YEAR,
            'P_CREATED_BY'  VALUE P_CREATED_BY,
            'P_VERSION_NO'  VALUE P_VERSION_NO,
            'P_USER_ID'     VALUE P_USER_ID,
            'P_MNU_ID'      VALUE P_MNU_ID
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
END DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP;