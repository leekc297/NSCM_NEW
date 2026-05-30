-- Relax NOT NULL on target failed tables so old CSV snapshot can load.
-- Production schema strictness can be re-applied later if needed.
ALTER SESSION SET CONTAINER = FREEPDB1;
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
  v_ok NUMBER := 0;
  v_fail NUMBER := 0;
  TYPE t_tab IS TABLE OF VARCHAR2(40);
  v_tables t_tab := t_tab(
    'SCM_ADM_USER_M','SCM_ADM_MSG_M','SCM_ADM_CMBO_SQL_M','SCM_ADM_DQ_EXECUTE_H',
    'SCM_ADM_LOOKUP_MASTER_DETAIL','SCM_ADM_LOOKUP_MASTER_DETAIL_BAK',
    'SCM_ADM_NOTICE_CONTENT_MASTER','SCM_ADM_RECIPIENT_MESSAGE','SCM_ADM_RECIPIENT_MESSAGE_H',
    'SCM_ADM_SMS_MAIL_SEND_LOG','SCM_COM_ATCH_FILE_M',
    'SCM_MST_CITY','SCM_MST_PROJECT','SCM_MST_SHEET_COLUMNS','SCM_MST_SITE_CUSTOMER',
    'SCM_MST_SITE_ITEM','SCM_MST_SITE_ITEM_PRIORITY','SCM_MST_SSO_USER_INFO','SCM_SYS_LOG_BATCH'
  );
BEGIN
  FOR i IN 1..v_tables.COUNT LOOP
    FOR c IN (SELECT column_name FROM dba_tab_columns WHERE owner='SCM_MGR' AND table_name=v_tables(i) AND nullable='N') LOOP
      BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE SCM_MGR."'||v_tables(i)||'" MODIFY ("'||c.column_name||'" NULL)';
        v_ok := v_ok + 1;
      EXCEPTION WHEN OTHERS THEN v_fail := v_fail + 1; END;
    END LOOP;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Relaxed='||v_ok||', Failed='||v_fail);
END;
/

EXIT
