--------------------------------------------------------------------------------
-- 39_dmf0003_sheet_columns_cleanup.sql
-- DMF0003 (mkt-fcst) — UI Category Setup 메타 정합 handoff (멱등)
--
-- 작성    : 2026-06-28  (Phase 3 메타 정합 진단 산출)
-- 대상 DB : 사내 Oracle  SCM_MGR @ 121.162.245.167:2521/OCGSCMD_P01
-- 룰      : corp-meta-integrity-and-wiring(#98) / ui-category-setup-column-meta /
--           ui-category-setup-no-arbitrary-data(#78, AI 임의 INSERT 절대 금지) /
--           column-align-code-standard(#96, C/L/R) / sheet-name(#91)
--
-- ⚠️ 적용 보류. 사용자(검토자) 가 직접 적용. 본 스크립트는 진단 근거 + 백업 + 보류 처리만 포함.
-- ⚠️ AI 가 임의로 INSERT/추측한 데이터 0건. 모든 행은 사내 DB 실측(READ) 근거.
--------------------------------------------------------------------------------
-- 진단 요약 (2026-06-28 READ 실측)
--   SCM_MST_SHEET_COLUMNS  WHERE PROGRAM_ID='DMF0003'  →  4 sheet / 96 row
--     main(67) / psi(17) / carFcst(2) / "Customer Demand Analysis"(10)
--   SCM_MST_SHEET_MEASURE  WHERE PROGRAM_ID='DMF0003'  →  2 sheet / 59 row
--     "Mkt Fcst"(47, AS-IS 권위) / main(12, 중복 stub)
--
--   ⭐ align(#96)  : HORIZONTAL_ALIGN_CODE 분포 C=25 / L=54 / R=17 → 전부 단일문자. 위반 0. (교정 불필요)
--   ⭐ NOT NULL    : SHEET_COLUMNS NOT NULL 컬럼(12종) NULL row 0건. (보정 불필요)
--   ⭐ INPUT_TP_CD : S=81 / IM=15 (정상값. MI typo 0)
--
--   ⛔ 결론: 사내 SHEET_COLUMNS 데이터 자체는 정합(삭제/UPDATE 강제 대상 없음).
--      ‼️ 진짜 정합 결손 = FE 측 sheet 명칭 mismatch (corp write 가 아니라 FE 코드 수정). §4 참조.
--------------------------------------------------------------------------------

WHENEVER SQLERROR CONTINUE;
SET DEFINE OFF;

--------------------------------------------------------------------------------
-- [STEP 0] CTAS 백업 (멱등 — 이미 있으면 skip)  ⭐ 모든 변경 선행 의무 (룰 30/#98 §4)
--------------------------------------------------------------------------------
BEGIN
  EXECUTE IMMEDIATE
    'CREATE TABLE SCM_MST_SHEET_COLUMNS_BAK_DMF0003 AS
       SELECT * FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = ''DMF0003''';
  DBMS_OUTPUT.PUT_LINE('BACKUP: SCM_MST_SHEET_COLUMNS_BAK_DMF0003 created');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -955 THEN DBMS_OUTPUT.PUT_LINE('BACKUP exists (skip): SCM_MST_SHEET_COLUMNS_BAK_DMF0003');
  ELSE RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE
    'CREATE TABLE SCM_MST_SHEET_MEASURE_BAK_DMF0003 AS
       SELECT * FROM SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID = ''DMF0003''';
  DBMS_OUTPUT.PUT_LINE('BACKUP: SCM_MST_SHEET_MEASURE_BAK_DMF0003 created');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -955 THEN DBMS_OUTPUT.PUT_LINE('BACKUP exists (skip): SCM_MST_SHEET_MEASURE_BAK_DMF0003');
  ELSE RAISE; END IF;
END;
/

--------------------------------------------------------------------------------
-- [STEP 1] 근거 SELECT — 삭제/변경 후보 행을 먼저 제시 (임의 추측 금지)
--------------------------------------------------------------------------------
PROMPT === 1-A. SHEET_COLUMNS sheet 별 행수 (FE 실사용 = main 만) ===
SELECT SHEET_NAME, COUNT(*) CNT
  FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0003'
 GROUP BY SHEET_NAME ORDER BY SHEET_NAME;

PROMPT === 1-B. main(67) 중 FE 가 직접 참조하는 15 binding 매핑 확인 (존재해야 정상) ===
SELECT COLUMN_NAME, VISIBLE_FLAG, HORIZONTAL_ALIGN_CODE, INPUT_TP_CD
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='main'
   AND COLUMN_NAME IN ('DIVISION_ID','DIVISION_ID40','END_CUSTOMER','END_CUSTOMER40',
                       'SCM_SITE_ID','SCM_SITE_ID40','ITEM_ID','ITEM_ID40','NICK_NAME',
                       'INCOTERMS','FCST_TYPE','DOM_EXP','ITEM_TYPE','MEASURE',
                       'PROJECT_CODE','PLANT_SITE_ID')
 ORDER BY SORT_ORDER_NO;

PROMPT === 1-C. 비-main sheet 행 (psi/carFcst/Customer Demand Analysis) — 현재 FE 미사용 ===
PROMPT ===      ‼️ 단, 백엔드 SP(DMF0003_GET_DM_ANL_MKT_PSI_*, _CAR_*, GET_SPREAD_TITLE_PSI/_CAR) 가 존재 ===
PROMPT ===         = AS-IS PSI 분석 / Car FCST 서브탭. 현 TO-BE FE 미구현(차기 Phase). DEAD 아님 → 보존 권고. ===
SELECT SHEET_NAME, SORT_ORDER_NO, COLUMN_NAME, COLUMN_LABEL_NAME
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME <> 'main'
 ORDER BY SHEET_NAME, SORT_ORDER_NO;

PROMPT === 1-D. MEASURE 중복 sheet — "Mkt Fcst"(47 권위) vs main(12 stub) ===
SELECT SHEET_NAME, COUNT(*) CNT,
       SUM(CASE WHEN VALID_YN='Y' THEN 1 ELSE 0 END) VALID_Y
  FROM SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID='DMF0003'
 GROUP BY SHEET_NAME ORDER BY SHEET_NAME;

--------------------------------------------------------------------------------
-- [STEP 2] align(#96) 교정 UPDATE  — 위반 0건 → 적용 대상 없음 (no-op 멱등)
--------------------------------------------------------------------------------
-- HORIZONTAL_ALIGN_CODE 는 이미 전부 C/L/R 단일문자. 아래는 만일의 비표준 잔존 대비 안전 정규화(멱등).
-- 'Center'->'C' 'Left'->'L' 'Right'->'R' (전체단어가 있으면 교정; 없으면 0 row).
UPDATE SCM_MST_SHEET_COLUMNS
   SET HORIZONTAL_ALIGN_CODE =
         CASE UPPER(HORIZONTAL_ALIGN_CODE)
           WHEN 'CENTER' THEN 'C' WHEN 'LEFT' THEN 'L' WHEN 'RIGHT' THEN 'R'
           ELSE HORIZONTAL_ALIGN_CODE END,
       LAST_UPDATED_BY = 'meta_audit_39', LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID='DMF0003'
   AND UPPER(HORIZONTAL_ALIGN_CODE) IN ('CENTER','LEFT','RIGHT');
-- 예상 영향: 0 row (진단 시 전부 단일문자 확인). COMMIT 은 STEP 4 에서.

--------------------------------------------------------------------------------
-- [STEP 3] NOT NULL 누락 보정  — 누락 0건 → 적용 대상 없음 (no-op)
--------------------------------------------------------------------------------
-- 진단 시 NOT NULL 12 컬럼(FIXED_FLAG/COLUMN_WIDTH/UPPERCASE_APPLY_FLAG/VISIBLE_FLAG/
--   DEFAULT_FLAG/USER_SELECTABLE_FLAG/VALID_YN/CREATED_BY/LAST_UPDATED_BY/INPUT_TP_CD/
--   HORIZONTAL_ALIGN_CODE/COLUMN_LABEL_NAME) NULL row = 0. 보정 UPDATE 불요.
-- (잔존 대비 가드 SELECT — 행이 나오면 그때 개별 보정)
PROMPT === 3-A. NOT NULL 누락 가드 (0 row 여야 정상) ===
SELECT SHEET_NAME, COLUMN_NAME FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0003'
   AND (FIXED_FLAG IS NULL OR COLUMN_WIDTH IS NULL OR UPPERCASE_APPLY_FLAG IS NULL
     OR VISIBLE_FLAG IS NULL OR DEFAULT_FLAG IS NULL OR USER_SELECTABLE_FLAG IS NULL
     OR VALID_YN IS NULL OR CREATED_BY IS NULL OR LAST_UPDATED_BY IS NULL
     OR INPUT_TP_CD IS NULL OR HORIZONTAL_ALIGN_CODE IS NULL OR COLUMN_LABEL_NAME IS NULL);

--------------------------------------------------------------------------------
-- [STEP 4] 정합 정리(DELETE) — ⚠️ 전부 보류(주석). 사용자 승인 후 개별 해제.
--------------------------------------------------------------------------------
-- ❌ 자동 DELETE 금지. 아래 후보들은 "FE 미사용" 이지만 백엔드 SP 가 살아있어 차기 Phase 자산일 수 있음.
--    anti-simplification + #78(임의 삭제 금지) 에 따라 강제 삭제하지 않음.
--
-- [후보 A] 비-main SHEET_COLUMNS sheet (psi/carFcst/Customer Demand Analysis, 29 row)
--   판정 : 현 TO-BE FE 미참조. BUT DMF0003_GET_DM_ANL_MKT_PSI_*/_CAR_* SP 존재 → AS-IS 서브탭 메타.
--   권고 : ✅ 보존 (삭제 보류). 차기 PSI/Car FCST 탭 구현 시 재사용. 정리하려면 사용자 명시 승인 필요.
--   (승인 시에만 해제)
--   DELETE FROM SCM_MST_SHEET_COLUMNS
--    WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME IN ('psi','carFcst','Customer Demand Analysis');
--
-- [후보 B] MEASURE 중복 sheet main(12) vs "Mkt Fcst"(47)
--   판정 : "Mkt Fcst" = AS-IS 권위(BNPIn 등 PR 트리거 measure 포함). main(12) = 단순 stub 중복.
--   주의 : 어느 쪽도 현재 FE 가 정확히 안 받음 (FE 가 'MKT FCST' 송신 — §4 mismatch). 명칭 확정이 선행.
--   권고 : ✅ 보류. §4 FE 수정으로 'Mkt Fcst' 로 정렬한 뒤, main(12) stub 정리 여부 별도 승인.
--   (승인 시에만 해제)
--   DELETE FROM SCM_MST_SHEET_MEASURE
--    WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='main';
--
-- 변경이 없으므로 ROLLBACK 으로 종료 (STEP 2/3 no-op 도 미커밋).
-- 실제 정리 적용 시: 위 DELETE 해제 → 영향행수 확인 → COMMIT.
ROLLBACK;

--------------------------------------------------------------------------------
-- [STEP 5] 백업 검증
--------------------------------------------------------------------------------
PROMPT === 5. 백업 row 수 (원본과 일치 확인) ===
SELECT 'COLUMNS_BAK' T, COUNT(*) CNT FROM SCM_MST_SHEET_COLUMNS_BAK_DMF0003
UNION ALL
SELECT 'MEASURE_BAK', COUNT(*) FROM SCM_MST_SHEET_MEASURE_BAK_DMF0003;

--------------------------------------------------------------------------------
-- §4. ⭐ 진짜 정합 결손 = FE 코드 수정 (corp write 아님 — 별도 FE PR)
--------------------------------------------------------------------------------
-- 파일 : nscm-fe/features/demand/src/pages/mkt-fcst/mkt-fcst.constants.ts
--   현재 : ADMIN_SHEET_NAME = { [SHEETS.MAIN]: 'MKT FCST' }
--   문제 : /admin/menu/DMF0003/column 이 SHEET_NAME='MKT FCST' 로 조회 → DMF0003 엔 그런 sheet 없음
--          (DB column sheet = 'main', measure sheet = 'Mkt Fcst'/'main'). 항상 0 row → 하드코딩 fallback.
--   결과 : admin(UI Category Setup) 의 67 컬럼 visible/align/width/division 변경이 화면에 전혀 반영 안 됨
--          (ui-category-setup-column-meta 위반). measure 도 동일(fetchStaticMeasures 0 row).
--
--   교정 (FE) :
--     export const ADMIN_SHEET_NAME = { [SHEETS.MAIN]: 'main' };          -- column fetch
--     // measure fetch 는 'Mkt Fcst' 명칭이 권위(47행) — measure 전용 매핑 분리 권고:
--     export const ADMIN_MEASURE_SHEET_NAME = { [SHEETS.MAIN]: 'Mkt Fcst' };
--     useMktFcstStore.fetchStaticMeasures 에서 ADMIN_MEASURE_SHEET_NAME 사용.
--   (BE 무변경 — /admin/menu/{id}/column·/measure generic. SP 무변경.)
--------------------------------------------------------------------------------
