--==============================================================================
-- 010_DMF0048_meta.sql — DMF0048 SalesMonitoring (Sales Monitoring) 메타 SQL 7-BLOCK
--   조회 전용 화면 (read-only) — F5 Search + F12 Excel 만
--   AS-IS: GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0048_SalesMonitoring/DMF0048_SalesMonitoring.cs (2,181 줄)
--   메뉴 위치: Demand > Demand_Plan > Sales Monitoring (UPPR_MNU_ID='Demand_Plan')
--   FE 폴더: nscm-fe/features/demand/src/pages/sales-monitoring/
--
-- 룰 v2 의무:
--   - 룰 08 §4.2 UPPR_MNU_ID 대소문자 표준 = 'Demand_Plan' (자매 화면 검증)
--   - 룰 08 §4.4 PROC_M COL_NM 자동 채움 키 (sesUserId/sesLangCd/mnuId)
--   - 룰 12 §15 CMBO `@varName` BE 자동 채움 (별도 X — 콤보는 자매 카탈로그 재사용)
--   - 룰 13 §10 MNU_DESC 필수 (sidebar 표시 의무)
--   - 모든 INSERT NOT EXISTS 멱등 패턴 (feedback_sql_idempotent_insert_all)
--
-- 작성: 2026-06-07 (Phase B-1)
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === PRE: 사전 카운트 ===
SELECT 'PRE: MNU' AS K, COUNT(*) AS V FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0048'
UNION ALL SELECT 'PRE: API', COUNT(*) FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE 'P_DMF0048%'
UNION ALL SELECT 'PRE: PROC', COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE 'DMF0048%'
UNION ALL SELECT 'PRE: SHEET_COLS', COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0048';

-- =============================================================================
-- BLOCK 1: MSG_M (API + i18n LBL 라벨)
-- =============================================================================
PROMPT === BLOCK 1 : MSG_M (5 + LBL 추가는 별도 i18n JSON 에서 관리) ===
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM, MSG_DESC, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, 'KO', 'API', NEW.MSG_NM, NEW.MSG_NM, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'MSG_API_DMF0048_MAIN_RETRIEVE'         AS MSG_ID, 'Sales Monitoring 조회' AS MSG_NM FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0048_SPREADTITLE_RETRIEVE',           'Sales Monitoring 헤더 조회'                FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID=NEW.MSG_ID AND X.LANG_CD='KO');

-- =============================================================================
-- BLOCK 2: SCM_ADM_MNU_M (메뉴 등록)
--   UPPR_MNU_ID='Demand_Plan' (자매 화면 표준 case, feedback_mnu_uppr_case_standard)
--   MNU_DESC 필수 (feedback_mnu_desc_required) - sidebar 표시 의무
--   MNU_URL = leaf slug 만 (feedback_mnu_url_slug_only)
--   MNU_TP_CD='SCREEN'
-- =============================================================================
PROMPT === BLOCK 2 : MNU_M (1 row) ===
INSERT INTO SCM_MGR.SCM_ADM_MNU_M (MNU_ID, UPPR_MNU_ID, MNU_NM, MNU_DESC, MNU_LVL, MNU_TP_CD, MNU_URL, MNU_ORD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0048', 'Demand_Plan', 'Sales Monitoring', 'Sales Monitoring (DM Plan 매출 모니터링 — 조회 전용)', 3, 'SCREEN', 'sales-monitoring', 90, 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0048');

