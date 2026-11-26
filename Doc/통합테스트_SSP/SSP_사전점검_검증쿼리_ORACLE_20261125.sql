-- ==============================================================================================================
-- SSP 통합테스트 시나리오(e2e) 사전점검 단계 검증쿼리 · Oracle(TO-BE) · 27개
-- 시험일(PLAN_DATE) = 20261125 · 계획 시작일 : 40 · 전극 = 20261125, 81·82 · Packer · 통합 스냅샷 = 20261124(시험일 - 1)
-- 실행 : DBeaver 에서 쿼리 하나씩(커서를 쿼리 안에 두고 Ctrl+Enter). 값을 바꿀 때는 각 쿼리 맨 위 WITH PRM 줄만 고침
-- 조회만 수행(변경 문장 없음). 번호 = 통합테스트 시나리오 「검증쿼리(사전점검)」 시트의 ID
-- 같은 번호의 MSSQL(AS-IS) 쿼리와 결과 열 이름 · 정렬이 같음
-- 생성 2026-11-25 10:52 · tools/Analysis/ssp_it_precheck/gen_sql_files.py
-- ==============================================================================================================

-- 목차
--   VQ-33  SSP 산출 · 재고 수신 프로그램 컴파일 상태
--   VQ-34  SSP 잡 등록 · 사용 여부
--   VQ-35  시험일 일 계획 ID · 40 일 계획(SP) 상태
--   VQ-36  법인별 재고 수신 확인 표시(시험일 · 수신 여부)
--   VQ-37  40 산출 진입 조건(법인 HQ00 · AZ00 · NJ00)
--   VQ-38  81·82 컷오프 진입 조건(법인별 3가지)
--   VQ-39  Packer 산출 진입 조건 · 기준일
--   VQ-40  전극 산출 진입 조건(법인별 3가지)
--   VQ-41  사업부별 재고 테이블 기준일 자료 존재 · 수신 시각
--   VQ-42  법인별 전일 ERP 재고(INVENTORY) 건수 · 수량
--   VQ-43  산출 입력 자료 최종 생성 일시
--   VQ-44  산출 공통 코드(법인 설명 · 시업 시각 · Packer 산출 기준일 · 통합 스냅샷 대상)
--   VQ-45  40 출하계획 산출 결과 구성(법인 · Measure 별)
--   VQ-46  40 당일 BALANCE 산식 불일치 행
--   VQ-47  81·82 OWMS 재고 마감 자료(법인 · 사업부 별)
--   VQ-48  81·82 출하계획 마감 결과 구성(법인 · 사업부 · Measure 별)
--   VQ-49  81·82 BALANCE 산식 불일치 행
--   VQ-50  Packer 출하계획 산출 결과 구성(Measure 별)
--   VQ-51  Packer BALANCE 산식 불일치 행
--   VQ-52  전극 출하계획 산출 결과 구성(법인 · 사업부 · Measure 별)
--   VQ-53  전극 기초재고 마감 · 재고 상세 마감(법인 별)
--   VQ-54  일 마감 진행 표시(시험일 행 · 전일 행) 81·82 · 전극
--   VQ-55  통합 스냅샷 결과(사업부 · 법인 별)
--   VQ-56  산출 배치가 만든 확정 원장(사업부 · 상태 별)
--   VQ-57  일 마감 지연 · 오류 문자 적재(문구 별)
--   VQ-27  출하요청 3종(SEMI · FG / Packer / 전극) 품목별 수량 (검증쿼리 시트 VQ-27 와 같은 쿼리 · AS-IS 대조용)
--   VQ-31  출하계획 테이블별 기준일 건수 · 수량 (검증쿼리 시트 VQ-31 와 같은 쿼리 · AS-IS 대조용)

-- ==============================================================================================================
-- [VQ-33] SSP 산출 · 재고 수신 프로그램 컴파일 상태
-- 분류 : 실행 환경
-- 대상 : ALL_OBJECTS
-- 확인 : 조회 0건이면 정상. 조회되는 프로그램은 컴파일 오류 해소 후 시험 시작
-- 사용 : 사전점검 No 1(SSP 배치 프로그램 컴파일 상태 · 잡 사용 여부 · ERP 연계 차단 기간 확인)
-- ==============================================================================================================
SELECT OBJECT_NAME
     , OBJECT_TYPE
     , STATUS
     , LAST_DDL_TIME
  FROM ALL_OBJECTS
 WHERE OWNER = 'SCM_MGR'
   AND STATUS = 'INVALID'
   AND OBJECT_TYPE IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY', 'VIEW')
   AND (   OBJECT_NAME LIKE 'PR_SSP%'
        OR OBJECT_NAME LIKE 'PKG_SSP%'
        OR OBJECT_NAME LIKE 'FN_GET_SSP%'
        OR OBJECT_NAME LIKE 'FN_GET_ANL_SHIP%'
        OR OBJECT_NAME IN ('PR_SCM_MST_PLAN', 'PR_SCM_DNM_STOCK_V', 'SCM_DNM_STOCK_V', 'SSP_DNM_ESS_PACKER_STOCK_V', 'SSP_PLAN_VERSION_V', 'SCM_ADM_SMS_SEND_BATCH'))
 ORDER BY OBJECT_NAME;

-- ==============================================================================================================
-- [VQ-34] SSP 잡 등록 · 사용 여부
-- 분류 : 실행 환경
-- 대상 : ALL_SCHEDULER_JOBS
-- 확인 : ENABLED 값이 시험 방식과 같음(수동 실행이면 FALSE, 잡 자동 수행이면 TRUE). JOB_ACTION 의 프로그램 순서가 수동 실행 순서
-- 사용 : 사전점검 No 1(SSP 배치 프로그램 컴파일 상태 · 잡 사용 여부 · ERP 연계 차단 기간 확인)
-- ==============================================================================================================
SELECT JOB_NAME
     , ENABLED
     , STATE
     , NVL(REPEAT_INTERVAL, SCHEDULE_NAME) AS SCHEDULE
     , LAST_START_DATE
     , NEXT_RUN_DATE
     , JOB_ACTION
  FROM ALL_SCHEDULER_JOBS
 WHERE OWNER = 'SCM_MGR'
   AND (   JOB_NAME LIKE '%SSP%'
        OR UPPER(JOB_ACTION) LIKE '%SSP%')
 ORDER BY JOB_NAME;

