
CREATE PROCEDURE [dbo].[PR_SCM_ADM_DB_TABLE_SCRIPT_BACKUP_missing_date]
  @missing_date  NVARCHAR(8)
AS
-- PR_SCM_ADM_DB_TABLE_SCRIPT_BACKUP_missing_date '20240310'

BEGIN
	SET NOCOUNT ON

--USE [Ancia]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM Ancia.SYS.OBJECTS O WITH (NOLOCK)
	JOIN Ancia.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [CN_CELL_M_DEV]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM CN_CELL_M_DEV.SYS.OBJECTS O WITH (NOLOCK)
	JOIN CN_CELL_M_DEV.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [CN_CELL_M2_DEV]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM CN_CELL_M2_DEV.SYS.OBJECTS O WITH (NOLOCK)
	JOIN CN_CELL_M2_DEV.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [DBManager]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM DBManager.SYS.OBJECTS O WITH (NOLOCK)
	JOIN DBManager.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [ENG_SCP]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM ENG_SCP.SYS.OBJECTS O WITH (NOLOCK)
	JOIN ENG_SCP.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [ForDBTuning]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM ForDBTuning.SYS.OBJECTS O WITH (NOLOCK)
	JOIN ForDBTuning.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [ForDBTuningTest]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM ForDBTuningTest.SYS.OBJECTS O WITH (NOLOCK)
	JOIN ForDBTuningTest.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [IKEP4]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM IKEP4.SYS.OBJECTS O WITH (NOLOCK)
	JOIN IKEP4.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [KR_CELL_DEV]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM KR_CELL_DEV.SYS.OBJECTS O WITH (NOLOCK)
	JOIN KR_CELL_DEV.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [KR_FORM_DEV]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM KR_FORM_DEV.SYS.OBJECTS O WITH (NOLOCK)
	JOIN KR_FORM_DEV.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [LGCE_FPDEV]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM LGCE_FPDEV.SYS.OBJECTS O WITH (NOLOCK)
	JOIN LGCE_FPDEV.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [LGCE_FPDEV_TR]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM LGCE_FPDEV_TR.SYS.OBJECTS O WITH (NOLOCK)
	JOIN LGCE_FPDEV_TR.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [LGCE_FPDEV_TR2]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM LGCE_FPDEV_TR2.SYS.OBJECTS O WITH (NOLOCK)
	JOIN LGCE_FPDEV_TR2.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [LGCE_FPDEV2]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM LGCE_FPDEV2.SYS.OBJECTS O WITH (NOLOCK)
	JOIN LGCE_FPDEV2.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [LGCE_INFDEV]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM LGCE_INFDEV.SYS.OBJECTS O WITH (NOLOCK)
	JOIN LGCE_INFDEV.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [LGCE_LOGIDEV]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM LGCE_LOGIDEV.SYS.OBJECTS O WITH (NOLOCK)
	JOIN LGCE_LOGIDEV.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [LGCE_RTSDEV]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM LGCE_RTSDEV.SYS.OBJECTS O WITH (NOLOCK)
	JOIN LGCE_RTSDEV.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [LGCE_SCMDEV]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM LGCE_SCMDEV.SYS.OBJECTS O WITH (NOLOCK)
	JOIN LGCE_SCMDEV.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [partitionTestDB]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM partitionTestDB.SYS.OBJECTS O WITH (NOLOCK)
	JOIN partitionTestDB.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [SHERPA]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM SHERPA.SYS.OBJECTS O WITH (NOLOCK)
	JOIN SHERPA.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date

--USE [sqlnexus]
	SELECT S.NAME + '.' + O.NAME,
			'[' + S.NAME + '].[' + O.NAME + ']',
			O.[OBJECT_ID]
	FROM sqlnexus.SYS.OBJECTS O WITH (NOLOCK)
	JOIN sqlnexus.SYS.SCHEMAS S WITH (NOLOCK) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
	WHERE O.[TYPE] = 'U'
	AND O.IS_MS_SHIPPED = 0
	AND o.modify_date between convert(varchar(8),DATEADD(DD, -1, @missing_date),112) and @missing_date




END


