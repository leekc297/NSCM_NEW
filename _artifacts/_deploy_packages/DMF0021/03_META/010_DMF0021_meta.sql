--==============================================================================
-- 010_DMF0021_meta.sql — DMF0021 SalesPlan 메타 SQL 7-BLOCK
--   AS-IS .cs 5,599줄 / PKG body 3,678줄
--   메인 SP : P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx (17 IN — body 후속 분리 필요)
--   SAVE SP : P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL (17 IN + 1 OUT)
--   MEASURE SP : P_DMF0021_GET_SALES_PLAN_MEASUREINFO/2 (0/2 IN + dual OUT)
--   메뉴: Demand > Demand Plan > Sales Plan (UPPR_MNU_ID='Demand_Plan')
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : MSG_M (5 API 메시지) ===
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM, MSG_DESC, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, 'KO', 'API', NEW.MSG_NM, NEW.MSG_NM, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'MSG_API_DMF0021_MAIN_RETRIEVE'         AS MSG_ID, 'Sales Plan 메인 조회'   AS MSG_NM FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0021_TITLE_RETRIEVE',                'Sales Plan 헤더 조회'                FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0021_MAIN_SAVE',                     'Sales Plan 저장 (17 IN)'             FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0021_MEASURE_RETRIEVE',              'Sales Plan Measure 정보'             FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0021_MEASURE2_RETRIEVE',             'Sales Plan Measure 정보 (EditYn)'    FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID=NEW.MSG_ID AND X.LANG_CD='KO');

PROMPT === BLOCK 2 : MNU_M (1 row, UPPR_MNU_ID='Demand_Plan') ===
INSERT INTO SCM_MGR.SCM_ADM_MNU_M (MNU_ID, UPPR_MNU_ID, MNU_NM, MNU_DESC, MNU_LVL, MNU_TP_CD, MNU_URL, MNU_ORD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0021', 'Demand_Plan', 'Sales Plan', 'Sales Plan (DM Plan — CRUD 활성, 141 검증 + 120 표현식 + 9 popup)', 3, 'SCREEN', 'sales-plan', 70, 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0021');

PROMPT === BLOCK 3 : SHEET_COLUMNS (51 cols — DMF0048 동일 구조) ===
-- 본 BLOCK 은 51 cols 전체 INSERT (DMF0048 패턴 정확 복제). 분량 제약으로 핵심 14만 발췌 — 후속 보강 필요.
INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS (PROGRAM_ID, SHT_NM, SORT_ORD, COLUMN_NAME, HDR_NM, WIDTH, ALIGN_CD, CTRL_TP_CD, INPUT_TP_CD, MERGE_YN, FRZ_YN, VISIBLE_YN, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0021', 'main', NEW.SORT_ORD, NEW.COLUMN_NAME, NEW.HDR_NM, NEW.WIDTH, NEW.ALIGN_CD, NEW.CTRL_TP_CD, NEW.INPUT_TP_CD, 'Y', 'Y', NEW.VISIBLE_YN, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT  1 AS SORT_ORD, 'DIVISION_ID'    AS COLUMN_NAME, 'Div'         AS HDR_NM,  60 AS WIDTH, 'C' AS ALIGN_CD, 'FPText' AS CTRL_TP_CD, 'S' AS INPUT_TP_CD, 'Y' AS VISIBLE_YN FROM DUAL UNION ALL
    SELECT  2,            'DEPT_NAME_KO',                 'Department',                100,         'C',             'FPText',                'S',                'Y' FROM DUAL UNION ALL
    SELECT  3,            'TEAM_NAME_KO',                 'Team',                      100,         'C',             'FPText',                'S',                'Y' FROM DUAL UNION ALL
    SELECT  4,            'END_CUSTOMER',                 'Customer',                  100,         'C',             'FPText',                'S',                'Y' FROM DUAL UNION ALL
    SELECT  5,            'BIZ_TYPE_NAME',                'Biz.Type',                  100,         'C',             'FPText',                'S',                'Y' FROM DUAL UNION ALL
    SELECT  6,            'SCM_SITE_ID',                  'Sales Site',                 90,         'C',             'FPText',                'S',                'Y' FROM DUAL UNION ALL
    SELECT  7,            'PLANT_SITE_ID',                'Plant Site',                 90,         'C',             'FPText',                'S',                'Y' FROM DUAL UNION ALL
    SELECT  8,            'PROJECT_CODE',                 'Project',                   100,         'C',             'FPModal',               'S',                'Y' FROM DUAL UNION ALL
    SELECT  9,            'PROJECT_NAME',                 'Project Name',              150,         'L',             'FPText',                'S',                'Y' FROM DUAL UNION ALL
    SELECT 10,            'ITEM_ID',                      'Model',                     120,         'C',             'FPModal',               'S',                'Y' FROM DUAL UNION ALL
    SELECT 11,            'INCOTERMS',                    'Incoterms',                  80,         'C',             'FPText',                'S',                'Y' FROM DUAL UNION ALL
    SELECT 12,            'FCST_TYPE',                    'Fcst Type',                  90,         'C',             'FPText',                'S',                'Y' FROM DUAL UNION ALL
    SELECT 13,            'MEASURE',                      'Measure',                   100,         'L',             'FPText',                'S',                'Y' FROM DUAL UNION ALL
    SELECT 14,            'QTY',                          'Qty',                        80,         'R',             'FPNumber',              'M',                'Y' FROM DUAL UNION ALL
    SELECT 15,            'CURRENCY',                     'Currency',                   70,         'C',             'FPText',                'S',                'Y' FROM DUAL UNION ALL
    SELECT 16,            'EDIT_FLAG',                    'EDIT_FLAG',                   0,         'C',             'FPText',                'S',                'N' FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS X WHERE X.PROGRAM_ID='DMF0021' AND X.SHT_NM='main' AND X.COLUMN_NAME=NEW.COLUMN_NAME);