-- ==============================================================================================================
-- [VQ-35] 시험일 일 계획 ID · 40 일 계획(SP) 상태
-- 분류 : 실행 환경
-- 대상 : SCM_MST_PLAN · SCM_MST_PLAN_DETAIL
-- 확인 : 사업부별 시험일 PLAN_NAME 행 1건. 40 산출 후 SP 행 PLAN_STATUS 0 수행 중 → 1 완료(-1 오류)
-- 사용 : 사전점검 No 2(시험일 일 계획 ID · 일 마감 진행 행 · 산출 공통 코드 확인) / 사전점검 No 16(40 산출 배치 법인 순서 실행(HQ00 → AZ00 → NJ00)) / 사전점검 No 40(산출 중 오류 발생 시 처리 확인(오류가 발생한 경우에 수행))
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_TEST_DATE FROM DUAL)   /* 시험일. 이 줄의 값만 바꿔 실행 */
SELECT A.DIVISION_ID
     , A.PLAN_NAME
     , A.PLAN_ID
     , B.PLAN_TYPE
     , B.PLAN_SEQ
     , B.PLAN_STATUS                   /* 0 수행 중, 1 완료, -1 오류 */
     , B.LAST_UPDATE_DATE
  FROM SCM_MST_PLAN A
     , SCM_MST_PLAN_DETAIL B
 WHERE B.DIVISION_ID(+) = A.DIVISION_ID
   AND B.PLAN_ID(+) = A.PLAN_ID
   AND A.PLAN_CYCLE = 'DAILY'
   AND A.PLAN_NAME = (SELECT P_TEST_DATE FROM PRM)
 ORDER BY A.DIVISION_ID
        , B.PLAN_TYPE;

-- ==============================================================================================================
-- [VQ-36] 법인별 재고 수신 확인 표시(시험일 · 수신 여부)
-- 분류 : 진입 조건
-- 대상 : SCM_ADM_LOOKUP_MASTER_DETAIL (IF_STOCK_CHECK)
-- 확인 : NOT_READY_CNT = 0 이면 재고 조건 충족. PLAN_40 · PLAN_AUTO 는 수신일(SEGMENT5) = 시험일 + 수신 여부(ATTRIBUTE1) = Y, PLAN_EE 는 수신일만 판정
-- 사용 : 사전점검 No 3(법인별 재고 수신 확인 표시 확인(사업부 산출 공통 진입 조건))
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_TEST_DATE FROM DUAL)   /* 시험일. 이 줄의 값만 바꿔 실행 */
SELECT SEGMENT1 AS CHECK_GROUP          /* PLAN_40 = 40, PLAN_AUTO = 81·82, PLAN_EE = 전극 */
     , SEGMENT3 AS UNIT
     , SEGMENT4 AS COMPANY_ID
     , COUNT(*) AS TOT_CNT
     , SUM(CASE WHEN SEGMENT5 = (SELECT P_TEST_DATE FROM PRM) AND (SEGMENT1 = 'PLAN_EE' OR ATTRIBUTE1 = 'Y') THEN 1 ELSE 0 END) AS PASS_CNT
     , SUM(CASE WHEN SEGMENT5 = (SELECT P_TEST_DATE FROM PRM) AND (SEGMENT1 = 'PLAN_EE' OR ATTRIBUTE1 = 'Y') THEN 0 ELSE 1 END) AS NOT_READY_CNT
     , LISTAGG(SEGMENT2 || ':' || SEGMENT5 || ':' || ATTRIBUTE1, ' / ') WITHIN GROUP (ORDER BY SEGMENT2) AS DETAIL   /* 재고 종류 : 수신일 : 수신 여부 */
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE = 'IF_STOCK_CHECK'
   AND VALID_YN = 'Y'
 GROUP BY SEGMENT1
        , SEGMENT3
        , SEGMENT4
 ORDER BY SEGMENT1
        , SEGMENT4;

-- ==============================================================================================================
-- [VQ-37] 40 산출 진입 조건(법인 HQ00 · AZ00 · NJ00)
-- 분류 : 진입 조건
-- 대상 : SSP_ANL_SHIP_PLAN_40 · SCM_ADM_LOOKUP_MASTER_DETAIL · SCM_MST_PLAN
-- 확인 : READY_YN = Y : 시험일 SHIP_CONFIRM 계획 0건 + 재고 수신 확인 미충족 0건 + 시험일 일 계획 ID 1건
-- 사용 : 사전점검 No 4(40 산출 진입 조건 확인(법인 HQ00 · AZ00 · NJ00)) / 사전점검 No 15(재고 수신 확인 미충족 상태에서 40 출하계획 생성 실행 → 건너뜀 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_TEST_DATE FROM DUAL)   /* 시험일. 이 줄의 값만 바꿔 실행 */
SELECT X.COMPANY_ID
     , X.PLAN_CNT                      /* 시험일 계획 시작일의 SHIP_CONFIRM 행. 1건 이상이면 산출 안 함 */
     , X.STOCK_NOT_READY_CNT           /* 재고 수신 확인(PLAN_40) 미충족 행 */
     , X.DAILY_PLAN_CNT                /* 시험일 일 계획 ID */
     , CASE WHEN X.PLAN_CNT = 0 AND X.STOCK_NOT_READY_CNT = 0 AND X.DAILY_PLAN_CNT > 0 THEN 'Y' ELSE 'N' END AS READY_YN
  FROM (SELECT C.COMPANY_ID
             , (SELECT COUNT(*)
                  FROM SSP_ANL_SHIP_PLAN_40 P
                     , PRM
                 WHERE P.DIVISION_ID = '40'
                   AND P.PLAN_START_YYYYMMDD = PRM.P_TEST_DATE
                   AND P.MEASURE = 'SHIP_CONFIRM'
                   AND P.ATTRIBUTE10 = C.COMPANY_ID) AS PLAN_CNT
             , (SELECT COUNT(*)
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
                     , PRM
                 WHERE L.LOOKUP_TYPE = 'IF_STOCK_CHECK'
                   AND L.VALID_YN = 'Y'
                   AND L.SEGMENT1 = 'PLAN_40'
                   AND L.SEGMENT3 = '40'
                   AND L.SEGMENT4 = C.COMPANY_ID
                   AND NOT (L.SEGMENT5 = PRM.P_TEST_DATE AND L.ATTRIBUTE1 = 'Y')) AS STOCK_NOT_READY_CNT
             , (SELECT COUNT(*)
                  FROM SCM_MST_PLAN M
                     , PRM
                 WHERE M.DIVISION_ID = '40'
                   AND M.PLAN_CYCLE = 'DAILY'
                   AND M.PLAN_NAME = PRM.P_TEST_DATE) AS DAILY_PLAN_CNT
          FROM (SELECT 'HQ00' AS COMPANY_ID FROM DUAL
                 UNION ALL
                SELECT 'AZ00' FROM DUAL
                 UNION ALL
                SELECT 'NJ00' FROM DUAL) C) X
 ORDER BY X.COMPANY_ID;

