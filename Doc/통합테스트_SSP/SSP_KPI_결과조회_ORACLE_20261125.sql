-- ==============================================================================================================
-- SSP KPI 배치 결과 조회 · Oracle(클라우드) · 조회만 수행
-- 대상 : 일별 PR_SSP_KPI_BR_BOD_REGISTRATION → SSP_KPI_BR_BOD_REGISTRATION
--        주별 PR_SSP_KPI_SHIPMENT_PSI_DW → SSP_KPI_SHIPMENT_PSI
--        주별 PR_SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY → SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY · _C
--        주별 PR_SSP_KPI_SPA_OTD1 → SSP_KPI_SPA_OTD1 · _C
-- 기준 : 실행일에 만든 행 = CREATION_DATE 가 실행일인 행(프로그램이 CREATION_DATE = SYSDATE 로 넣음, 사내 ZIOUI1 원문 2026-11-25 확인)
-- 실행 : DBeaver 에서 쿼리 하나씩(커서를 쿼리 안에 두고 Ctrl+Enter). 각 쿼리 맨 위 PRM 줄의 실행일만 바꿔 실행
-- 순서 : [Q0] 테이블별 건수 → 실행한 프로그램의 [Q1] ~ [Q4] → [Q5] 로그
-- ==============================================================================================================

-- ==============================================================================================================
-- [Q0] 테이블별 실행일 생성 건수
-- 확인 : 실행한 프로그램의 테이블 ROW_CNT > 0. FIRST_CREATED ~ LAST_CREATED = 넣은 시각
--        SSP_KPI_SPA_OTD1 은 월요일에만 넣음(계획 01시, 실적 06 ~ 21시). 다른 요일 실행이면 0 이 정상
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */
SELECT 'SSP_KPI_BR_BOD_REGISTRATION' AS TABLE_NAME
     , COUNT(*) AS ROW_CNT
     , MIN(A.CREATION_DATE) AS FIRST_CREATED
     , MAX(A.CREATION_DATE) AS LAST_CREATED
  FROM SSP_KPI_BR_BOD_REGISTRATION A
     , PRM
 WHERE A.CREATION_DATE >= TO_DATE(PRM.P_DAY, 'YYYYMMDD')
   AND A.CREATION_DATE <  TO_DATE(PRM.P_DAY, 'YYYYMMDD') + 1
 UNION ALL
SELECT 'SSP_KPI_SHIPMENT_PSI'
     , COUNT(*)
     , MIN(A.CREATION_DATE)
     , MAX(A.CREATION_DATE)
  FROM SSP_KPI_SHIPMENT_PSI A
     , PRM
 WHERE A.CREATION_DATE >= TO_DATE(PRM.P_DAY, 'YYYYMMDD')
   AND A.CREATION_DATE <  TO_DATE(PRM.P_DAY, 'YYYYMMDD') + 1
 UNION ALL
SELECT 'SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY'
     , COUNT(*)
     , MIN(A.CREATION_DATE)
     , MAX(A.CREATION_DATE)
  FROM SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY A
     , PRM
 WHERE A.CREATION_DATE >= TO_DATE(PRM.P_DAY, 'YYYYMMDD')
   AND A.CREATION_DATE <  TO_DATE(PRM.P_DAY, 'YYYYMMDD') + 1
 UNION ALL
SELECT 'SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY_C'
     , COUNT(*)
     , MIN(A.CREATION_DATE)
     , MAX(A.CREATION_DATE)
  FROM SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY_C A
     , PRM
 WHERE A.CREATION_DATE >= TO_DATE(PRM.P_DAY, 'YYYYMMDD')
   AND A.CREATION_DATE <  TO_DATE(PRM.P_DAY, 'YYYYMMDD') + 1
 UNION ALL
SELECT 'SSP_KPI_SPA_OTD1'
     , COUNT(*)
     , MIN(A.CREATION_DATE)
     , MAX(A.CREATION_DATE)
  FROM SSP_KPI_SPA_OTD1 A
     , PRM
 WHERE A.CREATION_DATE >= TO_DATE(PRM.P_DAY, 'YYYYMMDD')
   AND A.CREATION_DATE <  TO_DATE(PRM.P_DAY, 'YYYYMMDD') + 1
 UNION ALL
