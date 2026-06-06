--==============================================================================
-- 010_DEPENDENT_OBJECTS_CHECK.sql
--
-- 목적: DMF0043 SP body 가 호출하는 종속 객체들이 클라우드에 존재하고 VALID 한지 확인 (READ-ONLY)
-- 실행: SCM_MGR 또는 SCMD_APP 세션. SQL*Plus / DBeaver 모두 OK
-- 작성: 2026-06-04
--
-- 종속 객체 인벤토리 (DMF0043_GET_CONTRIBUTE_MAIN_DATA / GET_MAIN_SPREAD_TITLE 본문에서 추출):
--   1. PKG_SCM_USER_MNU (PACKAGE)        — PR_SCM_EDIT_YN() 사용
--   2. UF_FX_STRING_SPLIT (FUNCTION)     — NSCM 표준 문자열 분리 (TOKEN 컬럼 반환)
--   3. PR_SCM_SYS_LOG_BATCH (PROCEDURE)  — 시스템 로깅
--   4. DMF0002_GET_TITLESET_POPUP (PROCEDURE) — DMF0043_01 공유 (titleSet popup)
--==============================================================================
SET LINESIZE 200
SET PAGESIZE 100
SET SERVEROUTPUT ON

PROMPT === DIAG 1 : DMF0043 종속 객체 존재 + STATUS ===

SELECT object_name, object_type, status,
       TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl,
       owner
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND object_name IN (
     'PKG_SCM_USER_MNU',
     'UF_FX_STRING_SPLIT',
     'PR_SCM_SYS_LOG_BATCH',
     'DMF0002_GET_TITLESET_POPUP'
   )
 ORDER BY object_name;

PROMPT === DIAG 2 : 누락 객체 식별 ===

WITH expected AS (
  SELECT 'PKG_SCM_USER_MNU'          AS object_name FROM DUAL UNION ALL
  SELECT 'UF_FX_STRING_SPLIT'                       FROM DUAL UNION ALL
  SELECT 'PR_SCM_SYS_LOG_BATCH'                     FROM DUAL UNION ALL
  SELECT 'DMF0002_GET_TITLESET_POPUP'               FROM DUAL
)
SELECT e.object_name AS MISSING_OBJECT,
       'CLOUD 에 없음 — SCM_MGR 권한으로 생성 또는 다른 schema 에서 GRANT 필요' AS RESOLUTION
  FROM expected e
 WHERE NOT EXISTS (
   SELECT 1 FROM all_objects a
    WHERE a.owner = 'SCM_MGR' AND a.object_name = e.object_name
 );

PROMPT === DIAG 3 : INVALID 객체 (있다면 컴파일 오류 상세) ===

SELECT name, type, line, position, text
  FROM all_errors
 WHERE owner = 'SCM_MGR'
   AND name IN (
     'PKG_SCM_USER_MNU',
     'UF_FX_STRING_SPLIT',
     'PR_SCM_SYS_LOG_BATCH',
     'DMF0002_GET_TITLESET_POPUP'
   )
 ORDER BY name, sequence;

PROMPT === 판독 ===
PROMPT - DIAG 1 4 row + STATUS=VALID 모두 → 진행 OK
PROMPT - DIAG 2 결과 row 있음 → 누락 객체. SP body 컴파일/실행 시 PLS-00201 폭발
PROMPT - DIAG 3 결과 row 있음 → INVALID 객체. 해당 컴파일 오류 우선 해결
