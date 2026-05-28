-- =============================================================================
-- DMF0007 — Customer PSI TabPage 활성화 시드
-- =============================================================================
-- 대상: Docker Oracle 로컬 (FREEPDB1 / SCM_MGR)
-- 작성: 2026-05-28 (DMF0007 PSI 탭 추가 작업)
-- 의도: customerPSI sheet 의 비활성 상태(VALID_YN='N')를 활성화하고,
--       SCM_ADM_MNU_BTN_MPG_M 의 customerPSI 매핑 (SEARCH/SAVE) 신규 등록,
--       권한 테이블의 'customerPsi' 대소문자 오타를 'customerPSI' 로 통일하고
--       SAVE 권한 3개 그룹 (ADMIN/DM ADMIN/DM Viewer) 신규 등록.
--
-- 사전 확인:
--   - SCM_ADM_API_M 에 P_DMF0007_PSI_GET (조회), P_DMF0007_FCST_SAVE (저장 공유) 존재 ✓
--   - SCM_ADM_PROC_M 에 PKG_DMF0007.P_DMF0007_GET_CUST_PSI_DATA 파라미터 메타 존재 ✓
--   - PKG_DMF0007.P_DMF0007_GET_CUST_PSI_DATA SP 존재 ✓
--   - 메뉴 자체 권한 (SCM_ADM_USER_GR_MNU_MPG_M) 의 DMF0007 행 3개 그룹 보유 ✓
--
-- 실행 방법 (SQL*Plus):
--   sqlplus SCM_MGR/****@//localhost:1521/FREEPDB1 @dmf0007-customerpsi-seed.sql
-- DBeaver 실행은 dmf0007-customerpsi-seed_DBeaver.sql 사용
-- 검증은 dmf0007-customerpsi-seed_Verify.sql
-- 진단은 dmf0007-customerpsi-seed_Diagnose.sql
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

PROMPT
PROMPT === BLOCK 1: SCM_MST_SHEET_COLUMNS — customerPSI 활성화 (VALID_YN N→Y) ===
PROMPT

UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET VALID_YN = 'Y'
     , LAST_UPDATED_BY = 'minyonglee1'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0007'
   AND SHEET_NAME = 'customerPSI'
   AND VALID_YN = 'N';


PROMPT
PROMPT === BLOCK 2: SCM_ADM_MNU_BTN_MPG_M — customerPSI 매핑 INSERT (SEARCH + SAVE) ===
PROMPT

INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
  (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0007', 'customerPSI', 'SEARCH', 'P_DMF0007_PSI_GET', 'Y', 'minyonglee1', SYSDATE, 'minyonglee1', SYSDATE FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
    WHERE MNU_ID='DMF0007' AND SHT_NM='customerPSI' AND MNU_BTN_CD='SEARCH'
 );

INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
  (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0007', 'customerPSI', 'SAVE', 'P_DMF0007_FCST_SAVE', 'Y', 'minyonglee1', SYSDATE, 'minyonglee1', SYSDATE FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
    WHERE MNU_ID='DMF0007' AND SHT_NM='customerPSI' AND MNU_BTN_CD='SAVE'
 );


PROMPT
PROMPT === BLOCK 3: SCM_ADM_USER_GR_MNU_BTN_MPG_M — 'customerPsi' 오타 정정 + SAVE 권한 등록 ===
PROMPT

-- 3-1) 기존 'customerPsi' (소문자 i) SEARCH 행 3건을 'customerPSI' (대문자 SI) 로 정정.
--      단, 이미 'customerPSI' 가 존재하면 정정 대신 잔존 오타 행을 삭제.
UPDATE SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
   SET SHT_NM = 'customerPSI'
     , LAST_UPDATED_BY = 'minyonglee1'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0007'
   AND SHT_NM = 'customerPsi'
   AND MNU_BTN_CD IN ('SEARCH','SAVE')
   AND NOT EXISTS (
     SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M b
      WHERE b.USER_GR_ID = SCM_ADM_USER_GR_MNU_BTN_MPG_M.USER_GR_ID
        AND b.MNU_ID = 'DMF0007'
        AND b.SHT_NM = 'customerPSI'
        AND b.MNU_BTN_CD = SCM_ADM_USER_GR_MNU_BTN_MPG_M.MNU_BTN_CD
   );

DELETE FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0007'
   AND SHT_NM = 'customerPsi';

-- 3-2) customerFcst 의 권한 행을 기준으로 customerPSI 권한을 INSERT (없는 행만)
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT FCST.USER_GR_ID, FCST.MNU_ID, 'customerPSI', FCST.MNU_BTN_CD, FCST.USE_YN,
       'minyonglee1', SYSDATE, 'minyonglee1', SYSDATE
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M FCST
 WHERE FCST.MNU_ID = 'DMF0007'
   AND FCST.SHT_NM = 'customerFcst'
   AND NOT EXISTS (
     SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M B
      WHERE B.USER_GR_ID = FCST.USER_GR_ID
        AND B.MNU_ID = 'DMF0007'
        AND B.SHT_NM = 'customerPSI'
        AND B.MNU_BTN_CD = FCST.MNU_BTN_CD
   );


PROMPT
PROMPT === COMMIT ===
COMMIT;

PROMPT
PROMPT === Post-commit verification ===
PROMPT

PROMPT [1] SCM_MST_SHEET_COLUMNS customerPSI VALID_YN=Y 건수 (기대 16):
SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0007' AND SHEET_NAME='customerPSI' AND VALID_YN='Y';

PROMPT [2] SCM_ADM_MNU_BTN_MPG_M customerPSI 매핑 (기대 2):
SELECT MNU_BTN_CD, API_ID, USE_YN FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID='DMF0007' AND SHT_NM='customerPSI' ORDER BY MNU_BTN_CD;

PROMPT [3] SCM_ADM_USER_GR_MNU_BTN_MPG_M customerPSI 권한 (기대 customerFcst 와 동일 그룹/버튼 조합):
SELECT USER_GR_ID, MNU_BTN_CD, USE_YN FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID='DMF0007' AND SHT_NM='customerPSI' ORDER BY USER_GR_ID, MNU_BTN_CD;

PROMPT
PROMPT === DONE ===
