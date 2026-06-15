-- =====================================================================
-- 05_VERIFY.sql
--
-- Phase C: 검증 + silent fallback 복원 (hybrid: RAISE 전 DBMS_OUTPUT 진단 보존)
--
--   C-1. caller test 3 시나리오 + elapsed time
--   C-2. silent fallback 복원 (방어선 유지) — RAISE 후 backtrace 출력 + dummy cursor open hybrid
--
-- 실행: sqlplus scm_mgr/PASS@//localhost:1521/FREEPDB1 @05_VERIFY.sql
-- =====================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 0
SET LONG 100000000
SET LONGCHUNKSIZE 32767
SET FEEDBACK OFF
SET TRIMSPOOL ON
WHENEVER SQLERROR CONTINUE

PROMPT === [C-1.0] SP/helper STATUS 검증 ===
SELECT OBJECT_NAME, STATUS
  FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR'
   AND OBJECT_NAME IN ('DMF0043_GET_CONTRIBUTION_SALES_LIST', 'P_DMF0043_INIT_TITLESET_USER')
 ORDER BY OBJECT_NAME;

PROMPT === [C-1.1] caller test #1: 기본 (division=40, ver_seq=12, million=N, compat=N) ===
DECLARE
  v_rc1 SYS_REFCURSOR; v_rc2 SYS_REFCURSOR; v_rc3 SYS_REFCURSOR;
  v_t0 NUMBER; v_t1 NUMBER;
