--==============================================================================
-- 33_DMF_MENU_URL_GUEST_Perm_Fix.sql (SQL*Plus 버전)
--
-- 목적:
--   (1) MNU_URL 정정 (FE route-paths.ts slug 와 정합)
--       - DMF0043     : dmf0043     -> contribute-main
--       - DMF0043_01  : dmf0043_01  -> contribute-view
--       - DMF0072     : dmf0072     -> nn-master-mapping
--   (2) DMF0008 GUEST 그룹 권한 보강
--       - SCM_ADM_USER_GR_MNU_MPG_M    : 1 row (메뉴)
--       - SCM_ADM_USER_GR_MNU_BTN_MPG_M: 6 rows (마스터 버튼 정의 복제)
--
-- 멱등성:
--   UPDATE  : 같은 값 재실행 OK
--   INSERT  : NOT EXISTS 가드
--
-- 작성: 2026-05-29
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON

PROMPT === BLOCK 1 : MNU_URL UPDATE (3건) ===

UPDATE SCM_ADM_MNU_M
   SET MNU_URL          = 'contribute-main',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0043'
   AND MNU_URL <> 'contribute-main';

UPDATE SCM_ADM_MNU_M
   SET MNU_URL          = 'contribute-view',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0043_01'
   AND MNU_URL <> 'contribute-view';

UPDATE SCM_ADM_MNU_M
   SET MNU_URL          = 'nn-master-mapping',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0072'
   AND MNU_URL <> 'nn-master-mapping';

PROMPT === BLOCK 2 : DMF0008 GUEST 메뉴 권한 INSERT (1건, 멱등) ===

INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M
  (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'GUEST', 'DMF0008', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M
    WHERE USER_GR_ID = 'GUEST' AND MNU_ID = 'DMF0008'
 );

PROMPT === BLOCK 3 : DMF0008 GUEST 버튼 권한 INSERT (마스터 정의 복제, 멱등) ===

INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'GUEST', BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_ADM_MNU_BTN_MPG_M BTN
 WHERE BTN.MNU_ID = 'DMF0008'
   AND BTN.USE_YN = 'Y'
   AND NOT EXISTS (
     SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M X
      WHERE X.USER_GR_ID = 'GUEST'
        AND X.MNU_ID     = BTN.MNU_ID
        AND X.SHT_NM     = BTN.SHT_NM
        AND X.MNU_BTN_CD = BTN.MNU_BTN_CD
   );

COMMIT;

PROMPT === COMPLETE ===
EXIT
