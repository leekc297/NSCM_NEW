--------------------------------------------------------------------------------
-- DMF0021 TO-BE 검증 쿼리 — 동일 ITEM 의 MKT_FCST 원천 존재 여부 (AS-IS 대조쌍)
--------------------------------------------------------------------------------
-- 실행 대상 : **클라우드 TO-BE DB (Oracle, OCGSCMQ_P01)** — 계정 SCM_MGR
-- 짝 문서   : `DMF0021_ASIS_MKT_FCST_VERIFY.sql` (AS-IS / MS-SQL 판)
--             ⇒ 두 결과를 같은 절 번호끼리 나란히 놓고 비교할 것.
--
-- 배경 (사용자 실측 2026-09-02)
--   AS-IS QA : 이 ITEM 의 **2027-01·02 MKT_FCST 데이터 없음** → MKT FCST[R+P] 미생성 (정상)
--   TO-BE    : MKT FCST[R+P] 가 2027-01=1,069,000 / 2027-02=748,000 로 **존재**
--   ⇒ 확인할 것 = "TO-BE 원천에는 그 데이터가 있는가, 있다면 어디서 온 것인가"
--
-- ⭐ 왜 MKT_FCST 를 보는가 (PKG_DMF0021 실측 L572~605 — AS-IS L1071~1137 과 1:1 동일)
--   MKT_FCST_RP 는 원천 메저가 아니라 **두 조각의 합성**이다:
--     · 과거구간 : GT_DMF0021_RAW_DATA 의 MEASURE='RTF_SYS_RP' (YYYYMMDD <  경계)
--     · 미래구간 : GT_DMF0021_RAW_DATA 의 MEASURE='MKT_FCST'   (YYYYMMDD >= 경계, <= p_to)
--   문제 값이 2027-01·02(미래)에만 있으므로 → **미래구간 = MKT_FCST 조각**이다.
--
-- ⚠ 주의
--   · §1~§6 은 원천/메타 조회라 세션 무관. **§7 만** SP 실행 후 같은 세션에서 GTT 를 읽는다.
--   · SELECT 전용 + 조회 SP 호출뿐 — 원장 변경 없음.
--   · FCST_TYPE 원천값은 코드(`MPS` 등)다. 화면/엑셀 표기(`Mass`)와 다르니 코드로 비교할 것.
--------------------------------------------------------------------------------

SET LINESIZE 300
SET PAGESIZE 200
SET SERVEROUTPUT OFF
COLUMN MEASURE           FORMAT A22
COLUMN SCM_SITE_ID       FORMAT A28
COLUMN ITEM_ID           FORMAT A22
COLUMN FCST_TYPE         FORMAT A12
COLUMN CELL_PROD_SITE_ID FORMAT A12
COLUMN PROJECT_CODE      FORMAT A16
COLUMN PLANT_SITE_ID     FORMAT A12
COLUMN DIVISION_ID       FORMAT A10
COLUMN 구간판정          FORMAT A34
COLUMN 판정              FORMAT A26
COLUMN COLUMN_NAME       FORMAT A26

------------------------------ 조회조건 (화면과 동일하게) ------------------------------
DEFINE P_DIV    = '40'
DEFINE P_FROM   = '20260817'
DEFINE P_NOW    = '20260901'
DEFINE P_TO     = '20270228'
DEFINE P_USER   = 'jaeuk.shin'
------------------------------ 추적 대상 키 ------------------------------
DEFINE K_ITEM   = 'MCSS56831-A1'
DEFINE K_SITE   = 'BYD Electronics_CN_SZX'


PROMPT ===== §0 환경 지문 =====
SELECT SYS_CONTEXT('USERENV','DB_NAME') AS DB_NAME,
       SYS_CONTEXT('USERENV','SERVER_HOST') AS SERVER_HOST, USER AS CONNECTED_AS
  FROM DUAL;
-- 판정: DB_NAME 이 클라우드(OCGSCMQ_P01)인지 확인. 사내(OCGSCMD_P01)면 대조 의미 없음.


