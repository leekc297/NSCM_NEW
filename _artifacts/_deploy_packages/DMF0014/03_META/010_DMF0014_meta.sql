--==============================================================================
-- 010_DMF0014_meta.sql — DMF0014 CustFcstUpload 메타 SQL 7-BLOCK
--   AS-IS .cs 1,275줄 / PKG body 5 SP (메인 조회 + 헤더 + Save + Excel Upload + SM)
--   메뉴 위치: Demand > Demand_Plan > Customer FCST Upload (UPPR_MNU_ID='Demand_Plan')
--   FE 폴더: nscm-fe/features/demand/src/pages/customer-fcst-upload/ (부분 구현 존재)
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : MSG_M (5) ===
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM, MSG_DESC, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, 'KO', 'API', NEW.MSG_NM, NEW.MSG_NM, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'MSG_API_DMF0014_MAIN_RETRIEVE'        AS MSG_ID, 'Customer FCST Upload 조회' AS MSG_NM FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0014_TITLE_RETRIEVE',                'Customer FCST Upload 헤더 조회'         FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0014_MAIN_SAVE',                     'Customer FCST Upload 저장'              FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0014_EXCEL_UPLOAD',                  'Excel Upload 메인'                     FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0014_EXCEL_UPLOAD_SM',               'Excel Upload Small 사업부'             FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID=NEW.MSG_ID AND X.LANG_CD='KO');

PROMPT === BLOCK 2 : MNU_M (1 row) ===
INSERT INTO SCM_MGR.SCM_ADM_MNU_M (MNU_ID, UPPR_MNU_ID, MNU_NM, MNU_DESC, MNU_LVL, MNU_TP_CD, MNU_URL, MNU_ORD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0014', 'Demand_Plan', 'Customer FCST Upload', 'Customer FCST Upload (Excel Upload 패턴 — G4 Batch)', 3, 'SCREEN', 'customer-fcst-upload', 80, 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0014');

PROMPT === BLOCK 3 : SHEET_COLUMNS (15 BASE cols + EditFlag, 동적 시간축은 SpreadTitle SP) ===
INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS (PROGRAM_ID, SHT_NM, SORT_ORD, COLUMN_NAME, HDR_NM, WIDTH, ALIGN_CD, CTRL_TP_CD, INPUT_TP_CD, MERGE_YN, FRZ_YN, VISIBLE_YN, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0014', 'customerFcstUpload', NEW.SORT_ORD, NEW.COLUMN_NAME, NEW.HDR_NM, NEW.WIDTH, NEW.ALIGN_CD, NEW.CTRL_TP_CD, NEW.INPUT_TP_CD, 'Y', 'Y', 'Y', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT  1 AS SORT_ORD, 'DIVISION_ID'           AS COLUMN_NAME, 'Division*'        AS HDR_NM,  60 AS WIDTH, 'L' AS ALIGN_CD, 'FPComboBox' AS CTRL_TP_CD, 'IM' AS INPUT_TP_CD FROM DUAL UNION ALL
    SELECT  2,            'SCM_SITE_ID',                          'Sales Site*',                   60,         'L',             'FPComboBox',                'IM' FROM DUAL UNION ALL
    SELECT  3,            'PLANT_SITE_ID',                        'Plant Site*',                   60,         'L',             'FPComboBox',                'IM' FROM DUAL UNION ALL
    SELECT  4,            'CUSTOMER_PROJECT_CODE',                'Customer Project*',             60,         'L',             'FPText',                    'IM' FROM DUAL UNION ALL
    SELECT  5,            'CUSTOMER_MODEL',                       'Customer Model*',               60,         'L',             'FPText',                    'IM' FROM DUAL UNION ALL
    SELECT  6,            'INCOTERMS',                            'Incoterms*',                    40,         'L',             'FPComboBox',                'IM' FROM DUAL UNION ALL
    SELECT  7,            'FCST_TYPE',                            'FCST Type*',                    40,         'L',             'FPComboBox',                'IM' FROM DUAL UNION ALL
    SELECT  8,            'DOM_EXP',                              'Customs Handbook*',             60,         'L',             'FPComboBox',                'IM' FROM DUAL UNION ALL
    SELECT  9,            'MEASURE_GROUP',                        'Measure Group*',                60,         'L',             'FPText',                    'IM' FROM DUAL UNION ALL
    SELECT 10,            'MEASURE',                              'Measure*',                      40,         'L',             'FPComboBox',                'IM' FROM DUAL UNION ALL
    SELECT 11,            'UPLOAD_UOM',                           'Upload UOM*',                   40,         'L',             'FPComboBox',                'IM' FROM DUAL UNION ALL
    SELECT 12,            'PROJECT_CODE',                         'Project',                       80,         'L',             'FPModal',                   'IO' FROM DUAL UNION ALL
    SELECT 13,            'ITEM_ID',                              'Model',                        100,         'L',             'FPModal',                   'IO' FROM DUAL UNION ALL
    SELECT 14,            'EDIT_FLAG',                            'EDIT_FLAG',                      0,         'L',             'FPText',                    'S'  FROM DUAL UNION ALL
    SELECT 15,            'USER_ID',                              'User ID',                       80,         'L',             'FPText',                    'S'  FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS X WHERE X.PROGRAM_ID='DMF0014' AND X.SHT_NM='customerFcstUpload' AND X.COLUMN_NAME=NEW.COLUMN_NAME);

