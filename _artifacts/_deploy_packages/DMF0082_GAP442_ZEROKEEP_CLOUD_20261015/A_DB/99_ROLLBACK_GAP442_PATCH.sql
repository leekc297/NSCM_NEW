-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL=2026-10-15 13:18:04 FETCHED=2026-10-15 13:29 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 99_ROLLBACK — [GAP442 2026-10-15] GAP 442 원복 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 10_APPLY 가 바꾼 4곳(D1 · D2 · M1 · M2)을 각각 구 줄 1줄로 되돌린다.
--       각 신 블록은 ASCII 시작 토큰과 ASCII 마지막 줄 시작 토큰으로 찾는다 — 한글 주석 비교에 의존하지 않는다.
-- 가드: 마커 없음 → 무동작 · 신 블록 위치 이상 → 중단(원문 무변경) · 컴파일 오류 → 원문 자동 복원
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_s0    PLS_INTEGER;
    v_s1    PLS_INTEGER;
    v_pos   PLS_INTEGER;
    v_e     PLS_INTEGER;
    v_end   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'GAP442 2026-10-15';
    c_old1 CONSTANT VARCHAR2(400) := '    WHERE A.MEASURE IN (''MKT_AMT_KRW'', ''MKT_AMT_LOC'', ''MKT_FCST'', ''VMI_In_Req'', ''SCM_FCST'')' || CHR(10);   -- D1 Phase1 DELETE 대상 구 줄
    c_st1  CONSTANT VARCHAR2(400) := CHR(10) || '    /* [GAP442 2026-10-15]';   -- 신 블록 시작 (ASCII)
    c_en1  CONSTANT VARCHAR2(400) := '    WHERE A.MEASURE IN (''MKT_AMT_KRW'', ''MKT_AMT_LOC'')';   -- 신 블록 마지막 줄 시작 (ASCII)
    c_old2 CONSTANT VARCHAR2(400) := '            FROM SCM_MGR.GT_PRDM1_T_MAIN M WHERE M.MEASURE IN (''MKT_AMT_KRW'', ''MKT_AMT_LOC'', ''MKT_FCST'', ''VMI_In_Req'', ''SCM_FCST'')' || CHR(10);   -- D2 Phase1 DELETE 내부 구 줄
    c_st2  CONSTANT VARCHAR2(400) := CHR(10) || '            FROM SCM_MGR.GT_PRDM1_T_MAIN M WHERE M.MEASURE IN (''MKT_AMT_KRW'', ''MKT_AMT_LOC'')  --[GAP442 2026-10-15]';   -- 신 블록 시작 (ASCII)
    c_en2  CONSTANT VARCHAR2(400) := '            FROM SCM_MGR.GT_PRDM1_T_MAIN M WHERE M.MEASURE IN (''MKT_AMT_KRW'', ''MKT_AMT_LOC'')  --[GAP442 2026-10-15]';   -- 신 블록 마지막 줄 시작 (ASCII)
    c_old3 CONSTANT VARCHAR2(400) := '                 AND M.QTY_PRICE <> 0)' || CHR(10);   -- M1 MERGE 소스 구 줄
    c_st3  CONSTANT VARCHAR2(400) := CHR(10) || '                 AND (M.QTY_PRICE <> 0 OR M.MEASURE IN (''MKT_FCST'', ''VMI_In_Req'', ''SCM_FCST'')))  --[GAP442 2026-10-15]';   -- 신 블록 시작 (ASCII)
    c_en3  CONSTANT VARCHAR2(400) := '                 AND (M.QTY_PRICE <> 0 OR M.MEASURE IN (''MKT_FCST'', ''VMI_In_Req'', ''SCM_FCST'')))  --[GAP442 2026-10-15]';   -- 신 블록 마지막 줄 시작 (ASCII)
    c_old4 CONSTANT VARCHAR2(400) := '    , B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY_PRICE, B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE);' || CHR(10);   -- M2 MERGE INSERT 조건 구 줄
    c_st4  CONSTANT VARCHAR2(400) := CHR(10) || '    , B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY_PRICE, B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE)' || CHR(10) || '    WHERE B.QTY_PRICE <> 0;  --[GAP442 2026-10-15]';   -- 신 블록 시작 (ASCII)
    c_en4  CONSTANT VARCHAR2(400) := '    WHERE B.QTY_PRICE <> 0;  --[GAP442 2026-10-15]';   -- 신 블록 마지막 줄 시작 (ASCII)
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2, p_from PLS_INTEGER, p_to PLS_INTEGER) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := p_from;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL OR pos > p_to;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_s0  := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_SAVE_MAIN_DATA' || CHR(10));
    v_s1  := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_EXCEL_FORM_DATA');
    IF NOT (v_s0 > 0 AND v_s0 < v_s1) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 저장 프로시저 위치 확인 불가 (SAVE_MAIN_DATA / GET_EXCEL_FORM_DATA). 원문 무변경');
    END IF;
    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) <> 4 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 마커 ' || cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) || '곳 (4 기대). 원문 무변경');
    END IF;
    v_new := v_src;
    v_s0  := DBMS_LOB.INSTR(v_new, CHR(10) || 'PROCEDURE P_DMF0082_SAVE_MAIN_DATA' || CHR(10));
    v_s1  := DBMS_LOB.INSTR(v_new, CHR(10) || 'PROCEDURE P_DMF0082_GET_EXCEL_FORM_DATA');
    IF cnt(v_new, c_st1, v_s0, v_s1) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — D1 Phase1 DELETE 대상 신 블록이 SAVE_MAIN_DATA 구간에 1건이 아님. 원문 무변경');
    END IF;
    v_pos := DBMS_LOB.INSTR(v_new, c_st1, v_s0) + 1;               -- 신 블록 첫 글자
    v_e   := DBMS_LOB.INSTR(v_new, c_en1, v_pos);                  -- 마지막 줄 시작
    v_end := DBMS_LOB.INSTR(v_new, CHR(10), v_e);                     -- 마지막 줄 끝 LF
    IF v_e = 0 OR v_end = 0 OR v_end > v_s1 OR v_end - v_pos > 1000 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — D1 Phase1 DELETE 대상 신 블록 끝 위치 이상. 원문 무변경');
    END IF;
    v_new := SUBSTR(v_new, 1, v_pos - 1) || c_old1 || SUBSTR(v_new, v_end + 1);
    v_s0  := DBMS_LOB.INSTR(v_new, CHR(10) || 'PROCEDURE P_DMF0082_SAVE_MAIN_DATA' || CHR(10));
    v_s1  := DBMS_LOB.INSTR(v_new, CHR(10) || 'PROCEDURE P_DMF0082_GET_EXCEL_FORM_DATA');
    IF cnt(v_new, c_st2, v_s0, v_s1) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — D2 Phase1 DELETE 내부 신 블록이 SAVE_MAIN_DATA 구간에 1건이 아님. 원문 무변경');
    END IF;
    v_pos := DBMS_LOB.INSTR(v_new, c_st2, v_s0) + 1;               -- 신 블록 첫 글자
    v_e   := DBMS_LOB.INSTR(v_new, c_en2, v_pos);                  -- 마지막 줄 시작
    v_end := DBMS_LOB.INSTR(v_new, CHR(10), v_e);                     -- 마지막 줄 끝 LF
    IF v_e = 0 OR v_end = 0 OR v_end > v_s1 OR v_end - v_pos > 1000 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — D2 Phase1 DELETE 내부 신 블록 끝 위치 이상. 원문 무변경');
    END IF;
    v_new := SUBSTR(v_new, 1, v_pos - 1) || c_old2 || SUBSTR(v_new, v_end + 1);
    v_s0  := DBMS_LOB.INSTR(v_new, CHR(10) || 'PROCEDURE P_DMF0082_SAVE_MAIN_DATA' || CHR(10));
    v_s1  := DBMS_LOB.INSTR(v_new, CHR(10) || 'PROCEDURE P_DMF0082_GET_EXCEL_FORM_DATA');
    IF cnt(v_new, c_st3, v_s0, v_s1) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — M1 MERGE 소스 신 블록이 SAVE_MAIN_DATA 구간에 1건이 아님. 원문 무변경');
    END IF;
    v_pos := DBMS_LOB.INSTR(v_new, c_st3, v_s0) + 1;               -- 신 블록 첫 글자
    v_e   := DBMS_LOB.INSTR(v_new, c_en3, v_pos);                  -- 마지막 줄 시작
    v_end := DBMS_LOB.INSTR(v_new, CHR(10), v_e);                     -- 마지막 줄 끝 LF
    IF v_e = 0 OR v_end = 0 OR v_end > v_s1 OR v_end - v_pos > 1000 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — M1 MERGE 소스 신 블록 끝 위치 이상. 원문 무변경');
    END IF;
    v_new := SUBSTR(v_new, 1, v_pos - 1) || c_old3 || SUBSTR(v_new, v_end + 1);
    v_s0  := DBMS_LOB.INSTR(v_new, CHR(10) || 'PROCEDURE P_DMF0082_SAVE_MAIN_DATA' || CHR(10));
    v_s1  := DBMS_LOB.INSTR(v_new, CHR(10) || 'PROCEDURE P_DMF0082_GET_EXCEL_FORM_DATA');
    IF cnt(v_new, c_st4, v_s0, v_s1) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — M2 MERGE INSERT 조건 신 블록이 SAVE_MAIN_DATA 구간에 1건이 아님. 원문 무변경');
    END IF;
    v_pos := DBMS_LOB.INSTR(v_new, c_st4, v_s0) + 1;               -- 신 블록 첫 글자
    v_e   := DBMS_LOB.INSTR(v_new, c_en4, v_pos);                  -- 마지막 줄 시작
    v_end := DBMS_LOB.INSTR(v_new, CHR(10), v_e);                     -- 마지막 줄 끝 LF
    IF v_e = 0 OR v_end = 0 OR v_end > v_s1 OR v_end - v_pos > 1000 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — M2 MERGE INSERT 조건 신 블록 끝 위치 이상. 원문 무변경');
    END IF;
    v_new := SUBSTR(v_new, 1, v_pos - 1) || c_old4 || SUBSTR(v_new, v_end + 1);
    IF cnt(v_new, c_mark, 1, DBMS_LOB.GETLENGTH(v_new)) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치(마커 잔존). 원문 무변경');
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원 (2026-10-15 GAP452 리허설 사고 정정)
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;
