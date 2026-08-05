-- =============================================================================
-- 02_VERIFY_AFTER_APPLY.sql — 적용 후 검증 (계정: SCM_MGR)
--   [1] 컴파일 상태  [2] UI 조회 후 실행계획 2종 (프루닝 / MERGE spill)
-- =============================================================================
SET LINESIZE 220
SET PAGESIZE 200
SPOOL DMF0082_VERIFY_AFTER.txt

PROMPT ############################################################
PROMPT [1] 컴파일 상태 — VALID / 오류 0 / 라인 12,920 이어야 함
PROMPT ############################################################
SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082';
SELECT COUNT(*) AS 오류수 FROM ALL_ERRORS
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082';
SELECT MAX(LINE) AS 라인수 FROM DBA_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY';

PROMPT ############################################################
PROMPT [2] ⭐ 여기서 UI 로 DMF0082 조회를 실행하십시오
PROMPT     division 81 (기존 hang 재현 조건) → 완료 여부·소요시간 기록
PROMPT     division 40 / 82 → 행수가 적용 전과 동일한지 확인
PROMPT     조회 후 아래 [3][4] 를 이어서 실행
PROMPT ############################################################
PAUSE 조회 완료 후 Enter...

PROMPT ############################################################
PROMPT [3] 파티션 프루닝 반영 — SCM_MST_FUTURE_PRICE_C 접근 계획
PROMPT     PARTITION RANGE ALL → ITERATOR(또는 SINGLE) 로 바뀌어야 성공
PROMPT ############################################################
SELECT P.SQL_ID, P.ID, P.OPERATION||' '||P.OPTIONS AS OP,
       P.PARTITION_START, P.PARTITION_STOP
  FROM V$SQL_PLAN P
 WHERE (P.OBJECT_NAME = 'SCM_MST_FUTURE_PRICE_C' OR P.OPERATION LIKE 'PARTITION%')
   AND P.SQL_ID IN (SELECT SQL_ID FROM V$SQL
                     WHERE SQL_TEXT LIKE '%SCM_MST_FUTURE_PRICE_C%'
                       AND PARSING_SCHEMA_NAME='SCM_MGR'
                       AND LAST_ACTIVE_TIME > SYSDATE - 15/1440)
 ORDER BY P.SQL_ID, P.ID;

PROMPT ############################################################
PROMPT [4] MERGE 힌트 반영 — build 가 VIEW(집계) 쪽인지 + TEMP spill 소멸
PROMPT ############################################################
SELECT SQL_ID, CHILD_NUMBER FROM V$SQL
 WHERE SQL_TEXT LIKE 'MERGE /*+ LEADING(B) USE_HASH(A) *%'
   AND PARSING_SCHEMA_NAME='SCM_MGR';
-- 위 SQL_ID 로 (값 치환):
-- SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('<SQL_ID>',NULL,'ALLSTATS LAST'));
--   기대: HASH JOIN 첫 자식 = VIEW(SORT GROUP BY), Used-Tmp 컬럼 없음

SPOOL OFF
PROMPT 회신: DMF0082_VERIFY_AFTER.txt + division 81/40/82 소요시간·행수
