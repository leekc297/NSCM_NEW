-- =============================================================================
-- 38_Cleanup_MNU_MASTER_DBeaver.sql
-- DBeaver 실행용 (SET/PROMPT/DEFINE/&/슬래시 금지)
-- 각 DELETE 를 단일 statement 로 — Ctrl+Enter 로 개별 실행 가능
-- =============================================================================

-- BLOCK 1: 버튼 권한 매핑 삭제 (자식 테이블 우선)
DELETE FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID IN ('master','DEMAND_MASTER');

-- BLOCK 2: 메뉴 권한 매핑 삭제
DELETE FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
 WHERE MNU_ID IN ('master','DEMAND_MASTER');

-- BLOCK 3: 자식 메뉴 (DEMAND_MASTER) 삭제
DELETE FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE MNU_ID = 'DEMAND_MASTER';

-- BLOCK 4: 부모 메뉴 (master) 삭제
DELETE FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE MNU_ID = 'master';

COMMIT;
