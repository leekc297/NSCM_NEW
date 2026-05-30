--==============================================================================
-- 33_DMF_MENU_URL_GUEST_Perm_Fix_DBeaver.sql
--
-- 룰: Doc/_dev_rules/hooks/dbeaver-sql-mandatory-grep (^SET|^PROMPT|^DEFINE|^&\w|^/$ 0건)
-- 멱등: feedback_sql_idempotent_insert_all.md (NOT EXISTS 가드 + UPDATE 동일값 가드)
--
-- 실행 순서 (DBeaver에서 각 블록 Ctrl+Enter):
--   BLOCK 1 ~ 5 모두 멱등. 한 번에 전체 실행 OK. 마지막 COMMIT 필수.
--
-- 작성: 2026-05-29
--==============================================================================

-- BLOCK 1 : MNU_URL UPDATE (DMF0043 dmf0043 -> contribute-main)
UPDATE SCM_ADM_MNU_M
   SET MNU_URL          = 'contribute-main',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0043'
   AND MNU_URL <> 'contribute-main';

-- BLOCK 2 : MNU_URL UPDATE (DMF0043_01 dmf0043_01 -> contribute-view)
UPDATE SCM_ADM_MNU_M
   SET MNU_URL          = 'contribute-view',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0043_01'
   AND MNU_URL <> 'contribute-view';

-- BLOCK 3 : MNU_URL UPDATE (DMF0072 dmf0072 -> nn-master-mapping)
UPDATE SCM_ADM_MNU_M
   SET MNU_URL          = 'nn-master-mapping',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0072'
   AND MNU_URL <> 'nn-master-mapping';

-- BLOCK 4 : DMF0008 GUEST 메뉴 권한 INSERT (1건, 멱등)
INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M
  (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'GUEST', 'DMF0008', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M
    WHERE USER_GR_ID = 'GUEST' AND MNU_ID = 'DMF0008'
 );

-- BLOCK 5 : DMF0008 GUEST 버튼 권한 INSERT (마스터 정의 복제, 멱등)
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
