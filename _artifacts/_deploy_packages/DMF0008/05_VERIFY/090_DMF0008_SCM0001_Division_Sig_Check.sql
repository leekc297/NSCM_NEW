--==============================================================================
-- 090_DMF0008_SCM0001_Division_Sig_Check.sql
--
-- 목적: SCM0001_GET_DIVISION SP 시그니처 + 호출 검증 (DMF0008 division 대체 후보)
-- 작성: 2026-06-05
--==============================================================================
SET LINESIZE 250
SET SERVEROUTPUT ON

PROMPT === DIAG 1 : SCM0001_GET_DIVISION SP 시그니처 ===

SELECT owner, argument_name, position, data_type, in_out
  FROM all_arguments
 WHERE object_name = 'SCM0001_GET_DIVISION'
   AND package_name IS NULL
 ORDER BY owner, position;

PROMPT === DIAG 2 : SCM0001_GET_DIVISION 단독 호출 ===

DECLARE
  v_rc SYS_REFCURSOR;
BEGIN
  -- DIAG 1 결과에 맞춰 named param 호출 (P_USER_ID, P_MENU_ID 가 일반 패턴)
  SCM_MGR.SCM0001_GET_DIVISION(
    P_USER_ID => 'minyonglee1',
    P_MENU_ID => 'DMF0008',
    O_RC1     => v_rc
  );
  DBMS_OUTPUT.PUT_LINE('SCM0001_GET_DIVISION 정상 호출 OK');
  CLOSE v_rc;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 200));
END;
/
