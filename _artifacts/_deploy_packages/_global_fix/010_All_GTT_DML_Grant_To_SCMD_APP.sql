--==============================================================================
-- 010_All_GTT_DML_Grant_To_SCMD_APP.sql
--
-- 목적:
--   SCM_MGR 의 모든 GTT (GT_*, GTT_*, V_TMPDEPT 등) 에 SCMD_APP 가
--   SELECT/INSERT/UPDATE/DELETE 권한을 한 번에 받도록 일괄 GRANT.
--
-- 배경:
--   210 audit 결과 1,114 GTT 중 대다수가 SELECT 만 grant 또는 grant 0.
--   To-Be 의 49 SP 가 TRUNCATE 사용 + 4 SP 가 DROP TABLE 사용 + 50+ SP 가
--   generic '오류가 발생했습니다' raise. NextSCM Pilot 변환기 일반 패턴.
--
-- 안전성:
--   - DML 권한만 GRANT (DDL TRUNCATE/DROP 권한은 별개)
--   - GTT 는 session 종료 시 자동 비워짐 → 다른 session 영향 없음
--   - 이미 SELECT 있는 GTT 는 SKIP (-27486)
--   - 이미 INSERT/UPDATE/DELETE 있는 GTT 도 SKIP
--
-- 후속 작업 (별도 분석):
--   - TRUNCATE → DELETE 변환 (49 SP) — 각 SP body recompile 필요
--   - generic EXCEPTION → SQLCODE/SQLERRM 포함 변환 (50+ SP)
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200

PROMPT === BLOCK 1 : SCM_MGR 의 모든 GTT 전수 DML GRANT (INSERT/UPDATE/DELETE) ===

DECLARE
  v_total PLS_INTEGER := 0;
  v_ok    PLS_INTEGER := 0;
  v_skip  PLS_INTEGER := 0;
  v_err   PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT table_name FROM all_tables
     WHERE owner = 'SCM_MGR'
       AND temporary = 'Y'
     ORDER BY table_name
  ) LOOP
    v_total := v_total + 1;
    BEGIN
      EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON SCM_MGR.' || r.table_name || ' TO SCMD_APP';
      v_ok := v_ok + 1;
    EXCEPTION WHEN OTHERS THEN
      IF SQLCODE IN (-27486, -1031) THEN
        v_skip := v_skip + 1;
      ELSE
        v_err := v_err + 1;
        DBMS_OUTPUT.PUT_LINE('[ERR] ' || r.table_name || ' — ' || SUBSTR(SQLERRM, 1, 100));
      END IF;
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('===');
  DBMS_OUTPUT.PUT_LINE('GTT 전수 GRANT 결과: TOTAL=' || v_total || ' / OK=' || v_ok || ' / SKIP=' || v_skip || ' / ERR=' || v_err);
END;
/

COMMIT;

PROMPT === BLOCK 2 : 검증 — INSERT/UPDATE/DELETE 누락 GTT 잔여 카운트 ===

WITH all_gtt AS (
  SELECT table_name FROM all_tables
   WHERE owner = 'SCM_MGR'
     AND temporary = 'Y'
),
scmd_app_grants AS (
  SELECT table_name,
         MAX(CASE WHEN privilege = 'INSERT' THEN 1 ELSE 0 END) AS has_ins,
         MAX(CASE WHEN privilege = 'UPDATE' THEN 1 ELSE 0 END) AS has_upd,
         MAX(CASE WHEN privilege = 'DELETE' THEN 1 ELSE 0 END) AS has_del
    FROM dba_tab_privs
   WHERE grantee = 'SCMD_APP'
     AND owner = 'SCM_MGR'
   GROUP BY table_name
)
SELECT COUNT(*) AS total_gtt,
       SUM(CASE WHEN NVL(g.has_ins, 0) = 0 THEN 1 ELSE 0 END) AS missing_insert,
       SUM(CASE WHEN NVL(g.has_upd, 0) = 0 THEN 1 ELSE 0 END) AS missing_update,
       SUM(CASE WHEN NVL(g.has_del, 0) = 0 THEN 1 ELSE 0 END) AS missing_delete
  FROM all_gtt a
  LEFT JOIN scmd_app_grants g ON g.table_name = a.table_name;

PROMPT === 판독 ===
PROMPT - BLOCK 1: TOTAL ≈ 1,114 / OK 대부분 / SKIP=0 / ERR=0 기대
PROMPT - BLOCK 2: missing_insert / missing_update / missing_delete 모두 0
PROMPT - 적용 후 DMF0008/DMF0082/DMF0035/PKG_DMF0008 등 모두 INSERT/DELETE 가능
PROMPT - 단, TRUNCATE 는 여전히 권한 없음 (DDL) — SP body 의 TRUNCATE → DELETE 변환 필요
