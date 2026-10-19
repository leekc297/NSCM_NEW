-- 10_APPLY — [E20261014-DMF0005SCONM] PKG_DMF0005 BODY 외과 치환 패치 2곳 (전체 F5, 값 입력 없음, 멱등)
-- 선행: DMF0005_NOPUSH_CLOUD_20261014 (마커 E20261014-DMF0005NOPUSH) 적용 상태여야 한다.
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어(사내 전체본 복사 아님) 앵커 2곳만 치환 후 CREATE OR REPLACE.
-- 변경 2곳 (조회 프로시저 P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION 의 BASE):
--   ① BASE 의 SELECT 에 /*+ NO_PUSH_PRED(ONM) */ — Owner 이름을 행마다 다시 구하지 않고 Owner 종류마다 한 번 (힌트 사용자 승인 2026-10-14)
--   ② Sold-To LEFT JOIN ON 절의 `AND (P_DIVISION_ID = '82' OR NVL(SC.VALID_YN, 'Y') = 'Y')` 를 주석 처리 —
--      바로 위 `AND SC.VALID_YN = 'Y'` 로 항상 참(결과 동일). 바인드가 섞인 이 조건이 조인을 행별 실행(VW_DCL)으로 바꿔 있었다.
--   QA 10-14 실측(NOPUSH 뒤): 82 39.8s 중 Sold-To 23.8s · Owner 이름 22.4s — 두 구간 모두 결과 행마다 45,675회 반복
--   사내 결과 동등성: 시나리오 96 × 674,518행 PASS
-- 가드: 마커 존재 시 무동작 · 선행 NOPUSH 없으면 중단 · 앵커 각 1곳 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 실행 뒤 화면에서 다시 조회 → 90_VERIFY. 원복 = 99_ROLLBACK
-- 사내 ZIOUI1 적용 완료 2026-10-14 12:11:30 (같은 치환, build_apply.py)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_p0    PLS_INTEGER;
    v_p1    PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'E20261014-DMF0005SCONM';
    c_old1  CONSTANT VARCHAR2(32767) :=
        '    BASE AS (' || CHR(10) ||
        '        SELECT' || CHR(10) ||
        '              SI.DIVISION_ID' || CHR(10);
    c_new1  CONSTANT VARCHAR2(32767) :=
        '    BASE AS (' || CHR(10) ||
        '        SELECT /*+ NO_PUSH_PRED(ONM) */    -- 2026.10.14 [E20261014-DMF0005SCONM] Owner 이름(OWNER_NM)을 행마다 다시 구하지 않고 Owner 종류마다 한 번(07-22 설계) — 클라우드 QA 행별 반복 대응 · 힌트 사용자 승인' || CHR(10) ||
        '              SI.DIVISION_ID' || CHR(10);
    c_old2  CONSTANT VARCHAR2(32767) :=
        '         AND (P_DIVISION_ID = ''82'' OR NVL(SC.VALID_YN, ''Y'') = ''Y'')' || CHR(10);
    c_new2  CONSTANT VARCHAR2(32767) :=
        '--       AND (P_DIVISION_ID = ''82'' OR NVL(SC.VALID_YN, ''Y'') = ''Y'')    -- 2026.10.14 [E20261014-DMF0005SCONM] 원본 — 바로 위 SC.VALID_YN = ''Y'' 로 항상 참. 바인드가 섞인 이 조건이 조인을 행별 실행(VW_DCL)으로 바꿔 제거(결과 동일)' || CHR(10);
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
    PROCEDURE in_get(p_tok VARCHAR2, p_no PLS_INTEGER) IS
        v PLS_INTEGER := DBMS_LOB.INSTR(v_src, p_tok, 1);
    BEGIN
        IF v < v_p0 OR v > v_p1 THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — 앵커' || p_no || ' 가 조회 프로시저 구간 밖 (원문 무변경)');
        END IF;
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
    IF cnt(v_src, 'E20261014-DMF0005NOPUSH') <> 1 THEN
        RAISE_APPLICATION_ERROR(-20000, '중단 — 선행 패치 NOPUSH 미적용 (DMF0005_NOPUSH_CLOUD_20261014 먼저). 원문 무변경');
    END IF;
    IF cnt(v_src, c_old1) <> 1 OR cnt(v_src, c_old2) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 앵커 매칭 ①' || cnt(v_src, c_old1) || ' ②' || cnt(v_src, c_old2) || ' (각 1 기대). 00_PRECHECK L2 확인 (원문 무변경)');
    END IF;
    v_p0 := DBMS_LOB.INSTR(v_src, 'PROCEDURE P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION', 1);
    v_p1 := DBMS_LOB.INSTR(v_src, 'END P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION;', 1);
    in_get(c_old1, 1);
    in_get(c_old2, 2);
    v_new := REPLACE(REPLACE(v_src, c_old1, c_new1), c_old2, c_new2);
    IF cnt(v_new, c_mark) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20003, '중단 — 치환 결과 마커 ' || cnt(v_new, c_mark) || '곳 (2 기대)');
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
