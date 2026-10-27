-- SOURCE-FRESH: SCM_MGR.PKG_DMF0049 PACKAGE BODY LAST_DDL=2026-10-22 11:36:46 FETCHED=2026-10-22 11:44 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 99_ROLLBACK — [E20261022-SOLDTONULL] PKG 원복 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 10_APPLY 가 넣은 마커 줄 2개를 지우고, 바로 위 주석으로 남긴 원래 줄의 '--' 를 뗀다 (ASCII 토큰으로만 판정).
-- 가드: 마커 없음 → 무동작 · 마커 줄 ≠ 2 또는 윗줄이 원래 줄 주석이 아니면 중단(원문 무변경) · 컴파일 오류 → 원문 자동 복원
-- 데이터 원복은 99_ROLLBACK_DATA (별도)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    TYPE t_lines IS TABLE OF VARCHAR2(32767) INDEX BY PLS_INTEGER;
    l        t_lines;
    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    n        PLS_INTEGER := 0;
    i        PLS_INTEGER;
    v_ln     VARCHAR2(32767);
    c_mark   CONSTANT VARCHAR2(40)   := '[E20261022-SOLDTONULL]';
    c_tok1   CONSTANT VARCHAR2(100)  := 'NVL(NULLIF(RTRIM(A.SOLDTO_CODE),''''), ''/'')';
    c_tok2   CONSTANT VARCHAR2(100)  := 'NVL(NULLIF(RTRIM(A.SOLDTO_CODE),''''), ''-'')';
    c_new    CONSTANT VARCHAR2(100)  := 'NULLIF(RTRIM(A.SOLDTO_CODE),'''')';
    c_tail   CONSTANT VARCHAR2(400)  := '    -- 2026.10.22 [E20261022-SOLDTONULL] AS-IS 동일 빈 Sold-To = NULL 저장(''/'' 치환 제거 — 기존 NULL 행과 정렬 일치)' || CHR(10) || '';
    FUNCTION tok_pos(p VARCHAR2) RETURN PLS_INTEGER IS
    BEGIN
        RETURN CASE WHEN INSTR(p, c_tok1) > 0 THEN INSTR(p, c_tok1) ELSE INSTR(p, c_tok2) END;
    END;
    FUNCTION is_cmt(p VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN SUBSTR(LTRIM(p), 1, 2) = '--';
    END;
    PROCEDURE put(p VARCHAR2) IS
    BEGIN
        IF p IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(v_new, LENGTH(p), p); END IF;
    END;
BEGIN
    SELECT TEXT BULK COLLECT INTO l FROM USER_SOURCE WHERE NAME = 'PKG_DMF0049' AND TYPE = 'PACKAGE BODY' ORDER BY LINE;
    IF l.COUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, '중단 — PKG_DMF0049 BODY 없음');
    END IF;
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    DBMS_LOB.CREATETEMPORARY(v_new, TRUE);
    FOR k IN 1 .. l.COUNT LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(l(k)), l(k));
    END LOOP;
    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    FOR k IN 1 .. l.COUNT LOOP
        IF INSTR(l(k), c_mark) > 0 THEN
            IF k = 1 OR SUBSTR(l(k - 1), 1, 2) <> '--' OR tok_pos(l(k - 1)) = 0 THEN
                RAISE_APPLICATION_ERROR(-20001, '중단 — 마커 줄 위가 원래 줄 주석이 아님(L' || k || '). 원문 무변경');
            END IF;
            n := n + 1;
        END IF;
    END LOOP;
    IF n <> 2 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 마커 줄 ' || n || '건 (2 기대). 원문 무변경');
    END IF;
    FOR k IN 1 .. l.COUNT LOOP
        IF INSTR(l(k), c_mark) > 0 THEN
            NULL;
        ELSIF k < l.COUNT AND INSTR(l(k + 1), c_mark) > 0 THEN
            put(SUBSTR(l(k), 3));
        ELSE
            put(l(k));
        END IF;
    END LOOP;
    IF DBMS_LOB.INSTR(v_new, c_mark) > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치(마커 잔존). 원문 무변경');
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0049' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0049' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR x IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0049' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || x.LINE || ':' || x.POSITION || ' ' || x.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0049 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0049' ORDER BY OBJECT_TYPE;
