-- SOURCE-FRESH: SCM_MGR.PKG_SYS0014 PACKAGE BODY LAST_DDL=2026-10-15 21:13:24 FETCHED=2026-10-15 21:18 DB=ZIOUI1 (사내 적용본 기준 문구 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [GAP473 2026-10-15] GAP 473 PKG_SYS0014 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: Group User 저장 P_SYS0014_SAVE_GROUP_USER_M — 사용자를 그룹에서 삭제(UserInfo D)하거나 사업부 권한을 삭제(Division D)할 때
--   같은 키의 권한 요청 기록(SCM_MST_AUTH_REQUEST)도 함께 삭제 (AS-IS UP_FX_DeleteUserGroupInfo / UP_FX_DeleteUserGroupAuthExtention 동일).
--   그룹(GroupInfo) 삭제 · 추가 · 수정 · 다른 프로시저 무변경. 메타 · FE · 권한 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 저장 SP 구간 안 ASCII 주석 2줄 뒤에 DELETE 1문장씩 삽입 → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 대상 줄 각 1건 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src    CLOB;
    v_new    CLOB;
    v_seg    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    v_a      PLS_INTEGER;
    v_b      PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)   := 'GAP473 2026-10-15';
    c_pa     CONSTANT VARCHAR2(200)  := '' || CHR(10) || 'PROCEDURE P_SYS0014_SAVE_GROUP_USER_M (';
    c_pb     CONSTANT VARCHAR2(200)  := '' || CHR(10) || 'END P_SYS0014_SAVE_GROUP_USER_M;';
    c_old1   CONSTANT VARCHAR2(4000) := '    -- userInfo DELETE' || CHR(10) || '';
    c_new1   CONSTANT VARCHAR2(4000) := '    -- userInfo DELETE' || CHR(10) || '    -- [GAP473 2026-10-15] AS-IS UP_FX_DeleteUserGroupInfo parity: remove the user''s auth request records of this group too' || CHR(10) || '    DELETE FROM SCM_MGR.SCM_MST_AUTH_REQUEST R' || CHR(10) || '     WHERE (R.GROUP_ID, R.USER_ID) IN (' || CHR(10) || '         SELECT V_USER_GR_ID, V_USER_ID FROM JSON_TABLE(P_DATA, ''$[*]'' COLUMNS (' || CHR(10) || '             V_SHT_NM     VARCHAR2(30) PATH ''$.SHT_NM'',' || CHR(10) || '             V_CRUD_TYPE  VARCHAR2(1)  PATH ''$.CRUD_TYPE'',' || CHR(10) || '             V_USER_GR_ID VARCHAR2(50) PATH ''$.USER_GR_ID'',' || CHR(10) || '             V_USER_ID    VARCHAR2(50) PATH ''$.USER_ID''' || CHR(10) || '         )) WHERE V_SHT_NM=''UserInfo'' AND V_CRUD_TYPE=''D''' || CHR(10) || '     );' || CHR(10) || '';
    c_old2   CONSTANT VARCHAR2(4000) := '    -- unit_auth DELETE' || CHR(10) || '';
    c_new2   CONSTANT VARCHAR2(4000) := '    -- unit_auth DELETE' || CHR(10) || '    -- [GAP473 2026-10-15] AS-IS UP_FX_DeleteUserGroupAuthExtention parity: remove matching auth request records too' || CHR(10) || '    --   (DIVISION_ID=UPPR_UNIT_ID AND PLANT_ID=UNIT_ID) / UNIT_TP_CD=''D'' -> every request of that division' || CHR(10) || '    DELETE FROM SCM_MGR.SCM_MST_AUTH_REQUEST R' || CHR(10) || '     WHERE EXISTS (' || CHR(10) || '         SELECT 1 FROM JSON_TABLE(P_DATA, ''$[*]'' COLUMNS (' || CHR(10) || '             V_SHT_NM       VARCHAR2(30) PATH ''$.SHT_NM'',' || CHR(10) || '             V_CRUD_TYPE    VARCHAR2(1)  PATH ''$.CRUD_TYPE'',' || CHR(10) || '             V_USER_GR_ID   VARCHAR2(50) PATH ''$.USER_GR_ID'',' || CHR(10) || '             V_USER_ID      VARCHAR2(50) PATH ''$.USER_ID'',' || CHR(10) || '             V_UNIT_TP_CD   VARCHAR2(10) PATH ''$.UNIT_TP_CD'',' || CHR(10) || '             V_UNIT_ID      VARCHAR2(50) PATH ''$.UNIT_ID'',' || CHR(10) || '             V_UPPR_UNIT_ID VARCHAR2(50) PATH ''$.UPPR_UNIT_ID''' || CHR(10) || '         )) J' || CHR(10) || '          WHERE J.V_SHT_NM = ''Division'' AND J.V_CRUD_TYPE = ''D''' || CHR(10) || '            AND R.GROUP_ID = J.V_USER_GR_ID' || CHR(10) || '            AND R.USER_ID  = J.V_USER_ID' || CHR(10) || '            AND (   (R.DIVISION_ID = J.V_UPPR_UNIT_ID AND R.PLANT_ID = J.V_UNIT_ID)' || CHR(10) || '                 OR (J.V_UNIT_TP_CD = ''D'' AND R.DIVISION_ID = J.V_UNIT_ID))' || CHR(10) || '     );' || CHR(10) || '';
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
    PROCEDURE split_seg IS
    BEGIN
        v_a := DBMS_LOB.INSTR(v_new, c_pa);
        v_b := CASE WHEN v_a > 0 THEN DBMS_LOB.INSTR(v_new, c_pb, v_a) ELSE 0 END;
        IF NOT (v_a > 0 AND v_b > v_a) THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — P_SYS0014_SAVE_GROUP_USER_M 위치 확인 불가. 원문 무변경');
        END IF;
        v_seg := SUBSTR(v_new, v_a, v_b - v_a);
    END;
    PROCEDURE join_seg IS
    BEGIN
        v_new := SUBSTR(v_new, 1, v_a - 1) || v_seg || SUBSTR(v_new, v_b);
    END;
    PROCEDURE expect(p_name VARCHAR2, p_got PLS_INTEGER, p_exp PLS_INTEGER) IS
    BEGIN
        IF p_got <> p_exp THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' ' || p_got || '건 (' || p_exp || ' 기대). 00_PRECHECK 회신. 원문 무변경');
        END IF;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_SYS0014' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_new := v_src;
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    split_seg;
    expect('저장 SP userInfo DELETE 주석 줄', cnt(v_seg, c_old1), 1);
    expect('저장 SP unit_auth DELETE 주석 줄', cnt(v_seg, c_old2), 1);
    v_seg := REPLACE(v_seg, c_old1, c_new1);
    v_seg := REPLACE(v_seg, c_old2, c_new2);
    join_seg;
    expect('조립 결과 마커', cnt(v_new, c_mark), 2);
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_SYS0014' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_SYS0014' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_SYS0014' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        EXCEPTION WHEN OTHERS THEN
            NULL;
        END;
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_SYS0014 BODY ' || v_st || ' · 마커 2곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_SYS0014' ORDER BY OBJECT_TYPE;
