-- 01_DIAG — 조회 전용. Sales Price(DMF0020) 에서 Sales Site 'AJ상사_AB_TES' 조회 시 기간 컬럼이 일부 주차만 나오는 현상 점검
-- 전체 F5 실행 (값 입력 없음 · 바인드 없음 · 데이터/객체 변경 없음). D6 은 조회 SP 를 1회 호출하지만 세션 작업 테이블만 쓰고 끝에 ROLLBACK 한다.
-- 조회 기간 = 당월 1일 ~ +6개월 말일 (화면에서 다른 기간으로 조회했다면 D3 의 "전체 기간" 값을 함께 본다)
--
-- 화면에 기간 컬럼이 나오려면 두 가지가 다 맞아야 한다:
--   (가) 조회 SP 가 그 기간을 컬럼으로 내려준다                    ← DB: PERIODCOLS(10_APPLY). 이 파일의 D1·D6 으로 확인
--   (나) BE 가 값이 NULL 인 컬럼도 응답에 담아 준다                ← BE: C_BE 2개 파일 배포 (DB 에서는 확인할 수 없다)
--        (나) 가 안 돼 있으면 D6 의 '값이 전부 빈 컬럼' 수만큼 화면에서 컬럼이 빠진다
--
-- * [D0] 접속 DB · PKG_DMF0020 상태·LAST_DDL
-- * [D1] SP 패치(PERIODCOLS) 적용 여부
-- * [D2] Sales Site 마스터 — 이 사이트가 어느 사업부에 있는지
-- * [D3] 판가 원장 요약 — 이 사이트에 판가가 있는 날짜 수 (조회 기간 안 / 전체 기간)
-- * [D4] 판가 원장 날짜 목록 — 조회 기간 안에서 판가가 있는 날짜. 이 중 월요일이거나 1일인 날짜가 화면에 보이던 주차다
-- * [D5] 달력 — 조회 기간에 있어야 할 주차·월 수 (보완 뒤 화면에 나와야 하는 기간 컬럼 수)
-- * [D6] 조회 SP 실제 호출 — SP 가 내려준 기간 컬럼 수 / 달력 대비 빠진 구간 / 값이 전부 빈 컬럼 수
--          기대(DB 쪽 보완 완료): 빠진 구간 0 → 'SP PASS'. 값이 전부 빈 컬럼 수 = BE 배포 전까지 화면에서 빠지는 컬럼 수
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 300 PAGESIZE 500

SELECT 'D0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, SYS_CONTEXT('USERENV','INSTANCE_NAME') INST, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'D0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0020' ORDER BY O.OBJECT_TYPE;

SELECT 'D1 패치' CHK, P.PATCH, COUNT(S.LINE) MARKER_CNT,
       CASE WHEN COUNT(S.LINE) = 0 THEN '미적용 → ' || P.FILE_NM || ' 실행 대상'
            WHEN COUNT(S.LINE) = P.WANT THEN '적용됨'
            ELSE '비정상 — 실행하지 말고 결과 회신' END JUDGE
  FROM (SELECT 'PERIODCOLS' PATCH, 'E20261013-DMF0020PERIODCOLS' MARK, 1 WANT, '10_APPLY' FILE_NM FROM DUAL) P
  LEFT JOIN USER_SOURCE S ON S.NAME = 'PKG_DMF0020' AND S.TYPE = 'PACKAGE BODY' AND S.TEXT LIKE '%' || P.MARK || '%'
 GROUP BY P.PATCH, P.WANT, P.FILE_NM
 ORDER BY P.PATCH;

SELECT 'D2 사이트' CHK, S.DIVISION_ID, S.SCM_SITE_ID, S.SITE_TYPE, S.VALID_YN, S.END_CUSTOMER
  FROM SCM_MST_SITE S
 WHERE S.SCM_SITE_ID = 'AJ상사_AB_TES'
 ORDER BY S.DIVISION_ID;

