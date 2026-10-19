/* 13 — 본체 컴파일 확인 + 의존 객체 재컴파일 (사내 의존 0) */
ALTER PROCEDURE SCM_MGR.PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING COMPILE;
SELECT object_name, object_type, status FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING';
SELECT line, position, text FROM all_errors WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' ORDER BY sequence;
BEGIN
  FOR r IN (SELECT owner, name, type FROM all_dependencies WHERE referenced_owner = 'SCM_MGR' AND referenced_name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND owner = 'SCM_MGR') LOOP
    BEGIN EXECUTE IMMEDIATE 'ALTER ' || CASE r.type WHEN 'PACKAGE BODY' THEN 'PACKAGE' ELSE r.type END || ' SCM_MGR.' || r.name || ' COMPILE' || CASE r.type WHEN 'PACKAGE BODY' THEN ' BODY' END; EXCEPTION WHEN OTHERS THEN NULL; END;
  END LOOP;
END;
/
