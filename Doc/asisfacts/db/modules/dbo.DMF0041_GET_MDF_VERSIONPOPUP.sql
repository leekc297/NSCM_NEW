/****************************************************************************************************/
/* Program ID  : DMF0041_GET_MDF_VERSIONPOPUP                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/02/19  JYE       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/

CREATE PROCEDURE [dbo].[DMF0041_GET_MDF_VERSIONPOPUP]
    @p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8),
	@p_created_by	   NVARCHAR(50),
	@p_division_id	   NVARCHAR(MAX),
	@p_version_type	   NVARCHAR(MAX),
	@p_version_no	   NVARCHAR(MAX)
AS
BEGIN
	
    SET NOCOUNT ON;

	   SELECT DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, MAX(CREATED_BY) CREATED_BY, MAX(CREATION_DATE) CREATION_DATE
		 FROM [dbo].[DM_MST_VERSION]  WITH(NOLOCK)
	   WHERE (YYYYMMDD >= @p_start_yyyymmdd and YYYYMMDD <= @p_end_yyyymmdd)  
		  AND DIVISION_ID IN (SELECT token FROM dbo.String_Split(@p_division_id	,','))  		
		  AND VERSION_TYPE IN (SELECT token FROM dbo.String_Split(@p_version_type	,','))    
		  AND Exists (Select * from dbo.UF_FX_String_Split (@p_version_no,',') as P Where [VERSION_NO] LIKE P.token +'%')
	   GROUP BY DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD
	   ORDER BY VERSION_NO DESC
END
