-- 2026-06-16 — DMF0020_GET_SPREAD_TITLE_DATE 월 변경 주 분리 fix
--   사용자 명시: "SP 에서 월이 변경되는 경우에 월의 1일이 월요일이 아니라면 주차 생성"
--
--   원인: 기존 SP 가 SCM_SYS_CALENDAR_M 의 BASIS_START_DATE (그 주의 시작 월요일) 측 MIN 만 반환.
--         같은 주 (W27 6/29~7/5) 의 6월 row + 7월 row 모두 BASIS_START_DATE='20260629'.
--         FE 가 BASIS_START_DATE 으로 binding 생성 → 두 row 동일 binding → column 1개 (7월 측 누락).
--
--   Fix: BASIS_START_DATE = 그 row 의 BASIS_YYYYMM 의 첫째 날 (월 변경 주의 경우)
--        - 6월 row: MIN(BASIS_START_DATE) yyyymm = BASIS_YYYYMM → 그대로 '20260629'
--        - 7월 row: MIN(BASIS_START_DATE) yyyymm ≠ BASIS_YYYYMM → BASIS_YYYYMM 의 1일 '20260701'
--        → FE 에서 W_20260629 (6월 W27) + W_20260701 (7월 W27) 두 column 생성.

CREATE OR REPLACE PROCEDURE "DMF0020_GET_SPREAD_TITLE_DATE"
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
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
    SELECT
           -- ⭐ 2026-06-16 — 월 변경 주의 경우 BASIS_START_DATE 를 그 row 의 BASIS_YYYYMM 첫째 날로 보정.
           --   같은 주의 6월 row + 7월 row 가 서로 다른 BASIS_START_DATE 반환 → FE column 분리.
           CASE
             WHEN TO_CHAR(TO_DATE(MIN(BASIS_START_DATE),'YYYYMMDD'),'YYYYMM') = BASIS_YYYYMM
                  THEN MIN(BASIS_START_DATE)
             ELSE BASIS_YYYYMM || '01'
           END                                                            AS BASIS_START_DATE
         , BASIS_YYYYMM
         , WEEK_NAME
         , CASE
             WHEN TO_CHAR(TO_DATE(MIN(BASIS_START_DATE),'YYYYMMDD'),'YYYYMM') = BASIS_YYYYMM
                  THEN SUBSTR(MIN(BASIS_START_DATE), 5, 4)
             ELSE SUBSTR(BASIS_YYYYMM,5,2) || '01'
           END                                                            AS DATE_SHORT1_NAME
    FROM   SCM_SYS_CALENDAR_M
    WHERE  BASIS_YYYYMMDD >= P_START_YYYYMMDD
    AND    BASIS_YYYYMMDD <= P_END_YYYYMMDD
    GROUP BY BASIS_YYYYMM, WEEK_NAME
    ORDER BY 1;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  :=
            JSON_OBJECT(
                'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
                'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
                'P_CREATED_BY'     VALUE P_CREATED_BY
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

END DMF0020_GET_SPREAD_TITLE_DATE;
