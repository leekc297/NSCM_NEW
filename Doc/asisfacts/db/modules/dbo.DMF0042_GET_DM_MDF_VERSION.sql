
/****************************************************************************************************/
/* Program ID  : [DMF0042_GET_DM_MDF_VERSION]                                                           */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/06/10  JYE			Business Plan > Cut Off 팝업 조회 */
/* 2021/07/03	HWI1993		하반기과제 속도개선 - 데이터 이동보관 처리                                                                                                 */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0042_GET_DM_MDF_VERSION]    
    @p_division_id              NVARCHAR(MAX),	
	@p_version_description      NVARCHAR(MAX),
	@p_version_type			    NVARCHAR(MAX),
	@p_from_yyyymmdd            NVARCHAR(MAX),
	@p_to_yyyymmdd              NVARCHAR(MAX),
	@p_created_by				NVARCHAR(MAX)
 
AS  
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
		AND ISNULL(ATTRIBUTE1,'') <> 'MOVE'

	
  ORDER BY [DIVISION_ID], [VERSION_NO] DESC

END


