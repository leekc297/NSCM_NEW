-- 99 ROLLBACK — [E20261014-DMF0082VMICURR] 역치환 (이 DB 의 USER_SOURCE 를 읽어 치환한 6곳을 원문으로 되돌린 뒤 CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 되돌린 뒤 마커 0 이어야 실행. ⚠ 되돌리면 VMI 메저 행의 CURRENCY 가 다시 빈칸으로 나온다.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_main  PLS_INTEGER;
    v_cur   PLS_INTEGER;
    v_nxt   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'E20261014-DMF0082VMICURR';
    c_old1  CONSTANT VARCHAR2(32767) :=   -- 원문 1: 백필 MERGE 3곳 (GET_MAIN_DATA 1차·2차·3차) — 기대 3건
        '    WHERE  A.CURRENCY IS NULL' || CHR(10) ||
        '    AND    A.MEASURE NOT LIKE ''VMI%''' || CHR(10) ||
        '    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD;' || CHR(10);
    c_new1  CONSTANT VARCHAR2(32767) :=   -- 적용문 1
        '    WHERE  A.CURRENCY IS NULL' || CHR(10) ||
        '    --[E20261014-DMF0082VMICURR] VMI 도 LOC 통화 표시 (사용자 요청 2026-10-14) — 원문: AND    A.MEASURE NOT LIKE ''VMI%''' || CHR(10) ||
        '    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD;' || CHR(10);
    c_old2  CONSTANT VARCHAR2(32767) :=   -- 원문 2: 백필 MERGE 1곳 (GET_MAIN_DATA_CURRENT) — 기대 1건
        '            AND   A.CURRENCY IS NULL                                   /* ISNULL(A.CURRENCY,'''')='''' → IS NULL (C-7) */' || CHR(10) ||
        '            AND   A.MEASURE NOT LIKE ''VMI%'';' || CHR(10);
    c_new2  CONSTANT VARCHAR2(32767) :=   -- 적용문 2
        '            AND   A.CURRENCY IS NULL                                   /* ISNULL(A.CURRENCY,'''')='''' → IS NULL (C-7) */' || CHR(10) ||
        '            --[E20261014-DMF0082VMICURR] VMI 도 LOC 통화 표시 (사용자 요청 2026-10-14) — 원문: AND   A.MEASURE NOT LIKE ''VMI%'';' || CHR(10) ||
        '            ;' || CHR(10);
    c_old3  CONSTANT VARCHAR2(32767) :=   -- 원문 3: CURRNORM 2곳 (두 조회 프로시저) — 기대 2건
        '    --   VMI 계열은 AS-IS(IIF(MEASURE LIKE ''VMI%'','''',CURRENCY) · 백필 제외)와 동일하게 항상 공백.' || CHR(10) ||
        '    AND    (   MEASURE LIKE ''VMI%''' || CHR(10) ||
        '            OR CURRENCY IS NULL OR TRIM(CURRENCY) IS NULL OR TRIM(CURRENCY) = ''/'');' || CHR(10);
    c_new3  CONSTANT VARCHAR2(32767) :=   -- 적용문 3
        '    --   VMI 계열은 AS-IS(IIF(MEASURE LIKE ''VMI%'','''',CURRENCY) · 백필 제외)와 동일하게 항상 공백.' || CHR(10) ||
        '    --[E20261014-DMF0082VMICURR] VMI 도 LOC 통화 표시 (사용자 요청 2026-10-14) — VMI 공백 강제를 풀어 백필된 LOC 통화를 보존한다(셀 병합).' || CHR(10) ||
        '    --   원문: AND    (   MEASURE LIKE ''VMI%''' || CHR(10) ||
        '    --               OR CURRENCY IS NULL OR TRIM(CURRENCY) IS NULL OR TRIM(CURRENCY) = ''/'');' || CHR(10) ||
        '    AND    (   CURRENCY IS NULL OR TRIM(CURRENCY) IS NULL OR TRIM(CURRENCY) = ''/'');' || CHR(10);
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
    -- 토큰이 전부 GET_MAIN_DATA ~ GET_SPREAD_TITLE 구간(두 조회 프로시저) 안에 있는가
    FUNCTION in_scope(p_src CLOB, p_tok VARCHAR2) RETURN BOOLEAN IS
        pos PLS_INTEGER := 1;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL;
            IF pos < v_main OR pos > v_nxt THEN RETURN FALSE; END IF;
            pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN TRUE;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src  := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_main := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA' || CHR(10));
    v_cur  := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT');
    v_nxt  := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_SPREAD_TITLE');
    IF NOT (v_main > 0 AND v_main < v_cur AND v_cur < v_nxt) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 조회 프로시저 위치 확인 불가 (GET_MAIN_DATA / _CURRENT / GET_SPREAD_TITLE). 원문 무변경');
    END IF;
    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_new1) <> 3 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용문 1 매칭 ' || cnt(v_src, c_new1) || '건 (3 기대). 원문 무변경');
    END IF;
    IF cnt(v_src, c_new2) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용문 2 매칭 ' || cnt(v_src, c_new2) || '건 (1 기대). 원문 무변경');
    END IF;
    IF cnt(v_src, c_new3) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용문 3 매칭 ' || cnt(v_src, c_new3) || '건 (2 기대). 원문 무변경');
    END IF;
    v_new := v_src;
    v_new := REPLACE(v_new, c_new1, c_old1);
    v_new := REPLACE(v_new, c_new2, c_old2);
    v_new := REPLACE(v_new, c_new3, c_old3);
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
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
