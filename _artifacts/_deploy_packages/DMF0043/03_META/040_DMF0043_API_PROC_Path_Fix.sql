--==============================================================================
-- 040_DMF0043_API_PROC_Path_Fix.sql
--
-- 원인: 클라우드 SCM_ADM_API_M / SCM_ADM_PROC_M 의 API_URL/PROC_NM 가
--       'PKG_DMF0043.P_DMF0043_XXX' (legacy 30_ 등록본) 로 잘못 저장되어
--       BE 호출 시 PLS-00302 (PKG 구성요소 없음) → -9994 wrapping.
--       실제 cloud 컴파일된 객체는 standalone SP (P_ prefix 없음, PKG 없음):
--          DMF0043_GET_CONTRIBUTE_MAIN_DATA
--          DMF0043_GET_CONTRIBUTION_SALES_LIST
--          DMF0043_GET_MAIN_SPREAD_TITLE
--          DMF0043_GET_SALES_LIST_SPREAD_TITLE
--          DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO
--          DMF0043_SAVE_DM_MST_CONTRIBUTE_VER
--          DMF0043_GET_CONTRIBUTE_RATE_POPUP
--          DMF0043_GET_CONTRIBUTE_YEAR_POPUP
--          DMF0043_GET_CONT_VIEW_VERSIONPOPUP
--          DMF0043_GET_MAIN_VARSION_DATA
--
-- 멱등: REGEXP_REPLACE + WHERE 가드 (재실행 안전)
-- 실행: SCM_MGR 세션. SQL*Plus / DBeaver 모두 OK
--
-- 출처: _artifacts/_deploy_packages/old/DMF0043_deploy_2026-06-02/02_DB_Meta_SQL/030_70_*
-- 작성: 2026-06-04
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === BLOCK 1 : SCM_ADM_API_M.API_URL 정합 (PKG_DMF0043.P_ -> DMF0043_) ===

UPDATE SCM_MGR.SCM_ADM_API_M
   SET API_URL          = REGEXP_REPLACE(API_URL, '^PKG_DMF0043\.P?_?', ''),
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE API_ID LIKE 'DMF0043%'
   AND API_URL LIKE 'PKG_DMF0043.%';

PROMPT === BLOCK 2 : SCM_ADM_PROC_M.PROC_NM 정합 ===

UPDATE SCM_MGR.SCM_ADM_PROC_M
   SET PROC_NM          = REGEXP_REPLACE(PROC_NM, '^PKG_DMF0043\.P?_?', ''),
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROC_NM LIKE 'PKG_DMF0043.%';

PROMPT === BLOCK 3 : 검증 — fix 후 어떤 row 도 PKG_DMF0043. prefix 없어야 함 ===

SELECT 'API_M' AS src, api_id AS name, api_url AS value
  FROM SCM_MGR.SCM_ADM_API_M
 WHERE api_id LIKE 'DMF0043%'
 UNION ALL
SELECT 'PROC_M', proc_nm, col_nm
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE proc_nm LIKE 'DMF0043%' OR proc_nm LIKE 'PKG_DMF0043%'
 ORDER BY 1, 2;

PROMPT === BLOCK 4 : 잔존 PKG path 0건 확인 (FAIL 시 BLOCK 1-2 재실행) ===

SELECT 'API_M' AS src, COUNT(*) AS pkg_path_remaining_count
  FROM SCM_MGR.SCM_ADM_API_M
 WHERE api_url LIKE 'PKG_DMF0043.%'
 UNION ALL
SELECT 'PROC_M', COUNT(*)
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE proc_nm LIKE 'PKG_DMF0043.%';

COMMIT;
