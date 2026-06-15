SET LINESIZE 32767 PAGESIZE 0 FEEDBACK ON SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  v_sql_text CLOB;
  v_rc SYS_REFCURSOR;
BEGIN
  SELECT BODY INTO v_sql_text FROM SCM_MGR.DBG_VSQL_DUMP WHERE ID=2;
  -- Remove 'A.' prefix from ORDER BY at end
  -- Find last ORDER BY and replace A.col with col
  -- Simple approach: replace ' ORDER BY A.' with ' ORDER BY ' and ', A.' AFTER that with ', '
  DECLARE
    v_order_pos NUMBER;
    v_before CLOB;
    v_after CLOB;
    v_fixed CLOB;
  BEGIN
    v_order_pos := INSTR(v_sql_text, ' ORDER BY A.', -1);
    DBMS_OUTPUT.PUT_LINE('ORDER BY pos: ' || v_order_pos);
    IF v_order_pos > 0 THEN
      v_before := DBMS_LOB.SUBSTR(v_sql_text, v_order_pos - 1, 1);
      v_after := DBMS_LOB.SUBSTR(v_sql_text, DBMS_LOB.GETLENGTH(v_sql_text) - v_order_pos + 1, v_order_pos);
      -- Replace 'A.' in just the ORDER BY portion
      v_after := REPLACE(v_after, ' ORDER BY A.', ' ORDER BY ');
      v_after := REPLACE(v_after, ', A.', ', ');
      v_fixed := v_before || v_after;
      DBMS_OUTPUT.PUT_LINE('Fixed length: ' || DBMS_LOB.GETLENGTH(v_fixed));
      BEGIN
        OPEN v_rc FOR v_fixed;
        DBMS_OUTPUT.PUT_LINE('FIXED SQL OK');
        CLOSE v_rc;
      EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('FIXED SQL FAIL: ' || SUBSTR(SQLERRM,1,300));
      END;
    END IF;
  END;
END;
/
EXIT
