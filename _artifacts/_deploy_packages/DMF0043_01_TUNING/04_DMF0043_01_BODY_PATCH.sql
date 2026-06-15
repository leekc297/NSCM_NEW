-- =====================================================================
-- 04_DMF0043_01_BODY_PATCH.sql
--
-- Phase B-2: SP body 변경 (3 REPLACE — 모두 unique pattern 확인 완료)
--
--   REPLACE 1: TEAM.USER_ID IN (TABLE(UF_FX_STRING_SPLIT(I.OWNER, ','))) → SUBSTR/INSTR 단일 비교
--   REPLACE 2: TEAM.USER_ID IN (TABLE(UF_FX_STRING_SPLIT(A.OWNER, ','))) → SUBSTR/INSTR 단일 비교
--   REPLACE 3: AND LIST.PRODUCT_GROUP = RATIO.PRODUCT_GROUP → 주석 (Oracle 마이그레이션 SCM_MST_SITE_ITEM.REPORT_GROUP3 제거 정합)
--
-- ⚠️ 각 REPLACE 후 v_changed > 0 검증. 0 이면 RAISE (silent fail 차단).
-- ⚠️ 적용 전 자동 백업 spool: _diagnostics/..._BEFORE_BODYPATCH_<ts>.sql
-- ⚠️ 02_DIAGNOSE.sql 의 silent fallback 제거가 본 patch 보다 먼저 들어가 있을 수 있으므로
--    REPLACE 패턴이 원본 또는 diagnose-patched body 둘 다에서 unique 함을 확인 후 진행.
--
-- 실행: sqlplus scm_mgr/PASS@//localhost:1521/FREEPDB1 @04_DMF0043_01_BODY_PATCH.sql
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

PROMPT === [B-2.0] 백업 spool ===
COLUMN backup_path NEW_VALUE backup_path NOPRINT
SELECT '/tmp/DMF0043_GET_CONTRIBUTION_SALES_LIST_'
       || TO_CHAR(SYSDATE, 'YYYYMMDD_HH24MISS')
       || '_BEFORE_BODYPATCH.sql' AS backup_path
  FROM DUAL;

SPOOL &backup_path
PROMPT -- DMF0043_GET_CONTRIBUTION_SALES_LIST body before BODY_PATCH
SELECT 'CREATE OR REPLACE ' FROM DUAL;
SELECT TEXT FROM USER_SOURCE
 WHERE NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST' AND TYPE='PROCEDURE'
 ORDER BY LINE;
PROMPT /
SPOOL OFF

