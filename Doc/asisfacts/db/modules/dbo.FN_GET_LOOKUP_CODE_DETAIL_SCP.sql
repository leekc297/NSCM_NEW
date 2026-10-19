
/*
 * Program ID   : FN_GET_LOOKUP_CODE_DETAIL                                                              
 * Description  : Lookup Value 조회 
 * Program History  
 *===================================================================================================  
 *   Date       In Charge		Description  
 *===================================================================================================  
 * 2024/02/01   vadabi5   NERP )  Lookup Value 조회 - 하드코딩 대응 및 개선
 * 2024/03/14   vadabi5   NERP )  파라미터 정리
 ----------------------------------------------------------------------------------------------------
 -- p_lookup_type	: Company, Plant, storag
 -- p_param1		: KEY1
 -- p_param2		: KEY2
 -- segment3		: CODE ASIS
 -- segment4		: CODE TOBE
  ----------------------------------------------------------------------------------------------------
 SELECT dbo.FN_GET_LOOKUP_CODE_DETAIL('NERP_HARD_CODE_COMPANY', 'ESOC', NULL, 'ASIS')  
 SELECT dbo.FN_GET_LOOKUP_CODE_DETAIL('NERP_HARD_CODE_COMPANY', 'ESOC', NULL, 'NERP')  
 SELECT dbo.FN_GET_LOOKUP_CODE_DETAIL_SCP('NERP_HARD_CODE_COMPANY', 'ESOC', NULL)  
 */

CREATE FUNCTION [dbo].[FN_GET_LOOKUP_CODE_DETAIL_SCP]
      (
	  @p_lookup_type    NVARCHAR(200)
	 ,@p_param1			NVARCHAR(200)
	 ,@p_param2			NVARCHAR(200) = NULL
      )
       RETURNS NVARCHAR(100)
       WITH EXEC AS CALLER       
AS


BEGIN
  
   DECLARE @X_LOOKUP_CODE_DESC NVARCHAR(100)='';


   SELECT TOP 1 
	      @X_LOOKUP_CODE_DESC = segment4
	 FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
	WHERE lookup_type	= @p_lookup_type
	  AND segment1		= @p_param1
	  AND (@p_param2 IS NULL OR segment2 = @p_param2)
	  AND VALID_YN		= 'Y'   
	
   RETURN  @X_LOOKUP_CODE_DESC;

END
;
