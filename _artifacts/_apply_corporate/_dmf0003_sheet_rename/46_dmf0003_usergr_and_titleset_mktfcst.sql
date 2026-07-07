--------------------------------------------------------------------------------
-- 46_dmf0003_usergr_and_titleset_mktfcst.sql
--------------------------------------------------------------------------------
-- 목적 : DMF0003(mkt-fcst) SHEET_NAME 마이그레이션 [STEP 5/5]
--        선행조사1 에서 추가로 발견된 2개 테이블의 'main' 잔존 마이그레이션.
--
--   (A) SCM_ADM_USER_GR_MNU_BTN_MPG_M : 사용자그룹 권한 미러
--         MNU_ID='DMF0003' AND SHT_NM='main' (30행) -> 'Mkt Fcst'
--         PK = (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD). 'Mkt Fcst' 0행 = 충돌 없음.
--         => 단순 UPDATE.
--
--   (B) SCM_MST_TITLESET_USER : 사용자별 저장 컬럼/measure 레이아웃
--         PROGRAM_ID='DMF0003' AND SHEET_NAME='main' (84행, 3 users: admin/minyonglee1/rosia27)
--         PK = (USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME).
--         ⚠️ 충돌 위험 : 'Mkt Fcst' 가 이미 48행(4 users) 존재.
--            admin, minyonglee1 두 사용자는 'main' 과 'Mkt Fcst' 양쪽 보유 => PK 충돌.
--         정책 : 기존 'Mkt Fcst' 레이아웃 우선 보존.
--            (B-1) 'main' 행 중 (USER_ID,TYPE,COLUMN_NAME) 이 'Mkt Fcst' 에 이미 있는 twin
--                  은 DELETE (중복 제거 — 기존 'Mkt Fcst' 유지).
--            (B-2) 충돌 없는 나머지 'main' 행만 SHEET_NAME='Mkt Fcst' 로 UPDATE.
--
--   ※ 'mktFcst'(camelCase, 1203행/54 users)는 본 마이그레이션 대상 아님 —
--      어떤 SP 도 DMF0003 의 'mktFcst' 를 읽지 않음(조사2 확인). 별도 코드경로/레거시로 보존.
--      (DMF0040/PKG_DMF0035 의 'mktFcstWaterfall' 은 전혀 다른 화면 — 무관.)
--
-- 필요성 : 44(SP) 가 TITLESET_USER + SHEET_MEASURE 를 'Mkt Fcst' 로 JOIN 하므로,
--          (B) 미수행 시 'main' 3유저의 저장 measure 선택이 grid 에서 사라짐.
--          (A) 미수행 시 사용자그룹 권한 라우팅이 'main' 시트로 남아 버튼 권한 불일치.
--
-- 안전성 : 멱등. 적용주체 = 사용자(handoff). 자동 적용 안 함.
--------------------------------------------------------------------------------
WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
SET DEFINE OFF;
SET SERVEROUTPUT ON;

--==============================================================================
-- (A) SCM_ADM_USER_GR_MNU_BTN_MPG_M
--==============================================================================
PROMPT === [A-BEFORE] USER_GR DMF0003 SHT_NM 분포 ===
SELECT SHT_NM, COUNT(*) CNT
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0003'
 GROUP BY SHT_NM
 ORDER BY SHT_NM;

-- [백업] CTAS (멱등)
DECLARE
  v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM USER_TABLES
   WHERE TABLE_NAME = 'SCM_ADM_UGBTN_BAK_DMF0003_RENAME';
  IF v_cnt > 0 THEN
    EXECUTE IMMEDIATE 'DROP TABLE SCM_ADM_UGBTN_BAK_DMF0003_RENAME PURGE';
  END IF;
END;
/
CREATE TABLE SCM_ADM_UGBTN_BAK_DMF0003_RENAME AS
SELECT * FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0003' AND SHT_NM = 'main';

PROMPT === [A-BACKUP] 행수 (=30 기대) ===
SELECT COUNT(*) BACKUP_ROWS FROM SCM_ADM_UGBTN_BAK_DMF0003_RENAME;

-- [적용] 충돌 없음 -> 단순 UPDATE (멱등)
UPDATE SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
   SET SHT_NM = 'Mkt Fcst'
 WHERE MNU_ID = 'DMF0003'
   AND SHT_NM = 'main';

PROMPT === [A-APPLY] UPDATE 행수 (=30 기대, 재실행 시 0) ===
BEGIN
  DBMS_OUTPUT.PUT_LINE('USER_GR UPDATED ROWS = ' || SQL%ROWCOUNT);
END;
/

--==============================================================================
-- (B) SCM_MST_TITLESET_USER  (collision-safe)
--==============================================================================
PROMPT === [B-BEFORE] TITLESET DMF0003 SHEET_NAME 분포 ===
SELECT SHEET_NAME, COUNT(DISTINCT USER_ID) USERS, COUNT(*) ROWS_
  FROM SCM_MGR.SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID = 'DMF0003'
 GROUP BY SHEET_NAME
 ORDER BY SHEET_NAME;

