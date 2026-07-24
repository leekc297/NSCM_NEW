
  CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0021_GET_SPREAD_TITLE" 
/* [E20260715] MSSQL '' = Oracle NULL 변환 함정 정정 — 숨김 필수 컬럼 포함 조건(2개소)이 실데이터 DEFAULT_FLAG='N' 을 탈락시켜 SALES_PLAN_ADJUST_YN/GROUP_ID 헤더 메타 누락. admin */
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,   -- 20180604 division 추가
    P_BUCKET          IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DM0021_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2018/06/04     JYE				Div별로 연동                                                            */
/* 2018/10/26     JYE				스프레드 해더 칼럼 통합(일반 데이터 + 날짜데이터)                       */
/* 2021/10/12	rosia27				Sales Plan 속도 개선											        */
/* 2024.03.29   kcw3408             USER_INQUIRY_COLUMN_TYPE_CODE = 'C' 추가					            */
/* 2026.03.17  jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
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
AS

    v_user_col_cnt   PLS_INTEGER := 0;
    v_program_id     VARCHAR2(4000 CHAR);
    v_sheet_name     VARCHAR2(4000 CHAR);

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

    v_program_id   := 'DMF0021';
    v_sheet_name   := 'Sales Plan';
    v_user_col_cnt := 0;

    SELECT COUNT(*)
    INTO   v_user_col_cnt
    FROM   SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = v_program_id
    AND    U.SHEET_NAME = v_sheet_name
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'    /* 2024.03.29   kcw3408  추가 */
    AND    U.USER_ID    = P_CREATED_BY;

    IF v_user_col_cnt > 0 THEN

        OPEN O_RC1 FOR
        SELECT U.PROGRAM_ID
             , U.SHEET_NAME
             , U.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , U.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
             , U.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , ''                     AS DAY_CODE
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
             , C.VALID_YN
             , C.DIVISION_ID
        FROM   SCM_MST_TITLESET_USER U
             , SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    U.PROGRAM_ID  = C.PROGRAM_ID
        AND    U.SHEET_NAME  = C.SHEET_NAME
        AND    U.COLUMN_NAME = C.COLUMN_NAME
        AND    U.PROGRAM_ID  = v_program_id
        AND    U.SHEET_NAME  = v_sheet_name
        AND    U.USER_ID     = P_CREATED_BY
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
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
             , ''                     AS DAY_CODE
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
             , C.VALID_YN
             , C.DIVISION_ID
        FROM   SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = v_program_id
        AND    C.SHEET_NAME   = v_sheet_name
        AND    C.VISIBLE_FLAG = 'N'
        AND    NVL(C.DEFAULT_FLAG,'N') <> 'Y'   --[E20260715] ''=NULL 함정 정정 (실데이터 'N' 탈락 보정)
        AND    C.VALID_YN     = 'Y'
        AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                   SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                   FROM   DUAL
                   CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
               )
        UNION ALL
        SELECT v_program_id            AS PROGRAM_ID
             , v_sheet_name            AS SHEET_NAME
             , T.COLUMN_NAME
             , T.COLUMN_LABEL_NAME
             , TO_NUMBER(T.SORT_ORDER_NO) AS SORT_ORDER_NO    -- ORA-01790 방지
             , ''                      AS DATA_SORT_METHOD_CODE
             , T.SMALL_CLASS_LABEL_NAME
             , T.LARGE_CLASS_LABEL_NAME
             , T.DAY_CODE
             , ''                      AS FIXED_FLAG
             , 50                      AS COLUMN_WIDTH
             , T.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
             , ''                      AS CELL_COMBO_DATA_TYPE
             , 3                       AS DATA_SCALE_NUMBER    -- ORA-01790 방지: NUMBER 리터럴
             , TO_NUMBER(NULL)         AS DATA_MAX_LENGTH      -- ORA-01790 방지: NUMBER NULL
             , 'R'                     AS HORIZONTAL_ALIGN_CODE
             , 'Y'                     AS UPPERCASE_APPLY_FLAG
             , 'Y'                     AS VISIBLE_FLAG
             , ''                      AS DEFAULT_FLAG
             , ''                      AS USER_SELECTABLE_FLAG
             , ''                      AS VALID_YN
             , ''                      AS DIVISION_ID
        FROM (
                SELECT 'D_' || A.BASIS_YYYYMMDD                AS COLUMN_NAME
                     , A.CALENDAR_DAY                          AS COLUMN_LABEL_NAME
                     , A.WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , A.DAYOFWEEK                             AS DAY_CODE
                     , A.BASIS_YYYYMMDD || TO_CHAR(31, 'FM00') AS SORT_ORDER_NO
                     , 'FPNumber'                              AS CELL_CONTROL_OBJECT_TYPE_CODE
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                AND    1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                --UNION ALL
                --SELECT 'DB_' || A.BASIS_YYYYMMDD ...
                UNION ALL
                SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK   AS COLUMN_NAME
                     , A.WEEK_NAME                             AS COLUMN_LABEL_NAME
                     , A.WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , ''                                      AS DAY_CODE
                     , A.BASIS_START_DATE || TO_CHAR(21, 'FM00') AS SORT_ORDER_NO
                     , 'FPNumber'                              AS CELL_CONTROL_OBJECT_TYPE_CODE
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                GROUP BY A.BASIS_YYYYMM
                       , A.ISO_WEEK
                       , A.WEEK_NAME
                       , A.MONTH_NAME
                       , A.BASIS_START_DATE
                --UNION ALL
                --SELECT 'WB_' || A.BASIS_YYYYMM || A.ISO_WEEK ...
                UNION ALL
                SELECT 'M_' || A.BASIS_YYYYMM                 AS COLUMN_NAME
                     , A.MONTH_NAME                            AS COLUMN_LABEL_NAME
                     , A.MONTH_NAME                            AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , ''                                      AS DAY_CODE
                     , MIN(A.BASIS_START_DATE) || '01'         AS SORT_ORDER_NO
                     , 'FPNumber'                              AS CELL_CONTROL_OBJECT_TYPE_CODE
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                GROUP BY A.BASIS_YYYYMM
                       , A.MONTH_NAME
                --UNION ALL
                --SELECT 'MB_' || A.BASIS_YYYYMM ...
             ) T
        ORDER BY SORT_ORDER_NO;

    ELSE

        OPEN O_RC1 FOR
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
             , C.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , ''                     AS DAY_CODE
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
             , C.VALID_YN
             , C.DIVISION_ID
        FROM   SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = v_program_id
        AND    C.SHEET_NAME   = v_sheet_name
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y'
        AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
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
             , ''                     AS DAY_CODE
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
             , C.VALID_YN
             , C.DIVISION_ID
        FROM   SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = v_program_id
        AND    C.SHEET_NAME   = v_sheet_name
        AND    C.VISIBLE_FLAG = 'N'
        AND    NVL(C.DEFAULT_FLAG,'N') <> 'Y'   --[E20260715] ''=NULL 함정 정정 (실데이터 'N' 탈락 보정)
        AND    C.VALID_YN     = 'Y'
        AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                   SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                   FROM   DUAL
                   CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
               )
        UNION ALL
        SELECT v_program_id            AS PROGRAM_ID
             , v_sheet_name            AS SHEET_NAME
             , T.COLUMN_NAME
             , T.COLUMN_LABEL_NAME
             , TO_NUMBER(T.SORT_ORDER_NO) AS SORT_ORDER_NO    -- ORA-01790 방지
             , ''                      AS DATA_SORT_METHOD_CODE
             , T.SMALL_CLASS_LABEL_NAME
             , T.LARGE_CLASS_LABEL_NAME
             , T.DAY_CODE
             , ''                      AS FIXED_FLAG
             , 50                      AS COLUMN_WIDTH
             , 'FPNumber'              AS CELL_CONTROL_OBJECT_TYPE_CODE
             , ''                      AS CELL_COMBO_DATA_TYPE
             , 3                       AS DATA_SCALE_NUMBER    -- ORA-01790 방지: NUMBER 리터럴
             , TO_NUMBER(NULL)         AS DATA_MAX_LENGTH      -- ORA-01790 방지: NUMBER NULL
             , 'R'                     AS HORIZONTAL_ALIGN_CODE
             , 'Y'                     AS UPPERCASE_APPLY_FLAG
             , 'Y'                     AS VISIBLE_FLAG
             , ''                      AS DEFAULT_FLAG
             , ''                      AS USER_SELECTABLE_FLAG
             , ''                      AS VALID_YN
             , ''                      AS DIVISION_ID
        FROM (
                SELECT 'D_' || A.BASIS_YYYYMMDD                AS COLUMN_NAME
                     , A.CALENDAR_DAY                          AS COLUMN_LABEL_NAME
                     , A.WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , A.DAYOFWEEK                             AS DAY_CODE
                     , A.BASIS_YYYYMMDD || TO_CHAR(31, 'FM00') AS SORT_ORDER_NO
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                AND    1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                --UNION ALL
                --SELECT 'DB_' || A.BASIS_YYYYMMDD ...
                UNION ALL
                SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK   AS COLUMN_NAME
                     , A.WEEK_NAME                             AS COLUMN_LABEL_NAME
                     , A.WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , ''                                      AS DAY_CODE
                     , A.BASIS_START_DATE || TO_CHAR(21, 'FM00') AS SORT_ORDER_NO
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                GROUP BY A.BASIS_YYYYMM
                       , A.ISO_WEEK
                       , A.WEEK_NAME
                       , A.MONTH_NAME
                       , A.BASIS_START_DATE
                --UNION ALL
                --SELECT 'WB_' || A.BASIS_YYYYMM || A.ISO_WEEK ...
                UNION ALL
                SELECT 'M_' || A.BASIS_YYYYMM                 AS COLUMN_NAME
                     , A.MONTH_NAME                            AS COLUMN_LABEL_NAME
                     , A.MONTH_NAME                            AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , ''                                      AS DAY_CODE
                     , MIN(A.BASIS_START_DATE) || '01'         AS SORT_ORDER_NO
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                GROUP BY A.BASIS_YYYYMM
                       , A.MONTH_NAME
                --UNION ALL
                --SELECT 'MB_' || A.BASIS_YYYYMM ...
             ) T
        ORDER BY SORT_ORDER_NO;

    END IF;

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
        V_PROC_INPUT  :=
            JSON_OBJECT(
                'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
                'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
                'P_CREATED_BY'     VALUE P_CREATED_BY,
                'P_DIVISION_ID'    VALUE P_DIVISION_ID,
                'P_BUCKET'         VALUE P_BUCKET
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

END DMF0021_GET_SPREAD_TITLE;
/