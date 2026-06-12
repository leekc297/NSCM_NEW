SET SERVEROUTPUT ON
DECLARE
  v_rc SYS_REFCURSOR;
  v_cols NUMBER := 0;
BEGIN
  -- BE 실 호출과 동일 signature: (yyyy, verSeq, dis, his, sesUserId, userGroup, OUT cursor)
  DMF0043_GET_CONTRIBUTE_MAIN_DATA('2024','12','ALL','N','minyonglee1','',v_rc);
  CLOSE v_rc;
  DBMS_OUTPUT.PUT_LINE('  caller OK — cursor opened and closed');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('  caller ERR: SQLCODE=' || SQLCODE);
  DBMS_OUTPUT.PUT_LINE('  caller ERR: ' || SQLERRM);
END;
/
