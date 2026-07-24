CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0082_GET_MAIN_DATA_0202" 
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
    --=============================================================================================================================
    -- LOG �� ���� ���� (START) -- [E20250915-000105]_������ ���������� LOG�� ���� ���� (START)
    --=============================================================================================================================
    v_program_name   VARCHAR2(150) := 'DMF0082_GET_MAIN_DATA';
    v_log_type       VARCHAR2(30);
    n_log_count      PLS_INTEGER := 0;
    v_log_message    VARCHAR2(1000);
    v_description    VARCHAR2(500);
    d_event_date     TIMESTAMP;
    --=============================================================================================================================
    -- LOG �� ���� ���� (END)  -- [E20250915-000105]_������ ���������� LOG�� ���� ���� (END)
    --=============================================================================================================================

    V_CNT NUMBER := 0;

    --=============================================================================================================================
    -- ������ ���� �� ���� ���� ���� ���� (START)
    --=============================================================================================================================
    v_user_col_cnt   PLS_INTEGER;
    v_user_mea_cnt   PLS_INTEGER;
    va_program_id    VARCHAR2(50) := 'DMF0082';
    va_sheet_name    VARCHAR2(50) := 'FcstNPrice';
    --=============================================================================================================================
    -- ������ ���� �� ���� ���� ���� ���� (END)
    --=============================================================================================================================

    -- BUCKET ���� ����
    v_exp_yyyymmdd     VARCHAR2(8);
    v_pv_list          CLOB;
    v_pv_col_list      CLOB;
    v_pv_column_name   VARCHAR2(200);
    v_pv_name          VARCHAR2(100);
    v_sort_order_no    VARCHAR2(50);

    -- ���� ����
    v_from_yyyymmdd    VARCHAR2(8);
    v_to_yyyymmdd      VARCHAR2(8);
    v_from_result      VARCHAR2(8);
    v_to_result        VARCHAR2(8);
    v_user_time_zone   VARCHAR2(50);

    -- �������� ����
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

    -- DBMS_OUTPUT.PUT_LINE(v_program_name || ' : A001--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' DMF0082_GET_MAIN_DATA �������� ����');

    --=============================================================================================================================
    -- ���� LOG (START)  -- [E20250915-000105]_������ ���������� LOG ���� (START)
    --=============================================================================================================================
    v_log_type      := 'START';
    v_log_message   := '########## Start of procedure ##########';
    v_description   := '';
    d_event_date    := SYSTIMESTAMP;

    -- MSSQL: EXEC PR_DM_SYS_LOG_BATCH ...
    -- Oracle: ���� ���� ���������� ���������� ����(���� ���������� �������� ����)
    PR_DM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_created_by);
    --=============================================================================================================================
    -- ���� LOG (END)
    --=============================================================================================================================
    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;
    DBMS_OUTPUT.PUT_LINE('step 0-2: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

    --=============================================================================================================================
    -- ������ ���� ���� (START)
    --=============================================================================================================================
    --DBMS_OUTPUT.PUT_LINE(v_program_name || ' : A002--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ������ ���� ���� (START)');

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
        COMMIT;
    END IF;

    --DBMS_OUTPUT.PUT_LINE(v_program_name || ' : A002--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ������ ���� ���� (END)');
    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 1-1: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

    --=============================================================================================================================
    -- ������ ���� ���� (START)
    --=============================================================================================================================
    --DBMS_OUTPUT.PUT_LINE(v_program_name || ' : A003--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ������ ���� ���� (START)');

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
        COMMIT;
    END IF;

    --DBMS_OUTPUT.PUT_LINE(v_program_name || ' : A003--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ������ ���� ���� (END)');

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 1-3: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

    --=============================================================================================================================
    -- ������ ���� ���� (END)
    --=============================================================================================================================

    --=============================================================================================================================
    -- BUCKET �� v_pv_col_list , v_pv_list ������ (START)
    --=============================================================================================================================
--    DBMS_OUTPUT.PUT_LINE(v_program_name || ' : A004--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' BUCKET �� v_pv_col_list , v_pv_list ������ (START)');
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
--        -- Oracle PIVOT�� IN ��:  'D_20260101' AS D_20260101 ������ �������� ��
--        IF v_pv_col_list IS NULL OR v_pv_col_list = '' THEN
--            v_pv_col_list := '''' || r.PV_KEY || ''' AS ' || r.PV_KEY;
--            v_pv_list     := '''' || r.PV_KEY || '''';
--        ELSE
--            v_pv_col_list := v_pv_col_list || ', ' || '''' || r.PV_KEY || ''' AS ' || r.PV_KEY;
--            v_pv_list     := v_pv_list || ', ' || '''' || r.PV_KEY || '''';
--        END IF;
--    END LOOP;
--
--    DBMS_OUTPUT.PUT_LINE(v_program_name || ' : A004--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' BUCKET �� v_pv_col_list , v_pv_list ������ (END)');


    --=============================================================================================================================
    -- BUCKET ���� ���� ���� (START)
    --=============================================================================================================================
    -- MSSQL: DATEADD(WEEK, 50, @p_from_yyyymmdd)
    -- MSSQL: CURSOR LOCAL FAST_FORWARD
    -- ORACLE: ���� FOR UPDATE ���� READ ONLY ������ ����
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
-- BUCKET ���� ���� ���� (START)

    v_pv_list     := NULL;  -- SELECT ���� ���� ������ ������ (D_20260101, W_20260103 ...)
    v_pv_col_list := NULL;  -- PIVOT IN �� ������ ('D_20260101' AS D_20260101, ...)
     -- BUCKET ���� ���� ���� (START)
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
        -- PIVOT IN �� ������:  '<key>' AS <alias>, ...
        RTRIM(
          XMLCAST(
            XMLAGG(XMLELEMENT(e, pivot_in_piece || ', ') ORDER BY sort_order_no)
            AS CLOB
          ),
          ', '
        ) AS pv_col_list,

        -- SELECT �� ������: <alias>, ...
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


    -- ������ ���� (����)
    --DBMS_OUTPUT.PUT_LINE('v_pv_col_list=' || DBMS_LOB.SUBSTR(v_pv_col_list, 3000, 1));
    --DBMS_OUTPUT.PUT_LINE('v_pv_list='     || DBMS_LOB.SUBSTR(v_pv_list, 3000, 1));
    -- BUCKET ���� ���� ���� (END)

    -- BUCKET ���� ���� ���� (END)
    -- ������...���� ���� ������ �������� ��
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
    -- BUCKET ���� ���� ���� (END)
    --=============================================================================================================================

	--=============================================================================================================================
	-- Version ���� ���� ���� (START)
	--=============================================================================================================================

	--=============================================================================================================================
	-- Version ���� ���� ���� (END)
	--=============================================================================================================================

    --=============================================================================================================================
    -- (����) #TempSiteItem / #TempSelectMeasure / #TempFcstNPrice / #MF_SP ��
    --        MSSQL�� #TEMP DROP/CREATE ������ Oracle������ "GTT TRUNCATE"�� ����
    --=============================================================================================================================

    -- GTT ������(�������� ������ ����)
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


    -- 2026.01.13 #TEMP_DM_MST_ITEM_SINGLE_V �� DM_MST_ITEM_SINGLE_V ���� ����
    -- 2026.01.27 �������� ����
    /*
    INSERT INTO GTT_TEMP_DM_MST_ITEM_SINGLE_V
    SELECT *
      FROM DM_MST_ITEM_SINGLE_V
     WHERE DIVISION_ID = '40'
       AND ACTIVE_FLAG = 'Y';
    */

    DBMS_OUTPUT.PUT_LINE('step 1-5: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	--=============================================================================================================================
	-- #TempSiteItem ������ ���� (START)
	--=============================================================================================================================

    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

    -- INSERT /*+ APPEND PARALLEL(P1 8) */ INTO GTT_TEMPSITEITEMALL P1
    INSERT /*+ PARALLEL(P1 8) */ INTO GTT_TEMPSITEITEMALL P1
    -- ���� 01.23
    WITH
     P_SITE AS (

        -- SELECT TOKEN FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID,','))
        SELECT TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL)) AS token
        FROM dual
        CONNECT BY REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL) IS NOT NULL

     )
    ,P_CUST AS (

        --SELECT TOKEN FROM TABLE(STRING_SPLIT(P_CUSTOMER,','))
        SELECT TRIM(REGEXP_SUBSTR(P_CUSTOMER, '[^,]+', 1, LEVEL)) AS token
        FROM dual
        CONNECT BY REGEXP_SUBSTR(P_CUSTOMER, '[^,]+', 1, LEVEL) IS NOT NULL

    )
    ,P_BIZ AS (

        --SELECT TOKEN FROM TABLE(STRING_SPLIT(P_BIZ_TYPE,','))
        SELECT TRIM(REGEXP_SUBSTR(P_BIZ_TYPE, '[^,]+', 1, LEVEL)) AS token
        FROM dual
        CONNECT BY REGEXP_SUBSTR(P_BIZ_TYPE, '[^,]+', 1, LEVEL) IS NOT NULL

    )

    ,P_ITEM AS (

        --SELECT TOKEN FROM TABLE(STRING_SPLIT(P_BIZ_TYPE,','))
        SELECT TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL)) AS token
        FROM dual
        CONNECT BY REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL) IS NOT NULL

    )


    ,F_BASE AS (

        SELECT F.ROWID AS RID, F.OWNER
        FROM SCM_MST_SITE_ITEM F
        WHERE F.DIVISION_ID = p_division_id -- '40' �������� 02/02

        AND F.OWNER IS NOT NULL  -- 01/31
        -- AND ROWNUM <= 1000
    )

    , F_OWNER AS (

        SELECT FB.RID, OT.TOKEN AS OWNER_ID
        FROM F_BASE FB
        CROSS JOIN

            TABLE(STRING_SPLIT(FB.OWNER, ',')) OT

    )
    ,OWNER_AGG AS (

--    SELECT
--        F.ROWID AS RID,
--        LISTAGG(U.USER_NAME_EN, ',')
--            WITHIN GROUP (ORDER BY U.USER_NAME_EN) AS OWNER
--    FROM SCM_MST_SITE_ITEM F
--    JOIN TABLE(STRING_SPLIT(F.OWNER, ',')) O
--        ON 1 = 1
--    JOIN SCM_MST_SSO_USER_INFO U
--        ON U.USER_ID = O.TOKEN
--    GROUP BY F.ROWID

        SELECT FO.RID, LISTAGG(U.USER_NAME_EN,',') WITHIN GROUP (ORDER BY U.USER_NAME_EN) AS OWNER
        FROM F_OWNER FO
        JOIN SCM_MST_SSO_USER_INFO U ON U.USER_ID = FO.OWNER_ID
        GROUP BY FO.RID
    )
    ,
    BASE AS (
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
    WHERE DIVISION_ID = p_division_id -- '40' �������� 02/02
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
            MAX(ITEM_NAME)            AS ITEM_NAME,              -- NULL ����: ������ ����
            --MAX(ITEM_CLASS)           AS ITEM_CLASS,             -- NULL ����: ������ ����
            --MAX(ITEM_CLASS_NAME)      AS ITEM_CLASS_NAME,        -- NULL ����: ������ ����
            MAX(NICK_NAME)            AS NICK_NAME,              -- NULL ����: ������ ����

            CASE MIN(ITEM_TYPE_PRIORITY)
                WHEN 1 THEN 'P'
                WHEN 2 THEN 'H'
                WHEN 3 THEN 'Q'
                ELSE 'R'
            END                      AS ITEM_TYPE,

            --MAX(MATERIAL_CLASS_NAME)  AS MATERIAL_CLASS_NAME,
            --MAX(ITEM_UOM)             AS ITEM_UOM,
            --MAX(SPEC)                 AS SPEC,
            MAX(MDM_PROJECT_NAME)     AS MDM_PROJECT_NAME,
            MAX(MIN_CAPACITY)         AS MIN_CAPACITY,
            MAX(P_FORECAST_INFO_BIZ_TYPE)        AS FORECAST_INFO_BIZ_TYPE,
            MAX(P_FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT,
            --MAX(ACTIVE_FLAG)          AS ACTIVE_FLAG,
            MAX(P_CELL_TYPE)          AS CELL_TYPE,
            --MAX(ENERGE)               AS ENERGE,
            --MAX(CELL_QUANTITY)        AS CELL_QUANTITY,
            --MAX(SCP_EXTRA_SPEC)       AS SCP_EXTRA_SPEC
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

--        (
--          SELECT LISTAGG(ZA.USER_NAME_EN, ',') WITHIN GROUP (ORDER BY ZA.USER_NAME_EN)
--          FROM SCM_MST_SSO_USER_INFO ZA
--          JOIN
--            --  TABLE(STRING_SPLIT(F.OWNER, ',')) ZB
--                (SELECT TRIM(REGEXP_SUBSTR(F.OWNER, '[^,]+', 1, LEVEL)) AS token
--                FROM dual
--                CONNECT BY REGEXP_SUBSTR(F.OWNER, '[^,]+', 1, LEVEL) IS NOT NULL
--        ) ZB
--            ON ZA.USER_ID = ZB.TOKEN
--        ) AS OWNER,


        OA.OWNER,   -- ���� 01.23

        J.USER_NAME_EN AS PROJECT_OWNER,
        J.USER_ID,
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
    FROM

    SCM_MST_SITE_ITEM F

        LEFT JOIN OWNER_AGG OA     -- ���� 26.01.23
        ON OA.RID = F.ROWID    -- ���� 26.01.23

    -- JOIN GTT_TEMP_DM_MST_ITEM_SINGLE_V T2
    JOIN GTT_TEMP_DM_MST_ITEM_SINGLE_V_1 T2  -- ���� 26.01.27
      ON F.DIVISION_ID = T2.DIVISION_ID
     AND F.ITEM_ID     = T2.ITEM_ID

    -- LEFT JOIN GTT_TEMP_DM_MST_ITEM_SINGLE_V T4
    LEFT JOIN GTT_TEMP_DM_MST_ITEM_SINGLE_V_1 T4  -- ���� 01.27
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
          JOIN SCM_MST_SSO_DEPT_INFO C ON B.DEPT_ID = C.DEPT_ID
    ) TEAM

      -- ON TEAM.USER_ID IN (SELECT TOKEN FROM TABLE(STRING_SPLIT(F.OWNER, ',')) FETCH FIRST 1 ROWS ONLY)
      ON TEAM.USER_ID IN (SELECT TOKEN
                            FROM
                                -- TABLE(STRING_SPLIT(F.OWNER, ','))
                                (
                                SELECT TRIM(REGEXP_SUBSTR(F.OWNER, '[^,]+', 1, LEVEL)) AS token
                                FROM dual
                                CONNECT BY REGEXP_SUBSTR(F.OWNER, '[^,]+', 1, LEVEL) IS NOT NULL
                                )
                            FETCH FIRST 1 ROWS ONLY
                            )

    LEFT JOIN SCM_MST_SSO_USER_INFO J
      ON SUBSTR(F.OWNER, 1,
                CASE WHEN INSTR(F.OWNER, ',') = 0 THEN LENGTH(F.OWNER) ELSE INSTR(F.OWNER, ',')-1 END
               ) = J.USER_ID
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
                 AND SEGMENT1 = p_division_id -- '40' �������� 02/02
          )
         WHERE MODEL_RANK = 1
    ) LOOKA
      ON LOOKA.MODEL = F.ITEM_ID
    WHERE F.DIVISION_ID = p_division_id -- '40' �������� 02/02

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
    DBMS_OUTPUT.PUT_LINE('GTT_TEMPSITEITEMALL:' || v_cnt ||'-��');
    DBMS_OUTPUT.PUT_LINE('p_scm_site_id:'||p_scm_site_id||', p_customer:'||p_customer||', p_biz_type:'||p_biz_type||', P_ITME_ID:'||P_ITEM_ID);
    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 1-6: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

	-------------------------------------------------------------------------------------------------------------------------------
	-- #TempSiteItem ������ (START)
	-------------------------------------------------------------------------------------------------------------------------------
