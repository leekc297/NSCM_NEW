/* 05_BACKUP — 클라우드 현재 원문 보관 (있으면 건너뜀). 롤백 98 이 읽는다 */
DECLARE n NUMBER; BEGIN
  SELECT COUNT(*) INTO n FROM all_tables WHERE owner = 'SCM_MGR' AND table_name = 'BAK_SRC_WR_DATEVAR';
  IF n = 0 THEN EXECUTE IMMEDIATE 'CREATE TABLE SCM_MGR.BAK_SRC_WR_DATEVAR AS SELECT name, type, line, text, SYSDATE AS bak_dt FROM all_source WHERE owner = ''SCM_MGR'' AND name = ''PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING'' AND type = ''PROCEDURE'''; END IF;
END;
/
SELECT COUNT(*) AS backed_lines, MAX(bak_dt) FROM SCM_MGR.BAK_SRC_WR_DATEVAR;