SELECT 'SSP_KPI_SPA_OTD1_C'
     , COUNT(*)
     , MIN(A.CREATION_DATE)
     , MAX(A.CREATION_DATE)
  FROM SSP_KPI_SPA_OTD1_C A
     , PRM
 WHERE A.CREATION_DATE >= TO_DATE(PRM.P_DAY, 'YYYYMMDD')
   AND A.CREATION_DATE <  TO_DATE(PRM.P_DAY, 'YYYYMMDD') + 1;

-- ==============================================================================================================
-- [Q1] 일별 KPI : 물류 BOD 미등록(SSP_KPI_BR_BOD_REGISTRATION) 사업부별 요약
-- 확인 : 사업부별 미등록 행 수 · ROUTE_CNT 합. 같은 사업부가 실행 회차(CREATION_DATE)만큼 나뉘어 나오면 두 번 실행된 것
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */
SELECT A.YYYYMMDD
     , A.WEEK_NAME
     , A.DIVISION_ID
     , TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS') AS CREATED_AT
     , COUNT(*) AS ROW_CNT
     , SUM(A.ROUTE_CNT) AS ROUTE_CNT
  FROM SSP_KPI_BR_BOD_REGISTRATION A
     , PRM
 WHERE A.CREATION_DATE >= TO_DATE(PRM.P_DAY, 'YYYYMMDD')
   AND A.CREATION_DATE <  TO_DATE(PRM.P_DAY, 'YYYYMMDD') + 1
 GROUP BY A.YYYYMMDD
        , A.WEEK_NAME
        , A.DIVISION_ID
        , TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS')
 ORDER BY A.DIVISION_ID
        , CREATED_AT;

-- ==============================================================================================================
-- [Q1-1] 일별 KPI : 물류 BOD 미등록 행 상세
-- 확인 : 미등록 구간(출발 사이트 · 도착 사이트 · 인코텀즈 · 운송 수단 · 고객)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */
SELECT A.YYYYMMDD
     , A.DIVISION_ID
     , A.FROM_SITE
     , A.FROM_CITY
     , A.TO_SITE
     , A.TO_CITY
     , A.VMI_YN
     , A.INCOTERMS
     , A.TRANSPORT_MODE
     , A.ROUTE_CNT
     , A.CUSTOMER
     , A.ATTRIBUTE1 AS ISO_YYYYWW
     , A.CREATION_DATE
  FROM SSP_KPI_BR_BOD_REGISTRATION A
     , PRM
 WHERE A.CREATION_DATE >= TO_DATE(PRM.P_DAY, 'YYYYMMDD')
   AND A.CREATION_DATE <  TO_DATE(PRM.P_DAY, 'YYYYMMDD') + 1
 ORDER BY A.DIVISION_ID
        , A.FROM_SITE
        , A.TO_SITE;

-- ==============================================================================================================
-- [Q2] 주별 KPI : 출하 PSI(SSP_KPI_SHIPMENT_PSI) 집계일 · 사업부 · 법인별 요약
-- 확인 : SUM_YYYYMMDD = 실행일, YYYYMM = 집계 대상 월, START_YYYYMMDD = 집계 시작일. 사업부 · 법인별 행 수 · 수량 · 금액
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */
SELECT A.SUM_YYYYMMDD
     , A.YYYYMM
     , A.START_YYYYMMDD
     , A.DIVISION_ID
     , A.COMPANY_ID
     , COUNT(*) AS ROW_CNT
     , SUM(A.PLAN_QTY) AS PLAN_QTY
     , SUM(A.PLAN_QTY_TO_CELL) AS PLAN_QTY_TO_CELL
     , SUM(A.SALES_AMT) AS SALES_AMT
     , MIN(A.YYYYMMDD) AS FROM_DAY
     , MAX(A.YYYYMMDD) AS TO_DAY
  FROM SSP_KPI_SHIPMENT_PSI A
     , PRM
 WHERE A.CREATION_DATE >= TO_DATE(PRM.P_DAY, 'YYYYMMDD')
   AND A.CREATION_DATE <  TO_DATE(PRM.P_DAY, 'YYYYMMDD') + 1
 GROUP BY A.SUM_YYYYMMDD
        , A.YYYYMM
        , A.START_YYYYMMDD
        , A.DIVISION_ID
        , A.COMPANY_ID
 ORDER BY A.DIVISION_ID
        , A.COMPANY_ID;

