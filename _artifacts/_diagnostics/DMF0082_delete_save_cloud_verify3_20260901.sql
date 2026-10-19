-- ============================================================================
-- DMF0082 DELETE후저장 오류 — 3차 검증 (재배포 후에도 지속 실패, 2026-09-01)
-- 이번 판정 축: "실패가 DB 에 도달했는가" — §12 V$SQL 이 결정타.
--   도달 흔적 없음 → BE 내부 실패(NPE 계보 — 래퍼 메시지 "null" 과 정합) = 클라우드 BE 빌드 축
--   도달 흔적 있음 → DB 측 — §13(선택) SERVERERROR 트리거로 ORA 원문 채집
-- 실행 직전에 화면에서 DELETE→저장 1회 재현 후 곧바로 실행해주세요.
-- ============================================================================

-- §10. 최신 실패 로그 (오늘) — EXCEPTION 전문 + 호출문 앞부분
SELECT '§10 최신오류' AS SECTION, EXECUTE_TIME, ELAPSED_MS,
       SUBSTR(EXCEPTION, 1, 4000) AS EXCEPTION_FULL,
       SUBSTR(SQL_TEXT, 1, 200) AS CALL_HEAD
  FROM SCM_MGR.SCM_COM_SQL_LOG
 WHERE UPPER(PARAMS) LIKE '%SAVE_MAIN_DATA%'
   AND EXCEPTION IS NOT NULL
   AND EXECUTE_TIME >= TRUNC(SYSDATE)
 ORDER BY EXECUTE_TIME DESC
 FETCH FIRST 5 ROWS ONLY;

-- §11. 재배포 검증 — NCHARUNION=1 이어야 우리 정본. 0 이면 재배포가 다른 본문/미적용.
SELECT '§11 재배포검증' AS SECTION,
       (SELECT TO_CHAR(MAX(LAST_DDL_TIME),'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS
         WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY') AS BODY_LAST_DDL,
       (SELECT STATUS FROM ALL_OBJECTS
         WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY') AS BODY_STATUS,
       (SELECT COUNT(*) FROM ALL_SOURCE
         WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
           AND INSTR(TEXT,'E20260831-NCHARUNION') > 0) AS NCHARUNION_CNT
  FROM DUAL;

-- §12. ⭐ 결정타 — SAVE call 이 DB 에 도달했는지 (커서/실행 흔적)
--     판독: 행이 없거나 LAST_ACTIVE_TIME 이 재현 시각보다 과거 → 호출이 DB 에 안 옴 = BE 내부 실패 확정.
--           재현 시각과 일치하는 EXECUTIONS 증가가 보이면 → DB 측에서 실행 중 오류.
SELECT '§12 도달판정' AS SECTION, SQL_ID, EXECUTIONS, PARSE_CALLS,
       TO_CHAR(LAST_ACTIVE_TIME,'YYYY-MM-DD HH24:MI:SS') AS LAST_ACTIVE,
       FIRST_LOAD_TIME, SUBSTR(SQL_TEXT,1,120) AS SQL_HEAD
  FROM V$SQL
 WHERE UPPER(SQL_TEXT) LIKE '%P_DMF0082_SAVE_MAIN_DATA%'
   AND UPPER(SQL_TEXT) NOT LIKE '%V$SQL%'
 ORDER BY LAST_ACTIVE_TIME DESC;

-- §12-B. 보조 — 재현 시각대 세션 오류 이벤트 (있으면 DB 도달 방증)
SELECT '§12B ASH오류대' AS SECTION, TO_CHAR(SAMPLE_TIME,'HH24:MI:SS') AS T,
       SESSION_ID, SQL_ID, EVENT
  FROM V$ACTIVE_SESSION_HISTORY
 WHERE SAMPLE_TIME >= SYSDATE - 30/1440
   AND SQL_ID IN (SELECT SQL_ID FROM V$SQL WHERE UPPER(SQL_TEXT) LIKE '%P_DMF0082_SAVE_MAIN_DATA%')
 ORDER BY SAMPLE_TIME DESC
 FETCH FIRST 10 ROWS ONLY;

-- ============================================================================
-- §13. (선택 — §12 가 "DB 도달" 로 나올 때만, DBA 승인 하에) SERVERERROR 트리거로 ORA 원문 채집.
--      ⚠ 아래는 DDL 입니다. 설치 → 화면에서 DELETE→저장 1회 재현 → §13-C 조회 → §13-D 로 즉시 제거.
-- ============================================================================
-- §13-A. 채집 테이블 + 트리거 설치
-- CREATE TABLE SCM_MGR.TMP_ERR_CAPTURE (
--   AT_TIME TIMESTAMP, USERNAME VARCHAR2(128), ERR_STACK VARCHAR2(4000), SQL_HEAD VARCHAR2(1000));
-- CREATE OR REPLACE TRIGGER SCM_MGR.TRG_TMP_ERR_CAPTURE
-- AFTER SERVERERROR ON DATABASE
-- DECLARE
--   v_sql VARCHAR2(1000);
-- BEGIN
--   IF USER IN ('SCMP_APP','SCM_MGR') THEN
--     BEGIN
--       SELECT SUBSTR(SQL_TEXT,1,1000) INTO v_sql FROM V$SQL
--        WHERE SQL_ID = (SELECT PREV_SQL_ID FROM V$SESSION WHERE AUDSID = SYS_CONTEXT('USERENV','SESSIONID'))
--          AND ROWNUM = 1;
--     EXCEPTION WHEN OTHERS THEN v_sql := NULL; END;
--     INSERT INTO SCM_MGR.TMP_ERR_CAPTURE
--     VALUES (SYSTIMESTAMP, USER, DBMS_UTILITY.FORMAT_ERROR_STACK, v_sql);
--   END IF;
-- END;
-- /
-- §13-B. (재현: 화면에서 DELETE→저장 1회)
-- §13-C. 채집 결과 조회 — 여기의 ORA-코드가 실오류 원문
-- SELECT * FROM SCM_MGR.TMP_ERR_CAPTURE ORDER BY AT_TIME DESC;
-- §13-D. 제거 (필수 — 채집 후 바로)
-- DROP TRIGGER SCM_MGR.TRG_TMP_ERR_CAPTURE;
-- DROP TABLE SCM_MGR.TMP_ERR_CAPTURE;
