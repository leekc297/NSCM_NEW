-- 90 VERIFY — [E20261016-VMIDIOJOIN] DMF0003 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 1줄 PASS · V2 VALID / 오류 0 / 의존 INVALID 0 · V3 적용 문구 1 · 수정 전 문구 0 PASS
-- * 화면 확인: DMF0003 40 · Measure 전체 선택 조회 — 이전보다 빨라지고 결과(행·값)는 같아야 한다
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL (미적용 또는 마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0003' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20261016-VMIDIOJOIN%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0003')) DEP_INVALID
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
    DBMS_OUTPUT.PUT_LINE('V3 J1 적용 문구 ' || cnt(v_src, c_j1_new) || '건 · 수정 전 문구 ' || cnt(v_src, c_j1_old) || '건 → ' || CASE WHEN cnt(v_src, c_j1_new) = 1 AND cnt(v_src, c_j1_old) = 0 THEN 'PASS' ELSE 'FAIL (1 / 0 기대)' END);
END;
/
