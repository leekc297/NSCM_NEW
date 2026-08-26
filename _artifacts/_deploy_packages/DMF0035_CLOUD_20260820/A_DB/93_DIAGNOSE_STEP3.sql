-- =====================================================================================================
-- 93_DIAGNOSE_STEP3.sql — DMF0035 클라우드 0행 3차 (**SELECT 전용**) · 원인 축 = 조회조건 교집합
--
--   [2차(92) 판독 — 2026-08-20 클라우드 실측으로 **아래 축은 전부 배제됨**]
--     · 캘린더 정상: 총 15,340행(2009~2050), 20260801~20270228 **212행**, 파생컬럼 NULL 0 — 사내와 동일
--     · division×기간 원장 교집합 정상: DM_PLN_MKT_FCST div40 **116,533행** in-range
--     · PKG 본문도 이번 패키지분 확정: 마커 `E20260820-WFITEMPERF` 2 / `V_MEASURE_SHEET` 6 (기대치 일치)
--     · 메타·PROC_M·GTT·콤보 전부 정상(91 차수)
--
--   [S1 실제 파라미터 — 재현의 정본]
--     LOG_SEQ 452498 / **42.0초** / `PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL` (= BIZ PLAN)
--     divisionId=40, from=20260801, to=20270228, now=20260817, cellYn=N, qtyYn=N,
--     **versionType = `BP_M_20260807_V002(W32)`**, `@o_rc1: []`(0행), `@O_RESULT_CURSOR: SUCCESS/0`
--     ※ `(W32)` 접미는 SP 가 정상 제거한다(BODY L607~611 `SUBSTR(TOKEN,1,INSTR(TOKEN,'(')-1)`) → 원인 아님
--
--   ⭐ 남은 축은 **INNER JOIN 3개의 교집합**뿐이다 (BIZ 기준, BODY L855~ 실측):
--        DM_PLN_BP_FCST_C A
--          JOIN GT_DM22_SELECT_MEASURE B ON A.MEASURE = B.MEASURE      ← measure 이름 일치 필요
--          INNER JOIN SCM_SYS_CALENDAR_M                                ← 92 에서 정상 확인
--        WHERE A.VERSION_NO IN (SELECT VERSION_NO FROM GT_DM22_V_VERSION_NO)  ← 선택 버전 실재 필요
--     ⇒ ①선택 버전이 원장에 없거나 ②measure 이름이 안 맞으면 **오래 돌고 0행**(지금 증상과 일치).
--
--   사내 기준선(정본, 2026-08-20 실측):
--     · DM_PLN_BP_FCST_C div40/202608~202702 버전 = BP_M_20260810_V001(85,427) / BP_M_20260805_V001(85,426) 등 6종
--       ⚠ **`BP_M_20260807_V002` 는 사내에 없다** — 클라우드 전용 버전이므로 클라우드에서 직접 확인해야 한다
--     · measure 교집합 = 9종 중 **7 HIT**(Business_Plan/KRW/LOC/SalesAmt_KRW/SalesAmt_LOC/SalesAmt_USD/USD),
--       2 MISS(CAR_QTY/MKT_FCST — 원장에 그 measure 자체가 없음. 정상)
-- =====================================================================================================
SET LINESIZE 220
SET PAGESIZE 200

PROMPT ===== T1. ⭐⭐ BIZ — 선택한 버전이 원장에 실재하는가 (0행이면 **원인 확정**) =====
SELECT VERSION_NO, COUNT(*) CNT
  FROM SCM_MGR.DM_PLN_BP_FCST_C
 WHERE DIVISION_ID = '40'
   AND YYYYMM BETWEEN '202608' AND '202702'
 GROUP BY VERSION_NO
 ORDER BY 2 DESC FETCH FIRST 12 ROWS ONLY;

PROMPT ===== T1b. BIZ — 화면이 보낸 그 버전 정확 일치 확인 =====
SELECT COUNT(*) AS ROWS_FOR_SELECTED_VERSION
  FROM SCM_MGR.DM_PLN_BP_FCST_C
 WHERE DIVISION_ID = '40'
   AND VERSION_NO = 'BP_M_20260807_V002'      -- ⚠ S1 파라미터에서 '(W32)' 제거한 값
   AND YYYYMM BETWEEN '202608' AND '202702';

