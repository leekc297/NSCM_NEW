-- SOURCE-FRESH: OWNER=SCM_MGR OBJECT=PKG_DMF0082 (PACKAGE SPEC) LAST_DDL=2026-09-15 18:58:28 STATUS=VALID FETCHED=2026-09-16 18:24:59
-- SOURCE: 사내 ZIOUI1 빌드 시점 DB 추출 (hook #152)
-- NOTE  : [E20260916-PRICEWEEK] 변경은 BODY 한정 — SPEC 자체는 무변경(시그니처 동일)이나
--         클라우드 SPEC 세대 일치를 위해 동봉한다(사용자 지시 2026-09-16).
-- ⚠ ORDER: 반드시 SPEC 먼저 → 그 다음 02_PKG_DMF0082_BODY.sql.
--          SPEC 을 재컴파일하면 BODY 가 INVALID 가 되므로 BODY 를 뒤에 실행해야 한다.
CREATE OR REPLACE PACKAGE         "PKG_DMF0082" AS
/* [PKG CONSOLIDATION 20260723] UI별 PKG 취합 — 멤버 12. 기존 5 + 신규 7(standalone live 병합, 본문 무수정). */
    PROCEDURE P_DMF0082_GET_MAIN_DATA
    ( p_division_id IN VARCHAR2 , p_team_id IN VARCHAR2 , p_customer IN VARCHAR2 , p_biz_type IN VARCHAR2 , p_from_yyyymmdd IN VARCHAR2 , p_to_yyyymmdd IN VARCHAR2 , p_scm_site_id IN VARCHAR2 , p_item_id IN VARCHAR2 , p_version_type IN VARCHAR2 , p_qty_yn IN VARCHAR2 , p_created_by IN VARCHAR2 , p_user_group IN VARCHAR2 , p_plant_site_id IN VARCHAR2 DEFAULT 'ALL' /* [PLANT_SITE 2026-08-04] 조회조건 Plant Site (81 전용) */ , p_project_code IN VARCHAR2 DEFAULT 'ALL' /* [UICATEGORY 2026-08-07] 조회조건 Project */ , p_owner IN VARCHAR2 DEFAULT 'ALL' /* [UICATEGORY 2026-08-07] 조회조건 Owner */ , p_sender_code IN VARCHAR2 DEFAULT 'ALL' /* [UICATEGORY 2026-08-07] 조회조건 Sender Code (무값 행 통과) */ , O_RC1 OUT SYS_REFCURSOR , O_RC2 OUT SYS_REFCURSOR , O_RC3 OUT SYS_REFCURSOR , O_RC4 OUT SYS_REFCURSOR , O_RC5 OUT SYS_REFCURSOR , O_RESULT_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_POPUP_GET_FUTUREPRICE_INFO
    ( P_START_YYYYMMDD IN VARCHAR2, P_END_YYYYMMDD IN VARCHAR2, P_USER_ID IN VARCHAR2, P_MNU_ID IN VARCHAR2, O_RC1 OUT SYS_REFCURSOR, O_RESULT_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_POPUP_GET_MEASURE_COUNTINFO
    ( P_USER_ID IN VARCHAR2, P_MNU_ID IN VARCHAR2, O_RC1 OUT SYS_REFCURSOR, O_RESULT_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_POPUP_GET_MEASURE_COUNTINFO_SAVE_PRICE
    ( P_USER_ID IN VARCHAR2, P_MNU_ID IN VARCHAR2, O_RC1 OUT SYS_REFCURSOR, O_RESULT_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_POPUP_GET_WEEKDATA
    ( P_YYYYMMDD IN VARCHAR2, O_RC1 OUT SYS_REFCURSOR, O_RESULT_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_EXCEL_UPLOAD
    (
        p_mode           IN  NUMBER
      , p_created_by     IN  VARCHAR2
      , p_program_id     IN  VARCHAR2 DEFAULT 'DMF0082'   --[5ARG 2026-08-12] 공통 validProc 계약(Excel.xml 5-arg)
      , p_sheet_name     IN  VARCHAR2 DEFAULT 'FcstNPrice'
      , O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0082_GET_EXCEL_UPLOAD_DATA
    ( p_created_by IN VARCHAR2 , O_RC1 OUT SYS_REFCURSOR , O_RC2 OUT SYS_REFCURSOR , O_RESULT_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT
    ( p_division_id IN VARCHAR2 , p_team_id IN VARCHAR2 , p_customer IN VARCHAR2 , p_biz_type IN VARCHAR2 , p_from_yyyymmdd IN VARCHAR2 , p_to_yyyymmdd IN VARCHAR2 , p_scm_site_id IN VARCHAR2 , p_item_id IN VARCHAR2 , p_version_type IN VARCHAR2 , p_qty_yn IN VARCHAR2 , p_created_by IN VARCHAR2 , p_user_group IN VARCHAR2 , p_plant_site_id IN VARCHAR2 DEFAULT 'ALL' /* [PLANT_SITE 2026-08-04] 조회조건 Plant Site (81 전용) */ , p_project_code IN VARCHAR2 DEFAULT 'ALL' /* [UICATEGORY 2026-08-07] 조회조건 Project */ , p_owner IN VARCHAR2 DEFAULT 'ALL' /* [UICATEGORY 2026-08-07] 조회조건 Owner */ , p_sender_code IN VARCHAR2 DEFAULT 'ALL' /* [UICATEGORY 2026-08-07] 조회조건 Sender Code (무값 행 통과) */ , O_RC1 OUT SYS_REFCURSOR , O_RC2 OUT SYS_REFCURSOR , O_RC3 OUT SYS_REFCURSOR , O_RC4 OUT SYS_REFCURSOR , O_RC5 OUT SYS_REFCURSOR , O_RESULT_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_GET_SPREAD_TITLE
    ( p_start_yyyymmdd IN VARCHAR2, p_end_yyyymmdd IN VARCHAR2, p_created_by IN VARCHAR2, p_division_id IN VARCHAR2, O_RESULT_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP
    ( p_division_id IN VARCHAR2, p_dept_id IN VARCHAR2, p_end_customer IN VARCHAR2, p_scm_site_id IN VARCHAR2, p_plant_site_id IN VARCHAR2, p_project_code IN VARCHAR2, p_item_id IN VARCHAR2, p_customer_project_code IN VARCHAR2, p_customer_model IN VARCHAR2, p_from_yyyymmdd IN VARCHAR2, p_to_yyyymmdd IN VARCHAR2, p_biztype IN VARCHAR2, p_created_by IN VARCHAR2, p_userinfo IN VARCHAR2, p_owner IN VARCHAR2, p_over_range IN VARCHAR2, p_invalid_exec IN VARCHAR2, O_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE
    ( p_start_dt IN VARCHAR2, p_end_dt IN VARCHAR2, p_created_by IN VARCHAR2, p_division_id IN VARCHAR2, O_RESULT_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_SAVE_MAIN_DATA
    ( p_active_flag IN VARCHAR2 , p_division_id IN VARCHAR2 , p_project_code IN VARCHAR2 , p_end_customer IN VARCHAR2 , p_scm_site_id IN VARCHAR2 , p_item_id IN VARCHAR2 , p_dom_exp IN VARCHAR2 , p_fcst_type IN VARCHAR2 , p_incoterms IN VARCHAR2 , p_measure IN VARCHAR2 , p_plant_site_id IN VARCHAR2 , p_cell_prod_site_id IN VARCHAR2 , p_yyyymmdd IN VARCHAR2 , p_currency IN VARCHAR2 , p_qty IN VARCHAR2 , p_created_by IN VARCHAR2 , p_as_from_site IN VARCHAR2 DEFAULT NULL , O_RESULT_CURSOR OUT SYS_REFCURSOR );


-- ============================================================================
-- [E20260813-EXCELFORM] DMF0082 Excel Form 조회 SP 신설 — SPEC 선언부
--
--  목적: Excel Form 이 "본인 최종 업로드분 재조회"(P_DMF0082_GET_EXCEL_UPLOAD_DATA)가 아니라
--        **화면 조회조건에 걸린 현재 데이터 전체**를 양식으로 내려주도록 한다 (사용자 요구 2026-08-13).
--
--  계약:
--   - IN 16종 = P_DMF0082_GET_MAIN_DATA 와 **동일 축·동일 명명**
--     (CURRENT SP 가 team/startDate/endDate/version 으로 어긋나 있는 전례를 반복하지 않는다)
--   - 1행 = (조회조건에 걸린 키 조합) × (입력 가능 measure 1종). 월 값 컬럼은 내리지 않는다
--     (M4~M16 빈칸은 FE 가 생성 — 사용자 확정: 입력 전용)
--   - 각 값은 **업로드 검증 SP(P_DMF0082_EXCEL_UPLOAD)가 기대하는 표기 그대로** 내린다.
--     즉 본 SP 는 검증 SP 의 역함수이며, 이로써 양식→업로드 왕복이 구조적으로 보장된다.
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
);


    -- [2026.08.15 AJS 신뢰도검사 발견1] MSSQL DMF0082_POPUP_GET_SPREAD_TITLE_DATE 미이관분 이관
    PROCEDURE P_DMF0082_POPUP_GET_SPREAD_TITLE_DATE
    (
        p_start_yyyymmdd  IN  VARCHAR2
      , p_end_yyyymmdd    IN  VARCHAR2
      , p_created_by      IN  VARCHAR2
      , O_RC1             OUT SYS_REFCURSOR
      , O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    -- [2026-09-15 UIPKG] standalone PR_DM_PLN_CFM_TO_MKT_FCST
    PROCEDURE P_PR_DM_PLN_CFM_TO_MKT_FCST 
(
    p_created_by        IN  VARCHAR2
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
);

    -- [2026-09-15 UIPKG] standalone PR_SCM_MST_EXCHANGE_RATE
    PROCEDURE P_PR_SCM_MST_EXCHANGE_RATE 
(
      P_BATCH_YN  VARCHAR2 DEFAULT 'Y'  /* [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : P_BATCH_YN 파라미터 추가하여 배치수행/화면수행 구분 */
);

    -- [2026-09-15 UIPKG] standalone PR_SCM_MST_EXCHANGE_RATE_UI
    PROCEDURE P_PR_SCM_MST_EXCHANGE_RATE_UI (
    P_BATCH_YN      IN  VARCHAR2 DEFAULT 'N',
    O_RESULT_CURSOR OUT SYS_REFCURSOR
);

END PKG_DMF0082;
/
