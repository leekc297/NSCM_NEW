
/*
 * Program ID   : [SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION]
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge			Description
 *===================================================================================================
 * 2024/12/24   TanVQ1				Create new procedure to get Monthly Input Exception by Item_type and exht_tp_cd
 */

CREATE PROCEDURE [dbo].[SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION] 

	-- Add the parameters for the stored procedure here
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	SELECT  SEGMENT1 ITEM_TYPE,  SEGMENT2 EXHT_TP_CD
	FROM   SCM_ADM_LOOKUP_MASTER_DETAIL SAD
	WHERE  LOOKUP_TYPE = 'SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION' AND VALID_YN = 'Y'
	;

	
END;
