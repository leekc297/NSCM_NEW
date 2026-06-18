--==============================================================================
-- 050_DMF0008_full_chain_diagnose_fix.sql
--
-- DMF0008 조회/Status Update 전체 chain 진단 + GRANT/SYNONYM 보강
-- =============================================================================
-- 작성: 2026-06-17 (-9994 "Sql Error" 사고 후 사용자 명시 "조회 및 Status Update 전체 확인")
--
-- BE 응답 -9994 → 메모리 `feedback_scmd_app_grant_mandatory.md` 90% root cause = GRANT/SYNONYM 누락.
-- 진단 결과 발견: 010 file 의 BLOCK 3 마스터 테이블 인벤토리에 `SCM_SYS_LOG_BATCH` 누락.
--   DMF0000_GET_UPDATE_HISTORY body line 56-77 = FROM SCM_SYS_LOG_BATCH
--   PR_DM_DNM_EDI_CALLOFF_STATUS body 가 SCM_SYS_LOG_BATCH INSERT (Status Update 시 log 기록)
--   → SCMD_APP 사용자의 SCM_SYS_LOG_BATCH 권한 없음 → ORA-00942 → -9994
--
-- 진단 8 블록 + 보강 4 블록.
--==============================================================================

SET LINESIZE 250
SET PAGESIZE 200
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === DIAG 1 : DMF0008 SP 상태 (VALID/INVALID) ===

SELECT object_name, object_type, status,
       TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND (object_name LIKE 'DMF0008_%'
        OR object_name IN ('DMF0000_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS', 'PKG_DMF0008'))
   AND object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY')
 ORDER BY object_name, object_type;

PROMPT === DIAG 2 : INVALID SP 의 컴파일 오류 ===

SELECT name, type, line, position, text
  FROM all_errors
 WHERE owner = 'SCM_MGR'
   AND (name LIKE 'DMF0008_%'
        OR name IN ('DMF0000_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS', 'PKG_DMF0008'))
 ORDER BY name, sequence
 FETCH FIRST 30 ROWS ONLY;

PROMPT === DIAG 3 : SCMD_APP 의 DMF0008 SP EXECUTE 권한 ===

SELECT table_name AS object_name, privilege, grantee
  FROM all_tab_privs
 WHERE grantor = 'SCM_MGR' AND grantee = 'SCMD_APP'
   AND (table_name LIKE 'DMF0008_%'
        OR table_name IN ('DMF0000_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS', 'PKG_DMF0008'))
 ORDER BY table_name, privilege;

PROMPT === DIAG 4 : SCMD_APP SYNONYM 존재 여부 ===

SELECT synonym_name, table_owner, table_name
  FROM all_synonyms
 WHERE owner = 'SCMD_APP'
   AND (synonym_name LIKE 'DMF0008_%'
        OR synonym_name IN ('DMF0000_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS', 'PKG_DMF0008',
                            'SCM_SYS_LOG_BATCH'))
 ORDER BY synonym_name;

PROMPT === DIAG 5 : 핵심 테이블 SCM_SYS_LOG_BATCH 의 SCMD_APP 권한 (⭐ 의심 1순위) ===

SELECT table_name, privilege, grantee
  FROM all_tab_privs
 WHERE grantor = 'SCM_MGR' AND grantee = 'SCMD_APP'
   AND table_name = 'SCM_SYS_LOG_BATCH';

-- table 존재 여부
SELECT owner, table_name
  FROM all_tables
 WHERE table_name = 'SCM_SYS_LOG_BATCH';

