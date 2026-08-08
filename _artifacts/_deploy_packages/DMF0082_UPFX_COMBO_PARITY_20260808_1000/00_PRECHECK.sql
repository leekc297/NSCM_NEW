-- ====================================================================================
-- DMF0082 UP_FX 콤보 정합 — 적용 전 PRECHECK (2026-08-08)
--   QA·DEV 각각 실행 후 결과를 90_VERIFY 의 "적용 후" 값과 대조한다.
--   ⚠️ 본 패키지는 **메타(SHEET_COLUMNS) 무변경**이 설계 원칙이다. [3] 의 소비자 시트 수가
--      적용 전후 동일해야 한다(달라지면 잘못 적용된 것).
-- ====================================================================================

-- [1] CMBO 'DefaultBucketDay' 등재 여부 (기대: 적용 전 0)
SELECT COUNT(*) AS DEFAULTBUCKETDAY_CMBO
FROM   SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'DefaultBucketDay';

-- [2] 마스터 lookup 존재 — 전 division × MONTHLY/WEEKLY (기대: 16행, division 8종)
SELECT COUNT(*) AS ROWS_CNT, COUNT(DISTINCT SEGMENT1) AS DIVISIONS
FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
WHERE  LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY' AND VALID_YN = 'Y';

-- [3] 공유 CMBO 소비자 시트 수 baseline — **적용 후 동일해야 함**(메타 무변경 증명)
--     기대(사내 2026-08-08 실측): Incoterms 36 / DOM_EXP 12 / DeptId 10 (distinct 시트 기준)
SELECT CELL_COMBO_DATA_TYPE, COUNT(DISTINCT PROGRAM_ID || '|' || SHEET_NAME) AS SHEETS
FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE  CELL_COMBO_DATA_TYPE IN ('Incoterms','DOM_EXP','DeptId') AND NVL(VALID_YN,'Y') = 'Y'
GROUP BY CELL_COMBO_DATA_TYPE ORDER BY 1;

-- [4] 편집판 CMBO 기등록 확인 (기대: 4행 전부 존재 — 신규 등록 불요)
SELECT SQL_ID FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
WHERE  SQL_ID IN ('IncotermsEdit','CustomsHandbook','AsIncotermsEdit','PlantByDivisionCompany')
ORDER BY 1;

-- [5] AS-IS 큐레이션 적용 범위 근거 — 40 전용 판정의 원장 실측
--     (81/82 는 EDIT_YN='N' Incoterms 와 DOM_EXP='D' 를 실사용하므로 40 에만 편집판 적용)
SELECT DIVISION_ID,
       COUNT(*) AS TOT,
       SUM(CASE WHEN DOM_EXP = 'D' THEN 1 ELSE 0 END) AS DOM_EXP_D,
       SUM(CASE WHEN INCOTERMS NOT IN (SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                        WHERE LOOKUP_TYPE='INCOTERMS' AND VALID_YN='Y' AND ATTRIBUTE2='Y')
                 THEN 1 ELSE 0 END) AS INCO_NOT_EDITABLE
FROM   SCM_MGR.DM_PLN_MKT_FCST
WHERE  DIVISION_ID IN ('40','81','82')
GROUP BY DIVISION_ID ORDER BY 1;

-- [6] TEAM_ID 편집판 제외 근거 — SAVE IN 파라미터에 teamId 부재 확인 (기대: 0행)
SELECT COUNT(*) AS TEAMID_IN_SAVE
FROM   SCM_MGR.SCM_ADM_PROC_M
WHERE  PROC_NM = 'PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA'
AND    COL_TP_CD = 'IN' AND LOWER(COL_NM) = 'teamid';
