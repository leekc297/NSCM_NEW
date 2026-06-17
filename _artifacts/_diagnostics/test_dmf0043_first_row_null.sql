SET SERVEROUTPUT ON
DECLARE
  v_rc       SYS_REFCURSOR;
  v_cur_id   INTEGER;
  v_col_cnt  INTEGER;
  v_desc_tab DBMS_SQL.DESC_TAB;
  v_status   INTEGER;
  v_val      VARCHAR2(4000);
  v_y_null   INTEGER := 0;
  v_y_val    INTEGER := 0;
  v_m_null   INTEGER := 0;
  v_m_val    INTEGER := 0;
BEGIN
  SCM_MGR.DMF0043_GET_CONTRIBUTE_MAIN_DATA('2024','1','ALL','N','minyonglee1','',v_rc);
  v_cur_id := DBMS_SQL.TO_CURSOR_NUMBER(v_rc);
  DBMS_SQL.DESCRIBE_COLUMNS(v_cur_id, v_col_cnt, v_desc_tab);
  FOR i IN 1 .. v_col_cnt LOOP
    DBMS_SQL.DEFINE_COLUMN(v_cur_id, i, v_val, 4000);
  END LOOP;
  v_status := DBMS_SQL.FETCH_ROWS(v_cur_id);
  IF v_status > 0 THEN
    FOR i IN 1 .. v_col_cnt LOOP
      DBMS_SQL.COLUMN_VALUE(v_cur_id, i, v_val);
      IF v_desc_tab(i).col_name LIKE 'Y#%' THEN
        IF v_val IS NULL THEN v_y_null := v_y_null + 1; ELSE v_y_val := v_y_val + 1; END IF;
      ELSIF v_desc_tab(i).col_name LIKE 'M#%' THEN
        IF v_val IS NULL THEN v_m_null := v_m_null + 1; ELSE v_m_val := v_m_val + 1; END IF;
      END IF;
    END LOOP;
  END IF;
  DBMS_OUTPUT.PUT_LINE('First row dynamic col NULL count:');
  DBMS_OUTPUT.PUT_LINE('  Y# NULL=' || v_y_null || ' / valued=' || v_y_val);
  DBMS_OUTPUT.PUT_LINE('  M# NULL=' || v_m_null || ' / valued=' || v_m_val);
  DBMS_SQL.CLOSE_CURSOR(v_cur_id);
END;
/
