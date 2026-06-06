--==============================================================================
-- 090_DMF0008_SCM0001_PROC_M_Sig_Fix.sql
--
-- 사고: 080 FIX C 의 SCM0001_GET_DIVISION PROC_M (sesUserId/mnuId/o_rc1) 가
--       실제 시그니처 (O_RC1 OUT + O_RESULT_CURSOR OUT — IN 0개) 와 mismatch
--       → BE 가 sesUserId/mnuId 자동 채움 시도 → PLS-00306
--
-- 사고 chain (참고):
--   - SCM_MGR.SCM0001_GET_DIVISION : 2 OUT only (O_RC1, O_RESULT_CURSOR)
--   - SCMC.SCM0001_GET_DIVISION    : 1 OUT only (O_RC1)
--   - 본 fix 는 SCM_MGR 버전 (2 OUT) 시그니처 정합
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === FIX 1 : SCM0001_GET_DIVISION PROC_M 재정합 (DELETE + INSERT 2 row) ===

DELETE FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM = 'SCM0001_GET_DIVISION';

INSERT INTO SCM_MGR.SCM_ADM_PROC_M
  (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'SCM0001_GET_DIVISION', NEW.COL_NM, NEW.DATA_TP_CD, NEW.COL_TP_CD, NEW.SORT_ORD,
       'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    -- IN 인자 없음 (SCM_MGR.SCM0001_GET_DIVISION 시그니처 그대로)
    SELECT 'o_rc1'           AS COL_NM, 'CURSOR'      AS DATA_TP_CD, 'OUT' AS COL_TP_CD, 1 AS SORT_ORD FROM DUAL UNION ALL
    SELECT 'O_RESULT_CURSOR',           'PROC_RESULT',                'OUT',                2          FROM DUAL
  ) NEW;

PROMPT === FIX 2 : PKG_DMF0008.* legacy PROC_M 정리 (080 FIX A.2 의 PK 위반 잔여) ===

DELETE FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM LIKE 'PKG_DMF0008.%';

PROMPT === FIX 3 : 검증 — SCM0001_GET_DIVISION PROC_M 정합 + DMF0008 전체 chain ===

SELECT proc_nm, col_nm, data_tp_cd, col_tp_cd, sort_ord
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE proc_nm = 'SCM0001_GET_DIVISION'
 ORDER BY sort_ord;

PROMPT === FIX 4 : DMF0008/division/SEARCH chain 최종 검증 ===

SELECT BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD,
       BTN.API_ID, API.API_URL,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M P WHERE P.PROC_NM = API.API_URL) AS PROC_CNT,
       CASE WHEN (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M P WHERE P.PROC_NM = API.API_URL) = 0
              THEN 'FAIL: PROC_M missing'
            ELSE 'PASS' END AS RESULT
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
  LEFT JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID = BTN.API_ID
 WHERE BTN.MNU_ID = 'DMF0008' AND BTN.SHT_NM = 'division';

PROMPT === FIX 5 : SCM0001_GET_DIVISION 정확 호출 시뮬레이션 ===

DECLARE
  v_rc SYS_REFCURSOR;
  v_result_rc SYS_REFCURSOR;
BEGIN
  SCM_MGR.SCM0001_GET_DIVISION(
    O_RC1           => v_rc,
    O_RESULT_CURSOR => v_result_rc
  );
  DBMS_OUTPUT.PUT_LINE('SCM0001_GET_DIVISION 정확 호출 OK (2 OUT, 0 IN)');
  CLOSE v_rc;
  CLOSE v_result_rc;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 200));
END;
/

COMMIT;
