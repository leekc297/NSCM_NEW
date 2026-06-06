--==============================================================================
-- 220_PKG_DMF0072_Sites_Detail.sql
--
-- 목적:
--   PKG_DMF0072 PACKAGE BODY 의 사고 위치 정밀:
--     - TRUNCATE 1 line
--     - UTL_CALL_STACK.SUBPROGRAM(1)(2) 2 lines
--   각 procedure 의 EXCEPTION handler 도 확인.
--   + DMF0072_GET_NNMASTER_MAPPING_WRAPPER 가 PKG_DMF0072 procedure 호출하는지.
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250

PROMPT === DIAG 1 : PKG_DMF0072 의 TRUNCATE / UTL_CALL_STACK / RAISE 정확 line ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'PKG_DMF0072'
   AND type = 'PACKAGE BODY'
   AND REGEXP_LIKE(text, 'TRUNCATE|UTL_CALL_STACK|RAISE_APPLICATION_ERROR|PROCEDURE\s+\w', 'i')
 ORDER BY line;

PROMPT === DIAG 2 : DMF0072_GET_NNMASTER_MAPPING_WRAPPER 본문 ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0072_GET_NNMASTER_MAPPING_WRAPPER'
   AND type = 'PROCEDURE'
 ORDER BY line;

PROMPT === DIAG 3 : DMF0072_GET_NNMASTER_MAPPING (메인) 본문의 처음 60 line ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0072_GET_NNMASTER_MAPPING'
   AND type = 'PROCEDURE'
   AND line BETWEEN 1 AND 60
 ORDER BY line;

PROMPT === DIAG 4 : DMF0072_GET_NNMASTER_MAPPING 단독 호출 (정확 sig 8 args) ===

DECLARE
  v_cursor SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_dummy VARCHAR2(4000);
BEGIN
  DMF0072_GET_NNMASTER_MAPPING(
    dataTypeCode => 'ALL',
    divisionId   => '81',
    deptId       => 'ALL',
    endCustomer  => 'ALL',
    scmSiteId    => 'ALL',
    projectCode  => 'ALL',
    itemId       => 'ALL',
    p_cursor     => v_cursor
  );
  BEGIN
    LOOP FETCH v_cursor INTO v_dummy; EXIT WHEN v_cursor%NOTFOUND OR v_cnt >= 5; v_cnt := v_cnt + 1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt := -99; END;
  BEGIN CLOSE v_cursor; EXCEPTION WHEN OTHERS THEN NULL; END;

  DBMS_OUTPUT.PUT_LINE('NNMASTER_MAPPING fetch = ' || v_cnt || ' (-99=multi-col 정상)');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('NNMASTER_MAPPING ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 300));
  DBMS_OUTPUT.PUT_LINE('BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === DIAG 5 : DMF0072_GET_NNMASTER_MAPPING_WRAPPER 단독 호출 ===

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_dummy VARCHAR2(4000);
BEGIN
  DMF0072_GET_NNMASTER_MAPPING_WRAPPER(
    dataTypeCode => 'ALL',
    divisionId   => '81',
    deptId       => 'ALL',
    endCustomer  => 'ALL',
    scmSiteId    => 'ALL',
    projectCode  => 'ALL',
    itemId       => 'ALL',
    sesUserId    => 'minyonglee1',
    mnuId        => 'DMF0072',
    o_rc1        => v_rc1
  );
  BEGIN
    LOOP FETCH v_rc1 INTO v_dummy; EXIT WHEN v_rc1%NOTFOUND OR v_cnt >= 5; v_cnt := v_cnt + 1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt := -99; END;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;

  DBMS_OUTPUT.PUT_LINE('WRAPPER fetch = ' || v_cnt || ' (-99=multi-col 정상)');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('WRAPPER ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 300));
  DBMS_OUTPUT.PUT_LINE('BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === 판독 ===
PROMPT - DIAG 1: PKG_DMF0072 의 TRUNCATE/UTL_CALL_STACK 정확 line + 속한 procedure
PROMPT - DIAG 2: WRAPPER 가 PKG_DMF0072 호출하는지
PROMPT - DIAG 3: NNMASTER_MAPPING 메인 SP body 의 시작 부분
PROMPT - DIAG 4/5: 단독 호출 시 ORA 캡쳐 — 진짜 SQLCODE
