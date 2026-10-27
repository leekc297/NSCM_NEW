
/*
 * Program ID   : PR_XLS_GET_DP_MODEL_SITE
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.11.01   FP Pjt.         Create.
 * 
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_DP_MODEL_SITE] 'UC1'
 */

create PROCEDURE [dbo].[PR_XLS_GET_DP_MODEL_SITE]
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

	declare @v_version_no           nvarchar(50)


	if object_id('tempdb..#DP_MF_W') is not null
		drop table #DP_MF_W


	create table #DP_MF_W (
	          TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
            , ITEM_ID                   nvarchar(50) 
			, TO_SITE                   nvarchar(50)
			)
			;

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

		select top 1 
		       @v_version_no = version_no
		  from [dbo].[SY_DM_MST_VERSION] with(nolock)
		 where 1 = 1 
		   and division_id = @v_division_id
		   and version_type = 'MF_W'
		 order by version_no desc 


        insert into #DP_MF_W (item_id, TO_SITE)
        select x.ITEM_ID
			 , x.SCM_SITE_ID as TO_SITE
          from SY_DM_PLN_MKT_FCST_C as x with(nolock)
               join dbo.SCM_SYS_LOOKUP_VALUE as y with(nolock)
            ON Y.LOOKUP_TYPE_CODE		= 'XLS_SSP_PLAN_BOD'
           AND X.DIVISION_ID			= Y.SEGMENT1
           AND X.PLANT_SITE_ID			= Y.SEGMENT2
           AND X.SCM_SITE_ID			= Y.SEGMENT3
         where x.DIVISION_ID			= @v_division_id
           and x.VERSION_NO     	    = @v_version_no
           and x.cutoff_type			= 'MF_W'
          and x.MEASURE					= 'MKT_FCST'
		   and x.PLANT_SITE_ID          like @v_plant_id + '%'
         group by 
               x.ITEM_ID
			 , x.SCM_SITE_ID


        select *
		  from #DP_MF_W


		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()


	END CATCH

	if object_id('tempdb..#DP_MF_W') is not null
		drop table #DP_MF_W

END



