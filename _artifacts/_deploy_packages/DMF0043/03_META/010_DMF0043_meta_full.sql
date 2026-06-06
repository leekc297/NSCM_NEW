--==============================================================================
-- 41_DMF0043_meta.sql
--
-- 목적:
--   DMF0043 (Contribute Main) 화면용 DB 메타 등록.
--   - SCM_ADM_MSG_M            : API 메시지 i18n 10 건 (1 lang KO)
--   - SCM_ADM_API_M            : API 정의 10 건 (standalone SP redirect)
--   - SCM_ADM_MNU_BTN_MPG_M    : 시트별 버튼-API 매핑 10 건
--   - SCM_ADM_PROC_M           : 10 SP × 인자 매핑 (총 73 행)
--   - SCM_ADM_USER_GR_MNU_BTN_MPG_M : GUEST 버튼 권한 10 건 (BTN_MPG 복제)
--
-- 매핑 룰 (룰 29 / 메모리 feedback_proc_meta_col_nm_be_auto_keys):
--   - P_USER_ID    → sesUserId  (BE 자동 채움)
--   - P_MENU_ID    → mnuId      (BE 자동 채움)
--   - P_CREATED_BY → sesUserId  (BE 자동 채움 — 동일 값 binding)
--   - 그 외 IN     → camelCase
--   - OUT REF CURSOR → 원래 이름 그대로 (o_rc1/o_rc2/o_rc3/p_cursor_*)
--
-- 멱등성: 모든 INSERT 는 NOT EXISTS / MERGE 가드. 재실행 시 0 행 영향.
-- 작성: 2026-05-30
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET LINESIZE 200
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : SCM_ADM_MSG_M (API 메시지 10 건) ===

INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM, MSG_DESC, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, 'KO', 'API', NEW.MSG_NM, NEW.MSG_NM, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'MSG_API_DMF0043_MAIN_GET'         AS MSG_ID, '기여율 메인 조회'              AS MSG_NM FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0043_MAIN_SAVE',             '기여율 메인 저장'                            FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0043_VERSION_GET',           '기여율 버전 조회'                            FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0043_VERSION_SAVE',          '기여율 버전 저장'                            FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0043_SALES_LIST_GET',        '매출 목록 조회'                              FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0043_YEAR_POPUP',            '년도 POPUP 조회'                             FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0043_RATE_POPUP',            '기여율 POPUP 조회'                           FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0043_VERSION_POPUP',         '버전 POPUP 조회'                             FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0043_MAIN_TITLE',            '메인 스프레드 헤더 조회'                     FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0043_SALES_LIST_TITLE',      '매출 목록 헤더 조회'                         FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID = NEW.MSG_ID AND X.LANG_CD = 'KO'
 );

PROMPT === BLOCK 2 : SCM_ADM_API_M (10 건) ===

INSERT INTO SCM_MGR.SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.API_ID, NEW.API_TP_CD, NEW.API_MSG_ID, NEW.API_MSG_DESC, NEW.API_URL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'P_DMF0043_MAIN_GET'           AS API_ID, 'PROC_SELECT' AS API_TP_CD, 'MSG_API_DMF0043_MAIN_GET'         AS API_MSG_ID, '기여율 메인 조회'              AS API_MSG_DESC, 'DMF0043_GET_CONTRIBUTE_MAIN_DATA'        AS API_URL FROM DUAL UNION ALL
    SELECT 'P_DMF0043_MAIN_SAVE',                   'PROC_SAVE',                'MSG_API_DMF0043_MAIN_SAVE',                   '기여율 메인 저장',                              'DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO'          FROM DUAL UNION ALL
    SELECT 'P_DMF0043_VERSION_GET',                 'PROC_SELECT',              'MSG_API_DMF0043_VERSION_GET',                 '기여율 버전 조회',                              'DMF0043_GET_MAIN_VARSION_DATA'                 FROM DUAL UNION ALL
    SELECT 'P_DMF0043_VERSION_SAVE',                'PROC_SAVE',                'MSG_API_DMF0043_VERSION_SAVE',                '기여율 버전 저장',                              'DMF0043_SAVE_DM_MST_CONTRIBUTE_VER'            FROM DUAL UNION ALL
    SELECT 'P_DMF0043_SALES_LIST_GET',              'PROC_SELECT',              'MSG_API_DMF0043_SALES_LIST_GET',              '매출 목록 조회',                                'DMF0043_GET_CONTRIBUTION_SALES_LIST'           FROM DUAL UNION ALL
    SELECT 'P_DMF0043_YEAR_POPUP',                  'PROC_SELECT',              'MSG_API_DMF0043_YEAR_POPUP',                  '년도 POPUP 조회',                               'DMF0043_GET_CONTRIBUTE_YEAR_POPUP'             FROM DUAL UNION ALL
    SELECT 'P_DMF0043_RATE_POPUP',                  'PROC_SELECT',              'MSG_API_DMF0043_RATE_POPUP',                  '기여율 POPUP 조회',                             'DMF0043_GET_CONTRIBUTE_RATE_POPUP'             FROM DUAL UNION ALL
    SELECT 'P_DMF0043_VERSION_POPUP',               'PROC_SELECT',              'MSG_API_DMF0043_VERSION_POPUP',               '버전 POPUP 조회',                               'DMF0043_GET_CONT_VIEW_VERSIONPOPUP'            FROM DUAL UNION ALL
    SELECT 'P_DMF0043_MAIN_TITLE',                  'PROC_SELECT',              'MSG_API_DMF0043_MAIN_TITLE',                  '메인 스프레드 헤더 조회',                       'DMF0043_GET_MAIN_SPREAD_TITLE'                 FROM DUAL UNION ALL
    SELECT 'P_DMF0043_SALES_LIST_TITLE',            'PROC_SELECT',              'MSG_API_DMF0043_SALES_LIST_TITLE',            '매출 목록 헤더 조회',                           'DMF0043_GET_SALES_LIST_SPREAD_TITLE'           FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_API_M X WHERE X.API_ID = NEW.API_ID
 );

