-- 99_ROLLBACK_2_DEFAULT — 20 원복 (기록 테이블의 이전 DEFAULT 로 · 무효화된 의존 객체 재컴파일). 전체 F5 · 멱등
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_n NUMBER;
    TYPE t_set IS TABLE OF VARCHAR2(1) INDEX BY VARCHAR2(300);
    v_valid t_set; v_k VARCHAR2(300); v_bad NUMBER;
    PROCEDURE recomp_invalidated IS   -- 이 DDL 로 무효화된 객체(실행 전 VALID)만 재컴파일 · 원래 INVALID 이던 객체는 건드리지 않음
        v_st VARCHAR2(30); v_fix NUMBER := 0;
    BEGIN
        FOR pass IN 1 .. 3 LOOP
            FOR o IN (SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS WHERE STATUS = 'INVALID' ORDER BY OBJECT_TYPE, OBJECT_NAME) LOOP
                IF v_valid.EXISTS(o.OBJECT_NAME || '|' || o.OBJECT_TYPE) THEN
                    BEGIN
                        EXECUTE IMMEDIATE CASE o.OBJECT_TYPE WHEN 'PACKAGE BODY' THEN 'ALTER PACKAGE ' || o.OBJECT_NAME || ' COMPILE BODY'
                                                              WHEN 'TYPE BODY' THEN 'ALTER TYPE ' || o.OBJECT_NAME || ' COMPILE BODY'
                                                              ELSE 'ALTER ' || o.OBJECT_TYPE || ' ' || o.OBJECT_NAME || ' COMPILE' END;
                    EXCEPTION WHEN OTHERS THEN NULL;   -- 컴파일 경고/오류는 아래 상태 확인으로 보고 (ORA-24344)
                    END;
                END IF;
            END LOOP;
        END LOOP;
        FOR o IN (SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS ORDER BY 1, 2) LOOP
            IF v_valid.EXISTS(o.OBJECT_NAME || '|' || o.OBJECT_TYPE) AND o.STATUS <> 'VALID' THEN
                DBMS_OUTPUT.PUT_LINE('   ★ 재컴파일 실패 ' || o.OBJECT_NAME || ' ' || o.OBJECT_TYPE || ' — 회신'); v_fix := v_fix + 1;
            END IF;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('== 의존 객체 재컴파일 완료 · 실패 ' || v_fix);
    END;
BEGIN
    FOR o IN (SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS WHERE STATUS = 'VALID') LOOP v_valid(o.OBJECT_NAME || '|' || o.OBJECT_TYPE) := 'Y'; END LOOP;
    SELECT COUNT(*) INTO v_n FROM USER_TABLES WHERE TABLE_NAME = 'ZZ_CELLPROD_DASH_DFLT_20261027';
    IF v_n = 0 THEN DBMS_OUTPUT.PUT_LINE('SKIP — 기록 테이블 없음 (20 미실행)'); RETURN; END IF;
    EXECUTE IMMEDIATE 'ALTER SESSION SET DDL_LOCK_TIMEOUT = 30';
    FOR r IN (SELECT TABLE_NAME, OLD_DEFAULT, OLD_ON_NULL FROM SCM_MGR.ZZ_CELLPROD_DASH_DFLT_20261027 ORDER BY 1) LOOP
        EXECUTE IMMEDIATE 'ALTER TABLE SCM_MGR.' || r.TABLE_NAME || ' MODIFY (CELL_PROD_SITE_ID DEFAULT ' || CASE WHEN r.OLD_ON_NULL = 'YES' THEN 'ON NULL ' END || r.OLD_DEFAULT || ')';
        DBMS_OUTPUT.PUT_LINE('   RESTORED ' || RPAD(r.TABLE_NAME, 36) || ' DEFAULT ' || CASE WHEN r.OLD_ON_NULL = 'YES' THEN 'ON NULL ' END || r.OLD_DEFAULT);
    END LOOP;
    EXECUTE IMMEDIATE 'DROP TABLE SCM_MGR.ZZ_CELLPROD_DASH_DFLT_20261027 PURGE';
    recomp_invalidated;
END;
/
