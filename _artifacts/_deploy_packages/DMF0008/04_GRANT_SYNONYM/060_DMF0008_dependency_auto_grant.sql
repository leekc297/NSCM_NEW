--==============================================================================
-- 060_DMF0008_dependency_auto_grant.sql
--
-- DMF0008 Status Update / UpdateHistory SP 의존 객체 자동 추출 + 일괄 GRANT/SYNONYM
-- =============================================================================
-- 작성: 2026-06-17 (050 file 적용 후에도 동일 -9994 사고 — Network: STATUS_UPDATE + updateHistory 500)
--
-- 정밀 진단 전략:
--   1) ALL_DEPENDENCIES 로 SP 가 참조하는 모든 객체 자동 추출 (SCM_SYS_LOG_BATCH 추측 회피)
--   2) ALL_SOURCE 에서 SP body 의 FROM/INSERT/UPDATE/DELETE 라인 직접 grep
--   3) 추출된 모든 객체에 SCMD_APP GRANT + SYNONYM 자동 적용
--   4) SCMD_APP 로 connect 한 후 SP 단독 호출 가이드
--
-- 핵심 가설: SP body 가 SCM_SYS_LOG_BATCH 외 다른 테이블도 참조하지만 SCMD_APP 권한 누락.
--==============================================================================

SET LINESIZE 250
SET PAGESIZE 200
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === DIAG 1 : SP 들이 참조하는 모든 객체 (ALL_DEPENDENCIES 자동 추출) ===

SELECT name AS sp_name, referenced_owner, referenced_name, referenced_type
  FROM all_dependencies
 WHERE owner = 'SCM_MGR'
   AND name IN ('DMF0008_GET_UPDATE_HISTORY', 'DMF0000_GET_UPDATE_HISTORY',
                'PR_DM_DNM_EDI_CALLOFF_STATUS')
   AND referenced_type IN ('TABLE', 'VIEW', 'PROCEDURE', 'FUNCTION', 'PACKAGE', 'SYNONYM')
 ORDER BY name, referenced_type, referenced_name;

PROMPT === DIAG 2 : SP body 의 FROM/INSERT/UPDATE/DELETE 라인 (참조 명칭 직접 확인) ===

SELECT name AS sp_name, line,
       SUBSTR(REGEXP_REPLACE(text, '\s+', ' '), 1, 200) AS text_trimmed
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name IN ('DMF0008_GET_UPDATE_HISTORY', 'DMF0000_GET_UPDATE_HISTORY',
                'PR_DM_DNM_EDI_CALLOFF_STATUS')
   AND (UPPER(text) LIKE '%FROM %'
        OR UPPER(text) LIKE '%INSERT INTO%'
        OR UPPER(text) LIKE '%UPDATE %'
        OR UPPER(text) LIKE '%DELETE FROM%'
        OR UPPER(text) LIKE '%MERGE INTO%')
 ORDER BY name, line;

PROMPT === DIAG 3 : 현재 SCMD_APP 권한 상태 (의존 객체별) ===

WITH DEPS AS (
  SELECT DISTINCT referenced_name AS obj_name, referenced_type AS obj_type
    FROM all_dependencies
   WHERE owner = 'SCM_MGR'
     AND name IN ('DMF0008_GET_UPDATE_HISTORY', 'DMF0000_GET_UPDATE_HISTORY',
                  'PR_DM_DNM_EDI_CALLOFF_STATUS')
     AND referenced_owner = 'SCM_MGR'
     AND referenced_type IN ('TABLE', 'VIEW', 'PROCEDURE', 'FUNCTION', 'PACKAGE')
)
SELECT d.obj_name, d.obj_type,
       (SELECT LISTAGG(privilege, ',') WITHIN GROUP (ORDER BY privilege)
          FROM all_tab_privs
         WHERE grantor='SCM_MGR' AND grantee='SCMD_APP' AND table_name=d.obj_name) AS scmd_privs,
       (SELECT COUNT(*) FROM all_synonyms s
         WHERE s.owner='SCMD_APP' AND s.synonym_name=d.obj_name) AS scmd_syn_cnt
  FROM DEPS d
 ORDER BY d.obj_type, d.obj_name;

