-- 66. SYS0013 PROC_M cursor COL_NM 표준화 — o_rc1 → o_rc (자매 SYS0010 표준)
-- 사고: BE callProc 시 cursor key 매핑 실패 → errorMessage null → NPE -9994
-- 표준 (feedback_sp_dual_out_cursor_pattern.md): GET SP dual OUT = O_RC + O_RESULT_CURSOR
BEGIN
  UPDATE SCM_ADM_PROC_M
     SET COL_NM='o_rc', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE PROC_NM LIKE 'PKG_SYS0013.%'
     AND COL_NM='o_rc1';
  COMMIT;
END;
/
