PROCEDURE         P_DMF0000_GET_COMMON_SPREAD_TITLE
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_PROGRAM_ID      IN VARCHAR2,
    P_SHEET_NAME      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,       -- 20180607 추가
    --P_USER_ID         IN VARCHAR2, -- For EditYn
    --P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : DM0000_GET_COMMON_SPREAD_TITLE                                               */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 20180607		JYE			소형 관련 수정                                                            */
/* 2026.03.16   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                  */
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

    -- 로컬 변수
    V_EXISTS        PLS_INTEGER := 0;

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
    -- 사용자 타이틀셋 존재 여부 확인 (Case 28: 전건 COUNT 회피)
    -- ================================================================
    BEGIN
        SELECT 1
        INTO   V_EXISTS
        FROM   DUAL
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MST_TITLESET_USER U
            WHERE  U.PROGRAM_ID  = P_PROGRAM_ID
            AND    U.SHEET_NAME  = P_SHEET_NAME
            AND    U.USER_ID     = P_CREATED_BY
            AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        );
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_EXISTS := 0;
    END;

    IF V_EXISTS = 0 THEN
        -- ============================================================
        -- 사용자 설정 없음 → 기본 컬럼 조회
        -- ============================================================
        IF P_DIVISION_ID IS NULL OR P_DIVISION_ID = '' THEN    -- 20180607 분기 추가

            OPEN O_RC1 FOR
            SELECT
                 C.PROGRAM_ID
               , C.SHEET_NAME
               , C.COLUMN_NAME
               , C.COLUMN_LABEL_NAME
               , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
               , C.DATA_SORT_METHOD_CODE
               , C.SMALL_CLASS_LABEL_NAME
               , C.LARGE_CLASS_LABEL_NAME
               , '' AS DAY_CODE
               , C.FIXED_FLAG
               , C.COLUMN_WIDTH
               , C.CELL_CONTROL_OBJECT_TYPE_CODE
               , C.CELL_COMBO_DATA_TYPE
               , C.DATA_SCALE_NUMBER
               , C.DATA_MAX_LENGTH
               , C.HORIZONTAL_ALIGN_CODE
               , C.UPPERCASE_APPLY_FLAG
               , C.VISIBLE_FLAG
               , C.DEFAULT_FLAG
               , C.USER_SELECTABLE_FLAG
               --, C.VALID_YN
               , CASE C.VALID_YN WHEN 'Y' THEN -- 20180620 추가
                    CASE FN_GET_DIVISION_YN(C.DIVISION_ID, P_DIVISION_ID) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
                 ELSE C.VALID_YN END AS VALID_YN
               , 0 AS SEQ
               --, NVL(T2.EDIT_YN,'N') AS EDIT_YN
            FROM SCM_MST_SHEET_COLUMNS C
                /*
                INNER JOIN ( SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
                ON T2.UNIT_ID in (
                    SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                    FROM   DUAL
                    CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                )
                */

            WHERE 1 = 1
                AND    C.PROGRAM_ID  = P_PROGRAM_ID
                AND    C.SHEET_NAME  = P_SHEET_NAME

                --AND P_DIVISION_ID IN (SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.STRING_SPLIT(C.DIVISION_ID, ',')))    -- 20180620 division 추가

                AND P_DIVISION_ID IN (
                    SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                    FROM   DUAL
                    CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                )



            ORDER BY SEQ, SORT_ORDER_NO;

        ELSE -- 20180607 ELSE 추가

            OPEN O_RC1 FOR
            SELECT
                 C.PROGRAM_ID
               , C.SHEET_NAME
               , C.COLUMN_NAME
               , C.COLUMN_LABEL_NAME
               , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
               , C.DATA_SORT_METHOD_CODE
               , C.SMALL_CLASS_LABEL_NAME
               , C.LARGE_CLASS_LABEL_NAME
               , '' AS DAY_CODE
               , C.FIXED_FLAG
               , C.COLUMN_WIDTH
               , C.CELL_CONTROL_OBJECT_TYPE_CODE
               , C.CELL_COMBO_DATA_TYPE
               , C.DATA_SCALE_NUMBER
               , C.DATA_MAX_LENGTH
               , C.HORIZONTAL_ALIGN_CODE
               , C.UPPERCASE_APPLY_FLAG
               , C.VISIBLE_FLAG
               , CASE C.VALID_YN WHEN 'Y' THEN -- 20180607 추가
                    CASE FN_GET_DIVISION_YN(C.DIVISION_ID, P_DIVISION_ID) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
                 ELSE C.VALID_YN END AS VALID_YN
               , C.DEFAULT_FLAG
               , C.USER_SELECTABLE_FLAG
               --, C.VALID_YN
               , 0 AS SEQ
               --, NVL(T2.EDIT_YN,'N') AS EDIT_YN
            FROM SCM_MST_SHEET_COLUMNS C
                /*
                INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
                ON T2.UNIT_ID in (
                    SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                    FROM   DUAL
                    CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                )
                */

            WHERE 1 = 1
                AND    C.PROGRAM_ID  = P_PROGRAM_ID
                AND    C.SHEET_NAME  = P_SHEET_NAME
                -- AND P_DIVISION_ID IN (SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.STRING_SPLIT(C.DIVISION_ID, ',')))    -- 20180620 division 추가
                AND P_DIVISION_ID IN (
                    SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                    FROM   DUAL
                    CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                )
            ORDER BY SEQ, SORT_ORDER_NO;

        END IF;

    ELSE -- V_EXISTS <> 0

        OPEN O_RC1 FOR
        SELECT U.PROGRAM_ID
             , U.SHEET_NAME
             , U.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , U.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
             , U.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , '' AS DAY_CODE
             , C.FIXED_FLAG
             , C.COLUMN_WIDTH
             , C.CELL_CONTROL_OBJECT_TYPE_CODE
             , C.CELL_COMBO_DATA_TYPE
             , C.DATA_SCALE_NUMBER
             , C.DATA_MAX_LENGTH
             , C.HORIZONTAL_ALIGN_CODE
             , C.UPPERCASE_APPLY_FLAG
             , C.VISIBLE_FLAG
             , C.DEFAULT_FLAG
             , C.USER_SELECTABLE_FLAG
             --, C.VALID_YN
             , CASE C.VALID_YN WHEN 'Y' THEN -- 20180607 추가
                  CASE FN_GET_DIVISION_YN(C.DIVISION_ID, P_DIVISION_ID) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
               ELSE C.VALID_YN END AS VALID_YN
             , 1 AS SEQ
             --, NVL(T2.EDIT_YN,'N') AS EDIT_YN
        FROM   SCM_MST_TITLESET_USER U
             , SCM_MST_SHEET_COLUMNS C
                /*
                INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
                ON T2.UNIT_ID in (
                    SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                    FROM   DUAL
                    CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                )
                */

        WHERE  1 = 1
        AND    U.PROGRAM_ID  = C.PROGRAM_ID
        AND    U.SHEET_NAME  = C.SHEET_NAME
        AND    U.COLUMN_NAME = C.COLUMN_NAME
        AND    U.PROGRAM_ID  = P_PROGRAM_ID
        AND    U.SHEET_NAME  = P_SHEET_NAME
        AND    U.USER_ID     = P_CREATED_BY
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        -- AND P_DIVISION_ID IN (SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.STRING_SPLIT(C.DIVISION_ID, ',')))    -- 20180620 division 추가
        AND P_DIVISION_ID IN (
                    SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                    FROM   DUAL
                    CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                )

        UNION ALL

        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
             , C.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , '' AS DAY_CODE
             , C.FIXED_FLAG
             , C.COLUMN_WIDTH
             , C.CELL_CONTROL_OBJECT_TYPE_CODE
             , C.CELL_COMBO_DATA_TYPE
             , C.DATA_SCALE_NUMBER
             , C.DATA_MAX_LENGTH
             , C.HORIZONTAL_ALIGN_CODE
             , C.UPPERCASE_APPLY_FLAG
             , C.VISIBLE_FLAG
             , C.DEFAULT_FLAG
             , C.USER_SELECTABLE_FLAG
             --, C.VALID_YN
             , CASE C.VALID_YN WHEN 'Y' THEN -- 20180607 추가
                  CASE FN_GET_DIVISION_YN(C.DIVISION_ID, P_DIVISION_ID) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
               ELSE C.VALID_YN END AS VALID_YN
             , 2 AS SEQ
             --, NVL(T2.EDIT_YN,'N') AS EDIT_YN
        FROM   SCM_MST_SHEET_COLUMNS C
                /*
               INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
                ON T2.UNIT_ID in (
                    SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                    FROM   DUAL
                    CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                )
                */

        WHERE  1 = 1
        AND    C.PROGRAM_ID  = P_PROGRAM_ID
        AND    C.SHEET_NAME  = P_SHEET_NAME
        AND    C.VISIBLE_FLAG = 'N'
        AND    C.DEFAULT_FLAG = ''
        AND    C.VALID_YN     = 'Y'
        -- AND P_DIVISION_ID IN (SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.STRING_SPLIT(C.DIVISION_ID, ',')))    -- 20180620 division 추가
        AND P_DIVISION_ID IN (
                    SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                    FROM   DUAL
                    CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                )
        ORDER BY SEQ, SORT_ORDER_NO;

    END IF;

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
            'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
            'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
            'P_CREATED_BY'     VALUE P_CREATED_BY,
            'P_PROGRAM_ID'     VALUE P_PROGRAM_ID,
            'P_SHEET_NAME'     VALUE P_SHEET_NAME,
            'P_DIVISION_ID'    VALUE P_DIVISION_ID
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
        RAISE;
END P_DMF0000_GET_COMMON_SPREAD_TITLE;