-- ==============================================================================================================
-- [Q2-1] 주별 KPI : 출하 PSI 품목 · 일자별 상세(앞 1,000행)
-- 확인 : 출발 · 도착 사이트, 품목, 일자별 계획 수량. SALES_AMT 가 비어 있으면 단가(SCM_MST_FUTURE_PRICE) 없음
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */
SELECT A.SUM_YYYYMMDD
     , A.DIVISION_ID
     , A.COMPANY_ID
     , A.PLANT_ID
     , A.FROM_SITE
     , A.TO_SITE
     , A.SHIPTO_CODE
     , A.ITEM_ID
     , A.PROJECT_CODE
     , A.YYYYMMDD
     , A.PLAN_QTY
     , A.PLAN_QTY_TO_CELL
     , A.SALES_AMT
     , A.FCST_TYPE
     , A.INCOTERMS
     , A.TRANSPORT_MODE
     , A.END_CUSTOMER
  FROM SSP_KPI_SHIPMENT_PSI A
     , PRM
 WHERE A.CREATION_DATE >= TO_DATE(PRM.P_DAY, 'YYYYMMDD')
   AND A.CREATION_DATE <  TO_DATE(PRM.P_DAY, 'YYYYMMDD') + 1
 ORDER BY A.DIVISION_ID
        , A.COMPANY_ID
        , A.ITEM_ID
        , A.YYYYMMDD
 FETCH FIRST 1000 ROWS ONLY;

-- ==============================================================================================================
-- [Q3] 주별 KPI : 출하계획 준수율 원장(SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY_C) 구분 · 사업부별
-- 확인 : VERSION_TYPE PLAN = 실행일이 속한 주(금주) 확정 수량, RESULT = 전주 출하 실적
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */
SELECT A.VERSION_TYPE
     , A.DIVISION_ID
     , A.WEEK_NAME
     , MIN(A.YYYYMMDD) AS FROM_DAY
     , MAX(A.YYYYMMDD) AS TO_DAY
     , COUNT(*) AS ROW_CNT
     , SUM(A.PLAN_QTY) AS PLAN_QTY
     , SUM(A.RESULT_QTY) AS RESULT_QTY
  FROM SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY_C A
     , PRM
 WHERE A.CREATION_DATE >= TO_DATE(PRM.P_DAY, 'YYYYMMDD')
   AND A.CREATION_DATE <  TO_DATE(PRM.P_DAY, 'YYYYMMDD') + 1
 GROUP BY A.VERSION_TYPE
        , A.DIVISION_ID
        , A.WEEK_NAME
 ORDER BY A.VERSION_TYPE
        , A.DIVISION_ID
        , A.WEEK_NAME;

-- ==============================================================================================================
-- [Q3-1] 주별 KPI : 출하계획 준수율(SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY) 사업부 · 주별 계획 대비 실적
-- 확인 : 전주 계획(PLAN_QTY) 대비 실적(RESULT_QTY). ACCURACY_PCT = 실적 / 계획 × 100(계획 0 이면 빈 값)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */
SELECT A.DIVISION_ID
     , A.YYYYMM
     , A.WEEK_NAME
     , MIN(A.YYYYMMDD) AS FROM_DAY
     , MAX(A.YYYYMMDD) AS TO_DAY
     , COUNT(*) AS ROW_CNT
     , SUM(A.PLAN_QTY) AS PLAN_QTY
     , SUM(A.RESULT_QTY) AS RESULT_QTY
     , ROUND(SUM(A.RESULT_QTY) / NULLIF(SUM(A.PLAN_QTY), 0) * 100, 1) AS ACCURACY_PCT
  FROM SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY A
     , PRM
 WHERE A.CREATION_DATE >= TO_DATE(PRM.P_DAY, 'YYYYMMDD')
   AND A.CREATION_DATE <  TO_DATE(PRM.P_DAY, 'YYYYMMDD') + 1
 GROUP BY A.DIVISION_ID
        , A.YYYYMM
        , A.WEEK_NAME
 ORDER BY A.DIVISION_ID
        , A.WEEK_NAME;

