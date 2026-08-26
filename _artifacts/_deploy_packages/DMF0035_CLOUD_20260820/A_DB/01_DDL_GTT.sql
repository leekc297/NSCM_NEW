-- DMF0035_CLOUD_20260820 / A_DB/01_DDL_GTT.sql
-- GLOBAL TEMPORARY TABLE 자급 DDL — 기존재 가정 금지 (룰 #22 이관패키지 GTT/TYPE 자급 의무).
-- 축 확정 = ① PKG 4본 소스 grep(주석 제거 LIVE) ② ALL_DEPENDENCIES 양축 합집합 → 딕셔너리 교차.
--   grep 49종 / dep 49종 / 실존 GTT 49종.
-- ⚠ -955(기존재) 무시 방식의 맹점: 이름만 같고 컬럼 구조가 다른 구세대 GTT 가 남아 있으면
--    조용히 통과한 뒤 런타임 ORA-00904/00932 로 터진다. 적용 전 00_CLOUD_PRECHECK C2 의
--    컬럼 시그니처 대조를 반드시 수행할 것 (README §GTT 구조 diff 가이드).
-- 전 GTT DURATION = SYS$SESSION → ON COMMIT PRESERVE ROWS.

-- GT_DM22_CALENDAR (6 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM22_CALENDAR (
    BASIS_YYYYMMWW                         VARCHAR2(8 CHAR),
    ISO_YYYYWW                             VARCHAR2(8 CHAR),
    ISO_WEEK                               VARCHAR2(4 CHAR),
    BASIS_YYYYMMDD                         VARCHAR2(8 CHAR),
    END_FLAG                               VARCHAR2(1 CHAR),
    BASIS_YYYYMM                           VARCHAR2(6 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM22_DM_MST_ITEM_SINGLE_A_V (16 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_A_V (
    DIVISION_ID                            VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(150 CHAR),
    ITEM_NAME                              VARCHAR2(150 CHAR),
    NICK_NAME                              VARCHAR2(50 CHAR),
    ITEM_TYPE                              VARCHAR2(50 CHAR),
    ITEM_CLASS                             VARCHAR2(50 CHAR),
    ITEM_CLASS_NAME                        VARCHAR2(300 CHAR),
    MATERIAL_CLASS_NAME                    VARCHAR2(150 CHAR),
    ITEM_UOM                               VARCHAR2(10 CHAR),
    SPEC                                   VARCHAR2(200 CHAR),
    ACTIVE_FLAG                            VARCHAR2(1 CHAR),
    ENERGE                                 VARCHAR2(30 CHAR),
    MDM_PROJECT_NAME                       VARCHAR2(30 CHAR),
    MIN_CAPACITY                           VARCHAR2(30 CHAR),
    CELL_QUANTITY                          VARCHAR2(50 CHAR),
    SCP_EXTRA_SPEC                         VARCHAR2(150 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM22_DM_MST_ITEM_SINGLE_B_V (9 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_B_V (
    DIVISION_ID                            VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(150 CHAR),
    CELL_TYPE                              VARCHAR2(30 CHAR),
    FORECAST_INFO_BIZ_TYPE                 VARCHAR2(10 CHAR),
    FORECAST_INFO_PRODUCT_GROUP            VARCHAR2(10 CHAR),
    FORECAST_INFO_CELL_MODEL               VARCHAR2(20 CHAR),
    FORECAST_INFO_CELL_PACK_COUNT          NUMBER(20,10),
    FORECAST_INFO_SPEC                     VARCHAR2(30 CHAR),
    FORECAST_INFOR_VERSION                 VARCHAR2(10 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM22_DM_MST_ITEM_SINGLE_ORI_V (78 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_ORI_V (
    COMPANY_ID                             VARCHAR2(30 CHAR),
    DIVISION_ID                            VARCHAR2(30 CHAR),
    SITE_ID                                VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(150 CHAR),
    ITEM_NAME                              VARCHAR2(150 CHAR),
    NICK_NAME                              VARCHAR2(50 CHAR),
    ITEM_TYPE                              VARCHAR2(50 CHAR),
    ITEM_CLASS_LEVEL_1                     VARCHAR2(50 CHAR),
    ITEM_CLASS_LEVEL_2                     VARCHAR2(50 CHAR),
    ITEM_CLASS_LEVEL_3                     VARCHAR2(50 CHAR),
    ITEM_CLASS_LEVEL_4                     VARCHAR2(50 CHAR),
    ITEM_CLASS                             VARCHAR2(50 CHAR),
    ITEM_CLASS_NAME                        VARCHAR2(300 CHAR),
    MATERIAL_CLASS                         VARCHAR2(50 CHAR),
    MATERIAL_CLASS_NAME                    VARCHAR2(150 CHAR),
    ELECTRODE_TYPE                         VARCHAR2(20 CHAR),
    SIDE_TYPE                              VARCHAR2(20 CHAR),
    ITEM_GROUP_ID                          VARCHAR2(100 CHAR),
    SETUP_GROUP_ID_1                       VARCHAR2(100 CHAR),
    SETUP_GROUP_ID_2                       VARCHAR2(100 CHAR),
    SETUP_GROUP_ID_3                       VARCHAR2(100 CHAR),
    FLOW_ID                                VARCHAR2(150 CHAR),
    ERP_EOL                                VARCHAR2(50 CHAR),
    SCP_EOL                                VARCHAR2(50 CHAR),
    ITEM_UOM                               VARCHAR2(10 CHAR),
    SPEC                                   VARCHAR2(200 CHAR),
    DEMAND_LOT_SIZE                        NUMBER(20,10),
    ITEM_ATTRIBUTE                         VARCHAR2(150 CHAR),
    SETUP_ATTRIBUTE                        VARCHAR2(150 CHAR),
    BATCH_RATIO_ID                         VARCHAR2(150 CHAR),
    OUTSOURCING_FACTORY                    VARCHAR2(30 CHAR),
    FINITE_TERM                            NUMBER(20,10),
    FINITE_TERM_UOM                        VARCHAR2(10 CHAR),
    COATED_LENGTH                          NUMBER(20,10),
    UNCOATED_LENGTH                        NUMBER(20,10),
    LENGTH_UOM                             VARCHAR2(10 CHAR),
    SLURRY_LOSS_RATE                       NUMBER(20,10),
    DESCRIPTION                            VARCHAR2(200 CHAR),
    ACTIVE_FLAG                            VARCHAR2(1 CHAR),
    INSERT_ID                              VARCHAR2(150 CHAR),
    INSERT_TIME                            DATE,
    UPDATE_ID                              VARCHAR2(150 CHAR),
    UPDATE_TIME                            DATE,
    APPLIED_MODEL                          VARCHAR2(150 CHAR),
    CELL_TYPE                              VARCHAR2(30 CHAR),
    MAKE_AND_BUY                           VARCHAR2(10 CHAR),
    COLOR_ATTRIBUTE                        VARCHAR2(150 CHAR),
    FORMATION_FLOW_ID                      VARCHAR2(150 CHAR),
    STANDARD_COST                          NUMBER(20,5),
    CURRENCY                               VARCHAR2(10 CHAR),
    FORM_ATTRIBUTE                         VARCHAR2(150 CHAR),
    ENERGE                                 VARCHAR2(30 CHAR),
    SCP_FLOW_ID                            VARCHAR2(150 CHAR),
    SCP_OPERATION_GROUP                    VARCHAR2(2 CHAR),
    SCP_OPERATION_GROUP_ID                 VARCHAR2(2 CHAR),
    MDM_PROJECT_NAME                       VARCHAR2(30 CHAR),
    MIN_CAPACITY                           VARCHAR2(30 CHAR),
    MOBILE_MODEL_ID                        VARCHAR2(20 CHAR),
    FORECAST_INFO_BIZ_TYPE                 VARCHAR2(10 CHAR),
    FORECAST_INFO_PRODUCT_GROUP            VARCHAR2(10 CHAR),
    FORECAST_INFO_CELL_MODEL               VARCHAR2(20 CHAR),
    FORECAST_INFO_CELL_PACK_COUNT          NUMBER(20,10),
    FORECAST_INFO_SPEC                     VARCHAR2(30 CHAR),
    FORECAST_INFOR_VERSION                 VARCHAR2(10 CHAR),
    DOE                                    VARCHAR2(150 CHAR),
    INSULATION_COATING                     VARCHAR2(1 CHAR),
    PACK_PRODUCT_GROUP_CODE                VARCHAR2(200 CHAR),
    CELL_QUANTITY                          VARCHAR2(50 CHAR),
    SCP_EXTRA_SPEC                         VARCHAR2(150 CHAR),
    SCM_PIC                                VARCHAR2(150 CHAR),
    REP_CUSTOMER                           VARCHAR2(150 CHAR),
    MAKER                                  VARCHAR2(30 CHAR),
    EVAL_CLASS                             VARCHAR2(4 CHAR),
    EVAL_CLASS_INFO                        VARCHAR2(25 CHAR),
    FP_EXTRA_SPEC                          VARCHAR2(150 CHAR),
    MRP_USE_FLAG                           VARCHAR2(1 CHAR),
    ITEM_RAW_PLANT_ID                      VARCHAR2(30 CHAR),
    ITEM_COPY_YN                           VARCHAR2(1 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM22_DM_MST_ITEM_SINGLE_V (24 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V (
    DIVISION_ID                            VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(150 CHAR),
    ITEM_NAME                              VARCHAR2(150 CHAR),
    NICK_NAME                              VARCHAR2(50 CHAR),
    ITEM_TYPE                              VARCHAR2(50 CHAR),
    ITEM_CLASS                             VARCHAR2(50 CHAR),
    ITEM_CLASS_NAME                        VARCHAR2(300 CHAR),
    MATERIAL_CLASS_NAME                    VARCHAR2(150 CHAR),
    ITEM_UOM                               VARCHAR2(10 CHAR),
    SPEC                                   VARCHAR2(200 CHAR),
    ACTIVE_FLAG                            VARCHAR2(1 CHAR),
    CELL_TYPE                              VARCHAR2(30 CHAR),
    ENERGE                                 VARCHAR2(30 CHAR),
    ENERGE_WH                              VARCHAR2(30 CHAR),
    MDM_PROJECT_NAME                       VARCHAR2(30 CHAR),
    MIN_CAPACITY                           VARCHAR2(30 CHAR),
    FORECAST_INFO_BIZ_TYPE                 VARCHAR2(10 CHAR),
    FORECAST_INFO_PRODUCT_GROUP            VARCHAR2(10 CHAR),
    FORECAST_INFO_CELL_MODEL               VARCHAR2(20 CHAR),
    FORECAST_INFO_CELL_PACK_COUNT          NUMBER(20,10),
    FORECAST_INFO_SPEC                     VARCHAR2(30 CHAR),
    FORECAST_INFOR_VERSION                 VARCHAR2(10 CHAR),
    CELL_QUANTITY                          VARCHAR2(50 CHAR),
    SCP_EXTRA_SPEC                         VARCHAR2(150 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM22_DM_MST_ITEM_SINGLE_V_T (26 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V_T (
    DIVISION_ID                            VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(150 CHAR),
    ITEM_NAME                              VARCHAR2(150 CHAR),
    NICK_NAME                              VARCHAR2(50 CHAR),
    ITEM_TYPE                              VARCHAR2(50 CHAR),
    ITEM_CLASS                             VARCHAR2(50 CHAR),
    ITEM_CLASS_NAME                        VARCHAR2(300 CHAR),
    MATERIAL_CLASS_NAME                    VARCHAR2(150 CHAR),
    ITEM_UOM                               VARCHAR2(10 CHAR),
    SPEC                                   VARCHAR2(200 CHAR),
    ACTIVE_FLAG                            VARCHAR2(1 CHAR),
    CELL_TYPE                              VARCHAR2(30 CHAR),
    ENERGE                                 VARCHAR2(30 CHAR),
    ENERGE_WH                              VARCHAR2(30 CHAR),
    MDM_PROJECT_NAME                       VARCHAR2(30 CHAR),
    MIN_CAPACITY                           VARCHAR2(30 CHAR),
    FORECAST_INFO_BIZ_TYPE                 VARCHAR2(10 CHAR),
    FORECAST_INFO_PRODUCT_GROUP            VARCHAR2(10 CHAR),
    FORECAST_INFO_CELL_MODEL               VARCHAR2(20 CHAR),
    FORECAST_INFO_CELL_PACK_COUNT          NUMBER(20,10),
    FORECAST_INFO_SPEC                     VARCHAR2(30 CHAR),
    FORECAST_INFOR_VERSION                 VARCHAR2(10 CHAR),
    CELL_QUANTITY                          VARCHAR2(50 CHAR),
    SCP_EXTRA_SPEC                         VARCHAR2(150 CHAR),
    SEGMENT2                               VARCHAR2(4000 CHAR),
    CELL_MODEL_NICK_NAME                   VARCHAR2(4000 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM22_PROGRAM_ADD_MEASURE (4 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM22_PROGRAM_ADD_MEASURE (
    UI_MEASURE                             VARCHAR2(50 CHAR),
    DB_MEASURE                             VARCHAR2(50 CHAR),
    PLAN_RESULT                            VARCHAR2(1 CHAR),
    SYSTEM_ADD                             VARCHAR2(1 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM22_RAW_DATA (20 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM22_RAW_DATA (
    VERSION_NO                             VARCHAR2(50 CHAR),
    CUTOFF_YYYYMMDD                        VARCHAR2(8 CHAR),
    DIVISION_ID                            VARCHAR2(30 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    SCM_SITE_ID                            VARCHAR2(30 CHAR),
    PLANT_SITE_ID                          VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    TEXT                                   VARCHAR2(4000 CHAR),
    INCOTERMS                              VARCHAR2(10 CHAR),
    DOM_EXP                                VARCHAR2(3 CHAR),
    FCST_TYPE                              VARCHAR2(20 CHAR),
    CURRENCY                               VARCHAR2(3 CHAR),
    COMPANY_ID                             VARCHAR2(30 CHAR),
    MEASURE                                VARCHAR2(50 CHAR),
    YYYYMMDD                               VARCHAR2(8 CHAR),
    QTY                                    NUMBER(30,10),
    VALID_YN                               VARCHAR2(1 CHAR),
    PLAN_RESULT                            VARCHAR2(1 CHAR),
    ATTRIBUTE1                             VARCHAR2(150 CHAR),
    CELL_PROD_SITE_ID                      VARCHAR2(60 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM22_RAW_DATA_TEMP40 (19 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM22_RAW_DATA_TEMP40 (
    VERSION_NO                             VARCHAR2(50 CHAR),
    CUTOFF_YYYYMMDD                        VARCHAR2(8 CHAR),
    DIVISION_ID                            VARCHAR2(30 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    SCM_SITE_ID                            VARCHAR2(30 CHAR),
    PLANT_SITE_ID                          VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    TEXT                                   VARCHAR2(4000 CHAR),
    INCOTERMS                              VARCHAR2(10 CHAR),
    DOM_EXP                                VARCHAR2(3 CHAR),
    FCST_TYPE                              VARCHAR2(20 CHAR),
    CURRENCY                               VARCHAR2(3 CHAR),
    COMPANY_ID                             VARCHAR2(30 CHAR),
    MEASURE                                VARCHAR2(50 CHAR),
    YYYYMMDD                               VARCHAR2(8 CHAR),
    QTY                                    NUMBER(30,10),
    VALID_YN                               VARCHAR2(1 CHAR),
    PLAN_RESULT                            VARCHAR2(1 CHAR),
    CELL_PROD_SITE_ID                      VARCHAR2(60 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM22_RAW_DATA_TEMP40_KEY (16 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM22_RAW_DATA_TEMP40_KEY (
    VERSION_NO                             VARCHAR2(50 CHAR),
    CUTOFF_YYYYMMDD                        VARCHAR2(8 CHAR),
    DIVISION_ID                            VARCHAR2(30 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    SCM_SITE_ID                            VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    TEXT                                   VARCHAR2(4000 CHAR),
    INCOTERMS                              VARCHAR2(10 CHAR),
    DOM_EXP                                VARCHAR2(3 CHAR),
    FCST_TYPE                              VARCHAR2(20 CHAR),
    CURRENCY                               VARCHAR2(3 CHAR),
    COMPANY_ID                             VARCHAR2(30 CHAR),
    MEASURE                                VARCHAR2(50 CHAR),
    VALID_YN                               VARCHAR2(1 CHAR),
    PLAN_RESULT                            VARCHAR2(1 CHAR),
    CELL_PROD_SITE_ID                      VARCHAR2(60 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM22_RTF_ENERGY (20 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM22_RTF_ENERGY (
    VERSION_NO                             VARCHAR2(50 CHAR),
    CUTOFF_YYYYMMDD                        VARCHAR2(8 CHAR),
    DIVISION_ID                            VARCHAR2(30 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    SCM_SITE_ID                            VARCHAR2(30 CHAR),
    PLANT_SITE_ID                          VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    TEXT                                   VARCHAR2(4000 CHAR),
    INCOTERMS                              VARCHAR2(10 CHAR),
    DOM_EXP                                VARCHAR2(3 CHAR),
    FCST_TYPE                              VARCHAR2(20 CHAR),
    CURRENCY                               VARCHAR2(3 CHAR),
    COMPANY_ID                             VARCHAR2(30 CHAR),
    MEASURE                                VARCHAR2(50 CHAR),
    YYYYMMDD                               VARCHAR2(8 CHAR),
    QTY                                    NUMBER(30,10),
    VALID_YN                               VARCHAR2(1 CHAR),
    PLAN_RESULT                            VARCHAR2(1 CHAR),
    ATTRIBUTE1                             VARCHAR2(150 CHAR),
    CELL_PROD_SITE_ID                      VARCHAR2(60 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM22_SCM_MST_SHEET_MEASURE (5 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM22_SCM_MST_SHEET_MEASURE (
    USER_ID                                VARCHAR2(4000 CHAR),
    MEASURE                                VARCHAR2(50 CHAR),
    SORT_ORDER_NO                          NUMBER,
    SYSTEM_ADD                             VARCHAR2(1 CHAR),
    DIVISION_ID                            VARCHAR2(4000 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM22_SCM_MST_SITE (12 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM22_SCM_MST_SITE (
    SCM_SITE_ID                            VARCHAR2(30 CHAR),
    DIVISION_ID                            VARCHAR2(30 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    DEPT_ID                                VARCHAR2(4000 CHAR),
    SOLDTO_CODE                            VARCHAR2(4000 CHAR),
    VMI_YN                                 VARCHAR2(1 CHAR),
    END_CUSTOMER                           VARCHAR2(4000 CHAR),
    CITY_NAME                              VARCHAR2(4000 CHAR),
    COUNTRY_NAME                           VARCHAR2(4000 CHAR),
    SHIPTO_DESCRIPTION                     VARCHAR2(4000 CHAR),
    SOLDTO_DESCRIPTION                     VARCHAR2(4000 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM22_SCM_MST_SITE_ITEM (23 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM22_SCM_MST_SITE_ITEM (
    DIVISION_ID                            VARCHAR2(4000 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    SCM_SITE_ID                            VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    APPLICATION                            VARCHAR2(4000 CHAR),
    CUST_GROUP                             VARCHAR2(4000 CHAR),
    ROUTE                                  VARCHAR2(4000 CHAR),
    CUST_GROUP_DTL                         VARCHAR2(4000 CHAR),
    CELL_PER_CAR                           NUMBER,
    CELL_PER_MODULE                        NUMBER,
    SALES_COMPANY                          VARCHAR2(4000 CHAR),
    CURRENCY                               VARCHAR2(4000 CHAR),
    ATTRIBUTE1                             VARCHAR2(4000 CHAR),
    ATTRIBUTE2                             VARCHAR2(4000 CHAR),
    ATTRIBUTE5                             VARCHAR2(4000 CHAR),
    ATTRIBUTE7                             VARCHAR2(4000 CHAR),
    ATTRIBUTE8                             VARCHAR2(4000 CHAR),
    REPORT_GROUP6                          VARCHAR2(4000 CHAR),
    OWNER                                  VARCHAR2(4000 CHAR),
    OWNER_NAME                             VARCHAR2(4000 CHAR),
    OWNER_NAME_KO                          VARCHAR2(4000 CHAR),
    DEPT_ID                                VARCHAR2(4000 CHAR),
    VALID_YN                               VARCHAR2(1 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM22_SELECT_MEASURE (3 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM22_SELECT_MEASURE (
    MEASURE                                VARCHAR2(50 CHAR),
    SORT_ORDER_NO                          NUMBER,
    SYSTEM_ADD                             VARCHAR2(1 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM22_T (2 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM22_T (
    COLUMN_STRING                          VARCHAR2(1000 CHAR),
    SEQ                                    NUMBER
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM22_T_COLUMN_SETUP (4 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM22_T_COLUMN_SETUP (
    TBL_ALIAS                              VARCHAR2(10 CHAR),
    COLUMN_NAME                            VARCHAR2(100 CHAR),
    COLUMN_STRING                          VARCHAR2(1000 CHAR),
    SORT_KEY                               NUMBER
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM22_T_PRICE (14 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM22_T_PRICE (
    DIVISION_ID                            VARCHAR2(30 CHAR),
    VERSION_NO                             VARCHAR2(50 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    SCM_SITE_ID                            VARCHAR2(30 CHAR),
    PLANT_SITE_ID                          VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    YYYYMMDD                               VARCHAR2(8 CHAR),
    CURRENCY                               VARCHAR2(10 CHAR),
    MEASURE                                VARCHAR2(50 CHAR),
    DOM_EXP                                VARCHAR2(3 CHAR),
    FCST_TYPE                              VARCHAR2(20 CHAR),
    INCOTERMS                              VARCHAR2(10 CHAR),
    PRICE                                  NUMBER(30,10),
    CELL_PROD_SITE_ID                      VARCHAR2(60 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM22_V_VERSION_NO (2 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM22_V_VERSION_NO (
    VERSION_NO                             VARCHAR2(100 CHAR),
    TOBE_VERSION_NO                        VARCHAR2(100 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_CALENDAR (6 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_CALENDAR (
    BASIS_YYYYMMWW                         VARCHAR2(20 CHAR),
    ISO_YYYYWW                             VARCHAR2(20 CHAR),
    ISO_WEEK                               VARCHAR2(10 CHAR),
    BASIS_YYYYMMDD                         VARCHAR2(8 CHAR),
    END_FLAG                               VARCHAR2(10 CHAR),
    BASIS_YYYYMM                           VARCHAR2(6 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_CAL_MONTH_END (1 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_CAL_MONTH_END (
    MONTH_END_DATE                         VARCHAR2(8 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_CAL_WEEK_END (1 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_CAL_WEEK_END (
    WEEK_END_DATE                          VARCHAR2(8 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_DM_PLN_MKT (17 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_DM_PLN_MKT (
    DIVISION_ID                            VARCHAR2(30 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    SCM_SITE_ID                            VARCHAR2(100 CHAR),
    PLANT_SITE_ID                          VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    DOM_EXP                                VARCHAR2(3 CHAR),
    FCST_TYPE                              VARCHAR2(20 CHAR),
    INCOTERMS                              VARCHAR2(10 CHAR),
    MEASURE                                VARCHAR2(50 CHAR),
    YYYYMMDD                               VARCHAR2(8 CHAR),
    QTY                                    NUMBER(30,10),
    ATTRIBUTE10                            VARCHAR2(300 CHAR),
    CELL_PROD_SITE_ID                      VARCHAR2(30 CHAR),
    LAST_UPDATED_BY                        VARCHAR2(300 CHAR),
    ATTRIBUTE4                             VARCHAR2(300 CHAR),
    ATTRIBUTE5                             VARCHAR2(300 CHAR),
    MEASURE_GROUP                          VARCHAR2(50 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_EDI_END_CUST (8 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_EDI_END_CUST (
    DIVISION_ID                            VARCHAR2(10 CHAR),
    END_CUSTOMER                           VARCHAR2(100 CHAR),
    SCM_SITE_ID                            VARCHAR2(100 CHAR),
    FROM_WEEK                              NUMBER(10,0),
    FROM_DAY                               VARCHAR2(30 CHAR),
    TO_WEEK                                NUMBER(10,0),
    TO_DAY                                 VARCHAR2(30 CHAR),
    ACTIVE                                 VARCHAR2(30 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_EDI_SENDER (3 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_EDI_SENDER (
    SCM_SITE_ID                            VARCHAR2(100 CHAR),
    SENDER_CODE                            VARCHAR2(30 CHAR),
    SENDER_NAME                            VARCHAR2(200 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_ITEM_SINGLE_A (16 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_ITEM_SINGLE_A (
    DIVISION_ID                            VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    ITEM_NAME                              VARCHAR2(300 CHAR),
    ITEM_CLASS                             VARCHAR2(100 CHAR),
    ITEM_CLASS_NAME                        VARCHAR2(300 CHAR),
    NICK_NAME                              VARCHAR2(300 CHAR),
    ITEM_TYPE                              VARCHAR2(10 CHAR),
    MATERIAL_CLASS_NAME                    VARCHAR2(300 CHAR),
    ITEM_UOM                               VARCHAR2(30 CHAR),
    SPEC                                   VARCHAR2(300 CHAR),
    MDM_PROJECT_NAME                       VARCHAR2(300 CHAR),
    MIN_CAPACITY                           VARCHAR2(30 CHAR),
    ACTIVE_FLAG                            VARCHAR2(1 CHAR),
    ENERGE                                 VARCHAR2(100 CHAR),
    CELL_QUANTITY                          NUMBER,
    SCP_EXTRA_SPEC                         VARCHAR2(300 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_ITEM_SINGLE_B (9 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_ITEM_SINGLE_B (
    DIVISION_ID                            VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    FORECAST_INFO_BIZ_TYPE                 VARCHAR2(300 CHAR),
    FORECAST_INFO_PRODUCT_GROUP            VARCHAR2(300 CHAR),
    FORECAST_INFO_CELL_MODEL               VARCHAR2(300 CHAR),
    FORECAST_INFO_CELL_PACK_COUNT          NUMBER,
    FORECAST_INFO_SPEC                     VARCHAR2(300 CHAR),
    FORECAST_INFOR_VERSION                 VARCHAR2(300 CHAR),
    CELL_TYPE                              VARCHAR2(100 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_ITEM_SINGLE_ORI (34 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_ITEM_SINGLE_ORI (
    DIVISION_ID                            VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    ITEM_NAME                              VARCHAR2(300 CHAR),
    ITEM_CLASS                             VARCHAR2(100 CHAR),
    ITEM_CLASS_NAME                        VARCHAR2(300 CHAR),
    NICK_NAME                              VARCHAR2(300 CHAR),
    ITEM_TYPE                              VARCHAR2(50 CHAR),
    MATERIAL_CLASS_NAME                    VARCHAR2(300 CHAR),
    ITEM_UOM                               VARCHAR2(30 CHAR),
    SPEC                                   VARCHAR2(300 CHAR),
    MDM_PROJECT_NAME                       VARCHAR2(300 CHAR),
    MIN_CAPACITY                           VARCHAR2(30 CHAR),
    ACTIVE_FLAG                            VARCHAR2(1 CHAR),
    ENERGE                                 VARCHAR2(100 CHAR),
    CELL_QUANTITY                          NUMBER,
    SCP_EXTRA_SPEC                         VARCHAR2(300 CHAR),
    FORECAST_INFO_BIZ_TYPE                 VARCHAR2(300 CHAR),
    FORECAST_INFO_PRODUCT_GROUP            VARCHAR2(300 CHAR),
    FORECAST_INFO_CELL_MODEL               VARCHAR2(300 CHAR),
    FORECAST_INFO_CELL_PACK_COUNT          NUMBER,
    FORECAST_INFO_SPEC                     VARCHAR2(300 CHAR),
    FORECAST_INFOR_VERSION                 VARCHAR2(300 CHAR),
    CELL_TYPE                              VARCHAR2(100 CHAR),
    DOE                                    VARCHAR2(100 CHAR),
    ATTRIBUTE1                             VARCHAR2(300 CHAR),
    OPERATION_GROUP                        VARCHAR2(30 CHAR),
    FLOW_ID                                VARCHAR2(30 CHAR),
    LEVEL2_CODE                            VARCHAR2(300 CHAR),
    GROUP_CODE1                            VARCHAR2(300 CHAR),
    GROUP_CODE4                            VARCHAR2(300 CHAR),
    GROUP_CODE5                            VARCHAR2(300 CHAR),
    GROUP_CODE6                            VARCHAR2(300 CHAR),
    GROUP_CODE7                            VARCHAR2(300 CHAR),
    ATTRIBUTE8                             VARCHAR2(300 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_ITEM_SINGLE_V (23 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_ITEM_SINGLE_V (
    DIVISION_ID                            VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    ITEM_NAME                              VARCHAR2(300 CHAR),
    ITEM_CLASS                             VARCHAR2(100 CHAR),
    ITEM_CLASS_NAME                        VARCHAR2(300 CHAR),
    NICK_NAME                              VARCHAR2(300 CHAR),
    ITEM_TYPE                              VARCHAR2(50 CHAR),
    MATERIAL_CLASS_NAME                    VARCHAR2(300 CHAR),
    ITEM_UOM                               VARCHAR2(30 CHAR),
    SPEC                                   VARCHAR2(300 CHAR),
    MDM_PROJECT_NAME                       VARCHAR2(300 CHAR),
    MIN_CAPACITY                           VARCHAR2(30 CHAR),
    FORECAST_INFO_BIZ_TYPE                 VARCHAR2(300 CHAR),
    FORECAST_INFO_PRODUCT_GROUP            VARCHAR2(300 CHAR),
    FORECAST_INFO_CELL_MODEL               VARCHAR2(300 CHAR),
    FORECAST_INFO_CELL_PACK_COUNT          NUMBER,
    FORECAST_INFO_SPEC                     VARCHAR2(300 CHAR),
    FORECAST_INFOR_VERSION                 VARCHAR2(300 CHAR),
    ACTIVE_FLAG                            VARCHAR2(1 CHAR),
    CELL_TYPE                              VARCHAR2(100 CHAR),
    ENERGE                                 VARCHAR2(100 CHAR),
    CELL_QUANTITY                          NUMBER,
    SCP_EXTRA_SPEC                         VARCHAR2(300 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_RAW_DATA (23 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_RAW_DATA (
    VERSION_NO                             VARCHAR2(50 CHAR),
    CUTOFF_YYYYMMDD                        CHAR(8),
    DIVISION_ID                            VARCHAR2(30 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    SCM_SITE_ID                            VARCHAR2(100 CHAR),
    PLANT_SITE_ID                          VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    INCOTERMS                              VARCHAR2(10 CHAR),
    DOM_EXP                                VARCHAR2(3 CHAR),
    FCST_TYPE                              VARCHAR2(20 CHAR),
    MEASURE                                VARCHAR2(50 CHAR),
    MEASURE_GROUP                          VARCHAR2(50 CHAR),
    YYYYMMDD                               VARCHAR2(8 CHAR),
    QTY                                    NUMBER(30,10),
    VALID_YN                               VARCHAR2(1 CHAR),
    PLAN_RESULT                            VARCHAR2(1 CHAR),
    GUBUN                                  NUMBER(3,0),
    CREATE_DATE                            VARCHAR2(8 CHAR),
    LAST_UPDATED_BY                        VARCHAR2(300 CHAR),
    SENDER_CODE                            VARCHAR2(30 CHAR),
    SENDER_NAME                            VARCHAR2(200 CHAR),
    AS_FROM_SITE                           VARCHAR2(300 CHAR),
    CELL_PROD_SITE_ID                      VARCHAR2(30 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_RAW_DATA_FINAL (28 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_RAW_DATA_FINAL (
    VERSION_NO                             VARCHAR2(50 CHAR),
    CUTOFF_YYYYMMDD                        VARCHAR2(8 CHAR),
    DIVISION_ID                            VARCHAR2(30 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    SCM_SITE_ID                            VARCHAR2(100 CHAR),
    PLANT_SITE_ID                          VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    INCOTERMS                              VARCHAR2(10 CHAR),
    DOM_EXP                                VARCHAR2(3 CHAR),
    FCST_TYPE                              VARCHAR2(20 CHAR),
    MEASURE                                VARCHAR2(50 CHAR),
    MEASURE_GROUP                          VARCHAR2(50 CHAR),
    YYYYMMDD                               VARCHAR2(8 CHAR),
    QTY                                    NUMBER(30,10),
    VALID_YN                               VARCHAR2(1 CHAR),
    PLAN_RESULT                            VARCHAR2(1 CHAR),
    GUBUN                                  NUMBER(3,0),
    CREATE_DATE                            VARCHAR2(8 CHAR),
    LAST_UPDATED_BY                        VARCHAR2(300 CHAR),
    SENDER_CODE                            VARCHAR2(30 CHAR),
    SENDER_NAME                            VARCHAR2(200 CHAR),
    AS_FROM_SITE                           VARCHAR2(300 CHAR),
    CELL_NICKNAME                          VARCHAR2(300 CHAR),
    PRODUCT_LEVEL1                         VARCHAR2(300 CHAR),
    PRODUCT_LEVEL2                         VARCHAR2(300 CHAR),
    PRODUCT_LEVEL3                         VARCHAR2(300 CHAR),
    NOTATION                               VARCHAR2(8 CHAR),
    CELL_PROD_SITE_ID                      VARCHAR2(30 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_RPA_END_CUST (8 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_RPA_END_CUST (
    DIVISION_ID                            VARCHAR2(10 CHAR),
    END_CUSTOMER                           VARCHAR2(100 CHAR),
    SCM_SITE_ID                            VARCHAR2(100 CHAR),
    FROM_WEEK                              NUMBER(10,0),
    FROM_DAY                               VARCHAR2(30 CHAR),
    TO_WEEK                                NUMBER(10,0),
    TO_DAY                                 VARCHAR2(30 CHAR),
    ACTIVE                                 VARCHAR2(30 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_SCP_ITEM_INFO (11 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_SCP_ITEM_INFO (
    DIVISION_ID                            VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    CELL_NICKNAME                          VARCHAR2(300 CHAR),
    BASIC_NICKNAME_CELL40                  VARCHAR2(300 CHAR),
    NICKNAME_40                            VARCHAR2(300 CHAR),
    GROUP_CODE1                            VARCHAR2(300 CHAR),
    GROUP_CODE4                            VARCHAR2(300 CHAR),
    GROUP_CODE5                            VARCHAR2(300 CHAR),
    GROUP_CODE6                            VARCHAR2(300 CHAR),
    GROUP_CODE7                            VARCHAR2(300 CHAR),
    CELL_TYPE_GROUP_NAME                   VARCHAR2(300 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_SEL_MEASURE (7 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_SEL_MEASURE (
    PROGRAM_ID                             VARCHAR2(50 CHAR),
    SHEET_NAME                             VARCHAR2(100 CHAR),
    USER_ID                                VARCHAR2(100 CHAR),
    MEASURE_GROUP                          VARCHAR2(100 CHAR),
    MEASURE                                VARCHAR2(100 CHAR),
    SORT_ORDER_NO                          NUMBER,
    SYSTEM_ADD                             VARCHAR2(1 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_SITE_ITEM (26 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_SITE_ITEM (
    DIVISION_ID                            VARCHAR2(30 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    SCM_SITE_ID                            VARCHAR2(100 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    VALID_YN                               VARCHAR2(1 CHAR),
    CELL_PER_CAR                           NUMBER,
    CELL_PER_MODULE                        NUMBER,
    VMI_YN                                 VARCHAR2(1 CHAR),
    OWNER                                  VARCHAR2(200 CHAR),
    OWNER_NAME                             VARCHAR2(200 CHAR),
    OWNER_NAME_KO                          VARCHAR2(200 CHAR),
    DEPT_ID                                VARCHAR2(100 CHAR),
    ATTRIBUTE1                             VARCHAR2(300 CHAR),
    ATTRIBUTE2                             VARCHAR2(300 CHAR),
    ATTRIBUTE5                             VARCHAR2(300 CHAR),
    ATTRIBUTE7                             VARCHAR2(300 CHAR),
    ATTRIBUTE8                             VARCHAR2(300 CHAR),
    CUST_GROUP                             VARCHAR2(100 CHAR),
    CUST_GROUP_DTL                         VARCHAR2(100 CHAR),
    APPLICATION                            VARCHAR2(300 CHAR),
    ROUTE                                  VARCHAR2(300 CHAR),
    REPORT_GROUP6                          VARCHAR2(300 CHAR),
    SALES_COMPANY                          VARCHAR2(300 CHAR),
    SOLDTO_CODE                            VARCHAR2(100 CHAR),
    SOLDTO_CUSTOMER                        VARCHAR2(300 CHAR),
    PROJECT_S_OP_REPORT                    VARCHAR2(300 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_T (2 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_T (
    COLUMN_STRING                          VARCHAR2(1000 CHAR),
    SEQ                                    NUMBER(10,0)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_TEMP_SCM_SITE (13 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_TEMP_SCM_SITE (
    SCM_SITE_ID                            VARCHAR2(100 CHAR),
    DIVISION_ID                            VARCHAR2(30 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    DEPT_ID                                VARCHAR2(50 CHAR),
    SOLDTO_CODE                            VARCHAR2(100 CHAR),
    VMI_YN                                 VARCHAR2(1 CHAR),
    END_CUSTOMER                           VARCHAR2(300 CHAR),
    SOLDTO_CUSTOMER                        VARCHAR2(300 CHAR),
    CITY_NAME                              VARCHAR2(300 CHAR),
    COUNTRY_NAME                           VARCHAR2(300 CHAR),
    SHIPTO_DESCRIPTION                     VARCHAR2(300 CHAR),
    SOLDTO_DESCRIPTION                     VARCHAR2(300 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_TEMP_VMI_INV (12 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_TEMP_VMI_INV (
    DIVISION_ID                            VARCHAR2(30 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    SCM_SITE_ID                            VARCHAR2(100 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    DOM_EXP                                VARCHAR2(3 CHAR),
    FCST_TYPE                              VARCHAR2(20 CHAR),
    INCOTERMS                              VARCHAR2(10 CHAR),
    MEASURE                                VARCHAR2(50 CHAR),
    YYYYMMDD                               VARCHAR2(8 CHAR),
    PLANT_SITE_ID                          VARCHAR2(30 CHAR),
    QTY                                    NUMBER(30,10),
    CELL_PROD_SITE_ID                      VARCHAR2(30 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_T_COLUMN_SETUP (4 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_T_COLUMN_SETUP (
    TBL_ALIAS                              VARCHAR2(10 CHAR),
    COLUMN_NAME                            VARCHAR2(100 CHAR),
    COLUMN_STRING                          VARCHAR2(1000 CHAR),
    SORT_KEY                               NUMBER(10,0)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_T_LAST_SETUP (10 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_T_LAST_SETUP (
    DIVISION_ID                            VARCHAR2(30 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    SCM_SITE_ID                            VARCHAR2(100 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    DOM_EXP                                VARCHAR2(3 CHAR),
    FCST_TYPE                              VARCHAR2(20 CHAR),
    INCOTERMS                              VARCHAR2(10 CHAR),
    MEASURE                                VARCHAR2(50 CHAR),
    CREATE_DATE                            VARCHAR2(8 CHAR),
    LAST_UPDATED_BY                        VARCHAR2(300 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_T_LAST_SETUP_C (11 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_T_LAST_SETUP_C (
    VERSION_NO                             VARCHAR2(100 CHAR),
    DIVISION_ID                            VARCHAR2(30 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    SCM_SITE_ID                            VARCHAR2(100 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    DOM_EXP                                VARCHAR2(3 CHAR),
    FCST_TYPE                              VARCHAR2(20 CHAR),
    INCOTERMS                              VARCHAR2(10 CHAR),
    MEASURE                                VARCHAR2(50 CHAR),
    CREATE_DATE                            VARCHAR2(8 CHAR),
    LAST_UPDATED_BY                        VARCHAR2(300 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_VERSION (3 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_VERSION (
    VERSION_NO                             VARCHAR2(50 CHAR),
    VERSION_NO_W                           VARCHAR2(50 CHAR),
    NOW_YYYYMMDD                           VARCHAR2(8 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM35_VMI_INV_RESULT (28 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM35_VMI_INV_RESULT (
    VERSION_NO                             VARCHAR2(50 CHAR),
    CUTOFF_YYYYMMDD                        CHAR(8),
    DIVISION_ID                            VARCHAR2(30 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    SCM_SITE_ID                            VARCHAR2(100 CHAR),
    PLANT_SITE_ID                          VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    INCOTERMS                              VARCHAR2(10 CHAR),
    DOM_EXP                                VARCHAR2(3 CHAR),
    FCST_TYPE                              VARCHAR2(20 CHAR),
    MEASURE                                VARCHAR2(50 CHAR),
    MEASURE_GROUP                          VARCHAR2(50 CHAR),
    YYYYMMDD                               VARCHAR2(8 CHAR),
    QTY                                    NUMBER(30,10),
    VALID_YN                               VARCHAR2(1 CHAR),
    PLAN_RESULT                            VARCHAR2(1 CHAR),
    GUBUN                                  NUMBER(3,0),
    CREATE_DATE                            VARCHAR2(8 CHAR),
    LAST_UPDATED_BY                        VARCHAR2(300 CHAR),
    SENDER_CODE                            VARCHAR2(30 CHAR),
    SENDER_NAME                            VARCHAR2(200 CHAR),
    AS_FROM_SITE                           VARCHAR2(300 CHAR),
    CELL_NICKNAME                          VARCHAR2(300 CHAR),
    PRODUCT_LEVEL1                         VARCHAR2(300 CHAR),
    PRODUCT_LEVEL2                         VARCHAR2(300 CHAR),
    PRODUCT_LEVEL3                         VARCHAR2(300 CHAR),
    NOTATION                               VARCHAR2(8 CHAR),
    CELL_PROD_SITE_ID                      VARCHAR2(30 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM51_RAW_DATA (25 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM51_RAW_DATA (
    VERSION_NO                             VARCHAR2(30 CHAR),
    CUTOFF_YYYYMMDD                        CHAR(8 CHAR),
    DIVISION_ID                            VARCHAR2(30 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    SCM_SITE_ID                            VARCHAR2(30 CHAR),
    PLANT_SITE_ID                          VARCHAR2(30 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    INCOTERMS                              VARCHAR2(10 CHAR),
    CELL_PROD_SITE                         VARCHAR2(30 CHAR),
    FCST_TYPE                              VARCHAR2(20 CHAR),
    CURRENCY                               VARCHAR2(10 CHAR),
    COMPANY_ID                             VARCHAR2(30 CHAR),
    MEASURE                                VARCHAR2(50 CHAR),
    YYYYMM                                 CHAR(6 CHAR),
    CAL_YYYYQQ                             VARCHAR2(6 CHAR),
    CAL_YYYY                               VARCHAR2(4 CHAR),
    QTY                                    NUMBER(30,10),
    VALID_YN                               CHAR(1 CHAR),
    COLNAME                                VARCHAR2(30 CHAR),
    DEPT_ID                                VARCHAR2(50 CHAR),
    END_CUSTOMER                           VARCHAR2(50 CHAR),
    BIZ_TYPE                               VARCHAR2(30 CHAR),
    PROJECT_NAME                           VARCHAR2(50 CHAR),
    ITEM_USE                               VARCHAR2(100 CHAR),
    UNIT_ENERGY                            NUMBER(30,10)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM51_SCM_CITY (9 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM51_SCM_CITY (
    DIVISION_ID                            VARCHAR2(30 CHAR),
    SOLDTO_CUSTOMER                        VARCHAR2(1000 CHAR),
    END_CUSTOMER                           VARCHAR2(1000 CHAR),
    DEPT_ID                                VARCHAR2(1000 CHAR),
    SCM_SITE_ID                            VARCHAR2(30 CHAR),
    VMI_YN                                 VARCHAR2(1 CHAR),
    VALID_YN                               VARCHAR2(1 CHAR),
    CITY_NAME                              VARCHAR2(1000 CHAR),
    COUNTRY_NAME                           VARCHAR2(1000 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_DM51_SCM_MST_SITE_ITEM (24 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DM51_SCM_MST_SITE_ITEM (
    DIVISION_ID                            VARCHAR2(30 CHAR),
    SCM_SITE_ID                            VARCHAR2(30 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    CURRENCY                               VARCHAR2(10 CHAR),
    CUST_GROUP                             VARCHAR2(1000 CHAR),
    CUST_GROUP_DTL                         VARCHAR2(1000 CHAR),
    APPLICATION                            VARCHAR2(1000 CHAR),
    ROUTE                                  VARCHAR2(1000 CHAR),
    ATTRIBUTE1                             VARCHAR2(1000 CHAR),
    ATTRIBUTE2                             VARCHAR2(1000 CHAR),
    ATTRIBUTE5                             VARCHAR2(1000 CHAR),
    REPORT_GROUP1                          VARCHAR2(1000 CHAR),
    REPORT_GROUP2                          VARCHAR2(1000 CHAR),
    REPORT_GROUP3                          VARCHAR2(1000 CHAR),
    REPORT_GROUP4                          VARCHAR2(1000 CHAR),
    REPORT_GROUP5                          VARCHAR2(1000 CHAR),
    REPORT_GROUP6                          VARCHAR2(1000 CHAR),
    OWNER                                  VARCHAR2(1000 CHAR),
    CELL_PER_CAR                           NUMBER,
    CELL_PER_MODULE                        NUMBER,
    OWNER_NAME                             VARCHAR2(4000),
    OWNER_NAME_KO                          VARCHAR2(4000),
    DEPT_ID                                VARCHAR2(1000 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_SPNC_SHPCHK_DUP (12 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_SPNC_SHPCHK_DUP (
    DIVISION_ID                            VARCHAR2(30 CHAR),
    PLAN_START_YYYYMMDD                    VARCHAR2(8 CHAR),
    PLAN_TYPE                              VARCHAR2(50 CHAR),
    SEQ                                    VARCHAR2(30 CHAR),
    OPERATION_GROUP                        VARCHAR2(30 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    TO_SITE                                VARCHAR2(30 CHAR),
    INCOTERMS                              VARCHAR2(10 CHAR),
    FROM_SITE                              VARCHAR2(30 CHAR),
    BOD_ID                                 VARCHAR2(150 CHAR),
    TRANSPORT_MODE                         VARCHAR2(150 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_SPNC_SHPCHK_NEW (12 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_SPNC_SHPCHK_NEW (
    DIVISION_ID                            VARCHAR2(30 CHAR),
    PLAN_START_YYYYMMDD                    VARCHAR2(8 CHAR),
    PLAN_TYPE                              VARCHAR2(50 CHAR),
    SEQ                                    VARCHAR2(30 CHAR),
    OPERATION_GROUP                        VARCHAR2(30 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    TO_SITE                                VARCHAR2(30 CHAR),
    INCOTERMS                              VARCHAR2(10 CHAR),
    FROM_SITE                              VARCHAR2(30 CHAR),
    BOD_ID                                 VARCHAR2(150 CHAR),
    TRANSPORT_MODE                         VARCHAR2(150 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

-- GT_SPNC_SHPCHK_PLAN (11 cols, SYS$SESSION)
BEGIN EXECUTE IMMEDIATE q'[
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_SPNC_SHPCHK_PLAN (
    DIVISION_ID                            VARCHAR2(30 CHAR),
    PLAN_START_YYYYMMDD                    VARCHAR2(8 CHAR),
    PLAN_TYPE                              VARCHAR2(50 CHAR),
    SEQ                                    VARCHAR2(30 CHAR),
    OPERATION_GROUP                        VARCHAR2(30 CHAR),
    PROJECT_CODE                           VARCHAR2(50 CHAR),
    ITEM_ID                                VARCHAR2(50 CHAR),
    TO_SITE                                VARCHAR2(30 CHAR),
    INCOTERMS                              VARCHAR2(10 CHAR),
    FROM_SITE                              VARCHAR2(30 CHAR),
    BOD_ID                                 VARCHAR2(150 CHAR)
) ON COMMIT PRESERVE ROWS
]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/
