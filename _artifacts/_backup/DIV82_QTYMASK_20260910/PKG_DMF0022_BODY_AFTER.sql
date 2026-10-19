PACKAGE BODY           "PKG_DMF0022"
/****************************************************************************************************/
/* PROGRAM ID  : PKG_DMF0006                                                                        */
/* DESCRIPTION : PKG_DMF0006                                                                        */
/* USAGE       :                                                                                    */
/* PARAMETER   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* DATE        IN CHARGE    DESCRIPTION                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.18  SSLEE        [PJ20264226] NEXTSCM PILOT 설계 및 개발                                   */
/*                          UI 항목으로 PACKAGE로 전환                                                 */
/****************************************************************************************************/
AS

PROCEDURE P_DMF0022_GET_SPREAD_TITLE
(
    P_START_YYYYMMDD    IN VARCHAR2,
    P_END_YYYYMMDD      IN VARCHAR2,
    P_CREATED_BY        IN VARCHAR2,
    P_DIVISION_ID       IN VARCHAR2,
    P_BUCKET            IN VARCHAR2,
    P_USER_ID           IN VARCHAR2,
    P_MENU_ID           IN VARCHAR2,

    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID  : DMF0022_GET_SPREAD_TITLE
 * Description : Procedure 작성 가이드
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *
 *--------------------------------------------------------------------------------------------------
 * Date        In Charge    Description
 *--------------------------------------------------------------------------------------------------
 * 2018/02/05  pjs       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20180618   JYE  Div별로 연동
 * 2018/10/26     JYE       스프레드 해더 칼럼 통합(일반 데이터 + 날짜데이터)
 * 2021/11/15 rosia27   [PJ20209643] SALES PLAN WATERFALL 속도개선
 * 2022.07.19 kdw2819   [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
 */
AS
    i_Count         PLS_INTEGER := 0;
    v_program_id    VARCHAR2(50 CHAR) := 'DMF0035';  --[E20260909-TYPEAXIS] SHEET_COLUMNS/SHEET_MEASURE/TITLESET 축 = PROGRAM_ID 'DMF0035' + AS-IS 실등록 시트명 (사용자 지시 2026-09-09). PKG 명은 유지.
    v_sheet_name    VARCHAR2(50 CHAR) := 'Sales Plan Waterfall';  --[E20260806-WF] SHEET_COLUMNS/TITLESET 실등록명(FE) 정합

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    n_log_count     PLS_INTEGER := 0;
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := $$PLSQL_UNIT;

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    SELECT COUNT(*)
      INTO i_Count
      FROM SCM_MGR.SCM_MST_TITLESET_USER U
     WHERE U.PROGRAM_ID                      = v_program_id
       AND U.SHEET_NAME                      = v_sheet_name
       AND U.USER_ID                         = P_CREATED_BY
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE   = 'C';

    -- 날짜 컬럼 인라인 뷰 (DAILY/WEEKLY/MONTHLY/ONLY_WEEKLY 조건 공통)
    -- CONVERT(CHAR(2), 31) → TO_CHAR(31, 'FM00')
    -- SUBSTRING → SUBSTR
    -- + (문자열 연결) → ||

    IF i_Count > 0 THEN
        OPEN O_RC1 FOR
            SELECT U.PROGRAM_ID
                 , U.SHEET_NAME
                 , U.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , U.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                 , U.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , ''            AS DAY_CODE
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
                 , EDY.EDIT_YN
              FROM SCM_MGR.SCM_MST_TITLESET_USER  U
                 , SCM_MGR.SCM_MST_SHEET_COLUMNS  C
                   INNER JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY
                        ON EDY.USER_ID = P_USER_ID
                       AND EDY.MNU_ID  = P_MENU_ID
                       AND EDY.UNIT_ID = P_DIVISION_ID  --[E20260806-WF] C.DIVISION_ID 는 콤마 목록 — 정확일치 조인은 단독값 행만 생존(고정컬럼 2개 결함)
             WHERE U.PROGRAM_ID  = C.PROGRAM_ID
               AND U.SHEET_NAME  = C.SHEET_NAME
               AND U.COLUMN_NAME = C.COLUMN_NAME
               AND U.PROGRAM_ID  = v_program_id
               AND U.SHEET_NAME  = v_sheet_name
               AND U.USER_ID     = P_CREATED_BY
               AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
               AND P_DIVISION_ID IN (
                       SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                         FROM DUAL
                       CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )    -- 20180620 division 추가
            UNION ALL
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                 , C.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , ''            AS DAY_CODE
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
                 , EDY.EDIT_YN
              FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
                   INNER JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY
                        ON EDY.USER_ID = P_USER_ID
                       AND EDY.MNU_ID  = P_MENU_ID
                       AND EDY.UNIT_ID = P_DIVISION_ID  --[E20260806-WF] C.DIVISION_ID 는 콤마 목록 — 정확일치 조인은 단독값 행만 생존(고정컬럼 2개 결함)
             WHERE C.PROGRAM_ID   = v_program_id
               AND C.SHEET_NAME   = v_sheet_name
               AND C.VISIBLE_FLAG = 'N'
               AND RTRIM(C.DEFAULT_FLAG, ' -') IS NULL  --[E20260806-WF] 빈값 판정: NULL/' '/'-' 동일 취급
               AND C.VALID_YN     = 'Y'
               AND P_DIVISION_ID IN (
                       SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                         FROM DUAL
                       CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )    -- 20180620 division 추가
            UNION ALL
            SELECT v_program_id   AS PROGRAM_ID
                 , v_sheet_name   AS SHEET_NAME
                 , T.COLUMN_NAME
                 , T.COLUMN_LABEL_NAME
                 , ROW_NUMBER() OVER(ORDER BY T.SORT_ORDER_NO) AS SORT_ORDER_NO
                 , ''             AS DATA_SORT_METHOD_CODE
                 , T.SMALL_CLASS_LABEL_NAME
                 , T.LARGE_CLASS_LABEL_NAME
                 , T.DAY_CODE
                 , ''             AS FIXED_FLAG
                 , CASE WHEN P_BUCKET = 'ONLY_WEEKLY' THEN 100 ELSE 50 END AS COLUMN_WIDTH
                 , T.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                 , ''             AS CELL_COMBO_DATA_TYPE
                 , 3              AS DATA_SCALE_NUMBER
                 , NULL           AS DATA_MAX_LENGTH
                 , 'R'            AS HORIZONTAL_ALIGN_CODE
                 , 'Y'            AS UPPERCASE_APPLY_FLAG
                 , 'Y'            AS VISIBLE_FLAG
                 , ''             AS DEFAULT_FLAG
                 , ''             AS USER_SELECTABLE_FLAG
                 , ''             AS VALID_YN
                 , ''             AS DIVISION_ID
                 , 'N'            AS EDIT_YN
              FROM (
                       SELECT 'D_' || A.BASIS_YYYYMMDD       AS COLUMN_NAME
                            , A.CALENDAR_DAY                  AS COLUMN_LABEL_NAME
                            , A.WEEK_NAME                     AS SMALL_CLASS_LABEL_NAME
                            , A.MONTH_NAME                    AS LARGE_CLASS_LABEL_NAME
                            , A.DAYOFWEEK                     AS DAY_CODE
                            , A.BASIS_YYYYMMDD || TO_CHAR(31, 'FM00') AS SORT_ORDER_NO
                            , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                          AND 1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                       /*UNION ALL
                       SELECT 'DB_' || A.BASIS_YYYYMMDD  AS COLUMN_NAME
                            , A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
                            , A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
                            , A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
                            , ''                        AS DAY_CODE
                            , A.BASIS_YYYYMMDD || TO_CHAR(32, 'FM00') AS SORT_ORDER_NO
                            , 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
                         FROM SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD*/
                       UNION ALL
                       SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK  AS COLUMN_NAME
                            , A.WEEK_NAME                            AS COLUMN_LABEL_NAME
                            , A.WEEK_NAME                            AS SMALL_CLASS_LABEL_NAME
                            , A.MONTH_NAME                           AS LARGE_CLASS_LABEL_NAME
                            , ''                                     AS DAY_CODE
                            , A.BASIS_START_DATE || TO_CHAR(21, 'FM00') AS SORT_ORDER_NO
                            , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                          AND 1 = CASE WHEN P_BUCKET <> 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                        GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.WEEK_NAME, A.MONTH_NAME, A.BASIS_START_DATE
                       /*UNION ALL
                       SELECT 'WB_' || A.BASIS_YYYYMM || A.ISO_WEEK  AS COLUMN_NAME
                            , A.WEEK_NAME           AS COLUMN_LABEL_NAME
                            , A.WEEK_NAME           AS SMALL_CLASS_LABEL_NAME
                            , A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
                            , ''                    AS DAY_CODE
                            , A.BASIS_START_DATE || TO_CHAR(22, 'FM00') AS SORT_ORDER_NO
                            , 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
                         FROM SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                        GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.WEEK_NAME, A.MONTH_NAME, A.BASIS_START_DATE*/
                       UNION ALL
                       SELECT 'M_' || A.BASIS_YYYYMM              AS COLUMN_NAME
                            , A.MONTH_NAME                         AS COLUMN_LABEL_NAME
                            , A.MONTH_NAME                         AS SMALL_CLASS_LABEL_NAME
                            , A.MONTH_NAME                         AS LARGE_CLASS_LABEL_NAME
                            , ''                                   AS DAY_CODE
                            , MIN(A.BASIS_START_DATE) || TO_CHAR(1, 'FM00') AS SORT_ORDER_NO
                            , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                          AND 1 = CASE WHEN P_BUCKET <> 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                        GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                       /*UNION ALL
                       SELECT 'MB_' || A.BASIS_YYYYMM  AS COLUMN_NAME
                            , A.MONTH_NAME             AS COLUMN_LABEL
                            , A.MONTH_NAME             AS SMALL_LABEL_NAME
                            , A.MONTH_NAME             AS LARGE_LABEL_NAME
                            , ''                       AS DAY_CODE
                            , MIN(A.BASIS_START_DATE) || TO_CHAR(11, 'FM00') AS SORT_ORDER_NO
                            , 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
                         FROM SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                        GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME*/
                       --ORDER BY sort_order_no
                       -- 2022.07.19  kdw2819   [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
                       UNION ALL
                       SELECT 'W_' || SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK  AS COLUMN_NAME
                            , WEEK_NAME                                                AS COLUMN_LABEL_NAME
                            , WEEK_NAME                                                AS SMALL_CLASS_LABEL_NAME
                            , SUBSTR(MIN(BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MIN(BASIS_YYYYMMDD), 7, 2)
                                  || ' ~ ' || SUBSTR(MAX(BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MAX(BASIS_YYYYMMDD), 7, 2)
                                                                                       AS LARGE_CLASS_LABEL_NAME
                            , ''                                                       AS DAY_CODE
                            , MAX(BASIS_YYYYMMDD) || TO_CHAR(21, 'FM00')              AS SORT_ORDER_NO
                            -- , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                            , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                          AND 1 = CASE WHEN P_BUCKET = 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                        GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME
                   ) T
             ORDER BY SORT_ORDER_NO;

        DBMS_OUTPUT.PUT_LINE('-------------' || P_BUCKET);

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
                 , ''            AS DAY_CODE
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
                 , EDY.EDIT_YN
              FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
                   INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) EDY
                       ON EDY.UNIT_ID = P_DIVISION_ID  --[E20260806-WF] C.DIVISION_ID 는 콤마 목록 — 정확일치 조인은 단독값 행만 생존(고정컬럼 2개 결함)
             WHERE C.PROGRAM_ID   = v_program_id
               AND C.SHEET_NAME   = v_sheet_name
               AND C.DEFAULT_FLAG = 'Y'
               AND C.VALID_YN     = 'Y'
               AND P_DIVISION_ID IN (
                       SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                         FROM DUAL
                       CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )    -- 20180620 division 추가
            UNION ALL
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                 , C.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , ''            AS DAY_CODE
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
                 , EDY.EDIT_YN
              FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
                   INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) EDY
                       ON EDY.UNIT_ID = P_DIVISION_ID  --[E20260806-WF] C.DIVISION_ID 는 콤마 목록 — 정확일치 조인은 단독값 행만 생존(고정컬럼 2개 결함)
             WHERE C.PROGRAM_ID   = v_program_id
               AND C.SHEET_NAME   = v_sheet_name
               AND C.VISIBLE_FLAG = 'N'
               AND RTRIM(C.DEFAULT_FLAG, ' -') IS NULL  --[E20260806-WF] 빈값 판정: NULL/' '/'-' 동일 취급
               AND C.VALID_YN     = 'Y'
               AND P_DIVISION_ID IN (
                       SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                         FROM DUAL
                       CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )    -- 20180620 division 추가
            UNION ALL
            SELECT v_program_id   AS PROGRAM_ID
                 , v_sheet_name   AS SHEET_NAME
                 , T.COLUMN_NAME
                 , T.COLUMN_LABEL_NAME
                 , ROW_NUMBER() OVER(ORDER BY T.SORT_ORDER_NO) AS SORT_ORDER_NO
                 , ''             AS DATA_SORT_METHOD_CODE
                 , T.SMALL_CLASS_LABEL_NAME
                 , T.LARGE_CLASS_LABEL_NAME
                 , T.DAY_CODE
                 , ''             AS FIXED_FLAG
                 , CASE WHEN P_BUCKET = 'ONLY_WEEKLY' THEN 100 ELSE 50 END AS COLUMN_WIDTH
                 , 'FPNumber'     AS CELL_CONTROL_OBJECT_TYPE_CODE
                 , ''             AS CELL_COMBO_DATA_TYPE
                 , 3              AS DATA_SCALE_NUMBER
                 , NULL           AS DATA_MAX_LENGTH
                 , 'R'            AS HORIZONTAL_ALIGN_CODE
                 , 'Y'            AS UPPERCASE_APPLY_FLAG
                 , 'Y'            AS VISIBLE_FLAG
                 , ''             AS DEFAULT_FLAG
                 , ''             AS USER_SELECTABLE_FLAG
                 , ''             AS VALID_YN
                 , ''             AS DIVISION_ID
                 , 'N'            AS EDIT_YN
              FROM (
                       SELECT 'D_' || A.BASIS_YYYYMMDD       AS COLUMN_NAME
                            , A.CALENDAR_DAY                  AS COLUMN_LABEL_NAME
                            , A.WEEK_NAME                     AS SMALL_CLASS_LABEL_NAME
                            , A.MONTH_NAME                    AS LARGE_CLASS_LABEL_NAME
                            , A.DAYOFWEEK                     AS DAY_CODE
                            , A.BASIS_YYYYMMDD || TO_CHAR(31, 'FM00') AS SORT_ORDER_NO
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                          AND 1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                       /*UNION ALL
                       SELECT 'DB_' || A.BASIS_YYYYMMDD  AS COLUMN_NAME
                            , A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
                            , A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
                            , A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
                            , ''                        AS DAY_CODE
                            , A.BASIS_YYYYMMDD || TO_CHAR(32, 'FM00') AS SORT_ORDER_NO
                         FROM SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD*/
                       UNION ALL
                       SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK  AS COLUMN_NAME
                            , A.WEEK_NAME                            AS COLUMN_LABEL_NAME
                            , A.WEEK_NAME                            AS SMALL_CLASS_LABEL_NAME
                            , A.MONTH_NAME                           AS LARGE_CLASS_LABEL_NAME
                            , ''                                     AS DAY_CODE
                            , A.BASIS_START_DATE || TO_CHAR(21, 'FM00') AS SORT_ORDER_NO
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                          AND 1 = CASE WHEN P_BUCKET <> 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                        GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.WEEK_NAME, A.MONTH_NAME, A.BASIS_START_DATE
                       /*UNION ALL
                       SELECT 'WB_' || A.BASIS_YYYYMM || A.ISO_WEEK  AS COLUMN_NAME
                            , A.WEEK_NAME           AS COLUMN_LABEL_NAME
                            , A.WEEK_NAME           AS SMALL_CLASS_LABEL_NAME
                            , A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
                            , ''                    AS DAY_CODE
                            , A.BASIS_START_DATE || TO_CHAR(22, 'FM00') AS SORT_ORDER_NO
                         FROM SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                        GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.WEEK_NAME, A.MONTH_NAME, A.BASIS_START_DATE*/
                       UNION ALL
                       SELECT 'M_' || A.BASIS_YYYYMM              AS COLUMN_NAME
                            , A.MONTH_NAME                         AS COLUMN_LABEL_NAME
                            , A.MONTH_NAME                         AS SMALL_CLASS_LABEL_NAME
                            , A.MONTH_NAME                         AS LARGE_CLASS_LABEL_NAME
                            , ''                                   AS DAY_CODE
                            , MIN(A.BASIS_START_DATE) || TO_CHAR(1, 'FM00') AS SORT_ORDER_NO
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                          AND 1 = CASE WHEN P_BUCKET <> 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                        GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                       /*UNION ALL
                       SELECT 'MB_' || A.BASIS_YYYYMM  AS COLUMN_NAME
                            , A.MONTH_NAME             AS COLUMN_LABEL
                            , A.MONTH_NAME             AS SMALL_LABEL_NAME
                            , A.MONTH_NAME             AS LARGE_LABEL_NAME
                            , ''                       AS DAY_CODE
                            , MIN(A.BASIS_START_DATE) || TO_CHAR(11, 'FM00') AS SORT_ORDER_NO
                         FROM SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                        GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME*/
                       --ORDER BY sort_order_no
                       -- 2022.07.19  kdw2819   [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
                       UNION ALL
                       SELECT 'W_' || SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK  AS COLUMN_NAME
                            , WEEK_NAME                                                AS COLUMN_LABEL_NAME
                            , WEEK_NAME                                                AS SMALL_CLASS_LABEL_NAME
                            , SUBSTR(MIN(BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MIN(BASIS_YYYYMMDD), 7, 2)
                                  || ' ~ ' || SUBSTR(MAX(BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MAX(BASIS_YYYYMMDD), 7, 2)
                                                                                       AS LARGE_CLASS_LABEL_NAME
                            , ''                                                       AS DAY_CODE
                            , MAX(BASIS_YYYYMMDD) || TO_CHAR(21, 'FM00')              AS SORT_ORDER_NO
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                          AND 1 = CASE WHEN P_BUCKET = 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                        GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME
                   ) T
             ORDER BY SORT_ORDER_NO;

    END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, NULL AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
             'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD
            ,'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD
            ,'P_CREATED_BY'     VALUE P_CREATED_BY
            ,'P_DIVISION_ID'    VALUE P_DIVISION_ID
            ,'P_BUCKET'         VALUE P_BUCKET
            ,'P_USER_ID'        VALUE P_USER_ID
            ,'P_MENU_ID'        VALUE P_MENU_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION', '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0022_GET_SPREAD_TITLE;

PROCEDURE P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL
(
    P_DIVISION_ID       IN VARCHAR2,
    P_DEPT_ID           IN VARCHAR2,
    P_END_CUSTOMER      IN VARCHAR2,
    P_SCM_SITE_ID       IN VARCHAR2,
    P_PROJECT_CODE      IN VARCHAR2,
    P_ITEM_ID           IN VARCHAR2,
    P_ITEM_TYPE         IN VARCHAR2,
    P_FROM_YYYYMMDD     IN VARCHAR2,
    P_NOW_YYYYMMDD      IN VARCHAR2,
    P_TO_YYYYMMDD       IN VARCHAR2,
    P_CREATED_BY        IN VARCHAR2,
    P_PLANT_SITE_ID     IN VARCHAR2,
    P_BIZTYPE           IN VARCHAR2,
    P_OWNER             IN VARCHAR2,
    P_INTERNAL_YN       IN VARCHAR2,
    P_CELL_YN           IN VARCHAR2,
    P_VERSION_TYPE      IN VARCHAR2,
    P_BUCKET            IN VARCHAR2,   -- 20211110 SALES PLAN WATERFALL 속도 개선
    P_USER_DEPT_ID      IN VARCHAR2,   -- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
    P_GROUP_ID          IN VARCHAR2,   -- JV Planner 일지 확인하기 위해 추가
    P_USER_ID           IN VARCHAR2,
    P_MENU_ID           IN VARCHAR2,

    O_RC1               OUT SYS_REFCURSOR,
    O_RC2               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL
 * Description  : Sales Plan Waterfall 조회
 * Program History
 *=====================================================================================================================================================
 *   Date       In Charge      Description
 *=====================================================================================================================================================
 * 2018/03/12 SeungJae.Hwnag  Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/06/20 JYE       소형 개발
 * 2018/07/27 JYE       scm_mst_site_customer 조인 조건 추가
 * 2018/07/30 Son Young Suk 검색조건 project(코드,네임 라이크 검색), model/item(코드,닉네임 라이크 검색)으로 수정
 * 2018/08/09 JYE       멀티 오너 수정
 * 2018/08/10 JYE       멀티 오너 팀 수정
 * 2018/08/16 KHSONG      미래구간은 VALID_YN='Y' 인것만 추출
 * 2018/08/20 khsong      Sales Plan 비물동 구분코드는 SCM_MST_SITE_ITEM 등록여부와 관계없이 보여줘야함
 * 2018/08/24 Son Young Suk INTERNAL_TXN 포함 여부로 조회
 * 2018/09/07 JYE       INTERNAL_TXN, Cell Type 칼럼 추가
 * 2018/09/19 Son Young Suk MKT 칼럼 추가
 * 2018/10/11 JYE       Cutoff 데이터는 버전에 상응하는 단가 적용
 * 2018/11/02 JYE       칼럼 추가
 * 2018/11/14 JYE       Cell Qty 환산 추가
 * 2018/11/16 JYE       PRIORITY 칼럼 추가
 * 2018/12/13 ytchoi      전체적인 쿼리 변경
 *=====================================================================================================================================================
 * -- 속도개선을 위하여 mkt_fcst처럼 구조 변경한 버전
 *=====================================================================================================================================================
 * 2019/01/08 KHSONG      Unit Price 인경우는 SUM하지 않고 AVG로 표기함
 * 2019/01/18 KHSONG      중복제거위한 DISTINCT추가
 * 2019/01/23 KHSONG      속도개선 조회조건추가
 * 2019/01/25 KHSONG      누락컬럼 추가
 * 2019/01/28 KHSONG      누락컬럼추가
 * 2019/02/01 JYE       42, 44 추가
 * 2019/02/13 KHSONG      [CSR ID:3912438] 고객군, 판매처 컬럼 정규화 요청의 건
 * 2019/03/22 KHSONG      고객군, 판매처 컬럼 NULL처리조건 추가
 * 2019/04/19 KHSONG      [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가
 * 2019/05/07 KHSONG      [CSR ID:3985608] Biz Type이 없는건은 수량만 zero로 변환요청
 * 2019/07/09 KHSONG      [CSR ID:4034895] GSCM RTF[system] Measure 관련 요청건
 * 2019/09/19 KHSONG      [CSR ID:4082962] Cell Model Info 컬럼추가
 * 2019/10/25 KHSONG      쿼리조건오류 수정반영 & WITH TEMP 조건 용량초과 오류로 일반 TEMP테이블 생성으로 구조 변경함
 * 2020/01/16 HWI1993     COMPANY_ID 추가
 * 2020/01/31 KHSONG      [C20200114-000201] ESS사업부 ENERGE, CELL_QUANTITY 컬럼/Measure추가 & 쿼리내 UNION 줄여서 속도개선
 * 2020/02/18 KHSONG      C20200212-000304 : GSCM 차량대수 환산 오류 개선 요청 건
 * 2020/03/09 KHSONG      C20200303-000078 : DM meausre 추가의 건 / TMM MEASURE 권한추가
 * 2020/03/16 KHSONG      C20200224-000109 Sales Plan Waterfall 미산출 문의건 → Measure 기본값 Setting 로직 추가
 * 2020/04/27 KHSONG      C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
 * 2020/05/20 KHSONG      C20200330-000121 (GSCM Sales Plan Waterfall MKT FCST[R+P] 로직 변경 요청의 건)
 * 2020/07/10 P.C.I     [PJ20200138] Future Price Version_No 구분
 * 2020/07/22 P.C.I     [PJ20200138] Future Price Version_No 구분 원복
 * 2020/07/23 P.C.I     [C20200521-000202] Sales Plan waterfall 실적구간 표시 오류
 * 2020/08/19 P.C.I     [C20200608-000117] 실적구간 Unit Price Measure는 QTY/Sales Amt로 계산
 * 2020/08/12 hwi1993     C20200812-000104 [시스템 변경요청]  Active = 'N' 인 Model 도 조회되도록 변경( 미래구간 & Current 버전 에만 적용 )
 * 2020/09/28 hwi1993     [C20200928-000147][SCM PI팀] ESS 사내거래 ? Sales Plan Waterfall 수정 및 사내거래 포함시 실적구간 PRICE 로직 수정 ( INTERNAL QTY 포함하도록 )
 * 2020/11/25 P.C.I     [C20201125-000012] COMPANY_ID 변경(Site -> Sales Site Project Model)
 * 2021/03/15 P.C.I     [C20210304-000196] 소형 부자재 및 전극 매출 수량 표기(biz_type is null 제외)
 * 2021/06/02 hwi1993     [PJ20209642R] 중장기 싱글플랜
 * 2021/06/23   P.C.I     [PJ20209642R] Sales Price 는 Sum 대신 Avg로 계산
 * 2021/10/22 hwi1993     과제 속도개선 - wf 프로시저 표준화
 * 2021/11/18 kdw2819     [과제] 자동차 사업부 JV Planner 의 조회 권한 추가
 * 2021/11/19 ROSIA27     [C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건
 * 2021/11/24 rosia27     [C20211118-000259] [SCM PI팀] GSCM 시스템 데이터를 마케팅(채권)자료로 활용하기 위한 기능 변경 건
 * 2021/12/07 rosia27     [C20211130-000420][ESS영업관리팀] RTF{R+P] Energy Measure MWh 단위로 수정 요청의 건
 * 2022/03/04   kdw2819     [C20220304-000114] Sales Plan Waterfall 조회 시 Unit Price 누락 건 조치 요청
 * 2022/04/13   HWI1993     GM JV 작업
 * 2022/06/23 kdw2819     [C20220620-000557] GSCM DM 영역내, Version에 주차표기
 * 2022/07/19 kdw2819     [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
 * 2022/12/14 rosia27     [C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
 * 2023/02/02 heesan91    [E20230130-000233] [ESS영업관리팀] Waterfall 화면의 Version 값 주차(Week) 추가 요청의 건
 * 2023/02/14 rosia27     [E20230214-000256] Waterfall화면 Version 추가 로직 변경 요청
 * 2023/04/20   leetw85     [E20230410-000032] Column에 Sold-to, Sold-to Name 데이터 추가의 건
 * 2023/12/19   JSSBAE      [E20231128-000738][마케팅PI] 82번 사업부 SCM.DM 메져별 숫자표기 방식 변경 - Sales Plan, Sales Plan Waterfall
 * 2024/02/01   hmin      [E20240115-000325] Sales Plan Waterfall 화면 조회속도 저하 개선 (테이블 with (nolock) 처리 및 DM_MST_ITEM_SINGLE_V  VIEW -> 테이블 변경처리
 * 2024/02/28 KCW3408     Sales Plan Waterfall 화면 조회속도 저하 개선 (조회 순서 변경)
 * 2024/04/17 KCW3408     이동계획 기타매출 추가 요건(TEXT추가)
 * 2024/05/17   kcw3408     이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가)
 * 2024/06/24   kjj       이동계획 판가 매출 GROUP_ID 화면 표시
 * 2024/08/02   JSSBAE      [E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선
 * 2024/08/26   JSSBAE      [E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼메저 추가
 * 2024/08/13 KJJ       [PJ2024-50461] Team Mapping
 * 2024/09/12 JSSBAE      [E20240920-000300]_SCM.DM 화면 조회 속도 개선
 * 2024/11/04 KJJ       [PJ2024-50611] FCST_type을 하드코딩이 아니라 룩업에서 가져옴
 * 2024/11/15 KANG.H.J    [PJ2024-50611] 소형 매출 프로세스 개선
 * 2024/11/25 KANG.H.J    [PJ2024-50611] 소형 매출 프로세스 개선 (기타매출-ETC FCST 추가. RTF에 없기 때문에 SalesAMT 누락됨)
 * 2024/12/04 KJJ       [PJ2024-50611] Catch Up만 등록 되었을 경우 UNIT PRICE 보이게 수정
 * 2024/12/18 KJJ       [PJ2024-50611] 기타매출, Catch Up 테이블 분리 - 작업중
 * 2025/03/18 dsiol     [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
 * 2025/04/23 dsiol     [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : SCM_FCST - MEASURE 추가
 * 2025/04/29   JSSBAE      [E20250423-000842]_[공급생산 SCM PI팀] Sales Plan 화면 'SCP Use' 칼럼 추가
 * 2025/05/21   JSSBAE      [E20250520-000574]_SALES PLAN, SALES PLAN WATERFALL UI의 RTF_PR Measure 조회 로직 변경
 * 2025/06/02   kjiyoon     [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청
 * 2025/06/02 kjiyoon     [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : (HSJ20250528) 소형 외 사업부 CELL_PROD_SITE_ID 치환 로직 추가
 * 2025/06/24 JSSBAE      [E20250529-001488]_Sales Plan Waterfall 데이터 조회 로직 개선
 * 2025/07/07 KANG.H.J    [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가

 select @p_division_id='81', @p_dept_id='ALL', @p_end_customer='ALL', @p_scm_site_id='Volvo_SE_GOT', @p_project_code='', @p_item_id='APVCC519H-A1-000', @p_item_type='ALL',

 *===================================================================================================================================================
   EXEC DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL_KJJ @p_division_id='40', @p_dept_id='ALL', @p_end_customer='ALL'
   , @p_scm_site_id='ALL', @p_project_code='', @p_item_id='', @p_item_type='ALL', @p_from_yyyymmdd='20241101'
   , @p_now_yyyymmdd='20241111', @p_to_yyyymmdd='20250430', @p_created_by='kjj0070', @p_plant_site_id='ALL'
   , @p_biztype='ALL', @p_version_type='SP_W_20241119_V001(W47)', @p_owner='', @p_internal_yn='N', @p_cell_yn='N'
   , @p_bucket='MONTHLY', @p_user_dept_id='ICT', @p_group_id='ADMIN'
 */
AS
    v_program_id    VARCHAR2(50  CHAR) := 'DMF0035';  --[E20260909-TYPEAXIS] SHEET_COLUMNS/SHEET_MEASURE/TITLESET 축 = PROGRAM_ID 'DMF0035' + AS-IS 실등록 시트명 (사용자 지시 2026-09-09). PKG 명은 유지.
    v_sheet_name    VARCHAR2(50  CHAR) := 'Sales Plan Waterfall';  --[E20260909-TYPEAXIS] SHEET_COLUMNS/SHEET_MEASURE/TITLESET 축 = PROGRAM_ID 'DMF0035' + AS-IS 실등록 시트명 (사용자 지시 2026-09-09). PKG 명은 유지.
    v_measure_sheet VARCHAR2(50 CHAR) := 'Sales Plan Waterfall';  --[E20260806-WF] SHEET_MEASURE 실등록명(AS-IS) — TITLESET(FE명)과 상이, 데이터 무수정 정합
    --DECLARE @VERSION_NO NVARCHAR(50); --[E20250529-001488]_사용안하는 변수로 확인되어 주석처리

    v_ColList       VARCHAR2(32767 CHAR) := '';
    v_OrderList     VARCHAR2(32767 CHAR) := '';
    --v_Prod          VARCHAR2(32767 CHAR) := '';
    --v_MEASURE       PLS_INTEGER := 0;
    i_count         PLS_INTEGER := 0;
    v_user_mea_cnt  PLS_INTEGER := 0;  -- 20200316 KHSONG C20200224-000109

    -----------------------------------------------------------------------------------------------------------------------------------
    -- 20200306 KHSONG 조회시작기간이 START DATE가 아닌경우 PRICE값을 가져오지 못하여 변수추가사용
    -----------------------------------------------------------------------------------------------------------------------------------
    v_start_yyyymmdd    VARCHAR2(8 CHAR);

    -- Dynamic SQL 변수
    v_sql_text          VARCHAR2(32767 CHAR);
    --v_nsql              VARCHAR2(32767 CHAR);
    --v_nsql2             VARCHAR2(32767 CHAR);
    V_PV_LIST           VARCHAR2(32767 CHAR);
    V_PV_COL_LIST       VARCHAR2(32767 CHAR);
    --v_sort_order_no     VARCHAR2(50    CHAR);
    --v_PV_column_name    VARCHAR2(100   CHAR);
    --v_PV_name           VARCHAR2(50    CHAR);
    --v_column_name       VARCHAR2(100   CHAR);
    --v_column            VARCHAR2(32767 CHAR);
    --v_orderby           VARCHAR2(32767 CHAR);
    --v_column_text       VARCHAR2(32767 CHAR);
    --v_column_type       VARCHAR2(50    CHAR);
    --v_column_value      VARCHAR2(50    CHAR);
    --v_sum_qty           VARCHAR2(32767 CHAR);  -- [E20230619-000151] GSCM.DM 소수점 표기 방식 변경
    --v_qty_div           VARCHAR2(32767 CHAR);  -- [E20230619-000151] GSCM.DM 소수점 표기 방식 변경
    --v_avg_qty           VARCHAR2(32767 CHAR);  -- [E20230619-000151] GSCM.DM 소수점 표기 방식 변경
    V_SQL_SELECT        VARCHAR2(32767 CHAR);
    V_SQL_GROUPBY       VARCHAR2(32767 CHAR);
    v_I                 PLS_INTEGER;
    v_CNT               PLS_INTEGER;

    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100  CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
    n_log_count         PLS_INTEGER := 0;
    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := $$PLSQL_UNIT;

    v_exists            PLS_INTEGER;

BEGIN
    --[E20260820-DS2] GT/GTT 사용 SP 표준 — 클라우드 optimizer_dynamic_sampling=0 방어
    --  통계 없는 GTT 가 카디널리티 1 로 추정되어 NL 이 선택되면 대용량 표를 행 단위로 훑는다
    --  (클라우드 실측: GT_DM35_T_LAST_SETUP_C 적재문 1,302초/회, cell single block read).
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;
    -- GTT 세션 통계 설정
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_V_VERSION_NO',              'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_SELECT_MEASURE',            'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_SCM_MST_SHEET_MEASURE',     'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_PROGRAM_ADD_MEASURE',       'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_RAW_DATA',                  'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_RAW_DATA_TEMP40',           'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_RAW_DATA_TEMP40_KEY',       'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_RTF_ENERGY',                'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_SCM_MST_SITE_ITEM',         'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_T_PRICE',                   'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_T_COLUMN_SETUP',            'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_T',                         'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_CALENDAR',                  'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_SCM_MST_SITE',              'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_ORI_V',  'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_A_V',    'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_B_V',    'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_V',      'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_V_T',    'GLOBAL_TEMP_TABLE_STATS','SESSION');

    -- ON COMMIT PRESERVE ROWS GTT TRUNCATE
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_V_VERSION_NO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_SELECT_MEASURE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_SCM_MST_SHEET_MEASURE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_PROGRAM_ADD_MEASURE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_RAW_DATA';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_RAW_DATA_TEMP40';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_RAW_DATA_TEMP40_KEY';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_RTF_ENERGY';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_SCM_MST_SITE_ITEM';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_T_PRICE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_T_COLUMN_SETUP';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_T';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_CALENDAR';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_SCM_MST_SITE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_ORI_V';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_A_V';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_B_V';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V_T';

    --EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

    -----------------------------------------------------------------------------------------------------------------------------------
    -- 20200306 KHSONG 조회시작기간이 START DATE가 아닌경우 PRICE값을 가져오지 못하여 변수추가사용
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT BASIS_START_DATE
      INTO v_start_yyyymmdd
      FROM SCM_MGR.SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMMDD = P_FROM_YYYYMMDD;

    -----------------------------------------------------------------------------------------------------------------------------------
    --[E20250529-001488]_화면에서 버전을 넘길때 주차까지 넘겨주기때문에, 아예 버전만 변수로 테이블에 받아서 생성한다. START
    -----------------------------------------------------------------------------------------------------------------------------------
    INSERT /*+ NO_PARALLEL */ INTO SCM_MGR.GT_DM22_V_VERSION_NO
        (VERSION_NO, TOBE_VERSION_NO)
    SELECT TRIM(CASE WHEN INSTR(TOKEN, '(') = 0
                     THEN TOKEN
                     ELSE SUBSTR(TOKEN, 1, INSTR(TOKEN, '(') - 1)
                END) AS VERSION_NO,
           NULL AS TOBE_VERSION_NO
      FROM (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_VERSION_TYPE,',')) P)
    ;
    -----------------------------------------------------------------------------------------------------------------------------------
    --[E20250529-001488]_화면에서 버전을 넘길때 주차까지 넘겨주기때문에, 아예 버전만 변수로 테이블에 받아서 생성한다. END
    -----------------------------------------------------------------------------------------------------------------------------------

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A001--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    -----------------------------------------------------------------------------------------------------------------------------------
    -- 20200316 KHSONG C20200224-000109 START
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*)
      INTO v_user_mea_cnt
      FROM SCM_MGR.SCM_MST_TITLESET_USER U
     WHERE U.PROGRAM_ID                     = v_program_id
       AND U.SHEET_NAME                     = v_sheet_name
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE  = 'M'
       AND U.USER_ID                        = P_CREATED_BY;

    IF v_user_mea_cnt = 0 THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
            (USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG,
             DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        SELECT P_CREATED_BY AS USER_ID, C.PROGRAM_ID, v_sheet_name, 'M' AS USER_INQUIRY_COLUMN_TYPE_CODE,
               C.COLUMN_NAME, C.SORT_ORDER_NO, 'N' AS SUB_TOTAL_FLAG,
               '' AS DATA_SORT_METHOD_CODE, P_CREATED_BY AS CREATED_BY,
               SYSDATE AS CREATION_DATE,
               P_CREATED_BY AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
          FROM SCM_MGR.SCM_MST_SHEET_MEASURE C
         WHERE C.PROGRAM_ID   = v_program_id
           AND C.SHEET_NAME   = v_measure_sheet
           AND C.DEFAULT_FLAG = 'Y'
           AND C.VALID_YN     = 'Y';
    END IF;
    -----------------------------------------------------------------------------------------------------------------------------------
    -- 20200316 KHSONG C20200224-000109 END
    -----------------------------------------------------------------------------------------------------------------------------------

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A003--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    -----------------------------------------------------------------------------------------------------------------------------------
    -- [E20250520-000574]_사업부와 사용여부에 따라서 데이터를 가지고 올수있도록 수정 START
    -----------------------------------------------------------------------------------------------------------------------------------
    -- USER TITLE 정보와 MEASURE MASTER 정보를 JOIN하여 사업부별 정보를 보관한다.
    INSERT /*+ NO_PARALLEL */ INTO GT_DM22_SCM_MST_SHEET_MEASURE
        (USER_ID, MEASURE, SORT_ORDER_NO, SYSTEM_ADD, DIVISION_ID)
    SELECT t.user_id, t.measure, t.sort_order_no, t.system_add, t.division_id
    FROM (
          SELECT a.user_id, a.measure, a.sort_order_no, a.system_add, TRIM(REGEXP_SUBSTR(a.division_id, '[^,]+', 1, lv.lvl)) AS division_id
          FROM (
                SELECT
                    u.user_id,
                    u.column_name     AS measure,
                    u.sort_order_no,
                    b.division_id,
                    'N'               AS system_add
                FROM SCM_MGR.SCM_MST_TITLESET_USER    u
                INNER JOIN scm_mst_sheet_measure   b
                    ON  u.program_id    = b.program_id
                    AND b.sheet_name    = v_measure_sheet
                    AND u.column_name   = b.column_name
                WHERE u.program_id                    = v_program_id
                  AND u.sheet_name                    = v_sheet_name
                  AND u.user_inquiry_column_type_code = 'M'
                  AND u.user_id                       = p_created_by
                  AND b.valid_yn                      = 'Y'
               ) a
              -- MSSQL STRING_SPLIT → CONNECT BY LEVEL + REGEXP_SUBSTR
              CROSS JOIN (
                  SELECT LEVEL AS lvl
                  FROM DUAL
                  CONNECT BY LEVEL <= (
                      SELECT MAX(REGEXP_COUNT(b2.division_id, ',') + 1)
                      FROM SCM_MGR.SCM_MST_SHEET_MEASURE b2
                      WHERE b2.program_id = v_program_id
                        AND b2.sheet_name = v_measure_sheet
                        AND b2.valid_yn   = 'Y'
                  )
              ) lv
          WHERE REGEXP_SUBSTR(a.division_id, '[^,]+', 1, lv.lvl) IS NOT NULL
    ) t
    WHERE t.division_id = p_division_id;

    /* 과거 쿼리는 주석처리 한다.
    SELECT DISTINCT U.COLUMN_NAME AS MEASURE, U.SORT_ORDER_NO, 'N' AS SYSTEM_ADD
    INTO GT_DM22_SELECT_MEASURE
    FROM SCM_MST_TITLESET_USER U
    LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T
           ON U.USER_ID    = T.SEGMENT4 -- 20200309 KHSONG TMM MEASURE 권한추가
           AND P_CREATED_BY = T.SEGMENT4 -- USER_ID
           AND T.LOOKUP_TYPE = 'TMM_MEASURE_ADMIN'
           AND T.VALID_YN   = 'Y'        -- VALID_YN 여부
    WHERE 1 = 1
    AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND U.PROGRAM_ID   = v_program_id
    AND U.USER_ID      = P_CREATED_BY
    and U.USER_ID = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4 ELSE P_CREATED_BY END -- 20200309 KHSONG TMM MEASURE 권한추가
    */

    INSERT /*+ NO_PARALLEL */ INTO GT_DM22_SELECT_MEASURE
        (MEASURE, SORT_ORDER_NO, SYSTEM_ADD)
    SELECT DISTINCT U.MEASURE, U.SORT_ORDER_NO, U.SYSTEM_ADD
      FROM SCM_MGR.GT_DM22_SCM_MST_SHEET_MEASURE U
      LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL T
             ON U.USER_ID     = T.SEGMENT4  -- 20200309 KHSONG TMM MEASURE 권한추가
            AND P_CREATED_BY  = T.SEGMENT4  -- USER_ID
            AND T.LOOKUP_TYPE = 'TMM_MEASURE_ADMIN'
            AND T.VALID_YN    = 'Y'         -- VALID_YN 여부
     WHERE U.USER_ID = CASE WHEN U.MEASURE = 'TMM_FCST' THEN T.SEGMENT4 ELSE P_CREATED_BY END;
    -----------------------------------------------------------------------------------------------------------------------------------
    -- [E20250520-000574]_사업부와 사용여부에 따라서 데이터를 가지고 올수있도록 수정 END
    -----------------------------------------------------------------------------------------------------------------------------------

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A004--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

  -----------------------------------------------------------------------------------------------------------------------------------
  --[E20250529-001488]_MEASURE 추가할때마다 하드코딩으로 메져 추가하는 작업을 방지하기 위해 룩업으로 변경 원소스 주석처리 START
  -----------------------------------------------------------------------------------------------------------------------------------
  /*
  -----------------------------------------------------------------------------------------------------------------------------------
  -- 하단에서 실적구간의 Price 를 구하기 위해서 RTF_SYS_RP 와 SalesAmt_KRW, LOC 를 추가해준다.  START
  -----------------------------------------------------------------------------------------------------------------------------------
  IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE IN ( 'LOC', 'KRW' ))
  BEGIN
    INSERT INTO #SELECT_MEASURE
    ( MEASURE, SYSTEM_ADD )
    SELECT A.MEASURE, 'Y'
    FROM (  SELECT 'RTF_SYS_RP' AS MEASURE
        UNION ALL
        SELECT 'SALESAMT_KRW' AS MEASURE
        UNION ALL
        SELECT 'SALESAMT_LOC' AS MEASURE ) A
    LEFT OUTER JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
    WHERE B.MEASURE IS NULL
  END
  -----------------------------------------------------------------------------------------------------------------------------------
  -- 하단에서 실적구간의 Price 를 구하기 위해서 RTF_SYS_RP 와 SalesAmt_KRW, LOC 를 추가해준다.  END
  -----------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------
  -- MKT_FCST, RTF_SYS_RP로 MKT_FCST_RP를 만들기 위해 추가해준다.  START
  -----------------------------------------------------------------------------------------------------------------------------------
  IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE IN ( 'MKT_FCST_RP' ))
  BEGIN
    INSERT INTO #SELECT_MEASURE
    ( MEASURE, SYSTEM_ADD )
    SELECT A.MEASURE, 'Y'
    FROM (  SELECT 'MKT_FCST' AS MEASURE
        UNION ALL
        SELECT 'RTF_SYS_RP' AS MEASURE ) A
    LEFT OUTER JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
    WHERE B.MEASURE IS NULL
  END
  -----------------------------------------------------------------------------------------------------------------------------------
  -- MKT_FCST, RTF_SYS_RP로 MKT_FCST_RP를 만들기 위해 추가해준다.  END
  -----------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------
  --[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청 START
  -- 하단에서 실적구간의 RTF_PR 를 구하기 위해서 RTF_SYS_RP 를 추가해준다.
  -----------------------------------------------------------------------------------------------------------------------------------
  IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'RTF_PR' )
  BEGIN
    INSERT INTO #SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
    SELECT A.MEASURE, 'Y'
    FROM ( SELECT 'RTF_SYS_RP' AS MEASURE ) A
    LEFT OUTER JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
    WHERE B.MEASURE IS NULL
  END
  -----------------------------------------------------------------------------------------------------------------------------------
  --[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청 END
  -----------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------
  -- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청
  -- SCM_FCST 메저의 실적구간은 RTF_SYS_RP 를 가져와 보여주도록 한다.
  -----------------------------------------------------------------------------------------------------------------------------------
  IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE IN ( 'SCM_FCST' ))
  BEGIN
    INSERT INTO #SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
    SELECT A.MEASURE, 'Y'
    FROM (  SELECT 'RTF_SYS_RP' AS MEASURE) A
    LEFT OUTER JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
    WHERE B.MEASURE IS NULL
  END */

    INSERT /*+ NO_PARALLEL */ INTO GT_DM22_PROGRAM_ADD_MEASURE
        (UI_MEASURE, DB_MEASURE, PLAN_RESULT, SYSTEM_ADD)
    SELECT T.UI_MEASURE, T.DB_MEASURE, T.PLAN_RESULT, 'Y' AS SYSTEM_ADD
      FROM (
               SELECT A.COLUMN_NAME AS UI_MEASURE, TOKEN AS DB_MEASURE, PLAN_RESULT
                 FROM (
                          SELECT COLUMN_NAME,
                                 NVL(REPLACE(ATTRIBUTE5, ' ', ''), '') AS ATTRIBUTE5,
                                 CASE WHEN NVL(REPLACE(ATTRIBUTE5, ' ', ''), '@#@#@#') <> '@#@#@#' AND ATTRIBUTE7 = 'Y' THEN 'R'
                                      ELSE '' END AS PLAN_RESULT
                            FROM SCM_MGR.SCM_MST_SHEET_MEASURE
                           WHERE PROGRAM_ID = v_program_id
                             AND SHEET_NAME = v_measure_sheet
                             AND VALID_YN   = 'Y'
                             AND NVL(REPLACE(ATTRIBUTE5, ' ', ''), '@#@#@#') <> '@#@#@#'
                      ) A
               CROSS JOIN LATERAL (
                   SELECT TRIM(REGEXP_SUBSTR(A.ATTRIBUTE5, '[^,]+', 1, LEVEL)) AS TOKEN
                     FROM DUAL
                   CONNECT BY REGEXP_SUBSTR(A.ATTRIBUTE5, '[^,]+', 1, LEVEL) IS NOT NULL
               )
               UNION ALL
               SELECT A.COLUMN_NAME AS UI_MEASURE, TOKEN AS DB_MEASURE, PLAN_RESULT
                 FROM (
                          SELECT COLUMN_NAME,
                                 NVL(REPLACE(ATTRIBUTE6, ' ', ''), '') AS ATTRIBUTE6,
                                 CASE WHEN NVL(REPLACE(ATTRIBUTE6, ' ', ''), '@#@#@#') <> '@#@#@#' AND ATTRIBUTE7 = 'Y' THEN 'P'
                                      ELSE '' END AS PLAN_RESULT
                            FROM SCM_MGR.SCM_MST_SHEET_MEASURE
                           WHERE PROGRAM_ID = v_program_id
                             AND SHEET_NAME = v_measure_sheet
                             AND VALID_YN   = 'Y'
                             AND NVL(REPLACE(ATTRIBUTE6, ' ', ''), '@#@#@#') <> '@#@#@#'
                      ) A
               CROSS JOIN LATERAL (
                   SELECT TRIM(REGEXP_SUBSTR(A.ATTRIBUTE6, '[^,]+', 1, LEVEL)) AS TOKEN
                     FROM DUAL
                   CONNECT BY REGEXP_SUBSTR(A.ATTRIBUTE6, '[^,]+', 1, LEVEL) IS NOT NULL
               )
           ) T;

    SELECT COUNT(*)
      INTO v_exists
      FROM SCM_MGR.GT_DM22_PROGRAM_ADD_MEASURE A
     INNER JOIN GT_DM22_SELECT_MEASURE B ON A.UI_MEASURE = B.MEASURE
     WHERE ROWNUM = 1;

    IF v_exists > 0 THEN
        INSERT /*+ NO_PARALLEL */ INTO SCM_MGR.GT_DM22_SELECT_MEASURE
            (MEASURE, SYSTEM_ADD)
        SELECT A.DB_MEASURE AS MEASURE, A.SYSTEM_ADD
          FROM SCM_MGR.GT_DM22_PROGRAM_ADD_MEASURE A
          LEFT OUTER JOIN GT_DM22_SELECT_MEASURE B ON A.DB_MEASURE = B.MEASURE
         WHERE B.MEASURE IS NULL
         GROUP BY A.DB_MEASURE, A.SYSTEM_ADD;
    END IF;

    -----------------------------------------------------------------------------------------------------------------------------------
    --[E20250529-001488]_MEASURE 추가할때마다 하드코딩으로 메져 추가하는 작업을 방지하기 위해 룩업으로 변경 원소스 주석처리 END
    -----------------------------------------------------------------------------------------------------------------------------------
    --[E20250529-001488]_신규로 생성한 메져 사용하기 여러 분기쳐서 동일한 쿼리를 사용할 필요가 없는 것으로 확인되어 기존 소스 주석처리하고 해당 부분으로 변경 END
    -----------------------------------------------------------------------------------------------------------------------------------

    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_SELECT_MEASURE',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);
    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_PROGRAM_ADD_MEASURE',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);
    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_V_VERSION_NO',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A005--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    -- ----------------------------------------------------------------
    -- CURRENT 구간 데이터 적재
	  -- 계획구간: [FCST_TYPE: ETC외] DM_PLN_SALES_PLAN / [FCST_TYPE: ETC] DM_PLN_SALES_ETC_PLAN / 실적구간: DM_PLN_SALES_PLAN_RESULT
    -- ----------------------------------------------------------------
    IF UPPER(P_VERSION_TYPE) LIKE '%CURRENT%' THEN  --[E20260831-VERCASE] MSSQL CI 콜레이션 1:1 — 'Current' 등 대소문자 변형 흡수
        INSERT /*+ NO_PARALLEL */ INTO GT_DM22_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
             TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE,
             YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
        -- 계획구간 [FCST_TYPE: ETC외] DM_PLN_SALES_PLAN
        SELECT 'CURRENT', NULL, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, PLANT_SITE_ID, A.ITEM_ID,
               NVL(A.ATTRIBUTE9, '') AS TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, NULL, A.MEASURE,
               A.YYYYMMDD, A.QTY, 'P' AS PLAN_RESULT,
               CASE WHEN A.DIVISION_ID = '40' THEN A.CELL_PROD_SITE_ID ELSE '-' END
          FROM SCM_MGR.DM_PLN_SALES_PLAN A
          JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
          JOIN SCM_MGR.SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
         WHERE A.YYYYMMDD   >= P_NOW_YYYYMMDD AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.QTY        <> 0
           AND A.FCST_TYPE NOT IN (SELECT DISTINCT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                    WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                      AND VALID_YN = 'Y' AND SEGMENT1 = A.DIVISION_ID)
           AND A.ITEM_ID   NOT IN (SELECT DISTINCT SEGMENT3 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                    WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                      AND VALID_YN = 'Y' AND SEGMENT1 = A.DIVISION_ID)
           AND A.MEASURE   NOT IN (SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                    WHERE LOOKUP_TYPE = 'SALES_PLAN_CATCHUP' AND VALID_YN = 'Y')
        UNION ALL
        -- [PJ2024-50611] 기타매출 DM_PLN_SALES_ETC_PLAN
        SELECT 'CURRENT', NULL, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, PLANT_SITE_ID, A.ITEM_ID,
               A.REMARK_TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, NULL, A.MEASURE,
               A.YYYYMMDD, A.QTY, 'P', '-'
          FROM SCM_MGR.DM_PLN_SALES_ETC_PLAN A
          JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
          JOIN SCM_MGR.SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
         WHERE A.YYYYMMDD   >= P_NOW_YYYYMMDD AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.QTY        <> 0
        UNION ALL
        -- 실적구간 DM_PLN_SALES_PLAN_RESULT
        SELECT 'CURRENT', NULL, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, PLANT_SITE_ID, A.ITEM_ID,
               NVL(A.ATTRIBUTE9, ''), A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE,
               A.YYYYMMDD,
               A.QTY + CASE WHEN P_INTERNAL_YN = 'Y' AND P_DIVISION_ID = '82'
                                  AND REGEXP_LIKE(A.ATTRIBUTE2, '^\d+(\.\d+)?$')
                             THEN TO_NUMBER(A.ATTRIBUTE2) ELSE 0 END AS QTY,
               'R' AS PLAN_RESULT,
               A.CELL_PROD_SITE_ID
          FROM SCM_MGR.DM_PLN_SALES_PLAN_RESULT A
          JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
         WHERE A.YYYYMMDD   >= P_FROM_YYYYMMDD AND A.YYYYMMDD < P_NOW_YYYYMMDD
           AND A.DIVISION_ID = P_DIVISION_ID
           AND (A.QTY <> 0 OR (NVL(A.ATTRIBUTE2, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(A.ATTRIBUTE2, '^\d+(\.\d+)?$')))
           AND A.MEASURE NOT IN ('RTF_PR'); --[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은 RTF_SYS_RP 가져오도록 요청


    END IF;

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A006--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

   	-----------------------------------------------------------------------------------------------------------------------------------
	  -- CUTOFF 데이터
	  -- 계획구간: [FCST_TYPE: ETC외] DM_PLN_SALES_PLAN_C / [FCST_TYPE: ETC] DM_PLN_SALES_ETC_PLAN_C / 실적구간: DM_PLN_SALES_PLAN_RESULT_C
	  -----------------------------------------------------------------------------------------------------------------------------------


    IF p_version_type LIKE '%SP_%' THEN
        INSERT /*+ NO_PARALLEL */ INTO SCM_MGR.GT_DM22_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
             TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE,
             YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
        --[E20250529-001488]_버전은 테이블에서 가지고온 순수 데이터로 조회한다 START
        /*SELECT CASE WHEN @p_division_id ='82' AND E.DM_RTF_YN = 'N' THEN CONCAT(A.VERSION_NO , '(',D.WEEK_NAME,') (NO PLAN)')
              WHEN @p_division_id ='82' THEN CONCAT(A.VERSION_NO , '(',D.WEEK_NAME,')')
              ELSE A.VERSION_NO END AS  VERSION_NO  -- [E20230130-000233] */
        SELECT A.VERSION_NO
               --[E20250529-001488]_버전은 테이블에서 가지고온 순수 데이터로 조회한다 END
               , A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
               NVL(A.ATTRIBUTE9, ''), A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, NULL AS COMPANY_ID, A.MEASURE,
               A.YYYYMMDD, A.QTY, 'P' AS PLAN_RESULT,
               CASE WHEN A.DIVISION_ID = '40' THEN A.CELL_PROD_SITE_ID ELSE '-' END -- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : (HSJ20250528) 소형 외 사업부 CELL_PROD_SITE_ID 치환 로직 추가
          FROM SCM_MGR.DM_PLN_SALES_PLAN_C A
          JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
	       	--[E20250529-001488]_버전은 위에서 만들어온 테이블에서 사용한 버전을 사용한다.
          JOIN SCM_MGR.GT_DM22_V_VERSION_NO D ON A.VERSION_NO = D.VERSION_NO
          JOIN SCM_MGR.SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
          --LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM D ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'
          --[E20250529-001488]_버전을 가공하지 않을것이므로, 하단의 내용은 필요하지 않으므로 주석처리 한다 START
          /* INNER JOIN SCM_SYS_CALENDAR_M D WITH(NOLOCK) ON A.CUTOFF_YYYYMMDD = D.BASIS_YYYYMMDD  --[E20230130-000233] --[E20240115-000325] WITH(NOLOCK) 처리
          LEFT JOIN SCP_PLN_INTERFACE_YN E WITH(NOLOCK)
               ON A.DIVISION_ID     = E.DIVISION_ID
              AND D.BASIS_START_DATE  = E.PLAN_START_YYYYMMDD --[E20230130-000233]  */
          --[E20250529-001488]_버전을 가공하지 않을것이므로, 하단의 내용은 필요하지 않으므로 주석처리 한다 END
         WHERE A.YYYYMMDD   >= P_FROM_YYYYMMDD AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.QTY        <> 0
           --[E20250529-001488]_버전은 위에서 만들어온 테이블에서 사용한 버전을 사용한다.
           --AND A.VERSION_NO IN (SELECT LEFT(token, CASE WHEN CHARINDEX('(',token) = 0 THEN LEN(token) ELSE CHARINDEX('(',token)-1 END ) FROM dbo.String_Split(@p_version_type ,','))
           --마이그레이션 된 데이터 지우면 조건삭제
           AND A.FCST_TYPE NOT IN (SELECT DISTINCT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                    WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                      AND VALID_YN = 'Y' AND SEGMENT1 = A.DIVISION_ID)
           AND A.ITEM_ID   NOT IN (SELECT DISTINCT SEGMENT3 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                    WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                      AND VALID_YN = 'Y' AND SEGMENT1 = A.DIVISION_ID)
           AND A.MEASURE   NOT IN (SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                    WHERE LOOKUP_TYPE = 'SALES_PLAN_CATCHUP' AND VALID_YN = 'Y')
        -----------------------------------------------------------------------------------------------------------------------------------
        --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 START
        -----------------------------------------------------------------------------------------------------------------------------------
        UNION ALL
        --[E20250529-001488]_버전은 테이블에서 가지고온 순수 데이터로 조회한다 START
        /*SELECT CASE WHEN @p_division_id ='82' AND  E.DM_RTF_YN = 'N'  THEN CONCAT(A.VERSION_NO , '(',D.WEEK_NAME,') (NO PLAN)')
              WHEN @p_division_id ='82' THEN CONCAT(A.VERSION_NO , '(',D.WEEK_NAME,')')
              ELSE A.VERSION_NO END AS  VERSION_NO  -- [E20230130-000233]  */
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, PLANT_SITE_ID, A.ITEM_ID,
               A.REMARK_TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, NULL  AS COMPANY_ID, A.MEASURE,
               A.YYYYMMDD, A.QTY, 'P' AS PLAN_RESULT, '-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
          FROM SCM_MGR.DM_PLN_SALES_ETC_PLAN_C A
          JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		      --[E20250529-001488]_버전은 위에서 만들어온 테이블에서 사용한 버전을 사용한다.
          JOIN SCM_MGR.GT_DM22_V_VERSION_NO D ON A.VERSION_NO = D.VERSION_NO
          JOIN SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
          --LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM D ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'
          --[E20250529-001488]_버전을 가공하지 않을것이므로, 하단의 내용은 필요하지 않으므로 주석처리 한다 START
          /* INNER JOIN SCM_SYS_CALENDAR_M D WITH(NOLOCK) ON A.CUTOFF_YYYYMMDD = D.BASIS_YYYYMMDD  --[E20230130-000233] --[E20240115-000325] WITH(NOLOCK) 처리
          LEFT JOIN SCP_PLN_INTERFACE_YN E WITH(NOLOCK)
               ON A.DIVISION_ID     = E.DIVISION_ID
              AND D.BASIS_START_DATE  = E.PLAN_START_YYYYMMDD --[E20230130-000233] */
          --[E20250529-001488]_버전을 가공하지 않을것이므로, 하단의 내용은 필요하지 않으므로 주석처리 한다 END
         WHERE A.YYYYMMDD   >= P_FROM_YYYYMMDD AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.QTY        <> 0
        --[E20250529-001488]_버전은 위에서 만들어온 테이블에서 사용한 버전을 사용한다.
        --AND A.VERSION_NO IN (SELECT LEFT(token,  CASE WHEN CHARINDEX('(',token) = 0 THEN LEN(token) ELSE CHARINDEX('(',token)-1 END ) FROM dbo.String_Split(@p_version_type ,','))
        -----------------------------------------------------------------------------------------------------------------------------------
        --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 END
        -----------------------------------------------------------------------------------------------------------------------------------
        UNION ALL
        --[E20250529-001488]_버전은 테이블에서 가지고온 순수 데이터로 조회한다 START
        /*SELECT CASE WHEN @p_division_id ='82' AND  E.DM_RTF_YN = 'N'  THEN CONCAT(A.VERSION_NO , '(',D.WEEK_NAME,') (NO PLAN)')
              WHEN @p_division_id ='82' THEN CONCAT(A.VERSION_NO , '(',D.WEEK_NAME,')')
              ELSE A.VERSION_NO END AS  VERSION_NO  --[E20230130-000233]  */
        SELECT A.VERSION_NO
		    --[E20250529-001488]_버전은 테이블에서 가지고온 순수 데이터로 조회한다 END
               , A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
               NVL(A.ATTRIBUTE9, ''), A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE,
               A.YYYYMMDD,
               A.QTY + CASE WHEN P_INTERNAL_YN = 'Y' AND P_DIVISION_ID = '82'
                                  AND REGEXP_LIKE(A.ATTRIBUTE2, '^\d+(\.\d+)?$')
                             THEN TO_NUMBER(A.ATTRIBUTE2) ELSE 0 END,
               'R' AS PLAN_RESULT
                 --,'-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
               , A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
          FROM SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
          JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
      		--[E20250529-001488]_버전은 위에서 만들어온 테이블에서 사용한 버전을 사용한다.
          JOIN SCM_MGR.GT_DM22_V_VERSION_NO D ON A.VERSION_NO = D.VERSION_NO
          -- [C20220304-000114] Sales Plan Waterfall 조회 시 Unit Price 누락 건 조치 요청
          --[E20250529-001488]_버전을 가공하지 않을것이므로, 하단의 내용은 필요하지 않으므로 주석처리 한다 START
          /* INNER JOIN SCM_SYS_CALENDAR_M D WITH(NOLOCK) ON A.CUTOFF_YYYYMMDD = D.BASIS_YYYYMMDD  --[E20230130-000233]  [E20240115-000325] WITH (NOLOCK) 처리
          LEFT JOIN SCP_PLN_INTERFACE_YN E WITH(NOLOCK)
               ON A.DIVISION_ID     = E.DIVISION_ID
              AND D.BASIS_START_DATE  = E.PLAN_START_YYYYMMDD --[E20230130-000233] */
          --[E20250529-001488]_버전을 가공하지 않을것이므로, 하단의 내용은 필요하지 않으므로 주석처리 한다 END
         WHERE A.YYYYMMDD   >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD   < TO_CHAR(FN_NEXT_DAY(TO_DATE(A.CUTOFF_YYYYMMDD, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
           AND A.DIVISION_ID = P_DIVISION_ID
           AND (A.QTY <> 0 OR (NVL(A.ATTRIBUTE2, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(A.ATTRIBUTE2, '^\d+(\.\d+)?$'))) -- [C20200928-000147]
          --[E20250529-001488]_버전은 위에서 만들어온 테이블에서 사용한 버전을 사용한다. 원소스는 주석처리 한다
          --AND A.VERSION_NO IN (SELECT LEFT(token, CASE WHEN CHARINDEX('(',token) = 0 THEN LEN(token) ELSE CHARINDEX('(',token)-1 END) FROM dbo.String_Split(@p_version_type ,','))
           AND A.MEASURE NOT IN ('RTF_PR');  --[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청


    END IF;

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A007--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));
  -----------------------------------------------------------------------------------------------------------------------------------
  --[E20250529-001488]_신규로 생성한 메져 사용하기 여러 분기쳐서 동일한 쿼리를 사용할 필요가 없는 것으로 확인되어 기존 소스 주석처리하고 해당 부분으로 변경 START
  -----------------------------------------------------------------------------------------------------------------------------------
  /*
  IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'MKT_FCST_RP')
  BEGIN
    INSERT INTO #RAW_DATA
    ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
    , TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
    , YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
    SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
       , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'MKT_FCST_RP' AS MEASURE
       , A.YYYYMMDD, A.QTY, A.PLAN_RESULT, A.CELL_PROD_SITE_ID  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
    FROM #RAW_DATA A  WITH(NOLOCK)
    WHERE A.MEASURE = 'MKT_FCST'
    AND A.YYYYMMDD >=  CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd
                ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)
                END -- [C20200521-000202] Version cutoff 기준으로 MKT_FCST 조회
    AND A.YYYYMMDD <= @p_to_yyyymmdd

    INSERT INTO #RAW_DATA
    ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
    , TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
    , YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
    SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
       , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'MKT_FCST_RP' AS MEASURE
       , A.YYYYMMDD, A.QTY, A.PLAN_RESULT, A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
    FROM #RAW_DATA A WITH(NOLOCK)
    WHERE MEASURE = 'RTF_SYS_RP'
    AND A.YYYYMMDD >= @p_from_yyyymmdd
    AND A.YYYYMMDD <   CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd
                ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)
               END -- [C20200521-000202] Version cutoff 기준으로 RTF 조회
  END
  -----------------------------------------------------------------------------------------------------------------------------------
  --[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청 START
  -----------------------------------------------------------------------------------------------------------------------------------
  IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'RTF_PR')
  BEGIN
    INSERT INTO #RAW_DATA
    ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
    , TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
    , YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
    SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
       , TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, 'RTF_PR' AS MEASURE
       , YYYYMMDD, QTY, PLAN_RESULT, A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
    FROM #RAW_DATA A WITH(NOLOCK)
    WHERE MEASURE = 'RTF_SYS_RP'
    AND A.YYYYMMDD >= @p_from_yyyymmdd
    AND A.YYYYMMDD <  CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd
                 ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)
              END -- [C20200521-000202] Version cutoff 기준으로 RTF 조회

  END
  -----------------------------------------------------------------------------------------------------------------------------------
  --[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청 END
  -----------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------
  -- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청 START
  -----------------------------------------------------------------------------------------------------------------------------------
  IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'SCM_FCST')
  BEGIN
    INSERT INTO #RAW_DATA
    ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
    , TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
    , YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
    SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
       , TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, 'SCM_FCST' AS MEASURE
       , YYYYMMDD, QTY, PLAN_RESULT, A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
    FROM #RAW_DATA A WITH(NOLOCK)
    WHERE MEASURE = 'RTF_SYS_RP'
    AND A.YYYYMMDD >= @p_from_yyyymmdd
    AND A.YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd
                ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)
             END -- [C20200521-000202] Version cutoff 기준으로 RTF 조회
  END
  -----------------------------------------------------------------------------------------------------------------------------------
  -- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청 END
  -----------------------------------------------------------------------------------------------------------------------------------
  */

    -----------------------------------------------------------------------------------------------------------------------------------
    --[E20250529-001488]_신규로 생성한 메져 추가 (PLAN_RESULT='P' 파트)
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_exists
      FROM GT_DM22_PROGRAM_ADD_MEASURE A
     INNER JOIN GT_DM22_SELECT_MEASURE B ON A.UI_MEASURE = B.MEASURE
     WHERE PLAN_RESULT = 'P' AND ROWNUM = 1;

    IF v_exists > 0 THEN
        INSERT /*+ NO_PARALLEL */ INTO GT_DM22_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
             TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE,
             YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
               A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.UI_MEASURE,
               A.YYYYMMDD, A.QTY, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM SCM_MGR.GT_DM22_RAW_DATA A
         INNER JOIN (SELECT A.UI_MEASURE, A.DB_MEASURE
                       FROM SCM_MGR.GT_DM22_PROGRAM_ADD_MEASURE A
                      INNER JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.UI_MEASURE = B.MEASURE
                      WHERE PLAN_RESULT = 'P') B ON A.MEASURE = B.DB_MEASURE
         WHERE A.YYYYMMDD >= CASE WHEN A.VERSION_NO = 'CURRENT' THEN P_NOW_YYYYMMDD
                                  ELSE TO_CHAR(FN_NEXT_DAY(TO_DATE(A.CUTOFF_YYYYMMDD, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                             END -- [C20200521-000202] Version cutoff 기준으로 MKT_FCST 조회
           AND A.YYYYMMDD <= P_TO_YYYYMMDD;

    END IF;

    -----------------------------------------------------------------------------------------------------------------------------------
    --[E20250529-001488]_신규로 생성한 메져 추가 (PLAN_RESULT='R' 파트)
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_exists
      FROM SCM_MGR.GT_DM22_PROGRAM_ADD_MEASURE A
     INNER JOIN GT_DM22_SELECT_MEASURE B ON A.UI_MEASURE = B.MEASURE
     WHERE PLAN_RESULT = 'R' AND ROWNUM = 1;

    IF v_exists > 0 THEN
        --INSERT /*+  NO_PARALLEL */ INTO GT_DM22_RAW_DATA
        INSERT /*+  NO_PARALLEL */ INTO GT_DM22_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
             TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE,
             YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
               A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.UI_MEASURE,
               A.YYYYMMDD, A.QTY, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM SCM_MGR.GT_DM22_RAW_DATA A
         INNER JOIN (SELECT A.UI_MEASURE, A.DB_MEASURE
                       FROM SCM_MGR.GT_DM22_PROGRAM_ADD_MEASURE A
                      INNER JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.UI_MEASURE = B.MEASURE
                      WHERE PLAN_RESULT = 'R') B ON A.MEASURE = B.DB_MEASURE
         WHERE A.YYYYMMDD >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD <  CASE WHEN A.VERSION_NO = 'CURRENT' THEN P_NOW_YYYYMMDD
                                  ELSE TO_CHAR(FN_NEXT_DAY(TO_DATE(A.CUTOFF_YYYYMMDD, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                             END;

    END IF;
    -----------------------------------------------------------------------------------------------------------------------------------
    --[E20250529-001488]_신규로 생성한 메져 사용하기 여러 분기쳐서 동일한 쿼리를 사용할 필요가 없는 것으로 확인되어 기존 소스 주석처리하고 해당 부분으로 변경 END
    -----------------------------------------------------------------------------------------------------------------------------------

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A008--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    -- /* 20240308 kcw3408 index 추가 */
    -- create index idx1_RAW_DATA on GT_DM22_RAW_DATA ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID)

    -----------------------------------------------------------------------------------------------------------------------------------
    -- 아래서부터는 CURRENCY를 사용해야 하므로 여기서 UPDATE 한다.
    -----------------------------------------------------------------------------------------------------------------------------------
    UPDATE GT_DM22_RAW_DATA A
       SET A.CURRENCY =
           (SELECT B.CURRENCY
              FROM SCM_MGR.SCM_MST_SITE_ITEM B
             WHERE A.DIVISION_ID  = B.DIVISION_ID
               AND A.PROJECT_CODE = B.PROJECT_CODE
               AND A.SCM_SITE_ID  = B.SCM_SITE_ID
               AND A.ITEM_ID      = B.ITEM_ID
               AND ROWNUM = 1)
     WHERE A.CURRENCY IS NULL ;

    IF P_INTERNAL_YN <> 'Y' THEN
        DELETE FROM GT_DM22_RAW_DATA
         WHERE SCM_SITE_ID IN (SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN);
    END IF;



    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A009--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

  -----------------------------------------------------------------------------------------------------------------------------------
  --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
  -----------------------------------------------------------------------------------------------------------------------------------
--원소스 주석처리
/*
--[E20240115-000325] DM_MST_ITEM_SINGLE_V -> SCM_MST_ITEM_SN
--20240129 SM 해당 구간에 멈춰서 조치--------------------------------------------
--해당구간추가 후 아래 DM_MST_ITEM_SINGLE_v 사용구간 주석처리
SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, ITEM_CLASS
, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY
, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_PRODUCT_GROUP
, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
--[E20240731-000852]_ENERGE 컬럼 아래에서 처리할 예정이므로, 원래 사용했던 부분은 주석처리
--, ENERGE
, CELL_QUANTITY
, MDM_PROJECT_NAME, CELL_TYPE
--[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 82은 KWH, 40은 WH를 사용하므로 두 종류 모두 추가함 START
, ENERGE AS ENERGE_WH
, CASE WHEN ISNUMERIC(ENERGE) > 0 THEN (CONVERT(NUMERIC(15,3),ROUND((CONVERT(NUMERIC(15,3), ENERGE))/1000, 7))) ELSE NULL END AS ENERGE
--[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 82은 KWH, 40은 WH를 사용하므로 두 종류 모두 추가함 END
INTO #TEMP_DM_MST_ITEM_SINGLE_V
--FROM DM_MST_ITEM_SINGLE_V A
FROM
(
    SELECT  T1.DIVISION_ID,
      T1.ITEM_ID,
      MAX(T1.ITEM_NAME)         AS ITEM_NAME,       --해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
      MAX(T1.ITEM_CLASS)          AS ITEM_CLASS,        --해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
      MAX(T1.ITEM_CLASS_NAME)         AS ITEM_CLASS_NAME,   --해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
      MAX(T1.NICK_NAME)           AS NICK_NAME,     --닉네임이 NULL인 경우가 있으므로 하나로 통일
      case  min( case when T1.item_type = 'P' then 1          --타입이 사이트와 사업부, 법인에 따라 다양하게 존재 하므로 하나로 통일
              when T1.item_type = 'H' then 2          --또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함
              when T1.item_type = 'Q' then 3
              else 4 end )
                      when 1 then 'P'
                      when 2 then 'H'
                      when 3 then 'Q'
                      else 'R' end  AS ITEM_TYPE,
      MAX(T1.MATERIAL_CLASS_NAME        )   AS MATERIAL_CLASS_NAME,
      MAX(T1.ITEM_UOM             )   AS ITEM_UOM,
      MAX(T1.SPEC               )   AS SPEC,
      MAX(T1.MDM_PROJECT_NAME         )   AS MDM_PROJECT_NAME,
      MAX(T1.MIN_CAPACITY           )   AS MIN_CAPACITY,
      MAX(T2.FORECAST_INFO_BIZ_TYPE     )   AS FORECAST_INFO_BIZ_TYPE,
      MAX(T2.FORECAST_INFO_PRODUCT_GROUP    )   AS FORECAST_INFO_PRODUCT_GROUP,
      MAX(T2.FORECAST_INFO_CELL_MODEL     )   AS FORECAST_INFO_CELL_MODEL,
      MAX(T2.FORECAST_INFO_CELL_PACK_COUNT  )   AS FORECAST_INFO_CELL_PACK_COUNT,
      MAX(T2.FORECAST_INFO_SPEC       )   AS FORECAST_INFO_SPEC,
      MAX(T2.FORECAST_INFOR_VERSION     )   AS FORECAST_INFOR_VERSION,
      MAX(T1.ACTIVE_FLAG            )   AS ACTIVE_FLAG,  -- 20180720 ADD 'Y'대상중 1건 추출
      MAX(T2.CELL_TYPE            )   AS CELL_TYPE,  -- 20180911 ADD cell_type
      MAX(T1.ENERGE             )       AS ENERGE,      -- 20200116 khsong ADD ENERGE
      MAX(T1.CELL_QUANTITY          )     AS CELL_QUANTITY, -- 20200116 khsong ADD CELL_QUANTITY
      MAX(T1.SCP_EXTRA_SPEC)              AS SCP_EXTRA_SPEC   -- [20210428 SJHAN / CSR ID:C20210323-000420]
    FROM SCM_MST_ITEM_SN T1 WITH(NOLOCK)
    INNER JOIN ( SELECT DIVISION_ID, LEFT(ITEM_ID, 12) AS ITEM_ID
            , MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
            , MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
            , MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
            , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
            , MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
            , MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
            , MAX(CELL_TYPE) AS CELL_TYPE
          FROM  SCM_MST_ITEM_SN T2 WITH(NOLOCK)
          WHERE  DIVISION_ID =  @p_division_id
          GROUP BY DIVISION_ID, LEFT(ITEM_ID, 12)
        ) T2 ON T1.DIVISION_ID = T2.DIVISION_ID
      AND SUBSTRING(T1.ITEM_ID,1,12) = T2.ITEM_ID
    where 1=1
    AND   T1.DIVISION_ID = @p_division_id
    --AND   T1.ACTIVE_FLAG = 'Y'  --이걸 막아야 건수가 동일해짐 수정전/후 count
    --WHERE ACTIVE_FLAG = 'Y'  -- 20180720 ADD 'Y'대상만
    --LGCE_FPDEV_TR.DBO.SCM_ITEM_M T1
    group by T1.DIVISION_ID, T1.ITEM_ID
) A
join ( select distinct division_id, item_id from #RAW_DATA ) b on a.division_id = b.division_id and a.item_id = b.item_id
WHERE A.DIVISION_ID = @p_division_id
*/
    -----------------------------------------------------------------------------------------------------------------------------------
    --> SCM_MST_ITEM_SN 테이블을 TEMP로 넣는다.
    -----------------------------------------------------------------------------------------------------------------------------------
    INSERT /*+  NO_PARALLEL */ INTO SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_ORI_V
          (COMPANY_ID
          ,DIVISION_ID
          ,SITE_ID
          ,ITEM_ID
          ,ITEM_NAME
          ,NICK_NAME
          ,ITEM_TYPE
          ,ITEM_CLASS_LEVEL_1
          ,ITEM_CLASS_LEVEL_2
          ,ITEM_CLASS_LEVEL_3
          ,ITEM_CLASS_LEVEL_4
          ,ITEM_CLASS
          ,ITEM_CLASS_NAME
          ,MATERIAL_CLASS
          ,MATERIAL_CLASS_NAME
          ,ELECTRODE_TYPE
          ,SIDE_TYPE
          ,ITEM_GROUP_ID
          ,SETUP_GROUP_ID_1
          ,SETUP_GROUP_ID_2
          ,SETUP_GROUP_ID_3
          ,FLOW_ID
          ,ERP_EOL
          ,SCP_EOL
          ,ITEM_UOM
          ,SPEC
          ,DEMAND_LOT_SIZE
          ,ITEM_ATTRIBUTE
          ,SETUP_ATTRIBUTE
          ,BATCH_RATIO_ID
          ,OUTSOURCING_FACTORY
          ,FINITE_TERM
          ,FINITE_TERM_UOM
          ,COATED_LENGTH
          ,UNCOATED_LENGTH
          ,LENGTH_UOM
          ,SLURRY_LOSS_RATE
          ,DESCRIPTION
          ,ACTIVE_FLAG
          ,INSERT_ID
          ,INSERT_TIME
          ,UPDATE_ID
          ,UPDATE_TIME
          ,APPLIED_MODEL
          ,CELL_TYPE
          ,MAKE_AND_BUY
          ,COLOR_ATTRIBUTE
          ,FORMATION_FLOW_ID
          ,STANDARD_COST
          ,CURRENCY
          ,FORM_ATTRIBUTE
          ,ENERGE
          ,SCP_FLOW_ID
          ,SCP_OPERATION_GROUP
          ,SCP_OPERATION_GROUP_ID
          ,MDM_PROJECT_NAME
          ,MIN_CAPACITY
          ,MOBILE_MODEL_ID
          ,FORECAST_INFO_BIZ_TYPE
          ,FORECAST_INFO_PRODUCT_GROUP
          ,FORECAST_INFO_CELL_MODEL
          ,FORECAST_INFO_CELL_PACK_COUNT
          ,FORECAST_INFO_SPEC
          ,FORECAST_INFOR_VERSION
          ,DOE
          ,INSULATION_COATING
          ,PACK_PRODUCT_GROUP_CODE
          ,CELL_QUANTITY
          ,SCP_EXTRA_SPEC
          ,SCM_PIC
          ,REP_CUSTOMER
          ,MAKER
          ,EVAL_CLASS
          ,EVAL_CLASS_INFO
          ,FP_EXTRA_SPEC
          ,MRP_USE_FLAG
          ,ITEM_RAW_PLANT_ID
          ,ITEM_COPY_YN
          )
    SELECT COMPANY_ID
          ,DIVISION_ID
          ,SITE_ID
          ,ITEM_ID
          ,ITEM_NAME
          ,NICK_NAME
          ,ITEM_TYPE
          ,ITEM_CLASS_LEVEL_1
          ,ITEM_CLASS_LEVEL_2
          ,ITEM_CLASS_LEVEL_3
          ,ITEM_CLASS_LEVEL_4
          ,ITEM_CLASS
          ,ITEM_CLASS_NAME
          ,MATERIAL_CLASS
          ,MATERIAL_CLASS_NAME
          ,ELECTRODE_TYPE
          ,SIDE_TYPE
          ,ITEM_GROUP_ID
          ,SETUP_GROUP_ID_1
          ,SETUP_GROUP_ID_2
          ,SETUP_GROUP_ID_3
          ,FLOW_ID
          ,ERP_EOL
          ,SCP_EOL
          ,ITEM_UOM
          ,SPEC
          ,DEMAND_LOT_SIZE
          ,ITEM_ATTRIBUTE
          ,SETUP_ATTRIBUTE
          ,BATCH_RATIO_ID
          ,OUTSOURCING_FACTORY
          ,FINITE_TERM
          ,FINITE_TERM_UOM
          ,COATED_LENGTH
          ,UNCOATED_LENGTH
          ,LENGTH_UOM
          ,SLURRY_LOSS_RATE
          ,DESCRIPTION
          ,ACTIVE_FLAG
          ,INSERT_ID
          ,INSERT_TIME
          ,UPDATE_ID
          ,UPDATE_TIME
          ,APPLIED_MODEL
          ,CELL_TYPE
          ,MAKE_AND_BUY
          ,COLOR_ATTRIBUTE
          ,FORMATION_FLOW_ID
          ,STANDARD_COST
          ,CURRENCY
          ,FORM_ATTRIBUTE
          ,ENERGE
          ,SCP_FLOW_ID
          ,SCP_OPERATION_GROUP
          ,SCP_OPERATION_GROUP_ID
          ,MDM_PROJECT_NAME
          ,MIN_CAPACITY
          ,MOBILE_MODEL_ID
          ,FORECAST_INFO_BIZ_TYPE
          ,FORECAST_INFO_PRODUCT_GROUP
          ,FORECAST_INFO_CELL_MODEL
          ,FORECAST_INFO_CELL_PACK_COUNT
          ,FORECAST_INFO_SPEC
          ,FORECAST_INFOR_VERSION
          ,DOE
          ,INSULATION_COATING
          ,PACK_PRODUCT_GROUP_CODE
          ,CELL_QUANTITY
          ,SCP_EXTRA_SPEC
          ,SCM_PIC
          ,REP_CUSTOMER
          ,MAKER
          ,EVAL_CLASS
          ,EVAL_CLASS_INFO
          ,FP_EXTRA_SPEC
          ,MRP_USE_FLAG
          ,ITEM_RAW_PLANT_ID
          ,ITEM_COPY_YN
    FROM   SCM_MGR.SCM_MST_ITEM_SN
    WHERE DIVISION_ID = p_division_id
      --[E20260820-D22PREREDUCE] hook #129 ④ 선행축소 — 이 GTT 의 소비처는 아래 A_V(L1597)/B_V(L1646) 뿐이고
      --  최종 소비처 GT_DM22_DM_MST_ITEM_SINGLE_V(L1688) 는 GT_DM22_RAW_DATA 의 (DIVISION_ID,ITEM_ID) 로
      --  다시 INNER JOIN 된다. B_V 가 SUBSTR(ITEM_ID,1,12) 로 MAX 집계하므로 **prefix 단위**로 축소해야
      --  집계 그룹이 온전히 보존된다(정확 ITEM_ID 축소는 B_V 의 MAX 를 바꿔 금지).
      --  RAW_DATA 는 L1009/L1072 적재 후 L1688 까지 변경 DML 이 없다(사이 INSERT/DELETE/UPDATE 부재).
      --  실측(사내 2026-08-20): div40 243,050행 적재 → 최종 SINGLE_V 136행, TABLE ACCESS FULL SCM_ITEM_M.
      AND SUBSTR(ITEM_ID, 1, 12) IN (SELECT SUBSTR(R.ITEM_ID, 1, 12)
                                       FROM SCM_MGR.GT_DM22_RAW_DATA R
                                      WHERE R.DIVISION_ID = p_division_id)
    ;

    -----------------------------------------------------------------------------------------------------------------------------------
    --멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
    -----------------------------------------------------------------------------------------------------------------------------------
    INSERT /*+ NO_PARALLEL */ INTO SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_A_V
          (DIVISION_ID
          ,ITEM_ID
          ,ITEM_CLASS
          ,ITEM_NAME
          ,ITEM_CLASS_NAME
          ,NICK_NAME
          ,ITEM_TYPE
          ,MATERIAL_CLASS_NAME
          ,ITEM_UOM
          ,SPEC
          ,MDM_PROJECT_NAME
          ,MIN_CAPACITY
          ,ACTIVE_FLAG
          ,ENERGE
          ,CELL_QUANTITY
          ,SCP_EXTRA_SPEC
          )
    SELECT T1.DIVISION_ID
          ,T1.ITEM_ID
          ,MAX(T1.ITEM_CLASS)           AS ITEM_CLASS
          ,MAX(T1.ITEM_NAME)            AS ITEM_NAME
          ,MAX(T1.ITEM_CLASS_NAME)      AS ITEM_CLASS_NAME
          ,MAX(T1.NICK_NAME)            AS NICK_NAME
          ,CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                  WHEN T1.ITEM_TYPE = 'H' THEN 2
                  WHEN T1.ITEM_TYPE = 'Q' THEN 3
               ELSE 4 END )
                      WHEN 1 THEN 'P'
                      WHEN 2 THEN 'H'
                      WHEN 3 THEN 'Q'
                      ELSE 'R' END      AS ITEM_TYPE
          ,MAX(T1.MATERIAL_CLASS_NAME)  AS MATERIAL_CLASS_NAME
          ,MAX(T1.ITEM_UOM)             AS ITEM_UOM
          ,MAX(T1.SPEC)                 AS SPEC
          ,MAX(T1.MDM_PROJECT_NAME)     AS MDM_PROJECT_NAME
          ,MAX(T1.MIN_CAPACITY)         AS MIN_CAPACITY
          ,MAX(T1.ACTIVE_FLAG)          AS ACTIVE_FLAG
          ,MAX(T1.ENERGE)               AS ENERGE
          ,MAX(T1.CELL_QUANTITY)        AS CELL_QUANTITY
          ,MAX(T1.SCP_EXTRA_SPEC)       AS SCP_EXTRA_SPEC
    FROM  SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_ORI_V T1
    WHERE 1=1
    GROUP BY T1.DIVISION_ID, T1.ITEM_ID
    ;

    -----------------------------------------------------------------------------------------------------------------------------------
    --멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
    -----------------------------------------------------------------------------------------------------------------------------------
    INSERT /*+ NO_PARALLEL */ INTO SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_B_V
          (DIVISION_ID
          ,ITEM_ID
          ,FORECAST_INFO_BIZ_TYPE
          ,FORECAST_INFO_PRODUCT_GROUP
          ,FORECAST_INFO_CELL_MODEL
          ,FORECAST_INFO_CELL_PACK_COUNT
          ,FORECAST_INFO_SPEC
          ,FORECAST_INFOR_VERSION
          ,CELL_TYPE
          )
    SELECT DIVISION_ID
          ,SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
          ,MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
          ,MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
          ,MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
          ,MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
          ,MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
          ,MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
          ,MAX(CELL_TYPE) AS CELL_TYPE
    FROM  SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_ORI_V T2
    GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)
    ;

    --[E20260806-PERF] START — GTT 세션통계 부재로 하단 SINGLE_V INSERT 가 MERGE JOIN CARTESIAN
    --                  (RAW_DATA E-Rows=1 공유커서 재사용 x B_V 145K = 2.19B 중간행) 을 타면서
    --                  ORA-01652(TEMP 18,679MB) 발생 (2026-08-06 실측, SQL_ID dqgjb2xrptfk6).
    --                  AS-IS(MSSQL) 는 #TEMP 자동통계로 동일 결함 없음 → GATHER 동봉이 AS-IS 등가.
    --                  수집 3본 (RAW_DATA / A_V / B_V) — 기존 body 의 GT_DM22_SELECT_MEASURE 등
    --                  8개소 GATHER 와 동일 스타일. 실측: 수집 0.27s, INSERT 606s+실패 → 0.04s.
    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_RAW_DATA',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);
    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_A_V',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);
    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_B_V',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);
    --[E20260806-PERF] END

    -----------------------------------------------------------------------------------------------------------------------------------
    --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
    -----------------------------------------------------------------------------------------------------------------------------------
    -- #TEMP_DM_MST_ITEM_SINGLE_V 구성 (SCM_MST_ITEM_SN 직접 조회)
    INSERT /*+ NO_PARALLEL */ INTO SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V
          (DIVISION_ID
          ,ITEM_ID
          ,ITEM_NAME
          ,ITEM_CLASS
          ,ITEM_CLASS_NAME
          ,NICK_NAME
          ,ITEM_TYPE
          ,MATERIAL_CLASS_NAME
          ,ITEM_UOM
          ,SPEC
          ,MDM_PROJECT_NAME
          ,MIN_CAPACITY
          ,FORECAST_INFO_BIZ_TYPE
          ,FORECAST_INFO_PRODUCT_GROUP
          ,FORECAST_INFO_CELL_MODEL
          ,FORECAST_INFO_CELL_PACK_COUNT
          ,FORECAST_INFO_SPEC
          ,FORECAST_INFOR_VERSION
          ,ACTIVE_FLAG
          ,CELL_TYPE
          ,CELL_QUANTITY
          ,SCP_EXTRA_SPEC
          ,ENERGE_WH
          ,ENERGE
          )
    SELECT A.DIVISION_ID, A.ITEM_ID, A.ITEM_NAME, A.ITEM_CLASS, A.ITEM_CLASS_NAME
         , A.NICK_NAME, A.ITEM_TYPE, A.MATERIAL_CLASS_NAME, A.ITEM_UOM, A.SPEC
         , A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.FORECAST_INFO_PRODUCT_GROUP, A.FORECAST_INFO_CELL_MODEL
         , A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION, A.ACTIVE_FLAG, A.CELL_TYPE
         , A.CELL_QUANTITY, A.SCP_EXTRA_SPEC, A.ENERGE AS ENERGE_WH
         --[E20260910-ENERGESCALE] AS-IS L1855 CONVERT(NUMERIC(15,3)) 2단(입력·결과 3자리) 복원. 누락 시 Wh<500 품목이 0 아닌 미소값이 되어 AS-IS 대비 행 초과.
         , CASE WHEN REGEXP_LIKE(A.ENERGE, '^\d+(\.\d+)?$') THEN ROUND(ROUND(ROUND(TO_NUMBER(A.ENERGE), 3) / 1000, 7), 3) ELSE NULL END AS ENERGE
    FROM
        ( SELECT T1.DIVISION_ID, T1.ITEM_ID, T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME
               , T1.NICK_NAME, T1.ITEM_TYPE, T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC
               , T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
               , T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION, T1.ACTIVE_FLAG, T2.CELL_TYPE
               , T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC, T1.ENERGE
          FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_A_V T1
              INNER JOIN SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_B_V T2
                  ON T1.DIVISION_ID = T2.DIVISION_ID
                   AND SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
          WHERE 1=1  ) A
      JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID FROM SCM_MGR.GT_DM22_RAW_DATA ) B ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
      WHERE A.DIVISION_ID = p_division_id
      GROUP BY A.DIVISION_ID, A.ITEM_ID, A.ITEM_NAME, A.ITEM_CLASS, A.ITEM_CLASS_NAME, A.NICK_NAME, A.ITEM_TYPE, A.MATERIAL_CLASS_NAME
           , A.ITEM_UOM, A.SPEC, A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.FORECAST_INFO_PRODUCT_GROUP
           , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
           , A.ACTIVE_FLAG, A.CELL_TYPE, A.ENERGE, A.CELL_QUANTITY, A.SCP_EXTRA_SPEC
    ;


    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_V',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);

    -----------------------------------------------------------------------------------------------------------------------------------
    --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 END
    -----------------------------------------------------------------------------------------------------------------------------------

/* [E20240731-000852]_MDM에서 DM으로 ENERGE I/F 단위는 WH인데, 82사업부는 KW기준
						40번 사업부는 WH기준으로 보여주길 원하므로 82사업부인 경우에만 KWH로 나오도록 조건 추가
--[E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선 START
--해당 테이블의 데이터를 쓰므로, 데이터 완료된 후 KWH로 변경한다.
UPDATE #TEMP_DM_MST_ITEM_SINGLE_V
SET ENERGE = CASE WHEN ISNUMERIC(ENERGE) > 0 THEN ROUND((CONVERT(NUMERIC(15,3), ENERGE))/1000, 4) ELSE NULL END
FROM #TEMP_DM_MST_ITEM_SINGLE_V
--[E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선 END
*/

------------------------------------------------------------------------END
--[E20240115-000325] ▼ 주석처리
-------------------------------------------------------------------------------------------
----                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (BEGIN)
-------------------------------------------------------------------------------------------
--SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, ITEM_CLASS
--  , ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY
--  , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_PRODUCT_GROUP
--  , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
--  , ENERGE, CELL_QUANTITY
--  , MDM_PROJECT_NAME, CELL_TYPE
-- INTO #TEMP_DM_MST_ITEM_SINGLE_V
-- FROM DM_MST_ITEM_SINGLE_V A  WITH (NOLOCK)  --[E20240115-000325] WITH (NOLOCK) 처리
-- join ( select distinct division_id, item_id from #RAW_DATA ) b on a.division_id = b.division_id and a.item_id = b.item_id
--WHERE A.DIVISION_ID = @p_division_id

-------------------------------------------------------------------------------------------
----                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (END)
-------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
--                                 20190326 속도개선 ITEM_SINGLE_V TEMP TABLE 사용 (END)
------------------------------------------------------------------------------------------

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A010--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    -----------------------------------------------------------------------------------------------------------------------------------
    -- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (START)
    -----------------------------------------------------------------------------------------------------------------------------------
    INSERT /*+ NO_PARALLEL */ INTO GT_DM22_SCM_MST_SITE_ITEM
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, APPLICATION,
           CUST_GROUP, ROUTE, CUST_GROUP_DTL, CELL_PER_CAR, CELL_PER_MODULE,
           SALES_COMPANY, CURRENCY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5,
           ATTRIBUTE7, ATTRIBUTE8, NULL AS REPORT_GROUP6, A.OWNER,
           FN_GET_DM_MKT_OWNER_NAME(A.OWNER, ',', 'EN')   AS OWNER_NAME,
           FN_GET_DM_MKT_OWNER_NAME(A.OWNER, ',', 'KO')   AS OWNER_NAME_KO,
           -- [hook#150 2026-09-06 AJS] AS-IS: (SELECT SU.DEPT_ID FROM SCM_MST_SSO_USER_INFO SU
             -- [hook#150 2026-09-06 AJS] AS-IS: WHERE SU.USER_ID = (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(A.OWNER,',')) P WHERE ROWNUM = 1)) AS DEPT_ID,
           A.DEPT_ID AS DEPT_ID,  -- 2026-09-06 hook#150 AJS: DEPT_ID 원천 = SCM_MST_SITE_ITEM.DEPT_ID (SCM_MST_SITE.DEPT_ID 삭제 예정 / OWNER 경유 폐기)
           VALID_YN
      FROM SCM_MGR.SCM_MST_SITE_ITEM A
      JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID FROM SCM_MGR.GT_DM22_RAW_DATA) B
        ON A.DIVISION_ID  = B.DIVISION_ID
       AND A.SCM_SITE_ID  = B.SCM_SITE_ID
       AND A.PROJECT_CODE = B.PROJECT_CODE
       AND A.ITEM_ID      = B.ITEM_ID
     WHERE A.DIVISION_ID = P_DIVISION_ID;
    -----------------------------------------------------------------------------------------------------------------------------------
    -- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (END)
    -----------------------------------------------------------------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A011--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_SCM_MST_SITE_ITEM',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);


    DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
     WHERE A.PLAN_RESULT = 'P'
       AND A.ITEM_ID NOT IN (SELECT SEGMENT3 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                              WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                AND SEGMENT1 = A.DIVISION_ID)
       AND NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_DM22_SCM_MST_SITE_ITEM B
                        WHERE A.DIVISION_ID  = B.DIVISION_ID
                          AND A.PROJECT_CODE = B.PROJECT_CODE
                          AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                          AND A.ITEM_ID      = B.ITEM_ID
                          AND B.VALID_YN     = 'Y');
    --AND A.VERSION_NO = 'CURRENT' ( 수정 전 로직이 버전구분 없이 처리 )



    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A012--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    -----------------------------------------------------------------------------------------------------------------------------------
    --[PJ2024-50611] 화면에서 저장한 dept_id 업데이트 START
    -----------------------------------------------------------------------------------------------------------------------------------
    UPDATE SCM_MGR.GT_DM22_RAW_DATA A
       SET A.ATTRIBUTE1 =
           (SELECT B.ATTRIBUTE1
              FROM SCM_MGR.DM_PLN_SALES_ETC_PLAN B
             WHERE B.DIVISION_ID  = '40'
               AND B.FCST_TYPE    = 'ETC'
               AND B.YYYYMMDD    >= P_NOW_YYYYMMDD AND B.YYYYMMDD <= P_TO_YYYYMMDD
               AND B.QTY         <> 0
               AND A.DIVISION_ID  = B.DIVISION_ID
               AND A.PROJECT_CODE = B.PROJECT_CODE
               AND A.SCM_SITE_ID  = B.SCM_SITE_ID
               AND A.ITEM_ID      = B.ITEM_ID
               AND A.DOM_EXP      = B.DOM_EXP
               AND A.FCST_TYPE    = B.FCST_TYPE
               AND A.INCOTERMS    = B.INCOTERMS
               AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
               AND A.YYYYMMDD     = B.YYYYMMDD
               AND A.TEXT         = B.REMARK_TEXT
               AND ROWNUM = 1)
     WHERE A.DIVISION_ID = '40' AND A.FCST_TYPE = 'ETC';
    -----------------------------------------------------------------------------------------------------------------------------------
    --[PJ2024-50611] 화면에서 저장한 dept_id 처리 END
    -----------------------------------------------------------------------------------------------------------------------------------



    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    -----------------------------------------------------------------------------------------------------------------------------------
    -- 조회조건에 따른 필터링 처리 START
    -----------------------------------------------------------------------------------------------------------------------------------
    IF NVL(P_PROJECT_CODE,'@#@#@#') <> '@#@#@#' THEN -- 소형은 UI 에서 PROJECT DISABLE 됨
        DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
         WHERE NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.SCM_MST_PROJECT B
                    WHERE A.DIVISION_ID  = B.DIVISION_ID
                      AND A.PROJECT_CODE = B.PROJECT_CODE
                      AND (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_PROJECT_CODE,',')) P WHERE B.PROJECT_CODE LIKE '%'|| P.TOKEN ||'%')
                           OR
                           EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_PROJECT_CODE,',')) P WHERE B.PROJECT_NAME LIKE '%'|| P.TOKEN ||'%')
                          )
               );
        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013-1--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    END IF;

    IF NVL(P_ITEM_ID,'@#@#@#') <> '@#@#@#' THEN
        DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
         WHERE NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V B
                    WHERE A.ITEM_ID = B.ITEM_ID
                      AND (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) P WHERE A.ITEM_ID LIKE '%'|| P.TOKEN ||'%')
                           OR
                           EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) P WHERE B.NICK_NAME LIKE '%'|| P.TOKEN ||'%')
                          )
               );
        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013-2--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));
    END IF;

    IF NVL(P_OWNER,'@#@#@#') <> '@#@#@#' THEN
        DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
         WHERE NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.GT_DM22_SCM_MST_SITE_ITEM B
                    WHERE A.ITEM_ID     = B.ITEM_ID
                      AND A.SCM_SITE_ID = B.SCM_SITE_ID
                      AND A.PROJECT_CODE= B.PROJECT_CODE
                      AND (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_OWNER,',')) P WHERE B.OWNER LIKE '%'|| P.TOKEN ||'%')
                           OR
                           EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_OWNER,',')) P WHERE B.OWNER_NAME LIKE '%'|| P.TOKEN ||'%')
                           OR
                           EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_OWNER,',')) P WHERE B.OWNER_NAME_KO LIKE '%'|| P.TOKEN ||'%')
                          )
               );
        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013-3--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));
    END IF;

    IF P_DEPT_ID <> 'ALL' THEN
        -----------------------------------------------------------------------------------------------------------------------------------
        --[PJ2024-50461] Team Mapping
        -- 기타매출은 기존 SALE SITE 정보를 이용하므로 검색시도 구분해야함
        -----------------------------------------------------------------------------------------------------------------------------------
        -- 기타매출 이외
        DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
         WHERE A.FCST_TYPE <> 'ETC'
           AND NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_DM22_SCM_MST_SITE_ITEM B
                            WHERE A.ITEM_ID     = B.ITEM_ID
                              AND A.SCM_SITE_ID = B.SCM_SITE_ID
                              AND A.PROJECT_CODE= B.PROJECT_CODE
                              AND B.DEPT_ID IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DEPT_ID,',')) P)
                          );

        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013-4--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));
        -----------------------------------------------------------------------------------------------------------------------------------
        -- 기타매출(40 이외 사업부)
        -----------------------------------------------------------------------------------------------------------------------------------
        DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
         WHERE A.FCST_TYPE   = 'ETC'
           AND A.DIVISION_ID <> '40' --[PJ2024-50611] 40 이외 사업부는 기타일 경우 SCM_MST_SITE 에서 가져옴
           AND NOT EXISTS (
                           SELECT 1
                             FROM SCM_MGR.SCM_MST_SITE B
                                   LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM C
                                        ON C.DIVISION_ID = B.DIVISION_ID
                                       AND C.SCM_SITE_ID = B.SCM_SITE_ID
                            WHERE B.SCM_SITE_ID  = A.SCM_SITE_ID
                              AND B.DIVISION_ID  = P_DIVISION_ID
                              AND C.PROJECT_CODE = A.PROJECT_CODE
                              AND C.ITEM_ID      = A.ITEM_ID
                              AND C.DEPT_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_DEPT_ID,',')) P)
               );

        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013-5--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));
        -----------------------------------------------------------------------------------------------------------------------------------
        --[PJ2024-50611]_기타매출(40사업부) START
        -----------------------------------------------------------------------------------------------------------------------------------
        DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
         WHERE A.FCST_TYPE   = 'ETC'
           AND A.DIVISION_ID = '40'
           AND A.ATTRIBUTE1 NOT IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DEPT_ID,',')) P)
        ; --[PJ2024-50611] 40사업부 기타매출은 ATTRIBUTE1 에 부서코드 있음
        -----------------------------------------------------------------------------------------------------------------------------------
        --[PJ2024-50611]기타매출(40사업부) END
        -----------------------------------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013-6--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));
    END IF;

	/*
     IF ( @P_DIVISION_ID = '40')
     BEGIN
      DELETE A
      FROM #RAW_DATA A
      LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM B WITH(NOLOCK)
	       ON A.ITEM_ID = B.ITEM_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE
      LEFT OUTER JOIN ( SELECT DISTINCT token
           FROM dbo.String_Split(@p_dept_id,',')
          ) C ON B.DEPT_ID = C.TOKEN
      WHERE C.TOKEN IS NULL
     END
     ELSE
     BEGIN
      DELETE A
      FROM #RAW_DATA A
      LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
	       ON A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = @P_DIVISION_ID
      LEFT OUTER JOIN ( SELECT DISTINCT token
           FROM dbo.String_Split(@p_dept_id,',')
          ) C ON B.DEPT_ID = C.TOKEN
      WHERE C.TOKEN IS NULL
     END
	 */

    IF P_END_CUSTOMER <> 'ALL' THEN
        IF P_DIVISION_ID = '40' THEN
            DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
             WHERE A.PROJECT_CODE NOT IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_END_CUSTOMER,',')) P)
            ;
        ELSE
            DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
             WHERE NOT EXISTS (
                       SELECT 1 FROM SCM_MGR.SCM_MST_SITE B
                        WHERE A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = P_DIVISION_ID
                          AND B.END_CUSTOMER IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_END_CUSTOMER,',')) P)
                   );
        END IF;
        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013-7--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));
    END IF;

    IF P_SCM_SITE_ID <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
         WHERE A.SCM_SITE_ID NOT IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_SCM_SITE_ID,',')) P)
         ;
    END IF;

    IF P_PLANT_SITE_ID <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
         WHERE A.PLANT_SITE_ID NOT IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_PLANT_SITE_ID,',')) P)
         ;
        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013-8--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));
    END IF;

    IF P_ITEM_TYPE <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
         WHERE NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V B
                    WHERE A.ITEM_ID = B.ITEM_ID
                      AND B.ITEM_TYPE IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_TYPE,',')) P)
               );
    END IF;

    IF P_BIZTYPE <> 'ALL' THEN
        IF P_DIVISION_ID = '40' THEN
            DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
             WHERE NOT EXISTS (
                       SELECT 1 FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V B
                        WHERE A.ITEM_ID = B.ITEM_ID
                          AND B.FORECAST_INFO_BIZ_TYPE IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_BIZTYPE,',')) P)
                   );
        ELSE
            DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
             WHERE NOT EXISTS (
                       SELECT 1 FROM SCM_MGR.SCM_MST_PROJECT B
                        WHERE A.DIVISION_ID  = B.DIVISION_ID
                          AND A.PROJECT_CODE = B.PROJECT_CODE
                          AND EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_BIZTYPE,',')) P WHERE B.BIZ_TYPE LIKE P.TOKEN ||'%')
                   );
        END IF;
        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013-9--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));
    END IF;

    -----------------------------------------------------------------------------------------------------------------------------------
    -- 조회조건에 따른 필터링 처리 END
    -----------------------------------------------------------------------------------------------------------------------------------

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A014--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    -----------------------------------------------------------------------------------------------------------------------------------
    -- 실적구간 PRICE 처리
    -----------------------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------------
    -- 실적구간 LOC 메져 데이터 처리 (DM SALES PRICE를 가지고 계산하는 부분이 아니라, ERP에서 가지고 온 데이터를 가지고 계산하는 부분임)
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_exists FROM SCM_MGR.GT_DM22_SELECT_MEASURE WHERE MEASURE = 'LOC' AND ROWNUM = 1;
    IF v_exists > 0 THEN
        INSERT /*+ NO_PARALLEL */ INTO SCM_MGR.GT_DM22_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
             TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE,
             YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
               '', A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'LOC',
               A.YYYYMMDD,
               CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END,
               'R', A.CELL_PROD_SITE_ID
          FROM (SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                       A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY, A.CELL_PROD_SITE_ID
                  FROM SCM_MGR.GT_DM22_RAW_DATA A
                 WHERE YYYYMMDD >= v_start_yyyymmdd
                   AND YYYYMMDD <  CASE WHEN VERSION_NO = 'CURRENT' THEN P_NOW_YYYYMMDD
                                        ELSE TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'),'MON')-7,'YYYYMMDD') END
                   AND A.MEASURE = 'RTF_SYS_RP'
                 GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID,
                          A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID) A
          JOIN (SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                       A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY, A.CELL_PROD_SITE_ID
                  FROM SCM_MGR.GT_DM22_RAW_DATA A
                 WHERE YYYYMMDD >= v_start_yyyymmdd
                   AND YYYYMMDD <  CASE WHEN VERSION_NO = 'CURRENT' THEN P_NOW_YYYYMMDD
                                        ELSE TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'),'MON')-7,'YYYYMMDD') END
                   AND A.MEASURE = 'SalesAmt_LOC'
                 GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID,
                          A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID) B
                ON A.VERSION_NO            = B.VERSION_NO
               AND A.DIVISION_ID           = B.DIVISION_ID
               AND A.PROJECT_CODE          = B.PROJECT_CODE
               AND A.SCM_SITE_ID           = B.SCM_SITE_ID
               AND A.PLANT_SITE_ID         = B.PLANT_SITE_ID
               AND A.ITEM_ID               = B.ITEM_ID
               AND A.INCOTERMS             = B.INCOTERMS
               AND A.DOM_EXP               = B.DOM_EXP
               AND A.FCST_TYPE             = B.FCST_TYPE
               AND A.CURRENCY              = B.CURRENCY
               AND A.YYYYMMDD              = B.YYYYMMDD
               AND NVL(A.COMPANY_ID,'')    = NVL(B.COMPANY_ID,'')
               AND A.CELL_PROD_SITE_ID     = B.CELL_PROD_SITE_ID;

    END IF;

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A015--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    -----------------------------------------------------------------------------------------------------------------------------------
    -- 실적구간 KRW 메져 데이터 처리 (DM SALES PRICE를 가지고 계산하는 부분이 아니라, ERP에서 가지고 온 데이터를 가지고 계산하는 부분임)
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_exists FROM SCM_MGR.GT_DM22_SELECT_MEASURE WHERE MEASURE = 'KRW' AND ROWNUM = 1;
    IF v_exists > 0 THEN
        INSERT /*+NO_PARALLEL */ INTO SCM_MGR.GT_DM22_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
             TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE,
             YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
               '', A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'KRW',
               A.YYYYMMDD,
               CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END,
               'R', A.CELL_PROD_SITE_ID
          FROM (SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                       A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY, A.CELL_PROD_SITE_ID
                  FROM SCM_MGR.GT_DM22_RAW_DATA A
                 WHERE YYYYMMDD >= v_start_yyyymmdd
                   AND YYYYMMDD <  CASE WHEN VERSION_NO = 'CURRENT' THEN P_NOW_YYYYMMDD
                                        ELSE TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'),'MON')-7,'YYYYMMDD') END
                   AND A.MEASURE = 'RTF_SYS_RP'
                 GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID,
                          A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID) A
          JOIN (SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                       A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY, A.CELL_PROD_SITE_ID
                  FROM SCM_MGR.GT_DM22_RAW_DATA A
                 WHERE YYYYMMDD >= v_start_yyyymmdd
                   AND YYYYMMDD <  CASE WHEN VERSION_NO = 'CURRENT' THEN P_NOW_YYYYMMDD
                                        ELSE TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'),'MON')-7,'YYYYMMDD') END
                   AND A.MEASURE = 'SalesAmt_KRW'
                 GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID,
                          A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID) B
                ON A.VERSION_NO            = B.VERSION_NO
               AND A.DIVISION_ID           = B.DIVISION_ID
               AND A.PROJECT_CODE          = B.PROJECT_CODE
               AND A.SCM_SITE_ID           = B.SCM_SITE_ID
               AND A.PLANT_SITE_ID         = B.PLANT_SITE_ID
               AND A.ITEM_ID               = B.ITEM_ID
               AND A.INCOTERMS             = B.INCOTERMS
               AND A.DOM_EXP               = B.DOM_EXP
               AND A.FCST_TYPE             = B.FCST_TYPE
               AND A.CURRENCY              = B.CURRENCY
               AND A.YYYYMMDD              = B.YYYYMMDD
               AND NVL(A.COMPANY_ID,'')    = NVL(B.COMPANY_ID,'')
               AND A.CELL_PROD_SITE_ID     = B.CELL_PROD_SITE_ID;

    END IF;

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A016--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    -----------------------------------------------------------------------------------------------------------------------------------
    -- 계획구간 PRICE 처리
    -----------------------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------------
    -- 계획구간 CURRENT 'KRW', 'LOC', 'USD' 메져 데이터 처리
    -- 40사업부만 PRICE를 별도화면에서 저장하여 관리한다 40사업부 Demand > Demand Plan > FcstPrice MGMT / 타사업부 Master > Demand Master > Sales Price
    -- 40 사업부의 경우: DM_PLN_CFM_SELLING_PRICE, 타 사업부는 기존: SCM_MST_FUTURE_PRICE 사용
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_exists FROM SCM_MGR.GT_DM22_SELECT_MEASURE WHERE MEASURE IN ('KRW','LOC','USD') AND ROWNUM = 1;

    IF v_exists > 0 AND UPPER(P_VERSION_TYPE) LIKE '%CURRENT%' THEN  --[E20260831-VERCASE] MSSQL CI 콜레이션 1:1 — 'Current' 등 대소문자 변형 흡수
        IF P_DIVISION_ID = '40' THEN
            INSERT /*+ NO_PARALLEL */ INTO SCM_MGR.GT_DM22_RAW_DATA
                (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
                 TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
            SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                   A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE,
                   A.YYYYMMDD, C.PRICE, 'P', A.CELL_PROD_SITE_ID
              FROM (SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                                    A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD,
                                    B.BASIS_START_DATE, A.CELL_PROD_SITE_ID
                     FROM SCM_MGR.GT_DM22_RAW_DATA A
                     JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD
                    WHERE A.YYYYMMDD >= P_NOW_YYYYMMDD AND A.YYYYMMDD <= P_TO_YYYYMMDD
                      AND A.MEASURE IN ('RTF_SYS_RP','MKT_FCST_RP','MKT_FCST','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW','Catch_Up','SCM_FCST')) A
              JOIN SCM_MGR.DM_PLN_CFM_SELLING_PRICE C
                ON A.DIVISION_ID        = C.DIVISION_ID
               AND A.PROJECT_CODE       = C.PROJECT_CODE
               AND A.SCM_SITE_ID        = C.SCM_SITE_ID
               AND A.CELL_PROD_SITE_ID  = C.CELL_PROD_SITE_ID
               AND A.PLANT_SITE_ID      = C.PLANT_SITE_ID
               AND A.ITEM_ID            = C.ITEM_ID
               AND A.INCOTERMS          = C.INCOTERMS
               AND A.DOM_EXP            = C.DOM_EXP
               AND A.FCST_TYPE          = C.FCST_TYPE
               AND A.BASIS_START_DATE   = C.YYYYMMDD
               AND C.YYYYMMDD          <= P_TO_YYYYMMDD
              JOIN SCM_MGR.GT_DM22_SELECT_MEASURE D ON C.MEASURE = D.MEASURE;
        ELSE
            INSERT /*+ NO_PARALLEL */ INTO SCM_MGR.GT_DM22_RAW_DATA
                (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
                 TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
            SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                   A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE,
                   A.YYYYMMDD, C.PRICE, 'P', A.CELL_PROD_SITE_ID
              FROM (SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                                    A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD,
                                    B.BASIS_START_DATE, A.CELL_PROD_SITE_ID
                     FROM SCM_MGR.GT_DM22_RAW_DATA A
                     JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD
                    WHERE A.YYYYMMDD >= P_NOW_YYYYMMDD AND A.YYYYMMDD <= P_TO_YYYYMMDD
                      AND A.MEASURE IN ('RTF_SYS_RP','MKT_FCST_RP','MKT_FCST','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW','Catch_Up','SCM_FCST')) A
              JOIN SCM_MGR.SCM_MST_FUTURE_PRICE C
                ON A.DIVISION_ID      = C.DIVISION_ID
               AND A.PROJECT_CODE     = C.PROJECT_CODE
               AND A.SCM_SITE_ID      = C.SCM_SITE_ID
               AND A.PLANT_SITE_ID    = C.PLANT_SITE_ID
               AND A.ITEM_ID          = C.ITEM_ID
               AND A.INCOTERMS        = C.INCOTERMS
               AND A.DOM_EXP          = C.DOM_EXP
               AND A.FCST_TYPE        = C.FCST_TYPE
               AND A.BASIS_START_DATE = C.YYYYMMDD
               AND C.YYYYMMDD        <= P_TO_YYYYMMDD
              JOIN SCM_MGR.GT_DM22_SELECT_MEASURE D ON C.MEASURE = D.MEASURE;
        END IF;

    END IF;

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A017--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    -----------------------------------------------------------------------------------------------------------------------------------
    -- 계획구간 CUTOFF 'KRW','LOC','USD' 단가 처리 (#T_PRICE)
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_exists FROM SCM_MGR.GT_DM22_SELECT_MEASURE WHERE MEASURE IN ('KRW','LOC','USD') AND ROWNUM = 1;

    IF v_exists > 0 AND P_VERSION_TYPE LIKE '%SP_%' THEN
        IF P_DIVISION_ID = '40' THEN
            INSERT /*+ NO_PARALLEL */ INTO SCM_MGR.GT_DM22_T_PRICE
                (DIVISION_ID, VERSION_NO, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD,
                 CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CELL_PROD_SITE_ID)
            SELECT A.DIVISION_ID, A.VERSION_NO, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD,
                   A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PRICE, A.CELL_PROD_SITE_ID
              FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
              JOIN SCM_MGR.GT_DM22_SELECT_MEASURE C ON A.MEASURE = C.MEASURE
              JOIN SCM_MGR.GT_DM22_V_VERSION_NO D ON A.VERSION_NO = D.VERSION_NO
              JOIN (SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                                    A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID
                      FROM SCM_MGR.GT_DM22_RAW_DATA A
                     WHERE A.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(A.CUTOFF_YYYYMMDD,'YYYYMMDD'),'MON')-7,'YYYYMMDD')
                       AND A.YYYYMMDD <= P_TO_YYYYMMDD
                       AND A.MEASURE IN ('RTF_SYS_RP','MKT_FCST_RP','MKT_FCST','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW','SCM_FCST')) B
                ON A.DIVISION_ID       = B.DIVISION_ID
               AND A.PROJECT_CODE      = B.PROJECT_CODE
               AND A.SCM_SITE_ID       = B.SCM_SITE_ID
               AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
               AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
               AND A.ITEM_ID           = B.ITEM_ID
               AND A.INCOTERMS         = B.INCOTERMS
               AND A.DOM_EXP           = B.DOM_EXP
               AND A.FCST_TYPE         = B.FCST_TYPE
             WHERE A.DIVISION_ID = P_DIVISION_ID
               AND A.YYYYMMDD   <= P_TO_YYYYMMDD;
        ELSE
            INSERT /*+ NO_PARALLEL */ INTO GT_DM22_T_PRICE
                (DIVISION_ID, VERSION_NO, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD,
                 CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CELL_PROD_SITE_ID)
            SELECT A.DIVISION_ID, A.VERSION_NO, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD,
                   A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PRICE, '-'
              FROM SCM_MGR.SCM_MST_FUTURE_PRICE_C A
              JOIN SCM_MGR.GT_DM22_SELECT_MEASURE C ON A.MEASURE = C.MEASURE
              JOIN SCM_MGR.GT_DM22_V_VERSION_NO D ON A.VERSION_NO = D.VERSION_NO
              JOIN (SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                                    A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD
                      FROM SCM_MGR.GT_DM22_RAW_DATA A
                     WHERE A.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(A.CUTOFF_YYYYMMDD,'YYYYMMDD'),'MON')-7,'YYYYMMDD')
                       AND A.YYYYMMDD <= P_TO_YYYYMMDD
                       AND A.MEASURE IN ('RTF_SYS_RP','MKT_FCST_RP','MKT_FCST','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW','SCM_FCST')) B
                ON A.DIVISION_ID   = B.DIVISION_ID
               AND A.PROJECT_CODE  = B.PROJECT_CODE
               AND A.SCM_SITE_ID   = B.SCM_SITE_ID
               AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
               AND A.ITEM_ID       = B.ITEM_ID
               AND A.INCOTERMS     = B.INCOTERMS
               AND A.DOM_EXP       = B.DOM_EXP
               AND A.FCST_TYPE     = B.FCST_TYPE
             WHERE A.DIVISION_ID  = P_DIVISION_ID
               AND A.YYYYMMDD    <= P_TO_YYYYMMDD;
        END IF;

        DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_T_PRICE',
            estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);

        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A018--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    -----------------------------------------------------------------------------------------------------------------------------------
    --[E20250529-001488]_같은소스를 사업부별로 나누어서 돌리는 이상한 구조의 상태로 확인되어, 분기친내용 주석처리하고 하나만 돌리도록 수정 원소스 주석 START
    -- 실제로 필요한 내용은 하단에 작성
    -----------------------------------------------------------------------------------------------------------------------------------