-- ==============================================================================================================
-- [VQ-38] 81·82 컷오프 진입 조건(법인별 3가지)
-- 분류 : 진입 조건
-- 대상 : SSP_MST_SHIP_PLAN_SCHEDULE · SCM_DNM_STOCK_V · SCM_ADM_LOOKUP_MASTER_DETAIL
-- 확인 : READY_YN = Y : 시험일 행 CURRENT_PLAN_DATE_YN = N + 전일 ERP 재고 1건 이상 + 재고 수신 확인(PLAN_AUTO) 미충족 0건
-- 사용 : 사전점검 No 5(81·82 컷오프 진입 조건 확인(법인 11개)) / 사전점검 No 21(진입 조건 미충족 법인 건너뜀 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_TEST_DATE FROM DUAL)   /* 시험일. 이 줄의 값만 바꿔 실행 */
SELECT S.COMPANY_ID
     , S.PLAN_START_YYYYMMDD
     , S.CURRENT_PLAN_DATE_YN          /* N 이어야 진행 */
     , NVL(V.ERP_STOCK_CNT, 0) AS ERP_STOCK_CNT          /* 전일 ERP 재고(INVENTORY) */
     , NVL(L.STOCK_NOT_READY_CNT, 0) AS STOCK_NOT_READY_CNT   /* 재고 수신 확인(PLAN_AUTO) 미충족 행 */
     , CASE WHEN S.CURRENT_PLAN_DATE_YN = 'N' AND NVL(V.ERP_STOCK_CNT, 0) > 0 AND NVL(L.STOCK_NOT_READY_CNT, 0) = 0 THEN 'Y' ELSE 'N' END AS READY_YN
  FROM SSP_MST_SHIP_PLAN_SCHEDULE S
     , (SELECT COMPANY_ID
             , COUNT(*) AS ERP_STOCK_CNT
          FROM SCM_DNM_STOCK_V
             , PRM
         WHERE CUTOFF_DATE = TO_DATE(PRM.P_TEST_DATE, 'YYYYMMDD') - 1
           AND STOCK_TYPE = 'INVENTORY'
         GROUP BY COMPANY_ID) V
     , (SELECT SEGMENT4 AS COMPANY_ID
             , SUM(CASE WHEN SEGMENT5 = (SELECT P_TEST_DATE FROM PRM) AND ATTRIBUTE1 = 'Y' THEN 0 ELSE 1 END) AS STOCK_NOT_READY_CNT
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'IF_STOCK_CHECK'
           AND VALID_YN = 'Y'
           AND SEGMENT1 = 'PLAN_AUTO'
           AND SEGMENT3 = '81_82'
         GROUP BY SEGMENT4) L
 WHERE V.COMPANY_ID(+) = S.COMPANY_ID
   AND L.COMPANY_ID(+) = S.COMPANY_ID
   AND S.PLAN_START_YYYYMMDD = (SELECT P_TEST_DATE FROM PRM)
 ORDER BY S.COMPANY_ID;

-- ==============================================================================================================
-- [VQ-39] Packer 산출 진입 조건 · 기준일
-- 분류 : 진입 조건
-- 대상 : SCM_ADM_LOOKUP_MASTER_DETAIL (SSP_ANL_SHIP_PLAN_P) · SCM_DNM_SCS_STOCK
-- 확인 : READY_YN = Y : 계획 기준일(시험일 - 1) > 최종 산출 기준일(ATTRIBUTE1). 기초재고 기준일(시험일 - 3) 재고 건수 확인
-- 사용 : 사전점검 No 6(Packer 산출 진입 조건 · 기준일 확인) / 사전점검 No 28(Packer 산출 실행) / 사전점검 No 31(같은 날 Packer 산출 재실행 시 건너뜀 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_TEST_DATE FROM DUAL)   /* 시험일. 이 줄의 값만 바꿔 실행 */
SELECT L.SEGMENT1 AS DIVISION_ID
     , L.ATTRIBUTE1 AS LAST_PLAN_START                                               /* 최종 산출 기준일 */
     , TO_CHAR(TO_DATE((SELECT P_TEST_DATE FROM PRM), 'YYYYMMDD') - 1, 'YYYYMMDD') AS PLAN_START        /* 이번 계획 기준일 */
     , TO_CHAR(TO_DATE((SELECT P_TEST_DATE FROM PRM), 'YYYYMMDD') - 3, 'YYYYMMDD') AS BOH_DATE          /* 기초재고 기준일 */
     , (SELECT COUNT(*)
          FROM SCM_DNM_SCS_STOCK K
             , PRM
         WHERE K.CUTOFF_DATE = TO_CHAR(TO_DATE(PRM.P_TEST_DATE, 'YYYYMMDD') - 3, 'YYYYMMDD')) AS BOH_STOCK_CNT
     , CASE WHEN TO_CHAR(TO_DATE((SELECT P_TEST_DATE FROM PRM), 'YYYYMMDD') - 1, 'YYYYMMDD') > L.ATTRIBUTE1 THEN 'Y' ELSE 'N' END AS READY_YN
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
 WHERE L.LOOKUP_TYPE = 'SSP_ANL_SHIP_PLAN_P'
   AND L.VALID_YN = 'Y';

-- ==============================================================================================================
-- [VQ-40] 전극 산출 진입 조건(법인별 3가지)
-- 분류 : 진입 조건
-- 대상 : SSP_MST_SHIP_PLAN_SCHEDULE_EE · SCM_SYS_LOOKUP_VALUE(FP) · SCM_ADM_LOOKUP_MASTER_DETAIL
-- 확인 : READY_YN = Y : 시험일 행 CURRENT_PLAN_DATE_YN = N + FP 실적 수신 완료 표시 1건 이상 + 재고 수신 확인(PLAN_EE) 행이 있고 모두 수신일 = 시험일
-- 사용 : 사전점검 No 7(전극 산출 진입 조건 확인(법인별)) / 사전점검 No 32(FP 실적 수신 완료 표시가 없는 법인 건너뜀 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_TEST_DATE FROM DUAL)   /* 시험일. 이 줄의 값만 바꿔 실행 */
SELECT E.COMPANY_ID
     , E.CURRENT_PLAN_DATE_YN          /* N 미수행, P 진행 중, Y 완료, E 오류 */
     , NVL(F.FP_CALL_CNT, 0) AS FP_CALL_CNT                /* FP 실적 수신 완료 표시(시업 시각 일치) */
     , NVL(K.STOCK_TOT_CNT, 0) AS STOCK_TOT_CNT            /* 재고 수신 확인(PLAN_EE) 사용 행 */
     , NVL(K.STOCK_PASS_CNT, 0) AS STOCK_PASS_CNT          /* 그중 수신일 = 시험일 */
     , CASE WHEN E.CURRENT_PLAN_DATE_YN = 'N' AND NVL(F.FP_CALL_CNT, 0) > 0
             AND NVL(K.STOCK_TOT_CNT, 0) > 0 AND NVL(K.STOCK_TOT_CNT, 0) = NVL(K.STOCK_PASS_CNT, 0) THEN 'Y' ELSE 'N' END AS READY_YN
  FROM SSP_MST_SHIP_PLAN_SCHEDULE_EE E
     , (SELECT S.COMPANY_ID
             , COUNT(*) AS FP_CALL_CNT
          FROM SCM_SYS_LOOKUP_VALUE L
             , SCM_MST_SITE S
             , SCM_ADM_LOOKUP_MASTER_DETAIL L2
         WHERE S.SITE_ID = L.SEGMENT1
           AND L2.SEGMENT1 = S.PLANT_ID
           AND L2.SEGMENT4 = S.COMPANY_ID
           AND REPLACE(L2.SEGMENT2, ':', '') = L.SEGMENT2
           AND L2.LOOKUP_TYPE = 'BASIS_START_TIME_PLANT'
           AND L.LOOKUP_TYPE_CODE = 'AUTO_PLAN_CALL_FLAG'
           AND L.ACTIVE_FLAG = 'Y' AND L.ATTRIBUTE1 = (SELECT P_TEST_DATE FROM PRM)
         GROUP BY S.COMPANY_ID) F
     , (SELECT SEGMENT4 AS COMPANY_ID
             , COUNT(*) AS STOCK_TOT_CNT
             , SUM(CASE WHEN SEGMENT5 = (SELECT P_TEST_DATE FROM PRM) THEN 1 ELSE 0 END) AS STOCK_PASS_CNT
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'IF_STOCK_CHECK'
           AND VALID_YN = 'Y'
           AND SEGMENT1 = 'PLAN_EE' AND SEGMENT3 = 'EE'
         GROUP BY SEGMENT4) K
 WHERE F.COMPANY_ID(+) = E.COMPANY_ID
   AND K.COMPANY_ID(+) = E.COMPANY_ID
   AND E.PLAN_START_YYYYMMDD = (SELECT P_TEST_DATE FROM PRM)
 ORDER BY E.COMPANY_ID;

