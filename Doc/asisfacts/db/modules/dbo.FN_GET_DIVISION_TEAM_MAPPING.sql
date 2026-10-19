

/*  
 * Program ID   : FN_GET_DIVISION                                                               
 * Description  : SITE/OWNER 기준 별 Team Mapping 사업부를 조회하는 함수
 * 실행 예제    : DIVISION_ID IN (SELECT CODE FROM DBO.FN_GET_DIVISION_TEAM_MAPPING('OWNER'))
 * Program History  
 *===================================================================================================  
 * Date          In Charge       Description  
 *===================================================================================================  
 * 2024.08.01    P.C.I           [prepare] Team Mapping 기준 변경
 *                                                                                                    
*/  

 CREATE FUNCTION [DBO].[FN_GET_DIVISION_TEAM_MAPPING]
(	
  @P_VALUE   	NVARCHAR(200) -- Team Mapping 기준(SITE/OWNER)
)
RETURNS @RtnValue TABLE (CODE NVARCHAR(200))
AS
BEGIN
    DECLARE @V_VALUE    NVARCHAR(200) = @P_VALUE;

	INSERT INTO @RtnValue
	SELECT SEGMENT1  AS CODE
	FROM   DBO.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
	WHERE  LOOKUP_TYPE = 'DIVISION_TEAM_MAPPING'
	AND    VALID_YN = 'Y'
	AND    SEGMENT2 = @P_VALUE

RETURN 
END;

