
CREATE PROCEDURE [dbo].[PR_SCM_ADM_DB_SCRIPT_PURGE]

AS

BEGIN

	RETURN  -- 임시로 막음. 2025년 1월 1일날 NERP 프로젝트로 인해 RETURN 한줄 입력함.

/*
	SET NOCOUNT ON

		DECLARE @mmdd varchar(4)

		SET @mmdd = right(convert(varchar(8),getdate(),112),4)

		if @mmdd = '0110' 
		begin
			insert into SCM_ADM_DB_SCRIPT_BACKUP_EXCUTE_HISTORY
			SELECT 'QA Last Year Data Delete', getdate(), 'S'

				DELETE FROM "10.34.222.230,1433".LGCE_INFDEV.DBO.SCM_ADM_DB_SCRIPT_BACKUP
				WHERE BACKUP_DT < left(convert(varchar(8),getdate(),112),4) + '0101'

				DELETE FROM "10.34.222.230,1433".LGCE_INFDEV.DBO.SCM_ADM_DB_TABLE_SCRIPT_BACKUP
				WHERE BACKUP_DT < left(convert(varchar(8),getdate(),112),4) + '0101'

			insert into SCM_ADM_DB_SCRIPT_BACKUP_EXCUTE_HISTORY
			SELECT 'QA Last Year Data Delete', getdate(), 'E'
		end 

		if @mmdd = '0120' 
		begin
			insert into SCM_ADM_DB_SCRIPT_BACKUP_EXCUTE_HISTORY
			SELECT 'DEV Last Year Data Delete', getdate(), 'S'

				DELETE FROM SCM_ADM_DB_SCRIPT_BACKUP
				WHERE BACKUP_DT < left(convert(varchar(8),getdate(),112),4) + '0101'

				DELETE FROM SCM_ADM_DB_TABLE_SCRIPT_BACKUP
				WHERE BACKUP_DT < left(convert(varchar(8),getdate(),112),4) + '0101'

			insert into SCM_ADM_DB_SCRIPT_BACKUP_EXCUTE_HISTORY
			SELECT 'DEV Last Year Data Delete', getdate(), 'E'
		end 
*/

END

