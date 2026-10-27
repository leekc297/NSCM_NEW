-- 20_ALTER_DEFAULT — [E20261027-CELLPRODDASH] CELL_PROD_SITE_ID DEFAULT '/' → '-' (전체 F5 · 멱등)
-- 대상: CELL_PROD_SITE_ID 가 있는 일반 테이블(백업·스냅샷·임시 제외) 중 현재 DEFAULT 가 '/' 인 것. ON NULL 여부는 그대로 유지.
-- AS-IS: DM_PLN_SALES_PLAN · DM_PLN_SALES_PLAN_RESULT · DM_PLN_MKT_FCST_RESULT 의 DEFAULT 가 '-' (나머지는 기본값 없음 · NOT NULL).
-- 이전 값은 SCM_MGR.ZZ_CELLPROD_DASH_DFLT_20261027 에 기록 (99 가 복원). 딕셔너리만 바뀌는 DDL (행 갱신 없음) · 잠금 대기 30초.
-- ⚠ 테이블 DDL 은 그 테이블을 쓰는 PKG/PROC 를 INVALID 로 만든다(사내 17개) → 끝에서 실행 전 VALID 이던 객체만 재컴파일 · 실패 목록 출력.
--   실행 중인 세션이 있으면 ORA-04068 이 날 수 있으니 배치·화면 사용이 적을 때 실행.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    c_log CONSTANT VARCHAR2(60) := 'ZZ_CELLPROD_DASH_DFLT_20261027';
    v_n NUMBER; v_d VARCHAR2(4000); v_cnt NUMBER := 0;
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
    SELECT COUNT(*) INTO v_n FROM USER_TABLES WHERE TABLE_NAME = c_log;
    IF v_n = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE SCM_MGR.' || c_log || ' (TABLE_NAME VARCHAR2(128) NOT NULL, OLD_DEFAULT VARCHAR2(400), OLD_ON_NULL VARCHAR2(3), LOGGED_AT DATE DEFAULT SYSDATE NOT NULL)';
    END IF;
    EXECUTE IMMEDIATE 'ALTER SESSION SET DDL_LOCK_TIMEOUT = 30';
    FOR t IN (SELECT C.TABLE_NAME, C.DEFAULT_ON_NULL FROM USER_TAB_COLUMNS C JOIN USER_TABLES T ON T.TABLE_NAME = C.TABLE_NAME AND T.TEMPORARY = 'N'
                   WHERE C.COLUMN_NAME = 'CELL_PROD_SITE_ID' AND NOT REGEXP_LIKE(C.TABLE_NAME, '(BAK|_SNAPSHOT|_TMP|_TEST|^CMP[0-9][$]|^ZZ_)') ORDER BY 1) LOOP
        SELECT DATA_DEFAULT INTO v_d FROM USER_TAB_COLUMNS WHERE TABLE_NAME = t.TABLE_NAME AND COLUMN_NAME = 'CELL_PROD_SITE_ID';
        IF TRIM(v_d) = '''/''' THEN
            EXECUTE IMMEDIATE 'INSERT INTO SCM_MGR.' || c_log || ' (TABLE_NAME, OLD_DEFAULT, OLD_ON_NULL) VALUES (:1, :2, :3)' USING t.TABLE_NAME, TRIM(v_d), t.DEFAULT_ON_NULL;
            COMMIT;
            EXECUTE IMMEDIATE 'ALTER TABLE SCM_MGR.' || t.TABLE_NAME || ' MODIFY (CELL_PROD_SITE_ID DEFAULT ' || CASE WHEN t.DEFAULT_ON_NULL = 'YES' THEN 'ON NULL ' END || '''-'')';
            v_cnt := v_cnt + 1;
            DBMS_OUTPUT.PUT_LINE('   ALTERED ' || RPAD(t.TABLE_NAME, 36) || ' DEFAULT ' || CASE WHEN t.DEFAULT_ON_NULL = 'YES' THEN 'ON NULL ' END || '''/'' → ''-''');
        ELSE
            DBMS_OUTPUT.PUT_LINE('   SKIP    ' || RPAD(t.TABLE_NAME, 36) || ' 현재 DEFAULT ' || NVL(TRIM(v_d), '(없음)'));
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('== DEFAULT 변경 ' || v_cnt || '개 테이블 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
    recomp_invalidated;   -- 테이블 DDL 은 의존 PKG/PROC 를 무효화한다 (사내 리허설 실측 17개)
END;
/
