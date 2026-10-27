
/*
 * Program ID   : PR_XLS_GET_PLAN_WPP
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.11.27   FP Pjt.         Create.
 * 
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_PLAN_WPP] 'UC1'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_PLAN_WPP]
    @p_apl_code                 nvarchar(max)  = 'UC1'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	DECLARE	@v_apl_code				NVARCHAR(MAX)
	DECLARE @v_yyyymmdd_from		nvarchar(max)
	DECLARE @v_yyyymmdd_to			nvarchar(max)

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


		select x.factory_id
		     , x.top_item_id
			 , x.item_id
			 , x.operation_id
			 , x.line_id
			 , x.electrode_type
			 , x.production_type
			 , Format(x.plan_date, 'yyyy-MM-dd') as plan_date
			 , x.cell_out_qty
		 from FP_DAILY_PRODUCTIOIN_PLAN_H as x with(nolock)
		where x.plan_type = 'WPP'
		  and x.company_id   = @v_company_id	
		  and x.division_id  = @v_division_id	
		  and x.site_id	     = @v_site_id		
		  and x.plant_id     = @v_plant_id
		  and x.plan_date    >= ( SELECT MIN(DT) FROM [TH_UIS_CAL] WITH(NOLOCK) WHERE ISO_YYYYWW = (
								         SELECT ISO_YYYYWW FROM [TH_UIS_CAL] WITH(NOLOCK) WHERE DT = CONVERT(DATE, GETDATE()) )
                                )
		  and x.plan_date	<= getdate() + 365
		  and x.operation_id = 'A9000'
        order by 
		      x.factory_id
		    , x.top_item_id
			, x.item_id
			, x.operation_id
			, x.line_id
			, x.electrode_type
			, x.production_type
			, x.plan_date



		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()


	END CATCH

END



