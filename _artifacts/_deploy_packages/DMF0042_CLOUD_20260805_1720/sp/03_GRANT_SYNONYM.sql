-- ============================================================================
-- 03 PKG_DMF0042 — APP 계정 실행 권한 + SYNONYM
-- 생성: 2026-08-05 (사내 OCGSCMD_P01 실측 덤프 — 기억/추측 아님)
-- 원칙: 클라우드 INSERT-only 멱등 (기존재 row 무변경, KEY NOT EXISTS)
-- ============================================================================
-- ⚠ 계정명: 사내=SCMD_APP / 클라우드=SCMP_APP (DBWORK_7UI §3-A 실측) — 적용 환경의 APP 계정으로 치환 실행.

GRANT EXECUTE ON SCM_MGR.PKG_DMF0042 TO SCMP_APP;

BEGIN
  EXECUTE IMMEDIATE 'CREATE SYNONYM SCMP_APP.PKG_DMF0042 FOR SCM_MGR.PKG_DMF0042';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

-- 공용 의존(기존재 확인 의무 — 룰 22 §9.5, 본 패키지 범위 외):
-- SELECT OBJECT_NAME, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME IN
--  ('FN_STRING_SPLIT','UF_FX_STRING_SPLITFORIN','FN_GET_DM_MKT_OWNER_NAME',
--   'PR_DM_PLN_VERSION_CREATE','PR_SCM_SYS_LOG_BATCH','PKG_SCM_USER_MNU');
-- 6행 VALID 아니면 선행 이관 필요.
