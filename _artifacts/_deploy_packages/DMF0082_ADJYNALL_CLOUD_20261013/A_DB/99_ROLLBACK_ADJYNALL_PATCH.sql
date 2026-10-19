-- 99 ROLLBACK — [E20261013-DMF0082ADJYNALL] 역치환 (이 DB 의 USER_SOURCE 를 읽어 주석 처리한 8줄을 되살린 뒤 CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 되돌린 뒤 마커 0 이어야 실행. ⚠ 되돌리면 조정 제외(N) 품목은 다시 판가 없이 저장된다.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'E20261013-DMF0082ADJYNALL';
    c_old   CONSTANT VARCHAR2(32767) :=   -- 단가 검증 제외조건 8줄 (원문)
        '          AND NOT EXISTS (SELECT 1' || CHR(10) ||
        '                            FROM SCM_MGR.SCM_MST_SITE_ITEM Z' || CHR(10) ||
        '                           WHERE Z.DIVISION_ID  = A.DIVISION_ID' || CHR(10) ||
        '                             AND Z.PROJECT_CODE = A.PROJECT_CODE' || CHR(10) ||
        '                             AND Z.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10) ||
        '                             AND Z.ITEM_ID      = A.ITEM_ID' || CHR(10) ||
        '                             AND Z.VALID_YN     = ''Y''' || CHR(10) ||
        '                             AND Z.SALES_PLAN_ADJUST_YN = ''N'')' || CHR(10);
    c_new   CONSTANT VARCHAR2(32767) :=   -- 같은 8줄을 줄 주석 처리 + 설명 2줄
        '          --[E20261013-DMF0082ADJYNALL] 사용자 요청(2026-10-13): 판매계획 조정 제외(SALES_PLAN_ADJUST_YN=''N'') 품목도 단가 검증 대상.' || CHR(10) ||
        '          --  아래 제외조건 8줄 주석 처리 — 종전에는 이 품목이 판가 없이 수량 저장됐다(AS-IS 동일 예외 → 의도적 강화).' || CHR(10) ||
        '--          AND NOT EXISTS (SELECT 1' || CHR(10) ||
        '--                            FROM SCM_MGR.SCM_MST_SITE_ITEM Z' || CHR(10) ||
        '--                           WHERE Z.DIVISION_ID  = A.DIVISION_ID' || CHR(10) ||
        '--                             AND Z.PROJECT_CODE = A.PROJECT_CODE' || CHR(10) ||
        '--                             AND Z.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10) ||
        '--                             AND Z.ITEM_ID      = A.ITEM_ID' || CHR(10) ||
        '--                             AND Z.VALID_YN     = ''Y''' || CHR(10) ||
        '--                             AND Z.SALES_PLAN_ADJUST_YN = ''N'')' || CHR(10);
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
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (앵커는 LF 기준)
    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_new) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용 문구 매칭 ' || cnt(v_src, c_new) || '건 (1 기대). 원문 무변경');
    END IF;
    v_new := REPLACE(v_src, c_new, c_old);
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존');
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
