-- ============================================================================
-- DMF0082 Excel 업로드 SP 3종 — SCMD_APP SYNONYM (⚠ SCMD_APP user 로 접속 후 실행)
-- ----------------------------------------------------------------------------
-- 사유: SCM_MGR 는 CREATE ANY SYNONYM 권한 없음 (선례: 64_sys0013_synonym_scmd_app_user.sql)
-- GRANT EXECUTE 는 2026-07-12 SCM_MGR 세션에서 적용 완료 — SYNONYM 만 잔여.
-- 접속: sqlplus SCMD_APP/<password>@121.162.245.167:2521/OCGSCMD_P01
-- ============================================================================

CREATE OR REPLACE SYNONYM DMF0082_GET_MAIN_DATA_CURRENT FOR SCM_MGR.DMF0082_GET_MAIN_DATA_CURRENT;
CREATE OR REPLACE SYNONYM DMF0082_GET_EXCEL_UPLOAD_DATA FOR SCM_MGR.DMF0082_GET_EXCEL_UPLOAD_DATA;
CREATE OR REPLACE SYNONYM DMF0082_EXCEL_UPLOAD          FOR SCM_MGR.DMF0082_EXCEL_UPLOAD;

-- 검증
SELECT SYNONYM_NAME, TABLE_OWNER, TABLE_NAME
  FROM USER_SYNONYMS
 WHERE SYNONYM_NAME LIKE 'DMF0082_%'
 ORDER BY SYNONYM_NAME;
