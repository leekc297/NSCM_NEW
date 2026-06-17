/*=============================================================================================
 * File         : 015_Audit_DMF0003_Dynamic_Property.sql
 * Description  : DMF0003 — "UI 생성의 동적 속성관리" 보강 통합 audit
 *              :   - 011 ~ 014 적용 후 5 카테고리 통합 점검 (1 SQL 1 결과)
 *              :   - PASS 기준 (모두 만족 시 표준 적용 완료):
 *              :     1) Menu Button     : MNU_BTN_MPG_M 10 행, USE_YN='Y'
 *              :     2) Button 권한     : USER_GR_MNU_BTN_MPG_M 그룹 × button 매트릭스
 *              :     3) Column 메타     : SHEET_COLUMNS 43 행 + lookup 7 행 (CELL_COMBO_DATA_TYPE)
 *              :     4) Measure 메타    : SHEET_MEASURE 12 행, VALID_YN='Y'
 *              :     5) BE 동적 fetch 호환: 각 endpoint (auth/column/measure) 의 결과 행 수
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-06-15
 * Plan         : C:\Users\ejene\.claude\plans\dmf0003-jazzy-ullman.md
 *
 * 사전 조건   : 010~014 모두 실행 완료
 * 실행 계정   : SCM_MGR 또는 SCMD_APP (SELECT only)
 *===========================================================================================*/

SET DEFINE ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200
SET PAGESIZE 100

DEFINE V_MENU_ID = 'DMF0003'
DEFINE V_SHT_NM  = 'main'


-- =============================================================================================
-- 카테고리 1: Menu Button (UI 동적 속성관리 §3)
-- =============================================================================================

PROMPT
PROMPT ============================================================
PROMPT [1] Menu Button — SCM_ADM_MNU_BTN_MPG_M
PROMPT ============================================================

SELECT MNU_BTN_CD, API_ID, USE_YN
  FROM SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = '&V_MENU_ID' AND SHT_NM = '&V_SHT_NM'
 ORDER BY MNU_BTN_CD;

PROMPT
PROMPT === [1.A] 카운트 (10 예상 — SEARCH/INSERT/SAVE/DELETE/EXCEL/SORT/FILTER + custom 3) ===
SELECT COUNT(*) AS BTN_CNT,
       SUM(CASE WHEN USE_YN='Y' THEN 1 ELSE 0 END) AS USE_Y_CNT
  FROM SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = '&V_MENU_ID' AND SHT_NM = '&V_SHT_NM';


-- =============================================================================================
-- 카테고리 2: Button 사용자 그룹 권한
-- =============================================================================================

PROMPT
PROMPT ============================================================
PROMPT [2] Button 권한 — SCM_ADM_USER_GR_MNU_BTN_MPG_M
PROMPT ============================================================

SELECT USER_GR_ID, COUNT(*) AS BTN_CNT
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = '&V_MENU_ID' AND SHT_NM = '&V_SHT_NM' AND USE_YN = 'Y'
 GROUP BY USER_GR_ID
 ORDER BY USER_GR_ID;

PROMPT
PROMPT === [2.A] minyonglee1 사용자 권한 view (10 button 예상) ===
SELECT v.MNU_BTN_CD, v.USE_YN
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M v
  JOIN SCM_ADM_USER_M u    ON u.USER_GR_ID = v.USER_GR_ID
 WHERE u.USER_ID = 'minyonglee1' AND v.MNU_ID = '&V_MENU_ID' AND v.SHT_NM = '&V_SHT_NM' AND v.USE_YN = 'Y'
 ORDER BY v.MNU_BTN_CD;


-- =============================================================================================
-- 카테고리 3: Column 메타 (UI 동적 속성관리 §4)
-- =============================================================================================

PROMPT
PROMPT ============================================================
PROMPT [3] Column 메타 — SCM_MST_SHEET_COLUMNS
PROMPT ============================================================

SELECT COUNT(*)                                                       AS TOTAL_COL_CNT,
       SUM(CASE WHEN VISIBLE_FLAG='Y' THEN 1 ELSE 0 END)              AS VISIBLE_CNT,
       SUM(CASE WHEN CELL_COMBO_DATA_TYPE IS NOT NULL THEN 1 ELSE 0 END) AS LOOKUP_CNT
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = '&V_MENU_ID' AND SHEET_NAME = '&V_SHT_NM';

PROMPT
PROMPT === [3.A] lookup 컬럼 매핑 (7 행 예상 — END_CUSTOMER/SCM_SITE_ID/INCOTERMS/FCST_TYPE/DOM_EXP/PLANT_SITE_ID/MEASURE) ===
SELECT COLUMN_NAME, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = '&V_MENU_ID' AND SHEET_NAME = '&V_SHT_NM'
   AND CELL_COMBO_DATA_TYPE IS NOT NULL
 ORDER BY COLUMN_NAME;

