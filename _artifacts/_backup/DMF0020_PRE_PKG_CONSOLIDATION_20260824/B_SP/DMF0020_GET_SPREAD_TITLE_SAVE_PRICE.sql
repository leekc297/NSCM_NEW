-- [BACKUP 2026-08-24] SCM_MGR.DMF0020_GET_SPREAD_TITLE_SAVE_PRICE (PROCEDURE, VALID)
-- 원본 LAST_DDL = 2026-07-27 16:32:47

CREATE OR REPLACE PROCEDURE           "DMF0020_GET_SPREAD_TITLE_SAVE_PRICE"
(
    P_START_DT        IN VARCHAR2,
    P_END_DT          IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DMF0020_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2021/03/04  kuniid         [C20210127-000163] GSCM Sales Price 일괄입력 기능 개선 요청 */
/* 2026.03.17  jcnam          [PJ20264226] NextSCM Pilot 설계 및 개발                                */
/****************************************************************************************************/
/*
VAR RC1 REFCURSOR;
VAR RC2 REFCURSOR;
EXEC DMF0020_GET_SPREAD_TITLE_SAVE_PRICE('20250101','20260301','bindy122678','40',:RC1, :RC2);
PRINT RC1;
PRINT RC2;
*/
AS

    v_program_id     VARCHAR2(50 CHAR) := 'DMF0020';
    v_sheet_name     VARCHAR2(50 CHAR) := 'Sales Price Save All';

    I_COUNT          PLS_INTEGER := 0;

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

    -- 1. 등록여부
    SELECT COUNT(*)
    INTO   I_COUNT
    FROM   SCM_MST_TITLESET_USER U
    --     , SCM_MST_SHEET_COLUMNS C
    WHERE  1 = 1
    --AND    U.PROGRAM_ID  = C.PROGRAM_ID
    --AND    U.SHEET_NAME  = C.SHEET_NAME
    --AND    U.COLUMN_NAME = C.COLUMN_NAME
    AND    U.PROGRAM_ID  = v_program_id
    AND    U.SHEET_NAME  = v_sheet_name
    AND    U.USER_ID     = P_CREATED_BY
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

    -- 2.
    --IF I_COUNT = 0 THEN
    -- 일반 데이터 칼럼
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
         --, CASE C.VALID_YN  WHEN 'Y' THEN -- 20180607 추가
         --  CASE dbo.FN_GET_DIVISION_YN(C.DIVISION_ID, @p_division_id) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
         -- ELSE C.VALID_YN END VALID_YN
         , '0'                      AS SEQ
    --INTO #tmpTitleO
    FROM   SCM_MST_SHEET_COLUMNS C
    WHERE  1 = 1
    AND    C.PROGRAM_ID  = v_program_id
    AND    C.SHEET_NAME  = v_sheet_name
    AND    ( C.DEFAULT_FLAG = 'Y'
          OR (    C.VISIBLE_FLAG = 'N'
              AND (C.DEFAULT_FLAG IS NULL OR C.DEFAULT_FLAG = '-' OR C.DEFAULT_FLAG = ' ')   -- MSSQL '' = Oracle NULL
              AND C.VALID_YN     = 'Y'
             )
           )
    AND    P_DIVISION_ID IN (                                              -- 20180604 division 추가
               SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
               FROM   DUAL
               CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
           )
    -- 날짜 데이터 칼럼
    UNION ALL
    SELECT v_program_id            AS PROGRAM_ID
         , v_sheet_name            AS SHEET_NAME
         , MA.COLUMN_NAME
         , MA.COLUMN_LABEL_NAME
         , TO_NUMBER(MA.SORT_ORDER_NO) AS SORT_ORDER_NO   -- VARCHAR2 → NUMBER (ORA-01790 방지)
         , ''                      AS DATA_SORT_METHOD_CODE
         , MA.SMALL_CLASS_LABEL_NAME
         , MA.LARGE_CLASS_LABEL_NAME
         , MA.DAY_CODE
         , ''                      AS FIXED_FLAG
         , 120                     AS COLUMN_WIDTH
         , MA.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
         , ''                      AS CELL_COMBO_DATA_TYPE
         --, 2                     AS DATA_SCALE_NUMBER
         , 3                       AS DATA_SCALE_NUMBER    -- 20181029  NUMBER 리터럴 (ORA-01790 방지)
         , TO_NUMBER(NULL)         AS DATA_MAX_LENGTH      -- NUMBER NULL (ORA-01790 방지)
         , 'R'                     AS HORIZONTAL_ALIGN_CODE
         , 'Y'                     AS UPPERCASE_APPLY_FLAG
         , 'Y'                     AS VISIBLE_FLAG
         , ''                      AS DEFAULT_FLAG
         , ''                      AS USER_SELECTABLE_FLAG
         , ''                      AS VALID_YN
         , ''                      AS DIVISION_ID
    FROM (
            SELECT 'W_' || MIN(BASIS_START_DATE)               AS COLUMN_NAME
                 , SUBSTR(BASIS_START_DATE, 5, 4)              AS COLUMN_LABEL_NAME
                 , WEEK_NAME                                   AS SMALL_CLASS_LABEL_NAME
                 , MONTH_NAME                                  AS LARGE_CLASS_LABEL_NAME
                 , ''                                          AS DAY_CODE
                 , MIN(BASIS_START_DATE)                        AS SORT_ORDER_NO
                 , 'FPNumber'                                  AS CELL_CONTROL_OBJECT_TYPE_CODE
            FROM   SCM_SYS_CALENDAR_M
            WHERE  BASIS_YYYYMMDD >= P_START_DT
            AND    BASIS_YYYYMMDD <= P_END_DT
            GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4), MONTH_NAME

            UNION ALL

            SELECT 'M_' || MIN(BASIS_START_DATE)               AS COLUMN_NAME
                 , SUBSTR(BASIS_START_DATE, 5, 4)              AS COLUMN_LABEL_NAME
                 , WEEK_NAME                                   AS SMALL_CLASS_LABEL_NAME
                 , MONTH_NAME                                  AS LARGE_CLASS_LABEL_NAME
                 , ''                                          AS DAY_CODE
                 , MIN(BASIS_START_DATE)                        AS SORT_ORDER_NO
                 , 'FPNumber'                                  AS CELL_CONTROL_OBJECT_TYPE_CODE
            FROM   SCM_SYS_CALENDAR_M
            WHERE  BASIS_YYYYMMDD >= P_START_DT
            AND    BASIS_YYYYMMDD <= P_END_DT
            AND    CALENDAR_DAY = '01'
            GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4), MONTH_NAME

         ) MA
    ORDER BY SORT_ORDER_NO, COLUMN_LABEL_NAME, COLUMN_NAME;

    --ELSE --IF I_COUNT <> 0
    --BEGIN
    -- -- 일반 데이터 칼럼
    -- SELECT U.PROGRAM_ID
    --   , U.SHEET_NAME
    --   , U.COLUMN_NAME
    --   , C.COLUMN_LABEL_NAME
    --   , U.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
    --   , U.DATA_SORT_METHOD_CODE
    --   , C.SMALL_CLASS_LABEL_NAME
    --   , C.LARGE_CLASS_LABEL_NAME
    --   , '' AS DAY_CODE
    --   , C.FIXED_FLAG
    --   , C.COLUMN_WIDTH
    --   , C.CELL_CONTROL_OBJECT_TYPE_CODE
    --   , C.CELL_COMBO_DATA_TYPE
    --   , C.DATA_SCALE_NUMBER
    --   , C.DATA_MAX_LENGTH
    --   , C.HORIZONTAL_ALIGN_CODE
    --   , C.UPPERCASE_APPLY_FLAG
    --   , C.VISIBLE_FLAG
    --   , C.DEFAULT_FLAG
    --   , C.USER_SELECTABLE_FLAG
    --   --, C.VALID_YN
    --   , CASE C.VALID_YN  WHEN 'Y' THEN -- 20180607 추가
    --    CASE FN_GET_DIVISION_YN(C.DIVISION_ID, P_DIVISION_ID) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
    --   ELSE C.VALID_YN END VALID_YN
    --   , 1 AS SEQ
    -- FROM   SCM_MST_TITLESET_USER U
    --   , SCM_MST_SHEET_COLUMNS C
    -- WHERE  1 = 1
    -- AND    U.PROGRAM_ID  = C.PROGRAM_ID
    -- AND    U.SHEET_NAME  = C.SHEET_NAME
    -- AND    U.COLUMN_NAME = C.COLUMN_NAME
    -- AND    U.PROGRAM_ID  = v_program_id
    -- AND    U.SHEET_NAME  = v_sheet_name
    -- AND    U.USER_ID     = P_CREATED_BY
    -- AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    -- AND    P_DIVISION_ID IN (
    --            SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
    --            FROM   DUAL
    --            CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
    --        )  -- 20180604 division 추가
    -- UNION ALL
    -- SELECT C.PROGRAM_ID
    --   , C.SHEET_NAME
    --   , C.COLUMN_NAME
    --   , C.COLUMN_LABEL_NAME
    --   , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
    --   , C.DATA_SORT_METHOD_CODE
    --   , C.SMALL_CLASS_LABEL_NAME
    --   , C.LARGE_CLASS_LABEL_NAME
    --   , '' AS DAY_CODE
    --   , C.FIXED_FLAG
    --   , C.COLUMN_WIDTH
    --   , C.CELL_CONTROL_OBJECT_TYPE_CODE
    --   , C.CELL_COMBO_DATA_TYPE
    --   , C.DATA_SCALE_NUMBER
    --   , C.DATA_MAX_LENGTH
    --   , C.HORIZONTAL_ALIGN_CODE
    --   , C.UPPERCASE_APPLY_FLAG
    --   , C.VISIBLE_FLAG
    --   , C.DEFAULT_FLAG
    --   , C.USER_SELECTABLE_FLAG
    --   , C.VALID_YN
    --   , 2 AS SEQ
    -- FROM   SCM_MST_SHEET_COLUMNS C
    -- WHERE  1 = 1
    -- AND    C.PROGRAM_ID   = v_program_id
    -- AND    C.SHEET_NAME   = v_sheet_name
    -- AND    C.VISIBLE_FLAG = 'N'
    -- AND    (C.DEFAULT_FLAG IS NULL OR C.DEFAULT_FLAG = '-' OR C.DEFAULT_FLAG = ' ')
    -- AND    C.VALID_YN     = 'Y'
    -- AND    P_DIVISION_ID IN (
    --            SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
    --            FROM   DUAL
    --            CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
    --        )  -- 20180604 division 추가
    -- --ORDER BY SEQ, SORT_ORDER_NO
    -- -- 날짜 데이터 칼럼
    -- UNION ALL
    -- SELECT
    --  v_program_id             AS PROGRAM_ID
    --  , v_sheet_name           AS SHEET_NAME
    --  , MA.COLUMN_NAME
    --  , MA.COLUMN_LABEL_NAME
    --  , TO_NUMBER(MA.SORT_ORDER_NO) AS SORT_ORDER_NO
    --  , ''                     AS DATA_SORT_METHOD_CODE
    --  , MA.SMALL_CLASS_LABEL_NAME
    --  , MA.LARGE_CLASS_LABEL_NAME
    --  , MA.DAY_CODE
    --  , ''                     AS FIXED_FLAG
    --  , 120                    AS COLUMN_WIDTH
    --  , MA.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
    --  , ''                     AS CELL_COMBO_DATA_TYPE
    --  --, 2                    AS DATA_SCALE_NUMBER
    --  , 3                      AS DATA_SCALE_NUMBER -- 20181029
    --  , TO_NUMBER(NULL)        AS DATA_MAX_LENGTH
    --  , 'R'                    AS HORIZONTAL_ALIGN_CODE
    --  , 'Y'                    AS UPPERCASE_APPLY_FLAG
    --  , 'Y'                    AS VISIBLE_FLAG
    --  , ''                     AS DEFAULT_FLAG
    --  , ''                     AS USER_SELECTABLE_FLAG
    --  , ''                     AS VALID_YN
    --  , ''                     AS DIVISION_ID
    -- FROM  (
    --  SELECT
    --   'W_' || MIN(BASIS_START_DATE)              AS COLUMN_NAME
    --   , SUBSTR(BASIS_START_DATE, 5, 4)           AS COLUMN_LABEL_NAME
    --   , WEEK_NAME                                AS SMALL_CLASS_LABEL_NAME
    --   , MONTH_NAME                               AS LARGE_CLASS_LABEL_NAME
    --   , ''                                       AS DAY_CODE
    --   , MIN(BASIS_START_DATE)                     AS SORT_ORDER_NO
    --   , 'FPNumber'                               AS CELL_CONTROL_OBJECT_TYPE_CODE
    --  FROM SCM_SYS_CALENDAR_M
    --  WHERE  BASIS_YYYYMMDD >= P_START_DT
    --   AND    BASIS_YYYYMMDD <= P_END_DT
    --  GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4), MONTH_NAME
    --
    --  UNION ALL
    --
    --  SELECT
    --   'M_' || MIN(BASIS_START_DATE)              AS COLUMN_NAME
    --   , SUBSTR(BASIS_START_DATE, 5, 4)           AS COLUMN_LABEL_NAME
    --   , WEEK_NAME                                AS SMALL_CLASS_LABEL_NAME
    --   , MONTH_NAME                               AS LARGE_CLASS_LABEL_NAME
    --   , ''                                       AS DAY_CODE
    --   , MIN(BASIS_START_DATE)                     AS SORT_ORDER_NO
    --   , 'FPNumber'                               AS CELL_CONTROL_OBJECT_TYPE_CODE
    --  FROM SCM_SYS_CALENDAR_M
    --  WHERE  BASIS_YYYYMMDD >= P_START_DT
    --   AND BASIS_YYYYMMDD <= P_END_DT
    --   AND CALENDAR_DAY = '01'
    --  GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4), MONTH_NAME
    --
    -- ) MA
    -- ORDER BY SORT_ORDER_NO, COLUMN_LABEL_NAME, COLUMN_NAME;
    --END IF;

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
                'P_START_DT'    VALUE P_START_DT,
                'P_END_DT'      VALUE P_END_DT,
                'P_CREATED_BY'  VALUE P_CREATED_BY,
                'P_DIVISION_ID' VALUE P_DIVISION_ID
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

END DMF0020_GET_SPREAD_TITLE_SAVE_PRICE;
/
