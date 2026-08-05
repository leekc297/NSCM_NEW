-- =============================================================================
-- DMF0082_HANG_DIAG_CLOUD.sql
--   DMF0082 · DIVISION 81 조회가 **끝나지 않고 스피너만 도는** 현상 진단 (클라우드)
--
--   ⚠ READ-ONLY. 변경 없음. 계정: SCM_MGR
--
--   ⛔⛔ 실행 방법이 중요합니다
--     오류가 아니라 **hang** 이므로, **스피너가 도는 동안** 그 세션을 잡아야 합니다.
--     ① 화면에서 DMF0082 · DIVISION 81 조회를 시작 (스피너 도는 상태 유지)
--     ② **다른 세션**(SQL*Plus / DBeaver 새 창)에서 이 스크립트를 실행
--     ③ 30초 뒤 [3]~[5] 만 **한 번 더** 실행해서 값이 변하는지 비교
--        (같은 SQL_ID 에 머물러 있으면 그 SQL 이 범인, 계속 바뀌면 루프 의심)
--
--   ▶ 사내 대조값 (2026-07-31 실측, 같은 조회조건 Current/20260701~20270101)
--     · DIVISION 81 : **15.67초** 완료 / RC1 422행
--     · DIVISION 40 : 47.69초 완료 / RC1 1,974행   ← 40 이 더 무겁습니다
--     · 즉 사내에서 81 은 **정상 완료**합니다. 클라우드만 멈춘다면 환경/데이터 요인.
-- =============================================================================
SET LINESIZE 300
SET PAGESIZE 300
SET TRIMSPOOL ON
SET FEEDBACK ON
COLUMN EVENT        FORMAT A44
COLUMN SQL_TEXT     FORMAT A70
COLUMN T            FORMAT A70
COLUMN MODULE       FORMAT A24
COLUMN PROGRAM      FORMAT A26
COLUMN OBJ          FORMAT A34

SPOOL DMF0082_HANG_DIAG.txt

PROMPT ############################################################
PROMPT [0] 환경
PROMPT ############################################################
SELECT SYS_CONTEXT('USERENV','DB_NAME') DB_NAME,
       SYS_CONTEXT('USERENV','SERVER_HOST') HOST,
       TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW,
       (SELECT COUNT(*) FROM GV$INSTANCE) RAC_NODES
  FROM DUAL;

PROMPT ############################################################
PROMPT [1] ⭐ 지금 DMF0082 를 돌고 있는 세션 식별
PROMPT ############################################################
SELECT s.INST_ID, s.SID, s.SERIAL#, s.USERNAME, s.STATUS,
       s.SQL_ID, s.SQL_CHILD_NUMBER CH,
       s.LAST_CALL_ET AS 초_현재콜경과,
       s.EVENT, s.WAIT_CLASS, s.SECONDS_IN_WAIT AS 초_대기,
       s.BLOCKING_SESSION AS 차단세션, s.BLOCKING_INSTANCE AS 차단인스턴스,
       s.MODULE, s.PROGRAM
  FROM GV$SESSION s
 WHERE s.USERNAME IS NOT NULL
   AND s.STATUS = 'ACTIVE'
   AND ( s.SQL_ID IN (SELECT SQL_ID FROM GV$SQL
                       WHERE REGEXP_LIKE(SQL_TEXT,'DMF0082|GT_DMF0082|GT_FTPR|GT_PRDM1|GTT_MF_SP','i'))
      OR s.PREV_SQL_ID IN (SELECT SQL_ID FROM GV$SQL
                       WHERE REGEXP_LIKE(SQL_TEXT,'DMF0082|GT_DMF0082|GT_FTPR|GT_PRDM1|GTT_MF_SP','i')) )
 ORDER BY s.LAST_CALL_ET DESC;
