--------------------------------------------------------------------------------
-- DMF0021 : Sales Amt.(KRW) 원천 확인 검증 쿼리  (TO-BE / Oracle / SCM_MGR)
--------------------------------------------------------------------------------
-- 배경
--   DMF0021_40_20260902_DIFF.csv 3번째 행
--     Div 40 / Sales Site=Akasol Inc_US_HZP / Model=MCCM348018A3-000
--     Incoterms=DAP / FCST Type=Mass(=MPS) / Currency=USD / End Customer(PROJECT_CODE)=Akasol
--     Cell Prod Site=오창A(=HQ06-A) / Measure=Sales Amt.(KRW) / 2027-01 = 1,025,893,440
--   → TO-BE 에만 값이 있고 AS-IS 에는 해당 메저 행 자체가 없음.
--
-- 코드 대조 결론 (원문 실측 완료)
--   1) Sales Amt.(KRW) 의 MEASURE 코드 = 'SalesAmt_KRW'
--      (SCM_MST_SHEET_MEASURE / PROGRAM_ID='DMF0021' / SHEET_NAME='Sales Plan')
--   2) 조회 SP 는 이 메저를 **계산하지 않는다**. 유일한 공급원은
--        DM_PLN_SALES_PLAN  (MEASURE='SalesAmt_KRW')
--      TO-BE PKG_DMF0021 L485~517  ==  AS-IS DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx L919~991
--      (두 적재 arm 은 조건까지 1:1 동일)
--   3) 그 원천 행을 만드는 주체는 **저장(SAVE) 및 배치**이며 양쪽 모두 동일 구조:
--        TO-BE PKG_DMF0021 SAVE  L3110~3130 (SalesAmt_LOC x 환율)
--                                L3281~3308 (RTF 수량 x 단가)
--                                L3376      INSERT INTO DM_PLN_SALES_PLAN
--        AS-IS DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL L1610 / L1970 → L2148 INSERT INTO DM_PLN_SALES_PLAN
--   ⇒ 조회 로직 차이가 아니라 **원천 테이블에 행이 있느냐 없느냐**의 문제.
--      본 쿼리는 그 행의 실재 여부와 "누가/언제 만들었는지"를 확정한다.
--
-- 실행 : SQLcl / DBeaver. §6 은 같은 세션에서 연속 실행(GTT = SYS$SESSION).
--------------------------------------------------------------------------------
SET SERVEROUTPUT OFF
SET DEFINE ON
SET LINESIZE 300
SET PAGESIZE 200

DEFINE P_DIV     = '40'
DEFINE P_FROM    = '20260817'
DEFINE P_NOW     = '20260901'
DEFINE P_TO      = '20270228'
DEFINE P_USER    = 'jaeuk.shin'
DEFINE K_ITEM    = 'MCCM348018A3-000'
DEFINE K_SITE    = 'Akasol Inc_US_HZP'
DEFINE K_PROJ    = 'Akasol'
DEFINE K_CELL    = 'HQ06-A'
DEFINE K_MEAS    = 'SalesAmt_KRW'

COLUMN MEASURE          FORMAT A26
COLUMN COLUMN_NAME      FORMAT A24
COLUMN COLUMN_LABEL_NAME FORMAT A26
COLUMN DIVISION_ID      FORMAT A22
COLUMN PROJECT_CODE     FORMAT A18
COLUMN CREATED_BY       FORMAT A20
COLUMN LAST_UPDATED_BY  FORMAT A20
COLUMN SHEET_NAME       FORMAT A22

PROMPT ================ §0. 접속 환경 지문 ================
SELECT SYS_CONTEXT('USERENV','DB_NAME')     AS DB_NAME
     , SYS_CONTEXT('USERENV','SERVER_HOST') AS SRV
     , SYS_CONTEXT('USERENV','CURRENT_SCHEMA') AS CUR_SCHEMA
     , TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') AS NOW
  FROM DUAL;

PROMPT ================ §1. 메저 등록 — 'Sales Amt.(KRW)' 의 코드 확정 ================
-- 판정: DMF0021 시트는 'Sales Plan'. 코드는 SalesAmt_KRW 하나여야 한다.
SELECT SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, DIVISION_ID
     , DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, SORT_ORDER_NO
  FROM SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID = 'DMF0021'
   AND (UPPER(COLUMN_NAME) LIKE '%SALESAMT%' OR UPPER(COLUMN_NAME) IN ('KRW','LOC','USD'))
 ORDER BY SHEET_NAME, SORT_ORDER_NO, COLUMN_NAME;

