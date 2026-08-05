-- =============================================================================
-- 07_DMF0003_AFTER.sql — 커서 재파싱 후 효과 측정
--   ⚠ 선행 조건: 06 실행 → **화면에서 DMF0003 조회를 다시 실행** → 그 다음 이 파일
--      (조회를 다시 안 하면 커서가 없어 아무것도 안 나옵니다)
-- =============================================================================
SET LINESIZE 300
SET PAGESIZE 5000
SET LONG 500000
SET LONGCHUNKSIZE 500000
SET TRIMSPOOL ON
SET FEEDBACK ON

SPOOL DMF0003_NEXT_AFTER.txt

PROMPT ############################################################
PROMPT [1] 재파싱된 커서 — PHV 가 바뀌었는가
PROMPT ############################################################
SELECT SQL_ID, CHILD_NUMBER CH, PLAN_HASH_VALUE PHV,
       TO_CHAR(FIRST_LOAD_TIME) FIRST_LOAD,
       EXECUTIONS EX, ROUND(ELAPSED_TIME/1e6/GREATEST(EXECUTIONS,1),2) S_PER_EX,
       BUFFER_GETS BG, DISK_READS DR, ROWS_PROCESSED RP
  FROM V$SQL WHERE SQL_ID='fquabykr25nyy' ORDER BY CHILD_NUMBER;
-- ⭐ 판정
--   PHV 3515833160 → **다른 값** + S_PER_EX 급감  = PURGE 로 해결 (여기서 종료)
--   PHV 그대로 3515833160                          = 계획이 재현됨 → [2] 계획 분석 필요
--   사내 기준: PHV 1590849756 / 0.10초 / BG 21,865

PROMPT ############################################################
PROMPT [2] 새 실행계획 (실측 A-Rows 포함)
PROMPT ############################################################
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('fquabykr25nyy', NULL,
       'ALLSTATS LAST +COST +BYTES +PREDICATE'));
-- ⭐ 확인 4가지
--   ① E-Rows 와 A-Rows 가 크게 어긋나는 라인 = 카디널리티 오추정 지점
--   ② DM_PLN_MKT_FCST 접근 = INDEX RANGE SCAN / TABLE ACCESS FULL 중 무엇인가
--   ③ NESTED LOOPS 의 Starts 가 수만~수십만이면 그 조인이 범인
--   ④ GT_DMF0003_LAST_DATA_SETUP · GT_DMF0003_EDI_SENDER 의 Starts
--      = 행별 스칼라 서브쿼리 반복 실행 횟수 (크면 이게 CPU 를 태우는 원인)

PROMPT ############################################################
PROMPT [3] 화면 전체 소요 재측정 — 다른 SQL 로 병목이 옮겨갔는지
PROMPT ############################################################
SELECT * FROM (
  SELECT SQL_ID, PLAN_HASH_VALUE PHV, EXECUTIONS EX,
         ROUND(ELAPSED_TIME/1e6/GREATEST(EXECUTIONS,1),2) S_PER_EX,
         BUFFER_GETS BG, DISK_READS DR, ROWS_PROCESSED RP,
         SUBSTR(REGEXP_REPLACE(SQL_TEXT,'\s+',' '),1,66) T
    FROM V$SQL
   WHERE LAST_ACTIVE_TIME > SYSDATE - 1/48
     AND (UPPER(SQL_TEXT) LIKE '%GT_DMF0003%' OR UPPER(SQL_TEXT) LIKE '%GT_ANLO%'
       OR UPPER(SQL_TEXT) LIKE '%DM_ANL_MKT_PSI%')
   ORDER BY ELAPSED_TIME DESC
) WHERE ROWNUM <= 15;
-- 사내 기준 상위: d0hxg387f395t 2.74초 / 8fzdju31p9htc 1.98 / 8kfydzds35fy2 0.71
--                 fd8sm6x0qyg3g 0.53 / 나머지 0.1~0.2초대 (합계 약 3초)

PROMPT ############################################################
PROMPT [4] 대기 이벤트 — CPU 지배가 해소됐는가
PROMPT ############################################################
SELECT * FROM (
  SELECT NVL(EVENT,'ON CPU') EVENT, WAIT_CLASS, COUNT(*) SAMPLES
    FROM V$ACTIVE_SESSION_HISTORY
   WHERE SAMPLE_TIME > SYSTIMESTAMP - INTERVAL '15' MINUTE
   GROUP BY NVL(EVENT,'ON CPU'), WAIT_CLASS ORDER BY 3 DESC
) WHERE ROWNUM <= 12;
-- 직전 클라우드: ON CPU 265 지배 (디스크 아님)

SPOOL OFF

PROMPT
PROMPT =============================================================
PROMPT 07 완료 — 출력 파일: DMF0003_NEXT_AFTER.txt
PROMPT  DMF0003_NEXT_BEFORE.txt 와 함께 2개 회신 부탁드립니다.
PROMPT =============================================================