--     #TempSiteItem ������ (����)
--    INSERT /*+ APPEND PARALLEL(G1 8) */ INTO GTT_TEMPSITEITEM G1
    INSERT /*+ PARALLEL(G1 8) */ INTO GTT_TEMPSITEITEM G1
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
    DBMS_OUTPUT.PUT_LINE('GTT_TEMPSITEITEM:' || v_cnt ||'-��');

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 1-7: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

--  =============================================================================================================================
--     ���� ���� ����
--  =============================================================================================================================
    v_from_yyyymmdd  := '';
    v_to_yyyymmdd    := '';
    v_from_result    := '';
    v_to_result      := '';
    v_user_time_zone := '';

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

	/* ���� �� �� �� ���� ���� ���� ���� */
	/* ���� �� �� �� ���� ���� ���� ���� */
	/* ���� �� �� �� ���� ���� ���� ���� */

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

    -- @V_FROM_YYYYMMDD : (USER ������ ������) ���� ������
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

    -- FROM ���� : FROM ���� ���� ����������
    SELECT C.BASIS_START_DATE
      INTO v_from_result
      FROM SCM_SYS_CALENDAR_M C
     WHERE C.BASIS_YYYYMMDD = p_from_yyyymmdd;

    -- TO ���� : TO ���� ���� ������ ������
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
                         ' ���� ���� �� v_from_yyyymmdd:'||v_from_yyyymmdd||' v_to_yyyymmdd:'||v_to_yyyymmdd||
                         ' v_from_result:'||v_from_result||' v_to_result:'||v_to_result);



	/* ���� �� �� �� ���� ���� ���� ���� */
	/* ���� �� �� �� ���� ���� ���� ���� */
	/* ���� �� �� �� ���� ���� ���� ���� */

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

    --=============================================================================================================================
    -- Temp ������ ������ (TRUNCATE)
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
--    -- #TempSelectMeasure ������
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

     COMMIT;
    -- DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A008--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' #TempSelectMeasure ������ ����');

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 1-8: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

