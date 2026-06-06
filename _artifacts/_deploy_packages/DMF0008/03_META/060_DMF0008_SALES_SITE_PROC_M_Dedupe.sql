--==============================================================================
-- 060_DMF0008_SALES_SITE_PROC_M_Dedupe.sql
--
-- 목적:
--   DMF0008_GET_SALES_SITE 의 PROC_M 중복 정리:
--     soldto + soldTo (sort 2) → soldTo 만 유지 (FE 가 보내는 키)
--     shipto + shipTo (sort 3) → shipTo 만 유지
--
-- 사실 (DIAG 4):
--   7 row 등록 (정상 4 row 기대 + 중복 2 + 결과 cursor 1):
--     - divisionId, soldto, soldTo, shipTo, shipto, scmSiteId, O_RESULT_CURSOR
--
-- FE filter (useErpEdiMasterStore.ts L106-111):
--   divisionId / soldTo / shipTo / scmSiteId  (camelCase)
--
-- SP signature (DIAG 2):
--   P_DIVISION_ID, P_SOLDTO, P_SHIPTO, P_SCM_SITE_ID, O_RESULT_CURSOR (5 args)
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200

PROMPT === BLOCK 1 : 현재 PROC_M 상태 (BEFORE) ===

SELECT proc_nm, col_nm, data_tp_cd, col_tp_cd, sort_ord
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE proc_nm = 'DMF0008_GET_SALES_SITE'
 ORDER BY sort_ord, col_nm;

PROMPT === BLOCK 2 : 중복 소문자 row 제거 ===

DECLARE
  v_cnt PLS_INTEGER;
BEGIN
  -- soldto (소문자) 제거 — soldTo (camelCase) 유지
  DELETE FROM SCM_MGR.SCM_ADM_PROC_M
   WHERE proc_nm = 'DMF0008_GET_SALES_SITE'
     AND col_nm = 'soldto'
     AND col_tp_cd = 'IN';
  v_cnt := SQL%ROWCOUNT;
  DBMS_OUTPUT.PUT_LINE('soldto DELETE: ' || v_cnt || ' rows');

  -- shipto (소문자) 제거 — shipTo (camelCase) 유지
  DELETE FROM SCM_MGR.SCM_ADM_PROC_M
   WHERE proc_nm = 'DMF0008_GET_SALES_SITE'
     AND col_nm = 'shipto'
     AND col_tp_cd = 'IN';
  v_cnt := SQL%ROWCOUNT;
  DBMS_OUTPUT.PUT_LINE('shipto DELETE: ' || v_cnt || ' rows');

  COMMIT;
END;
/

PROMPT === BLOCK 3 : 정리 후 PROC_M 상태 (AFTER — 5 row 기대) ===

SELECT proc_nm, col_nm, data_tp_cd, col_tp_cd, sort_ord
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE proc_nm = 'DMF0008_GET_SALES_SITE'
 ORDER BY sort_ord, col_nm;

PROMPT === BLOCK 4 : 검증 — divisionId(1) + soldTo(2) + shipTo(3) + scmSiteId(4) + O_RESULT_CURSOR(5) ===

SELECT COUNT(*) AS total_rows,
       SUM(CASE WHEN col_nm = 'divisionId' AND sort_ord = 1 THEN 1 ELSE 0 END) AS has_divisionId,
       SUM(CASE WHEN col_nm = 'soldTo'     AND sort_ord = 2 THEN 1 ELSE 0 END) AS has_soldTo,
       SUM(CASE WHEN col_nm = 'shipTo'     AND sort_ord = 3 THEN 1 ELSE 0 END) AS has_shipTo,
       SUM(CASE WHEN col_nm = 'scmSiteId'  AND sort_ord = 4 THEN 1 ELSE 0 END) AS has_scmSiteId,
       SUM(CASE WHEN UPPER(col_nm) = 'O_RESULT_CURSOR' AND sort_ord = 5 THEN 1 ELSE 0 END) AS has_result_cursor,
       SUM(CASE WHEN col_nm IN ('soldto', 'shipto') THEN 1 ELSE 0 END) AS leftover_lowercase
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE proc_nm = 'DMF0008_GET_SALES_SITE';

PROMPT === 판독 ===
PROMPT - BLOCK 3: 5 row 만 남음 (소문자 row 제거 확인)
PROMPT - BLOCK 4: total_rows=5 / has_xxx=1 모두 / leftover_lowercase=0
