CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0082_GET_MAIN_DATA_TEST" (
    p_division_id     IN VARCHAR2,
    p_team_id         IN VARCHAR2,
    p_customer        IN VARCHAR2,
    p_biz_type        IN VARCHAR2,
    p_from_yyyymmdd   IN VARCHAR2,
    p_to_yyyymmdd     IN VARCHAR2,
    p_scm_site_id     IN VARCHAR2,
    p_item_id         IN VARCHAR2,
    p_version_type    IN VARCHAR2,
    p_qty_yn          IN VARCHAR2,
    p_created_by      IN VARCHAR2,
    p_user_group      IN VARCHAR2,

    o_rs1             OUT SYS_REFCURSOR,
    o_rs2             OUT SYS_REFCURSOR,
    o_rs3             OUT SYS_REFCURSOR,
    o_rs4             OUT SYS_REFCURSOR,
    o_rs5             OUT SYS_REFCURSOR
)
IS
  v_program_name   VARCHAR2(150) := 'DMF0082_GET_MAIN_DATA';
  v_log_type       VARCHAR2(30);
  n_log_count      PLS_INTEGER := 0;
  v_log_message    VARCHAR2(1000);
  v_description    VARCHAR2(500);
  d_event_date     TIMESTAMP;

  v_user_col_cnt   PLS_INTEGER := 0;
  v_user_mea_cnt   PLS_INTEGER := 0;

  va_program_id    VARCHAR2(50) := 'DMF0082';
  va_sheet_name    VARCHAR2(50) := 'FcstNPrice';

  -- BUCKET
  v_exp_yyyymmdd   VARCHAR2(8);
  v_pv_list        CLOB;
  v_pv_col_list    CLOB;

  -- 날짜변수
  v_from_yyyymmdd   VARCHAR2(8);
  v_to_yyyymmdd     VARCHAR2(8);
  v_from_result     VARCHAR2(8);
  v_to_result       VARCHAR2(8);
  v_user_time_zone  VARCHAR2(50);

  -- 동적쿼리
  v_column   CLOB;
  v_groupby  CLOB;
  v_orderby  CLOB;
  v_sql_text CLOB;

  v_group_id VARCHAR2(50) := '';

  -- 보조
  v_today_dow VARCHAR2(3);
  v_now_hhmi  VARCHAR2(4);
BEGIN

  DBMS_OUTPUT.PUT_LINE(v_program_name||' : START '||TO_CHAR(SYSTIMESTAMP,'YYYY-MM-DD HH24:MI:SS.FF3'));

  -- 시작 LOG
  v_log_type := 'START';
  v_log_message := '########## Start of procedure ##########';
  v_description := '';
  d_event_date := SYSTIMESTAMP;

  PR_DM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_created_by);

  ---------------------------------------------------------------------------
  -- 1) 사용자 컬럼/메저 초기 세팅
  ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE(v_program_name||' : 1----');

  SELECT COUNT(*)
    INTO v_user_col_cnt
    FROM scm_mst_titleset_user u
   WHERE u.program_id = va_program_id
     AND u.sheet_name = va_sheet_name
     AND u.user_inquiry_column_type_code = 'C'
     AND u.user_id = p_created_by;

  IF v_user_col_cnt = 0 THEN
    INSERT INTO scm_mst_titleset_user
      ( user_id, program_id, sheet_name, user_inquiry_column_type_code, column_name,
        sort_order_no, sub_total_flag, data_sort_method_code, created_by, creation_date,
        last_updated_by, last_update_date )
    SELECT p_created_by, c.program_id, c.sheet_name, 'C', c.column_name,
           c.sort_order_no, 'N', '', p_created_by, SYSTIMESTAMP,
           p_created_by, SYSTIMESTAMP
      FROM scm_mst_sheet_columns c
     WHERE c.program_id = va_program_id
       AND c.sheet_name = va_sheet_name
       AND c.default_flag = 'Y'
       AND c.valid_yn = 'Y';
  END IF;

    DBMS_OUTPUT.PUT_LINE(v_program_name||' : 2----');

  SELECT COUNT(*)
    INTO v_user_mea_cnt
    FROM scm_mst_titleset_user u
   WHERE u.program_id = va_program_id
     AND u.sheet_name = va_sheet_name
     AND u.user_inquiry_column_type_code = 'M'
     AND u.user_id = p_created_by;

  IF v_user_mea_cnt = 0 THEN
    INSERT INTO scm_mst_titleset_user
      ( user_id, program_id, sheet_name, user_inquiry_column_type_code, column_name,
        sort_order_no, sub_total_flag, data_sort_method_code, created_by, creation_date,
        last_updated_by, last_update_date )
    SELECT p_created_by, c.program_id, c.sheet_name, 'M', c.column_name,
           c.sort_order_no, 'N', '', p_created_by, SYSTIMESTAMP,
           p_created_by, SYSTIMESTAMP
      FROM scm_mst_sheet_measure c
     WHERE c.program_id = va_program_id
       AND c.sheet_name = va_sheet_name
       AND c.default_flag = 'Y'
       AND c.valid_yn = 'Y';
  END IF;

  ---------------------------------------------------------------------------
  -- 2) BUCKET 리스트 생성
  ---------------------------------------------------------------------------
      DBMS_OUTPUT.PUT_LINE(v_program_name||' : 3----');

  v_exp_yyyymmdd := TO_CHAR(TO_DATE(p_from_yyyymmdd,'YYYYMMDD') + 7*50, 'YYYYMMDD');
 DBMS_OUTPUT.PUT_LINE(v_program_name||' : 3----1 v_exp_yyyymmdd='||v_exp_yyyymmdd);
