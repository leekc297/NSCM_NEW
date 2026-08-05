-- =============================================================================
-- 03_EXTRACT_META.sql — 클라우드 sqlplus/SQLcl 실행 → &UI_ID._META.sql 생성 (spool)
-- 대상: UI 배선 메타 8테이블 + MSG/LBL 신규분 — 행 전체를 INSERT-only(NOT EXISTS) 문으로 생성
-- 원칙: 로컬(사내) 기존재 row 무변경 — PK(또는 지정 키) NOT EXISTS 멱등 / 감사컬럼 원본 보존
-- 범용 에미터: 컬럼 목록·PK 를 딕셔너리에서 동적 구성 (타 UI 재사용 — DEFINE 만 교체)
-- =============================================================================
DEFINE UI_ID      = 'SYS0016'
DEFINE OWNER      = 'SCM_MGR'
DEFINE META_SINCE = '20260728'  -- MSG/LBL 신규 등록분 시작일 (클라우드 작업 시작일)

SET SERVEROUTPUT ON SIZE UNLIMITED
SET PAGESIZE 0 LINESIZE 32767 TRIMSPOOL ON TRIMOUT ON HEADING OFF FEEDBACK OFF VERIFY OFF ECHO OFF

SPOOL &UI_ID._META.sql

DECLARE
    v_ui  CONSTANT VARCHAR2(30) := '&UI_ID';
    v_own CONSTANT VARCHAR2(30) := '&OWNER';

    -- 문자열 → SQL 리터럴 (따옴표 이스케이프 + 개행 CHR(10) 분해 + 2000자 분할)
    FUNCTION lit(p VARCHAR2) RETURN CLOB IS
        v CLOB := ''; seg VARCHAR2(32767); pos PLS_INTEGER; rest VARCHAR2(32767);
    BEGIN
        IF p IS NULL THEN RETURN 'NULL'; END IF;
        rest := REPLACE(p, CHR(13) || CHR(10), CHR(10));
        LOOP
            pos := INSTR(rest, CHR(10));
            IF pos = 0 THEN seg := rest; ELSE seg := SUBSTR(rest, 1, pos - 1); END IF;
            DECLARE s VARCHAR2(32767) := REPLACE(seg, '''', ''''''); c CLOB := ''; i PLS_INTEGER := 1;
            BEGIN
                IF s IS NULL THEN c := ''''''; END IF;
                WHILE i <= NVL(LENGTH(s), 0) LOOP
                    IF c IS NOT NULL AND DBMS_LOB.GETLENGTH(c) > 0 THEN c := c || '||'; END IF;
                    c := c || '''' || SUBSTR(s, i, 2000) || '''';
                    i := i + 2000;
                END LOOP;
                IF v IS NOT NULL AND DBMS_LOB.GETLENGTH(v) > 0 THEN v := v || '||CHR(10)||'; END IF;
                v := v || c;
            END;
            EXIT WHEN pos = 0;
            rest := SUBSTR(rest, pos + 1);
        END LOOP;
        RETURN v;
    END;

    -- [v3.1 2026-08-04] 개행 인식 분할 — 고정 2500자 분할은 토큰/리터럴 중간 개행을 만들고
    --   TRIMSPOOL 이 행끝 공백을 지워 산출 SQL 을 파손시킴 (SYS0016 SHEET_COLUMNS 3/13 사고).
    PROCEDURE put_clob(p CLOB) IS
        v_pos PLS_INTEGER := 1; v_nl PLS_INTEGER; v_len PLS_INTEGER := DBMS_LOB.GETLENGTH(p);
    BEGIN
        WHILE v_pos <= v_len LOOP
            v_nl := DBMS_LOB.INSTR(p, CHR(10), v_pos);
            IF v_nl = 0 OR v_nl IS NULL THEN v_nl := v_len + 1; END IF;
            DBMS_OUTPUT.PUT_LINE(RTRIM(DBMS_LOB.SUBSTR(p, LEAST(v_nl - v_pos, 32000), v_pos), CHR(13)));
            v_pos := v_nl + 1;
        END LOOP;
    END;

    -- p_keys: NULL 이면 PK 자동 조회, 없으면 오류 표기
    PROCEDURE emit(p_tab VARCHAR2, p_where VARCHAR2, p_keys VARCHAR2 DEFAULT NULL) IS
        TYPE t_col IS RECORD (name VARCHAR2(130), dtype VARCHAR2(30));
        TYPE t_cols IS TABLE OF t_col;
        cols   t_cols := t_cols();
        keys   VARCHAR2(4000) := p_keys;
        v_sel  CLOB := ''; v_cur INTEGER; v_cnt INTEGER; v_rows PLS_INTEGER := 0;
        v_val  VARCHAR2(32767); v_stmt CLOB; v_body CLOB; v_pred CLOB;
        v_names VARCHAR2(32767) := '';
    BEGIN
        FOR c IN (SELECT COLUMN_NAME, DATA_TYPE FROM ALL_TAB_COLUMNS
                  WHERE OWNER = v_own AND TABLE_NAME = p_tab ORDER BY COLUMN_ID) LOOP
            cols.EXTEND;
            cols(cols.COUNT).name  := c.COLUMN_NAME;
            cols(cols.COUNT).dtype := c.DATA_TYPE;
            v_names := v_names || CASE WHEN cols.COUNT > 1 THEN ', ' END || c.COLUMN_NAME;
            IF v_sel IS NOT NULL AND DBMS_LOB.GETLENGTH(v_sel) > 0 THEN v_sel := v_sel || ', '; END IF;
            v_sel := v_sel ||
                CASE WHEN c.DATA_TYPE = 'DATE' THEN 'TO_CHAR(' || c.COLUMN_NAME || ',''YYYYMMDDHH24MISS'')'
                     WHEN c.DATA_TYPE = 'NUMBER' THEN 'TO_CHAR(' || c.COLUMN_NAME || ')'
                     WHEN c.DATA_TYPE = 'CLOB' THEN 'DBMS_LOB.SUBSTR(' || c.COLUMN_NAME || ',32767,1)'
                     ELSE c.COLUMN_NAME END;
        END LOOP;
        IF keys IS NULL THEN
            SELECT LISTAGG(CC.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY CC.POSITION) INTO keys
            FROM ALL_CONSTRAINTS C JOIN ALL_CONS_COLUMNS CC
              ON C.OWNER = CC.OWNER AND C.CONSTRAINT_NAME = CC.CONSTRAINT_NAME
            WHERE C.OWNER = v_own AND C.TABLE_NAME = p_tab AND C.CONSTRAINT_TYPE = 'P';
        END IF;
        IF keys IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('-- !! ' || p_tab || ': PK 없음 + 키 미지정 — 추출 생략 (키 지정 후 재실행)');
            RETURN;
        END IF;
        DBMS_OUTPUT.PUT_LINE('-- ---- ' || p_tab || ' (' || p_where || ' / KEY=' || keys || ') ----');

        v_cur := DBMS_SQL.OPEN_CURSOR;
        DBMS_SQL.PARSE(v_cur, 'SELECT ' || v_sel || ' FROM ' || v_own || '.' || p_tab || ' WHERE ' || p_where, DBMS_SQL.NATIVE);
        FOR i IN 1 .. cols.COUNT LOOP
            DBMS_SQL.DEFINE_COLUMN(v_cur, i, v_val, 32767);
        END LOOP;
        v_cnt := DBMS_SQL.EXECUTE(v_cur);
        WHILE DBMS_SQL.FETCH_ROWS(v_cur) > 0 LOOP
            v_rows := v_rows + 1;
            v_body := ''; v_pred := '';
            FOR i IN 1 .. cols.COUNT LOOP
                DBMS_SQL.COLUMN_VALUE(v_cur, i, v_val);
                IF i > 1 THEN v_body := v_body || ',' || CHR(10) || '       '; END IF;
                v_body := v_body ||
                    CASE WHEN v_val IS NULL THEN 'NULL'
                         WHEN cols(i).dtype = 'DATE' THEN 'TO_DATE(''' || v_val || ''',''YYYYMMDDHH24MISS'')'
                         WHEN cols(i).dtype = 'NUMBER' THEN v_val
                         ELSE lit(v_val) END
                    || ' AS ' || cols(i).name;
                IF INSTR(',' || keys || ',', ',' || cols(i).name || ',') > 0 THEN
                    IF v_pred IS NOT NULL AND DBMS_LOB.GETLENGTH(v_pred) > 0 THEN v_pred := v_pred || ' AND '; END IF;
                    v_pred := v_pred || CASE WHEN v_val IS NULL
                                             THEN 'X.' || cols(i).name || ' IS NULL AND S.' || cols(i).name || ' IS NULL'
                                             ELSE 'X.' || cols(i).name || ' = S.' || cols(i).name END;
                END IF;
            END LOOP;
            v_stmt := 'INSERT INTO ' || v_own || '.' || p_tab || ' (' || v_names || ')' || CHR(10) ||
                      'SELECT ' || v_names || ' FROM (' || CHR(10) ||
                      'SELECT ' || v_body || CHR(10) || 'FROM DUAL) S' || CHR(10) ||
                      'WHERE NOT EXISTS (SELECT 1 FROM ' || v_own || '.' || p_tab || ' X WHERE ' || v_pred || ');' || CHR(10);
            put_clob(v_stmt);
        END LOOP;
        DBMS_SQL.CLOSE_CURSOR(v_cur);
        DBMS_OUTPUT.PUT_LINE('-- (' || p_tab || ' ' || v_rows || '행)');
        DBMS_OUTPUT.PUT_LINE('');
    EXCEPTION WHEN OTHERS THEN
        IF DBMS_SQL.IS_OPEN(v_cur) THEN DBMS_SQL.CLOSE_CURSOR(v_cur); END IF;
        DBMS_OUTPUT.PUT_LINE('-- !! ' || p_tab || ' 추출 오류: ' || SQLERRM);
    END;
BEGIN
    DBMS_OUTPUT.PUT_LINE('-- ' || v_ui || ' 배선 메타 (클라우드 추출 ' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') ||
                         ') — INSERT-only NOT EXISTS 멱등 / 감사컬럼 원본 보존');
    emit('SCM_ADM_MNU_M',                 'MNU_ID = ''' || v_ui || '''');
    emit('SCM_ADM_MNU_BTN_MPG_M',         'MNU_ID = ''' || v_ui || '''');
    emit('SCM_ADM_API_M',
         'API_ID IN (SELECT API_ID FROM ' || v_own || '.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = ''' || v_ui || ''')');
    emit('SCM_ADM_USER_GR_MNU_MPG_M',     'MNU_ID = ''' || v_ui || '''');
    emit('SCM_ADM_USER_GR_MNU_BTN_MPG_M', 'MNU_ID = ''' || v_ui || '''');
    emit('SCM_ADM_PROC_M',
         'PROC_NM IN (SELECT API_URL FROM ' || v_own || '.SCM_ADM_API_M WHERE API_ID IN ' ||
         '(SELECT API_ID FROM ' || v_own || '.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = ''' || v_ui || '''))',
         'PROC_NM,COL_NM');
    emit('SCM_MST_SHEET_COLUMNS',         'PROGRAM_ID = ''' || v_ui || '''',
         'PROGRAM_ID,SHEET_NAME,DIVISION_ID,COLUMN_NAME');
    emit('SCM_MST_SHEET_MEASURE',         'PROGRAM_ID = ''' || v_ui || '''',
         'PROGRAM_ID,SHEET_NAME,DIVISION_ID,COLUMN_NAME');
    emit('SCM_ADM_MSG_M',
         'CREATION_DATE >= TO_DATE(''&META_SINCE'',''YYYYMMDD'')');
    -- 콤보 사용 시 (FE useTabComboQueries 인벤토리로 SQL_ID 확인 후 주석 해제·치환)
    -- emit('SCM_ADM_CMBO_SQL_M', 'SQL_ID IN (''XXX'',''YYY'')');
    DBMS_OUTPUT.PUT_LINE('COMMIT;');
END;
/

SPOOL OFF
PROMPT === &UI_ID._META.sql 생성 완료 — "!!" 오류 0건 + 각 테이블 행수 확인 (DISCOVER [D] 와 일치해야 함) ===
