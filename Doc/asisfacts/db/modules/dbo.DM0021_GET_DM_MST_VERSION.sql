/****************************************************************************************************/
/* Program ID  : [DMF0006_GET_CUSTOMERMODELMAPPING]                                                           */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DM0021_GET_DM_MST_VERSION]    
    @p_division_id              NVARCHAR(MAX),	
	@p_version_description      NVARCHAR(MAX),
	@p_version_type			    NVARCHAR(MAX),
	@p_from_yyyymmdd            NVARCHAR(MAX),
	@p_to_yyyymmdd              NVARCHAR(MAX),
	@p_created_by				NVARCHAR(MAX)
 
AS  
  -- DM0020_GET_SCM_MST_FUTURE_PRICE '', '', '', '', '', ''
BEGIN
  SET NOCOUNT ON;

 SELECT 
		[DIVISION_ID]
      ,[VERSION_NO]
      ,[VERSION_DESCRIPTION]
      ,[VERSION_TYPE]
      ,[YYYYMMDD]
      ,[VER_CRE_SEQ]
      ,[CREATED_BY]
      ,[CREATION_DATE]
      ,[LAST_UPDATED_BY]
      ,[LAST_UPDATE_DATE]      
  FROM [dbo].[DM_MST_VERSION] WITH(NOLOCK)
  WHERE (YYYYMMDD >= @p_from_yyyymmdd and YYYYMMDD <= @p_to_yyyymmdd)
		AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   		 ELSE DIVISION_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_division_id,',') as P Where 
					(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE DIVISION_ID END) = P.data
	               )
		AND [VERSION_TYPE] like @p_version_type + '%'
		AND [VERSION_DESCRIPTION] like @p_version_description + '%'
	
  ORDER BY [DIVISION_ID], [VERSION_NO] DESC

END

