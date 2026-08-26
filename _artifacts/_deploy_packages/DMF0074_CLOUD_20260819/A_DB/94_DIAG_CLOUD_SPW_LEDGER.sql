--==============================================================================
-- 94_DIAG_CLOUD_SPW_LEDGER.sql — 클라우드 SP_W 스냅샷 원장 실태 세분 (div 40)
--   93 판정: 최신 SP_W_20260806_V001 의 DM_PLN_SALES_PLAN_C 원장 0행 → 템플릿 0건.
--   본 진단: ①어느 버전까지 원장이 있(었)는지 ②08-06 버전은 measure 무관 전무인지
--            ③버전 생성 주체·시각 — 조치(배치 재수행 vs 데이터 이관) 판단 근거.
--   실행: sqlplus SCM_MGR — QA·DEV 양쪽.
--==============================================================================
SET LINESIZE 200 PAGESIZE 200 TRIMSPOOL ON

PROMPT ===== [G0] 환경 =====
SELECT SYS_CONTEXT('USERENV','DB_NAME') AS DB_NAME FROM DUAL;

PROMPT ===== [G1] DM_PLN_SALES_PLAN_C (40) 버전별 행수 — 최근 8 (사내: 20260817=28,085 / 20260730 有) =====
SELECT VERSION_NO, COUNT(*) AS ROWS_CNT
  FROM SCM_MGR.DM_PLN_SALES_PLAN_C
 WHERE DIVISION_ID='40'
 GROUP BY VERSION_NO
 ORDER BY VERSION_NO DESC
 FETCH FIRST 8 ROWS ONLY;

PROMPT ===== [G2] SP_W_20260806_V001 원장 — measure 무관 총량 (0 = 버전 행만 있고 스냅샷 미적재) =====
SELECT COUNT(*) AS TOTAL_ROWS FROM SCM_MGR.DM_PLN_SALES_PLAN_C
 WHERE DIVISION_ID='40' AND VERSION_NO='SP_W_20260806_V001';

PROMPT ===== [G3] (G2>0 인 경우만 의미) measure 별 분포 =====
SELECT MEASURE, COUNT(*) AS CNT
  FROM SCM_MGR.DM_PLN_SALES_PLAN_C
 WHERE DIVISION_ID='40' AND VERSION_NO='SP_W_20260806_V001'
 GROUP BY MEASURE ORDER BY CNT DESC
 FETCH FIRST 15 ROWS ONLY;

PROMPT ===== [G4] DM_MST_VERSION SP_W (40) 최근 5 — 생성 주체·시각 (F1b 대체) =====
SELECT VERSION_NO, YYYYMMDD, ATTRIBUTE7, CREATED_BY,
       TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI') AS CREATED
  FROM SCM_MGR.DM_MST_VERSION
 WHERE DIVISION_ID='40' AND VERSION_TYPE='SP_W'
 ORDER BY VERSION_NO DESC
 FETCH FIRST 5 ROWS ONLY;

PROMPT ===== [G5] 참고 — 테이블 총량 (환경 데이터 규모 감각) =====
SELECT (SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_PLAN_C        WHERE DIVISION_ID='40') AS C_40,
       (SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C WHERE DIVISION_ID='40') AS RESULT_C_40
  FROM DUAL;
--==============================================================================
-- 판독:
--  · G1 에 과거 버전 원장이 있고 08-06 만 0 → 08-06 주간 스냅샷 적재 실패(그 주 배치 문제)
--  · G1 자체가 전부 소량/공백 → 클라우드에 스냅샷 원장 이관·배치가 원래 없던 것
--  → 조치 택1: (A) 클라우드에서 주간 SP_W 스냅샷 생성 프로세스 수행(정석 — 이후 매주 자동)
--             (B) 사내 최신 SP_W_20260817_V001 버전행+원장(28,085행)을 클라우드로 1회 데이터 이관
--==============================================================================
