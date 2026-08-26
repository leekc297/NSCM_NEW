-- =====================================================================================
-- SDM1020 — [99] ROUTE_PATH — ⚠ 실행 순서 최후미: 반드시 FE 배포(B_FE 반영·빌드) 후 실행
-- 선적용 시 메뉴 클릭 -> 탭 내 "Page Not Found" (viewRegistry `pages/<화면>/index.ts` 가
--   유일 등록 키 — resolveView 실패). feedback_deploy_fe_partial_folder_notfound.md
-- 사내 현행 실측(2026-08-19): ROUTE_PATH='sdm/project-list' (사내 FE 기배포 상태)
-- =====================================================================================
UPDATE SCM_MGR.SCM_ADM_MNU_M SET ROUTE_PATH = 'sdm/project-list' WHERE MNU_ID = 'SDM1020';
COMMIT;

-- [검증] SELECT MNU_ID, ROUTE_PATH FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='SDM1020';  -- 'sdm/project-list'
