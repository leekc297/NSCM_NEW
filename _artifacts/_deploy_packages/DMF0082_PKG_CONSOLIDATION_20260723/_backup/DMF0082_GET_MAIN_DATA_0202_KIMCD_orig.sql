CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0082_GET_MAIN_DATA_0202_KIMCD" 
(
    p_division_id    IN VARCHAR2,
    p_team_id        IN VARCHAR2,
    p_customer       IN VARCHAR2,
    p_biz_type       IN VARCHAR2,
    p_from_yyyymmdd  IN VARCHAR2,
    p_to_yyyymmdd    IN VARCHAR2,
    p_scm_site_id    IN VARCHAR2,
    p_item_id        IN VARCHAR2,
    p_version_type   IN VARCHAR2,
    p_qty_yn         IN VARCHAR2,
    p_created_by     IN VARCHAR2,
    p_user_group     IN VARCHAR2,

    o_rc1             OUT SYS_REFCURSOR,
    o_rc2             OUT SYS_REFCURSOR,
    o_rc3             OUT SYS_REFCURSOR,
    o_rc4             OUT SYS_REFCURSOR,
    o_rc5             OUT SYS_REFCURSOR
)
AS
--   DMF0082_GET_MAIN_DATA('40','ALL','ALL','ALL','20260101','20260630','ALL','','Current','N','bindy122678','ADMIN',
--   :o_rc1, :o_rc2, :o_rc3, :o_rc4, :o_rc5);
--  SET SERVEROUTPUT ON;
--
--  DECLARE
--      o_rc1 SYS_REFCURSOR;
--      o_rc2 SYS_REFCURSOR;
--      o_rc3 SYS_REFCURSOR;
--      o_rc4 SYS_REFCURSOR;
--      o_rc5 SYS_REFCURSOR;
--  BEGIN
--      DMF0082_GET_MAIN_DATA_0202_KIMCD('40','ALL','ALL','ALL','20260101','20260630','ALL','','Current','N','bindy122678','ADMIN',
--      o_rc1, o_rc2, o_rc3, o_rc4, o_rc5);

    -- 커서 닫기
--      CLOSE o_rc1;
--      CLOSE o_rc2;
--      CLOSE o_rc3;
--      CLOSE o_rc4;
--      CLOSE o_rc5;
--  END;
    --=============================================================================================================================
    -- LOG 용 변수 설정 (START) -- [E20250915-000105]_로그를 찍기위해서 LOG용 변수 추가 (START)
    --=============================================================================================================================
    v_program_name   VARCHAR2(150) := 'DMF0082_GET_MAIN_DATA';
    v_log_type       VARCHAR2(30);
    n_log_count      PLS_INTEGER := 0;
    v_log_message    VARCHAR2(1000);
    v_description    VARCHAR2(500);
    d_event_date     TIMESTAMP;
    --=============================================================================================================================
    -- LOG 용 변수 설정 (END)  -- [E20250915-000105]_로그를 찍기위해서 LOG용 변수 추가 (END)
    --=============================================================================================================================

    V_CNT NUMBER := 0;

    --=============================================================================================================================
    -- 사용자 컬럼 및 메저 세팅 관련 변수 (START)
    --=============================================================================================================================
    v_user_col_cnt   PLS_INTEGER;
    v_user_mea_cnt   PLS_INTEGER;
    va_program_id    VARCHAR2(50) := 'DMF0082';
    va_sheet_name    VARCHAR2(50) := 'FcstNPrice';
    --=============================================================================================================================
    -- 사용자 컬럼 및 메저 세팅 관련 변수 (END)
    --=============================================================================================================================

    -- BUCKET 관련 변수
    v_exp_yyyymmdd     VARCHAR2(8);
    v_pv_list          CLOB;
    v_pv_col_list      CLOB;
    v_pv_column_name   VARCHAR2(200);
    v_pv_name          VARCHAR2(100);
    v_sort_order_no    VARCHAR2(50);

    -- 날짜 변수
    v_from_yyyymmdd    VARCHAR2(8);
    v_to_yyyymmdd      VARCHAR2(8);
    v_from_result      VARCHAR2(8);
    v_to_result        VARCHAR2(8);
    v_user_time_zone   VARCHAR2(50);

    -- 동적쿼리 관련
    v_cur_column_name  VARCHAR2(200);
    v_cur_program_id   VARCHAR2(10);
    v_cur_sheet_name   VARCHAR2(100);
    v_cur_sort_order   VARCHAR2(50);

    v_column           CLOB := '';
    v_groupby          CLOB := '';
    v_orderby          CLOB := '';

    v_group_id         VARCHAR2(50) := '';
    v_sql_text         CLOB;

    c_bucket SYS_REFCURSOR;
    -- implicit result cursor
    /*
    o_rc1 SYS_REFCURSOR;
    o_rc2 SYS_REFCURSOR;
    o_rc3 SYS_REFCURSOR;
    o_rc4 SYS_REFCURSOR;
    o_rc5 SYS_REFCURSOR;
    */

      v_start_ts     TIMESTAMP WITH TIME ZONE;
      v_elapsed_sec  NUMBER;
BEGIN

    v_start_ts := SYSTIMESTAMP;
    DBMS_OUTPUT.PUT_LINE('step 0-1: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    -- DBMS_OUTPUT.PUT_LINE(v_program_name || ' : A001--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' DMF0082_GET_MAIN_DATA 조회쿼리 시작');

    --=============================================================================================================================
    -- 시작 LOG (START)  -- [E20250915-000105]_로그를 찍기위해서 LOG 추가 (START)
    --=============================================================================================================================
    v_log_type      := 'START';
    v_log_message   := '########## Start of procedure ##########';
    v_description   := '';
    d_event_date    := SYSTIMESTAMP;

    -- MSSQL: EXEC PR_DM_SYS_LOG_BATCH ...
    -- Oracle: 동일 이름 프로시저가 존재한다는 전제(정의 미제공으로 내부포함 불가)
    PR_DM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_created_by);
    --=============================================================================================================================
    -- 시작 LOG (END)
    --=============================================================================================================================
    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;
    DBMS_OUTPUT.PUT_LINE('step 0-2: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

    --=============================================================================================================================
    -- 사용자 컬럼 처리 (START)
    --=============================================================================================================================
    --DBMS_OUTPUT.PUT_LINE(v_program_name || ' : A002--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' 사용자 컬럼 처리 (START)');

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 0-3: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));


    SELECT COUNT(*)
      INTO v_user_col_cnt
      FROM SCM_MST_TITLESET_USER U
     WHERE U.PROGRAM_ID = va_program_id
       AND U.SHEET_NAME = va_sheet_name
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
       AND U.USER_ID = p_created_by;

    DBMS_OUTPUT.PUT_LINE('v_user_col_cnt:' ||v_user_col_cnt);

    IF v_user_col_cnt = 0 THEN
        INSERT INTO SCM_MST_TITLESET_USER
        ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME,
          SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE,
          LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT p_created_by, C.PROGRAM_ID, C.SHEET_NAME, 'C', C.COLUMN_NAME,
               C.SORT_ORDER_NO, 'N', '', p_created_by, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
               p_created_by, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
          FROM SCM_MST_SHEET_COLUMNS C
         WHERE C.PROGRAM_ID = va_program_id
           AND C.SHEET_NAME = va_sheet_name
           AND C.DEFAULT_FLAG = 'Y'
           AND C.VALID_YN = 'Y';
    END IF;

    --DBMS_OUTPUT.PUT_LINE(v_program_name || ' : A002--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' 사용자 컬럼 처리 (END)');
    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 1-1: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

    --=============================================================================================================================
    -- 사용자 메저 처리 (START)
    --=============================================================================================================================
    --DBMS_OUTPUT.PUT_LINE(v_program_name || ' : A003--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' 사용자 메저 처리 (START)');

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 1-2: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));


    SELECT COUNT(*)
      INTO v_user_mea_cnt
      FROM SCM_MST_TITLESET_USER U
     WHERE U.PROGRAM_ID = va_program_id
       AND U.SHEET_NAME = va_sheet_name
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
       AND U.USER_ID = p_created_by;

    DBMS_OUTPUT.PUT_LINE('v_user_mea_cnt:' ||v_user_mea_cnt);

    IF v_user_mea_cnt = 0 THEN
        INSERT INTO SCM_MST_TITLESET_USER
        ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME,
          SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE,
          LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT p_created_by, C.PROGRAM_ID, C.SHEET_NAME, 'M', C.COLUMN_NAME,
               C.SORT_ORDER_NO, 'N', '', p_created_by, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
               p_created_by, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
          FROM SCM_MST_SHEET_MEASURE C
         WHERE C.PROGRAM_ID = va_program_id
           AND C.SHEET_NAME = va_sheet_name
           AND C.DEFAULT_FLAG = 'Y'
           AND C.VALID_YN = 'Y';
    END IF;

    --DBMS_OUTPUT.PUT_LINE(v_program_name || ' : A003--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' 사용자 메저 처리 (END)');

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 1-3: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

    --=============================================================================================================================
    -- 사용자 메저 처리 (END)
    --=============================================================================================================================

    --=============================================================================================================================
    -- BUCKET ▶ v_pv_col_list , v_pv_list 만들기 (START)
    --=============================================================================================================================
--    DBMS_OUTPUT.PUT_LINE(v_program_name || ' : A004--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' BUCKET ▶ v_pv_col_list , v_pv_list 만들기 (START)');
--
--    v_exp_yyyymmdd := TO_CHAR(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD') + (50*7), 'YYYYMMDD');
--
--    v_pv_list     := '';
--    v_pv_col_list := '';
--
--    FOR r IN (
--        SELECT 'D_' || A.BASIS_YYYYMMDD AS COL_KEY,
--               'D_' || A.BASIS_YYYYMMDD AS PV_KEY,
--               A.BASIS_YYYYMMDD || '_' || CHR(31) AS SORT_ORDER_NO
--          FROM SCM_SYS_CALENDAR_M A
--         WHERE A.BASIS_YYYYMMDD >= p_from_yyyymmdd
--           AND A.BASIS_YYYYMMDD <= v_exp_yyyymmdd
--
--        UNION ALL
--        SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS COL_KEY,
--               'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS PV_KEY,
--               A.BASIS_START_DATE || '_' || CHR(21) AS SORT_ORDER_NO
--          FROM SCM_SYS_CALENDAR_M A
--         WHERE A.BASIS_YYYYMMDD >= p_from_yyyymmdd
--           AND A.BASIS_YYYYMMDD <= p_to_yyyymmdd
--         GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
--
--        UNION ALL
--        SELECT 'M_' || A.BASIS_YYYYMM AS COL_KEY,
--               'M_' || A.BASIS_YYYYMM AS PV_KEY,
--               MIN(A.BASIS_START_DATE) || '_' || CHR(1) AS SORT_ORDER_NO
--          FROM SCM_SYS_CALENDAR_M A
--         WHERE A.BASIS_YYYYMMDD >= p_from_yyyymmdd
--           AND A.BASIS_YYYYMMDD <= p_to_yyyymmdd
--         GROUP BY A.BASIS_YYYYMM
--         ORDER BY SORT_ORDER_NO
--    ) LOOP
--        -- Oracle PIVOT용 IN 절:  'D_20260101' AS D_20260101 형태로 만들어야 함
--        IF v_pv_col_list IS NULL OR v_pv_col_list = '' THEN
--            v_pv_col_list := '''' || r.PV_KEY || ''' AS ' || r.PV_KEY;
--            v_pv_list     := '''' || r.PV_KEY || '''';
--        ELSE
--            v_pv_col_list := v_pv_col_list || ', ' || '''' || r.PV_KEY || ''' AS ' || r.PV_KEY;
--            v_pv_list     := v_pv_list || ', ' || '''' || r.PV_KEY || '''';
--        END IF;
--    END LOOP;
--
--    DBMS_OUTPUT.PUT_LINE(v_program_name || ' : A004--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' BUCKET ▶ v_pv_col_list , v_pv_list 만들기 (END)');


    --=============================================================================================================================
    -- BUCKET 관련 세팅 시작 (START)
    --=============================================================================================================================
    -- MSSQL: DATEADD(WEEK, 50, @p_from_yyyymmdd)
    -- MSSQL: CURSOR LOCAL FAST_FORWARD
    -- ORACLE: 기본 FOR UPDATE 없는 READ ONLY 커서로 사용
--    OPEN c_bucket FOR
--        SELECT column_name, pv_name, sort_order_no
--          FROM (
--
--
--                SELECT
--                       ''''||'D_' || a.basis_yyyymmdd || ''||''''|| ' AS D_' || a.basis_yyyymmdd AS column_name,
--                    ''''||'D_' || a.basis_yyyymmdd || ''||''''  AS pv_name,
--                       a.basis_yyyymmdd || '_' || LPAD('31', 2, '0') AS sort_order_no
--                  FROM scm_sys_calendar_m a
--                 WHERE a.basis_yyyymmdd >= p_from_yyyymmdd
--                   AND a.basis_yyyymmdd <= v_exp_yyyymmdd
--
--                UNION ALL
--
--                SELECT
--                       ''''||'W_' || a.basis_yyyymm || a.iso_week || ''||''''|| ' AS W_' || a.basis_yyyymm || a.iso_week AS column_name,
--                       ''''||'W_' || a.basis_yyyymm || a.iso_week || ''||'''' AS pv_name,
--                       a.basis_start_date || '_' || LPAD('21', 2, '0') AS sort_order_no
--                  FROM scm_sys_calendar_m a
--                 WHERE a.basis_yyyymmdd >= p_from_yyyymmdd
--                   AND a.basis_yyyymmdd <= p_to_yyyymmdd
--                 GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date
--
--                UNION ALL
--
--                SELECT
--                       ''''||'M_' || a.basis_yyyymm || ''||''''|| ' AS M_' || a.basis_yyyymm AS column_name,
--                       ''''||'M_' || a.basis_yyyymm || ''||'''' AS pv_name,
--                       MIN(a.basis_start_date) || '_' || LPAD('1', 2, '0') AS sort_order_no
--                  FROM scm_sys_calendar_m a
--                 WHERE a.basis_yyyymmdd >= p_from_yyyymmdd
--                   AND a.basis_yyyymmdd <= p_to_yyyymmdd
--                 GROUP BY a.basis_yyyymm







--                SELECT
--                       '[D_' || a.basis_yyyymmdd || '] AS D_' || a.basis_yyyymmdd AS column_name,
--                    '[D_' || a.basis_yyyymmdd || ']'  AS pv_name,
--                       a.basis_yyyymmdd || '_' || LPAD('31', 2, '0') AS sort_order_no
--                  FROM scm_sys_calendar_m a
--                 WHERE a.basis_yyyymmdd >= p_from_yyyymmdd
--                   AND a.basis_yyyymmdd <= v_exp_yyyymmdd
--
--                UNION ALL
--
--                SELECT
--                       '[W_' || a.basis_yyyymm || a.iso_week || '] AS W_' || a.basis_yyyymm || a.iso_week AS column_name,
--                       '[W_' || a.basis_yyyymm || a.iso_week || ']' AS pv_name,
--                       a.basis_start_date || '_' || LPAD('21', 2, '0') AS sort_order_no
--                  FROM scm_sys_calendar_m a
--                 WHERE a.basis_yyyymmdd >= p_from_yyyymmdd
--                   AND a.basis_yyyymmdd <= p_to_yyyymmdd
--                 GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date
--
--                UNION ALL
--
--                SELECT
--                       '[M_' || a.basis_yyyymm || '] AS M_' || a.basis_yyyymm AS column_name,
--                       '[M_' || a.basis_yyyymm || ']' AS pv_name,
--                       MIN(a.basis_start_date) || '_' || LPAD('1', 2, '0') AS sort_order_no
--                  FROM scm_sys_calendar_m a
--                 WHERE a.basis_yyyymmdd >= p_from_yyyymmdd
--                   AND a.basis_yyyymmdd <= p_to_yyyymmdd
--                 GROUP BY a.basis_yyyymm

--               )
--         ORDER BY sort_order_no;
-- BUCKET 관련 세팅 시작 (START)

    v_pv_list     := NULL;  -- SELECT 절에 붙일 컬럼명 리스트 (D_20260101, W_20260103 ...)
    v_pv_col_list := NULL;  -- PIVOT IN 절 리스트 ('D_20260101' AS D_20260101, ...)
     -- BUCKET 관련 세팅 시작 (START)
    v_exp_yyyymmdd := TO_CHAR(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD') + (50 * 7), 'YYYYMMDD');

    WITH bucket AS (
        -- Day
        SELECT
            '''D_' || a.basis_yyyymmdd || ''' AS D_' || a.basis_yyyymmdd AS pivot_in_piece,
            'D_'  || a.basis_yyyymmdd                              AS pivot_alias,
            a.basis_yyyymmdd || '_' || LPAD('31', 2, '0')          AS sort_order_no
        FROM scm_sys_calendar_m a
        WHERE a.basis_yyyymmdd >= p_from_yyyymmdd
          AND a.basis_yyyymmdd <= v_exp_yyyymmdd

        UNION ALL

        -- Week
        SELECT
            '''W_' || a.basis_yyyymm || a.iso_week || ''' AS W_' || a.basis_yyyymm || a.iso_week AS pivot_in_piece,
            'W_'  || a.basis_yyyymm || a.iso_week                                       AS pivot_alias,
            a.basis_start_date || '_' || LPAD('21', 2, '0')                             AS sort_order_no
        FROM scm_sys_calendar_m a
        WHERE a.basis_yyyymmdd >= p_from_yyyymmdd
          AND a.basis_yyyymmdd <= p_to_yyyymmdd
        GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date

        UNION ALL

        -- Month
        SELECT
            '''M_' || a.basis_yyyymm || ''' AS M_' || a.basis_yyyymm AS pivot_in_piece,
            'M_'  || a.basis_yyyymm                                 AS pivot_alias,
            MIN(a.basis_start_date) || '_' || LPAD('01', 2, '0')     AS sort_order_no
        FROM scm_sys_calendar_m a
        WHERE a.basis_yyyymmdd >= p_from_yyyymmdd
          AND a.basis_yyyymmdd <= p_to_yyyymmdd
        GROUP BY a.basis_yyyymm
    )
    SELECT
        -- PIVOT IN 절 리스트:  '<key>' AS <alias>, ...
        RTRIM(
          XMLCAST(
            XMLAGG(XMLELEMENT(e, pivot_in_piece || ', ') ORDER BY sort_order_no)
            AS CLOB
          ),
          ', '
        ) AS pv_col_list,

        -- SELECT 절 리스트: <alias>, ...
        RTRIM(
          XMLCAST(
            XMLAGG(XMLELEMENT(e, pivot_alias || ', ') ORDER BY sort_order_no)
            AS CLOB
          ),
          ', '
        ) AS pv_list
    INTO v_pv_col_list, v_pv_list
    FROM bucket;

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 1-4: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));


    -- 디버깅 출력 (필수)
    --DBMS_OUTPUT.PUT_LINE('v_pv_col_list=' || DBMS_LOB.SUBSTR(v_pv_col_list, 3000, 1));
    --DBMS_OUTPUT.PUT_LINE('v_pv_list='     || DBMS_LOB.SUBSTR(v_pv_list, 3000, 1));
    -- BUCKET 관련 세팅 종료 (END)

    -- BUCKET 관련 세팅 종료 (END)
    -- 테스트...피봇 갯수 산정용 삭제해도 됨
    /*
    WITH bucket_log AS (
        -- Day
        SELECT
            '''D_' || a.basis_yyyymmdd || ''' AS D_' || a.basis_yyyymmdd AS pivot_in_piece,
            'D_'  || a.basis_yyyymmdd                              AS pivot_alias,
            a.basis_yyyymmdd || '_' || LPAD('31', 2, '0')          AS sort_order_no
        FROM scm_sys_calendar_m a
        WHERE a.basis_yyyymmdd >= p_from_yyyymmdd
          AND a.basis_yyyymmdd <= v_exp_yyyymmdd

        UNION ALL

        -- Week
        SELECT
            '''W_' || a.basis_yyyymm || a.iso_week || ''' AS W_' || a.basis_yyyymm || a.iso_week AS pivot_in_piece,
            'W_'  || a.basis_yyyymm || a.iso_week                                       AS pivot_alias,
            a.basis_start_date || '_' || LPAD('21', 2, '0')                             AS sort_order_no
        FROM scm_sys_calendar_m a
        WHERE a.basis_yyyymmdd >= p_from_yyyymmdd
          AND a.basis_yyyymmdd <= p_to_yyyymmdd
        GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date

        UNION ALL

        -- Month
        SELECT
            '''M_' || a.basis_yyyymm || ''' AS M_' || a.basis_yyyymm AS pivot_in_piece,
            'M_'  || a.basis_yyyymm                                 AS pivot_alias,
            MIN(a.basis_start_date) || '_' || LPAD('01', 2, '0')     AS sort_order_no
        FROM scm_sys_calendar_m a
        WHERE a.basis_yyyymmdd >= p_from_yyyymmdd
          AND a.basis_yyyymmdd <= p_to_yyyymmdd
        GROUP BY a.basis_yyyymm
    )
    SELECT COUNT(*) INTO v_cnt FROM bucket_log;
    DBMS_OUTPUT.PUT_LINE('pivot column count='||v_cnt);
    */

    --=============================================================================================================================
    -- BUCKET 관련 세팅 종료 (END)
    --=============================================================================================================================

  --=============================================================================================================================
  -- Version 관련 세팅 시작 (START)
  --=============================================================================================================================

  --=============================================================================================================================
  -- Version 관련 세팅 시작 (END)
  --=============================================================================================================================

    --=============================================================================================================================
    -- (중간) #TempSiteItem / #TempSelectMeasure / #TempFcstNPrice / #MF_SP 등
    --        MSSQL의 #TEMP DROP/CREATE 구간은 Oracle에서는 "GTT TRUNCATE"로 치환
    --=============================================================================================================================

    -- GTT 초기화(프로시저 재진입 대비)
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_TEMP_DM_MST_ITEM_SINGLE_V';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_TEMPSITEITEMALL';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_TEMPSITEITEM';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_TEMPSELECTMEASURE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_TEMPFCSTNPRICE';

    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_CAL_MONTH_END_DATE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_CAL_WEEK_END_DATE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_TEMP_INTO_GROUP_MEASURE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_TEMP_ADMIN_GROUP_MEASURE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_MF_SP';

    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_T_LAST_DATA_SETUP_FCST';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_T_LAST_DATA_SETUP_PRICE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_T_WS_FCST';
    -- EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_LAST_DATA_SETUP_FCST';
    -- EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_LAST_DATA_SETUP_PRICE';
    -- EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_WS_FCST';


    -- 2026.01.13 #TEMP_DM_MST_ITEM_SINGLE_V 는 DM_MST_ITEM_SINGLE_V 으로 대체
    -- 2026.01.27 죠인으로 변경
    /*
    INSERT INTO GTT_TEMP_DM_MST_ITEM_SINGLE_V
    SELECT *
      FROM DM_MST_ITEM_SINGLE_V
     WHERE DIVISION_ID = '40'
       AND ACTIVE_FLAG = 'Y';
    */

    DBMS_OUTPUT.PUT_LINE('step 1-5: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

  --=============================================================================================================================
  -- #TempSiteItem 만들기 시작 (START)
  --=============================================================================================================================

    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

    INSERT /*+ APPEND PARALLEL(P1 8) */ INTO GTT_TEMPSITEITEMALL P1

    -- 튜닝 01.23
    WITH
     P_SITE AS (

            -- SELECT TOKEN FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID,','))
            SELECT TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL)) AS token
            FROM dual
            CONNECT BY REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL) IS NOT NULL

    )
    ,P_CUST AS (
            -- SELECT TOKEN FROM TABLE(STRING_SPLIT(P_CUSTOMER,','))
        SELECT TRIM(REGEXP_SUBSTR(P_CUSTOMER, '[^,]+', 1, LEVEL)) AS token
        FROM dual
        CONNECT BY REGEXP_SUBSTR(P_CUSTOMER, '[^,]+', 1, LEVEL) IS NOT NULL
    )
    ,P_BIZ AS (
        -- SELECT TOKEN FROM TABLE(STRING_SPLIT(P_BIZ_TYPE,','))
        SELECT TRIM(REGEXP_SUBSTR(P_BIZ_TYPE, '[^,]+', 1, LEVEL)) AS token
        FROM dual
        CONNECT BY REGEXP_SUBSTR(P_BIZ_TYPE, '[^,]+', 1, LEVEL) IS NOT NULL
    )
    ,P_ITEM AS (
        -- SELECT TOKEN FROM TABLE(STRING_SPLIT(P_BIZ_TYPE,','))
        SELECT TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL)) AS token
        FROM dual
        CONNECT BY REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL) IS NOT NULL
    )