-- debug용 강제 설정
    v_exp_yyyymmdd := '20260131';

  WITH bucket_rows AS (
      SELECT 'D_'||a.basis_yyyymmdd AS pv_name,
             'D_'||a.basis_yyyymmdd AS col_name,
             a.basis_yyyymmdd||'_31' AS sort_key
        FROM scm_sys_calendar_m a
       WHERE a.basis_yyyymmdd >= p_from_yyyymmdd
         AND a.basis_yyyymmdd <= v_exp_yyyymmdd
--      UNION ALL
--      SELECT 'W_'||a.basis_yyyymm||a.iso_week AS pv_name,
--             'W_'||a.basis_yyyymm||a.iso_week AS col_name,
--             a.basis_start_date||'_21' AS sort_key
--        FROM scm_sys_calendar_m a
--       WHERE a.basis_yyyymmdd >= p_from_yyyymmdd
--         AND a.basis_yyyymmdd <= p_to_yyyymmdd
--       GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date
--      UNION ALL
--      SELECT 'M_'||a.basis_yyyymm AS pv_name,
--             'M_'||a.basis_yyyymm AS col_name,
--             MIN(a.basis_start_date)||'_01' AS sort_key
--        FROM scm_sys_calendar_m a
--       WHERE a.basis_yyyymmdd >= p_from_yyyymmdd
--         AND a.basis_yyyymmdd <= p_to_yyyymmdd
--       GROUP BY a.basis_yyyymm
  )
  SELECT LISTAGG(''''||pv_name||'''', ',') WITHIN GROUP (ORDER BY sort_key),
         LISTAGG('"'||col_name||'"', ',')  WITHIN GROUP (ORDER BY sort_key)
    INTO v_pv_list, v_pv_col_list
    FROM bucket_rows;

  ---------------------------------------------------------------------------
  -- 3) 날짜 변수 세팅
  ---------------------------------------------------------------------------
      DBMS_OUTPUT.PUT_LINE(v_program_name||' : 4----');

  SELECT u.timezone
    INTO v_user_time_zone
    FROM tb_fx_user u
   WHERE u.userid = p_created_by;

  v_today_dow := TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH'); -- MON/TUE...
  v_now_hhmi  := TO_CHAR(SYSDATE, 'HH24MI');

  WITH t AS (
    SELECT iso_yyyyww
      FROM scm_sys_calendar_m
     WHERE basis_yyyymmdd = TO_CHAR(FN_MULTY_TIME(v_user_time_zone),'YYYYMMDD')
  )
  SELECT MIN(c.basis_yyyymmdd)
    INTO v_from_yyyymmdd
    FROM scm_sys_calendar_m c
    JOIN t ON c.iso_yyyyww = t.iso_yyyyww;

  SELECT c.basis_start_date INTO v_from_result
    FROM scm_sys_calendar_m c
   WHERE c.basis_yyyymmdd = p_from_yyyymmdd;

  SELECT c.basis_start_date INTO v_to_result
    FROM scm_sys_calendar_m c
   WHERE c.basis_yyyymmdd = p_to_yyyymmdd;

    DBMS_OUTPUT.PUT_LINE(v_program_name||' : 5----');

  v_to_yyyymmdd := NULL;

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

    DBMS_OUTPUT.PUT_LINE(v_program_name||' : 6----');

  DBMS_OUTPUT.PUT_LINE('DATE VARS: FROM_PLAN='||v_from_yyyymmdd||' TO_PLAN='||v_to_yyyymmdd||
                       ' FROM_RSLT='||v_from_result||' TO_RSLT='||v_to_result);

  ---------------------------------------------------------------------------
  -- 4) 권한 그룹(ADMIN) 판단
  ---------------------------------------------------------------------------
  SELECT CASE
           WHEN EXISTS (
             SELECT 1
               FROM scm_adm_lookup_master_detail
              WHERE lookup_type='GET_ADMIN_GROUP'
                AND valid_yn='Y'
                AND segment1 = p_user_group
                AND segment2 = 'ALL'
           ) THEN 'ADMIN'
           ELSE ''
         END
    INTO v_group_id
    FROM dual;

    DBMS_OUTPUT.PUT_LINE(v_program_name||' : 7----');

  ---------------------------------------------------------------------------
  -- 5) C_TITLE (동적 컬럼 리스트 생성)
  ---------------------------------------------------------------------------
  WITH title_rows AS (
      SELECT u.program_id,
             u.sheet_name,
             u.column_name,
             CASE
               WHEN u.column_name = 'LAST_UPDATE_DATE' THEN 800
               WHEN u.column_name = 'LAST_UPDATED_BY'  THEN 560
               ELSE TO_NUMBER(u.sort_order_no)
             END AS sort_no
        FROM scm_mst_titleset_user u
        JOIN scm_mst_sheet_columns c
          ON u.program_id = c.program_id
         AND u.sheet_name = c.sheet_name
         AND u.column_name = c.column_name
       WHERE u.program_id = va_program_id
         AND u.sheet_name = va_sheet_name
         AND u.user_id = p_created_by
         AND u.user_inquiry_column_type_code = 'C'
      UNION ALL
      SELECT c.program_id,
             c.sheet_name,
             c.column_name,
             CASE WHEN c.column_name='GROUP_ID' THEN NVL(TO_NUMBER(u.sort_order_no),85) - 0.5
                  ELSE TO_NUMBER(c.sort_order_no)
             END AS sort_no
        FROM scm_mst_sheet_columns c
        LEFT JOIN scm_mst_titleset_user u
          ON u.program_id = c.program_id
         AND u.sheet_name = c.sheet_name
         AND u.user_inquiry_column_type_code='C'
         AND u.column_name IN ('ITEM_ID')
         AND u.user_id = p_created_by
       WHERE c.program_id = va_program_id
         AND c.sheet_name = va_sheet_name
         AND c.default_flag = ''
         AND c.valid_yn='Y'
  )
  SELECT LISTAGG(column_name, ', ') WITHIN GROUP(ORDER BY sort_no) || ', NOTATION' AS col_list,
         ' GROUP BY ' || LISTAGG(column_name, ', ') WITHIN GROUP(ORDER BY sort_no) || ', EDIT_FLAG, SORT_ORDER_NO' AS grp_list,
         ' ORDER BY SORT_KEY, ' ||
         REPLACE(
           REPLACE(LISTAGG(column_name, ', ') WITHIN GROUP(ORDER BY sort_no), 'MEASURE_GROUP', ' TO_NUMBER(SORT_ORDER_NO) '),
           ', MEASURE', ''
         ) AS ord_list
    INTO v_column, v_groupby, v_orderby
    FROM title_rows;

    DBMS_OUTPUT.PUT_LINE(v_program_name||' : 8----');

  ---------------------------------------------------------------------------
  -- 6) 동적 Pivot SQL 생성 및 o_rs1 오픈
  ---------------------------------------------------------------------------
  DECLARE
    v_pivot_in CLOB;
  BEGIN
    -- v_pv_list의 "순서 유지"를 위해 seq를 붙여 ORDER BY seq

