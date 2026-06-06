--==============================================================================
-- 010_Object_Status_Verify.sql
--
-- 목적: DMF0043 관련 모든 객체의 STATUS = VALID 인지 검증 (READ-ONLY)
--       INVALID 시 USER_ERRORS dump 으로 컴파일 오류 식별
-- 실행: SCM_MGR 세션. SQL*Plus / DBeaver 모두 OK
-- 작성: 2026-06-04
--
-- 검증 대상:
--   - DMF0043 SP 9개 (standalone)
--   - PKG_DMF0043 (존재 시)
--   - GT_DMF0043_* 7개 (GTT)
--   - 종속 PKG/FUNC (PKG_SCM_USER_MNU / UF_FX_STRING_SPLIT / PR_SCM_SYS_LOG_BATCH)
--==============================================================================
SET LINESIZE 250
SET PAGESIZE 200
SET SERVEROUTPUT ON

PROMPT === VERIFY 1 : DMF0043 SP 9개 + 종속 객체 STATUS ===

SELECT object_name, object_type, status,
       TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND (
        (object_name LIKE 'DMF0043_%' AND object_type = 'PROCEDURE')
     OR (object_name = 'PKG_DMF0043' AND object_type IN ('PACKAGE', 'PACKAGE BODY'))
     OR (object_name IN ('PKG_SCM_USER_MNU', 'PR_SCM_SYS_LOG_BATCH', 'UF_FX_STRING_SPLIT',
                         'DMF0002_GET_TITLESET_POPUP'))
   )
 ORDER BY object_type, object_name;

PROMPT === VERIFY 2 : INVALID 객체 (있다면 우선 해결) ===

SELECT object_name, object_type, status
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND (object_name LIKE 'DMF0043_%' OR object_name LIKE 'PKG_DMF0043%')
   AND status = 'INVALID';

PROMPT === VERIFY 3 : INVALID 시 컴파일 오류 상세 ===

SELECT name, type, line, position, text
  FROM all_errors
 WHERE owner = 'SCM_MGR'
   AND (name LIKE 'DMF0043_%' OR name LIKE 'PKG_DMF0043%')
 ORDER BY name, sequence
 FETCH FIRST 100 ROWS ONLY;

PROMPT === VERIFY 4 : GTT 7개 존재 여부 ===

SELECT table_name, temporary, duration
  FROM all_tables
 WHERE owner = 'SCM_MGR'
   AND table_name LIKE 'GT_DMF0043_%'
 ORDER BY table_name;

PROMPT === VERIFY 5 : 누락 항목 (총괄) ===

WITH expected_objects AS (
  SELECT 'DMF0043_GET_CONTRIBUTE_MAIN_DATA'    AS name, 'PROCEDURE' AS typ FROM DUAL UNION ALL
  SELECT 'DMF0043_GET_CONTRIBUTE_RATE_POPUP',           'PROCEDURE' FROM DUAL UNION ALL
  SELECT 'DMF0043_GET_CONTRIBUTE_YEAR_POPUP',           'PROCEDURE' FROM DUAL UNION ALL
  SELECT 'DMF0043_GET_CONT_VIEW_VERSIONPOPUP',          'PROCEDURE' FROM DUAL UNION ALL
  SELECT 'DMF0043_GET_MAIN_SPREAD_TITLE',               'PROCEDURE' FROM DUAL UNION ALL
  SELECT 'DMF0043_GET_MAIN_VARSION_DATA',               'PROCEDURE' FROM DUAL UNION ALL
  SELECT 'DMF0043_GET_SALES_LIST_SPREAD_TITLE',         'PROCEDURE' FROM DUAL UNION ALL
  SELECT 'DMF0043_GET_CONTRIBUTION_SALES_LIST',         'PROCEDURE' FROM DUAL UNION ALL
  SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO',        'PROCEDURE' FROM DUAL UNION ALL
  SELECT 'DMF0043_SAVE_DM_MST_CONTRIBUTE_VER',          'PROCEDURE' FROM DUAL UNION ALL
  SELECT 'GT_DMF0043_TITLE',                            'TABLE'     FROM DUAL UNION ALL
  SELECT 'GT_DMF0043_TEMP',                             'TABLE'     FROM DUAL UNION ALL
  SELECT 'GT_DMF0043_TEMP2',                            'TABLE'     FROM DUAL UNION ALL
  SELECT 'GT_DMF0043_TEMP3',                            'TABLE'     FROM DUAL UNION ALL
  SELECT 'GT_DMF0043_MASTER_LIST',                      'TABLE'     FROM DUAL UNION ALL
  SELECT 'GT_DMF0043_TEMP_LIST',                        'TABLE'     FROM DUAL UNION ALL
  SELECT 'GT_DMF0043_DATA_TABLE',                       'TABLE'     FROM DUAL
)
SELECT e.name AS MISSING_OBJECT, e.typ AS object_type
  FROM expected_objects e
 WHERE NOT EXISTS (
   SELECT 1 FROM all_objects a
    WHERE a.owner = 'SCM_MGR'
      AND a.object_name = e.name
      AND (a.object_type = e.typ
           OR (e.typ = 'TABLE' AND a.object_type = 'TABLE'))
 )
 ORDER BY 1;

PROMPT === 판독 ===
PROMPT - VERIFY 1 모든 row STATUS=VALID → OK
PROMPT - VERIFY 2 row 0 → OK
PROMPT - VERIFY 3 row 0 → OK
PROMPT - VERIFY 4 7 row 모두 출력 + TEMPORARY=Y → OK
PROMPT - VERIFY 5 row 0 → 모든 객체 존재 OK
