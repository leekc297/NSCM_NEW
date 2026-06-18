--==============================================================================
-- 230_DMF0008_end_log_patch_v2.sql
--
-- 220 의 DBMS_SQL.PARSE 시그니처 오류 (PLS-00306) 수정판
-- =============================================================================
-- 작성: 2026-06-17 (220 PLS-00306 fix)
--
-- 220 오류:
--   DBMS_SQL.PARSE(v_cursor, v_new_ddl, 1, DBMS_LOB.GETLENGTH(v_new_ddl), TRUE, DBMS_SQL.NATIVE)
--   → 6 인자는 VARCHAR2A/S 시그니처. CLOB 은 3 인자 시그니처: (c, clob, language_flag).
--
-- 230 fix:
--   EXECUTE IMMEDIATE v_new_ddl 사용 (Oracle 11g+ 에서 CLOB 지원).
--   DBMS_SQL 보다 단순 + 안전.
--==============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET LINESIZE 200

PROMPT === STEP 1 : 적용 전 SP 상태 ===

SELECT object_name, status, TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner='SCM_MGR' AND object_name='PR_DM_DNM_EDI_CALLOFF_STATUS' AND object_type='PROCEDURE';

PROMPT === STEP 2 : 자동 patch — EXECUTE IMMEDIATE CLOB ===

DECLARE
  v_ddl     CLOB;
  v_new_ddl CLOB;
  v_anchor  VARCHAR2(80) := 'EXCEPTION' || CHR(10) || '        WHEN OTHERS THEN';
  v_insert  VARCHAR2(800);
  v_pos     PLS_INTEGER;
BEGIN
  -- 1) END 로그 5줄 (anchor 직전 삽입)
  v_insert :=
    '    -- 종료 LOG (정상 경로) - 2026-06-17 fix' || CHR(10) ||
    '    V_LOG_TYPE := ''END'';' || CHR(10) ||
    '    V_LOG_MESSAGE := ''########## END of procedure ##########'';' || CHR(10) ||
    '    D_EVENT_DATE := SYSTIMESTAMP;' || CHR(10) ||
    '    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);' || CHR(10) || CHR(10) || '    ';

  -- 2) 현 DDL 추출
  v_ddl := DBMS_METADATA.GET_DDL('PROCEDURE', 'PR_DM_DNM_EDI_CALLOFF_STATUS', 'SCM_MGR');

  -- 3) anchor 위치 찾기 (들여쓰기 8)
  v_pos := DBMS_LOB.INSTR(v_ddl, v_anchor);
  IF v_pos = 0 THEN
    -- 들여쓰기 4
    v_anchor := 'EXCEPTION' || CHR(10) || '    WHEN OTHERS THEN';
    v_pos := DBMS_LOB.INSTR(v_ddl, v_anchor);
  END IF;
  IF v_pos = 0 THEN
    -- 들여쓰기 없음
    v_anchor := 'EXCEPTION' || CHR(10) || 'WHEN OTHERS THEN';
    v_pos := DBMS_LOB.INSTR(v_ddl, v_anchor);
  END IF;

  IF v_pos = 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'anchor 패턴 미발견');
  END IF;

  DBMS_OUTPUT.PUT_LINE('[INFO] anchor 위치=' || v_pos || ', DDL 길이=' || DBMS_LOB.GETLENGTH(v_ddl));

  -- 4) 새 DDL = (anchor 직전까지) + (v_insert) + (anchor 부터 끝까지)
  DBMS_LOB.CREATETEMPORARY(v_new_ddl, TRUE);
  DBMS_LOB.APPEND(v_new_ddl, DBMS_LOB.SUBSTR(v_ddl, v_pos - 1, 1));
  DBMS_LOB.WRITEAPPEND(v_new_ddl, LENGTH(v_insert), v_insert);
  DBMS_LOB.APPEND(v_new_ddl, DBMS_LOB.SUBSTR(v_ddl, DBMS_LOB.GETLENGTH(v_ddl) - v_pos + 1, v_pos));

  DBMS_OUTPUT.PUT_LINE('[INFO] 새 DDL 길이=' || DBMS_LOB.GETLENGTH(v_new_ddl));

  -- 5) EXECUTE IMMEDIATE — CLOB 직접 실행 (Oracle 11g+)
  EXECUTE IMMEDIATE v_new_ddl;

  DBMS_OUTPUT.PUT_LINE('[OK] SP 재컴파일 완료');

  DBMS_LOB.FREETEMPORARY(v_new_ddl);
END;
/

PROMPT === STEP 3 : 적용 후 SP 상태 (VALID 기대) ===

SELECT object_name, status, TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner='SCM_MGR' AND object_name='PR_DM_DNM_EDI_CALLOFF_STATUS' AND object_type='PROCEDURE';

PROMPT === STEP 4 : V_LOG_TYPE := 'END' 라인 (2 row 기대) ===

SELECT line, SUBSTR(text, 1, 100) AS txt
  FROM all_source
 WHERE owner='SCM_MGR' AND name='PR_DM_DNM_EDI_CALLOFF_STATUS'
   AND UPPER(text) LIKE '%V_LOG_TYPE%''END''%'
 ORDER BY line;

PROMPT === STEP 5 : 실 호출 — END+1 검증 ===

DECLARE
  v_pre_end  PLS_INTEGER;
  v_post_end PLS_INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_pre_end FROM SCM_MGR.SCM_SYS_LOG_BATCH
   WHERE PROGRAM_NAME='PR_DM_DNM_EDI_CALLOFF_STATUS' AND LOG_TYPE='END';

  SCM_MGR.PR_DM_DNM_EDI_CALLOFF_STATUS;
  COMMIT;

  SELECT COUNT(*) INTO v_post_end FROM SCM_MGR.SCM_SYS_LOG_BATCH
   WHERE PROGRAM_NAME='PR_DM_DNM_EDI_CALLOFF_STATUS' AND LOG_TYPE='END';

  DBMS_OUTPUT.PUT_LINE('END LOG : PRE=' || v_pre_end || ' POST=' || v_post_end ||
                       ' DIFF=' || (v_post_end - v_pre_end));
  IF v_post_end - v_pre_end >= 1 THEN
    DBMS_OUTPUT.PUT_LINE('[SUCCESS] END 로그 정상 INSERT — fix 완료');
  ELSE
    DBMS_OUTPUT.PUT_LINE('[FAIL] END+0');
  END IF;
END;
/

PROMPT === STEP 6 : SCM_SYS_LOG_BATCH 최신 row ===

SELECT LOG_TYPE, COUNT(*) AS CNT,
       TO_CHAR(MAX(LAST_UPDATE_DATE), 'YYYY-MM-DD HH24:MI:SS') AS LAST_DT
  FROM SCM_MGR.SCM_SYS_LOG_BATCH
 WHERE PROGRAM_NAME='PR_DM_DNM_EDI_CALLOFF_STATUS'
 GROUP BY LOG_TYPE
 ORDER BY LOG_TYPE;

PROMPT === 230_DMF0008_end_log_patch_v2.sql 완료 ===
