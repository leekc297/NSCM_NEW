--==============================================================================
-- 030_70_DMF0043_API_PROC_Path_Fix_DBeaver.sql
--
-- 원인: 클라우드 SCM_ADM_API_M / SCM_ADM_PROC_M 의 API_URL/PROC_NM 가
--       'PKG_DMF0043.P_DMF0043_XXX' (legacy 30_ 등록본) 로 잘못 저장되어
--       BE 호출 시 PLS-00302 (PKG 구성요소 없음) → -9994 wrapping.
--       실제 클라우드 컴파일된 객체는 standalone SP (P_ prefix 없음, PKG 없음):
--          DMF0043_GET_CONTRIBUTE_MAIN_DATA
--          DMF0043_GET_CONTRIBUTION_SALES_LIST
--          DMF0043_GET_MAIN_SPREAD_TITLE
--          DMF0043_GET_SALES_LIST_SPREAD_TITLE
--          DMF0043_SAVE_CONTRIBUTE_RATE
--          DMF0043_SAVE_CONTRIBUTE_RATE_POPUP
--          DMF0043_GET_CONTRIBUTE_RATE_POPUP
--          DMF0043_GET_MAIN_VARSION_DATA
--          DMF0043_GET_TITLESET_POPUP    (공용)
--
-- 룰: Doc/_dev_rules/hooks/dbeaver-sql-mandatory-grep (SQL*Plus 0건)
-- 멱등: REGEXP_REPLACE + WHERE 가드 (재실행 안전)
--
-- 작성: 2026-06-04
--==============================================================================

-- BLOCK 1 : SCM_ADM_API_M.API_URL 정합
--    'PKG_DMF0043.P_DMF0043_XXX' 또는 'PKG_DMF0043.DMF0043_XXX' → 'DMF0043_XXX'
UPDATE SCM_ADM_API_M
   SET API_URL          = REGEXP_REPLACE(API_URL, '^PKG_DMF0043\.P?_?', ''),
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE API_ID LIKE 'DMF0043%'
   AND API_URL LIKE 'PKG_DMF0043.%';

-- BLOCK 2 : SCM_ADM_PROC_M.PROC_NM 정합 (PK 의 일부라 UPDATE 가능 — 동일 row 안)
UPDATE SCM_ADM_PROC_M
   SET PROC_NM          = REGEXP_REPLACE(PROC_NM, '^PKG_DMF0043\.P?_?', ''),
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROC_NM LIKE 'PKG_DMF0043.%';

-- BLOCK 3 : 검증 — fix 후 어떤 row 도 PKG_DMF0043. prefix 없어야 함
SELECT 'API_M' SRC, API_ID NAME, API_URL VALUE FROM SCM_ADM_API_M
 WHERE API_ID LIKE 'DMF0043%'
 UNION ALL
SELECT 'PROC_M', PROC_NM, COL_NM FROM SCM_ADM_PROC_M
 WHERE PROC_NM LIKE 'DMF0043%' OR PROC_NM LIKE 'PKG_DMF0043%'
 ORDER BY 1, 2;

COMMIT;