PROMPT ===== §1 titleset — MKT_FCST 가 조회 대상에 들어가는가 =====
-- MKT_FCST_RP 를 고르면 SP 가 MKT_FCST·RTF_SYS_RP 를 SYSTEM_ADD='Y' 로 자동 추가한다(L432~441).
SELECT COLUMN_NAME, SORT_ORDER_NO
  FROM SCM_MGR.SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID = 'DMF0021'
   AND USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
   AND USER_ID = '&P_USER'
 ORDER BY SORT_ORDER_NO;


PROMPT ===== §2 메저 마스터 =====
SELECT COLUMN_NAME, DIVISION_ID, VALID_YN, DEFAULT_FLAG, SORT_ORDER_NO
  FROM SCM_MGR.SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID = 'DMF0021'
   AND COLUMN_NAME IN ('MKT_FCST','MKT_FCST_RP','RTF_SYS_RP')
 ORDER BY SORT_ORDER_NO;


PROMPT ===== §3 ⭐ 원천 DM_PLN_SALES_PLAN — 이 ITEM 의 MKT_FCST 존재 여부 (필터 전) =====
-- ⭐ AS-IS 판 §3 과 **정확히 같은 축**. 두 결과를 나란히 비교할 것.
SELECT A.MEASURE, A.YYYYMMDD, A.QTY, A.CURRENCY, A.FCST_TYPE, A.INCOTERMS,
       A.SCM_SITE_ID, A.PROJECT_CODE, A.PLANT_SITE_ID,
       NVL(A.CELL_PROD_SITE_ID,'-') AS CELL_PROD_SITE_ID, A.DOM_EXP
  FROM SCM_MGR.DM_PLN_SALES_PLAN A
 WHERE A.DIVISION_ID = '&P_DIV'
   AND A.ITEM_ID     = '&K_ITEM'
   AND A.SCM_SITE_ID = '&K_SITE'
   AND A.YYYYMMDD BETWEEN '&P_FROM' AND '&P_TO'
   AND A.MEASURE IN ('MKT_FCST','MKT_FCST_RP','RTF_SYS_RP')
 ORDER BY A.MEASURE, A.YYYYMMDD;
-- 판정:
--   · MKT_FCST 2027-01·02 행이 **있으면** → AS-IS QA 에는 없는 데이터가 TO-BE 에 있는 것
--     = **원천 데이터 차이**(적재/이관 경로 문제). SP 로직 문제가 아니다.
--   · **없으면** → 원천이 아니라 다른 경로(§4 ETC / §5 RESULT)에서 온 것이다.


PROMPT ===== §3-1 기간 경계 판정 =====
SELECT A.MEASURE, A.YYYYMMDD, A.QTY,
       CASE WHEN A.YYYYMMDD >= '&P_NOW' AND A.YYYYMMDD <= '&P_TO'
            THEN 'IN  (미래구간 = MKT_FCST_RP 재료)'
            WHEN A.YYYYMMDD >= '&P_FROM' AND A.YYYYMMDD < '&P_NOW'
            THEN 'PAST(과거구간)'
            ELSE 'OUT (조회기간 밖)' END AS 구간판정
  FROM SCM_MGR.DM_PLN_SALES_PLAN A
 WHERE A.DIVISION_ID = '&P_DIV'
   AND A.ITEM_ID     = '&K_ITEM'
   AND A.SCM_SITE_ID = '&K_SITE'
   AND A.MEASURE     = 'MKT_FCST'
 ORDER BY A.YYYYMMDD;


PROMPT ===== §4 다른 원천 1 — DM_PLN_SALES_ETC_PLAN (UNION ALL 두 번째 arm, L522~) =====
SELECT A.MEASURE, A.YYYYMMDD, A.QTY, A.CURRENCY, A.FCST_TYPE, A.SCM_SITE_ID, A.PROJECT_CODE
  FROM SCM_MGR.DM_PLN_SALES_ETC_PLAN A
 WHERE A.DIVISION_ID = '&P_DIV'
   AND A.ITEM_ID     = '&K_ITEM'
   AND A.YYYYMMDD BETWEEN '&P_FROM' AND '&P_TO'
   AND A.MEASURE IN ('MKT_FCST','MKT_FCST_RP','RTF_SYS_RP')
 ORDER BY A.MEASURE, A.YYYYMMDD;
-- 판정: ETC 는 SCM_SITE_ID 조인 없이 들어오는 경로다. 여기 MKT_FCST 가 있으면 이쪽이 출처.


