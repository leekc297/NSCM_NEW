--==============================================================================
-- 160_DMF0008_minyonglee1_permission_fix.sql
--
-- DMF0008 minyonglee1 권한 robust fix (-9997 No Permission 사고 후)
-- =============================================================================
-- 작성: 2026-06-17 (BE response `{"code":"-9997","message":"No Permission"}` 사고 후)
--
-- 145 file 의 BLOCK 2 가정 (SCM_ADM_USER_M.USER_GR_ID 컬럼 직접 매핑) 이 사내 환경과 다를 수 있음.
-- 본 SQL 은 SCM_ADM_USER_GR_MPG_M (사용자 ↔ 그룹 별 mapping 테이블) 기준으로 minyonglee1 의
-- 모든 USER_GR_ID 를 자동 검출하여 직접 권한 INSERT.
--
-- BLOCK 1: minyonglee1 의 모든 USER_GR_ID 에 DMF0008 핵심 11 권한 INSERT
-- BLOCK 2: GUEST USER_GR (login 전 default 그룹) 권한 보강 (145 file 의 BLOCK 1 dedup)
--
-- 적용 후 -9997 No Permission 사고 해소 기대.
--==============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === PRE-CHECK : minyonglee1 그룹 매핑 ===

SELECT USER_ID, USER_GR_ID, USE_YN
  FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M
 WHERE USER_ID = 'minyonglee1';

PROMPT === BLOCK 1 : minyonglee1 그룹 → DMF0008 핵심 11 권한 INSERT ===

-- SCM_ADM_USER_GR_MPG_M (사용자×그룹 매핑) 기준 — minyonglee1 의 모든 그룹에 권한 부여
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT gr.USER_GR_ID, 'DMF0008', NEW.SHT_NM, NEW.MNU_BTN_CD, 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M gr
 CROSS JOIN (
    SELECT 'summary'        AS SHT_NM, 'SEARCH' AS MNU_BTN_CD FROM DUAL UNION ALL
    SELECT 'repair',                    'SEARCH'              FROM DUAL UNION ALL
    SELECT 'repair',                    'SAVE'                FROM DUAL UNION ALL
    SELECT 'salesSite',                 'SEARCH'              FROM DUAL UNION ALL
    SELECT 'salesSite',                 'INSERT'              FROM DUAL UNION ALL
    SELECT 'salesSite',                 'SAVE'                FROM DUAL UNION ALL
    SELECT 'sspm',                      'SEARCH'              FROM DUAL UNION ALL
    SELECT 'sspm',                      'INSERT'              FROM DUAL UNION ALL
    SELECT 'sspm',                      'SAVE'                FROM DUAL UNION ALL
    SELECT 'updateHistory',             'SEARCH'              FROM DUAL UNION ALL
    SELECT 'main',                      'STATUS_UPDATE'       FROM DUAL
 ) NEW
 WHERE gr.USER_ID = 'minyonglee1'
   AND (gr.USE_YN = 'Y' OR gr.USE_YN IS NULL)
   AND NOT EXISTS (
     SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M bt
      WHERE bt.USER_GR_ID = gr.USER_GR_ID AND bt.MNU_ID = 'DMF0008'
        AND bt.SHT_NM = NEW.SHT_NM AND bt.MNU_BTN_CD = NEW.MNU_BTN_CD
   );

PROMPT === BLOCK 2 : GUEST USER_GR (login 전 default) 권한 보강 ===

-- 145 file 의 BLOCK 1 과 동일 — 멱등 (NOT EXISTS) 이므로 재실행 안전
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'GUEST', 'DMF0008', NEW.SHT_NM, NEW.MNU_BTN_CD, 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'summary'        AS SHT_NM, 'SEARCH' AS MNU_BTN_CD FROM DUAL UNION ALL
    SELECT 'repair',                    'SEARCH'              FROM DUAL UNION ALL
    SELECT 'repair',                    'SAVE'                FROM DUAL UNION ALL
    SELECT 'salesSite',                 'SEARCH'              FROM DUAL UNION ALL
    SELECT 'salesSite',                 'INSERT'              FROM DUAL UNION ALL
    SELECT 'salesSite',                 'SAVE'                FROM DUAL UNION ALL
    SELECT 'sspm',                      'SEARCH'              FROM DUAL UNION ALL
    SELECT 'sspm',                      'INSERT'              FROM DUAL UNION ALL
    SELECT 'sspm',                      'SAVE'                FROM DUAL UNION ALL
    SELECT 'updateHistory',             'SEARCH'              FROM DUAL UNION ALL
    SELECT 'main',                      'STATUS_UPDATE'       FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X
    WHERE X.USER_GR_ID = 'GUEST' AND X.MNU_ID = 'DMF0008'
      AND X.SHT_NM = NEW.SHT_NM AND X.MNU_BTN_CD = NEW.MNU_BTN_CD
 );

COMMIT;

PROMPT === POST-CHECK 1 : minyonglee1 그룹 권한 인벤토리 ===

SELECT bt.USER_GR_ID, bt.SHT_NM, bt.MNU_BTN_CD, bt.USE_YN
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M bt
 WHERE bt.MNU_ID = 'DMF0008'
   AND bt.USER_GR_ID IN (
     SELECT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M WHERE USER_ID = 'minyonglee1'
   )
 ORDER BY bt.USER_GR_ID, bt.SHT_NM, bt.MNU_BTN_CD;

PROMPT === POST-CHECK 2 : USER_GR 권한 카운트 ===

SELECT USER_GR_ID, COUNT(*) AS BTN_CNT
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0008' AND USE_YN = 'Y'
 GROUP BY USER_GR_ID
 ORDER BY USER_GR_ID;

PROMPT === 160_DMF0008_minyonglee1_permission_fix.sql 완료 ===

--==============================================================================
-- 적용 절차:
--   1) 150_DMF0008_user_permission_diagnose.sql 먼저 실행 (현 상태 확인)
--   2) DIAG 2 row 0 인 경우 — minyonglee1 의 USER_GR_MPG_M row 자체 없음 → 사내 admin
--      에 사용자 등록 요청 (본 SQL 으로 해결 불가)
--   3) DIAG 2 row ≥ 1 인 경우 — 본 SQL (160) 실행 → 그룹별 권한 보강
--   4) 브라우저 새로고침 → DMF0008 진입 → -9997 사고 해소 기대
--==============================================================================