PROMPT === [B-2.1] REPLACE 3건 적용 (각 v_changed 검증) ===
DECLARE
  v_src        CLOB := EMPTY_CLOB();
  v_patched    CLOB;
  v_prev_len   NUMBER;
  v_after_len  NUMBER;
  v_total      NUMBER := 0;

  PROCEDURE apply_patch(
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
      RAISE_APPLICATION_ERROR(-20001, '[FAIL] ' || p_label || ' — 패턴 미발견 (silent fail 방지)');
    ELSE
      v_total := v_total + 1;
      DBMS_OUTPUT.PUT_LINE('[OK] ' || p_label || ' (size ' || v_pl || ' → ' || v_al || ')');
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

  -- REPLACE 1: TEAM.USER_ID IN (UF_FX_STRING_SPLIT(I.OWNER, ',') first token)
  --   → SUBSTR/INSTR 단일 비교 (TABLE 함수 호출 제거)
  apply_patch(
    'REPLACE 1: UF_FX_STRING_SPLIT(I.OWNER, '','') first-token → SUBSTR/INSTR',
    'TEAM.USER_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(I.OWNER, '','')) WHERE ROWNUM <= 1)',
    'TEAM.USER_ID = SUBSTR(I.OWNER, 1, INSTR(I.OWNER || '','', '','') - 1)'
  );

  -- REPLACE 2: TEAM.USER_ID IN (UF_FX_STRING_SPLIT(A.OWNER, ',') first token)
  apply_patch(
    'REPLACE 2: UF_FX_STRING_SPLIT(A.OWNER, '','') first-token → SUBSTR/INSTR',
    'TEAM.USER_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(A.OWNER, '','')) WHERE ROWNUM <= 1)',
    'TEAM.USER_ID = SUBSTR(A.OWNER, 1, INSTR(A.OWNER || '','', '','') - 1)'
  );

  -- REPLACE 3: LIST.PRODUCT_GROUP = RATIO.PRODUCT_GROUP → 주석화
  --   LIST.PRODUCT_GROUP = '' AS PRODUCT_GROUP (L2740) 상수. RATIO.PRODUCT_GROUP 와 의미 없는 JOIN
  --   동일 패턴 L747 이 이미 주석 처리됨 (SCM_MST_SITE_ITEM.REPORT_GROUP3 제거 정합)
  apply_patch(
    'REPLACE 3: LIST.PRODUCT_GROUP = RATIO.PRODUCT_GROUP 주석화',
    'AND LIST.PRODUCT_GROUP = RATIO.PRODUCT_GROUP',
    '-- AND LIST.PRODUCT_GROUP = RATIO.PRODUCT_GROUP -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP3 제거 (Oracle 마이그레이션 2026.06.09)'
  );

  DBMS_OUTPUT.PUT_LINE('=== 총 변경 ' || v_total || ' / 3 건 ===');

  IF v_total <> 3 THEN
    RAISE_APPLICATION_ERROR(-20002, '[FAIL] 변경 카운트 mismatch — patch 중단');
  END IF;

  -- USER_SOURCE 의 첫 줄은 "PROCEDURE name(...)" — CREATE OR REPLACE prefix 필요
  v_patched := 'CREATE OR REPLACE ' || v_patched;
  EXECUTE IMMEDIATE v_patched;
  DBMS_OUTPUT.PUT_LINE('[OK] SP recompile 완료');

  DBMS_LOB.FREETEMPORARY(v_src);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('[FAIL] ' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    IF v_src IS NOT NULL THEN
      BEGIN DBMS_LOB.FREETEMPORARY(v_src); EXCEPTION WHEN OTHERS THEN NULL; END;
    END IF;
    RAISE;
END;
/

PROMPT === [B-2.2] STATUS 검증 ===
SELECT OBJECT_NAME, STATUS
  FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR' AND OBJECT_NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST';

SELECT LINE, POSITION, TEXT
  FROM USER_ERRORS
 WHERE NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST' AND TYPE='PROCEDURE'
 ORDER BY SEQUENCE;

PROMPT === [B-2.3] 적용 후 grep 검증 ===
-- 기대: UF_FX_STRING_SPLIT(I.OWNER / A.OWNER) 0건 + LIST.PRODUCT_GROUP = RATIO.PRODUCT_GROUP 0건
SELECT 'I.OWNER pattern' AS chk, COUNT(*) AS hits
  FROM USER_SOURCE
 WHERE NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST'
   AND TEXT LIKE '%UF_FX_STRING_SPLIT(I.OWNER%';

SELECT 'A.OWNER pattern' AS chk, COUNT(*) AS hits
  FROM USER_SOURCE
 WHERE NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST'
   AND TEXT LIKE '%UF_FX_STRING_SPLIT(A.OWNER%';

SELECT 'LIST.PRODUCT_GROUP active' AS chk, COUNT(*) AS hits
  FROM USER_SOURCE
 WHERE NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST'
   AND TEXT LIKE '%AND LIST.PRODUCT_GROUP = RATIO.PRODUCT_GROUP%'
   AND TEXT NOT LIKE '%--%LIST.PRODUCT_GROUP%';

PROMPT === BODY_PATCH 완료 ===
PROMPT - 백업: &backup_path
PROMPT - 다음: 05_VERIFY.sql (caller test + elapsed)