-- =============================================================================
-- BLOCK 3: SCM_MST_SHEET_COLUMNS (Grid 컬럼 메타 — 51 cols)
--   PROGRAM_ID='DMF0048', SHT_NM='main' (feedback_sheet_name_main_standard)
--   COLUMN_NAME 은 SP 반환 alias case-sensitive 일치 (sheet-columns-binding-match.md)
-- =============================================================================
PROMPT === BLOCK 3 : SHEET_COLUMNS (51 rows) ===
INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS (PROGRAM_ID, SHT_NM, SORT_ORD, COLUMN_NAME, HDR_NM, WIDTH, ALIGN_CD, CTRL_TP_CD, INPUT_TP_CD, MERGE_YN, FRZ_YN, VISIBLE_YN, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0048', 'main', NEW.SORT_ORD, NEW.COLUMN_NAME, NEW.HDR_NM, NEW.WIDTH, NEW.ALIGN_CD, 'FPText', 'S', NEW.MERGE_YN, 'N', NEW.VISIBLE_YN, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    -- Main 19 cols (AS-IS DefColumns L103~)
    SELECT  1 AS SORT_ORD, 'Column1'        AS COLUMN_NAME, ''               AS HDR_NM,  30 AS WIDTH, 'C' AS ALIGN_CD, 'Y' AS MERGE_YN, 'Y' AS VISIBLE_YN FROM DUAL UNION ALL
    SELECT  2,            'Column2',                       '',                            30,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT  3,            'Column3',                       '',                            30,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT  4,            'DIVISION_ID',                   'Div',                         60,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT  5,            'DEPT_ID',                       'Dept ID',                     80,          'C',              'Y',              'N' FROM DUAL UNION ALL
    SELECT  6,            'DEPT_NAME_KO',                  'Department',                 100,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT  7,            'TEAM_ID',                       'Team ID',                     80,          'C',              'Y',              'N' FROM DUAL UNION ALL
    SELECT  8,            'TEAM_NAME_KO',                  'Team',                       100,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT  9,            'END_CUSTOMER',                  'Customer',                   100,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 10,            'BIZ_TYPE',                      'Biz.Type Code',               80,          'C',              'Y',              'N' FROM DUAL UNION ALL
    SELECT 11,            'BIZ_TYPE_NAME',                 'Biz.Type',                   100,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 12,            'SCM_SITE_ID',                   'Sales Site',                  90,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 13,            'PLANT_SITE_ID',                 'Plant Site',                  90,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 14,            'PLANT_SITE_ID2',                'Plant Site 2',                90,          'C',              'Y',              'N' FROM DUAL UNION ALL
    SELECT 15,            'PROJECT_CODE',                  'Project',                    100,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 16,            'PROJECT_NAME',                  'Project Name',               150,          'L',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 17,            'ITEM_ID',                       'Model',                      120,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 18,            'ITEM_CLASS_NAME',               'Item Class',                 100,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 19,            'ITEM_NAME',                     'Item Name',                  150,          'L',              'Y',              'Y' FROM DUAL UNION ALL
    -- [C20200513-000276] +16 cols
    SELECT 20,            'SALES_COMPANY',                 'Sales Company',              100,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 21,            'SALES_PLANT',                   'Sales Plant',                100,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 22,            'NICK_NAME',                     'Nick Name',                  100,          'L',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 23,            'INCOTERMS',                     'Incoterms',                   80,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 24,            'ITEM_TYPE',                     'Item Type',                   90,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 25,            'FCST_TYPE',                     'Fcst Type',                   90,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 26,            'DOM_EXP',                       'DOM/EXP',                     80,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 27,            'PROJECT_STATUS',                'Project Status',             100,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 28,            'PROJECT_OWNER',                 'Project Owner',              100,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 29,            'MEASURE_GROUP',                 'Measure Group',              100,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 30,            'MEASURE',                       'Measure',                    100,          'L',              'N',              'Y' FROM DUAL UNION ALL
    SELECT 31,            'YYYYMMDD',                      'YYYYMMDD',                    80,          'C',              'N',              'N' FROM DUAL UNION ALL
    SELECT 32,            'QTY',                           'Qty',                         80,          'R',              'N',              'N' FROM DUAL UNION ALL
    SELECT 33,            'CURRENCY',                      'Currency',                    70,          'C',              'N',              'Y' FROM DUAL UNION ALL
    SELECT 34,            'SALES_PLAN_ADJUST_YN',          'Adjust YN',                   70,          'C',              'N',              'Y' FROM DUAL UNION ALL
    SELECT 35,            'TEAM_INCHARGE',                 'Team Incharge',              100,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    -- UPPER_DEPT_ID (1 col)
    SELECT 36,            'UPPER_DEPT_ID',                 'Upper Dept',                 100,          'C',              'Y',              'N' FROM DUAL UNION ALL
    -- [PJ20200138] +3 cols
    SELECT 37,            'DISTRIBUTION_CHANNEL',          'Distribution',               120,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 38,            'CELL_NAME',                     'Cell Name',                  100,          'L',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 39,            'SHIPMENT_SITE',                 'Shipment Site',              100,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    -- 201806 소형 +11 cols
    SELECT 40,            'END_CUSTOMER40',                'End Customer 40',            120,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 41,            'OWNER',                         'Owner',                      100,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 42,            'COUNTRY_NAME',                  'Country',                    100,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 43,            'CITY_NAME',                     'City',                       100,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 44,            'FORECAST_INFO_PRODUCT_GROUP',   'Product Group',              120,          'C',              'Y',              'Y' FROM DUAL UNION ALL
    SELECT 45,            'VMI_YN',                        'VMI YN',                      70,          'C',              'N',              'Y' FROM DUAL UNION ALL
    SELECT 46,            'COLUMN_NAME',                   'Col Name',                   100,          'C',              'N',              'N' FROM DUAL UNION ALL
    SELECT 47,            'COLUMN_LABEL_NAME',             'Col Label',                  100,          'L',              'N',              'N' FROM DUAL UNION ALL
    SELECT 48,            'SMALL_CLASS_LABEL_NAME',        'Small Class',                100,          'L',              'N',              'N' FROM DUAL UNION ALL
    SELECT 49,            'LARGE_CLASS_LABEL_NAME',        'Large Class',                100,          'L',              'N',              'N' FROM DUAL UNION ALL
    SELECT 50,            'DAY_CODE',                      'Day Code',                    70,          'C',              'N',              'N' FROM DUAL UNION ALL
    -- AS-IS L131 'ProjectName' (duplicate column for [PJ20200138])
    SELECT 51,            'PROJECT_NAME2',                 'Project Name (PJ)',          150,          'L',              'Y',              'N' FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS X
    WHERE X.PROGRAM_ID='DMF0048' AND X.SHT_NM='main' AND X.COLUMN_NAME=NEW.COLUMN_NAME
 );

