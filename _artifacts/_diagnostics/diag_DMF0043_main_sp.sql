-- DMF0043_GET_CONTRIBUTE_MAIN_DATA cursor inspect (column metadata 출력)
SET SERVEROUTPUT ON
DECLARE
  v_rc       SYS_REFCURSOR;
  v_cur_id   INTEGER;
  v_col_cnt  INTEGER;
  v_desc_tab DBMS_SQL.DESC_TAB;
BEGIN
  -- 호출: yyyy=2024, ver=1, dis='ALL', his='N', user_id='minyonglee1', user_group=''
  DMF0043_GET_CONTRIBUTE_MAIN_DATA('2024','1','ALL','N','minyonglee1','',v_rc);

  v_cur_id := DBMS_SQL.TO_CURSOR_NUMBER(v_rc);
  DBMS_SQL.DESCRIBE_COLUMNS(v_cur_id, v_col_cnt, v_desc_tab);

  DBMS_OUTPUT.PUT_LINE('=== column count: ' || v_col_cnt || ' ===');
  FOR i IN 1 .. v_col_cnt LOOP
    DBMS_OUTPUT.PUT_LINE(i || ': ' || v_desc_tab(i).col_name);
  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cur_id);
END;
/
