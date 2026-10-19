
/*
 * Program ID   : DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE
 * Description  : 두 개의 연월 사이의 연월 반환
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/07/26	ilovu1			Initial Release 사업계획 프로젝트
 */
--select * from dbo.DMF0009_GET_YM_IN_BETWEEN_TWO_YM('202301', '202412') OPTION (MAXRECURSION 1000);
CREATE function [dbo].[DMF0009_GET_YM_IN_BETWEEN_TWO_YM]
(
      @p_start_yyyymm  NVARCHAR(6)
    , @p_end_yyyymm    NVARCHAR(6)
) returns table
as
return
	(
	WITH S(NUM) AS (SELECT 1				  
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
	SELECT NUM
	     , YYYY + MM      YM
	     , YYYY + QQ      YQ
      FROM T
	--OPTION (MAXRECURSION 1000)
	);