--    WITH x AS (
--      SELECT LEVEL AS seq,
--             REGEXP_SUBSTR(v_pv_list, '''[^'']+''', 1, LEVEL) AS item
--        FROM dual
--      CONNECT BY REGEXP_SUBSTR(v_pv_list, '''[^'']+''', 1, LEVEL) IS NOT NULL
--    )
--    SELECT LISTAGG(item||' AS "'||REPLACE(item,'''','')||'"', ',') WITHIN GROUP(ORDER BY seq)
--      INTO v_pivot_in
--      FROM x;

    -- q-quote로 동적SQL 내 따옴표/콤마 깨짐 방지
    v_sql_text :=
         'WITH
          temp_select_measure AS (
            SELECT DISTINCT
                   u.program_id,
                   u.sheet_name,
                   u.user_id,
                   u.column_name AS measure_group,
                   u.column_name AS measure,
                   NVL(smsm.attribute5, u.column_name) AS result_measure,
                   u.sort_order_no
              FROM scm_mst_titleset_user u
              JOIN scm_mst_sheet_measure smsm
                ON u.program_id = smsm.program_id
               AND u.sheet_name = smsm.sheet_name
               AND u.column_name = smsm.column_name
             WHERE u.user_inquiry_column_type_code = ''M''
               AND smsm.valid_yn = ''Y''
               AND u.program_id = :va_program_id
               AND u.sheet_name = :va_sheet_name
               AND u.user_id    = :p_created_by
          ),
          t_ws_fcst AS (
            SELECT segment1 AS fcst_type
              FROM scm_adm_lookup_master_detail
             WHERE lookup_type = ''SALES_TYPE_CODE''
          ),

          -- ✅ o_rs4와 동일한 방식으로 동적SQL에서도 edit_flag 계산
          temp_into_group_measure AS (
            SELECT
              a.segment4 AS measure,
              TRIM(d.token)  AS days,
              TRIM(a.attribute2) AS from_time,
              TRIM(a.attribute3) AS to_time,
              TRIM(lm.token) AS limit_measure
            FROM scm_adm_lookup_master_detail a
            CROSS JOIN TABLE(string_split(a.attribute1, '','')) d
            CROSS JOIN TABLE(string_split(a.attribute4, '','')) lm
            WHERE a.lookup_type = ''GET_ADMIN_GROUP_MEASURE''
              AND a.valid_yn = ''Y''
              AND a.segment1 = :p_user_group
              AND a.segment2 = :va_program_id
              AND a.segment3 = :p_division_id
              AND ( d.token IS NULL OR TRIM(d.token) = '''' OR TRIM(d.token) = :v_today_dow )
              AND ( TRIM(a.attribute2) IS NULL OR TRIM(a.attribute2) = '''' OR TRIM(a.attribute2) <= :v_now_hhmi )
              AND ( TRIM(a.attribute3) IS NULL OR TRIM(a.attribute3) = '''' OR TRIM(a.attribute3) >= :v_now_hhmi )
          ),
          all_measures AS (
            SELECT a.segment4 AS measure
              FROM scm_adm_lookup_master_detail a
             WHERE a.lookup_type=''GET_ADMIN_GROUP_MEASURE''
               AND a.valid_yn=''Y''
               AND a.segment2 = :va_program_id
             GROUP BY a.segment4
          ),
          base_flag AS (
            SELECT m.measure,
                   CASE WHEN EXISTS (SELECT 1 FROM temp_into_group_measure x WHERE x.measure = m.measure)
                        THEN ''Y'' ELSE ''N'' END AS edit_flag
              FROM all_measures m
          ),
          temp_admin_group_measure AS (
            SELECT b.measure,
                   CASE
                     WHEN EXISTS (SELECT 1 FROM temp_into_group_measure x WHERE x.limit_measure = b.measure)
                       THEN ''N''
                     ELSE b.edit_flag
                   END AS edit_flag
              FROM base_flag b
          ),

          temp_site_item AS (
            SELECT
              f.division_id, f.project_code, f.scm_site_id, f.item_id, t2.nick_name,
              MAX(f.project_code) AS project_name,
              MAX(f.attribute5)   AS cell_model,
              MAX(s.end_customer) AS end_customer,
              MAX(s.soldto_customer) AS soldto_customer,
              MAX(i.country) AS country,
              MAX(i.country_name) AS country_name,
              MAX(h.city) AS city,
              MAX(h.city_name) AS city_name,
              MAX(j.user_name_en) AS project_owner,
              MAX(j.user_id) AS user_id,
              MAX(t2.item_name) AS item_name,
              MAX(t2.item_type) AS item_type,
              MAX(f.cust_group) AS cust_group,
              MAX(f.cust_group_dtl) AS cust_group_dtl,
              MAX(f.application) AS application,
              MAX(f.route) AS route,
              MAX(t2.mdm_project_name) AS mdm_project_name,
              MAX(t2.min_capacity) AS min_capacity,
              MAX(CASE WHEN f.item_id = looka.model THEN looka.biz_type ELSE t2.forecast_info_biz_type END) AS forecast_info_biz_type,
              MAX(t2.forecast_info_product_group) AS forecast_info_product_group,
              MAX(look.name) AS cell_type,
              MAX(CASE WHEN f.item_id = looka.model THEN looka.cell_pack_count ELSE t2.forecast_info_cell_pack_count END) AS forecast_info_cell_pack_count,
              MAX(t2.forecast_info_spec || t2.forecast_infor_version) AS forecast_info_all,
              MAX(t2.forecast_info_spec) AS forecast_info_spec,
              MAX(t2.forecast_infor_version) AS forecast_infor_version,
              MAX(NVL(t4.nick_name,'''') ) AS cell_model_nick_name,
              MAX(s.vmi_yn) AS vmi_yn,
              MAX(NVL(f.attribute1,'''') ) AS dms_sales,
              MAX(NVL(f.attribute2,'''') ) AS dms_customer,
              MAX(team.dept_id) AS dept_id,
              MAX(team.dept_name_ko) AS dept_name_ko,
              MAX(f.valid_yn) AS item_valid_yn
            FROM scm_mst_site_item f
            JOIN dm_mst_item_single_v t2
              ON f.division_id = t2.division_id
             AND f.item_id = t2.item_id
            JOIN scm_mst_site s
              ON f.division_id = s.division_id
             AND f.scm_site_id = s.scm_site_id
             AND s.site_type = ''SALES''
            JOIN scm_mst_city h ON s.city = h.city
            JOIN scm_mst_country i ON s.country = i.country
            LEFT JOIN (
              SELECT b.user_id, b.user_name, b.user_name_en, b.dept_id, c.dept_name_ko
                FROM scm_mst_sso_user_info b
                JOIN scm_mst_sso_dept_info c ON b.dept_id = c.dept_id
            ) team
              ON team.user_id = (
                   SELECT MIN(ss.token)
                     FROM TABLE(string_split(f.owner, '','')) ss
                    WHERE ss.token IS NOT NULL
                 )
            LEFT JOIN scm_mst_sso_user_info j
              ON j.user_id = SUBSTR(f.owner, 1, CASE WHEN INSTR(f.owner,'','')=0 THEN LENGTH(f.owner) ELSE INSTR(f.owner,'','')-1 END)
            LEFT JOIN (
              SELECT segment1 AS code, segment2 AS name
                FROM scm_adm_lookup_master_detail
               WHERE lookup_type = ''CELL_TYPE''
            ) look ON look.code = t2.cell_type
            LEFT JOIN dm_mst_item_single_v t4
              ON t2.division_id = t4.division_id
             AND NVL(t2.forecast_info_cell_model,'''') = t4.item_id
            LEFT JOIN (
              SELECT model, biz_type, cell_pack_count
                FROM (
                  SELECT segment2 AS model,
                         segment3 AS biz_type,
                         segment4 AS cell_pack_count,
                         RANK() OVER(PARTITION BY segment2 ORDER BY display_seq DESC) rk
                    FROM scm_adm_lookup_master_detail
                   WHERE lookup_type=''DM_BIZ_TYPE_40''
                     AND segment1 = ''40''
                )
               WHERE rk = 1
            ) looka ON looka.model = f.item_id
           WHERE f.division_id = ''40''
             AND t2.active_flag = ''Y''
             AND ( :p_scm_site_id = ''ALL'' OR f.scm_site_id IN (
                   SELECT s.token FROM TABLE(string_split(:p_scm_site_id, '','')) s WHERE s.token IS NOT NULL
                 ))
             AND ( :p_customer = ''ALL'' OR f.project_code IN (
                   SELECT s.token FROM TABLE(string_split(:p_customer, '','')) s WHERE s.token IS NOT NULL
                 ))
             AND ( :p_biz_type = ''ALL'' OR (CASE WHEN f.item_id = looka.model THEN looka.biz_type ELSE t2.forecast_info_biz_type END) IN (
                   SELECT s.token FROM TABLE(string_split(:p_biz_type, '','')) s WHERE s.token IS NOT NULL
                 ))
             AND ( :p_item_id IS NULL OR :p_item_id = '''' OR EXISTS (
                   SELECT 1
                     FROM TABLE(string_split(:p_item_id, '','')) x
                    WHERE x.token IS NOT NULL
                      AND ( f.item_id LIKE ''%''||x.token||''%'' OR t2.nick_name LIKE ''%''||x.token||''%'' )
                 ))
           GROUP BY f.division_id, f.project_code, f.scm_site_id, f.item_id, t2.nick_name
          ),

          temp_fcst_n_price AS (
            SELECT
              a.division_id, a.project_code, a.end_customer, a.scm_site_id, a.item_id,
              a.dom_exp, a.fcst_type, a.incoterms,
              CASE WHEN a.measure IN (''MKT_FCST_RP_CAR'',''MKT_FCST_RP_CELL'') THEN ''MKT_FCST_PP'' ELSE a.measure END AS measure,
              a.plant_site_id, a.cell_prod_site_id, a.yyyymmdd,
              a.qty,
              b.measure_group,
              c.cell_model, c.nick_name, c.dms_sales, c.dms_customer, c.owner,
              c.dept_id, c.dept_name_ko,
              c.forecast_info_cell_pack_count,
              c.item_type, c.project_name, c.project_owner,
              c.soldto_customer, c.country_name, c.city_name,
              c.item_name, c.vmi_yn,
              c.cust_group, c.cust_group_dtl, c.application, c.route,
              c.mdm_project_name, c.min_capacity, c.forecast_info_biz_type,
              c.cell_type, c.forecast_info_all, c.forecast_info_spec, c.forecast_infor_version,
              c.cell_model_nick_name,
              b.sort_order_no,
              NULL AS create_date,
              NULL AS last_updated_by,
              '''' AS currency,
              ''CURRENT'' AS version_no,
              NULL AS cutoff_yyyymmdd,
              CASE WHEN a.measure IN (''KRW'',''USD'',''LOC'',''MKT_AMT_LOC'',''MKT_AMT_KRW'') THEN ''POINT3'' ELSE ''INTEGER'' END AS notation
            FROM dm_pln_cfm_mkt_demand_plan a
            JOIN temp_select_measure b
              ON a.measure = CASE
                              WHEN b.measure IN (''RTF_RP_CAR'',''RTF_SYS_RP_CAR'',''RTF_RP_CELL'',''RTF_SYS_RP_CELL'',''RTF_ENERGY'') THEN ''RTF''
                              ELSE b.measure
                            END
            JOIN temp_site_item c
              ON a.division_id = c.division_id
             AND a.project_code = c.project_code
             AND a.scm_site_id = c.scm_site_id
             AND a.item_id = c.item_id
             AND c.item_valid_yn = ''Y''
            JOIN t_ws_fcst d
              ON a.fcst_type = d.fcst_type
           WHERE a.division_id = :p_division_id
             AND ( :p_scm_site_id = ''ALL'' OR a.scm_site_id IN (
                   SELECT s.token FROM TABLE(string_split(:p_scm_site_id, '','')) s WHERE s.token IS NOT NULL
                 ))
             AND a.yyyymmdd BETWEEN :v_from_yyyymmdd AND :v_to_yyyymmdd
             AND ( (a.measure <> ''SCM_FCST'' AND a.qty <> 0) OR (a.measure = ''SCM_FCST'') )
          ),

          mf_sp AS (
            SELECT
              a.division_id, a.scm_site_id, a.plant_site_id, a.project_code, a.item_id,
              a.incoterms, a.fcst_type, a.dom_exp, a.measure, a.end_customer,
              a.nick_name, a.dms_sales, a.dms_customer,
              c.basis_yyyymm AS yyyymm,
              c.basis_yyyymm || c.iso_week AS yyyymmww,
              c.basis_yyyymmdd AS yyyymmdd,
              a.cell_model AS forecast_info_cell_model,
              a.dept_id AS team_id,
              a.dept_name_ko AS team_name_ko,
              a.item_type, a.project_name, a.project_owner, a.owner,
              a.soldto_customer, a.country_name, a.city_name,
              a.item_name, a.vmi_yn, a.cell_prod_site_id,
              a.cust_group, a.cust_group_dtl, a.application, a.route,
              a.mdm_project_name, a.min_capacity, a.forecast_info_biz_type,
              a.cell_type, a.forecast_info_cell_pack_count, a.forecast_info_all,
              a.forecast_info_spec, a.forecast_infor_version, a.cell_model_nick_name,
              CAST(a.qty AS NUMBER(36,10)) AS qty,
              999 AS sort_key,
              NVL(a.create_date,'' '') AS last_update_date,
              NVL(a.last_updated_by,'' '') AS last_updated_by,
              a.notation,
              a.currency,
              a.version_no,
              a.cutoff_yyyymmdd,
              a.sort_order_no,
              a.measure_group,
              ''N'' AS new_flag,
              ''0000000'' AS bucket,
              NVL(m.edit_flag, ''N'') AS edit_flag
            FROM temp_fcst_n_price a
            JOIN scm_sys_calendar_m c
              ON c.basis_yyyymmdd = a.yyyymmdd
            LEFT JOIN temp_admin_group_measure m
              ON m.measure = a.measure
           WHERE ( :p_team_id = ''ALL'' OR a.dept_id IN (
                   SELECT s.token FROM TABLE(string_split(:p_team_id, '','')) s WHERE s.token IS NOT NULL
                 ))
          )

          SELECT '||v_column||', sort_order_no, '||v_pv_col_list||'
            FROM (
              -- Day
              SELECT '||v_column||', f.sort_order_no, ''D_''||f.yyyymmdd AS ykey, f.qty
                FROM mf_sp f
               WHERE ( (f.measure NOT IN (''SCM_FCST'',''FCST_GAP'') AND f.qty <> 0) OR (f.measure IN (''SCM_FCST'',''FCST_GAP'')) )

              UNION ALL
              -- Week (SUM)
              SELECT '||v_column||', f.sort_order_no, ''W_''||f.yyyymmww AS ykey, SUM(f.qty) AS qty
                FROM mf_sp f
               WHERE f.measure NOT IN (''KRW'',''USD'',''LOC'')
                 AND ( (f.measure NOT IN (''SCM_FCST'',''FCST_GAP'') AND f.qty <> 0) OR (f.measure IN (''SCM_FCST'',''FCST_GAP'')) )
               GROUP BY '||v_column||', f.sort_order_no, f.yyyymmww

              UNION ALL
              -- Week (AVG)
              SELECT '||v_column||', f.sort_order_no, ''W_''||f.yyyymmww AS ykey, AVG(f.qty) AS qty
                FROM mf_sp f
               WHERE f.measure IN (''KRW'',''USD'',''LOC'')
               GROUP BY '||v_column||', f.sort_order_no, f.yyyymmww

              UNION ALL
              -- Month (SUM)
              SELECT '||v_column||', f.sort_order_no, ''M_''||f.yyyymm AS ykey, SUM(f.qty) AS qty
                FROM mf_sp f
               WHERE f.measure NOT IN (''KRW'',''USD'',''LOC'')
                 AND ( (f.measure NOT IN (''SCM_FCST'',''FCST_GAP'') AND f.qty <> 0) OR (f.measure IN (''SCM_FCST'',''FCST_GAP'')) )
               GROUP BY '||v_column||', f.sort_order_no, f.yyyymm

              UNION ALL
              -- Month (AVG)
              SELECT '||v_column||', f.sort_order_no, ''M_''||f.yyyymm AS ykey, AVG(f.qty) AS qty
                FROM mf_sp f
               WHERE f.measure IN (''KRW'',''USD'',''LOC'')
               GROUP BY '||v_column||', f.sort_order_no, f.yyyymm
            ) src
            PIVOT (
              SUM(qty) FOR ykey IN ('||v_pivot_in||')
            ) p
          '||v_orderby;

    DBMS_OUTPUT.PUT_LINE(v_program_name||' : 9----');
    DBMS_OUTPUT.PUT_LINE(v_sql_text||' '||v_sql_text);

    OPEN o_rs1 FOR v_sql_text
    USING
      -- temp_select_measure (3)
      va_program_id,              -- :va_program_id (1)
      va_sheet_name,              -- :va_sheet_name
      p_created_by,               -- :p_created_by

      -- temp_into_group_measure (6)
      p_user_group,               -- :p_user_group
      va_program_id,              -- :va_program_id (2)
      p_division_id,              -- :p_division_id (1)
      v_today_dow,                -- :v_today_dow
      v_now_hhmi,                 -- :v_now_hhmi (1)
      v_now_hhmi,                 -- :v_now_hhmi (2)

      -- all_measures (1)
      va_program_id,              -- :va_program_id (3)

      -- temp_site_item filters
      p_scm_site_id,              -- :p_scm_site_id (1)  ( :p_scm_site_id = 'ALL' )
      p_scm_site_id,              -- :p_scm_site_id (2)  ( string_split(:p_scm_site_id) )
      p_customer,                 -- :p_customer (1)
      p_customer,                 -- :p_customer (2)
      p_biz_type,                 -- :p_biz_type (1)
      p_biz_type,                 -- :p_biz_type (2)
      p_item_id,                  -- :p_item_id (1)  ( IS NULL )
      p_item_id,                  -- :p_item_id (2)  ( = '' )
      p_item_id,                  -- :p_item_id (3)  ( string_split(:p_item_id) )

      -- temp_fcst_n_price
      p_division_id,              -- :p_division_id (2)
      p_scm_site_id,              -- :p_scm_site_id (3)  ( :p_scm_site_id = 'ALL' )
      p_scm_site_id,              -- :p_scm_site_id (4)  ( string_split(:p_scm_site_id) )
      v_from_yyyymmdd,            -- :v_from_yyyymmdd
      v_to_yyyymmdd,              -- :v_to_yyyymmdd

      -- mf_sp team filter
      p_team_id,                  -- :p_team_id (1) ( :p_team_id = 'ALL' )
      p_team_id;                  -- :p_team_id (2) ( string_split(:p_team_id) )

  END;

    DBMS_OUTPUT.PUT_LINE(v_program_name||' : 10----');

  ---------------------------------------------------------------------------
  -- 7) 나머지 ResultSet들 반환
  ---------------------------------------------------------------------------
  OPEN o_rs2 FOR
    SELECT month_name, iso_week
      FROM scm_sys_calendar_m
     WHERE basis_yyyymm = TO_CHAR(ADD_MONTHS(SYSDATE, 3), 'YYYYMM')
     ORDER BY basis_yyyymmdd
     FETCH FIRST 1 ROWS ONLY;

  OPEN o_rs3 FOR
    WITH a AS (
      SELECT basis_yyyymm, iso_week, basis_date
        FROM scm_sys_calendar_m
       WHERE basis_yyyymmdd = TO_CHAR(SYSDATE,'YYYYMMDD')
    ),
    b AS (
      SELECT basis_yyyymm, iso_week, basis_date
        FROM scm_sys_calendar_m
       WHERE basis_yyyymmdd = TO_CHAR(SYSDATE-7,'YYYYMMDD')
    )
    SELECT 'M_'||a.basis_yyyymm AS this_yyyymm,
           'W_'||a.basis_yyyymm||a.iso_week AS this_yyyymmww,
           a.basis_date,
           'M_'||b.basis_yyyymm AS pre_yyyymm,
           'W_'||b.basis_yyyymm||b.iso_week AS pre_yyyymmww,
           a.basis_yyyymm, a.iso_week
      FROM a CROSS JOIN b;

    DBMS_OUTPUT.PUT_LINE(v_program_name||' : 11----');

  OPEN o_rs4 FOR
    WITH temp_into_group_measure AS (
      SELECT
        a.segment1 AS user_group,
        a.segment3 AS division_id,
        a.segment4 AS measure,
        TRIM(d.token) AS days,
        TRIM(a.attribute2) AS from_time,
        TRIM(a.attribute3) AS to_time,
        TRIM(lm.token) AS limit_measure
      FROM scm_adm_lookup_master_detail a
      CROSS JOIN TABLE(string_split(a.attribute1, ',')) d
      CROSS JOIN TABLE(string_split(a.attribute4, ',')) lm
      WHERE a.lookup_type = 'GET_ADMIN_GROUP_MEASURE'
        AND a.valid_yn = 'Y'
        AND a.segment1 = p_user_group
        AND a.segment2 = va_program_id
        AND a.segment3 = p_division_id
        AND ( d.token IS NULL OR TRIM(d.token) = '' OR TRIM(d.token) = v_today_dow )
        AND ( TRIM(a.attribute2) IS NULL OR TRIM(a.attribute2) = '' OR TRIM(a.attribute2) <= v_now_hhmi )
        AND ( TRIM(a.attribute3) IS NULL OR TRIM(a.attribute3) = '' OR TRIM(a.attribute3) >= v_now_hhmi )
    ),
    all_measures AS (
      SELECT a.segment4 AS measure
        FROM scm_adm_lookup_master_detail a
       WHERE a.lookup_type='GET_ADMIN_GROUP_MEASURE'
         AND a.valid_yn='Y'
         AND a.segment2 = va_program_id
       GROUP BY a.segment4
    ),
    base_flag AS (
      SELECT m.measure,
             CASE WHEN EXISTS (SELECT 1 FROM temp_into_group_measure x WHERE x.measure = m.measure)
                  THEN 'Y' ELSE 'N' END AS edit_flag
        FROM all_measures m
    )
    SELECT b.measure,
           CASE
             WHEN EXISTS (SELECT 1 FROM temp_into_group_measure x WHERE x.limit_measure = b.measure)
               THEN 'N'
             ELSE b.edit_flag
           END AS edit_flag
      FROM base_flag b;

    DBMS_OUTPUT.PUT_LINE(v_program_name||' : 12----');

  OPEN o_rs5 FOR
    SELECT basis_yyyymmdd,
           basis_yyyymm,
           CASE WHEN SUBSTR(basis_start_date,7,2) = '01' THEN 'Y' ELSE 'N' END AS first_week_flag,
           CASE
             WHEN SUBSTR(TO_CHAR(TO_DATE(basis_start_date,'YYYYMMDD')+7,'YYYYMMDD'),1,6) = SUBSTR(basis_start_date,1,6)
               THEN 'N' ELSE 'Y'
           END AS end_month_flag,
           COUNT(*) OVER(PARTITION BY basis_yyyymm) AS month_day_cnt,
           COUNT(*) OVER(PARTITION BY iso_yyyyww||partial_week_name) AS week_day_cnt,
           iso_yyyyww
      FROM scm_sys_calendar_m
     WHERE basis_yyyymmdd BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
     ORDER BY basis_yyyymmdd;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('ERR =' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_CALL_STACK);
    RAISE_APPLICATION_ERROR(-20001, 'NO_DATA_FOUND: 필수 기준 데이터가 없습니다.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERR =' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_CALL_STACK);
    RAISE_APPLICATION_ERROR(-20099, 'DMF0082_GET_MAIN_DATA ERROR: '||SQLERRM);
END;