-- [백업] CTAS — 'main' 84행 백업 (멱등)
DECLARE
  v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM USER_TABLES
   WHERE TABLE_NAME = 'SCM_MST_TSU_BAK_DMF0003_RENAME';
  IF v_cnt > 0 THEN
    EXECUTE IMMEDIATE 'DROP TABLE SCM_MST_TSU_BAK_DMF0003_RENAME PURGE';
  END IF;
END;
/
CREATE TABLE SCM_MST_TSU_BAK_DMF0003_RENAME AS
SELECT * FROM SCM_MGR.SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID = 'DMF0003' AND SHEET_NAME = 'main';

PROMPT === [B-BACKUP] 행수 (=84 기대) ===
SELECT COUNT(*) BACKUP_ROWS FROM SCM_MST_TSU_BAK_DMF0003_RENAME;

-- [B-진단] twin(이미 'Mkt Fcst' 에 동일 USER/TYPE/COLUMN 존재) 행수 사전 확인
PROMPT === [B-DIAG] twin(충돌) 행수 — DELETE 대상 ===
SELECT COUNT(*) TWIN_ROWS
  FROM SCM_MGR.SCM_MST_TITLESET_USER M
 WHERE M.PROGRAM_ID = 'DMF0003' AND M.SHEET_NAME = 'main'
   AND EXISTS (
        SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER T
         WHERE T.PROGRAM_ID = 'DMF0003' AND T.SHEET_NAME = 'Mkt Fcst'
           AND T.USER_ID = M.USER_ID
           AND T.USER_INQUIRY_COLUMN_TYPE_CODE = M.USER_INQUIRY_COLUMN_TYPE_CODE
           AND T.COLUMN_NAME = M.COLUMN_NAME );

-- [B-1] twin DELETE (기존 'Mkt Fcst' 레이아웃 우선 — 멱등)
DELETE FROM SCM_MGR.SCM_MST_TITLESET_USER M
 WHERE M.PROGRAM_ID = 'DMF0003' AND M.SHEET_NAME = 'main'
   AND EXISTS (
        SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER T
         WHERE T.PROGRAM_ID = 'DMF0003' AND T.SHEET_NAME = 'Mkt Fcst'
           AND T.USER_ID = M.USER_ID
           AND T.USER_INQUIRY_COLUMN_TYPE_CODE = M.USER_INQUIRY_COLUMN_TYPE_CODE
           AND T.COLUMN_NAME = M.COLUMN_NAME );

PROMPT === [B-1 APPLY] twin DELETE 행수 ===
BEGIN
  DBMS_OUTPUT.PUT_LINE('TITLESET twin DELETED = ' || SQL%ROWCOUNT);
END;
/

-- [B-2] 충돌 없는 나머지 'main' -> 'Mkt Fcst' UPDATE (멱등)
UPDATE SCM_MGR.SCM_MST_TITLESET_USER
   SET SHEET_NAME = 'Mkt Fcst'
 WHERE PROGRAM_ID = 'DMF0003'
   AND SHEET_NAME = 'main';

PROMPT === [B-2 APPLY] UPDATE 행수 ===
BEGIN
  DBMS_OUTPUT.PUT_LINE('TITLESET UPDATED = ' || SQL%ROWCOUNT);
END;
/

COMMIT;

--==============================================================================
-- [검증] 적용 후
--==============================================================================
PROMPT === [A-AFTER] USER_GR 잔존 'main' = 0 기대 ===
SELECT COUNT(*) RESIDUAL_MAIN
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0003' AND SHT_NM = 'main';

PROMPT === [B-AFTER] TITLESET DMF0003 SHEET_NAME 분포 (main=0 기대) ===
SELECT SHEET_NAME, COUNT(DISTINCT USER_ID) USERS, COUNT(*) ROWS_
  FROM SCM_MGR.SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID = 'DMF0003'
 GROUP BY SHEET_NAME
 ORDER BY SHEET_NAME;

PROMPT === [B-AFTER] 잔존 'main' = 0 기대 ===
SELECT COUNT(*) RESIDUAL_MAIN
  FROM SCM_MGR.SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID = 'DMF0003' AND SHEET_NAME = 'main';

--==============================================================================
-- [원복] 필요 시
--==============================================================================
-- (A) DELETE FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
--      WHERE MNU_ID='DMF0003' AND SHT_NM='Mkt Fcst'
--        AND (USER_GR_ID,MNU_BTN_CD) IN
--            (SELECT USER_GR_ID,MNU_BTN_CD FROM SCM_ADM_UGBTN_BAK_DMF0003_RENAME);
--     INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
--      SELECT * FROM SCM_ADM_UGBTN_BAK_DMF0003_RENAME;
-- (B) DELETE FROM SCM_MGR.SCM_MST_TITLESET_USER
--      WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='Mkt Fcst'
--        AND (USER_ID,USER_INQUIRY_COLUMN_TYPE_CODE,COLUMN_NAME) IN
--            (SELECT USER_ID,USER_INQUIRY_COLUMN_TYPE_CODE,COLUMN_NAME
--               FROM SCM_MST_TSU_BAK_DMF0003_RENAME);
--     INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
--      SELECT * FROM SCM_MST_TSU_BAK_DMF0003_RENAME;
-- COMMIT;

PROMPT === 46 완료 ===
