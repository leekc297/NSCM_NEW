--==============================================================================
-- 45_DMF0020_meta.sql — DMF0020 (Sales Future Price)
--   VALID 15 SP 중 핵심 5개 등록 (메인/헤더/오너/주간/저장)
--   INVALID 4 SP (GET_SALES_PRICE_TEMPLATE, GET_SCM_MST_FUTURE_PRICE,
--                 SAVE_SCM_MST_FUTURE_PRICE_ALL/POPUP) 는 후속 보강
--     - 원인: SCM_MGR.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE 미존재 + 일부 테이블 미존재
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : MSG_M (5) ===
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM, MSG_DESC, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, 'KO', 'API', NEW.MSG_NM, NEW.MSG_NM, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'MSG_API_DMF0020_FUTURE_GET'   AS MSG_ID, 'Sales Future Price 조회' AS MSG_NM FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0020_TITLE_GET',             'Spread Header 조회'                FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0020_OWNER_GET',             'Owner 조회'                        FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0020_WEEK_GET',              'Week Data 조회'                    FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0020_EXRATE_SAVE',           '환율 저장'                          FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID=NEW.MSG_ID AND X.LANG_CD='KO');

PROMPT === BLOCK 2 : API_M (5) ===
INSERT INTO SCM_MGR.SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.API_ID, NEW.API_TP_CD, NEW.API_MSG_ID, NEW.API_MSG_DESC, NEW.API_URL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'P_DMF0020_FUTURE_GET'   AS API_ID, 'PROC_SELECT' AS API_TP_CD, 'MSG_API_DMF0020_FUTURE_GET'  AS API_MSG_ID, '메인 조회' AS API_MSG_DESC, 'DMF0020_GET_FUTUREPRICE_INFO'         AS API_URL FROM DUAL UNION ALL
    SELECT 'P_DMF0020_TITLE_GET',             'PROC_SELECT',              'MSG_API_DMF0020_TITLE_GET',              '헤더 조회',               'DMF0020_GET_SPREAD_TITLE'                       FROM DUAL UNION ALL
    SELECT 'P_DMF0020_OWNER_GET',             'PROC_SELECT',              'MSG_API_DMF0020_OWNER_GET',              'Owner',                  'DMF0020_GET_OWNER_DATA'                         FROM DUAL UNION ALL
    SELECT 'P_DMF0020_WEEK_GET',              'PROC_SELECT',              'MSG_API_DMF0020_WEEK_GET',               'Week',                   'DMF0020_GET_WEEKDATA'                           FROM DUAL UNION ALL
    SELECT 'P_DMF0020_EXRATE_SAVE',           'PROC_SAVE',                'MSG_API_DMF0020_EXRATE_SAVE',            '환율 저장',               'DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL'          FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_API_M X WHERE X.API_ID=NEW.API_ID);

PROMPT === BLOCK 3 : BTN_MPG (5) ===
INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0020', NEW.SHT_NM, NEW.MNU_BTN_CD, NEW.API_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'main'      AS SHT_NM, 'SEARCH' AS MNU_BTN_CD, 'P_DMF0020_FUTURE_GET' AS API_ID FROM DUAL UNION ALL
    SELECT 'mainTitle',           'SEARCH',                'P_DMF0020_TITLE_GET'           FROM DUAL UNION ALL
    SELECT 'owner',               'SEARCH',                'P_DMF0020_OWNER_GET'           FROM DUAL UNION ALL
    SELECT 'week',                'SEARCH',                'P_DMF0020_WEEK_GET'            FROM DUAL UNION ALL
    SELECT 'exchange',            'SAVE',                  'P_DMF0020_EXRATE_SAVE'         FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X WHERE X.MNU_ID='DMF0020' AND X.SHT_NM=NEW.SHT_NM AND X.MNU_BTN_CD=NEW.MNU_BTN_CD);

