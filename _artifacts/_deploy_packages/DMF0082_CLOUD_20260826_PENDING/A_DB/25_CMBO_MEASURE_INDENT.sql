-- DMF0082_CLOUD_20260826_PENDING / 공유 콤보 'Measure' — CUST 종속 데이터 기반 1단 항목 게이트에 DMF0082 추가
-- [E20260826-MEASINDENT] 계층 표기(1단 ' └ ' / 2단 '    └ ') 정본 = 이 콤보 단일 원천 (DMF0003 파리티).
-- 멱등: 이미 반영돼 있으면 0행 UPDATE — 재실행 무해. 게이트 구조라 타 17개 소비 화면 무영향.
UPDATE SCM_MGR.SCM_ADM_CMBO_SQL_M
SET    SQL_DTL_CTN = REPLACE(SQL_DTL_CTN,
         '@mnuId IN (''DMF0003'', ''DMF0035'', ''DMF0003_TEST'')',
         '@mnuId IN (''DMF0003'', ''DMF0035'', ''DMF0003_TEST'', ''DMF0082'')')
     , LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
WHERE  SQL_ID = 'Measure'
AND    DBMS_LOB.INSTR(SQL_DTL_CTN, '''DMF0003_TEST'', ''DMF0082''') = 0;
COMMIT;

-- 검증 (기대: 1 = 반영)
SELECT CASE WHEN DBMS_LOB.INSTR(SQL_DTL_CTN, '''DMF0003_TEST'', ''DMF0082''') > 0 THEN 1 ELSE 0 END AS APPLIED
FROM   SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'Measure';
