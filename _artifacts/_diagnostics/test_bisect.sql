SET LINESIZE 32767 PAGESIZE 0 FEEDBACK ON SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  v_sql_text CLOB;
  v_rc SYS_REFCURSOR;
  v_cte_only CLOB;
  v_idx NUMBER;
BEGIN
  SELECT BODY INTO v_sql_text FROM SCM_MGR.DBG_VSQL_DUMP WHERE ID=2;
  -- Test A: extract CTE only (up to closing `)`)
  v_idx := INSTR(v_sql_text, 'A.EDIT_FLAG)') + LENGTH('A.EDIT_FLAG)');
  v_cte_only := DBMS_LOB.SUBSTR(v_sql_text, v_idx, 1);
  DBMS_OUTPUT.PUT_LINE('CTE_LEN=' || v_idx);
  -- Make it a standalone query
  v_cte_only := REPLACE(v_cte_only, 'WITH SALES_LIST AS (', '');
  v_cte_only := SUBSTR(v_cte_only, 1, LENGTH(v_cte_only)-1); -- remove final ')'
  BEGIN
    OPEN v_rc FOR v_cte_only;
    DBMS_OUTPUT.PUT_LINE('CTE inner standalone OK');
    CLOSE v_rc;
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('CTE inner FAIL: ' || SUBSTR(SQLERRM,1,500));
  END;
  -- Test B: outer SELECT only (with CTE)
  -- (skip for now)
END;
/
EXIT
