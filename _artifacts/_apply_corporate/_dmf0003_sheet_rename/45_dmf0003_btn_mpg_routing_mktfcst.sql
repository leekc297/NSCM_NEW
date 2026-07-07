--------------------------------------------------------------------------------
-- 45_dmf0003_btn_mpg_routing_mktfcst.sql
--------------------------------------------------------------------------------
-- 목적 : DMF0003(mkt-fcst) SHEET_NAME 마이그레이션 [STEP 4/5]
--        SCM_ADM_MNU_BTN_MPG_M 버튼 라우팅 SHT_NM 'main'(10행) -> 'Mkt Fcst'
--
-- 대상 : SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0003' AND SHT_NM='main' (10행)
--        버튼 : COLUMN_SETUP, DELETE, EXCEL, FILTER, INSERT, MASTER_CHG,
--               MEASURE_SELECT, SAVE, SEARCH, SORT
--        titleSet 행(SEARCH 1행)은 불변.
--
-- API_ID 정책(사용자 확정) : API_ID(예 'DMF0003_main_SEARCH')는 opaque 식별자 —
--        SHT_NM 만 변경, API_ID 는 유지(불필요 cascade 회피). API_M 무변경.
--
-- 안전성 : PK_SCM_ADM_MNU_BTN_MPG_M_NEW = (MNU_ID, SHT_NM, MNU_BTN_CD).
--          SHT_NM 가 PK 2번째 — UPDATE 가능. 현재 'Mkt Fcst' 행 0 = 충돌 없음.
--          멱등(재실행 시 0행).
--
-- 적용주체 : 사용자(handoff). 자동 적용 안 함.
--------------------------------------------------------------------------------
WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
SET DEFINE OFF;
SET SERVEROUTPUT ON;

--==============================================================================
-- [근거] 적용 전 현황
--==============================================================================
PROMPT === [BEFORE] BTN_MPG DMF0003 SHT_NM 분포 ===
SELECT SHT_NM, COUNT(*) CNT
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0003'
 GROUP BY SHT_NM
 ORDER BY SHT_NM;

PROMPT === [BEFORE] 'main' 버튼 상세 (10행 기대) ===
SELECT SHT_NM, MNU_BTN_CD, API_ID
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0003' AND SHT_NM = 'main'
 ORDER BY MNU_BTN_CD;

--==============================================================================
-- [백업] CTAS — 'main' 10행 백업 (멱등)
--==============================================================================
DECLARE
  v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt
    FROM USER_TABLES
   WHERE TABLE_NAME = 'SCM_ADM_BTNMPG_BAK_DMF0003_RENAME';
  IF v_cnt > 0 THEN
    EXECUTE IMMEDIATE 'DROP TABLE SCM_ADM_BTNMPG_BAK_DMF0003_RENAME PURGE';
  END IF;
END;
/
CREATE TABLE SCM_ADM_BTNMPG_BAK_DMF0003_RENAME AS
SELECT * FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0003' AND SHT_NM = 'main';

PROMPT === [BACKUP] SCM_ADM_BTNMPG_BAK_DMF0003_RENAME 행수 (=10 기대) ===
SELECT COUNT(*) BACKUP_ROWS FROM SCM_ADM_BTNMPG_BAK_DMF0003_RENAME;

--==============================================================================
-- [적용] SHT_NM rename 'main' -> 'Mkt Fcst' (titleSet 불변, 멱등)
--==============================================================================
UPDATE SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
   SET SHT_NM = 'Mkt Fcst'
 WHERE MNU_ID = 'DMF0003'
   AND SHT_NM = 'main';

PROMPT === [APPLY] UPDATE 행수 (=10 기대, 재실행 시 0) ===
BEGIN
  DBMS_OUTPUT.PUT_LINE('UPDATED ROWS = ' || SQL%ROWCOUNT);
END;
/

COMMIT;

--==============================================================================
-- [검증] 적용 후 — 'main' 0, 'Mkt Fcst' 10, titleSet 1 유지
--==============================================================================
PROMPT === [AFTER] BTN_MPG DMF0003 SHT_NM 분포 ===
SELECT SHT_NM, COUNT(*) CNT
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0003'
 GROUP BY SHT_NM
 ORDER BY SHT_NM;

PROMPT === [검증] 잔존 'main' = 0 기대 ===
SELECT COUNT(*) RESIDUAL_MAIN
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0003' AND SHT_NM = 'main';

--==============================================================================
-- [원복] 필요 시
--==============================================================================
-- DELETE FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
--  WHERE MNU_ID='DMF0003' AND SHT_NM='Mkt Fcst'
--    AND MNU_BTN_CD IN (SELECT MNU_BTN_CD FROM SCM_ADM_BTNMPG_BAK_DMF0003_RENAME);
-- INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M SELECT * FROM SCM_ADM_BTNMPG_BAK_DMF0003_RENAME;
-- COMMIT;

PROMPT === 45 완료 ===
