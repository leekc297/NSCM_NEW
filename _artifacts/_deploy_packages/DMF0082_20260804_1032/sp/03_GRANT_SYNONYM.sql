-- ============================================================================
-- 03 PKG_DMF0082 — SCMD_APP 실행 권한 + SYNONYM (hook scmd-app-grant-mandatory)
-- BE(SCMD_APP) 는 SYNONYM 경유로 PKG_DMF0082.* 호출.
-- 멱등: GRANT 재실행 무해 / SYNONYM ORA-00955 skip.
-- (사내 실측: SCMD_APP EXECUTE + SYNONYM 기존재 — 클라우드 동기화용)
-- ============================================================================

GRANT EXECUTE ON SCM_MGR.PKG_DMF0082 TO SCMD_APP;

BEGIN
  EXECUTE IMMEDIATE 'CREATE SYNONYM SCMD_APP.PKG_DMF0082 FOR SCM_MGR.PKG_DMF0082';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

-- 공용 split 함수 (GET plant site 필터·SAVE 팝업 공용) — 클라우드 사전 존재 확인 의무 (룰 22 §9.5)
-- SELECT OBJECT_NAME, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME IN ('UF_FX_STRING_SPLITFORIN','UF_FX_STRING_SPLIT');
-- 0행 = AS-IS 공유 유틸 이관 선행 필요 (본 패키지 범위 외 — 기존 6UI 패키지에 동봉 이력 있음)
