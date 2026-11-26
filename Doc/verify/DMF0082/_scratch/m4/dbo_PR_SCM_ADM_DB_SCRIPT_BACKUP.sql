CREATE   PROCEDURE [dbo].[PR_SCM_ADM_DB_SCRIPT_BACKUP]

AS

BEGIN
	SET NOCOUNT ON

	DECLARE @backup_dt datetime

	SET @backup_dt = getdate()

	-----------------------------------------------------------------------------------------------

	INSERT INTO [SCM_ADM_DB_SCRPIT_BACKUP]
	SELECT getdate() AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM sys.objects so with(nolock), SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.object_id = sc.id
	AND so.type IN ('P', 'FN', 'V', 'SO', 'SN')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

	-----------------------------------------------------------------------------------------------

END