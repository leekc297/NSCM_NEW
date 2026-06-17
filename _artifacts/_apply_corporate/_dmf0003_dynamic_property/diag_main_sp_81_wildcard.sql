-- SP body LIKE 패턴 검증: P_ITEM_ID/P_PROJECT_CODE = '%' (wildcard) 시도
DECLARE
  c1 SYS_REFCURSOR; c2 SYS_REFCURSOR; c3 SYS_REFCURSOR; c4 SYS_REFCURSOR;
  l_cid NUMBER; l_cnt PLS_INTEGER := 0; l_cols NUMBER;
  l_desc dbms_sql.desc_tab2;
  v_si PLS_INTEGER; v_data PLS_INTEGER; v_dst PLS_INTEGER;
BEGIN
  DMF0003_GET_MKT_FCST_DATA(
    '81', 'ALL','ALL','ALL','ALL','ALL',
    '%',    -- P_PROJECT_CODE = '%' (wildcard, NOT 'ALL')
    '%',    -- P_ITEM_ID = '%'
    TO_CHAR(SYSDATE,'YYYYMMDD'), TO_CHAR(SYSDATE+90,'YYYYMMDD'),
    'minyonglee1', 'ADMIN', 'ALL','ALL','N','N','N','N','ALL','ALL',
    'minyonglee1','DMF0003',
    c1, c2, c3, c4);
  SELECT COUNT(*) INTO v_si   FROM SCM_MGR.GT_GGET_SITE_ITEM;
  SELECT COUNT(*) INTO v_data FROM SCM_MGR.GT_GGET_MKT_FCST_DATA;
  SELECT COUNT(*) INTO v_dst  FROM SCM_MGR.GT_GGET_MKT_FCST_DST;
  l_cid := dbms_sql.to_cursor_number(c1);
  dbms_sql.describe_columns2(l_cid, l_cols, l_desc);
  WHILE dbms_sql.fetch_rows(l_cid) > 0 LOOP l_cnt := l_cnt + 1; END LOOP;
  dbms_sql.close_cursor(l_cid);
  RAISE_APPLICATION_ERROR(-20999,
    'DIV=81 wildcard P_ITEM_ID/P_PROJECT_CODE=% SITE_ITEM=' || v_si
    || ' MKT_DATA=' || v_data || ' MKT_DST=' || v_dst || ' MAIN_ROW=' || l_cnt);
END;
/
