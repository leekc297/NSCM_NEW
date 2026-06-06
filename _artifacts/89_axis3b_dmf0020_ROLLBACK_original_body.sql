--==============================================================================
-- 89_axis3b_dmf0020_ROLLBACK_original_body.sql
-- ⚠️ 88_axis3b_dmf0020_future_m_dual_cursor.sql 원복
--
-- 원인: 88 sql 의 SP body 임의 재작성 (anti-simplification 위반) → ORA-04024
--       핀 커서 self-deadlock + main logic 결함
--
-- 원복:
--   1. SP body 원본 (수정 전, DBMS_METADATA.GET_DDL 추출) 그대로 복원 — /tmp/dmf0020_future_m.sql
--      (single cursor signature: O_RC1 OUT SYS_REFCURSOR 하나만)
--   2. PROC_M 에서 88 가 추가한 O_RESULT_CURSOR row (SORT_ORD=19) DELETE
--      → PROC_M 18 row 로 복귀 (signature 정합 회복)
--
-- AXIS 3-B audit 결과:
--   - P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M 는 single cursor SP 로 인정
--     (BE 가 single cursor 응답 정상 처리. AXIS 3-B 위반은 별도 작업 대상)
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR CONTINUE  -- SP body 일부 실패 시에도 PROC_M cleanup 진행

PROMPT === STEP 1. SP body 원본 복원 (/tmp/dmf0020_future_m.sql) ===
@/tmp/dmf0020_future_m.sql

PROMPT === STEP 2. PROC_M O_RESULT_CURSOR row DELETE (88 가 추가한 row 원복) ===
WHENEVER SQLERROR EXIT FAILURE
DELETE FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM='P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M' AND COL_NM='O_RESULT_CURSOR' AND COL_TP_CD='OUT';

COMMIT;

PROMPT === VERIFY 1. SP signature (18 args, single OUT cursor) ===
SELECT POSITION, ARGUMENT_NAME, IN_OUT, DATA_TYPE FROM ALL_ARGUMENTS
 WHERE OWNER='SCM_MGR' AND OBJECT_NAME='P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M' AND PACKAGE_NAME IS NULL
 ORDER BY POSITION;

PROMPT === VERIFY 2. PROC_M 18 row ===
SELECT PROC_NM, COUNT(*) AS PROC_M_ROWS FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM='P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M' GROUP BY PROC_NM;

PROMPT === VERIFY 3. SP status (VALID) ===
SELECT OBJECT_NAME, STATUS FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR' AND OBJECT_NAME='P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M' AND OBJECT_TYPE='PROCEDURE';
EXIT;
