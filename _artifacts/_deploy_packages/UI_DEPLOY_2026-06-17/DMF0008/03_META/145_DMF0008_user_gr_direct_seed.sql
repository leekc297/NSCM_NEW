--==============================================================================
-- 145_DMF0008_user_gr_direct_seed.sql
--
-- DMF0008 — USER_GR_MNU_BTN_MPG_M 직접 시드 (권한 없음 alert 3회 사고 fix)
-- =============================================================================
-- 작성: 2026-06-17 (DMF0008 화면 진입 시 권한 없음 alert 3회 사용자 보고 후)
--
-- 배경:
--   화면 진입 시 자동 호출되는 3 sheet (summary/repair/updateHistory) 의
--   SCM_ADM_USER_GR_MNU_BTN_MPG_M GUEST + minyonglee1 USER_GR 권한 미등록 →
--   BE 가 권한 없음 응답 (-9994 또는 401) → useTabProcQuery 자동 alert 3회.
--
--   140 file 의 BLOCK 2 는 sister 그룹 (DMF0005/DMF0004) SEARCH 권한 가진 USER_GR
--   를 동적 복사. 사용자 그룹이 sister 권한 없으면 작동 안 함 → 직접 시드 보강.
--
-- BLOCK 구성:
--   AUDIT  : 현 USER_GR 인벤토리 (DMF0008 × 핵심 sheet × SEARCH)
--   BLOCK 1: GUEST USER_GR 직접 INSERT — DMF0008 핵심 5 sheet × SEARCH
--   BLOCK 2: minyonglee1 의 USER_GR (SCM_ADM_USER_M JOIN) 도 동일 권한 시드
--
-- 멱등성: NOT EXISTS — 재실행 안전.
--==============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === AUDIT : 현 USER_GR 의 DMF0008 권한 ===

SELECT USER_GR_ID, SHT_NM, MNU_BTN_CD, USE_YN
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0008'
 ORDER BY USER_GR_ID, SHT_NM, MNU_BTN_CD;

PROMPT === BLOCK 1 : GUEST 직접 시드 — DMF0008 × 5 sheet × SEARCH ===

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

PROMPT === BLOCK 2 : minyonglee1 USER_GR 도 동일 시드 ===

INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT u.USER_GR_ID, 'DMF0008', NEW.SHT_NM, NEW.MNU_BTN_CD, 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_USER_M u
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
 WHERE u.USER_ID = 'minyonglee1' AND u.USER_GR_ID IS NOT NULL
   AND NOT EXISTS (
     SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M e
      WHERE e.USER_GR_ID = u.USER_GR_ID AND e.MNU_ID = 'DMF0008'
        AND e.SHT_NM = NEW.SHT_NM AND e.MNU_BTN_CD = NEW.MNU_BTN_CD
   );

COMMIT;

PROMPT === POST-AUDIT : 적용 후 USER_GR 인벤토리 ===

SELECT USER_GR_ID, SHT_NM, MNU_BTN_CD, USE_YN
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0008'
 ORDER BY USER_GR_ID, SHT_NM, MNU_BTN_CD;

SELECT USER_GR_ID, COUNT(*) AS BTN_CNT
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0008' AND USE_YN = 'Y'
 GROUP BY USER_GR_ID
 ORDER BY USER_GR_ID;

PROMPT === 145_DMF0008_user_gr_direct_seed.sql 완료 ===

--==============================================================================
-- 적용 후 FE 검증:
--   1) DMF0008 화면 진입 시 권한 없음 alert 0회 기대
--   2) Summary / Repair / UpdateHistory 모두 정상 조회
--   3) Last Update Start / End 데이터 표시 (UpdateHistory SP 결과)
--   4) Status Update button 동작 정상
--==============================================================================
