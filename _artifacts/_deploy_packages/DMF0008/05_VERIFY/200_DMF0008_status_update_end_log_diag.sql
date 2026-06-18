--==============================================================================
-- 200_DMF0008_status_update_end_log_diag.sql
--
-- Last Update End Date 미변경 원인 진단
-- =============================================================================
-- 작성: 2026-06-17 (Status Update 후 Start 만 변경, End 변경 X 사용자 보고)
--
-- 가설:
--   1) PR_DM_DNM_EDI_CALLOFF_STATUS SP body 가 'END' 로그 INSERT 부분 미실행
--      → EXCEPTION 진입 또는 중간 RAISE / RETURN
--   2) SP 내부 PR_SCM_SYS_LOG_BATCH('END', ...) 호출 자체 누락 (변환기 결함)
--   3) BE 가 SP 호출 후 별도 END 로그 INSERT 처리 누락
--==============================================================================

SET LINESIZE 250
SET PAGESIZE 200
SET SERVEROUTPUT ON

PROMPT === DIAG 1 : SCM_SYS_LOG_BATCH 의 START/END row 카운트 + 최신 시각 ===

SELECT LOG_TYPE, COUNT(*) AS CNT,
       TO_CHAR(MIN(LAST_UPDATE_DATE), 'YYYY-MM-DD HH24:MI:SS') AS FIRST_DT,
       TO_CHAR(MAX(LAST_UPDATE_DATE), 'YYYY-MM-DD HH24:MI:SS') AS LAST_DT,
       MAX(LAST_UPDATED_BY) AS LAST_BY
  FROM SCM_MGR.SCM_SYS_LOG_BATCH
 WHERE PROGRAM_NAME = 'PR_DM_DNM_EDI_CALLOFF_STATUS'
 GROUP BY LOG_TYPE
 ORDER BY LOG_TYPE;

PROMPT === DIAG 2 : 최근 24시간 의 SCM_SYS_LOG_BATCH 모든 row ===

