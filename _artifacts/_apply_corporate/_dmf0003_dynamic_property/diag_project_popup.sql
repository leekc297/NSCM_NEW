-- Project popup SP — row count via RAISE_APPLICATION_ERROR (ora.py 가 결과 캡쳐 가능)
DECLARE
  c1 SYS_REFCURSOR; c2 SYS_REFCURSOR;
  l_cid NUMBER; l_cnt PLS_INTEGER := 0; l_cols NUMBER;
  l_desc dbms_sql.desc_tab2;
  v_div VARCHAR2(2) := '&V_DIV';
BEGIN
  PKG_COM0000.P_COM0005_GET_PROJECT_BY_DIVISION_POPUP(
    v_div, 'ALL', 'ALL', 'ALL', '', '',
    c1, c2);
  l_cid := dbms_sql.to_cursor_number(c1);
  dbms_sql.describe_columns2(l_cid, l_cols, l_desc);
  WHILE dbms_sql.fetch_rows(l_cid) > 0 LOOP
    l_cnt := l_cnt + 1;
    EXIT WHEN l_cnt > 999999;
  END LOOP;
  dbms_sql.close_cursor(l_cid);
  RAISE_APPLICATION_ERROR(-20999,
    'DIV=' || v_div || ' / cursor_cols=' || l_cols || ' / row_count=' || l_cnt);
END;
/