-- 02.02 요청사항    ,F_BASE AS (
--
--        SELECT F.ROWID AS RID, F.OWNER
--        FROM SCM_MST_SITE_ITEM F
--        WHERE F.DIVISION_ID = p_division_id -- '40' 전 사업부 사용을 위해 변수처리 02/02
--        AND F.OWNER IS NOT NULL  -- 01/31
--
--    )
--    , F_OWNER AS (
--
--        SELECT FB.RID, OT.TOKEN AS OWNER_ID
--        FROM F_BASE FB
--        -- CROSS JOIN TABLE(STRING_SPLIT(FB.OWNER, ',')) OT
--        CROSS JOIN LATERAL (
--            SELECT TRIM(REGEXP_SUBSTR(FB.OWNER, '[^,]+', 1, LEVEL)) AS token
--            FROM dual
--            CONNECT BY REGEXP_SUBSTR(FB.OWNER, '[^,]+', 1, LEVEL) IS NOT NULL
--        ) OT
--    )
--    ,OWNER_AGG AS (
--        SELECT FO.RID, LISTAGG(U.USER_NAME_EN,',') WITHIN GROUP (ORDER BY U.USER_NAME_EN) AS OWNER
--        FROM F_OWNER FO
--        JOIN SCM_MST_SSO_USER_INFO U ON U.USER_ID = FO.OWNER_ID
--        GROUP BY FO.RID
--    ),

    , BASE AS (
    SELECT /*+ MATERIALIZE PARALLEL(m1 4) */
        DIVISION_ID,
        ITEM_ID,
        ITEM_NAME,
        --ITEM_CLASS,
        --ITEM_CLASS_NAME,
        NICK_NAME,
        ITEM_TYPE,
        MATERIAL_CLASS_NAME,
        ITEM_UOM,
        SPEC,
        MDM_PROJECT_NAME,
        MIN_CAPACITY,
        --ACTIVE_FLAG,
        --ENERGE,
        --CELL_QUANTITY,
        --SCP_EXTRA_SPEC,
        FORECAST_INFO_BIZ_TYPE,
        FORECAST_INFO_PRODUCT_GROUP,
        FORECAST_INFO_CELL_MODEL,
        FORECAST_INFO_CELL_PACK_COUNT,
        FORECAST_INFO_SPEC,
        FORECAST_INFOR_VERSION,
        CELL_TYPE,
        MAX(FORECAST_INFO_BIZ_TYPE)
            OVER (PARTITION BY DIVISION_ID, ITEM_ID_12) AS P_FORECAST_INFO_BIZ_TYPE,

        MAX(FORECAST_INFO_PRODUCT_GROUP)
            OVER (PARTITION BY DIVISION_ID, ITEM_ID_12) AS P_FORECAST_INFO_PRODUCT_GROUP,

        MAX(FORECAST_INFO_CELL_MODEL)
            OVER (PARTITION BY DIVISION_ID, ITEM_ID_12) AS P_FORECAST_INFO_CELL_MODEL,

        MAX(FORECAST_INFO_CELL_PACK_COUNT)
            OVER (PARTITION BY DIVISION_ID, ITEM_ID_12) AS P_FORECAST_INFO_CELL_PACK_COUNT,

        MAX(FORECAST_INFO_SPEC)
            OVER (PARTITION BY DIVISION_ID, ITEM_ID_12) AS P_FORECAST_INFO_SPEC,

        MAX(FORECAST_INFOR_VERSION)
            OVER (PARTITION BY DIVISION_ID, ITEM_ID_12) AS P_FORECAST_INFOR_VERSION,

        MAX(CELL_TYPE)
            OVER (PARTITION BY DIVISION_ID, ITEM_ID_12) AS P_CELL_TYPE,

        CASE
            WHEN ITEM_TYPE = 'P' THEN 1
            WHEN ITEM_TYPE = 'H' THEN 2
            WHEN ITEM_TYPE = 'Q' THEN 3
            ELSE 4
        END AS ITEM_TYPE_PRIORITY

    FROM gtt_scm_item_m m1 -- SCM_MST_ITEM_SN
    WHERE DIVISION_ID = p_division_id -- '40' 전 사업부 사용을 위해 변수처리 02/02
       AND ACTIVE_FLAG = 'Y'
    ),
    GTT_TEMP_DM_MST_ITEM_SINGLE_V_1 AS (

      --SELECT /*+ MATERIALIZE PARALLEL(d1 8) RESULT_CACHE */ *
      --FROM DM_MST_ITEM_SINGLE_V d1
      --WHERE DIVISION_ID = '40'
      -- AND ACTIVE_FLAG = 'Y'

        SELECT /*+ MATERIALIZE PARALLEL(B1 8) */
            DIVISION_ID,
            ITEM_ID,
            MAX(ITEM_NAME)            AS ITEM_NAME,              -- NULL 가능: 하나로 통일
            --MAX(ITEM_CLASS)           AS ITEM_CLASS,             -- NULL 가능: 하나로 통일
            --MAX(ITEM_CLASS_NAME)      AS ITEM_CLASS_NAME,        -- NULL 가능: 하나로 통일
            MAX(NICK_NAME)            AS NICK_NAME,              -- NULL 가능: 하나로 통일

            CASE MIN(ITEM_TYPE_PRIORITY)
                WHEN 1 THEN 'P'
                WHEN 2 THEN 'H'
                WHEN 3 THEN 'Q'
                ELSE 'R'
            END                      AS ITEM_TYPE,
            MAX(MDM_PROJECT_NAME)     AS MDM_PROJECT_NAME,
            MAX(MIN_CAPACITY)         AS MIN_CAPACITY,
            MAX(P_FORECAST_INFO_BIZ_TYPE)        AS FORECAST_INFO_BIZ_TYPE,
            MAX(P_FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT,
            MAX(P_CELL_TYPE)          AS CELL_TYPE,
            MAX(P_FORECAST_INFO_PRODUCT_GROUP)   AS FORECAST_INFO_PRODUCT_GROUP,
            MAX(P_FORECAST_INFO_CELL_MODEL)      AS FORECAST_INFO_CELL_MODEL,
            MAX(P_FORECAST_INFO_SPEC)            AS FORECAST_INFO_SPEC,
            MAX(P_FORECAST_INFOR_VERSION)        AS FORECAST_INFOR_VERSION
        FROM BASE B1

        GROUP BY
            DIVISION_ID,
            ITEM_ID

    )

    SELECT

        F.DIVISION_ID,
        F.PROJECT_CODE,
        F.SCM_SITE_ID,
        F.ITEM_ID,
        T2.NICK_NAME,
        F.PROJECT_CODE,
        F.ATTRIBUTE5 AS CELL_MODEL,
        S.END_CUSTOMER,
        S.SOLDTO_CUSTOMER,
        I.COUNTRY,
        I.COUNTRY_NAME,
        H.CITY,
        H.CITY_NAME,
        /* OWNER: MSSQL STUFF/FOR XML PATH -> Oracle LISTAGG */
        -- *****무한 대기
        --        (
        --          SELECT LISTAGG(ZA.USER_NAME_EN, ',') WITHIN GROUP (ORDER BY ZA.USER_NAME_EN)
        --            FROM SCM_MST_SSO_USER_INFO ZA
        --           -- WHERE ZA.USER_ID = 'a.akpoguma'
        --           WHERE ZA.USER_ID IN (SELECT TOKEN FROM TABLE(STRING_SPLIT(F.OWNER, ',')))
        --        ) AS OWNER,
        -- 'test-user' as owner,

        -- 02.02 요청사항
        (
          SELECT LISTAGG(ZA.USER_NAME_EN, ',') WITHIN GROUP (ORDER BY ZA.USER_NAME_EN)
          FROM SCM_MST_SSO_USER_INFO ZA
          JOIN -- TABLE(STRING_SPLIT(F.OWNER, ',')) ZB
                 ( SELECT TRIM(REGEXP_SUBSTR(F.OWNER, '[^,]+', 1, LEVEL)) AS TOKEN
                  FROM dual
                  CONNECT BY REGEXP_SUBSTR(F.OWNER, '[^,]+', 1, LEVEL) IS NOT NULL ) ZB
            ON ZA.USER_ID = ZB.TOKEN
        ) AS OWNER,
        -- 02.02 요청사항 OA.OWNER,   -- 튜닝 01.23

        TEAM.USER_NAME_EN AS PROJECT_OWNER,
        TEAM.USER_ID,
        T2.ITEM_NAME,
        T2.ITEM_TYPE,
        F.CUST_GROUP,
        F.CUST_GROUP_DTL,
        F.APPLICATION,
        F.ROUTE,
        T2.MDM_PROJECT_NAME,
        T2.MIN_CAPACITY,
        CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE ELSE T2.FORECAST_INFO_BIZ_TYPE END AS FORECAST_INFO_BIZ_TYPE,
        T2.FORECAST_INFO_PRODUCT_GROUP,
        LOOK.NAME AS CELL_TYPE,
        CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN to_number(LOOKA.CELL_PACK_COUNT) ELSE to_number(T2.FORECAST_INFO_CELL_PACK_COUNT) END AS FORECAST_INFO_CELL_PACK_COUNT,
        (T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION) AS FORECAST_INFO_ALL,
        T2.FORECAST_INFO_SPEC,
        T2.FORECAST_INFOR_VERSION,

        NVL(T4.NICK_NAME,'') AS CELL_MODEL_NICK_NAME,

        S.VMI_YN,
        NVL(F.ATTRIBUTE1,'') AS DMS_SALES,
        NVL(F.ATTRIBUTE2,'') AS DMS_CUSTOMER,
        TEAM.DEPT_ID,
        TEAM.DEPT_NAME_KO,
        F.VALID_YN AS ITEM_VALID_YN
    FROM SCM_MST_SITE_ITEM F

        -- 020.02 요청사항 LEFT JOIN OWNER_AGG OA     -- 튜닝 26.01.23
        -- 020.02 요청사항 ON OA.RID = F.ROWID    -- 튜닝 26.01.23

    -- JOIN GTT_TEMP_DM_MST_ITEM_SINGLE_V T2
    JOIN GTT_TEMP_DM_MST_ITEM_SINGLE_V_1 T2  -- 튜닝 26.01.27
      ON F.DIVISION_ID = T2.DIVISION_ID
     AND F.ITEM_ID     = T2.ITEM_ID

    -- LEFT JOIN GTT_TEMP_DM_MST_ITEM_SINGLE_V T4
    LEFT JOIN GTT_TEMP_DM_MST_ITEM_SINGLE_V_1 T4  -- 튜닝 01.27
      ON T2.DIVISION_ID = T4.DIVISION_ID
     -- AND NVL(T2.FORECAST_INFO_CELL_MODEL,'') = T4.ITEM_ID -- 01.31
     AND T2.FORECAST_INFO_CELL_MODEL = T4.ITEM_ID


    JOIN (SELECT DISTINCT '%'||TOKEN||'%' AS TST
            -- FROM TABLE(STRING_SPLIT(p_item_id, ','))
            FROM P_ITEM
    ) B
      ON (F.ITEM_ID LIKE B.TST OR T2.NICK_NAME LIKE B.TST)
    JOIN SCM_MST_SITE S
      ON F.DIVISION_ID = S.DIVISION_ID
     AND F.SCM_SITE_ID = S.SCM_SITE_ID
     AND S.SITE_TYPE   = 'SALES'

    JOIN SCM_MST_CITY H
      ON S.CITY = H.CITY
    JOIN SCM_MST_COUNTRY I
      ON S.COUNTRY = I.COUNTRY
    LEFT JOIN (
        SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
          FROM SCM_MST_SSO_USER_INFO B
          LEFT JOIN SCM_MST_SSO_DEPT_INFO C ON B.DEPT_ID = C.DEPT_ID
    ) TEAM
      -- ON TEAM.USER_ID IN (
        -- SELECT TOKEN FROM TABLE(STRING_SPLIT(F.OWNER, ',')) FETCH FIRST 1 ROWS ONLY
        ON TEAM.USER_ID = SUBSTR(F.OWNER, 1,
                CASE WHEN INSTR(F.OWNER, ',') = 0 THEN LENGTH(F.OWNER) ELSE INSTR(F.OWNER, ',')-1 END
               )
--    LEFT JOIN SCM_MST_SSO_USER_INFO J
--      ON SUBSTR(F.OWNER, 1,
--                CASE WHEN INSTR(F.OWNER, ',') = 0 THEN LENGTH(F.OWNER) ELSE INSTR(F.OWNER, ',')-1 END
--               ) = J.USER_ID
    LEFT JOIN (
    -- ok
        SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'CELL_TYPE'
    ) LOOK
      ON LOOK.CODE = T2.CELL_TYPE

    LEFT JOIN (
        -- ok
        SELECT MODEL, BIZ_TYPE, CELL_PACK_COUNT, MODEL_RANK
          FROM (
              SELECT SEGMENT2 AS MODEL,
                     SEGMENT3 AS BIZ_TYPE,
                     SEGMENT4 AS CELL_PACK_COUNT,
                     RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) AS MODEL_RANK
                FROM SCM_ADM_LOOKUP_MASTER_DETAIL
               WHERE LOOKUP_TYPE = 'DM_BIZ_TYPE_40'
                 AND SEGMENT1 = p_division_id -- '40' 전 사업부 사용을 위해 변수처리 02/02
          )
         WHERE MODEL_RANK = 1
    ) LOOKA
      ON LOOKA.MODEL = F.ITEM_ID
    WHERE F.DIVISION_ID = p_division_id -- '40' 전 사업부 사용을 위해 변수처리 02/02

      AND (CASE WHEN p_scm_site_id = 'ALL' THEN p_scm_site_id ELSE F.SCM_SITE_ID END) IN (SELECT TOKEN FROM P_SITE)
      AND (CASE WHEN p_customer    = 'ALL' THEN p_customer    ELSE F.PROJECT_CODE END) IN (SELECT TOKEN FROM P_CUST)
      AND (CASE WHEN p_biz_type    = 'ALL' THEN p_biz_type
                WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                ELSE T2.FORECAST_INFO_BIZ_TYPE END) IN (SELECT TOKEN FROM P_BIZ)

--      AND (P_SCM_SITE_ID = 'ALL' OR F.SCM_SITE_ID IN (SELECT TOKEN FROM P_SITE))
--      AND (P_CUSTOMER = 'ALL' OR F.PROJECT_CODE IN (SELECT TOKEN FROM P_CUST))
--      AND (P_BIZ_TYPE = 'ALL' OR
--                (CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
--                ELSE T2.FORECAST_INFO_BIZ_TYPE END) IN (SELECT TOKEN FROM P_BIZ))
    ;

    COMMIT;

    select count(*) into v_cnt from GTT_TEMPSITEITEMALL;
    DBMS_OUTPUT.PUT_LINE('GTT_TEMPSITEITEMALL:' || v_cnt ||'-건');
    DBMS_OUTPUT.PUT_LINE('p_scm_site_id:'||p_scm_site_id||', p_customer:'||p_customer||', p_biz_type:'||p_biz_type||', P_ITME_ID:'||P_ITEM_ID);
    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 1-6: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

  -------------------------------------------------------------------------------------------------------------------------------
  -- #TempSiteItem 만들기 (START)
  -------------------------------------------------------------------------------------------------------------------------------
--     #TempSiteItem 만들기 (집계)
    INSERT /*+ APPEND PARALLEL(G1 8) */ INTO GTT_TEMPSITEITEM G1
    SELECT
        DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME,
        MAX(CELL_MODEL)                    AS CELL_MODEL,
        MAX(END_CUSTOMER)                  AS END_CUSTOMER,
        MAX(SOLDTO_CUSTOMER)               AS SOLDTO_CUSTOMER,
        MAX(COUNTRY)                       AS COUNTRY,
        MAX(COUNTRY_NAME)                  AS COUNTRY_NAME,
        MAX(CITY)                          AS CITY,
        MAX(CITY_NAME)                     AS CITY_NAME,
        MAX(OWNER)                         AS OWNER,
        MAX(PROJECT_OWNER)                 AS PROJECT_OWNER,
        MAX(USER_ID)                       AS USER_ID,
        MAX(ITEM_NAME)                     AS ITEM_NAME,
        MAX(ITEM_TYPE)                     AS ITEM_TYPE,
        MAX(CUST_GROUP)                    AS CUST_GROUP,
        MAX(CUST_GROUP_DTL)                AS CUST_GROUP_DTL,
        MAX(APPLICATION)                   AS APPLICATION,
        MAX(ROUTE)                         AS ROUTE,
        MAX(MDM_PROJECT_NAME)              AS MDM_PROJECT_NAME,
        MAX(MIN_CAPACITY)                  AS MIN_CAPACITY,
        MAX(FORECAST_INFO_BIZ_TYPE)        AS FORECAST_INFO_BIZ_TYPE,
        MAX(FORECAST_INFO_PRODUCT_GROUP)   AS FORECAST_INFO_PRODUCT_GROUP,
        MAX(CELL_TYPE)                     AS CELL_TYPE,
        MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT,
        MAX(FORECAST_INFO_ALL)             AS FORECAST_INFO_ALL,
        MAX(FORECAST_INFO_SPEC)            AS FORECAST_INFO_SPEC,
        MAX(FORECAST_INFOR_VERSION)        AS FORECAST_INFOR_VERSION,
        MAX(CELL_MODEL_NICK_NAME)          AS CELL_MODEL_NICK_NAME,
        MAX(VMI_YN)                        AS VMI_YN,
        MAX(DMS_SALES)                     AS DMS_SALES,
        MAX(DMS_CUSTOMER)                  AS DMS_CUSTOMER,
        MAX(DEPT_ID)                       AS DEPT_ID,
        MAX(DEPT_NAME_KO)                  AS DEPT_NAME_KO,
        MAX(ITEM_VALID_YN)                 AS ITEM_VALID_YN
    FROM GTT_TEMPSITEITEMALL
    GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;

    COMMIT;

    select count(*) into v_cnt from GTT_TEMPSITEITEM;
    DBMS_OUTPUT.PUT_LINE('GTT_TEMPSITEITEM:' || v_cnt ||'-건');

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 1-7: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

--  =============================================================================================================================
--     날짜 변수 세팅
--  =============================================================================================================================
    v_from_yyyymmdd  := '';
    v_to_yyyymmdd    := '';
    v_from_result    := '';
    v_to_result      := '';
    v_user_time_zone := '';

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

  /* 조회 할 때 쓸 날짜 변수 세팅 시작 */
  /* 조회 할 때 쓸 날짜 변수 세팅 시작 */
  /* 조회 할 때 쓸 날짜 변수 세팅 시작 */

    BEGIN
    -- AS054
        SELECT U.TIMEZONE
          INTO v_user_time_zone
          FROM TB_FX_User U
         WHERE U.UserID = p_created_by;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_user_time_zone := '';
    END;

    -- @V_FROM_YYYYMMDD : (USER 시차를 고려한) 당주 월요일
    -- 20260119
    SELECT MIN(C.BASIS_YYYYMMDD)
      INTO v_from_yyyymmdd
      FROM SCM_SYS_CALENDAR_M C
      JOIN (
            SELECT DISTINCT ISO_YYYYWW
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD = TO_CHAR(FN_MULTY_TIME(v_user_time_zone), 'YYYYMMDD')
      ) T
        ON C.ISO_YYYYWW = T.ISO_YYYYWW;

    -- FROM 실적 : FROM 조회 구간 월요일부터
    SELECT C.BASIS_START_DATE
      INTO v_from_result
      FROM SCM_SYS_CALENDAR_M C
     WHERE C.BASIS_YYYYMMDD = p_from_yyyymmdd;

    -- TO 실적 : TO 조회 구간 월요일 전까지
    SELECT C.BASIS_START_DATE
      INTO v_to_result
      FROM SCM_SYS_CALENDAR_M C
     WHERE C.BASIS_YYYYMMDD = p_to_yyyymmdd;

    IF v_from_yyyymmdd > v_from_result THEN
        v_to_yyyymmdd := p_to_yyyymmdd;
        v_to_result   := v_from_yyyymmdd;
    ELSIF v_from_yyyymmdd <= v_from_result THEN
        v_to_yyyymmdd := p_to_yyyymmdd;
        v_from_result := '19000101';
        v_to_result   := '19000101';
    ELSIF v_from_yyyymmdd > v_to_result THEN
        v_from_yyyymmdd := '19000101';
        v_to_yyyymmdd   := '19000101';
        v_from_result   := p_from_yyyymmdd;
        v_to_result     := p_to_yyyymmdd;
    ELSIF v_from_yyyymmdd = v_to_result THEN
        v_to_yyyymmdd := v_from_yyyymmdd;
        v_from_result := p_from_yyyymmdd;
        v_to_result   := p_to_yyyymmdd;
    END IF;

    DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A007--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') ||
                         ' 날짜 변수 ▶ v_from_yyyymmdd:'||v_from_yyyymmdd||' v_to_yyyymmdd:'||v_to_yyyymmdd||
                         ' v_from_result:'||v_from_result||' v_to_result:'||v_to_result);



  /* 조회 할 때 쓸 날짜 변수 세팅 종료 */
  /* 조회 할 때 쓸 날짜 변수 세팅 종료 */
  /* 조회 할 때 쓸 날짜 변수 세팅 종료 */

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

    --=============================================================================================================================
    -- Temp 테이블 초기화 (TRUNCATE)
    --=============================================================================================================================
    /*
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_TEMPSELECTMEASURE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_T_LAST_DATA_SETUP_FCST';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_T_LAST_DATA_SETUP_PRICE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_T_WS_FCST';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_TEMPFCSTNPRICE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_CAL_MONTH_END_DATE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_CAL_WEEK_END_DATE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_TEMP_INTO_GROUP_MEASURE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_TEMP_ADMIN_GROUP_MEASURE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_MF_SP';
    */
