--==============================================================================
-- 190_DMF0008_SALES_SITE_Final_Diagnose.sql
--
-- 목적:
--   1) SALES_SITE 정확 5 args 단독 호출 → 실제 ORA 캡쳐
--   2) SP body line 170-185 (OPEN O_RESULT_CURSOR 2번 영역) IF/ELSE 분기 확인
--   3) API_M 중복 + BTN_MPG 매핑 정리
--
-- 정확한 sig (DIAG 2):
--   P_DIVISION_ID, P_SOLDTO, P_SHIPTO, P_SCM_SITE_ID, O_RESULT_CURSOR (5 args)
--   ⚠ P_USER_ID / P_MENU_ID / O_RC1 없음 (SUMMARY/REPAIR/SSPM 와 다름)
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === DIAG 1 : SALES_SITE 정확 5 args 단독 호출 (BMW row sample) ===

DECLARE
  v_result_rc SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_dummy VARCHAR2(4000);
BEGIN
  DMF0008_GET_SALES_SITE(
    P_DIVISION_ID => '81',
    P_SOLDTO      => 'DE000161',
    P_SHIPTO      => 'DEH000086',
    P_SCM_SITE_ID => '',
    O_RESULT_CURSOR => v_result_rc
  );
  BEGIN
    LOOP FETCH v_result_rc INTO v_dummy; EXIT WHEN v_result_rc%NOTFOUND OR v_cnt >= 5; v_cnt := v_cnt + 1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt := -99; END;
  BEGIN CLOSE v_result_rc; EXCEPTION WHEN OTHERS THEN NULL; END;

  DBMS_OUTPUT.PUT_LINE('SALES_SITE 5args fetch = ' || v_cnt || ' (-99=multi-col 정상)');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('SALES_SITE 5args ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 300));
  DBMS_OUTPUT.PUT_LINE('BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === DIAG 2 : SP body line 170-200 (OPEN O_RESULT_CURSOR 2번 영역 확인) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_SALES_SITE'
   AND type = 'PROCEDURE'
   AND line BETWEEN 170 AND 205
 ORDER BY line;

PROMPT === DIAG 3 : SP body 전체 length + IF/THEN/ELSE 분기 grep ===

SELECT COUNT(*) AS total_lines
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_SALES_SITE'
   AND type = 'PROCEDURE';

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_SALES_SITE'
   AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, '\b(IF|ELSE|ELSIF|END\s+IF|BEGIN|END)\b', 'i')
 ORDER BY line
 FETCH FIRST 30 ROWS ONLY;

PROMPT === DIAG 4 : API_M 중복 정리 — BTN_MPG 가 어느 api_id 가리키는지 ===

-- SCM_ADM_MNU_BTN_MPG_M 컬럼명 확인 (이전 ORA-00904 BTN_ID 회피)
SELECT column_name FROM all_tab_columns
 WHERE owner = 'SCM_MGR'
   AND table_name = 'SCM_ADM_MNU_BTN_MPG_M'
 ORDER BY column_id;

PROMPT === DIAG 5 : DMF0008 BTN_MPG 전체 (SHT_NM 기준 = salesSite, sspm) ===

SELECT *
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE mnu_id = 'DMF0008'
   AND sht_nm IN ('salesSite', 'sspm')
 ORDER BY sht_nm;

PROMPT === DIAG 6 : API_M 중복 row 식별 (P_DMF0008_SITE_GET vs P_DMF0008_SALES_SITE_GET) ===

SELECT api_id, api_url, api_tp_cd, api_msg_id
  FROM SCM_MGR.SCM_ADM_API_M
 WHERE UPPER(api_url) LIKE '%DMF0008_GET_SALES_SITE%'
 ORDER BY api_id;

PROMPT === 판독 ===
PROMPT - DIAG 1: SP 자체 정상 (-99) 또는 ORA 캡쳐
PROMPT - DIAG 2: line 177/180 OPEN O_RESULT_CURSOR 사이 구조
PROMPT - DIAG 3: IF/THEN 분기 있으면 line 180 = ELSE 분기 (정상)
PROMPT -          없으면 SUMMARY 와 동일 무조건 덮어쓰기 사고
PROMPT - DIAG 5: BTN_MPG 의 api_id 가 P_DMF0008_SITE_GET 또는 P_DMF0008_SALES_SITE_GET 둘 중 하나
PROMPT -          → 사용되지 않는 api_id row 는 cleanup 후보
