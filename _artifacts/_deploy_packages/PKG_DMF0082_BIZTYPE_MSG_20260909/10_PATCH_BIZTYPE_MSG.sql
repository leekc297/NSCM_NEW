--------------------------------------------------------------------------------
-- PKG_DMF0082 — [E20260608-000294] BIZ_TYPE 오류 메시지 문구 변경 (외과적 패치)
--
-- 대상 : SCM_MGR.PKG_DMF0082 (PACKAGE BODY) > P_DMF0082_SAVE_MAIN_DATA
-- 방식 : 현재 DB 의 PACKAGE BODY 원문을 읽어 **해당 1줄만** 치환 후 재컴파일.
--        전체본 덮어쓰기 아님 — 클라우드 baseline 이 무엇이든 이 변경만 적용된다.
-- 실행 : SQL*Plus / SQLcl 에서 SCM_MGR 로 접속 후 그대로 실행
--------------------------------------------------------------------------------
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

DECLARE
    C_OWNER  CONSTANT VARCHAR2(30)  := 'PKG_DMF0082';
    C_OLD    CONSTANT VARCHAR2(200) := q'[V_DESCRIPTION := 'Model*: ' || v_BIZ_TYPE_CHECK]';
    C_NEWTAG CONSTANT VARCHAR2(100) := 'MDM에서 Biz Type을 입력하시기';
    C_DRYRUN CONSTANT BOOLEAN       := FALSE;   -- TRUE = DDL 생성만 하고 적용하지 않음

    v_ddl    CLOB;
    v_txt    VARCHAR2(32767);
    v_ind    VARCHAR2(200);
    v_cnt    PLS_INTEGER;
    v_done   PLS_INTEGER := 0;
BEGIN
    EXECUTE IMMEDIATE 'ALTER SESSION SET DDL_LOCK_TIMEOUT = 60';

    -- G1) 중복 적용 차단
    SELECT COUNT(*) INTO v_cnt FROM USER_SOURCE
     WHERE NAME = C_OWNER AND TYPE = 'PACKAGE BODY' AND INSTR(TEXT, C_NEWTAG) > 0;
    IF v_cnt > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'ALREADY APPLIED : 신 문구 ' || v_cnt || '건 존재 — 적용 중단');
    END IF;

    -- G2) 대상 LIVE 라인 유일성 (주석 라인 제외)
    SELECT COUNT(*) INTO v_cnt FROM USER_SOURCE
     WHERE NAME = C_OWNER AND TYPE = 'PACKAGE BODY'
       AND INSTR(TEXT, C_OLD) > 0 AND LTRIM(TEXT) NOT LIKE '--%';
    IF v_cnt <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'PRECHECK FAIL : 대상 LIVE 라인 ' || v_cnt || '건 (기대 1건) — 적용 중단');
    END IF;

    -- 본문 재조립
    DBMS_LOB.CREATETEMPORARY(v_ddl, TRUE);
    v_txt := 'CREATE OR REPLACE ';
    DBMS_LOB.WRITEAPPEND(v_ddl, LENGTH(v_txt), v_txt);

    FOR r IN (SELECT LINE, TEXT FROM USER_SOURCE
               WHERE NAME = C_OWNER AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        IF INSTR(r.TEXT, C_OLD) > 0 AND LTRIM(r.TEXT) NOT LIKE '--%' THEN
            v_ind := SUBSTR(r.TEXT, 1, INSTR(r.TEXT, 'V_DESCRIPTION') - 1);
            v_txt := v_ind || '--[E20260608-000294]_문구변경 요청으로 인하여 문구 변경 진행 (START)' || CHR(10)
                  || v_ind || '--' || LTRIM(RTRIM(r.TEXT, CHR(10) || CHR(13))) || ' --[E20260608-000294]_원소스 주석' || CHR(10)
                  || v_ind || q'[V_DESCRIPTION := '1. MDM에서 Biz Type을 입력하시기 바랍니다.' || CHR(10)]' || CHR(10)
                  || v_ind || q'[              || '2. MDM에 Biz Type이 입력된 상태면 SCM_FP에 CSR 요청하시기 바랍니다.';]' || CHR(10)
                  || v_ind || '--[E20260608-000294]_문구변경 요청으로 인하여 문구 변경 진행 (END)' || CHR(10);
            v_done := v_done + 1;
        ELSE
            v_txt := r.TEXT;
        END IF;
        DBMS_LOB.WRITEAPPEND(v_ddl, LENGTH(v_txt), v_txt);
    END LOOP;

    IF v_done <> 1 THEN
        RAISE_APPLICATION_ERROR(-20003, 'BUILD FAIL : 치환 ' || v_done || '건 (기대 1건) — 적용 중단');
    END IF;

    IF C_DRYRUN THEN
        DBMS_OUTPUT.PUT_LINE('DRY RUN  — 치환 1건 / DDL 길이 ' || DBMS_LOB.GETLENGTH(v_ddl) || ' (미적용)');
    ELSE
        EXECUTE IMMEDIATE v_ddl;
        DBMS_OUTPUT.PUT_LINE('APPLIED  — 치환 1건 / DDL 길이 ' || DBMS_LOB.GETLENGTH(v_ddl));
    END IF;

    DBMS_LOB.FREETEMPORARY(v_ddl);
END;
/

-- 컴파일 결과 즉시 확인
SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' ORDER BY OBJECT_TYPE;

SELECT LINE, POSITION, TEXT FROM USER_ERRORS
 WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE;
