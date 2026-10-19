
CREATE PROCEDURE [dbo].[PR_SCM_ADM_DB_SCRIPT_COPY_TO_QA]

AS

BEGIN
	SET NOCOUNT ON

	return

	--insert into SCM_ADM_DB_SCRIPT_BACKUP_EXCUTE_HISTORY
	--SELECT 'Copy_to_QA_Server', getdate(), 'S'

/*

	insert into "10.34.222.230,1433".LGCE_INFDEV.DBO.SCM_ADM_DB_SCRIPT_BACKUP
	select * 
	from SCM_ADM_DB_SCRIPT_BACKUP with(nolock)
	where backup_dt >= convert(varchar(8),GETDATE(),112) 


	insert into "10.34.222.230,1433".LGCE_INFDEV.DBO.SCM_ADM_DB_TABLE_SCRIPT_BACKUP
	select * 
	from SCM_ADM_DB_TABLE_SCRIPT_BACKUP with(nolock)
	where backup_dt >= convert(varchar(8),GETDATE(),112) 


	insert into SCM_ADM_DB_SCRIPT_BACKUP_EXCUTE_HISTORY
	SELECT 'PR_SCM_ADM_DB_SCRIPT_COPY_TO_QA', getdate(), 'F'


	insert into "10.34.222.230,1433".LGCE_INFDEV.DBO.SCM_ADM_DB_SCRIPT_BACKUP_EXCUTE_HISTORY
	select * 
	from SCM_ADM_DB_SCRIPT_BACKUP_EXCUTE_HISTORY with(nolock)
	where backup_dt >= convert(varchar(8),GETDATE(),112) 

*/

END

