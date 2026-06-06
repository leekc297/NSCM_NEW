--==============================================================================
-- 66_SYS0013_SCM0005_DynamicQuery_permission_fix.sql
--
-- 목적: SYS0013 (SCM0005 Dynamic Query) 화면 "권한없음" 사고 fix
--
-- 사고 (2026-06-09):
--   USER_GR_MNU_BTN_MPG_M 에 MNU_BTN_CD = RETRIEVE 만 있음 (8 row × 2 group)
--   FE useTabProcQuery default action = SEARCH 호출 → BE 권한 체크 시 SEARCH 없음 → "권한없음"
--   MNU_BTN_MPG_M 의 8 row 는 SEARCH/SAVE/EXECUTE 표준 사용 (정상)
--
-- 동작:
--   - USER_GR_MNU_BTN_MPG_M 의 RETRIEVE → SEARCH 정정 (MNU_BTN_MPG_M 과 일치)
--   - 2 group (ADMIN / SCM PI Admin) × 4 sheet (main/columns/parameters/history) = 8 row UPDATE
--   - SAVE / EXECUTE 권한은 그대로 유지
--
-- 멱등성: NOT EXISTS INSERT + RETRIEVE DELETE — 재실행 안전.
-- 참조 패턴: 60_SYS0012_SCM0009_full_fix.sql (BLOCK 5)
-- 작성: 2026-06-09
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : 사전 상태 ===
SELECT MNU_BTN_CD, COUNT(*) AS CNT
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID='SYS0013'
 GROUP BY MNU_BTN_CD
 ORDER BY MNU_BTN_CD;

PROMPT === BLOCK 2 : SEARCH 권한 INSERT (2 group × 4 sheet) ===
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.USER_GR_ID, NEW.MNU_ID, NEW.SHT_NM, NEW.MNU_BTN_CD, NEW.USE_YN, NEW.CREATED_BY, NEW.CREATION_DATE, NEW.LAST_UPDATED_BY, NEW.LAST_UPDATE_DATE
  FROM (
    SELECT 'ADMIN' AS USER_GR_ID, 'SYS0013' AS MNU_ID, 'main'       AS SHT_NM, 'SEARCH' AS MNU_BTN_CD, 'Y' AS USE_YN, 'system' AS CREATED_BY, SYSDATE AS CREATION_DATE, 'system' AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE FROM DUAL UNION ALL
    SELECT 'ADMIN',        'SYS0013', 'columns',    'SEARCH', 'Y', 'system', SYSDATE, 'system', SYSDATE FROM DUAL UNION ALL
    SELECT 'ADMIN',        'SYS0013', 'parameters', 'SEARCH', 'Y', 'system', SYSDATE, 'system', SYSDATE FROM DUAL UNION ALL
    SELECT 'ADMIN',        'SYS0013', 'history',    'SEARCH', 'Y', 'system', SYSDATE, 'system', SYSDATE FROM DUAL UNION ALL
    SELECT 'SCM PI Admin', 'SYS0013', 'main',       'SEARCH', 'Y', 'system', SYSDATE, 'system', SYSDATE FROM DUAL UNION ALL
    SELECT 'SCM PI Admin', 'SYS0013', 'columns',    'SEARCH', 'Y', 'system', SYSDATE, 'system', SYSDATE FROM DUAL UNION ALL
    SELECT 'SCM PI Admin', 'SYS0013', 'parameters', 'SEARCH', 'Y', 'system', SYSDATE, 'system', SYSDATE FROM DUAL UNION ALL
    SELECT 'SCM PI Admin', 'SYS0013', 'history',    'SEARCH', 'Y', 'system', SYSDATE, 'system', SYSDATE FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X
    WHERE X.USER_GR_ID = NEW.USER_GR_ID AND X.MNU_ID = NEW.MNU_ID
      AND X.SHT_NM = NEW.SHT_NM AND X.MNU_BTN_CD = NEW.MNU_BTN_CD
 );

PROMPT === BLOCK 3 : 잘못된 RETRIEVE 권한 row 삭제 (SEARCH 로 통합되었으므로) ===
DELETE FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID='SYS0013' AND MNU_BTN_CD='RETRIEVE';

PROMPT === BLOCK 4 : 사후 상태 ===
SELECT MNU_BTN_CD, COUNT(*) AS CNT
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID='SYS0013'
 GROUP BY MNU_BTN_CD
 ORDER BY MNU_BTN_CD;

COMMIT;
PROMPT === COMPLETE ===
EXIT;
