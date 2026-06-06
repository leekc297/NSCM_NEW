--==============================================================================
-- 040_INDEX_DMF0043_Verify.sql
--
-- 목적: DMF0043 SP 가 SELECT 하는 마스터 테이블들의 INDEX 존재 확인 (READ-ONLY)
-- 실행: SCM_MGR 또는 SCMD_APP 세션
-- 작성: 2026-06-04
--
-- 핵심 마스터 테이블 + 권장 INDEX:
--   1. DM_MST_CONTRIBUTE_RATIO_MST   : (VER_SEQ) + (DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, SOLDTO_CUST_REPORT)
--   2. DM_MST_CONTRIBUTE_RATIO_DTL   : (VER_SEQ, YYYYMM, OS_CORP_CD) + FK MST 컬럼 매칭
--   3. DM_MST_CONTRIBUTE_VER         : (VER_SEQ) — PK
--   4. SCM_MST_SITE_ITEM             : (DIVISION_ID, SCM_SITE_ID, ITEM_ID) + OWNER (REGEXP_SUBSTR fetch)
--   5. SCM_MST_SITE                  : (DIVISION_ID, SCM_SITE_ID) — PK
--   6. SCM_MST_SHEET_COLUMNS         : (PROGRAM_ID, SHEET_NAME, COLUMN_NAME) — NON-UNIQUE (DMF0043 8 dedupe 후)
--==============================================================================
SET LINESIZE 250
SET PAGESIZE 200
SET SERVEROUTPUT ON

PROMPT === DIAG 1 : 마스터 테이블 INDEX 인벤토리 (DMF0043 SELECT 대상) ===

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
     'SCM_MST_SHEET_COLUMNS',
     'SCM_MST_SSO_USER_INFO',
     'SCM_MST_SSO_DEPT_INFO'
   )
 GROUP BY i.table_name, i.index_name, i.uniqueness, i.status
 ORDER BY i.table_name, i.uniqueness DESC, i.index_name;

PROMPT === DIAG 2 : 마스터 테이블 row count (성능 영향 추정) ===

DECLARE
  v_cnt NUMBER;
  PROCEDURE rep(p_tbl VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM SCM_MGR.' || p_tbl INTO v_cnt;
    DBMS_OUTPUT.PUT_LINE(RPAD(p_tbl, 35) || ' = ' || TO_CHAR(v_cnt, 'FM999,999,999,990'));
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(RPAD(p_tbl, 35) || ' = N/A (' || SQLERRM || ')');
  END;
BEGIN
  rep('DM_MST_CONTRIBUTE_RATIO_MST');
  rep('DM_MST_CONTRIBUTE_RATIO_DTL');
  rep('DM_MST_CONTRIBUTE_VER');
  rep('SCM_MST_SITE_ITEM');
  rep('SCM_MST_SITE');
  rep('SCM_MST_SHEET_COLUMNS');
END;
/

PROMPT === DIAG 3 : SCM_MST_SHEET_COLUMNS PK uniqueness (DMF0043 dedupe 후 NON-UNIQUE 권장) ===

SELECT i.index_name, i.uniqueness, i.status, c.constraint_type,
       LISTAGG(ic.column_name, ',') WITHIN GROUP (ORDER BY ic.column_position) AS columns
  FROM all_indexes i
       LEFT JOIN all_constraints c ON c.owner = i.owner AND c.index_name = i.index_name
       JOIN all_ind_columns ic ON ic.index_owner = i.owner AND ic.index_name = i.index_name
 WHERE i.table_owner = 'SCM_MGR'
   AND i.table_name = 'SCM_MST_SHEET_COLUMNS'
 GROUP BY i.index_name, i.uniqueness, i.status, c.constraint_type
 ORDER BY i.index_name;

PROMPT === DIAG 4 : 권장 추가 INDEX (DMF0043 조회 가속 — 누락 시 CREATE) ===

PROMPT [recommend-1] DM_MST_CONTRIBUTE_RATIO_MST 조회 가속용
PROMPT     CREATE INDEX SCM_MGR.IDX_DM_RATIO_MST_VER ON SCM_MGR.DM_MST_CONTRIBUTE_RATIO_MST (VER_SEQ);

PROMPT [recommend-2] DM_MST_CONTRIBUTE_RATIO_DTL JOIN 가속용
PROMPT     CREATE INDEX SCM_MGR.IDX_DM_RATIO_DTL_VER_YYYYMM ON SCM_MGR.DM_MST_CONTRIBUTE_RATIO_DTL (VER_SEQ, YYYYMM);

PROMPT [recommend-3] SCM_MST_SITE_ITEM 조회 가속용
PROMPT     CREATE INDEX SCM_MGR.IDX_SITE_ITEM_DIV_SITE ON SCM_MGR.SCM_MST_SITE_ITEM (DIVISION_ID, SCM_SITE_ID);

PROMPT === 판독 ===
PROMPT - DIAG 1 결과에서 권장 컬럼 조합의 INDEX 없으면 (DIAG 4 의 추가 INDEX 후보 검토)
PROMPT - DIAG 2 row count 가 1M+ 이면 caller ORA-01013 timeout 의 원인 가능
PROMPT - DIAG 3 SHEET_COLUMNS PK = NON-UNIQUE 인지 확인 (DMF0043 dedupe 사고 방지)
