


/*
 * Program ID   : SSP0022_GET_BOD_ITEM_VALID_CHECK
 * Description  : BOD ITEM 유효성 체크
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 *  2020-04-16  KIMYONGHO      BOD ITEM 유효성 체크

 ex) 
 */
CREATE PROCEDURE [dbo].[SSP0022_GET_BOD_ITEM_VALID_CHECK]
	 @p_division_id			NVARCHAR(MAX)
	,@p_bod_id				NVARCHAR(MAX)
	,@p_to_site				NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	
	
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	

	IF @p_bod_id = '-'
		SET @p_bod_id = '';

	SELECT *
	FROM SCP_MST_BOD_ITEM X
	JOIN SCP_MST_BOD_N_V V
		ON V.DIVISION_ID = X.DIVISION_ID
		AND V.BOD_ID = X.BOD_ID
	WHERE X.DIVISION_ID = @p_division_id
	AND X.VALID_YN ='Y'
	AND X.BOD_ID IN (SELECT BOD_ID 
				  FROM SCP_MST_BOD_N_V
				  --FROM [10.34.220.88,7433].[LGCE_SCMDEV].[DBO].[SCP_MST_BOD_N_V] 
				  WHERE DIVISION_ID = @p_division_id
				  AND VALID_YN = 'Y'
				  AND FROM_SITE   IN(SELECT SEGMENT3
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)	
								WHERE L.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
								AND L.SEGMENT2 = @p_division_id
								AND L.ATTRIBUTE1 =@p_to_site)
				  AND TO_SITE   IN(SELECT ATTRIBUTE1
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)	
								WHERE L.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
								AND L.SEGMENT2 = @p_division_id
								AND L.ATTRIBUTE1 =@p_to_site)
				  AND BOD_ID  LIKE '%' + @p_bod_id +'%'
				)
	AND (X.ITEM_ID LIKE '%' + @p_item_id + '%' )

END


