--==============================================================================
-- 56_COM0008_sheet_columns_dedupe.sql  (SQL*Plus 본체)
--
-- 목적: SCM_MST_SHEET_COLUMNS 의 COM0008/itemByDivisionPopup duplicate row 정리
--
-- 사고 원인 (2026-06-02 사용자 보고 "Model/Nickname Popup 데이터 미조회"):
--   - 메타 17개 distinct column 이 각각 2번씩 등록 (총 34 rows)
--   - DataGrid (Wijmo FlexGrid) 가 같은 binding column 2개를 받아 렌더링 충돌
--   - SP 자체는 정상 동작 (PKG_COM0000.P_COM0008_GET_ITEM_BY_DIVISION_POPUP — div=40 13K rows / div=81 42K / div=82 31K 확인)
--
-- 누구든 메모리 룰 `feedback_sql_idempotent_insert_all` 미준수 — INSERT ALL 또는 INSERT 2번 실행
--
-- 영향 범위:
--   - COM0008/itemByDivisionPopup 만 cleanup (다른 PROGRAM_ID/SHEET_NAME 영향 0)
--   - duplicate 17 row 만 삭제 (각 COLUMN_NAME 의 ROWID 작은 것 1개 유지)
--
-- 멱등성: 실행 후 distinct=17 / total=17. 재실행 시 17개 그대로.
-- 작성: 2026-06-02
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : 사전 상태 ===
SELECT 'BEFORE: distinct columns' AS K, COUNT(DISTINCT COLUMN_NAME) AS V FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='COM0008' AND SHEET_NAME='itemByDivisionPopup'
UNION ALL
SELECT 'BEFORE: total rows', COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='COM0008' AND SHEET_NAME='itemByDivisionPopup';

PROMPT === BLOCK 2 : duplicate row 제거 (각 COLUMN_NAME 의 더 큰 ROWID 삭제) ===
DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS X
 WHERE X.PROGRAM_ID = 'COM0008'
   AND X.SHEET_NAME = 'itemByDivisionPopup'
   AND X.ROWID NOT IN (
     SELECT MIN(Y.ROWID) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS Y
      WHERE Y.PROGRAM_ID = 'COM0008' AND Y.SHEET_NAME = 'itemByDivisionPopup'
      GROUP BY Y.COLUMN_NAME
   );

PROMPT === BLOCK 3 : 사후 상태 ===
SELECT 'AFTER: distinct columns' AS K, COUNT(DISTINCT COLUMN_NAME) AS V FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='COM0008' AND SHEET_NAME='itemByDivisionPopup'
UNION ALL
SELECT 'AFTER: total rows', COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='COM0008' AND SHEET_NAME='itemByDivisionPopup'
UNION ALL
SELECT 'AFTER: duplicates remaining (should be 0)', COUNT(*) FROM (
  SELECT COLUMN_NAME FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
   WHERE PROGRAM_ID='COM0008' AND SHEET_NAME='itemByDivisionPopup'
   GROUP BY COLUMN_NAME HAVING COUNT(*) > 1
);

COMMIT;
PROMPT === COMPLETE ===
EXIT;
