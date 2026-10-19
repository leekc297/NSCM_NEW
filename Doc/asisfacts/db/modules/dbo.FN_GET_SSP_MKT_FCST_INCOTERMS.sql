
CREATE FUNCTION [dbo].[FN_GET_SSP_MKT_FCST_INCOTERMS]
(
  @p_division_id     NVARCHAR(30),
  @p_from_site       NVARCHAR(30),
  @p_to_site         NVARCHAR(30),
  @p_item_id         NVARCHAR(50),
  @p_project_code    NVARCHAR(50),
  @p_fcst_type       NVARCHAR(20),
  @p_yyyymmdd        NVARCHAR(20)
)

RETURNS NVARCHAR(100)
AS
/*
 * Program ID   : [FN_GET_SSP_MKT_FCST_INCOTERMS]
 * Description  : Sales Site가 VMI인 경우 MKT FCST 에 입력된 INCOTERMS를 ERP에 I/F (SO Suggestion)   
 *        
 *        
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.07.09   juhlee     Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트

 */
BEGIN
  
  DECLARE @v_incoterms NVARCHAR(100)
  

	SELECT top 1 @v_incoterms = INCOTERMS
	FROM  DM_PLN_MKT_FCST WITH(NOLOCK) 
	WHERE MEASURE       = 'MKT_FCST'
	AND   DIVISION_ID   = @p_division_id
	AND   PLANT_SITE_ID = @p_from_site    
	AND   SCM_SITE_ID   = @p_to_site     
	AND   ITEM_ID       = @p_item_id     
	AND   PROJECT_CODE  = @p_project_code
	AND   FCST_TYPE     = @p_fcst_type   
	AND   YYYYMMDD     >= @p_yyyymmdd   
	ORDER BY YYYYMMDD



  IF @v_incoterms IS NULL 
   
		SELECT top 1 @v_incoterms = INCOTERMS
		FROM  DM_PLN_MKT_FCST WITH(NOLOCK) 
		WHERE MEASURE       = 'MKT_FCST'
		AND   DIVISION_ID   = @p_division_id
		AND   PLANT_SITE_ID = @p_from_site   
		AND   SCM_SITE_ID   = @p_to_site    
		--AND   ITEM_ID       = @p_item_id    
		--AND   PROJECT_CODE  = @p_project_code 
		--AND   FCST_TYPE     = @p_fcst_type    
		--AND   YYYYMMDD     >= @p_yyyymmdd    
		ORDER BY YYYYMMDD

	
  RETURN @v_incoterms;

END
;
