
CREATE FUNCTION [dbo].[FN_GET_SSP_IF_STOCK_CHECK_YN]
(
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
  
	DECLARE @v_if_stock_check		INT
	DECLARE @v_if_stock_check_yn	NVARCHAR(1) = 'N'
  
	SELECT @v_if_stock_check = COUNT(*) 
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
	                         FROM XIF_MES_ISS_WAIT_PALLET_R_SN WITH(NOLOCK)
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


	IF @v_if_stock_check = 0
		SET @v_if_stock_check_yn = 'Y' ;

	
	RETURN @v_if_stock_check_yn

END
;
