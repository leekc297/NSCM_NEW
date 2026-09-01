-- [E20260826-AUTHVIEW] SCP Planner = Excel Form/Upload 버튼 권한 회수 (사용자 지시 2026-08-26)
-- AS-IS 파리티: 81 SCP 는 DMF0003 화면(Excel 기능 없음)·판가 편집 불가 — Excel 진입 축 자체 불필요
-- FE 는 기존 hasButton('FORM_DATA')/hasButton('UPLOAD') 조건으로 자동 숨김 (코드 무수정 축)
UPDATE SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
SET USE_YN='N', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
WHERE MNU_ID='DMF0082' AND USER_GR_ID='SCP Planner' AND SHT_NM='FcstNPrice'
  AND MNU_BTN_CD IN ('FORM_DATA','UPLOAD','UPLOAD_DATA','UPLOAD_SAVE') AND USE_YN='Y';
COMMIT;

-- 검증 (기대: SCP Planner 계정에서 FORM_DATA/UPLOAD/UPLOAD_DATA/UPLOAD_SAVE 부재)
-- CALL SCM_MGR.PKG_NSCM_UI_COM_AUTH.PR_GET_MNU_BTN_AUTH('<scp계정>', 'DMF0082', ?);
