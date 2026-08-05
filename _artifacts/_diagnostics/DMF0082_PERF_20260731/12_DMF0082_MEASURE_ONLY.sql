-- =============================================================================
-- 12_DMF0082_MEASURE_ONLY.sql — ⚠ **측정 전용. 아무것도 변경하지 않습니다.**
--
--   목표: 클라우드 DMF0082 **20초 → 5초 이내**
--   ⚠ 사내가 이미 **10초**이므로 5초는 사내보다 빠른 목표입니다.
--      통계 조정만으로는 도달 불가 — 어디에 시간이 쓰이는지 먼저 정확히 알아야 합니다.
--
--   ⛔ 직전 사고(LOCK_TABLE_STATS → ORA-20005) 재발 방지를 위해
--      이번에는 **측정 → 보고 → 합의 → 적용** 순서로 갑니다. 이 파일은 측정만 합니다.
--
--   실행: DMF0082 조회를 **1회 실행한 직후** (같은 세션 아니어도 됨). 계정 SCM_MGR
-- =============================================================================
SET LINESIZE 240
SET PAGESIZE 400
SET TRIMSPOOL ON
COLUMN T FORMAT A60
COLUMN TABLE_NAME FORMAT A36

SPOOL DMF0082_MEASURE.txt

PROMPT ############################################################
PROMPT [1] ⭐ 현재 상태 확정 — 10 번 스크립트의 잔재가 무엇인가
PROMPT ############################################################
PROMPT --- [1-A] 통계 잠금 잔존 (기대: 0행. 있으면 즉시 UNLOCK 필요)
SELECT s.TABLE_NAME, s.STATTYPE_LOCKED
  FROM USER_TAB_STATISTICS s
  JOIN USER_TABLES u ON u.TABLE_NAME = s.TABLE_NAME AND u.TEMPORARY='Y'
 WHERE s.STATTYPE_LOCKED IS NOT NULL;

PROMPT --- [1-B] 통계가 설정된 GTT (10 번이 남긴 것 + DMF0003 분)
SELECT TABLE_NAME, NUM_ROWS, BLOCKS, AVG_ROW_LEN,
       DBMS_STATS.GET_PREFS('GLOBAL_TEMP_TABLE_STATS','SCM_MGR',TABLE_NAME) PREF,
       TO_CHAR(LAST_ANALYZED,'MM-DD HH24:MI') ANZ
  FROM USER_TABLES WHERE TEMPORARY='Y' AND NUM_ROWS IS NOT NULL
 ORDER BY LAST_ANALYZED DESC;
-- ⭐ 판정: GT_DMF0082_* / GT_PRDM1_* / GT_FTPR_* 가 보이면 10 번 잔재가 남아 있는 것.
--         SP 가 스스로 GATHER 하는 GTT 라면 매 실행마다 덮어써지므로 무해하지만,
--         그렇지 않은 GTT 는 고정값이 남아 계획에 영향을 줍니다.

PROMPT --- [1-C] SP 가 스스로 GATHER 하는 GTT (건드리면 안 되는 목록)
SELECT DISTINCT REGEXP_SUBSTR(UPPER(TEXT),'TABNAME\s*=>\s*''([A-Z0-9_]+)''',1,1,'i',1) GTT_SELF_GATHER
  FROM USER_SOURCE
 WHERE TYPE='PACKAGE BODY' AND NAME='PKG_DMF0082'
   AND TRIM(TEXT) NOT LIKE '--%' AND REGEXP_LIKE(TEXT,'GATHER_TABLE_STATS','i')
 ORDER BY 1;
-- 사내 실측: PKG_DMF0082 는 GATHER 를 40회 호출(대상 37본). 이들은 세션 통계가
-- 매 실행 갱신되므로 **고정 통계도 LOCK 도 불필요**합니다.

