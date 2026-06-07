/*=============================================================================================
 * File         : 010_DMF0003_Registration_DBeaver.sql
 * Description  : DMF0003 (MKT FCST) Phase 1 메타 등록 — DBeaver 호환 [PART 1: 등록]
 *              :
 *              : ★ DBeaver 파서 제약으로 PART 단위 3개 파일로 분리:
 *              :   • 010_DMF0003_Registration_DBeaver.sql           — 본 파일 (등록 PL/SQL 블록)
 *              :   • 010_DMF0003_Registration_DBeaver_Verify.sql    — 검증 SELECT
 *              :   • 010_DMF0003_Registration_DBeaver_Diagnose.sql  — 라우팅 진단 PL/SQL 블록
 *              :
 *              : 7개 영역 등록:
 *              :   1. i18n            (SCM_ADM_MSG_M)
 *              :   2. Procedure       (SCM_ADM_PROC_M) ★ 22 IN + 4 OUT = 26 row
 *              :   3. Sheet Columns   (SCM_MST_SHEET_COLUMNS) — 인라인 JSON_TABLE INSERT
 *              :   4. MENU            (SCM_ADM_MNU_M)
 *              :   5. API             (SCM_ADM_API_M)
 *              :   6. MNU_BTN_MPG     (SCM_ADM_MNU_BTN_MPG_M)
 *              :   7. Group MENU      (SCM_ADM_USER_GR_MNU_MPG_M)
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-06-07
 *
 * 실행 방법   :
 *   1. 본 파일 열기 → 전체 선택 (Ctrl+A) → Ctrl+Enter (또는 Alt+X)
 *   2. DBMS_OUTPUT 결과 확인 (Window → DBMS Output 뷰)
 *   3. 010_DMF0003_Registration_DBeaver_Verify.sql 실행 (CNT 검증)
 *   4. 010_DMF0003_Registration_DBeaver_Diagnose.sql 실행 (라우팅 동작 확인)
 *
 * 사전 조건   :
 *   • SCM_MGR.DMF0003_GET_MKT_FCST_DATA standalone SP 컴파일 VALID
 *   • DBeaver: Window → Preferences → Database → Editors → Oracle → ✅ Enable DBMS_OUTPUT
 *
 * ★ 자기완결형 (Self-Contained): 외부 PKG 의존성 없음.
 *
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/

DECLARE
    -- ─── 환경 상수 ────────────────────────────────────────────────────────────────────────
    V_MENU_ID         CONSTANT VARCHAR2(20)  := 'DMF0003';
    V_UPPR_MENU       CONSTANT VARCHAR2(50)  := 'Demand_Master';
    V_MENU_LV_NO      CONSTANT NUMBER        := 3;
    V_MENU_URL        CONSTANT VARCHAR2(200) := 'mkt-forecast-master';
    V_MENU_MSG_ID     CONSTANT VARCHAR2(50)  := 'MNU_DMF0003';
    V_MENU_KO         CONSTANT VARCHAR2(200) := '시장 수요 계획';
    V_MENU_EN         CONSTANT VARCHAR2(200) := 'Market Forecast';
    V_MENU_CN         CONSTANT VARCHAR2(200) := '市场需求计划';
    V_SORT_ORD        CONSTANT NUMBER        := 30;
    V_SHEET_NM        CONSTANT VARCHAR2(50)  := 'main';
    V_USER_ID         CONSTANT VARCHAR2(50)  := 'admin';

    -- ─── 파생 상수 ────────────────────────────────────────────────────────────────────────
    V_PROC_GET        CONSTANT VARCHAR2(100) := 'DMF0003_GET_MKT_FCST_DATA';  -- standalone
    V_API_SEARCH      CONSTANT VARCHAR2(100) := V_MENU_ID || '_' || V_SHEET_NM || '_SEARCH';
    V_API_SEARCH_MSG  CONSTANT VARCHAR2(50)  := 'MSG_API_' || V_MENU_ID || '_MKTFCST_SEARCH';

    v_col_json  CLOB;
    v_col_count NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('DMF0003 (Market Forecast) Phase 1 메타 등록 시작');
    DBMS_OUTPUT.PUT_LINE('============================================================');

    -- =========================================================================================
    -- BLOCK 1: i18n (SCM_ADM_MSG_M) — 메뉴명 + API 메시지
    -- =========================================================================================
    DELETE FROM SCM_ADM_MSG_M WHERE MSG_ID IN (V_MENU_MSG_ID, V_API_SEARCH_MSG);

    INSERT ALL
      INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_MENU_MSG_ID, 'KO', V_MENU_KO, 'MNU', 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_MENU_MSG_ID, 'EN', V_MENU_EN, 'MNU', 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_MENU_MSG_ID, 'CN', V_MENU_CN, 'MNU', 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_API_SEARCH_MSG, 'KO', '시장 수요 계획 조회', 'API', 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_API_SEARCH_MSG, 'EN', 'Market Forecast Search', 'API', 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_API_SEARCH_MSG, 'CN', '市场需求计划查询', 'API', 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
    SELECT 1 FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('[BLOCK 1] i18n: '||SQL%ROWCOUNT||' 행 등록 (MNU 3 + API 3)');

    -- =========================================================================================
    -- BLOCK 2: Procedure 메타 (SCM_ADM_PROC_M) — ★ standalone SP, 22 IN + 4 OUT
    -- =========================================================================================
    DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = V_PROC_GET;

    INSERT ALL
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'divisionId',    'IN', 'VARCHAR',  1, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'scmSiteId',     'IN', 'VARCHAR',  2, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'plantSiteId',   'IN', 'VARCHAR',  3, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'teamId',        'IN', 'VARCHAR',  4, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'customer',      'IN', 'VARCHAR',  5, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'bizType',       'IN', 'VARCHAR',  6, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'projectCode',   'IN', 'VARCHAR',  7, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'itemId',        'IN', 'VARCHAR',  8, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'fromYyyymmdd',  'IN', 'VARCHAR',  9, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'toYyyymmdd',    'IN', 'VARCHAR', 10, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'createdBy',     'IN', 'VARCHAR', 11, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'userGroup',     'IN', 'VARCHAR', 12, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'itemType',      'IN', 'VARCHAR', 13, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'owner',         'IN', 'VARCHAR', 14, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'qtyYn',         'IN', 'VARCHAR', 15, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'cellYn',        'IN', 'VARCHAR', 16, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'invalidExec',   'IN', 'VARCHAR', 17, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'asYn',          'IN', 'VARCHAR', 18, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'userDeptId',    'IN', 'VARCHAR', 19, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'senderCode',    'IN', 'VARCHAR', 20, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'sesUserId',     'IN', 'VARCHAR', 21, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'mnuId',         'IN', 'VARCHAR', 22, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'o_rc1',           'OUT', 'CURSOR',      23, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'o_rc2',           'OUT', 'CURSOR',      24, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'o_rc3',           'OUT', 'CURSOR',      25, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'o_result_cursor', 'OUT', 'PROC_RESULT', 26, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
    SELECT 1 FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('[BLOCK 2] PROC_M: '||SQL%ROWCOUNT||' 행 등록 (기대 26 = IN 22 + OUT 4)');

    -- =========================================================================================
    -- BLOCK 3: Sheet Columns 등록 (SCM_MST_SHEET_COLUMNS) — Main 43 fixed cols
    -- 동적 PIVOT cols (Bucket DAILY/WEEKLY/MONTHLY) 은 Phase 3 에서 FE 동적 생성 (미등록)
    -- =========================================================================================
    v_col_json := '[
        {"sht_nm":"main","col_nm":"DIVISION_ID",       "col_lbl":"Div.",            "cell_tp":"FPText",  "col_wth": 70,"sort_ord": 1,"align":"C","fixed":"Y","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"DEPT_ID",           "col_lbl":"Dept ID",         "cell_tp":"FPText",  "col_wth": 80,"sort_ord": 2,"align":"C","fixed":"Y","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"DEPT_NAME_KO",      "col_lbl":"Dept Name",       "cell_tp":"FPText",  "col_wth":120,"sort_ord": 3,"align":"L","fixed":"Y","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"TEAM_ID",           "col_lbl":"Team ID",         "cell_tp":"FPText",  "col_wth": 80,"sort_ord": 4,"align":"C","fixed":"Y","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"TEAM_NAME_KO",      "col_lbl":"Team Name",       "cell_tp":"FPText",  "col_wth":120,"sort_ord": 5,"align":"L","fixed":"Y","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"END_CUSTOMER",      "col_lbl":"End Customer",    "cell_tp":"FPText",  "col_wth":110,"sort_ord": 6,"align":"L","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"BIZ_TYPE",          "col_lbl":"Biz Type",        "cell_tp":"FPText",  "col_wth": 90,"sort_ord": 7,"align":"C","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"SCM_SITE_ID",       "col_lbl":"Sales Site",      "cell_tp":"FPText",  "col_wth":100,"sort_ord": 8,"align":"C","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"PLANT_SITE_ID",     "col_lbl":"Plant Site",      "cell_tp":"FPText",  "col_wth":100,"sort_ord": 9,"align":"C","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"PROJECT_CODE",      "col_lbl":"Project",         "cell_tp":"FPText",  "col_wth":110,"sort_ord":10,"align":"L","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"PROJECT_CODE_NAME", "col_lbl":"Project Code Name","cell_tp":"FPText", "col_wth":140,"sort_ord":11,"align":"L","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"PROJECT_NAME",      "col_lbl":"Project Name",    "cell_tp":"FPText",  "col_wth":140,"sort_ord":12,"align":"L","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"ITEM_ID",           "col_lbl":"Item",            "cell_tp":"FPText",  "col_wth":140,"sort_ord":13,"align":"L","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"ITEM_NAME",         "col_lbl":"Item Name",       "cell_tp":"FPText",  "col_wth":160,"sort_ord":14,"align":"L","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"NICK_NAME",         "col_lbl":"Nickname",        "cell_tp":"FPText",  "col_wth":120,"sort_ord":15,"align":"L","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"INCOTERMS",         "col_lbl":"Incoterms",       "cell_tp":"FPText",  "col_wth": 90,"sort_ord":16,"align":"C","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"ITEM_TYPE",         "col_lbl":"Item Type",       "cell_tp":"FPText",  "col_wth": 90,"sort_ord":17,"align":"C","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"FCST_TYPE",         "col_lbl":"FCST Type",       "cell_tp":"FPText",  "col_wth": 90,"sort_ord":18,"align":"C","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"DOM_EXP",           "col_lbl":"DOM/EXP",         "cell_tp":"FPText",  "col_wth": 80,"sort_ord":19,"align":"C","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"PROJECT_STATUS",    "col_lbl":"Project Status",  "cell_tp":"FPText",  "col_wth":110,"sort_ord":20,"align":"C","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"PROJECT_OWNER",     "col_lbl":"Project Owner",   "cell_tp":"FPText",  "col_wth":110,"sort_ord":21,"align":"L","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"OWNER",             "col_lbl":"Owner",           "cell_tp":"FPText",  "col_wth":110,"sort_ord":22,"align":"L","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"SOLD_TO_CUSTOMER",  "col_lbl":"Sold-to",         "cell_tp":"FPText",  "col_wth":110,"sort_ord":23,"align":"L","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"CELL_TYPE",         "col_lbl":"Cell Type",       "cell_tp":"FPText",  "col_wth": 90,"sort_ord":24,"align":"C","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"CITY",              "col_lbl":"City Code",       "cell_tp":"FPText",  "col_wth": 90,"sort_ord":25,"align":"C","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"CITY_NAME",         "col_lbl":"City Name",       "cell_tp":"FPText",  "col_wth":120,"sort_ord":26,"align":"L","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"COUNTRY",           "col_lbl":"Country Code",    "cell_tp":"FPText",  "col_wth": 90,"sort_ord":27,"align":"C","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"COUNTRY_NAME",      "col_lbl":"Country Name",    "cell_tp":"FPText",  "col_wth":120,"sort_ord":28,"align":"L","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"EDIT_FLAG",         "col_lbl":"Edit Flag",       "cell_tp":"FPText",  "col_wth": 80,"sort_ord":29,"align":"C","input_tp":"READONLY","visible":"N"},
        {"sht_nm":"main","col_nm":"MEASURE_GROUP",     "col_lbl":"Measure Group",   "cell_tp":"FPText",  "col_wth":110,"sort_ord":30,"align":"C","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"MEASURE",           "col_lbl":"Measure",         "cell_tp":"FPText",  "col_wth":110,"sort_ord":31,"align":"C","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"YYYYMMDD",          "col_lbl":"Date",            "cell_tp":"FPText",  "col_wth": 90,"sort_ord":32,"align":"C","input_tp":"READONLY"},
        {"sht_nm":"main","col_nm":"QTY",               "col_lbl":"Qty",             "cell_tp":"FPNumber","col_wth":100,"sort_ord":33,"align":"R","scale":0,"input_tp":"OPTIONAL"},
        {"sht_nm":"main","col_nm":"COLUMN_NAME",       "col_lbl":"Column Name",     "cell_tp":"FPText",  "col_wth":110,"sort_ord":34,"align":"L","input_tp":"READONLY","visible":"N"},
        {"sht_nm":"main","col_nm":"COLUMN_LABEL",      "col_lbl":"Column Label",    "cell_tp":"FPText",  "col_wth":120,"sort_ord":35,"align":"L","input_tp":"READONLY","visible":"N"},
        {"sht_nm":"main","col_nm":"SMALL_LABEL_NAME",  "col_lbl":"Small Label",     "cell_tp":"FPText",  "col_wth":110,"sort_ord":36,"align":"L","input_tp":"READONLY","visible":"N"},
        {"sht_nm":"main","col_nm":"LARGE_LABEL_NAME",  "col_lbl":"Large Label",     "cell_tp":"FPText",  "col_wth":110,"sort_ord":37,"align":"L","input_tp":"READONLY","visible":"N"},
        {"sht_nm":"main","col_nm":"DAY_CODE",          "col_lbl":"Day Code",        "cell_tp":"FPText",  "col_wth": 80,"sort_ord":38,"align":"C","input_tp":"READONLY","visible":"N"},
        {"sht_nm":"main","col_nm":"DIVISION_ID40",     "col_lbl":"Division40",      "cell_tp":"FPText",  "col_wth": 80,"sort_ord":39,"align":"C","input_tp":"READONLY","visible":"N"},
        {"sht_nm":"main","col_nm":"END_CUSTOMER40",    "col_lbl":"Customer40",      "cell_tp":"FPText",  "col_wth":110,"sort_ord":40,"align":"L","input_tp":"READONLY","visible":"N"},
        {"sht_nm":"main","col_nm":"SCM_SITE_ID40",     "col_lbl":"ScmSite40",       "cell_tp":"FPText",  "col_wth":100,"sort_ord":41,"align":"C","input_tp":"READONLY","visible":"N"},
        {"sht_nm":"main","col_nm":"ITEM_ID40",         "col_lbl":"ItemId40",        "cell_tp":"FPText",  "col_wth":140,"sort_ord":42,"align":"L","input_tp":"READONLY","visible":"N"},
        {"sht_nm":"main","col_nm":"VMI_YN",            "col_lbl":"VMI Y/N",         "cell_tp":"FPText",  "col_wth": 80,"sort_ord":43,"align":"C","input_tp":"READONLY"}
    ]';

    DELETE FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = V_MENU_ID;

    INSERT INTO SCM_MST_SHEET_COLUMNS (
        PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO,
        SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, FIXED_FLAG, COLUMN_WIDTH,
        CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE,
        DATA_SCALE_NUMBER, DATA_MAX_LENGTH, HORIZONTAL_ALIGN_CODE,
        UPPERCASE_APPLY_FLAG, VISIBLE_FLAG, DEFAULT_FLAG,
        USER_SELECTABLE_FLAG, VALID_YN, DIVISION_ID, INPUT_TP_CD,
        CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
    )
    SELECT
        V_MENU_ID,
        jt.SHT_NM, jt.COL_NM, jt.COL_LBL, jt.SORT_ORD,
        jt.SMALL_CLS, jt.LARGE_CLS,
        NVL(jt.FIXED, 'N'),
        NVL(jt.COL_WTH, 100),
        NVL(jt.CELL_TP, 'FPText'),
        jt.CELL_CBO,
        NVL(jt.SCALE, 0),
        NVL(jt.MAX_LEN, 200),
        NVL(jt.ALIGN, 'L'),
        NVL(jt.UPPER, 'N'),
        NVL(jt.VISIBLE, 'Y'),
        NVL(jt.DEFAULT_F, 'Y'),
        NVL(jt.USR_SEL, 'Y'),
        'Y',
        NVL(jt.DIV_ID, 'ALL'),
        NVL(jt.INPUT_TP, 'OPTIONAL'),
        V_USER_ID, SYSDATE, V_USER_ID, SYSDATE
    FROM JSON_TABLE(v_col_json, '$[*]'
        COLUMNS (
            SHT_NM    VARCHAR2(50 CHAR)   PATH '$.sht_nm',
            COL_NM    VARCHAR2(100 CHAR)  PATH '$.col_nm',
            COL_LBL   VARCHAR2(200 CHAR)  PATH '$.col_lbl',
            SORT_ORD  NUMBER              PATH '$.sort_ord',
            SMALL_CLS VARCHAR2(100 CHAR)  PATH '$.small_cls',
            LARGE_CLS VARCHAR2(100 CHAR)  PATH '$.large_cls',
            FIXED     VARCHAR2(1 CHAR)    PATH '$.fixed',
            COL_WTH   NUMBER              PATH '$.col_wth',
            CELL_TP   VARCHAR2(50 CHAR)   PATH '$.cell_tp',
            CELL_CBO  VARCHAR2(100 CHAR)  PATH '$.cell_cbo',
            SCALE     NUMBER              PATH '$.scale',
            MAX_LEN   NUMBER              PATH '$.max_len',
            ALIGN     VARCHAR2(1 CHAR)    PATH '$.align',
            UPPER     VARCHAR2(1 CHAR)    PATH '$.upper',
            VISIBLE   VARCHAR2(1 CHAR)    PATH '$.visible',
            DEFAULT_F VARCHAR2(1 CHAR)    PATH '$.default_f',
            USR_SEL   VARCHAR2(1 CHAR)    PATH '$.usr_sel',
            DIV_ID    VARCHAR2(100 CHAR)  PATH '$.div_id',
            INPUT_TP  VARCHAR2(50 CHAR)   PATH '$.input_tp'
        )) jt;
    v_col_count := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('[BLOCK 3] SHEET_COLUMNS: '||v_col_count||' 행 등록 (기대 43)');

    -- =========================================================================================
    -- BLOCK 4: MENU 등록 (SCM_ADM_MNU_M)
    -- ★ UPPR_MNU_ID = 'Demand_Master' PascalCase (메모리 표준)
    -- ★ MNU_DESC NOT NULL — 룰 13 §10
    -- =========================================================================================
    MERGE INTO SCM_ADM_MNU_M T
    USING (SELECT V_MENU_ID AS MNU_ID FROM DUAL) S
       ON (T.MNU_ID = S.MNU_ID)
    WHEN MATCHED THEN
        UPDATE SET T.UPPR_MNU_ID      = V_UPPR_MENU,
                   T.MNU_LV_NO        = V_MENU_LV_NO,
                   T.MNU_MSG_ID       = V_MENU_MSG_ID,
                   T.MNU_URL          = V_MENU_URL,
                   T.MNU_DESC         = V_MENU_EN,
                   T.SORT_ORD         = V_SORT_ORD,
                   T.MNU_TP_CD        = 'FN',
                   T.USE_YN           = 'Y',
                   T.LAST_UPDATED_BY  = V_USER_ID,
                   T.LAST_UPDATE_DATE = SYSDATE
    WHEN NOT MATCHED THEN
        INSERT (MNU_ID, UPPR_MNU_ID, MNU_LV_NO, MNU_MSG_ID, MNU_URL, MNU_DESC, SORT_ORD,
                MNU_TP_CD, USE_YN,
                CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_MENU_ID, V_UPPR_MENU, V_MENU_LV_NO, V_MENU_MSG_ID, V_MENU_URL, V_MENU_EN,
                V_SORT_ORD, 'FN', 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE);
    DBMS_OUTPUT.PUT_LINE('[BLOCK 4] MENU: '||SQL%ROWCOUNT||' 행 MERGE');

    -- =========================================================================================
    -- BLOCK 5: API 등록 (SCM_ADM_API_M) — Phase 1 = SEARCH 1건
    -- =========================================================================================
    DELETE FROM SCM_ADM_API_M WHERE API_ID LIKE V_MENU_ID||'\_%' ESCAPE '\';

    INSERT INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
                               CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES (V_API_SEARCH, 'PROC', V_API_SEARCH_MSG,
            'DMF0003 Market Forecast Search', V_PROC_GET, 'Y',
            V_USER_ID, SYSDATE, V_USER_ID, SYSDATE);
    DBMS_OUTPUT.PUT_LINE('[BLOCK 5] API_M: '||SQL%ROWCOUNT||' 행 등록');

    -- =========================================================================================
    -- BLOCK 6: MNU_BTN_MPG (라우팅 매핑) — Phase 1 = SEARCH 1건
    -- ★ MNU_BTN_CD = 'SEARCH' (표준, 'RETRIEVE' 금지)
    -- =========================================================================================
    DELETE FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = V_MENU_ID;

    INSERT INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES (V_MENU_ID, V_SHEET_NM, 'SEARCH', V_API_SEARCH, 'Y',
            V_USER_ID, SYSDATE, V_USER_ID, SYSDATE);
    DBMS_OUTPUT.PUT_LINE('[BLOCK 6] MNU_BTN_MPG: '||SQL%ROWCOUNT||' 행 등록');

    -- =========================================================================================
    -- BLOCK 7: Group MENU 권한 (SCM_ADM_USER_GR_MNU_MPG_M)
    -- ADMIN + DEMAND_USER + GUEST (3 groups)
    -- =========================================================================================
    DELETE FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = V_MENU_ID;

    INSERT ALL
      INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN,
                                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES ('ADMIN',       V_MENU_ID, 'Y', V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN,
                                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES ('DEMAND_USER', V_MENU_ID, 'Y', V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN,
                                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES ('GUEST',       V_MENU_ID, 'Y', V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
    SELECT 1 FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('[BLOCK 7] USER_GR_MNU_MPG: '||SQL%ROWCOUNT||' 행 등록');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('DMF0003 Phase 1 메타 등록 완료. Verify/Diagnose 파일 실행 권장.');
    DBMS_OUTPUT.PUT_LINE('============================================================');

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('❌ ERROR: '||SQLCODE||' / '||SQLERRM);
    RAISE;
END;
