--==============================================================================
-- 110_DMF0008_Division81_Empty_Diagnose.sql
--
-- 목적: DB 에 division=81 데이터 존재하지만 FE 조회 결과 0건 원인 진단
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === DIAG 1 : DM_DNM_EDI_SUMMARY 의 division=81 데이터 + date range (FE filter 와 cross-check) ===

-- store 의 initSearch (현재월 1일 ~ +3개월 말일) — 예: 2026-06-01 ~ 2026-09-30
SELECT division_id,
       COUNT(*) AS total_rows,
       MIN(start_date) AS min_sdate, MAX(start_date) AS max_sdate,
       MIN(end_date)   AS min_edate, MAX(end_date)   AS max_edate,
       SUM(CASE WHEN start_date >= '20260601' AND start_date <= '20260930' THEN 1 ELSE 0 END) AS in_default_range
  FROM SCM_MGR.DM_DNM_EDI_SUMMARY
 WHERE division_id = '81'
 GROUP BY division_id;

PROMPT === DIAG 2 : DM_DNM_EDI_SUMMARY 의 date column 인벤토리 (어느 컬럼으로 필터링하는지) ===

SELECT column_name, data_type, data_length
  FROM all_tab_columns
 WHERE owner = 'SCM_MGR'
   AND table_name = 'DM_DNM_EDI_SUMMARY'
   AND (data_type LIKE '%DATE%' OR column_name LIKE '%DATE%' OR column_name LIKE '%DT%' OR column_name LIKE '%YYYYMM%')
 ORDER BY column_id;

PROMPT === DIAG 3 : DMF0008_GET_EDI_MST_SUMMARY 시그니처 (FE 호출 인자 확인) ===

SELECT argument_name, position, data_type, in_out
  FROM all_arguments
 WHERE owner = 'SCM_MGR'
   AND object_name = 'DMF0008_GET_EDI_MST_SUMMARY'
   AND package_name IS NULL
 ORDER BY position;

PROMPT === DIAG 4 : DMF0008_GET_EDI_MST_SUMMARY body 의 WHERE 절 (date filter 확인) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_SUMMARY'
   AND type = 'PROCEDURE'
   AND (REGEXP_LIKE(text, 'WHERE|AND.*DATE|AND.*YYYYMM|p_from|p_to|FROM_DT|TO_DT', 'i'))
 ORDER BY line
 FETCH FIRST 40 ROWS ONLY;

PROMPT === DIAG 5 : DMF0008_GET_EDI_MST_SUMMARY 단독 호출 (다양한 date range 시도) ===

DECLARE
  v_rc SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_dummy VARCHAR2(4000);

  PROCEDURE try_call(p_from VARCHAR2, p_to VARCHAR2, p_div VARCHAR2) IS
    v_rc2 SYS_REFCURSOR;
    v_c PLS_INTEGER := 0;
  BEGIN
    -- SP 시그니처에 따라 named param 조정 (DIAG 3 결과 보고)
    EXECUTE IMMEDIATE
      'BEGIN DMF0008_GET_EDI_MST_SUMMARY(p_division_id=>:1, p_from_yyyymmdd=>:2, p_to_yyyymmdd=>:3, p_ses_user_id=>:4, p_menu_id=>:5, O_RC1=>:6); END;'
      USING p_div, p_from, p_to, 'minyonglee1', 'DMF0008', OUT v_rc2;
    BEGIN
      LOOP FETCH v_rc2 INTO v_dummy; EXIT WHEN v_rc2%NOTFOUND; v_c := v_c + 1; END LOOP;
    EXCEPTION WHEN OTHERS THEN v_c := -99; END;
    BEGIN CLOSE v_rc2; EXCEPTION WHEN OTHERS THEN NULL; END;
    DBMS_OUTPUT.PUT_LINE('div=' || p_div || ' range=[' || p_from || '~' || p_to || '] rows=' || v_c);
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('div=' || p_div || ' range=[' || p_from || '~' || p_to || '] ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 100));
  END;
BEGIN
  try_call('20260601', '20260930', '81');  -- 현재 default
  try_call('20260101', '20261231', '81');  -- 2026 전체
  try_call('20240101', '20261231', '81');  -- 3년
  try_call('19000101', '99991231', '81');  -- 무제한
  try_call('20260601', '20260930', '40');  -- 40 (비교)
END;
/

PROMPT === DIAG 6 : DM_DNM_EDI_SUMMARY division 81 의 user_id 인벤토리 (권한 필터 후보) ===

SELECT user_id, division_id, COUNT(*) AS row_cnt
  FROM SCM_MGR.DM_DNM_EDI_SUMMARY
 WHERE division_id = '81'
 GROUP BY user_id, division_id
 ORDER BY row_cnt DESC
 FETCH FIRST 10 ROWS ONLY;

PROMPT === 판독 ===
PROMPT - DIAG 1 in_default_range = 0 → store default date 범위 (현재월~+3월) 에 81 데이터 없음 → FE 의 fromYyyymmdd/toYyyymmdd 조정 필요
PROMPT - DIAG 5 div=81 range=무제한 row > 0 + range=default row = 0 → 데이터는 있지만 default 날짜 범위 외 (가설 C 확정)
PROMPT - DIAG 5 div=81 모든 range row = 0 + div=40 row > 0 → 권한 필터 또는 SP body 다른 조건 (가설 D)
PROMPT - DIAG 5 div=81 모든 range row > 0 → SP 자체 정상. FE payload 또는 응답 형식 문제 (Network 탭 확인)
PROMPT - DIAG 6 user_id 컬럼에 minyonglee1 없으면 SP 의 권한 필터가 그 컬럼 사용 시 0 row
