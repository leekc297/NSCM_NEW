-- =====================================================================================
-- SDM1020 — [02] GRANT + SYNONYM (앱계정 실행 권한 — SP EXECUTE 축)
-- 사내 실측(2026-08-19): DBA_TAB_PRIVS GRANTEE=SCMP_APP EXECUTE 1행 + ALL_SYNONYMS SCMP_APP.PKG_SDM1020 1행
-- =====================================================================================

-- [A] 클라우드 BE 계정 = SCMP_APP 프로파일
GRANT EXECUTE ON SCM_MGR.PKG_SDM1020 TO SCMP_APP;

-- ⚠ 시노님 생성은 DBA 권한(CREATE ANY SYNONYM) 필요 — SCM_MGR 계정으로는 불가(사내 실사고).
--   DBA 세션에서 실행할 것. 기존재 시 ORA-00955 -> 동일 대상(FOR SCM_MGR.PKG_SDM1020) 확인 후 skip.
CREATE SYNONYM SCMP_APP.PKG_SDM1020 FOR SCM_MGR.PKG_SDM1020;

-- [B] 클라우드 BE 계정 = SCMD_APP 프로파일(dev/qa/prd 환경별 상이) — 해당 환경에서 주석 해제 실행
-- GRANT EXECUTE ON SCM_MGR.PKG_SDM1020 TO SCMD_APP;
-- CREATE SYNONYM SCMD_APP.PKG_SDM1020 FOR SCM_MGR.PKG_SDM1020;   -- (DBA 세션)

-- [검증]
-- SELECT GRANTEE, PRIVILEGE FROM DBA_TAB_PRIVS WHERE OWNER='SCM_MGR' AND TABLE_NAME='PKG_SDM1020';
-- SELECT OWNER, SYNONYM_NAME FROM ALL_SYNONYMS WHERE TABLE_NAME='PKG_SDM1020';
