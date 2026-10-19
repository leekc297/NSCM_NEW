
CREATE PROCEDURE [dbo].[PR_SCM_ADM_DB_SCRIPT_BACKUP]

AS

BEGIN
	SET NOCOUNT ON
/*
	DECLARE @backup_dt datetime
	SET @backup_dt = getdate()
*/
	-----------------------------------------------------------------------------------------------
	DECLARE @mmdd varchar(4)

	SET @mmdd = right(convert(varchar(8),getdate(),112),4)

/*
	if @mmdd = '0301' 
	begin
		-- Full Backup (매년 1월 1일 )
		INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
		SELECT getdate() AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
		FROM sys.objects so with(nolock), SYSCOMMENTS sc with(nolock)
		WHERE 1=1
--		AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, GETDATE()),112) and convert(varchar(8),GETDATE(),112) 
		AND so.object_id = sc.id
		AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
		AND so.name NOT LIKE 'sp_%'
		ORDER BY so.type, so.name, sc.colid
	end
	else
*/
--	begin
		-- 변경내역만 Backup
		INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
		SELECT getdate() AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
		FROM sys.objects so with(nolock), SYSCOMMENTS sc with(nolock)
		WHERE 1=1
		AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, GETDATE()),112) and convert(varchar(8),GETDATE(),112) 
		AND so.object_id = sc.id
		AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
		AND so.name NOT LIKE 'sp_%'
		ORDER BY so.type, so.name, sc.colid
--	end

/*
	-- 4주 이전 정보 삭제
	DELETE [SCM_ADM_DB_SCRIPT_BACKUP]
	WHERE  backup_dt <= DATEADD(DD, -7*4, GETDATE())
*/
	-----------------------------------------------------------------------------------------------

END

