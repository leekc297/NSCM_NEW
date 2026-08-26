-- =====================================================================================
-- SDM5010 Project Master — [03] 앱계정 실행 권한 + 시노님
-- 2026-08-19 · SDM1010/1020 선례 동일
-- =====================================================================================

-- [3-1] GRANT EXECUTE → SCMP_APP (SCM_MGR 계정으로 적용 — 2026-08-19 사내 적용 대상)
GRANT EXECUTE ON SCM_MGR.PKG_SDM5010 TO SCMP_APP;

-- [3-2] 시노님 — ⛔ 파일만 생성, 여기서 적용 시도 금지 (DBA 계정 실행 필요)
--   SCM_MGR 은 CREATE SYNONYM 권한 스코프 밖 — DBA 가 아래 1문을 별도 실행할 것.
--   (실행 전 기존재 확인: SELECT * FROM ALL_SYNONYMS WHERE OWNER='SCMP_APP' AND SYNONYM_NAME='PKG_SDM5010')
--
--   CREATE SYNONYM SCMP_APP.PKG_SDM5010 FOR SCM_MGR.PKG_SDM5010;
