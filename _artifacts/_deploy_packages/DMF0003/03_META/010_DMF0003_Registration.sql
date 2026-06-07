/*=============================================================================================
 * File         : 010_DMF0003_Registration.sql
 * Description  : DMF0003 (MKT FCST — Market Forecast) Phase 1 메타 등록
 *              :   - Phase 1 범위: 메뉴 등록 + 메인 GET SP + 43 fixed cols + 권한
 *              :   - 메인 GET SP : SCM_MGR.DMF0003_GET_MKT_FCST_DATA (standalone, AS-IS 1:1 변환)
 *              :   - Phase 2~7 augment 파일: 020~060
 *              :
 *              : 7-BLOCK 표준 (DMF0020 Registration 패턴 그대로):
 *              :   1. i18n            (SCM_ADM_MSG_M)
 *              :   2. Procedure       (SCM_ADM_PROC_M) ★ 누락 시 빈 결과
 *              :   3. Sheet Columns   (SCM_MST_SHEET_COLUMNS) — 인라인 JSON_TABLE INSERT
 *              :   4. MENU            (SCM_ADM_MNU_M)
 *              :   5. API             (SCM_ADM_API_M)
 *              :   6. MNU_BTN_MPG     (SCM_ADM_MNU_BTN_MPG_M)
 *              :   7. Group MENU      (SCM_ADM_USER_GR_MNU_MPG_M)
 *              :
 *              : ★ 자기완결형 (Self-Contained): 외부 PKG 의존성 없음.
 *              : ★ UPPR_MENU = 'Demand_Master' PascalCase (메모리 표준, 자매 화면 cross-check)
 *              : ★ SHT_NM    = 'main' (자매 화면 표준 — ORA-01403 회피)
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-06-07
 * Plan         : C:\Users\ejene\.claude\plans\goofy-percolating-island.md
 *
 * 화면 정보   :
 *   MENU_ID    : DMF0003
 *   화면명     : Market Forecast (MKT FCST)
 *   FE 경로    : /master/demand-master/mkt-forecast-master
 *   3 변형 결정: 사용자 옵션 B — 메인 _1_MktFcst 만 신규, _T_/_M_ deprecated
 *   메인 GET SP: SCM_MGR.DMF0003_GET_MKT_FCST_DATA (standalone, 22 IN + 4 OUT, archive line 1546)
 *   AS-IS .cs  : Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Plan.UIL/DMF0003_1_MktFcst.cs (7,056 lines)
 *
 * 사전 조건   : SCM_MGR.DMF0003_GET_MKT_FCST_DATA 컴파일 완료 (VALID 상태)
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/

SET DEFINE ON
SET SERVEROUTPUT ON SIZE UNLIMITED

DEFINE V_MENU_ID         = 'DMF0003'
DEFINE V_UPPR_MENU       = 'Demand_Master'
DEFINE V_MENU_LV_NO      = 3
DEFINE V_MENU_URL        = 'mkt-forecast-master'
DEFINE V_MENU_MSG_ID     = 'MNU_DMF0003'
DEFINE V_MENU_KO         = '시장 수요 계획'
DEFINE V_MENU_EN         = 'Market Forecast'
DEFINE V_MENU_CN         = '市场需求计划'
DEFINE V_SORT_ORD        = 30
DEFINE V_SHEET_NM        = 'main'
DEFINE V_PKG_NM          = 'PKG_DMF0003'
DEFINE V_USER_ID         = 'admin'
DEFINE V_API_SEARCH_MSG  = 'MSG_API_DMF0003_MKTFCST_SEARCH'


-- =============================================================================================
-- BLOCK 1: i18n (SCM_ADM_MSG_M) — 메뉴명 + API 메시지
-- =============================================================================================

DELETE FROM SCM_ADM_MSG_M WHERE MSG_ID IN ('&V_MENU_MSG_ID', '&V_API_SEARCH_MSG');

INSERT ALL
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_MENU_MSG_ID', 'KO', '&V_MENU_KO', 'MNU', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_MENU_MSG_ID', 'EN', '&V_MENU_EN', 'MNU', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_MENU_MSG_ID', 'CN', '&V_MENU_CN', 'MNU', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_API_SEARCH_MSG', 'KO', '시장 수요 계획 조회', 'API', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_API_SEARCH_MSG', 'EN', 'Market Forecast Search', 'API', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_API_SEARCH_MSG', 'CN', '市场需求计划查询', 'API', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;


-- =============================================================================================
-- BLOCK 2: Procedure 메타 (SCM_ADM_PROC_M) — ★ 핵심
-- 명명규약: P_DIVISION_ID → divisionId (camelCase, P_ 제거)
--          P_USER_ID → sesUserId, P_MENU_ID → mnuId (메모리 표준 — BE 자동 채움 키)
--          O_RC1 → o_rc1, O_RESULT_CURSOR → o_result_cursor
-- 메인 GET SP: SCM_MGR.DMF0003_GET_MKT_FCST_DATA (standalone, 22 IN + 4 OUT = 26 row)
-- AS-IS sig  : archive line 1546 (07_Standalone_SP/_archive_absorbed_into_PKG)
-- =============================================================================================

DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = 'DMF0003_GET_MKT_FCST_DATA';

INSERT ALL
  -- IN 22개
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'divisionId',    'IN', 'VARCHAR',  1, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'scmSiteId',     'IN', 'VARCHAR',  2, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'plantSiteId',   'IN', 'VARCHAR',  3, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'teamId',        'IN', 'VARCHAR',  4, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'customer',      'IN', 'VARCHAR',  5, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'bizType',       'IN', 'VARCHAR',  6, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'projectCode',   'IN', 'VARCHAR',  7, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'itemId',        'IN', 'VARCHAR',  8, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'fromYyyymmdd',  'IN', 'VARCHAR',  9, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'toYyyymmdd',    'IN', 'VARCHAR', 10, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'createdBy',     'IN', 'VARCHAR', 11, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'userGroup',     'IN', 'VARCHAR', 12, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'itemType',      'IN', 'VARCHAR', 13, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'owner',         'IN', 'VARCHAR', 14, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'qtyYn',         'IN', 'VARCHAR', 15, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'cellYn',        'IN', 'VARCHAR', 16, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'invalidExec',   'IN', 'VARCHAR', 17, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'asYn',          'IN', 'VARCHAR', 18, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'userDeptId',    'IN', 'VARCHAR', 19, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'senderCode',    'IN', 'VARCHAR', 20, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'sesUserId',     'IN', 'VARCHAR', 21, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'mnuId',         'IN', 'VARCHAR', 22, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  -- OUT 4개 (4 cursor — AS-IS 1:1)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'o_rc1',           'OUT', 'CURSOR',      23, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'o_rc2',           'OUT', 'CURSOR',      24, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'o_rc3',           'OUT', 'CURSOR',      25, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_GET_MKT_FCST_DATA', 'o_result_cursor', 'OUT', 'PROC_RESULT', 26, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;


-- =============================================================================================
-- BLOCK 3: Sheet Columns 등록 (SCM_MST_SHEET_COLUMNS) — 인라인 JSON_TABLE INSERT
-- AS-IS DefColumns Main 43 cols (analysis.md §4.5) — Phase 1 범위 fixed cols.
-- 동적 PIVOT 컬럼 (Bucket DAILY/WEEKLY/MONTHLY) 은 Phase 3 에서 FE 동적 생성 (SHEET_COLUMNS 미등록).
-- ESS 사업부 추가 13 cols + 20190326 수정 불가 14 cols 도 Phase 3 augment.
-- ★ binding (COLUMN_NAME) ↔ SP O_RC1 cursor SELECT alias 일치 의무 (hook sheet-columns-binding-match)
-- =============================================================================================

DECLARE
    v_col_json  CLOB := '[
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
    v_col_count NUMBER;
BEGIN
    DELETE FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = '&V_MENU_ID';

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
        '&V_MENU_ID',
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
        '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE
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
    DBMS_OUTPUT.PUT_LINE('[BLOCK 3] SCM_MST_SHEET_COLUMNS: '||v_col_count||' 행 등록 (기대 43)');
END;
/


-- =============================================================================================
-- BLOCK 4: MENU 등록 (SCM_ADM_MNU_M)
-- ★ UPPR_MNU_ID = 'Demand_Master' PascalCase (메모리 표준 — 자매 화면 cross-check)
-- ★ MNU_DESC NOT NULL — 룰 13 §10 (sidebar 표시 의무)
-- =============================================================================================

MERGE INTO SCM_ADM_MNU_M T
USING (SELECT '&V_MENU_ID' AS MNU_ID FROM DUAL) S
   ON (T.MNU_ID = S.MNU_ID)
WHEN MATCHED THEN
    UPDATE SET T.UPPR_MNU_ID      = '&V_UPPR_MENU',
               T.MNU_LV_NO        = &V_MENU_LV_NO,
               T.MNU_MSG_ID       = '&V_MENU_MSG_ID',
               T.MNU_URL          = '&V_MENU_URL',
               T.MNU_DESC         = '&V_MENU_EN',
               T.SORT_ORD         = &V_SORT_ORD,
               T.MNU_TP_CD        = 'FN',
               T.USE_YN           = 'Y',
               T.LAST_UPDATED_BY  = '&V_USER_ID',
               T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN
    INSERT (MNU_ID, UPPR_MNU_ID, MNU_LV_NO, MNU_MSG_ID, MNU_URL, MNU_DESC, SORT_ORD,
            MNU_TP_CD, USE_YN,
            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_MENU_ID', '&V_UPPR_MENU', &V_MENU_LV_NO, '&V_MENU_MSG_ID', '&V_MENU_URL', '&V_MENU_EN',
            &V_SORT_ORD, 'FN', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);


-- =============================================================================================
-- BLOCK 5: API 등록 (SCM_ADM_API_M) — Phase 1 = SEARCH 1건만
-- =============================================================================================

DELETE FROM SCM_ADM_API_M WHERE API_ID LIKE 'DMF0003\_%' ESCAPE '\';

INSERT ALL
  INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003_main_SEARCH', 'PROC', '&V_API_SEARCH_MSG',
            'DMF0003 Market Forecast Search', 'DMF0003_GET_MKT_FCST_DATA', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;


-- =============================================================================================
-- BLOCK 6: MNU_BTN_MPG (SCM_ADM_MNU_BTN_MPG_M — 라우팅 매핑) — Phase 1 = SEARCH 1건
-- MNU_BTN_CD = 'SEARCH' (표준 — 'RETRIEVE' 금지, 룰 12 §13)
-- =============================================================================================

DELETE FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = '&V_MENU_ID';

INSERT ALL
  INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                              CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0003', 'main', 'SEARCH', 'DMF0003_main_SEARCH', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;


-- =============================================================================================
-- BLOCK 7: Group MENU 권한 (SCM_ADM_USER_GR_MNU_MPG_M)
-- ★ minyonglee1 (메모리 user_login_id) 사용자 + ADMIN/DEMAND_USER 그룹
-- =============================================================================================

DELETE FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = '&V_MENU_ID';

INSERT ALL
  INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN,
                                  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('ADMIN',       'DMF0003', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN,
                                  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DEMAND_USER', 'DMF0003', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN,
                                  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('GUEST',       'DMF0003', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;


COMMIT;


-- =============================================================================================
-- BLOCK 8: 검증 SELECT (7개 영역 확인)
-- =============================================================================================

PROMPT
PROMPT ============================================================
PROMPT 신규 화면 [DMF0003 — Market Forecast] Phase 1 등록 검증 결과
PROMPT ============================================================

SELECT '1.MENU'         AS K, COUNT(*) AS CNT,  1 AS EXPECT_MIN, 'SCM_ADM_MNU_M'              AS TBL FROM SCM_ADM_MNU_M             WHERE MNU_ID = 'DMF0003'
UNION ALL
SELECT '2.MENU_AUTH',    COUNT(*),  3, 'SCM_ADM_USER_GR_MNU_MPG_M'      FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = 'DMF0003'
UNION ALL
SELECT '3.UI_COLS',      COUNT(*), 43, 'SCM_MST_SHEET_COLUMNS (★ 43 fixed)' FROM SCM_MST_SHEET_COLUMNS  WHERE PROGRAM_ID = 'DMF0003'
UNION ALL
SELECT '4.PROC',         COUNT(*), 26, 'SCM_ADM_PROC_M  (★ 22 IN + 4 OUT)' FROM SCM_ADM_PROC_M         WHERE PROC_NM = 'DMF0003_GET_MKT_FCST_DATA'
UNION ALL
SELECT '5.API',          COUNT(*),  1, 'SCM_ADM_API_M'                  FROM SCM_ADM_API_M             WHERE API_ID LIKE 'DMF0003\_%' ESCAPE '\'
UNION ALL
SELECT '6.MNU_BTN_MPG',  COUNT(*),  1, 'SCM_ADM_MNU_BTN_MPG_M'          FROM SCM_ADM_MNU_BTN_MPG_M     WHERE MNU_ID = 'DMF0003'
UNION ALL
SELECT '7.I18N_MNU',     COUNT(*),  3, 'SCM_ADM_MSG_M (KO/EN/CN)'       FROM SCM_ADM_MSG_M             WHERE MSG_ID = 'MNU_DMF0003'
ORDER BY 1;


-- ── 동작 검증: PR_GET_PROC_INFO_LIST 가 정상 라우팅 ─────────────────────────────────────────
PROMPT
PROMPT === PR_GET_PROC_INFO_LIST(DMF0003, main, SEARCH) 결과 ===
DECLARE
    v_cur     SYS_REFCURSOR;
    v_proc_nm VARCHAR2(200); v_col_nm VARCHAR2(100);
    v_data_tp VARCHAR2(50);  v_col_tp VARCHAR2(50);
    v_sort_ord NUMBER;       v_cnt PLS_INTEGER := 0;
BEGIN
    SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST(
        P_MNU_ID => 'DMF0003', P_SHT_NM => 'main', P_MNU_BTN_CD => 'SEARCH',
        O_CURSOR => v_cur
    );
    LOOP
        FETCH v_cur INTO v_proc_nm, v_col_nm, v_data_tp, v_col_tp, v_sort_ord;
        EXIT WHEN v_cur%NOTFOUND;
        v_cnt := v_cnt + 1;
        DBMS_OUTPUT.PUT_LINE('  ['||v_cnt||'] '||v_proc_nm||' / '||v_col_nm||' / '||v_data_tp||' / '||v_col_tp||' / '||v_sort_ord);
    END LOOP;
    CLOSE v_cur;

    IF v_cnt = 0 THEN
        DBMS_OUTPUT.PUT_LINE('  ❌ FAIL: 라우팅 행 0 — BLOCK 5/6 재확인');
    ELSIF v_cnt < 26 THEN
        DBMS_OUTPUT.PUT_LINE('  ⚠ WARN: SCM_ADM_PROC_M 누락 ('||v_cnt||'/26) — BLOCK 2 재확인');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  ✅ OK: 26 행 라우팅됨 (IN 22 + OUT 4)');
    END IF;
END;
/

PROMPT
PROMPT ============================================================
PROMPT Phase 1 등록 완료. 다음 단계:
PROMPT   1) 05_VERIFY/010_Object_Status_Verify.sql 실행 (SP VALID 확인)
PROMPT   2) 05_VERIFY/020_Meta_Chain_Verify.sql 실행 (메타 chain PASS)
PROMPT   3) FE 측 Router.tsx + menu-ids.ts + route-paths.ts 등록
PROMPT   4) start-all.ps1 → /master/demand-master/mkt-forecast-master 진입 → grid 43 cols 표시
PROMPT ============================================================


UNDEFINE V_MENU_ID V_UPPR_MENU V_MENU_LV_NO V_MENU_URL V_MENU_MSG_ID
UNDEFINE V_MENU_KO V_MENU_EN V_MENU_CN V_SORT_ORD V_SHEET_NM V_PKG_NM V_USER_ID V_API_SEARCH_MSG
