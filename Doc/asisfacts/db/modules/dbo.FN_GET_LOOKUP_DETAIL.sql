
/*
 * Program ID   : FN_GET_LOOKUP_DETAIL                                                              
 * Description  : Lookup Value 조회 
 * Program History  
 *===================================================================================================  
 *   Date       In Charge		Description  
 *===================================================================================================  
 * 2024/12/14   byunghunjung   NERP )  Lookup Value 조회 - 하드코딩 대응 및 개선
 ----------------------------------------------------------------------------------------------------
 SELECT * FROM dbo.FN_GET_LOOKUP_DETAIL('NERP_HARD_CODE_COMPANY', 'ESOC', NULL, 'ASIS')
 SELECT * FROM dbo.FN_GET_LOOKUP_DETAIL('NERP_HARD_CODE_COMPANY', 'ESOC', NULL, 'NERP')
 */
 
CREATE FUNCTION [dbo].[FN_GET_LOOKUP_DETAIL]
(	
  @p_lookup_type    NVARCHAR(200)
 ,@p_param1			NVARCHAR(200)
 ,@p_param2			NVARCHAR(200)
 ,@p_use_code       NVARCHAR(8)
)
RETURNS TABLE 
AS
RETURN 
(	
	---------------------------------------------------------
	-- COMPANY, PLANT, STORAGE
	---------------------------------------------------------
    SELECT 
		  CASE 
		  WHEN @p_use_code = 'NERP' 
		  THEN segment4 
		  ELSE segment3
		  END AS VALUE
	 FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
	 WHERE lookup_type = @p_lookup_type
	   AND segment1 = @p_param1
	   AND (@p_param2 IS NULL OR segment2 = @p_param2)
)

