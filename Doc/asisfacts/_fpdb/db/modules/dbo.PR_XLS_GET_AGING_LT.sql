
/*
 * Program ID   : PR_XLS_GET_AGING_LT
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.09.01   FP Pjt.         Create.
 * 
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_AGING_LT] 'UC1'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_AGING_LT]
    @p_apl_code             nvarchar(max)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE		@v_apl_code			NVARCHAR(MAX)

	declare		@v_company_id		nvarchar(50)
	declare		@v_division_id		NVARCHAR(50) 
	declare		@v_site_id			nvarchar(50)
	declare		@v_plant_id			nvarchar(50)
	declare     @v_elec_plant_id	nvarchar(50)

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



		select company_id, division_id, site_id, plant_id, line_id, item_id, sum(standard_LT) /1440 as LT
		  from [dbo].[SCM_AGING_ITEM_FLOW_M] with(nolock)
		 where 1 = 1
		   and company_id		= @v_company_id
		   and division_id		= @v_division_id
		   and site_id			= @v_site_id
		   and plant_id			= @v_plant_id
		   and default_route	= 'Y'
		group by company_id, division_id, site_id, plant_id, line_id, item_id


		PRINT 'OK'


	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()


	END CATCH


END



