-- 90 VERIFY — [GAP392 2026-10-15] GAP 392 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 3줄 PASS · V2 VALID / 오류 0 / 의존 INVALID 0
-- * V3 (DBMS_OUTPUT) SP 직접 호출 — Project 콤보·조회 결과(두 분기) 순서 역전 0 → PASS (원장 무변경, 조회 SP 의 세션 임시표만 사용)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 3 THEN 'PASS' ELSE 'FAIL (미적용 또는 마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0068' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%GAP392 2026-10-15%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0068')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0068' ORDER BY O.OBJECT_TYPE;
DECLARE
    rc1 SYS_REFCURSOR; rc2 SYS_REFCURSOR; rcr SYS_REFCURSOR;
    v_code VARCHAR2(4000); v_name VARCHAR2(4000);
    TYPE t_vers IS TABLE OF VARCHAR2(40);
    vers t_vers := t_vers('R_S_GAP392_VERIFY', 'R_B_GAP392_VERIFY');
    v_res VARCHAR2(4000);   -- 판정 줄 모음 (SP 자체 DBMS_OUTPUT 은 버리고 마지막에 판정만 출력)
    PROCEDURE drain IS l VARCHAR2(32767); st INTEGER; BEGIN LOOP DBMS_OUTPUT.GET_LINE(l, st); EXIT WHEN st <> 0; END LOOP; END;
    PROCEDURE judge(p_label VARCHAR2, p_cur IN OUT SYS_REFCURSOR, p_col VARCHAR2) IS
        c NUMBER; n PLS_INTEGER; d DBMS_SQL.DESC_TAB2; pos PLS_INTEGER := 0;
        v VARCHAR2(4000); prev VARCHAR2(4000); rows_n PLS_INTEGER := 0; inv PLS_INTEGER := 0; first_inv VARCHAR2(4000);
    BEGIN
        c := DBMS_SQL.TO_CURSOR_NUMBER(p_cur);
        DBMS_SQL.DESCRIBE_COLUMNS2(c, n, d);
        FOR i IN 1 .. n LOOP IF d(i).col_name = p_col THEN pos := i; END IF; END LOOP;
        DBMS_SQL.DEFINE_COLUMN(c, pos, v, 4000);
        WHILE DBMS_SQL.FETCH_ROWS(c) > 0 LOOP
            DBMS_SQL.COLUMN_VALUE(c, pos, v);
            rows_n := rows_n + 1;
            IF rows_n > 1 AND (UPPER(prev) > UPPER(v) OR (UPPER(prev) = UPPER(v) AND prev > v)) THEN
                inv := inv + 1;
                IF first_inv IS NULL THEN first_inv := SUBSTR(prev || '  >  ' || v, 1, 300); END IF;
            END IF;
            prev := v;
        END LOOP;
        DBMS_SQL.CLOSE_CURSOR(c);
        v_res := v_res || 'V3 ' || p_label || ' 행 ' || rows_n || ' · 순서 역전 ' || inv || ' → '
            || CASE WHEN inv = 0 THEN 'PASS' ELSE 'FAIL (예: ' || first_inv || ')' END || CHR(10);
    END;
BEGIN
    PKG_DMF0068.P_DMF0068_GET_LOOKUPPROJECT('40', 'R_S_GAP392_VERIFY', NULL, 'DMF0068', rc1, rcr);
    CLOSE rcr;
    drain;
    judge('Project 콤보', rc1, 'NAME');
    FOR i IN 1 .. vers.COUNT LOOP
        PKG_DMF0068.P_DMF0068_GET_ORDERLIST('40', vers(i), '202501', '202712', NULL, 'DMF0068', rc1, rc2, rcr);
        CLOSE rc2; CLOSE rcr;
        drain;
        judge('조회 결과 ' || SUBSTR(vers(i), 1, 3) || ' 분기', rc1, 'PROJECT_NAME');
    END LOOP;
    drain;
    DBMS_OUTPUT.ENABLE(NULL);
    DBMS_OUTPUT.PUT_LINE(RTRIM(v_res, CHR(10)));
END;
/
