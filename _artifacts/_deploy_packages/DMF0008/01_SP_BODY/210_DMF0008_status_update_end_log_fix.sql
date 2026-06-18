--==============================================================================
-- 210_DMF0008_status_update_end_log_fix.sql
--
-- PR_DM_DNM_EDI_CALLOFF_STATUS — END 로그 정상 경로 호출 추가
-- =============================================================================
-- 작성: 2026-06-17 (200 진단 결과 → END 로그가 EXCEPTION 블록 안 unreachable 위치)
--
-- 사고:
--   200 DIAG 6 의 DIFF: START+1 END+0 → 정상 종료 시 END 로그 미기록
--   200 DIAG 분석 결과 L526-530 의 END 호출이 L514 EXCEPTION 블록 안에 위치.
--   정상 경로 (L508 outer logic 종료) 에서는 END 호출 자체 없음.
--
-- 변환기 결함 패턴:
--   MSSQL TRY block 끝에 있던 END 로그 → Oracle 변환 시 EXCEPTION 블록 안으로 잘못 이동
--
-- Fix 전략 — sp-body-minimal-change.md 준수:
--   L508 (outer logic END;) 직후, L514 (EXCEPTION) 직전에 END 로그 호출 5줄 추가.
--   기존 L526-530 의 EXCEPTION 안 END 로그는 그대로 유지 (ERROR 시에도 END 기록 = 의도).
--
-- 본 SQL 은 SP body 전체 재컴파일 (CREATE OR REPLACE) — DBMS_METADATA 로 dump 후
-- 정확 위치에 5줄 추가하는 방식 안내.
--==============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === STEP 1 : 적용 전 상태 확인 ===

SELECT object_name, status, TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner='SCM_MGR' AND object_name='PR_DM_DNM_EDI_CALLOFF_STATUS' AND object_type='PROCEDURE';

PROMPT === STEP 2 : SP body 의 EXCEPTION 직전 위치 (L504~L514) 확인 ===

SELECT line, SUBSTR(text, 1, 150) AS txt
  FROM all_source
 WHERE owner='SCM_MGR' AND name='PR_DM_DNM_EDI_CALLOFF_STATUS'
   AND line BETWEEN 504 AND 514
 ORDER BY line;

PROMPT === STEP 3 : SP body 전체 dump (수동 patch 용) ===

-- DBeaver/SQL*Plus 로 다음 query 결과를 .sql 파일로 spool 한 후 수정:
--
-- SET LONG 100000
-- SET LONGCHUNKSIZE 100000
-- SET PAGESIZE 0
-- SET LINESIZE 32767
-- SPOOL pr_dm_dnm_edi_calloff_status_dump.sql
-- SELECT DBMS_METADATA.GET_DDL('PROCEDURE', 'PR_DM_DNM_EDI_CALLOFF_STATUS', 'SCM_MGR') FROM DUAL;
-- SPOOL OFF

PROMPT === STEP 4 : 수동 patch 절차 (DBeaver 권장) ===

PROMPT
PROMPT  1. DBeaver — Database Navigator → SCM_MGR → Procedures → PR_DM_DNM_EDI_CALLOFF_STATUS
PROMPT  2. 우클릭 → "Edit Source" 또는 "View Source" → Edit 모드
PROMPT  3. L508 (END;) 직후, L510 (-- END TRY 주석) 직전 빈 줄 (L509) 에 다음 5줄 삽입:
PROMPT
PROMPT  -------- 삽입 5줄 (들여쓰기 4 칸) --------
PROMPT      -- 종료 LOG (정상 경로) — 2026-06-17 fix
PROMPT      V_LOG_TYPE := 'END';
PROMPT      V_LOG_MESSAGE := '########## END of procedure ##########';
PROMPT      D_EVENT_DATE := SYSTIMESTAMP;
PROMPT      PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
PROMPT  ------------------------------------------------
PROMPT
PROMPT  4. F5 (Run Script) 또는 Alt+X (Execute SQL Script) — SP 재컴파일
PROMPT  5. STEP 5 검증 query 실행

PROMPT === STEP 5 : 적용 후 검증 ===

-- 5-1 : SP 상태 (VALID 기대)
SELECT object_name, status, TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner='SCM_MGR' AND object_name='PR_DM_DNM_EDI_CALLOFF_STATUS' AND object_type='PROCEDURE';

-- 5-2 : 적용 후 라인 다시 확인 (L509 즈음에 'V_LOG_TYPE := ''END''' 등장 기대)
SELECT line, SUBSTR(text, 1, 150) AS txt
  FROM all_source
 WHERE owner='SCM_MGR' AND name='PR_DM_DNM_EDI_CALLOFF_STATUS'
   AND (UPPER(text) LIKE '%V_LOG_TYPE%''END''%'
        OR UPPER(text) LIKE '%''END OF PROCEDURE%')
 ORDER BY line;

-- 5-3 : 실 호출 — END 로그 INSERT 검증
DECLARE
  v_pre_end_cnt PLS_INTEGER;
  v_post_end_cnt PLS_INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_pre_end_cnt FROM SCM_MGR.SCM_SYS_LOG_BATCH
   WHERE PROGRAM_NAME='PR_DM_DNM_EDI_CALLOFF_STATUS' AND LOG_TYPE='END';

  SCM_MGR.PR_DM_DNM_EDI_CALLOFF_STATUS;
  COMMIT;

  SELECT COUNT(*) INTO v_post_end_cnt FROM SCM_MGR.SCM_SYS_LOG_BATCH
   WHERE PROGRAM_NAME='PR_DM_DNM_EDI_CALLOFF_STATUS' AND LOG_TYPE='END';

  DBMS_OUTPUT.PUT_LINE('END LOG : PRE=' || v_pre_end_cnt || ' POST=' || v_post_end_cnt ||
                       ' DIFF=' || (v_post_end_cnt - v_pre_end_cnt));
  IF v_post_end_cnt - v_pre_end_cnt = 1 THEN
    DBMS_OUTPUT.PUT_LINE('[OK] END 로그 정상 INSERT — fix 성공');
  ELSE
    DBMS_OUTPUT.PUT_LINE('[FAIL] END 로그 미증가 — 추가 진단 필요');
  END IF;
END;
/

PROMPT === 210_DMF0008_status_update_end_log_fix.sql 완료 ===

--==============================================================================
-- 본 SQL 은 안내 + 검증용. 실제 SP 수정은 DBeaver 의 SP Edit 모드에서 직접 5줄 삽입.
-- 사용자 사내 DBA 권한 필요. 권한 있으면 STEP 4 절차대로 수동 patch.
-- 권한 없으면 사내 DBA 에 patch 요청 (5줄 삽입 + 재컴파일).
--==============================================================================
