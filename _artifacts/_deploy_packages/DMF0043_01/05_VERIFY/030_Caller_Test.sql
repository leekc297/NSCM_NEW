--==============================================================================
-- 030_Caller_Test.sql (DMF0043_01)
--
-- 목적: DMF0043_01 의 핵심 caller (DMF0043_GET_CONTRIBUTION_SALES_LIST) 호출 검증
--       DMF0043 선적용 후 본 SP 정상 동작 확인
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET TIMING ON

PROMPT === BLOCK 1 : SALES_LIST caller 실행 ===

DECLARE
  v_cursor_main SYS_REFCURSOR;
  v_cursor_sort SYS_REFCURSOR;
  v_cursor_cnt  SYS_REFCURSOR;
  v_start TIMESTAMP := SYSTIMESTAMP;
BEGIN
  BEGIN DELETE FROM SCM_MGR.GT_DMF0043_TITLE; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN DELETE FROM SCM_MGR.GT_DMF0043_TEMP;  EXCEPTION WHEN OTHERS THEN NULL; END;

  DMF0043_GET_CONTRIBUTION_SALES_LIST(
    p_division_id      => '40',
    p_ver_seq          => '12',
    p_version_no       => NULL,
    p_end_cust_report  => 'ALL',
    p_product_group    => 'ALL',
    p_biz_type         => 'ALL',
    p_million_yn       => 'N',
    p_compatibility_yn => 'N',
    p_created_by       => 'minyonglee1'
    -- 필요 시 OUT cursor 파라미터 추가
  );

  DBMS_OUTPUT.PUT_LINE('Caller 정상 종료');
  DBMS_OUTPUT.PUT_LINE('Elapsed = ' || EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start)) || 's');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('Caller ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 200));
  DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === BLOCK 2 : titleSet popup test ===

DECLARE
  v_rc SYS_REFCURSOR;
BEGIN
  DMF0002_GET_TITLESET_POPUP(
    p_user_id   => 'minyonglee1',
    p_program_id => 'DMF0043_01',
    p_sheet_name => 'main',
    O_RC1 => v_rc
  );
  DBMS_OUTPUT.PUT_LINE('TitleSet popup 정상 OPEN');
  CLOSE v_rc;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('TitleSet ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 200));
END;
/
