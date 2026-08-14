-- ============================================================================
-- [E20260813-EXCELFORM] DMF0082 Excel Form 조회 SP 신설 — BODY 구현부
--
--  ⭐ 설계 요지 (근거)
--   1) 조회조건 필터는 **MAIN GET 을 그대로 호출**해 재사용한다. MAIN 이 스테이징하는
--      GT_DMF0082_TEMP_FCST_N_PRICE 가 키 10 + 정보성 컬럼 전량을 이미 보유하므로,
--      필터 로직을 복제하지 않고도 "MAIN 조회조건에 맞는 데이터 전체"가 정의상 보장된다.
--      (사내 실측 2026-08-13: div40 3개월 = GET 6.9s / GTT 938,540행 / DISTINCT 키 2,559)
--   2) measure 는 화면 개인화(titleset)와 **무관**하게 LOOKUP 'DM_UI_EDITABLE_MEASURE'
--      (SEGMENT1='DMF0082', ATTRIBUTE1='Y' = INSERT_YN)로 CROSS JOIN 한다 — 사용자 요구
--      "입력 가능 메저 전체 대상". VMI 조건(ATTRIBUTE3)은 검증 SP L4711~4716 과 동일 술어를 쓴다.
--   3) 각 컬럼 값은 **검증 SP 가 기대하는 표기**로 내린다 (검증 SP 원문 실측):
--        Div              = 코드 그대로                              (L4330)
--        End Customer     = END_CUSTOMER lookup SEGMENT3(명칭)        (L4394 EC.NAME = ATTRIBUTE2)
--        Sales Site       = SCM_SITE_ID 코드 그대로                   (L4433)
--        Model            = ITEM_ID 코드 그대로                       (L4513)
--        Incoterms        = INCOTERMS lookup SEGMENT2(=SEGMENT1)      (L4552)
--        FCST Type        = SALES_TYPE_CODE lookup SEGMENT2(명칭)     (L4591)
--        Customs Handbook = DM_CUSTOMS_HANDBOOK_40 SEGMENT2(=SEG1)    (L4629)
--        Cell Prod Site   = SP_CELL_PROD_SITE ATTRIBUTE1(명칭)        (L4667)
--        Currency         = CURRENCY_LIST SEGMENT2(=SEGMENT1)         (L4761, LOC 행만 검증)
--        Measure          = DM_UI_EDITABLE_MEASURE SEGMENT4(표시명)   (L4722)
--      → 본 SP 는 검증 SP 의 역함수. 양식→업로드 왕복이 구조적으로 보장된다.
--   4) 정보성 컬럼은 키별 MAX() 로 축약한다. DISTINCT 에 넣으면 정보성 값 변형 1건이
--      키를 쪼개 행이 불어난다(중복 양식 행 = 업로드 중복키 ERROR 유발).
-- ============================================================================
PROCEDURE P_DMF0082_GET_EXCEL_FORM_DATA (
    p_division_id               IN  VARCHAR2
  , p_dept_id                   IN  VARCHAR2
  , p_end_customer              IN  VARCHAR2
  , p_biz_type                  IN  VARCHAR2
  , p_from_yyyymmdd             IN  VARCHAR2
  , p_to_yyyymmdd               IN  VARCHAR2
  , p_sales_site                IN  VARCHAR2
  , p_item_id                   IN  VARCHAR2
  , p_version_type              IN  VARCHAR2
  , p_qty_yn                    IN  VARCHAR2
  , p_ses_user_id               IN  VARCHAR2
  , p_user_group                IN  VARCHAR2
  , p_plant_site_id             IN  VARCHAR2 DEFAULT 'ALL'
  , p_project_code              IN  VARCHAR2 DEFAULT 'ALL'
  , p_owner                     IN  VARCHAR2 DEFAULT 'ALL'
  , p_sender_code               IN  VARCHAR2 DEFAULT 'ALL'
  , o_rc1                       OUT SYS_REFCURSOR
  , o_result_cursor             OUT SYS_REFCURSOR
)
AS
    v_rc_main                   SYS_REFCURSOR;
    v_rc_d1                     SYS_REFCURSOR;
    v_rc_d2                     SYS_REFCURSOR;
    v_rc_d3                     SYS_REFCURSOR;
    v_rc_d4                     SYS_REFCURSOR;
    v_rc_res                    SYS_REFCURSOR;
    n_key_cnt                   PLS_INTEGER := 0;

    V_PROC_INPUT                VARCHAR2(4000 CHAR);
    V_BACKTRACE                 VARCHAR2(4000 CHAR);
    V_SQL_CODE                  VARCHAR2(100  CHAR);
    V_SQL_ERRMSG                VARCHAR2(1000 CHAR);
    n_log_count                 PLS_INTEGER := 0;
    V_PROGRAM_NAME              VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
