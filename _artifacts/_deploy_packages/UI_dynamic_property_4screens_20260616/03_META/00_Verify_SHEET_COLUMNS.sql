-- ====================================================================
-- DMF0008 / DMF0043 / DMF0043_01 / DMF0072 — UI 동적 속성관리 적용 사전 검증
-- ====================================================================
-- 작성: 2026-06-16
-- 목적: 4 화면의 FE 변경 (staticColumns 동적 fetch) 적용 전, 사내 Oracle 의
--       SCM_MST_SHEET_COLUMNS 에 컬럼 메타가 등록되어 있는지 검증.
--       누락 시 화면 진입 시 staticColumns 빈 배열 → fallback (BASE_COLUMNS 상수) 적용 →
--       admin SYS0004 UI Category Setup 변경 무효화 (운영 결정 무효).
-- ====================================================================

-- ===== 1) 4 화면 별 SHEET_COLUMNS 등록 row 수 =====
-- 기대 결과:
--   DMF0008 / summary, repair, salesSite, sspm: 각 sheet 의 컬럼 수 (>0)
--   DMF0043 / main: 6 (BASE) 또는 그 이상
--   DMF0043 / ContributeSalesList (또는 별도 PROGRAM_ID 'DMF0043_01' / main): 9 BASE
--   DMF0072 / main: 23
SELECT PROGRAM_ID, SHEET_NAME, COUNT(*) AS COL_COUNT
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID IN ('DMF0008', 'DMF0043', 'DMF0043_01', 'DMF0072')
 GROUP BY PROGRAM_ID, SHEET_NAME
 ORDER BY PROGRAM_ID, SHEET_NAME;

-- ===== 2) DMF0072 (NN Master Mapping) — 23 컬럼 등록 상세 검증 =====
--   FE 의 MAIN_COLUMNS (nn-master-mapping.constants.ts) 와 1:1 cross-check.
--   누락 컬럼 발견 시 별도 INSERT SQL 필요.
SELECT COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH, INPUT_TP_CD,
       CELL_CONTROL_OBJECT_TYPE_CODE, ATTRIBUTE1, SORT_ORDER_NO, VISIBLE_FLAG
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0072'
   AND SHEET_NAME = 'main'
 ORDER BY SORT_ORDER_NO, COLUMN_NAME;

-- ===== 3) DMF0043 (Contribute Main) — BASE 6 컬럼 등록 검증 =====
--   FE 의 BASE_COLUMNS (ContributeMainGrid.tsx:22) 와 1:1 cross-check.
--   기대: DEPARTMENT_NAME / DEPT_NAME / END_CUST_REPORT / SOLDTO_CUST_REPORT / PRODUCT_GROUP / DM_BIZ_TYPE
SELECT COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH, VISIBLE_FLAG
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0043'
   AND SHEET_NAME = 'main'
 ORDER BY SORT_ORDER_NO, COLUMN_NAME;

-- ===== 4) DMF0043_01 (Contribute View) — BASE 9 컬럼 등록 검증 =====
--   FE 의 buildColumnMeta 의 BASE 컬럼 (BASE_COLUMN_COUNT=9) 와 cross-check.
--   PROGRAM_ID = 'DMF0043_01' 또는 'DMF0043' (sheet_name = 'ContributeSalesList' 등) 확인 필요.
SELECT COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH, VISIBLE_FLAG
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID IN ('DMF0043_01', 'DMF0043')
   AND SHEET_NAME IN ('main', 'ContributeSalesList')
 ORDER BY PROGRAM_ID, SHEET_NAME, SORT_ORDER_NO, COLUMN_NAME;

-- ===== 5) DMF0008 (ERP/EDI Master) — 4 sheet 의 컬럼 등록 검증 =====
--   FE 4 sheet: summary / repair / salesSite / sspm — 각 sheet 의 컬럼 수 ≥ 1 필수.
SELECT PROGRAM_ID, SHEET_NAME, COUNT(*) AS COL_COUNT
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0008'
 GROUP BY PROGRAM_ID, SHEET_NAME
 ORDER BY SHEET_NAME;

-- ====================================================================
-- 누락 발견 시 조치:
--   1) admin SYS0004 UI Category Setup 화면에서 화면 선택 → 컬럼 추가
--   2) 또는 deploy SQL 작성 (NOT EXISTS 멱등 INSERT — 메모리 feedback_sql_idempotent_insert_all 참조)
--
-- FE 변경 검증:
--   각 화면 진입 시 Browser DevTools Network → /admin/menu/{MENU_ID}/column 응답 확인
--   응답이 [] (빈 배열) 이면 SHEET_COLUMNS 미등록 → 위 SQL 로 등록 의무
-- ====================================================================
