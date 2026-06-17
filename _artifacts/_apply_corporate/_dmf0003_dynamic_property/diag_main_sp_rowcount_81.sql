DECLARE
  c1 SYS_REFCURSOR; c2 SYS_REFCURSOR; c3 SYS_REFCURSOR; c4 SYS_REFCURSOR;
  l_cid NUMBER; l_cnt PLS_INTEGER := 0; l_cols NUMBER;
  l_desc dbms_sql.desc_tab2;
BEGIN
  DMF0003_GET_MKT_FCST_DATA(
    '81', 'ALL','ALL','ALL','ALL','ALL','ALL','ALL',
    TO_CHAR(SYSDATE,'YYYYMMDD'), TO_CHAR(SYSDATE+90,'YYYYMMDD'),
    'minyonglee1', 'ADMIN', 'ALL','ALL','N','N','N','N','ALL','ALL',
    'minyonglee1','DMF0003',
    c1, c2, c3, c4);
  l_cid := dbms_sql.to_cursor_number(c1);
  dbms_sql.describe_columns2(l_cid, l_cols, l_desc);
  WHILE dbms_sql.fetch_rows(l_cid) > 0 LOOP l_cnt := l_cnt + 1; END LOOP;
  dbms_sql.close_cursor(l_cid);
  RAISE_APPLICATION_ERROR(-20999, 'DIV=81 cursor_cols=' || l_cols || ' row_count=' || l_cnt);
END;
/
