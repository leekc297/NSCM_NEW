-- ============================================================================
-- DMF0082 — 같은 업무키가 2줄로 갈리는 원인 지목 (v2 · 필터 없음)
--
-- v1 은 SCM_SITE/ITEM 을 리터럴로 걸어 0행이 나왔다. v2 는 **조회된 전체**에서
-- 갈리는 업무키를 스스로 찾아내므로 대상을 미리 몰라도 된다.
--
-- 최종 커서는 PIVOT 이라 SELECT 목록에 남은 모든 컬럼이 **그리드 행 그레인**이다.
--   그레인 = ① C_TITLE(계정별 컬럼 설정)  ② NOTATION  ③ SORT_ORDER_NO
--            ④ [E20260822-KEYCOL] 저장 키 12컬럼  ← TO-BE 전용 (AS-IS 부재)
--   ①②③ 때문에 갈리면 AS-IS 도 동일 → 현행 유지
--   ④ 에만 속한 컬럼 때문에 갈리면 AS-IS 에 없던 회귀 → 1행 병합 보완 대상
--
-- ⚠ §1~§5 를 **같은 커넥션·같은 세션**에서 순서대로. 전부 읽기 전용.
-- ⚠ §1 의 p_created_by 는 **화면에서 보던 그 계정 ID** 여야 한다 (C_TITLE 이 계정별).
-- ============================================================================

-- ----------------------------------------------------------------------------
-- §1. 화면과 동일 조건으로 조회 재현
--     ITEM 은 넉넉히 주거나 'ALL' 대신 결손이 보이는 Model 몇 개를 콤마로 나열한다.
-- ----------------------------------------------------------------------------
DECLARE
    R1 SYS_REFCURSOR; R2 SYS_REFCURSOR; R3 SYS_REFCURSOR;
    R4 SYS_REFCURSOR; R5 SYS_REFCURSOR; RR SYS_REFCURSOR;
BEGIN
    SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(
        p_division_id   => '40',
        p_team_id       => 'ALL',
        p_customer      => 'ALL',
        p_biz_type      => 'ALL',
        p_from_yyyymmdd => '20260101',          -- ← 화면 조회 From
        p_to_yyyymmdd   => '20271231',          -- ← 화면 조회 To
        p_scm_site_id   => 'ALL',
        p_item_id       => 'MCSS22531-B1',      -- ← 캡처의 Model (Foxlink_CN_DGG / 남경A)
        p_version_type  => 'Current',
        p_qty_yn        => 'Y',
        p_created_by    => 'minyonglee1',       -- ⚠ 반드시 화면에서 보던 계정 ID 로 교체
        p_user_group    => 'ADMIN',
        p_plant_site_id => 'ALL',
        p_project_code  => 'ALL',
        p_owner         => 'ALL',
        p_sender_code   => 'ALL',
        O_RC1 => R1, O_RC2 => R2, O_RC3 => R3, O_RC4 => R4, O_RC5 => R5,
        O_RESULT_CURSOR => RR);
END;
/

-- ----------------------------------------------------------------------------
-- §2. 적재 확인 — 여기가 0행이면 §1 의 조건이 틀린 것이다 (다음 단계 무의미)
-- ----------------------------------------------------------------------------
SELECT ITEM_ID, SCM_SITE_ID, MEASURE, COUNT(*) AS 행수,
       MIN(BUCKET_KEY) AS 시작, MAX(BUCKET_KEY) AS 종료
  FROM SCM_MGR.GT_DMF0082_MF_SP
 GROUP BY ITEM_ID, SCM_SITE_ID, MEASURE
 ORDER BY 1, 2, 3;


