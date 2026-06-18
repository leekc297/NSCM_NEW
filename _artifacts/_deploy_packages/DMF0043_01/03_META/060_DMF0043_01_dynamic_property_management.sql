--==============================================================================
-- 060_DMF0043_01_dynamic_property_management.sql
--
-- DMF0043_01 (Contribute View) — UI 동적 속성관리 (Menu Button) 보강
-- =============================================================================
-- 작성: 2026-06-17 (4 화면 재작업 — DMF0043_01 Step 3)
-- 적용 hook:
--   _rules_v2/hooks/ui-dynamic-property-management.md §3
--   _rules_v2/hooks/menu-button-dynamic-fetch.md
--
-- 변경 FE :
--   - ContributeView.tsx — useTabBtnPermissions + hasButton + customButtons filter
--
-- Column staticColumns 미적용 사유:
--   DMF0043_01 의 Grid 컬럼은 SP `DMF0043_GET_SALES_LIST_SPREAD_TITLE` 가
--   SCM_MST_SHEET_COLUMNS 기반 LARGE/SMALL/leaf 3-row 헤더로 동적 빌드 → admin 메타 변경이
--   이미 SP 경로로 즉시 반영됨. /admin/menu/{MENU_ID}/column 별도 호출은 중복.
--
-- BLOCK 구성:
--   AUDIT   : 현 DMF0043_01 BTN_MPG_M 인벤토리
--   BLOCK 1 : SCM_ADM_MNU_BTN_MPG_M — COLUMN_SET (⊞ 컬럼 표시 설정) custom button 보강
--   BLOCK 2 : SCM_ADM_USER_GR_MNU_BTN_MPG_M — 자매 그룹 동적 복사
--==============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === AUDIT 1 : 현 DMF0043_01 BTN_MPG_M 인벤토리 ===

SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0043_01'
 ORDER BY SHT_NM, MNU_BTN_CD;

PROMPT === AUDIT 2 : 표준 button 누락 검출 ===

WITH EXPECTED_BTN AS (
  SELECT 'main' SHT_NM, 'COLUMN_SET' MNU_BTN_CD FROM DUAL
)
SELECT E.SHT_NM || '/' || E.MNU_BTN_CD AS MISSING
  FROM EXPECTED_BTN E
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X
    WHERE X.MNU_ID = 'DMF0043_01' AND X.SHT_NM = E.SHT_NM AND X.MNU_BTN_CD = E.MNU_BTN_CD
 );

PROMPT === BLOCK 1 : SCM_ADM_MNU_BTN_MPG_M — COLUMN_SET 보강 ===

-- ⊞ 컬럼 표시 설정 custom button (ColumnSettingModal popup 호출)
-- API_ID = 'P_DMF0002_GET_TITLESET_POPUP' (기존 ColumnSettingModal popup SP 재사용)
INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
  (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0043_01', 'main', 'COLUMN_SET', 'P_DMF0002_GET_TITLESET_POPUP', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X
    WHERE X.MNU_ID = 'DMF0043_01' AND X.SHT_NM = 'main' AND X.MNU_BTN_CD = 'COLUMN_SET'
 );

PROMPT === BLOCK 2 : SCM_ADM_USER_GR_MNU_BTN_MPG_M — COLUMN_SET 자매 그룹 동적 복사 ===

INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT u.USER_GR_ID, 'DMF0043_01', 'main', 'COLUMN_SET', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M u
 WHERE u.MNU_ID = 'DMF0043_01' AND u.SHT_NM = 'main' AND u.MNU_BTN_CD = 'SEARCH' AND u.USE_YN = 'Y'
   AND NOT EXISTS (
     SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M e
      WHERE e.USER_GR_ID = u.USER_GR_ID AND e.MNU_ID = 'DMF0043_01'
        AND e.SHT_NM = 'main' AND e.MNU_BTN_CD = 'COLUMN_SET'
   );

COMMIT;

PROMPT === POST-AUDIT : 적용 후 BTN_MPG_M ===
SELECT MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0043_01'
 ORDER BY SHT_NM, MNU_BTN_CD;

PROMPT === 060_DMF0043_01_dynamic_property_management.sql 완료 ===

--==============================================================================
-- 적용 후 FE 검증:
--   1) GET /admin/menu/DMF0043_01/auth → mnuBtnAuth 에 'SEARCH', 'COLUMN_SET' 포함
--   2) admin SYS0009 에서 DMF0043_01/main/COLUMN_SET USE_YN='N' → 화면 재진입 시 ⊞ 버튼 숨김
--
-- 별도 작업 (PIVOT NVL — 사내 DB 환경 필요):
--   _artifacts/_diagnostics/test_dmf0043_01_first_row_null.py 실행
--   → DMF0043_GET_CONTRIBUTION_SALES_LIST cursor 의 dynamic 컬럼 첫 row NULL count 0 기대
--   → NULL 발견 시 pivot-dynamic-column-nvl.md §3 패턴 적용 + sp-patch-file-deploy.md
--==============================================================================
