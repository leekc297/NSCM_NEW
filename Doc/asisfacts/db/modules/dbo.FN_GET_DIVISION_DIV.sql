

/*  
 * Program ID   : FN_GET_DIVISION_DIV
 * Description  : DIV 에 해당하는 사업부만 리턴(81, 81_*,  리턴
 * 실행 예제    : SELECT * FROM dbo.FN_GET_DIVISION_DIV('81') => 81, 81_UC, 81_HM,...
 * Program History  
 *===================================================================================================  
 *Date          In Charge       Description  
 *===================================================================================================  
 *2023.03.28    chaan           V1.1.0      Initial Release PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 
 *                                                                                                    
*/  
--DROP FUNCTION [dbo].[FN_GET_DIVISION_DIV]
CREATE FUNCTION [dbo].[FN_GET_DIVISION_DIV]
(
    @p_division_id     NVARCHAR(MAX)     = '' -- 81/40/82
)
RETURNS TABLE
AS
RETURN
(
    SELECT  DIVISION_ID
    FROM    dbo.SCM_MST_DIVISION WITH(NOLOCK)
    WHERE   1=1
        AND VALID_YN    = 'Y'
        AND ATTRIBUTE3  = @p_division_id
)

