-- ============================================================================
-- [Step 4] PKG_DMF0000 — SCMD_APP 실행 권한 + SYNONYM (hook scmd-app-grant-mandatory)
-- BE(SCMD_APP) 는 SYNONYM 경유로 PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA 호출.
-- 멱등: GRANT 재실행 무해 / SYNONYM ORA-00955 skip.
-- (사내 실측: SCMD_APP·SCMP_APP EXECUTE + SYNONYM 기존재 — 클라우드 동기화용)
-- ============================================================================

GRANT EXECUTE ON SCM_MGR.PKG_DMF0000 TO SCMD_APP;

BEGIN
  EXECUTE IMMEDIATE 'CREATE SYNONYM SCMD_APP.PKG_DMF0000 FOR SCM_MGR.PKG_DMF0000';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -955 THEN RAISE; END IF;
END;
/
