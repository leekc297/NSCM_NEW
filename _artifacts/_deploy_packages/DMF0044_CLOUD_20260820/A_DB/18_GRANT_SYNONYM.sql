-- ═══════════════════════════════════════════════════════════════════════════════
-- DMF0044_CLOUD_20260820 / A_DB/18_GRANT_SYNONYM.sql
--   PKG_DMF0044 EXECUTE GRANT + 앱 계정 시노님.
--
--   ⚠ DMF0014 PLS-00201 사고 계보 — 메타(API_M)만 고치고 GRANT/시노님을 빠뜨리면
--     UI/BE 계정(SCMD_APP / SCMP_APP)에서 "식별자를 선언해야 합니다" 로 실패한다.
--     **시노님 ≠ 권한**이므로 둘 다 필요하다. 시노님만 만들면 시노님은 VALID 로 보이지만
--     실행은 동일하게 실패한다.
--
--   실행 주체:
--     · GRANT   → SCM_MGR (객체 소유자) 로 실행
--     · SYNONYM → 각 앱 계정 소유 시노님이므로 DBA(또는 CREATE ANY SYNONYM 보유 계정)로 실행
--
--   ── 사내 실측 구성 (2026-08-20, DBA_TAB_PRIVS / ALL_SYNONYMS) ────────────────
--     PKG_DMF0044                : SCMD_APP EXECUTE · SCMP_APP EXECUTE            (2건)
--                                  시노님 SCMD_APP / SCMP_APP 동명                (2건)
--     DMF0002_GET_TITLESET_POPUP : SCMD_APP·SCMP_APP EXECUTE + RL_SCM_DML(EXECUTE,DEBUG)
--                                  + RL_SCM_SEL(EXECUTE)                          (5건)
--                                  시노님 SCMD_APP / SCMP_APP 동명                (2건)
--     SCM0002_SET_TITLESET_POPUP : 위와 동일 구성                                 (5건 + 시노님 2건)
--     PKG_DMF0000                : SCMD_APP EXECUTE · SCMP_APP EXECUTE            (2건)
--                                  시노님 SCMD_APP / SCMP_APP 동명                (2건)
--   ───────────────────────────────────────────────────────────────────────────────
--   §2·§3 의 공유 객체 3본은 **본 화면이 API_M 을 통해 직접 호출**한다 (24_PROC_M_SYNC §2 참조).
--   클라우드에 이미 있으면 재실행해도 무해하지만, 없으면 팝업 진입 시점에 PLS-00201 로 죽는다.
-- ═══════════════════════════════════════════════════════════════════════════════

-- ── §1) PKG_DMF0044 — EXECUTE GRANT (SCM_MGR 로 실행) ─────────────────────────
GRANT EXECUTE ON SCM_MGR.PKG_DMF0044 TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.PKG_DMF0044 TO SCMP_APP;

-- ── §2) PKG_DMF0044 — SYNONYM (DBA 실행) ──────────────────────────────────────
CREATE OR REPLACE SYNONYM SCMD_APP.PKG_DMF0044 FOR SCM_MGR.PKG_DMF0044;
CREATE OR REPLACE SYNONYM SCMP_APP.PKG_DMF0044 FOR SCM_MGR.PKG_DMF0044;

-- ── §3) 공유 객체 3본 — 클라우드 결손일 때만 (00_CLOUD_PRECHECK C6 확인 후) ────
--   ⚠ 객체 자체가 클라우드에 없으면 GRANT 도 실패한다(ORA-04042).
--     그때는 본 패키지가 아니라 해당 화면(DMF0002 / SCM0002 / DMF0000) 소관 패키지로 배포할 것.
--     본 패키지는 **권한·시노님만** 보정한다.
-- GRANT EXECUTE ON SCM_MGR.DMF0002_GET_TITLESET_POPUP TO SCMD_APP;
-- GRANT EXECUTE ON SCM_MGR.DMF0002_GET_TITLESET_POPUP TO SCMP_APP;
-- GRANT EXECUTE ON SCM_MGR.SCM0002_SET_TITLESET_POPUP TO SCMD_APP;
-- GRANT EXECUTE ON SCM_MGR.SCM0002_SET_TITLESET_POPUP TO SCMP_APP;
-- GRANT EXECUTE ON SCM_MGR.PKG_DMF0000                TO SCMD_APP;
-- GRANT EXECUTE ON SCM_MGR.PKG_DMF0000                TO SCMP_APP;
-- CREATE OR REPLACE SYNONYM SCMD_APP.DMF0002_GET_TITLESET_POPUP FOR SCM_MGR.DMF0002_GET_TITLESET_POPUP;
-- CREATE OR REPLACE SYNONYM SCMP_APP.DMF0002_GET_TITLESET_POPUP FOR SCM_MGR.DMF0002_GET_TITLESET_POPUP;
-- CREATE OR REPLACE SYNONYM SCMD_APP.SCM0002_SET_TITLESET_POPUP FOR SCM_MGR.SCM0002_SET_TITLESET_POPUP;
-- CREATE OR REPLACE SYNONYM SCMP_APP.SCM0002_SET_TITLESET_POPUP FOR SCM_MGR.SCM0002_SET_TITLESET_POPUP;
-- CREATE OR REPLACE SYNONYM SCMD_APP.PKG_DMF0000                FOR SCM_MGR.PKG_DMF0000;
-- CREATE OR REPLACE SYNONYM SCMP_APP.PKG_DMF0000                FOR SCM_MGR.PKG_DMF0000;

-- ── §4) (옵션) 사내에만 있는 롤 경유 권한 — 클라우드에 동명 롤이 있을 때만 ─────
--   사내 실측: RL_SCM_DML(EXECUTE·DEBUG) / RL_SCM_SEL(EXECUTE) 가 공유 PROCEDURE 2본에 부여돼 있다.
--   PKG_DMF0044 자체에는 롤 부여 없음(앱 계정 직접 부여만).
--   클라우드에 롤이 없으면 ORA-01919 — 실행하지 말 것.
-- GRANT EXECUTE ON SCM_MGR.DMF0002_GET_TITLESET_POPUP TO RL_SCM_SEL;
-- GRANT EXECUTE ON SCM_MGR.SCM0002_SET_TITLESET_POPUP TO RL_SCM_SEL;
