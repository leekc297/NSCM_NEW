-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL=2026-10-26 23:48:51 FETCHED=2026-10-26 23:56:39 DB=ZIOUI1 (치환쌍 기준 = 사내 적용 전/후 diff)
-- 00_PRECHECK — 조회 전용 (전체 F5). [E20261026-DMF0082-MKTAMTAUDIT] 적용 가능 여부
--   P0 대상 DB · PKG_DMF0082 BODY 상태 / P1 표식 · 앵커별 매칭 수 (전부 PASS 여야 10 적용 가능, 표식 > 0 이면 이미 적용)
--   P2 원천 데이터 — 금액 메저 행의 수정 정보 공란 수 (0 이어야 적용 후 화면에 값이 나온다)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
SET SQLBLANKLINES ON
SELECT 'P0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' ORDER BY OBJECT_TYPE;
DECLARE
    c_obj   CONSTANT VARCHAR2(30) := 'PKG_DMF0082';
    c_tag   CONSTANT VARCHAR2(30) := 'MKTAMTAUDIT';
    c_from1 CONSTANT VARCHAR2(32767) := q'~             , NULL AS CREATE_DATE, NULL AS LAST_UPDATED_BY~' || CHR(10) || q'~             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT~' || CHR(10) || '';
    c_from2 CONSTANT VARCHAR2(32767) := q'~                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY~' || CHR(10) || q'~                FROM   SCM_MGR.DM_PLN_SALES_PLAN S~' || CHR(10) || '';
    c_from3 CONSTANT VARCHAR2(32767) := q'~                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY~' || CHR(10) || q'~                FROM   SCM_MGR.DM_PLN_SALES_PLAN_C S~' || CHR(10) || '';
    c_from4 CONSTANT VARCHAR2(32767) := q'~             , NULL AS CREATE_DATE~' || CHR(10) || q'~             , NULL AS LAST_UPDATED_BY~' || CHR(10) || q'~             , '/' AS CURRENCY~' || CHR(10) || '';
    v_src   CLOB;
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
    DBMS_OUTPUT.PUT_LINE('P1 tag MKTAMTAUDIT = ' || cnt(v_src, c_tag) || CASE WHEN cnt(v_src, c_tag) > 0 THEN ' (이미 적용 — 10 은 무동작)' ELSE ' (미적용)' END);
    IF cnt(v_src, c_tag) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('P1 anchor 검사 생략 — 이미 적용된 원문이라 적용 전 문구가 없는 것이 정상. 90_VERIFY 로 확인');
        RETURN;
    END IF;
    DBMS_OUTPUT.PUT_LINE('P1 anchor 1 = ' || cnt(v_src, c_from1) || ' (expected 3)' || CASE WHEN cnt(v_src, c_from1) = 3 THEN ' PASS' ELSE ' FAIL' END);
    DBMS_OUTPUT.PUT_LINE('P1 anchor 2 = ' || cnt(v_src, c_from2) || ' (expected 2)' || CASE WHEN cnt(v_src, c_from2) = 2 THEN ' PASS' ELSE ' FAIL' END);
    DBMS_OUTPUT.PUT_LINE('P1 anchor 3 = ' || cnt(v_src, c_from3) || ' (expected 2)' || CASE WHEN cnt(v_src, c_from3) = 2 THEN ' PASS' ELSE ' FAIL' END);
    DBMS_OUTPUT.PUT_LINE('P1 anchor 4 = ' || cnt(v_src, c_from4) || ' (expected 1)' || CASE WHEN cnt(v_src, c_from4) = 1 THEN ' PASS' ELSE ' FAIL' END);
END;
/
SELECT 'P2' CHK, 'DM_PLN_SALES_PLAN' TBL, MEASURE, COUNT(*) N
     , SUM(CASE WHEN CREATION_DATE IS NULL OR LAST_UPDATED_BY IS NULL THEN 1 ELSE 0 END) N_AUDIT_NULL
  FROM SCM_MGR.DM_PLN_SALES_PLAN WHERE DIVISION_ID LIKE '81%' AND MEASURE IN ('MKT_AMT_KRW','MKT_AMT_LOC') GROUP BY MEASURE
UNION ALL
SELECT 'P2', 'DM_PLN_SALES_PLAN_C', MEASURE, COUNT(*)
     , SUM(CASE WHEN CREATION_DATE IS NULL OR LAST_UPDATED_BY IS NULL THEN 1 ELSE 0 END)
  FROM SCM_MGR.DM_PLN_SALES_PLAN_C WHERE DIVISION_ID LIKE '81%' AND MEASURE IN ('MKT_AMT_KRW','MKT_AMT_LOC')
   AND YYYYMMDD >= TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMMDD') GROUP BY MEASURE;