-- ⚠️ 35 추가 컬럼 (Main 19 + 추가 16 + UPPER_DEPT_ID + [PJ20200138] 4 + 201806 11) 은 Phase B-3 후속 정밀 추출 후 추가

PROMPT === BLOCK 4 : PROC_M (메인 19 + Save 18 + Measure 3 + Measure2 4 = 44 rows) ===
INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.PROC_NM, NEW.COL_NM, NEW.DATA_TP_CD, NEW.COL_TP_CD, NEW.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    -- DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx (17 IN + 2 OUT = 19)
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX' AS PROC_NM, 'divisionId'    AS COL_NM, 'VARCHAR' AS DATA_TP_CD, 'IN'  AS COL_TP_CD,  1 AS SORT_ORD FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX',           'deptId',                    'VARCHAR',               'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX',           'endCustomer',               'VARCHAR',               'IN',                3 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX',           'scmSiteId',                 'VARCHAR',               'IN',                4 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX',           'projectCode',               'VARCHAR',               'IN',                5 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX',           'itemId',                    'VARCHAR',               'IN',                6 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX',           'itemType',                  'VARCHAR',               'IN',                7 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX',           'fromYyyymmdd',              'VARCHAR',               'IN',                8 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX',           'nowYyyymmdd',               'VARCHAR',               'IN',                9 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX',           'toYyyymmdd',                'VARCHAR',               'IN',               10 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX',           'sesUserId',                 'VARCHAR',               'IN',               11 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX',           'plantSiteId',               'VARCHAR',               'IN',               12 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX',           'biztype',                   'VARCHAR',               'IN',               13 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX',           'owner',                     'VARCHAR',               'IN',               14 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX',           'internalYn',                'VARCHAR',               'IN',               15 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX',           'sesGroupId',                'VARCHAR',               'IN',               16 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX',           'bucket',                    'VARCHAR',               'IN',               17 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX',           'sesDeptId',                 'VARCHAR',               'IN',               18 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX',           'o_rc1',                     'CURSOR',                'OUT',              19 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX',           'O_RESULT_CURSOR',           'PROC_RESULT',           'OUT',              20 FROM DUAL UNION ALL
    -- DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL (17 IN + 1 OUT = 18)
    SELECT 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL',             'activeFlag',                'VARCHAR',               'IN',                1 FROM DUAL UNION ALL
    SELECT 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL',             'divisionId',                'VARCHAR',               'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL',             'projectCode',               'VARCHAR',               'IN',                3 FROM DUAL UNION ALL
    SELECT 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL',             'scmSiteId',                 'VARCHAR',               'IN',                4 FROM DUAL UNION ALL
    SELECT 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL',             'plantSiteId',               'VARCHAR',               'IN',                5 FROM DUAL UNION ALL
    SELECT 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL',             'itemId',                    'VARCHAR',               'IN',                6 FROM DUAL UNION ALL
    SELECT 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL',             'domExp',                    'VARCHAR',               'IN',                7 FROM DUAL UNION ALL
    SELECT 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL',             'fcstType',                  'VARCHAR',               'IN',                8 FROM DUAL UNION ALL
    SELECT 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL',             'incoterms',                 'VARCHAR',               'IN',                9 FROM DUAL UNION ALL
    SELECT 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL',             'measure',                   'VARCHAR',               'IN',               10 FROM DUAL UNION ALL
    SELECT 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL',             'yyyymmdd',                  'VARCHAR',               'IN',               11 FROM DUAL UNION ALL
    SELECT 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL',             'qty',                       'VARCHAR',               'IN',               12 FROM DUAL UNION ALL
    SELECT 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL',             'currency',                  'VARCHAR',               'IN',               13 FROM DUAL UNION ALL
    SELECT 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL',             'sesUserId',                 'VARCHAR',               'IN',               14 FROM DUAL UNION ALL
    SELECT 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL',             'sesUserIdDup',              'VARCHAR',               'IN',               15 FROM DUAL UNION ALL
    SELECT 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL',             'textVal',                   'VARCHAR',               'IN',               16 FROM DUAL UNION ALL
    SELECT 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL',             'deptId',                    'VARCHAR',               'IN',               17 FROM DUAL UNION ALL
    SELECT 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL',             'cellProdSiteId',            'VARCHAR',               'IN',               18 FROM DUAL UNION ALL
    SELECT 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL',             'O_RESULT_CURSOR',           'PROC_RESULT',           'OUT',              19 FROM DUAL UNION ALL
    -- DMF0021_GET_SALES_PLAN_MEASUREINFO (0 IN + 2 OUT = 2)
    SELECT 'DMF0021_GET_SALES_PLAN_MEASUREINFO',             'o_rc1',                     'CURSOR',                'OUT',               1 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_SALES_PLAN_MEASUREINFO',             'O_RESULT_CURSOR',           'PROC_RESULT',           'OUT',               2 FROM DUAL UNION ALL
    -- DMF0021_GET_SALES_PLAN_MEASUREINFO2 (2 IN + 2 OUT = 4)
    SELECT 'DMF0021_GET_SALES_PLAN_MEASUREINFO2',            'sesUserId',                 'VARCHAR',               'IN',                1 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_SALES_PLAN_MEASUREINFO2',            'mnuId',                     'VARCHAR',               'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_SALES_PLAN_MEASUREINFO2',            'o_rc1',                     'CURSOR',                'OUT',               3 FROM DUAL UNION ALL
    SELECT 'DMF0021_GET_SALES_PLAN_MEASUREINFO2',            'O_RESULT_CURSOR',           'PROC_RESULT',           'OUT',               4 FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_PROC_M X WHERE X.PROC_NM=NEW.PROC_NM AND X.COL_NM=NEW.COL_NM AND X.COL_TP_CD=NEW.COL_TP_CD);

