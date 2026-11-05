-- SOURCE-FRESH: SCM_MGR.PKG_DMF0049 PACKAGE BODY LAST_DDL=2026-10-22 11:44:39 FETCHED=2026-10-28 16:58 DB=ZIOUI1 (사내 기준본 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [E20261028-DUPKEYMSG] DMF0049 저장 키 중복 검증 = 저장 후 모습 기준 (전체 F5, 값 입력 없음, 멱등)
-- 증상: 같은 세트를 두 번째 저장하면 DMF0049 키 중복 메시지('데이터 저장 시 중복…') 대신
--       MOBILE 병합 메시지('ETC Report데이터를 Sales Report 데이터와 병합하는 과정에서 중복…')가 나왔다(전송 버전),
--       전송 전 버전은 아무 검증에도 걸리지 않고 저장되었다.
-- 원인: P_DMF0049_SAVE_SALES_ETC_REPORT_C 의 중복 검증이 "원장 x 이번 저장분" 을 12개 키로 조인해 COUNT>1 을 본다 →
--       원장 1건 x 저장분 1건 = 1 이라 두 번째 저장은 통과 (AS-IS 원문도 같은 식).
-- 변경: 중복 검증 2곳(건수 SELECT · 안내문 키 SELECT)을 "저장 후 모습" 기준으로 바꾼다.
--       저장 후 모습 = 원장 행 중 이번 저장분이 같은 PK(DATA_SEQ·MEASURE·YYYYMMDD)로 바꾸거나 지우는 행은 빼고
--                      + 이번 저장분 중 삭제(D)가 아닌 행. 12개 키(GAP358 빈 값 동일 취급 유지)로 묶어 2건 이상이고
--                      이번 저장분이 낀 묶음 = 중복 → 기존과 같은 키 중복 메시지·ROLLBACK·RETURN.
--       원래 줄은 '--[E20261028-DUPKEYMSG]ORIG ' 접두 주석으로 보존. 메시지 문구·다른 로직 무변경.
-- 범위: PKG_DMF0049 BODY 저장 프로시저 중복 검증 2곳. 메타·FE·권한 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 줄 단위로 읽어(FRESH-GATE = 실행 시점 원문) 저장 프로시저 범위 안에서 ASCII 앵커로 두 블록을 찾는다.
-- 가드: 마커 존재 시 무동작 · 블록 위치 못 찾거나 2개 이상이면 중단(원문 무변경) · ORA-24344 외 생성 오류 중단 · 컴파일 실패 시 원문 복원
-- 사내 ZIOUI1 적용 완료(2026-10-28). 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK_DUPKEYMSG_PATCH
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    TYPE t_lines IS TABLE OF VARCHAR2(32767) INDEX BY PLS_INTEGER;
    l        t_lines;
    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    v_code   PLS_INTEGER := 0;
    v_msg    VARCHAR2(4000);
    n1       PLS_INTEGER := 0;
    n2       PLS_INTEGER := 0;
    s_ln     PLS_INTEGER := 0;
    e_ln     PLS_INTEGER := 0;
    b1s      PLS_INTEGER := 0;
    b1e      PLS_INTEGER := 0;
    b2s      PLS_INTEGER := 0;
    b2e      PLS_INTEGER := 0;
    c_mark   CONSTANT VARCHAR2(40)  := '[E20261028-DUPKEYMSG]';
    c_orig   CONSTANT VARCHAR2(40)  := '--[E20261028-DUPKEYMSG]ORIG ';
    c_new1   CONSTANT VARCHAR2(8000) := q'~    -- [E20261028-DUPKEYMSG] NEW-BEGIN 2026.10.28 저장 후 모습(원장에 남을 행 + 이번 저장분) 기준 12키 중복 검증
    --   구 검증(원장 x 저장분 COUNT>1)은 같은 세트를 두 번째 저장할 때 1건으로 세어 통과 -> MOBILE 병합 검증 메시지로 넘어갔다.
    --   키 중복 메시지가 먼저 나오도록 변경(사용자 요청 2026-10-28). 이번 저장분이 낀 묶음만 판정.
    SELECT COUNT(*) INTO v_chk FROM (
        SELECT 1
          FROM (
                SELECT A.VERSION_NO, A.DIVISION_ID, A.DEPARTMENT_ID, A.DEPT_ID, A.ITEM_ID, A.MEASURE, A.YYYYMMDD, A.CURRENCY
                     , A.COMPANY_ID, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP, A.COUNTRY_CODE, 'A' AS SRC
                  FROM DM_PLN_SALES_ETC_REPORT_C A
                 WHERE A.DIVISION_ID = v_division_id AND A.VERSION_NO = v_version_no
                   AND NOT EXISTS ( SELECT 1 FROM SCM_MGR.GT_DMF0049_RESULTS_MST B
                                     WHERE B.DATA_SEQ = TO_CHAR(A.DATA_SEQ) AND B.MEASURE = A.MEASURE AND B.YYYYMMDD = A.YYYYMMDD )
                UNION ALL
                SELECT B.VERSION_NO, B.DIVISION_ID, B.DEPARTMENT_ID, B.DEPT_ID, B.ITEM_ID, B.MEASURE, B.YYYYMMDD, B.CURRENCY
                     , B.COMPANY_ID, B.END_CUST_REPORT, B.CUST_REPORT, B.PRODUCT_GROUP, B.COUNTRY_CODE, 'B' AS SRC
                  FROM SCM_MGR.GT_DMF0049_RESULTS_MST B
                 WHERE NVL(B.ACTIVE_FLAG, '/') <> 'D'
               ) X
         GROUP BY NVL(X.VERSION_NO,'/'), NVL(X.DIVISION_ID,'/'), NVL(X.DEPARTMENT_ID,'/'), NVL(X.DEPT_ID,'/'), NVL(X.ITEM_ID,'/')
                , NVL(X.MEASURE,'/'), NVL(X.YYYYMMDD,'/'), NVL(X.CURRENCY,'/'), NVL(X.COMPANY_ID,'/'), NVL(X.END_CUST_REPORT,'/')
                , NVL(X.CUST_REPORT,'/'), NVL(X.PRODUCT_GROUP,'/'), SCM_MGR.FN_GET_COUNTRY_KR_NAME(X.COUNTRY_CODE)
         HAVING COUNT(*) > 1 AND MAX(X.SRC) = 'B'
    );
    -- [E20261028-DUPKEYMSG] NEW-END
~';
    c_new2   CONSTANT VARCHAR2(8000) := q'~              -- [E20261028-DUPKEYMSG] NEW-BEGIN 2026.10.28 저장 후 모습(원장에 남을 행 + 이번 저장분) 기준 12키 중복 검증
              --   구 검증(원장 x 저장분 COUNT>1)은 같은 세트를 두 번째 저장할 때 1건으로 세어 통과 -> MOBILE 병합 검증 메시지로 넘어갔다.
              --   키 중복 메시지가 먼저 나오도록 변경(사용자 요청 2026-10-28). 이번 저장분이 낀 묶음만 판정.
              FROM ( SELECT MAX(X.VERSION_NO) VERSION_NO, MAX(X.DIVISION_ID) DIVISION_ID, MAX(X.DEPARTMENT_ID) DEPARTMENT_ID
                          , MAX(X.DEPT_ID) DEPT_ID, MAX(X.ITEM_ID) ITEM_ID, MAX(X.MEASURE) MEASURE, MAX(X.YYYYMMDD) YYYYMMDD
                          , MAX(X.CURRENCY) CURRENCY, MAX(X.COMPANY_ID) COMPANY_ID, MAX(X.END_CUST_REPORT) END_CUST_REPORT
                          , MAX(X.CUST_REPORT) CUST_REPORT, MAX(X.PRODUCT_GROUP) PRODUCT_GROUP
                          , SCM_MGR.FN_GET_COUNTRY_KR_NAME(MAX(X.COUNTRY_CODE)) AS COUNTRY_KR_NAME
                       FROM (
                             SELECT A.VERSION_NO, A.DIVISION_ID, A.DEPARTMENT_ID, A.DEPT_ID, A.ITEM_ID, A.MEASURE, A.YYYYMMDD, A.CURRENCY
                                  , A.COMPANY_ID, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP, A.COUNTRY_CODE, 'A' AS SRC
                               FROM DM_PLN_SALES_ETC_REPORT_C A
                              WHERE A.DIVISION_ID = v_division_id AND A.VERSION_NO = v_version_no
                                AND NOT EXISTS ( SELECT 1 FROM SCM_MGR.GT_DMF0049_RESULTS_MST B
                                                  WHERE B.DATA_SEQ = TO_CHAR(A.DATA_SEQ) AND B.MEASURE = A.MEASURE AND B.YYYYMMDD = A.YYYYMMDD )
                             UNION ALL
                             SELECT B.VERSION_NO, B.DIVISION_ID, B.DEPARTMENT_ID, B.DEPT_ID, B.ITEM_ID, B.MEASURE, B.YYYYMMDD, B.CURRENCY
                                  , B.COMPANY_ID, B.END_CUST_REPORT, B.CUST_REPORT, B.PRODUCT_GROUP, B.COUNTRY_CODE, 'B' AS SRC
                               FROM SCM_MGR.GT_DMF0049_RESULTS_MST B
                              WHERE NVL(B.ACTIVE_FLAG, '/') <> 'D'
                            ) X
                      GROUP BY NVL(X.VERSION_NO,'/'), NVL(X.DIVISION_ID,'/'), NVL(X.DEPARTMENT_ID,'/'), NVL(X.DEPT_ID,'/'), NVL(X.ITEM_ID,'/')
                             , NVL(X.MEASURE,'/'), NVL(X.YYYYMMDD,'/'), NVL(X.CURRENCY,'/'), NVL(X.COMPANY_ID,'/'), NVL(X.END_CUST_REPORT,'/')
                             , NVL(X.CUST_REPORT,'/'), NVL(X.PRODUCT_GROUP,'/'), SCM_MGR.FN_GET_COUNTRY_KR_NAME(X.COUNTRY_CODE)
                      HAVING COUNT(*) > 1 AND MAX(X.SRC) = 'B' ) T
              -- [E20261028-DUPKEYMSG] NEW-END
~';
    PROCEDURE put(p VARCHAR2) IS
    BEGIN
        IF p IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(v_new, LENGTH(p), p); END IF;
    END;
BEGIN
    -- FRESH-GATE: 기준본 = 실행 시점의 이 DB USER_SOURCE (로컬 파일 아님)
    SELECT TEXT BULK COLLECT INTO l FROM USER_SOURCE WHERE NAME = 'PKG_DMF0049' AND TYPE = 'PACKAGE BODY' ORDER BY LINE;
    IF l.COUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, '중단 — PKG_DMF0049 BODY 없음');
    END IF;
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    DBMS_LOB.CREATETEMPORARY(v_new, TRUE);
    FOR k IN 1 .. l.COUNT LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(l(k)), l(k));
        IF s_ln = 0 AND REGEXP_LIKE(l(k), '^\s*PROCEDURE\s+P_DMF0049_SAVE_SALES_ETC_REPORT_C(\s|\(|$)', 'i') THEN s_ln := k; END IF;
        IF s_ln > 0 AND e_ln = 0 AND REGEXP_LIKE(l(k), '^\s*END\s+P_DMF0049_SAVE_SALES_ETC_REPORT_C\s*;', 'i') THEN e_ln := k; END IF;
    END LOOP;
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    IF s_ln = 0 OR e_ln = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 저장 프로시저 범위 못 찾음(시작 ' || s_ln || ' / 끝 ' || e_ln || '). 원문 무변경');
    END IF;
    -- 블록1: SELECT COUNT(*) INTO v_chk FROM ( … 원장 A JOIN GT B … HAVING COUNT(*) > 1 );
    FOR k IN s_ln .. e_ln - 3 LOOP
        IF REGEXP_LIKE(l(k), '^\s*SELECT\s+COUNT\(\*\)\s+INTO\s+v_chk\s+FROM\s+\(\s*$', 'i')
           AND INSTR(l(k + 2), 'DM_PLN_SALES_ETC_REPORT_C A') > 0
           AND INSTR(l(k + 3), 'GT_DMF0049_RESULTS_MST B') > 0 THEN
            n1 := n1 + 1; b1s := k;
        END IF;
    END LOOP;
    IF n1 <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 중복 검증 건수 블록 ' || n1 || '곳 (1 기대). 00_PRECHECK 회신. 원문 무변경');
    END IF;
    FOR k IN b1s + 1 .. LEAST(b1s + 40, e_ln) LOOP
        IF REGEXP_LIKE(l(k), '^\s*\);\s*$') THEN b1e := k; EXIT; END IF;
    END LOOP;
    -- 블록2: FROM ( SELECT A.VERSION_NO, A.DIVISION_ID, A.DEPARTMENT_ID … HAVING COUNT(*) > 1 ) T
    FOR k IN b1s .. e_ln LOOP
        IF REGEXP_LIKE(l(k), '^\s*FROM\s+\(\s*SELECT\s+A\.VERSION_NO,\s*A\.DIVISION_ID,\s*A\.DEPARTMENT_ID', 'i') THEN
            n2 := n2 + 1; b2s := k;
        END IF;
    END LOOP;
    IF n2 <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 중복 안내문 키 블록 ' || n2 || '곳 (1 기대). 00_PRECHECK 회신. 원문 무변경');
    END IF;
    FOR k IN b2s + 1 .. LEAST(b2s + 40, e_ln) LOOP
        IF REGEXP_LIKE(l(k), 'HAVING\s+COUNT\(\*\)\s*>\s*1\s*\)\s*T\s*$', 'i') THEN b2e := k; EXIT; END IF;
    END LOOP;
    IF b1e = 0 OR b2e = 0 OR b2s <= b1e THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 블록 끝 못 찾음(블록1 ' || b1s || '~' || b1e || ' / 블록2 ' || b2s || '~' || b2e || '). 원문 무변경');
    END IF;
    FOR k IN 1 .. l.COUNT LOOP
        IF k = b1s THEN put(c_new1); END IF;
        IF k = b2s THEN put(c_new2); END IF;
        IF k BETWEEN b1s AND b1e OR k BETWEEN b2s AND b2e THEN
            put(c_orig || l(k));
        ELSE
            put(l(k));
        END IF;
    END LOOP;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        v_code := SQLCODE; v_msg := SQLERRM;
    END;
    IF v_code NOT IN (0, -24344) THEN
        RAISE_APPLICATION_ERROR(-20006, '중단 — 생성 미실행 오류 ' || v_msg || ' (원문 무변경. 잠시 후 재실행)');
    END IF;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0049' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0049' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR x IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0049' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || x.LINE || ':' || x.POSITION || ' ' || x.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    SELECT COUNT(*) INTO n1 FROM USER_SOURCE WHERE NAME = 'PKG_DMF0049' AND TYPE = 'PACKAGE BODY' AND TEXT LIKE '%' || c_mark || '%NEW-BEGIN%';
    IF n1 <> 2 THEN
        RAISE_APPLICATION_ERROR(-20007, '확인 실패 — 적용 후 NEW-BEGIN ' || n1 || '곳 (2 기대). 90_VERIFY 회신');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0049 BODY ' || v_st || ' · 중복 검증 2곳 교체(블록1 ' || b1s || '~' || b1e || ' / 블록2 ' || b2s || '~' || b2e || ') · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0049' ORDER BY OBJECT_TYPE;
