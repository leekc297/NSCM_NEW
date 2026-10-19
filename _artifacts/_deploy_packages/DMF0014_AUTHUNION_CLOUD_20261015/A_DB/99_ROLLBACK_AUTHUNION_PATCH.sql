-- 99 ROLLBACK — [AUTHUNION 2026-10-15] 역치환 (판정 2곳을 그룹명 단일 판정으로 되돌린다). 전체 F5, 멱등
-- 마커 없으면 무동작. ⚠ 되돌리면 관리자 그룹 사용자도 다시 담당 팀 행만 편집 가능해진다.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_pos   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40)   := 'AUTHUNION 2026-10-15';
    c_old   CONSTANT VARCHAR2(200)  := '        AND    SEGMENT1 = P_USERINFO;' || CHR(10);   -- 치환 전: 그룹명 단일 판정
    c_new   CONSTANT VARCHAR2(2000) := '        AND    (SEGMENT1 = P_USERINFO  --[AUTHUNION 2026-10-15] 보유그룹 합집합 판정 (FE groupId 유령 → USER_ID 전달 대응)' || CHR(10) || '                OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M G' || CHR(10) || '                                WHERE  G.USER_ID IN (P_USERINFO, P_USER_ID, P_CREATED_BY)' || CHR(10) || '                                AND    G.USE_YN = ''Y''));' || CHR(10);   -- 치환 뒤: 보유그룹 합집합 판정
    c_ctx   CONSTANT VARCHAR2(40)   := 'GET_ADMIN_GROUP';
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
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0014' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    IF NVL(DBMS_LOB.GETLENGTH(v_src), 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — PKG_DMF0014 BODY 없음. 원문 무변경');
    END IF;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_new) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용 문구 매칭 ' || cnt(v_src, c_new) || '건 (2 기대). 원문 무변경');
    END IF;
    v_new := REPLACE(v_src, c_new, c_old);
    IF cnt(v_new, c_mark) <> 0 OR cnt(v_new, c_old) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 결과 불일치. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0014' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0014' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0014' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0014 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0014' ORDER BY OBJECT_TYPE;
