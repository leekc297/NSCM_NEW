--==============================================================================
-- DMF0072_NNMasterMapping — 메타 등록 DBeaver 호환 (멱등 1 PL/SQL 블록)
--
-- 룰 25 §1.5 + 메모리 feedback_sql_idempotent_insert_all.md
-- 메모리 feedback_dbeaver_sql_mandatory_grep.md (^SET|^PROMPT|^DEFINE|^&\w|^/$ 0건)
--
-- 4축 매핑: Doc/_analysis/domain_DM/screens/DMF0072_NNMasterMapping/__asis-mapping__.md
-- 작성: 2026-05-29
--==============================================================================

BEGIN
  ----------------------------------------------------------------------------
  -- BLOCK 1 : SCM_ADM_MSG_M (i18n × KO/EN/CN) — MNU + API 메시지
  ----------------------------------------------------------------------------
  INSERT INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT NEW.MSG_ID, NEW.LANG_CD, NEW.MSG_NM, NEW.MSG_TP_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
    FROM (
      SELECT 'MNU_DMF0072' MSG_ID, 'KO' LANG_CD, 'N:N 매핑'              MSG_NM, 'MNU' MSG_TP_CD FROM DUAL UNION ALL
      SELECT 'MNU_DMF0072', 'EN', 'N:N Master Mapping',                  'MNU' FROM DUAL UNION ALL
      SELECT 'MNU_DMF0072', 'CN', '多对多主数据映射',                     'MNU' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0072_MAIN_SEARCH', 'KO', '메인 조회 실패',         'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0072_MAIN_SEARCH', 'EN', 'Main search failed',    'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0072_MAIN_SEARCH', 'CN', '主查询失败',             'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0072_MAIN_SAVE',   'KO', '저장 실패',              'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0072_MAIN_SAVE',   'EN', 'Save failed',            'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0072_MAIN_SAVE',   'CN', '保存失败',                'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0072_TITLE_SEARCH', 'KO', 'Spread 헤더 조회 실패',   'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0072_TITLE_SEARCH', 'EN', 'Spread title search failed', 'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0072_TITLE_SEARCH', 'CN', '电子表格标题查询失败',     'API' FROM DUAL
    ) NEW
   WHERE NOT EXISTS (
     SELECT 1 FROM SCM_ADM_MSG_M T
      WHERE T.MSG_ID = NEW.MSG_ID AND T.LANG_CD = NEW.LANG_CD
   );

  ----------------------------------------------------------------------------
  -- BLOCK 2 : SCM_ADM_MNU_M (메뉴 마스터 — 형제 DMF0020 의 부모/레벨/유형 복제)
  ----------------------------------------------------------------------------
  INSERT INTO SCM_ADM_MNU_M
    (MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC,
     SORT_ORD, MNU_LV_NO, MNU_TP_CD, UNIT_TP_CD, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT 'DMF0072', UPPR_MNU_ID, 'nn-master-mapping', 'MNU_DMF0072', 'N:N Master Mapping',
         (SELECT NVL(MAX(SORT_ORD), 0) + 10 FROM SCM_ADM_MNU_M
           WHERE UPPR_MNU_ID = M.UPPR_MNU_ID),
         MNU_LV_NO, MNU_TP_CD, UNIT_TP_CD, 'Y',
         'admin', SYSDATE, 'admin', SYSDATE
    FROM SCM_ADM_MNU_M M
   WHERE MNU_ID = 'DMF0020'
     AND NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0072');

  ----------------------------------------------------------------------------
  -- BLOCK 3 : SCM_ADM_PROC_M (SP 메타) — SP 컴파일 후 별도 PR
  -- 3 SPs: DMF0072_GET_NNMASTER_MAPPING / DMF0072_SAVE_NNMASTER_MAPPING /
  --        DMF0000_GET_COMMON_SPREAD_TITLE (공통)
  ----------------------------------------------------------------------------

  ----------------------------------------------------------------------------
  -- BLOCK 4 : SCM_ADM_API_M (API 메타) — 3 건
  ----------------------------------------------------------------------------
  INSERT INTO SCM_ADM_API_M
    (API_ID, API_TP_CD, API_MSG_ID, API_URL, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT NEW.API_ID, 'PROC', NEW.MSG_ID, NEW.URL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
    FROM (
      SELECT 'DMF0072_main_SEARCH'  API_ID, 'MSG_API_DMF0072_MAIN_SEARCH'  MSG_ID, 'PKG_DMF0072.P_DMF0072_GET_NNMASTER_MAPPING'   URL FROM DUAL UNION ALL
      SELECT 'DMF0072_main_SAVE',            'MSG_API_DMF0072_MAIN_SAVE',            'PKG_DMF0072.P_DMF0072_SAVE_NNMASTER_MAPPING' FROM DUAL UNION ALL
      SELECT 'DMF0072_title_SEARCH',         'MSG_API_DMF0072_TITLE_SEARCH',         'PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE' FROM DUAL
    ) NEW
   WHERE NOT EXISTS (
     SELECT 1 FROM SCM_ADM_API_M T WHERE T.API_ID = NEW.API_ID
   );

  ----------------------------------------------------------------------------
  -- BLOCK 5 : SCM_ADM_MNU_BTN_MPG_M (라우팅 — 3 mapping)
  ----------------------------------------------------------------------------
  INSERT INTO SCM_ADM_MNU_BTN_MPG_M
    (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT 'DMF0072', NEW.SHT, NEW.BTN, NEW.API, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
    FROM (
      SELECT 'main'  SHT, 'SEARCH'  BTN, 'DMF0072_main_SEARCH'  API FROM DUAL UNION ALL
      SELECT 'main',      'SAVE',        'DMF0072_main_SAVE'         FROM DUAL UNION ALL
      SELECT 'title',     'SEARCH',      'DMF0072_title_SEARCH'      FROM DUAL
    ) NEW
   WHERE NOT EXISTS (
     SELECT 1 FROM SCM_ADM_MNU_BTN_MPG_M T
      WHERE T.MNU_ID = 'DMF0072' AND T.SHT_NM = NEW.SHT AND T.MNU_BTN_CD = NEW.BTN
   );

  ----------------------------------------------------------------------------
  -- BLOCK 6 : SCM_MST_SHEET_COLUMNS (Grid 22 cols — main sheet)
  ----------------------------------------------------------------------------
  INSERT INTO SCM_MST_SHEET_COLUMNS
    (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO,
     FIXED_FLAG, COLUMN_WIDTH, CELL_CONTROL_OBJECT_TYPE_CODE,
     HORIZONTAL_ALIGN_CODE, UPPERCASE_APPLY_FLAG, VISIBLE_FLAG,
     DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, INPUT_TP_CD,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT 'DMF0072', NEW.SHT_NM, NEW.COL_NM, NEW.COL_LBL, NEW.SORT_ORD,
         NEW.FIXED, NEW.COL_WTH, NEW.CELL_TP,
         NEW.ALIGN, 'N', NEW.VISIBLE,
         'Y', 'Y', 'Y', NEW.INPUT_TP,
         'admin', SYSDATE, 'admin', SYSDATE
    FROM (
      SELECT 'main' SHT_NM, 'DATA_TYPE_CODE' COL_NM, 'LBL_DMF0072_DATA_TYPE'  COL_LBL,  1 SORT_ORD, 'Y' FIXED,  80 COL_WTH, 'FPCombo' CELL_TP, 'C' ALIGN, 'Y' VISIBLE, 'M' INPUT_TP FROM DUAL UNION ALL
      SELECT 'main', 'DIVISION_ID',           'LBL_DMF0072_DIVISION',         2, 'Y', 60,  'FPText',  'C', 'Y', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'COMPANY_ID',            'LBL_DMF0072_COMPANY',          3, 'N', 80,  'FPCombo', 'C', 'Y', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'SOLDTO_CODE',           'LBL_DMF0072_SOLDTO',           4, 'N', 100, 'FPText',  'C', 'Y', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'SHIPTO_CODE',           'LBL_DMF0072_SHIPTO',           5, 'N', 100, 'FPText',  'C', 'Y', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'UNLOADING_POINT',       'LBL_DMF0072_CUST_UNLOAD',      6, 'N', 100, 'FPText',  'L', 'Y', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'CUSTOMER_PLANT',        'LBL_DMF0072_CUST_PLANT',       7, 'N', 80,  'FPText',  'L', 'Y', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'CUSTOMER_ITEM_ID',      'LBL_DMF0072_CUST_ITEM_ID',     8, 'N', 120, 'FPText',  'L', 'Y', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'END_CUSTOMER',          'LBL_DMF0072_END_CUSTOMER',     9, 'N', 100, 'FPCombo', 'C', 'Y', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'SCM_SITE_ID',           'LBL_DMF0072_SCM_SITE',        10, 'N', 100, 'FPCombo', 'C', 'Y', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'PROJECT_CODE',          'LBL_DMF0072_PROJECT',         11, 'N', 100, 'FPText',  'C', 'Y', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'FCST_TYPE',             'LBL_DMF0072_FCST_TYPE',       12, 'N', 80,  'FPCombo', 'C', 'Y', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'INCOTERMS',             'LBL_DMF0072_INCOTERMS',       13, 'N', 80,  'FPCombo', 'C', 'Y', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'DOM_EXP',               'LBL_DMF0072_DOM_EXP',         14, 'N', 80,  'FPCombo', 'C', 'Y', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'ITEM_ID',               'LBL_DMF0072_MDM_CODE',        15, 'N', 120, 'FPText',  'L', 'Y', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'MAPPING_ITEM_ID',       'LBL_DMF0072_MAPPING_ITEM',    16, 'N', 120, 'FPText',  'L', 'Y', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'MAPPING_ITEM_ID_ORIGINAL', 'LBL_DMF0072_MAPPING_ORG',  17, 'N',   0, 'FPText',  'L', 'N', 'S' FROM DUAL UNION ALL
      SELECT 'main', 'VALID_START_DATE',      'LBL_DMF0072_START_DATE',      18, 'N', 100, 'FPText',  'C', 'Y', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'VALID_END_DATE',        'LBL_DMF0072_END_DATE',        19, 'N', 100, 'FPText',  'C', 'Y', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'ACTIVE_YN',             'LBL_DMF0072_ACTIVE_FLAG',     20, 'N',  60, 'FPCheck', 'C', 'Y', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'LAST_UPDATED_BY',       'LBL_DMF0072_UPDATED_BY',      21, 'N',  80, 'FPText',  'C', 'Y', 'S' FROM DUAL UNION ALL
      SELECT 'main', 'LAST_UPDATE_DATE',      'LBL_DMF0072_UPDATE_DATE',     22, 'N', 100, 'FPText',  'C', 'Y', 'S' FROM DUAL
    ) NEW
   WHERE NOT EXISTS (
     SELECT 1 FROM SCM_MST_SHEET_COLUMNS T
      WHERE T.PROGRAM_ID = 'DMF0072'
        AND T.SHEET_NAME = NEW.SHT_NM
        AND T.COLUMN_NAME = NEW.COL_NM
   );

  ----------------------------------------------------------------------------
  -- BLOCK 7 : SCM_ADM_USER_GR_MNU_MPG_M + ..._BTN_MPG_M (권한 — DMF0020 복제)
  ----------------------------------------------------------------------------
  INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M
    (USER_GR_ID, MNU_ID, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT USER_GR_ID, 'DMF0072', 'Y',
         'admin', SYSDATE, 'admin', SYSDATE
    FROM SCM_ADM_USER_GR_MNU_MPG_M
   WHERE MNU_ID = 'DMF0020'
     AND USE_YN = 'Y'
     AND NOT EXISTS (
       SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M T
        WHERE T.USER_GR_ID = SCM_ADM_USER_GR_MNU_MPG_M.USER_GR_ID
          AND T.MNU_ID = 'DMF0072'
     );

  INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M
    (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT DISTINCT UGB.USER_GR_ID, 'DMF0072', BTN.SHT_NM, BTN.MNU_BTN_CD, 'Y',
         'admin', SYSDATE, 'admin', SYSDATE
    FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M UGB
    JOIN SCM_ADM_MNU_BTN_MPG_M BTN
      ON BTN.MNU_ID = 'DMF0072'
   WHERE UGB.MNU_ID = 'DMF0020'
     AND UGB.USE_YN = 'Y'
     AND NOT EXISTS (
       SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M T
        WHERE T.USER_GR_ID = UGB.USER_GR_ID
          AND T.MNU_ID = 'DMF0072'
          AND T.SHT_NM = BTN.SHT_NM
          AND T.MNU_BTN_CD = BTN.MNU_BTN_CD
     );

  COMMIT;
END;
