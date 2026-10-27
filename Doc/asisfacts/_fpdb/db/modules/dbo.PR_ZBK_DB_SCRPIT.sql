



CREATE PROCEDURE [dbo].[PR_ZBK_DB_SCRPIT]

AS

BEGIN
	SET NOCOUNT ON

	DECLARE @backup_dt datetime

	SET @backup_dt = getdate()

	-----------------------------------------------------------------------------------------------

	INSERT INTO [ZFP_DB_SCRPIT_BACKUP]
	SELECT @backup_dt AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM sys.objects so with(nolock), SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.object_id = sc.id
	AND so.type IN ('P', 'FN')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

	-----------------------------------------------------------------------------------------------

	INSERT INTO [ZFP_DB_SCRPIT_BACKUP]
	SELECT @backup_dt AS backup_dt, 'LGCE_FP' AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM LGCE_FP.sys.objects so with(nolock), LGCE_FP.sys.syscomments sc with(nolock)
	WHERE 1=1
	AND so.object_id = sc.id
	AND so.type IN ('P', 'FN')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

	-----------------------------------------------------------------------------------------------

END





