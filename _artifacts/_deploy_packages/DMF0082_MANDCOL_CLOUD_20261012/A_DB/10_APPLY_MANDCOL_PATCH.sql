-- 10_APPLY — [E20261012-DMF0082MANDCOL] PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어(클라우드 현재 원문 기준 — 사내 전체본 복사 아님) 숨김 판정 2곳 뒤에 보정 블록만 삽입 후 CREATE OR REPLACE.
-- 내용: P_DMF0082_GET_MAIN_DATA 의 '숨긴 컬럼 대표값 통일'([E20260918-KEYCOLGRAIN] CELL_PROD_SITE_ID / [KEYCOLGRAIN2] PLANT_SITE_ID) 판정에서
--       사용자 컬럼 저장 내역(SCM_MST_TITLESET_USER 'C')에 없더라도 **메타상 필수 컬럼**(SCM_MST_SHEET_COLUMNS USER_SELECTABLE_FLAG='N' · VISIBLE_FLAG='Y' ·
--       해당 division)이면 '표시 중' 으로 본다. 화면은 필수 컬럼을 항상 표시하므로 판정을 화면과 일치시킨다. 기존 문장은 한 글자도 바꾸지 않는다.
-- 증상: 저장 내역에 CELL_PROD_SITE_ID 가 없는 사용자(k0101)는 화면에 Cell Prod Site 가 보이는데도 LOC/KRW/USD 가 한 사이트로 합쳐져
--       HQ06-A 에 LOC 가 안 나옴 (클라우드 QA 10-12 실측 — 판가 HQ06-A 888 / NJ01-A 777 → NJ01-A 한 줄 832.5)
-- 가드: 마커 존재 시 무동작 · 앵커 각 1건 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 2026-10-12 18:16:54 (같은 블록 · 전후 비교 4케이스 통과). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'E20261012-DMF0082MANDCOL';
    c_old1  CONSTANT VARCHAR2(32767) :=   -- CELL_PROD_SITE_ID 판정 (원문)
        '       AND U.COLUMN_NAME = ''CELL_PROD_SITE_ID'';' || CHR(10) ||
        '' || CHR(10) ||
        '    IF V_USER_COL_CNT = 0 THEN   -- 화면에서 숨긴 컬럼일 때만 (표시 중이면 AS-IS 파리티 유지)' || CHR(10);
    c_new1  CONSTANT VARCHAR2(32767) :=   -- CELL_PROD_SITE_ID 판정 + 필수 컬럼 보정 블록
        '       AND U.COLUMN_NAME = ''CELL_PROD_SITE_ID'';' || CHR(10) ||
        '' || CHR(10) ||
        '    --[E20261012-DMF0082MANDCOL] 필수 컬럼은 ''숨긴 컬럼'' 이 아니다 (사용자 신고 2026-10-12 · 승인 A안).' || CHR(10) ||
        '    --  화면은 사용자가 숨길 수 없는 필수 컬럼(메타 USER_SELECTABLE_FLAG=''N'' + VISIBLE_FLAG=''Y'')을 사용자 컬럼 저장 내역' || CHR(10) ||
        '    --  (SCM_MST_TITLESET_USER ''C'')에 없어도 항상 표시한다. 저장 내역만 보면 ''숨김'' 으로 오판해 화면에 보이는 컬럼의 값을' || CHR(10) ||
        '    --  대표값 하나로 합친다 — 클라우드 실측: 판가 LOC HQ06-A 888 / NJ01-A 777 이 NJ01-A 한 줄(832.5)로 합쳐져' || CHR(10) ||
        '    --  HQ06-A 에 LOC 가 안 나옴 (Column Set 을 다시 저장해 행이 생기면 정상).' || CHR(10) ||
        '    --  판정식 = 화면 컬럼 메타 조회(PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST)와 같은 division 토큰 규칙.' || CHR(10) ||
        '    IF V_USER_COL_CNT = 0 THEN' || CHR(10) ||
        '        SELECT COUNT(*)' || CHR(10) ||
        '          INTO V_USER_COL_CNT' || CHR(10) ||
        '          FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C' || CHR(10) ||
        '         WHERE C.PROGRAM_ID  = VA_PROGRAM_ID' || CHR(10) ||
        '           AND C.SHEET_NAME  = VA_SHEET_NAME' || CHR(10) ||
        '           AND C.COLUMN_NAME = ''CELL_PROD_SITE_ID''' || CHR(10) ||
        '           AND C.VALID_YN    = ''Y''' || CHR(10) ||
        '           AND C.USER_SELECTABLE_FLAG = ''N''' || CHR(10) ||
        '           AND C.VISIBLE_FLAG = ''Y''' || CHR(10) ||
        '           AND (C.DIVISION_ID IS NULL OR INSTR('','' || C.DIVISION_ID || '','', '','' || p_division_id || '','') > 0);' || CHR(10) ||
        '    END IF;' || CHR(10) ||
        '' || CHR(10) ||
        '    IF V_USER_COL_CNT = 0 THEN   -- 화면에서 숨긴 컬럼일 때만 (표시 중이면 AS-IS 파리티 유지)' || CHR(10);
    c_old2  CONSTANT VARCHAR2(32767) :=   -- PLANT_SITE_ID 판정 (원문)
        '       AND U.COLUMN_NAME = ''PLANT_SITE_ID'';' || CHR(10) ||
        '' || CHR(10) ||
        '    IF V_USER_COL_CNT = 0 THEN   -- 화면에서 숨긴 컬럼일 때만' || CHR(10);
    c_new2  CONSTANT VARCHAR2(32767) :=   -- PLANT_SITE_ID 판정 + 필수 컬럼 보정 블록
        '       AND U.COLUMN_NAME = ''PLANT_SITE_ID'';' || CHR(10) ||
        '' || CHR(10) ||
        '    --[E20261012-DMF0082MANDCOL] 필수 컬럼은 ''숨긴 컬럼'' 이 아니다 — 위 CELL_PROD_SITE_ID 와 같은 보정.' || CHR(10) ||
        '    IF V_USER_COL_CNT = 0 THEN' || CHR(10) ||
        '        SELECT COUNT(*)' || CHR(10) ||
        '          INTO V_USER_COL_CNT' || CHR(10) ||
        '          FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C' || CHR(10) ||
        '         WHERE C.PROGRAM_ID  = VA_PROGRAM_ID' || CHR(10) ||
        '           AND C.SHEET_NAME  = VA_SHEET_NAME' || CHR(10) ||
        '           AND C.COLUMN_NAME = ''PLANT_SITE_ID''' || CHR(10) ||
        '           AND C.VALID_YN    = ''Y''' || CHR(10) ||
        '           AND C.USER_SELECTABLE_FLAG = ''N''' || CHR(10) ||
        '           AND C.VISIBLE_FLAG = ''Y''' || CHR(10) ||
        '           AND (C.DIVISION_ID IS NULL OR INSTR('','' || C.DIVISION_ID || '','', '','' || p_division_id || '','') > 0);' || CHR(10) ||
        '    END IF;' || CHR(10) ||
        '' || CHR(10) ||
        '    IF V_USER_COL_CNT = 0 THEN   -- 화면에서 숨긴 컬럼일 때만' || CHR(10);
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
    IF cnt(v_src, c_old1) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — CELL_PROD_SITE_ID 판정 앵커 매칭 ' || cnt(v_src, c_old1) || '건 (1 기대). 원문이 사내 기준과 다름 → 00_PRECHECK L1 문맥 확인');
    END IF;
    IF cnt(v_src, c_old2) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — PLANT_SITE_ID 판정 앵커 매칭 ' || cnt(v_src, c_old2) || '건 (1 기대). 원문이 사내 기준과 다름 → 00_PRECHECK L1 문맥 확인');
    END IF;
    v_new := REPLACE(REPLACE(v_src, c_old1, c_new1), c_old2, c_new2);
    IF cnt(v_new, c_mark) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 치환 결과 마커 ' || cnt(v_new, c_mark) || '곳 (2 기대)');
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
