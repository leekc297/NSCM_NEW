-- PKG_SYS0012 — 앱계정 실행 권한 (SCM_MGR 로 실행 · 멱등: GRANT 재실행 무해)
-- 사내 적용 2026-09-15 19:00:15 (s2_apply.py grants) · 확인 2026-09-15 19:03: EXECUTE 존재
GRANT EXECUTE ON SCM_MGR.PKG_SYS0012 TO SCMP_APP;
