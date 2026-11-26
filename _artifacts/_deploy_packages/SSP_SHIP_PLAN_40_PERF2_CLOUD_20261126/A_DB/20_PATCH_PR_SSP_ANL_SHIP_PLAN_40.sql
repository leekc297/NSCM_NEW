-- SOURCE-FRESH: SCM_MGR.PR_SSP_ANL_SHIP_PLAN_40 PROCEDURE LAST_DDL=2026-11-26 14:51:33 FETCHED=2026-11-26 15:12 DB=ZIOUI1
/* PR_SSP_ANL_SHIP_PLAN_40 : 클라우드 원문 위에 보완 3곳만 바꿈 (E20261126-OWMSMAX 1-1, E20261126-AGINGCUT 1-6, E20261126-WHSTKHD 2-14)
 * 위치마다 표식이 이미 있으면 SKIP. 바꿀 문장을 한 곳에서 찾지 못하면 전체 중단(-20011, 원문 무변경)
 * 그 밖의 줄은 클라우드 원문 그대로 둠. 컴파일 실패면 원문 복원(-20012)
 * SCM_MGR 접속, 전체 실행(F5). Output 창 문구 확인 */
SET SERVEROUTPUT ON SIZE UNLIMITED
ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;
DECLARE
    c_name CONSTANT VARCHAR2(128) := 'PR_SSP_ANL_SHIP_PLAN_40';
    o1 CONSTANT VARCHAR2(32767) := q'~                   AND O.PROD_GROUP = V_DIVISION_ID
                   AND FN_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)) IS NOT NULL
                ;
~';
    n1 CONSTANT VARCHAR2(32767) := q'~                   AND O.PROD_GROUP = V_DIVISION_ID
                   /* [E20261126-OWMSMAX] 행마다 함수 호출 -> 스칼라 서브쿼리 캐시(같은 PLANT_ID, ITEM_ID 는 1회). 클라우드 11-26 회차당 73~76초(83wgypmy3wyvu) */
                   AND (SELECT FN_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)) FROM DUAL) IS NOT NULL
                ;
~';
    o2 CONSTANT VARCHAR2(32767) := q'~           AND A.CUTOFF_DATE = B.CUTOFF_DATE
        ;
~';
    n2 CONSTANT VARCHAR2(32767) := q'~           AND A.CUTOFF_DATE = B.CUTOFF_DATE
         /* [E20261126-AGINGCUT] 조인 조건에서 나오는 조건을 바깥쪽 뷰에 명시(결과 같음). 뷰 CUTOFF_DATE = 원장 CUTOFF_DATE - 1 이므로 */
         /* A.CUTOFF_DATE > SYSDATE - 5 = A.ORG_CUTOFF_DATE > SYSDATE - 4. 원장 SCM_AGING_STOCK_H 전체 읽기 → CUTOFF_DATE 인덱스 범위 */
         WHERE A.DIVISION_ID     = V_DIVISION_ID
           AND A.ORG_CUTOFF_DATE > SYSDATE - 4
        ;
~';
    o3 CONSTANT VARCHAR2(32767) := q'~                    ,        P.YYYYMMDD
                    )
        SELECT
             Z.DIVISION_ID
            ,Z.PLAN_START_YYYYMMDD
~';
    n3 CONSTANT VARCHAR2(32767) := q'~                    ,        P.YYYYMMDD
                    )
        /* [E20261126-WHSTKHD] GTT 행 수를 1행으로 추정하면 Z 행마다 HD 를 다시 집계(SSP_ANL_HOLD_STOCK 인덱스 스킵 스캔 반복)함. */
        /* HD 는 한 번만 집계하도록 조인 조건 밀어넣기 금지. 클라우드 11-26 회차당 111 ~ 133초(aj7nw6qjt4tjv) */
        SELECT /*+ NO_PUSH_PRED(HD) */
             Z.DIVISION_ID
            ,Z.PLAN_START_YYYYMMDD
