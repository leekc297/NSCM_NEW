-- Verify (DDL/DML 없음 — SELECT 만, 5 BLOCK)
-- 적용 후 카운트 검증. DBeaver 호환 (PROMPT/SET 0건)

-- BLOCK 1: i18n MNU 신규 (=15 의무)
SELECT 'BLOCK 1: i18n MNU' AS chk,
       COUNT(*) AS actual,
       15 AS expect,
       CASE WHEN COUNT(*)=15 THEN 'PASS' ELSE 'FAIL' END AS result
FROM SCM_MGR.SCM_ADM_MSG_M
WHERE MSG_ID IN ('MNU_BIZPLAN','MNU_SALES_REPORT','MNU_DMF0042_1','MNU_DMF0042_2','MNU_DMF0042_3');

-- BLOCK 2: 부모 메뉴 2건
SELECT 'BLOCK 2: 부모 메뉴' AS chk,
       COUNT(*) AS actual,
       2 AS expect,
       CASE WHEN COUNT(*)=2 THEN 'PASS' ELSE 'FAIL' END AS result
FROM SCM_MGR.SCM_ADM_MNU_M
WHERE MNU_ID IN ('Bizplan','Sales_Report') AND USE_YN='Y';

-- BLOCK 3: 자식 신규 3건
SELECT 'BLOCK 3: 자식 신규' AS chk,
       COUNT(*) AS actual,
       3 AS expect,
       CASE WHEN COUNT(*)=3 THEN 'PASS' ELSE 'FAIL' END AS result
FROM SCM_MGR.SCM_ADM_MNU_M
WHERE MNU_ID IN ('DMF0042_1','DMF0042_2','DMF0042_3') AND USE_YN='Y';

-- BLOCK 4: URL slug 의미 (= 8건 OK, DB slug 가 'dmf%' 형식이 아님)
SELECT 'BLOCK 4: URL slug 의미' AS chk,
       COUNT(*) AS actual,
       8 AS expect,
       CASE WHEN COUNT(*)=8 THEN 'PASS' ELSE 'FAIL' END AS result
FROM SCM_MGR.SCM_ADM_MNU_M
WHERE MNU_ID IN ('DMF0014','DMF0021','DMF0042','DMF0044','DMF0048','DMF0049','DMF0074','DMF0081')
  AND MNU_URL NOT LIKE 'dmf%';

-- BLOCK 5: UPPR fix (= 3건 DMF0042/0044/0049 → Bizplan/Sales_Report)
SELECT 'BLOCK 5: UPPR fix' AS chk,
       COUNT(*) AS actual,
       3 AS expect,
       CASE WHEN COUNT(*)=3 THEN 'PASS' ELSE 'FAIL' END AS result
FROM SCM_MGR.SCM_ADM_MNU_M
WHERE MNU_ID IN ('DMF0042','DMF0044','DMF0049')
  AND UPPR_MNU_ID IN ('Bizplan','Sales_Report');

-- BLOCK 6: 권한 신규 15건 (3 그룹 × 5 메뉴)
SELECT 'BLOCK 6: 권한 신규' AS chk,
       COUNT(*) AS actual,
       15 AS expect,
       CASE WHEN COUNT(*)=15 THEN 'PASS' ELSE 'FAIL' END AS result
FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
WHERE USER_GR_ID IN ('ADMIN','DM ADMIN','DM Viewer')
  AND MNU_ID IN ('Bizplan','Sales_Report','DMF0042_1','DMF0042_2','DMF0042_3');

-- 종합: 14 메뉴 최종 상태
SELECT MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_DESC, MNU_TP_CD, USE_YN
FROM SCM_MGR.SCM_ADM_MNU_M
WHERE MNU_ID IN ('DMF0014','DMF0021','DMF0042','DMF0042_1','DMF0042_2','DMF0042_3',
                 'DMF0044','DMF0048','DMF0049','DMF0074','DMF0081','DMF0082',
                 'Bizplan','Sales_Report')
ORDER BY DECODE(UPPR_MNU_ID, 'Report', 0, 'Demand_Plan', 1, 'Bizplan', 2, 'Sales_Report', 3, 9), SORT_ORD, MNU_ID;
