--==============================================================================
-- 120_DMF0008_Summary_SP_Body_Analyze.sql
--
-- 목적:
--   1. DMF0008_GET_EDI_MST_SUMMARY 가 사용하는 실제 테이블명 (DM_DNM_EDI_SUMMARY 아님)
--   2. v_FROM_YYYYMMDD 자체 계산 logic (p_FROM_YYYYMMDD 안쓰임)
--   3. 정확한 시그니처로 81 호출 → row 수
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === DIAG 1 : EDI SUMMARY 관련 테이블 검색 (실제 이름) ===

SELECT owner, object_name, object_type, status
  FROM all_objects
 WHERE (object_name LIKE '%EDI%SUMMARY%'
     OR object_name LIKE '%DNM_EDI%'
     OR object_name LIKE '%DM_DNM%')
   AND object_type IN ('TABLE', 'VIEW', 'SYNONYM')
 ORDER BY owner, object_name;

PROMPT === DIAG 2 : DMF0008_GET_EDI_MST_SUMMARY 의 FROM 절 (실제 source 테이블) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_SUMMARY'
   AND type = 'PROCEDURE'
   AND (REGEXP_LIKE(text, 'FROM\s+\w', 'i')
     OR REGEXP_LIKE(text, 'v_FROM_YYYYMMDD\s*:?=', 'i')
     OR REGEXP_LIKE(text, 'v_TO_YYYYMMDD\s*:?=', 'i'))
 ORDER BY line;

PROMPT === DIAG 3 : v_FROM_YYYYMMDD 정의 + 사용 영역 (line 90-105 영역) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_SUMMARY'
   AND type = 'PROCEDURE'
   AND line BETWEEN 60 AND 110
 ORDER BY line;

PROMPT === DIAG 4 : DMF0008_GET_EDI_MST_SUMMARY 정확한 시그니처 호출 (8 args) ===

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_rc3 SYS_REFCURSOR;
  v_result_rc SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_dummy VARCHAR2(4000);
BEGIN
  DMF0008_GET_EDI_MST_SUMMARY(
    P_FROM_YYYYMMDD => '20240101',
    P_TO_YYYYMMDD   => '20261231',
    P_DIVISION_ID   => '81',
    P_USER_ID       => 'minyonglee1',
    P_MENU_ID       => 'DMF0008',
    O_RC1           => v_rc1,
    O_RC3           => v_rc3,
    O_RESULT_CURSOR => v_result_rc
  );

  -- O_RC1 row count (single-col fetch — multi-col 이면 -99)
  BEGIN
    LOOP FETCH v_rc1 INTO v_dummy; EXIT WHEN v_rc1%NOTFOUND; v_cnt := v_cnt + 1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt := -99; END;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_rc3; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_result_rc; EXCEPTION WHEN OTHERS THEN NULL; END;

  DBMS_OUTPUT.PUT_LINE('SUMMARY div=81 O_RC1 fetch = ' || v_cnt || ' (-99 = multi-col cursor 정상)');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('SUMMARY div=81 ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 200));
  DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === DIAG 5 : 동일 호출 division=40 비교 (정상 동작 vs 81) ===

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_rc3 SYS_REFCURSOR;
  v_result_rc SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_dummy VARCHAR2(4000);
BEGIN
  DMF0008_GET_EDI_MST_SUMMARY(
    P_FROM_YYYYMMDD => '20240101',
    P_TO_YYYYMMDD   => '20261231',
    P_DIVISION_ID   => '40',
    P_USER_ID       => 'minyonglee1',
    P_MENU_ID       => 'DMF0008',
    O_RC1           => v_rc1,
    O_RC3           => v_rc3,
    O_RESULT_CURSOR => v_result_rc
  );
  BEGIN
    LOOP FETCH v_rc1 INTO v_dummy; EXIT WHEN v_rc1%NOTFOUND; v_cnt := v_cnt + 1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt := -99; END;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_rc3; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_result_rc; EXCEPTION WHEN OTHERS THEN NULL; END;

  DBMS_OUTPUT.PUT_LINE('SUMMARY div=40 O_RC1 fetch = ' || v_cnt);
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('SUMMARY div=40 ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 200));
END;
/

PROMPT === DIAG 6 : SCM_ADM_PROC_M 의 SUMMARY SP 메타 (FE → BE → SP 정합 검증) ===

SELECT proc_nm, col_nm, data_tp_cd, col_tp_cd, sort_ord
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE proc_nm = 'DMF0008_GET_EDI_MST_SUMMARY'
 ORDER BY sort_ord;

PROMPT === 판독 ===
PROMPT - DIAG 1: 실제 테이블명 (예: DM_DNM_EDI_SUMMARY_C 또는 다른) 확인
PROMPT - DIAG 2/3: v_FROM_YYYYMMDD 자체 계산 logic 또는 다른 변수 사용 패턴
PROMPT - DIAG 4: div=81 O_RC1 fetch 0 또는 -99 (정상)
PROMPT - DIAG 5: div=40 row 수와 비교
PROMPT - DIAG 6: PROC_M 가 FE 의 fromYyyymmdd/toYyyymmdd/divisionId 받지만 SP body 가 안 쓰면 useless