PROMPT ===== §5 다른 원천 2 — DM_PLN_SALES_PLAN_RESULT (과거 실적 arm, L555~) =====
SELECT A.MEASURE, A.YYYYMMDD, A.QTY, A.SCM_SITE_ID, A.PROJECT_CODE
  FROM SCM_MGR.DM_PLN_SALES_PLAN_RESULT A
 WHERE A.DIVISION_ID = '&P_DIV'
   AND A.ITEM_ID     = '&K_ITEM'
   AND A.YYYYMMDD BETWEEN '&P_FROM' AND '&P_TO'
   AND A.MEASURE IN ('MKT_FCST','RTF_SYS_RP')
 ORDER BY A.MEASURE, A.YYYYMMDD;


PROMPT ===== §6 필터 통과 재현 (AS-IS 판 §8 과 동일 축) =====
SELECT A.MEASURE, A.YYYYMMDD, A.QTY, A.CURRENCY, A.FCST_TYPE,
       NVL(A.CELL_PROD_SITE_ID,'-') AS CELL_PROD_SITE_ID
  FROM SCM_MGR.DM_PLN_SALES_PLAN A
  JOIN SCM_MGR.SCM_MST_SITE C
    ON A.DIVISION_ID = C.DIVISION_ID
   AND A.SCM_SITE_ID = C.SCM_SITE_ID
   AND C.VALID_YN    = 'Y'
 WHERE A.YYYYMMDD >= '&P_NOW' AND A.YYYYMMDD <= '&P_TO'
   AND A.DIVISION_ID = '&P_DIV'
   AND A.MEASURE     = 'MKT_FCST'
   AND A.ITEM_ID     = '&K_ITEM'
   AND A.SCM_SITE_ID = '&K_SITE'
   AND A.QTY <> 0
   AND A.FCST_TYPE NOT IN ( SELECT DISTINCT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                             WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                               AND VALID_YN = 'Y' AND SEGMENT1 = A.DIVISION_ID )
   AND A.ITEM_ID   NOT IN ( SELECT DISTINCT SEGMENT3 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                             WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                               AND VALID_YN = 'Y' AND SEGMENT1 = A.DIVISION_ID )
   AND A.MEASURE   NOT IN ( SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                             WHERE LOOKUP_TYPE = 'SALES_PLAN_CATCHUP' AND VALID_YN = 'Y' )
 ORDER BY A.YYYYMMDD;
-- 판정: 여기 행이 있으면 TO-BE 는 MKT_FCST_RP 미래구간을 만든다 = 화면 결과와 일치.


PROMPT ===== §7 SP 실행 후 실제 산출 확인 (같은 세션 연속 실행 필수) =====
-- GTT(SYS$SESSION)라 아래 블록과 그 다음 SELECT 를 반드시 같은 세션에서 연속 실행할 것.
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
  CLOSE v1; CLOSE v2; CLOSE v3;
END;
/

-- 이 ITEM 이 최종 RAW 에 어떤 메저로 남았는가
SELECT MEASURE, COUNT(*) AS CNT, MIN(YYYYMMDD) AS MIN_YMD, MAX(YYYYMMDD) AS MAX_YMD,
       SUM(CASE WHEN QTY <> 0 THEN 1 ELSE 0 END) AS QTY_NOT_ZERO
  FROM SCM_MGR.GT_DMF0021_RAW_DATA
 WHERE ITEM_ID = '&K_ITEM' AND SCM_SITE_ID = '&K_SITE'
 GROUP BY MEASURE
 ORDER BY MEASURE;

-- MKT_FCST_RP 상세 (2027-01·02 가 실제로 만들어졌는지)
SELECT MEASURE, YYYYMMDD, QTY, PLAN_RESULT, VERSION_NO,
       NVL(CELL_PROD_SITE_ID,'-') AS CELL_PROD_SITE_ID
  FROM SCM_MGR.GT_DMF0021_RAW_DATA
 WHERE ITEM_ID = '&K_ITEM' AND SCM_SITE_ID = '&K_SITE'
   AND MEASURE IN ('MKT_FCST','MKT_FCST_RP')
 ORDER BY MEASURE, YYYYMMDD;

PROMPT ===== 끝 =====
