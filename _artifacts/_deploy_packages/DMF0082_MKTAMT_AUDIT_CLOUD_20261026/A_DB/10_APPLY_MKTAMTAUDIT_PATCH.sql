-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL=2026-10-26 23:48:51 FETCHED=2026-10-26 23:56:39 DB=ZIOUI1 (치환쌍 기준 = 사내 적용 전/후 diff)
-- 10_APPLY — [E20261026-DMF0082-MKTAMTAUDIT] PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082 조회의 MKT FCST 금액 메저(MKT_AMT_KRW / MKT_AMT_LOC) 행 LAST UPDATE DATE · LAST UPDATED BY 공란 보완.
--       금액 arm 4곳(GET_MAIN_DATA Current·MF·SF / GET_MAIN_DATA_CURRENT)이 NULL 고정 → 원천(DM_PLN_SALES_PLAN·_C) 행의
--       MAX(CREATION_DATE) · 그 시점 LAST_UPDATED_BY 로 채움 (다른 수요 메저와 같은 규칙).
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 바뀐 줄만 치환 후 CREATE OR REPLACE (사내 전체본 복사 아님 — 다른 프로시저·다른 줄 무변경).
--       치환 쌍은 사내 적용 전/후 원문 diff 에서 자동 생성 (build_package.py).
-- 가드: 표식 있으면 무동작 · 앵커 수가 기대와 다르면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
SET SQLBLANKLINES ON
DECLARE
    c_obj   CONSTANT VARCHAR2(30) := 'PKG_DMF0082';
    c_tag   CONSTANT VARCHAR2(30) := 'MKTAMTAUDIT';
    c_from1 CONSTANT VARCHAR2(32767) := q'~             , NULL AS CREATE_DATE, NULL AS LAST_UPDATED_BY~' || CHR(10) || q'~             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT~' || CHR(10) || '';
    c_to1   CONSTANT VARCHAR2(32767) := q'~             , A.CREATE_DATE, A.LAST_UPDATED_BY  --[E20261026-DMF0082-MKTAMTAUDIT] 원천 행 수정 정보 (구: NULL AS CREATE_DATE, NULL AS LAST_UPDATED_BY)~' || CHR(10) || q'~             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT~' || CHR(10) || '';
    c_from2 CONSTANT VARCHAR2(32767) := q'~                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY~' || CHR(10) || q'~                FROM   SCM_MGR.DM_PLN_SALES_PLAN S~' || CHR(10) || '';
    c_to2   CONSTANT VARCHAR2(32767) := q'~                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY  --[E20261026-DMF0082-MKTAMTAUDIT]~' || CHR(10) || q'~                FROM   SCM_MGR.DM_PLN_SALES_PLAN S~' || CHR(10) || '';
    c_from3 CONSTANT VARCHAR2(32767) := q'~                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY~' || CHR(10) || q'~                FROM   SCM_MGR.DM_PLN_SALES_PLAN_C S~' || CHR(10) || '';
    c_to3   CONSTANT VARCHAR2(32767) := q'~                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY  --[E20261026-DMF0082-MKTAMTAUDIT]~' || CHR(10) || q'~                FROM   SCM_MGR.DM_PLN_SALES_PLAN_C S~' || CHR(10) || '';
    c_from4 CONSTANT VARCHAR2(32767) := q'~             , NULL AS CREATE_DATE~' || CHR(10) || q'~             , NULL AS LAST_UPDATED_BY~' || CHR(10) || q'~             , '/' AS CURRENCY~' || CHR(10) || '';
    c_to4   CONSTANT VARCHAR2(32767) := q'~             , A.CREATE_DATE  --[E20261026-DMF0082-MKTAMTAUDIT] 구: NULL AS CREATE_DATE~' || CHR(10) || q'~             , A.LAST_UPDATED_BY  --[E20261026-DMF0082-MKTAMTAUDIT] 구: NULL AS LAST_UPDATED_BY~' || CHR(10) || q'~             , '/' AS CURRENCY~' || CHR(10) || '';
    v_src   CLOB;
    v_org   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_code  PLS_INTEGER := 0;
    v_msg   VARCHAR2(400);
    v_chk   PLS_INTEGER;
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
    FUNCTION load_src RETURN CLOB IS
        v CLOB;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v, TRUE);
        FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = c_obj AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
            DBMS_LOB.WRITEAPPEND(v, LENGTH(r.TEXT), r.TEXT);
        END LOOP;
        RETURN REPLACE(v, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (토큰은 LF 기준)
    END;
BEGIN
    v_src := load_src;
    v_org := v_src;
    IF cnt(v_src, c_tag) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP - already applied (tag ' || cnt(v_src, c_tag) || '). source unchanged');
        RETURN;
    END IF;
    IF cnt(v_src, c_from1) <> 3 THEN
        RAISE_APPLICATION_ERROR(-20002, 'STOP - anchor 1 match ' || cnt(v_src, c_from1) || ' (expected 3). run 00_PRECHECK and send result. source unchanged');
    END IF;
    v_src := REPLACE(v_src, c_from1, c_to1);
    IF cnt(v_src, c_from2) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20002, 'STOP - anchor 2 match ' || cnt(v_src, c_from2) || ' (expected 2). run 00_PRECHECK and send result. source unchanged');
    END IF;
    v_src := REPLACE(v_src, c_from2, c_to2);
    IF cnt(v_src, c_from3) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20002, 'STOP - anchor 3 match ' || cnt(v_src, c_from3) || ' (expected 2). run 00_PRECHECK and send result. source unchanged');
    END IF;
    v_src := REPLACE(v_src, c_from3, c_to3);
    IF cnt(v_src, c_from4) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20002, 'STOP - anchor 4 match ' || cnt(v_src, c_from4) || ' (expected 1). run 00_PRECHECK and send result. source unchanged');
    END IF;
    v_src := REPLACE(v_src, c_from4, c_to4);
    IF cnt(v_src, c_tag) <> 9 THEN
        RAISE_APPLICATION_ERROR(-20004, 'STOP - assembled tag ' || cnt(v_src, c_tag) || ' (expected 9). source unchanged');
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;
    EXCEPTION WHEN OTHERS THEN
        v_code := SQLCODE; v_msg := SUBSTR(SQLERRM, 1, 400);   -- ORA-24344(컴파일 오류 동반 생성)만 아래 STATUS 판정으로 진행
    END;
    IF v_code NOT IN (0, -24344) THEN
        RAISE_APPLICATION_ERROR(-20006, 'STOP - CREATE not executed: ' || v_msg || ' (package in use? retry later). source unchanged');
    END IF;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = c_obj AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = c_obj AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = c_obj AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_org;   -- 원문 자동 복원
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
        SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = c_obj AND OBJECT_TYPE = 'PACKAGE BODY';
        RAISE_APPLICATION_ERROR(-20005, 'COMPILE FAILED -> original restored (now ' || v_st || '). run 90_VERIFY');
    END IF;
    SELECT COUNT(*) INTO v_chk FROM USER_SOURCE WHERE NAME = c_obj AND TYPE = 'PACKAGE BODY' AND INSTR(TEXT, c_tag) > 0;
    IF v_chk <> 9 THEN
        RAISE_APPLICATION_ERROR(-20007, 'STOP - after CREATE, tag lines in USER_SOURCE = ' || v_chk || ' (expected 9). run 90_VERIFY');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED - ' || c_obj || ' BODY ' || v_st || ' / MKTAMTAUDIT tag lines ' || v_chk || ' / ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;