--
--    --=============================================================================================================================
--    -- #TempSelectMeasure 만들기
--    --=============================================================================================================================
    INSERT INTO GTT_TEMPSELECTMEASURE
    SELECT DISTINCT
           U.PROGRAM_ID,
           U.SHEET_NAME,
           U.USER_ID,
           U.COLUMN_NAME AS MEASURE_GROUP,
           U.COLUMN_NAME AS MEASURE,
           NVL(SMSM.ATTRIBUTE5, U.COLUMN_NAME) AS RESULT_MEASURE,
           U.SORT_ORDER_NO
      FROM SCM_MST_TITLESET_USER U
      JOIN SCM_MST_SHEET_MEASURE SMSM
        ON U.PROGRAM_ID = SMSM.PROGRAM_ID
       AND U.SHEET_NAME = SMSM.SHEET_NAME
       AND U.COLUMN_NAME = SMSM.COLUMN_NAME
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
       AND SMSM.VALID_YN = 'Y'
     WHERE U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
       AND U.PROGRAM_ID = va_program_id
       AND U.SHEET_NAME = va_sheet_name
       AND U.USER_ID = p_created_by;

    -- DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A008--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' #TempSelectMeasure 만들기 성공');

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 1-8: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

--    ------------------------------------------------------------------------------------------------
--    --[PJ2025-50188] ... 필수 메저 강제 등록 (LOC/KRW/FCST_GAP)
--    ------------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------
  --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 (MKT Fcst AMT/QTY)
  --실적구간 LOC,KRW를 계산하기 위해 필수 메저 RTF_SYS_RP, MKT_AMT_LOC, MKT_AMT_KRW 를 메저에 강제 등록 START
  ------------------------------------------------------------------------------------------------
    SELECT count(*) into v_cnt FROM GTT_TEMPSELECTMEASURE A WHERE A.MEASURE IN ('LOC','KRW','FCST_GAP');
    IF v_cnt > 0 THEN
        INSERT INTO GTT_TEMPSELECTMEASURE
        (PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, RESULT_MEASURE, SORT_ORDER_NO)
        SELECT DISTINCT
               W.PROGRAM_ID, W.SHEET_NAME,
               'DM_ADMIN' AS USER_ID,
               W.MEASURE_GROUP, W.MEASURE, W.RESULT_MEASURE, W.SORT_ORDER_NO
          FROM (
                SELECT A.PROGRAM_ID, A.SHEET_NAME, 'LOC' AS TARGET_MEASURE,
                       A.COLUMN_NAME AS MEASURE_GROUP, A.COLUMN_NAME AS MEASURE, A.COLUMN_NAME AS RESULT_MEASURE, A.SORT_ORDER_NO
                  FROM SCM_MST_SHEET_MEASURE A
                 WHERE A.PROGRAM_ID = va_program_id
                   AND A.SHEET_NAME  = va_sheet_name
                   AND A.COLUMN_NAME IN ('RTF_SYS_RP','MKT_AMT_LOC')
                UNION ALL
                SELECT A.PROGRAM_ID, A.SHEET_NAME, 'KRW' AS TARGET_MEASURE,
                       A.COLUMN_NAME, A.COLUMN_NAME, A.COLUMN_NAME, A.SORT_ORDER_NO
                  FROM SCM_MST_SHEET_MEASURE A
                 WHERE A.PROGRAM_ID = va_program_id
                   AND A.SHEET_NAME  = va_sheet_name
                   AND A.COLUMN_NAME IN ('RTF_SYS_RP','MKT_AMT_KRW')
                UNION ALL
                SELECT A.PROGRAM_ID, A.SHEET_NAME, 'FCST_GAP' AS TARGET_MEASURE,
                       A.COLUMN_NAME, A.COLUMN_NAME, A.COLUMN_NAME, A.SORT_ORDER_NO
                  FROM SCM_MST_SHEET_MEASURE A
                 WHERE A.PROGRAM_ID = va_program_id
                   AND A.SHEET_NAME  = va_sheet_name
                   AND A.COLUMN_NAME IN ('MKT_FCST','SCM_FCST')
          ) W
          JOIN GTT_TEMPSELECTMEASURE T
            ON W.PROGRAM_ID = T.PROGRAM_ID
           AND W.SHEET_NAME = T.SHEET_NAME
           AND W.TARGET_MEASURE = T.MEASURE
         WHERE NOT EXISTS (SELECT 1 FROM GTT_TEMPSELECTMEASURE X WHERE X.MEASURE = W.MEASURE);
    END IF;

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 1-9: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));
  ------------------------------------------------------------------------------------------------
  --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 (MKT Fcst AMT/QTY)
  --실적구간 LOC,KRW를 계산하기 위해 필수 메저 RTF_SYS_RP, MKT_AMT_LOC, MKT_AMT_KRW 를 메저에 강제 등록 END
  ------------------------------------------------------------------------------------------------

  --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 START----------------------------------------------
  --LOC를 기준으로 CURRENCY를 일괄 업데이트 하기 때문에 무조건 해당 메저 INSERT
  --DM_PLN_CFM_SELLING_PRICE 테이블로 JOIN 해서 업데이트 하면 속도가 너무 느림
    -- LOC는 무조건 INSERT
    INSERT INTO GTT_TEMPSELECTMEASURE
    (PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, RESULT_MEASURE, SORT_ORDER_NO)
    SELECT A.PROGRAM_ID, A.SHEET_NAME, 'DM_ADMIN',
           A.COLUMN_NAME, A.COLUMN_NAME, A.COLUMN_NAME, A.SORT_ORDER_NO
      FROM SCM_MST_SHEET_MEASURE A
     WHERE A.PROGRAM_ID = va_program_id
       AND A.SHEET_NAME  = va_sheet_name
       AND A.COLUMN_NAME = 'LOC'
       AND NOT EXISTS (SELECT 1 FROM GTT_TEMPSELECTMEASURE X WHERE X.MEASURE = A.COLUMN_NAME);
  --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 END----------------------------------------------


    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 2-1: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

  -- #TempSelectMeasure 만들기 종료

  -- #T_LAST_DATA_SETUP_FCST 만들기 시작
    --=============================================================================================================================
    -- #T_LAST_DATA_SETUP_* (CURRENT)
    --=============================================================================================================================
    IF UPPER(p_version_type) LIKE '%CURRENT%' THEN
        -- DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A009--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' #T_LAST_DATA_SETUP_FCST 만들기 시작');

      --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 START ---------------------------------------------------------------------
      --기존 쿼리 주석 처리 후 일괄 변경
      --1.LAST_UPDATE_DATE 값을 가져올 때, CASE WHEN 에 소형사업부에서 사용하지 않는 메저들만 있어서 해당 로직 제거
      --2.가장 최근 데이터를 입력한 사용자ID가 아니라 MAX사용자ID로 가져와서 수정함

        INSERT INTO GTT_T_LAST_DATA_SETUP_FCST
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, LAST_UPDATE_DATE, LAST_UPDATED_BY
        FROM (
            SELECT
                A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE,
                TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD') AS LAST_UPDATE_DATE,
                A.LAST_UPDATED_BY AS LAST_UPDATED_BY,
                ROW_NUMBER() OVER (
                    PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                    ORDER BY A.LAST_UPDATE_DATE
                ) AS RN
            FROM DM_PLN_CFM_MKT_DEMAND_PLAN A
            JOIN GTT_TEMPSELECTMEASURE B
              ON A.MEASURE = CASE
                               WHEN B.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL') THEN 'MKT_FCST_PP'
                               WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY') THEN 'RTF'
                               ELSE B.MEASURE
                             END
            WHERE A.DIVISION_ID = p_division_id
              AND A.YYYYMMDD >= TO_CHAR(ADD_MONTHS(TO_DATE(p_from_yyyymmdd,'YYYYMMDD'), -12), 'YYYYMMDD')
              AND A.YYYYMMDD <= p_to_yyyymmdd
        )
        WHERE NVL(PROJECT_CODE,'') <> ''
          AND NVL(SCM_SITE_ID,'') <> ''
          AND NVL(ITEM_ID,'') <> ''
          AND RN = 1;

       --  DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A009--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' #T_LAST_DATA_SETUP_FCST 만들기 종료');
       -- DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A010--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' #T_LAST_DATA_SETUP_PRICE 만들기 시작');

            -- #T_LAST_DATA_SETUP_FCST 만들기 종료
      --SELECT * FROM #T_LAST_DATA_SETUP_FCST

        SELECT COUNT(*) INTO V_CNT FROM GTT_T_LAST_DATA_SETUP_FCST;
        DBMS_OUTPUT.PUT_LINE('GTT_T_LAST_DATA_SETUP_FCST:' || V_CNT);

        INSERT INTO GTT_T_LAST_DATA_SETUP_PRICE
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, LAST_UPDATE_DATE, LAST_UPDATED_BY
        FROM (
            SELECT
                A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE,
                TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD') AS LAST_UPDATE_DATE,
                A.LAST_UPDATED_BY AS LAST_UPDATED_BY,
                ROW_NUMBER() OVER (
                    PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                    ORDER BY A.LAST_UPDATE_DATE
                ) AS RN
            FROM DM_PLN_CFM_SELLING_PRICE A
            JOIN GTT_TEMPSELECTMEASURE B
              ON A.MEASURE = B.MEASURE
            WHERE A.DIVISION_ID = p_division_id
              AND A.YYYYMMDD >= TO_CHAR(ADD_MONTHS(TO_DATE(p_from_yyyymmdd,'YYYYMMDD'), -12), 'YYYYMMDD')
              AND A.YYYYMMDD <= p_to_yyyymmdd
        )
        WHERE NVL(PROJECT_CODE,'') <> ''
          AND NVL(SCM_SITE_ID,'') <> ''
          AND NVL(ITEM_ID,'') <> ''
          AND RN = 1;

        SELECT COUNT(*) INTO V_CNT FROM GTT_T_LAST_DATA_SETUP_PRICE;
        DBMS_OUTPUT.PUT_LINE('GTT_T_LAST_DATA_SETUP_PRICE-2:' || V_CNT);

        -- DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A011--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' #T_LAST_DATA_SETUP_PRICE 만들기 종료');
    END IF;

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 2-2: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));


    --=============================================================================================================================
    -- #T_WS_FCST
    --=============================================================================================================================
    INSERT INTO GTT_T_WS_FCST (FCST_TYPE)
    SELECT SEGMENT1
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE LOOKUP_TYPE = 'SALES_TYPE_CODE';

    DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A016--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' #T_WS_FCST 만들기 성공');

    --=============================================================================================================================

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 2-3: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

    DBMS_OUTPUT.PUT_LINE('P_VERSION_TYPE:'||P_VERSION_TYPE);

    IF (upper(P_VERSION_TYPE) LIKE '%CURRENT%') THEN

