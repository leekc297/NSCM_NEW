SET LINESIZE 500
PROMPT === full MERGE INSERT (line 280~310) ===
SELECT line, '|' || text || '|' AS line_text
  FROM user_source
 WHERE name = 'DMF0043_SAVE_DM_MST_CONTRIBUTE_VER'
   AND type = 'PROCEDURE'
   AND line BETWEEN 278 AND 310
 ORDER BY line;

PROMPT === DM_MST_CONTRIBUTE_VER 의 모든 column + NOT NULL ===
SELECT column_id, column_name, data_type, nullable, data_default
  FROM all_tab_columns
 WHERE owner = 'SCM_MGR' AND table_name = 'DM_MST_CONTRIBUTE_VER'
 ORDER BY column_id;
