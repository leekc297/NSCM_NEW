-- 02_MAKE_REPLAY_SCRIPT — 조회 전용 (전체 F5) · 클라우드 DB 를 바꾸지 않음
-- 목적: 01 의 저장 호출 1건을 '실행 가능한 PL/SQL 문장(재현 스크립트)' 으로 만들어 파일로 저장
--   · 로그 문장을 그대로 실행하면 인자 1개가 수십만 자라 PLS-00172(문자열 리터럴 32,767바이트 초과)
--     → 인자마다 CLOB 변수에 4,000자 조각을 이어 붙인 뒤 SP 를 호출하는 형태로 출력한다
-- 대상 선택: 아래 c_log_seq
--   · NULL(기본) = 1,000건 이상 저장 중 가장 최근 1건 자동 선택
--   · 특정 건 = 01 결과의 LOG_SEQ 숫자로 바꿔서 실행
-- 출력: SPOOL 파일 C:\temp\DMF0082_SAVE_REPLAY.sql  (C:\temp 폴더가 없으면 먼저 만들 것)
--       SQL Developer 는 '스크립트 실행(F5)' 이어야 SPOOL 이 동작한다. 실패 시 스크립트 출력창 전체를 복사해 .sql 로 저장
-- 출력 파일 검증: 파일 맨 아래 '-- REPLAY-END rows=… params=17 chars=…' 줄이 있어야 완전한 파일
SET SERVEROUTPUT ON SIZE UNLIMITED FORMAT WRAPPED
SET LINESIZE 32767
SET PAGESIZE 0
SET FEEDBACK OFF
SET HEADING OFF
SET VERIFY OFF
SET TRIMSPOOL ON
SET DEFINE OFF
SPOOL C:\temp\DMF0082_SAVE_REPLAY.sql

