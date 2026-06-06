--==============================================================================
-- 070_DMF0008_PROC_M_Inventory.sql
--
-- 목적: 500 / 403 fix 정확 작성 위한 메타 인벤토리
--==============================================================================
SET LINESIZE 250
SET PAGESIZE 200
SET SERVEROUTPUT ON

PROMPT === DIAG 1 : DMF0008_GET_UPDATE_HISTORY PROC_M 5 row 인벤토리 ===

SELECT proc_nm, col_nm, data_tp_cd, col_tp_cd, sort_ord
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE proc_nm = 'DMF0008_GET_UPDATE_HISTORY'
 ORDER BY sort_ord;

PROMPT === DIAG 2 : DMF0008_GET_MY_DIVISION_LIST SP 시그니처 (division sheet 호출 후보) ===

SELECT object_name, status,
       TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND object_name = 'DMF0008_GET_MY_DIVISION_LIST';

SELECT argument_name, position, data_type, in_out
  FROM all_arguments
 WHERE owner = 'SCM_MGR'
   AND object_name = 'DMF0008_GET_MY_DIVISION_LIST'
   AND package_name IS NULL
 ORDER BY position;

PROMPT === DIAG 3 : DMF0008/updateHistory/SEARCH = P_DMF0008_STATUS_UPDATE 매핑 점검 ===

-- DIAG 6 결과: updateHistory/SEARCH 의 API_ID = P_DMF0008_STATUS_UPDATE (BTN_MPG)
-- API_URL = DMF0008_GET_UPDATE_HISTORY
-- ⚠ API_ID 이름이 STATUS_UPDATE 인데 SP 는 UPDATE_HISTORY — 비일관성 (메타 등록 오류 의심)

SELECT 'BTN_MPG  updateHistory/SEARCH' AS source,
       api_id AS api_id_value,
       'expect P_DMF0008_UPDATE_HISTORY_GET (또는 별도 API_ID)' AS issue
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE mnu_id = 'DMF0008' AND sht_nm = 'updateHistory' AND mnu_btn_cd = 'SEARCH'
 UNION ALL
SELECT 'API_M  P_DMF0008_STATUS_UPDATE',
       api_url,
       'API_ID=STATUS_UPDATE 인데 API_URL=GET_UPDATE_HISTORY — 두 화면 (main/STATUS_UPDATE vs updateHistory/SEARCH) 가 같은 API_ID 공유'
  FROM SCM_MGR.SCM_ADM_API_M
 WHERE api_id = 'P_DMF0008_STATUS_UPDATE';

PROMPT === DIAG 4 : DMF0008_GET_UPDATE_HISTORY 정확 호출 (P_USER_ID named param) ===

DECLARE
  v_rc SYS_REFCURSOR;
BEGIN
  DMF0008_GET_UPDATE_HISTORY(
    P_USER_ID => 'minyonglee1',
    P_MENU_ID => 'DMF0008',
    O_RC1     => v_rc
  );
  DBMS_OUTPUT.PUT_LINE('UPDATE_HISTORY 정상 호출 OK (3 args)');
  CLOSE v_rc;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 200));
END;
/