SELECT 'D3 판가 요약' CHK, P.DIVISION_ID,
       COUNT(DISTINCT CASE WHEN P.YYYYMMDD BETWEEN TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD') AND TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),7)-1,'YYYYMMDD') THEN P.YYYYMMDD END) DATES_IN_PERIOD,
       COUNT(DISTINCT P.YYYYMMDD) DATES_ALL, MIN(P.YYYYMMDD) FIRST_DATE, MAX(P.YYYYMMDD) LAST_DATE, COUNT(*) ROW_CNT,
       TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD') || '~' || TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),7)-1,'YYYYMMDD') PERIOD
  FROM SCM_MST_FUTURE_PRICE P
 WHERE P.SCM_SITE_ID = 'AJ상사_AB_TES'
 GROUP BY P.DIVISION_ID
 ORDER BY P.DIVISION_ID;

SELECT 'D4 판가 날짜' CHK, P.DIVISION_ID, P.YYYYMMDD, TO_CHAR(TO_DATE(P.YYYYMMDD,'YYYYMMDD'),'DY','NLS_DATE_LANGUAGE=ENGLISH') DOW,
       CASE WHEN TO_CHAR(TO_DATE(P.YYYYMMDD,'YYYYMMDD'),'DY','NLS_DATE_LANGUAGE=ENGLISH') = 'MON' OR SUBSTR(P.YYYYMMDD,7,2) = '01' THEN 'Y' ELSE 'N' END SHOWN_ON_SCREEN,
       COUNT(*) ROW_CNT, COUNT(DISTINCT P.ITEM_ID) ITEMS
  FROM SCM_MST_FUTURE_PRICE P
 WHERE P.SCM_SITE_ID = 'AJ상사_AB_TES'
   AND P.YYYYMMDD BETWEEN TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD') AND TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),7)-1,'YYYYMMDD')
 GROUP BY P.DIVISION_ID, P.YYYYMMDD
 ORDER BY P.DIVISION_ID, P.YYYYMMDD;

SELECT 'D5 달력' CHK, COUNT(DISTINCT C.BASIS_START_DATE) WEEKS, COUNT(DISTINCT C.BASIS_YYYYMM) MONTHS,
       COUNT(DISTINCT C.BASIS_START_DATE) + COUNT(DISTINCT C.BASIS_YYYYMM) EXPECTED_PERIOD_COLS,
       SUM(CASE WHEN C.BASIS_START_DATE IS NULL OR C.BASIS_YYYYMM IS NULL THEN 1 ELSE 0 END) EMPTY_DAYS,
       MIN(C.BASIS_START_DATE) FIRST_WEEK, MAX(C.BASIS_START_DATE) LAST_WEEK
  FROM SCM_SYS_CALENDAR_M C
 WHERE C.BASIS_YYYYMMDD BETWEEN TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD') AND TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),7)-1,'YYYYMMDD');

-- D6 — 조회 SP 호출 (사이트가 속한 사업부마다 1회). 결과 커서를 끝까지 읽어 기간 컬럼별 값 유무를 센다. 끝에 ROLLBACK.
DECLARE
  c_site CONSTANT VARCHAR2(200) := 'AJ상사_AB_TES';
  v_from VARCHAR2(8) := TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD'); v_to VARCHAR2(8) := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),7)-1,'YYYYMMDD');
  v_div_cnt PLS_INTEGER := 0;
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
  FOR dv IN (SELECT DIVISION_ID FROM SCM_MST_SITE WHERE SCM_SITE_ID = c_site
             UNION
             SELECT DIVISION_ID FROM SCM_MST_FUTURE_PRICE WHERE SCM_SITE_ID = c_site
             ORDER BY 1) LOOP
    v_div_cnt := v_div_cnt + 1;
    probe(dv.DIVISION_ID, c_site, v_from, v_to);
    v_out(v_out.COUNT + 1) := 'D6 div ' || dv.DIVISION_ID || ' site ' || c_site || ' (' || v_from || '~' || v_to || ') — 행 ' || v_rows || ' · SP 주차 컬럼 ' || v_w || ' · 월 컬럼 ' || v_m ||
      ' · 달력 구간 ' || v_cal || ' · 빠진 구간 ' || v_miss || ' · 값이 전부 빈 컬럼 ' || v_gone || ' · SP ' || TO_CHAR((DBMS_UTILITY.GET_TIME - t0)/100, 'FM99990.00') || 's → ' || verdict;
    v_out(v_out.COUNT + 1) := 'D6 div ' || dv.DIVISION_ID || ' SP 주차 = ' || NVL(v_list, '(없음)');
  END LOOP;
  DBMS_OUTPUT.ENABLE(NULL);
  FOR i IN 1 .. v_out.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE(v_out(i));
  END LOOP;
  IF v_div_cnt = 0 THEN
    DBMS_OUTPUT.PUT_LINE('D6 SKIP — Sales Site ''' || c_site || ''' 가 사이트 마스터·판가 원장 어디에도 없음 (사이트 이름 철자·공백 확인 후 회신)');
  END IF;
END;
/
