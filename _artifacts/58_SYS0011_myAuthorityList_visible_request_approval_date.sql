--==============================================================================
-- 58_SYS0011_myAuthorityList_visible_request_approval_date.sql
--
-- 목적: SCM0008 (Auth Request) 화면의 My Authority List grid 에서 누락된
--       Request Date (CREATION_DATE) / Approval Date (LAST_UPDATE_DATE) 표시
--
-- 현황 (2026-06-06):
--   USER_GR_NM        Authority        Y
--   DIVISION_NAME     Div. Name        Y
--   CREATION_DATE     Request Date     N  ← 표시 필요
--   APPROVAL_RESULT   Approval Result  Y
--   LAST_UPDATED_BY   Approval User    Y
--   REJECT_REASON     Reject Reason    Y
--   LAST_UPDATE_DATE  Approval Date    N  ← 표시 필요
--
-- 멱등성: VISIBLE_FLAG='Y' UPDATE — 재실행 안전.
-- 작성: 2026-06-06
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : 사전 상태 ===
SELECT COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, VISIBLE_FLAG
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'SYS0011'
   AND SHEET_NAME = 'myAuthorityList'
   AND COLUMN_NAME IN ('CREATION_DATE', 'LAST_UPDATE_DATE')
 ORDER BY SORT_ORDER_NO;

PROMPT === BLOCK 2 : VISIBLE_FLAG = Y UPDATE ===
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET VISIBLE_FLAG = 'Y'
 WHERE PROGRAM_ID = 'SYS0011'
   AND SHEET_NAME = 'myAuthorityList'
   AND COLUMN_NAME IN ('CREATION_DATE', 'LAST_UPDATE_DATE')
   AND NVL(VISIBLE_FLAG, 'N') <> 'Y';

PROMPT === BLOCK 3 : 사후 상태 ===
SELECT COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, VISIBLE_FLAG
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'SYS0011'
   AND SHEET_NAME = 'myAuthorityList'
 ORDER BY SORT_ORDER_NO;

COMMIT;
PROMPT === COMPLETE ===
EXIT;
