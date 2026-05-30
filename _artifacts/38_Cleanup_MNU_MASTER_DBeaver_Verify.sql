-- =============================================================================
-- 38_Cleanup_MNU_MASTER_DBeaver_Verify.sql
-- DBeaver 단일 SELECT (UNION ALL) — Ctrl+Enter 로 한 번에 실행
-- 모든 ACTUAL 컬럼이 EXPECT 와 일치해야 PASS
-- =============================================================================
SELECT 'MNU_M (master, DEMAND_MASTER) — DELETED' AS CHK,
       0 AS EXPECT,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_M
         WHERE MNU_ID IN ('master','DEMAND_MASTER')) AS ACTUAL
  FROM DUAL
UNION ALL
SELECT 'USER_GR_MNU_MPG (master tree) — DELETED',
       0,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
         WHERE MNU_ID IN ('master','DEMAND_MASTER'))
  FROM DUAL
UNION ALL
SELECT 'USER_GR_MNU_BTN_MPG (master tree) — DELETED',
       0,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
         WHERE MNU_ID IN ('master','DEMAND_MASTER'))
  FROM DUAL
UNION ALL
SELECT 'Master (대문자) 트리 — 18 자식 포함 보존',
       18,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_M
        START WITH MNU_ID = 'Master'
        CONNECT BY PRIOR MNU_ID = UPPR_MNU_ID)
  FROM DUAL
UNION ALL
SELECT 'Master root row 보존',
       1,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_M
         WHERE MNU_ID = 'Master')
  FROM DUAL
UNION ALL
SELECT 'Demand_Master 자식 row 보존',
       1,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_M
         WHERE MNU_ID = 'Demand_Master')
  FROM DUAL;