SELECT TO_CHAR(LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS LOG_DT,
       LOG_TYPE, LAST_UPDATED_BY,
       SUBSTR(LOG_MESSAGE, 1, 100) AS MSG_PREVIEW
  FROM SCM_MGR.SCM_SYS_LOG_BATCH
 WHERE PROGRAM_NAME = 'PR_DM_DNM_EDI_CALLOFF_STATUS'
   AND LAST_UPDATE_DATE >= SYSDATE - 1
 ORDER BY LAST_UPDATE_DATE DESC
 FETCH FIRST 20 ROWS ONLY;

PROMPT === DIAG 3 : PR_DM_DNM_EDI_CALLOFF_STATUS SP body 의 PR_SCM_SYS_LOG_BATCH 호출 추출 ===

SELECT line,
       SUBSTR(REGEXP_REPLACE(text, '\s+', ' '), 1, 200) AS text_trimmed
  FROM all_source
 WHERE owner='SCM_MGR'
   AND name='PR_DM_DNM_EDI_CALLOFF_STATUS'
   AND (UPPER(text) LIKE '%PR_SCM_SYS_LOG_BATCH%'
        OR UPPER(text) LIKE '%LOG_TYPE%'
        OR UPPER(text) LIKE '''START'''
        OR UPPER(text) LIKE '''END''')
 ORDER BY line;

PROMPT === DIAG 4 : PR_DM_DNM_EDI_CALLOFF_STATUS SP body — EXCEPTION + RAISE 라인 ===

SELECT line,
       SUBSTR(REGEXP_REPLACE(text, '\s+', ' '), 1, 200) AS text_trimmed
  FROM all_source
 WHERE owner='SCM_MGR'
   AND name='PR_DM_DNM_EDI_CALLOFF_STATUS'
   AND (UPPER(text) LIKE '%EXCEPTION%'
        OR UPPER(text) LIKE '%RAISE%'
        OR UPPER(text) LIKE '%RETURN%'
        OR UPPER(text) LIKE 'BEGIN%'
        OR UPPER(text) LIKE 'END;%'
        OR UPPER(text) LIKE 'END %DMF%'
        OR UPPER(text) LIKE 'END %PR_%')
 ORDER BY line;

PROMPT === DIAG 5 : SP 시그니처 (인자 0개 확인) + STATUS ===

SELECT object_name, status,
       TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner='SCM_MGR' AND object_name='PR_DM_DNM_EDI_CALLOFF_STATUS'
   AND object_type='PROCEDURE';

SELECT argument_name, position, data_type, in_out
  FROM all_arguments
 WHERE owner='SCM_MGR' AND object_name='PR_DM_DNM_EDI_CALLOFF_STATUS'
   AND package_name IS NULL
 ORDER BY position;

PROMPT === DIAG 6 : SP 단독 호출 — START/END 양쪽 기록 여부 검증 ===

DECLARE
  v_pre_start_cnt PLS_INTEGER;
  v_pre_end_cnt   PLS_INTEGER;
  v_post_start_cnt PLS_INTEGER;
  v_post_end_cnt   PLS_INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_pre_start_cnt FROM SCM_MGR.SCM_SYS_LOG_BATCH
   WHERE PROGRAM_NAME='PR_DM_DNM_EDI_CALLOFF_STATUS' AND LOG_TYPE='START';
  SELECT COUNT(*) INTO v_pre_end_cnt FROM SCM_MGR.SCM_SYS_LOG_BATCH
   WHERE PROGRAM_NAME='PR_DM_DNM_EDI_CALLOFF_STATUS' AND LOG_TYPE='END';

  DBMS_OUTPUT.PUT_LINE('PRE  : START=' || v_pre_start_cnt || ' END=' || v_pre_end_cnt);

  BEGIN
    SCM_MGR.PR_DM_DNM_EDI_CALLOFF_STATUS;
    DBMS_OUTPUT.PUT_LINE('SP CALL: NORMAL EXIT');
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('SP CALL ERR: SQLCODE=' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE('SP CALL ERR: SQLERRM=' || SUBSTR(SQLERRM, 1, 300));
  END;
  COMMIT; -- SP 가 INSERT 후 COMMIT 안 했을 수 있음

  SELECT COUNT(*) INTO v_post_start_cnt FROM SCM_MGR.SCM_SYS_LOG_BATCH
   WHERE PROGRAM_NAME='PR_DM_DNM_EDI_CALLOFF_STATUS' AND LOG_TYPE='START';
  SELECT COUNT(*) INTO v_post_end_cnt FROM SCM_MGR.SCM_SYS_LOG_BATCH
   WHERE PROGRAM_NAME='PR_DM_DNM_EDI_CALLOFF_STATUS' AND LOG_TYPE='END';

  DBMS_OUTPUT.PUT_LINE('POST : START=' || v_post_start_cnt || ' END=' || v_post_end_cnt);
  DBMS_OUTPUT.PUT_LINE('DIFF : START+' || (v_post_start_cnt - v_pre_start_cnt) ||
                       ' END+' || (v_post_end_cnt - v_pre_end_cnt));
END;
/

PROMPT === 200_DMF0008_status_update_end_log_diag.sql 완료 ===

--==============================================================================
-- 판독:
--   DIAG 1 의 START LAST_DT > END LAST_DT → SP 가 END 안 찍음 (root cause 확정)
--   DIAG 3 에 PR_SCM_SYS_LOG_BATCH('END', ...) 호출 라인 0건 → SP body 자체 결함
--   DIAG 6 의 DIFF : START+1 END+0 → SP 가 END 직전 RAISE / RETURN 또는 EXCEPTION
--   DIAG 6 SQLCODE/SQLERRM → 실 ORA 코드 (BE 가 -9994 변환 안 되는 이유 — 200 OK 인데 logic 결함)
--==============================================================================
