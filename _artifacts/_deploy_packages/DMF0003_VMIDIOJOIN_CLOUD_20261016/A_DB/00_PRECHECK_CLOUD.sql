-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [E20261016-VMIDIOJOIN] DMF0003 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0003 상태·LAST_DDL
-- * [L1] 대상 문구 건수 — J1 1 (PASS 기대, DBMS_OUTPUT)
-- * [L2] 마커 — 적용 전 0
-- * [L3] 지금 PKG_DMF0003 실행 중 세션 (있으면 끝난 뒤 10 실행 — 컴파일이 대기함)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0003' ORDER BY O.OBJECT_TYPE;
DECLARE
    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40) := 'E20261016-VMIDIOJOIN';
    c_j1_old CONSTANT VARCHAR2(4000) := '        ''  ON  A.ITEM_ID     = CASE WHEN '''''' || P_DIVISION_ID || '''''' = ''''40'''' THEN VM.KEY_JOIN ELSE A.ITEM_ID END'' || CHR(10) ||' || CHR(10) || '        ''  AND ( '''''' || P_DIVISION_ID || '''''' = ''''40''''  '' || CHR(10) ||' || CHR(10) || '        ''        OR A.SCM_SITE_ID = VM.KEY_JOIN )'' || CHR(10) ||' || CHR(10) || '';
    c_j1_new CONSTANT VARCHAR2(4000) := '        CASE WHEN P_DIVISION_ID = ''40''' || CHR(10) || '             THEN ''  ON  A.ITEM_ID     = VM.KEY_JOIN'' || CHR(10)    --[E20261016-VMIDIOJOIN] 40 = item key equi-join (CASE-wrapped ON blocked hash join -> per-row full scan of GT). Same result. Other divisions: original text below' || CHR(10) || '             ELSE ''  ON  A.ITEM_ID     = CASE WHEN '''''' || P_DIVISION_ID || '''''' = ''''40'''' THEN VM.KEY_JOIN ELSE A.ITEM_ID END'' || CHR(10) ||' || CHR(10) || '                  ''  AND ( '''''' || P_DIVISION_ID || '''''' = ''''40''''  '' || CHR(10) ||' || CHR(10) || '                  ''        OR A.SCM_SITE_ID = VM.KEY_JOIN )'' || CHR(10)' || CHR(10) || '        END ||' || CHR(10) || '';
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
    PROCEDURE expect(p_name VARCHAR2, p_got PLS_INTEGER, p_exp PLS_INTEGER) IS
    BEGIN
        IF p_got <> p_exp THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' ' || p_got || '건 (' || p_exp || ' 기대). 00_PRECHECK 회신. 원문 무변경');
        END IF;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0003' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_new := v_src;
    DBMS_OUTPUT.PUT_LINE('L1 J1 ' || cnt(v_src, c_j1_old) || '건 → ' || CASE WHEN cnt(v_src, c_j1_old) = 1 THEN 'PASS' ELSE 'FAIL (1 기대) → 10 실행 금지·결과 회신' END);
END;
/
SELECT 'L2 마커' CHK, COUNT(*) N, MIN(LINE) LINE,
       CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0003' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20261016-VMIDIOJOIN%';
SELECT 'L3 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0003' AND OBJECT_TYPE='PACKAGE');