-- ==============================================================================================================
-- [VQ-41] 사업부별 재고 테이블 기준일 자료 존재 · 수신 시각
-- 분류 : 재고
-- 대상 : SSP_DNM_OWMS_STOCK · SSP_DNM_GMES_STOCK_81_82 · SSP_DNM_GMES_STOCK_EE · SSP_DNM_IWMS_STOCK_EE · SSP_DNM_OWMS_STOCK_EE · SSP_DNM_GMES_STOCK_40 · SSP_DNM_STOCK_C · SCM_DNM_SCS_STOCK
-- 확인 : 9행 모두 ROW_CNT 1건 이상, LAST_CREATED 가 시험일(Packer 기초재고 행은 시험일 - 2 이전 수신분). 기준일 규칙 = 「SSP 프로세스 확인 내용」 2026-11-20 판 8번 슬라이드
-- 사용 : 사전점검 No 8(사업부별 재고 I/F 수신 확인) / 사전점검 No 8(사업부별 재고 I/F 수신 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_TEST_DATE FROM DUAL)   /* 시험일. 이 줄의 값만 바꿔 실행 */
SELECT X.UNIT
     , X.TABLE_NAME
     , X.DATA_DATE_RULE
     , TO_CHAR(TO_DATE((SELECT P_TEST_DATE FROM PRM), 'YYYYMMDD') - X.DAY_OFFSET, 'YYYYMMDD') AS DATA_DATE
     , X.ROW_CNT
     , X.LAST_CREATED
  FROM (SELECT '81·82 · 40' AS UNIT, 'SSP_DNM_OWMS_STOCK' AS TABLE_NAME, '전일' AS DATA_DATE_RULE, 1 AS DAY_OFFSET, COUNT(*) AS ROW_CNT, MAX(CREATION_DATE) AS LAST_CREATED
          FROM SSP_DNM_OWMS_STOCK WHERE CUTOFF_DATE = TO_CHAR(TO_DATE((SELECT P_TEST_DATE FROM PRM), 'YYYYMMDD') - 1, 'YYYYMMDD')
         UNION ALL
        SELECT '81·82', 'SSP_DNM_GMES_STOCK_81_82', '당일', 0, COUNT(*), MAX(CREATION_DATE)
          FROM SSP_DNM_GMES_STOCK_81_82 WHERE YYYYMMDD = (SELECT P_TEST_DATE FROM PRM)
         UNION ALL
        SELECT '전극', 'SSP_DNM_GMES_STOCK_EE', '당일', 0, COUNT(*), MAX(CREATION_DATE)
          FROM SSP_DNM_GMES_STOCK_EE WHERE YYYYMMDD = (SELECT P_TEST_DATE FROM PRM)
         UNION ALL
        SELECT '전극', 'SSP_DNM_IWMS_STOCK_EE', '당일', 0, COUNT(*), MAX(CREATION_DATE)
          FROM SSP_DNM_IWMS_STOCK_EE WHERE YYYYMMDD = (SELECT P_TEST_DATE FROM PRM)
         UNION ALL
        SELECT '전극', 'SSP_DNM_OWMS_STOCK_EE', '당일', 0, COUNT(*), MAX(CREATION_DATE)
          FROM SSP_DNM_OWMS_STOCK_EE WHERE YYYYMMDD = (SELECT P_TEST_DATE FROM PRM)
         UNION ALL
        SELECT '40', 'SSP_DNM_GMES_STOCK_40', '당일', 0, COUNT(*), MAX(CREATION_DATE)
          FROM SSP_DNM_GMES_STOCK_40 WHERE YYYYMMDD = (SELECT P_TEST_DATE FROM PRM)
         UNION ALL
        SELECT '40', 'SSP_DNM_STOCK_C', '전일', 1, COUNT(*), MAX(CREATION_DATE)
          FROM SSP_DNM_STOCK_C WHERE CUTOFF_DATE = TO_DATE((SELECT P_TEST_DATE FROM PRM), 'YYYYMMDD') - 1
         UNION ALL
        SELECT 'Packer', 'SCM_DNM_SCS_STOCK', '전일(수신분)', 1, COUNT(*), MAX(CREATION_DATE)
          FROM SCM_DNM_SCS_STOCK WHERE CUTOFF_DATE = TO_CHAR(TO_DATE((SELECT P_TEST_DATE FROM PRM), 'YYYYMMDD') - 1, 'YYYYMMDD')
         UNION ALL
        SELECT 'Packer', 'SCM_DNM_SCS_STOCK', '시험일 - 3(산출 기초재고)', 3, COUNT(*), MAX(CREATION_DATE)
          FROM SCM_DNM_SCS_STOCK WHERE CUTOFF_DATE = TO_CHAR(TO_DATE((SELECT P_TEST_DATE FROM PRM), 'YYYYMMDD') - 3, 'YYYYMMDD')) X;

-- ==============================================================================================================
-- [VQ-42] 법인별 전일 ERP 재고(INVENTORY) 건수 · 수량
-- 분류 : 재고
-- 대상 : SCM_DNM_STOCK_V
-- 확인 : 81·82 컷오프 대상 법인마다 1건 이상. 0건(조회 안 됨) 법인은 컷오프가 진행되지 않음
-- 사용 : 사전점검 No 9(법인별 전일 ERP 재고 생성 확인) / 사전점검 No 9(법인별 전일 ERP 재고 생성 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_TEST_DATE FROM DUAL)   /* 시험일. 이 줄의 값만 바꿔 실행 */
SELECT COMPANY_ID
     , TO_CHAR(CUTOFF_DATE, 'YYYYMMDD') AS CUTOFF_DATE
     , COUNT(*) AS ROW_CNT
     , COUNT(DISTINCT ITEM_ID) AS ITEM_CNT
     , SUM(SSP_QTY) AS SSP_QTY
  FROM SCM_DNM_STOCK_V
     , PRM
 WHERE CUTOFF_DATE = TO_DATE(PRM.P_TEST_DATE, 'YYYYMMDD') - 1
   AND STOCK_TYPE = 'INVENTORY'
 GROUP BY COMPANY_ID
        , TO_CHAR(CUTOFF_DATE, 'YYYYMMDD')
 ORDER BY COMPANY_ID;

