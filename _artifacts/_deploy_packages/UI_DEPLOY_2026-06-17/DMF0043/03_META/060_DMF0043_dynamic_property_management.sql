--==============================================================================
-- 060_DMF0043_dynamic_property_management.sql
--
-- DMF0043 (Contribute Main) — UI 동적 속성관리 (Menu Button + SHEET_COLUMNS) 보강
-- =============================================================================
-- 작성: 2026-06-17 (4 화면 재작업 — DMF0043 Step 2)
-- 적용 hook:
--   _rules_v2/hooks/ui-dynamic-property-management.md §3 §4 §6 §7
--   _rules_v2/hooks/column-meta-rework-checklist.md §2.4 §2.5
--   _rules_v2/hooks/ui-category-setup-column-meta.md
--
-- 변경 FE :
--   - ContributeMain.tsx — useTabBtnPermissions + hasButton + customButtons filter
--   - useContributeMainStore.ts — staticColumns + fetchStaticColumns action
--   - ContributeMainGrid.tsx — visibleBaseColumns = BASE.filter(staticColumns)
--
-- BLOCK 구성:
--   AUDIT   : 현 DMF0043 메타 (BTN_MPG_M + SHEET_COLUMNS) 인벤토리
--   BLOCK 1 : SCM_ADM_MNU_BTN_MPG_M — VERSION_MGMT (custom button) 보강
--   BLOCK 2 : SCM_ADM_USER_GR_MNU_BTN_MPG_M — VERSION_MGMT 자매 그룹 동적 복사
--   BLOCK 3 : SCM_MST_SHEET_COLUMNS — BASE 6 컬럼 INSERT (FE BASE_COLUMNS 1:1)
--
-- 멱등성: 모든 INSERT 가 NOT EXISTS 패턴 — 재실행 영향 없음.
--==============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === AUDIT 1 : 현 DMF0043 BTN_MPG_M 인벤토리 ===

SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0043'
 ORDER BY SHT_NM, MNU_BTN_CD;

PROMPT === AUDIT 2 : 현 DMF0043 SHEET_COLUMNS 인벤토리 (main sheet) ===

SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, SORT_ORDER_NO, VISIBLE_FLAG,
       COLUMN_LABEL_NAME, COLUMN_WIDTH, INPUT_TP_CD, HORIZONTAL_ALIGN_CODE
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0043' AND SHEET_NAME = 'main'
 ORDER BY SORT_ORDER_NO;

PROMPT === AUDIT 3 : 표준 button + BASE 6 컬럼 누락 검출 ===

WITH EXPECTED_BTN AS (
  SELECT 'main' SHT_NM, 'VERSION_MGMT' MNU_BTN_CD FROM DUAL
), EXPECTED_COL AS (
  SELECT 'DEPARTMENT_NAME'    COL FROM DUAL UNION ALL
  SELECT 'DEPT_NAME'                FROM DUAL UNION ALL
  SELECT 'END_CUST_REPORT'          FROM DUAL UNION ALL
  SELECT 'SOLDTO_CUST_REPORT'       FROM DUAL UNION ALL
  SELECT 'PRODUCT_GROUP'            FROM DUAL UNION ALL
  SELECT 'DM_BIZ_TYPE'              FROM DUAL
)
SELECT 'BTN_MPG' AS TARGET, E.SHT_NM || '/' || E.MNU_BTN_CD AS MISSING
  FROM EXPECTED_BTN E
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X
                    WHERE X.MNU_ID = 'DMF0043' AND X.SHT_NM = E.SHT_NM AND X.MNU_BTN_CD = E.MNU_BTN_CD)
UNION ALL
SELECT 'SHEET_COL', 'main/' || C.COL
  FROM EXPECTED_COL C
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS X
                    WHERE X.PROGRAM_ID = 'DMF0043' AND X.SHEET_NAME = 'main' AND X.COLUMN_NAME = C.COL);

PROMPT === BLOCK 1 : SCM_ADM_MNU_BTN_MPG_M — VERSION_MGMT 보강 ===

-- 기여율 버전관리 custom button (FE customButtons code = 'VERSION_MGMT')
-- API_ID = 'P_DMF0043_VERSION_POPUP' (기존 등록된 popup 조회 SP 재사용)
INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
  (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0043', 'main', 'VERSION_MGMT', 'P_DMF0043_VERSION_POPUP', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X
    WHERE X.MNU_ID = 'DMF0043' AND X.SHT_NM = 'main' AND X.MNU_BTN_CD = 'VERSION_MGMT'
 );

PROMPT === BLOCK 2 : SCM_ADM_USER_GR_MNU_BTN_MPG_M — VERSION_MGMT 자매 그룹 동적 복사 ===

