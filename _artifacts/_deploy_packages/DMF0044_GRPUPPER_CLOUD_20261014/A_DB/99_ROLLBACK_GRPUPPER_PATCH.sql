-- 99 ROLLBACK — [E20261014-DMF0044GRPUPPER] 역치환 (GROUP BY 3줄을 UPPER 없는 식으로 되돌린다). 전체 F5, 멱등
-- 마커 없으면 무동작. ⚠ 되돌리면 ALL · CUTOFF DATA 조회가 다시 ORA-00979 로 실패한다.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_reg   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_a     PLS_INTEGER;
    v_b     PLS_INTEGER;
    v_g     PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40)   := 'E20261014-DMF0044GRPUPPER';
    c_ps    CONSTANT VARCHAR2(200)  := CHR(10) || 'PROCEDURE P_DMF0044_GET_SALES_REPORTS_DATA';   -- 범위 시작: 조회 프로시저
    c_pe    CONSTANT VARCHAR2(200)  := 'IF P_DATA_TYPE <> ''1'' THEN';   -- 범위 끝: ETC 구간 시작
    c_up    CONSTANT VARCHAR2(200)  := 'WHEN UPPER(SINGLE.ITEM_CLASS_NAME) LIKE ''%';   -- SELECT 쪽 식 (그대로 둔다)
    c_raw   CONSTANT VARCHAR2(200)  := 'WHEN SINGLE.ITEM_CLASS_NAME LIKE ''%';   -- GROUP BY 쪽 식 (UPPER 로 맞춘다)
    c_gold  CONSTANT VARCHAR2(400)  := 'CASE WHEN SINGLE.ITEM_CLASS_NAME LIKE ''%CELL%'' THEN ''Cell''' || CHR(10);
    c_gnew  CONSTANT VARCHAR2(400)  := 'CASE WHEN UPPER(SINGLE.ITEM_CLASS_NAME) LIKE ''%CELL%'' THEN ''Cell''  --[E20261014-DMF0044GRPUPPER] SELECT 의 Model Type 식과 같게(UPPER) — 달라서 ORA-00979' || CHR(10);
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
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0044' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_a := DBMS_LOB.INSTR(v_src, c_ps);
    IF v_a > 0 THEN v_b := DBMS_LOB.INSTR(v_src, c_pe, v_a); END IF;
    IF NVL(v_a, 0) = 0 OR NVL(v_b, 0) = 0 OR cnt(v_src, c_ps) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 조회 프로시저 또는 ETC 구간 시작 줄을 찾지 못함. 원문 무변경');
    END IF;
    v_reg := SUBSTR(v_src, v_a, v_b - v_a);   -- 프로시저 시작 ~ ETC 구간 직전 (CUTOFF DATA 구간 포함)
    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    v_g := DBMS_LOB.INSTR(v_reg, c_gnew);
    IF cnt(v_reg, c_gnew) <> 1 OR cnt(SUBSTR(v_reg, v_g), c_up) <> 3 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용 문구 매칭 ' || cnt(v_reg, c_gnew) || '건 (1 기대). 원문 무변경');
    END IF;
    v_reg := SUBSTR(v_reg, 1, v_g - 1) || REPLACE(REPLACE(SUBSTR(v_reg, v_g), c_gnew, c_gold), c_up, c_raw);
    v_new := SUBSTR(v_src, 1, v_a - 1) || v_reg || SUBSTR(v_src, v_b);
    IF cnt(v_new, c_mark) <> 0 OR cnt(v_reg, c_up) <> 3 OR cnt(v_reg, c_raw) <> 3 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 결과 불일치. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0044' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0044' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0044' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0044 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0044' ORDER BY OBJECT_TYPE;