DECLARE
    c_log_seq   CONSTANT NUMBER := NULL;          -- ← 특정 건이면 LOG_SEQ 숫자로 변경
    c_chunk     CONSTANT PLS_INTEGER := 4000;
    v_seq       NUMBER;
    v_txt       CLOB;
    v_created   VARCHAR2(30);
    v_by        VARCHAR2(200);
    v_ms        NUMBER;
    v_len       PLS_INTEGER;
    v_pos       PLS_INTEGER;
    v_end       PLS_INTEGER;
    v_off       PLS_INTEGER;
    v_piece     VARCHAR2(32767);
    v_rows      PLS_INTEGER;
    v_total     PLS_INTEGER := 0;
    TYPE t_names IS TABLE OF VARCHAR2(30);
    v_names     t_names := t_names('P_ACTIVE_FLAG','P_DIVISION_ID','P_PROJECT_CODE','P_END_CUSTOMER','P_SCM_SITE_ID','P_ITEM_ID',
                                   'P_DOM_EXP','P_FCST_TYPE','P_INCOTERMS','P_MEASURE','P_PLANT_SITE_ID','P_CELL_PROD_SITE_ID',
                                   'P_YYYYMMDD','P_CURRENCY','P_QTY','P_CREATED_BY','P_AS_FROM_SITE');
    c_head      CONSTANT VARCHAR2(80) := '{call PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA( ''';
    c_sep       CONSTANT VARCHAR2(10) := ''', ''';
    c_tail      CONSTANT VARCHAR2(20) := ''', NULL)}';
    PROCEDURE o(p VARCHAR2) IS BEGIN DBMS_OUTPUT.PUT_LINE(p); END;
BEGIN
    -- 대상 1건 선택
    IF c_log_seq IS NOT NULL THEN
        v_seq := c_log_seq;
    ELSE
        SELECT MAX(LOG_SEQ) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE, LOG_SEQ) INTO v_seq
          FROM (SELECT LOG_SEQ, CREATE_DATE, SQL_TEXT,
                       DBMS_LOB.INSTR(SQL_TEXT, '( ''') + 3 P1_START,
                       DBMS_LOB.INSTR(SQL_TEXT, ''', ', 1, 1) P1_END
                  FROM SCM_MGR.SCM_COM_SQL_LOG
                 WHERE SQL_ID = 'com.lgcns.nscm.callProc'
                   AND DBMS_LOB.INSTR(SQL_TEXT, 'PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA') > 0)
         WHERE P1_END > P1_START
           AND REGEXP_COUNT(SUBSTR(SQL_TEXT, P1_START, P1_END - P1_START), '\^') + 1 >= 1000;
    END IF;
    IF v_seq IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'STOP - DMF0082 SAVE_MAIN_DATA 1,000건 이상 호출 로그 없음 (01 결과 확인)');
    END IF;

    SELECT SQL_TEXT, TO_CHAR(CREATE_DATE,'YYYY-MM-DD HH24:MI:SS'), CREATED_BY, ELAPSED_MS
      INTO v_txt, v_created, v_by, v_ms
      FROM SCM_MGR.SCM_COM_SQL_LOG WHERE LOG_SEQ = v_seq;
    v_len := DBMS_LOB.GETLENGTH(v_txt);

    -- 형식 검증: 시작 '{call …( '' ' · 끝 ''', NULL)}' · 구분자 ''', ''' 16개
    IF DBMS_LOB.INSTR(v_txt, c_head) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20002, 'STOP - 문장 시작 형식 불일치 LOG_SEQ=' || v_seq || ' : ' || DBMS_LOB.SUBSTR(v_txt, 80, 1));
    END IF;
    IF DBMS_LOB.SUBSTR(v_txt, LENGTH(c_tail), v_len - LENGTH(c_tail) + 1) <> c_tail THEN
        RAISE_APPLICATION_ERROR(-20003, 'STOP - 문장 끝 형식 불일치 LOG_SEQ=' || v_seq || ' : ' || DBMS_LOB.SUBSTR(v_txt, 40, v_len - 39));
    END IF;
    IF DBMS_LOB.INSTR(v_txt, c_sep, 1, 16) = 0 OR DBMS_LOB.INSTR(v_txt, c_sep, 1, 17) > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'STOP - 인자 구분자 수가 16 이 아님 (값 안에 '', '' 포함 가능) LOG_SEQ=' || v_seq);
    END IF;

    v_pos  := LENGTH(c_head) + 1;
    v_end  := DBMS_LOB.INSTR(v_txt, c_sep, v_pos, 1);
    v_rows := REGEXP_COUNT(SUBSTR(v_txt, v_pos, v_end - v_pos), '\^') + 1;

    o('-- DMF0082 SAVE REPLAY  (02_MAKE_REPLAY_SCRIPT 생성 ' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') || ' / DB ' || SYS_CONTEXT('USERENV','DB_NAME') || ')');
    o('-- 원본 LOG_SEQ=' || v_seq || '  CREATED=' || v_created || '  CREATED_BY=' || v_by || '  ELAPSED_MS=' || v_ms || '  SAVE_ROWS=' || v_rows || '  SQL_LEN=' || v_len);
    o('-- 주의: 실행하면 실제로 저장된다(SP 내부 COMMIT). 대상 DB 를 확인하고 실행할 것');
    o('SET SERVEROUTPUT ON SIZE UNLIMITED');
    o('SET DEFINE OFF');
    o('DECLARE');
    FOR i IN 1 .. 17 LOOP
        o('    v_' || LOWER(v_names(i)) || ' CLOB;');
    END LOOP;
    o('    v_rc  SYS_REFCURSOR;');
    o('    v_t0  TIMESTAMP;');
    o('    v_cur INTEGER; v_cnt INTEGER; v_desc DBMS_SQL.DESC_TAB2; v_val VARCHAR2(4000); v_line VARCHAR2(32767); v_n PLS_INTEGER := 0;');
    o('    FUNCTION tok(p CLOB) RETURN PLS_INTEGER IS BEGIN RETURN REGEXP_COUNT(p, ''\^'') + 1; END;');
    o('BEGIN');

    -- 인자 17개: CLOB 조각 이어 붙이기
    v_pos := LENGTH(c_head) + 1;
    FOR i IN 1 .. 17 LOOP
        IF i < 17 THEN
            v_end := DBMS_LOB.INSTR(v_txt, c_sep, v_pos, 1);
        ELSE
            v_end := v_len - LENGTH(c_tail) + 1;
        END IF;
        o('    DBMS_LOB.CREATETEMPORARY(v_' || LOWER(v_names(i)) || ', TRUE);   -- ' || v_names(i) || ' chars=' || (v_end - v_pos));
        v_off := v_pos;
        WHILE v_off < v_end LOOP
            v_piece := DBMS_LOB.SUBSTR(v_txt, LEAST(c_chunk, v_end - v_off), v_off);
            o('    DBMS_LOB.APPEND(v_' || LOWER(v_names(i)) || ', TO_CLOB(''' || REPLACE(v_piece, '''', '''''') || '''));');
            v_off := v_off + LEAST(c_chunk, v_end - v_off);
        END LOOP;
        v_total := v_total + (v_end - v_pos);
        v_pos := v_end + LENGTH(c_sep);
    END LOOP;

    -- 호출 + 결과 출력
    FOR i IN 1 .. 17 LOOP
        o('    DBMS_OUTPUT.PUT_LINE(''' || RPAD(v_names(i), 20) || ' len='' || DBMS_LOB.GETLENGTH(v_' || LOWER(v_names(i)) || ') || '' tokens='' || tok(v_' || LOWER(v_names(i)) || '));');
    END LOOP;
    o('    v_t0 := SYSTIMESTAMP;');
    o('    SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA(');
    FOR i IN 1 .. 17 LOOP
        o('        v_' || LOWER(v_names(i)) || ',');
    END LOOP;
    o('        v_rc);');
    o('    DBMS_OUTPUT.PUT_LINE(''ELAPSED '' || TO_CHAR(SYSTIMESTAMP - v_t0));');
    o('    v_cur := DBMS_SQL.TO_CURSOR_NUMBER(v_rc);');
    o('    DBMS_SQL.DESCRIBE_COLUMNS2(v_cur, v_cnt, v_desc);');
    o('    FOR c IN 1 .. v_cnt LOOP DBMS_SQL.DEFINE_COLUMN(v_cur, c, v_val, 4000); END LOOP;');
    o('    WHILE DBMS_SQL.FETCH_ROWS(v_cur) > 0 AND v_n < 50 LOOP');
    o('        v_n := v_n + 1; v_line := ''RESULT'';');
    o('        FOR c IN 1 .. v_cnt LOOP DBMS_SQL.COLUMN_VALUE(v_cur, c, v_val); v_line := v_line || '' | '' || v_desc(c).col_name || ''='' || v_val; END LOOP;');
    o('        DBMS_OUTPUT.PUT_LINE(SUBSTR(v_line, 1, 4000));');
    o('    END LOOP;');
    o('    DBMS_SQL.CLOSE_CURSOR(v_cur);');
    o('END;');
    o('/');
    o('-- REPLAY-END rows=' || v_rows || ' params=17 chars=' || v_total || ' LOG_SEQ=' || v_seq);
END;
/
SPOOL OFF
SET PAGESIZE 500
SET HEADING ON
SET FEEDBACK ON
