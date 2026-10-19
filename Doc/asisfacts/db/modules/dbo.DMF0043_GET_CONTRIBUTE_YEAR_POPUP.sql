
/*
 **************************************************************************************************
 * Program ID  :  [[DMF0043_GET_CONTRIBUTE_YEAR_POPUP]]
 * Description : DMF0043 > 검색 연도
 * Usage       : Procedure 작성 시 참조하세요!                                                      
 * Parameter   :                                                                                    
 *                                                                                                  
 *--------------------------------------------------------------------------------------------------
 * Date        In Charge    Description                                                             
 *--------------------------------------------------------------------------------------------------
 * 2019/05/09  JYE       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 **************************************************************************************************
*/
CREATE PROC [dbo].[DMF0043_GET_CONTRIBUTE_YEAR_POPUP]
AS
BEGIN

	SELECT CODE, NAME FROM
	(
		SELECT 
			'ALL' AS CODE
			,'ALL' AS NAME
			,0 AS SORTORDER
		UNION ALL

		SELECT 
			YYYY AS CODE
			,YYYY AS NAME
			,ROW_NUMBER() OVER (ORDER BY YYYY) SORTORDER
		FROM [dbo].[DM_MST_CONTRIBUTE_VER]
		GROUP BY YYYY
	) AS MA
	ORDER BY SORTORDER

END


