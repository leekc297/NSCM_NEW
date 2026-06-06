--==============================================================================
-- 040_DMF0008_All_Groups_Btn_Permission.sql
--
-- 목적: minyonglee1 (또는 GUEST 외 다른 사용자) 의 권한 그룹 모두에 DMF0008 권한 자동 등록
--       "No Permission" 사고 방지 — GUEST 그룹만 등록한 070 fix 보강
-- 실행: SCM_MGR 세션
-- 멱등: NOT EXISTS
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === BLOCK 1 : minyonglee1 의 모든 그룹에 DMF0008 메뉴 권한 ===

INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
  (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT ugr.USER_GR_ID, 'DMF0008', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M ugr
 WHERE ugr.USER_ID = 'minyonglee1'
   AND NOT EXISTS (
     SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M X
      WHERE X.USER_GR_ID = ugr.USER_GR_ID AND X.MNU_ID = 'DMF0008'
   );

PROMPT === BLOCK 2 : minyonglee1 의 모든 그룹에 DMF0008 모든 버튼 권한 ===

INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD,
   USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT ugr.USER_GR_ID, BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD, 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M ugr
  CROSS JOIN SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
 WHERE ugr.USER_ID = 'minyonglee1'
   AND BTN.MNU_ID = 'DMF0008'
   AND NOT EXISTS (
     SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X
      WHERE X.USER_GR_ID = ugr.USER_GR_ID
        AND X.MNU_ID = BTN.MNU_ID AND X.SHT_NM = BTN.SHT_NM AND X.MNU_BTN_CD = BTN.MNU_BTN_CD
   );

PROMPT === BLOCK 3 : 검증 — minyonglee1 권한 그룹 + DMF0008 권한 인벤토리 ===

SELECT ugr.USER_GR_ID,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
         WHERE USER_GR_ID = ugr.USER_GR_ID AND MNU_ID = 'DMF0008') AS menu_perm,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
         WHERE USER_GR_ID = ugr.USER_GR_ID AND MNU_ID = 'DMF0008') AS btn_perm
  FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M ugr
 WHERE ugr.USER_ID = 'minyonglee1';

COMMIT;
