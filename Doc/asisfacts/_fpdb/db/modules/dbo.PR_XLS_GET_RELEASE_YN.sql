
/*
 * Program ID   : [PR_XLS_GET_RELEASE_YN]
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 
 * 
 * 
 ex) PR_XLS_GET_RELEASE_YN 'UC1-20241006-02'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_RELEASE_YN]
	@p_selected_intg_plan_id			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    DECLARE  @v_selected_intg_plan_id NVARCHAR(MAX)='';

    set @v_selected_intg_plan_id	= @p_selected_intg_plan_id

    BEGIN TRY

	    SELECT 
                COUNT(INTG_PLAN_ID) AS Cnt
        FROM    SCM_FP_PLAN_H WITH(NOLOCK) 
        WHERE   1=1 
        AND     INTG_PLAN_ID    = @v_selected_intg_plan_id
        AND     RELEASE_FLAG    = 'Y';

    END TRY

	BEGIN CATCH
	    PRINT ERROR_MESSAGE()


	END CATCH


END



