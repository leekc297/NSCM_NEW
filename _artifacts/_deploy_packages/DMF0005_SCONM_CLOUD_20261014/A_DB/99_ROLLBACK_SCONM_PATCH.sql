-- 99_ROLLBACK — [E20261014-DMF0005SCONM] 패치 원복 (전체 F5, 값 입력 없음, 멱등)
-- 10_APPLY 가 바꾼 2곳만 원래대로 되돌린다(선행 NOPUSH 패치는 그대로 둔다).
-- 가드: 마커 없으면 무동작 · 치환 대상 각 1곳 아니면 중단 · 컴파일 오류 시 원문 자동 복원
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'E20261014-DMF0005SCONM';
    c_old1  CONSTANT VARCHAR2(32767) :=
        '    BASE AS (' || CHR(10) ||
        '        SELECT' || CHR(10) ||
        '              SI.DIVISION_ID' || CHR(10);
    c_new1  CONSTANT VARCHAR2(32767) :=
        '    BASE AS (' || CHR(10) ||
        '        SELECT /*+ NO_PUSH_PRED(ONM) */    -- 2026.10.14 [E20261014-DMF0005SCONM] Owner 이름(OWNER_NM)을 행마다 다시 구하지 않고 Owner 종류마다 한 번(07-22 설계) — 클라우드 QA 행별 반복 대응 · 힌트 사용자 승인' || CHR(10) ||
        '              SI.DIVISION_ID' || CHR(10);
    c_old2  CONSTANT VARCHAR2(32767) :=
        '         AND (P_DIVISION_ID = ''82'' OR NVL(SC.VALID_YN, ''Y'') = ''Y'')' || CHR(10);
    c_new2  CONSTANT VARCHAR2(32767) :=
        '--       AND (P_DIVISION_ID = ''82'' OR NVL(SC.VALID_YN, ''Y'') = ''Y'')    -- 2026.10.14 [E20261014-DMF0005SCONM] 원본 — 바로 위 SC.VALID_YN = ''Y'' 로 항상 참. 바인드가 섞인 이 조건이 조인을 행별 실행(VW_DCL)으로 바꿔 제거(결과 동일)' || CHR(10);
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := 1;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0005' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));
    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_new1) <> 1 OR cnt(v_src, c_new2) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 패치 줄 매칭 ①' || cnt(v_src, c_new1) || ' ②' || cnt(v_src, c_new2) || ' (각 1 기대). 원문 무변경');
    END IF;
    v_new := REPLACE(REPLACE(v_src, c_new1, c_old1), c_new2, c_old2);
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 원복 뒤에도 마커 ' || cnt(v_new, c_mark) || '곳');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0005' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0005' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 패치 상태로 복원함');
    END IF;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0005 BODY ' || v_st || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0005' ORDER BY OBJECT_TYPE;
