-- SOURCE-FRESH: SCM_MGR 화면 SCP0111 객체·META (DB=ZIOUI1 SERVER_HOST=localhost) FETCHED=2026-11-19 13:38:37
/* 40_GRANT — 화면 객체 권한·앱 계정 시노님 (사내 실측 그대로 · 멱등)
 * 패키지 SCP0111_CLOUD_DB_MOD_20261119_1338 · 생성 tools/CloudPkg/cloud_pkg.py 1.4.1 · 2026-11-19 13:38
 * 실행 계정 = SCM_MGR (전체 F5 · 반복 실행 안전)
 */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
    c_dry CONSTANT BOOLEAN := FALSE;
    PROCEDURE g(p_obj VARCHAR2, p_to VARCHAR2, p_privs VARCHAR2) IS n PLS_INTEGER;
    BEGIN
        SELECT COUNT(*) INTO n FROM USER_OBJECTS WHERE OBJECT_NAME = p_obj;
        IF n = 0 THEN DBMS_OUTPUT.PUT_LINE('SKIP    ' || p_obj || ' 없음'); RETURN; END IF;
        IF NOT c_dry THEN EXECUTE IMMEDIATE 'GRANT ' || p_privs || ' ON ' || p_obj || ' TO ' || p_to; END IF;
        DBMS_OUTPUT.PUT_LINE('GRANT   ' || p_privs || ' ON ' || p_obj || ' TO ' || p_to);
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE IN (-1917, -1919) THEN DBMS_OUTPUT.PUT_LINE('  WARN  ' || p_to || ' 없음 — ' || p_obj);
        ELSE RAISE; END IF;
    END;
    PROCEDURE s(p_owner VARCHAR2, p_syn VARCHAR2, p_obj VARCHAR2) IS n PLS_INTEGER;
    BEGIN
        SELECT COUNT(*) INTO n FROM ALL_SYNONYMS WHERE OWNER = p_owner AND SYNONYM_NAME = p_syn AND TABLE_OWNER = 'SCM_MGR' AND TABLE_NAME = p_obj;
        IF n > 0 THEN RETURN; END IF;
        IF NOT c_dry THEN EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM ' || p_owner || '.' || p_syn || ' FOR SCM_MGR.' || p_obj; END IF;
        DBMS_OUTPUT.PUT_LINE('SYNONYM ' || p_owner || '.' || p_syn || ' -> SCM_MGR.' || p_obj);
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE = -1031 THEN DBMS_OUTPUT.PUT_LINE('  WARN  권한 부족(CREATE ANY SYNONYM) — ' || p_owner || '.' || p_syn || ' 는 system 계정으로');
        ELSIF SQLCODE = -1917 THEN DBMS_OUTPUT.PUT_LINE('  WARN  사용자 ' || p_owner || ' 없음');
        ELSE RAISE; END IF;
    END;
BEGIN
    g('PKG_SCP0111', 'RL_SCM_SEL', 'EXECUTE');
    s('SCMP_APP', 'PKG_SCP0111', 'PKG_SCP0111');
END;
/
