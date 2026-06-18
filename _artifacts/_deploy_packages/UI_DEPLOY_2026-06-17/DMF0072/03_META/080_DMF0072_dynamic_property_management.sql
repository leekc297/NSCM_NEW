--==============================================================================
-- 080_DMF0072_dynamic_property_management.sql
--
-- DMF0072 (NN Master Mapping) — UI 동적 속성관리 (Menu Button + SHEET_COLUMNS 23) 보강
-- =============================================================================
-- 작성: 2026-06-17 (4 화면 재작업 — DMF0072 Step 4)
-- 적용 hook:
--   _rules_v2/hooks/ui-dynamic-property-management.md §3 §4 §6 §7
--   _rules_v2/hooks/column-meta-rework-checklist.md §2.4 §2.5
--   _rules_v2/hooks/ui-category-setup-column-meta.md
--
-- 변경 FE :
--   - NnMasterMapping.tsx — useTabBtnPermissions + hasButton + monolithic 분리 (577 → ~300줄)
--   - useNnMasterMappingStore.ts — staticColumns + fetchStaticColumns action
--   - components/NnMasterMappingGrid.tsx (신규) — FlexGrid + HierarchicalMergeManager + visibleColumns
--   - components/NnMasterMappingModals.tsx (신규) — Customer/Project/Item modal 통합
--
-- BLOCK 구성:
--   AUDIT   : 현 DMF0072 메타 (BTN_MPG_M + SHEET_COLUMNS) 인벤토리
--   BLOCK 1 : SCM_ADM_MNU_BTN_MPG_M — main/SEARCH/INSERT/SAVE/DELETE 보강
--   BLOCK 2 : SCM_ADM_USER_GR_MNU_BTN_MPG_M — 자매 그룹 동적 복사
--   BLOCK 3 : SCM_MST_SHEET_COLUMNS — MAIN_COLUMNS 23개 INSERT (kebab-case 회피)
--
-- 멱등성: 모든 INSERT 가 NOT EXISTS 패턴 — 재실행 영향 없음.
--==============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === AUDIT 1 : 현 DMF0072 BTN_MPG_M 인벤토리 ===

SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0072'
 ORDER BY SHT_NM, MNU_BTN_CD;

PROMPT === AUDIT 2 : 현 DMF0072 SHEET_COLUMNS (main) 인벤토리 ===

SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, SORT_ORDER_NO, VISIBLE_FLAG, COLUMN_WIDTH
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0072' AND SHEET_NAME = 'main'
 ORDER BY SORT_ORDER_NO;

PROMPT === BLOCK 1 : SCM_ADM_MNU_BTN_MPG_M — 표준 4 button 보강 ===

-- FE hotkeyConfig 의 4 button (SEARCH/INSERT/SAVE/DELETE) NOT EXISTS INSERT
INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
  (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0072', 'main', NEW.MNU_BTN_CD, NEW.API_ID, 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'SEARCH' AS MNU_BTN_CD, 'P_DMF0072_NN_MAPPING_GET'  AS API_ID FROM DUAL UNION ALL
    SELECT 'INSERT',                NULL                                  FROM DUAL UNION ALL
    SELECT 'SAVE',                  'P_DMF0072_NN_MAPPING_SAVE'           FROM DUAL UNION ALL
    SELECT 'DELETE',                NULL                                  FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X
    WHERE X.MNU_ID = 'DMF0072' AND X.SHT_NM = 'main' AND X.MNU_BTN_CD = NEW.MNU_BTN_CD
 );

PROMPT === BLOCK 2 : SCM_ADM_USER_GR_MNU_BTN_MPG_M — 4 button 자매 그룹 동적 복사 ===

INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT u.USER_GR_ID, 'DMF0072', 'main', T.MNU_BTN_CD, 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M u
 CROSS JOIN (
    SELECT 'SEARCH' MNU_BTN_CD FROM DUAL UNION ALL
    SELECT 'INSERT'             FROM DUAL UNION ALL
    SELECT 'SAVE'               FROM DUAL UNION ALL
    SELECT 'DELETE'             FROM DUAL
 ) T
 WHERE u.MNU_ID IN ('DMF0004', 'DMF0005') AND u.SHT_NM IN ('main', 'production')
   AND u.MNU_BTN_CD = 'SEARCH' AND u.USE_YN = 'Y'
   AND NOT EXISTS (
     SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M e
      WHERE e.USER_GR_ID = u.USER_GR_ID AND e.MNU_ID = 'DMF0072'
        AND e.SHT_NM = 'main' AND e.MNU_BTN_CD = T.MNU_BTN_CD
   );

PROMPT === BLOCK 3 : SCM_MST_SHEET_COLUMNS — MAIN_COLUMNS 23개 INSERT ===

-- FE nn-master-mapping.constants.ts L75-245 의 MAIN_COLUMNS 23개 1:1 매핑.
-- 모든 binding 은 snake_case (kebab-case 사고 방지 — DMF0072 사례).
-- INPUT_TP_CD 매핑:
--   S → 'S' (Static read-only)
--   M → 'M' (Mandatory)
--   O → 'O' (Optional)
--   IM → 'IM' (Insert Mandatory)
--   IO → 'IO' (Insert Optional)
-- CELL_CONTROL_OBJECT_TYPE_CODE: FE _ctrlType (FPText/FPModal/FPComboBox/FPCheckBox/FPDate/FPDateTime).
-- 5 flag default: FIXED_FLAG='N', UPPERCASE_APPLY_FLAG='N', USER_SELECTABLE_FLAG='Y', DEFAULT_FLAG='Y', VISIBLE_FLAG='Y'

INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS (
  PROGRAM_ID, SHEET_NAME, COLUMN_NAME,
  COLUMN_LABEL_NAME, SORT_ORDER_NO, COLUMN_WIDTH,
  VISIBLE_FLAG, FIXED_FLAG, UPPERCASE_APPLY_FLAG, USER_SELECTABLE_FLAG, DEFAULT_FLAG,
  INPUT_TP_CD, CELL_CONTROL_OBJECT_TYPE_CODE, HORIZONTAL_ALIGN_CODE,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
)
SELECT 'DMF0072', 'main', NEW.COL,
       NEW.LBL, NEW.SORT_ORD, NEW.WIDTH,
       'Y', 'N', 'N', 'Y', 'Y',
       NEW.INPUT_TP, NEW.CTRL_TP, 'L',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'DATA_TYPE_CODE'           AS COL, 'Data Type'         AS LBL,  1 AS SORT_ORD, 100 AS WIDTH, 'S'  AS INPUT_TP, 'FPText'    AS CTRL_TP FROM DUAL UNION ALL
    SELECT 'DIVISION_ID',                       'Division',                 2,             80,              'S',            'FPText'              FROM DUAL UNION ALL
    SELECT 'COMPANY_ID',                        'Company',                  3,             90,              'IM',           'FPComboBox'          FROM DUAL UNION ALL
    SELECT 'END_CUSTOMER',                      'End Customer',             4,             130,             'IM',           'FPComboBox'          FROM DUAL UNION ALL
    SELECT 'UNLOADING_POINT',                   'Unloading Point',          5,             130,             'IO',           'FPText'              FROM DUAL UNION ALL
    SELECT 'CUSTOMER_PLANT',                    'Customer Plant',           6,             130,             'IO',           'FPText'              FROM DUAL UNION ALL
    SELECT 'SOLDTO_CODE',                       'SoldTo',                   7,             110,             'IM',           'FPModal'             FROM DUAL UNION ALL
    SELECT 'SHIPTO_CODE',                       'ShipTo',                   8,             110,             'IM',           'FPModal'             FROM DUAL UNION ALL
    SELECT 'SCM_SITE_ID',                       'SCM Site',                 9,             160,             'IM',           'FPComboBox'          FROM DUAL UNION ALL
    SELECT 'PROJECT_CODE',                      'Project',                 10,             110,             'IM',           'FPModal'             FROM DUAL UNION ALL
    SELECT 'FCST_TYPE',                         'FCST Type',               11,              90,             'IM',           'FPComboBox'          FROM DUAL UNION ALL
    SELECT 'INCOTERMS',                         'Incoterms',               12,              90,             'IM',           'FPComboBox'          FROM DUAL UNION ALL
    SELECT 'DOM_EXP',                           'Dom/Exp',                 13,              80,             'IM',           'FPComboBox'          FROM DUAL UNION ALL
    SELECT 'CUSTOMER_ITEM_ID',                  'Customer Item',           14,             140,             'IO',           'FPText'              FROM DUAL UNION ALL
    SELECT 'ITEM_ID',                           'MDM Code',                15,             140,             'IM',           'FPModal'             FROM DUAL UNION ALL
    SELECT 'MAPPING_ITEM_ID',                   'Mapping Item',            16,             140,             'M',            'FPModal'             FROM DUAL UNION ALL
    SELECT 'MAPPING_ITEM_ID_ORIGINAL',          'Mapping Item (Org)',      17,             160,             'S',            'FPText'              FROM DUAL UNION ALL
    SELECT 'VALID_START_DATE',                  'Valid Start',             18,             110,             'M',            'FPDate'              FROM DUAL UNION ALL
    SELECT 'VALID_END_DATE',                    'Valid End',               19,             110,             'M',            'FPDate'              FROM DUAL UNION ALL
    SELECT 'ACTIVE_YN',                         'Active',                  20,              70,             'M',            'FPCheckBox'          FROM DUAL UNION ALL
    SELECT 'LAST_UPDATE_DATE',                  'Last Update',             21,             140,             'S',            'FPDateTime'          FROM DUAL UNION ALL
    SELECT 'LAST_UPDATED_BY',                   'Updated By',              22,             110,             'S',            'FPText'              FROM DUAL UNION ALL
    SELECT 'DC_LEVEL',                          'DC Level',                23,              90,             'M',            'FPText'              FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS X
    WHERE X.PROGRAM_ID = 'DMF0072' AND X.SHEET_NAME = 'main' AND X.COLUMN_NAME = NEW.COL
 );

COMMIT;

PROMPT === POST-AUDIT 1 : 적용 후 BTN_MPG_M ===
SELECT MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0072'
 ORDER BY SHT_NM, MNU_BTN_CD;

PROMPT === POST-AUDIT 2 : 적용 후 SHEET_COLUMNS (23 row 기대) ===
SELECT COUNT(*) AS COL_CNT
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0072' AND SHEET_NAME = 'main';

SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, SORT_ORDER_NO, COLUMN_LABEL_NAME, COLUMN_WIDTH, INPUT_TP_CD
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0072' AND SHEET_NAME = 'main'
 ORDER BY SORT_ORDER_NO;

PROMPT === 080_DMF0072_dynamic_property_management.sql 완료 ===

--==============================================================================
-- 적용 후 FE 검증:
--   1) GET /admin/menu/DMF0072/auth → mnuBtnAuth 에 'SEARCH', 'INSERT', 'SAVE', 'DELETE' 포함
--   2) POST /admin/menu/DMF0072/column → 23 row 정상 반환
--   3) admin SYS0009 에서 DMF0072/main/INSERT USE_YN='N' → 화면 재진입 시 Insert 버튼 비활성
--   4) admin SYS0004 에서 LAST_UPDATED_BY VISIBLE_FLAG='N' → 컬럼 숨김 (23 → 22)
--==============================================================================
