SET LINESIZE 32767 PAGESIZE 0 FEEDBACK ON SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  v_sql_text CLOB;
  v_inner CLOB;
  v_outer CLOB;
  v_idx_start NUMBER;
  v_idx_end NUMBER;
  v_rc SYS_REFCURSOR;
BEGIN
  SELECT BODY INTO v_sql_text FROM SCM_MGR.DBG_VSQL_DUMP WHERE ID=2;
  -- Extract inner CTE body: from after 'AS (' to before ') SELECT '
  v_idx_start := INSTR(v_sql_text, 'AS (') + 4;
  v_idx_end := INSTR(v_sql_text, ') SELECT ');
  v_inner := DBMS_LOB.SUBSTR(v_sql_text, v_idx_end - v_idx_start, v_idx_start);
  DBMS_OUTPUT.PUT_LINE('inner_len=' || LENGTH(v_inner));
  BEGIN
    OPEN v_rc FOR v_inner;
    DBMS_OUTPUT.PUT_LINE('INNER CTE OK');
    CLOSE v_rc;
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('INNER FAIL: ' || SUBSTR(SQLERRM, 1, 300));
  END;
  -- Extract outer: from ') SELECT ' onwards, wrap in WITH
  v_outer := 'WITH SALES_LIST AS (' || v_inner || ') ' || DBMS_LOB.SUBSTR(v_sql_text, DBMS_LOB.GETLENGTH(v_sql_text) - v_idx_end, v_idx_end + 2);
  DBMS_OUTPUT.PUT_LINE('outer_full_len=' || LENGTH(v_outer));
  BEGIN
    OPEN v_rc FOR v_outer;
    DBMS_OUTPUT.PUT_LINE('OUTER OK');
    CLOSE v_rc;
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('OUTER FAIL: ' || SUBSTR(SQLERRM, 1, 300));
  END;
END;
/
EXIT
