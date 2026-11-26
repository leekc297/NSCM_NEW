-- SOURCE-FRESH: SCM_MGR.PR_SSP_ANL_SHIP_PLAN_40 PROCEDURE LAST_DDL=2026-11-26 11:26:06 FETCHED=2026-11-26 11:26 DB=ZIOUI1
/* PR_SSP_ANL_SHIP_PLAN_40 : 본문 BEGIN 다음 줄에 dynamic_sampling 2 세션 설정 2줄 추가 (E20261126-DS2)
 * 클라우드 원문(ALL_SOURCE, OWNER SCM_MGR) 위에 넣음(다른 줄 그대로). 이미 있으면 SKIP. 0열 BEGIN 줄이 없으면 중단(원문 무변경).
 * 컴파일 실패면 원문으로 되돌리고 오류. SCM_MGR 접속, 전체 실행(F5). Output 창 문구 확인 */
SET SERVEROUTPUT ON SIZE UNLIMITED
ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;
DECLARE
    c_name CONSTANT VARCHAR2(128) := 'PR_SSP_ANL_SHIP_PLAN_40';
    v_new  CLOB;
    v_old  CLOB;
    v_ins  BOOLEAN := FALSE;
    v_has  NUMBER;
    v_nl   VARCHAR2(2);
    v_st   VARCHAR2(30);
    PROCEDURE ap(c IN OUT NOCOPY CLOB, t VARCHAR2) IS
    BEGIN
        IF t IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(c, LENGTH(t), t); END IF;
    END;
BEGIN
    SELECT COUNT(*) INTO v_has FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = c_name AND TYPE = 'PROCEDURE' AND INSTR(TEXT, 'E20261126-DS2') > 0;
    IF v_has > 0 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  ' || c_name || ' 이미 반영됨(E20261126-DS2)');
        RETURN;
    END IF;
    DBMS_LOB.CREATETEMPORARY(v_new, TRUE);
    DBMS_LOB.CREATETEMPORARY(v_old, TRUE);
    ap(v_new, 'CREATE OR REPLACE ');
    ap(v_old, 'CREATE OR REPLACE ');
    FOR r IN (SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = c_name AND TYPE = 'PROCEDURE' ORDER BY LINE) LOOP
        ap(v_new, r.TEXT);
        ap(v_old, r.TEXT);
        IF NOT v_ins AND REGEXP_LIKE(r.TEXT, '^BEGIN[[:space:]]*$') THEN
            v_nl := CASE WHEN INSTR(r.TEXT, CHR(13)) > 0 THEN CHR(13) || CHR(10) ELSE CHR(10) END;
            ap(v_new, q'~    /* [E20261126-DS2] GTT(통계 없음) 행 수 추정용. 클라우드 optimizer_dynamic_sampling = 0 (2026-11-26 확인) */~' || v_nl);
            ap(v_new, q'~    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';~' || v_nl);
            v_ins := TRUE;
        END IF;
    END LOOP;
    IF NOT v_ins THEN
        RAISE_APPLICATION_ERROR(-20011, c_name || ' : 0열 BEGIN 줄 없음. 원문 무변경. 클라우드 원문 전달 필요');
    END IF;
    BEGIN
        EXECUTE IMMEDIATE v_new;
    EXCEPTION
        WHEN OTHERS THEN NULL;   /* ORA-24344 컴파일 오류는 아래 STATUS 로 판정 */
    END;
    SELECT STATUS INTO v_st FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = c_name AND OBJECT_TYPE = 'PROCEDURE';
    IF v_st <> 'VALID' THEN
        BEGIN EXECUTE IMMEDIATE v_old; EXCEPTION WHEN OTHERS THEN NULL; END;
        RAISE_APPLICATION_ERROR(-20012, c_name || ' : 컴파일 실패로 원문 복원함. ALL_ERRORS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> APPLY ' || c_name || ' · ' || v_st);
END;
/
