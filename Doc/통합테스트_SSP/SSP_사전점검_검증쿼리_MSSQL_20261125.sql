-- ==============================================================================================================
-- SSP 통합테스트 시나리오(e2e) 사전점검 단계 검증쿼리 · MSSQL(AS-IS) · 13개
-- 시험일(PLAN_DATE) = 20261125 · 계획 시작일 : 40 · 전극 = 20261125, 81·82 · Packer · 통합 스냅샷 = 20261124(시험일 - 1)
-- 실행 : DBeaver 에서 쿼리 하나씩(커서를 쿼리 안에 두고 Ctrl+Enter). 값을 바꿀 때는 각 쿼리 맨 위 WITH PRM 줄만 고침
-- 조회만 수행(변경 문장 없음). 번호 = 통합테스트 시나리오 「검증쿼리(사전점검)」 시트의 ID
-- 같은 번호의 Oracle(TO-BE) 쿼리와 결과 열 이름 · 정렬이 같음. AS-IS 운영 DB 에서 실행. VQ-42 는 뷰 전체를 계산하므로 업무 시간을 피해 실행
-- 생성 2026-11-25 10:52 · tools/Analysis/ssp_it_precheck/gen_sql_files.py
-- ==============================================================================================================

-- 목차
--   VQ-41  사업부별 재고 테이블 기준일 자료 존재 · 수신 시각
--   VQ-42  법인별 전일 ERP 재고(INVENTORY) 건수 · 수량
--   VQ-43  산출 입력 자료 최종 생성 일시
--   VQ-45  40 출하계획 산출 결과 구성(법인 · Measure 별)
--   VQ-47  81·82 OWMS 재고 마감 자료(법인 · 사업부 별)
--   VQ-48  81·82 출하계획 마감 결과 구성(법인 · 사업부 · Measure 별)
--   VQ-50  Packer 출하계획 산출 결과 구성(Measure 별)
--   VQ-52  전극 출하계획 산출 결과 구성(법인 · 사업부 · Measure 별)
--   VQ-53  전극 기초재고 마감 · 재고 상세 마감(법인 별)
--   VQ-55  통합 스냅샷 결과(사업부 · 법인 별)
--   VQ-56  산출 배치가 만든 확정 원장(사업부 · 상태 별)
--   VQ-27  출하요청 3종(SEMI · FG / Packer / 전극) 품목별 수량 (검증쿼리 시트 VQ-27 와 같은 쿼리 · AS-IS 대조용)
--   VQ-31  출하계획 테이블별 기준일 건수 · 수량 (검증쿼리 시트 VQ-31 와 같은 쿼리 · AS-IS 대조용)

-- ==============================================================================================================
-- [VQ-41] 사업부별 재고 테이블 기준일 자료 존재 · 수신 시각
-- 분류 : 재고
-- 대상 : SSP_DNM_OWMS_STOCK · SSP_DNM_GMES_STOCK_81_82 · SSP_DNM_GMES_STOCK_EE · SSP_DNM_IWMS_STOCK_EE · SSP_DNM_OWMS_STOCK_EE · SSP_DNM_GMES_STOCK_40 · SSP_DNM_STOCK_C · SCM_DNM_SCS_STOCK
-- 확인 : 9행 모두 ROW_CNT 1건 이상, LAST_CREATED 가 시험일(Packer 기초재고 행은 시험일 - 2 이전 수신분). 기준일 규칙 = 「SSP 프로세스 확인 내용」 2026-11-20 판 8번 슬라이드
-- 사용 : 사전점검 No 8(사업부별 재고 I/F 수신 확인) / 사전점검 No 8(사업부별 재고 I/F 수신 확인)
-- ==============================================================================================================
WITH PRM0 AS (SELECT '20261125' AS P_TEST_DATE)   /* 시험일. 이 줄의 값만 바꿔 실행 */
   , PRM AS (SELECT P_TEST_DATE, CONVERT(CHAR(8), DATEADD(DAY, -1, CONVERT(DATE, P_TEST_DATE, 112)), 112) AS P_D1, CONVERT(CHAR(8), DATEADD(DAY, -3, CONVERT(DATE, P_TEST_DATE, 112)), 112) AS P_D3 FROM PRM0)