-- =============================================================================
-- BLOCK 4: SCM_ADM_PROC_M (SP 파라미터 명세)
--   P_DMF0048_GET_DM_PLN_SALES_MONITORING : 22 IN + 3 OUT (o_rc1/o_rc2/O_RESULT_CURSOR)
--   P_DMF0048_GET_SPREAD_TITLE            : 4 IN + 2 OUT (o_rc1/O_RESULT_CURSOR) — ⚠️ PKG body 보강 필요
--
--   COL_NM 자동 채움 키 (feedback_proc_meta_mandatory):
--     P_USER_ID → sesUserId / P_MENU_ID → mnuId / P_LANG_CD → sesLangCd
--     P_CREATED_BY → sesUserId 또는 별도 (BE 자동 채움 안 함, FE 전달)
--     그 외 IN → camelCase
--   O_RCn → 소문자 / O_RESULT_CURSOR → 대문자 + PROC_RESULT 타입
-- =============================================================================
PROMPT === BLOCK 4 : PROC_M (33 rows = 25 + 8) ===
INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.PROC_NM, NEW.COL_NM, NEW.DATA_TP_CD, NEW.COL_TP_CD, NEW.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    -- DMF0048_GET_DM_PLN_SALES_MONITORING — 22 IN + 3 OUT
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING' AS PROC_NM, 'divisionId'      AS COL_NM, 'VARCHAR'      AS DATA_TP_CD, 'IN'  AS COL_TP_CD,  1 AS SORT_ORD FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'deptId',                     'VARCHAR',                  'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'endCustomer',                'VARCHAR',                  'IN',                3 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'scmSiteId',                  'VARCHAR',                  'IN',                4 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'projectCode',                'VARCHAR',                  'IN',                5 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'itemId',                     'VARCHAR',                  'IN',                6 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'itemType',                   'VARCHAR',                  'IN',                7 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'fromYyyymmdd',               'VARCHAR',                  'IN',                8 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'nowYyyymmdd',                'VARCHAR',                  'IN',                9 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'toYyyymmdd',                 'VARCHAR',                  'IN',               10 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'sesUserId',                  'VARCHAR',                  'IN',               11 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'plantSiteId',                'VARCHAR',                  'IN',               12 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'biztype',                    'VARCHAR',                  'IN',               13 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'owner',                      'VARCHAR',                  'IN',               14 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'internalYn',                 'VARCHAR',                  'IN',               15 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'sesGroupId',                 'VARCHAR',                  'IN',               16 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'bucket',                     'VARCHAR',                  'IN',               17 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'sesDeptId',                  'VARCHAR',                  'IN',               18 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'sesUserIdDup',               'VARCHAR',                  'IN',               19 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'mnuId',                      'VARCHAR',                  'IN',               20 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'o_rc1',                      'CURSOR',                   'OUT',              21 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'o_rc2',                      'CURSOR',                   'OUT',              22 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_DM_PLN_SALES_MONITORING',           'O_RESULT_CURSOR',            'PROC_RESULT',              'OUT',              23 FROM DUAL UNION ALL
    -- DMF0048_GET_SPREAD_TITLE — 4 IN + 2 OUT (PKG body 보강 필요 — sp-body-minimal-change hook)
    SELECT 'DMF0048_GET_SPREAD_TITLE',                      'startYyyymmdd',              'VARCHAR',                  'IN',                1 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_SPREAD_TITLE',                      'endYyyymmdd',                'VARCHAR',                  'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_SPREAD_TITLE',                      'sesUserId',                  'VARCHAR',                  'IN',                3 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_SPREAD_TITLE',                      'divisionId',                 'VARCHAR',                  'IN',                4 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_SPREAD_TITLE',                      'bucket',                     'VARCHAR',                  'IN',                5 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_SPREAD_TITLE',                      'o_rc1',                      'CURSOR',                   'OUT',               6 FROM DUAL UNION ALL
    SELECT 'DMF0048_GET_SPREAD_TITLE',                      'O_RESULT_CURSOR',            'PROC_RESULT',              'OUT',               7 FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_PROC_M X WHERE X.PROC_NM=NEW.PROC_NM AND X.COL_NM=NEW.COL_NM AND X.COL_TP_CD=NEW.COL_TP_CD);

