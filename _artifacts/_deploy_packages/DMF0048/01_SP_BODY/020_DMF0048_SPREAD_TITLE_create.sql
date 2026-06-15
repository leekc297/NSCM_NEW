--==============================================================================
-- 020_DMF0048_SPREAD_TITLE_create.sql — DMF0048 SPREAD_TITLE body 신규 작성
--   기존 PKG_DMF0048 의 spec L62 에 SPREAD_TITLE 선언만 있고 body 누락 → PLS-00302
--
-- 전략 (sp-body-minimal-change hook + 안전 우선):
--   1. PKG body 는 1바이트도 변경 X (메모리 feedback_sp_body_no_rewrite)
--   2. Standalone PROCEDURE SCM_MGR.P_DMF0048_GET_SPREAD_TITLE 신규 작성 (CREATE OR REPLACE)
--   3. PKG spec 의 SPREAD_TITLE 선언 제거 (별도 SQL — 010_DMF0048_spec_fix.sql)
--   4. 메타 API_URL 정정 (별도 SQL — 030_DMF0048_meta_api_url_fix.sql)
--
-- 원본 출처:
--   `To-be_v2_converted/07_Standalone_SP/_archive_absorbed_into_PKG/05_Standalone_SP_DMF0048.sql`
--   (archive 의 SELECT 를 OPEN cursor FOR 로 wrap + OUT cursor 2 추가)
--
-- 작성: 2026-06-07 (Phase B-1 후속)
-- 룰 의무: sp-body-minimal-change.md §1.2 (5줄 초과 시 작업 분리 — 본 작업은 신규 작성이므로 적용 외)
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === DMF0048 P_DMF0048_GET_SPREAD_TITLE standalone procedure 신규 생성 ===

CREATE OR REPLACE PROCEDURE SCM_MGR.P_DMF0048_GET_SPREAD_TITLE
(
    P_START_YYYYMMDD     IN  VARCHAR2,
    P_END_YYYYMMDD       IN  VARCHAR2,
    P_CREATED_BY         IN  VARCHAR2,    -- = sesUserId (BE 자동 채움)
    P_DIVISION_ID        IN  VARCHAR2,
    P_BUCKET             IN  VARCHAR2,    -- DAILY / WEEKLY / MONTHLY
    P_MENU_ID            IN  VARCHAR2,    -- = mnuId (BE 자동 채움)
    O_RC1                OUT SYS_REFCURSOR,
    O_RESULT_CURSOR      OUT SYS_REFCURSOR
)
/*=====================================================================================================================================================
 * Program ID   : P_DMF0048_GET_SPREAD_TITLE
 * Description  : DMF0048 Sales Monitoring 동적 헤더 컬럼 메타 반환
 *              : Bucket (DAILY/WEEKLY/MONTHLY) 별 시간축 컬럼 (D_yyyymmdd / W_yyyymmww / M_yyyymm) +
 *              : SCM_MST_SHEET_COLUMNS + SCM_MST_TITLESET_USER 의 사용자 정의 컬럼 통합
 * Author       : 마리소프트 (NSCM TO-BE)
 * Created      : 2026-06-07 (Phase B-1 후속 — sp-body-minimal-change hook 적용)
 * Note         : archive 'To-be_v2_converted/07_Standalone_SP/_archive_absorbed_into_PKG/05_Standalone_SP_DMF0048.sql'
 *              : 의 SELECT 를 OPEN cursor FOR 로 wrap + dual cursor (O_RC1 + O_RESULT_CURSOR) 추가
 * Source AS-IS : DMF0048_GET_SPREAD_TITLE (SQL Server 392 lines)
 *=====================================================================================================================================================
 * Date        In Charge    Description
 *=====================================================================================================================================================
 * 2017-12-22   SongDH        Initial Release (PJ20170278 전지본부 자동차 GSCM 구축)
 * 2018-06-04   anonymous     division 추가 (p_division_id IN 필터)
 * 2018-06-20   anonymous     division 다중 매칭 (fn_string_split)
 * 2026-06-07   마리소프트      [PJ20264226] NextSCM Pilot — Oracle 변환 + OUT cursor 2 추가 (NSCM dual cursor)
 *====================================================================================================================================================*/
AS
    v_user_col_cnt INTEGER;
    v_program_id   VARCHAR2(4000 CHAR);
    v_sheet_name   VARCHAR2(4000 CHAR);