SELECT X.UNIT
     , X.TABLE_NAME
     , X.DATA_DATE_RULE
     , CONVERT(CHAR(8), DATEADD(DAY, -X.DAY_OFFSET, CONVERT(DATE, (SELECT P_TEST_DATE FROM PRM), 112)), 112) AS DATA_DATE
     , X.ROW_CNT
     , X.LAST_CREATED
  FROM (SELECT N'81·82 · 40' AS UNIT, 'SSP_DNM_OWMS_STOCK' AS TABLE_NAME, N'전일' AS DATA_DATE_RULE, 1 AS DAY_OFFSET, COUNT(*) AS ROW_CNT, MAX(CREATION_DATE) AS LAST_CREATED
          FROM SSP_DNM_OWMS_STOCK WITH (NOLOCK) WHERE CUTOFF_DATE = (SELECT P_D1 FROM PRM)
         UNION ALL
        SELECT N'81·82', 'SSP_DNM_GMES_STOCK_81_82', N'당일', 0, COUNT(*), MAX(CREATION_DATE)
          FROM SSP_DNM_GMES_STOCK_81_82 WITH (NOLOCK) WHERE YYYYMMDD = (SELECT P_TEST_DATE FROM PRM)
         UNION ALL
        SELECT N'전극', 'SSP_DNM_GMES_STOCK_EE', N'당일', 0, COUNT(*), MAX(CREATION_DATE)
          FROM SSP_DNM_GMES_STOCK_EE WITH (NOLOCK) WHERE YYYYMMDD = (SELECT P_TEST_DATE FROM PRM)
         UNION ALL
        SELECT N'전극', 'SSP_DNM_IWMS_STOCK_EE', N'당일', 0, COUNT(*), MAX(CREATION_DATE)
          FROM SSP_DNM_IWMS_STOCK_EE WITH (NOLOCK) WHERE YYYYMMDD = (SELECT P_TEST_DATE FROM PRM)
         UNION ALL
        SELECT N'전극', 'SSP_DNM_OWMS_STOCK_EE', N'당일', 0, COUNT(*), MAX(CREATION_DATE)
          FROM SSP_DNM_OWMS_STOCK_EE WITH (NOLOCK) WHERE YYYYMMDD = (SELECT P_TEST_DATE FROM PRM)
         UNION ALL
        SELECT N'40', 'SSP_DNM_GMES_STOCK_40', N'당일', 0, COUNT(*), MAX(CREATION_DATE)
          FROM SSP_DNM_GMES_STOCK_40 WITH (NOLOCK) WHERE YYYYMMDD = (SELECT P_TEST_DATE FROM PRM)
         UNION ALL
        SELECT N'40', 'SSP_DNM_STOCK_C', N'전일', 1, COUNT(*), MAX(CREATION_DATE)
          FROM SSP_DNM_STOCK_C WITH (NOLOCK) WHERE CUTOFF_DATE = CONVERT(DATETIME, (SELECT P_D1 FROM PRM), 112)
         UNION ALL
        SELECT N'Packer', 'SCM_DNM_SCS_STOCK', N'전일(수신분)', 1, COUNT(*), MAX(CREATION_DATE)
          FROM SCM_DNM_SCS_STOCK WITH (NOLOCK) WHERE CUTOFF_DATE = (SELECT P_D1 FROM PRM)
         UNION ALL
        SELECT N'Packer', 'SCM_DNM_SCS_STOCK', N'시험일 - 3(산출 기초재고)', 3, COUNT(*), MAX(CREATION_DATE)
          FROM SCM_DNM_SCS_STOCK WITH (NOLOCK) WHERE CUTOFF_DATE = (SELECT P_D3 FROM PRM)) X;

