-- ====================================================================================
-- DMF0082 클라우드 통합 이관 — 적용 전 PRECHECK  (2026-08-08)
--   ⚠️ QA·DEV **각각** 실행하고 결과를 비교한다(두 DB 상태가 다를 수 있다).
--   본 스크립트는 **무엇을 적용해야 하는지 스스로 판정**한다 — [0] 결과부터 읽을 것.
-- ====================================================================================

-- ────────────────────────────────────────────────────────────────────────────────────
-- [0] ⭐ 적용 대상 자동 판정 — 각 행의 STATUS 가 '적용 필요' 인 블록만 실행한다
-- ────────────────────────────────────────────────────────────────────────────────────
SELECT '선행: DMF0082_20260804_1032 (GTT/PKG 누적)' AS STEP,
       CASE WHEN (SELECT COUNT(*) FROM ALL_ARGUMENTS
                   WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0082'
                     AND ARGUMENT_NAME='P_PLANT_SITE_ID') > 0
            THEN '적용됨' ELSE '⛔ 미적용 — 본 패키지보다 먼저 적용 필요' END AS STATUS
FROM DUAL
UNION ALL
SELECT 'A. UICATEGORY (2026-08-07)',
       CASE WHEN (SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                   WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice') >= 61
             AND (SELECT COUNT(*) FROM ALL_ARGUMENTS
                   WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0082'
                     AND ARGUMENT_NAME='P_SENDER_CODE') > 0
            THEN '적용됨 — A 블록 skip' ELSE '적용 필요 — A_UICATEGORY_20260807 실행' END
FROM DUAL
UNION ALL
SELECT 'B-1. CMBO DefaultBucketDay (2026-08-08)',
       CASE WHEN (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
                   WHERE SQL_ID='DefaultBucketDay') > 0
            THEN '적용됨 — skip' ELSE '적용 필요' END
FROM DUAL
UNION ALL
SELECT 'B-2. CMBO GET_ADMIN_GROUP 권한 변형 (2026-08-08)',
       CASE WHEN (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
                   WHERE SQL_ID IN ('TeambyDivisionAuth','SiteByEndCustomerAuth',
                                    'EndCustomerByDivisionDeptAuth')
                     AND UPPER(SQL_DTL_CTN) LIKE '%GET_ADMIN_GROUP%') = 3
            THEN '적용됨 — skip' ELSE '적용 필요' END
FROM DUAL;

-- ────────────────────────────────────────────────────────────────────────────────────
-- [1] baseline — 적용 후 90_VERIFY 와 **반드시 비교**할 값
-- ────────────────────────────────────────────────────────────────────────────────────
-- [1-1] 공유 CMBO 소비 시트 수 — ⭐ 적용 후 **불변**이어야 한다(본 패키지는 시트 메타를 안 건드린다)
--       사내 기대: Incoterms 36 / DOM_EXP 12 / DeptId 10 (distinct 시트 기준)
SELECT CELL_COMBO_DATA_TYPE, COUNT(DISTINCT PROGRAM_ID || '|' || SHEET_NAME) AS SHEETS
FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE  CELL_COMBO_DATA_TYPE IN ('Incoterms','DOM_EXP','DeptId') AND NVL(VALID_YN,'Y')='Y'
GROUP BY CELL_COMBO_DATA_TYPE ORDER BY 1;

-- [1-2] DMF0082 시트 컬럼 노출 (A 적용 전이면 44 근처 / 적용 후 61·49·42·41)
SELECT COUNT(*) TOTAL,
       SUM(CASE WHEN ','||DIVISION_ID||',' LIKE '%,40,%' THEN 1 ELSE 0 END) D40,
       SUM(CASE WHEN ','||DIVISION_ID||',' LIKE '%,81,%' THEN 1 ELSE 0 END) D81,
       SUM(CASE WHEN ','||DIVISION_ID||',' LIKE '%,82,%' THEN 1 ELSE 0 END) D82
FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE  PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice';

-- [1-3] ⭐ B-2 영향 baseline — **DMF0003 조회 범위가 넓어진다.** 적용 전 행수를 남겨 둘 것.
--   (사내 실측: hongjae.kim SiteByEndCustomerAuth 0 → 1,282 / EndCustomerByDivisionDeptAuth 0 → 4)
--   ⚠️ 아래 :USER 를 실제 계정으로 바꿔 QA·DEV 각각 2~3 계정 측정 후 기록한다.
--   SELECT COUNT(*) FROM ( <SiteByEndCustomerAuth SQL 에 @sesUserId → '계정' 치환> );

-- [1-4] 권한 승격 원천 — GET_ADMIN_GROUP 등재 그룹 (클라우드에도 동일 등재돼 있어야 의미가 있다)
--   사내 실측 SEGMENT2='ALL': ADMIN / DM ADMIN / DM Planner / SCM PI Admin / SCP Planner / minyonglee1
--   ⛔ 이 목록이 클라우드와 다르면 B-2 적용 후 결과가 사내와 달라진다 — 먼저 대조할 것.
SELECT SEGMENT1 AS USER_GR_ID, SEGMENT2 AS SCOPE, VALID_YN
FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
WHERE  LOOKUP_TYPE='GET_ADMIN_GROUP' ORDER BY 2, 1;

-- [1-5] 배분 기본요일 마스터 (B-1 이 조회하는 원천 — 부재 시 콤보 0행 → FE 는 MON 폴백)
SELECT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS BUCKET, SEGMENT3 AS DAY_CD
FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
WHERE  LOOKUP_TYPE='DEFAULT_BUCKET_DAY' AND VALID_YN='Y' ORDER BY 1, 2;

-- [1-6] 리터럴 ADMIN 축소 이식 탐지 (B-2 적용 전 = 3건 / 적용 후 = 0건)
SELECT SQL_ID FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
WHERE  REGEXP_LIKE(UPPER(SQL_DTL_CTN), 'USER_GR_ID\s*=\s*''ADMIN''')
AND    UPPER(SQL_DTL_CTN) NOT LIKE '%GET_ADMIN_GROUP%' ORDER BY 1;

-- ────────────────────────────────────────────────────────────────────────────────────
-- [2] 백업 (적용 직전 실행 — 원복 원천)
-- ────────────────────────────────────────────────────────────────────────────────────
-- CREATE TABLE SCM_MGR.CMBO_BAK_CLOUD_20260808 AS
--   SELECT * FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
--    WHERE SQL_ID IN ('TeambyDivisionAuth','SiteByEndCustomerAuth','EndCustomerByDivisionDeptAuth');
-- CREATE TABLE SCM_MGR.SHEETCOL_BAK_CLOUD_20260808 AS
--   SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0082';
-- CREATE TABLE SCM_MGR.TITLESET_BAK_CLOUD_20260808 AS
--   SELECT * FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0082';
-- (PKG 는 적용 전 USER_SOURCE 덤프 보관)