PROMPT ================ §2. ⭐ 원천 실재 여부 — 해당 키의 SalesAmt_KRW ================
-- 판정: 행이 있으면 = 원천에 실재 → 조회 로직 문제 아님(원천/저장 이력 차이).
--       행이 없으면 = 다른 경로(§4/§5)에서 유입된 것.
SELECT PROJECT_CODE, MEASURE, YYYYMMDD, QTY, CURRENCY
     , CELL_PROD_SITE_ID, PLANT_SITE_ID, INCOTERMS, DOM_EXP, FCST_TYPE
     , CREATED_BY, TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS')    AS CREATED_DT
     , LAST_UPDATED_BY, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') AS UPD_DT
  FROM DM_PLN_SALES_PLAN
 WHERE DIVISION_ID = '&P_DIV'
   AND ITEM_ID     = '&K_ITEM'
   AND SCM_SITE_ID = '&K_SITE'
   AND MEASURE     = '&K_MEAS'
   AND YYYYMMDD BETWEEN '&P_FROM' AND '&P_TO'
 ORDER BY YYYYMMDD;

PROMPT ================ §2-1. ⭐ 생성 주체 판별 (핵심) ================
-- CREATED_BY 의미
--   SYSTEM / CUTOFF / SSP_SYNC / VMI_BATCH  = 배치 생성 (양쪽 환경 공통이어야 정상)
--   EXCHANGE_RATE_UI                        = 환율 화면 저장이 파생 생성
--   사람 ID (예: jaeuk.shin, minyonglee1)   = DMF0021 화면 저장이 파생 생성
--   E20260xxx-xxxxxx 형태                   = 테스트/이관 마커
-- 판정: CREATION_DATE 가 TO-BE 데이터 동기화 시점 **이후**이고 CREATED_BY 가
--       사람 ID / EXCHANGE_RATE_UI 이면 → **TO-BE 에서 저장이 수행되어 생긴 행**
--       (AS-IS 에는 없는 것이 당연. 데이터 동기화 누락이 아님)
SELECT CREATED_BY
     , COUNT(*)                                              AS CNT
     , TO_CHAR(MIN(CREATION_DATE),'YYYY-MM-DD HH24:MI:SS')   AS FIRST_DT
     , TO_CHAR(MAX(CREATION_DATE),'YYYY-MM-DD HH24:MI:SS')   AS LAST_DT
  FROM DM_PLN_SALES_PLAN
 WHERE DIVISION_ID = '&P_DIV'
   AND MEASURE     = '&K_MEAS'
   AND YYYYMMDD BETWEEN '&P_FROM' AND '&P_TO'
 GROUP BY CREATED_BY
 ORDER BY CNT DESC;

PROMPT ================ §3. 같은 키의 전체 메저 분포 (PROJECT_CODE 전환 확인) ================
-- 참고: 사내 실측에서는 이 키의 PROJECT_CODE 가 기간에 따라 Gillig(2026) → Akasol(2027) 로
--       전환되고, SalesAmt_KRW 는 RTF_SYS_RP>0 인 Gillig 구간에만 존재했다.
--       즉 SalesAmt 는 "실적이 찍힌 시점"에만 적재되는 파생 실적 메저다.
SELECT PROJECT_CODE, MEASURE, SUBSTR(YYYYMMDD,1,6) AS YM
     , COUNT(*) AS CNT, SUM(QTY) AS SUM_QTY
  FROM DM_PLN_SALES_PLAN
 WHERE DIVISION_ID = '&P_DIV'
   AND ITEM_ID     = '&K_ITEM'
   AND SCM_SITE_ID = '&K_SITE'
   AND YYYYMMDD BETWEEN '&P_FROM' AND '&P_TO'
 GROUP BY PROJECT_CODE, MEASURE, SUBSTR(YYYYMMDD,1,6)
 ORDER BY MEASURE, YM, PROJECT_CODE;

