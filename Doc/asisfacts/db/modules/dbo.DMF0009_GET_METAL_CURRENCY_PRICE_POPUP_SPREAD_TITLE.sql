

/*
 * Program ID   : DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE
 * Description  : DMF009_MetalCurrencyPricePopUp(Metal & Currency)의 스프레드 칼럼 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/07/26	ilovu1			Initial Release 사업계획 프로젝트
 */
--exec dbo.DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE '202301', '202405';
CREATE PROCEDURE [dbo].[DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE]
      @p_start_yyyymm  NVARCHAR(6)
    , @p_end_yyyymm    NVARCHAR(6)
AS
BEGIN
	;WITH S(NUM) AS (SELECT 1				  
				      UNION ALL  
				     SELECT NUM+1 FROM S WHERE NUM < DATEDIFF(MONTH, @p_start_yyyymm + '01', @p_end_yyyymm + '01') + 1
				    )
        , T AS (SELECT NUM 
		             , FORMAT(DATEADD(MONTH, NUM - 1, @p_start_yyyymm + '01'), 'yyyy') YYYY 
		             , FORMAT(DATEADD(MONTH, NUM - 1, @p_start_yyyymm + '01'), 'yy')   YY
					 , FORMAT(DATEADD(MONTH, NUM - 1, @p_start_yyyymm + '01'), 'MM')   MM
					 , CASE 
							WHEN FORMAT(DATEADD(MONTH, NUM - 1, @p_start_yyyymm + '01'), 'MM') BETWEEN '01' AND '03' THEN '1Q'							
							WHEN FORMAT(DATEADD(MONTH, NUM - 1, @p_start_yyyymm + '01'), 'MM') BETWEEN '04' AND '06' THEN '2Q'							
							WHEN FORMAT(DATEADD(MONTH, NUM - 1, @p_start_yyyymm + '01'), 'MM') BETWEEN '07' AND '09' THEN '3Q'							
							WHEN FORMAT(DATEADD(MONTH, NUM - 1, @p_start_yyyymm + '01'), 'MM') BETWEEN '10' AND '12' THEN '4Q'							
					   END QQ
		          FROM S
               )
	SELECT 'C' + YYYY + MM      COLUMN_NAME
	     , YY + QQ              SPAN_NAME
		 , '''' + YY + '.' + MM COL_HEADER
		 , '''' + YY + ' ' + QQ SPAN_HEADER
		 , YYYY + MM		    YYYYMM
      FROM T 
	 ORDER BY NUM 
	OPTION (MAXRECURSION 1000);
END;
