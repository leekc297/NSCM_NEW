-- ============================================================================
-- DMF0082 SAVE_MAIN_DATA — P_AS_FROM_SITE 신설 (2026-08-05 사용자 요청)
--   ①시그니처: p_as_from_site IN VARCHAR2 DEFAULT NULL (16번째 IN, positional 뒤호환)
--   ②'^' unfold 2변수 패턴으로 행별 토큰 파싱 → GT V_ATTRIBUTE10 적재
--   ③V81-11 AS 계열 신규 차단 가드 완화: AS FROM SITE 공백 행만 차단
--   ④81 MERGE(DM_PLN_MKT_FCST) UPDATE 에 ATTRIBUTE10 조건부 갱신(미전달 시 보존)
--   ⑤이력(DM_PLN_MKT_FCST_H)·AS Plant 지움 로직은 GT 컬럼 운반으로 자동 반영 (기존)
--   40 경로(DM_PLN_CFM_*)는 무변경. 원본: 사내 live 2026-08-05 추출본 위 치환.
-- ============================================================================
CREATE OR REPLACE
PACKAGE           "PKG_DMF0082" AS
/* [PKG CONSOLIDATION 20260723] UI별 PKG 취합 — 멤버 12. 기존 5 + 신규 7(standalone live 병합, 본문 무수정). */
    PROCEDURE P_DMF0082_GET_MAIN_DATA
    ( p_division_id IN VARCHAR2 , p_team_id IN VARCHAR2 , p_customer IN VARCHAR2 , p_biz_type IN VARCHAR2 , p_from_yyyymmdd IN VARCHAR2 , p_to_yyyymmdd IN VARCHAR2 , p_scm_site_id IN VARCHAR2 , p_item_id IN VARCHAR2 , p_version_type IN VARCHAR2 , p_qty_yn IN VARCHAR2 , p_created_by IN VARCHAR2 , p_user_group IN VARCHAR2 , p_plant_site_id IN VARCHAR2 DEFAULT 'ALL' /* [PLANT_SITE 2026-08-04] 조회조건 Plant Site (81 전용) */ , O_RC1 OUT SYS_REFCURSOR , O_RC2 OUT SYS_REFCURSOR , O_RC3 OUT SYS_REFCURSOR , O_RC4 OUT SYS_REFCURSOR , O_RC5 OUT SYS_REFCURSOR , O_RESULT_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_POPUP_GET_FUTUREPRICE_INFO
    ( P_START_YYYYMMDD IN VARCHAR2, P_END_YYYYMMDD IN VARCHAR2, P_USER_ID IN VARCHAR2, P_MNU_ID IN VARCHAR2, O_RC1 OUT SYS_REFCURSOR, O_RESULT_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_POPUP_GET_MEASURE_COUNTINFO
    ( P_USER_ID IN VARCHAR2, P_MNU_ID IN VARCHAR2, O_RC1 OUT SYS_REFCURSOR, O_RESULT_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_POPUP_GET_MEASURE_COUNTINFO_SAVE_PRICE
    ( P_USER_ID IN VARCHAR2, P_MNU_ID IN VARCHAR2, O_RC1 OUT SYS_REFCURSOR, O_RESULT_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_POPUP_GET_WEEKDATA
    ( P_YYYYMMDD IN VARCHAR2, O_RC1 OUT SYS_REFCURSOR, O_RESULT_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_EXCEL_UPLOAD
    ( p_mode IN NUMBER , p_created_by IN VARCHAR2 , O_RESULT_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_GET_EXCEL_UPLOAD_DATA
    ( p_created_by IN VARCHAR2 , O_RC1 OUT SYS_REFCURSOR , O_RC2 OUT SYS_REFCURSOR , O_RESULT_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT
    ( p_division_id IN VARCHAR2 , p_team_id IN VARCHAR2 , p_customer IN VARCHAR2 , p_biz_type IN VARCHAR2 , p_from_yyyymmdd IN VARCHAR2 , p_to_yyyymmdd IN VARCHAR2 , p_scm_site_id IN VARCHAR2 , p_item_id IN VARCHAR2 , p_version_type IN VARCHAR2 , p_qty_yn IN VARCHAR2 , p_created_by IN VARCHAR2 , p_user_group IN VARCHAR2 , p_plant_site_id IN VARCHAR2 DEFAULT 'ALL' /* [PLANT_SITE 2026-08-04] 조회조건 Plant Site (81 전용) */ , O_RC1 OUT SYS_REFCURSOR , O_RC2 OUT SYS_REFCURSOR , O_RC3 OUT SYS_REFCURSOR , O_RC4 OUT SYS_REFCURSOR , O_RC5 OUT SYS_REFCURSOR , O_RESULT_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_GET_SPREAD_TITLE
    ( p_start_yyyymmdd IN VARCHAR2, p_end_yyyymmdd IN VARCHAR2, p_created_by IN VARCHAR2, p_division_id IN VARCHAR2, O_RESULT_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP
    ( p_division_id IN VARCHAR2, p_dept_id IN VARCHAR2, p_end_customer IN VARCHAR2, p_scm_site_id IN VARCHAR2, p_plant_site_id IN VARCHAR2, p_project_code IN VARCHAR2, p_item_id IN VARCHAR2, p_customer_project_code IN VARCHAR2, p_customer_model IN VARCHAR2, p_from_yyyymmdd IN VARCHAR2, p_to_yyyymmdd IN VARCHAR2, p_biztype IN VARCHAR2, p_created_by IN VARCHAR2, p_userinfo IN VARCHAR2, p_owner IN VARCHAR2, p_over_range IN VARCHAR2, p_invalid_exec IN VARCHAR2, O_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE
    ( p_start_dt IN VARCHAR2, p_end_dt IN VARCHAR2, p_created_by IN VARCHAR2, p_division_id IN VARCHAR2, O_RESULT_CURSOR OUT SYS_REFCURSOR );

    PROCEDURE P_DMF0082_SAVE_MAIN_DATA
    ( p_active_flag IN VARCHAR2 , p_division_id IN VARCHAR2 , p_project_code IN VARCHAR2 , p_end_customer IN VARCHAR2 , p_scm_site_id IN VARCHAR2 , p_item_id IN VARCHAR2 , p_dom_exp IN VARCHAR2 , p_fcst_type IN VARCHAR2 , p_incoterms IN VARCHAR2 , p_measure IN VARCHAR2 , p_plant_site_id IN VARCHAR2 , p_cell_prod_site_id IN VARCHAR2 , p_yyyymmdd IN VARCHAR2 , p_currency IN VARCHAR2 , p_qty IN VARCHAR2 , p_created_by IN VARCHAR2 , p_as_from_site IN VARCHAR2 DEFAULT NULL , O_RESULT_CURSOR OUT SYS_REFCURSOR );

END PKG_DMF0082;
/
