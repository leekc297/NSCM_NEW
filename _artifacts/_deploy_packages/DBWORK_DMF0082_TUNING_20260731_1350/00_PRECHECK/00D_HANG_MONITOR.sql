-- =============================================================================
-- 00D_HANG_MONITOR.sql — 실행이 끝나지 않을 때, ⭐ 취소하기 전에 별도 세션에서 실행
--   (지금 어느 문장이/어떤 대기로 멈춰 있는지 = 클라우드 병목의 직접 증거)
--   계정: SCM_MGR / 새 워크시트(새 커넥션)에서 실행
-- =============================================================================
SET LINESIZE 220
SET PAGESIZE 100
SPOOL DMF0082_HANG_MONITOR.txt

PROMPT ############################################################
PROMPT [1] 걸려있는 세션 — 지금 실행 중인 SQL_ID / 대기 이벤트 / 경과
PROMPT ############################################################
SELECT S.SID, S.SERIAL#, S.SQL_ID, S.SQL_CHILD_NUMBER AS CH,
       S.EVENT, S.WAIT_CLASS, S.SECONDS_IN_WAIT,
       S.LAST_CALL_ET AS 전체호출_경과초,
       ROUND(Q.ELAPSED_TIME/1e6,1) AS 이문장_누적초,
       Q.DISK_READS, Q.BUFFER_GETS,
       SUBSTR(REPLACE(Q.SQL_TEXT, CHR(10),' '),1,110) AS SQL_HEAD
  FROM V$SESSION S
  LEFT JOIN V$SQL Q ON Q.SQL_ID = S.SQL_ID AND Q.CHILD_NUMBER = S.SQL_CHILD_NUMBER
 WHERE S.USERNAME = 'SCM_MGR'
   AND S.STATUS   = 'ACTIVE'
   AND S.SID     <> SYS_CONTEXT('USERENV','SID')
 ORDER BY S.LAST_CALL_ET DESC;

PROMPT ############################################################
PROMPT [2] 그 문장의 실행계획 — 위 [1] 의 SQL_ID/CH 를 치환해 실행
PROMPT ############################################################
-- SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('<SQL_ID>', <CH>, 'ALLSTATS LAST +PARTITION'));

PROMPT ############################################################
PROMPT [3] ⭐ 걸린 세션의 옵티마이저 환경 — dynamic sampling 이 0 이면 그것이 원인
PROMPT     (BE/시스템에 적용한 =2 가 SQL Developer 새 세션에 없을 수 있음)
PROMPT     <SID> 를 [1] 의 SID 로 치환
PROMPT ############################################################
-- SELECT NAME, VALUE, ISDEFAULT FROM V$SES_OPTIMIZER_ENV
--  WHERE SID = <SID> AND NAME IN ('optimizer_dynamic_sampling','statistics_level');

PROMPT ############################################################
PROMPT [4] 시스템 파라미터 대조
PROMPT ############################################################
SELECT NAME, VALUE, ISSYS_MODIFIABLE FROM V$PARAMETER
 WHERE NAME IN ('optimizer_dynamic_sampling','statistics_level','temp_undo_enabled');

SPOOL OFF

-- ── 확인이 끝난 후 취소 ──
-- SQL Developer: 실행 중 워크시트의 [작업 취소](빨간 정지 버튼) → 안 되면 해당 커넥션 접속 해제
-- 그래도 남아있으면 (권한 있을 때):  ALTER SYSTEM KILL SESSION '<SID>,<SERIAL#>' IMMEDIATE;
