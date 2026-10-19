
CREATE FUNCTION [dbo].[FN_GET_SSP_IF_GMES_STOCK_CHECK]
(
  @p_biz_gubun      NVARCHAR(30),  --40:소형, 8X:자동차/ESS, EE:전극
  @p_company_id     NVARCHAR(30),
  @p_yyyymmdd       NVARCHAR(08)

)

RETURNS NVARCHAR(1)
AS
/*
 * Program ID   : FN_GET_SSP_IF_STOCK_CHECK_YN
 * Description  : 법인별 인터페이스 완료 여부   
 *        
 *        
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.10.19   SSP Pjt.       Create.
 */
BEGIN
  
	DECLARE @v_if_stock_check		INT			= 100
	DECLARE @v_if_stock_check_yn	NVARCHAR(1) = 'N'
  
    IF @p_biz_gubun = '8X'
	BEGIN
		SELECT @v_if_stock_check = COUNT(IIF(X.MES_SOURCE_GROUP = '', NULL , 1)) --미설정일 경우 제외 함
		  FROM (
			   SELECT TOKEN AS MES_SOURCE_GROUP
				 FROM SCM_ADM_LOOKUP_MASTER_DETAIL  A WITH(NOLOCK)
					  CROSS APPLY STRING_SPLIT(ATTRIBUTE2, ',')
				WHERE 1 = 1
				  AND A.LOOKUP_TYPE		= 'IF_STOCK_CHECK'
				  AND A.SEGMENT1		= 'PLAN_AUTO'
				  AND A.SEGMENT2		= 'MES_W'
				  AND A.SEGMENT3		= '81_82'
				  AND A.SEGMENT4		= @p_company_id
			   ) AS X
			   LEFT OUTER JOIN (
							   SELECT DISTINCT LEFT(IF_ID, 4) AS MES_SOURCE_GROUP
								 FROM dbo.XIF_MES_WIP_LOT_R_SN WITH(NOLOCK)
								WHERE SUM_DATE = @p_yyyymmdd
								  AND LEFT(IF_ID,4) IN (
													   SELECT TOKEN AS MES_SOURCE_GROUP
														 FROM SCM_ADM_LOOKUP_MASTER_DETAIL  A WITH(NOLOCK)
															  CROSS APPLY STRING_SPLIT(ATTRIBUTE2, ',')
														WHERE 1 = 1
														  AND A.LOOKUP_TYPE	= 'IF_STOCK_CHECK'
														  AND A.SEGMENT1		= 'PLAN_AUTO'
														  AND A.SEGMENT2		= 'MES_W'
														  AND A.SEGMENT3		= '81_82'
														  AND A.SEGMENT4		= @p_company_id
													   )
							   ) AS Y
			ON X.MES_SOURCE_GROUP = Y.MES_SOURCE_GROUP 
		 WHERE Y.MES_SOURCE_GROUP IS NULL  
	 END
	 ELSE IF @p_biz_gubun = '40'
	 BEGIN
		SET @v_if_stock_check = 100
	 END
	 ELSE IF @p_biz_gubun = 'EE'
	 BEGIN
		SELECT @v_if_stock_check = COUNT(IIF(X.MES_SOURCE_GROUP = '', NULL , 1))
		  FROM (
			   SELECT TOKEN AS MES_SOURCE_GROUP
				 FROM SCM_ADM_LOOKUP_MASTER_DETAIL  A WITH(NOLOCK)
					  CROSS APPLY STRING_SPLIT(ATTRIBUTE2, ',')
				WHERE 1 = 1
				  AND A.LOOKUP_TYPE		= 'IF_STOCK_CHECK'
				  AND A.SEGMENT1		= 'PLAN_EE'
				  AND A.SEGMENT2		= 'MES'
				  AND A.SEGMENT3		= 'EE'
				  AND A.SEGMENT4		= @p_company_id
			   ) AS X
			   LEFT OUTER JOIN (
							   SELECT DISTINCT LEFT(IF_ID, 4) AS MES_SOURCE_GROUP
								 FROM dbo.XIF_MES_WIP_LOT_R_SN WITH(NOLOCK)
								WHERE SUM_DATE = @p_yyyymmdd
								  AND LEFT(IF_ID,4) IN (
													   SELECT TOKEN AS MES_SOURCE_GROUP
														 FROM SCM_ADM_LOOKUP_MASTER_DETAIL  A WITH(NOLOCK)
															  CROSS APPLY STRING_SPLIT(ATTRIBUTE2, ',')
														WHERE 1 = 1
														  AND A.LOOKUP_TYPE		= 'IF_STOCK_CHECK'
														  AND A.SEGMENT1		= 'PLAN_EE'
														  AND A.SEGMENT2		= 'MES'
														  AND A.SEGMENT3		= 'EE'
														  AND A.SEGMENT4		= @p_company_id
													   )
							   ) AS Y
			ON X.MES_SOURCE_GROUP = Y.MES_SOURCE_GROUP 
		 WHERE Y.MES_SOURCE_GROUP IS NULL  
	 END
	 ELSE
	 BEGIN
		SET @v_if_stock_check = 100
	 END

	IF @v_if_stock_check = 0
		SET @v_if_stock_check_yn = 'Y' ;

	
	RETURN @v_if_stock_check_yn

END
;
