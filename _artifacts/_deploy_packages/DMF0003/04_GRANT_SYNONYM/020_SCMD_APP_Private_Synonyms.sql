/*=============================================================================================
 * File         : 020_SCMD_APP_Private_Synonyms.sql
 * Description  : SCMD_APP 에 SCM_MGR.DMF0003 객체별 private synonym 생성
 *              :   ★ SCMD_APP 계정으로 직접 실행 (또는 EXECUTE IMMEDIATE)
 *===========================================================================================*/

BEGIN
    FOR rec IN (
        SELECT OBJECT_NAME
        FROM ALL_OBJECTS
        WHERE OWNER = 'SCM_MGR'
          AND (OBJECT_NAME LIKE 'DMF0003%' OR OBJECT_NAME = 'PKG_DMF0003')
          AND OBJECT_TYPE IN ('PROCEDURE', 'PACKAGE')
    ) LOOP
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM SCMD_APP.' || rec.OBJECT_NAME ||
                              ' FOR SCM_MGR.' || rec.OBJECT_NAME;
            DBMS_OUTPUT.PUT_LINE('SYNONYM ' || rec.OBJECT_NAME || ' → SCM_MGR.' || rec.OBJECT_NAME);
        EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('SKIP ' || rec.OBJECT_NAME || ': ' || SQLERRM);
        END;
    END LOOP;
END;
/
