


/*
 * Program ID   : SSP0002_GET_BOD_VALID_CHECK
 * Description  : Div, From Site, To Site 에 해당되는 BOD(Trans mode, Incoterms) 유효성 체크
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/07/04   ayj            transmode, incoterms validation
 * 2020/09/21   KIMYONGHO	 SSP INCOTERMS 변경 작업

 ex) 
 */

CREATE PROCEDURE [dbo].[SSP0002_GET_BOD_VALID_CHECK]
	 @p_division_id			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_to_site				NVARCHAR(MAX)
	,@p_incoterms			NVARCHAR(MAX)
	,@p_transport_mode		NVARCHAR(MAX)
	,@p_bod_id				NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	SELECT TRANSPORT_MODE 
	FROM  [DBO].[SCP_MST_BOD_N_V] WITH(NOLOCK)
	WHERE  DIVISION_ID		= @p_division_id
	AND    FROM_SITE		= @p_from_site
	AND    TO_SITE			= @p_to_site
	-- 2020/09/21   KIMYONGHO	 SSP INCOTERMS 변경 작업
	--AND	   INCOTERMS		= @p_incoterms
	AND	   SSP_INCOTERMS		= @p_incoterms
	AND	   TRANSPORT_MODE	= @p_transport_mode

	SELECT distinct 
			-- 2020/09/21   KIMYONGHO	 SSP INCOTERMS 변경 작업
			--INCOTERMS
			SSP_INCOTERMS AS INCOTERMS
	FROM	[DBO].[SCP_MST_BOD_N_V] WITH(NOLOCK)
	WHERE	1=1 
	AND		DIVISION_ID = @p_division_id
	AND		FROM_SITE	= @p_from_site
	AND		TO_SITE		= @p_to_site
	-- 2020/09/21   KIMYONGHO	 SSP INCOTERMS 변경 작업
	--AND		INCOTERMS   = @p_incoterms
	AND		SSP_INCOTERMS   = @p_incoterms
	AND		BOD_ID		= @p_bod_id
	AND		BOD_VALID_YN = 'Y'

END


