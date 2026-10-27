
/*
 * Program ID   : PR_XLS_GET_SHIP_REQ
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.10.01   FP Pjt.         Create.
 * 
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_SHIP_REQ] 'UC1'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_SHIP_REQ]
    @p_apl_code                 nvarchar(max)  = 'UC1'
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


		SELECT 
		       --FS.COMPANY_ID
		--	 , X.[DIVISION_ID]
		--	 , FS.PLANT_ID
		--	 , X.[PROJECT_CODE]
			   X.[SCM_SITE_ID] AS TO_SITE
			 , X.[ITEM_ID] AS MODEL_ID
			 , Z.NICK_NAME
			 --, X.[FCST_TYPE]
			 --, X.[INCOTERMS]
			 --, X.[TRANSPORT_MODE]
			 --, X.[BOD_ID]
			 --, X.[PLANT_SITE_ID] AS FROM_SITE
			 --, X.[SITE_TYPE]
			 , FORMAT(convert(datetime, X.[YYYYMMDD]), 'yyyy-MM-dd') as yyyymmdd
			 , X.[QTY]
			 --, X.LAST_UPDATED_BY AS UPDATE_ID
			 --, X.LAST_UPDATE_DATE AS UPDATE_TIME
		  FROM [DBO].[SY_DM_PLN_SHIPMENT_REQ] AS X WITH(NOLOCK)
			   JOIN [DBO].[SCM_SYS_LOOKUP_VALUE] AS Y WITH(NOLOCK)
			ON Y.LOOKUP_TYPE_CODE		= 'XLS_SSP_PLAN_BOD'
		   AND X.DIVISION_ID			= Y.SEGMENT1
		   AND X.[PLANT_SITE_ID]		= Y.SEGMENT2
		   AND X.[SCM_SITE_ID]			= Y.SEGMENT3
		   AND X.BOD_ID					= Y.ATTRIBUTE1
			   JOIN SY_SCM_MST_SITE AS FS WITH(NOLOCK) 
			ON X.DIVISION_ID			= FS.DIVISION_ID 
		   AND X.[PLANT_SITE_ID]		= FS.SCM_SITE_ID
		       JOIN SCM_ITEM_M as Z with(nolock)
			ON FS.COMPANY_ID			= Z.company_id
		   AND X.DIVISION_ID			= Z.DIVISION_ID
		   AND Z.SITE_ID				= @v_site_id
		   AND X.ITEM_ID				= Z.ITEM_ID
		 WHERE 1 = 1
		   AND X.SITE_TYPE = 'SALES'
		   AND X.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(DBO.[SY_FN_GET_ANL_SHIP_FROZEN_DAY_CNT]('SSP', X.[DIVISION_ID], X.[PLANT_SITE_ID], CONVERT(NVARCHAR, GETDATE(), 112)) , 10) , GETDATE()), 112)
		   AND X.YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DAY, 370 , GETDATE()), 112)
		   AND X.[DIVISION_ID]			= @v_division_id
		   AND FS.PLANT_ID				= @v_plant_id

		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()


	END CATCH

END


