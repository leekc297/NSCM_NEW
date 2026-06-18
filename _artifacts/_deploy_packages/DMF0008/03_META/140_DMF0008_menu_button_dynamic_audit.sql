-- =====================================================================
-- DMF0008 — Menu Button 동적 fetch 적용 audit + 보강
-- =====================================================================
-- 작성: 2026-06-17 (4 화면 재작업 — DMF0008 / 43 / 43_01 / 72)
-- 적용 hook:
--   _rules_v2/hooks/ui-dynamic-property-management.md §3 (Menu Button)
--   _rules_v2/hooks/menu-button-dynamic-fetch.md
--   _rules_v2/hooks/column-meta-rework-checklist.md §1.1
--
-- 목적: FE 가 `useTabBtnPermissions({ menuId: 'DMF0008' })` + `hasButton(...)` 로 전환됨.
--   BE GET /admin/menu/DMF0008/auth → SCM_ADM_USER_GR_MNU_BTN_MPG_M JOIN 결과 list 반환.
--   sheet 무관 union. 따라서 SHT_NM 별 USE_YN='Y' 가 1건 이상 있어야 hasButton(BTN_CD) 결과 true.
--
-- 핵심 button 코드 (ErpEdiMaster.tsx 분석):
--   SEARCH        — hotkeyConfig.search → setSummaryFilters (Summary grid 조회)
--   SAVE          — hotkeyConfig.save → handleSave (Sales Site 또는 SSPM 저장)
--   INSERT        — hotkeyConfig.insert → handleInsert (Sales Site / SSPM)
--   STATUS_UPDATE — customButtons → P_DMF0008_STATUS_UPDATE
--   EXCEL         — SubTitle DefaultButtonActions 자동
--
-- 적용 순서:
--   1) AUDIT 블록 실행 → 현 상태 확인
--   2) 누락 시 BLOCK 1 (BTN_MPG_M) + BLOCK 2 (USER_GR_*) 실행
--   3) POST-AUDIT 재확인 → 모든 row USE_YN='Y' 확인
--
-- 적용 환경: SQL*Plus / SQLcl / DBeaver Execute Script. 사내 SCM_MGR.
-- DDL grep: SCM_ADM_MNU_BTN_MPG_M + SCM_ADM_USER_GR_MNU_BTN_MPG_M 컬럼 확정됨 (010 file 기준).
-- =====================================================================

PROMPT === AUDIT 1 : 현 DMF0008 BTN_MPG_M 인벤토리 ===

SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, TO_CHAR(LAST_UPDATE_DATE, 'YYYY-MM-DD') AS LUD
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0008'
 ORDER BY SHT_NM, MNU_BTN_CD;

PROMPT === AUDIT 2 : 현 DMF0008 USER_GR_MNU_BTN_MPG_M 인벤토리 (USER_GR_ID 별) ===

SELECT USER_GR_ID, COUNT(*) AS CNT, LISTAGG(SHT_NM || '/' || MNU_BTN_CD, ', ')
         WITHIN GROUP (ORDER BY SHT_NM, MNU_BTN_CD) AS PERMISSIONS
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0008' AND USE_YN = 'Y'
 GROUP BY USER_GR_ID
 ORDER BY USER_GR_ID;

PROMPT === AUDIT 3 : 표준 button 누락 검출 (4 sheet × 핵심 button) ===

WITH EXPECTED AS (
  SELECT 'summary'   AS SHT_NM, 'SEARCH'        AS MNU_BTN_CD FROM DUAL UNION ALL
  SELECT 'repair',                'SEARCH'                    FROM DUAL UNION ALL
  SELECT 'salesSite',             'SEARCH'                    FROM DUAL UNION ALL
  SELECT 'salesSite',             'INSERT'                    FROM DUAL UNION ALL
  SELECT 'salesSite',             'SAVE'                      FROM DUAL UNION ALL
  SELECT 'sspm',                  'SEARCH'                    FROM DUAL UNION ALL
  SELECT 'sspm',                  'INSERT'                    FROM DUAL UNION ALL
  SELECT 'sspm',                  'SAVE'                      FROM DUAL UNION ALL
  SELECT 'main',                  'STATUS_UPDATE'             FROM DUAL
)
SELECT E.SHT_NM, E.MNU_BTN_CD, '누락 — BTN_MPG_M 등록 필요' AS STATUS
  FROM EXPECTED E
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X
    WHERE X.MNU_ID = 'DMF0008' AND X.SHT_NM = E.SHT_NM AND X.MNU_BTN_CD = E.MNU_BTN_CD
 );

