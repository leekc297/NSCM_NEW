--==============================================================================
-- 230_PKG_DMF0072_Proc_Sig_And_Call.sql
--
-- 목적:
--   1) PKG_DMF0072.P_DMF0072_GET_NNMASTER_MAPPING 의 정확한 signature
--   2) WRAPPER 의 PKG.proc 호출 args 11개 vs PKG.proc sig 일치 확인
--   3) WRAPPER 정확 named param (P_XXX) 으로 호출 → ORA 캡쳐
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250

PROMPT === DIAG 1 : PKG_DMF0072.P_DMF0072_GET_NNMASTER_MAPPING signature ===

SELECT argument_name, position, data_type, in_out
  FROM all_arguments
 WHERE owner = 'SCM_MGR'
   AND package_name = 'PKG_DMF0072'
   AND object_name = 'P_DMF0072_GET_NNMASTER_MAPPING'
 ORDER BY sequence;

PROMPT === DIAG 2 : standalone DMF0072_GET_NNMASTER_MAPPING signature ===

SELECT argument_name, position, data_type, in_out
  FROM all_arguments
 WHERE owner = 'SCM_MGR'
   AND object_name = 'DMF0072_GET_NNMASTER_MAPPING'
   AND package_name IS NULL
 ORDER BY position;

PROMPT === DIAG 3 : DMF0072_GET_NNMASTER_MAPPING_WRAPPER signature (외부 노출) ===

SELECT argument_name, position, data_type, in_out
  FROM all_arguments
 WHERE owner = 'SCM_MGR'
   AND object_name = 'DMF0072_GET_NNMASTER_MAPPING_WRAPPER'
   AND package_name IS NULL
 ORDER BY position;

PROMPT === DIAG 4 : WRAPPER 정확 named param 호출 (P_XXX) ===

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_dummy VARCHAR2(4000);
BEGIN
  DMF0072_GET_NNMASTER_MAPPING_WRAPPER(
    P_DATA_TYPE_CODE => 'ALL',
    P_DIVISION_ID    => '81',
    P_DEPT_ID        => 'ALL',
    P_END_CUSTOMER   => 'ALL',
    P_SCM_SITE_ID    => 'ALL',
    P_PROJECT_CODE   => 'ALL',
    P_ITEM_ID        => 'ALL',
    P_USER_ID        => 'minyonglee1',
    P_MENU_ID        => 'DMF0072',
    O_RC1            => v_rc1
  );
  BEGIN
    LOOP FETCH v_rc1 INTO v_dummy; EXIT WHEN v_rc1%NOTFOUND OR v_cnt >= 5; v_cnt := v_cnt + 1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt := -99; END;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;

  DBMS_OUTPUT.PUT_LINE('WRAPPER fetch = ' || v_cnt || ' (-99=multi-col 정상)');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('WRAPPER ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 400));
  DBMS_OUTPUT.PUT_LINE('BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === DIAG 5 : standalone DMF0072_GET_NNMASTER_MAPPING 정확 named param ===

DECLARE
  v_cursor SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_dummy VARCHAR2(4000);
BEGIN
  DMF0072_GET_NNMASTER_MAPPING(
    p_data_type_code => 'ALL',
    p_division_id    => '81',
    p_dept_id        => 'ALL',
    p_end_customer   => 'ALL',
    p_scm_site_id    => 'ALL',
    p_project_code   => 'ALL',
    p_item_id        => 'ALL',
    p_cursor         => v_cursor
  );
  BEGIN
    LOOP FETCH v_cursor INTO v_dummy; EXIT WHEN v_cursor%NOTFOUND OR v_cnt >= 5; v_cnt := v_cnt + 1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt := -99; END;
  BEGIN CLOSE v_cursor; EXCEPTION WHEN OTHERS THEN NULL; END;

  DBMS_OUTPUT.PUT_LINE('NNMASTER_MAPPING fetch = ' || v_cnt || ' (-99=multi-col 정상)');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('NNMASTER_MAPPING ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 400));
  DBMS_OUTPUT.PUT_LINE('BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === DIAG 6 : PKG_DMF0072.P_DMF0072_GET_NNMASTER_MAPPING 직접 호출 ===

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_rc2 SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_dummy VARCHAR2(4000);
BEGIN
  -- 11 args 시도 (WRAPPER 와 동일)
  EXECUTE IMMEDIATE 'BEGIN SCM_MGR.PKG_DMF0072.P_DMF0072_GET_NNMASTER_MAPPING(:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11); END;'
    USING IN 'ALL', IN '81', IN 'ALL', IN 'ALL', IN 'ALL', IN 'ALL', IN 'ALL', IN 'minyonglee1', IN 'DMF0072', OUT v_rc1, OUT v_rc2;
  BEGIN
    LOOP FETCH v_rc1 INTO v_dummy; EXIT WHEN v_rc1%NOTFOUND OR v_cnt >= 5; v_cnt := v_cnt + 1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt := -99; END;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_rc2; EXCEPTION WHEN OTHERS THEN NULL; END;

  DBMS_OUTPUT.PUT_LINE('PKG.proc 11args fetch = ' || v_cnt);
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('PKG.proc 11args ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 400));
END;
/

PROMPT === 판독 ===
PROMPT - DIAG 1: PKG.proc 의 정확 sig
PROMPT - DIAG 2/3: standalone + WRAPPER 의 정확 sig
PROMPT - DIAG 4 WRAPPER fetch=-99 → 정상 / ERR → SQLCODE 노출
PROMPT - DIAG 5 standalone NNMASTER_MAPPING 직접 호출 (PKG 우회)
PROMPT - DIAG 6 PKG.proc 직접 호출 — args 갯수 mismatch 시 PLS-00306
