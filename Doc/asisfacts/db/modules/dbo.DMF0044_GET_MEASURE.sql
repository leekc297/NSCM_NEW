
/*
 * Program ID   : DMF0044_GET_MDF_REPORTS_DATA
 * Description  :  MDF Reports 메인 데이터 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/01/20	HWI1993		Initial Release -- COMMON 을 사용하지 않기 위해 새로 생성함. ( COMMON 의 DMF0044_MDF_MEASURE_ETC 와 동일 )
*/
CREATE PROCEDURE [dbo].[DMF0044_GET_MEASURE]
 @p_Data_Type	nvarchar(100)
AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT 
			COLUMN_NAME	AS CODE
			, COLUMN_LABEL_NAME	AS NAME
	FROM SCM_MST_SHEET_MEASURE (NOLOCK )
	WHERE  1 = 1
	AND		PROGRAM_ID  = 'DMF0044'
	AND		SHEET_NAME  = 'MDF Reports'
	AND		COLUMN_NAME IN ('SalesAmt_KRW', 'SalesAmt_LOC')
	ORDER BY SORT_ORDER_NO

END