PROMPT === BLOCK 3 : SCM_ADM_MNU_BTN_MPG_M (10 건) ===

INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0043', NEW.SHT_NM, NEW.MNU_BTN_CD, NEW.API_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'main'              AS SHT_NM, 'SEARCH' AS MNU_BTN_CD, 'P_DMF0043_MAIN_GET'         AS API_ID FROM DUAL UNION ALL
    SELECT 'main',                       'SAVE',                  'P_DMF0043_MAIN_SAVE'                  FROM DUAL UNION ALL
    SELECT 'mainTitle',                  'SEARCH',                'P_DMF0043_MAIN_TITLE'                 FROM DUAL UNION ALL
    SELECT 'version',                    'SEARCH',                'P_DMF0043_VERSION_GET'                FROM DUAL UNION ALL
    SELECT 'version',                    'SAVE',                  'P_DMF0043_VERSION_SAVE'               FROM DUAL UNION ALL
    SELECT 'yearPopup',                  'SEARCH',                'P_DMF0043_YEAR_POPUP'                 FROM DUAL UNION ALL
    SELECT 'ratePopup',                  'SEARCH',                'P_DMF0043_RATE_POPUP'                 FROM DUAL UNION ALL
    SELECT 'versionPopup',               'SEARCH',                'P_DMF0043_VERSION_POPUP'              FROM DUAL UNION ALL
    SELECT 'salesList',                  'SEARCH',                'P_DMF0043_SALES_LIST_GET'             FROM DUAL UNION ALL
    SELECT 'salesListTitle',             'SEARCH',                'P_DMF0043_SALES_LIST_TITLE'           FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X
    WHERE X.MNU_ID='DMF0043' AND X.SHT_NM=NEW.SHT_NM AND X.MNU_BTN_CD=NEW.MNU_BTN_CD
 );

PROMPT === BLOCK 4 : SCM_ADM_PROC_M (10 SP × 인자 매핑) ===

INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.PROC_NM, NEW.COL_NM, NEW.DATA_TP_CD, NEW.COL_TP_CD, NEW.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    -- SP 1: DMF0043_GET_CONTRIBUTE_MAIN_DATA (IN: P_YYYY, P_VER_SEQ, P_DIS, P_HIS, P_CREATED_BY, P_USER_GROUP / OUT: O_RC1)
    SELECT 'DMF0043_GET_CONTRIBUTE_MAIN_DATA' AS PROC_NM, 'yyyy'      AS COL_NM, 'VARCHAR' AS DATA_TP_CD, 'IN'  AS COL_TP_CD, 1  AS SORT_ORD FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTE_MAIN_DATA',           'verSeq',                 'VARCHAR',               'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTE_MAIN_DATA',           'dis',                    'VARCHAR',               'IN',                3 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTE_MAIN_DATA',           'his',                    'VARCHAR',               'IN',                4 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTE_MAIN_DATA',           'sesUserId',              'VARCHAR',               'IN',                5 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTE_MAIN_DATA',           'userGroup',              'VARCHAR',               'IN',                6 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTE_MAIN_DATA',           'o_rc1',                  'CURSOR',                'OUT',               7 FROM DUAL UNION ALL
    -- SP 2: DMF0043_GET_CONTRIBUTE_RATE_POPUP (IN: P_YYYY / OUT: O_RC1, O_RESULT_CURSOR)
    SELECT 'DMF0043_GET_CONTRIBUTE_RATE_POPUP',          'yyyy',                   'VARCHAR',               'IN',                1 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTE_RATE_POPUP',          'o_rc1',                  'CURSOR',                'OUT',               2 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTE_RATE_POPUP',          'O_RESULT_CURSOR',        'PROC_RESULT',           'OUT',               3 FROM DUAL UNION ALL
    -- SP 3: DMF0043_GET_CONTRIBUTE_YEAR_POPUP (IN: P_USER_ID, P_MENU_ID / OUT: O_RC1)
    SELECT 'DMF0043_GET_CONTRIBUTE_YEAR_POPUP',          'sesUserId',              'VARCHAR',               'IN',                1 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTE_YEAR_POPUP',          'mnuId',                  'VARCHAR',               'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTE_YEAR_POPUP',          'o_rc1',                  'CURSOR',                'OUT',               3 FROM DUAL UNION ALL
    -- SP 4: DMF0043_GET_CONT_VIEW_VERSIONPOPUP (IN 7 / OUT: O_RC1)
    SELECT 'DMF0043_GET_CONT_VIEW_VERSIONPOPUP',         'startYyyymmdd',          'VARCHAR',               'IN',                1 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONT_VIEW_VERSIONPOPUP',         'endYyyymmdd',            'VARCHAR',               'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONT_VIEW_VERSIONPOPUP',         'divisionId',             'VARCHAR',               'IN',                3 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONT_VIEW_VERSIONPOPUP',         'versionType',            'VARCHAR',               'IN',                4 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONT_VIEW_VERSIONPOPUP',         'description',            'VARCHAR',               'IN',                5 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONT_VIEW_VERSIONPOPUP',         'sesUserId',              'VARCHAR',               'IN',                6 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONT_VIEW_VERSIONPOPUP',         'mnuId',                  'VARCHAR',               'IN',                7 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONT_VIEW_VERSIONPOPUP',         'o_rc1',                  'CURSOR',                'OUT',               8 FROM DUAL UNION ALL
    -- SP 5: DMF0043_GET_MAIN_SPREAD_TITLE (IN: P_DIVISION_ID, P_YYYY, P_CREATED_BY, P_USER_ID, P_MENU_ID / OUT: O_RC1, O_RC2, O_RC3)
    --        P_CREATED_BY + P_USER_ID 모두 sesUserId 로 통합 (PK 충돌 회피)
    SELECT 'DMF0043_GET_MAIN_SPREAD_TITLE',              'divisionId',             'VARCHAR',               'IN',                1 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_MAIN_SPREAD_TITLE',              'yyyy',                   'VARCHAR',               'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_MAIN_SPREAD_TITLE',              'sesUserId',              'VARCHAR',               'IN',                3 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_MAIN_SPREAD_TITLE',              'mnuId',                  'VARCHAR',               'IN',                4 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_MAIN_SPREAD_TITLE',              'o_rc1',                  'CURSOR',                'OUT',               5 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_MAIN_SPREAD_TITLE',              'o_rc2',                  'CURSOR',                'OUT',               6 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_MAIN_SPREAD_TITLE',              'o_rc3',                  'CURSOR',                'OUT',               7 FROM DUAL UNION ALL
    -- SP 6: DMF0043_GET_MAIN_VARSION_DATA (IN: P_USER_ID, P_MENU_ID / OUT: O_RC1)
    SELECT 'DMF0043_GET_MAIN_VARSION_DATA',              'sesUserId',              'VARCHAR',               'IN',                1 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_MAIN_VARSION_DATA',              'mnuId',                  'VARCHAR',               'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_MAIN_VARSION_DATA',              'o_rc1',                  'CURSOR',                'OUT',               3 FROM DUAL UNION ALL
    -- SP 7: DMF0043_GET_SALES_LIST_SPREAD_TITLE (IN: P_DIVISION_ID, P_CREATED_BY, P_USER_ID, P_MENU_ID / OUT: O_RC1)
    SELECT 'DMF0043_GET_SALES_LIST_SPREAD_TITLE',        'divisionId',             'VARCHAR',               'IN',                1 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_SALES_LIST_SPREAD_TITLE',        'sesUserId',              'VARCHAR',               'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_SALES_LIST_SPREAD_TITLE',        'mnuId',                  'VARCHAR',               'IN',                3 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_SALES_LIST_SPREAD_TITLE',        'o_rc1',                  'CURSOR',                'OUT',               4 FROM DUAL UNION ALL
    -- SP 8: DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO (IN 13 / OUT: O_RC1)
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO',       'activeFlag',             'VARCHAR',               'IN',                1 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO',       'verSeq',                 'VARCHAR',               'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO',       'departmentId',           'VARCHAR',               'IN',                3 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO',       'deptId',                 'VARCHAR',               'IN',                4 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO',       'endCustReport',          'VARCHAR',               'IN',                5 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO',       'soldtoCustReport',       'VARCHAR',               'IN',                6 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO',       'productGroup',           'VARCHAR',               'IN',                7 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO',       'dmBizType',              'VARCHAR',               'IN',                8 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO',       'yyyymm',                 'VARCHAR',               'IN',                9 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO',       'osCorpCd',               'VARCHAR',               'IN',               10 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO',       'contributionType',       'VARCHAR',               'IN',               11 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO',       'contributionRatio',      'VARCHAR',               'IN',               12 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO',       'sesUserId',              'VARCHAR',               'IN',               13 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO',       'o_rc1',                  'CURSOR',                'OUT',              14 FROM DUAL UNION ALL
    -- SP 9: DMF0043_SAVE_DM_MST_CONTRIBUTE_VER (IN 7 / OUT: O_RC1, O_RC2)
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_VER',         'activeFlag',             'VARCHAR',               'IN',                1 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_VER',         'verSeq',                 'VARCHAR',               'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_VER',         'yyyy',                   'VARCHAR',               'IN',                3 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_VER',         'versionNm',              'VARCHAR',               'IN',                4 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_VER',         'description',            'VARCHAR',               'IN',                5 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_VER',         'validYn',                'VARCHAR',               'IN',                6 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_VER',         'sesUserId',              'VARCHAR',               'IN',                7 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_VER',         'o_rc1',                  'CURSOR',                'OUT',               8 FROM DUAL UNION ALL
    SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_VER',         'o_rc2',                  'CURSOR',                'OUT',               9 FROM DUAL UNION ALL
    -- SP 10: DMF0043_GET_CONTRIBUTION_SALES_LIST (IN 9 / OUT: P_CURSOR_MAIN, P_CURSOR_SORT, P_CURSOR_CNT)
    SELECT 'DMF0043_GET_CONTRIBUTION_SALES_LIST',        'divisionId',             'VARCHAR',               'IN',                1 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTION_SALES_LIST',        'verSeq',                 'VARCHAR',               'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTION_SALES_LIST',        'versionNo',              'VARCHAR',               'IN',                3 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTION_SALES_LIST',        'endCustReport',          'VARCHAR',               'IN',                4 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTION_SALES_LIST',        'productGroup',           'VARCHAR',               'IN',                5 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTION_SALES_LIST',        'bizType',                'VARCHAR',               'IN',                6 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTION_SALES_LIST',        'millionYn',              'VARCHAR',               'IN',                7 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTION_SALES_LIST',        'compatibilityYn',        'VARCHAR',               'IN',                8 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTION_SALES_LIST',        'sesUserId',              'VARCHAR',               'IN',                9 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTION_SALES_LIST',        'p_cursor_main',          'CURSOR',                'OUT',              10 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTION_SALES_LIST',        'p_cursor_sort',          'CURSOR',                'OUT',              11 FROM DUAL UNION ALL
    SELECT 'DMF0043_GET_CONTRIBUTION_SALES_LIST',        'p_cursor_cnt',           'CURSOR',                'OUT',              12 FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_PROC_M X
    WHERE X.PROC_NM = NEW.PROC_NM AND X.COL_NM = NEW.COL_NM AND X.COL_TP_CD = NEW.COL_TP_CD
 );

