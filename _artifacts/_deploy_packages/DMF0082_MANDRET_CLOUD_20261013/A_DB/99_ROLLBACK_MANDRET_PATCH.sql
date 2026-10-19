-- 99 ROLLBACK — [E20261013-DMF0082MANDRET] 역치환 (이 DB 의 USER_SOURCE 를 읽어 끼워 넣은 2곳을 걷어낸 뒤 CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 걷어낸 뒤 마커 0 이어야 실행. ⚠ 되돌리면 필수 표시 컬럼이 Column Set 저장 내역에 없는 사용자에게 다시 빈칸으로 나온다.
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
    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_anc || c_blk1) <> 1 OR cnt(v_src, c_anc || c_blk2) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용 문구 매칭 ' || cnt(v_src, c_anc || c_blk1) || ' · ' || cnt(v_src, c_anc || c_blk2) || '건 (각 1 기대). 원문 무변경');
    END IF;
    v_new := REPLACE(v_src, c_anc || c_blk1, c_anc);
    v_new := REPLACE(v_new, c_anc || c_blk2, c_anc);
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
