-- ============================================================================
-- 04_APP_SYNONYM_ONLY.sql  (PKG_DMF0068)
--   ⛔ 【애플리케이션(BE 접속) 계정 세션에서만 실행】
--        · 클라우드 : **SCMP_APP**   ← 2026-07-30 확인 (SCMD_APP 아님)
--        · 사내     : SCMD_APP
--      SCM_MGR 로 실행하면 ORA-01031(권한 부족)로 실패한다.
--   DMF0068 이관에서 **유일하게 SCM_MGR 이 아닌 계정이 필요한 작업**이다.
--   선행: `01_PKG_DMF0068_SPEC.sql` → `02_PKG_DMF0068_BODY.sql` → `03_GRANT.sql`(SCM_MGR)
-- ============================================================================
--
-- 왜 필요한가:
--   BE 는 스키마 없는 `PKG_DMF0068.P_...` 로 호출한다
--   (`SCM_ADM_PROC_M.PROC_NM` 240건 전부 스키마 미표기 = 규약. PROC_M 수정 금지).
--   접속 계정에 SYNONYM 이 없으면 `ORA-06550 / PLS-00201` → BE 래퍼가 -9994 로 감싼다.
--   ⚠️ GRANT EXECUTE 만으로는 해결되지 않는다 (권한과 이름 해석은 별개).
--   ⚠️ 다른 계정에 만들면 **SP 직접 호출은 성공하는데 화면만 PLS-00201** (2026-07-30 SYS0017 실사고).
--   사내 실측: `PKG_%` SYNONYM 소유자 = SCMP_APP 57 / SCMD_APP 56 — 두 계정 공존.

-- ── [1] 지금 접속한 계정이 이 환경의 애플리케이션 계정인지 확인 ──────────────
--    클라우드에서 'SCMP_APP' 이 나와야 진행한다.
SELECT USER AS CURRENT_ACCOUNT FROM DUAL;

--    교차 확인 — 정상 동작 중인 화면 패키지의 SYNONYM 소유자 = 애플리케이션 계정
SELECT OWNER, SYNONYM_NAME, TABLE_OWNER
  FROM ALL_SYNONYMS
 WHERE TABLE_NAME IN ('PKG_DMF0068','PKG_DMF0044','PKG_DMF0049')
 ORDER BY SYNONYM_NAME, OWNER;

-- ── [2] SYNONYM 생성 (멱등) — 반드시 위 [1] 의 계정 세션에서 ─────────────────
CREATE OR REPLACE SYNONYM PKG_DMF0068 FOR SCM_MGR.PKG_DMF0068;

-- ── [3] 확인 — OWNER 가 현재 접속 계정(클라우드=SCMP_APP)과 같아야 한다 ───────
SELECT OWNER, SYNONYM_NAME, TABLE_OWNER, TABLE_NAME
  FROM ALL_SYNONYMS WHERE SYNONYM_NAME = 'PKG_DMF0068';

-- ── [4] 실제 호출 검증 (같은 세션 / SQLcl·SQL*Plus) ─────────────────────────
-- VAR rc1 REFCURSOR
-- VAR rc2 REFCURSOR
-- EXEC PKG_DMF0068.P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP('40','REPORT_SP_W','2025-07','2026-10',:rc1,:rc2);
-- PRINT rc1

-- ── [4] 는 되는데 화면만 PLS-00201 이면 ─────────────────────────────────────
--    ① 접속 계정 ≠ BE 접속 계정 → [1] 재확인 (1순위)
--    ② JDBC/MyBatis statement 캐시 → **WAS 재기동**
--    ③ 적용 DB 가 클라우드가 아님 → 접속 문자열 재확인
--
-- SYNONYM 1건으로 DMF0068 의 **5개 프로시저(12 API) 전부** 해소된다.
-- 참조 테이블·GTT 는 별도 GRANT 불필요 — 패키지가 AUTHID 미지정(정의자 권한)이라
-- 본문의 객체 접근이 SCM_MGR 권한으로 수행된다.
