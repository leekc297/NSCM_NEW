--------------------------------------------------------------------------------
-- 99_ROLLBACK — 원복 (신 문구 → 구 문구). 10_PATCH 의 역방향, 동일 외과적 방식.
--------------------------------------------------------------------------------
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

DECLARE
    C_OWNER  CONSTANT VARCHAR2(30)  := 'PKG_DMF0082';
    C_START  CONSTANT VARCHAR2(100) := '[E20260608-000294]_문구변경 요청으로 인하여 문구 변경 진행 (START)';
    C_END    CONSTANT VARCHAR2(100) := '[E20260608-000294]_문구변경 요청으로 인하여 문구 변경 진행 (END)';
    C_ORIG   CONSTANT VARCHAR2(100) := '[E20260608-000294]_원소스 주석';

    v_ddl    CLOB;
    v_txt    VARCHAR2(32767);
    v_cnt    PLS_INTEGER;
    v_skip   BOOLEAN := FALSE;
    v_done   PLS_INTEGER := 0;
BEGIN
    EXECUTE IMMEDIATE 'ALTER SESSION SET DDL_LOCK_TIMEOUT = 60';

    SELECT COUNT(*) INTO v_cnt FROM USER_SOURCE
     WHERE NAME = C_OWNER AND TYPE = 'PACKAGE BODY' AND INSTR(TEXT, C_ORIG) > 0;
    IF v_cnt <> 1 THEN
        RAISE_APPLICATION_ERROR(-20011, 'ROLLBACK PRECHECK FAIL : 원소스 주석 ' || v_cnt || '건 (기대 1건)');
    END IF;

    DBMS_LOB.CREATETEMPORARY(v_ddl, TRUE);
    v_txt := 'CREATE OR REPLACE ';
    DBMS_LOB.WRITEAPPEND(v_ddl, LENGTH(v_txt), v_txt);

    FOR r IN (SELECT LINE, TEXT FROM USER_SOURCE
               WHERE NAME = C_OWNER AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        IF INSTR(r.TEXT, C_START) > 0 THEN
            v_skip := TRUE;                       -- 블록 시작 — 이후 라인 폐기
        END IF;

        IF v_skip AND INSTR(r.TEXT, C_ORIG) > 0 THEN
            -- 주석 처리된 원소스를 되살린다 : 선행 '--' 와 꼬리 주석 제거
            v_txt := REGEXP_REPLACE(RTRIM(r.TEXT, CHR(10) || CHR(13)), '^(\s*)--', '\1');
            v_txt := SUBSTR(v_txt, 1, INSTR(v_txt, ' --' || C_ORIG) - 1) || CHR(10);
            DBMS_LOB.WRITEAPPEND(v_ddl, LENGTH(v_txt), v_txt);
            v_done := v_done + 1;
        ELSIF NOT v_skip THEN
            DBMS_LOB.WRITEAPPEND(v_ddl, LENGTH(r.TEXT), r.TEXT);
        END IF;

        IF INSTR(r.TEXT, C_END) > 0 THEN
            v_skip := FALSE;                      -- 블록 종료
        END IF;
    END LOOP;

    IF v_done <> 1 THEN
        RAISE_APPLICATION_ERROR(-20012, 'ROLLBACK BUILD FAIL : 복원 ' || v_done || '건 (기대 1건)');
    END IF;

    EXECUTE IMMEDIATE v_ddl;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — 복원 1건 / DDL 길이 ' || DBMS_LOB.GETLENGTH(v_ddl));
    DBMS_LOB.FREETEMPORARY(v_ddl);
END;
/

SELECT OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;
SELECT LINE, TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
   AND INSTR(TEXT,'BIZ_TYPE 이 없어서') > 0 ORDER BY LINE;
