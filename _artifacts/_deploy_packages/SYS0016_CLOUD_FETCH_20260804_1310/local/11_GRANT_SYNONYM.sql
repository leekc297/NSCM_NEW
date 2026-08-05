-- =============================================================================
-- 11_GRANT_SYNONYM.sql — 로컬(사내) 적용: DDL 적용 후 실행
-- SCMD_APP(BE 계정) EXECUTE GRANT + SYNONYM — hook scmd-app-grant-mandatory
-- 대상: UI 패턴 매칭 코드 객체 자동 (멱등 — SYNONYM -955 skip)
-- =============================================================================
DEFINE UI_ID = 'SYS0016'

SET SERVEROUTPUT ON
BEGIN
    FOR o IN (SELECT OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS
              WHERE OWNER = 'SCM_MGR'
              AND   OBJECT_TYPE IN ('PACKAGE','PROCEDURE','FUNCTION')
              AND   OBJECT_NAME LIKE '%&UI_ID%') LOOP
        EXECUTE IMMEDIATE 'GRANT EXECUTE ON SCM_MGR.' || o.OBJECT_NAME || ' TO SCMD_APP';
        BEGIN
            EXECUTE IMMEDIATE 'CREATE SYNONYM SCMD_APP.' || o.OBJECT_NAME || ' FOR SCM_MGR.' || o.OBJECT_NAME;
            DBMS_OUTPUT.PUT_LINE('GRANT+SYNONYM: ' || o.OBJECT_NAME);
        EXCEPTION WHEN OTHERS THEN
            IF SQLCODE = -955 THEN DBMS_OUTPUT.PUT_LINE('GRANT(SYNONYM 기존재): ' || o.OBJECT_NAME);
            ELSE RAISE; END IF;
        END;
    END LOOP;
END;
/
-- ⚠ 배선 SP 가 UI 패턴 명칭이 아니면(예: 공용 SCM0010_* 재사용) 아래 수동 추가:
-- GRANT EXECUTE ON SCM_MGR.<객체> TO SCMD_APP;  + SYNONYM (기존재 시 -955 skip)
