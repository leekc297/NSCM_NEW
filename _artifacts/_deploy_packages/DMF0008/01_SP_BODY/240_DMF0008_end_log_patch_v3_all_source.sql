--==============================================================================
-- 240_DMF0008_end_log_patch_v3_all_source.sql
--
-- 230 의 DBMS_METADATA bug (LPX-00210/ORA-01001) 회피 — ALL_SOURCE 사용
-- =============================================================================
-- 작성: 2026-06-17 (230 LPX-00210 사고 — 사내 Oracle DBMS_METADATA stylesheet 손상)
--
-- 230 사고:
--   META:22:58:15.382: bad stylesheet: kuaudobj
--   LPX-00210: expected '<' instead of '?'
--   ORA-01001: 커서가 부적합합니다
--   → 메모리 `db-schema-divergence-check.md` 에 등재된 사내 Oracle bug
--
-- 240 전략:
--   DBMS_METADATA.GET_DDL 우회 → ALL_SOURCE 에서 SP body line 별 추출 + 재조립.
--   'CREATE OR REPLACE ' prefix + ALL_SOURCE 의 모든 line 순차 concat → CLOB.
--   anchor splice → EXECUTE IMMEDIATE.
--==============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET LINESIZE 200

PROMPT === STEP 1 : 적용 전 SP 상태 ===

SELECT object_name, status, TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner='SCM_MGR' AND object_name='PR_DM_DNM_EDI_CALLOFF_STATUS' AND object_type='PROCEDURE';

PROMPT === STEP 2 : ALL_SOURCE 재조립 patch ===

DECLARE
  v_body    CLOB;
  v_new_body CLOB;
  v_anchor  VARCHAR2(80);
  v_insert  VARCHAR2(800);
  v_pos     PLS_INTEGER;
  v_prefix  VARCHAR2(20) := 'CREATE OR REPLACE ';
BEGIN
  -- 1) END 로그 5줄
  v_insert :=
    '    -- 종료 LOG (정상 경로) - 2026-06-17 fix' || CHR(10) ||
    '    V_LOG_TYPE := ''END'';' || CHR(10) ||
    '    V_LOG_MESSAGE := ''########## END of procedure ##########'';' || CHR(10) ||
    '    D_EVENT_DATE := SYSTIMESTAMP;' || CHR(10) ||
    '    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);' || CHR(10) || CHR(10) || '    ';

  -- 2) ALL_SOURCE 에서 SP body 재조립
  DBMS_LOB.CREATETEMPORARY(v_body, TRUE);
  DBMS_LOB.WRITEAPPEND(v_body, LENGTH(v_prefix), v_prefix);

  FOR r IN (
    SELECT text FROM all_source
     WHERE owner='SCM_MGR'
       AND name='PR_DM_DNM_EDI_CALLOFF_STATUS'
       AND type='PROCEDURE'
     ORDER BY line
  ) LOOP
    DBMS_LOB.WRITEAPPEND(v_body, LENGTH(r.text), r.text);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('[INFO] SP body 재조립 완료, 길이=' || DBMS_LOB.GETLENGTH(v_body));

  -- 3) anchor 위치 (들여쓰기 8 → 4 → 0 fallback)
  v_anchor := 'EXCEPTION' || CHR(10) || '        WHEN OTHERS THEN';
  v_pos := DBMS_LOB.INSTR(v_body, v_anchor);
  IF v_pos = 0 THEN
    v_anchor := 'EXCEPTION' || CHR(10) || '    WHEN OTHERS THEN';
    v_pos := DBMS_LOB.INSTR(v_body, v_anchor);
  END IF;
  IF v_pos = 0 THEN
    v_anchor := 'EXCEPTION' || CHR(10) || 'WHEN OTHERS THEN';
    v_pos := DBMS_LOB.INSTR(v_body, v_anchor);
  END IF;
  -- ALL_SOURCE 가 CHR(13)+CHR(10) (CRLF) 일 수도
  IF v_pos = 0 THEN
    v_anchor := 'EXCEPTION' || CHR(13) || CHR(10) || '        WHEN OTHERS THEN';
    v_pos := DBMS_LOB.INSTR(v_body, v_anchor);
  END IF;
  IF v_pos = 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'anchor 패턴 미발견');
  END IF;

  DBMS_OUTPUT.PUT_LINE('[INFO] anchor 위치=' || v_pos);

  -- 4) splice
  DBMS_LOB.CREATETEMPORARY(v_new_body, TRUE);
  DBMS_LOB.APPEND(v_new_body, DBMS_LOB.SUBSTR(v_body, v_pos - 1, 1));
  DBMS_LOB.WRITEAPPEND(v_new_body, LENGTH(v_insert), v_insert);
  DBMS_LOB.APPEND(v_new_body, DBMS_LOB.SUBSTR(v_body, DBMS_LOB.GETLENGTH(v_body) - v_pos + 1, v_pos));

  DBMS_OUTPUT.PUT_LINE('[INFO] 새 body 길이=' || DBMS_LOB.GETLENGTH(v_new_body));

  -- 5) EXECUTE IMMEDIATE
  EXECUTE IMMEDIATE v_new_body;

  DBMS_OUTPUT.PUT_LINE('[OK] SP 재컴파일 완료');

  DBMS_LOB.FREETEMPORARY(v_body);
  DBMS_LOB.FREETEMPORARY(v_new_body);
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

PROMPT === 240_DMF0008_end_log_patch_v3_all_source.sql 완료 ===

--==============================================================================
-- 적용 후:
--   STEP 3 : LAST_DDL 갱신 + STATUS=VALID
--   STEP 4 : V_LOG_TYPE='END' 2 row (신규 정상 경로 + 기존 EXCEPTION 안)
--   STEP 5 : [SUCCESS] DIFF=1
--   STEP 6 : END LAST_DT = 2026-06-17 (오늘)
--   브라우저 새로고침 → DMF0008 → Status Update 클릭 → Last Update End Date 변경
--==============================================================================
