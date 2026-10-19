/****************************************************************************************************/
/* Program ID  : [DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP]                                           */
/* Description : Procedure 작성 가이드                                                               */
/* Usage       : Procedure 작성 시 참조하세요!                                                       */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2019/04/10  JYE            Business Plan 추가														*/
/* 2022/10/24	ROSIA27				[C20221024-000510]DM UI 소스 정리 요청							*/
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP]    
    @p_division_id					NVARCHAR(30),	
	@p_from_yyyymmdd				NVARCHAR(8),
	@p_to_yyyymmdd					NVARCHAR(8),
	@p_created_by					NVARCHAR(MAX),
	@p_cate							NVARCHAR(8)
AS  
  
BEGIN
	SET NOCOUNT ON;

	IF (@p_cate = 'BP')
	BEGIN
		SELECT 
			DIVISION_ID
			,[CURRENCY]
			,[UNIT_CURRENCY]
			,[CURRENCY] + '/' + [UNIT_CURRENCY] AS CURRENCY_UNITCURRENCY
		FROM [dbo].[DM_BP_EXCHANGE_RATE]
		WHERE 
		(YYYYMMDD >= @p_from_yyyymmdd and YYYYMMDD <= @p_to_yyyymmdd)
		AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   				ELSE DIVISION_ID			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_division_id,',') as P Where 
						(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE DIVISION_ID END) = P.data
						)
		GROUP BY DIVISION_ID,[CURRENCY], [UNIT_CURRENCY]
	END
	ELSE
	BEGIN
		SELECT 
			DIVISION_ID
			,[CURRENCY]
			,[UNIT_CURRENCY]
			,[CURRENCY] + '/' + [UNIT_CURRENCY] AS CURRENCY_UNITCURRENCY
		FROM [dbo].[DM_MST_EXCHANGE_RATE]
		WHERE 
		(YYYYMMDD >= @p_from_yyyymmdd and YYYYMMDD <= @p_to_yyyymmdd)
		AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   				ELSE DIVISION_ID			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_division_id,',') as P Where 
						(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE DIVISION_ID END) = P.data
						)
		GROUP BY DIVISION_ID,[CURRENCY], [UNIT_CURRENCY]
	END
END
