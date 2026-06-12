SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
WHENEVER SQLERROR CONTINUE

PROMPT === 1. 직접 SP 호출 test (사용자와 동일 payload) ===
DECLARE
  v_rc1 SYS_REFCURSOR;
  v_rc2 SYS_REFCURSOR;
  v_err VARCHAR2(4000);
  v_code VARCHAR2(20);
  v_msg  VARCHAR2(2000);
BEGIN
  DMF0043_SAVE_DM_MST_CONTRIBUTE_VER(
    'I',        -- activeFlag
    '',         -- verSeq (빈 — INSERT 시 자동 채번)
    '2025',     -- yyyy
    '25년 해외법인 기여도',  -- versionNm
    '',         -- description
    'Y',        -- validYn
    'minyonglee1',
    v_rc1, v_rc2
  );
  DBMS_OUTPUT.PUT_LINE('  call OK — cursors returned');

  -- o_rc1 fetch (ERR_EVENT/RESULT_CODE/RESULT_MSG)
  IF v_rc1 IS NOT NULL THEN
    LOOP
      FETCH v_rc1 INTO v_code, v_msg, v_err;
      EXIT WHEN v_rc1%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('  RC1: ' || v_code || ' / ' || v_msg || ' / ' || v_err);
    END LOOP;
    CLOSE v_rc1;
  END IF;
  IF v_rc2 IS NOT NULL THEN CLOSE v_rc2; END IF;
  ROLLBACK;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('  call ERR SQLCODE=' || SQLCODE);
  DBMS_OUTPUT.PUT_LINE('  call ERR ' || SQLERRM);
  DBMS_OUTPUT.PUT_LINE('  bt: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  ROLLBACK;
END;
/

PROMPT === 2. SP body line 260~410 ===
SELECT LINE, TEXT
  FROM user_source
 WHERE name = 'DMF0043_SAVE_DM_MST_CONTRIBUTE_VER'
   AND type = 'PROCEDURE'
   AND LINE BETWEEN 260 AND 410
 ORDER BY LINE;
