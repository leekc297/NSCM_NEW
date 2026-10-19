

CREATE FUNCTION [dbo].[NERP_FN_GET_SSP_JV_DIVISION_ID]
(
	@p_division_id		nvarchar(MAX),
	@p_plant_id			nvarchar(MAX)
)

RETURNS nvarchar(MAX)
WITH EXEC AS CALLER
AS
/****************************************************************************
  * FUNCTION NAME : [FN_GET_SSP_JV_DIVISION_ID]
  * DESCRIPTION   : JV DIVISION 정보 
  * INPUT         : @p_division_id	: 소속 DIVISION (SCM_MST_DIVISION.attribute3 참조)
					@p_plant_id		: PLANT_ID
					@r_division_id  : JV DIVISION_ID
  * USAGE         : SELECT DBO.[FN_GET_SSP_JV_DIVISION_ID]('81', 'G671')
			        
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE			IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2022.04.01		SSP Pjt.			Create.
  ****************************************************************************/
BEGIN

	DECLARE @r_division_id    NVARCHAR(30) ;


	SELECT TOP 1
		   @r_division_id		= MS.DIVISION_ID     
	  FROM [10.34.222.230,1433].[LGCE_SCMDEV].[DBO].SCM_MST_SITE	AS MS WITH(NOLOCK) 
		   JOIN SCM_MST_DIVISION AS MD WITH(NOLOCK)
		ON MS.DIVISION_ID = MD.DIVISION_ID
	 WHERE 1 = 1
	   AND MS.PLANT_ID			= @p_plant_id
	   AND MS.VALID_YN			= 'Y' 
	   AND MS.SITE_TYPE			= 'PLANT'
	   and MD.ATTRIBUTE3		= @p_division_id

	IF @r_division_id IS NULL
		SET @r_division_id		= @p_division_id;

	RETURN @r_division_id;
END
