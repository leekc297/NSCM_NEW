--------------------------------------------------------------------------------
-- 42_dmf0003_sheet_columns_rename_mktfcst.sql
--------------------------------------------------------------------------------
-- 목적 : DMF0003(mkt-fcst) 그리드 SHEET_NAME 전 계층 마이그레이션 'main' -> 'Mkt Fcst'
--        [STEP 1/5] SCM_MST_SHEET_COLUMNS 컬럼 메타 rename
--
-- 대상 : SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='main' (67행)
-- 결과 : 'main' 67 -> 'Mkt Fcst' 67  (현재 'Mkt Fcst' 0행이라 충돌 없음 = clean rename)
--
-- 안전성 : SCM_MST_SHEET_COLUMNS 에 UNIQUE 제약 없음(PK_SCM_MST_SHEET_COLUMNS = NONUNIQUE).
--          따라서 UPDATE 시 PK/UNIQUE 충돌 위험 0. 멱등(재실행 시 0행 UPDATE).
--
-- 적용주체 : 사용자(handoff). 본 스크립트는 사내 DB 에 자동 적용되지 않음.
-- 적용순서 : 42 -> 43 -> 44 -> 45 -> 46  (의존순서 README 참조)
--------------------------------------------------------------------------------
WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
SET DEFINE OFF;
SET SERVEROUTPUT ON;

--==============================================================================
-- [근거] 적용 전 현황
--==============================================================================
PROMPT === [BEFORE] SHEET_COLUMNS DMF0003 SHEET_NAME 분포 ===
SELECT SHEET_NAME, COUNT(*) CNT
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0003'
 GROUP BY SHEET_NAME
 ORDER BY SHEET_NAME;

--==============================================================================
-- [백업] CTAS — 'main' 67행만 별도 백업 (멱등: 존재 시 DROP 후 재생성)
--==============================================================================
DECLARE
  v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt
    FROM USER_TABLES
   WHERE TABLE_NAME = 'SCM_MST_SHC_BAK_DMF0003_RENAME';
  IF v_cnt > 0 THEN
    EXECUTE IMMEDIATE 'DROP TABLE SCM_MST_SHC_BAK_DMF0003_RENAME PURGE';
  END IF;
END;
/
CREATE TABLE SCM_MST_SHC_BAK_DMF0003_RENAME AS
SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0003' AND SHEET_NAME = 'main';

PROMPT === [BACKUP] SCM_MST_SHC_BAK_DMF0003_RENAME 행수 (=67 기대) ===
SELECT COUNT(*) BACKUP_ROWS FROM SCM_MST_SHC_BAK_DMF0003_RENAME;

--==============================================================================
-- [적용] rename 'main' -> 'Mkt Fcst' (멱등: 'main' 없으면 0행)
--==============================================================================
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET SHEET_NAME = 'Mkt Fcst'
 WHERE PROGRAM_ID = 'DMF0003'
   AND SHEET_NAME = 'main';

PROMPT === [APPLY] UPDATE 행수 (=67 기대, 재실행 시 0) ===
-- SQL%ROWCOUNT 확인용
BEGIN
  DBMS_OUTPUT.PUT_LINE('UPDATED ROWS = ' || SQL%ROWCOUNT);
END;
/

COMMIT;

--==============================================================================
-- [검증] 적용 후 — 'main' 0, 'Mkt Fcst' 67 기대
--==============================================================================
PROMPT === [AFTER] SHEET_COLUMNS DMF0003 SHEET_NAME 분포 ===
SELECT SHEET_NAME, COUNT(*) CNT
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0003'
 GROUP BY SHEET_NAME
 ORDER BY SHEET_NAME;

PROMPT === [검증] 잔존 'main' = 0 기대 ===
SELECT COUNT(*) RESIDUAL_MAIN
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0003' AND SHEET_NAME = 'main';

--==============================================================================
-- [원복] 필요 시 아래 블록 수동 실행
--==============================================================================
-- UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
--    SET SHEET_NAME = 'main'
--  WHERE PROGRAM_ID = 'DMF0003'
--    AND SHEET_NAME = 'Mkt Fcst'
--    AND (COLUMN_NAME) IN (SELECT COLUMN_NAME FROM SCM_MST_SHC_BAK_DMF0003_RENAME);
-- COMMIT;
-- 또는 완전 복원: DELETE 신규 'Mkt Fcst' 후 백업 재삽입
--   DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='Mkt Fcst';
--   INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS SELECT * FROM SCM_MST_SHC_BAK_DMF0003_RENAME;
--   COMMIT;

PROMPT === 42 완료 ===
