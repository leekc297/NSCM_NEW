



/*
 * Program ID   : [FN_LIST_LOOKUP_VALUE]                                                              
 * Description  : hard coding 값 반환
 * Program History  
 *===================================================================================================  
 *   Date       In Charge		Description  
 *===================================================================================================  
 * 2024/03/01   chkim.68   [PJ20228272] NERP )  Lookup Value 조회 - 하드코딩 대응 및 개선
 * 2024/03/01   kimcd    COMPANY_ID 등 참고 코드 제외
 ----------------------------------------------------------------------------------------------------
 */
 CREATE FUNCTION [dbo].[FN_GET_LOOKUP_VALUE]
(	
  @P_PROCEDURE_KEY   	NVARCHAR(200) -- using object (table name, xml query file, ) 
 ,@P_SEQUENCE   NVARCHAR(200) -- 사용 로직 대체 값. 시퀀스 (0,1,2,3) 또는 로직 설명가능한 문자열 CUR_PLAN_COMPANY, CUR_RESULT_PLANT, STORAGE, VENDOR, CUSTOMER
)
  RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @RtnValue NVARCHAR(100)='';
    DECLARE @V_PROCEDURE_KEY    NVARCHAR(200) = @P_PROCEDURE_KEY;
	DECLARE @V_SEQUENCE NVARCHAR(200) = @P_SEQUENCE;


	SELECT @RtnValue = SEGMENT2
	FROM   DBO.SCM_CODE_LOOKUP_VALUE WITH(NOLOCK)
	WHERE  LOOKUP_TYPE_CODE = @V_PROCEDURE_KEY
	AND    SEGMENT1         = @V_SEQUENCE
	AND    ACTIVE_FLAG      = 'Y'

RETURN @RtnValue
END;