PROMPT
PROMPT === [3.B] CMBO_SQL_M 인벤토리 누락 확인 (모두 OK 예상) ===
SELECT cm.CELL_COMBO_DATA_TYPE AS SQL_ID,
       NVL2(s.SQL_ID, 'OK', 'MISSING') AS STATUS
  FROM (SELECT DISTINCT CELL_COMBO_DATA_TYPE FROM SCM_MST_SHEET_COLUMNS
         WHERE PROGRAM_ID = '&V_MENU_ID' AND SHEET_NAME = '&V_SHT_NM' AND CELL_COMBO_DATA_TYPE IS NOT NULL) cm
  LEFT JOIN SCM_ADM_CMBO_SQL_M s ON s.SQL_ID = cm.CELL_COMBO_DATA_TYPE
 ORDER BY 2 DESC, 1;


-- =============================================================================================
-- 카테고리 4: Measure 메타 (UI 동적 속성관리 §5)
-- =============================================================================================

PROMPT
PROMPT ============================================================
PROMPT [4] Measure 메타 — SCM_MST_SHEET_MEASURE
PROMPT ============================================================

SELECT COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, VALID_YN
  FROM SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID = '&V_MENU_ID' AND SHEET_NAME = '&V_SHT_NM'
 ORDER BY SORT_ORDER_NO;

PROMPT
PROMPT === [4.A] 카운트 (12 예상, VALID_YN='Y' 만) ===
SELECT COUNT(*) AS MEASURE_CNT
  FROM SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID = '&V_MENU_ID' AND SHEET_NAME = '&V_SHT_NM' AND VALID_YN = 'Y';


-- =============================================================================================
-- 카테고리 5: 종합 PASS 판정 (한 줄 결과)
-- =============================================================================================

PROMPT
PROMPT ============================================================
PROMPT [5] 종합 PASS 판정 — 5 카테고리 통합
PROMPT ============================================================

WITH cnt AS (
  SELECT
    (SELECT COUNT(*) FROM SCM_ADM_MNU_BTN_MPG_M             WHERE MNU_ID = '&V_MENU_ID' AND SHT_NM = '&V_SHT_NM' AND USE_YN = 'Y') AS btn_cnt,
    (SELECT COUNT(DISTINCT USER_GR_ID) FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
                                                            WHERE MNU_ID = '&V_MENU_ID' AND SHT_NM = '&V_SHT_NM' AND USE_YN = 'Y') AS auth_grp_cnt,
    (SELECT COUNT(*) FROM SCM_MST_SHEET_COLUMNS             WHERE PROGRAM_ID = '&V_MENU_ID' AND SHEET_NAME = '&V_SHT_NM')           AS col_cnt,
    (SELECT COUNT(*) FROM SCM_MST_SHEET_COLUMNS             WHERE PROGRAM_ID = '&V_MENU_ID' AND SHEET_NAME = '&V_SHT_NM'
                                                              AND CELL_COMBO_DATA_TYPE IS NOT NULL)                                  AS lookup_cnt,
    (SELECT COUNT(*) FROM SCM_MST_SHEET_MEASURE             WHERE PROGRAM_ID = '&V_MENU_ID' AND SHEET_NAME = '&V_SHT_NM'
                                                              AND VALID_YN = 'Y')                                                    AS measure_cnt
  FROM DUAL
)
SELECT 'BTN_MPG (>= 10)'  AS K, TO_CHAR(btn_cnt)        AS VAL, CASE WHEN btn_cnt      >= 10 THEN 'PASS' ELSE 'FAIL' END AS STATUS FROM cnt UNION ALL
SELECT 'AUTH_GRP (>= 1)',         TO_CHAR(auth_grp_cnt),         CASE WHEN auth_grp_cnt >=  1 THEN 'PASS' ELSE 'FAIL' END           FROM cnt UNION ALL
SELECT 'SHEET_COL (= 43)',        TO_CHAR(col_cnt),              CASE WHEN col_cnt      =  43 THEN 'PASS' ELSE 'FAIL' END           FROM cnt UNION ALL
SELECT 'LOOKUP (>= 7)',           TO_CHAR(lookup_cnt),           CASE WHEN lookup_cnt   >=  7 THEN 'PASS' ELSE 'FAIL' END           FROM cnt UNION ALL
SELECT 'MEASURE (>= 12)',         TO_CHAR(measure_cnt),          CASE WHEN measure_cnt  >= 12 THEN 'PASS' ELSE 'FAIL' END           FROM cnt;
