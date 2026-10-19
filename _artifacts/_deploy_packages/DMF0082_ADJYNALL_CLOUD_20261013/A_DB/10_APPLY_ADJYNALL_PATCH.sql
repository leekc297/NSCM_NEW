-- 10_APPLY — [E20261013-DMF0082ADJYNALL] PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: P_DMF0082_SAVE_MAIN_DATA 단가 검증(#10 Sales Price 해당 주차 확인)에서
--       'Site-Item 마스터에 SALES_PLAN_ADJUST_YN = N 인 품목은 검사 제외' 조건 8줄을 주석 처리한다.
--       → 판매계획 조정 제외 품목도 그 주에 판가가 없으면 'Unit Price Not Found !' 로 저장 차단.
-- 배경: 클라우드 QA 10-12 — 40 · AJ상사_AB_TES · MCCM356015A2 · Aima 가 오창A 판가 없이 MKT_FCST 저장됨(품목 플래그 N).
--       사용자 요청(2026-10-13): 플래그가 N 이어도 단가 검증 적용. AS-IS 도 같은 예외를 두고 있어 AS-IS 대비 의도적 강화.
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 그 8줄만 주석으로 바꾼 뒤 CREATE OR REPLACE (사내 전체본 복사 아님 — 다른 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 앵커 1건 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 2026-10-13 09:59:41 (같은 치환 · 문장 전후 비교 5케이스 통과). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'E20261013-DMF0082ADJYNALL';
    c_old   CONSTANT VARCHAR2(32767) :=   -- 단가 검증 제외조건 8줄 (원문)
        '          AND NOT EXISTS (SELECT 1' || CHR(10) ||
        '                            FROM SCM_MGR.SCM_MST_SITE_ITEM Z' || CHR(10) ||
        '                           WHERE Z.DIVISION_ID  = A.DIVISION_ID' || CHR(10) ||
        '                             AND Z.PROJECT_CODE = A.PROJECT_CODE' || CHR(10) ||
        '                             AND Z.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10) ||
        '                             AND Z.ITEM_ID      = A.ITEM_ID' || CHR(10) ||
        '                             AND Z.VALID_YN     = ''Y''' || CHR(10) ||
        '                             AND Z.SALES_PLAN_ADJUST_YN = ''N'')' || CHR(10);
    c_new   CONSTANT VARCHAR2(32767) :=   -- 같은 8줄을 줄 주석 처리 + 설명 2줄
        '          --[E20261013-DMF0082ADJYNALL] 사용자 요청(2026-10-13): 판매계획 조정 제외(SALES_PLAN_ADJUST_YN=''N'') 품목도 단가 검증 대상.' || CHR(10) ||
        '          --  아래 제외조건 8줄 주석 처리 — 종전에는 이 품목이 판가 없이 수량 저장됐다(AS-IS 동일 예외 → 의도적 강화).' || CHR(10) ||
        '--          AND NOT EXISTS (SELECT 1' || CHR(10) ||
        '--                            FROM SCM_MGR.SCM_MST_SITE_ITEM Z' || CHR(10) ||
        '--                           WHERE Z.DIVISION_ID  = A.DIVISION_ID' || CHR(10) ||
        '--                             AND Z.PROJECT_CODE = A.PROJECT_CODE' || CHR(10) ||
        '--                             AND Z.SCM_SITE_ID  = A.SCM_SITE_ID' || CHR(10) ||
        '--                             AND Z.ITEM_ID      = A.ITEM_ID' || CHR(10) ||
        '--                             AND Z.VALID_YN     = ''Y''' || CHR(10) ||
        '--                             AND Z.SALES_PLAN_ADJUST_YN = ''N'')' || CHR(10);
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
    IF cnt(v_src, c_old) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 제외조건 앵커 매칭 ' || cnt(v_src, c_old) || '건 (1 기대). 원문이 사내 기준과 다름 → 00_PRECHECK L1 문맥 확인');
    END IF;
    v_new := REPLACE(v_src, c_old, c_new);
    IF cnt(v_new, c_mark) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 치환 결과 마커 ' || cnt(v_new, c_mark) || '곳 (1 기대)');
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
