-- [BACKUP 2026-08-24] SCM_MGR.DMF0020_GET_SALES_PRICE_TEMPLATE (PROCEDURE, VALID)
-- 원본 LAST_DDL = 2026-07-21 16:38:57

CREATE OR REPLACE PROCEDURE           "DMF0020_GET_SALES_PRICE_TEMPLATE"
(
    P_DIVISION_ID   IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/********************************************************************************************************************************************************/
/* Program ID  : [DMF0020_GET_SALES_PRICE_TEMPLATE]																										*/
/* Description : Procedure 작성 가이드																													*/
/* Usage       : Procedure 작성 시 참조하세요!																												*/
/* Parameter   :																																		*/
/*																																						*/
/*------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Date			In Charge			Description																											*/
/*------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* 2024.07.17		KJJ      최초 작성- [PJ2024-50611]Sales Price 템플릿 다운 기능추가                                                                      */
/* 2026.03.16   jcnam         [PJ20264226] NextSCM Pilot 설계 및 개발                                                                                     */
/*------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*
VAR RC1 REFCURSOR
VAR RC2 REFCURSOR
EXEC DMF0020_GET_SALES_PRICE_TEMPLATE('40',   :rc1, :rc2);
PRINT RC1
PRINT RC2
*/

    -- EXCEPTION 블록 필수 변수
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

    -- ================================================================
    -- START 로그
    -- ================================================================
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- ================================================================
    -- 메인 조회
    -- ================================================================
    OPEN O_RC1 FOR
    WITH TEMP_VERSION_NO AS (
        --DIV별 최신 버전(2024.10.04)---------------------
        SELECT /*+ MATERIALIZE */
               A.DIVISION_ID, A.VERSION_NO, A.YYYYMMDD, B.BASIS_YYYYMM AS YYYYMM
        FROM
        (
            SELECT DIVISION_ID, MAX(VERSION_NO) AS VERSION_NO, MAX(YYYYMMDD) AS YYYYMMDD
            FROM DM_MST_VERSION
            WHERE DIVISION_ID = P_DIVISION_ID
            AND VERSION_TYPE = 'SP_W'
            --AND NVL(ATTRIBUTE7, 'N') = 'Y'
            GROUP BY DIVISION_ID
        ) A
        INNER JOIN SCM_SYS_CALENDAR_M B
                ON B.BASIS_YYYYMMDD = A.YYYYMMDD
    )
    SELECT DISTINCT
        A.DIVISION_ID
        , A.DEPT_NAME_KO AS DEPT_NAME
        , A.END_CUSTOMER
        , A.PROJECT_CODE
        , MAX(A.CURRENCY) AS CURRENCY -- Model별로 하나의 CURRENCY만 있어야 하므로 MAX값 취함
        , A.ITEM_ID
        , '' AS M0
        , '' AS M1
        , '' AS M2
        , '' AS M3
        , '' AS M4
        , '' AS M5
        , '' AS M6
        , '' AS M7
        , '' AS M8
        , '' AS M9
        , '' AS M10
        , '' AS M11
        , '' AS M12
        , EDIT_YN
    FROM
    (
        SELECT
        SP.DIVISION_ID
        , TEAM.DEPT_ID
        , TEAM.DEPT_NAME_KO
        , MS.END_CUSTOMER
        , SP.PROJECT_CODE
        , MP.PROJECT_NAME
        , SP.ITEM_ID
        , SP.SCM_SITE_ID
        , CASE WHEN NVL(SP.CURRENCY, '') = '' THEN SI.CURRENCY ELSE SP.CURRENCY END AS CURRENCY--CURRENCY가 없을 경우 SSPM의 값을 가져옴
        , NVL(T2.EDIT_YN,'N') AS EDIT_YN

        FROM DM_PLN_SALES_PLAN_C SP

            INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
            ON SP.DIVISION_ID = T2.UNIT_ID

        INNER JOIN SCM_MST_SITE MS
            ON MS.DIVISION_ID = SP.DIVISION_ID
            AND MS.SCM_SITE_ID = SP.SCM_SITE_ID
            AND MS.VALID_YN = 'Y'
        -- 변경된 DEPT_ID
        INNER JOIN SCM_MST_SITE_ITEM IM
            ON MS.DIVISION_ID = IM.DIVISION_ID
            AND MS.SCM_SITE_ID = IM.SCM_SITE_ID

        INNER JOIN SCM_MST_SSO_DEPT_INFO DI
            -- ON DI.DEPT_ID = MS.DEPT_ID
            ON DI.DEPT_ID = IM.DEPT_ID
            AND DI.VALID_YN = 'Y'

        /* DEPT_ID 테이블 변경
        INNER JOIN SCM_MST_SSO_DEPT_INFO DI
            ON DI.DEPT_ID = MS.DEPT_ID
            AND DI.VALID_YN = 'Y'
        */

        INNER JOIN SCM_MST_PROJECT MP
            ON MP.DIVISION_ID = SP.DIVISION_ID
           AND MP.PROJECT_CODE = SP.PROJECT_CODE

        INNER JOIN SCM_MST_SITE_ITEM SI
            ON SI.DIVISION_ID = SP.DIVISION_ID
            AND SI.PROJECT_CODE = SP.PROJECT_CODE
            AND SI.SCM_SITE_ID = SP.SCM_SITE_ID
            AND SI.ITEM_ID = SP.ITEM_ID
            AND SI.VALID_YN = 'Y'
        INNER JOIN TEMP_VERSION_NO T_VER--DIV별 최신버전(2024.10.04)
            ON SP.DIVISION_ID = T_VER.DIVISION_ID
            AND SP.VERSION_NO = T_VER.VERSION_NO
        LEFT JOIN (
                SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID
                FROM SCM_MST_SSO_USER_INFO B
                INNER JOIN SCM_MST_SSO_DEPT_INFO C
                ON B.DEPT_ID = C.DEPT_ID
            ) TEAM
            ON
            TEAM.USER_ID = TRIM(
                CASE
                    WHEN INSTR(SI.OWNER, ',') > 0
                    THEN SUBSTR(SI.OWNER, 1, INSTR(SI.OWNER, ',') - 1)
                    ELSE SI.OWNER
                END
            )
        WHERE SP.DIVISION_ID = P_DIVISION_ID
        AND SP.QTY <> 0
        AND SP.MEASURE = 'RTF_SYS_RP'
        --버전의 날짜로 처리(2024.10.04)

        AND SP.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(T_VER.YYYYMMDD, 'MON') - 7, 'YYYYMMDD')
        AND SP.YYYYMMDD <= TO_CHAR(TO_DATE(TO_CHAR(FN_NEXT_DAY(T_VER.YYYYMMDD, 'MON') - 7, 'YYYYMMDD'), 'YYYYMMDD') + (52 * 7) - 1, 'YYYYMMDD')

        UNION ALL

        SELECT
        SP.DIVISION_ID
        , TEAM.DEPT_ID
        , TEAM.DEPT_NAME_KO
        , MS.END_CUSTOMER
        , SP.PROJECT_CODE
        , MP.PROJECT_NAME
        , SP.ITEM_ID
        , SP.SCM_SITE_ID
        , CASE WHEN NVL(SP.CURRENCY, '') = '' THEN SI.CURRENCY ELSE SP.CURRENCY END AS CURRENCY--CURRENCY가 없을 경우 SSPM의 값을 가져옴
        , NVL(T2.EDIT_YN,'N') AS EDIT_YN
        FROM DM_PLN_SALES_PLAN_RESULT_C SP

        INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
            ON SP.DIVISION_ID = T2.UNIT_ID


        INNER JOIN SCM_MST_SITE MS
            ON MS.DIVISION_ID = SP.DIVISION_ID
            AND MS.SCM_SITE_ID = SP.SCM_SITE_ID
            AND MS.VALID_YN = 'Y'

        INNER JOIN SCM_MST_SITE_ITEM IM
            ON MS.DIVISION_ID = IM.DIVISION_ID
            AND MS.SCM_SITE_ID = IM.SCM_SITE_ID

        -- 변경된 DEPT_ID
        INNER JOIN SCM_MST_SSO_DEPT_INFO DI
            -- ON DI.DEPT_ID = MS.DEPT_ID
            ON DI.DEPT_ID = IM.DEPT_ID
            AND DI.VALID_YN = 'Y'

        /* DEPT_ID 테이블 변경
        INNER JOIN SCM_MST_SSO_DEPT_INFO DI
            ON DI.DEPT_ID = MS.DEPT_ID
            AND DI.VALID_YN = 'Y'
        */

        INNER JOIN SCM_MST_PROJECT MP
            ON MP.DIVISION_ID = SP.DIVISION_ID
            AND MP.PROJECT_CODE = SP.PROJECT_CODE
        INNER JOIN SCM_MST_SITE_ITEM SI
            ON SI.DIVISION_ID = SP.DIVISION_ID
            AND SI.PROJECT_CODE = SP.PROJECT_CODE
            AND SI.SCM_SITE_ID = SP.SCM_SITE_ID
            AND SI.ITEM_ID = SP.ITEM_ID
            AND SI.VALID_YN = 'Y'
        INNER JOIN TEMP_VERSION_NO T_VER--DIV별 최신버전(2024.10.04)
            ON SP.DIVISION_ID = T_VER.DIVISION_ID
            AND SP.VERSION_NO = T_VER.VERSION_NO
        LEFT JOIN (
                SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID
                FROM SCM_MST_SSO_USER_INFO B
                INNER JOIN SCM_MST_SSO_DEPT_INFO C
                ON B.DEPT_ID = C.DEPT_ID
            ) TEAM
            ON
            TEAM.USER_ID = TRIM(
                CASE
                    WHEN INSTR(SI.OWNER, ',') > 0
                    THEN SUBSTR(SI.OWNER, 1, INSTR(SI.OWNER, ',') - 1)
                    ELSE SI.OWNER
                END
            )
        WHERE SP.DIVISION_ID = P_DIVISION_ID
        AND SP.QTY <> 0
        AND SP.MEASURE = 'RTF_SYS_RP'
        AND SP.YYYYMMDD >= T_VER.YYYYMM || '01'
        AND SP.YYYYMMDD < TO_CHAR(FN_NEXT_DAY(T_VER.YYYYMMDD, 'MON') - 7, 'YYYYMMDD')
    ) A
    GROUP BY
    A.DIVISION_ID
    , A.DEPT_ID
    , A.DEPT_NAME_KO
    , A.END_CUSTOMER
    , A.PROJECT_CODE
    , A.PROJECT_NAME
    , A.ITEM_ID
    , A.SCM_SITE_ID
    , A.EDIT_YN
    ;
    --, A.CURRENCY

    -- ================================================================
    -- 조회 성공 O_RESULT_CURSOR (Case 3 표준 패턴)
    -- ================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    -- ================================================================
    -- END 로그
    -- ================================================================
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID
        );
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
END DMF0020_GET_SALES_PRICE_TEMPLATE;
/
