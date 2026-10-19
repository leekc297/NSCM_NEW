-- 10_APPLY — [E20261013-DMF0082MANDRET] PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082 조회 프로시저 2종(P_DMF0082_GET_MAIN_DATA · P_DMF0082_GET_MAIN_DATA_CURRENT)이
--       화면 필수 표시 컬럼을 사용자 Column Set 저장 내역과 무관하게 항상 결과에 넣도록 한다.
--       필수 컬럼 = 컬럼 메타(SCM_MST_SHEET_COLUMNS)에서 USER_SELECTABLE_FLAG = 'N' · VISIBLE_FLAG = 'Y' · VALID_YN = 'Y' 이고
--                   DIVISION_ID 목록에 조회 사업부가 들어 있는 컬럼 (화면이 항상 표시하는 것과 같은 규칙)
-- 배경: AS From Site 를 필수 표시로 바꾼 뒤 컬럼은 보이는데 값이 빈칸 (클라우드 QA 10-13 minyonglee1 — Column Set 저장 내역에 이 컬럼 없음).
--       조회 SP 는 Column Set 저장 내역에 있는 컬럼과 저장 키 12컬럼만 내려주고 있었다.
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 저장 키 루프 뒤 2곳에 루프를 끼워 넣은 뒤 CREATE OR REPLACE (사내 전체본 복사 아님 — 기존 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 앵커 2건 아니거나 위치가 두 조회 프로시저와 다르면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 2026-10-13 17:48:59 (같은 삽입 · 전후 비교 12케이스 통과). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_p1    PLS_INTEGER;
    v_p2    PLS_INTEGER;
    v_cur   PLS_INTEGER;
    v_nxt   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'E20261013-DMF0082MANDRET';
    c_anc   CONSTANT VARCHAR2(32767) :=   -- 앵커: 저장 키 강제 추가 루프의 끝 5줄 (두 조회 프로시저에 1회씩)
        '        IF INSTR('','' || REPLACE(V_COLUMN, '' '', '''') || '','', '','' || K.C || '','') = 0 THEN' || CHR(10) ||
        '            V_COLUMN  := V_COLUMN  || '', '' || K.C;' || CHR(10) ||
        '            V_GROUPBY := V_GROUPBY || '', '' || K.C;' || CHR(10) ||
        '        END IF;' || CHR(10) ||
        '    END LOOP;' || CHR(10);
    c_blk1  CONSTANT VARCHAR2(32767) :=   -- 삽입 1: P_DMF0082_GET_MAIN_DATA (피벗 원천 GT_DMF0082_MF_SP)
        '' || CHR(10) ||
        '    --[E20261013-DMF0082MANDRET] 화면 필수 표시 컬럼은 Column Setting 과 무관하게 항상 반환한다 (사용자 신고 2026-10-13).' || CHR(10) ||
        '    --  화면은 필수 컬럼(메타 USER_SELECTABLE_FLAG=''N'' + VISIBLE_FLAG=''Y'')을 사용자 컬럼 저장 내역에 없어도 항상 표시한다.' || CHR(10) ||
        '    --  위 루프는 저장 키 12컬럼만 보장하므로, 그 밖의 필수 컬럼은 저장 내역에 없는 사용자에게 값이 내려가지 않았다' || CHR(10) ||
        '    --  (실측: AS_FROM_SITE 를 필수로 바꾼 뒤 컬럼은 보이고 값이 빈칸).' || CHR(10) ||
        '    --  판정식 = [E20261012-DMF0082MANDCOL] 과 같은 메타 · division 토큰 규칙. 최종 피벗 원천에 실제로 있는 컬럼만 넣는다' || CHR(10) ||
        '    --  (없는 컬럼이 필수로 등록돼도 ORA-00904 가 나지 않게). 이미 있으면 넣지 않는다(멱등).' || CHR(10) ||
        '    FOR K IN ( SELECT C.COLUMN_NAME AS C' || CHR(10) ||
        '                 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C' || CHR(10) ||
        '                WHERE C.PROGRAM_ID  = VA_PROGRAM_ID' || CHR(10) ||
        '                  AND C.SHEET_NAME  = VA_SHEET_NAME' || CHR(10) ||
        '                  AND C.VALID_YN    = ''Y''' || CHR(10) ||
        '                  AND C.USER_SELECTABLE_FLAG = ''N''' || CHR(10) ||
        '                  AND C.VISIBLE_FLAG = ''Y''' || CHR(10) ||
        '                  AND (C.DIVISION_ID IS NULL OR INSTR('','' || C.DIVISION_ID || '','', '','' || p_division_id || '','') > 0)' || CHR(10) ||
        '                  AND C.COLUMN_NAME IN ( SELECT T.COLUMN_NAME FROM USER_TAB_COLUMNS T WHERE T.TABLE_NAME = ''GT_DMF0082_MF_SP'' )' || CHR(10) ||
        '                ORDER BY C.SORT_ORDER_NO, C.COLUMN_NAME ) LOOP' || CHR(10) ||
        '        IF INSTR('','' || REPLACE(V_COLUMN, '' '', '''') || '','', '','' || K.C || '','') = 0 THEN' || CHR(10) ||
        '            V_COLUMN  := V_COLUMN  || '', '' || K.C;' || CHR(10) ||
        '            V_GROUPBY := V_GROUPBY || '', '' || K.C;' || CHR(10) ||
        '        END IF;' || CHR(10) ||
        '    END LOOP;' || CHR(10);
    c_blk2  CONSTANT VARCHAR2(32767) :=   -- 삽입 2: P_DMF0082_GET_MAIN_DATA_CURRENT (피벗 원천 GTT_MF_SP)
        '' || CHR(10) ||
        '    --[E20261013-DMF0082MANDRET] 화면 필수 표시 컬럼은 Column Setting 과 무관하게 항상 반환한다 (사용자 신고 2026-10-13).' || CHR(10) ||
        '    --  화면은 필수 컬럼(메타 USER_SELECTABLE_FLAG=''N'' + VISIBLE_FLAG=''Y'')을 사용자 컬럼 저장 내역에 없어도 항상 표시한다.' || CHR(10) ||
        '    --  위 루프는 저장 키 12컬럼만 보장하므로, 그 밖의 필수 컬럼은 저장 내역에 없는 사용자에게 값이 내려가지 않았다' || CHR(10) ||
        '    --  (실측: AS_FROM_SITE 를 필수로 바꾼 뒤 컬럼은 보이고 값이 빈칸).' || CHR(10) ||
        '    --  판정식 = [E20261012-DMF0082MANDCOL] 과 같은 메타 · division 토큰 규칙. 최종 피벗 원천에 실제로 있는 컬럼만 넣는다' || CHR(10) ||
        '    --  (없는 컬럼이 필수로 등록돼도 ORA-00904 가 나지 않게). 이미 있으면 넣지 않는다(멱등).' || CHR(10) ||
        '    FOR K IN ( SELECT C.COLUMN_NAME AS C' || CHR(10) ||
        '                 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C' || CHR(10) ||
        '                WHERE C.PROGRAM_ID  = VA_PROGRAM_ID' || CHR(10) ||
        '                  AND C.SHEET_NAME  = VA_SHEET_NAME' || CHR(10) ||
        '                  AND C.VALID_YN    = ''Y''' || CHR(10) ||
        '                  AND C.USER_SELECTABLE_FLAG = ''N''' || CHR(10) ||
        '                  AND C.VISIBLE_FLAG = ''Y''' || CHR(10) ||
        '                  AND (C.DIVISION_ID IS NULL OR INSTR('','' || C.DIVISION_ID || '','', '','' || p_division_id || '','') > 0)' || CHR(10) ||
        '                  AND C.COLUMN_NAME IN ( SELECT T.COLUMN_NAME FROM USER_TAB_COLUMNS T WHERE T.TABLE_NAME = ''GTT_MF_SP'' )' || CHR(10) ||
        '                ORDER BY C.SORT_ORDER_NO, C.COLUMN_NAME ) LOOP' || CHR(10) ||
        '        IF INSTR('','' || REPLACE(V_COLUMN, '' '', '''') || '','', '','' || K.C || '','') = 0 THEN' || CHR(10) ||
        '            V_COLUMN  := V_COLUMN  || '', '' || K.C;' || CHR(10) ||
        '            V_GROUPBY := V_GROUPBY || '', '' || K.C;' || CHR(10) ||
        '        END IF;' || CHR(10) ||
        '    END LOOP;' || CHR(10);
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
        RAISE_APPLICATION_ERROR(-20001, '중단 — 저장 키 루프 끝 앵커 매칭 ' || cnt(v_src, c_anc) || '건 (2 기대). 원문이 사내 기준과 다름 → 00_PRECHECK L1 확인. 원문 무변경');
    END IF;
    v_p1  := DBMS_LOB.INSTR(v_src, c_anc, 1, 1);
    v_p2  := DBMS_LOB.INSTR(v_src, c_anc, 1, 2);
    v_cur := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT');
    v_nxt := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_SPREAD_TITLE');
    IF NOT (v_cur > 0 AND v_nxt > 0 AND v_p1 < v_cur AND v_cur < v_p2 AND v_p2 < v_nxt) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 앵커 위치가 GET_MAIN_DATA / GET_MAIN_DATA_CURRENT 순서와 다름. 원문 무변경');
    END IF;
    -- 뒤쪽(2번째)부터 끼워 넣는다 — 앞쪽 위치가 밀리지 않게
    v_new := DBMS_LOB.SUBSTR(v_src, 1, 1);   -- CLOB 초기화용 (아래에서 다시 조립)
    v_new := SUBSTR(v_src, 1, v_p1 + LENGTH(c_anc) - 1) || c_blk1
          || SUBSTR(v_src, v_p1 + LENGTH(c_anc), v_p2 - v_p1)
          || c_blk2
          || SUBSTR(v_src, v_p2 + LENGTH(c_anc));
    IF cnt(v_new, c_mark) <> 2 OR cnt(v_new, c_anc || c_blk1) <> 1 OR cnt(v_new, c_anc || c_blk2) <> 1 THEN
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