PROMPT ############################################################
PROMPT [2] ⭐⭐ 20초의 내역 — 조회 직후 실행
PROMPT ############################################################
SELECT * FROM (
  SELECT SQL_ID, PLAN_HASH_VALUE PHV, EXECUTIONS EX,
         ROUND(ELAPSED_TIME/1e6,2) TOT_S,
         ROUND(ELAPSED_TIME/1e6/GREATEST(EXECUTIONS,1),2) S_PER_EX,
         ROUND(CPU_TIME/1e6,2) CPU_S,
         BUFFER_GETS BG, DISK_READS DR, ROWS_PROCESSED RP,
         SUBSTR(REGEXP_REPLACE(SQL_TEXT,'\s+',' '),1,60) T
    FROM V$SQL
   WHERE LAST_ACTIVE_TIME > SYSDATE - 1/48
     AND (UPPER(SQL_TEXT) LIKE '%GT_DMF0082%' OR UPPER(SQL_TEXT) LIKE '%GTT_MF_SP%'
       OR UPPER(SQL_TEXT) LIKE '%GT_PRDM1%'   OR UPPER(SQL_TEXT) LIKE '%GT_FTPR%'
       OR UPPER(SQL_TEXT) LIKE '%GTT_TEMP%'   OR UPPER(SQL_TEXT) LIKE '%PKG_DMF0082%')
   ORDER BY ELAPSED_TIME DESC
) WHERE ROWNUM <= 25;
-- ⭐ 사내 기준선 (10초 / 상위 12건, 참고용):
--   8bku8q77ab48v 0.35초x7 BG 217,122  INSERT GT_DMF0082_MST_ITEM_SINGLE_ORI_V
--   5rmzj9wg8tvhr 2.32초x1 BG  20,224  SELECT (DIVISION_ID, DIVISION_NAME, UPPER_...)
--   553u2hmbmd63d 1.39초x1 BG   5,784  INSERT /*+ APPEND PARALLEL(4) */ GT_DMF0082_MF_SP
--   6tsng6uzsmjk5 1.33초x1 BG  85,854  INSERT GT_FTPR_TMPOUTPUTALL
--   39zy6yw60vt62 1.29초x1 BG  44,066  INSERT GT_DMF0082_T_LAST_DATA_SETUP_PRICE
--   5cj6byz57ugdp 1.28초x1 BG  90,488  INSERT GT_FTPR_SCM_MST_FUTURE_PRICE
--   676qd81wgsa4f 1.28초x1 BG  47,964  INSERT GT_FTPR_TMPOUTPUTOMISSION
--   3a8jzvxnc57hz 1.22초x1 BG 140,107  INSERT GT_DMF0082_TEMP_FCST_N_PRICE
--   71qhktf3y9k5x 0.57초x2 BG 172,595  INSERT GT_FTPR_TMPOUTPUT
--   cd0qf5t6wstq8 0.43초x2 BG  47,781  MERGE GT_FTPR_TMPOUTPUT
--   bkdmskr8tsvdw 0.41초x2 BG  51,951  INSERT GT_FTPR_TMPOUTPUT
--
-- ⭐⭐ 읽는 법 — **사내는 단일 병목이 없습니다.** 1~2초짜리 단계가 10여 개 쌓여 10초입니다.
--     따라서 클라우드 20초도 "하나만 고치면 되는" 구조가 아닐 가능성이 큽니다.
--     ① 사내보다 **유독 몇 배 느린 SQL** 이 있으면 → 그것부터 (계획/통계 문제)
--     ② 전 단계가 고르게 2배면 → **데이터량 차이**(클라우드가 6~22배)가 주 원인
--        → 이 경우 5초 도달은 **SP 구조 개선** 없이는 불가능

PROMPT ############################################################
PROMPT [3] 총 소요 합계 (단계 누적치)
PROMPT ############################################################
SELECT ROUND(SUM(ELAPSED_TIME)/1e6, 1) TOTAL_SEC, COUNT(*) SQL_CNT
  FROM V$SQL
 WHERE LAST_ACTIVE_TIME > SYSDATE - 1/48
   AND (UPPER(SQL_TEXT) LIKE '%GT_DMF0082%' OR UPPER(SQL_TEXT) LIKE '%GT_PRDM1%'
     OR UPPER(SQL_TEXT) LIKE '%GT_FTPR%'    OR UPPER(SQL_TEXT) LIKE '%GTT_MF_SP%');
-- 화면 체감 20초와 이 합계를 비교 → 차이가 크면 DB 밖(BE/네트워크/FE 렌더링) 요인

PROMPT ############################################################
PROMPT [4] 대기 이벤트
PROMPT ############################################################
SELECT * FROM (
  SELECT NVL(EVENT,'ON CPU') EVENT, WAIT_CLASS, COUNT(*) SAMPLES
    FROM V$ACTIVE_SESSION_HISTORY
   WHERE SAMPLE_TIME > SYSTIMESTAMP - INTERVAL '15' MINUTE
   GROUP BY NVL(EVENT,'ON CPU'), WAIT_CLASS ORDER BY 3 DESC
) WHERE ROWNUM <= 12;

PROMPT ############################################################
PROMPT [5] 조회 경로 단계 수 (구조 개선 여지 판단)
PROMPT ############################################################
SELECT COUNT(*) GTT_DML_STEPS
  FROM USER_SOURCE
 WHERE TYPE='PACKAGE BODY' AND NAME='PKG_DMF0082'
   AND TRIM(TEXT) NOT LIKE '--%'
   AND REGEXP_LIKE(TEXT,'(INSERT\s+(/\*.*?\*/\s*)?INTO|MERGE\s+INTO)\s+(SCM_MGR\.)?GTT?_','i');
-- 단계가 많을수록 각 단계의 왕복·중간결과 적재 비용이 누적됩니다.

SPOOL OFF

PROMPT
PROMPT =============================================================
PROMPT 회신 요망: DMF0082_MEASURE.txt
PROMPT  + 화면 체감 소요(초), 사용한 division / 조회조건
PROMPT ⚠ 이번엔 측정 결과를 보고 **무엇을 바꿀지 합의한 뒤** 적용하겠습니다.
PROMPT =============================================================