-- ==============================================================================================================
-- [VQ-42] 법인별 전일 ERP 재고(INVENTORY) 건수 · 수량
-- 분류 : 재고
-- 대상 : SCM_DNM_STOCK_V
-- 확인 : 81·82 컷오프 대상 법인마다 1건 이상. 0건(조회 안 됨) 법인은 컷오프가 진행되지 않음
-- 사용 : 사전점검 No 9(법인별 전일 ERP 재고 생성 확인) / 사전점검 No 9(법인별 전일 ERP 재고 생성 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_TEST_DATE)   /* 시험일. 이 줄의 값만 바꿔 실행 */
SELECT COMPANY_ID
     , CONVERT(CHAR(8), CUTOFF_DATE, 112) AS CUTOFF_DATE
     , COUNT(*) AS ROW_CNT
     , COUNT(DISTINCT ITEM_ID) AS ITEM_CNT
     , SUM(SSP_QTY) AS SSP_QTY
  FROM SCM_DNM_STOCK_V WITH (NOLOCK)
   CROSS JOIN PRM
 WHERE CUTOFF_DATE = DATEADD(DAY, -1, CONVERT(DATETIME, PRM.P_TEST_DATE, 112))
   AND STOCK_TYPE = 'INVENTORY'
 GROUP BY COMPANY_ID
        , CONVERT(CHAR(8), CUTOFF_DATE, 112)
 ORDER BY COMPANY_ID;

-- ==============================================================================================================
-- [VQ-43] 산출 입력 자료 최종 생성 일시
-- 분류 : 계획 입력
-- 대상 : SSP_DNM_FP_PLAN_FROZEN · SSP_DNM_FP_AMEND_SHIPAVAL · SCM_DNM_SCS_PROD_PLAN · SCM_DNM_SCS_STOCK
-- 확인 : 4행 모두 LAST_CREATED 가 시험일. FP 확정 생산계획은 81·82 · 40 · 전극 산출이, SCS 자료는 Packer 산출이 읽음
-- 사용 : 사전점검 No 10(산출 입력 자료 갱신 확인) / 사전점검 No 10(산출 입력 자료 갱신 확인)
-- ==============================================================================================================
WITH PRM0 AS (SELECT '20261125' AS P_TEST_DATE)   /* 시험일. 이 줄의 값만 바꿔 실행 */
   , PRM AS (SELECT P_TEST_DATE, CONVERT(CHAR(8), DATEADD(DAY, -3, CONVERT(DATE, P_TEST_DATE, 112)), 112) AS P_D3 FROM PRM0)
SELECT 'SSP_DNM_FP_PLAN_FROZEN' AS TABLE_NAME, N'FP 확정 생산계획' AS DATA_NAME
     , COUNT(*) AS ROW_CNT, MIN(PLAN_DATE) AS MIN_DATE, MAX(PLAN_DATE) AS MAX_DATE, MAX(CREATION_DATE) AS LAST_CREATED
  FROM SSP_DNM_FP_PLAN_FROZEN WITH (NOLOCK)
 UNION ALL
SELECT 'SSP_DNM_FP_AMEND_SHIPAVAL', N'FP 출하가능량'
     , COUNT(*), MIN(PLAN_DATE), MAX(PLAN_DATE), MAX(CREATION_DATE)
  FROM SSP_DNM_FP_AMEND_SHIPAVAL WITH (NOLOCK)
 UNION ALL
SELECT 'SCM_DNM_SCS_PROD_PLAN', N'SCS 생산계획'
     , COUNT(*), MIN(PROD_DATE), MAX(PROD_DATE), MAX(CREATION_DATE)
  FROM SCM_DNM_SCS_PROD_PLAN WITH (NOLOCK)
   CROSS JOIN PRM
 WHERE CUTOFF_DATE >= PRM.P_D3
 UNION ALL
SELECT 'SCM_DNM_SCS_STOCK', N'SCS 재고'
     , COUNT(*), MIN(CUTOFF_DATE), MAX(CUTOFF_DATE), MAX(CREATION_DATE)
  FROM SCM_DNM_SCS_STOCK WITH (NOLOCK)
   CROSS JOIN PRM
 WHERE CUTOFF_DATE >= PRM.P_D3;