BEGIN
  v_t0 := DBMS_UTILITY.GET_TIME;
  SCM_MGR.DMF0043_GET_CONTRIBUTION_SALES_LIST(
    '40','12',NULL,'ALL','ALL','ALL','N','N','minyonglee1',
    v_rc1, v_rc2, v_rc3
  );
  v_t1 := DBMS_UTILITY.GET_TIME;
  DBMS_OUTPUT.PUT_LINE('[CALL#1] OK  elapsed = ' || ((v_t1 - v_t0)/100) || 's');
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_rc2; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_rc3; EXCEPTION WHEN OTHERS THEN NULL; END;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('[CALL#1] FAIL ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 500));
  DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === [C-1.2] caller test #2: compat=Y (cnt cursor 분기) ===
DECLARE
  v_rc1 SYS_REFCURSOR; v_rc2 SYS_REFCURSOR; v_rc3 SYS_REFCURSOR;
  v_t0 NUMBER; v_t1 NUMBER;
BEGIN
  v_t0 := DBMS_UTILITY.GET_TIME;
  SCM_MGR.DMF0043_GET_CONTRIBUTION_SALES_LIST(
    '40','12',NULL,'ALL','ALL','ALL','N','Y','minyonglee1',
    v_rc1, v_rc2, v_rc3
  );
  v_t1 := DBMS_UTILITY.GET_TIME;
  DBMS_OUTPUT.PUT_LINE('[CALL#2] OK  elapsed = ' || ((v_t1 - v_t0)/100) || 's');
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_rc2; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_rc3; EXCEPTION WHEN OTHERS THEN NULL; END;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('[CALL#2] FAIL ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 500));
  DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === [C-1.3] caller test #3: million=Y (단위변환 분기) ===
DECLARE
  v_rc1 SYS_REFCURSOR; v_rc2 SYS_REFCURSOR; v_rc3 SYS_REFCURSOR;
  v_t0 NUMBER; v_t1 NUMBER;
BEGIN
  v_t0 := DBMS_UTILITY.GET_TIME;
  SCM_MGR.DMF0043_GET_CONTRIBUTION_SALES_LIST(
    '40','12',NULL,'ALL','ALL','ALL','Y','N','minyonglee1',
    v_rc1, v_rc2, v_rc3
  );
  v_t1 := DBMS_UTILITY.GET_TIME;
  DBMS_OUTPUT.PUT_LINE('[CALL#3] OK  elapsed = ' || ((v_t1 - v_t0)/100) || 's');
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_rc2; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_rc3; EXCEPTION WHEN OTHERS THEN NULL; END;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('[CALL#3] FAIL ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 500));
  DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === [C-1.4] helper SP test ===
DECLARE
  v_before NUMBER; v_after NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_before
    FROM SCM_MST_TITLESET_USER
   WHERE USER_ID='minyonglee1' AND PROGRAM_ID='DMF0043'
     AND SHEET_NAME='ContributeSalesList' AND USER_INQUIRY_COLUMN_TYPE_CODE='C';
  SCM_MGR.P_DMF0043_INIT_TITLESET_USER('minyonglee1', 'DMF0043', 'ContributeSalesList');
  SELECT COUNT(*) INTO v_after
    FROM SCM_MST_TITLESET_USER
   WHERE USER_ID='minyonglee1' AND PROGRAM_ID='DMF0043'
     AND SHEET_NAME='ContributeSalesList' AND USER_INQUIRY_COLUMN_TYPE_CODE='C';
  DBMS_OUTPUT.PUT_LINE('[helper] TITLESET_USER rows: ' || v_before || ' → ' || v_after);
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('[helper] FAIL ' || SQLERRM);
END;
/

PROMPT === [C-2] Silent fallback 복원 (hybrid: RAISE 진단 + dummy cursor 방어선) ===
-- 02_DIAGNOSE.sql 에서 silent fallback 을 RAISE 로 교체했을 가능성. 본 단계에서 hybrid 패턴 복원.
-- 패턴: DBMS_OUTPUT.PUT_LINE 으로 진단 보존 + dummy cursor open (BE 가 empty result 받음)
DECLARE
  v_src       CLOB := EMPTY_CLOB();
  v_patched   CLOB;
  v_changes   NUMBER := 0;

  PROCEDURE apply_revert(
    p_label   IN VARCHAR2,
    p_search  IN VARCHAR2,
    p_replace IN VARCHAR2
  ) IS
    v_pl NUMBER := DBMS_LOB.GETLENGTH(v_patched);
    v_al NUMBER;
  BEGIN
    v_patched := REPLACE(v_patched, p_search, p_replace);
    v_al := DBMS_LOB.GETLENGTH(v_patched);
    IF v_al = v_pl THEN
      DBMS_OUTPUT.PUT_LINE('[SKIP] ' || p_label || ' — 패턴 미발견 (이미 hybrid 상태 또는 원본)');
    ELSE
      v_changes := v_changes + 1;
      DBMS_OUTPUT.PUT_LINE('[OK] ' || p_label);
    END IF;
  END;
BEGIN
  DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
  FOR rec IN (
    SELECT TEXT FROM USER_SOURCE
     WHERE NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST' AND TYPE='PROCEDURE'
     ORDER BY LINE
  ) LOOP
    DBMS_LOB.APPEND(v_src, rec.TEXT);
  END LOOP;
  v_patched := v_src;

  -- Revert 1: DIAGNOSE 의 main cursor RAISE → hybrid
  apply_revert(
    'Revert 1: main cursor RAISE → hybrid (DBMS_OUTPUT + dummy)',
    'DBMS_OUTPUT.PUT_LINE(''[main-cursor-RAISE] ''||SQLERRM||'' / BT=''||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); RAISE;',
    'DBMS_OUTPUT.PUT_LINE(''[main-cursor] ''||SQLERRM||'' / BT=''||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); BEGIN OPEN p_cursor_main FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; EXCEPTION WHEN OTHERS THEN NULL; END;'
  );

  -- Revert 2: DIAGNOSE 의 sort cursor RAISE → hybrid
  apply_revert(
    'Revert 2: sort cursor RAISE → hybrid',
    'DBMS_OUTPUT.PUT_LINE(''[sort-cursor-RAISE] ''||SQLERRM||'' / BT=''||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); RAISE;',
    'DBMS_OUTPUT.PUT_LINE(''[sort-cursor] ''||SQLERRM||'' / BT=''||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); BEGIN OPEN p_cursor_sort FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; EXCEPTION WHEN OTHERS THEN NULL; END;'
  );

  -- Revert 3: DIAGNOSE 의 outer fallback 제거 → 복원
  apply_revert(
    'Revert 3a: outer main 복원',
    '-- [DIAGNOSE] outer fallback main 제거',
    'BEGIN IF NOT p_cursor_main%ISOPEN THEN OPEN p_cursor_main FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;'
  );
  apply_revert(
    'Revert 3b: outer sort 복원',
    '-- [DIAGNOSE] outer fallback sort 제거',
    'BEGIN IF NOT p_cursor_sort%ISOPEN THEN OPEN p_cursor_sort FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;'
  );
  apply_revert(
    'Revert 3c: outer cnt 복원 (RAISE 제거)',
    '-- [DIAGNOSE] outer fallback cnt 제거' || CHR(10) || '    RAISE;',
    'BEGIN IF NOT p_cursor_cnt%ISOPEN  THEN OPEN p_cursor_cnt  FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;'
  );

  DBMS_OUTPUT.PUT_LINE('=== Revert 변경 ' || v_changes || ' 건 ===');

  IF v_changes > 0 THEN
    v_patched := 'CREATE OR REPLACE ' || v_patched;
    EXECUTE IMMEDIATE v_patched;
    DBMS_OUTPUT.PUT_LINE('[OK] SP recompile 완료 — silent fallback hybrid 복원');
  ELSE
    DBMS_OUTPUT.PUT_LINE('[INFO] 변경 없음 — 이미 정상 상태');
  END IF;

  DBMS_LOB.FREETEMPORARY(v_src);
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('[FAIL] revert: ' || SQLERRM);
  DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  IF v_src IS NOT NULL THEN
    BEGIN DBMS_LOB.FREETEMPORARY(v_src); EXCEPTION WHEN OTHERS THEN NULL; END;
  END IF;
END;
/

PROMPT === [C-3] 최종 STATUS 검증 ===
SELECT OBJECT_NAME, STATUS
  FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR'
   AND OBJECT_NAME IN ('DMF0043_GET_CONTRIBUTION_SALES_LIST', 'P_DMF0043_INIT_TITLESET_USER');

SELECT LINE, POSITION, TEXT
  FROM USER_ERRORS
 WHERE NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST' AND TYPE='PROCEDURE'
 ORDER BY SEQUENCE;

PROMPT === VERIFY 완료 ===
PROMPT - SP STATUS=VALID 확인
PROMPT - 3 caller scenario elapsed time 로그 보존
PROMPT - silent fallback hybrid 복원 완료 (운영 안정성 + 진단 가능성)
PROMPT - 다음: FE 화면 진입 수동 검증 (Version 선택 → 조회)
