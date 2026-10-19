

/*  
 * Program ID   : FN_GET_DIVISION_CODE
 * Description  : 40,81,82 코드 리턴
 * 실행 예제    : SELECT * FROM dbo.FN_GET_DIVISION_CODE => 40, 81, 82
 * Program History  
 *===================================================================================================  
 *Date          In Charge       Description  
 *===================================================================================================  
 *2023.03.28    chaan           V1.1.0      Initial Release PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 
 *                                                                                                    
*/  
--DROP FUNCTION [dbo].[FN_GET_DIVISION_CODE]
CREATE FUNCTION [dbo].[FN_GET_DIVISION_CODE]
(
)
RETURNS TABLE
AS
RETURN
(
    SELECT  DIVISION_ID
    FROM    dbo.SCM_MST_DIVISION WITH(NOLOCK)
    WHERE   1=1
        AND VALID_YN    = 'Y'
        AND ATTRIBUTE3 <> 'EE'
        AND ATTRIBUTE4 =  'LG'
)

