-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL=2026-10-15 11:10:16 FETCHED=2026-10-15 11:32 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [GAP439 2026-10-15] GAP 439 PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082 조회 P_DMF0082_GET_MAIN_DATA 의 버전 토큰 적재 1문장을 바꾼다.
--       버전 팝업(DMF0073_GET_VERSION_SALESPRICE)이 돌려주는 값 = VERSION_NO||'(주차)'[||' (NO PLAN)'] 이 그대로 넘어와
--       DM_MST_VERSION.VERSION_NO 정확 조인이 0건 → Current 외 버전 조회 불가.
--       Current 가 아닌 토큰은 첫 '(' 이후를 잘라 순수 VERSION_NO 로 적재한다. Current 는 그대로.
-- 범위: 조회 SP 1문장(1줄 → 8줄). 원장 · 저장 · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 GET_MAIN_DATA 구간의 ASCII 구 문장 1줄을 블록으로 치환하고 CREATE OR REPLACE
--       (사내 전체본 복사 아님 — 다른 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 구 문장이 구간 안 1건이 아니면 중단(원문 무변경) · 조립 길이 불일치 시 중단
--       · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL 2026-10-15 11:10:16) — 81 MF_W_20260930_V001(W40) 0→498건 · Current 7,148 불변.
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_main  PLS_INTEGER;
    v_cur   PLS_INTEGER;
    v_pos   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'GAP439 2026-10-15';
    c_old   CONSTANT VARCHAR2(400) :=   -- 구 문장 (ASCII 한 줄 · GET_MAIN_DATA 구간 안 1건)
        '    SELECT ''p_version_type'', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_version_type, '',''));' || CHR(10);
    c_block CONSTANT VARCHAR2(32767) :=   -- 치환 블록 (사내 적용본과 동일 문구)
        '    /* [GAP439 2026-10-15] 버전 팝업 반환값 = VERSION_NO||''(주차)''[||'' (NO PLAN)''] (DMF0073_GET_VERSION_SALESPRICE) 이 FE 를 거쳐 그대로 유입 →' || CHR(10) ||
        '       DM_MST_VERSION.VERSION_NO 정확 조인 0건(Current 외 버전 조회 불가). Current 가 아닌 토큰은 첫 ''('' 이후를 잘라 순수 VERSION_NO 로 적재' || CHR(10) ||
        '       (DM_MST_VERSION.VERSION_NO 에 ''('' 포함 행 0건 실측 — 절단이 실버전을 훼손하지 않음). */' || CHR(10) ||
        '    SELECT ''p_version_type''' || CHR(10) ||
        '         , CASE WHEN UPPER(COLUMN_VALUE) LIKE ''%CURRENT%'' THEN COLUMN_VALUE' || CHR(10) ||
        '                ELSE TRIM(REGEXP_REPLACE(COLUMN_VALUE, ''\(.*$'', ''''))' || CHR(10) ||
        '           END' || CHR(10) ||
        '    FROM TABLE(UF_FX_String_SplitForIN(p_version_type, '',''));' || CHR(10);
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
    v_src  := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_main := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA' || CHR(10));
    v_cur  := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT');
    IF NOT (v_main > 0 AND v_main < v_cur) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 조회 프로시저 위치 확인 불가 (GET_MAIN_DATA / _CURRENT). 원문 무변경');
    END IF;
    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, CHR(10) || c_old, v_main, v_cur) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 구 문장이 GET_MAIN_DATA 구간에 ' || cnt(v_src, CHR(10) || c_old, v_main, v_cur) || '건 (1 기대). 00_PRECHECK L1 회신. 원문 무변경');
    END IF;
    v_pos := DBMS_LOB.INSTR(v_src, CHR(10) || c_old, v_main) + 1;   -- 구 문장 첫 글자
    v_new := SUBSTR(v_src, 1, v_pos - 1) || c_block || SUBSTR(v_src, v_pos + LENGTH(c_old));
    IF cnt(v_new, c_mark, 1, DBMS_LOB.GETLENGTH(v_new)) <> 1
       OR cnt(v_new, CHR(10) || c_old, 1, DBMS_LOB.GETLENGTH(v_new)) <> 0
       OR DBMS_LOB.GETLENGTH(v_new) <> DBMS_LOB.GETLENGTH(v_src) - LENGTH(c_old) + LENGTH(c_block) THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치. 원문 무변경');
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
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 1곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;
