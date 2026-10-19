-- [E20261008-SLASHOBJ] 03b_CLOUD_RECOMPILE_INVALID — 03 적용 뒤 새로 INVALID 된 객체(01 백업 회차의 기준선 밖) 재컴파일 2회 · 생성 2026-10-08 18:40 · 대상 96객체(사내 현재 원문 스냅샷 2026-10-08T17:26) · SCM_MGR 접속 후 파일 전체 실행(F5)
--   · 기준선(원래 INVALID 였던 객체)은 건드리지 않음. 남는 객체는 마지막 SELECT 로 출력.

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_run  VARCHAR2(14); v_stmt VARCHAR2(400); v_done NUMBER := 0; v_err NUMBER := 0;
BEGIN
    SELECT MAX(bak_run) INTO v_run FROM SCM_MGR.ZZ_SLASHOBJ_BAK_20261008;
    IF v_run IS NULL THEN DBMS_OUTPUT.PUT_LINE('NOTE | no backup run in SCM_MGR.ZZ_SLASHOBJ_BAK_20261008 — run 01 first (baseline empty → every INVALID counts as new)'); END IF;
    FOR pass IN 1 .. 2 LOOP
        FOR o IN (SELECT object_type, object_name FROM all_objects
                   WHERE owner = 'SCM_MGR' AND status = 'INVALID'
                     AND object_type || '|' || object_name NOT IN (SELECT obj_name FROM SCM_MGR.ZZ_SLASHOBJ_BAK_20261008 WHERE bak_run = v_run AND obj_type = '#INVALID_BASELINE')
                   ORDER BY CASE object_type WHEN 'PACKAGE' THEN 1 WHEN 'TYPE' THEN 1 WHEN 'VIEW' THEN 2 WHEN 'FUNCTION' THEN 3 WHEN 'PROCEDURE' THEN 3 WHEN 'PACKAGE BODY' THEN 4 ELSE 5 END, object_name) LOOP
            v_stmt := CASE o.object_type
                        WHEN 'PACKAGE BODY' THEN 'ALTER PACKAGE SCM_MGR.' || o.object_name || ' COMPILE BODY'
                        WHEN 'PACKAGE'      THEN 'ALTER PACKAGE SCM_MGR.' || o.object_name || ' COMPILE SPECIFICATION'
                        WHEN 'TYPE BODY'    THEN 'ALTER TYPE SCM_MGR.' || o.object_name || ' COMPILE BODY'
                        WHEN 'TYPE'         THEN 'ALTER TYPE SCM_MGR.' || o.object_name || ' COMPILE SPECIFICATION'
                        WHEN 'SYNONYM'      THEN NULL
                        ELSE 'ALTER ' || o.object_type || ' SCM_MGR.' || o.object_name || ' COMPILE' END;
            IF v_stmt IS NOT NULL THEN
                BEGIN EXECUTE IMMEDIATE v_stmt; v_done := v_done + 1;
                EXCEPTION WHEN OTHERS THEN v_err := v_err + 1; DBMS_OUTPUT.PUT_LINE('COMPILE ERR ' || o.object_type || ' ' || o.object_name || ' : ' || SUBSTR(SQLERRM, 1, 150)); END;
            END IF;
        END LOOP;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('RECOMPILE baseline_run=' || v_run || ' | compiled=' || v_done || ' | errors=' || v_err);
END;
/
-- 기준선 밖에 남은 INVALID (0행이 정상)
SELECT 'STILL INVALID (new) | ' || object_type || ' ' || object_name AS line FROM all_objects
 WHERE owner = 'SCM_MGR' AND status = 'INVALID'
   AND object_type || '|' || object_name NOT IN (SELECT obj_name FROM SCM_MGR.ZZ_SLASHOBJ_BAK_20261008 WHERE bak_run = (SELECT MAX(bak_run) FROM SCM_MGR.ZZ_SLASHOBJ_BAK_20261008) AND obj_type = '#INVALID_BASELINE')
 ORDER BY 1;
