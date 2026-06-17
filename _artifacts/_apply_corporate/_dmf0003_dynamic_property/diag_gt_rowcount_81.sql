DECLARE
  c1 SYS_REFCURSOR; c2 SYS_REFCURSOR; c3 SYS_REFCURSOR; c4 SYS_REFCURSOR;
  v_dst_cnt   PLS_INTEGER := 0;
  v_data_cnt  PLS_INTEGER := 0;
  v_price_cnt PLS_INTEGER := 0;
  v_ssp_cnt   PLS_INTEGER := 0;
  v_bnp_cnt   PLS_INTEGER := 0;
BEGIN
  DMF0003_GET_MKT_FCST_DATA(
    '81', 'ALL','ALL','ALL','ALL','ALL','ALL','ALL',
    TO_CHAR(SYSDATE,'YYYYMMDD'), TO_CHAR(SYSDATE+90,'YYYYMMDD'),
    'minyonglee1', 'ADMIN', 'ALL','ALL','N','N','N','N','ALL','ALL',
    'minyonglee1','DMF0003',
    c1, c2, c3, c4);
  SELECT COUNT(*) INTO v_dst_cnt   FROM SCM_MGR.GT_GGET_MKT_FCST_DST;
  SELECT COUNT(*) INTO v_data_cnt  FROM SCM_MGR.GT_GGET_MKT_FCST_DATA;
  SELECT COUNT(*) INTO v_price_cnt FROM SCM_MGR.GT_GGET_SALES_PRICE;
  SELECT COUNT(*) INTO v_ssp_cnt   FROM SCM_MGR.GT_GGET_T_SSP_SYNC;
  SELECT COUNT(*) INTO v_bnp_cnt   FROM SCM_MGR.GT_GGET_T_BNP;
  RAISE_APPLICATION_ERROR(-20999,
    'DIV=81 GT_MKT_DST=' || v_dst_cnt || ' GT_MKT_DATA=' || v_data_cnt
    || ' GT_PRICE=' || v_price_cnt || ' GT_SSP=' || v_ssp_cnt || ' GT_BNP=' || v_bnp_cnt);
END;
/
