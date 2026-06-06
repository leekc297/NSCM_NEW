--==============================================================================
-- 57_SYS0011_SCM0008_sheet_columns_dedupe.sql  (SQL*Plus 본체)
--
-- 목적: SCM_MST_SHEET_COLUMNS 의 SYS0011 (SCM0008 Auth Request) duplicate row 정리
--
-- 사고 (2026-06-06 사용자 보고 "전체 grid 에 동일 column 이 2번씩 나옴"):
--   4 sheet 모두 정확히 2배 중복:
--     - authority         : TOT 6  / DISTINCT 3
--     - division          : TOT 4  / DISTINCT 2
--     - myAuthorityList   : TOT 18 / DISTINCT 9
--     - userInfo          : TOT 14 / DISTINCT 7
--   합계 TOT 42 / DISTINCT 21 — 메타 등록 INSERT 가 2회 실행된 안티 패턴
--   (메모리 룰 `feedback_sql_idempotent_insert_all` 미준수)
--
-- 영향 범위:
--   - SYS0011 의 4 sheet 만 cleanup (다른 PROGRAM_ID/SHEET_NAME 영향 0)
--   - duplicate 21 row 만 삭제 (각 (SHEET_NAME, COLUMN_NAME) 의 ROWID 작은 것 유지)
--
-- 멱등성: 실행 후 distinct = total. 재실행 안전.
-- 참조 패턴: _artifacts/56_COM0008_sheet_columns_dedupe.sql
-- 작성: 2026-06-06
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : 사전 상태 (sheet 별 TOT / DISTINCT) ===
SELECT 'BEFORE ' || SHEET_NAME AS K,
       COUNT(*) AS TOT,
       COUNT(DISTINCT COLUMN_NAME) AS DISTINCT_CNT
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'SYS0011'
 GROUP BY SHEET_NAME
 ORDER BY SHEET_NAME;

PROMPT === BLOCK 2 : duplicate row 제거 ((SHEET_NAME, COLUMN_NAME) 별 MIN(ROWID) 유지) ===
DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS X
 WHERE X.PROGRAM_ID = 'SYS0011'
   AND X.ROWID NOT IN (
     SELECT MIN(Y.ROWID)
       FROM SCM_MGR.SCM_MST_SHEET_COLUMNS Y
      WHERE Y.PROGRAM_ID = 'SYS0011'
      GROUP BY Y.SHEET_NAME, Y.COLUMN_NAME
   );

PROMPT === BLOCK 3 : 사후 상태 (TOT = DISTINCT 여야 함) ===
SELECT 'AFTER ' || SHEET_NAME AS K,
       COUNT(*) AS TOT,
       COUNT(DISTINCT COLUMN_NAME) AS DISTINCT_CNT
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'SYS0011'
 GROUP BY SHEET_NAME
 ORDER BY SHEET_NAME;

PROMPT === BLOCK 4 : duplicate 잔존 검증 (0건 이어야 함) ===
SELECT SHEET_NAME, COLUMN_NAME, COUNT(*) AS CNT
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'SYS0011'
 GROUP BY SHEET_NAME, COLUMN_NAME
HAVING COUNT(*) > 1
 ORDER BY SHEET_NAME, COLUMN_NAME;

COMMIT;
PROMPT === COMPLETE ===
EXIT;
