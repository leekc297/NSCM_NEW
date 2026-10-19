/****************************************************************************************************/
/* Program ID  : [DMF0041_GET_MEASURE_UNIT_CURRENCY]                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/02/26  JYE          MDF Simulator Unit Currency */
/*                                                                                                  */
/****************************************************************************************************/

CREATE PROCEDURE [dbo].[DMF0041_GET_MEASURE_UNIT_CURRENCY]
AS
BEGIN
	
    SET NOCOUNT ON;
    
	SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME
	FROM [DBO].[SCM_MST_SHEET_MEASURE]
	WHERE PROGRAM_ID = 'DMF0041' and SHEET_NAME = 'MDF_Unit'
	ORDER BY SORT_ORDER_NO
END

