--==============================================================================
-- 070_DMF0008_sp_runtime_diagnose.sql
--
-- DMF0008 UpdateHistory + StatusUpdate SP 실 호출 + PROC_M 메타 검증
-- =============================================================================
-- 작성: 2026-06-17 (060 적용 후 권한 정상 확인 + 여전히 -9994 발생)
-- 권한 문제 해소 후 잔여 원인 진단: SP runtime / PROC_M 메타 mismatch.
--==============================================================================

SET LINESIZE 250
SET PAGESIZE 200
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === DIAG A : DMF0008_GET_UPDATE_HISTORY SP 단독 호출 (SCM_MGR 세션, 실 오류 캐치) ===

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_sdate VARCHAR2(30); v_edate VARCHAR2(30); v_by VARCHAR2(100);
BEGIN
  SCM_MGR.DMF0008_GET_UPDATE_HISTORY('minyonglee1', 'DMF0008', v_rc1);
  IF v_rc1 IS NOT NULL THEN
    FETCH v_rc1 INTO v_sdate, v_edate, v_by;
    DBMS_OUTPUT.PUT_LINE('[A OK] SDATE=' || NVL(v_sdate, 'NULL') ||
                         ' EDATE=' || NVL(v_edate, 'NULL') ||
                         ' BY=' || NVL(v_by, 'NULL'));
    CLOSE v_rc1;
  ELSE
    DBMS_OUTPUT.PUT_LINE('[A] cursor NULL');
  END IF;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('[A ERR] SQLCODE=' || SQLCODE);
  DBMS_OUTPUT.PUT_LINE('[A ERR] SQLERRM=' || SUBSTR(SQLERRM, 1, 300));
  DBMS_OUTPUT.PUT_LINE('[A ERR] STACK=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === DIAG B : DMF0000_GET_UPDATE_HISTORY (body) 단독 호출 — wrapper 우회 ===

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_rrc SYS_REFCURSOR;
  v_sdate VARCHAR2(30); v_edate VARCHAR2(30); v_by VARCHAR2(100);
BEGIN
  SCM_MGR.DMF0000_GET_UPDATE_HISTORY(v_rc1, v_rrc);
  FETCH v_rc1 INTO v_sdate, v_edate, v_by;
  DBMS_OUTPUT.PUT_LINE('[B OK] SDATE=' || NVL(v_sdate, 'NULL') ||
                       ' EDATE=' || NVL(v_edate, 'NULL') ||
                       ' BY=' || NVL(v_by, 'NULL'));
  CLOSE v_rc1; CLOSE v_rrc;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('[B ERR] SQLCODE=' || SQLCODE);
  DBMS_OUTPUT.PUT_LINE('[B ERR] SQLERRM=' || SUBSTR(SQLERRM, 1, 300));
  DBMS_OUTPUT.PUT_LINE('[B ERR] STACK=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === DIAG C : DMF0008/updateHistory chain — BTN_MPG → API_M → PROC_M → SP ===

SELECT BTN.MNU_BTN_CD, BTN.API_ID,
       API.API_URL AS PROC_NM,
       (SELECT object_name || ' ' || status FROM all_objects
         WHERE owner='SCM_MGR' AND object_name=API.API_URL AND object_type='PROCEDURE' AND ROWNUM=1) AS SP_STATUS
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
  LEFT JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID = BTN.API_ID
 WHERE BTN.MNU_ID = 'DMF0008' AND BTN.SHT_NM = 'updateHistory';

PROMPT === DIAG D : updateHistory SP 의 PROC_M 인자 매핑 (BE 가 채울 메타) ===

SELECT P.PROC_NM, P.COL_NM, P.DATA_TP_CD, P.COL_TP_CD, P.SORT_ORD
  FROM SCM_MGR.SCM_ADM_PROC_M P
 WHERE P.PROC_NM IN (
   SELECT API.API_URL FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
     JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID = BTN.API_ID
    WHERE BTN.MNU_ID = 'DMF0008' AND BTN.SHT_NM = 'updateHistory'
 )
 ORDER BY P.PROC_NM, P.SORT_ORD;

PROMPT === DIAG E : updateHistory SP 의 실 ALL_ARGUMENTS (SP 컴파일 시그니처) ===

SELECT argument_name, position, data_type, in_out, sequence
  FROM all_arguments
 WHERE owner = 'SCM_MGR'
   AND object_name IN (
     SELECT API.API_URL FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
       JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID = BTN.API_ID
      WHERE BTN.MNU_ID = 'DMF0008' AND BTN.SHT_NM = 'updateHistory'
   )
   AND package_name IS NULL
 ORDER BY object_name, position;

PROMPT === DIAG F : main/STATUS_UPDATE chain ===

SELECT BTN.MNU_BTN_CD, BTN.API_ID,
       API.API_URL AS PROC_NM,
       (SELECT object_name || ' ' || status FROM all_objects
         WHERE owner='SCM_MGR' AND object_name=API.API_URL AND object_type='PROCEDURE' AND ROWNUM=1) AS SP_STATUS
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
  LEFT JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID = BTN.API_ID
 WHERE BTN.MNU_ID = 'DMF0008' AND BTN.SHT_NM = 'main' AND BTN.MNU_BTN_CD = 'STATUS_UPDATE';

PROMPT === DIAG G : STATUS_UPDATE SP 의 PROC_M ===

SELECT P.PROC_NM, P.COL_NM, P.DATA_TP_CD, P.COL_TP_CD, P.SORT_ORD
  FROM SCM_MGR.SCM_ADM_PROC_M P
 WHERE P.PROC_NM IN (
   SELECT API.API_URL FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
     JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID = BTN.API_ID
    WHERE BTN.MNU_ID = 'DMF0008' AND BTN.SHT_NM = 'main' AND BTN.MNU_BTN_CD = 'STATUS_UPDATE'
 )
 ORDER BY P.PROC_NM, P.SORT_ORD;

PROMPT === DIAG H : STATUS_UPDATE SP 의 ALL_ARGUMENTS ===

SELECT argument_name, position, data_type, in_out, sequence
  FROM all_arguments
 WHERE owner = 'SCM_MGR'
   AND object_name IN (
     SELECT API.API_URL FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
       JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID = BTN.API_ID
      WHERE BTN.MNU_ID = 'DMF0008' AND BTN.SHT_NM = 'main' AND BTN.MNU_BTN_CD = 'STATUS_UPDATE'
   )
   AND package_name IS NULL
 ORDER BY object_name, position;

PROMPT === 070_DMF0008_sp_runtime_diagnose.sql 완료 ===

--==============================================================================
-- 판독 가이드:
--
-- [A]/[B] OK + SDATE NULL → SP 자체 정상 (데이터 없음)
-- [A]/[B] ERR 시 → SQLCODE/SQLERRM 으로 root cause 확정
--
-- [D] PROC_M row 0 → BE 가 SP 호출 못함 (PROC_M 메타 미등록)
-- [D] COL_NM vs [E] argument_name 불일치 → PLS-00306 → -9994
-- [E] 의 position/data_type 과 [D] 의 SORT_ORD/DATA_TP_CD 가 일치해야 함
--
-- DMF0008_GET_UPDATE_HISTORY 시그니처 (참고):
--   1 P_USER_ID  VARCHAR2 IN  → PROC_M COL_NM 'sesUserId'  expect
--   2 P_MENU_ID  VARCHAR2 IN  → PROC_M COL_NM 'mnuId'      expect
--   3 O_RC1      REF CURSOR OUT → PROC_M COL_NM 'o_rc1'    expect
--
-- PROC_M 의 COL_NM 이 위와 다르면 BE 가 IN 인자 못 채움 → SQL 오류 → -9994
--==============================================================================
