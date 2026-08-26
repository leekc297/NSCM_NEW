-- GRANT_EXCHANGE_RATE_UI_SCMP_APP_20260818.sql
--   DMF0082 환율 모달 [BPS I/F] 클릭 시 SQL ERROR — 앱계정 EXECUTE 권한 누락 정정
--
-- 원인: BPS I/F = `/{MENU_ID}/futurePriceInfo/IF/call-proc` → SCM_MGR.PR_SCM_MST_EXCHANGE_RATE_UI.
--   이 래퍼는 2026-08-07 신설 standalone 프로시저인데 GRANT 가 **SCMD_APP 에만** 부여돼 있었다.
--   UI/BE 접속 계정이 SCMP_APP 인 환경(클라우드)에서는 객체를 못 찾아 ORA-00904/06550 계열로 실패한다.
--   같은 화면의 PKG_DMF0082 / PR_SCM_MST_EXCHANGE_RATE 는 두 계정 모두 보유 — 신설 객체만 누락.
--   ⚠ 사내 로컬 BE 가 SCM_MGR 직결이면 절대 재현되지 않는다(정적 확인 의무).

GRANT EXECUTE ON SCM_MGR.PR_SCM_MST_EXCHANGE_RATE_UI TO SCMP_APP;

-- 검증: SCMD_APP · SCMP_APP 2행이어야 한다
SELECT TABLE_NAME, GRANTEE, PRIVILEGE
  FROM ALL_TAB_PRIVS
 WHERE TABLE_SCHEMA = 'SCM_MGR'
   AND TABLE_NAME   = 'PR_SCM_MST_EXCHANGE_RATE_UI'
 ORDER BY GRANTEE;
