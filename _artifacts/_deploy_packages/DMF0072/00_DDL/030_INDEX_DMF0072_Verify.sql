--==============================================================================
-- 030_INDEX_DMF0072_Verify.sql
--==============================================================================
SET LINESIZE 250
SET SERVEROUTPUT ON

PROMPT === DIAG 1 : DMF0072 마스터 테이블 INDEX ===

SELECT i.table_name, i.index_name, i.uniqueness, i.status,
       LISTAGG(c.column_name, ',') WITHIN GROUP (ORDER BY c.column_position) AS columns
  FROM all_indexes i
       JOIN all_ind_columns c ON c.index_owner = i.owner
                              AND c.index_name = i.index_name
                              AND c.table_owner = i.table_owner
                              AND c.table_name = i.table_name
 WHERE i.table_owner = 'SCM_MGR'
   AND i.table_name IN (
     'SCM_MST_SITE_ITEM', 'SCM_MST_SITE',
     'DM_MST_PROJECT', 'DM_MST_ITEM',
     'SCM_MST_SSO_USER_INFO', 'SCM_MST_SSO_DEPT_INFO',
     'SCM_ADM_CMBO_SQL_M'
   )
 GROUP BY i.table_name, i.index_name, i.uniqueness, i.status
 ORDER BY i.table_name, i.uniqueness DESC, i.index_name;