PROMPT === BLOCK 4 : PROC_M (메인 조회 17 + 헤더 7 + Save 19 + ExcelUpload 5 + SM 3 = 51) ===
INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.PROC_NM, NEW.COL_NM, NEW.DATA_TP_CD, NEW.COL_TP_CD, NEW.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    -- P_DMF0014_GET_CUST_FCST_UPLOAD_DATA (15 IN + 2 OUT = 17)
    SELECT 'DMF0014_GET_CUST_FCST_UPLOAD_DATA' AS PROC_NM, 'divisionId'     AS COL_NM, 'VARCHAR' AS DATA_TP_CD, 'IN'  AS COL_TP_CD,  1 AS SORT_ORD FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_CUST_FCST_UPLOAD_DATA',           'deptId',                    'VARCHAR',               'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_CUST_FCST_UPLOAD_DATA',           'endCustomer',               'VARCHAR',               'IN',                3 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_CUST_FCST_UPLOAD_DATA',           'scmSiteId',                 'VARCHAR',               'IN',                4 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_CUST_FCST_UPLOAD_DATA',           'plantSiteId',               'VARCHAR',               'IN',                5 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_CUST_FCST_UPLOAD_DATA',           'projectCode',               'VARCHAR',               'IN',                6 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_CUST_FCST_UPLOAD_DATA',           'itemId',                    'VARCHAR',               'IN',                7 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_CUST_FCST_UPLOAD_DATA',           'startYyyymmdd',             'VARCHAR',               'IN',                8 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_CUST_FCST_UPLOAD_DATA',           'endYyyymmdd',               'VARCHAR',               'IN',                9 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_CUST_FCST_UPLOAD_DATA',           'bucketType',                'VARCHAR',               'IN',               10 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_CUST_FCST_UPLOAD_DATA',           'domExp',                    'VARCHAR',               'IN',               11 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_CUST_FCST_UPLOAD_DATA',           'sesUserId',                 'VARCHAR',               'IN',               12 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_CUST_FCST_UPLOAD_DATA',           'sesGroupId',                'VARCHAR',               'IN',               13 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_CUST_FCST_UPLOAD_DATA',           'sesUserIdDup',              'VARCHAR',               'IN',               14 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_CUST_FCST_UPLOAD_DATA',           'mnuId',                     'VARCHAR',               'IN',               15 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_CUST_FCST_UPLOAD_DATA',           'o_rc1',                     'CURSOR',                'OUT',              16 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_CUST_FCST_UPLOAD_DATA',           'O_RESULT_CURSOR',           'PROC_RESULT',           'OUT',              17 FROM DUAL UNION ALL
    -- P_DMF0014_GET_SPREAD_TITLE (5 IN + 2 OUT = 7)
    SELECT 'DMF0014_GET_SPREAD_TITLE',                    'startYyyymmdd',             'VARCHAR',               'IN',                1 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_SPREAD_TITLE',                    'endYyyymmdd',               'VARCHAR',               'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_SPREAD_TITLE',                    'bucketType',                'VARCHAR',               'IN',                3 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_SPREAD_TITLE',                    'sesUserId',                 'VARCHAR',               'IN',                4 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_SPREAD_TITLE',                    'mnuId',                     'VARCHAR',               'IN',                5 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_SPREAD_TITLE',                    'o_rc1',                     'CURSOR',                'OUT',               6 FROM DUAL UNION ALL
    SELECT 'DMF0014_GET_SPREAD_TITLE',                    'O_RESULT_CURSOR',           'PROC_RESULT',           'OUT',               7 FROM DUAL UNION ALL
    -- P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA (17 IN + 1 OUT = 18)
    SELECT 'DMF0014_SAVE_CUST_FCST_UPLOAD_DATA',          'activeFlag',                'VARCHAR',               'IN',                1 FROM DUAL UNION ALL
    SELECT 'DMF0014_SAVE_CUST_FCST_UPLOAD_DATA',          'divisionId',                'VARCHAR',               'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0014_SAVE_CUST_FCST_UPLOAD_DATA',          'scmSiteId',                 'VARCHAR',               'IN',                3 FROM DUAL UNION ALL
    SELECT 'DMF0014_SAVE_CUST_FCST_UPLOAD_DATA',          'customerProjectCode',       'VARCHAR',               'IN',                4 FROM DUAL UNION ALL
    SELECT 'DMF0014_SAVE_CUST_FCST_UPLOAD_DATA',          'customerModel',             'VARCHAR',               'IN',                5 FROM DUAL UNION ALL
    SELECT 'DMF0014_SAVE_CUST_FCST_UPLOAD_DATA',          'incoterms',                 'VARCHAR',               'IN',                6 FROM DUAL UNION ALL
    SELECT 'DMF0014_SAVE_CUST_FCST_UPLOAD_DATA',          'fcstType',                  'VARCHAR',               'IN',                7 FROM DUAL UNION ALL
    SELECT 'DMF0014_SAVE_CUST_FCST_UPLOAD_DATA',          'domExp',                    'VARCHAR',               'IN',                8 FROM DUAL UNION ALL
    SELECT 'DMF0014_SAVE_CUST_FCST_UPLOAD_DATA',          'measureGroup',              'VARCHAR',               'IN',                9 FROM DUAL UNION ALL
    SELECT 'DMF0014_SAVE_CUST_FCST_UPLOAD_DATA',          'measure',                   'VARCHAR',               'IN',               10 FROM DUAL UNION ALL
    SELECT 'DMF0014_SAVE_CUST_FCST_UPLOAD_DATA',          'plantSiteId',               'VARCHAR',               'IN',               11 FROM DUAL UNION ALL
    SELECT 'DMF0014_SAVE_CUST_FCST_UPLOAD_DATA',          'uploadUom',                 'VARCHAR',               'IN',               12 FROM DUAL UNION ALL
    SELECT 'DMF0014_SAVE_CUST_FCST_UPLOAD_DATA',          'projectCode',               'VARCHAR',               'IN',               13 FROM DUAL UNION ALL
    SELECT 'DMF0014_SAVE_CUST_FCST_UPLOAD_DATA',          'itemId',                    'VARCHAR',               'IN',               14 FROM DUAL UNION ALL
    SELECT 'DMF0014_SAVE_CUST_FCST_UPLOAD_DATA',          'yyyymmdd',                  'VARCHAR',               'IN',               15 FROM DUAL UNION ALL
    SELECT 'DMF0014_SAVE_CUST_FCST_UPLOAD_DATA',          'qty',                       'VARCHAR',               'IN',               16 FROM DUAL UNION ALL
    SELECT 'DMF0014_SAVE_CUST_FCST_UPLOAD_DATA',          'sesUserId',                 'VARCHAR',               'IN',               17 FROM DUAL UNION ALL
    SELECT 'DMF0014_SAVE_CUST_FCST_UPLOAD_DATA',          'O_RESULT_CURSOR',           'PROC_RESULT',           'OUT',              18 FROM DUAL UNION ALL
    -- P_DMF0014_CUST_FCST_EXCEL_UPLOAD (4 IN + 1 OUT = 5)
    SELECT 'DMF0014_CUST_FCST_EXCEL_UPLOAD',              'mode',                      'INTEGER',               'IN',                1 FROM DUAL UNION ALL
    SELECT 'DMF0014_CUST_FCST_EXCEL_UPLOAD',              'sesUserId',                 'VARCHAR',               'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0014_CUST_FCST_EXCEL_UPLOAD',              'programId',                 'VARCHAR',               'IN',                3 FROM DUAL UNION ALL
    SELECT 'DMF0014_CUST_FCST_EXCEL_UPLOAD',              'sheetName',                 'VARCHAR',               'IN',                4 FROM DUAL UNION ALL
    SELECT 'DMF0014_CUST_FCST_EXCEL_UPLOAD',              'O_RESULT_CURSOR',           'PROC_RESULT',           'OUT',               5 FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_PROC_M X WHERE X.PROC_NM=NEW.PROC_NM AND X.COL_NM=NEW.COL_NM AND X.COL_TP_CD=NEW.COL_TP_CD);

