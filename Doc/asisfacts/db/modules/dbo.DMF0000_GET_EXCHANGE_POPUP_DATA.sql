/****************************************************************************************************/
/* Program ID  : [DMF0000_GET_EXCHANGE_POPUP_DATA]							                        */
/* Description : 사용자 환율 관리 프로그램 (개발기준, Sales Price,Sales Plan,Fcst&Price에서 사용)   */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP 참고 해서 만듬											*/
/* 2025.04.24       dsiol		[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 사용자 환율 관리 프로그램 */
/* EXEC [DMF0000_GET_EXCHANGE_POPUP_DATA] '40','20250401','20260401'						    */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0000_GET_EXCHANGE_POPUP_DATA]
    @p_division_id					NVARCHAR(30),	
	@p_from_yyyymmdd				NVARCHAR(8),
	@p_to_yyyymmdd					NVARCHAR(8)
AS  
  
BEGIN
	SET NOCOUNT ON;
	
		DECLARE @COLUMNS	    NVARCHAR(MAX)
		SET @COLUMNS = ''
		SELECT @COLUMNS = @COLUMNS + '[' + YYYYMMDD + '],' FROM 
		(
			SELECT 
			DISTINCT 'D' + [YYYYMMDD] AS [YYYYMMDD]
			FROM [dbo].[DM_MST_EXCHANGE_RATE] WITH(NOLOCK)
			WHERE
				(YYYYMMDD >= @p_from_yyyymmdd AND YYYYMMDD <= @p_to_yyyymmdd)
			AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   										 ELSE DIVISION_ID			
				END IN (
							SELECT * FROM dbo.UF_FX_String_SplitForIN (@p_division_id,',') AS P WHERE 
							(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE DIVISION_ID END) = P.DATA
						)
		) YYYYMMDD
		ORDER BY [YYYYMMDD] ASC

		SET @COLUMNS = LEFT(@COLUMNS, LEN(@COLUMNS) - 1)
		--SELECT @COLUMNS

		DECLARE @SQL	        NVARCHAR(MAX)
		
		--혹시나 EXRT_TP_CD 컬럼을 다시 추가 하면 아래의 동적쿼리를 꼭 수정하세요!!!
		SET @SQL = N'
		SELECT * FROM
		(
		SELECT 
			DIVISION_ID  
			,[CURRENCY]
			,[UNIT_CURRENCY]
			,''D'' + [YYYYMMDD] AS [YYYYMMDD]
			,[EXCHANGE_PRICE]      
			,CONVERT(CHAR(19),FIRST_VALUE(LAST_UPDATE_DATE) OVER (PARTITION BY DIVISION_ID,CURRENCY,UNIT_CURRENCY ORDER BY LAST_UPDATE_DATE DESC),20) AS LAST_UPDATE_DATE
			,FIRST_VALUE(LAST_UPDATED_BY) OVER (PARTITION BY DIVISION_ID,CURRENCY,UNIT_CURRENCY ORDER BY LAST_UPDATE_DATE DESC) AS LAST_UPDATED_BY
		FROM [dbo].[DM_MST_EXCHANGE_RATE] WITH(NOLOCK)
		WHERE
		(YYYYMMDD >= ''' + @p_from_yyyymmdd + ''' and YYYYMMDD <= ''' + @p_to_yyyymmdd + ''')
		AND CASE WHEN ''' + @p_division_id + ''' = ''ALL'' THEN ''ALL''
		   									ELSE DIVISION_ID			
			END IN (
						SELECT * FROM dbo.UF_FX_String_SplitForIN (''' + @p_division_id + ''','','') AS P WHERE 
						(CASE WHEN ''' + @p_division_id + ''' = ''ALL'' THEN ''ALL'' ELSE DIVISION_ID END) = P.DATA
				   )
		AND UNIT_CURRENCY IN ( SELECT SEGMENT1
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
								WHERE LOOKUP_TYPE = ''CURRENCY_LIST'' --CURRENCY_LIST에 있는 데이터만 가져 온다.
									AND VALID_YN = ''Y''
							)
		AND CURRENCY = ''KRW''
		)A
		PIVOT ( SUM(EXCHANGE_PRICE) FOR YYYYMMDD IN (' + @COLUMNS + ') ) AS PIVOT_RESULT
		ORDER BY DIVISION_ID,[CURRENCY],[UNIT_CURRENCY]
		'

		EXEC(@SQL)
END
