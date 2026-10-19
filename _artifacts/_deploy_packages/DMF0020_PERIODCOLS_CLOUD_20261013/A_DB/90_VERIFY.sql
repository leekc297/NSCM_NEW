-- 90_VERIFY — V1~V2 조회 전용 · V3 = 조회 SP 1회 호출(세션 작업 테이블만 사용, 끝에 ROLLBACK)
-- * 기대: V1 PASS · V2 VALID/오류 0 · V3 'SP PASS …'
-- * 10 실행 전에 돌리면 V1 FAIL(0) · V3 = 'SP 가 데이터 구간만 내려줌' — 그 자체가 적용 전 증거
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 300 PAGESIZE 500
SELECT 'V1 마커' CHK, P.PATCH, COUNT(S.LINE) N, CASE WHEN COUNT(S.LINE) = P.WANT THEN 'PASS' ELSE 'FAIL (' || COUNT(S.LINE) || ' / 기대 ' || P.WANT || ')' END JUDGE
  FROM (SELECT 'PERIODCOLS' PATCH, 'E20261013-DMF0020PERIODCOLS' MARK, 1 WANT FROM DUAL) P
  LEFT JOIN USER_SOURCE S ON S.NAME = 'PKG_DMF0020' AND S.TYPE = 'PACKAGE BODY' AND S.TEXT LIKE '%' || P.MARK || '%'
 GROUP BY P.PATCH, P.WANT
 ORDER BY P.PATCH;
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0020')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0020' ORDER BY O.OBJECT_TYPE;
-- V3 — 기능 확인: 당월~+6개월 구간에서 "일부 날짜만 판가가 있는" Sales Site 1곳을 이 DB 원장에서 골라 조회 (값 입력 없음)
--   판정 = 달력 전체 구간이 SP 결과 컬럼으로 있다(빠진 구간 0). '값이 전부 빈 컬럼' 은 참고값 — 화면 표시는 BE(C_BE) 몫
DECLARE
  v_from VARCHAR2(8) := TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD'); v_to VARCHAR2(8) := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),7)-1,'YYYYMMDD');
  v_div VARCHAR2(20); v_site VARCHAR2(200); v_have PLS_INTEGER;
  rc1 SYS_REFCURSOR; rr SYS_REFCURSOR;
  cc INTEGER; n INTEGER; d DBMS_SQL.DESC_TAB; x NUMBER;
  TYPE t_set IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(128); s t_set; has_val t_set;
  v_w PLS_INTEGER; v_m PLS_INTEGER; v_cal PLS_INTEGER; v_miss PLS_INTEGER; v_gone PLS_INTEGER; v_rows PLS_INTEGER; v_list VARCHAR2(32767); t0 NUMBER;
  TYPE t_lines IS TABLE OF VARCHAR2(32767) INDEX BY PLS_INTEGER; v_out t_lines;   -- 결과 줄은 모아 두었다가 맨 끝에 찍는다
  PROCEDURE probe(p_div VARCHAR2, p_site VARCHAR2, p_from VARCHAR2, p_to VARCHAR2) IS
  BEGIN
    v_w := 0; v_m := 0; v_cal := 0; v_miss := 0; v_gone := 0; v_rows := 0; v_list := NULL; s.DELETE; has_val.DELETE;
    t0 := DBMS_UTILITY.GET_TIME;
    DBMS_OUTPUT.DISABLE;   -- SP 가 내부에서 찍는 긴 조회문 출력은 버린다 (DISABLE 은 버퍼를 비우므로 결과 줄은 v_out 에 모은다)
    SCM_MGR.PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE(p_div, 'ALL', 'ALL', p_site, 'ALL', 'ALL', 'ALL', 'ALL', 'ALL', p_from, p_to, 'ALL',
        'admin', 'ADMIN', 'ALL', 'N', 'N', 'Current', rc1, rr);
    cc := DBMS_SQL.TO_CURSOR_NUMBER(rc1);
    DBMS_SQL.DESCRIBE_COLUMNS(cc, n, d);
    FOR i IN 1 .. n LOOP
      IF d(i).col_name LIKE 'W\_%' ESCAPE '\' OR d(i).col_name LIKE 'M\_%' ESCAPE '\' THEN
        s(d(i).col_name) := i;
        DBMS_SQL.DEFINE_COLUMN(cc, i, x);
        IF d(i).col_name LIKE 'W%' THEN
          v_w := v_w + 1;
          IF v_list IS NULL OR LENGTH(v_list) < 3000 THEN v_list := v_list || CASE WHEN v_list IS NOT NULL THEN ',' END || SUBSTR(d(i).col_name, 3); END IF;
        ELSE
          v_m := v_m + 1;
        END IF;
      END IF;
    END LOOP;
    WHILE DBMS_SQL.FETCH_ROWS(cc) > 0 LOOP
      v_rows := v_rows + 1;
      FOR i IN 1 .. n LOOP
        IF s.EXISTS(d(i).col_name) AND NOT has_val.EXISTS(d(i).col_name) THEN
          DBMS_SQL.COLUMN_VALUE(cc, i, x);
          IF x IS NOT NULL THEN has_val(d(i).col_name) := 1; END IF;
        END IF;
      END LOOP;
    END LOOP;
    DBMS_SQL.CLOSE_CURSOR(cc); CLOSE rr;
    v_gone := v_w + v_m - has_val.COUNT;
    FOR c IN (SELECT 'W_' || BASIS_START_DATE K FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD BETWEEN p_from AND p_to AND BASIS_START_DATE IS NOT NULL
              UNION
              SELECT 'M_' || BASIS_YYYYMM || '01' FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD BETWEEN p_from AND p_to AND BASIS_YYYYMM IS NOT NULL) LOOP
      v_cal := v_cal + 1;
      IF NOT s.EXISTS(c.K) THEN v_miss := v_miss + 1; END IF;
    END LOOP;
    ROLLBACK;
  END;
  FUNCTION verdict RETURN VARCHAR2 IS
  BEGIN
    RETURN CASE WHEN v_miss > 0 THEN 'SP 가 데이터 구간만 내려줌 — PERIODCOLS(10_APPLY) 미적용 상태'
                WHEN v_rows = 0 THEN 'SP PASS (0행) — 이 사업부·기간에 조회되는 행이 없다. 화면은 행이 없으면 기간 컬럼도 없다'
                WHEN v_gone > 0 THEN 'SP PASS — Period 전체를 내려준다. 값이 전부 빈 컬럼 ' || v_gone || '개는 BE 가 NULL 컬럼을 응답에 담아야 화면에 보인다 (C_BE 배포 여부 확인)'
                ELSE 'SP PASS — Period 전체 구간에 값이 있다 → BE 설정과 무관하게 화면에 전부 표시' END;
  END;
