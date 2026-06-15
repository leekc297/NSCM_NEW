-- =====================================================================
-- 01_DMF0043_01_TUNING_RUN.sql  (master runner — 2026-06-09 재정비)
--
-- DMF0043_01 (Contribute View) 조회 SQL 오류 + 속도 개선 master script
--
-- Phase 구조:
--   A. 진단:  02_DMF0043_01_DIAGNOSE.sql
--   B-1. 환경 분기 fix:
--        - 로컬 Docker: 03_LOCAL_FIX.sql
--        - cloud:       03_CLOUD_FIX.sql (별도 적용)
--   B-2. SP body patch: 04_DMF0043_01_BODY_PATCH.sql
--   C.   검증 + 복원:   05_VERIFY.sql
--
-- ⚠️ 본 runner 는 로컬 Docker 전용 자동 실행. cloud 적용은 03_CLOUD_FIX.sql 만 수동.
-- ⚠️ Phase 사이 사용자 결과 확인 후 다음 진행이 정석. 자동 실행은 진단 결과를
--    한 번에 보고자 할 때만 사용.
--
-- 실행: sqlplus scm_mgr/PASS@//localhost:1521/FREEPDB1 @01_DMF0043_01_TUNING_RUN.sql
-- =====================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 0
SET LONG 100000000
SET LONGCHUNKSIZE 32767
SET FEEDBACK OFF
WHENEVER SQLERROR CONTINUE
SET TIMING ON

PROMPT ===========================================================
PROMPT === DMF0043_01 TUNING RUN — Phase A → B-1 → B-2 → C ===
PROMPT ===========================================================

PROMPT
PROMPT ====================== Phase A — DIAGNOSE ======================
@@02_DMF0043_01_DIAGNOSE.sql

PROMPT
PROMPT ====================== Phase B-1 — LOCAL FIX ====================
@@03_LOCAL_FIX.sql

PROMPT
PROMPT ====================== Phase B-2 — BODY PATCH ===================
@@04_DMF0043_01_BODY_PATCH.sql

PROMPT
PROMPT ====================== Phase C — VERIFY + REVERT ================
@@05_VERIFY.sql

PROMPT
PROMPT ===========================================================
PROMPT === TUNING RUN 완료 ===
PROMPT === 검증 단계 ===
PROMPT === 1. FE 화면 진입 (DMF0043_01 Contribute View) ===
PROMPT === 2. Version 선택 → 조회 ===
PROMPT === 3. Grid 결과 표시 + Console DBMS_OUTPUT 의 [main-cursor] [sort-cursor] 부재 확인 ===
PROMPT === ===
PROMPT === cloud 별도 적용: @03_CLOUD_FIX.sql ===
PROMPT === Rollback: _diagnostics/...BEFORE_BODYPATCH_<ts>.sql 그대로 실행 ===
PROMPT ===========================================================
