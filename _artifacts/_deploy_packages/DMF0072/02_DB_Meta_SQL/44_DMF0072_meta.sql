--==============================================================================
-- 44_DMF0072_meta.sql — DMF0072 (N:N Master Mapping)
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : MSG_M (2 건) ===
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM, MSG_DESC, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, 'KO', 'API', NEW.MSG_NM, NEW.MSG_NM, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'MSG_API_DMF0072_GET'  AS MSG_ID, 'N:N Master Mapping 조회' AS MSG_NM FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0072_SAVE',           'N:N Master Mapping 저장'           FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID=NEW.MSG_ID AND X.LANG_CD='KO');

PROMPT === BLOCK 2 : API_M (2 건) ===
INSERT INTO SCM_MGR.SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.API_ID, NEW.API_TP_CD, NEW.API_MSG_ID, NEW.API_MSG_DESC, NEW.API_URL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'P_DMF0072_GET'   AS API_ID, 'PROC_SELECT' AS API_TP_CD, 'MSG_API_DMF0072_GET'  AS API_MSG_ID, 'NN 조회' AS API_MSG_DESC, 'DMF0072_GET_NNMASTER_MAPPING'  AS API_URL FROM DUAL UNION ALL
    SELECT 'P_DMF0072_SAVE',           'PROC_SAVE',                'MSG_API_DMF0072_SAVE',              'NN 저장',               'DMF0072_SAVE_NNMASTER_MAPPING'           FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_API_M X WHERE X.API_ID=NEW.API_ID);

PROMPT === BLOCK 3 : BTN_MPG (2 건) ===
INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0072', NEW.SHT_NM, NEW.MNU_BTN_CD, NEW.API_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'main' AS SHT_NM, 'SEARCH' AS MNU_BTN_CD, 'P_DMF0072_GET'  AS API_ID FROM DUAL UNION ALL
    SELECT 'main',          'SAVE',                  'P_DMF0072_SAVE'          FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X WHERE X.MNU_ID='DMF0072' AND X.SHT_NM=NEW.SHT_NM AND X.MNU_BTN_CD=NEW.MNU_BTN_CD);

PROMPT === BLOCK 4 : PROC_M ===
INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.PROC_NM, NEW.COL_NM, NEW.DATA_TP_CD, NEW.COL_TP_CD, NEW.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    -- GET_NNMASTER_MAPPING
    SELECT 'DMF0072_GET_NNMASTER_MAPPING' AS PROC_NM, 'dataTypeCode'   AS COL_NM, 'VARCHAR' AS DATA_TP_CD, 'IN'  AS COL_TP_CD, 1 AS SORT_ORD FROM DUAL UNION ALL
    SELECT 'DMF0072_GET_NNMASTER_MAPPING',           'divisionId',                'VARCHAR',               'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0072_GET_NNMASTER_MAPPING',           'deptId',                    'VARCHAR',               'IN',                3 FROM DUAL UNION ALL
    SELECT 'DMF0072_GET_NNMASTER_MAPPING',           'endCustomer',               'VARCHAR',               'IN',                4 FROM DUAL UNION ALL
    SELECT 'DMF0072_GET_NNMASTER_MAPPING',           'scmSiteId',                 'VARCHAR',               'IN',                5 FROM DUAL UNION ALL
    SELECT 'DMF0072_GET_NNMASTER_MAPPING',           'projectCode',               'VARCHAR',               'IN',                6 FROM DUAL UNION ALL
    SELECT 'DMF0072_GET_NNMASTER_MAPPING',           'itemId',                    'VARCHAR',               'IN',                7 FROM DUAL UNION ALL
    SELECT 'DMF0072_GET_NNMASTER_MAPPING',           'p_cursor',                  'CURSOR',                'OUT',               8 FROM DUAL UNION ALL
    -- SAVE_NNMASTER_MAPPING
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'divisionId',                'VARCHAR',               'IN',                1 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'companyId',                 'VARCHAR',               'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'actType',                   'VARCHAR',               'IN',                3 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'custFcstType',              'VARCHAR',               'IN',                4 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'endCustomer',               'VARCHAR',               'IN',                5 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'custUnload',                'VARCHAR',               'IN',                6 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'custPlant',                 'VARCHAR',               'IN',                7 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'soldto',                    'VARCHAR',               'IN',                8 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'shipto',                    'VARCHAR',               'IN',                9 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'projectCode',               'VARCHAR',               'IN',               10 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'scmSiteId',                 'VARCHAR',               'IN',               11 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'fcstType',                  'VARCHAR',               'IN',               12 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'incoterms',                 'VARCHAR',               'IN',               13 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'domExp',                    'VARCHAR',               'IN',               14 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'custItemId',                'VARCHAR',               'IN',               15 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'mdmCode',                   'VARCHAR',               'IN',               16 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'mappingItemId',             'VARCHAR',               'IN',               17 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'mappingItemIdOriginal',     'VARCHAR',               'IN',               18 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'activeFlag',                'VARCHAR',               'IN',               19 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'validFrom',                 'VARCHAR',               'IN',               20 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'validTo',                   'VARCHAR',               'IN',               21 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'sesUserId',                 'VARCHAR',               'IN',               22 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'p_result_cursor',           'CURSOR',                'OUT',              23 FROM DUAL UNION ALL
    SELECT 'DMF0072_SAVE_NNMASTER_MAPPING',          'p_error_cursor',            'CURSOR',                'OUT',              24 FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_PROC_M X WHERE X.PROC_NM=NEW.PROC_NM AND X.COL_NM=NEW.COL_NM AND X.COL_TP_CD=NEW.COL_TP_CD);

PROMPT === BLOCK 5 : GUEST 권한 ===
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'GUEST', BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
 WHERE BTN.MNU_ID='DMF0072' AND BTN.USE_YN='Y'
   AND NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X WHERE X.USER_GR_ID='GUEST' AND X.MNU_ID=BTN.MNU_ID AND X.SHT_NM=BTN.SHT_NM AND X.MNU_BTN_CD=BTN.MNU_BTN_CD);

PROMPT === BLOCK 6 : 사후 카운트 ===
SELECT 'POST: API_M (2)' AS K, COUNT(*) AS V FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE 'P_DMF0072%'
UNION ALL SELECT 'POST: BTN_MPG (2)', COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0072'
UNION ALL SELECT 'POST: PROC_M (32)', COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE 'DMF0072%'
UNION ALL SELECT 'POST: GUEST BTN (2)', COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE USER_GR_ID='GUEST' AND MNU_ID='DMF0072';

COMMIT;
EXIT;
