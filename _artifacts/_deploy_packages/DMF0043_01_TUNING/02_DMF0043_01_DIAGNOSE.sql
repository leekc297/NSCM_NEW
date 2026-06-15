-- =====================================================================
-- 02_DMF0043_01_DIAGNOSE.sql
--
-- Phase A 진단: 실 ORA-XXXXX 노출
--
-- 1) 로컬 Docker SCM_MGR 의 DMF0043_GET_CONTRIBUTION_SALES_LIST body 백업 spool
-- 2) silent fallback (OPEN p_cursor_* FOR ... EXCEPTION WHEN OTHERS → DUMMY) 3건 임시 제거
--    - main  (L2720~L2724 block)
--    - sort  (L2725~L2729 block)
--    - outer (L2846~L2852 block)
-- 3) caller test (9 IN — FE ContributeView.tsx + 030_Caller_Test.sql 시그니처)
-- 4) DBMS_OUTPUT 으로 실 SQLERRM + FORMAT_ERROR_BACKTRACE 노출
--
-- 환경: 로컬 Docker (localhost:1521 / FREEPDB1 / scm_mgr)
-- 실행: sqlcl 또는 sqlplus scm_mgr/PASS@//localhost:1521/FREEPDB1 @02_DMF0043_01_DIAGNOSE.sql
--
-- ⚠️ 본 script 는 SP body 를 임시 변경 — 04_BODY_PATCH.sql 또는 C-2 복원 단계
--     에서 백업 파일 (spool 결과) 로 복원 의무.
-- =====================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 0
SET LONG 100000000
SET LONGCHUNKSIZE 32767
SET FEEDBACK OFF
SET TIMING ON
SET TRIMSPOOL ON
WHENEVER SQLERROR CONTINUE

PROMPT === [A-1] SP body 백업 spool ===
COLUMN spool_path NEW_VALUE spool_path NOPRINT
SELECT '/tmp/DMF0043_GET_CONTRIBUTION_SALES_LIST_LOCAL_'
       || TO_CHAR(SYSDATE, 'YYYYMMDD_HH24MISS')
       || '_BACKUP.sql' AS spool_path
  FROM DUAL;

SPOOL &spool_path
PROMPT -- DMF0043_GET_CONTRIBUTION_SALES_LIST body backup (local Docker SCM_MGR)
PROMPT -- 복원: SQL*Plus 또는 sqlcl 로 본 파일 그대로 실행
SELECT 'CREATE OR REPLACE ' AS prefix FROM DUAL;
SELECT TEXT
  FROM USER_SOURCE
 WHERE NAME = 'DMF0043_GET_CONTRIBUTION_SALES_LIST'
   AND TYPE = 'PROCEDURE'
 ORDER BY LINE;
PROMPT /
SPOOL OFF

PROMPT === [A-1.1] body 라인 수 + silent fallback 등장 횟수 ===
SELECT COUNT(*) AS body_lines
  FROM USER_SOURCE
 WHERE NAME = 'DMF0043_GET_CONTRIBUTION_SALES_LIST' AND TYPE = 'PROCEDURE';

SELECT COUNT(*) AS silent_fallback_count
  FROM USER_SOURCE
 WHERE NAME = 'DMF0043_GET_CONTRIBUTION_SALES_LIST'
   AND TYPE = 'PROCEDURE'
   AND UPPER(TEXT) LIKE '%OPEN%FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0%';

PROMPT === [A-2] silent fallback 임시 제거 (RAISE 로 교체) ===
DECLARE
  v_src     CLOB := EMPTY_CLOB();
  v_patched CLOB;
  v_prev_len NUMBER;
  v_after_len NUMBER;
  v_changes NUMBER := 0;
