CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0044_GET_VERSION_POPUP" 
(
    P_START_YYYYMMDD    IN  VARCHAR2,
    P_END_YYYYMMDD      IN  VARCHAR2,
    P_CREATED_BY        IN  VARCHAR2,
    P_DIVISION_ID       IN  VARCHAR2,
    P_VERSION_TYPE      IN  VARCHAR2,
    P_VERSION_NO        IN  VARCHAR2,
    P_USER_ID           IN  VARCHAR2, -- For EditYn
    P_MNU_ID            IN  VARCHAR2, -- For EditYn

    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DM0035_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2026.03.23   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                 */
/*                                                                                                  */
/****************************************************************************************************/
/*****************************************************************************************************
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
IS
    -- Case 41: 프로그램명 (패키지 대응)
    V_PROGRAM_NAME  VARCHAR2(200 CHAR);

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
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- EXEC SCM0002_GET_VERSIONBYWATERFALLPOPUP @p_start_yyyymmdd='20180313', @p_end_yyyymmdd='20180913', @p_created_by='20140001', @p_division_id='82', @p_version_type='SP_D,SP_W,SP_M,', @p_version_no=''

    OPEN O_RC1 FOR
    SELECT 'SP_Z_CURRENT' AS CODE,
           'Current' AS VERSION_NO,
           'Current' AS VERSION_DESCRIPTION,
           CAST(NULL AS VARCHAR2(30 CHAR)) AS VERSION_TYPE,
           CAST(NULL AS VARCHAR2(30 CHAR)) AS VER_CRE_SEQ,
           CAST(NULL AS VARCHAR2(8 CHAR))  AS YYYYMMDD,
           CAST(NULL AS VARCHAR2(50 CHAR)) AS CREATED_BY,
           SYSDATE AS CREATION_DATE,
           'N' AS EDIT_YN
    FROM   DUAL

    UNION ALL

    SELECT VERSION_NO AS CODE,
           VERSION_NO,
           VERSION_DESCRIPTION,
           TO_CHAR(VERSION_TYPE) AS VERSION_TYPE,
           TO_CHAR(VER_CRE_SEQ) AS VER_CRE_SEQ,
           YYYYMMDD,
           MAX(CREATED_BY) AS CREATED_BY,
           MAX(CREATION_DATE) AS CREATION_DATE,

           NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM   SCM_MGR.DM_MST_VERSION T1
            INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
            ON T1.DIVISION_ID = T2.UNIT_ID

    WHERE  YYYYMMDD >= P_START_YYYYMMDD
    AND    YYYYMMDD <= P_END_YYYYMMDD
    AND    T1.DIVISION_ID IN (
               SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL)) AS TOKEN
               FROM   DUAL
               CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
           )
    AND    VERSION_TYPE IN (
               SELECT TRIM(REGEXP_SUBSTR(P_VERSION_TYPE, '[^,]+', 1, LEVEL)) AS TOKEN
               FROM   DUAL
               CONNECT BY REGEXP_SUBSTR(P_VERSION_TYPE, '[^,]+', 1, LEVEL) IS NOT NULL
           )
    AND    EXISTS (
               SELECT 1
               FROM   (
                   SELECT TRIM(REGEXP_SUBSTR(P_VERSION_NO, '[^,]+', 1, LEVEL)) AS TOKEN
                   FROM   DUAL
                   CONNECT BY REGEXP_SUBSTR(P_VERSION_NO, '[^,]+', 1, LEVEL) IS NOT NULL
               ) P
               WHERE  VERSION_NO LIKE P.TOKEN || '%'
           )
    GROUP BY VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, EDIT_YN
    ORDER BY CODE DESC, VERSION_NO DESC;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
            'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
            'P_CREATED_BY'     VALUE P_CREATED_BY,
            'P_DIVISION_ID'    VALUE P_DIVISION_ID,
            'P_VERSION_TYPE'   VALUE P_VERSION_TYPE,
            'P_VERSION_NO'     VALUE P_VERSION_NO,
            'P_USER_ID'        VALUE P_USER_ID,
            'P_MNU_ID'         VALUE P_MNU_ID
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END DMF0044_GET_VERSION_POPUP;
/
