--==============================================================================
-- 220_DMF0008_status_update_end_log_auto_patch.sql
--
-- PR_DM_DNM_EDI_CALLOFF_STATUS — END 로그 자동 patch (수동 편집 불필요)
-- =============================================================================
-- 작성: 2026-06-17 (200 진단 + L500-540 라인 분석 결과 → 자동 splice patch)
--
-- 알고리즘:
--   1) DBMS_METADATA.GET_DDL 로 현 SP DDL 추출 (CLOB)
--   2) anchor 패턴 'EXCEPTION' + CHR(10) + '        WHEN OTHERS THEN' 직전 찾기
--   3) 그 위치에 END 로그 5줄 삽입
--   4) DBMS_SQL.PARSE 로 CLOB 채로 CREATE OR REPLACE 실행 (Oracle 12+)
--
-- 안전성:
--   - DBMS_LOB 으로 CLOB 처리 (32KB 이상 SP body 안전)
--   - anchor 미발견 시 ROLLBACK + RAISE (적용 안 됨)
--   - 적용 후 검증 query 자동 실행
--==============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET LINESIZE 200

PROMPT === STEP 1 : 적용 전 SP 상태 ===

SELECT object_name, status, TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner='SCM_MGR' AND object_name='PR_DM_DNM_EDI_CALLOFF_STATUS' AND object_type='PROCEDURE';

PROMPT === STEP 2 : 자동 patch 실행 ===

DECLARE
  v_ddl       CLOB;
  v_new_ddl   CLOB;
  v_anchor    VARCHAR2(80) := 'EXCEPTION' || CHR(10) || '        WHEN OTHERS THEN';
  v_insert    VARCHAR2(800);
  v_pos       PLS_INTEGER;
  v_anchor_len PLS_INTEGER;
  v_cursor    INTEGER;
  v_dummy     INTEGER;
BEGIN
  -- 1) END 로그 5줄 (anchor 직전 삽입)
  v_insert :=
    '    -- 종료 LOG (정상 경로) - 2026-06-17 fix (200 DIAG: DIFF END+0 → END+1)' || CHR(10) ||
    '    V_LOG_TYPE := ''END'';' || CHR(10) ||
    '    V_LOG_MESSAGE := ''########## END of procedure ##########'';' || CHR(10) ||
    '    D_EVENT_DATE := SYSTIMESTAMP;' || CHR(10) ||
    '    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);' || CHR(10) || CHR(10) || '    ';

  -- 2) 현 DDL 추출
  v_ddl := DBMS_METADATA.GET_DDL('PROCEDURE', 'PR_DM_DNM_EDI_CALLOFF_STATUS', 'SCM_MGR');
  v_anchor_len := LENGTH(v_anchor);

  -- 3) anchor 위치 (EXCEPTION 직전)
  v_pos := DBMS_LOB.INSTR(v_ddl, v_anchor);

  IF v_pos = 0 THEN
    -- anchor 다른 형식 시도 (들여쓰기 4)
    v_anchor := 'EXCEPTION' || CHR(10) || '    WHEN OTHERS THEN';
    v_anchor_len := LENGTH(v_anchor);
    v_pos := DBMS_LOB.INSTR(v_ddl, v_anchor);
  END IF;

  IF v_pos = 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'anchor 패턴 미발견 — 수동 patch 필요');
  END IF;

  DBMS_OUTPUT.PUT_LINE('[INFO] anchor 위치: ' || v_pos || ', DDL 길이: ' || DBMS_LOB.GETLENGTH(v_ddl));

  -- 4) anchor 직전에 v_insert 삽입 → 새 DDL 조립
  DBMS_LOB.CREATETEMPORARY(v_new_ddl, TRUE);
  DBMS_LOB.APPEND(v_new_ddl, DBMS_LOB.SUBSTR(v_ddl, v_pos - 1, 1));
  DBMS_LOB.WRITEAPPEND(v_new_ddl, LENGTH(v_insert), v_insert);
  DBMS_LOB.APPEND(v_new_ddl, DBMS_LOB.SUBSTR(v_ddl, DBMS_LOB.GETLENGTH(v_ddl) - v_pos + 1, v_pos));

  DBMS_OUTPUT.PUT_LINE('[INFO] 새 DDL 길이: ' || DBMS_LOB.GETLENGTH(v_new_ddl));

  -- 5) DBMS_SQL.PARSE 으로 CREATE OR REPLACE 실행 (CLOB 채로)
  v_cursor := DBMS_SQL.OPEN_CURSOR;
  BEGIN
    DBMS_SQL.PARSE(v_cursor, v_new_ddl, 1, DBMS_LOB.GETLENGTH(v_new_ddl), TRUE, DBMS_SQL.NATIVE);
    v_dummy := DBMS_SQL.EXECUTE(v_cursor);
    DBMS_SQL.CLOSE_CURSOR(v_cursor);
    DBMS_OUTPUT.PUT_LINE('[OK] SP 재컴파일 완료');
  EXCEPTION WHEN OTHERS THEN
    IF DBMS_SQL.IS_OPEN(v_cursor) THEN
      DBMS_SQL.CLOSE_CURSOR(v_cursor);
    END IF;
    RAISE;
  END;

  DBMS_LOB.FREETEMPORARY(v_new_ddl);
END;
/

PROMPT === STEP 3 : 적용 후 SP 상태 (VALID 기대) ===

SELECT object_name, status, TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner='SCM_MGR' AND object_name='PR_DM_DNM_EDI_CALLOFF_STATUS' AND object_type='PROCEDURE';

PROMPT === STEP 4 : 새 END 로그 호출 라인 확인 (V_LOG_TYPE := 'END' 2 row 기대) ===

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
  IF v_post_end - v_pre_end = 1 THEN
    DBMS_OUTPUT.PUT_LINE('[SUCCESS] END 로그 정상 INSERT — fix 완료');
  ELSE
    DBMS_OUTPUT.PUT_LINE('[FAIL] END+0 — 추가 진단 필요');
  END IF;
END;
/

PROMPT === STEP 6 : SCM_SYS_LOG_BATCH 최신 row 확인 (START + END 모두 오늘 날짜 기대) ===

SELECT LOG_TYPE, COUNT(*) AS CNT,
       TO_CHAR(MAX(LAST_UPDATE_DATE), 'YYYY-MM-DD HH24:MI:SS') AS LAST_DT
  FROM SCM_MGR.SCM_SYS_LOG_BATCH
 WHERE PROGRAM_NAME='PR_DM_DNM_EDI_CALLOFF_STATUS'
 GROUP BY LOG_TYPE
 ORDER BY LOG_TYPE;

PROMPT === 220_DMF0008_status_update_end_log_auto_patch.sql 완료 ===

--==============================================================================
-- 적용 후:
--   STEP 3 의 STATUS = 'VALID' 확인
--   STEP 4 의 V_LOG_TYPE := 'END' 가 2 row 출력 (기존 EXCEPTION 안 + 신규 정상 경로)
--   STEP 5 의 [SUCCESS] 출력
--   STEP 6 의 END LAST_DT = 오늘 날짜 (2026-06-17)
--   브라우저 새로고침 → DMF0008 → Status Update 클릭 → Last Update End 변경됨
--==============================================================================
