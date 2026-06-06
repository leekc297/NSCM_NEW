--==============================================================================
-- 020_GTT_DMF0043_CHECK.sql
--
-- 목적: DMF0043 SP 가 사용하는 7개 GTT 가 SCM_MGR 에 존재하는지 확인 (READ-ONLY)
-- 실행: SCM_MGR 또는 SCMD_APP 세션
-- 작성: 2026-06-04
--
-- GTT 인벤토리 (DMF0043_GET_CONTRIBUTE_MAIN_DATA / SAVE 본문에서 추출):
--   1. GT_DMF0043_TITLE         — DMF0043_GET_MAIN_SPREAD_TITLE 적재
--   2. GT_DMF0043_TEMP          — 메인 데이터 1단계
--   3. GT_DMF0043_TEMP2         — DISCARD 처리 후 (p_dis='ALL')
--   4. GT_DMF0043_TEMP3         — 최종 PIVOT 직전
--   5. GT_DMF0043_MASTER_LIST   — p_his='Y' 분기 master 목록
--   6. GT_DMF0043_TEMP_LIST     — p_his='Y' 분기 temp list
--   7. GT_DMF0043_DATA_TABLE    — DM_MST_CONTRIBUTE_RATIO_DTL JOIN 결과
--==============================================================================
SET LINESIZE 200
SET PAGESIZE 100
SET SERVEROUTPUT ON

PROMPT === DIAG 1 : DMF0043 GTT 7개 존재 확인 ===

SELECT table_name, temporary, duration, tablespace_name
  FROM all_tables
 WHERE owner = 'SCM_MGR'
   AND table_name IN (
     'GT_DMF0043_TITLE',
     'GT_DMF0043_TEMP',
     'GT_DMF0043_TEMP2',
     'GT_DMF0043_TEMP3',
     'GT_DMF0043_MASTER_LIST',
     'GT_DMF0043_TEMP_LIST',
     'GT_DMF0043_DATA_TABLE'
   )
 ORDER BY table_name;

PROMPT === DIAG 2 : 누락 GTT 식별 ===

WITH expected AS (
  SELECT 'GT_DMF0043_TITLE'         AS table_name FROM DUAL UNION ALL
  SELECT 'GT_DMF0043_TEMP'                        FROM DUAL UNION ALL
  SELECT 'GT_DMF0043_TEMP2'                       FROM DUAL UNION ALL
  SELECT 'GT_DMF0043_TEMP3'                       FROM DUAL UNION ALL
  SELECT 'GT_DMF0043_MASTER_LIST'                 FROM DUAL UNION ALL
  SELECT 'GT_DMF0043_TEMP_LIST'                   FROM DUAL UNION ALL
  SELECT 'GT_DMF0043_DATA_TABLE'                  FROM DUAL
)
SELECT e.table_name AS MISSING_GTT,
       'CLOUD 에 없음 — SCM_MGR 권한으로 CREATE GLOBAL TEMPORARY TABLE 필요' AS RESOLUTION
  FROM expected e
 WHERE NOT EXISTS (
   SELECT 1 FROM all_tables a
    WHERE a.owner = 'SCM_MGR' AND a.table_name = e.table_name
 );

PROMPT === DIAG 3 : GTT 의 SCMD_APP 권한 (SELECT/INSERT/DELETE 가 있어야 SP 정상 실행) ===

SELECT table_name, grantee, privilege, grantor
  FROM all_tab_privs
 WHERE table_schema = 'SCM_MGR'
   AND table_name LIKE 'GT_DMF0043_%'
   AND grantee = 'SCMD_APP'
 ORDER BY table_name, privilege;

PROMPT === DIAG 4 : GTT 컬럼 인벤토리 (특히 GT_DMF0043_TITLE 22 컬럼인지) ===

SELECT table_name, column_name, data_type, data_length, nullable
  FROM all_tab_columns
 WHERE owner = 'SCM_MGR'
   AND table_name = 'GT_DMF0043_TITLE'
 ORDER BY column_id;

PROMPT === 판독 ===
PROMPT - DIAG 1 7 row + TEMPORARY=Y 모두 → 진행 OK
PROMPT - DIAG 2 결과 row 있음 → 누락 GTT. SP 본문 INSERT INTO 시 ORA-00942 폭발
PROMPT - DIAG 3 결과 0 row → SCMD_APP 가 GTT 사용 불가. 04_GRANT_SYNONYM/010 실행 필요
PROMPT - DIAG 4 GT_DMF0043_TITLE 컬럼 수 22 인지 확인 (caller FETCH 22 변수와 매칭)
