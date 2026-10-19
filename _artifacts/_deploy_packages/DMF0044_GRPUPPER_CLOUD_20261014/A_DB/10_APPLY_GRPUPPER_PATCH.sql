-- 10_APPLY — [E20261014-DMF0044GRPUPPER] PKG_DMF0044 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 증상: DMF0044 조회 — Data Type 이 ALL · CUTOFF DATA 이면 SQL ERROR, ETC 는 정상.
-- 원인: P_DMF0044_GET_SALES_REPORTS_DATA 의 CUTOFF DATA INSERT 문에서 Model Type 식이
--         SELECT   : CASE WHEN UPPER(SINGLE.ITEM_CLASS_NAME) LIKE '%CELL%' …   (UPPER 있음)
--         GROUP BY : CASE WHEN SINGLE.ITEM_CLASS_NAME LIKE '%CELL%' …          (UPPER 없음)
--       로 서로 달라 ORA-00979 (SINGLE.ITEM_CLASS_NAME: must appear in the GROUP BY clause).
-- 보완: GROUP BY 의 3줄을 SELECT 와 같은 식(UPPER)으로 맞춘다. SELECT · ETC 구간 · 그 밖의 문장 무변경.
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 3줄만 바꾼 뒤 CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · CUTOFF 구간의 식이 "UPPER 3줄 + UPPER 없음 3줄" 구조가 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 2026-10-14 09:28:20 (적용 전 ALL · CUTOFF DATA 오류 재현 → 적용 후 3종 모두 정상). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
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
    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_reg, c_up) <> 3 OR cnt(v_reg, c_raw) <> 3 OR cnt(v_reg, c_gold) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — CUTOFF 구간 Model Type 식 개수: UPPER ' || cnt(v_reg, c_up) || ' · UPPER 없음 ' || cnt(v_reg, c_raw)
            || ' (3 · 3 기대). 이 DB 의 원문이 사내와 다름 → 00_PRECHECK L1 · L2 결과 회신. 원문 무변경');
    END IF;
    v_g := DBMS_LOB.INSTR(v_reg, c_raw);
    IF NOT (DBMS_LOB.INSTR(v_reg, c_up, 1, 3) < v_g AND DBMS_LOB.INSTR(v_reg, 'GROUP BY', DBMS_LOB.INSTR(v_reg, c_up, 1, 3)) < v_g) THEN
        RAISE_APPLICATION_ERROR(-20003, '중단 — UPPER 식이 SELECT, UPPER 없는 식이 GROUP BY 에 있는 구조가 아님. 원문 무변경');
    END IF;
    v_reg := REPLACE(REPLACE(v_reg, c_gold, c_gnew), c_raw, c_up);
    v_new := SUBSTR(v_src, 1, v_a - 1) || v_reg || SUBSTR(v_src, v_b);
    IF cnt(v_new, c_mark) <> 1 OR cnt(v_reg, c_up) <> 6 OR cnt(v_reg, c_raw) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치 (마커 ' || cnt(v_new, c_mark) || '곳, 1 기대). 원문 무변경');
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
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0044 BODY ' || v_st || ' · GROUP BY 3줄 보완 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0044' ORDER BY OBJECT_TYPE;
