-- 10_APPLY — [E20261013-DMF0003SYNCSYS] PKG_DMF0003 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: P_DMF0003_MKT_FCST_SALES_PLAN_SYNC (DMF0003 저장 뒤 82 Sales Plan 동기화)가 DM_PLN_SALES_PLAN 에 기록하는
--       생성자·수정자를 저장한 사용자 대신 'SYSTEM' 으로 바꾼다.
--         수량 메저(MKT_FCST·CUST_FCST·TMM_FCST·RTF·RTF_SYS_RP) : 생성자·생성 시각 = 원장 값 그대로 / 수정자 = 'SYSTEM'
--         금액 메저(SalesAmt_KRW/LOC/USD·MKT_AMT_KRW/LOC)       : 생성자 = 'SYSTEM'·생성 시각 = 저장 시각 / 수정자 = 'SYSTEM'
--         수정 시각 = 전 메저 저장 시각 (종전과 같음)
-- 배경: 82 는 한 품목만 저장해도 사업부 전체 Sales Plan(당주 이후)이 다시 기록되어, 손대지 않은 품목까지
--       그 사용자가 수정한 것으로 남았다 (클라우드 QA 10-13 13:42 k0101 — 12,249행).
-- 범위: 이 프로시저의 최종 INSERT SELECT 목록 2줄만. 수량·금액 값, 삭제 범위, 메저 목록 무변경.
--       ★ 기존 데이터는 고치지 않는다 — 적용 뒤 82 를 DMF0003 에서 저장할 때부터 새 규칙으로 기록된다.
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 그 2줄만 바꾼 뒤 CREATE OR REPLACE (사내 전체본 복사 아님 — 다른 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 앵커 1건 아니거나 동기화 프로시저 밖이면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 2026-10-13 15:37:05 (같은 치환 · 바뀐 식 20케이스 통과). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
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
    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_old) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 최종 기록 2줄 앵커 매칭 ' || cnt(v_src, c_old) || '건 (1 기대). 원문이 사내 기준과 다름 → 00_PRECHECK L1 확인. 원문 무변경');
    END IF;
    v_pos  := DBMS_LOB.INSTR(v_src, c_old);
    v_proc := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0003_MKT_FCST_SALES_PLAN_SYNC');
    IF v_proc = 0 OR v_pos < v_proc OR DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE ', v_proc + 20) BETWEEN 1 AND v_pos THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 앵커가 P_DMF0003_MKT_FCST_SALES_PLAN_SYNC 밖에 있음. 원문 무변경');
    END IF;
    v_new := REPLACE(v_src, c_old, c_new);
    IF cnt(v_new, c_mark) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 치환 결과 마커 ' || cnt(v_new, c_mark) || '곳 (1 기대). 원문 무변경');
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
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0003 BODY ' || v_st || ' · 마커 ' || cnt(v_new, c_mark) || '곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0003' ORDER BY OBJECT_TYPE;