PROMPT ===== T2. ⭐ BIZ — measure 교집합 (사내 기준선: 9종 중 7 HIT) =====
--  TITLESET_USER 의 measure 이름이 원장 MEASURE 값과 하나도 안 맞으면 JOIN 에서 전멸한다.
SELECT U.COLUMN_NAME,
       CASE WHEN EXISTS (SELECT 1 FROM SCM_MGR.DM_PLN_BP_FCST_C L
                          WHERE L.MEASURE = U.COLUMN_NAME
                            AND L.DIVISION_ID = '40'
                            AND L.YYYYMM BETWEEN '202608' AND '202702')
            THEN 'HIT' ELSE 'MISS' END AS MATCH_
  FROM SCM_MGR.SCM_MST_TITLESET_USER U
 WHERE U.PROGRAM_ID = 'DMF0051'
   AND U.SHEET_NAME = 'Biz Plan Waterfall'
   AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
   AND U.USER_ID = 'minyonglee1'
 ORDER BY 1;

PROMPT ===== T3. BIZ 원장에 실제 존재하는 measure 목록 (T2 가 전부 MISS 일 때 대조용) =====
SELECT MEASURE, COUNT(*) CNT
  FROM SCM_MGR.DM_PLN_BP_FCST_C
 WHERE DIVISION_ID = '40' AND YYYYMM BETWEEN '202608' AND '202702'
 GROUP BY MEASURE ORDER BY 2 DESC FETCH FIRST 15 ROWS ONLY;

PROMPT ===== T4. MKT — 같은 조건에서 데이터가 잡히는가 (MKT 는 버전 개념이 다름) =====
SELECT DIVISION_ID, COUNT(*) CNT, MIN(YYYYMMDD) MIN_D, MAX(YYYYMMDD) MAX_D
  FROM SCM_MGR.DM_PLN_MKT_FCST
 WHERE DIVISION_ID = '40' AND YYYYMMDD BETWEEN '20260801' AND '20270228'
 GROUP BY DIVISION_ID;

PROMPT ===== T4b. MKT — measure 교집합 (TITLESET 'mktFcstWaterfall' 3행 기준) =====
SELECT U.COLUMN_NAME,
       CASE WHEN EXISTS (SELECT 1 FROM SCM_MGR.DM_PLN_MKT_FCST L
                          WHERE L.MEASURE = U.COLUMN_NAME AND L.DIVISION_ID = '40'
                            AND L.YYYYMMDD BETWEEN '20260801' AND '20270228')
            THEN 'HIT' ELSE 'MISS' END AS MATCH_
  FROM SCM_MGR.SCM_MST_TITLESET_USER U
 WHERE U.PROGRAM_ID = 'DMF0035' AND U.SHEET_NAME = 'mktFcstWaterfall'
   AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M' AND U.USER_ID = 'minyonglee1'
 ORDER BY 1;

PROMPT ===== T5. SALES — 같은 조건 =====
SELECT DIVISION_ID, COUNT(*) CNT
  FROM SCM_MGR.DM_PLN_SALES_PLAN
 WHERE DIVISION_ID = '40' AND YYYYMMDD BETWEEN '20260801' AND '20270228'
 GROUP BY DIVISION_ID;

PROMPT ===== 판독 =====
PROMPT   T1b = 0                     → **선택한 버전에 데이터 없음 = 원인 확정**. T1 목록의 버전으로 재조회
PROMPT   T2 전부 MISS                → measure 이름 불일치 = 원인. T3 목록과 대조해 TITLESET/SHEET_MEASURE 정정
PROMPT   T1b > 0 이고 T2 에 HIT 존재  → BIZ 는 나와야 정상 → SP 실행 축 재점검(다음 단계)
PROMPT   T4/T5 가 0                  → 해당 TYPE 은 원장 데이터 자체가 없음(조건 문제)
