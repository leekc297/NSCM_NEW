SET LINESIZE 300
PROMPT === MERGE block 정밀 (line 260~340) ===
SELECT line, text
  FROM user_source
 WHERE name = 'DMF0043_SAVE_DM_MST_CONTRIBUTE_VER'
   AND type = 'PROCEDURE'
   AND line BETWEEN 260 AND 340
 ORDER BY line;

PROMPT === GT row 확인 후 즉시 ===
DECLARE
  v_rc1 SYS_REFCURSOR;
  v_rc2 SYS_REFCURSOR;
  v_n NUMBER;
BEGIN
  DMF0043_SAVE_DM_MST_CONTRIBUTE_VER('I','','2027','TEST_2027','','Y','minyonglee1',v_rc1,v_rc2);
  IF v_rc1 IS NOT NULL THEN CLOSE v_rc1; END IF;
  IF v_rc2 IS NOT NULL THEN CLOSE v_rc2; END IF;
  SELECT COUNT(*) INTO v_n FROM GT_SDMCV_RESULTS_MST_2;
  DBMS_OUTPUT.PUT_LINE('  GT count after SP: ' || v_n);
  FOR rec IN (SELECT active_flag, ver_seq, yyyy, version_nm, valid_yn FROM GT_SDMCV_RESULTS_MST_2)
  LOOP
    DBMS_OUTPUT.PUT_LINE('  GT row: [' || rec.active_flag || '][' || rec.ver_seq || '][' || rec.yyyy || '][' || rec.version_nm || '][' || rec.valid_yn || ']');
  END LOOP;
  ROLLBACK;
END;
/