PROMPT === BLOCK 5 : API_M (4 endpoint) ===
INSERT INTO SCM_MGR.SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.API_ID, NEW.API_TP_CD, NEW.API_MSG_ID, NEW.API_MSG_DESC, NEW.API_URL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'P_DMF0014_MAIN_RETRIEVE'  AS API_ID, 'PROC_SELECT' AS API_TP_CD, 'MSG_API_DMF0014_MAIN_RETRIEVE'  AS API_MSG_ID, '메인 조회'              AS API_MSG_DESC, 'PKG_DMF0014.P_DMF0014_GET_CUST_FCST_UPLOAD_DATA' AS API_URL FROM DUAL UNION ALL
    SELECT 'P_DMF0014_TITLE_RETRIEVE',           'PROC_SELECT',              'MSG_API_DMF0014_TITLE_RETRIEVE',                '동적 헤더 조회',                         'PKG_DMF0014.P_DMF0014_GET_SPREAD_TITLE'              FROM DUAL UNION ALL
    SELECT 'P_DMF0014_MAIN_SAVE',                'PROC_SAVE',                'MSG_API_DMF0014_MAIN_SAVE',                     '저장 (17 IN)',                          'PKG_DMF0014.P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA'    FROM DUAL UNION ALL
    SELECT 'P_DMF0014_EXCEL_UPLOAD',             'PROC_BATCH',               'MSG_API_DMF0014_EXCEL_UPLOAD',                  'Excel Upload (Mode 1/2/3)',             'PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD'        FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_API_M X WHERE X.API_ID=NEW.API_ID);

