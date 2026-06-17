-- 010_DMF0003_Registration.sql 의 사내 미적용 부분 보충 (NOT EXISTS 멱등)
--   - BLOCK 2: PROC_M 26 row (DMF0003_GET_MKT_FCST_DATA 22 IN + 4 OUT)
--   - BLOCK 5: API_M SEARCH 1 row (011 의 9 API 와 별도)
--   - BLOCK 6: BTN_MPG SEARCH 1 row (011 의 9 BTN 과 별도)
--   - BLOCK 1: i18n MNU_DMF0003 KO/EN/CN 3 + MSG_API_DMF0003_MKTFCST_SEARCH KO/EN/CN 3 (NOT EXISTS)
--
-- ⚠ 010 의 BLOCK 3 (SHEET_COLUMNS) / BLOCK 5 DELETE / BLOCK 6 DELETE 는 의도적으로 SKIP
--   - BLOCK 3: 표준화 UPDATE 로 67 col 이 이미 'main' 으로 정착
--   - BLOCK 5 DELETE: 011 의 9 API 보존
--   - BLOCK 6 DELETE: 011 의 9 BTN 보존

-- ========== BLOCK 1: i18n MSG_M (NOT EXISTS) ==========

INSERT INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, NEW.LANG_CD, NEW.MSG_NM, NEW.MSG_TP_CD, 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'MNU_DMF0003'                            MSG_ID, 'KO' LANG_CD, '시장 수요 계획'                 MSG_NM, 'MNU' MSG_TP_CD FROM DUAL UNION ALL
    SELECT 'MNU_DMF0003',                                   'EN',         'Market Forecast',                       'MNU'            FROM DUAL UNION ALL
    SELECT 'MNU_DMF0003',                                   'CN',         '市场需求计划',                          'MNU'            FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MKTFCST_SEARCH',                'KO',         '시장 수요 계획 조회',                  'API'            FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MKTFCST_SEARCH',                'EN',         'Market Forecast Search',                'API'            FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MKTFCST_SEARCH',                'CN',         '市场需求计划查询',                      'API'            FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_ADM_MSG_M E
    WHERE E.MSG_ID = NEW.MSG_ID AND E.LANG_CD = NEW.LANG_CD
 );

-- ========== BLOCK 2: PROC_M 26 row (NOT EXISTS 멱등) ==========

INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                             CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0003_GET_MKT_FCST_DATA', NEW.COL_NM, NEW.COL_TP_CD, NEW.DATA_TP_CD, NEW.SORT_ORD,
       'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'divisionId'      COL_NM, 'IN'  COL_TP_CD, 'VARCHAR'     DATA_TP_CD,  1 SORT_ORD FROM DUAL UNION ALL
    SELECT 'scmSiteId',              'IN',             'VARCHAR',                 2          FROM DUAL UNION ALL
    SELECT 'plantSiteId',            'IN',             'VARCHAR',                 3          FROM DUAL UNION ALL
    SELECT 'teamId',                 'IN',             'VARCHAR',                 4          FROM DUAL UNION ALL
    SELECT 'customer',               'IN',             'VARCHAR',                 5          FROM DUAL UNION ALL
    SELECT 'bizType',                'IN',             'VARCHAR',                 6          FROM DUAL UNION ALL
    SELECT 'projectCode',            'IN',             'VARCHAR',                 7          FROM DUAL UNION ALL
    SELECT 'itemId',                 'IN',             'VARCHAR',                 8          FROM DUAL UNION ALL
    SELECT 'fromYyyymmdd',           'IN',             'VARCHAR',                 9          FROM DUAL UNION ALL
    SELECT 'toYyyymmdd',             'IN',             'VARCHAR',                10          FROM DUAL UNION ALL
    SELECT 'createdBy',              'IN',             'VARCHAR',                11          FROM DUAL UNION ALL
    SELECT 'userGroup',              'IN',             'VARCHAR',                12          FROM DUAL UNION ALL
    SELECT 'itemType',               'IN',             'VARCHAR',                13          FROM DUAL UNION ALL
    SELECT 'owner',                  'IN',             'VARCHAR',                14          FROM DUAL UNION ALL
    SELECT 'qtyYn',                  'IN',             'VARCHAR',                15          FROM DUAL UNION ALL
    SELECT 'cellYn',                 'IN',             'VARCHAR',                16          FROM DUAL UNION ALL
    SELECT 'invalidExec',            'IN',             'VARCHAR',                17          FROM DUAL UNION ALL
    SELECT 'asYn',                   'IN',             'VARCHAR',                18          FROM DUAL UNION ALL
    SELECT 'userDeptId',             'IN',             'VARCHAR',                19          FROM DUAL UNION ALL
    SELECT 'senderCode',             'IN',             'VARCHAR',                20          FROM DUAL UNION ALL
    SELECT 'sesUserId',              'IN',             'VARCHAR',                21          FROM DUAL UNION ALL
    SELECT 'mnuId',                  'IN',             'VARCHAR',                22          FROM DUAL UNION ALL
    SELECT 'o_rc1',                  'OUT',            'CURSOR',                 23          FROM DUAL UNION ALL
    SELECT 'o_rc2',                  'OUT',            'CURSOR',                 24          FROM DUAL UNION ALL
    SELECT 'o_rc3',                  'OUT',            'CURSOR',                 25          FROM DUAL UNION ALL
    SELECT 'o_result_cursor',        'OUT',            'PROC_RESULT',            26          FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_ADM_PROC_M E
    WHERE E.PROC_NM = 'DMF0003_GET_MKT_FCST_DATA' AND E.COL_NM = NEW.COL_NM AND E.COL_TP_CD = NEW.COL_TP_CD
 );

-- ========== BLOCK 3: API_M SEARCH (NOT EXISTS) ==========

INSERT INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
                            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0003_main_SEARCH', 'PROC', 'MSG_API_DMF0003_MKTFCST_SEARCH',
       'DMF0003 Market Forecast Search', 'DMF0003_GET_MKT_FCST_DATA', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_ADM_API_M E WHERE E.API_ID = 'DMF0003_main_SEARCH'
 );

-- ========== BLOCK 4: BTN_MPG SEARCH (NOT EXISTS) ==========

INSERT INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                                    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0003', 'main', 'SEARCH', 'DMF0003_main_SEARCH', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_ADM_MNU_BTN_MPG_M E
    WHERE E.MNU_ID = 'DMF0003' AND E.SHT_NM = 'main' AND E.MNU_BTN_CD = 'SEARCH'
 );

-- ========== BLOCK 5: SEARCH 사용자 그룹 권한 (NOT EXISTS) ==========

INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
                                            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT u.USER_GR_ID, 'DMF0003', 'main', 'SEARCH', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM (SELECT 'ADMIN' USER_GR_ID FROM DUAL UNION ALL
        SELECT 'DEMAND_USER'      FROM DUAL UNION ALL
        SELECT 'GUEST'            FROM DUAL) u
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M E
    WHERE E.USER_GR_ID = u.USER_GR_ID AND E.MNU_ID = 'DMF0003' AND E.SHT_NM = 'main' AND E.MNU_BTN_CD = 'SEARCH'
 );

COMMIT;
