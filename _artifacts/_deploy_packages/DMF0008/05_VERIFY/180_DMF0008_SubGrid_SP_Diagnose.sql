--==============================================================================
-- 180_DMF0008_SubGrid_SP_Diagnose.sql
--
-- 목적:
--   1단 grid 더블클릭 시 SQL error -9994 의 진짜 원인.
--   FE handleSummaryDoubleClick → setSubFilter() → 3단 SALES_SITE + SSPM 호출.
--   둘 중 하나 ORA 발생 가능. REPAIR 는 호출 안 됨 (이전 진단 무관).
--
-- As-Is sigs:
--   DMF0008_GET_SALES_SITE                : division_id / soldto / shipto / scm_site_id
--   DMF0008_GET_SALES_SITE_PROJECT_MODEL  : division_id / item_id / scm_site_id
--
-- FE 가 보내는 인자:
--   SALES_SITE : divisionId / soldTo / shipTo / scmSiteId
--   SSPM       : divisionId / itemId / scmSiteId
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === DIAG 1 : 두 SP 존재 + STATUS ===

SELECT owner, object_name, object_type, status, last_ddl_time
  FROM all_objects
 WHERE object_name IN ('DMF0008_GET_SALES_SITE', 'DMF0008_GET_SALES_SITE_PROJECT_MODEL')
   AND object_type IN ('PROCEDURE', 'SYNONYM')
 ORDER BY object_name, owner;

PROMPT === DIAG 2 : SALES_SITE signature ===

SELECT argument_name, position, data_type, in_out
  FROM all_arguments
 WHERE owner = 'SCM_MGR'
   AND object_name = 'DMF0008_GET_SALES_SITE'
   AND package_name IS NULL
 ORDER BY position;

PROMPT === DIAG 3 : SSPM signature ===

SELECT argument_name, position, data_type, in_out
  FROM all_arguments
 WHERE owner = 'SCM_MGR'
   AND object_name = 'DMF0008_GET_SALES_SITE_PROJECT_MODEL'
   AND package_name IS NULL
 ORDER BY position;

PROMPT === DIAG 4 : 두 SP 의 PROC_M 메타 ===

SELECT proc_nm, col_nm, data_tp_cd, col_tp_cd, sort_ord
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE proc_nm IN ('DMF0008_GET_SALES_SITE', 'DMF0008_GET_SALES_SITE_PROJECT_MODEL')
 ORDER BY proc_nm, sort_ord;

PROMPT === DIAG 5 : 두 SP body OPEN 구문 (DUMMY OPEN 사고 검출) ===

SELECT 'SALES_SITE' AS sp, line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_SALES_SITE'
   AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, 'OPEN\s+O_', 'i')
 ORDER BY line;

SELECT 'SSPM' AS sp, line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_SALES_SITE_PROJECT_MODEL'
   AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, 'OPEN\s+O_', 'i')
 ORDER BY line;

PROMPT === DIAG 6 : SALES_SITE 단독 호출 — 실제 FE 더블클릭 시 sample row 값 사용 ===
-- (BMW row 의 ERP_SOLDTO/ERP_SHIPTO/GSCM_SALES_SITE_ID — 임의 sample)

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_result_rc SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_dummy VARCHAR2(4000);
BEGIN
  -- SP signature 시그너처 자동 매칭 시도 (DIAG 2 결과 본 후 수동 정정 가능)
  EXECUTE IMMEDIATE
    'BEGIN DMF0008_GET_SALES_SITE(:p_division_id, :p_soldto, :p_shipto, :p_scm_site_id, :p_user_id, :p_menu_id, :o_rc1, :o_result); END;'
    USING IN '81', IN 'DE000161', IN 'DEH000086', IN '', IN 'minyonglee1', IN 'DMF0008', OUT v_rc1, OUT v_result_rc;
  BEGIN
    LOOP FETCH v_rc1 INTO v_dummy; EXIT WHEN v_rc1%NOTFOUND OR v_cnt >= 5; v_cnt := v_cnt + 1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt := -99; END;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_result_rc; EXCEPTION WHEN OTHERS THEN NULL; END;

  DBMS_OUTPUT.PUT_LINE('SALES_SITE fetch = ' || v_cnt || ' (-99=multi-col 정상)');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('SALES_SITE ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 300));
  DBMS_OUTPUT.PUT_LINE('BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === DIAG 7 : SSPM 단독 호출 ===

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_result_rc SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_dummy VARCHAR2(4000);
BEGIN
  EXECUTE IMMEDIATE
    'BEGIN DMF0008_GET_SALES_SITE_PROJECT_MODEL(:p_division_id, :p_item_id, :p_scm_site_id, :p_user_id, :p_menu_id, :o_rc1, :o_result); END;'
    USING IN '81', IN 'APFMCCX48-A1', IN '', IN 'minyonglee1', IN 'DMF0008', OUT v_rc1, OUT v_result_rc;
  BEGIN
    LOOP FETCH v_rc1 INTO v_dummy; EXIT WHEN v_rc1%NOTFOUND OR v_cnt >= 5; v_cnt := v_cnt + 1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt := -99; END;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_result_rc; EXCEPTION WHEN OTHERS THEN NULL; END;

  DBMS_OUTPUT.PUT_LINE('SSPM fetch = ' || v_cnt || ' (-99=multi-col 정상)');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('SSPM ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 300));
  DBMS_OUTPUT.PUT_LINE('BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === DIAG 8 : API_M / BTN_MPG (두 sheet 정합) ===

SELECT api_id, api_url, api_tp_cd
  FROM SCM_MGR.SCM_ADM_API_M
 WHERE UPPER(api_url) LIKE '%DMF0008_GET_SALES_SITE%'
 ORDER BY api_id;

PROMPT === DIAG 9 : 두 SP body 의 PR_SCM_SYS_LOG_BATCH / RAISE_APPLICATION_ERROR 패턴 ===
-- (SP 가 -20001 raise → BE 가 -9994 변환 chain 확인)

SELECT 'SALES_SITE' AS sp, line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_SALES_SITE'
   AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, 'PR_SCM_SYS_LOG|RAISE_APPLICATION_ERROR|EXCEPTION\s+WHEN', 'i')
 ORDER BY line;

SELECT 'SSPM' AS sp, line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_SALES_SITE_PROJECT_MODEL'
   AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, 'PR_SCM_SYS_LOG|RAISE_APPLICATION_ERROR|EXCEPTION\s+WHEN', 'i')
 ORDER BY line;

PROMPT === 판독 ===
PROMPT - DIAG 1 두 SP VALID
PROMPT - DIAG 2/3 sig 가 PROC_M (DIAG 4) 와 정합 — 다르면 -9994 원인
PROMPT - DIAG 5 DUMMY OPEN 패턴 있으면 SUMMARY 와 동일 사고
PROMPT - DIAG 6/7 ERR 캡쳐 → 진짜 ORA 원인
PROMPT - DIAG 6/7 fetch=-99 → SP 정상 → FE/BE 매핑 문제
PROMPT - DIAG 6/7 fetch=ERR → SP body 본격 분석 필요
