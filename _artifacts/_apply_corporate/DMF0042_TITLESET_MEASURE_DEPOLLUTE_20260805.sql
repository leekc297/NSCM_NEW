-- =====================================================================================
-- DMF0042 titleset 'C' 캐시 오염 정정 (2026-08-05) — hook #115 (titleset-cache-immunization) 계보
-- 증상  : DMF0042 Biz Plan 조회 ORA-00960 (PKG_DMF0042 L2724 OPEN 동적 PIVOT)
-- 원인  : SCM_MST_TITLESET_USER 'C' 에 고정컬럼 MEASURE 오염 1행 (2026-07-30 14:19 ColumnSet 저장 유래)
--         → ColList UNION 양쪽(titleset + hidden default)에서 "MEASURE" 2회 유입
--         → L2689 REPLACE 로 "SORT_ORDER_NO","MEASURE" 2회 확장 → SELECT 목록 중복 → ORA-00960
--         (AS-IS MSSQL 은 SELECT 목록 중복 허용 — 변환 잠재결함이 오염 데이터로 발현)
-- 조치  : 오염 1행 DELETE (멱등). SP 가드(hook #115 이식)·FE 모달 고정컬럼 제외는 별도 승인 대상.
-- 원복  : 아래 백업 값으로 INSERT
--   USER_ID=minyonglee1 / PROGRAM_ID=DMF0042 / SHEET_NAME=Biz Plan / TYPE=C / COLUMN_NAME=MEASURE
--   SORT_ORDER_NO=896 / CREATED_BY=minyonglee1 / CREATION_DATE=2026-07-30 14:19
-- =====================================================================================
DELETE FROM SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID = 'DMF0042'
   AND SHEET_NAME = 'Biz Plan'
   AND USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
   AND COLUMN_NAME = 'MEASURE';

COMMIT;

-- 검증 (기대 0행)
SELECT USER_ID, COLUMN_NAME
  FROM SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID = 'DMF0042'
   AND SHEET_NAME = 'Biz Plan'
   AND USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
   AND COLUMN_NAME = 'MEASURE';
