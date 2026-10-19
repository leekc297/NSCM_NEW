-- [E20261008-SLASHDEF] NULL 센티널 DEFAULT '-' -> '/' (1_DEFAULT 시트, 현재 '-' & 적용 '/' = 1916컬럼/262테이블). 데이터 변경 없음(메타만). 생성 2026-10-08 16:00
-- 적용 뒤 INVALID 객체 재컴파일 (SCM_MGR 소유 INVALID 전부, 2회 반복). DDL 로 무효화된 의존 PKG/PROC/VIEW 를 바로 되살린다.
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
    n PLS_INTEGER;
BEGIN
    FOR pass IN 1 .. 2 LOOP
        n := 0;
        FOR o IN (SELECT object_type, object_name FROM all_objects WHERE owner = 'SCM_MGR' AND status = 'INVALID' AND object_type IN ('PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION','VIEW','TRIGGER','TYPE','TYPE BODY') ORDER BY DECODE(object_type,'TYPE',1,'VIEW',2,'PACKAGE',3,'FUNCTION',4,'PROCEDURE',5,'PACKAGE BODY',6,'TYPE BODY',7,8), object_name) LOOP
            BEGIN
                EXECUTE IMMEDIATE 'ALTER ' || CASE o.object_type WHEN 'PACKAGE BODY' THEN 'PACKAGE' WHEN 'TYPE BODY' THEN 'TYPE' ELSE o.object_type END || ' SCM_MGR.' || o.object_name || ' COMPILE' || CASE o.object_type WHEN 'PACKAGE BODY' THEN ' BODY' WHEN 'TYPE BODY' THEN ' BODY' END;
                n := n + 1;
            EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('COMPILE FAIL | ' || o.object_type || ' ' || o.object_name || ' | ' || SQLERRM);
            END;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('pass ' || pass || ' compiled=' || n);
    END LOOP;
    SELECT COUNT(*) INTO n FROM all_objects WHERE owner = 'SCM_MGR' AND status = 'INVALID';
    DBMS_OUTPUT.PUT_LINE('remaining INVALID=' || n || ' (적용 전부터 INVALID 였던 객체는 본 작업과 무관 — 원인 분류는 06_CLOUD_INVALID_DIAG.sql · 사내 기준선 48 → 최종 5)');
END;
/