-- ==============================================================================================================
-- [VQ-43] 산출 입력 자료 최종 생성 일시
-- 분류 : 계획 입력
-- 대상 : SSP_DNM_FP_PLAN_FROZEN · SSP_DNM_FP_AMEND_SHIPAVAL · SCM_DNM_SCS_PROD_PLAN · SCM_DNM_SCS_STOCK
-- 확인 : 4행 모두 LAST_CREATED 가 시험일. FP 확정 생산계획은 81·82 · 40 · 전극 산출이, SCS 자료는 Packer 산출이 읽음
-- 사용 : 사전점검 No 10(산출 입력 자료 갱신 확인) / 사전점검 No 10(산출 입력 자료 갱신 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_TEST_DATE FROM DUAL)   /* 시험일. 이 줄의 값만 바꿔 실행 */
SELECT 'SSP_DNM_FP_PLAN_FROZEN' AS TABLE_NAME, 'FP 확정 생산계획' AS DATA_NAME
     , COUNT(*) AS ROW_CNT, MIN(PLAN_DATE) AS MIN_DATE, MAX(PLAN_DATE) AS MAX_DATE, MAX(CREATION_DATE) AS LAST_CREATED
  FROM SSP_DNM_FP_PLAN_FROZEN
 UNION ALL
SELECT 'SSP_DNM_FP_AMEND_SHIPAVAL', 'FP 출하가능량'
     , COUNT(*), MIN(PLAN_DATE), MAX(PLAN_DATE), MAX(CREATION_DATE)
  FROM SSP_DNM_FP_AMEND_SHIPAVAL
 UNION ALL
SELECT 'SCM_DNM_SCS_PROD_PLAN', 'SCS 생산계획'
     , COUNT(*), MIN(PROD_DATE), MAX(PROD_DATE), MAX(CREATION_DATE)
  FROM SCM_DNM_SCS_PROD_PLAN
     , PRM
 WHERE CUTOFF_DATE >= TO_CHAR(TO_DATE(PRM.P_TEST_DATE, 'YYYYMMDD') - 3, 'YYYYMMDD')
 UNION ALL
SELECT 'SCM_DNM_SCS_STOCK', 'SCS 재고'
     , COUNT(*), MIN(CUTOFF_DATE), MAX(CUTOFF_DATE), MAX(CREATION_DATE)
  FROM SCM_DNM_SCS_STOCK
     , PRM
 WHERE CUTOFF_DATE >= TO_CHAR(TO_DATE(PRM.P_TEST_DATE, 'YYYYMMDD') - 3, 'YYYYMMDD');

-- ==============================================================================================================
-- [VQ-44] 산출 공통 코드(법인 설명 · 시업 시각 · Packer 산출 기준일 · 통합 스냅샷 대상)
-- 분류 : 기준정보
-- 대상 : SCM_ADM_LOOKUP_MASTER_DETAIL
-- 확인 : 산출 대상 법인의 COMPANY_DESC · BASIS_START_TIME_PLANT 행 존재. SSP_ANL_SHIP_PLAN_P · SSP_ANL_SHIP_PLAN_ALL 의 ATTRIBUTE1 = 최종 산출 기준일
-- 사용 : 사전점검 No 2(시험일 일 계획 ID · 일 마감 진행 행 · 산출 공통 코드 확인) / 사전점검 No 37(사업부별 출하계획 · 확정 통합 스냅샷 생성 확인)
-- ==============================================================================================================
SELECT LOOKUP_TYPE
     , SEGMENT1
     , SEGMENT2
     , SEGMENT3
     , SEGMENT4
     , ATTRIBUTE1
     , VALID_YN
     , LAST_UPDATE_DATE
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE IN ('COMPANY_DESC', 'BASIS_START_TIME_PLANT', 'SSP_ANL_SHIP_PLAN_P', 'SSP_ANL_SHIP_PLAN_ALL')
   AND VALID_YN = 'Y'
 ORDER BY LOOKUP_TYPE
        , DISPLAY_SEQ
        , SEGMENT1;