PROMPT === DIAG 6 : DMF0008/{summary,repair,salesSite,sspm,updateHistory,main}/* chain (BTN→API→PROC→SP) ===

SELECT BTN.SHT_NM, BTN.MNU_BTN_CD, BTN.API_ID,
       API.API_URL AS PROC_NM,
       (SELECT status FROM all_objects o
         WHERE o.owner='SCM_MGR' AND o.object_name=API.API_URL AND o.object_type='PROCEDURE'
           AND ROWNUM=1) AS SP_STATUS,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M P WHERE P.PROC_NM = API.API_URL) AS PROC_M_CNT,
       (SELECT COUNT(*) FROM all_tab_privs
         WHERE grantor='SCM_MGR' AND grantee='SCMD_APP' AND table_name=API.API_URL AND privilege='EXECUTE') AS SCMD_GRANT,
       (SELECT COUNT(*) FROM all_synonyms
         WHERE owner='SCMD_APP' AND synonym_name=API.API_URL) AS SCMD_SYN
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
  LEFT JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID = BTN.API_ID
 WHERE BTN.MNU_ID = 'DMF0008'
 ORDER BY BTN.SHT_NM, BTN.MNU_BTN_CD;

PROMPT === DIAG 7 : DMF0000_GET_UPDATE_HISTORY 단독 호출 (BE 우회) ===

DECLARE
  v_rc1   SYS_REFCURSOR;
  v_rrc   SYS_REFCURSOR;
  v_sdate VARCHAR2(30); v_edate VARCHAR2(30); v_by VARCHAR2(100);
BEGIN
  SCM_MGR.DMF0000_GET_UPDATE_HISTORY(v_rc1, v_rrc);
  FETCH v_rc1 INTO v_sdate, v_edate, v_by;
  DBMS_OUTPUT.PUT_LINE('SDATE=' || NVL(v_sdate, 'NULL') ||
                       ' EDATE=' || NVL(v_edate, 'NULL') ||
                       ' BY=' || NVL(v_by, 'NULL'));
  CLOSE v_rc1; CLOSE v_rrc;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 200));
END;
/

PROMPT === DIAG 8 : SCM_SYS_LOG_BATCH 의 PR_DM_DNM_EDI_CALLOFF_STATUS 로그 존재 여부 ===

SELECT LOG_TYPE, COUNT(*) AS CNT,
       TO_CHAR(MAX(LAST_UPDATE_DATE), 'YYYY-MM-DD HH24:MI:SS') AS LAST_DT
  FROM SCM_MGR.SCM_SYS_LOG_BATCH
 WHERE PROGRAM_NAME = 'PR_DM_DNM_EDI_CALLOFF_STATUS'
 GROUP BY LOG_TYPE
 ORDER BY LOG_TYPE;

PROMPT ============================================================
PROMPT === 진단 완료. 아래 보강 BLOCK 자동 실행 ===
PROMPT ============================================================

PROMPT === FIX 1 : SCM_SYS_LOG_BATCH SELECT/INSERT/UPDATE GRANT to SCMD_APP ===

DECLARE
  v_cnt PLS_INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM all_tables
   WHERE owner='SCM_MGR' AND table_name='SCM_SYS_LOG_BATCH';

  IF v_cnt > 0 THEN
    BEGIN EXECUTE IMMEDIATE 'GRANT SELECT ON SCM_MGR.SCM_SYS_LOG_BATCH TO SCMD_APP';
      DBMS_OUTPUT.PUT_LINE('[OK]  GRANT SELECT SCM_SYS_LOG_BATCH');
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[ERR] SELECT ' || SQLERRM); END;
    BEGIN EXECUTE IMMEDIATE 'GRANT INSERT ON SCM_MGR.SCM_SYS_LOG_BATCH TO SCMD_APP';
      DBMS_OUTPUT.PUT_LINE('[OK]  GRANT INSERT SCM_SYS_LOG_BATCH');
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[ERR] INSERT ' || SQLERRM); END;
    BEGIN EXECUTE IMMEDIATE 'GRANT UPDATE ON SCM_MGR.SCM_SYS_LOG_BATCH TO SCMD_APP';
      DBMS_OUTPUT.PUT_LINE('[OK]  GRANT UPDATE SCM_SYS_LOG_BATCH');
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[ERR] UPDATE ' || SQLERRM); END;
  ELSE
    DBMS_OUTPUT.PUT_LINE('[SKIP] SCM_SYS_LOG_BATCH 테이블 미존재 (사내 별도 owner?)');
  END IF;
END;
/

PROMPT === FIX 2 : SCM_SYS_LOG_BATCH SYNONYM for SCMD_APP ===

DECLARE
  v_cnt PLS_INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM all_synonyms
   WHERE owner='SCMD_APP' AND synonym_name='SCM_SYS_LOG_BATCH';

  IF v_cnt = 0 THEN
    BEGIN
      EXECUTE IMMEDIATE 'CREATE SYNONYM SCMD_APP.SCM_SYS_LOG_BATCH FOR SCM_MGR.SCM_SYS_LOG_BATCH';
      DBMS_OUTPUT.PUT_LINE('[OK] CREATE SYNONYM SCM_SYS_LOG_BATCH');
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERR] SYNONYM ' || SQLERRM);
    END;
  ELSE
    DBMS_OUTPUT.PUT_LINE('[SKIP] SCM_SYS_LOG_BATCH SYNONYM 이미 존재');
  END IF;
END;
/

PROMPT === FIX 3 : DMF0008 + 공용 SP 전체 EXECUTE GRANT 재적용 (010 file 의 BLOCK 1 보강) ===

DECLARE
  v_ok PLS_INTEGER := 0; v_skip PLS_INTEGER := 0; v_err PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT object_name, object_type FROM all_objects
     WHERE owner = 'SCM_MGR'
       AND (object_name LIKE 'DMF0008_%'
            OR object_name IN ('DMF0000_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS',
                               'UF_FX_STRING_SPLIT', 'PKG_SCM_USER_MNU', 'PR_SCM_SYS_LOG_BATCH',
                               'PKG_DMF0008'))
       AND object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE')
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'GRANT EXECUTE ON SCM_MGR.' || r.object_name || ' TO SCMD_APP';
      v_ok := v_ok + 1;
    EXCEPTION WHEN OTHERS THEN
      IF SQLCODE IN (-27486, -1031) THEN v_skip := v_skip + 1; ELSE v_err := v_err + 1; END IF;
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('FIX 3: OK=' || v_ok || ' SKIP=' || v_skip || ' ERR=' || v_err);
END;
/

PROMPT === FIX 4 : SCMD_APP SYNONYM 전체 재적용 (020 file 의 보강) ===

DECLARE
  v_ok PLS_INTEGER := 0; v_skip PLS_INTEGER := 0; v_err PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT object_name FROM all_objects
     WHERE owner = 'SCM_MGR'
       AND (object_name LIKE 'DMF0008_%'
            OR object_name IN ('DMF0000_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS',
                               'UF_FX_STRING_SPLIT', 'PKG_SCM_USER_MNU', 'PR_SCM_SYS_LOG_BATCH',
                               'PKG_DMF0008'))
       AND object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE')
       AND NOT EXISTS (
         SELECT 1 FROM all_synonyms s
          WHERE s.owner='SCMD_APP' AND s.synonym_name=all_objects.object_name
       )
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'CREATE SYNONYM SCMD_APP.' || r.object_name || ' FOR SCM_MGR.' || r.object_name;
      v_ok := v_ok + 1;
    EXCEPTION WHEN OTHERS THEN
      IF SQLCODE = -955 THEN v_skip := v_skip + 1; ELSE v_err := v_err + 1; END IF;
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('FIX 4 SYNONYM: OK=' || v_ok || ' SKIP=' || v_skip || ' ERR=' || v_err);
END;
/

COMMIT;

PROMPT === POST-CHECK : SCMD_APP DMF0008 권한 + SYNONYM 인벤토리 ===

SELECT 'GRANT' AS KIND, table_name AS object_name, privilege
  FROM all_tab_privs
 WHERE grantor='SCM_MGR' AND grantee='SCMD_APP'
   AND (table_name LIKE 'DMF0008_%'
        OR table_name IN ('DMF0000_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS',
                          'PKG_DMF0008', 'SCM_SYS_LOG_BATCH'))
UNION ALL
SELECT 'SYNONYM', synonym_name, table_owner || '.' || table_name
  FROM all_synonyms
 WHERE owner='SCMD_APP'
   AND (synonym_name LIKE 'DMF0008_%'
        OR synonym_name IN ('DMF0000_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS',
                            'PKG_DMF0008', 'SCM_SYS_LOG_BATCH'))
 ORDER BY KIND, object_name;

PROMPT === 050_DMF0008_full_chain_diagnose_fix.sql 완료 ===
