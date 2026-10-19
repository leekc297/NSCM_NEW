
/*
 * Program ID   : PR_SCM_ADM_SAVE_UPLOAD_DATA
 * Description  : PSI UPLOAD DATA  
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2017. 12. 15    SongDH     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[PR_SCM_ADM_SAVE_UPLOAD_DATA]
	@p_program_id		NVARCHAR(40),
	@p_sheet_name		NVARCHAR(150),
	@p_created_by		NVARCHAR(150) 
AS

BEGIN

	SET NOCOUNT ON;
	DECLARE @v_sql_text      AS NVARCHAR(MAX);

	SET @v_sql_text = '';

	SET @v_sql_text = 
	(
		SELECT Z.OK
		FROM   (SELECT A.STORAGE_SQL_ID AS OK
					--A.STORAGE_SQL_ID + '(0.' + @v_created_by +')' AS OK
				FROM [dbo].[SCM_ADM_EXCEL_COLUMNS] A   WITH(NOLOCK)
				WHERE 1 = 1
				AND  A.PROGRAM_ID = @p_program_id
				AND  A.SHEET_NAME = @p_sheet_name
	           ) Z
	)
	;

	EXEC @v_sql_text '1', @p_created_by  ;
	--EXEC SP_EXECUTESQL @v_sql_text;

  END;		

