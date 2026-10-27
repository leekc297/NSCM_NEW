-- 99_ROLLBACK — 10 전환 되돌리기 (비-40 '/' → '-', 전환 전부터 '/' 이던 행은 기록 테이블로 제외) · 전체 F5
-- ⚠ 10 실행 뒤 화면·배치가 새로 '/' 로 저장한 행도 '-' 로 돌아간다 (구분 불가). 기록 테이블이 없으면(10 미실행·DRY RUN) 무동작.
-- ★ c_dry_run = 'Y' 이면 건수만.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    c_dry_run CONSTANT VARCHAR2(1)   := 'Y';
    c_keep    CONSTANT VARCHAR2(200) := ' NOT IN (''40'', ''NERP_40'') ';
    c_log     CONSTANT VARCHAR2(60)  := 'ZZ_CELLPROD_SLASH_PRE_20261027';
    v_n NUMBER; v_done NUMBER; v_task VARCHAR2(128);
BEGIN
    SELECT COUNT(*) INTO v_n FROM USER_TABLES WHERE TABLE_NAME = c_log;
    IF v_n = 0 THEN DBMS_OUTPUT.PUT_LINE('SKIP — 기록 테이블 없음 (10 미실행)'); RETURN; END IF;
    FOR t IN (SELECT DISTINCT TABLE_NAME FROM SCM_MGR.ZZ_CELLPROD_SLASH_PRE_20261027 ORDER BY 1) LOOP
        EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM SCM_MGR.' || t.TABLE_NAME || ' A WHERE A.CELL_PROD_SITE_ID = ''/'' AND A.DIVISION_ID' || c_keep
                       || ' AND NOT EXISTS (SELECT 1 FROM SCM_MGR.' || c_log || ' L WHERE L.TABLE_NAME = :t AND L.RID = A.ROWID)' INTO v_n USING t.TABLE_NAME;
        IF c_dry_run = 'Y' OR v_n = 0 THEN
            DBMS_OUTPUT.PUT_LINE('   ' || RPAD(t.TABLE_NAME, 32) || ' 되돌릴 대상 ' || TO_CHAR(v_n, 'FM999,999,999'));
            CONTINUE;
        END IF;
        v_done := 0;
        v_task := 'CELLPROD_RB_' || SUBSTR(t.TABLE_NAME, 1, 40) || '_' || TO_CHAR(SYSDATE, 'HH24MISS');
        DBMS_PARALLEL_EXECUTE.CREATE_TASK(v_task);
        DBMS_PARALLEL_EXECUTE.CREATE_CHUNKS_BY_ROWID(v_task, 'SCM_MGR', t.TABLE_NAME, FALSE, 20000);
        FOR ch IN (SELECT START_ROWID, END_ROWID FROM USER_PARALLEL_EXECUTE_CHUNKS WHERE TASK_NAME = v_task ORDER BY CHUNK_ID) LOOP
            EXECUTE IMMEDIATE 'UPDATE SCM_MGR.' || t.TABLE_NAME || ' A SET A.CELL_PROD_SITE_ID = ''-''
                                WHERE A.ROWID BETWEEN :s AND :e AND A.CELL_PROD_SITE_ID = ''/'' AND A.DIVISION_ID' || c_keep || '
                                  AND NOT EXISTS (SELECT 1 FROM SCM_MGR.' || c_log || ' L WHERE L.TABLE_NAME = :t AND L.RID = A.ROWID)'
                USING ch.START_ROWID, ch.END_ROWID, t.TABLE_NAME;
            v_done := v_done + SQL%ROWCOUNT;
            COMMIT;
        END LOOP;
        DBMS_PARALLEL_EXECUTE.DROP_TASK(v_task);
        DBMS_OUTPUT.PUT_LINE('   ' || RPAD(t.TABLE_NAME, 32) || ' 되돌림 ' || TO_CHAR(v_done, 'FM999,999,999'));
    END LOOP;
END;
/
