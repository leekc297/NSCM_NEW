--==============================================================================
-- 060_DMF0008_division_updateHistory_Diagnose.sql
--
-- 목적: DMF0008 FE 조회 시 발생한 2 오류 진단
--   (1) /api/DMF0008/division/SEARCH/call-proc → 403 Forbidden
--   (2) /api/DMF0008/updateHistory/SEARCH/call-proc → 500 Internal Server Error
--
-- 실행: SCM_MGR 세션
-- 작성: 2026-06-05
--==============================================================================
SET LINESIZE 250
SET PAGESIZE 200
SET SERVEROUTPUT ON

PROMPT === DIAG 1 : DMF0008 BTN_MPG 전체 인벤토리 ===

SELECT BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD,
       BTN.API_ID, BTN.USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
 WHERE BTN.MNU_ID = 'DMF0008'
 ORDER BY BTN.SHT_NM, BTN.MNU_BTN_CD;

PROMPT === DIAG 2 : DMF0008/division/SEARCH 매핑 + GUEST 권한 ===

SELECT 'BTN_MPG' AS src,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
         WHERE MNU_ID='DMF0008' AND SHT_NM='division' AND MNU_BTN_CD='SEARCH') AS cnt,
       'expect 1 — 없으면 BTN_MPG 등록 필요' AS note FROM DUAL
UNION ALL
SELECT 'GUEST_BTN_PERM',
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
         WHERE USER_GR_ID='GUEST' AND MNU_ID='DMF0008' AND SHT_NM='division' AND MNU_BTN_CD='SEARCH'),
       'expect 1 — 없으면 GUEST 권한 등록 필요 → 403 원인'
  FROM DUAL;

PROMPT === DIAG 3 : DMF0008/division/SEARCH chain (BTN → API → PROC) ===

SELECT BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD, BTN.API_ID,
       API.API_URL,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M P WHERE P.PROC_NM = API.API_URL) AS PROC_M_CNT
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
  LEFT JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID = BTN.API_ID
 WHERE BTN.MNU_ID = 'DMF0008'
   AND BTN.SHT_NM = 'division';

PROMPT === DIAG 4 : DMF0008_GET_UPDATE_HISTORY SP 상태 + 시그니처 ===

SELECT object_name, object_type, status,
       TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND object_name IN ('DMF0008_GET_UPDATE_HISTORY', 'DMF0000_GET_UPDATE_HISTORY')
 ORDER BY object_name;

SELECT argument_name, position, data_type, in_out
  FROM all_arguments
 WHERE owner = 'SCM_MGR'
   AND object_name IN ('DMF0008_GET_UPDATE_HISTORY', 'DMF0000_GET_UPDATE_HISTORY')
   AND package_name IS NULL
 ORDER BY object_name, position;

PROMPT === DIAG 5 : DMF0008_GET_UPDATE_HISTORY INVALID 시 컴파일 오류 ===

SELECT name, type, line, position, text
  FROM all_errors
 WHERE owner = 'SCM_MGR'
   AND name IN ('DMF0008_GET_UPDATE_HISTORY', 'DMF0000_GET_UPDATE_HISTORY')
 ORDER BY name, sequence
 FETCH FIRST 30 ROWS ONLY;

PROMPT === DIAG 6 : DMF0008/updateHistory/SEARCH chain ===

SELECT BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD, BTN.API_ID,
       API.API_URL,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M P WHERE P.PROC_NM = API.API_URL) AS PROC_M_CNT
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
  LEFT JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID = BTN.API_ID
 WHERE BTN.MNU_ID = 'DMF0008'
   AND BTN.SHT_NM = 'updateHistory';

PROMPT === DIAG 7 : DMF0008_GET_UPDATE_HISTORY 단독 호출 ===

DECLARE
  v_rc SYS_REFCURSOR;
BEGIN
  DMF0008_GET_UPDATE_HISTORY(
    p_ses_user_id => 'minyonglee1',
    p_menu_id     => 'DMF0008',
    O_RC1         => v_rc
  );
  DBMS_OUTPUT.PUT_LINE('UPDATE_HISTORY 단독 호출 정상');
  CLOSE v_rc;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('UPDATE_HISTORY ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 200));
  DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === 판독 ===
PROMPT - DIAG 1 row 에 division/SEARCH 없음 → 403 원인 (BTN_MPG 누락)
PROMPT - DIAG 2 BTN_MPG=1 + GUEST_BTN_PERM=0 → 403 원인 (권한 누락)
PROMPT - DIAG 3 row 0 또는 PROC_M_CNT=0 → chain 끊김
PROMPT - DIAG 4 STATUS=VALID + 8 args → OK
PROMPT - DIAG 4 STATUS=INVALID → DIAG 5 컴파일 오류 확인 (500 원인)
PROMPT - DIAG 6 row 1 + chain OK 인데 DIAG 7 ERR → SP body runtime 오류
PROMPT - DIAG 7 ORA-xxxxx → 500 underlying 원인 확정