PROMPT === BLOCK 4 : PROC_M (5 SP × 인자) ===
INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.PROC_NM, NEW.COL_NM, NEW.DATA_TP_CD, NEW.COL_TP_CD, NEW.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    -- GET_FUTUREPRICE_INFO
    SELECT 'DMF0020_GET_FUTUREPRICE_INFO' AS PROC_NM, 'startYyyymmdd' AS COL_NM, 'VARCHAR' AS DATA_TP_CD, 'IN' AS COL_TP_CD, 1 AS SORT_ORD FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_FUTUREPRICE_INFO',           'endYyyymmdd',              'VARCHAR',               'IN',               2 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_FUTUREPRICE_INFO',           'sesUserId',                'VARCHAR',               'IN',               3 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_FUTUREPRICE_INFO',           'mnuId',                    'VARCHAR',               'IN',               4 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_FUTUREPRICE_INFO',           'o_rc1',                    'CURSOR',                'OUT',              5 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_FUTUREPRICE_INFO',           'O_RESULT_CURSOR',          'PROC_RESULT',           'OUT',              6 FROM DUAL UNION ALL
    -- GET_SPREAD_TITLE
    SELECT 'DMF0020_GET_SPREAD_TITLE',               'startDt',                  'VARCHAR',               'IN',               1 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_SPREAD_TITLE',               'endDt',                    'VARCHAR',               'IN',               2 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_SPREAD_TITLE',               'sesUserId',                'VARCHAR',               'IN',               3 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_SPREAD_TITLE',               'divisionId',               'VARCHAR',               'IN',               4 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_SPREAD_TITLE',               'o_rc1',                    'CURSOR',                'OUT',              5 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_SPREAD_TITLE',               'O_RESULT_CURSOR',          'PROC_RESULT',           'OUT',              6 FROM DUAL UNION ALL
    -- GET_OWNER_DATA
    SELECT 'DMF0020_GET_OWNER_DATA',                 'divisionId',               'VARCHAR',               'IN',               1 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_OWNER_DATA',                 'deptId',                   'VARCHAR',               'IN',               2 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_OWNER_DATA',                 'endCustomer',              'VARCHAR',               'IN',               3 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_OWNER_DATA',                 'projectCode',              'VARCHAR',               'IN',               4 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_OWNER_DATA',                 'scmSiteId',                'VARCHAR',               'IN',               5 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_OWNER_DATA',                 'ownerId',                  'VARCHAR',               'IN',               6 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_OWNER_DATA',                 'sesUserId',                'VARCHAR',               'IN',               7 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_OWNER_DATA',                 'mnuId',                    'VARCHAR',               'IN',               8 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_OWNER_DATA',                 'o_rc1',                    'CURSOR',                'OUT',              9 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_OWNER_DATA',                 'O_RESULT_CURSOR',          'PROC_RESULT',           'OUT',             10 FROM DUAL UNION ALL
    -- GET_WEEKDATA
    SELECT 'DMF0020_GET_WEEKDATA',                   'yyyymmdd',                 'VARCHAR',               'IN',               1 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_WEEKDATA',                   'o_rc1',                    'CURSOR',                'OUT',              2 FROM DUAL UNION ALL
    SELECT 'DMF0020_GET_WEEKDATA',                   'O_RESULT_CURSOR',          'PROC_RESULT',           'OUT',              3 FROM DUAL UNION ALL
    -- SAVE_DM_MST_EXCHANGE_RATE_ALL
    SELECT 'DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL',  'activeFlag',               'VARCHAR',               'IN',               1 FROM DUAL UNION ALL
    SELECT 'DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL',  'divisionId',               'VARCHAR',               'IN',               2 FROM DUAL UNION ALL
    SELECT 'DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL',  'yyyymmdd',                 'VARCHAR',               'IN',               3 FROM DUAL UNION ALL
    SELECT 'DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL',  'currency',                 'VARCHAR',               'IN',               4 FROM DUAL UNION ALL
    SELECT 'DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL',  'unitCurrency',             'VARCHAR',               'IN',               5 FROM DUAL UNION ALL
    SELECT 'DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL',  'exchangePrice',            'VARCHAR',               'IN',               6 FROM DUAL UNION ALL
    SELECT 'DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL',  'sesUserId',                'VARCHAR',               'IN',               7 FROM DUAL UNION ALL
    SELECT 'DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL',  'O_RESULT_CURSOR',          'PROC_RESULT',           'OUT',              8 FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_PROC_M X WHERE X.PROC_NM=NEW.PROC_NM AND X.COL_NM=NEW.COL_NM AND X.COL_TP_CD=NEW.COL_TP_CD);

PROMPT === BLOCK 5 : GUEST 권한 ===
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'GUEST', BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
 WHERE BTN.MNU_ID='DMF0020' AND BTN.USE_YN='Y'
   AND NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X WHERE X.USER_GR_ID='GUEST' AND X.MNU_ID=BTN.MNU_ID AND X.SHT_NM=BTN.SHT_NM AND X.MNU_BTN_CD=BTN.MNU_BTN_CD);

PROMPT === BLOCK 6 : 사후 카운트 ===
SELECT 'POST: API_M (5)' AS K, COUNT(*) AS V FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE 'P_DMF0020%'
UNION ALL SELECT 'POST: BTN_MPG (5)', COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0020'
UNION ALL SELECT 'POST: PROC_M (33)', COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE 'DMF0020%'
UNION ALL SELECT 'POST: GUEST BTN (5)', COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE USER_GR_ID='GUEST' AND MNU_ID='DMF0020';

COMMIT;
EXIT;
