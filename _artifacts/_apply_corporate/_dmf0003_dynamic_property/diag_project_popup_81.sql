DECLARE
  c1 SYS_REFCURSOR; c2 SYS_REFCURSOR;
  l_cid NUMBER; l_cnt PLS_INTEGER := 0; l_cols NUMBER;
  l_desc dbms_sql.desc_tab2;
BEGIN
  PKG_COM0000.P_COM0005_GET_PROJECT_BY_DIVISION_POPUP(
    '81', 'ALL', 'ALL', 'ALL', '', '', c1, c2);
  l_cid := dbms_sql.to_cursor_number(c1);
  dbms_sql.describe_columns2(l_cid, l_cols, l_desc);
  WHILE dbms_sql.fetch_rows(l_cid) > 0 LOOP l_cnt := l_cnt + 1; END LOOP;
  dbms_sql.close_cursor(l_cid);
  RAISE_APPLICATION_ERROR(-20999, 'DIV=81 cursor_cols=' || l_cols || ' row_count=' || l_cnt);
END;
/
