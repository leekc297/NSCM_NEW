--==============================================================================
-- 010_DEPENDENT_OBJECTS_CHECK.sql (DMF0043_01)
--
-- 목적: DMF0043_01 (Contribute View) 가 호출하는 종속 객체 존재 + STATUS 확인 (READ-ONLY)
-- 실행: SCM_MGR / SCMD_APP 세션 모두 OK
-- 작성: 2026-06-05
--
-- DMF0043_01 종속 인벤토리:
--   1. DMF0043 의 공유 SP 4개 (CONTRIBUTION_SALES_LIST / SALES_LIST_SPREAD_TITLE / MAIN_VARSION_DATA / CONTRIBUTE_RATE_POPUP)
--      → DMF0043 deploy 패키지 (01_SP_BODY/010) 가 선적용 필요
--   2. DMF0043_GET_CONT_VIEW_VERSIONPOPUP — DMF0043 패키지 안 [7/9]
--   3. DMF0002_GET_TITLESET_POPUP — 본 패키지 01_SP_BODY/010 에 carrying
--   4. 공용: UF_FX_STRING_SPLIT / PKG_SCM_USER_MNU / PR_SCM_SYS_LOG_BATCH
--==============================================================================
SET LINESIZE 200
SET PAGESIZE 100
SET SERVEROUTPUT ON

PROMPT === DIAG 1 : DMF0043_01 종속 SP 존재 + STATUS ===

SELECT object_name, object_type, status,
       TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND object_name IN (
     'DMF0043_GET_CONTRIBUTION_SALES_LIST',      -- DMF0043 공유
     'DMF0043_GET_SALES_LIST_SPREAD_TITLE',      -- DMF0043 공유
     'DMF0043_GET_MAIN_VARSION_DATA',            -- DMF0043 공유
     'DMF0043_GET_CONTRIBUTE_RATE_POPUP',        -- DMF0043 공유
     'DMF0043_GET_CONT_VIEW_VERSIONPOPUP',       -- DMF0043_01 전용 (PKG 안)
     'DMF0002_GET_TITLESET_POPUP',               -- 공용 (titleSet popup)
     'UF_FX_STRING_SPLIT',
     'PKG_SCM_USER_MNU',
     'PR_SCM_SYS_LOG_BATCH'
   )
 ORDER BY object_type, object_name;

PROMPT === DIAG 2 : 누락 객체 ===

WITH expected AS (
  SELECT 'DMF0043_GET_CONTRIBUTION_SALES_LIST'  AS object_name FROM DUAL UNION ALL
  SELECT 'DMF0043_GET_SALES_LIST_SPREAD_TITLE'                FROM DUAL UNION ALL
  SELECT 'DMF0043_GET_MAIN_VARSION_DATA'                     FROM DUAL UNION ALL
  SELECT 'DMF0043_GET_CONTRIBUTE_RATE_POPUP'                 FROM DUAL UNION ALL
  SELECT 'DMF0043_GET_CONT_VIEW_VERSIONPOPUP'                FROM DUAL UNION ALL
  SELECT 'DMF0002_GET_TITLESET_POPUP'                        FROM DUAL UNION ALL
  SELECT 'UF_FX_STRING_SPLIT'                                FROM DUAL UNION ALL
  SELECT 'PKG_SCM_USER_MNU'                                  FROM DUAL UNION ALL
  SELECT 'PR_SCM_SYS_LOG_BATCH'                              FROM DUAL
)
SELECT e.object_name AS MISSING_OBJECT,
       CASE
         WHEN e.object_name LIKE 'DMF0043_%' AND e.object_name <> 'DMF0043_GET_CONT_VIEW_VERSIONPOPUP'
              THEN 'DMF0043 deploy package 의 01_SP_BODY/010 선적용 필요'
         WHEN e.object_name = 'DMF0043_GET_CONT_VIEW_VERSIONPOPUP'
              THEN 'PKG_DMF0043 PACKAGE BODY 적재 필요'
         WHEN e.object_name = 'DMF0002_GET_TITLESET_POPUP'
              THEN '본 패키지 01_SP_BODY/010 실행 필요'
         ELSE 'CLOUD 운영팀 / DBA grant 또는 객체 생성 필요'
       END AS RESOLUTION
  FROM expected e
 WHERE NOT EXISTS (
   SELECT 1 FROM all_objects a
    WHERE a.owner = 'SCM_MGR' AND a.object_name = e.object_name
 );

PROMPT === DIAG 3 : INVALID 객체의 컴파일 오류 ===

SELECT name, type, line, position, text
  FROM all_errors
 WHERE owner = 'SCM_MGR'
   AND name IN (
     'DMF0043_GET_CONTRIBUTION_SALES_LIST',
     'DMF0043_GET_SALES_LIST_SPREAD_TITLE',
     'DMF0043_GET_MAIN_VARSION_DATA',
     'DMF0043_GET_CONTRIBUTE_RATE_POPUP',
     'DMF0043_GET_CONT_VIEW_VERSIONPOPUP',
     'DMF0002_GET_TITLESET_POPUP'
   )
 ORDER BY name, sequence
 FETCH FIRST 50 ROWS ONLY;

PROMPT === 판독 ===
PROMPT - DIAG 1 9 row + STATUS=VALID 모두 → 진행 OK
PROMPT - DIAG 2 row 있음 → 누락 객체 해결 필수 (특히 DMF0043 deploy 선적용)
PROMPT - DIAG 3 row 0 → 컴파일 정상
