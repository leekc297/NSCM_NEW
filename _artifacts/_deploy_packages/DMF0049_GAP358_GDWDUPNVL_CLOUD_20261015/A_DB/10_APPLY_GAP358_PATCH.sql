-- SOURCE-FRESH: SCM_MGR.PKG_DMF0049 PACKAGE BODY LAST_DDL=2026-10-15 18:36:26 FETCHED=2026-10-15 18:39 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [GAP358 2026-10-15] GAP 358 PKG_DMF0049 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0049 저장(P_DMF0049_SAVE_SALES_ETC_REPORT_C) GDW 중복 키 검사 [E20250418-001567] 의 연결 조건 12개를
--   `A.x = B.x` → `NVL(A.x,'/') = NVL(B.x,'/')` 로 바꾼다. AS-IS(MSSQL)는 빈 값끼리('' = '') 같다고 보지만
--   Oracle 은 빈 값이 NULL 이라 비교가 성립하지 않아, 빈 칸(Country·Cust.(Report) 등)이 있는 행이 중복 검사에서 빠졌다.
-- 범위: 검증 SELECT 1문장(13줄). 저장 로직 · 원장 · 메타 · FE · 권한 · GTT 정의 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 ASCII 문구로 치환(한글 비교 없음) → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 대상 블록이 1건이 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL 2026-10-15 18:36:26).
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)   := 'GAP358 2026-10-15';
    c_old    CONSTANT VARCHAR2(2000) := '          INNER JOIN SCM_MGR.GT_DMF0049_RESULTS_MST B' || CHR(10) || '                  ON A.VERSION_NO = B.VERSION_NO' || CHR(10) || '                 AND A.DIVISION_ID = B.DIVISION_ID' || CHR(10) || '                 AND A.DEPARTMENT_ID = B.DEPARTMENT_ID' || CHR(10) || '                 AND A.DEPT_ID = B.DEPT_ID' || CHR(10) || '                 AND A.ITEM_ID = B.ITEM_ID' || CHR(10) || '                 AND A.MEASURE = B.MEASURE' || CHR(10) || '                 AND A.YYYYMMDD = B.YYYYMMDD' || CHR(10) || '                 AND A.CURRENCY = B.CURRENCY' || CHR(10) || '                 AND A.COMPANY_ID = B.COMPANY_ID' || CHR(10) || '                 AND A.END_CUST_REPORT = B.END_CUST_REPORT' || CHR(10) || '                 AND A.CUST_REPORT = B.CUST_REPORT' || CHR(10) || '                 AND A.PRODUCT_GROUP = B.PRODUCT_GROUP' || CHR(10) || '                 AND A.COUNTRY_CODE = B.COUNTRY_CODE' || CHR(10) || '';
    c_new    CONSTANT VARCHAR2(2000) := '          INNER JOIN SCM_MGR.GT_DMF0049_RESULTS_MST B' || CHR(10) || '                  ON A.VERSION_NO = B.VERSION_NO  --[GAP358 2026-10-15] 12 keys: empty(NULL) equality NVL(x,''/'') both sides (AS-IS MSSQL ''''='''' parity)' || CHR(10) || '                 AND NVL(A.DIVISION_ID,''/'') = NVL(B.DIVISION_ID,''/'')' || CHR(10) || '                 AND NVL(A.DEPARTMENT_ID,''/'') = NVL(B.DEPARTMENT_ID,''/'')' || CHR(10) || '                 AND NVL(A.DEPT_ID,''/'') = NVL(B.DEPT_ID,''/'')' || CHR(10) || '                 AND NVL(A.ITEM_ID,''/'') = NVL(B.ITEM_ID,''/'')' || CHR(10) || '                 AND NVL(A.MEASURE,''/'') = NVL(B.MEASURE,''/'')' || CHR(10) || '                 AND NVL(A.YYYYMMDD,''/'') = NVL(B.YYYYMMDD,''/'')' || CHR(10) || '                 AND NVL(A.CURRENCY,''/'') = NVL(B.CURRENCY,''/'')' || CHR(10) || '                 AND NVL(A.COMPANY_ID,''/'') = NVL(B.COMPANY_ID,''/'')' || CHR(10) || '                 AND NVL(A.END_CUST_REPORT,''/'') = NVL(B.END_CUST_REPORT,''/'')' || CHR(10) || '                 AND NVL(A.CUST_REPORT,''/'') = NVL(B.CUST_REPORT,''/'')' || CHR(10) || '                 AND NVL(A.PRODUCT_GROUP,''/'') = NVL(B.PRODUCT_GROUP,''/'')' || CHR(10) || '                 AND NVL(A.COUNTRY_CODE,''/'') = NVL(B.COUNTRY_CODE,''/'')' || CHR(10) || '';
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
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0049' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_new := v_src;
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_new, c_old) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 중복 검사 연결 블록 ' || cnt(v_new, c_old) || '건 (1 기대). 00_PRECHECK 회신. 원문 무변경');
    END IF;
    v_new := REPLACE(v_new, c_old, c_new);
    IF cnt(v_new, c_new) <> 1 OR cnt(v_new, c_mark) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치. 원문 무변경');
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0049' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0049' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0049' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0049 BODY ' || v_st || ' · 마커 1곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0049' ORDER BY OBJECT_TYPE;
