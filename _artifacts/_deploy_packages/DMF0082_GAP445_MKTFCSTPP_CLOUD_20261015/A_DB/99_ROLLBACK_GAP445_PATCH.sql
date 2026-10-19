-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL=2026-10-15 14:12:14 FETCHED=2026-10-15 14:21 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 99_ROLLBACK — [GAP445 2026-10-15] GAP 445 원복 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 10_APPLY 가 넣은 블록 2개(각 '빈 줄 + ASCII 마커 줄 ~ 첫 END IF --[DIV81]')를 지운다 — 한글 주석 비교에 의존하지 않는다.
-- 가드: 마커 없음 → 무동작 · 블록 위치 이상 → 중단(원문 무변경) · 컴파일 오류 → 원문 자동 복원
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    v_m0     PLS_INTEGER;
    v_m1     PLS_INTEGER;
    v_cb     PLS_INTEGER;
    v_mb     PLS_INTEGER;
    v_sb     PLS_INTEGER;
    v_pos    PLS_INTEGER;
    v_end    PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)  := 'GAP445 2026-10-15';
    c_enddiv CONSTANT VARCHAR2(100) := CHR(10) || '        END IF;  --[DIV81]' || CHR(10) || '';
    c_br_cur CONSTANT VARCHAR2(200) := CHR(10) || '    IF p_version_type LIKE ''%Current%'' OR p_version_type LIKE ''%current%'' THEN' || CHR(10) || '';
    c_br_mf  CONSTANT VARCHAR2(200) := CHR(10) || '    IF p_version_type LIKE ''%MF%'' THEN' || CHR(10) || '';
    c_br_sf  CONSTANT VARCHAR2(200) := CHR(10) || '    IF p_version_type LIKE ''%SF%'' THEN' || CHR(10) || '';
    c_st_cur CONSTANT VARCHAR2(200) := CHR(10) || CHR(10) || '        /* [GAP445 2026-10-15] MKT_FCST [P+P] Current';   -- 빈 줄 + 마커 줄 시작 (ASCII)
    c_st_mf  CONSTANT VARCHAR2(200) := CHR(10) || CHR(10) || '        /* [GAP445 2026-10-15] MKT_FCST [P+P] MF';
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
    PROCEDURE locate(p_src CLOB) IS
    BEGIN
        v_m0 := DBMS_LOB.INSTR(p_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA' || CHR(10));
        v_m1 := DBMS_LOB.INSTR(p_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT');
        v_cb := DBMS_LOB.INSTR(p_src, c_br_cur, v_m0);
        v_mb := DBMS_LOB.INSTR(p_src, c_br_mf, v_m0);
        v_sb := DBMS_LOB.INSTR(p_src, c_br_sf, v_m0);
        IF NOT (v_m0 > 0 AND v_m0 < v_cb AND v_cb < v_mb AND v_mb < v_sb AND v_sb < v_m1) THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — GET_MAIN_DATA 의 Current/MF/SF 분기 위치 확인 불가. 00_PRECHECK L1 회신. 원문 무변경');
        END IF;
    END;
    PROCEDURE cut(p_tok VARCHAR2, p_lo PLS_INTEGER, p_hi PLS_INTEGER, p_name VARCHAR2) IS
    BEGIN
        IF cnt(v_new, p_tok, p_lo, p_hi) <> 1 THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 블록이 해당 분기에 1건이 아님. 원문 무변경');
        END IF;
        v_pos := DBMS_LOB.INSTR(v_new, p_tok, p_lo);                 -- 앞 END IF 줄 끝 LF
        v_end := DBMS_LOB.INSTR(v_new, c_enddiv, v_pos + 2);          -- 블록 마지막 END IF 줄 앞 LF
        IF v_end = 0 OR v_end > p_hi OR v_end - v_pos > 30000 THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — ' || p_name || ' 블록 끝 위치 이상. 원문 무변경');
        END IF;
        v_new := SUBSTR(v_new, 1, v_pos) || SUBSTR(v_new, v_end + LENGTH(c_enddiv));
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 마커 ' || cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) || '곳 (2 기대). 원문 무변경');
    END IF;
    v_new := v_src;
    locate(v_new);
    cut(c_st_mf, v_mb, v_sb, 'MF');          -- 뒤쪽 먼저 (앞쪽 위치 불변)
    locate(v_new);
    cut(c_st_cur, v_cb, v_mb, 'Current');
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
