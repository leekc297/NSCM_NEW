
/*
 **************************************************************************************************
 * Program ID  :  [DMF0043_GET_CONTRIBUTE_RATE_POPUP]
 * Description : DMF0043 > 기여율 관리 팝업
 * Usage       : Procedure 작성 시 참조하세요!                                                      
 * Parameter   :                                                                                    
 *                                                                                                  
 *--------------------------------------------------------------------------------------------------
 * Date        In Charge    Description                                                             
 *--------------------------------------------------------------------------------------------------
 * 2019/05/09  JYE       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 **************************************************************************************************
*/
CREATE PROC [dbo].[DMF0043_GET_CONTRIBUTE_RATE_POPUP]
(
	@p_yyyy              NVARCHAR(10)
)
AS
BEGIN
	SELECT 
		VER_SEQ
		,YYYY
		,VERSION_NM
		,DESCRIPTION
		,VALID_YN
	FROM [dbo].[DM_MST_CONTRIBUTE_VER]
	WHERE YYYY = CASE WHEN @p_yyyy IS NULL OR @p_yyyy = 'ALL' THEN YYYY ELSE @p_yyyy END
    ORDER BY YYYY DESC
END
