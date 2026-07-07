-- =====================================================================================
-- DMF0008 — SCM_MST_SHEET_COLUMNS 대문자(AS-IS) sheet 행 삭제 (2026-06-28) — 사용자 요구.
--
-- 배경: AS-IS GSCM 은 sheet 명을 대문자(snake)로 적용(REPAIR/SALES_SITE/SSPM/SUMMARY).
--       TO-BE NSCM 은 소문자(camel) 사용(repair/salesSite/sspm/summary).
--       사내 OCGSCMD_P01 의 DMF0008 SHEET_COLUMNS 에 대문자/소문자가 중복 적재되어 있음
--       (각 sheet 별 행 수 동일: REPAIR 22 / SALES_SITE 25 / SSPM 69 / SUMMARY 5 = 121).
--
-- 안전성: BE 조회 proc = PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST.
--         WHERE C.SHEET_NAME = V_SHEET_NAME (= FE 전달 소문자, case-sensitive exact match).
--         FE 는 SHEETS enum 소문자(summary/repair/salesSite/sspm)만 전송.
--         → 대문자 행은 절대 매칭되지 않는 dead data. 소문자 행이 화면을 서빙. 삭제 = 무영향.
--
-- 대상: 전체 대문자 snake (SHEET_NAME = UPPER 이며 소문자 글자 없음). camelCase(salesSite)는 제외.
-- 멱등: CTAS 백업은 기존 있으면 DROP 후 재생성. DELETE 는 조건이 대문자만 → 재실행 시 0건.
-- 적용: python _artifacts/_diagnostics/ora.py exec _artifacts/local-docker-oracle/dmf0008/23_delete_uppercase_sheet_columns.sql
-- 원복: INSERT INTO SCM_MST_SHEET_COLUMNS SELECT * FROM SCM_MST_SHC_DMF8_UPR_BAK;
-- =====================================================================================

-- 1) 백업 (CTAS) — 삭제 대상 대문자 행 전체 보존 (원복 source)
DROP TABLE SCM_MST_SHC_DMF8_UPR_BAK;

CREATE TABLE SCM_MST_SHC_DMF8_UPR_BAK AS
SELECT * FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0008'
   AND SHEET_NAME = UPPER(SHEET_NAME)
   AND SHEET_NAME <> LOWER(SHEET_NAME);

-- 2) 삭제 — DMF0008 대문자 snake sheet 행만
DELETE FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0008'
   AND SHEET_NAME = UPPER(SHEET_NAME)
   AND SHEET_NAME <> LOWER(SHEET_NAME);

COMMIT;
