


/*
 * Program ID   : [FN_LIST_LOOKUP_VALUE]                                                              
 * Description  : hard coding 값 반환
 * Program History  
 *===================================================================================================  
 *   Date       In Charge		Description  
 *===================================================================================================  
 * 2024/12/14   chkim.68   [PJ20228272] NERP )  Lookup Value 조회 - 하드코딩 대응 및 개선
 ----------------------------------------------------------------------------------------------------
 */
 CREATE FUNCTION [dbo].[FN_LIST_LOOKUP_VALUE]
(	
  @P_PROCEDURE_KEY   	NVARCHAR(200) -- using object (table name, xml query file, ) 
 ,@P_LOOKUP_CODE_TYPE   NVARCHAR(200) -- 사용 로직 대체 값. CUR_PLAN_COMPANY, CUR_RESULT_PLANT, STORAGE, VENDOR, CUSTOMER
)
RETURNS @RtnValue TABLE (CODE NVARCHAR(200))
AS
BEGIN
    DECLARE @V_PROCEDURE_KEY    NVARCHAR(200) = @P_PROCEDURE_KEY;
	DECLARE @V_LOOKUP_CODE_TYPE NVARCHAR(200) = @P_LOOKUP_CODE_TYPE;

	INSERT INTO @RtnValue
	SELECT SEGMENT2  AS CODE
	FROM   DBO.SCM_CODE_LOOKUP_VALUE WITH(NOLOCK)
	WHERE  LOOKUP_TYPE_CODE = @V_PROCEDURE_KEY
	AND    SEGMENT1         = @V_LOOKUP_CODE_TYPE
	AND    ACTIVE_FLAG      = 'Y'

RETURN 
END;