--
-- ⭐ 판정
--   초_현재콜경과 가 계속 증가 → 아직 돌고 있음(hang 진행 중). 이 SID 를 [3]~[6] 에 사용
--   EVENT / WAIT_CLASS  → 무엇을 기다리는지 (아래 해석표)
--   차단세션 이 NOT NULL → **다른 세션이 막고 있음**(락) → [4] 로 추적
--
-- 【EVENT 해석】
--   'library cache: mutex X' / 'cursor: mutex X' / 'row cache mutex'
--        → GTT TRUNCATE(DDL) 동시세션 경합 (hook #107). [7] 확인
--   'enq: TX - row lock contention'      → 행 락. [4] 차단 트리
--   'enq: TM - contention'               → 테이블 락 (DDL vs DML)
--   'cell single block physical read' / 'db file sequential read'
--        → 계획 문제로 인한 랜덤 IO 과다 (느린 것이지 멈춘 게 아님)
--   'direct path read temp' / 'direct path write temp' → TEMP 유출
--   'ON CPU'(EVENT NULL)                 → CPU 소모 중. 루프 의심 → [6]
--   'SQL*Net message from client'        → **DB 는 끝났고 FE/BE 대기** → DB 문제 아님

PROMPT ############################################################
PROMPT [2] 위 세션이 실행 중인 SQL 전문
PROMPT ############################################################
SELECT s.SID, s.SQL_ID, q.PLAN_HASH_VALUE PHV,
       ROUND(q.ELAPSED_TIME/1e6,1) AS 누적초, q.EXECUTIONS AS 실행횟수,
       q.BUFFER_GETS, q.DISK_READS, q.ROWS_PROCESSED,
       SUBSTR(REGEXP_REPLACE(q.SQL_TEXT,'\s+',' '),1,140) AS SQL_TEXT
  FROM GV$SESSION s JOIN GV$SQL q
    ON q.INST_ID=s.INST_ID AND q.SQL_ID=s.SQL_ID AND q.CHILD_NUMBER=s.SQL_CHILD_NUMBER
 WHERE s.STATUS='ACTIVE' AND s.USERNAME IS NOT NULL
   AND REGEXP_LIKE(q.SQL_TEXT,'DMF0082|GT_DMF0082|GT_FTPR|GT_PRDM1|GTT_MF_SP','i');

PROMPT ############################################################
PROMPT [3] 실시간 대기 (30초 간격으로 2회 실행해 비교)
PROMPT ############################################################
SELECT INST_ID, SID, EVENT, WAIT_CLASS, STATE, SECONDS_IN_WAIT,
       P1TEXT, P1, P2TEXT, P2, P3TEXT, P3
  FROM GV$SESSION
 WHERE STATUS='ACTIVE' AND USERNAME IS NOT NULL
   AND SQL_ID IN (SELECT SQL_ID FROM GV$SQL
                   WHERE REGEXP_LIKE(SQL_TEXT,'DMF0082|GT_DMF0082|GT_FTPR|GT_PRDM1','i'));

PROMPT ############################################################
PROMPT [4] 차단(blocking) 트리 — 락으로 멈춘 것인지
PROMPT ############################################################
SELECT LEVEL LV, LPAD(' ',(LEVEL-1)*2)||SID AS 세션트리, INST_ID, SERIAL#, USERNAME,
       STATUS, EVENT, SECONDS_IN_WAIT, BLOCKING_SESSION, SQL_ID
  FROM GV$SESSION
 WHERE USERNAME IS NOT NULL
 START WITH BLOCKING_SESSION IS NULL
        AND SID IN (SELECT BLOCKING_SESSION FROM GV$SESSION WHERE BLOCKING_SESSION IS NOT NULL)
 CONNECT BY PRIOR SID = BLOCKING_SESSION
        AND PRIOR INST_ID = BLOCKING_INSTANCE;
-- 0행 = 락 차단 없음

PROMPT --- 락 상세 (있을 때만)
SELECT l.INST_ID, l.SID, l.TYPE, l.ID1, l.ID2, l.LMODE, l.REQUEST, l.CTIME,
       o.OWNER||'.'||o.OBJECT_NAME AS OBJ
  FROM GV$LOCK l LEFT JOIN DBA_OBJECTS o ON o.OBJECT_ID = l.ID1
 WHERE l.REQUEST > 0
 ORDER BY l.CTIME DESC;

PROMPT ############################################################
PROMPT [5] LONGOPS — 진행률이 있으면 "느린 것", 없으면 "멈춘 것"
PROMPT ############################################################
SELECT INST_ID, SID, SERIAL#, OPNAME, TARGET, SOFAR, TOTALWORK,
       ROUND(SOFAR/NULLIF(TOTALWORK,0)*100,1) AS PCT,
       ELAPSED_SECONDS, TIME_REMAINING, SQL_ID
  FROM GV$SESSION_LONGOPS
 WHERE TIME_REMAINING > 0 OR (ELAPSED_SECONDS > 5 AND SOFAR < TOTALWORK)
 ORDER BY START_TIME DESC;

PROMPT ############################################################
PROMPT [6] ⭐ 최근 15분 ASH — 그 세션이 어디에 시간을 쓰는가 (루프 판별)
PROMPT ############################################################
SELECT * FROM (
  SELECT a.SQL_ID, a.SQL_PLAN_HASH_VALUE PHV,
         NVL(a.EVENT,'ON CPU') EVENT, a.WAIT_CLASS,
         COUNT(*) AS 샘플수,
         MIN(a.SAMPLE_TIME) AS 최초, MAX(a.SAMPLE_TIME) AS 최종,
         SUBSTR(REGEXP_REPLACE((SELECT q.SQL_TEXT FROM GV$SQL q
                                 WHERE q.SQL_ID=a.SQL_ID AND ROWNUM=1),'\s+',' '),1,60) AS T
    FROM GV$ACTIVE_SESSION_HISTORY a
   WHERE a.SAMPLE_TIME > SYSTIMESTAMP - INTERVAL '15' MINUTE
     AND a.SESSION_TYPE='FOREGROUND'
   GROUP BY a.SQL_ID, a.SQL_PLAN_HASH_VALUE, NVL(a.EVENT,'ON CPU'), a.WAIT_CLASS
   ORDER BY COUNT(*) DESC
) WHERE ROWNUM <= 20;
--
-- ⭐ 판정
--   특정 SQL_ID 1개에 샘플이 집중 → **그 SQL 이 오래 걸리는 것**(계획 문제)
--   여러 SQL_ID 가 짧게 반복 등장 → **루프**(같은 구간을 계속 도는 것) → [8] 확인
--   'ON CPU' 지배 + 특정 SQL 없음 → PL/SQL 루프 의심

PROMPT ############################################################
PROMPT [7] TRUNCATE mutex 경합 여부 (hook #107) — 클라우드 잔존 확인
PROMPT ############################################################
SELECT COUNT(*) AS 잔존_TRUNCATE_라인
  FROM USER_SOURCE
 WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
   AND TRIM(TEXT) NOT LIKE '--%'
   AND REGEXP_LIKE(TEXT,'TRUNCATE\s+TABLE','i');
-- ⭐ 사내는 2026-07-30 에 **19건 전량 DELETE 로 전환 완료 → 0건**입니다.
--    클라우드가 **0 이 아니면** 아직 구판이며, 동시 세션에서
--    'library cache: mutex X' / 'row cache mutex' 로 hang 될 수 있습니다([1] EVENT 와 대조).
--    → 조치 = 이관 패키지 DBWORK_7UI_PKSENTINEL_TRUNC_20260730_2301 의
--             02_DB_SP/14_PKG_DMF0082_BODY.sql 적용

PROMPT --- 지금 mutex 경합이 실제로 있는지
SELECT INST_ID, EVENT, COUNT(*) AS 세션수
  FROM GV$SESSION
 WHERE EVENT LIKE 'library cache%' OR EVENT LIKE 'cursor:%' OR EVENT LIKE 'row cache%'
    OR EVENT LIKE 'enq:%'
 GROUP BY INST_ID, EVENT ORDER BY 3 DESC;

PROMPT ############################################################
PROMPT [8] 무한루프 위험 구문 대조 (사내 값과 비교)
PROMPT ############################################################
SELECT
  (SELECT COUNT(*) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
    AND TRIM(TEXT) NOT LIKE '--%' AND REGEXP_LIKE(TEXT,'%NOTFOUND','i'))          AS NOTFOUND_LINES,
  (SELECT COUNT(*) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
    AND TRIM(TEXT) NOT LIKE '--%' AND REGEXP_LIKE(TEXT,'^\s*LOOP\s*$|WHILE\s','i')) AS LOOP_LINES,
  (SELECT COUNT(*) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
    AND TRIM(TEXT) NOT LIKE '--%' AND REGEXP_LIKE(TEXT,'LIKE\s*''81%''','i'))     AS DIV81_BRANCH,
  (SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI') FROM USER_OBJECTS
    WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY')               AS BODY_LAST_DDL,
  (SELECT STATUS FROM USER_OBJECTS
    WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY')               AS BODY_STATUS
FROM DUAL;
-- ⭐ 사내 기준: NOTFOUND_LINES 7 / LOOP_LINES 12 / DIV81_BRANCH 25 / STATUS VALID
--    DIV81_BRANCH 가 사내보다 **적으면** 클라우드 BODY 가 구판입니다
--    (사내는 2026-07-30 에 division 82→81 편입으로 분기를 26곳 손봤습니다)

PROMPT ############################################################
PROMPT [9] DIVISION 81 데이터량 — 40 과 비교 (데이터 폭증 여부)
PROMPT ############################################################
SELECT 'SCM_MST_FUTURE_PRICE' T, DIVISION_ID, COUNT(*) CNT
  FROM SCM_MST_FUTURE_PRICE WHERE DIVISION_ID IN ('40','81','82')
 GROUP BY DIVISION_ID
UNION ALL
SELECT 'DM_PLN_MKT_FCST', DIVISION_ID, COUNT(*)
  FROM DM_PLN_MKT_FCST WHERE DIVISION_ID IN ('40','81','82')
 GROUP BY DIVISION_ID
UNION ALL
SELECT 'SCM_MST_SITE_ITEM', DIVISION_ID, COUNT(*)
  FROM SCM_MST_SITE_ITEM WHERE DIVISION_ID IN ('40','81','82')
 GROUP BY DIVISION_ID
 ORDER BY 1,2;
-- 사내 참고: SCM_MST_FUTURE_PRICE 40=655,158 / 81=545,671 / 82=487,245
--            → 81 이 40 보다 작습니다. 사내 81 조회는 15.67초에 완료됩니다.
--            클라우드 81 이 40 보다 훨씬 크면 데이터량 요인.

PROMPT ############################################################
PROMPT [10] 81 마스터 미입력 점검 (81 경로 계산에 쓰이는 컬럼)
PROMPT ############################################################
SELECT DIVISION_ID, COUNT(*) AS CNT,
       SUM(CASE WHEN CELL_PER_CAR    IS NULL THEN 1 ELSE 0 END) AS CELL_PER_CAR_NULL,
       SUM(CASE WHEN CELL_PER_MODULE IS NULL THEN 1 ELSE 0 END) AS CELL_PER_MODULE_NULL
  FROM SCM_MST_SITE_ITEM
 WHERE DIVISION_ID IN ('40','81','82')
 GROUP BY DIVISION_ID ORDER BY 1;
-- ⭐ 사내 실측 (2026-07-31):
--    40 : 22,525건 / CELL_PER_CAR NULL 22,525 / CELL_PER_MODULE NULL 22,525
--    81 : 52,526건 / CELL_PER_CAR NULL 18,352 / CELL_PER_MODULE NULL 19,576
--    82 : 37,423건 / CELL_PER_CAR NULL 37,423 / CELL_PER_MODULE NULL 37,420
--    → 사내 81 은 부분 입력 상태에서도 15.67초에 **정상 완료**합니다.
--      클라우드 81 건수가 사내(52,526)보다 훨씬 크면 데이터량 요인을 함께 의심하십시오.

SPOOL OFF

PROMPT
PROMPT =============================================================
PROMPT 회신 요망: DMF0082_HANG_DIAG.txt
PROMPT  ⭐ 가장 중요한 것
PROMPT    · [1] 의 EVENT / WAIT_CLASS / 초_현재콜경과 / 차단세션
PROMPT    · [7] 의 잔존_TRUNCATE_라인  (사내=0. 0 이 아니면 구판 = mutex hang 유력)
PROMPT    · [8] 의 DIV81_BRANCH (사내=25) 와 BODY_LAST_DDL
PROMPT  ⚠ [1]~[3] 은 **스피너가 도는 동안** 30초 간격 2회 실행해 값 변화를 비교해 주세요
PROMPT =============================================================
