-- 10_APPLY — [E20261014-DMF0005NOPUSH] PKG_DMF0005 BODY 외과 치환 패치 (전체 F5, 값 입력 없음, 멱등)
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어(클라우드 현재 원문 기준 — 사내 전체본 복사 아님) 앵커 1곳만 치환 후 CREATE OR REPLACE.
-- 변경 1줄: 조회 프로시저(P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION) 최종 SELECT 안쪽
--     SELECT                                          →  SELECT /*+ NO_PUSH_PRED(SC) */    -- 주석
--           B.*                                             B.*
--         , NVL(SC.CNT, 0) AS SC_CNT                      , NVL(SC.CNT, 0) AS SC_CNT
--   효과: SITE_CNT(사이트 · 프로젝트 · 팀별 H · P 건수)를 결과 행마다 다시 실행하지 않고 한 번 계산해 붙인다.
--   QA 10-14 실측: 지금 계획은 40 조회 1회에 SITE_CNT 15,672회 재실행 · 26억 행 읽기 · 18분. 사내 QA 조건 모사: 패치 전 2분 초과 → 패치 뒤 40 0.96s · 82 1.53s · 81 1.71s
--   결과 값 영향 없음 (사내 시나리오 동등성 대조). 힌트 = 사용자 승인 2026-10-14.
-- 가드: 마커 존재 시 무동작 · 앵커 1곳 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 실행 전 00_PRECHECK [L4] 확인 — 이 패키지를 실행 중인 세션이 있으면 교체가 끝날 때까지 기다릴 수 있다.
-- 실행 뒤 화면에서 다시 조회(이미 돌고 있던 조회는 옛 계획으로 계속 돈다) → 90_VERIFY. 원복 = 99_ROLLBACK
-- 사내 ZIOUI1 적용 완료 2026-10-14 (같은 치환, build_apply.py)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_cnt   PLS_INTEGER := 0;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'E20261014-DMF0005NOPUSH';
    c_old   CONSTANT VARCHAR2(32767) :=
        '        SELECT' || CHR(10) ||
        '              B.*' || CHR(10) ||
        '            , NVL(SC.CNT, 0) AS SC_CNT' || CHR(10);
    c_new   CONSTANT VARCHAR2(32767) :=   -- 한글 주석 포함(UTF8 3바이트) → 바이트 한도 여유
        '        SELECT /*+ NO_PUSH_PRED(SC) */    -- 2026.10.14 [E20261014-DMF0005NOPUSH] SITE_CNT 를 행마다 다시 실행하지 않고 한 번 계산해 붙인다(클라우드 QA 조회 미종료 대응 · 힌트 사용자 승인)' || CHR(10) ||
        '              B.*' || CHR(10) ||
        '            , NVL(SC.CNT, 0) AS SC_CNT' || CHR(10);
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
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0005' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (앵커는 LF 기준)
    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    v_cnt := cnt(v_src, c_old);
    IF v_cnt <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 앵커 매칭 ' || v_cnt || '건 (1 기대). 원문이 사내 기준과 다름 → 00_PRECHECK L1 문맥 확인 (원문 무변경)');
    END IF;
    IF DBMS_LOB.INSTR(v_src, c_old, 1) < DBMS_LOB.INSTR(v_src, 'PROCEDURE P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION', 1)
       OR DBMS_LOB.INSTR(v_src, c_old, 1) > DBMS_LOB.INSTR(v_src, 'END P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION;', 1) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 앵커가 조회 프로시저 구간 밖 (원문 무변경)');
    END IF;
    v_new := REPLACE(v_src, c_old, c_new);
    IF cnt(v_new, c_mark) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20003, '중단 — 치환 결과 마커 ' || cnt(v_new, c_mark) || '곳 (1 기대)');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0005' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0005' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0005' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0005 BODY ' || v_st || ' · 마커 ' || cnt(v_new, c_mark) || '곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0005' ORDER BY OBJECT_TYPE;