-- =============================================================================
-- BLOCK 5: SCM_ADM_API_M (API → SP 매핑)
--   API_MSG_ID NOT NULL (reference_scm_adm_api_m_ddl) — BLOCK 1 MSG_M 와 연동
--   API_TP_CD : PROC_SELECT (조회) / PROC_SAVE (저장)
-- =============================================================================
PROMPT === BLOCK 5 : API_M (2 rows) ===
INSERT INTO SCM_MGR.SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.API_ID, NEW.API_TP_CD, NEW.API_MSG_ID, NEW.API_MSG_DESC, NEW.API_URL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'P_DMF0048_MAIN_RETRIEVE'  AS API_ID, 'PROC_SELECT' AS API_TP_CD, 'MSG_API_DMF0048_MAIN_RETRIEVE'  AS API_MSG_ID, 'Sales Monitoring 메인 조회' AS API_MSG_DESC, 'PKG_DMF0048.P_DMF0048_GET_DM_PLN_SALES_MONITORING' AS API_URL FROM DUAL UNION ALL
    SELECT 'P_DMF0048_TITLE_RETRIEVE',           'PROC_SELECT',              'MSG_API_DMF0048_SPREADTITLE_RETRIEVE',         '동적 헤더 조회',                            'PKG_DMF0048.P_DMF0048_GET_SPREAD_TITLE'             FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_API_M X WHERE X.API_ID=NEW.API_ID);

