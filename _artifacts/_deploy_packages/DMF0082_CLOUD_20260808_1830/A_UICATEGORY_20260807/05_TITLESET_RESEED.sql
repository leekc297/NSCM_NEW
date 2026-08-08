-- ====================================================================
-- DMF0082 UICATEGORY — TITLESET 전체 재시드 (클라우드용, 2026-08-07 사용자 확정)
--   클라우드 사용자 개인화(컬럼/메저 선택) 전체 삭제 → 각 사용자 최초 조회 시 자동 재시드
--   (P_DMF0082_GET_MAIN_DATA 시드 = 'C'/'M' 양 타입 커버 — 보강된 DIVISION 토큰·신규 컬럼 반영)
--   ⚠️ 반드시 04_META 적용 이후 실행 (재시드 기준 = DEFAULT_FLAG='Y' AND VALID_YN='Y')
--   ⚠️ 개인화 소실 — 적용 전 백업 권장:
--     CREATE TABLE SCM_MGR.TITLESET_USER_BAK_DMF0082_CLOUD_0807 AS
--       SELECT * FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0082';
--   ⚠️ QA·DEV 2곳 동시 적용 의무
-- ====================================================================

DELETE FROM SCM_MGR.SCM_MST_TITLESET_USER
WHERE  PROGRAM_ID = 'DMF0082'
AND    SHEET_NAME = 'FcstNPrice';

COMMIT;

-- [검증] 기대 0행 (이후 사용자 조회 시 자동 재생성)
SELECT COUNT(*) REMAIN FROM SCM_MGR.SCM_MST_TITLESET_USER
WHERE  PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice';
