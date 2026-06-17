DECLARE
  c1 SYS_REFCURSOR;
  c2 SYS_REFCURSOR;
  c3 SYS_REFCURSOR;
  c4 SYS_REFCURSOR;
BEGIN
  DMF0003_GET_MKT_FCST_DATA(
    '40',                                  -- P_DIVISION_ID
    'ALL',                                 -- P_SCM_SITE_ID
    'ALL',                                 -- P_PLANT_SITE_ID
    'ALL',                                 -- P_TEAM_ID
    'ALL',                                 -- P_CUSTOMER
    'ALL',                                 -- P_BIZ_TYPE
    'ALL',                                 -- P_PROJECT_CODE
    'ALL',                                 -- P_ITEM_ID
    TO_CHAR(SYSDATE,    'YYYYMMDD'),       -- P_FROM_YYYYMMDD
    TO_CHAR(SYSDATE+90, 'YYYYMMDD'),       -- P_TO_YYYYMMDD
    'admin',                               -- P_CREATED_BY
    'ADMIN',                               -- P_USER_GROUP
    'ALL',                                 -- P_ITEM_TYPE
    'ALL',                                 -- P_OWNER
    'N',                                   -- P_QTY_YN
    'N',                                   -- P_CELL_YN
    'N',                                   -- P_INVALID_EXEC
    'N',                                   -- P_AS_YN
    'ALL',                                 -- P_USER_DEPT_ID
    'ALL',                                 -- P_SENDER_CODE
    'minyonglee1',                         -- P_USER_ID
    'DMF0003',                             -- P_MENU_ID
    c1, c2, c3, c4
  );
  DBMS_OUTPUT.PUT_LINE('OK — SP returned 4 cursors');
END;
/