-- =============================================================================
-- BLOCK 6: SCM_ADM_MNU_BTN_MPG_M (메뉴×시트×버튼 → API)
--   MNU_BTN_CD 표준 : SEARCH (RETRIEVE 금지, feedback_button_code_consistency_search_vs_retrieve)
-- =============================================================================
PROMPT === BLOCK 6 : MNU_BTN_MPG_M (2 rows) ===
INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0048', NEW.SHT_NM, NEW.MNU_BTN_CD, NEW.API_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'main'         AS SHT_NM, 'SEARCH' AS MNU_BTN_CD, 'P_DMF0048_MAIN_RETRIEVE'  AS API_ID FROM DUAL UNION ALL
    SELECT 'spreadTitle',             'SEARCH',                'P_DMF0048_TITLE_RETRIEVE'           FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X WHERE X.MNU_ID='DMF0048' AND X.SHT_NM=NEW.SHT_NM AND X.MNU_BTN_CD=NEW.MNU_BTN_CD);

-- =============================================================================
-- BLOCK 7: 권한 (USER_GR_MNU_MPG_M + USER_GR_MNU_BTN_MPG_M)
--   GUEST 그룹 + minyonglee1 (user_login_id) 표준
--   메뉴 권한 + 버튼 권한 둘 다 INSERT (reference_scm_adm_user_gr_btn_mpg_m)
-- =============================================================================
PROMPT === BLOCK 7.1 : USER_GR_MNU_MPG_M (메뉴 권한 — GUEST + minyonglee1 그룹) ===
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.USER_GR_ID, 'DMF0048', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'GUEST' AS USER_GR_ID FROM DUAL UNION ALL
    SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
     WHERE G.USER_ID = 'minyonglee1'
       AND G.USE_YN = 'Y'
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M X WHERE X.USER_GR_ID=NEW.USER_GR_ID AND X.MNU_ID='DMF0048');

PROMPT === BLOCK 7.2 : USER_GR_MNU_BTN_MPG_M (버튼 권한 — GUEST + minyonglee1 그룹) ===
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT GR.USER_GR_ID, BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
  CROSS JOIN (
    SELECT 'GUEST' AS USER_GR_ID FROM DUAL UNION ALL
    SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
     WHERE G.USER_ID = 'minyonglee1' AND G.USE_YN = 'Y'
  ) GR
 WHERE BTN.MNU_ID='DMF0048' AND BTN.USE_YN='Y'
   AND NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X WHERE X.USER_GR_ID=GR.USER_GR_ID AND X.MNU_ID=BTN.MNU_ID AND X.SHT_NM=BTN.SHT_NM AND X.MNU_BTN_CD=BTN.MNU_BTN_CD);

PROMPT === POST: 사후 카운트 (Verify 5 BLOCK) ===
SELECT 'POST: MNU (1)'         AS K, COUNT(*) AS V FROM SCM_MGR.SCM_ADM_MNU_M           WHERE MNU_ID='DMF0048'
UNION ALL SELECT 'POST: API (2)',         COUNT(*) FROM SCM_MGR.SCM_ADM_API_M           WHERE API_ID LIKE 'P_DMF0048%'
UNION ALL SELECT 'POST: BTN_MPG (2)',     COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M   WHERE MNU_ID='DMF0048'
UNION ALL SELECT 'POST: PROC_M (30)',     COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M          WHERE PROC_NM LIKE 'DMF0048%'
UNION ALL SELECT 'POST: SHEET_COLS (51)', COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS   WHERE PROGRAM_ID='DMF0048'
UNION ALL SELECT 'POST: MSG (2)',         COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M           WHERE MSG_ID LIKE 'MSG_API_DMF0048%'
UNION ALL SELECT 'POST: GUEST MNU',       COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE USER_GR_ID='GUEST' AND MNU_ID='DMF0048'
UNION ALL SELECT 'POST: GUEST BTN',       COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE USER_GR_ID='GUEST' AND MNU_ID='DMF0048';

COMMIT;
EXIT;
