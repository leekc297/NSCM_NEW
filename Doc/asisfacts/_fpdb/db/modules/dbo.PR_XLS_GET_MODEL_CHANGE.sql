
/*
 * Program ID   : PR_XLS_GET_MODEL_CHANGE
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.10.21   FP Pjt.         Create.
 * 2024.11.16   shineuiho67     --and ACTIVE_FLAG    = 'Y' --2024-11-16 PI요청의거 주석처리(모두 나오도록)
 * 2024.11.17   shineuiho67     OPERATION_ID, LINE_ID, EFF_START_DATE --2024-11-17 ORDER BY 추가
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_MODEL_CHANGE] 'UC1'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_MODEL_CHANGE]
    @p_apl_code             nvarchar(max)  = 'UC1'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	@v_apl_code				NVARCHAR(MAX)
	
	declare	@v_company_id			nvarchar(50)
	declare	@v_division_id			NVARCHAR(50) 
	declare	@v_site_id				nvarchar(50)
	declare	@v_plant_id				nvarchar(50)
	declare @v_elec_plant_id		nvarchar(50)

	set @v_apl_code			= @p_apl_code


	BEGIN TRY	
			
		select @v_company_id		= attribute1
			 , @v_division_id		= attribute2
			 , @v_site_id			= attribute3
			 , @v_plant_id			= attribute4
			 , @v_elec_plant_id		= attribute5
		  from dbo.SCM_SYS_LOOKUP_VALUE with(nolock)
		 where lookup_type_code = 'XLS_PLAN_APL_PLANT'
		   and segment1 = @v_apl_code
		   and active_flag = 'Y'
		
		
		select COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , MODEL_ID
              , LINE_ID
              , OPERATION_ID
              , ITEM_ID
              , PRODUCTION_TYPE
              , ELECTRODE_TYPE
              , VERSION
              , EFF_START_DATE
              , EFF_END_DATE
              , PRIORITY
              , INV_APL_FLAG
              , ACTIVE_FLAG
		  FROM FP_PLAN_MODEL_CHANGE_M WITH(NOLOCK)
	     WHERE 1 = 1
		   AND COMPANY_ID		= @v_company_id	
		   AND DIVISION_ID	= @v_division_id	
		   AND SITE_ID		= @v_site_id		
		   AND PLANT_ID		IN (@v_plant_id, @v_elec_plant_id)
		   --AND OPERATION_ID	IN ('E2000', 'A5000', 'A8000', 'A9000', 'F6000')
		   --and ACTIVE_FLAG    = 'Y' --2024-11-16 PI요청의거 주석처리(모두 나오도록)
         ORDER BY OPERATION_ID, LINE_ID, EFF_START_DATE --2024-11-17 추가
		  

		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()

	END CATCH

END