--      DBMS_OUTPUT.PUT_LINE(
--          VA_PROGRAM_ID || ' : A017--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
--          || '#TempFcstNPrice 만들기 시작 - VERSION - CURRENT'
--      );



      --------------------------------------------------------------------------------------------------------------------------------
      -- #TempFcstNPrice 만들기 (INSERT)
      --------------------------------------------------------------------------------------------------------------------------------
/*
      DBMS_STATS.GATHER_TABLE_STATS(
          ownname          => 'SCM_MGR',
          tabname          => 'GTT_TEMPSITEITEM',
          estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
          method_opt       => 'FOR ALL COLUMNS SIZE 1',
          cascade          => TRUE,
          degree           => 8
      );

      DBMS_STATS.GATHER_TABLE_STATS(
          ownname          => 'SCM_MGR',
          tabname          => 'GTT_TEMPSELECTMEASURE',
          estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
          method_opt       => 'FOR ALL COLUMNS SIZE 1',
          cascade          => TRUE,
          degree           => 8
      );

      DBMS_STATS.GATHER_TABLE_STATS(
          ownname          => 'SCM_MGR',
          tabname          => 'GTT_T_WS_FCST',
          estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
          method_opt       => 'FOR ALL COLUMNS SIZE 1',
          cascade          => TRUE,
          degree           => 8
      );




*/
    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 2-3-1: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));



      INSERT /*+ APPEND */ INTO GTT_TEMPFCSTNPRICE T1
      ( DIVISION_ID       , PROJECT_CODE                  , END_CUSTOMER           , SCM_SITE_ID            , ITEM_ID              , DOM_EXP            , FCST_TYPE          , INCOTERMS        , MEASURE                 , PLANT_SITE_ID
      , CELL_PROD_SITE_ID , YYYYMMDD                      , QTY                    , MEASURE_GROUP          , CELL_MODEL           , NICK_NAME          , DMS_SALES          , DMS_CUSTOMER     , OWNER                   , DEPT_ID
      , DEPT_NAME_KO      , FORECAST_INFO_CELL_PACK_COUNT , ITEM_TYPE              , PROJECT_NAME           , PROJECT_OWNER
      , SOLDTO_CUSTOMER   , COUNTRY_NAME                  , CITY_NAME
      , ITEM_NAME         , VMI_YN                        , CUST_GROUP             , CUST_GROUP_DTL         , APPLICATION          , ROUTE              , MDM_PROJECT_NAME   , MIN_CAPACITY     , FORECAST_INFO_BIZ_TYPE  , CELL_TYPE
      , FORECAST_INFO_ALL , FORECAST_INFO_SPEC            , FORECAST_INFOR_VERSION , CELL_MODEL_NICK_NAME
      , SORT_ORDER_NO
      , CREATE_DATE       , LAST_UPDATED_BY
      , CURRENCY          , VERSION_NO                    , CUTOFF_YYYYMMDD        , NOTATION
      )
      /* DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 기준 MEASURE */
      -- 기본적인 MEASURE 포함
      -- MKT_FCST [R+P]의 P부분 (기준일 이후)
      -- RTF [R+P] 의 P 부분 (기준일 이후)


      WITH P_SITE AS (

        -- SELECT TOKEN FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID,','))
            SELECT TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL)) AS token
            FROM dual
            CONNECT BY REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL) IS NOT NULL

      )  -- 01.31
      -- 179,049건
      SELECT
             A.DIVISION_ID
           , A.PROJECT_CODE
           , A.END_CUSTOMER
           , A.SCM_SITE_ID
           , A.ITEM_ID
           , A.DOM_EXP
           , A.FCST_TYPE
           , A.INCOTERMS
           , CASE WHEN A.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST_PP'
                  WHEN A.MEASURE =  'MKT_FCST' AND B.MEASURE = 'MKT_FCST_PP' THEN 'MKT_FCST' ELSE A.MEASURE END AS MEASURE
           , A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID
           , A.YYYYMMDD
           , A.QTY
           , B.MEASURE_GROUP
           , C.CELL_MODEL
           , C.NICK_NAME
           , C.DMS_SALES
           , C.DMS_CUSTOMER
           , C.OWNER
           , C.DEPT_ID
           , C.DEPT_NAME_KO
           , C.FORECAST_INFO_CELL_PACK_COUNT
           , C.ITEM_TYPE
           , C.PROJECT_NAME
           , C.PROJECT_OWNER
           , C.SOLDTO_CUSTOMER
           , C.COUNTRY_NAME
           , C.CITY_NAME
           , C.ITEM_NAME
           , C.VMI_YN
           , C.CUST_GROUP
           , C.CUST_GROUP_DTL
           , C.APPLICATION
           , C.ROUTE
           , C.MDM_PROJECT_NAME
           , C.MIN_CAPACITY
           , C.FORECAST_INFO_BIZ_TYPE
           , C.CELL_TYPE
           , C.FORECAST_INFO_ALL
           , C.FORECAST_INFO_SPEC
           , C.FORECAST_INFOR_VERSION
           , C.CELL_MODEL_NICK_NAME
           , B.SORT_ORDER_NO
           , LD.CREATE_DATE
           , LD.LAST_UPDATED_BY
           , '' AS CURRENCY
           , 'CURRENT' AS VERSION_NO
           , NULL AS CUTOFF_YYYYMMDD
           --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 'MKT_AMT_LOC', 'MKT_AMT_KRW' 메저 소숫점3자리 표현을 위해 NOTATION 변경 (INTEGER -> POINT3)
           , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM DM_PLN_CFM_MKT_DEMAND_PLAN A
        INNER JOIN GTT_TEMPSELECTMEASURE B
          ON A.MEASURE =
             (CASE
                WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY') THEN 'RTF'
                WHEN B.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL','RTF_ENERGY') THEN 'RTF_SYS_RP'
                WHEN B.MEASURE = 'MKT_FCST_PP' THEN 'MKT_FCST'
                ELSE B.MEASURE
              END)
        /* OUTER APPLY TOP(1) -> LEFT JOIN (ROW_NUMBER=1) */
        LEFT JOIN (
            SELECT *
              FROM (
                    SELECT LD.DIVISION_ID, LD.PROJECT_CODE, LD.SCM_SITE_ID, LD.ITEM_ID,
                           LD.DOM_EXP, LD.FCST_TYPE, LD.INCOTERMS, LD.MEASURE,
                           LD.CREATE_DATE, LD.LAST_UPDATED_BY--,
--                           ROW_NUMBER() OVER (
  --                           PARTITION BY LD.DIVISION_ID, LD.PROJECT_CODE, LD.SCM_SITE_ID, LD.ITEM_ID,
    --                                      LD.DOM_EXP, LD.FCST_TYPE, LD.INCOTERMS, LD.MEASURE
      --                       ORDER BY LD.CREATE_DATE DESC
        --                   ) AS RN
                      FROM GTT_T_LAST_DATA_SETUP_FCST LD
                   )
             -- WHERE RN = 1
        ) LD
          ON LD.DIVISION_ID   = A.DIVISION_ID
         AND LD.PROJECT_CODE  = A.PROJECT_CODE
         AND LD.SCM_SITE_ID   = A.SCM_SITE_ID
         AND LD.ITEM_ID       = A.ITEM_ID
         AND LD.DOM_EXP       = A.DOM_EXP
         AND LD.FCST_TYPE     = A.FCST_TYPE
         AND LD.INCOTERMS     = A.INCOTERMS
         AND LD.MEASURE       = A.MEASURE
        INNER JOIN GTT_TEMPSITEITEM C
          ON A.DIVISION_ID   = C.DIVISION_ID
         AND A.PROJECT_CODE  = C.PROJECT_CODE
         AND A.SCM_SITE_ID   = C.SCM_SITE_ID
         AND A.ITEM_ID       = C.ITEM_ID
         AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN GTT_T_WS_FCST D
          ON A.FCST_TYPE = D.FCST_TYPE
       WHERE 1=1
         AND A.DIVISION_ID = P_DIVISION_ID
         AND (CASE WHEN P_SCM_SITE_ID = 'ALL' THEN P_SCM_SITE_ID ELSE A.SCM_SITE_ID END) IN
             -- (SELECT TOKEN FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ',')))
             (SELECT TOKEN FROM P_SITE)
         AND A.YYYYMMDD >= V_FROM_YYYYMMDD
         AND A.YYYYMMDD <= V_TO_YYYYMMDD
         --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
         AND (
               (A.MEASURE <> 'SCM_FCST' AND A.QTY <> 0)
               OR
               (A.MEASURE = 'SCM_FCST')
             )
         --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END
       UNION ALL
      SELECT /*+ MONITOR LEADING(A C LD) USE_HASH(C)  USE_HASH(LD B)  */

             A.DIVISION_ID
           , A.PROJECT_CODE
           , A.END_CUSTOMER
           , A.SCM_SITE_ID
           , A.ITEM_ID
           , A.DOM_EXP
           , A.FCST_TYPE
           , A.INCOTERMS
           , A.MEASURE
           , A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID
           , A.YYYYMMDD
           , NVL(A.PRICE,0) AS QTY
           , B.MEASURE_GROUP
           , C.CELL_MODEL
           , C.NICK_NAME
           , C.DMS_SALES
           , C.DMS_CUSTOMER
           , C.OWNER
           , C.DEPT_ID
           , C.DEPT_NAME_KO
           , C.FORECAST_INFO_CELL_PACK_COUNT
           , C.ITEM_TYPE
           , C.PROJECT_NAME
           , C.PROJECT_OWNER
           , C.SOLDTO_CUSTOMER
           , C.COUNTRY_NAME
           , C.CITY_NAME
           , C.ITEM_NAME
           , C.VMI_YN
           , C.CUST_GROUP
           , C.CUST_GROUP_DTL
           , C.APPLICATION
           , C.ROUTE
           , C.MDM_PROJECT_NAME
           , C.MIN_CAPACITY
           , C.FORECAST_INFO_BIZ_TYPE
           , C.CELL_TYPE
           , C.FORECAST_INFO_ALL
           , C.FORECAST_INFO_SPEC
           , C.FORECAST_INFOR_VERSION
           , C.CELL_MODEL_NICK_NAME
           , B.SORT_ORDER_NO
           , LD.CREATE_DATE
           , LD.LAST_UPDATED_BY
           , A.CURRENCY
           , 'CURRENT' AS VERSION_NO
           , NULL AS CUTOFF_YYYYMMDD
           , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC',
                'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM DM_PLN_CFM_SELLING_PRICE A    -- 확정판매가격계획기본 981,064 건
        INNER JOIN GTT_TEMPSELECTMEASURE B  -- 8
          ON A.MEASURE = B.MEASURE
        LEFT JOIN (
            SELECT *
              FROM (
                    SELECT LD.DIVISION_ID,
                            LD.PROJECT_CODE,
                            LD.SCM_SITE_ID,
                            LD.ITEM_ID,
                            LD.DOM_EXP,
                            LD.FCST_TYPE, LD.INCOTERMS, LD.MEASURE,
                           LD.CREATE_DATE, LD.LAST_UPDATED_BY--,
--                           ROW_NUMBER() OVER (
  --                           PARTITION BY LD.DIVISION_ID,
    --                                        LD.PROJECT_CODE,
      --                                      LD.SCM_SITE_ID,
        --                                    LD.ITEM_ID,
          --                                LD.DOM_EXP,
            --                              LD.FCST_TYPE,
              --                            LD.INCOTERMS,
                --                          LD.MEASURE
                  --           ORDER BY LD.CREATE_DATE DESC
                    --       ) AS RN
                      FROM GTT_T_LAST_DATA_SETUP_PRICE LD  -- 0
                   )
             --WHERE RN = 1
        ) LD
          ON LD.DIVISION_ID   = A.DIVISION_ID
         AND LD.PROJECT_CODE  = A.PROJECT_CODE
         AND LD.SCM_SITE_ID   = A.SCM_SITE_ID
         AND LD.ITEM_ID       = A.ITEM_ID
         AND LD.DOM_EXP       = A.DOM_EXP
         AND LD.FCST_TYPE     = A.FCST_TYPE
         AND LD.INCOTERMS     = A.INCOTERMS
         AND LD.MEASURE       = A.MEASURE
        INNER JOIN GTT_TEMPSITEITEM C       -- 14758건
          ON A.DIVISION_ID   = C.DIVISION_ID
         AND A.PROJECT_CODE  = C.PROJECT_CODE
         AND A.SCM_SITE_ID   = C.SCM_SITE_ID
         AND A.ITEM_ID       = C.ITEM_ID
         AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN GTT_T_WS_FCST D        -- 14건
          ON A.FCST_TYPE = D.FCST_TYPE
       WHERE 1=1
         AND A.DIVISION_ID = P_DIVISION_ID
         AND (CASE WHEN P_SCM_SITE_ID = 'ALL' THEN P_SCM_SITE_ID
                ELSE A.SCM_SITE_ID END) IN (SELECT TOKEN FROM P_SITE)
             -- 01.31 (SELECT TOKEN FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ',')))
         AND A.YYYYMMDD >= V_TO_RESULT
         AND A.YYYYMMDD <= V_TO_YYYYMMDD

         ;


    COMMIT;

     select count(*) into v_cnt from GTT_TEMPFCSTNPRICE;
     DBMS_OUTPUT.PUT_LINE('GTT_TEMPFCSTNPRICE: '||v_cnt||'-건');

     v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 2-4: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));


      --------------------------------------------------------------------------------------------------------------------------------
      -- UPDATE A SET A.CURRENCY = SP.CURRENCY ...
      -- ORACLE: UPDATE (inline view) SET ...
      --------------------------------------------------------------------------------------------------------------------------------
