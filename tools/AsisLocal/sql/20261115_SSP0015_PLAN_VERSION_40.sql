-- 2026-11-15 SSP0015 시험용 사업부 40 계획 버전 1건 (사용자 승인 2026-11-15 '넣기')
-- 목적  SSP0015 Plan date 목록(SSP_PLAN_VERSION_V)에 사업부 40 20261009 를 띄워 런처 조회 행을 만든다
-- 근거  SSP_PLAN_VERSION_V = scm_mst_plan_detail·scm_mst_plan·scm_mst_modeling(DAILY) 확정 계획 중 plan_name >= FN_GET_BUCKET_YYYYMMDD(-5)
--       사업부 40 마지막 확정 계획 145706(20260822) → 목록 0개 · SSP_ANL_SHIP_PLAN_40 계획일 20261009 = 28,148행
-- plan_id 145790 = DAILY 채번(주간 ID*100 + 01~07)이 만들지 않는 값 · 기존 3,030개 DAILY ID 끝자리 01~07 · 문자열 MAX(145807)보다 작음
-- 표시   ATTRIBUTE15 = 'ASISLIVE_TEST_20261115'
-- 대상   AS-IS 개발 MSSQL(LGCE_SCMDEV) 만

-- [적용]
INSERT INTO scm_mst_plan (division_id, plan_cycle, plan_id, plan_name, horizon_start_date, horizon_end_date,
                          creation_date, created_by, last_update_date, last_updated_by, attribute15)
SELECT division_id, plan_cycle, '145790', '20261009', '20261008', '20270128',
       SYSDATETIME(), 'asislive', SYSDATETIME(), 'asislive', 'ASISLIVE_TEST_20261115'
FROM   scm_mst_plan
WHERE  division_id = '40' AND plan_cycle = 'DAILY' AND plan_id = '145706'
AND    NOT EXISTS (SELECT 1 FROM scm_mst_plan WHERE division_id = '40' AND plan_cycle = 'DAILY' AND plan_id = '145790');

INSERT INTO scm_mst_plan_detail (MODELING_ID, DIVISION_ID, PLAN_ID, PLAN_SEQ, PLAN_TYPE, INPUT_START_DATE, INPUT_END_DATE, PLAN_START_DATE, PLAN_END_DATE,
       PLAN_OUTPUT_END_DATE, OUTPUT_START_DATE, OUTPUT_END_DATE, ANL_START_DATE, ANL_END_DATE, PLAN_STATUS, RUN_TYPE, PLAN_TYPE_DESCRIPTION, BASE_SEQ,
       DISPLAY_YN, UI_DISPLAY_YN, NORMAL_COMPLETE_YN, CONFIRM_FLAG, CONFIRM_USER, CONFIRM_DATE, ACTIVE_FLAG,
       CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY, ATTRIBUTE15)
SELECT MODELING_ID, DIVISION_ID, '145790', PLAN_SEQ, PLAN_TYPE,
       '2026-10-09 08:00:00', '2026-10-09 10:30:00', '2026-10-09 08:00:00', '2026-10-09 10:30:00',
       '2026-10-09 10:30:00', '2026-10-09 08:00:00', '2026-10-09 10:30:00', '2026-10-09 08:00:00', '2026-10-09 10:30:00',
       PLAN_STATUS, RUN_TYPE, PLAN_TYPE_DESCRIPTION, BASE_SEQ,
       DISPLAY_YN, UI_DISPLAY_YN, NORMAL_COMPLETE_YN, CONFIRM_FLAG, 'asislive', '2026-10-09 08:00:00', ACTIVE_FLAG,
       SYSDATETIME(), 'asislive', SYSDATETIME(), 'asislive', 'ASISLIVE_TEST_20261115'
FROM   scm_mst_plan_detail
WHERE  division_id = '40' AND plan_id = '145706'
AND    NOT EXISTS (SELECT 1 FROM scm_mst_plan_detail WHERE division_id = '40' AND plan_id = '145790');

-- [확인]
-- SELECT * FROM SSP_PLAN_VERSION_V WHERE division_id = '40';

-- [되돌리기]
-- DELETE FROM scm_mst_plan_detail WHERE division_id = '40' AND plan_id = '145790' AND ATTRIBUTE15 = 'ASISLIVE_TEST_20261115';
-- DELETE FROM scm_mst_plan        WHERE division_id = '40' AND plan_id = '145790' AND attribute15 = 'ASISLIVE_TEST_20261115';
