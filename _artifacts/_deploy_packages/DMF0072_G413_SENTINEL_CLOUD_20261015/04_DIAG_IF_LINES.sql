-- =====================================================================================
-- 04_DIAG_IF_LINES.sql  클라우드 PR_DM_CUST_MODEL_MAPPING_IF 비교 라인만 조회 (조회 전용, 전체 F5 안전)
-- 03 결과는 TEXT 열 폭(4000자) 때문에 회신이 잘림 → 필요한 라인만 좁은 폭(200자)으로 출력
-- 대상: 하역지/플랜트/고객품번 컬럼이 나오는 라인 + MERGE/ON 라인 (사내 기준 29행)
-- 결과 전체를 복사해 회신해 주세요.
-- =====================================================================================
SELECT LINE,
       CAST(SUBSTR(REGEXP_REPLACE(RTRIM(TEXT, CHR(10)), '^[[:space:]]+', ''), 1, 200) AS VARCHAR2(200)) AS TXT
  FROM ALL_SOURCE
 WHERE OWNER = 'SCM_MGR'
   AND NAME  = 'PR_DM_CUST_MODEL_MAPPING_IF'
   AND TYPE  = 'PROCEDURE'
   AND (   UPPER(TEXT) LIKE '%UNLOADING_POINT%'
        OR UPPER(TEXT) LIKE '%CUSTOMER_PLANT%'
        OR UPPER(TEXT) LIKE '%CUST_MATERIAL_CODE%'
        OR UPPER(TEXT) LIKE '%CUSTOMER_ITEM_ID%'
        OR UPPER(TEXT) LIKE '%MERGE INTO%'
        OR REGEXP_LIKE(UPPER(TEXT), '(^|[[:space:]])ON[[:space:]]*\('))
 ORDER BY LINE;