BEGIN
    --[E20260806-DS2] GT/GTT 사용 SP 표준 — 클라우드 optimizer_dynamic_sampling=0 방어
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

    ------------------------------------------------------------------------
    -- 1) MAIN 조회 파이프라인 재사용 → GT_DMF0082_TEMP_FCST_N_PRICE 적재
    --    (커서는 쓰지 않고 즉시 닫는다 — 필터 로직 복제 방지가 목적)
    ------------------------------------------------------------------------
    SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(
        p_division_id, p_dept_id, p_end_customer, p_biz_type
      , p_from_yyyymmdd, p_to_yyyymmdd, p_sales_site, p_item_id
      , p_version_type, p_qty_yn, p_ses_user_id, p_user_group
      , p_plant_site_id, p_project_code, p_owner, p_sender_code
      , v_rc_main, v_rc_d1, v_rc_d2, v_rc_d3, v_rc_d4, v_rc_res
    );
    BEGIN IF v_rc_main IS NOT NULL THEN CLOSE v_rc_main; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN IF v_rc_d1   IS NOT NULL THEN CLOSE v_rc_d1;   END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN IF v_rc_d2   IS NOT NULL THEN CLOSE v_rc_d2;   END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN IF v_rc_d3   IS NOT NULL THEN CLOSE v_rc_d3;   END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN IF v_rc_d4   IS NOT NULL THEN CLOSE v_rc_d4;   END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN IF v_rc_res  IS NOT NULL THEN CLOSE v_rc_res;  END IF; EXCEPTION WHEN OTHERS THEN NULL; END;

    SELECT COUNT(*) INTO n_key_cnt FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE;

    ------------------------------------------------------------------------
    -- 2) 양식 행 = 키(DISTINCT) × 입력 가능 measure, 값은 검증 기대 표기
    ------------------------------------------------------------------------
    OPEN o_rc1 FOR
    WITH WT_KEY AS (
        SELECT G.DIVISION_ID
             , G.END_CUSTOMER
             , G.SCM_SITE_ID
             , G.ITEM_ID
             , G.INCOTERMS
             , G.FCST_TYPE
             , G.DOM_EXP
             , G.CELL_PROD_SITE_ID
             -- LOC 행의 통화가 정본(단가 통화). 없으면 키의 대표 통화
             , NVL(MAX(CASE WHEN G.MEASURE = 'LOC' THEN G.CURRENCY END), MAX(G.CURRENCY)) AS CURRENCY
             -- 정보성 컬럼 (키별 MAX 축약 — DISTINCT 에 넣으면 키가 쪼개진다)
             , MAX(G.DEPT_ID)                        AS TEAM_ID
             , MAX(G.DEPT_NAME_KO)                   AS TEAM_NAME_KO
             , MAX(G.SOLDTO_CUSTOMER)                AS SOLDTO_CUSTOMER
             , MAX(G.COUNTRY_NAME)                   AS COUNTRY_NAME
             , MAX(G.CITY_NAME)                      AS CITY_NAME
             , MAX(G.ITEM_NAME)                      AS ITEM_NAME
             , MAX(G.NICK_NAME)                      AS NICK_NAME
             , MAX(G.ITEM_TYPE)                      AS ITEM_TYPE
             , MAX(G.CUST_GROUP)                     AS CUST_GROUP
             , MAX(G.CUST_GROUP_DTL)                 AS CUST_GROUP_DTL
             , MAX(G.OWNER)                          AS OWNER
             , MAX(G.APPLICATION)                    AS APPLICATION
             , MAX(G.ROUTE)                          AS ROUTE
             , MAX(G.MDM_PROJECT_NAME)               AS MDM_PROJECT_NAME
             , MAX(G.MIN_CAPACITY)                   AS MIN_CAPACITY
             , MAX(G.FORECAST_INFO_BIZ_TYPE)         AS FORECAST_INFO_BIZ_TYPE
             , MAX(G.CELL_TYPE)                      AS CELL_TYPE
             , MAX(G.CELL_MODEL)                     AS FORECAST_INFO_CELL_MODEL
             , MAX(G.FORECAST_INFO_CELL_PACK_COUNT)  AS FORECAST_INFO_CELL_PACK_COUNT
             , MAX(G.FORECAST_INFO_ALL)              AS FORECAST_INFO_ALL
             , MAX(G.FORECAST_INFO_SPEC)             AS FORECAST_INFO_SPEC
             , MAX(G.FORECAST_INFOR_VERSION)         AS FORECAST_INFOR_VERSION
             , MAX(G.CELL_MODEL_NICK_NAME)           AS CELL_MODEL_NICK_NAME
             , MAX(G.VMI_YN)                         AS VMI_YN
             , MAX(G.DMS_SALES)                      AS DMS_SALES
             , MAX(G.DMS_CUSTOMER)                   AS DMS_CUSTOMER
             , MAX(G.AS_FROM_SITE)                   AS AS_FROM_SITE
             , MAX(G.LAST_UPDATED_BY)                AS LAST_UPDATED_BY
             , MAX(G.SENDER_NAME)                    AS SENDER_NAME
          FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE G
         GROUP BY G.DIVISION_ID, G.END_CUSTOMER, G.SCM_SITE_ID, G.ITEM_ID
                , G.INCOTERMS, G.FCST_TYPE, G.DOM_EXP, G.CELL_PROD_SITE_ID
    )
    -- 입력 가능 measure (화면 개인화 무관 — INSERT_YN='Y')
    , WT_MEASURE AS (
        SELECT L.SEGMENT2  AS DIVISION_ID
             , L.SEGMENT3  AS MEASURE_CODE
             , L.SEGMENT4  AS MEASURE_NAME
             , L.ATTRIBUTE3 AS VMI_COND
             , ROW_NUMBER() OVER (PARTITION BY L.SEGMENT2 ORDER BY L.SEGMENT3) AS MEASURE_SORT
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
         INNER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER M
            ON  M.LOOKUP_TYPE = L.LOOKUP_TYPE
            AND M.VALID_YN    = 'Y'
         WHERE L.LOOKUP_TYPE = 'DM_UI_EDITABLE_MEASURE'
           AND L.SEGMENT1    = 'DMF0082'
           AND L.VALID_YN    = 'Y'
           AND L.ATTRIBUTE1  = 'Y'          -- INSERT_YN (검증 SP L4709 동일)
    )
    -- End Customer 코드 → 명칭 (검증 SP L4387~4393 역방향)
    , WT_EC AS (
        SELECT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS EC_CODE, MAX(SEGMENT3) AS EC_NAME
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'END_CUSTOMER' AND VALID_YN = 'Y' AND SEGMENT2 <> '-'
         GROUP BY SEGMENT1, SEGMENT2
    )
    -- FCST Type 코드 → 명칭 (검증 SP L4586~4591 역방향)
    , WT_FCST AS (
        SELECT SEGMENT1 AS FCST_CODE, MAX(SEGMENT2) AS FCST_NAME
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'SALES_TYPE_CODE' AND VALID_YN = 'Y'
           AND NVL(ATTRIBUTE2, '-') <> 'Y'
         GROUP BY SEGMENT1
    )
    -- Cell Prod Site 코드 → 명칭 (검증 SP L4663~4667 역방향)
    , WT_CPS AS (
        SELECT SEGMENT1 AS CPS_CODE, MAX(ATTRIBUTE1) AS CPS_NAME
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'SP_CELL_PROD_SITE' AND VALID_YN = 'Y'
         GROUP BY SEGMENT1
    )
    SELECT K.DIVISION_ID
         , NVL(EC.EC_NAME, K.END_CUSTOMER)      AS END_CUSTOMER
         , K.SCM_SITE_ID
         , K.ITEM_ID
         , K.INCOTERMS
         , NVL(FT.FCST_NAME, K.FCST_TYPE)       AS FCST_TYPE
         , K.DOM_EXP
         , NVL(CP.CPS_NAME, K.CELL_PROD_SITE_ID) AS CELL_PROD_SITE_ID
         , K.CURRENCY
         , MSR.MEASURE_NAME                      AS MEASURE
         --
         , K.TEAM_ID, K.TEAM_NAME_KO, K.SOLDTO_CUSTOMER, K.COUNTRY_NAME, K.CITY_NAME
         , K.ITEM_NAME, K.NICK_NAME, K.ITEM_TYPE, K.CUST_GROUP, K.CUST_GROUP_DTL
         , K.OWNER, K.APPLICATION, K.ROUTE, K.MDM_PROJECT_NAME, K.MIN_CAPACITY
         , K.FORECAST_INFO_BIZ_TYPE, K.CELL_TYPE, K.FORECAST_INFO_CELL_MODEL
         , K.FORECAST_INFO_CELL_PACK_COUNT, K.FORECAST_INFO_ALL, K.FORECAST_INFO_SPEC
         , K.FORECAST_INFOR_VERSION, K.CELL_MODEL_NICK_NAME, K.VMI_YN
         , K.DMS_SALES, K.DMS_CUSTOMER, K.AS_FROM_SITE, K.LAST_UPDATED_BY, K.SENDER_NAME
         -- ⭐ 업로드 불가 예고 플래그 — 마스터 결핍으로 **검증 SP 역변환이 실패할 행**을 미리 표시한다.
         --    (사내 실측 2026-08-13 div40 3개월: EC 1종 'SUZUKI' / CellProdSite 2종 EG00-A·AZ00-A / Incoterms 1종)
         --    양식에 실어 보내고 업로드에서야 ERROR 로 알려주면 사용자가 원인을 못 찾는다.
         , RTRIM(
             CASE WHEN EC.EC_NAME IS NULL AND K.END_CUSTOMER NOT IN (
                       SELECT SI.PROJECT_CODE FROM SCM_MGR.SCM_MST_SITE_ITEM SI
                        WHERE SI.DIVISION_ID = K.DIVISION_ID AND SI.VALID_YN = 'Y')
                  THEN 'EC,' ELSE '' END ||
             CASE WHEN CP.CPS_NAME IS NULL THEN 'CELL_PROD_SITE,' ELSE '' END ||
             CASE WHEN NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LI
                                    WHERE LI.LOOKUP_TYPE = 'INCOTERMS' AND LI.VALID_YN = 'Y'
                                      AND LI.SEGMENT2 = K.INCOTERMS)
                  THEN 'INCOTERMS,' ELSE '' END
           , ',') AS FORM_WARN
      FROM WT_KEY K
     INNER JOIN WT_MEASURE MSR
        ON MSR.DIVISION_ID = K.DIVISION_ID
      LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE MS
        ON  MS.DIVISION_ID = K.DIVISION_ID
        AND MS.SCM_SITE_ID = K.SCM_SITE_ID
      LEFT OUTER JOIN WT_EC EC
        ON  EC.DIVISION_ID = K.DIVISION_ID
        AND EC.EC_CODE     = K.END_CUSTOMER
      LEFT OUTER JOIN WT_FCST FT
        ON  FT.FCST_CODE   = K.FCST_TYPE
      LEFT OUTER JOIN WT_CPS CP
        ON  CP.CPS_CODE    = K.CELL_PROD_SITE_ID
     -- VMI 조건 = 검증 SP L4711~4716 동일 술어 (양식에 넣어놓고 업로드에서 거부되는 일이 없도록)
     WHERE ( ( NVL(MS.VMI_YN, 'N') = 'N' AND MSR.VMI_COND <> 'Y' )
             OR NVL(MS.VMI_YN, 'N') = 'Y' )
     ORDER BY K.END_CUSTOMER, K.SCM_SITE_ID, K.ITEM_ID, K.FCST_TYPE
            , K.INCOTERMS, K.DOM_EXP, K.CELL_PROD_SITE_ID, MSR.MEASURE_SORT;

    OPEN o_result_cursor FOR
        SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG, TO_CHAR(n_key_cnt) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'p_division_id'    VALUE p_division_id
          , 'p_dept_id'        VALUE p_dept_id
          , 'p_end_customer'   VALUE SUBSTR(p_end_customer, 1, 200)
          , 'p_from_yyyymmdd'  VALUE p_from_yyyymmdd
          , 'p_to_yyyymmdd'    VALUE p_to_yyyymmdd
          , 'p_sales_site'     VALUE SUBSTR(p_sales_site, 1, 200)
          , 'p_item_id'        VALUE SUBSTR(p_item_id, 1, 200)
          , 'p_version_type'   VALUE p_version_type
          , 'p_ses_user_id'    VALUE p_ses_user_id
        );
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION',
                '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0082_GET_EXCEL_FORM_DATA;
