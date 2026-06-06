--==============================================================================
-- 040_71_DMF0043_API_BTN_MPG_Full_Resync_DBeaver.sql
--
-- 원인: 클라우드 SCM_ADM_API_M / SCM_ADM_MNU_BTN_MPG_M 의 DMF0043 routing 누락.
--       (진단 결과 API_M 에 1행만 존재. P_DMF0043_xxx 행 9건 누락.)
--       BE 호출 시 PR_GET_PROC_INFO_LIST → chain 끊김 → 잘못된 row → -9994.
--
-- 룰: Doc/_dev_rules/hooks/dbeaver-sql-mandatory-grep (SQL*Plus 0건)
-- 멱등: NOT EXISTS 가드 (재실행 안전)
-- 원본: _artifacts/41_DMF0043_meta.sql BLOCK 2 + BLOCK 3
--
-- 작성: 2026-06-04
--==============================================================================

-- BLOCK 1 : SCM_ADM_MSG_M (i18n KO) — API_MSG_ID 가 NOT NULL FK 일 수 있어 선등록
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, 'KO', NEW.MSG_NM, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'MSG_API_DMF0043_MAIN_GET'          AS MSG_ID, '기여율 메인 조회'              AS MSG_NM FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0043_MAIN_SAVE',                    '기여율 메인 저장'                       FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0043_VERSION_GET',                  '기여율 버전 조회'                       FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0043_VERSION_SAVE',                 '기여율 버전 저장'                       FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0043_SALES_LIST_GET',               '매출 목록 조회'                         FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0043_YEAR_POPUP',                   '년도 POPUP 조회'                        FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0043_RATE_POPUP',                   '기여율 POPUP 조회'                      FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0043_VERSION_POPUP',                '버전 POPUP 조회'                        FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0043_MAIN_TITLE',                   '메인 스프레드 헤더 조회'                FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0043_SALES_LIST_TITLE',             '매출 목록 헤더 조회'                    FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID = NEW.MSG_ID AND X.LANG_CD = 'KO'
 );

-- BLOCK 2 : SCM_ADM_API_M — 10 row 보강
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

-- BLOCK 3 : SCM_ADM_MNU_BTN_MPG_M — 10 row 보강 (메뉴-버튼 → API_ID 매핑)
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

-- BLOCK 4 : 검증 — main/SEARCH chain 정합
SELECT BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD,
       BTN.API_ID AS BTN_API_ID,
       API.API_URL,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M P WHERE P.PROC_NM = API.API_URL) AS PROC_M_COL_CNT,
       CASE
         WHEN API.API_URL IS NULL THEN 'FAIL: API_M missing'
         WHEN (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M P WHERE P.PROC_NM = API.API_URL) = 0 THEN 'FAIL: PROC_M missing'
         ELSE 'PASS'
       END AS RESULT
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
  LEFT JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID = BTN.API_ID
 WHERE BTN.MNU_ID = 'DMF0043'
 ORDER BY BTN.SHT_NM, BTN.MNU_BTN_CD;

COMMIT;
