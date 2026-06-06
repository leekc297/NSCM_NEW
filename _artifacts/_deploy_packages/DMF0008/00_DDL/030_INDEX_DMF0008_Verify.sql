--==============================================================================
-- 030_INDEX_DMF0008_Verify.sql
--
-- 목적: DMF0008 SELECT 대상 테이블 INDEX 확인 (READ-ONLY)
-- 작성: 2026-06-05
--==============================================================================
SET LINESIZE 250
SET PAGESIZE 200
SET SERVEROUTPUT ON

PROMPT === DIAG 1 : DMF0008 마스터 테이블 INDEX 인벤토리 ===

SELECT i.table_name, i.index_name, i.uniqueness, i.status,
       LISTAGG(c.column_name, ',') WITHIN GROUP (ORDER BY c.column_position) AS columns
  FROM all_indexes i
       JOIN all_ind_columns c ON c.index_owner = i.owner
                              AND c.index_name = i.index_name
                              AND c.table_owner = i.table_owner
                              AND c.table_name = i.table_name
 WHERE i.table_owner = 'SCM_MGR'
   AND i.table_name IN (
     'DM_DNM_EDI_REPAIR',
     'DM_DNM_EDI_SUMMARY',
     'SCM_MST_SALES_SITE',
     'SCM_MST_SITE_ITEM',
     'SCM_MST_SITE',
     'SCM_ADM_SYS_LOG'
   )
 GROUP BY i.table_name, i.index_name, i.uniqueness, i.status
 ORDER BY i.table_name, i.uniqueness DESC, i.index_name;

PROMPT === DIAG 2 : 마스터 row count ===

DECLARE
  v_cnt NUMBER;
  PROCEDURE rep(p_tbl VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM SCM_MGR.' || p_tbl INTO v_cnt;
    DBMS_OUTPUT.PUT_LINE(RPAD(p_tbl, 35) || ' = ' || TO_CHAR(v_cnt, 'FM999,999,999,990'));
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(RPAD(p_tbl, 35) || ' = N/A (' || SUBSTR(SQLERRM, 1, 50) || ')');
  END;
BEGIN
  rep('DM_DNM_EDI_REPAIR');
  rep('DM_DNM_EDI_SUMMARY');
  rep('SCM_MST_SALES_SITE');
  rep('SCM_MST_SITE_ITEM');
END;
/