--    ------------------------------------------------------------------------------------------------
--    --[PJ2025-50188] ... ���� ���� ���� ���� (LOC/KRW/FCST_GAP)
--    ------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------
	--[PJ2025-50188]���� �������� ������ ���� ������ : ���� Unit Price ���� ���� (MKT Fcst AMT/QTY)
	--�������� LOC,KRW�� �������� ���� ���� ���� RTF_SYS_RP, MKT_AMT_LOC, MKT_AMT_KRW �� ������ ���� ���� START
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

         COMMIT;
    END IF;

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 1-9: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));
	------------------------------------------------------------------------------------------------
	--[PJ2025-50188]���� �������� ������ ���� ������ : ���� Unit Price ���� ���� (MKT Fcst AMT/QTY)
	--�������� LOC,KRW�� �������� ���� ���� ���� RTF_SYS_RP, MKT_AMT_LOC, MKT_AMT_KRW �� ������ ���� ���� END
	------------------------------------------------------------------------------------------------

	--[PJ2025-50188]���� �������� ������ ���� ������ : �������� START----------------------------------------------
	--LOC�� �������� CURRENCY�� ���� �������� ���� ������ ������ ���� ���� INSERT
	--DM_PLN_CFM_SELLING_PRICE �������� JOIN ���� �������� ���� ������ ���� ����
    -- LOC�� ������ INSERT
    INSERT INTO GTT_TEMPSELECTMEASURE
    (PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, RESULT_MEASURE, SORT_ORDER_NO)
    SELECT A.PROGRAM_ID, A.SHEET_NAME, 'DM_ADMIN',
           A.COLUMN_NAME, A.COLUMN_NAME, A.COLUMN_NAME, A.SORT_ORDER_NO
      FROM SCM_MST_SHEET_MEASURE A
     WHERE A.PROGRAM_ID = va_program_id
       AND A.SHEET_NAME  = va_sheet_name
       AND A.COLUMN_NAME = 'LOC'
       AND NOT EXISTS (SELECT 1 FROM GTT_TEMPSELECTMEASURE X WHERE X.MEASURE = A.COLUMN_NAME);
    COMMIT;
	--[PJ2025-50188]���� �������� ������ ���� ������ : �������� END----------------------------------------------


    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 2-1: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

	-- #TempSelectMeasure ������ ����

	-- #T_LAST_DATA_SETUP_FCST ������ ����
    --=============================================================================================================================
    -- #T_LAST_DATA_SETUP_* (CURRENT)
    --=============================================================================================================================
    IF UPPER(p_version_type) LIKE '%CURRENT%' THEN
        -- DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A009--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' #T_LAST_DATA_SETUP_FCST ������ ����');

			--[PJ2025-50188]���� �������� ������ ���� ������ : �������� START ---------------------------------------------------------------------
			--���� ���� ���� ���� �� ���� ����
			--1.LAST_UPDATE_DATE ���� ������ ��, CASE WHEN �� �������������� �������� ���� �������� ������ ���� ���� ����
			--2.���� ���� �������� ������ ������ID�� ������ MAX������ID�� �������� ������

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

        COMMIT;

       --  DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A009--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' #T_LAST_DATA_SETUP_FCST ������ ����');
       -- DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A010--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' #T_LAST_DATA_SETUP_PRICE ������ ����');

            -- #T_LAST_DATA_SETUP_FCST ������ ����
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

        COMMIT;

        SELECT COUNT(*) INTO V_CNT FROM GTT_T_LAST_DATA_SETUP_PRICE;
        DBMS_OUTPUT.PUT_LINE('GTT_T_LAST_DATA_SETUP_PRICE-2:' || V_CNT);

        -- DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A011--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' #T_LAST_DATA_SETUP_PRICE ������ ����');
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
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A016--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' #T_WS_FCST ������ ����');

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
--          || '#TempFcstNPrice ������ ���� - VERSION - CURRENT'
--      );



      --------------------------------------------------------------------------------------------------------------------------------
      -- #TempFcstNPrice ������ (INSERT)
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



      -- INSERT /*+ APPEND */ INTO GTT_TEMPFCSTNPRICE T1
      INSERT INTO GTT_TEMPFCSTNPRICE T1
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
      /* DM_PLN_CFM_MKT_DEMAND_PLAN ������ ���� MEASURE */
      -- �������� MEASURE ����
      -- MKT_FCST [R+P]�� P���� (������ ����)
      -- RTF [R+P] �� P ���� (������ ����)


      WITH P_SITE AS (SELECT TOKEN
                        -- FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID,','))
                        FROM (
                            SELECT TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL)) AS token
                            FROM dual
                            CONNECT BY REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                            )
                        )  -- 01.31
      -- 179,049��
      SELECT
             A.DIVISION_ID
           , A.PROJECT_CODE
           , A.END_CUSTOMER
           , A.SCM_SITE_ID
           , A.ITEM_ID
           , A.DOM_EXP
           , A.FCST_TYPE
           , A.INCOTERMS
           , CASE WHEN A.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
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
           --[PJ2025-50188]���� �������� ������ ���� ������ : 'MKT_AMT_LOC', 'MKT_AMT_KRW' ���� ������3���� ������ ���� NOTATION ���� (INTEGER -> POINT3)
           , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM DM_PLN_CFM_MKT_DEMAND_PLAN A
        INNER JOIN GTT_TEMPSELECTMEASURE B
          ON A.MEASURE =
             (CASE
                WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY') THEN 'RTF'
                WHEN B.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL','RTF_ENERGY') THEN 'RTF_SYS_RP'
                ELSE B.MEASURE
              END)
        /* OUTER APPLY TOP(1) -> LEFT JOIN (ROW_NUMBER=1) */
        LEFT JOIN (
            SELECT *
              FROM (
                    SELECT LD.DIVISION_ID, LD.PROJECT_CODE, LD.SCM_SITE_ID, LD.ITEM_ID,
                           LD.DOM_EXP, LD.FCST_TYPE, LD.INCOTERMS, LD.MEASURE,
                           LD.CREATE_DATE, LD.LAST_UPDATED_BY,
                           ROW_NUMBER() OVER (
                             PARTITION BY LD.DIVISION_ID, LD.PROJECT_CODE, LD.SCM_SITE_ID, LD.ITEM_ID,
                                          LD.DOM_EXP, LD.FCST_TYPE, LD.INCOTERMS, LD.MEASURE
                             ORDER BY LD.CREATE_DATE DESC
                           ) AS RN
                      FROM GTT_T_LAST_DATA_SETUP_FCST LD
                   )
             WHERE RN = 1
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
         AND A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
         --[PJ2025-50188]SCM_FCST�� 0�� ������ ���� ���������� ���� ���� START
         AND (
               (A.MEASURE <> 'SCM_FCST' AND A.QTY <> 0)
               OR
               (A.MEASURE = 'SCM_FCST')
             )
         --[PJ2025-50188]SCM_FCST�� 0�� ������ ���� ���������� ���� ���� END

      UNION ALL

      SELECT
             A.DIVISION_ID
           , A.PROJECT_CODE
           , A.END_CUSTOMER
           , A.SCM_SITE_ID
           , A.ITEM_ID
           , A.DOM_EXP
           , A.FCST_TYPE
           , A.INCOTERMS
           , 'MKT_FCST_PP' AS MEASURE
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
           , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM DM_PLN_CFM_MKT_DEMAND_PLAN A
        INNER JOIN GTT_TEMPSELECTMEASURE B
          ON A.MEASURE = 'MKT_FCST'
         AND B.MEASURE = 'MKT_FCST_PP'
        LEFT JOIN (
            SELECT *
              FROM (
                    SELECT LD.DIVISION_ID, LD.PROJECT_CODE, LD.SCM_SITE_ID, LD.ITEM_ID,
                           LD.DOM_EXP, LD.FCST_TYPE, LD.INCOTERMS, LD.MEASURE,
                           LD.CREATE_DATE, LD.LAST_UPDATED_BY,
                           ROW_NUMBER() OVER (
                             PARTITION BY LD.DIVISION_ID, LD.PROJECT_CODE, LD.SCM_SITE_ID, LD.ITEM_ID,
                                          LD.DOM_EXP, LD.FCST_TYPE, LD.INCOTERMS, LD.MEASURE
                             ORDER BY LD.CREATE_DATE DESC
                           ) AS RN
                      FROM GTT_T_LAST_DATA_SETUP_FCST LD
                   )
             WHERE RN = 1
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
         AND A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
         AND A.QTY <> 0

       UNION ALL

      SELECT

            /*+ MONITOR LEADING(A C LD) USE_HASH(C)  USE_HASH(LD)  */

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
        FROM DM_PLN_CFM_SELLING_PRICE A    -- �������������������� 981,064 ��
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
                           LD.CREATE_DATE, LD.LAST_UPDATED_BY,
                           ROW_NUMBER() OVER (
                             PARTITION BY LD.DIVISION_ID,
                                            LD.PROJECT_CODE,
                                            LD.SCM_SITE_ID,
                                            LD.ITEM_ID,
                                          LD.DOM_EXP,
                                          LD.FCST_TYPE,
                                          LD.INCOTERMS,
                                          LD.MEASURE
                             ORDER BY LD.CREATE_DATE DESC
                           ) AS RN
                      FROM GTT_T_LAST_DATA_SETUP_PRICE LD  -- 0
                   )
             WHERE RN = 1
        ) LD
          ON LD.DIVISION_ID   = A.DIVISION_ID
         AND LD.PROJECT_CODE  = A.PROJECT_CODE
         AND LD.SCM_SITE_ID   = A.SCM_SITE_ID
         AND LD.ITEM_ID       = A.ITEM_ID
         AND LD.DOM_EXP       = A.DOM_EXP
         AND LD.FCST_TYPE     = A.FCST_TYPE
         AND LD.INCOTERMS     = A.INCOTERMS
         AND LD.MEASURE       = A.MEASURE
        INNER JOIN GTT_TEMPSITEITEM C       -- 14758��
          ON A.DIVISION_ID   = C.DIVISION_ID
         AND A.PROJECT_CODE  = C.PROJECT_CODE
         AND A.SCM_SITE_ID   = C.SCM_SITE_ID
         AND A.ITEM_ID       = C.ITEM_ID
         AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN GTT_T_WS_FCST D        -- 14��
          ON A.FCST_TYPE = D.FCST_TYPE
       WHERE 1=1
         AND A.DIVISION_ID = P_DIVISION_ID
         AND (CASE WHEN P_SCM_SITE_ID = 'ALL' THEN P_SCM_SITE_ID
                ELSE A.SCM_SITE_ID END) IN (SELECT TOKEN FROM P_SITE)
             -- 01.31 (SELECT TOKEN FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ',')))
         AND A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD

         ;


    COMMIT;

     select count(*) into v_cnt from GTT_TEMPFCSTNPRICE;
     DBMS_OUTPUT.PUT_LINE('GTT_TEMPFCSTNPRICE: '||v_cnt||'-��');

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
--                    FROM GTT_TEMPFCSTNPRICE SP -- [PJ2025-50188]���� �������� ������ ���� ������ : ��������
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

        /* 01.28 ����
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

        MERGE /*+ PARALLEL(A 8) */ INTO GTT_TEMPFCSTNPRICE A
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
        --DBMS_OUTPUT.PUT_LINE('2.GTT_TEMPFCSTNPRICE: '||v_cnt||'-��');

     v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 2-6: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

      --------------------------------------------------------------------------------------------------------------------------------
      -- #TempFcstNPrice �� INSERT �� �������� �������� ���� ���� ����
      -- LOC = MKT_AMT_LOC/RTF_SYS_RP
      -- KRW = MKT_AMT_KRW/RTF_SYS_RP
      --------------------------------------------------------------------------------------------------------------------------------
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

      -- INSERT /*+ APPEND PARALLEL(T1 8) */ INTO GTT_TEMPFCSTNPRICE T1
      INSERT /*+ PARALLEL(T1 8) */ INTO GTT_TEMPFCSTNPRICE T1
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
      --���� ���� ���� �� FCST GAP ���� ... START
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
           --[PJ2025-50188]... NOTATION ���� (INTEGER -> POINT3)
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
    --DBMS_OUTPUT.PUT_LINE('3.GTT_TEMPFCSTNPRICE: '||v_cnt||'-��');

      DBMS_OUTPUT.PUT_LINE('step 2-6: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
      --------------------------------------------------------------------------------------------------------------------------------
      -- ���� ����
      --------------------------------------------------------------------------------------------------------------------------------
--      DBMS_OUTPUT.PUT_LINE(
--          VA_PROGRAM_ID || ' : A018--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
--          || '#TempFcstNPrice ������ ���� - VERSION - CURRENT'
--      );

    END IF;


      v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 2-7: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));

    -----------------------------------------------------------------------------------------------
    -- Unit Price ���� �� ������ MEASURE ���� (USER_ID=DM_ADMIN)
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
	--[PJ2025-50188]���� �������� ������ ���� ������ : ���� Unit Price ���� ���� END
	-----------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

	/* ���������� ���������� ���� �� �������� ���� �� ��������. */

	/* ������������ ���� �� ���� ������ ������ ���� */
	/* C_TITLE : ������ bucket�� ���� MONTH ���� WEEK�� �������� ������ ������ ������ ���� */

	/* C_TITLE ���� ���� */
	/* C_TITLE ���� ���� */
	/* C_TITLE ���� ���� */


       --=============================================================================================================================
    -- C_TITLE ����: v_column / v_groupby / v_orderby ������
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


    -- [E20240812-000094] NOTATION ����
    --[E20240812-000094]_������������ �������������� ���������� ����, ���� ������ �������������� ���� START
    v_column := v_column || ', NOTATION';
    --[E20240812-000094]_������������ �������������� ���������� ����, ���� ������ �������������� ���� END
    v_groupby := v_groupby || ', EDIT_FLAG, SORT_ORDER_NO';
    v_orderby := REPLACE(v_orderby, 'MEASURE_GROUP', ' TO_NUMBER(SORT_ORDER_NO)');
    v_orderby := REPLACE(v_orderby, ', MEASURE', '');

    /* C_TITLE ���� ���� */
	/* C_TITLE ���� ���� */
	/* C_TITLE ���� ���� */

    --=============================================================================================================================
    -- ���������� LOOKUP���� (BEGIN)
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
    -- ���������� LOOKUP���� (END)
    --=============================================================================================================================
	-------------------------------------------------------------------------------------------------------------------------
	--�������� ����: ���������� �������� Timeline �������� MKT FCST / SCM FCST�� �������� �������� ����
	--MKT FCST ���� ������ ���� ������ ������ �� ������ ���� ���� ����
	--[Timeline ������ ���� ������ MKT FCST, SCM FCST ���� ���� ����]
	--���� �� 24�� DM cutoff �� �������� �������� SCM_FCST�� ���� ���������� ���� ��������,
	--���� �� 15�� DM Cutoff �� �� 15�� 30�� ~ 17�� 30�� ���� SCM FCST ���������� ��

	--���� ������ ���� ������ ������ ������������, ��������. ���� ������ ���� ������ ������ ���������� �������� ������
	--������: GET_ADMIN_GROUP_MEASURE

       -------------------------------------------------------------------------------------------------------------------------
    -- [E20250729-000433] ... GET_ADMIN_GROUP_MEASURE ����
    -------------------------------------------------------------------------------------------------------------------------
	--1). GET_ADMIN_GROUP_MEASURE �������� �������� TEMP�� ������
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
--     CROSS JOIN TABLE(STRING_SPLIT(B.LIMIT_MEASURE, ',')) LM
        CROSS JOIN LATERAL(
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

    DBMS_OUTPUT.PUT_LINE('step 3-2: p_user_group='||p_user_group||', va_program_id='||va_program_id||', p_division_id='||p_division_id||' P_SCN_SITE_ID:'||P_SCM_SITE_ID||' V_TO_RESULT:'||V_TO_RESULT||' V_TO_YYYYMMDD:'||V_TO_YYYYMMDD||', va_program_id:'||va_program_id||', va_sheet_name:'||va_sheet_name);

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 3-3: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));


	--2). ���� �������� MEASURE�� ������ ���� ������ ���� ������ ������ ��������, ���� ���� �������� ������ ���������� ������ ���� ������ EDIT_FLAG�� ��������
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



    --3). #TEMP_INTO_GROUP_MEASURE �������� ������ ������ �� LIMIT_MEASURE�� �������� ���� ���� ������ FLAG�� N���� ����������
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
	--[E20250729-000433]_[����/����SCM PI��] ������ SCM FCST ���� �� MKT FCST ���� ���������� ������ ���� END
	-------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

     v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 3-5: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));


    --#CAL_MONTH_END_DATE ������ ����
    INSERT INTO GTT_CAL_MONTH_END_DATE (MONTH_END_DATE)
    SELECT MAX(BASIS_YYYYMMDD)
      FROM SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
     GROUP BY BASIS_YYYYMM;
    COMMIT;

    --DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A027--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' #CAL_MONTH_END_DATE ������ ����');

     v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 3-6: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));



    --#CAL_WEEK_END_DATE ������ ����
    INSERT INTO GTT_CAL_WEEK_END_DATE (WEEK_END_DATE)
    SELECT MAX(BASIS_YYYYMMDD)
      FROM SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
     GROUP BY ISO_YYYYWW || PARTIAL_WEEK_NAME;

    COMMIT;

    --DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A028--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' #CAL_WEEK_END_DATE ������ ����');

     v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 3-7: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));


    --SELECT COUNT(*) INTO V_CNT FROM GTT_MF_SP;
    --DBMS_OUTPUT.PUT_LINE('GTT_MF_SP:'||V_CNT||'-��');
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

    /* ������������ ������ MF_SP ���������� */
    -- INSERT /*+ APPEND PARALLEL(T 8) */ INTO GTT_MF_SP T
    INSERT /*+ PARALLEL(T 8) */ INTO GTT_MF_SP T

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
        /* ���� ���� 2026.01.28
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
                FROM (
                    SELECT TRIM(REGEXP_SUBSTR(p_team_id, '[^,]+', 1, LEVEL)) AS token
                    FROM dual
                    CONNECT BY REGEXP_SUBSTR(p_team_id, '[^,]+', 1, LEVEL) IS NOT NULL
                    )
                -- FROM TABLE(STRING_SPLIT(p_team_id, ','))
                );

    COMMIT;

    SELECT COUNT(*) INTO V_CNT FROM GTT_MF_SP;
    DBMS_OUTPUT.PUT_LINE('GTT_MF_SP:'||V_CNT||'-��');

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

    --    -- p_qty_yn = 'Y' ����
    --2025.03.10 Philsu Park: MKT Fcst ���� ������ ������ �������� ���� ������.
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

            -- INSERT /*+ APPEND */ INTO gtt_mf_sp_keep
            INSERT INTO gtt_mf_sp_keep

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

            -- INSERT /*+ APPEND */ INTO GTT_MF_SP
            INSERT INTO GTT_MF_SP
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
        DBMS_OUTPUT.PUT_LINE('GTT_MF_SP:'||V_CNT||'-��');

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



    -- �������� delete from GTT_MF_SP_temp2;
    -- �������� insert into GTT_MF_SP_temp2 select * from gtt_mf_sp;

    -- =========================================================================================================================
    -- ���� PIVOT ���� (MSSQL: SP_EXECUTESQL @v_sql_text)
    -- Oracle: EXECUTE IMMEDIATE�� ���� SQL�� ������ ���� RETURN_RESULT
    -- =========================================================================================================================

    -- v_column / v_orderby / v_pv_col_list ������ MSSQL C_TITLE ���� ������ ������ Oracle FOR LOOP�� ������ ������.
    -- (�������� ������ �������������� ���� ���� �������� ������ ������ ����)

    -- *****
    --v_column := 'DIVISION_ID';

    /*
    DBMS_OUTPUT.PUT_LINE('----------------------------');
    DBMS_OUTPUT.PUT_LINE('v_pv_list:'||v_pv_list);
    DBMS_OUTPUT.PUT_LINE('v_column:'||v_column);
    DBMS_OUTPUT.PUT_LINE('----------------------------');
    */
    /* 26.01.28 V_ORDERBY���� CURRENCY ���� .. MEASURE ���� ������ ������.. CURRENCY NULL������ ������ ���� ����.
    MKT_FCST
    RTF_SYS_RP
    SCM_FCST
    KRW
    USD
    LOC
    */

    SELECT REPLACE(V_ORDERBY,'CURRENCY,','') INTO V_ORDERBY FROM DUAL;

    /* --------------- */

    /* ���������� �������� �������� */
    /* SORT_KEY ���� 26.01.22*/
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

    -- DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A033--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ������ DataTable ����');
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
    -- (2) ������ DataTable: M+3 ������ ���� ���� (o_rs2)
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
    -- (3) ������ DataTable: ���� ���� / ���� ���� (o_rs3)
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
    -- (4) ������ DataTable: EDIT_FLAG ���� (o_rs4)
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
    -- (5) �������� DataTable: ���� ���� ���� ������ (o_rs5)
    --  - MSSQL ���� ���� ����:
    --    * FIRST_WEEK_FLAG : BASIS_START_DATE(���� �� ������)�� ���� '01'���� Y
    --    * END_MONTH_FLAG  : BASIS_START_DATE + 7���� ��(YYYYMM)�� BASIS_START_DATE�� ��(YYYYMM)�� ������ Y
    --    * MONTH_DAY_CNT   : ���� ����(analytic)
    --    * WEEK_DAY_CNT    : ������ ����(analytic) (ISO_YYYYWW + PARTIAL_WEEK_NAME ����)
    --=============================================================================================================================
    OPEN o_rc5 FOR
        SELECT
            BASIS_YYYYMMDD,                                        -- UI���� BASIS_YYYYMMDD �� ���� ���� ����.
            BASIS_YYYYMM,                                          -- UI���� BASIS_YYYYMM �� ���� ���� ����.
            CASE
                WHEN SUBSTR(BASIS_START_DATE, 7, 2) = '01' THEN 'Y'
                ELSE 'N'
            END AS FIRST_WEEK_FLAG,                                -- ���� 1���� ������ ���� FLAG
            CASE
                WHEN SUBSTR(TO_CHAR(TO_DATE(BASIS_START_DATE, 'YYYYMMDD') + 7, 'YYYYMMDD'), 1, 6) =
                     SUBSTR(BASIS_START_DATE, 1, 6)
                THEN 'N'
                ELSE 'Y'
            END AS END_MONTH_FLAG,                                 -- ���� ������ ���� FLAG
            COUNT(*) OVER (PARTITION BY BASIS_YYYYMM) AS MONTH_DAY_CNT,                     -- ���� ���� ������
            COUNT(*) OVER (PARTITION BY ISO_YYYYWW || PARTIAL_WEEK_NAME) AS WEEK_DAY_CNT,   -- ���� ���� ������
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

    -- DBMS_OUTPUT.PUT_LINE(va_program_id || ' : A034--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ������ DataTable ����');
    COMMIT;
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

    v_elapsed_sec := EXTRACT(DAY    FROM (SYSTIMESTAMP - v_start_ts)) * 86400
      + EXTRACT(HOUR   FROM (SYSTIMESTAMP - v_start_ts)) * 3600
      + EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60
      + EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts));
    v_start_ts := systimestamp;

    DBMS_OUTPUT.PUT_LINE('step 6-6: '||TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')||' : '||TO_CHAR(v_elapsed_sec));


END;