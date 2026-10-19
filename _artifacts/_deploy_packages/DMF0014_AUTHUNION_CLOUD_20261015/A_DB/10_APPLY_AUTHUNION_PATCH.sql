-- SOURCE-FRESH: SCM_MGR.PKG_DMF0014 PACKAGE BODY LAST_DDL=2026-10-15 11:16:15 FETCHED=2026-10-15 11:16 DB=ZIOUI1 (패치형 — 적용 대상 원문은 실행 시점 클라우드 USER_SOURCE)
-- 10_APPLY — [AUTHUNION 2026-10-15] PKG_DMF0014 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 요청: DMF0014 — 로그인 사용자의 권한그룹이 기준코드 GET_ADMIN_GROUP(VALID_YN='Y', SEGMENT2='ALL') 에 있으면 전행 수정 가능 (AS-IS 동작)
-- 원인: AS-IS 는 P_USERINFO 에 그룹명(NowGroupID)을 넘기지만 TO-BE FE 는 USER_ID 를 넘긴다(session.groupId 미존재)
--       → SP 판정 `SEGMENT1 = P_USERINFO` 가 항상 0건 → 관리자 그룹 사용자도 담당 팀 행만 편집 가능.
-- 보완: 판정 2곳(P_DMF0014_GET_CUST_FCST_UPLOAD_DATA · P_DMF0014_GET_EXCEL_FORM_DATA)을
--       "전달값이 그룹명이거나, 사용자(P_USERINFO/P_USER_ID/P_CREATED_BY)가 보유한 그룹" 으로 확장. FE·BE 변경 없음.
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 2줄만 바꾼 뒤 CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 대상 줄이 정확히 2개가 아니거나 GET_ADMIN_GROUP 판정 문맥이 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 2026-10-15 11:16:15. 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
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
    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_old) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 판정 줄 "AND SEGMENT1 = P_USERINFO;" ' || cnt(v_src, c_old)
            || '개 (2 기대). 이 DB 의 원문이 사내와 다름 → 00_PRECHECK L1 결과 회신. 원문 무변경');
    END IF;
    FOR i IN 1 .. 2 LOOP   -- 각 줄 바로 앞 400자 안에 GET_ADMIN_GROUP 판정이 있어야 한다
        v_pos := DBMS_LOB.INSTR(v_src, c_old, 1, i);
        IF INSTR(DBMS_LOB.SUBSTR(v_src, 400, GREATEST(v_pos - 400, 1)), c_ctx) = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, '중단 — ' || i || '번째 판정 줄 앞에 GET_ADMIN_GROUP 이 없음. 원문 무변경');
        END IF;
    END LOOP;
    v_new := REPLACE(v_src, c_old, c_new);
    IF cnt(v_new, c_mark) <> 2 OR cnt(v_new, c_old) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치 (마커 ' || cnt(v_new, c_mark) || '곳, 2 기대). 원문 무변경');
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
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0014 BODY ' || v_st || ' · 관리자 그룹 판정 2곳 합집합 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0014' ORDER BY OBJECT_TYPE;