-- ----------------------------------------------------------------------------
-- §3. ⭐ 어느 컬럼이 행을 가르는가 — 조회된 전체 대상, 컬럼 54개 전수
-- ----------------------------------------------------------------------------
WITH G AS (
  SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE,
         COUNT(DISTINCT NVL(TO_CHAR(CELL_PROD_SITE_ID),'~')) AS K_CELL_PROD_SITE_ID,
         COUNT(DISTINCT NVL(TO_CHAR(CURRENCY),'~')) AS K_CURRENCY,
         COUNT(DISTINCT NVL(TO_CHAR(VERSION_NO),'~')) AS K_VERSION_NO,
         COUNT(DISTINCT NVL(TO_CHAR(CUTOFF_YYYYMMDD),'~')) AS K_CUTOFF_YYYYMMDD,
         COUNT(DISTINCT NVL(TO_CHAR(NOTATION),'~')) AS K_NOTATION,
         COUNT(DISTINCT NVL(TO_CHAR(SORT_ORDER_NO),'~')) AS K_SORT_ORDER_NO,
         COUNT(DISTINCT NVL(TO_CHAR(MEASURE_GROUP),'~')) AS K_MEASURE_GROUP,
         COUNT(DISTINCT NVL(TO_CHAR(EDIT_FLAG),'~')) AS K_EDIT_FLAG,
         COUNT(DISTINCT NVL(TO_CHAR(SORT_KEY),'~')) AS K_SORT_KEY,
         COUNT(DISTINCT NVL(TO_CHAR(GROUP_ID),'~')) AS K_GROUP_ID,
         COUNT(DISTINCT NVL(TO_CHAR(AS_FROM_SITE),'~')) AS K_AS_FROM_SITE,
         COUNT(DISTINCT NVL(TO_CHAR(AS_YN),'~')) AS K_AS_YN,
         COUNT(DISTINCT NVL(TO_CHAR(NEW_FLAG),'~')) AS K_NEW_FLAG,
         COUNT(DISTINCT NVL(TO_CHAR(ATTR1),'~')) AS K_ATTR1,
         COUNT(DISTINCT NVL(TO_CHAR(VMI_STD_DIO),'~')) AS K_VMI_STD_DIO,
         COUNT(DISTINCT NVL(TO_CHAR(SENDER_CODE),'~')) AS K_SENDER_CODE,
         COUNT(DISTINCT NVL(TO_CHAR(SENDER_NAME),'~')) AS K_SENDER_NAME,
         COUNT(DISTINCT NVL(TO_CHAR(NICK_NAME),'~')) AS K_NICK_NAME,
         COUNT(DISTINCT NVL(TO_CHAR(CELL_MODEL),'~')) AS K_CELL_MODEL,
         COUNT(DISTINCT NVL(TO_CHAR(CELL_MODEL_NICK_NAME),'~')) AS K_CELL_MODEL_NICK_NAME,
         COUNT(DISTINCT NVL(TO_CHAR(DMS_SALES),'~')) AS K_DMS_SALES,
         COUNT(DISTINCT NVL(TO_CHAR(DMS_CUSTOMER),'~')) AS K_DMS_CUSTOMER,
         COUNT(DISTINCT NVL(TO_CHAR(OWNER),'~')) AS K_OWNER,
         COUNT(DISTINCT NVL(TO_CHAR(DEPT_ID),'~')) AS K_DEPT_ID,
         COUNT(DISTINCT NVL(TO_CHAR(DEPT_NAME_KO),'~')) AS K_DEPT_NAME_KO,
         COUNT(DISTINCT NVL(TO_CHAR(ITEM_TYPE),'~')) AS K_ITEM_TYPE,
         COUNT(DISTINCT NVL(TO_CHAR(ITEM_NAME),'~')) AS K_ITEM_NAME,
         COUNT(DISTINCT NVL(TO_CHAR(PROJECT_NAME),'~')) AS K_PROJECT_NAME,
         COUNT(DISTINCT NVL(TO_CHAR(PROJECT_OWNER),'~')) AS K_PROJECT_OWNER,
         COUNT(DISTINCT NVL(TO_CHAR(PROJECT_STATUS),'~')) AS K_PROJECT_STATUS,
         COUNT(DISTINCT NVL(TO_CHAR(PROJECT_S_OP_REPORT),'~')) AS K_PROJECT_S_OP_REPORT,
         COUNT(DISTINCT NVL(TO_CHAR(BIZ_TYPE),'~')) AS K_BIZ_TYPE,
         COUNT(DISTINCT NVL(TO_CHAR(SOLDTO_CUSTOMER),'~')) AS K_SOLDTO_CUSTOMER,
         COUNT(DISTINCT NVL(TO_CHAR(COUNTRY_NAME),'~')) AS K_COUNTRY_NAME,
         COUNT(DISTINCT NVL(TO_CHAR(CITY_NAME),'~')) AS K_CITY_NAME,
         COUNT(DISTINCT NVL(TO_CHAR(VMI_YN),'~')) AS K_VMI_YN,
         COUNT(DISTINCT NVL(TO_CHAR(CUST_GROUP),'~')) AS K_CUST_GROUP,
         COUNT(DISTINCT NVL(TO_CHAR(CUST_GROUP_DTL),'~')) AS K_CUST_GROUP_DTL,
         COUNT(DISTINCT NVL(TO_CHAR(APPLICATION),'~')) AS K_APPLICATION,
         COUNT(DISTINCT NVL(TO_CHAR(ROUTE),'~')) AS K_ROUTE,
         COUNT(DISTINCT NVL(TO_CHAR(MDM_PROJECT_NAME),'~')) AS K_MDM_PROJECT_NAME,
         COUNT(DISTINCT NVL(TO_CHAR(MIN_CAPACITY),'~')) AS K_MIN_CAPACITY,
         COUNT(DISTINCT NVL(TO_CHAR(FORECAST_INFO_BIZ_TYPE),'~')) AS K_FORECAST_INFO_BIZ_TYPE,
         COUNT(DISTINCT NVL(TO_CHAR(CELL_TYPE),'~')) AS K_CELL_TYPE,
         COUNT(DISTINCT NVL(TO_CHAR(FORECAST_INFO_ALL),'~')) AS K_FORECAST_INFO_ALL,
         COUNT(DISTINCT NVL(TO_CHAR(FORECAST_INFO_SPEC),'~')) AS K_FORECAST_INFO_SPEC,
         COUNT(DISTINCT NVL(TO_CHAR(FORECAST_INFOR_VERSION),'~')) AS K_FORECAST_INFOR_VERSION,
         COUNT(DISTINCT NVL(TO_CHAR(FORECAST_INFO_CELL_PACK_COUNT),'~')) AS K_FORECAST_INFO_CELL_PACK_COUNT,
         COUNT(DISTINCT NVL(TO_CHAR(CELL_PER_CAR),'~')) AS K_CELL_PER_CAR,
         COUNT(DISTINCT NVL(TO_CHAR(CELL_PER_MODULE),'~')) AS K_CELL_PER_MODULE,
         COUNT(DISTINCT NVL(TO_CHAR(MODULE_PER_CAR),'~')) AS K_MODULE_PER_CAR,
         COUNT(DISTINCT NVL(TO_CHAR(ENERGE),'~')) AS K_ENERGE,
         COUNT(DISTINCT NVL(TO_CHAR(CELL_QUANTITY),'~')) AS K_CELL_QUANTITY,
         COUNT(DISTINCT NVL(TO_CHAR(LAST_UPDATED_BY),'~')) AS K_LAST_UPDATED_BY
    FROM SCM_MGR.GT_DMF0082_MF_SP
   GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE
)
SELECT * FROM (
  SELECT 'CELL_PROD_SITE_ID' AS 컬럼명, SUM(CASE WHEN K_CELL_PROD_SITE_ID > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'CURRENCY' AS 컬럼명, SUM(CASE WHEN K_CURRENCY > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'VERSION_NO' AS 컬럼명, SUM(CASE WHEN K_VERSION_NO > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'CUTOFF_YYYYMMDD' AS 컬럼명, SUM(CASE WHEN K_CUTOFF_YYYYMMDD > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'NOTATION' AS 컬럼명, SUM(CASE WHEN K_NOTATION > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'SORT_ORDER_NO' AS 컬럼명, SUM(CASE WHEN K_SORT_ORDER_NO > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'MEASURE_GROUP' AS 컬럼명, SUM(CASE WHEN K_MEASURE_GROUP > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'EDIT_FLAG' AS 컬럼명, SUM(CASE WHEN K_EDIT_FLAG > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'SORT_KEY' AS 컬럼명, SUM(CASE WHEN K_SORT_KEY > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'GROUP_ID' AS 컬럼명, SUM(CASE WHEN K_GROUP_ID > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'AS_FROM_SITE' AS 컬럼명, SUM(CASE WHEN K_AS_FROM_SITE > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'AS_YN' AS 컬럼명, SUM(CASE WHEN K_AS_YN > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'NEW_FLAG' AS 컬럼명, SUM(CASE WHEN K_NEW_FLAG > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'ATTR1' AS 컬럼명, SUM(CASE WHEN K_ATTR1 > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'VMI_STD_DIO' AS 컬럼명, SUM(CASE WHEN K_VMI_STD_DIO > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'SENDER_CODE' AS 컬럼명, SUM(CASE WHEN K_SENDER_CODE > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'SENDER_NAME' AS 컬럼명, SUM(CASE WHEN K_SENDER_NAME > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'NICK_NAME' AS 컬럼명, SUM(CASE WHEN K_NICK_NAME > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'CELL_MODEL' AS 컬럼명, SUM(CASE WHEN K_CELL_MODEL > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'CELL_MODEL_NICK_NAME' AS 컬럼명, SUM(CASE WHEN K_CELL_MODEL_NICK_NAME > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'DMS_SALES' AS 컬럼명, SUM(CASE WHEN K_DMS_SALES > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'DMS_CUSTOMER' AS 컬럼명, SUM(CASE WHEN K_DMS_CUSTOMER > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'OWNER' AS 컬럼명, SUM(CASE WHEN K_OWNER > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'DEPT_ID' AS 컬럼명, SUM(CASE WHEN K_DEPT_ID > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'DEPT_NAME_KO' AS 컬럼명, SUM(CASE WHEN K_DEPT_NAME_KO > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'ITEM_TYPE' AS 컬럼명, SUM(CASE WHEN K_ITEM_TYPE > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'ITEM_NAME' AS 컬럼명, SUM(CASE WHEN K_ITEM_NAME > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'PROJECT_NAME' AS 컬럼명, SUM(CASE WHEN K_PROJECT_NAME > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'PROJECT_OWNER' AS 컬럼명, SUM(CASE WHEN K_PROJECT_OWNER > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'PROJECT_STATUS' AS 컬럼명, SUM(CASE WHEN K_PROJECT_STATUS > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'PROJECT_S_OP_REPORT' AS 컬럼명, SUM(CASE WHEN K_PROJECT_S_OP_REPORT > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'BIZ_TYPE' AS 컬럼명, SUM(CASE WHEN K_BIZ_TYPE > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'SOLDTO_CUSTOMER' AS 컬럼명, SUM(CASE WHEN K_SOLDTO_CUSTOMER > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'COUNTRY_NAME' AS 컬럼명, SUM(CASE WHEN K_COUNTRY_NAME > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'CITY_NAME' AS 컬럼명, SUM(CASE WHEN K_CITY_NAME > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'VMI_YN' AS 컬럼명, SUM(CASE WHEN K_VMI_YN > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'CUST_GROUP' AS 컬럼명, SUM(CASE WHEN K_CUST_GROUP > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'CUST_GROUP_DTL' AS 컬럼명, SUM(CASE WHEN K_CUST_GROUP_DTL > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'APPLICATION' AS 컬럼명, SUM(CASE WHEN K_APPLICATION > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'ROUTE' AS 컬럼명, SUM(CASE WHEN K_ROUTE > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'MDM_PROJECT_NAME' AS 컬럼명, SUM(CASE WHEN K_MDM_PROJECT_NAME > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'MIN_CAPACITY' AS 컬럼명, SUM(CASE WHEN K_MIN_CAPACITY > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'FORECAST_INFO_BIZ_TYPE' AS 컬럼명, SUM(CASE WHEN K_FORECAST_INFO_BIZ_TYPE > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'CELL_TYPE' AS 컬럼명, SUM(CASE WHEN K_CELL_TYPE > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'FORECAST_INFO_ALL' AS 컬럼명, SUM(CASE WHEN K_FORECAST_INFO_ALL > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'FORECAST_INFO_SPEC' AS 컬럼명, SUM(CASE WHEN K_FORECAST_INFO_SPEC > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'FORECAST_INFOR_VERSION' AS 컬럼명, SUM(CASE WHEN K_FORECAST_INFOR_VERSION > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'FORECAST_INFO_CELL_PACK_COUNT' AS 컬럼명, SUM(CASE WHEN K_FORECAST_INFO_CELL_PACK_COUNT > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'CELL_PER_CAR' AS 컬럼명, SUM(CASE WHEN K_CELL_PER_CAR > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'CELL_PER_MODULE' AS 컬럼명, SUM(CASE WHEN K_CELL_PER_MODULE > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'MODULE_PER_CAR' AS 컬럼명, SUM(CASE WHEN K_MODULE_PER_CAR > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'ENERGE' AS 컬럼명, SUM(CASE WHEN K_ENERGE > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'CELL_QUANTITY' AS 컬럼명, SUM(CASE WHEN K_CELL_QUANTITY > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
UNION ALL
  SELECT 'LAST_UPDATED_BY' AS 컬럼명, SUM(CASE WHEN K_LAST_UPDATED_BY > 1 THEN 1 ELSE 0 END) AS 분리업무키수 FROM G
)
WHERE 분리업무키수 > 0
ORDER BY 2 DESC, 1;
-- 여기 나오는 컬럼이 범인이다. 0행이면 갈리는 업무키가 없다.
-- §5 의 목록과 대조해 ①C_TITLE 소속인지 ④KEYCOL 전용인지 판정한다.


-- ----------------------------------------------------------------------------
-- §4. 갈린 업무키 실제 목록 — 두 줄을 좌우로 비교
-- ----------------------------------------------------------------------------
SELECT ITEM_ID, SCM_SITE_ID, PROJECT_CODE, MEASURE, INCOTERMS, FCST_TYPE, DOM_EXP,
       PLANT_SITE_ID, CELL_PROD_SITE_ID, CURRENCY, VERSION_NO, NOTATION,
       SORT_ORDER_NO, EDIT_FLAG, SORT_KEY, GROUP_ID, AS_FROM_SITE, NICK_NAME,
       COUNT(*) AS 행수, MIN(BUCKET_KEY) AS 시작, MAX(BUCKET_KEY) AS 종료,
       SUM(QTY) AS 합계
  FROM SCM_MGR.GT_DMF0082_MF_SP
 WHERE (DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE) IN (
         SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE FROM (
           SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE, COUNT(*) AS C FROM (
             SELECT DISTINCT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE, CELL_PROD_SITE_ID, CURRENCY, VERSION_NO, NOTATION,
                    SORT_ORDER_NO, EDIT_FLAG, SORT_KEY, GROUP_ID, AS_FROM_SITE, NICK_NAME
               FROM SCM_MGR.GT_DMF0082_MF_SP)
           GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE)
         WHERE C > 1)
 GROUP BY ITEM_ID, SCM_SITE_ID, PROJECT_CODE, MEASURE, INCOTERMS, FCST_TYPE, DOM_EXP,
          PLANT_SITE_ID, CELL_PROD_SITE_ID, CURRENCY, VERSION_NO, NOTATION,
          SORT_ORDER_NO, EDIT_FLAG, SORT_KEY, GROUP_ID, AS_FROM_SITE, NICK_NAME
 ORDER BY ITEM_ID, SCM_SITE_ID, MEASURE, 시작;
-- 같은 ITEM/SITE/MEASURE 가 2줄로 나오면 그 두 줄에서 **다른 칸**이 원인이다.
-- '시작/종료' 로 실적 구간 줄과 계획 구간 줄이 구분된다.


-- ----------------------------------------------------------------------------
-- §5. 이 계정의 그레인 목록 — 화면에 안 보여도 그레인이면 행을 가른다
-- ----------------------------------------------------------------------------
SELECT '① C_TITLE(계정 컬럼설정)' AS 구분, U.COLUMN_NAME
  FROM SCM_MGR.SCM_MST_TITLESET_USER U, SCM_MGR.SCM_MST_SHEET_COLUMNS C
 WHERE U.PROGRAM_ID = C.PROGRAM_ID AND U.SHEET_NAME = C.SHEET_NAME
   AND U.COLUMN_NAME = C.COLUMN_NAME
   AND U.PROGRAM_ID = 'DMF0082' AND U.SHEET_NAME = 'FcstNPrice'
   AND U.USER_ID = 'minyonglee1'          -- ⚠ §1 과 같은 계정으로 교체
   AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
UNION ALL
SELECT '④ KEYCOL(TO-BE 전용)', COLUMN_VALUE
  FROM TABLE(SYS.ODCIVARCHAR2LIST(
       'DIVISION_ID','PROJECT_CODE','END_CUSTOMER','SCM_SITE_ID','ITEM_ID','DOM_EXP',
       'FCST_TYPE','INCOTERMS','MEASURE','PLANT_SITE_ID','CELL_PROD_SITE_ID','CURRENCY'))
UNION ALL
SELECT '②③ 고정', COLUMN_VALUE
  FROM TABLE(SYS.ODCIVARCHAR2LIST('NOTATION','SORT_ORDER_NO'))
 ORDER BY 1, 2;
-- §3 의 범인이 ① 에 있으면 AS-IS 도 갈린다 → 현행 유지
-- ④ 에만 있으면 AS-IS 에 없던 TO-BE 회귀 → 1행 병합 보완 대상

-- ----------------------------------------------------------------------------
-- §6. ⭐ 한 Cell Prod Site 안에서 실제 그리드 줄을 그대로 재현
--     §3/§4 는 업무키(=measure 포함) 안의 분리를 본다. 그런데 "남경A 하나에서 2줄"은
--     **서로 다른 MEASURE 가 한 블록에 겹쳐 보이는 것**일 수 있다
--     (화면에서 둘 중 한 줄의 Measure 라벨이 비어 있으면 그 경우다).
--     여기서는 PIVOT 그레인을 그대로 DISTINCT 해 **실제 줄 수와 각 줄의 MEASURE** 를 뽑는다.
-- ----------------------------------------------------------------------------
SELECT ROW_NUMBER() OVER (ORDER BY TO_NUMBER(SORT_ORDER_NO), MEASURE) AS 줄번호,
       MEASURE, SORT_ORDER_NO, MEASURE_GROUP, NOTATION,
       ITEM_ID, SCM_SITE_ID, PROJECT_CODE, END_CUSTOMER, NICK_NAME,
       INCOTERMS, FCST_TYPE, DOM_EXP, PLANT_SITE_ID, CELL_PROD_SITE_ID,
       CURRENCY, VERSION_NO, AS_FROM_SITE, EDIT_FLAG, SORT_KEY, GROUP_ID
  FROM ( SELECT DISTINCT MEASURE, SORT_ORDER_NO, MEASURE_GROUP, NOTATION,
                ITEM_ID, SCM_SITE_ID, PROJECT_CODE, END_CUSTOMER, NICK_NAME,
                INCOTERMS, FCST_TYPE, DOM_EXP, PLANT_SITE_ID, CELL_PROD_SITE_ID,
                CURRENCY, VERSION_NO, AS_FROM_SITE, EDIT_FLAG, SORT_KEY, GROUP_ID
           FROM SCM_MGR.GT_DMF0082_MF_SP
          WHERE ITEM_ID     = 'MCSS22531-B1'          -- ← 캡처의 Model
            AND SCM_SITE_ID = 'Foxlink_CN_DGG' )      -- ← 캡처의 Sales Site
                                                      --   (Cell Prod Site 는 일부러 안 건다 —
                                                      --    남경A 안에서 갈리는지 보려면 전부 봐야 한다)
 ORDER BY 1;
-- 같은 라벨로 보이던 줄이 실제로는 **다른 MEASURE 코드**인지 여기서 드러난다.
--   예) RTF_SYS_RP(=RTF[R+P]) 와 RTF_SCP(=RTF[P+P]) 가 나란히 나오는 경우
-- 한 MEASURE 가 2줄로 나오면 그 두 줄에서 다른 칸이 원인이다.


-- ----------------------------------------------------------------------------
-- §7. 라벨 없는 measure 가 섞여 나오는지 — 화면 Measure 칸이 빈 줄의 정체
--     SCM_MST_SHEET_MEASURE(해당 division) 에 없는 measure 는 FE 가 라벨을 못 붙인다.
-- ----------------------------------------------------------------------------
SELECT F.MEASURE,
       COUNT(*) AS 행수,
       MIN(F.BUCKET_KEY) AS 시작, MAX(F.BUCKET_KEY) AS 종료,
       MAX(M.COLUMN_LABEL_NAME) AS 화면라벨,
       CASE WHEN MAX(M.COLUMN_LABEL_NAME) IS NULL
            THEN '⚠ 라벨 없음 — 화면 Measure 칸이 빈 줄로 보인다'
            ELSE '정상' END AS 판정
  FROM SCM_MGR.GT_DMF0082_MF_SP F
  LEFT JOIN SCM_MGR.SCM_MST_SHEET_MEASURE M
    ON  M.PROGRAM_ID  = 'DMF0082'
    AND M.COLUMN_NAME = F.MEASURE
    AND M.VALID_YN    = 'Y'
    AND ',' || REPLACE(M.DIVISION_ID, ' ', '') || ',' LIKE '%,' || F.DIVISION_ID || ',%'
 GROUP BY F.MEASURE
 ORDER BY 6 DESC, 1;
-- '라벨 없음' 이 나오면 그 measure 가 화면에서 빈 Measure 칸으로 보이는 줄이다.
-- 이 경우는 행분리가 아니라 **조회 대상 measure 선정 문제**이므로 원인·보완이 다르다.

-- ----------------------------------------------------------------------------
-- §8. ⭐ 두 줄의 값이 어느 기간에 실려 있는가 — 실적/계획 분리 여부 확인
--     캡처에서 RTF[R+P] 두 줄이 서로 다른 주차 컬럼에만 값을 갖는다.
--     MF_SP 를 그레인별로 쪼개 **각 줄이 덮는 기간**을 본다.
-- ----------------------------------------------------------------------------
SELECT MEASURE, CELL_PROD_SITE_ID, CURRENCY, VERSION_NO, NOTATION, SORT_ORDER_NO,
       EDIT_FLAG, SORT_KEY, GROUP_ID, AS_FROM_SITE, LAST_UPDATED_BY, SENDER_CODE,
       NICK_NAME, INCOTERMS, FCST_TYPE, DOM_EXP, PLANT_SITE_ID, PROJECT_CODE, END_CUSTOMER,
       COUNT(*) AS 행수, MIN(BUCKET_KEY) AS 시작, MAX(BUCKET_KEY) AS 종료, SUM(QTY) AS 합계
  FROM SCM_MGR.GT_DMF0082_MF_SP
 WHERE ITEM_ID     = 'MCSS22531-B1'
   AND SCM_SITE_ID = 'Foxlink_CN_DGG'
   AND MEASURE IN ('RTF_SYS_RP', 'BALANCE')
 GROUP BY MEASURE, CELL_PROD_SITE_ID, CURRENCY, VERSION_NO, NOTATION, SORT_ORDER_NO,
          EDIT_FLAG, SORT_KEY, GROUP_ID, AS_FROM_SITE, LAST_UPDATED_BY, SENDER_CODE,
          NICK_NAME, INCOTERMS, FCST_TYPE, DOM_EXP, PLANT_SITE_ID, PROJECT_CODE, END_CUSTOMER
 ORDER BY MEASURE, 시작;
-- 한 MEASURE 가 2줄로 나오면 두 줄을 좌우로 비교한다. **다른 칸이 범인**이다.
-- '시작/종료' 가 앞뒤로 갈리면 실적 구간 줄 / 계획 구간 줄이다.

-- ============================================================================
-- §9. ⭐⭐ 실제 그리드 줄 수 — V_COLUMN 을 그대로 재현해서 센다
--
--   §5 실측으로 이 계정의 그레인이 확정됐다.
--     V_COLUMN = C_TITLE 16 + NOTATION + SORT_ORDER_NO
--              = CELL_PROD_SITE_ID, CURRENCY, DIVISION_ID, DOM_EXP, END_CUSTOMER,
--                FCST_TYPE, INCOTERMS, ITEM_ID, MEASURE, NICK_NAME, PLANT_SITE_ID,
--                PROJECT_CODE, PROJECT_NAME, PROJECT_OWNER, SCM_SITE_ID,
--                TEAM_ID(=DEPT_ID), NOTATION, SORT_ORDER_NO
--     KEYCOL 12 는 전부 이미 C_TITLE 에 있어 **추가되는 것이 없다**
--     → 이 계정은 AS-IS 와 그레인이 동일하다.
--     LAST_UPDATED_BY 는 C_TITLE 에 없으므로 **그레인이 아니다**(행을 가르지 못한다).
--
--   아래가 DB 가 내보내는 **진짜 줄 수**다.
--     · 2줄이 나오면 → DB 단계 분리. 어느 칸이 다른지 바로 보인다.
--     · 1줄이 나오면 → DB 는 1줄인데 화면이 2줄 = **FE 렌더 문제**로 범위가 바뀐다.
-- ============================================================================
SELECT MEASURE, SORT_ORDER_NO, NOTATION,
       CELL_PROD_SITE_ID, CURRENCY, DOM_EXP, END_CUSTOMER, FCST_TYPE, INCOTERMS,
       NICK_NAME, PLANT_SITE_ID, PROJECT_CODE, PROJECT_NAME, PROJECT_OWNER,
       DEPT_ID AS TEAM_ID,
       COUNT(*) AS 원본행수, MIN(BUCKET_KEY) AS 시작, MAX(BUCKET_KEY) AS 종료,
       SUM(QTY) AS 합계
  FROM SCM_MGR.GT_DMF0082_MF_SP
 WHERE ITEM_ID     = 'MCSS22531-B1'
   AND SCM_SITE_ID = 'Foxlink_CN_DGG'
 GROUP BY MEASURE, SORT_ORDER_NO, NOTATION,
          CELL_PROD_SITE_ID, CURRENCY, DOM_EXP, END_CUSTOMER, FCST_TYPE, INCOTERMS,
          NICK_NAME, PLANT_SITE_ID, PROJECT_CODE, PROJECT_NAME, PROJECT_OWNER, DEPT_ID
 ORDER BY TO_NUMBER(SORT_ORDER_NO), MEASURE;
-- ⭐ 여기 나온 줄 수 = 화면에 보여야 할 줄 수다.
--    RTF_SYS_RP 가 1줄이면 DB 는 정상이고 화면이 2줄로 그린 것이다.


-- ----------------------------------------------------------------------------
-- §10. §9 가 1줄인데 화면이 2줄이면 — FE 로 실제 나가는 결과를 본다
--      O_RC1 을 그대로 받아 RTF 줄이 몇 개인지 센다.
--      (DBeaver: 결과 그리드에서 MEASURE 컬럼 기준으로 확인)
-- ----------------------------------------------------------------------------
-- 아래를 §1 과 같은 세션에서 실행하고, 결과 그리드에서 MEASURE = 'RTF_SYS_RP' 인
-- 줄이 몇 개인지 직접 센다. (O_RC1 은 PIVOT 결과 = 화면 그리드 원본)
DECLARE
    R1 SYS_REFCURSOR; R2 SYS_REFCURSOR; R3 SYS_REFCURSOR;
    R4 SYS_REFCURSOR; R5 SYS_REFCURSOR; RR SYS_REFCURSOR;
BEGIN
    SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(
        p_division_id   => '40',        p_team_id       => 'ALL',
        p_customer      => 'ALL',       p_biz_type      => 'ALL',
        p_from_yyyymmdd => '20260101',  p_to_yyyymmdd   => '20271231',
        p_scm_site_id   => 'ALL',       p_item_id       => 'MCSS22531-B1',
        p_version_type  => 'Current',   p_qty_yn        => 'Y',
        p_created_by    => 'minyonglee1',
        p_user_group    => 'ADMIN',     p_plant_site_id => 'ALL',
        p_project_code  => 'ALL',       p_owner         => 'ALL',
        p_sender_code   => 'ALL',
        O_RC1 => R1, O_RC2 => R2, O_RC3 => R3, O_RC4 => R4, O_RC5 => R5,
        O_RESULT_CURSOR => RR);
    DBMS_SQL.RETURN_RESULT(R1);   -- ← 화면 그리드 원본이 그대로 반환된다
END;
/
-- MEASURE='RTF_SYS_RP' 줄이 2개면 DB 가 2줄을 내보내는 것이고,
-- 1개면 DB 는 1줄인데 FE 가 2줄로 그린 것이다. 여기서 원인 영역이 확정된다.

-- ============================================================================
-- §11. ⭐⭐⭐ 핵심 — **보이는 컬럼이 전부 같은데 2줄**인 경우를 찾는다
--
--   §5 실측 = 이 계정(minyonglee1)의 보이는 컬럼 16개.
--   그리드 그레인은 여기에 **보이지 않는 2개** (NOTATION, SORT_ORDER_NO) 가 더해진다.
--   보이는 16개가 같은데 줄이 2개면 → 화면에서 구분이 안 되는 중복 줄이고,
--   그 원인은 NOTATION / SORT_ORDER_NO 다.
--
--   ⚠ 유력 원인 (소스 실측): 실적 arm 은 표시 measure 를 B.MEASURE 로 넣으면서
--      NOTATION 은 **A.MEASURE(원장 measure = RESULT_MEASURE)** 로 계산한다.
--        L1886 실적 : CASE WHEN A.MEASURE IN ('KRW','USD','LOC',...) ... , MEASURE 는 B.MEASURE
--        L1670 계획 : CASE WHEN A.MEASURE IN (...) ...              , MEASURE 도 A.MEASURE
--      실적 arm 은 B.RESULT_MEASURE = A.MEASURE 로 조인해 한 행이 여러 표시 measure 로 fan-out 된다.
--      따라서 같은 표시 measure 인데 실적 줄은 'INTEGER', 계획 줄은 'POINT3' 이 될 수 있고
--      → **NOTATION 만 달라 2줄**이 된다. (사내는 RESULT_MEASURE 매핑이 달라 재현 안 됨)
-- ============================================================================
SELECT MEASURE, ITEM_ID, SCM_SITE_ID, PROJECT_CODE, INCOTERMS, FCST_TYPE,
       CELL_PROD_SITE_ID, CURRENCY,
       COUNT(*) AS 줄수,
       LISTAGG(NOTATION, ' | ') WITHIN GROUP (ORDER BY NOTATION)            AS NOTATION_값들,
       LISTAGG(SORT_ORDER_NO, ' | ') WITHIN GROUP (ORDER BY SORT_ORDER_NO)  AS SORT_값들
  FROM ( SELECT DISTINCT
                DIVISION_ID,
                PROJECT_CODE,
                END_CUSTOMER,
                SCM_SITE_ID,
                ITEM_ID,
                DOM_EXP,
                FCST_TYPE,
                INCOTERMS,
                MEASURE,
                PLANT_SITE_ID,
                CELL_PROD_SITE_ID,
                CURRENCY,
                NICK_NAME,
                PROJECT_NAME,
                PROJECT_OWNER,
                DEPT_ID,
                NOTATION, SORT_ORDER_NO
           FROM SCM_MGR.GT_DMF0082_MF_SP )
 GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, CURRENCY, NICK_NAME, PROJECT_NAME, PROJECT_OWNER, DEPT_ID
HAVING COUNT(*) > 1
 ORDER BY MEASURE, ITEM_ID, SCM_SITE_ID;
-- ⭐ 여기 나온 줄이 **화면에서 똑같아 보이는데 2줄로 나오는 것들**이다.
--    NOTATION_값들 이 'INTEGER | POINT3' 이면 위 실적/계획 NOTATION 불일치가 원인 확정이다.
--    0행이면 DB 는 중복 줄을 안 내보내는 것이고, 원인 영역이 FE 로 바뀐다.


-- ----------------------------------------------------------------------------
-- §12. §11 이 NOTATION 때문이라면 — 측정별 NOTATION 분포
-- ----------------------------------------------------------------------------
SELECT MEASURE, NOTATION, COUNT(*) AS 행수,
       MIN(BUCKET_KEY) AS 시작, MAX(BUCKET_KEY) AS 종료
  FROM SCM_MGR.GT_DMF0082_MF_SP
 GROUP BY MEASURE, NOTATION
 ORDER BY MEASURE, NOTATION;
-- 한 MEASURE 에 NOTATION 이 2종이면 확정이다.
-- '시작/종료' 로 어느 쪽이 실적 구간(앞)이고 계획 구간(뒤)인지 구분된다.
