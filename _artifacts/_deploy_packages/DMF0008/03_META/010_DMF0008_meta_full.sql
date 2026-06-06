--==============================================================================
-- 43_DMF0008_meta.sql
-- DMF0008 (ERP EDI Master) 화면 메타.
-- standalone SP 6개 모두 VALID → PROC_M / API_M / BTN_MPG / GUEST 권한 신규 등록.
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : MSG_M (6 API 메시지) ===

INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM, MSG_DESC, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, 'KO', 'API', NEW.MSG_NM, NEW.MSG_NM, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'MSG_API_DMF0008_SUMMARY_GET'   AS MSG_ID, 'EDI Master 요약 조회'         AS MSG_NM FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0008_REPAIR_GET',             'EDI Master 수정 조회'                  FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0008_SITE_GET',               'Sales Site 조회'                       FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0008_PROJECT_GET',            'Project Model 조회'                    FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0008_REPAIR_SAVE',            'EDI Master 저장'                       FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0008_PROJECT_SAVE',           'Project Model 저장'                    FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID = NEW.MSG_ID AND X.LANG_CD = 'KO'
 );

PROMPT === BLOCK 2 : API_M (6 건) ===

INSERT INTO SCM_MGR.SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.API_ID, NEW.API_TP_CD, NEW.API_MSG_ID, NEW.API_MSG_DESC, NEW.API_URL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'P_DMF0008_SUMMARY_GET'  AS API_ID, 'PROC_SELECT' AS API_TP_CD, 'MSG_API_DMF0008_SUMMARY_GET' AS API_MSG_ID, '요약 조회'   AS API_MSG_DESC, 'DMF0008_GET_EDI_MST_SUMMARY'               AS API_URL FROM DUAL UNION ALL
    SELECT 'P_DMF0008_REPAIR_GET',          'PROC_SELECT',              'MSG_API_DMF0008_REPAIR_GET',                '수정 조회',                  'DMF0008_GET_EDI_MST_REPAIR'                          FROM DUAL UNION ALL
    SELECT 'P_DMF0008_SITE_GET',            'PROC_SELECT',              'MSG_API_DMF0008_SITE_GET',                  'Sales Site',                 'DMF0008_GET_SALES_SITE'                              FROM DUAL UNION ALL
    SELECT 'P_DMF0008_PROJECT_GET',         'PROC_SELECT',              'MSG_API_DMF0008_PROJECT_GET',               'Project Model',              'DMF0008_GET_SALES_SITE_PROJECT_MODEL'                FROM DUAL UNION ALL
    SELECT 'P_DMF0008_REPAIR_SAVE',         'PROC_SAVE',                'MSG_API_DMF0008_REPAIR_SAVE',               'EDI Master 저장',            'DMF0008_SAVE_SALES_SITE_EDI_REPAIR'                  FROM DUAL UNION ALL
    SELECT 'P_DMF0008_PROJECT_SAVE',        'PROC_SAVE',                'MSG_API_DMF0008_PROJECT_SAVE',              'Project Model 저장',         'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR'          FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_API_M X WHERE X.API_ID = NEW.API_ID
 );

PROMPT === BLOCK 3 : BTN_MPG (6 건) ===

INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0008', NEW.SHT_NM, NEW.MNU_BTN_CD, NEW.API_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'summary'  AS SHT_NM, 'SEARCH' AS MNU_BTN_CD, 'P_DMF0008_SUMMARY_GET' AS API_ID FROM DUAL UNION ALL
    SELECT 'repair',           'SEARCH',                'P_DMF0008_REPAIR_GET'           FROM DUAL UNION ALL
    SELECT 'repair',           'SAVE',                  'P_DMF0008_REPAIR_SAVE'          FROM DUAL UNION ALL
    SELECT 'site',             'SEARCH',                'P_DMF0008_SITE_GET'             FROM DUAL UNION ALL
    SELECT 'project',          'SEARCH',                'P_DMF0008_PROJECT_GET'          FROM DUAL UNION ALL
    SELECT 'project',          'SAVE',                  'P_DMF0008_PROJECT_SAVE'         FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X
    WHERE X.MNU_ID='DMF0008' AND X.SHT_NM=NEW.SHT_NM AND X.MNU_BTN_CD=NEW.MNU_BTN_CD
 );

