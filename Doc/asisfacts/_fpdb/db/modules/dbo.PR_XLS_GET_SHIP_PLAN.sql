
/*
 * Program ID   : PR_XLS_GET_SHIP_PLAN
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.10.01   FP Pjt.         Create.
 * 
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_SHIP_PLAN] 'UC1'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_SHIP_PLAN]
    @p_apl_code                 nvarchar(max)  = 'UC1'
--,	@p_yyyymmdd_from			NVARCHAR(MAX)
--,	@p_yyyymmdd_to				NVARCHAR(MAX)
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
	set @v_yyyymmdd_from	= Format(convert(datetime, format( getdate(), 'yyyyMM') + '01') -15, 'yyyyMMdd')   --format( getdate(), 'yyyyMM') + '01'
	--set @v_yyyymmdd_to		= format( convert(datetime, @p_yyyymmdd_to), 'yyyyMMdd')


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


		SELECT x.FROM_SITE_COMPANY_ID
		     , x.[DIVISION_ID]
		     , x.FROM_SITE_PLANT_ID 
			 , x.[PROJECT_CODE]
			 , x.TO_SITE AS [SCM_SITE_ID]
			 , x.[ITEM_ID]
			 , x.[FCST_TYPE]
			 , x.[INCOTERMS]
			 , x.[TRANSPORT_MODE]
			 , x.[BOD_ID]
			 , x.FROM_SITE AS [PLANT_SITE_ID]
			 , convert(DATE, x.[YYYYMMDD], 112) as YYYYMMDD
			 , x.[QTY]
		  from SY_SSP_ANL_SHIP_CONFIRM AS x with(nolock)
		       join dbo.SCM_SYS_LOOKUP_VALUE as y with(nolock)
			ON Y.LOOKUP_TYPE_CODE = 'XLS_SSP_PLAN_BOD'
		   AND X.DIVISION_ID	= Y.SEGMENT1
		   AND X.FROM_SITE		= Y.SEGMENT2
		   AND X.TO_SITE		= Y.SEGMENT3
		   AND X.BOD_ID			= Y.ATTRIBUTE1
		       JOIN SY_SCM_MST_SITE AS FS WITH(NOLOCK) 
			ON X.DIVISION_ID	= FS.DIVISION_ID 
		   AND X.FROM_SITE		= FS.SCM_SITE_ID
		 where 1 = 1
		   and x.FROM_SITE_COMPANY_ID	= @v_company_id
		   and x.division_id			= @v_division_id
		   and x.from_site_plant_id		in (@v_plant_id, @v_elec_plant_id)
		   --and x.YYYYMMDD				< CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10) , getdate()), 112)
		   and x.yyyymmdd				>= @v_yyyymmdd_from
		   AND x.change_type			= 'C'



		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()


	END CATCH

END



