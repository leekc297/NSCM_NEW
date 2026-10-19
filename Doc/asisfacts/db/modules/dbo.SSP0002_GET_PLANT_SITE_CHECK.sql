


/*
 * Program ID   : SSP0022_GET_PLANT_SITE_CHECK
 * Description  : PLANT_SITE 체크
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 *  2020-05-22  KIMYONGHO     PLANT_SITE  체크

 ex) 
 */
CREATE PROCEDURE [dbo].[SSP0002_GET_PLANT_SITE_CHECK]
	 @p_from_site			NVARCHAR(MAX)
	,@p_to_site			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



	DECLARE @from_site_cnt		INTEGER = 0; 
	DECLARE @to_site_cnt		INTEGER = 0;

	SET @from_site_cnt = 0;
	SET @to_site_cnt = 0;
	

	-- FROM_SITE PLANT CHECK
	SELECT @from_site_cnt = COUNT(*)
	FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
	WHERE  1 = 1
	AND    A.SITE_TYPE = 'PLANT'
	AND    A.VALID_YN  = 'Y'
	AND    A.SCM_SITE_ID = @p_from_site;

	-- TO_SITE PLANT CHECK
	SELECT @to_site_cnt = COUNT(*)
	FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
	WHERE  1 = 1
	AND    A.SITE_TYPE = 'PLANT'
	AND    A.VALID_YN  = 'Y'
	AND    A.SCM_SITE_ID = @p_to_site;


	IF ((@from_site_cnt + @to_site_cnt)  = 2)   -- FROM, TO 둘다 PLANT이면 법인간 거래
		SELECT 'S' AS RESULT_CODE, '' AS MSG

END


