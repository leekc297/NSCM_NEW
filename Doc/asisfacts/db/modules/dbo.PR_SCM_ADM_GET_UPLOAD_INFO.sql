/*
 * Program ID   : PR_SCM_ADM_GET_UPLOAD_INFO
 * Description  : PSI UPLOAD INFO 
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2017. 12. 15    SongDH     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[PR_SCM_ADM_GET_UPLOAD_INFO]
	@p_program_id		NVARCHAR(40),
	@p_sheet_name		NVARCHAR(150)

AS

BEGIN

	SET NOCOUNT ON;
	
	SELECT * 
	FROM   [dbo].[SCM_ADM_EXCEL_COLUMNS] A WITH(NOLOCK)	
	WHERE  A.PROGRAM_ID = @p_program_id 
	AND    A.SHEET_NAME = @p_sheet_name;

END;						