BEGIN
  BEGIN
    SELECT DIVISION_ID, SCM_SITE_ID, W INTO v_div, v_site, v_have FROM (
      SELECT DIVISION_ID, SCM_SITE_ID, COUNT(DISTINCT YYYYMMDD) W, COUNT(*) C
        FROM SCM_MST_FUTURE_PRICE
       WHERE YYYYMMDD BETWEEN v_from AND v_to
       GROUP BY DIVISION_ID, SCM_SITE_ID
      HAVING COUNT(DISTINCT YYYYMMDD) < (SELECT COUNT(DISTINCT BASIS_START_DATE) FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD BETWEEN v_from AND v_to)
       ORDER BY W, C DESC, DIVISION_ID, SCM_SITE_ID) WHERE ROWNUM = 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('V3 SKIP — "일부 날짜만 판가가 있는" Sales Site 가 없음 (이 기간 증상 대상 없음)');
    RETURN;
  END;
  probe(v_div, v_site, v_from, v_to);
  DBMS_OUTPUT.ENABLE(NULL);
  DBMS_OUTPUT.PUT_LINE('V3 div ' || v_div || ' site ' || v_site || ' (' || v_from || '~' || v_to || ', 판가 보유 ' || v_have || '일) — 행 ' || v_rows || ' · SP 기간 컬럼 ' || (v_w + v_m) ||
    ' · 달력 구간 ' || v_cal || ' · 빠진 구간 ' || v_miss || ' · 값이 전부 빈 컬럼 ' || v_gone || ' · SP ' || TO_CHAR((DBMS_UTILITY.GET_TIME - t0)/100, 'FM99990.00') || 's → ' || verdict);
END;
/
