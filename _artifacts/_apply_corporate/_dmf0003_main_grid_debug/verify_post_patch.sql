-- 변환 후 검증: DIV=81 'ALL' 매개변수 호출 + 6 룰 적용 효과 확인
DECLARE
  c1 SYS_REFCURSOR; c2 SYS_REFCURSOR; c3 SYS_REFCURSOR; c4 SYS_REFCURSOR;
  l_cid NUMBER; l_cnt PLS_INTEGER := 0; l_cols NUMBER;
  l_desc dbms_sql.desc_tab2;
  v_si_all PLS_INTEGER; v_si PLS_INTEGER; v_data PLS_INTEGER;
  v_split_item PLS_INTEGER; v_split_owner PLS_INTEGER; v_split_proj PLS_INTEGER;
BEGIN
  DMF0003_GET_MKT_FCST_DATA(
    '81', 'ALL','ALL','ALL','ALL','ALL','ALL','ALL',
    TO_CHAR(SYSDATE,'YYYYMMDD'), TO_CHAR(SYSDATE+7,'YYYYMMDD'),
    'minyonglee1', 'ADMIN', 'ALL','ALL','N','N','N','N','ALL','ALL',
    'minyonglee1','DMF0003',
    c1, c2, c3, c4);
  SELECT COUNT(*) INTO v_split_item  FROM SCM_MGR.GT_GGET_SPLIT_ITEM_ID;
  SELECT COUNT(*) INTO v_split_owner FROM SCM_MGR.GT_GGET_SPLIT_OWNER;
  SELECT COUNT(*) INTO v_split_proj  FROM SCM_MGR.GT_GGET_SPLIT_PROJECT_CODE;
  SELECT COUNT(*) INTO v_si_all      FROM SCM_MGR.GT_GGET_SITE_ITEM_ALL;
  SELECT COUNT(*) INTO v_si          FROM SCM_MGR.GT_GGET_SITE_ITEM;
  SELECT COUNT(*) INTO v_data        FROM SCM_MGR.GT_GGET_MKT_FCST_DATA;
  l_cid := dbms_sql.to_cursor_number(c1);
  dbms_sql.describe_columns2(l_cid, l_cols, l_desc);
  WHILE dbms_sql.fetch_rows(l_cid) > 0 LOOP l_cnt := l_cnt + 1; END LOOP;
  dbms_sql.close_cursor(l_cid);
  RAISE_APPLICATION_ERROR(-20999,
    'POST-PATCH DIV=81 7day ''ALL'' — '
    || 'SPLIT_ITEM=' || v_split_item || ' SPLIT_OWNER=' || v_split_owner || ' SPLIT_PROJ=' || v_split_proj
    || ' | SI_ALL=' || v_si_all || ' SI=' || v_si || ' DATA=' || v_data || ' MAIN_ROW=' || l_cnt);
END;
/
