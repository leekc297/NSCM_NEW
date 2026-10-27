-- 10_APPLY — [E20261027-DMF0082LASTUPDORD] PKG_DMF0082 BODY 패치 (전체 F5 · 값 입력 없음 · 멱등)
-- 내용: DMF0082 조회 프로시저 2종(P_DMF0082_GET_MAIN_DATA · P_DMF0082_GET_MAIN_DATA_CURRENT)의 정렬 키(V_ORDERBY)에서
--       LAST_UPDATED_BY · LAST_UPDATE_DATE 를 뺀다. [E20261027-DMF0082LASTUPD](줄 묶음 제외)와 짝 — 두 컬럼은 참고값이라
--       Column Set 에 넣어도 줄 순서는 키 컬럼으로만 정한다. 두 컬럼을 고르지 않으면 정렬 키는 원래 값 그대로.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 C_TITLE 루프 끝(END LOOP; CLOSE C_TITLE;) 2곳 뒤에 1문장씩 끼워 넣고 CREATE OR REPLACE (사내 전체본 복사 아님 · 기존 문장 무변경)
-- 가드: 마커 있으면 무동작 · 앵커 2건 아니거나 위치가 두 조회 프로시저와 다르면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 선행: DMF0082_LASTUPD_CLOUD_20261027 (클라우드 적용 확인됨 — 없어도 이 패치는 독립 동작)
-- 사내 ZIOUI1 적용 완료 2026-10-27 15:45:34 (40케이스 전후 비교 PASS). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src  CLOB;
    v_new  CLOB;
    v_st   VARCHAR2(30);
    v_err  PLS_INTEGER;
    v_p1   PLS_INTEGER;
    v_p2   PLS_INTEGER;
    v_cs   PLS_INTEGER;
    v_ce   PLS_INTEGER;
    c_mark CONSTANT VARCHAR2(40) := 'E20261027-DMF0082LASTUPDORD';
    c_anc  CONSTANT VARCHAR2(200) :=   -- 앵커: C_TITLE 루프 끝 2줄 (두 조회 프로시저에 1회씩)
        '    END LOOP;' || CHR(10) ||
        '    CLOSE C_TITLE;' || CHR(10);
    c_blk  CONSTANT VARCHAR2(32767) :=   -- 삽입: 정렬 키에서 두 참고값 컬럼 제거 1문장
        '' || CHR(10) ||
        '    --[E20261027-DMF0082LASTUPDORD] LAST UPDATED BY · LAST UPDATE DATE 는 참고값 — 정렬 키에서도 뺀다 (사용자 요청 2026-10-27).' || CHR(10) ||
        '    --  [E20261027-DMF0082LASTUPD] 로 줄 묶음에서 뺀 것과 같은 기준: 두 컬럼을 Column Set 에 넣어도 줄 순서는 키 컬럼으로만 정한다.' || CHR(10) ||
        '    --  V_ORDERBY 는 '' ORDER BY SORT_KEY, 컬럼, 컬럼…'' 형태라 '', 컬럼'' 토큰만 제거한다(두 컬럼이 없으면 원래 값 그대로).' || CHR(10) ||
        '    V_ORDERBY := RTRIM(REPLACE(REPLACE(V_ORDERBY || '','', '', LAST_UPDATED_BY,'', '',''), '', LAST_UPDATE_DATE,'', '',''), '','');' || CHR(10);
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
    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_anc) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 앵커 매칭 ' || cnt(v_src, c_anc) || '건 (2 기대) → 00_PRECHECK L1 회신. 원문 무변경');
    END IF;
    v_p1 := DBMS_LOB.INSTR(v_src, c_anc, 1, 1);
    v_p2 := DBMS_LOB.INSTR(v_src, c_anc, 1, 2);
    v_cs := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT');
    v_ce := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_SPREAD_TITLE');
    IF NOT (v_cs > 0 AND v_ce > 0 AND v_p1 < v_cs AND v_cs < v_p2 AND v_p2 < v_ce) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 앵커 위치가 GET_MAIN_DATA / GET_MAIN_DATA_CURRENT 순서와 다름. 원문 무변경');
    END IF;
    v_new := SUBSTR(v_src, 1, v_p1 + LENGTH(c_anc) - 1) || c_blk
          || SUBSTR(v_src, v_p1 + LENGTH(c_anc), v_p2 - v_p1)
          || c_blk
          || SUBSTR(v_src, v_p2 + LENGTH(c_anc));
    IF cnt(v_new, c_mark) <> 2 OR cnt(v_new, c_anc || c_blk) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치 (마커 ' || cnt(v_new, c_mark) || '곳, 2 기대). 원문 무변경');
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
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 ' || cnt(v_new, c_mark) || '곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;
