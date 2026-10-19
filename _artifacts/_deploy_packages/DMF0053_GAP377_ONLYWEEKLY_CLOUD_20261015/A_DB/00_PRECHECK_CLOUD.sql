-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [GAP377 2026-10-15] GAP 377 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0053 상태·LAST_DDL
-- * [L1] 대상 문구 건수 — T1~T3 각 2 · G1~G2 각 1 (전부 PASS 기대, DBMS_OUTPUT)
-- * [L2] 마커 — 적용 전 0
-- * [L3] 지금 PKG_DMF0053 실행 중 세션 (있으면 끝난 뒤 10 실행 — 컴파일이 대기함)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0053' ORDER BY O.OBJECT_TYPE;
DECLARE
    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40) := 'GAP377 2026-10-15';
    c_t1_old CONSTANT VARCHAR2(4000) := '                     , '''' AS FIXED_FLAG, 50 AS COLUMN_WIDTH' || CHR(10) || '';
    c_t1_new CONSTANT VARCHAR2(4000) := '                     , '''' AS FIXED_FLAG, CASE WHEN P_BUCKET = ''ONLY_WEEKLY'' THEN 100 ELSE 50 END AS COLUMN_WIDTH  --[GAP377 2026-10-15] AS-IS width' || CHR(10) || '';
    c_t2_old CONSTANT VARCHAR2(4000) := '                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD' || CHR(10) || '                         GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.WEEK_NAME, A.MONTH_NAME' || CHR(10) || '';
    c_t2_new CONSTANT VARCHAR2(4000) := '                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD' || CHR(10) || '                           AND P_BUCKET <> ''ONLY_WEEKLY''  --[GAP377 2026-10-15]' || CHR(10) || '                         GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.WEEK_NAME, A.MONTH_NAME' || CHR(10) || '';
    c_t3_old CONSTANT VARCHAR2(4000) := '                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD' || CHR(10) || '                         GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME' || CHR(10) || '                       ) T' || CHR(10) || '';
    c_t3_new CONSTANT VARCHAR2(4000) := '                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD' || CHR(10) || '                           AND P_BUCKET <> ''ONLY_WEEKLY''  --[GAP377 2026-10-15]' || CHR(10) || '                         GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME' || CHR(10) || '                        UNION ALL' || CHR(10) || '                        --[GAP377 2026-10-15] ONLY_WEEKLY: one column per ISO week (AS-IS C20220620-000567)' || CHR(10) || '                        SELECT ''W_'' || SUBSTR(MAX(A.BASIS_YYYYMMDD), 1, 6) || A.ISO_WEEK AS COLUMN_NAME' || CHR(10) || '                             , A.WEEK_NAME AS COLUMN_LABEL_NAME' || CHR(10) || '                             , A.WEEK_NAME AS SMALL_CLASS_LABEL_NAME' || CHR(10) || '                             , SUBSTR(MIN(A.BASIS_YYYYMMDD), 5, 2) || ''.'' || SUBSTR(MIN(A.BASIS_YYYYMMDD), 7, 2)' || CHR(10) || '                               || '' ~ '' || SUBSTR(MAX(A.BASIS_YYYYMMDD), 5, 2) || ''.'' || SUBSTR(MAX(A.BASIS_YYYYMMDD), 7, 2) AS LARGE_CLASS_LABEL_NAME' || CHR(10) || '                             , '''' AS DAY_CODE' || CHR(10) || '                             , TO_NUMBER(MAX(A.BASIS_YYYYMMDD) || ''21'') AS SORT_ORDER_NO' || CHR(10) || '                          FROM SCM_SYS_CALENDAR_M A' || CHR(10) || '                         WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD' || CHR(10) || '                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD' || CHR(10) || '                           AND P_BUCKET = ''ONLY_WEEKLY''' || CHR(10) || '                         GROUP BY A.ISO_YYYYWW, A.ISO_WEEK, A.WEEK_NAME' || CHR(10) || '                       ) T' || CHR(10) || '';
    c_g1_old CONSTANT VARCHAR2(4000) := '         , SUBSTR(CAL.BASIS_YYYYMM, 1, 6) || CAL.ISO_WEEK AS BASIS_YYYYMMWW' || CHR(10) || '';
    c_g1_new CONSTANT VARCHAR2(4000) := '         , CW.BASIS_YYYYMMWW AS BASIS_YYYYMMWW  /* [GAP377 2026-10-15] AS-IS #CALENDAR week key */' || CHR(10) || '';
    c_g2_old CONSTANT VARCHAR2(4000) := '      JOIN SCM_SYS_CALENDAR_M CAL ON A.YYYYMMDD = CAL.BASIS_YYYYMMDD' || CHR(10) || '';
    c_g2_new CONSTANT VARCHAR2(4000) := '      JOIN SCM_SYS_CALENDAR_M CAL ON A.YYYYMMDD = CAL.BASIS_YYYYMMDD' || CHR(10) || '      /* [GAP377 2026-10-15] week key = month of the last in-period day of the ISO week + ISO_WEEK (AS-IS #CALENDAR) */' || CHR(10) || '      LEFT OUTER JOIN ( SELECT ISO_YYYYWW, ISO_WEEK, SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK AS BASIS_YYYYMMWW' || CHR(10) || '                          FROM SCM_SYS_CALENDAR_M' || CHR(10) || '                         WHERE BASIS_YYYYMMDD BETWEEN '''''' || P_FROM_YYYYMMDD || '''''' AND '''''' || P_TO_YYYYMMDD || ''''''' || CHR(10) || '                         GROUP BY ISO_YYYYWW, ISO_WEEK ) CW ON CAL.ISO_YYYYWW = CW.ISO_YYYYWW AND CAL.ISO_WEEK = CW.ISO_WEEK' || CHR(10) || '';
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
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0053' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_new := v_src;
    DBMS_OUTPUT.PUT_LINE('L1 T1 ' || cnt(v_src, c_t1_old) || '건 → ' || CASE WHEN cnt(v_src, c_t1_old) = 2 THEN 'PASS' ELSE 'FAIL (2 기대) → 10 실행 금지·결과 회신' END);
    DBMS_OUTPUT.PUT_LINE('L1 T2 ' || cnt(v_src, c_t2_old) || '건 → ' || CASE WHEN cnt(v_src, c_t2_old) = 2 THEN 'PASS' ELSE 'FAIL (2 기대) → 10 실행 금지·결과 회신' END);
    DBMS_OUTPUT.PUT_LINE('L1 T3 ' || cnt(v_src, c_t3_old) || '건 → ' || CASE WHEN cnt(v_src, c_t3_old) = 2 THEN 'PASS' ELSE 'FAIL (2 기대) → 10 실행 금지·결과 회신' END);
    DBMS_OUTPUT.PUT_LINE('L1 G1 ' || cnt(v_src, c_g1_old) || '건 → ' || CASE WHEN cnt(v_src, c_g1_old) = 1 THEN 'PASS' ELSE 'FAIL (1 기대) → 10 실행 금지·결과 회신' END);
    DBMS_OUTPUT.PUT_LINE('L1 G2 ' || cnt(v_src, c_g2_old) || '건 → ' || CASE WHEN cnt(v_src, c_g2_old) = 1 THEN 'PASS' ELSE 'FAIL (1 기대) → 10 실행 금지·결과 회신' END);
END;
/
SELECT 'L2 마커' CHK, COUNT(*) N, MIN(LINE) LINE,
       CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0053' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%GAP377 2026-10-15%';
SELECT 'L3 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0053' AND OBJECT_TYPE='PACKAGE');
