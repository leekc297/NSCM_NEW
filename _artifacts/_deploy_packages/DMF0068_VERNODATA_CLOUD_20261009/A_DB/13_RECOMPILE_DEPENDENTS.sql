/* 13 — 본체 컴파일 확인 + 의존 객체 재컴파일 (사내 의존 = 없음) */
ALTER PACKAGE SCM_MGR.PKG_DMF0068 COMPILE BODY;
SELECT object_name, object_type, status FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = 'PKG_DMF0068';
SELECT line, position, text FROM all_errors WHERE owner = 'SCM_MGR' AND name = 'PKG_DMF0068' ORDER BY sequence;
BEGIN
  FOR r IN (SELECT owner, name, type FROM all_dependencies WHERE referenced_owner = 'SCM_MGR' AND referenced_name = 'PKG_DMF0068' AND owner = 'SCM_MGR' AND name <> 'PKG_DMF0068') LOOP
    BEGIN EXECUTE IMMEDIATE 'ALTER ' || CASE r.type WHEN 'PACKAGE BODY' THEN 'PACKAGE' ELSE r.type END || ' SCM_MGR.' || r.name || ' COMPILE' || CASE r.type WHEN 'PACKAGE BODY' THEN ' BODY' END; EXCEPTION WHEN OTHERS THEN NULL; END;
  END LOOP;
END;
/