BEGIN
  DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
  FOR rec IN (
    SELECT TEXT FROM USER_SOURCE
     WHERE NAME = 'DMF0043_GET_CONTRIBUTION_SALES_LIST' AND TYPE = 'PROCEDURE'
     ORDER BY LINE
  ) LOOP
    DBMS_LOB.APPEND(v_src, rec.TEXT);
  END LOOP;
  v_patched := v_src;

  -- Patch 1: main cursor silent fallback → RAISE
  --   원본: '    EXCEPTION WHEN OTHERS THEN' + '      BEGIN OPEN p_cursor_main FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; EXCEPTION WHEN OTHERS THEN NULL; END;'
  --   교체: '    EXCEPTION WHEN OTHERS THEN' + '      DBMS_OUTPUT.PUT_LINE(''[main-cursor] ''||SQLERRM||'' / BT=''||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); RAISE;'
  v_prev_len := DBMS_LOB.GETLENGTH(v_patched);
  v_patched := REPLACE(v_patched,
    'BEGIN OPEN p_cursor_main FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; EXCEPTION WHEN OTHERS THEN NULL; END;',
    'DBMS_OUTPUT.PUT_LINE(''[main-cursor-RAISE] ''||SQLERRM||'' / BT=''||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); RAISE;');
  v_after_len := DBMS_LOB.GETLENGTH(v_patched);
  IF v_after_len = v_prev_len THEN
    DBMS_OUTPUT.PUT_LINE('[WARN] Patch 1 (main cursor fallback) — 패턴 미발견 (이미 제거되었거나 다른 형태)');
  ELSE
    v_changes := v_changes + 1;
    DBMS_OUTPUT.PUT_LINE('[OK] Patch 1 — main cursor fallback 제거');
  END IF;

  -- Patch 2: sort cursor silent fallback → RAISE
  v_prev_len := DBMS_LOB.GETLENGTH(v_patched);
  v_patched := REPLACE(v_patched,
    'BEGIN OPEN p_cursor_sort FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; EXCEPTION WHEN OTHERS THEN NULL; END;',
    'DBMS_OUTPUT.PUT_LINE(''[sort-cursor-RAISE] ''||SQLERRM||'' / BT=''||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); RAISE;');
  v_after_len := DBMS_LOB.GETLENGTH(v_patched);
  IF v_after_len = v_prev_len THEN
    DBMS_OUTPUT.PUT_LINE('[WARN] Patch 2 (sort cursor fallback) — 패턴 미발견');
  ELSE
    v_changes := v_changes + 1;
    DBMS_OUTPUT.PUT_LINE('[OK] Patch 2 — sort cursor fallback 제거');
  END IF;

  -- Patch 3: outer EXCEPTION WHEN OTHERS — 이미 SQLERRM 출력 있음. RAISE 추가
  -- 원본:
  --   EXCEPTION
  --     WHEN OTHERS THEN
  --       DBMS_OUTPUT.PUT_LINE('[outer] ' || SQLERRM || ' / BT=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --       BEGIN IF NOT p_cursor_main%ISOPEN THEN OPEN p_cursor_main FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
  --       BEGIN IF NOT p_cursor_sort%ISOPEN THEN OPEN p_cursor_sort FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
  --       BEGIN IF NOT p_cursor_cnt%ISOPEN  THEN OPEN p_cursor_cnt  FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
  --   END;
  -- 교체: RAISE 추가 (3 dummy open 제거 → caller 가 SQLERRM 받음)
  v_prev_len := DBMS_LOB.GETLENGTH(v_patched);
  v_patched := REPLACE(v_patched,
    'BEGIN IF NOT p_cursor_main%ISOPEN THEN OPEN p_cursor_main FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;',
    '-- [DIAGNOSE] outer fallback main 제거');
  v_patched := REPLACE(v_patched,
    'BEGIN IF NOT p_cursor_sort%ISOPEN THEN OPEN p_cursor_sort FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;',
    '-- [DIAGNOSE] outer fallback sort 제거');
  v_patched := REPLACE(v_patched,
    'BEGIN IF NOT p_cursor_cnt%ISOPEN  THEN OPEN p_cursor_cnt  FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;',
    '-- [DIAGNOSE] outer fallback cnt 제거' || CHR(10) || '    RAISE;');
  v_after_len := DBMS_LOB.GETLENGTH(v_patched);
  IF v_after_len = v_prev_len THEN
    DBMS_OUTPUT.PUT_LINE('[WARN] Patch 3 (outer fallback) — 패턴 미발견');
  ELSE
    v_changes := v_changes + 1;
    DBMS_OUTPUT.PUT_LINE('[OK] Patch 3 — outer fallback + RAISE 처리');
  END IF;

  DBMS_OUTPUT.PUT_LINE('=== 총 변경 ' || v_changes || ' 건 ===');
  IF v_changes = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] silent fallback 패턴 0건 — 이미 제거되었거나 cloud 와 다른 body');
    DBMS_OUTPUT.PUT_LINE('[INFO] caller test 만 진행하여 ORA 확인');
  ELSE
    -- USER_SOURCE 의 첫 줄은 "PROCEDURE name (...)" — CREATE OR REPLACE prefix 필요
    v_patched := 'CREATE OR REPLACE ' || v_patched;
    EXECUTE IMMEDIATE v_patched;
    DBMS_OUTPUT.PUT_LINE('[OK] SP recompile 완료');
  END IF;

  DBMS_LOB.FREETEMPORARY(v_src);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('[FAIL] Patch 실행 오류: ' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    IF v_src IS NOT NULL THEN
      BEGIN DBMS_LOB.FREETEMPORARY(v_src); EXCEPTION WHEN OTHERS THEN NULL; END;
    END IF;
END;
/

PROMPT === [A-2.1] SP STATUS 검증 ===
SELECT OBJECT_NAME, STATUS
  FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR' AND OBJECT_NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST';

PROMPT === [A-3] Caller test (9 IN — FE payload 매칭) ===
-- division=40, ver_seq=12 (자매 030_Caller_Test 와 동일 시나리오), 나머지 ALL/N
DECLARE
  v_cursor_main SYS_REFCURSOR;
  v_cursor_sort SYS_REFCURSOR;
  v_cursor_cnt  SYS_REFCURSOR;
  v_t0 NUMBER;
  v_t1 NUMBER;
BEGIN
  v_t0 := DBMS_UTILITY.GET_TIME;
  SCM_MGR.DMF0043_GET_CONTRIBUTION_SALES_LIST(
    p_division_id      => '40',
    p_ver_seq          => '12',
    p_version_no       => NULL,
    p_end_cust_report  => 'ALL',
    p_product_group    => 'ALL',
    p_biz_type         => 'ALL',
    p_million_yn       => 'N',
    p_compatibility_yn => 'N',
    p_created_by       => 'minyonglee1',
    p_cursor_main      => v_cursor_main,
    p_cursor_sort      => v_cursor_sort,
    p_cursor_cnt       => v_cursor_cnt
  );
  v_t1 := DBMS_UTILITY.GET_TIME;
  DBMS_OUTPUT.PUT_LINE('[CALLER] OK — elapsed = ' || ((v_t1 - v_t0)/100) || 's');
  BEGIN CLOSE v_cursor_main; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_cursor_sort; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_cursor_cnt;  EXCEPTION WHEN OTHERS THEN NULL; END;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('============================================');
    DBMS_OUTPUT.PUT_LINE('[CALLER] FAIL SQLCODE = ' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE('[CALLER] FAIL SQLERRM = ' || SUBSTR(SQLERRM, 1, 4000));
    DBMS_OUTPUT.PUT_LINE('[CALLER] BACKTRACE = ');
    DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    DBMS_OUTPUT.PUT_LINE('============================================');
END;
/

PROMPT === [A-3.1] 추가 시나리오: million_yn=Y, compatibility_yn=Y (다른 분기 검증) ===
DECLARE
  v_cursor_main SYS_REFCURSOR;
  v_cursor_sort SYS_REFCURSOR;
  v_cursor_cnt  SYS_REFCURSOR;
BEGIN
  SCM_MGR.DMF0043_GET_CONTRIBUTION_SALES_LIST(
    '40','12',NULL,'ALL','ALL','ALL','Y','Y','minyonglee1',
    v_cursor_main, v_cursor_sort, v_cursor_cnt
  );
  DBMS_OUTPUT.PUT_LINE('[CALLER-VARIANT] OK');
  BEGIN CLOSE v_cursor_main; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_cursor_sort; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_cursor_cnt;  EXCEPTION WHEN OTHERS THEN NULL; END;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('[CALLER-VARIANT] FAIL ' || SQLCODE || ' / ' || SUBSTR(SQLERRM,1,500));
    DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === [A-3.2] USER_ERRORS 확인 (recompile 후 invalid 시 컴파일 오류 dump) ===
SELECT LINE, POSITION, TEXT
  FROM USER_ERRORS
 WHERE NAME = 'DMF0043_GET_CONTRIBUTION_SALES_LIST' AND TYPE = 'PROCEDURE'
 ORDER BY SEQUENCE;

PROMPT === [A-3.3] 의존 객체 STATUS ===
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS
  FROM USER_OBJECTS
 WHERE OBJECT_NAME IN (
   'UF_FX_STRING_SPLIT', 'FN_SCM_GET_WHERE_SQL', 'FN_SCM_STRING_SPLIT',
   'GT_DMF0043_SALES_LIST_C', 'GT_DMF0043_TITLE', 'GT_DMF0043_TEMP',
   'DM_MST_ITEM_SINGLE_V', 'DM_MST_CONTRIBUTE_RATIO_MST', 'DM_MST_CONTRIBUTE_RATIO_DTL',
   'SCM_MST_SITE_ITEM', 'SCM_MST_SITE', 'SCM_MST_SHEET_COLUMNS', 'SCM_MST_TITLESET_USER',
   'SCM_MST_SSO_USER_INFO', 'SCM_MST_SSO_DEPT_INFO',
   'SCM_ADM_LOOKUP_MASTER_DETAIL'
 )
 ORDER BY OBJECT_TYPE, OBJECT_NAME;

PROMPT === [A-3.4] SCM_MST_TITLESET_USER 데이터 확인 (FIX 3 helper 필요성) ===
SELECT COUNT(*) AS titleset_rows_for_user
  FROM SCM_MST_TITLESET_USER
 WHERE USER_ID = 'minyonglee1'
   AND PROGRAM_ID = 'DMF0043'
   AND SHEET_NAME = 'ContributeSalesList'
   AND USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

PROMPT === [A-3.5] SCM_MST_SHEET_COLUMNS DEFAULT_FLAG='Y' 인벤토리 ===
SELECT COUNT(*) AS default_y_columns
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0043'
   AND SHEET_NAME = 'ContributeSalesList'
   AND DEFAULT_FLAG = 'Y'
   AND VALID_YN = 'Y';

PROMPT === DIAGNOSE 완료 ===
PROMPT - body 백업: &spool_path
PROMPT - 다음 단계: 백업 파일 확인 후 04_BODY_PATCH.sql 작성
PROMPT - 또는 Phase C-2 복원 시 백업 파일 그대로 실행
