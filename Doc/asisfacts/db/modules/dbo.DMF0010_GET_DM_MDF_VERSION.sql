
/*
 * Program ID   : DMF0010_GET_DM_MDF_VERSION
 * Description  :DMF0010_BizPlanPrice(메탈 판가 등록 화면)의 Cut-Off 내역 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/08/03	ilovu1			Initial Release 사업계획 프로젝트
 */
 --EXEC [dbo].[DMF0010_GET_DM_MDF_VERSION] 'ALL',   '', 'BP_M', '20200101', '20231231', 'ilovu1'
 --EXEC [dbo].[DMF0010_GET_DM_MDF_VERSION] '81,40', '', 'BP_M', '20230101', '20231231', 'ilovu1'
 --EXEC [dbo].[DMF0010_GET_DM_MDF_VERSION] '81',    '', 'BP_M', '20230101', '20231231', 'ilovu1'
 --EXEC [dbo].[DMF0010_GET_DM_MDF_VERSION] '40',    '', 'BP_M', '20230101', '20231231', 'ilovu1'
CREATE PROCEDURE [dbo].[DMF0010_GET_DM_MDF_VERSION]    
      @p_DIVISION_ID              NVARCHAR(MAX)
	, @p_VERSION_DESCRIPTION      NVARCHAR(MAX)
	, @p_VERSION_TYPE			  NVARCHAR(MAX)
	, @p_START_YYYYMMDD           NVARCHAR(MAX)
	, @p_END_YYYYMMDD             NVARCHAR(MAX)
	, @p_CREATED_BY				  NVARCHAR(MAX)
AS  
BEGIN
	SET NOCOUNT ON;

	DECLARE @v_TABLE TABLE (DIVISION_ID NVARCHAR(30));
	INSERT
	  INTO @v_TABLE
    SELECT [Data]
	  FROM dbo.UF_FX_String_SplitForIN (@p_DIVISION_ID,',')
     WHERE @p_DIVISION_ID <> 'ALL';

	SELECT 
		   [DIVISION_ID]
		 , [VERSION_NO]
		 , [VERSION_DESCRIPTION]
		 , [VERSION_TYPE]
		 , [YYYYMMDD]
		 , [VER_CRE_SEQ]
		 , [CREATED_BY]
		 , [CREATION_DATE]
		 , [LAST_UPDATED_BY]
		 , [LAST_UPDATE_DATE]      
	  FROM [dbo].[DM_MST_VERSION] V WITH (NOLOCK)
	 WHERE YYYYMMDD              BETWEEN @p_START_YYYYMMDD AND @p_END_YYYYMMDD
	   AND EXISTS (SELECT 1 
	                 FROM @v_TABLE S 
					WHERE @p_DIVISION_ID <> 'ALL'
					  AND S.DIVISION_ID = V.DIVISION_ID 
				    UNION ALL
				   SELECT 1	
				    WHERE @p_DIVISION_ID =  'ALL'
				  )
	   AND [VERSION_TYPE]        =  @p_VERSION_TYPE
	   AND [VERSION_DESCRIPTION] LIKE @p_VERSION_DESCRIPTION + '%'
	 ORDER BY 
		   [DIVISION_ID]
		 , [VERSION_NO] DESC;

END;
