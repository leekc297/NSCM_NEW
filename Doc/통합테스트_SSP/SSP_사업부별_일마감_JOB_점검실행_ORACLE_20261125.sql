-- ==============================================================================================================
-- SSP 사업부별 일마감 JOB 점검 · 실행 · Oracle(클라우드) · 실행일 20261125
-- 순서 : 1부 점검(조회 문장) → 결과 확인 → 2부 실행(변경 문장, 사업부 블록 하나씩) → 3부 실행 뒤 확인
-- 실행 : DBeaver = 쿼리 · 블록 안에 커서를 두고 Ctrl+Enter(블록 아래 / 줄은 실행하지 않음). SQL Developer · SQLcl = 블록과 / 줄까지 선택해 실행
--        파일 전체 실행(F5, Alt+X)은 하지 않음. 2부 블록이 한꺼번에 돌아감
-- 주의 : 2부는 프로그램 안에서 COMMIT 함. 되돌릴 수 없음. 2부 실행 전 1부 결과로 진입 조건 확인
--        산출 프로그램은 날짜 인자가 없고 실행 시각(SYSDATE) 기준. 실행일(20261125) 당일에 실행해야 함
-- 일마감 JOB(사내 ZIOUI1 2026-11-25 17:13:43 조회 · AS-IS 개발 msdb JOB 8개와 단계 · 인자 일치)
--   40 HQ00 = JOB_PR_SSP_PLN_SHIP_PLAN_40 · 40 AZ00 = _40_AZ · 40 NJ00 = _40_C
--   81·82 = JOB_PR_SSP_PLN_SHIP_PLAN_81_82(PR_SSP_PLN_SHIP_PLAN_CUTOFF) · 전극 = JOB_PR_SSP_PLN_SHIP_PLAN_EE · Packer = JOB_PR_SSP_PLN_SHIP_PLAN_P
--   통합 스냅샷 = JOB_PR_SSP_ANL_SHIP_PLAN_ALL · 마감 지연 문자 = JOB_PR_SSP_DAILY_PLAN_CUTOFF_CHECK_SMS_SEND(문자 발송이라 2부에 넣지 않음)
-- 마감 판정 · 기준 시각 = PR_SSP_DAILY_PLAN_CUTOFF_CHECK_SMS_SEND 원문(LAST_DDL_TIME 2026-11-17 17:17:14)
--   81·82 · 전극 = 실행일 스케줄 행 CURRENT_PLAN_DATE_YN = Y · 40 = 실행일 SSP_ANL_SHIP_PLAN_40 SHIP_CONFIRM 행 1건 이상(법인 = ATTRIBUTE10)
-- 40 은 실행일 일 계획 ID(SCM_MST_PLAN DAILY)가 있어야 함([VQ-35]). 없으면 SCM_MST_PLAN_일계획ID_생성_실행쿼리 파일 먼저
-- 생성 2026-11-25 17:13 · tools/Analysis/ssp_it_precheck/gen_cutoff_sql.py
-- ==============================================================================================================


-- ==============================================================================================================
-- 1부 점검(조회 문장)
-- ==============================================================================================================


