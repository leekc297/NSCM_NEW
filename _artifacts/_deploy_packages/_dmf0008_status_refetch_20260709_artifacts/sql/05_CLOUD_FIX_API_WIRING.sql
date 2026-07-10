-- =====================================================================================
-- DMF0008 Status Update — 클라우드 API_M 오배선 정정 (2026-07-09 실측 확정)
--
-- 실측: 클라우드 P_DMF0008_STATUS_UPDATE 의 API_URL = 'DMF0008_GET_UPDATE_HISTORY' (오배선)
--       → 버튼 클릭 시 조회 SP 만 실행(항상 성공 토스트), 실행 SP 는 미호출 → START 로그·시간 미갱신
-- 정본(사내): API_URL = 'PR_DM_DNM_EDI_CALLOFF_STATUS' / PROC_M 0행(인자 없음)
-- =====================================================================================

UPDATE SCM_MGR.SCM_ADM_API_M
   SET API_URL = 'PR_DM_DNM_EDI_CALLOFF_STATUS',
       LAST_UPDATED_BY = 'fix_dmf0008_20260709',
       LAST_UPDATE_DATE = SYSDATE
 WHERE API_ID = 'P_DMF0008_STATUS_UPDATE'
   AND API_URL <> 'PR_DM_DNM_EDI_CALLOFF_STATUS';

-- 인자 0개 SP — PROC_M 파라미터 행이 있으면 안 됨 (사내 정본 = 0행)
DELETE FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM = 'PR_DM_DNM_EDI_CALLOFF_STATUS';

COMMIT;

-- 검증
SELECT b.MNU_BTN_CD, b.API_ID, a.API_URL
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M b
  JOIN SCM_MGR.SCM_ADM_API_M a ON a.API_ID = b.API_ID
 WHERE b.MNU_ID = 'DMF0008' AND b.MNU_BTN_CD = 'STATUS_UPDATE';
