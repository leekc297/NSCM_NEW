-- ====================================================================================
-- DMF0082 UP_FX 콤보 정합 — 적용 후 검증 (2026-08-08) · QA·DEV 각각 실행
-- ====================================================================================

-- [1] CMBO 'DefaultBucketDay' 등재 (기대: 1)
SELECT COUNT(*) AS DEFAULTBUCKETDAY_CMBO
FROM   SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'DefaultBucketDay';

-- [2] 치환 실행 검증 — division × bucketType 조합마다 정확히 1행
--     기대: 40/W=MON · 81/M=FRI · 82/D=FRI (사내 실측)
SELECT '40' AS DIV, 'W' AS BKT, L.SEGMENT3 AS CODE
FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
WHERE  L.LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY' AND L.VALID_YN = 'Y' AND L.SEGMENT1 = '40'
AND    L.SEGMENT2 = CASE WHEN 'W' IN ('D','DAILY','M','MONTHLY') THEN 'MONTHLY' ELSE 'WEEKLY' END
UNION ALL
SELECT '81', 'M', L.SEGMENT3 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
WHERE  L.LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY' AND L.VALID_YN = 'Y' AND L.SEGMENT1 = '81'
AND    L.SEGMENT2 = CASE WHEN 'M' IN ('D','DAILY','M','MONTHLY') THEN 'MONTHLY' ELSE 'WEEKLY' END
UNION ALL
SELECT '82', 'D', L.SEGMENT3 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
WHERE  L.LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY' AND L.VALID_YN = 'Y' AND L.SEGMENT1 = '82'
AND    L.SEGMENT2 = CASE WHEN 'D' IN ('D','DAILY','M','MONTHLY') THEN 'MONTHLY' ELSE 'WEEKLY' END;

-- [3] ⭐ 메타 무변경 증명 — 00_PRECHECK [3] 과 **완전히 동일**해야 한다
--     (Incoterms 36 / DOM_EXP 12 / DeptId 10 (distinct 시트 기준). 하나라도 줄면 메타를 잘못 건드린 것 → 즉시 원복)
SELECT CELL_COMBO_DATA_TYPE, COUNT(DISTINCT PROGRAM_ID || '|' || SHEET_NAME) AS SHEETS
FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE  CELL_COMBO_DATA_TYPE IN ('Incoterms','DOM_EXP','DeptId') AND NVL(VALID_YN,'Y') = 'Y'
GROUP BY CELL_COMBO_DATA_TYPE ORDER BY 1;

-- [4] DMF0082 셀 콤보 배선 무변경 (기대: INCOTERMS=Incoterms / DOM_EXP=DOM_EXP / TEAM_ID=DeptId)
--     편집판 교체는 **FE 스왑**으로 처리하므로 메타는 표시용 그대로여야 한다.
SELECT COLUMN_NAME, CELL_COMBO_DATA_TYPE
FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE  PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice'
AND    COLUMN_NAME IN ('INCOTERMS','DOM_EXP','TEAM_ID','MEASURE','CELL_PROD_SITE_ID','SCM_SITE_ID','PLANT_SITE_ID')
ORDER BY 1;

-- [5] Measure 콤보 @mnuId 실효 검증 — 치환값에 따라 행수가 달라져야 한다
--     기대: DMF0082 = 14행 이상(SHEET_MEASURE 분기 반영) / '' = 하드코딩 DUAL 목록만
SELECT COUNT(*) AS MEASURE_ROWS_DMF0082
FROM   SCM_MGR.SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID = 'DMF0082' AND VALID_YN = 'Y';
SELECT COUNT(*) AS MEASURE_ROWS_EMPTY_TOKEN
FROM   SCM_MGR.SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID = '' AND VALID_YN = 'Y';  -- 기대 0 (결함 재현 조건)

-- [6] 편집판 CMBO 행수 (기대: IncotermsEdit 10 / CustomsHandbook 1 / AsIncotermsEdit div별 0~3)
SELECT 'IncotermsEdit' AS CMB, COUNT(*) AS ROWS_CNT FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
WHERE  LOOKUP_TYPE = 'INCOTERMS' AND VALID_YN = 'Y' AND ATTRIBUTE2 = 'Y'
UNION ALL
SELECT 'CustomsHandbook', COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
WHERE  LOOKUP_TYPE = 'DM_CUSTOMS_HANDBOOK_40' AND VALID_YN = 'Y'
UNION ALL
SELECT 'AsIncotermsEdit(' || SEGMENT1 || ')', COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
WHERE  LOOKUP_TYPE = 'AS_INCOTERMS' AND VALID_YN = 'Y' GROUP BY SEGMENT1;

-- [7] FE 게이트 (DB 아님 — 적용 후 로컬/CI 에서 실행)
--   python _artifacts/_diagnostics/ui_gate_runner.py --menu DMF0082 \
--          --page nscm-fe/features/demand/src/pages/forecast-price
--     → 섹션 7 FAIL 0 (WARN 2 = EndCustomerByDivisionDept @deptId · PlantByDivisionCompany @companyId,
--       둘 다 관대형이며 사유는 __asis-mapping__.md 토큰 대사표에 기재)
--   python _artifacts/_diagnostics/ui_http_e2e.py --menu DMF0082
--     → D2 축 셀 콤보 0행 FAIL 0
