/*=============================================================================================
 * File         : 013_DMF0003_Sheet_Columns_LookupMeta.sql
 * Description  : DMF0003 — UI 동적 속성관리 hook §4 (Column) lookup 메타 보강
 *              :   - 010 BLOCK 3 에 SCM_MST_SHEET_COLUMNS 43건 등록 완료
 *              :   - lookup (combo dropdown) 컬럼 7종의 CELL_COMBO_DATA_TYPE 갱신
 *              :     → wrapper DataGrid 가 자동 fetch 하여 dropdown 표시
 *              :
 *              : ⚠ 메모리 feedback_column_lookup_meta_standard.md (2026-06-12) 핵심:
 *              :   - lookup SQL_ID 는 CELL_COMBO_DATA_TYPE 위치에 등록 의무
 *              :   - ATTRIBUTE1 위치 절대 금지 (DataGrid wrapper 인식 불가)
 *              :
 *              : 갱신 컬럼 인벤토리 (FE MAIN_COLUMNS 의 _comboKey 와 정확히 매칭):
 *              :   END_CUSTOMER   → 'EndCustomerByDivisionDept'
 *              :   SCM_SITE_ID    → 'SiteByEndCustomer'
 *              :   INCOTERMS      → 'Incoterms'
 *              :   FCST_TYPE      → 'FcstType'
 *              :   DOM_EXP        → 'CustomsHandbook'
 *              :   PLANT_SITE_ID  → 'PlantSite'
 *              :   MEASURE        → 'Measure'
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-06-15
 * Plan         : C:\Users\ejene\.claude\plans\dmf0003-jazzy-ullman.md
 *
 * 관련 hook    : Doc/_rules_v2/hooks/ui-category-setup-column-meta.md (§4 + §11)
 *              : Doc/_rules_v2/hooks/column-lookup-meta-standard.md
 *
 * 사전 조건   : 010 BLOCK 3 실행 완료 (43 fixed col 등록)
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/

SET DEFINE ON
SET SERVEROUTPUT ON SIZE UNLIMITED

DEFINE V_MENU_ID = 'DMF0003'
DEFINE V_SHT_NM  = 'main'


-- =============================================================================================
-- BLOCK 1: SCM_ADM_CMBO_SQL_M 존재 확인 (lookup SQL_ID 인벤토리)
--   필요한 7 SQL_ID 가 모두 인벤토리에 있는지 확인 (없으면 WARN — 별도 INSERT 필요)
-- =============================================================================================

PROMPT
PROMPT === 1. SCM_ADM_CMBO_SQL_M 인벤토리 확인 ===
SELECT NEW.SQL_ID,
       NVL2( (SELECT 1 FROM SCM_ADM_CMBO_SQL_M m WHERE m.SQL_ID = NEW.SQL_ID), 'OK', 'MISSING' ) AS STATUS
  FROM (
    SELECT 'EndCustomerByDivisionDept' SQL_ID FROM DUAL UNION ALL
    SELECT 'SiteByEndCustomer'                 FROM DUAL UNION ALL
    SELECT 'Incoterms'                         FROM DUAL UNION ALL
    SELECT 'FcstType'                          FROM DUAL UNION ALL
    SELECT 'CustomsHandbook'                   FROM DUAL UNION ALL
    SELECT 'PlantSite'                         FROM DUAL UNION ALL
    SELECT 'Measure'                           FROM DUAL
  ) NEW
 ORDER BY 1;


-- =============================================================================================
-- BLOCK 2: SCM_MST_SHEET_COLUMNS UPDATE — lookup 7 컬럼의 CELL_COMBO_DATA_TYPE 갱신
--   (ATTRIBUTE1 자리는 metadata SQL 의 modal popup 키 — touch X)
-- =============================================================================================

UPDATE SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox',
       CELL_COMBO_DATA_TYPE          = 'EndCustomerByDivisionDept',
       LAST_UPDATED_BY               = 'admin',
       LAST_UPDATE_DATE              = SYSDATE
 WHERE PROGRAM_ID = '&V_MENU_ID' AND SHEET_NAME = '&V_SHT_NM' AND COLUMN_NAME = 'END_CUSTOMER';

UPDATE SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox',
       CELL_COMBO_DATA_TYPE          = 'SiteByEndCustomer',
       LAST_UPDATED_BY               = 'admin',
       LAST_UPDATE_DATE              = SYSDATE
 WHERE PROGRAM_ID = '&V_MENU_ID' AND SHEET_NAME = '&V_SHT_NM' AND COLUMN_NAME = 'SCM_SITE_ID';

UPDATE SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox',
       CELL_COMBO_DATA_TYPE          = 'Incoterms',
       LAST_UPDATED_BY               = 'admin',
       LAST_UPDATE_DATE              = SYSDATE
 WHERE PROGRAM_ID = '&V_MENU_ID' AND SHEET_NAME = '&V_SHT_NM' AND COLUMN_NAME = 'INCOTERMS';

UPDATE SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox',
       CELL_COMBO_DATA_TYPE          = 'FcstType',
       LAST_UPDATED_BY               = 'admin',
       LAST_UPDATE_DATE              = SYSDATE
 WHERE PROGRAM_ID = '&V_MENU_ID' AND SHEET_NAME = '&V_SHT_NM' AND COLUMN_NAME = 'FCST_TYPE';

UPDATE SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox',
       CELL_COMBO_DATA_TYPE          = 'CustomsHandbook',
       LAST_UPDATED_BY               = 'admin',
       LAST_UPDATE_DATE              = SYSDATE
 WHERE PROGRAM_ID = '&V_MENU_ID' AND SHEET_NAME = '&V_SHT_NM' AND COLUMN_NAME = 'DOM_EXP';

UPDATE SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox',
       CELL_COMBO_DATA_TYPE          = 'PlantSite',
       LAST_UPDATED_BY               = 'admin',
       LAST_UPDATE_DATE              = SYSDATE
 WHERE PROGRAM_ID = '&V_MENU_ID' AND SHEET_NAME = '&V_SHT_NM' AND COLUMN_NAME = 'PLANT_SITE_ID';

UPDATE SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox',
       CELL_COMBO_DATA_TYPE          = 'Measure',
       LAST_UPDATED_BY               = 'admin',
       LAST_UPDATE_DATE              = SYSDATE
 WHERE PROGRAM_ID = '&V_MENU_ID' AND SHEET_NAME = '&V_SHT_NM' AND COLUMN_NAME = 'MEASURE';


COMMIT;


-- =============================================================================================
-- BLOCK 3: 검증 SELECT
-- =============================================================================================

PROMPT
PROMPT ============================================================
PROMPT DMF0003 lookup 메타 갱신 결과
PROMPT ============================================================

SELECT COLUMN_NAME, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = '&V_MENU_ID' AND SHEET_NAME = '&V_SHT_NM'
   AND CELL_COMBO_DATA_TYPE IS NOT NULL
 ORDER BY COLUMN_NAME;

PROMPT
PROMPT === lookup column 카운트 (7 예상) ===
SELECT COUNT(*) AS LOOKUP_CNT
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = '&V_MENU_ID' AND SHEET_NAME = '&V_SHT_NM'
   AND CELL_COMBO_DATA_TYPE IS NOT NULL;
