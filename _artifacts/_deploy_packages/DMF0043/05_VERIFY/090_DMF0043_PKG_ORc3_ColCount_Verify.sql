--==============================================================================
-- 090_DMF0043_PKG_ORc3_ColCount_Verify.sql
--
-- 목적: PKG.P_DMF0043_GET_MAIN_SPREAD_TITLE 의 OPEN O_RC3 FOR 의 SELECT 컬럼 수 확인
--       → standalone wrapper 적용 시 caller fetch 22-var 와 정합 검증
-- 실행: SCM_MGR 세션
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === DIAG 1 : PKG SPREAD_TITLE 의 OPEN O_RC3 FOR 직후 SELECT 절 (line 338-445) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'PKG_DMF0043'
   AND type = 'PACKAGE BODY'
   AND line BETWEEN 338 AND 446
 ORDER BY line;

PROMPT === DIAG 2 : caller (CONTRIBUTE_MAIN_DATA) 의 FETCH INTO 22-var 영역 확인 ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0043_GET_CONTRIBUTE_MAIN_DATA'
   AND type = 'PROCEDURE'
   AND line BETWEEN 73 AND 130
 ORDER BY line;

PROMPT === DIAG 3 : PKG SPREAD_TITLE 단독 호출 (9 args 정확) → GT_GMST + O_RC3 row count ===

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_rc2 SYS_REFCURSOR;
  v_rc3 SYS_REFCURSOR;
  v_result_rc SYS_REFCURSOR;
  v_gmst_cnt PLS_INTEGER;
  v_gmst2_cnt PLS_INTEGER;
  v_dummy VARCHAR2(100);
  v_rc3_cnt PLS_INTEGER := 0;
BEGIN
  BEGIN DELETE FROM SCM_MGR.GT_GMST_TEMP2_2; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN DELETE FROM SCM_MGR.GT_GMST_TEMP_2;  EXCEPTION WHEN OTHERS THEN NULL; END;

  -- 정확한 9 args 호출
  SCM_MGR.PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE(
    P_DIVISION_ID    => '40',
    P_YYYY           => '2024',
    P_CREATED_BY     => 'minyonglee1',
    P_USER_ID        => 'minyonglee1',
    P_MENU_ID        => 'DMF0043',
    O_RC1            => v_rc1,
    O_RC2            => v_rc2,
    O_RC3            => v_rc3,
    O_RESULT_CURSOR  => v_result_rc
  );
  DBMS_OUTPUT.PUT_LINE('PKG.SPREAD_TITLE 호출 성공');

  -- O_RC3 fetch (column mismatch 예상 — 22 컬럼 cursor 면 -99)
  BEGIN
    LOOP FETCH v_rc3 INTO v_dummy; EXIT WHEN v_rc3%NOTFOUND; v_rc3_cnt := v_rc3_cnt + 1; END LOOP;
  EXCEPTION WHEN OTHERS THEN
    v_rc3_cnt := -99;  -- column mismatch
  END;
  BEGIN CLOSE v_rc3; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_rc2; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_result_rc; EXCEPTION WHEN OTHERS THEN NULL; END;
  DBMS_OUTPUT.PUT_LINE('O_RC3 single-col fetch result = ' || v_rc3_cnt || ' (-99 = column mismatch 정상 — 22+ 컬럼 cursor)');

  -- GT_GMST 적재 row count
  SELECT COUNT(*) INTO v_gmst_cnt FROM SCM_MGR.GT_GMST_TEMP_2;
  SELECT COUNT(*) INTO v_gmst2_cnt FROM SCM_MGR.GT_GMST_TEMP2_2;
  DBMS_OUTPUT.PUT_LINE('GT_GMST_TEMP_2  row = ' || v_gmst_cnt  || ' (예상 9 — OS_CORP RBU_0001~RBU_0008+RBU_0999)');
  DBMS_OUTPUT.PUT_LINE('GT_GMST_TEMP2_2 row = ' || v_gmst2_cnt || ' (예상 117 = 9 OS_CORP × 13 (1Y+12M))');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('DIAG 3 ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM,1,200));
  DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === DIAG 4 : PKG SPREAD_TITLE O_RC3 의 SELECT 컬럼 수 (위 DIAG 1 의 텍스트 분석) ===

PROMPT [수동 분석] DIAG 1 의 line 338-446 SELECT 절에서 컬럼 수 카운트.
PROMPT - caller fetch 변수 22개 (DIAG 2 의 FETCH INTO 22 lines)
PROMPT - PKG O_RC3 SELECT 22 컬럼 → wrapper 작성 가능
PROMPT - PKG O_RC3 SELECT 23 컬럼 (EDIT_YN 포함) → wrapper 안에 컬럼 22 추출 logic 필요