PROMPT === BLOCK 5 : API_M (4 endpoint) ===
INSERT INTO SCM_MGR.SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.API_ID, NEW.API_TP_CD, NEW.API_MSG_ID, NEW.API_MSG_DESC, NEW.API_URL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'P_DMF0021_MAIN_RETRIEVE'      AS API_ID, 'PROC_SELECT' AS API_TP_CD, 'MSG_API_DMF0021_MAIN_RETRIEVE'  AS API_MSG_ID, '메인 조회 (2,122줄)'      AS API_MSG_DESC, 'PKG_DMF0021.P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX' AS API_URL FROM DUAL UNION ALL
    SELECT 'P_DMF0021_MAIN_SAVE',                    'PROC_SAVE',                'MSG_API_DMF0021_MAIN_SAVE',                     'Save (2,937줄, 17 IN)',                  'PKG_DMF0021.P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL'                  FROM DUAL UNION ALL
    SELECT 'P_DMF0021_MEASURE_RETRIEVE',             'PROC_SELECT',              'MSG_API_DMF0021_MEASURE_RETRIEVE',              'Measure 정보',                            'PKG_DMF0021.P_DMF0021_GET_SALES_PLAN_MEASUREINFO'                  FROM DUAL UNION ALL
    SELECT 'P_DMF0021_MEASURE2_RETRIEVE',            'PROC_SELECT',              'MSG_API_DMF0021_MEASURE2_RETRIEVE',             'Measure 정보 (EditYn)',                  'PKG_DMF0021.P_DMF0021_GET_SALES_PLAN_MEASUREINFO2'                 FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_API_M X WHERE X.API_ID=NEW.API_ID);