PROMPT === BLOCK 1 : 누락 button NOT EXISTS INSERT (SCM_ADM_MNU_BTN_MPG_M) ===

-- API_ID 는 기존 등록된 SP 와 매핑. 사내 SCM_ADM_API_M 에 API_ID 가 없으면 NULL 로 등록 (BE 가 hasButton 만 사용)
INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
  (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0008', NEW.SHT_NM, NEW.MNU_BTN_CD, NEW.API_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'summary'   AS SHT_NM, 'SEARCH'        AS MNU_BTN_CD, 'P_DMF0008_SUMMARY_GET'                 AS API_ID FROM DUAL UNION ALL
    SELECT 'repair',                'SEARCH',                     'P_DMF0008_REPAIR_GET'                            FROM DUAL UNION ALL
    SELECT 'salesSite',             'SEARCH',                     'P_DMF0008_SALES_SITE_GET'                        FROM DUAL UNION ALL
    SELECT 'salesSite',             'INSERT',                     NULL                                              FROM DUAL UNION ALL
    SELECT 'salesSite',             'SAVE',                       'P_DMF0008_SAVE_SALES_SITE_EDI_REPAIR'            FROM DUAL UNION ALL
    SELECT 'sspm',                  'SEARCH',                     'P_DMF0008_SSPM_GET'                              FROM DUAL UNION ALL
    SELECT 'sspm',                  'INSERT',                     NULL                                              FROM DUAL UNION ALL
    SELECT 'sspm',                  'SAVE',                       'P_DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR'    FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X
    WHERE X.MNU_ID = 'DMF0008' AND X.SHT_NM = NEW.SHT_NM AND X.MNU_BTN_CD = NEW.MNU_BTN_CD
 );

PROMPT === BLOCK 2 : USER_GR_MNU_BTN_MPG_M 자매 그룹 동적 복사 ===

-- 자매 화면 (DMF0005 / DMF0004) 에서 SEARCH 권한을 가진 모든 USER_GR_ID 를 DMF0008 의 모든 sheet 의 모든 핵심 button 에 동적 복사
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT u.USER_GR_ID, 'DMF0008', T.SHT_NM, T.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M u
 CROSS JOIN (
    SELECT 'summary' SHT_NM, 'SEARCH' MNU_BTN_CD FROM DUAL UNION ALL
    SELECT 'repair',         'SEARCH'            FROM DUAL UNION ALL
    SELECT 'salesSite',      'SEARCH'            FROM DUAL UNION ALL
    SELECT 'salesSite',      'INSERT'            FROM DUAL UNION ALL
    SELECT 'salesSite',      'SAVE'              FROM DUAL UNION ALL
    SELECT 'sspm',           'SEARCH'            FROM DUAL UNION ALL
    SELECT 'sspm',           'INSERT'            FROM DUAL UNION ALL
    SELECT 'sspm',           'SAVE'              FROM DUAL UNION ALL
    SELECT 'main',           'STATUS_UPDATE'     FROM DUAL
 ) T
 WHERE u.MNU_ID IN ('DMF0005', 'DMF0004') AND u.SHT_NM IN ('main', 'production') AND u.MNU_BTN_CD = 'SEARCH' AND u.USE_YN = 'Y'
   AND NOT EXISTS (
     SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M e
      WHERE e.USER_GR_ID = u.USER_GR_ID AND e.MNU_ID = 'DMF0008'
        AND e.SHT_NM = T.SHT_NM AND e.MNU_BTN_CD = T.MNU_BTN_CD
   );

COMMIT;

PROMPT === POST-AUDIT : 적용 후 결과 ===

SELECT MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0008'
 ORDER BY SHT_NM, MNU_BTN_CD;

SELECT USER_GR_ID, COUNT(*) AS BTN_CNT
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0008' AND USE_YN = 'Y'
 GROUP BY USER_GR_ID
 ORDER BY USER_GR_ID;

-- =====================================================================
-- 적용 후 FE 검증:
--   1) DevTools Network 탭에서 GET /admin/menu/DMF0008/auth → 200 + mnuBtnAuth list 확인
--   2) ErpEdiMaster 진입 → SubTitle 의 SEARCH / SAVE / INSERT 버튼 visible/enable
--   3) Status Update customButton visible 확인
--   4) admin SYS0009 에서 DMF0008/main/STATUS_UPDATE USE_YN='N' → 화면 재진입 시 즉시 숨김
-- =====================================================================
