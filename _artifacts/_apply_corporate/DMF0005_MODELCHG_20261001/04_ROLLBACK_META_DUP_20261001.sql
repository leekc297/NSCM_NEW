-- =====================================================================================================
-- DMF0005 — 03_META 1차 적용(2026-10-01 13:00)이 만든 중복 버튼·권한 6행 원복 (사내 ZIOUI1 전용)
--   사유: 타 작업 경로(SYSADMIN, 11:18 기록)로 이미 production/MODEL_CHANGE · modelChange/SAVE 가 등록돼 있었음.
--         03 이 다른 이름(production/MODEL_CODE_CHANGE · modelChangePopup/SAVE)으로 같은 기능 버튼을 추가해 중복.
--   대상: 03 이 넣은 행만 (CREATED_BY='admin' + 키 정확 일치) — 기존 SYSADMIN 행 무접촉
-- =====================================================================================================
DELETE FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0005' AND CREATED_BY = 'admin'
   AND ( (SHT_NM = 'production'       AND MNU_BTN_CD = 'MODEL_CODE_CHANGE')
      OR (SHT_NM = 'modelChangePopup' AND MNU_BTN_CD = 'SAVE') );

DELETE FROM SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0005' AND CREATED_BY = 'admin'
   AND ( (SHT_NM = 'production'       AND MNU_BTN_CD = 'MODEL_CODE_CHANGE')
      OR (SHT_NM = 'modelChangePopup' AND MNU_BTN_CD = 'SAVE') );

COMMIT;
