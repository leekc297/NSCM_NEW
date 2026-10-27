

/*
 * Program ID   : [PR_XLS_OPT_GET_INSTANCE_ID]
 * Description  : 통합플랜아이디에 해당하는 INSTANCE_ID, PLAN_ID 정보를 가져온다.
 * Program History
 *===================================================================================================
 *   Date          In Charge		Description
 *===================================================================================================
 * 2025-09-16  shineuiho7  [PJ2025-50540] SCP/FP 통합 계획 수립을 위한 시뮬레이터Tool 구축 및 UI 개선 : 신규 작성
 * 
 * 
 ex) 
 exec PR_XLS_OPT_GET_INSTANCE_ID 'UC1-20250528-01', 'UC1'     --GM1공장=UC1
 exec PR_XLS_OPT_GET_INSTANCE_ID 'UC2-20250528-01', 'UC2'     --GM2공장=UC2
 
 */

CREATE PROCEDURE [dbo].[PR_XLS_OPT_GET_INSTANCE_ID]
        @p_intg_plan_id        NVARCHAR(MAX)  = 'UC1-20250528-01',
		@p_apl_code             NVARCHAR(MAX)  = 'UC1'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	@v_intg_plan_id			     	NVARCHAR(MAX)
	DECLARE	@v_apl_code	     		     	NVARCHAR(MAX)
	
	set @v_intg_plan_id				    	= @p_intg_plan_id
	set @v_apl_code				         	= @p_apl_code
	
    BEGIN TRY

			   SELECT INTG_PLAN_ID, INSTANCE_ID, PLAN_ID, INSERT_TIME 
				FROM SCM_FP_PLAN_H WITH(NOLOCK)
				WHERE 1=1
				AND INTG_PLAN_ID LIKE 'UC%'
				AND ( (@v_apl_code = 'UC1' and INSTANCE_ID IN ('UC_CELL_A', 'UC_E_PRE_A', 'UC_FORM_A')) or 
				          (@v_apl_code = 'UC2' and INSTANCE_ID IN ('UC_CELL_A2', 'UC_E_PRE_A2', 'UC_FORM_A2'))
						)
				AND INTG_PLAN_ID = @v_intg_plan_id
				ORDER BY INSTANCE_ID;

    END TRY

	BEGIN CATCH
	    PRINT ERROR_MESSAGE()

	END CATCH

END



