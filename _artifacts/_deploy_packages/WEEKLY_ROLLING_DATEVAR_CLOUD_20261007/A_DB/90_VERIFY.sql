/* 90 VERIFY — 조회 전용 */
SELECT 'V1 VALID' AS chk, status AS val FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND object_type = 'PROCEDURE'
UNION ALL SELECT 'V2 마커 14', TO_CHAR(COUNT(*)) FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND type = 'PROCEDURE' AND text LIKE '%E20261007-DATEVAR%'
UNION ALL SELECT 'V3 술어 안 함수 잔존 0', TO_CHAR(COUNT(*)) FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND type = 'PROCEDURE'
                 AND text LIKE '%TO_CHAR(FN_NEXT_DAY(SYSDATE, ''MON'')%' AND text NOT LIKE '%V_FROM_%'
UNION ALL SELECT 'V4 대입문 2', TO_CHAR(COUNT(*)) FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND type = 'PROCEDURE' AND REGEXP_LIKE(text, '^\s*V_FROM_(1W|54W)\s+:=')
UNION ALL SELECT 'V5 의존 INVALID 0', TO_CHAR(COUNT(*)) FROM all_objects o WHERE o.owner = 'SCM_MGR' AND o.status = 'INVALID'
                 AND o.object_name IN (SELECT name FROM all_dependencies WHERE referenced_owner = 'SCM_MGR' AND referenced_name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING');
/* V6 동치(선택, 조회 전용·사내 40 기준 191,466행 함수형 58.9s → 바인드형 0.8s): 함수 술어 vs 리터럴 날짜 건수 비교 */
SELECT 'V6 함수형' AS chk, COUNT(*) AS cnt, SUM(F.QTY) AS qty FROM SCM_MGR.DM_PLN_MKT_FCST F, SCM_MGR.SCM_MST_SITE_ITEM T2
 WHERE F.DIVISION_ID = T2.DIVISION_ID AND F.PROJECT_CODE = T2.PROJECT_CODE AND F.SCM_SITE_ID = T2.SCM_SITE_ID AND F.ITEM_ID = T2.ITEM_ID AND T2.VALID_YN = 'Y' AND F.DIVISION_ID = '40'
   AND F.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
   AND F.MEASURE NOT IN ('CUST_FCST_EDI_ORG','Immidiate[Org.]','Planning_Forecast[Org.]','Commercial_Agreement[Org.]','Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]','Material_Temp[Org.]','Backorder[Org.]');
/* 다음 주 월요일 15:00 이후: dfrascwsp66jy 의 phv·elapsed 가 바뀌었는지 (03_root_block_measure.sql Q13 / DBA_HIST_SQLBIND 한 줄 쿼리) */
