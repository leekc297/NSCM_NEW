-- =====================================================================================================
-- 92_DIAGNOSE_STEP2.sql — DMF0035 클라우드 0행 2차 적출 (**SELECT 전용**)
--
--   [1차(91) 결과 판독 — 2026-08-20 클라우드 실측]
--     · 메타 3축(SHEET_MEASURE/SHEET_COLUMNS/PROC_M) 사내 기준선과 **정확히 일치** → 적재 문제 아님
--     · TITLESET_USER 자동 시딩도 **정상 동작**(DMF0035 3행 / DMF0022 12행 / DMF0051 9행)
--     · PKG 4본 VALID(08-20 17:18~19) · 원장 데이터 2.6M~51.7M행 · 콤보 4종 Y · GTT 24개(사내와 동수)
--     · 호출은 **42초간 실행되고 예외 없이 종료**(SCM_COM_SQL_LOG 452498)
--       ⚠ `RESULT_COUNT=0` 은 0행의 증거가 아니다 — callProc 은 커서를 세지 않아 사내 정상 호출도 0으로 찍힌다
--   ⇒ 남은 후보는 **조회 조건이 실제로 걸러낸 축**이다. 아래 S1(실제 파라미터) → S2(기간 축) 순으로 본다.
--
--   ⭐ 최유력 가설 — 기간 축(SCM_SYS_CALENDAR_M)
--     PKG_DMF0035 BODY 는 D_/W_/M_ **기간 컬럼 목록 자체를 캘린더에서 생성**하고(L160~195),
--     본문에서도 `INNER JOIN SCM_SYS_CALENDAR_M C ON B.YYYYMMDD = C.BASIS_YYYYMMDD`(L286) 로 조인한다.
--     ⇒ 조회 기간에 캘린더 행이 없으면 **기간 컬럼이 0개 + 데이터 전멸** = 3 TYPE 동시 0행.
--     사내 기준선: 전체 15,340행(2009-01-01~2050-12-31), 20260801~20270228 구간 **212행**(영업일만).
-- =====================================================================================================
SET LINESIZE 250
SET PAGESIZE 300
SET LONG 8000

PROMPT ===== S1. ⭐ 실제 호출 파라미터 전문 (재현의 정본 — 추정 금지) =====
--  division / versionNo / fromYyyymmdd / toYyyymmdd / bucket 을 여기서 확정한다.
SELECT LOG_SEQ, ELAPSED_MS, TO_CHAR(EXECUTE_TIME,'MM-DD HH24:MI:SS') T,
       DBMS_LOB.SUBSTR(PARAMS, 1800, 1) AS PARAMS_HEAD
  FROM SCM_MGR.SCM_COM_SQL_LOG
 WHERE SQL_ID = 'com.lgcns.nscm.callProc'
   AND EXECUTE_TIME > SYSDATE - 1
   AND ELAPSED_MS > 1000            -- 실제 조회 호출만 (경량 호출 제외)
 ORDER BY EXECUTE_TIME DESC FETCH FIRST 3 ROWS ONLY;

PROMPT ===== S2. ⭐⭐ 캘린더 커버리지 (사내: 총 15,340 / 20260801~20270228 구간 212행) =====
SELECT MIN(BASIS_YYYYMMDD) MIN_D, MAX(BASIS_YYYYMMDD) MAX_D, COUNT(*) TOT,
       SUM(CASE WHEN BASIS_YYYYMMDD BETWEEN '20260801' AND '20270228' THEN 1 ELSE 0 END) IN_RANGE,
       CASE WHEN SUM(CASE WHEN BASIS_YYYYMMDD BETWEEN '20260801' AND '20270228' THEN 1 ELSE 0 END) = 0
            THEN '*** FAIL — 기간 컬럼 0개 → 전 TYPE 0행 ***' ELSE 'OK(기간 행 존재)' END VERDICT
  FROM SCM_MGR.SCM_SYS_CALENDAR_M;

