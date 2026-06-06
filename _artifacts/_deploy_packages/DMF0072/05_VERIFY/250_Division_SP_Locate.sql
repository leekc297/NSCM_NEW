--==============================================================================
-- 250_Division_SP_Locate.sql
--
-- 목적:
--   DMF0008_GET_MY_DIVISION_LIST 가 SCM_MGR 에 없음. 다른 owner 또는 PKG 안에 있는지
--   광범위 검색.
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === DIAG 1 : DMF0008_GET_MY_DIVISION_LIST 전체 owner 검색 ===

SELECT owner, object_name, object_type, status, last_ddl_time
  FROM all_objects
 WHERE object_name = 'DMF0008_GET_MY_DIVISION_LIST'
 ORDER BY owner;

PROMPT === DIAG 2 : DMF0008 + DIVISION 관련 SP 광범위 ===

SELECT owner, object_name, object_type, status
  FROM all_objects
 WHERE object_name LIKE '%DMF0008%' AND object_name LIKE '%DIVISION%'
   AND object_type IN ('PROCEDURE', 'PACKAGE', 'SYNONYM', 'FUNCTION')
 ORDER BY owner, object_name;

PROMPT === DIAG 3 : SCMD_APP 의 DMF0008_GET_MY_DIVISION_LIST synonym ===

SELECT synonym_name, table_owner, table_name, db_link
  FROM all_synonyms
 WHERE synonym_name = 'DMF0008_GET_MY_DIVISION_LIST';

PROMPT === DIAG 4 : PKG_DMF0008 안의 GET_MY_DIVISION procedure 검색 ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'PKG_DMF0008'
   AND REGEXP_LIKE(text, 'PROCEDURE\s+\w*DIVISION|PROCEDURE\s+\w*MY_DIVISION', 'i')
 ORDER BY line
 FETCH FIRST 30 ROWS ONLY;

PROMPT === DIAG 5 : PKG_DMF0008 안의 모든 PROCEDURE 선언 ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'PKG_DMF0008'
   AND type = 'PACKAGE BODY'
   AND REGEXP_LIKE(text, '^\s*PROCEDURE\s+', 'i')
 ORDER BY line
 FETCH FIRST 30 ROWS ONLY;

PROMPT === DIAG 6 : DM_DNM_EDI_CALLOFF_ITEM 또는 SCM_ADM_USER 관련 division 함수/SP ===

SELECT owner, object_name, object_type
  FROM all_objects
 WHERE (object_name LIKE 'FN_%DIVISION%' OR object_name LIKE 'PR_%DIVISION%')
   AND object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE')
 ORDER BY owner, object_name
 FETCH FIRST 20 ROWS ONLY;

PROMPT === 판독 ===
PROMPT - DIAG 1 : SCMC owner 또는 다른 owner 에 있는지
PROMPT - DIAG 2 : DMF0008 + DIVISION 결합 객체
PROMPT - DIAG 3 : SCMD_APP synonym 미존재 = 별칭 누락
PROMPT - DIAG 4/5 : PKG_DMF0008 내부 procedure 인지
PROMPT - DIAG 6 : division 관련 다른 함수 (예: FN_GET_MY_DIVISION 등)
