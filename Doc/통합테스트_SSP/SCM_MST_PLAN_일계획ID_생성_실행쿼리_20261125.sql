-- ==============================================================================================================
-- 일 계획 ID(SCM_MST_PLAN, DAILY) 생성 실행 쿼리 · Oracle · 클라우드 · 20261122 ~ 20261125 4일치
-- 근거 : 점검 결과(2026-11-25 10:44 회신) — 일 계획 ID 마지막 = 20261121(ID 147006, 11개 사업부) · 주 계획 ID 20261123 = 1471 있음 · 중복 0행 · DB 오늘 = 20261125(WED) · 이번 주 월요일 = 20261123
-- 실행 : SQL Developer · SQLcl · SQL*Plus 에서 파일 전체 실행(F5) 가능. [E1] 확인 → [E2] 생성 → [E3] · [E4] 확인 순서로 한 번에 실행됨
--        DBeaver 에서는 문장 하나씩(커서를 문장 안에 두고 Ctrl+Enter). [E2] 블록 아래 / 줄은 실행하지 않음
-- 2026-11-25 수정 : [E2] 블록 끝에 / 줄 추가(없어서 스크립트 실행 때 PLS-00103 발생. 그때 생성된 행은 없음)
-- 실행 기한 : 2026-11-25 ~ 2026-11-29(이번 주) 안에 실행. 프로그램이 「실행하는 날이 속한 주의 월요일」만 월요일 방식으로 만들기 때문에, 다음 주에 실행하면 20261123 의 ID 가 어긋남
-- 주의 : [E2] 는 변경 문장. 프로그램(PR_SCM_MST_PLAN) 안에서 COMMIT 함
-- 만들어질 값(프로그램 규칙으로 계산한 예상) :
--   20261122(SUN) 전일 20261121 행 복사      → PLAN_ID 147007 · HORIZON 20261121 ~ 20270313
--   20261123(MON) 전주 월요일 20261116 행 복사 → PLAN_ID 147101(전주 WEEKLY 1470 + 1, 뒤에 01) · HORIZON 20261122 ~ 20270314
--   20261124(TUE) 전일 20261123 행 복사      → PLAN_ID 147102 · HORIZON 20261123 ~ 20270315
--   20261125(WED) 전일 20261124 행 복사      → PLAN_ID 147103 · HORIZON 20261124 ~ 20270316
--   대상 사업부 11개 : 40, 81, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HM, EE_ST, EE_UC
--   81_HD · EE_HD(마지막 20241201) · EE_HG(0건)은 복사할 전일 행이 없어 만들어지지 않음. 점검 결과에서 20261104 이후 계속 없던 사업부이고 40 산출과 무관
-- ==============================================================================================================

-- ==============================================================================================================
-- [E1] 실행 전 확인(조회 문장)
-- 확인 : TODAY 가 20261125 ~ 20261129, THIS_MONDAY = 20261123, LAST_DAILY_40 = 20261121, WEEKLY_1116 = 1470, DAILY_1116 = 147001
--        하나라도 다르면 [E2] 를 실행하지 말고 값을 회신
-- ==============================================================================================================
SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') AS TODAY
     , TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD') AS THIS_MONDAY
     , (SELECT MAX(M.PLAN_NAME)
          FROM SCM_MST_PLAN M
         WHERE M.DIVISION_ID = '40'
           AND M.PLAN_CYCLE = 'DAILY') AS LAST_DAILY_40
     , (SELECT MIN(M.PLAN_ID)
          FROM SCM_MST_PLAN M
         WHERE M.PLAN_CYCLE = 'WEEKLY'
           AND M.PLAN_NAME = '20261116') AS WEEKLY_1116
     , (SELECT MIN(M.PLAN_ID)
          FROM SCM_MST_PLAN M
         WHERE M.PLAN_CYCLE = 'DAILY'
           AND M.PLAN_NAME = '20261116') AS DAILY_1116
     , (SELECT COUNT(*)
          FROM SCM_MST_PLAN M
         WHERE M.PLAN_CYCLE = 'DAILY'
           AND M.PLAN_NAME BETWEEN '20261122' AND '20261125') AS ALREADY_CNT        /* 0 이어야 함 */
  FROM DUAL;

