-- 99 ROLLBACK — [E20261013-DMF0003SYNCSYS] 역치환 (이 DB 의 USER_SOURCE 를 읽어 바꾼 2줄을 종전 문장으로 되돌린 뒤 CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 되돌린 뒤 마커 0 이어야 실행. ⚠ 되돌리면 다시 저장한 사용자 이름으로 기록된다. 이미 기록된 데이터는 바뀌지 않는다.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_pos   PLS_INTEGER;
    v_proc  PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'E20261013-DMF0003SYNCSYS';
    c_old   CONSTANT VARCHAR2(32767) :=   -- 최종 기록 2줄 (원문 — 줄 맨 앞 줄바꿈 포함: 주석 처리된 같은 문구와 구분)
        CHR(10) || '                 , NVL(CREATED_BY, V_CREATED_BY), NVL(CREATION_DATE, SYSDATE)' || CHR(10) ||
        '                 , V_CREATED_BY, SYSDATE AS LAST_UPDATE_DATE' || CHR(10);
    c_new   CONSTANT VARCHAR2(32767) :=   -- 설명 5줄 + 종전 2줄 주석 + 새 2줄
        CHR(10) || '                 --[E20261013-DMF0003SYNCSYS] 사용자 요청(2026-10-13): 생성자·수정자를 저장한 사용자가 아니라 ''SYSTEM'' 으로 기록한다.' || CHR(10) ||
        '                 --  수량 메저(MKT_FCST·CUST_FCST·TMM_FCST·RTF·RTF_SYS_RP) = 생성자·생성 시각은 원장 값 그대로, 수정자만 ''SYSTEM''.' || CHR(10) ||
        '                 --  금액 메저(SalesAmt_KRW/LOC/USD·MKT_AMT_KRW/LOC) = 생성자·수정자 모두 ''SYSTEM'', 생성 시각 = 저장 시각.' || CHR(10) ||
        '                 --  수정 시각 = 전 메저 저장 시각. 메저 종류로 직접 구분한다 (원장 생성자가 빈 수량 행에 ''SYSTEM'' 이 들어가지 않게).' || CHR(10) ||
        '                 --  종전에는 82 를 한 품목만 저장해도 사업부 전체 행이 그 사용자가 수정한 것으로 남았다 (AS-IS 동일 → 의도적 변경).' || CHR(10) ||
        '--                 , NVL(CREATED_BY, V_CREATED_BY), NVL(CREATION_DATE, SYSDATE)' || CHR(10) ||
        '--                 , V_CREATED_BY, SYSDATE AS LAST_UPDATE_DATE' || CHR(10) ||
        '                 , CASE WHEN MEASURE IN (''MKT_FCST'', ''CUST_FCST'', ''TMM_FCST'', ''RTF'', ''RTF_SYS_RP'') THEN CREATED_BY ELSE ''SYSTEM'' END, NVL(CREATION_DATE, SYSDATE)' || CHR(10) ||
        '                 , ''SYSTEM'', SYSDATE AS LAST_UPDATE_DATE' || CHR(10);
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
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0003' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
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
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0003' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0003' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0003' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0003 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0003' ORDER BY OBJECT_TYPE;
