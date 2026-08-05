-- =============================================================================
-- 00C_CLOUD_PROFILE.sql — ⭐ 클라우드 문장별 프로파일 (적용 전 baseline / 적용 후 비교 공용)
--   목적: 클라우드에서 "어느 문장이 시간을 쓰는지" 를 실측 → 튜닝 우선순위를 클라우드 기준으로 확정
--   계정: SCM_MGR / SQL Developer 또는 SQL*Plus 에서 스크립트 실행(F5)
--
--   ⚠ 사용법
--     · 적용 전(BEFORE): division 40 → 82 순서로 실행. ⛔ 81 은 적용 전엔 실행 금지
--       (프루닝 미적용 상태에서 16분+ hang 재현 — 세션만 낭비됩니다)
--     · 적용 후(AFTER) : 40 → 82 → 81 모두 실행
--     · division 을 바꾸려면 아래 DEFINE DIV 만 수정
-- =============================================================================
SET TIMING ON
SET LINESIZE 220
SET PAGESIZE 100
SET SERVEROUTPUT ON

DEFINE DIV = '40'
SPOOL DMF0082_PROFILE_DIV&DIV..txt

-- [0] 세션 환경 — ⭐ BE 와 동일 조건으로 강제 (이 세션에만 적용)
--   ⚠ optimizer_dynamic_sampling: 클라우드 "100초→20초" 조치가 시스템이 아닌 BE 쪽에만
--     적용돼 있으면 SQL Developer 새 세션은 =0 으로 돌아가 GTT 무통계 → 사실상 hang 이 재현됩니다.
ALTER SESSION SET optimizer_dynamic_sampling = 2;
ALTER SESSION SET STATISTICS_LEVEL = ALL;
-- 참고: STATISTICS_LEVEL=ALL 은 문장별 실측을 위해 필요하지만 5~20% 오버헤드가 있습니다.
--       전체 시간 판정은 UI 조회 기준, 이 스크립트는 "문장별 비중" 판정용입니다.

PROMPT ############################################################
PROMPT [1] SP 실행 — division &DIV (TIMING 값 = 전체 소요시간)
PROMPT ############################################################
VAR C1 REFCURSOR
VAR C2 REFCURSOR
VAR C3 REFCURSOR
VAR C4 REFCURSOR
VAR C5 REFCURSOR
VAR C6 REFCURSOR
EXEC PKG_DMF0082.P_DMF0082_GET_MAIN_DATA('&DIV','ALL','ALL','ALL','20260701','20270101','ALL','','Current','N','minyonglee1','minyonglee1', :C1,:C2,:C3,:C4,:C5,:C6);
-- (PRINT 금지 — 수만 행 출력으로 측정이 오염됩니다)

PROMPT ############################################################
PROMPT [2] ⭐ 문장별 소요시간 TOP 15 — 방금 실행분(LAST) 기준
PROMPT     LAST_SEC 큰 문장이 클라우드 튜닝 표적입니다
PROMPT ############################################################
SELECT * FROM (
  SELECT S.SQL_ID,
         ROUND(MAX(P.LAST_ELAPSED_TIME)/1e6, 2)  AS LAST_SEC,
         MAX(P.LAST_CR_BUFFER_GETS
           + P.LAST_CU_BUFFER_GETS)               AS LAST_BUFFER_GETS,
         MAX(P.LAST_DISK_READS)                   AS LAST_DISK_READS,
         S.ROWS_PROCESSED,
         SUBSTR(REPLACE(REPLACE(S.SQL_TEXT, CHR(10),' '), CHR(9),' '), 1, 90) AS SQL_HEAD
    FROM V$SQL S
    JOIN V$SQL_PLAN_STATISTICS_ALL P
      ON P.SQL_ID = S.SQL_ID AND P.CHILD_NUMBER = S.CHILD_NUMBER AND P.ID <= 1
   WHERE S.PARSING_SCHEMA_NAME = 'SCM_MGR'
     AND S.LAST_ACTIVE_TIME > SYSDATE - 15/1440
     AND S.PROGRAM_ID = (SELECT OBJECT_ID FROM DBA_OBJECTS
                          WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082'
                            AND OBJECT_TYPE='PACKAGE BODY')
   GROUP BY S.SQL_ID, S.ROWS_PROCESSED, SUBSTR(REPLACE(REPLACE(S.SQL_TEXT, CHR(10),' '), CHR(9),' '), 1, 90)
   ORDER BY 2 DESC
) WHERE ROWNUM <= 15;

PROMPT ############################################################
PROMPT [3] TOP 1~3 문장의 실행계획 (SQL_ID 를 [2] 결과값으로 치환해 실행)
PROMPT ############################################################
-- SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('<SQL_ID>', NULL, 'ALLSTATS LAST'));

PROMPT ############################################################
PROMPT [4] 참고 — 이번 실행의 세션 자원 총량
PROMPT ############################################################
SELECT S.NAME, M.VALUE
  FROM V$MYSTAT M JOIN V$STATNAME S ON S.STATISTIC# = M.STATISTIC#
 WHERE S.NAME IN ('session logical reads','CPU used by this session',
                  'redo size','physical reads','table scan rows gotten');

SPOOL OFF
PROMPT
PROMPT 회신: DMF0082_PROFILE_DIV&DIV..txt (division 별 1파일)
PROMPT  ⭐ 적용 전 40·82 + 적용 후 40·81·82 = 총 5회분이 모이면
PROMPT     클라우드 기준 잔여 병목 순위를 확정해 다음 튜닝을 진행합니다
