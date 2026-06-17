-- DMF0003 메인 grid 0 row 진단 #1: ITEM_SINGLE 4 단계 GT row count 동시 측정
--   ORI (SCM_MST_ITEM_SN where DIV+ACTIVE) → A (GROUP BY) → B (SUBSTR 12) → V (A JOIN B + EXISTS LIKE)
--   각 GT row 측정으로 drop point 식별

DECLARE
  c1 SYS_REFCURSOR; c2 SYS_REFCURSOR; c3 SYS_REFCURSOR; c4 SYS_REFCURSOR;
  v_ori    PLS_INTEGER := 0;
  v_a      PLS_INTEGER := 0;
  v_b      PLS_INTEGER := 0;
  v_v      PLS_INTEGER := 0;
  v_si_all PLS_INTEGER := 0;
  v_si     PLS_INTEGER := 0;
BEGIN
  DMF0003_GET_MKT_FCST_DATA(
    '81', 'ALL','ALL','ALL','ALL','ALL','ALL','ALL',
    TO_CHAR(SYSDATE,'YYYYMMDD'), TO_CHAR(SYSDATE+90,'YYYYMMDD'),
    'minyonglee1', 'ADMIN', 'ALL','ALL','N','N','N','N','ALL','ALL',
    'minyonglee1','DMF0003',
    c1, c2, c3, c4);
  SELECT COUNT(*) INTO v_ori    FROM SCM_MGR.GT_GGET_ITEM_SINGLE_ORI;
  SELECT COUNT(*) INTO v_a      FROM SCM_MGR.GT_GGET_ITEM_SINGLE_A;
  SELECT COUNT(*) INTO v_b      FROM SCM_MGR.GT_GGET_ITEM_SINGLE_B;
  SELECT COUNT(*) INTO v_v      FROM SCM_MGR.GT_GGET_ITEM_SINGLE_V;
  SELECT COUNT(*) INTO v_si_all FROM SCM_MGR.GT_GGET_SITE_ITEM_ALL;
  SELECT COUNT(*) INTO v_si     FROM SCM_MGR.GT_GGET_SITE_ITEM;
  RAISE_APPLICATION_ERROR(-20999,
    'DIV=81 ORI=' || v_ori || ' A=' || v_a || ' B=' || v_b || ' V=' || v_v
    || ' SI_ALL=' || v_si_all || ' SI=' || v_si);
END;
/
