/****************************************************************************************************/
/* Program ID  : [DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP]                                           */
/* Description : Procedure 작성 가이드                                                               */
/* Usage       : Procedure 작성 시 참조하세요!                                                       */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2021.05.13	P.C.I		 [PJ20209642R] Chempion 환율 적용(GSCM에서 관리중인 환율만 조회 Currency = 'KRW', Unit_Currency IN ( 'RMB', 'USD', 'EUR', 'JPY', 'AUD' ))*/
/* 2022.10.24	ROSIA27				[C20221024-000510]DM UI 소스 정리 요청							*/
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP]    
    @p_division_id              NVARCHAR(30),	
	@p_from_yyyymmdd            NVARCHAR(8),
	@p_to_yyyymmdd             NVARCHAR(8),
	@p_created_by              NVARCHAR(MAX)
 
AS  
  -- DM0020_GET_SCM_MST_FUTURE_PRICE '', '', '', '', '', ''
BEGIN
  SET NOCOUNT ON;

  SELECT 
      DIVISION_ID
	  ,[CURRENCY]
      ,[UNIT_CURRENCY]
	  ,[CURRENCY] + '/' + [UNIT_CURRENCY] AS CURRENCY_UNITCURRENCY
  FROM [dbo].[DM_MST_EXCHANGE_RATE] (NOLOCK)
  WHERE 
  (YYYYMMDD >= @p_from_yyyymmdd and YYYYMMDD <= @p_to_yyyymmdd)
  AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   		 ELSE DIVISION_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_division_id,',') as P Where 
					(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE DIVISION_ID END) = P.data
	               )
	--[PJ20209642R] Chempion 환율 적용(GSCM에서 관리중인 환율만 조회 Currency = 'KRW', Unit_Currency IN ( 'RMB', 'USD', 'EUR', 'JPY', 'AUD' ))
	AND UNIT_CURRENCY IN ( SELECT SEGMENT1
							FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
							WHERE LOOKUP_TYPE = 'DMF0020_CURRENCY'
								AND VALID_YN = 'Y'
						)
	AND CURRENCY = 'KRW'
  GROUP BY DIVISION_ID,[CURRENCY], [UNIT_CURRENCY]
  ORDER BY 1,2,3
END