--      UPDATE (
--          SELECT A.CURRENCY AS A_CURRENCY,
--                 SP.CURRENCY AS SP_CURRENCY
--            FROM GTT_TEMPFCSTNPRICE A
--            JOIN (
--                  SELECT DISTINCT
--                         SP.DIVISION_ID, SP.PROJECT_CODE, SP.SCM_SITE_ID, SP.PLANT_SITE_ID, SP.ITEM_ID,
--                         SP.INCOTERMS, SP.DOM_EXP, SP.FCST_TYPE, SP.CURRENCY, SP.CELL_PROD_SITE_ID
--                    FROM GTT_TEMPFCSTNPRICE SP -- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
--                   WHERE 1=1
--                     AND SP.DIVISION_ID = P_DIVISION_ID
--                     AND (CASE WHEN P_SCM_SITE_ID = 'ALL' THEN P_SCM_SITE_ID ELSE SP.SCM_SITE_ID END) IN
--                         (SELECT TOKEN FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ',')))
--                     AND SP.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
--                     AND SP.MEASURE = 'LOC'
--            ) SP
--              ON A.DIVISION_ID       = SP.DIVISION_ID
--             AND A.PROJECT_CODE      = SP.PROJECT_CODE
--             AND A.SCM_SITE_ID       = SP.SCM_SITE_ID
--             AND A.PLANT_SITE_ID     = SP.PLANT_SITE_ID
--             AND A.ITEM_ID           = SP.ITEM_ID
--             AND A.INCOTERMS         = SP.INCOTERMS
--             AND A.DOM_EXP           = SP.DOM_EXP
--             AND A.FCST_TYPE         = SP.FCST_TYPE
--             AND A.CELL_PROD_SITE_ID = SP.CELL_PROD_SITE_ID
--           WHERE 1=1
--             AND A.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND V_TO_YYYYMMDD
--             AND NVL(A.CURRENCY,'') = ''
--             AND A.MEASURE NOT LIKE 'VMI%'
--      )
--      SET A_CURRENCY = SP_CURRENCY;

        /* 01.28 삭제
        MERGE INTO GTT_TEMPFCSTNPRICE A
        USING (
          SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
                 INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID,
                 CURRENCY
          FROM (
            SELECT SP.*,
                   ROW_NUMBER() OVER (
                     PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
                                  INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
                     ORDER BY YYYYMMDD DESC
                   ) rn
            FROM GTT_TEMPFCSTNPRICE SP
            WHERE SP.DIVISION_ID = P_DIVISION_ID
              AND (CASE WHEN P_SCM_SITE_ID='ALL' THEN P_SCM_SITE_ID ELSE SP.SCM_SITE_ID END) IN
                  (SELECT TOKEN FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ',')))
              AND SP.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
              AND SP.MEASURE = 'LOC'
              AND NVL(SP.CURRENCY,'') <> ''
          )
          WHERE rn = 1
        ) SP
        ON (
           A.DIVISION_ID       = SP.DIVISION_ID
        AND A.PROJECT_CODE      = SP.PROJECT_CODE
        AND A.SCM_SITE_ID       = SP.SCM_SITE_ID
        AND A.PLANT_SITE_ID     = SP.PLANT_SITE_ID
        AND A.ITEM_ID           = SP.ITEM_ID
        AND A.INCOTERMS         = SP.INCOTERMS
        AND A.DOM_EXP           = SP.DOM_EXP
        AND A.FCST_TYPE         = SP.FCST_TYPE
        AND A.CELL_PROD_SITE_ID = SP.CELL_PROD_SITE_ID
        )
        WHEN MATCHED THEN UPDATE
        SET A.CURRENCY = SP.CURRENCY
        WHERE 1=1
          AND A.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND V_TO_YYYYMMDD
          AND NVL(A.CURRENCY,'') = ''
          AND A.MEASURE NOT LIKE 'VMI%';
          */

