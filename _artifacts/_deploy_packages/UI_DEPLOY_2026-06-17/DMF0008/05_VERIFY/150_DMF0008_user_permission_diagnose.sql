--==============================================================================
-- 150_DMF0008_user_permission_diagnose.sql
--
-- DMF0008 권한 없음 (-9997 No Permission) 진단
-- =============================================================================
-- 작성: 2026-06-17 (사용자 BE Response `{"code":"-9997","message":"No Permission"}` 보고 후)
--
-- 검증 흐름:
--   DIAG 1 : minyonglee1 의 SCM_ADM_USER_M row 존재 + USER_GR 직접 컬럼 확인
--   DIAG 2 : SCM_ADM_USER_GR_MPG_M 의 minyonglee1 USER_GR 매핑 인벤토리
--   DIAG 3 : minyonglee1 가 속한 USER_GR 의 DMF0008 권한 인벤토리
--   DIAG 4 : 필수 sheet/button 누락 검출
--   DIAG 5 : GUEST USER_GR 의 DMF0008 권한 (fallback)
--==============================================================================

SET LINESIZE 250
SET PAGESIZE 200
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === DIAG 1 : minyonglee1 user 정보 ===

SELECT USER_ID, USER_NAME,
       -- USER_GR_ID 컬럼이 SCM_ADM_USER_M 에 있는 경우 (직접 매핑)
       CASE WHEN COLUMN_VALUE IS NOT NULL THEN COLUMN_VALUE ELSE '(no direct USER_GR_ID column)' END AS DIRECT_USER_GR
  FROM SCM_MGR.SCM_ADM_USER_M u,
       TABLE(CAST(MULTISET(SELECT u.USER_GR_ID FROM DUAL WHERE 1=0) AS SYS.ODCIVARCHAR2LIST)) -- safe placeholder
 WHERE u.USER_ID = 'minyonglee1';

-- 위 query 가 ORA-00904 (USER_GR_ID column 미존재) 시 정상 — DIAG 2 로
SELECT USER_ID, USER_NAME, EMAIL,
       TO_CHAR(CREATION_DATE, 'YYYY-MM-DD') AS CREATION_DATE
  FROM SCM_MGR.SCM_ADM_USER_M
 WHERE USER_ID = 'minyonglee1';

PROMPT === DIAG 2 : SCM_ADM_USER_GR_MPG_M 매핑 ===

SELECT USER_ID, USER_GR_ID, USE_YN
  FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M
 WHERE USER_ID = 'minyonglee1';

PROMPT === DIAG 3 : minyonglee1 의 그룹 의 DMF0008 권한 인벤토리 ===

SELECT bt.USER_GR_ID, bt.SHT_NM, bt.MNU_BTN_CD, bt.USE_YN
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M bt
 WHERE bt.MNU_ID = 'DMF0008'
   AND bt.USER_GR_ID IN (
     SELECT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M
      WHERE USER_ID = 'minyonglee1'
   )
 ORDER BY bt.USER_GR_ID, bt.SHT_NM, bt.MNU_BTN_CD;

PROMPT === DIAG 4 : DMF0008 필수 sheet/button × minyonglee1 그룹 권한 누락 ===

WITH EXPECTED AS (
  SELECT 'summary'        AS SHT_NM, 'SEARCH' AS MNU_BTN_CD FROM DUAL UNION ALL
  SELECT 'repair',                    'SEARCH'              FROM DUAL UNION ALL
  SELECT 'repair',                    'SAVE'                FROM DUAL UNION ALL
  SELECT 'salesSite',                 'SEARCH'              FROM DUAL UNION ALL
  SELECT 'salesSite',                 'INSERT'              FROM DUAL UNION ALL
  SELECT 'salesSite',                 'SAVE'                FROM DUAL UNION ALL
  SELECT 'sspm',                      'SEARCH'              FROM DUAL UNION ALL
  SELECT 'sspm',                      'INSERT'              FROM DUAL UNION ALL
  SELECT 'sspm',                      'SAVE'                FROM DUAL UNION ALL
  SELECT 'updateHistory',             'SEARCH'              FROM DUAL UNION ALL
  SELECT 'main',                      'STATUS_UPDATE'       FROM DUAL
),
USER_GR AS (
  SELECT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M WHERE USER_ID = 'minyonglee1'
)
SELECT g.USER_GR_ID, e.SHT_NM, e.MNU_BTN_CD, '누락 — GUEST INSERT 필요' AS STATUS
  FROM USER_GR g
 CROSS JOIN EXPECTED e
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M bt
    WHERE bt.USER_GR_ID = g.USER_GR_ID AND bt.MNU_ID = 'DMF0008'
      AND bt.SHT_NM = e.SHT_NM AND bt.MNU_BTN_CD = e.MNU_BTN_CD
      AND bt.USE_YN = 'Y'
 )
 ORDER BY g.USER_GR_ID, e.SHT_NM, e.MNU_BTN_CD;

PROMPT === DIAG 5 : GUEST USER_GR 의 DMF0008 권한 (fallback 확인) ===

SELECT SHT_NM, MNU_BTN_CD, USE_YN
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0008' AND USER_GR_ID = 'GUEST'
 ORDER BY SHT_NM, MNU_BTN_CD;

--==============================================================================
-- 판독:
--   DIAG 2 row 0 → minyonglee1 의 USER_GR 매핑 자체 없음 → 사내 admin 등록 필요
--   DIAG 3 row 0 → 그룹은 있지만 DMF0008 권한 0 건 → DIAG 4 누락 모두 INSERT 필요
--   DIAG 4 row 1+ → 그 sheet/button 의 권한 INSERT 필요 (160 SQL 적용)
--   DIAG 5 row 0 → 140/145 file 적용 안 된 상태 → 145 file 사내 적용 필요
--==============================================================================
