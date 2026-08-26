-- =====================================================================================
-- SDM5010 Project Master — [99] ROUTE_PATH — ⛔ 파일만 생성, 지금 실행 금지
-- FE 완성(viewRegistry 키 'sdm/project-master' = features/.../pages/<화면>/index.ts 등록) 후 별도 적용.
-- 선적용 시 메뉴 클릭 → 탭 내 "Page Not Found" (resolveView 실패) — feedback_deploy_fe_partial_folder_notfound.md
-- =====================================================================================
UPDATE SCM_MGR.SCM_ADM_MNU_M SET ROUTE_PATH = 'sdm/project-master' WHERE MNU_ID = 'SDM5010';
COMMIT;
