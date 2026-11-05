-- =====================================================================================================
-- 99_ROLLBACK.sql — 이 패키지가 INSERT 한 행만 삭제 (CREATED_BY='admin' 표식). 다른 작성자의 기존 행·UPDATE 된 행은 건드리지 않는다.
--   SOURCE-FRESH: 대상 키 = 사내 ZIOUI1 2026-10-30 16:17:24 실측 (PLAN_TYPE 3 · LBL01163/LBL01167 6)
--   MATCHED-UPDATE 가 일어난 행(클라우드에 다른 값의 PLAN_TYPE 이 있었던 경우)은 00_PRECHECK [P9] 결과로 수동 복원한다.
--   전체 F5 1회 · 재실행 안전(0행).
-- =====================================================================================================

DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = 'SCP0100' AND COLUMN_NAME = 'PLAN_TYPE' AND CREATED_BY = 'admin';
DELETE FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID IN ('LBL01163', 'LBL01167') AND CREATED_BY = 'admin';
COMMIT;

-- 사후 확인 (이 패키지 표식 행 0 기대)
SELECT 'R1' STEP, (SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0100' AND COLUMN_NAME='PLAN_TYPE' AND CREATED_BY='admin') PLAN_TYPE_ADMIN_ROWS,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID IN ('LBL01163', 'LBL01167') AND CREATED_BY='admin') LBL_ADMIN_ROWS FROM DUAL;
