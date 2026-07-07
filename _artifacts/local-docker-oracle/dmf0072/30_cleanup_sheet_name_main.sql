-- =====================================================================================
-- DMF0072 SHEET_COLUMNS 정리 (2026-06-28) — 사용자 요구 (sheet명 main 일원화 + 헤더 1단)
--   배경: AS-IS UI Category Setup sheet명 = NNMasterMapping. TO-BE = main (FE 이미 main 사용)
--   사내 OCGSCMD_P01 SCM_MST_SHEET_COLUMNS DMF0072 = NNMasterMapping(23) + main(23) 중복
--   조회 proc PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST = WHERE SHEET_NAME = sheetNm
--   (case-sensitive exact) → FE가 main 만 전달 → NNMasterMapping 은 dead data
--
--   작업 1) NNMasterMapping 23행 삭제 (main 일원화)
--   작업 2) main 23행 LARGE_CLASS_LABEL_NAME / SMALL_CLASS_LABEL_NAME = NULL (헤더 1단화)
--           getColumnDepth(FE columnMapping.ts) 가 LG/SM 비면 ONE_DEPTH(단일헤더) 판정
--
--   백업: 변경 전 DMF0072 전체(46행) CTAS = SCM_MST_SHC_DMF72_BAK (원복 source)
--   원복: DELETE main; INSERT INTO SCM_MST_SHEET_COLUMNS SELECT * FROM SCM_MST_SHC_DMF72_BAK
--   멱등: DROP IF EXISTS(PLSQL) + CTAS / DELETE 조건=NNMasterMapping(재실행 0건) / UPDATE NULL(재실행 동일)
--   적용: python _artifacts/_diagnostics/ora.py exec _artifacts/local-docker-oracle/dmf0072/30_cleanup_sheet_name_main.sql
-- =====================================================================================

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE SCM_MST_SHC_DMF72_BAK';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE SCM_MST_SHC_DMF72_BAK AS
SELECT * FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = 'DMF0072';

DELETE FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0072' AND SHEET_NAME = 'NNMasterMapping';

UPDATE SCM_MST_SHEET_COLUMNS
   SET LARGE_CLASS_LABEL_NAME = NULL, SMALL_CLASS_LABEL_NAME = NULL
 WHERE PROGRAM_ID = 'DMF0072' AND SHEET_NAME = 'main';

COMMIT;