PROMPT ============================================================
PROMPT === FIX 1 : 의존 객체 일괄 GRANT (TABLE/VIEW=ALL DML, SP/PKG=EXECUTE) ===
PROMPT ============================================================

DECLARE
  v_ok_grant   PLS_INTEGER := 0;
  v_skip_grant PLS_INTEGER := 0;
  v_err_grant  PLS_INTEGER := 0;
  v_ok_syn     PLS_INTEGER := 0;
  v_skip_syn   PLS_INTEGER := 0;
  v_err_syn    PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT DISTINCT referenced_name AS obj_name, referenced_type AS obj_type
      FROM all_dependencies
     WHERE owner = 'SCM_MGR'
       AND name IN ('DMF0008_GET_UPDATE_HISTORY', 'DMF0000_GET_UPDATE_HISTORY',
                    'PR_DM_DNM_EDI_CALLOFF_STATUS')
       AND referenced_owner = 'SCM_MGR'
       AND referenced_type IN ('TABLE', 'VIEW', 'PROCEDURE', 'FUNCTION', 'PACKAGE')
  ) LOOP
    -- GRANT
    BEGIN
      IF r.obj_type IN ('TABLE', 'VIEW') THEN
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON SCM_MGR.' || r.obj_name || ' TO SCMD_APP';
      ELSE
        EXECUTE IMMEDIATE 'GRANT EXECUTE ON SCM_MGR.' || r.obj_name || ' TO SCMD_APP';
      END IF;
      v_ok_grant := v_ok_grant + 1;
      DBMS_OUTPUT.PUT_LINE(RPAD('[GRANT OK]', 14) || RPAD(r.obj_type, 12) || r.obj_name);
    EXCEPTION WHEN OTHERS THEN
      IF SQLCODE IN (-1031, -27486) THEN
        v_skip_grant := v_skip_grant + 1;
      ELSE
        v_err_grant := v_err_grant + 1;
        DBMS_OUTPUT.PUT_LINE(RPAD('[GRANT ERR]', 14) || r.obj_name || ' / ' || SQLERRM);
      END IF;
    END;
    -- SYNONYM
    BEGIN
      EXECUTE IMMEDIATE 'CREATE SYNONYM SCMD_APP.' || r.obj_name || ' FOR SCM_MGR.' || r.obj_name;
      v_ok_syn := v_ok_syn + 1;
      DBMS_OUTPUT.PUT_LINE(RPAD('[SYN OK]', 14) || RPAD(r.obj_type, 12) || r.obj_name);
    EXCEPTION WHEN OTHERS THEN
      IF SQLCODE = -955 THEN  -- ORA-00955 already exists
        v_skip_syn := v_skip_syn + 1;
      ELSE
        v_err_syn := v_err_syn + 1;
        DBMS_OUTPUT.PUT_LINE(RPAD('[SYN ERR]', 14) || r.obj_name || ' / ' || SQLERRM);
      END IF;
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('FIX 1 GRANT:   OK=' || v_ok_grant || ' SKIP=' || v_skip_grant || ' ERR=' || v_err_grant);
  DBMS_OUTPUT.PUT_LINE('FIX 1 SYNONYM: OK=' || v_ok_syn || ' SKIP=' || v_skip_syn || ' ERR=' || v_err_syn);
END;
/

PROMPT === FIX 2 : SP 자체 + PKG 의 EXECUTE GRANT 보강 (이미 010 file 적용했지만 재확인) ===

