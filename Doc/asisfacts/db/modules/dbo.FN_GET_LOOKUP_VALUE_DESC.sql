
CREATE FUNCTION [dbo].[FN_GET_LOOKUP_VALUE_DESC]
      (
	  
	   @P_PROCEDURE_KEY   	NVARCHAR(200), -- using object (table name, xml query file, ) 
	   @P_SEQUENCE			NVARCHAR(200), -- 사용 로직 대체 값. 시퀀스 (0,1,2,3) 또는 로직 설명가능한 문자열 CUR_PLAN_COMPANY, CUR_RESULT_PLANT, STORAGE, VENDOR, CUSTOMER
       @P_LOOKUP_CODE		NVARCHAR(100), -- LOOKUP CODE
       @P_REP_CODE			NVARCHAR(100)  -- Replace CODE
       )
       RETURNS NVARCHAR(100)
       WITH EXEC AS CALLER       
AS

/*
 * Program ID   : [FN_GET_LOOKUP_VALUE_DESC]                                                              
 * Description  : 룩업코드명 리턴(오라클의 NVL 처리)
 * Program History  
 *===================================================================================================  
 *   Date       In Charge		Description  
 *===================================================================================================  
 * 2024.03.12	P.C.I			[PJ20228272] NERP 하드코딩 대응 및 개선
 ----------------------------------------------------------------------------------------------------
 */

BEGIN
  
    DECLARE @V_LOOKUP_CODE_DESC		NVARCHAR(100) = '';
    DECLARE @RET_REP_CODE			NVARCHAR(100);

   
	
	SELECT TOP 1 @V_LOOKUP_CODE_DESC = SEGMENT3
	FROM   DBO.SCM_CODE_LOOKUP_VALUE WITH(NOLOCK)
	WHERE  LOOKUP_TYPE_CODE = @P_PROCEDURE_KEY
	AND    SEGMENT1         = @P_SEQUENCE
	AND    SEGMENT2         = @P_LOOKUP_CODE
	AND    ACTIVE_FLAG      = 'Y'



	
    IF (ISNULL(@V_LOOKUP_CODE_DESC, '') = '')
        SET @RET_REP_CODE = ISNULL(@P_REP_CODE, '');
    ELSE
        SET @RET_REP_CODE = @V_LOOKUP_CODE_DESC;

    RETURN @RET_REP_CODE;


END
;
