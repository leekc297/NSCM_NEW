-- =====================================================================
-- DMF0020 / 09_GTT_STATS / 검증 SQL
-- 기대: 14 row, PREFERENCE_VALUE = 'SESSION' 모두
-- =====================================================================
SELECT TABLE_NAME, PREFERENCE_NAME, PREFERENCE_VALUE
FROM ALL_TAB_STAT_PREFS
WHERE OWNER = 'SCM_MGR'
  AND TABLE_NAME LIKE 'GT_FTPR_%'
  AND PREFERENCE_NAME = 'GLOBAL_TEMP_TABLE_STATS'
ORDER BY TABLE_NAME;
