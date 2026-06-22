-- ============================================================
-- SYS0013 — GRANT EXECUTE + PUBLIC SYNONYM 일괄 (SCMD_APP 사용계정)
-- 실행 계정: SCM_MGR · 룰 `feedback_scmd_app_grant_mandatory`
-- ⚠ PKG.PROC 부분 grant 불가 — PKG/standalone 단위만 (중복 제거)
-- ============================================================

GRANT EXECUTE ON SCM_MGR.PKG_SYS0013 TO SCMD_APP;
CREATE OR REPLACE PUBLIC SYNONYM PKG_SYS0013 FOR SCM_MGR.PKG_SYS0013;
GRANT EXECUTE ON SCM_MGR.SYS0013_GET_HISTORY TO SCMD_APP;
CREATE OR REPLACE PUBLIC SYNONYM SYS0013_GET_HISTORY FOR SCM_MGR.SYS0013_GET_HISTORY;
