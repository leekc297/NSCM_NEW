-- DBMS_PROFILER 로 DMF0003_GET_MKT_FCST_DATA 실행 (1주 period, wildcard ITEM/PROJECT, OWNER='')
DECLARE
  c1 SYS_REFCURSOR; c2 SYS_REFCURSOR; c3 SYS_REFCURSOR; c4 SYS_REFCURSOR;
  v_runid PLS_INTEGER;
  v_si_all PLS_INTEGER; v_si PLS_INTEGER; v_data PLS_INTEGER;
BEGIN
  DBMS_PROFILER.START_PROFILER(
    run_comment => 'DMF0003 main grid timing analysis DIV=81 7day wildcard',
    run_number  => v_runid
  );
  DMF0003_GET_MKT_FCST_DATA(
    '81',
    'ALL','ALL','ALL','ALL','ALL',
    '%', '%',
    TO_CHAR(SYSDATE,'YYYYMMDD'), TO_CHAR(SYSDATE+7,'YYYYMMDD'),
    'minyonglee1', 'ADMIN', 'ALL',
    '',
    'N','N','N','N','ALL','ALL',
    'minyonglee1','DMF0003',
    c1, c2, c3, c4);
  DBMS_PROFILER.STOP_PROFILER;
  SELECT COUNT(*) INTO v_si_all FROM SCM_MGR.GT_GGET_SITE_ITEM_ALL;
  SELECT COUNT(*) INTO v_si     FROM SCM_MGR.GT_GGET_SITE_ITEM;
  SELECT COUNT(*) INTO v_data   FROM SCM_MGR.GT_GGET_MKT_FCST_DATA;
  RAISE_APPLICATION_ERROR(-20999,
    'RUNID=' || v_runid || ' SI_ALL=' || v_si_all || ' SI=' || v_si || ' DATA=' || v_data);
END;
/