/*
      DBMS_STATS.GATHER_TABLE_STATS(
          ownname          => 'SCM_MGR',
          tabname          => 'GTT_TEMPFCSTNPRICE',
          estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
          method_opt       => 'FOR ALL COLUMNS SIZE 1',
          cascade          => TRUE,
          degree           => 8
      );
*/

    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

        MERGE /*+ PARALLEL(A 8) index( sp IX_GTT_TEMPFCSTNPRICE_03) index( a IX_GTT_TEMPFCSTNPRICE_03) */ INTO GTT_TEMPFCSTNPRICE A
        USING (

--            SELECT /*+ PARALLEL(SP 8) */
--                DISTINCT
--                SP.DIVISION_ID,
--                SP.PROJECT_CODE,
--                SP.SCM_SITE_ID,
--                SP.PLANT_SITE_ID,
--                SP.ITEM_ID,
--                SP.INCOTERMS,
--                SP.DOM_EXP,
--                SP.FCST_TYPE,
--                SP.CURRENCY,
--                SP.CELL_PROD_SITE_ID
--            FROM GTT_TempFcstNPrice SP
--            WHERE SP.DIVISION_ID = P_DIVISION_ID
--              AND ( P_SCM_SITE_ID = 'ALL'
--                    OR SP.SCM_SITE_ID IN (
--                        SELECT TOKEN
--                        FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))
--                    )
--                  )
--              AND SP.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
--              AND SP.MEASURE = 'LOC'


              SELECT division_id, project_code, scm_site_id, plant_site_id, item_id,
                     incoterms, dom_exp, fcst_type, currency, cell_prod_site_id
              FROM (
                SELECT sp.*,
                       ROW_NUMBER() OVER (
                         PARTITION BY division_id, project_code, scm_site_id, plant_site_id, item_id,
                                      incoterms, dom_exp, fcst_type, cell_prod_site_id
                         ORDER BY yyyymmdd DESC
                       ) rn
                FROM gtt_tempfcstnprice sp
                WHERE sp.division_id = p_division_id
                  AND sp.yyyymmdd BETWEEN v_to_result AND v_to_yyyymmdd
                  AND sp.measure = 'LOC'
              )
              WHERE rn = 1

        ) SP
        ON (
            A.DIVISION_ID = SP.DIVISION_ID
            AND A.PROJECT_CODE = SP.PROJECT_CODE
            AND A.SCM_SITE_ID = SP.SCM_SITE_ID
            AND A.PLANT_SITE_ID = SP.PLANT_SITE_ID
            AND A.ITEM_ID = SP.ITEM_ID
            AND A.INCOTERMS = SP.INCOTERMS
            AND A.DOM_EXP = SP.DOM_EXP
            AND A.FCST_TYPE = SP.FCST_TYPE
            AND A.CELL_PROD_SITE_ID = SP.CELL_PROD_SITE_ID
        )
        WHEN MATCHED THEN
            UPDATE SET A.CURRENCY = SP.CURRENCY
            WHERE A.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND V_TO_YYYYMMDD
              AND A.CURRENCY IS NULL
              -- AND NVL(A.CURRENCY, '') = ''
              AND A.MEASURE NOT LIKE 'VMI%';
      DBMS_OUTPUT.PUT_LINE('step 2-6: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(SQL%ROWCOUNT));
      COMMIT;


--       MERGE INTO GTT_TEMPFCSTNPRICE A
--        USING (
--          SELECT DISTINCT
--                SP.DIVISION_ID,
--                SP.PROJECT_CODE,
--                SP.SCM_SITE_ID,
--                SP.PLANT_SITE_ID,
--                SP.ITEM_ID,
--                SP.INCOTERMS,
--                SP.DOM_EXP,
--                SP.FCST_TYPE,
--                SP.CURRENCY,
--                SP.CELL_PROD_SITE_ID
--          FROM GTT_TEMPFCSTNPRICE SP
--          WHERE 1=1
--            AND SP.DIVISION_ID = A.DIVISION_ID
--            AND CASE WHEN P_SCM_SITE_ID = 'ALL' THEN P_SCM_SITE_ID ELSE SP.SCM_SITE_ID END IN (
--                SELECT TOKEN
--                FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ''))
--            )
--            AND SP.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
--            AND SP.MEASURE = 'LOC'
--        ) SP
--        ON (
--           A.DIVISION_ID       = SP.DIVISION_ID
--        AND A.PROJECT_CODE      = SP.PROJECT_CODE
--        AND A.SCM_SITE_ID       = SP.SCM_SITE_ID
--        AND A.PLANT_SITE_ID     = SP.PLANT_SITE_ID
--        AND A.ITEM_ID           = SP.ITEM_ID
--        AND A.INCOTERMS         = SP.INCOTERMS
--        AND A.DOM_EXP           = SP.DOM_EXP
--        AND A.FCST_TYPE         = SP.FCST_TYPE
--        AND A.CELL_PROD_SITE_ID = SP.CELL_PROD_SITE_ID
--        AND A.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND V_TO_YYYYMMDD
--        AND NVL(A.CURRENCY,'') = ''
--        AND A.MEASURE NOT LIKE 'VMI%'
--    )
--    WHEN MATCHED THEN
--        UPDATE SET A.CURRENCY = SP.CURRENCY
--        ;
--



        --select count(*) into v_cnt from GTT_TEMPFCSTNPRICE;
        --DBMS_OUTPUT.PUT_LINE('2.GTT_TEMPFCSTNPRICE: '||v_cnt||'-건');

     v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 2-6: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

      --------------------------------------------------------------------------------------------------------------------------------
      -- #TempFcstNPrice 에 INSERT 한 메저들을 이용하여 판가 실적 계산
      -- LOC = MKT_AMT_LOC/RTF_SYS_RP
      -- KRW = MKT_AMT_KRW/RTF_SYS_RP
      --------------------------------------------------------------------------------------------------------------------------------
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

      INSERT /*+ APPEND PARALLEL(T1 8) */ INTO GTT_TEMPFCSTNPRICE T1
      ( DIVISION_ID       , PROJECT_CODE                  , END_CUSTOMER           , SCM_SITE_ID            , ITEM_ID              , DOM_EXP            , FCST_TYPE          , INCOTERMS        , MEASURE                 , PLANT_SITE_ID
      , CELL_PROD_SITE_ID , YYYYMMDD                      , QTY                    , MEASURE_GROUP          , CELL_MODEL           , NICK_NAME          , DMS_SALES          , DMS_CUSTOMER     , OWNER                   , DEPT_ID
      , DEPT_NAME_KO      , FORECAST_INFO_CELL_PACK_COUNT , ITEM_TYPE              , PROJECT_NAME           , PROJECT_OWNER
      , SOLDTO_CUSTOMER   , COUNTRY_NAME                  , CITY_NAME
      , ITEM_NAME         , VMI_YN                        , CUST_GROUP             , CUST_GROUP_DTL         , APPLICATION          , ROUTE              , MDM_PROJECT_NAME   , MIN_CAPACITY     , FORECAST_INFO_BIZ_TYPE  , CELL_TYPE
      , FORECAST_INFO_ALL , FORECAST_INFO_SPEC            , FORECAST_INFOR_VERSION , CELL_MODEL_NICK_NAME
      , SORT_ORDER_NO
      , CREATE_DATE       , LAST_UPDATED_BY
      , CURRENCY          , VERSION_NO                    , CUTOFF_YYYYMMDD        , NOTATION
      )
      --기존 소스 개선 및 FCST GAP 추가 ... START
      SELECT /*+ LEADING(A) USE_NL(D) USE_INDEX(D IDX01_GTT_TEMPSELECTMEASURE) */
             A.DIVISION_ID
           , A.PROJECT_CODE
           , A.PROJECT_CODE AS END_CUSTOMER
           , A.SCM_SITE_ID
           , A.ITEM_ID
           , A.DOM_EXP
           , A.FCST_TYPE
           , A.INCOTERMS
           , D.MEASURE
           , A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID
           , A.YYYYMMDD
           , CASE D.MEASURE
               WHEN 'LOC' THEN
                 CASE
                   WHEN SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END) <> 0
                   THEN SUM(CASE WHEN A.MEASURE = 'MKT_AMT_LOC' THEN A.QTY ELSE 0 END)
                        / SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END)
                   ELSE 0
                 END
               WHEN 'KRW' THEN
                 CASE
                   WHEN SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END) <> 0
                   THEN SUM(CASE WHEN A.MEASURE = 'MKT_AMT_KRW' THEN A.QTY ELSE 0 END)
                        / SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END)
                   ELSE 0
                 END
             END AS QTY
           , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
           , MAX(A.CELL_MODEL) AS CELL_MODEL
           , MAX(A.NICK_NAME) AS NICK_NAME
           , MAX(A.DMS_SALES) AS DMS_SALES
           , MAX(A.DMS_CUSTOMER) AS DMS_CUSTOMER
           , MAX(A.OWNER) AS OWNER
           , MAX(A.DEPT_ID) AS DEPT_ID
           , MAX(A.DEPT_NAME_KO) AS DEPT_NAME_KO
           , MAX(A.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
           , MAX(A.ITEM_TYPE) AS ITEM_TYPE
           , MAX(A.PROJECT_NAME) AS PROJECT_NAME
           , MAX(A.PROJECT_OWNER) AS PROJECT_OWNER
           , MAX(A.SOLDTO_CUSTOMER) AS SOLDTO_CUSTOMER
           , MAX(A.COUNTRY_NAME) AS COUNTRY_NAME
           , MAX(A.CITY_NAME) AS CITY_NAME
           , MAX(A.ITEM_NAME) AS ITEM_NAME
           , MAX(A.VMI_YN) AS VMI_YN
           , MAX(A.CUST_GROUP) AS CUST_GROUP
           , MAX(A.CUST_GROUP_DTL) AS CUST_GROUP_DTL
           , MAX(A.APPLICATION) AS APPLICATION
           , MAX(A.ROUTE) AS ROUTE
           , MAX(A.MDM_PROJECT_NAME) AS MDM_PROJECT_NAME
           , MAX(A.MIN_CAPACITY) AS MIN_CAPACITY
           , MAX(A.FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
           , MAX(A.CELL_TYPE) AS CELL_TYPE
           , MAX(A.FORECAST_INFO_ALL) AS FORECAST_INFO_ALL
           , MAX(A.FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
           , MAX(A.FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
           , MAX(A.CELL_MODEL_NICK_NAME) AS CELL_MODEL_NICK_NAME
           , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO
           , MAX(A.CREATE_DATE) AS CREATE_DATE
           , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
           , MAX(A.CURRENCY) AS CURRENCY
           , 'CURRENT' AS VERSION_NO
           , NULL AS CUTOFF_YYYYMMDD
           --[PJ2025-50188]... NOTATION 변경 (INTEGER -> POINT3)
           , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM GTT_TEMPFCSTNPRICE A
        JOIN GTT_TEMPSELECTMEASURE D
          ON D.MEASURE IN ('LOC','KRW')
       WHERE 1=1
         AND A.MEASURE IN ('RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW')
         AND A.YYYYMMDD >= P_FROM_YYYYMMDD
         AND A.YYYYMMDD <  V_TO_RESULT
       GROUP BY
             A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID,
             A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID,
             A.CELL_PROD_SITE_ID,
             A.CURRENCY, A.YYYYMMDD, D.MEASURE;
        COMMIT;
    --select count(*) into v_cnt from GTT_TEMPFCSTNPRICE;
    --DBMS_OUTPUT.PUT_LINE('3.GTT_TEMPFCSTNPRICE: '||v_cnt||'-건');

      DBMS_OUTPUT.PUT_LINE('step 2-6: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
      --------------------------------------------------------------------------------------------------------------------------------
      -- 종료 로그
      --------------------------------------------------------------------------------------------------------------------------------
--      DBMS_OUTPUT.PUT_LINE(
--          VA_PROGRAM_ID || ' : A018--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
--          || '#TempFcstNPrice 만들기 종료 - VERSION - CURRENT'
--      );

    END IF;


      v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 2-7: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

    -----------------------------------------------------------------------------------------------
    -- Unit Price 계산 후 불필요 MEASURE 삭제 (USER_ID=DM_ADMIN)
    -----------------------------------------------------------------------------------------------
    DELETE FROM GTT_TEMPFCSTNPRICE A
     WHERE EXISTS (
           SELECT 1
             FROM GTT_TEMPSELECTMEASURE B
            WHERE A.MEASURE = B.MEASURE
              AND B.USER_ID = 'DM_ADMIN'
     );
    COMMIT;

      v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 2-8: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

    -----------------------------------------------------------------------------------------------
  --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 END
  -----------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

  /* 최종적으로 동적쿼리로 조회 할 쿼리문을 완성 후 실행한다. */

  /* 동적쿼리에서 사용 할 동적 컬럼을 만드는 커서 */
  /* C_TITLE : 선택한 bucket의 값인 MONTH 혹은 WEEK를 이용해서 동적인 컬럼을 만드는 커서 */

  /* C_TITLE 커서 시작 */
  /* C_TITLE 커서 시작 */
  /* C_TITLE 커서 시작 */


       --=============================================================================================================================
    -- C_TITLE 커서: v_column / v_groupby / v_orderby 만들기
    --=============================================================================================================================
    v_column  := '';
    v_groupby := '';
    v_orderby := '';

    DBMS_OUTPUT.PUT_LINE('va_program_id:'||va_program_id||',va_sheet_name:'||va_sheet_name );

    FOR r IN (
        with w1 as (
        SELECT
            U.PROGRAM_ID,
            U.SHEET_NAME,
            U.COLUMN_NAME,
            CASE WHEN U.COLUMN_NAME = 'LAST_UPDATE_DATE' THEN '800'
                 WHEN U.COLUMN_NAME = 'LAST_UPDATED_BY'  THEN '560'
                 ELSE TO_CHAR(U.SORT_ORDER_NO) END AS SORT_ORDER_NO
        FROM SCM_MST_TITLESET_USER U
        JOIN SCM_MST_SHEET_COLUMNS C
          ON U.PROGRAM_ID = C.PROGRAM_ID
         AND U.SHEET_NAME = C.SHEET_NAME
         AND U.COLUMN_NAME = C.COLUMN_NAME
        WHERE U.PROGRAM_ID = va_program_id
          AND U.SHEET_NAME = va_sheet_name
          AND U.USER_ID = p_created_by
          AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'

        UNION ALL
        SELECT
            C.PROGRAM_ID,
            C.SHEET_NAME,
            C.COLUMN_NAME,
            TO_CHAR(CASE WHEN C.COLUMN_NAME='GROUP_ID' THEN NVL(TO_NUMBER(U.SORT_ORDER_NO),85) - 0.5 ELSE TO_NUMBER(C.SORT_ORDER_NO) END) AS SORT_ORDER_NO
        FROM SCM_MST_SHEET_COLUMNS C
        LEFT JOIN SCM_MST_TITLESET_USER U
          ON U.PROGRAM_ID = C.PROGRAM_ID
         AND U.SHEET_NAME = C.SHEET_NAME
         AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
         AND U.COLUMN_NAME IN ('ITEM_ID')
         AND U.USER_ID = p_created_by
        WHERE C.PROGRAM_ID = va_program_id
          AND C.SHEET_NAME  = va_sheet_name
          AND C.DEFAULT_FLAG = ' '  -- todo
          AND C.VALID_YN = 'Y'
        )
        select *
        from w1
        ORDER BY TO_NUMBER(SORT_ORDER_NO)
    ) LOOP
        IF v_column IS NULL OR DBMS_LOB.GETLENGTH(v_column)=0 THEN
            v_column  := r.COLUMN_NAME;
            v_groupby := ' GROUP BY ' || r.COLUMN_NAME;
            v_orderby := ' ORDER BY SORT_KEY, ' ||
                         CASE WHEN r.COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG') THEN r.COLUMN_NAME ELSE '' END;
        ELSE
            v_column  := v_column  || ', ' || r.COLUMN_NAME;
            v_groupby := v_groupby || ', ' || r.COLUMN_NAME;

            IF r.COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG') THEN
                v_orderby := v_orderby || ', ' || r.COLUMN_NAME;
            END IF;

        END IF;
    END LOOP;

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 2-9: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));


    -- [E20240812-000094] NOTATION 추가
    --[E20240812-000094]_해당컬럼으로 숫자표기형태를 구분하려고 하니, 해당 컬럼을 추출할수있도록 추가 START
    v_column := v_column || ', NOTATION';
    --[E20240812-000094]_해당컬럼으로 숫자표기형태를 구분하려고 하니, 해당 컬럼을 추출할수있도록 추가 END
    v_groupby := v_groupby || ', EDIT_FLAG, SORT_ORDER_NO';
    v_orderby := REPLACE(v_orderby, 'MEASURE_GROUP', ' TO_NUMBER(SORT_ORDER_NO)');
    v_orderby := REPLACE(v_orderby, ', MEASURE', '');

    /* C_TITLE 커서 종료 */
  /* C_TITLE 커서 종료 */
  /* C_TITLE 커서 종료 */

    --=============================================================================================================================
    -- 권한그룹을 LOOKUP관리 (BEGIN)
    --=============================================================================================================================
    SELECT COUNT(1) INTO V_CNT
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
           AND VALID_YN = 'Y'
           AND SEGMENT1 = p_user_group
           AND SEGMENT2 = 'ALL';

    IF NVL(V_CNT,0) > 0 THEN
        v_group_id := 'ADMIN';
    END IF;


    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 3-1: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));


    --=============================================================================================================================
    -- 권한그룹을 LOOKUP관리 (END)
    --=============================================================================================================================
  -------------------------------------------------------------------------------------------------------------------------
  --사용자의 요건: 소형사업부 계획수립 Timeline 단축으로 MKT FCST / SCM FCST가 월요일에 진행됨에 따라
  --MKT FCST 입력 제한을 시간 단위로 제한할 수 있도록 기능 개발 필요
  --[Timeline 단축에 따른 월요일 MKT FCST, SCM FCST 입력 시간 변경]
  --기존 월 24시 DM cutoff → 기존에는 화요일에 SCM_FCST만 입력 가능하도록 되어 있었으나,
  --변경 월 15시 DM Cutoff → 월 15시 30분 ~ 17시 30분 까지 SCM FCST 수정하고자 함

  --기존 룩업은 모든 메져에 날짜가 적혀있었는데, 의미없음. 실제 제한을 하는 메져만 일자를 두는것으로 룩업구성 변경함
  --룩업명: GET_ADMIN_GROUP_MEASURE

       -------------------------------------------------------------------------------------------------------------------------
    -- [E20250729-000433] ... GET_ADMIN_GROUP_MEASURE 로직
    -------------------------------------------------------------------------------------------------------------------------
  --1). GET_ADMIN_GROUP_MEASURE 룩업에서 데이터를 TEMP로 담는다
    INSERT INTO GTT_TEMP_INTO_GROUP_MEASURE
    SELECT
        B.USER_GROUP, B.DIVISION_ID, B.MEASURE, B.DAYS, B.FROM_TIME, B.TO_TIME, LM.TOKEN AS LIMIT_MEASURE
    FROM (
        SELECT
            A.SEGMENT1 AS USER_GROUP,
            A.SEGMENT3 AS DIVISION_ID,
            A.SEGMENT4 AS MEASURE,
            D.TOKEN    AS DAYS,
            A.ATTRIBUTE2 AS FROM_TIME,
            A.ATTRIBUTE3 AS TO_TIME,
            A.ATTRIBUTE4 AS LIMIT_MEASURE
        FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
        -- CROSS JOIN TABLE(STRING_SPLIT(A.ATTRIBUTE1, ',')) D
        CROSS JOIN LATERAL (
            SELECT TRIM(REGEXP_SUBSTR(A.ATTRIBUTE1, '[^,]+', 1, LEVEL)) AS token
            FROM dual
            CONNECT BY REGEXP_SUBSTR(A.ATTRIBUTE1, '[^,]+', 1, LEVEL) IS NOT NULL
        ) D
        WHERE A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
          AND A.VALID_YN = 'Y'
          AND A.SEGMENT1 = p_user_group
          AND A.SEGMENT2 = va_program_id
          AND A.SEGMENT3 = p_division_id
    ) B
    -- CROSS JOIN TABLE(STRING_SPLIT(B.LIMIT_MEASURE, ',')) LM
    CROSS JOIN LATERAL (
            SELECT TRIM(REGEXP_SUBSTR(B.LIMIT_MEASURE, '[^,]+', 1, LEVEL)) AS token
            FROM dual
            CONNECT BY REGEXP_SUBSTR(B.LIMIT_MEASURE, '[^,]+', 1, LEVEL) IS NOT NULL
    ) LM
    WHERE B.DAYS = CASE
        WHEN NVL(REPLACE(B.DAYS,' ',''),'') = '' THEN B.DAYS
        ELSE CASE TO_CHAR(SYSDATE, 'D')
             WHEN '1' THEN 'SUN'
             WHEN '2' THEN 'MON'
             WHEN '3' THEN 'TUE'
             WHEN '4' THEN 'WED'
             WHEN '5' THEN 'THU'
             WHEN '6' THEN 'FRI'
             WHEN '7' THEN 'SAT'
        END
    END
    AND B.FROM_TIME <= CASE
        WHEN NVL(REPLACE(B.FROM_TIME,' ',''),'') = '' THEN B.FROM_TIME
        ELSE SUBSTR(REPLACE(TO_CHAR(SYSDATE,'HH24:MI:SS'),':',''),1,4)
    END
    AND B.TO_TIME >= CASE
        WHEN NVL(REPLACE(B.TO_TIME,' ',''),'') = '' THEN B.TO_TIME
        ELSE SUBSTR(REPLACE(TO_CHAR(SYSDATE,'HH24:MI:SS'),':',''),1,4)
    END;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('step 3-2: p_user_group='||p_user_group||', va_program_id='||va_program_id||', p_division_id='||p_division_id||' P_SCN_SITE_ID:'||P_SCM_SITE_ID||' V_TO_RESULT:'||V_TO_RESULT||' V_TO_YYYYMMDD:'||V_TO_YYYYMMDD);

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 3-3: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));


  --2). 실제 관리하는 MEASURE와 권한이 가진 메져가 다른 경우가 있을수 있으므로, 해당 화면 기준으로 메져를 구한다음에 위에서 구한 메져로 EDIT_FLAG로 붙여준다
    INSERT INTO GTT_TEMP_ADMIN_GROUP_MEASURE
    SELECT
        A.MEASURE,
        CASE WHEN NVL(B.MEASURE,'') = '' THEN 'N' ELSE 'Y' END AS EDIT_FLAG
    FROM (
        SELECT A.SEGMENT4 AS MEASURE
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
         WHERE A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
           AND A.VALID_YN = 'Y'
           AND A.SEGMENT2 = va_program_id
         GROUP BY A.SEGMENT4
    ) A
    LEFT JOIN (
        SELECT MEASURE
          FROM GTT_TEMP_INTO_GROUP_MEASURE
         GROUP BY MEASURE
    ) B
      ON A.MEASURE = B.MEASURE;
    COMMIT;

     v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 3-4: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));



    --3). #TEMP_INTO_GROUP_MEASURE 테이블에 적재한 데이터 중 LIMIT_MEASURE가 존재하는 경우 해당 메져의 FLAG는 N으로 변경해준다
    SELECT COUNT(*) INTO V_CNT FROM GTT_TEMP_INTO_GROUP_MEASURE A WHERE NVL(A.LIMIT_MEASURE,'') <> '';
    IF V_CNT >= 1 THEN
        UPDATE GTT_TEMP_ADMIN_GROUP_MEASURE A
           SET A.EDIT_FLAG = 'N'
         WHERE EXISTS (
            SELECT 1
              FROM GTT_TEMP_INTO_GROUP_MEASURE B
             WHERE A.MEASURE = B.LIMIT_MEASURE
         );
         COMMIT;
    END IF;
  --[E20250729-000433]_[공급/생산SCM PI팀] 월요일 SCM FCST 입력 시 MKT FCST 수정 불가하도록 시스템 개선 END
  -------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

     v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 3-5: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));


    --#CAL_MONTH_END_DATE 만들기 시작
    INSERT INTO GTT_CAL_MONTH_END_DATE (MONTH_END_DATE)
    SELECT MAX(BASIS_YYYYMMDD)
      FROM SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
     GROUP BY BASIS_YYYYMM;
    COMMIT;

    --DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A027--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' #CAL_MONTH_END_DATE 만들기 성공');

     v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 3-6: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));



    --#CAL_WEEK_END_DATE 만들기 시작
    INSERT INTO GTT_CAL_WEEK_END_DATE (WEEK_END_DATE)
    SELECT MAX(BASIS_YYYYMMDD)
      FROM SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
     GROUP BY ISO_YYYYWW || PARTIAL_WEEK_NAME;

    COMMIT;

    --DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A028--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' #CAL_WEEK_END_DATE 만들기 성공');

     v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 3-7: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));


    --SELECT COUNT(*) INTO V_CNT FROM GTT_MF_SP;
    --DBMS_OUTPUT.PUT_LINE('GTT_MF_SP:'||V_CNT||'-건');
    --DBMS_OUTPUT.PUT_LINE('P_DIVISION_ID:'||P_DIVISION_ID);
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
      DBMS_STATS.GATHER_TABLE_STATS(
          ownname          => 'SCM_MGR',
          tabname          => 'GTT_TEMPFCSTNPRICE',
          estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
          method_opt       => 'FOR ALL COLUMNS SIZE 1',
          cascade          => TRUE,
          degree           => 8
      );

      DBMS_STATS.GATHER_TABLE_STATS(
          ownname          => 'SCM_MGR',
          tabname          => 'GTT_CAL_MONTH_END_DATE',
          estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
          method_opt       => 'FOR ALL COLUMNS SIZE 1',
          cascade          => TRUE,
          degree           => 8
      );


      DBMS_STATS.GATHER_TABLE_STATS(
          ownname          => 'SCM_MGR',
          tabname          => 'GTT_CAL_WEEK_END_DATE',
          estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
          method_opt       => 'FOR ALL COLUMNS SIZE 1',
          cascade          => TRUE,
          degree           => 8
      );
