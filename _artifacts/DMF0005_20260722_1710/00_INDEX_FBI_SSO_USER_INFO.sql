-- [PERF-DMF0005 20260722] Step 0: FBI — FN_GET_MULTI_OWNER_NAME 의 UPPER(USER_ID) 조회 SARGable 화
-- 사유: 함수 내부 SELECT 가 UPPER(USER_ID)=UPPER(:x) 라 PK(USER_ID) 인덱스를 못 타고 호출당 128,610행 풀스캔.
--       DMF0005 '81' 조회 300s+ 의 주범 (ASH 300샘플 중 298). 동일 함수를 쓰는 DMF0003 등 전 화면 공통 이득.
-- 멱등: 기존재 시 ORA-00955 / ORA-01408 skip
-- 적용: 2026-07-22 사내 OCGSCMD_P01 (사용자 승인)
CREATE INDEX IDX02_SCM_MST_SSO_USER_INFO ON SCM_MST_SSO_USER_INFO (UPPER(USER_ID));

-- 검증
-- SELECT index_name, status, funcidx_status FROM user_indexes WHERE index_name='IDX02_SCM_MST_SSO_USER_INFO';
