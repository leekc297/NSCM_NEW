--==============================================================================
-- 016_DMF0008_GTT_DML_Grant.sql
--
-- 목적:
--   SCMD_APP 가 DMF0008 SP 의 GTT 에 SELECT 만 grant 받음.
--   SP body 의 INSERT (line 65, 122) / TRUNCATE (line 43-44) / SELECT (line 175, 178, 181)
--   호출 시 ORA-01031 / ORA-00942.
--
-- DIAG 5 결과: SELECT 만 grant. INSERT/UPDATE/DELETE 누락.
--
-- 처치: GTT 4종 (RESULT_TABLE_1 / 1_2 / 2 / 2_2) 에 SELECT/INSERT/UPDATE/DELETE GRANT.
--       추가 GTT (GT_DMF0008_*) 도 같이.
--       TRUNCATE 는 DDL — 별도 처치 (SP body 변경 권장).
--
-- 작성: 2026-06-05
--==============================================================================
SET SERVEROUTPUT ON
SET LINESIZE 200

PROMPT === BLOCK 1 : DMF0008 관련 GTT 전수 DML GRANT ===

DECLARE
  v_ok PLS_INTEGER := 0; v_skip PLS_INTEGER := 0; v_err PLS_INTEGER := 0;
  v_msg VARCHAR2(300);
BEGIN
  FOR r IN (
    SELECT table_name FROM all_tables
     WHERE owner = 'SCM_MGR'
       AND (table_name LIKE 'GT_GSSI_DMF0008%'
         OR table_name LIKE 'GT_DMF0008%')
       AND temporary = 'Y'
     ORDER BY table_name
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON SCM_MGR.' || r.table_name || ' TO SCMD_APP';
      v_ok := v_ok + 1;
      DBMS_OUTPUT.PUT_LINE(RPAD('[OK]', 8) || r.table_name);
    EXCEPTION WHEN OTHERS THEN
      v_msg := SUBSTR(SQLERRM, 1, 200);
      IF SQLCODE IN (-27486, -1031) THEN
        v_skip := v_skip + 1;
        DBMS_OUTPUT.PUT_LINE(RPAD('[SKIP]', 8) || r.table_name || ' — ' || v_msg);
      ELSE
        v_err := v_err + 1;
        DBMS_OUTPUT.PUT_LINE(RPAD('[ERR]', 8) || r.table_name || ' — ' || v_msg);
      END IF;
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('BLOCK 1: OK=' || v_ok || ' SKIP=' || v_skip || ' ERR=' || v_err);
END;
/

PROMPT === BLOCK 2 : 검증 — SCMD_APP 의 GTT grant 상태 (AFTER) ===

SELECT grantee, table_name, privilege
  FROM dba_tab_privs
 WHERE grantee = 'SCMD_APP'
   AND owner = 'SCM_MGR'
   AND (table_name LIKE 'GT_GSSI_DMF0008%' OR table_name LIKE 'GT_DMF0008%')
 ORDER BY table_name, privilege;

COMMIT;

PROMPT === 판독 ===
PROMPT - BLOCK 1: 8 GTT (4 GSSI + 4 GT_DMF0008) × 1 GRANT row 출력
PROMPT - BLOCK 2: 각 GTT 별 4 privilege (SELECT/INSERT/UPDATE/DELETE)
PROMPT - 적용 후 SP 재호출 — line 43 TRUNCATE 는 여전히 권한 없음 (DDL)
PROMPT - 다음 단계: SP body 의 TRUNCATE → DELETE 변환 (017 fix)
