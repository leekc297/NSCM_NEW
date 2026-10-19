
CREATE PROCEDURE [dbo].[PR_SCM_ADM_DB_SCRIPT_BACKUP_MISSING_DATE]
  @missing_date  NVARCHAR(8)
AS

-- PR_SCM_ADM_DB_SCRIPT_BACKUP_MISSING_DATE '20240310'
BEGIN
	SET NOCOUNT ON

	--select convert(varchar(8),DATEADD(DD, -1, @missing_date),112)
	--select @missing_date


--USE [Ancia]

	--declare   @missing_date  NVARCHAR(8) = '20240310'

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM Ancia.sys.objects so with(nolock), Ancia.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [CN_CELL_M_DEV]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM CN_CELL_M_DEV.sys.objects so with(nolock), CN_CELL_M_DEV.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [CN_CELL_M2_DEV]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM CN_CELL_M2_DEV.sys.objects so with(nolock), CN_CELL_M2_DEV.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [DBManager]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM DBManager.sys.objects so with(nolock), DBManager.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [ENG_SCP]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM ENG_SCP.sys.objects so with(nolock), ENG_SCP.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [ForDBTuning]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM ForDBTuning.sys.objects so with(nolock), ForDBTuning.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [ForDBTuningTest]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM ForDBTuningTest.sys.objects so with(nolock), ForDBTuningTest.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [IKEP4]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM IKEP4.sys.objects so with(nolock), IKEP4.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [KR_CELL_DEV]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM KR_CELL_DEV.sys.objects so with(nolock), KR_CELL_DEV.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [KR_FORM_DEV]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM KR_FORM_DEV.sys.objects so with(nolock), KR_FORM_DEV.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [LGCE_FPDEV]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM LGCE_FPDEV.sys.objects so with(nolock), LGCE_FPDEV.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [LGCE_FPDEV_TR]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM LGCE_FPDEV_TR.sys.objects so with(nolock), LGCE_FPDEV_TR.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [LGCE_FPDEV_TR2]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM LGCE_FPDEV_TR2.sys.objects so with(nolock), LGCE_FPDEV_TR2.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [LGCE_FPDEV2]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM LGCE_FPDEV2.sys.objects so with(nolock), LGCE_FPDEV2.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [LGCE_INFDEV]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM LGCE_INFDEV.sys.objects so with(nolock), LGCE_INFDEV.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [LGCE_LOGIDEV]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM LGCE_LOGIDEV.sys.objects so with(nolock), LGCE_LOGIDEV.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [LGCE_RTSDEV]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM LGCE_RTSDEV.sys.objects so with(nolock), LGCE_RTSDEV.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [LGCE_SCMDEV]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM LGCE_SCMDEV.sys.objects so with(nolock), LGCE_SCMDEV.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [partitionTestDB]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM partitionTestDB.sys.objects so with(nolock), partitionTestDB.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [SHERPA]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM SHERPA.sys.objects so with(nolock), SHERPA.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

--USE [sqlnexus]

--	INSERT INTO LGCE_SCMDEV.dbo.SCM_ADM_DB_SCRIPT_BACKUP
	SELECT @missing_date AS backup_dt, DB_NAME() AS fp_db_name, so.type, so.name AS script_nm, so.object_id, sc.colid, sc.text
	FROM sqlnexus.sys.objects so with(nolock), sqlnexus.sys.SYSCOMMENTS sc with(nolock)
	WHERE 1=1
	AND so.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date
	AND so.object_id = sc.id
	AND so.type IN ('FN', 'IF', 'P', 'SO', 'SN', 'TF', 'V')
	AND so.name NOT LIKE 'sp_%'
	ORDER BY so.type, so.name, sc.colid

END

/*

-- PR_SCM_ADM_DB_SCRIPT_BACKUP_MISSING_DATE '20240310'

SELECT '20240310', 

SELECT CONVERT(NVARCHAR(8), DATEADD(DD, -1, '20240310'),112)


SELECT CONVERT(NVARCHAR(8), DATEADD(DD, -1, '20240310'),112)
*/