-- ==============================================================================================================
-- [E2] 일 계획 ID 생성(변경 문장) : 20261122 → 20261123 → 20261124 → 20261125 순서로 하루씩
-- 잡 : JOB_SCMPROD_PLAN_ID_DAILY_CREATION 이 매일 00:10 에 하루치씩 하던 일을 4일치 차례로 실행
-- 안전 장치 : 마지막 일자가 20261121 이 아니거나, 실행일이 20261125 ~ 20261129 밖이면 아무것도 만들지 않고 오류 문구로 끝남
--             → 두 번 실행해도 다시 만들어지지 않음
-- ==============================================================================================================
DECLARE
  V_LAST  VARCHAR2(8);
  V_TODAY VARCHAR2(8) := TO_CHAR(SYSDATE, 'YYYYMMDD');
BEGIN
  SELECT MAX(PLAN_NAME)
    INTO V_LAST
    FROM SCM_MST_PLAN
   WHERE DIVISION_ID = '40'
     AND PLAN_CYCLE = 'DAILY';
  IF V_LAST <> '20261121' THEN
    RAISE_APPLICATION_ERROR(-20001, 'STOP - LAST DAILY PLAN_NAME(40) IS ' || V_LAST || ', EXPECTED 20261121');
  END IF;
  IF V_TODAY < '20261125' OR V_TODAY > '20261129' THEN
    RAISE_APPLICATION_ERROR(-20002, 'STOP - TODAY IS ' || V_TODAY || ', RUN BETWEEN 20261125 AND 20261129');
  END IF;
  PR_SCM_MST_PLAN('DAILY', '20261122');
  PR_SCM_MST_PLAN('DAILY', '20261123');
  PR_SCM_MST_PLAN('DAILY', '20261124');
  PR_SCM_MST_PLAN('DAILY', '20261125');
END;

/

-- ==============================================================================================================
-- [E3] 생성 결과 확인(조회 문장)
-- 확인 : 4행. 일자마다 DIVISION_CNT = 11, MIN_PLAN_ID = MAX_PLAN_ID, 값이 맨 위 「만들어질 값」과 같음
--        20261122 = 147007 · 20261123 = 147101 · 20261124 = 147102 · 20261125 = 147103
--        4행이 안 되거나 값이 다르면 그 결과를 회신(임의로 지우지 말 것)
-- ==============================================================================================================
SELECT M.PLAN_NAME
     , TO_CHAR(TO_DATE(M.PLAN_NAME, 'YYYYMMDD'), 'DY', 'NLS_DATE_LANGUAGE=AMERICAN') AS DAY_NAME
     , COUNT(*) AS DIVISION_CNT
     , MIN(M.PLAN_ID) AS MIN_PLAN_ID
     , MAX(M.PLAN_ID) AS MAX_PLAN_ID
     , MIN(M.HORIZON_START_DATE) AS HORIZON_START
     , MAX(M.HORIZON_END_DATE) AS HORIZON_END
     , MAX(M.CREATION_DATE) AS CREATION_DATE
     , MAX(M.CREATED_BY) AS CREATED_BY
     , LISTAGG(M.DIVISION_ID, ', ') WITHIN GROUP (ORDER BY M.DIVISION_ID) AS DIVISIONS
  FROM SCM_MST_PLAN M
 WHERE M.PLAN_CYCLE = 'DAILY'
   AND M.PLAN_NAME BETWEEN '20261120' AND '20261125'
 GROUP BY M.PLAN_NAME
 ORDER BY M.PLAN_NAME;

-- ==============================================================================================================
-- [E4] 40 산출 진입 조건 다시 확인(조회 문장) : 통합테스트 검증쿼리 VQ-37 과 같은 쿼리
-- 확인 : DAILY_PLAN_CNT = 1. READY_YN 은 재고 수신 확인(STOCK_NOT_READY_CNT)까지 0 이어야 Y
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
