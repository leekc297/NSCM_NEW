-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [GAP358 2026-10-15] GAP 358 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0049 상태·LAST_DDL
-- * [L1] 대상 블록(중복 검사 연결 조건 13줄) 건수 — 1 PASS 기대 (DBMS_OUTPUT)
-- * [L2] 마커 — 적용 전 0
-- * [L3] 지금 PKG_DMF0049 실행 중 세션 (있으면 끝난 뒤 10 실행 — 컴파일이 대기함)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0049' ORDER BY O.OBJECT_TYPE;
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
    DBMS_OUTPUT.PUT_LINE('L1 대상 블록 ' || cnt(v_src, c_old) || '건 → ' || CASE WHEN cnt(v_src, c_old) = 1 THEN 'PASS' WHEN cnt(v_src, c_new) = 1 THEN '이미 적용됨(10 은 SKIP)' ELSE 'FAIL → 10 실행 금지·결과 회신' END);
END;
/
SELECT 'L2 마커' CHK, COUNT(*) N, MIN(LINE) LINE,
       CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0049' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%GAP358 2026-10-15%';
SELECT 'L3 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0049' AND OBJECT_TYPE='PACKAGE');
