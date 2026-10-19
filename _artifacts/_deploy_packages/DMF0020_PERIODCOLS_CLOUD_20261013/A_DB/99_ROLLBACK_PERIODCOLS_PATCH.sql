-- 99_ROLLBACK — [E20261013-DMF0020PERIODCOLS] 역치환 (이 DB 의 USER_SOURCE 를 읽어 해당 줄을 원문으로 되돌린 뒤 CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 되돌린 뒤 마커 0 이어야 실행.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'E20261013-DMF0020PERIODCOLS';
    c_old1  CONSTANT VARCHAR2(32767) :=   -- PIVOT 컬럼 목록 루프 (원문)
        '    FOR REC IN (SELECT DISTINCT YYYYMMDD FROM SCM_MGR.GT_FTPR_TMPOUTPUT ORDER BY YYYYMMDD) LOOP' || CHR(10);
    c_new1  CONSTANT VARCHAR2(32767) :=   -- PIVOT 컬럼 목록 루프 (변경)
        '    /* [E20261013-DMF0020PERIODCOLS] 기간 컬럼 = 조회 Period 전체 구간(달력) + 조회된 데이터의 날짜.' || CHR(10) ||
        '       종전: 조회된 데이터의 날짜만 -> 일부 주만 판가가 있는 Sales Site 로 조회하면 그 주만 컬럼이 됐다.' || CHR(10) ||
        '       달력 기준은 헤더 SP(P_DMF0020_GET_SPREAD_TITLE_DATE)와 같다: 주 = BASIS_START_DATE / 월 = BASIS_YYYYMM.' || CHR(10) ||
        '       데이터 쪽은 그대로 합친다 (달력 주 시작일과 다른 날짜로 저장된 판가도 종전처럼 컬럼이 된다).' || CHR(10) ||
        '       원문: FOR REC IN (SELECT DISTINCT YYYYMMDD FROM SCM_MGR.GT_FTPR_TMPOUTPUT ORDER BY YYYYMMDD) LOOP */' || CHR(10) ||
        '    FOR REC IN (SELECT YYYYMMDD FROM SCM_MGR.GT_FTPR_TMPOUTPUT' || CHR(10) ||
        '                UNION' || CHR(10) ||
        '                SELECT ''W_'' || C.BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M C' || CHR(10) ||
        '                 WHERE C.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD' || CHR(10) ||
        '                   AND C.BASIS_START_DATE IS NOT NULL' || CHR(10) ||
        '                UNION' || CHR(10) ||
        '                SELECT ''M_'' || C.BASIS_YYYYMM || ''01'' FROM SCM_MGR.SCM_SYS_CALENDAR_M C' || CHR(10) ||
        '                 WHERE C.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD' || CHR(10) ||
        '                   AND C.BASIS_YYYYMM IS NOT NULL' || CHR(10) ||
        '                ORDER BY 1) LOOP' || CHR(10);
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
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0020' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (앵커는 LF 기준)
    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_new1) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20011, '중단 — [PIVOT 컬럼 목록 루프] 적용 블록 매칭 ' || cnt(v_src, c_new1) || '건 (1 기대). 원문 무변경');
    END IF;
    v_new := REPLACE(v_src, c_new1, c_old1);
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0020' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0020' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0020' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0020 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0020' ORDER BY OBJECT_TYPE;