*/


    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

    /* 동적쿼리에서 사용될 MF_SP 임시테이블 */
    INSERT /*+ APPEND PARALLEL(T 8) */ INTO GTT_MF_SP T

    WITH P_TEAM AS (
        SELECT TRIM(REGEXP_SUBSTR(P_TEAM_ID, '[^,]+', 1, LEVEL)) AS token
        FROM dual
        CONNECT BY REGEXP_SUBSTR(P_TEAM_ID, '[^,]+', 1, LEVEL) IS NOT NULL
    )
    SELECT /*+ PARALLEL(A 8) */
        A.DIVISION_ID,
        A.SCM_SITE_ID,
        A.PLANT_SITE_ID,
        A.PROJECT_CODE,
        A.ITEM_ID,
        A.INCOTERMS,
        A.FCST_TYPE,
        A.DOM_EXP,
        A.MEASURE,
        A.END_CUSTOMER,
        A.NICK_NAME,
        A.DMS_SALES,
        A.DMS_CUSTOMER,
        C.BASIS_YYYYMM AS YYYYMM,
        C.BASIS_YYYYMM || C.ISO_WEEK AS YYYYMMWW,
        C.BASIS_YYYYMMDD AS YYYYMMDD,
        C.DAYOFWEEK,
        A.CELL_MODEL AS FORECAST_INFO_CELL_MODEL,
        A.DEPT_ID AS TEAM_ID,
        A.DEPT_NAME_KO AS TEAM_NAME_KO,
        A.ITEM_TYPE,
        A.PROJECT_NAME,
        A.PROJECT_OWNER,
        A.OWNER,
        A.SOLDTO_CUSTOMER,
        A.COUNTRY_NAME,
        A.CITY_NAME,
        A.ITEM_NAME,
        A.VMI_YN,
        A.CELL_PROD_SITE_ID,
        A.CUST_GROUP,
        A.CUST_GROUP_DTL,
        A.APPLICATION,
        A.ROUTE,
        A.MDM_PROJECT_NAME,
        A.MIN_CAPACITY,
        A.FORECAST_INFO_BIZ_TYPE,
        A.CELL_TYPE,
        A.FORECAST_INFO_CELL_PACK_COUNT,
        A.FORECAST_INFO_ALL,
        A.FORECAST_INFO_SPEC,
        A.FORECAST_INFOR_VERSION,
        A.CELL_MODEL_NICK_NAME,
        CAST(A.QTY AS NUMBER(36,10)) AS QTY,
        CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN 'Y' ELSE 'N' END AS MONTH_END_YN,
        CASE WHEN C3.WEEK_END_DATE  IS NOT NULL THEN 'Y' ELSE 'N' END AS WEEK_END_YN,
        CASE
            WHEN MA.DEPT_ID IS NOT NULL AND A.MEASURE_GROUP NOT IN ('CUST_FCST_2','CUST_FCST_3','TMM_FCST') AND A.MEASURE = M1.SEGMENT3 THEN 'Y'
            WHEN (v_group_id='ADMIN') AND A.MEASURE_GROUP <> 'TMM_FCST' AND A.MEASURE = M1.SEGMENT3 THEN 'Y'
            ELSE 'N'
        END AS EDIT_FLAG,
        A.SORT_ORDER_NO,
        A.MEASURE_GROUP,
        'N' AS NEW_FLAG,
        NVL(BK.BUCKET, '0000000') AS BUCKET,
        999 AS SORT_KEY,
        CASE WHEN NVL(A.CREATE_DATE,'') = '' THEN ' ' ELSE A.CREATE_DATE END AS LAST_UPDATE_DATE,
        CASE WHEN NVL(A.LAST_UPDATED_BY,'') = '' THEN ' ' ELSE A.LAST_UPDATED_BY END AS LAST_UPDATED_BY,
        A.NOTATION,
        A.CURRENCY,
        A.VERSION_NO,
        A.CUTOFF_YYYYMMDD
    FROM GTT_TEMPFCSTNPRICE A
    JOIN SCM_SYS_CALENDAR_M C
      ON C.BASIS_YYYYMMDD = A.YYYYMMDD

    LEFT JOIN GTT_CAL_MONTH_END_DATE C2
      ON A.YYYYMMDD = C2.MONTH_END_DATE

    LEFT JOIN GTT_CAL_WEEK_END_DATE C3
      ON A.YYYYMMDD = C3.WEEK_END_DATE

    LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M1
      ON A.DIVISION_ID = M1.SEGMENT2
     AND A.MEASURE     = M1.SEGMENT3
     AND M1.LOOKUP_TYPE = 'DM_UI_EDITABLE_MEASURE'
     AND M1.SEGMENT1    = 'DMF0082'
     AND M1.ATTRIBUTE2  = 'Y'
     AND M1.VALID_YN    = 'Y'

    LEFT JOIN (
        /* 오류 쿼리 2026.01.28
        SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS,
               MAX(CASE WHEN YYYYMMDD='SUN' THEN BUCKET_PER END) ||
               MAX(CASE WHEN YYYYMMDD='MON' THEN BUCKET_PER END) ||
               MAX(CASE WHEN YYYYMMDD='TUE' THEN BUCKET_PER END) ||
               MAX(CASE WHEN YYYYMMDD='WED' THEN BUCKET_PER END) ||
               MAX(CASE WHEN YYYYMMDD='THU' THEN BUCKET_PER END) ||
               MAX(CASE WHEN YYYYMMDD='FRI' THEN BUCKET_PER END) ||
               MAX(CASE WHEN YYYYMMDD='SAT' THEN BUCKET_PER END) AS BUCKET
        FROM (
            SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, YYYYMMDD,
                   CASE WHEN BUCKET_PER='Y' THEN '1' ELSE '0' END AS BUCKET_PER
            FROM DM_MST_BUCKET_CONVERSION
        )
        WHERE DIVISION_ID = p_division_id
        GROUP BY DIVISION_ID, SCM_SITE_ID, INCOTERMS
        */
        SELECT
            DIVISION_ID,
            SCM_SITE_ID,
            INCOTERMS,
            NVL(SUN, '0') || NVL(MON, '0') || NVL(TUE, '0') || NVL(WED, '0') ||
            NVL(THU, '0') || NVL(FRI, '0') || NVL(SAT, '0') AS BUCKET
        FROM (
            SELECT
                DIVISION_ID,
                SCM_SITE_ID,
                INCOTERMS,
                YYYYMMDD,
                CASE WHEN BUCKET_PER = 'Y' THEN '1' ELSE '0' END AS BUCKET_PER
            FROM DM_MST_BUCKET_CONVERSION D1
        ) BU
        PIVOT (
            MAX(BUCKET_PER)
            FOR YYYYMMDD IN (
                'SUN' AS SUN,
                'MON' AS MON,
                'TUE' AS TUE,
                'WED' AS WED,
                'THU' AS THU,
                'FRI' AS FRI,
                'SAT' AS SAT
            )
        )
        WHERE DIVISION_ID = p_division_id


    ) BK
      ON A.DIVISION_ID = BK.DIVISION_ID
     AND A.SCM_SITE_ID = BK.SCM_SITE_ID
     AND A.INCOTERMS = BK.INCOTERMS
    LEFT JOIN (
        SELECT LOOK.SEGMENT3 AS DEPT_ID
        FROM TB_FX_User USR
        JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LOOK
          ON USR.DEPT_ID = LOOK.SEGMENT1
         AND LOOK.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
         AND LOOK.VALID_YN = 'Y'
        WHERE USR.UserID = p_created_by
        UNION
        SELECT DEPT_ID
        FROM TB_FX_User
        WHERE UserID = p_created_by
    ) MA
      ON A.DEPT_ID = MA.DEPT_ID
    WHERE (CASE WHEN p_team_id = 'ALL' THEN p_team_id ELSE A.DEPT_ID END)
        IN (SELECT TOKEN
--            FROM TABLE(STRING_SPLIT(p_team_id, ','))
            FROM P_TEAM
            );

    COMMIT;

    SELECT COUNT(*) INTO V_CNT FROM GTT_MF_SP;
    DBMS_OUTPUT.PUT_LINE('GTT_MF_SP:'||V_CNT||'-건');

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 3-8: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