/*
    IF @p_division_id <> '82' AND @p_division_id <> '40'
    BEGIN
      INSERT INTO #RAW_DATA
      ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
      , TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
      , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
      SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
         , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD
         , C.PRICE, 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
      FROM ( SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
                 , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD
                 , B.BASIS_START_DATE, A.CELL_PROD_SITE_ID
          FROM #RAW_DATA A WITH(NOLOCK)
          JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD  \* 20240228 KCW3408 속도개선 *\
          -- [C20220304-000114] Sales Plan Waterfall 조회 시 Unit Price 누락 건 조치 요청
          WHERE A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112) AND A.YYYYMMDD <= @p_to_yyyymmdd
          AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'SCM_FCST' )  --[PJ2025-50188] SCM_FCST - MEASURE 추가
         ) A
      -- JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD    \* 20240228 KCW3408 속도개선 *\
      JOIN #T_PRICE C WITH(NOLOCK)
        ON A.DIVISION_ID    = C.DIVISION_ID
       AND A.PROJECT_CODE   = C.PROJECT_CODE
       AND A.SCM_SITE_ID    = C.SCM_SITE_ID
       AND A.PLANT_SITE_ID  = C.PLANT_SITE_ID
       AND A.ITEM_ID      = C.ITEM_ID
       AND A.INCOTERMS    = C.INCOTERMS
       AND A.DOM_EXP      = C.DOM_EXP
       AND A.FCST_TYPE    = C.FCST_TYPE
       AND A.BASIS_START_DATE = C.YYYYMMDD
       AND A.VERSION_NO   = C.VERSION_NO
      --  JOIN  #SELECT_MEASURE D WITH(NOLOCK)  ON C.MEASURE = D.MEASURE
    END
    ELSE IF @p_division_id = '82'
    BEGIN
      INSERT INTO #RAW_DATA
      ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
      , TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
      , QTY, PLAN_RESULT, CELL_PROD_SITE_ID  )
      SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
         , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD
         , C.PRICE, 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
      FROM ( SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
                 , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD
                 , B.BASIS_START_DATE, A.CELL_PROD_SITE_ID
          FROM #RAW_DATA A WITH(NOLOCK)
          JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD   \* 20240228 KCW3408 속도개선 *\
          -- [C20220304-000114] Sales Plan Waterfall 조회 시 Unit Price 누락 건 조치 요청
          WHERE A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112) AND A.YYYYMMDD <= @p_to_yyyymmdd
          AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'SCM_FCST' )  --[PJ2025-50188] SCM_FCST - MEASURE 추가
          ) A
      --JOIN SCM_SYS_CALENDAR_M B (NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD  \* 20240228 KCW3408 속도개선 *\
      JOIN #T_PRICE C WITH(NOLOCK)
        ON A.DIVISION_ID    = C.DIVISION_ID
      AND A.PROJECT_CODE    = C.PROJECT_CODE
      AND A.SCM_SITE_ID   = C.SCM_SITE_ID
      AND A.PLANT_SITE_ID   = C.PLANT_SITE_ID
      AND A.ITEM_ID     = C.ITEM_ID
      AND A.INCOTERMS     = C.INCOTERMS
      AND A.DOM_EXP     = C.DOM_EXP
      AND A.FCST_TYPE     = C.FCST_TYPE
      AND A.BASIS_START_DATE  = C.YYYYMMDD
      --[E20250529-001488]_순수 데이터로 JOIN한다 원소스 주석처리
      --AND SUBSTRING(A.VERSION_NO, 0, CHARINDEX('(',A.VERSION_NO)) = C.VERSION_NO --[E20230130-000233]
      AND A.VERSION_NO    = C.VERSION_NO
      \*AND CASE WHEN A.VERSION_NO LIKE '%(%' THEN SUBSTRING(A.VERSION_NO, 0, CHARINDEX('(',A.VERSION_NO))
           ELSE A.VERSION_NO  END = C.VERSION_NO --[E20230130-000233]해당 CSR로 반영한 것으로 정상 매핑되지 않는건 확인되어 20250522 SM 반영 *\
      -- JOIN #SELECT_MEASURE D ON C.MEASURE = D.MEASURE
    END
    ELSE IF @p_division_id = '40'
    BEGIN
      INSERT INTO #RAW_DATA
      ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
      , TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
      , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
      SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
         , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD
         , C.PRICE, 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
      FROM (  SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
                  , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD
                  , B.BASIS_START_DATE, A.CELL_PROD_SITE_ID
          FROM #RAW_DATA A WITH(NOLOCK)
          JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD   \* 20240228 KCW3408 속도개선 *\
          -- [C20220304-000114] Sales Plan Waterfall 조회 시 Unit Price 누락 건 조치 요청
          WHERE A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112) AND A.YYYYMMDD <= @p_to_yyyymmdd
          AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'SCM_FCST' ) --[PJ2025-50188] SCM_FCST - MEASURE 추가
         ) A
      --JOIN SCM_SYS_CALENDAR_M B (NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD  \* 20240228 KCW3408 속도개선 *\
      JOIN #T_PRICE C WITH(NOLOCK)
        ON A.DIVISION_ID    = C.DIVISION_ID
       AND A.PROJECT_CODE   = C.PROJECT_CODE
       AND A.SCM_SITE_ID    = C.SCM_SITE_ID
       AND A.PLANT_SITE_ID  = C.PLANT_SITE_ID
       AND A.ITEM_ID      = C.ITEM_ID
       AND A.INCOTERMS    = C.INCOTERMS
       AND A.DOM_EXP      = C.DOM_EXP
       AND A.FCST_TYPE    = C.FCST_TYPE
       AND A.BASIS_START_DATE = C.YYYYMMDD
       --[E20250529-001488]_순수 데이터로 JOIN한다 원소스 주석처리
       --AND SUBSTRING(A.VERSION_NO, 0, CHARINDEX('(',A.VERSION_NO))  = C.VERSION_NO --[E20230130-000233]
       AND A.VERSION_NO   = C.VERSION_NO
       \*AND CASE WHEN A.VERSION_NO LIKE '%(%' THEN SUBSTRING(A.VERSION_NO, 0, CHARINDEX('(',A.VERSION_NO))
                ELSE A.VERSION_NO  END = C.VERSION_NO --[E20230130-000233]해당 CSR로 반영한 것으로 정상 매핑되지 않는건 확인되어 20250522 SM 반영*\
       AND A.CELL_PROD_SITE_ID= C.CELL_PROD_SITE_ID
      -- JOIN #SELECT_MEASURE D ON C.MEASURE = D.MEASURE
    END
*/

        -- [E20250529-001488]_사업부별 분기 통합 버전
        INSERT /*+ NO_PARALLEL */ INTO GT_DM22_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
             TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
               A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD,
               C.PRICE, 'P', A.CELL_PROD_SITE_ID
          FROM (SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                                A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD,
                                B.BASIS_START_DATE, A.CELL_PROD_SITE_ID
                  FROM SCM_MGR.GT_DM22_RAW_DATA A
                  JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD  /* 20240228 KCW3408 속도개선 */
				          -- [C20220304-000114] Sales Plan Waterfall 조회 시 Unit Price 누락 건 조치 요청
                 WHERE A.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(A.CUTOFF_YYYYMMDD,'YYYYMMDD'),'MON')-7,'YYYYMMDD')
                   AND A.YYYYMMDD <= P_TO_YYYYMMDD
                   AND A.MEASURE IN ('RTF_SYS_RP','MKT_FCST_RP','MKT_FCST','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW','SCM_FCST')) A
		      -- JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD    /* 20240228 KCW3408 속도개선 */
          JOIN SCM_MGR.GT_DM22_T_PRICE C
            ON A.DIVISION_ID      = C.DIVISION_ID
           AND A.PROJECT_CODE     = C.PROJECT_CODE
           AND A.SCM_SITE_ID      = C.SCM_SITE_ID
           AND A.PLANT_SITE_ID    = C.PLANT_SITE_ID
           AND A.ITEM_ID          = C.ITEM_ID
           AND A.INCOTERMS        = C.INCOTERMS
           AND A.DOM_EXP          = C.DOM_EXP
           AND A.FCST_TYPE        = C.FCST_TYPE
           AND A.BASIS_START_DATE = C.YYYYMMDD
           AND A.VERSION_NO       = C.VERSION_NO;
    --  JOIN  #SELECT_MEASURE D WITH(NOLOCK)  ON C.MEASURE = D.MEASURE
    -----------------------------------------------------------------------------------------------------------------------------------
    --[E20250529-001488]_같은소스를 사업부별로 나누어서 돌리는 이상한 구조의 상태로 확인되어, 분기친내용 주석처리하고 하나만 돌리도록 수정 원소스 주석 END
    -- 실제로 필요한 내용은 하단에 작성
    -----------------------------------------------------------------------------------------------------------------------------------

    END IF;

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A019--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    -----------------------------------------------------------------------------------------------------------------------------------
    -- 필요없는 메저 삭제
    -----------------------------------------------------------------------------------------------------------------------------------
    DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
     WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_DM22_SELECT_MEASURE B WHERE A.MEASURE = B.MEASURE AND B.SYSTEM_ADD = 'Y');

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A019-1--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    -----------------------------------------------------------------------------------------------------------------------------------
    -- 파생 MEASURE 계산 (CAR, CELL, ENERGY 환산)
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_exists
      FROM SCM_MGR.GT_DM22_SELECT_MEASURE
     WHERE MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL','RTF_SYS_RP_CAR','RTF_SYS_RP_CELL','RTF_ENERGY','MKT_FCST_ENERGY')
       AND ROWNUM = 1;

    IF v_exists > 0 THEN
        INSERT /*+NO_PARALLEL */ INTO SCM_MGR.GT_DM22_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
             TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
               A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.MEASURE_CALC, A.YYYYMMDD,
               CASE WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CAR','RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
                        CASE WHEN INSTR(C.ITEM_CLASS_NAME,'Cell') > 0 AND D.CELL_PER_CAR > 0 THEN A.QTY / D.CELL_PER_CAR
                             WHEN INSTR(C.ITEM_CLASS_NAME,'Module') > 0 AND D.CELL_PER_CAR > 0 AND D.CELL_PER_MODULE > 0
                                  THEN A.QTY / (D.CELL_PER_CAR / D.CELL_PER_MODULE)
                             WHEN INSTR(C.ITEM_CLASS_NAME,'Pack') > 0 THEN A.QTY
                             ELSE 0 END
                    WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID LIKE '81%' THEN
                        CASE WHEN INSTR(C.ITEM_CLASS_NAME,'Cell') > 0 AND D.CELL_PER_CAR > 0 THEN A.QTY
                             WHEN (INSTR(C.ITEM_CLASS_NAME,'Module') > 0 OR INSTR(C.ITEM_CLASS_NAME,'Pack') > 0)
                                  AND D.CELL_PER_MODULE > 0 THEN A.QTY * D.CELL_PER_MODULE
                             ELSE 0 END
                    WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID = '82'
                        THEN A.QTY * C.CELL_QUANTITY
                    -- 20211119 ROSIA27 [C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건
                    WHEN B.MEASURE_CALC = 'RTF_ENERGY' THEN
   --[E20260910-ENERGE] AS-IS 참조 컬럼 복원: ENERGE_WH(원본 WH) → ENERGE(KWH 환산분). AS-IS L3387/L3393 및 PKG_DMF0021 L1275 동형.
                        CASE WHEN TO_NUMBER(C.ENERGE DEFAULT NULL ON CONVERSION ERROR) IS NOT NULL THEN (A.QTY * TO_NUMBER(C.ENERGE)) / 1000 ELSE NULL END
                    -- 20221214 rosia27 [C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
                    WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND B.MEASURE_ORI = 'RTF_SYS_RP' AND A.PLAN_RESULT = 'R' THEN
   --[E20260910-ENERGE] AS-IS 참조 컬럼 복원: ENERGE_WH(원본 WH) → ENERGE(KWH 환산분). AS-IS L3387/L3393 및 PKG_DMF0021 L1275 동형.
                        CASE WHEN TO_NUMBER(C.ENERGE DEFAULT NULL ON CONVERSION ERROR) IS NOT NULL THEN (TO_NUMBER(C.ENERGE) * A.QTY) / 1000 ELSE NULL END
                    ELSE 0
               END,
               A.PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM SCM_MGR.GT_DM22_RAW_DATA A
          JOIN (SELECT CASE WHEN A.MEASURE LIKE 'MKT_FCST_RP%' THEN 'MKT_FCST_RP' ELSE 'RTF_SYS_RP' END AS MEASURE_ORI,
                       A.MEASURE AS MEASURE_CALC
                  FROM SCM_MGR.GT_DM22_SELECT_MEASURE A
                 WHERE MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL','RTF_SYS_RP_CAR','RTF_SYS_RP_CELL','RTF_ENERGY','MKT_FCST_ENERGY')) B
                ON A.MEASURE = B.MEASURE_ORI
          JOIN SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID AND A.DIVISION_ID = C.DIVISION_ID
          LEFT OUTER JOIN SCM_MGR.GT_DM22_SCM_MST_SITE_ITEM D
                       ON A.DIVISION_ID  = D.DIVISION_ID
                      AND A.SCM_SITE_ID  = D.SCM_SITE_ID
                      AND A.PROJECT_CODE = D.PROJECT_CODE
                      AND A.ITEM_ID      = D.ITEM_ID
         WHERE A.MEASURE IN ('MKT_FCST_RP','RTF_SYS_RP');

    END IF;

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A020--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    -----------------------------------------------------------------------------------------------------------------------------------
    -- MKT_FCST_ENERGY 계획구간 처리
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_exists FROM SCM_MGR.GT_DM22_SELECT_MEASURE WHERE MEASURE = 'MKT_FCST_ENERGY' AND ROWNUM = 1;
    IF v_exists > 0 THEN
        INSERT /*+ NO_PARALLEL */ INTO GT_DM22_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
             TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
               A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.MEASURE_CALC, A.YYYYMMDD,
               CASE WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND A.PLAN_RESULT = 'P' THEN
   --[E20260910-ENERGE] AS-IS 참조 컬럼 복원: ENERGE_WH(원본 WH) → ENERGE(KWH 환산분). AS-IS L3387/L3393 및 PKG_DMF0021 L1275 동형.
                        CASE WHEN TO_NUMBER(C.ENERGE DEFAULT NULL ON CONVERSION ERROR) IS NOT NULL THEN (TO_NUMBER(C.ENERGE) * A.QTY)/1000 ELSE NULL END
                    ELSE 0 END,
               A.PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM SCM_MGR.GT_DM22_RAW_DATA A
          JOIN (SELECT 'MKT_FCST_RP' AS MEASURE_ORI, A.MEASURE AS MEASURE_CALC
                  FROM SCM_MGR.GT_DM22_SELECT_MEASURE A WHERE MEASURE = 'MKT_FCST_ENERGY') B ON A.MEASURE = B.MEASURE_ORI
          JOIN SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID AND A.DIVISION_ID = C.DIVISION_ID
         WHERE A.MEASURE = 'MKT_FCST_RP';

    END IF;

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A021--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

/*
    --########클로드가 변환하면서 임의로 만든 로직이라서 주석  처리#######
    -----------------------------------------------------------------------------------------------------------------------------------
    -- [PJ2024-50611] 소형 매출 프로세스 개선 (40사업부 RTF 기반 재배포)
    -----------------------------------------------------------------------------------------------------------------------------------
    IF P_DIVISION_ID = '40' THEN
        -- RTF_SYS_RP 등 계획구간 삭제 후 DM_PLN_SALES_PLAN 기반으로 재적재
        -- (CURRENT / SP 버전 분기)
        --COMMIT; -- 위 INSERT들 확정
        -- 세부 로직 생략 없이 원본과 동일하게 유지
        -- (원본 2109~2430라인 로직은 구조가 동일하므로 CURRENT/SP 분기 그대로 구현)
        -- CURRENT
        IF UPPER(P_VERSION_TYPE) LIKE '%CURRENT%' THEN  --[E20260831-VERCASE] MSSQL CI 콜레이션 1:1 — 'Current' 등 대소문자 변형 흡수
            -- 1) MEASURE IN (...) 계획구간 삭제
            DELETE FROM SCM_MGR.GT_DM22_RAW_DATA
             WHERE DIVISION_ID = P_DIVISION_ID
               AND MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_IN_PLAN','AS_IN_PLAN','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD','SCM_FCST')
               AND YYYYMMDD >= P_NOW_YYYYMMDD
               AND ITEM_ID NOT IN (SELECT DISTINCT ITEM_ID FROM SCM_MGR.DM_PLN_SALES_ETC_PLAN
                                    WHERE DIVISION_ID = P_DIVISION_ID AND FCST_TYPE = 'ETC'
                                      AND YYYYMMDD >= P_NOW_YYYYMMDD
                                      AND ITEM_ID NOT IN (SELECT ITEM_ID FROM SCP_MST_FINAL_ITEM WHERE DIVISION_ID = P_DIVISION_ID));

            -- 2) DM_PLN_SALES_PLAN 기반 재적재
            INSERT \*+ NO_PARALLEL *\ INTO SCM_MGR.GT_DM22_RAW_DATA
                (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
                 TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID)
            SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, B.PLANT_SITE_ID, A.ITEM_ID,
                   A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE,
                   B.YYYYMMDD, B.QTY, A.VALID_YN, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
              FROM (SELECT DISTINCT VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID,
                                    ITEM_ID, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID,
                                    MEASURE, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID
                      FROM SCM_MGR.GT_DM22_RAW_DATA
                     WHERE DIVISION_ID = P_DIVISION_ID
                       AND MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_IN_PLAN','AS_IN_PLAN','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD','SCM_FCST')
                       AND YYYYMMDD >= P_NOW_YYYYMMDD) A
             INNER JOIN SCM_MGR.DM_PLN_SALES_PLAN B
                     ON A.DIVISION_ID       = B.DIVISION_ID
                    AND A.PROJECT_CODE      = B.PROJECT_CODE
                    AND A.SCM_SITE_ID       = B.SCM_SITE_ID
                    AND A.ITEM_ID           = B.ITEM_ID
                    AND A.INCOTERMS         = B.INCOTERMS
                    AND A.DOM_EXP           = B.DOM_EXP
                    AND A.FCST_TYPE         = B.FCST_TYPE
                    AND A.MEASURE           = B.MEASURE
                    AND B.YYYYMMDD         >= P_NOW_YYYYMMDD
                    AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID;

        ELSIF P_VERSION_TYPE LIKE '%SP%' THEN
            -- SP 버전도 동일 구조로 DM_PLN_SALES_PLAN_C 사용
            DELETE FROM SCM_MGR.GT_DM22_RAW_DATA
             WHERE DIVISION_ID = P_DIVISION_ID
               AND MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_IN_PLAN','AS_IN_PLAN','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD','SCM_FCST')
               AND YYYYMMDD >= P_NOW_YYYYMMDD
               AND ITEM_ID NOT IN (SELECT DISTINCT ITEM_ID FROM SCM_MGR.DM_PLN_SALES_ETC_PLAN
                                    WHERE DIVISION_ID = P_DIVISION_ID AND FCST_TYPE = 'ETC'
                                      AND YYYYMMDD >= P_NOW_YYYYMMDD
                                      AND ITEM_ID NOT IN (SELECT ITEM_ID FROM SCP_MST_FINAL_ITEM WHERE DIVISION_ID = P_DIVISION_ID));

            INSERT \*+ NO_PARALLEL *\ INTO SCM_MGR.GT_DM22_RAW_DATA
                (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
                 TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID)
            SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, B.PLANT_SITE_ID, A.ITEM_ID,
                   A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE,
                   B.YYYYMMDD, B.QTY, A.VALID_YN, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
              FROM (SELECT DISTINCT VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID,
                                    ITEM_ID, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID,
                                    MEASURE, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID
                      FROM SCM_MGR.GT_DM22_RAW_DATA
                     WHERE DIVISION_ID = P_DIVISION_ID
                       AND MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_IN_PLAN','AS_IN_PLAN','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD','SCM_FCST')
                       AND YYYYMMDD >= P_NOW_YYYYMMDD) A
             INNER JOIN SCM_MGR.DM_PLN_SALES_PLAN_C B
                     ON A.DIVISION_ID       = B.DIVISION_ID
                    AND A.VERSION_NO        = B.VERSION_NO
                    AND A.CUTOFF_YYYYMMDD   = B.CUTOFF_YYYYMMDD
                    AND A.PROJECT_CODE      = B.PROJECT_CODE
                    AND A.SCM_SITE_ID       = B.SCM_SITE_ID
                    AND A.ITEM_ID           = B.ITEM_ID
                    AND A.INCOTERMS         = B.INCOTERMS
                    AND A.DOM_EXP           = B.DOM_EXP
                    AND A.FCST_TYPE         = B.FCST_TYPE
                    AND A.MEASURE           = B.MEASURE
                    AND B.YYYYMMDD         >= P_NOW_YYYYMMDD
                    AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID;

        END IF;
    END IF;*/


    ------------------------------------------------------------------------------------------
    -- 컬럼리스트 만들고, MKT FCST 와 비슷한 방식으로, CTE 로 데이터를 만들고, CTE SELECT 문에 컬럼리스트 삽입한다.
    -- 컬럼리스트 생성 START
    ------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------
    -- 날짜컬럼 생성
    ------------------------------------------------------------------------------------------
    V_PV_LIST     := '';
    V_PV_COL_LIST := '';

    FOR r IN (
        SELECT COLUMN_NAME, PV_NAME, SORT_ORDER_NO
          FROM (
                   -- DAILY
                   SELECT '''D_' || A.BASIS_YYYYMMDD || '''  AS D_' || A.BASIS_YYYYMMDD AS COLUMN_NAME,
                          'D_' || A.BASIS_YYYYMMDD || ' ' AS PV_NAME,
                          A.BASIS_YYYYMMDD || '_' || TO_CHAR(31, 'FM00') AS SORT_ORDER_NO
                     FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                    WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                      AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                      AND P_BUCKET = 'DAILY'
                   UNION ALL
                   -- WEEKLY
                   SELECT '''W_' || A.BASIS_YYYYMM || A.ISO_WEEK || '''  AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK,
                          'W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ' ',
                          A.BASIS_START_DATE || '_' || TO_CHAR(21, 'FM00')
                     FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                    WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                      AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                      AND P_BUCKET <> 'ONLY_WEEKLY'
                    GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                   UNION ALL
                   -- MONTHLY
                   SELECT '''M_' || A.BASIS_YYYYMM || '''  AS M_' || A.BASIS_YYYYMM,
                          'M_' || A.BASIS_YYYYMM || ' ',
                          MIN(A.BASIS_START_DATE) || '_' || TO_CHAR(1, 'FM00')
                     FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                    WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                      AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                      AND P_BUCKET <> 'ONLY_WEEKLY'
                    GROUP BY A.BASIS_YYYYMM
                   UNION ALL
                   -- [C20220620-000567] ONLY_WEEKLY (Partial week)
                   SELECT '''W_' || SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK || '''  AS W_' || SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK,
                          'W_' || SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK || ' ',
                          MAX(BASIS_YYYYMMDD) || '_' || TO_CHAR(21, 'FM00')
                     FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                    WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                      AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                      AND P_BUCKET = 'ONLY_WEEKLY'
                    GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME
               )
         ORDER BY SORT_ORDER_NO
    ) LOOP
        IF V_PV_COL_LIST IS NOT NULL AND LENGTH(V_PV_COL_LIST) > 0 THEN
            V_PV_COL_LIST := V_PV_COL_LIST || ',' || r.COLUMN_NAME || CHR(10);
            V_PV_LIST     := V_PV_LIST     || ',' || r.PV_NAME || CHR(10);
        ELSE
            V_PV_COL_LIST := r.COLUMN_NAME || CHR(10);
            V_PV_LIST     := r.PV_NAME || CHR(10);
        END IF;
    END LOOP;
		------------------------------------------------------------------------------------------
		-- 날짜컬럼 생성 END
		------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- 20240228 KCW3408 속도개선_템프사용 START
    ------------------------------------------------------------------------------------------
    -- #TEMP_SCM_MST_SITE 구성
    INSERT /*+ NO_PARALLEL */ INTO SCM_MGR.GT_DM22_SCM_MST_SITE
        (SCM_SITE_ID, DIVISION_ID, PROJECT_CODE, ITEM_ID, DEPT_ID, SOLDTO_CODE, VMI_YN, END_CUSTOMER, CITY_NAME, COUNTRY_NAME, SHIPTO_DESCRIPTION, SOLDTO_DESCRIPTION)
    SELECT B.SCM_SITE_ID, B.DIVISION_ID, B.PROJECT_CODE, B.ITEM_ID, B.DEPT_ID, K.SOLDTO_CODE, B.VMI_YN, B.END_CUSTOMER,
           H.CITY_NAME, J.COUNTRY_NAME, L.SHIPTO_DESCRIPTION, L.SOLDTO_DESCRIPTION
      FROM (SELECT A.DIVISION_ID, A.SCM_SITE_ID, B.PROJECT_CODE, B.ITEM_ID, B.DEPT_ID, A.END_CUSTOMER, A.VMI_YN, A.CITY, A.COUNTRY
              FROM SCM_MGR.SCM_MST_SITE A
                   LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM B
                        ON A.DIVISION_ID = B.DIVISION_ID
                       AND A.SCM_SITE_ID = B.SCM_SITE_ID
             WHERE 1=1
               --[E20260820-D22PREREDUCE] hook #129 ④ 선행축소 — 이 GTT 의 유일한 소비처(최종 동적 SQL L3516)는
               --  GT_DM22_RAW_DATA 와 (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID) 로 LEFT JOIN 하므로
               --  RAW_DATA 에 (DIVISION_ID, SCM_SITE_ID) 가 없는 행은 결과에 기여할 수 없다.
               --  L2681 이후의 RAW_DATA 적재문은 모두 RAW_DATA/TEMP40_KEY/RTF_ENERGY 파생이라 SITE 집합이 늘지 않는다.
               --  실측(사내 2026-08-20): 필터 전무로 조회 사업부와 무관하게 항상 118,322행 적재.
               AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DM22_RAW_DATA R
                            WHERE R.DIVISION_ID = A.DIVISION_ID
                              AND R.SCM_SITE_ID = A.SCM_SITE_ID)
             GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, B.PROJECT_CODE, B.ITEM_ID, B.DEPT_ID, A.END_CUSTOMER, A.VMI_YN, A.CITY, A.COUNTRY
           ) B
      LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_CUSTOMER K ON B.DIVISION_ID = K.DIVISION_ID AND B.SCM_SITE_ID = K.SCM_SITE_ID AND K.REP_YN = 'Y'
      LEFT OUTER JOIN SCM_MGR.SCM_MST_CITY H ON B.CITY = H.CITY
      LEFT OUTER JOIN SCM_MGR.SCM_MST_COUNTRY J ON B.COUNTRY = J.COUNTRY
      LEFT OUTER JOIN SCM_MGR.SCM_MST_CUSTOMER L ON K.DIVISION_ID = L.DIVISION_ID AND K.SHIPTO_CODE = L.SHIPTO_CODE AND K.SOLDTO_CODE = L.SOLDTO_CODE;

    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_SCM_MST_SITE',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);
    ------------------------------------------------------------------------------------------
    -- 20240228 KCW3408 속도개선_템프사용 END
    ------------------------------------------------------------------------------------------

    --#TEMP_DM_MST_ITEM_SINGLE_V_T 구성
    INSERT /*+ NO_PARALLEL */ INTO SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V_T
          (DIVISION_ID
          ,ITEM_ID
          ,ITEM_NAME
          ,ITEM_CLASS
          ,ITEM_CLASS_NAME
          ,NICK_NAME
          ,ITEM_TYPE
          ,MATERIAL_CLASS_NAME
          ,ITEM_UOM
          ,SPEC
          ,MDM_PROJECT_NAME
          ,MIN_CAPACITY
          ,FORECAST_INFO_BIZ_TYPE
          ,FORECAST_INFO_PRODUCT_GROUP
          ,FORECAST_INFO_CELL_MODEL
          ,FORECAST_INFO_CELL_PACK_COUNT
          ,FORECAST_INFO_SPEC
          ,FORECAST_INFOR_VERSION
          ,ACTIVE_FLAG
          ,CELL_TYPE
          ,CELL_QUANTITY
          ,SCP_EXTRA_SPEC
          ,ENERGE_WH
          ,ENERGE
          ,SEGMENT2
          ,CELL_MODEL_NICK_NAME
          )
    SELECT D.DIVISION_ID
          ,D.ITEM_ID
          ,D.ITEM_NAME
          ,D.ITEM_CLASS
          ,D.ITEM_CLASS_NAME
          ,D.NICK_NAME
          ,D.ITEM_TYPE
          ,D.MATERIAL_CLASS_NAME
          ,D.ITEM_UOM
          ,D.SPEC
          ,D.MDM_PROJECT_NAME
          ,D.MIN_CAPACITY
          ,D.FORECAST_INFO_BIZ_TYPE
          ,D.FORECAST_INFO_PRODUCT_GROUP
          ,D.FORECAST_INFO_CELL_MODEL
          ,D.FORECAST_INFO_CELL_PACK_COUNT
          ,D.FORECAST_INFO_SPEC
          ,D.FORECAST_INFOR_VERSION
          ,D.ACTIVE_FLAG
          ,D.CELL_TYPE
          ,D.CELL_QUANTITY
          ,D.SCP_EXTRA_SPEC
          ,D.ENERGE_WH
          ,D.ENERGE
          ,E.SEGMENT2
          ,NVL(F.NICK_NAME,'') AS CELL_MODEL_NICK_NAME
    FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V D
    LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL E
           ON D.CELL_TYPE = E.SEGMENT1
          AND E.LOOKUP_TYPE = 'CELL_TYPE'
    LEFT OUTER JOIN SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V F
           ON D.DIVISION_ID = F.DIVISION_ID
          AND NVL(D.FORECAST_INFO_CELL_MODEL,'@#@#@#') = F.ITEM_ID
    ;

    -----------------------------------------------------------------------------------------------------------------------------------
    --[E20250529-001488]_버전작업은 마지막에서 해주는것으로 변경한다 (82 사업부만 해당한다) START
    -----------------------------------------------------------------------------------------------------------------------------------
    IF P_DIVISION_ID = '82' THEN
        UPDATE SCM_MGR.GT_DM22_V_VERSION_NO A
           SET A.TOBE_VERSION_NO =
               (SELECT CASE WHEN C.DM_RTF_YN = 'N' THEN A.VERSION_NO || '(' || B.WEEK_NAME || ') (NO PLAN)'
                            ELSE A.VERSION_NO || '(' || B.WEEK_NAME || ')' END
                  FROM SCM_MGR.SCM_SYS_CALENDAR_M B, SCM_MGR.SCP_PLN_INTERFACE_YN C
                 WHERE SUBSTR(A.VERSION_NO, 6, 8) = B.BASIS_YYYYMMDD
                   AND C.DIVISION_ID = P_DIVISION_ID
                   AND B.BASIS_START_DATE = C.PLAN_START_YYYYMMDD
                   AND ROWNUM = 1);

        UPDATE SCM_MGR.GT_DM22_RAW_DATA A
           SET A.VERSION_NO =
               (SELECT B.TOBE_VERSION_NO
                  FROM SCM_MGR.GT_DM22_V_VERSION_NO B
                 WHERE A.VERSION_NO = B.VERSION_NO
                   AND B.TOBE_VERSION_NO IS NOT NULL
                   AND ROWNUM = 1)
         WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_DM22_V_VERSION_NO B
                        WHERE A.VERSION_NO = B.VERSION_NO AND B.TOBE_VERSION_NO IS NOT NULL);

    END IF;
    -----------------------------------------------------------------------------------------------------------------------------------
    --[E20250529-001488]_버전작업은 마지막에서 해주는것으로 변경한다 (82 사업부만 해당한다) END
    -----------------------------------------------------------------------------------------------------------------------------------


    ------------------------------------------------------------------------------------------
    -- 컬럼리스트 생성
    ------------------------------------------------------------------------------------------
    SELECT COUNT(*)
      INTO i_count
      FROM SCM_MGR.SCM_MST_TITLESET_USER U
     WHERE U.PROGRAM_ID                     = v_program_id
       AND U.SHEET_NAME                     = v_sheet_name
       AND U.USER_ID                        = P_CREATED_BY
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE  = 'C';

    IF i_count = 0 THEN
        FOR r IN (
            SELECT C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
              FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
             WHERE C.PROGRAM_ID   = v_program_id
               AND C.SHEET_NAME   = v_sheet_name
               AND (C.DEFAULT_FLAG = 'Y' OR (C.VISIBLE_FLAG = 'N' AND RTRIM(C.DEFAULT_FLAG, ' -') IS NULL AND C.VALID_YN = 'Y'))  --[E20260831-W34] AS-IS DEFAULT_FLAG='' 숨은컬럼 arm — ''=NULL(' '/'-' 흡수) 정정
             ORDER BY SORT_ORDER_NO
        ) LOOP
            IF v_ColList IS NOT NULL AND LENGTH(v_ColList) > 0 THEN
                v_ColList   := v_ColList   || ',' || r.COLUMN_NAME || ' ';
                v_OrderList := v_OrderList || ',' || r.COLUMN_NAME || ' ' || r.DATA_SORT_METHOD_CODE;
            ELSE
                v_ColList   := ' ' || r.COLUMN_NAME || ' ';
                v_OrderList := ' ' || r.COLUMN_NAME || '  ' || r.DATA_SORT_METHOD_CODE;
            END IF;
        END LOOP;
    ELSE
        FOR r IN (
            SELECT CASE WHEN C.COLUMN_NAME = 'GROUP_ID'
                        THEN NVL(TU.SORT_ORDER_NO, 95) - 0.5
                        ELSE U.SORT_ORDER_NO END AS SORT_ORDER_NO,
                   C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE
              FROM SCM_MGR.SCM_MST_TITLESET_USER U
             INNER JOIN SCM_MGR.SCM_MST_SHEET_COLUMNS C
                     ON U.PROGRAM_ID  = C.PROGRAM_ID
                    AND U.SHEET_NAME  = C.SHEET_NAME
                    AND U.COLUMN_NAME = C.COLUMN_NAME
                    AND U.PROGRAM_ID  = v_program_id
                    AND U.SHEET_NAME  = v_sheet_name
                    AND U.USER_ID     = P_CREATED_BY
                    AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    --[E20260910-PERSDIV] 개인화 컬럼목록에 DIVISION 필터 적용.
    --  근거: AS-IS 동일 화면군의 DMF0051 은 이 조건이 LIVE 다([C20221107-000343] BP Waterfall 오류 수정).
    --        AS-IS DMF0022 는 같은 조건을 2019-01-25 주석처리했으나(KHSONG), MSSQL 은 #TEMP 에 전 컬럼이
    --        물리적으로 존재해 무해했다. Oracle 은 컬럼목록을 사전(GT_..._T_COLUMN_SETUP)과 조인해
    --        SELECT 를 만들므로, 타 DIVISION 전용 컬럼이 개인화에 남아 있으면 ORA-00904 로 조회가 통째로 실패한다.
    --  표시축 영향 없음(실측): 82 그리드/엑셀 헤더는 AS-IS·TO-BE 모두 PLANT_SITE_ID/FROM_SITE_ID/
    --        CELL_PROD_SITE_ID/END_CUSTOMER40 를 표시하지 않는다 — 데이터에만 실려 있던 미사용 컬럼이다.
                    AND P_DIVISION_ID IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(C.DIVISION_ID, ',')) P)
              LEFT OUTER JOIN SCM_MGR.SCM_MST_TITLESET_USER TU
                           ON TU.PROGRAM_ID = C.PROGRAM_ID
                          AND TU.SHEET_NAME = C.SHEET_NAME
                          AND TU.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                          AND TU.COLUMN_NAME = 'ITEM_ID'
                          AND TU.USER_ID = P_CREATED_BY
            UNION ALL
            SELECT C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
              FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
             WHERE C.PROGRAM_ID   = v_program_id
               AND C.SHEET_NAME   = v_sheet_name
               AND C.VISIBLE_FLAG = 'N'
               AND RTRIM(C.DEFAULT_FLAG, ' -') IS NULL  --[E20260831-W34] AS-IS DEFAULT_FLAG='' 숨은컬럼 arm — ''=NULL(' '/'-' 흡수) 정정
               AND C.VALID_YN     = 'Y'
            ORDER BY SORT_ORDER_NO
        ) LOOP
            IF v_ColList IS NOT NULL AND LENGTH(v_ColList) > 0 THEN
                v_ColList   := v_ColList   || ',' || r.COLUMN_NAME || ' ' || CHR(10);
                v_OrderList := v_OrderList || ',' || r.COLUMN_NAME || '  ' || r.DATA_SORT_METHOD_CODE || CHR(10);
            ELSE
                v_ColList   := ' ' || r.COLUMN_NAME || ' ' || CHR(10);
                v_OrderList := ' ' || r.COLUMN_NAME || ' ' || r.DATA_SORT_METHOD_CODE || CHR(10);
            END IF;
        END LOOP;
    END IF;

    --------------------------------------------------------------------------------------------
    --[E20231128-000738][마케팅PI] 82번 사업부 SCM.DM 메져별 숫자표기 방식 변경 - Sales Plan, Sales Plan Waterfall
    --------------------------------------------------------------------------------------------
    v_ColList   := v_ColList || ',NOTATION';

    --[E20260910-MEASURECOL] MEASURE 컬럼 보장 — PKG_DMF0035 [E20260909-MEASURECOL] 과 동일 방식.
    --  아래 집계부가 F.MEASURE 를 **무조건** 참조하는데(KRW/USD/LOC 는 AVG, 나머지는 SUM),
    --  T_DM22_WF 의 SELECT 는 개인화 컬럼목록(v_ColList)을 사전과 조인해 만든다.
    --  [E20260831-W34] 로 CTE 의 고정 A.MEASURE 선택을 제거한 뒤로는 개인화에 MEASURE 가 없으면
    --  MEASURE 가 아예 생성되지 않아 ORA-00904 "F"."MEASURE" 로 조회가 통째로 실패한다.
    --  (클라우드 div82 SALES PLAN 실패 → 사내에서 개인화 MEASURE 행 제거로 동일 재현, 2026-09-10)
    --  MEASURE 는 개인화 모달에 노출되지 않는 축이므로 사용자 선택과 무관하게 항상 보장한다.
    --  이미 목록에 있으면 덧붙이지 않는다([E20260831-W34] 가 잡은 ORA-00918 중복 회귀 방지).
    IF INSTR(',' || REPLACE(REPLACE(v_ColList, ' ', ''), CHR(10), '') || ',', ',MEASURE,') = 0 THEN
        v_ColList := v_ColList || ',MEASURE';
    END IF;
    v_ColList   := REPLACE(v_ColList,   'VERSION_NO', 'VERSION_SORT,VERSION_NO');
    v_OrderList := REPLACE(v_OrderList, 'VERSION_NO', 'VERSION_SORT DESC,VERSION_NO');
    v_OrderList := REPLACE(v_OrderList, 'MEASURE',    'SORT_ORDER_NO,MEASURE');

    -- ColList, OrderList 마지막 콤마 제거는 Oracle에서는 불필요 (앞에서 콤마 붙이는 방식으로 처리됨)

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A022--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    -----------------------------------------------------------------------------------------------------------------------------------
    -- CTE에서 사용할 SELECT COLUMN 정리 (#T_COLUMN_SETUP)
    -----------------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','VERSION_NO','A.VERSION_NO',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','DIVISION_ID','A.DIVISION_ID',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','PROJECT_CODE','A.PROJECT_CODE',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','SCM_SITE_ID','A.SCM_SITE_ID',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','PLANT_SITE_ID','A.PLANT_SITE_ID',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','GROUP_ID','NVL(I.GROUP_ID,'' '') AS GROUP_ID',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','ITEM_ID','A.ITEM_ID',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','TEXT','CASE WHEN LENGTH(A.TEXT) = 0 THEN '' '' ELSE A.TEXT END AS TEXT',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','INCOTERMS','A.INCOTERMS',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','DOM_EXP','A.DOM_EXP',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','FCST_TYPE','A.FCST_TYPE',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','MEASURE','A.MEASURE',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','END_CUSTOMER40','A.PROJECT_CODE AS END_CUSTOMER40',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','INTERNAL_YN','CASE WHEN LENGTH(A.SCM_SITE_ID) > 2 AND LENGTH(A.SCM_SITE_ID) < 6 THEN ''Y'' ELSE ''N'' END AS INTERNAL_YN',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','YYYYMMDD','A.YYYYMMDD',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','QTY','A.QTY',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','VERSION_SORT','CASE WHEN A.VERSION_NO = ''CURRENT'' THEN ''ZZZZZZZZZZZZZZZ'' ELSE A.VERSION_NO END AS VERSION_SORT',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('B','VMI_YN','B.VMI_YN',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('B','END_CUSTOMER','B.END_CUSTOMER',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('AC','CURRENCY','CASE WHEN A.CURRENCY IS NOT NULL THEN A.CURRENCY ELSE C.CURRENCY END AS CURRENCY',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','CELL_PROD_SITE_ID','A.CELL_PROD_SITE_ID',1);
    --[E20260910-FROMSITE] AS-IS 사전 항목 복원 (AS-IS DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL L2078).
    --  변환 시 이 1건이 누락되어, 메타(SCM_MST_SHEET_COLUMNS DMF0022/DMF0035 'Sales Plan Waterfall')에는
    --  FROM_SITE_ID 가 등록돼 있는데 사전에 없어 SELECT 목록에서는 빠지고 ORDER BY 에만 남았다
    --  → ORA-00904 "FROM_SITE_ID". (div82 SALES PLAN 조회 실패 실사고 2026-09-10)
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','FROM_SITE_ID','CASE WHEN NVL(A.CELL_PROD_SITE_ID,''-'') = ''-'' THEN ''N/A'' ELSE A.CELL_PROD_SITE_ID END AS FROM_SITE_ID',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('ABC','DEPT_ID','CASE WHEN A.FCST_TYPE = ''ETC'' THEN CASE WHEN A.DIVISION_ID = ''40'' THEN A.ATTRIBUTE1 ELSE B.DEPT_ID END ELSE C.DEPT_ID END AS DEPT_ID',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','APPLICATION','C.APPLICATION',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','CUST_GROUP','C.CUST_GROUP',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','OWNER','C.OWNER_NAME AS OWNER',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','ROUTE','C.ROUTE',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','CUST_GROUP_DTL','C.CUST_GROUP_DTL',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','CELL_PER_CAR','C.CELL_PER_CAR',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','CELL_PER_MODULE','C.CELL_PER_MODULE',1);
    --[E20260910-COMPANYID] AS-IS 폴백 조건 파리티 복원.
    --  AS-IS: CASE WHEN ISNULL(A.COMPANY_ID,'') = '' THEN C.SALES_COMPANY ELSE A.COMPANY_ID END  (L2016)
    --    MSSQL 의 = '' 는 NULL·''·전부공백을 모두 참으로 잡는다(패딩 비교).
    --  구 TO-BE: NVL(A.COMPANY_ID,'@#@#@#') = '@#@#@#'  → **NULL 일 때만** 참.
    --  실측(div40): AS-IS 공백 611,354 / '-' 0  vs  TO-BE 공백 0 / '-' 610,994 (실값은 양쪽 445,238 동일)
    --    = 이관 시 공백이 센티널 '-' 로 정규화되어, 구 조건은 폴백이 전혀 발동하지 않았다.
    --    그 결과 COMPANY_ID 가 '-' 로 남아 키가 갈리고 AS-IS 대비 행이 분리됨(실사고 2026-09-10).
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('AC','COMPANY_ID','CASE WHEN NVL(TRIM(A.COMPANY_ID),''-'') = ''-'' THEN C.SALES_COMPANY ELSE A.COMPANY_ID END AS COMPANY_ID',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','MODULE_PER_CAR','CASE WHEN C.CELL_PER_MODULE <> 0 THEN C.CELL_PER_CAR / C.CELL_PER_MODULE ELSE 0 END AS MODULE_PER_CAR',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','DMS_SALES','NVL(C.ATTRIBUTE1,'''') AS DMS_SALES',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','DMS_CUSTOMER','NVL(C.ATTRIBUTE2,'''') AS DMS_CUSTOMER',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','FORECAST_INFO_CELL_MODEL','C.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','PRIORITY','C.ATTRIBUTE7 AS PRIORITY',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','KWH_CELL','C.ATTRIBUTE8 AS KWH_CELL',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','REPORT_GROUP6','NVL(C.REPORT_GROUP6,'''') AS REPORT_GROUP6',1);
    --[E20260910-KWHNUM] KWH_MODULE/KWH_PACK 의 ATTRIBUTE8 숫자변환 안전화.
    --  기존 가드는 NULL 여부만 본다(AS-IS ISNULL(ATTRIBUTE8,'')<>'' 동형). 값이 비숫자면
    --  TO_NUMBER 가 ORA-01722 를 던져 조회 전체가 실패한다(클라우드 82 실측: '#' 포함 문자열).
    --  사내 82 는 ATTRIBUTE8 이 전건 NULL 이라 무증상이었다(39,572/39,572 실측).
    --  숫자면 값 동일, 비숫자면 0 (사용자 지시 2026-09-10) — 참조 컬럼·산식 불변, 예외만 제거한다.
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('AC','KWH_MODULE','CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_MODULE > 0 AND NVL(C.ATTRIBUTE8,''@#@#@#'') <> ''@#@#@#'' THEN (C.CELL_PER_MODULE * TO_NUMBER(C.ATTRIBUTE8 DEFAULT 0 ON CONVERSION ERROR)) ELSE NULL END AS KWH_MODULE',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('AC','KWH_PACK','CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_CAR > 0 AND NVL(C.ATTRIBUTE8,''@#@#@#'') <> ''@#@#@#'' THEN (C.CELL_PER_CAR * TO_NUMBER(C.ATTRIBUTE8 DEFAULT 0 ON CONVERSION ERROR)) ELSE NULL END AS KWH_PACK',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','FORECAST_INFO_CELL_PACK_COUNT','D.FORECAST_INFO_CELL_PACK_COUNT',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','BIZ_TYPE_NAME40','D.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','FORECAST_INFO_PRODUCT_GROUP','D.FORECAST_INFO_PRODUCT_GROUP',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','ENERGE','D.ENERGE',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','ENERGE_WH','D.ENERGE_WH',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','CELL_QUANTITY','D.CELL_QUANTITY',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','ITEM_CLASS_NAME','NVL(D.ITEM_CLASS_NAME,'''') AS ITEM_CLASS_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','ITEM_NAME','NVL(D.ITEM_NAME,'''') AS ITEM_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','ITEM_TYPE','NVL(D.ITEM_TYPE,'''') AS ITEM_TYPE',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','NICK_NAME','NVL(D.NICK_NAME,'''') AS NICK_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','MIN_CAPACITY','D.MIN_CAPACITY',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','FORECAST_INFO_ALL','D.FORECAST_INFO_SPEC || D.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','FORECAST_INFO_SPEC','D.FORECAST_INFO_SPEC',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','FORECAST_INFOR_VERSION','D.FORECAST_INFOR_VERSION',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','MDM_PROJECT_NAME','D.MDM_PROJECT_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','CELL_TYPE','D.SEGMENT2 AS CELL_TYPE',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','CELL_MODEL_NICK_NAME','D.CELL_MODEL_NICK_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('G','BIZ_TYPE_NAME','G.BIZ_TYPE AS BIZ_TYPE_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('G','PROJECT_NAME','G.PROJECT_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('G','PROJECT_OWNER','G.PROJECT_OWNER',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('G','PROJECT_STATUS','G.PROJECT_STATUS',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('G','PRODUCT_GROUP_NAME','G.PRODUCT_GROUP_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('B','CITY_NAME','B.CITY_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('B','COUNTRY_NAME','B.COUNTRY_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('B','SHIPTO_DESCRIPTION','B.SHIPTO_DESCRIPTION',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('M','SORT_ORDER_NO','M.SORT_ORDER_NO',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','SALES_COMPANY','C.SALES_COMPANY',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('B','SOLDTO_CODE','B.SOLDTO_CODE',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('B','SOLDTO_DESCRIPTION','B.SOLDTO_DESCRIPTION',1); --[E20230410-000032] 20230420추가
		------------------------------------------------------------------------------------------
		--[E20231128-000738][마케팅PI] 82번 사업부 SCM.DM 메져별 숫자표기 방식 변경 - Sales Plan, Sales Plan Waterfall START
		------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('O','SEGMENT3','NVL(O.SEGMENT3,''DEFAULT'') AS NOTATION',1);
    ------------------------------------------------------------------------------------------
    --[E20231128-000738][마케팅PI] 82번 사업부 SCM.DM 메져별 숫자표기 방식 변경 - Sales Plan, Sales Plan Waterfall END
    ------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------
    --[E20250423-000842]_[공급생산 SCM PI팀] Sales Plan 화면 'SCP Use' 칼럼 추가 START
    ------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','SCP_USE_YN',
        'CASE WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE IN (''VMI_In_Req'',''VMI_In_Plan'') THEN ''Y'' '||
        'WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''N'' AND A.MEASURE IN (''MKT_FCST_RP'',''MKT_FCST'',''RTF'',''RTF_SCP'',''RTF_SYS_RP'',''RTF_PR'') THEN ''Y'' '||
        'ELSE ''N'' END AS SCP_USE_YN',1);
		------------------------------------------------------------------------------------------
		--[E20250423-000842]_[공급생산 SCM PI팀] Sales Plan 화면 'SCP Use' 칼럼 추가 END
		------------------------------------------------------------------------------------------

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A023--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));


    -- #T (컬럼순서) 구성 (UF_FX_String_Split 대체: REGEXP)

    --[E20260910-GRAINFIX] 사용자 지시(2026-09-10, 안 B): 구 [E20260828-ALLCOLS] 블록 **제거**.
    --  그 블록은 UI CATEGORY 의 사업부 매칭 VALID 컬럼을 컬럼목록 뒤에 덧붙여 FE OLAP 의 '필드 후보'로
    --  쓰게 했는데, 이 목록은 그대로 SELECT/GROUP BY/PIVOT 축이 되므로 **표시되지 않는 컬럼이 집계
    --  grain 을 쪼갰다**. 실사고: 클라우드 DMF0035 div81 조회 AS-IS 1,080행 vs TO-BE 1,094행(+14).
    --  14행 전부가 신규 키가 아니라 기존 키의 분할이고 기간별 합계·전체 총합(296,093,862)은 양측 동일 =
    --  누락/중복 없는 순수 grain 차이였다. 실적표(DM_PLN_MKT_FCST_RESULT)와 계획표(DM_PLN_MKT_FCST)의
    --  PLANT_SITE_ID/PROJECT_CODE/AS_FROM_SITE 등이 달라 같은 키가 실적행·계획행으로 갈렸다.
    --  AS-IS(DMF0035_GET_MKT_FCST_WATERFALL)에는 이런 확장 블록이 없다(전수 0건) — GROUP BY 축은
    --  오직 표시 컬럼([@V_COLUMN] = titleset 'C')이다. 파리티 회복을 위해 제거한다.
    INSERT INTO SCM_MGR.GT_DM22_T (COLUMN_STRING, SEQ)
    SELECT B.COLUMN_STRING, ROW_NUMBER() OVER (ORDER BY B.SORT_KEY) AS SEQ
      FROM (
               SELECT TRIM(REPLACE(REPLACE(REPLACE(TOKEN, '[', ''), ']', ''),CHR(10),'')) AS TOKEN
                 FROM (
                          SELECT TRIM(REGEXP_SUBSTR(v_ColList, '[^,]+', 1, LEVEL)) AS TOKEN
                            FROM DUAL
                          CONNECT BY REGEXP_SUBSTR(v_ColList, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
           ) A
      JOIN SCM_MGR.GT_DM22_T_COLUMN_SETUP B ON A.TOKEN = B.COLUMN_NAME;

    SELECT COUNT(*) INTO v_CNT FROM SCM_MGR.GT_DM22_T;
    V_SQL_SELECT  := '';
    V_SQL_GROUPBY := '';
    v_I := 1;

    WHILE v_I <= v_CNT LOOP
        DECLARE
            v_col_str VARCHAR2(1000 CHAR);
        BEGIN
            SELECT COLUMN_STRING INTO v_col_str FROM SCM_MGR.GT_DM22_T WHERE SEQ = v_I;
            V_SQL_SELECT  := V_SQL_SELECT  || CASE WHEN v_I = 1 THEN '' ELSE ',' END || v_col_str || CHR(10) ;
            V_SQL_GROUPBY := V_SQL_GROUPBY || CASE WHEN v_I = 1 THEN '' ELSE ',' END
                             || CASE WHEN INSTR(UPPER(v_col_str), ' AS ') > 0
                                     THEN SUBSTR(v_col_str, 1, INSTR(UPPER(v_col_str), ' AS ') - 1)
                                     ELSE v_col_str END  || CHR(10) ;
        END;
        v_I := v_I + 1;
    END LOOP;


    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A024--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    ------------------------------------------------------------------------------------------
    -- [PJ2024-50611] 소형 매출 프로세스 개선
    ------------------------------------------------------------------------------------------
    IF p_division_id = '40' THEN

        ------------------------------------------------------------------------------------------
        -- 1) #RAW_DATA_FINAL 의 Measure = 'RTF_SYS_RP / RTF_SCP'가 있는 것은 삭제한다. 단, 계획구간에서만
        ------------------------------------------------------------------------------------------
        INSERT /*+ NO_PARALLEL */ INTO SCM_MGR.GT_DM22_RAW_DATA_TEMP40
              (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
              ,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
              ,YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID  )
        SELECT VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
              ,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
              ,YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID
        FROM  SCM_MGR.GT_DM22_RAW_DATA
        WHERE DIVISION_ID = p_division_id
        AND   MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_IN_PLAN','AS_IN_PLAN','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD', 'SCM_FCST') --[PJ2025-50188] SCM_FCST - MEASURE 추가
        AND   YYYYMMDD   >= p_now_yyyymmdd
        ;


        INSERT /*+ NO_PARALLEL */ INTO SCM_MGR.GT_DM22_RAW_DATA_TEMP40_KEY
              (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
              ,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
              ,VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID)
        SELECT VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
              ,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
              ,VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID
        FROM   SCM_MGR.GT_DM22_RAW_DATA_TEMP40
        GROUP BY VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, TEXT
             , INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID
        ;
        ------------------------------------------------------------------------------------------
        -- 기타매출은 제외하고 삭제함. (기타매출은 RTF에 없기 때문에 기존 SalesPlan 데이터 유지
        ------------------------------------------------------------------------------------------
        DELETE SCM_MGR.GT_DM22_RAW_DATA
        WHERE  DIVISION_ID = p_division_id
        AND    MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_IN_PLAN','AS_IN_PLAN','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD', 'SCM_FCST') --[PJ2025-50188] SCM_FCST - MEASURE 추가
        AND    YYYYMMDD   >= p_now_yyyymmdd
        ------------------------------------------------------------------------------------------
        -- 기타매출은 제외하고 삭제
        ------------------------------------------------------------------------------------------
        AND   ITEM_ID NOT IN (  SELECT DISTINCT ITEM_ID
                                --FROM DM_PLN_SALES_PLAN Z
                                FROM SCM_MGR.DM_PLN_SALES_ETC_PLAN Z  --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
                                WHERE Z.DIVISION_ID = p_division_id
                                AND   Z.FCST_TYPE = 'ETC'
                                AND   Z.YYYYMMDD >= p_now_yyyymmdd
                                AND   Z.ITEM_ID NOT IN ( SELECT ITEM_ID
                                             FROM SCM_MGR.SCP_MST_FINAL_ITEM
                                             WHERE DIVISION_ID = p_division_id ))
        ;

        IF ( UPPER(p_version_type) LIKE '%CURRENT%' ) THEN  --[E20260831-VERCASE] MSSQL CI 콜레이션 1:1 — 'Current' 등 대소문자 변형 흡수

            ------------------------------------------------------------------------------------------
            -- 2-1) #RAW_DATA_FINAL 에 DM_PLN_SALES_PLAN 기반으로 PLAN_SITE_ID 및 YYYYMMDD/QTY를 입력한다.
            --[PJ2025-50017] CELL_PROD_SITE_ID 컬럼이 추가된 테이블 변경
            --DM_PLN_RTF_ALLOCATION   -> DM_PLN_SALES_PLAN
            --DM_PLN_RTF_ALLOCATION_C -> DM_PLN_SALES_PLAN_C
            ------------------------------------------------------------------------------------------
            INSERT /*+ NO_PARALLEL */ INTO GT_DM22_RAW_DATA
                  ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                  , TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
                  , YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID)
            SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, B.PLANT_SITE_ID, A.ITEM_ID
                 , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE
                 , B.YYYYMMDD, B.QTY, A.VALID_YN, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
            FROM  SCM_MGR.GT_DM22_RAW_DATA_TEMP40_KEY A
                  INNER JOIN SCM_MGR.DM_PLN_SALES_PLAN B
                      ON 1=1
                       AND A.DIVISION_ID    = B.DIVISION_ID
                       AND A.PROJECT_CODE   = B.PROJECT_CODE
                       AND A.SCM_SITE_ID    = B.SCM_SITE_ID
                       AND A.ITEM_ID        = B.ITEM_ID
                       AND A.INCOTERMS      = B.INCOTERMS
                       AND A.DOM_EXP        = B.DOM_EXP
                       AND A.FCST_TYPE      = B.FCST_TYPE
                       AND A.MEASURE        = B.MEASURE
                       AND B.YYYYMMDD       >= p_now_yyyymmdd
                       AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
            ;

            --UPDATE A
            --SET   A.PLANT_SITE_ID = B.PLANT_SITE_ID
            --  , A.FROM_SITE_ID  = B.FROM_SITE_ID
            --FROM  #RAW_DATA A WITH(NOLOCK)
            --INNER JOIN DM_PLN_RTF_ALLOCATION B WITH(NOLOCK)
            --ON 1=1
            -- AND  A.DIVISION_ID   = B.DIVISION_ID
            -- AND  A.PROJECT_CODE  = B.PROJECT_CODE
            -- AND  A.SCM_SITE_ID   = B.SCM_SITE_ID
            -- AND  A.ITEM_ID     = B.ITEM_ID
            -- AND  A.INCOTERMS   = B.INCOTERMS
            -- AND  A.DOM_EXP     = B.DOM_EXP
            -- AND  A.FCST_TYPE   = B.FCST_TYPE
            -- AND  A.MEASURE     = 'RTF_ENERGY'
            -- AND  B.MEASURE     = 'RTF_SCP'
            -- AND  A.YYYYMMDD    = B.YYYYMMDD
            -- AND  A.YYYYMMDD    >= @p_now_yyyymmdd
            -- AND  B.YYYYMMDD    >= @p_now_yyyymmdd
            --;


            INSERT /*+ NO_PARALLEL */ INTO SCM_MGR.GT_DM22_RTF_ENERGY
                  (VERSION_NO
                  ,CUTOFF_YYYYMMDD
                  ,DIVISION_ID
                  ,PROJECT_CODE
                  ,SCM_SITE_ID
                  ,PLANT_SITE_ID
                  ,ITEM_ID
                  ,TEXT
                  ,INCOTERMS
                  ,DOM_EXP
                  ,FCST_TYPE
                  ,CURRENCY
                  ,COMPANY_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  ,VALID_YN
                  ,PLAN_RESULT
                  ,ATTRIBUTE1
                  ,CELL_PROD_SITE_ID
                  )
            SELECT VERSION_NO
                  ,CUTOFF_YYYYMMDD
                  ,DIVISION_ID
                  ,PROJECT_CODE
                  ,SCM_SITE_ID
                  ,PLANT_SITE_ID
                  ,ITEM_ID
                  ,TEXT
                  ,INCOTERMS
                  ,DOM_EXP
                  ,FCST_TYPE
                  ,CURRENCY
                  ,COMPANY_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  ,VALID_YN
                  ,PLAN_RESULT
                  ,ATTRIBUTE1
                  ,CELL_PROD_SITE_ID
            FROM  SCM_MGR.GT_DM22_RAW_DATA A
            WHERE A.DIVISION_ID = p_division_id
            AND   A.MEASURE   = 'RTF_ENERGY';

            DELETE SCM_MGR.GT_DM22_RAW_DATA
            WHERE DIVISION_ID = p_division_id
            AND   MEASURE = 'RTF_ENERGY';

            ------------------------------------------------------------------------------------------
            --[PJ2025-50017] CELL_PROD_SITE_ID 컬럼이 추가된 테이블 변경
            --DM_PLN_RTF_ALLOCATION   -> DM_PLN_SALES_PLAN
            --DM_PLN_RTF_ALLOCATION_C -> DM_PLN_SALES_PLAN_C
            ------------------------------------------------------------------------------------------
            INSERT /*+ NO_PARALLEL */ INTO SCM_MGR.GT_DM22_RAW_DATA
                    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS
                    , DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY
                    , VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID )
            SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, B.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS
                    , A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE, B.YYYYMMDD, A.QTY
                    , A.VALID_YN, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
            FROM  SCM_MGR.GT_DM22_RTF_ENERGY A
            INNER JOIN SCM_MGR.DM_PLN_SALES_PLAN B
                ON 1=1
                 AND A.PROJECT_CODE   = B.PROJECT_CODE
                 AND A.DIVISION_ID    = B.DIVISION_ID
                 AND A.SCM_SITE_ID    = B.SCM_SITE_ID
                 AND A.PLANT_SITE_ID  = B.PLANT_SITE_ID
                 AND A.ITEM_ID        = B.ITEM_ID
                 AND A.INCOTERMS      = B.INCOTERMS
                 AND A.DOM_EXP        = B.DOM_EXP
                 AND A.FCST_TYPE      = B.FCST_TYPE
                 AND A.YYYYMMDD       = B.YYYYMMDD
                 AND A.MEASURE        = 'RTF_ENERGY'
                 AND B.MEASURE        = 'RTF_SYS_RP'
                 AND B.YYYYMMDD       >= p_now_yyyymmdd
                 AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID;

            MERGE INTO SCM_MGR.GT_DM22_RAW_DATA A
            USING ( SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP
                        , A.FCST_TYPE, A.YYYYMMDD, A.QTY, B.SUM_QTY, A.CELL_PROD_SITE_ID
                    FROM SCM_MGR.GT_DM22_RAW_DATA A
                        INNER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, YYYYMMDD, SUM(QTY) AS SUM_QTY, CELL_PROD_SITE_ID
                                    FROM SCM_MGR.GT_DM22_RAW_DATA
                                    WHERE DIVISION_ID = p_division_id
                                    AND   VERSION_NO  = p_version_type
                                    AND   MEASURE   = 'RTF_SYS_RP'
                                    AND   YYYYMMDD     >= p_now_yyyymmdd
                                    GROUP BY DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, YYYYMMDD, CELL_PROD_SITE_ID ) B
                            ON 1=1
                             AND A.DIVISION_ID    = B.DIVISION_ID
                             AND A.PROJECT_CODE   = B.PROJECT_CODE
                             AND A.SCM_SITE_ID    = B.SCM_SITE_ID
                             AND A.PLANT_SITE_ID  = B.PLANT_SITE_ID
                             AND A.ITEM_ID        = B.ITEM_ID
                             AND A.INCOTERMS      = B.INCOTERMS
                             AND A.DOM_EXP        = B.DOM_EXP
                             AND A.FCST_TYPE      = B.FCST_TYPE
                             AND A.YYYYMMDD       = B.YYYYMMDD
                    WHERE A.DIVISION_ID       = p_division_id
                    AND   A.VERSION_NO        = p_version_type
                    AND   A.MEASURE           = 'RTF_SYS_RP'
                    AND   A.YYYYMMDD         >= p_now_yyyymmdd
                    AND   A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                 ) B
              ON ( 1 = 1
               AND A.DIVISION_ID    = B.DIVISION_ID
               AND A.PROJECT_CODE   = B.PROJECT_CODE
               AND A.SCM_SITE_ID    = B.SCM_SITE_ID
               AND A.PLANT_SITE_ID    = B.PLANT_SITE_ID
               AND A.ITEM_ID      = B.ITEM_ID
               AND A.INCOTERMS      = B.INCOTERMS
               AND A.DOM_EXP      = B.DOM_EXP
               AND A.FCST_TYPE      = B.FCST_TYPE
               AND A.YYYYMMDD     = B.YYYYMMDD
               AND A.MEASURE      = 'RTF_ENERGY'
               AND A.CELL_PROD_SITE_ID  = B.CELL_PROD_SITE_ID )
            WHEN MATCHED THEN
            UPDATE SET A.QTY = A.QTY * (B.QTY/B.SUM_QTY);

        ELSIF ( p_version_type LIKE '%SP%') THEN

            ------------------------------------------------------------------------------------------
            -- 2-2) #RAW_DATA_FINAL 에 DM_PLN_SALES_PLAN_C 기반으로 PLAN_SITE_ID 및 YYYYMMDD/QTY를 입력한다.
            --[PJ2025-50017] CELL_PROD_SITE_ID 컬럼이 추가된 테이블 변경
            --DM_PLN_RTF_ALLOCATION   -> DM_PLN_SALES_PLAN
            --DM_PLN_RTF_ALLOCATION_C -> DM_PLN_SALES_PLAN_C
            ------------------------------------------------------------------------------------------
            INSERT /*+ NO_PARALLEL */ INTO SCM_MGR.GT_DM22_RAW_DATA
                  ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                  , TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
                  , YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID)
            SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, B.PLANT_SITE_ID, A.ITEM_ID
                 , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE
                 , B.YYYYMMDD, B.QTY, A.VALID_YN, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
            FROM  SCM_MGR.GT_DM22_RAW_DATA_TEMP40_KEY A
            INNER JOIN SCM_MGR.DM_PLN_SALES_PLAN_C B
                ON 1=1
                 AND  A.DIVISION_ID     = B.DIVISION_ID
                 AND  A.VERSION_NO      = B.VERSION_NO
                 AND  A.CUTOFF_YYYYMMDD = B.CUTOFF_YYYYMMDD
                 AND  A.PROJECT_CODE    = B.PROJECT_CODE
                 AND  A.SCM_SITE_ID     = B.SCM_SITE_ID
                 AND  A.ITEM_ID         = B.ITEM_ID
                 AND  A.INCOTERMS       = B.INCOTERMS
                 AND  A.DOM_EXP         = B.DOM_EXP
                 AND  A.FCST_TYPE       = B.FCST_TYPE
                 AND  A.MEASURE         = B.MEASURE
                 AND  B.YYYYMMDD        >= p_now_yyyymmdd
                 --[E20260820-D22VERPUSH] hook #129 ②/④ — B 에 access 술어가 없어 계획이
                 --  HASH JOIN + TABLE ACCESS FULL DM_PLN_SALES_PLAN_C(3,710,755행/88,637블록) 로 뒤집힌다
                 --  (사내 실측 disk 91,969 / 0.861s, SQL_ID 0jg5q91v6uvm9). A(GT_DM22_RAW_DATA_TEMP40_KEY)는
                 --  DIVISION_ID = p_division_id 로 제한되고, A.VERSION_NO = B.VERSION_NO 이며 _C 에는
                 --  VERSION_NO='CURRENT' 행이 0건(실측)이므로 아래 두 술어는 결과 등가이며
                 --  IX_DM_PLN_SALES_PLAN_C_N3(VERSION_NO,DIVISION_ID,YYYYMMDD,MEASURE,CUTOFF_YYYYMMDD) 선두를 연다.
                 AND  B.DIVISION_ID     = p_division_id
                 AND  B.VERSION_NO IN (SELECT V.VERSION_NO FROM SCM_MGR.GT_DM22_V_VERSION_NO V)
                 AND  A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID;

            --UPDATE A
            --SET   A.PLANT_SITE_ID = B.PLANT_SITE_ID
            --  , A.FROM_SITE_ID  = B.FROM_SITE_ID
            --FROM  #RAW_DATA A WITH(NOLOCK)
            --INNER JOIN DM_PLN_RTF_ALLOCATION_C B WITH(NOLOCK)
            --ON 1=1
            -- AND  A.VERSION_NO    = B.VERSION_NO
            -- AND  A.CUTOFF_YYYYMMDD = B.CUTOFF_YYYYMMDD
            -- AND  A.DIVISION_ID   = B.DIVISION_ID
            -- AND  A.PROJECT_CODE  = B.PROJECT_CODE
            -- AND  A.SCM_SITE_ID   = B.SCM_SITE_ID
            -- AND  A.ITEM_ID     = B.ITEM_ID
            -- AND  A.INCOTERMS   = B.INCOTERMS
            -- AND  A.DOM_EXP     = B.DOM_EXP
            -- AND  A.FCST_TYPE   = B.FCST_TYPE
            -- AND  A.MEASURE     = 'RTF_ENERGY'
            -- AND  B.MEASURE     = 'RTF_SCP'
            -- AND  A.YYYYMMDD    = B.YYYYMMDD
            -- AND  A.YYYYMMDD    >= @p_now_yyyymmdd
            -- AND  B.YYYYMMDD    >= @p_now_yyyymmdd
            --;

            INSERT /*+ NO_PARALLEL */ INTO SCM_MGR.GT_DM22_RTF_ENERGY
                  (VERSION_NO
                  ,CUTOFF_YYYYMMDD
                  ,DIVISION_ID
                  ,PROJECT_CODE
                  ,SCM_SITE_ID
                  ,PLANT_SITE_ID
                  ,ITEM_ID
                  ,TEXT
                  ,INCOTERMS
                  ,DOM_EXP
                  ,FCST_TYPE
                  ,CURRENCY
                  ,COMPANY_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  ,VALID_YN
                  ,PLAN_RESULT
                  ,ATTRIBUTE1
                  ,CELL_PROD_SITE_ID
                  )
            SELECT VERSION_NO
                  ,CUTOFF_YYYYMMDD
                  ,DIVISION_ID
                  ,PROJECT_CODE
                  ,SCM_SITE_ID
                  ,PLANT_SITE_ID
                  ,ITEM_ID
                  ,TEXT
                  ,INCOTERMS
                  ,DOM_EXP
                  ,FCST_TYPE
                  ,CURRENCY
                  ,COMPANY_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  ,VALID_YN
                  ,PLAN_RESULT
                  ,ATTRIBUTE1
                  ,CELL_PROD_SITE_ID
            FROM  SCM_MGR.GT_DM22_RAW_DATA A
            WHERE A.DIVISION_ID = p_division_id
            AND   A.MEASURE   = 'RTF_ENERGY';

            DELETE SCM_MGR.GT_DM22_RAW_DATA
            WHERE DIVISION_ID = p_division_id
            AND   MEASURE = 'RTF_ENERGY';


            ------------------------------------------------------------------------------------------
            --[PJ2025-50017] CELL_PROD_SITE_ID 컬럼이 추가된 테이블 변경
            --DM_PLN_RTF_ALLOCATION   -> DM_PLN_SALES_PLAN
            --DM_PLN_RTF_ALLOCATION_C -> DM_PLN_SALES_PLAN_C
            ------------------------------------------------------------------------------------------
            INSERT /*+ NO_PARALLEL */ INTO GT_DM22_RAW_DATA
                    ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                    , TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
                    , YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID)
            SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, B.PLANT_SITE_ID, A.ITEM_ID
                    , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE
                    , B.YYYYMMDD, A.QTY, A.VALID_YN, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
            FROM  SCM_MGR.GT_DM22_RTF_ENERGY A
            INNER JOIN SCM_MGR.DM_PLN_SALES_PLAN_C B
                ON 1=1
                 AND A.DIVISION_ID      = B.DIVISION_ID
                 AND A.VERSION_NO       = B.VERSION_NO
                 AND A.CUTOFF_YYYYMMDD  = B.CUTOFF_YYYYMMDD
                 AND A.PROJECT_CODE     = B.PROJECT_CODE
                 AND A.SCM_SITE_ID      = B.SCM_SITE_ID
                 AND A.PLANT_SITE_ID    = B.PLANT_SITE_ID
                 AND A.ITEM_ID          = B.ITEM_ID
                 AND A.INCOTERMS        = B.INCOTERMS
                 AND A.DOM_EXP          = B.DOM_EXP
                 AND A.FCST_TYPE        = B.FCST_TYPE
                 AND A.YYYYMMDD         = B.YYYYMMDD
                 AND A.MEASURE          = 'RTF_ENERGY'
                 AND B.MEASURE          = 'RTF_SYS_RP'
                 AND B.YYYYMMDD         >= p_now_yyyymmdd
                 --[E20260820-D22VERPUSH] hook #129 ②/④ — 동일 결함(GT_DM22_RTF_ENERGY 조인 경로).
                 --  A(GT_DM22_RTF_ENERGY)는 적재 시 WHERE A.DIVISION_ID = p_division_id 로 제한된다.
                 AND B.DIVISION_ID      = p_division_id
                 AND B.VERSION_NO IN (SELECT V.VERSION_NO FROM SCM_MGR.GT_DM22_V_VERSION_NO V)
                 AND A.CELL_PROD_SITE_ID  = B.CELL_PROD_SITE_ID;

            MERGE INTO SCM_MGR.GT_DM22_RAW_DATA A
            USING ( SELECT DISTINCT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
                              , A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.YYYYMMDD, A.QTY, B.SUM_QTY
                        , ROUND(CASE WHEN B.SUM_QTY  <> 0 THEN A.QTY / B.SUM_QTY ELSE 0 END , 9) AS RATIO -- 2025.01.23 0 나누기 오류 수정
                        --, ROUND(A.QTY/B.SUM_QTY, 9) AS RATIO
                        , A.CELL_PROD_SITE_ID
                    FROM SCM_MGR.GT_DM22_RAW_DATA A
                    INNER JOIN (  SELECT DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, YYYYMMDD, SUM(QTY) AS SUM_QTY, CELL_PROD_SITE_ID
                                  FROM SCM_MGR.GT_DM22_RAW_DATA
                                  WHERE DIVISION_ID = p_division_id
                                  AND   MEASURE     = 'RTF_SYS_RP'
                                  AND   YYYYMMDD    >= p_now_yyyymmdd
                                  GROUP BY  DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, YYYYMMDD, CELL_PROD_SITE_ID ) B
                        ON 1=1
                         AND  A.DIVISION_ID     = B.DIVISION_ID
                         AND  A.VERSION_NO      = B.VERSION_NO
                         AND  A.CUTOFF_YYYYMMDD = B.CUTOFF_YYYYMMDD
                         AND  A.PROJECT_CODE    = B.PROJECT_CODE
                         AND  A.SCM_SITE_ID     = B.SCM_SITE_ID
                         AND  A.PLANT_SITE_ID   = B.PLANT_SITE_ID
                         AND  A.ITEM_ID         = B.ITEM_ID
                         AND  A.INCOTERMS       = B.INCOTERMS
                         AND  A.DOM_EXP         = B.DOM_EXP
                         AND  A.FCST_TYPE       = B.FCST_TYPE
                         AND  A.YYYYMMDD        = B.YYYYMMDD
                    WHERE A.DIVISION_ID         = p_division_id
                    AND   A.MEASURE             = 'RTF_SYS_RP'
                    AND   A.YYYYMMDD           >= p_now_yyyymmdd
                    AND   A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
               ) B
               ON ( 1=1
                  AND A.DIVISION_ID       = B.DIVISION_ID
                  AND A.VERSION_NO        = B.VERSION_NO
                  AND A.CUTOFF_YYYYMMDD   = B.CUTOFF_YYYYMMDD
                  AND A.PROJECT_CODE      = B.PROJECT_CODE
                  AND A.SCM_SITE_ID       = B.SCM_SITE_ID
                  AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
                  AND A.ITEM_ID           = B.ITEM_ID
                  AND A.INCOTERMS         = B.INCOTERMS
                  AND A.DOM_EXP           = B.DOM_EXP
                  AND A.FCST_TYPE         = B.FCST_TYPE
                  AND A.YYYYMMDD          = B.YYYYMMDD
                  AND A.MEASURE           = 'RTF_ENERGY'
                  AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID )
            WHEN MATCHED THEN
            UPDATE SET A.QTY = A.QTY * B.RATIO--(B.QTY / B.SUM_QTY)-- 2025.01.23 0 나누기 오류 수정
            ;
        END IF;
    END IF;

    ------------------------------------------------------------------------------------------
    --[E20250529-001488]_버전작업은 마지막에서 해주는것으로 변경한다 (82 사업부만 해당한다) START
    ------------------------------------------------------------------------------------------
    IF (p_division_id= '82') THEN

        MERGE INTO SCM_MGR.GT_DM22_V_VERSION_NO A
        USING (
            SELECT A.VERSION_NO,
                   CASE
                       WHEN C.DM_RTF_YN = 'N' THEN A.VERSION_NO || '(' || B.WEEK_NAME || ') (NO PLAN)'
                       ELSE A.VERSION_NO || '(' || B.WEEK_NAME || ')'
                   END AS TOBE_VERSION_NO
            FROM SCM_MGR.GT_DM22_V_VERSION_NO A
            INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M B
                ON SUBSTR(A.VERSION_NO, 6, 8) = B.BASIS_YYYYMMDD
            LEFT JOIN SCM_MGR.SCP_PLN_INTERFACE_YN C
                ON C.DIVISION_ID = p_division_id
                AND B.BASIS_START_DATE = C.PLAN_START_YYYYMMDD
        ) B
        ON (A.VERSION_NO = B.VERSION_NO)
        WHEN MATCHED THEN
            UPDATE SET A.TOBE_VERSION_NO = B.TOBE_VERSION_NO
        ;

        UPDATE SCM_MGR.GT_DM22_RAW_DATA A
        SET A.VERSION_NO = (
                            SELECT B.TOBE_VERSION_NO
                            FROM SCM_MGR.GT_DM22_V_VERSION_NO B
                            WHERE A.VERSION_NO = B.VERSION_NO
                           )
        WHERE EXISTS (
            SELECT 1
            FROM SCM_MGR.GT_DM22_V_VERSION_NO B
            WHERE A.VERSION_NO = B.VERSION_NO
        );
    END IF;
    ------------------------------------------------------------------------------------------
    --[E20250529-001488]_버전작업은 마지막에서 해주는것으로 변경한다 (82 사업부만 해당한다) END
    ------------------------------------------------------------------------------------------

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A025--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    -- #CALENDAR 구성
    INSERT /*+ NO_PARALLEL */ INTO SCM_MGR.GT_DM22_CALENDAR
        (BASIS_YYYYMMWW, ISO_YYYYWW, ISO_WEEK, BASIS_YYYYMMDD, END_FLAG, BASIS_YYYYMM)
    SELECT A.BASIS_YYYYMMWW, A.ISO_YYYYWW, A.ISO_WEEK, B.BASIS_YYYYMMDD, B.END_FLAG, B.BASIS_YYYYMM
      FROM (SELECT SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK AS BASIS_YYYYMMWW, ISO_YYYYWW, ISO_WEEK
              FROM SCM_MGR.SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
               AND BASIS_YYYYMMDD <= P_TO_YYYYMMDD
             GROUP BY ISO_YYYYWW, ISO_WEEK) A
      JOIN SCM_MGR.SCM_SYS_CALENDAR_M B
        ON A.ISO_YYYYWW = B.ISO_YYYYWW
       AND A.ISO_WEEK   = B.ISO_WEEK;


    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A026--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_CALENDAR',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);


    -- QTY 처리 방식 분기
    IF P_CELL_YN = 'Y' THEN
        v_sql_text := 'WITH T_DM22_WF AS ('
                      || 'SELECT FN_GET_DM_SALES_PLAN_WATERFALL_QTY2('
                      || 'A.MEASURE, NVL(D.ITEM_CLASS_NAME,'''')'
                      || ', NVL(A.QTY,0)'
                      || ', NVL(C.CELL_PER_CAR,0)'
                      || ', NVL(C.CELL_PER_MODULE,0)'
                      || ', ''Y'''
                      || ', NVL(D.FORECAST_INFO_CELL_PACK_COUNT, 0)'
                      || ', ''' || P_DIVISION_ID || ''', NVL(D.FORECAST_INFO_BIZ_TYPE, '''')'
                      || ') AS QTY ';
    ELSIF P_DIVISION_ID = '82' THEN
        -- [E20230619-000151] MSSQL: CONVERT(float,FORMAT(A.QTY,'##0.##########')) → Oracle: TO_NUMBER(TO_CHAR(A.QTY,'FM99999999990.9999999999'))
        v_sql_text := 'WITH T_DM22_WF AS ('
          --[E20260910-QTYMASK] 82 전용 QTY 변환 — 고정폭 포맷마스크 제거.
    --  AS-IS: CONVERT(float, FORMAT(A.QTY,'##0.##########'))  — MSSQL FORMAT 은 정수부 폭 제한이 없다.
    --  전환본은 'FM99999999990.9999999999' 로 옮겨 정수부가 11자리로 고정됐다. QTY 가 12자리 이상이면
    --  TO_CHAR 이 '#######################' 를 돌려주고 TO_NUMBER 가 ORA-01722 를 던져 82 조회가 통째로 실패한다.
    --  (실측: TO_CHAR(123456789012.5,'FM99999999990.9999999999') = '####...' → ORA-01722 '#' 포함 문자열)
    --  클라우드 82 실패 SQL 원문(V$SQL 4c2b0xq488adv/a9pyq6n5aptwv)에 이 식이 그대로 들어 있음을 확인.
    --  마스크의 실제 의미는 '소수 10자리 반올림' 이므로 ROUND(A.QTY,10) 이 등가다(실측 3케이스 동일).
                || ' SELECT ROUND(A.QTY, 10) AS QTY ';
    ELSE
        v_sql_text := 'WITH T_DM22_WF AS ('
                      || ' SELECT A.QTY AS QTY ';
    END IF;

    --[E20260831-W34] 고정 A.MEASURE 선택 제거 - DEFAULT_FLAG arm 복원으로 V_SQL_SELECT 경유 중복(ORA-00918) 해소 (AS-IS 동형)
    v_sql_text := v_sql_text || '
        , CASE WHEN ''' || P_BUCKET || ''' = ''DAILY'' THEN A.YYYYMMDD ELSE '''' END AS YYYYMMDD
        , CAL.BASIS_YYYYMM, CAL.ISO_WEEK, CAL.BASIS_YYYYMMWW
        , M.SORT_ORDER_NO
        , CAL.END_FLAG
        , NVL(O.SEGMENT3, ''DEFAULT'') AS NOTATION
        , [V_SQL_SELECT]
        , EDY.EDIT_YN
        FROM SCM_MGR.GT_DM22_RAW_DATA A
        INNER JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY
             ON EDY.USER_ID = ''' || P_USER_ID || '''
            AND EDY.MNU_ID  = ''' || P_MENU_ID || '''
            AND EDY.UNIT_ID = A.DIVISION_ID
        JOIN SCM_MGR.GT_DM22_SELECT_MEASURE      M ON A.MEASURE    = M.MEASURE
        JOIN SCM_MGR.GT_DM22_CALENDAR          CAL ON A.YYYYMMDD   = CAL.BASIS_YYYYMMDD
        LEFT OUTER JOIN SCM_MGR.GT_DM22_SCM_MST_SITE        B ON A.SCM_SITE_ID = B.SCM_SITE_ID AND A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID
        LEFT OUTER JOIN SCM_MGR.GT_DM22_SCM_MST_SITE_ITEM   C ON A.DIVISION_ID = C.DIVISION_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
        LEFT OUTER JOIN SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V_T D ON A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID
        LEFT OUTER JOIN SCM_MGR.SCM_MST_PROJECT         G ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE
        LEFT OUTER JOIN SCM_MGR.SCP_MST_ITEM_GROUP_DETAIL I ON A.DIVISION_ID = I.DIVISION_ID AND A.PROJECT_CODE = I.PROJECT_CODE AND A.ITEM_ID = I.ITEM_ID
        LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL O ON O.LOOKUP_TYPE = ''DM_MEASURE_POSITIONAL_NOTATION'' AND A.MEASURE = O.SEGMENT2 AND A.DIVISION_ID = O.SEGMENT1
       )
       ';



    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A027--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

    -- ----------------------------------------------------------------
    -- 최종 PIVOT Dynamic SQL 실행 → O_RC1 반환
    -- ----------------------------------------------------------------
    v_sql_text := v_sql_text || CHR(10) || 'SELECT [v_ColList], SORT_ORDER_NO, EDIT_YN, [V_PV_LIST] '
                || CHR(10) || ' FROM ( ';

    IF P_BUCKET = 'DAILY' THEN
        v_sql_text := v_sql_text
                || CHR(10) || 'SELECT [v_ColList], F.SORT_ORDER_NO, ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.EDIT_YN, F.QTY'
                || CHR(10) || ' FROM T_DM22_WF F '
                || CHR(10) || 'WHERE F.QTY <> 0'
                || CHR(10) || 'UNION ALL';
    END IF;

    IF P_BUCKET <> 'ONLY_WEEKLY' THEN
        v_sql_text := v_sql_text
                || CHR(10) || ' SELECT [v_ColList], F.SORT_ORDER_NO, ''W_'' || F.BASIS_YYYYMM || F.ISO_WEEK AS YYYYMMDD'
                || CHR(10) || '  , F.EDIT_YN'
                || CHR(10) || '  , CASE WHEN F.MEASURE IN (''KRW'',''USD'',''LOC'') THEN AVG(F.QTY) ELSE SUM(F.QTY) END AS QTY'
                || CHR(10) || ' FROM T_DM22_WF F'
                || CHR(10) || 'WHERE F.QTY <> 0'
                || CHR(10) || 'GROUP BY [v_ColList], F.MEASURE, F.SORT_ORDER_NO, F.BASIS_YYYYMM, F.ISO_WEEK, F.EDIT_YN'
                || CHR(10) || ' UNION ALL'
                || CHR(10) || ' SELECT [v_ColList], F.SORT_ORDER_NO, ''M_'' || F.BASIS_YYYYMM AS YYYYMMDD'
                || CHR(10) || '  , F.EDIT_YN'
                || CHR(10) || '  , CASE WHEN F.MEASURE IN (''KRW'',''USD'',''LOC'') THEN AVG(F.QTY) ELSE SUM(F.QTY) END AS QTY'
                || CHR(10) || ' FROM T_DM22_WF F'
                || CHR(10) || 'WHERE F.QTY <> 0'
                || CHR(10) || 'GROUP BY [v_ColList], F.MEASURE, F.SORT_ORDER_NO, F.BASIS_YYYYMM, F.EDIT_YN'
                || CHR(10) || ' ) F PIVOT ( SUM(F.QTY) FOR YYYYMMDD IN ( [V_PV_COL_LIST] ))'
                || CHR(10) || ' ORDER BY [v_OrderList] ';
    ELSIF P_BUCKET = 'ONLY_WEEKLY' THEN
        -- [C20220620-000567] Partial week
        v_sql_text := v_sql_text
                || CHR(10) || ' SELECT [v_ColList], F.SORT_ORDER_NO, ''W_'' || F.BASIS_YYYYMMWW AS YYYYMMDD'
                || CHR(10) || '  , F.EDIT_YN'
                || CHR(10) || '  , CASE WHEN F.MEASURE IN (''KRW'',''USD'',''LOC'') THEN AVG(F.QTY) ELSE SUM(F.QTY) END AS QTY'
                || CHR(10) || ' FROM T_DM22_WF F'
                || CHR(10) || 'WHERE F.QTY <> 0'
                || CHR(10) || 'GROUP BY [v_ColList], F.MEASURE, F.SORT_ORDER_NO, F.BASIS_YYYYMMWW, F.ISO_WEEK, F.EDIT_YN'
                || CHR(10) || ' ) F PIVOT ( SUM(F.QTY) FOR YYYYMMDD IN ([V_PV_COL_LIST] ))'
                || CHR(10) || ' ORDER BY [v_OrderList] ';
    END IF;

	  v_sql_text := REPLACE(v_sql_text,'[V_PV_COL_LIST]'    , V_PV_COL_LIST );
	  v_sql_text := REPLACE(v_sql_text,'[V_PV_LIST]'        , v_PV_LIST     );
	  v_sql_text := REPLACE(v_sql_text,'[v_ColList]'        , v_ColList     );
	  v_sql_text := REPLACE(v_sql_text,'[v_OrderList]'      , v_OrderList   );
	  v_sql_text := REPLACE(v_sql_text,'[V_SQL_SELECT]'     , V_SQL_SELECT  );
	  v_sql_text := REPLACE(v_sql_text,'[V_SQL_GROUPBY]'    , V_SQL_GROUPBY );

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A028--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));


--v_sql_text1 := SUBSTR(v_sql_text,1,9000);
--v_sql_text2 := SUBSTR(v_sql_text,9001,9000);
--v_sql_text3 := SUBSTR(v_sql_text,18001,9000);
--v_sql_text4 := SUBSTR(v_sql_text,27001,9000);

--DBMS_OUTPUT.PUT_LINE(v_sql_text1);
--DBMS_OUTPUT.PUT_LINE(v_sql_text2);
--DBMS_OUTPUT.PUT_LINE(v_sql_text3);
--DBMS_OUTPUT.PUT_LINE(v_sql_text4);

    OPEN O_RC1 FOR v_sql_text;

    -- ISO_WEEK, BASIS_DATE 반환 (MSSQL 원본 마지막 SELECT 동일)
    OPEN O_RC2 FOR
        SELECT ISO_WEEK, BASIS_DATE
          FROM SCM_MGR.SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD = TO_CHAR(SYSTIMESTAMP, 'YYYYMMDD');

    --EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, NULL AS EVENT FROM DUAL;

    DBMS_OUTPUT.ENABLE(1000000);

    DBMS_OUTPUT.PUT_LINE('=============================');
    DBMS_OUTPUT.PUT_LINE('V_PV_COL_LIST : '||V_PV_COL_LIST ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('v_PV_LIST : '||v_PV_LIST ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('v_ColList : '||v_ColList ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('v_OrderList :'||v_OrderList ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('V_SQL_SELECT :'||V_SQL_SELECT ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('V_SQL_GROUPBY :'||V_SQL_GROUPBY ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('=============================');


    DBMS_OUTPUT.PUT_LINE(v_sql_text);

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A029--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||'=>'||TO_CHAR(SQL%ROWCOUNT));

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        --EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_DIVISION_ID'       VALUE P_DIVISION_ID,
            'P_DEPT_ID'           VALUE P_DEPT_ID,
            'P_END_CUSTOMER'      VALUE P_END_CUSTOMER,
            'P_SCM_SITE_ID'       VALUE P_SCM_SITE_ID,
            'P_PROJECT_CODE'      VALUE P_PROJECT_CODE,
            'P_ITEM_ID'           VALUE P_ITEM_ID,
            'P_ITEM_TYPE'         VALUE P_ITEM_TYPE,
            'P_FROM_YYYYMMDD'     VALUE P_FROM_YYYYMMDD,
            'P_NOW_YYYYMMDD'      VALUE P_NOW_YYYYMMDD,
            'P_TO_YYYYMMDD'       VALUE P_TO_YYYYMMDD,
            'P_CREATED_BY'        VALUE P_CREATED_BY,
            'P_PLANT_SITE_ID'     VALUE P_PLANT_SITE_ID,
            'P_BIZTYPE'           VALUE P_BIZTYPE,
            'P_OWNER'             VALUE P_OWNER,
            'P_INTERNAL_YN'       VALUE P_INTERNAL_YN,
            'P_CELL_YN'           VALUE P_CELL_YN,
            'P_VERSION_TYPE'      VALUE P_VERSION_TYPE,
            'P_BUCKET'            VALUE P_BUCKET,
            'P_USER_DEPT_ID'      VALUE P_USER_DEPT_ID,
            'P_GROUP_ID'          VALUE P_GROUP_ID,
            'P_USER_ID'           VALUE P_USER_ID,
            'P_MENU_ID'           VALUE P_MENU_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION',
                '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL;

END PKG_DMF0022;