PROMPT ===== S2b. 캘린더 월별 분포 + 필수 파생컬럼 NULL 여부 =====
--  ISO_WEEK / BASIS_YYYYMM / BASIS_START_DATE 가 NULL 이면 W_/M_ 컬럼 생성이 깨진다.
SELECT SUBSTR(BASIS_YYYYMMDD,1,6) YM, COUNT(*) CNT,
       SUM(CASE WHEN ISO_WEEK IS NULL THEN 1 ELSE 0 END)          NULL_ISO_WEEK,
       SUM(CASE WHEN BASIS_YYYYMM IS NULL THEN 1 ELSE 0 END)      NULL_YYYYMM,
       SUM(CASE WHEN BASIS_START_DATE IS NULL THEN 1 ELSE 0 END)  NULL_START
  FROM SCM_MGR.SCM_SYS_CALENDAR_M
 WHERE BASIS_YYYYMMDD BETWEEN '20260701' AND '20270331'
 GROUP BY SUBSTR(BASIS_YYYYMMDD,1,6) ORDER BY 1;

PROMPT ===== S3. 버전 축 — 조회에 쓴 버전이 실재하는가 (S1 의 versionNo 와 대조) =====
--  'CURRENT' 는 SP 가 내부 생성하는 가상 버전이라 원장에 없어도 정상. 그 외 값이면 아래에 있어야 한다.
SELECT VERSION_NO, DIVISION_ID, COUNT(*) CNT
  FROM SCM_MGR.DM_PLN_MKT_FCST
 GROUP BY VERSION_NO, DIVISION_ID ORDER BY 3 DESC FETCH FIRST 15 ROWS ONLY;

PROMPT ===== S4. 조회 division 의 원장 데이터 — division·기간 교집합이 실제로 있는가 =====
--  ⚠ S1 에서 확인한 division 으로 바꿔 실행할 것(아래는 40 예시).
SELECT DIVISION_ID,
       SUM(CASE WHEN YYYYMMDD BETWEEN '20260801' AND '20270228' THEN 1 ELSE 0 END) IN_RANGE,
       COUNT(*) TOT
  FROM SCM_MGR.DM_PLN_MKT_FCST
 WHERE DIVISION_ID IN ('40','81','82')
 GROUP BY DIVISION_ID ORDER BY 1;

PROMPT ===== S5. WFITEMPERF 튜닝 의존 축 (SCP 정보 — 비어도 LEFT JOIN 이라 행수 영향 없음. 참고용) =====
SELECT 'SCP_MST_FINAL_ITEM' TB, COUNT(*) CNT FROM SCM_MGR.SCP_MST_FINAL_ITEM
UNION ALL SELECT 'SCM_MST_SITE_ITEM', COUNT(*) FROM SCM_MGR.SCM_MST_SITE_ITEM;

PROMPT ===== S6. 튜닝 마커 — 클라우드 PKG 가 이번 패키지 본문인지 확인 =====
SELECT SUM(CASE WHEN TEXT LIKE '%E20260820-WFITEMPERF%' THEN 1 ELSE 0 END) WFITEMPERF,
       SUM(CASE WHEN UPPER(TEXT) LIKE '%V_MEASURE_SHEET%' THEN 1 ELSE 0 END) V_MEASURE_SHEET
  FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME IN ('PKG_DMF0035','PKG_DMF0022') AND TYPE='PACKAGE BODY';
--  기대: WFITEMPERF 2 (MKT 튜닝 적용본) / V_MEASURE_SHEET 6 (DMF0022 08-06 정본 — 0 이면 구세대 덮어쓰기)

PROMPT ===== 판독 =====
PROMPT   S2 IN_RANGE = 0            → **캘린더 미적재 = 확정 원인**. SCM_SYS_CALENDAR_M 적재 필요
PROMPT   S2b 에 NULL_* > 0          → 캘린더는 있으나 파생컬럼 결손 → W_/M_ 컬럼 생성 실패
PROMPT   S2 OK 인데 S4 IN_RANGE = 0 → 해당 division·기간에 원장 데이터가 없음 (조건 문제)
PROMPT   S3 에 S1 의 versionNo 부재  → 버전 선택 문제 (CURRENT 는 예외)
PROMPT   S6 V_MEASURE_SHEET = 0     → PKG_DMF0022 가 구세대 = SALES PLAN 만 0행이 되는 별개 계보
