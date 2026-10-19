/* 98 ROLLBACK — 05 가 보관한 클라우드 원문으로 복원 (적용 전 판으로 되돌림) */
DECLARE v CLOB; BEGIN
  DBMS_LOB.CREATETEMPORARY(v, TRUE);
  FOR r IN (SELECT text FROM SCM_MGR.BAK_SRC_DMF0068_VERNODATA WHERE type = 'PACKAGE BODY' ORDER BY line) LOOP DBMS_LOB.WRITEAPPEND(v, LENGTH(r.text), r.text); END LOOP;
  EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v;
END;
/
SELECT object_name, status, TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = 'PKG_DMF0068' AND object_type = 'PACKAGE BODY';
