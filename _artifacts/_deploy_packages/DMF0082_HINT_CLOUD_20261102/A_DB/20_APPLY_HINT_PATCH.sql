-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL=2026-11-02 11:05:27 FETCHED=2026-11-02 11:05:38 DB=ZIOUI1
-- 10_APPLY — [E20261102-DMF0082HINT] PKG_DMF0082 BODY 패치 (전체 F5 · 값 입력 없음 · 멱등)
-- 내용: P_DMF0082_GET_MAIN_DATA 힌트 6건(사용자 지정 튜닝 2026-11-02). 로직·결과 컬럼 변경 없음.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 GET_MAIN_DATA 범위 안 앵커 7곳만 치환 후 CREATE OR REPLACE (사내 전체본 복사 아님)
-- 가드: 마커 있으면 무동작 · 앵커가 범위 안 각 1건이 아니면 중단(원문 무변경, 어느 앵커인지 출력) · 컴파일 오류 시 원문 자동 복원
-- 실행 뒤 30_SPEED_AFTER
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src  CLOB;
    v_new  CLOB;
    v_rng  CLOB;
    v_st   VARCHAR2(30);
    v_err  PLS_INTEGER;
    v_s    PLS_INTEGER;
    v_e    PLS_INTEGER;
    c_mark CONSTANT VARCHAR2(40) := 'E20261102-DMF0082HINT';
    TYPE t_vc IS TABLE OF VARCHAR2(4000) INDEX BY PLS_INTEGER;
    c_name t_vc; c_anc t_vc; c_new t_vc;
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
    PROCEDURE compile_body(p_sql CLOB) IS   -- 컴파일 오류(ORA-24344)는 아래 STATUS 확인으로 처리, 그 외 오류(ORA-04021 등)는 그대로 올림
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || p_sql;
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE <> -24344 THEN RAISE; END IF;
    END;