DECLARE
  v_ok PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT object_name FROM all_objects
     WHERE owner='SCM_MGR'
       AND object_name IN ('DMF0008_GET_UPDATE_HISTORY', 'DMF0000_GET_UPDATE_HISTORY',
                           'PR_DM_DNM_EDI_CALLOFF_STATUS')
       AND object_type='PROCEDURE'
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'GRANT EXECUTE ON SCM_MGR.' || r.object_name || ' TO SCMD_APP';
      v_ok := v_ok + 1;
    EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN
      EXECUTE IMMEDIATE 'CREATE SYNONYM SCMD_APP.' || r.object_name || ' FOR SCM_MGR.' || r.object_name;
    EXCEPTION WHEN OTHERS THEN NULL; END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('FIX 2 SP GRANT: OK=' || v_ok);
END;
/

COMMIT;

PROMPT === POST-CHECK : 의존 객체 SCMD_APP 권한 + SYNONYM 재인벤토리 ===

WITH DEPS AS (
  SELECT DISTINCT referenced_name AS obj_name, referenced_type AS obj_type
    FROM all_dependencies
   WHERE owner = 'SCM_MGR'
     AND name IN ('DMF0008_GET_UPDATE_HISTORY', 'DMF0000_GET_UPDATE_HISTORY',
                  'PR_DM_DNM_EDI_CALLOFF_STATUS')
     AND referenced_owner = 'SCM_MGR'
     AND referenced_type IN ('TABLE', 'VIEW', 'PROCEDURE', 'FUNCTION', 'PACKAGE')
)
SELECT d.obj_name, d.obj_type,
       (SELECT LISTAGG(privilege, ',') WITHIN GROUP (ORDER BY privilege)
          FROM all_tab_privs
         WHERE grantor='SCM_MGR' AND grantee='SCMD_APP' AND table_name=d.obj_name) AS scmd_privs,
       (SELECT COUNT(*) FROM all_synonyms s
         WHERE s.owner='SCMD_APP' AND s.synonym_name=d.obj_name) AS scmd_syn_cnt
  FROM DEPS d
 ORDER BY d.obj_type, d.obj_name;

PROMPT === DIAG 4 : SCMD_APP 로 SP 호출 (BE 와 동일 권한 시뮬레이션) ===
PROMPT ====================================================================
PROMPT  본 진단은 SCMD_APP 사용자로 별도 connect 후 실행 (현 세션이 SCM_MGR 이면 무의미).
PROMPT
PROMPT  -- SCMD_APP 로 connect 후 실행:
PROMPT  DECLARE
PROMPT    v_rc1 SYS_REFCURSOR;
PROMPT    v_rrc SYS_REFCURSOR;
PROMPT  BEGIN
PROMPT    SCMD_APP.DMF0000_GET_UPDATE_HISTORY(v_rc1, v_rrc);
PROMPT    DBMS_OUTPUT.PUT_LINE('SCMD_APP 호출 OK');
PROMPT    CLOSE v_rc1; CLOSE v_rrc;
PROMPT  EXCEPTION WHEN OTHERS THEN
PROMPT    DBMS_OUTPUT.PUT_LINE('ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 300));
PROMPT    DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
PROMPT  END;
PROMPT  /
PROMPT
PROMPT  → ORA-XXXXX 코드가 BE 가 -9994 로 변환하기 전 실제 원인.
PROMPT ====================================================================

PROMPT === 060_DMF0008_dependency_auto_grant.sql 완료 ===

--==============================================================================
-- 적용 후:
--   1) DIAG 1/2 출력에서 SP 가 참조하는 실제 테이블 명칭 확인 (SCM_SYS_LOG_BATCH 인지 다른 이름인지)
--   2) FIX 1 의 OK 카운트 확인
--   3) POST-CHECK 에서 모든 의존 객체에 SCMD_APP 권한 + SYNONYM 존재 확인
--   4) DIAG 4 가이드대로 SCMD_APP connect 후 SP 단독 호출 — ORA-XXXXX 메시지 확보
--==============================================================================