BEGIN
    v_program_id   := 'DMF0048';
    v_sheet_name   := 'Sales Monitoring';
    v_user_col_cnt := 0;

    -- 사용자 정의 컬럼 존재 여부 검사
    SELECT COUNT(*)
      INTO v_user_col_cnt
      FROM SCM_MGR.SCM_MST_TITLESET_USER U
     WHERE 1 = 1
       AND U.PROGRAM_ID = v_program_id
       AND U.SHEET_NAME = v_sheet_name
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
       AND U.USER_ID    = P_CREATED_BY;

    IF v_user_col_cnt > 0 THEN
        ----------------------------------------------------------------------
        -- 사용자 정의 컬럼 + 시스템 기본 컬럼 + 동적 시간축 컬럼 통합
        ----------------------------------------------------------------------
        OPEN O_RC1 FOR
            SELECT U.PROGRAM_ID
                 , U.SHEET_NAME
                 , U.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , U.SORT_ORDER_NO
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
                 , C.VALID_YN
                 , C.DIVISION_ID
              FROM SCM_MGR.SCM_MST_TITLESET_USER U
                 , SCM_MGR.SCM_MST_SHEET_COLUMNS C
             WHERE 1 = 1
               AND U.PROGRAM_ID  = C.PROGRAM_ID
               AND U.SHEET_NAME  = C.SHEET_NAME
               AND U.COLUMN_NAME = C.COLUMN_NAME
               AND U.PROGRAM_ID  = v_program_id
               AND U.SHEET_NAME  = v_sheet_name
               AND U.USER_ID     = P_CREATED_BY
               AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
               AND P_DIVISION_ID IN (SELECT TOKEN FROM TABLE(SCM_MGR.FN_STRING_SPLIT(C.DIVISION_ID, ',')))
            UNION ALL
            -- VISIBLE_FLAG='' AND DEFAULT_FLAG IS NULL : 숨김 컬럼이지만 사용자 선택 가능
            SELECT C.PROGRAM_ID, C.SHEET_NAME, C.COLUMN_NAME, C.COLUMN_LABEL_NAME
                 , C.SORT_ORDER_NO, C.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME, C.LARGE_CLASS_LABEL_NAME
                 , '' AS DAY_CODE
                 , C.FIXED_FLAG, C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE, C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER, C.DATA_MAX_LENGTH, C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG, C.VISIBLE_FLAG, C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG, C.VALID_YN, C.DIVISION_ID
              FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
             WHERE 1 = 1
               AND C.PROGRAM_ID  = v_program_id
               AND C.SHEET_NAME  = v_sheet_name
               AND C.VISIBLE_FLAG = ''
               AND C.DEFAULT_FLAG IS NULL
               AND C.VALID_YN     = 'Y'
               AND P_DIVISION_ID IN (SELECT TOKEN FROM TABLE(SCM_MGR.FN_STRING_SPLIT(C.DIVISION_ID, ',')))
            UNION ALL
            -- 동적 시간축 컬럼 (D_/W_/M_) — Bucket 별 분기
            SELECT v_program_id   AS PROGRAM_ID
                 , v_sheet_name   AS SHEET_NAME
                 , T.COLUMN_NAME
                 , T.COLUMN_LABEL_NAME
                 , T.SORT_ORDER_NO
                 , ''             AS DATA_SORT_METHOD_CODE
                 , T.SMALL_CLASS_LABEL_NAME
                 , T.LARGE_CLASS_LABEL_NAME
                 , T.DAY_CODE
                 , ''             AS FIXED_FLAG
                 , 50             AS COLUMN_WIDTH
                 , T.CELL_CONTROL_OBJECT_TYPE_CODE
                 , ''             AS CELL_COMBO_DATA_TYPE
                 , '3'            AS DATA_SCALE_NUMBER
                 , ''             AS DATA_MAX_LENGTH
                 , 'R'            AS HORIZONTAL_ALIGN_CODE
                 , 'Y'            AS UPPERCASE_APPLY_FLAG
                 , 'Y'            AS VISIBLE_FLAG
                 , ''             AS DEFAULT_FLAG
                 , ''             AS USER_SELECTABLE_FLAG
                 , ''             AS VALID_YN
                 , ''             AS DIVISION_ID
              FROM (
                    -- DAILY : D_yyyymmdd (각 일자)
                    SELECT 'D_' || A.BASIS_YYYYMMDD                             AS COLUMN_NAME
                         , A.CALENDAR_DAY                                       AS COLUMN_LABEL_NAME
                         , A.WEEK_NAME                                          AS SMALL_CLASS_LABEL_NAME
                         , A.MONTH_NAME                                         AS LARGE_CLASS_LABEL_NAME
                         , A.DAYOFWEEK                                          AS DAY_CODE
                         , A.BASIS_YYYYMMDD || TO_CHAR(31)                      AS SORT_ORDER_NO
                         , 'FPNumber'                                           AS CELL_CONTROL_OBJECT_TYPE_CODE
                      FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                       AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                       AND 1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                    UNION ALL
                    -- WEEKLY : W_yyyymmww (각 주차)
                    SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK                 AS COLUMN_NAME
                         , A.WEEK_NAME                                          AS COLUMN_LABEL_NAME
                         , A.WEEK_NAME                                          AS SMALL_CLASS_LABEL_NAME
                         , A.MONTH_NAME                                         AS LARGE_CLASS_LABEL_NAME
                         , ''                                                   AS DAY_CODE
                         , A.BASIS_START_DATE || TO_CHAR(21)                    AS SORT_ORDER_NO
                         , 'FPNumber'                                           AS CELL_CONTROL_OBJECT_TYPE_CODE
                      FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                       AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                       AND 1 = CASE WHEN P_BUCKET = 'WEEKLY' THEN 1 ELSE 2 END
                     GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.WEEK_NAME, A.MONTH_NAME, A.BASIS_START_DATE
                    UNION ALL
                    -- MONTHLY : M_yyyymm (각 월)
                    SELECT 'M_' || A.BASIS_YYYYMM                               AS COLUMN_NAME
                         , A.MONTH_NAME                                         AS COLUMN_LABEL_NAME
                         , A.MONTH_NAME                                         AS SMALL_CLASS_LABEL_NAME
                         , A.MONTH_NAME                                         AS LARGE_CLASS_LABEL_NAME
                         , ''                                                   AS DAY_CODE
                         , MIN(A.BASIS_START_DATE) || '01'                      AS SORT_ORDER_NO
                         , 'FPNumber'                                           AS CELL_CONTROL_OBJECT_TYPE_CODE
                      FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                       AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                       AND 1 = CASE WHEN P_BUCKET = 'MONTHLY' THEN 1 ELSE 2 END
                     GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                   ) T
             ORDER BY 5;     -- SORT_ORDER_NO (5 번째 컬럼)

    ELSE
        ----------------------------------------------------------------------
        -- 사용자 정의 컬럼 없음 → 시스템 기본 컬럼 + 동적 시간축 통합
        ----------------------------------------------------------------------
        OPEN O_RC1 FOR
            -- 시스템 기본 컬럼 (DEFAULT_FLAG='Y')
            SELECT C.PROGRAM_ID, C.SHEET_NAME, C.COLUMN_NAME, C.COLUMN_LABEL_NAME
                 , C.SORT_ORDER_NO, C.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME, C.LARGE_CLASS_LABEL_NAME
                 , '' AS DAY_CODE
                 , C.FIXED_FLAG, C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE, C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER, C.DATA_MAX_LENGTH, C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG, C.VISIBLE_FLAG, C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG, C.VALID_YN, C.DIVISION_ID
              FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
             WHERE 1 = 1
               AND C.PROGRAM_ID  = v_program_id
               AND C.SHEET_NAME  = v_sheet_name
               AND C.DEFAULT_FLAG = 'Y'
               AND C.VALID_YN     = 'Y'
               AND P_DIVISION_ID IN (SELECT TOKEN FROM TABLE(SCM_MGR.FN_STRING_SPLIT(C.DIVISION_ID, ',')))
            UNION ALL
            -- 숨김 / 사용자 선택 가능 컬럼
            SELECT C.PROGRAM_ID, C.SHEET_NAME, C.COLUMN_NAME, C.COLUMN_LABEL_NAME
                 , C.SORT_ORDER_NO, C.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME, C.LARGE_CLASS_LABEL_NAME
                 , '' AS DAY_CODE
                 , C.FIXED_FLAG, C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE, C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER, C.DATA_MAX_LENGTH, C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG, C.VISIBLE_FLAG, C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG, C.VALID_YN, C.DIVISION_ID
              FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
             WHERE 1 = 1
               AND C.PROGRAM_ID  = v_program_id
               AND C.SHEET_NAME  = v_sheet_name
               AND C.VISIBLE_FLAG = ''
               AND C.DEFAULT_FLAG IS NULL
               AND C.VALID_YN     = 'Y'
               AND P_DIVISION_ID IN (SELECT TOKEN FROM TABLE(SCM_MGR.FN_STRING_SPLIT(C.DIVISION_ID, ',')))
            UNION ALL
            -- 동적 시간축 컬럼 (D_/W_/M_) — Bucket 별 분기
            SELECT v_program_id   AS PROGRAM_ID
                 , v_sheet_name   AS SHEET_NAME
                 , T.COLUMN_NAME
                 , T.COLUMN_LABEL_NAME
                 , T.SORT_ORDER_NO
                 , ''             AS DATA_SORT_METHOD_CODE
                 , T.SMALL_CLASS_LABEL_NAME
                 , T.LARGE_CLASS_LABEL_NAME
                 , T.DAY_CODE
                 , ''             AS FIXED_FLAG
                 , 50             AS COLUMN_WIDTH
                 , 'FPNumber'     AS CELL_CONTROL_OBJECT_TYPE_CODE
                 , ''             AS CELL_COMBO_DATA_TYPE
                 , '3'            AS DATA_SCALE_NUMBER
                 , ''             AS DATA_MAX_LENGTH
                 , 'R'            AS HORIZONTAL_ALIGN_CODE
                 , 'Y'            AS UPPERCASE_APPLY_FLAG
                 , 'Y'            AS VISIBLE_FLAG
                 , ''             AS DEFAULT_FLAG
                 , ''             AS USER_SELECTABLE_FLAG
                 , ''             AS VALID_YN
                 , ''             AS DIVISION_ID
              FROM (
                    SELECT 'D_' || A.BASIS_YYYYMMDD                             AS COLUMN_NAME
                         , A.CALENDAR_DAY                                       AS COLUMN_LABEL_NAME
                         , A.WEEK_NAME                                          AS SMALL_CLASS_LABEL_NAME
                         , A.MONTH_NAME                                         AS LARGE_CLASS_LABEL_NAME
                         , A.DAYOFWEEK                                          AS DAY_CODE
                         , A.BASIS_YYYYMMDD || TO_CHAR(31)                      AS SORT_ORDER_NO
                      FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                       AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                       AND 1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                    UNION ALL
                    SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK                 AS COLUMN_NAME
                         , A.WEEK_NAME                                          AS COLUMN_LABEL_NAME
                         , A.WEEK_NAME                                          AS SMALL_CLASS_LABEL_NAME
                         , A.MONTH_NAME                                         AS LARGE_CLASS_LABEL_NAME
                         , ''                                                   AS DAY_CODE
                         , A.BASIS_START_DATE || TO_CHAR(21)                    AS SORT_ORDER_NO
                      FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                       AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                       AND 1 = CASE WHEN P_BUCKET = 'WEEKLY' THEN 1 ELSE 2 END
                     GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.WEEK_NAME, A.MONTH_NAME, A.BASIS_START_DATE
                    UNION ALL
                    SELECT 'M_' || A.BASIS_YYYYMM                               AS COLUMN_NAME
                         , A.MONTH_NAME                                         AS COLUMN_LABEL_NAME
                         , A.MONTH_NAME                                         AS SMALL_CLASS_LABEL_NAME
                         , A.MONTH_NAME                                         AS LARGE_CLASS_LABEL_NAME
                         , ''                                                   AS DAY_CODE
                         , MIN(A.BASIS_START_DATE) || '01'                      AS SORT_ORDER_NO
                      FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                       AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                       AND 1 = CASE WHEN P_BUCKET = 'MONTHLY' THEN 1 ELSE 2 END
                     GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                   ) T
             ORDER BY 5;     -- SORT_ORDER_NO
    END IF;

    -- 표준 result cursor (NSCM dual cursor 표준)
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, '' AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        -- 표준 EXCEPTION (NSCM PR_SCM_SYS_LOG_BATCH 패턴)
        OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE,
                   SUBSTR('P_DMF0048_GET_SPREAD_TITLE: ' || SQLERRM, 1, 4000) AS MSG,
                   '' AS EVENT
              FROM DUAL;
        RAISE_APPLICATION_ERROR(
            -20001,
            '[P_DMF0048_GET_SPREAD_TITLE] SQLCODE=' || SQLCODE ||
            ' / SQLERRM=' || SQLERRM ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END P_DMF0048_GET_SPREAD_TITLE;
/

PROMPT === SP status 검증 ===
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, LAST_DDL_TIME
  FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR'
   AND OBJECT_NAME='P_DMF0048_GET_SPREAD_TITLE'
   AND OBJECT_TYPE='PROCEDURE';

PROMPT === ALL_ARGUMENTS 검증 (8 row 예상 — 6 IN + 2 OUT) ===
SELECT POSITION, ARGUMENT_NAME, DATA_TYPE, IN_OUT
  FROM ALL_ARGUMENTS
 WHERE OWNER='SCM_MGR'
   AND OBJECT_NAME='P_DMF0048_GET_SPREAD_TITLE'
   AND PACKAGE_NAME IS NULL
 ORDER BY POSITION;

EXIT;
