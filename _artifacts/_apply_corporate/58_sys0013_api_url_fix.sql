-- ============================================================================
-- 58. SYS0013 — SCM_ADM_API_M.API_URL 정정 (PLS-00201 즉시 fix)
-- ----------------------------------------------------------------------------
-- 작성  : 2026-06-15 (SYS0013 진입 SQL error)
-- 사고  : API_M.API_URL = 'P_SCM0005_*' (옛 명명, 사내 미존재)
--        → BE callProc PLS-00201 → -9994 "Sql Error"
--        실제 사내 SP family = DMF0027_GET_DM_TMP_DYNAMIC_QUERY_* (7개 VALID + SCMD_APP GRANT 보유)
-- ----------------------------------------------------------------------------
-- 정정 매핑 (확인된 GET 3건):
--   API_SCM0005_GET_QUERY_LIST   → DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST
--   API_SCM0005_GET_COLUMNS      → DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS
--   API_SCM0005_GET_PARAMETERS   → DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS
--
-- 보류 (사내 SP 미존재 — 별도 작업 필요):
--   API_SCM0005_GET_HISTORY      (history tab — query row 클릭 후 호출, enabled 가드 있음)
--   API_SCM0005_EXECUTE_QUERY    (Execute 버튼)
--   API_SCM0005_SAVE_QUERY/COLUMNS/PARAMETERS (SAVE 버튼)
-- ============================================================================

SET DEFINE OFF;
SET SERVEROUTPUT ON;

DECLARE
  v_cnt PLS_INTEGER := 0;
BEGIN
  UPDATE SCM_ADM_API_M
     SET API_URL='DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST',
         LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE API_ID='API_SCM0005_GET_QUERY_LIST';
  v_cnt := v_cnt + SQL%ROWCOUNT;

  UPDATE SCM_ADM_API_M
     SET API_URL='DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS',
         LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE API_ID='API_SCM0005_GET_COLUMNS';
  v_cnt := v_cnt + SQL%ROWCOUNT;

  UPDATE SCM_ADM_API_M
     SET API_URL='DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS',
         LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE API_ID='API_SCM0005_GET_PARAMETERS';
  v_cnt := v_cnt + SQL%ROWCOUNT;

  DBMS_OUTPUT.PUT_LINE('API_URL updated rows : ' || v_cnt || ' (3 기대)');
  COMMIT;
END;
/
