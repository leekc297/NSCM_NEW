PROCEDURE           "DMF0072_GET_NNMASTER_MAPPING_WRAPPER" (
    P_DATA_TYPE_CODE VARCHAR2,
    P_DIVISION_ID    VARCHAR2,
    P_DEPT_ID        VARCHAR2,
    P_END_CUSTOMER   VARCHAR2,
    P_SCM_SITE_ID    VARCHAR2,
    P_PROJECT_CODE   VARCHAR2,
    P_ITEM_ID        VARCHAR2,
    P_USER_ID        VARCHAR2,
    P_MENU_ID        VARCHAR2,
    O_RC1            OUT SYS_REFCURSOR
) AS
    V_RESULT_CURSOR SYS_REFCURSOR;
BEGIN
    -- As-Is .cs L477~485: FoxDataRequest("DMF0072_GET_NNMASTER_MAPPING")
    --   p_data_type_code/divisionId/deptId/endCustomer/scmSiteId 모두 콤마 join 그대로 전달
    --   ('ALL' 도 그대로 — 메인 SP 가 CASE WHEN P_XXX='ALL' THEN ... 으로 처리)
    SCM_MGR.PKG_DMF0072.P_DMF0072_GET_NNMASTER_MAPPING(
        P_DATA_TYPE_CODE,
        P_DIVISION_ID,
        P_DEPT_ID,
        P_END_CUSTOMER,
        P_SCM_SITE_ID,
        P_PROJECT_CODE,
        P_ITEM_ID,
        P_USER_ID,
        P_MENU_ID,
        O_RC1,
        V_RESULT_CURSOR
    );
END DMF0072_GET_NNMASTER_MAPPING_WRAPPER;