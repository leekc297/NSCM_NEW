--==============================================================================
-- 020_69_DMF0043_MNU_URL_Cloud_Fix_Verify.sql
--
-- 적용 후 검증 (1건만 expected = 'contribute-main')
--==============================================================================

-- VERIFY 1 : DMF0043 MNU_URL 값
SELECT 'DMF0043' AS CHECK_ITEM,
       'contribute-main' AS EXPECTED,
       MNU_URL AS ACTUAL,
       CASE WHEN MNU_URL = 'contribute-main' THEN 'PASS' ELSE 'FAIL' END AS RESULT
  FROM SCM_ADM_MNU_M
 WHERE MNU_ID = 'DMF0043';

-- VERIFY 2 : FE 표준 slug 인벤토리 (전수 표시 — 클라우드에서 추가 정합 필요한지 확인)
SELECT M.MNU_ID,
       M.MNU_URL AS DB_VALUE,
       FE.STANDARD_SLUG,
       CASE WHEN M.MNU_URL = FE.STANDARD_SLUG THEN 'PASS' ELSE 'MISMATCH' END AS RESULT
  FROM SCM_ADM_MNU_M M
  JOIN (
    SELECT 'DMF0004'    AS MNU_ID, 'sales-site'                AS STANDARD_SLUG FROM DUAL UNION ALL
    SELECT 'DMF0005',    'sales-site-project-model'                             FROM DUAL UNION ALL
    SELECT 'DMF0006',    'customer-model-mapping'                               FROM DUAL UNION ALL
    SELECT 'DMF0007',    'customer-fcst-master'                                 FROM DUAL UNION ALL
    SELECT 'DMF0043',    'contribute-main'                                      FROM DUAL UNION ALL
    SELECT 'DMF0043_01', 'contribute-view'                                      FROM DUAL UNION ALL
    SELECT 'DMF0008',    'erp-edi-master'                                       FROM DUAL UNION ALL
    SELECT 'DMF0072',    'nn-master-mapping'                                    FROM DUAL UNION ALL
    SELECT 'DMF0020',    'sales-future-price'                                   FROM DUAL UNION ALL
    SELECT 'DMF0082',    'forecast-price'                                       FROM DUAL UNION ALL
    SELECT 'DMF0022',    'sales-plan-waterfall'                                 FROM DUAL
  ) FE ON FE.MNU_ID = M.MNU_ID
 ORDER BY M.MNU_ID;