-- DMF0043 의 SEARCH 권한을 가진 모든 USER_GR_ID 에 VERSION_MGMT 동시 부여
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT u.USER_GR_ID, 'DMF0043', 'main', 'VERSION_MGMT', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M u
 WHERE u.MNU_ID = 'DMF0043' AND u.SHT_NM = 'main' AND u.MNU_BTN_CD = 'SEARCH' AND u.USE_YN = 'Y'
   AND NOT EXISTS (
     SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M e
      WHERE e.USER_GR_ID = u.USER_GR_ID AND e.MNU_ID = 'DMF0043'
        AND e.SHT_NM = 'main' AND e.MNU_BTN_CD = 'VERSION_MGMT'
   );

PROMPT === BLOCK 3 : SCM_MST_SHEET_COLUMNS — BASE 6 컬럼 INSERT ===

-- FE ContributeMainGrid.tsx 의 BASE_COLUMNS (L22-29) 1:1 매핑:
--   DEPARTMENT_NAME   부문        180
--   DEPT_NAME         팀          200
--   END_CUST_REPORT   고객군      120
--   SOLDTO_CUST_REPORT 판매처     140
--   PRODUCT_GROUP     제품군      100
--   DM_BIZ_TYPE       형태         80
-- 모든 BASE 컬럼은 isReadOnly (FE) → INPUT_TP_CD='S' (Static/조회만).
-- 5 flag (FIXED_FLAG/UPPERCASE_APPLY_FLAG/USER_SELECTABLE_FLAG/DEFAULT_FLAG/VISIBLE_FLAG)
-- 표준 default (DMF0008 110 file 기준):
--   FIXED_FLAG='N', UPPERCASE_APPLY_FLAG='N', USER_SELECTABLE_FLAG='Y', DEFAULT_FLAG='Y', VISIBLE_FLAG='Y'

INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS (
  PROGRAM_ID, SHEET_NAME, COLUMN_NAME,
  COLUMN_LABEL_NAME, SORT_ORDER_NO, COLUMN_WIDTH,
  VISIBLE_FLAG, FIXED_FLAG, UPPERCASE_APPLY_FLAG, USER_SELECTABLE_FLAG, DEFAULT_FLAG,
  INPUT_TP_CD, HORIZONTAL_ALIGN_CODE,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
)
SELECT 'DMF0043', 'main', NEW.COL,
       NEW.LBL, NEW.SORT_ORD, NEW.WIDTH,
       'Y', 'N', 'N', 'Y', 'Y',
       'S', 'L',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'DEPARTMENT_NAME'    AS COL, '부문'     AS LBL, 1 AS SORT_ORD, 180 AS WIDTH FROM DUAL UNION ALL
    SELECT 'DEPT_NAME',                 '팀',                2,              200          FROM DUAL UNION ALL
    SELECT 'END_CUST_REPORT',           '고객군',            3,              120          FROM DUAL UNION ALL
    SELECT 'SOLDTO_CUST_REPORT',        '판매처',            4,              140          FROM DUAL UNION ALL
    SELECT 'PRODUCT_GROUP',             '제품군',            5,              100          FROM DUAL UNION ALL
    SELECT 'DM_BIZ_TYPE',               '형태',              6,               80          FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS X
    WHERE X.PROGRAM_ID = 'DMF0043' AND X.SHEET_NAME = 'main' AND X.COLUMN_NAME = NEW.COL
 );

COMMIT;

PROMPT === POST-AUDIT 1 : 적용 후 BTN_MPG_M ===
SELECT MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0043'
 ORDER BY SHT_NM, MNU_BTN_CD;

PROMPT === POST-AUDIT 2 : 적용 후 SHEET_COLUMNS (main) ===
SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, SORT_ORDER_NO, COLUMN_LABEL_NAME, COLUMN_WIDTH, VISIBLE_FLAG
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0043' AND SHEET_NAME = 'main'
 ORDER BY SORT_ORDER_NO;

PROMPT === POST-AUDIT 3 : USER_GR VERSION_MGMT 부여 사용자 그룹 수 ===
SELECT USER_GR_ID, COUNT(*) AS BTN_CNT
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0043' AND USE_YN = 'Y'
 GROUP BY USER_GR_ID
 ORDER BY USER_GR_ID;

PROMPT === 060_DMF0043_dynamic_property_management.sql 완료 ===

--==============================================================================
-- 적용 후 FE 검증:
--   1) GET /admin/menu/DMF0043/auth → mnuBtnAuth 에 'SEARCH', 'SAVE', 'VERSION_MGMT' 포함
--   2) POST /admin/menu/DMF0043/column → BASE 6 row + visible/width
--   3) admin SYS0009 에서 DMF0043/main/VERSION_MGMT USE_YN='N' → 화면 재진입 시 button 숨김
--   4) admin SYS0004 에서 DEPT_NAME VISIBLE_FLAG='N' → 컬럼 숨김 (전체 컬럼 수 6→5)
--   5) PIVOT 동적 컬럼 (Y#/M#) 은 SP 응답 기반 — 영향 없음
--==============================================================================