PROMPT === BLOCK 5 : SCM_ADM_USER_GR_MNU_BTN_MPG_M (GUEST × 10) ===

INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'GUEST', BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
 WHERE BTN.MNU_ID = 'DMF0043'
   AND BTN.USE_YN = 'Y'
   AND NOT EXISTS (
     SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X
      WHERE X.USER_GR_ID = 'GUEST'
        AND X.MNU_ID     = BTN.MNU_ID
        AND X.SHT_NM     = BTN.SHT_NM
        AND X.MNU_BTN_CD = BTN.MNU_BTN_CD
   );

PROMPT === BLOCK 6 : 사후 카운트 ===

SELECT 'POST: MSG_M (10)' AS K, COUNT(*) AS V FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID LIKE 'MSG_API_DMF0043%'
UNION ALL
SELECT 'POST: API_M (10)', COUNT(*) FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE 'P_DMF0043%'
UNION ALL
SELECT 'POST: BTN_MPG (10)', COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0043'
UNION ALL
SELECT 'POST: PROC_M (73)', COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE 'DMF0043_%'
UNION ALL
SELECT 'POST: GUEST BTN PERM (10)', COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE USER_GR_ID='GUEST' AND MNU_ID='DMF0043';

COMMIT;

PROMPT === COMPLETE ===
EXIT;
