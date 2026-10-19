
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*
 * Program ID   : DMF0049_GET_MEASURE
 * Description  :  Sales ETC Report 메저 가져오기
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/03/30	HWI1993		Initial Release -- dmf0044 에서 복사해서 생성
 * 2020/05/04	HWI1993		DIVISION_ID 를 WHERE 절에 추가
 * 2020/06/10	HWI1993		40이 아닌 경우 USD 추가
 * 2021/01/28	P.C.I		[C20210125-000207] 소형사업부 RTF_SYS_RP Measure 추가
   2022.04.25	HWI1993		GM JV 작업
*/
 CREATE PROCEDURE [dbo].[DMF0049_GET_MEASURE]
 @p_division_id	nvarchar(30)
AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	IF @p_division_id = '40' 
	BEGIN
		SELECT 
				COLUMN_NAME	AS CODE
				, COLUMN_LABEL_NAME	AS NAME
		FROM SCM_MST_SHEET_MEASURE (NOLOCK )
		WHERE  1 = 1
		AND		PROGRAM_ID  = 'DMF0049'
		AND		SHEET_NAME  = 'MDF Reports'
		AND		COLUMN_NAME IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'RTF_SYS_RP') --[C20210125-000207] 소형사업부 RTF_SYS_RP Measure 추가
		AND		patindex('%' + @p_division_id + '%', DIVISION_ID ) > 0
		ORDER BY SORT_ORDER_NO
	END
	ELSE
	BEGIN
		SELECT 
				COLUMN_NAME	AS CODE
				, COLUMN_LABEL_NAME	AS NAME
		FROM SCM_MST_SHEET_MEASURE (NOLOCK )
		WHERE  1 = 1
		AND		PROGRAM_ID  = 'DMF0049'
		AND		SHEET_NAME  = 'MDF Reports'
		AND		COLUMN_NAME IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'SalesAmt_USD')
		AND		patindex('%' + @p_division_id + '%', DIVISION_ID ) > 0
		ORDER BY SORT_ORDER_NO
	END

END

