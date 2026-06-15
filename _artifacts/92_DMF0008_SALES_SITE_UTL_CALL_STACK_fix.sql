-- DMF0008_GET_SALES_SITE 사고 fix (2026-06-10)
-- 사용자 보고: Repair grid 더블클릭 시 sql error 발생.
--
-- 진짜 원인 (EXCEPTION OTHERS 의 generic '오류가 발생했습니다.' 가 숨김):
--   ORA-06533: Subscript beyond count at line 54
--   UTL_CALL_STACK.SUBPROGRAM(1)(1) IS NOT NULL 로 unconditional access — top-level call 시 element 1개만 있어서 (1)(2) 접근 시 폭발
--   자매 화면 DMF0008_GET_SALES_SITE_PROJECT_MODEL 는 .COUNT > 1 안전 체크 패턴
--
-- Fix (NOT a body rewrite — minimal diff):
--   Line 53: IF UTL_CALL_STACK.SUBPROGRAM(1)(1) IS NOT NULL THEN
--          → IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
--   EXCEPTION: RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.')
--            → RAISE_APPLICATION_ERROR(-20001, 'SQLCODE=' || V_SQL_CODE || ' SQLERRM=' || V_SQL_ERRMSG || ' BACKTRACE=...')
--   EXCEPTION: PR_SCM_SYS_LOG_BATCH(...) 호출 비활성화 (SCM_SYS_LOG table 미존재 — 별도 이슈)
--
-- 적용 SP body 파일: _dmf0008_fix/_fixed_sales_site.sql (CREATE OR REPLACE)
-- Python generator: _dmf0008_fix/apply_sales_site_fix.py

-- 본 파일은 적용 기록 용. 실제 SP body 는 _fixed_sales_site.sql 적용 후 STATUS=VALID.

-- 검증 SQL:
PROMPT === DMF0008_GET_SALES_SITE STATUS (must be VALID) ===
SELECT object_name, status FROM all_objects
 WHERE owner='SCM_MGR' AND object_name='DMF0008_GET_SALES_SITE' AND object_type='PROCEDURE';

PROMPT === SP test call ===
DECLARE
  cr SYS_REFCURSOR;
  v_cnt1 NUMBER; v_cnt2 NUMBER;
BEGIN
  DMF0008_GET_SALES_SITE('81', 'FR00125300', 'FRH000201', 'PSA AS_FR_VEL', cr);
  SELECT COUNT(*) INTO v_cnt1 FROM GT_GSSI_DMF0008_RESULT_TABLE_1_2;
  SELECT COUNT(*) INTO v_cnt2 FROM GT_GSSI_DMF0008_RESULT_TABLE_2_2;
  DBMS_OUTPUT.PUT_LINE('Expected: GTT_1_2=1 (match) / GTT_2_2=0 (fallback skipped)');
  DBMS_OUTPUT.PUT_LINE('Actual:   GTT_1_2=' || v_cnt1 || ' / GTT_2_2=' || v_cnt2);
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('FAILED: ' || SUBSTR(SQLERRM, 1, 300));
END;
/
