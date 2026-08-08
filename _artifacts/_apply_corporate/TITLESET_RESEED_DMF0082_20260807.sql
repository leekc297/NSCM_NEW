-- =====================================================================
-- DMF0082 uicategory — TITLESET 전체 재시드 (2026-08-07, 사용자 확정)
-- 47명 C 540 + M 272 = 812행 삭제 → 각 사용자 최초 조회 시 자동 재시드
--   (P_DMF0082_GET_MAIN_DATA 시드 = 'C' L242~275 + 'M' L286~319 — 양 타입 커버 실측)
-- 재시드 기준 = DEFAULT_FLAG='Y' AND VALID_YN='Y' (보강된 DIVISION 토큰·신규 컬럼 반영)
-- ⚠️ 반드시 META(SHEET_COLUMNS) 적용 이후 실행 (본 파일 = Phase 6)
-- 원복 = ROLLBACK_DMF0082_uicategory_20260807.sql [3] (백업 812행 복원)
-- =====================================================================

DELETE FROM SCM_MGR.SCM_MST_TITLESET_USER
WHERE  PROGRAM_ID = 'DMF0082'
AND    SHEET_NAME = 'FcstNPrice';

COMMIT;

-- [검증] 기대 0행
SELECT COUNT(*) REMAIN FROM SCM_MGR.SCM_MST_TITLESET_USER
WHERE  PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice';
