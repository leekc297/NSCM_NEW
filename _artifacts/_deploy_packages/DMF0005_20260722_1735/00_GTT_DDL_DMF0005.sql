-- ============================================================================
-- [DMF0005 PERF 20260722] Step 1: GTT 자급 DDL (멱등 — 기존재 ORA-00955 skip)
-- PKG_DMF0005.P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION 이 의존하는
-- GT_GGET_SPLIT_* 패밀리 7종 전부 동봉 (클라우드 기존재 가정 금지 — hook deploy-package-completeness)
-- 규격: 기존 패밀리(GT_GGET_SPLIT_OWNER 등)와 동일 — TOK VARCHAR2(1600), ON COMMIT PRESERVE ROWS
-- ============================================================================
DECLARE
    PROCEDURE MK(P_NAME IN VARCHAR2) IS
        E_EXISTS EXCEPTION;
        PRAGMA EXCEPTION_INIT(E_EXISTS, -955);
    BEGIN
        EXECUTE IMMEDIATE 'CREATE GLOBAL TEMPORARY TABLE ' || P_NAME ||
                          ' ( TOK VARCHAR2(1600) ) ON COMMIT PRESERVE ROWS';
        DBMS_OUTPUT.PUT_LINE('CREATED: ' || P_NAME);
    EXCEPTION
        WHEN E_EXISTS THEN DBMS_OUTPUT.PUT_LINE('SKIP(-955): ' || P_NAME);
    END;
BEGIN
    MK('GT_GGET_SPLIT_TEAM_ID');
    MK('GT_GGET_SPLIT_CUSTOMER');
    MK('GT_GGET_SPLIT_SCM_SITE_ID');
    MK('GT_GGET_SPLIT_VALID_YN');
    MK('GT_GGET_SPLIT_ITEM_ID');
    MK('GT_GGET_SPLIT_PROJECT_CODE');
    MK('GT_GGET_SPLIT_OWNER');
END;
/

-- 검증: 7행 + duration=SYS$SESSION 이어야 함
SELECT table_name, duration
  FROM user_tables
 WHERE table_name IN ('GT_GGET_SPLIT_TEAM_ID','GT_GGET_SPLIT_CUSTOMER','GT_GGET_SPLIT_SCM_SITE_ID',
                      'GT_GGET_SPLIT_VALID_YN','GT_GGET_SPLIT_ITEM_ID','GT_GGET_SPLIT_PROJECT_CODE',
                      'GT_GGET_SPLIT_OWNER')
 ORDER BY table_name;