~';
    v_src  CLOB;
    v_old  CLOB;
    v_cnt  NUMBER := 0;
    v_st   VARCHAR2(30);
    PROCEDURE ap(c IN OUT NOCOPY CLOB, t VARCHAR2) IS
    BEGIN
        IF t IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(c, LENGTH(t), t); END IF;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    DBMS_LOB.CREATETEMPORARY(v_old, TRUE);
    ap(v_old, 'CREATE OR REPLACE ');
    FOR r IN (SELECT TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = c_name AND TYPE = 'PROCEDURE' ORDER BY LINE) LOOP
        ap(v_src, r.TEXT);
        ap(v_old, r.TEXT);
    END LOOP;
    IF DBMS_LOB.INSTR(v_src, 'E20261126-OWMSMAX') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  위치 1 (E20261126-OWMSMAX, 원 537줄) 이미 반영');
    ELSIF DBMS_LOB.INSTR(v_src, o1, 1, 1) = 0 OR DBMS_LOB.INSTR(v_src, o1, 1, 2) > 0 THEN
        RAISE_APPLICATION_ERROR(-20011, c_name || ' : 위치 1 (E20261126-OWMSMAX, 원 537줄) 바꿀 문장을 한 곳에서 찾지 못함. 원문 무변경. 15_DIFF_SOURCE 결과 회신');
    ELSE
        v_src := REPLACE(v_src, o1, n1);
        v_cnt := v_cnt + 1;
        DBMS_OUTPUT.PUT_LINE('> PATCH 위치 1 (E20261126-OWMSMAX, 원 537줄)');
    END IF;
    IF DBMS_LOB.INSTR(v_src, 'E20261126-AGINGCUT') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  위치 2 (E20261126-AGINGCUT, 원 909줄) 이미 반영');
    ELSIF DBMS_LOB.INSTR(v_src, o2, 1, 1) = 0 OR DBMS_LOB.INSTR(v_src, o2, 1, 2) > 0 THEN
        RAISE_APPLICATION_ERROR(-20011, c_name || ' : 위치 2 (E20261126-AGINGCUT, 원 909줄) 바꿀 문장을 한 곳에서 찾지 못함. 원문 무변경. 15_DIFF_SOURCE 결과 회신');
    ELSE
        v_src := REPLACE(v_src, o2, n2);
        v_cnt := v_cnt + 1;
        DBMS_OUTPUT.PUT_LINE('> PATCH 위치 2 (E20261126-AGINGCUT, 원 909줄)');
    END IF;
    IF DBMS_LOB.INSTR(v_src, 'E20261126-WHSTKHD') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  위치 3 (E20261126-WHSTKHD, 원 3216줄) 이미 반영');
    ELSIF DBMS_LOB.INSTR(v_src, o3, 1, 1) = 0 OR DBMS_LOB.INSTR(v_src, o3, 1, 2) > 0 THEN
        RAISE_APPLICATION_ERROR(-20011, c_name || ' : 위치 3 (E20261126-WHSTKHD, 원 3216줄) 바꿀 문장을 한 곳에서 찾지 못함. 원문 무변경. 15_DIFF_SOURCE 결과 회신');
    ELSE
        v_src := REPLACE(v_src, o3, n3);
        v_cnt := v_cnt + 1;
        DBMS_OUTPUT.PUT_LINE('> PATCH 위치 3 (E20261126-WHSTKHD, 원 3216줄)');
    END IF;
    IF v_cnt = 0 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  ' || c_name || ' 3곳 모두 이미 반영');
        RETURN;
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;
    EXCEPTION
        WHEN OTHERS THEN NULL;   /* ORA-24344 컴파일 오류는 아래 STATUS 로 판정 */
    END;
    SELECT STATUS INTO v_st FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = c_name AND OBJECT_TYPE = 'PROCEDURE';
    IF v_st <> 'VALID' THEN
        BEGIN EXECUTE IMMEDIATE v_old; EXCEPTION WHEN OTHERS THEN NULL; END;
        RAISE_APPLICATION_ERROR(-20012, c_name || ' : 컴파일 실패로 원문 복원함. ALL_ERRORS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> APPLY ' || c_name || ' · ' || v_st || ' · 바꾼 위치 ' || v_cnt);
END;
/
