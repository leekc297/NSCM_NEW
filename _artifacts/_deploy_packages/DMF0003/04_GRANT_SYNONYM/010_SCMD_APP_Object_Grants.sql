/*=============================================================================================
 * File         : 010_SCMD_APP_Object_Grants.sql
 * Description  : SCM_MGR.DMF0003 객체에 SCMD_APP GRANT EXECUTE
 *===========================================================================================*/

BEGIN
    FOR rec IN (
        SELECT OBJECT_NAME, OBJECT_TYPE
        FROM ALL_OBJECTS
        WHERE OWNER = 'SCM_MGR'
          AND (OBJECT_NAME LIKE 'DMF0003%' OR OBJECT_NAME = 'PKG_DMF0003')
          AND OBJECT_TYPE IN ('PROCEDURE', 'PACKAGE', 'FUNCTION')
    ) LOOP
        EXECUTE IMMEDIATE 'GRANT EXECUTE ON SCM_MGR.' || rec.OBJECT_NAME || ' TO SCMD_APP';
        DBMS_OUTPUT.PUT_LINE('GRANT EXECUTE ON ' || rec.OBJECT_NAME || ' → SCMD_APP');
    END LOOP;
END;
/