-- ==============================================================================================================
-- [C0] 사업부 · 법인별 일마감 현황
-- 확인 : STATUS = 마감 완료 / 마감 전 / 마감 지연(기준 시각 지남). 2부에서 실행할 사업부 · 법인을 고름
--       81·82 · 전극 법인 행이 없으면 실행일 스케줄 행이 없는 것. 그 법인은 마감되지 않음
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */
, BASE AS (
SELECT '81·82' AS UNIT
     , S.COMPANY_ID
     , S.CURRENT_PLAN_DATE_YN AS DONE_FLAG
     , CASE WHEN S.CURRENT_PLAN_DATE_YN = 'Y' THEN 'Y' ELSE 'N' END AS DONE_YN
     , S.LAST_UPDATE_DATE
     , CASE S.COMPANY_ID WHEN 'WA00' THEN '16:20' WHEN 'NJ00' THEN '10:40' WHEN 'NB00' THEN '10:40' WHEN 'HM00' THEN '09:30'
                         WHEN 'HQ00' THEN '07:30' WHEN 'HG00' THEN '20:40' WHEN 'GM00' THEN '21:10' WHEN 'HD00' THEN '21:40'
                         WHEN 'MI00' THEN '20:40' WHEN 'NA00' THEN '10:40' WHEN 'ST00' THEN '20:40' END AS CUTOFF_TIME
  FROM SSP_MST_SHIP_PLAN_SCHEDULE S
     , PRM
 WHERE S.PLAN_START_YYYYMMDD = PRM.P_DAY
 UNION ALL
SELECT '전극'
     , E.COMPANY_ID
     , E.CURRENT_PLAN_DATE_YN
     , CASE WHEN E.CURRENT_PLAN_DATE_YN = 'Y' THEN 'Y' ELSE 'N' END
     , E.LAST_UPDATE_DATE
     , CASE E.COMPANY_ID WHEN 'WA00' THEN '15:50' WHEN 'NJ00' THEN '11:50' WHEN 'NB00' THEN '10:50' WHEN 'HM00' THEN '09:50'
                         WHEN 'HQ00' THEN '07:50' WHEN 'HG00' THEN '21:00' WHEN 'GM00' THEN '20:00' WHEN 'HD00' THEN '20:50'
                         WHEN 'MI00' THEN '20:50' WHEN 'NA00' THEN '10:50' WHEN 'ST00' THEN '20:50' END
  FROM SSP_MST_SHIP_PLAN_SCHEDULE_EE E
     , PRM
 WHERE E.PLAN_START_YYYYMMDD = PRM.P_DAY
 UNION ALL
SELECT '40'
     , C.COMPANY_ID
     , TO_CHAR(NVL(P.CNT, 0))
     , CASE WHEN NVL(P.CNT, 0) > 0 THEN 'Y' ELSE 'N' END
     , P.LAST_UPDATE_DATE
     , C.CUTOFF_TIME
  FROM (SELECT 'HQ00' AS COMPANY_ID, '08:10' AS CUTOFF_TIME FROM DUAL
         UNION ALL
        SELECT 'AZ00', '10:40' FROM DUAL
         UNION ALL
        SELECT 'NJ00', '11:10' FROM DUAL) C
     , (SELECT A.ATTRIBUTE10 AS COMPANY_ID
             , COUNT(*) AS CNT
             , MAX(A.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
          FROM SSP_ANL_SHIP_PLAN_40 A
             , PRM
         WHERE A.DIVISION_ID         = '40'
           AND A.PLAN_START_YYYYMMDD = PRM.P_DAY
           AND A.MEASURE             = 'SHIP_CONFIRM'
         GROUP BY A.ATTRIBUTE10) P
 WHERE P.COMPANY_ID(+) = C.COMPANY_ID
)
SELECT B.UNIT
     , B.COMPANY_ID
     , B.CUTOFF_TIME
     , B.DONE_FLAG       /* 81·82 · 전극 = CURRENT_PLAN_DATE_YN(N 미수행, P 진행 중, Y 완료, E 오류) · 40 = 당일 SHIP_CONFIRM 행 수 */
     , B.DONE_YN
     , CASE WHEN B.DONE_YN = 'Y' THEN '마감 완료'
            WHEN PRM.P_DAY < TO_CHAR(SYSDATE, 'YYYYMMDD') OR (PRM.P_DAY = TO_CHAR(SYSDATE, 'YYYYMMDD') AND B.CUTOFF_TIME < TO_CHAR(SYSDATE, 'HH24:MI')) THEN '마감 지연'
            ELSE '마감 전' END AS STATUS
     , B.LAST_UPDATE_DATE
  FROM BASE B
     , PRM
 ORDER BY DECODE(B.UNIT, '40', 1, '81·82', 2, 3)
        , B.CUTOFF_TIME
        , B.COMPANY_ID;


-- ==============================================================================================================
-- [C1] 일마감 JOB 상태 · 실행 중 JOB
-- 확인 : ENABLED = TRUE 이면 스케줄대로 자동 실행됨. RUNNING_SID 값이 있으면 실행 중이므로 2부 같은 블록 실행하지 않음
-- ==============================================================================================================
SELECT J.JOB_NAME
     , J.ENABLED
     , J.STATE
     , NVL(J.REPEAT_INTERVAL, J.SCHEDULE_NAME) AS SCHEDULE
     , J.LAST_START_DATE
     , J.LAST_RUN_DURATION
     , J.NEXT_RUN_DATE
     , R.SESSION_ID AS RUNNING_SID
     , R.ELAPSED_TIME AS RUNNING_ELAPSED
  FROM ALL_SCHEDULER_JOBS J
  LEFT JOIN ALL_SCHEDULER_RUNNING_JOBS R
    ON R.OWNER    = J.OWNER
   AND R.JOB_NAME = J.JOB_NAME
 WHERE J.OWNER = 'SCM_MGR'
   AND J.JOB_NAME IN ('JOB_PR_SSP_PLN_SHIP_PLAN_40',
                      'JOB_PR_SSP_PLN_SHIP_PLAN_40_AZ',
                      'JOB_PR_SSP_PLN_SHIP_PLAN_40_C',
                      'JOB_PR_SSP_PLN_SHIP_PLAN_81_82',
                      'JOB_PR_SSP_PLN_SHIP_PLAN_EE',
                      'JOB_PR_SSP_PLN_SHIP_PLAN_P',
                      'JOB_PR_SSP_ANL_SHIP_PLAN_ALL',
                      'JOB_PR_SSP_DAILY_PLAN_CUTOFF_CHECK_SMS_SEND')
 ORDER BY J.JOB_NAME;


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
-- 2부 실행(변경 문장) : 사업부 블록 하나씩. 실행 전 [C0] [C1] 과 블록에 적힌 확인 쿼리
-- ==============================================================================================================


-- ==============================================================================================================
-- [R1] 40(Mobility&IT) 법인 HQ00 일마감
-- JOB : JOB_PR_SSP_PLN_SHIP_PLAN_40(운영 매일 08:00 · 마감 기준 08:10)
-- 실행 전 확인 : [C0] 40 HQ00 · [VQ-35] · [VQ-37] · 실행 뒤 확인 : [C0] 40 HQ00 DONE_YN = Y · [L1]
-- 실행문 = JOB 실행문 그대로(사내 ZIOUI1 2026-11-25 17:13:43 조회)
-- ==============================================================================================================
DECLARE
  V_P_LOG_MESSGE VARCHAR2(4000);
BEGIN
  /* step 2 : PR_SSP_ANL_SHIP_PLAN_40_BALANCE (성공 시 다음 단계 / 실패 시 작업 종료(실패)) */
  PR_SSP_ANL_SHIP_PLAN_40_BALANCE;
  /* step 3 : PR_SSP_ANL_SHIP_CONFIRM_BATCH_40 (성공 시 다음 단계 / 실패 시 작업 종료(실패)) */
  PR_SSP_ANL_SHIP_CONFIRM_BATCH_40(P_DIVISION_ID => '40'
                                    , P_COMPANY_ID  => 'HQ00');
  /* step 4 : PR_SSP_ANL_SHIP_PLAN_40 (성공 시 다음 단계 / 실패 시 작업 종료(실패)) */
  PR_SSP_ANL_SHIP_PLAN_40(P_DIVISION_ID => '40'
                           , P_COMPANY_ID  => 'HQ00');
  /* step 5 : PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40 (성공 시 작업 종료(성공) / 실패 시 작업 종료(실패)) */
  PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40(P_COMPANY_ID1 => 'HQ00'
                                         , P_LOG_MESSGE  => V_P_LOG_MESSGE);
END;

/


-- ==============================================================================================================
-- [R2] 40(Mobility&IT) 법인 AZ00 일마감
-- JOB : JOB_PR_SSP_PLN_SHIP_PLAN_40_AZ(운영 매일 10:30 · 마감 기준 10:40)
-- 실행 전 확인 : [C0] 40 AZ00 · [VQ-37] · 실행 뒤 확인 : [C0] 40 AZ00 DONE_YN = Y · [L1]
-- 실행문 = JOB 실행문 그대로(사내 ZIOUI1 2026-11-25 17:13:43 조회)
-- ==============================================================================================================
DECLARE
  V_P_LOG_MESSGE VARCHAR2(4000);
BEGIN
  /* step 2 : PR_SSP_ANL_SHIP_CONFIRM_BATCH_40 (성공 시 다음 단계 / 실패 시 작업 종료(실패)) */
  PR_SSP_ANL_SHIP_CONFIRM_BATCH_40(P_DIVISION_ID => '40'
                                    , P_COMPANY_ID  => 'AZ00');
  /* step 3 : PR_SSP_ANL_SHIP_PLAN_40 (성공 시 다음 단계 / 실패 시 작업 종료(실패)) */
  PR_SSP_ANL_SHIP_PLAN_40(P_DIVISION_ID => '40'
                           , P_COMPANY_ID  => 'AZ00');
  /* step 4 : PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40 (성공 시 작업 종료(성공) / 실패 시 작업 종료(실패)) */
  PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40(P_COMPANY_ID1 => 'AZ00'
                                         , P_LOG_MESSGE  => V_P_LOG_MESSGE);
END;

/


-- ==============================================================================================================
-- [R3] 40(Mobility&IT) 법인 NJ00 일마감
-- JOB : JOB_PR_SSP_PLN_SHIP_PLAN_40_C(운영 매일 11:00 · 마감 기준 11:10)
-- 실행 전 확인 : [C0] 40 NJ00 · [VQ-37] · 실행 뒤 확인 : [C0] 40 NJ00 DONE_YN = Y · [L1]
-- 실행문 = JOB 실행문 그대로(사내 ZIOUI1 2026-11-25 17:13:43 조회)
-- ==============================================================================================================
DECLARE
  V_P_LOG_MESSGE VARCHAR2(4000);
BEGIN
  /* step 2 : PR_SSP_ANL_SHIP_CONFIRM_BATCH_40 (성공 시 다음 단계 / 실패 시 작업 종료(실패)) */
  PR_SSP_ANL_SHIP_CONFIRM_BATCH_40(P_DIVISION_ID => '40'
                                    , P_COMPANY_ID  => 'NJ00');
  /* step 3 : PR_SSP_ANL_SHIP_PLAN_40 (성공 시 다음 단계 / 실패 시 작업 종료(실패)) */
  PR_SSP_ANL_SHIP_PLAN_40(P_DIVISION_ID => '40'
                           , P_COMPANY_ID  => 'NJ00');
  /* step 4 : PR_SSP_ANL_INVENTORY_RAW (성공 시 다음 단계 / 실패 시 작업 종료(실패)) */
  PR_SSP_ANL_INVENTORY_RAW(P_DIVISION_ID => '40');
  /* step 5 : PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40 (성공 시 작업 종료(성공) / 실패 시 작업 종료(실패)) */
  PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40(P_COMPANY_ID1 => 'NJ00'
                                         , P_LOG_MESSGE  => V_P_LOG_MESSGE);
END;

/


-- ==============================================================================================================
-- [R4] 81·82(Auto&ESS) 법인별 일마감(CUTOFF)
-- JOB : JOB_PR_SSP_PLN_SHIP_PLAN_81_82(운영 05:07 ~ 23:57 10분마다 · 법인별 마감 기준 [C0])
-- 실행 전 확인 : [C0] 81·82 · [VQ-38] · 실행 뒤 확인 : [C0] 81·82 DONE_YN = Y · [VQ-54] · [L1]
-- 실행문 = JOB 실행문 그대로(사내 ZIOUI1 2026-11-25 17:13:43 조회)
-- ==============================================================================================================
BEGIN
  /* step 2 : PR_SSP_PLN_SHIP_PLAN_CUTOFF (성공 시 작업 종료(성공) / 실패 시 작업 종료(실패)) */
  PR_SSP_PLN_SHIP_PLAN_CUTOFF;
END;

/


-- ==============================================================================================================
-- [R5] 전극(Electrode) 법인별 일마감
-- JOB : JOB_PR_SSP_PLN_SHIP_PLAN_EE(운영 10분마다 · 법인별 마감 기준 [C0])
-- 실행 전 확인 : [C0] 전극 · [VQ-40] · 실행 뒤 확인 : [C0] 전극 DONE_YN = Y · [VQ-54] · [L1]
-- 실행문 = JOB 실행문 그대로(사내 ZIOUI1 2026-11-25 17:13:43 조회)
-- ==============================================================================================================
BEGIN
  /* step 2 : PR_SSP_ANL_SHIP_PLAN_EE (성공 시 작업 종료(성공) / 실패 시 작업 종료(실패)) */
  PR_SSP_ANL_SHIP_PLAN_EE;
END;

/


-- ==============================================================================================================
-- [R6] Packer 일 산출
-- JOB : JOB_PR_SSP_PLN_SHIP_PLAN_P(운영 매일 07:15(마감 지연 문자 대상 아님))
-- 실행 전 확인 : [VQ-39] · 실행 뒤 확인 : [L1]
-- 실행문 = JOB 실행문 그대로(사내 ZIOUI1 2026-11-25 17:13:43 조회)
-- ==============================================================================================================
BEGIN
  /* step 2 : PR_SSP_ANL_SHIP_PLAN_P (성공 시 다음 단계 / 실패 시 작업 종료(실패)) */
  PR_SSP_ANL_SHIP_PLAN_P;
  /* step 3 : PR_SSP_ANL_SHIP_CONFIRM_P (성공 시 작업 종료(성공) / 실패 시 작업 종료(실패)) */
  PR_SSP_ANL_SHIP_CONFIRM_P;
END;

/


-- ==============================================================================================================
-- [R7] 사업부별 출하계획 · 확정 통합 스냅샷
-- JOB : JOB_PR_SSP_ANL_SHIP_PLAN_ALL(운영 30분마다)
-- 실행 전 확인 : R1 ~ R6 끝난 뒤 · 실행 뒤 확인 : [L1]
-- 실행문 = JOB 실행문 그대로(사내 ZIOUI1 2026-11-25 17:13:43 조회)
-- ==============================================================================================================
BEGIN
  /* step 2 : PR_SSP_ANL_SHIP_PLAN_ALL (성공 시 작업 종료(성공) / 실패 시 작업 종료(실패)) */
  PR_SSP_ANL_SHIP_PLAN_ALL(P_PLAN_START_YYYYMMDD => NULL);
END;

/


-- ==============================================================================================================
-- 3부 실행 뒤 확인 : [C0] [C1] [VQ-54] [VQ-57] 다시 실행 + 아래 [L1]
-- ==============================================================================================================


-- ==============================================================================================================
-- [L1] 실행일 일마감 프로그램 로그
-- 확인 : 프로그램마다 START 뒤 END. ERROR 면 LOG_MESSAGE · SQL_ERR_MSG 회신
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
   AND L.PROGRAM_NAME IN ('PR_SSP_ANL_SHIP_PLAN_40_BALANCE',
                          'PR_SSP_ANL_SHIP_CONFIRM_BATCH_40',
                          'PR_SSP_ANL_SHIP_PLAN_40',
                          'PR_SSP_ANL_INVENTORY_RAW',
                          'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40',
                          'PR_SSP_PLN_SHIP_PLAN_CUTOFF',
                          'PR_SSP_ANL_SHIP_PLAN_CUTOFF',
                          'PR_SSP_ANL_SHIP_PLAN_CUTOFF_FP_AUTO',
                          'PR_SSP_ANL_SHIP_CONFIRM_BATCH_N',
                          'PR_SSP_ANL_SHIP_CONFIRM_BATCH_N_FP_AUTO',
                          'PR_SSP_ANL_SHIP_PLAN_EE',
                          'PR_SSP_ANL_SHIP_PLAN_P',
                          'PR_SSP_ANL_SHIP_CONFIRM_P',
                          'PR_SSP_ANL_SHIP_PLAN_ALL',
                          'PR_SSP_DAILY_PLAN_CUTOFF_CHECK_SMS_SEND')
 ORDER BY L.EVENT_DATE DESC;
