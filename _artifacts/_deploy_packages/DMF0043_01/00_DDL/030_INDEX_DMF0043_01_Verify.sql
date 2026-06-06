--==============================================================================
-- 030_INDEX_DMF0043_01_Verify.sql
--
-- 목적: DMF0043_01 가 SELECT 하는 마스터 테이블 INDEX 확인 (READ-ONLY)
-- 실행: SCM_MGR / SCMD_APP 세션
-- 작성: 2026-06-05
--
-- DMF0043_01 의 핵심 SP (DMF0043_GET_CONTRIBUTION_SALES_LIST) 가 사용하는 테이블:
--   - DM_MST_CONTRIBUTE_RATIO_MST / DTL / VER (DMF0043 와 동일)
--   - SCM_MST_SITE_ITEM / SCM_MST_SITE
--   - SCM_MST_SHEET_COLUMNS (PROGRAM_ID='DMF0043' / 'DMF0043_01' 모두)
--==============================================================================
SET LINESIZE 250
SET PAGESIZE 200
SET SERVEROUTPUT ON

PROMPT === DIAG 1 : 마스터 테이블 INDEX 인벤토리 ===

SELECT i.table_name, i.index_name, i.uniqueness, i.status,
       LISTAGG(c.column_name, ',') WITHIN GROUP (ORDER BY c.column_position) AS columns
  FROM all_indexes i
       JOIN all_ind_columns c ON c.index_owner = i.owner
                              AND c.index_name = i.index_name
                              AND c.table_owner = i.table_owner
                              AND c.table_name  = i.table_name
 WHERE i.table_owner = 'SCM_MGR'
   AND i.table_name IN (
     'DM_MST_CONTRIBUTE_RATIO_MST',
     'DM_MST_CONTRIBUTE_RATIO_DTL',
     'DM_MST_CONTRIBUTE_VER',
     'SCM_MST_SITE_ITEM',
     'SCM_MST_SITE',
     'SCM_MST_SHEET_COLUMNS'
   )
 GROUP BY i.table_name, i.index_name, i.uniqueness, i.status
 ORDER BY i.table_name, i.uniqueness DESC, i.index_name;

PROMPT === DIAG 2 : SCM_MST_SHEET_COLUMNS 의 DMF0043_01 행 인벤토리 ===

SELECT COLUMN_NAME, TO_NUMBER(SORT_ORDER_NO) AS sort,
       DEFAULT_FLAG, VISIBLE_FLAG, VALID_YN, DIVISION_ID
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0043_01'
 ORDER BY SHEET_NAME, TO_NUMBER(SORT_ORDER_NO);

PROMPT === 판독 ===
PROMPT - DIAG 1 INDEX 정상 + UNIQUE PK 존재 → OK
PROMPT - DIAG 2 SCM_MST_SHEET_COLUMNS 의 DMF0043_01 row > 0 → OK
PROMPT - DIAG 2 row 0 → DMF0043 와 SHEET_NAME 공유 (ContributeMain 등) — DMF0043 데이터 사용 가능