PROMPT === BLOCK 4 : PROC_M (6 SP × 인자) ===

INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.PROC_NM, NEW.COL_NM, NEW.DATA_TP_CD, NEW.COL_TP_CD, NEW.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    -- 1. GET_EDI_MST_REPAIR
    SELECT 'DMF0008_GET_EDI_MST_REPAIR'    AS PROC_NM, 'divisionId'         AS COL_NM, 'VARCHAR' AS DATA_TP_CD, 'IN'  AS COL_TP_CD, 1 AS SORT_ORD FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_EDI_MST_REPAIR',              'fromYyyymmdd',                    'VARCHAR',               'IN',               2 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_EDI_MST_REPAIR',              'toYyyymmdd',                      'VARCHAR',               'IN',               3 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_EDI_MST_REPAIR',              'senderName',                      'VARCHAR',               'IN',               4 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_EDI_MST_REPAIR',              'flag',                            'VARCHAR',               'IN',               5 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_EDI_MST_REPAIR',              'sesUserId',                       'VARCHAR',               'IN',               6 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_EDI_MST_REPAIR',              'mnuId',                           'VARCHAR',               'IN',               7 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_EDI_MST_REPAIR',              'o_rc1',                           'CURSOR',                'OUT',              8 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_EDI_MST_REPAIR',              'O_RESULT_CURSOR',                 'PROC_RESULT',           'OUT',              9 FROM DUAL UNION ALL
    -- 2. GET_EDI_MST_SUMMARY
    SELECT 'DMF0008_GET_EDI_MST_SUMMARY',             'fromYyyymmdd',                    'VARCHAR',               'IN',               1 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_EDI_MST_SUMMARY',             'toYyyymmdd',                      'VARCHAR',               'IN',               2 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_EDI_MST_SUMMARY',             'divisionId',                      'VARCHAR',               'IN',               3 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_EDI_MST_SUMMARY',             'sesUserId',                       'VARCHAR',               'IN',               4 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_EDI_MST_SUMMARY',             'mnuId',                           'VARCHAR',               'IN',               5 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_EDI_MST_SUMMARY',             'o_rc1',                           'CURSOR',                'OUT',              6 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_EDI_MST_SUMMARY',             'o_rc3',                           'CURSOR',                'OUT',              7 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_EDI_MST_SUMMARY',             'O_RESULT_CURSOR',                 'PROC_RESULT',           'OUT',              8 FROM DUAL UNION ALL
    -- 3. GET_SALES_SITE
    SELECT 'DMF0008_GET_SALES_SITE',                  'divisionId',                      'VARCHAR',               'IN',               1 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_SALES_SITE',                  'soldto',                          'VARCHAR',               'IN',               2 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_SALES_SITE',                  'shipto',                          'VARCHAR',               'IN',               3 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_SALES_SITE',                  'scmSiteId',                       'VARCHAR',               'IN',               4 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_SALES_SITE',                  'O_RESULT_CURSOR',                 'PROC_RESULT',           'OUT',              5 FROM DUAL UNION ALL
    -- 4. GET_SALES_SITE_PROJECT_MODEL
    SELECT 'DMF0008_GET_SALES_SITE_PROJECT_MODEL',    'divisionId',                      'VARCHAR',               'IN',               1 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_SALES_SITE_PROJECT_MODEL',    'itemId',                          'VARCHAR',               'IN',               2 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_SALES_SITE_PROJECT_MODEL',    'scmSiteId',                       'VARCHAR',               'IN',               3 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_SALES_SITE_PROJECT_MODEL',    'sesUserId',                       'VARCHAR',               'IN',               4 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_SALES_SITE_PROJECT_MODEL',    'mnuId',                           'VARCHAR',               'IN',               5 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_SALES_SITE_PROJECT_MODEL',    'o_rc1',                           'CURSOR',                'OUT',              6 FROM DUAL UNION ALL
    SELECT 'DMF0008_GET_SALES_SITE_PROJECT_MODEL',    'O_RESULT_CURSOR',                 'PROC_RESULT',           'OUT',              7 FROM DUAL UNION ALL
    -- 5. SAVE_SALES_SITE_EDI_REPAIR
    SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR',      'divisionId',                      'VARCHAR',               'IN',               1 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR',      'endCustomer',                     'VARCHAR',               'IN',               2 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR',      'soldtoCustomer',                  'VARCHAR',               'IN',               3 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR',      'companyId',                       'VARCHAR',               'IN',               4 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR',      'scmSiteId',                       'VARCHAR',               'IN',               5 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR',      'soldtoCode',                      'VARCHAR',               'IN',               6 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR',      'shiptoCode',                      'VARCHAR',               'IN',               7 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR',      'vmiYn',                           'VARCHAR',               'IN',               8 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR',      'validYn',                         'VARCHAR',               'IN',               9 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR',      'custValidYn',                     'VARCHAR',               'IN',              10 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR',      'repYn',                           'VARCHAR',               'IN',              11 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR',      'country',                         'VARCHAR',               'IN',              12 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR',      'city',                            'VARCHAR',               'IN',              13 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR',      'shipPlanAuto',                    'VARCHAR',               'IN',              14 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR',      'deptId',                          'VARCHAR',               'IN',              15 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR',      'sesUserId',                       'VARCHAR',               'IN',              16 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR',      'p_message_cursor',                'CURSOR',                'OUT',             17 FROM DUAL UNION ALL
    -- 6. SAVE_SALES_SITE_PROJECT_EDI_REPAIR
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','divisionId',                    'VARCHAR',               'IN',               1 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','projectCode',                   'VARCHAR',               'IN',               2 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','scmSiteId',                     'VARCHAR',               'IN',               3 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','itemId',                        'VARCHAR',               'IN',               4 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','currency',                      'VARCHAR',               'IN',               5 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','kwh',                           'VARCHAR',               'IN',               6 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','cellPerCar',                    'VARCHAR',               'IN',               7 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','cellPerModule',                 'VARCHAR',               'IN',               8 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','liabilityPeriod',               'VARCHAR',               'IN',               9 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','validYn',                       'VARCHAR',               'IN',              10 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','bpmsExist',                     'VARCHAR',               'IN',              11 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','salesCompany',                  'VARCHAR',               'IN',              12 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','salesPlant',                    'VARCHAR',               'IN',              13 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','moduleVariant',                 'VARCHAR',               'IN',              14 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','incoterms',                     'VARCHAR',               'IN',              15 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','sesUserId',                     'VARCHAR',               'IN',              16 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','o_rc1',                         'CURSOR',                'OUT',             17 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','o_rc2',                         'CURSOR',                'OUT',             18 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','o_rc3',                         'CURSOR',                'OUT',             19 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','o_rc4',                         'CURSOR',                'OUT',             20 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','o_rc5',                         'CURSOR',                'OUT',             21 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','o_rc6',                         'CURSOR',                'OUT',             22 FROM DUAL UNION ALL
    SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR','O_RESULT_CURSOR',               'PROC_RESULT',           'OUT',             23 FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_PROC_M X WHERE X.PROC_NM = NEW.PROC_NM AND X.COL_NM = NEW.COL_NM AND X.COL_TP_CD = NEW.COL_TP_CD
 );

PROMPT === BLOCK 5 : GUEST 권한 ===

INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'GUEST', BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
 WHERE BTN.MNU_ID = 'DMF0008' AND BTN.USE_YN = 'Y'
   AND NOT EXISTS (
     SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X
      WHERE X.USER_GR_ID='GUEST' AND X.MNU_ID=BTN.MNU_ID AND X.SHT_NM=BTN.SHT_NM AND X.MNU_BTN_CD=BTN.MNU_BTN_CD
   );

PROMPT === BLOCK 6 : 사후 카운트 ===

SELECT 'POST: API_M' AS K, COUNT(*) AS V FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE 'P_DMF0008%'
UNION ALL
SELECT 'POST: BTN_MPG', COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0008'
UNION ALL
SELECT 'POST: PROC_M', COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE 'DMF0008_%'
UNION ALL
SELECT 'POST: GUEST BTN', COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE USER_GR_ID='GUEST' AND MNU_ID='DMF0008';

COMMIT;
EXIT;
