-- =====================================================================
-- DMF0005 (Production/Purchase) SP 성능 보강
-- 작성일: 2026-05-27
-- 목적: 직접 SP 호출 4분 51초 → 합리적 시간으로 단축
--
-- 핵심 원인:
--   - SCM_MST_ITEM_SN (614,575 rows) 에 인덱스 0건 → ITEM_AGG CTE 풀스캔
--   - 관련 테이블들의 통계가 sample 또는 stale
-- =====================================================================

WHENEVER SQLERROR EXIT SQL.SQLCODE

-- 인덱스 추가
CREATE INDEX IF NOT EXISTS IDX_SCM_MST_ITEM_SN_DIV_ITEM
    ON SCM_MST_ITEM_SN (DIVISION_ID, ITEM_ID);

-- 관련 테이블 통계 100% 재수집
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','SCM_MST_ITEM_SN', estimate_percent=>100, cascade=>TRUE);
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','SCM_MST_SITE_ITEM', estimate_percent=>100, cascade=>TRUE);
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','SCM_MST_SITE', estimate_percent=>100, cascade=>TRUE);
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','SCM_MST_SITE_CUSTOMER', estimate_percent=>100, cascade=>TRUE);
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','SCM_MST_PROJECT', estimate_percent=>100, cascade=>TRUE);
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','DM_MST_CUSTOMER_MODEL', estimate_percent=>100, cascade=>TRUE);
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','SCM_ADM_LOOKUP_MASTER_DETAIL', estimate_percent=>100, cascade=>TRUE);

EXIT
