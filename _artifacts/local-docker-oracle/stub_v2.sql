ALTER SESSION SET CONTAINER = FREEPDB1;
SET SERVEROUTPUT ON SIZE UNLIMITED

-- Drop old TYPE chain (must drop FUNCTION first that depends on T_STR_TABLE)
BEGIN
  FOR r IN (SELECT object_name, object_type FROM dba_objects WHERE owner='SCM_MGR' AND object_name IN ('FN_SPLITSTRING','UF_FX_STRING_SPLIT','UF_FX_STRING_SPLITFORIN') AND object_type='FUNCTION') LOOP
    BEGIN EXECUTE IMMEDIATE 'DROP FUNCTION SCM_MGR.'||r.object_name; EXCEPTION WHEN OTHERS THEN NULL; END;
  END LOOP;
  BEGIN EXECUTE IMMEDIATE 'DROP TYPE SCM_MGR.T_STR_TABLE FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TYPE SCM_MGR.T_STR_OBJ FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
END;
/

-- OBJECT type with both TOKEN and VALUE columns (covers both usage patterns)
CREATE OR REPLACE TYPE SCM_MGR.T_STR_OBJ AS OBJECT (TOKEN VARCHAR2(4000), VALUE VARCHAR2(4000));
/

CREATE OR REPLACE TYPE SCM_MGR.T_STR_TABLE AS TABLE OF SCM_MGR.T_STR_OBJ;
/

CREATE OR REPLACE FUNCTION SCM_MGR.FN_SPLITSTRING(
  p_str   IN VARCHAR2,
  p_delim IN VARCHAR2 DEFAULT ','
) RETURN SCM_MGR.T_STR_TABLE PIPELINED IS
  v_start PLS_INTEGER := 1;
  v_pos   PLS_INTEGER;
  v_len   PLS_INTEGER;
  v_tok   VARCHAR2(4000);
BEGIN
  IF p_str IS NULL THEN RETURN; END IF;
  v_len := LENGTH(p_delim);
  LOOP
    v_pos := INSTR(p_str, p_delim, v_start);
    IF v_pos = 0 THEN
      v_tok := SUBSTR(p_str, v_start);
      PIPE ROW(SCM_MGR.T_STR_OBJ(v_tok, v_tok));
      EXIT;
    END IF;
    v_tok := SUBSTR(p_str, v_start, v_pos - v_start);
    PIPE ROW(SCM_MGR.T_STR_OBJ(v_tok, v_tok));
    v_start := v_pos + v_len;
  END LOOP;
  RETURN;
END;
/

CREATE OR REPLACE FUNCTION SCM_MGR.UF_FX_STRING_SPLIT(
  p_str   IN VARCHAR2,
  p_delim IN VARCHAR2 DEFAULT ','
) RETURN SCM_MGR.T_STR_TABLE PIPELINED IS
  v_start PLS_INTEGER := 1;
  v_pos   PLS_INTEGER;
  v_len   PLS_INTEGER;
  v_tok   VARCHAR2(4000);
BEGIN
  IF p_str IS NULL THEN RETURN; END IF;
  v_len := LENGTH(p_delim);
  LOOP
    v_pos := INSTR(p_str, p_delim, v_start);
    IF v_pos = 0 THEN
      v_tok := SUBSTR(p_str, v_start);
      PIPE ROW(SCM_MGR.T_STR_OBJ(v_tok, v_tok));
      EXIT;
    END IF;
    v_tok := SUBSTR(p_str, v_start, v_pos - v_start);
    PIPE ROW(SCM_MGR.T_STR_OBJ(v_tok, v_tok));
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
  v_tok   VARCHAR2(4000);
BEGIN
  IF p_str IS NULL THEN RETURN; END IF;
  v_len := LENGTH(p_delim);
  LOOP
    v_pos := INSTR(p_str, p_delim, v_start);
    IF v_pos = 0 THEN
      v_tok := SUBSTR(p_str, v_start);
      PIPE ROW(SCM_MGR.T_STR_OBJ(v_tok, v_tok));
      EXIT;
    END IF;
    v_tok := SUBSTR(p_str, v_start, v_pos - v_start);
    PIPE ROW(SCM_MGR.T_STR_OBJ(v_tok, v_tok));
    v_start := v_pos + v_len;
  END LOOP;
  RETURN;
END;
/

-- Recompile pass
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

SELECT object_type||':'||COUNT(*) AS info FROM dba_objects WHERE owner='SCM_MGR' AND status='INVALID' GROUP BY object_type;
SELECT 'PKG_COM0000_errors='||COUNT(*) FROM dba_errors WHERE owner='SCM_MGR' AND name='PKG_COM0000';
EXIT