/*
      DBMS_STATS.GATHER_TABLE_STATS(
          ownname          => 'SCM_MGR',
          tabname          => 'GTT_MF_SP',
          estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
          method_opt       => 'FOR ALL COLUMNS SIZE 1',
          cascade          => TRUE,
          degree           => 8
      );
*/

    --    -- p_qty_yn = 'Y' 필터
    --2025.03.10 Philsu Park: MKT Fcst 수량 없는거 날리고 조회하는 구문 테스트.
    IF p_qty_yn = 'Y' THEN

        v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
          + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
          + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
          + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
        v_start_ts := systimestamp;
        DBMS_OUTPUT.PUT_LINE('step 3-9: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));




        EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';


--        INSERT /*+ APPEND PARALLEL(T 8) */ INTO GTT_MF_SP_KEEP T
--        SELECT /*+ PARALLEL(SP 8) */ SP.*
--          FROM GTT_MF_SP SP
--          JOIN (
--            SELECT /* MATERIALIZE PARALLEL(8) */ DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, FCST_TYPE, DOM_EXP, END_CUSTOMER, CELL_PROD_SITE_ID
--            FROM GTT_MF_SP
--            WHERE MEASURE IN ('MKT_FCST','SCM_FCST')
--            GROUP BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, FCST_TYPE, DOM_EXP, END_CUSTOMER, CELL_PROD_SITE_ID
--            HAVING SUM(QTY) <> 0
--            ) k
--                ON K.DIVISION_ID = SP.DIVISION_ID
--               AND K.SCM_SITE_ID = SP.SCM_SITE_ID
--               AND K.PROJECT_CODE = SP.PROJECT_CODE
--               AND K.ITEM_ID = SP.ITEM_ID
--               AND K.INCOTERMS = SP.INCOTERMS
--               AND K.FCST_TYPE = SP.FCST_TYPE
--               AND K.DOM_EXP = SP.DOM_EXP
--               AND K.END_CUSTOMER = SP.END_CUSTOMER
--               AND K.CELL_PROD_SITE_ID = SP.CELL_PROD_SITE_ID
--               ;
--
--
--        COMMIT;
--
--        EXECUTE IMMEDIATE 'TRUNCATE TABLE GTT_MF_SP';
--
--        INSERT /*+ PARALLEL(T 8) */  INTO GTT_MF_SP T
--        SELECT * FROM GTT_MF_SP_KEEP;
--        COMMIT;



            -- 1/2
            EXECUTE IMMEDIATE 'TRUNCATE TABLE gtt_mf_sp_keep';

            INSERT /*+ APPEND */ INTO gtt_mf_sp_keep

            WITH k AS (
                SELECT /*+ MATERIALIZE */ DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, FCST_TYPE, DOM_EXP, END_CUSTOMER, CELL_PROD_SITE_ID
                  FROM GTT_MF_SP T1
                 WHERE MEASURE IN ('MKT_FCST','SCM_FCST')
                 GROUP BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, FCST_TYPE, DOM_EXP, END_CUSTOMER, CELL_PROD_SITE_ID
                HAVING SUM(QTY) <> 0
            )
            SELECT sp.*
            FROM gtt_mf_sp sp
            JOIN k
              ON k.division_id       = sp.division_id
             AND k.scm_site_id       = sp.scm_site_id
             AND k.project_code      = sp.project_code
             AND k.item_id           = sp.item_id
             AND k.incoterms         = sp.incoterms
             AND k.fcst_type         = sp.fcst_type
             AND k.dom_exp           = sp.dom_exp
             AND k.end_customer      = sp.end_customer
             AND k.cell_prod_site_id = sp.cell_prod_site_id;
            COMMIT;

            -- 2/2
            EXECUTE IMMEDIATE 'TRUNCATE TABLE gtt_mf_sp';

            INSERT /*+ APPEND */ INTO GTT_MF_SP
            SELECT * FROM gtt_mf_sp_keep;

            COMMIT;





--
--        DELETE /* parallel(SP 8) */
--        FROM GTT_MF_SP SP
--         WHERE NOT EXISTS (
--            SELECT 1
--              FROM (
--                SELECT /*+ MATERIALIZE */ DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, FCST_TYPE, DOM_EXP, END_CUSTOMER, CELL_PROD_SITE_ID
--                  FROM GTT_MF_SP T1
--                 WHERE MEASURE IN ('MKT_FCST','SCM_FCST')
--                 GROUP BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, FCST_TYPE, DOM_EXP, END_CUSTOMER, CELL_PROD_SITE_ID
--                HAVING SUM(QTY) <> 0
--              ) TT
--             WHERE TT.DIVISION_ID = SP.DIVISION_ID
--               AND TT.SCM_SITE_ID = SP.SCM_SITE_ID
--               AND TT.PROJECT_CODE = SP.PROJECT_CODE
--               AND TT.ITEM_ID = SP.ITEM_ID
--               AND TT.INCOTERMS = SP.INCOTERMS
--               AND TT.FCST_TYPE = SP.FCST_TYPE
--               AND TT.DOM_EXP = SP.DOM_EXP
--               AND TT.END_CUSTOMER = SP.END_CUSTOMER
--               AND TT.CELL_PROD_SITE_ID = SP.CELL_PROD_SITE_ID
--         );
--         COMMIT;


        SELECT COUNT(*) INTO V_CNT FROM GTT_MF_SP;
        DBMS_OUTPUT.PUT_LINE('GTT_MF_SP:'||V_CNT||'-건');

        v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
          + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
          + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
          + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
        v_start_ts := systimestamp;
        DBMS_OUTPUT.PUT_LINE('step 4-1: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

    END IF;

    SELECT COUNT(*) INTO V_CNT FROM GTT_MF_SP;

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 5-1: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));



    -- 디버깅용 delete from GTT_MF_SP_temp2;
    -- 디버깅용 insert into GTT_MF_SP_temp2 select * from gtt_mf_sp;

    -- =========================================================================================================================
    -- 동적 PIVOT 실행 (MSSQL: SP_EXECUTESQL @v_sql_text)
    -- Oracle: EXECUTE IMMEDIATE로 동적 SQL을 커서로 열고 RETURN_RESULT
    -- =========================================================================================================================

    -- v_column / v_orderby / v_pv_col_list 구성은 MSSQL C_TITLE 커서 로직을 그대로 Oracle FOR LOOP로 만들면 됩니다.
    -- (여기서는 “이미 구성되었다”는 가정 하에 동적쿼리 실행만 완성본 제공)

    -- *****
    --v_column := 'DIVISION_ID';

    /*
    DBMS_OUTPUT.PUT_LINE('----------------------------');
    DBMS_OUTPUT.PUT_LINE('v_pv_list:'||v_pv_list);
    DBMS_OUTPUT.PUT_LINE('v_column:'||v_column);
    DBMS_OUTPUT.PUT_LINE('----------------------------');
    */
    /* 26.01.28 V_ORDERBY에서 CURRENCY 제외 .. MEASURE 순서 표시를 위해서.. CURRENCY NULL값으로 인해서 순서 바뀜.
    MKT_FCST
    RTF_SYS_RP
    SCM_FCST
    KRW
    USD
    LOC
    */

    SELECT REPLACE(V_ORDERBY,'CURRENCY,','') INTO V_ORDERBY FROM DUAL;

    /* --------------- */

    /* 최종적으로 실행하는 동적쿼리 */
    /* SORT_KEY 추가 26.01.22*/
    v_sql_text :=
--        'SELECT ' || v_column || ', SORT_ORDER_NO, ' || v_pv_list || CHR(10) ||
        'SELECT ' || v_column || ', SORT_ORDER_NO, ' || v_pv_list || CHR(10) ||
--        'SELECT ' || v_column || ', SORT_ORDER_NO, SORT_KEY, M_202601' || CHR(10) ||
        '  FROM (' || CHR(10) ||
        -- '        SELECT ' || v_column || ', F.SORT_ORDER_NO, F.SORT_KEY as SORT_KEY, ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY' || CHR(10) ||
        '        SELECT ' || v_column || ', F.SORT_ORDER_NO,  ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY' || CHR(10) ||
        '          FROM GTT_MF_SP F' || CHR(10) ||
        '         WHERE 1=1' || CHR(10) ||
        '           AND ( (F.MEASURE NOT IN (''SCM_FCST'', ''FCST_GAP'') AND F.QTY <> 0) OR (F.MEASURE IN (''SCM_FCST'', ''FCST_GAP'')) )' || CHR(10) ||
        '        UNION ALL' || CHR(10) ||
        '        SELECT ' || v_column || ', F.SORT_ORDER_NO,  ''W_'' || F.YYYYMMWW AS YYYYMMDD,' || CHR(10) ||
        '               SUM(CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'') AND F.WEEK_END_YN = ''Y'' THEN F.QTY ELSE F.QTY END) AS QTY' || CHR(10) ||
        '          FROM GTT_MF_SP F' || CHR(10) ||
        '         WHERE 1=1' || CHR(10) ||
        '           AND F.MEASURE NOT IN (''KRW'', ''USD'', ''LOC'')' || CHR(10) ||
        '           AND ( (F.MEASURE NOT IN (''SCM_FCST'', ''FCST_GAP'') AND F.QTY <> 0) OR (F.MEASURE IN (''SCM_FCST'', ''FCST_GAP'')) )' || CHR(10) ||
        '         GROUP BY ' || v_column || ', F.SORT_ORDER_NO,F.SORT_KEY, F.YYYYMMWW, F.WEEK_END_YN' || CHR(10) ||
        '        UNION ALL' || CHR(10) ||
        '        SELECT ' || v_column || ', F.SORT_ORDER_NO,  ''W_'' || F.YYYYMMWW AS YYYYMMDD, AVG(F.QTY) AS QTY' || CHR(10) ||
        '          FROM GTT_MF_SP F' || CHR(10) ||
        '         WHERE F.MEASURE IN (''KRW'', ''USD'', ''LOC'')' || CHR(10) ||
        '         GROUP BY ' || v_column || ', F.SORT_ORDER_NO,F.SORT_KEY, F.YYYYMMWW' || CHR(10) ||
        '        UNION ALL' || CHR(10) ||
        '        SELECT ' || v_column || ', F.SORT_ORDER_NO, ''M_'' || F.YYYYMM AS YYYYMMDD,' || CHR(10) ||
        '               SUM(CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'') AND F.MONTH_END_YN = ''Y'' THEN F.QTY ELSE F.QTY END) AS QTY' || CHR(10) ||
        '          FROM GTT_MF_SP F' || CHR(10) ||
        '         WHERE 1=1' || CHR(10) ||
        '           AND F.MEASURE NOT IN (''KRW'', ''USD'', ''LOC'')' || CHR(10) ||
        '           AND ( (F.MEASURE NOT IN (''SCM_FCST'', ''FCST_GAP'') AND F.QTY <> 0) OR (F.MEASURE IN (''SCM_FCST'', ''FCST_GAP'')) )' || CHR(10) ||
        '         GROUP BY ' || v_column || ', F.SORT_ORDER_NO,F.SORT_KEY, F.YYYYMM, F.MONTH_END_YN' || CHR(10) ||
        '        UNION ALL' || CHR(10) ||
        '        SELECT ' || v_column || ', F.SORT_ORDER_NO,  ''M_'' || F.YYYYMM AS YYYYMMDD, AVG(F.QTY) AS QTY' || CHR(10) ||
        '          FROM GTT_MF_SP F' || CHR(10) ||
        '         WHERE F.MEASURE IN (''KRW'', ''USD'', ''LOC'')' || CHR(10) ||
        '         GROUP BY ' || v_column || ', F.SORT_ORDER_NO, F.SORT_KEY, F.YYYYMM' || CHR(10) ||
        '       ) F' || CHR(10) ||
--                ' PIVOT (SUM(QTY) FOR YYYYMMDD IN (' || v_pv_col_list || ')) PVT' || CHR(10) ||
        ' PIVOT (SUM(QTY) FOR YYYYMMDD IN ('||v_pv_col_list||')) PVT' || CHR(10) ||
--        ' PIVOT (SUM(QTY) FOR YYYYMMDD IN ( ''M_202601'' as M_202601'||' )) PVT' || CHR(10) ||
        ' ' || v_orderby;

    -- DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A033--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' 첫번째 DataTable 시작');
    /* DEBUG
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('v_orderby:'||v_orderby);
    DBMS_OUTPUT.PUT_LINE(v_sql_text);
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------');
    */

    --SELECT COUNT(*) INTO V_CNT FROM GTT_MF_SP;
    --DBMS_OUTPUT.PUT_LINE('V_COLUMN:'||V_COLUMN  );
    --DBMS_OUTPUT.PUT_LINE('GTT_MF_SP:'||V_CNT  );
    --DBMS_OUTPUT.PUT_LINE('OPEN CURSOR AND DBMS_SQL.RETURN_RESULT>>>>>>>>>>>>>>>>>>>>');

    --DBMS_OUTPUT.PUT_LINE('open cursor >>>>>>>>>>>>>>>>>>>>');
    --DBMS_OUTPUT.PUT_LINE(v_sql_text);

    OPEN o_rc1 FOR v_sql_text;

    -- DBMS_SQL.RETURN_RESULT(o_rc1);


    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 6-1: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

    --=============================================================================================================================
    -- (2) 두번째 DataTable: M+3 월부터 수정 가능 (o_rs2)
    --=============================================================================================================================
    OPEN o_rc2 FOR
        SELECT MONTH_NAME, ISO_WEEK
          FROM (
                SELECT MONTH_NAME, ISO_WEEK
                FROM SCM_SYS_CALENDAR_M
                WHERE BASIS_YYYYMM = TO_CHAR(ADD_MONTHS(SYSDATE, 3), 'YYYYMM')
                ORDER BY BASIS_YYYYMMDD
          )
         WHERE ROWNUM = 1;

    -- DBMS_SQL.RETURN_RESULT(o_rc2);


    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 6-2: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

    --=============================================================================================================================
    -- (3) 세번째 DataTable: 현재 주차 / 전주 주차 (o_rs3)
    --=============================================================================================================================
    OPEN o_rc3 FOR
        SELECT
            'M_' || A.BASIS_YYYYMM AS THIS_YYYYMM,
            'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS THIS_YYYYMMWW,
            A.BASIS_DATE,
            'M_' || B.BASIS_YYYYMM AS PRE_YYYYMM,
            'W_' || B.BASIS_YYYYMM || B.ISO_WEEK AS PRE_YYYYMMWW,
            A.BASIS_YYYYMM,
            A.ISO_WEEK
        FROM (
            SELECT BASIS_YYYYMM, ISO_WEEK, TO_CHAR(BASIS_DATE, 'YYYYMMDD') BASIS_DATE
            FROM SCM_SYS_CALENDAR_M
            WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')
        ) A
        JOIN (
            SELECT BASIS_YYYYMM, ISO_WEEK, TO_CHAR(BASIS_DATE, 'YYYYMMDD') BASIS_DATE
            FROM SCM_SYS_CALENDAR_M
            WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE - 7, 'YYYYMMDD')
        ) B
          ON 1=1;

    -- DBMS_SQL.RETURN_RESULT(o_rc3);

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 6-3: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

    --=============================================================================================================================
    -- (4) 네번째 DataTable: EDIT_FLAG 목록 (o_rs4)
    --=============================================================================================================================
    OPEN o_rc4 FOR
        SELECT A.MEASURE, A.EDIT_FLAG
          FROM GTT_TEMP_ADMIN_GROUP_MEASURE A;

    -- DBMS_SQL.RETURN_RESULT(o_rc4);

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 6-4: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

    --=============================================================================================================================
    -- (5) 다섯번째 DataTable: 월별 배분 로직 캘린더 (o_rs5)
    --  - MSSQL 원본 로직 동일:
    --    * FIRST_WEEK_FLAG : BASIS_START_DATE(해당 주 시작일)의 일이 '01'이면 Y
    --    * END_MONTH_FLAG  : BASIS_START_DATE + 7일의 월(YYYYMM)이 BASIS_START_DATE의 월(YYYYMM)과 다르면 Y
    --    * MONTH_DAY_CNT   : 월별 일수(analytic)
    --    * WEEK_DAY_CNT    : 주차별 일수(analytic) (ISO_YYYYWW + PARTIAL_WEEK_NAME 기준)
    --=============================================================================================================================
    OPEN o_rc5 FOR
        SELECT
            BASIS_YYYYMMDD,                                        -- UI에서 BASIS_YYYYMMDD 로 값을 가져 온다.
            BASIS_YYYYMM,                                          -- UI에서 BASIS_YYYYMM 로 값을 가져 온다.
            CASE
                WHEN SUBSTR(BASIS_START_DATE, 7, 2) = '01' THEN 'Y'
                ELSE 'N'
            END AS FIRST_WEEK_FLAG,                                -- 매월 1일이 포함된 주차 FLAG
            CASE
                WHEN SUBSTR(TO_CHAR(TO_DATE(BASIS_START_DATE, 'YYYYMMDD') + 7, 'YYYYMMDD'), 1, 6) =
                     SUBSTR(BASIS_START_DATE, 1, 6)
                THEN 'N'
                ELSE 'Y'
            END AS END_MONTH_FLAG,                                 -- 월별 마지막 주차 FLAG
            COUNT(*) OVER (PARTITION BY BASIS_YYYYMM) AS MONTH_DAY_CNT,                     -- 해당 월의 일개수
            COUNT(*) OVER (PARTITION BY ISO_YYYYWW || PARTIAL_WEEK_NAME) AS WEEK_DAY_CNT,   -- 해당 주의 일개수
            ISO_YYYYWW                                              -- [20250616] KJIYOON
        FROM SCM_SYS_CALENDAR_M
        WHERE BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        ORDER BY BASIS_YYYYMMDD;

    -- DBMS_SQL.RETURN_RESULT(o_rc5);

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 6-5: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

    -- DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A034--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' 첫번째 DataTable 종료');
    COMMIT;
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 6-6: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));


END;