-- DMF0043 강제 재컴파일 + STATUS 검증 (8개 SQL 적용 후)
SET SERVEROUTPUT ON
WHENEVER SQLERROR CONTINUE

PROMPT === 1. DMF0043 객체 강제 ALTER COMPILE ===
BEGIN
  FOR rec IN (
    SELECT object_name, object_type
      FROM all_objects
     WHERE owner = 'SCM_MGR'
       AND (object_name LIKE 'DMF0043%' OR object_name = 'PKG_DMF0043')
       AND object_type IN ('PROCEDURE','PACKAGE','PACKAGE BODY')
     ORDER BY DECODE(object_type,'PACKAGE',1,'PACKAGE BODY',2,'PROCEDURE',3)
  ) LOOP
    BEGIN
      IF rec.object_type = 'PACKAGE BODY' THEN
        EXECUTE IMMEDIATE 'ALTER PACKAGE SCM_MGR.' || rec.object_name || ' COMPILE BODY';
      ELSIF rec.object_type = 'PACKAGE' THEN
        EXECUTE IMMEDIATE 'ALTER PACKAGE SCM_MGR.' || rec.object_name || ' COMPILE';
      ELSE
        EXECUTE IMMEDIATE 'ALTER PROCEDURE SCM_MGR.' || rec.object_name || ' COMPILE';
      END IF;
      DBMS_OUTPUT.PUT_LINE('  OK : ' || rec.object_type || ' ' || rec.object_name);
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('  ERR: ' || rec.object_type || ' ' || rec.object_name || ' — ' || SQLERRM);
    END;
  END LOOP;
END;
/

PROMPT === 2. 최종 STATUS ===
SELECT object_name, object_type, status,
       TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND (object_name LIKE 'DMF0043%' OR object_name = 'PKG_DMF0043')
 ORDER BY object_type, object_name;

PROMPT === 3. INVALID 객체의 컴파일 오류 ===
SELECT name, type, line, position, text
  FROM user_errors
 WHERE name LIKE 'DMF0043%' OR name = 'PKG_DMF0043'
 ORDER BY name, sequence;

PROMPT === 4. caller (DMF0043_GET_CONTRIBUTE_MAIN_DATA) 호출 검증 ===
DECLARE
  v_rc1 SYS_REFCURSOR;
  v_rc2 SYS_REFCURSOR;
  v_rc3 SYS_REFCURSOR;
BEGIN
  DMF0043_GET_CONTRIBUTE_MAIN_DATA('40','2026','ALL','minyonglee1','DMF0043','N',v_rc1,v_rc2,v_rc3);
  DBMS_OUTPUT.PUT_LINE('  caller OK — cursors opened');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('  caller ERR: ' || SQLCODE || ' / ' || SQLERRM);
  DBMS_OUTPUT.PUT_LINE('  backtrace: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/
