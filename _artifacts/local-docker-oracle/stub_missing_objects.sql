-- 누락 객체 stub — PKG_COM0000 외 다수 PKG body 가 의존
-- 화면 작업 시점에 정밀 변환 가능, 지금은 일단 컴파일 통과 + 미사용 procedure 만 stub error 반환
ALTER SESSION SET CONTAINER = FREEPDB1;
SET SERVEROUTPUT ON SIZE UNLIMITED

-- 1. SCM_MGR.SCM_MST_ITEM_SN (빈 테이블 stub — DDL 누락분)
DECLARE v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM dba_tables WHERE owner='SCM_MGR' AND table_name='SCM_MST_ITEM_SN';
  IF v_cnt = 0 THEN
    EXECUTE IMMEDIATE 'CREATE TABLE SCM_MGR.SCM_MST_ITEM_SN (ITEM_ID VARCHAR2(50), SN_ID VARCHAR2(50), USE_YN VARCHAR2(1) DEFAULT ''N'') TABLESPACE TS_SCM_D01';
    DBMS_OUTPUT.PUT_LINE('Created stub SCM_MST_ITEM_SN');
  END IF;
END;
/

-- 2. TYPE T_STR_TABLE (FN_SPLITSTRING 반환 TABLE type)
DECLARE v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM dba_types WHERE owner='SCM_MGR' AND type_name='T_STR_TABLE';
  IF v_cnt = 0 THEN
    EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE SCM_MGR.T_STR_TABLE AS TABLE OF VARCHAR2(4000)';
    DBMS_OUTPUT.PUT_LINE('Created TYPE T_STR_TABLE');
  END IF;
END;
/

-- 3. FN_SPLITSTRING — TABLE-returning function (가장 일반적인 split 패턴)
CREATE OR REPLACE FUNCTION SCM_MGR.FN_SPLITSTRING(
  p_str   IN VARCHAR2,
  p_delim IN VARCHAR2 DEFAULT ','
) RETURN SCM_MGR.T_STR_TABLE PIPELINED IS
  v_start PLS_INTEGER := 1;
  v_pos   PLS_INTEGER;
  v_len   PLS_INTEGER;
BEGIN
  IF p_str IS NULL THEN RETURN; END IF;
  v_len := LENGTH(p_delim);
  LOOP
    v_pos := INSTR(p_str, p_delim, v_start);
    IF v_pos = 0 THEN
      PIPE ROW(SUBSTR(p_str, v_start));
      EXIT;
    END IF;
    PIPE ROW(SUBSTR(p_str, v_start, v_pos - v_start));
    v_start := v_pos + v_len;
  END LOOP;
  RETURN;
END;
/

-- 4. UF_FX_STRING_SPLIT, UF_FX_STRING_SPLITFORIN — same pattern wrappers
CREATE OR REPLACE FUNCTION SCM_MGR.UF_FX_STRING_SPLIT(
  p_str   IN VARCHAR2,
  p_delim IN VARCHAR2 DEFAULT ','
) RETURN SCM_MGR.T_STR_TABLE PIPELINED IS
  v_start PLS_INTEGER := 1;
  v_pos   PLS_INTEGER;
  v_len   PLS_INTEGER;
BEGIN
  IF p_str IS NULL THEN RETURN; END IF;
  v_len := LENGTH(p_delim);
  LOOP
    v_pos := INSTR(p_str, p_delim, v_start);
    IF v_pos = 0 THEN
      PIPE ROW(SUBSTR(p_str, v_start));
      EXIT;
    END IF;
    PIPE ROW(SUBSTR(p_str, v_start, v_pos - v_start));
    v_start := v_pos + v_len;
  END LOOP;
  RETURN;
END;
/

CREATE OR REPLACE FUNCTION SCM_MGR.UF_FX_STRING_SPLITFORIN(
  p_str   IN VARCHAR2,
  p_delim IN VARCHAR2 DEFAULT ','
) RETURN SCM_MGR.T_STR_TABLE PIPELINED IS
  v_start PLS_INTEGER := 1;
  v_pos   PLS_INTEGER;
  v_len   PLS_INTEGER;
BEGIN
  IF p_str IS NULL THEN RETURN; END IF;
  v_len := LENGTH(p_delim);
  LOOP
    v_pos := INSTR(p_str, p_delim, v_start);
    IF v_pos = 0 THEN
      PIPE ROW(SUBSTR(p_str, v_start));
      EXIT;
    END IF;
    PIPE ROW(SUBSTR(p_str, v_start, v_pos - v_start));
    v_start := v_pos + v_len;
  END LOOP;
  RETURN;
END;
/

-- 5. Try recompile all SCM_MGR INVALID objects again
BEGIN
  FOR i IN 1..3 LOOP
    FOR r IN (SELECT object_name, object_type FROM dba_objects WHERE owner='SCM_MGR' AND status='INVALID' AND object_type IN ('PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION','VIEW','TRIGGER')) LOOP
      BEGIN
        IF r.object_type = 'PACKAGE BODY' THEN
          EXECUTE IMMEDIATE 'ALTER PACKAGE SCM_MGR.'||r.object_name||' COMPILE BODY';
        ELSE
          EXECUTE IMMEDIATE 'ALTER '||r.object_type||' SCM_MGR.'||r.object_name||' COMPILE';
        END IF;
      EXCEPTION WHEN OTHERS THEN NULL;
      END;
    END LOOP;
  END LOOP;
END;
/

PROMPT === INVALID after stub + recompile ===
SELECT object_type||':'||COUNT(*) AS info FROM dba_objects WHERE owner='SCM_MGR' AND status='INVALID' GROUP BY object_type;
SELECT object_name, object_type FROM dba_objects WHERE owner='SCM_MGR' AND status='INVALID' ORDER BY object_type, object_name;
EXIT
