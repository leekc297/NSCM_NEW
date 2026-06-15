-- ============================================================================
-- 55. 메뉴/MSG i18n 통합 정합화 (DBeaver / SQL Developer 용)
-- ----------------------------------------------------------------------------
-- 사용법: DBeaver 에서 PL/SQL BLOCK 전체 선택 → Ctrl+Enter (또는 Alt+X)
-- 적용 4 axis:
--   (1) SCM_ADM_LOOKUP_MASTER_DETAIL.DESCRIPTION : "Korean" → Label/Message/Menu
--   (2) SCM_ADM_MSG_M.MSG_TP_CD                   : MENU→MNU (3) + API→MSG (31)
--   (3) SCM_ADM_MNU_M.MNU_DESC                    : DMF0043/DMF0043_01 영문화
-- ============================================================================

BEGIN
  -- (1) SYS0001 Type combo 표시 정정 ("Korean" 잔존 fix)
  UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
     SET DESCRIPTION='Label',   LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE LOOKUP_TYPE='MSG_TP_CD' AND SEGMENT1='LBL';

  UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
     SET DESCRIPTION='Message', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE LOOKUP_TYPE='MSG_TP_CD' AND SEGMENT1='MSG';

  UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
     SET DESCRIPTION='Menu',    LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE LOOKUP_TYPE='MSG_TP_CD' AND SEGMENT1='MNU';

  -- (2) MSG_TP_CD typo 통일
  UPDATE SCM_ADM_MSG_M
     SET MSG_TP_CD='MNU', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE MSG_TP_CD='MENU';

  UPDATE SCM_ADM_MSG_M
     SET MSG_TP_CD='MSG', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE MSG_TP_CD='API';

  -- (3) DMF0043 / DMF0043_01 MNU_DESC 영문화 (FE fallback 한글 차단)
  UPDATE SCM_ADM_MNU_M
     SET MNU_DESC='Overseas Subs. Contribution Rate Reg.',
         LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE MNU_ID='DMF0043';

  UPDATE SCM_ADM_MNU_M
     SET MNU_DESC='Overseas Subs. Contribution Sales',
         LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE MNU_ID='DMF0043_01';

  COMMIT;
END;

-- 적용 후 55_..._Verify.sql 실행 → 4 검증 모두 PASS 확인
