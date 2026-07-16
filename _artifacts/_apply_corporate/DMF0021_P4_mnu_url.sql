-- =====================================================================
-- DMF0021 P4 — MNU_URL 교체: 'dmf0003'(임시) → 'sales-plan' (2026-07-14)
-- 라우트 3-SET 정합: route-paths.ts DMF0021 상수 = Router.tsx path = MNU_URL (동일 kebab 문자열)
-- 충돌 실측: MNU_M / route-paths.ts 에 'sales-plan' 0건 (sales-plan-waterfall 은 별개 문자열)
-- 멱등: 가드 조건(MNU_URL='dmf0003') — 재실행 시 0행
-- =====================================================================
UPDATE SCM_MGR.SCM_ADM_MNU_M
SET MNU_URL = 'sales-plan', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
WHERE MNU_ID = 'DMF0021' AND MNU_URL = 'dmf0003';

COMMIT;

SELECT MNU_ID, MNU_URL, USE_YN FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0021';

-- 원복: UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='dmf0003' WHERE MNU_ID='DMF0021'; COMMIT;
