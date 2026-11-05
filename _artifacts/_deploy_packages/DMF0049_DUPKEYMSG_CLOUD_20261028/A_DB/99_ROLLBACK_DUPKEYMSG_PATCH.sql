-- 99_ROLLBACK_DUPKEYMSG_PATCH — [E20261028-DUPKEYMSG] 원복 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 10_APPLY 가 넣은 NEW-BEGIN ~ NEW-END 줄(2곳)을 지우고, '--[E20261028-DUPKEYMSG]ORIG ' 접두 주석 줄의 접두만 제거 → 적용 전 원문과 동일
-- 가드: 마커 없으면 무동작 · NEW-BEGIN/NEW-END 가 2쌍이 아니면 중단 · ORA-24344 외 오류 중단 · 컴파일 실패 시 현재 원문 복원
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    TYPE t_lines IS TABLE OF VARCHAR2(32767) INDEX BY PLS_INTEGER;
    l        t_lines;
    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    v_code   PLS_INTEGER := 0;
    v_msg    VARCHAR2(4000);
    nb       PLS_INTEGER := 0;
    ne       PLS_INTEGER := 0;
    in_new   BOOLEAN := FALSE;
    c_mark   CONSTANT VARCHAR2(40) := '[E20261028-DUPKEYMSG]';
    c_orig   CONSTANT VARCHAR2(40) := '--[E20261028-DUPKEYMSG]ORIG ';
    PROCEDURE put(p VARCHAR2) IS
    BEGIN
        IF p IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(v_new, LENGTH(p), p); END IF;
    END;
BEGIN
    SELECT TEXT BULK COLLECT INTO l FROM USER_SOURCE WHERE NAME = 'PKG_DMF0049' AND TYPE = 'PACKAGE BODY' ORDER BY LINE;
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    DBMS_LOB.CREATETEMPORARY(v_new, TRUE);
    FOR k IN 1 .. l.COUNT LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(l(k)), l(k));
        IF INSTR(l(k), c_mark || ' NEW-BEGIN') > 0 THEN nb := nb + 1; END IF;
        IF INSTR(l(k), c_mark || ' NEW-END') > 0 THEN ne := ne + 1; END IF;
    END LOOP;
    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음(미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF nb <> 2 OR ne <> 2 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — NEW-BEGIN ' || nb || ' / NEW-END ' || ne || ' (각 2 기대). 원문 무변경');
    END IF;
    FOR k IN 1 .. l.COUNT LOOP
        IF INSTR(l(k), c_mark || ' NEW-BEGIN') > 0 THEN
            in_new := TRUE;
        ELSIF INSTR(l(k), c_mark || ' NEW-END') > 0 THEN
            in_new := FALSE;
        ELSIF NOT in_new THEN
            IF SUBSTR(l(k), 1, LENGTH(c_orig)) = c_orig THEN
                put(SUBSTR(l(k), LENGTH(c_orig) + 1));
            ELSE
                put(l(k));
            END IF;
        END IF;
    END LOOP;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        v_code := SQLCODE; v_msg := SQLERRM;
    END;
    IF v_code NOT IN (0, -24344) THEN
        RAISE_APPLICATION_ERROR(-20006, '중단 — 생성 미실행 오류 ' || v_msg || ' (원문 무변경. 잠시 후 재실행)');
    END IF;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0049' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0049' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 현재 원문 복원함');
    END IF;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0049 BODY ' || v_st || ' · 중복 검증 2곳 원래대로 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0049' ORDER BY OBJECT_TYPE;