PROMPT ================ §4. 저장 이력 (SAVE 가 만든 것인지 직접 확인) ================
-- DM_PLN_SALES_PLAN_H 에 같은 키의 SalesAmt_KRW 이력이 있으면 = 화면 저장 경유 생성.
SELECT PROJECT_CODE, MEASURE, YYYYMMDD, QTY
     , CREATED_BY, TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') AS CREATED_DT
  FROM DM_PLN_SALES_PLAN_H
 WHERE DIVISION_ID = '&P_DIV'
   AND ITEM_ID     = '&K_ITEM'
   AND SCM_SITE_ID = '&K_SITE'
   AND MEASURE     = '&K_MEAS'
 ORDER BY CREATION_DATE DESC
 FETCH FIRST 50 ROWS ONLY;

PROMPT ================ §5. 파생 재료 확인 (단가 · 환율) ================
-- SAVE 파생식 : SalesAmt_KRW = RTF수량 x 단가(KRW)  또는  SalesAmt_LOC x 환율(→KRW)
--   단가 원천 : SCM_MST_FUTURE_PRICE / DM_PLN_CFM_SELLING_PRICE  (MEASURE='KRW')
--   환율 원천 : DM_MST_EXCHANGE_RATE  (UNIT_CURRENCY='USD', CURRENCY='KRW')
SELECT 'SCM_MST_FUTURE_PRICE' AS SRC, FP.MEASURE, FP.YYYYMMDD, FP.PRICE
  FROM SCM_MST_FUTURE_PRICE FP
 WHERE FP.DIVISION_ID = '&P_DIV' AND FP.ITEM_ID = '&K_ITEM'
   AND FP.SCM_SITE_ID = '&K_SITE' AND FP.PROJECT_CODE = '&K_PROJ'
   AND FP.MEASURE IN ('KRW','LOC','USD')
   AND FP.YYYYMMDD BETWEEN '&P_FROM' AND '&P_TO'
UNION ALL
SELECT 'DM_PLN_CFM_SELLING_PRICE', SP.MEASURE, SP.YYYYMMDD, SP.PRICE
  FROM DM_PLN_CFM_SELLING_PRICE SP
 WHERE SP.DIVISION_ID = '&P_DIV' AND SP.ITEM_ID = '&K_ITEM'
   AND SP.SCM_SITE_ID = '&K_SITE' AND SP.PROJECT_CODE = '&K_PROJ'
   AND SP.MEASURE IN ('KRW','LOC','USD')
   AND SP.YYYYMMDD BETWEEN '&P_FROM' AND '&P_TO'
 ORDER BY 1, 2, 3;

PROMPT ================ §5-1. 환율 ================
SELECT YYYYMMDD, UNIT_CURRENCY, CURRENCY, EXCHANGE_PRICE
  FROM DM_MST_EXCHANGE_RATE
 WHERE DIVISION_ID = '&P_DIV'
   AND UNIT_CURRENCY = 'USD' AND CURRENCY = 'KRW'
   AND YYYYMMDD BETWEEN '20260801' AND '20270301'
 ORDER BY YYYYMMDD;

PROMPT ================ §6. 조회 SP 실행 후 실제 산출 확인 (동일 세션) ================
-- ⚠ 무필터 센티널은 NULL. 'ALL' 을 주면 SP 내부 DELETE 분기가 켜져 전량 삭제된다.
DECLARE
    v1 SYS_REFCURSOR; v2 SYS_REFCURSOR; v3 SYS_REFCURSOR;
BEGIN
    SCM_MGR.PKG_DMF0021.P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX(
      p_division_id   => '&P_DIV'
    , p_dept_id       => NULL      -- ⚠ 무필터 센티널은 NULL. 'ALL' 을 주면 전량 삭제된다
    , p_end_customer  => NULL
    , p_scm_site_id   => NULL
    , p_project_code  => NULL
    , p_item_id       => NULL
    , p_item_type     => NULL
    , p_from_yyyymmdd => '&P_FROM'
    , p_now_yyyymmdd  => '&P_NOW'
    , p_to_yyyymmdd   => '&P_TO'
    , p_created_by    => '&P_USER'
    , p_plant_site_id => NULL
    , p_biztype       => NULL
    , p_owner         => NULL
    , p_internal_yn   => 'N'
    , p_userinfo      => NULL
    , p_bucket        => 'MONTHLY'
    , p_user_dept_id  => NULL
    , p_cur_result    => v1, p_cur_calendar => v2, p_cur_edit_auth => v3);
