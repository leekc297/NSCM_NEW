SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET FEEDBACK ON

DECLARE
  v_src CLOB := EMPTY_CLOB();
  v_patched CLOB;
  v_pl NUMBER; v_al NUMBER;
BEGIN
  DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
  FOR rec IN (SELECT TEXT FROM USER_SOURCE WHERE NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST' AND TYPE='PROCEDURE' ORDER BY LINE) LOOP
    DBMS_LOB.APPEND(v_src, rec.TEXT);
  END LOOP;
  v_pl := DBMS_LOB.GETLENGTH(v_src);

  v_patched := REPLACE(v_src,
    'OPEN p_cursor_main FOR v_sql_text;',
    'INSERT INTO SCM_MGR.DBG_VSQL_DUMP(ID, TS, BODY) VALUES (1, SYSTIMESTAMP, v_sql_text); COMMIT;' || CHR(10) ||
    '    OPEN p_cursor_main FOR v_sql_text;');
  v_al := DBMS_LOB.GETLENGTH(v_patched);
  DBMS_OUTPUT.PUT_LINE('Source: ' || v_pl || '  Patched: ' || v_al);
  IF v_al > v_pl THEN
    v_patched := 'CREATE OR REPLACE ' || v_patched;
    EXECUTE IMMEDIATE v_patched;
    DBMS_OUTPUT.PUT_LINE('SP patched OK');
  ELSE
    DBMS_OUTPUT.PUT_LINE('PATTERN_NOT_FOUND');
  END IF;
  DBMS_LOB.FREETEMPORARY(v_src);
END;
/
EXIT
