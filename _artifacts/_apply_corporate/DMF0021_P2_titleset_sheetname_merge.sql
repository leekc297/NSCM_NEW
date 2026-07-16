-- =====================================================================
-- DMF0021 P2 — TITLESET_USER SHEET_NAME 병합: 'salesPlan' → 'Sales Plan' (2026-07-14)
-- 근거 (실측): SP 3본(DATAEX L152 / SPREAD_TITLE L58 / PKG L140)이 'Sales Plan' 리터럴로 읽음.
--   'salesPlan' 526건 = AS-IS 운영 실데이터(2024-04~2026-04 실사용자 다수 — kjj0070/kcw3408 등),
--   'Sales Plan' 16건 = 2026-06-01 테스트성(chano0612 8 + '여기에_MEASURE보유_USER_ID' placeholder 8).
-- 방침 (사용자 확정 2026-07-14): 병합 rename — 충돌 시 최신 'salesPlan'(운영분) 우선.
-- 복합키: USER_ID + PROGRAM_ID + SHEET_NAME + USER_INQUIRY_COLUMN_TYPE_CODE + COLUMN_NAME
-- 멱등: 재실행 시 'salesPlan' 0건 → 전 구문 0행.
-- =====================================================================

-- 백업 (재실행 시 기존재 오류 무시하고 진행)
CREATE TABLE SCM_MGR.TITLESET_USER_BAK_DMF0021_0714 AS
SELECT * FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE PROGRAM_ID = 'DMF0021';

-- 1) placeholder 테스트 행 제거 (명백한 더미 USER_ID)
DELETE FROM SCM_MGR.SCM_MST_TITLESET_USER
WHERE PROGRAM_ID = 'DMF0021' AND USER_ID = '여기에_MEASURE보유_USER_ID';

-- 2) 충돌 정리: 동일 복합키로 'Sales Plan' 행이 이미 있으면 그 행 삭제 (운영분 'salesPlan' 우선)
DELETE FROM SCM_MGR.SCM_MST_TITLESET_USER t
WHERE t.PROGRAM_ID = 'DMF0021' AND t.SHEET_NAME = 'Sales Plan'
AND EXISTS (
    SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER s
    WHERE s.PROGRAM_ID = t.PROGRAM_ID AND s.SHEET_NAME = 'salesPlan'
      AND s.USER_ID = t.USER_ID
      AND s.USER_INQUIRY_COLUMN_TYPE_CODE = t.USER_INQUIRY_COLUMN_TYPE_CODE
      AND s.COLUMN_NAME = t.COLUMN_NAME
);

-- 3) 병합 rename
UPDATE SCM_MGR.SCM_MST_TITLESET_USER
SET SHEET_NAME = 'Sales Plan', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
WHERE PROGRAM_ID = 'DMF0021' AND SHEET_NAME = 'salesPlan';

COMMIT;

-- 검증: 'salesPlan' 잔존 0건 / 'Sales Plan' ≈ 526+8-충돌 건
SELECT SHEET_NAME, COUNT(*) FROM SCM_MGR.SCM_MST_TITLESET_USER
WHERE PROGRAM_ID = 'DMF0021' GROUP BY SHEET_NAME;

-- 원복: DELETE FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0021';
--       INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER SELECT * FROM SCM_MGR.TITLESET_USER_BAK_DMF0021_0714; COMMIT;
