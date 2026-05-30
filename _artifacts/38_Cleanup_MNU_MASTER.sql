-- =============================================================================
-- 38_Cleanup_MNU_MASTER.sql
-- 가짜 root 메뉴 'master' (i18n 미연결, MNU_MSG_ID='MNU_MASTER') 정리
-- =============================================================================
-- 작성: 2026-05-30
-- 배경: 메뉴 트리에 'MNU_MASTER' 라는 raw 코드가 노출됨. 진짜 메뉴는
--       대문자 'Master' (MNU_MSG_ID='MNU00001') 이며 동일 MNU_URL='master'.
--
-- 삭제 대상:
--   SCM_ADM_MNU_M
--     master         (root, MNU_MSG_ID='MNU_MASTER',         MNU_URL='master')
--     DEMAND_MASTER  (자식, MNU_MSG_ID='MNU_DEMAND_MASTER',  MNU_URL='demand-master')
--   SCM_ADM_USER_GR_MNU_MPG_M  → 2 row (위 2 메뉴 권한)
--   SCM_ADM_USER_GR_MNU_BTN_MPG_M → 0 row
--
-- 보존:
--   Master (대문자) 트리 — 17 자식 화면 (DM*, DMF*) 그대로
--
-- 실행:
--   sqlplus SCM_MGR/'!SCMroqkf2026'@//localhost:1521/FREEPDB1 @38_Cleanup_MNU_MASTER.sql
-- =============================================================================

SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 100
SET LINESIZE 200
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT
PROMPT === BLOCK 0: 사전 카운트 ===

SELECT 'PRE: MNU_M(master)' AS K, COUNT(*) AS V FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID IN ('master','DEMAND_MASTER');
SELECT 'PRE: GR_MNU_MPG'    AS K, COUNT(*) AS V FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID IN ('master','DEMAND_MASTER');
SELECT 'PRE: GR_BTN_MPG'    AS K, COUNT(*) AS V FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID IN ('master','DEMAND_MASTER');

PROMPT
PROMPT === BLOCK 1: 버튼 권한 매핑 삭제 (자식 테이블 우선) ===
DELETE FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID IN ('master','DEMAND_MASTER');

PROMPT
PROMPT === BLOCK 2: 메뉴 권한 매핑 삭제 ===
DELETE FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
 WHERE MNU_ID IN ('master','DEMAND_MASTER');

PROMPT
PROMPT === BLOCK 3: 자식 메뉴 (DEMAND_MASTER) 삭제 ===
DELETE FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE MNU_ID = 'DEMAND_MASTER';

PROMPT
PROMPT === BLOCK 4: 부모 메뉴 (master) 삭제 ===
DELETE FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE MNU_ID = 'master';

PROMPT
PROMPT === BLOCK 5: 사후 카운트 (모두 0 이어야 함) ===

SELECT 'POST: MNU_M(master)' AS K, COUNT(*) AS V FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID IN ('master','DEMAND_MASTER');
SELECT 'POST: GR_MNU_MPG'    AS K, COUNT(*) AS V FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID IN ('master','DEMAND_MASTER');
SELECT 'POST: GR_BTN_MPG'    AS K, COUNT(*) AS V FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID IN ('master','DEMAND_MASTER');

PROMPT
PROMPT === BLOCK 6: Master (대문자) 트리 보존 검증 ===

SELECT 'POST: Master tree' AS K, COUNT(*) AS V
  FROM SCM_MGR.SCM_ADM_MNU_M
 START WITH MNU_ID = 'Master'
 CONNECT BY PRIOR MNU_ID = UPPR_MNU_ID;

COMMIT;

PROMPT
PROMPT === 완료 ===
EXIT;