PROMPT === BLOCK 6 : MNU_BTN_MPG_M (4) ===
INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0021', NEW.SHT_NM, NEW.MNU_BTN_CD, NEW.API_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'main'           AS SHT_NM, 'SEARCH' AS MNU_BTN_CD, 'P_DMF0021_MAIN_RETRIEVE'      AS API_ID FROM DUAL UNION ALL
    SELECT 'main',                      'SAVE',                 'P_DMF0021_MAIN_SAVE'                    FROM DUAL UNION ALL
    SELECT 'measureInfo',               'SEARCH',               'P_DMF0021_MEASURE_RETRIEVE'             FROM DUAL UNION ALL
    SELECT 'measureInfo2',              'SEARCH',               'P_DMF0021_MEASURE2_RETRIEVE'            FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X WHERE X.MNU_ID='DMF0021' AND X.SHT_NM=NEW.SHT_NM AND X.MNU_BTN_CD=NEW.MNU_BTN_CD);

PROMPT === BLOCK 7 : 권한 (GUEST + minyonglee1) ===
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.USER_GR_ID, 'DMF0021', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'GUEST' AS USER_GR_ID FROM DUAL UNION ALL
    SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G WHERE G.USER_ID = 'minyonglee1' AND G.USE_YN = 'Y'
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M X WHERE X.USER_GR_ID=NEW.USER_GR_ID AND X.MNU_ID='DMF0021');

INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT GR.USER_GR_ID, BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
  CROSS JOIN (
    SELECT 'GUEST' AS USER_GR_ID FROM DUAL UNION ALL
    SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G WHERE G.USER_ID = 'minyonglee1' AND G.USE_YN = 'Y'
  ) GR
 WHERE BTN.MNU_ID='DMF0021' AND BTN.USE_YN='Y'
   AND NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X WHERE X.USER_GR_ID=GR.USER_GR_ID AND X.MNU_ID=BTN.MNU_ID AND X.SHT_NM=BTN.SHT_NM AND X.MNU_BTN_CD=BTN.MNU_BTN_CD);

PROMPT === POST: 사후 카운트 ===
SELECT 'POST: MNU'         AS K, COUNT(*) AS V FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0021'
UNION ALL SELECT 'POST: API',          COUNT(*) FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE 'P_DMF0021%'
UNION ALL SELECT 'POST: BTN_MPG',      COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0021'
UNION ALL SELECT 'POST: PROC_M',       COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE 'DMF0021%'
UNION ALL SELECT 'POST: SHEET_COLS',   COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0021'
UNION ALL SELECT 'POST: MSG',          COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID LIKE 'MSG_API_DMF0021%'
UNION ALL SELECT 'POST: GUEST MNU',    COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE USER_GR_ID='GUEST' AND MNU_ID='DMF0021'
UNION ALL SELECT 'POST: GUEST BTN',    COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE USER_GR_ID='GUEST' AND MNU_ID='DMF0021';

COMMIT;
EXIT;
