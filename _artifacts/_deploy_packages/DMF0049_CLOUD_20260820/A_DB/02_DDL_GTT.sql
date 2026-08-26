-- DMF0049_CLOUD_20260820 / A_DB/02_DDL_GTT.sql
-- GLOBAL TEMPORARY TABLE 자급 DDL — 기존재 가정 금지 (룰 #22 GTT/TYPE 자급 의무).
-- 축 확정 = ① PKG_DMF0049 소스 grep(주석 제거 LIVE) ② ALL_DEPENDENCIES 합집합 → 딕셔너리 교차.
--   grep 6종 / dep 6종 / 실존 GTT 6종.
-- ⚠ -955(기존재) skip 의 맹점: 이름만 같고 컬럼 구조가 다른 구세대 GTT 가 남아 있으면
--    조용히 통과한 뒤 런타임 ORA-00904/00932 로 터진다. 적용 전 90_VERIFY V4b 컬럼 시그니처 대조 필수.

-- GT_DMF0049_PJT (4 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DMF0049_PJT (
    DIVISION_ID                          VARCHAR2(30 CHAR),
    PROJECT_CODE                         VARCHAR2(30 CHAR),
    PROJECT_NAME                         VARCHAR2(150 CHAR),
    PRODUCT_GROUP_NAME                   VARCHAR2(30 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DMF0049_RESULTS_MST (45 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DMF0049_RESULTS_MST (
    ACTIVE_FLAG                          VARCHAR2(4000 CHAR),
    RESULT_MONTH                         VARCHAR2(4000 CHAR),
    DIVISION_ID                          VARCHAR2(4000 CHAR),
    VERSION_NO                           VARCHAR2(4000 CHAR),
    DATA_SEQ                             VARCHAR2(4000 CHAR),
    DEPARTMENT_ID                        VARCHAR2(4000 CHAR),
    DEPARTMENT_EDIT_FLAG                 VARCHAR2(4000 CHAR),
    T_DEPARTMENT_NAME                    VARCHAR2(4000 CHAR),
    DEPT_ID                              VARCHAR2(4000 CHAR),
    CUST_REPORT                          VARCHAR2(4000 CHAR),
    END_CUST_REPORT                      VARCHAR2(4000 CHAR),
    SOLDTO_CODE                          VARCHAR2(4000 CHAR),
    SOLDTO_CUST_REPORT                   VARCHAR2(4000 CHAR),
    PRODUCT_GROUP                        VARCHAR2(4000 CHAR),
    ITEM_ID                              VARCHAR2(4000 CHAR),
    PRODUCT_DETAILS                      VARCHAR2(4000 CHAR),
    CURRENCY                             VARCHAR2(4000 CHAR),
    COMPANY_ID                           VARCHAR2(4000 CHAR),
    BIZ_TYPE                             VARCHAR2(4000 CHAR),
    APPLICATION_GR                       VARCHAR2(4000 CHAR),
    APPLICATION                          VARCHAR2(4000 CHAR),
    COUNTRY_CODE                         VARCHAR2(4000 CHAR),
    PROJECT_CODE                         VARCHAR2(4000 CHAR),
    SCM_SITE_ID                          VARCHAR2(4000 CHAR),
    FCST_TYPE                            VARCHAR2(4000 CHAR),
    ITEM_USE                             VARCHAR2(4000 CHAR),
    SOLDTO_COUNTRY                       VARCHAR2(4000 CHAR),
    SHIPTO_COUNTRY                       VARCHAR2(4000 CHAR),
    END_CUSTOMER                         VARCHAR2(4000 CHAR),
    CELL_MODEL_INFO                      VARCHAR2(4000 CHAR),
    CELL_MODEL                           VARCHAR2(4000 CHAR),
    MEASURE                              VARCHAR2(4000 CHAR),
    YYYYMMDD                             VARCHAR2(4000 CHAR),
    QTY                                  VARCHAR2(4000 CHAR),
    CREATED_BY                           VARCHAR2(4000 CHAR),
    OWNER_NAME                           VARCHAR2(4000 CHAR),
    CUST_GROUP_DTL                       VARCHAR2(4000 CHAR),
    FORECAST_INFO_SPEC                   VARCHAR2(4000 CHAR),
    NICK_NAME                            VARCHAR2(4000 CHAR),
    FORECAST_INFO_CELL_PACK_COUNT        VARCHAR2(4000 CHAR),
    COMPANY_NAME                         VARCHAR2(4000 CHAR),
    COUNTRY_KR_NAME                      VARCHAR2(4000 CHAR),
    ROUTE                                VARCHAR2(4000 CHAR),
    DEPARTMENT_NAME                      VARCHAR2(4000 CHAR),
    DEPT_NAME                            VARCHAR2(4000 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DMF0049_RESULTS_MST_PRICE (36 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DMF0049_RESULTS_MST_PRICE (
    ACTIVE_FLAG                          VARCHAR2(4000 CHAR),
    RESULT_MONTH                         VARCHAR2(4000 CHAR),
    DIVISION_ID                          VARCHAR2(4000 CHAR),
    VERSION_NO                           VARCHAR2(4000 CHAR),
    DATA_SEQ                             VARCHAR2(4000 CHAR),
    DEPARTMENT_ID                        VARCHAR2(4000 CHAR),
    DEPT_ID                              VARCHAR2(4000 CHAR),
    CUST_REPORT                          VARCHAR2(4000 CHAR),
    END_CUST_REPORT                      VARCHAR2(4000 CHAR),
    SOLDTO_CODE                          VARCHAR2(4000 CHAR),
    SOLDTO_CUST_REPORT                   VARCHAR2(4000 CHAR),
    PRODUCT_GROUP                        VARCHAR2(4000 CHAR),
    ITEM_ID                              VARCHAR2(4000 CHAR),
    PRODUCT_DETAILS                      VARCHAR2(4000 CHAR),
    CURRENCY                             VARCHAR2(4000 CHAR),
    COMPANY_ID                           VARCHAR2(4000 CHAR),
    BIZ_TYPE                             VARCHAR2(4000 CHAR),
    APPLICATION_GR                       VARCHAR2(4000 CHAR),
    APPLICATION                          VARCHAR2(4000 CHAR),
    COUNTRY_CODE                         VARCHAR2(4000 CHAR),
    PROJECT_CODE                         VARCHAR2(4000 CHAR),
    SCM_SITE_ID                          VARCHAR2(4000 CHAR),
    FCST_TYPE                            VARCHAR2(4000 CHAR),
    CELL_MODEL_INFO                      VARCHAR2(4000 CHAR),
    CELL_MODEL                           VARCHAR2(4000 CHAR),
    MEASURE                              VARCHAR2(4000 CHAR),
    YYYYMMDD                             VARCHAR2(4000 CHAR),
    SALESAMT_LOC                         NUMBER,
    RTF_SYS_RP                           NUMBER,
    CREATED_BY                           VARCHAR2(4000 CHAR),
    ITEM_USE                             VARCHAR2(4000 CHAR),
    SOLDTO_COUNTRY                       VARCHAR2(4000 CHAR),
    SHIPTO_COUNTRY                       VARCHAR2(4000 CHAR),
    END_CUSTOMER                         VARCHAR2(4000 CHAR),
    DEPARTMENT_EDIT_FLAG                 VARCHAR2(4000 CHAR),
    T_DEPARTMENT_NAME                    VARCHAR2(4000 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DMF0049_SELECT_MEASURE (5 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DMF0049_SELECT_MEASURE (
    PROGRAM_ID                           VARCHAR2(50 CHAR),
    SHEET_NAME                           VARCHAR2(50 CHAR),
    USER_ID                              VARCHAR2(50 CHAR),
    MEASURE                              VARCHAR2(20 CHAR),
    SORT_ORDER_NO                        NUMBER
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DMF0049_T (48 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DMF0049_T (
    DIVISION_ID                          VARCHAR2(4000 CHAR),
    VERSION_NO                           VARCHAR2(4000 CHAR),
    CUTOFF_TYPE                          VARCHAR2(4000 CHAR),
    CUTOFF_YYYYMMDD                      VARCHAR2(4000 CHAR),
    DEPARTMENT_ID                        VARCHAR2(4000 CHAR),
    T_DEPARTMENT_ID                      VARCHAR2(4000 CHAR),
    T_DEPARTMENT_NAME                    VARCHAR2(4000 CHAR),
    DEPT_ID                              VARCHAR2(4000 CHAR),
    T_DEPT_ID                            VARCHAR2(4000 CHAR),
    T_DEPT_NAME                          VARCHAR2(4000 CHAR),
    END_CUST_REPORT                      VARCHAR2(4000 CHAR),
    CUST_REPORT                          VARCHAR2(4000 CHAR),
    PRODUCT_GROUP                        VARCHAR2(4000 CHAR),
    PROJECT_CODE                         VARCHAR2(4000 CHAR),
    SCM_SITE_ID                          VARCHAR2(4000 CHAR),
    ITEM_ID                              VARCHAR2(4000 CHAR),
    NICK_NAME                            VARCHAR2(4000 CHAR),
    MEASURE                              VARCHAR2(4000 CHAR),
    PLANT_SITE_ID                        VARCHAR2(4000 CHAR),
    COMPANY_ID                           VARCHAR2(4000 CHAR),
    YYYYMM                               VARCHAR2(4000 CHAR),
    CURRENCY                             VARCHAR2(4000 CHAR),
    QTY                                  NUMBER,
    EDIT_FLAG                            VARCHAR2(4000 CHAR),
    APP                                  VARCHAR2(4000 CHAR),
    SOLDTO_CUST_REPORT                   VARCHAR2(4000 CHAR),
    DMS_CUSTOMER                         VARCHAR2(4000 CHAR),
    BIZ_TYPE                             VARCHAR2(4000 CHAR),
    APPLICATION_GR                       VARCHAR2(4000 CHAR),
    PRODUCT_DETAILS                      VARCHAR2(4000 CHAR),
    DISPLAY_SEQ1                         NUMBER,
    DISPLAY_SEQ2                         NUMBER,
    COUNTRY_CODE                         VARCHAR2(4000 CHAR),
    SOLDTO_CODE                          VARCHAR2(4000 CHAR),
    CELL_PER_CAR                         NUMBER,
    CELL_NAME                            VARCHAR2(4000 CHAR),
    FCST_TYPE                            VARCHAR2(4000 CHAR),
    DATA_SEQ                             NUMBER,
    INCOTERMS                            VARCHAR2(4000 CHAR),
    ITEM_USE                             VARCHAR2(4000 CHAR),
    MODEL_TYPE                           VARCHAR2(4000 CHAR),
    MODULE_PER_CAR                       NUMBER,
    PROJECT_NAME                         VARCHAR2(4000 CHAR),
    SOLDTO_COUNTRY                       VARCHAR2(4000 CHAR),
    SHIPTO_COUNTRY                       VARCHAR2(4000 CHAR),
    END_CUSTOMER                         VARCHAR2(4000 CHAR),
    CELL_MODEL                           VARCHAR2(4000 CHAR),
    CELL_MODEL_INFO                      VARCHAR2(4000 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DMF0049_TEMP_ITEM_SINGLE (9 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DMF0049_TEMP_ITEM_SINGLE (
    ITEM_ID                              VARCHAR2(4000 CHAR),
    ITEM_CLASS_NAME                      VARCHAR2(4000 CHAR),
    ENERGY                               NUMBER,
    CELL_QUANTITY                        NUMBER,
    FORECAST_INFO_BIZ_TYPE               VARCHAR2(4000 CHAR),
    FORECAST_INFO_SPEC                   VARCHAR2(4000 CHAR),
    NICK_NAME                            VARCHAR2(4000 CHAR),
    FORECAST_INFO_CELL_MODEL             VARCHAR2(4000 CHAR),
    FORECAST_INFO_CELL_PACK_COUNT        VARCHAR2(4000 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- ── GTT INDEX : 0 본 (사내 실측)
-- ⚠ **0행 축** — 본 화면 GTT 에는 인덱스가 하나도 없다 (사내 실측 0). 이관 대상 없음.

-- ── TYPE 축 : 0 본 (ALL_DEPENDENCIES 실측)
-- ⚠ **0행 축** — PKG_DMF0049 는 사용자 정의 TYPE 을 참조하지 않는다. 이관 대상 없음.