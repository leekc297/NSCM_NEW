
/****************************************************************************************************/
/* Program ID  : [[DMF0043_GET_MAIN_VARSION_DATA]]                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/07/18     JYE		기여율 등록화면 Version 바인딩 데이터                    */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0043_GET_MAIN_VARSION_DATA]
AS
BEGIN
	
    SET NOCOUNT ON; 
	SELECT 
		VER_SEQ AS CODE
		,VERSION_NM AS NAME
		,[VER_SEQ]
		,[YYYY]
		,[VERSION_NM]
		,[DESCRIPTION]
		,[YYYY] + '(' + [VERSION_NM] + ')' AS NAME2
	FROM [dbo].[DM_MST_CONTRIBUTE_VER]
	WHERE VALID_YN = 'Y'
    ORDER BY YYYY DESC
END