BEGIN
    c_name(1) := 'H1 TEMP_SITE_ITEM_ALL FULL(F)';
    c_anc(1) := '    )' || CHR(10) ||
        '    SELECT F.DIVISION_ID' || CHR(10) ||
        '         , F.PROJECT_CODE' || CHR(10) ||
        '         , F.SCM_SITE_ID' || CHR(10) ||
        '         , F.ITEM_ID' || CHR(10) ||
        '         , F.ATTRIBUTE5 ';
    c_new(1) := '    )' || CHR(10) ||
        '    SELECT /*+ FULL(F) */ /*[E20261102-DMF0082HINT]*/ F.DIVISION_ID' || CHR(10) ||
        '         , F.PROJECT_CODE' || CHR(10) ||
        '         , F.SCM_SITE_ID' || CHR(10) ||
        '         , F.ITEM_ID' || CHR(10) ||
        '         , F.ATTRIBUTE5 ';
    c_name(2) := 'H2 T_LAST_DATA_SETUP_FCST FULL(A) USE_HASH(A)';
    c_anc(2) := '    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST' || CHR(10) ||
        '        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)' || CHR(10) ||
        '    SELECT A.DIVISION_ID,';
    c_new(2) := '    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST' || CHR(10) ||
        '        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)' || CHR(10) ||
        '    SELECT /*+ FULL(A) USE_HASH(A) */ /*[E20261102-DMF0082HINT]*/ A.DIVISION_ID,';
    c_name(3) := 'H3 FUTURE_PRICE 1 read';
    c_anc(3) := '        FROM (' || CHR(10) ||
        '        SELECT A.DIVISION_ID AS C01' || CHR(10) ||
        '             , A.PROJECT_CODE AS C02' || CHR(10) ||
        '             , A.PROJECT_CODE AS C03  --[DIV81]';
    c_new(3) := '        FROM (' || CHR(10) ||
        '        SELECT /*+ LEADING(B A C) USE_HASH(A C D) FULL(A) FULL(B) FULL(C) FULL(D) NO_SWAP_JOIN_INPUTS(A) PARALLEL(4) */ /*[E20261102-DMF0082HINT]*/ A.DIVISION_ID AS C01' || CHR(10) ||
        '             , A.PROJECT_CODE AS C02' || CHR(10) ||
        '             , A.PROJECT_CODE AS C03  --[DIV81]';
    c_name(4) := 'H4 CFM_SELLING_PRICE hint replace';
    c_anc(4) := '        SELECT /*+ LEADING(A) USE_HASH(B) USE_HASH(C) */ ';
    c_new(4) := '        SELECT /*+ LEADING(B A) USE_HASH(A C) FULL(A) SWAP_JOIN_INPUTS(B) NO_SWAP_JOIN_INPUTS(A) SWAP_JOIN_INPUTS(C) */ /*[E20261102-DMF0082HINT] old hint: LEADING(A) USE_HASH(B) USE_HASH(C)*/ ';
    c_name(5) := 'H5 MF_SP load';
    c_anc(5) := '    SELECT F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID' || CHR(10) ||
        '         , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID' || CHR(10) ||
        '         , F.CELL_PROD_SITE_ID' || CHR(10) ||
        '         , CAL.BUCKET_TYPE' || CHR(10);
    c_new(5) := '    SELECT /*+ LEADING(CAL F VD) USE_HASH(F VD PVT) SWAP_JOIN_INPUTS(CAL) NO_SWAP_JOIN_INPUTS(F) PARALLEL(F 4) */ /*[E20261102-DMF0082HINT]*/ F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID' || CHR(10) ||
        '         , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID' || CHR(10) ||
        '         , F.CELL_PROD_SITE_ID' || CHR(10) ||
        '         , CAL.BUCKET_TYPE' || CHR(10);
    c_name(6) := 'H6a final dynamic SQL placeholder';
    c_anc(6) := '    V_SQL := ''' || CHR(10) ||
        '    SELECT [@V_COLUMN]' || CHR(10) ||
        '    , ([@V_QTY_SUM]) AS QTY' || CHR(10);
    c_new(6) := '    V_SQL := ''' || CHR(10) ||
        '    SELECT [@V_HINT82] [@V_COLUMN]' || CHR(10) ||
        '    , ([@V_QTY_SUM]) AS QTY' || CHR(10);
    c_name(7) := 'H6b PARALLEL(8) only for 82';
    c_anc(7) := '    V_SQL := REPLACE(V_SQL, ''[@V_QTY_SUM]'',     V_QTY_SUM);' || CHR(10);
    c_new(7) := '    V_SQL := REPLACE(V_SQL, ''[@V_HINT82]'', CASE WHEN p_division_id = ''82'' THEN ''/*+ PARALLEL(8) */'' END);  --[E20261102-DMF0082HINT] 82 only' || CHR(10) ||
        '    V_SQL := REPLACE(V_SQL, ''[@V_QTY_SUM]'',     V_QTY_SUM);' || CHR(10);
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    IF v_src IS NULL OR DBMS_LOB.GETLENGTH(v_src) = 0 THEN
        RAISE_APPLICATION_ERROR(-20000, '중단 — USER_SOURCE 에 PKG_DMF0082 BODY 없음. SCM_MGR 로 접속했는지 확인');
    END IF;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (앵커는 LF 기준)
    v_s := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA' || CHR(10));
    v_e := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_POPUP_GET_FUTUREPRICE_INFO');
    IF v_s = 0 OR v_e = 0 OR v_e < v_s THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — P_DMF0082_GET_MAIN_DATA 범위를 찾지 못함. 원문 무변경');
    END IF;
    v_rng := SUBSTR(v_src, v_s, v_e - v_s);
    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    FOR i IN 1 .. c_anc.COUNT LOOP
        IF cnt(v_rng, c_anc(i)) <> 1 THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — 앵커 ' || c_name(i) || ' 매칭 ' || cnt(v_rng, c_anc(i)) || '건 (1 기대) → 결과 회신. 원문 무변경');
        END IF;
    END LOOP;
    FOR i IN 1 .. c_anc.COUNT LOOP
        v_rng := REPLACE(v_rng, c_anc(i), c_new(i));
    END LOOP;
    v_new := SUBSTR(v_src, 1, v_s - 1) || v_rng || SUBSTR(v_src, v_e);
    IF cnt(v_new, c_mark) <> 7 - 1 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 마커 ' || cnt(v_new, c_mark) || '곳 (6 기대). 원문 무변경');
    END IF;
    compile_body(v_new);
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        compile_body(v_src);   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 ' || cnt(v_new, c_mark) || '곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;
