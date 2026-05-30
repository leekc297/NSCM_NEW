--==============================================================================
-- DMF0043_01_Contribute_View — 메타 등록 DBeaver 호환 (멱등 1 PL/SQL 블록)
--
-- 룰 25 §1.5 + 메모리 feedback_sql_idempotent_insert_all.md (INSERT SELECT NEW NOT EXISTS)
-- 메모리 feedback_dbeaver_sql_mandatory_grep.md (^SET|^PROMPT|^DEFINE|^&\w|^/$ 0건)
--
-- 4축 매핑 근거: Doc/_analysis/domain_DM/screens/DMF0043_Contribute_View/__asis-mapping__.md
-- 선결: 30_DMF0043_Contribute_Main_Registration_DBeaver.sql 먼저 실행 (공유 POPUP API 의존)
-- 작성: 2026-05-28
--==============================================================================

BEGIN
  ----------------------------------------------------------------------------
  -- BLOCK 1 : SCM_ADM_MSG_M (i18n × KO/EN/CN) — View 화면 MNU + 신규 API 메시지
  -- 공유 ContributeRate API 메시지는 Main 등록 시 이미 INSERT 됨 (재시도 NEW WHERE NOT EXISTS 로 안전)
  ----------------------------------------------------------------------------
  INSERT INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT NEW.MSG_ID, NEW.LANG_CD, NEW.MSG_NM, NEW.MSG_TP_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
    FROM (
      SELECT 'MNU_DMF0043_01' MSG_ID, 'KO' LANG_CD, '기여율 조회'         MSG_NM, 'MNU' MSG_TP_CD FROM DUAL UNION ALL
      SELECT 'MNU_DMF0043_01', 'EN', 'Contribute View',                    'MNU' FROM DUAL UNION ALL
      SELECT 'MNU_DMF0043_01', 'CN', '贡献率查询',                          'MNU' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_VIEW_SEARCH', 'KO', '메인 조회 실패',           'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_VIEW_SEARCH', 'EN', 'Main search failed',     'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_VIEW_SEARCH', 'CN', '主查询失败',              'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_VIEW_TITLE_SEARCH', 'KO', 'Spread 헤더 조회 실패', 'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_VIEW_TITLE_SEARCH', 'EN', 'Spread title search failed', 'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_VIEW_TITLE_SEARCH', 'CN', '电子表格标题查询失败',  'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_VIEW_VERSION_SEARCH', 'KO', '버전 팝업 조회 실패', 'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_VIEW_VERSION_SEARCH', 'EN', 'Version popup search failed', 'API' FROM DUAL UNION ALL
      SELECT 'MSG_API_DMF0043_VIEW_VERSION_SEARCH', 'CN', '版本弹窗查询失败',     'API' FROM DUAL
    ) NEW
   WHERE NOT EXISTS (
     SELECT 1 FROM SCM_ADM_MSG_M T
      WHERE T.MSG_ID = NEW.MSG_ID AND T.LANG_CD = NEW.LANG_CD
   );

  ----------------------------------------------------------------------------
  -- BLOCK 2 : SCM_ADM_MNU_M (메뉴 마스터) — DMF0043 (Main) 형제로 등록
  ----------------------------------------------------------------------------
  INSERT INTO SCM_ADM_MNU_M
    (MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC,
     SORT_ORD, MNU_LV_NO, MNU_TP_CD, UNIT_TP_CD, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT 'DMF0043_01', UPPR_MNU_ID, 'contribute-view', 'MNU_DMF0043_01', 'Contribute View',
         (SELECT NVL(MAX(SORT_ORD), 0) + 10 FROM SCM_ADM_MNU_M
           WHERE UPPR_MNU_ID = M.UPPR_MNU_ID),
         MNU_LV_NO, MNU_TP_CD, UNIT_TP_CD, 'Y',
         'admin', SYSDATE, 'admin', SYSDATE
    FROM SCM_ADM_MNU_M M
   WHERE MNU_ID = 'DMF0043'
     AND NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0043_01');

  ----------------------------------------------------------------------------
  -- BLOCK 3 : SCM_ADM_PROC_M (SP 메타) — SP 컴파일 후 별도 PR
  -- 신규 SPs (View 전용):
  --   DMF0043_GET_SALES_LIST_SPREAD_TITLE / DMF0043_GET_CONTRIBUTION_SALES_LIST /
  --   DMF0043_GET_CONT_VIEW_VERSIONPOPUP
  -- 공유 SPs (Main 과 공통 — 등록 완료):
  --   SCM0001_GET_LOOKUP_VALUES / DMF0043 POPUP SPs (Main 등록 시 처리)
  ----------------------------------------------------------------------------

  ----------------------------------------------------------------------------
  -- BLOCK 4 : SCM_ADM_API_M (View 전용 API 4건)
  ----------------------------------------------------------------------------
  INSERT INTO SCM_ADM_API_M
    (API_ID, API_TP_CD, API_MSG_ID, API_URL, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT NEW.API_ID, 'PROC', NEW.MSG_ID, NEW.URL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
    FROM (
      SELECT 'DMF0043_01_main_SEARCH'    API_ID, 'MSG_API_DMF0043_VIEW_SEARCH'       MSG_ID, 'PKG_DMF0043.P_DMF0043_GET_CONTRIBUTION_SALES_LIST' URL FROM DUAL UNION ALL
      SELECT 'DMF0043_01_title_SEARCH',           'MSG_API_DMF0043_VIEW_TITLE_SEARCH',         'PKG_DMF0043.P_DMF0043_GET_SALES_LIST_SPREAD_TITLE'  FROM DUAL UNION ALL
      SELECT 'DMF0043_01_version_SEARCH',         'MSG_API_DMF0043_VIEW_VERSION_SEARCH',       'PKG_DMF0043.P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP'  FROM DUAL UNION ALL
      SELECT 'DMF0043_01_lookup_SEARCH',          'MSG_API_DMF0043_VIEW_SEARCH',               'PKG_SCM0001.P_SCM0001_GET_LOOKUP_VALUES'           FROM DUAL
    ) NEW
   WHERE NOT EXISTS (
     SELECT 1 FROM SCM_ADM_API_M T WHERE T.API_ID = NEW.API_ID
   );

  ----------------------------------------------------------------------------
  -- BLOCK 5 : SCM_ADM_MNU_BTN_MPG_M (라우팅 — View 전용 4 + 공유 ContributeRate 모달 3)
  -- 공유 API 는 DMF0043_contributeRate_* (Main 등록 시 생성) 를 그대로 참조
  ----------------------------------------------------------------------------
  INSERT INTO SCM_ADM_MNU_BTN_MPG_M
    (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT 'DMF0043_01', NEW.SHT, NEW.BTN, NEW.API, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
    FROM (
      SELECT 'main'                 SHT, 'SEARCH'  BTN, 'DMF0043_01_main_SEARCH'              API FROM DUAL UNION ALL
      SELECT 'title',                'SEARCH',  'DMF0043_01_title_SEARCH'              FROM DUAL UNION ALL
      SELECT 'version',              'SEARCH',  'DMF0043_01_version_SEARCH'            FROM DUAL UNION ALL
      SELECT 'lookup',               'SEARCH',  'DMF0043_01_lookup_SEARCH'             FROM DUAL UNION ALL
      -- 공유 ContributeRate 모달 (DMF0043 Main 의 API 재사용)
      SELECT 'contributeRate',       'SEARCH',  'DMF0043_contributeRate_SEARCH'        FROM DUAL UNION ALL
      SELECT 'contributeRate',       'SAVE',    'DMF0043_contributeRate_SAVE'          FROM DUAL UNION ALL
      SELECT 'contributeRateYear',   'SEARCH',  'DMF0043_contributeRateYear_SEARCH'    FROM DUAL UNION ALL
      SELECT 'contributeRateTitle',  'SEARCH',  'DMF0043_contributeRateTitle_SEARCH'   FROM DUAL
    ) NEW
   WHERE NOT EXISTS (
     SELECT 1 FROM SCM_ADM_MNU_BTN_MPG_M T
      WHERE T.MNU_ID = 'DMF0043_01' AND T.SHT_NM = NEW.SHT AND T.MNU_BTN_CD = NEW.BTN
   );

  ----------------------------------------------------------------------------
  -- BLOCK 6 : SCM_MST_SHEET_COLUMNS (Grid 컬럼 — View 의 main + version popup)
  -- ContributeRate sheet 는 DMF0043 (Main) 에 등록됨 — View 는 별도 등록 불필요
  ----------------------------------------------------------------------------
  INSERT INTO SCM_MST_SHEET_COLUMNS
    (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO,
     FIXED_FLAG, COLUMN_WIDTH, CELL_CONTROL_OBJECT_TYPE_CODE,
     HORIZONTAL_ALIGN_CODE, UPPERCASE_APPLY_FLAG, VISIBLE_FLAG,
     DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, INPUT_TP_CD,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT 'DMF0043_01', NEW.SHT_NM, NEW.COL_NM, NEW.COL_LBL, NEW.SORT_ORD,
         NEW.FIXED, NEW.COL_WTH, NEW.CELL_TP,
         NEW.ALIGN, 'N', 'Y',
         'Y', 'Y', 'Y', NEW.INPUT_TP,
         'admin', SYSDATE, 'admin', SYSDATE
    FROM (
      -- main sheet (Sales 기여 조회 — Large/Small 그룹 + SUM)
      SELECT 'main' SHT_NM, 'YYYY'         COL_NM, 'LBL_DMF0043_YYYY'           COL_LBL, 1  SORT_ORD, 'Y' FIXED, 60  COL_WTH, 'FPText' CELL_TP, 'C' ALIGN, 'M' INPUT_TP FROM DUAL UNION ALL
      SELECT 'main', 'VERSION_ID',     'LBL_DMF0043_VERSION',       2, 'Y', 100, 'FPText', 'C', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'CUSTOMER_GROUP', 'LBL_DMF0043_CUST_GROUP',    3, 'Y', 100, 'FPText', 'C', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'PRODUCT_TYPE',   'LBL_DMF0043_PRODUCT_TYPE',  4, 'Y', 100, 'FPText', 'C', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'BIZ_TYPE',       'LBL_DMF0043_BIZ_TYPE',      5, 'Y', 80,  'FPText', 'C', 'M' FROM DUAL UNION ALL
      SELECT 'main', 'LARGE_LABEL',    'LBL_DMF0043_LARGE_GROUP',   6, 'N', 120, 'FPText', 'C', 'S' FROM DUAL UNION ALL
      SELECT 'main', 'SMALL_LABEL',    'LBL_DMF0043_SMALL_GROUP',   7, 'N', 120, 'FPText', 'C', 'S' FROM DUAL UNION ALL
      SELECT 'main', 'SUM_VALUE',      'LBL_DMF0043_SUM',           8, 'N', 100, 'FPText', 'R', 'S' FROM DUAL UNION ALL
      -- version popup sheet (Sales Plan Version 선택)
      SELECT 'version', 'VER_SEQ',     'LBL_DMF0043_VER_SEQ',       1, 'Y', 70,  'FPText', 'C', 'S' FROM DUAL UNION ALL
      SELECT 'version', 'YYYY',        'LBL_DMF0043_YYYY',          2, 'Y', 70,  'FPText', 'C', 'M' FROM DUAL UNION ALL
      SELECT 'version', 'VERSION_NM',  'LBL_DMF0043_VERSION_NM',    3, 'N', 200, 'FPText', 'L', 'M' FROM DUAL UNION ALL
      SELECT 'version', 'VALID_YN',    'LBL_DMF0043_VALID_YN',      4, 'N', 60,  'FPCheck','C', 'M' FROM DUAL UNION ALL
      SELECT 'version', 'DESCRIPTION', 'LBL_DMF0043_DESCRIPTION',   5, 'N', 300, 'FPText', 'L', 'M' FROM DUAL
    ) NEW
   WHERE NOT EXISTS (
     SELECT 1 FROM SCM_MST_SHEET_COLUMNS T
      WHERE T.PROGRAM_ID = 'DMF0043_01'
        AND T.SHEET_NAME = NEW.SHT_NM
        AND T.COLUMN_NAME = NEW.COL_NM
   );

  ----------------------------------------------------------------------------
  -- BLOCK 7 : SCM_ADM_USER_GR_MNU_MPG_M + ..._BTN_MPG_M (권한 — DMF0043 Main 의 복제)
  ----------------------------------------------------------------------------
  -- 메뉴 권한
  INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M
    (USER_GR_ID, MNU_ID, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT USER_GR_ID, 'DMF0043_01', 'Y',
         'admin', SYSDATE, 'admin', SYSDATE
    FROM SCM_ADM_USER_GR_MNU_MPG_M
   WHERE MNU_ID = 'DMF0043'
     AND USE_YN = 'Y'
     AND NOT EXISTS (
       SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M T
        WHERE T.USER_GR_ID = SCM_ADM_USER_GR_MNU_MPG_M.USER_GR_ID
          AND T.MNU_ID = 'DMF0043_01'
     );

  -- 버튼 권한 : DMF0043_01 의 실제 버튼 8개 × DMF0043 권한 그룹
  INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M
    (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT DISTINCT UGB.USER_GR_ID, 'DMF0043_01', BTN.SHT_NM, BTN.MNU_BTN_CD, 'Y',
         'admin', SYSDATE, 'admin', SYSDATE
    FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M UGB
    JOIN SCM_ADM_MNU_BTN_MPG_M BTN
      ON BTN.MNU_ID = 'DMF0043_01'
   WHERE UGB.MNU_ID = 'DMF0043'
     AND UGB.USE_YN = 'Y'
     AND NOT EXISTS (
       SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M T
        WHERE T.USER_GR_ID = UGB.USER_GR_ID
          AND T.MNU_ID = 'DMF0043_01'
          AND T.SHT_NM = BTN.SHT_NM
          AND T.MNU_BTN_CD = BTN.MNU_BTN_CD
     );

  COMMIT;
END;
