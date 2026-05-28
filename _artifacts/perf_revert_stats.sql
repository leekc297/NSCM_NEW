-- =====================================================================
-- DMF0005 SP plan 복구
--   - 100% stats 가 plan 악화 → auto sample size 로 재수집
--   - 인덱스 IDX_SCM_ITEM_M_DIV_ITEM 은 유지 (효과 검증됨)
--   - shared_pool flush 로 stale cached plan 제거
-- =====================================================================
ALTER SESSION SET CONTAINER=FREEPDB1;

EXEC DBMS_STATS.GATHER_TABLE_STATS('FP_MGR','SCM_ITEM_M', estimate_percent=>DBMS_STATS.AUTO_SAMPLE_SIZE, cascade=>TRUE, method_opt=>'FOR ALL COLUMNS SIZE AUTO');
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','SCM_MST_SITE_ITEM', estimate_percent=>DBMS_STATS.AUTO_SAMPLE_SIZE, cascade=>TRUE, method_opt=>'FOR ALL COLUMNS SIZE AUTO');
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','SCM_MST_SITE', estimate_percent=>DBMS_STATS.AUTO_SAMPLE_SIZE, cascade=>TRUE, method_opt=>'FOR ALL COLUMNS SIZE AUTO');
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','SCM_MST_SITE_CUSTOMER', estimate_percent=>DBMS_STATS.AUTO_SAMPLE_SIZE, cascade=>TRUE, method_opt=>'FOR ALL COLUMNS SIZE AUTO');
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','SCM_MST_PROJECT', estimate_percent=>DBMS_STATS.AUTO_SAMPLE_SIZE, cascade=>TRUE, method_opt=>'FOR ALL COLUMNS SIZE AUTO');
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','DM_MST_CUSTOMER_MODEL', estimate_percent=>DBMS_STATS.AUTO_SAMPLE_SIZE, cascade=>TRUE, method_opt=>'FOR ALL COLUMNS SIZE AUTO');
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','SCM_MST_SSO_USER_INFO', estimate_percent=>DBMS_STATS.AUTO_SAMPLE_SIZE, cascade=>TRUE, method_opt=>'FOR ALL COLUMNS SIZE AUTO');
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','SCM_MST_SSO_DEPT_INFO', estimate_percent=>DBMS_STATS.AUTO_SAMPLE_SIZE, cascade=>TRUE, method_opt=>'FOR ALL COLUMNS SIZE AUTO');

ALTER SYSTEM FLUSH SHARED_POOL;

EXIT