-- ==============================================================================================================
-- [Q4] 주별 KPI : 출하 준수율 OTD1 원장(SSP_KPI_SPA_OTD1_C) 구분 · 사업부별
-- 확인 : VERSION_TYPE PLAN = 금주 계획(월요일 01시 생성), RESULT = 전주 실적(월요일 법인 시업 시각 이후 생성)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */
SELECT A.VERSION_TYPE
     , A.DIVISION_ID
     , MIN(A.YYYYMMDD) AS FROM_DAY
     , MAX(A.YYYYMMDD) AS TO_DAY
     , COUNT(*) AS ROW_CNT
     , SUM(A.PLAN_QTY) AS PLAN_QTY
     , SUM(A.RESULT_QTY) AS RESULT_QTY
     , MIN(A.CREATION_DATE) AS FIRST_CREATED
     , MAX(A.CREATION_DATE) AS LAST_CREATED
  FROM SSP_KPI_SPA_OTD1_C A
     , PRM
 WHERE A.CREATION_DATE >= TO_DATE(PRM.P_DAY, 'YYYYMMDD')
   AND A.CREATION_DATE <  TO_DATE(PRM.P_DAY, 'YYYYMMDD') + 1
 GROUP BY A.VERSION_TYPE
        , A.DIVISION_ID
 ORDER BY A.VERSION_TYPE
        , A.DIVISION_ID;

-- ==============================================================================================================
-- [Q4-1] 주별 KPI : 출하 준수율 OTD1(SSP_KPI_SPA_OTD1) 법인 · 사업부 · 주별 계획 대비 실적
-- 확인 : 법인별 계획 대비 실적. OTD1_PCT = 실적 / 계획 × 100(계획 0 이면 빈 값)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */
SELECT A.COMPANY_ID
     , A.DIVISION_ID
     , A.YYYYWW
     , MIN(A.YYYYMMDD) AS FROM_DAY
     , MAX(A.YYYYMMDD) AS TO_DAY
     , COUNT(*) AS ROW_CNT
     , SUM(A.PLAN_QTY) AS PLAN_QTY
     , SUM(A.RESULT_QTY) AS RESULT_QTY
     , ROUND(SUM(A.RESULT_QTY) / NULLIF(SUM(A.PLAN_QTY), 0) * 100, 1) AS OTD1_PCT
  FROM SSP_KPI_SPA_OTD1 A
     , PRM
 WHERE A.CREATION_DATE >= TO_DATE(PRM.P_DAY, 'YYYYMMDD')
   AND A.CREATION_DATE <  TO_DATE(PRM.P_DAY, 'YYYYMMDD') + 1
 GROUP BY A.COMPANY_ID
        , A.DIVISION_ID
        , A.YYYYWW
 ORDER BY A.COMPANY_ID
        , A.DIVISION_ID
        , A.YYYYWW;

-- ==============================================================================================================
-- [Q5] KPI 프로그램 실행 로그(실행일)
-- 확인 : 프로그램마다 START 뒤 END. ERROR 면 LOG_MESSAGE · SQL_ERR_MSG 회신. END 의 DESCRIPTION = 소요 시간
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */
SELECT L.EVENT_DATE
     , L.PROGRAM_NAME
     , L.LOG_TYPE
     , L.LOG_COUNT
     , SUBSTR(L.LOG_MESSAGE, 1, 200) AS LOG_MESSAGE
     , SUBSTR(L.DESCRIPTION, 1, 300) AS DESCRIPTION
     , L.SQL_ERR_CODE
     , SUBSTR(L.SQL_ERR_MSG, 1, 300) AS SQL_ERR_MSG
  FROM SCM_SYS_LOG_BATCH L
     , PRM
 WHERE L.EVENT_DATE >= TO_DATE(PRM.P_DAY, 'YYYYMMDD')
   AND L.EVENT_DATE <  TO_DATE(PRM.P_DAY, 'YYYYMMDD') + 1
   AND L.PROGRAM_NAME IN ('PR_SSP_KPI_BR_BOD_REGISTRATION', 'PR_SSP_KPI_SHIPMENT_PSI_DW'
                        , 'PR_SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY', 'PR_SSP_KPI_SPA_OTD1')
 ORDER BY L.EVENT_DATE DESC;