-- ==============================================================================================================
-- [VQ-45] 40 출하계획 산출 결과 구성(법인 · Measure 별)
-- 분류 : 일 산출
-- 대상 : SSP_ANL_SHIP_PLAN_40
-- 확인 : 계획 시작일 = 시험일. 법인(HQ00 · AZ00 · NJ00)마다 행 생성, 기간 = 계획 시작일 - 1 ~ + 83일. AS-IS 같은 기준일 결과와 건수 · 수량 대조
-- 사용 : 사전점검 No 15(재고 수신 확인 미충족 상태에서 40 출하계획 생성 실행 → 건너뜀 확인) / 사전점검 No 17(40 출하계획 생성 결과 구성 확인) / 사전점검 No 19(40 산출 결과 AS-IS 같은 기준일 대조) / 사전점검 No 19(40 산출 결과 AS-IS 같은 기준일 대조) / 사전점검 No 19(40 산출 결과 AS-IS 같은 기준일 대조) / 사전점검 No 20(같은 날 40 산출 재실행 시 중복 생성 없음 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_PLAN_START FROM DUAL)   /* 계획 시작일 = 시험일. 이 줄의 값만 바꿔 실행 */
SELECT ATTRIBUTE10 AS COMPANY_ID
     , MEASURE
     , COUNT(*) AS ROW_CNT
     , COUNT(DISTINCT ITEM_ID) AS ITEM_CNT
     , MIN(YYYYMMDD) AS MIN_DATE
     , MAX(YYYYMMDD) AS MAX_DATE
     , SUM(QTY) AS QTY
     , MAX(LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
  FROM SSP_ANL_SHIP_PLAN_40
     , PRM
 WHERE DIVISION_ID = '40'
   AND PLAN_START_YYYYMMDD = PRM.P_PLAN_START
 GROUP BY ATTRIBUTE10
        , MEASURE
 ORDER BY ATTRIBUTE10
        , MEASURE;

-- ==============================================================================================================
-- [VQ-46] 40 당일 BALANCE 산식 불일치 행
-- 분류 : 일 산출
-- 대상 : SSP_ANL_SHIP_PLAN_40
-- 확인 : 조회 0건이면 정상. 계획 시작일 당일 BALANCE = WH_STOCK - SHIP_CONFIRM - POSTP_PLAN (법인 · From Site · 품목 단위)
-- 사용 : 사전점검 No 18(40 당일 BALANCE 산식 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_PLAN_START FROM DUAL)   /* 계획 시작일 = 시험일. 이 줄의 값만 바꿔 실행 */
SELECT X.COMPANY_ID
     , X.FROM_SITE
     , X.ITEM_ID
     , X.WH_STOCK
     , X.SHIP_CONFIRM
     , X.POSTP_PLAN
     , X.BALANCE
     , X.WH_STOCK - X.SHIP_CONFIRM - X.POSTP_PLAN AS CALC_BALANCE
  FROM (SELECT ATTRIBUTE10 AS COMPANY_ID
             , FROM_SITE
             , ITEM_ID
             , SUM(CASE WHEN MEASURE = 'WH_STOCK' THEN QTY ELSE 0 END) AS WH_STOCK
             , SUM(CASE WHEN MEASURE = 'SHIP_CONFIRM' THEN QTY ELSE 0 END) AS SHIP_CONFIRM
             , SUM(CASE WHEN MEASURE = 'POSTP_PLAN' THEN QTY ELSE 0 END) AS POSTP_PLAN
             , SUM(CASE WHEN MEASURE = 'BALANCE' THEN QTY ELSE 0 END) AS BALANCE
             , SUM(CASE WHEN MEASURE = 'BALANCE' THEN 1 ELSE 0 END) AS BALANCE_ROW_CNT
          FROM SSP_ANL_SHIP_PLAN_40
             , PRM
         WHERE DIVISION_ID = '40'
           AND PLAN_START_YYYYMMDD = PRM.P_PLAN_START
           AND YYYYMMDD = PRM.P_PLAN_START
         GROUP BY ATTRIBUTE10
                , FROM_SITE
                , ITEM_ID) X
 WHERE X.BALANCE_ROW_CNT > 0
   AND X.BALANCE <> X.WH_STOCK - X.SHIP_CONFIRM - X.POSTP_PLAN
 ORDER BY X.COMPANY_ID
        , X.FROM_SITE
        , X.ITEM_ID;

-- ==============================================================================================================
-- [VQ-47] 81·82 OWMS 재고 마감 자료(법인 · 사업부 별)
-- 분류 : 일 산출
-- 대상 : SSP_ANL_OWMS_STOCK_C2
-- 확인 : 컷오프 완료 법인마다 행 존재. CUTOFF_DATE = 시험일 - 1, PLAN_START_YYYYMMDD = 시험일, 최종 변경자 ssp_batch
-- 사용 : 사전점검 No 23(OWMS 재고 마감 자료 생성 확인) / 사전점검 No 23(OWMS 재고 마감 자료 생성 확인) / 사전점검 No 27(같은 날 81·82 컷오프 재실행 시 중복 생성 없음 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_TEST_DATE FROM DUAL)   /* 시험일. 이 줄의 값만 바꿔 실행 */
SELECT COMPANY_ID
     , DIVISION_ID
     , CUTOFF_DATE
     , PLAN_START_YYYYMMDD
     , COUNT(*) AS ROW_CNT
     , COUNT(DISTINCT ITEM_ID) AS ITEM_CNT
     , SUM(STOCK_QTY) AS STOCK_QTY
     , SUM(AVAILABLE_QTY) AS AVAILABLE_QTY
     , MAX(LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
  FROM SSP_ANL_OWMS_STOCK_C2
     , PRM
 WHERE CUTOFF_DATE = TO_CHAR(TO_DATE(PRM.P_TEST_DATE, 'YYYYMMDD') - 1, 'YYYYMMDD')
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
WITH PRM AS (SELECT '20261124' AS P_PLAN_START FROM DUAL)   /* 계획 시작일 = 시험일 - 1. 이 줄의 값만 바꿔 실행 */
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
  FROM SSP_ANL_SHIP_PLAN_C
     , PRM
 WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START
 GROUP BY COMPANY_ID
        , DIVISION_ID
        , MEASURE
 ORDER BY COMPANY_ID
        , DIVISION_ID
        , MEASURE;

-- ==============================================================================================================
-- [VQ-49] 81·82 BALANCE 산식 불일치 행
-- 분류 : 일 산출
-- 대상 : SSP_ANL_SHIP_PLAN_C
-- 확인 : 조회 0건이면 정상. 일자별 BALANCE = WH_STOCK - SHIP_PLAN (법인 · 사업부 · From Site · 품목 단위)
-- 사용 : 사전점검 No 25(81·82 BALANCE 산식 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261124' AS P_PLAN_START FROM DUAL)   /* 계획 시작일 = 시험일 - 1. 이 줄의 값만 바꿔 실행 */
SELECT X.COMPANY_ID
     , X.DIVISION_ID
     , X.FROM_SITE
     , X.ITEM_ID
     , X.YYYYMMDD
     , X.WH_STOCK
     , X.SHIP_PLAN
     , X.BALANCE
     , X.WH_STOCK - X.SHIP_PLAN AS CALC_BALANCE
  FROM (SELECT COMPANY_ID
             , DIVISION_ID
             , FROM_SITE
             , ITEM_ID
             , YYYYMMDD
             , SUM(CASE WHEN MEASURE = 'WH_STOCK' THEN QTY ELSE 0 END) AS WH_STOCK
             , SUM(CASE WHEN MEASURE = 'SHIP_PLAN' THEN QTY ELSE 0 END) AS SHIP_PLAN
             , SUM(CASE WHEN MEASURE = 'BALANCE' THEN QTY ELSE 0 END) AS BALANCE
             , SUM(CASE WHEN MEASURE = 'BALANCE' THEN 1 ELSE 0 END) AS BALANCE_ROW_CNT
          FROM SSP_ANL_SHIP_PLAN_C
             , PRM
         WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START
         GROUP BY COMPANY_ID
                , DIVISION_ID
                , FROM_SITE
                , ITEM_ID
                , YYYYMMDD) X
 WHERE X.BALANCE_ROW_CNT > 0
   AND X.BALANCE <> X.WH_STOCK - X.SHIP_PLAN
 ORDER BY X.COMPANY_ID
        , X.DIVISION_ID
        , X.FROM_SITE
        , X.ITEM_ID
        , X.YYYYMMDD;

-- ==============================================================================================================
-- [VQ-50] Packer 출하계획 산출 결과 구성(Measure 별)
-- 분류 : 일 산출
-- 대상 : SSP_ANL_SHIP_PLAN_P
-- 확인 : 계획 시작일 = 시험일 - 1. Measure 6종, 기간 = 계획 시작일 - 1 ~ + 55일(57일). AS-IS 같은 기준일 결과와 건수 · 수량 대조
-- 사용 : 사전점검 No 29(Packer 출하계획 생성 결과 구성 확인) / 사전점검 No 30(Packer BALANCE 산식 확인 · AS-IS 같은 기준일 대조) / 사전점검 No 30(Packer BALANCE 산식 확인 · AS-IS 같은 기준일 대조) / 사전점검 No 30(Packer BALANCE 산식 확인 · AS-IS 같은 기준일 대조) / 사전점검 No 31(같은 날 Packer 산출 재실행 시 건너뜀 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261124' AS P_PLAN_START FROM DUAL)   /* 계획 시작일 = 시험일 - 1. 이 줄의 값만 바꿔 실행 */
SELECT DIVISION_ID
     , MEASURE
     , COUNT(*) AS ROW_CNT
     , COUNT(DISTINCT ITEM_ID) AS ITEM_CNT
     , COUNT(DISTINCT YYYYMMDD) AS DAY_CNT
     , MIN(YYYYMMDD) AS MIN_DATE
     , MAX(YYYYMMDD) AS MAX_DATE
     , SUM(QTY) AS QTY
     , MAX(LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
  FROM SSP_ANL_SHIP_PLAN_P
     , PRM
 WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START
 GROUP BY DIVISION_ID
        , MEASURE
 ORDER BY DIVISION_ID
        , MEASURE;

-- ==============================================================================================================
-- [VQ-51] Packer BALANCE 산식 불일치 행
-- 분류 : 일 산출
-- 대상 : SSP_ANL_SHIP_PLAN_P
-- 확인 : 조회 0건이면 정상. 일자별 BALANCE = WH_STOCK - SHIP_CONFIRM (From Site · 품목 단위)
-- 사용 : 사전점검 No 30(Packer BALANCE 산식 확인 · AS-IS 같은 기준일 대조)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261124' AS P_PLAN_START FROM DUAL)   /* 계획 시작일 = 시험일 - 1. 이 줄의 값만 바꿔 실행 */
SELECT X.FROM_SITE
     , X.ITEM_ID
     , X.YYYYMMDD
     , X.WH_STOCK
     , X.SHIP_CONFIRM
     , X.BALANCE
     , X.WH_STOCK - X.SHIP_CONFIRM AS CALC_BALANCE
  FROM (SELECT FROM_SITE
             , ITEM_ID
             , YYYYMMDD
             , SUM(CASE WHEN MEASURE = 'WH_STOCK' THEN QTY ELSE 0 END) AS WH_STOCK
             , SUM(CASE WHEN MEASURE = 'SHIP_CONFIRM' THEN QTY ELSE 0 END) AS SHIP_CONFIRM
             , SUM(CASE WHEN MEASURE = 'BALANCE' THEN QTY ELSE 0 END) AS BALANCE
             , SUM(CASE WHEN MEASURE = 'BALANCE' THEN 1 ELSE 0 END) AS BALANCE_ROW_CNT
          FROM SSP_ANL_SHIP_PLAN_P
             , PRM
         WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START
         GROUP BY FROM_SITE
                , ITEM_ID
                , YYYYMMDD) X
 WHERE X.BALANCE_ROW_CNT > 0
   AND X.BALANCE <> X.WH_STOCK - X.SHIP_CONFIRM
 ORDER BY X.FROM_SITE
        , X.ITEM_ID
        , X.YYYYMMDD;

-- ==============================================================================================================
-- [VQ-52] 전극 출하계획 산출 결과 구성(법인 · 사업부 · Measure 별)
-- 분류 : 일 산출
-- 대상 : SSP_ANL_SHIP_PLAN_EE
-- 확인 : 계획 시작일 = 시험일. 산출 법인마다 MEASURE_TYPE R(요청용) · P(계획용) 행 생성. AS-IS 같은 기준일 결과와 건수 · 수량 대조
-- 사용 : 사전점검 No 34(전극 출하계획 생성 결과 구성 확인) / 사전점검 No 35(전극 산출 결과 AS-IS 같은 기준일 대조) / 사전점검 No 35(전극 산출 결과 AS-IS 같은 기준일 대조) / 사전점검 No 35(전극 산출 결과 AS-IS 같은 기준일 대조) / 사전점검 No 36(같은 날 전극 산출 재실행 시 중복 생성 없음 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_PLAN_START FROM DUAL)   /* 계획 시작일 = 시험일. 이 줄의 값만 바꿔 실행 */
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
  FROM SSP_ANL_SHIP_PLAN_EE
     , PRM
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
WITH PRM AS (SELECT '20261125' AS P_PLAN_START FROM DUAL)   /* 계획 시작일 = 시험일. 이 줄의 값만 바꿔 실행 */
SELECT 'SSP_ANL_BOH_CUTOFF_EE' AS TABLE_NAME
     , COMPANY_ID
     , DIVISION_ID
     , COUNT(*) AS ROW_CNT
     , SUM(TOT_BOH_QTY) AS QTY
     , MAX(LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
  FROM SSP_ANL_BOH_CUTOFF_EE
     , PRM
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
  FROM SSP_ANL_STOCK_EE_C
     , PRM
 WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START
   AND COMPANY_ID IN (SELECT COMPANY_ID FROM SSP_MST_SHIP_PLAN_SCHEDULE_EE WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START)
 GROUP BY COMPANY_ID
        , DIVISION_ID
 ORDER BY 1
        , 2
        , 3;

-- ==============================================================================================================
-- [VQ-54] 일 마감 진행 표시(시험일 행 · 전일 행) 81·82 · 전극
-- 분류 : 일 산출
-- 대상 : SSP_MST_SHIP_PLAN_SCHEDULE · SSP_MST_SHIP_PLAN_SCHEDULE_EE
-- 확인 : 산출 후 시험일 행 = CURRENT_PLAN_DATE_YN Y(81·82 는 ERP · OWMS 재고 마감도 Y), 전일 행 = PLAN_CUTOFF_CREATE_YN · CONFIRM_CREATE_YN Y(81·82 는 FP_TARGET_SEND_YN 도 Y)
-- 사용 : 사전점검 No 21(진입 조건 미충족 법인 건너뜀 확인) / 사전점검 No 22(81·82 컷오프 실행 · 법인별 단계 순서 확인) / 사전점검 No 27(같은 날 81·82 컷오프 재실행 시 중복 생성 없음 확인) / 사전점검 No 32(FP 실적 수신 완료 표시가 없는 법인 건너뜀 확인) / 사전점검 No 33(전극 산출 실행 · 법인별 진행 확인) / 사전점검 No 36(같은 날 전극 산출 재실행 시 중복 생성 없음 확인) / 사전점검 No 40(산출 중 오류 발생 시 처리 확인(오류가 발생한 경우에 수행))
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_TEST_DATE FROM DUAL)   /* 시험일. 이 줄의 값만 바꿔 실행 */
SELECT '81·82' AS UNIT
     , COMPANY_ID
     , PLAN_START_YYYYMMDD
     , CURRENT_PLAN_DATE_YN
     , ERP_STOCK_CUTOFF_YN
     , OWMS_STOCK_CUTOFF_YN
     , PLAN_CUTOFF_CREATE_YN
     , CONFIRM_CREATE_YN
     , FP_TARGET_SEND_YN
     , LAST_UPDATE_DATE
  FROM SSP_MST_SHIP_PLAN_SCHEDULE
     , PRM
 WHERE PLAN_START_YYYYMMDD IN (PRM.P_TEST_DATE, TO_CHAR(TO_DATE(PRM.P_TEST_DATE, 'YYYYMMDD') - 1, 'YYYYMMDD'))
 UNION ALL
SELECT '전극'
     , COMPANY_ID
     , PLAN_START_YYYYMMDD
     , CURRENT_PLAN_DATE_YN            /* N 미수행, P 진행 중, Y 완료, E 오류 */
     , NULL
     , NULL
     , PLAN_CUTOFF_CREATE_YN
     , CONFIRM_CREATE_YN
     , FP_TARGET_SEND_YN
     , LAST_UPDATE_DATE
  FROM SSP_MST_SHIP_PLAN_SCHEDULE_EE
     , PRM
 WHERE PLAN_START_YYYYMMDD IN (PRM.P_TEST_DATE, TO_CHAR(TO_DATE(PRM.P_TEST_DATE, 'YYYYMMDD') - 1, 'YYYYMMDD'))
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
WITH PRM AS (SELECT '20261124' AS P_PLAN_START FROM DUAL)   /* 계획 시작일 = 시험일 - 1. 이 줄의 값만 바꿔 실행 */
SELECT DIVISION_ID
     , COMPANY_ID
     , NVL(ELECTRODE_YN, 'N') AS ELECTRODE_YN
     , COUNT(*) AS ROW_CNT
     , COUNT(DISTINCT CONFIRM_ID) AS CONFIRM_CNT
     , SUM(SHIPMENT_CONFIRM_QTY) AS SHIPMENT_CONFIRM_QTY
     , SUM(SHIPPING_PLAN_QTY) AS SHIPPING_PLAN_QTY
     , MAX(UPDATED_DATE) AS UPDATED_DATE
  FROM SSP_ANL_SHIP_PLAN_ALL
     , PRM
 WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START
 GROUP BY DIVISION_ID
        , COMPANY_ID
        , NVL(ELECTRODE_YN, 'N')
 ORDER BY DIVISION_ID
        , COMPANY_ID;

-- ==============================================================================================================
-- [VQ-56] 산출 배치가 만든 확정 원장(사업부 · 상태 별)
-- 분류 : 일 산출
-- 대상 : SSP_ANL_SHIP_CONFIRM
-- 확인 : 산출 직후 확정구간에 들어온 선적요청이 확정 행으로 생성됨. 이후 화면 · ERP 송신 검증은 테스트케이스 시트(VQ-01 ~ VQ-05)
-- 사용 : 사전점검 No 38(산출 배치가 만든 확정 원장 확인(테스트케이스 시트 연결 지점)) / 사전점검 No 38(산출 배치가 만든 확정 원장 확인(테스트케이스 시트 연결 지점))
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_TEST_DATE FROM DUAL)   /* 시험일. 이 줄의 값만 바꿔 실행 */
SELECT DIVISION_ID
     , CHANGE_TYPE
     , SHIPMENT_STATUS               /* C 확정, D 작성 중, R 요청 완료, P 계획 */
     , COUNT(*) AS ROW_CNT
     , SUM(QTY) AS QTY
     , MIN(YYYYMMDD) AS MIN_DATE
     , MAX(YYYYMMDD) AS MAX_DATE
     , MAX(CREATION_DATE) AS LAST_CREATED
  FROM SSP_ANL_SHIP_CONFIRM
     , PRM
 WHERE CREATION_DATE >= TO_DATE(PRM.P_TEST_DATE, 'YYYYMMDD')
   AND CREATION_DATE < TO_DATE(PRM.P_TEST_DATE, 'YYYYMMDD') + 1
   AND CREATED_BY = 'ssp_batch'
 GROUP BY DIVISION_ID
        , CHANGE_TYPE
        , SHIPMENT_STATUS
 ORDER BY DIVISION_ID
        , CHANGE_TYPE
        , SHIPMENT_STATUS;

-- ==============================================================================================================
-- [VQ-57] 일 마감 지연 · 오류 문자 적재(문구 별)
-- 분류 : 감시
-- 대상 : XIF_IFS_SMS_DATA_SN
-- 확인 : 지연 : 「[사업부 구분 CUTOFF DELAY - 법인]」 문구가 수신자 수만큼 적재. 완료 법인은 적재 없음. 오류 문자도 같은 테이블에 적재
-- 사용 : 사전점검 No 39(일 마감 지연 문자 적재 확인) / 사전점검 No 40(산출 중 오류 발생 시 처리 확인(오류가 발생한 경우에 수행))
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_TEST_DATE, 'CUTOFF' AS P_KEYWORD FROM DUAL)   /* 시험일 · 문구 일부. 이 줄의 값만 바꿔 실행 */
SELECT TR_MSG
     , COUNT(*) AS SEND_CNT
     , MIN(IF_INS_DATE) AS FIRST_INS_DATE
     , MAX(IF_INS_DATE) AS LAST_INS_DATE
     , MAX(IF_FLAG) AS IF_FLAG
  FROM XIF_IFS_SMS_DATA_SN
     , PRM
 WHERE IF_INS_DATE >= TO_DATE(PRM.P_TEST_DATE, 'YYYYMMDD')
   AND IF_INS_DATE < TO_DATE(PRM.P_TEST_DATE, 'YYYYMMDD') + 1
   AND TR_MSG LIKE '%' || PRM.P_KEYWORD || '%'
 GROUP BY TR_MSG
 ORDER BY MIN(IF_INS_DATE);

-- ==============================================================================================================
-- [VQ-27] 출하요청 3종(SEMI · FG / Packer / 전극) 품목별 수량 (검증쿼리 시트 VQ-27 와 같은 쿼리 · AS-IS 대조용)
-- 분류 : 출하요청
-- 대상 : DM_PLN_SHIPMENT_REQ · SSP_ANL_SHIP_REQ_P · SSP_ANL_SHIP_REQ_EE
-- 확인 : 화면 조회 수량 = 쿼리 수량, 입력 · 저장 후 증감 반영
-- 사용 : 사전점검 No 11(사업부별 선적요청(Shipment Request) 존재 확인) / 사전점검 No 11(사업부별 선적요청(Shipment Request) 존재 확인)
-- ==============================================================================================================
WITH PRM AS (SELECT 'MCCM349215A1-111' AS P_ITEM_ID, '20261125' AS P_FROM_YYYYMMDD, '20261231' AS P_TO_YYYYMMDD FROM DUAL)   /* 품목 · 출하일 시작 · 출하일 종료. 이 줄의 값만 바꿔 실행 */
SELECT 'DM_PLN_SHIPMENT_REQ' AS SRC
     , DIVISION_ID
     , SITE_TYPE                     /* PLANT = SEMI, SALES = FG */
     , YYYYMMDD
     , SUM(QTY) AS QTY
  FROM DM_PLN_SHIPMENT_REQ
     , PRM
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
  FROM SSP_ANL_SHIP_REQ_P
     , PRM
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
  FROM SSP_ANL_SHIP_REQ_EE
     , PRM
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
WITH PRM AS (SELECT '20261125' AS P_PLAN_START FROM DUAL)   /* 계획 시작일 = 시험일. 이 줄의 값만 바꿔 실행 */
SELECT 'SSP_ANL_SHIP_PLAN_40' AS TABLE_NAME
     , COUNT(*) AS ROW_CNT
     , SUM(QTY) AS QTY
  FROM SSP_ANL_SHIP_PLAN_40
     , PRM
 WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START
 UNION ALL
SELECT 'SSP_ANL_SHIP_PLAN_C'
     , COUNT(*)
     , SUM(QTY)
  FROM SSP_ANL_SHIP_PLAN_C
     , PRM
 WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START
 UNION ALL
SELECT 'SSP_ANL_SHIP_PLAN_P'
     , COUNT(*)
     , SUM(QTY)
  FROM SSP_ANL_SHIP_PLAN_P
     , PRM
 WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START
 UNION ALL
SELECT 'SSP_ANL_SHIP_PLAN_EE'
     , COUNT(*)
     , SUM(QTY)
  FROM SSP_ANL_SHIP_PLAN_EE
     , PRM
 WHERE PLAN_START_YYYYMMDD = PRM.P_PLAN_START;