PROMPT === BLOCK 6 : MNU_BTN_MPG_M (4) ===
INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0014', NEW.SHT_NM, NEW.MNU_BTN_CD, NEW.API_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'customerFcstUpload' AS SHT_NM, 'SEARCH'       AS MNU_BTN_CD, 'P_DMF0014_MAIN_RETRIEVE'  AS API_ID FROM DUAL UNION ALL
    SELECT 'customerFcstUpload',            'SAVE',                       'P_DMF0014_MAIN_SAVE'                FROM DUAL UNION ALL
    SELECT 'customerFcstUpload',            'UPLOAD',                     'P_DMF0014_EXCEL_UPLOAD'             FROM DUAL UNION ALL
    SELECT 'spreadTitle',                   'SEARCH',                     'P_DMF0014_TITLE_RETRIEVE'           FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X WHERE X.MNU_ID='DMF0014' AND X.SHT_NM=NEW.SHT_NM AND X.MNU_BTN_CD=NEW.MNU_BTN_CD);

PROMPT === BLOCK 7 : 권한 (GUEST + minyonglee1) ===
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.USER_GR_ID, 'DMF0014', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'GUEST' AS USER_GR_ID FROM DUAL UNION ALL
    SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G WHERE G.USER_ID = 'minyonglee1' AND G.USE_YN = 'Y'
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M X WHERE X.USER_GR_ID=NEW.USER_GR_ID AND X.MNU_ID='DMF0014');

INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT GR.USER_GR_ID, BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
  CROSS JOIN (
    SELECT 'GUEST' AS USER_GR_ID FROM DUAL UNION ALL
    SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G WHERE G.USER_ID = 'minyonglee1' AND G.USE_YN = 'Y'
  ) GR
 WHERE BTN.MNU_ID='DMF0014' AND BTN.USE_YN='Y'
   AND NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X WHERE X.USER_GR_ID=GR.USER_GR_ID AND X.MNU_ID=BTN.MNU_ID AND X.SHT_NM=BTN.SHT_NM AND X.MNU_BTN_CD=BTN.MNU_BTN_CD);

PROMPT === POST: 사후 카운트 ===
SELECT 'POST: MNU'         AS K, COUNT(*) AS V FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0014'
UNION ALL SELECT 'POST: API',          COUNT(*) FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE 'P_DMF0014%'
UNION ALL SELECT 'POST: BTN_MPG',      COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0014'
UNION ALL SELECT 'POST: PROC_M',       COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE 'DMF0014%'
UNION ALL SELECT 'POST: SHEET_COLS',   COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0014'
UNION ALL SELECT 'POST: MSG',          COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID LIKE 'MSG_API_DMF0014%'
UNION ALL SELECT 'POST: GUEST MNU',    COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE USER_GR_ID='GUEST' AND MNU_ID='DMF0014'
UNION ALL SELECT 'POST: GUEST BTN',    COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE USER_GR_ID='GUEST' AND MNU_ID='DMF0014';

COMMIT;
EXIT;
