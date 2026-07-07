--------------------------------------------------------------------------------
-- 43_dmf0003_sheet_measure_drop_main.sql
--------------------------------------------------------------------------------
-- 목적 : DMF0003(mkt-fcst) SHEET_NAME 마이그레이션 [STEP 2/5]
--        SCM_MST_SHEET_MEASURE 'main'(12행) DELETE — 'Mkt Fcst'(47행) 채택/보존
--
-- 사용자 확정 결정 :
--   measure 충돌 시 기존 'Mkt Fcst'(47, VALID_YN Y23/N24) 채택, 'main'(12, 전부 Y) 삭제.
--   => 그리드 measure 가 'Mkt Fcst' 활성 23종으로 전환 = 의도된 동작.
--
-- 안전성 : PK_SCM_MST_SHEET_MEASURE = (PROGRAM_ID, SHEET_NAME, COLUMN_NAME).
--          DELETE 만 수행 — 'Mkt Fcst' 행은 SHEET_NAME 가 달라 영향 없음.
--          멱등(재실행 시 0행 DELETE).
--
-- 적용주체 : 사용자(handoff). 자동 적용 안 함.
-- 의존     : 단독 실행 가능하나 42 와 함께 적용 권장 (컬럼+measure 정합).
--------------------------------------------------------------------------------
WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
SET DEFINE OFF;
SET SERVEROUTPUT ON;

--==============================================================================
-- [근거] 적용 전 현황
--==============================================================================
PROMPT === [BEFORE] SHEET_MEASURE DMF0003 SHEET_NAME x VALID_YN 분포 ===
SELECT SHEET_NAME, VALID_YN, COUNT(*) CNT
  FROM SCM_MGR.SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID = 'DMF0003'
 GROUP BY SHEET_NAME, VALID_YN
 ORDER BY SHEET_NAME, VALID_YN;

--==============================================================================
-- [백업] CTAS — 삭제 대상 'main' 12행 백업 (멱등)
--==============================================================================
DECLARE
  v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt
    FROM USER_TABLES
   WHERE TABLE_NAME = 'SCM_MST_SHM_BAK_DMF0003_DROPMAIN';
  IF v_cnt > 0 THEN
    EXECUTE IMMEDIATE 'DROP TABLE SCM_MST_SHM_BAK_DMF0003_DROPMAIN PURGE';
  END IF;
END;
/
CREATE TABLE SCM_MST_SHM_BAK_DMF0003_DROPMAIN AS
SELECT * FROM SCM_MGR.SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID = 'DMF0003' AND SHEET_NAME = 'main';

PROMPT === [BACKUP] SCM_MST_SHM_BAK_DMF0003_DROPMAIN 행수 (=12 기대) ===
SELECT COUNT(*) BACKUP_ROWS FROM SCM_MST_SHM_BAK_DMF0003_DROPMAIN;

--==============================================================================
-- [보존 확인] 'Mkt Fcst' 47행 사전 확인 (삭제로 영향받지 않음)
--==============================================================================
PROMPT === [PRESERVE] 'Mkt Fcst' 행수 (=47 기대, Y=23/N=24) ===
SELECT VALID_YN, COUNT(*) CNT
  FROM SCM_MGR.SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID = 'DMF0003' AND SHEET_NAME = 'Mkt Fcst'
 GROUP BY VALID_YN
 ORDER BY VALID_YN;

--==============================================================================
-- [적용] 'main' DELETE (멱등)
--==============================================================================
DELETE FROM SCM_MGR.SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID = 'DMF0003'
   AND SHEET_NAME = 'main';

PROMPT === [APPLY] DELETE 행수 (=12 기대, 재실행 시 0) ===
BEGIN
  DBMS_OUTPUT.PUT_LINE('DELETED ROWS = ' || SQL%ROWCOUNT);
END;
/

COMMIT;

--==============================================================================
-- [검증] 적용 후 — 'main' 0, 'Mkt Fcst' 47(Y23/N24) 보존
--==============================================================================
PROMPT === [AFTER] SHEET_MEASURE DMF0003 SHEET_NAME x VALID_YN 분포 ===
SELECT SHEET_NAME, VALID_YN, COUNT(*) CNT
  FROM SCM_MGR.SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID = 'DMF0003'
 GROUP BY SHEET_NAME, VALID_YN
 ORDER BY SHEET_NAME, VALID_YN;

PROMPT === [검증] 잔존 'main' = 0 기대 ===
SELECT COUNT(*) RESIDUAL_MAIN
  FROM SCM_MGR.SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID = 'DMF0003' AND SHEET_NAME = 'main';

PROMPT === [검증] 그리드 표시 measure = 'Mkt Fcst' VALID_YN='Y' 23종 ===
SELECT COLUMN_NAME, SORT_ORDER_NO
  FROM SCM_MGR.SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID = 'DMF0003' AND SHEET_NAME = 'Mkt Fcst' AND VALID_YN = 'Y'
 ORDER BY SORT_ORDER_NO;

--==============================================================================
-- [원복] 필요 시 백업 재삽입
--==============================================================================
-- INSERT INTO SCM_MGR.SCM_MST_SHEET_MEASURE
-- SELECT * FROM SCM_MST_SHM_BAK_DMF0003_DROPMAIN;
-- COMMIT;

PROMPT === 43 완료 ===
