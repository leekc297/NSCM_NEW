--==============================================================================
-- DMF0043_Contribute_Main — 메타 등록 DBeaver 호환 (멱등 1 PL/SQL 블록)
--
-- 룰 25 §1.5 + 메모리 feedback_sql_idempotent_insert_all.md:
--   INSERT ALL ... VALUES 금지 → INSERT SELECT FROM ... NEW WHERE NOT EXISTS 패턴
-- 메모리 feedback_dbeaver_sql_mandatory_grep.md:
--   ^SET|^PROMPT|^DEFINE|^&\w|^/$  → 모두 0건 (실행 직전 grep 검증)
--
-- 4축 매핑 근거: Doc/_analysis/domain_DM/screens/DMF0043_Contribute_Main/__asis-mapping__.md
-- 작성: 2026-05-28
--==============================================================================

BEGIN
  ----------------------------------------------------------------------------
  -- BLOCK 1 : SCM_ADM_MSG_M (i18n × KO/EN/CN) — MNU + API 메시지
  ----------------------------------------------------------------------------
  INSERT INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT NEW.MSG_ID, NEW.LANG_CD, NEW.MSG_NM, NEW.MSG_TP_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
    FROM (
      SELECT 'MNU_DMF0043'                                LANG_CD_DUMMY, 'MNU_DMF0043' MSG_ID, 'KO' LANG_CD, '기여율 마스터'                  MSG_NM, 'MNU' MSG_TP_CD FROM DUAL UNION ALL
      SELECT 'MNU_DMF0043', 'MNU_DMF0043', 'EN', 'Contribute Main',                'MNU' FROM DUAL UNION ALL
      SELECT 'MNU_DMF0043', 'MNU_DMF0043', 'CN', '贡献率主数据',                   'MNU' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_MAIN_SEARCH', 'MSG_API_DMF0043_MAIN_SEARCH', 'KO', '메인 조회 실패',             'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_MAIN_SEARCH', 'MSG_API_DMF0043_MAIN_SEARCH', 'EN', 'Main search failed',         'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_MAIN_SEARCH', 'MSG_API_DMF0043_MAIN_SEARCH', 'CN', '主查询失败',                  'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_MAIN_SAVE',   'MSG_API_DMF0043_MAIN_SAVE',   'KO', '저장 실패',                  'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_MAIN_SAVE',   'MSG_API_DMF0043_MAIN_SAVE',   'EN', 'Save failed',                'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_MAIN_SAVE',   'MSG_API_DMF0043_MAIN_SAVE',   'CN', '保存失败',                    'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_VERSION_SEARCH', 'MSG_API_DMF0043_VERSION_SEARCH', 'KO', '버전 데이터 조회 실패',  'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_VERSION_SEARCH', 'MSG_API_DMF0043_VERSION_SEARCH', 'EN', 'Version data search failed', 'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_VERSION_SEARCH', 'MSG_API_DMF0043_VERSION_SEARCH', 'CN', '版本数据查询失败',         'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_TITLE_SEARCH', 'MSG_API_DMF0043_TITLE_SEARCH', 'KO', 'Spread 헤더 조회 실패',       'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_TITLE_SEARCH', 'MSG_API_DMF0043_TITLE_SEARCH', 'EN', 'Spread title search failed',  'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_TITLE_SEARCH', 'MSG_API_DMF0043_TITLE_SEARCH', 'CN', '电子表格标题查询失败',         'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_CONTRIBUTE_RATE_SEARCH', 'MSG_API_DMF0043_CONTRIBUTE_RATE_SEARCH', 'KO', '기여율 팝업 조회 실패',        'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_CONTRIBUTE_RATE_SEARCH', 'MSG_API_DMF0043_CONTRIBUTE_RATE_SEARCH', 'EN', 'Contribute rate popup search failed', 'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_CONTRIBUTE_RATE_SEARCH', 'MSG_API_DMF0043_CONTRIBUTE_RATE_SEARCH', 'CN', '贡献率弹窗查询失败',           'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_CONTRIBUTE_RATE_SAVE',   'MSG_API_DMF0043_CONTRIBUTE_RATE_SAVE',   'KO', '버전 저장 실패',              'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_CONTRIBUTE_RATE_SAVE',   'MSG_API_DMF0043_CONTRIBUTE_RATE_SAVE',   'EN', 'Version save failed',         'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_CONTRIBUTE_RATE_SAVE',   'MSG_API_DMF0043_CONTRIBUTE_RATE_SAVE',   'CN', '版本保存失败',                'API' FROM DUAL
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
  SELECT 'DMF0043', UPPR_MNU_ID, 'contribute-main', 'MNU_DMF0043', 'Contribute Main',
         (SELECT NVL(MAX(SORT_ORD), 0) + 10 FROM SCM_ADM_MNU_M
           WHERE UPPR_MNU_ID = M.UPPR_MNU_ID),
         MNU_LV_NO, MNU_TP_CD, UNIT_TP_CD, 'Y',
         'admin', SYSDATE, 'admin', SYSDATE
    FROM SCM_ADM_MNU_M M
   WHERE MNU_ID = 'DMF0020'
     AND NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0043');

  ----------------------------------------------------------------------------
  -- BLOCK 3 : SCM_ADM_PROC_M (SP 메타) — SP 컴파일 후 별도 PR 에서 갱신
  -- 5 SPs: DMF0043_GET_MAIN_VARSION_DATA / DMF0043_GET_MAIN_SPREAD_TITLE /
  --         DMF0043_GET_CONTRIBUTE_MAIN_DATA / DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO /
  --         SCM0001_GET_LOOKUP_VALUES (공통 — 별도 등록)
  --
  -- POPUP 공유 SPs (ContributeRate modal — Main 과 View 양쪽에서 호출):
  --   DMF0000_GET_COMMON_SPREAD_TITLE / DMF0043_GET_CONTRIBUTE_RATE_POPUP /
  --   DMF0043_GET_CONTRIBUTE_YEAR_POPUP / DMF0043_SAVE_DM_MST_CONTRIBUTE_VER
  ----------------------------------------------------------------------------

  ----------------------------------------------------------------------------
  -- BLOCK 4 : SCM_ADM_API_M (API 메타) — Main + ContributeRate POPUP 9건
  ----------------------------------------------------------------------------
  INSERT INTO SCM_ADM_API_M
    (API_ID, API_TP_CD, API_MSG_ID, API_URL, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT NEW.API_ID, 'PROC', NEW.MSG_ID, NEW.URL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
    FROM (
      SELECT 'DMF0043_main_SEARCH'              API_ID, 'MSG_API_DMF0043_MAIN_SEARCH'              MSG_ID, 'PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_MAIN_DATA'  URL FROM DUAL UNION ALL
      SELECT 'DMF0043_main_SAVE',                'MSG_API_DMF0043_MAIN_SAVE',                       'PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO' FROM DUAL UNION ALL
      SELECT 'DMF0043_version_SEARCH',           'MSG_API_DMF0043_VERSION_SEARCH',                  'PKG_DMF0043.P_DMF0043_GET_MAIN_VARSION_DATA'        FROM DUAL UNION ALL
      SELECT 'DMF0043_title_SEARCH',             'MSG_API_DMF0043_TITLE_SEARCH',                    'PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE'        FROM DUAL UNION ALL
      SELECT 'DMF0043_lookup_SEARCH',            'MSG_API_DMF0043_MAIN_SEARCH',                     'PKG_SCM0001.P_SCM0001_GET_LOOKUP_VALUES'            FROM DUAL UNION ALL
      -- POPUP (ContributeRate) — 공유 모달
      SELECT 'DMF0043_contributeRate_SEARCH',    'MSG_API_DMF0043_CONTRIBUTE_RATE_SEARCH',          'PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_RATE_POPUP'    FROM DUAL UNION ALL
      SELECT 'DMF0043_contributeRate_SAVE',      'MSG_API_DMF0043_CONTRIBUTE_RATE_SAVE',            'PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER'   FROM DUAL UNION ALL
      SELECT 'DMF0043_contributeRateYear_SEARCH','MSG_API_DMF0043_CONTRIBUTE_RATE_SEARCH',          'PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_YEAR_POPUP'    FROM DUAL UNION ALL
      SELECT 'DMF0043_contributeRateTitle_SEARCH','MSG_API_DMF0043_CONTRIBUTE_RATE_SEARCH',         'PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE'      FROM DUAL
    ) NEW
   WHERE NOT EXISTS (
     SELECT 1 FROM SCM_ADM_API_M T WHERE T.API_ID = NEW.API_ID
   );

  ----------------------------------------------------------------------------
  -- BLOCK 5 : SCM_ADM_MNU_BTN_MPG_M (라우팅 — 9 mapping)
  ----------------------------------------------------------------------------
  INSERT INTO SCM_ADM_MNU_BTN_MPG_M
    (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT 'DMF0043', NEW.SHT, NEW.BTN, NEW.API, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
    FROM (
      SELECT 'main'                 SHT, 'SEARCH'  BTN, 'DMF0043_main_SEARCH'               API FROM DUAL UNION ALL
      SELECT 'main',                 'SAVE',    'DMF0043_main_SAVE'                  FROM DUAL UNION ALL
      SELECT 'version',              'SEARCH',  'DMF0043_version_SEARCH'             FROM DUAL UNION ALL
      SELECT 'title',                'SEARCH',  'DMF0043_title_SEARCH'               FROM DUAL UNION ALL
      SELECT 'lookup',               'SEARCH',  'DMF0043_lookup_SEARCH'              FROM DUAL UNION ALL
      SELECT 'contributeRate',       'SEARCH',  'DMF0043_contributeRate_SEARCH'      FROM DUAL UNION ALL
      SELECT 'contributeRate',       'SAVE',    'DMF0043_contributeRate_SAVE'        FROM DUAL UNION ALL
      SELECT 'contributeRateYear',   'SEARCH',  'DMF0043_contributeRateYear_SEARCH'  FROM DUAL UNION ALL
      SELECT 'contributeRateTitle',  'SEARCH',  'DMF0043_contributeRateTitle_SEARCH' FROM DUAL
    ) NEW
   WHERE NOT EXISTS (
     SELECT 1 FROM SCM_ADM_MNU_BTN_MPG_M T
      WHERE T.MNU_ID = 'DMF0043' AND T.SHT_NM = NEW.SHT AND T.MNU_BTN_CD = NEW.BTN
   );

  ----------------------------------------------------------------------------
  -- BLOCK 6 : SCM_MST_SHEET_COLUMNS (Grid 컬럼 — main + contributeRate)
  ----------------------------------------------------------------------------
  INSERT INTO SCM_MST_SHEET_COLUMNS
    (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO,
     FIXED_FLAG, COLUMN_WIDTH, CELL_CONTROL_OBJECT_TYPE_CODE,
     HORIZONTAL_ALIGN_CODE, UPPERCASE_APPLY_FLAG, VISIBLE_FLAG,
     DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, INPUT_TP_CD,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT 'DMF0043', NEW.SHT_NM, NEW.COL_NM, NEW.COL_LBL, NEW.SORT_ORD,
         NEW.FIXED, NEW.COL_WTH, NEW.CELL_TP,
         NEW.ALIGN, 'N', 'Y',
         'Y', 'Y', 'Y', NEW.INPUT_TP,
         'admin', SYSDATE, 'admin', SYSDATE
    FROM (
      -- main sheet (기여율 마스터)
      SELECT 'main' SHT_NM, 'EDIT_FLAG'      COL_NM, 'LBL_DMF0043_EDIT_FLAG'    COL_LBL, 1  SORT_ORD, 'Y' FIXED, 50  COL_WTH, 'FPText' CELL_TP, 'C' ALIGN, 'S' INPUT_TP FROM DUAL UNION ALL
      SELECT 'main', 'YYYY',           'LBL_DMF0043_YYYY',         2,  'Y', 60,  'FPText', 'C', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'DIVISION_ID',    'LBL_DMF0043_DIVISION',     3,  'Y', 80,  'FPText', 'C', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'CUSTOMER_GROUP', 'LBL_DMF0043_CUST_GROUP',   4,  'Y', 100, 'FPText', 'C', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'PRODUCT_TYPE',   'LBL_DMF0043_PRODUCT_TYPE', 5,  'Y', 100, 'FPText', 'C', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'BIZ_TYPE',       'LBL_DMF0043_BIZ_TYPE',     6,  'Y', 80,  'FPText', 'C', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'PREV_YEAR_SUM',  'LBL_DMF0043_PREV_SUM',     7,  'N', 100, 'FPText', 'R', 'S' FROM DUAL UNION ALL
      SELECT 'main', 'CURR_YEAR_SUM',  'LBL_DMF0043_CURR_SUM',     8,  'N', 100, 'FPText', 'R', 'S' FROM DUAL UNION ALL
      SELECT 'main', 'NEXT_YEAR_SUM',  'LBL_DMF0043_NEXT_SUM',     9,  'N', 100, 'FPText', 'R', 'S' FROM DUAL UNION ALL
      SELECT 'main', 'RATIO_PCT',      'LBL_DMF0043_RATIO',        10, 'N', 80,  'FPText', 'R', 'M' FROM DUAL UNION ALL
      -- contributeRate sheet (POPUP — 버전 관리)
      SELECT 'contributeRate', 'EDIT_FLAG',   'LBL_DMF0043_EDIT_FLAG',     1, 'Y', 50,  'FPText', 'C', 'S' FROM DUAL UNION ALL
      SELECT 'contributeRate', 'VER_SEQ',     'LBL_DMF0043_VER_SEQ',       2, 'Y', 70,  'FPText', 'C', 'S' FROM DUAL UNION ALL
      SELECT 'contributeRate', 'YYYY',        'LBL_DMF0043_YYYY',          3, 'Y', 70,  'FPText', 'C', 'M' FROM DUAL UNION ALL
      SELECT 'contributeRate', 'VERSION_NM',  'LBL_DMF0043_VERSION_NM',    4, 'N', 200, 'FPText', 'L', 'M' FROM DUAL UNION ALL
      SELECT 'contributeRate', 'VALID_YN',    'LBL_DMF0043_VALID_YN',      5, 'N', 60,  'FPCheck','C', 'M' FROM DUAL UNION ALL
      SELECT 'contributeRate', 'DESCRIPTION', 'LBL_DMF0043_DESCRIPTION',   6, 'N', 300, 'FPText', 'L', 'M' FROM DUAL
    ) NEW
   WHERE NOT EXISTS (
     SELECT 1 FROM SCM_MST_SHEET_COLUMNS T
      WHERE T.PROGRAM_ID = 'DMF0043'
        AND T.SHEET_NAME = NEW.SHT_NM
        AND T.COLUMN_NAME = NEW.COL_NM
   );

  ----------------------------------------------------------------------------
  -- BLOCK 7 : SCM_ADM_USER_GR_MNU_MPG_M + ..._BTN_MPG_M (권한 — 형제 DMF0020 복제)
  ----------------------------------------------------------------------------
  -- 메뉴 권한 : DMF0020 권한 그룹에 DMF0043 도 동일 부여
  INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M
    (USER_GR_ID, MNU_ID, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT USER_GR_ID, 'DMF0043', 'Y',
         'admin', SYSDATE, 'admin', SYSDATE
    FROM SCM_ADM_USER_GR_MNU_MPG_M
   WHERE MNU_ID = 'DMF0020'
     AND USE_YN = 'Y'
     AND NOT EXISTS (
       SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M T
        WHERE T.USER_GR_ID = SCM_ADM_USER_GR_MNU_MPG_M.USER_GR_ID
          AND T.MNU_ID = 'DMF0043'
     );

  -- 버튼 권한 : DMF0043 의 실제 버튼 9개 × DMF0020 권한 그룹
  INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M
    (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT DISTINCT UGB.USER_GR_ID, 'DMF0043', BTN.SHT_NM, BTN.MNU_BTN_CD, 'Y',
         'admin', SYSDATE, 'admin', SYSDATE
    FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M UGB
    JOIN SCM_ADM_MNU_BTN_MPG_M BTN
      ON BTN.MNU_ID = 'DMF0043'
   WHERE UGB.MNU_ID = 'DMF0020'
     AND UGB.USE_YN = 'Y'
     AND NOT EXISTS (
       SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M T
        WHERE T.USER_GR_ID = UGB.USER_GR_ID
          AND T.MNU_ID = 'DMF0043'
          AND T.SHT_NM = BTN.SHT_NM
          AND T.MNU_BTN_CD = BTN.MNU_BTN_CD
     );

  COMMIT;
END;
