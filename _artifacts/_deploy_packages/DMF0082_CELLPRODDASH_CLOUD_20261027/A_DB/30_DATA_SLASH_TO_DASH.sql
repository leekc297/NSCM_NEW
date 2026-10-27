-- 30_DATA_SLASH_TO_DASH — [E20261027-CELLPRODDASH] CELL_PROD_SITE_ID '/' · 공백 → '-' (전 사업부 · 전체 F5 · 멱등)
-- 대상: CELL_PROD_SITE_ID 한 컬럼만 (감사 컬럼 등 다른 컬럼 무변경) · CELL_PROD_SITE_ID 가 있는 일반 테이블(백업·스냅샷·임시 제외)
-- 원복 대비: 바꾸는 행의 ROWID 와 이전 값을 SCM_MGR.ZZ_CELLPROD_DASH_DATA_20261027 에 먼저 기록 → 기록분만 5만 건씩 UPDATE · COMMIT
-- 가드: PK 에 CELL_PROD_SITE_ID 가 있고 같은 키 '-' 행이 이미 있으면(PK 충돌) 그 테이블 전체 건너뜀 (회신)
-- ★ c_dry_run = 'Y' 이면 건수만 (변경·기록 없음)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    c_dry_run CONSTANT VARCHAR2(1) := 'N';
    c_log     CONSTANT VARCHAR2(60) := 'ZZ_CELLPROD_DASH_DATA_20261027';
    c_cond    CONSTANT VARCHAR2(200) := ' (CELL_PROD_SITE_ID = ''/'' OR (CELL_PROD_SITE_ID IS NOT NULL AND TRIM(CELL_PROD_SITE_ID) IS NULL)) ';
    v_n NUMBER; v_on VARCHAR2(4000); v_pk VARCHAR2(4000); v_lo NUMBER; v_hi NUMBER; v_done NUMBER; v_all NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('== CELL_PROD_SITE_ID ''/'' → ''-'' ' || CASE c_dry_run WHEN 'Y' THEN '[DRY RUN]' ELSE '[실행]' END || ' · ' || SYS_CONTEXT('USERENV','DB_NAME') || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
    IF c_dry_run = 'N' THEN
        SELECT COUNT(*) INTO v_n FROM USER_TABLES WHERE TABLE_NAME = c_log;
        IF v_n = 0 THEN
            EXECUTE IMMEDIATE 'CREATE TABLE SCM_MGR.' || c_log || ' (SEQ NUMBER NOT NULL, TABLE_NAME VARCHAR2(128) NOT NULL, RID ROWID NOT NULL, OLD_VAL VARCHAR2(120), LOGGED_AT DATE DEFAULT SYSDATE NOT NULL)';
        END IF;
    END IF;
    FOR t IN (SELECT C.TABLE_NAME, C.DEFAULT_ON_NULL FROM USER_TAB_COLUMNS C JOIN USER_TABLES T ON T.TABLE_NAME = C.TABLE_NAME AND T.TEMPORARY = 'N'
                   WHERE C.COLUMN_NAME = 'CELL_PROD_SITE_ID' AND NOT REGEXP_LIKE(C.TABLE_NAME, '(BAK|_SNAPSHOT|_TMP|_TEST|^CMP[0-9][$]|^ZZ_)') ORDER BY 1) LOOP
        EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM SCM_MGR.' || t.TABLE_NAME || ' WHERE' || c_cond INTO v_n;
        IF v_n = 0 THEN DBMS_OUTPUT.PUT_LINE('   ' || RPAD(t.TABLE_NAME, 36) || ' 대상 0 (''/'' 행 없음)'); CONTINUE; END IF;
        v_pk := NULL; v_on := NULL;
        FOR k IN (SELECT CC.COLUMN_NAME FROM USER_CONSTRAINTS C JOIN USER_CONS_COLUMNS CC ON CC.CONSTRAINT_NAME = C.CONSTRAINT_NAME
                   WHERE C.TABLE_NAME = t.TABLE_NAME AND C.CONSTRAINT_TYPE = 'P' ORDER BY CC.POSITION) LOOP
            v_pk := v_pk || k.COLUMN_NAME || ',';
            IF k.COLUMN_NAME <> 'CELL_PROD_SITE_ID' THEN v_on := v_on || ' AND B.' || k.COLUMN_NAME || ' = A.' || k.COLUMN_NAME; END IF;
        END LOOP;
        IF INSTR(',' || v_pk, ',CELL_PROD_SITE_ID,') > 0 THEN
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM SCM_MGR.' || t.TABLE_NAME || ' A WHERE' || REPLACE(c_cond, 'CELL_PROD_SITE_ID', 'A.CELL_PROD_SITE_ID')
                           || ' AND EXISTS (SELECT 1 FROM SCM_MGR.' || t.TABLE_NAME || ' B WHERE B.CELL_PROD_SITE_ID = ''-''' || v_on || ')' INTO v_done;
            IF v_done > 0 THEN DBMS_OUTPUT.PUT_LINE('   ★ ' || RPAD(t.TABLE_NAME, 34) || ' PK 충돌 ' || v_done || '건 — 건너뜀 (회신)'); CONTINUE; END IF;
        END IF;
        IF c_dry_run = 'Y' THEN DBMS_OUTPUT.PUT_LINE('   ' || RPAD(t.TABLE_NAME, 36) || ' 대상 ' || TO_CHAR(v_n, 'FM999,999,999')); CONTINUE; END IF;
        EXECUTE IMMEDIATE 'SELECT NVL(MAX(SEQ), 0) FROM SCM_MGR.' || c_log INTO v_lo;
        EXECUTE IMMEDIATE 'INSERT INTO SCM_MGR.' || c_log || ' (SEQ, TABLE_NAME, RID, OLD_VAL) SELECT :b + ROWNUM, :t, ROWID, CELL_PROD_SITE_ID FROM SCM_MGR.' || t.TABLE_NAME || ' WHERE' || c_cond
            USING v_lo, t.TABLE_NAME;
        v_hi := v_lo + SQL%ROWCOUNT;
        COMMIT;
        v_done := 0;
        WHILE v_lo < v_hi LOOP
            EXECUTE IMMEDIATE 'UPDATE SCM_MGR.' || t.TABLE_NAME || ' SET CELL_PROD_SITE_ID = ''-'' WHERE ROWID IN (SELECT RID FROM SCM_MGR.' || c_log || ' WHERE SEQ > :a AND SEQ <= :z) AND' || c_cond
                USING v_lo, LEAST(v_lo + 50000, v_hi);
            v_done := v_done + SQL%ROWCOUNT;
            COMMIT;
            v_lo := v_lo + 50000;
        END LOOP;
        v_all := v_all + v_done;
        DBMS_OUTPUT.PUT_LINE('   ' || RPAD(t.TABLE_NAME, 36) || ' 전환 ' || LPAD(TO_CHAR(v_done, 'FM999,999,999'), 12) || ' / 대상 ' || TO_CHAR(v_n, 'FM999,999,999'));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('== 완료 ' || CASE c_dry_run WHEN 'Y' THEN '(DRY RUN)' ELSE '전환 합계 ' || TO_CHAR(v_all, 'FM999,999,999') END || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