-- ==============================================================================================================
-- [VQ-45] 40 출하계획 산출 결과 구성(법인 · Measure 별)
-- 분류 : 일 산출
-- 대상 : SSP_ANL_SHIP_PLAN_40
-- 확인 : 계획 시작일 = 시험일. 법인(HQ00 · AZ00 · NJ00)마다 행 생성, 기간 = 계획 시작일 - 1 ~ + 83일. AS-IS 같은 기준일 결과와 건수 · 수량 대조
-- 사용 : 사전점검 No 15(재고 수신 확인 미충족 상태에서 40 출하계획 생성 실행 → 건너뜀 확인) / 사전점검 No 17(40 출하계획 생성 결과 구성 확인) / 사전점검 No 19(40 산출 결과 AS-IS 같은 기준일 대조) / 사전점검 No 19(40 산출 결과 AS-IS 같은 기준일 대조) / 사전점검 No 19(40 산출 결과 AS-IS 같은 기준일 대조) / 사전점검 No 20(같은 날 40 산출 재실행 시 중복 생성 없음 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_PLAN_START)   /* 계획 시작일 = 시험일. 이 줄의 값만 바꿔 실행 */
SELECT ATTRIBUTE10 AS COMPANY_ID
     , MEASURE
     , COUNT(*) AS ROW_CNT
     , COUNT(DISTINCT ITEM_ID) AS ITEM_CNT
     , MIN(YYYYMMDD) AS MIN_DATE
     , MAX(YYYYMMDD) AS MAX_DATE
     , SUM(QTY) AS QTY
     , MAX(LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
  FROM SSP_ANL_SHIP_PLAN_40 WITH (NOLOCK)
   CROSS JOIN PRM
 WHERE DIVISION_ID = '40'
   AND PLAN_START_YYYYMMDD = PRM.P_PLAN_START
 GROUP BY ATTRIBUTE10
        , MEASURE
 ORDER BY ATTRIBUTE10
        , MEASURE;

-- ==============================================================================================================
-- [VQ-47] 81·82 OWMS 재고 마감 자료(법인 · 사업부 별)
-- 분류 : 일 산출
-- 대상 : SSP_ANL_OWMS_STOCK_C2
-- 확인 : 컷오프 완료 법인마다 행 존재. CUTOFF_DATE = 시험일 - 1, PLAN_START_YYYYMMDD = 시험일, 최종 변경자 ssp_batch
-- 사용 : 사전점검 No 23(OWMS 재고 마감 자료 생성 확인) / 사전점검 No 23(OWMS 재고 마감 자료 생성 확인) / 사전점검 No 27(같은 날 81·82 컷오프 재실행 시 중복 생성 없음 확인)
-- ==============================================================================================================
WITH PRM0 AS (SELECT '20261125' AS P_TEST_DATE)   /* 시험일. 이 줄의 값만 바꿔 실행 */
   , PRM AS (SELECT P_TEST_DATE, CONVERT(CHAR(8), DATEADD(DAY, -1, CONVERT(DATE, P_TEST_DATE, 112)), 112) AS P_D1 FROM PRM0)
SELECT COMPANY_ID
     , DIVISION_ID
     , CUTOFF_DATE
     , PLAN_START_YYYYMMDD
     , COUNT(*) AS ROW_CNT
     , COUNT(DISTINCT ITEM_ID) AS ITEM_CNT
     , SUM(STOCK_QTY) AS STOCK_QTY
     , SUM(AVAILABLE_QTY) AS AVAILABLE_QTY
     , MAX(LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
  FROM SSP_ANL_OWMS_STOCK_C2 WITH (NOLOCK)
   CROSS JOIN PRM
 WHERE CUTOFF_DATE = PRM.P_D1
   AND PLAN_START_YYYYMMDD = PRM.P_TEST_DATE
 GROUP BY COMPANY_ID
        , DIVISION_ID
        , CUTOFF_DATE
        , PLAN_START_YYYYMMDD
 ORDER BY COMPANY_ID
        , DIVISION_ID;

-- ==============================================================================================================
-- [VQ-48] 81·82 출하계획 마감 결과 구성(법인 · 사업부 · Measure 별)
-- 분류 : 일 산출
-- 대상 : SSP_ANL_SHIP_PLAN_C
-- 확인 : 계획 시작일 = 시험일 - 1. 법인 · 사업부마다 Measure 7종, 기간 = 계획 시작일 ~ + 55일(56일). AS-IS 같은 기준일 결과와 건수 · 수량 대조
-- 사용 : 사전점검 No 21(진입 조건 미충족 법인 건너뜀 확인) / 사전점검 No 24(81·82 출하계획 마감 결과 구성 확인) / 사전점검 No 26(81·82 산출 결과 AS-IS 같은 기준일 대조) / 사전점검 No 26(81·82 산출 결과 AS-IS 같은 기준일 대조) / 사전점검 No 26(81·82 산출 결과 AS-IS 같은 기준일 대조) / 사전점검 No 27(같은 날 81·82 컷오프 재실행 시 중복 생성 없음 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261124' AS P_PLAN_START)   /* 계획 시작일 = 시험일 - 1. 이 줄의 값만 바꿔 실행 */
SELECT COMPANY_ID
     , DIVISION_ID
     , MEASURE
     , COUNT(*) AS ROW_CNT
     , COUNT(DISTINCT ITEM_ID) AS ITEM_CNT
     , COUNT(DISTINCT YYYYMMDD) AS DAY_CNT
     , MIN(YYYYMMDD) AS MIN_DATE
     , MAX(YYYYMMDD) AS MAX_DATE
     , SUM(QTY) AS QTY
     , MAX(LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
  FROM SSP_ANL_SHIP_PLAN_C WITH (NOLOCK)
   CROSS JOIN PRM
 WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START
   AND DIVISION_ID IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION WITH (NOLOCK))
   AND COMPANY_ID IN (SELECT COMPANY_ID FROM SSP_MST_SHIP_PLAN_SCHEDULE WITH (NOLOCK) WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START)
 GROUP BY COMPANY_ID
        , DIVISION_ID
        , MEASURE
 ORDER BY COMPANY_ID
        , DIVISION_ID
        , MEASURE;

-- ==============================================================================================================
-- [VQ-50] Packer 출하계획 산출 결과 구성(Measure 별)
-- 분류 : 일 산출
-- 대상 : SSP_ANL_SHIP_PLAN_P
-- 확인 : 계획 시작일 = 시험일 - 1. Measure 6종, 기간 = 계획 시작일 - 1 ~ + 55일(57일). AS-IS 같은 기준일 결과와 건수 · 수량 대조
-- 사용 : 사전점검 No 29(Packer 출하계획 생성 결과 구성 확인) / 사전점검 No 30(Packer BALANCE 산식 확인 · AS-IS 같은 기준일 대조) / 사전점검 No 30(Packer BALANCE 산식 확인 · AS-IS 같은 기준일 대조) / 사전점검 No 30(Packer BALANCE 산식 확인 · AS-IS 같은 기준일 대조) / 사전점검 No 31(같은 날 Packer 산출 재실행 시 건너뜀 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261124' AS P_PLAN_START)   /* 계획 시작일 = 시험일 - 1. 이 줄의 값만 바꿔 실행 */
SELECT DIVISION_ID
     , MEASURE
     , COUNT(*) AS ROW_CNT
     , COUNT(DISTINCT ITEM_ID) AS ITEM_CNT
     , COUNT(DISTINCT YYYYMMDD) AS DAY_CNT
     , MIN(YYYYMMDD) AS MIN_DATE
     , MAX(YYYYMMDD) AS MAX_DATE
     , SUM(QTY) AS QTY
     , MAX(LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
  FROM SSP_ANL_SHIP_PLAN_P WITH (NOLOCK)
   CROSS JOIN PRM
 WHERE DIVISION_ID = '40'
   AND PLAN_START_YYYYMMDD = PRM.P_PLAN_START
 GROUP BY DIVISION_ID
        , MEASURE
 ORDER BY DIVISION_ID
        , MEASURE;

-- ==============================================================================================================
-- [VQ-52] 전극 출하계획 산출 결과 구성(법인 · 사업부 · Measure 별)
-- 분류 : 일 산출
-- 대상 : SSP_ANL_SHIP_PLAN_EE
-- 확인 : 계획 시작일 = 시험일. 산출 법인마다 MEASURE_TYPE R(요청용) · P(계획용) 행 생성. AS-IS 같은 기준일 결과와 건수 · 수량 대조
-- 사용 : 사전점검 No 34(전극 출하계획 생성 결과 구성 확인) / 사전점검 No 35(전극 산출 결과 AS-IS 같은 기준일 대조) / 사전점검 No 35(전극 산출 결과 AS-IS 같은 기준일 대조) / 사전점검 No 35(전극 산출 결과 AS-IS 같은 기준일 대조) / 사전점검 No 36(같은 날 전극 산출 재실행 시 중복 생성 없음 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_PLAN_START)   /* 계획 시작일 = 시험일. 이 줄의 값만 바꿔 실행 */
SELECT COMPANY_ID
     , DIVISION_ID
     , MEASURE_TYPE                    /* R 요청용, P 계획용 */
     , MEASURE
     , COUNT(*) AS ROW_CNT
     , COUNT(DISTINCT ITEM_ID) AS ITEM_CNT
     , MIN(YYYYMMDD) AS MIN_DATE
     , MAX(YYYYMMDD) AS MAX_DATE
     , SUM(QTY) AS QTY
     , MAX(LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
  FROM SSP_ANL_SHIP_PLAN_EE WITH (NOLOCK)
   CROSS JOIN PRM
 WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START
 GROUP BY COMPANY_ID
        , DIVISION_ID
        , MEASURE_TYPE
        , MEASURE
 ORDER BY COMPANY_ID
        , DIVISION_ID
        , MEASURE_TYPE
        , MEASURE;

-- ==============================================================================================================
-- [VQ-53] 전극 기초재고 마감 · 재고 상세 마감(법인 별)
-- 분류 : 일 산출
-- 대상 : SSP_ANL_BOH_CUTOFF_EE · SSP_ANL_STOCK_EE_C
-- 확인 : 산출 법인마다 두 테이블에 시험일 행 존재(기초재고 마감 CUTOFF_DATE · 재고 상세 마감 PLAN_START_YYYYMMDD = 시험일)
-- 사용 : 사전점검 No 34(전극 출하계획 생성 결과 구성 확인) / 사전점검 No 34(전극 출하계획 생성 결과 구성 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_PLAN_START)   /* 계획 시작일 = 시험일. 이 줄의 값만 바꿔 실행 */
SELECT 'SSP_ANL_BOH_CUTOFF_EE' AS TABLE_NAME
     , COMPANY_ID
     , DIVISION_ID
     , COUNT(*) AS ROW_CNT
     , SUM(TOT_BOH_QTY) AS QTY
     , MAX(LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
  FROM SSP_ANL_BOH_CUTOFF_EE WITH (NOLOCK)
   CROSS JOIN PRM
 WHERE CUTOFF_DATE = PRM.P_PLAN_START
 GROUP BY COMPANY_ID
        , DIVISION_ID
 UNION ALL
SELECT 'SSP_ANL_STOCK_EE_C'
     , COMPANY_ID
     , DIVISION_ID
     , COUNT(*)
     , SUM(TOT_QTY)
     , MAX(LAST_UPDATE_DATE)
  FROM SSP_ANL_STOCK_EE_C WITH (NOLOCK)
   CROSS JOIN PRM
 WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START
   AND COMPANY_ID IN (SELECT COMPANY_ID FROM SSP_MST_SHIP_PLAN_SCHEDULE_EE WITH (NOLOCK) WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START)
 GROUP BY COMPANY_ID
        , DIVISION_ID
 ORDER BY 1
        , 2
        , 3;

-- ==============================================================================================================
-- [VQ-55] 통합 스냅샷 결과(사업부 · 법인 별)
-- 분류 : 일 산출
-- 대상 : SSP_ANL_SHIP_PLAN_ALL
-- 확인 : 계획 시작일 = 시험일 - 1. 산출을 마친 사업부 · 법인마다 행 존재. 대상별 최종 스냅샷 기준일은 VQ-44(SSP_ANL_SHIP_PLAN_ALL)의 ATTRIBUTE1
-- 사용 : 사전점검 No 37(사업부별 출하계획 · 확정 통합 스냅샷 생성 확인) / 사전점검 No 37(사업부별 출하계획 · 확정 통합 스냅샷 생성 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261124' AS P_PLAN_START)   /* 계획 시작일 = 시험일 - 1. 이 줄의 값만 바꿔 실행 */
SELECT DIVISION_ID
     , COMPANY_ID
     , ISNULL(ELECTRODE_YN, 'N') AS ELECTRODE_YN
     , COUNT(*) AS ROW_CNT
     , COUNT(DISTINCT CONFIRM_ID) AS CONFIRM_CNT
     , SUM(SHIPMENT_CONFIRM_QTY) AS SHIPMENT_CONFIRM_QTY
     , SUM(SHIPPING_PLAN_QTY) AS SHIPPING_PLAN_QTY
     , MAX(UPDATED_DATE) AS UPDATED_DATE
  FROM SSP_ANL_SHIP_PLAN_ALL WITH (NOLOCK)
   CROSS JOIN PRM
 WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START
 GROUP BY DIVISION_ID
        , COMPANY_ID
        , ISNULL(ELECTRODE_YN, 'N')
 ORDER BY DIVISION_ID
        , COMPANY_ID;

-- ==============================================================================================================
-- [VQ-56] 산출 배치가 만든 확정 원장(사업부 · 상태 별)
-- 분류 : 일 산출
-- 대상 : SSP_ANL_SHIP_CONFIRM
-- 확인 : 산출 직후 확정구간에 들어온 선적요청이 확정 행으로 생성됨. 이후 화면 · ERP 송신 검증은 테스트케이스 시트(VQ-01 ~ VQ-05)
-- 사용 : 사전점검 No 38(산출 배치가 만든 확정 원장 확인(테스트케이스 시트 연결 지점)) / 사전점검 No 38(산출 배치가 만든 확정 원장 확인(테스트케이스 시트 연결 지점))
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_TEST_DATE)   /* 시험일. 이 줄의 값만 바꿔 실행 */
SELECT DIVISION_ID
     , CHANGE_TYPE
     , SHIPMENT_STATUS               /* C 확정, D 작성 중, R 요청 완료, P 계획 */
     , COUNT(*) AS ROW_CNT
     , SUM(QTY) AS QTY
     , MIN(YYYYMMDD) AS MIN_DATE
     , MAX(YYYYMMDD) AS MAX_DATE
     , MAX(CREATION_DATE) AS LAST_CREATED
  FROM SSP_ANL_SHIP_CONFIRM WITH (NOLOCK)
   CROSS JOIN PRM
 WHERE CREATION_DATE >= CONVERT(DATETIME, PRM.P_TEST_DATE, 112)
   AND CREATION_DATE < DATEADD(DAY, 1, CONVERT(DATETIME, PRM.P_TEST_DATE, 112))
   AND CREATED_BY = 'ssp_batch'
 GROUP BY DIVISION_ID
        , CHANGE_TYPE
        , SHIPMENT_STATUS
 ORDER BY DIVISION_ID
        , CHANGE_TYPE
        , SHIPMENT_STATUS;

-- ==============================================================================================================
-- [VQ-27] 출하요청 3종(SEMI · FG / Packer / 전극) 품목별 수량 (검증쿼리 시트 VQ-27 와 같은 쿼리 · AS-IS 대조용)
-- 분류 : 출하요청
-- 대상 : DM_PLN_SHIPMENT_REQ · SSP_ANL_SHIP_REQ_P · SSP_ANL_SHIP_REQ_EE
-- 확인 : 화면 조회 수량 = 쿼리 수량, 입력 · 저장 후 증감 반영
-- 사용 : 사전점검 No 11(사업부별 선적요청(Shipment Request) 존재 확인) / 사전점검 No 11(사업부별 선적요청(Shipment Request) 존재 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT 'MCCM349215A1-111' AS P_ITEM_ID, '20261125' AS P_FROM_YYYYMMDD, '20261231' AS P_TO_YYYYMMDD)   /* 품목 · 출하일 시작 · 출하일 종료. 이 줄의 값만 바꿔 실행 */
SELECT 'DM_PLN_SHIPMENT_REQ' AS SRC
     , DIVISION_ID
     , SITE_TYPE                     /* PLANT = SEMI, SALES = FG */
     , YYYYMMDD
     , SUM(QTY) AS QTY
  FROM DM_PLN_SHIPMENT_REQ WITH (NOLOCK)
   CROSS JOIN PRM
 WHERE ITEM_ID = PRM.P_ITEM_ID
   AND YYYYMMDD BETWEEN PRM.P_FROM_YYYYMMDD AND PRM.P_TO_YYYYMMDD
 GROUP BY DIVISION_ID
        , SITE_TYPE
        , YYYYMMDD
 UNION ALL
SELECT 'SSP_ANL_SHIP_REQ_P'
     , DIVISION_ID
     , 'PACKER'
     , YYYYMMDD
     , SUM(QTY)
  FROM SSP_ANL_SHIP_REQ_P WITH (NOLOCK)
   CROSS JOIN PRM
 WHERE ITEM_ID = PRM.P_ITEM_ID
   AND YYYYMMDD BETWEEN PRM.P_FROM_YYYYMMDD AND PRM.P_TO_YYYYMMDD
 GROUP BY DIVISION_ID
        , YYYYMMDD
 UNION ALL
SELECT 'SSP_ANL_SHIP_REQ_EE'
     , FROM_DIVISION_ID
     , 'EE'
     , ETD_DATE
     , SUM(QTY)
  FROM SSP_ANL_SHIP_REQ_EE WITH (NOLOCK)
   CROSS JOIN PRM
 WHERE ITEM_ID = PRM.P_ITEM_ID
   AND ETD_DATE BETWEEN PRM.P_FROM_YYYYMMDD AND PRM.P_TO_YYYYMMDD
 GROUP BY FROM_DIVISION_ID
        , ETD_DATE
 ORDER BY SRC
        , YYYYMMDD;

-- ==============================================================================================================
-- [VQ-31] 출하계획 테이블별 기준일 건수 · 수량 (검증쿼리 시트 VQ-31 와 같은 쿼리 · AS-IS 대조용)
-- 분류 : 기준선
-- 대상 : SSP_ANL_SHIP_PLAN_40 · _C · _P · _EE
-- 확인 : 산출 후 기준일 행 생성, AS-IS 같은 기준일 결과와 비교
-- 사용 : 사전점검 No 14(시험 전 집계 저장) / 사전점검 No 19(40 산출 결과 AS-IS 같은 기준일 대조) / 사전점검 No 26(81·82 산출 결과 AS-IS 같은 기준일 대조) / 사전점검 No 30(Packer BALANCE 산식 확인 · AS-IS 같은 기준일 대조) / 사전점검 No 35(전극 산출 결과 AS-IS 같은 기준일 대조) / 사전점검 No 41(재시험 준비(재시험 때만 수행))
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_PLAN_START)   /* 계획 시작일 = 시험일. 이 줄의 값만 바꿔 실행 */
SELECT 'SSP_ANL_SHIP_PLAN_40' AS TABLE_NAME
     , COUNT(*) AS ROW_CNT
     , SUM(QTY) AS QTY
  FROM SSP_ANL_SHIP_PLAN_40 WITH (NOLOCK)
   CROSS JOIN PRM
 WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START
 UNION ALL
SELECT 'SSP_ANL_SHIP_PLAN_C'
     , COUNT(*)
     , SUM(QTY)
  FROM SSP_ANL_SHIP_PLAN_C WITH (NOLOCK)
   CROSS JOIN PRM
 WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START
   AND DIVISION_ID IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION WITH (NOLOCK))
   AND COMPANY_ID IN (SELECT COMPANY_ID FROM SSP_MST_SHIP_PLAN_SCHEDULE WITH (NOLOCK) WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START)
 UNION ALL
SELECT 'SSP_ANL_SHIP_PLAN_P'
     , COUNT(*)
     , SUM(QTY)
  FROM SSP_ANL_SHIP_PLAN_P WITH (NOLOCK)
   CROSS JOIN PRM
 WHERE DIVISION_ID = '40'
   AND PLAN_START_YYYYMMDD = PRM.P_PLAN_START
 UNION ALL
SELECT 'SSP_ANL_SHIP_PLAN_EE'
     , COUNT(*)
     , SUM(QTY)
  FROM SSP_ANL_SHIP_PLAN_EE WITH (NOLOCK)
   CROSS JOIN PRM
 WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START;