END;
/

-- ⚠ SQL*Plus/SQLcl 은 줄 끝의 '-' 를 **줄 연결 문자**로 해석한다.
--    PROMPT 를 '----' 로 끝내면 다음 줄의 SELECT 를 통째로 흡수해 "알 수 없는 명령" 이 난다.
--    (2026-09-02 실행에서 §6-1/§6-2 가 이 이유로 깨짐) → PROMPT 는 '=' 로 끝낼 것.
PROMPT ================ §6-1. GTT 안에서 해당 키의 SalesAmt_KRW 가 실제 산출되었는지 ================
SELECT MEASURE, PROJECT_CODE, SUBSTR(YYYYMMDD,1,6) AS YM, COUNT(*) AS CNT, SUM(QTY) AS SUM_QTY
  FROM GT_DMF0021_RAW_DATA
 WHERE DIVISION_ID = '&P_DIV'
   AND ITEM_ID     = '&K_ITEM'
   AND SCM_SITE_ID = '&K_SITE'
 GROUP BY MEASURE, PROJECT_CODE, SUBSTR(YYYYMMDD,1,6)
 ORDER BY MEASURE, YM, PROJECT_CODE;

PROMPT ================ §6-2. 조회에 실제 반영된 메저 목록 (SYSTEM_ADD 포함) ================
SELECT MEASURE, SYSTEM_ADD FROM GT_DMF0021_SELECT_MEASURE ORDER BY SYSTEM_ADD, MEASURE;

PROMPT ================ §7. 초과 3종 세트가 같은 이벤트 산물인지 ================
-- 2026-09-02 클라우드 실측: SalesAmt_KRW 는 CREATED_BY='EXCHANGE_RATE' 로
-- 2026-08-31 10:57:28 단일 시각에 2,224건 일괄 생성됨(§2-1).
-- 초과 78행의 22개 그룹은 RTF_PR + SalesAmt_KRW + SalesAmt_LOC 3종 세트였으므로
-- RTF_PR 도 같은 이벤트 산물인지 확인한다.
SELECT MEASURE, CREATED_BY
     , COUNT(*)                                            AS CNT
     , TO_CHAR(MIN(CREATION_DATE),'YYYY-MM-DD HH24:MI:SS') AS FIRST_DT
     , TO_CHAR(MAX(CREATION_DATE),'YYYY-MM-DD HH24:MI:SS') AS LAST_DT
  FROM DM_PLN_SALES_PLAN
 WHERE DIVISION_ID = '&P_DIV'
   AND ITEM_ID     = '&K_ITEM'
   AND SCM_SITE_ID = '&K_SITE'
   AND MEASURE IN ('RTF_PR','RTF_SYS_RP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD')
   AND YYYYMMDD BETWEEN '&P_FROM' AND '&P_TO'
 GROUP BY MEASURE, CREATED_BY
 ORDER BY MEASURE, CNT DESC;

PROMPT ================ §8. 2026-08-31 일괄 이벤트의 영향 범위 ================
-- 판정: 이 이벤트가 만든 행이 초과분과 같은 규모/메저 구성이면
--       "동기화 이후 TO-BE 에서만 돈 일괄 재생성" 이 건수차의 원인으로 확정된다.
SELECT MEASURE, CREATED_BY
     , TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') AS CREATED_DT
     , COUNT(*)                        AS CNT
     , COUNT(DISTINCT ITEM_ID)         AS ITEMS
     , COUNT(DISTINCT SCM_SITE_ID)     AS SITES
  FROM DM_PLN_SALES_PLAN
 WHERE DIVISION_ID = '&P_DIV'
   AND CREATION_DATE >= TO_DATE('2026-08-31','YYYY-MM-DD')
   AND YYYYMMDD BETWEEN '&P_FROM' AND '&P_TO'
 GROUP BY MEASURE, CREATED_BY, TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS')
 ORDER BY CNT DESC
 FETCH FIRST 30 ROWS ONLY;

PROMPT ================ 끝 ================
